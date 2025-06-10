"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import QDate, Qt
from qgis.PyQt.QtGui import QStandardItem, QStandardItemModel
from qgis.PyQt.QtWidgets import QAbstractItemView, QCheckBox, QComboBox, QLineEdit, \
    QTableView, QWidget, QDateEdit, QLabel, QTextEdit, QCompleter

from typing import Optional, List
from functools import partial

from ...ui.ui_manager import TeamCreateUi, UserCreateUi, AddLotUi, LotManagementUi, \
    ResourcesManagementUi, OrganizationCreateUi

from .... import global_vars
from ....libs import lib_vars, tools_qgis, tools_qt, tools_db
from ...utils import tools_gw
from ...utils.selection_mode import GwSelectionMode


class AddNewLot:

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        """ Class to control 'Add basic visit' of toolbar 'edit' """

        self.ids = []
        self.canvas = global_vars.canvas
        self.rb_red = tools_gw.create_rubberband(self.canvas)
        self.rb_red.setColor(Qt.darkRed)
        self.rb_red.setIconSize(20)
        self.rb_list = []
        self.schema_parent = lib_vars.schema_name
        # self.cm_schema = lib_vars.project_vars['cm_schema']
        self.lot_date_format = 'yyyy-MM-dd'
        self.max_id = 0
        self.signal_selectionChanged = False
        self.param_options = None
        self.plugin_name = 'Giswater'
        self.plugin_dir = lib_vars.plugin_dir
        self.schemaname = lib_vars.schema_name
        self.iface = global_vars.iface
        self.dict_tables = None
        self.lot_saved = False
        self.is_new_lot = True

    def manage_lot(self, lot_id=None, is_new=True):
        """Open the AddLot dialog and load dynamic fields from gw_fct_getlot."""

        self.lot_id = lot_id
        self.rubber_band = tools_gw.create_rubberband(self.canvas)
        self.is_new_lot = is_new
        self.lot_id_value = None
        self.ids = []
        self.rb_list = []
        self.feature_type = 'arc'
        self.signal_selectionChanged = False
        self.cmb_position = 17
        self.srid = lib_vars.data_epsg
        table_object = "lot"

        if is_new:
            self.is_new_lot = True
            self.lot_saved = False
        else:
            self.is_new_lot = False
            self.lot_saved = True

        self.list_ids = {ft: [] for ft in ['arc', 'node', 'connec', 'gully', 'link']}
        self.excluded_layers = [f"v_edit_{ft}" for ft in self.list_ids]

        self.layers = {ft: tools_gw.get_layers_from_feature_type(ft) for ft in ['arc', 'node', 'connec', 'link']}
        if tools_gw.get_project_type() == 'ud':
            self.layers['gully'] = tools_gw.get_layers_from_feature_type('gully')

        # Create dialog and load base settings
        self.dlg_lot = AddLotUi(self)
        tools_gw.load_settings(self.dlg_lot)

        # Load dynamic form and apply fields
        self.load_lot_dialog(lot_id)

        # Reference key widgets
        self.user_name = self.dlg_lot.findChild(QLineEdit, "user_name")

        if self.lot_id_value:
            widget = self.get_widget_by_columnname(self.dlg_lot, "lot_id")
            if widget:
                widget.setText(str(self.lot_id_value))

        # Fill workorder part (custom logic)
        self.fill_workorder_fields()

        if lot_id:
            self._load_lot_relations(lot_id)
            self.enable_feature_tabs_by_campaign(lot_id)

        if tools_gw.get_project_type() == 'ws':
            tools_qt.enable_tab_by_tab_name(self.dlg_lot.tab_widget, 'LoadsTab', False)

        # Icon buttons
        tools_gw.add_icon(self.dlg_lot.btn_insert, '111')
        tools_gw.add_icon(self.dlg_lot.btn_delete, '112')
        tools_gw.add_icon(self.dlg_lot.btn_snapping, '137')
        tools_gw.add_icon(self.dlg_lot.btn_expr_select, '178')

        # Cancel / Accept
        self.dlg_lot.btn_cancel.clicked.connect(self.dlg_lot.reject)
        self.dlg_lot.rejected.connect(self.manage_rejected)
        self.dlg_lot.rejected.connect(partial(self.reset_rb_list, self.rb_list))
        self.dlg_lot.btn_accept.clicked.connect(self.save_lot)
        self.dlg_lot.rejected.connect(lambda: tools_gw.reset_rubberband(self.rubber_band))
        self.dlg_lot.rejected.connect(lambda: tools_gw.remove_selection(True, layers=self.layers))

        # Tab logic
        name_widget = self.get_widget_by_columnname(self.dlg_lot, "name")
        if name_widget:
            name_widget.textChanged.connect(self._check_enable_tab_relations)
            self._check_enable_tab_relations()

        if tools_gw.get_project_type() == 'ws':
            index = self.dlg_lot.tab_feature.indexOf(self.dlg_lot.tab_gully)
            if index != -1:
                self.dlg_lot.tab_feature.removeTab(index)

        self.dlg_lot.tab_widget.currentChanged.connect(self._on_tab_change)
        self.dlg_lot.tab_feature.currentChanged.connect(self._on_tab_feature_changed)
        self.dlg_lot.tab_feature.currentChanged.connect(lambda: self._update_feature_completer_lot(self.dlg_lot))

        # Relation feature buttons
        self.dlg_lot.btn_insert.clicked.connect(
            lambda: tools_gw.insert_feature(self, self.dlg_lot, table_object, GwSelectionMode.LOT, False, None, None,
                                            refresh_callback=lambda: self._load_lot_relations(self.lot_id))
        )
        self.dlg_lot.btn_insert.clicked.connect(lambda: self._update_feature_completer_lot(self.dlg_lot))

        self.dlg_lot.btn_delete.clicked.connect(
            lambda: tools_gw.delete_records(self, self.dlg_lot, table_object, GwSelectionMode.LOT, None, None, None,
                                            refresh_callback=lambda: self._load_lot_relations(self.lot_id))
        )
        self.dlg_lot.btn_delete.clicked.connect(lambda: self._update_feature_completer_lot(self.dlg_lot))

        self.dlg_lot.btn_snapping.clicked.connect(
            partial(tools_gw.selection_init, self, self.dlg_lot, table_object, GwSelectionMode.LOT)
        )
        self.dlg_lot.btn_snapping.clicked.connect(lambda: self._update_feature_completer_lot(self.dlg_lot))

        self.dlg_lot.btn_expr_select.clicked.connect(
            partial(tools_gw.select_with_expression_dialog, self, self.dlg_lot, table_object,
                    selection_mode=GwSelectionMode.EXPRESSION_LOT)
        )
        self.dlg_lot.btn_expr_select.clicked.connect(lambda: self._update_feature_completer_lot(self.dlg_lot))

        # Always set multi-row and full row selection for relation tables, both on create and edit
        relation_table_names = [
            "tbl_campaign_lot_x_arc",
            "tbl_campaign_lot_x_node",
            "tbl_campaign_lot_x_connec",
            "tbl_campaign_lot_x_link"
        ]
        if tools_gw.get_project_type() == 'ud':
            relation_table_names.append("tbl_campaign_lot_x_gully")

        for table_name in relation_table_names:
            view = getattr(self.dlg_lot, table_name, None)
            if view:
                tools_qt.set_tableview_config(view)

        # Open dialog
        tools_gw.open_dialog(self.dlg_lot, dlg_name="add_lot")

    def load_lot_dialog(self, lot_id):
        """Dynamically load and populate lot dialog using gw_fct_getlot"""

        p_data = {
            "feature": {"tableName": "om_campaign_lot", "idName": "lot_id"},
            "data": {}
        }
        if lot_id:
            p_data["feature"]["id"] = lot_id

        response = tools_gw.execute_procedure("gw_fct_getlot", p_data, schema_name="cm")
        if not response or response.get("status") != "Accepted":
            tools_qgis.show_warning("Failed to load lot form.")
            return

        form_fields = response["body"]["data"].get("fields", [])
        self.fields_form = form_fields
        self.lot_id_value = response["body"].get("feature", {}).get("id")

        for field in form_fields:
            widget = self.create_widget_from_field(field)
            if not widget:
                continue

            # Prioritize selectedId for combos, otherwise use value
            if isinstance(widget, QComboBox) and "selectedId" in field:
                self.set_widget_value(widget, field["selectedId"])
            elif "value" in field:
                self.set_widget_value(widget, field["value"])
            if "columnname" in field:
                widget.setProperty("columnname", field["columnname"])
            if "widgetname" in field:
                widget.setObjectName(field["widgetname"])

            label = QLabel(field["label"]) if field.get("label") else None
            tools_gw.add_widget(self.dlg_lot, field, label, widget)

    def create_widget_from_field(self, field):
        """Create a Qt widget based on field metadata"""

        wtype = field.get("widgettype", "text")
        iseditable = field.get("iseditable", True)
        widget = None

        if wtype == "text":
            widget = QLineEdit()
            if not iseditable:
                widget.setEnabled(False)

        elif wtype == "textarea":
            widget = QTextEdit()
            if not iseditable:
                widget.setReadOnly(True)

        elif wtype == "datetime":
            widget = QDateEdit()
            widget.setCalendarPopup(True)
            widget.setDisplayFormat("MM/dd/yyyy")
            value = field.get("value")
            date = QDate.fromString(value, "yyyy-MM-dd") if value else QDate.currentDate()
            widget.setDate(date if date.isValid() else QDate.currentDate())
            if not iseditable:
                widget.setEnabled(False)

        elif wtype == "check":
            widget = QCheckBox()
            if not iseditable:
                widget.setEnabled(False)

        elif wtype == "combo":
            widget = QComboBox()
            ids = field.get("comboIds", [])
            names = field.get("comboNames", [])
            for i, name in enumerate(names):
                widget.addItem(name, ids[i] if i < len(ids) else name)
            if not iseditable:
                widget.setEnabled(False)

        # Get columns to ignore for tab_relations when export csv
        sql = "SELECT columnname FROM config_form_tableview WHERE location_type = 'lot' AND " \
              "visible IS NOT TRUE AND objectname = 've_lot_x_" + str(self.feature_type) + "'"
        rows = tools_db.get_rows(sql)
        result_relation = []
        if rows is not None:
            for row in rows:
                result_relation.append(row[0])
        return widget

    def _on_tab_feature_changed(self):
        # Update self.feature_type just like in Campaign
        self.feature_type = tools_gw.get_signal_change_tab(self.dlg_lot, self.excluded_layers)
        print(f"[DEBUG] feature_type updated to: {self.feature_type}")

    def get_allowed_features_for_lot(self, lot_id, feature):
        """Only be able to make the relations to the features id that come from campaign """
        # feature: "arc", "node", etc.
        row = tools_db.get_row(f"SELECT campaign_id FROM cm.om_campaign_lot WHERE lot_id = {lot_id}")
        campaign_id = row[0] if row else None
        if not campaign_id:
            return []

        feature_table = f"cm.om_campaign_x_{feature}"
        feature_id = f"{feature}_id"
        sql = f"SELECT {feature_id} FROM {feature_table} WHERE campaign_id = {campaign_id}"
        return [row[feature_id] for row in tools_db.get_rows(sql)]

    def enable_feature_tabs_by_campaign(self, lot_id):
        row = tools_db.get_row(f"SELECT campaign_id FROM cm.om_campaign_lot WHERE lot_id = {lot_id}")
        campaign_id = row[0] if row else None
        if not campaign_id:
            return []

        feature_types = ['arc', 'node', 'connec', 'link']

        for feature in feature_types:
            count_row = tools_db.get_row(
                f"SELECT COUNT(*) FROM cm.om_campaign_x_{feature} WHERE campaign_id = '{campaign_id}'")
            count = count_row[0] if count_row else 0
            tab_widget = getattr(self.dlg_lot, f"tab_{feature}", None)  # adjust to your widget naming
            if tab_widget:
                idx = self.dlg_lot.tab_feature.indexOf(tab_widget)
                self.dlg_lot.tab_feature.setTabEnabled(idx, count > 0)

    def _load_lot_relations(self, lot_id):
        """
        Load related elements into lot relation tabs for the given ID.
        Includes 'gully' only if project type is UD.
        """

        relation_tabs = {
            "tbl_campaign_lot_x_arc": ("om_campaign_lot_x_arc", "arc_id"),
            "tbl_campaign_lot_x_node": ("om_campaign_lot_x_node", "node_id"),
            "tbl_campaign_lot_x_connec": ("om_campaign_lot_x_connec", "connec_id"),
            "tbl_campaign_lot_x_link": ("om_campaign_lot_x_link", "link_id")

        }

        # Only include gully and link if project type is 'ud'
        if tools_gw.get_project_type() == 'ud':
            relation_tabs.update({
                "tbl_campaign_lot_x_gully": ("om_campaign_lot_x_gully", "gully_id"),
            })

        for table_name, (db_table, col_id) in relation_tabs.items():
            view = getattr(self.dlg_lot, table_name, None)
            if view:
                sql = f"SELECT * FROM cm.{db_table} WHERE lot_id = {lot_id}"
                self.populate_manager_lot(view, sql)

    def get_widget_by_columnname(self, dialog, columnname):
        for widget in dialog.findChildren(QWidget):
            if widget.property("columnname") == columnname:
                return widget
        return None

    def set_widget_value(self, widget, value):
        """Sets the widget value from JSON"""

        if isinstance(widget, QLineEdit):
            widget.setText(str(value))
        elif isinstance(widget, QTextEdit):
            widget.setPlainText(str(value))
        elif isinstance(widget, QDateEdit):
            if value:
                date = QDate.fromString(value, "yyyy-MM-dd")
                if date.isValid():
                    widget.setDate(date)
        elif isinstance(widget, QCheckBox):
            widget.setChecked(str(value).lower() in ["true", "1"])
        elif isinstance(widget, QComboBox):
            index = widget.findData(str(value))
            if index >= 0:
                widget.setCurrentIndex(index)

    def _check_enable_tab_relations(self):
        name_widget = self.get_widget_by_columnname(self.dlg_lot, "name")
        if not name_widget:
            return

        enable = bool(name_widget.text().strip())
        self.dlg_lot.tab_widget.setTabEnabled(self.dlg_lot.tab_widget.indexOf(self.dlg_lot.RelationsTab), enable)

    def _on_tab_change(self, index):
        tab = self.dlg_lot.tab_widget.widget(index)
        if tab.objectName() == "RelationsTab" and self.is_new_lot and not self.lot_saved:
            self.save_lot(from_change_tab=True)
            self.lot_saved = True  # Only block repeated auto-saves
            self.enable_feature_tabs_by_campaign(self.lot_id)

    def populate_cmb_team(self):
        """ Fill ComboBox cmb_assigned_to """

        sql = ("SELECT DISTINCT(cat_team.team_id), teamname "
               "FROM cm.cat_team WHERE active is True ORDER BY teamname")
        rows = tools_db.get_rows(sql, commit=True)

        if rows:
            cmb_assigned_to = self.dlg_lot.findChild(QComboBox, "cmb_assigned_to")
            if cmb_assigned_to:
                tools_qt.fill_combo_values(cmb_assigned_to, rows)
        else:
            self.dlg_lot.cmb_assigned_to.clear()

    def update_workorder_fields(self):
        """Fetch workorder info from DB and populate dynamic form fields."""

        cmb_ot = self.dlg_lot.findChild(QComboBox, "tab_data_wo")
        if not cmb_ot:
            return

        workorder_id = cmb_ot.currentData()
        if not workorder_id:
            return

        # Ejecutar SELECT
        sql = f"""
            SELECT workorder_class, workorder_id, workorder_type, workorder_class, address, serie,  observ
            FROM cm.workorder
            WHERE workorder_id = '{workorder_id}'
        """
        row = tools_db.get_row(sql)
        if not row:
            return

        # Asignar valores a campos del formulario
        mapping = {
            "tab_data_workorder_type": row["workorder_type"],
            "tab_data_workorder_class": row["workorder_class"],
            "tab_data_address": row["address"],
            "tab_data_observ": row["observ"],
        }

        for name, val in mapping.items():
            widget = self.dlg_lot.findChild(QWidget, name)
            if widget:
                self.set_widget_value(widget, val)

    def fill_workorder_fields(self):
        """ Fill combo boxes of the form """

        # Fill ComboBox cmb_assigned_to
        self.populate_cmb_team()
        # OT Combo is now filled
        cmb_ot = self.dlg_lot.findChild(QComboBox, "tab_data_wo")
        if cmb_ot:
            cmb_ot.currentIndexChanged.connect(self.update_workorder_fields)
            self.update_workorder_fields()  # call once immediately

    def save_lot(self, from_change_tab=False):
        """Save lot using gw_fct_setlot (dynamic form logic) with mandatory field validation."""

        fields = {}
        list_mandatory = []

        for field in self.fields_form:
            column = field.get("columnname")
            widget = self.dlg_lot.findChild(QWidget, field.get("widgetname"))
            if not widget:
                continue

            widget.setStyleSheet("")

            if isinstance(widget, QComboBox):
                value = widget.currentData()
            elif isinstance(widget, QDateEdit):
                value = widget.date().toString("yyyy-MM-dd") if widget.date().isValid() else None
            else:
                value = tools_qt.get_widget_value(self.dlg_lot, widget)

            fields[column] = value

            if field.get("ismandatory", False) and not value:
                widget.setStyleSheet("border: 1px solid red")
                list_mandatory.append(field.get("widgetname"))

        if list_mandatory:
            tools_qgis.show_warning(
                "Some mandatory fields are missing. Please fill the required fields (marked in red).",
                dialog=self.dlg_lot
            )
            return False

        feature_id = fields.get("lot_id")

        body = {
            "feature": {
                "tableName": "om_campaign_lot",
                "idName": "lot_id",
                "id": feature_id
            },
            "data": {
                "fields": fields
            }
        }

        result = tools_gw.execute_procedure("gw_fct_setlot", body, schema_name="cm")

        if result and result.get("status") == "Accepted":
            self.lot_id = result["body"]["feature"]["id"]
            self.is_new_lot = False
            # Only close dialog if this was a manual Accept, never for auto-save
            if not from_change_tab:
                self.dlg_lot.accept()
        else:
            tools_qgis.show_warning("Error saving lot.")

    def reset_rb_list(self, rb_list):
        """Resets the main rubber band and clears all rubber band selections in the provided list,
        effectively removing any current feature highlights from the canvas."""

        self.rb_red.reset()
        for rb in rb_list:
            rb.reset()

    def manage_rejected(self):
        """Handles the cancellation or rejection of changes by disconnecting selection signals,
        clearing any active feature selections, saving user settings, switching the tool to pan mode, and closing the current dialog."""

        tools_qgis.disconnect_signal_selection_changed()
        layer = self.iface.activeLayer()
        if layer:
            layer.removeSelection()
        tools_gw.save_settings(self.dlg_lot)
        self.iface.actionPan().trigger()
        tools_gw.close_dialog(self.dlg_lot)

    def lot_manager(self):
        """Entry point for opening the Lot Manager dialog (Button 75)."""

        self.dlg_lot_man = LotManagementUi(self)
        tools_gw.load_settings(self.dlg_lot_man)

        self.dlg_lot_man.tbl_lots.setEditTriggers(QTableView.NoEditTriggers)
        self.dlg_lot_man.tbl_lots.setSelectionBehavior(QTableView.SelectRows)

        # Fill combo values for lot date_filter_type combo
        date_types = [['real_startdate', 'Data inici'], ['real_enddate', 'Data fi'],
                      ['startdate', 'Data inici planificada'],
                      ['enddate', 'Data final planificada']]
        tools_qt.fill_combo_values(self.dlg_lot_man.cmb_date_filter_type, date_types, 1, sort_combo=False)

        # Fill combo values for lot status (based on sys_typevalue table)
        sql = "SELECT id, idval FROM cm.sys_typevalue WHERE typevalue = 'lot_status' ORDER BY id"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_lot_man.cmb_estat, rows, index_to_show=1, add_empty=True)

        self.load_lots_into_manager()
        self.init_filters()

        self.dlg_lot_man.date_event_from.dateChanged.connect(self.filter_lot)
        self.dlg_lot_man.date_event_to.dateChanged.connect(self.filter_lot)
        self.dlg_lot_man.cmb_date_filter_type.currentIndexChanged.connect(self.filter_lot)
        self.dlg_lot_man.chk_show_nulls.stateChanged.connect(self.filter_lot)
        self.dlg_lot_man.txt_lot_name.textChanged.connect(self.filter_lot)
        self.dlg_lot_man.cmb_estat.currentIndexChanged.connect(self.filter_lot)
        self.dlg_lot_man.btn_open.clicked.connect(self.open_lot)
        self.dlg_lot_man.tbl_lots.doubleClicked.connect(self.open_lot)
        self.dlg_lot_man.btn_delete.clicked.connect(self.delete_lot)

        tools_gw.open_dialog(self.dlg_lot_man, dlg_name="lot_management")

    def load_lots_into_manager(self):
        """Load campaign data into the campaign management table"""

        if not hasattr(self.dlg_lot_man, "tbl_lots"):
            return
        query = "SELECT * FROM cm.om_campaign_lot ORDER BY lot_id DESC"
        self.populate_manager_lot(self.dlg_lot_man.tbl_lots, query)

    def init_filters(self):
        current_date = QDate.currentDate()
        sql = 'SELECT MIN(startdate), MAX(startdate) FROM cm.om_campaign_lot'
        row = tools_db.get_rows(sql)

        if row and row[0]:
            self.dlg_lot_man.date_event_from.setDate(row[0][0] or current_date)
            self.dlg_lot_man.date_event_to.setDate(row[0][1] or current_date)
        else:
            self.dlg_lot_man.date_event_from.setDate(current_date)
            self.dlg_lot_man.date_event_to.setDate(current_date)

    def populate_manager_lot(self, view: QTableView, query: str, columns: list[str] = None):
        """Populate a QTableView with the results of a SQL query."""

        data = tools_db.get_rows(query)
        if not data:
            view.setModel(QStandardItemModel())  # Clear view
            return

        # Auto-detect column names if not provided
        if not columns:
            columns = list(data[0].keys())

        model = QStandardItemModel(len(data), len(columns))
        model.setHorizontalHeaderLabels(columns)

        for row_idx, row in enumerate(data):
            for col_idx, col_name in enumerate(columns):
                value = str(row.get(col_name, ''))
                model.setItem(row_idx, col_idx, QStandardItem(value))

        view.setModel(model)
        view.resizeColumnsToContents()

    def filter_lot(self):
        """Filter lot records based on date range and date type."""
        filters = []

        # get value to now column filter (startdate, enddate, real_startdate, real_enddate)
        date_type = tools_qt.get_combo_value(self.dlg_lot_man, self.dlg_lot_man.cmb_date_filter_type, 0)
        if not date_type:
            return

        # get dates
        date_from = self.dlg_lot_man.date_event_from.date()
        date_to = self.dlg_lot_man.date_event_to.date()

        # start date end date logic
        if date_from > date_to:
            self.dlg_lot_man.date_event_to.setDate(date_from)
            date_to = date_from

        interval = f"'{date_from.toString('yyyy-MM-dd')} 00:00:00' AND '{date_to.toString('yyyy-MM-dd')} 23:59:59'"
        date_filter = f"({date_type} BETWEEN {interval}"

        # show nulls if checked
        if hasattr(self.dlg_lot_man, "chk_show_nulls") and self.dlg_lot_man.chk_show_nulls.isChecked():
            date_filter += f" OR {date_type} IS NULL)"
        else:
            date_filter += ")"

        filters.append(date_filter)

        # filter by name logic
        name_value = self.dlg_lot_man.txt_lot_name.text().strip()
        if name_value:
            filters.append(f"name ILIKE '%{name_value}%'")

        # filter by status
        status_value = tools_qt.get_combo_value(self.dlg_lot_man, self.dlg_lot_man.cmb_estat, 0)
        if status_value:
            filters.append(f"status = '{status_value}'")

        # build and execute full query
        where_clause = " AND ".join(filters)
        query = "SELECT * FROM cm.om_campaign_lot"
        if where_clause:
            query += f" WHERE {where_clause}"
        query += " ORDER BY lot_id DESC"
        self.populate_manager_lot(self.dlg_lot_man.tbl_lots, query)

    def open_lot(self, index=None):
        """Open selected lot in edit mode, from button or double click."""

        if index and index.isValid():
            model = index.model()
            row = index.row()
            id_index = model.index(row, 0)
            lot_id = model.data(id_index)
        else:
            selected = self.dlg_lot_man.tbl_lots.selectionModel().selectedRows()
            if not selected:
                tools_qgis.show_warning("Please select a lot to open.", dialog=self.dlg_lot_man)
                return
            lot_id = selected[0].data()

        try:
            lot_id = int(lot_id)
            if lot_id > 0:
                self.manage_lot(lot_id=lot_id, is_new=False)
        except (ValueError, TypeError):
            tools_qgis.show_warning("Invalid lot ID.")

    def delete_lot(self):
        """Delete selected lot(s) with confirmation."""

        selected = self.dlg_lot_man.tbl_lots.selectionModel().selectedRows()
        if not selected:
            tools_qgis.show_warning("Select a lot to delete.", dialog=self.dlg_lot_man)
            return

        msg = f"Are you sure you want to delete {len(selected)} lot(s)?"
        if not tools_qt.show_question(msg, title="Delete Lot(s)"):
            return

        deleted = 0
        for index in selected:
            lot_id = index.data()
            if not str(lot_id).isdigit():
                continue

            sql = f"DELETE FROM cm.om_campaign_lot WHERE lot_id = {lot_id}"
            if tools_db.execute_sql(sql):
                deleted += 1

        tools_qgis.show_info(f"{deleted} lot(s) deleted.", dialog=self.dlg_lot_man)
        self.filter_lot()

    def _update_feature_completer_lot(self, dlg):
        # Identify the current tab
        tab_name = dlg.tab_feature.currentWidget().objectName()
        table_map = {
            'tab_arc': ('arc', 'arc_id'),
            'tab_node': ('node', 'node_id'),
            'tab_connec': ('connec', 'connec_id'),
            'tab_link': ('link', 'link_id'),
            'tab_gully': ('gully', 'gully_id'),
        }
        feature, id_column = table_map.get(tab_name, (None, None))
        if not feature:
            return

        # Get the allowed IDs for this lot and feature
        lot_id = self.lot_id_value  # or get the currently edited lot_id from the dialog
        allowed_ids = self.get_allowed_features_for_lot(lot_id, feature)  # Returns a list of IDs

        # Set up the completer
        feature_id_lineedit = dlg.findChild(QLineEdit, "feature_id")
        if feature_id_lineedit:
            completer = QCompleter([str(x) for x in allowed_ids])
            completer.setCaseSensitivity(False)
            feature_id_lineedit.setCompleter(completer)

    def _get_role_from_team_name(self, team_name: str) -> Optional[str]:
        """Determines the database role based on the team name."""
        if not team_name:
            return None

        team_name_lower = team_name.lower()

        if "admin" in team_name_lower:
            return "role_cm_admin"
        elif "manager" in team_name_lower:
            return "role_cm_manager"
        elif "field" in team_name_lower:
            return "role_cm_field"

        return None

    """ FUNCTIONS RELATED WITH TAB LOAD"""

    def get_current_user(self):
        """ Get all user information """

        # Get user name
        username = tools_db.get_current_user()

        # Get role_id and organizaton_id for the user
        sql = f"SELECT role_id, organization_id FROM cm.cat_team WHERE team_id = (SELECT team_id FROM cm.cat_user WHERE username = '{username}');"
        rows = tools_db.get_rows(sql)

        # Check rows
        if not rows or not rows[0]:
            return None

        row = rows[0]

        # Return a dict of user information
        return {"role": row[0], "org_id": row[1]}

    def resources_management(self):
        """Manages resources by coordinating the loading, display, and updates of resource-related information
        (such as teams and vehicles) within the application's UI."""

        # Get user information
        user_data = self.get_current_user()

        # Chek data
        if not user_data:
            return

        self.user_data = user_data

        # Create the dialog
        self.dlg_resources_man = ResourcesManagementUi(self)
        tools_gw.load_settings(self.dlg_resources_man)

        # Create tables dictionary
        self.dict_tables = {
            "cat_organization": {
                "query": "SELECT organization_id::text, code, orgname, descript, active::text FROM cm.cat_organization",
                "idname": "organization_id",
                "widget": tools_qt.get_widget(self.dlg_resources_man, "tbl_organizations")
            },
            "cat_team": {
                "query": "SELECT team_id::text, co.orgname, ct.code, teamname, ct.descript, ct.active::text, role_id" +
                         " FROM cm.cat_team ct INNER JOIN cm.cat_organization co ON co.organization_id = ct.organization_id",
                "idname": "team_id",
                "widget": tools_qt.get_widget(self.dlg_resources_man, "tbl_teams")
            },
            "cat_user": {
                "query": "SELECT user_id::text, teamname, cu.code, loginname, username, fullname, cu.descript, cu.active::text" +
                         " FROM cm.cat_user cu INNER JOIN cm.cat_team ct ON cu.team_id = ct.team_id",
                "idname": "user_id",
                "widget": tools_qt.get_widget(self.dlg_resources_man, "tbl_users"),
                "cmbParent": tools_qt.get_widget(self.dlg_resources_man, "cmb_team")
            }
        }

        # Init variables
        self.org_id = None
        self.team_id = None
        self.user_id = None
        self.tab_organizations = 0

        # Populate combos
        sql = "SELECT organization_id AS id, orgname AS idval FROM cm.cat_organization"
        rows = tools_db.get_rows(sql)

        # Chek rows
        if rows:
            tools_qt.fill_combo_values(self.dlg_resources_man.cmb_orga, rows, 1, add_empty=True)

        # Create sql query to get all teams
        sql = "SELECT team_id AS id, teamname AS idval FROM cm.cat_team"

        # Check if user is superadmin
        if self.user_data["role"] == "role_cm_admin":

            # Create list of tables
            tables = ["cat_organization", "cat_team", "cat_user"]

            # Fill tables
            for table in tables:
                self.populate_tableview(table)

            # Set signals for manage organizations
            self.dlg_resources_man.btn_organi_create.clicked.connect(partial(self.open_create_organization))
            self.dlg_resources_man.btn_organi_update.clicked.connect(partial(self.open_create_organization, True))
            self.dlg_resources_man.btn_organi_delete.clicked.connect(partial(self.delete_registers, "cat_organization"))
            self.dlg_resources_man.txt_orgname.textChanged.connect(partial(self.txt_org_name_changed))
            self.dlg_resources_man.cmb_orga.currentIndexChanged.connect(partial(self.filter_teams_table))
            self.dict_tables["cat_organization"]["widget"].doubleClicked.connect(
                partial(self.selected_row, "cat_organization"))
        else:

            # Remove tab organizations
            self.dlg_resources_man.tab_main.removeTab(self.tab_organizations)

            # Set combo value to the user organization
            tools_qt.set_combo_value(self.dlg_resources_man.cmb_orga, self.user_data['org_id'], 0, False)

            # Filter teams table by the user organization selected
            self.filter_teams_table()

            # Set disabled combo
            self.dlg_resources_man.cmb_orga.setEnabled(False)

            # Filter teams combo
            sql += f" WHERE organization_id = {self.user_data['org_id']}"

            # Create sql filter and populate table
            sql_filter = f"WHERE ct.team_id = any(SELECT team_id FROM cm.cat_team WHERE organization_id = {self.user_data['org_id']})"
            self.populate_tableview("cat_user", sql_filter)

        # Fill teams combo
        rows = tools_db.get_rows(sql)
        if rows:
            tools_qt.fill_combo_values(self.dlg_resources_man.cmb_team, rows, 1, add_empty=True)

        # Set signals for tables
        self.dict_tables["cat_team"]["widget"].doubleClicked.connect(partial(self.selected_row, "cat_team"))
        self.dict_tables["cat_user"]["widget"].doubleClicked.connect(partial(self.selected_row, "cat_user"))

        # Set signals for manage teams
        self.dlg_resources_man.btn_team_create.clicked.connect(partial(self.open_create_team))
        self.dlg_resources_man.btn_team_update.clicked.connect(partial(self.open_create_team, True))
        self.dlg_resources_man.btn_team_delete.clicked.connect(partial(self.delete_registers, "cat_team"))

        # Set signals for manage users
        self.dlg_resources_man.btn_user_create.clicked.connect(partial(self.open_create_user))
        self.dlg_resources_man.btn_user_update.clicked.connect(partial(self.open_create_user, True))
        self.dlg_resources_man.btn_user_delete.clicked.connect(partial(self.delete_registers, "cat_user"))
        self.dlg_resources_man.cmb_team.currentIndexChanged.connect(partial(self.filter_users_table))

        # self.dlg_resources_man.cmb_team.currentIndexChanged.connect(self.populate_team_views)
        # self.dlg_resources_man.cmb_vehicle.currentIndexChanged.connect(self.populate_vehicle_views)

        # self.dlg_resources_man.btn_team_create.clicked.connect(partial(self.create_team))
        # self.dlg_resources_man.btn_team_update.clicked.connect(partial(self.manage_team))
        # self.dlg_resources_man.btn_team_selector.clicked.connect(partial(self.open_team_selector))
        # self.dlg_resources_man.btn_team_delete.clicked.connect(partial(self.delete_team))

        # #self.dlg_resources_man.btn_vehicle_create.clicked.connect(partial(self.create_vehicle))
        # self.dlg_resources_man.btn_vehicle_update.clicked.connect(partial(self.manage_vehicle))
        # self.dlg_resources_man.btn_vehicle_delete.clicked.connect(partial(self.delete_vehicle))

        self.dlg_resources_man.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_resources_man))
        # self.dlg_resources_man.rejected.connect(partial(tools_gw.save_settings, self.dlg_resources_man))

        # Open form
        tools_gw.open_dialog(self.dlg_resources_man, "resources_management")

    def txt_org_name_changed(self):
        """ Filter table by organization id """

        org_name = tools_qt.get_text(self.dlg_resources_man, "txt_orgname")
        sql_filter = f"WHERE orgname ILIKE '%{org_name}%'" if org_name != 'null' else None
        self.populate_tableview("cat_organization", sql_filter)

    def filter_teams_table(self):
        """ Filter table by organization id """

        org_id = tools_qt.get_combo_value(self.dlg_resources_man, "cmb_orga")
        sql_filter = f"WHERE co.organization_id = {org_id}" if org_id != '' else None
        self.populate_tableview("cat_team", sql_filter)

    def filter_users_table(self):
        """ Filter table by user name """

        # Get selected team id from combo
        team_id = tools_qt.get_combo_value(self.dlg_resources_man, "cmb_team")

        # Build sql filtering by the selected team
        sql_filter = f"WHERE ct.team_id = {team_id}" if team_id != '' else None

        # Check if user select all teams in combo and the role is not admin
        if not sql_filter and self.user_data["role"] != "role_cm_admin":
            # Build sql filtering by the user organization
            sql_filter = f"WHERE ct.organization_id = {self.user_data['org_id']}"

        # Refresh table
        self.populate_tableview("cat_user", sql_filter)

    def populate_tableview(self, table_name: str, sql_filter: Optional[str] = None):
        """Populate a QTableView with the results of a SQL query."""

        # Get QTableView
        table = self.dict_tables[table_name]["widget"]

        # Get query to populate
        query = self.dict_tables[table_name]["query"]

        # Check sql filter
        if sql_filter:
            query += f" {sql_filter}"
        elif 'cmbParent' in self.dict_tables[table_name]:
            # Reset combo parent
            cmb_parent = self.dict_tables[table_name]["cmbParent"]
            tools_qt.set_combo_value(cmb_parent, '', 1)

        # Get data from query
        data = tools_db.get_rows(f"{query} ORDER BY {self.dict_tables[table_name]['idname']}:: INTEGER")

        # Check data
        if not data:
            table.setModel(QStandardItemModel())  # Clear view
            return

        # Get column headers
        columns = list(data[0].keys())

        # Create model for table
        model = QStandardItemModel(len(data), len(columns))
        model.setHorizontalHeaderLabels(columns)

        # Set table parameters
        table.setSelectionBehavior(QAbstractItemView.SelectRows)
        table.setEditTriggers(QAbstractItemView.NoEditTriggers)
        table.setSortingEnabled(True)

        # Populate table view
        for row_idx, row in enumerate(data):
            for col_idx, col_name in enumerate(columns):
                if col_name in row:
                    value = row[col_name]
                    model.setItem(row_idx, col_idx, QStandardItem(value))

        # Apply model to table
        table.setModel(model)

    def selected_row(self, table_name: str):
        """ Handle double click selected row """

        # Call open_create function depending of the table name
        if table_name == "cat_organization":
            self.open_create_organization(True)
        elif table_name == "cat_team":
            self.open_create_team(True)
        else:
            self.open_create_user(True)

    def delete_registers(self, tablename):
        """ Delete selected registers from the table."""

        # Get idname
        idname = self.dict_tables[tablename]["idname"]

        # Get values to delete
        values = self.get_selected_ids(tablename)
        if not values:
            return

        # Build ids
        ids = ",".join(str(v) for v in values)

        # If deleting users, get their login names first to also drop the DB user
        login_names_to_drop = []
        if tablename == "cat_user":
            login_names_rows = tools_db.get_rows(f"SELECT loginname FROM cm.cat_user WHERE {idname} IN ({ids})")
            if login_names_rows:
                login_names_to_drop = [row[0] for row in login_names_rows if row and row[0]]

        # Create message for the question
        msg = f"Are you sure you want to delete these records: ({ids})?."
        if tablename == "cat_user" and login_names_to_drop:
            msg += f"\\nThis will also delete the database user(s): {', '.join(login_names_to_drop)}"

        answer = tools_qt.show_question(msg, "Delete records")

        # Check answer
        if answer:
            # Delete records from the application table first
            if tools_db.execute_sql(f"DELETE FROM cm.{tablename} WHERE {idname} IN ({str(ids)})"):
                # If it was a user, also drop the database user
                if tablename == "cat_user":
                    for login_name in login_names_to_drop:
                        if not tools_db.execute_sql(f'DROP USER IF EXISTS "{login_name}"', commit=True):
                            tools_qgis.show_warning(f"Failed to drop database user '{login_name}'. It may need to be removed manually.")
            else:
                tools_qgis.show_warning(f"Failed to delete records from {tablename}.")

            # Chek user role
            if self.user_data["role"] == "role_cm_admin":
                # Reload table without filtering
                self.populate_tableview(tablename)
            else:
                if tablename == "cat_team":
                    self.filter_teams_table()
                elif tablename == "cat_user":
                    # Create sql filter and populate table
                    sql_filter = f"WHERE ct.team_id = any(SELECT team_id FROM cm.cat_team WHERE organization_id = {self.user_data['org_id']})"
                    self.populate_tableview(tablename, sql_filter)

    def open_create_organization(self, is_update: Optional[bool] = False):
        """ Open create organization dialog """

        user = tools_db.current_user
        form = {"formName": "generic", "formType": "create_organization"}
        body = {"client": {"cur_user": user}, "form": form}

        # DB fct
        json_result = tools_gw.execute_procedure('gw_fct_getdialogcm', body, schema_name="cm")

        # Create and open dialog
        self.dlg_create_organization = OrganizationCreateUi(self)
        tools_gw.load_settings(self.dlg_create_organization)
        tools_gw.manage_dlg_widgets(self, self.dlg_create_organization, json_result)

        if is_update:
            # Get selected id from table

            selected_ids = self.get_selected_ids("cat_organization")
            if not selected_ids:
                return

            self.org_id = selected_ids[0]  # Get first selected id

            # Get object_id from selected row
            sql = f"SELECT orgname, descript, code, active FROM cm.cat_organization WHERE organization_id = '{self.org_id}'"

            rows = tools_db.get_rows(sql)
            if rows:
                row = rows[0]
                tools_qt.set_widget_text(self.dlg_create_organization, "tab_none_name", row[0])
                tools_qt.set_widget_text(self.dlg_create_organization, "tab_none_descript", row[1])
                if len(row) > 2:
                    tools_qt.set_widget_text(self.dlg_create_organization, "tab_none_code", row[2])
                    tools_qt.set_checked(self.dlg_create_organization, "tab_none_active", row[3])

        tools_gw.open_dialog(self.dlg_create_organization, "organization_create")

    def open_create_team(self, is_update: Optional[bool] = False):
        """ Open create team dialog """

        user = tools_db.current_user
        form = {"formName": "generic", "formType": "create_team"}
        body = {"client": {"cur_user": user}, "form": form}

        # DB fct
        json_result = tools_gw.execute_procedure('gw_fct_getdialogcm', body, schema_name="cm")

        # Create and open dialog
        self.dlg_create_team = TeamCreateUi(self)
        tools_gw.load_settings(self.dlg_create_team)
        tools_gw.manage_dlg_widgets(self, self.dlg_create_team, json_result)

        # Get organization widget combo
        cmb_org = self.dlg_create_team.findChild(QWidget, "tab_none_org_id")

        # Chek user role
        if self.user_data["role"] != "admin":
            # Set combo value to the user organization
            tools_qt.set_combo_value(cmb_org, self.user_data['org_id'], 0, False)

            # Disable combo
            cmb_org.setEnabled(False)

        if is_update:
            # Get selected id from table

            selected_ids = self.get_selected_ids("cat_team")
            if not selected_ids:
                return

            self.team_id = selected_ids[0]  # Get first selected id

            # Get object_id from selected row
            sql = f"SELECT teamname, descript, active, code, organization_id FROM cm.cat_team WHERE team_id = '{self.team_id}'"

            rows = tools_db.get_rows(sql)
            if rows:
                row = rows[0]
                tools_qt.set_widget_text(self.dlg_create_team, "tab_none_name", row[0])
                tools_qt.set_widget_text(self.dlg_create_team, "tab_none_descript", row[1])
                if len(row) > 2:
                    tools_qt.set_checked(self.dlg_create_team, "tab_none_active", row[2])
                    tools_qt.set_widget_text(self.dlg_create_team, "tab_none_code", row[3])
                    tools_qt.set_combo_value(cmb_org, row[4], 0, False)

        tools_gw.open_dialog(self.dlg_create_team, "create_team")

    def open_create_user(self, is_update: Optional[bool] = False):
        """ Open create team dialog """

        user = tools_db.current_user
        form = {"formName": "generic", "formType": "create_user"}
        body = {"client": {"cur_user": user}, "form": form}

        # DB fct
        json_result = tools_gw.execute_procedure('gw_fct_getdialogcm', body, schema_name="cm")

        # Create and open dialog
        self.dlg_create_team = UserCreateUi(self)
        tools_gw.load_settings(self.dlg_create_team)
        tools_gw.manage_dlg_widgets(self, self.dlg_create_team, json_result)

        # Get team widget combo
        cmb_team = self.dlg_create_team.findChild(QWidget, "tab_none_team_id")

        if self.user_data["role"] != "admin":
            # Refresh values for team widget combo
            sql = f"SELECT team_id AS id, teamname AS idval FROM cm.cat_team WHERE organization_id = {self.user_data['org_id']}"
            rows = tools_db.get_rows(sql)
            tools_qt.fill_combo_values(cmb_team, rows)

        if is_update:
            # Get selected id from table

            selected_ids = self.get_selected_ids("cat_user")
            if not selected_ids:
                return

            self.user_id = selected_ids[0]  # Get first selected id

            # Get object_id from selected row
            sql = f"SELECT loginname, descript, active, code, username, fullname, team_id FROM cm.cat_user WHERE user_id = '{self.user_id}'"

            rows = tools_db.get_rows(sql)
            if rows:
                row = rows[0]
                tools_qt.set_widget_text(self.dlg_create_team, "tab_none_loginname", row[0])
                tools_qt.set_widget_text(self.dlg_create_team, "tab_none_descript", row[1])
                if len(row) > 2:
                    tools_qt.set_checked(self.dlg_create_team, "tab_none_active", row[2])
                    tools_qt.set_widget_text(self.dlg_create_team, "tab_none_code", row[3])
                    tools_qt.set_widget_text(self.dlg_create_team, "tab_none_username", row[4])
                    tools_qt.set_widget_text(self.dlg_create_team, "tab_none_fullname", row[5])
                    tools_qt.set_combo_value(cmb_team, row[6], 0, False)

        tools_gw.open_dialog(self.dlg_create_team, "create_user")

    def get_selected_ids(self, tablename) -> List:
        """Get selected ids from QTableView."""

        qtable = self.dict_tables[tablename]["widget"]

        model = qtable.model()
        selection_model = qtable.selectionModel()
        selected_rows = selection_model.selectedRows()

        values = []
        for index in selected_rows:
            row = index.row()
            item = model.item(row, 0)  # Get the first column value (id)
            if item:
                values.append(item.text())

        if not values:
            message = "No records selected"
            tools_qgis.show_warning(message)

        return values


def upsert_organization(**kwargs):
    """ Create organization """

    dlg = kwargs["dialog"]
    this = kwargs["class"]
    org_id = this.org_id

    # Get input values
    name = tools_qt.get_text(dlg, "tab_none_name")
    descript = tools_qt.get_text(dlg, "tab_none_descript")
    code = tools_qt.get_text(dlg, "tab_none_code")
    active = tools_qt.get_widget_value(dlg, "tab_none_active")

    # Validate input values
    if name == "null" or descript == "null" or code == "null":
        message = "Name, description and code are required fields"
        tools_qt.show_info_box(message, "Info")
        return

    # Validate if name already exists
    sql_name_exists = f"SELECT * FROM cm.cat_organization WHERE orgname = '{str(name)}'"

    if not org_id:
        sql = f"INSERT INTO cm.cat_organization (orgname, descript, code, active) VALUES ('{name}', '{descript}', '{code}', {active})"
    else:
        sql_name_exists += f" AND organization_id != {org_id}"
        sql = f"UPDATE cm.cat_organization SET orgname = '{name}', descript = '{descript}', code = '{code}', active = {active} WHERE organization_id = {org_id}"
        this.org_id = None

    rows = tools_db.get_rows(sql_name_exists, commit=True)
    if rows:
        message = "The organization name already exists"
        tools_qt.show_info_box(message, "Info", parameter=str(name))
        return

    # Execute SQL
    status = tools_db.execute_sql(sql, commit=True)

    if not status:
        message = "Error creating or updating organization"
        tools_qgis.show_warning(message, parameter=str(name))
        return

    # Close dialog
    tools_gw.close_dialog(dlg)

    # Reload table
    this.populate_tableview("cat_organization")


def upsert_team(**kwargs):
    """ Create organization """

    dlg = kwargs["dialog"]
    this = kwargs["class"]
    team_id = this.team_id

    # Get input values
    name = tools_qt.get_text(dlg, "tab_none_name")
    descript = tools_qt.get_text(dlg, "tab_none_descript")
    code = tools_qt.get_text(dlg, "tab_none_code")
    active = tools_qt.get_widget_value(dlg, "tab_none_active")
    org_id = tools_qt.get_combo_value(dlg, "tab_none_org_id")
    role_id = tools_qt.get_combo_value(dlg, "tab_none_role_id")

    # Validate input values
    if name == "null" or descript == "null" or org_id == '' or code == 'null':
        message = "Missing required fields"
        tools_qt.show_info_box(message, "Info")
        return

    # Validate if name already exists
    sql_name_exists = f"SELECT * FROM cm.cat_team WHERE teamname = '{str(name)}'"

    if not team_id:
        sql = f"INSERT INTO cm.cat_team (teamname, descript, active, organization_id, code, role_id) \
                VALUES ('{name}', '{descript}', {active}, '{org_id}', '{code}', '{role_id}')"
    else:
        sql_name_exists += f" AND team_id != {team_id}"
        sql = f"UPDATE cm.cat_team SET teamname = '{name}', descript = '{descript}', active = {active}, \
                code = '{code}', role_id = '{role_id}', organization_id = '{org_id}' WHERE team_id = {team_id}"
        this.team_id = None

    rows = tools_db.get_rows(sql_name_exists, commit=True)
    if rows:
        message = "The team name already exists"
        tools_qt.show_info_box(message, "Info", parameter=str(name))
        return

    # Execute SQL
    status = tools_db.execute_sql(sql, commit=True)

    if not status:
        message = "Error creating or updating team"
        tools_qgis.show_warning(message, parameter=str(name))
        return

    # Close dialog
    tools_gw.close_dialog(dlg)

    # Chek user role
    if this.user_data["role"] == "role_cm_admin":
        # Reload table without filtering
        this.populate_tableview("cat_team")
    else:
        # Filter teams table by the user organization selected
        this.filter_teams_table()


def upsert_user(**kwargs):
    """ Create or update a user and its corresponding database role. """

    dlg = kwargs["dialog"]
    this = kwargs["class"]
    user_id = this.user_id

    # Get input values
    login_name = tools_qt.get_text(dlg, "tab_none_loginname")
    user_name = tools_qt.get_text(dlg, "tab_none_username")
    full_name = tools_qt.get_text(dlg, "tab_none_fullname")
    code = tools_qt.get_text(dlg, "tab_none_code")
    descript = tools_qt.get_text(dlg, "tab_none_descript")
    team_id = tools_qt.get_combo_value(dlg, "tab_none_team_id")
    active = tools_qt.get_widget_value(dlg, "tab_none_active")
    password = tools_qt.get_text(dlg, "tab_none_password")

    # Validate input values
    if any(value in (None, "", "null") for value in [login_name, user_name, full_name, code, descript, team_id]):
        tools_qt.show_info_box("Missing required fields", "Info")
        return

    # Get team name and the corresponding role for the new/updated team
    team_name_row = tools_db.get_row(f"SELECT teamname FROM cm.cat_team WHERE team_id = {team_id}")
    if not team_name_row:
        tools_qgis.show_warning("Selected team not found.")
        return
    new_team_name = team_name_row[0]
    new_role_name = this._get_role_from_team_name(new_team_name)

    if not new_role_name:
        tools_qgis.show_warning(f"Could not determine a valid role for team '{new_team_name}'.")
        return

    # Validate if user name already exists
    sql_name_exists = f"SELECT * FROM cm.cat_user WHERE username = '{str(user_name)}'"

    if not user_id:  # This is a new user
        # Create the database user
        create_sql = f'CREATE USER "{login_name}" WITH LOGIN'
        if password and password not in ('', 'null'):
            create_sql += f" PASSWORD '{password}'"
        
        if not tools_db.execute_sql(f"{create_sql};", commit=True):
            tools_qgis.show_warning(
                f"Failed to create database user '{login_name}'. The user might already exist in the database.")
            return

        # Grant the group role to the new user
        grant_sql = f'GRANT "{new_role_name}", "role_basic" TO "{login_name}";'
        if not tools_db.execute_sql(grant_sql, commit=True):
            tools_qgis.show_warning(f"User '{login_name}' was created, but failed to grant roles ('{new_role_name}', 'role_basic').")
            # Continue to insert into cat_user anyway

        # Prepare SQL to insert user data into the application table
        sql = f"INSERT INTO cm.cat_user (username, descript, active, team_id, code, loginname, fullname) \
                VALUES ('{user_name}', '{descript}', {active}, '{team_id}', '{code}', '{login_name}', '{full_name}')"

    else:  # This is an existing user
        sql_name_exists += f" AND user_id != {user_id}"

        # Get original user data to check for changes in login name or team
        user_data_row = tools_db.get_row(f"SELECT loginname, team_id FROM cm.cat_user WHERE user_id = {user_id}")
        original_login_name = user_data_row[0] if user_data_row else None
        old_team_id = user_data_row[1] if user_data_row else None
        
        if not original_login_name:
            tools_qgis.show_warning("Could not find the original user to update.")
            return

        # If the login name was changed, rename the database user first
        if original_login_name != login_name:
            rename_sql = f'ALTER USER "{original_login_name}" RENAME TO "{login_name}";'
            if not tools_db.execute_sql(rename_sql, commit=True):
                tools_qgis.show_warning(f"Failed to rename user from '{original_login_name}' to '{login_name}'. The new name might already be in use in the database.")
                return

        # If the user's team has changed, update their database role accordingly
        if old_team_id and old_team_id != int(team_id):
            old_team_name_row = tools_db.get_row(f"SELECT teamname FROM cm.cat_team WHERE team_id = {old_team_id}")
            if old_team_name_row:
                old_role_name = this._get_role_from_team_name(old_team_name_row[0])
                if old_role_name and old_role_name != new_role_name:
                    revoke_sql = f'REVOKE "{old_role_name}" FROM "{login_name}";'
                    grant_sql = f'GRANT "{new_role_name}" TO "{login_name}";'
                    tools_db.execute_sql(revoke_sql, commit=True)
                    tools_db.execute_sql(grant_sql, commit=True)

        # If a new password was provided, update it in the database
        if password and password not in ('', 'null'):
            pw_change_sql = f'ALTER USER "{login_name}" WITH PASSWORD \'{password}\';'
            if not tools_db.execute_sql(pw_change_sql, commit=True):
                tools_qgis.show_warning(f"Failed to update password for user '{login_name}'.")

        # Grant basic role to make sure user has it
        tools_db.execute_sql(f'GRANT "role_basic" TO "{login_name}"', commit=True)

        # Prepare SQL to update the user data in the application table
        sql = f"UPDATE cm.cat_user SET username = '{user_name}', fullname = '{full_name}', descript = '{descript}', active = {active}, \
                code = '{code}', loginname = '{login_name}', team_id = '{team_id}' WHERE user_id = {user_id}"
        this.user_id = None

    rows = tools_db.get_rows(sql_name_exists, commit=True)
    if rows:
        tools_qt.show_info_box("The user name already exists", "Info", parameter=str(user_name))
        return

    # Save the user data to the application's user table
    status = tools_db.execute_sql(sql, commit=True)

    if not status:
        tools_qgis.show_warning("Error creating or updating user in cat_user table.", parameter=str(user_name))
        return

    # Close the dialog and refresh the user list
    tools_gw.close_dialog(dlg)
    if this.user_data["role"] == "role_cm_admin":
        this.populate_tableview("cat_user")


def close(**kwargs):
    """ Close dialog """
    tools_gw.close_dialog(kwargs["dialog"])
