"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from qgis.PyQt.QtGui import QKeySequence
from qgis.PyQt.QtWidgets import QAction, QMenu

from ..dialog import GwAction
from ...shared.info import GwInfo
from ...utils import tools_gw
from ....lib import tools_os
from .... import global_vars


class GwPointAddButton(GwAction):

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)

        # First add the menu before adding it to the toolbar
        if toolbar is not None:
            toolbar.removeAction(self.action)

        self.feature_cat = tools_gw.manage_feature_cat()
        project_type = tools_gw.get_project_type()
        self.info_feature = GwInfo('data')

        # Get list of different node and arc types
        self.menu = QMenu()
        # List of nodes from node_type_cat_type - nodes which we are using
        list_feature_cat = tools_os.get_values_from_dictionary(self.feature_cat)
        for feature_cat in list_feature_cat:
            if feature_cat.feature_type.upper() == 'NODE':
                obj_action = QAction(str(feature_cat.id), action_group)
                if f"{feature_cat.shortcut_key}" not in global_vars.shortcut_keys:
                    obj_action.setShortcut(QKeySequence(str(feature_cat.shortcut_key)))
                try:
                    obj_action.setShortcutVisibleInContextMenu(True)
                except:
                    pass
                self.menu.addAction(obj_action)
                obj_action.triggered.connect(partial(self.info_feature.add_feature, feature_cat))
                obj_action.triggered.connect(partial(self._save_last_selection, self.menu, feature_cat))

        self.menu.addSeparator()

        list_feature_cat = tools_os.get_values_from_dictionary(self.feature_cat)
        for feature_cat in list_feature_cat:
            if feature_cat.feature_type.upper() == 'CONNEC':
                obj_action = QAction(str(feature_cat.id), action_group)
                if f"{feature_cat.shortcut_key}" not in global_vars.shortcut_keys:
                    obj_action.setShortcut(QKeySequence(str(feature_cat.shortcut_key)))
                try:
                    obj_action.setShortcutVisibleInContextMenu(True)
                except:
                    pass
                self.menu.addAction(obj_action)
                obj_action.triggered.connect(partial(self.info_feature.add_feature, feature_cat))
                obj_action.triggered.connect(partial(self._save_last_selection, self.menu, feature_cat))
        self.menu.addSeparator()

        list_feature_cat = tools_os.get_values_from_dictionary(self.feature_cat)
        for feature_cat in list_feature_cat:
            if feature_cat.feature_type.upper() == 'GULLY' and project_type == 'ud':
                obj_action = QAction(str(feature_cat.id), action_group)
                if f"{feature_cat.shortcut_key}" not in global_vars.shortcut_keys:
                    obj_action.setShortcut(QKeySequence(str(feature_cat.shortcut_key)))
                try:
                    obj_action.setShortcutVisibleInContextMenu(True)
                except:
                    pass
                self.menu.addAction(obj_action)
                obj_action.triggered.connect(partial(self.info_feature.add_feature, feature_cat))
                obj_action.triggered.connect(partial(self._save_last_selection, self.menu, feature_cat))
        self.menu.addSeparator()


        if toolbar is not None:
            self.action.setMenu(self.menu)
            toolbar.addAction(self.action)


    def clicked_event(self):
        if self.menu.property('last_selection') is not None:
            self.info_feature.add_feature(self.menu.property('last_selection'))


    # region private functions

    def _save_last_selection(self, menu, feature_cat):
        menu.setProperty("last_selection", feature_cat)

    # endregion