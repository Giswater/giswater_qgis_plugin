"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
import os
import sys

from PyQt4.QtGui import QComboBox, QLineEdit, QDoubleValidator


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
        self.result_id = self.dlg.findChild(QComboBox, "result_id")
        self.text_prices_coeficient = self.dlg.findChild(QLineEdit, "text_prices_coeficient")
        self.text_prices_coeficient.setValidator(QDoubleValidator())
        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'estimate_result_new')

        sql = "SELECT result_id FROM "+self.schema_name+".rpt_cat_result ORDER BY result_id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("result_id", rows, False)
        self.dlg.exec_()


    def master_estimate_result_new_calculate(self):
        """ Call function ws30.gw_fct_plan_estimate_result """

        # TODO revisar tablas
        sql = "SELECT ws30.gw_fct_plan_estimate_result('" + utils_giswater.getWidgetText(self.result_id) + "', '"+utils_giswater.getWidgetText(self.text_prices_coeficient) + "')"
        status = self.controller.execute_sql(sql)
        if status:
            message = "Values has been updated"
            self.controller.show_info(message, context_name='ui_message')
            self.iface.mapCanvas().refreshAllLayers()
        pass


    def master_estimate_result_selector(self):
        """ Button 49: Estimate result selector """

        # Create dialog 
        self.dlg = EstimateResultSelector()
        utils_giswater.setDialog(self.dlg)
        # Set signals
        self.dlg.btn_accept.clicked.connect(self.master_estimate_result_selector_accept)
        self.dlg.btn_cancel.clicked.connect(self.close_dialog)
        self.rpt_selector_result_id = self.dlg.findChild(QComboBox, "rpt_selector_result_id")

        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'estimate_result_selector')
        # TODO revisar tablas
        sql = "SELECT result_id FROM "+self.schema_name+".plan_selector_result WHERE cur_user = current_user ORDER BY result_id "
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.rpt_selector_result_id, rows, False)

        self.dlg.exec_()


    def master_estimate_result_selector_accept(self):
        # TODO
        self.iface.mapCanvas().refreshAllLayers()
        pass

