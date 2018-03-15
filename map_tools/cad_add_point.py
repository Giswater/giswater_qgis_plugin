'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from PyQt4.QtCore import Qt
from PyQt4.QtGui import QDoubleValidator
from qgis.core import QgsMapLayerRegistry, QgsFeatureRequest, QgsVectorLayer, QgsFeature, QgsGeometry, QgsPoint
from qgis.core import QgsProject, QgsSingleSymbolRendererV2, QgsMarkerSymbolV2

import utils_giswater
from map_tools.parent import ParentMapTool
from ui.cad_add_point import Cad_add_point
from functools import partial


class CadAddPoint(ParentMapTool):
    """ Button 72: Add point """

    def __init__(self, iface, settings, action, index_action):
        """ Class constructor """

        # Call ParentMapTool constructor
        super(CadAddPoint, self).__init__(iface, settings, action, index_action)
        self.cancel_point = False
        self.virtual_layer_point = None
        self.worker_layer = None

        
    def init_create_point_form(self):

        # Create the dialog and signals
        self.dlg_create_point = Cad_add_point()
        utils_giswater.setDialog(self.dlg_create_point)
        self.load_settings(self.dlg_create_point)

        virtual_layer_name = "point"
        sql = ("SELECT value FROM " + self.controller.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND parameter = 'virtual_layer_point'")        
        row = self.controller.get_row(sql)
        if row:
            virtual_layer_name = row[0]
        
        if self.exist_virtual_layer(virtual_layer_name):
            self.get_point(virtual_layer_name)
        else:
            self.create_virtual_layer(virtual_layer_name)
            message = "Virtual layer not found. It's gonna be created"
            self.controller.show_info(message)
            self.iface.setActiveLayer(self.worker_layer)
            self.get_point(virtual_layer_name)


    def get_point(self, virtual_layer_name):
        validator = QDoubleValidator(-99999.99, 99999.999, 3)
        validator.setNotation(QDoubleValidator().StandardNotation)
        self.dlg_create_point.dist_x.setValidator(validator)
        validator = QDoubleValidator(-99999.99, 99999.999, 3)
        validator.setNotation(QDoubleValidator().StandardNotation)
        self.dlg_create_point.dist_y.setValidator(validator)
        self.dlg_create_point.btn_accept.pressed.connect(self.get_values)
        self.dlg_create_point.btn_cancel.pressed.connect(self.cancel)
        self.dlg_create_point.dist_x.setFocus()

        self.active_layer = self.iface.mapCanvas().currentLayer()
        self.virtual_layer_point = self.controller.get_layer_by_layername(virtual_layer_name, True)
        
        # Open dialog
        self.open_dialog(self.dlg_create_point, maximize_button=False)


    def create_virtual_layer(self, virtual_layer_name):
    
        sql = ("SELECT value FROM " + self.controller.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND parameter = 'virtual_layer_point'")
        row = self.controller.get_row(sql)
        if not row:
            sql = ("INSERT INTO " + self.schema_name + ".config_param_user (parameter, value, cur_user) "
                   " VALUES ('virtual_layer_point', '" + virtual_layer_name + "', current_user)")
            self.controller.execute_sql(sql)
        uri = "Point?crs=epsg:" + str(self.srid)
        virtual_layer = QgsVectorLayer(uri, virtual_layer_name, "memory")
        props = {'color': 'red', 'color_border': 'red', 'size': '1.5'}
        s = QgsMarkerSymbolV2.createSimple(props)
        virtual_layer.setRendererV2(QgsSingleSymbolRendererV2(s))
        virtual_layer.updateExtents()
        QgsProject.instance().setSnapSettingsForLayer(virtual_layer.id(), True, 0, 0, 1.0, False)
        QgsMapLayerRegistry.instance().addMapLayer(virtual_layer)
        self.iface.mapCanvas().refresh()


    def exist_virtual_layer(self, virtual_layer_name):

        layers = self.iface.mapCanvas().layers()
        for layer in layers:
            if layer.name() == virtual_layer_name:
                return True
        return False


    def get_values(self):

        self.dist_x = self.dlg_create_point.dist_x.text()
        self.dist_y = self.dlg_create_point.dist_y.text()
        if self.virtual_layer_point:        
            self.virtual_layer_point.startEditing()
            self.close_dialog(self.dlg_create_point)


    def cancel(self):

        self.close_dialog(self.dlg_create_point)
        self.iface.setActiveLayer(self.current_layer)
        if self.virtual_layer_point:        
            if self.virtual_layer_point.isEditable():
                self.virtual_layer_point.commitChanges()
        self.cancel_point = True
        self.cancel_map_tool()

        
    def select_feature(self):

        self.canvas.selectionChanged.disconnect()
        features = self.worker_layer.selectedFeatures()

        if len(features) == 0:
            return

        for f in features:
            feature = f

        self.init_create_point_form()
        if not self.cancel_point:
            if self.virtual_layer_point:
                sql = ("SELECT ST_GeomFromEWKT('SRID=" + str(self.srid) + ";" + str(feature.geometry().exportToWkt(3)) + "')")
                row = self.controller.get_row(sql)
                if not row:
                    return
                inverter = utils_giswater.isChecked(self.dlg_create_point.chk_invert)
                sql = ("SELECT " + self.controller.schema_name + ".gw_fct_cad_add_relative_point"
                       "('" + str(row[0]) + "', " + utils_giswater.getWidgetText(self.dlg_create_point.dist_x) + ", "
                       + utils_giswater.getWidgetText(self.dlg_create_point.dist_y) + ", " + str(inverter) + ")")
                row = self.controller.get_row(sql)
                if not row:
                    return
                point = row[0]
                feature = QgsFeature()
                feature.setGeometry(QgsGeometry.fromPoint(QgsPoint(float(point[0]), float(point[1]))))
                provider = self.virtual_layer_point.dataProvider()
                self.virtual_layer_point.startEditing()
                provider.addFeatures([feature])
                self.virtual_layer_point.commitChanges()
                self.canvas.selectionChanged.connect(partial(self.select_feature))
        else:
            self.iface.setActiveLayer(self.current_layer)
            self.cancel_map_tool()
            self.cancel_point = False
            return



    """ QgsMapTools inherited event functions """


    def canvasReleaseEvent(self, event):

        if event.button() == Qt.RightButton:
            self.iface.setActiveLayer(self.current_layer)
            self.cancel_map_tool()
            self.iface.actionPan().trigger()
            return

        if self.virtual_layer_point:
            self.virtual_layer_point.commitChanges()


    def activate(self):

        # Get SRID
        self.srid = self.controller.plugin_settings_value('srid')

        # Check button
        self.action().setChecked(True)

        # Show help message when action is activated
        if self.show_help:
            message = "Select an arc and click it to set distances"
            self.controller.show_info(message)

        # Get current layer
        if self.iface.activeLayer():
            self.current_layer = self.iface.activeLayer()
            self.controller.log_info(str(self.current_layer.name()))

        # Check for default base layer,
        sql = ("SELECT value FROM " + self.controller.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND parameter = 'cad_tools_base_layer_vdefault'")
        row = self.controller.get_row(sql)
        # If cad_tools_base_layer_vdefault exist prevails over selected layer
        if row:
            self.worker_layer = self.controller.get_layer_by_layername(row[0])
            if self.worker_layer:
                self.iface.setActiveLayer(self.worker_layer)
            else:
                self.worker_layer = self.iface.activeLayer()
        else:
            self.worker_layer = self.iface.activeLayer()

        if self.worker_layer:
            self.iface.legendInterface().setLayerVisible(self.worker_layer, True)

        # Select map tool 'Select features' and set signal
        # Change cursor

        self.iface.actionSelect().trigger()
        #self.canvas.setCursor(self.cursor)
        self.iface.setActiveLayer(self.worker_layer)
        self.canvas.selectionChanged.connect(partial(self.select_feature))


    def deactivate(self):
    
        # Call parent method
        try:
            if self.current_layer:
                self.iface.setActiveLayer(self.current_layer)
        except:
            pass
        finally:
            ParentMapTool.deactivate(self)
            
            