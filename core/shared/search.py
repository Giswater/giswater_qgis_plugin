"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import csv
import os
import re
import sys
from functools import partial

from qgis.PyQt.QtCore import QStringListModel, Qt, QTimer
from qgis.PyQt.QtGui import QColor
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtWidgets import QAbstractItemView, QComboBox, QCompleter, QFileDialog, QGridLayout, QHeaderView, \
    QLabel, QLineEdit, QSizePolicy, QSpacerItem, QTableView, QTabWidget, QWidget, QDockWidget
from qgis.core import QgsPointXY, QgsGeometry

from .document import GwDocument
from .info import GwInfo
from .psector import GwPsector
from .visit import GwVisit
from ..ui.ui_manager import GwInfoGenericUi, GwSearchWorkcatUi
from ..utils import tools_gw
from ... import global_vars
from ...lib import tools_db, tools_qgis, tools_qt


class GwSearch:

    def __init__(self):

        self.manage_new_psector = GwPsector()
        self.manage_visit = GwVisit()
        self.iface = global_vars.iface
        self.project_type = global_vars.project_type
        self.canvas = global_vars.canvas
        self.schema_name = global_vars.schema_name
        self.json_search = {}
        self.lbl_visible = False
        self.dlg_search = None
        self.is_mincut = False
        self.rubber_band = tools_gw.create_rubberband(self.canvas)
        self.aux_rubber_band = tools_gw.create_rubberband(self.canvas)


    def open_search(self, dlg_search, dlg_mincut=None, load_project=False):

        # If docker search is already opened, don't let user open another one
        docker_search = self.iface.mainWindow().findChild(QDockWidget, 'dlg_search')
        if docker_search and dlg_mincut is None:
            return

        # If dlg_search is not None we are going to open search independently.
        if dlg_search:
            self.dlg_search = dlg_search
            self._init_dialog()

        # If dlg_mincut is None we are not opening from mincut
        form = ""
        if dlg_mincut:
            self.dlg_search = dlg_mincut
            self.is_mincut = True
            form = f'"singleTab":"tab_address"'

        self.dlg_search.lbl_msg.setStyleSheet("QLabel{color:red;}")
        self.dlg_search.lbl_msg.setVisible(False)
        qgis_project_add_schema = global_vars.project_vars['add_schema']
        if qgis_project_add_schema is None:
            body = tools_gw.create_body(form=form)
        else:
            extras = f'"addSchema":"{qgis_project_add_schema}"'
            body = tools_gw.create_body(form=form, extras=extras)
        complet_list = tools_gw.execute_procedure('gw_fct_getsearch', body)
        if not complet_list or complet_list['status'] == 'Failed':
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
                try:
                    label = QLabel()
                    label.setObjectName('lbl_' + field['label'])
                    label.setText(field['label'].capitalize())
                    widget = None
                    if field['widgettype'] == 'typeahead':
                        completer = QCompleter()
                        widget = tools_gw.add_lineedit(field)
                        widget = self._set_typeahead_completer(widget, completer)
                        self.lineedit_list.append(widget)
                    elif field['widgettype'] == 'combo':
                        widget = self._add_combobox(field)
                    gridlayout.addWidget(label, x, 0)
                    gridlayout.addWidget(widget, x, 1)
                    x += 1
                except Exception:
                    msg = f"key 'comboIds' or/and comboNames not found WHERE columname='{field['columnname']}' AND " \
                          f"widgetname='{field['widgetname']}' AND widgettype='{field['widgettype']}'"
                    tools_qgis.show_message(msg, 2)

            vertical_spacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
            gridlayout.addItem(vertical_spacer1)

        if self.is_mincut is False:
            tools_qt.manage_translation('search', self.dlg_search)


    def export_to_csv(self, dialog, qtable_1=None, qtable_2=None, path=None):

        folder_path = tools_qt.get_text(dialog, path)
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
                answer = tools_qt.show_question(msg, "Overwrite")
                if answer:
                    self._write_to_csv(dialog, folder_path, all_rows)
            else:
                self._write_to_csv(dialog, folder_path, all_rows)
        except Exception:
            msg = "File path doesn't exist or you dont have permission or file is opened"
            tools_qgis.show_warning(msg)


    # region private functions


    def _init_dialog(self):
        """ Initialize dialog. Make it dockable in left dock widget area """

        self.iface.addDockWidget(Qt.LeftDockWidgetArea, self.dlg_search)
        self.dlg_search.dlg_closed.connect(self._reset_rubber_band)
        self.dlg_search.dlg_closed.connect(self._close_search)


    def _reset_rubber_band(self):

        tools_gw.reset_rubberband(self.rubber_band)
        tools_gw.reset_rubberband(self.aux_rubber_band)


    def _close_search(self):

        self.dlg_search = None


    def _set_typeahead_completer(self, widget, completer=None):
        """ Set completer and add listeners """

        if completer:
            model = QStringListModel()
            completer.highlighted.connect(partial(self._check_tab, completer))
            self._make_list(completer, model, widget)
            widget.textChanged.connect(partial(self._make_list, completer, model, widget))

        return widget


    def _check_tab(self, completer, is_add_schema=False):

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

        for line_edit in line_list:
            if 'id' in item:
                line_edit.setProperty('id_', item['id'])

        # Show info in docker?
        if self.is_mincut is False:
            tools_gw.init_docker()

        # Get selected tab name
        tab_selected = self.dlg_search.main_tab.widget(index).objectName()

        # check for addschema
        if tab_selected == 'add_network':
            is_add_schema = True

        # Tab 'network or add_network'
        if tab_selected == 'network' or tab_selected == 'add_network':
            self.customForm = GwInfo(tab_type='data')
            complet_result, dialog = self.customForm.get_info_from_id(
                item['sys_table_id'], tab_type='data', feature_id=item['sys_id'], is_add_schema=is_add_schema)

            if not complet_result:
                return

            # self.customForm.get_info_from_id (...) in turn ends up calling self.open_custom_form (...) which will draw
            # the line on the feature but not zoom. Here, with draw we redraw simply to zoom and so that there are not
            # two ruberbands (the one from self.open_custom_form (...) and this one) we delete these

            try:
                margin = float(complet_result['body']['feature']['zoomCanvasMargin']['mts'])
            except ValueError:
                margin = 50

            tools_gw.draw_by_json(complet_result, self.rubber_band, margin)
            self._reset_rubber_band()

        # Tab 'address' (streets)
        elif tab_selected == 'address' and 'id' in item and 'sys_id' not in item:
            polygon = item['st_astext']
            if polygon:
                polygon = polygon[9:len(polygon) - 2]
                polygon = polygon.split(',')
                x1, y1 = polygon[0].split(' ')
                x2, y2 = polygon[2].split(' ')
                tools_qgis.zoom_to_rectangle(x1, y1, x2, y2)
            else:
                message = f"Zoom unavailable. Doesn't exist the geometry for the street"
                tools_qgis.show_info(message, parameter=item['display_name'])

        # Tab 'address'
        elif tab_selected == 'address' and 'sys_x' in item and 'sys_y' in item:
            x1 = item['sys_x']
            y1 = item['sys_y']
            point = QgsPointXY(float(x1), float(y1))
            tools_qgis.draw_point(point, self.rubber_band, duration_time=5000)
            tools_qgis.zoom_to_rectangle(x1, y1, x1, y1, margin=100)
            self.canvas.refresh()

        # Tab 'hydro'
        elif tab_selected == 'hydro':
            x1 = item['sys_x']
            y1 = item['sys_y']
            point = QgsPointXY(float(x1), float(y1))
            tools_qgis.draw_point(point, self.rubber_band)
            tools_qgis.zoom_to_rectangle(x1, y1, x1, y1, margin=100)
            self._open_hydrometer_dialog(table_name=item['sys_table_id'], feature_id=item['sys_id'])

        # Tab 'workcat'
        elif tab_selected == 'workcat':
            list_coord = re.search('\(\((.*)\)\)', str(item['sys_geometry']))
            if not list_coord:
                msg = "Empty coordinate list"
                tools_qgis.show_warning(msg)
                return
            points = tools_qgis.get_geometry_vertex(list_coord)
            self._draw_polygon(points, self.rubber_band, fill_color=QColor(255, 0, 255, 25))
            max_x, max_y, min_x, min_y = tools_qgis.get_max_rectangle_from_coords(list_coord)
            tools_qgis.zoom_to_rectangle(max_x, max_y, min_x, min_y)
            self._workcat_open_table_items(item)
            return

        # Tab 'psector'
        elif tab_selected == 'psector':
            list_coord = re.search('\(\((.*)\)\)', str(item['sys_geometry']))
            self.manage_new_psector.get_psector(item['sys_id'], is_api=True)
            self.manage_new_psector.dlg_plan_psector.rejected.connect(self.rubber_band.reset)
            if not list_coord:
                msg = "Empty coordinate list"
                tools_qgis.show_warning(msg)
                return
            points = tools_qgis.get_geometry_vertex(list_coord)
            self._reset_rubber_band()
            self._draw_polygon(points, self.rubber_band, fill_color=QColor(255, 0, 255, 50))
            max_x, max_y, min_x, min_y = tools_qgis.get_max_rectangle_from_coords(list_coord)
            tools_qgis.zoom_to_rectangle(max_x, max_y, min_x, min_y, margin=50)

        # Tab 'visit'
        elif tab_selected == 'visit':
            list_coord = re.search('\((.*)\)', str(item['sys_geometry']))
            if not list_coord:
                msg = "Empty coordinate list"
                tools_qgis.show_info(msg)
                self.manage_visit.get_visit(visit_id=item['sys_id'])
                return
            max_x, max_y, min_x, min_y = tools_qgis.get_max_rectangle_from_coords(list_coord)
            self._reset_rubber_band()
            point = QgsPointXY(float(max_x), float(max_y))
            tools_qgis.draw_point(point, self.rubber_band)
            tools_qgis.zoom_to_rectangle(max_x, max_y, min_x, min_y, margin=100)
            self.manage_visit.get_visit(visit_id=item['sys_id'])
            self.manage_visit.dlg_add_visit.rejected.connect(self.rubber_band.reset)
            return

        self.lbl_visible = False
        self.dlg_search.lbl_msg.setVisible(self.lbl_visible)


    def _make_list(self, completer, model, widget):
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
            id = tools_qt.get_combo_value(self.dlg_search, combo, 0)
            name = tools_qt.get_combo_value(self.dlg_search, combo, 1)
            try:
                feature_type = tools_qt.get_combo_value(self.dlg_search, combo, 2)
                extras_search += f'"searchType":"{feature_type}", '
            except IndexError:
                pass
            extras_search += f'"{combo.property("columnname")}":{{"id":"{id}", "name":"{name}"}}, '
            extras_search_add += f'"{combo.property("columnname")}":{{"id":"{id}", "name":"{name}"}}, '

        if line_list:
            line_edit = line_list[0]
            # If current tab have more than one QLineEdit, clear second QLineEdit
            if len(line_list) == 2:
                line_edit.textChanged.connect(partial(self._clear_line_edit_add, line_list))

            value = tools_qt.get_text(self.dlg_search, line_edit, return_string_null=False)
            if str(value) == '':
                return

            qgis_project_add_schema = tools_qgis.get_plugin_settings_value('gwAddSchema')
            extras_search += f'"{line_edit.property("columnname")}":{{"text":"{value}"}}, '
            extras_search += f'"addSchema":"{qgis_project_add_schema}"'
            extras_search_add += f'"{line_edit.property("columnname")}":{{"text":"{value}"}}'
            body = tools_gw.create_body(form=form_search, extras=extras_search)
            result = tools_gw.execute_procedure('gw_fct_setsearch', body, rubber_band=self.rubber_band)
            if not result or result['status'] == 'Failed':
                return False

            if result:
                self.result_data = result

        # Set label visible
        display_list = []
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

            # Get list of items from returned json from database and make a list for completer
            for data in self.result_data['data']:
                display_list.append(data['display_name'])
            tools_qt.set_completer_object(completer, model, widget, sorted(display_list))

        if len(line_list) == 2:
            line_edit_add = line_list[1]
            value = tools_qt.get_text(self.dlg_search, line_edit_add)
            if str(value) in display_list:
                if line_edit:
                    line_edit.setText(value)
                return
            if str(value) == 'null':
                return

            extras_search_add += f', "{line_edit_add.property("columnname")}":{{"text":"{value}"}}'
            body = tools_gw.create_body(form=form_search_add, extras=extras_search_add)
            result = tools_gw.execute_procedure('gw_fct_setsearchadd', body, rubber_band=self.rubber_band)
            if not result or result['status'] == 'Failed':
                return False

            self.result_data = result
            if result is not None:
                display_list = []
                for data in self.result_data['data']:
                    display_list.append(data['display_name'])
                tools_qt.set_completer_object(completer, model, line_edit_add, sorted(display_list))


    def _clear_line_edit_add(self, line_list):
        """ Clear second line edit if exist """

        line_edit_add = line_list[1]
        line_edit_add.blockSignals(True)
        line_edit_add.setText('')
        line_edit_add.blockSignals(False)


    def _add_combobox(self, field):

        widget = QComboBox()
        widget.setObjectName(field['widgetname'])
        widget.setProperty('columnname', field['columnname'])
        list_items = self._get_list_items(widget, field)
        tools_qt.fill_combo_values(widget, list_items, 1)
        if 'selectedId' in field:
            tools_qt.set_combo_value(widget, field['selectedId'], 0)
        # noinspection PyUnresolvedReferences
        widget.currentIndexChanged.connect(partial(self._clear_lineedits))

        return widget


    def _clear_lineedits(self):

        # Clear all lineedit widgets from search tabs
        for widget in self.lineedit_list:
            tools_qt.set_widget_text(self.dlg_search, widget, '')


    def _get_list_items(self, widget, field):

        # Generate list of items to add into combo
        widget.blockSignals(True)
        widget.clear()
        widget.blockSignals(False)
        list_items = []
        if 'comboIds' in field:
            for i in range(0, len(field['comboIds'])):
                if 'comboFeature' in field:
                    elem = [field['comboIds'][i], field['comboNames'][i], field['comboFeature'][i]]
                else:
                    elem = [field['comboIds'][i], field['comboNames'][i]]
                list_items.append(elem)
        return list_items


    def _open_hydrometer_dialog(self, table_name=None, feature_id=None):

        # get sys variale
        qgis_project_infotype = tools_qgis.get_plugin_settings_value('infoType')

        feature = f'"tableName":"{table_name}", "id":"{feature_id}"'
        extras = f'"infoType":"{qgis_project_infotype}"'
        body = tools_gw.create_body(feature=feature, extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_getinfofromid', body)
        if json_result is None or json_result['status'] == 'Failed':
            return
        result = json_result

        self.hydro_info_dlg = GwInfoGenericUi()
        tools_gw.load_settings(self.hydro_info_dlg)

        self.hydro_info_dlg.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.hydro_info_dlg))
        self.hydro_info_dlg.rejected.connect(partial(tools_gw.close_dialog, self.hydro_info_dlg))
        self.hydro_info_dlg.rejected.connect(self._reset_rubber_band)
        tools_gw.build_dialog_info(self.hydro_info_dlg, result)
        tools_gw.open_dialog(self.hydro_info_dlg, dlg_name='info_generic')


    def _workcat_open_table_items(self, item):
        """ Create the view and open the dialog with his content """

        workcat_id = item['sys_id']
        field_id = item['filter_text']
        display_name = item['display_name']
        if workcat_id is None:
            return False

        self._update_selector_workcat(workcat_id)
        current_selectors = self._get_current_selectors()
        self._force_expl(workcat_id)
        # TODO ZOOM TO SELECTED WORKCAT
        # self.zoom_to_polygon(workcat_id, layer_name, field_id)

        self.items_dialog = GwSearchWorkcatUi()

        tools_gw.add_icon(self.items_dialog.btn_doc_insert, "111")
        tools_gw.add_icon(self.items_dialog.btn_doc_delete, "112")
        tools_gw.add_icon(self.items_dialog.btn_doc_new, "34")
        tools_gw.add_icon(self.items_dialog.btn_open_doc, "170")

        tools_gw.load_settings(self.items_dialog)
        self.items_dialog.btn_state1.setEnabled(False)
        self.items_dialog.btn_state0.setEnabled(False)

        search_csv_path = tools_gw.get_config_parser('btn_search', 'search_csv_path', "user", "session")
        tools_qt.set_widget_text(self.items_dialog, self.items_dialog.txt_path, search_csv_path)

        self.items_dialog.tbl_psm.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.items_dialog.tbl_psm.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
        self.items_dialog.tbl_psm_end.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.items_dialog.tbl_psm_end.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
        self.items_dialog.tbl_document.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.items_dialog.tbl_document.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)

        self._set_enable_qatable_by_state(self.items_dialog.tbl_psm, 1, self.items_dialog.btn_state1)
        self._set_enable_qatable_by_state(self.items_dialog.tbl_psm_end, 0, self.items_dialog.btn_state0)

        # Create list for completer QLineEdit
        sql = "SELECT DISTINCT(id) FROM v_ui_document ORDER BY id"
        list_items = tools_db.create_list_for_completer(sql)
        tools_qt.set_completer_lineedit(self.items_dialog.doc_id, list_items)

        table_name = "v_ui_workcat_x_feature"
        table_name_end = "v_ui_workcat_x_feature_end"
        table_doc = "v_ui_doc_x_workcat"
        self.items_dialog.btn_doc_insert.clicked.connect(
            partial(self._document_insert, self.items_dialog, 'doc_x_workcat', 'workcat_id', item['sys_id']))
        self.items_dialog.btn_doc_delete.clicked.connect(partial(tools_qt.delete_rows_tableview, self.items_dialog.tbl_document))
        self.items_dialog.btn_doc_new.clicked.connect(
            partial(self._manage_document, self.items_dialog.tbl_document, item['sys_id']))
        self.items_dialog.btn_open_doc.clicked.connect(partial(tools_qt.document_open, self.items_dialog.tbl_document, 'path'))
        self.items_dialog.tbl_document.doubleClicked.connect(
            partial(tools_qt.document_open, self.items_dialog.tbl_document, 'path'))

        self.items_dialog.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.items_dialog))
        self.items_dialog.btn_path.clicked.connect(
            partial(self._get_folder_dialog, self.items_dialog, self.items_dialog.txt_path))
        self.items_dialog.rejected.connect(partial(self._restore_selectors, current_selectors))
        self.items_dialog.rejected.connect(partial(tools_gw.close_dialog, self.items_dialog))
        self.items_dialog.rejected.connect(self._reset_rubber_band)
        self.items_dialog.btn_state1.clicked.connect(
            partial(self._force_state, self.items_dialog.btn_state1, 1, self.items_dialog.tbl_psm))
        self.items_dialog.btn_state0.clicked.connect(
            partial(self._force_state, self.items_dialog.btn_state0, 0, self.items_dialog.tbl_psm_end))
        self.items_dialog.btn_export_to_csv.clicked.connect(
            partial(self.export_to_csv, self.items_dialog, self.items_dialog.tbl_psm, self.items_dialog.tbl_psm_end,
                    self.items_dialog.txt_path))

        self.items_dialog.txt_name.textChanged.connect(partial(
            self._workcat_filter_by_text, self.items_dialog, self.items_dialog.tbl_psm, self.items_dialog.txt_name,
            table_name, workcat_id, field_id))
        self.items_dialog.txt_name_end.textChanged.connect(partial(
            self._workcat_filter_by_text, self.items_dialog, self.items_dialog.tbl_psm_end,
            self.items_dialog.txt_name_end, table_name_end, workcat_id, field_id))
        self.items_dialog.tbl_psm.doubleClicked.connect(partial(self._open_feature_form, self.items_dialog.tbl_psm))
        self.items_dialog.tbl_psm.clicked.connect(partial(self._get_parameters, self.items_dialog.tbl_psm))
        self.items_dialog.tbl_psm_end.doubleClicked.connect(partial(self._open_feature_form, self.items_dialog.tbl_psm_end))
        self.items_dialog.tbl_psm_end.clicked.connect(partial(self._get_parameters, self.items_dialog.tbl_psm_end))

        expr = "workcat_id ILIKE '%" + str(workcat_id) + "%'"
        self._workcat_fill_table(self.items_dialog.tbl_psm, table_name, expr=expr)
        tools_gw.set_tablemodel_config(self.items_dialog, self.items_dialog.tbl_psm, table_name)
        expr = "workcat_id ILIKE '%" + str(workcat_id) + "%'"
        self._workcat_fill_table(self.items_dialog.tbl_psm_end, table_name_end, expr=expr)
        tools_gw.set_tablemodel_config(self.items_dialog, self.items_dialog.tbl_psm_end, table_name_end)
        expr = "workcat_id ILIKE '%" + str(workcat_id) + "%'"
        self._workcat_fill_table(self.items_dialog.tbl_document, table_doc, expr=expr)
        tools_gw.set_tablemodel_config(self.items_dialog, self.items_dialog.tbl_document, table_doc)

        #
        # Add data to workcat search form
        table_name = "v_ui_workcat_x_feature"
        table_name_end = "v_ui_workcat_x_feature_end"
        extension = '_end'
        self._fill_label_data(workcat_id, table_name)
        self._fill_label_data(workcat_id, table_name_end, extension)

        tools_gw.open_dialog(self.items_dialog, dlg_name='search_workcat')
        title = self.items_dialog.windowTitle()
        self.items_dialog.setWindowTitle(f"{title} - {display_name}")
        text = tools_qt.get_text(self.items_dialog, self.items_dialog.lbl_init, False, False)
        tools_qt.set_widget_text(self.items_dialog, self.items_dialog.lbl_init, f"{text} {field_id}")
        text = tools_qt.get_text(self.items_dialog, self.items_dialog.lbl_end, False, False)
        tools_qt.set_widget_text(self.items_dialog, self.items_dialog.lbl_end, f"{text} {field_id}")


    def _manage_document(self, qtable, item_id):
        """ Access GUI to manage documents e.g Execute action of button 34 """

        manage_document = GwDocument(single_tool=False)
        dlg_docman = manage_document.get_document(tablename='workcat', qtable=qtable, item_id=item_id)
        dlg_docman.btn_accept.clicked.connect(partial(tools_gw.set_completer_object, dlg_docman, 'doc'))
        tools_qt.remove_tab(dlg_docman.tabWidget, 'tab_rel')


    def _get_current_selectors(self):
        """ Take the current selector_expl and selector_state to restore them at the end of the operation """

        current_tab = tools_gw.get_config_parser('dialogs_tab', 'selector_basic', "user", "session")
        form = f'"currentTab":"{current_tab}"'
        extras = f'"selectorType":"selector_basic", "filterText":""'
        body = tools_gw.create_body(form=form, extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_getselectors', body)
        return json_result


    def _restore_selectors(self, current_selectors):
        """ Restore selector_expl and selector_state to how the user had it """

        qgis_project_add_schema = tools_qgis.get_plugin_settings_value('gwAddSchema')
        for form_tab in current_selectors['body']['form']['formTabs']:
            if form_tab['tableName'] not in ('selector_expl', 'selector_state'):
                continue
            selector_type = form_tab['selectorType']
            tab_name = form_tab['tabName']
            field_id = None
            if form_tab['tableName'] == 'selector_expl':
                field_id = 'expl_id'
            elif form_tab['tableName'] == 'selector_state':
                field_id = 'id'
            for field in form_tab['fields']:
                _id = field[field_id]
                extras = (f'"selectorType":"{selector_type}", "tabName":"{tab_name}", '
                          f'"id":"{_id}", "isAlone":"False", "value":"{field["value"]}", '
                          f'"addSchema":"{qgis_project_add_schema}"')
                body = tools_gw.create_body(extras=extras)
                tools_gw.execute_procedure('gw_fct_setselectors', body)
        tools_qgis.refresh_map_canvas()


    def _force_expl(self, workcat_id):
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
        rows = tools_db.get_rows(sql)
        if not rows:
            return

        if len(rows) > 0:
            for row in rows:
                sql = (f"INSERT INTO selector_expl(expl_id, cur_user) "
                       f" VALUES('{row[0]}', current_user)")
                tools_db.execute_sql(sql)
            msg = "Your exploitation selector has been updated"
            tools_qgis.show_info(msg)


    def _update_selector_workcat(self, workcat_id):
        """ Update table selector_workcat """

        sql = ("DELETE FROM selector_workcat "
               " WHERE cur_user = current_user;\n")
        sql += (f"INSERT INTO selector_workcat(workcat_id, cur_user) "
                f" VALUES('{workcat_id}', current_user);\n")
        tools_db.execute_sql(sql)


    def _set_enable_qatable_by_state(self, qtable, _id, qbutton):

        sql = (f"SELECT state_id FROM selector_state "
               f" WHERE cur_user = current_user AND state_id ='{_id}'")
        row = tools_db.get_row(sql)
        if row is None:
            qtable.setEnabled(False)
            qbutton.setEnabled(True)


    def _get_folder_dialog(self, dialog, widget):
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
        folder_path, filter_ = file_dialog.getSaveFileName(None, tools_qt.tr(msg), folder_path, '*.csv')
        if folder_path:
            tools_qt.set_widget_text(dialog, widget, str(folder_path))


    def _force_state(self, qbutton, state, qtable):
        """ Force selected state and set qtable enabled = True """

        sql = (f"SELECT state_id "
               f"FROM selector_state "
               f"WHERE cur_user = current_user AND state_id = '{state}'")
        row = tools_db.get_row(sql)
        if row:
            return

        sql = (f"INSERT INTO selector_state(state_id, cur_user) "
               f"VALUES('{state}', current_user)")
        tools_db.execute_sql(sql)
        qtable.setEnabled(True)
        qbutton.setEnabled(False)
        tools_qgis.refresh_map_canvas()
        qtable.model().select()


    def _write_to_csv(self, dialog, folder_path=None, all_rows=None):

        with open(folder_path, "w") as output:
            writer = csv.writer(output, lineterminator='\n')
            writer.writerows(all_rows)
        tools_gw.set_config_parser('btn_search', 'search_csv_path', f"{tools_qt.get_text(dialog, 'txt_path')}")
        message = "The csv file has been successfully exported"
        tools_qgis.show_info(message)


    def _workcat_filter_by_text(self, dialog, qtable, widget_txt, table_name, workcat_id, field_id):
        """ Filter list of workcats by workcat_id and field_id """

        result_select = tools_qt.get_text(dialog, widget_txt)
        if result_select != 'null':
            expr = (f"workcat_id = '{workcat_id}'"
                    f" and {field_id} ILIKE '%{result_select}%'")
        else:
            expr = f"workcat_id ILIKE '%{workcat_id}%'"
        self._workcat_fill_table(qtable, table_name, expr=expr)
        tools_gw.set_tablemodel_config(dialog, qtable, table_name)


    def _workcat_fill_table(self, widget, table_name, set_edit_triggers=QTableView.NoEditTriggers, expr=None):
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
        model = QSqlTableModel(db=global_vars.qgis_db_credentials)
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnFieldChange)
        model.setSort(0, 0)
        model.select()

        widget.setEditTriggers(set_edit_triggers)
        # Check for errors
        if model.lastError().isValid():
            tools_qgis.show_warning(model.lastError().text())
        # Attach model to table view
        if expr:
            widget.setModel(model)
            widget.model().setFilter(expr)
        else:
            widget.setModel(model)


    def _open_feature_form(self, qtable):
        """ Zoom feature with the code set in 'network_code' of the layer set in 'network_feature_type' """

        tools_gw.reset_rubberband(self.aux_rubber_band)
        # Get selected code from combo
        element = qtable.selectionModel().selectedRows()
        if len(element) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return

        row = element[0].row()

        feature_type = qtable.model().record(row).value('feature_type').lower()
        table_name = "v_edit_" + feature_type

        feature_id = qtable.model().record(row).value('feature_id')

        self.customForm = GwInfo(tab_type='data')
        complet_result, dialog = self.customForm.get_info_from_id(table_name, feature_id, 'data')

        # Get list of all coords in field geometry
        try:
            list_coord = re.search('\((.*)\)', str(complet_result['body']['feature']['geometry']['st_astext']))
            max_x, max_y, min_x, min_y = tools_qgis.get_max_rectangle_from_coords(list_coord)
            tools_qgis.zoom_to_rectangle(max_x, max_y, min_x, min_y, 1)
        except Exception:
            pass


    def _fill_label_data(self, workcat_id, table_name, extension=None):

        if workcat_id == "null":
            return

        features = ['NODE', 'CONNEC', 'GULLY', 'ELEMENT', 'ARC']
        for feature in features:
            sql = (f"SELECT feature_id "
                   f" FROM {table_name}")
            sql += f" WHERE workcat_id = '{workcat_id}' AND feature_type = '{feature}'"
            rows = tools_db.get_rows(sql)
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
                    row = tools_db.get_row(sql)
                    if row:
                        length = length + row[0]
                    else:
                        message = "Some data is missing. Check gis_length for arc"
                        tools_qgis.show_warning(message, parameter=arc_id)
                        return
                if extension is not None:
                    widget = self.items_dialog.findChild(QLabel, f"lbl_length{extension}")
                else:
                    widget = self.items_dialog.findChild(QLabel, "lbl_length")

                # Add data to workcat search form
                widget.setText(f"Total arcs length: {length}")


    def _draw_polygon(self, points, rubber_band, border=QColor(255, 0, 0, 100), width=3, duration_time=None, fill_color=None):
        """
        Draw 'polygon' over canvas following list of points
            :param duration_time: integer milliseconds ex: 3000 for 3 seconds
        """

        rubber_band.setIconSize(20)
        polygon = QgsGeometry.fromPolygonXY([points])
        rubber_band.setToGeometry(polygon, None)
        rubber_band.setColor(border)
        if fill_color:
            rubber_band.setFillColor(fill_color)
        rubber_band.setWidth(width)
        rubber_band.show()

        # wait to simulate a flashing effect
        if duration_time is not None:
            QTimer.singleShot(duration_time, rubber_band.reset)


    def _document_insert(self, dialog, tablename, field, field_value):
        """
        Insert a document related to the current visit
            :param dialog: (QDialog )
            :param tablename: Name of the table to make the queries (String)
            :param field: Field of the table to make the where clause (String)
            :param field_value: Value to compare in the clause where (String)
        """

        doc_id = dialog.doc_id.text()
        if not doc_id:
            message = "You need to insert doc_id"
            tools_qgis.show_warning(message)
            return

        # Check if document already exist
        sql = (f"SELECT doc_id"
               f" FROM {tablename}"
               f" WHERE doc_id = '{doc_id}' AND {field} = '{field_value}'")
        row = tools_db.get_row(sql)
        if row:
            msg = "Document already exist"
            tools_qgis.show_warning(msg)
            return

        # Insert into new table
        sql = (f"INSERT INTO {tablename} (doc_id, {field})"
               f" VALUES ('{doc_id}', '{field_value}')")
        status = tools_db.execute_sql(sql)
        if status:
            message = "Document inserted successfully"
            tools_qgis.show_info(message)

        dialog.tbl_document.model().select()


    def _get_parameters(self, qtable, index):

        tools_gw.reset_rubberband(self.aux_rubber_band)
        row = index.row()
        column_index = tools_qt.get_col_index_by_col_name(qtable, 'feature_type')
        feature_type = index.sibling(row, column_index).data().lower()
        column_index = tools_qt.get_col_index_by_col_name(qtable, 'feature_id')
        feature_id = index.sibling(row, column_index).data()
        layer = tools_qgis.get_layer_by_tablename(f"v_edit_{feature_type}")
        if not layer:
            return

        feature = tools_qt.get_feature_by_id(layer, feature_id, f"{feature_type}_id")
        try:
            width = {"arc": 5}
            geometry = feature.geometry()
            self.aux_rubber_band.setToGeometry(geometry, None)
            self.aux_rubber_band.setColor(QColor(255, 0, 0, 125))
            self.aux_rubber_band.setWidth(width.get(feature_type, 10))
            self.aux_rubber_band.show()
        except AttributeError:
            pass

    # endregion
