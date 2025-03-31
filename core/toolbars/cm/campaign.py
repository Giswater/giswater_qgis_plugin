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
from qgis.PyQt.QtCore import QDate
from qgis.PyQt.QtWidgets import QLineEdit, QDateEdit, QCheckBox, QComboBox, QWidget, QLabel, QGridLayout, QSpacerItem, \
    QSizePolicy, QTextEdit, QMenu, QAction, QCompleter, QToolButton, QTableView
from .... import global_vars
from ....libs import tools_qt, tools_db, tools_qgis, lib_vars
from ...utils import tools_gw
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
        tools_gw.open_dialog(self.dialog, dlg_name="campaign_manager")


    def load_campaign_dialog(self, campaign_id=None, mode="review"):

        # In the edit_typevalue or another cm.edit_typevalue
        # INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('cm_campaing_type', '1', 'Review', NULL, NULL);
        # INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('cm_campaing_type', '2', 'Visit', NULL, NULL);

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
            index = self.dialog.tab_feature.indexOf(self.dialog.tab_5)
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

        tools_gw.add_icon(self.dialog.btn_insert, '111')
        tools_gw.add_icon(self.dialog.btn_delete, '112')
        tools_gw.add_icon(self.dialog.btn_snapping, '137')

        self.dialog.btn_cancel.clicked.connect(self.dialog.reject)
        self.dialog.btn_accept.clicked.connect(self.save_campaign)
        self.dialog.tab_widget.currentChanged.connect(self._on_tab_change)
        self.setup_tab_relations()
        self._update_feature_completer(self.dialog)

        tools_gw.open_dialog(self.dialog, dlg_name="add_campaign")


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
        try:
            fields_str = self.extract_campaign_fields(self.dialog)
            extras = f'"fields":{{{fields_str}}}, "campaign_type":{self.campaign_type}'
            body = tools_gw.create_body(feature='"tableName":"om_campaign", "idName":"id"', extras=extras)

            result = tools_gw.execute_procedure("gw_fct_setcampaign", body, schema_name="cm")

            if result.get("status") == "Accepted":
                tools_qgis.show_info("Campaign saved successfully.", dialog=self.dialog)
                self.campaign_saved = True
                self.is_new_campaign = False

                # Update campaign ID in the dialog
                campaign_id = result.get("body", {}).get("campaign_id")
                if campaign_id:
                    id_field = self.dialog.findChild(QLineEdit, "id")
                    if id_field:
                        id_field.setTseext(str(campaign_id))

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
        self.feature_type = "arc"
        self.rubber_band = tools_gw.create_rubberband(self.canvas)

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
        self.dialog.btn_insert.clicked.connect(
            lambda: self.insert_campaign_relation(self.dialog)
        )

        self.dialog.btn_delete.clicked.connect(
            lambda: self.delete_campaign_relation(self.dialog)
        )

        self.dialog.btn_snapping.clicked.connect(
            partial(tools_gw.selection_init, self, self.dialog, None, False)
        )

    def _update_feature_completer(self, dlg):
        tab_name = dlg.tab_feature.currentWidget().objectName()
        table_map = {
            'tab': ('v_edit_arc', 'arc_id'),
            'tab_2': ('v_edit_node', 'node_id'),
            'tab_3': ('v_edit_connec', 'connec_id'),
            'tab_4': ('v_edit_link', 'link_id'),
            'tab_5': ('v_edit_gully', 'gully_id')
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


    def _load_relation_table(self, view, table_name, id_column, campaign_id):
        """Load existing relations into the view"""
        query = f"""SELECT * from {table_name} where campaign_id = {campaign_id}"""
        self.populate_tableview(view, query)


    def insert_campaign_relation(self, dialog):
        """Insert feature into the corresponding om_campaign_x_* table"""

        # Get campaign ID from the dialog field
        for w in dialog.findChildren(QLineEdit):
            if w.property("columnname") == "id":
                campaign_id = tools_qt.get_text(dialog, w)
                break
        print("campaign_id: ", campaign_id)
        if not campaign_id or not campaign_id.isdigit():
            tools_qgis.show_warning("Invalid campaign ID.")
            return

        # Get the feature ID from the line edit
        feature_id = dialog.feature_id.text().strip()
        if not feature_id or not feature_id.isdigit():
            tools_qgis.show_warning("Feature ID must be a number.")
            return

        # Determine current tab and corresponding table/column
        tab_name = dialog.tab_feature.currentWidget().objectName()
        table_map = {
            "tab": ("om_campaign_x_arc", "arc_id"),
            "tab_2": ("om_campaign_x_node", "node_id"),
            "tab_3": ("om_campaign_x_connec", "connec_id"),
            'tab_4': ('om_campaign_x_link', 'link_id'),
            "tab_5": ("om_campaign_x_gully", "gully_id"),
        }

        table_info = table_map.get(tab_name)
        if not table_info:
            tools_qgis.show_warning("Unknown feature tab.")
            return

        table_name, column_name = table_info

        # Build and execute SQL
        sql = f"""
            INSERT INTO cm.{table_name} (campaign_id, {column_name})
            VALUES ({campaign_id}, '{feature_id}')
        """
        ok = tools_db.execute_sql(sql)
        if ok:
            tools_qgis.show_info(f"{feature_id} inserted into {table_name}")
            dialog.feature_id.clear()
            self._refresh_relation_table(dialog)
        else:
            tools_qgis.show_warning("Insert failed.")


    def delete_campaign_relation(self, dialog):
        """Delete selected row from the active relation table"""
        current_tab = dialog.tab_feature.currentWidget().objectName()
        table = self._get_relation_table(dialog, current_tab)
        selected = table.selectedItems()
        if selected:
            row = selected[0].row()
            table.removeRow(row)


    def _get_relation_table(self, dialog, tab_name):
        return {
            'tab': dialog.tbl_campaign_x_arc,
            'tab_2': dialog.tbl_campaign_x_node,
            'tab_3': dialog.tbl_campaign_x_connec,
            'tab_4': dialog.tbl_campaign_x_link,
            'tab_5': dialog.tbl_campaign_x_gully,
        }.get(tab_name)


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

    def _refresh_relation_table(self, dialog):
        """Refresh the current relation table based on selected tab"""
        tab_name = dialog.tab_feature.currentWidget().objectName()

        table_map = {
            "tab": ("tbl_campaign_x_arc", "om_campaign_x_arc", "arc_id"),
            "tab_2": ("tbl_campaign_x_node", "om_campaign_x_node", "node_id"),
            "tab_3": ("tbl_campaign_x_connec", "om_campaign_x_connec", "connec_id"),
            "tab_4": ("tbl_campaign_x_link", "om_campaign_x_link", "link_id"),
            "tab_5": ("tbl_campaign_x_gully", "om_campaign_x_gully", "gully_id"),
        }

        table_info = table_map.get(tab_name)
        if not table_info:
            return

        table_widget_name, table_name, id_column = table_info
        table_widget = getattr(dialog, table_widget_name, None)
        if not table_widget:
            return

        # Get campaign_id from the dialog
        campaign_id = None
        for w in dialog.findChildren(QLineEdit):
            if w.property("columnname") == "id":
                campaign_id = tools_qt.get_text(dialog, w)
                break
        if not campaign_id:
            return
        print(table_widget)
        print(table_name)
        print(id_column)
        print(campaign_id)

        self._load_relation_table(table_widget, table_name, id_column, campaign_id)
