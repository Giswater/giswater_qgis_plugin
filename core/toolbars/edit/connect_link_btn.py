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
from qgis.core import QgsVectorLayer, QgsRectangle

from ..maptool_button import GwMaptoolButton
from ...ui.ui_manager import GwDialogTextUi
from ...utils import tools_gw
from ....lib import tools_qgis, tools_qt


class GwConnectLinkButton(GwMaptoolButton):
    """ Button 20: User select connections from layer 'connec'
    Execute SQL function: 'gw_fct_setlinktonetwork ' """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        """ Class constructor """

        super().__init__(icon_path, action_name, text, toolbar, action_group)

        self.dragging = False

        # Select rectangle
        self.select_rect = QRect()


    def link_selected_features(self, geom_type, layer):
        """ Link selected @geom_type to the pipe """

        # Check features selected
        number_features = layer.selectedFeatureCount()
        if number_features == 0:
            message = "You have to select at least one feature!"
            tools_qgis.show_warning(message)
            return

        # Get selected features from layers of selected @geom_type
        aux = "["
        field_id = geom_type + "_id"

        if layer.selectedFeatureCount() > 0:
            # Get selected features of the layer
            features = layer.selectedFeatures()
            for feature in features:
                feature_id = feature.attribute(field_id)
                aux += str(feature_id) + ", "
            list_feature_id = aux[:-2] + "]"
            feature_id = f'"id":"{list_feature_id}"'
            extras = f'"feature_type":"{geom_type.upper()}"'
            body = tools_gw.create_body(feature=feature_id, extras=extras)
            # Execute SQL function and show result to the user
            result = tools_gw.get_json('gw_fct_setlinktonetwork ', body)
            if result:
                self.dlg_dtext = GwDialogTextUi()
                tools_gw.load_settings(self.dlg_dtext)
                self.dlg_dtext.btn_accept.hide()
                self.dlg_dtext.setWindowTitle('Connect to network')
                self.dlg_dtext.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_dtext))
                self.dlg_dtext.rejected.connect(partial(tools_gw.close_dialog, self.dlg_dtext))
                tools_gw.fill_tab_log(self.dlg_dtext, result['body']['data'], False)
                tools_gw.open_dialog(self.dlg_dtext, dlg_name='dialog_text')

            layer.removeSelection()

        # Refresh map canvas
        self.rubber_band.reset()
        self.refresh_map_canvas()
        self.iface.actionPan().trigger()


    def set_rubber_band(self):

        # Coordinates transform
        transform = self.canvas.getCoordinateTransform()

        # Coordinates
        ll = transform.toMapCoordinates(self.select_rect.left(), self.select_rect.bottom())
        lr = transform.toMapCoordinates(self.select_rect.right(), self.select_rect.bottom())
        ul = transform.toMapCoordinates(self.select_rect.left(), self.select_rect.top())
        ur = transform.toMapCoordinates(self.select_rect.right(), self.select_rect.top())

        # Rubber band
        self.rubber_band.reset(2)
        self.rubber_band.addPoint(ll, False)
        self.rubber_band.addPoint(lr, False)
        self.rubber_band.addPoint(ur, False)
        self.rubber_band.addPoint(ul, False)
        self.rubber_band.addPoint(ll, True)

        self.selected_rectangle = QgsRectangle(ll, ur)


    def select_multiple_features(self, select_geometry):

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

    # region QgsMapTools inherited
    """ QgsMapTools inherited event functions """

    def canvasMoveEvent(self, event):
        """ With left click the digitizing is finished """

        if event.buttons() == Qt.LeftButton:

            if not self.dragging:
                self.dragging = True
                self.select_rect.setTopLeft(event.pos())

            self.select_rect.setBottomRight(event.pos())
            self.set_rubber_band()


    def canvasPressEvent(self, event):

        self.select_rect.setRect(0, 0, 0, 0)
        self.rubber_band.reset(2)


    def canvasReleaseEvent(self, event):
        """ With left click the digitizing is finished """

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

                self.set_rubber_band()
                self.select_multiple_features(self.selected_rectangle)
                self.dragging = False

                # Refresh map canvas
                self.rubber_band.reset()

        elif event.button() == Qt.RightButton:

            # Check selected records
            number_features = 0
            layer = tools_qgis.get_layer_by_tablename('v_edit_connec')
            if layer:
                number_features += layer.selectedFeatureCount()

            if number_features > 0:
                message = "Number of features selected in the group of"
                title = "Interpolate value - Do you want to update values"
                answer = tools_qt.ask_question(message, title, parameter='connec: ' + str(number_features))
                if answer:
                    # Create link
                    self.link_selected_features('connec', layer)
                    self.cancel_map_tool()

            layer = tools_qgis.get_layer_by_tablename('v_edit_gully')
            if layer:
                # Check selected records
                number_features = 0
                number_features += layer.selectedFeatureCount()

                if number_features > 0:
                    message = "Number of features selected in the group of"
                    title = "Interpolate value - Do you want to update values"
                    answer = tools_qt.ask_question(message, title, parameter='gully: ' + str(number_features))
                    if answer:
                        # Create link
                        self.link_selected_features('gully', layer)
                        self.cancel_map_tool()

        # Force reload dataProvider of layer
        tools_qgis.set_layer_index('v_edit_link')
        tools_qgis.set_layer_index('v_edit_vnode')


    def activate(self):

        # Check button
        self.action.setChecked(True)

        # Rubber band
        self.rubber_band.reset()


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
            message = "Right click to use current selection, select connec points by clicking or dragging (selection box)"
            tools_qgis.show_info(message)


    def deactivate(self):
        super().deactivate()

    # end region


