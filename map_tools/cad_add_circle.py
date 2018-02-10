'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from PyQt4.QtCore import QPoint, Qt
from PyQt4.QtGui import QDoubleValidator
from qgis.core import QgsMapLayerRegistry, QgsVectorLayer, QgsFeature, QgsGeometry, QgsPoint, QgsMapToPixel, QgsFillSymbolV2
from qgis.core import QgsProject, QgsSingleSymbolRendererV2
from qgis.gui import QgsVertexMarker

import utils_giswater
from map_tools.parent import ParentMapTool
from ui.cad_add_circle import Cad_add_circle


class CadAddCircle(ParentMapTool):
    """ Button 71: Add circle """

    def __init__(self, iface, settings, action, index_action):
        """ Class constructor """

        # Call ParentMapTool constructor
        super(CadAddCircle, self).__init__(iface, settings, action, index_action)
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CROSS)
        self.cancel_circle = False
        self.virtual_layer_polygon = None


    def init_create_circle_form(self):
        
        # Create the dialog and signals
        self.dlg_create_circle = Cad_add_circle()
        utils_giswater.setDialog(self.dlg_create_circle)

        virtual_layer_name = "virtual_layer_polygon"
        sql = ("SELECT value FROM " + self.controller.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND parameter = 'virtual_layer_polygon'")
        row = self.controller.get_row(sql)
        if row:
            virtual_layer_name = row[0]
        
        if self.exist_virtual_layer(virtual_layer_name):
            self.get_point(virtual_layer_name)
        else:
            self.create_virtual_layer(virtual_layer_name)
            message = "Virtual layer not found. It's gonna be created"
            self.controller.show_info(message)
            self.iface.setActiveLayer(self.vdefault_layer)
            self.get_point(virtual_layer_name)

    def get_point(self, virtual_layer_name):
        validator = QDoubleValidator(0.00, 999.00, 3)
        validator.setNotation(QDoubleValidator().StandardNotation)

        self.dlg_create_circle.radius.setValidator(validator)
        self.dlg_create_circle.btn_accept.pressed.connect(self.get_radius)
        self.dlg_create_circle.btn_cancel.pressed.connect(self.cancel)
        self.dlg_create_circle.radius.setFocus()

        self.active_layer = self.iface.mapCanvas().currentLayer()
        self.virtual_layer_polygon = self.controller.get_layer_by_layername(virtual_layer_name, True)
        self.dlg_create_circle.exec_()

    def create_virtual_layer(self, virtual_layer_name):

        srid = self.controller.plugin_settings_value('srid')
        uri = "Polygon?crs=epsg:" + str(srid)
        virtual_layer = QgsVectorLayer(uri, virtual_layer_name, "memory")
        props = {'color': '0, 0, 0', 'style': 'no', 'style_border': 'solid', 'color_border': '255, 0, 0'}
        s = QgsFillSymbolV2.createSimple(props)
        virtual_layer.setRendererV2(QgsSingleSymbolRendererV2(s))
        virtual_layer.updateExtents()
        QgsProject.instance().setSnapSettingsForLayer(virtual_layer.id(), True, 2, 0, 1.0, False)
        QgsMapLayerRegistry.instance().addMapLayer(virtual_layer)
        self.iface.mapCanvas().refresh()


    def exist_virtual_layer(self, virtual_layer_name):

        layers = self.iface.mapCanvas().layers()
        for layer in layers:
            if layer.name() == virtual_layer_name:
                return True
        return False


    def get_radius(self):
        
        self.radius = self.dlg_create_circle.radius.text()
        self.virtual_layer_polygon.startEditing()
        self.dlg_create_circle.close()


    def cancel(self):
        
        self.dlg_create_circle.close()
        self.cancel_map_tool()
        if self.virtual_layer_polygon:
            if self.virtual_layer_polygon.isEditable():
                self.virtual_layer_polygon.commitChanges()
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
            point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(), x, y)

            self.init_create_circle_form()
            if not self.cancel_circle:
                feature = QgsFeature()
                feature.setGeometry(QgsGeometry.fromPoint(point).buffer(float(self.radius), 100))
                provider = self.virtual_layer_polygon.dataProvider()
                self.virtual_layer_polygon.startEditing()
                provider.addFeatures([feature])
            else:
                self.iface.actionPan().trigger()
                self.cancel_circle = False
                return
            
        elif event.button() == Qt.RightButton:
            self.cancel_map_tool()
            self.iface.setActiveLayer(self.current_layer)

        if self.virtual_layer_polygon:
            self.virtual_layer_polygon.commitChanges()


    def activate(self):

        # Check button
        self.action().setChecked(True)

        # Change cursor
        self.canvas.setCursor(self.cursor)
        
        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Clear snapping
        self.snapper_manager.clear_snapping()

        # Get current layer
        self.current_layer = self.iface.activeLayer()

        # Check for default base layer
        sql = ("SELECT value FROM " + self.controller.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND parameter = 'cad_tools_base_layer_vdefault'")
        row = self.controller.get_row(sql)
        if row:
            self.vdefault_layer = self.controller.get_layer_by_layername(row[0])
            self.iface.setActiveLayer(self.vdefault_layer)
        else:
            self.vdefault_layer = self.iface.activeLayer()
        # Set snapping
        layer = self.iface.activeLayer()
        self.snapper_manager.snap_to_layer(layer)

        # Show help message when action is activated
        if self.show_help:
            message = "Select an element and click it to set radius"
            self.controller.show_info(message)

        # Set active 'v_edit_dimensions'
        layer = self.iface.activeLayer()
        if layer:
            self.iface.setActiveLayer(layer)


    def deactivate(self):

        # Call parent method
        ParentMapTool.deactivate(self)
        self.iface.setActiveLayer(self.current_layer)


    
