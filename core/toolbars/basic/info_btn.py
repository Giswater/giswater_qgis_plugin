"""This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
import re
import json
from functools import partial

from qgis.PyQt.QtCore import QPoint, Qt, QTimer
from qgis.PyQt.QtGui import QColor, QCursor, QIcon
from qgis.PyQt.QtWidgets import QAction, QCheckBox, QHBoxLayout, QMenu, QWidget, QWidgetAction
from qgis.core import QgsApplication, QgsGeometry, QgsPointXY

from ...shared.info import GwInfo
from ..maptool import GwMaptool
from ...threads.toggle_valve_state import GwToggleValveTask
from ...utils import tools_gw
from .... import global_vars
from ....libs import lib_vars, tools_db, tools_qgis, tools_os, tools_qt


class GwInfoButton(GwMaptool):
    """Button 01: Info"""

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)

        self.rubber_band = tools_gw.create_rubberband(global_vars.canvas)
        self.tab_type = None
        # Used when the signal 'signal_activate' is emitted from the info, do not open another form
        self.block_signal = False
        self.previous_info_feature = None
        self.action_name = action_name

    # region QgsMapTools inherited
    """ QgsMapTools inherited event functions """

    def keyPressEvent(self, event):  # noqa: N802

        if event.key() == Qt.Key.Key_Escape:
            for rb in self.rubberband_list:
                tools_gw.reset_rubberband(rb)
            tools_gw.reset_rubberband(self.rubber_band)
            self.action.trigger()
            return

    def canvasMoveEvent(self, event):  # noqa: N802
        pass

    def canvasReleaseEvent(self, event):  # noqa: N802

        self._get_info(event)

    def activate(self):

        # Check action. It works if is selected from toolbar. Not working if is selected from menu or shortcut keys
        if hasattr(self.action, "setChecked"):
            self.action.setChecked(True)
        # Change map tool cursor
        self.cursor = QCursor()
        self.cursor.setShape(Qt.CursorShape.WhatsThisCursor)
        self.canvas.setCursor(self.cursor)
        self.rubberband_list = []
        self.tab_type = "data"

    def deactivate(self):

        if hasattr(self, "rubberband_list"):
            for rb in self.rubberband_list:
                tools_gw.reset_rubberband(rb)
        if hasattr(self, "dlg_info_feature"):
            tools_gw.reset_rubberband(self.rubber_band)

        super().deactivate()

    # endregion

    # region private functions

    def _reactivate_map_tool(self):
        """Reactivate tool"""
        self.block_signal = True
        info_action = self.iface.mainWindow().findChildren(QAction, self.action_name)[-1]
        info_action.trigger()

    def _reset_rubber_bands(self):
        for rb in self.rubberband_list:
            tools_gw.reset_rubberband(rb)
        if hasattr(self, "rubber_band"):
            tools_qgis.reset_rubber_band(self.rubber_band)

    def _get_layers_from_coordinates(self, point, rb_list, tab_type=None):

        cursor = QCursor()
        x = cursor.pos().x()
        y = cursor.pos().y()
        click_point = QPoint(x + 5, y + 5)

        visible_layers = tools_qgis.get_visible_layers(as_str_list=True)
        scale_zoom = self.iface.mapCanvas().scale()

        # Get layers under mouse clicked
        extras = f'"pointClickCoords":{{"xcoord":{point.x()}, "ycoord":{point.y()}}}, '
        extras += f'"visibleLayers":{visible_layers}, '
        extras += f'"zoomScale":{scale_zoom} '
        body = tools_gw.create_body(extras=extras)
        json_result = tools_gw.execute_procedure("gw_fct_getlayersfromcoordinates", body, rubber_band=self.rubber_band)
        if not json_result or json_result["status"] == "Failed":
            return False

        # hide QMenu identify if no feature under mouse
        len_layers = len(json_result["body"]["data"]["layersNames"])
        if len_layers == 0:
            return False

        self.icon_folder = self.plugin_dir + "/icons/dialogs/"

        # Right click main QMenu
        main_menu = QMenu()

        # Create one menu for each layer
        for layer in json_result["body"]["data"]["layersNames"]:
            layer_name = tools_qgis.get_layer_by_tablename(layer["layerName"])
            icon_path = self.icon_folder + layer["icon"] + ".png"
            if os.path.exists(str(icon_path)):
                icon = QIcon(icon_path)
                sub_menu = main_menu.addMenu(icon, layer_name.name())
            else:
                sub_menu = main_menu.addMenu(layer_name.name())
            # Create one QAction for each id
            for feature in layer["ids"]:
                if "label" in feature:
                    label = str(feature["label"])
                else:
                    label = str(feature["id"])

                # If plan_psector_data exists, create a submenu for this feature
                if "plan_psector_data" in feature and feature["plan_psector_data"] is not None:
                    psector_menu = sub_menu.addMenu(label)
                    # Add main feature action in submenu
                    main_action = QAction(label, None)
                    main_action.setProperty("feature_id", str(feature["id"]))
                    main_action.setProperty("layer_name", layer_name.name())
                    psector_menu.addAction(main_action)
                    main_action.triggered.connect(partial(self._get_info_from_selected_id, main_action, tab_type))
                    main_action.hovered.connect(partial(self._draw_by_action, feature, rb_list))
                    # Store reference to main action in menu property for restoration
                    psector_menu.setProperty("main_action", main_action)
                    psector_menu.setProperty("main_action_label", label)
                    psector_menu.setProperty("feature_id", str(feature["id"]))
                    psector_menu.setProperty("layer_name", layer_name.name())
                    psector_menu.setProperty("tab_type", tab_type)

                    # Add separator
                    psector_menu.addSeparator()

                    # Add psector info actions (informational only)
                    # Handle both single object and array of psector_data
                    psector_data = feature["plan_psector_data"]
                    psector_list = psector_data if isinstance(psector_data, list) else [psector_data]

                    for idx, psector_item in enumerate(psector_list):
                        # Add separator between multiple psectors (except before the first one)
                        if idx > 0:
                            psector_menu.addSeparator()

                        if "name" in psector_item:
                            if "psector_id" in psector_item:
                                # Check if psector exists in selector_psector
                                sql = "SELECT psector_id FROM selector_psector WHERE psector_id = %s AND cur_user = current_user"
                                row = tools_db.get_row(sql, params=(psector_item["psector_id"],), log_info=False)
                                is_in_selector = row is not None
                                # Create QCheckBox widget for psector
                                label = f"{psector_item['psector_id']} - {psector_item['name']}"
                                checkbox = QCheckBox(label)
                                if psector_item["active"] is False:
                                    checkbox.setStyleSheet("QCheckBox {color: #E9E7E3;}")
                                container = QWidget(psector_menu)
                                layout = QHBoxLayout(container)
                                layout.setContentsMargins(10, 4, 10, 4)
                                layout.addWidget(checkbox)
                                checkbox.setChecked(is_in_selector)
                                checkbox.setProperty("psector_id", psector_item["psector_id"])
                                # Store reference to menu in checkbox property
                                checkbox.setProperty("psector_menu", psector_menu)
                                # Connect checkbox stateChanged to function that updates selector_psector
                                checkbox.stateChanged.connect(partial(self._toggle_psector_selector, psector_item["psector_id"]))
                                # Create QWidgetAction to embed checkbox in menu
                                widget_action = QWidgetAction(psector_menu)
                                widget_action.setDefaultWidget(container)
                                psector_menu.addAction(widget_action)
                            else:
                                label = f"{psector_item['name']}"
                                info_action = psector_menu.addAction(label)
                                info_action.setEnabled(False)
                                info_action.hovered.connect(partial(self._draw_by_action, feature, rb_list))
                else:
                    # No plan_psector_data, add action directly
                    action = QAction(label, None)
                    action.setProperty("feature_id", str(feature["id"]))
                    action.setProperty("layer_name", layer_name.name())
                    sub_menu.addAction(action)
                    action.triggered.connect(partial(self._get_info_from_selected_id, action, tab_type))
                    action.hovered.connect(partial(self._draw_by_action, feature, rb_list))

        main_menu.addSeparator()
        # Identify all
        cont = 0
        for layer in json_result["body"]["data"]["layersNames"]:
            cont += len(layer["ids"])
        action = QAction(f"{tools_qt.tr('Identify all')} ({cont})", None)
        action.hovered.connect(partial(self._identify_all, json_result, rb_list))
        main_menu.addAction(action)
        main_menu.addSeparator()

        # Open/close valve
        valve = json_result["body"]["data"].get("valve")
        if valve:
            valve_id = valve["id"]
            valve_text = valve["text"]
            valve_table = valve["tableName"]
            valve_value = valve["value"]
            action_valve = QAction(f"{valve_text}", None)
            action_valve.triggered.connect(partial(self._toggle_valve_state, valve_id, valve_table, valve_value))
            action_valve.hovered.connect(partial(self._reset_rubber_bands))
            main_menu.addAction(action_valve)
            main_menu.addSeparator()

        # Open/close valve in netscenario
        valve_netscenario = json_result["body"]["data"].get("valve_netscenario")
        if valve_netscenario:
            valve_netscenario_id = valve_netscenario["id"]
            netscenario_id = valve_netscenario["netscenario_id"]
            valve_netscenario_text = valve_netscenario["text"]
            valve_netscenario_table = valve_netscenario["tableName"]
            valve_netscenario_value = valve_netscenario["value"]
            action_valve_netscenario = QAction(f"{valve_netscenario_text}", None)
            if valve_netscenario_id:
                action_valve_netscenario.triggered.connect(partial(self._toggle_valve_state_netscenario, netscenario_id, valve_netscenario_id, valve_netscenario_table, valve_netscenario_value))
            action_valve_netscenario.hovered.connect(partial(self._reset_rubber_bands))
            main_menu.addAction(action_valve_netscenario)
            main_menu.addSeparator()

        main_menu.aboutToHide.connect(self._reset_rubber_bands)
        main_menu.exec(click_point)

    def _identify_all(self, complet_list, rb_list):

        tools_gw.reset_rubberband(self.rubber_band)
        for rb in rb_list:
            tools_gw.reset_rubberband(rb)
        for layer in complet_list["body"]["data"]["layersNames"]:
            for feature in layer["ids"]:
                points = []
                list_coord = re.search(r"\(+([^)]+)\)+", str(feature["geometry"]))
                coords = list_coord.group(1)
                polygon = coords.split(",")
                for i in range(0, len(polygon)):
                    x, y = polygon[i].split(" ")
                    point = QgsPointXY(float(x), float(y))
                    points.append(point)
                rb = tools_gw.create_rubberband(self.canvas)
                polyline = QgsGeometry.fromPolylineXY(points)
                rb.setToGeometry(polyline, None)
                rb.setColor(QColor(255, 0, 0, 100))
                rb.setWidth(5)
                rb.show()
                rb_list.append(rb)

    def _toggle_valve_state(self, valve_id, table_name, value):
        """Open or closes a valve. If parameter 'utils_graphanalytics_automatic_trigger' is true,
        also updates mapzones in a thread
        """
        # Build function body
        feature = f'"id":"{valve_id}", '
        feature += f'"tableName":"{table_name}", '
        feature += ' "featureType":"node" '
        extras = f'"fields":{{"closed": "{value}"}}'
        body = tools_gw.create_body(feature=feature, extras=extras)

        # Get utils_graphanalytics_automatic_trigger param
        row = tools_gw.get_config_value("utils_graphanalytics_automatic_trigger", table="config_param_system")
        thread = row[0] if row else None
        if thread:
            thread = json.loads(thread)
            thread = tools_os.set_boolean(thread["status"], default=False)

        # If param is false don't create thread
        if not thread:
            tools_gw.execute_procedure("gw_fct_setfields", body)
            tools_qgis.refresh_map_canvas()
            return

        # If param is true show question and create thread
        msg = "You closed a valve, this will modify the current mapzones and it may take a little bit of time."
        if lib_vars.user_level["level"] in ("1", "2"):
            msg = ("You closed a valve, this will modify the current mapzones and it may take a little bit of time."
                    " Would you like to continue?")
            answer = tools_qt.show_question(msg)
        else:
            tools_qgis.show_info(msg)
            answer = True

        if answer:
            params = {"body": body}
            self.valve_thread = GwToggleValveTask("Update mapzones", params)
            QgsApplication.taskManager().addTask(self.valve_thread)
            QgsApplication.taskManager().triggerTask(self.valve_thread)

    def _toggle_valve_state_netscenario(self, netscenario_id, valve_id, table_name, value):
        """Open or closes a valve in a netscenario"""
        # Build function body
        feature = f'"id":"{netscenario_id}, {valve_id}", '
        feature += f'"tableName":"{table_name}" '
        # feature += f' "featureType":"node" '
        extras = f'"fields":{{"netscenario_id": "{netscenario_id}", "node_id": "{valve_id}","closed": "{value}"}}'
        body = tools_gw.create_body(feature=feature, extras=extras)

        tools_gw.execute_procedure("gw_fct_upsertfields", body)
        tools_qgis.refresh_map_canvas()

    def _draw_by_action(self, feature, rb_list, reset_rb=True):
        """Draw lines based on geometry"""
        for rb in rb_list:
            tools_gw.reset_rubberband(rb)
        if feature["geometry"] is None:
            return

        if reset_rb:
            tools_gw.reset_rubberband(self.rubber_band)
        tools_gw.draw_wkt_geometry(str(feature["geometry"]), self.rubber_band, QColor(255, 0, 0, 100), 3)

    def _get_info_from_selected_id(self, action, tab_type):
        """Set active selected layer"""
        tools_gw.reset_rubberband(self.rubber_band)
        # Get layer name from action property (for nested menus) or from parent menu title
        layer_name_str = action.property("layer_name")
        if layer_name_str:
            layer = tools_qgis.get_layer_by_layername(layer_name_str)
        else:
            parent_menu = action.associatedWidgets()[0]
            layer = tools_qgis.get_layer_by_layername(parent_menu.title())
        if layer:
            layer_source = tools_qgis.get_layer_source(layer)
            self.iface.setActiveLayer(layer)
            tools_gw.init_docker()
            info_feature = GwInfo(self.tab_type)
            info_feature.signal_activate.connect(self._reactivate_map_tool)
            info_feature.get_info_from_id(table_name=layer_source["table"], feature_id=action.property("feature_id"), tab_type=tab_type)
            # Remove previous rubberband when open new docker
            if isinstance(self.previous_info_feature, GwInfo) and lib_vars.session_vars["dialog_docker"] is not None:
                tools_gw.reset_rubberband(self.previous_info_feature.rubber_band)
            self.previous_info_feature = info_feature

    def _get_info(self, event):

        for rb in self.rubberband_list:
            tools_gw.reset_rubberband(rb)

        if self.block_signal:
            self.block_signal = False
            return

        if event.button() == Qt.MouseButton.LeftButton:

            point = tools_qgis.create_point(self.canvas, self.iface, event)
            if point is False:
                return
            tools_gw.init_docker()
            info_feature = GwInfo(self.tab_type)
            info_feature.signal_activate.connect(self._reactivate_map_tool)
            info_feature.get_info_from_coordinates(point, tab_type=self.tab_type)
            # Remove previous rubberband when open new docker
            if isinstance(self.previous_info_feature, GwInfo) and lib_vars.session_vars["dialog_docker"] is not None:
                tools_gw.reset_rubberband(self.previous_info_feature.rubber_band)
            self.previous_info_feature = info_feature

        elif event.button() == Qt.MouseButton.RightButton:
            point = tools_qgis.create_point(self.canvas, self.iface, event)
            if point is False:
                return

            self._get_layers_from_coordinates(point, self.rubberband_list, self.tab_type)

    def _toggle_psector_selector(self, psector_id: int, state):
        """Toggle psector in selector_psector when checkbox is toggled
        :param psector_id: ID of the psector to toggle
        """
        # Get the checkbox that triggered this (sender)
        checkbox = self.sender()
        if checkbox is None:
            return

        # Get checked state
        is_checked = checkbox.isChecked()

        # Get menu reference from checkbox property
        psector_menu = checkbox.property("psector_menu")
        if psector_menu is None:
            return

        # Store reference to main action before executing procedure
        main_action = psector_menu.property("main_action")
        main_action_index = -1
        if main_action:
            actions = psector_menu.actions()
            try:
                main_action_index = actions.index(main_action)
            except ValueError:
                main_action_index = -1

        # Update selector_psector using gw_fct_setselectors
        value_str = "True" if is_checked else "False"
        extras = (f'"selectorType":"selector_basic", "tabName":"tab_psector", "id":"{psector_id}", '
                  f'"isAlone":"False", "value":"{value_str}", "addSchema":"{lib_vars.project_vars["add_schema"]}"')
        body = tools_gw.create_body(extras=extras)
        json_result = tools_gw.execute_procedure("gw_fct_setselectors", body)

        level = json_result["body"]["message"]["level"]
        if level == 0:
            message = json_result["body"]["message"]["text"]
            tools_qgis.show_message(message, level)
            QTimer.singleShot(0, partial(self.restore_state, checkbox, is_checked))
            return

        # Restore main action if it was removed after execute_procedure
        if main_action:
            actions_after = psector_menu.actions()
            if main_action not in actions_after:
                # Main action was removed, restore it
                if main_action_index >= 0 and main_action_index < len(actions_after):
                    psector_menu.insertAction(actions_after[main_action_index], main_action)
                else:
                    # Insert at the beginning
                    psector_menu.insertAction(actions_after[0] if actions_after else None, main_action)

        tools_gw.refresh_selectors()

    def restore_state(self, checkbox, is_checked):
        checkbox.blockSignals(True)
        checkbox.setChecked(not is_checked)
        checkbox.blockSignals(False)

    # endregion
