"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from qgis.PyQt.QtWidgets import QAction, QActionGroup, QMenu, QToolButton

from ..dialog import GwAction
from ...shared.mincut import GwMincut
from ...ui.ui_manager import GwMincutUi
from ....libs import tools_qt

from .... import global_vars


class GwMincutButton(GwAction):
    """ Button 11: Mincut """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)
        if global_vars.project_type == 'ws':
            if toolbar is not None:
                toolbar.removeAction(self.action)

            self.mincut = GwMincut()
            self.actions = [tools_qt.tr('Mincut'), tools_qt.tr('Offline Mincut')]
            self.last_selection = tools_qt.tr('Mincut')
            self.menu = QMenu()
            self.menu.setObjectName("GW_mincut")
            self._fill_action_menu()

            if toolbar is not None:
                self.action.setMenu(self.menu)
                toolbar.addAction(self.action)
                button = toolbar.widgetForAction(self.action)
                if isinstance(button, QToolButton):
                    button.setPopupMode(QToolButton.ToolButtonPopupMode.MenuButtonPopup)

    def _fill_action_menu(self):
        """Fill action menu."""

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

    def clicked_event(self, selected_action=None):

        if global_vars.project_type != 'ws':
            return

        if selected_action is None or isinstance(selected_action, bool):
            selected_action = self.last_selection
        else:
            self.last_selection = selected_action

        if selected_action == tools_qt.tr('Offline Mincut'):
            self.mincut.start_offline_mincut()
            return

        self.mincut.mincut_mode = 'network'
        self.mincut.set_dialog(GwMincutUi(self))
        self.mincut.get_mincut()

