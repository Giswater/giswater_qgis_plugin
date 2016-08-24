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
from qgis.gui import QgsMapCanvasSnapper, QgsMapTool
from PyQt4.QtCore import Qt
from PyQt4.QtGui import QCursor

from snapping_utils import SnappingConfigManager


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
        self.schema_name = None        
        self.controller = None        
        self.dao = None 
        
        # Call superclass constructor and set current action        
        QgsMapTool.__init__(self, self.canvas)
        self.setAction(action)

        # Snapper
        self.snapperManager = SnappingConfigManager(self.iface)
        self.snapper = QgsMapCanvasSnapper(self.canvas)
        
        # Change map tool cursor
        self.cursor = QCursor()
        self.cursor.setShape(Qt.CrossCursor)

        # Get default cursor
        self.stdCursor = self.parent().cursor()        


    def set_layers(self, layer_arc, layer_connec, layer_node):
        ''' Sets layers involved in Map Tools functions
            Sets Snapper Manager '''
        self.layer_arc = layer_arc
        self.layer_connec = layer_connec
        self.layer_node = layer_node
        self.snapperManager.set_layers(layer_arc, layer_connec, layer_node)

    def set_schema_name(self, schema_name):
        self.schema_name = schema_name

    def set_controller(self, controller):
        self.controller = controller

    def set_dao(self, dao):
        self.dao = dao

