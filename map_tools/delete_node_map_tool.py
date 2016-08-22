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
from PyQt4.QtCore import *   # @UnusedWildImport
from PyQt4.QtGui import *    # @UnusedWildImport
from qgis.core import QgsPoint, QgsFeatureRequest, QgsExpression, QgsMapLayer, QgsMapLayerRegistry
from qgis.gui import QgsHighlight, QgsMapCanvasSnapper, QgsMapTool, QgsVertexMarker

from snapping_utils import SnappingConfigManager


class DeleteNodeMapTool(QgsMapTool):

    def __init__(self, iface, settings, action, index_action):  
        ''' Class constructor '''

        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.settings = settings
        self.index_action = index_action
        QgsMapTool.__init__(self, self.canvas)
        self.setAction(action)

        # Snapper
        self.snapperManager = SnappingConfigManager(self.iface)
        self.snapper = QgsMapCanvasSnapper(self.canvas)

        # Change map tool cursor
        self.cursor = QCursor()
        self.cursor.setShape(Qt.CrossCursor)

        # Get default cursor
        self.stdCursor = self.parent().cursor()

        # And finally we set the mapTool's parent cursor
        #self.parent().setCursor(self.cursor)

        # Vertex marker
        self.vertexMarker = QgsVertexMarker(self.canvas)
        self.vertexMarker.setColor(QColor(255, 25, 25))
        self.vertexMarker.setIconSize(12)
        self.vertexMarker.setIconType(QgsVertexMarker.ICON_CIRCLE) # or ICON_CROSS, ICON_X
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
        (retval,result) = self.snapper.snapToBackgroundLayers(eventPoint)
        self.current_layer = None

        # That's the snapped point
        if result <> []:

            # Check Arc or Node
            for snapPoint in result:

                if snapPoint.layer.name() == 'Node':

                    # Get the point
                    point = QgsPoint(result[0].snappedVertex)

                    # Add marker
                    self.vertexMarker.setCenter(point)
                    self.vertexMarker.show()

                    # Data for function
                    self.current_layer = result[0].layer
                    self.snappFeat = next(
                        result[0].layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))

                    break


    def canvasReleaseEvent(self, event):
        
        # With right click the digitizing is finished
        if event.button() == 1 and self.current_layer is not None:

            ''' Button 17. User select one node.
            Execute SQL function 'gw_fct_delete_node'
            Show warning (if any) '''

            # Get selected features and layer type: 'node'
            elem_type = self.current_layer.name().lower()

            feature = self.snappFeat
            node_id = feature.attribute('node_id')

            # Execute SQL function and show result to the user
            function_name = "gw_fct_delete_node"
            sql = "SELECT " + self.schema_name + "." + function_name + "('" + str(node_id) + "');"
            self.controller.get_row(sql)

            # Refresh map canvas
            self.iface.mapCanvas().refresh()


    def set_layer_arc(self, layer_arc):
        ''' Set layer 'Arc' '''
        self.layer_arc = layer_arc


    def set_layer_node(self, layer_node):
        ''' Set layer 'Node' '''
        self.layer_node = layer_node


    def set_schema_name(self, schema_name):
        self.schema_name = schema_name


    def set_dao(self, dao):
        self.dao = dao


    def set_controller(self, controller):
        self.controller = controller


    def activate(self):

        print('delete_node_map_tool Activate')

        # Check button
        self.action().setChecked(True)

        # Store user snapping configuration
        self.snapperManager.storeSnappingOptions()

        # Clear snapping
        self.snapperManager.clearSnapping()

        # Set snapping to node
        self.snapperManager.snapToNode()

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Control current layer (due to QGIS bug in snapping system)
        try:
            if self.canvas.currentLayer().type() == QgsMapLayer.VectorLayer:
                self.canvas.setCurrentLayer(QgsMapLayerRegistry.instance().mapLayersByName("Node")[0])
        except:
            self.canvas.setCurrentLayer(QgsMapLayerRegistry.instance().mapLayersByName("Node")[0])


    def deactivate(self):

        print('delete_node_map_tool Deactivate')

        # Check button
        self.action().setChecked(False)

        # Restore previous snapping
        self.snapperManager.recoverSnappingOptions()

        # Recover cursor
        self.canvas.setCursor(self.stdCursor)

        # Removehighlight
        self.h = None