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
from qgis.core import QGis, QgsPoint, QgsMapToPixel, QgsFeatureRequest
from qgis.gui import QgsRubberBand, QgsVertexMarker
from PyQt4.QtCore import QPoint, Qt
from PyQt4.QtGui import QColor, QCursor

from map_tools.parent import ParentMapTool


class MoveNodeMapTool(ParentMapTool):
    ''' Button 16. Move node
    Execute SQL function: 'gw_fct_node2arc' '''        

    def __init__(self, iface, settings, action, index_action, srid):
        ''' Class constructor '''        
        
        # Call ParentMapTool constructor     
        super(MoveNodeMapTool, self).__init__(iface, settings, action, index_action)  
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


    def reset(self):
                
        # Graphic elements
        self.rubberBand.reset()

        # Selection
        self.snappFeat = None
          
            
    def move_node(self, node_id, point):
        ''' Move selected node to the current point '''  
           
        if self.srid is None:
            self.srid = self.settings.value('db/srid')  
        if self.schema_name is None:
            self.schema_name = self.settings.value('db/schema_name')               
                   
        # Update node geometry
        the_geom = "ST_GeomFromText('POINT(" + str(point.x()) + " " + str(point.y()) + ")', " + str(self.srid) + ")";
        sql = "UPDATE "+self.schema_name+".node SET the_geom = "+the_geom
        sql+= " WHERE node_id = '"+node_id+"'"
        status = self.controller.execute_sql(sql) 
        if status:
            # Show message before executing
            message = "The procedure will delete features on database. Please ensure that features has no undelete value on true. On the other hand you must know that traceability table will storage precedent information."
            self.controller.show_info_box(message, "Info")
            
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
        if self.canvas.currentLayer() == None:
            self.iface.setActiveLayer(self.layer_node_man[0])


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

        #Plugin reloader bug, MapTool should be deactivated
        try:
            eventPoint = QPoint(x, y)
        except(TypeError, KeyError):
            self.iface.actionPan().trigger()
            return
        
        # Select node or arc
        if self.snappFeat == None:

            # Snap to node
            (retval,result) = self.snapper.snapToBackgroundLayers(eventPoint)   #@UnusedVariable
            if result <> []:

                exist = self.snapperManager.check_node_group(result[0].layer)
                if exist:
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
            (retval,result) = self.snapper.snapToBackgroundLayers(eventPoint)   #@UnusedVariable
            if (result <> []) and (result[0].snappedVertexNr == -1):

                # That's the snapped point
                exist = self.snapperManager.check_arc_group(result[0].layer)
                if exist:
                    point = QgsPoint(result[0].snappedVertex)
    
                    # Add marker
                    self.vertexMarker.setColor(QColor(255, 0, 0))
                    self.vertexMarker.setCenter(point)
                    self.vertexMarker.show()
                    
                    # Select the arc
                    result[0].layer.removeSelection()
                    result[0].layer.select([result[0].snappedAtGeometry])
    
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

            # Select node or arc
            if self.snappFeat == None:

                # Snap to node
                (retval,result) = self.snapper.snapToBackgroundLayers(eventPoint)   #@UnusedVariable
                
                if result <> []:

                    self.snappFeat = next(result[0].layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))

                    # That's the snapped point
                    exist = self.snapperManager.check_node_group(result[0].layer)
                    if exist:
                        point = QgsPoint(result[0].snappedVertex)

                        # Hide highlight
                        self.vertexMarker.hide()
                        
                        # Set a new point to go on with
                        self.rubberBand.addPoint(point)

                        # Add arc snapping
                        self.snapperManager.snapToArc()

            else:
                
                # Snap to arc
                (retval,result) = self.snapper.snapToBackgroundLayers(eventPoint)   #@UnusedVariable
                if result <> []:

                    # That's the snapped point
                    exist = self.snapperManager.check_arc_group(result[0].layer)
                    if exist:
                        point = self.toLayerCoordinates(result[0].layer, QgsPoint(result[0].snappedVertex))

                        # Get selected feature (at this moment it will have one and only one)
                        feature = self.snappFeat
                        node_id = feature.attribute('node_id')

                        # Move selected node to the released point
                        self.move_node(node_id, point)
              
                    # Rubberband reset
                    self.reset()

                    # No snap to arc
                    self.snapperManager.unsnapToArc()
                
                    # Refresh map canvas
                    self.iface.mapCanvas().refreshAllLayers()

                    for layerRefresh in self.iface.mapCanvas().layers():
                        layerRefresh.triggerRepaint()
        
        elif event.button() == Qt.RightButton:

            # Reset rubber band
            self.reset()

            # No snap to arc
            self.snapperManager.unsnapToArc()

            # Refresh map canvas
            self.iface.mapCanvas().refreshAllLayers()

            for layerRefresh in self.iface.mapCanvas().layers():
                layerRefresh.triggerRepaint()

