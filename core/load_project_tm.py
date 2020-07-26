"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtWidgets import QActionGroup

from .. import global_vars
from .load_project import LoadProject
from ..actions.tm_basic import TmBasic
from ..lib.qgis_tools import QgisTools


class LoadProjectTm(LoadProject):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to manage load project of type 'tm' """

        LoadProject.__init__(self, iface, settings, controller, plugin_dir)


    def project_read_tm(self):
        """ Function executed when a user opens a QGIS project of type 'tm' """

        # Set actions classes (define one class per plugin toolbar)
        self.tm_basic = TmBasic(self.iface, global_vars.settings, self.controller, self.plugin_dir)
        self.tm_basic.set_tree_manage(self)

        # Manage actions of the different plugin_toolbars
        self.manage_toolbars_common()
        self.manage_toolbars_tm()

        # Set actions to controller class for further management
        self.controller.set_actions(self.actions)

        # Set objects for map tools classes
        self.manage_map_tools()

        # Log it
        message = "Project read successfully ('tm')"
        self.controller.log_info(message)


    def manage_toolbars_tm(self):
        """ Manage actions of the different plugin toolbars """

        toolbar_id = "tm_basic"
        list_actions = ['303', '301', '302', '304', '305', '309']
        self.manage_toolbar(toolbar_id, list_actions)

        # Manage action group of every toolbar
        parent = self.iface.mainWindow()
        for plugin_toolbar in list(self.plugin_toolbars.values()):
            ag = QActionGroup(parent)
            for index_action in plugin_toolbar.list_actions:
                self.add_action(index_action, plugin_toolbar.toolbar, ag)

        # Enable toolbars
        self.enable_toolbar("basic")
        self.enable_toolbar("utils")
        self.enable_toolbar("tm_basic")
        self.tm_basic.set_controller(self.controller)



