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
from qgis.core import QgsPoint, QgsFeatureRequest, QgsExpression
from qgis.gui import QgsVertexMarker
from PyQt4.QtCore import QPoint, Qt 
from PyQt4.QtGui import QColor

from map_tools.parent import ParentMapTool


class FlowTraceFlowExitMapTool(ParentMapTool):
    """ Button 56: Flow trace
        Button 57: Flow exit
    """    

    def __init__(self, iface, settings, action, index_action):  
        """ Class constructor """
        
        # Call ParentMapTool constructor     
        super(FlowTraceFlowExitMapTool, self).__init__(iface, settings, action, index_action)

        # Vertex marker
        self.vertex_marker = QgsVertexMarker(self.canvas)
        self.vertex_marker.setColor(QColor(255, 25, 25))
        self.vertex_marker.setIconSize(11)
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_BOX) # or ICON_CROSS, ICON_X
        self.vertex_marker.setPenWidth(5)


    """ QgsMapTools inherited event functions """

    def canvasMoveEvent(self, event):

        # Hide highlight
        self.vertex_marker.hide()

        # Get the click
        x = event.pos().x()
        y = event.pos().y()

        #Plugin reloader bug, MapTool should be deactivated
        try:
            eventPoint = QPoint(x, y)
        except(TypeError, KeyError):
            self.iface.actionPan().trigger()
            return

        # Snapping        
        (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)   #@UnusedVariable   
        self.current_layer = None

        # That's the snapped point
        if result <> []:

            # Check Arc or Node
            for snapped_feat in result:

                exist = self.snapper_manager.check_node_group(snapped_feat.layer)
                if exist:
                    
                    # Get the point
                    point = QgsPoint(snapped_feat.snappedVertex)

                    # Add marker
                    self.vertex_marker.setCenter(point)
                    self.vertex_marker.show()

                    # Data for function
                    self.current_layer = snapped_feat.layer
                    self.snapped_feat = next(snapped_feat.layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))

                    # Change symbol
                    self.vertex_marker.setIconType(QgsVertexMarker.ICON_CIRCLE)

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
            sql = "SELECT "+self.schema_name+"."+function_name+"('"+str(elem_id)+"');"
            result = self.controller.execute_sql(sql)
            if result:
                # Get 'arc' and 'node' list and select them
                self.select_features(self.layer_arc_man, 'arc')
                self.select_features(self.layer_node_man, 'node')

            # Refresh map canvas
            self.iface.mapCanvas().refreshAllLayers()

            for layer_refresh in self.iface.mapCanvas().layers():
                layer_refresh.triggerRepaint()


    def select_features(self, layer_group, elem_type):

        if self.index_action == '56':
            tablename = "anl_flow_trace_"+elem_type
        else:
            tablename = "anl_flow_exit_"+elem_type
            
        sql = "SELECT * FROM " + self.schema_name + "." + tablename + " ORDER BY "+elem_type+"_id"
        rows = self.controller.get_rows(sql)
        if not rows:
            return
            
        # Build an expression to select them
        aux = "\""+elem_type+"_id\" IN ("
        for elem in rows:
            aux += "'" + elem[0] + "', "
        aux = aux[:-2] + ")"

        # Get a featureIterator from this expression:
        expr = QgsExpression(aux)
        if expr.hasParserError():
            message = "Expression Error: " + str(expr.parserErrorString())
            self.controller.show_warning(message, context_name='ui_message')
            return

        # Select features with these id's
        for layer in layer_group:

            it = layer.getFeatures(QgsFeatureRequest(expr))

            # Build a list of feature id's from the previous result
            id_list = [i.id() for i in it]

            # Select features with these id's
            layer.setSelectedFeatures(id_list)


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

            self.controller.show_info(message, context_name='ui_message' )

        # Control current layer (due to QGIS bug in snapping system)
        if self.canvas.currentLayer() == None:
            self.iface.setActiveLayer(self.layer_node_man[0])


    def deactivate(self):

        # Call parent method     
        ParentMapTool.deactivate(self)
                
        