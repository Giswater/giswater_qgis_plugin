"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from qgis.PyQt.QtCore import Qt, QDate

from ..maptool import GwMaptool
from ...ui.ui_manager import GwArcFusionUi
from ...utils import tools_gw
from ....lib import tools_qt, tools_db, tools_qgis, tools_os


class GwArcFusionButton(GwMaptool):
    """ Button 17: Fusion arc
    User select one node. Execute SQL function: 'gw_fct_delete_node' """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)


    # region QgsMapTools inherited
    """ QgsMapTools inherited event functions """

    def activate(self):

        # Check button
        if hasattr(self.action, "setChecked"):
            self.action.setChecked(True)

        # Store user snapping configuration
        self.previous_snapping = self.snapper_manager.get_snapping_options()

        # Clear snapping
        self.snapper_manager.set_snapping_status()

        # Set active layer to 'v_edit_node'
        self.layer_node = tools_qgis.get_layer_by_tablename("v_edit_node")
        self.iface.setActiveLayer(self.layer_node)

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Click on node, that joins two pipes, in order to remove it and merge pipes"
            tools_qgis.show_info(message)


    def canvasReleaseEvent(self, event):

        self._get_arc_fusion(event)


    # endregion


    # region private functions

    def _fusion_arc(self):

        state_type = tools_qt.get_combo_value(self.dlg_fusion, "cmb_statetype")
        action_mode = self.dlg_fusion.cmb_nodeaction.currentIndex()
        workcat_id_end = self.dlg_fusion.workcat_id_end.currentText()
        enddate = self.dlg_fusion.enddate.date()
        enddate_str = enddate.toString('yyyy-MM-dd')
        feature_id = f'"id":["{self.node_id}"]'
        extras = f'"enddate":"{enddate_str}"'
        if workcat_id_end not in (None, 'null', ''):
            extras += f', "workcat_id_end":"{workcat_id_end}"'
        if action_mode is not None:
            extras += f', "action_mode": {action_mode}'
            if action_mode == 1 and state_type is not None:
                extras += f', "state_type": {state_type}'
        body = tools_gw.create_body(feature=feature_id, extras=extras)
        # Execute SQL function and show result to the user
        result = tools_gw.execute_procedure('gw_fct_setarcfusion', body)
        if not result or result['status'] == 'Failed':
            return

        text_result = None
        log = tools_gw.get_config_parser("user_edit_tricks", "arc_fusion_disable_showlog", 'user', 'init')
        if not tools_os.set_boolean(log, False):
            text_result, change_tab = tools_gw.fill_tab_log(self.dlg_fusion, result['body']['data'], True, True, 1)

        self._save_dlg_values()

        if not text_result:
            self.dlg_fusion.close()

        self.refresh_map_canvas()

        # Check in init config file if user wants to keep map tool active or not
        self.manage_active_maptool()


    def _get_arc_fusion(self, event):

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
            self.node_state = snapped_feat.attribute('state')

            # If the node has state 0 (obsolete) don't open arc fusion dlg
            if self.node_state is not None and self.node_state == 0:
                msg = "The node is obsolete, this tool doesn't work with obsolete nodes."
                tools_qgis.show_warning(msg, title="Arc fusion")
                return

            self.dlg_fusion = GwArcFusionUi()
            tools_gw.load_settings(self.dlg_fusion)

            # Fill ComboBox cmb_nodeaction
            rows = [[0, 'KEEP OPERATIVE'], [1, 'DOWNGRADE NODE'], [2, 'REMOVE NODE']]
            tools_qt.fill_combo_values(self.dlg_fusion.cmb_nodeaction, rows, 1, sort_by=0)
            node_action = tools_gw.get_config_parser("btn_arc_fusion", "cmb_nodeaction", "user", "session")
            if node_action not in (None, 'None', ''):
                tools_qt.set_widget_text(self.dlg_fusion, "cmb_nodeaction", node_action)

            # Fill ComboBox workcat_id_end
            sql = "SELECT id FROM cat_work ORDER BY id"
            rows = tools_db.get_rows(sql)
            tools_qt.fill_combo_box(self.dlg_fusion, "workcat_id_end", rows, True)

            # Fill ComboBox cmb_statetype
            sql = "SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL AND state = 0"
            rows = tools_db.get_rows(sql)
            tools_qt.fill_combo_values(self.dlg_fusion.cmb_statetype, rows, 1, add_empty=True)
            state_type = tools_gw.get_config_parser("btn_arc_fusion", "cmb_statetype", "user", "session")
            if state_type not in (None, 'None', ''):
                tools_qt.set_widget_text(self.dlg_fusion, "cmb_statetype", state_type)

            # Set QDateEdit to current date
            current_date = QDate.currentDate()
            tools_qt.set_calendar(self.dlg_fusion, "enddate", current_date)

            # If the node has state 2 (planified) only allow remove node
            if self.node_state is not None and self.node_state == 2:
                self.dlg_fusion.cmb_nodeaction.setCurrentIndex(2)
                self.dlg_fusion.cmb_nodeaction.setEnabled(False)
                tools_qt.set_stylesheet(self.dlg_fusion.cmb_nodeaction, style="color: black")
            # Disable some widgets
            if self.dlg_fusion.cmb_nodeaction.currentIndex() != 1:
                self.dlg_fusion.enddate.setEnabled(False)
                self.dlg_fusion.workcat_id_end.setEnabled(False)
                self.dlg_fusion.cmb_statetype.setEnabled(False)

            # Disable tab log
            tools_gw.disable_tab_log(self.dlg_fusion)

            # Set signals
            self.dlg_fusion.cmb_nodeaction.currentIndexChanged.connect(partial(self._manage_nodeaction))
            self.dlg_fusion.btn_accept.clicked.connect(self._fusion_arc)
            self.dlg_fusion.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_fusion))
            self.dlg_fusion.rejected.connect(partial(tools_gw.close_dialog, self.dlg_fusion))

            tools_gw.open_dialog(self.dlg_fusion, dlg_name='arc_fusion')


    def _manage_nodeaction(self, index):

        if index == 1:
            self.dlg_fusion.enddate.setEnabled(True)
            self.dlg_fusion.workcat_id_end.setEnabled(True)
            self.dlg_fusion.cmb_statetype.setEnabled(True)
        else:
            self.dlg_fusion.enddate.setEnabled(False)
            self.dlg_fusion.workcat_id_end.setEnabled(False)
            self.dlg_fusion.cmb_statetype.setEnabled(False)


    def _save_dlg_values(self):

        # Save combo 'Node action'
        node_action = tools_qt.get_text(self.dlg_fusion, "cmb_nodeaction")
        if node_action:
            tools_gw.set_config_parser("btn_arc_fusion", "cmb_nodeaction", node_action)

        # Save combo 'State type'
        state_type = tools_qt.get_text(self.dlg_fusion, "cmb_statetype")
        if state_type:
            tools_gw.set_config_parser("btn_arc_fusion", "cmb_statetype", state_type)

    # endregion