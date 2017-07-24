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

from PyQt4.QtCore import Qt
from qgis.core import QgsMapLayerRegistry

from qgis.gui import QgsVertexMarker
from PyQt4.QtGui import QCursor


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
        
        
    def init_config_form(self):
        ''' Custom form initial configuration '''
        #self.dialog.setWindowFlags(Qt.WindowStaysOnTopHint)
        
        btn_orientation = self.dialog.findChild(QPushButton, "btn_orientation")
        btn_orientation.clicked.connect(self.orientation)
        
        btn_snapping = self.dialog.findChild(QPushButton, "btn_snapping")
        btn_snapping.clicked.connect(self.snapping)
        
        mapCanvas=self.iface.mapCanvas()
		# Create the appropriate map tool and connect the gotPoint() signal.
        self.emitPoint = QgsMapToolEmitPoint(mapCanvas)
        mapCanvas.setMapTool(self.emitPoint)
 
        #QObject.connect(self.emitPoint, SIGNAL("canvasClicked(const QgsPoint &, Qt::MouseButton)"), self.clickButton)
        
        #canvas.xyCoordinates.connect( self.canvasMoveEvent )
        
        self.canvas=self.iface.mapCanvas()
        self.snapper = QgsMapCanvasSnapper(self.canvas)
        #QObject.connect(self.canvas, SIGNAL("renderComplete(QPainter *)"),self.checkLayers)
        #QObject.connect(self.canvas, SIGNAL("mouseMoveEvent(const QgsPoint)"), self.test)
        #cursor = QCursor()
        #cursor.setShape(Qt.WhatsThisCursor)
        #setTextCursor(self.cursor)
        
    def orientation(self):
        # Disconnect previous snapping
        QObject.disconnect(self.emitPoint, SIGNAL("canvasClicked(const QgsPoint &, Qt::MouseButton)"), self.clickButtonSnapping)
        QObject.connect(self.emitPoint, SIGNAL("canvasClicked(const QgsPoint &, Qt::MouseButton)"), self.clickButtonOrientation)
        
        
    def snapping(self):
  
        # Disconnect previous snapping
        QObject.disconnect(self.emitPoint, SIGNAL("canvasClicked(const QgsPoint &, Qt::MouseButton)"), self.clickButtonOrientation)
        
        # Track mouse movement
        self.canvas.xyCoordinates.connect( self.canvasMoveEvent )


        QObject.connect(self.emitPoint, SIGNAL("canvasClicked(const QgsPoint &, Qt::MouseButton)"), self.clickButtonSnapping)

        
    def clickButtonOrientation(self,point,btn):
    
        layer = QgsMapLayerRegistry.instance().mapLayersByName("v_edit_dimensions")[0]
        self.iface.setActiveLayer(layer)
        
        # Find the layer to edit
        #layer = self.iface.activeLayer()
        layer.startEditing()

        self.canvas=self.iface.mapCanvas()
        self.snapper = QgsMapCanvasSnapper(self.canvas)
        
        self.x_symbol=self.dialog.findChild(QLineEdit, "x_symbol")
        self.x_symbol.setText(str(point.x()))
                
        self.y_symbol=self.dialog.findChild(QLineEdit, "y_symbol")
        self.y_symbol.setText(str(point.y()))
        

    def clickButtonSnapping(self,point,btn):
    
        # Deactivate mouse tracking
        # Track mouse movement
        self.canvas.xyCoordinates.disconnect( self.canvasMoveEvent )        
    
    
        layer = QgsMapLayerRegistry.instance().mapLayersByName("v_edit_dimensions")[0]
        self.iface.setActiveLayer(layer)
        
        # Find the layer to edit
        #layer = self.iface.activeLayer()
        layer.startEditing()
        
        node_group = ["Junction","Valve","Reduction","Tank","Meter","Manhole","Source"]
        connec_group = ["Wjoin","Fountain"]
        arc_group = ["Pipe"]
        self.canvas=self.iface.mapCanvas()
        self.snapper = QgsMapCanvasSnapper(self.canvas)

        map_point = self.canvas.getCoordinateTransform().transform(point)
        x = map_point.x()
        y = map_point.y()
        eventPoint = QPoint(x, y)
                     
        # Snapping
        (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)  # @UnusedVariable
            
        # That's the snapped point
        if result <> []:

            # Check feature
            for snapPoint in result:
                
                element_type = snapPoint.layer.name()
                
                if element_type in node_group:
                    feat_type = 'node'
                if element_type in connec_group:
                    feat_type = 'connec'
                if element_type in arc_group:
                    feat_type = 'arc'
                
                        
                # Get the point
                point = QgsPoint(result[0].snappedVertex)   #@UnusedVariable
                snappFeat = next(result[0].layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))
                feature = snappFeat
                element_id = feature.attribute(feat_type+'_id')
 
                # LEAVE SELECTION
                result[0].layer.select([result[0].snappedAtGeometry])
           
                # Get depth of feature
                sql = "SELECT depth FROM "+self.schema_name+"."+feat_type+" WHERE "+feat_type+"_id = '"+element_id+"'"  
                message = str(sql)
                self.controller.show_info(message, context_name='ui_message' )
                
                rows = self.controller.get_rows(sql) 
                
                message = str(rows)
                self.controller.show_info(message, context_name='ui_message' )
                
                self.depth=self.dialog.findChild(QLineEdit, "depth")
                self.depth.setText(str(rows[0][0]))
                self.feature_id =self.dialog.findChild(QLineEdit, "feature_id")
                self.feature_id.setText(str(element_id))
                self.feature_type =self.dialog.findChild(QLineEdit, "feature_type")
                self.feature_type.setText(str(element_type))
                
                # Reset snapping
                point = []
                break
                        
                        
    def canvasMoveEvent(self,point):
        #message = str(point)
        #self.controller.show_info(message, context_name='ui_message' )
        
        map_point = self.canvas.getCoordinateTransform().transform(point)
        x = map_point.x()
        y = map_point.y()
        eventPoint = QPoint(x, y)
        
        # Change cursor
        # Change map tool cursor
        #self.cursor = QCursor()
        #self.cursor.setShape(Qt.WhatsThisCursor)
        #self.setTextCursor(self.cursor)
        
                   
        # Snapping
        (retval, result) = self.snapper.snapToBackgroundLayers(eventPoint)  # @UnusedVariable
          
        #message = str(result)
        #self.controller.show_info(message, context_name='ui_message' )        
        # That's the snapped point
        if result <> []:

            # Check feature
            for snapPoint in result:
                        
                # Get the point
                point = QgsPoint(result[0].snappedVertex)   #@UnusedVariable
                snappFeat = next(result[0].layer.getFeatures(QgsFeatureRequest().setFilterFid(result[0].snappedAtGeometry)))
                feature = snappFeat
                element_id = feature.attribute('reduction_depth')
                message = str(element_id)
                self.controller.show_info(message, context_name='ui_message' )
      
  