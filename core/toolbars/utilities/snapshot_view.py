"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import json
import operator
import datetime
from functools import partial

from qgis.PyQt.QtCore import QDate, QDateTime
from qgis.PyQt.QtWidgets import QComboBox, QCheckBox, QDateEdit, QDoubleSpinBox, QSizePolicy, QGridLayout, QLabel, \
    QTextEdit, QLineEdit, QCompleter, QTabWidget, QWidget, QGroupBox, QMenu, QAction, QPushButton
from qgis.gui import QgsDateTimeEdit, QgsMapTool
from qgis.core import QgsRectangle
from PyQt5.QtCore import pyqtSignal

from ..dialog import GwAction
from ...ui.ui_manager import GwSnapshotViewUi
from ...utils import tools_gw
from ....libs import lib_vars, tools_qt, tools_db, tools_qgis

from ...utils.select_manager import GwSelectManager
from .... import global_vars

class GwSnapshotViewButton(GwAction):
    """ Button 68: Snapshot View """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)


    def clicked_event(self):

        self._open_snapshot_view()


    # region private functions

    def _open_snapshot_view(self):
        """ Get dialog """

        # Create form and body
        user = tools_db.current_user
        form = { "formName" : "generic", "formType" : "snapshot_view" }
        body = { "client" : { "cur_user": user }, "form" : form }

        # Execute procedure
        json_result = tools_gw.execute_procedure('gw_fct_get_dialog', body)

        # Create dialog
        self.dlg_snapshot_view = GwSnapshotViewUi(self)
        tools_gw.load_settings(self.dlg_snapshot_view)
        tools_gw.manage_dlg_widgets(self, self.dlg_snapshot_view, json_result)

        # Get dynamic widgets
        self.txt_coordinates = self.dlg_snapshot_view.findChild(QLineEdit, "tab_none_extension")
        self.btn_coordinate_actions = self.dlg_snapshot_view.findChild(QPushButton, "tab_none_btn_grid")
        self.date = self.dlg_snapshot_view.findChild(QWidget, "tab_none_date")

        # Set default date to current date
        self.date.setDateTime(QDateTime.currentDateTime())

        # Handle coordinate actions
        self._handle_coordinates_actions()

        # Hide gully checkbox if project type is not UD
        if self.project_type != 'ud':
            self.dlg_snapshot_view.findChild(QCheckBox, "tab_none_chk_gully").hide()
            self.dlg_snapshot_view.findChild(QLabel, "lbl_tab_none_chk_gully").hide()

        # Add icons
        tools_gw.add_icon(self.btn_coordinate_actions, "999")

        # Open form
        tools_gw.open_dialog(self.dlg_snapshot_view, 'snapshot_view')


    def _handle_coordinates_actions(self):
        """Populate the coordinates actions button with actions"""
        try:
            menu = QMenu(self.btn_coordinate_actions)
            dict_menu = {}

            # Exploitation
            action_expl = menu.addMenu(f"Calculate from Exploitation")
            dict_menu[f"Calculate from Exploitation"] = action_expl

            action_expl_1 = QAction('1 - expl_01', self.btn_coordinate_actions)
            action_expl_1.triggered.connect(partial(self._get_from_exploitation, '1'))
            dict_menu[f"Calculate from Exploitation - 1 - expl_01"] = action_expl_1
            dict_menu[f"Calculate from Exploitation"].addAction(action_expl_1)

            action_expl_2 = QAction('2 - expl_02', self.btn_coordinate_actions)
            action_expl_2.triggered.connect(partial(self._get_from_exploitation, '2'))
            dict_menu[f"Calculate from Exploitation - 2 - expl_02"] = action_expl_2
            dict_menu[f"Calculate from Exploitation"].addAction(action_expl_2)

            # Municipality
            action_muni = menu.addMenu(f"Calculate from Municipality")
            dict_menu[f"Calculate from Municipality"] = action_muni

            action_muni_1 = QAction('1 - Sant Boi del Llobregat', self.btn_coordinate_actions)
            action_muni_1.triggered.connect(partial(self._get_from_municipality, '1'))
            dict_menu[f"Calculate from Municipality - 1 - Sant Boi del Llobregat"] = action_muni_1
            dict_menu[f"Calculate from Municipality"].addAction(action_muni_1)

            action_muni_2 = QAction('2 - Sant Esteve de les Roures', self.btn_coordinate_actions)
            action_muni_2.triggered.connect(partial(self._get_from_municipality, '2'))
            dict_menu[f"Calculate from Municipality - 2 - Sant Esteve de les Roures"] = action_muni_2
            dict_menu[f"Calculate from Municipality"].addAction(action_muni_2)

            # Map Canvas Extent
            action_current = QAction('Use Current Map Canvas Extent', self.btn_coordinate_actions)
            action_current.triggered.connect(partial(self._get_canvas_extent))
            dict_menu[f"Use Current Map Canvas Extent"] = action_current
            menu.addAction(action_current)

            # Draw on map canvas
            action_draw = QAction('Draw on Map Canvas', self.btn_coordinate_actions)
            action_draw.triggered.connect(partial(self._draw_extent))
            dict_menu[f"Draw on Map Canvas"] = action_draw
            menu.addAction(action_draw)

            # Assign the menu to the button
            self.btn_coordinate_actions.setMenu(menu)

        except Exception as e:
            tools_qgis.show_warning(f"Failed to load layers: {e}", dialog=self.style_mng_dlg)

    def _get_from_exploitation(self, expl_id):

        sql = f"SELECT ST_Xmin(the_geom), ST_Xmax(the_geom), ST_Ymin(the_geom), ST_Ymax(the_geom) FROM exploitation where expl_id = {expl_id};"
        coordinates = tools_db.get_row(sql)
        tools_qt.set_widget_text(self.dlg_snapshot_view, self.txt_coordinates, f"{coordinates[0]},{coordinates[1]},{coordinates[2]},{coordinates[3]} [EPSG:25831]")

    def _get_from_municipality(self, muni_id):

        sql = f"SELECT ST_Xmin(the_geom), ST_Xmax(the_geom), ST_Ymin(the_geom), ST_Ymax(the_geom) FROM ext_municipality where muni_id = {muni_id};"
        coordinates = tools_db.get_row(sql)
        tools_qt.set_widget_text(self.dlg_snapshot_view, self.txt_coordinates, f"{coordinates[0]},{coordinates[1]},{coordinates[2]},{coordinates[3]} [EPSG:25831]")


    def _get_canvas_extent(self):

        canvas = self.iface.mapCanvas()
        extent = canvas.extent()

        xmin = extent.xMinimum()
        xmax = extent.xMaximum()
        ymin = extent.yMinimum()
        ymax = extent.yMaximum()

        tools_qt.set_widget_text(self.dlg_snapshot_view, self.txt_coordinates, f"{xmin},{xmax},{ymin},{ymax} [EPSG:25831]")


    def _draw_extent(self):

        select_manager = GwSelectManager(self, None, self.dlg_snapshot_view, False, self.dlg_snapshot_view)
        global_vars.canvas.setMapTool(select_manager)
        cursor = tools_gw.get_cursor_multiple_selection()
        global_vars.canvas.setCursor(cursor)


def close_dlg(**kwargs):
    """ Close form """

    dialog = kwargs["dialog"]
    tools_gw.close_dialog(dialog)

def open_grid(**kwargs):
    """ Close form """

    print("grid")


def run(**kwargs):
    """ Close form """

    print("run")