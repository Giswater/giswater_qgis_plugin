"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from functools import partial
from qgis.core import QgsPoint, QgsFeatureRequest, QgsExpression
from PyQt4.QtCore import QPoint, Qt
from PyQt4.Qt import QDate
from datetime import datetime
import utils_giswater
from map_tools.parent import ParentMapTool

from ..ui.node_replace import Node_replace             # @UnresolvedImport


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
        dlg_nodereplace.btn_accept.pressed.connect(partial(self.get_values, dlg_nodereplace))
        dlg_nodereplace.btn_cancel.pressed.connect(dlg_nodereplace.close)
        sql = 'SELECT value FROM ' + self.schema_name + '.config_param_user'
        sql += ' WHERE "cur_user" = current_user AND parameter = ' + "'workcat_vdefault'"
        row = self.controller.get_row(sql)
        if row:
            dlg_nodereplace.workcat_id_end.setText(row[0])
            self.workcat_id_end_aux = row[0]
        
        sql = 'SELECT value FROM ' + self.schema_name + '.config_param_user'
        sql += ' WHERE "cur_user" = current_user AND parameter = ' + "'enddate_vdefault'"
        row = self.controller.get_row(sql)
        if row:
            self.enddate_aux = datetime.strptime(row[0], '%Y-%m-%d').date()
        else:
            self.enddate_aux = QDate.currentDate().date()
        dlg_nodereplace.enddate.setDate(self.enddate_aux)

        dlg_nodereplace.exec_()
        
    def get_values(self, dialog):
        self.workcat_id_end_aux = utils_giswater.getWidgetText(dialog.workcat_id_end)
        self.enddate_aux = dialog.enddate.date().toString('yyyy-MM-dd')
        dialog.close()


    ''' QgsMapTools inherited event functions '''

    def canvasMoveEvent(self, event):
        
        # Hide marker
        self.vertex_marker.hide()

        # Get the click
        x = event.pos().x()
        y = event.pos().y()

        # Plugin reloader bug, MapTool should be deactivated
        try:
            event_point = QPoint(x, y)
        except(TypeError, KeyError):
            self.iface.actionPan().trigger()
            return

        # Snapping
        (retval, result) = self.snapper.snapToBackgroundLayers(event_point)  # @UnusedVariable

        # That's the snapped point
        if result:
            # Check for nodes
            for snapped_feat in result:
                exist = self.snapper_manager.check_node_group(snapped_feat.layer)
                if exist:
                    # Get the point and add marker
                    point = QgsPoint(result[0].snappedVertex)
                    self.vertex_marker.setCenter(point)
                    self.vertex_marker.show()
                    break


    def canvasReleaseEvent(self, event):

        # With left click the digitizing is finished
        if event.button() == Qt.LeftButton:

            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            event_point = QPoint(x, y)
            feature = None

            # Snapping
            (retval, result) = self.snapper.snapToBackgroundLayers(event_point)  # @UnusedVariable

            # That's the snapped features
            if result:
                for snapped_feat in result:
                    # Check if feature belongs to 'node' group                  
                    exist = self.snapper_manager.check_node_group(snapped_feat.layer)
                    if exist:
                        # Get the point
                        point = QgsPoint(result[0].snappedVertex)  # @UnusedVariable
                        feature = next(result[0].layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))
                        result[0].layer.select([result[0].snappedAtGeometry])
                        break

            if feature is not None:

                # Get selected features and layer type: 'node'
                node_id = feature.attribute('node_id')

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
                        self.open_custom_form(new_node_id)
                    else:
                        message = "Error replacing node"
                        self.controller.show_warning(message)                        
    
                    # Refresh map canvas
                    self.refresh_map_canvas()


    def open_custom_form(self, new_node_id):
        """ Open custom form from selected layer """
        
        # get pointer of node by ID
        aux = "node_id = "
        aux += "'" + str(new_node_id[0]) + "'"
        expr = QgsExpression(aux)
        if expr.hasParserError():
            message = "Expression Error: " + str(expr.parserErrorString())
            self.controller.show_warning(message)
            return

        # Get a featureIterator from this expression:
        it = self.canvas.currentLayer().getFeatures(QgsFeatureRequest(expr))
        id_list = [i for i in it]
        if id_list != []:
            self.iface.openFeatureForm(self.canvas.currentLayer(), id_list[0])


    def activate(self):

        # Check button
        self.action().setChecked(True)

        self.init_replace_node_form()

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Clear snapping
        self.snapper_manager.clear_snapping()

        # Set snapping to node
        self.snapper_manager.snap_to_node()

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Select the node inside a pipe by clicking on it and it will be replaced"
            self.controller.show_info(message)

        # Control current layer (due to QGIS bug in snapping system)
        if self.canvas.currentLayer() == None:
            self.iface.setActiveLayer(self.layer_node_man[0])


    def deactivate(self):
          
        # Call parent method     
        ParentMapTool.deactivate(self)
    
