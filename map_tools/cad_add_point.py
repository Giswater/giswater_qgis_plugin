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

from qgis.core import QgsMapLayerRegistry, QgsExpression, QgsFeatureRequest, QgsVectorLayer, QgsFeature, QgsGeometry
from qgis.core import QgsPoint, QgsMapToPixel, QgsProject, QgsRasterLayer
from qgis.core import QgsFillSymbolV2, QgsSingleSymbolRendererV2

from ..ui.cad_add_point import Cad_add_point             # @UnresolvedImport

import utils_giswater

class CadAddPoint(ParentMapTool):
    """ Button 72: Add point """

    def __init__(self, iface, settings, action, index_action):
        """ Class constructor """

        # Call ParentMapTool constructor
        super(CadAddPoint, self).__init__(iface, settings, action, index_action)

    def init_create_point_form(self):
        """   """
        # Create the dialog and signals
        self.dlg_create_point = Cad_add_point()
        utils_giswater.setDialog(self.dlg_create_point)

        sql = ("SELECT value FROM "+self.controller.schema_name+".config_param_user WHERE parameter='virtual_layer_point'")
        row = self.controller.get_row(sql)
        if row:
            virtual_layer_name = row[0]
        else:
            message = "virtual_layer_polygon parameter not found or it's void!!"
            self.controller.show_warning(message)
            self.cancel()
            return
        if self.exist_virtual_layer(virtual_layer_name):
            validator = QDoubleValidator(0.00, 9999.999, 3)
            validator.setNotation(QDoubleValidator().StandardNotation)
            self.dlg_create_point.dist_x.setValidator(validator)
            self.dlg_create_point.dist_y.setValidator(validator)
            self.dlg_create_point.btn_accept.pressed.connect(self.get_values)
            self.dlg_create_point.btn_cancel.pressed.connect(self.cancel)
            self.dlg_create_point.dist_x.setFocus()
            #
            self.active_layer = self.iface.mapCanvas().currentLayer()
            self.virtual_layer_point = self.controller.get_layer_by_layername(virtual_layer_name, True)

            self.dlg_create_point.exec_()
        else:
            self.create_virtual_layer(virtual_layer_name)
            message = "Virtual layer point not exist, we create!"
            self.controller.show_warning(message)


    def create_virtual_layer(self, virtual_layer_name):
        srid = self.controller.plugin_settings_value('srid')

        uri = "Point?crs=epsg:"+str(srid)

        virtual_layer = QgsVectorLayer(uri, virtual_layer_name, "memory")

        props = {'color': '0, 0, 0', 'style': 'no', 'style_border': 'solid', 'color_border': '255, 0, 0'}
        s = QgsFillSymbolV2.createSimple(props)
        virtual_layer.setRendererV2(QgsSingleSymbolRendererV2(s))
        virtual_layer.updateExtents()
        QgsMapLayerRegistry.instance().addMapLayer(virtual_layer)
        self.iface.mapCanvas().refresh()

    def exist_virtual_layer(self, virtual_layer_name):

        layers = self.iface.mapCanvas().layers()
        for layer in layers:
            if layer.name() == virtual_layer_name:
                return True
        return False

    def get_values(self):
        """   """
        self.dist_x = self.dlg_create_point.dist_x.text()
        self.dist_y = self.dlg_create_point.dist_y.text()
        self.controller.log_info(str("DIST X: " + self.dist_x))
        self.controller.log_info(str("DIST Y: " + self.dist_y))
        self.controller.log_info(str("ACTIVE: " + self.active_layer.name()))
        self.controller.log_info(str("VIRTUAL: " + self.virtual_layer_point.name()))
        self.virtual_layer_point.startEditing()
        self.dlg_create_point.close()



    def cancel(self):
        """   """

        if self.virtual_layer_point.isEditable():
            self.virtual_layer_point.commitChanges()
        ParentMapTool.deactivate(self)
        self.deactivate(self)
        self.dlg_create_point.close()

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
        if event.button() == Qt.LeftButton:
            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            init_point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(), x, y)

            self.controller.log_info(str("X: " + str(x)))
            self.controller.log_info(str("Y: " + str(y)))

            self.init_create_circle_form()

            feature = QgsFeature()
            feature.setGeometry(QgsGeometry.fromPoint(init_point).buffer(float(self.radius),25))
            self.controller.log_info(str(self.virtual_layer_point.name()))
            provider = self.virtual_layer_point.dataProvider()
            self.virtual_layer_point.startEditing()
            provider.addFeatures([feature])

        elif event.button() == Qt.RightButton:
            ParentMapTool.deactivate(self)
            self.deactivate(self)

        self.virtual_layer_point.commitChanges()


    def activate(self):
        self.init_create_point_form()



    def deactivate(self):

        # Call parent method     
        ParentMapTool.deactivate(self)
    
