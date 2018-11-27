"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-   
try:
    from qgis.core import Qgis
except:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT >= 20000 and Qgis.QGIS_VERSION_INT < 29900: 
    from PyQt4.QtGui import QAbstractItemView, QTableView   
else:
    from qgis.PyQt.QtWidgets import QAbstractItemView, QTableView      
    
from functools import partial

import utils_giswater
from giswater.ui_manager import AddElement                
from giswater.ui_manager import ElementManagement
from giswater.actions.parent_manage import ParentManage


class ManageElement(ParentManage):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control 'Add element' of toolbar 'edit' """
        ParentManage.__init__(self, iface, settings, controller, plugin_dir)
        
         
    def manage_element(self, new_element_id=True, feature=None, geom_type=None):
        """ Button 33: Add element """
        self.controller.restore_info()
        self.new_element_id = new_element_id
        # Create the dialog and signals
        self.dlg_add_element = AddElement()
        self.load_settings(self.dlg_add_element)
        self.element_id = None        

        # Capture the current layer to return it at the end of the operation
        cur_active_layer = self.iface.activeLayer()
        
        self.set_selectionbehavior(self.dlg_add_element)
        
        # Get layers of every geom_type
        self.reset_lists()
        self.reset_layers()    
        self.layers['arc'] = self.controller.api_get_group_layers('arc')
        self.layers['node'] = self.controller.api_get_group_layers('node')
        self.layers['connec'] = self.controller.api_get_group_layers('connec')
        self.layers['element'] = self.controller.api_get_group_layers('element')
                
        # Remove 'gully' for 'WS'
        self.project_type = self.controller.get_project_type()
        if self.project_type == 'ws':
            self.dlg_add_element.tab_feature.removeTab(3)
        else:
            self.layers['gully'] = self.controller.api_get_group_layers('gully')
                            
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

        # Fill combo boxes of the form and related events
        self.dlg_add_element.element_type.currentIndexChanged.connect(partial(self.filter_elementcat_id))

        # Fill combo boxes
        sql = "SELECT DISTINCT(elementtype_id) FROM " + self.schema_name + ".cat_element ORDER BY elementtype_id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_add_element, "element_type", rows, False)
        self.populate_combo(self.dlg_add_element, "state", "value_state", "name")
        self.populate_combo(self.dlg_add_element, "expl_id", "exploitation", "name")
        sql = ("SELECT location_type"
               " FROM " + self.schema_name + ".man_type_location"
               " WHERE feature_type = 'ELEMENT' " 
               " ORDER BY location_type")
        rows = self.controller.get_rows(sql, commit=self.autocommit)
        utils_giswater.fillComboBox(self.dlg_add_element, "location_type", rows)
        if rows:
            utils_giswater.setCurrentIndex(self.dlg_add_element, "location_type", 0)
        self.populate_combo(self.dlg_add_element, "workcat_id", "cat_work")
        self.populate_combo(self.dlg_add_element, "buildercat_id", "cat_builder")
        self.populate_combo(self.dlg_add_element, "ownercat_id", "cat_owner")
        self.populate_combo(self.dlg_add_element, "verified", "value_verified")
        self.populate_combo(self.dlg_add_element, "workcat_id_end", "cat_work")

        # Set combo boxes
        self.set_combo(self.dlg_add_element, 'element_type', 'cat_element', 'elementtype_vdefault', field_id='elementtype_id',field_name='elementtype_id')
        self.set_combo(self.dlg_add_element, 'elementcat_id', 'cat_element', 'elementcat_vdefault', field_id='id', field_name='id')
        self.set_combo(self.dlg_add_element, 'state', 'value_state', 'state_vdefault', field_name='name')
        self.set_combo(self.dlg_add_element, 'expl_id', 'exploitation', 'exploitation_vdefault', field_id='expl_id', field_name='name')
        self.set_combo(self.dlg_add_element, 'workcat_id', 'cat_work', 'workcat_vdefault', field_id='id', field_name='id')
        self.set_combo(self.dlg_add_element, 'verified', 'value_verified', 'verified_vdefault', field_id='id', field_name='id')

        # Adding auto-completion to a QLineEdit
        table_object = "element"        
        self.set_completer_object(self.dlg_add_element, table_object)

        # Adding auto-completion to a QLineEdit for default feature
        #geom_type = "node"
        viewname = "ve_" + geom_type
        self.set_completer_feature_id(self.dlg_add_element.feature_id, geom_type, viewname)

        # Get layer element and save if is visible or not for restore when finish process
        layer_element = self.controller.get_layer_by_tablename("ve_element")
        layer_is_visible = self.controller.is_layer_visible(layer_element)

        # Set signals
        self.dlg_add_element.btn_accept.clicked.connect(partial(self.manage_element_accept, table_object))
        self.dlg_add_element.btn_accept.clicked.connect(partial(self.set_layer_visible, layer_element, layer_is_visible))
        self.dlg_add_element.btn_cancel.clicked.connect(partial(self.manage_close, self.dlg_add_element, table_object, cur_active_layer))
        self.dlg_add_element.btn_cancel.clicked.connect(partial(self.set_layer_visible, layer_element, layer_is_visible))
        self.dlg_add_element.rejected.connect(partial(self.manage_close, self.dlg_add_element, table_object, cur_active_layer))
        self.dlg_add_element.rejected.connect(partial(self.set_layer_visible, layer_element, layer_is_visible))
        self.dlg_add_element.tab_feature.currentChanged.connect(partial(self.tab_feature_changed, self.dlg_add_element, table_object))
        self.dlg_add_element.element_id.textChanged.connect(partial(self.exist_object, self.dlg_add_element, table_object))
        self.dlg_add_element.btn_insert.clicked.connect(partial(self.insert_feature, self.dlg_add_element, table_object))
        self.dlg_add_element.btn_delete.clicked.connect(partial(self.delete_records, self.dlg_add_element, table_object))
        self.dlg_add_element.btn_snapping.clicked.connect(partial(self.selection_init, self.dlg_add_element, table_object))
        self.dlg_add_element.btn_add_geom.clicked.connect(self.add_point)
        if feature:
            self.dlg_add_element.tabWidget.currentChanged.connect(partial(self.fill_tbl_new_element, self.dlg_add_element, geom_type, feature[geom_type+"_id"]))

        # Set default tab 'arc'
        self.dlg_add_element.tab_feature.setCurrentIndex(0)
        self.geom_type = "arc"
        self.tab_feature_changed(self.dlg_add_element, table_object)

        # Force layer ve_element set active True
        self.controller.set_layer_visible(layer_element)

        # If is a new element dont need set enddate
        if self.new_element_id is True:
            # Set calendars date from config_param_user
            self.set_calendars(self.dlg_add_element, 'builtdate', 'config_param_user', 'value', 'builtdate_vdefault')
            utils_giswater.setWidgetText(self.dlg_add_element, 'num_elements', '1')
            self.dlg_add_element.enddate.setEnabled(False)

        # Open the dialog    
        self.open_dialog(self.dlg_add_element, maximize_button=False)
        return self.dlg_add_element


    def set_layer_visible(self, layer, visible):
        """ Restore visible state when finish process """
        self.controller.set_layer_visible(layer, visible)


    def fill_tbl_new_element(self, dialog, geom_type, feature_id):

        widget = "tbl_element_x_" + geom_type
        widget = dialog.findChild(QTableView, widget)
        widget.setSelectionBehavior(QAbstractItemView.SelectRows)
        expr_filter = geom_type + "_id = '" + str(feature_id) + "'"
        # Set model of selected widget
        table_name = self.schema_name + ".ve_" + geom_type
        self.set_model_to_table(widget, table_name, expr_filter)

        # Adding auto-completion to a QLineEdit
        self.table_object = "element"
        self.set_completer_object(dialog, self.table_object)


    def manage_element_accept(self, table_object):
        """ Insert or update table 'element'. Add element to selected feature """

        # Get values from dialog
        element_id = utils_giswater.getWidgetText(self.dlg_add_element, "element_id", return_string_null=False)
        elementcat_id = utils_giswater.getWidgetText(self.dlg_add_element, "elementcat_id", return_string_null=False)
        ownercat_id = utils_giswater.getWidgetText(self.dlg_add_element, "ownercat_id", return_string_null=False)
        location_type = utils_giswater.getWidgetText(self.dlg_add_element, "location_type", return_string_null=False)
        buildercat_id = utils_giswater.getWidgetText(self.dlg_add_element, "buildercat_id", return_string_null=False)
        workcat_id = utils_giswater.getWidgetText(self.dlg_add_element, "workcat_id", return_string_null=False)
        workcat_id_end = utils_giswater.getWidgetText(self.dlg_add_element, "workcat_id_end", return_string_null=False)
        comment = utils_giswater.getWidgetText(self.dlg_add_element, "comment", return_string_null=False)
        observ = utils_giswater.getWidgetText(self.dlg_add_element, "observ", return_string_null=False)
        link = utils_giswater.getWidgetText(self.dlg_add_element, "link", return_string_null=False)
        verified = utils_giswater.getWidgetText(self.dlg_add_element, "verified", return_string_null=False)
        rotation = utils_giswater.getWidgetText(self.dlg_add_element, "rotation")
        if rotation == 0 or rotation is None or rotation == 'null':
            rotation = '0'
        builtdate = self.dlg_add_element.builtdate.dateTime().toString('yyyy-MM-dd')
        enddate = self.dlg_add_element.enddate.dateTime().toString('yyyy-MM-dd')
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
        state_value = utils_giswater.getWidgetText(self.dlg_add_element, 'state', return_string_null=False)
        if state_value == '':
            self.controller.show_warning(message, parameter="state_id")
            return            
        expl_value = utils_giswater.getWidgetText(self.dlg_add_element, 'expl_id', return_string_null=False)
        if expl_value == '':
            self.controller.show_warning(message, parameter="expl_id")
            return  
                    
        # Manage fields state and expl_id
        sql = ("SELECT id FROM " + self.schema_name + ".value_state"
               " WHERE name = '" + state_value + "'")
        row = self.controller.get_row(sql)
        if row:
            state = row[0]

        sql = ("SELECT expl_id FROM " + self.schema_name + ".exploitation"
               " WHERE name = '" + expl_value + "'")
        row = self.controller.get_row(sql)
        if row:
            expl_id = row[0]

        # Get SRID
        srid = self.controller.plugin_settings_value('srid')   
        
        # Check if this element already exists
        sql = ("SELECT DISTINCT(element_id)"
               " FROM " + self.schema_name + "." + str(table_object) + ""
               " WHERE element_id = '" + str(element_id) + "'")
        row = self.controller.get_row(sql, log_info=False, log_sql=True)


        if row is None:
            # If object not exist perform an INSERT
            if element_id == '':
                sql = ("INSERT INTO " + self.schema_name + ".element (elementcat_id, num_elements, state"
                       ", expl_id, rotation, comment, observ, link, undelete, builtdate"
                       ", ownercat_id, location_type, buildercat_id, workcat_id, workcat_id_end, verified, the_geom)")
                sql_values = (" VALUES ('" + str(elementcat_id) +"', '" + str(num_elements) + "', '" + str(state) + "', '"
                              + str(expl_id) + "', '" + str(rotation) + "', '" + str(comment) + "', '" + str(observ) + "', '"
                              + str(link) + "', '" + str(undelete) + "', '" + str(builtdate) + "'")
            else:
                sql = ("INSERT INTO " + self.schema_name + ".element (element_id, elementcat_id, num_elements, state"
                       ", expl_id, rotation, comment, observ, link, undelete, builtdate"
                       ", ownercat_id, location_type, buildercat_id, workcat_id, workcat_id_end, verified, the_geom)")

                sql_values = (" VALUES ('" + str(element_id) + "', '" + str(elementcat_id) +"', '" + str(num_elements) + "', '" + str(state) + "', '"
                              + str(expl_id) + "', '" + str(rotation) + "', '" + str(comment) + "', '" + str(observ) + "', '"
                              + str(link) + "', '" + str(undelete) + "', '" + str(builtdate) + "'")

            if ownercat_id:
                sql_values += ", '" + str(ownercat_id) + "'"
            else:
                sql_values += ", null"
            if location_type:
                sql_values += ", '" + str(location_type) + "'"
            else:
                sql_values += ", null"
            if buildercat_id:
                sql_values += ", '" + str(buildercat_id) + "'"
            else:
                sql_values += ", null"
            if workcat_id:
                sql_values += ", '" + str(workcat_id) + "'"
            else:
                sql_values += ", null"
            if workcat_id_end:
                sql_values += ", '" + str(workcat_id_end) + "'"
            else:
                sql_values += ", null"
            if verified:
                sql_values += ", '" + str(verified) + "'"
            else:
                sql_values += ", null"
            if str(self.x) != "":
                sql_values += ", ST_SetSRID(ST_MakePoint(" + str(self.x) + "," + str(self.y) + "), " + str(srid) +")"
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
            sql = ("UPDATE " + self.schema_name + ".element"
                   " SET elementcat_id = '" + str(elementcat_id) + "', num_elements = '" + str(num_elements) + "', state = '" + str(state) + "'"
                   ", expl_id = '" + str(expl_id) + "', rotation = '" + str(rotation) + "'"
                   ", comment = '" + str(comment) + "', observ = '" + str(observ) + "'"
                   ", link = '" + str(link) + "', undelete = '" + str(undelete) + "'"
                   ", enddate = '" + str(enddate) + "', builtdate = '" + str(builtdate) + "'")
            if ownercat_id:
                sql += ", ownercat_id = '" + str(ownercat_id) + "'"
            else:
                sql += ", ownercat_id = null"
            if location_type:
                sql += ", location_type = '" + str(location_type) + "'"
            else:
                sql += ", location_type = null"
            if buildercat_id:
                sql += ", buildercat_id = '" + str(buildercat_id) + "'"
            else:
                sql += ", buildercat_id = null"
            if workcat_id:
                sql += ", workcat_id = '" + str(workcat_id) + "'"
            else:
                sql += ", workcat_id = null"
            if workcat_id_end:
                sql += ", workcat_id_end = '" + str(workcat_id_end) + "'"
            else:
                sql += ", workcat_id_end = null"
            if verified:
                sql += ", verified = '" + str(verified) + "'"
            else:
                sql += ", verified = null"
            if str(self.x) != "":
                sql += ", the_geom = ST_SetSRID(ST_MakePoint(" + str(self.x) + "," + str(self.y) + "), " + str(
                    srid) + ")"

            sql += " WHERE element_id = '" + str(element_id) + "';"
            
        # Manage records in tables @table_object_x_@geom_type
        sql+= ("\nDELETE FROM " + self.schema_name + ".element_x_node"
               " WHERE element_id = '" + str(element_id) + "';")
        sql+= ("\nDELETE FROM " + self.schema_name + ".element_x_arc"
               " WHERE element_id = '" + str(element_id) + "';")
        sql+= ("\nDELETE FROM " + self.schema_name + ".element_x_connec"
               " WHERE element_id = '" + str(element_id) + "';")

        if self.list_ids['arc']:
            for feature_id in self.list_ids['arc']:
                sql += ("\nINSERT INTO " + self.schema_name + ".element_x_arc (element_id, arc_id)"
                       " VALUES ('" + str(element_id) + "', '" + str(feature_id) + "');")
        if self.list_ids['node']:
            for feature_id in self.list_ids['node']:
                sql+= ("\nINSERT INTO " + self.schema_name + ".element_x_node (element_id, node_id)"
                       " VALUES ('" + str(element_id) + "', '" + str(feature_id) + "');")
        if self.list_ids['connec']:
            for feature_id in self.list_ids['connec']:
                sql += ("\nINSERT INTO " + self.schema_name + ".element_x_connec (element_id, connec_id)"
                       " VALUES ('" + str(element_id) + "', '" + str(feature_id) + "');")
                
        status = self.controller.execute_sql(sql, log_sql=True)
        if status:
            self.element_id = element_id
            self.manage_close(self.dlg_add_element, table_object)
            # TODO Reload table tbl_element
            # filter_ = "node_id = '" + str(feature_id) + "'"
            # table_element = "ve_ui_element_x_node"
            # self.set_model_to_table(self.tbl_element, table_element, filter_)

    def filter_elementcat_id(self):
        """ Filter QComboBox @elementcat_id according QComboBox @elementtype_id """
        
        sql = ("SELECT DISTINCT(id) FROM " + self.schema_name + ".cat_element"
               " WHERE elementtype_id = '" + utils_giswater.getWidgetText(self.dlg_add_element, "element_type") + "'")
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_add_element, "elementcat_id", rows, False)


    def edit_element(self):
        """ Button 67: Edit element """
        self.controller.restore_info()
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
        
        