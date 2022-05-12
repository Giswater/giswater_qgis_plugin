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


class GwNonVisualManagerButton(GwAction):
    """ Button 218: Non visual objects manager """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        super().__init__(icon_path, action_name, text, toolbar, action_group)

        self.nonvisual = GwNonVisual()


    def clicked_event(self):
        self.nonvisual.manage_nonvisual()
