"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
import os
import sys

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)

from parent import ParentAction


class Om(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'om_ws' """
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)


    def set_project_type(self, project_type):     
        self.project_type = project_type


    def om_add_visit(self):
        """ Button 64: Add visit """
        # TODO:
        self.controller.log_info("om_add_visit")        
        if self.project_type == 'ws':
            self.controller.log_info("Execute 'om_ws_add_visit'")
        else:
            self.controller.log_info("Execute 'om_ud_add_visit'")


    def om_visit_management(self):
        """ Button 65: Visit management """
        # TODO:
        self.controller.log_info("om_visit_management")        
        
