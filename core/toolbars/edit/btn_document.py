"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from ..parent_dialog import GwParentAction
from ...actions.document import GwDocument


class GwAddDocumentButton(GwParentAction):
    def __init__(self, icon_path, text, toolbar, action_group):
        super().__init__(icon_path, text, toolbar, action_group)

        self.document = GwDocument()


    def clicked_event(self):
        self.document.manage_document()
