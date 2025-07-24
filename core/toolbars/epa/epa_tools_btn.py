"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
from functools import partial
from typing import Optional
from pathlib import Path

from qgis.core import QgsProject
from qgis.PyQt.QtCore import QPoint
from qgis.PyQt.QtWidgets import QMenu, QAction, QActionGroup
from qgis.PyQt.QtGui import QIcon

from ..dialog import GwAction
from .... import global_vars
from ....libs import lib_vars, tools_qgis, tools_qt
from .epa_tools.anl_add_demand_check import AddDemandCheck
from .epa_tools.anl_recursive_go2epa import RecursiveEpa
from .epa_tools.anl_quantized_demands import QuantizedDemands
from .epa_tools.anl_valve_operation_check import ValveOperationCheck
from .epa_tools.cal_emitter import EmitterCalibration
from .epa_tools.cal_static import StaticCalibration
from .epa_tools.import_epanet import GwImportEpanet
from .epa_tools.import_swmm import GwImportSwmm
from .epa_tools.go2iber import Go2Iber


class GwEpaTools(GwAction):
    """ Button 46: Epa tools """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.iface = global_vars.iface

        # Create a menu and add all the actions
        self.menu = QMenu()
        self.menu.setObjectName("GW_epa_tools")
        self._fill_action_menu()

        if toolbar is not None:
            self.action.setMenu(self.menu)
            toolbar.addAction(self.action)

    def clicked_event(self):
        button = self.action.associatedWidgets()[1]
        menu_point = button.mapToGlobal(QPoint(0, button.height()))
        self.menu.exec(menu_point)

    def _fill_action_menu(self):
        """ Fill action menu """

        # disconnect and remove previuos signals and actions
        actions = self.menu.actions()
        for action in actions:
            action.disconnect()
            self.menu.removeAction(action)
            del action
        ag = QActionGroup(self.iface.mainWindow())

        anl_menu = self.menu.addMenu(tools_qt.tr("Analytics"))
        cal_menu = self.menu.addMenu(tools_qt.tr("Calibration"))

        new_actions = [
            (anl_menu, ('ws'), tools_qt.tr('Additional demand check'), None),
            (anl_menu, ('ud', 'ws'), tools_qt.tr('EPA multi calls'), None),
            (anl_menu, ('ws'), tools_qt.tr('Quantized demands'), None),
            (anl_menu, ('ws'), tools_qt.tr('Valve operation check'), None),
            (cal_menu, ('ws'), tools_qt.tr('Emitter calibration'), None),
            (cal_menu, ('ws'), tools_qt.tr('Static calibration'), None),
            (self.menu, ('ud', 'ws'), tools_qt.tr('Import INP file'), QIcon(f"{lib_vars.plugin_dir}{os.sep}icons{os.sep}toolbars{os.sep}epa{os.sep}22.png"))
        ]
        # Add Go2Iber action if ibergis plugin is available
        if tools_qgis.is_plugin_active('ibergis'):
            ibergis_menu = self.menu.addMenu(QIcon(f"{lib_vars.plugin_dir}{os.sep}icons{os.sep}toolbars{os.sep}epa{os.sep}47.png"), "IberGIS")
            new_actions.append((ibergis_menu, ('ud'), tools_qt.tr('Import IberGIS GPKG project'), None))

        for menu, types, action, icon in new_actions:
            if global_vars.project_type in types:
                if icon:
                    obj_action = QAction(icon, f"{action}", ag)
                else:
                    obj_action = QAction(f"{action}", ag)
                menu.addAction(obj_action)
                obj_action.triggered.connect(partial(self._get_selected_action, action))

        # Remove menu if it is empty
        for menu in self.menu.findChildren(QMenu):
            if not len(menu.actions()):
                menu.menuAction().setParent(None)

    def _get_selected_action(self, name):
        """ Gets selected action """

        if name == tools_qt.tr('Additional demand check'):
            add_demand_check = AddDemandCheck()
            add_demand_check.clicked_event()

        elif name == tools_qt.tr('EPA multi calls'):
            recursive_epa = RecursiveEpa()
            recursive_epa.clicked_event()

        elif name == tools_qt.tr('Emitter calibration'):
            emitter_calibration = EmitterCalibration()
            emitter_calibration.clicked_event()

        elif name == tools_qt.tr('Quantized demands'):
            quantized_demands = QuantizedDemands()
            quantized_demands.clicked_event()

        elif name == tools_qt.tr('Static calibration'):
            static_calibration = StaticCalibration()
            static_calibration.clicked_event()

        elif name == tools_qt.tr('Valve operation check'):
            valve_operation_check = ValveOperationCheck()
            valve_operation_check.clicked_event()

        elif name == tools_qt.tr('Import INP file'):
            if global_vars.project_type == 'ws':
                import_inp = GwImportEpanet()
                import_inp.clicked_event()
                return
            if global_vars.project_type == 'ud':
                import_inp = GwImportSwmm()
                import_inp.clicked_event()
                return

        elif name == tools_qt.tr('Import IberGIS GPKG project'):
            go2iber = Go2Iber()
            # Get file path from user
            file_path: Optional[Path] = self._get_file()
            if not file_path:
                return
            if os.path.exists(file_path):
                # Load project
                import_result = go2iber.load_project(file_path)
                if import_result:
                    msg = "IBERGIS project imported successfully"
                    tools_qgis.show_info(msg)
                else:
                    msg = "Error importing IBERGIS project"
                    tools_qgis.show_warning(msg)

    def _check_ibergis_project(self) -> bool:
        gpkg_path = tools_qgis.get_project_variable('project_gpkg_path')
        if not gpkg_path or not os.path.exists(f"{QgsProject.instance().absolutePath()}{os.sep}{gpkg_path}"):
            return False
        mandatory_layers = ['roof', 'ground', 'boundary_conditions']
        for tablename in mandatory_layers:
            if not tools_qgis.get_layer_by_tablename(tablename):
                return False

        return True

    def _get_file(self) -> Optional[Path]:
        """ Get the GPKG file path from the user. """
        file_path = tools_qt.get_file(
            "Select GPKG file", "", "GPKG files (*.gpkg)"
        )

        # Check if the file extension is .gpkg
        if file_path and file_path.suffix == ".gpkg":
            return file_path
        else:
            msg = "The file selected is not a GPKG file"
            tools_qgis.show_warning(msg)
            return
