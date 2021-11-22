"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtWidgets import QMenu, QAction, QActionGroup
from qgis.core import QgsFeatureRequest

from ..maptool import GwMaptool
from ...shared.catalog import GwCatalog
from ...shared.info import GwInfo
from ...ui.ui_manager import GwFeatureTypeChangeUi
from ...utils import tools_gw
from ....lib import tools_qgis, tools_qt, tools_db
from .... import global_vars


class GwFeatureTypeChangeButton(GwMaptool):
    """ Button 28: Change feature type
    User select from drop-down button feature type: ARC, NODE, CONNEC.
    Snap to this feature type is activated.
    User selects a feature of that type from the map.
    A form is opened showing current feature_type.type and combos to replace it
    """

    def __init__(self, icon_path, action_name, text, toolbar, action_group, icon_type=1):

        super().__init__(icon_path, action_name, text, toolbar, action_group, icon_type)
        self.project_type = None
        self.feature_type = None
        self.tablename = None
        self.cat_table = None
        self.feature_edit_type = None
        self.feature_type_cat = None
        self.feature_id = None
        self.list_tables = ['v_edit_arc', 'v_edit_node', 'v_edit_connec', 'v_edit_gully']

        # Create a menu and add all the actions
        if toolbar is not None:
            toolbar.removeAction(self.action)

        self.menu = QMenu()
        self.menu.setObjectName("GW_change_menu")
        self._fill_change_menu()

        if toolbar is not None:
            self.action.setMenu(self.menu)
            toolbar.addAction(self.action)


    # region QgsMapTools inherited
    """ QgsMapTools inherited event functions """

    def activate(self):

        self.project_type = tools_gw.get_project_type()

        # Check action. It works if is selected from toolbar. Not working if is selected from menu or shortcut keys
        if hasattr(self.action, "setChecked"):
            self.action.setChecked(True)

        # Store user snapping configuration
        self.previous_snapping = self.snapper_manager.get_snapping_options()

        # Disable snapping
        self.snapper_manager.set_snapping_status()

        # Set snapping to 'node', 'connec' and 'gully'
        self.snapper_manager.set_snapping_layers()
        self.snapper_manager.config_snap_to_node()
        self.snapper_manager.config_snap_to_connec()
        self.snapper_manager.config_snap_to_gully()
        self.snapper_manager.config_snap_to_arc()
        self.snapper_manager.set_snap_mode()

        # Manage last feature type selected
        last_feature_type = tools_gw.get_config_parser("btn_featuretype_change", "last_feature_type", "user", "session")
        if last_feature_type is None:
            last_feature_type = "NODE"

        # Manage active layer
        self._set_active_layer(last_feature_type)
        layer = self.iface.activeLayer()
        tablename = tools_qgis.get_layer_source_table_name(layer)
        if tablename not in self.list_tables:
            self._set_active_layer(last_feature_type)

        # Change cursor
        self.canvas.setCursor(self.cursor)

        # Show help message when action is activated
        if self.show_help:
            message = "Click on feature to change its type"
            tools_qgis.show_info(message)


    def canvasMoveEvent(self, event):

        # Hide marker and get coordinates
        self.vertex_marker.hide()
        event_point = self.snapper_manager.get_event_point(event)

        # Snapping layers 'v_edit_'
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if result.isValid():
            layer = self.snapper_manager.get_snapped_layer(result)
            tablename = tools_qgis.get_layer_source_table_name(layer)
            if tablename and 'v_edit' in tablename:
                self.snapper_manager.add_marker(result, self.vertex_marker)


    def canvasReleaseEvent(self, event):

        self._featuretype_change(event)


    # endregion


    # region private functions

    def _fill_change_menu(self):
        """ Fill change feature type menu """

        # disconnect and remove previuos signals and actions
        actions = self.menu.actions()
        for action in actions:
            action.disconnect()
            self.menu.removeAction(action)
            del action
        ag = QActionGroup(self.iface.mainWindow())

        actions = ['ARC', 'NODE', 'CONNEC']
        if global_vars.project_type.lower() == 'ud':
            actions.append('GULLY')

        for action in actions:
            obj_action = QAction(f"{action}", ag)
            self.menu.addAction(obj_action)
            obj_action.triggered.connect(partial(super().clicked_event))
            obj_action.triggered.connect(partial(self._set_active_layer, action))
            obj_action.triggered.connect(partial(tools_gw.set_config_parser, section="btn_featuretype_change",
                                                 parameter="last_feature_type", value=action, comment=None))


    def _set_active_layer(self, name):
        """ Sets the active layer according to the name parameter (ARC, NODE, CONNEC, GULLY) """

        layers = {"ARC": "v_edit_arc", "NODE": "v_edit_node",
                  "CONNEC": "v_edit_connec", "GULLY": "v_edit_gully"}
        tablename = layers.get(name.upper())
        self.current_layer = tools_qgis.get_layer_by_tablename(tablename)
        self.iface.setActiveLayer(self.current_layer)


    def _open_catalog(self, feature_type):

        # Get feature_type
        child_type = tools_qt.get_text(self.dlg_change, self.dlg_change.feature_type_new)
        if child_type == 'null':
            msg = "New feature type is null. Please, select a valid value"
            tools_qt.show_info_box(msg, "Info")
            return

        self.catalog = GwCatalog()
        self.catalog.open_catalog(self.dlg_change, 'featurecat_id', feature_type, child_type)


    def _edit_change_elem_type_accept(self):
        """ Update current type of feature and save changes in database """

        project_type = tools_gw.get_project_type()
        feature_type_new = tools_qt.get_text(self.dlg_change, self.dlg_change.feature_type_new)
        featurecat_id = tools_qt.get_text(self.dlg_change, self.dlg_change.featurecat_id)

        if feature_type_new != "null":

            if (featurecat_id != "null" and featurecat_id is not None and project_type == 'ws') or (
                    project_type == 'ud'):

                fieldname = f"{self.feature_type}cat_id"
                if self.feature_type == "connec":
                    fieldname = f"connecat_id"
                elif self.feature_type == "gully":
                    fieldname = f"gratecat_id"
                sql = (f"UPDATE {self.tablename} "
                       f"SET {fieldname} = '{featurecat_id}' "
                       f"WHERE {self.feature_type}_id = '{self.feature_id}'")
                tools_db.execute_sql(sql)
                if project_type == 'ud':
                    sql = (f"UPDATE {self.tablename} "
                           f"SET {self.feature_type}_type = '{feature_type_new}' "
                           f"WHERE {self.feature_type}_id = '{self.feature_id}'")
                    tools_db.execute_sql(sql)

                tools_gw.set_config_parser("btn_featuretype_change", "feature_type_new", feature_type_new)
                tools_gw.set_config_parser("btn_featuretype_change", "featurecat_id", featurecat_id)
                message = "Values has been updated"
                tools_qgis.show_info(message)

            else:
                message = "Field catalog_id required!"
                tools_qgis.show_warning(message)
                return

        else:
            message = "Feature has not been updated because no catalog has been selected"
            tools_qgis.show_warning(message)

        # Close form
        tools_gw.close_dialog(self.dlg_change)

        # Refresh map canvas
        self.refresh_map_canvas()

        # Check if the expression is valid
        expr_filter = f"{self.feature_type}_id = '{self.feature_id}'"
        (is_valid, expr) = tools_qt.check_expression_filter(expr_filter)  # @UnusedVariable
        if not is_valid:
            return

        # Check in init config file if user wants to keep map tool active or not
        self.manage_active_maptool()


    def _open_custom_form(self, layer, expr):
        """ Open custom from selected layer """

        it = layer.getFeatures(QgsFeatureRequest(expr))
        features = [i for i in it]
        if features[0]:
            self.customForm = GwInfo('data')
            self.customForm.user_current_layer = self.current_layer
            feature_id = features[0][f"{self.feature_type}_id"]
            complet_result, dialog = self.customForm.get_info_from_id(self.tablename, feature_id, 'data')
            if not complet_result:
                return

            dialog.dlg_closed.connect(partial(tools_qgis.restore_user_layer, self.tablename))


    def _change_elem_type(self, feature):

        # Create the dialog, fill feature_type and define its signals
        self.dlg_change = GwFeatureTypeChangeUi()
        tools_gw.load_settings(self.dlg_change)
        tools_gw.add_icon(self.dlg_change.btn_catalog, "195")

        # Get featuretype_id from current feature
        project_type = tools_gw.get_project_type()
        if project_type == 'ws':
            self.dlg_change.feature_type_new.currentIndexChanged.connect(partial(self._filter_catalog))
        elif project_type == 'ud':
            sql = (f"SELECT DISTINCT(id), id "
                   f"FROM {self.cat_table} "
                   f"WHERE active IS TRUE OR active IS NULL "
                   f"ORDER BY id")
            rows = tools_db.get_rows(sql, log_sql=True)
            tools_qt.fill_combo_values(self.dlg_change.featurecat_id, rows, 1)

            # Set default value
            featurecat_id = tools_gw.get_config_parser("btn_featuretype_change", "featurecat_id", "user", "session")
            if featurecat_id not in (None, "None"):
                tools_qt.set_combo_value(self.dlg_change.featurecat_id, featurecat_id, 1, add_new=False)

        # Get feature type from current feature
        feature_type = feature.attribute(self.feature_edit_type)
        self.dlg_change.feature_type.setText(feature_type)

        # Fill 1st combo boxes-new system feature type
        sql = (f"SELECT DISTINCT(id) "
               f"FROM cat_feature "
               f"WHERE lower(feature_type) = '{self.feature_type}' AND active is True "
               f"ORDER BY id")
        rows = tools_db.get_rows(sql)
        rows.insert(0, ['', ''])
        feature_type_new = tools_gw.get_config_parser("btn_featuretype_change", "feature_type_new", "user", "session")
        tools_qt.fill_combo_values(self.dlg_change.feature_type_new, rows)
        if feature_type_new in (None, "None"):
            feature_type_new = feature_type
        in_combo = tools_qt.set_combo_value(self.dlg_change.feature_type_new, feature_type_new, 0, add_new=False)
        if not in_combo:
            tools_qt.set_combo_value(self.dlg_change.feature_type_new, feature_type, 0)

        # Set buttons signals
        self.dlg_change.btn_catalog.clicked.connect(partial(self._open_catalog, self.feature_type))
        self.dlg_change.btn_accept.clicked.connect(self._edit_change_elem_type_accept)
        self.dlg_change.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_change))

        # Open dialog
        tools_gw.open_dialog(self.dlg_change, 'featuretype_change')


    def _filter_catalog(self):

        feature_type_new = tools_qt.get_text(self.dlg_change, self.dlg_change.feature_type_new)
        if feature_type_new == "null":
            return

        # Populate catalog_id
        sql = (f"SELECT DISTINCT(id), id "
               f"FROM {self.cat_table} "
               f"WHERE {self.feature_type}type_id = '{feature_type_new}' AND (active IS TRUE OR active IS NULL) "
               f"ORDER BY id")
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_change.featurecat_id, rows, 1)
        featurecat_id = tools_gw.get_config_parser("btn_featuretype_change", "featurecat_id", "user", "session")
        if featurecat_id not in (None, "None"):
            tools_qt.set_combo_value(self.dlg_change.featurecat_id, featurecat_id, 1, add_new=False)


    def _featuretype_change(self, event):

        if event.button() == Qt.RightButton:
            self.cancel_map_tool()
            return

        # Get snapped feature
        event_point = self.snapper_manager.get_event_point(event)
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if not result.isValid():
            return

        snapped_feat = self.snapper_manager.get_snapped_feature(result)
        if snapped_feat is None:
            return

        layer = self.snapper_manager.get_snapped_layer(result)
        tablename = tools_qgis.get_layer_source_table_name(layer)
        if tablename and 'v_edit' in tablename:
            if tablename == 'v_edit_node':
                self.feature_type = 'node'
            elif tablename == 'v_edit_connec':
                self.feature_type = 'connec'
            elif tablename == 'v_edit_gully':
                self.feature_type = 'gully'
            elif tablename == 'v_edit_arc':
                self.feature_type = 'arc'

        self.tablename = tablename
        self.cat_table = f'cat_{self.feature_type}'
        if self.feature_type == 'gully':
            self.cat_table = f'cat_grate'
        self.feature_edit_type = f'{self.feature_type}_type'
        self.feature_type_cat = f'{self.feature_type}type_id'
        self.feature_id = snapped_feat.attribute(f'{self.feature_type}_id')
        self._change_elem_type(snapped_feat)

    # endregion