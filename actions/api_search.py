"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-

from functools import partial

import operator
import json
import utils_giswater

from qgis.core import QgsRectangle
from PyQt4.QtCore import Qt
from PyQt4.QtGui import QSpacerItem, QSizePolicy, QStringListModel, QCompleter
from PyQt4.QtGui import QWidget, QTabWidget, QGridLayout, QLabel, QLineEdit, QComboBox

from api_parent import ApiParent
from ui_manager import ApiSearchUi


class ApiSearch(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class constructor """
        ApiParent.__init__(self, iface, settings, controller, plugin_dir)
        self.json_search = {}
        self.lbl_visible = False
    def api_search(self):
        # Dialog
        self.dlg_search = ApiSearchUi()
        self.load_settings(self.dlg_search)
        self.dlg_search.lbl_msg.setStyleSheet("QLabel{color:red;}")
        self.dlg_search.lbl_msg.setVisible(False)

        sql = ("SELECT " + self.schema_name + ".gw_fct_getsearch(9,'es')")
        row = self.controller.get_row(sql, log_sql=True)
        if not row:
            self.controller.show_message("NOT ROW FOR: " + sql, 2)
            return
        result = row[0]

        main_tab = self.dlg_search.findChild(QTabWidget, 'main_tab')
        first_tab = None

        for tab in result["formTabs"]:
            self.controller.log_info(str(tab['tabName']))
            if first_tab is None:
                first_tab = tab['tabName']

            tab_widget = QWidget(main_tab)
            tab_widget.setObjectName(tab['tabName'])
            main_tab.addTab(tab_widget, tab['tabLabel'])
            gridlayout = QGridLayout()
            tab_widget.setLayout(gridlayout)
            x = 0
            for field in tab['fields']:
                label = QLabel()
                label.setObjectName('lbl_' + field['label'])
                label.setText(field['label'].capitalize())
                if field['type'] == 'typeahead':
                    widget = self.add_lineedit(field)
                elif field['type'] == 'combo':
                    widget = self.add_combobox(field)

                gridlayout.addWidget(label, x, 0)
                gridlayout.addWidget(widget, x, 1)

                x += 1

            vertical_spacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
            gridlayout.addItem(vertical_spacer1)

        self.dlg_search.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_search))
        # Open dialog
        self.dlg_search.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_search.show()


    def add_lineedit(self, field):
        """ Add widgets QLineEdit type """
        widget = QLineEdit()
        widget.setObjectName(field['name'])
        if 'value' in field:
            widget.setText(field['value'])
        if 'iseditable' in field:
            widget.setReadOnly(not field['disable'])
            if not field['iseditable']:
                widget.setStyleSheet("QLineEdit { background: rgb(242, 242, 242);"
                                     " color: rgb(100, 100, 100)}")
        model = QStringListModel()
        completer = QCompleter()
        completer.highlighted.connect(partial(self.zoom_to_object, completer))

        self.make_list(completer, model, widget)
        widget.textChanged.connect(partial(self.make_list, completer, model, widget))

        return widget


    def zoom_to_object(self, completer):
        # Get text from selected row
        row = completer.popup().currentIndex().row()
        _key = completer.completionModel().index(row, 0).data()

        # Search text into self.result_data
        # (this variable contains all the matching objects in the function "make_list())"
        item = None
        for data in self.result_data['data']:
            if _key == data['display_name']:
                item = data
                break

        # if item is None:
        #     print(__name__)
        #     print(self.__class__.__name__)
        #
        #     return

        if 'sys_id' in item:
            layer = self.controller.get_layer_by_tablename(item['sys_table_id'])
            if layer is None:
                msg = "Layer not found"
                self.controller.show_message(msg, message_level=2, duration=3)
                return
            self.iface.setActiveLayer(layer)
            expr_filter = str(item['sys_idname']) + " = " + str(item['sys_id'])
            (is_valid, expr) = self.check_expression(expr_filter)  # @UnusedVariable
            if not is_valid:
                print("INVALID EXPRESSION at: " + __name__)
                return
            self.select_features_by_expr(layer, expr)
            self.iface.actionZoomToSelected().trigger()
        elif 'id' in item and 'sys_id' not in item:
            polygon = item['st_astext']
            polygon = polygon[9:len(polygon)-2]
            polygon = polygon.split(',')
            x1, y1 = polygon[0].split(' ')
            x3, y3 = polygon[2].split(' ')
            rect = QgsRectangle(float(x1), float(y1), float(x3), float(y3))
            self.canvas.setExtent(rect)
            self.canvas.refresh()

        self.lbl_visible = False
        self.dlg_search.lbl_msg.setVisible(self.lbl_visible)


    def make_list(self, completer, model, widget):
        """ Create a list of ids and populate widget (QLineEdit)"""
        # # Set SQL
        json_search = {}
        index = self.dlg_search.main_tab.currentIndex()
        combo_list = self.dlg_search.main_tab.widget(index).findChildren(QComboBox)
        line_list = self.dlg_search.main_tab.widget(index).findChildren(QLineEdit)
        json_search['tabName'] = self.dlg_search.main_tab.widget(index).objectName()
        if combo_list:
            combo = combo_list[0]
            id = utils_giswater.get_item_data(self.dlg_search, combo, 0)
            name = utils_giswater.get_item_data(self.dlg_search, combo, 1)
            json_search[combo.objectName()] = {}
            _json = {}
            _json['id'] = id
            _json['name'] = name
            json_search[combo.objectName()] = _json

        if line_list:
            line = line_list[0]
            value = utils_giswater.getWidgetText(self.dlg_search, line)
            json_search[line.objectName()] = {}
            _json = {}
            _json['text'] = value
            json_search[line.objectName()] = _json

        json_search = json.dumps(json_search)
        self.controller.log_info(str(json_search))
        sql = ("SELECT " + self.schema_name + ".gw_fct_updatesearch($$" +json_search + "$$)")
        row = self.controller.get_row(sql, log_sql=True)
        self.result_data = row[0]

        if self.result_data['data'] == {} and self.lbl_visible:
            self.dlg_search.lbl_msg.setVisible(True)
        else:
            self.lbl_visible = True
            self.dlg_search.lbl_msg.setVisible(False)

        # Get list of items from returned json from data base and make a list for completer
        display_list = []
        for data in self.result_data['data']:
            display_list.append(data['display_name'])
        self.set_completer_object(completer, model, widget, display_list)



    def add_combobox(self, field):
        widget = QComboBox()
        widget.setObjectName(field['name'])
        self.populate_combo(widget, field)
        if 'selectedId' in field:
            utils_giswater.set_combo_itemData(widget, field['selectedId'], 0)
        return widget

    def get_params(self, widget):
        self.table_name = utils_giswater.get_item_data(widget, 0)
        self.id_type = utils_giswater.get_item_data(widget, 1) +"_id"

    def populate_combo(self, widget, field, allow_blank=True):
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

