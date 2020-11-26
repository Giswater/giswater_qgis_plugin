"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from ..parent_dialog import GwParentAction
from ...load_project_check import GwProjectCheck


class GwProjectCheckButton(GwParentAction):

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        super().__init__(icon_path, action_name, text, toolbar, action_group)


    def clicked_event(self):

        # Return layers in the same order as listed in TOC
        layers = tools_qgis.get_project_layers()

        check_project_result = GwProjectCheck()
        check_project_result.populate_audit_check_project(layers, "false")
