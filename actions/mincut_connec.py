"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtCore import pyqtSignal, QPoint, QRect, Qt
from PyQt4.QtGui import QColor
from qgis.core import QgsPoint, QgsRectangle, QGis
from qgis.gui import QgsMapTool, QgsRubberBand, QgsVertexMarker, QgsMapCanvasSnapper


class MincutConnec(QgsMapTool):

    canvasClicked = pyqtSignal()


    def __init__(self, iface, controller):
        """ Class constructor """

        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.controller = controller
        # Call superclass constructor and set current action
        QgsMapTool.__init__(self, self.canvas)

        self.dragging = False

        # Vertex marker       
        self.vertex_marker = QgsVertexMarker(self.canvas)
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CIRCLE)
        self.vertex_marker.setColor(QColor(255, 100, 255))
        self.vertex_marker.setIconSize(15)
        self.vertex_marker.setPenWidth(3)          

        # Rubber band
        self.rubber_band = QgsRubberBand(self.canvas, QGis.Line)
        self.rubber_band.setColor(color)
        self.rubber_band.setWidth(1)             

        # Select rectangle
        self.select_rect = QRect()

        # Parametrize
        self.layernames_connec = ["v_edit_connec"]
        #self.snapperManager = SnappingConfigManager(self.iface)
        self.snapper = QgsMapCanvasSnapper(self.canvas)


    def activate(self):
        pass


    def canvasPressEvent(self, event):   #@UnusedVariable
        self.select_rect.setRect(0, 0, 0, 0)
        self.rubber_band.reset()


    def canvasMoveEvent(self, event):
        """ With left click the digitizing is finished """

        if event.buttons() == Qt.LeftButton:
            if not self.dragging:
                self.dragging = True
                self.select_rect.setTopLeft(event.pos())
            self.select_rect.setBottomRight(event.pos())
            self.set_rubber_band()

        else:
            # Hide highlight
            self.vertex_marker.hide()

            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            event_point = QPoint(x, y)

            # Snapping
            (retval, result) = self.snapper.snapToBackgroundLayers(event_point)  # @UnusedVariable

            # That's the snapped point
            if result:
                # Check feature
                for snap_point in result:
                    element_type = snap_point.layer.name()
                    if element_type in self.layernames_connec:
                        # Get the point
                        point = QgsPoint(snap_point.snappedVertex)
                        # Add marker
                        self.vertex_marker.setCenter(point)
                        self.vertex_marker.show()
                        break


    def canvasReleaseEvent(self, event):
        """ With left click the digitizing is finished """

        if event.button() == Qt.LeftButton:

            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            event_point = QPoint(x, y)

            # Not dragging, just simple selection
            if not self.dragging:
                
                # Snap to node
                (retval, result) = self.snapper.snapToBackgroundLayers(event_point)  # @UnusedVariable

                # That's the snapped point
                if result:
                    # Check feature
                    for snapped_point in result:
                        element_type = snapped_point.layer.name()
                        if element_type in self.layernames_connec:
                            feat_type = 'connec'
                        else:
                            continue

                        point = QgsPoint(snapped_point.snappedVertex)  # @UnusedVariable
                        # layer.removeSelection()
                        # layer.select([result[0].snappedAtGeometry])

                        #snapped_point.layer.removeSelection()
                        snapped_point.layer.select([snapped_point.snappedAtGeometry])
                        
            else:

                # Set valid values for rectangle's width and height
                if self.select_rect.width() == 1:
                    self.select_rect.setLeft(self.select_rect.left() + 1)

                if self.select_rect.height() == 1:
                    self.select_rect.setBottom(self.select_rect.bottom() + 1)

                self.set_rubber_band()               
                self.select_multiple_features(self.selected_rectangle)
                self.dragging = False

            # Refresh map canvas
            self.rubber_band.reset()
            self.refresh_map_canvas()


    def set_rubber_band(self):

        # Coordinates transform
        transform = self.canvas.getCoordinateTransform()

        # Coordinates
        ll = transform.toMapCoordinates(self.select_rect.left(), self.select_rect.bottom())
        lr = transform.toMapCoordinates(self.select_rect.right(), self.select_rect.bottom())
        ul = transform.toMapCoordinates(self.select_rect.left(), self.select_rect.top())
        ur = transform.toMapCoordinates(self.select_rect.right(), self.select_rect.top())

        # Rubber band
        self.rubber_band.reset()
        self.rubber_band.addPoint(ll, False)
        self.rubber_band.addPoint(lr, False)
        self.rubber_band.addPoint(ur, False)
        self.rubber_band.addPoint(ul, False)
        self.rubber_band.addPoint(ll, True)

        self.selected_rectangle = QgsRectangle(ll, ur)


    def select_multiple_features(self, rectangle):
       
        if self.layernames_connec is None:
            return

        if QGis.QGIS_VERSION_INT >= 21600:

            # Selection for all connec group layers
            for layer_name in self.layernames_connec:
                # Get layer by his name
                layer = self.controller.get_layer_by_layername(layer_name, log_info=True)
                if layer:
                    self.layers_connec.append(layer)                   
                    layer.selectByRect(rectangle)

        else:
            for layer_name in self.layernames_connec:
                self.iface.setActiveLayer(layer)                
                layer.removeSelection()
                layer.select(rectangle, True)

