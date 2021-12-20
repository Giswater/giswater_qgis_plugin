"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtWidgets import QDockWidget

from ..dialog import GwAction
from ...ui.ui_manager import GwSearchUi
from ...shared.search import GwSearch


class GwSearchButton(GwAction):
    """ Button 143: Search """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        super().__init__(icon_path, action_name, text, toolbar, action_group)

        self.search = GwSearch()


    def clicked_event(self):
        # Get 'Search' docker form from qgis iface and remove it if exists
        dockers_search = self.iface.mainWindow().findChildren(QDockWidget, 'dlg_search')
        if dockers_search:
            for docker_search in dockers_search:
                self.iface.removeDockWidget(docker_search)
                docker_search.deleteLater()

        dlg_search = GwSearchUi()
        self.search.open_search(dlg_search)
