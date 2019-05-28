"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except:
    from qgis.core import QGis as Qgis
from functools import partial
from giswater.actions.api_cf import ApiCF
from giswater.actions.manage_element import ManageElement        
from giswater.actions.manage_document import ManageDocument      
from giswater.actions.manage_workcat_end import ManageWorkcatEnd      
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
        # feature.setAttribute('state', '2')
        # feature.setAttribute('state_type', '5')
        # layer.updateFeature(feature)

        geom = feature.geometry()
        list_points = None
        if layer.geometryType() == Qgis.Point:
            points = geom.asPoint()
            list_points = '"x1":' + str(points.x()) + ', "y1":' + str(points.y())
        elif layer.geometryType() in(Qgis.Line, Qgis.Polygon):
            points = geom.asPolyline()
            init_point = points[0]
            last_point = points[-1]
            list_points = '"x1":' + str(init_point.x()) + ', "y1":' + str(init_point.y())
            list_points += ', "x2":' + str(last_point.x()) + ', "y2":' + str(last_point.y())

        else:
            self.controller.log_info(str(type("NO FEATURE TYPE DEFINED")))

        self.api_cf = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir, 'data')
        result, dialog = self.api_cf.open_form(point=list_points, feature_cat=feature_cat, new_feature_id=feature_id, layer_new_feature=layer, tab_type='data', new_feature=feature)

        if result is False:
            layer.deleteFeature(feature.id())
            self.iface.actionRollbackEdits().trigger()

        #self.iface.actionPan().trigger()

    def get_feature_by_id(self, layer, id_):
        iter = layer.getFeatures()
        for feature in iter:
            if feature.id() == id_:
                return feature
        return False


    def edit_add_element(self):
        """ Button 33: Add element """       
        self.manage_element.manage_element()


    def edit_add_file(self):
        """ Button 34: Add document """   
        self.manage_document.manage_document()
        
    
    def edit_document(self):
        """ Button 66: Edit document """          
        self.manage_document.edit_document()        
        
            
    def edit_element(self):
        """ Button 67: Edit element """          
        self.manage_element.edit_element()


    def edit_end_feature(self):
        """ Button 68: Edit end feature """
        self.manage_workcat_end.manage_workcat_end()

