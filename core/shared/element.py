"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from qgis.PyQt.QtCore import QRegExp
from qgis.PyQt.QtGui import QRegExpValidator
from qgis.PyQt.QtWidgets import QAbstractItemView, QPushButton, QTableView, QComboBox

from ..utils import tools_gw
from ..ui.ui_manager import GwElementUi, GwElementManagerUi
from ..utils.snap_manager import GwSnapManager
from ... import global_vars
from ...lib import tools_qgis, tools_qt, tools_db, tools_os


class GwElement:

    def __init__(self):
        """ Class to control 'Add element' of toolbar 'edit' """

        self.iface = global_vars.iface
        self.schema_name = global_vars.schema_name
        self.canvas = global_vars.canvas
        self.snapper_manager = GwSnapManager(self.iface)
        self.vertex_marker = self.snapper_manager.vertex_marker


    def get_element(self, new_element_id=True, feature=None, feature_type=None, selected_object_id=None):
        """ Button 33: Add element """
        self.rubber_band = tools_gw.create_rubberband(self.canvas)
        self.new_element_id = new_element_id

        # Create the dialog and signals
        self.dlg_add_element = GwElementUi()
        tools_gw.load_settings(self.dlg_add_element)
        self.element_id = None

        # Capture the current layer to return it at the end of the operation
        cur_active_layer = self.iface.activeLayer()

        widget_list = self.dlg_add_element.findChildren(QTableView)
        for widget in widget_list:
            tools_qt.set_tableview_config(widget)

        # Get layers of every feature_type

        # Setting lists
        self.ids = []
        self.list_ids = {}
        self.list_ids['arc'] = []
        self.list_ids['node'] = []
        self.list_ids['connec'] = []
        self.list_ids['gully'] = []
        self.list_ids['element'] = []

        # Setting layers
        self.layers = {}
        self.layers['arc'] = []
        self.layers['node'] = []
        self.layers['connec'] = []
        self.layers['gully'] = []
        self.layers['element'] = []

        self.layers['arc'] = tools_gw.get_layers_from_feature_type('arc')
        self.layers['node'] = tools_gw.get_layers_from_feature_type('node')
        self.layers['connec'] = tools_gw.get_layers_from_feature_type('connec')
        self.layers['element'] = tools_gw.get_layers_from_feature_type('element')
        self.point_xy = {"x": None, "y": None}

        # Remove 'gully' for 'WS'
        self.project_type = tools_gw.get_project_type()
        if self.project_type == 'ws':
            tools_qt.remove_tab(self.dlg_add_element.tab_feature, 'tab_gully')
        else:
            self.layers['gully'] = tools_gw.get_layers_from_feature_type('gully')

        # Set icons
        tools_gw.add_icon(self.dlg_add_element.btn_add_geom, "133")
        tools_gw.add_icon(self.dlg_add_element.btn_insert, "111")
        tools_gw.add_icon(self.dlg_add_element.btn_delete, "112")
        tools_gw.add_icon(self.dlg_add_element.btn_snapping, "137")

        # Remove all previous selections
        self.layers = tools_gw.remove_selection(True, layers=self.layers)
        if feature:
            layer = self.layers[feature_type][0]
            layer.selectByIds([feature.id()])

        self._check_date(self.dlg_add_element.builtdate, self.dlg_add_element.btn_accept, 1)
        self._check_date(self.dlg_add_element.enddate, self.dlg_add_element.btn_accept, 1)

        # Get layer element and save if is visible or not for restore when finish process
        layer_element = tools_qgis.get_layer_by_tablename("v_edit_element")
        layer_is_visible = False
        if layer_element:
            layer_is_visible = tools_qgis.is_layer_visible(layer_element)

        recursive = False
        if layer_is_visible:
            recursive = True

        # Adding auto-completion to a QLineEdit
        table_object = "element"
        tools_gw.set_completer_object(self.dlg_add_element, table_object)

        # Set signals
        excluded_layers = ["v_edit_arc", "v_edit_node", "v_edit_connec", "v_edit_element", "v_edit_gully",
                           "v_edit_element"]
        layers_visibility = tools_gw.get_parent_layers_visibility()
        self.dlg_add_element.rejected.connect(partial(tools_gw.restore_parent_layers_visibility, layers_visibility))
        self.dlg_add_element.btn_accept.clicked.connect(partial(self._manage_element_accept, table_object))
        self.dlg_add_element.btn_accept.clicked.connect(
            partial(tools_qgis.set_layer_visible, layer_element, recursive, layer_is_visible))
        self.dlg_add_element.btn_cancel.clicked.connect(lambda: setattr(self, 'layers', tools_gw.manage_close(
            self.dlg_add_element, table_object, cur_active_layer, layers=self.layers)))
        self.dlg_add_element.btn_cancel.clicked.connect(
            partial(tools_qgis.set_layer_visible, layer_element, recursive, layer_is_visible))
        self.dlg_add_element.rejected.connect(lambda: setattr(self, 'layers', tools_gw.manage_close(
            self.dlg_add_element, table_object, cur_active_layer, layers=self.layers)))
        self.dlg_add_element.rejected.connect(
            partial(tools_qgis.set_layer_visible, layer_element, recursive, layer_is_visible))
        self.dlg_add_element.tab_feature.currentChanged.connect(
            partial(tools_gw.get_signal_change_tab, self.dlg_add_element, excluded_layers))
        self.dlg_add_element.rejected.connect(lambda: tools_gw.reset_rubberband(self.rubber_band))

        self.dlg_add_element.element_id.textChanged.connect(
            partial(self._fill_dialog_element, self.dlg_add_element, table_object, None))
        self.dlg_add_element.btn_insert.clicked.connect(
            partial(tools_gw.insert_feature, self, self.dlg_add_element, table_object, False, False, None, None))
        self.dlg_add_element.btn_delete.clicked.connect(
            partial(tools_gw.delete_records, self, self.dlg_add_element, table_object, False, None, None))
        self.dlg_add_element.btn_snapping.clicked.connect(
            partial(tools_gw.selection_init, self, self.dlg_add_element, table_object, False))

        self.dlg_add_element.btn_add_geom.clicked.connect(self._get_point_xy)
        self.dlg_add_element.state.currentIndexChanged.connect(partial(self._filter_state_type))

        self.dlg_add_element.tbl_element_x_arc.clicked.connect(partial(tools_qgis.hilight_feature_by_id,
            self.dlg_add_element.tbl_element_x_arc, "v_edit_arc", "arc_id", self.rubber_band, 5))
        self.dlg_add_element.tbl_element_x_node.clicked.connect(partial(tools_qgis.hilight_feature_by_id,
            self.dlg_add_element.tbl_element_x_node, "v_edit_node", "node_id", self.rubber_band, 10))
        self.dlg_add_element.tbl_element_x_connec.clicked.connect(partial(tools_qgis.hilight_feature_by_id,
            self.dlg_add_element.tbl_element_x_connec, "v_edit_connec", "connec_id", self.rubber_band, 10))
        self.dlg_add_element.tbl_element_x_gully.clicked.connect(partial(tools_qgis.hilight_feature_by_id,
            self.dlg_add_element.tbl_element_x_gully, "v_edit_gully", "gully_id", self.rubber_band, 10))

        # Fill combo boxes of the form and related events
        self.dlg_add_element.element_type.currentIndexChanged.connect(partial(self._filter_elementcat_id))
        self.dlg_add_element.element_type.currentIndexChanged.connect(partial(self._update_location_cmb))

        # TODO maybe all this values can be in one Json query
        # Fill combo boxes
        sql = "SELECT DISTINCT(elementtype_id), elementtype_id FROM cat_element ORDER BY elementtype_id"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_add_element.element_type, rows, 1)

        sql = "SELECT expl_id, name FROM exploitation WHERE expl_id != '0' ORDER BY name"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_add_element.expl_id, rows, 1)

        sql = "SELECT DISTINCT(id), name FROM value_state"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_add_element.state, rows, 1)

        self._filter_state_type()

        sql = ("SELECT location_type, location_type FROM man_type_location"
               " WHERE feature_type = 'ELEMENT' "
               " ORDER BY location_type")
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_add_element.location_type, rows, 1)
        if rows:
            tools_qt.set_combo_value(self.dlg_add_element.location_type, rows[0][0], 0)

        sql = "SELECT DISTINCT(id), id FROM cat_owner"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_add_element.ownercat_id, rows, 1, add_empty=True)

        sql = "SELECT DISTINCT(id), id FROM cat_builder"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_add_element.buildercat_id, rows, 1, add_empty=True)

        sql = "SELECT DISTINCT(id), id FROM cat_work"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_add_element.workcat_id, rows, 1, add_empty=True)
        self.dlg_add_element.workcat_id.currentIndexChanged.connect(partial(
            tools_qt.set_stylesheet, self.dlg_add_element.workcat_id, None))

        sql = "SELECT DISTINCT(id), id FROM cat_work"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_add_element.workcat_id_end, rows, 1, add_empty=True)

        sql = "SELECT id, idval FROM edit_typevalue WHERE typevalue = 'value_verified'"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_add_element.verified, rows, 1, add_empty=True)
        self._filter_elementcat_id()

        if self.new_element_id:
            self._set_default_values()

        # Adding auto-completion to a QLineEdit for default feature
        tools_gw.set_completer_widget("v_edit_arc", self.dlg_add_element.feature_id, "arc_id", )

        if feature:
            self.dlg_add_element.tabWidget.currentChanged.connect(partial(
                self._fill_tbl_new_element, self.dlg_add_element, feature_type, feature[feature_type + "_id"]))

        # Set default tab 'arc'
        self.dlg_add_element.tab_feature.setCurrentIndex(0)
        self.feature_type = "arc"
        tools_gw.get_signal_change_tab(self.dlg_add_element, excluded_layers)

        # Force layer v_edit_element set active True
        if layer_element:
            tools_qgis.set_layer_visible(layer_element)

        # If is a new element dont need set enddate
        if self.new_element_id is True:
            tools_qt.set_widget_text(self.dlg_add_element, 'num_elements', '1')

        self._update_location_cmb()
        if not self.new_element_id:
            tools_qt.set_widget_text(self.dlg_add_element, 'element_id', selected_object_id)
            self._fill_dialog_element(self.dlg_add_element, 'element', None)

        # Open the dialog
        tools_gw.open_dialog(self.dlg_add_element, dlg_name='element', hide_config_widgets=True)
        return self.dlg_add_element


    def _update_location_cmb(self):

        element_type = tools_qt.get_text(self.dlg_add_element, self.dlg_add_element.element_type)
        sql = (f"SELECT location_type, location_type FROM man_type_location"
               f" WHERE feature_type = 'ELEMENT' "
               f" AND ('{element_type}' = ANY(featurecat_id::text[]) OR featurecat_id is null)"
               f" ORDER BY location_type")
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_add_element.location_type, rows, add_empty=True)
        if rows:
            tools_qt.set_combo_value(self.dlg_add_element.location_type, rows[0][0], 0)


    def manage_elements(self):
        """ Button 67: Edit element """

        # Create the dialog
        self.dlg_man = GwElementManagerUi()
        tools_gw.load_settings(self.dlg_man)
        self.dlg_man.tbl_element.setSelectionBehavior(QAbstractItemView.SelectRows)

        # Adding auto-completion to a QLineEdit
        table_object = "element"
        tools_gw.set_completer_object(self.dlg_man, table_object)

        # Set a model with selected filter. Attach that model to selected table
        message = tools_qt.fill_table(self.dlg_man.tbl_element, f"{self.schema_name}.{table_object}")
        if message:
            tools_qgis.show_warning(message)
        tools_gw.set_tablemodel_config(self.dlg_man, self.dlg_man.tbl_element, table_object)

        # Set signals
        self.dlg_man.element_id.textChanged.connect(partial(
            tools_qt.filter_by_id, self.dlg_man, self.dlg_man.tbl_element, self.dlg_man.element_id, table_object))
        self.dlg_man.tbl_element.doubleClicked.connect(partial(
            self._open_selected_object_element, self.dlg_man, self.dlg_man.tbl_element, table_object))
        self.dlg_man.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_man))
        self.dlg_man.rejected.connect(partial(tools_gw.close_dialog, self.dlg_man))
        self.dlg_man.btn_delete.clicked.connect(partial(
            tools_gw.delete_selected_rows, self.dlg_man.tbl_element, table_object))

        # Open form
        tools_gw.open_dialog(self.dlg_man, dlg_name='element_manager')


    # region private functions

    def _get_point_xy(self):

        self.snapper_manager.add_point(self.vertex_marker)
        self.point_xy = self.snapper_manager.point_xy


    def _set_default_values(self):
        """ Set default values """

        row = tools_gw.get_config_value("edit_elementcat_vdefault")
        if row:
            sql = f"SELECT elementtype_id, elementtype_id FROM cat_element WHERE id = '{row[0]}'"
            element_type = tools_db.get_row(sql)
            tools_qt.set_combo_value(self.dlg_add_element.element_type, element_type[0], 0)

        self._manage_combo(self.dlg_add_element.elementcat_id, 'edit_elementcat_vdefault')
        self._manage_combo(self.dlg_add_element.state, 'edit_state_vdefault')
        self._manage_combo(self.dlg_add_element.state_type, 'edit_statetype_1_vdefault')
        self._manage_combo(self.dlg_add_element.ownercat_id, 'edit_ownercat_vdefault')
        self._manage_combo(self.dlg_add_element.workcat_id, 'edit_workcat_vdefault')
        self._manage_combo(self.dlg_add_element.workcat_id_end, 'edit_workcat_id_end_vdefault')
        self._manage_combo(self.dlg_add_element.verified, 'edit_verified_vdefault')

        builtdate_vdef = tools_gw.get_config_value('edit_builtdate_vdefault')
        enddate_vdef = tools_gw.get_config_value('edit_enddate_vdefault')
        if builtdate_vdef:
            self.dlg_add_element.builtdate.setText(builtdate_vdef[0].replace('/', '-'))
        if enddate_vdef:
            self.dlg_add_element.enddate.setText(enddate_vdef[0].replace('/', '-'))


    def _manage_combo(self, combo, parameter):

        row = tools_gw.get_config_value(parameter)
        if row:
            tools_qt.set_combo_value(combo, row[0], 0)


    def _filter_state_type(self):

        state = tools_qt.get_combo_value(self.dlg_add_element, self.dlg_add_element.state, 0)
        sql = (f"SELECT DISTINCT(id), name FROM value_state_type "
               f"WHERE state = {state}")
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_add_element.state_type, rows, 1)


    def _fill_tbl_new_element(self, dialog, feature_type, feature_id):

        widget = "tbl_element_x_" + feature_type
        widget = dialog.findChild(QTableView, widget)
        widget.setSelectionBehavior(QAbstractItemView.SelectRows)
        expr_filter = f"{feature_type}_id = '{feature_id}'"

        # Set model of selected widget
        table_name = f"{self.schema_name}.v_edit_{feature_type}"
        message = tools_qt.fill_table(widget, table_name, expr_filter)
        if message:
            tools_qgis.show_warning(message)

        # Adding auto-completion to a QLineEdit
        self.table_object = "element"
        tools_gw.set_completer_object(dialog, self.table_object)


    def _manage_element_accept(self, table_object):
        """ Insert or update table 'element'. Add element to selected feature """

        # Get values from dialog
        element_id = tools_qt.get_text(self.dlg_add_element, "element_id", return_string_null=False)
        code = tools_qt.get_text(self.dlg_add_element, "code", return_string_null=False)
        elementcat_id = tools_qt.get_combo_value(self.dlg_add_element, self.dlg_add_element.elementcat_id)
        ownercat_id = tools_qt.get_combo_value(self.dlg_add_element, self.dlg_add_element.ownercat_id)
        location_type = tools_qt.get_combo_value(self.dlg_add_element, self.dlg_add_element.location_type)
        buildercat_id = tools_qt.get_combo_value(self.dlg_add_element, self.dlg_add_element.buildercat_id)
        builtdate = tools_qt.get_text(self.dlg_add_element, "builtdate", return_string_null=False)
        enddate = tools_qt.get_text(self.dlg_add_element, "enddate", return_string_null=False)
        workcat_id = tools_qt.get_combo_value(self.dlg_add_element, self.dlg_add_element.workcat_id)
        workcat_id_end = tools_qt.get_combo_value(self.dlg_add_element, self.dlg_add_element.workcat_id_end)
        comment = tools_qt.get_text(self.dlg_add_element, "comment", return_string_null=False)
        observ = tools_qt.get_text(self.dlg_add_element, "observ", return_string_null=False)
        link = tools_qt.get_text(self.dlg_add_element, "link", return_string_null=False)
        verified = tools_qt.get_combo_value(self.dlg_add_element, self.dlg_add_element.verified)
        rotation = tools_qt.get_text(self.dlg_add_element, "rotation")
        if rotation == 0 or rotation is None or rotation == 'null':
            rotation = '0'
        undelete = self.dlg_add_element.undelete.isChecked()

        # Check mandatory fields
        message = "You need to insert value for field"
        if elementcat_id == '':
            tools_qgis.show_warning(message, parameter="elementcat_id")
            return
        num_elements = tools_qt.get_text(self.dlg_add_element, "num_elements", return_string_null=False)
        if num_elements == '':
            tools_qgis.show_warning(message, parameter="num_elements")
            return
        state = tools_qt.get_combo_value(self.dlg_add_element, self.dlg_add_element.state)
        if state == '':
            tools_qgis.show_warning(message, parameter="state_id")
            return

        state_type = tools_qt.get_combo_value(self.dlg_add_element, self.dlg_add_element.state_type)
        expl_id = tools_qt.get_combo_value(self.dlg_add_element, self.dlg_add_element.expl_id)

        # Get SRID
        srid = global_vars.data_epsg

        # Check if this element already exists
        sql = (f"SELECT DISTINCT(element_id)"
               f" FROM {table_object}"
               f" WHERE element_id = '{element_id}'")
        row = tools_db.get_row(sql, log_info=False)
        if row is None:
            # If object not exist perform an INSERT
            if element_id == '':
                sql = ("INSERT INTO v_edit_element (elementcat_id,  num_elements, state, state_type"
                       ", expl_id, rotation, comment, observ, link, undelete, builtdate, enddate, ownercat_id"
                       ", location_type, buildercat_id, workcat_id, workcat_id_end, verified, the_geom, code)")
                sql_values = (f" VALUES ('{elementcat_id}', '{num_elements}', '{state}', '{state_type}', "
                              f"'{expl_id}', '{rotation}', $${comment}$$, $${observ}$$, "
                              f"$${link}$$, '{undelete}'")
            else:
                sql = ("INSERT INTO v_edit_element (element_id, elementcat_id, num_elements, state, state_type"
                       ", expl_id, rotation, comment, observ, link, undelete, builtdate, enddate, ownercat_id"
                       ", location_type, buildercat_id, workcat_id, workcat_id_end, verified, the_geom, code)")

                sql_values = (f" VALUES ('{element_id}', '{elementcat_id}', '{num_elements}',  '{state}', "
                              f"'{state_type}', '{expl_id}', '{rotation}', $${comment}$$, $${observ}$$, $${link}$$, "
                              f"'{undelete}'")
            if builtdate:
                sql_values += f", '{builtdate}'"
            else:
                sql_values += ", null"
            if enddate:
                sql_values += f", '{enddate}'"
            else:
                sql_values += ", null"
            if ownercat_id:
                sql_values += f", '{ownercat_id}'"
            else:
                sql_values += ", null"
            if location_type:
                sql_values += f", '{location_type}'"
            else:
                sql_values += ", null"
            if buildercat_id:
                sql_values += f", '{buildercat_id}'"
            else:
                sql_values += ", null"
            if workcat_id:
                sql_values += f", '{workcat_id}'"
            else:
                sql_values += ", null"
            if workcat_id_end:
                sql_values += f", '{workcat_id_end}'"
            else:
                sql_values += ", null"
            if verified:
                sql_values += f", '{verified}'"
            else:
                sql_values += ", null"
            if str(self.point_xy['x']) not in ("", None, "None"):
                sql_values += f", ST_SetSRID(ST_MakePoint({self.point_xy['x']},{self.point_xy['y']}), {srid})"
                self.point_xy['x'] = ""
            else:
                sql_values += ", null"
            if code:
                sql_values += f", $${code}$$"
            else:
                sql_values += ", null"
            if element_id == '':
                sql += sql_values + ") RETURNING element_id;"
                new_elem_id = tools_db.execute_returning(sql)
                sql_values = ""
                sql = ""
                element_id = str(new_elem_id[0])
            else:
                sql_values += ");\n"
            sql += sql_values
        # If object already exist perform an UPDATE
        else:
            message = "Are you sure you want to update the data?"
            answer = tools_qt.show_question(message)
            if not answer:
                return
            sql = (f"UPDATE element"
                   f" SET elementcat_id = '{elementcat_id}', num_elements = '{num_elements}', state = '{state}'"
                   f", state_type = '{state_type}', expl_id = '{expl_id}', rotation = '{rotation}'"
                   f", comment = $${comment}$$, observ = $${observ}$$"
                   f", link = $${link}$$, undelete = '{undelete}'")
            if builtdate:
                sql += f", builtdate = '{builtdate}'"
            else:
                sql += ", builtdate = null"
            if enddate:
                sql += f", enddate = '{enddate}'"
            else:
                sql += ", enddate = null"
            if ownercat_id:
                sql += f", ownercat_id = '{ownercat_id}'"
            else:
                sql += ", ownercat_id = null"
            if location_type:
                sql += f", location_type = '{location_type}'"
            else:
                sql += ", location_type = null"
            if buildercat_id:
                sql += f", buildercat_id = '{buildercat_id}'"
            else:
                sql += ", buildercat_id = null"
            if workcat_id:
                sql += f", workcat_id = '{workcat_id}'"
            else:
                sql += ", workcat_id = null"
            if code:
                sql += f", code = $${code}$$"
            else:
                sql += ", code = null"
            if workcat_id_end:
                sql += f", workcat_id_end = '{workcat_id_end}'"
            else:
                sql += ", workcat_id_end = null"
            if verified:
                sql += f", verified = '{verified}'"
            else:
                sql += ", verified = null"
            if str(self.point_xy['x']) not in ("", None, "None"):
                sql += f", the_geom = ST_SetSRID(ST_MakePoint({self.point_xy['x']},{self.point_xy['y']}), {srid})"

            sql += f" WHERE element_id = '{element_id}';"
        # Manage records in tables @table_object_x_@feature_type
        sql += (f"\nDELETE FROM element_x_node"
                f" WHERE element_id = '{element_id}';")
        sql += (f"\nDELETE FROM element_x_arc"
                f" WHERE element_id = '{element_id}';")
        sql += (f"\nDELETE FROM element_x_connec"
                f" WHERE element_id = '{element_id}';")

        if self.list_ids['arc']:
            for feature_id in self.list_ids['arc']:
                sql += (f"\nINSERT INTO element_x_arc (element_id, arc_id)"
                        f" VALUES ('{element_id}', '{feature_id}');")
        if self.list_ids['node']:
            for feature_id in self.list_ids['node']:
                sql += (f"\nINSERT INTO element_x_node (element_id, node_id)"
                        f" VALUES ('{element_id}', '{feature_id}');")
        if self.list_ids['connec']:
            for feature_id in self.list_ids['connec']:
                sql += (f"\nINSERT INTO element_x_connec (element_id, connec_id)"
                        f" VALUES ('{element_id}', '{feature_id}');")

        status = tools_db.execute_sql(sql)
        if status:
            self.element_id = element_id
            self.layers = tools_gw.manage_close(self.dlg_add_element, table_object, layers=self.layers)


    def _filter_elementcat_id(self):
        """ Filter QComboBox @elementcat_id according QComboBox @elementtype_id """

        element_type = tools_qt.get_combo_value(self.dlg_add_element, self.dlg_add_element.element_type, 1)
        sql = (f"SELECT DISTINCT(id), id FROM cat_element"
               f" WHERE elementtype_id = '{element_type}'"
               f" ORDER BY id")
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_add_element.elementcat_id, rows, 1)


    def _open_selected_object_element(self, dialog, widget, table_object):

        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return

        row = selected_list[0].row()

        # Get object_id from selected row
        field_object_id = table_object + "_id"
        selected_object_id = widget.model().record(row).value(field_object_id)

        # Close this dialog and open selected object
        keep_open_form = tools_gw.get_config_parser('dialogs_actions', 'element_manager_keep_open', "user", "init", prefix=True)
        if tools_os.set_boolean(keep_open_form, False) is not True:
            dialog.close()

        self.get_element(new_element_id=False, selected_object_id=selected_object_id)


    def _check_date(self, widget, button=None, regex_type=1):
        """ Set QRegExpression in order to validate QLineEdit(widget) field type date.
        Also allow to enable or disable a QPushButton(button), like typical accept button
        @Type=1 (yyy-mm-dd), @Type=2 (dd-mm-yyyy)
        """

        reg_exp = ""
        placeholder = "yyyy-mm-dd"
        if regex_type == 1:
            widget.setPlaceholderText("yyyy-mm-dd")
            placeholder = "yyyy-mm-dd"
            reg_exp = QRegExp("(((\d{4})([-])(0[13578]|10|12)([-])(0[1-9]|[12][0-9]|3[01]))|"
                              "((\d{4})([-])(0[469]|11)([-])([0][1-9]|[12][0-9]|30))|"
                              "((\d{4})([-])(02)([-])(0[1-9]|1[0-9]|2[0-8]))|"
                              "(([02468][048]00)([-])(02)([-])(29))|"
                              "(([13579][26]00)([-])(02)([-])(29))|"
                              "(([0-9][0-9][0][48])([-])(02)([-])(29))|"
                              "(([0-9][0-9][2468][048])([-])(02)([-])(29))|"
                              "(([0-9][0-9][13579][26])([-])(02)([-])(29)))")
        elif regex_type == 2:
            widget.setPlaceholderText("dd-mm-yyyy")
            placeholder = "dd-mm-yyyy"
            reg_exp = QRegExp("(((0[1-9]|[12][0-9]|3[01])([-])(0[13578]|10|12)([-])(\d{4}))|"
                              "(([0][1-9]|[12][0-9]|30)([-])(0[469]|11)([-])(\d{4}))|"
                              "((0[1-9]|1[0-9]|2[0-8])([-])(02)([-])(\d{4}))|"
                              "((29)(-)(02)([-])([02468][048]00))|"
                              "((29)([-])(02)([-])([13579][26]00))|"
                              "((29)([-])(02)([-])([0-9][0-9][0][48]))|"
                              "((29)([-])(02)([-])([0-9][0-9][2468][048]))|"
                              "((29)([-])(02)([-])([0-9][0-9][13579][26])))")
        elif regex_type == 3:
            widget.setPlaceholderText("yyyy/mm/dd")
            placeholder = "yyyy/mm/dd"
            reg_exp = QRegExp("(((\d{4})([/])(0[13578]|10|12)([/])(0[1-9]|[12][0-9]|3[01]))|"
                              "((\d{4})([/])(0[469]|11)([/])([0][1-9]|[12][0-9]|30))|"
                              "((\d{4})([/])(02)([/])(0[1-9]|1[0-9]|2[0-8]))|"
                              "(([02468][048]00)([/])(02)([/])(29))|"
                              "(([13579][26]00)([/])(02)([/])(29))|"
                              "(([0-9][0-9][0][48])([/])(02)([/])(29))|"
                              "(([0-9][0-9][2468][048])([/])(02)([/])(29))|"
                              "(([0-9][0-9][13579][26])([/])(02)([/])(29)))")
        elif regex_type == 4:
            widget.setPlaceholderText("dd/mm/yyyy")
            placeholder = "dd/mm/yyyy"
            reg_exp = QRegExp("(((0[1-9]|[12][0-9]|3[01])([/])(0[13578]|10|12)([/])(\d{4}))|"
                              "(([0][1-9]|[12][0-9]|30)([/])(0[469]|11)([/])(\d{4}))|"
                              "((0[1-9]|1[0-9]|2[0-8])([/])(02)([/])(\d{4}))|"
                              "((29)(-)(02)([/])([02468][048]00))|"
                              "((29)([/])(02)([/])([13579][26]00))|"
                              "((29)([/])(02)([/])([0-9][0-9][0][48]))|"
                              "((29)([/])(02)([/])([0-9][0-9][2468][048]))|"
                              "((29)([/])(02)([/])([0-9][0-9][13579][26])))")

        widget.setValidator(QRegExpValidator(reg_exp))
        widget.textChanged.connect(partial(self._check_regex, widget, reg_exp, button, placeholder))


    def _check_regex(self, widget, reg_exp, button, placeholder, text):

        is_valid = False
        if reg_exp.exactMatch(text) is True:
            widget.setStyleSheet(None)
            is_valid = True
        elif str(text) == '':
            widget.setStyleSheet(None)
            widget.setPlaceholderText(placeholder)
            is_valid = True
        elif reg_exp.exactMatch(text) is False:
            widget.setStyleSheet("border: 1px solid red")
            is_valid = False

        if button is not None and type(button) == QPushButton:
            if is_valid is False:
                button.setEnabled(False)
            else:
                button.setEnabled(True)


    def _fill_dialog_element(self, dialog, table_object, single_tool_mode=None):

        # Reset list of selected records
        self.ids, self.list_ids = tools_gw.reset_feature_list()

        list_feature_type = ['arc', 'node', 'connec', 'element']
        if global_vars.project_type == 'ud':
            list_feature_type.append('gully')

        object_id = tools_qt.get_text(dialog, table_object + "_id")

        # Check if we already have data with selected object_id
        sql = (f"SELECT * "
               f" FROM {table_object}"
               f" WHERE {table_object}_id = '{object_id}'")
        row = tools_db.get_row(sql, log_info=False)

        # If object_id not found: Clear data
        if not row:
            # Reset widgets
            widgets = ["elementcat_id", "state", "expl_id", "ownercat_id", "location_type", "buildercat_id",
                       "workcat_id", "workcat_id_end", "comment", "observ", "path", "rotation", "verified",
                       "num_elements"]
            for widget_name in widgets:
                tools_qt.set_widget_text(dialog, widget_name, "")

            self._set_combo_from_param_user(dialog, 'state', 'value_state', 'edit_state_vdefault', field_name='name')
            self._set_combo_from_param_user(dialog, 'expl_id', 'exploitation', 'edit_exploitation_vdefault',
                                           field_id='expl_id', field_name='name')
            self.dlg_add_element.builtdate.setText(
                tools_gw.get_config_value('edit_builtdate_vdefault')[0].replace('/', '-'))
            self.dlg_add_element.enddate.setText(
                tools_gw.get_config_value('edit_enddate_vdefault')[0].replace('/', '-'))
            self._set_combo_from_param_user(dialog, 'workcat_id', 'cat_work', 'edit_workcat_vdefault',
                                           field_id='id', field_name='id')
            if single_tool_mode is not None:
                self.layers = tools_gw.remove_selection(single_tool_mode, self.layers)
            else:
                self.layers = tools_gw.remove_selection(True, self.layers)

            for feature_type in list_feature_type:
                tools_qt.reset_model(dialog, table_object, feature_type)

            return

        tools_qt.set_widget_text(dialog, "code", row['code'])
        sql = (f"SELECT elementtype_id FROM cat_element"
               f" WHERE id = '{row['elementcat_id']}'")
        row_type = tools_db.get_row(sql)
        if row_type:
            tools_qt.set_widget_text(dialog, "element_type", f"{row_type[0]}")

        # Fill input widgets with data of the @row
        cmb_widgets = ["elementcat_id", "state", "state_type", "expl_id", "ownercat_id", "location_type", "buildercat_id", "workcat_id",
                   "workcat_id_end", "verified"]
        widgets = ["comment", "observ", "link", "rotation", "num_elements"]
        for widget_name in cmb_widgets:
            widget = dialog.findChild(QComboBox, widget_name)
            tools_qt.set_combo_value(widget, f"{row[widget_name]}", 0)
        for widget_name in widgets:
            tools_qt.set_widget_text(dialog, widget_name, f"{row[widget_name]}")

        tools_qt.set_widget_text(dialog, "builtdate", row['builtdate'])
        tools_qt.set_widget_text(dialog, "enddate", row['enddate'])
        if str(row['undelete']) == 'True':
            dialog.undelete.setChecked(True)

        # Check related @feature_type
        for feature_type in list_feature_type:
            tools_gw.get_rows_by_feature_type(self, dialog, table_object, feature_type)


    def _set_combo_from_param_user(self, dialog, widget, table_name, parameter, field_id='id', field_name='id'):
        """ Executes query and set combo box """

        sql = (f"SELECT t1.{field_name} FROM {table_name} as t1"
               f" INNER JOIN config_param_user as t2 ON t1.{field_id}::text = t2.value::text"
               f" WHERE parameter = '{parameter}' AND cur_user = current_user")
        row = tools_db.get_row(sql)
        if row:
            tools_qt.set_widget_text(dialog, widget, row[0])


    # endregion
