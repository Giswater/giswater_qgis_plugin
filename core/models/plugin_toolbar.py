"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-


class PluginToolbar(object):
    """ Keep data related with every toolbar of the plugin """

    def __init__(self, toolbar_id, name, enabled, toolbar=None, list_actions=[]):
        """ 
        :param toolbar: QToolBar
        :param list_actions: list
        """
        self.toolbar_id = toolbar_id
        self.name = name
        self.enabled = enabled
        self.toolbar = toolbar
        self.list_actions = list_actions


