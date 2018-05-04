# -*- coding: utf-8 -*-


class PluginToolbar():
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
              
        