"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtGui import QDoubleValidator, QColor
from qgis.core import QgsMapToPixel, QgsWkbTypes, QgsGeometry, QgsPoint, QgsPointXY, QgsSymbol
from qgis.gui import QgsVertexMarker, QgsRubberBand

from ..maptool import GwMaptool
from ...ui.ui_manager import GwAuxPointUi
from ...utils import tools_gw
from ....libs import lib_vars, tools_qgis, tools_qt, tools_db


class GwAuxPointAddButton(GwMaptool):
    """ Button 36: Add point aux """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CROSS)
        self.cancel_point = False
        self.layer_points = None
        self.point_1 = None
        self.point_2 = None
        self.snap_to_selected_layer = False
        # RUBBERBANDS TO PREVIEW RESULT
        # Background points & line
        self.rb_bg_point = tools_gw.create_rubberband(self.canvas, "point")
        self.rb_bg_point.setColor(QColor(0, 0, 0, 150))
        self.rb_bg_line = tools_gw.create_rubberband(self.canvas, "line")
        self.rb_bg_line.setLineStyle(Qt.DashLine)
        self.rb_bg_line.setColor(QColor(0, 0, 0, 150))
        # Start point from where it will calculate final point
        self.rb_start_point = tools_gw.create_rubberband(self.canvas, "point")
        self.rb_start_point.setColor(QColor(0, 0, 255, 100))
        self.rb_start_point.setWidth(5)
        # Final point calculated
        self.rb_final_point = tools_gw.create_rubberband(self.canvas, "point")
        self.rb_final_point.setColor(QColor(255, 0, 0, 150))
        self.rb_final_point.setWidth(3)
        self.rb_final_point.setIcon(QgsRubberBand.ICON_X)
        self.rb_final_point.setIconSize(10)


    def cancel(self):

        tools_gw.set_config_parser('btn_auxpoint', "rb_left", f"{self.dlg_create_point.rb_left.isChecked()}")
        tools_gw.set_config_parser('btn_auxpoint', "rb_right", f"{self.dlg_create_point.rb_right.isChecked()}")

        self._reset_rubberbands()
        tools_gw.close_dialog(self.dlg_create_point)
        self.iface.setActiveLayer(self.current_layer)
        if self.layer_points:
            if self.layer_points.isEditable():
                self.layer_points.commitChanges()
        self.cancel_point = True
        self.cancel_map_tool()


    # region QgsMapTools inherited
    """ QgsMapTools inherited event functions """

    def keyPressEvent(self, event):

        if event.key() == Qt.Key_Escape:
            self.cancel_map_tool()
            self.iface.setActiveLayer(self.current_layer)
            return


    def canvasMoveEvent(self, event):

        # Hide highlight and get coordinates
        self.vertex_marker.hide()
        event_point = self.snapper_manager.get_event_point(event)

        # Snapping
        if self.snap_to_selected_layer:
            result = self.snapper_manager.snap_to_current_layer(event_point)
        else:
            result = self.snapper_manager.snap_to_project_config_layers(event_point)

        if result.isValid():
            # Get the point and add marker on it
            self.snapper_manager.add_marker(result, self.vertex_marker)


    def canvasReleaseEvent(self, event):

        self._add_aux_point(event)


    def activate(self):

        tools_qgis.set_cursor_wait()
        try:
            # Load missing cad aux layers
            self._load_missing_layers()
        except Exception:
            pass
        tools_qgis.restore_cursor()

        self.snap_to_selected_layer = False
        # Get SRID
        self.srid = lib_vars.data_epsg

        # Check action. It works if is selected from toolbar. Not working if is selected from menu or shortcut keys
        if hasattr(self.action, "setChecked"):
            self.action.setChecked(True)

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Click on 2 places on the map, creating a line, then set the location of a point"
            tools_qgis.show_info(message)


        # Get current layer
        self.current_layer = self.iface.activeLayer()

        self.layer_points = tools_qgis.get_layer_by_tablename('v_edit_cad_auxpoint')
        if self.layer_points is None:
            tools_qgis.show_warning("Layer not found", parameter='v_edit_cad_auxpoint')
            self.cancel_map_tool()
            self.iface.setActiveLayer(self.current_layer)
            return
        self.iface.setActiveLayer(self.layer_points)

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

        self.point_1 = None
        self.point_2 = None
        self._reset_rubberbands()

        # Call parent method
        super().deactivate()
        self.iface.setActiveLayer(self.current_layer)
        try:
            self.iface.setActiveLayer(self.current_layer)
        except RuntimeError:
            pass


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


    def _init_create_point_form(self, point_1=None, point_2=None):

        # Create the dialog and signals
        self.dlg_create_point = GwAuxPointUi(self)
        tools_gw.load_settings(self.dlg_create_point)

        validator = QDoubleValidator(-99999.99, 9999999.00, 3)
        validator.setNotation(QDoubleValidator().StandardNotation)
        self.dlg_create_point.dist_x.setValidator(validator)
        validator = QDoubleValidator(-99999.99, 9999999.00, 3)
        validator.setNotation(QDoubleValidator().StandardNotation)
        self.dlg_create_point.dist_y.setValidator(validator)
        self.dlg_create_point.dist_x.textChanged.connect(partial(self._preview_point, self.dlg_create_point, point_1, point_2))
        self.dlg_create_point.dist_y.textChanged.connect(partial(self._preview_point, self.dlg_create_point, point_1, point_2))
        self.dlg_create_point.rb_left.toggled.connect(partial(self._preview_point, self.dlg_create_point, point_1, point_2))
        self.dlg_create_point.btn_accept.clicked.connect(partial(self._get_values, point_1, point_2))
        self.dlg_create_point.btn_cancel.clicked.connect(self.cancel)
        self.dlg_create_point.rejected.connect(self.cancel)

        if tools_gw.get_config_parser('btn_auxpoint', "rb_left", "user", "session") in ("True", True):
            self.dlg_create_point.rb_left.setChecked(True)
        elif tools_gw.get_config_parser('btn_auxpoint', "rb_right", "user", "session") in ("True", True):
            self.dlg_create_point.rb_right.setChecked(True)

        tools_gw.open_dialog(self.dlg_create_point, dlg_name='auxpoint')
        self.dlg_create_point.dist_x.setFocus()


    def _preview_point(self, dialog, point1, point2):

        tools_gw.reset_rubberband(self.rb_final_point, "point")

        value_x = tools_qt.get_text(dialog, 'dist_x')
        value_y = tools_qt.get_text(dialog, 'dist_y')
        try:
            distance_x = float(value_x)
        except ValueError as e:
            distance_x = 0.0
        try:
            distance_y = float(value_y)
        except ValueError as e:
            distance_y = 0.0

        if point1 is None or point2 is None:
            return

        start_from_point1 = dialog.rb_left.isChecked()
        if start_from_point1 in (None, True):
            start_point = point1
        else:
            start_point = point2

        tools_gw.reset_rubberband(self.rb_start_point, "point")

        self.rb_start_point.addPoint(start_point)

        # Calculate the vector from point1 to point2
        vector_x = point2.x() - point1.x()
        vector_y = point2.y() - point1.y()

        # Calculate the length of the vector
        vector_length = (vector_x ** 2 + vector_y ** 2) ** 0.5

        # Normalize the vector
        normalized_vector_x = vector_x / vector_length
        normalized_vector_y = vector_y / vector_length

        # Calculate the coordinates of the new point in the direction towards end_point
        new_point_x = start_point.x() + normalized_vector_x * distance_x
        new_point_y = start_point.y() + normalized_vector_y * distance_x

        # Calculate the unit vector of the line from start_point in the direction of the vector
        line_unit_vector_x = normalized_vector_x
        line_unit_vector_y = normalized_vector_y

        # Calculate the coordinates of the new point perpendicular to the line
        # (swap x and y components of the unit vector, then negate one of them)
        perpendicular_vector_x = -line_unit_vector_y
        perpendicular_vector_y = line_unit_vector_x

        new_point_x_perpendicular = new_point_x + perpendicular_vector_x * distance_y
        new_point_y_perpendicular = new_point_y + perpendicular_vector_y * distance_y

        preview_point = QgsPointXY(new_point_x_perpendicular, new_point_y_perpendicular)
        self.rb_final_point.addPoint(preview_point)


    def _get_values(self, point_1, point_2):

        tools_gw.set_config_parser('btn_auxpoint', "rb_left", f"{self.dlg_create_point.rb_left.isChecked()}")
        tools_gw.set_config_parser('btn_auxpoint', "rb_right", f"{self.dlg_create_point.rb_right.isChecked()}")

        self.dist_x = self.dlg_create_point.dist_x.text()
        if not self.dist_x:
            self.dist_x = 0
        self.dist_y = self.dlg_create_point.dist_y.text()
        if not self.dist_y:
            self.dist_y = 0

        self.delete_prev = tools_qt.is_checked(self.dlg_create_point, self.dlg_create_point.chk_delete_prev)
        if self.layer_points:
            self.layer_points.startEditing()
            tools_gw.close_dialog(self.dlg_create_point)
            if self.dlg_create_point.rb_left.isChecked():
                self.direction = 1
            else:
                self.direction = 2

            sql = f"SELECT ST_GeomFromText('POINT({point_1[0]} {point_1[1]})', {self.srid})"
            row = tools_db.get_row(sql)
            point_1 = row[0]
            sql = f"SELECT ST_GeomFromText('POINT({point_2[0]} {point_2[1]})', {self.srid})"
            row = tools_db.get_row(sql)
            point_2 = row[0]

            sql = (f"SELECT gw_fct_cad_add_relative_point "
                   f"('{point_1}', '{point_2}', {self.dist_x}, "
                   f"{self.dist_y}, {self.direction}, {self.delete_prev})")
            tools_db.execute_sql(sql)
            self.layer_points.commitChanges()
            self.layer_points.dataProvider().reloadData()
            self.layer_points.triggerRepaint()

        else:
            self.iface.actionPan().trigger()
            self.cancel_point = False
            return
        self._reset_rubberbands()


    def _add_aux_point(self, event):
        if event.button() == Qt.LeftButton:

            # Get coordinates
            x = event.pos().x()
            y = event.pos().y()
            event_point = self.snapper_manager.get_event_point(event)

            # Create point with snap reference
            result = self.snapper_manager.snap_to_project_config_layers(event_point)
            point = None
            if result.isValid():
                point = self.snapper_manager.get_snapped_point(result)

            # Create point with mouse cursor reference
            if point is None:
                point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(), x, y)

            if self.point_1 is None:
                self.point_1 = point
                tools_gw.reset_rubberband(self.rb_bg_line, "line")
                tools_gw.reset_rubberband(self.rb_bg_point, "point")
                self.rb_bg_point.addPoint(self.point_1)
            else:
                self.point_2 = point
                self.rb_bg_point.addPoint(self.point_2)

            if self.point_1 is not None and self.point_2 is not None:
                tools_gw.reset_rubberband(self.rb_bg_line, "line")

                p1 = QgsPoint(self.point_1)
                p2 = QgsPoint(self.point_2)
                self.rb_bg_line.addGeometry(QgsGeometry.fromPolyline([p1, p2]))
                # Create form
                self._init_create_point_form(self.point_1, self.point_2)
                # Restart points variables
                self.point_1 = None
                self.point_2 = None

        elif event.button() == Qt.RightButton:
            self._reset_rubberbands()
            self.cancel_map_tool()
            self.iface.setActiveLayer(self.current_layer)

        if self.layer_points:
            self.layer_points.commitChanges()


    def _reset_rubberbands(self):

        tools_gw.reset_rubberband(self.rb_bg_point, "point")
        tools_gw.reset_rubberband(self.rb_bg_line, "line")
        tools_gw.reset_rubberband(self.rb_start_point, "point")
        tools_gw.reset_rubberband(self.rb_final_point, "point")

    # endregion