'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from PyQt4.QtCore import QPoint
from PyQt4.QtCore import Qt

from map_tools.parent import ParentMapTool

from qgis.core import QgsMapLayerRegistry, QgsExpression, QgsFeatureRequest, QgsPoint


from ..ui.create_circle import Create_circle             # @UnresolvedImport


import utils_giswater


class CadAddCircle(ParentMapTool):
    """ Button 71: Add circle """

    def __init__(self, iface, settings, action, index_action):
        """ Class constructor """

        # Call ParentMapTool constructor
        super(CadAddCircle, self).__init__(iface, settings, action, index_action)

    def init_create_circle_form(self):
        # Create the dialog and signals
        self.dlg_create_circle = Create_circle()
        utils_giswater.setDialog(self.dlg_create_circle)

        self.dlg_create_circle.btn_accept.pressed.connect(self.get_radius)
        self.dlg_create_circle.btn_cancel.pressed.connect(self.cancel)
        self.active_layer=self.iface.mapCanvas().currentLayer()

        self.virtual_layer = QgsMapLayerRegistry.instance().mapLayersByName('Point_aux')[0]

        self.dlg_create_circle.exec_()


    def get_radius(self):
        radius = self.dlg_create_circle.radius.text()
        self.controller.log_info(str("RADIUS: " + radius))
        self.controller.log_info(str("ACTIVE: " + self.active_layer.name()))
        self.controller.log_info(str("VIRTUAL: " + self.virtual_layer.name()))
        self.virtual_layer.startEditing()
        self.dlg_create_circle.close()



    def cancel(self):
        if self.active_layer.isEditing():
            self.controller.log_info(str("CANCEL"))
            self.active_layer.commitChanges()
    """ QgsMapTools inherited event functions """

    def canvasMoveEvent(self, event):

        # Hide highlight
        self.vertex_marker.hide()

        # Get the click
        x = event.pos().x()
        y = event.pos().y()
        self.controller.log_info(str("TEST 1"))
        self.controller.log_info(str("X: "+ str(x)))
        self.controller.log_info(str("Y: "+ str(y)))
        self.controller.log_info(str("TEST 2"))
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
        self.controller.log_info(str("TEST 3"))
        pass




    def activate(self):

        # Check button
        self.action().setChecked(True)

        self.init_create_circle_form()

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

    
