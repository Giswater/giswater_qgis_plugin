"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsFeatureRequest
from qgis.PyQt.QtCore import Qt

from functools import partial

from ....lib import tools_qt
from ...ui.ui_manager import NodeTypeChange
from ...shared.catalog import GwCatalog
from ...shared.info import GwInfo
from ..parent_maptool import GwParentMapTool
from ...utils.tools_giswater import check_expression, close_dialog, load_settings, open_dialog
from ....lib.tools_qgis import get_event_point, snap_to_current_layer, get_snapped_feature, get_snapping_options, \
    enable_snapping, restore_user_layer


class GwNodeTypeChangeButton(GwParentMapTool):
    """ Button 28: User select one node. A form is opened showing current node_type.type
            Combo to select new node_type.type
            Combo to select new node_type.id
            Combo to select new cat_node.id
    """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        """ Class constructor """

        super().__init__(icon_path, action_name, text, toolbar, action_group)


    def open_catalog(self):

        # Get feature_type
        feature_type = tools_qt.getWidgetText(self.dlg_chg_node_type, self.dlg_chg_node_type.node_node_type_new)
        if feature_type is 'null':
            msg = "New node type is null. Please, select a valid value."
            self.controller.show_info_box(msg, "Info")
            return
        self.catalog = GwCatalog()
        self.catalog.api_catalog(self.dlg_chg_node_type, 'node_nodecat_id', 'node', feature_type)


    def edit_change_elem_type_accept(self):
        """ Update current type of node and save changes in database """

        project_type = self.controller.get_project_type()
        node_node_type_new = tools_qt.getWidgetText(self.dlg_chg_node_type, self.dlg_chg_node_type.node_node_type_new)
        node_nodecat_id = tools_qt.getWidgetText(self.dlg_chg_node_type, self.dlg_chg_node_type.node_nodecat_id)

        layer = False
        if node_node_type_new != "null":

            if (node_nodecat_id != "null" and node_nodecat_id is not None and project_type == 'ws') or (project_type == 'ud'):
                # Update field 'nodecat_id'
                sql = (f"UPDATE v_edit_node SET nodecat_id = '{node_nodecat_id}' "
                       f"WHERE node_id = '{self.node_id}'")
                self.controller.execute_sql(sql)

                if project_type == 'ud':
                    sql = (f"UPDATE v_edit_node SET node_type = '{node_node_type_new}' "
                           f"WHERE node_id = '{self.node_id}'")
                    self.controller.execute_sql(sql)

                # Set active layer
                layer = self.controller.get_layer_by_tablename('v_edit_node')
                if layer:
                    self.iface.setActiveLayer(layer)
                message = "Values has been updated"
                self.controller.show_info(message)

            else:
                message = "Field catalog_id required!"
                self.controller.show_warning(message)
                return

        else:
            message = "The node has not been updated because no catalog has been selected"
            self.controller.show_warning(message)

        # Close form
        close_dialog(self.dlg_chg_node_type)

        # Refresh map canvas
        self.refresh_map_canvas()

        # Check if the expression is valid
        expr_filter = f"node_id = '{self.node_id}'"
        (is_valid, expr) = check_expression(expr_filter)  # @UnusedVariable
        if not is_valid:
            return
        if layer:
            self.open_custom_form(layer, expr)


    def open_custom_form(self, layer, expr):
        """ Open custom from selected layer """

        it = layer.getFeatures(QgsFeatureRequest(expr))
        features = [i for i in it]
        if features[0]:
            self.ApiCF = GwInfo(tab_type='data')
            self.ApiCF.user_current_layer = self.current_layer
            complet_result, dialog = self.ApiCF.get_info_from_id(table_name='v_edit_node', feature_id=features[0]["node_id"],
                                                                 tab_type='data')
            if not complet_result:
                return

            dialog.dlg_closed.connect(restore_user_layer)


    def change_elem_type(self, feature):

        # Create the dialog, fill node_type and define its signals
        self.dlg_chg_node_type = NodeTypeChange()
        load_settings(self.dlg_chg_node_type)

        # Get nodetype_id from current node
        node_type = ""
        project_type = self.controller.get_project_type()
        if project_type == 'ws':
            node_type = feature.attribute('nodetype_id')
            self.dlg_chg_node_type.node_node_type_new.currentIndexChanged.connect(partial(self.filter_catalog))
        elif project_type == 'ud':
            node_type = feature.attribute('node_type')
            sql = "SELECT DISTINCT(id), id FROM cat_node  ORDER BY id"
            rows = self.controller.get_rows(sql)
            tools_qt.set_item_data(self.dlg_chg_node_type.node_nodecat_id, rows, 1)

        self.dlg_chg_node_type.node_node_type.setText(node_type)
        self.dlg_chg_node_type.btn_catalog.clicked.connect(partial(self.open_catalog))
        self.dlg_chg_node_type.btn_accept.clicked.connect(self.edit_change_elem_type_accept)
        self.dlg_chg_node_type.btn_cancel.clicked.connect(partial(close_dialog, self.dlg_chg_node_type))

        # Fill 1st combo boxes-new system node type
        sql = ("SELECT DISTINCT(id) FROM cat_feature WHERE active is True "
               "AND feature_type = 'NODE' ORDER BY id")
        rows = self.controller.get_rows(sql)
        tools_qt.fillComboBox(self.dlg_chg_node_type, "node_node_type_new", rows)

        # Open dialog
        open_dialog(self.dlg_chg_node_type, dlg_name='nodetype_change', maximize_button=False)


    def filter_catalog(self):

        node_node_type_new = tools_qt.getWidgetText(self.dlg_chg_node_type,
                                                    self.dlg_chg_node_type.node_node_type_new)

        if node_node_type_new == "null":
            return

        # Populate catalog_id
        sql = f"SELECT DISTINCT(id), id FROM cat_node WHERE nodetype_id = '{node_node_type_new}' ORDER BY id"
        rows = self.controller.get_rows(sql)
        tools_qt.set_item_data(self.dlg_chg_node_type.node_nodecat_id, rows, 1)


    """ QgsMapTools inherited event functions """

    def keyPressEvent(self, event):
        if event.key() == Qt.Key_Escape:
            self.cancel_map_tool()
            return


    def canvasReleaseEvent(self, event):

        self.node_id = None

        # With left click the digitizing is finished
        if event.button() == Qt.RightButton:
            self.cancel_map_tool()
            return

        # Get the click
        event_point = get_event_point(event)

        # Snapping
        result = snap_to_current_layer(event_point)
        if result.isValid():
            # Get the point
            snapped_feat = get_snapped_feature(result)
            if snapped_feat:
                self.node_id = snapped_feat.attribute('node_id')
                # Change node type
                self.change_elem_type(snapped_feat)


    def activate(self):

        # Check button
        self.action.setChecked(True)

        # Store user snapping configuration
        self.previous_snapping = get_snapping_options()

        # Clear snapping
        enable_snapping()
        self.current_layer = self.iface.activeLayer()
        # Set active layer to 'v_edit_node'
        self.layer_node = self.controller.get_layer_by_tablename("v_edit_node")
        self.iface.setActiveLayer(self.layer_node)

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Select the node inside a pipe by clicking on it and it will be changed"
            self.controller.show_info(message)


    def deactivate(self):
        # Call parent method
        super().deactivate()

