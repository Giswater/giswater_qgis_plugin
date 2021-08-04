"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from ..dialog import GwAction
from ...shared.mincut import GwMincut
from ...ui.ui_manager import GwMincutUi

from .... import global_vars


class GwMincutButton(GwAction):
    """ Button 26: Minuct """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)
        if global_vars.project_type == 'ws':
            self.mincut = GwMincut()


    def clicked_event(self):

        self.mincut.set_dialog(GwMincutUi())
        self.mincut.get_mincut()

