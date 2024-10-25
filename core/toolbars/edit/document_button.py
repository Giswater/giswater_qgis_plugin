"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from ..dialog import GwAction
from ...shared.document import GwDocument


class GwDocumentButton(GwAction):
    """ Button 34: Document """

    def __init__(self, icon_path, action_name, text, toolbar, action_group, list_tabs=None, doc_tables=None, feature_type=None):
        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.list_tabs = list_tabs if list_tabs else ["node", "arc", "connec", "gully"]
        self.doc_tables = doc_tables if doc_tables else ["doc_x_node", "doc_x_arc", "doc_x_connec", "doc_x_gully", "doc_x_workcat", "doc_x_psector", "doc_x_visit"]
        self.feature_type = feature_type
        self.document = GwDocument()


    def clicked_event(self):
        self.document.get_document(list_tabs=self.list_tabs, doc_tables=self.doc_tables, feature_type=self.feature_type)

