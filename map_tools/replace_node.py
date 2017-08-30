"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from qgis.core import QgsPoint, QgsFeatureRequest
from qgis.gui import QgsVertexMarker
from PyQt4.QtCore import QPoint, Qt
from PyQt4.QtGui import QColor

from map_tools.parent import ParentMapTool


class ReplaceNodeMapTool(ParentMapTool):
    ''' Button 44. User select one node.
    Execute SQL function: 'gw_fct_node_replace' '''

    def __init__(self, iface, settings, action, index_action):
        ''' Class constructor '''

        # Call ParentMapTool constructor
        super(ReplaceNodeMapTool, self).__init__(iface, settings, action, index_action)

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

        # Plugin reloader bug, MapTool should be deactivated
        try:
            eventPoint = QPoint(x, y)
        except(TypeError, KeyError):
            self.iface.actionPan().trigger()
            return

        # Snapping
        (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)  # @UnusedVariable

        # That's the snapped point
        if result <> []:

            # Check Arc or Node
            for snapPoint in result:

                exist = self.snapperManager.check_node_group(snapPoint.layer)
                if exist:
                    # if snapPoint.layer.name() == self.layer_node.name():
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

                    exist = self.snapperManager.check_node_group(snapPoint.layer)
                    # if snapPoint.layer.name() == self.layer_node.name():
                    if exist:
                        # Get the point
                        point = QgsPoint(result[0].snappedVertex)  # @UnusedVariable
                        snappFeat = next(result[0].layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))
                        result[0].layer.select([result[0].snappedAtGeometry])
                        break

            if snappFeat is not None:

                # Get selected features and layer type: 'node'
                feature = snappFeat
                node_id = feature.attribute('node_id')
                layer = result[0].layer.name()
                view_name = "v_edit_man_"+layer.lower()
                message = str(view_name)
                self.controller.show_warning(message, context_name='ui_message')

                # Show message before executing
                message = "Are you sure you want to replace selected node with a new one ?"
                self.controller.show_info_box(message, "Info")

                # Execute SQL function and show result to the user
                function_name = "gw_fct_node_replace"
                sql = "SELECT " + self.schema_name + "." + function_name + "('" + str(node_id) + "','" + str(view_name) + "');"
                status = self.controller.execute_sql(sql)
                if status:
                    message = "Node replaced successfully"
                    self.controller.show_info(message, context_name='ui_message')

                # Refresh map canvas
                self.iface.mapCanvas().refreshAllLayers()

                for layerRefresh in self.iface.mapCanvas().layers():
                    layerRefresh.triggerRepaint()


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
            message = "Select the node inside a pipe by clicking on it and it will be replaced"
            self.controller.show_warning(message, context_name='ui_message')

        # Control current layer (due to QGIS bug in snapping system)
        if self.canvas.currentLayer() == None:
            self.iface.setActiveLayer(self.layer_node_man[0])


    def deactivate(self):

        # Check button
        self.action().setChecked(False)

        # Restore previous snapping
        self.snapperManager.recoverSnappingOptions()

        # Recover cursor
        self.canvas.setCursor(self.stdCursor)

        # Removehighlight
        self.h = None
    
