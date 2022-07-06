"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from qgis.PyQt.QtCore import QRect, Qt
from qgis.PyQt.QtWidgets import QApplication
from qgis.core import QgsVectorLayer, QgsRectangle, QgsApplication, QgsProject

from ..maptool import GwMaptool
from ...ui.ui_manager import GwDialogTextUi
from ...utils import tools_gw
from ....lib import tools_qgis, tools_qt
from ...threads.connect_link import GwConnectLink
from .... import global_vars


class GwConnectLinkButton(GwMaptool):
    """ Button 20: Connect Link
    User select connections from layer 'connec'
    Execute SQL function: 'gw_fct_setlinktonetwork ' """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.dragging = False
        self.select_rect = QRect()


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

        # Clear snapping
        self.snapper_manager.set_snapping_status()

        # Set snapping to 'connec' and 'gully'
        self.snapper_manager.config_snap_to_connec()
        self.snapper_manager.config_snap_to_gully()

        # Change cursor
        cursor = tools_gw.get_cursor_multiple_selection()
        self.canvas.setCursor(cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Select connecs or gullies with qgis tool and use right click to connect them with network"
            tools_qgis.show_info(message)


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
        tools_gw.reset_rubberband(self.rubber_band, 2)


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

            layer_connec = tools_qgis.get_layer_by_tablename('v_edit_connec')
            if layer_connec:
                number_connec_features += layer_connec.selectedFeatureCount()
            if number_connec_features > 0 and QgsProject.instance().layerTreeRoot().findLayer(layer_connec).isVisible():
                message = "Number of features selected in the group of"
                title = "Connect to network"
                answer = tools_qt.show_question(message, title, parameter='connec: ' + str(number_connec_features))
                if answer:
                    # Create link
                    self.connect_link_task = GwConnectLink("Connect link", self, 'connec', layer_connec)
                    QgsApplication.taskManager().addTask(self.connect_link_task)
                    QgsApplication.taskManager().triggerTask(self.connect_link_task)
                else:
                    self.manage_gully_result()
            else:
                self.manage_gully_result()

            if number_connec_features == 0 or QgsProject.instance().layerTreeRoot().findLayer(layer_connec).isVisible() is False:
                self.cancel_map_tool()


    def manage_result(self, result, layer):

        if result and result['status'] != 'Failed':
            self.dlg_dtext = GwDialogTextUi('connect_to_network')
            tools_gw.load_settings(self.dlg_dtext)
            self.dlg_dtext.btn_accept.hide()
            self.dlg_dtext.setWindowTitle('Connect to network')
            self.dlg_dtext.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_dtext))
            self.dlg_dtext.rejected.connect(partial(tools_gw.close_dialog, self.dlg_dtext))
            if layer.name() == 'Connec' and global_vars.project_type == 'ud':
                self.dlg_dtext.btn_close.clicked.connect(partial(self.manage_gully_result))
                self.dlg_dtext.rejected.connect(partial(self.manage_gully_result))
            tools_gw.fill_tab_log(self.dlg_dtext, result['body']['data'], False)
            tools_gw.open_dialog(self.dlg_dtext, dlg_name='dialog_text')
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
        tools_gw.reset_rubberband(self.rubber_band, 2)
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
        layer = tools_qgis.get_layer_by_tablename('v_edit_connec')
        if layer:
            layer.selectByRect(select_geometry, behaviour)

        layer = tools_qgis.get_layer_by_tablename('v_edit_gully')
        if layer:
            layer.selectByRect(select_geometry, behaviour)

    # endregion
