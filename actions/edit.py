"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from functools import partial

try:
    from qgis.core import Qgis
except:
    from qgis.core import QGis as Qgis
if Qgis.QGIS_VERSION_INT >= 21400 and Qgis.QGIS_VERSION_INT < 29900:
    from PyQt4.QtCore import Qt, QPoint, pyqtSignal
    from PyQt4.QtGui import QApplication, QAction, QColor
else:
    from qgis.PyQt.QtCore import Qt, QPoint, pyqtSignal
    from qgis.PyQt.QtGui import QColor
    from qgis.PyQt.QtWidgets import QApplication, QAction


from qgis.core import QgsPoint
from qgis.gui import QgsMapToolEmitPoint, QgsVertexMarker, QgsMapTool

from giswater.actions.api_cf import ApiCF
from giswater.actions.manage_element import ManageElement        
from giswater.actions.manage_document import ManageDocument      
from giswater.actions.manage_workcat_end import ManageWorkcatEnd

from giswater.actions.api_parent import ApiParent
from giswater.actions.parent import ParentAction




class Edit(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'edit' """
                
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.manage_document = ManageDocument(iface, settings, controller, plugin_dir)
        self.manage_element = ManageElement(iface, settings, controller, plugin_dir)
        self.manage_workcat_end = ManageWorkcatEnd(iface, settings, controller, plugin_dir)



    def set_project_type(self, project_type):
        self.project_type = project_type


    def edit_add_feature(self, feature_cat):
        """ Button 01, 02: Add 'node' or 'arc' """
        self.api_parent = ApiParent(self.iface, self.settings, self.controller, self.plugin_dir)
        self.coords_list = []
        self.points = None
        self.last_points = None
        self.previous_map_tool = self.canvas.mapTool()
        self.controller.restore_info()
        layer = self.controller.get_layer_by_tablename(feature_cat.parent_layer)


        if layer:
            self.iface.setActiveLayer(layer)
            layer.startEditing()
            layer.featureAdded.connect(partial(self.open_new_feature, layer, feature_cat))
            self.iface.actionAddFeature().trigger()

        else:
            message = "Selected layer name not found"
            self.controller.show_warning(message, parameter=feature_cat.parent_layer)


    def open_new_feature(self, layer, feature_cat, feature_id):
        feature = self.get_feature_by_id(layer, feature_id)
        geom = feature.geometry()

        if layer.geometryType() == Qgis.Point:
            points = geom.asPoint()
            list_points = '"x1":' + str(points.x()) + ', "y1":' + str(points.y())
            the_geom = geom.asWkb().encode('hex')

        elif layer.geometryType() in(Qgis.Line, Qgis.Polygon):
            points = geom.asPolyline()
            init_point = points[0]
            last_point = points[-1]
            list_points = '"x1":' + str(init_point.x()) + ', "y1":' + str(init_point.y())
            list_points += ', "x2":' + str(last_point.x()) + ', "y2":' + str(last_point.y())
            the_geom = geom.asWkb().encode('hex')

        else:
            self.controller.log_info(str(type("NO FEATURE TYPE DEFINED")))

        self.controller.log_info(str("INIT:") + str(the_geom))
        self.api_cf = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir)
        self.controller.api_cf = self.api_cf
        self.api_cf.open_form(point=list_points, feature_cat=feature_cat, new_feature_id=feature_id, layer_new_feature=layer)


    def get_feature_by_id(self, layer, id_):
        iter = layer.getFeatures()
        for feature in iter:
            if feature.id() == id_:
                return feature
        return False


    def set_geom(self, layer, feature_id,feature_cat,points, point, button_clicked ):
        self.controlloer.log_info(str("WORKWORKWORKWORKWORKWORKWORKWORK"))
        self.controlloer.log_info(str("WORKWORKWORKWORKWORKWORKWORKWORK"))
        self.controlloer.log_info(str("WORKWORKWORKWORKWORKWORKWORKWORK"))

        # Control features with 1 point
        if button_clicked == Qt.LeftButton and feature_cat.type.lower() in ('node', 'connec'):
            #self.disconect_xyCoordinates()

            self.points = '"x1":' + str(points.x()) + ', "y1":' + str(points.y())
            self.api_cf = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir)
            self.controller.api_cf = self.api_cf
            self.api_cf.open_form(point=self.points, feature_cat=feature_cat)
        elif button_clicked == Qt.RightButton and feature_cat.type.lower() in ('node', 'connec'):
            #self.disconect_xyCoordinates()
            self.emit_point.canvasClicked.disconnect()
            if self.controller.previous_maptool is not None:
                self.canvas.setMapTool(self.controller.previous_maptool)


        # Control features with more than 1 point
        if button_clicked == Qt.LeftButton and feature_cat.type.lower() in ('arc'):
            if self.points is None:
                self.points = '"x1":' + str(point.x()) + ', "y1":' + str(point.y())
                point = QgsPoint(float(point.x()), float(point.y()))
                self.coords_list.append(point)
                print(self.coords_list)

            else:
                self.last_points = ', "x2":' + str(point.x()) + ', "y2":' + str(point.y())
                point = QgsPoint(float(point.x()), float(point.y()))
                self.coords_list.append(point)

        elif button_clicked == Qt.RightButton and feature_cat.type.lower() in ('arc'):
            #self.disconect_xyCoordinates()
            if self.last_points is None:
                if self.controller.previous_maptool is not None:
                    self.canvas.setMapTool(self.controller.previous_maptool)
                self.emit_point.canvasClicked.disconnect()
                return
            else:

                self.points = self.points + self.last_points
                self.api_cf = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir)
                self.controller.api_cf = self.api_cf
                self.api_cf.open_form(point=self.points, feature_cat=feature_cat)


        # layer = self.controller.get_layer_by_tablename(layername)
        # if layer:
        #     self.iface.setActiveLayer(layer)
        #     layer.startEditing()
        #     self.iface.actionAddFeature().trigger()
        # else:
        #     message = "Selected layer name not found"
        #     self.controller.show_warning(message, parameter=layername)


    def edit_add_element(self):
        """ Button 33: Add element """
        self.controller.restore_info()
        self.manage_element.manage_element()


    def edit_add_file(self):
        """ Button 34: Add document """
        self.controller.restore_info()
        self.manage_document.manage_document()
        
    
    def edit_document(self):
        """ Button 66: Edit document """
        self.controller.restore_info()
        self.manage_document.edit_document()        
        
            
    def edit_element(self):
        """ Button 67: Edit element """
        self.controller.restore_info()
        self.manage_element.edit_element()


    def edit_end_feature(self):
        """ Button 68: Edit end feature """
        self.controller.restore_info()
        self.manage_workcat_end.manage_workcat_end()

