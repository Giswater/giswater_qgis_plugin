"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import math
from qgis.PyQt.QtGui import QColor
from qgis.PyQt.QtWidgets import QApplication
from qgis.PyQt.QtCore import Qt
from qgis.core import QgsPointXY, QgsRectangle, QgsGeometry, QgsWkbTypes
from qgis.gui import QgsMapTool

from ..utils import tools_gw
from ... import global_vars
from ...libs import tools_qgis, tools_qt, tools_os
from ..utils.snap_manager import GwSnapManager
from .selection_mode import GwSelectionMode


class GwSelectManager(QgsMapTool):

    def __init__(self, class_object, table_object=None, dialog=None, selection_mode: GwSelectionMode = GwSelectionMode.DEFAULT, save_rectangle=False):
        """
        :param table_object: Class where we will look for @layers, @feature_type, @list_ids, etc
        :param table_object: (String)
        :param dialog: (QDialog)
        :param selection_mode: (GwSelectionMode)
        """

        self.class_object = class_object
        self.iface = global_vars.iface
        self.canvas = global_vars.canvas
        self.table_object = table_object
        self.dialog = dialog
        self.selection_mode = selection_mode
        self.save_rectangle = save_rectangle
        
        # Call superclass constructor and set current action
        QgsMapTool.__init__(self, self.canvas)

        self.snapper_manager = GwSnapManager(self.iface)

        self.rubber_band = tools_gw.create_rubberband(self.canvas, "line")
        self.rubber_band.setColor(QColor(255, 100, 255))
        self.rubber_band.setFillColor(QColor(254, 178, 76, 63))
        self.rubber_band.setWidth(2)
        self._reset_selection()
        self.selected_features = []

        tools_qgis.refresh_map_canvas()

    # region QgsMapTools inherited
    """ QgsMapTools inherited event functions """
    def canvasPressEvent(self, event):

        if event.button() == Qt.LeftButton:
            self.start_point = self.toMapCoordinates(event.pos())
            self.end_point = self.start_point
            self.is_emitting_point = True
            self._show_rectangle(self.start_point, self.end_point)
        elif event.button() == Qt.RightButton:
            # Right-click deletes/cancels the drawing
            self.rubber_band.hide()
            self.is_emitting_point = False
            self.start_point = None
            self.end_point = None

    def canvasReleaseEvent(self, event):

        self.is_emitting_point = False
        rectangle = self._get_rectangle()
        if self.save_rectangle:
            xmin = rectangle.xMinimum()
            xmax = rectangle.xMaximum()
            ymin = rectangle.yMinimum()
            ymax = rectangle.yMaximum()
            tools_qt.set_widget_text(self.save_rectangle, "txt_coordinates", f"{xmin},{xmax},{ymin},{ymax} [EPSG:25831]")
            self.rubber_band.hide()
            return
        selected_rectangle = None

        if QApplication.keyboardModifiers() in (Qt.ControlModifier, (Qt.ControlModifier | Qt.ShiftModifier)):
            unselect = True
        else:
            unselect = False

        if event.button() != Qt.LeftButton:
            self.rubber_band.hide()
            return

        # Reconnect signal to enhance process
        tools_qgis.disconnect_signal_selection_changed()
        tools_gw.connect_signal_selection_changed(self.class_object, self.dialog, self.table_object, self.selection_mode)
        for i, layer in enumerate(self.class_object.rel_layers[self.class_object.rel_feature_type]):
            # Selection by rectangle
            if rectangle:
                if selected_rectangle is None:
                    selected_rectangle = self.canvas.mapSettings().mapToLayerCoordinates(layer, rectangle)
                # If Ctrl or Ctrl+Shift clicked: remove features to selection
                if unselect:
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

        # Check system variable to keep drawing
        keep_drawing = tools_gw.get_config_parser('dialogs_actions', 'keep_drawing', "user", "init", prefix=False)
        keep_drawing = tools_os.set_boolean(keep_drawing, False)

        if keep_drawing:
            global_vars.canvas.setMapTool(GwSelectManager(self.class_object, self.table_object, self.dialog, self.selection_mode))
            cursor = tools_gw.get_cursor_multiple_selection()
            global_vars.canvas.setCursor(cursor)

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

    def keyPressEvent(self, event):
        """Handle keyboard input"""
        if event.key() == Qt.Key_Escape:
            # Escape key deletes/cancels the drawing
            self.rubber_band.hide()
            self.is_emitting_point = False
            self.start_point = None
            self.end_point = None

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
            tools_gw.reset_rubberband(self.rubber_band, "polygon")
        except Exception:
            pass

    # endregion


class GwPolygonSelectManager(QgsMapTool):
    """Polygon selection tool"""

    def __init__(self, class_object, table_object=None, dialog=None, selection_mode: GwSelectionMode = GwSelectionMode.DEFAULT):
        self.class_object = class_object
        self.iface = global_vars.iface
        self.canvas = global_vars.canvas
        self.table_object = table_object
        self.dialog = dialog
        self.selection_mode = selection_mode
        
        QgsMapTool.__init__(self, self.canvas)
        self.snapper_manager = GwSnapManager(self.iface)
        
        self.rubber_band = tools_gw.create_rubberband(self.canvas, "polygon")
        self.rubber_band.setColor(QColor(255, 100, 255))
        self.rubber_band.setFillColor(QColor(254, 178, 76, 63))
        self.rubber_band.setWidth(2)
        self.points = []
        self.is_drawing = False

        tools_qgis.refresh_map_canvas()

    def activate(self):
        """Activate the tool and preselect features."""
        pass

    def canvasPressEvent(self, event):
        if event.button() == Qt.LeftButton:
            point = self.toMapCoordinates(event.pos())
            self.points.append(point)
            self.is_drawing = True
            self._update_polygon()
        elif event.button() == Qt.RightButton:
            # Finish polygon and select
            self._finish_selection()

    def canvasMoveEvent(self, event):
        if self.is_drawing and self.points:
            # Show preview of polygon
            temp_points = self.points + [self.toMapCoordinates(event.pos())]
            self._draw_polygon(temp_points)

    def _update_polygon(self):
        if len(self.points) >= 2:
            self._draw_polygon(self.points)

    def _draw_polygon(self, points):
        self.rubber_band.reset(QgsWkbTypes.PolygonGeometry)
        for i, point in enumerate(points):
            self.rubber_band.addPoint(point, i == len(points) - 1)
        self.rubber_band.show()

    def _finish_selection(self):
        if len(self.points) < 3:
            return

        # Create polygon geometry
        polygon = QgsGeometry.fromPolygonXY([self.points])

        if QApplication.keyboardModifiers() in (Qt.ControlModifier, (Qt.ControlModifier | Qt.ShiftModifier)):
            unselect = True
        else:
            unselect = False
        
        # Reconnect signal
        tools_qgis.disconnect_signal_selection_changed()
        tools_gw.connect_signal_selection_changed(self.class_object, self.dialog, self.table_object, self.selection_mode)
        
        # Select features within polygon
        for layer in self.class_object.rel_layers[self.class_object.rel_feature_type]:
            
            if unselect:
                layer.selectByRect(polygon.boundingBox(), layer.RemoveFromSelection)
            else:
                layer.selectByRect(polygon.boundingBox(), layer.AddToSelection)

        # Clean up
        self.rubber_band.hide()
        self.points = []
        self.is_drawing = False

    def deactivate(self):
        self.rubber_band.hide()
        QgsMapTool.deactivate(self)

    def keyPressEvent(self, event):
        """Handle keyboard input"""
        if event.key() == Qt.Key_Escape:
            self.rubber_band.hide()
            self.points = []
            self.is_drawing = False


class GwCircleSelectManager(QgsMapTool):
    """Circle selection tool - Two-click method: first click for center, second click for radius"""

    def __init__(self, class_object, table_object=None, dialog=None, selection_mode: GwSelectionMode = GwSelectionMode.DEFAULT):
        self.class_object = class_object
        self.iface = global_vars.iface
        self.canvas = global_vars.canvas
        self.table_object = table_object
        self.dialog = dialog
        self.selection_mode = selection_mode
        
        QgsMapTool.__init__(self, self.canvas)
        self.snapper_manager = GwSnapManager(self.iface)
        
        # Create rubber band for circle outline
        self.rubber_band = tools_gw.create_rubberband(self.canvas, "polygon")
        self.rubber_band.setColor(QColor(255, 100, 255))
        self.rubber_band.setFillColor(QColor(254, 178, 76, 63))
        self.rubber_band.setWidth(2)
        
        # Create center point marker
        self.center_marker = tools_gw.create_rubberband(self.canvas, "point")
        self.center_marker.setColor(QColor(255, 0, 0))
        self.center_marker.setWidth(3)
        self.center_marker.setIconSize(8)
        
        self.center_point = None
        self.step = 0  # 0 = waiting for center, 1 = waiting for radius
        self.current_radius = 0

        tools_qgis.refresh_map_canvas()

    def activate(self):
        """Activate the tool and preselect features."""
        pass

    def canvasPressEvent(self, event):
        if event.button() == Qt.LeftButton:
            # First click: set center point
            self.center_point = self.toMapCoordinates(event.pos())
            
            # Show center point marker
            self.center_marker.reset()
            self.center_marker.addPoint(self.center_point)
            self.center_marker.show()

        elif event.button() == Qt.RightButton:
            # Right-click deletes/cancels the drawing
            self._clear_drawing()

    def canvasMoveEvent(self, event):
        if self.center_point:
            # Show preview circle while moving mouse
            current_point = self.toMapCoordinates(event.pos())
            self.current_radius = math.sqrt(
                (current_point.x() - self.center_point.x())**2 + 
                (current_point.y() - self.center_point.y())**2
            )
            self._draw_circle(self.center_point, self.current_radius)
            
            # Update status bar with radius info
            if hasattr(self.iface, 'statusBarIface'):
                radius_text = f"Circle radius: {self.current_radius:.2f} map units - Click to confirm"
                self.iface.statusBarIface().showMessage(radius_text, 0)

    def canvasReleaseEvent(self, event):
        # Consume all release events to prevent canvas panning
        if event.button() == Qt.LeftButton:
            # Second click: set radius and complete selection
            current_point = self.toMapCoordinates(event.pos())
            self.current_radius = math.sqrt(
                (current_point.x() - self.center_point.x())**2 + 
                (current_point.y() - self.center_point.y())**2
            )
            
            if self.current_radius > 0:
                self._finish_selection(self.center_point, self.current_radius)
            else:
                self._clear_drawing()

    def canvasDoubleClickEvent(self, event):
        # Not needed for two-click method
        pass

    def keyPressEvent(self, event):
        """Handle keyboard input"""
        if event.key() == Qt.Key_Escape:
            self._clear_drawing()
        elif event.key() == Qt.Key_Return or event.key() == Qt.Key_Enter:
            if self.step == 1 and self.center_point and self.current_radius > 0:
                self._finish_selection(self.center_point, self.current_radius)

    def _draw_circle(self, center, radius, segments=64):
        """Draw circle with more segments for smoother appearance"""
        if radius <= 0:
            return
            
        # Reset rubber band with polygon geometry type
        self.rubber_band.reset(QgsWkbTypes.PolygonGeometry)
        
        # Create circle points
        points = []
        for i in range(segments):
            angle = 2 * math.pi * i / segments
            x = center.x() + radius * math.cos(angle)
            y = center.y() + radius * math.sin(angle)
            points.append(QgsPointXY(x, y))
        
        # Create polygon geometry from points
        if points:
            circle_polygon = QgsGeometry.fromPolygonXY([points])
            self.rubber_band.setToGeometry(circle_polygon, None)
        
        self.rubber_band.show()

    def _finish_selection(self, center, radius, keep_visible=False):
        """Complete the circle selection"""
        if radius <= 0:
            self._clear_drawing()
            return
            
        # Create circle geometry using buffer
        circle_geom = QgsGeometry.fromPointXY(center).buffer(radius, 64)
        
        # Check if the selection is 
        if QApplication.keyboardModifiers() in (Qt.ControlModifier, (Qt.ControlModifier | Qt.ShiftModifier)):
            unselect = True
        else:
            unselect = False

        # Reconnect signal
        tools_qgis.disconnect_signal_selection_changed()
        tools_gw.connect_signal_selection_changed(self.class_object, self.dialog, self.table_object, self.selection_mode)
        
        # Select features within circle
        selected_count = 0
        for layer in self.class_object.rel_layers[self.class_object.rel_feature_type]:

            # First select by bounding box for efficiency
            if unselect:
                layer.selectByRect(circle_geom.boundingBox(), layer.RemoveFromSelection)
            else:
                layer.selectByRect(circle_geom.boundingBox(), layer.AddToSelection)

        # Show selection result in status bar
        if hasattr(self.iface, 'statusBarIface'):
            result_text = f"Selected {selected_count} features in circle (radius: {radius:.2f})"
            self.iface.statusBarIface().showMessage(result_text, 3000)

        # Clean up or keep visible
        if not keep_visible:
            self._clear_drawing()
        else:
            self.step = 0

    def _clear_drawing(self):
        """Clear all drawing elements"""
        self.rubber_band.hide()
        self.center_marker.hide()
        self.center_point = None
        self.current_radius = 0
        self.step = 0

    def deactivate(self):
        """Clean up when tool is deactivated"""
        self._clear_drawing()
        if hasattr(self.iface, 'statusBarIface'):
            self.iface.statusBarIface().clearMessage()
        QgsMapTool.deactivate(self)


class GwFreehandSelectManager(QgsMapTool):
    """Freehand drawing selection tool"""

    def __init__(self, class_object, table_object=None, dialog=None, selection_mode: GwSelectionMode = GwSelectionMode.DEFAULT):
        self.class_object = class_object
        self.iface = global_vars.iface
        self.canvas = global_vars.canvas
        self.table_object = table_object
        self.dialog = dialog
        self.selection_mode = selection_mode
        
        QgsMapTool.__init__(self, self.canvas)
        self.snapper_manager = GwSnapManager(self.iface)
        
        self.rubber_band = tools_gw.create_rubberband(self.canvas, "polygon")
        self.rubber_band.setColor(QColor(255, 100, 255))
        self.rubber_band.setFillColor(QColor(254, 178, 76, 63))
        self.rubber_band.setWidth(2)
        self.points = []
        self.is_drawing = False
        self.min_distance = 5.0  # Minimum distance between points in pixels

        tools_qgis.refresh_map_canvas()

    def activate(self):
        """Activate the tool and preselect features."""
        pass

    def canvasPressEvent(self, event):
        if event.button() == Qt.LeftButton:
            point = self.toMapCoordinates(event.pos())
            self.points = [point]  # Start new freehand path
            self.is_drawing = True
            self.rubber_band.reset(QgsWkbTypes.PolygonGeometry)
            self.rubber_band.addPoint(point, False)
            self.rubber_band.show()
        elif event.button() == Qt.RightButton:
            # Right-click deletes/cancels the drawing
            self.is_drawing = False
            self.rubber_band.hide()
            self.points = []

    def canvasMoveEvent(self, event):
        if self.is_drawing:
            current_point = self.toMapCoordinates(event.pos())
            
            # Only add point if it's far enough from the last point
            if self.points:
                last_point = self.points[-1]
                # Convert to screen coordinates to check pixel distance
                last_screen = self.toCanvasCoordinates(last_point)
                current_screen = event.pos()
                pixel_distance = ((current_screen.x() - last_screen.x())**2 + 
                                (current_screen.y() - last_screen.y())**2)**0.5
                
                if pixel_distance >= self.min_distance:
                    self.points.append(current_point)
                    self._update_rubber_band()
    
    def _update_rubber_band(self):
        """Update rubber band to show current freehand path as a filled polygon"""
        if len(self.points) >= 2:
            self.rubber_band.reset(QgsWkbTypes.PolygonGeometry)
            # Add all points to create the polygon outline
            for i, point in enumerate(self.points):
                self.rubber_band.addPoint(point, False)
            # Close the polygon by adding the first point again
            self.rubber_band.addPoint(self.points[0], True)
            self.rubber_band.show()

    def canvasReleaseEvent(self, event):
        if event.button() == Qt.LeftButton and self.is_drawing:
            self.is_drawing = False
            
            # Close the polygon if we have enough points
            if len(self.points) >= 3:
                # Final update to show closed polygon
                self._update_rubber_band()
                self._finish_selection()
            else:
                # Not enough points, clear the drawing
                self.rubber_band.hide()
                self.points = []

    def keyPressEvent(self, event):
        # Allow Escape key to cancel current drawing
        if event.key() == Qt.Key_Escape:
            self.is_drawing = False
            self.rubber_band.hide()
            self.points = []

    def _finish_selection(self):
        if len(self.points) < 3:
            return

        # Create polygon geometry from freehand points
        polygon = QgsGeometry.fromPolygonXY([self.points])

        if QApplication.keyboardModifiers() in (Qt.ControlModifier, (Qt.ControlModifier | Qt.ShiftModifier)):
            unselect = True
        else:
            unselect = False
        
        # Reconnect signal
        tools_qgis.disconnect_signal_selection_changed()
        tools_gw.connect_signal_selection_changed(self.class_object, self.dialog, self.table_object, self.selection_mode)
        
        # Select features within polygon
        for layer in self.class_object.rel_layers[self.class_object.rel_feature_type]:
            
            # First select by bounding box for efficiency
            if unselect:
                layer.selectByRect(polygon.boundingBox(), layer.RemoveFromSelection)
            else:
                layer.selectByRect(polygon.boundingBox(), layer.AddToSelection)

        # Clean up
        self.rubber_band.hide()
        self.points = []

    def deactivate(self):
        self.rubber_band.hide()
        self.is_drawing = False
        self.points = []
        QgsMapTool.deactivate(self)



