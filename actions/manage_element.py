"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from qgis.PyQt.QtWidgets import QAbstractItemView, QTableView

from .. import utils_giswater
from ..ui_manager import ElementUi
from ..ui_manager import ElementManagement
from .parent_manage import ParentManage


class ManageElement(ParentManage):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control 'Add element' of toolbar 'edit' """
        ParentManage.__init__(self, iface, settings, controller, plugin_dir)
        
         
    def manage_element(self, new_element_id=True, feature=None, geom_type=None):
        """ Button 33: Add element """

        self.new_element_id = new_element_id

        # Create the dialog and signals
        self.dlg_add_element = ElementUi()
        self.load_settings(self.dlg_add_element)
        self.element_id = None

        # Capture the current layer to return it at the end of the operation
        cur_active_layer = self.iface.activeLayer()
        
        self.set_selectionbehavior(self.dlg_add_element)
        
        # Get layers of every geom_type
        self.reset_lists()
        self.reset_layers()    
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
        self.set_icon(self.dlg_add_element.btn_add_geom, "133")
        self.set_icon(self.dlg_add_element.btn_insert, "111")
        self.set_icon(self.dlg_add_element.btn_delete, "112")
        self.set_icon(self.dlg_add_element.btn_snapping, "137")

        # Remove all previous selections
        self.remove_selection(True)
        if feature:
            layer = self.iface.activeLayer()
            layer.selectByIds([feature.id()])
        # TODO pending translation
        # Manage i18n of the form
        # self.controller.translate_form(self.dlg, 'element')

        utils_giswater.set_regexp_date_validator(self.dlg_add_element.builtdate, self.dlg_add_element.btn_accept, 1)

        # Get layer element and save if is visible or not for restore when finish process
        layer_element = self.controller.get_layer_by_tablename("v_edit_element")
        layer_is_visible = False
        if layer_element:
            layer_is_visible = self.controller.is_layer_visible(layer_element)

        # Adding auto-completion to a QLineEdit
        table_object = "element"
        self.set_completer_object(self.dlg_add_element, table_object)

        # Set signals
        self.dlg_add_element.btn_accept.clicked.connect(partial(self.manage_element_accept, table_object))
        self.dlg_add_element.btn_accept.clicked.connect(
            partial(self.controller.set_layer_visible, layer_element, layer_is_visible))
        self.dlg_add_element.btn_cancel.clicked.connect(
            partial(self.manage_close, self.dlg_add_element, table_object, cur_active_layer, excluded_layers=[]))
        self.dlg_add_element.btn_cancel.clicked.connect(
            partial(self.controller.set_layer_visible, layer_element, layer_is_visible))
        self.dlg_add_element.rejected.connect(
            partial(self.manage_close, self.dlg_add_element, table_object, cur_active_layer, excluded_layers=[]))
        self.dlg_add_element.rejected.connect(
            partial(self.controller.set_layer_visible, layer_element, layer_is_visible))
        self.dlg_add_element.tab_feature.currentChanged.connect(
            partial(self.tab_feature_changed, self.dlg_add_element, table_object, []))
        self.dlg_add_element.element_id.textChanged.connect(
            partial(self.exist_object, self.dlg_add_element, table_object))
        self.dlg_add_element.btn_insert.clicked.connect(
            partial(self.insert_feature, self.dlg_add_element, table_object))
        self.dlg_add_element.btn_delete.clicked.connect(
            partial(self.delete_records, self.dlg_add_element, table_object))
        self.dlg_add_element.btn_snapping.clicked.connect(
            partial(self.selection_init, self.dlg_add_element, table_object))
        self.dlg_add_element.btn_add_geom.clicked.connect(self.add_point)
        self.dlg_add_element.state.currentIndexChanged.connect(partial(self.filter_state_type))

        # Fill combo boxes of the form and related events
        self.dlg_add_element.element_type.currentIndexChanged.connect(partial(self.filter_elementcat_id))
        self.dlg_add_element.element_type.currentIndexChanged.connect(partial(self.update_location_cmb))
        # TODO maybe all this values can be in one Json query
        # Fill combo boxes
        sql = "SELECT DISTINCT(elementtype_id), elementtype_id FROM cat_element ORDER BY elementtype_id"
        rows = self.controller.get_rows(sql)
        utils_giswater.set_item_data(self.dlg_add_element.element_type, rows, 1)

        sql = "SELECT expl_id, name FROM exploitation WHERE expl_id != '0' ORDER BY name"
        rows = self.controller.get_rows(sql)
        utils_giswater.set_item_data(self.dlg_add_element.expl_id, rows, 1)

        sql = "SELECT DISTINCT(id), name FROM value_state"
        rows = self.controller.get_rows(sql)
        utils_giswater.set_item_data(self.dlg_add_element.state, rows, 1)

        self.filter_state_type()

        sql = ("SELECT location_type, location_type FROM man_type_location"
               " WHERE feature_type = 'ELEMENT' "
               " ORDER BY location_type")
        rows = self.controller.get_rows(sql, commit=self.autocommit)
        utils_giswater.set_item_data(self.dlg_add_element.location_type, rows, 1)

        if rows:
            utils_giswater.set_combo_itemData(self.dlg_add_element.location_type, rows[0][0], 0)


        sql = "SELECT DISTINCT(id), id FROM cat_owner"
        rows = self.controller.get_rows(sql)
        utils_giswater.set_item_data(self.dlg_add_element.ownercat_id, rows, 1, add_empty=True)

        sql = "SELECT DISTINCT(id), id FROM cat_builder"
        rows = self.controller.get_rows(sql)
        utils_giswater.set_item_data(self.dlg_add_element.buildercat_id, rows, 1, add_empty=True)

        sql = "SELECT DISTINCT(id), id FROM cat_work"
        rows = self.controller.get_rows(sql)
        utils_giswater.set_item_data(self.dlg_add_element.workcat_id, rows, 1, add_empty=True)

        sql = "SELECT DISTINCT(id), id FROM cat_work"
        rows = self.controller.get_rows(sql)
        utils_giswater.set_item_data(self.dlg_add_element.workcat_id_end, rows, 1, add_empty=True)

        sql = "SELECT DISTINCT(id), id FROM value_verified"
        rows = self.controller.get_rows(sql)
        utils_giswater.set_item_data(self.dlg_add_element.verified, rows, 1, add_empty=True)
        self.filter_elementcat_id()

        if self.new_element_id:
            # Set default values
            elementtype_vdef = self.controller.get_config('elementcat_vdefault')[0]
            utils_giswater.set_combo_itemData(self.dlg_add_element.element_type, elementtype_vdef, 0)

            elementcat_vdef = self.controller.get_config('elementcat_vdefault')[0]
            utils_giswater.set_combo_itemData(self.dlg_add_element.elementcat_id, elementcat_vdef, 0)

            state_vdef = self.controller.get_config('state_vdefault')[0]
            utils_giswater.set_combo_itemData(self.dlg_add_element.state, state_vdef, 0)

            statetype_vdef = self.controller.get_config('statetype_1_vdefault')[0]
            utils_giswater.set_combo_itemData(self.dlg_add_element.state_type, statetype_vdef, 0)

            owner_vdef = self.controller.get_config('ownercat_vdefault')[0]
            utils_giswater.set_combo_itemData(self.dlg_add_element.ownercat_id, owner_vdef, 0)

            builtdate_vdef = self.controller.get_config('builtdate_vdefault')[0]
            utils_giswater.setWidgetText(self.dlg_add_element, self.dlg_add_element.builtdate, builtdate_vdef)

            workcat_vdef = self.controller.get_config('workcat_vdefault')[0]
            utils_giswater.set_combo_itemData(self.dlg_add_element.workcat_id, workcat_vdef, 0)

            workcatend_vdef = self.controller.get_config('workcat_id_end_vdefault')[0]
            utils_giswater.set_combo_itemData(self.dlg_add_element.workcat_id_end, workcatend_vdef, 0)

            verified_vdef = self.controller.get_config('verified_vdefault')[0]
            utils_giswater.set_combo_itemData(self.dlg_add_element.verified, verified_vdef, 0)


        # Adding auto-completion to a QLineEdit for default feature
        self.set_completer_feature_id(self.dlg_add_element.feature_id, "arc", "v_edit_arc")

        if feature:
            self.dlg_add_element.tabWidget.currentChanged.connect(partial(self.fill_tbl_new_element, self.dlg_add_element, geom_type, feature[geom_type+"_id"]))

        # Set default tab 'arc'
        self.dlg_add_element.tab_feature.setCurrentIndex(0)
        self.geom_type = "arc"
        self.tab_feature_changed(self.dlg_add_element, table_object)

        # Force layer v_edit_element set active True
        if layer_element:
            self.controller.set_layer_visible(layer_element)

        # If is a new element dont need set enddate
        if self.new_element_id is True:
            utils_giswater.setWidgetText(self.dlg_add_element, 'num_elements', '1')

        self.update_location_cmb()
        if not self.new_element_id:
            self.exist_object(self.dlg_add_element, 'element')

        # Open the dialog    
        self.open_dialog(self.dlg_add_element, dlg_name='element', maximize_button=False)
        return self.dlg_add_element


    def filter_state_type(self):
        state = utils_giswater.get_item_data(self.dlg_add_element, self.dlg_add_element.state, 0)
        sql = (f"SELECT DISTINCT(id), name FROM value_state_type "
               f"WHERE state = {state}")
        rows = self.controller.get_rows(sql)
        utils_giswater.set_item_data(self.dlg_add_element.state_type, rows, 1)


    def update_location_cmb(self):

        element_type = utils_giswater.getWidgetText(self.dlg_add_element, self.dlg_add_element.element_type)
        sql = (f"SELECT location_type, location_type FROM man_type_location"
               f" WHERE feature_type = 'ELEMENT' "
               f" AND (featurecat_id = '{element_type}' OR featurecat_id is null)"
               f" ORDER BY location_type")
        rows = self.controller.get_rows(sql, log_sql=True, commit=self.autocommit)
        utils_giswater.set_item_data(self.dlg_add_element.location_type, rows, add_empty=True)
        if rows:
            utils_giswater.set_combo_itemData(self.dlg_add_element.location_type, rows[0][0], 0)


    def fill_tbl_new_element(self, dialog, geom_type, feature_id):

        widget = "tbl_element_x_" + geom_type
        widget = dialog.findChild(QTableView, widget)
        widget.setSelectionBehavior(QAbstractItemView.SelectRows)
        expr_filter = f"{geom_type}_id = '{feature_id}'"

        # Set model of selected widget
        table_name = f"{self.schema_name}.v_edit_{geom_type}"
        self.set_model_to_table(widget, table_name, expr_filter)

        # Adding auto-completion to a QLineEdit
        self.table_object = "element"
        self.set_completer_object(dialog, self.table_object)


    def manage_element_accept(self, table_object):
        """ Insert or update table 'element'. Add element to selected feature """

        # Get values from dialog
        element_id = utils_giswater.getWidgetText(self.dlg_add_element, "element_id", return_string_null=False)
        code = utils_giswater.getWidgetText(self.dlg_add_element, "code", return_string_null=False)
        elementcat_id = utils_giswater.get_item_data(self.dlg_add_element, self.dlg_add_element.elementcat_id)
        ownercat_id = utils_giswater.get_item_data(self.dlg_add_element, self.dlg_add_element.ownercat_id)
        location_type = utils_giswater.get_item_data(self.dlg_add_element, self.dlg_add_element.location_type)
        buildercat_id = utils_giswater.get_item_data(self.dlg_add_element, self.dlg_add_element.buildercat_id)
        builtdate = utils_giswater.getWidgetText(self.dlg_add_element, "builtdate", return_string_null=False)
        workcat_id = utils_giswater.get_item_data(self.dlg_add_element, self.dlg_add_element.workcat_id)
        workcat_id_end = utils_giswater.get_item_data(self.dlg_add_element, self.dlg_add_element.workcat_id_end)
        comment = utils_giswater.getWidgetText(self.dlg_add_element, "comment", return_string_null=False)
        observ = utils_giswater.getWidgetText(self.dlg_add_element, "observ", return_string_null=False)
        link = utils_giswater.getWidgetText(self.dlg_add_element, "link", return_string_null=False)
        verified = utils_giswater.get_item_data(self.dlg_add_element, self.dlg_add_element.verified)
        rotation = utils_giswater.getWidgetText(self.dlg_add_element, "rotation")
        if rotation == 0 or rotation is None or rotation == 'null':
            rotation = '0'
        undelete = self.dlg_add_element.undelete.isChecked()

        # Check mandatory fields
        message = "You need to insert value for field"
        if elementcat_id == '':
            self.controller.show_warning(message, parameter="elementcat_id")
            return
        num_elements = utils_giswater.getWidgetText(self.dlg_add_element, "num_elements", return_string_null=False)
        if num_elements == '':
            self.controller.show_warning(message, parameter="num_elements")
            return
        state = utils_giswater.get_item_data(self.dlg_add_element, self.dlg_add_element.state)
        if state == '':
            self.controller.show_warning(message, parameter="state_id")
            return            

        state_type = utils_giswater.get_item_data(self.dlg_add_element, self.dlg_add_element.state_type)
        expl_id = utils_giswater.get_item_data(self.dlg_add_element, self.dlg_add_element.expl_id)

        # Get SRID
        srid = self.controller.plugin_settings_value('srid')   
        
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
                sql_values += ", null"
            if workcat_id_end:
                sql_values += f", '{workcat_id_end}'"
            else:
                sql_values += ", null"
            if verified:
                sql_values += f", '{verified}'"
            else:
                sql_values += ", null"

            if str(self.x) != "":
                sql_values += f", ST_SetSRID(ST_MakePoint({self.x},{self.y}), {srid})"
                self.x = ""
            else:
                sql_values += ", null"
            if code:
                sql_values += f", '{code}'"
            else:
                sql_values += ", null"
            if element_id == '':
                sql += sql_values + ") RETURNING element_id;"
                new_elem_id = self.controller.execute_returning(sql, search_audit=False, log_sql=True)
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
            if str(self.x) != "":
                sql += f", the_geom = ST_SetSRID(ST_MakePoint({self.x},{self.y}), {srid})"

            sql += f" WHERE element_id = '{element_id}';"
            
        # Manage records in tables @table_object_x_@geom_type
        sql+= (f"\nDELETE FROM element_x_node"
               f" WHERE element_id = '{element_id}';")
        sql+= (f"\nDELETE FROM element_x_arc"
               f" WHERE element_id = '{element_id}';")
        sql+= (f"\nDELETE FROM element_x_connec"
               f" WHERE element_id = '{element_id}';")

        if self.list_ids['arc']:
            for feature_id in self.list_ids['arc']:
                sql += (f"\nINSERT INTO element_x_arc (element_id, arc_id)"
                        f" VALUES ('{element_id}', '{feature_id}');")
        if self.list_ids['node']:
            for feature_id in self.list_ids['node']:
                sql+= (f"\nINSERT INTO element_x_node (element_id, node_id)"
                       f" VALUES ('{element_id}', '{feature_id}');")
        if self.list_ids['connec']:
            for feature_id in self.list_ids['connec']:
                sql += (f"\nINSERT INTO element_x_connec (element_id, connec_id)"
                        f" VALUES ('{element_id}', '{feature_id}');")
                
        status = self.controller.execute_sql(sql, log_sql=True)
        if status:
            self.element_id = element_id
            self.manage_close(self.dlg_add_element, table_object, excluded_layers=[])
            # TODO Reload table tbl_element
            # filter_ = "node_id = '" + str(feature_id) + "'"
            # table_element = "v_ui_element_x_node"
            # self.set_model_to_table(self.tbl_element, table_element, filter_)


    def filter_elementcat_id(self):
        """ Filter QComboBox @elementcat_id according QComboBox @elementtype_id """
        element_type = utils_giswater.get_item_data(self.dlg_add_element, self.dlg_add_element.element_type, 1)
        sql = (f"SELECT DISTINCT(id), id FROM cat_element"
               f" WHERE elementtype_id = '{element_type}'"
               f" ORDER BY id")
        rows = self.controller.get_rows(sql, log_sql=True)
        utils_giswater.set_item_data(self.dlg_add_element.elementcat_id, rows, 1)



    def edit_element(self):
        """ Button 67: Edit element """          
        
        # Create the dialog
        self.dlg_man = ElementManagement()
        self.load_settings(self.dlg_man)
        self.dlg_man.tbl_element.setSelectionBehavior(QAbstractItemView.SelectRows)
                
        # Adding auto-completion to a QLineEdit
        table_object = "element"        
        self.set_completer_object(self.dlg_man, table_object)

        # Set a model with selected filter. Attach that model to selected table
        self.fill_table_object(self.dlg_man.tbl_element, self.schema_name + "." + table_object)                
        self.set_table_columns(self.dlg_man, self.dlg_man.tbl_element, table_object)
        
        # Set dignals
        self.dlg_man.element_id.textChanged.connect(partial(self.filter_by_id,  self.dlg_man, self.dlg_man.tbl_element, self.dlg_man.element_id, table_object))
        self.dlg_man.tbl_element.doubleClicked.connect(partial(self.open_selected_object, self.dlg_man, self.dlg_man.tbl_element, table_object))
        self.dlg_man.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_man))
        self.dlg_man.rejected.connect(partial(self.close_dialog, self.dlg_man))
        self.dlg_man.btn_delete.clicked.connect(partial(self.delete_selected_object, self.dlg_man.tbl_element, table_object))
                                        
        # Open form
        self.open_dialog(self.dlg_man)             
        
        