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
from ....libs import tools_qt


class GwAddCampaignButton(GwAction):
    """ Button 84: Add new campaign """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.new_campaign = Campaign(icon_path, action_name, text, toolbar, action_group)

        self.actions = [tools_qt.tr('Review'), tools_qt.tr('Visit')]

        # Create a menu and add all the actions
        self.menu = QMenu()
        self.menu.setObjectName("GW_create_campaign")
        self._fill_action_menu()

        if toolbar is not None:
            self.action.setMenu(self.menu)
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
