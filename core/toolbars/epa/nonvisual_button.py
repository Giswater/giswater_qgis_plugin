"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from qgis.PyQt.QtWidgets import QMenu, QAction, QActionGroup

from ..dialog import GwAction
from ...shared.nonvisual import GwNonVisual
from ...utils import tools_gw
from ....lib import tools_qt, tools_qgis, tools_db, tools_os
from .... import global_vars


class GwNonVisualButton(GwAction):
    """ Button 217: Non visual objects """

    def __init__(self, icon_path, action_name, text, toolbar, action_group, menu_actions=None):
        super().__init__(icon_path, action_name, text, toolbar, action_group)

        # Create a menu and add all the actions
        if toolbar is not None:
            toolbar.removeAction(self.action)

        self.selected_action = None
        self.menu = QMenu()
        self.menu.setObjectName("GW_nonvisual_menu")
        self._fill_action_menu(menu_actions)

        if toolbar is not None:
            self.action.setMenu(self.menu)
            toolbar.addAction(self.action)
        self.nonvisual = GwNonVisual()


    def clicked_event(self):
        self.nonvisual.get_nonvisual(self.selected_action)


    def _fill_action_menu(self, menu_actions):
        """ Fill action menu """

        # disconnect and remove previuos signals and actions
        actions = self.menu.actions()
        for action in actions:
            action.disconnect()
            self.menu.removeAction(action)
            del action
        ag = QActionGroup(self.iface.mainWindow())

        actions = menu_actions
        if actions is None:
            if global_vars.project_type == 'ws':
                actions = ['CURVES', 'PATTERNS', 'CONTROLS', 'RULES']
            elif global_vars.project_type == 'ud':
                actions = ['CURVES', 'PATTERNS', 'CONTROLS', 'TIMESERIES']
            else:
                actions = []

        for action in actions:
            obj_action = QAction(f"{action}", ag)
            self.menu.addAction(obj_action)
            obj_action.triggered.connect(partial(self._get_selected_action, action))
            obj_action.triggered.connect(partial(self.clicked_event))


    def _get_selected_action(self, name):
        """ Gets selected action """

        self.selected_action = name

        tools_gw.set_config_parser("btn_nonvisual", "last_action", self.selected_action, "user", "session")
