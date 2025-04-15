"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from .campaign import Campaign
from .lot import AddNewLot
from ..dialog import GwAction
from qgis.PyQt.QtWidgets import QAction, QMenu, QActionGroup
from functools import partial
from ...utils import tools_gw

class GwManageCampaignLotButton(GwAction):
    """ Button 87: Campaign Management """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.campaign_manager = Campaign(icon_path, action_name, text, toolbar, action_group)
        self.new_lot = AddNewLot(icon_path, action_name, text, toolbar, action_group)

        self.actions = ['Manage Campaign', 'Manage Lot']

        # Create a menu and add all the actions
        self.menu = QMenu()
        self.menu.setObjectName("GW_manage_campaign_lot")
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
        if selected_action == "Manage Campaign":
            self.campaign_manager.campaign_manager()
        elif selected_action == "Manage Lot":
            self.new_lot.lot_manager()

