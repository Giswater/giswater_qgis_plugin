"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: latin-1 -*-
import json
import operator
from collections import OrderedDict
from functools import partial

from qgis.PyQt.QtWidgets import QGridLayout, QLabel, QLineEdit, QComboBox, QGroupBox, QSpacerItem, QSizePolicy, QWidget

from ..utils import tools_gw
from ..ui.ui_manager import InfoCatalogUi
from ... import global_vars
from ...lib import tools_qt, tools_log, tools_db


class GwCatalog:

    def __init__(self):
        """ Class to control toolbar 'om_ws' """
        pass


    def api_catalog(self, previous_dialog, widget_name, geom_type, feature_type):

        # Manage if geom_type is gully and set grate
        if geom_type == 'gully':
            geom_type = 'grate'

        form_name = 'upsert_catalog_' + geom_type + ''
        form = f'"formName":"{form_name}", "tabName":"data", "editable":"TRUE"'
        feature = f'"feature_type":"{feature_type}"'
        body = tools_gw.create_body(form, feature)
        sql = f"SELECT gw_fct_getcatalog({body})::text"
        row = tools_db.get_row(sql)
        if not row:
            tools_gw.show_message("NOT ROW FOR: " + sql, 2)
            return

        complet_list = json.loads(row[0], object_pairs_hook=OrderedDict)
        groupBox_1 = QGroupBox("Filter")
        self.filter_form = QGridLayout()

        self.dlg_catalog = InfoCatalogUi()
        tools_gw.load_settings(self.dlg_catalog)
        self.dlg_catalog.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_catalog))
        self.dlg_catalog.btn_accept.clicked.connect(partial(self.fill_geomcat_id, previous_dialog, widget_name))

        main_layout = self.dlg_catalog.widget.findChild(QGridLayout, 'main_layout')
        result = complet_list['body']['data']
        for field in result['fields']:
            label = QLabel()
            label.setObjectName('lbl_' + field['label'])
            label.setText(field['label'].capitalize())
            widget = None
            if field['widgettype'] == 'combo':
                widget = self.add_combobox(self.dlg_catalog, field)
            if field['layoutname'] == 'lyt_data_1':
                self.filter_form.addWidget(label, field['layoutorder'], 0)
                self.filter_form.addWidget(widget, field['layoutorder'], 1)

        groupBox_1.setLayout(self.filter_form)
        main_layout.addWidget(groupBox_1)
        verticalSpacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
        main_layout.addItem(verticalSpacer1)

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

        # Call get_api_catalog first time
        self.get_api_catalog(matcat_id, pnom, dnom, id, feature_type, geom_type)

        # Set Listeners
        matcat_id.currentIndexChanged.connect(
            partial(self.populate_pn_dn, matcat_id, pnom, dnom, feature_type, geom_type))
        pnom.currentIndexChanged.connect(partial(self.get_api_catalog, matcat_id,
                                         pnom, dnom, id, feature_type, geom_type))
        dnom.currentIndexChanged.connect(partial(self.get_api_catalog, matcat_id,
                                         pnom, dnom, id, feature_type, geom_type))

        # Set shortcut keys
        self.dlg_catalog.key_escape.connect(partial(tools_gw.close_dialog, self.dlg_catalog))

        # Open form
        tools_gw.open_dialog(self.dlg_catalog, dlg_name='info_catalog')


    def get_api_catalog(self, matcat_id, pnom, dnom, id, feature_type, geom_type):

        matcat_id_value = tools_qt.get_combo_value(self.dlg_catalog, matcat_id)
        pn_value = tools_qt.get_combo_value(self.dlg_catalog, pnom)
        dn_value = tools_qt.get_combo_value(self.dlg_catalog, dnom)

        form_name = 'upsert_catalog_' + geom_type + ''
        form = f'"formName":"{form_name}", "tabName":"data", "editable":"TRUE"'
        feature = f'"feature_type":"{feature_type}"'
        extras = None
        if tools_gw.get_project_type() == 'ws':
            extras = f'"fields":{{"matcat_id":"{matcat_id_value}", "pnom":"{pn_value}", "dnom":"{dn_value}"}}'
        elif tools_gw.get_project_type() == 'ud':
            extras = f'"fields":{{"matcat_id":"{matcat_id_value}", "shape":"{pn_value}", "geom1":"{dn_value}"}}'

        body = tools_gw.create_body(form=form, feature=feature, extras=extras)
        sql = f"SELECT gw_fct_getcatalog({body})::text"
        row = tools_db.get_row(sql)
        complet_result = json.loads(row[0], object_pairs_hook=OrderedDict)
        if complet_result['status'] == "Failed":
            tools_log.log_warning(complet_result)
            return False
        if complet_result['status'] == "Accepted":
            result = complet_result['body']['data']
            for field in result['fields']:
                if field['columnname'] == 'id':
                    self.fill_combo(id, field)


    def populate_pn_dn(self, matcat_id, pnom, dnom, feature_type, geom_type):

        matcat_id_value = tools_qt.get_combo_value(self.dlg_catalog, matcat_id)

        form_name = f'upsert_catalog_' + geom_type + ''
        form = f'"formName":"{form_name}", "tabName":"data", "editable":"TRUE"'
        feature = f'"feature_type":"{feature_type}"'
        extras = f'"fields":{{"matcat_id":"{matcat_id_value}"}}'
        body = tools_gw.create_body(form=form, feature=feature, extras=extras)
        sql = f"SELECT gw_fct_getcatalog({body})::text"
        row = tools_db.get_row(sql)
        complet_list = json.loads(row[0], object_pairs_hook=OrderedDict)
        result = complet_list['body']['data']
        for field in result['fields']:
            if field['columnname'] == 'pnom':
                self.fill_combo(pnom, field)
            elif field['columnname'] == 'dnom':
                self.fill_combo(dnom, field)
            elif field['columnname'] == 'shape':
                self.fill_combo(pnom, field)
            elif field['columnname'] == 'geom1':
                self.fill_combo(dnom, field)


    def get_event_combo_parent(self, fields, row, geom_type):

        if fields == 'fields':
            for field in row["fields"]:
                if field['isparent'] is True:
                    widget = self.dlg_catalog.findChild(QComboBox, field['columnname'])
                    widget.currentIndexChanged.connect(partial(tools_gw.fill_child, self.dlg_catalog, widget, 'catalog', geom_type))
                    widget.currentIndexChanged.connect(partial(self.populate_catalog_id, geom_type))


    def populate_catalog_id(self, geom_type):

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
            sql = f"SELECT gw_api_get_catalog_id('{metcat_value}', '{pn_value}', '{dn_value}', '{geom_type}', 9)"
            row = tools_db.get_row(sql)
            self.fill_combo(widget_id, row[0]['catalog_id'][0])


    def add_combobox(self, dialog, field):

        widget = QComboBox()
        widget.setObjectName(field['columnname'])
        widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Preferred)
        self.fill_combo(widget, field)
        if 'selectedId' in field:
            tools_qt.set_combo_value(widget, field['selectedId'], 0)

        return widget


    def fill_combo(self, widget, field):

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


    def fill_geomcat_id(self, previous_dialog, widget_name):

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
            tools_gw.show_message(message, 2, parameter=str(widget_name))

        tools_gw.close_dialog(self.dlg_catalog)

