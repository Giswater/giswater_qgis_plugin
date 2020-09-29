"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtWidgets import QAbstractItemView, QTableView
from qgis.gui import QgsVertexMarker

from functools import partial

from lib import tools_qt
from core.utils.tools_giswater import close_dialog, load_settings, open_dialog
from core.ui.ui_manager import ElementUi, ElementManager
import global_vars
from actions.parent_manage_funct import set_completer_object, tab_feature_changed, \
    set_completer_widget, set_table_columns

from lib.tools_qgis import remove_selection, add_point, selection_init, insert_feature
from lib.tools_qt import delete_records, manage_close, fill_table_object, filter_by_id, delete_selected_object, \
    set_selectionbehavior, set_model_to_table, set_icon, exist_object

class GwElement:

    def __init__(self):
        """ Class to control 'Add element' of toolbar 'edit' """

        self.iface = global_vars.iface
        self.controller = global_vars.controller
        self.schema_name = global_vars.schema_name

        self.vertex_marker = QgsVertexMarker(global_vars.canvas)


    def manage_element(self, new_element_id=True, feature=None, geom_type=None):
        """ Button 33: Add element """

        self.new_element_id = new_element_id

        # Create the dialog and signals
        self.dlg_add_element = ElementUi()
        load_settings(self.dlg_add_element)
        self.element_id = None

        # Capture the current layer to return it at the end of the operation
        cur_active_layer = self.iface.activeLayer()

        set_selectionbehavior(self.dlg_add_element)

        # Get layers of every geom_type

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

        self.layers['arc'] = self.controller.get_group_layers('arc')
        self.layers['node'] = self.controller.get_group_layers('node')
        self.layers['connec'] = self.controller.get_group_layers('connec')
        self.layers['element'] = self.controller.get_group_layers('element')

        # Remove 'gully' for 'WS'
        self.project_type = self.controller.get_project_type()
        if self.project_type == 'ws':
            self.dlg_add_element.tab_feature.removeTab(3)
        else:
            self.layers['gully'] = self.controller.get_group_layers('gully')

        # Set icons
        set_icon(self.dlg_add_element.btn_add_geom, "133")
        set_icon(self.dlg_add_element.btn_insert, "111")
        set_icon(self.dlg_add_element.btn_delete, "112")
        set_icon(self.dlg_add_element.btn_snapping, "137")

        # Remove all previous selections
        self.layers = remove_selection(True, layers=self.layers)
        if feature:
            layer = self.iface.activeLayer()
            layer.selectByIds([feature.id()])

        tools_qt.set_regexp_date_validator(self.dlg_add_element.builtdate, self.dlg_add_element.btn_accept, 1)

        # Get layer element and save if is visible or not for restore when finish process
        layer_element = self.controller.get_layer_by_tablename("v_edit_element")
        layer_is_visible = False
        if layer_element:
            layer_is_visible = self.controller.is_layer_visible(layer_element)

        # Adding auto-completion to a QLineEdit
        table_object = "element"
        set_completer_object(self.dlg_add_element, table_object)

        # Set signals
        self.dlg_add_element.btn_accept.clicked.connect(partial(self.manage_element_accept, table_object))
        self.dlg_add_element.btn_accept.clicked.connect(
            partial(self.controller.set_layer_visible, layer_element, layer_is_visible))
        # TODO: Set variable  self.layers using return parameters
        self.dlg_add_element.btn_cancel.clicked.connect(
            partial(manage_close, self.dlg_add_element, table_object, cur_active_layer, excluded_layers=[],
                    layers=self.layers))
        self.dlg_add_element.btn_cancel.clicked.connect(
            partial(self.controller.set_layer_visible, layer_element, layer_is_visible))
        # TODO: Set variable  self.layers using return parameters
        self.dlg_add_element.rejected.connect(
            partial(manage_close, self.dlg_add_element, table_object, cur_active_layer, excluded_layers=[],
                    layers=self.layers))
        self.dlg_add_element.rejected.connect(
            partial(self.controller.set_layer_visible, layer_element, layer_is_visible))
        self.dlg_add_element.tab_feature.currentChanged.connect(
            partial(tab_feature_changed, self.dlg_add_element, table_object, []))
        # TODO: Set variables self.ids, self.layers, self.list_ids using return parameters
        self.dlg_add_element.element_id.textChanged.connect(
            partial(exist_object, self.dlg_add_element, table_object, layers=self.layers,
                    ids=self.ids, list_ids=self.list_ids))
        # TODO: Set variables self.ids, self.layers, self.list_ids using return parameters
        self.dlg_add_element.btn_insert.clicked.connect(
            partial(insert_feature, self.dlg_add_element, table_object, geom_type=geom_type, ids=self.ids,
                    layers=self.layers, list_ids=self.list_ids))
        # TODO: Set variables self.ids, self.layers, self.list_ids using return parameters
        self.dlg_add_element.btn_delete.clicked.connect(
            partial(delete_records, self.dlg_add_element, table_object, geom_type=geom_type, layers=self.layers,
                    ids=self.ids, list_ids=self.list_ids))
        # TODO: Set variables self.ids, self.layers, self.list_ids using return parameters
        self.dlg_add_element.btn_snapping.clicked.connect(
            partial(selection_init, self.dlg_add_element, table_object, geom_type=geom_type, layers=self.layers))
        self.point_xy = self.dlg_add_element.btn_add_geom.clicked.connect(partial(add_point, self.vertex_marker))
        self.dlg_add_element.state.currentIndexChanged.connect(partial(self.filter_state_type))

        # Fill combo boxes of the form and related events
        self.dlg_add_element.element_type.currentIndexChanged.connect(partial(self.filter_elementcat_id))
        self.dlg_add_element.element_type.currentIndexChanged.connect(partial(self.update_location_cmb))
        # TODO maybe all this values can be in one Json query
        # Fill combo boxes
        sql = "SELECT DISTINCT(elementtype_id), elementtype_id FROM cat_element ORDER BY elementtype_id"
        rows = self.controller.get_rows(sql)
        tools_qt.set_item_data(self.dlg_add_element.element_type, rows, 1)

        sql = "SELECT expl_id, name FROM exploitation WHERE expl_id != '0' ORDER BY name"
        rows = self.controller.get_rows(sql)
        tools_qt.set_item_data(self.dlg_add_element.expl_id, rows, 1)

        sql = "SELECT DISTINCT(id), name FROM value_state"
        rows = self.controller.get_rows(sql)
        tools_qt.set_item_data(self.dlg_add_element.state, rows, 1)

        self.filter_state_type()

        sql = ("SELECT location_type, location_type FROM man_type_location"
               " WHERE feature_type = 'ELEMENT' "
               " ORDER BY location_type")
        rows = self.controller.get_rows(sql)
        tools_qt.set_item_data(self.dlg_add_element.location_type, rows, 1)

        if rows:
            tools_qt.set_combo_itemData(self.dlg_add_element.location_type, rows[0][0], 0)

        sql = "SELECT DISTINCT(id), id FROM cat_owner"
        rows = self.controller.get_rows(sql)
        tools_qt.set_item_data(self.dlg_add_element.ownercat_id, rows, 1, add_empty=True)

        sql = "SELECT DISTINCT(id), id FROM cat_builder"
        rows = self.controller.get_rows(sql)
        tools_qt.set_item_data(self.dlg_add_element.buildercat_id, rows, 1, add_empty=True)

        sql = "SELECT DISTINCT(id), id FROM cat_work"
        rows = self.controller.get_rows(sql)
        tools_qt.set_item_data(self.dlg_add_element.workcat_id, rows, 1, add_empty=True)
        self.dlg_add_element.workcat_id.currentIndexChanged.connect(partial(
            self.set_style_sheet, self.dlg_add_element.workcat_id, None))

        sql = "SELECT DISTINCT(id), id FROM cat_work"
        rows = self.controller.get_rows(sql)
        tools_qt.set_item_data(self.dlg_add_element.workcat_id_end, rows, 1, add_empty=True)

        sql = "SELECT id, idval FROM edit_typevalue WHERE typevalue = 'value_verified'"
        rows = self.controller.get_rows(sql)
        tools_qt.set_item_data(self.dlg_add_element.verified, rows, 1, add_empty=True)
        self.filter_elementcat_id()

        if self.new_element_id:

            # Set default values
            self.set_default_values()

        # Adding auto-completion to a QLineEdit for default feature
        set_completer_widget("v_edit_arc", self.dlg_add_element.feature_id, "arc_id", )

        if feature:
            self.dlg_add_element.tabWidget.currentChanged.connect(partial(self.fill_tbl_new_element,
                self.dlg_add_element, geom_type, feature[geom_type + "_id"]))

        # Set default tab 'arc'
        self.dlg_add_element.tab_feature.setCurrentIndex(0)
        self.geom_type = "arc"
        tab_feature_changed(self.dlg_add_element, table_object)

        # Force layer v_edit_element set active True
        if layer_element:
            self.controller.set_layer_visible(layer_element)

        # If is a new element dont need set enddate
        if self.new_element_id is True:
            tools_qt.setWidgetText(self.dlg_add_element, 'num_elements', '1')

        self.update_location_cmb()
        if not self.new_element_id:
            self.ids, self.layers, self.list_ids = exist_object(self.dlg_add_element, 'element', layers=self.layers,
                                                                ids=self.ids, list_ids=self.list_ids)

        # Open the dialog
        open_dialog(self.dlg_add_element, dlg_name='element', maximize_button=False)
        return self.dlg_add_element


    def set_style_sheet(self, widget, style="border: 1px solid red"):
        widget.setStyleSheet(style)


    def set_default_values(self):
        """ Set default values """

        self.manage_combo(self.dlg_add_element.element_type, 'elementcat_vdefault')
        self.manage_combo(self.dlg_add_element.elementcat_id, 'elementcat_vdefault')
        self.manage_combo(self.dlg_add_element.state, 'state_vdefault')
        self.manage_combo(self.dlg_add_element.state_type, 'statetype_1_vdefault')
        self.manage_combo(self.dlg_add_element.ownercat_id, 'ownercat_vdefault')
        self.manage_combo(self.dlg_add_element.builtdate, 'builtdate_vdefault')
        self.manage_combo(self.dlg_add_element.workcat_id, 'workcat_vdefault')
        self.manage_combo(self.dlg_add_element.workcat_id_end, 'workcat_id_end_vdefault')
        self.manage_combo(self.dlg_add_element.verified, 'verified_vdefault')


    def manage_combo(self, combo, parameter):

        row = self.controller.get_config(parameter)
        if row:
            tools_qt.set_combo_itemData(combo, row[0], 0)


    def filter_state_type(self):

        state = tools_qt.get_item_data(self.dlg_add_element, self.dlg_add_element.state, 0)
        sql = (f"SELECT DISTINCT(id), name FROM value_state_type "
               f"WHERE state = {state}")
        rows = self.controller.get_rows(sql)
        tools_qt.set_item_data(self.dlg_add_element.state_type, rows, 1)


    def update_location_cmb(self):

        element_type = tools_qt.getWidgetText(self.dlg_add_element, self.dlg_add_element.element_type)
        sql = (f"SELECT location_type, location_type FROM man_type_location"
               f" WHERE feature_type = 'ELEMENT' "
               f" AND (featurecat_id = '{element_type}' OR featurecat_id is null)"
               f" ORDER BY location_type")
        rows = self.controller.get_rows(sql)
        tools_qt.set_item_data(self.dlg_add_element.location_type, rows, add_empty=True)
        if rows:
            tools_qt.set_combo_itemData(self.dlg_add_element.location_type, rows[0][0], 0)


    def fill_tbl_new_element(self, dialog, geom_type, feature_id):

        widget = "tbl_element_x_" + geom_type
        widget = dialog.findChild(QTableView, widget)
        widget.setSelectionBehavior(QAbstractItemView.SelectRows)
        expr_filter = f"{geom_type}_id = '{feature_id}'"

        # Set model of selected widget
        table_name = f"{self.schema_name}.v_edit_{geom_type}"
        set_model_to_table(widget, table_name, expr_filter)

        # Adding auto-completion to a QLineEdit
        self.table_object = "element"
        set_completer_object(dialog, self.table_object)


    def manage_element_accept(self, table_object):
        """ Insert or update table 'element'. Add element to selected feature """

        # Get values from dialog
        element_id = tools_qt.getWidgetText(self.dlg_add_element, "element_id", return_string_null=False)
        code = tools_qt.getWidgetText(self.dlg_add_element, "code", return_string_null=False)
        elementcat_id = tools_qt.get_item_data(self.dlg_add_element, self.dlg_add_element.elementcat_id)
        ownercat_id = tools_qt.get_item_data(self.dlg_add_element, self.dlg_add_element.ownercat_id)
        location_type = tools_qt.get_item_data(self.dlg_add_element, self.dlg_add_element.location_type)
        buildercat_id = tools_qt.get_item_data(self.dlg_add_element, self.dlg_add_element.buildercat_id)
        builtdate = tools_qt.getWidgetText(self.dlg_add_element, "builtdate", return_string_null=False)
        workcat_id = tools_qt.get_item_data(self.dlg_add_element, self.dlg_add_element.workcat_id)
        workcat_id_end = tools_qt.get_item_data(self.dlg_add_element, self.dlg_add_element.workcat_id_end)
        comment = tools_qt.getWidgetText(self.dlg_add_element, "comment", return_string_null=False)
        observ = tools_qt.getWidgetText(self.dlg_add_element, "observ", return_string_null=False)
        link = tools_qt.getWidgetText(self.dlg_add_element, "link", return_string_null=False)
        verified = tools_qt.get_item_data(self.dlg_add_element, self.dlg_add_element.verified)
        rotation = tools_qt.getWidgetText(self.dlg_add_element, "rotation")
        if rotation == 0 or rotation is None or rotation == 'null':
            rotation = '0'
        undelete = self.dlg_add_element.undelete.isChecked()

        # Check mandatory fields
        message = "You need to insert value for field"
        if elementcat_id == '':
            self.controller.show_warning(message, parameter="elementcat_id")
            return
        num_elements = tools_qt.getWidgetText(self.dlg_add_element, "num_elements", return_string_null=False)
        if num_elements == '':
            self.controller.show_warning(message, parameter="num_elements")
            return
        state = tools_qt.get_item_data(self.dlg_add_element, self.dlg_add_element.state)
        if state == '':
            self.controller.show_warning(message, parameter="state_id")
            return

        state_type = tools_qt.get_item_data(self.dlg_add_element, self.dlg_add_element.state_type)
        expl_id = tools_qt.get_item_data(self.dlg_add_element, self.dlg_add_element.expl_id)

        # Get SRID
        srid = global_vars.srid

        # Check if this element already exists
        sql = (f"SELECT DISTINCT(element_id)"
               f" FROM {table_object}"
               f" WHERE element_id = '{element_id}'")
        row = self.controller.get_row(sql, log_info=False)

        if row is None:
            # If object not exist perform an INSERT
            if element_id == '':
                sql = ("INSERT INTO v_edit_element (elementcat_id,  num_elements, state, state_type"
                       ", expl_id, rotation, comment, observ, link, undelete, builtdate"
                       ", ownercat_id, location_type, buildercat_id, workcat_id, workcat_id_end, verified, the_geom, code)")
                sql_values = (f" VALUES ('{elementcat_id}', '{num_elements}', '{state}', '{state_type}', "
                              f"'{expl_id}', '{rotation}', '{comment}', '{observ}', "
                              f"'{link}', '{undelete}'")
            else:
                sql = ("INSERT INTO v_edit_element (element_id, elementcat_id, num_elements, state, state_type"
                       ", expl_id, rotation, comment, observ, link, undelete, builtdate"
                       ", ownercat_id, location_type, buildercat_id, workcat_id, workcat_id_end, verified, the_geom, code)")

                sql_values = (f" VALUES ('{element_id}', '{elementcat_id}', '{num_elements}',  '{state}', '{state_type}', "
                              f"'{expl_id}', '{rotation}', '{comment}', '{observ}', "
                              f"'{link}', '{undelete}'")

            if builtdate:
                sql_values += f", '{builtdate}'"
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
                self.set_style_sheet(self.dlg_add_element.workcat_id)
                return
            if workcat_id_end:
                sql_values += f", '{workcat_id_end}'"
            else:
                sql_values += ", null"
            if verified:
                sql_values += f", '{verified}'"
            else:
                sql_values += ", null"

            if str(self.point_xy['x']) != "":
                sql_values += f", ST_SetSRID(ST_MakePoint({self.point_xy['x']},{self.point_xy['y']}), {srid})"
                self.point_xy['x'] = ""
            else:
                sql_values += ", null"
            if code:
                sql_values += f", '{code}'"
            else:
                sql_values += ", null"
            if element_id == '':
                sql += sql_values + ") RETURNING element_id;"
                new_elem_id = self.controller.execute_returning(sql)
                sql_values = ""
                sql = ""
                element_id = str(new_elem_id[0])
            else:
                sql_values += ");\n"
            sql += sql_values

        # If object already exist perform an UPDATE
        else:
            message = "Are you sure you want to update the data?"
            answer = self.controller.ask_question(message)
            if not answer:
                return
            sql = (f"UPDATE element"
                   f" SET elementcat_id = '{elementcat_id}', num_elements = '{num_elements}', state = '{state}'"
                   f", state_type = '{state_type}', expl_id = '{expl_id}', rotation = '{rotation}'"
                   f", comment = '{comment}', observ = '{observ}'"
                   f", link = '{link}', undelete = '{undelete}'")
            if builtdate:
                sql += f", builtdate = '{builtdate}'"
            else:
                sql += ", builtdate = null"
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
                sql += f", code = '{code}'"
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
            if str(self.point_xy['x']) != "":
                sql += f", the_geom = ST_SetSRID(ST_MakePoint({self.point_xy['x']},{self.point_xy['y']}), {srid})"

            sql += f" WHERE element_id = '{element_id}';"

        # Manage records in tables @table_object_x_@geom_type
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

        status = self.controller.execute_sql(sql)
        if status:
            self.element_id = element_id
            self.layers = manage_close(self.dlg_add_element, table_object, excluded_layers=[], layers=self.layers)


    def filter_elementcat_id(self):
        """ Filter QComboBox @elementcat_id according QComboBox @elementtype_id """

        element_type = tools_qt.get_item_data(self.dlg_add_element, self.dlg_add_element.element_type, 1)
        sql = (f"SELECT DISTINCT(id), id FROM cat_element"
               f" WHERE elementtype_id = '{element_type}'"
               f" ORDER BY id")
        rows = self.controller.get_rows(sql)
        tools_qt.set_item_data(self.dlg_add_element.elementcat_id, rows, 1)


    def edit_element(self):
        """ Button 67: Edit element """

        # Create the dialog
        self.dlg_man = ElementManager()
        load_settings(self.dlg_man)
        self.dlg_man.tbl_element.setSelectionBehavior(QAbstractItemView.SelectRows)

        # Adding auto-completion to a QLineEdit
        table_object = "element"
        set_completer_object(self.dlg_man, table_object)

        # Set a model with selected filter. Attach that model to selected table
        fill_table_object(self.dlg_man.tbl_element, self.schema_name + "." + table_object)
        set_table_columns(self.dlg_man, self.dlg_man.tbl_element, table_object)

        # Set signals
        self.dlg_man.element_id.textChanged.connect(partial(filter_by_id, self.dlg_man, self.dlg_man.tbl_element,
            self.dlg_man.element_id, table_object))
        self.dlg_man.tbl_element.doubleClicked.connect(partial(self.open_selected_object_element, self.dlg_man,
            self.dlg_man.tbl_element, table_object))
        self.dlg_man.btn_cancel.clicked.connect(partial(close_dialog, self.dlg_man))
        self.dlg_man.rejected.connect(partial(close_dialog, self.dlg_man))
        self.dlg_man.btn_delete.clicked.connect(partial(delete_selected_object, self.dlg_man.tbl_element,
            table_object))

        # Open form
        open_dialog(self.dlg_man, dlg_name='element_manager')


    def open_selected_object_element(self, dialog, widget, table_object):

        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        row = selected_list[0].row()

        # Get object_id from selected row
        widget_id = table_object + "_id"
        field_object_id = table_object + "_id"

        selected_object_id = widget.model().record(row).value(field_object_id)

        # Close this dialog and open selected object
        dialog.close()

        self.manage_element(new_element_id=False)
        tools_qt.setWidgetText(self.dlg_add_element, widget_id, selected_object_id)


