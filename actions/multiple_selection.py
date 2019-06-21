"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except ImportError:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT < 29900:
    from qgis.core import QgsPoint as QgsPointXY
    from giswater.map_tools.snapping_utils_v2 import SnappingConfigManager
else:
    from qgis.core import QgsPointXY
    from giswater.map_tools.snapping_utils_v3 import SnappingConfigManager

from qgis.core import QgsRectangle
from qgis.gui import QgsMapTool, QgsRubberBand
from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtWidgets import QApplication
from qgis.PyQt.QtGui import QColor


class MultipleSelection(QgsMapTool):


    def __init__(self, iface, controller, layers, 
                 mincut=None, parent_manage=None, manage_new_psector=None, table_object=None, dialog=None):
        """ Class constructor """

        self.layers = layers
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.mincut = mincut
        self.parent_manage = parent_manage
        self.manage_new_psector = manage_new_psector
        self.table_object = table_object
        self.dialog = dialog
        
        # Call superclass constructor and set current action
        QgsMapTool.__init__(self, self.canvas)

        self.controller = controller
        self.rubber_band = QgsRubberBand(self.canvas, 2)
        self.rubber_band.setColor(QColor(255, 100, 255))
        self.rubber_band.setFillColor(QColor(254, 178, 76, 63))
        self.rubber_band.setWidth(1)
        self.reset()
        self.selected_features = []

        if Qgis.QGIS_VERSION_INT < 29900:
            snapper = QgsMapCanvasSnapper(self.canvas)
        # Snapper
        self.snapper_manager = SnappingConfigManager(self.iface)
        self.snapper = self.snapper_manager.get_snapper()


    def reset(self):
        
        self.start_point = self.end_point = None
        self.is_emitting_point = False
        self.reset_rubber_band()


    def canvasPressEvent(self, event):

        if event.button() == Qt.LeftButton:
            self.start_point = self.toMapCoordinates(event.pos())
            self.end_point = self.start_point
            self.is_emitting_point = True
            self.show_rect(self.start_point, self.end_point)


    def canvasReleaseEvent(self, event):
        
        self.is_emitting_point = False
        rectangle = self.get_rectangle()
        selected_rectangle = None
        key = QApplication.keyboardModifiers()                

        if event.button() != Qt.LeftButton:
            self.rubber_band.hide()            
            return
        
        # Disconnect signal to enhance process
        # We will reconnect it when processing last layer of the group 
        if self.mincut:                            
            self.mincut.disconnect_signal_selection_changed()           
        if self.parent_manage: 
            self.parent_manage.disconnect_signal_selection_changed()
        if self.manage_new_psector:
            self.manage_new_psector.disconnect_signal_selection_changed()
        
        for i in range(len(self.layers)):
            layer = self.layers[i]
            if i == len(self.layers) - 1:
                if self.mincut:                              
                    self.mincut.connect_signal_selection_changed("mincut_connec")
                if self.parent_manage:                          
                    self.parent_manage.connect_signal_selection_changed(self.dialog, self.table_object)
                if self.manage_new_psector:
                    self.manage_new_psector.connect_signal_selection_changed(
                        self.manage_new_psector.dlg_plan_psector, self.table_object)

            # Selection by rectangle
            if rectangle:
                if selected_rectangle is None:
                    selected_rectangle = self.canvas.mapSettings().mapToLayerCoordinates(layer, rectangle)
                # If Ctrl+Shift clicked: remove features from selection
                if key == (Qt.ControlModifier | Qt.ShiftModifier):                
                    layer.selectByRect(selected_rectangle, layer.RemoveFromSelection)
                # If Ctrl clicked: add features to selection
                elif key == Qt.ControlModifier:
                    layer.selectByRect(selected_rectangle, layer.AddToSelection)
                # If Ctrl not clicked: add features to selection
                else:
                    layer.selectByRect(selected_rectangle, layer.AddToSelection)
                                        
            # Selection one by one
            else:
                event_point = self.snapper_manager.get_event_point(event)
                result = self.snapper_manager.snap_to_background_layers(event_point)
                if self.snapper_manager.result_is_valid():
                    # Get the point. Leave selection
                    self.snapper_manager.get_snapped_feature(result, True)

        self.rubber_band.hide()


    def canvasMoveEvent(self, event):
        
        if not self.is_emitting_point:
            return

        self.end_point = self.toMapCoordinates(event.pos())
        self.show_rect(self.start_point, self.end_point)


    def show_rect(self, start_point, end_point):
        
        self.reset_rubber_band()
        if start_point.x() == end_point.x() or start_point.y() == end_point.y():
            return

        point1 = QgsPointXY(start_point.x(), start_point.y())
        point2 = QgsPointXY(start_point.x(), end_point.y())
        point3 = QgsPointXY(end_point.x(), end_point.y())
        point4 = QgsPointXY(end_point.x(), start_point.y())

        self.rubber_band.addPoint(point1, False)
        self.rubber_band.addPoint(point2, False)
        self.rubber_band.addPoint(point3, False)
        self.rubber_band.addPoint(point4, True)
        self.rubber_band.show()


    def get_rectangle(self):
        
        if self.start_point is None or self.end_point is None:
            return None
        elif self.start_point.x() == self.end_point.x() or self.start_point.y() == self.end_point.y():
            return None

        return QgsRectangle(self.start_point, self.end_point)


    def deactivate(self):

        self.rubber_band.hide()
        QgsMapTool.deactivate(self)


    def activate(self):
        pass


    def reset_rubber_band(self):

        try:
            self.rubber_band.reset(2)
        except:
            pass

