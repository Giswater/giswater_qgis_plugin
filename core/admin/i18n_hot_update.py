"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
import re
from functools import partial

from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtGui import QStandardItem, QStandardItemModel
from qgis.PyQt.QtWidgets import (
    QListWidget, QCompleter, QLineEdit, QVBoxLayout, QWidget,
    QHeaderView, QSizePolicy, QGroupBox, QScrollArea,
)

from ..ui.ui_manager import GwAdminI18NHotUpdateUi
from ..utils import tools_gw
from qgis.PyQt.sip import isdeleted
from ...libs import lib_vars, tools_qt, tools_db, tools_os
from . import _admin_catalog as admin_catalog
from .i18n_languages import GwI18NManageLanguagesDialog, _I18N_SCHEMAS


_SCHEMA_COLUMNS = ("Schema", "Kind", "Version", "Language", "Created", "Last update")
_COL_SCHEMA = 0
_COL_KIND = 1
_COL_VERSION = 2
_COL_LANGUAGE = 3
_COL_CREATED = 4
_COL_UPDATED = 5
_TRANSLATABLE_KINDS = frozenset({"WS", "UD", "AM", "CM"})
_MAX_VISIBLE_SCHEMA_ROWS = 4
_NETWORK_DBTABLES = [
    "dbparam_user", "dbconfig_param_system", "dbconfig_form_fields", "dbconfig_typevalue",
    "dbfprocess", "dbmessage", "dbconfig_csv", "dbconfig_form_tabs", "dbconfig_report",
    "dbconfig_toolbox", "dbfunction", "dblabel", "dbtypevalue", "dbconfig_form_fields_feat",
    "dbconfig_form_tableview", "dbconfig_visit_parameter", "dbtable", "dbplan_price", "dbstyle",
    "su_basic_tables", "dbjson", "dbconfig_form_fields_json",
]
_TAB_DATA_LINE_RE = re.compile(r",\s*'tab_data'\s*,")
_FORM_FIELDS_SQL = frozenset({
    "dbconfig_form_fields.sql",
    "dbconfig_form_fields_feat.sql",
    "dbconfig_form_fields_json.sql",
})


class GwAdminI18NHotUpdate():

    def __init__(self, admin_btn):
        self.admin = admin_btn
        self._active_connection = ""
        self._selected_schema = ""
        self._inventory_rows: list[dict] = []
        self._schema_model = None
        self._tables_project_type = "ws"
        self._i18n_password = ""
        self.dlg_qm = None
        self._scroll_area = None
        self._scroll_content = None
        self.dev_commit = None

    def init_dialog(self):
        """Constructor"""

        self.dlg_qm = GwAdminI18NHotUpdateUi(self)
        self._setup_status_label()
        self._schema_model = QStandardItemModel(0, len(_SCHEMA_COLUMNS), self.dlg_qm)
        self._schema_model.setHorizontalHeaderLabels(list(_SCHEMA_COLUMNS))
        tools_gw.load_settings(self.dlg_qm)
        self._load_user_values()
        self.dev_commit = tools_gw.get_config_parser(
            'system', 'force_commit', "user", "init", prefix=True,
        )

        self.dbtables_dic = self.tables_dic()
        self._setup_connection()
        self._setup_schema_table()
        self._set_signals()
        self._setup_tables_filter()
        self._populate_language_combo()
        self._refresh_schema_table()
        self._apply_dialog_height()
        self.admin._manage_schemas_update_system_info = self._update_system_info
        self.dlg_qm.finished.connect(self._clear_admin_callbacks)
        tools_gw.open_dialog(self.dlg_qm, dlg_name='admin_i18n_languages')

    def _set_signals(self):
        self.dlg_qm.btn_update.clicked.connect(partial(self._run_update))
        self.dlg_qm.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_qm))
        self.dlg_qm.btn_manage_language.clicked.connect(partial(self._open_manage_language))
        self.dlg_qm.btn_refresh.clicked.connect(partial(self._refresh_schema_table))
        self.dlg_qm.cmb_connection.currentIndexChanged.connect(partial(self._on_connection_changed))
        self.dlg_qm.cmb_language.currentIndexChanged.connect(partial(self._save_language_selection))
        self.dlg_qm.rejected.connect(self._save_user_values)

    def _setup_status_label(self) -> None:
        self.dlg_qm.lbl_info.setWordWrap(False)
        self.dlg_qm.lbl_info.setSizePolicy(QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Fixed)

    def _setup_connection(self) -> None:
        self.admin._populate_combo_connections()
        if self.admin.list_connections:
            tools_qt.fill_combo_values(
                self.dlg_qm.cmb_connection, self.admin.list_connections,
            )
        current = ""
        if getattr(self.admin, "cmb_connection", None) is not None:
            current = tools_qt.get_text(
                self.admin.dlg_readsql,
                self.admin.cmb_connection,
                return_string_null=False,
            )
        if not current:
            current = self.admin._get_last_connection() or ""
        if current:
            tools_qt.set_combo_value(self.dlg_qm.cmb_connection, current, 1)
        self._active_connection = current
        self._update_system_info()

    def _format_system_info(self) -> str:
        result = getattr(self.admin, "_admin_catalog_cache", None)
        pg = self.admin.postgresql_version or "?"
        postgis = self.admin.postgis_version or "?"
        pgrouting = self.admin.pgrouting_version or "?"
        lines = [
            f"{tools_qt.tr('PostgreSQL version')}: {pg}",
            f"{tools_qt.tr('PostGis version')}: {postgis}",
            f"{tools_qt.tr('PgRouting version')}: {pgrouting}",
        ]
        if result and getattr(result, "extensions_present", None):
            missing = sorted(
                name for name, present in result.extensions_present.items() if not present
            )
            if missing:
                lines.append(
                    f"{tools_qt.tr('Missing extensions')}: {', '.join(missing)}"
                )
        return "\n".join(lines)

    def _update_system_info(self) -> None:
        self.dlg_qm.txt_system_info.setPlainText(self._format_system_info())

    def _on_connection_changed(self) -> None:
        connection_name = tools_qt.get_text(
            self.dlg_qm, self.dlg_qm.cmb_connection, return_string_null=False,
        )
        if not connection_name or connection_name == self._active_connection:
            return
        previous = self._active_connection
        self.dlg_qm.setEnabled(False)
        try:
            if not self.admin.reload_connection_for_manage_schemas(connection_name):
                if previous:
                    self.dlg_qm.cmb_connection.blockSignals(True)
                    tools_qt.set_combo_value(self.dlg_qm.cmb_connection, previous, 1)
                    self.dlg_qm.cmb_connection.blockSignals(False)
                return
            self._active_connection = connection_name
            self._selected_schema = ""
            self.dlg_qm.tbl_schemas.clearSelection()
            self._update_system_info()
            self._refresh_schema_table()
        finally:
            self.dlg_qm.setEnabled(True)
        

    def _ensure_dialog_scroll(self) -> None:
        if self._scroll_area is not None:
            return

        main_layout = self.dlg_qm.verticalLayout
        scroll_area = QScrollArea(self.dlg_qm)
        scroll_area.setWidgetResizable(True)
        scroll_area.setFrameShape(QScrollArea.Shape.NoFrame)
        scroll_area.setHorizontalScrollBarPolicy(Qt.ScrollBarPolicy.ScrollBarAlwaysOff)
        scroll_area.setVerticalScrollBarPolicy(Qt.ScrollBarPolicy.ScrollBarAsNeeded)
        scroll_area.setSizePolicy(QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Expanding)

        content = QWidget()
        content_layout = QVBoxLayout(content)
        content_layout.setContentsMargins(0, 0, 0, 0)
        content_layout.setSpacing(main_layout.spacing())

        while main_layout.count() > 1:
            item = main_layout.takeAt(0)
            if item.widget():
                content_layout.addWidget(item.widget())
            elif item.layout():
                content_layout.addLayout(item.layout())
            elif item.spacerItem():
                content_layout.addItem(item.spacerItem())

        scroll_area.setWidget(content)
        main_layout.insertWidget(0, scroll_area, 1)

        self._scroll_area = scroll_area
        self._scroll_content = content

    def _apply_dialog_height(self) -> None:
        margin_top = 14
        margin_bottom = 38
        margin_between = 10

        content_height = margin_top
        for i, widget in enumerate(self.dlg_qm.findChildren(QGroupBox)):
            content_height += widget.sizeHint().height()
            if isinstance(widget, QGroupBox):
                content_height += margin_between

        dialog_height = content_height + margin_bottom
        dialog_width = self.dlg_qm.width()
        self.dlg_qm.resize(dialog_width, dialog_height)
        self.dlg_qm.setMaximumHeight(dialog_height)

        self._ensure_dialog_scroll()


    def _setup_schema_table(self) -> None:
        self.dlg_qm.tbl_schemas.setModel(self._schema_model)
        self.dlg_qm.tbl_schemas.setAlternatingRowColors(True)
        self.dlg_qm.tbl_schemas.setSortingEnabled(True)
        self.dlg_qm.tbl_schemas.verticalHeader().setVisible(False)
        self.dlg_qm.tbl_schemas.setVerticalScrollBarPolicy(
            Qt.ScrollBarPolicy.ScrollBarAsNeeded,
        )
        header = self.dlg_qm.tbl_schemas.horizontalHeader()
        header.setStretchLastSection(False)
        header.setSectionResizeMode(_COL_SCHEMA, QHeaderView.ResizeMode.Stretch)
        for col in (_COL_KIND, _COL_VERSION, _COL_LANGUAGE, _COL_CREATED, _COL_UPDATED):
            header.setSectionResizeMode(col, QHeaderView.ResizeMode.ResizeToContents)
        header.setMinimumSectionSize(48)
        selection = self.dlg_qm.tbl_schemas.selectionModel()
        if selection is not None:
            selection.selectionChanged.connect(partial(self._on_schema_selection_changed))
        self._apply_schema_table_height()
        self._update_schema_label()

    def _clear_admin_callbacks(self, *_args) -> None:
        if getattr(self.admin, "_manage_schemas_update_system_info", None) is self._update_system_info:
            self.admin._manage_schemas_update_system_info = None
        if getattr(self.admin, "dlg_i18n_hot_update", None) is self.dlg_qm:
            self.admin.dlg_i18n_hot_update = None

    def _apply_schema_table_height(self) -> None:
        """Cap the schema table to four visible rows; scroll when there are more."""
        table = self.dlg_qm.tbl_schemas
        row_h = table.verticalHeader().defaultSectionSize()
        visible_rows = _MAX_VISIBLE_SCHEMA_ROWS
        if self._schema_model.rowCount() > 0:
            visible_rows = min(self._schema_model.rowCount(), _MAX_VISIBLE_SCHEMA_ROWS)
            row_h = max(row_h, table.rowHeight(0))
        header_h = table.horizontalHeader().height()
        if header_h <= 0:
            header_h = table.fontMetrics().height() + 10
        frame = table.frameWidth() * 2
        height = header_h + row_h * visible_rows + frame
        table.setFixedHeight(height)
        table.setSizePolicy(QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Fixed)
        self.dlg_qm.grb_schemas.setSizePolicy(
            QSizePolicy.Policy.Preferred, QSizePolicy.Policy.Fixed,
        )

    def _setup_tables_filter(self) -> None:
        widget = QListWidget()
        widget.setObjectName('list_widget')
        widget.setMaximumHeight(28)
        widget.setSizePolicy(QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Fixed)

        completer = QCompleter()
        type_ahead = QLineEdit()
        type_ahead.setPlaceholderText(tools_qt.tr("Type to search..."))

        model = QStandardItemModel()
        completer.activated.connect(
            partial(tools_gw.add_item_multiple_option, completer, widget, type_ahead),
        )
        self.make_list_multiple_option(completer, model, type_ahead, widget)
        type_ahead.textChanged.connect(
            partial(self.make_list_multiple_option, completer, model, type_ahead, widget),
        )
        widget.itemDoubleClicked.connect(partial(tools_gw.delete_item_on_doubleclick, widget))
        widget.model().rowsInserted.connect(partial(self.update_selected_table_dic))

        layout = QVBoxLayout()
        layout.setContentsMargins(0, 0, 0, 0)
        layout.setSpacing(2)
        layout.addWidget(type_ahead)
        layout.addWidget(widget)

        container = QWidget()
        container.setLayout(layout)
        filter_layout = self.dlg_qm.wgt_tables_filter.layout()
        if filter_layout is None:
            filter_layout = QVBoxLayout(self.dlg_qm.wgt_tables_filter)
            filter_layout.setContentsMargins(0, 0, 0, 0)
        filter_layout.addWidget(container)

    def _populate_language_combo(self) -> None:
        self.dlg_qm.cmb_language.clear()
        status, cursor = tools_gw.create_sqlite_conn("config")
        if not status or cursor is None:
            tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', "Config database file not found")
            return
        cursor.execute("SELECT locale, name FROM locales WHERE active = 1 ORDER BY name")
        rows = [[locale, name] for locale, name in cursor.fetchall()]
        if not rows:
            tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', "No active locales configured")
            return
        tools_qt.fill_combo_values(self.dlg_qm.cmb_language, rows)
        language = tools_gw.get_config_parser(
            'i18n_generator', 'qm_lang_language', "user", "session", False,
        )
        if language:
            tools_qt.set_combo_value(self.dlg_qm.cmb_language, language, 0, add_new=False)

    def _save_language_selection(self, *_args) -> None:
        language = tools_qt.get_combo_value(self.dlg_qm, self.dlg_qm.cmb_language, 0)
        if language:
            tools_gw.set_config_parser(
                'i18n_generator', 'qm_lang_language', f"{language}",
                "user", "session", prefix=False,
            )

    def _refresh_schema_table(self) -> None:
        previous_schema = self._selected_schema
        self.dlg_qm.btn_refresh.setEnabled(False)
        try:
            update_info = getattr(self.admin, "_manage_schemas_update_system_info", None)
            if update_info:
                update_info()
            else:
                self._update_system_info()
            self.dlg_qm.tbl_schemas.setSortingEnabled(False)
            selection = self.dlg_qm.tbl_schemas.selectionModel()
            if selection is not None:
                selection.blockSignals(True)
            try:
                self._schema_model.removeRows(0, self._schema_model.rowCount())
                self._inventory_rows = admin_catalog.fetch_schema_inventory()
                for row in self._inventory_rows:
                    language = self._fetch_schema_language(str(row.get("schema") or ""))
                    values = (
                        row.get("schema", ""),
                        row.get("kind", ""),
                        row.get("version", ""),
                        language,
                        row.get("date_created", ""),
                        row.get("date_updated", ""),
                    )
                    items = []
                    for value in values:
                        item = QStandardItem(str(value or ""))
                        item.setEditable(False)
                        items.append(item)
                    self._schema_model.appendRow(items)
            finally:
                if selection is not None:
                    selection.blockSignals(False)
            self.dlg_qm.tbl_schemas.setSortingEnabled(True)
            self._apply_schema_table_height()
            self._apply_dialog_height()
            if previous_schema:
                self._select_schema_row(previous_schema)
            else:
                self._update_schema_label()
        finally:
            self.dlg_qm.btn_refresh.setEnabled(True)

    def _fetch_schema_language(self, schema_name: str) -> str:
        if not schema_name or not tools_db.dao:
            return ""
        sql = (
            f"SELECT language FROM {schema_name}.sys_version "
            "ORDER BY id DESC LIMIT 1"
        )
        row = tools_db.get_row(sql, commit=self.dev_commit)
        if row and row[0]:
            return str(row[0])
        return ""

    def _select_schema_row(self, schema_name: str) -> None:
        for row_idx in range(self._schema_model.rowCount()):
            item = self._schema_model.item(row_idx, _COL_SCHEMA)
            if item and item.text() == schema_name:
                self.dlg_qm.tbl_schemas.selectRow(row_idx)
                self._selected_schema = schema_name
                self._update_schema_label()
                return

    def _update_schema_label(self) -> None:
        schema_name = self._selected_schema_name()
        if not schema_name:
            self.dlg_qm.lbl_schema_selection.setText(
                tools_qt.tr("Schema: select a row below"),
            )
            return
        self.dlg_qm.lbl_schema_selection.setText(
            f"{tools_qt.tr('Schema')}: {schema_name}",
        )

    def _selected_schema_name(self) -> str:
        selection = self.dlg_qm.tbl_schemas.selectionModel()
        if selection is None:
            return ""
        indexes = selection.selectedRows()
        if not indexes:
            return ""
        item = self._schema_model.item(indexes[0].row(), _COL_SCHEMA)
        return item.text() if item else ""

    def _on_schema_selection_changed(self, *_args) -> None:
        self._selected_schema = self._selected_schema_name()
        self._update_schema_label()
        row = admin_catalog.find_inventory_row(
            self._inventory_rows, schema=self._selected_schema,
        )
        if not row:
            return
        kind = str(row.get("kind") or "").lower()
        if kind in self.dbtables_dic or kind in _I18N_SCHEMAS:
            self._ensure_dbtables_dic(kind)
            self._tables_project_type = kind

    def _open_manage_language(self) -> None:
        dlg = getattr(self, 'dlg_i18n_languages', None)
        if dlg is not None and not isdeleted(dlg) and dlg.isVisible():
            tools_gw.focus_open_dialog(dlg)
            return

        dlg = GwI18NManageLanguagesDialog(self, parent=self.dlg_qm)
        dlg.init_dialog()
        self.dlg_i18n_languages = dlg

    def _selected_schema_row(self) -> dict | None:
        schema_name = self._selected_schema_name()
        if not schema_name:
            return None
        return admin_catalog.find_inventory_row(self._inventory_rows, schema=schema_name)

    def _run_update(self):
        """Apply locally downloaded i18n SQL files to the selected schema."""

        row = self._selected_schema_row()
        if not row:
            msg = "Select a schema"
            tools_qt.show_info_box(msg)
            return

        self._save_language_selection()
        self.language = tools_qt.get_combo_value(self.dlg_qm, self.dlg_qm.cmb_language, 0)
        if not self.language:
            msg = "Select a language"
            tools_qt.show_info_box(msg)
            return

        kind = str(row.get("kind") or "").upper()
        schema_name = str(row.get("schema") or "")
        if kind not in _TRANSLATABLE_KINDS:
            msg = "{0}: unsupported type {1}"
            msg_params = (schema_name, kind or "?")
            tools_qt.show_info_box(msg, msg_params=msg_params)
            return

        if not self._local_language_files_exist(self.language, kind.lower()):
            msg = "No local SQL files found for language ({0}). Download them first."
            tools_qt.show_info_box(msg, msg_params=(self.language,))
            return

        msg = "Apply translation ({0}) to schema ({1}) using local SQL files?"
        title = "Update translation?"
        msg_params = (self.language, schema_name)
        if not tools_qt.show_question(msg, title, msg_params=msg_params):
            return

        self.cursor_dest = tools_db.dao.get_cursor()
        self.add_tab_data = tools_qt.is_checked(self.dlg_qm, self.dlg_qm.chk_add_tab_data)
        self.project_type = kind.lower()
        self.schema = schema_name
        self._tables_project_type = self.project_type

        self.dlg_qm.setEnabled(False)
        try:
            status_cfg_msg, schema_errors = self._apply_local_sql_files()
            if status_cfg_msg is True:
                self._change_lang()
                msg = "{0}: Database translation successful to {1}."
                msg_params = (schema_name, self.language)
            elif status_cfg_msg is False:
                msg = "{0}: Database translation failed."
                msg_params = (schema_name,)
            else:
                msg = "{0}: Database translation canceled."
                msg_params = (schema_name,)
            if schema_errors:
                msg = f"{tools_qt.tr(msg, list_params=msg_params)} Errors: {', '.join(schema_errors)}"
                msg_params = None
        finally:
            self.dlg_qm.setEnabled(True)

        tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', msg, msg_params=msg_params)
        tools_qt.show_info_box(msg, msg_params=msg_params)
        self._refresh_schema_table()

    def make_list_multiple_option(self, completer, model, widget, list_widget):
        if widget is None:
            widget = self.dlg_qm.findChild(QLineEdit)
        if list_widget is None:
            list_widget = self.dlg_qm.findChild(QListWidget, 'list_widget')
        if not widget or not self.dbtables_dic:
            return

        project_type = self._tables_project_type
        if project_type not in self.dbtables_dic:
            project_type = "ws"
        value = widget.text()
        display_list = []
        selected = [list_widget.item(i).text() for i in range(list_widget.count())]
        for table in self.dbtables_dic[project_type]['dbtables']:
            if value and value not in table:
                continue
            if table in selected:
                continue
            display_list.append({"id": table, "idval": table})
        tools_qt.set_completer_object(
            completer, model, widget, sorted(display_list, key=lambda x: x["idval"]),
        )

    @staticmethod
    def _folder_locale(locale: str) -> str:
        return locale.replace("-", "_")

    def _dbmodel_dir(self) -> str:
        return os.path.join(lib_vars.plugin_dir, 'dbmodel')

    def _local_i18n_dir(self, kind: str, locale: str) -> str:
        schema_path = _I18N_SCHEMAS.get(kind)
        if not schema_path:
            return ""
        folder = self._folder_locale(locale)
        return os.path.join(self._dbmodel_dir(), schema_path, folder)

    def _local_language_files_exist(self, locale: str, kind: str) -> bool:
        folder = self._local_i18n_dir(kind, locale)
        if not folder or not os.path.isdir(folder):
            return False
        return any(name.endswith('.sql') for name in os.listdir(folder))

    def _sql_sources_for_kind(self, kind: str) -> list[tuple[str, str]]:
        """Return (i18n_kind, target_schema) pairs to execute for a project kind."""
        return [(kind, self.schema)]

    def _discover_dbtables(self, kind: str, locale: str) -> list[str]:
        i18n_dir = self._local_i18n_dir(kind, locale)
        if not i18n_dir or not os.path.isdir(i18n_dir):
            return []
        return sorted(
            os.path.splitext(name)[0]
            for name in os.listdir(i18n_dir)
            if name.endswith('.sql')
        )

    def _ensure_dbtables_dic(self, kind: str) -> None:
        if kind in self.dbtables_dic:
            return
        locale = tools_qt.get_combo_value(self.dlg_qm, self.dlg_qm.cmb_language, 0) or "en_US"
        tables = self._discover_dbtables(kind, locale)
        if tables:
            self.dbtables_dic[kind] = {
                "dbtables": tables,
                "project_type": [kind],
            }

    def _resolve_dbtables(self) -> list[str]:
        use_selected = tools_qt.is_checked(self.dlg_qm, self.dlg_qm.chk_use_selected_tables)
        discovered = set(self._discover_dbtables(self.project_type, self.language))

        if use_selected and getattr(self, 'selected_dbtables_dic', None):
            selected = self.selected_dbtables_dic.get(
                self.project_type, {},
            ).get('dbtables')
            if selected:
                return [
                    table for table in selected
                    if table in discovered
                ]

        self._ensure_dbtables_dic(self.project_type)
        preferred = []
        if self.project_type in self.dbtables_dic:
            preferred = self.dbtables_dic[self.project_type]['dbtables']
        elif discovered:
            preferred = sorted(discovered)

        ordered = [table for table in preferred if table in discovered]
        extras = sorted(discovered.difference(ordered))
        return ordered + extras

    @staticmethod
    def _sql_schema_name(schema_name: str) -> str:
        name = str(schema_name or "").replace('"', '').strip()
        if not name:
            return name
        if re.fullmatch(r"[a-z_][a-z0-9_]*", name):
            return name
        escaped = name.replace('"', '""')
        return f'"{escaped}"'

    @staticmethod
    def _last_db_error() -> str:
        err = lib_vars.session_vars.get("last_error")
        if err is None:
            return ""
        pgerror = getattr(err, "pgerror", None)
        if pgerror:
            return str(pgerror).strip()
        diag = getattr(err, "diag", None)
        if diag is not None and getattr(diag, "message_primary", None):
            return str(diag.message_primary).strip()
        return str(err).strip()

    def _apply_local_sql_files(self):
        """Read downloaded .sql files and apply them to the selected schema."""

        dbtables = self._resolve_dbtables()
        if not dbtables:
            folder = self._local_i18n_dir(self.project_type, self.language)
            return False, [folder or self.project_type]

        messages = []
        for source_kind, target_schema in self._sql_sources_for_kind(self.project_type):
            i18n_dir = self._local_i18n_dir(source_kind, self.language)
            if not i18n_dir or not os.path.isdir(i18n_dir):
                messages.append(i18n_dir or source_kind)
                continue

            for dbtable in dbtables:
                sql_path = os.path.join(i18n_dir, f"{dbtable}.sql")
                if not os.path.isfile(sql_path):
                    continue

                tools_qt.set_widget_text(
                    self.dlg_qm, 'lbl_info',
                    "Updating {0}...",
                    msg_params=(f"{target_schema}/{dbtable}",),
                )
                ok, error = self._execute_local_sql_file(sql_path, target_schema)
                if not ok:
                    detail = error or os.path.basename(sql_path)
                    messages.append(f"{dbtable}.sql: {detail}")
                    if not tools_os.set_boolean(self.dev_commit, False):
                        break

        if messages:
            return False, messages
        return True, None

    def _execute_local_sql_file(self, filepath: str, schema_name: str) -> tuple[bool, str]:
        try:
            with open(filepath, encoding='utf-8') as handle:
                sql = handle.read()
        except OSError as exc:
            return False, str(exc)

        sql_schema = self._sql_schema_name(schema_name)
        sql = sql.replace("SCHEMA_NAME", sql_schema)
        if not self.add_tab_data and os.path.basename(filepath) in _FORM_FIELDS_SQL:
            sql = self._strip_tab_data_rows(sql)

        if not sql.strip():
            return True, ""

        ok = tools_db.execute_sql(
            sql,
            filepath=filepath,
            commit=self.dev_commit,
            is_thread=True,
            show_exception=False,
        )
        if ok:
            return True, ""
        return False, self._last_db_error() or os.path.basename(filepath)

    @staticmethod
    def _strip_tab_data_rows(sql: str) -> str:
        """Remove config_form_fields rows for tab_data when the option is unchecked."""
        cleaned_lines = []
        for line in sql.splitlines():
            if _TAB_DATA_LINE_RE.search(line):
                continue
            cleaned_lines.append(line)
        cleaned = "\n".join(cleaned_lines)
        cleaned = re.sub(r",(\s*)\)", r"\1)", cleaned)
        return cleaned

    def _change_lang(self) -> None:
        lang = self.language.replace("'", "''")
        schema = self._sql_schema_name(self.schema)
        query = f"UPDATE {schema}.sys_version SET language = '{lang}'"
        try:
            self.cursor_dest.execute(query)
            tools_db.dao.commit()
        except Exception:
            tools_db.dao.rollback()

    def update_selected_table_dic(self):
        if not hasattr(self, 'dlg_qm'):
            return
        list_widget = self.dlg_qm.findChild(QListWidget, 'list_widget')
        org_tables_dic = self.tables_dic()
        if list_widget:
            self.selected_tables = [list_widget.item(i).text() for i in range(list_widget.count())]
            self.selected_dbtables_dic = {
                "ws": {
                    "dbtables": [table for table in self.selected_tables if table in org_tables_dic["ws"]["dbtables"]],
                    "project_type": ["ws", "utils"]
                },
                "ud": {
                    "dbtables": [table for table in self.selected_tables if table in org_tables_dic["ud"]["dbtables"]],
                    "project_type": ["ud", "utils"]
                },
                "am": {
                    "dbtables": [table for table in self.selected_tables if table in org_tables_dic["am"]["dbtables"]],
                    "project_type": ["am"]
                },
                "cm": {
                    "dbtables": [table for table in self.selected_tables if table in org_tables_dic["cm"]["dbtables"]],
                    "project_type": ["cm"]
                },
            }

    @staticmethod
    def tables_dic():
        return {
            "ws": {
                "dbtables": list(_NETWORK_DBTABLES),
                "project_type": ["ws", "utils"],
            },
            "ud": {
                "dbtables": list(_NETWORK_DBTABLES),
                "project_type": ["ud", "utils"],
            },
            "am": {
                "dbtables": ["dbconfig_engine", "dbconfig_form_tableview", "su_basic_tables"],
                "project_type": ["am"]
            },
            "cm": {
                "dbtables": ["dbconfig_form_fields", "dbconfig_form_tabs", "dbconfig_param_system",
                             "dbtypevalue", "dbtable", "dbconfig_form_tableview", "dbfprocess", "dbconfig_form_fields_json"],
                "project_type": ["cm"]
            },
        }

    def _save_user_values(self):
        language = tools_qt.get_combo_value(self.dlg_qm, self.dlg_qm.cmb_language, 0)
        if language:
            tools_gw.set_config_parser(
                'i18n_generator', 'qm_lang_language', f"{language}",
                "user", "session", prefix=False,
            )

    def _load_user_values(self):
        tools_gw.get_config_parser('i18n_generator', 'qm_lang_host', "user", "session", False)
        tools_gw.get_config_parser('i18n_generator', 'qm_lang_port', "user", "session", False)
        tools_gw.get_config_parser('i18n_generator', 'qm_lang_db', "user", "session", False)
        tools_gw.get_config_parser('i18n_generator', 'qm_lang_user', "user", "session", False)
