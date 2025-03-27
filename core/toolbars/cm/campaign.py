"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from qgis.PyQt.QtCore import QDate
from qgis.PyQt.QtWidgets import QLineEdit, QDateEdit, QCheckBox, QComboBox, QWidget, QLabel, QGridLayout, QSpacerItem, QSizePolicy, QTextEdit
from .... import global_vars
from ....libs import tools_qt, tools_db, tools_qgis
from ...utils import tools_gw
from ...ui.ui_manager import AddCampaignReviewUi, AddCampaignVisitUi, CampaignManagementUi
from qgis.gui import QgsDateTimeEdit


class Campaign:
    """Handles campaign creation, management, and database operations"""

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        self.iface = global_vars.iface
        self.campaign_date_format = 'yyyy-MM-dd'
        self.dialog = None
        self.campaign_type = None




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

        response = tools_gw.execute_procedure("gw_fct_getcampaign", p_data, schema_name="cm")
        if not response or response.get("status") != "Accepted":
            tools_qgis.show_warning("Failed to load campaign form.")
            return

        form_fields = response["body"]["data"].get("fields", [])
        self.dialog = AddCampaignReviewUi(self) if mode == "review" else AddCampaignVisitUi(self)

        tools_gw.load_settings(self.dialog)

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

        self.dialog.btn_cancel.clicked.connect(self.dialog.reject)
        self.dialog.btn_accept.clicked.connect(self.save_campaign)

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

    def save_campaign(self):
        """Save campaign data from the dialog"""
        try:
            # Get form values from dialog
            fields_str = self.extract_campaign_fields(self.dialog)
            print("CAMPAIGN_TYPE: ", self.campaign_type)
            print("hola: ", fields_str)

            # Prepare request body
            feature = '"tableName":"om_campaign", "idName":"id"'
            extras = f'"fields":{{{fields_str}}}, "campaign_type":{self.campaign_type}'
            body = tools_gw.create_body(feature=feature, extras=extras)

            # Execute the save procedure
            result = tools_gw.execute_procedure("gw_fct_setcampaign", body, schema_name="cm")

            if result.get("status") == "Accepted":
                tools_qgis.show_info("Campaign saved successfully.")
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