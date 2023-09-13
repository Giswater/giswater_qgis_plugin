"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import json

from functools import partial

from qgis.PyQt.QtCore import QPoint
from qgis.PyQt.QtWidgets import QAction, QMenu

from ..dialog import GwAction
from .mapzone_manager import GwMapzoneManager
from ...shared.info import GwInfo
from ...shared.psector import GwPsector


class GwUtilsManagerButton(GwAction):
    """ Button 217: Utils manager """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)

        # First add the menu before adding it to the toolbar
        if toolbar is not None:
            toolbar.removeAction(self.action)

        self.info_feature = GwInfo('data')

        self.menu = QMenu()
        self.menu.setObjectName("GW_utils_menu")
        self._fill_utils_menu()

        self.menu.aboutToShow.connect(self._fill_utils_menu)

        if toolbar is not None:
            self.action.setMenu(self.menu)
            toolbar.addAction(self.action)


    def clicked_event(self):

        button = self.action.associatedWidgets()[1]
        menu_point = button.mapToGlobal(QPoint(0, button.height()))
        self.menu.popup(menu_point)


    # region private functions

    def _fill_utils_menu(self):
        """ Fill add arc menu """

        # disconnect and remove previuos signals and actions
        actions = self.menu.actions()
        for action in actions:
            action.disconnect()
            self.menu.removeAction(action)
            del action
        action_group = self.action.property('action_group')

        buttons = [['Mapzones manager', '_mapzones_manager'], ['Prices manager', '_prices_manager']]

        for button in buttons:
            button_name = button[0]
            button_function = button[1]
            obj_action = QAction(str(button_name), action_group)
            obj_action.setObjectName(button_name)
            obj_action.setProperty('action_group', action_group)
            # if f"{feature_cat.shortcut_key}" not in global_vars.shortcut_keys:
            #     obj_action.setShortcut(QKeySequence(str(feature_cat.shortcut_key)))
            # try:
            #     obj_action.setShortcutVisibleInContextMenu(True)
            # except Exception:
            #     pass
            self.menu.addAction(obj_action)
            obj_action.triggered.connect(partial(getattr(self, button_function)))
            # obj_action.triggered.connect(partial(self._save_last_selection, self.menu, feature_cat))


    def _prices_manager(self):
        self.psector = GwPsector()
        self.psector.manage_prices()

    # region mapzone manager functions

    def _mapzones_manager(self):

        self.mapzones_manager = GwMapzoneManager()
        self.mapzones_manager.manage_mapzones()
    # endregion
