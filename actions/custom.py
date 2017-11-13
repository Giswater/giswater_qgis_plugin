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
import utils_giswater    

from ..ui.selector_date import SelectorDate         # @UnresolvedImport
from ..ui.ud_om_add_visit_file import AddVisitFile  # @UnresolvedImport
from parent import ParentAction


class Custom(ParentAction):
   
    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control Management toolbar actions """  
                  
        # Call ParentAction constructor      
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
                

    def custom_selector_date(self):
        """ TODO: Button 91. Selector date """
        
        self.controller.log_info("custom_selector_date") 
    
    
    def custom_import_visit_csv(self):
        """ TODO: Button 92. Import visit from CSV file """
        
        self.controller.log_info("custom_import_visit_csv") 
        
        