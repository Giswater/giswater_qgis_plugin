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
from qgis.gui import QgsVertexMarker, QgsMapToolEmitPoint

from qgis.PyQt.QtCore import QPoint, Qt

from qgis.PyQt.QtWidgets import QApplication


from functools import partial

from map_tools.parent import ParentMapTool
from giswater.actions.api_cf import ApiCF
from giswater.actions.api_parent import ApiParent


class CadApiInfo(ParentMapTool):
    """ Button 71: Add circle """

    def __init__(self, iface, settings, action, index_action, controller, plugin_dir):
        """ Class constructor """
        # Call ParentMapTool constructor
        super(CadApiInfo, self).__init__(iface, settings, action, index_action)
        self.controller = controller
        self.plugin_dir = plugin_dir



    """ QgsMapTools inherited event functions """

    def keyPressEvent(self, event):
        self.controller.log_info(str(event.key()))
        if event.key() == Qt.Key_Escape:
            self.controller.log_info("keyPressEvent")
            self.cancel_map_tool()
            self.deactivate()

            return

    def canvasMoveEvent(self, event):

        pass

    def canvasReleaseEvent(self, event):
        self.controller.log_info("CANVASRELEASE")
        self.controller.log_info(str(event.button()))
        if event.button() == Qt.LeftButton or event.button() == Qt.RightButton:
            self.controller.log_info("LeftButton")
            # Get the click
            x = event.pos().x()
            y = event.pos().y()
            try:
                point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(), x, y)
            except(TypeError, KeyError):
                self.iface.actionPan().trigger()
                return
            self.info_cf = ApiCF(self.iface, self.settings, self.controller, self.controller.plugin_dir)
            self.info_cf.get_point(point, event.button(), 'data')

        else:
            self.controller.log_info("cacacaca")

    def activate(self):
        self.std_cursor = self.parent().cursor()
        self.action().setChecked(True)
        self.canvas = self.iface.mapCanvas()
        QApplication.setOverrideCursor(Qt.WhatsThisCursor)



    def deactivate(self):

        # Call parent method
        self.action().setChecked(False)

        self.canvas.setCursor(self.std_cursor)
        self.cancel_map_tool()
        ParentMapTool.deactivate(self)

