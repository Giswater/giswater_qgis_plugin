"""This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from ...shared.flow import GwFlow


class GwFlowTraceButton(GwFlow):
    """Button 13: Flow trace"""

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.help_message = "Click on node to compute its upstream network"

    def canvasReleaseEvent(self, event):
        self._set_flow(event, "gw_fct_graphanalytics_upstream")
