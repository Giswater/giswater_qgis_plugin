"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from ..parent_action import GwParentAction
from ...project_check import GwProjectCheck


class GwProjectCheckButton(GwParentAction):
    def __init__(self, icon_path, text, toolbar, action_group):
        super().__init__(icon_path, text, toolbar, action_group)


    def clicked_event(self):

        # Return layers in the same order as listed in TOC
        layers = self.controller.get_layers()

        check_project_result = GwProjectCheck()
        check_project_result.populate_audit_check_project(layers, "false")
