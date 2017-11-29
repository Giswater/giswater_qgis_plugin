'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from PyQt4.QtCore import QPoint, Qt
from PyQt4.QtGui import QDoubleValidator

from map_tools.parent import ParentMapTool

from qgis.core import QgsMapLayerRegistry, QgsExpression, QgsFeatureRequest, QgsPoint, QgsFeature, QgsGeometry, QgsVectorLayer, QgsMapToPixel


from ..ui.create_circle import Create_circle             # @UnresolvedImport


import utils_giswater


class CadAddCircle(ParentMapTool):
    """ Button 71: Add circle """

    def __init__(self, iface, settings, action, index_action):
        """ Class constructor """

        # Call ParentMapTool constructor
        super(CadAddCircle, self).__init__(iface, settings, action, index_action)


    def init_create_circle_form(self):
        """   """
        # Create the dialog and signals
        self.dlg_create_circle = Create_circle()
        utils_giswater.setDialog(self.dlg_create_circle)

        validator=QDoubleValidator(0.00, 9999.00, 3)
        validator.setNotation(QDoubleValidator().StandardNotation)

        self.dlg_create_circle.radius.setValidator(validator)
        self.dlg_create_circle.btn_accept.pressed.connect(self.get_radius)
        self.dlg_create_circle.btn_cancel.pressed.connect(self.cancel)
        self.dlg_create_circle.radius.setFocus()

        self.active_layer = self.iface.mapCanvas().currentLayer()
        self.virtual_layer = QgsMapLayerRegistry.instance().mapLayersByName('Polygon_aux')[0]

        self.dlg_create_circle.exec_()


    def get_radius(self):
        """   """
        self.radius = self.dlg_create_circle.radius.text()
        self.controller.log_info(str("RADIUS: " + self.radius))
        self.controller.log_info(str("ACTIVE: " + self.active_layer.name()))
        self.controller.log_info(str("VIRTUAL: " + self.virtual_layer.name()))
        self.virtual_layer.startEditing()
        self.dlg_create_circle.close()


    def cancel(self):
        """   """

        if self.virtual_layer.isEditable():
            self.virtual_layer.commitChanges()
        ParentMapTool.deactivate(self)
        self.deactivate(self)
        self.dlg_create_circle.close()


    """ QgsMapTools inherited event functions """

    def canvasMoveEvent(self, event):

        # Hide highlight
        self.vertex_marker.hide()

        # Get the click
        x = event.pos().x()
        y = event.pos().y()
        #Plugin reloader bug, MapTool should be deactivated
        try:
            event_point = QPoint(x, y)
        except(TypeError, KeyError):
            self.iface.actionPan().trigger()
            return

        # Snapping
        (retval, result) = self.snapper.snapToBackgroundLayers(event_point)  # @UnusedVariable

        # That's the snapped features
        if result:
            for snapped_feat in result:
                # Check if point belongs to 'node' group
                exist = self.snapper_manager.check_node_group(snapped_feat.layer)
                if exist:
                    # Get the point and add marker on it
                    point = QgsPoint(result[0].snappedVertex)
                    self.vertex_marker.setCenter(point)
                    self.vertex_marker.show()
                    break


    def canvasReleaseEvent(self, event):
        """   """
        if event.button() == Qt.LeftButton:
            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(), x, y)

            self.controller.log_info(str("X: " + str(x)))
            self.controller.log_info(str("Y: " + str(y)))

            self.init_create_circle_form()

            feature = QgsFeature()
            feature.setGeometry(QgsGeometry.fromPoint(point).buffer(float(self.radius),25))
            self.controller.log_info(str(self.virtual_layer.name()))
            provider = self.virtual_layer.dataProvider()
            self.virtual_layer.startEditing()
            provider.addFeatures([feature])

        elif event.button() == Qt.RightButton:
            ParentMapTool.deactivate(self)
            self.deactivate(self)

        self.virtual_layer.commitChanges()


    def activate(self):

        # Check button
        self.action().setChecked(True)

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Clear snapping
        self.snapper_manager.clear_snapping()

        # Set snapping to node
        self.snapper_manager.snap_to_node()

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Select the node inside a pipe by clicking on it and it will be replaced"
            self.controller.show_info(message)

        # Control current layer (due to QGIS bug in snapping system)
        if self.canvas.currentLayer() == None:
            self.iface.setActiveLayer(self.layer_node_man[0])

    def deactivate(self):

        # Call parent method
        ParentMapTool.deactivate(self)

    
