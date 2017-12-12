"""
/***************************************************************************
        begin                : 2016-08-24
        copyright            : (C) 2016 by BGEO SL
        email                : derill@bgeo.es
        git sha              : $Format:%H$
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

"""

# -*- coding: utf-8 -*-
from qgis.core import QGis, QgsPoint, QgsExpression
from qgis.gui import QgsMapCanvasSnapper, QgsMapTool, QgsVertexMarker, QgsRubberBand
from PyQt4.QtCore import Qt, QPoint
from PyQt4.QtGui import QCursor, QColor, QIcon

from snapping_utils import SnappingConfigManager

import os
import sys


class ParentMapTool(QgsMapTool):


    def __init__(self, iface, settings, action, index_action):  
        """ Class constructor """

        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.settings = settings
        self.show_help = bool(int(self.settings.value('status/show_help', 1)))
        self.index_action = index_action
        self.layer_arc = None        
        self.layer_connec = None        
        self.layer_node = None   
        
        self.layer_arc_man = None        
        self.layer_connec_man = None        
        self.layer_node_man = None
        self.layer_gully_man = None 
            
        self.schema_name = None        
        self.controller = None        
        self.dao = None 
        
        # Call superclass constructor and set current action        
        QgsMapTool.__init__(self, self.canvas)
        self.setAction(action)

        # Snapper
        self.snapper_manager = SnappingConfigManager(self.iface)
        self.snapper = QgsMapCanvasSnapper(self.canvas)
        
        # Change map tool cursor
        self.cursor = QCursor()
        self.cursor.setShape(Qt.CrossCursor)

        # Get default cursor
        self.std_cursor = self.parent().cursor()    
        
        # Set default vertex marker
        color = QColor(255, 100, 255)
        self.vertex_marker = QgsVertexMarker(self.canvas)
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CIRCLE)
        self.vertex_marker.setColor(color)
        self.vertex_marker.setIconSize(15)
        self.vertex_marker.setPenWidth(3)  
                 
        # Set default rubber band
        self.rubber_band = QgsRubberBand(self.canvas, QGis.Line)
        self.rubber_band.setColor(color)
        self.rubber_band.setWidth(1)           
        self.reset()
        
        self.force_active_layer = True
        
        # Set default encoding 
        reload(sys)
        sys.setdefaultencoding('utf-8')   #@UndefinedVariable    
        

    def set_layers(self, layer_arc_man, layer_connec_man, layer_node_man, layer_gully_man=None):
        """ Sets layers involved in Map Tools functions
            Sets Snapper Manager """
        self.layer_arc_man = layer_arc_man
        self.layer_connec_man = layer_connec_man
        self.layer_node_man = layer_node_man
        self.layer_gully_man = layer_gully_man
        self.snapper_manager.set_layers(layer_arc_man, layer_connec_man, layer_node_man, layer_gully_man)


    def set_controller(self, controller):
        self.controller = controller
        self.schema_name = controller.schema_name
        self.plugin_dir = self.controller.plugin_dir 
        self.snapper_manager.controller = controller
        
        
    def deactivate(self):
        
        # Uncheck button
        self.action().setChecked(False)

        # Restore previous snapping
        self.snapper_manager.recover_snapping_options()

        # Recover cursor
        self.canvas.setCursor(self.std_cursor)

        # Removehighlight
        self.vertex_marker.hide()        
        self.vertex_marker = None


    def set_icon(self, widget, icon):
        """ Set @icon to selected @widget """

        # Get icons folder
        icons_folder = os.path.join(self.plugin_dir, 'icons')           
        icon_path = os.path.join(icons_folder, str(icon) + ".png")           
        if os.path.exists(icon_path):
            widget.setIcon(QIcon(icon_path))
        else:
            self.controller.log_info("File not found", parameter=icon_path)
            
    
    def set_action_pan(self):
        """ Set action 'Pan' """  
        try:
            self.iface.actionPan().trigger()     
        except Exception:          
            pass  


    def reset(self):
                
        # Graphic elements
        self.rubber_band.reset()

        # Selection
        self.snapped_feat = None      


    def remove_markers(self):
        """ Remove previous markers """
             
        vertex_items = [i for i in self.canvas.scene().items() if issubclass(type(i), QgsVertexMarker)]
        for ver in vertex_items:
            if ver in self.canvas.scene().items():
                self.canvas.scene().removeItem(ver)
        

    def refresh_map_canvas(self):
        """ Refresh all layers present in map canvas """
        
        self.canvas.refreshAllLayers()
        for layer_refresh in self.canvas.layers():
            layer_refresh.triggerRepaint()     
            

    def close_dialog(self, dlg=None): 
        """ Close dialog """
        
        if dlg is None or type(dlg) is bool:
            dlg = self.dlg
        try:
            self.save_settings(dlg)
            dlg.close()
            map_tool = self.canvas.mapTool()
            # If selected map tool is from the plugin, set 'Pan' as current one 
            if map_tool.toolName() == '':
                self.set_action_pan()
        except AttributeError:
            pass
        

    def load_settings(self, dialog=None):
        """ Load QGIS settings related with dialog position and size """
                     
        if dialog is None:
            dialog = self.dlg
              
        try:      
            width = self.controller.plugin_settings_value(dialog.objectName() + "_width", dialog.width())
            height = self.controller.plugin_settings_value(dialog.objectName() + "_height", dialog.height())
            x = self.controller.plugin_settings_value(dialog.objectName() + "_x")
            y = self.controller.plugin_settings_value(dialog.objectName() + "_y")          
            if x < 0 or y < 0:
                dialog.resize(width, height)
            else:
                dialog.setGeometry(int(x), int(y), int(width), int(height))
        except:
            pass                        
            
            
    def save_settings(self, dialog=None):
        """ Save QGIS settings related with dialog position and size """   
                   
        if dialog is None:
            dialog = self.dlg
            
        try:             
            self.controller.plugin_settings_set_value(dialog.objectName() + "_width", dialog.width())
            self.controller.plugin_settings_set_value(dialog.objectName() + "_height", dialog.height())
            self.controller.plugin_settings_set_value(dialog.objectName() + "_x", dialog.pos().x())
            self.controller.plugin_settings_set_value(dialog.objectName() + "_y", dialog.pos().y())  
        except:
            pass                      
            
        
    def check_expression(self, expr_filter, log_info=False):
        """ Check if expression filter @expr is valid """
        
        if log_info:
            self.controller.log_info(expr_filter)
        expr = QgsExpression(expr_filter)
        if expr.hasParserError():
            message = "Expression Error"
            self.controller.log_warning(message, parameter=expr_filter)      
            return (False, expr)
        return (True, expr)
    
        
    def canvasMoveEvent(self, event):
        
        # Make sure active layer is always 'v_edit_node'
        cur_layer = self.iface.activeLayer()
        if cur_layer != self.layer_node and self.force_active_layer:
            self.iface.setActiveLayer(self.layer_node) 
          
        # Hide highlight
        self.vertex_marker.hide()
  
        try:
            # Get current mouse coordinates
            x = event.pos().x()
            y = event.pos().y()
            event_point = QPoint(x, y)
        except(TypeError, KeyError):
            self.iface.actionPan().trigger()
            return

        # Snapping
        (retval, result) = self.snapper.snapToCurrentLayer(event_point, 2)  # @UnusedVariable
  
        # That's the snapped features
        if result:          
            # Get the point and add marker on it
            point = QgsPoint(result[0].snappedVertex)
            self.vertex_marker.setCenter(point)
            self.vertex_marker.show()           
                             
