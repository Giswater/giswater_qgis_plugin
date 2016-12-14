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
from qgis.core import QGis, QgsPoint, QgsMapToPixel, QgsMapLayer
from qgis.gui import QgsRubberBand, QgsVertexMarker
from PyQt4.QtCore import QPoint, Qt
from PyQt4.QtGui import QColor, QCursor

from map_tools.parent import ParentMapTool


class MoveNodeMapTool(ParentMapTool):
    ''' Button 16. Move node
    Execute SQL function: 'gw_fct_node2arc' '''        

    def __init__(self, iface, settings, action, index_action, controller, srid):
        ''' Class constructor '''        
        
        # Call ParentMapTool constructor     
        super(MoveNodeMapTool, self).__init__(iface, settings, action, index_action)  
        self.controller = controller
        self.srid = srid  

        # Vertex marker
        self.vertexMarker = QgsVertexMarker(self.canvas)
        self.vertexMarker.setColor(QColor(0, 255, 0))
        self.vertexMarker.setIconSize(9)
        self.vertexMarker.setIconType(QgsVertexMarker.ICON_BOX) # or ICON_CROSS, ICON_X
        self.vertexMarker.setPenWidth(5)
   
        # Rubber band
        self.rubberBand = QgsRubberBand(self.canvas, QGis.Line)
        mFillColor = QColor(255, 0, 0);
        self.rubberBand.setColor(mFillColor)
        self.rubberBand.setWidth(3)           
        self.reset()     
        
        ################################
        #--------------------------------
        self.layer_node=self.set_node_layer()
        #--------------------------------
        ##################################   


    def reset(self):
                
        # Clear selected features 
        layer = self.canvas.currentLayer()
        if layer is not None:
            layer.removeSelection()

        # Graphic elements
        self.rubberBand.reset()
          
            
    def move_node(self, node_id, point):
        ''' Move selected node to the current point '''  
           
        if self.srid is None:
            self.srid = self.controller.plugin_settings_value('srid')  
        if self.schema_name is None:
            self.schema_name = self.controller.plugin_settings_value('schema_name')               
                   
        # Update node geometry
        the_geom = "ST_GeomFromText('POINT("+str(point.x())+" "+str(point.y())+")', "+str(self.srid)+")";
        sql = "UPDATE "+self.schema_name+".node SET the_geom = "+the_geom
        sql+= " WHERE node_id = '"+node_id+"'"
        status = self.controller.execute_sql(sql) 
        if status:
            # Execute SQL function and show result to the user
            function_name = "gw_fct_node2arc"
            sql = "SELECT "+self.schema_name+"."+function_name+"('"+str(node_id)+"');"
            self.controller.execute_sql(sql)
        else:
            message = "Move node: Error updating geometry"
            self.controller.show_warning(message, context_name='ui_message')
            
        # Refresh map canvas
        self.canvas.currentLayer().triggerRepaint()  

                
    
    ''' QgsMapTool inherited event functions '''    
       
    def activate(self):
        ''' Called when set as currently active map tool '''

        # Check button
        self.action().setChecked(True)

        # Store user snapping configuration
        self.snapperManager.storeSnappingOptions()

        # Clear snapping
        self.snapperManager.clearSnapping()

        # Set snapping to node
        self.snapperManager.snapToNode()
        self.snapperManager.snapToArc()

        # Change pointer
        cursor = QCursor()
        cursor.setShape(Qt.CrossCursor)

        # Get default cursor        
        self.stdCursor = self.parent().cursor()   
 
        # And finally we set the mapTool's parent cursor
        self.parent().setCursor(cursor)

        # Reset
        self.reset()

        # Show help message when action is activated
        if self.show_help:
            message = "Select the disconnected node by clicking on it, move the pointer to desired location inside a pipe and click again"
            self.controller.show_info(message, context_name='ui_message' )

        # Control current layer (due to QGIS bug in snapping system)
        try:
            if self.canvas.currentLayer().type() == QgsMapLayer.VectorLayer:
                self.canvas.setCurrentLayer(self.layer_node)
        except:
            self.canvas.setCurrentLayer(self.layer_node)


    def deactivate(self):
        ''' Called when map tool is being deactivated '''

        # Check button
        self.action().setChecked(False)

        # Restore previous snapping
        self.snapperManager.recoverSnappingOptions()

        # Recover cursor
        self.canvas.setCursor(self.stdCursor)

        try:
            self.rubberBand.reset(QGis.Line)
        except AttributeError:
            pass


    def canvasMoveEvent(self, event):
        ''' Mouse movement event '''      
                        
        # Hide highlight
        self.vertexMarker.hide()
            
        # Get the click
        x = event.pos().x()
        y = event.pos().y()
        eventPoint = QPoint(x,y)

        # Node layer
        layer = self.canvas.currentLayer()
        if layer is None:
            return

        # Select node or arc
        if layer.selectedFeatureCount() == 0:

            # Snap to node
            (retval,result) = self.snapper.snapToBackgroundLayers(eventPoint)   #@UnusedVariable
            
            # That's the snapped point
            if result <> [] and (result[0].layer.name() == self.layer_node.name()):

                point = QgsPoint(result[0].snappedVertex)

                # Add marker    
                self.vertexMarker.setColor(QColor(0, 255, 0))
                self.vertexMarker.setCenter(point)
                self.vertexMarker.show()
                
                # Set a new point to go on with
                #self.appendPoint(point)
                self.rubberBand.movePoint(point)

            else:
                point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(),  x, y)
                self.rubberBand.movePoint(point)

        else:
                
            # Snap to arc
            result = []
            (retval,result) = self.snapper.snapToBackgroundLayers(eventPoint)   #@UnusedVariable
            
            # That's the snapped point
            if (result <> []) and (result[0].layer.name() == self.layer_arc.name()) and (result[0].snappedVertexNr == -1):
            
                point = QgsPoint(result[0].snappedVertex)

                # Add marker
                self.vertexMarker.setColor(QColor(255, 0, 0))
                self.vertexMarker.setCenter(point)
                self.vertexMarker.show()
                
                # Select the arc
                self.layer_arc.removeSelection()
                self.layer_arc.select([result[0].snappedAtGeometry])

                # Bring the rubberband to the cursor i.e. the clicked point
                self.rubberBand.movePoint(point)
        
            else:
                
                # Bring the rubberband to the cursor i.e. the clicked point
                point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(),  x, y)
                self.rubberBand.movePoint(point)


    def canvasReleaseEvent(self, event):
        ''' Mouse release event '''         
        
        if event.button() == Qt.LeftButton:
            
            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            eventPoint = QPoint(x,y)

            # Node layer
            layer = self.canvas.currentLayer()

            # Select node or arc
            if layer.selectedFeatureCount() == 0:

                # Snap to node
                (retval,result) = self.snapper.snapToBackgroundLayers(eventPoint)   #@UnusedVariable
            
                # That's the snapped point
                if result <> [] and (result[0].layer.name() == self.layer_node.name()):
            
                    point = QgsPoint(result[0].snappedVertex)

                    layer.select([result[0].snappedAtGeometry])
        
                    # Hide highlight
                    self.vertexMarker.hide()
                    
                    # Set a new point to go on with
                    self.rubberBand.addPoint(point)

            else:
                
                # Snap to arc
                (retval,result) = self.snapper.snapToBackgroundLayers(eventPoint)   #@UnusedVariable
            
                # That's the snapped point
                if (result <> []) and (result[0].layer.name() == self.layer_arc.name()):
            
                    point = QgsPoint(result[0].snappedVertex)
                    
                    # Get selected feature (at this moment it will have one and only one)           
                    feature = layer.selectedFeatures()[0]
                    node_id = feature.attribute('node_id') 
        
                    # Move selected node to the released point
                    self.move_node(node_id, point)       
            
                    # Rubberband reset
                    self.reset()                    
            
                    # Refresh map canvas
                    self.iface.mapCanvas().refresh()               
        
        elif event.button() == Qt.RightButton:
            self.reset()
                   
    
    
    def set_node_layer(self):
        print "*********CONNEC -function test SET group--------------"
        layers = self.iface.legendInterface().layers()
        if len(layers) == 0:
            return 
        
        self.layer_node = None
        # Initialize variables
        self.layer_node_man = [None for i in range(18)]

        # Iterate over all layers to get the ones specified in 'db' config section
        for cur_layer in layers:
            (uri_schema, uri_table) = self.controller.get_layer_source(cur_layer)
            if uri_table is not None:
           
                if 'v_edit_man_hydrant' in uri_table:
                    self.layer_node_man[0] = cur_layer
                if 'v_edit_man_junction' in uri_table:
                    self.layer_node_man[1] = cur_layer
                if 'v_edit_man_manhole' in uri_table:
                    self.layer_node_man[2] = cur_layer
                if 'v_edit_man_meter' in uri_table:
                    self.layer_node_man[3] = cur_layer
                if 'v_edit_man_node' in uri_table:
                    self.layer_node_man[4] = cur_layer
                if 'v_edit_man_pump' in uri_table:
                    self.layer_node_man[5] = cur_layer
                if 'v_edit_man_reduction' in uri_table:
                    self.layer_node_man[6] = cur_layer
                if 'v_edit_man_source' in uri_table:
                    self.layer_node_man[7] = cur_layer
                if 'v_edit_man_tank' in uri_table:
                    self.layer_node_man[8] = cur_layer
                if 'v_edit_man_valve' in uri_table:
                    self.layer_node_man[9] = cur_layer
                if 'v_edit_man_waterwell' in uri_table:
                    self.layer_node_man[10] = cur_layer 
                    
                    
                if 'v_edit_man_chamber' in uri_table:
                    self.layer_node_man[11] = cur_layer 
                if 'v_edit_man_netgully' in uri_table:
                    self.layer_node_man[12] = cur_layer
                if 'v_edit_man_netinit' in uri_table:
                    self.layer_node_man[13] = cur_layer 
                if 'v_edit_man_wjump' in uri_table:
                    self.layer_node_man[14] = cur_layer 
                if 'v_edit_man_wwtp' in uri_table:
                    self.layer_node_man[15] = cur_layer 
                if 'v_edit_man_outfall' in uri_table:
                    self.layer_node_man[16] = cur_layer 
                if 'v_edit_man_storage' in uri_table:
                    self.layer_node_man[17] = cur_layer
                    
        '''            
        if self.iface.activeLayer() in self.layer_node_man:
            print "IS IN THE TABLE"
        '''   
        self.layer_node=self.iface.activeLayer() 
        # if (self.layer_node)<-(VALUE OF SNAPPED LAYER) in self.layer_node_man:
        if self.layer_node in self.layer_node_man:
            print "IS IN THE TABLE"
            return self.layer_node