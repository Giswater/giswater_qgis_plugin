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
from .... import global_vars
from ....lib import tools_os


class GwArcAddButton(GwAction):
    """ Button 02: Add arc """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)

        # First add the menu before adding it to the toolbar
        if toolbar is not None:
            toolbar.removeAction(self.action)

        self.info_feature = GwInfo('data')

        self.menu = QMenu()
        self.menu.setObjectName("GW_arc_menu")
        self._fill_arc_menu()

        self.menu.aboutToShow.connect(self._check_reload)

        if toolbar is not None:
            self.action.setMenu(self.menu)
            toolbar.addAction(self.action)


    def clicked_event(self):

        if self.menu.property('last_selection') is not None:
            self.info_feature.add_feature(self.menu.property('last_selection'))


    # region private functions


    def _check_reload(self):
        """ Check for reload button """

        reload_cat_feature = tools_gw.get_config_parser('system', 'reload_cat_feature', 'project', 'giswater')
        reload_cat_feature = tools_os.set_boolean(reload_cat_feature)
        if reload_cat_feature:
            self._fill_arc_menu()


    def _fill_arc_menu(self):
        """ Fill add arc menu """

        # disconnect and remove previuos signals and actions
        actions = self.menu.actions()
        for action in actions:
            action.disconnect()
            self.menu.removeAction(action)
            del action
        action_group = self.action.property('action_group')

        # Get list of different arc types
        features_cat = tools_gw.manage_feature_cat()
        if features_cat is not None:
            list_feature_cat = tools_os.get_values_from_dictionary(features_cat)
            for feature_cat in list_feature_cat:
                if feature_cat.feature_type.upper() == 'ARC':
                    obj_action = QAction(str(feature_cat.id), action_group)
                    obj_action.setObjectName(feature_cat.id)
                    obj_action.setProperty('action_group', action_group)
                    if f"{feature_cat.shortcut_key}" not in global_vars.shortcut_keys:
                        obj_action.setShortcut(QKeySequence(str(feature_cat.shortcut_key)))
                    try:
                        obj_action.setShortcutVisibleInContextMenu(True)
                    except Exception:
                        pass
                    self.menu.addAction(obj_action)
                    obj_action.triggered.connect(partial(self.info_feature.add_feature, feature_cat))
                    obj_action.triggered.connect(partial(self._save_last_selection, self.menu, feature_cat))


    def _save_last_selection(self, menu, feature_cat):
        menu.setProperty("last_selection", feature_cat)

    # endregion
