"""
/***************************************************************************
        begin                : 2016-01-05
        copyright            : (C) 2016 by BGEO SL
        email                : vicente.medina@gits.ws
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
from qgis.PyQt.QtWidgets import QAction
from qgis.PyQt.QtGui import QCursor
from qgis.PyQt.QtCore import Qt

from .parent import ParentMapTool
from ..actions.manage_visit import ManageVisit


class OpenVisit(ParentMapTool):
    """ Button 17: User select one node. Execute SQL function: 'gw_fct_delete_node' """

    def __init__(self, iface, settings, action, index_action):
        """ Class constructor """

        # Call ParentMapTool constructor
        super(OpenVisit, self).__init__(iface, settings, action, index_action)
        self.controller = None
        self.current_layer = None


    """ QgsMapTools inherited event functions """

    def keyPressEvent(self, event):
        if event.key() == Qt.Key_Escape:
            self.cancel_map_tool()
            return

    def canvasReleaseEvent(self, event):

        if event.button() == Qt.RightButton:
            self.cancel_map_tool()
            return

        # Get coordinates
        event_point = self.snapper_manager.get_event_point(event)

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if not self.snapper_manager.result_is_valid():
            return

        # Get snapped feature
        snapped_feat = self.snapper_manager.get_snapped_feature(result)
        if snapped_feat:
            visit_id = snapped_feat.attribute('id')
            manage_visit = ManageVisit(self.iface, self.settings, self.controller, self.plugin_dir)
            manage_visit.manage_visit(visit_id=visit_id, tag='info')


    def activate(self):

        # Get current layer
        self.current_layer = self.iface.activeLayer()

        # Check button
        self.action().setChecked(True)

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Clear snapping
        self.snapper_manager.enable_snapping()

        # Set active layer to 'v_edit_om_visit'
        self.layer_visit = self.controller.get_layer_by_tablename("v_edit_om_visit")
        if self.layer_visit is None:
            message = "Layer not found"
            self.controller.show_message(message, message_level=2, parameter='v_edit_om_visit')
            self.cancel_map_tool()
            return
        self.iface.setActiveLayer(self.layer_visit)

        # Change cursor

        self.canvas.setCursor(QCursor(Qt.WhatsThisCursor))

        # Show help message when action is activated
        if self.show_help:
            message = "Select visit to open"
            self.controller.show_info(message)


    def deactivate(self):

        # Call parent method
        ParentMapTool.deactivate(self)
        if self.current_layer is not None:
            self.iface.setActiveLayer(self.current_layer)

        action = self.iface.mainWindow().findChild(QAction, 'map_tool_open_visit')
        action.setChecked(False)
