"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from .parent import ParentAction


class Custom(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'custom' """
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)


    def set_project_type(self, project_type):
        self.project_type = project_type


    def custom_test_function(self):
        """ Button xx: """
        self.controller.log_info("custom_test_function")

