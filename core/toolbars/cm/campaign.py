"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-

from qgis.PyQt.QtCore import QDate
from qgis.PyQt.QtWidgets import QLineEdit, QDateEdit, QCheckBox, QComboBox, QWidget
from .... import global_vars
from ....libs import tools_qt, tools_db, tools_qgis
from ...utils import tools_gw
from ...ui.ui_manager import AddCampaignReviewUi, AddCampaignVisitUi, CampaignManagementUi


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
        """Loads and opens the dynamic campaign dialog for review or visit"""
        self.campaign_type = mode

        # Compose JSON input
        feature = {
            "tableName": "om_campaign",
            "idName": "id",
            "campaign_mode": mode
        }
        if campaign_id:
            feature["id"] = campaign_id

        p_data = {
            "client": {
                "device": 4,
                "lang": "en_US",
                "infoType": 1,
                "epsg": 25831
            },
            "feature": feature
        }

        # Call the DB function
        response = tools_gw.execute_procedure("gw_fct_getcampaign", p_data, schema_name="cm")
        if not response or response.get("status") != "Accepted":
            tools_qgis.show_warning("Failed to load campaign form.")
            return

        # Extract form structure and create dialog
        data = response["body"]["data"]
        form_fields = data["fields"]
        print(form_fields)
        is_new = not campaign_id

        # Choose the right dialog class
        if mode == "review":
            self.dialog = AddCampaignReviewUi(self)
        elif mode == "visit":
            self.dialog = AddCampaignVisitUi(self)
        else:
            raise ValueError("Invalid campaign mode")

        tools_gw.load_settings(self.dialog)
        for field in form_fields:
            print("hola")
            widget = self.dialog.findChild(QWidget, field['widgetname'])
            value = field.get("value") or field.get("selectedId")
            if isinstance(widget, QLineEdit):
                widget.setText(value or '')
            elif isinstance(widget, QCheckBox):
                widget.setChecked(value in ['true', True, '1', 1])
            elif isinstance(widget, QComboBox):
                index = widget.findData(value)
                if index != -1:
                    widget.setCurrentIndex(index)

        if not is_new:
            tools_qt.set_widget_text(self.dialog, self.dialog.campaign_id, campaign_id)

        self.dialog.btn_cancel.clicked.connect(self.dialog.reject)
        self.dialog.btn_accept.clicked.connect(self.save_campaign_review)

        tools_gw.open_dialog(self.dialog, dlg_name="add_campaign")


    def save_campaign_review(self):
        fields = ''

        for widget in self.dialog.findChildren((QLineEdit, QDateEdit)):
            widget_name = widget.property('columnname')
            if not widget_name:
                continue
            if isinstance(widget, QLineEdit):
                value = tools_qt.get_text(self.dialog, widget)
            elif isinstance(widget, QDateEdit):
                value = widget.date().toString(self.campaign_date_format)
            if value not in ('null', ''):
                fields += f'"{widget_name}":"{value}",'

        for widget in self.dialog.findChildren(QCheckBox):
            widget_name = widget.property('columnname')
            if widget_name:
                value = tools_qt.is_checked(self.dialog, widget)
                fields += f'"{widget_name}":{str(value).lower()},'

        for widget in self.dialog.findChildren(QComboBox):
            widget_name = widget.property('columnname')
            if not widget_name:
                continue
            value = tools_qt.get_combo_value(self.dialog, widget)
            if value not in ('null', '', '-1'):
                fields += f'"{widget_name}":{value},'

        if fields.endswith(','):
            fields = fields[:-1]

        campaign_type = self.campaign_type if self.campaign_type is not None else -1

        feature = '"tableName":"om_campaign"'
        extras = f'"campaign_type": {campaign_type}, "fields":{{{fields}}}'
        body = tools_gw.create_body(feature=feature, extras=extras)

        result = tools_gw.execute_procedure('gw_fct_setcampaign', body, schema_name='cm')
        if result and result.get('status') == 'Accepted':
            tools_qgis.show_info("Campaign saved successfully")
            self.dialog.accept()
        else:
            tools_qgis.show_warning(f"Failed to save campaign: {result}")
