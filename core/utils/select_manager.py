"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtGui import QColor
from qgis.PyQt.QtWidgets import QApplication
from qgis.core import QgsPointXY, QgsRectangle
from qgis.gui import QgsMapTool

from ..utils import tools_gw
from ... import global_vars
from ...lib import tools_qgis
from ..utils.snap_manager import GwSnapManager


class GwSelectManager(QgsMapTool):

    def __init__(self, class_object, table_object=None, dialog=None, query=None):
        """
        :param table_object: Class where we will look for @layers, @feature_type, @list_ids, etc
        :param table_object: (String)
        :param dialog: (QDialog)
        :param query: Used only for psectors
        """

        self.class_object = class_object
        self.iface = global_vars.iface
        self.canvas = global_vars.canvas
        self.table_object = table_object
        self.dialog = dialog
        self.query = query

        # Call superclass constructor and set current action
        QgsMapTool.__init__(self, self.canvas)

        self.snapper_manager = GwSnapManager(self.iface)

        self.rubber_band = tools_gw.create_rubberband(self.canvas, 2)
        self.rubber_band.setColor(QColor(255, 100, 255))
        self.rubber_band.setFillColor(QColor(254, 178, 76, 63))
        self.rubber_band.setWidth(1)
        self._reset_selection()
        self.selected_features = []


    # region QgsMapTools inherited
    """ QgsMapTools inherited event functions """
    def canvasPressEvent(self, event):

        if event.button() == Qt.LeftButton:
            self.start_point = self.toMapCoordinates(event.pos())
            self.end_point = self.start_point
            self.is_emitting_point = True
            self._show_rectangle(self.start_point, self.end_point)


    def canvasReleaseEvent(self, event):

        self.is_emitting_point = False
        rectangle = self._get_rectangle()
        selected_rectangle = None
        key = QApplication.keyboardModifiers()

        if event.button() != Qt.LeftButton:
            self.rubber_band.hide()
            return

        # Reconnect signal to enhance process
        tools_qgis.disconnect_signal_selection_changed()
        tools_gw.connect_signal_selection_changed(self.class_object, self.dialog, self.table_object, query=self.query)
        for i, layer in enumerate(self.class_object.layers[self.class_object.feature_type]):
            # Selection by rectangle
            if rectangle:
                if selected_rectangle is None:
                    selected_rectangle = self.canvas.mapSettings().mapToLayerCoordinates(layer, rectangle)
                # If Ctrl or Ctrl+Shift clicked: remove features to selection
                if key in (Qt.ControlModifier, (Qt.ControlModifier | Qt.ShiftModifier)):
                    layer.selectByRect(selected_rectangle, layer.RemoveFromSelection)
                # If not clicked: add features to selection
                else:
                    layer.selectByRect(selected_rectangle, layer.AddToSelection)

            # Selection one by one
            else:
                event_point = self.snapper_manager.get_event_point(event)
                result = self.snapper_manager.snap_to_project_config_layers(event_point)
                if result.isValid():
                    # Get the point. Leave selection
                    self.snapper_manager.get_snapped_feature(result, True)

        self.rubber_band.hide()


    def canvasMoveEvent(self, event):

        if not self.is_emitting_point:
            return

        self.end_point = self.toMapCoordinates(event.pos())
        self._show_rectangle(self.start_point, self.end_point)


    def deactivate(self):

        self.rubber_band.hide()
        QgsMapTool.deactivate(self)


    def activate(self):
        pass

    # endregion

    # region private functions

    def _reset_selection(self):
        """ Reset values """
        self.start_point = None
        self.end_point = None
        self.is_emitting_point = False
        self._reset_rubber_band()


    def _show_rectangle(self, start_point, end_point):

        self._reset_rubber_band()
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


    def _get_rectangle(self):

        if self.start_point is None or self.end_point is None:
            return None
        elif self.start_point.x() == self.end_point.x() or self.start_point.y() == self.end_point.y():
            return None

        return QgsRectangle(self.start_point, self.end_point)


    def _reset_rubber_band(self):

        try:
            tools_gw.reset_rubberband(self.rubber_band, 2)
        except Exception:
            pass

    # endregion




