"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-          
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


    def edit_add_feature(self, layername):
        """ Button 01, 02: Add 'node' or 'arc' """
                
        # Set active layer and triggers action Add Feature
        layer = self.controller.get_layer_by_layername(layername)
        if layer:
            self.iface.setActiveLayer(layer)
            layer.startEditing()
            self.iface.actionAddFeature().trigger()
        else:
            message = "Selected layer name not found"
            self.controller.show_warning(message, parameter=layername)


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

