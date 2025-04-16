"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from qgis.PyQt.QtGui import QStandardItemModel, QStandardItem
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtCore import QDate, QTimer
from qgis.PyQt.QtWidgets import QLineEdit, QDateEdit, QCheckBox, QComboBox, QWidget, QLabel, QGridLayout, QSpacerItem, \
    QSizePolicy, QTextEdit, QMenu, QAction, QCompleter, QToolButton, QTableView
from .... import global_vars
from ....libs import tools_qt, tools_db, tools_qgis, lib_vars
from ...utils import tools_gw
from ...utils.selection_mode import GwSelectionMode
from ...ui.ui_manager import AddCampaignReviewUi, AddCampaignVisitUi, CampaignManagementUi
from qgis.gui import QgsDateTimeEdit


class Campaign:
    """Handles campaign creation, management, and database operations"""

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        self.iface = global_vars.iface
        self.campaign_date_format = 'yyyy-MM-dd'
        self.schema_name = lib_vars.schema_name
        self.project_type = tools_gw.get_project_type()
        self.dialog = None
        self.campaign_type = None
        self.campaign_id = None
        self.canvas = global_vars.canvas
        self.campaign_saved = False
        self.is_new_campaign = True

    def create_campaign(self, campaign_id=None, is_new=True, dialog_type="review"):
        """ Entry point for campaign creation or editing """
        self.load_campaign_dialog(campaign_id=campaign_id, mode=dialog_type)


    def campaign_manager(self):
        """ Opens the campaign management interface """
        self.dialog = CampaignManagementUi(self)
        tools_gw.load_settings(self.dialog)
        self.load_campaigns_into_manager()

        self.dialog.tbl_campaign.setEditTriggers(QTableView.NoEditTriggers)
        self.dialog.tbl_campaign.setSelectionBehavior(QTableView.SelectRows)

        # Populate combo date type
        rows = [['real_startdate', 'Data inici'], ['real_enddate', 'Data fi'], ['startdate', 'Data inici planificada'],
                ['enddate', 'Data final planificada']]
        tools_qt.fill_combo_values(self.dialog.campaign_cmb_date_filter_type, rows, 1, sort_combo=False)

        # Fill combo values for campaign status (based on edit_typevalue table)
        sql = "SELECT id, idval FROM lots3_ws.edit_typevalue WHERE typevalue = 'cm_campaing_lot_status' ORDER BY id"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dialog.campaign_cmb_state, rows, index_to_show=1, add_empty=True)


        # Set filter events
        self.dialog.campaign_cmb_state.currentIndexChanged.connect(self.filter_campaigns)
        self.dialog.campaign_cmb_state.currentIndexChanged.connect(self.filter_campaigns)
        self.dialog.date_event_from.dateChanged.connect(self.filter_campaigns)
        self.dialog.date_event_to.dateChanged.connect(self.filter_campaigns)
        self.dialog.campaign_cmb_date_filter_type.currentIndexChanged.connect(self.filter_campaigns)
        self.dialog.campaign_cmb_date_filter_type.currentIndexChanged.connect(self.manage_date_filter)
        #self.dialog.tbl_campaign.doubleClicked.connect(self.open_selected_campaign)
        self.dialog.tbl_campaign.doubleClicked.connect(self.open_campaign)
        self.dialog.campaign_btn_delete.clicked.connect(self.delete_selected_campaign)
        self.dialog.campaign_btn_create.clicked.connect(self.open_selected_campaign)

        self.manage_date_filter()
        tools_gw.open_dialog(self.dialog, dlg_name="campaign_manager")


    def load_campaign_dialog(self, campaign_id=None, mode="review"):
        """
        Load and initialize the campaign dialog.

        - Creates and sets up the form dynamically based on response from `gw_fct_getcampaign`.
        - Initializes rubberbands and layer lists.
        - Loads campaign relations if editing an existing campaign.
        - Sets icons, connections, tab visibility (e.g. hides gully tab for 'ws' projects), and widget behaviors.
        - Applies reviewclass logic and sets up snapping/highlight connections for relation tabs.

        :param campaign_id: ID of the campaign to load. If None, creates a new campaign.
        :param mode: Type of campaign dialog to load. Options: 'review', 'visit'.
        """

        # In the edit_typevalue or another cm.edit_typevalue
        # INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('cm_campaing_type', '1', 'Review', NULL, NULL);
        # INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('cm_campaing_type', '2', 'Visit', NULL, NULL);
        # same with status and status in x_feature

        # Setting lists
        self.rubber_band = tools_gw.create_rubberband(self.canvas)
        self.ids = []
        self.list_ids = {'arc': [], 'node': [], 'connec': [], 'gully': [], 'link': []}
        self.layers = {'arc': [], 'node': [], 'connec': [], 'gully': [], 'link': []}
        self.layers['arc'] = tools_gw.get_layers_from_feature_type('arc')
        self.layers['node'] = tools_gw.get_layers_from_feature_type('node')
        self.layers['connec'] = tools_gw.get_layers_from_feature_type('connec')
        if self.project_type == 'ud':
            self.layers['gully'] = tools_gw.get_layers_from_feature_type('gully')
        self.layers['link'] = tools_gw.get_layers_from_feature_type('link')


        self.excluded_layers = [
            "v_edit_arc", "v_edit_node", "v_edit_connec",
            "v_edit_gully", "v_edit_link"
        ]

        modes = {"review": 1, "visit": 2}
        self.campaign_type = modes.get(mode, 1)

        body = {
            "feature": {
                "tableName": "om_campaign",
                "idName": "id",
                "campaign_mode": mode
            }
        }
        if campaign_id:
            body["feature"]["id"] = campaign_id
        p_data = tools_gw.create_body(body=body)
        self.is_new_campaign = campaign_id is None
        self.campaign_saved = False

        response = tools_gw.execute_procedure("gw_fct_getcampaign", p_data, schema_name="cm")
        if not response or response.get("status") != "Accepted":
            tools_qgis.show_warning("Failed to load campaign form.")
            return

        form_fields = response["body"]["data"].get("fields", [])
        self.dialog = AddCampaignReviewUi(self) if mode == "review" else AddCampaignVisitUi(self)

        tools_gw.load_settings(self.dialog)

        # Hide gully tab if project_type is 'ws'
        if self.project_type == 'ws':
            index = self.dialog.tab_feature.indexOf(self.dialog.tab_gully)
            if index != -1:
                self.dialog.tab_feature.removeTab(index)

        # Build widgets dynamically
        for field in form_fields:
            widget = self.create_widget_from_field(field)
            if not widget:
                continue

            if "value" in field:
                self.set_widget_value(widget, field["value"])
            if "columnname" in field:
                widget.setProperty("columnname", field["columnname"])


            label = QLabel(field["label"]) if field.get("label") else None
            tools_gw.add_widget(self.dialog, field, label, widget)

        if campaign_id:
            self._load_campaign_relations(campaign_id)

        tools_gw.add_icon(self.dialog.btn_insert, '111')
        tools_gw.add_icon(self.dialog.btn_delete, '112')
        tools_gw.add_icon(self.dialog.btn_snapping, '137')

        self.dialog.rejected.connect(lambda: tools_gw.reset_rubberband(self.rubber_band))
        self.dialog.rejected.connect(lambda: tools_gw.remove_selection(True, layers=self.layers))

        self.dialog.btn_cancel.clicked.connect(self.dialog.reject)
        self.dialog.btn_accept.clicked.connect(self.save_campaign)
        self.dialog.tab_widget.currentChanged.connect(self._on_tab_change)
        self.setup_tab_relations()
        self._update_feature_completer(self.dialog)

        self.reviewclass_combo = self.get_widget_by_columnname(self.dialog, "reviewclass_id")
        if isinstance(self.reviewclass_combo, QComboBox):
            self.reviewclass_combo.currentIndexChanged.connect(self._on_reviewclass_changed)

        self.dialog.tbl_campaign_x_arc.clicked.connect(partial(tools_qgis.highlight_feature_by_id,
                                                               self.dialog.tbl_campaign_x_arc, "v_edit_arc", "arc_id", self.rubber_band, 5))
        self.dialog.tbl_campaign_x_node.clicked.connect(partial(tools_qgis.highlight_feature_by_id,
                                                                self.dialog.tbl_campaign_x_node, "v_edit_node", "node_id", self.rubber_band, 10))
        self.dialog.tbl_campaign_x_connec.clicked.connect(partial(tools_qgis.highlight_feature_by_id,
                                                                  self.dialog.tbl_campaign_x_connec, "v_edit_connec", "connec_id", self.rubber_band, 10))
        self.dialog.tbl_campaign_x_gully.clicked.connect(partial(tools_qgis.highlight_feature_by_id,
                                                                 self.dialog.tbl_campaign_x_gully, "v_edit_gully", "gully_id", self.rubber_band, 10))
        self.dialog.tbl_campaign_x_link.clicked.connect(partial(tools_qgis.highlight_feature_by_id,
                                                                 self.dialog.tbl_campaign_x_link, "v_edit_link", "link_id", self.rubber_band, 10))

        tools_gw.open_dialog(self.dialog, dlg_name="add_campaign")


    def _load_campaign_relations(self, campaign_id):
        """
        Load related elements into campaign relation tabs for the given ID.
        Includes 'gully' only if project type is UD.
        """

        relation_tabs = {
            "tbl_campaign_x_arc": ("om_campaign_x_arc", "arc_id"),
            "tbl_campaign_x_node": ("om_campaign_x_node", "node_id"),
            "tbl_campaign_x_connec": ("om_campaign_x_connec", "connec_id"),
            "tbl_campaign_x_link": ("om_campaign_x_link", "link_id")

        }

        # Only include gully and link if project type is 'ud'
        if self.project_type == 'ud':
            relation_tabs.update({
                "tbl_campaign_x_gully": ("om_campaign_x_gully", "gully_id"),
            })

        for table_name, (db_table, col_id) in relation_tabs.items():
            view = getattr(self.dialog, table_name, None)
            if view:
                sql = f"SELECT * FROM cm.{db_table} WHERE campaign_id = {campaign_id}"
                self.populate_tableview(view, sql)

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

        return widget


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
            index = widget.findData(value)
            if index >= 0:
                widget.setCurrentIndex(index)


    def _on_tab_change(self, index):
        # Get the tab object at the changed index
        tab = self.dialog.tab_widget.widget(index)
        if tab.objectName() == "tab_relations" and self.is_new_campaign and not self.campaign_saved:
            self.save_campaign(from_tab_change=True)


    def save_campaign(self, from_tab_change=False):
        """Save campaign data to the database. Updates ID and resets map on success."""

        try:
            fields_str = self.extract_campaign_fields(self.dialog)
            extras = f'"fields":{{{fields_str}}}, "campaign_type":{self.campaign_type}'
            body = tools_gw.create_body(feature='"tableName":"om_campaign", "idName":"id"', extras=extras)

            result = tools_gw.execute_procedure("gw_fct_setcampaign", body, schema_name="cm")

            if result.get("status") == "Accepted":
                tools_qgis.show_info("Campaign saved successfully.", dialog=self.dialog)
                self.campaign_saved = True
                self.is_new_campaign = False
                tools_gw.remove_selection(True, layers=self.layers)
                tools_gw.reset_rubberband(self.rubber_band)

                # Update campaign ID in the dialog
                campaign_id = result.get("body", {}).get("campaign_id")
                self.campaign_id = campaign_id
                if campaign_id:
                    id_field = self.dialog.findChild(QLineEdit, "id")
                    if id_field:
                        id_field.setText(str(campaign_id))

                if not from_tab_change:
                    self.dialog.accept()

            else:
                tools_qgis.show_warning(result.get("message", "Failed to save campaign."))

        except Exception as e:
            tools_qgis.show_warning(f"Error saving campaign: {e}")


    def extract_campaign_fields(self, dialog):
        """Build a JSON string of field values from the campaign dialog"""
        fields = ''
        for widget in dialog.findChildren(QLineEdit):
            colname = widget.property('columnname')
            if not colname:
                continue
            value = tools_qt.get_text(dialog, widget)
            if value != 'null':
                fields += f'"{colname}":"{value}", '

        for widget in dialog.findChildren(QTextEdit):
            colname = widget.property('columnname')
            if not colname:
                continue
            value = tools_qt.get_text(dialog, widget)
            if value != 'null':
                fields += f'"{colname}":"{value}", '

        for widget in dialog.findChildren(QCheckBox):
            colname = widget.property('columnname')
            if not colname:
                continue
            value = str(tools_qt.is_checked(dialog, widget)).lower()
            if value not in ('null', '""'):
                fields += f'"{colname}":{value}, '

        for widget in dialog.findChildren(QComboBox):
            colname = widget.property('columnname')
            if not colname:
                continue
            value = tools_qt.get_combo_value(dialog, widget)
            if value not in ('null', '', '-1'):
                fields += f'"{colname}":"{value}", '

        for widget in dialog.findChildren(QDateEdit):
            colname = widget.property('columnname')
            if not colname:
                continue
            value = tools_qt.get_calendar_date(dialog, widget)
            if value:
                fields += f'"{colname}":"{value}", '

        if fields.endswith(', '):
            fields = fields[:-2]

        return fields


    def setup_tab_relations(self):
        #self.dialog.tab_relations.setCurrentIndex(0)
        self.feature_type = tools_gw.get_signal_change_tab(self.dialog)
        self.rubber_band = tools_gw.create_rubberband(self.canvas)
        table_object = "campaign"
        tools_gw.get_signal_change_tab(self.dialog)

        highlight_mappings = {
            "arc": ("v_edit_arc", "arc_id", 5),
            "node": ("v_edit_node", "node_id", 10),
            "connec": ("v_edit_connec", "connec_id", 10),
            "link": ("v_edit_link", "link_id", 10),
            "gully": ("v_edit_gully", "gully_id", 10)
        }

        for name, (layer, id_column, size) in highlight_mappings.items():
            tbl = getattr(self.dialog, f"tbl_campaign_x_{name}", None)
            if tbl:
                tbl.clicked.connect(
                    partial(tools_qgis.highlight_feature_by_id, tbl, layer, id_column, self.rubber_band, size))

        self.dialog.tab_feature.currentChanged.connect(
            lambda: self._update_feature_completer(self.dialog)
        )

        self.dialog.tab_feature.currentChanged.connect(self._on_tab_feature_changed)

        self.dialog.btn_insert.clicked.connect(
            partial(tools_gw.insert_feature, self, self.dialog, table_object, GwSelectionMode.CAMPAIGN, True, None, None))

        self.dialog.btn_delete.clicked.connect(
            partial(tools_gw.delete_records, self, self.dialog, table_object, GwSelectionMode.CAMPAIGN, None, None, None))

        self.dialog.btn_snapping.clicked.connect(
            partial(tools_gw.selection_init, self, self.dialog, table_object, GwSelectionMode.CAMPAIGN)
        )


    def _on_tab_feature_changed(self):
        self.feature_type = tools_gw.get_signal_change_tab(self.dialog, self.excluded_layers)


    def get_widget_by_columnname(self, dialog, columnname):
        for widget in dialog.findChildren(QWidget):
            if widget.property("columnname") == columnname:
                return widget
        return None


    def _update_feature_completer(self, dlg):
        tab_name = dlg.tab_feature.currentWidget().objectName()
        table_map = {
            'tab_arc': ('v_edit_arc', 'arc_id'),
            'tab_node': ('v_edit_node', 'node_id'),
            'tab_connec': ('v_edit_connec', 'connec_id'),
            'tab_link': ('v_edit_link', 'link_id'),
            'tab_gully': ('v_edit_gully', 'gully_id')
        }
        table_name, id_column = table_map.get(tab_name, (None, None))
        if not table_name:
            return

        sql = f"SELECT {id_column}::text FROM {self.schema_name}.{table_name} ORDER BY {id_column} LIMIT 100"
        result = tools_db.get_rows(sql)
        values = [row[id_column] for row in result if row.get(id_column)]

        completer = QCompleter(values)
        completer.setCaseSensitivity(False)
        dlg.feature_id.setCompleter(completer)


    def _on_reviewclass_changed(self):
        """Called when the user changes reviewclass combo."""

        reviewclass_data = self.reviewclass_combo.currentData()
        if not reviewclass_data:
            return

        reviewclass_id = reviewclass_data[0]
        if not str(reviewclass_id).isdigit():
            return

        feature_types = self.get_allowed_feature_types_for_reviewclass(int(reviewclass_id))
        print("Features_type:", feature_types)
        self._manage_tabs_enabled(feature_types)


    def get_allowed_feature_types_for_reviewclass(self, reviewclass_id: int):
        """Query om_reviewclass_x_layer to get allowed feature types for a given reviewclass"""
        sql = f"""
            SELECT DISTINCT feature_type
            FROM cm.om_reviewclass_x_layer
            WHERE reviewclass_id = {reviewclass_id}
        """
        rows = tools_db.get_rows(sql)
        return [r["feature_type"] for r in rows if r.get("feature_type")]


    def _manage_tabs_enabled(self, feature_types):
        """ Enable or disable relation tabs depending on allowed feature types (e.g., ['node', 'arc']). """

        # Normalize all feature types to lowercase for comparison
        normalized = [ft.lower() for ft in feature_types]

        tab_widget = self.dialog.tab_feature

        print("Enabled tabs should be:", normalized)

        for i in range(tab_widget.count()):
            widget = tab_widget.widget(i)
            if not widget:
                continue

            object_name = widget.objectName()
            tab_type = object_name.replace("tab_", "")
            enabled = tab_type in normalized
            tab_widget.setTabEnabled(i, enabled)


    def populate_tableview(self, view: QTableView, query: str, columns: list[str] = None):
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


    # Campaign manager
    def load_campaigns_into_manager(self):
        """Load campaign data into the campaign management table"""

        if not hasattr(self.dialog, "tbl_campaign"):
            return

        query = "SELECT * FROM cm.om_campaign ORDER BY id DESC"
        self.populate_tableview(self.dialog.tbl_campaign, query)


    def manage_date_filter(self):
        """Update date filters based on selected field (e.g., real_startdate)"""

        field = tools_qt.get_combo_value(self.dialog, self.dialog.campaign_cmb_date_filter_type, 0)
        print(field)
        if not field:
            return

        sql = f"""
            SELECT 
                MIN({field})::date AS min_date, 
                MAX({field})::date AS max_date 
            FROM cm.om_campaign 
            WHERE {field} IS NOT NULL
        """
        print(sql)
        result = tools_db.get_row(sql)

        if result:
            min_date = result.get("min_date")
            max_date = result.get("max_date")

            if min_date:
                self.dialog.date_event_from.setDate(min_date)
            if max_date:
                self.dialog.date_event_to.setDate(max_date)


    def filter_campaigns(self):
        """Filter om_campaign based on status and date"""

        filters = []

        # Estado
        status_row = self.dialog.campaign_cmb_state.currentData()
        if status_row and status_row[0]:
            filters.append(f"status = {status_row[0]}")

        # Columna de fecha
        date_type = tools_qt.get_combo_value(self.dialog, self.dialog.campaign_cmb_date_filter_type, 0)
        if not date_type:
            tools_qgis.show_warning("Select a valid date column to filter.", dialog=self.dialog)
            return

        # Rango de fechas
        date_from = self.dialog.date_event_from.date()
        date_to = self.dialog.date_event_to.date()

        # Auto-correct date range
        if date_from > date_to:
            self.dialog.date_event_to.setDate(date_from)
            date_to = date_from  # Update variable too

        date_format_low = self.campaign_date_format + ' 00:00:00'
        date_format_high = self.campaign_date_format + ' 23:59:59'

        interval = f"'{date_from.toString(date_format_low)}' AND '{date_to.toString(date_format_high)}'"
        date_filter = f"({date_type} BETWEEN {interval}"

        # Mostrar nulos
        if self.dialog.campaign_chk_show_nulls.isChecked():
            date_filter += f" OR {date_type} IS NULL)"
        else:
            date_filter += ")"

        filters.append(date_filter)

        # Build SQL
        where_clause = " AND ".join(filters)
        query = "SELECT * FROM cm.om_campaign"
        if where_clause:
            query += f" WHERE {where_clause}"
        query += " ORDER BY id DESC"

        self.populate_tableview(self.dialog.tbl_campaign, query)

    def delete_selected_campaign(self):
        """Delete the selected campaign"""
        selected = self.dialog.tbl_campaign.selectionModel().selectedRows()
        if not selected:
            tools_qgis.show_warning("Select a campaign to delete.", dialog=self.dialog)
            return

        index = selected[0]
        campaign_id = index.data()
        if not str(campaign_id).isdigit():
            tools_qgis.show_warning("Invalid campaign ID.", dialog=self.dialog)
            return

        # Confirm deletion
        if not tools_qt.show_question(f"Are you sure you want to delete {len(selected)} campaign(s)?"):
            return

        success = 0
        for index in selected:
            campaign_id = index.data()
            if not str(campaign_id).isdigit():
                continue
            sql = f"DELETE FROM cm.om_campaign WHERE id = {campaign_id}"
            if tools_db.execute_sql(sql):
                success += 1

        tools_qgis.show_info(f"{success} campaign(s) deleted.", dialog=self.dialog)
        self.filter_campaigns()

    def open_selected_campaign(self):
        """Open the selected campaign from the manager"""
        selected = self.dialog.tbl_campaign.selectionModel().selectedRows()
        if not selected:
            tools_qgis.show_warning("Select a campaign to open.")
            return

        index = selected[0]
        campaign_id = index.data()
        if not str(campaign_id).isdigit():
            tools_qgis.show_warning("Invalid campaign ID.")
            return

        self.create_campaign(campaign_id=int(campaign_id), is_new=False, dialog_type="review")

    def open_campaign(self, index):
        """Open campaign from the clicked index safely (double click handler)."""
        if not index.isValid():
            return

        model = index.model()
        row = index.row()
        id_index = model.index(row, 0)
        campaign_id = model.data(id_index)

        try:
            campaign_id = int(campaign_id)
            if campaign_id > 0:
                # Delay dialog creation to avoid access violation during double-click stack
                QTimer.singleShot(0, lambda: self.load_campaign_dialog(campaign_id))
        except (ValueError, TypeError):
            tools_qgis.show_warning("Invalid campaign ID.")

    def _on_campaign_double_click(self, index):
        campaign_id = index.model().data(index.model().index(index.row(), 0))
        self.load_campaign_dialog(int(campaign_id))


