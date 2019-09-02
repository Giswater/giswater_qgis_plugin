"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: latin-1 -*-
from qgis.PyQt.QtWidgets import QGridLayout, QLabel, QLineEdit, QComboBox, QGroupBox, QSpacerItem, QSizePolicy, QWidget

import json
import operator
from functools import partial
from collections import OrderedDict

from .. import utils_giswater
from .api_parent import ApiParent
from ..ui_manager import ApiCatalogUi


class ApiCatalog(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'om_ws' """

        ApiParent.__init__(self, iface, settings, controller, plugin_dir)


    def set_project_type(self, project_type):

        self.project_type = project_type


    def api_catalog(self, previous_dialog, widget_name, geom_type, feature_type):

        form_name = 'upsert_catalog_' + geom_type + ''
        form = f'"formName":"{form_name}", "tabName":"data", "editable":"TRUE"'
        feature = f'"feature_type":"{feature_type}"'
        body = self.create_body(form, feature)
        sql = f"SELECT gw_api_getcatalog($${{{body}}}$$)::text"
        row = self.controller.get_row(sql, log_sql=True, commit=True)
        if not row:
            self.controller.show_message("NOT ROW FOR: " + sql, 2)
            return

        complet_list = [json.loads(row[0], object_pairs_hook=OrderedDict)]
        groupBox_1 = QGroupBox("Filter")
        self.filter_form = QGridLayout()

        self.dlg_catalog = ApiCatalogUi()
        self.load_settings(self.dlg_catalog)
        self.dlg_catalog.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_catalog))
        self.dlg_catalog.btn_accept.clicked.connect(partial(self.fill_geomcat_id, previous_dialog, widget_name))

        main_layout = self.dlg_catalog.widget.findChild(QGridLayout, 'main_layout')
        result = complet_list[0]['body']['data']
        for field in result['fields']:
            label = QLabel()
            label.setObjectName('lbl_' + field['label'])
            label.setText(field['label'].capitalize())
            if field['widgettype'] == 'combo':
                widget = self.add_combobox(self.dlg_catalog, field)
            if field['layout_id'] == 1:
                self.filter_form.addWidget(label, field['layout_order'], 0)
                self.filter_form.addWidget(widget, field['layout_order'], 1)

        groupBox_1.setLayout(self.filter_form)
        main_layout.addWidget(groupBox_1)
        verticalSpacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
        main_layout.addItem(verticalSpacer1)

        matcat_id = self.dlg_catalog.findChild(QComboBox, 'matcat_id')

        if self.controller.get_project_type() == 'ws':
            pnom = self.dlg_catalog.findChild(QComboBox, 'pnom')
            dnom = self.dlg_catalog.findChild(QComboBox, 'dnom')
        elif self.controller.get_project_type() == 'ud':
            pnom = self.dlg_catalog.findChild(QComboBox, 'shape')
            dnom = self.dlg_catalog.findChild(QComboBox, 'geom1')

        id = self.dlg_catalog.findChild(QComboBox, 'id')

        # Call get_api_catalog first time
        self.get_api_catalog(matcat_id, pnom, dnom, id, feature_type, geom_type)

        # Set Listeners
        matcat_id.currentIndexChanged.connect(partial(self.populate_pn_dn, matcat_id, pnom, dnom, feature_type, geom_type))
        pnom.currentIndexChanged.connect(partial(self.get_api_catalog, matcat_id, pnom, dnom, id, feature_type, geom_type))
        dnom.currentIndexChanged.connect(partial(self.get_api_catalog, matcat_id, pnom, dnom, id, feature_type, geom_type))

        # Open form
        self.open_dialog(self.dlg_catalog)


    def get_api_catalog(self, matcat_id, pnom, dnom, id, feature_type, geom_type):

        matcat_id_value = utils_giswater.get_item_data(self.dlg_catalog, matcat_id)
        pn_value = utils_giswater.get_item_data(self.dlg_catalog, pnom)
        dn_value = utils_giswater.get_item_data(self.dlg_catalog, dnom)

        form_name = 'upsert_catalog_' + geom_type + ''
        form = f'"formName":"{form_name}", "tabName":"data", "editable":"TRUE"'
        feature = f'"feature_type":"{feature_type}"'
        if self.controller.get_project_type() == 'ws':
            extras = f'"fields":{{"matcat_id":"{matcat_id_value}", "pnom":"{pn_value}", "dnom":"{dn_value}"}}'
        elif self.controller.get_project_type() == 'ud':
            extras = f'"fields":{{"matcat_id":"{matcat_id_value}", "shape":"{pn_value}", "geom1":"{dn_value}"}}'

        body = self.create_body(form=form, feature=feature, extras=extras)
        sql = f"SELECT gw_api_getcatalog($${{{body}}}$$)::text"
        row = self.controller.get_row(sql, log_sql=True)
        complet_list = [json.loads(row[0], object_pairs_hook=OrderedDict)]
        result = complet_list[0]['body']['data']
        for field in result['fields']:
            if field['column_id'] == 'id':
                self.populate_combo(id,field)


    def populate_pn_dn(self, matcat_id, pnom, dnom, feature_type, geom_type):

        matcat_id_value = utils_giswater.get_item_data(self.dlg_catalog, matcat_id)

        form_name = f'upsert_catalog_' + geom_type + ''
        form = f'"formName":"{form_name}", "tabName":"data", "editable":"TRUE"'
        feature = f'"feature_type":"{feature_type}"'
        extras = f'"fields":{{"matcat_id":"{matcat_id_value}"}}'
        body = self.create_body(form=form, feature=feature, extras=extras)
        sql = f"SELECT gw_api_getcatalog($${{{body}}}$$)::text"
        row = self.controller.get_row(sql, log_sql=True)
        complet_list = [json.loads(row[0], object_pairs_hook=OrderedDict)]
        result = complet_list[0]['body']['data']
        for field in result['fields']:
            if field['column_id'] == 'pnom':
                self.populate_combo(pnom,field)
            elif field['column_id'] == 'dnom':
                self.populate_combo(dnom,field)
            elif field['column_id'] == 'shape':
                self.populate_combo(pnom, field)
            elif field['column_id'] == 'geom1':
                self.populate_combo(dnom,field)

    def get_event_combo_parent(self, fields, row, geom_type):

        if fields == 'fields':
            for field in row["fields"]:
                if field['isparent'] is True:
                    widget = self.dlg_catalog.findChild(QComboBox, field['column_id'])
                    widget.currentIndexChanged.connect(partial(self.fill_child, widget, geom_type))
                    widget.currentIndexChanged.connect(partial(self.populate_catalog_id, geom_type))


    def fill_child(self, widget, geom_type):

        combo_parent = widget.objectName()
        combo_id = utils_giswater.get_item_data(self.dlg_catalog, widget)
        # TODO cambiar por gw_api_getchilds
        sql = f"SELECT gw_api_get_combochilds('catalog' ,'' ,'' ,'{combo_parent}', '{combo_id}','{geom_type}')"
        row = self.controller.get_row(sql, log_sql=True)
        for combo_child in row[0]['fields']:
            if combo_child is not None:
                self.populate_child(combo_child, row)


    def populate_catalog_id(self, geom_type):

        # Get widgets
        widget_metcat_id = self.dlg_catalog.findChild(QComboBox, 'matcat_id')
        widget_pn = self.dlg_catalog.findChild(QComboBox, 'pnom')
        widget_dn = self.dlg_catalog.findChild(QComboBox, 'dnom')
        widget_id = self.dlg_catalog.findChild(QComboBox, 'id')

        # Get values from combo parents
        metcat_value = utils_giswater.getWidgetText(self.dlg_catalog, widget_metcat_id)
        pn_value = utils_giswater.getWidgetText(self.dlg_catalog, widget_pn)
        dn_value = utils_giswater.getWidgetText(self.dlg_catalog, widget_dn)

        sql = f"SELECT gw_api_get_catalog_id('{metcat_value}','{pn_value}','{dn_value}','{geom_type}',9)"
        row = self.controller.get_row(sql, log_sql=True)
        self.populate_combo(widget_id, row[0]['catalog_id'][0])


    def populate_child(self, combo_child, result):

        child = self.dlg_catalog.findChild(QComboBox, str(combo_child['widgetname']))
        if child:
            self.populate_combo(child, combo_child)


    def close_dialog(self, dlg=None):
        """ Close dialog """
        try:
            self.save_settings(dlg)
            dlg.close()

        except AttributeError:
            pass


    def add_combobox(self, dialog, field):

        widget = QComboBox()
        widget.setObjectName(field['column_id'])
        widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Preferred)
        self.populate_combo(widget, field)
        if 'selectedId' in field:
            utils_giswater.set_combo_itemData(widget, field['selectedId'], 0)

        return widget


    def populate_combo(self, widget, field):

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
            for record in records_sorted:
                widget.addItem(str(record[1]), record)
        if 'selectedId' in field:
            if str(field['selectedId']) != 'None':
                utils_giswater.set_combo_itemData(widget, field['selectedId'], 0)


    def fill_geomcat_id(self, previous_dialog, widget_name):

        widget_id = self.dlg_catalog.findChild(QComboBox, 'id')
        catalog_id = utils_giswater.getWidgetText(self.dlg_catalog, widget_id)

        widget = previous_dialog.findChild(QWidget, widget_name)

        if type(widget) is QLineEdit:
            widget.setText(catalog_id)
            widget.setFocus()
        elif type(widget) is QComboBox:
            utils_giswater.setWidgetText(previous_dialog, widget, catalog_id)
            widget.setFocus()
        else:
            msg = ("Widget not found: " + str(widget_name))
            self.controller.show_message(msg, 2)

        self.close_dialog(self.dlg_catalog)

