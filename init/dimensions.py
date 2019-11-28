"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-

from qgis.core import QgsPointXY
from ..map_tools.snapping_utils_v3 import SnappingConfigManager

from qgis.PyQt.QtWidgets import QPushButton, QLineEdit
from qgis.PyQt.QtCore import QTimer
from qgis.gui import QgsMapToolEmitPoint, QgsMapTip

from .. import utils_giswater
from ..parent_init import ParentDialog


def formOpen(dialog, layer, feature):
    """ Function called when a connec is identified in the map """
    
    global feature_dialog
    # Create class to manage Feature Form interaction
    feature_dialog = Dimensions(dialog, layer, feature)
    init_config()
    

def init_config():
    pass
     
     
class Dimensions(ParentDialog):
    
    def __init__(self, dialog, layer, feature):
        """ Constructor class """
        
        self.id = None        
        super(Dimensions, self).__init__(dialog, layer, feature)      
        self.init_config_form()
        if dialog.parent():        
            dialog.parent().setFixedSize(320, 410)
        
        
    def init_config_form(self):
        """ Custom form initial configuration """

        self.canvas = self.iface.mapCanvas()
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)

        # Snapper
        self.snapper_manager = SnappingConfigManager(self.iface)
        self.snapper = self.snapper_manager.get_snapper()

        # Configure button signals
        btn_orientation = self.dialog.findChild(QPushButton, "btn_orientation")
        btn_orientation.clicked.connect(self.orientation)
        self.set_icon(btn_orientation, "133")
        btn_snapping = self.dialog.findChild(QPushButton, "btn_snapping")
        btn_snapping.clicked.connect(self.snapping)
        self.set_icon(btn_snapping, "129")
        
        # Set layers dimensions, node and connec
        self.layer_dimensions = self.controller.get_layer_by_tablename("v_edit_dimensions")
        self.layer_node = self.controller.get_layer_by_tablename("v_edit_node")
        self.layer_connec = self.controller.get_layer_by_tablename("v_edit_connec")

        self.create_map_tips()
        
        
    def orientation(self):
        
        self.emit_point.canvasClicked.connect(self.click_button_orientation)


    def snapping(self):  
                   
        # Set active layer and set signals
        self.iface.setActiveLayer(self.layer_node)
        self.canvas.xyCoordinates.connect(self.mouse_move)
        self.emit_point.canvasClicked.connect(self.click_button_snapping)


    def mouse_move(self, point):

        # Hide marker and get coordinates
        self.snapper_manager.remove_marker()
        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_background_layers(event_point)
        if self.snapper_manager.result_is_valid():
            layer = self.snapper_manager.get_snapped_layer(result)
            # Check feature
            if layer == self.layer_node or layer == self.layer_connec:
                self.snapper_manager.add_marker(result)

        
    def click_button_orientation(self, point):  # @UnusedVariable

        if not self.layer_dimensions:
            return   

        self.x_symbol = self.dialog.findChild(QLineEdit, "x_symbol")
        self.x_symbol.setText(str(int(point.x())))
        self.y_symbol = self.dialog.findChild(QLineEdit, "y_symbol")
        self.y_symbol.setText(str(int(point.y())))
        

    def click_button_snapping(self, point, btn):  # @UnusedVariable

        if not self.layer_dimensions:
            return   
             
        layer = self.layer_dimensions
        self.iface.setActiveLayer(layer)
        layer.startEditing()

        # Get coordinates
        event_point = self.snapper_manager.get_event_point(point=point)
                     
        # Snapping
        result = self.snapper_manager.snap_to_background_layers(event_point)
        if self.snapper_manager.result_is_valid():

            layer = self.snapper_manager.get_snapped_layer(result)
            # Check feature
            if layer == self.layer_node:
                feat_type = 'node'
            elif layer == self.layer_connec:
                feat_type = 'connec'
            else:
                return

            # Get the point
            snapped_feat = self.snapper_manager.get_snapped_feature(result)
            feature_id = self.snapper_manager.get_snapped_feature_id(result)
            element_id = snapped_feat.attribute(feat_type + '_id')

            # Leave selection
            layer.select([feature_id])

            # Get depth of the feature
            if self.project_type == 'ws':
                fieldname = "depth"
            elif self.project_type == 'ud' and feat_type == 'node':
                fieldname = "ymax"
            elif self.project_type == 'ud' and feat_type == 'connec':
                fieldname = "connec_depth"

            sql = ("SELECT " + fieldname + " "
                   "FROM " + feat_type + " "
                   "WHERE " + feat_type + "_id = '" + element_id + "'")
            row = self.controller.get_row(sql)
            if not row:
                return

            utils_giswater.setText(self.dialog, "depth", row[0])
            utils_giswater.setText(self.dialog, "feature_id", element_id)
            utils_giswater.setText(self.dialog, "feature_type", feat_type.upper())

    
    def create_map_tips(self):
        """ Create MapTips on the map """

        row = self.controller.get_config('dim_tooltip')
        if row and row[0].lower() != 'true':
            return

        self.timer_map_tips = QTimer(self.canvas)
        self.map_tip_node = QgsMapTip()
        self.map_tip_connec = QgsMapTip()

        self.canvas.xyCoordinates.connect(self.map_tip_changed)
        self.timer_map_tips.timeout.connect(self.show_map_tip)
        self.timer_map_tips_clear = QTimer(self.canvas)
        self.timer_map_tips_clear.timeout.connect(self.clear_map_tip)


    def map_tip_changed(self, point):
        """ SLOT. Initialize the Timer to show MapTips on the map """
        
        if self.canvas.underMouse(): 
            self.last_map_position = QgsPointXY(point.x(), point.y())
            self.map_tip_node.clear(self.canvas)
            self.map_tip_connec.clear(self.canvas)
            self.timer_map_tips.start(100)

            
    def show_map_tip(self):
        """ Show MapTips on the map """
        
        self.timer_map_tips.stop()
        if self.canvas.underMouse(): 
            point_qgs = self.last_map_position
            point_qt = self.canvas.mouseLastXY()
            if self.layer_node:
                self.map_tip_node.showMapTip(self.layer_node, point_qgs, point_qt, self.canvas)
            if self.layer_connec:
                self.map_tip_connec.showMapTip(self.layer_connec, point_qgs, point_qt, self.canvas)
            self.timer_map_tips_clear.start(1000)
                                            
            
    def clear_map_tip(self):
        """ Clear MapTips """
        
        self.timer_map_tips_clear.stop()
        self.map_tip_node.clear(self.canvas)         
        self.map_tip_connec.clear(self.canvas)    
            
        
    def reject_dialog(self):
        """ Reject dialog without saving """ 
        
        self.set_action_identify()
        try: 
            self.canvas.xyCoordinates.disconnect()                                            
            self.canvas.timeout.disconnect()           
        except Exception:
            pass            
                 
                 
    def save(self):
        """ Save feature """
        
        # General save
        self.dialog.save()     
        self.iface.actionSaveEdits().trigger()    
        self.reject_dialog()                                  
            
