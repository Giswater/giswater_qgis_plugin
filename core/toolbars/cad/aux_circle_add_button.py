"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtGui import QDoubleValidator
from qgis.core import QgsFeature, QgsGeometry, QgsMapToPixel
from qgis.gui import QgsVertexMarker

from ..maptool import GwMaptool
from ...ui.ui_manager import GwAuxCircleUi
from ...utils import tools_gw
from ....lib import tools_qgis, tools_qt, tools_db


class GwAuxCircleAddButton(GwMaptool):
    """ Button 71: Add circle aux """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CROSS)
        self.cancel_circle = False
        self.layer_circle = None
        self.snap_to_selected_layer = False


    def cancel(self):

        tools_gw.close_dialog(self.dlg_create_circle)
        self.cancel_map_tool()
        if self.layer_circle:
            if self.layer_circle.isEditable():
                self.layer_circle.commitChanges()
        self.cancel_circle = True
        self.iface.setActiveLayer(self.current_layer)

    # region QgsMapTools inherited
    """ QgsMapTools inherited event functions """

    def keyPressEvent(self, event):

        if event.key() == Qt.Key_Escape:
            self.cancel_map_tool()
            self.iface.setActiveLayer(self.current_layer)
            return


    def canvasMoveEvent(self, event):

        # Hide marker and get coordinates
        self.vertex_marker.hide()
        event_point = self.snapper_manager.get_event_point(event)

        # Snapping
        if self.snap_to_selected_layer:
            result = self.snapper_manager.snap_to_current_layer(event_point)
        else:
            result = self.snapper_manager.snap_to_project_config_layers(event_point)

        # Add marker
        self.snapper_manager.add_marker(result, self.vertex_marker)


    def canvasReleaseEvent(self, event):

        self._add_aux_circle(event)


    def activate(self):

        tools_qgis.set_cursor_wait()
        try:
            # Load missing cad aux layers
            self._load_missing_layers()
        except Exception:
            pass
        tools_qgis.restore_cursor()

        self.snap_to_selected_layer = False
        # Check action. It works if is selected from toolbar. Not working if is selected from menu or shortcut keys
        if hasattr(self.action, "setChecked"):
            self.action.setChecked(True)

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Click on feature or any place on the map and set radius of a circle"
            tools_qgis.show_info(message)

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Get current layer
        self.current_layer = self.iface.activeLayer()

        self.layer_circle = tools_qgis.get_layer_by_tablename('v_edit_cad_auxcircle')
        if self.layer_circle is None:
            tools_qgis.show_warning("Layer not found", parameter='v_edit_cad_auxcircle')
            self.iface.actionPan().trigger()
            self.cancel_circle = True
            self.cancel_map_tool()
            self.iface.setActiveLayer(self.current_layer)
            return
        self.iface.setActiveLayer(self.layer_circle)

        # Check for default base layer
        self.vdefault_layer = None

        row = tools_gw.get_config_value('edit_cadtools_baselayer_vdefault')
        if row:
            self.snap_to_selected_layer = True
            self.vdefault_layer = tools_qgis.get_layer_by_tablename(row[0], True)
            if self.vdefault_layer:
                self.iface.setActiveLayer(self.vdefault_layer)

        if self.vdefault_layer is None:
            self.vdefault_layer = self.iface.activeLayer()


    def deactivate(self):

        self.snapper_manager.recover_snapping_options()
        # Call parent method
        super().deactivate()
        self.iface.setActiveLayer(self.current_layer)

    # endregion

    # region private functions

    def _load_missing_layers(self):
        """ Adds any missing Mincut layers to TOC """

        sql = f"SELECT id, alias FROM sys_table WHERE id LIKE 'v_edit_cad_aux%' AND alias IS NOT NULL"
        rows = tools_db.get_rows(sql)
        if rows:
            for tablename, alias in rows:
                lyr = tools_qgis.get_layer_by_tablename(tablename)
                if not lyr:
                    geom = f'geom_{alias.lower()}'
                    if tablename == 'v_edit_cad_auxcircle':
                        geom = 'geom_polygon'
                    tools_gw.add_layer_database(tablename, alias=alias, group="INVENTORY", sub_group="AUXILIAR", the_geom=geom)


    def _init_create_circle_form(self, point):

        # Create the dialog and signals
        self.dlg_create_circle = GwAuxCircleUi()
        tools_gw.load_settings(self.dlg_create_circle)
        self.cancel_circle = False
        validator = QDoubleValidator(0.00, 9999999.00, 3)
        validator.setNotation(QDoubleValidator().StandardNotation)
        self.dlg_create_circle.radius.setValidator(validator)

        self.dlg_create_circle.btn_accept.clicked.connect(partial(self._get_radius, point))
        self.dlg_create_circle.btn_cancel.clicked.connect(self.cancel)
        self.dlg_create_circle.radius.setFocus()

        tools_gw.open_dialog(self.dlg_create_circle, dlg_name='auxcircle')


    def _get_radius(self, point):

        self.radius = self.dlg_create_circle.radius.text()
        if not self.radius:
            self.radius = 0.1
        self.delete_prev = tools_qt.is_checked(self.dlg_create_circle, self.dlg_create_circle.chk_delete_prev)

        if self.layer_circle:
            self.layer_circle.startEditing()
            tools_gw.close_dialog(self.dlg_create_circle)
            if self.delete_prev:
                selection = self.layer_circle.getFeatures()
                self.layer_circle.selectByIds([f.id() for f in selection])
                if self.layer_circle.selectedFeatureCount() > 0:
                    features = self.layer_circle.selectedFeatures()
                    for feature in features:
                        self.layer_circle.deleteFeature(feature.id())

            if not self.cancel_circle:
                feature = QgsFeature()
                feature.setGeometry(QgsGeometry.fromPointXY(point).buffer(float(self.radius), 100))
                provider = self.layer_circle.dataProvider()
                # Next line generate: WARNING    Attribute index 0 out of bounds [0;0]
                # but all work ok
                provider.addFeatures([feature])

            self.layer_circle.commitChanges()
            self.layer_circle.dataProvider().reloadData()
            self.layer_circle.triggerRepaint()

        else:
            self.iface.actionPan().trigger()
            self.cancel_circle = False
            return


    def _add_aux_circle(self, event):

        if event.button() == Qt.LeftButton:

            # Get coordinates
            x = event.pos().x()
            y = event.pos().y()
            event_point = self.snapper_manager.get_event_point(event)

            # Create point with snap reference
            result = self.snapper_manager.snap_to_project_config_layers(event_point)
            point = self.snapper_manager.get_snapped_point(result)

            # Create point with mouse cursor reference
            if point is None:
                point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(), x, y)

            self._init_create_circle_form(point)

        elif event.button() == Qt.RightButton:
            self.snapper_manager.recover_snapping_options()
            self.iface.actionPan().trigger()
            self.cancel_circle = True
            self.cancel_map_tool()
            self.iface.setActiveLayer(self.current_layer)
            return

        if self.layer_circle:
            self.layer_circle.commitChanges()

    # endregion