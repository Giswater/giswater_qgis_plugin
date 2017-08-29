'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
import os
import sys

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater

from ..ui.plan_estimate_result_new import EstimateResultNew                # @UnresolvedImport
from ..ui.plan_estimate_result_selector import EstimateResultSelector      # @UnresolvedImport

from parent import ParentAction                                 


class Master(ParentAction):
   
    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control Master toolbar actions """           
        # Call ParentAction constructor      
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
    

    def master_estimate_result_new(self):
        """ Button 38: New estimate result """

        # Create dialog 
        self.dlg = EstimateResultNew()

        # Set signals
        self.dlg.btn_calculate.clicked.connect(self.master_estimate_result_new_calculate)
        self.dlg.btn_close.clicked.connect(self.close_dialog)

        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'estimate_result_new')
        self.dlg.exec_()


    def master_estimate_result_new_calculate(self):
        # TODO
        pass


    def master_estimate_result_selector(self):
        """ Button 49: Estimate result selector """

        # Create dialog 
        self.dlg = EstimateResultSelector()

        # Set signals
        self.dlg.btn_accept.clicked.connect(self.master_estimate_result_selector_accept)
        self.dlg.btn_cancel.clicked.connect(self.close_dialog)

        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'estimate_result_selector')
        self.dlg.exec_()


    def master_estimate_result_selector_accept(self):
        # TODO
        pass
    
