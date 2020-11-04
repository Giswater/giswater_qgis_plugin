"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from qgis.PyQt.QtCore import Qt, QDate

from ..parent_maptool import GwParentMapTool
from ...ui.ui_manager import ArcFusionUi
from ...utils import tools_gw
from ....lib import tools_qt


class GwArcFusionButton(GwParentMapTool):
    """ Button 17: User select one node. Execute SQL function: 'gw_fct_delete_node' """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        """ Class constructor """
        super().__init__(icon_path, action_name, text, toolbar, action_group)


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
        snapped_feat = None
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if result.isValid():
            snapped_feat = self.snapper_manager.get_snapped_feature(result)

        if snapped_feat:
            self.node_id = snapped_feat.attribute('node_id')
            self.dlg_fusion = ArcFusionUi()
            tools_gw.load_settings(self.dlg_fusion)

            # Fill ComboBox workcat_id_end
            sql = "SELECT id FROM cat_work ORDER BY id"
            rows = self.controller.get_rows(sql)
            tools_qt.fillComboBox(self.dlg_fusion, "workcat_id_end", rows, False)

            # Set QDateEdit to current date
            current_date = QDate.currentDate()
            tools_qt.setCalendarDate(self.dlg_fusion, "enddate", current_date)

            # Set signals
            self.dlg_fusion.btn_accept.clicked.connect(self.exec_fusion)
            self.dlg_fusion.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_fusion))

            tools_gw.open_dialog(self.dlg_fusion, dlg_name='arc_fusion')


    def exec_fusion(self):

        workcat_id_end = self.dlg_fusion.workcat_id_end.currentText()
        enddate = self.dlg_fusion.enddate.date()
        enddate_str = enddate.toString('yyyy-MM-dd')
        feature_id = f'"id":["{self.node_id}"]'
        extras = f'"workcat_id_end":"{workcat_id_end}", "enddate":"{enddate_str}"'
        body = tools_gw.create_body(feature=feature_id, extras=extras)
        # Execute SQL function and show result to the user
        result = self.controller.get_json('gw_fct_setarcfusion', body)
        if not result or result['status'] == 'Failed':
            return

        text_result, change_tab = tools_gw.populate_info_text(self.dlg_fusion, result['body']['data'], True, True, 1)

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
        self.previous_snapping = self.snapper_manager.get_snapping_options()

        # Clear snapping
        self.snapper_manager.enable_snapping()

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

