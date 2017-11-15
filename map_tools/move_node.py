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
from qgis.gui import QgsVertexMarker
from PyQt4.QtCore import QPoint, Qt
from PyQt4.QtGui import QCursor

from map_tools.parent import ParentMapTool


class MoveNodeMapTool(ParentMapTool):
    """ Button 16. Move node
    Execute SQL function: 'gw_fct_node2arc' """        

    def __init__(self, iface, settings, action, index_action):
        """ Class constructor """        
        
        # Call ParentMapTool constructor     
        super(MoveNodeMapTool, self).__init__(iface, settings, action, index_action)  
          
            
    def move_node(self, node_id, point):
        """ Move selected node to the current point """  
           
        srid = self.controller.plugin_settings_value('srid')                 
                   
        # Update node geometry
        the_geom = "ST_GeomFromText('POINT(" + str(point.x()) + " " + str(point.y()) + ")', " + str(srid) + ")";
        sql = "UPDATE " + self.schema_name + ".node SET the_geom = " + the_geom
        sql+= " WHERE node_id = '" + node_id + "'"
        status = self.controller.execute_sql(sql) 
        if status:
            # Show message before executing
            message = ("The procedure will delete features on database." 
                       " Please ensure that features has no undelete value on true."
                       " On the other hand you must know that traceability table will storage precedent information.")
            self.controller.show_info_box(message, "Info")
            
            # Execute SQL function and show result to the user
            function_name = "gw_fct_arc_divide"
            row = self.controller.check_function(function_name)
            if not row:
                function_name = "gw_fct_node2arc"
                row = self.controller.check_function(function_name)
                if not row:
                    message = "Database function not found"
                    self.controller.show_warning(message, parameter=function_name)
                    return
            sql = "SELECT " + self.schema_name + "." + function_name + "('" + str(node_id) + "');"
            row = self.controller.get_row(sql, commit=True)
            if row:
                if row[0] > 1: 
                    message = ("There are linked features related to the new arcs (connec/gully) without the automatic updated of the arc_id after the division.\n"
                               "Please review it.\nNumber of features missupdated") 
                    self.controller.show_info_box(message, parameter=row[0])
        else:
            message = "Move node: Error updating geometry"
            self.controller.show_warning(message)
            
        # Refresh map canvas
        self.canvas.currentLayer().triggerRepaint()  

                
    
    """ QgsMapTool inherited event functions """    
       
    def activate(self):
        """ Called when set as currently active map tool """

        # Check button
        self.action().setChecked(True)

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Clear snapping
        self.snapper_manager.clear_snapping()

        # Set snapping to node
        self.snapper_manager.snap_to_node()

        # Change pointer
        cursor = QCursor()
        cursor.setShape(Qt.CrossCursor)

        # Get default cursor        
        self.std_cursor = self.parent().cursor()   
 
        # And finally we set the mapTool's parent cursor
        self.parent().setCursor(cursor)

        # Reset
        self.reset()

        # Show help message when action is activated
        if self.show_help:
            message = "Select the disconnected node by clicking on it, move the pointer to desired location inside a pipe and click again"
            self.controller.show_info(message)

        # Control current layer (due to QGIS bug in snapping system)
        if self.canvas.currentLayer() == None:
            self.iface.setActiveLayer(self.layer_node_man[0])


    def deactivate(self):
        """ Called when map tool is being deactivated """

        # Call parent method     
        ParentMapTool.deactivate(self)

        try:
            self.rubber_band.reset(QGis.Line)
        except AttributeError:
            pass


    def canvasMoveEvent(self, event):
        """ Mouse movement event """      

        # Hide marker
        self.vertex_marker.hide()
            
        # Get the click
        x = event.pos().x()
        y = event.pos().y()

        #Plugin reloader bug, MapTool should be deactivated
        try:
            event_point = QPoint(x, y)
        except(TypeError, KeyError):
            self.set_action_pan()
            return
        
        # Select node or arc
        if self.snapped_feat == None:

            # Snap to node
            (retval, result) = self.snapper.snapToBackgroundLayers(event_point)   #@UnusedVariable
            if result:
                # Check if feature belongs to 'node' group
                exist = self.snapper_manager.check_node_group(result[0].layer)
                if exist:
                    point = QgsPoint(result[0].snappedVertex)
    
                    # Set marker    
                    self.vertex_marker.setIconType(QgsVertexMarker.ICON_CIRCLE)                
                    self.vertex_marker.setCenter(point)
                    self.vertex_marker.show()
                    
                    # Set a new point to go on with
                    self.rubber_band.movePoint(point)

            else:
                point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(), x, y)
                self.rubber_band.movePoint(point)

        else:
                
            # Snap to arc
            (retval, result) = self.snapper.snapToBackgroundLayers(event_point)   #@UnusedVariable
            if result and result[0].snappedVertexNr == -1:

                # Check if feature belongs to 'arc' group
                exist = self.snapper_manager.check_arc_group(result[0].layer)
                if exist:
                    point = QgsPoint(result[0].snappedVertex)
    
                    # Set marker
                    self.vertex_marker.setIconType(QgsVertexMarker.ICON_X)                 
                    self.vertex_marker.setCenter(point)
                    self.vertex_marker.show()
                    
                    # Select the arc
                    result[0].layer.removeSelection()
                    result[0].layer.select([result[0].snappedAtGeometry])
    
                    # Bring the rubberband to the cursor i.e. the clicked point
                    self.rubber_band.movePoint(point)
        
            else:
                
                # Bring the rubberband to the cursor i.e. the clicked point
                point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(),  x, y)
                self.rubber_band.movePoint(point)


    def canvasReleaseEvent(self, event):
        """ Mouse release event """         
        
        if event.button() == Qt.LeftButton:
            
            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            eventPoint = QPoint(x,y)

            # Select node or arc
            if self.snapped_feat is None:

                # Snap to node
                (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)   #@UnusedVariable
                
                if result:

                    self.snapped_feat = next(result[0].layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))

                    # That's the snapped point
                    exist = self.snapper_manager.check_node_group(result[0].layer)
                    if exist:
                        point = QgsPoint(result[0].snappedVertex)

                        # Hide marker
                        self.vertex_marker.hide()
                        
                        # Set a new point to go on with
                        self.rubber_band.addPoint(point)

                        # Add arc snapping
                        self.snapper_manager.snap_to_arc()

            else:
                
                # Snap to arc
                (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)   #@UnusedVariable
                if result:

                    # That's the snapped point
                    exist = self.snapper_manager.check_arc_group(result[0].layer)
                    if exist:
                        point = self.toLayerCoordinates(result[0].layer, QgsPoint(result[0].snappedVertex))

                        # Get selected feature (at this moment it will have one and only one)
                        node_id = self.snapped_feat.attribute('node_id')

                        # Move selected node to the released point
                        self.move_node(node_id, point)
              
                    # Rubberband reset
                    self.reset()

                    # No snap to arc
                    self.snapper_manager.unsnap_to_arc()
                
                    # Refresh map canvas
                    self.refresh_map_canvas()

        
        elif event.button() == Qt.RightButton:

            # Reset rubber band
            self.reset()

            # No snap to arc
            self.snapper_manager.unsnap_to_arc()

            # Refresh map canvas
            self.refresh_map_canvas()

