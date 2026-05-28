"""
Manage satellite / auxiliary schemas from a single dialog.
"""

from __future__ import annotations

from functools import partial

from qgis.PyQt.QtCore import QEvent, Qt
from qgis.PyQt.QtGui import QStandardItem, QStandardItemModel
from qgis.PyQt.QtWidgets import QHeaderView

from ..ui.ui_manager import GwAdminManageSchemasUi
from ...libs import tools_qt
from . import _admin_catalog as admin_catalog

_NETWORK_COLUMNS = ("Schema", "Kind", "Version", "Profile", "Linked")
_COL_SCHEMA = 0


class GwManageSchemasDialog(GwAdminManageSchemasUi):

    def __init__(self, admin_btn, parent=None):
        super().__init__(admin_btn, parent=parent)
        self.admin = admin_btn
        self._inventory_rows: list[dict] = []
        self._selected_network_parent = ""
        self._network_model = QStandardItemModel(0, len(_NETWORK_COLUMNS), self)
        self._network_model.setHorizontalHeaderLabels(list(_NETWORK_COLUMNS))

        self.messageBar().hide()
        self._setup_network_table()
        self._refresh_inventory()
        self._connect_signals()

    def _connect_signals(self) -> None:
        self.btn_refresh.clicked.connect(partial(self._refresh_inventory))
        self.btn_update_network.clicked.connect(partial(self._update_network))
        self.btn_utils_create.clicked.connect(partial(self.admin._create_utils))
        self.btn_utils_integrate.clicked.connect(partial(self._integrate_utils))
        self.btn_utils_update.clicked.connect(partial(self.admin._update_utils))
        self.btn_cibs_create.clicked.connect(partial(self.admin._create_cibs))
        self.btn_cibs_integrate.clicked.connect(partial(self._integrate_cibs))
        self.btn_cibs_copy.clicked.connect(partial(self._adapt_cibs_copy))
        self.btn_cibs_update.clicked.connect(partial(self.admin._update_cibs))
        self.btn_create_am.clicked.connect(partial(self._create_am))
        self.btn_update_am.clicked.connect(partial(self._update_am))
        self.btn_delete_am.clicked.connect(partial(self.admin._delete_other_schema, 'am'))
        self.btn_create_cm.clicked.connect(partial(self.admin._open_create_cm_project))
        self.btn_update_cm.clicked.connect(partial(self._update_cm))
        self.btn_delete_cm.clicked.connect(partial(self._delete_cm))
        self.btn_create_audit.clicked.connect(partial(self._create_audit))
        self.btn_update_audit.clicked.connect(partial(self.admin._update_audit))
        self.btn_activate_audit.clicked.connect(partial(self._activate_audit))
        self.btn_reload_audit_triggers.clicked.connect(partial(self._reload_audit_triggers))
        self.btn_delete_audit.clicked.connect(partial(self.admin._delete_other_schema, 'audit'))
        self.btn_close.clicked.connect(self.close)
        selection = self.tbl_network.selectionModel()
        if selection is not None:
            selection.selectionChanged.connect(partial(self._on_network_selection_changed))

    def _setup_network_table(self) -> None:
        self.tbl_network.setModel(self._network_model)
        self.tbl_network.setAlternatingRowColors(True)
        self.tbl_network.setSortingEnabled(True)
        self.tbl_network.verticalHeader().setVisible(False)

        header = self.tbl_network.horizontalHeader()
        header.setStretchLastSection(True)
        header.setSectionResizeMode(_COL_SCHEMA, QHeaderView.ResizeMode.Stretch)
        header.setSectionResizeMode(1, QHeaderView.ResizeMode.ResizeToContents)
        header.setSectionResizeMode(2, QHeaderView.ResizeMode.ResizeToContents)
        header.setSectionResizeMode(3, QHeaderView.ResizeMode.ResizeToContents)
        header.setSectionResizeMode(4, QHeaderView.ResizeMode.Stretch)
        self.tbl_network.viewport().installEventFilter(self)

    def eventFilter(self, watched, event):
        if watched is self.tbl_network.viewport():
            if (
                event.type() == QEvent.Type.MouseButtonPress
                and event.button() == Qt.MouseButton.LeftButton
            ):
                index = self.tbl_network.indexAt(event.pos())
                if index.isValid():
                    selection = self.tbl_network.selectionModel()
                    if selection is not None and selection.isSelected(index):
                        selection.clearSelection()
                        return True
        return super().eventFilter(watched, event)

    def _network_rows(self) -> list[dict]:
        return [
            row for row in self._inventory_rows
            if str(row.get("kind") or "").upper() in ("WS", "UD")
        ]

    def _refresh_inventory(self) -> None:
        previous_parent = self._selected_network_parent
        self._inventory_rows = admin_catalog.fetch_schema_inventory()
        self._populate_network_table()
        if previous_parent:
            self._select_network_row(previous_parent)
        self._update_schema_labels()
        self._update_action_state()

    def _populate_network_table(self) -> None:
        self.tbl_network.setSortingEnabled(False)
        self._network_model.removeRows(0, self._network_model.rowCount())
        for row in self._network_rows():
            values = (
                row.get("schema", ""),
                row.get("kind", ""),
                row.get("version", ""),
                row.get("profile", ""),
                row.get("linked", ""),
            )
            items = []
            for value in values:
                item = QStandardItem(str(value or ""))
                item.setEditable(False)
                items.append(item)
            self._network_model.appendRow(items)
        self.tbl_network.setSortingEnabled(True)

    def _on_network_selection_changed(self, *_args) -> None:
        self._selected_network_parent = self._selected_parent()
        self._update_network_label()
        self._update_action_state()

    def _selected_parent(self) -> str:
        selection = self.tbl_network.selectionModel()
        if selection is None:
            return ""
        indexes = selection.selectedRows()
        if not indexes:
            return ""
        row_idx = indexes[0].row()
        item = self._network_model.item(row_idx, _COL_SCHEMA)
        return item.text() if item else ""

    def _select_network_row(self, schema_name: str) -> None:
        for row_idx in range(self._network_model.rowCount()):
            item = self._network_model.item(row_idx, _COL_SCHEMA)
            if item and item.text() == schema_name:
                self.tbl_network.selectRow(row_idx)
                self._selected_network_parent = schema_name
                self._update_network_label()
                return

    def _parent_context(self) -> tuple[str, str]:
        parent = self._selected_parent()
        return parent, self._parent_kind(parent)

    def _parent_kind(self, schema_name: str) -> str:
        row = admin_catalog.find_inventory_row(self._inventory_rows, schema=schema_name)
        if row:
            return str(row.get("kind") or "").upper()
        for schema, project_type in admin_catalog.fetch_sys_version_schemas():
            if schema == schema_name:
                return str(project_type).upper()
        return ""

    def _format_schema_info(self, row: dict | None, default_name: str = "") -> str:
        if not row:
            return "Not installed"
        schema = str(row.get("schema") or default_name or "?")
        version = str(row.get("version") or "?")
        return f"{schema} · {version}"

    def _satellite_row(self, *, kind: str | None = None, schema: str | None = None) -> dict | None:
        return admin_catalog.find_inventory_row(
            self._inventory_rows,
            kind=kind,
            schema=schema,
        )

    def _set_info_label(self, attr: str, text: str) -> None:
        label = getattr(self, attr, None)
        if label is not None:
            label.setText(text)

    def _update_schema_labels(self) -> None:
        utils_row = self._satellite_row(schema="utils")
        cibs_row = self._satellite_row(schema="cibs")
        am_row = self._satellite_row(kind="AM") or self._satellite_row(schema="am")
        cm_row = self._satellite_row(kind="CM")
        audit_row = self._satellite_row(kind="AUDIT") or self._satellite_row(schema="audit")

        self._set_info_label("lbl_utils_info", self._format_schema_info(utils_row, "utils"))
        self._set_info_label("lbl_cibs_info", self._format_schema_info(cibs_row, "cibs"))
        self._set_info_label("lbl_am_info", self._format_schema_info(am_row, "am"))
        self._set_info_label("lbl_cm_info", self._format_schema_info(cm_row, "cm"))
        self._set_info_label("lbl_audit_info", self._format_schema_info(audit_row, "audit"))
        self._update_network_label()

    def _update_network_label(self) -> None:
        parent = self._selected_parent()
        if not parent:
            self.lbl_network_selection.setText("Anchor: select a row below")
            return
        row = self._satellite_row(schema=parent)
        kind = str((row or {}).get("kind") or self._parent_kind(parent) or "?").upper()
        version = str((row or {}).get("version") or "?")
        self.lbl_network_selection.setText(f"Anchor: {parent} · {kind} · {version}")

    def _needs_update(self, version: str) -> bool:
        return admin_catalog.schema_needs_plugin_update(
            version,
            str(self.admin.plugin_version),
        )

    def _network_has_pending_updates(self, anchor: str) -> bool:
        if not anchor or self._parent_kind(anchor) not in ("WS", "UD"):
            return False
        plan = admin_catalog.build_network_update_plan(anchor, str(self.admin.plugin_version))
        return any(step.get("needs_update") for step in plan)

    def _update_action_state(self, *_args) -> None:
        parent, parent_kind = self._parent_context()
        has_network_parent = bool(parent) and parent_kind in ("WS", "UD")

        utils_row = self._satellite_row(schema="utils")
        cibs_row = self._satellite_row(schema="cibs")
        am_row = self._satellite_row(kind="AM") or self._satellite_row(schema="am")
        cm_row = self._satellite_row(kind="CM")
        audit_row = self._satellite_row(kind="AUDIT") or self._satellite_row(schema="audit")

        utils_exists = utils_row is not None
        cibs_exists = cibs_row is not None
        am_exists = am_row is not None
        cm_exists = cm_row is not None
        audit_exists = audit_row is not None

        self.btn_utils_create.setEnabled(not utils_exists)
        self.btn_utils_update.setEnabled(
            utils_exists and self._needs_update(str((utils_row or {}).get("version") or ""))
        )
        self.btn_utils_integrate.setEnabled(
            has_network_parent
            and utils_exists
            and not admin_catalog.parent_satellite_linked(
                self._inventory_rows, parent, "utils"
            )
        )

        self.btn_cibs_create.setEnabled(not cibs_exists)
        self.btn_cibs_update.setEnabled(
            cibs_exists and self._needs_update(str((cibs_row or {}).get("version") or ""))
        )
        self.btn_cibs_integrate.setEnabled(
            has_network_parent
            and cibs_exists
            and not admin_catalog.parent_satellite_linked(
                self._inventory_rows, parent, "cibs"
            )
        )
        self.btn_cibs_copy.setEnabled(has_network_parent and cibs_exists)

        self.btn_create_am.setEnabled(not am_exists and has_network_parent and parent_kind == "WS")
        self.btn_update_am.setEnabled(
            am_exists and self._needs_update(str((am_row or {}).get("version") or ""))
        )
        self.btn_delete_am.setEnabled(am_exists)

        self.btn_create_cm.setEnabled(not cm_exists and has_network_parent)
        self.btn_update_cm.setEnabled(
            cm_exists and self._needs_update(str((cm_row or {}).get("version") or ""))
        )
        self.btn_delete_cm.setEnabled(cm_exists)

        self.btn_create_audit.setEnabled(not audit_exists)
        self.btn_update_audit.setEnabled(
            audit_exists and self._needs_update(str((audit_row or {}).get("version") or ""))
        )
        self.btn_activate_audit.setEnabled(audit_exists and has_network_parent)
        self.btn_reload_audit_triggers.setEnabled(audit_exists and has_network_parent)
        self.btn_delete_audit.setEnabled(audit_exists)

        self.btn_update_network.setEnabled(self._network_has_pending_updates(parent))

    def _update_network(self) -> None:
        parent = self._selected_parent()
        if not parent:
            tools_qt.show_info_box("Select a WS or UD schema in the table.")
            return
        if self._parent_kind(parent) not in ("WS", "UD"):
            tools_qt.show_info_box("Update network requires a WS or UD anchor.")
            return
        self.admin._update_network(anchor_schema=parent)

    def _create_am(self) -> None:
        parent, parent_type = self._parent_context()
        if not parent or parent_type != "WS":
            tools_qt.show_info_box("Select a WS anchor in the network table.")
            return
        self.admin.create_project_data_other_schema(
            'am',
            parent_schema=parent,
            parent_type=parent_type.lower(),
        )

    def _create_audit(self) -> None:
        self.admin.create_project_data_other_schema('audit')

    def _update_am(self) -> None:
        parent, parent_type = self._parent_context()
        self.admin._update_asset(
            parent_schema=parent,
            parent_type=parent_type.lower(),
        )

    def _update_cm(self) -> None:
        parent, parent_type = self._parent_context()
        cm_row = self._satellite_row(kind="CM")
        cm_schema = str((cm_row or {}).get("schema") or admin_catalog.find_cm_schema() or "cm")
        self.admin._update_cm(
            parent_schema=parent,
            parent_type=parent_type.lower(),
            cm_schema=cm_schema,
        )

    def _delete_cm(self) -> None:
        cm_row = self._satellite_row(kind="CM")
        schema_name = str((cm_row or {}).get("schema") or admin_catalog.find_cm_schema() or "cm")
        self.admin._delete_other_schema(schema_name)

    def _activate_audit(self) -> None:
        parent, parent_type = self._parent_context()
        if not parent:
            tools_qt.show_info_box("Select a WS/UD anchor in the network table.")
            return
        self.admin._activate_audit(
            'audit',
            parent_schema=parent,
            parent_type=parent_type.lower(),
        )

    def _reload_audit_triggers(self) -> None:
        parent = self._selected_parent()
        if not parent:
            tools_qt.show_info_box("Select a WS/UD anchor in the network table.")
            return
        self.admin._reload_audit_triggers(schema_name=parent)

    def _integrate_utils(self):
        parent, parent_kind = self._parent_context()
        if not parent:
            tools_qt.show_info_box("Select a WS or UD anchor in the network table.")
            return
        if parent_kind == "WS":
            self.admin._adapt_utils_ws(ws_schema=parent)
        elif parent_kind == "UD":
            self.admin._adapt_utils_ud(ud_schema=parent)
        else:
            tools_qt.show_info_box("Integrate utils requires a WS or UD anchor.")

    def _integrate_cibs(self):
        parent = self._selected_parent()
        if not parent:
            tools_qt.show_info_box("Select a network anchor to integrate cibs.")
            return
        tools_qt.set_widget_text(self.admin.dlg_readsql, self.admin.dlg_readsql.cmb_cibs, parent)
        self.admin._adapt_cibs()

    def _adapt_cibs_copy(self):
        parent = self._selected_parent()
        if not parent:
            tools_qt.show_info_box("Select a network anchor to copy cibs data.")
            return
        tools_qt.set_widget_text(self.admin.dlg_readsql, self.admin.dlg_readsql.cmb_cibs, parent)
        self.admin._copy_cibs_data()
