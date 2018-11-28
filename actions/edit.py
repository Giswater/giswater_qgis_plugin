"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except:
    from qgis.core import QGis as Qgis
if Qgis.QGIS_VERSION_INT >= 21400 and Qgis.QGIS_VERSION_INT < 29900:
    from PyQt4.QtCore import Qt
    from PyQt4.QtGui import QApplication
else:
    from qgis.PyQt.QtCore import Qt
    from qgis.PyQt.QtWidgets import QApplication

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
        self.controller.log_info(str(feature_cat))
        """ Button 01, 02: Add 'node' or 'arc' """
        self.controller.restore_info()
        # Set active layer and triggers action Add Feature
        # add "listener" to all actions to desactivate basic_api_info
        # actions_list = self.iface.mainWindow().findChildren(QAction)
        # for action in actions_list:
        #     if action.objectName() != 'basic_api_info' and self.controller.api_cf is not None:
        #         action.triggered.connect(partial(self.controller.restore_info))
        # Create the appropriate map tool and connect the gotPoint() signal.
        # self.canvas = self.iface.mapCanvas()
        # self.emit_point = QgsMapToolEmitPoint(self.canvas)
        # self.canvas.setMapTool(self.emit_point)

        self.api_cf = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir)
        self.controller.api_cf = self.api_cf
        self.api_cf.api_info()



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

