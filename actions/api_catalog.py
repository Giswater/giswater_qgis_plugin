"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: latin-1 -*-

import json
import sys
# import config
from functools import partial

import operator
from PyQt4.QtCore import QDate
from PyQt4.QtGui import QComboBox, QCheckBox, QDateEdit, QDoubleSpinBox, QGroupBox, QHBoxLayout, QFormLayout, \
    QSpacerItem, QSizePolicy, QIntValidator, QDoubleValidator, QLineEdit
from PyQt4.QtGui import QGridLayout, QCompleter
from PyQt4.QtGui import QLabel
from PyQt4.QtGui import QLineEdit
from qgis.gui import QgsMessageBar, QgsMapCanvasSnapper, QgsMapToolEmitPoint,  QgsDateTimeEdit
import utils_giswater
from actions.api_parent import ApiParent
from parent import ParentAction

from ui_manager import ApiCatalogUi

from PyQt4 import QtCore, QtGui
from PyQt4.QtGui import QTabWidget, QWidget, QVBoxLayout
from datetime import datetime

class ApiCatalog(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'om_ws' """
        ApiParent.__init__(self, iface, settings, controller, plugin_dir)

    def set_project_type(self, project_type):
        self.project_type = project_type

    def api_catalog(self):
        sql = ("SELECT " + self.schema_name + ".gw_api_get_catalog('upsert_catalog','','','',9)")
        row = self.controller.get_row(sql, log_sql=True)
        groupBox_1 = QGroupBox("Filter")
        self.filter_form = QGridLayout()


        self.dlg_catalog = ApiCatalogUi()
        self.load_settings(self.dlg_catalog)
        self.dlg_catalog.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_catalog))
        # self.dlg_catalog.btn_accept.clicked.connect(partial(self.update_values))

        main_layout = self.dlg_catalog.widget.findChild(QGridLayout, 'main_layout')
        self.controller.log_info(str(row))
        result = row[0]['editData']
        self.controller.log_info(str(result))
        # if 'fields' not in result:
        #     return

        for field in result['fields']:
            if field['widgettype'] == 2:
                widget = self.add_combobox(self.dlg_catalog, field)
                # widget = self.set_auto_update_combobox(field, self.dlg_catalog, widget)
            # elif field['widgettype'] == 11:
            #     widget = Line()
            #     widget.setObjectName(field['column_id'])
            #     widget.setOrientation(QtCore.Qt.Horizontal)
            #     return widget
            if field['layout_id'] == 1:
                self.filter_form.addWidget(widget, field['layout_order'],0)

        groupBox_1.setLayout(self.filter_form)
        main_layout.addWidget(groupBox_1)
        verticalSpacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
        main_layout.addItem(verticalSpacer1)

        # Event on change from combo parent
        self.get_event_combo_parent('fields', result)

        # Open form
        self.dlg_catalog.show()

    def get_event_combo_parent(self, fields, row):
        if fields == 'fields':
            for field in row["fields"]:
                if field['dv_isparent']:
                    widget = self.dlg_catalog.findChild(QComboBox, field['column_id'])
                    widget.currentIndexChanged.connect(partial(self.fill_child, widget))

    def fill_child(self, widget):
        combo_parent = widget.objectName()
        combo_id = utils_giswater.get_item_data(self.dlg_catalog, widget)

        sql = ("SELECT " + self.schema_name + ".gw_api_get_combochilds('catalog" + "' ,'' ,'' ,'" + str(combo_parent) + "', '" + str(combo_id) + "')")
        row = self.controller.get_row(sql, log_sql=True)

        for combo_child in row[0]['fields']:
            if combo_child is not None:
                self.populate_child(combo_child, row)

    def populate_child(self, combo_child, result):
        child = self.dlg_catalog.findChild(QComboBox, str(combo_child['childName']))
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
        self.populate_combo(widget, field)
        if 'selectedId' in field:
            utils_giswater.set_combo_itemData(widget, field['selectedId'], 0)
        # widget.currentIndexChanged.connect(partial(self.get_values, dialog, widget, self.my_json))
        return widget

    def populate_combo(self, widget, field):
        # Generate list of items to add into combo
        widget.blockSignals(True)
        widget.clear()
        widget.blockSignals(False)
        combolist = []
        if 'comboIds' in field:
            for i in range(0, len(field['comboIds'])):
                elem = [field['comboIds'][i], field['comboNames'][i]]
                combolist.append(elem)
            records_sorted = sorted(combolist, key=operator.itemgetter(1))
            # Populate combo
            for record in records_sorted:
                widget.addItem(record[1], record)
        if 'value' in field:
            if str(field['value']) != 'None':
                utils_giswater.set_combo_itemData(widget, field['value'], 0)

    def get_values(self, dialog, widget, _json=None):
        value = None
        if type(widget) is QLineEdit and not widget.isReadOnly():
            value = utils_giswater.getWidgetText(dialog, widget, return_string_null=False)
        elif type(widget) is QComboBox and widget.isEnabled():
            value = utils_giswater.get_item_data(dialog, widget, 0)
        elif type(widget) is QCheckBox and widget.isEnabled():
            value = utils_giswater.isChecked(dialog, widget)
        elif type(widget) is QgsDateTimeEdit and widget.isEnabled():
            value = utils_giswater.getCalendarDate(dialog, widget)

        # Only get values if layer is editable
        if self.layer.isEditable():
            # If widget.isEditable(False) return None, here control it.
            if str(value) == '':
                _json[str(widget.objectName())] = None
            else:
                _json[str(widget.objectName())] = str(value)
        self.controller.log_info(str(_json))