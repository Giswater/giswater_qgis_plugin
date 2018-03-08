"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from qgis.core import QgsPoint, QgsFeatureRequest
from PyQt4.QtCore import QPoint, Qt
from PyQt4.Qt import QDate

import os
import sys
from functools import partial
from datetime import datetime

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater
from map_tools.parent import ParentMapTool
from ui.node_replace import Node_replace


class ReplaceNodeMapTool(ParentMapTool):
    ''' Button 44: User select one node. Execute SQL function: 'gw_fct_node_replace' '''

    def __init__(self, iface, settings, action, index_action):
        ''' Class constructor '''

        # Call ParentMapTool constructor
        super(ReplaceNodeMapTool, self).__init__(iface, settings, action, index_action)


    def init_replace_node_form(self):
        
        # Create the dialog and signals
        dlg_nodereplace = Node_replace()
        utils_giswater.setDialog(dlg_nodereplace)
        self.load_settings(dlg_nodereplace)
        dlg_nodereplace.btn_accept.pressed.connect(partial(self.get_values, dlg_nodereplace))
        dlg_nodereplace.btn_cancel.pressed.connect(partial(self.close_dlg, dlg_nodereplace))

        sql = ("SELECT id FROM " + self.schema_name + ".cat_work ORDER BY id")
        rows = self.controller.get_rows(sql)
        if rows:
            utils_giswater.fillComboBox(dlg_nodereplace.workcat_id_end, rows)
            utils_giswater.set_autocompleter(dlg_nodereplace.workcat_id_end)

        sql = ("SELECT value FROM " + self.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND parameter = 'workcat_vdefault'")
        row = self.controller.get_row(sql)
        if row:
            dlg_nodereplace.workcat_id_end.setCurrentIndex(dlg_nodereplace.workcat_id_end.findText(row[0]))

        sql = ("SELECT value FROM " + self.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND parameter = 'enddate_vdefault'")
        row = self.controller.get_row(sql)
        if row:
            self.enddate_aux = datetime.strptime(row[0], '%Y-%m-%d').date()
        else:
            self.enddate_aux = datetime.strptime(QDate.currentDate().toString('yyyy-MM-dd'), '%Y-%m-%d').date()

        dlg_nodereplace.enddate.setDate(self.enddate_aux)

        dlg_nodereplace.exec_()
        
        
    def get_values(self, dialog):
        
        self.workcat_id_end_aux = utils_giswater.getWidgetText(dialog.workcat_id_end)
        self.enddate_aux = dialog.enddate.date().toString('yyyy-MM-dd')
        self.close_dlg(dialog)


    def close_dlg(self, dlg=None):
        """ Close dialog """

        try:
            self.save_settings(dlg)
            dlg.close()
            # Deactivate map tool
            self.deactivate()
            self.set_action_pan()
        except AttributeError:
            pass


    ''' QgsMapTools inherited event functions '''

    def keyPressEvent(self, event):
        if event.key() == Qt.Key_Escape:
            self.cancel_map_tool()
            return


    def canvasReleaseEvent(self, event):
        
        if event.button() == Qt.RightButton:
            self.cancel_map_tool()
            return

        # Get the click
        x = event.pos().x()
        y = event.pos().y()
        event_point = QPoint(x, y)
        snapped_feat = None

        # Snapping
        (retval, result) = self.snapper.snapToCurrentLayer(event_point, 2)  # @UnusedVariable
                
        if result:
            # Get the first feature
            snapped_feat = result[0]
            point = QgsPoint(snapped_feat.snappedVertex)   #@UnusedVariable
            snapped_feat = next(snapped_feat.layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))                

        if snapped_feat:

            # Get 'node_id' and 'nodetype'
            node_id = snapped_feat.attribute('node_id')
            if self.project_type == 'ws':
                nodetype_id = snapped_feat.attribute('nodetype_id')
            elif self.project_type == 'ud':
                nodetype_id = snapped_feat.attribute('node_type')
            layer = self.controller.get_layer_by_nodetype(nodetype_id, log_info=True) 
            if not layer:
                return       

            # Ask question before executing
            message = "Are you sure you want to replace selected node with a new one?"
            answer = self.controller.ask_question(message, "Replace node")
            if answer:
                # Execute SQL function and show result to the user
                function_name = "gw_fct_node_replace"
                sql = ("SELECT " + self.schema_name + "." + function_name + "('"
                       + str(node_id) + "', '" + self.workcat_id_end_aux + "', '" + str(self.enddate_aux) + "', '"
                       + str(utils_giswater.isChecked("keep_elements")) + "');")
                new_node_id = self.controller.get_row(sql, commit=True)
                if new_node_id:
                    message = "Node replaced successfully"
                    self.controller.show_info(message)
                    self.iface.setActiveLayer(layer)                 
                    self.force_active_layer = False                    
                    self.open_custom_form(layer, new_node_id)
                else:
                    message = "Error replacing node"
                    self.controller.show_warning(message)                        

                # Refresh map canvas
                self.refresh_map_canvas()
                
        
            # Deactivate map tool
            self.deactivate()
            self.set_action_pan()                


    def open_custom_form(self, layer, node_id):
        """ Open custom form from selected @layer and @node_id """
                                
        # Get feature with selected node_id
        expr_filter = "node_id = "
        expr_filter += "'" + str(node_id[0]) + "'"
        (is_valid, expr) = self.check_expression(expr_filter, True)   #@UnusedVariable       
        if not is_valid:
            return     
  
        # Get a featureIterator from this expression:     
        it = layer.getFeatures(QgsFeatureRequest(expr))
        id_list = [i for i in it]
        if id_list:
            self.iface.openFeatureForm(layer, id_list[0])


    def activate(self):

        # Check button
        self.action().setChecked(True)

        self.init_replace_node_form()

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Clear snapping
        self.snapper_manager.clear_snapping()

        # Set active layer to 'v_edit_node'
        self.layer_node = self.controller.get_layer_by_tablename("v_edit_node")
        self.iface.setActiveLayer(self.layer_node)   
        self.force_active_layer = True           

        # Change cursor
        self.canvas.setCursor(self.cursor)
        
        self.project_type = self.controller.get_project_type()         

        # Show help message when action is activated
        if self.show_help:
            message = "Select the node inside a pipe by clicking on it and it will be replaced"
            self.controller.show_info(message)


    def deactivate(self):
          
        # Call parent method     
        ParentMapTool.deactivate(self)
    
