"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
import os
import sys

from PyQt4.QtGui import QDoubleValidator


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
        utils_giswater.setDialog(self.dlg)
        
        # Set signals
        self.dlg.btn_calculate.clicked.connect(self.master_estimate_result_new_calculate)
        self.dlg.btn_close.clicked.connect(self.close_dialog)
        self.dlg.text_prices_coeficient.setValidator(QDoubleValidator())

        # Fill combo box
        sql = "SELECT result_id FROM "+self.schema_name+".rpt_cat_result ORDER BY result_id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("result_id", rows, False)
        
        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'estimate_result_new')
        self.dlg.exec_()


    def master_estimate_result_new_calculate(self):
        """ Execute function 'gw_fct_plan_estimate_result' """

        # Get values from form
        result_id = utils_giswater.getWidgetText("result_id")
        coefficient = utils_giswater.getWidgetText("text_prices_coeficient")
        if coefficient == 'null':
            message = "Please, introduce a coefficient value"
            self.controller.show_warning(message, context_name='ui_message')  
            return          
        
        # Execute function 'gw_fct_plan_estimate_result'
        sql = "SELECT "+self.schema_name+".gw_fct_plan_estimate_result('" + result_id + "', " + coefficient + ")"
        status = self.controller.execute_sql(sql)
        if status:
            message = "Values has been updated"
            self.controller.show_info(message, context_name='ui_message')
        
        # Refresh canvas
        self.iface.mapCanvas().refreshAllLayers()


    def master_estimate_result_selector(self):
        """ Button 49: Estimate result selector """

        # Create dialog 
        self.dlg = EstimateResultSelector()
        utils_giswater.setDialog(self.dlg)
        
        # Set signals
        self.dlg.btn_accept.clicked.connect(self.master_estimate_result_selector_accept)
        self.dlg.btn_cancel.clicked.connect(self.close_dialog)

        # Fill combo box
        sql = "SELECT result_id FROM "+self.schema_name+".plan_result_cat "
        sql += " WHERE cur_user = current_user ORDER BY result_id"
        rows = self.controller.get_rows(sql)
        if not rows:
            return
        
        utils_giswater.fillComboBox("rpt_selector_result_id", rows, False)
        
        # Get selected value from table 'plan_selector_result'
        sql = "SELECT result_id FROM "+self.schema_name+".plan_selector_result"
        sql += " WHERE cur_user = current_user"   
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setSelectedItem("rpt_selector_result_id", str(row[0]))
        elif row is None and self.controller.last_error:           
            return
            
        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'estimate_result_selector')
        self.dlg.exec_()


    def master_estimate_result_selector_accept(self):
        """ Update value of table 'plan_selector_result' """
    
        # Get selected value and upsert the table
        result_id = utils_giswater.getWidgetText("rpt_selector_result_id")
        sql = " INSERT INTO "+self.schema_name+".plan_selector_result (result_id, cur_user) VALUES ("
        sql += "'" + result_id + "', current_user)"
        sql += " ON CONFLICT (cur_user) DO UPDATE"
        sql += " SET result_id = '" + result_id + "'"
        sql += " WHERE plan_selector_result.cur_user = current_user"
        self.controller.log_info(sql)
        status = self.controller.execute_sql(sql)
        if status:
            message = "Values has been updated"
            self.controller.show_info(message, context_name='ui_message')        
        
        # Refresh canvas
        self.iface.mapCanvas().refreshAllLayers()
        

