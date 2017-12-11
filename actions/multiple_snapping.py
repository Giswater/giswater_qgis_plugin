'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from qgis.core import QgsFeatureRequest, QgsPoint, QgsRectangle, QGis
from qgis.gui import QgsMapTool, QgsMapCanvasSnapper, QgsRubberBand, QgsVertexMarker
from PyQt4.QtCore import Qt, pyqtSignal, QPoint
from PyQt4.QtGui import QApplication, QColor


class MultipleSnapping(QgsMapTool):

    canvasClicked = pyqtSignal()

    def __init__(self, iface, controller, layernames):
        """ Class constructor """

        self.layernames = layernames
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        
        # Call superclass constructor and set current action
        QgsMapTool.__init__(self, self.canvas)

        self.controller = controller
        self.rubber_band = QgsRubberBand(self.canvas, QGis.Polygon)
        self.rubber_band.setColor(QColor(254, 178, 76, 63))
        self.rubber_band.setWidth(1)
        self.reset()
        self.snapper = QgsMapCanvasSnapper(self.canvas)
        self.selected_features = []

        # Vertex marker
        self.vertex_marker = QgsVertexMarker(self.canvas)
        self.vertex_marker.setColor(QColor(255, 100, 255))
        self.vertex_marker.setIconSize(15)
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CROSS)
        self.vertex_marker.setPenWidth(3)


    def reset(self):
        self.start_point = self.end_point = None
        self.is_emitting_point = False
        self.rubber_band.reset(QGis.Polygon)


    def canvasPressEvent(self, e):

        if e.button() == Qt.LeftButton:
            self.start_point = self.toMapCoordinates(e.pos())
            self.end_point = self.start_point
            self.is_emitting_point = True
            self.show_rect(self.start_point, self.end_point)


    def canvasReleaseEvent(self, e):
        
        self.is_emitting_point = False
        r = self.rectangle()

        # Use CTRL button to unselect features
        key = QApplication.keyboardModifiers()

        number_features = 0
        if e.button() == Qt.LeftButton:
            for layer in self.layers:
                # Check number of selections
                #number_features = layer.selectedFeatureCount()
                if r is not None:
                    # Selection by rectange
                    lRect = self.canvas.mapSettings().mapToLayerCoordinates(layer, r)
                    layer.select(lRect, True) # True for leave previous selection
                    # if CTRL pressed : unselect features
                    if key == Qt.ControlModifier:
                        layer.selectByRect(lRect, layer.RemoveFromSelection)
                else:
                    # Selection one by one
                    x = e.pos().x()
                    y = e.pos().y()
                    eventPoint = QPoint(x, y)
                    (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)  #@UnusedVariable
                    if result:
                        # Check feature
                        for snap_point in result:
                            # Get the point. Leave selection
                            #point = QgsPoint(snap_point.snappedVertex)
                            snapp_feat = next(snap_point.layer.getFeatures(QgsFeatureRequest().setFilterFid(snap_point.snappedAtGeometry)))
                            snap_point.layer.select([snap_point.snappedAtGeometry])

            self.rubber_band.hide()


    def canvasMoveEvent(self, e):
        
        if not self.is_emitting_point:
            return
        self.end_point = self.toMapCoordinates(e.pos())
        self.show_rect(self.start_point, self.end_point)


    def show_rect(self, start_point, end_point):
        
        self.rubber_band.reset(QGis.Polygon)
        if start_point.x() == end_point.x() or start_point.y() == end_point.y():
            return
        point1 = QgsPoint(start_point.x(), start_point.y())
        point2 = QgsPoint(start_point.x(), end_point.y())
        point3 = QgsPoint(end_point.x(), end_point.y())
        point4 = QgsPoint(end_point.x(), start_point.y())

        self.rubber_band.addPoint(point1, False)
        self.rubber_band.addPoint(point2, False)
        self.rubber_band.addPoint(point3, False)
        self.rubber_band.addPoint(point4, True)  # true to update canvas
        self.rubber_band.show()


    def rectangle(self):
        
        if self.start_point is None or self.end_point is None:
            return None
        elif self.start_point.x() == self.end_point.x() or self.start_point.y() == self.end_point.y():
            return None

        return QgsRectangle(self.start_point, self.end_point)


    def deactivate(self):
        self.rubber_band.hide()
        QgsMapTool.deactivate(self)


    def activate(self):

        self.layernames = ["v_edit_connec"]
        self.layers = []
        for layername in self.layernames:
            layer = self.controller.get_layer_by_tablename(layername, log_info=True)
            if layer:
                self.layers.append(layer)
                self.iface.setActiveLayer(layer)

        self.canvas.xyCoordinates.connect(self.mouse_move)


    def mouse_move(self, p):

        self.vertex_marker.hide()
        map_point = self.canvas.getCoordinateTransform().transform(p)
        x = map_point.x()
        y = map_point.y()
        event_point = QPoint(x, y)

        # Snapping
        (retval, result) = self.snapper.snapToCurrentLayer(event_point, 2)  # @UnusedVariable

        # That's the snapped point
        if result:
            # Check feature
            for snapPoint in result:
                if snapPoint.layer.name() == 'v_edit_connec':
                    point = QgsPoint(snapPoint.snappedVertex)
                    # Add marker
                    self.vertex_marker.setCenter(point)
                    self.vertex_marker.show()
                    break

