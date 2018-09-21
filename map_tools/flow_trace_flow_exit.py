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
try:
    from qgis.core import Qgis
except:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT >= 20000 and Qgis.QGIS_VERSION_INT < 29900:
    from PyQt4.QtCore import QPoint, Qt
else:
    from qgis.PyQt.QtCore import QPoint, Qt
    
from qgis.core import QgsPoint, QgsFeatureRequest, QgsExpression

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

        # Hide highlight
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
        (retval, result) = self.snapper.snapToBackgroundLayers(event_point)   #@UnusedVariable   
        self.current_layer = None

        # That's the snapped features
        if result:
            for snapped_feat in result:
                # Check if feature belongs to 'node' group
                exist = self.snapper_manager.check_node_group(snapped_feat.layer)
                if exist:
                    # Get the point and set marker
                    point = QgsPoint(snapped_feat.snappedVertex)
                    self.vertex_marker.setCenter(point)
                    self.vertex_marker.show()
                    # Data for function
                    self.current_layer = snapped_feat.layer
                    self.snapped_feat = next(snapped_feat.layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))
                    break


    def canvasReleaseEvent(self, event):
        """ With left click the digitizing is finished """
        
        if event.button() == Qt.LeftButton and self.current_layer is not None:

            # Execute SQL function
            if self.index_action == '56':
                function_name = "gw_fct_flow_trace"
            else:
                function_name = "gw_fct_flow_exit"
                
            elem_id = self.snapped_feat.attribute('node_id')
            sql = "SELECT " + self.schema_name + "." + function_name + "('" + str(elem_id) + "');"
            result = self.controller.execute_sql(sql)
            if result:
                # Get 'arc' and 'node' list and select them
                self.select_features(self.layer_arc_man, 'arc')
                self.select_features(self.layer_node_man, 'node')

            # Refresh map canvas
            self.refresh_map_canvas()
             
            # Set action pan   
            self.set_action_pan()


    def select_features(self, layer_group, elem_type):
 
        if self.index_action == '56':
            tablename = "anl_flow_"+elem_type
            where = " WHERE context = 'Flow trace'"
        else:
            tablename = "anl_flow_"+elem_type
            where = " WHERE context = 'Flow exit'"
            
        sql = "SELECT * FROM " + self.schema_name + "." + tablename
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
        for layer in layer_group:
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
        self.snapper_manager.clear_snapping()

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
            self.iface.setActiveLayer(self.layer_node_man[0])


    def deactivate(self):

        # Call parent method     
        ParentMapTool.deactivate(self)

