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
from builtins import str
from builtins import next

# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except ImportError:
    from qgis.core import QGis as Qgis

from qgis.core import QgsPoint, QgsMapToPixel, QgsFeatureRequest
from qgis.gui import QgsVertexMarker
from qgis.PyQt.QtCore import QPoint, Qt

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
        sql = ("UPDATE " + self.schema_name + ".node SET the_geom = " + the_geom + ""
               " WHERE node_id = '" + node_id + "'")
        status = self.controller.execute_sql(sql) 
        if status:

            
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
            self.controller.execute_sql(sql, commit=True)

        else:
            message = "Move node: Error updating geometry"
            self.controller.show_warning(message)
            
        # Rubberband reset
        self.reset()
                                
        # Refresh map canvas
        self.refresh_map_canvas()  
        
        # Deactivate map tool
        self.deactivate()
        self.set_action_pan()

                
    
    """ QgsMapTool inherited event functions """

    def keyPressEvent(self, event):
        if event.key() == Qt.Key_Escape:
            self.cancel_map_tool()
            return


    def activate(self):
        """ Called when set as currently active map tool """

        # Check button
        self.action().setChecked(True)

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Clear snapping
        self.snapper_manager.clear_snapping()

        # Get active layer
        self.active_layer = self.iface.activeLayer()
        
        # Set active layer to 'v_edit_node'
        self.layer_node = self.controller.get_layer_by_tablename("v_edit_node")
        self.iface.setActiveLayer(self.layer_node)    
        
        # Get layer to 'v_edit_arc'
        self.layer_arc = self.controller.get_layer_by_tablename("v_edit_arc")          
 
        # Set the mapTool's parent cursor
        self.canvas.setCursor(self.cursor)  
            
        # Reset
        self.reset()
        
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CIRCLE)         

        # Show help message when action is activated
        if self.show_help:
            message = "Select the disconnected node by clicking on it, move the pointer to desired location inside a pipe and click again"
            self.controller.show_info(message)


    def deactivate(self):
        """ Called when map tool is being deactivated """

        # Call parent method     
        ParentMapTool.deactivate(self)
        
        # Restore previous active layer
        if self.active_layer:
            self.iface.setActiveLayer(self.active_layer)           

        try:
            self.rubber_band.reset(Qgis.Line)
        except AttributeError:
            pass


    def canvasMoveEvent(self, event):
        """ Mouse movement event """      

        # Hide marker
        self.vertex_marker.hide()
        
        try:
            # Get current mouse coordinates
            x = event.pos().x()
            y = event.pos().y()            
            event_point = QPoint(x, y)
        except(TypeError, KeyError):
            self.set_action_pan()
            return
        
        # Snap to node
        if self.snapped_feat is None:
            
            # Make sure active layer is 'v_edit_node'
            cur_layer = self.iface.activeLayer()
            if cur_layer != self.layer_node:
                self.iface.setActiveLayer(self.layer_node)             
            
            # Snapping
            (retval, result) = self.snapper_manager.snap_to_current_layer(event_point)
            if result:
                # Get the point and add marker on it
                snapped_point = result[0]
                point = self.snapper_manager.add_marker(snapped_point, self.vertex_marker)
                # Set a new point to go on with
                self.rubber_band.movePoint(point)
            else:
                point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(), x, y)
                self.rubber_band.movePoint(point)

        # Snap to arc
        else:
            
            # Make sure active layer is 'v_edit_arc'
            cur_layer = self.iface.activeLayer()
            if cur_layer != self.layer_arc:
                self.iface.setActiveLayer(self.layer_arc)               

            # Snapping
            (retval, result) = self.snapper_manager.snap_to_current_layer(event_point)
            
            if result and result[0].snappedVertexNr == -1:

                snapped_point = result[0]
                point = self.snapper_manager.add_marker(snapped_point, self.vertex_marker, QgsVertexMarker.ICON_CROSS)
                
                # Select the arc
                snapped_point.layer.removeSelection()
                snapped_point.layer.select([snapped_point.snappedAtGeometry])

                # Bring the rubberband to the cursor i.e. the clicked point
                self.rubber_band.movePoint(point)
        
            else:
                # Bring the rubberband to the cursor i.e. the clicked point
                point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(), x, y)
                self.rubber_band.movePoint(point)


    def canvasReleaseEvent(self, event):
        """ Mouse release event """         
        
        if event.button() == Qt.LeftButton:
            
            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            event_point = QPoint(x,y)

            # Snap to node
            if self.snapped_feat is None:

                (retval, result) = self.snapper_manager.snap_to_current_layer(event_point)
                
                if result:

                    snapped_point = result[0]
                    self.snapped_feat = next(snapped_point.layer.getFeatures(QgsFeatureRequest().setFilterFid(snapped_point.snappedAtGeometry)))
                    point = QgsPoint(snapped_point.snappedVertex)

                    # Hide marker
                    self.vertex_marker.hide()
                    
                    # Set a new point to go on with
                    self.rubber_band.addPoint(point)

                    # Add arc snapping
                    self.iface.setActiveLayer(self.layer_arc)

            # Snap to arc
            else:

                (retval, result) = self.snapper_manager.snap_to_current_layer(event_point)
                if result:

                    snapped_point = result[0]
                    point = self.toLayerCoordinates(snapped_point.layer, QgsPoint(snapped_point.snappedVertex))

                    # Get selected feature (at this moment it will have one and only one)
                    node_id = self.snapped_feat.attribute('node_id')

                    # Move selected node to the released point
                    # Show message before executing
                    message = ("The procedure will delete features on database."
                               " Please ensure that features has no undelete value on true."
                               " On the other hand you must know that traceability table will storage precedent information.")
                    title = "Info"
                    answer = self.controller.ask_question(message, title)
                    if answer:
                        self.move_node(node_id, point)

        
        elif event.button() == Qt.RightButton:
            self.cancel_map_tool()
            
