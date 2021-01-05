"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from ..dialog_button import GwDialogButton
from ...shared.go2epa import GwGo2Epa


class GwGo2EpaButton(GwDialogButton):

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.go2epa = GwGo2Epa()


    def clicked_event(self):
        self.go2epa.go2epa()

