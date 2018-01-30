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

from ui.add_doc import AddDoc                           
from ui.doc_management import DocManagement                      
from actions.parent_manage import ParentManage


class ManageDocument(ParentManage):

    def __init__(self, iface, settings, controller, plugin_dir, single_tool=True):
        """ Class to control action 'Add document' of toolbar 'edit' """
        ParentManage.__init__(self, iface, settings, controller, plugin_dir) 

        # parameter to set if the document manager is working as
        # single tool or integrated in another tool
        self.single_tool_mode = single_tool


    def edit_add_file(self):
        self.manage_document()
                

    def manage_document(self):
        """ Button 34: Add document """

        # Create the dialog and signals
        self.dlg = AddDoc()
        utils_giswater.setDialog(self.dlg)

        # Capture the current layer to return it at the end of the operation
        cur_active_layer = self.iface.activeLayer()

        self.set_selectionbehavior(self.dlg)
        
        # Get layers of every geom_type
        self.reset_lists()
        self.reset_layers ()       
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
        
        # Remove all previous selections
        if self.single_tool_mode:
            self.remove_selection(True)
        
        # Set icons
        self.set_icon(self.dlg.btn_insert, "111")
        self.set_icon(self.dlg.btn_delete, "112")
        self.set_icon(self.dlg.btn_snapping, "137")

        # Manage i18n of the form
        #self.controller.translate_form(self.dlg, 'file')
                
        # Fill combo boxes
        self.populate_combo("doc_type", "doc_type")

        # Adding auto-completion to a QLineEdit
        table_object = "doc"        
        self.set_completer_object(table_object)

        # Set signals
        self.dlg.path_url.clicked.connect(partial(self.open_web_browser, "path"))
        self.dlg.path_doc.clicked.connect(partial(self.get_file_dialog, "path"))
        self.dlg.btn_accept.pressed.connect(self.manage_document_accept)
        self.dlg.btn_cancel.pressed.connect(partial(self.manage_close, table_object, cur_active_layer))
        self.dlg.rejected.connect(partial(self.manage_close, table_object, cur_active_layer))        
        self.dlg.tab_feature.currentChanged.connect(partial(self.tab_feature_changed, table_object))
        self.dlg.doc_id.textChanged.connect(partial(self.exist_object, table_object)) 
        self.dlg.btn_insert.pressed.connect(partial(self.insert_feature, table_object))              
        self.dlg.btn_delete.pressed.connect(partial(self.delete_records, table_object))
        self.dlg.btn_snapping.pressed.connect(partial(self.selection_init, table_object))
                
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
               

    def manage_document_accept(self, table_object="doc"):
        """ Insert or update table 'document'. Add document to selected feature """

        # Get values from dialog
        doc_id = utils_giswater.getWidgetText("doc_id")
        doc_type = utils_giswater.getWidgetText("doc_type")
        observ = utils_giswater.getWidgetText("observ")
        path = utils_giswater.getWidgetText("path")

        if doc_id == 'null':
            message = "You need to insert doc_id"
            self.controller.show_warning(message)
            return
        if doc_type == 'null':
            message = "You need to insert doc_type"
            self.controller.show_warning(message)
            return

        # Check if this document already exists
        sql = ("SELECT DISTINCT(id)"
               " FROM " + self.schema_name + "." + table_object + ""
               " WHERE id = '" + doc_id + "'")
        row = self.controller.get_row(sql, log_info=False)
        
        # If document already exist perform an UPDATE
        if row:
            message = "Are you sure you want to update the data?"
            answer = self.controller.ask_question(message)
            if not answer:
                return
            sql = ("UPDATE " + self.schema_name + ".doc "
                   " SET doc_type = '" + doc_type + "', observ = '" + observ + "', path = '" + path + "'"
                   " WHERE id = '" + doc_id + "';")

        # If document not exist perform an INSERT
        else:
            sql = ("INSERT INTO " + self.schema_name + ".doc (id, doc_type, path, observ)"
                   " VALUES ('" + doc_id + "', '" + doc_type + "', '" + path + "', '" + observ + "');")

        # Manage records in tables @table_object_x_@geom_type
        sql+= ("\nDELETE FROM " + self.schema_name + ".doc_x_node"
               " WHERE doc_id = '" + str(doc_id) + "';")
        sql+= ("\nDELETE FROM " + self.schema_name + ".doc_x_arc"
               " WHERE doc_id = '" + str(doc_id) + "';")
        sql+= ("\nDELETE FROM " + self.schema_name + ".doc_x_connec"
               " WHERE doc_id = '" + str(doc_id) + "';")
        if self.project_type == 'ud':        
            sql+= ("\nDELETE FROM " + self.schema_name + ".doc_x_gully"
                   " WHERE doc_id = '" + str(doc_id) + "';")        

        if self.list_ids['arc']:
            for feature_id in self.list_ids['arc']:
                sql+= ("\nINSERT INTO " + self.schema_name + ".doc_x_arc (doc_id, arc_id)"
                       " VALUES ('" + str(doc_id) + "', '" + str(feature_id) + "');")
        if self.list_ids['node']:
            for feature_id in self.list_ids['node']:
                sql+= ("\nINSERT INTO " + self.schema_name + ".doc_x_node (doc_id, node_id)"
                       " VALUES ('" + str(doc_id) + "', '" + str(feature_id) + "');")
        if self.list_ids['connec']:
            for feature_id in self.list_ids['connec']:
                sql+= ("\nINSERT INTO " + self.schema_name + ".doc_x_connec (doc_id, connec_id)"
                       " VALUES ('" + str(doc_id) + "', '" + str(feature_id) + "');")
        if self.project_type == 'ud' and self.list_ids['gully']:
            for feature_id in self.list_ids['gully']:
                sql+= ("\nINSERT INTO " + self.schema_name + ".doc_x_gully (doc_id, gully_id)"
                       " VALUES ('" + str(doc_id) + "', '" + str(feature_id) + "');")                
                
        status = self.controller.execute_sql(sql)
        if status:
            self.manage_close(table_object)     
            
            
    def edit_document(self):
        """ Button 66: Edit document """ 
        
        # Create the dialog
        self.dlg_man = DocManagement()
        utils_giswater.setDialog(self.dlg_man)
        utils_giswater.set_table_selection_behavior(self.dlg_man.tbl_document)         
                
        # Adding auto-completion to a QLineEdit
        table_object = "doc"        
        self.set_completer_object(table_object)
                
        # Set a model with selected filter. Attach that model to selected table
        self.fill_table_object(self.dlg_man.tbl_document, self.schema_name + "." + table_object)                
        self.set_table_columns(self.dlg_man.tbl_document, table_object)        
        
        # Set dignals
        self.dlg_man.doc_id.textChanged.connect(partial(self.filter_by_id, self.dlg_man.tbl_document, self.dlg_man.doc_id, table_object))        
        self.dlg_man.tbl_document.doubleClicked.connect(partial(self.open_selected_object, self.dlg_man.tbl_document, table_object))
        self.dlg_man.btn_accept.pressed.connect(partial(self.open_selected_object, self.dlg_man.tbl_document, table_object))
        self.dlg_man.btn_cancel.pressed.connect(self.dlg_man.close)
        self.dlg_man.btn_delete.clicked.connect(partial(self.delete_selected_object, self.dlg_man.tbl_document, table_object))
                                
        # Open form
        self.dlg_man.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_man.open()  
        
                    