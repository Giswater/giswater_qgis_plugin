"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os

from qgis.core import QgsWkbTypes
from qgis.gui import QgsMapTool
from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtGui import QCursor, QColor, QIcon
from qgis.PyQt.QtWidgets import QAction

from ..utils import tools_gw
from ..utils.snap_manager import GwSnapManager
from ... import global_vars
from ...lib import tools_os


class GwMaptool(QgsMapTool):

    def __init__(self, icon_path, action_name, text, toolbar, action_group, icon_type=4):

        self.iface = global_vars.iface
        self.canvas = global_vars.canvas
        self.schema_name = global_vars.schema_name
        self.settings = global_vars.giswater_settings
        self.plugin_dir = global_vars.plugin_dir
        self.project_type = global_vars.project_type
        self.show_help = tools_gw.get_config_parser('system', 'show_help', "project", "giswater")
        self.layer_arc = None
        self.layer_connec = None
        self.layer_gully = None
        self.layer_node = None

        self.snapper_manager = GwSnapManager(self.iface)
        self.previous_snapping = self.snapper_manager.get_snapping_options()

        super().__init__(self.canvas)

        # Change map tool cursor
        self.cursor = QCursor()
        self.cursor.setShape(Qt.CrossCursor)

        # Get default cursor
        # noinspection PyCallingNonCallable
        self.std_cursor = self.parent().cursor()

        # Set default vertex marker
        self.vertex_marker = self.snapper_manager.vertex_marker
        self.snapper_manager.set_vertex_marker(self.vertex_marker, icon_type=icon_type)

        # Set default rubber band
        color = QColor(255, 100, 255)
        color_selection = QColor(254, 178, 76, 63)
        self.rubber_band = tools_gw.create_rubberband(self.canvas, 2)
        self.rubber_band.setColor(color)
        self.rubber_band.setFillColor(color_selection)
        self.rubber_band.setWidth(1)
        self.reset()
        self.force_active_layer = True

        if toolbar is None:
            return

        self.action = None

        icon = None
        if os.path.exists(icon_path):
            icon = QIcon(icon_path)
        if icon is None:
            self.action = QAction(text, action_group)
        else:
            self.action = QAction(icon, text, action_group)

        self.action.setObjectName(action_name)
        self.action.setCheckable(True)
        self.action.triggered.connect(self.clicked_event)
        toolbar.addAction(self.action)
        self.setAction(self.action)


    def clicked_event(self):

        selected_maptool = self.iface.mapCanvas().mapTool()
        self.prev_maptool = selected_maptool
        if not self == selected_maptool:
            self.iface.mapCanvas().setMapTool(self)


    def deactivate(self):

        # Uncheck button
        if hasattr(self.action, "setChecked"):  # If the maptool is activated through the giswater menu, it breaks
            self.action.setChecked(False)

        # Restore previous snapping
        self.snapper_manager.restore_snap_options(self.previous_snapping)

        # Enable snapping
        self.snapper_manager.set_snapping_status(True)

        # Recover cursor
        self.canvas.setCursor(self.std_cursor)

        # Remove highlight
        self.vertex_marker.hide()


    def canvasMoveEvent(self, event):

        # Make sure active layer is always 'v_edit_node'
        cur_layer = self.iface.activeLayer()
        if cur_layer != self.layer_node and self.force_active_layer:
            self.iface.setActiveLayer(self.layer_node)

        # Hide highlight and get coordinates
        self.vertex_marker.hide()
        event_point = self.snapper_manager.get_event_point(event)

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if result.isValid():
            self.snapper_manager.add_marker(result, self.vertex_marker)


    def keyPressEvent(self, event):

        if event.key() == Qt.Key_Escape:
            self.cancel_map_tool()
            return


    def canvasReleaseEvent(self, event):

        if event.button() == Qt.RightButton:
            self.cancel_map_tool()


    def recover_previus_maptool(self):

        if self.prev_maptool:
            self.iface.mapCanvas().setMapTool(self.prev_maptool)
            self.prev_maptool = None


    def set_action_pan(self):
        """ Set action 'Pan' """

        try:
            self.iface.actionPan().trigger()
        except Exception:
            pass


    def reset_rubber_band(self, geom_type="polygon"):

        if geom_type == "polygon":
            geom_type = QgsWkbTypes.PolygonGeometry
        elif geom_type == "line":
            geom_type = QgsWkbTypes.LineGeometry
        self.rubber_band.reset(geom_type)


    def reset(self):

        self.reset_rubber_band()
        self.snapped_feat = None


    def cancel_map_tool(self):
        """ Executed if user press right button or escape key """

        # Reset rubber band
        self.reset()

        # Deactivate map tool
        self.deactivate()

        # Set action pan
        self.set_action_pan()


    def refresh_map_canvas(self):
        """ Refresh all layers present in map canvas """

        self.canvas.refreshAllLayers()
        for layer_refresh in self.canvas.layers():
            layer_refresh.triggerRepaint()


    def manage_active_maptool(self):
        """ Check in init config file if user wants to keep map tool active or not """

        value = tools_gw.get_config_parser('user_edit_tricks', 'keep_maptool_active', "user", "init", prefix=True)
        keep_maptool_active = tools_os.set_boolean(value, False)
        if not keep_maptool_active:
            self.cancel_map_tool()

