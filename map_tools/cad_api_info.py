"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsMapToPixel
from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtGui import QCursor
from qgis.PyQt.QtWidgets import QAction

import json
from collections import OrderedDict
from functools import partial

from .parent import ParentMapTool
from ..actions.api_cf import ApiCF
from ..ui_manager import DockerUi


class CadApiInfo(ParentMapTool):
    """ Button 37: Info """

    def __init__(self, iface, settings, action, index_action):
        """ Class constructor """

        super(CadApiInfo, self).__init__(iface, settings, action, index_action)
        self.index_action = index_action
        self.tab_type = None
        # Used when the signal 'signal_activate' is emitted from the info, do not open another form
        self.block_signal = False


    def close_docker(self):
        """ Save QDockWidget position (1=Left, 2=right, 8=bottom, 4=top),
            remove from iface and del class
        """

        if hasattr(self, 'dlg_docker') and type(self.dlg_docker) is DockerUi:
            if not self.dlg_docker.isFloating():
                cur_user = self.controller.get_current_user()
                docker_pos = self.iface.mainWindow().dockWidgetArea(self.dlg_docker)
                self.controller.plugin_settings_set_value(f"docker_info_{cur_user}", docker_pos)
                self.iface.removeDockWidget(self.dlg_docker)
                del self.dlg_docker


    def create_point(self, event):

        x = event.pos().x()
        y = event.pos().y()
        try:
            point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(), x, y)
        except(TypeError, KeyError):
            self.iface.actionPan().trigger()
            return False

        return point


    def manage_docker_options(self):
        """ Check if user want dock the dialog or not """

        # Load last docker position
        cur_user = self.controller.get_current_user()
        pos = self.controller.plugin_settings_value(f"docker_info_{cur_user}")

        # Docker positions: 1=Left, 2=Right, 4=Top, 8=Bottom
        self.dlg_docker.position = 2
        if type(pos) is int and pos in (1, 2, 4, 8):
            self.dlg_docker.position = pos

        # If user want to dock the dialog, we reset rubberbands for each info
        # For the first time, cf_info does not exist, therefore we cannot access it and reset rubberbands
        try:
            self.api_cf.resetRubberbands()
        except AttributeError as e:
            pass



    """ QgsMapTools inherited event functions """

    def keyPressEvent(self, event):

        if event.key() == Qt.Key_Escape:
            for rb in self.rubberband_list:
                rb.reset()
            self.api_cf.resetRubberbands()
            self.action().trigger()
            return


    def canvasMoveEvent(self, event):
        pass


    def canvasReleaseEvent(self, event):

        for rb in self.rubberband_list:
            rb.reset()

        if self.block_signal:
            self.block_signal = False
            return

        row = self.controller.get_config('qgis_form_docker')
        if row:
            if row[0].lower() == 'true':
                self.close_docker()
                self.dlg_docker = DockerUi()
                self.dlg_docker.dlg_closed.connect(partial(self.close_docker))
                self.manage_docker_options()
            else:
                self.dlg_docker = None
        else:
            self.dlg_docker = None

        if event.button() == Qt.LeftButton:
            point = self.create_point(event)
            if point is False:
                return
            self.api_cf.open_form(point, tab_type=self.tab_type, docker=self.dlg_docker)

        elif event.button() == Qt.RightButton:
            point = self.create_point(event)
            if point is False:
                return
            self.api_cf.hilight_feature(point, self.rubberband_list, self.tab_type, self.dlg_docker)


    def reactivate_map_tool(self):
        """ Reactivate tool """

        self.block_signal = True
        info_action = self.iface.mainWindow().findChild(QAction, 'map_tool_api_info_data')
        info_action.trigger()


    def activate(self):

        # Check button
        self.action().setChecked(True)
        # Change map tool cursor
        self.cursor = QCursor()
        self.cursor.setShape(Qt.WhatsThisCursor)
        self.canvas.setCursor(self.cursor)
        self.rubberband_list = []
        if self.index_action == '37':
            self.tab_type = 'data'
        elif self.index_action == '199':
            self.tab_type = 'inp'

        self.api_cf = ApiCF(self.iface, self.settings, self.controller, self.controller.plugin_dir, self.tab_type)
        self.api_cf.signal_activate.connect(self.reactivate_map_tool)


    def deactivate(self):

        for rb in self.rubberband_list:
            rb.reset()
        if hasattr(self, 'api_cf'):
            self.api_cf.resetRubberbands()
        ParentMapTool.deactivate(self)

