"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtWidgets import QAction, QMenu
from qgis.PyQt.QtGui import QKeySequence

from ..dialog import GwAction
from ...utils import tools_gw
from .... import global_vars
from functools import partial
from ....libs import tools_os
from ...shared.info import GwInfo


class GwElementButton(GwAction):
    """ Button 33: Element """

    def __init__(self, icon_path, action_name, text, toolbar, action_group, list_tabs=None, feature_type=None):
        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.list_tabs = list_tabs if list_tabs else ["node", "arc", "connec", "gully", 'link']
        self.feature_type = feature_type
        self.info_feature = GwInfo('data')
        self.menu = QMenu()
        self.menu.setObjectName("GW_element_menu")
        self._fill_element_menu()

        self.menu.aboutToShow.connect(self._fill_element_menu)
        if toolbar is not None:
            self.action.setMenu(self.menu)
            toolbar.addAction(self.action)
        
    def clicked_event(self):

        self._fill_element_menu()

    def _fill_element_menu(self):
        """ Fill add point menu """

        # disconnect and remove previuos signals and actions
        actions = self.menu.actions()
        for action in actions:
            action.disconnect()
            self.menu.removeAction(action)
            del action
        action_group = self.action.property('action_group')

        # Get list of different element types
        features_cat = tools_gw.manage_feature_cat()
        if features_cat is not None:
            list_feature_cat = tools_os.get_values_from_dictionary(features_cat)
            for feature_cat in list_feature_cat:
                if feature_cat.feature_class.upper() == 'FRELEM':
                    obj_action = QAction(str(feature_cat.id), action_group)
                    if f"{feature_cat.shortcut_key}" not in global_vars.shortcut_keys:
                        obj_action.setShortcut(QKeySequence(str(feature_cat.shortcut_key)))
                    try:
                        obj_action.setShortcutVisibleInContextMenu(True)
                    except Exception:
                        pass
                    self.menu.addAction(obj_action)
                    obj_action.triggered.connect(partial(self.info_feature.add_feature, feature_cat, self))
                    obj_action.triggered.connect(partial(self._save_last_selection, self.menu, feature_cat))
            self.menu.addSeparator()
            list_feature_cat = tools_os.get_values_from_dictionary(features_cat)
            for feature_cat in list_feature_cat:
                if feature_cat.feature_class.upper() == 'GENELEM':
                    obj_action = QAction(str(feature_cat.id), action_group)
                    if f"{feature_cat.shortcut_key}" not in global_vars.shortcut_keys:
                        obj_action.setShortcut(QKeySequence(str(feature_cat.shortcut_key)))
                    try:
                        obj_action.setShortcutVisibleInContextMenu(True)
                    except Exception:
                        pass
                    self.menu.addAction(obj_action)
                    obj_action.triggered.connect(partial(self.info_feature.add_feature, feature_cat, self))
                    obj_action.triggered.connect(partial(self._save_last_selection, self.menu, feature_cat))
            self.menu.addSeparator()

    def _save_last_selection(self, menu, feature_cat):
        menu.setProperty("last_selection", feature_cat)