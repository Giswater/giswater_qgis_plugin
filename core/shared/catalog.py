"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: latin-1 -*-
import operator
from functools import partial

from qgis.PyQt.QtWidgets import QGridLayout, QLabel, QLineEdit, QComboBox, QGroupBox, QSpacerItem, QSizePolicy, QWidget

from ..utils import tools_gw
from ..ui.ui_manager import GwInfoCatalogUi
from ...lib import tools_qt, tools_log, tools_db, tools_qgis


class GwCatalog:

    def __init__(self):
        """ Class to control toolbar 'om_ws' """
        pass


    def open_catalog(self, previous_dialog, widget_name, feature_type, child_type):
        """ Main function of catalog """

        # Manage if feature_type is gully and set grate
        if feature_type == 'gully':
            feature_type = 'grate'

        form_name = 'upsert_catalog_' + feature_type + ''
        form = f'"formName":"{form_name}", "tabName":"data", "editable":"TRUE"'
        feature = f'"feature_type":"{child_type}"'
        body = tools_gw.create_body(form, feature)
        json_result = tools_gw.execute_procedure('gw_fct_getcatalog', body, log_sql=True)
        if json_result is None: return

        group_box_1 = QGroupBox("Filter")
        self.filter_form = QGridLayout()

        self.dlg_catalog = GwInfoCatalogUi()
        tools_gw.load_settings(self.dlg_catalog)
        self.dlg_catalog.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_catalog))
        self.dlg_catalog.btn_accept.clicked.connect(partial(self._fill_geomcat_id, previous_dialog, widget_name))

        main_layout = self.dlg_catalog.widget.findChild(QGridLayout, 'main_layout')
        result = json_result['body']['data']
        for field in result['fields']:
            label = QLabel()
            label.setObjectName('lbl_' + field['label'])
            label.setText(field['label'].capitalize())
            widget = None
            if field['widgettype'] == 'combo':
                widget = self._add_combobox(field)
            if field['layoutname'] == 'lyt_data_1':
                self.filter_form.addWidget(label, field['layoutorder'], 0)
                self.filter_form.addWidget(widget, field['layoutorder'], 1)

        group_box_1.setLayout(self.filter_form)
        main_layout.addWidget(group_box_1)
        vertical_spacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
        main_layout.addItem(vertical_spacer1)

        matcat_id = self.dlg_catalog.findChild(QComboBox, 'matcat_id')

        pnom = None
        dnom = None
        if tools_gw.get_project_type() == 'ws':
            pnom = self.dlg_catalog.findChild(QComboBox, 'pnom')
            dnom = self.dlg_catalog.findChild(QComboBox, 'dnom')
        elif tools_gw.get_project_type() == 'ud':
            pnom = self.dlg_catalog.findChild(QComboBox, 'shape')
            dnom = self.dlg_catalog.findChild(QComboBox, 'geom1')

        id = self.dlg_catalog.findChild(QComboBox, 'id')

        # Call _get_catalog first time
        self._get_catalog(matcat_id, pnom, dnom, id, feature_type, child_type)

        # Set Listeners
        matcat_id.currentIndexChanged.connect(partial(self._populate_pn_dn, matcat_id, pnom, dnom, feature_type, child_type))
        pnom.currentIndexChanged.connect(partial(self._get_catalog, matcat_id,pnom, dnom, id, feature_type, child_type))
        dnom.currentIndexChanged.connect(partial(self._get_catalog, matcat_id, pnom, dnom, id, feature_type, child_type))

        # Set shortcut keys
        self.dlg_catalog.key_escape.connect(partial(tools_gw.close_dialog, self.dlg_catalog))

        # Open form
        tools_gw.open_dialog(self.dlg_catalog, dlg_name='info_catalog')


    # region private functions

    def _get_catalog(self, matcat_id, pnom, dnom, id, feature_type, child_type):
        """ Execute gw_fct_getcatalog """

        matcat_id_value = tools_qt.get_combo_value(self.dlg_catalog, matcat_id)
        pn_value = tools_qt.get_combo_value(self.dlg_catalog, pnom)
        dn_value = tools_qt.get_combo_value(self.dlg_catalog, dnom)

        form_name = 'upsert_catalog_' + feature_type + ''
        form = f'"formName":"{form_name}", "tabName":"data", "editable":"TRUE"'
        feature = f'"feature_type":"{child_type}"'
        extras = None
        if tools_gw.get_project_type() == 'ws':
            extras = f'"fields":{{"matcat_id":"{matcat_id_value}", "pnom":"{pn_value}", "dnom":"{dn_value}"}}'
        elif tools_gw.get_project_type() == 'ud':
            extras = f'"fields":{{"matcat_id":"{matcat_id_value}", "shape":"{pn_value}", "geom1":"{dn_value}"}}'

        body = tools_gw.create_body(form=form, feature=feature, extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_getcatalog', body, log_sql=True)
        if json_result is None: return

        if json_result['status'] == "Failed":
            tools_log.log_warning(json_result)
            return False
        if json_result['status'] == "Accepted":
            result = json_result['body']['data']
            for field in result['fields']:
                if field['columnname'] == 'id':
                    self._fill_combo(id, field)


    def _populate_pn_dn(self, matcat_id, pnom, dnom, feature_type, child_type):
        """ Execute gw_fct_getcatalog and fill combos """

        matcat_id_value = tools_qt.get_combo_value(self.dlg_catalog, matcat_id)

        form_name = f'upsert_catalog_' + feature_type + ''
        form = f'"formName":"{form_name}", "tabName":"data", "editable":"TRUE"'
        feature = f'"feature_type":"{child_type}"'
        extras = f'"fields":{{"matcat_id":"{matcat_id_value}"}}'
        body = tools_gw.create_body(form=form, feature=feature, extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_getcatalog', body, log_sql=True)
        if json_result is None: return

        for field in json_result['body']['data']['fields']:
            if field['columnname'] in ('pnom', 'shape'):
                self._fill_combo(pnom, field)
            elif field['columnname'] in ('dnom', 'geom1'):
                self._fill_combo(dnom, field)


    def _populate_catalog_id(self, feature_type):
        """ Execute gw_api_get_catalog_id and fill combo id """

        # Get widgets
        widget_metcat_id = self.dlg_catalog.findChild(QComboBox, 'matcat_id')
        widget_pn = self.dlg_catalog.findChild(QComboBox, 'pnom')
        widget_dn = self.dlg_catalog.findChild(QComboBox, 'dnom')
        widget_id = self.dlg_catalog.findChild(QComboBox, 'id')

        # Get values from combo parents
        metcat_value = tools_qt.get_text(self.dlg_catalog, widget_metcat_id)
        pn_value = tools_qt.get_text(self.dlg_catalog, widget_pn)
        dn_value = tools_qt.get_text(self.dlg_catalog, widget_dn)

        exists = tools_db.check_function('gw_api_get_catalog_id')
        if exists:
            sql = f"SELECT gw_api_get_catalog_id('{metcat_value}', '{pn_value}', '{dn_value}', '{feature_type}', 9)"
            row = tools_db.get_row(sql)
            self._fill_combo(widget_id, row[0]['catalog_id'][0])
            
    
    def _add_combobox(self, field):
        """ Add QComboBox to dialog """

        widget = QComboBox()
        widget.setObjectName(field['columnname'])
        widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Preferred)
        self._fill_combo(widget, field)
        if 'selectedId' in field:
            tools_qt.set_combo_value(widget, field['selectedId'], 0)

        return widget
    
    
    def _fill_combo(self, widget, field):
        """
        Fill QComboBox
            :param widget: combobox destination (QComboBox)
            :param field: json where find values (Json)
        """

        # Generate list of items to add into combo
        widget.blockSignals(True)
        widget.clear()
        widget.blockSignals(False)
        combolist = []
        if 'comboIds' in field:
            for i in range(0, len(field['comboIds'])):
                if field['comboIds'][i] is not None and field['comboNames'][i] is not None:
                    elem = [field['comboIds'][i], field['comboNames'][i]]
                    combolist.append(elem)
            records_sorted = sorted(combolist, key=operator.itemgetter(1))
            # Populate combo
            if widget.objectName() != 'id':
                records_sorted.insert(0, ['', ''])
            for record in records_sorted:
                widget.addItem(str(record[1]), record)
                
    
    def _fill_geomcat_id(self, previous_dialog, widget_name):
        """ Fill the widget of the previous dialogue """

        widget_id = self.dlg_catalog.findChild(QComboBox, 'id')
        catalog_id = tools_qt.get_text(self.dlg_catalog, widget_id)
        widget = previous_dialog.findChild(QWidget, widget_name)

        if type(widget) is QLineEdit:
            widget.setText(catalog_id)
            widget.setFocus()
        elif type(widget) is QComboBox:
            tools_qt.set_widget_text(previous_dialog, widget, catalog_id)
            widget.setFocus()
        else:
            message = "Widget not found"
            tools_qgis.show_message(message, 2, parameter=str(widget_name))

        tools_gw.close_dialog(self.dlg_catalog)

    # endregion
