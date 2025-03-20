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

    def create_campaign_review(self, campaign_id=None, is_new=True):
        """ Manages the creation or update of a campaign review """

        self.is_new_campaign = is_new
        self.dialog = AddCampaignReviewUi(self)  # Load the Review UI

        tools_gw.load_settings(self.dialog)

        # Populate dropdowns
        self.populate_campaign_reviewclass()

        # Generate a new ID if it's a new campaign
        new_campaign_id = campaign_id if campaign_id else self.get_next_id('om_campaign', 'id')
        tools_qt.set_widget_text(self.dialog, self.dialog.campaign_id, new_campaign_id)

        # Setup event listeners
        self.dialog.btn_cancel.clicked.connect(self.dialog.reject)
        self.dialog.btn_accept.clicked.connect(self.save_campaign_review)

        # Load existing campaign data if editing
        if not is_new and campaign_id:
            self.load_campaign_data(campaign_id)

        # Open the dialog
        tools_gw.open_dialog(self.dialog, dlg_name="add_campaign_review")


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


    def save_campaign_review(self):
        """ Saves the campaign review details to the database """

        campaign_id = self.dialog.findChild(QLineEdit, "campaign_name").text().strip()
        start_date = self.dialog.findChild(QDateEdit, "start_date").date().toString(self.campaign_date_format)
        end_date = self.dialog.findChild(QDateEdit, "end_date").date().toString(self.campaign_date_format)
        reviewclass_id = tools_qt.get_combo_value(self.dialog,
                                                  self.dialog.findChild(QComboBox, "campaign_reviewclass_id"), 0)

        if not campaign_name:
            tools_qt.show_warning("Campaign name is required!")
            return

        sql = f"""
            INSERT INTO campaigns (name, start_date, end_date, reviewclass_id) 
            VALUES ('{campaign_name}', '{start_date}', '{end_date}', '{reviewclass_id}')
        """

        tools_db.execute_sql(sql)
        self.dialog.accept()


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


    def populate_campaign_reviewclass(self):
        """ Populates the campaign_reviewclass_id combo box with values from om_reviewclass """

        sql = "SELECT id, idval FROM cm.om_reviewclass WHERE active = true ORDER BY id"
        rows = tools_db.get_rows(sql)

        if rows:
            tools_qt.fill_combo_values(self.dialog.campaign_reviewclass_id, rows, 1)  # Display idval, store id


    def get_next_id(self, table_name, pk):
        """Retrieves the next available ID for a new record by finding the max value in the table."""
        sql = f"SELECT MAX({pk}::integer) FROM cm.{table_name};"
        row = tools_db.get_rows(sql)

        if row and isinstance(row, list) and len(row) > 0 and isinstance(row[0], tuple):
            max_id = row[0][0] if row[0][0] is not None else 0
        else:
            max_id = 0

        return max_id + 1
