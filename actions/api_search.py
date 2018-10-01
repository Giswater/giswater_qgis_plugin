"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
import csv
import json
import operator
import os
import subprocess
import sys
import webbrowser
from functools import partial
import utils_giswater




from PyQt4.QtCore import QTimer
from PyQt4.uic.properties import QtGui


from PyQt4 import uic
# TODO  Es probable que la libreria QgsPoint en la version 3.x pase a llamarse QgsPointXY
# TODO  Es probable que la libreria QgsMarkerSymbolV2 en la version 3.x pase a llamarse QgsMarkerSymbol
from qgis.core import QgsRectangle, QgsPoint, QgsGeometry, QGis, QgsMarkerSymbolV2
from qgis.gui import QgsVertexMarker, QgsRubberBand
# TODO  Es probable que la libreria QgsTextAnnotationItem en la version 3.x pase a llamarse QgsTextAnnotation y ademas
# TODO  pertenezca a qgis.core (esto segundo no es seguro)
from qgis.gui import QgsTextAnnotationItem
from PyQt4.QtCore import Qt
from PyQt4.QtGui import QWidget, QTabWidget, QGridLayout, QLabel, QLineEdit, QComboBox, QTableView, QFileDialog
from PyQt4.QtGui import QSpacerItem, QSizePolicy, QStringListModel, QCompleter, QTextDocument, QAbstractItemView
from PyQt4.QtSql import QSqlTableModel
from actions.HyperLinkLabel import HyperLinkLabel
from actions.api_cf import ApiCF
from actions.manage_new_psector import ManageNewPsector
from api_parent import ApiParent
from ui_manager import ApiSearchUi, HydroInfo, ListItems


class ApiSearch(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class constructor """
        ApiParent.__init__(self, iface, settings, controller, plugin_dir)
        self.manage_new_psector = ManageNewPsector(iface, settings, controller, plugin_dir)
        self.iface = iface
        self.json_search = {}
        self.lbl_visible = False

        if QGis.QGIS_VERSION_INT >= 10900:
            self.rubberBand = QgsRubberBand(self.canvas, QGis.Point)
            self.rubberBand.setColor(Qt.yellow)
            # self.rubberBand.setIcon(QgsRubberBand.IconType.ICON_CIRCLE)
            self.rubberBand.setIconSize(10)
        else:
            self.vMarker = QgsVertexMarker(self.canvas)
            self.vMarker.setIconSize(10)





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

        # Search text into self.result_data
        # (this variable contains all the matching objects in the function "make_list())"
        item = None
        for data in self.result_data['data']:
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
            point = QgsPoint(float(x1), float(y1))
            self.highlight(point, 2000)
            self.zoom_to_rectangle(x1, y1, x1, y1)

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
            x1 = item['sys_x']
            y1 = item['sys_y']
            point = QgsPoint(float(x1), float(y1))
            self.highlight(point, 2000)
            self.zoom_to_rectangle(x1, y1, x1, y1)


            self.open_hydrometer_dialog(table_name=item['sys_table_id'], feature_type=None, feature_id=item['sys_id'])

        elif self.dlg_search.main_tab.widget(index).objectName() == 'workcat':
            # TODO mantenemos como la 3.1

            self.workcat_open_table_items(item)
            return
        elif self.dlg_search.main_tab.widget(index).objectName() == 'psector':
            #TODO de donde sacamos el campo id?
            self.manage_new_psector.new_psector(item['sys_id'], item['sys_table_id'], 'workcat_id')
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

            value = utils_giswater.getWidgetText(self.dlg_search, line_edit, return_string_null=False)
            if str(value) == '':
                return
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

    def workcat_open_table_items(self, item):
        print(item)
        """ Create the view and open the dialog with his content """
        workcat_id = item['sys_id']
        layer_name= item['sys_table_id']
        field_id = item['filter_text']

        if workcat_id is None:
            return False

        self.update_selector_workcat(workcat_id)
        self.force_expl(workcat_id)

        #self.zoom_to_polygon(workcat_id, layer_name, field_id)

        self.items_dialog = ListItems()
        self.load_settings(self.items_dialog)
        self.items_dialog.btn_state1.setEnabled(False)
        self.items_dialog.btn_state0.setEnabled(False)
        utils_giswater.setWidgetText(self.items_dialog, self.items_dialog.txt_path, self.controller.plugin_settings_value('search_csv_path'))

        utils_giswater.setWidgetText(self.items_dialog, self.items_dialog.label_init, "Filter by: "+str(field_id))
        utils_giswater.setWidgetText(self.items_dialog, self.items_dialog.label_end, "Filter by: "+str(field_id))
        #
        self.items_dialog.tbl_psm.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.items_dialog.tbl_psm_end.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.disable_qatable_by_state(self.items_dialog.tbl_psm, 1, self.items_dialog.btn_state1)
        self.disable_qatable_by_state(self.items_dialog.tbl_psm_end, 0, self.items_dialog.btn_state0)

        table_name = "v_ui_workcat_x_feature"
        table_name_end = "v_ui_workcat_x_feature_end"
        self.items_dialog.btn_close.clicked.connect(partial(self.close_dialog, self.items_dialog))
        self.items_dialog.btn_path.clicked.connect(partial(self.get_folder_dialog, self.items_dialog, self.items_dialog.txt_path))
        self.items_dialog.rejected.connect(partial(self.close_dialog, self.items_dialog))
        self.items_dialog.btn_state1.clicked.connect(partial(self.force_state, self.items_dialog.btn_state1, 1, self.items_dialog.tbl_psm))
        self.items_dialog.btn_state0.clicked.connect(partial(self.force_state, self.items_dialog.btn_state0, 0, self.items_dialog.tbl_psm_end))
        self.items_dialog.export_to_csv.clicked.connect(
            partial(self.export_to_csv, self.items_dialog, self.items_dialog.tbl_psm, self.items_dialog.tbl_psm_end,
                    self.items_dialog.txt_path))

        self.items_dialog.txt_name.textChanged.connect(partial
            (self.workcat_filter_by_text, self.items_dialog, self.items_dialog.tbl_psm, self.items_dialog.txt_name, table_name, workcat_id, field_id))
        self.items_dialog.txt_name_end.textChanged.connect(partial
            (self.workcat_filter_by_text, self.items_dialog, self.items_dialog.tbl_psm_end, self.items_dialog.txt_name_end, table_name_end, workcat_id, field_id))
        self.items_dialog.tbl_psm.doubleClicked.connect(partial(self.workcat_zoom, self.items_dialog.tbl_psm))
        self.items_dialog.tbl_psm_end.doubleClicked.connect(partial(self.workcat_zoom, self.items_dialog.tbl_psm_end))

        expr = "workcat_id ILIKE '%" + str(workcat_id) + "%'"
        self.workcat_fill_table(self.items_dialog.tbl_psm, table_name, expr=expr)
        self.set_table_columns(self.items_dialog, self.items_dialog.tbl_psm, table_name)
        expr = "workcat_id ILIKE '%" + str(workcat_id) + "%'"
        self.workcat_fill_table(self.items_dialog.tbl_psm_end, table_name_end, expr=expr)
        self.set_table_columns(self.items_dialog, self.items_dialog.tbl_psm_end, table_name_end)
        #
        # Add data to workcat search form
        table_name = "v_ui_workcat_x_feature"
        table_name_end = "v_ui_workcat_x_feature_end"
        extension = '_end'
        self.fill_label_data(workcat_id, table_name)
        self.fill_label_data(workcat_id, table_name_end, extension)

        self.items_dialog.setWindowFlags(Qt.WindowMaximizeButtonHint | Qt.WindowStaysOnTopHint)
        self.items_dialog.open()


    def force_expl(self,  workcat_id):
        """ Active exploitations are compared with workcat farms.
            If there is consistency nothing happens, if there is no consistency force this exploitations to selector."""

        sql = ("SELECT a.expl_id, a.expl_name FROM "
               "  (SELECT expl_id, expl_name FROM " + self.schema_name + ".v_ui_workcat_x_feature "
               "   WHERE workcat_id='" + str(workcat_id) + "' "
               "   UNION SELECT expl_id, expl_name FROM " + self.schema_name + ".v_ui_workcat_x_feature_end "
               "   WHERE workcat_id='" + str(workcat_id) + "'"
               "   ) AS a "
               " WHERE expl_id NOT IN "
               "  (SELECT expl_id FROM " + self.schema_name + ".selector_expl "
               "   WHERE cur_user=current_user)")
        rows = self.controller.get_rows(sql)

        if len(rows) > 0:
            for row in rows:
                sql = ("INSERT INTO " + self.schema_name + ".selector_expl(expl_id, cur_user) "
                       " VALUES('" + str(row[0]) + "', current_user)")
                self.controller.execute_sql(sql)
            msg = "Your exploitation selector has been updated"
            self.controller.show_warning(msg)

    def update_selector_workcat(self, workcat_id):
        """  Update table selector_workcat """

        sql = ("DELETE FROM " + self.schema_name + ".selector_workcat "
               " WHERE cur_user = current_user;\n")
        sql += ("INSERT INTO " + self.schema_name + ".selector_workcat(workcat_id, cur_user) "
                " VALUES('" + workcat_id + "', current_user);\n")
        self.controller.execute_sql(sql)

    def disable_qatable_by_state(self, qtable, _id, qbutton):

        sql = ("SELECT state_id FROM " + self.schema_name + ".selector_state "
               " WHERE cur_user = current_user AND state_id ='" + str(_id) + "'")
        row = self.controller.get_row(sql)
        if row is None:
            qtable.setEnabled(False)
            qbutton.setEnabled(True)


    def get_folder_dialog(self, dialog, widget):
        """ Get folder dialog """
        if 'nt' in sys.builtin_module_names:
            folder_path = os.path.expanduser("~\Documents")
        else:
            folder_path = os.path.expanduser("~")

        # Open dialog to select folder
        os.chdir(folder_path)
        file_dialog = QFileDialog()
        file_dialog.setFileMode(QFileDialog.Directory)

        msg = "Save as"
        folder_path = file_dialog.getSaveFileName(None, self.controller.tr(msg), folder_path, '*.csv')
        if folder_path:
            utils_giswater.setWidgetText(dialog, widget, str(folder_path))


    def force_state(self, qbutton, state, qtable):
        """ Force selected state and set qtable enabled = True """
        sql = ("SELECT state_id FROM " + self.schema_name + ".selector_state "
               " WHERE cur_user=current_user AND state_id ='" + str(state) + "'")
        row = self.controller.get_row(sql)
        if row is not None:
            return
        sql = ("INSERT INTO " + self.schema_name + ".selector_state(state_id, cur_user) "
               " VALUES('" + str(state) + "', current_user)")
        self.controller.execute_sql(sql)
        qtable.setEnabled(True)
        qbutton.setEnabled(False)
        self.refresh_map_canvas()


    def export_to_csv(self, dialog, qtable_1=None, qtable_2=None, path=None):

        folder_path = utils_giswater.getWidgetText(dialog, path)
        if folder_path is None or folder_path == 'null':
            return
        if folder_path.find('.csv') == -1:
            folder_path += '.csv'
        if qtable_1:
            model_1 = qtable_1.model()
        else:
            return
        if qtable_2:
            model_2 = qtable_2.model()

        # Convert qtable values into list
        all_rows = []
        headers = []
        for i in range(0, model_1.columnCount()):
            headers.append(str(model_1.headerData(i, Qt.Horizontal)))
        all_rows.append(headers)
        for rows in range(0, model_1.rowCount()):
            row = []
            for col in range(0, model_1.columnCount()):
                row.append(str(model_1.data(model_1.index(rows, col))))
            all_rows.append(row)
        if qtable_2 is not None:
            headers = []
            for i in range(0, model_2.columnCount()):
                headers.append(str(model_2.headerData(i, Qt.Horizontal)))
            all_rows.append(headers)
            for rows in range(0, model_2.rowCount()):
                row = []
                for col in range(0, model_2.columnCount()):
                    row.append(str(model_2.data(model_2.index(rows, col))))
                all_rows.append(row)
        # Write list into csv file
        try:
            if os.path.exists(folder_path):
                msg = "Are you sure you want to overwrite this file?"
                answer = self.controller.ask_question(msg, "Overwrite")
                if answer:
                    self.write_csv(dialog, folder_path, all_rows)
            else:
                self.write_csv(dialog, folder_path, all_rows)
        except:
            msg = "File path doesn't exist or you dont have permission or file is opened"
            self.controller.show_warning(msg)
            pass


    def workcat_filter_by_text(self, dialog, qtable, widget_txt, table_name, workcat_id, field_id):

        result_select = utils_giswater.getWidgetText(dialog, widget_txt)
        if result_select != 'null':
            expr = ("workcat_id = '" + str(workcat_id) + "'"
                    " and " + str(field_id) + " ILIKE '%" + str(result_select) + "%'")
        else:
            expr = "workcat_id ILIKE '%" + str(workcat_id) + "%'"
        self.workcat_fill_table(qtable, table_name, expr=expr)
        self.set_table_columns(dialog, qtable, table_name)


    def workcat_fill_table(self, widget, table_name, hidde=False, set_edit_triggers=QTableView.NoEditTriggers, expr=None):
        """ Fill table @widget filtering query by @workcat_id
        Set a model with selected filter.
        Attach that model to selected table
        @setEditStrategy:
            0: OnFieldChange
            1: OnRowChange
            2: OnManualSubmit
        """

        # Set model
        model = QSqlTableModel()
        model.setTable(self.schema_name+"."+table_name)
        model.setEditStrategy(QSqlTableModel.OnFieldChange)
        model.setSort(0, 0)
        model.select()

        widget.setEditTriggers(set_edit_triggers)
        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())
        # Attach model to table view
        if expr:
            widget.setModel(model)
            widget.model().setFilter(expr)
        else:
            widget.setModel(model)

        if hidde:
            self.refresh_table(widget)


    def workcat_zoom(self, qtable):
        """ Zoom feature with the code set in 'network_code' of the layer set in 'network_geom_type' """

        # Get selected code from combo
        element = qtable.selectionModel().selectedRows()
        if len(element) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        row = element[0].row()
        feature_id = qtable.model().record(row).value('feature_id')

        # Get selected layer
        geom_type = qtable.model().record(row).value('feature_type').lower()
        fieldname = geom_type + "_id"

        # Check if the expression is valid
        expr_filter = fieldname + " = '" + str(feature_id) + "'"
        (is_valid, expr) = self.check_expression(expr_filter)   #@UnusedVariable
        if not is_valid:
            return

        for value in self.feature_cat.itervalues():
            if value.type.lower() == geom_type:
                layer = self.controller.get_layer_by_layername(value.layername)
                if layer:
                    # Select features of @layer applying @expr
                    self.select_features_by_expr(layer, expr)
                    # If any feature found, zoom it and exit function
                    if layer.selectedFeatureCount() > 0:
                        self.iface.setActiveLayer(layer)
                        self.iface.legendInterface().setLayerVisible(layer, True)
                        self.open_custom_form(layer, expr)
                        self.zoom_to_selected_features(layer, geom_type)
                        return

        # If the feature is not in views because the selectors are "disabled"...
        message = "Modify values of selectors to see the feature"
        self.controller.show_warning(message)


    def fill_label_data(self, workcat_id, table_name, extension=None):

        if workcat_id == "null":
            return

        features = ['NODE', 'CONNEC', 'GULLY', 'ELEMENT', 'ARC']
        for feature in features:
            sql = ("SELECT feature_id "
                   " FROM " + self.schema_name + "." + str(table_name) + "")
            sql += (" WHERE workcat_id = '" + str(workcat_id)) + "' AND feature_type = '" + str(feature) + "'"
            rows = self.controller.get_rows(sql)
            if not rows:
                pass

            if extension is not None:
                widget_name = "lbl_total_" + str(feature.lower()) + str(extension)
            else:
                widget_name = "lbl_total_" + str(feature.lower())

            widget = self.items_dialog.findChild(QLabel, str(widget_name))

            if self.project_type == 'ws' and feature == 'GULLY':
                widget.hide()
            total = len(rows)
            # Add data to workcat search form
            widget.setText(str(feature.lower().title()) + "s: " + str(total))
            # TODO 1 DESCOMENTAR ESTO Y COMPROBAR, FALLA EL gis_length de la capa arc
            length = 0
            if feature == 'ARC':
                for row in rows:
                    arc_id = str(row[0])
                    sql = ("SELECT st_length2d(the_geom)::numeric(12,2) "
                           " FROM " + self.schema_name + ".arc"
                           " WHERE arc_id = '" + arc_id + "'")
                    row = self.controller.get_row(sql)
                    if row:
                        length = length + row[0]
                    else:
                        message = "Some data is missing. Check gis_length for arc"
                        self.controller.show_warning(message, parameter = arc_id)
                        return
                if extension != None:
                    widget = self.items_dialog.findChild(QLabel, "lbl_length" + str(extension))
                else:
                    widget = self.items_dialog.findChild(QLabel, "lbl_length")

                # Add data to workcat search form
                widget.setText("Total arcs length: " + str(length))
            # TODO END



    def zoom_to_polygon(self, workcat_id, layer_name, field_id):


        layer = self.controller.get_layer_by_tablename(layer_name)
        if not layer:
            msg = "Layer not found"
            self.controller.show_message(msg, message_level=2, duration=3)
            return

        # Check if the expression is valid
        expr_filter = str(field_id) + " LIKE '%" + str(workcat_id) + "%'"
        (is_valid, expr) = self.check_expression(expr_filter)   #@UnusedVariable
        if not is_valid:
            return
        if workcat_id is not None:
            sql = ("SELECT the_geom FROM " + self.schema_name + "." + str(layer_name) + " "
                   " WHERE "+str(field_id)+"='"+str(workcat_id) + "'")
            row = self.controller.get_row(sql)
            if row[0] is None or row[0] == 'null':
                msg = "Cant zoom to selection because has no geometry: "
                self.controller.show_warning(msg, parameter=workcat_id)
                self.iface.legendInterface().setLayerVisible(layer, False)
                return

        # Select features of @layer applying @expr
        self.select_features_by_expr(layer, expr)

        # If any feature found, zoom it and exit function
        if layer.selectedFeatureCount() > 0:
            self.iface.setActiveLayer(layer)
            self.iface.legendInterface().setLayerVisible(layer, True)
            self.iface.actionZoomToSelected().trigger()
            layer.removeSelection()

















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

