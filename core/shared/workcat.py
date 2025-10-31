"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import csv
import os
import re
from functools import partial

from qgis.PyQt.QtCore import QDate, Qt
from qgis.PyQt.QtGui import QColor, QStandardItemModel, QCursor
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtWidgets import QAbstractItemView, QLabel, QHeaderView, QTableView, QMenu, QAction, QPushButton
from qgis.core import QgsExpression

from .document import GwDocument
from ..ui.ui_manager import GwWorkcatManagerUi, GwInfoWorkcatUi, GwSearchWorkcatUi
from ..utils import tools_gw
from ...libs import lib_vars, tools_db, tools_qgis, tools_qt, tools_os


class GwWorkcat:
    def __init__(self, iface, canvas):
        self.iface = iface
        self.canvas = canvas
        self.schema_name = lib_vars.schema_name
        self.project_type = tools_gw.get_project_type()
        self.rubber_band = tools_gw.create_rubberband(self.canvas)
        self.aux_rubber_band = tools_gw.create_rubberband(self.canvas)
        self.items_dialog = None

    def manage_workcats(self):
        """ Manager to display and manage workcats """
        self.dlg_man = GwWorkcatManagerUi(self)
        self.dlg_man.setProperty('class_obj', self)
        tools_gw.load_settings(self.dlg_man)
        self.dlg_man.tbl_workcat.setSelectionBehavior(QAbstractItemView.SelectionBehavior.SelectRows)
        tools_qt.set_tableview_config(self.dlg_man.tbl_workcat)

        # Populate custom context menu
        self.dlg_man.tbl_workcat.setContextMenuPolicy(Qt.ContextMenuPolicy.CustomContextMenu)
        self.dlg_man.tbl_workcat.customContextMenuRequested.connect(partial(self._show_context_menu, self.dlg_man.tbl_workcat))

        # Auto-completion
        table_object = "workcat"
        tools_gw.set_completer_object(self.dlg_man, table_object, field_id="name")

        # Fill table
        status = self._fill_workcat_table()
        if not status:
            return False, False

        # Set signals
        self.dlg_man.workcat_name.textChanged.connect(self._fill_workcat_table)
        self.dlg_man.tbl_workcat.doubleClicked.connect(
            partial(self._open_selected_workcat, self.dlg_man, self.dlg_man.tbl_workcat))
        self.dlg_man.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_man))
        self.dlg_man.rejected.connect(partial(tools_gw.close_dialog, self.dlg_man))
        self.dlg_man.btn_delete.clicked.connect(self._handle_delete)
        self.dlg_man.btn_create.clicked.connect(partial(self.create_workcat))

        # Open form
        tools_gw.open_dialog(self.dlg_man, dlg_name='workcat_manager')

    def _handle_delete(self):
        tools_gw.delete_selected_rows(self.dlg_man.tbl_workcat, "cat_work")
        self._refresh_manager_table()

    def _fill_workcat_table(self, filter_text=None):
        view = "cat_work"
        if filter_text is None:
            filter_text = ""
        complet_list = tools_gw.get_list(view, filter_name=filter_text, id_field="id")
        if complet_list is False:
            return False
        for field in complet_list['body']['data']['fields']:
            if field.get('hidden'):
                continue
            model = self.dlg_man.tbl_workcat.model()
            if model is None:
                model = QStandardItemModel()
                self.dlg_man.tbl_workcat.setModel(model)
            model.removeRows(0, model.rowCount())
            if field['value']:
                self.dlg_man.tbl_workcat = tools_gw.add_tableview_header(self.dlg_man.tbl_workcat, field)
                self.dlg_man.tbl_workcat = tools_gw.fill_tableview_rows(self.dlg_man.tbl_workcat, field)
        tools_gw.set_tablemodel_config(self.dlg_man, self.dlg_man.tbl_workcat, 'cat_work', 0)
        tools_qt.set_tableview_config(self.dlg_man.tbl_workcat, sectionResizeMode=QHeaderView.ResizeMode.Interactive)
        return True

    def _open_selected_workcat(self, dialog, widget):
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            msg = "Any record selected"
            tools_qgis.show_warning(msg, dialog=dialog)
            return
        row = selected_list[0].row()
        field_object_id = "id"
        id_col_idx = tools_qt.get_col_index_by_col_name(widget, field_object_id)
        selected_object_id = widget.model().item(row, id_col_idx).text()

        keep_open_form = tools_gw.get_config_parser('dialogs_actions', 'workcat_manager_keep_open', "user", "init",
                                                    prefix=True)
        if tools_os.set_boolean(keep_open_form, False) is not True:
            dialog.close()

        self.open_workcat(selected_object_id)

    def open_workcat(self, workcat_id):
        item = {'sys_id': workcat_id, 'filter_text': '', 'display_name': 'Workcat Details'}
        self.workcat_open_table_items(item)

    def _refresh_manager_table(self):
        try:
            if getattr(self, 'dlg_man', None):
                self._fill_workcat_table()
        except Exception as e:
            print(f"Error refreshing manager table: {e}")

    def create_workcat(self):
        dialog = GwInfoWorkcatUi(self)
        tools_gw.load_settings(dialog)
        dialog.setWindowTitle("New Workcat")
        dialog.builtdate.setDate(QDate.currentDate())
        dialog.raise_()
        dialog.activateWindow()
        dialog.btn_accept.clicked.connect(partial(self._save_new_workcat, dialog))
        dialog.btn_cancel.clicked.connect(dialog.reject)

        dialog.cat_work_id.textChanged.connect(partial(self._check_workcat_exists, dialog))

        dialog.messageBar().hide()

        tools_gw.open_dialog(dialog, dlg_name='info_workcat')

    def _save_new_workcat(self, dialog):
        workid = dialog.cat_work_id.text()
        descript = dialog.descript.toPlainText()
        link = dialog.link.toPlainText()
        workid_key1 = dialog.workid_key_1.text()
        workid_key2 = dialog.workid_key_2.text()
        builddate = dialog.builtdate.date().toString("yyyy-MM-dd")

        sql = (f"INSERT INTO cat_work (id, descript, link, workid_key1, workid_key2, builtdate) "
               f"VALUES ('{workid}', '{descript}', '{link}', '{workid_key1}', '{workid_key2}', '{builddate}')")

        status = tools_db.execute_sql(sql)
        if status:
            msg = "Workcat created successfully."
            tools_qgis.show_info(msg)
            self._refresh_manager_table()
            dialog.accept()
        else:
            msg = "Error creating Workcat."
            tools_qgis.show_warning(msg)

    def _check_workcat_exists(self, dialog):
        workid = dialog.cat_work_id.text()
        sql = f"SELECT id FROM cat_work WHERE id = '{workid}'"
        row = tools_db.get_row(sql, log_info=False)
        if row:
            dialog.cat_work_id.setStyleSheet("border: 1px solid red")
            dialog.btn_accept.setEnabled(False)
            dialog.cat_work_id.setToolTip("Workcat ID already exists")
        else:
            dialog.cat_work_id.setStyleSheet("")
            dialog.btn_accept.setEnabled(True)
            dialog.cat_work_id.setToolTip("")

    def workcat_open_table_items(self, item):
        """ Create the view and open the dialog with his content """

        workcat_id = item['sys_id']
        field_id = item['filter_text']
        display_name = item['display_name']
        if workcat_id is None:
            return False
        if 'sys_geometry' not in item:
            sql = f"""
                SELECT row_to_json(row) FROM (SELECT 
                    CASE
                    WHEN st_geometrytype(st_concavehull(d.the_geom, 0.99::double precision)) = 'ST_Polygon'::text THEN st_astext(st_buffer(st_concavehull(d.the_geom, 0.99::double precision), 10::double precision)::geometry(Polygon, {lib_vars.project_epsg}))
                    ELSE st_astext(st_expand(st_buffer(d.the_geom, 10::double precision), 1::double precision)::geometry(Polygon, {lib_vars.project_epsg}))
                    END AS st_astext
                
                    FROM (SELECT st_collect(a.the_geom) AS the_geom, a.workcat_id FROM (  SELECT node.workcat_id, node.the_geom FROM node WHERE node.state = 1
                            UNION
                            SELECT arc.workcat_id, arc.the_geom FROM arc WHERE arc.state = 1
                            UNION
                            SELECT connec.workcat_id, connec.the_geom FROM connec WHERE connec.state = 1
                            UNION
                            SELECT element.workcat_id, element.the_geom FROM element WHERE element.state = 1
                            UNION
                            SELECT node.workcat_id_end AS workcat_id,node.the_geom FROM node WHERE node.state = 0
                            UNION
                            SELECT arc.workcat_id_end AS workcat_id, arc.the_geom FROM arc WHERE arc.state = 0
                            UNION
                            SELECT connec.workcat_id_end AS workcat_id,connec.the_geom FROM connec WHERE connec.state = 0
                            UNION  
                            SELECT element.workcat_id_end AS workcat_id, element.the_geom FROM element WHERE element.state = 0) a GROUP BY a.workcat_id ) d 
                
                    JOIN cat_work AS b ON d.workcat_id = b.id WHERE d.workcat_id::text = '{workcat_id}' LIMIT 1 )row
            """
            row = tools_db.get_row(sql)
            try:
                item['sys_geometry'] = row[0]['st_astext']
            except Exception:
                pass

        if 'sys_geometry' in item:
            # Zoom to result
            list_coord = re.search(r'\(\((.*)\)\)', str(item['sys_geometry']))
            if not list_coord:
                msg = "Empty coordinate list"
                tools_qgis.show_warning(msg)
                return
            points = tools_qgis.get_geometry_vertex(list_coord)
            tools_qgis.draw_polygon(points, self.rubber_band)
            max_x, max_y, min_x, min_y = tools_qgis.get_max_rectangle_from_coords(list_coord)
            tools_qgis.zoom_to_rectangle(max_x, max_y, min_x, min_y)

        self._update_selector_workcat(workcat_id)
        current_selectors = self._get_current_selectors()
        self._force_expl(workcat_id)

        self.items_dialog = GwSearchWorkcatUi(self)

        tools_gw.add_icon(self.items_dialog.btn_doc_insert, "111")
        tools_gw.add_icon(self.items_dialog.btn_doc_delete, "112")
        tools_gw.add_icon(self.items_dialog.btn_doc_new, "117")
        tools_gw.add_icon(self.items_dialog.btn_open_doc, "170")

        tools_gw.load_settings(self.items_dialog)
        self.items_dialog.btn_state1.setEnabled(False)
        self.items_dialog.btn_state0.setEnabled(False)

        search_csv_path = tools_gw.get_config_parser('btn_search', 'search_csv_path', "user", "session")
        tools_qt.set_widget_text(self.items_dialog, self.items_dialog.txt_path, search_csv_path)

        self.items_dialog.tbl_psm.setSelectionBehavior(QAbstractItemView.SelectionBehavior.SelectRows)
        self.items_dialog.tbl_psm.horizontalHeader().setSectionResizeMode(QHeaderView.ResizeMode.Stretch)
        self.items_dialog.tbl_psm_end.setSelectionBehavior(QAbstractItemView.SelectionBehavior.SelectRows)
        self.items_dialog.tbl_psm_end.horizontalHeader().setSectionResizeMode(QHeaderView.ResizeMode.Stretch)
        self.items_dialog.tbl_document.setSelectionBehavior(QAbstractItemView.SelectionBehavior.SelectRows)
        self.items_dialog.tbl_document.horizontalHeader().setSectionResizeMode(QHeaderView.ResizeMode.Stretch)

        self._set_enable_qatable_by_state(self.items_dialog.tbl_psm, 1, self.items_dialog.btn_state1)
        self._set_enable_qatable_by_state(self.items_dialog.tbl_psm_end, 0, self.items_dialog.btn_state0)

        # Create and configure QComboBox
        sql = "SELECT id, name as idval FROM v_ui_doc ORDER BY name"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.items_dialog.doc_id, rows, index_to_show=1, add_empty=True)
        tools_qt.set_autocompleter(self.items_dialog.doc_id)

        table_name = "v_ui_workcat_x_feature"
        table_name_end = "v_ui_workcat_x_feature_end"
        table_doc = "v_ui_doc_x_workcat"
        self.items_dialog.btn_doc_insert.clicked.connect(
            partial(self._document_insert, self.items_dialog, 'doc_x_workcat', 'workcat_id', item['sys_id']))
        self.items_dialog.btn_doc_delete.clicked.connect(partial(tools_gw.delete_selected_rows, self.items_dialog.tbl_document, 'doc_x_workcat'))
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

        # Select workcat features
        layers = [
            tools_qgis.get_layer_by_tablename("ve_arc"),
            tools_qgis.get_layer_by_tablename("ve_node"),
            tools_qgis.get_layer_by_tablename("ve_connec"),
            tools_qgis.get_layer_by_tablename("ve_link"),
            tools_qgis.get_layer_by_tablename("ve_man_frelem"),
            tools_qgis.get_layer_by_tablename("ve_man_genelem"),
            tools_qgis.get_layer_by_tablename("ve_gully"),
        ]
        expr = QgsExpression(expr)
        for lyr in layers:
            if lyr is None:
                continue
            tools_qgis.select_features_by_expr(lyr, expr)

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
        extras = '"selectorType":"selector_basic", "filterText":""'
        body = tools_gw.create_body(form=form, extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_getselectors', body)
        return json_result

    def _restore_selectors(self, current_selectors):
        """ Restore selector_expl and selector_state to how the user had it """

        qgis_project_add_schema = lib_vars.project_vars['add_schema']
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

        tools_qt.get_save_file_path(dialog, widget, '*.csv', 'Save as', os.path.expanduser("~/Documents" if os.name == 'nt' else "~"))

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
        msg = "The csv file has been successfully exported"
        tools_qgis.show_info(msg, dialog=dialog)

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

    def _workcat_fill_table(self, widget, table_name, set_edit_triggers=QTableView.EditTrigger.NoEditTriggers, expr=None):
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
        model = QSqlTableModel(db=lib_vars.qgis_db_credentials)
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.EditStrategy.OnFieldChange)
        model.setSort(0, 0)
        model.select()

        widget.setEditTriggers(set_edit_triggers)
        # Check for errors
        if model.lastError().isValid():
            if 'Unable to find table' in model.lastError().text():
                tools_db.reset_qsqldatabase_connection(self.items_dialog)
            else:
                tools_qgis.show_warning(model.lastError().text(), dialog=self.items_dialog)
        # Attach model to table view
        if expr:
            widget.setModel(model)
            widget.model().setFilter(expr)
        else:
            widget.setModel(model)

    def _show_context_menu(self, qtableview, pos):
        """ Show custom context menu """
        menu = QMenu(qtableview)

        action_open = QAction("Open", qtableview)
        action_open.triggered.connect(partial(tools_gw._force_button_click, qtableview.window(), QTableView, qtableview.objectName(), pos))
        menu.addAction(action_open)

        action_delete = QAction("Delete", qtableview)
        action_delete.triggered.connect(partial(tools_gw._force_button_click, qtableview.window(), QPushButton, "btn_delete"))
        menu.addAction(action_delete)

        # Show menu
        menu.exec(QCursor.pos())

    def _open_feature_form(self, qtable):
        """ Zoom feature with the code set in 'network_code' of the layer set in 'network_feature_type' """
        from .info import GwInfo  # Avoid circular import

        tools_gw.reset_rubberband(self.aux_rubber_band)
        # Get selected code from combo
        element = qtable.selectionModel().selectedRows()
        if len(element) == 0:
            msg = "Any record selected"
            tools_qgis.show_warning(msg)
            return

        row = element[0].row()

        feature_type = qtable.model().record(row).value('feature_type').lower()
        table_name = "ve_" + feature_type

        feature_id = qtable.model().record(row).value('feature_id')

        self.customForm = GwInfo(tab_type='data')
        complet_result, dialog = self.customForm.get_info_from_id(table_name, feature_id, 'data')

        # Get list of all coords in field geometry
        try:
            list_coord = re.search(r'\((.*)\)', str(complet_result['body']['feature']['geometry']['st_astext']))
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
                        msg = "Some data is missing. Check gis_length for arc"
                        tools_qgis.show_warning(msg, parameter=arc_id, dialog=self.items_dialog)
                        return
                if extension is not None:
                    widget = self.items_dialog.findChild(QLabel, f"lbl_length{extension}")
                else:
                    widget = self.items_dialog.findChild(QLabel, "lbl_length")

                # Add data to workcat search form
                widget.setText(f"Total arcs length: {length}")

    def _document_insert(self, dialog, tablename, field, field_value):
        """
        Insert a document related to the current visit
            :param dialog: (QDialog )
            :param tablename: Name of the table to make the queries (String)
            :param field: Field of the table to make the where clause (String)
            :param field_value: Value to compare in the clause where (String)
        """
        doc_id = tools_qt.get_combo_value(dialog, dialog.doc_id)

        if not doc_id:
            msg = "Any document selected"
            tools_qgis.show_warning(msg, dialog=dialog)
            return

        # Check if document already exist
        sql = (f"SELECT doc_id"
               f" FROM {tablename}"
               f" WHERE doc_id = '{doc_id}' AND {field} = '{field_value}'")
        row = tools_db.get_row(sql)
        if row:
            msg = "Document already exist"
            tools_qgis.show_warning(msg, dialog=dialog)
            return

        # Insert into new table
        sql = (f"INSERT INTO {tablename} (doc_id, {field})"
               f" VALUES ('{doc_id}', '{field_value}')")
        status = tools_db.execute_sql(sql)
        if status:
            msg = "Document inserted successfully"
            tools_qgis.show_info(msg, dialog=dialog)

        dialog.doc_id.blockSignals(True)
        dialog.doc_id.setCurrentIndex(0)
        dialog.doc_id.hidePopup()
        dialog.doc_id.blockSignals(False)
        dialog.tbl_document.model().select()

    def _get_parameters(self, qtable, index):

        tools_gw.reset_rubberband(self.aux_rubber_band)
        row = index.row()
        column_index = tools_qt.get_col_index_by_col_name(qtable, 'feature_type')
        feature_type = index.sibling(row, column_index).data().lower()
        column_index = tools_qt.get_col_index_by_col_name(qtable, 'feature_id')
        feature_id = index.sibling(row, column_index).data()
        layer = tools_qgis.get_layer_by_tablename(f"ve_{feature_type}")
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

    def _reset_rubber_band(self):
        tools_gw.reset_rubberband(self.rubber_band)
        tools_gw.reset_rubberband(self.aux_rubber_band)

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
            headers.append(str(model_1.headerData(i, Qt.Orientation.Horizontal)))
        all_rows.append(headers)
        for rows in range(0, model_1.rowCount()):
            row = []
            for col in range(0, model_1.columnCount()):
                row.append(str(model_1.data(model_1.index(rows, col))))
            all_rows.append(row)
        if qtable_2 is not None:
            headers = []
            for i in range(0, model_2.columnCount()):
                headers.append(str(model_2.headerData(i, Qt.Orientation.Horizontal)))
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
            tools_qgis.show_warning(msg, dialog=dialog)
