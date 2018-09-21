"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT >= 20000 and Qgis.QGIS_VERSION_INT < 29900:
    from PyQt4.QtCore import Qt
    from PyQt4.QtGui import QSpacerItem, QSizePolicy, QStringListModel, QCompleter
    from PyQt4.QtGui import QWidget, QTabWidget, QGridLayout, QLabel, QLineEdit, QComboBox
else:
    from qgis.PyQt.QtCore import Qt, QStringListModel
    from qgis.PyQt.QtWidgets import QWidget, QTabWidget, QGridLayout, QLabel, QLineEdit, QComboBox, QSizePolicy, QSpacerItem, QCompleter

import operator
from functools import partial

import utils_giswater
from giswater.actions.api_parent import ApiParent
from giswater.ui_manager import ApiSearchUi


class ApiSearch(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class constructor """
        ApiParent.__init__(self, iface, settings, controller, plugin_dir)


    def api_search(self):
        
        # Dialog
        self.dlg_search = ApiSearchUi()
        self.load_settings(self.dlg_search)

        sql = ("SELECT " + self.schema_name + ".gw_fct_getsearch(9,'es')")
        row = self.controller.get_row(sql, log_sql=True)
        if not row:
            self.controller.show_message("NOT ROW FOR: " + sql, 2)
            return
        result = row[0]

        # self.tab_main = QtGui.QTabWidget(self.dlg_SeachPlus)
        # self.tab_main.setGeometry(QtCore.QRect(10, 20, 329, 153))
        # self.tab_main.setObjectName(str(my_json['formTabs']['formName']))


        main_tab = self.dlg_search.findChild(QTabWidget, 'main_tab')
        self.controller.log_info(str(result))
        for tab in result["formTabs"]:
            self.controller.log_info(str("-----------"))


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
                # elif field['widgettype'] == 3:
                #     widget = self.add_checkbox(field)
                # elif field['widgettype'] == 4:
                #     widget = self.add_calendar(field)
                # elif field['widgettype'] == 6:
                #     pass
                # elif field['widgettype'] == 8:
                #     widget = self.add_button(field)


                gridlayout.addWidget(label, x, 0)
                gridlayout.addWidget(widget, x, 1)

                x =x+1

            verticalSpacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
            gridlayout.addItem(verticalSpacer1)
        self.dlg_search.btn_close.clicked.connect(partial(self.close_dialog,self.dlg_search))
        # Open dialog
        self.dlg_search.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_search.show()


    def add_lineedit(self, field):

        widget = QLineEdit()
        widget.setObjectName(field['name'])
        if 'value' in field:
            widget.setText(field['value'])
        if 'iseditable' in field:
            widget.setReadOnly(not field['disable'])
            if not field['iseditable']:
                widget.setStyleSheet("QLineEdit { background: rgb(242, 242, 242);"
                                     " color: rgb(100, 100, 100)}")

        # if str(table_name) == '-1':
        #     return widget

        completer = QCompleter()
        model = QStringListModel()

        widget.textChanged.connect(partial(self.make_list, completer, model, widget))

        return widget


    def make_list(self, completer, model, widget):
        """ Create a list of ids and populate widget (QLineEdit)"""
        
        # # Set SQL
        # my_json = {}
        # index = self.dlg_search.main_tab.currentIndex()
        # my_json['tabName'] = self.dlg_search.main_tab.widget(index).objectName()
        # self.controller.log_info(str(my_json))

        # if 'dv_table' in field:

        index = self.dlg_search.main_tab.currentIndex()
        _list = self.dlg_search.main_tab.widget(index).findChildren(QComboBox)
        combo = _list[0]
        self.controller.log_info(str(combo.objectName()))
        #combo = self.dlg_search.findChild(QComboBox, 'dv_parent_id')
        self.table_name = ""
        if combo:
            self.table_name = utils_giswater.get_item_data(combo, 0)
            self.id_type = utils_giswater.get_item_data(combo, 1) + "_id"
            self.controller.log_info(str("wwwww")+str(self.table_name))
            if not self.table_name:
                return

        else:
            self.table_name = self.dlg_search.main_tab.widget(index).objectName()

        sql = ("SELECT " + self.schema_name + ".gw_api_get_rowslineedit('" + str(self.table_name) + "', '" +
               "" + str(self.id_type) + "', '" + str(utils_giswater.getWidgetText(widget)) + "')")
        row = self.controller.get_rows(sql, log_sql=True)
        result = row[0][0]['data']
        self.controller.log_info(str(result))
        self.list_items = []
        for _id in result:
            self.list_items.append(_id[str(self.id_type)])
        self.set_completer_object(completer, model, widget, self.list_items)


    def add_combobox(self, field):
        
        widget = QComboBox()
        widget.setObjectName(field['name'])
        self.populate_combo(widget, field)
        if 'selectedId' in field:
            utils_giswater.set_combo_itemData(widget, field['selectedId'], 0)
        #widget.currentIndexChanged.connect(partial(self.get_params, widget))
        #widget.removeItem(0)
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

