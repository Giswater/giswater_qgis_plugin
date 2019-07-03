"""
/***************************************************************************
        begin                : 2016-01-05
        copyright            : (C) 2016 by BGEO SL
        email                : vicente.medina@gits.ws
        git sha              : $Format:%H$
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

"""
# -*- coding: utf-8 -*-
from qgis.core import QgsFeatureRequest, QgsExpression
from qgis.PyQt.QtCore import Qt

from map_tools.parent import ParentMapTool


class FlowTraceFlowExitMapTool(ParentMapTool):
    """ Button 56: Flow trace
        Button 57: Flow exit
    """    

    def __init__(self, iface, settings, action, index_action):  
        """ Class constructor """
        
        # Call ParentMapTool constructor     
        super(FlowTraceFlowExitMapTool, self).__init__(iface, settings, action, index_action)
        

    """ QgsMapTools inherited event functions """

    def canvasMoveEvent(self, event):

        # Hide marker and get coordinates
        self.vertex_marker.hide()
        event_point = self.snapper_manager.get_event_point(event)

        # Snapping        
        self.current_layer = None
        result = self.snapper_manager.snap_to_background_layers(event_point)
        if self.snapper_manager.result_is_valid():
            layer = self.snapper_manager.get_snapped_layer(result)
            # Check if feature belongs to 'node' group
            exist = self.snapper_manager.check_node_group(layer)
            if exist:
                self.snapper_manager.add_marker(result, self.vertex_marker)
                # Data for function
                self.current_layer = layer
                self.snapped_feat = self.snapper_manager.get_snapped_feature(result)


    def canvasReleaseEvent(self, event):
        """ With left click the digitizing is finished """
        
        if event.button() == Qt.LeftButton and self.current_layer:

            # Execute SQL function
            if self.index_action == '56':
                function_name = "gw_fct_flow_trace"
            else:
                function_name = "gw_fct_flow_exit"
                
            elem_id = self.snapped_feat.attribute('node_id')
            sql = "SELECT " + function_name + "('" + str(elem_id) + "');"
            result = self.controller.execute_sql(sql)
            if result:
                # Get 'arc' and 'node' list and select them
                self.select_features('arc')
                self.select_features('node')

            # Refresh map canvas
            self.refresh_map_canvas()
             
            # Set action pan   
            self.set_action_pan()


    def select_features(self, elem_type):
 
        if self.index_action == '56':
            tablename = "anl_flow_" + elem_type
            where = " WHERE context = 'Flow trace'"
        else:
            tablename = "anl_flow_" + elem_type
            where = " WHERE context = 'Flow exit'"
            
        sql = "SELECT * FROM " + tablename
        sql = sql + where
        sql += " ORDER BY " + elem_type + "_id"
        rows = self.controller.get_rows(sql)
        if not rows:
            return
            
        # Build an expression to select them
        aux = "\""+elem_type+"_id\" IN ("
        for row in rows:            
            aux += "'" + str(row[1]) + "', "
        aux = aux[:-2] + ")"

        # Get a featureIterator from this expression
        expr = QgsExpression(aux)
        if expr.hasParserError():
            message = "Expression Error"
            self.controller.show_warning(message, parameter=expr.parserErrorString())
            return

        # Select features with these id's
        tablename = 'v_edit_' + elem_type
        layer = self.controller.get_layer_by_tablename(tablename)
        if layer:
            it = layer.getFeatures(QgsFeatureRequest(expr))
            # Build a list of feature id's from the previous result
            id_list = [i.id() for i in it]
            # Select features with these id's
            layer.selectByIds(id_list)


    def activate(self):

        # Check button
        self.action().setChecked(True)

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Clear snapping
        self.snapper_manager.enable_snapping()

        # Set snapping to node
        self.snapper_manager.snap_to_node()

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            if self.index_action == '56':
                message = "Select a node and click on it, the upstream nodes are computed"
            else:
                message = "Select a node and click on it, the downstream nodes are computed"
            self.controller.show_info(message)

        # Control current layer (due to QGIS bug in snapping system)
        if self.canvas.currentLayer() is None:
            layer = self.controller.get_layer_by_tablename('v_edit_node')
            if layer:
                self.iface.setActiveLayer(layer)


    def deactivate(self):

        # Call parent method     
        ParentMapTool.deactivate(self)

