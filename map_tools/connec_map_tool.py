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
from PyQt4.QtCore import QRect
from PyQt4.QtGui import QApplication
from qgis.core import (QGis, QgsPoint, QgsMapToPixel, QgsMapLayerRegistry, QgsMapLayer, QgsVectorLayer,
                       QgsFeatureRequest, QgsRectangle)
from qgis.gui import QgsMapCanvasSnapper, QgsMapTool, QgsRubberBand, QgsVertexMarker
from PyQt4.QtCore import QPoint, Qt
from PyQt4.QtGui import QColor, QCursor

from parent_map_tool import ParentMapTool

from snapping_utils import SnappingConfigManager


class ConnecMapTool(ParentMapTool):

    def __init__(self, iface, settings, action, index_action):
        ''' Class constructor '''

        # Call ParentMapTool constructor
        super(ConnecMapTool, self).__init__(iface, settings, action, index_action)

        self.dragging = False

        # And finally we set the mapTool's parent cursor
        # self.parent().setCursor(self.cursor)

        # Vertex marker
        self.vertexMarker = QgsVertexMarker(self.canvas)
        self.vertexMarker.setColor(QColor(255, 25, 25))
        self.vertexMarker.setIconSize(11)
        self.vertexMarker.setIconType(QgsVertexMarker.ICON_BOX)  # or ICON_CROSS, ICON_X
        self.vertexMarker.setPenWidth(5)

        # Rubber band
        self.rubberBand = QgsRubberBand(self.canvas, True)
        mFillColor = QColor(100, 0, 0);
        self.rubberBand.setColor(mFillColor)
        self.rubberBand.setWidth(3)
        mBorderColor = QColor(254, 58, 29)
        self.rubberBand.setBorderColor(mBorderColor)
        # self.reset()

        # Select rectangle
        self.selectRect = QRect()


    def reset(self):

        # Clear selected features
        layer = self.layer_connec
        if layer is not None:
            layer.removeSelection()

        # Graphic elements
        self.rubberBand.reset()


    ''' QgsMapTools inherited event functions '''

    def canvasMoveEvent(self, event):

        # With right click the digitizing is finished
        if event.buttons() == Qt.LeftButton:

            if not self.dragging:
                self.dragging = True
                self.selectRect.setTopLeft(event.pos())

            self.selectRect.setBottomRight(event.pos())
            self.set_rubber_band()

        else:

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

                    if snapPoint.layer == self.layer_connec:

                        # Get the point
                        point = QgsPoint(result[0].snappedVertex)

                        # Add marker
                        self.vertexMarker.setCenter(point)
                        self.vertexMarker.show()

                        break


    def canvasPressEvent(self, event):

        self.selectRect.setRect(0, 0, 0, 0)
        self.rubberBand.reset()


    def canvasReleaseEvent(self, event):

        # With right click the digitizing is finished
        if event.button() == 1:

            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            eventPoint = QPoint(x, y)

            # Node layer
            layer = self.layer_connec

            # Not dragging, just simple selection
            if not self.dragging:

                # Snap to node
                (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)  # @UnusedVariable

                # That's the snapped point
                if result <> [] and (result[0].layer.name() == self.layer_connec.name()):
                    point = QgsPoint(result[0].snappedVertex)

                    layer.removeSelection()
                    layer.select([result[0].snappedAtGeometry])

                    # Create link
                    self.link_connec()

                    # Hide highlight
                    self.vertexMarker.hide()


            else:

                # Set valid values for rectangle's width and height
                if self.selectRect.width() == 1:
                    self.selectRect.setLeft( self.selectRect.left() + 1 )

                if self.selectRect.height() == 1:
                    self.selectRect.setBottom( self.selectRect.bottom() + 1 )

                self.set_rubber_band()

                selectGeom = self.rubberBand.asGeometry()

                self.select_multiple_features(self.selectRectMapCoord)

                self.dragging = False

                # Create link
                self.link_connec()

                #self.reset()

        # On right click, take action
        if event.button() == 2:

            # Create link
            self.link_connec()


    def activate(self):

        print('connec_map_tool Activate')

        # Check button
        self.action().setChecked(True)

        # Rubber band
        self.rubberBand.reset()

        # Store user snapping configuration
        self.snapperManager.storeSnappingOptions()

        # Clear snapping
        self.snapperManager.clearSnapping()

        # Set snapping to arc and node
        self.snapperManager.snapToConnec()

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            self.controller.show_info(
                "Right click to use current selection, select connec points by clicking or dragging (selection box)")

        # Control current layer (due to QGIS bug in snapping system)
        try:
            if self.canvas.currentLayer().type() == QgsMapLayer.VectorLayer:
                self.canvas.setCurrentLayer(QgsMapLayerRegistry.instance().mapLayersByName("Connec")[0])
        except:
            self.canvas.setCurrentLayer(QgsMapLayerRegistry.instance().mapLayersByName("Connec")[0])


    def deactivate(self):

        print('connec_map_tool Deactivate')

        # Check button
        self.action().setChecked(False)

        # Rubber band
        self.rubberBand.reset()

        # Restore previous snapping
        self.snapperManager.recoverSnappingOptions()

        # Recover cursor
        self.canvas.setCursor(self.stdCursor)


    def link_connec(self):
        ''' Link selected connec to the pipe '''

        ''' Button 20. User select connections from layer 'connec'
        and executes function: 'gw_fct_connect_to_network' '''

        # Get selected features (from layer 'connec')
        aux = "{"
        layer = self.layer_connec
        if layer.selectedFeatureCount() == 0:
            self.controller.show_warning("You have to select at least one feature!")
            return
        features = layer.selectedFeatures()
        for feature in features:
            connec_id = feature.attribute('connec_id')
            aux += str(connec_id) + ", "
        connec_array = aux[:-2] + "}"

        # Execute function
        function_name = "gw_fct_connect_to_network"
        sql = "SELECT " + self.schema_name + "." + function_name + "('" + connec_array + "');"
        self.controller.execute_sql(sql)

        # Refresh map canvas
        self.rubberBand.reset()
        self.iface.mapCanvas().refresh()  # Rubberband reset


    def set_rubber_band(self):

        # Coordinates transform
        transform = self.canvas.getCoordinateTransform()

        # Coordinates
        ll = transform.toMapCoordinates(self.selectRect.left(), self.selectRect.bottom())
        lr = transform.toMapCoordinates(self.selectRect.right(), self.selectRect.bottom())
        ul = transform.toMapCoordinates(self.selectRect.left(), self.selectRect.top())
        ur = transform.toMapCoordinates(self.selectRect.right(), self.selectRect.top())

        # Rubber band
        self.rubberBand.reset()
        self.rubberBand.addPoint(ll, False)
        self.rubberBand.addPoint(lr, False)
        self.rubberBand.addPoint(ur, False)
        self.rubberBand.addPoint(ul, False)
        self.rubberBand.addPoint(ll, True)

        self.selectRectMapCoord = 	QgsRectangle(ll, ur)


    def select_multiple_features(self, selectGeometry):

        # Default choice
        behaviour = QgsVectorLayer.SetSelection

        # Modifiers
        modifiers = QApplication.keyboardModifiers()

        if modifiers == Qt.ControlModifier:
            behaviour = QgsVectorLayer.AddToSelection
        elif modifiers == Qt.ShiftModifier:
            behaviour = QgsVectorLayer.RemoveFromSelection

        # Layer
        layer = self.layer_connec

        if layer == None:
            return

        # Change cursor
        QApplication.setOverrideCursor(Qt.WaitCursor)

        # Selection
        layer.selectByRect(selectGeometry, behaviour)

        # Old cursor
        QApplication.restoreOverrideCursor()



