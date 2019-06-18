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
from __future__ import absolute_import

# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except ImportError:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT < 29900:
    from qgis.core import QgsMapLayerRegistry as QgsProject
    from giswater.map_tools.snapping_utils_v2 import SnappingConfigManager
else:
    from qgis.core import QgsWkbTypes, QgsProject
    from giswater.map_tools.snapping_utils_v3 import SnappingConfigManager

from qgis.core import QgsExpression
from qgis.gui import QgsMapTool, QgsVertexMarker, QgsRubberBand
from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtGui import QCursor, QColor, QIcon, QPixmap

import os
import sys
if 'nt' in sys.builtin_module_names:
    import ctypes


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
        self.snapper = self.snapper_manager.get_snapper()
        
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
        color_selection = QColor(254, 178, 76, 63)
        if Qgis.QGIS_VERSION_INT < 29900:
            self.rubber_band = QgsRubberBand(self.canvas, Qgis.Polygon)
        else:
            self.rubber_band = QgsRubberBand(self.canvas, QgsWkbTypes.PolygonGeometry)
        self.rubber_band.setColor(color)
        self.rubber_band.setFillColor(color_selection)           
        self.rubber_band.setWidth(1)           
        self.reset()
        
        self.force_active_layer = True
        
        # Set default encoding
        if Qgis.QGIS_VERSION_INT < 29900:
            reload(sys)
            sys.setdefaultencoding('utf-8')   #@UndefinedVariable
        
        
    def get_cursor_multiple_selection(self):
        """ Set cursor for multiple selection """
        
        path_folder = os.path.join(os.path.dirname(__file__), os.pardir) 
        path_cursor = os.path.join(path_folder, 'icons', '201.png')                
        if os.path.exists(path_cursor):      
            cursor = QCursor(QPixmap(path_cursor))    
        else:        
            cursor = QCursor(Qt.ArrowCursor)  
                
        return cursor
     

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

        # Remove highlight
        self.vertex_marker.hide()        


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


    def reset_rubber_band(self):

        try:
            # Graphic elements
            if Qgis.QGIS_VERSION_INT < 29900:
                self.rubber_band.reset(Qgis.Polygon)
            else:
                self.rubber_band.reset(QgsWkbTypes.PolygonGeometry)
        except:
            pass


    def reset(self):

        self.reset_rubber_band()
        self.snapped_feat = None      
        
    
    def cancel_map_tool(self):
        """ Executed if user press right button or escape key """
        
        # Reset rubber band
        self.reset()

        # Deactivate map tool
        self.deactivate()
        self.set_action_pan()
                        

    def remove_markers(self):
        """ Remove previous markers """
             
        vertex_items = [i for i in list(self.canvas.scene().items()) if issubclass(type(i), QgsVertexMarker)]
        for ver in vertex_items:
            if ver in list(self.canvas.scene().items()):
                self.canvas.scene().removeItem(ver)
        

    def refresh_map_canvas(self):
        """ Refresh all layers present in map canvas """
        
        self.canvas.refreshAllLayers()
        for layer_refresh in self.canvas.layers():
            layer_refresh.triggerRepaint()     
           
           
    def open_dialog(self, dlg=None, dlg_name=None, maximize_button=True, stay_on_top=True): 
        """ Open dialog """

        if dlg is None or type(dlg) is bool:
            dlg = self.dlg
            
        # Manage i18n of the dialog                  
        if dlg_name:      
            self.controller.manage_translation(dlg_name, dlg)      
            
        # Manage stay on top and maximize button
        if maximize_button and stay_on_top:           
            dlg.setWindowFlags(Qt.WindowMinimizeButtonHint | Qt.WindowMaximizeButtonHint | Qt.WindowStaysOnTopHint)       
        elif not maximize_button and stay_on_top:
            dlg.setWindowFlags(Qt.WindowMinimizeButtonHint | Qt.WindowStaysOnTopHint) 
        elif maximize_button and not stay_on_top:
            dlg.setWindowFlags(Qt.WindowMaximizeButtonHint)              

        # Open dialog
        dlg.open()    
                    

    def close_dialog(self, dlg=None, set_action_pan=True): 
        """ Close dialog """
        
        if dlg is None or type(dlg) is bool:
            dlg = self.dlg
        try:
            self.save_settings(dlg)
            dlg.close()
            if set_action_pan:
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
            x = self.controller.plugin_settings_value(dialog.objectName() + "_x")
            y = self.controller.plugin_settings_value(dialog.objectName() + "_y")
            width = self.controller.plugin_settings_value(dialog.objectName() + "_width", dialog.property('width'))
            height = self.controller.plugin_settings_value(dialog.objectName() + "_height", dialog.property('height'))

            if int(x) < 0 or int(y) < 0:
                dialog.resize(int(width), int(height))
            else:
                screens = ctypes.windll.user32
                screen_x = screens.GetSystemMetrics(78)
                screen_y = screens.GetSystemMetrics(79)
                if int(x) > screen_x:
                    x = int(screen_x) - int(width)
                if int(y) > screen_y:
                    y = int(screen_y)
                dialog.setGeometry(int(x), int(y), int(width), int(height))
        except:
            pass
            
            
    def save_settings(self, dialog=None):
        """ Save QGIS settings related with dialog position and size """   
                   
        if dialog is None:
            dialog = self.dlg
            
        try:             
            self.controller.plugin_settings_set_value(dialog.objectName() + "_width", dialog.property('width'))
            self.controller.plugin_settings_set_value(dialog.objectName() + "_height", dialog.property('height'))
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
            return False, expr

        return True, expr


    def get_composers_list(self):

        if Qgis.QGIS_VERSION_INT < 29900:
            active_composers = self.iface.activeComposers()
        else:
            layour_manager = QgsProject.instance().layoutManager().layouts()
            active_composers = [layout for layout in layour_manager]

        return active_composers


    def get_composer_name(self, composer):

        if Qgis.QGIS_VERSION_INT < 29900:
            composer_name = composer.composerWindow().windowTitle()
        else:
            composer_name = composer.name()

        return composer_name


    def get_composer_index(self, name):

        index = 0
        composers = self.get_composers_list()
        for comp_view in composers:
            composer_name = self.get_composer_name(comp_view)
            if composer_name == name:
                break
            index += 1

        return index

        
    def canvasMoveEvent(self, event):
        
        # Make sure active layer is always 'v_edit_node'
        cur_layer = self.iface.activeLayer()
        if cur_layer != self.layer_node and self.force_active_layer:
            self.iface.setActiveLayer(self.layer_node) 
          
        # Hide highlight and get coordinates
        self.vertex_marker.hide()
        event_point = self.snapper_manager.get_event_point(event)

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if result:
            # Check snapped features
            for snapped_point in result:
                self.snapper_manager.add_marker(snapped_point, self.vertext_marker)
                break

