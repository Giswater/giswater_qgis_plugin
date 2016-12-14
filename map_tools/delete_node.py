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
from qgis.core import QgsPoint, QgsFeatureRequest, QgsMapLayer
from qgis.gui import QgsVertexMarker
from PyQt4.QtCore import QPoint, Qt
from PyQt4.QtGui import QColor

from map_tools.parent import ParentMapTool



class DeleteNodeMapTool(ParentMapTool):
    ''' Button 17. User select one node.
    Execute SQL function: 'gw_fct_delete_node' '''

    def __init__(self, iface, settings, action, index_action):
        ''' Class constructor '''

        # Call ParentMapTool constructor
        super(DeleteNodeMapTool, self).__init__(iface, settings, action, index_action)

        # Vertex marker
        self.vertexMarker = QgsVertexMarker(self.canvas)
        self.vertexMarker.setColor(QColor(255, 25, 25))
        self.vertexMarker.setIconSize(12)
        self.vertexMarker.setIconType(QgsVertexMarker.ICON_CIRCLE)  # or ICON_CROSS, ICON_X
        self.vertexMarker.setPenWidth(5)
        
    ''' QgsMapTools inherited event functions '''

    def canvasMoveEvent(self, event):
        
        # Hide highlight
        self.vertexMarker.hide()

        # Get the click
        x = event.pos().x()
        y = event.pos().y()
        eventPoint = QPoint(x, y)

        # Snapping
        (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)  # @UnusedVariable

        # That's the snapped point
        if result <> []:

            # Check Arc or Node
            for snapPoint in result:

                self.layer_node= self.iface.activeLayer().name()

                self.layer_node=self.iface.activeLayer().name()
                exist = self.check_group_node(snapPoint.layer)
                   
                if exist : 
                    if snapPoint.layer.name() == self.layer_node:
                        # Get the point
    
                        point = QgsPoint(result[0].snappedVertex)
    
                        # Add marker
                        self.vertexMarker.setCenter(point)
                        self.vertexMarker.show()
    
                        break

    def canvasReleaseEvent(self, event):
        
        # With left click the digitizing is finished
        if event.button() == Qt.LeftButton:

            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            eventPoint = QPoint(x, y)

            snappFeat = None

            # Snapping
            (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)  # @UnusedVariable

            # That's the snapped point
            if result <> []:

                # Check Arc or Node
                for snapPoint in result:
                    # in function we call snapPoint.layer.name () function return 0
                    # if boolean 
                    #x= self.group_node(snapPoint.layer)
                    
                    self.layer_node=self.iface.activeLayer().name()
                    exist = self.check_group_node(snapPoint.layer)
                    print"*******EXIST*********"
                    print self.layer_node
                    print exist
                    print snapPoint.layer.name()
                    if exist : 
                        if snapPoint.layer.name() == self.layer_node:
                            print "RAAAAAAAAAAAAAAAAAAAAAADI"
                            # Get the point
                            point = QgsPoint(result[0].snappedVertex)
    
                            snappFeat = next(
                                result[0].layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))
    
                            break

            if snappFeat is not None:

                # Get selected features and layer type: 'node'
                feature = snappFeat
                node_id = feature.attribute('node_id')
                node_type = feature.attribute('node_type')
                
                
                if node_type == "POU":
                    print "test3"
                    inf_text= "text"
                    answer = self.controller.ask_question("Are you sure you want to delete these records?", "Delete records", inf_text)
                    table_name = '"v_ui_doc_x_node'
                    if answer:
                        # Unlink document
                        sql = "DELETE FROM "+self.schema_name+"."+table_name 
                        sql+= " WHERE node_id='"+node_id+"'"
                        self.dao.execute_sql(sql)
          
                    
                # Execute SQL function and show result to the user
                function_name = "gw_fct_delete_node"
                sql = "SELECT " + self.schema_name + "." + function_name + "('" + str(node_id) + "');"
                status = self.controller.execute_sql(sql)
                if status:
                    message = "Node deleted successfully"
                    self.controller.show_warning(message, context_name='ui_message' )  

                # Refresh map canvas
                self.iface.mapCanvas().refresh()
                

    def activate(self):

        # Check button
        self.action().setChecked(True)

        # Store user snapping configuration
        self.snapperManager.storeSnappingOptions()

        # Clear snapping
        self.snapperManager.clearSnapping()
        
        print"test activate"
        # Set snapping to node
        self.snapperManager.snapToNode()

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Select the node inside a pipe by clicking on it and it will be removed"
            self.controller.show_warning(message, context_name='ui_message')
        self.layer_node = self.iface.activeLayer()     
        # Control current layer (due to self.iface.activeLayer()QGIS bug in snapping system)
        try:
            if self.canvas.currentLayer().type() == QgsMapLayer.VectorLayer:
                self.canvas.setCurrentLayer(self.layer_node)
        except:
            self.canvas.setCurrentLayer(self.layer_node)

    def deactivate(self):

        # Check button
        self.action().setChecked(False)

        # Restore previous snapping
        self.snapperManager.recoverSnappingOptions()

        # Recover cursor
        self.canvas.setCursor(self.stdCursor)

        # Removehighlight
        self.h = None

                
    
        
        
    def check_group_node(self,layer_snap):
        print "*********function test if group--------------"
        layers = self.iface.legendInterface().layers()
        if len(layers) == 0:
            return 
        
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
        print "from function"
        print layer_snap
        print self.layer_node_man
        print self.layer_node_man[15].name()
        if layer_snap in self.layer_node_man:
            print "IS IN THE TABLE"
            return 1