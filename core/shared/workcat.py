"""
This file is part of Pavements
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import re
import csv
import os
from functools import partial

from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtGui import QColor
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtWidgets import QAbstractItemView, QTableView, QFileDialog, QLabel, QHeaderView

from .document import GwDocument
from .info import GwInfo
from ..ui.ui_manager import GwWorkcatManagerUi
from ..utils import tools_gw
from ...libs import tools_qgis, tools_db, tools_qt, lib_vars

class GwWorkcat:
    def __init__(self, iface, canvas):
        self.iface = iface
        self.canvas = canvas
        self.schema_name = lib_vars.schema_name
        self.project_type = tools_gw.get_project_type()
        self.rubber_band = tools_gw.create_rubberband(self.canvas)
        self.aux_rubber_band = tools_gw.create_rubberband(self.canvas)
        self.items_dialog = None

    def open_workcat_manager(self):
        print("Opening Workcat Manager...")
        self.items_dialog = GwWorkcatManagerUi()
        print("UI Loaded")

        tools_gw.add_icon(self.items_dialog.btn_doc_insert, "111", sub_folder="24x24")
        tools_gw.add_icon(self.items_dialog.btn_doc_delete, "112", sub_folder="24x24")
        tools_gw.add_icon(self.items_dialog.btn_doc_new, "34", sub_folder="24x24")
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
            partial(self._document_insert, self.items_dialog, 'doc_x_workcat', 'workcat_id', 'workcat'))
        self.items_dialog.btn_doc_delete.clicked.connect(
            partial(tools_gw.delete_selected_rows, self.items_dialog.tbl_document, 'doc_x_workcat'))
        self.items_dialog.btn_doc_new.clicked.connect(
            partial(self._manage_document, self.items_dialog.tbl_document, 'workcat'))
        self.items_dialog.btn_open_doc.clicked.connect(partial(tools_qt.document_open, self.items_dialog.tbl_document, 'path'))
        self.items_dialog.tbl_document.doubleClicked.connect(
            partial(tools_qt.document_open, self.items_dialog.tbl_document, 'path'))

        self.items_dialog.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.items_dialog))
        self.items_dialog.btn_path.clicked.connect(
            partial(self._get_folder_dialog, self.items_dialog, self.items_dialog.txt_path))
        self.items_dialog.rejected.connect(partial(tools_gw.close_dialog, self.items_dialog))
        self.items_dialog.rejected.connect(self._reset_rubber_band)
        self.items_dialog.btn_state1.clicked.connect(
            partial(self._force_state, self.items_dialog.btn_state1, 1, self.items_dialog.tbl_psm))
        self.items_dialog.btn_state0.clicked.connect(
            partial(self._force_state, self.items_dialog.btn_state0, 0, self.items_dialog.tbl_psm_end))
        self.items_dialog.btn_export_to_csv.clicked.connect(
            partial(self._export_to_csv, self.items_dialog, self.items_dialog.tbl_psm, self.items_dialog.tbl_psm_end,
                    self.items_dialog.txt_path))

        self.items_dialog.txt_name.textChanged.connect(partial(
            self._workcat_filter_by_text, self.items_dialog, self.items_dialog.tbl_psm, self.items_dialog.txt_name,
            table_name, 'workcat', 'name'))
        self.items_dialog.txt_name_end.textChanged.connect(partial(
            self._workcat_filter_by_text, self.items_dialog, self.items_dialog.tbl_psm_end,
            self.items_dialog.txt_name_end, table_name_end, 'workcat', 'name'))
        self.items_dialog.tbl_psm.doubleClicked.connect(partial(self._open_feature_form, self.items_dialog.tbl_psm))
        self.items_dialog.tbl_psm.clicked.connect(partial(self._get_parameters, self.items_dialog.tbl_psm))
        self.items_dialog.tbl_psm_end.doubleClicked.connect(partial(self._open_feature_form, self.items_dialog.tbl_psm_end))
        self.items_dialog.tbl_psm_end.clicked.connect(partial(self._get_parameters, self.items_dialog.tbl_psm_end))

        expr = "workcat_id ILIKE '%%'"
        self._workcat_fill_table(self.items_dialog.tbl_psm, table_name, expr=expr)
        tools_gw.set_tablemodel_config(self.items_dialog, self.items_dialog.tbl_psm, table_name)
        self._workcat_fill_table(self.items_dialog.tbl_psm_end, table_name_end, expr=expr)
        tools_gw.set_tablemodel_config(self.items_dialog, self.items_dialog.tbl_psm_end, table_name_end)
        self._workcat_fill_table(self.items_dialog.tbl_document, table_doc, expr=expr)
        tools_gw.set_tablemodel_config(self.items_dialog, self.items_dialog.tbl_document, table_doc)

        tools_gw.open_dialog(self.items_dialog, dlg_name='search_workcat')

    def _document_insert(self, dialog, tablename, field, field_value):
        try:
            doc_id = dialog.doc_id.text()
            if not doc_id:
                raise ValueError("You need to insert doc_id")

            sql = f"SELECT doc_id FROM {tablename} WHERE doc_id = '{doc_id}' AND {field} = '{field_value}'"
            row = tools_db.get_row(sql)
            if row:
                raise ValueError("Document already exist")

            sql = f"INSERT INTO {tablename} (doc_id, {field}) VALUES ('{doc_id}', '{field_value}')"
            status = tools_db.execute_sql(sql)
            if status:
                tools_qgis.show_info("Document inserted successfully", dialog=dialog)

            dialog.tbl_document.model().select()
        except Exception as e:
            tools_qgis.show_warning("Error inserting document", message=str(e))

    def _get_folder_dialog(self, dialog, widget):
        try:
            widget.setStyleSheet(None)
            folder_path = os.path.expanduser("~/Documents" if os.name == 'nt' else "~")

            os.chdir(folder_path)
            file_dialog = QFileDialog()
            file_dialog.setFileMode(QFileDialog.Directory)

            msg = "Save as"
            folder_path, filter_ = file_dialog.getSaveFileName(None, tools_qt.tr(msg), folder_path, '*.csv')
            if folder_path:
                tools_qt.set_widget_text(dialog, widget, str(folder_path))
        except Exception as e:
            tools_qgis.show_warning("Error getting folder dialog", message=str(e))

    def _force_state(self, qbutton, state, qtable):
        try:
            sql = f"SELECT state_id FROM selector_state WHERE cur_user = current_user AND state_id = '{state}'"
            row = tools_db.get_row(sql)
            if row:
                return

            sql = f"INSERT INTO selector_state(state_id, cur_user) VALUES ('{state}', current_user)"
            tools_db.execute_sql(sql)
            qtable.setEnabled(True)
            qbutton.setEnabled(False)
            tools_qgis.refresh_map_canvas()
            qtable.model().select()
        except Exception as e:
            tools_qgis.show_warning("Error forcing state", message=str(e))

    def _workcat_filter_by_text(self, dialog, qtable, widget_txt, table_name, workcat_id, field_id):
        try:
            result_select = tools_qt.get_text(dialog, widget_txt)
            if result_select != 'null':
                expr = f"workcat_id = '{workcat_id}' and {field_id} ILIKE '%{result_select}%'"
            else:
                expr = f"workcat_id ILIKE '%{workcat_id}%'"
            self._workcat_fill_table(qtable, table_name, expr=expr)
            tools_gw.set_tablemodel_config(dialog, qtable, table_name)
        except Exception as e:
            tools_qgis.show_warning("Error filtering workcat by text", message=str(e))

    def _workcat_fill_table(self, widget, table_name, set_edit_triggers=QTableView.NoEditTriggers, expr=None):
        try:
            if self.schema_name not in table_name:
                table_name = self.schema_name + "." + table_name

            model = QSqlTableModel(db=lib_vars.qgis_db_credentials)
            model.setTable(table_name)
            model.setEditStrategy(QSqlTableModel.OnFieldChange)
            model.setSort(0, 0)
            model.select()

            widget.setEditTriggers(set_edit_triggers)
            if model.lastError().isValid():
                if 'Unable to find table' in model.lastError().text():
                    tools_db.reset_qsqldatabase_connection(self.items_dialog)
                else:
                    tools_qgis.show_warning(model.lastError().text(), dialog=self.items_dialog)

            if expr:
                model.setFilter(expr)

            widget.setModel(model)
        except Exception as e:
            tools_qgis.show_warning("Error filling workcat table", message=str(e))

    def _open_feature_form(self, qtable):
        try:
            tools_gw.reset_rubberband(self.aux_rubber_band)
            element = qtable.selectionModel().selectedRows()
            if len(element) == 0:
                raise ValueError("Any record selected")

            row = element[0].row()

            feature_type = qtable.model().record(row).value('feature_type').lower()
            table_name = "v_edit_" + feature_type
            feature_id = qtable.model().record(row).value('feature_id')

            self.customForm = GwInfo(tab_type='data')
            complet_result, dialog = self.customForm.get_info_from_id(table_name, feature_id, 'data')

            try:
                list_coord = re.search('\((.*)\)', str(complet_result['body']['feature']['geometry']['st_astext']))
                max_x, max_y, min_x, min_y = tools_qgis.get_max_rectangle_from_coords(list_coord)
                tools_qgis.zoom_to_rectangle(max_x, max_y, min_x, min_y, 1)
            except Exception:
                pass
        except Exception as e:
            tools_qgis.show_warning("Error opening feature form", message=str(e))

    def _set_enable_qatable_by_state(self, qtable, _id, qbutton):
        try:
            sql = f"SELECT state_id FROM selector_state WHERE cur_user = current_user AND state_id ='{_id}'"
            row = tools_db.get_row(sql)
            if row is None:
                qtable.setEnabled(False)
                qbutton.setEnabled(True)
        except Exception as e:
            tools_qgis.show_warning("Error setting enable qatable by state", message=str(e))

    def _reset_rubber_band(self):
        try:
            tools_gw.reset_rubberband(self.rubber_band)
            tools_gw.reset_rubberband(self.aux_rubber_band)
        except Exception as e:
            tools_qgis.show_warning("Error resetting rubber band", message=str(e))

    def _export_to_csv(self, dialog, qtable_1=None, qtable_2=None, path=None):
        try:
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
                tools_qgis.show_warning(msg, dialog=dialog)
        except Exception as e:
            tools_qgis.show_warning("Error exporting to CSV", message=str(e))

    def _write_to_csv(self, dialog, folder_path=None, all_rows=None):
        try:
            with open(folder_path, "w") as output:
                writer = csv.writer(output, lineterminator='\n')
                writer.writerows(all_rows)
            tools_gw.set_config_parser('btn_search', 'search_csv_path', f"{tools_qt.get_text(dialog, 'txt_path')}")
            tools_qgis.show_info("The csv file has been successfully exported", dialog=dialog)
        except Exception as e:
            tools_qgis.show_warning("Error writing to CSV", message=str(e))

    def _manage_document(self, qtable, item_id):
        try:
            """ Access GUI to manage documents e.g Execute action of button 34 """

            manage_document = GwDocument(single_tool=False)
            dlg_docman = manage_document.get_document(tablename='workcat', qtable=qtable, item_id=item_id)
            dlg_docman.btn_accept.clicked.connect(partial(tools_gw.set_completer_object, dlg_docman, 'doc'))
            tools_qt.remove_tab(dlg_docman.tabWidget, 'tab_rel')
        except Exception as e:
            tools_qgis.show_warning("Error managing document", message=str(e))

    def _get_parameters(self, qtable, index):
        try:
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
        except Exception as e:
            tools_qgis.show_warning("Error getting parameters", message=str(e))
