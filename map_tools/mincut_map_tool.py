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
from qgis.core import QgsPoint, QgsFeatureRequest, QgsExpression, QgsMapLayer
from qgis.gui import QgsVertexMarker
from PyQt4.QtCore import QPoint, Qt 
from PyQt4.QtGui import QColor

from parent_map_tool import ParentMapTool


class MincutMapTool(ParentMapTool):
    ''' Button 26. User select one node or arc.
    Execute SQL function: 'gw_fct_mincut'
    This function fills 3 temporary tables with id's: node_id, arc_id and valve_id
    Returns and integer: error code
    Get these id's and select them in its corresponding layers '''    

    def __init__(self, iface, settings, action, index_action):  
        ''' Class constructor '''
        
        # Call ParentMapTool constructor     
        super(MincutMapTool, self).__init__(iface, settings, action, index_action)  

        # Vertex marker
        self.vertexMarker = QgsVertexMarker(self.canvas)
        self.vertexMarker.setColor(QColor(255, 25, 25))
        self.vertexMarker.setIconSize(11)
        self.vertexMarker.setIconType(QgsVertexMarker.ICON_BOX) # or ICON_CROSS, ICON_X
        self.vertexMarker.setPenWidth(5)



    ''' QgsMapTools inherited event functions '''

    def canvasMoveEvent(self, event):

        # Hide highlight
        self.vertexMarker.hide()

        # Get the click
        x = event.pos().x()
        y = event.pos().y()
        eventPoint = QPoint(x,y)

        # Snapping        
        (retval,result) = self.snapper.snapToBackgroundLayers(eventPoint)   #@UnusedVariable   
        self.current_layer = None

        # That's the snapped point
        if result <> []:

            # Check Arc or Node
            for snapPoint in result:

                if snapPoint.layer.name() == self.layer_node.name() or snapPoint.layer.name() == self.layer_arc.name():
                    
                    # Get the point
                    point = QgsPoint(result[0].snappedVertex)

                    # Add marker
                    self.vertexMarker.setCenter(point)
                    self.vertexMarker.show()

                    # Data for function
                    self.current_layer = result[0].layer
                    self.snappFeat = next(result[0].layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))

                    # Change symbol
                    if snapPoint.layer.name() == self.layer_node.name():
                        self.vertexMarker.setIconType(QgsVertexMarker.ICON_CIRCLE)
                    else:
                        self.vertexMarker.setIconType(QgsVertexMarker.ICON_BOX)

                    break


    def canvasReleaseEvent(self, event):
        ''' With left click the digitizing is finished '''
        
        if event.button() == Qt.LeftButton and self.current_layer is not None:

            # Get selected layer type: 'arc' or 'node'
            if self.current_layer.name() == self.layer_arc.name():
                elem_type = 'arc'
            elif self.current_layer.name() == self.layer_node.name():
                elem_type = 'node'
            else:
                message = "Current layer not valid"
                self.controller.show_warning(message, context_name='ui_message')
                return

            feature = self.snappFeat
            elem_id = feature.attribute(elem_type+'_id')

            # Execute SQL function
            function_name = "gw_fct_mincut"
            sql = "SELECT "+self.schema_name+"."+function_name+"('"+str(elem_id)+"', '"+elem_type+"');"
            result = self.controller.execute_sql(sql)
            print sql
            if result:
                # Get 'arc' and 'node' list and select them
                self.mg_flow_trace_select_features(self.layer_arc, 'arc')
                self.mg_flow_trace_select_features(self.layer_node, 'node')

            # Refresh map canvas
            self.iface.mapCanvas().refresh()


    def mg_flow_trace_select_features(self, layer, elem_type):

        sql = "SELECT * FROM "+self.schema_name+".anl_mincut_"+elem_type+" ORDER BY "+elem_type+"_id"
        rows = self.controller.get_rows(sql)
        if rows:
    
            # Build an expression to select them
            aux = "\""+elem_type+"_id\" IN ("
            for elem in rows:
                aux += elem[0] + ", "
            aux = aux[:-2] + ")"
    
            # Get a featureIterator from this expression:
            expr = QgsExpression(aux)
            if expr.hasParserError():
                message = "Expression Error: " + str(expr.parserErrorString())
                self.controller.show_warning(message, context_name='ui_message')
                return
            it = layer.getFeatures(QgsFeatureRequest(expr))
    
            # Build a list of feature id's from the previous result
            id_list = [i.id() for i in it]
    
            # Select features with these id's
            layer.setSelectedFeatures(id_list)


    def activate(self):

        # Check button
        self.action().setChecked(True)

        # Store user snapping configuration
        self.snapperManager.storeSnappingOptions()

        # Clear snapping
        self.snapperManager.clearSnapping()

        # Set snapping to arc and node
        self.snapperManager.snapToArc()
        self.snapperManager.snapToNode()

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Select a node or pipe and click on it, the valves minimum cut polygon is computed"
            self.controller.show_info(message, context_name='ui_message' )  
        # Control current layer (due to QGIS bug in snapping system)
        try:
            if self.canvas.currentLayer().type() == QgsMapLayer.VectorLayer:
                self.canvas.setCurrentLayer(self.layer_arc)
        except:
            self.canvas.setCurrentLayer(self.layer_arc)


    def deactivate(self):

        # Check button
        self.action().setChecked(False)

        # Restore previous snapping
        self.snapperManager.recoverSnappingOptions()

        # Recover cursor
        self.canvas.setCursor(self.stdCursor)

        # Remove highlight
        self.h = None
        
        