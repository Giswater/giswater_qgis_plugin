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
from qgis.PyQt.QtWidgets import QApplication, QActionGroup, QWidget, QAction, QMenu
from qgis.core import QgsVectorLayer, QgsRectangle, QgsApplication, QgsProject

from ..maptool import GwMaptool
from ...ui.ui_manager import GwDialogShowInfoUi
from ...utils import tools_gw
from ....libs import tools_qgis, tools_qt, tools_db
from ...threads.connect_link import GwConnectLink
from .... import global_vars
from ...ui.ui_manager import GwConnectLinkUi

class SelectAction(Enum):
    CONNEC_LINK = tools_qt.tr('Connec to link')
    GULLY_LINK = tools_qt.tr('Gully to link')


class GwConnectLinkButton(GwMaptool):
    """ Button 27: Connect Link
    User select connections from layer 'connec'
    Execute SQL function: 'gw_fct_setlinktonetwork ' """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.dragging = False
        self.select_rect = QRect()
        self.selected_features = []
        self.project_type = tools_gw.get_project_type()

        # Check project type
        if self.project_type != 'ws':
            # Create a dropdown menu
            self.menu = QMenu()

            # Fill the menu
            self._fill_action_menu()

            # Add menu to toolbar
            if toolbar is not None and self.action is not None:
                self.action.setMenu(self.menu)
                toolbar.addAction(self.action)

    def clicked_event(self):
        """ Event when button is clicked """

        if self.project_type == 'ws':
            self.feature = 'connec'
            self.open_dlg()

    def open_dlg(self):
        """ Open connect link dialog """

        # Create form and body
        form = {"formName": "generic", "formType": f"link_to_{self.feature}"}
        body = {"client": {"cur_user": tools_db.current_user}, "form": form}

        # Execute procedure
        json_result = tools_gw.execute_procedure('gw_fct_get_dialog', body)

        # Create dialog
        self.dlg_connect_link = GwConnectLinkUi(self)
        tools_gw.load_settings(self.dlg_connect_link)
        tools_gw.manage_dlg_widgets(self, self.dlg_connect_link, json_result)

        # Get dynamic widgets
        self.txt_id = self.dlg_connect_link.findChild(QWidget, "tab_none_id")

        self.txt_id.setEditable(True)

        self.pipe_diameter = self.dlg_connect_link.findChild(QWidget, "tab_none_pipe_diameter")
        self.max_distance = self.dlg_connect_link.findChild(QWidget, "tab_none_max_distance")
        self.tbl_ids = self.dlg_connect_link.findChild(QWidget, "tab_none_tbl_ids")

        self.tbl_ids.setMinimumWidth(300)
        tools_gw.add_tableview_header(self.tbl_ids, json_headers=[{'header':f'{self.feature}_id'}])

        # Open form
        tools_gw.open_dialog(self.dlg_connect_link, 'connect_link')

    def fill_tbl_ids(self):
        """ Fill table with selected features """

        field = { "value": self.selected_features }

        # Clear previous rows
        self.tbl_ids.model().removeRows(0, self.tbl_ids.model().rowCount())

        # Fill table with selected features
        tools_gw.fill_tableview_rows(self.tbl_ids, field)

    def _fill_action_menu(self):
        """Fill the dropdown menu with actions."""

        # Disconnect and remove previous signals and actions
        for action in self.menu.actions():
            action.disconnect()  # Disconnect signals
            self.menu.removeAction(action)  # Remove from menu

        # Create actions for the menu
        ag = QActionGroup(self.iface.mainWindow())
        for action in SelectAction:
            # Use `action.value` for user-friendly labels
            obj_action = QAction(action.value, ag)
            self.menu.addAction(obj_action)
            # connect signal
            obj_action.triggered.connect(self._action_triggered)

    def _action_triggered(self):
        """ Action triggered event """

        # Get the action that was triggered
        action = self.sender()

        # Check if the action is valid
        if action is None:
            return

        # Get the selected action from the menu
        selected_action = SelectAction(action.text())

        # Open dialog based on selected action
        self.feature = 'connec' if selected_action == SelectAction.CONNEC_LINK else 'gully'
        self.open_dlg()

    """ QgsMapTools inherited event functions """

    def activate(self):
        """ Activate map tool """

        # Rubber band
        tools_gw.reset_rubberband(self.rubber_band)

        # Store user snapping configuration
        self.previous_snapping = self.snapper_manager.get_snapping_options()

        # Change cursor
        cursor = tools_gw.get_cursor_multiple_selection()
        self.canvas.setCursor(cursor)

        # Show help message when action is activated
        if self.show_help:
            msg = ("Select connecs or gullies with qgis tool and use right click to connect them with network. "
                      "CTRL + SHIFT over selection to remove it")
            tools_qgis.show_info(msg, duration=9)

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
                    msg = "Connect link task is already active!"
                    tools_qgis.show_warning(msg)
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

    def manage_result(self, result):

        if result and result['status'] != 'Failed':
            self.dlg_info = GwDialogShowInfoUi()
            tools_gw.load_settings(self.dlg_info)
            self.dlg_info.btn_accept.hide()
            self.dlg_info.setWindowTitle('Connect to network')
            self.dlg_info.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_info))
            self.dlg_info.rejected.connect(partial(tools_gw.close_dialog, self.dlg_info))

            tools_gw.fill_tab_log(self.dlg_info, result['body']['data'], False)
            tools_gw.open_dialog(self.dlg_info, dlg_name='dialog_text')
        else:
            msg = "gw_fct_setlinktonetwork (Check log messages)"
            tools_qgis.show_warning(msg, title='Function error')

        # Refresh map canvas
        tools_gw.reset_rubberband(self.rubber_band)
        self.refresh_map_canvas()
        self.iface.actionPan().trigger()

        # Force reload dataProvider of layer
        tools_qgis.set_layer_index('v_edit_link')
        tools_qgis.set_layer_index('v_edit_vnode')

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
        layer = tools_qgis.get_layer_by_tablename(f'v_edit_{self.feature}')
        if layer:

            if behaviour == QgsVectorLayer.RemoveFromSelection and len(layer.selectedFeatures()) == 1:
                selected_feature = {f"{self.feature}_id": layer.selectedFeatures()[0].attribute(f"{self.feature}_id")}
                if selected_feature in self.selected_features:

                    # Remove the selected feature from the list
                    self.selected_features.remove(selected_feature)

            layer.selectByRect(select_geometry, behaviour)

            if layer.selectedFeatureCount() > 0:
                for connec_feature in layer.selectedFeatures():
                    # Get the connec_id attribute of the selected feature
                    selected_feature = {f"{self.feature}_id": connec_feature.attribute(f"{self.feature}_id")}

                    # Check if the connec_id is already in the list
                    if behaviour == QgsVectorLayer.AddToSelection and selected_feature not in self.selected_features:
                        # Add the new connec_id to the list
                        self.selected_features.append(selected_feature)

                    elif behaviour == QgsVectorLayer.RemoveFromSelection and selected_feature in self.selected_features:
                        # Remove the connec_id from the list
                        self.selected_features.remove(selected_feature)

            self.fill_tbl_ids()

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

def add(**kwargs):
    """ Add button clicked event """

    this = kwargs['class']

    selected_id = tools_qt.get_combo_value(this.dlg_connect_link, "tab_none_id")

    if selected_id is None or selected_id == '':
        message = "Please select a feature to add"
        tools_qgis.show_warning(message, title='Connect to network')
        return

    new_feature = {f"{this.feature}_id": selected_id}
    if new_feature in this.selected_features:
        message = "This feature is already in the list"
        tools_qgis.show_warning(message, title='Connect to network')
        return

    this.selected_features.append(new_feature)
    this.fill_tbl_ids()

def remove(**kwargs):
    """ Remove button clicked event """

    this = kwargs['class']

    selected_id = tools_qt.get_combo_value(this.dlg_connect_link, "tab_none_id")

    if selected_id is None or selected_id == '':
        tools_qt.delete_rows_tableview(this.tbl_ids)
        return

    feature = {f"{this.feature}_id": selected_id }
    if feature not in this.selected_features:
        message = "This feature is not in the list"
        tools_qgis.show_warning(message, title='Connect to network', dialog=this.dlg_connect_link)
        return

    this.selected_features.remove(feature)
    this.fill_tbl_ids()

def accept(**kwargs):
    """ Accept button clicked event """

    this = kwargs['class']
    this.linkcat = tools_qt.get_combo_value(this.dlg_connect_link, "tab_none_linkcat")

    # Check input values
    if this.pipe_diameter.text() == '' or this.max_distance.text() == '' or this.linkcat == '':
        message = "Please fill all fields in the dialog"
        tools_qgis.show_warning(message, title='Connect to network', dialog=this.dlg_connect_link)
        return

    layer_arc = tools_qgis.get_layer_by_tablename('v_edit_arc')
    selected_arc = None

    # Check if the layer is valid and has selected arc
    if layer_arc and layer_arc.selectedFeatureCount() > 0:
        # Get the first selected arc
        selected_arc_feature = layer_arc.selectedFeatures()[0]  # Use the first selected arc
        selected_arc = selected_arc_feature.attribute("arc_id")

    this.ids = []
    model = this.tbl_ids.model()

    for row in range(model.rowCount()):
        item = model.item(row, 0)
        if item is not None:
            this.ids.append(int(item.text()))

    if len(this.ids) == 0:
        message = "Please select a feature to add"
        tools_qgis.show_warning(message, title='Connect to network', dialog=this.dlg_connect_link)
        return

    # Create the task
    this.connect_link_task = GwConnectLink("Connect link", this, this.feature, selected_arc=selected_arc)

    # Add and trigger the task
    QgsApplication.taskManager().addTask(this.connect_link_task)
    QgsApplication.taskManager().triggerTask(this.connect_link_task)

    # Cancel map tool if no features are selected or the layer is not visible
    this.cancel_map_tool()

    # Close dialog
    tools_gw.close_dialog(this.dlg_connect_link)

def snapping(**kwargs):
    """ Accept button clicked event """

    GwMaptool.clicked_event(kwargs['class'])

def close(**kwargs):
    """ Close button clicked event """

    tools_gw.close_dialog(kwargs['dialog'])