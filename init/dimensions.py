'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''
# -*- coding: utf-8 -*-
from PyQt4.QtGui import QPushButton, QLineEdit
from PyQt4.QtCore import QObject, QTimer, QPoint, SIGNAL
from qgis.core import QgsMapLayerRegistry, QgsFeatureRequest, QgsPoint
from qgis.gui import QgsMapToolEmitPoint, QgsMapTip, QgsMapCanvasSnapper

import utils_giswater
from parent_init import ParentDialog


def formOpen(dialog, layer, feature):
    ''' Function called when a connec is identified in the map '''
    
    global feature_dialog
    utils_giswater.setDialog(dialog)
    # Create class to manage Feature Form interaction    
    feature_dialog = Dimensions(dialog, layer, feature)
    init_config()
    

def init_config():
    pass
     
     
class Dimensions(ParentDialog):
    
    def __init__(self, dialog, layer, feature):
        ''' Constructor class '''
        
        super(Dimensions, self).__init__(dialog, layer, feature)      
        self.init_config_form()
        dialog.parent().setFixedSize(320, 410)
        
        
    def init_config_form(self):
        ''' Custom form initial configuration '''
        
        btn_orientation = self.dialog.findChild(QPushButton, "btn_orientation")
        btn_orientation.clicked.connect(self.orientation)
        btn_snapping = self.dialog.findChild(QPushButton, "btn_snapping")
        btn_snapping.clicked.connect(self.snapping)
        
        mapCanvas = self.iface.mapCanvas()
        # Create the appropriate map tool and connect the gotPoint() signal.
        self.emitPoint = QgsMapToolEmitPoint(mapCanvas)
        mapCanvas.setMapTool(self.emitPoint)
        
        self.canvas = self.iface.mapCanvas()
        self.snapper = QgsMapCanvasSnapper(self.canvas)
        self.create_map_tips()
        
        
    def orientation(self):
        
        # Disconnect previous snapping
        QObject.disconnect(self.emitPoint, SIGNAL("canvasClicked(const QgsPoint &, Qt::MouseButton)"), self.click_button_snapping)
        QObject.connect(self.emitPoint, SIGNAL("canvasClicked(const QgsPoint &, Qt::MouseButton)"), self.click_button_orientation)
        
        
    def snapping(self):
               
        # Disconnect previous snapping
        QObject.disconnect(self.emitPoint, SIGNAL("canvasClicked(const QgsPoint &, Qt::MouseButton)"), self.click_button_orientation)
        
        # Track mouse movement
        QObject.connect(self.emitPoint, SIGNAL("canvasClicked(const QgsPoint &, Qt::MouseButton)"), self.click_button_snapping)
        
        #self.canvas.xyCoordinates.disconnect( self.canvasMoveEvent )
        
        
    def click_button_orientation(self, point, btn): #@UnusedVariable
    
        layer = QgsMapLayerRegistry.instance().mapLayersByName("v_edit_dimensions")[0]
        self.iface.setActiveLayer(layer)

        self.canvas = self.iface.mapCanvas()
        self.snapper = QgsMapCanvasSnapper(self.canvas)

        self.x_symbol = self.dialog.findChild(QLineEdit, "x_symbol")
        self.x_symbol.setText(str(point.x()))
        self.y_symbol = self.dialog.findChild(QLineEdit, "y_symbol")
        self.y_symbol.setText(str(point.y()))
        

    def click_button_snapping(self, point, btn):    #@UnusedVariable
                 
        layer = QgsMapLayerRegistry.instance().mapLayersByName("v_edit_dimensions")[0]
        self.iface.setActiveLayer(layer)
        layer.startEditing()
        
        node_group = ["Junction","Valve","Reduction","Tank","Meter","Manhole","Source","Hydrant"]
        connec_group = ["Wjoin","Fountain"]
        
        self.canvas = self.iface.mapCanvas()
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
                #self.controller.show_info(str(element_type), context_name='ui_message')
                if element_type in node_group:
                    feat_type = 'node'
                elif element_type in connec_group:
                    feat_type = 'connec'
                else:
                    continue
                        
                # Get the point
                point = QgsPoint(snapPoint.snappedVertex)   
                snappFeat = next(snapPoint.layer.getFeatures(QgsFeatureRequest().setFilterFid(snapPoint.snappedAtGeometry)))
                feature = snappFeat
                element_id = feature.attribute(feat_type+'_id')
 
                # LEAVE SELECTION
                snapPoint.layer.select([snapPoint.snappedAtGeometry])
           
                # Get depth of feature
                sql = "SELECT depth"
                sql+= " FROM "+self.schema_name+"."+feat_type 
                sql+= " WHERE "+feat_type+"_id = '"+element_id+"'"  
                row = self.dao.get_row(sql)
                if not row:
                    return
                depth = self.dialog.findChild(QLineEdit, "depth")
                depth.setText(str(row[0]))
                feature_id = self.dialog.findChild(QLineEdit, "feature_id")
                feature_id.setText(str(element_id))
                feature_type = self.dialog.findChild(QLineEdit, "feature_type")
                feature_type.setText(str(element_type))
            
                # Reset snapping
                point = []
               
    
    def create_map_tips(self):
        ''' Create MapTips on the map '''
        
        self.timerMapTips = QTimer(self.canvas)
        self.mapTip_connec = QgsMapTip()
        self.mapTip_node = QgsMapTip()
        self.canvas.connect(self.canvas, SIGNAL( "xyCoordinates(const QgsPoint&)" ), self.map_tip_changed)
        self.canvas.connect(self.timerMapTips, SIGNAL( "timeout()" ),self.show_map_tip)

            
    def map_tip_changed(self, p):
        ''' SLOT. Initialize the Timer to show MapTips on the map '''
        
        if self.canvas.underMouse(): # Only if mouse is over the map
            # Here you could check if your custom MapTips button is active or sth
            self.lastMapPosition = QgsPoint(p.x(), p.y())
            self.mapTip_connec.clear(self.canvas)
            self.mapTip_node.clear(self.canvas)
            self.timerMapTips.start(100) # time in milliseconds

            
    def show_map_tip(self):
        ''' SLOT. Show MapTips on the map '''
        
        self.timerMapTips.stop()
        layer_node = QgsMapLayerRegistry.instance().mapLayersByName("v_edit_node")[0]
        layer_connec = QgsMapLayerRegistry.instance().mapLayersByName("v_edit_connec")[0]

        if self.canvas.underMouse(): 
            # Here you could check if your custom MapTips button is active or sth
            pointQgs = self.lastMapPosition
            pointQt = self.canvas.mouseLastXY()
            self.mapTip_node.showMapTip(layer_node, pointQgs, pointQt, self.canvas)
            self.mapTip_connec.showMapTip(layer_connec, pointQgs, pointQt, self.canvas)

