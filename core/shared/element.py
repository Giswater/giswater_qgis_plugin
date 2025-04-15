"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import webbrowser

from functools import partial
from sip import isdeleted

from qgis.PyQt.QtCore import QRegExp, Qt
from qgis.PyQt.QtGui import QRegExpValidator, QCursor
from qgis.PyQt.QtWidgets import QAbstractItemView, QPushButton, QTableView, QComboBox, QGridLayout, QSpacerItem, QSizePolicy, QLineEdit

from ..utils import tools_gw, tools_backend_calls
from ..utils.selection_mode import GwSelectionMode
from ..ui.ui_manager import GwElementUi, GwElementManagerUi
from ..utils.snap_manager import GwSnapManager
from ... import global_vars
from ...libs import lib_vars, tools_qgis, tools_qt, tools_db, tools_os


class GwElement:

    def __init__(self):
        """ Class to control 'Add element' of toolbar 'edit' """

        self.iface = global_vars.iface
        self.schema_name = lib_vars.schema_name
        self.canvas = global_vars.canvas
        self.snapper_manager = GwSnapManager(self.iface)
        self.vertex_marker = self.snapper_manager.vertex_marker
        self.dlg_add_element = None

    def get_element(self, new_element_id=True, feature=None, feature_type=None, selected_object_id=None, list_tabs=None):
        """ Button 33: Add element """

        self.rubber_band = tools_gw.create_rubberband(self.canvas)
        self.new_element_id = new_element_id

        # Create the dialog and signals
        self.dlg_add_element = GwElementUi(self)
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
        self.list_ids = {'arc': [], 'node': [], 'connec': [], 'link': [], 'gully': [], 'element': []}
        self.layers = {'arc': [], 'node': [], 'connec': [], 'link': [], 'gully': [], 'element': []}
        self.layers['arc'] = tools_gw.get_layers_from_feature_type('arc')
        self.layers['node'] = tools_gw.get_layers_from_feature_type('node')
        self.layers['connec'] = tools_gw.get_layers_from_feature_type('connec')
        self.layers['link'] = tools_gw.get_layers_from_feature_type('link')
        self.layers['element'] = tools_gw.get_layers_from_feature_type('element')
        self.point_xy = {"x": None, "y": None}

        params = ['arc', 'node', 'connec', 'gully', 'link']
        if list_tabs:
            for i in params:
                if i not in list_tabs:
                    tools_qt.remove_tab(self.dlg_add_element.tab_feature, f'tab_{i}')

        # Remove 'gully' if not 'UD'
        self.project_type = tools_gw.get_project_type()
        if self.project_type != 'ud':
            tools_qt.remove_tab(self.dlg_add_element.tab_feature, 'tab_gully')
        else:
            self.layers['gully'] = tools_gw.get_layers_from_feature_type('gully')

        # Set icons
        tools_gw.add_icon(self.dlg_add_element.btn_add_geom, "133")
        tools_gw.add_icon(self.dlg_add_element.btn_insert, "111")
        tools_gw.add_icon(self.dlg_add_element.btn_delete, "112")
        tools_gw.add_icon(self.dlg_add_element.btn_snapping, "137")
        tools_gw.add_icon(self.dlg_add_element.btn_expr_select, "178")
        tools_gw.add_icon(self.dlg_add_element.btn_path_url, "173")

        # Remove all previous selections
        self.layers = tools_gw.remove_selection(True, layers=self.layers)
        if feature:
            layer = self.layers[feature_type][0]
            layer.selectByIds([feature.id()])

        tools_qt.check_date(self.dlg_add_element.builtdate, self.dlg_add_element.btn_accept, 1)
        tools_qt.check_date(self.dlg_add_element.enddate, self.dlg_add_element.btn_accept, 1)

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
        tools_gw.set_completer_object(self.dlg_add_element, table_object, field_id='element_id')

        # Set signals
        excluded_layers = ["v_edit_arc", "v_edit_node", "v_edit_connec", "v_edit_element", "v_edit_gully",
                           "v_edit_element", "v_edit_link"]
        self.excluded_layers = excluded_layers
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
            partial(tools_gw.insert_feature, self, self.dlg_add_element, table_object, GwSelectionMode.DEFAULT, False, None, None))
        self.dlg_add_element.btn_delete.clicked.connect(
            partial(tools_gw.delete_records, self, self.dlg_add_element, table_object, GwSelectionMode.DEFAULT, None, None))
        self.dlg_add_element.btn_snapping.clicked.connect(
            partial(tools_gw.selection_init, self, self.dlg_add_element, table_object, GwSelectionMode.DEFAULT))
        self.dlg_add_element.btn_expr_select.clicked.connect(
            partial(tools_gw.select_with_expression_dialog, self, self.dlg_add_element, table_object)
        )

        self.dlg_add_element.btn_add_geom.clicked.connect(self._get_point_xy)
        self.dlg_add_element.state.currentIndexChanged.connect(partial(self._filter_state_type))

        self.dlg_add_element.tbl_element_x_arc.clicked.connect(partial(tools_qgis.highlight_feature_by_id,
                                                                       self.dlg_add_element.tbl_element_x_arc, "v_edit_arc", "arc_id", self.rubber_band, 5))
        self.dlg_add_element.tbl_element_x_node.clicked.connect(partial(tools_qgis.highlight_feature_by_id,
                                                                        self.dlg_add_element.tbl_element_x_node, "v_edit_node", "node_id", self.rubber_band, 10))
        self.dlg_add_element.tbl_element_x_connec.clicked.connect(partial(tools_qgis.highlight_feature_by_id,
                                                                          self.dlg_add_element.tbl_element_x_connec, "v_edit_connec", "connec_id", self.rubber_band, 10))
        self.dlg_add_element.tbl_element_x_gully.clicked.connect(partial(tools_qgis.highlight_feature_by_id,
                                                                         self.dlg_add_element.tbl_element_x_gully, "v_edit_gully", "gully_id", self.rubber_band, 10))
        self.dlg_add_element.tbl_element_x_link.clicked.connect(partial(tools_qgis.highlight_feature_by_id,
                                                                         self.dlg_add_element.tbl_element_x_link, "v_edit_link", "link_id", self.rubber_band, 10))
        self.dlg_add_element.btn_path_url.clicked.connect(partial(self._open_web_browser, self.dlg_add_element, "link"))

        # Fill combo boxes of the form and related events
        self.dlg_add_element.element_type.currentIndexChanged.connect(partial(self._filter_elementcat_id))
        self.dlg_add_element.element_type.currentIndexChanged.connect(partial(self._update_location_cmb))

        # TODO maybe all this values can be in one Json query
        # Fill combo boxes
        sql = "SELECT DISTINCT(element_type), element_type FROM cat_element ORDER BY element_type"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_add_element.element_type, rows)

        sql = "SELECT expl_id, name FROM exploitation WHERE expl_id != '0' ORDER BY name"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_add_element.expl_id, rows)

        # Set explotation vdefault for combo expl_id
        sql = "SELECT value FROM config_param_user WHERE parameter='edit_exploitation_vdefault' AND cur_user=current_user"
        row = tools_db.get_row(sql)
        if row is not None:
            tools_qt.set_combo_value(self.dlg_add_element.expl_id, row[0], 0)

        sql = "SELECT DISTINCT(id), name FROM value_state"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_add_element.state, rows)

        self._filter_state_type()

        sql = ("SELECT location_type, location_type FROM man_type_location"
               " WHERE feature_type = 'ELEMENT' "
               " ORDER BY location_type")
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_add_element.location_type, rows)
        if rows:
            tools_qt.set_combo_value(self.dlg_add_element.location_type, rows[0][0], 0)

        sql = "SELECT DISTINCT(id), id FROM cat_owner"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_add_element.ownercat_id, rows, add_empty=True)

        sql = "SELECT DISTINCT(id), id FROM cat_work"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_add_element.workcat_id, rows, add_empty=True)
        self.dlg_add_element.workcat_id.currentIndexChanged.connect(partial(
            tools_qt.set_stylesheet, self.dlg_add_element.workcat_id, None))

        sql = "SELECT DISTINCT(id), id FROM cat_work"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_add_element.workcat_id_end, rows, add_empty=True)

        sql = "SELECT id, idval FROM edit_typevalue WHERE typevalue = 'value_verified'"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_add_element.verified, rows, add_empty=True)
        self._filter_elementcat_id()

        if self.new_element_id:
            self._set_default_values()

        # Adding auto-completion to a QLineEdit for default feature
        if feature_type is None:
            feature_type = "arc"
        viewname = f"v_edit_{feature_type}"
        tools_gw.set_completer_widget(viewname, self.dlg_add_element.feature_id, str(feature_type) + "_id")

        if feature:
            self.dlg_add_element.tabWidget.currentChanged.connect(partial(
                self._fill_tbl_new_element, self.dlg_add_element, feature_type, feature[feature_type + "_id"]))

        # Set default tab 'arc'
        self.dlg_add_element.tab_feature.setCurrentIndex(0)
        self.feature_type = feature_type
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

    def get_element_dialog(self):
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
        """ Button 34: Edit element   
            Fetches form configuration, dynamically populates widgets, and opens the dialog."""

        # Define the form type and create the body
        form_type = "form_element"
        body = tools_gw.create_body(form=f'"formName":"element_manager","formType":"{form_type}"')

        # Fetch dialog configuration from the database
        json_result = tools_gw.execute_procedure('gw_fct_get_dialog', body)

        # Check for a valid result
        if not json_result or json_result.get("status") != "Accepted":
            tools_qgis.show_message(f"Failed to fetch dialog configuration: ", 2, parameter=json_result)
            return
        self.complet_result = json_result

        # Store the dialog as an instance variable to prevent garbage collection
        self.dlg_mng = GwElementManagerUi(self)
        tools_gw.load_settings(self.dlg_mng)

        # Populate the dialog with fields
        self._populate_dynamic_widgets(self.dlg_mng, json_result)
        self.load_connections(self.complet_result)

        # Open the dialog
        tools_gw.open_dialog(self.dlg_mng, dlg_name=form_type)

    def _populate_dynamic_widgets(self, dialog, complet_result):
        """Creates and populates all widgets dynamically into the dialog layout."""

        # Retrieve the tablename from the JSON response if available
        tablename = complet_result['body']['form'].get('tableName', 'default_table')
        old_widget_pos = 0
        layout_orientations = {}
        layout_list = []
        prev_layout = ""

        for layout_name, layout_info in complet_result['body']['form']['layouts'].items():
            orientation = layout_info.get('lytOrientation')
            if orientation:
                layout_orientations[layout_name] = orientation

        # Loop through fields and add them to the appropriate layouts
        for field in complet_result['body']['data']['fields']:
            # Skip hidden fields
            if field.get('hidden'):
                continue

            # Pass required parameters (dialog, result, field, tablename, class_info)
            label, widget = tools_gw.set_widgets(dialog, complet_result, field, tablename, self)

            if widget is None:
                continue

            layout = self.dlg_mng.findChild(QGridLayout, field['layoutname'])
            if layout is not None:
                orientation = layout_orientations.get(layout.objectName(), "vertical")
                layout.setProperty('lytOrientation', orientation)
                if layout.objectName() != prev_layout:
                    prev_layout = layout.objectName()
                # Take the QGridLayout with the intention of adding a QSpacerItem later
                if layout not in layout_list and layout.objectName() in ('lyt_buttons', 'lyt_element_mng_1', 'lyt_element_mng_2'):
                    layout_list.append(layout)

                if field['layoutorder'] is None:
                    message = "The field layoutorder is not configured for"
                    msg = f"formname:form_element, columnname:{field['columnname']}"
                    tools_qgis.show_message(message, 2, parameter=msg, dialog=self.dlg_mng)
                    continue

                # Populate dialog widgets using lytOrientation field
                old_widget_pos = tools_gw.add_widget_combined(self.dlg_mng, field, label, widget, old_widget_pos)

            elif field['layoutname'] != 'lyt_none':
                message = "The field layoutname is not configured for"
                msg = f"formname:form_element, columnname:{field['columnname']}"
                tools_qgis.show_message(message, 2, parameter=msg, dialog=self.dlg_mng)

            if isinstance(widget, QTableView):
                # Populate custom context menu
                widget.setContextMenuPolicy(Qt.CustomContextMenu)
                widget.customContextMenuRequested.connect(partial(tools_gw._show_context_menu, widget, dialog))

    def load_connections(self, complet_result):
        list_tables = self.dlg_mng.findChildren(QTableView)
        complet_list = []
        for table in list_tables:
            widgetname = table.objectName()
            columnname = table.property('columnname')
            if columnname is None:
                msg = f"widget {widgetname} has not columnname and cant be configured"
                tools_qgis.show_info(msg, 3)
                continue
            linkedobject = table.property('linkedobject')
            complet_list, widget_list = tools_gw.fill_tbl(complet_result, self.dlg_mng, widgetname, linkedobject, '')
            if complet_list is False:
                return False
            tools_gw.set_filter_listeners(complet_result, self.dlg_mng, widget_list, columnname, widgetname)

    # region private functions

    def _get_point_xy(self):

        self.snapper_manager.add_point(self.vertex_marker)
        self.point_xy = self.snapper_manager.point_xy

    def _set_default_values(self):
        """ Set default values """

        row = tools_gw.get_config_value("edit_elementcat_vdefault")
        if row is not None and row[0]:
            sql = f"SELECT element_type, element_type FROM cat_element WHERE id = '{row[0]}'"
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
        tools_qt.fill_combo_values(self.dlg_add_element.state_type, rows)

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
        tools_gw.set_completer_object(dialog, self.table_object, field_id='element_id')

    def _manage_element_accept(self, table_object):
        """ Insert or update table 'element'. Add element to selected feature """

        # Get values from dialog
        element_id = tools_qt.get_text(self.dlg_add_element, "element_id", return_string_null=False)
        code = tools_qt.get_text(self.dlg_add_element, "code", return_string_null=False)
        elementcat_id = tools_qt.get_combo_value(self.dlg_add_element, self.dlg_add_element.elementcat_id)
        ownercat_id = tools_qt.get_combo_value(self.dlg_add_element, self.dlg_add_element.ownercat_id)
        location_type = tools_qt.get_combo_value(self.dlg_add_element, self.dlg_add_element.location_type)
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
            tools_qgis.show_warning(message, parameter="elementcat_id", dialog=self.dlg_add_element)
            return
        num_elements = tools_qt.get_text(self.dlg_add_element, "num_elements", return_string_null=False)
        if num_elements == '':
            tools_qgis.show_warning(message, parameter="num_elements", dialog=self.dlg_add_element)
            return
        state = tools_qt.get_combo_value(self.dlg_add_element, self.dlg_add_element.state)
        if state == '':
            tools_qgis.show_warning(message, parameter="state_id", dialog=self.dlg_add_element)
            return

        state_type = tools_qt.get_combo_value(self.dlg_add_element, self.dlg_add_element.state_type)
        expl_id = tools_qt.get_combo_value(self.dlg_add_element, self.dlg_add_element.expl_id)

        # Get SRID
        srid = lib_vars.data_epsg

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
                       ", location_type, workcat_id, workcat_id_end, verified, the_geom, code)")
                sql_values = (f" VALUES ('{elementcat_id}', '{num_elements}', '{state}', '{state_type}', "
                              f"'{expl_id}', '{rotation}', $${comment}$$, $${observ}$$, "
                              f"$${link}$$, '{undelete}'")
            else:
                sql = ("INSERT INTO v_edit_element (element_id, elementcat_id, num_elements, state, state_type"
                       ", expl_id, rotation, comment, observ, link, undelete, builtdate, enddate, ownercat_id"
                       ", location_type, workcat_id, workcat_id_end, verified, the_geom, code)")

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
            sql = (f"UPDATE v_edit_element"
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
        if global_vars.project_type == 'ud':
            sql += (f"\nDELETE FROM element_x_gully"
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
        if self.list_ids['link']:
            for feature_id in self.list_ids['link']:
                sql += (f"\nINSERT INTO element_x_link (element_id, link_id)"
                        f" VALUES ('{element_id}', '{feature_id}');")
        if self.list_ids['gully']:
            for feature_id in self.list_ids['gully']:
                sql += (f"\nINSERT INTO element_x_gully (element_id, gully_id)"
                        f" VALUES ('{element_id}', '{feature_id}');")
        status = tools_db.execute_sql(sql)
        if status:
            self.element_id = element_id
            self.layers = tools_gw.manage_close(self.dlg_add_element, table_object, layers=self.layers)
            # Refresh canvas
            tools_qgis.refresh_map_canvas()

    def _filter_elementcat_id(self):
        """ Filter QComboBox @elementcat_id according QComboBox @element_type """

        element_type = tools_qt.get_combo_value(self.dlg_add_element, self.dlg_add_element.element_type, 1)
        sql = (f"SELECT DISTINCT(id), id FROM cat_element"
               f" WHERE element_type = '{element_type}'"
               f" ORDER BY id")
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_add_element.elementcat_id, rows)

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

        if button is not None and type(button) is QPushButton:
            if is_valid is False:
                button.setEnabled(False)
            else:
                button.setEnabled(True)

    def _fill_dialog_element(self, dialog, table_object, single_tool_mode=None):

        # Reset list of selected records
        self.ids, self.list_ids = tools_gw.reset_feature_list()

        list_feature_type = ['arc', 'node', 'connec', 'element', 'link']
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
            widgets = ["elementcat_id", "state", "expl_id", "ownercat_id", "location_type",
                       "workcat_id", "workcat_id_end", "comment", "observ", "path", "rotation", "verified",
                       "num_elements"]
            for widget_name in widgets:
                tools_qt.set_widget_text(dialog, widget_name, "")

            self._set_combo_from_param_user(dialog, 'state', 'value_state', 'edit_state_vdefault', field_name='name')
            self._set_combo_from_param_user(dialog, 'expl_id', 'exploitation', 'edit_exploitation_vdefault',
                                           field_id='expl_id', field_name='name')

            builtdate = tools_gw.get_config_value('edit_builtdate_vdefault')
            if builtdate:
                self.dlg_add_element.builtdate.setText(builtdate[0].replace('/', '-'))
            enddate = tools_gw.get_config_value('edit_enddate_vdefault')
            if enddate:
                self.dlg_add_element.enddate.setText(enddate[0].replace('/', '-'))
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
        sql = (f"SELECT element_type FROM cat_element"
               f" WHERE id = '{row['elementcat_id']}'")
        row_type = tools_db.get_row(sql)
        if row_type:
            tools_qt.set_widget_text(dialog, "element_type", f"{row_type[0]}")

        # Fill input widgets with data of the @row
        cmb_widgets = ["elementcat_id", "state", "state_type", "expl_id", "ownercat_id", "location_type", "workcat_id",
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
        x1, y1, x2, y2 = None, None, None, None
        for feature_type in list_feature_type:
            tools_gw.get_rows_by_feature_type(self, dialog, table_object, feature_type)
            try:
                layer = self.layers[feature_type][0]
            except Exception as e:
                continue
            extent = layer.boundingBoxOfSelected()
            if extent.xMinimum() == 0 and extent.xMaximum() == 0:
                continue
            # If this is the first iteration, set the initial extent
            if x1 is None:
                x1, y1, x2, y2 = extent.xMinimum(), extent.yMinimum(), extent.xMaximum(), extent.yMaximum()
            else:
                # Update the extent to include the bounding box of the current layer
                x1 = min(x1, extent.xMinimum())
                y1 = min(y1, extent.yMinimum())
                x2 = max(x2, extent.xMaximum())
                y2 = max(y2, extent.yMaximum())
        if None in (x1, y1, x2, y2):
            return
        tools_qgis.zoom_to_rectangle(x1, y1, x2, y2)

    def _set_combo_from_param_user(self, dialog, widget, table_name, parameter, field_id='id', field_name='id'):
        """ Executes query and set combo box """

        sql = (f"SELECT t1.{field_name} FROM {table_name} as t1"
               f" INNER JOIN config_param_user as t2 ON t1.{field_id}::text = t2.value::text"
               f" WHERE parameter = '{parameter}' AND cur_user = current_user")
        row = tools_db.get_row(sql)
        if row:
            tools_qt.set_widget_text(dialog, widget, row[0])

    def _open_web_browser(self, dialog, widget=None):
        """ Display url using the default browser """

        if widget is not None:
            url = tools_qt.get_text(dialog, widget)
            if url == 'null':
                url = 'http://www.giswater.org'
        else:
            url = 'http://www.giswater.org'

        webbrowser.open(url)

    # endregion
