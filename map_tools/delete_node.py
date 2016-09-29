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

                if snapPoint.layer.name() == self.layer_node.name():
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

                    if snapPoint.layer.name() == self.layer_node.name():
                        # Get the point
                        point = QgsPoint(result[0].snappedVertex)

                        snappFeat = next(
                            result[0].layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))

                        break

            if snappFeat is not None:

                # Get selected features and layer type: 'node'
                feature = snappFeat
                node_id = feature.attribute('node_id')

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

        # Set snapping to node
        self.snapperManager.snapToNode()

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Select the node inside a pipe by clicking on it and it will be removed"
            self.controller.show_warning(message, context_name='ui_message')
               
        # Control current layer (due to QGIS bug in snapping system)
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

