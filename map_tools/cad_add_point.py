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
from qgis.core import QgsFillSymbolV2, QgsSingleSymbolRendererV2, QgsMarkerSymbolV2

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
            message = "virtual_layer_point parameter not found or it's void!!"
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


        uri = "Point?crs=epsg:"+str(self.srid)

        virtual_layer = QgsVectorLayer(uri, virtual_layer_name, "memory")
        props = {'angle': '0', 'color': '0,128,0,255', 'horizontal_anchor_point': '1', 'offset': '0,0',
                 'offset_map_unit_scale': '0,0', 'offset_unit': 'MM', 'outline_color': '0,0,0,255',
                 'outline_style': 'solid', 'outline_width': '0', 'outline_width_map_unit_scale': '0,0',
                 'outline_width_unit': 'MM', 'scale_method': 'area', 'size': '2', 'size_map_unit_scale': '0,0',
                 'size_unit': 'MM', 'vertical_anchor_point': '1'}
        props = {'color':'red', 'color_border':'red', 'size': '1'}
        s = QgsMarkerSymbolV2.createSimple(props)
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
        self.virtual_layer_point.startEditing()
        self.dlg_create_point.close()


    def cancel(self):
        """   """

        self.dlg_create_point.close()
        self.iface.actionPan().trigger()
        if self.virtual_layer_point.isEditable():
            self.virtual_layer_point.commitChanges()


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
                # Get the point and add marker on it
                point = QgsPoint(result[0].snappedVertex)
                self.vertex_marker.setCenter(point)
                self.vertex_marker.show()
                

    def canvasReleaseEvent(self, event):
        if event.button() == Qt.LeftButton:
            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            init_point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(), x, y)


            event_point = QPoint(x, y)
            # Snapping
            (retval, result) = self.snapper.snapToBackgroundLayers(event_point)  # @UnusedVariable

            # That's the snapped features
            # That's the snapped features
            if result:
                for snapped_feat in result:
                    point = QgsPoint(result[0].snappedVertex)  # @UnusedVariable
                    feature = next(result[0].layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))
                    result[0].layer.select([result[0].snappedAtGeometry])
                    break
            self.init_create_point_form()

            sql = ("SELECT ST_GeomFromEWKT('SRID="+str(self.srid)+";"+str(feature.geometry().exportToWkt(3))+"')")
            row = self.controller.get_row(sql)

            inverter = utils_giswater.isChecked(self.dlg_create_point.chk_invert)
            sql = "SELECT "+self.controller.schema_name+".gw_fct_cad_add_relative_point('"+str(row[0])+"',"+utils_giswater.getWidgetText(self.dlg_create_point.dist_x)+","+utils_giswater.getWidgetText(self.dlg_create_point.dist_y)+","+str(inverter)+")"
            row = self.controller.get_row(sql)

            sql = "SELECT ST_AsText((ST_GeomFromWKB(ST_AsEWKB('"+row[0]+"'))))"
            geom = self.controller.get_row(sql)

            part1 = geom[0]
            part1 = part1[6:len(part1)-1]

            x = str(part1[0:len(part1)/2-2])
            y = str(part1[len(part1)/2+1:len(part1)-2])

            # 418933.539259056 , 4576797.52508555
            feature = QgsFeature()

            feature.setGeometry(QgsGeometry.fromPoint(QgsPoint(float(x), float(y))))
            provider = self.virtual_layer_point.dataProvider()
            self.virtual_layer_point.startEditing()
            provider.addFeatures([feature])

        elif event.button() == Qt.RightButton:
            ParentMapTool.deactivate(self)
            self.deactivate(self)

        self.virtual_layer_point.commitChanges()


    def activate(self):
        self.srid = self.controller.plugin_settings_value('srid')
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
    
