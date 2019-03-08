"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from qgis.core import QgsMapLayerRegistry, QgsVectorLayer, QgsFeature, QgsGeometry, QgsPoint, QgsMapToPixel, QgsFillSymbolV2
from qgis.core import QgsProject, QgsSingleSymbolRendererV2
from qgis.gui import QgsVertexMarker
from qgis.PyQt.QtCore import QPoint, Qt
from qgis.PyQt.QtGui import QDoubleValidator

import utils_giswater
from map_tools.parent import ParentMapTool
from .ui_manager import Cad_add_circle
from functools import partial


class CadAddCircle(ParentMapTool):
    """ Button 71: Add circle """

    def __init__(self, iface, settings, action, index_action):
        """ Class constructor """

        # Call ParentMapTool constructor
        super(CadAddCircle, self).__init__(iface, settings, action, index_action)
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CROSS)
        self.cancel_circle = False
        self.layer_circle = None


    def init_create_circle_form(self, point):
        
        # Create the dialog and signals
        self.dlg_create_circle = Cad_add_circle()
        self.load_settings(self.dlg_create_circle)
        self.cancel_circle = False
        validator = QDoubleValidator(0.00, 999.00, 3)
        validator.setNotation(QDoubleValidator().StandardNotation)
        self.dlg_create_circle.radius.setValidator(validator)

        self.dlg_create_circle.btn_accept.clicked.connect(partial(self.get_radius, point))
        self.dlg_create_circle.btn_cancel.clicked.connect(self.cancel)
        self.dlg_create_circle.radius.setFocus()

        self.dlg_create_circle.exec_()


    def get_radius(self, point):

        self.radius = self.dlg_create_circle.radius.text()
        if not self.radius:
            self.radius = 0.1
        self.delete_prev = utils_giswater.isChecked(self.dlg_create_circle, self.dlg_create_circle.chk_delete_prev)

        if self.layer_circle:
            self.layer_circle.startEditing()
            self.close_dialog(self.dlg_create_circle)
            if self.delete_prev:
                selection = self.layer_circle.getFeatures()
                self.layer_circle.setSelectedFeatures([f.id() for f in selection])
                if self.layer_circle.selectedFeatureCount() > 0:
                    features = self.layer_circle.selectedFeatures()
                    for feature in features:
                        self.layer_circle.deleteFeature(feature.id())

            if not self.cancel_circle:
                feature = QgsFeature()
                feature.setGeometry(QgsGeometry.fromPoint(point).buffer(float(self.radius), 100))
                provider = self.layer_circle.dataProvider()

                provider.addFeatures([feature])
            self.layer_circle.commitChanges()
            self.layer_circle.dataProvider().forceReload()
            self.layer_circle.triggerRepaint()
            
        else:
            self.iface.actionPan().trigger()
            self.cancel_circle = False
            return


    def cancel(self):

        self.close_dialog(self.dlg_create_circle)
        self.cancel_map_tool()
        if self.layer_circle:
            if self.layer_circle.isEditable():
                self.layer_circle.commitChanges()
        self.cancel_circle = True
        self.iface.setActiveLayer(self.current_layer)


    """ QgsMapTools inherited event functions """

    def keyPressEvent(self, event):

        if event.key() == Qt.Key_Escape:
            self.cancel_map_tool()
            self.iface.setActiveLayer(self.current_layer)
            return


    def canvasMoveEvent(self, event):

        # Hide highlight
        self.vertex_marker.hide()

        # Get the click
        x = event.pos().x()
        y = event.pos().y()
        try:
            event_point = QPoint(x, y)
        except(TypeError, KeyError):
            self.iface.actionPan().trigger()
            return

        # Snapping
        (retval, result) = self.snapper.snapToBackgroundLayers(event_point)  # @UnusedVariable

        # That's the snapped features
        if result:
            # Get the point and add marker on it
            point = QgsPoint(result[0].snappedVertex)
            self.vertex_marker.setCenter(point)
            self.vertex_marker.show()


    def canvasReleaseEvent(self, event):

        if event.button() == Qt.LeftButton:

            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            try:
                event_point = QPoint(x, y)
            except(TypeError, KeyError):
                self.iface.actionPan().trigger()
                return
            (retval, result) = self.snapper.snapToBackgroundLayers(event_point)  # @UnusedVariable
            # Create point with snap reference
            if result:
                point = QgsPoint(result[0].snappedVertex)
            # Create point with mouse cursor reference
            else:
                point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(), x, y)

            self.init_create_circle_form(point)

        elif event.button() == Qt.RightButton:
            self.iface.actionPan().trigger()
            self.cancel_circle = True
            self.cancel_map_tool()
            self.iface.setActiveLayer(self.current_layer)
            return

        if self.layer_circle:
            self.layer_circle.commitChanges()


    def activate(self):

        # Check button
        self.action().setChecked(True)

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Select an element and click it to set radius"
            self.controller.show_info(message)

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Get current layer
        self.current_layer = self.iface.activeLayer()

        self.layer_circle = self.controller.get_layer_by_tablename('v_edit_cad_auxcircle', True)
        if self.layer_circle is None:
            self.show_warning("Layer not found", parameter=self.layer_circle)
            return
        self.iface.setActiveLayer(self.layer_circle)

        # Check for default base layer
        sql = ("SELECT value FROM " + self.controller.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND parameter = 'cad_tools_base_layer_vdefault_1'")
        row = self.controller.get_row(sql)
        if row:
            self.snap_to_selected_layer = True
            self.vdefault_layer = self.controller.get_layer_by_layername(row[0])
            self.iface.setActiveLayer(self.vdefault_layer)
        else:
            # Get current layer
            self.vdefault_layer = self.iface.activeLayer()

        # Set snapping
        self.snapper_manager.snap_to_layer(self.vdefault_layer)


    def deactivate(self):

        # Call parent method
        ParentMapTool.deactivate(self)
        self.iface.setActiveLayer(self.current_layer)
        
