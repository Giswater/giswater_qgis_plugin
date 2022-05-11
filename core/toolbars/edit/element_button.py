"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from ..dialog import GwAction
from ...shared.element import GwElement


class GwElementButton(GwAction):
    """ Button 33: Element """

    def __init__(self, icon_path, action_name, text, toolbar, action_group, list_tabs=None):
        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.list_tabs = list_tabs if list_tabs else ["node", "arc", "connec", "gully"]
        self.element = GwElement()


    def clicked_event(self):
        self.element.get_element(list_tabs=self.list_tabs)
