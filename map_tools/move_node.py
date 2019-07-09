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
from qgis.core import QgsMapToPixel
from qgis.gui import QgsVertexMarker
from qgis.PyQt.QtCore import Qt

from .parent import ParentMapTool


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
        self.snapper_manager.enable_snapping()

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
            self.reset_rubber_band("line")
        except AttributeError:
            pass


    def canvasMoveEvent(self, event):
        """ Mouse movement event """      

        # Hide marker and get coordinates
        self.vertex_marker.hide()
        x = event.pos().x()
        y = event.pos().y()
        event_point = self.snapper_manager.get_event_point(event)
        
        # Snap to node
        if self.snapped_feat is None:
            
            # Make sure active layer is 'v_edit_node'
            cur_layer = self.iface.activeLayer()
            if cur_layer != self.layer_node:
                self.iface.setActiveLayer(self.layer_node)             
            
            # Snapping
            result = self.snapper_manager.snap_to_current_layer(event_point)
            if self.snapper_manager.result_is_valid():
                # Get the point and add marker on it
                point = self.snapper_manager.add_marker(result, self.vertex_marker)
            else:
                point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(), x, y)

            # Set a new point to go on with
            self.rubber_band.movePoint(point)

        # Snap to arc
        else:
            
            # Make sure active layer is 'v_edit_arc'
            cur_layer = self.iface.activeLayer()
            if cur_layer != self.layer_arc:
                self.iface.setActiveLayer(self.layer_arc)               

            # Snapping
            result = self.snapper_manager.snap_to_current_layer(event_point)
            
            #if result and result[0].snappedVertexNr == -1:
            if self.snapper_manager.result_is_valid():
                layer = self.snapper_manager.get_snapped_layer(result)
                feature_id = self.snapper_manager.get_snapped_feature_id(result)
                point = self.snapper_manager.add_marker(result, self.vertex_marker, QgsVertexMarker.ICON_CROSS)
                # Select the arc
                layer.removeSelection()
                layer.select([feature_id])
            else:
                # Bring the rubberband to the cursor i.e. the clicked point
                point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(), x, y)

            self.rubber_band.movePoint(point)


    def canvasReleaseEvent(self, event):
        """ Mouse release event """         
        
        if event.button() == Qt.LeftButton:

            event_point = self.snapper_manager.get_event_point(event)

            # Snap to node
            if self.snapped_feat is None:

                result = self.snapper_manager.snap_to_current_layer(event_point)
                if not self.snapper_manager.result_is_valid():
                    return

                self.snapped_feat = self.snapper_manager.get_snapped_feature(result)
                point = self.snapper_manager.get_snapped_point(result)

                # Hide marker
                self.vertex_marker.hide()

                # Set a new point to go on with
                self.rubber_band.addPoint(point)

                # Add arc snapping
                self.iface.setActiveLayer(self.layer_arc)

            # Snap to arc
            else:

                result = self.snapper_manager.snap_to_current_layer(event_point)
                if not self.snapper_manager.result_is_valid():
                    return

                layer = self.snapper_manager.get_snapped_layer(result)
                point = self.snapper_manager.get_snapped_point(result)
                point = self.toLayerCoordinates(layer, point)

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
            
