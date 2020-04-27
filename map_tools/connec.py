"""
/***************************************************************************
        begin                : 2016-01-05
        copyright            : (C) 2016 by BGEO SL
        email                : vicente.medina@gits.ws
        git sha              : $Format:%H$
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

"""

# -*- coding: utf-8 -*-

from qgis.core import QgsVectorLayer, QgsRectangle
from qgis.PyQt.QtCore import QRect, Qt
from qgis.PyQt.QtWidgets import QApplication

from functools import partial

from ..ui_manager import  BasicInfoUi
from .parent import ParentMapTool


class ConnecMapTool(ParentMapTool):
    """ Button 20: User select connections from layer 'connec'
    Execute SQL function: 'gw_fct_connect_to_network' """    

    def __init__(self, iface, settings, action, index_action):
        """ Class constructor """

        # Call ParentMapTool constructor
        super(ConnecMapTool, self).__init__(iface, settings, action, index_action)

        self.dragging = False

        # Select rectangle
        self.select_rect = QRect()



    """ QgsMapTools inherited event functions """

    def canvasMoveEvent(self, event):
        """ With left click the digitizing is finished """

        if event.buttons() == Qt.LeftButton:

            if not self.dragging:
                self.dragging = True
                self.select_rect.setTopLeft(event.pos())

            self.select_rect.setBottomRight(event.pos())
            self.set_rubber_band()


    def canvasPressEvent(self, event):   #@UnusedVariable

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
                result = self.snapper_manager.snap_to_background_layers(event_point)
                if not self.snapper_manager.result_is_valid():
                    return

                # Check if it belongs to 'connec' or 'gully' group
                layer = self.snapper_manager.get_snapped_layer(result)
                feature_id = self.snapper_manager.get_snapped_feature_id(result)
                exist_connec = self.snapper_manager.check_connec_group(layer)
                exist_gully = self.snapper_manager.check_gully_group(layer)
                if exist_connec or exist_gully:
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
            layer = self.snapper_manager.layer_connec
            if layer:
                number_features += layer.selectedFeatureCount()

            if number_features > 0:
                message = "Number of features selected in the group of"
                title = "Interpolate value - Do you want to update values"
                answer = self.controller.ask_question(message, title, parameter='connec: '+str(number_features))
                if answer:
                    # Create link
                    self.link_selected_features('connec', layer)
                    self.cancel_map_tool()
                    
            layer = self.snapper_manager.layer_gully
            if layer:
                # Check selected records
                number_features = 0
                number_features += layer.selectedFeatureCount()
    
                if number_features > 0:
                    message = "Number of features selected in the group of"
                    title = "Interpolate value - Do you want to update values"
                    answer = self.controller.ask_question(message, title, parameter='gully: '+str(number_features))
                    if answer:
                        # Create link
                        self.link_selected_features('gully', layer)
                        self.cancel_map_tool()

        # Force reload dataProvider of layer
        self.controller.indexing_spatial_layer('v_edit_link')
        self.controller.indexing_spatial_layer('v_edit_vnode')


    def activate(self):

        # Check button
        self.action().setChecked(True)

        # Rubber band
        self.rubber_band.reset()

        # Set main snapping layers
        self.snapper_manager.set_snapping_layers()

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Clear snapping
        self.snapper_manager.enable_snapping()

        # Set snapping to 'connec' and 'gully'
        self.snapper_manager.snap_to_connec_gully()

        # Change cursor
        cursor = self.get_cursor_multiple_selection()
        self.canvas.setCursor(cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Right click to use current selection, select connec points by clicking or dragging (selection box)"
            self.controller.show_info(message)  


    def deactivate(self):

        ParentMapTool.deactivate(self)


    def link_selected_features(self, geom_type, layer):
        """ Link selected @geom_type to the pipe """

        # Check features selected
        number_features = layer.selectedFeatureCount()
        if number_features == 0:
            message = "You have to select at least one feature!"
            self.controller.show_warning(message)
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
            body = self.create_body(feature=feature_id, extras=extras)
            # Execute SQL function and show result to the user
            result = self.controller.get_json('gw_fct_connect_to_network', body, log_sql=True)
            if result:
                self.dlg_binfo = BasicInfoUi()
                self.load_settings(self.dlg_binfo)
                self.dlg_binfo.btn_accept.hide()
                self.dlg_binfo.setWindowTitle('Connect to network')
                self.dlg_binfo.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_binfo))
                self.dlg_binfo.rejected.connect(partial(self.close_dialog, self.dlg_binfo))
                self.populate_info_text(self.dlg_binfo, result['body']['data'], False)
                self.open_dialog(self.dlg_binfo)

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


    def select_multiple_features(self, selectGeometry):

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
        layer = self.snapper_manager.layer_connec
        if layer:
            layer.selectByRect(selectGeometry, behaviour)
            
        layer = self.snapper_manager.layer_gully
        if layer:
            layer.selectByRect(selectGeometry, behaviour)
        
