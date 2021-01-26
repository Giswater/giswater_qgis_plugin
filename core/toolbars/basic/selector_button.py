"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from ..dialog import GwAction
from ...shared.selector import GwSelector
from ....core.utils import tools_gw


class GwSelectorButton(GwAction):

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        super().__init__(icon_path, action_name, text, toolbar, action_group)

    def clicked_event(self):

        selector_type = '"selector_basic"'

        # Show form in docker?
        tools_gw.init_docker('qgis_form_docker')
        selector = GwSelector()
        selector.open_selector(selector_type)
