"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: latin-1 -*-


try:
    from qgis.core import Qgis
except:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT < 29900:
    pass
else:
    from qgis.core import QgsPointXY
    from ..map_tools.snapping_utils_v3 import SnappingConfigManager


from functools import partial

from qgis.gui import QgsMapToolEmitPoint, QgsMapTip

from qgis.PyQt.QtCore import QTimer
from qgis.PyQt.QtWidgets import QAction, QLineEdit, QPushButton

from .api_parent import ApiParent
from ..ui_manager import ApiDimensioningUi

from .. import utils_giswater


class ApiDimensioning(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class constructor """

        ApiParent.__init__(self, iface, settings, controller, plugin_dir)
        self.iface = iface
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir

        self.canvas = self.iface.mapCanvas()
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)

        # Snapper
        self.snapper_manager = SnappingConfigManager(self.iface)
        self.snapper = self.snapper_manager.get_snapper()


    def open_form(self, new_feature=None):
        self.dlg_dim = ApiDimensioningUi()
        self.load_settings(self.dlg_dim)

        # Set signals
        actionSnapping = self.dlg_dim.findChild(QAction, "actionSnapping")
        actionSnapping.triggered.connect(self.snapping)
        self.set_icon(actionSnapping, "103")

        actionOrientation = self.dlg_dim.findChild(QAction, "actionOrientation")
        actionOrientation.triggered.connect(self.orientation)
        self.set_icon(actionOrientation, "133")

        self.dlg_dim.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_dim))
        self.dlg_dim.dlg_closed.connect(partial(self.save_settings, self.dlg_dim))

        # Set layers dimensions, node and connec
        self.layer_dimensions = self.controller.get_layer_by_tablename("v_edit_dimensions")
        self.layer_node = self.controller.get_layer_by_tablename("v_edit_node")
        self.layer_connec = self.controller.get_layer_by_tablename("v_edit_connec")

        self.create_map_tips()

        self.open_dialog(self.dlg_dim)
        return False, False


    def snapping(self):
        # Set active layer and set signals
        self.iface.setActiveLayer(self.layer_node)
        self.canvas.xyCoordinates.connect(self.mouse_move)
        self.emit_point.canvasClicked.connect(self.click_button_snapping)

    def mouse_move(self, point):

        # Hide marker and get coordinates
        self.snapper_manager.remove_marker()
        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_background_layers(event_point)
        if self.snapper_manager.result_is_valid():
            layer = self.snapper_manager.get_snapped_layer(result)
            # Check feature
            if layer == self.layer_node or layer == self.layer_connec:
                self.snapper_manager.add_marker(result)


    def click_button_snapping(self, point, btn):

        if not self.layer_dimensions:
            return

        layer = self.layer_dimensions
        self.iface.setActiveLayer(layer)
        layer.startEditing()

        # Get coordinates
        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_background_layers(event_point)
        if self.snapper_manager.result_is_valid():

            layer = self.snapper_manager.get_snapped_layer(result)
            # Check feature
            if layer == self.layer_node:
                feat_type = 'node'
            elif layer == self.layer_connec:
                feat_type = 'connec'
            else:
                return

            # Get the point
            snapped_feat = self.snapper_manager.get_snapped_feature(result)
            feature_id = self.snapper_manager.get_snapped_feature_id(result)
            element_id = snapped_feat.attribute(feat_type + '_id')

            # Leave selection
            layer.select([feature_id])

            # Get depth of the feature
            self.project_type = self.controller.get_project_type()
            if self.project_type == 'ws':
                fieldname = "depth"
            elif self.project_type == 'ud' and feat_type == 'node':
                fieldname = "ymax"
            elif self.project_type == 'ud' and feat_type == 'connec':
                fieldname = "connec_depth"

            sql = (f"SELECT {fieldname} "
                   f"FROM {feat_type} "
                   f"WHERE {feat_type}_id = '{element_id}'")
            row = self.controller.get_row(sql)
            if not row:
                return

            utils_giswater.setText(self.dlg_dim, "depth", row[0])
            utils_giswater.setText(self.dlg_dim, "feature_id", element_id)
            utils_giswater.setText(self.dlg_dim, "feature_type", feat_type.upper())


    def orientation(self):

        self.emit_point.canvasClicked.connect(self.click_button_orientation)


    def click_button_orientation(self, point):

        if not self.layer_dimensions:
            return

        self.x_symbol = self.dlg_dim.findChild(QLineEdit, "x_symbol")

        self.x_symbol.setText(str(int(point.x())))

        self.y_symbol = self.dlg_dim.findChild(QLineEdit, "y_symbol")
        self.y_symbol.setText(str(int(point.y())))


    def create_map_tips(self):
        """ Create MapTips on the map """

        sql = ("SELECT value FROM config_param_user "
               "WHERE cur_user = current_user AND parameter = 'dim_tooltip'")
        row = self.controller.get_row(sql)
        if not row or row[0].lower() != 'true':
            return

        self.timer_map_tips = QTimer(self.canvas)
        self.map_tip_node = QgsMapTip()
        self.map_tip_connec = QgsMapTip()

        self.canvas.xyCoordinates.connect(self.map_tip_changed)
        self.timer_map_tips.timeout.connect(self.show_map_tip)
        self.timer_map_tips_clear = QTimer(self.canvas)
        self.timer_map_tips_clear.timeout.connect(self.clear_map_tip)


    def map_tip_changed(self, point):
        """ SLOT. Initialize the Timer to show MapTips on the map """

        if self.canvas.underMouse():
            self.last_map_position = QgsPointXY(point.x(), point.y())
            self.map_tip_node.clear(self.canvas)
            self.map_tip_connec.clear(self.canvas)
            self.timer_map_tips.start(100)

    def show_map_tip(self):
        """ Show MapTips on the map """

        self.timer_map_tips.stop()
        if self.canvas.underMouse():
            point_qgs = self.last_map_position
            point_qt = self.canvas.mouseLastXY()
            if self.layer_node:
                self.map_tip_node.showMapTip(self.layer_node, point_qgs, point_qt, self.canvas)
            if self.layer_connec:
                self.map_tip_connec.showMapTip(self.layer_connec, point_qgs, point_qt, self.canvas)
            self.timer_map_tips_clear.start(1000)

    def clear_map_tip(self):
        """ Clear MapTips """

        self.timer_map_tips_clear.stop()
        self.map_tip_node.clear(self.canvas)
        self.map_tip_connec.clear(self.canvas)