"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial
from enum import Enum

from qgis.PyQt.QtCore import QRect, Qt
from qgis.PyQt.QtWidgets import QApplication, QMenu, QAction, QActionGroup
from qgis.core import QgsVectorLayer, QgsRectangle, QgsApplication, QgsProject, QgsWkbTypes

from ..maptool import GwMaptool
from ...ui.ui_manager import GwDialogShowInfoUi
from ...utils import tools_gw
from ....libs import tools_qgis, tools_qt
from ...threads.connect_link import GwConnectLink
from .... import global_vars


class SelectAction(Enum):
    CLOSEST_ARCS = "CLOSEST ARCS"
    FORCED_ARCS = "FORCED ARCS"
    FORCED_ARCS2 = "FORCED ARCS (SELECTING ONLY ARCS)"


class GwConnectLinkButton(GwMaptool):
    """ Button 27: Connect Link
    User select connections from layer 'connec'
    Execute SQL function: 'gw_fct_setlinktonetwork ' """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.dragging = False
        self.select_rect = QRect()

        # Store the current selected action
        self.current_action = SelectAction.CLOSEST_ARCS

        # Create a dropdown menu
        self.menu = QMenu()

        # Dynamically set actions from the SelectAction Enum, excluding FORCED_ARCS2
        self.actions = [action for action in SelectAction if action != SelectAction.FORCED_ARCS2]

        # Fill the menu
        self._fill_action_menu()

        # Add menu to toolbar
        if toolbar is not None:
            self.action.setMenu(self.menu)
            toolbar.addAction(self.action)

    def _fill_action_menu(self):
        """Fill the dropdown menu with actions."""

        # Disconnect and remove previous signals and actions
        for action in self.menu.actions():
            action.disconnect()  # Disconnect signals
            self.menu.removeAction(action)  # Remove from menu

        # Create actions for the menu
        ag = QActionGroup(self.iface.mainWindow())
        for action in self.actions:
            # Use `action.value` for user-friendly labels
            obj_action = QAction(action.value, ag)
            self.menu.addAction(obj_action)

            # Connect signals for action selection
            obj_action.triggered.connect(partial(self._set_current_action, action))
            obj_action.triggered.connect(partial(super().clicked_event))

    def _set_current_action(self, action_name):
        """Set the currently selected action."""
        self.current_action = action_name

    # region QgsMapTools inherited
    """ QgsMapTools inherited event functions """

    def activate(self):

        # Check action. It works if is selected from toolbar. Not working if is selected from menu or shortcut keys
        if hasattr(self.action, "setChecked"):
            self.action.setChecked(True)

        # Rubber band
        tools_gw.reset_rubberband(self.rubber_band)

        # Store user snapping configuration
        self.previous_snapping = self.snapper_manager.get_snapping_options()

        # Change cursor
        cursor = tools_gw.get_cursor_multiple_selection()
        self.canvas.setCursor(cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Select connecs or gullies with qgis tool and use right click to connect them with network. " \
                      "CTRL + SHIFT over selection to remove it"
            tools_qgis.show_info(message, duration=9)

    def canvasMoveEvent(self, event):
        """ With left click the digitizing is finished """

        if event.buttons() == Qt.LeftButton:

            if not self.dragging:
                self.dragging = True
                self.select_rect.setTopLeft(event.pos())

            self.select_rect.setBottomRight(event.pos())
            self._set_rubber_band()

    def canvasPressEvent(self, event):

        self.select_rect.setRect(0, 0, 0, 0)
        tools_gw.reset_rubberband(self.rubber_band, "polygon")

    def canvasReleaseEvent(self, event):
        """ With left click the digitizing is finished """

        # Manage if task is already running
        if hasattr(self, 'connect_link_task') and self.connect_link_task is not None:
            try:
                if self.connect_link_task.isActive():
                    message = "Connect link task is already active!"
                    tools_qgis.show_warning(message)
                    return
            except RuntimeError:
                pass

        if event.button() == Qt.LeftButton:

            # Get coordinates
            event_point = self.snapper_manager.get_event_point(event)

            # Simple selection
            if not self.dragging:

                # Snap to connec or gully
                result = self.snapper_manager.snap_to_project_config_layers(event_point)
                if not result.isValid():
                    return

                # Check if it belongs to 'connec' or 'gully' group
                layer = self.snapper_manager.get_snapped_layer(result)
                feature_id = self.snapper_manager.get_snapped_feature_id(result)
                layer_connec = tools_qgis.get_layer_by_tablename(layer)
                layer_gully = tools_qgis.get_layer_by_tablename(layer)
                if layer_connec or layer_gully:
                    key = QApplication.keyboardModifiers()
                    # If Ctrl+Shift is clicked: deselect snapped feature
                    if key == (Qt.ControlModifier | Qt.ShiftModifier):
                        layer.deselect([feature_id])
                    else:
                        # If Ctrl is not clicked: remove previous selection
                        if key != Qt.ControlModifier:
                            layer.removeSelection()
                        layer.select([feature_id])

                    # Hide marker
                    self.vertex_marker.hide()

            # Multiple selection
            else:
                # Set valid values for rectangle's width and height
                if self.select_rect.width() == 1:
                    self.select_rect.setLeft(self.select_rect.left() + 1)

                if self.select_rect.height() == 1:
                    self.select_rect.setBottom(self.select_rect.bottom() + 1)

                self._set_rubber_band()
                self._select_multiple_features(self.selected_rectangle)
                self.dragging = False

                # Refresh map canvas
                tools_gw.reset_rubberband(self.rubber_band)

            # Force reload dataProvider of layer
            tools_qgis.set_layer_index('v_edit_link')
            tools_qgis.set_layer_index('v_edit_vnode')

        elif event.button() == Qt.RightButton:
            # Check selected records
            number_connec_features = 0
            # Get the connection layer and count selected features
            layer_connec = tools_qgis.get_layer_by_tablename('v_edit_connec')
            if layer_connec:
                number_connec_features += layer_connec.selectedFeatureCount()
            if number_connec_features > 0 and QgsProject.instance().layerTreeRoot().findLayer(layer_connec).isVisible():
                # Check if the current action is "FORCED ARCS"
                if self.current_action == SelectAction.FORCED_ARCS:
                    if number_connec_features > 0:
                        # Notify user and switch to arc selection
                        self._set_current_action(SelectAction.FORCED_ARCS2)
                        tools_qgis.show_info(
                            "Nodes selected. Now, please select an arc on the map and confirm with a right-click.")
                        return
                    else:
                        tools_qgis.show_warning("No nodes selected. Please select nodes first.")
                        return
                # Handle the FORCED_ARCS2 case
                if self.current_action == SelectAction.FORCED_ARCS2:
                    # Retrieve the selected arc
                    layer_arc = tools_qgis.get_layer_by_tablename('v_edit_arc')
                    selected_arc = None
                    selected_arc_msg = ""
                    if layer_arc and layer_arc.selectedFeatureCount() > 0:
                        # Get the first selected arc (or handle multiple arcs if needed)
                        selected_arc_feature = layer_arc.selectedFeatures()[0]  # Use the first selected arc
                        selected_arc = selected_arc_feature.attribute("arc_id")
                        selected_arc_msg = f" Arc ID: {selected_arc}"
                    # Append arc info to the message
                    message = f"For the selected {selected_arc_msg}, wil have a number of features selected in the group of connec"
                else:
                    # Default message for non-FORCED_ARCS2 cases
                    message = "Number of features selected in the group of connec"
                # Show the confirmation dialog
                title = "Connect to network"
                answer = tools_qt.show_question(message, title, parameter=str(number_connec_features))
                if answer:
                    # Create the task
                    if self.current_action == SelectAction.FORCED_ARCS2:
                        # Include the selected arc in the function call
                        self.connect_link_task = GwConnectLink(
                            "Connect link", self, 'connec', layer_connec, selected_arc=selected_arc
                        )
                    else:
                        # Default behavior for non-FORCED_ARCS2 cases
                        self.connect_link_task = GwConnectLink(
                            "Connect link", self, 'connec', layer_connec
                        )
                    # Add and trigger the task
                    QgsApplication.taskManager().addTask(self.connect_link_task)
                    QgsApplication.taskManager().triggerTask(self.connect_link_task)
                else:
                    self.manage_gully_result()
            else:
                self.manage_gully_result()
            # Cancel map tool if no features are selected or the layer is not visible
            if number_connec_features == 0 or QgsProject.instance().layerTreeRoot().findLayer(
                    layer_connec).isVisible() is False:
                self.cancel_map_tool()

    def manage_result(self, result, layer):

        if result and result['status'] != 'Failed':
            self.dlg_info = GwDialogShowInfoUi()
            tools_gw.load_settings(self.dlg_info)
            self.dlg_info.btn_accept.hide()
            self.dlg_info.setWindowTitle('Connect to network')
            self.dlg_info.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_info))
            self.dlg_info.rejected.connect(partial(tools_gw.close_dialog, self.dlg_info))
            if layer.name() == 'Connec' and global_vars.project_type == 'ud':
                self.dlg_info.btn_close.clicked.connect(partial(self.manage_gully_result))
                self.dlg_info.rejected.connect(partial(self.manage_gully_result))
            tools_gw.fill_tab_log(self.dlg_info, result['body']['data'], False)
            tools_gw.open_dialog(self.dlg_info, dlg_name='dialog_text')
        else:
            tools_qgis.show_warning("gw_fct_setlinktonetwork (Check log messages)", title='Function error')

        layer.removeSelection()

        # Refresh map canvas
        if layer.name() == 'Gully' or global_vars.project_type == 'ws':
            tools_gw.reset_rubberband(self.rubber_band)
            self.refresh_map_canvas()
            self.iface.actionPan().trigger()

        # Force reload dataProvider of layer
        tools_qgis.set_layer_index('v_edit_link')
        tools_qgis.set_layer_index('v_edit_vnode')

    def manage_gully_result(self):

        # Manage if task is already running
        if hasattr(self, 'connect_link_task') and self.connect_link_task is not None:
            try:
                if self.connect_link_task.isActive():
                    message = "Connect link task is already active!"
                    tools_qgis.show_warning(message)
                    return
            except RuntimeError:
                pass

        layer_gully = tools_qgis.get_layer_by_tablename('v_edit_gully')
        if layer_gully:
            # Check selected records
            number_features = 0
            number_features += layer_gully.selectedFeatureCount()
            if number_features > 0 and QgsProject.instance().layerTreeRoot().findLayer(layer_gully).isVisible():
                message = "Number of features selected in the group of"
                title = "Connect to network"
                answer = tools_qt.show_question(message, title, parameter='gully: ' + str(number_features))
                if answer:
                    # Create link
                    self.connect_link_task = GwConnectLink("Connect link", self, 'gully', layer_gully)
                    QgsApplication.taskManager().addTask(self.connect_link_task)
                    QgsApplication.taskManager().triggerTask(self.connect_link_task)

            if number_features == 0 or QgsProject.instance().layerTreeRoot().findLayer(layer_gully).isVisible() is False:
                self.cancel_map_tool()

    # endregion

    # region private functions

    def _set_rubber_band(self):

        # Coordinates transform
        transform = self.canvas.getCoordinateTransform()

        # Coordinates
        ll = transform.toMapCoordinates(self.select_rect.left(), self.select_rect.bottom())
        lr = transform.toMapCoordinates(self.select_rect.right(), self.select_rect.bottom())
        ul = transform.toMapCoordinates(self.select_rect.left(), self.select_rect.top())
        ur = transform.toMapCoordinates(self.select_rect.right(), self.select_rect.top())

        # Rubber band
        tools_gw.reset_rubberband(self.rubber_band, "polygon")
        self.rubber_band.addPoint(ll, False)
        self.rubber_band.addPoint(lr, False)
        self.rubber_band.addPoint(ur, False)
        self.rubber_band.addPoint(ul, False)
        self.rubber_band.addPoint(ll, True)

        self.selected_rectangle = QgsRectangle(ll, ur)

    def _select_multiple_features(self, select_geometry):

        key = QApplication.keyboardModifiers()

        # If Ctrl+Shift clicked: remove features from selection
        if key == (Qt.ControlModifier | Qt.ShiftModifier):
            behaviour = QgsVectorLayer.RemoveFromSelection
        # If Ctrl clicked: add features to selection
        elif key == Qt.ControlModifier:
            behaviour = QgsVectorLayer.AddToSelection
        # If Ctrl not clicked: add features to selection
        else:
            behaviour = QgsVectorLayer.AddToSelection

        # Selection for all connec and gully layers
        if self.current_action in (SelectAction.FORCED_ARCS, SelectAction.CLOSEST_ARCS):
            layer = tools_qgis.get_layer_by_tablename('v_edit_connec')
            if layer:
                layer.selectByRect(select_geometry, behaviour)

            layer = tools_qgis.get_layer_by_tablename('v_edit_gully')
            if layer:
                layer.selectByRect(select_geometry, behaviour)
            return
        if self.current_action == SelectAction.FORCED_ARCS2:
            layer = tools_qgis.get_layer_by_tablename('v_edit_arc')
            if layer:
                # Use selectByRect to initially select features
                layer.selectByRect(select_geometry, behaviour)

                # Get the selected features after selection
                selected_features = layer.selectedFeatures()

                # If more than one feature is selected, keep only the first one
                if len(selected_features) > 1:
                    # Get the IDs of all selected features
                    selected_ids = [feature.id() for feature in selected_features]
                    # Keep only the first ID and deselect the others
                    layer.selectByIds([selected_ids[0]])

    # endregion
