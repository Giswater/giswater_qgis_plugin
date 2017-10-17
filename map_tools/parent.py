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
from PyQt4.QtGui import QIcon
from qgis.gui import QgsMapCanvasSnapper, QgsMapTool, QgsVertexMarker
from PyQt4.QtCore import Qt
from PyQt4.QtGui import QCursor, QColor

from snapping_utils import SnappingConfigManager

import os
import sys


class ParentMapTool(QgsMapTool):


    def __init__(self, iface, settings, action, index_action):  
        ''' Class constructor '''

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
        self.vertex_marker = QgsVertexMarker(self.canvas)
        self.vertex_marker.setColor(QColor(255, 25, 25))
        self.vertex_marker.setIconSize(12)
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CIRCLE)  # or ICON_CROSS, ICON_X
        self.vertex_marker.setPenWidth(5)        
        
        # Set default encoding 
        reload(sys)
        sys.setdefaultencoding('utf-8')   #@UndefinedVariable    
        

    def set_layers(self, layer_arc_man, layer_connec_man, layer_node_man, layer_gully_man=None):
        ''' Sets layers involved in Map Tools functions
            Sets Snapper Manager '''
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
        
        # Check button
        self.action().setChecked(False)

        # Restore previous snapping
        self.snapper_manager.recover_snapping_options()

        # Recover cursor
        self.canvas.setCursor(self.std_cursor)

        # Removehighlight
        self.h = None


    def set_icon(self, widget, icon):
        """ Set @icon to selected @widget """

        # Get icons folder
        icons_folder = os.path.join(self.plugin_dir, 'icons')           
        icon_path = os.path.join(icons_folder, str(icon) + ".png")           
        if os.path.exists(icon_path):
            widget.setIcon(QIcon(icon_path))
        else:
            self.controller.log_info("File not found", parameter=icon_path)
            
