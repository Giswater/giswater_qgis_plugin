"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: latin-1 -*-
try:
    from qgis.core import Qgis
except:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT >= 20000 and Qgis.QGIS_VERSION_INT < 29900:
    from PyQt4.QtCore import Qt
    from PyQt4.QtGui import QApplication
    from PyQt4.QtGui import QAction
else:
    from qgis.PyQt.QtCore import Qt
    from qgis.PyQt.QtWidgets import QAction, QApplication

from qgis.gui import QgsMapToolEmitPoint

import json
import operator
import win32api, win32con
from functools import partial

from api_parent import ApiParent
from actions.api_cf import ApiCF


class ApiMoveNode(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class constructor """
        ApiParent.__init__(self, iface, settings, controller, plugin_dir)
        self.api_cf = ApiCF(iface, settings, controller, plugin_dir)
        self.iface = iface
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir


    def api_move_node(self):
        """ Button 37: Own Giswater info """
        self.controller.restore_info()
        # Create the appropriate map tool and connect the gotPoint() signal.
        QApplication.setOverrideCursor(Qt.CrossCursor)
        self.canvas = self.iface.mapCanvas()
        #self.canvas.connect(self.canvas, SIGNAL("xyCoordinates(const QgsPoint&)"), self.mouse_move)
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        self.emit_point.canvasClicked.connect(self.get_point)


    def mouse_move(self, p):

        map_point = self.canvas.getCoordinateTransform().transform(p)
        x = map_point.x()
        y = map_point.y()


    def click(self):
        #win32api.SetCursorPos((x, y))
        x, y = win32api.GetCursorPos()
        win32api.mouse_event(win32con.MOUSEEVENTF_LEFTDOWN, x, y, 0, 0)
        win32api.mouse_event(win32con.MOUSEEVENTF_LEFTUP, x, y, 0, 0)
        win32api.mouse_event(win32con.MOUSEEVENTF_LEFTDOWN, x, y, 0, 0)
        #self.api_cf.open_form(self, point=None, node_id=None)
        
        
    def get_point(self, point, button_clicked):

        if button_clicked == Qt.RightButton:
            self.emit_point.canvasClicked.disconnect()
            QApplication.restoreOverrideCursor()
        else:
            self.emit_point.canvasClicked.disconnect()
            self.start_tool(point)


    def start_tool(self, point=None, node_id=None):
        
        # Get srid
        self.srid = self.controller.plugin_settings_value('srid')
        if self.iface.activeLayer() is None:
            active_layer = ""
        else:
            active_layer = self.controller.get_layer_source_table_name(self.iface.activeLayer())

        visible_layers = self.get_visible_layers()
        # TODO editables han de ser null
        # editable_layers = self.get_editable_layers()
        editable_layers = ''
        scale_zoom = self.iface.mapCanvas().scale()
        if point:
            sql = ("SELECT " + self.schema_name + ".gw_api_get_infofromcoordinates(" + str(point.x()) + ", "
                   + str(point.y())+" ,"+str(self.srid) + ", '"+str(active_layer)+"', '"+str(visible_layers)+"', '"
                   + str(editable_layers)+"', "+str(scale_zoom)+", 9, 100)")
        elif node_id:
            sql = ("SELECT the_geom FROM " + self.schema_name + ".ve_node WHERE node_id = '" + str(node_id) + "'")
            row = self.controller.get_row(sql, log_sql=False)
            sql = ("SELECT " + self.schema_name + ".gw_api_get_infofromid('ve_node', '"+str(node_id)+"',"
                   " '" + str(row[0])+"', True, 9, 100)")
        row = self.controller.get_row(sql, log_sql=True)
        if not row:
            self.controller.show_message("NOT ROW FOR: " + sql, 2)
            return

        # # Get table name for use as title
        # self.tablename = row[0]['tableName']
        # pos_ini = row[0]['tableName'].rfind("_")
        # pos_fi = len(str(row[0]['tableName']))
        # self.node_type = row[0]['tableName'][pos_ini+1:pos_fi]

        # Get tableParent and select layer
        self.table_parent = str(row[0]['tableParent'])
        self.layer = self.controller.get_layer_by_tablename(self.table_parent)
        self.iface.setActiveLayer(self.layer)
        # Get node_type (arc, node, connec)
        pos_ini = row[0]['tableParent'].rfind("_")
        pos_fi = len(str(row[0]['tableParent']))
        self.node_type = row[0]['tableParent'][pos_ini + 1:pos_fi]

        if not self.layer.isEditable():
            self.iface.mainWindow().findChild(QAction, 'mActionToggleEditing').trigger()
            self.iface.mainWindow().findChild(QAction, 'mActionNodeTool').trigger()
            self.click()
            # self.emit_point = QgsMapToolEmitPoint(self.canvas)
            # self.canvas.setMapTool(self.emit_point)
            # self.emit_point.canvasClicked.connect(self.button)

            self.controller.log_info(str("TEST 30"))
            
            
    def button(self, point, button_clicked):

        if button_clicked == Qt.RightButton:
            self.open_form()
            #QApplication.restoreOverrideCursor()
        else:
            self.emit_point.canvasClicked.disconnect()
            self.start_tool(point)
            
            
    def open_form(self):
        
        sql = ("SELECT parameter, value  FROM " + self.schema_name + ".config_param_user "
               " WHERE parameter  = 'open_info' AND cur_user=current_user")
        row = self.controller.get_row(sql, log_sql=True)
        self.controller.log_info(str("TEST 23"))
        self.controller.log_info(str(row))
        self.controller.log_info(str("TEST 24"))
        node_id = '1040'
        self.ApiCF = ApiCF(self.iface, self.settings, self.controller, self.plugin_dir)
        self.ApiCF.open_form(table_name=self.table_parent, node_type=self.node_type, node_id=node_id)
        
