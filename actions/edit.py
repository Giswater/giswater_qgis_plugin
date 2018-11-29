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
    from PyQt4.QtCore import Qt, QPoint
    from PyQt4.QtGui import QApplication, QAction, QColor
else:
    from qgis.PyQt.QtCore import Qt, QPoint
    from qgis.PyQt.QtGui import QColor
    from qgis.PyQt.QtWidgets import QApplication, QAction


from qgis.core import QgsPoint
from qgis.gui import QgsMapToolEmitPoint, QgsVertexMarker

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
            self.iface.actionAddFeature().trigger()
        # # Vertex marker
        # self.vertex_marker = QgsVertexMarker(self.canvas)
        # self.vertex_marker.setColor(QColor(255, 100, 255))
        # self.vertex_marker.setIconSize(15)
        #
        # if feature_cat.type.lower() in ('node', 'connec'):
        #     self.controller.log_info(str("NODE"))
        #     self.vertex_marker.setIconType(QgsVertexMarker.ICON_CIRCLE)
        # elif feature_cat.type.lower() in ('arc'):
        #     self.controller.log_info(str("ARC"))
        #     self.vertex_marker.setIconType(QgsVertexMarker.ICON_CROSS)
        # self.vertex_marker.setPenWidth(3)

        # Snapper
        #self.snapper = self.get_snapper()
        self.canvas = self.iface.mapCanvas()
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        #self.canvas.xyCoordinates.connect(self.mouse_move)
        #self.xyCoordinates_conected = True
        self.emit_point.canvasClicked.connect(partial(self.set_geom, feature_cat))


    def mouse_move(self,  p):
        self.snapped_point = None
        self.vertex_marker.hide()
        map_point = self.canvas.getCoordinateTransform().transform(p)
        x = map_point.x()
        y = map_point.y()
        eventPoint = QPoint(x, y)

        # Snapping
        (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)  # @UnusedVariable

        # That's the snapped point
        if result:
            # Check feature
            for snapped_point in result:
                self.snapped_point = QgsPoint(snapped_point.snappedVertex)
                self.vertex_marker.setCenter(self.snapped_point)
                self.vertex_marker.show()
        else:
            self.vertex_marker.hide()


    def set_geom(self, feature_cat, point, button_clicked):

        # Control features with 1 point
        if button_clicked == Qt.LeftButton and feature_cat.type.lower() in ('node', 'connec'):
            #self.disconect_xyCoordinates()
            self.emit_point.canvasClicked.disconnect()
            self.points = '"x1":' + str(point.x()) + ', "y1":' + str(point.y())
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

