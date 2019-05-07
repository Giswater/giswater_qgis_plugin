"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except ImportError:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT < 29900:
    from qgis.core import QgsPoint
else:
    from qgis.core import QgsPointXY

from qgis.core import QgsPointLocator, QgsMapToPixel
from qgis.gui import QgsVertexMarker, QgsMapToolEmitPoint, QgsMapTool

from qgis.PyQt.QtCore import QPoint, Qt, pyqtSignal
from qgis.PyQt.QtGui import QCursor
from qgis.PyQt.QtWidgets import QApplication


from functools import partial

from map_tools.parent import ParentMapTool
from giswater.actions.api_cf import ApiCF
from giswater.actions.api_parent import ApiParent


class CadApiInfo(QgsMapTool):
    """ Button 37: Info """

    def __init__(self, iface, settings, action, index_action, controller, plugin_dir):
        """ Class constructor """
        # Call ParentMapTool constructor
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        QgsMapTool.__init__(self, self.canvas)
        self.settings = settings
        self.action = action
        self.index_action = index_action
        self.controller = controller
        self.plugin_dir = plugin_dir
        self.is_active = None



    """ QgsMapTools inherited event functions """

    def keyPressEvent(self, event):
        self.controller.log_info(str(event.key()))
        if event.key() == Qt.Key_Escape:
            self.controller.log_info("keyPressEvent")
            self.deactivate()

    def canvasMoveEvent(self, event):
        pass

    def canvasReleaseEvent(self, event):
        complet_result = None
        self.controller.log_info("CANVASRELEASE")
        self.controller.log_info(str(event.button()))
        if event.button() == Qt.LeftButton and self.is_active:
            self.controller.log_info("LeftButton")
            point = self.create_point(event)
            if point is False:
                return
            complet_result = self.info_cf.open_form(point, tab_type='data')

        if not complet_result is None:
                print("FAIL get_point")
                return
        elif event.button() == Qt.RightButton and self.is_active:
            point = self.create_point(event)
            if point is False:
                return
            self.info_cf.hilight_feature(point, tab_type='data')
        else:
            self.controller.log_info("cacacaca")


    def create_point(self, event):
        x = event.pos().x()
        y = event.pos().y()
        try:
            point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(), x, y)
        except(TypeError, KeyError):
            self.iface.actionPan().trigger()
            return False
        return point

    def activate(self):
        self.is_active = True
        self.std_cursor = self.parent().cursor()
        self.action.setChecked(True)
        self.canvas = self.iface.mapCanvas()

        # Change map tool cursor
        self.cursor = QCursor()
        self.cursor.setShape(Qt.WhatsThisCursor)
        self.canvas.setCursor(self.cursor)
        self.info_cf = ApiCF(self.iface, self.settings, self.controller, self.controller.plugin_dir)


    def deactivate(self):
        self.is_active = False
        # Call parent method
        self.action.setChecked(False)
        self.canvas.setCursor(self.std_cursor)
        QgsMapTool.deactivate(self)
        self.deactivated.emit()

