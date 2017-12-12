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
                
        # Remove 'gully' for 'WS'
        self.project_type = self.controller.get_project_type()
        if self.project_type == 'ws':
            self.dlg.tab_feature.removeTab(3)   
                            
        # Set icons
        self.set_icon(self.dlg.add_geom, "133")
        self.set_icon(self.dlg.btn_insert, "111")
        self.set_icon(self.dlg.btn_delete, "112")
        self.set_icon(self.dlg.btn_snapping, "137")

        # Manage i18n of the form
        #self.controller.translate_form(self.dlg, 'element')     
                        
        # Fill combo boxes
        self.populate_combo("elementcat_id", "cat_element")
        self.populate_combo("state", "value_state", "name")
        self.populate_combo("expl_id", "exploitation", "name")
        self.populate_combo("location_type", "man_type_location")
        self.populate_combo("workcat_id", "cat_work")
        self.populate_combo("buildercat_id", "cat_builder")
        self.populate_combo("ownercat_id", "cat_owner")
        self.populate_combo("verified", "value_verified")
        self.populate_combo("workcat_id_end", "cat_work")
        
        # Adding auto-completion to a QLineEdit
        table_object = "element"        
        self.set_completer_object(table_object)
        
        # Set signals
        self.dlg.btn_accept.pressed.connect(self.manage_element_accept)        
        self.dlg.btn_cancel.pressed.connect(partial(self.manage_close, table_object)) 
        self.dlg.tab_feature.currentChanged.connect(partial(self.tab_feature_changed, table_object))        
        self.dlg.element_id.textChanged.connect(partial(self.exist_object, table_object)) 
        self.dlg.btn_insert.pressed.connect(partial(self.insert_geom, table_object))              
        self.dlg.btn_delete.pressed.connect(partial(self.delete_records, table_object))
        self.dlg.btn_snapping.pressed.connect(partial(self.snapping_init, table_object))        
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

 
    def manage_element_accept(self, table_object="element"):
        """ Insert or update table 'element'. Add element to selected feature """

        # Get values from dialog
        element_id = utils_giswater.getWidgetText("element_id")
        elementcat_id = utils_giswater.getWidgetText("elementcat_id")
        state = utils_giswater.getWidgetText("state")
        expl_id = utils_giswater.getWidgetText("expl_id")
        ownercat_id = utils_giswater.getWidgetText("ownercat_id")
        location_type = utils_giswater.getWidgetText("location_type")
        buildercat_id = utils_giswater.getWidgetText("buildercat_id")

        workcat_id = utils_giswater.getWidgetText("workcat_id")
        workcat_id_end = utils_giswater.getWidgetText("workcat_id_end")
        #annotation = utils_giswater.getWidgetText("annotation")
        comment = utils_giswater.getWidgetText("comment")
        observ = utils_giswater.getWidgetText("observ")
        link = utils_giswater.getWidgetText("path")
        verified = utils_giswater.getWidgetText("verified")
        rotation = utils_giswater.getWidgetText("rotation")

        builtdate = self.dlg.builtdate.dateTime().toString('yyyy-MM-dd')
        enddate = self.dlg.enddate.dateTime().toString('yyyy-MM-dd')
        undelete = self.dlg.undelete.isChecked()

        if element_id == 'null':
            message = "You need to insert element_id"
            self.controller.show_warning(message)
            return
        
        # TODO: Manage state and expl_id
        if state == 'OBSOLETE':
            state = '0'
        elif state == 'ON SERVICE':
            state = '1'
        elif state == 'PLANIFIED':
            state = '2'
         
        if expl_id == 'expl_01':
            expl_id = '1'
        elif expl_id == 'expl_02':
            expl_id = '2'
        elif expl_id == 'expl_03':
            expl_id = '3'
        elif expl_id == 'expl_04':
            expl_id = '4'            
                    
        # Get SRID
        srid = self.controller.plugin_settings_value('srid')   
        
        # Check if this element already exists
        sql = ("SELECT DISTINCT(element_id)"
               " FROM " + self.schema_name + "." + table_object + ""
               " WHERE element_id = '" + element_id + "'")
        row = self.controller.get_row(sql, log_info=False)
        
        # If object already exist perform an UPDATE
        if row:
#             message = "Are you sure you want to update the data?"
#             answer = self.controller.ask_question(message)
#             if not answer:
#                 return
            sql = ("UPDATE " + self.schema_name + ".element"
                   " SET elementcat_id = '" + str(elementcat_id) + "', state = '" + str(state) + "',"
                   " location_type = '" + str(location_type) + "', workcat_id_end = '" + str(workcat_id_end) + "',"
                   " workcat_id = '" + str(workcat_id) + "', buildercat_id = '" + str(buildercat_id) + "',"
                   " ownercat_id = '" + str(ownercat_id) + "', rotation = '" + str(rotation) + "',"
                   " comment = '" + str(comment) + "', expl_id = '" + str(expl_id) + "', observ = '" + str(observ) + "',"
                   " link = '" + str(link) + "', verified = '" + str(verified) + "', undelete = '" + str(undelete) + "',"
                   " enddate = '" + str(enddate) + "', builtdate = '" + str(builtdate) + "'")
            if str(self.x) != "":
                sql += ", the_geom = ST_SetSRID(ST_MakePoint(" + str(self.x) + "," + str(self.y) + "), " + str(srid) + ")"
            sql += " WHERE element_id = '" + str(element_id) + "';"

        # If object not exist perform an INSERT
        else:

            sql = ("INSERT INTO " + self.schema_name + ".element (element_id, elementcat_id, state, location_type, "
                   " workcat_id, buildercat_id, ownercat_id, rotation, comment, expl_id, observ, link, verified, "
                   "workcat_id_end, enddate, builtdate, undelete")
            if str(self.x) != "":
                sql += ", the_geom"

            sql += ") VALUES ('" + str(element_id) + "', '" + str(elementcat_id) + "', '" + str(state) + "', '" + str(location_type) + "', '"
            sql += str(workcat_id) + "', '" + str(buildercat_id) + "', '" + str(ownercat_id) + "', '" + str(rotation) + "', '" + str(comment) + "', '"
            sql += str(expl_id) + "','" + str(observ) + "','" + str(link) + "','" + str(verified) + "','" + str(workcat_id_end) + "','" + str(enddate) + "','" + str(builtdate) + "','" + str(undelete) + "'"
            if str(self.x) != "" :
                sql += ", ST_SetSRID(ST_MakePoint(" + str(self.x) + "," + str(self.y) + "), " + str(srid) +")"
            sql += ");"

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
                
        self.controller.execute_sql(sql)
                
        self.manage_close(table_object)           
      

    def edit_element(self):
        """ Button 67: Edit element """          
        
        # Create the dialog and signals
        self.dlg = ElementManagement()
        utils_giswater.setDialog(self.dlg)
        
        # Open form
        self.dlg.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg.open()         
        
        