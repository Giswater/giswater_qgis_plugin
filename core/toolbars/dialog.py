"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os

from qgis.PyQt.QtWidgets import QAction
from qgis.PyQt.QtGui import QIcon

from ... import global_vars
from ...lib import tools_qgis


class GwAction:

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        self.iface = global_vars.iface
        self.canvas = global_vars.canvas
        self.schema_name = global_vars.schema_name
        self.settings = global_vars.settings
        self.plugin_dir = global_vars.plugin_dir
        self.project_type = global_vars.project_type

        icon = None
        if os.path.exists(icon_path):
            icon = QIcon(icon_path)

        self.action = None
        if icon is None:
            self.action = QAction(text, action_group)
        else:
            self.action = QAction(icon, text, action_group)

        self.action.setObjectName(action_name)
        self.action.setCheckable(False)
        self.action.triggered.connect(self.clicked_event)

        if toolbar is None:
            return

        toolbar.addAction(self.action)


    def clicked_event(self):

        tools_qgis.show_message("Action has no function!!", "INFO")

