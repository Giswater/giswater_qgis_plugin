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
from qgis.PyQt.QtCore import Qt, QDate

from lib import qt_tools
from ..parent_maptool import GwParentMapTool
from ....ui_manager import ArcFusionUi
from functools import partial
from ...utils.giswater_tools import load_settings, open_dialog, close_dialog, create_body, populate_info_text
from ....lib.qgis_tools import get_event_point, snap_to_current_layer, get_snapped_feature, get_snapping_options, \
    enable_snapping


class GwArcFusionButton(GwParentMapTool):
    """ Button 17: User select one node. Execute SQL function: 'gw_fct_delete_node' """

    def __init__(self, icon_path, text, toolbar, action_group):
        """ Class constructor """

        # Call ParentMapTool constructor
        super().__init__(icon_path, text, toolbar, action_group)



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
        event_point = get_event_point(event)

        # Snapping
        snapped_feat = None
        result = snap_to_current_layer(event_point)
        if result.isValid():
            snapped_feat = get_snapped_feature(result)

        if snapped_feat:
            self.node_id = snapped_feat.attribute('node_id')
            self.dlg_fusion = ArcFusionUi()
            load_settings(self.dlg_fusion)

            # Fill ComboBox workcat_id_end
            sql = "SELECT id FROM cat_work ORDER BY id"
            rows = self.controller.get_rows(sql)
            qt_tools.fillComboBox(self.dlg_fusion, "workcat_id_end", rows, False)

            # Set QDateEdit to current date
            current_date = QDate.currentDate()
            qt_tools.setCalendarDate(self.dlg_fusion, "enddate", current_date)

            # Set signals
            self.dlg_fusion.btn_accept.clicked.connect(self.exec_fusion)
            self.dlg_fusion.btn_cancel.clicked.connect(partial(close_dialog, self.dlg_fusion))

            open_dialog(self.dlg_fusion, dlg_name='arc_fusion')


    def exec_fusion(self):

        workcat_id_end = self.dlg_fusion.workcat_id_end.currentText()
        enddate = self.dlg_fusion.enddate.date()
        enddate_str = enddate.toString('yyyy-MM-dd')
        feature_id = f'"id":["{self.node_id}"]'
        extras = f'"workcat_id_end":"{workcat_id_end}", "enddate":"{enddate_str}"'
        body = create_body(feature=feature_id, extras=extras)
        # Execute SQL function and show result to the user
        result = self.controller.get_json('gw_fct_arc_fusion', body)
        if not result:
            return

        text_result = populate_info_text(self.dlg_fusion, result['body']['data'], True, True, 1)

        if not text_result:
            self.dlg_fusion.close()
        # Refresh map canvas
        self.refresh_map_canvas()

        # Deactivate map tool
        self.deactivate()

        self.set_action_pan()


    def activate(self):

        # Check button
        self.action.setChecked(True)

        # Store user snapping configuration
        self.previous_snapping = get_snapping_options()

        # Clear snapping
        enable_snapping()

        # Set active layer to 'v_edit_node'
        self.layer_node = self.controller.get_layer_by_tablename("v_edit_node")
        self.iface.setActiveLayer(self.layer_node)

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Select the node inside a pipe by clicking on it and it will be removed"
            self.controller.show_info(message)


    def deactivate(self):

        # Call parent method
        super().deactivate()

