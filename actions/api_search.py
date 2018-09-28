"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
import os
import webbrowser
from functools import partial

import operator
import json

import subprocess

import sys
from PyQt4.QtCore import QTimer
from PyQt4.uic.properties import QtGui

import utils_giswater
from PyQt4 import uic
# TODO  Es probable que la libreria QgsPoint en la version 3.x pase a llamarse QgsPointXY
# TODO  Es probable que la libreria QgsMarkerSymbolV2 en la version 3.x pase a llamarse QgsMarkerSymbol
from qgis.core import QgsRectangle, QgsPoint, QgsGeometry, QGis, QgsMarkerSymbolV2
from qgis.gui import QgsVertexMarker, QgsRubberBand
# TODO  Es probable que la libreria QgsTextAnnotationItem en la version 3.x pase a llamarse QgsTextAnnotation y ademas
# TODO  pertenezca a qgis.core (esto segundo no es seguro)
from qgis.gui import QgsTextAnnotationItem
from PyQt4.QtCore import Qt
from PyQt4.QtGui import QWidget, QTabWidget, QGridLayout, QLabel, QLineEdit, QComboBox, QPushButton
from PyQt4.QtGui import QSpacerItem, QSizePolicy, QStringListModel, QCompleter, QTextDocument

from actions.HyperLinkLabel import HyperLinkLabel
from actions.api_cf import ApiCF
from actions.manage_new_psector import ManageNewPsector
from api_parent import ApiParent
from ui_manager import ApiSearchUi, HydroInfo


class ApiSearch(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class constructor """
        ApiParent.__init__(self, iface, settings, controller, plugin_dir)
        self.manage_new_psector = ManageNewPsector(iface, settings, controller, plugin_dir)
        self.iface = iface
        self.json_search = {}
        self.lbl_visible = False
        self.load_config_data()
        if QGis.QGIS_VERSION_INT >= 10900:
            self.rubberBand = QgsRubberBand(self.canvas, QGis.Point)
            self.rubberBand.setColor(Qt.yellow)
            # self.rubberBand.setIcon(QgsRubberBand.IconType.ICON_CIRCLE)
            self.rubberBand.setIconSize(10)
        else:
            self.vMarker = QgsVertexMarker(self.canvas)
            self.vMarker.setIconSize(10)


    def load_config_data(self):
        """ Load configuration data from tables """

        self.params = {}
        sql = ("SELECT parameter, value FROM " + self.controller.schema_name + ".config_param_system"
               " WHERE context = 'searchplus' ORDER BY parameter")
        rows = self.controller.get_rows(sql)
        if not rows:
            message = "Parameters related with 'searchplus' not set in table 'config_param_system'"
            self.controller.log_warning(message)
            return False

        for row in rows:
            self.params[row['parameter']] = str(row['value'])

            # Get scale zoom
        if not 'scale_zoom' in self.params:
            self.scale_zoom = 2500
        else:
            self.scale_zoom = self.params['scale_zoom']

        return True


    def api_search(self):
        # Dialog
        self.dlg_search = ApiSearchUi()
        self.load_settings(self.dlg_search)
        self.dlg_search.lbl_msg.setStyleSheet("QLabel{color:red;}")
        self.dlg_search.lbl_msg.setVisible(False)

        # Make it dockable in left dock widget area
        self.iface.addDockWidget(Qt.LeftDockWidgetArea, self.dlg_search)
        self.dlg_search.setFixedHeight(162)

        sql = ("SELECT " + self.schema_name + ".gw_fct_getsearch(9,'es')")
        row = self.controller.get_row(sql, log_sql=True)
        if not row:
            self.controller.show_message("NOT ROW FOR: " + sql, 2)
            return
        result = row[0]

        main_tab = self.dlg_search.findChild(QTabWidget, 'main_tab')
        first_tab = None

        for tab in result["formTabs"]:
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
                    completer = QCompleter()
                    widget = self.add_lineedit(field, completer)
                elif field['type'] == 'combo':
                    widget = self.add_combobox(field)

                gridlayout.addWidget(label, x, 0)
                gridlayout.addWidget(widget, x, 1)

                x += 1

            vertical_spacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
            gridlayout.addItem(vertical_spacer1)

        # TODO: Save position when destroy dlg

        # Open dialog
        self.dlg_search.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_search.show()


    def add_lineedit(self,  field, completer=None):
        """ Add widgets QLineEdit type """
        widget = QLineEdit()
        widget.setObjectName(field['column_id'])
        if 'value' in field:
            widget.setText(field['value'])

        if 'iseditable' in field:
            widget.setReadOnly(not field['iseditable'])
            if not field['iseditable']:
                widget.setStyleSheet("QLineEdit { background: rgb(242, 242, 242); color: rgb(100, 100, 100)}")
        if completer:
            model = QStringListModel()
            completer.highlighted.connect(partial(self.zoom_to_object, completer))

            self.make_list(completer, model, widget)
            widget.textChanged.connect(partial(self.make_list, completer, model, widget))

        return widget


    def zoom_to_object(self, completer):
        # We look for the index of current tab so we can search by name
        index = self.dlg_search.main_tab.currentIndex()

        # Get all QLineEdit for activate or we cant write when tab have more than 1 QLineEdit
        line_list = self.dlg_search.main_tab.widget(index).findChildren(QLineEdit)
        for line_edit in line_list:
            line_edit.setReadOnly(False)
            line_edit.setStyleSheet("QLineEdit { background: rgb(255, 255, 255); color: rgb(0, 0, 0)}")

        # Get selected row
        row = completer.popup().currentIndex().row()
        if row == -1:
            return
        # Get text from selected row
        _key = completer.completionModel().index(row, 0).data()
        print(_key)
        # Search text into self.result_data
        # (this variable contains all the matching objects in the function "make_list())"
        item = None
        for data in self.result_data['data']:
            print(data)
            if _key == data['display_name']:
                item = data
                break

        # IF for zoom to tab network
        if self.dlg_search.main_tab.widget(index).objectName() == 'network':
            layer = self.controller.get_layer_by_tablename(item['sys_table_id'])
            if layer is None:
                msg = "Layer not found"
                self.controller.show_message(msg, message_level=2, duration=3)
                return

            self.iface.setActiveLayer(layer)
            # TODO revisar esta expresion y el mensage de error que genera en la pestana de postgis del qgis
            # expr_filter = str(item['sys_idname']) + " = " + str(item['sys_id'])
            # (is_valid, expr) = self.check_expression(expr_filter)  # @UnusedVariable
            # if not is_valid:
            #     print("INVALID EXPRESSION at: " + __name__)
            #     return
            # self.select_features_by_expr(layer, expr)
            # self.iface.actionZoomToSelected().trigger()
            self.ApiCF = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir)
            self.ApiCF.open_form(table_name=item['sys_table_id'], feature_type=item['feature_type'], feature_id=item['sys_id'])
        elif self.dlg_search.main_tab.widget(index).objectName() == 'search':
            # TODO
            return
        # IF for zoom to tab address (streets)
        elif self.dlg_search.main_tab.widget(index).objectName() == 'address' and 'id' in item and 'sys_id' not in item:
            polygon = item['st_astext']
            polygon = polygon[9:len(polygon)-2]
            polygon = polygon.split(',')
            x1, y1 = polygon[0].split(' ')
            x2, y2 = polygon[2].split(' ')
            self.zoom_to_rectangle(x1, y1, x2, y2)
        # IF for zoom to tab address (postnumbers)
        elif self.dlg_search.main_tab.widget(index).objectName() == 'address' and 'sys_x' in item and 'sys_y' in item:
            x1 = item['sys_x']
            y1 = item['sys_y']
            self.zoom_to_rectangle(x1, y1, x1, y1)
            point = QgsPoint(float(x1), float(y1))
            self.highlight(point, 2000)
            textItem = QgsTextAnnotationItem(self.iface.mapCanvas())
            document = QTextDocument()
            #document.setHtml("<strong>" + str("TEST") + "</strong></br><p>hola<p/>")
            document.setPlainText("HOLA")
            textItem.setDocument(document)
            # symbol = QgsMarkerSymbolV2()
            # symbol.setSize(9)
            # textItem.setMarkerSymbol(symbol)
            textItem.setMapPosition(point)



            self.canvas.refresh()
        elif self.dlg_search.main_tab.widget(index).objectName() == 'hydro':
            # TODO
            combo_list = self.dlg_search.main_tab.widget(index).findChildren(QComboBox)
            if combo_list:
                combo = combo_list[0]
                expl_name = utils_giswater.get_item_data(self.dlg_search, combo, 1)

            #row = item['display_name'].split(' - ', 2)
            print (item)
            x1 = item['sys_x']
            y1 = item['sys_y']
            print (item)
            self.zoom_to_rectangle(x1, y1, x1, y1)
            point = QgsPoint(float(x1), float(y1))
            self.highlight(point, 2000)
            self.canvas.refresh()
            self.open_hydrometer_dialog(table_name=item['sys_table_id'], feature_type=None, feature_id=item['sys_id'])

        elif self.dlg_search.main_tab.widget(index).objectName() == 'workcat':
            # TODO mantenemos como la 3.1
            return
        elif self.dlg_search.main_tab.widget(index).objectName() == 'psector':
            self.manage_new_psector.new_psector(item['sys_id'], 'plan')
            return
        elif self.dlg_search.main_tab.widget(index).objectName() == 'visit':
            # TODO
            return
        self.lbl_visible = False
        self.dlg_search.lbl_msg.setVisible(self.lbl_visible)

    def zoom_to_rectangle(self, x1, y1, x2, y2):
        rect = QgsRectangle(float(x1), float(y1), float(x2), float(y2))
        self.canvas.setExtent(rect)
        self.canvas.refresh()


    def highlight(self, point, duration_time=None):
        if QGis.QGIS_VERSION_INT >= 10900:
            rb = self.rubberBand
            rb.reset(QGis.Point)
            rb.addPoint(point)
        else:
            self.vMarker = QgsVertexMarker(self.canvas)
            self.vMarker.setIconSize(10)
            self.vMarker.setCenter(point)
            self.vMarker.show()

        # wait to simulate a flashing effect
        if duration_time:
            QTimer.singleShot(duration_time, self.resetRubberbands)

    def resetRubberbands(self):
        canvas = self.canvas
        if QGis.QGIS_VERSION_INT >= 10900:
            self.rubberBand.reset()
        else:
            self.vMarker.hide()
            canvas.scene().removeItem(self.vMarker)


    def make_list(self, completer, model, widget):
        """ Create a list of ids and populate widget (QLineEdit)"""
        # Create 2 json, one for first QLineEdit and other for second QLineEdit
        json_updatesearch = {}
        json_updatesearch_add = {}
        row = None
        index = self.dlg_search.main_tab.currentIndex()
        combo_list = self.dlg_search.main_tab.widget(index).findChildren(QComboBox)
        line_list = self.dlg_search.main_tab.widget(index).findChildren(QLineEdit)
        json_updatesearch['tabName'] = self.dlg_search.main_tab.widget(index).objectName()
        json_updatesearch_add['tabName'] = self.dlg_search.main_tab.widget(index).objectName()
        if combo_list:
            combo = combo_list[0]
            id = utils_giswater.get_item_data(self.dlg_search, combo, 0)
            name = utils_giswater.get_item_data(self.dlg_search, combo, 1)
            json_updatesearch[combo.objectName()] = {}
            _json = {}
            _json['id'] = id
            _json['name'] = name
            json_updatesearch[combo.objectName()] = _json
            json_updatesearch_add[combo.objectName()] = _json

        if line_list:
            # Prepare an aux json because 1 field of main json is another json
            _json = {}
            line_edit = line_list[0]

            # If current tab have more than one QLineEdit, clear second QLineEdit
            if len(line_list) == 2:
                line_edit.textChanged.connect(partial(self.clear_line_edit_add, line_list))

            value = utils_giswater.getWidgetText(self.dlg_search, line_edit)
            json_updatesearch[line_edit.objectName()] = {}
            json_updatesearch_add[line_edit.objectName()] = {}
            _json['text'] = value
            json_updatesearch[line_edit.objectName()] = _json
            json_updatesearch_add[line_edit.objectName()] = _json
            json_updatesearch = json.dumps(json_updatesearch)

            sql = ("SELECT " + self.schema_name + ".gw_fct_updatesearch($$" +json_updatesearch + "$$)")
            row = self.controller.get_row(sql, log_sql=True)
            if row:
                self.result_data = row[0]
        # Set label visible
        if row is not None:
            if self.result_data['data'] == {} and self.lbl_visible:
                self.dlg_search.lbl_msg.setVisible(True)
                if len(line_list) == 2:
                    widget = line_list[1]
                    widget.setReadOnly(True)
                    widget.setStyleSheet("QLineEdit { background: rgb(242, 242, 242); color: rgb(100, 100, 100)}")
            else:
                self.lbl_visible = True
                self.dlg_search.lbl_msg.setVisible(False)

            # Get list of items from returned json from data base and make a list for completer
            display_list = []
            for data in self.result_data['data']:
                display_list.append(data['display_name'])
            self.set_completer_object(completer, model, widget, display_list)

        if len(line_list) == 2:
            _json = {}
            line_edit_add = line_list[1]
            value = utils_giswater.getWidgetText(self.dlg_search, line_edit_add)
            if str(value) == 'null':
                return

            json_updatesearch_add[line_edit_add.objectName()] = {}
            _json['text'] = value
            json_updatesearch_add[line_edit_add.objectName()] = _json
            json_updatesearch_add = json.dumps(json_updatesearch_add)

            sql = ("SELECT " + self.schema_name + ".gw_fct_updatesearch_add($$" + json_updatesearch_add + "$$)")
            row = self.controller.get_row(sql, log_sql=True)
            if row:
                self.result_data = row[0]
                if row is not None:
                    display_list = []
                    for data in self.result_data['data']:
                        display_list.append(data['display_name'])
                    self.set_completer_object(completer, model, line_edit_add, display_list)


    def clear_line_edit_add(self, line_list):
        """ Clear second line edit if exist"""
        line_edit_add = line_list[1]
        line_edit_add.setText('')


    def add_combobox(self, field):
        widget = QComboBox()
        widget.setObjectName(field['column_id'])
        self.populate_combo(widget, field)
        if 'selectedId' in field:
            utils_giswater.set_combo_itemData(widget, field['selectedId'], 0)
        return widget


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


    def open_hydrometer_dialog(self, table_name=None, feature_type=None, feature_id=None):

        self.hydro_info_dlg = HydroInfo()
        self.load_settings(self.hydro_info_dlg)

        self.hydro_info_dlg.btn_close.clicked.connect(partial(self.close_dialog, self.hydro_info_dlg))
        self.hydro_info_dlg.rejected.connect(partial(self.close_dialog, self.hydro_info_dlg))

        sql = ("SELECT " + self.schema_name + ".gw_api_get_infofromid('"+str(table_name)+"', '"+str(feature_id)+"',"
               " null, True, 9, 100)")
        row = self.controller.get_row(sql, log_sql=True)

        if not row:
            self.controller.show_message("NOT ROW FOR: " + sql, 2)
            return
        result = row[0]['editData']
        if 'fields' not in result:
            return
        self.controller.log_info(str(result))
        # Get field id name
        field_id = str(row[0]['idName'])


        grid_layout = self.hydro_info_dlg.findChild(QGridLayout, 'gridLayout')
        for field in result["fields"]:
            label = QLabel()
            label.setObjectName('lbl_' + field['form_label'])
            label.setText(field['form_label'].capitalize())

            if 'tooltip' in field:
                label.setToolTip(field['tooltip'])
            else:
                label.setToolTip(field['form_label'].capitalize())

            if field['widgettype'] == 1 or field['widgettype'] == 10:
                widget = self.add_lineedit(field)
                if widget.objectName() == field_id:
                    self.feature_id = widget.text()
            elif field['widgettype'] == 9:
                widget = self.add_hyperlink(self.hydro_info_dlg, field)

            grid_layout.addWidget(label,  field['layout_order'], 0)
            grid_layout.addWidget(widget, field['layout_order'], 1)

        verticalSpacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
        grid_layout.addItem(verticalSpacer1)

        self.hydro_info_dlg.open()


    def add_hyperlink(self, dialog, field):
        widget = HyperLinkLabel()
        widget.setObjectName(field['column_id'])
        widget.setText(field['value'])
        widget.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
        widget.resize(widget.sizeHint().width(), widget.sizeHint().height())
        function_name = 'no_function_asociated'

        if 'button_function' in field:
            if field['button_function'] is not None:
                function_name = field['button_function']
            else:
                msg = ("parameter button_function is null for button " + widget.objectName())
                self.controller.show_message(msg, 2)
        else:
            msg = "parameter button_function not found"
            self.controller.show_message(msg, 2)

        widget.clicked.connect(partial(getattr(self, function_name), dialog, widget, 2))
        return widget


    def open_url(self, dialog, widget, message_level=None):
        path = widget.text()

        # Check if file exist
        if os.path.exists(path):
            # Open the document
            if sys.platform == "win32":
                os.startfile(path)
            else:
                opener = "open" if sys.platform == "darwin" else "xdg-open"
                subprocess.call([opener, path])
        else:
            webbrowser.open(path)

