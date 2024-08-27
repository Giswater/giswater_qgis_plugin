"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial
import json

from ...ui.ui_manager import GwStyleManagerUi, GwCreateStyleGroupUi
from ...utils import tools_gw
from ....libs import lib_vars, tools_db
from .... import global_vars
from qgis.PyQt.QtWidgets import QDialog, QLabel, QMessageBox, QHeaderView, QTableView, QMenu, QAction
from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtSql import QSqlTableModel


class GwStyleManager:

    def __init__(self):
        """Initializes the StyleManager with basic configurations."""
        self.plugin_dir = lib_vars.plugin_dir
        self.iface = global_vars.iface
        self.schema_name = lib_vars.schema_name
        self.style_mng_dlg = None


    def manage_styles(self):
        """Manages the user interface for style management."""
        self.style_mng_dlg = GwStyleManagerUi(self)
        tools_gw.load_settings(self.style_mng_dlg)

        # Add icons to the buttons
        tools_gw.add_icon(self.style_mng_dlg.btn_addGroup, "111", sub_folder="24x24")
        tools_gw.add_icon(self.style_mng_dlg.btn_deleteGroup, "112", sub_folder="24x24")

        # Load layers and populate the menu
        layers_data = self._load_layers_with_geom()
        if layers_data:
            self._populate_layers_menu(layers_data)

        # Populate the combobox with style groups
        self.populate_stylegroup_combobox()
        self._load_styles()

        # Connect signals to the corresponding methods
        self.style_mng_dlg.btn_addGroup.clicked.connect(partial(self._add_style_group, self.style_mng_dlg))
        self.style_mng_dlg.btn_deleteGroup.clicked.connect(self._delete_style_group)
        self.style_mng_dlg.stylegroup.currentIndexChanged.connect(self._load_styles)
        self.style_mng_dlg.style_name.textChanged.connect(self._filter_styles)

        # Connect signals to the style buttons
        self.style_mng_dlg.btn_deleteStyle.clicked.connect(self._delete_selected_styles)

        # Open the style management dialog
        tools_gw.open_dialog(self.style_mng_dlg, 'style_manager')


    def populate_stylegroup_combobox(self):
        """Populates the style group combobox with data from the database."""
        contexts_params = self.get_contexts_params()

        self.style_mng_dlg.stylegroup.clear()
        self.style_mng_dlg.stylegroup.addItem("")

        for context_id, context_name in contexts_params:
            self.style_mng_dlg.stylegroup.addItem(context_name, context_id)


    def get_contexts_params(self):
        """Retrieves style context parameters from the database."""
        sql = """
        SELECT id, idval, addparam
            FROM config_style
        WHERE id != 0
        """
        rows = tools_db.get_rows(sql)

        if not rows:
            return []

        processed_rows = []
        for row in rows:
            id, idval, addparam = row
            order_by = 999
            if addparam:
                try:
                    order_by = addparam.get("orderBy", 999)
                except Exception:
                    pass

            processed_rows.append((id, idval, order_by))

        processed_rows.sort(key=lambda x: x[2])

        return [(row[0], row[1]) for row in processed_rows]

    def _load_sys_roles(self, dialog_create):
        """Load roles in combobox."""
        sql = "SELECT id FROM sys_role"
        roles = tools_db.get_rows(sql)
        dialog_create.sys_role.clear()
        for role in roles:
            dialog_create.sys_role.addItem(role[0])


    def _add_style_group(self, dialog):
        """Logic for adding a style group using the Qt Designer dialog."""
        dialog_create = GwCreateStyleGroupUi(self)
        tools_gw.load_settings(dialog_create)

        dialog_create.setWindowFlag(Qt.WindowStaysOnTopHint)
        dialog_create.raise_()
        dialog_create.activateWindow()
        self._load_sys_roles(dialog_create)

        dialog_create.btn_add.clicked.connect(partial(self._handle_add_feature, dialog_create))
        dialog_create.feature_id.textChanged.connect(partial(self._check_style_exists, dialog_create))
        dialog_create.idval.textChanged.connect(partial(self._check_style_exists, dialog_create))

        dialog_create.exec_()

    def _handle_add_feature(self, dialog_create):
        """Handles the logic when the add button is clicked."""

        # Gather data from the dialog fields
        feature_id = dialog_create.feature_id.text()
        idval = dialog_create.idval.text()
        descript = dialog_create.descript.text()
        sys_role = dialog_create.sys_role.currentText()
        addparam = dialog_create.addparam.text()

        # Validate that the mandatory fields are not empty
        if not feature_id or not idval:
            QMessageBox.warning(self.style_mng_dlg, "Input Error", "Feature ID and Idval cannot be empty!")
            return

        # Start building the SQL query
        sql = f"INSERT INTO config_style (id, idval"

        # Initialize the values part with the mandatory fields
        values = f"'{feature_id}', '{idval}'"

        # Add optional fields if they are not empty
        if descript:
            sql += ", descript"
            values += f", '{descript}'"
        if sys_role:
            sql += ", sys_role"
            values += f", '{sys_role}'"
        if addparam:
            sql += ", addparam"
            values += f", '{addparam}'"

        # Close the fields section of the SQL query
        sql += f") VALUES ({values}) RETURNING id;"

        print(sql)

        try:
            # Execute the SQL command and retrieve the new ID
            tools_db.execute_sql(sql)
            QMessageBox.information(self.style_mng_dlg, "Success", "Feature added successfully!")
            self.populate_stylegroup_combobox()
            dialog_create.accept()

        except Exception as e:
            QMessageBox.critical(self.style_mng_dlg, "Database Error", f"Failed to add feature: {e}")

    def _filter_styles(self):
        """Aplica un filtro basado en el texto del textbox y la selección del combobox."""
        search_text = self.style_mng_dlg.style_name.text().strip()
        selected_stylegroup_name = self.style_mng_dlg.stylegroup.currentText().strip()

        filter_str = ""

        if search_text:
            filter_str += f"layername LIKE '%{search_text}%'"

        if selected_stylegroup_name:
            if filter_str:
                filter_str += " AND "
            filter_str += f"idval = '{selected_stylegroup_name}'"

        model = self.style_mng_dlg.tbl_style.model()
        model.setFilter(filter_str)


    def _load_styles(self):
        """Loads styles into the table based on the selected style group."""
        selected_stylegroup_name = self.style_mng_dlg.stylegroup.currentText()

        # Prepare the SQL query to load data from the view
        model = QSqlTableModel(db=lib_vars.qgis_db_credentials)
        model.setTable(f"{lib_vars.schema_name}.v_ui_sys_style")

        if selected_stylegroup_name:
            # Apply filter based on the selected style group
            model.setFilter(f"idval = '{selected_stylegroup_name}'")

        model.select()

        # Check for any errors
        if model.lastError().isValid():
            QMessageBox.critical(self.style_mng_dlg, "Database Error", model.lastError().text())
            return

        self.style_mng_dlg.tbl_style.setModel(model)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        self.style_mng_dlg.tbl_style.setSelectionBehavior(QTableView.SelectRows)
        self.style_mng_dlg.tbl_style.setEditTriggers(QTableView.NoEditTriggers)
        self.style_mng_dlg.tbl_style.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)


    def _check_style_exists(self, dialog_create):
        feature_id_text = dialog_create.feature_id.text().strip()
        idval_text = dialog_create.idval.text().strip()
        color = "border: 1px solid red"
        has_error = False

        dialog_create.feature_id.setStyleSheet("")
        dialog_create.feature_id.setToolTip("")
        dialog_create.idval.setStyleSheet("")
        dialog_create.idval.setToolTip("")

        # Validates Feature ID if it's not empty
        if feature_id_text:
            try:
                feature_id = int(feature_id_text)
                sql_id = f"SELECT id FROM config_style WHERE id = '{feature_id}'"
                row_id = tools_db.get_row(sql_id, log_info=False)

                if row_id:
                    dialog_create.feature_id.setStyleSheet(color)
                    dialog_create.feature_id.setToolTip("Feature ID already exists")
                    has_error = True
            except ValueError:
                dialog_create.feature_id.setStyleSheet(color)
                dialog_create.feature_id.setToolTip("Feature ID must be an integer")
                has_error = True

        # Validates Idval if it's not empty
        if idval_text:
            sql_idval = f"SELECT idval FROM config_style WHERE idval = '{idval_text}'"
            row_idval = tools_db.get_row(sql_idval, log_info=False)

            if row_idval:
                dialog_create.idval.setStyleSheet(color)
                dialog_create.idval.setToolTip("Idval already exists")
                has_error = True
            else:
                dialog_create.idval.setStyleSheet("")
                dialog_create.idval.setToolTip("")

        dialog_create.btn_add.setEnabled(not has_error)

    def _delete_style_group(self):
        """Logic for deleting a style group with cascade deletion."""
        selected_stylegroup_name = self.style_mng_dlg.stylegroup.currentText()

        if not selected_stylegroup_name:
            QMessageBox.warning(self.style_mng_dlg, "Selection Error", "Please select a style group to delete.")
            return

        # Confirm deletion with cascade warning
        confirm = QMessageBox.question(
            self.style_mng_dlg,
            "Confirm Cascade Delete",
            (f"Are you sure you want to delete the style group '{selected_stylegroup_name}'?\n\n"
             "This will also delete all related entries in the sys_style table."),
            QMessageBox.Yes | QMessageBox.No
        )

        if confirm == QMessageBox.No:
            return

        try:
            sql_delete_related = f"DELETE FROM sys_style WHERE styleconfig_id = (SELECT id FROM config_style WHERE idval = '{selected_stylegroup_name}')"
            tools_db.execute_sql(sql_delete_related)

            sql_delete_group = f"DELETE FROM config_style WHERE idval = '{selected_stylegroup_name}'"
            tools_db.execute_sql(sql_delete_group)

            QMessageBox.information(self.style_mng_dlg, "Success",
                                    f"Style group '{selected_stylegroup_name}' and related entries have been deleted.")

            # Refresh the combo box
            self.populate_stylegroup_combobox()
            self._load_styles()

        except Exception as e:
            QMessageBox.critical(self.style_mng_dlg, "Database Error", f"Failed to delete style group: {e}")

    def _manage_current_changed(self):
        """Handles tab changes."""
        if self.style_mng_dlg is None:
            return
        pass

    #Functions for btn style top right of the dialog

    def _delete_selected_styles(self):
        """Logic for deleting the selected styles from the table."""
        selected_rows = self.style_mng_dlg.tbl_style.selectionModel().selectedRows()

        if len(selected_rows) == 0:
            QMessageBox.warning(self.style_mng_dlg, "Selection Error", "Please select one or more styles to delete.")
            return

        confirm = QMessageBox.question(
            self.style_mng_dlg,
            "Confirm Deletion",
            "Are you sure you want to delete the selected styles?",
            QMessageBox.Yes | QMessageBox.No
        )

        if confirm == QMessageBox.No:
            return

        for index in selected_rows:
            row = index.row()

            layername_index = self.style_mng_dlg.tbl_style.model().index(row, 0)
            idval_index = self.style_mng_dlg.tbl_style.model().index(row, 1)

            layername = self.style_mng_dlg.tbl_style.model().data(layername_index)
            idval = self.style_mng_dlg.tbl_style.model().data(idval_index)

            try:
                # Retrieve the numeric `styleconfig_id` based on the `idval`
                sql_get_id = (
                    f"SELECT id FROM {lib_vars.schema_name}.config_style "
                    f"WHERE idval = '{idval}';"
                )
                row_result = tools_db.get_row(sql_get_id)

                if not row_result:
                    QMessageBox.critical(self.style_mng_dlg, "Error",
                                         f"Could not find the corresponding ID for the selected style {idval}.")
                    continue

                styleconfig_id = row_result[0]

                # Delete the selected row from sys_style using the retrieved numeric `styleconfig_id`
                sql_delete_style = (
                    f"DELETE FROM {lib_vars.schema_name}.sys_style "
                    f"WHERE layername = '{layername}' AND styleconfig_id = {styleconfig_id};"
                )
                tools_db.execute_sql(sql_delete_style)

            except Exception as e:
                QMessageBox.critical(self.style_mng_dlg, "Database Error",
                                     f"Failed to delete style {layername} with ID {idval}: {e}")
                continue

        QMessageBox.information(self.style_mng_dlg, "Success", "Selected styles were successfully deleted.")
        self._load_styles()

    def _load_layers_with_geom(self):
        """Load layers with geometry for the Add Style button."""
        try:
            body = tools_gw.create_body()
            json_result = tools_gw.execute_procedure('gw_fct_getaddlayervalues', body)
            if not json_result or json_result['status'] != 'Accepted':
                QMessageBox.warning(self.style_mng_dlg, "Error", "Failed to load layers.")
                return None

            return json_result['body']['data']['fields']

        except Exception as e:
            QMessageBox.critical(self.style_mng_dlg, "Database Error", f"Failed to load layers: {e}")
            return None

    def _populate_layers_menu(self, layers):
        """Populate the Add Style button with layers grouped by context."""
        try:
            menu = QMenu(self.style_mng_dlg.btn_addStyle)

            dict_menu = {}

            for layer in layers:
                # Filter only layers that have a geometry field
                if layer['geomField'] == "None" or not layer['geomField']:
                    continue  # Skip layers without a geometry field

                context = json.loads(layer['context'])

                # Level 1 of the context
                if 'level_1' in context and context['level_1'] not in dict_menu:
                    menu_level_1 = menu.addMenu(f"{context['level_1']}")
                    dict_menu[context['level_1']] = menu_level_1

                # Level 2 of the context
                if 'level_2' in context and f"{context['level_1']}_{context['level_2']}" not in dict_menu:
                    menu_level_2 = dict_menu[context['level_1']].addMenu(f"{context['level_2']}")
                    dict_menu[f"{context['level_1']}_{context['level_2']}"] = menu_level_2

                # Level 3 of the context
                if 'level_3' in context and f"{context['level_1']}_{context['level_2']}_{context['level_3']}" not in dict_menu:
                    menu_level_3 = dict_menu[f"{context['level_1']}_{context['level_2']}"].addMenu(
                        f"{context['level_3']}")
                    dict_menu[f"{context['level_1']}_{context['level_2']}_{context['level_3']}"] = menu_level_3

                alias = layer['layerName'] if layer['layerName'] is not None else layer['tableName']
                alias = f"{alias}     "

                # Add actions and submenus at the appropriate context level
                if 'level_3' in context:
                    sub_menu = dict_menu[f"{context['level_1']}_{context['level_2']}_{context['level_3']}"]
                else:
                    sub_menu = dict_menu[f"{context['level_1']}_{context['level_2']}"]

                action = QAction(alias, self.style_mng_dlg.btn_addStyle)
                action.triggered.connect(partial(self._add_layer_style, layer['tableName'], layer['geomField']))
                sub_menu.addAction(action)

            # Assign the menu to the button
            self.style_mng_dlg.btn_addStyle.setMenu(menu)

        except Exception as e:
            QMessageBox.critical(self.style_mng_dlg, "Database Error", f"Failed to load layers: {e}")

    def _add_layer_style(self, table_name, geom_field):
        """Logic to handle the addition of styles for a selected layer."""
        print(f"Add style for {table_name} with geometry field {geom_field}")

