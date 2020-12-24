"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
import webbrowser
from functools import partial

from qgis.PyQt.QtWidgets import QAbstractItemView, QTableView, QFileDialog

from ..utils import tools_gw
from ..ui.ui_manager import DocUi, DocManager
from ... import global_vars
from ...lib import tools_qt, tools_db, tools_qgis


class GwDocument:

    def __init__(self, single_tool=True):
        """ Class to control action 'Add document' of toolbar 'edit' """

        # parameter to set if the document manager is working as
        # single tool or integrated in another tool
        self.single_tool_mode = single_tool
        self.previous_dialog = None
        self.iface = global_vars.iface
        self.schema_name = global_vars.schema_name
        self.files_path = []


    def edit_add_file(self):
        self.manage_document()


    def manage_document(self, tablename=None, qtable=None, item_id=None, feature=None, geom_type=None, row=None):
        """ Button 34: Add document """

        # Create the dialog and signals
        self.dlg_add_doc = DocUi()
        tools_gw.load_settings(self.dlg_add_doc)
        self.doc_id = None
        self.files_path = []

        # Capture the current layer to return it at the end of the operation
        cur_active_layer = self.iface.activeLayer()

        widget_list = self.dlg_add_doc.findChildren(QTableView)
        for widget in widget_list:
            tools_qt.set_tableview_config(widget)

        # Get layers of every geom_type

        # Setting lists
        self.ids = []
        self.list_ids = {'arc': [], 'node': [], 'connec': [], 'gully': [], 'element': []}

        # Setting layers
        self.layers = {'arc': [], 'node': [], 'connec': [], 'element': []}
        self.layers['arc'] = tools_gw.get_layers_from_feature_type('arc')
        self.layers['node'] = tools_gw.get_layers_from_feature_type('node')
        self.layers['connec'] = tools_gw.get_layers_from_feature_type('connec')
        self.layers['element'] = tools_gw.get_layers_from_feature_type('element')

        # Remove 'gully' for 'WS'
        self.project_type = tools_gw.get_project_type()
        if self.project_type == 'ws':
            tools_qt.remove_tab(self.dlg_add_doc.tab_feature, 'tab_gully')

        else:
            self.layers['gully'] = tools_gw.get_layers_from_feature_type('gully')

        # Remove all previous selections
        if self.single_tool_mode:
            self.layers = tools_gw.remove_selection(True, layers=self.layers)

        if feature is not None:
            layer = self.iface.activeLayer()
            layer.selectByIds([feature.id()])

        # Set icons
        tools_gw.add_icon(self.dlg_add_doc.btn_insert, "111")
        tools_gw.add_icon(self.dlg_add_doc.btn_delete, "112")
        tools_gw.add_icon(self.dlg_add_doc.btn_snapping, "137")
        self.dlg_add_doc.tabWidget.setTabEnabled(1, False)
        # Fill combo boxes
        self.fill_combo_by_query(self.dlg_add_doc, "doc_type", "doc_type")

        # Set current/selected date and link
        if row:
            tools_qt.set_calendar(self.dlg_add_doc, 'date', row.value('date'))
            tools_qt.set_widget_text(self.dlg_add_doc, 'path', row.value('path'))
            self.files_path.append(row.value('path'))
        else:
            tools_qt.set_calendar(self.dlg_add_doc, 'date', None)

        # Adding auto-completion to a QLineEdit
        table_object = "doc"
        tools_gw.set_completer_object(self.dlg_add_doc, table_object)

        # Adding auto-completion to a QLineEdit for default feature
        if geom_type is None:
            geom_type = "arc"
        viewname = f"v_edit_{geom_type}"
        tools_gw.set_completer_widget(viewname, self.dlg_add_doc.feature_id, str(geom_type) + "_id")

        # Set signals
        self.dlg_add_doc.doc_type.currentIndexChanged.connect(self.activate_relations)
        self.dlg_add_doc.btn_path_url.clicked.connect(partial(self.open_web_browser, self.dlg_add_doc, "path"))
        self.dlg_add_doc.btn_path_doc.clicked.connect(lambda: setattr(self, 'files_path', self.get_file_dialog(self.dlg_add_doc, "path")))
        self.dlg_add_doc.btn_accept.clicked.connect(
            partial(self.manage_document_accept, table_object, tablename, qtable, item_id))
        self.dlg_add_doc.btn_cancel.clicked.connect(lambda: setattr(self, 'layers', tools_gw.manage_close(self.dlg_add_doc,
                    table_object, cur_active_layer, excluded_layers=["v_edit_element"],
                    single_tool_mode=self.single_tool_mode, layers=self.layers)))
        self.dlg_add_doc.rejected.connect(lambda: setattr(self, 'layers', tools_gw.manage_close(self.dlg_add_doc, table_object,
                    cur_active_layer, excluded_layers=["v_edit_element"],single_tool_mode=self.single_tool_mode,
                    layers=self.layers)))
        self.dlg_add_doc.tab_feature.currentChanged.connect(
            partial(tools_gw.get_signal_change_tab, self.dlg_add_doc, excluded_layers=["v_edit_element"]))

        self.dlg_add_doc.doc_id.textChanged.connect(
            partial(self.fill_dialog_document, self.dlg_add_doc, table_object, None))
        self.dlg_add_doc.btn_insert.clicked.connect(
            partial(tools_gw.insert_feature, self, self.dlg_add_doc, table_object, False, False, None, None))
        self.dlg_add_doc.btn_delete.clicked.connect(
            partial(tools_gw.delete_records, self, self.dlg_add_doc,  table_object, False, None, None))
        self.dlg_add_doc.btn_snapping.clicked.connect(
            partial(tools_gw.selection_init, self, self.dlg_add_doc, table_object, False))

        if feature:
            self.dlg_add_doc.tabWidget.currentChanged.connect(
                partial(self.fill_table_doc, self.dlg_add_doc, geom_type, feature[geom_type + "_id"]))

        # Set default tab 'arc'
        self.dlg_add_doc.tab_feature.setCurrentIndex(0)
        self.geom_type = "arc"
        tools_gw.get_signal_change_tab(self.dlg_add_doc, excluded_layers=["v_edit_element"])

        # Open the dialog
        tools_gw.open_dialog(self.dlg_add_doc, dlg_name='doc', maximize_button=False)

        return self.dlg_add_doc


    def fill_combo_by_query(self, dialog, widget, table_name, field_name="id"):
        """ Executes query and fill combo box """

        sql = (f"SELECT {field_name}"
               f" FROM {table_name}"
               f" ORDER BY {field_name}")
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_box(dialog, widget, rows)
        if rows:
            tools_qt.set_current_index(dialog, widget, 0)


    def activate_relations(self):
        """ Force user to set doc_id and doc_type """

        doc_type = tools_qt.get_text(self.dlg_add_doc, self.dlg_add_doc.doc_type, False, False)

        if doc_type in (None, '', 'null'):
            self.dlg_add_doc.tabWidget.setTabEnabled(1, False)
        else:
            self.dlg_add_doc.tabWidget.setTabEnabled(1, True)


    def fill_table_doc(self, dialog, geom_type, feature_id):

        widget = "tbl_doc_x_" + geom_type
        widget = dialog.findChild(QTableView, widget)
        widget.setSelectionBehavior(QAbstractItemView.SelectRows)
        expr_filter = f"{geom_type}_id = '{feature_id}'"

        # Set model of selected widget
        table_name = f"{self.schema_name}.v_edit_{geom_type}"
        message = tools_qt.fill_table(widget, table_name, expr_filter)
        if message:
            tools_qgis.show_warning(message)


    def manage_document_accept(self, table_object, tablename=None, qtable=None, item_id=None):
        """ Insert or update table 'document'. Add document to selected feature """

        # Get values from dialog
        doc_id = tools_qt.get_text(self.dlg_add_doc, "doc_id", False, False)
        doc_type = tools_qt.get_text(self.dlg_add_doc, "doc_type", False, False)
        date = tools_qt.get_calendar_date(self.dlg_add_doc, "date", datetime_format="yyyy/MM/dd")
        path = tools_qt.get_text(self.dlg_add_doc, "path", return_string_null=False)
        observ = tools_qt.get_text(self.dlg_add_doc, "observ", False, False)

        if doc_type in (None, ''):
            message = "You need to insert doc_type"
            tools_qgis.show_warning(message)
            return

        # Check if this document already exists
        sql = (f"SELECT DISTINCT(id)"
               f" FROM {table_object}"
               f" WHERE id = '{doc_id}'")
        row = tools_db.get_row(sql, log_info=False)

        # If document not exists perform an INSERT
        if row is None:
            if len(self.files_path) <= 1:
                if doc_id in (None, ''):
                    sql, doc_id = self.insert_doc_sql(doc_type, observ, date, path)
                else:
                    sql = (f"INSERT INTO doc (id, doc_type, path, observ, date)"
                           f" VALUES ('{doc_id}', '{doc_type}', '{path}', '{observ}', '{date}');")
                self.update_doc_tables(sql, doc_id, table_object, tablename, item_id, qtable)
            else:
                # Ask question before executing
                msg = ("You have selected multiple documents. In this case, doc_id will be a sequencial number for "
                       "all selected documents and your doc_id won't be used.")
                answer = tools_qt.ask_question(msg, tools_qt.tr("Add document", aux_context='ui_message'))
                if answer:
                    for file in self.files_path:
                        sql, doc_id = self.insert_doc_sql(doc_type, observ, date, file)
                        self.update_doc_tables(sql, doc_id, table_object, tablename, item_id, qtable)
        # If document exists perform an UPDATE
        else:
            message = "Are you sure you want to update the data?"
            answer = tools_qt.ask_question(message)
            if not answer:
                return
            if len(self.files_path) <= 1:
                sql = self.update_doc_sql(doc_type, observ, date, doc_id, path)
                self.update_doc_tables(sql, doc_id, table_object, tablename, item_id, qtable)
            else:
                # If document have more than 1 file perform an INSERT
                # Ask question before executing
                msg = ("You have selected multiple documents. In this case, doc_id will be a sequencial number for "
                       "all selected documents and your doc_id won't be used.")
                answer = tools_qt.ask_question(msg, tools_qt.tr("Add document", aux_context='ui_message'))
                if answer:
                    for cont, file in enumerate(self.files_path):
                        if cont == 0:
                            sql = self.update_doc_sql(doc_type, observ, date, doc_id, file)
                            self.update_doc_tables(sql, doc_id, table_object, tablename, item_id, qtable)
                        else:
                            sql, doc_id = self.insert_doc_sql(doc_type, observ, date, file)
                            self.update_doc_tables(sql, doc_id, table_object, tablename, item_id, qtable)


    def insert_doc_sql(self, doc_type, observ, date, path):
        sql = (f"INSERT INTO doc (doc_type, path, observ, date)"
               f" VALUES ('{doc_type}', '{path}', '{observ}', '{date}') RETURNING id;")
        new_doc_id = tools_db.execute_returning(sql)
        sql = ""
        doc_id = str(new_doc_id[0])
        return sql, doc_id


    def update_doc_sql(self, doc_type, observ, date, doc_id, path):
        sql = (f"UPDATE doc "
               f" SET doc_type = '{doc_type}', observ = '{observ}', path = '{path}', date = '{date}'"
               f" WHERE id = '{doc_id}';")
        return sql


    def update_doc_tables(self, sql, doc_id, table_object, tablename, item_id, qtable):
        # Manage records in tables @table_object_x_@geom_type
        sql += (f"\nDELETE FROM doc_x_node"
                f" WHERE doc_id = '{doc_id}';")
        sql += (f"\nDELETE FROM doc_x_arc"
                f" WHERE doc_id = '{doc_id}';")
        sql += (f"\nDELETE FROM doc_x_connec"
                f" WHERE doc_id = '{doc_id}';")
        if self.project_type == 'ud':
            sql += (f"\nDELETE FROM doc_x_gully"
                    f" WHERE doc_id = '{doc_id}';")

        if self.list_ids['arc']:
            for feature_id in self.list_ids['arc']:
                sql += (f"\nINSERT INTO doc_x_arc (doc_id, arc_id)"
                        f" VALUES ('{doc_id}', '{feature_id}');")
        if self.list_ids['node']:
            for feature_id in self.list_ids['node']:
                sql += (f"\nINSERT INTO doc_x_node (doc_id, node_id)"
                        f" VALUES ('{doc_id}', '{feature_id}');")
        if self.list_ids['connec']:
            for feature_id in self.list_ids['connec']:
                sql += (f"\nINSERT INTO doc_x_connec (doc_id, connec_id)"
                        f" VALUES ('{doc_id}', '{feature_id}');")
        if self.project_type == 'ud' and self.list_ids['gully']:
            for feature_id in self.list_ids['gully']:
                sql += (f"\nINSERT INTO doc_x_gully (doc_id, gully_id)"
                        f" VALUES ('{doc_id}', '{feature_id}');")

        status = tools_db.execute_sql(sql)
        if status:
            self.doc_id = doc_id
            tools_gw.manage_close(self.dlg_add_doc, table_object, excluded_layers=["v_edit_element"],
                         single_tool_mode=self.single_tool_mode, layers=self.layers)

        if tablename is None:
            return
        else:
            sql = (f"INSERT INTO doc_x_{tablename} (doc_id, {tablename}_id) "
                   f" VALUES('{doc_id}', '{item_id}')")
            tools_db.execute_sql(sql)
            expr = f"{tablename}_id = '{item_id}'"
            message = tools_qt.fill_table(qtable, f"{self.schema_name}.v_ui_doc_x_{tablename}", expr)
            if message:
                tools_qgis.show_warning(message)


    def edit_document(self):
        """ Button 66: Edit document """

        # Create the dialog
        self.dlg_man = DocManager()
        tools_gw.load_settings(self.dlg_man)
        self.dlg_man.tbl_document.setSelectionBehavior(QAbstractItemView.SelectRows)

        # Adding auto-completion to a QLineEdit
        table_object = "doc"
        tools_gw.set_completer_object(self.dlg_man, table_object)

        # Set a model with selected filter. Attach that model to selected table
        message = tools_qt.fill_table(self.dlg_man.tbl_document, f"{self.schema_name}.{table_object}")
        if message:
            tools_qgis.show_warning(message)
        tools_gw.set_tablemodel_config(self.dlg_man, self.dlg_man.tbl_document, table_object)

        # Set dignals
        self.dlg_man.doc_id.textChanged.connect(
            partial(tools_qt.filter_by_id, self.dlg_man, self.dlg_man.tbl_document, self.dlg_man.doc_id, table_object))
        self.dlg_man.tbl_document.doubleClicked.connect(
            partial(self.open_selected_object_document, self.dlg_man, self.dlg_man.tbl_document, table_object))
        self.dlg_man.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_man))
        self.dlg_man.rejected.connect(partial(tools_gw.close_dialog, self.dlg_man))
        self.dlg_man.btn_delete.clicked.connect(
            partial(tools_gw.delete_selected_rows, self.dlg_man.tbl_document, table_object))

        # Open form
        tools_gw.open_dialog(self.dlg_man, dlg_name='doc_manager')


    def open_selected_object_document(self, dialog, widget, table_object):

        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return

        row = selected_list[0].row()

        # Get object_id from selected row
        field_object_id = "id"
        widget_id = table_object + "_id"
        selected_object_id = widget.model().record(row).value(field_object_id)

        # Close this dialog and open selected object
        dialog.close()

        self.manage_document(row=widget.model().record(row))
        tools_qt.set_widget_text(self.dlg_add_doc, widget_id, selected_object_id)


    def open_web_browser(self, dialog, widget=None):
        """ Display url using the default browser """

        if widget is not None:
            url = tools_qt.get_text(dialog, widget)
            if url == 'null':
                url = 'http://www.giswater.org'
        else:
            url = 'http://www.giswater.org'

        webbrowser.open(url)


    def get_file_dialog(self, dialog, widget):
        """ Get file dialog """

        # Check if selected file exists. Set default value if necessary
        file_path = tools_qt.get_text(dialog, widget)
        if file_path is None or file_path == 'null' or not os.path.exists(str(file_path)):
            folder_path = global_vars.plugin_dir
        else:
            folder_path = os.path.dirname(file_path)
        # Open dialog to select file
        os.chdir(folder_path)
        file_dialog = QFileDialog()
        file_dialog.setFileMode(QFileDialog.AnyFile)
        message = "Select file"
        files_path, filter_ = file_dialog.getOpenFileNames(parent=None, caption=tools_qt.tr(message, aux_context='ui_message'))

        file_text = ""
        for file in files_path:
            file_text += f"{file}\n\n"
        if files_path:
            tools_qt.set_widget_text(dialog, widget, str(file_text))
        return files_path


    def fill_dialog_document(self, dialog, table_object, single_tool_mode=None):

        # Reset list of selected records
        self.ids, self.list_ids = tools_gw.reset_feature_list()

        list_geom_type = ['arc', 'node', 'connec', 'element']
        if global_vars.project_type == 'ud':
            list_geom_type.append('gully')

        object_id = tools_qt.get_text(dialog, table_object + "_id")

        # Check if we already have data with selected object_id
        sql = (f"SELECT * "
               f" FROM {table_object}"
               f" WHERE id = '{object_id}'")
        row = tools_db.get_row(sql, log_info=False)

        # If object_id not found: Clear data
        if not row:
            # Reset widgets
            widgets = ["doc_type", "observ", "path"]
            if widgets:
                for widget_name in widgets:
                    tools_qt.set_widget_text(dialog, widget_name, "")

            if single_tool_mode is not None:
                self.layers = tools_gw.remove_selection(single_tool_mode, self.layers)
            else:
                self.layers = tools_gw.remove_selection(True, self.layers)

            for geom_type in list_geom_type:
                tools_qt.reset_model(dialog, table_object, geom_type)

            return

        # Fill input widgets with data of the @row
        tools_qt.set_widget_text(dialog, "doc_type", row["doc_type"])
        tools_qt.set_widget_text(dialog, "observ", row["observ"])
        tools_qt.set_widget_text(dialog, "path", row["path"])

        # Check related @geom_type
        for geom_type in list_geom_type:
            tools_gw.get_rows_by_feature_type(self, dialog, table_object, geom_type)