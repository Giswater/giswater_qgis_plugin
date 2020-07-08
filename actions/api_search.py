"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsPointXY
from qgis.PyQt.QtCore import QStringListModel, Qt
from qgis.PyQt.QtGui import QColor
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtWidgets import QAbstractItemView, QComboBox, QCompleter, QFileDialog, QGridLayout, QHeaderView, \
    QLabel, QLineEdit, QSizePolicy, QSpacerItem, QTableView, QTabWidget, QWidget

import csv
import operator
import os
import re
import sys
from functools import partial

from .. import utils_giswater
from .api_cf import ApiCF
from .manage_document import ManageDocument
from .manage_new_psector import ManageNewPsector
from .manage_visit import ManageVisit
from .api_parent import ApiParent
from ..ui_manager import SearchUi, InfoGenericUi, SearchWorkcat


class ApiSearch(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class constructor """

        ApiParent.__init__(self, iface, settings, controller, plugin_dir)
        self.manage_new_psector = ManageNewPsector(iface, settings, controller, plugin_dir)
        self.manage_visit = ManageVisit(iface, settings, controller, plugin_dir)
        self.iface = iface
        self.project_type = controller.get_project_type()
        self.json_search = {}
        self.lbl_visible = False
        self.dlg_search = None
        self.is_mincut = False


    def init_dialog(self):
        """ Initialize dialog. Make it dockable in left dock widget area """

        self.dlg_search = SearchUi()
        self.load_settings(self.dlg_search)
        self.iface.addDockWidget(Qt.LeftDockWidgetArea, self.dlg_search)
        self.dlg_search.dlg_closed.connect(self.reset_rubber_polygon)
        self.dlg_search.dlg_closed.connect(self.close_search)


    def api_search(self, dlg_mincut=None):
        form = ""
        if self.dlg_search is None and dlg_mincut is None:
            self.init_dialog()
        if dlg_mincut:
            self.dlg_search = dlg_mincut
            self.is_mincut = True
            form = f'"singleTab":"tab_address"'

        self.dlg_search.lbl_msg.setStyleSheet("QLabel{color:red;}")
        self.dlg_search.lbl_msg.setVisible(False)
        qgis_project_add_schema = self.controller.plugin_settings_value('gwAddSchema')

        self.controller.set_user_settings_value('open_search', 'true')

        if qgis_project_add_schema is None:
            body = self.create_body(form=form)
        else:
            extras = f'"addSchema":"{qgis_project_add_schema}"'
            body = self.create_body(form=form, extras=extras)
        function_name = "gw_fct_getsearch"
        complet_list = self.controller.get_json(function_name, body)
        if not complet_list:
            return False

        main_tab = self.dlg_search.findChild(QTabWidget, 'main_tab')
        if dlg_mincut and len(complet_list["form"]) == 1:
            main_tab = self.dlg_search.findChild(QTabWidget, 'main_tab')
            main_tab.setStyleSheet("QTabBar::tab { background-color: transparent; text-align:left;"
                                   "border: 1px solid transparent;}"    
                                   "QTabWidget::pane { background-color: #fcfcfc; border: 1 solid #dadada;}")

        first_tab = None
        self.lineedit_list = []
        for tab in complet_list["form"]:
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
                widget = None
                if field['widgettype'] == 'typeahead':
                    completer = QCompleter()
                    widget = self.add_lineedit(field)
                    widget = self.set_typeahead_completer(widget, completer)
                    self.lineedit_list.append(widget)
                elif field['widgettype'] == 'combo':
                    widget = self.add_combobox(field)
                gridlayout.addWidget(label, x, 0)
                gridlayout.addWidget(widget, x, 1)
                x += 1

            vertical_spacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
            gridlayout.addItem(vertical_spacer1)

        if self.is_mincut is False:
            self.controller.manage_translation('search', self.dlg_search)


    def reset_rubber_polygon(self):

        if self.rubber_polygon:
            self.rubber_polygon.reset()


    def close_search(self):

        self.dlg_search = None
        self.controller.set_user_settings_value('open_search', 'false')


    def set_typeahead_completer(self, widget, completer=None):
        """ Set completer and add listeners """

        if completer:
            model = QStringListModel()
            completer.highlighted.connect(partial(self.check_tab, completer))
            self.make_list(completer, model, widget)
            widget.textChanged.connect(partial(self.make_list, completer, model, widget))

        return widget


    def check_tab(self, completer, is_add_schema=False):

        # We look for the index of current tab so we can search by name
        index = self.dlg_search.main_tab.currentIndex()

        # Get all QLineEdit for activate or we cant write when tab have more than 1 QLineEdit
        line_list = self.dlg_search.main_tab.widget(index).findChildren(QLineEdit)
        for line_edit in line_list:
            line_edit.setReadOnly(False)
            line_edit.setStyleSheet(None)

        # Get selected row
        row = completer.popup().currentIndex().row()
        if row == -1:
            return

        # Get text from selected row
        _key = completer.completionModel().index(row, 0).data()
        # Search text into self.result_data: this variable contains all matching objects in the function "make_list()"
        item = None
        for data in self.result_data['data']:
            if _key == data['display_name']:
                item = data
                break

        # Show info in docker?
        if self.is_mincut is False:
            self.controller.init_docker()

        # Get selected tab name
        tab_selected = self.dlg_search.main_tab.widget(index).objectName()

        # check for addschema
        if tab_selected == 'add_network':
            is_add_schema = True

        # Tab 'network or add_network'
        if tab_selected == 'network' or tab_selected == 'add_network':
            self.ApiCF = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir, tab_type='data')
            complet_result, dialog = self.ApiCF.open_form(table_name=item['sys_table_id'], feature_id=item['sys_id'],
                                   tab_type='data', is_add_schema=is_add_schema)
            if not complet_result:
                return
            self.draw(complet_result[0])
            self.resetRubberbands()

        # Tab 'search'
        elif tab_selected == 'search':
            # TODO
            return

        # Tab 'address' (streets)
        elif tab_selected == 'address' and 'id' in item and 'sys_id' not in item:
            polygon = item['st_astext']
            if polygon:
                polygon = polygon[9:len(polygon) - 2]
                polygon = polygon.split(',')
                x1, y1 = polygon[0].split(' ')
                x2, y2 = polygon[2].split(' ')
                self.zoom_to_rectangle(x1, y1, x2, y2)
            else:
                message = f"Zoom unavailable. Doesn't exist the geometry for the street"
                self.controller.show_info(message, parameter=item['display_name'])

        # Tab 'address'
        elif tab_selected == 'address' and 'sys_x' in item and 'sys_y' in item:
            x1 = item['sys_x']
            y1 = item['sys_y']
            point = QgsPointXY(float(x1), float(y1))
            self.draw_point(point, duration_time=5000)
            self.zoom_to_rectangle(x1, y1, x1, y1, margin=100)
            self.canvas.refresh()

        # Tab 'hydro'
        elif tab_selected == 'hydro':
            x1 = item['sys_x']
            y1 = item['sys_y']
            point = QgsPointXY(float(x1), float(y1))
            self.draw_point(point)
            self.zoom_to_rectangle(x1, y1, x1, y1, margin=100)
            self.open_hydrometer_dialog(table_name=item['sys_table_id'], feature_id=item['sys_id'])

        # Tab 'workcat'
        elif tab_selected == 'workcat':
            list_coord = re.search('\(\((.*)\)\)', str(item['sys_geometry']))
            if not list_coord:
                msg = "Empty coordinate list"
                self.controller.show_warning(msg)
                return
            points = self.get_points(list_coord)
            self.resetRubberbands()
            self.draw_polygon(points, fill_color=QColor(255, 0, 255, 50))
            max_x, max_y, min_x, min_y = self.get_max_rectangle_from_coords(list_coord)
            self.zoom_to_rectangle(max_x, max_y, min_x, min_y)
            self.workcat_open_table_items(item)
            return

        # Tab 'psector'
        elif tab_selected == 'psector':
            list_coord = re.search('\(\((.*)\)\)', str(item['sys_geometry']))
            self.manage_new_psector.new_psector(item['sys_id'], 'plan', is_api=True)
            self.manage_new_psector.dlg_plan_psector.rejected.connect(self.resetRubberbands)
            if not list_coord:
                msg = "Empty coordinate list"
                self.controller.show_warning(msg)
                return
            points = self.get_points(list_coord)
            self.resetRubberbands()
            self.draw_polygon(points, fill_color=QColor(255, 0, 255, 50))
            max_x, max_y, min_x, min_y = self.get_max_rectangle_from_coords(list_coord)
            self.zoom_to_rectangle(max_x, max_y, min_x, min_y, margin=50)

        # Tab 'visit'
        elif tab_selected == 'visit':
            list_coord = re.search('\((.*)\)', str(item['sys_geometry']))
            if not list_coord:
                msg = "Empty coordinate list"
                self.controller.show_warning(msg)
                return
            max_x, max_y, min_x, min_y = self.get_max_rectangle_from_coords(list_coord)
            self.resetRubberbands()
            point = QgsPointXY(float(max_x), float(max_y))
            self.draw_point(point)
            self.zoom_to_rectangle(max_x, max_y, min_x, min_y, margin=100)
            self.manage_visit.manage_visit(visit_id=item['sys_id'])
            self.manage_visit.dlg_add_visit.rejected.connect(self.resetRubberbands)
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
        result = None
        index = self.dlg_search.main_tab.currentIndex()
        combo_list = self.dlg_search.main_tab.widget(index).findChildren(QComboBox)
        line_list = self.dlg_search.main_tab.widget(index).findChildren(QLineEdit)
        form_search += f'"tabName":"{self.dlg_search.main_tab.widget(index).objectName()}"'
        form_search_add += f'"tabName":"{self.dlg_search.main_tab.widget(index).objectName()}"'

        if combo_list:
            combo = combo_list[0]
            id = utils_giswater.get_item_data(self.dlg_search, combo, 0)
            name = utils_giswater.get_item_data(self.dlg_search, combo, 1)
            try:
                feature_type = utils_giswater.get_item_data(self.dlg_search, combo, 2)
                extras_search += f'"searchType":"{feature_type}", '
            except IndexError:
                pass
            extras_search += f'"{combo.property("columnname")}":{{"id":"{id}", "name":"{name}"}}, '
            extras_search_add += f'"{combo.property("columnname")}":{{"id":"{id}", "name":"{name}"}}, '
        if line_list:
            line_edit = line_list[0]
            # If current tab have more than one QLineEdit, clear second QLineEdit
            if len(line_list) == 2:
                line_edit.textChanged.connect(partial(self.clear_line_edit_add, line_list))

            value = utils_giswater.getWidgetText(self.dlg_search, line_edit, return_string_null=False)
            if str(value) == '':
                return

            qgis_project_add_schema = self.controller.plugin_settings_value('gwAddSchema')
            extras_search += f'"{line_edit.property("columnname")}":{{"text":"{value}"}}, '
            extras_search += f'"addSchema":"{qgis_project_add_schema}"'
            extras_search_add += f'"{line_edit.property("columnname")}":{{"text":"{value}"}}'
            body = self.create_body(form=form_search, extras=extras_search)
            result = self.controller.get_json('gw_fct_setsearch', body, log_sql=True)
            if not result:
                return False

            if result:
                self.result_data = result

        # Set label visible
        if result:
            if self.result_data['data'] == {} and self.lbl_visible:
                self.dlg_search.lbl_msg.setVisible(True)
                if len(line_list) == 2:
                    widget_add = line_list[1]
                    widget_add.setReadOnly(True)
                    widget_add.setStyleSheet("QLineEdit { background: rgb(242, 242, 242); color: rgb(100, 100, 100)}")
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

            extras_search_add += f', "{line_edit_add.property("columnname")}":{{"text":"{value}"}}'
            body = self.create_body(form=form_search_add, extras=extras_search_add)
            result = self.controller.get_json('gw_fct_setsearchadd', body, log_sql=True)
            if not result:
                return False

            if result:
                self.result_data = result
                if result is not None:
                    display_list = []
                    for data in self.result_data['data']:
                        display_list.append(data['display_name'])
                    self.set_completer_object_api(completer, model, line_edit_add, display_list)


    def clear_line_edit_add(self, line_list):
        """ Clear second line edit if exist """

        line_edit_add = line_list[1]
        line_edit_add.blockSignals(True)
        line_edit_add.setText('')
        line_edit_add.blockSignals(False)


    def add_combobox(self, field):

        widget = QComboBox()
        widget.setObjectName(field['widgetname'])
        widget.setProperty('columnname', field['columnname'])
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
                if 'comboFeature' in field:
                    elem = [field['comboIds'][i], field['comboNames'][i], field['comboFeature'][i]]
                else:
                    elem = [field['comboIds'][i], field['comboNames'][i]]
                combolist.append(elem)
        records_sorted = sorted(combolist, key=operator.itemgetter(1))

        # Populate combo
        for record in records_sorted:
            widget.addItem(record[1], record)


    def open_hydrometer_dialog(self, table_name=None, feature_id=None):

        # get sys variale
        qgis_project_infotype = self.controller.plugin_settings_value('infoType')

        feature = f'"tableName":"{table_name}", "id":"{feature_id}"'
        extras = f'"infoType":"{qgis_project_infotype}"'
        body = self.create_body(feature=feature, extras=extras)
        function_name = 'gw_fct_getinfofromid'
        json_result = self.controller.get_json(function_name, body, log_sql=True)
        if json_result is None:
            return

        result = [json_result]
        if not result:
            return

        self.hydro_info_dlg = InfoGenericUi()
        self.load_settings(self.hydro_info_dlg)

        self.hydro_info_dlg.btn_close.clicked.connect(partial(self.close_dialog, self.hydro_info_dlg))
        self.hydro_info_dlg.rejected.connect(partial(self.close_dialog, self.hydro_info_dlg))
        self.hydro_info_dlg.rejected.connect(partial(self.resetRubberbands))
        field_id = str(result[0]['body']['feature']['idName'])
        self.populate_basic_info(self.hydro_info_dlg, result, field_id)

        self.open_dialog(self.hydro_info_dlg, dlg_name='info_generic')


    def workcat_open_table_items(self, item):
        """ Create the view and open the dialog with his content """

        workcat_id = item['sys_id']
        field_id = item['filter_text']
        display_name = item['display_name']

        if workcat_id is None:
            return False

        self.update_selector_workcat(workcat_id)
        self.force_expl(workcat_id)
        # TODO ZOOM TO SELECTED WORKCAT
        #self.zoom_to_polygon(workcat_id, layer_name, field_id)

        self.items_dialog = SearchWorkcat()
        self.items_dialog.setWindowTitle(f'Workcat: {display_name}')
        self.set_icon(self.items_dialog.btn_doc_insert, "111")
        self.set_icon(self.items_dialog.btn_doc_delete, "112")
        self.set_icon(self.items_dialog.btn_doc_new, "34")
        self.set_icon(self.items_dialog.btn_open_doc, "170")

        self.load_settings(self.items_dialog)
        self.items_dialog.btn_state1.setEnabled(False)
        self.items_dialog.btn_state0.setEnabled(False)

        search_csv_path = self.controller.plugin_settings_value('search_csv_path')
        utils_giswater.setWidgetText(self.items_dialog, self.items_dialog.txt_path, search_csv_path)
        utils_giswater.setWidgetText(self.items_dialog, self.items_dialog.lbl_init, f"Filter by: {field_id}")
        utils_giswater.setWidgetText(self.items_dialog, self.items_dialog.lbl_end, f"Filter by: {field_id}")

        self.items_dialog.tbl_psm.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.items_dialog.tbl_psm.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
        self.items_dialog.tbl_psm_end.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.items_dialog.tbl_psm_end.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
        self.items_dialog.tbl_document.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.items_dialog.tbl_document.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)

        self.disable_qatable_by_state(self.items_dialog.tbl_psm, 1, self.items_dialog.btn_state1)
        self.disable_qatable_by_state(self.items_dialog.tbl_psm_end, 0, self.items_dialog.btn_state0)

        # Create list for completer QLineEdit
        sql = "SELECT DISTINCT(id) FROM v_ui_document ORDER BY id"
        list_items = self.make_list_for_completer(sql)
        self.set_completer_lineedit(self.items_dialog.doc_id, list_items)

        table_name = "v_ui_workcat_x_feature"
        table_name_end = "v_ui_workcat_x_feature_end"
        table_doc = "v_ui_doc_x_workcat"
        self.items_dialog.btn_doc_insert.clicked.connect(
            partial(self.document_insert, self.items_dialog, 'doc_x_workcat', 'workcat_id', item['sys_id']))
        self.items_dialog.btn_doc_delete.clicked.connect(
            partial(self.document_delete, self.items_dialog.tbl_document, 'doc_x_workcat'))
        self.items_dialog.btn_doc_new.clicked.connect(
            partial(self.manage_document, self.items_dialog.tbl_document, item['sys_id']))
        self.items_dialog.btn_open_doc.clicked.connect(partial(self.document_open, self.items_dialog.tbl_document))
        self.items_dialog.tbl_document.doubleClicked.connect(
            partial(self.document_open, self.items_dialog.tbl_document))

        self.items_dialog.btn_close.clicked.connect(partial(self.close_dialog, self.items_dialog))
        self.items_dialog.btn_path.clicked.connect(
            partial(self.get_folder_dialog, self.items_dialog, self.items_dialog.txt_path))
        self.items_dialog.rejected.connect(partial(self.close_dialog, self.items_dialog))
        self.items_dialog.rejected.connect(partial(self.resetRubberbands))
        self.items_dialog.btn_state1.clicked.connect(
            partial(self.force_state, self.items_dialog.btn_state1, 1, self.items_dialog.tbl_psm))
        self.items_dialog.btn_state0.clicked.connect(
            partial(self.force_state, self.items_dialog.btn_state0, 0, self.items_dialog.tbl_psm_end))
        self.items_dialog.btn_export_to_csv.clicked.connect(
            partial(self.export_to_csv, self.items_dialog, self.items_dialog.tbl_psm, self.items_dialog.tbl_psm_end,
                    self.items_dialog.txt_path))

        self.items_dialog.txt_name.textChanged.connect(partial
            (self.workcat_filter_by_text, self.items_dialog, self.items_dialog.tbl_psm, self.items_dialog.txt_name, table_name, workcat_id, field_id))
        self.items_dialog.txt_name_end.textChanged.connect(partial
            (self.workcat_filter_by_text, self.items_dialog, self.items_dialog.tbl_psm_end, self.items_dialog.txt_name_end, table_name_end, workcat_id, field_id))
        self.items_dialog.tbl_psm.doubleClicked.connect(partial(self.open_feature_form, self.items_dialog.tbl_psm))
        self.items_dialog.tbl_psm_end.doubleClicked.connect(
            partial(self.open_feature_form, self.items_dialog.tbl_psm_end))

        expr = "workcat_id ILIKE '%" + str(workcat_id) + "%'"
        self.workcat_fill_table(self.items_dialog.tbl_psm, table_name, expr=expr)
        self.set_table_columns(self.items_dialog, self.items_dialog.tbl_psm, table_name)
        expr = "workcat_id ILIKE '%" + str(workcat_id) + "%'"
        self.workcat_fill_table(self.items_dialog.tbl_psm_end, table_name_end, expr=expr)
        self.set_table_columns(self.items_dialog, self.items_dialog.tbl_psm_end, table_name_end)
        expr = "workcat_id ILIKE '%" + str(workcat_id) + "%'"
        self.workcat_fill_table(self.items_dialog.tbl_document, table_doc, expr=expr)
        self.set_table_columns(self.items_dialog, self.items_dialog.tbl_document, table_doc)

        #
        # Add data to workcat search form
        table_name = "v_ui_workcat_x_feature"
        table_name_end = "v_ui_workcat_x_feature_end"
        extension = '_end'
        self.fill_label_data(workcat_id, table_name)
        self.fill_label_data(workcat_id, table_name_end, extension)

        self.open_dialog(self.items_dialog, dlg_name='search_workcat')


    def manage_document(self, qtable, item_id):
        """ Access GUI to manage documents e.g Execute action of button 34 """

        manage_document = ManageDocument(self.iface, self.settings, self.controller, self.plugin_dir, single_tool=False)
        dlg_docman = manage_document.manage_document(tablename='workcat', qtable=qtable, item_id=item_id)
        dlg_docman.btn_accept.clicked.connect(partial(self.set_completer_object, dlg_docman, 'doc'))
        utils_giswater.remove_tab_by_tabName(dlg_docman.tabWidget, 'tab_rel')


    def force_expl(self, workcat_id):
        """ Active exploitations are compared with workcat farms.
            If there is consistency nothing happens, if there is no consistency force this exploitations to selector."""

        sql = (f"SELECT a.expl_id, a.expl_name FROM "
               f"  (SELECT expl_id, expl_name FROM v_ui_workcat_x_feature "
               f"   WHERE workcat_id='{workcat_id}' "
               f"   UNION SELECT expl_id, expl_name FROM v_ui_workcat_x_feature_end "
               f"   WHERE workcat_id='{workcat_id}'"
               f"   ) AS a "
               f" WHERE expl_id NOT IN "
               f"  (SELECT expl_id FROM selector_expl "
               f"   WHERE cur_user=current_user)")
        rows = self.controller.get_rows(sql)
        if not rows:
            return

        if len(rows) > 0:
            for row in rows:
                sql = (f"INSERT INTO selector_expl(expl_id, cur_user) "
                       f" VALUES('{row[0]}', current_user)")
                self.controller.execute_sql(sql)
            msg = "Your exploitation selector has been updated"
            self.controller.show_info(msg)


    def update_selector_workcat(self, workcat_id):
        """ Update table selector_workcat """

        sql = ("DELETE FROM selector_workcat "
               " WHERE cur_user = current_user;\n")
        sql += (f"INSERT INTO selector_workcat(workcat_id, cur_user) "
                f" VALUES('{workcat_id}', current_user);\n")
        self.controller.execute_sql(sql)


    def disable_qatable_by_state(self, qtable, _id, qbutton):

        sql = (f"SELECT state_id FROM selector_state "
               f" WHERE cur_user = current_user AND state_id ='{_id}'")
        row = self.controller.get_row(sql)
        if row is None:
            qtable.setEnabled(False)
            qbutton.setEnabled(True)


    def get_folder_dialog(self, dialog, widget):
        """ Get folder dialog """

        widget.setStyleSheet(None)
        if 'nt' in sys.builtin_module_names:
            folder_path = os.path.expanduser("~/Documents")
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

        sql = (f"SELECT state_id "
               f"FROM selector_state "
               f"WHERE cur_user = current_user AND state_id = '{state}'")
        row = self.controller.get_row(sql)
        if row:
            return

        sql = (f"INSERT INTO selector_state(state_id, cur_user) "
               f"VALUES('{state}', current_user)")
        self.controller.execute_sql(sql)
        qtable.setEnabled(True)
        qbutton.setEnabled(False)
        self.refresh_map_canvas()
        qtable.model().select()


    def export_to_csv(self, dialog, qtable_1=None, qtable_2=None, path=None):

        folder_path = utils_giswater.getWidgetText(dialog, path)
        if folder_path is None or folder_path == 'null':
            path.setStyleSheet("border: 1px solid red")
            return

        path.setStyleSheet(None)
        if folder_path.find('.csv') == -1:
            folder_path += '.csv'
        if qtable_1:
            model_1 = qtable_1.model()
        else:
            return

        model_2 = None
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
        message = "The csv file has been successfully exported"
        self.controller.show_info(message)


    def workcat_filter_by_text(self, dialog, qtable, widget_txt, table_name, workcat_id, field_id):
        """ Filter list of workcats by workcat_id and field_id """

        result_select = utils_giswater.getWidgetText(dialog, widget_txt)
        if result_select != 'null':
            expr = (f"workcat_id = '{workcat_id}'"
                    f" and {field_id} ILIKE '%{result_select}%'")
        else:
            expr = f"workcat_id ILIKE '%{workcat_id}%'"
        self.workcat_fill_table(qtable, table_name, expr=expr)
        self.set_table_columns(dialog, qtable, table_name)


    def workcat_fill_table(self, widget, table_name, set_edit_triggers=QTableView.NoEditTriggers, expr=None):
        """ Fill table @widget filtering query by @workcat_id
        Set a model with selected filter.
        Attach that model to selected table
        @setEditStrategy:
            0: OnFieldChange
            1: OnRowChange
            2: OnManualSubmit
        """

        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        # Set model
        model = QSqlTableModel()
        model.setTable(table_name)
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
        complet_result, dialog = self.ApiCF.open_form(table_name=table_name, feature_id=feature_id, tab_type='data')

        # Get list of all coords in field geometry
        list_coord = re.search('\((.*)\)', str(complet_result[0]['body']['feature']['geometry']['st_astext']))

        points = self.get_points(list_coord)
        self.reset_rubber_polygon()
        self.draw_polyline(points)

        max_x, max_y, min_x, min_y = self.get_max_rectangle_from_coords(list_coord)
        self.zoom_to_rectangle(max_x, max_y, min_x, min_y)


    def fill_label_data(self, workcat_id, table_name, extension=None):

        if workcat_id == "null":
            return

        features = ['NODE', 'CONNEC', 'GULLY', 'ELEMENT', 'ARC']
        for feature in features:
            sql = (f"SELECT feature_id "
                   f" FROM {table_name}")
            sql += f" WHERE workcat_id = '{workcat_id}' AND feature_type = '{feature}'"
            rows = self.controller.get_rows(sql)
            if extension is not None:
                widget_name = f"lbl_total_{feature.lower()}{extension}"
            else:
                widget_name = f"lbl_total_{feature.lower()}"

            widget = self.items_dialog.findChild(QLabel, str(widget_name))
            if not rows:
                total = 0
            else:
                total = len(rows)

            # Add data to workcat search form
            widget.setText(str(feature.lower().title()) + "s: " + str(total))
            if self.project_type == 'ws' and feature == 'GULLY':
                widget.setVisible(False)

            if not rows:
                continue

            length = 0
            if feature == 'ARC':
                for row in rows:
                    arc_id = str(row[0])
                    sql = (f"SELECT st_length2d(the_geom)::numeric(12,2) "
                           f" FROM arc"
                           f" WHERE arc_id = '{arc_id}'")
                    row = self.controller.get_row(sql)
                    if row:
                        length = length + row[0]
                    else:
                        message = "Some data is missing. Check gis_length for arc"
                        self.controller.show_warning(message, parameter=arc_id)
                        return
                if extension is not None:
                    widget = self.items_dialog.findChild(QLabel, f"lbl_length{extension}")
                else:
                    widget = self.items_dialog.findChild(QLabel, "lbl_length")

                # Add data to workcat search form
                widget.setText(f"Total arcs length: {length}")
