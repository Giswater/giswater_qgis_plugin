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
        if dialog.parent():        
            dialog.parent().setFixedSize(320, 410)
        
        
    def init_config_form(self):
        ''' Custom form initial configuration '''
        
        btn_orientation = self.dialog.findChild(QPushButton, "btn_orientation")
        btn_orientation.clicked.connect(self.orientation)
        btn_snapping = self.dialog.findChild(QPushButton, "btn_snapping")
        btn_snapping.clicked.connect(self.snapping)
        
        # Set layers dimensions, node and connec
        self.layer_dimensions = None
        self.layer_dimensions = QgsMapLayerRegistry.instance().mapLayersByName("v_edit_dimensions")
        if self.layer_dimensions:
            self.layer_dimensions = self.layer_dimensions[0]   
         
        self.layer_node = None   
        self.layer_node = QgsMapLayerRegistry.instance().mapLayersByName("v_edit_node")
        if self.layer_node:
            self.layer_node = self.layer_node[0]      
            
        self.layer_connec = None   
        self.layer_connec = QgsMapLayerRegistry.instance().mapLayersByName("v_edit_connec")
        if self.layer_connec:
            self.layer_connec = self.layer_connec[0]               
        
        # Set snapping and map tips
        self.canvas = self.iface.mapCanvas()
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        self.snapper = QgsMapCanvasSnapper(self.canvas)
        self.create_map_tips()
        
        
    def orientation(self):
        
        # Disconnect previous snapping
        QObject.disconnect(self.emit_point, SIGNAL("canvasClicked(const QgsPoint &, Qt::MouseButton)"), self.click_button_snapping)
        QObject.connect(self.emit_point, SIGNAL("canvasClicked(const QgsPoint &, Qt::MouseButton)"), self.click_button_orientation)
        
        
    def snapping(self):
               
        # Disconnect previous snapping
        QObject.disconnect(self.emit_point, SIGNAL("canvasClicked(const QgsPoint &, Qt::MouseButton)"), self.click_button_orientation)
        
        # Track mouse movement
        QObject.connect(self.emit_point, SIGNAL("canvasClicked(const QgsPoint &, Qt::MouseButton)"), self.click_button_snapping)    
        
        
    def click_button_orientation(self, point, btn): #@UnusedVariable
    
        if not self.layer_dimensions:
            return   
             
        layer = self.layer_dimensions
        self.iface.setActiveLayer(layer)

        self.x_symbol = self.dialog.findChild(QLineEdit, "x_symbol")
        self.x_symbol.setText(str(point.x()))
        self.y_symbol = self.dialog.findChild(QLineEdit, "y_symbol")
        self.y_symbol.setText(str(point.y()))
        

    def click_button_snapping(self, point, btn):    #@UnusedVariable
                                 
        if not self.layer_dimensions:
            return   
             
        layer = self.layer_dimensions
        self.iface.setActiveLayer(layer)
        layer.startEditing()
        
        node_group = ["Junction","Valve","Reduction","Tank","Meter","Manhole","Source","Hydrant"]
        connec_group = ["Wjoin","Fountain"]
        
        snapper = QgsMapCanvasSnapper(self.canvas)
        map_point = self.canvas.getCoordinateTransform().transform(point)
        x = map_point.x()
        y = map_point.y()
        event_point = QPoint(x, y)
                     
        # Snapping
        (retval, result) = snapper.snapToBackgroundLayers(event_point)  # @UnusedVariable
            
        # That's the snapped point
        if result <> []:

            # Check feature
            for snap_point in result:
                
                element_type = snap_point.layer.name()
                if element_type in node_group:
                    feat_type = 'node'
                elif element_type in connec_group:
                    feat_type = 'connec'
                else:
                    continue
                        
                # Get the point
                point = QgsPoint(snap_point.snappedVertex)   
                snapp_feature = next(snap_point.layer.getFeatures(QgsFeatureRequest().setFilterFid(snap_point.snappedAtGeometry)))
                feature = snapp_feature
                element_id = feature.attribute(feat_type+'_id')
 
                # LEAVE SELECTION
                snap_point.layer.select([snap_point.snappedAtGeometry])
           
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
        
        self.timer_map_tips = QTimer(self.canvas)
        self.map_tip_node = QgsMapTip()
        self.map_tip_connec = QgsMapTip()
        self.canvas.connect(self.canvas, SIGNAL("xyCoordinates(const QgsPoint&)"), self.map_tip_changed)
        self.canvas.connect(self.timer_map_tips, SIGNAL("timeout()"), self.show_map_tip)
        
        self.timer_map_tips_clear = QTimer(self.canvas)        
        self.canvas.connect(self.timer_map_tips_clear, SIGNAL("timeout()"), self.clear_map_tip)

            
    def map_tip_changed(self, p):
        ''' SLOT. Initialize the Timer to show MapTips on the map '''
        
        if self.canvas.underMouse(): 
            self.last_map_position = QgsPoint(p.x(), p.y())
            self.map_tip_node.clear(self.canvas)
            self.map_tip_connec.clear(self.canvas)
            self.timer_map_tips.start(100)

            
    def show_map_tip(self):
        ''' SLOT. Show MapTips on the map '''
        
        self.timer_map_tips.stop()
        if self.canvas.underMouse(): 
            point_qgs = self.last_map_position
            point_qt = self.canvas.mouseLastXY()
            if self.layer_node:
                self.map_tip_node.showMapTip(self.layer_node, point_qgs, point_qt, self.canvas)
            if self.layer_connec:
                self.map_tip_connec.showMapTip(self.layer_connec, point_qgs, point_qt, self.canvas)
            self.timer_map_tips_clear.start(2000)               
                                            
            
    def clear_map_tip(self):
        ''' SLOT. Show MapTips on the map '''
        self.timer_map_tips_clear.stop()
        self.map_tip_node.clear(self.canvas)         
        self.map_tip_connec.clear(self.canvas)    
            
