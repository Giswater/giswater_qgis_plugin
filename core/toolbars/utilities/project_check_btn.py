"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from ..dialog import GwAction
from ...load_project_check import GwLoadProjectCheck

from ....lib import tools_qgis


class GwProjectCheckButton(GwAction):
    """ Button 59: Check project """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)


    def clicked_event(self):

        self._open_check_project()


    # region private functions

    def _open_check_project(self):

        # Return layers in the same order as listed in TOC
        layers = tools_qgis.get_project_layers()

        check_project_result = GwLoadProjectCheck()
        check_project_result.fill_check_project_table(layers, "false")

    # endregion