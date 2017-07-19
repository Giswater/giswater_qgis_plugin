'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-

from PyQt4.QtGui import QPushButton, QTableView, QTabWidget, QLineEdit, QAction,QMessageBox,QComboBox, QLabel
from PyQt4.QtCore import Qt, QSettings,QObject
from functools import partial

import utils_giswater
from parent_init import ParentDialog
#from init.ws_man_node_init import ManNodeDialog
from ui.ws_catalog import WScatalog                  # @UnresolvedImport

from qgis.core import QgsProject,QgsMapLayerRegistry,QgsExpression,QgsFeatureRequest

import init.ws_man_node_init
from PyQt4 import QtGui, uic
import os
from qgis.core import QgsMessageLog
from PyQt4.QtGui import QSizePolicy

from qgis.gui import QgsMapToolEmitPoint
from PyQt4.QtGui import *
from PyQt4.QtCore import *
from qgis.gui import QgsMapCanvasSnapper


def formOpen(dialog, layer, feature):
    ''' Function called when a connec is identified in the map '''
    
    global feature_dialog
    utils_giswater.setDialog(dialog)
    # Create class to manage Feature Form interaction    
    feature_dialog = Dimensions(dialog, layer, feature)
    init_config()
    
    
    
def init_config():
     
    # Manage 'arccat_id'
    # arccat_id = utils_giswater.getWidgetText("arccat_id") 
    # utils_giswater.setSelectedItem("arccat_id", arccat_id)   

    # Manage 'state'
    # state = utils_giswater.getWidgetText("state") 
    # utils_giswater.setSelectedItem("state", state)   
    pass
     
     
class Dimensions(ParentDialog):
    
    def __init__(self, dialog, layer, feature):
        ''' Constructor class '''
        
        
        super(Dimensions, self).__init__(dialog, layer, feature)      
        self.init_config_form()
        
        #QgsMapTool.__init__(self, QgisInterface.mapCanvas())
        
    def init_config_form(self):
        ''' Custom form initial configuration '''
        
        btn_orientation = self.dialog.findChild(QPushButton, "btn_orientation")
        btn_orientation.clicked.connect(self.orientation)
        
        #canvas = self.iface.mapCanvas()
        
        mapCanvas=self.iface.mapCanvas()
		# Create the appropriate map tool and connect the gotPoint() signal.
        self.emitPoint = QgsMapToolEmitPoint(mapCanvas)
        mapCanvas.setMapTool(self.emitPoint)
        QObject.connect(self.emitPoint, SIGNAL("canvasClicked(const QgsPoint &, Qt::MouseButton)"), self.clickButton)

        
    def orientation(self):
        pass
        
        
    def clickButton(self,point,btn):
        self.canvas=self.iface.mapCanvas()
        self.snapper = QgsMapCanvasSnapper(self.canvas)

        
        map_point = self.canvas.getCoordinateTransform().transform(point)
        x = map_point.x()
        y = map_point.y()
        eventPoint = QPoint(x, y)
        # Snapping
        (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)  # @UnusedVariable
        message = str(result)
        self.controller.show_info(message, context_name='ui_message')
        
        # That's the snapped point
        if result <> []:

            # Check feature
            for snapPoint in result:
                x = snapPoint.layer.name()
                
                message = str(x)
                self.controller.show_info(message, context_name='ui_message')
                
                # Get the point
                point = QgsPoint(result[0].snappedVertex)   #@UnusedVariable
                snappFeat = next(result[0].layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))
                feature = snappFeat
                node_id = feature.attribute('node_id')
                
                message = str(node_id)
                self.controller.show_info(message, context_name='ui_message')
        
                # LEAVE SELECTION
                result[0].layer.select([result[0].snappedAtGeometry])
                break
        
        
      
        