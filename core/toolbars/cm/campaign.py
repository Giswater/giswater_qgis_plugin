"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-

from qgis.PyQt.QtCore import QDate
from qgis.PyQt.QtWidgets import QLineEdit, QDateEdit, QCheckBox, QComboBox, QWidget, QLabel, QGridLayout, QSpacerItem, QSizePolicy, QTextEdit
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
        self.campaign_type = mode

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
            "feature": feature,
            "form": {},
            "data": {
                "filterFields": {},
                "pafeInfo": {}
            }
        }

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

            label = QLabel(field["label"]) if field.get("label") else None
            tools_gw.add_widget(self.dialog, field, label, widget)

        self.dialog.btn_cancel.clicked.connect(self.dialog.reject)
        self.dialog.btn_accept.clicked.connect(self.save_campaign_review)

        tools_gw.open_dialog(self.dialog, dlg_name="add_campaign")

    def create_widget_from_field(self, field):
        """Create a Qt widget based on field metadata"""
        wtype = field.get("widgettype", "text")

        if wtype == "text":
            return QLineEdit()
        elif wtype == "textarea":
            return QTextEdit()
        elif wtype == "datetime":
            widget = QDateEdit()
            widget.setCalendarPopup(True)
            widget.setDisplayFormat("MM/dd/yyyy")
            value = field.get("value")
            if value:
                try:
                    date = QDate.fromString(value, "yyyy-MM-dd")
                    if date.isValid():
                        widget.setDate(date)
                    else:
                        widget.setDate(QDate.currentDate())
                except:
                    widget.setDate(QDate.currentDate())
            else:
                widget.setDate(QDate.currentDate())
            return widget
        elif wtype == "check":
            return QCheckBox()
        elif wtype == "combo":
            combo = QComboBox()
            ids = field.get("comboIds", [])
            names = field.get("comboNames", [])
            for i, name in enumerate(names):
                combo.addItem(name, ids[i] if i < len(ids) else name)
            return combo
        else:
            return None


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
