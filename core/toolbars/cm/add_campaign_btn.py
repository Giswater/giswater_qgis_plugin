"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from .campaign import Campaign
from ..dialog import GwAction
from qgis.PyQt.QtWidgets import QAction, QMenu, QActionGroup
from functools import partial
from ....libs import tools_qt, tools_db
import json


class GwAddCampaignButton(GwAction):
    """ Button 84: Add new campaign """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.new_campaign = Campaign(icon_path, action_name, text, toolbar, action_group)

        # Fetch and parse the campaign type configuration from the database
        config_query = "SELECT value FROM cm.config_param_system WHERE parameter = 'create_campaign_type'"
        config_result = tools_db.get_row(config_query)
        
        show_review = True
        show_visit = True
        
        if config_result and config_result['value']:
            try:
                config = json.loads(config_result['value'])
                show_review = config.get('campaignReview', 'true').lower() == 'true'
                show_visit = config.get('campaignVisit', 'true').lower() == 'true'
            except (json.JSONDecodeError, KeyError):
                # Fallback to default if JSON is malformed
                pass

        # If both are false, default to showing only Review
        if not show_review and not show_visit:
            show_review = True

        # Conditional logic for button creation
        if show_review and show_visit:
            # Both are true: create a dropdown menu
            self.actions = [tools_qt.tr('Review'), tools_qt.tr('Visit')]
            self.menu = QMenu()
            self.menu.setObjectName("GW_create_campaign")
            self._fill_action_menu()

            if toolbar is not None:
                self.action.setMenu(self.menu)
                toolbar.addAction(self.action)
        else:
            # Only one is true: create a simple button
            if show_review:
                self.action.triggered.connect(lambda: self.clicked_event(tools_qt.tr("Review")))
            elif show_visit:
                self.action.triggered.connect(lambda: self.clicked_event(tools_qt.tr("Visit")))
            
            if toolbar is not None:
                toolbar.addAction(self.action)

    def _fill_action_menu(self):
        """ Fill action menu """
        actions = self.menu.actions()
        for action in actions:
            action.disconnect()
            self.menu.removeAction(action)
            del action

        ag = QActionGroup(self.iface.mainWindow())

        for action in self.actions:
            obj_action = QAction(f"{action}", ag)
            self.menu.addAction(obj_action)
            obj_action.triggered.connect(partial(self.clicked_event, action))

    def clicked_event(self, selected_action):
        """ Open the correct campaign dialog based on user selection """
        if selected_action == tools_qt.tr("Review"):
            self.new_campaign.create_campaign(dialog_type="review")
        elif selected_action == tools_qt.tr("Visit"):
            self.new_campaign.create_campaign(dialog_type="visit")
