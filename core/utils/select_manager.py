"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import math
from enum import Enum
from qgis.PyQt.QtGui import QColor
from qgis.PyQt.QtWidgets import QApplication
from qgis.PyQt.QtCore import Qt
from qgis.core import QgsPointXY, QgsRectangle, QgsGeometry, QgsWkbTypes, QgsVectorLayer
from qgis.gui import QgsMapTool

from ..utils import tools_gw
from ... import global_vars
from ...libs import tools_qgis, tools_qt, tools_os
from ..utils.snap_manager import GwSnapManager
from .selection_mode import GwSelectionMode


class GwSelectionType(Enum):
    """Enum for different selection types"""
    RECTANGLE = "rectangle"
    POLYGON = "polygon"
    CIRCLE = "circle"
    FREEHAND = "freehand"
    POINT = "point"  # Single point selection mode
    DEFAULT = "rectangle"  # Default to rectangle for backward compatibility


class GwSelectManager(QgsMapTool):

    def __init__(self, class_object, table_object=None, dialog=None, selection_mode: GwSelectionMode = GwSelectionMode.DEFAULT,
                 save_rectangle=False, selection_type: GwSelectionType = GwSelectionType.DEFAULT):
        """
        Unified selection manager supporting multiple selection types
        :param class_object: Class where we will look for @layers, @feature_type, @list_ids, etc
        :param table_object: (String)
        :param dialog: (QDialog)
        :param selection_mode: (GwSelectionMode)
        :param save_rectangle: (Boolean) Whether to save rectangle coordinates
        :param selection_type: (GwSelectionType) Type of selection tool to use
        """

        self.class_object = class_object
        self.iface = global_vars.iface
        self.canvas = global_vars.canvas
        self.table_object = table_object
        self.dialog = dialog
        self.selection_mode = selection_mode
        self.save_rectangle = save_rectangle
        self.selection_type = selection_type

        # Call superclass constructor and set current action
        QgsMapTool.__init__(self, self.canvas)

        self.snapper_manager = GwSnapManager(self.iface)

        # Initialize rubber bands for different selection types
        self._init_rubber_bands()

        # Common properties
        self.selected_features = []
        self._reset_selection()

    def _init_rubber_bands(self):
        """Initialize rubber bands based on selection type"""
        # Always use polygon type for rubber band to support filled rectangles
        self.rubber_band = tools_gw.create_rubberband(self.canvas, "polygon")

        self.rubber_band.setColor(QColor(255, 100, 255))
        self.rubber_band.setFillColor(QColor(254, 178, 76, 63))
        self.rubber_band.setWidth(2)

        # Additional rubber band for circle center marker
        if self.selection_type == GwSelectionType.CIRCLE:
            self.center_marker = tools_gw.create_rubberband(self.canvas, "point")
            self.center_marker.setColor(QColor(255, 0, 0))
            self.center_marker.setWidth(3)
            self.center_marker.setIconSize(8)

    # region QgsMapTools inherited
    """ QgsMapTools inherited event functions """
    def canvasPressEvent(self, event):
        if event.button() == Qt.LeftButton:
            point = self.toMapCoordinates(event.pos())

            if self.selection_type == GwSelectionType.POINT:
                self._handle_point_selection(event)
            elif self.selection_type in [GwSelectionType.RECTANGLE, GwSelectionType.DEFAULT]:
                self._handle_rectangle_press(point)
            elif self.selection_type == GwSelectionType.POLYGON:
                self._handle_polygon_press(point)
            elif self.selection_type == GwSelectionType.CIRCLE:
                self._handle_circle_press(point)
            elif self.selection_type == GwSelectionType.FREEHAND:
                self._handle_freehand_press(point)

        elif event.button() == Qt.RightButton:
            self._handle_right_click()

    def canvasReleaseEvent(self, event):
        if event.button() == Qt.LeftButton:
            if self.selection_type == GwSelectionType.POINT:
                # Point selection is handled in canvasPressEvent
                pass
            elif self.selection_type in [GwSelectionType.RECTANGLE, GwSelectionType.DEFAULT]:
                self._handle_rectangle_release(event)
            elif self.selection_type == GwSelectionType.CIRCLE:
                self._handle_circle_release(event)
            elif self.selection_type == GwSelectionType.FREEHAND:
                self._handle_freehand_release(event)
        else:
            self.rubber_band.hide()

    def canvasMoveEvent(self, event):
        point = self.toMapCoordinates(event.pos())

        if self.selection_type in [GwSelectionType.RECTANGLE, GwSelectionType.DEFAULT]:
            self._handle_rectangle_move(point)
        elif self.selection_type == GwSelectionType.POLYGON:
            self._handle_polygon_move(point)
        elif self.selection_type == GwSelectionType.CIRCLE:
            self._handle_circle_move(point)
        elif self.selection_type == GwSelectionType.FREEHAND:
            self._handle_freehand_move(event, point)

    def deactivate(self):
        self.rubber_band.hide()
        if hasattr(self, 'center_marker'):
            self.center_marker.hide()
        if hasattr(self.iface, 'statusBarIface'):
            self.iface.statusBarIface().clearMessage()
        QgsMapTool.deactivate(self)

    def activate(self):
        pass

    def keyPressEvent(self, event):
        """Handle keyboard input"""
        if event.key() == Qt.Key_Escape:
            self._clear_drawing()
        elif event.key() in (Qt.Key_Return, Qt.Key_Enter):
            if self.selection_type == GwSelectionType.CIRCLE and hasattr(self, 'center_point') and self.center_point:
                self._finish_circle_selection(self.center_point, getattr(self, 'current_radius', 0))

    # endregion

    # region private functions

    def _reset_selection(self):
        """Reset values for all selection types"""
        # Rectangle/Default
        self.start_point = None
        self.end_point = None
        self.is_emitting_point = False

        # Polygon
        self.points = []
        self.is_drawing = False

        # Circle
        self.center_point = None
        self.current_radius = 0

        # Freehand
        self.min_distance = 5.0

        self._reset_rubber_band()

    def _clear_drawing(self):
        """Clear all drawing elements"""
        self.rubber_band.hide()
        if hasattr(self, 'center_marker'):
            self.center_marker.hide()
        self._reset_selection()

    def _reset_rubber_band(self):
        try:
            # Always use polygon type for rubber band
            tools_gw.reset_rubberband(self.rubber_band, "polygon")
        except Exception:
            pass

    # Rectangle selection handlers
    def _handle_rectangle_press(self, point):
        self.start_point = point
        self.end_point = self.start_point
        self.is_emitting_point = True
        self._show_rectangle(self.start_point, self.end_point)

    def _handle_rectangle_move(self, point):
        if not self.is_emitting_point:
            return
        self.end_point = point
        self._show_rectangle(self.start_point, self.end_point)

    def _handle_rectangle_release(self, event):
        self.is_emitting_point = False
        rectangle = self._get_rectangle()

        if self.save_rectangle and rectangle:
            xmin = rectangle.xMinimum()
            xmax = rectangle.xMaximum()
            ymin = rectangle.yMinimum()
            ymax = rectangle.yMaximum()
            tools_qt.set_widget_text(self.save_rectangle, "txt_coordinates", f"{xmin},{xmax},{ymin},{ymax} [EPSG:25831]")
            self.rubber_band.hide()
            return

        if event.button() != Qt.LeftButton:
            self.rubber_band.hide()
            return

        self._perform_selection(rectangle, event)

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

    # Polygon selection handlers
    def _handle_polygon_press(self, point):
        self.points.append(point)
        self.is_drawing = True
        self._update_polygon()

    def _handle_polygon_move(self, point):
        if self.is_drawing and self.points:
            temp_points = self.points + [point]
            self._draw_polygon(temp_points)

    def _update_polygon(self):
        if len(self.points) >= 2:
            self._draw_polygon(self.points)

    def _draw_polygon(self, points):
        self.rubber_band.reset(QgsWkbTypes.PolygonGeometry)
        for i, point in enumerate(points):
            self.rubber_band.addPoint(point, i == len(points) - 1)
        self.rubber_band.show()

    # Circle selection handlers
    def _handle_circle_press(self, point):
        self.center_point = point
        if hasattr(self, 'center_marker'):
            self.center_marker.reset()
            self.center_marker.addPoint(self.center_point)
            self.center_marker.show()

    def _handle_circle_move(self, point):
        if self.center_point:
            self.current_radius = math.sqrt(
                (point.x() - self.center_point.x())**2 +
                (point.y() - self.center_point.y())**2
            )
            self._draw_circle(self.center_point, self.current_radius)

            if hasattr(self.iface, 'statusBarIface'):
                radius_text = f"Circle radius: {self.current_radius:.2f} map units - Click to confirm"
                self.iface.statusBarIface().showMessage(radius_text, 0)

    def _handle_circle_release(self, event):
        if self.center_point:
            current_point = self.toMapCoordinates(event.pos())
            self.current_radius = math.sqrt(
                (current_point.x() - self.center_point.x())**2 +
                (current_point.y() - self.center_point.y())**2
            )

            if self.current_radius > 0:
                self._finish_circle_selection(self.center_point, self.current_radius)
            else:
                self._clear_drawing()

    def _draw_circle(self, center, radius, segments=64):
        if radius <= 0:
            return

        self.rubber_band.reset(QgsWkbTypes.PolygonGeometry)

        points = []
        for i in range(segments):
            angle = 2 * math.pi * i / segments
            x = center.x() + radius * math.cos(angle)
            y = center.y() + radius * math.sin(angle)
            points.append(QgsPointXY(x, y))

        if points:
            circle_polygon = QgsGeometry.fromPolygonXY([points])
            self.rubber_band.setToGeometry(circle_polygon, None)

        self.rubber_band.show()

    def _finish_circle_selection(self, center, radius):
        if radius <= 0:
            self._clear_drawing()
            return

        circle_geom = QgsGeometry.fromPointXY(center).buffer(radius, 64)
        self._perform_geometry_selection(circle_geom)

        if hasattr(self.iface, 'statusBarIface'):
            result_text = f"Circle selection completed (radius: {radius:.2f})"
            self.iface.statusBarIface().showMessage(result_text, 3000)

        self._clear_drawing()

    # Freehand selection handlers
    def _handle_freehand_press(self, point):
        self.points = [point]
        self.is_drawing = True
        self.rubber_band.reset(QgsWkbTypes.PolygonGeometry)
        self.rubber_band.addPoint(point, False)
        self.rubber_band.show()

    def _handle_freehand_move(self, event, point):
        if self.is_drawing and self.points:
            last_point = self.points[-1]
            last_screen = self.toCanvasCoordinates(last_point)
            current_screen = event.pos()
            pixel_distance = ((current_screen.x() - last_screen.x())**2 +
                            (current_screen.y() - last_screen.y())**2)**0.5

            if pixel_distance >= self.min_distance:
                self.points.append(point)
                self._update_freehand_rubber_band()

    def _handle_freehand_release(self, event):
        if self.is_drawing:
            self.is_drawing = False

            if len(self.points) >= 3:
                self._update_freehand_rubber_band()
                self._finish_freehand_selection()
            else:
                self.rubber_band.hide()
                self.points = []

    def _update_freehand_rubber_band(self):
        if len(self.points) >= 2:
            self.rubber_band.reset(QgsWkbTypes.PolygonGeometry)
            for i, point in enumerate(self.points):
                self.rubber_band.addPoint(point, False)
            self.rubber_band.addPoint(self.points[0], True)
            self.rubber_band.show()

    def _finish_freehand_selection(self):
        if len(self.points) < 3:
            return

        polygon = QgsGeometry.fromPolygonXY([self.points])
        self._perform_geometry_selection(polygon)

        self.rubber_band.hide()
        self.points = []

    # Right click handler
    def _handle_point_selection(self, event):
        """Handle point selection mode - select features by clicking on them"""
        # Check modifier keys
        ctrl_pressed = QApplication.keyboardModifiers() & Qt.ControlModifier
        shift_pressed = QApplication.keyboardModifiers() & Qt.ShiftModifier

        # Determine selection behavior
        if ctrl_pressed and shift_pressed:
            behavior = QgsVectorLayer.RemoveFromSelection
        elif ctrl_pressed and not shift_pressed:
            behavior = QgsVectorLayer.AddToSelection
        else:
            behavior = QgsVectorLayer.SetSelection

        # Get snapped feature
        event_point = self.snapper_manager.get_event_point(event)
        result = self.snapper_manager.snap_to_project_config_layers(event_point)

        # Connect selection changed signal
        tools_qgis.disconnect_signal_selection_changed()
        tools_gw.connect_signal_selection_changed(self.class_object, self.dialog, self.table_object, self.selection_mode)

        if result.isValid():
            # Get the layer and feature ID
            layer = result.layer()
            feature_id = result.featureId()

            # Apply selection
            if behavior == QgsVectorLayer.SetSelection:
                # Clear all selections first
                for lyr in self.class_object.rel_layers[self.class_object.rel_feature_type]:
                    lyr.removeSelection()
                # Then select the new feature
                layer.select([feature_id])
            elif behavior == QgsVectorLayer.AddToSelection:
                layer.select([feature_id])
            else:  # RemoveFromSelection
                layer.deselect([feature_id])

        self._check_keep_drawing()

    def _handle_right_click(self):
        if self.selection_type == GwSelectionType.POLYGON and len(self.points) >= 3:
            self._finish_polygon_selection()
        else:
            self._clear_drawing()

    def _finish_polygon_selection(self):
        if len(self.points) < 3:
            return

        polygon = QgsGeometry.fromPolygonXY([self.points])
        self._perform_geometry_selection(polygon)

        self.rubber_band.hide()
        self.points = []
        self.is_drawing = False

    # Common selection methods
    def _perform_selection(self, rectangle=None, event=None):
        """Perform selection for rectangle or point selection"""
        # Check modifier keys
        ctrl_pressed = QApplication.keyboardModifiers() & Qt.ControlModifier
        shift_pressed = QApplication.keyboardModifiers() & Qt.ShiftModifier

        # Determine selection behavior:
        # Ctrl+Shift = Remove from selection
        # Ctrl only = Add to existing selection
        # No modifiers = Replace selection (clear previous and select new)
        if ctrl_pressed and shift_pressed:
            selection_behavior = "remove"
        elif ctrl_pressed and not shift_pressed:
            selection_behavior = "add"
        else:
            selection_behavior = "replace"

        tools_qgis.disconnect_signal_selection_changed()
        tools_gw.connect_signal_selection_changed(self.class_object, self.dialog, self.table_object, self.selection_mode)

        if rectangle:
            selected_rectangle = None
            for layer in self.class_object.rel_layers[self.class_object.rel_feature_type]:
                if selected_rectangle is None:
                    selected_rectangle = self.canvas.mapSettings().mapToLayerCoordinates(layer, rectangle)

                if selection_behavior == "remove":
                    layer.selectByRect(selected_rectangle, layer.RemoveFromSelection)
                elif selection_behavior == "add":
                    layer.selectByRect(selected_rectangle, layer.AddToSelection)
                else:  # replace
                    layer.selectByRect(selected_rectangle, layer.SetSelection)
        else:
            # Point selection
            if event:
                event_point = self.snapper_manager.get_event_point(event)
                result = self.snapper_manager.snap_to_project_config_layers(event_point)
                if result.isValid():
                    self.snapper_manager.get_snapped_feature(result, True)

        self.rubber_band.hide()
        self._check_keep_drawing()

    def _perform_geometry_selection(self, geometry):
        """Perform selection using geometry (for polygon, circle, freehand)"""
        # Check modifier keys
        ctrl_pressed = QApplication.keyboardModifiers() & Qt.ControlModifier
        shift_pressed = QApplication.keyboardModifiers() & Qt.ShiftModifier

        # Determine selection behavior:
        # Ctrl+Shift = Remove from selection
        # Ctrl only = Add to existing selection
        # No modifiers = Replace selection (clear previous and select new)
        if ctrl_pressed and shift_pressed:
            behavior = QgsVectorLayer.RemoveFromSelection
        elif ctrl_pressed and not shift_pressed:
            behavior = QgsVectorLayer.AddToSelection
        else:
            behavior = QgsVectorLayer.SetSelection

        tools_qgis.disconnect_signal_selection_changed()
        tools_gw.connect_signal_selection_changed(self.class_object, self.dialog, self.table_object, self.selection_mode)

        wkt = geometry.asWkt()

        for layer in self.class_object.rel_layers[self.class_object.rel_feature_type]:
            layer.selectByExpression(f"intersects($geometry, geom_from_wkt('{wkt}'))", behavior)

        self._check_keep_drawing()

    def _check_keep_drawing(self):
        """Check if we should keep the drawing tool active"""
        keep_drawing = tools_gw.get_config_parser('dialogs_actions', 'keep_drawing', "user", "init", prefix=False)
        keep_drawing = tools_os.set_boolean(keep_drawing, False)

        if keep_drawing:
            global_vars.canvas.setMapTool(GwSelectManager(
                self.class_object, self.table_object, self.dialog,
                self.selection_mode, self.save_rectangle, self.selection_type
            ))
            cursor = tools_gw.get_cursor_multiple_selection()
            global_vars.canvas.setCursor(cursor)

    # endregion


# Backward compatibility aliases for existing code
def GwPolygonSelectManager(*args, **kwargs):
    return GwSelectManager(*args, **kwargs, selection_type=GwSelectionType.POLYGON)


def GwCircleSelectManager(*args, **kwargs):
    return GwSelectManager(*args, **kwargs, selection_type=GwSelectionType.CIRCLE)


def GwFreehandSelectManager(*args, **kwargs):
    return GwSelectManager(*args, **kwargs, selection_type=GwSelectionType.FREEHAND)


def GwPointSelectManager(*args, **kwargs):
    return GwSelectManager(*args, **kwargs, selection_type=GwSelectionType.POINT)