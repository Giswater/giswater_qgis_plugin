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


class CadApiInfo(ParentMapTool):
    """ Button 37: Info """

    def __init__(self, iface, settings, action, index_action):
        """ Class constructor """
        # Call ParentMapTool constructor
        super(CadApiInfo, self).__init__(iface, settings, action, index_action)
        self.index_action = index_action
        self.tab_type = None

    def create_point(self, event):
        x = event.pos().x()
        y = event.pos().y()
        try:
            point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(), x, y)
        except(TypeError, KeyError):
            self.iface.actionPan().trigger()
            return False
        return point


    """ QgsMapTools inherited event functions """

    def keyPressEvent(self, event):
        if event.key() == Qt.Key_Escape:
            for rb in self.rubberband_list:
                rb.reset()
            self.info_cf.resetRubberbands()
            self.action().trigger()
            return



    def canvasMoveEvent(self, event):
        pass



    def canvasReleaseEvent(self, event):
        for rb in self.rubberband_list:
            rb.reset()
        complet_result = None
        if event.button() == Qt.LeftButton:
            point = self.create_point(event)
            if point is False:
                return
            complet_result, dialog = self.info_cf.open_form(point, tab_type=self.tab_type)
        if complet_result is False:
                print("No point under mouse(LeftButton)")
                return
        elif event.button() == Qt.RightButton:
            point = self.create_point(event)
            if point is False:
                print("No point under mouse(RightButton)")
                return

            self.info_cf.hilight_feature(point, rb_list=self.rubberband_list, tab_type=self.tab_type)


    def activate(self):
        # Check button
        self.action().setChecked(True)
        print(self.index_action)
        # Change map tool cursor
        self.cursor = QCursor()
        self.cursor.setShape(Qt.WhatsThisCursor)
        self.canvas.setCursor(self.cursor)
        self.rubberband_list = []
        if self.index_action == '37':
            self.tab_type = 'data'
        elif self.index_action == '199':
            self.tab_type = 'inp'

        self.info_cf = ApiCF(self.iface, self.settings, self.controller, self.controller.plugin_dir, self.tab_type)



    def deactivate(self):
        for rb in self.rubberband_list:
            rb.reset()
        self.info_cf.resetRubberbands()
        ParentMapTool.deactivate(self)



