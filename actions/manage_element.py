"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-

from PyQt4.QtCore import Qt       

import os
import sys
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater

from ui.add_element import AddElement                 
from ui.element_management import ElementManagement   
from actions.parent_manage import ParentManage


class ManageElement(ParentManage):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control 'Add element' of toolbar 'edit' """
        ParentManage.__init__(self, iface, settings, controller, plugin_dir)
        
         
    def manage_element(self):
        """ Button 33: Add element """
        
        # Create the dialog and signals
        self.dlg = AddElement()
        utils_giswater.setDialog(self.dlg)
        self.element_id = None        

        # Capture the current layer to return it at the end of the operation
        cur_active_layer = self.iface.activeLayer()
        
        self.set_selectionbehavior(self.dlg)
        
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
            self.dlg.tab_feature.removeTab(3)   
        else:
            self.layers['gully'] = self.controller.get_group_layers('gully')            
                            
        # Set icons
        self.set_icon(self.dlg.add_geom, "133")
        self.set_icon(self.dlg.btn_insert, "111")
        self.set_icon(self.dlg.btn_delete, "112")
        self.set_icon(self.dlg.btn_snapping, "137")

        # Remove all previous selections
        self.remove_selection(True)        

        # Manage i18n of the form
        #self.controller.translate_form(self.dlg, 'element')     
                        
        # Fill combo boxes
        self.populate_combo("elementcat_id", "cat_element")
        self.populate_combo("state", "value_state", "name")
        self.populate_combo("expl_id", "exploitation", "name")
        self.populate_combo("location_type", "man_type_location", field_name='location_type')
        self.populate_combo("workcat_id", "cat_work")
        self.populate_combo("buildercat_id", "cat_builder")
        self.populate_combo("ownercat_id", "cat_owner")
        self.populate_combo("verified", "value_verified")
        self.populate_combo("workcat_id_end", "cat_work")

        # Set combo boxes
        self.set_combo('elementcat_id', 'cat_element', 'elementcat_vdefault', field_id='id', field_name='id')
        self.set_combo('state', 'value_state', 'state_vdefault', field_name='name')
        self.set_combo('expl_id', 'exploitation', 'exploitation_vdefault', field_id='expl_id', field_name='name')
        self.set_combo('workcat_id', 'cat_work', 'workcat_vdefault', field_id='id', field_name='id')
        self.set_combo('verified', 'value_verified', 'verified_vdefault', field_id='id', field_name='id')



        # Adding auto-completion to a QLineEdit
        table_object = "element"        
        self.set_completer_object(table_object)
        
        # Set signals
        self.dlg.btn_accept.pressed.connect(self.manage_element_accept)        
        self.dlg.btn_cancel.pressed.connect(partial(self.manage_close, table_object, cur_active_layer))
        self.dlg.rejected.connect(partial(self.manage_close, table_object, cur_active_layer))        
        self.dlg.tab_feature.currentChanged.connect(partial(self.tab_feature_changed, table_object))        
        self.dlg.element_id.textChanged.connect(partial(self.exist_object, table_object)) 
        self.dlg.btn_insert.pressed.connect(partial(self.insert_feature, table_object))              
        self.dlg.btn_delete.pressed.connect(partial(self.delete_records, table_object))
        self.dlg.btn_snapping.pressed.connect(partial(self.selection_init, table_object))        
        self.dlg.add_geom.pressed.connect(self.add_point)
        
        # Adding auto-completion to a QLineEdit for default feature
        geom_type = "node"
        viewname = "v_edit_" + geom_type
        self.set_completer_feature_id(geom_type, viewname)
        
        # Set default tab 'arc'
        self.dlg.tab_feature.setCurrentIndex(0)
        self.geom_type = "arc"
        self.tab_feature_changed(table_object)        
        
        # Open the dialog     
        self.dlg.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg.open()
        return self.dlg
    
 
    def manage_element_accept(self, table_object="element"):
        """ Insert or update table 'element'. Add element to selected feature """

        # Get values from dialog
        element_id = utils_giswater.getWidgetText("element_id", return_string_null=False)
        elementcat_id = utils_giswater.getWidgetText("elementcat_id", return_string_null=False)
        ownercat_id = utils_giswater.getWidgetText("ownercat_id", return_string_null=False)
        location_type = utils_giswater.getWidgetText("location_type", return_string_null=False)
        buildercat_id = utils_giswater.getWidgetText("buildercat_id", return_string_null=False)
        workcat_id = utils_giswater.getWidgetText("workcat_id", return_string_null=False)
        workcat_id_end = utils_giswater.getWidgetText("workcat_id_end", return_string_null=False)
        comment = utils_giswater.getWidgetText("comment", return_string_null=False)
        observ = utils_giswater.getWidgetText("observ", return_string_null=False)
        link = utils_giswater.getWidgetText("link", return_string_null=False)
        verified = utils_giswater.getWidgetText("verified", return_string_null=False)
        rotation = utils_giswater.getWidgetText("rotation")
        if rotation == 0 or rotation is None or rotation == 'null':
            rotation = '0'
        builtdate = self.dlg.builtdate.dateTime().toString('yyyy-MM-dd')
        enddate = self.dlg.enddate.dateTime().toString('yyyy-MM-dd')
        undelete = self.dlg.undelete.isChecked()

        # Check mandatory fields
        message = "You need to insert value for field"
        if elementcat_id == '':
            self.controller.show_warning(message, parameter="elementcat_id")
            return
        state_value = utils_giswater.getWidgetText('state', return_string_null=False)
        if state_value == '':
            self.controller.show_warning(message, parameter="state_id")
            return            
        expl_value = utils_giswater.getWidgetText('expl_id', return_string_null=False) 
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
               " FROM " + self.schema_name + "." + table_object + ""
               " WHERE element_id = '" + element_id + "'")
        row = self.controller.get_row(sql, log_info=False)
        
        # If object already exist perform an UPDATE
        if row:
            message = "Are you sure you want to update the data?"
            answer = self.controller.ask_question(message)
            if not answer:
                return
            sql = ("UPDATE " + self.schema_name + ".element"
                   " SET elementcat_id = '" + str(elementcat_id) + "', state = '" + str(state) + "'" 
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
                sql += ", the_geom = ST_SetSRID(ST_MakePoint(" + str(self.x) + "," + str(self.y) + "), " + str(srid) + ")"
                
            sql += " WHERE element_id = '" + str(element_id) + "';"

        # If object not exist perform an INSERT
        else:
            self.controller.log_info(str(element_id))
            if element_id == '':
                sql = ("INSERT INTO " + self.schema_name + ".element (elementcat_id, state"
                       ", expl_id, rotation, comment, observ, link, undelete, enddate, builtdate"
                       ", ownercat_id, location_type, buildercat_id, workcat_id, workcat_id_end, verified, the_geom)")
                sql_values = (" VALUES ('" + str(elementcat_id) + "', '" + str(state) + "', '"
                              + str(expl_id) + "', '" + str(rotation) + "', '" + str(comment) + "', '" + str(observ) + "', '"
                              + str(link) + "', '" + str(undelete) + "', '" + str(enddate) + "', '" + str(builtdate) + "'")
            else:
                sql = ("INSERT INTO " + self.schema_name + ".element (element_id, elementcat_id, state"
                       ", expl_id, rotation, comment, observ, link, undelete, enddate, builtdate"
                       ", ownercat_id, location_type, buildercat_id, workcat_id, workcat_id_end, verified, the_geom)")

                sql_values = (" VALUES ('" + str(element_id) + "', '" + str(elementcat_id) + "', '" + str(state) + "', '"
                              + str(expl_id) + "', '" + str(rotation) + "', '" + str(comment) + "', '" + str(observ) + "', '"
                              + str(link) + "', '" + str(undelete) + "', '" + str(enddate) + "', '" + str(builtdate) + "'")

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
            if str(self.x) != "" :
                sql += ", ST_SetSRID(ST_MakePoint(" + str(self.x) + "," + str(self.y) + "), " + str(srid) +")"
            else:
                sql_values += ", null"

            sql_values += ");\n"
            sql += sql_values

        # Manage records in tables @table_object_x_@geom_type
        sql+= ("\nDELETE FROM " + self.schema_name + ".element_x_node"
               " WHERE element_id = '" + str(element_id) + "';")
        sql+= ("\nDELETE FROM " + self.schema_name + ".element_x_arc"
               " WHERE element_id = '" + str(element_id) + "';")
        sql+= ("\nDELETE FROM " + self.schema_name + ".element_x_connec"
               " WHERE element_id = '" + str(element_id) + "';")

        if self.list_ids['arc']:
            for feature_id in self.list_ids['arc']:
                sql+= ("\nINSERT INTO " + self.schema_name + ".element_x_arc (element_id, arc_id)"
                       " VALUES ('" + str(element_id) + "', '" + str(feature_id) + "');")
        if self.list_ids['node']:
            for feature_id in self.list_ids['node']:
                sql+= ("\nINSERT INTO " + self.schema_name + ".element_x_node (element_id, node_id)"
                       " VALUES ('" + str(element_id) + "', '" + str(feature_id) + "');")
        if self.list_ids['connec']:
            for feature_id in self.list_ids['connec']:
                sql+= ("\nINSERT INTO " + self.schema_name + ".element_x_connec (element_id, connec_id)"
                       " VALUES ('" + str(element_id) + "', '" + str(feature_id) + "');")
                
        status = self.controller.execute_sql(sql, log_sql=True)
        if status:
            self.element_id = element_id
            self.manage_close(table_object)           
      

    def edit_element(self):
        """ Button 67: Edit element """          
        
        # Create the dialog
        self.dlg_man = ElementManagement()
        utils_giswater.setDialog(self.dlg_man)
        utils_giswater.set_table_selection_behavior(self.dlg_man.tbl_element)                 
                
        # Adding auto-completion to a QLineEdit
        table_object = "element"        
        self.set_completer_object(table_object)  
                
        # Set a model with selected filter. Attach that model to selected table
        self.fill_table_object(self.dlg_man.tbl_element, self.schema_name + "." + table_object)                
        self.set_table_columns(self.dlg_man.tbl_element, table_object)        
        
        # Set dignals
        self.dlg_man.element_id.textChanged.connect(partial(self.filter_by_id, self.dlg_man.tbl_element, self.dlg_man.element_id, table_object))        
        self.dlg_man.tbl_element.doubleClicked.connect(partial(self.open_selected_object, self.dlg_man.tbl_element, table_object))
        self.dlg_man.btn_accept.pressed.connect(partial(self.open_selected_object, self.dlg_man.tbl_element, table_object))
        self.dlg_man.btn_cancel.pressed.connect(self.dlg_man.close)
        self.dlg_man.btn_delete.clicked.connect(partial(self.delete_selected_object, self.dlg_man.tbl_element, table_object))
                                        
        # Open form
        self.dlg_man.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_man.open()                
        
        