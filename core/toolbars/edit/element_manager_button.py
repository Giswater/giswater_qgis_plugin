"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from ..dialog import GwAction
from ...shared.element import GwElement


class GwElementManagerButton(GwAction):
    """ Button 67: Element Manager """

    def __init__(self, icon_path, action_name, text, toolbar, action_group, list_tabs=None ,feature_type=None, list_element=None):
        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.list_tabs = list_tabs if list_tabs else ["node", "arc", "connec", "gully"]
        self.list_element = list_element if list_element else ["node", "arc", "connec"]
        self.feature_type = feature_type
        self.element = GwElement()
        self.element.list_tabs = self.list_tabs
        self.element.feature_type = self.feature_type
        self.element.list_element = self.list_element



    def clicked_event(self):
        self.element.manage_elements()
