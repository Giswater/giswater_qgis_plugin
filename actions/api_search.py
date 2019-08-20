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

if Qgis.QGIS_VERSION_INT < 29900:
    from qgis.core import QgsPoint as QgsPointXY
    from qgis.PyQt.QtGui import QStringListModel
else:
    from qgis.core import QgsPointXY
    from qgis.PyQt.QtCore import QStringListModel

from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtGui import QColor
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtWidgets import QAbstractItemView, QComboBox, QCompleter, QFileDialog, QGridLayout, QLabel, QLineEdit
from qgis.PyQt.QtWidgets import QSizePolicy, QSpacerItem, QTableView, QTabWidget, QWidget

import csv
import json
import operator
import os
import re
import sys
from functools import partial
from collections import OrderedDict

from .. import utils_giswater
from .api_cf import ApiCF
from .manage_new_psector import ManageNewPsector
from .manage_visit import ManageVisit
from .api_parent import ApiParent
from ..ui_manager import ApiSearchUi, ApiBasicInfo, ListItems


class ApiSearch(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class constructor """

        ApiParent.__init__(self, iface, settings, controller, plugin_dir)
        self.manage_new_psector = ManageNewPsector(iface, settings, controller, plugin_dir)
        self.manage_visit = ManageVisit(iface, settings, controller, plugin_dir)
        self.iface = iface
        self.json_search = {}
        self.lbl_visible = False


    def api_search(self):
        
        # Dialog
        self.dlg_search = ApiSearchUi()
        self.load_settings(self.dlg_search)
        self.dlg_search.lbl_msg.setStyleSheet("QLabel{color:red;}")
        self.dlg_search.lbl_msg.setVisible(False)

        # Make it dockable in left dock widget area
        self.iface.addDockWidget(Qt.LeftDockWidgetArea, self.dlg_search)

        body = self.create_body()
        function_name = "gw_api_getsearch"
        row = self.controller.execute_api_function(function_name, body)
        if not row:
            return False

        complet_list = [json.loads(row[0], object_pairs_hook=OrderedDict)]

        main_tab = self.dlg_search.findChild(QTabWidget, 'main_tab')
        first_tab = None
        self.lineedit_list = []
        for tab in complet_list[0]["form"]:
            if first_tab is None:
                first_tab = tab['tabName']
            tab_widget = QWidget(main_tab)
            tab_widget.setObjectName(tab['tabName'])
            main_tab.addTab(tab_widget, tab['tabtext'])
            gridlayout = QGridLayout()
            tab_widget.setLayout(gridlayout)
            x = 0

            for field in tab['fields']:
                label = QLabel()
                label.setObjectName('lbl_' + field['label'])
                label.setText(field['label'].capitalize())
                if field['widgettype'] == 'typeahead':
                    completer = QCompleter()
                    widget = self.add_lineedit(field)
                    widget = self.set_completer(widget, completer)
                    self.lineedit_list.append(widget)
                elif field['widgettype'] == 'combo':
                    widget = self.add_combobox(field)

                gridlayout.addWidget(label, x, 0)
                gridlayout.addWidget(widget, x, 1)
                x += 1

            vertical_spacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
            gridlayout.addItem(vertical_spacer1)

        self.dlg_search.dlg_closed.connect(self.rubber_polygon.reset)
    
        # Open dialog
        self.open_dialog(self.dlg_search)


    def set_completer(self, widget, completer=None):
        """ Set completer and add listeners """

        if completer:
            model = QStringListModel()
            completer.highlighted.connect(partial(self.check_tab, completer))
            self.make_list(completer, model, widget)
            widget.textChanged.connect(partial(self.make_list, completer, model, widget))

        return widget


    def check_tab(self, completer):

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
            # layer = self.controller.get_layer_by_tablename(item['sys_table_id'])
            # if layer is None:
            #     msg = "Layer not found"
            #     self.controller.show_message(msg, message_level=2, duration=3)
            #     return
            #
            # self.iface.setActiveLayer(layer)
            self.ApiCF = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir, tab_type='data')
            complet_result, dialog = self.ApiCF.open_form(table_name=item['sys_table_id'], feature_id=item['sys_id'], tab_type='data')
            if not complet_result:
                print("FAIL")
                return
            self.draw(complet_result)

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
            point = QgsPointXY(float(x1), float(y1))

            self.draw_point(point)
            self.zoom_to_rectangle(x1, y1, x1, y1)

            # textItem = QgsTextAnnotationItem(self.iface.mapCanvas())
            # document = QTextDocument()
            # #document.setHtml("<strong>" + str("TEST") + "</strong></br><p>hola<p/>")
            # document.setPlainText("HOLA")
            # textItem.setDocument(document)
            # # symbol = QgsMarkerSymbolV2()
            # # symbol.setSize(9)
            # # textItem.setMarkerSymbol(symbol)
            # textItem.setMapPosition(point)

            self.canvas.refresh()

        elif self.dlg_search.main_tab.widget(index).objectName() == 'hydro':
            x1 = item['sys_x']
            y1 = item['sys_y']
            point = QgsPointXY(float(x1), float(y1))
            self.draw_point(point)
            self.zoom_to_rectangle(x1, y1, x1, y1)
            self.open_hydrometer_dialog(table_name=item['sys_table_id'], feature_id=item['sys_id'])

        elif self.dlg_search.main_tab.widget(index).objectName() == 'workcat':
            list_coord = re.search('\(\((.*)\)\)', str(item['sys_geometry']))
            points = self.get_points(list_coord)
            self.draw_polygon(points, fill_color=QColor(255, 0, 255, 50))
            max_x, max_y, min_x, min_y = self.get_max_rectangle_from_coords(list_coord)
            self.zoom_to_rectangle(max_x, max_y, min_x, min_y)
            self.workcat_open_table_items(item)
            return

        elif self.dlg_search.main_tab.widget(index).objectName() == 'psector':
            list_coord = re.search('\(\((.*)\)\)', str(item['sys_geometry']))
            points = self.get_points(list_coord)
            self.draw_polygon(points, fill_color=QColor(255, 0, 255, 50))
            max_x, max_y, min_x, min_y = self.get_max_rectangle_from_coords(list_coord)
            self.zoom_to_rectangle(max_x, max_y, min_x, min_y)
            self.manage_new_psector.new_psector(item['sys_id'], 'plan', is_api=True)

        elif self.dlg_search.main_tab.widget(index).objectName() == 'visit':
            list_coord = re.search('\((.*)\)', str(item['sys_geometry']))
            max_x, max_y, min_x, min_y = self.get_max_rectangle_from_coords(list_coord)
            self.resetRubberbands()
            point = QgsPointXY(float(max_x), float(max_y))
            self.draw_point(point)
            self.zoom_to_rectangle(max_x, max_y, min_x, min_y)
            self.manage_visit.manage_visit(visit_id=item['sys_id'])
            return

        self.lbl_visible = False
        self.dlg_search.lbl_msg.setVisible(self.lbl_visible)


    def make_list(self, completer, model, widget):
        """ Create a list of ids and populate widget (QLineEdit) """

        # Create 2 json, one for first QLineEdit and other for second QLineEdit
        form_search = ''
        extras_search = ''
        form_search_add = ''
        extras_search_add = ''
        row = None
        index = self.dlg_search.main_tab.currentIndex()
        combo_list = self.dlg_search.main_tab.widget(index).findChildren(QComboBox)
        line_list = self.dlg_search.main_tab.widget(index).findChildren(QLineEdit)
        form_search += '"tabName":"'+self.dlg_search.main_tab.widget(index).objectName()+'"'
        form_search_add += '"tabName":"' + self.dlg_search.main_tab.widget(index).objectName() + '"'
        if combo_list:
            combo = combo_list[0]
            id = utils_giswater.get_item_data(self.dlg_search, combo, 0)
            name = utils_giswater.get_item_data(self.dlg_search, combo, 1)
            extras_search += '"'+combo.property('column_id')+'":{"id":"' + str(id) + '", "name":"' + name + '"}, '
            extras_search_add += '"' + combo.property('column_id') + '":{"id":"' + str(id) + '", "name":"' + name + '"}, '
        if line_list:
            line_edit = line_list[0]
            # If current tab have more than one QLineEdit, clear second QLineEdit
            if len(line_list) == 2:
                line_edit.textChanged.connect(partial(self.clear_line_edit_add, line_list))

            value = utils_giswater.getWidgetText(self.dlg_search, line_edit, return_string_null=False)
            if str(value) == '':
                return

            extras_search += '"' + line_edit.property('column_id') + '":{"text":"' + value + '"}'
            extras_search_add += '"' + line_edit.property('column_id') + '":{"text":"' + value + '"}'
            body = self.create_body(form=form_search, extras=extras_search)
            sql = ("SELECT gw_api_setsearch($${" +body + "}$$)")
            row = self.controller.get_row(sql, log_sql=True, commit=True)
            if row:
                self.result_data = row[0]

        # Set label visible
        if row:
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
            self.set_completer_object_api(completer, model, widget, display_list)

        if len(line_list) == 2:
            line_edit_add = line_list[1]
            value = utils_giswater.getWidgetText(self.dlg_search, line_edit_add)
            if str(value) == 'null':
                return

            extras_search_add += ', "' + line_edit_add.property('column_id') + '":{"text":"' + value + '"}'
            body = self.create_body(form=form_search_add, extras=extras_search_add)
            sql = ("SELECT gw_api_setsearch_add($${" + body + "}$$)")
            row = self.controller.get_row(sql, log_sql=True, commit=True)
            if row:
                self.result_data = row[0]
                if row is not None:
                    display_list = []
                    for data in self.result_data['data']:
                        display_list.append(data['display_name'])
                    self.set_completer_object_api(completer, model, line_edit_add, display_list)


    def clear_line_edit_add(self, line_list):
        """ Clear second line edit if exist """

        line_edit_add = line_list[1]
        line_edit_add.setText('')


    def add_combobox(self, field):

        widget = QComboBox()
        widget.setObjectName(field['widgetname'])
        widget.setProperty('column_id', field['column_id'])
        self.populate_combo(widget, field)
        if 'selectedId' in field:
            utils_giswater.set_combo_itemData(widget, field['selectedId'], 0)
        widget.currentIndexChanged.connect(partial(self.clear_lineedits))

        return widget

    def clear_lineedits(self):

        # Clear all lineedit widgets from search tabs
        for widget in self.lineedit_list:
            utils_giswater.setWidgetText(self.dlg_search, widget, '')


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


    def open_hydrometer_dialog(self, table_name=None, feature_id=None):

        feature = '"tableName":"' + str(table_name) + '", "id":"' + str(feature_id) + '"'
        body = self.create_body(feature=feature)
        sql = ("SELECT gw_api_getinfofromid($${" + body + "}$$)")
        row = self.controller.get_row(sql, log_sql=True, commit=True)
        if not row:
            self.controller.show_message("NOT ROW FOR: " + sql, 2)
            return

        self.hydro_info_dlg = ApiBasicInfo()
        self.load_settings(self.hydro_info_dlg)

        self.hydro_info_dlg.btn_close.clicked.connect(partial(self.close_dialog, self.hydro_info_dlg))
        self.hydro_info_dlg.rejected.connect(partial(self.close_dialog, self.hydro_info_dlg))
        field_id = str(row[0]['body']['feature']['idName'])
        self.populate_basic_info(self.hydro_info_dlg, row, field_id)

        self.open_dialog(self.hydro_info_dlg)


    def workcat_open_table_items(self, item):
        """ Create the view and open the dialog with his content """

        workcat_id = item['sys_id']
        layer_name = item['sys_table_id']
        field_id = item['filter_text']

        if workcat_id is None:
            return False

        self.update_selector_workcat(workcat_id)
        self.force_expl(workcat_id)
        # TODO ZOOM TO SELECTED WORKCAT
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
        self.items_dialog.tbl_psm.doubleClicked.connect(partial(self.open_feature_form, self.items_dialog.tbl_psm))
        self.items_dialog.tbl_psm_end.doubleClicked.connect(partial(self.open_feature_form, self.items_dialog.tbl_psm_end))

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

        self.open_dialog(self.items_dialog)


    def force_expl(self,  workcat_id):
        """ Active exploitations are compared with workcat farms.
            If there is consistency nothing happens, if there is no consistency force this exploitations to selector."""

        sql = ("SELECT a.expl_id, a.expl_name FROM "
               "  (SELECT expl_id, expl_name FROM v_ui_workcat_x_feature "
               "   WHERE workcat_id='" + str(workcat_id) + "' "
               "   UNION SELECT expl_id, expl_name FROM v_ui_workcat_x_feature_end "
               "   WHERE workcat_id='" + str(workcat_id) + "'"
               "   ) AS a "
               " WHERE expl_id NOT IN "
               "  (SELECT expl_id FROM selector_expl "
               "   WHERE cur_user=current_user)")
        rows = self.controller.get_rows(sql)
        if not rows:
            return

        if len(rows) > 0:
            for row in rows:
                sql = ("INSERT INTO selector_expl(expl_id, cur_user) "
                       " VALUES('" + str(row[0]) + "', current_user)")
                self.controller.execute_sql(sql)
            msg = "Your exploitation selector has been updated"
            self.controller.show_warning(msg)


    def update_selector_workcat(self, workcat_id):
        """ Update table selector_workcat """

        sql = ("DELETE FROM selector_workcat "
               " WHERE cur_user = current_user;\n")
        sql += ("INSERT INTO selector_workcat(workcat_id, cur_user) "
                " VALUES('" + workcat_id + "', current_user);\n")
        self.controller.execute_sql(sql)


    def disable_qatable_by_state(self, qtable, _id, qbutton):

        sql = ("SELECT state_id FROM selector_state "
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
        folder_path, filter_ = file_dialog.getSaveFileName(None, self.controller.tr(msg), folder_path, '*.csv')
        if folder_path:
            utils_giswater.setWidgetText(dialog, widget, str(folder_path))


    def force_state(self, qbutton, state, qtable):
        """ Force selected state and set qtable enabled = True """

        sql = ("SELECT state_id "
               "FROM selector_state "
               "WHERE cur_user = current_user AND state_id = '" + str(state) + "'")
        row = self.controller.get_row(sql)
        if row:
            return
        
        sql = ("INSERT INTO selector_state(state_id, cur_user) "
               "VALUES('" + str(state) + "', current_user)")
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
                    self.write_to_csv(dialog, folder_path, all_rows)
            else:
                self.write_to_csv(dialog, folder_path, all_rows)
        except:
            msg = "File path doesn't exist or you dont have permission or file is opened"
            self.controller.show_warning(msg)
            pass


    def write_to_csv(self, dialog, folder_path=None, all_rows=None):

        with open(folder_path, "w") as output:
            writer = csv.writer(output, lineterminator='\n')
            writer.writerows(all_rows)
        self.controller.plugin_settings_set_value("search_csv_path", utils_giswater.getWidgetText(dialog, 'txt_path'))
        message = "Values has been updated"
        self.controller.show_info(message)


    def workcat_filter_by_text(self, dialog, qtable, widget_txt, table_name, workcat_id, field_id):
        """ Filter list of workcats by workcat_id and field_id """

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


    def open_feature_form(self, qtable):
        """ Zoom feature with the code set in 'network_code' of the layer set in 'network_geom_type' """

        # Get selected code from combo
        element = qtable.selectionModel().selectedRows()
        if len(element) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        row = element[0].row()

        geom_type = qtable.model().record(row).value('feature_type').lower()
        table_name = "v_edit_" + geom_type

        feature_id = qtable.model().record(row).value('feature_id')

        self.ApiCF = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir, tab_type='data')
        complet_result, dialog = self.ApiCF.open_form(table_name=table_name,  feature_id=feature_id, tab_type='data')
        # Get list of all coords in field geometry
        list_coord = re.search('\((.*)\)', str(complet_result[0]['body']['feature']['geometry']['st_astext']))

        points = self.get_points(list_coord)
        self.rubber_polygon.reset()
        self.draw_polyline(points)

        max_x, max_y, min_x, min_y = self.get_max_rectangle_from_coords(list_coord)
        self.zoom_to_rectangle(max_x, max_y, min_x, min_y)


    def fill_label_data(self, workcat_id, table_name, extension=None):

        if workcat_id == "null":
            return

        features = ['NODE', 'CONNEC', 'GULLY', 'ELEMENT', 'ARC']
        for feature in features:
            sql = ("SELECT feature_id "
                   " FROM " + str(table_name) + "")
            sql += (" WHERE workcat_id = '" + str(workcat_id)) + "' AND feature_type = '" + str(feature) + "'"
            rows = self.controller.get_rows(sql)
            if not rows:
                return

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
            length = 0
            if feature == 'ARC':
                for row in rows:
                    arc_id = str(row[0])
                    sql = ("SELECT st_length2d(the_geom)::numeric(12,2) "
                           " FROM arc"
                           " WHERE arc_id = '" + arc_id + "'")
                    row = self.controller.get_row(sql)
                    if row:
                        length = length + row[0]
                    else:
                        message = "Some data is missing. Check gis_length for arc"
                        self.controller.show_warning(message, parameter = arc_id)
                        return
                if extension is not  None:
                    widget = self.items_dialog.findChild(QLabel, "lbl_length" + str(extension))
                else:
                    widget = self.items_dialog.findChild(QLabel, "lbl_length")

                # Add data to workcat search form
                widget.setText("Total arcs length: " + str(length))

