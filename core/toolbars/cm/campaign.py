"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-

from qgis.core import Qgis
from qgis.PyQt.QtCore import QDate, Qt
from qgis.PyQt.QtWidgets import QLineEdit, QDateEdit
from .... import global_vars
from ....libs import lib_vars, tools_qt, tools_db
from ...utils import tools_gw
from ...ui.ui_manager import AddCampaignReviewUi, AddCampaignVisitUi, CampaignManagementUi


class Campaign:
    """Handles campaign creation, management, and database operations"""

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        self.iface = global_vars.iface
        self.campaign_date_format = 'yyyy-MM-dd'
        self.dialog = None

    def create_campaign(self, campaign_id=None, is_new=True, dialog_type="review"):
        """ Opens the appropriate campaign dialog based on user selection """
        if dialog_type == "review":
            self.dialog = AddCampaignReviewUi(self)
        elif dialog_type == "visit":
            self.dialog = AddCampaignVisitUi(self)
        else:
            raise ValueError("Invalid dialog type for campaign")

        tools_gw.load_settings(self.dialog)

        # Setup buttons and signals
        self.dialog.btn_cancel.clicked.connect(self.dialog.reject)
        self.dialog.btn_accept.clicked.connect(self.save_campaign)

        # Load data if editing an existing campaign
        if not is_new and campaign_id:
            self.load_campaign_data(campaign_id)

        # Open dialog
        tools_gw.open_dialog(self.dialog, dlg_name="add_campaign")

    def campaign_manager(self):
        """ Opens the campaign management interface """
        self.dialog = CampaignManagementUi(self)
        tools_gw.load_settings(self.dialog)
        tools_gw.open_dialog(self.dialog, dlg_name="campaign_manager")

    def load_campaign_data(self, campaign_id):
        """ Load campaign details into the UI for editing """
        sql = f"SELECT name, start_date, end_date FROM campaigns WHERE id = {campaign_id}"
        row = tools_db.get_rows(sql)

        if row:
            self.dialog.findChild(QLineEdit, "campaign_name").setText(row[0])
            self.dialog.findChild(QDateEdit, "start_date").setDate(QDate.fromString(row[1], self.campaign_date_format))
            self.dialog.findChild(QDateEdit, "end_date").setDate(QDate.fromString(row[2], self.campaign_date_format))

    def save_campaign(self):
        """ Saves the campaign data to the database """
        campaign_name = self.dialog.findChild(QLineEdit, "campaign_name").text().strip()
        start_date = self.dialog.findChild(QDateEdit, "start_date").date().toString(self.campaign_date_format)
        end_date = self.dialog.findChild(QDateEdit, "end_date").date().toString(self.campaign_date_format)

        if not campaign_name:
            tools_qt.show_warning("Campaign name is required!")
            return

        # Check if editing an existing campaign
        campaign_id = getattr(self.dialog, "campaign_id", None)
        if campaign_id:
            sql = f"""
                UPDATE campaigns 
                SET name='{campaign_name}', start_date='{start_date}', end_date='{end_date}' 
                WHERE id={campaign_id}
            """
        else:
            sql = f"""
                INSERT INTO campaigns (name, start_date, end_date) 
                VALUES ('{campaign_name}', '{start_date}', '{end_date}')
            """

        tools_db.execute_sql(sql)
        self.dialog.accept()
