"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtCore import Qt
from PyQt4.QtSql import QSqlTableModel
from qgis.core import QgsFeatureRequest           

import os
import sys
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater

from ui.add_doc import AddDoc                           
from actions.parent_manage import ParentManage


class ManageDocument(ParentManage):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control action 'Add document' of toolbar 'edit' """
        ParentManage.__init__(self, iface, settings, controller, plugin_dir) 


    def edit_add_file(self):
        self.manage_document()
                

    def manage_document(self):
        """ Button 34: Add document """
                         
        self.set_layers_by_geom()  

        # Create the dialog and signals
        self.dlg = AddDoc()
        utils_giswater.setDialog(self.dlg)

        
        # Remove 'gully' for 'WS'
        self.project_type = self.controller.get_project_type()
        if self.project_type == 'ws':
            self.dlg.tab_feature.removeTab(3)        

        # Set icons
        self.set_icon(self.dlg.btn_insert, "111")
        self.set_icon(self.dlg.btn_delete, "112")
        self.set_icon(self.dlg.btn_snapping, "137")

        # Set signals
        self.dlg.btn_accept.pressed.connect(self.manage_document_accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)

        # Get widgets
        self.dlg.path_url.clicked.connect(partial(self.open_web_browser, "path"))
        self.dlg.path_doc.clicked.connect(partial(self.get_file_dialog, "path"))

        # Manage i18n of the form
        #self.controller.translate_form(self.dlg, 'file')
                
        # Fill combo boxes
        self.populate_combo("doc_type", "doc_type")

        # Adding auto-completion to a QLineEdit
        table_object = "doc"        
        self.set_completer_object(table_object)

        # Check which tab is selected        
        self.dlg.tab_feature.currentChanged.connect(partial(self.tab_feature_changed, table_object))
        self.dlg.doc_id.textChanged.connect(partial(self.exist_object, table_object)) 
                
        # Adding auto-completion to a QLineEdit for default feature
        geom_type = "node"
        viewname = "v_edit_" + geom_type
        self.set_completer_feature_id(geom_type, viewname)

        # Set default tab 'node'
        #self.geom_type = "node"
        self.dlg.tab_feature.setCurrentIndex(1)
                       
        # Set signals
        #self.dlg.btn_insert.pressed.connect(partial(self.manual_init, widget, viewname, geom_type + "_id", self.dlg, self.group_pointers_arc))
        self.dlg.btn_insert.pressed.connect(partial(self.insert_geom, table_object))              
        self.dlg.btn_delete.pressed.connect(partial(self.delete_records, table_object))
        self.dlg.btn_snapping.pressed.connect(partial(self.snapping_init, viewname))

        # Open the dialog
        self.dlg.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg.open()


    def insert_geom(self, table_object):
        """ Select feature with entered id. Set a model with selected filter.
            Attach that model to selected table 
        """

        # Clear list of ids
        self.ids = []

        field_id = self.geom_type + "_id"
        feature_id = utils_giswater.getWidgetText("feature_id")        
        if feature_id == 'null':
            message = "You need to enter a feature id"
            self.controller.show_info_box(message) 
            return

        # Iterate over all layers of the group
        for layer in self.group_pointers:
            if layer.selectedFeatureCount() > 0:
                # Get selected features of the layer
                features = layer.selectedFeatures()
                for feature in features:
                    # Append 'feature_id' into the list
                    selected_id = feature.attribute(field_id)
                    self.ids.append(str(selected_id))

        # Show message if element is already in the list
        if feature_id in self.ids:
            message = "Selected feature already in the list"
            self.controller.show_info_box(message, parameter=feature_id)
            return
        
        # If feature id doesn't exist in list -> add
        self.ids.append(feature_id)

        # Set expression filter with 'connec_list'
        expr_filter = "\"" + field_id + "\" IN ("
        for i in range(len(self.ids)):
            expr_filter += "'" + str(self.ids[i]) + "', "
        expr_filter = expr_filter[:-2] + ")"

        # Check expression
        (is_valid, expr) = self.check_expression(expr_filter, True)
        if not is_valid:
            return   

        # Reload contents of table 'tbl_doc_x_@geom_type'
        self.reload_table(table_object, self.geom_type, expr_filter)
            
        # Select features with previous filter
        for layer in self.group_pointers:
            # Build a list of feature id's and select them
            it = layer.getFeatures(QgsFeatureRequest(expr))
            id_list = [i.id() for i in it]
            layer.selectByIds(id_list)
        
        # Update list
        self.list_ids[self.geom_type] = self.ids
                

    def exist_object(self, table_object):
        """ Check if selected object (document or element) already exists """
        
        # Reset list of selected records
        self.reset_lists()
        
        field_object_id = "id"
        #object_id = self.dlg.doc_id.text()
        object_id = utils_giswater.getWidgetText(table_object + "_id")

        # Check if we already have data with selected object_id
        sql = ("SELECT * " 
            " FROM " + self.schema_name + "." + str(table_object) + ""
            " WHERE " + str(field_object_id) + " = '" + str(object_id) + "'")
        row = self.controller.get_row(sql, log_info=False)

        # If object_id not found: Clear data
        if not row:           
            utils_giswater.setWidgetText("doc_type", "")
            utils_giswater.setWidgetText("observ", "")
            utils_giswater.setWidgetText("path", "")         
            self.remove_selection()   
            self.reset_lists()       
            self.reset_model(table_object, "arc")      
            self.reset_model(table_object, "node")      
            self.reset_model(table_object, "connec")     
            return            

        # If exists, check data in relation tables of every geom_type
        utils_giswater.setWidgetText("doc_type", row['doc_type'])
        utils_giswater.setWidgetText("observ", row['observ'])
        utils_giswater.setWidgetText("path", row['path'])
            
        # Check related 'arcs'
        self.get_records_geom_type(table_object, "arc")
        
        # Check related 'nodes'
        self.get_records_geom_type(table_object, "node")
        
        # Check related 'connecs'
        self.get_records_geom_type(table_object, "connec")


    def get_records_geom_type(self, table_object, geom_type):
        """ Get records of @geom_type associated to selected @table_object """
        
        object_id = utils_giswater.getWidgetText(table_object + "_id")        
        table_relation = table_object + "_x_" + geom_type
        widget_name = "tbl_" + table_relation           
        sql = ("SELECT " + geom_type + "_id"
               " FROM " + self.schema_name + "." + table_relation + ""
               " WHERE " + table_object + "_id = '" + str(object_id) + "'")
        rows = self.controller.get_rows(sql, log_sql=True)
        if rows:
            for row in rows:
                self.list_ids[geom_type].append(str(row[0]))
                self.ids.append(str(row[0]))

            expr_filter = self.get_expr_filter(geom_type, self.group_pointers_node)
            self.set_table_model(widget_name, geom_type, expr_filter)           
        

    def delete_records(self, table_object):
        """ Delete selected elements of the table """          
                    
        widget_name = "tbl_" + table_object + "_x_" + self.geom_type
        widget = utils_giswater.getWidget(widget_name)
        if not widget:
            self.controller.show_warning("Widget not found", parameter=widget_name)
            return
        
        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_info_box(message)
            return

        self.ids = self.list_ids[self.geom_type]
        field_id = self.geom_type + "_id"
        
        del_id = []
        inf_text = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_feature = widget.model().record(row).value(field_id)
            inf_text += str(id_feature) + ", "
            list_id = list_id + "'" + str(id_feature) + "', "
            del_id.append(id_feature)
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        message = "Are you sure you want to delete these records?"
        answer = self.controller.ask_question(message, "Delete records", inf_text)
        if answer:
            for el in del_id:
                self.ids.remove(el)
                
        # Select features which are in the list
        expr_filter = "\"" + field_id + "\" IN ("
        for i in range(len(self.ids)):
            expr_filter += "'" + str(self.ids[i]) + "', "
        expr_filter = expr_filter[:-2] + ")"
        
        # Check expression
        (is_valid, expr) = self.check_expression(expr_filter, True) #@UnusedVariable
        if not is_valid:
            return           

        # Update model of the widget with selected expr_filter   
        self.reload_table(table_object, self.geom_type, expr_filter)               
        

    def reload_table(self, table_object, geom_type, expr_filter):
        """ Reload @widget with contents of @tablename applying selected @expr_filter """
                         
        widget_name = "tbl_" + table_object + "_x_" + geom_type
        widget = utils_giswater.getWidget(widget_name) 
        if not widget:
            self.controller.log_info("Widget not found", parameter=widget_name)
            return None
        
        expr = self.set_table_model(widget, geom_type, expr_filter)
        return expr
    
    
    def set_table_model(self, widget_name, geom_type, expr_filter):
        """ Sets a TableModel to @widget_name attached to 
            @table_name and filter @expr_filter 
        """
        
        # Check expression          
        (is_valid, expr) = self.check_expression(expr_filter, True)    #@UnusedVariable
        if not is_valid:
            return expr              

        # Set a model with selected filter expression
        table_name = "v_edit_" + geom_type        
        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name  
        
        # Set the model
        model = QSqlTableModel();
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.select()
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())
            return expr
        
        # Attach model to selected widget
        widget = utils_giswater.getWidget(widget_name) 
        if not widget:
            self.controller.log_info("Widget not found", parameter=widget_name)
            return expr
        
        widget.setModel(model)
        if expr_filter:
            widget.model().setFilter(expr_filter)
        widget.model().select()        
        
        return expr      
        

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

        # Check if this document already exists
        sql = ("SELECT DISTINCT(id)"
               " FROM " + self.schema_name + "." + table_object + ""
               " WHERE id = '" + doc_id + "'")
        row = self.controller.get_row(sql)
        
        # If document already exist perform an UPDATE
        if row:
#             message = "Are you sure you want to update the data?"
#             answer = self.controller.ask_question(message)
#             if not answer:
#                 return
            sql = ("UPDATE " + self.schema_name + ".doc "
                   " SET doc_type = '" + doc_type + "', "
                   " observ = '" + observ + "', path = '" + path + "'"
                   " WHERE id = '" + doc_id + "';")

        # If document not exist perform an INSERT
        else:
            sql = ("INSERT INTO " + self.schema_name + ".doc (id, doc_type, path, observ) "
                   " VALUES ('" + doc_id + "', '" + doc_type + "', '" + path + "', '" + observ +  "');")

        # Manage records in tables @table_object_x_@geom_type
        sql+= ("\nDELETE FROM " + self.schema_name + ".doc_x_node"
               " WHERE doc_id = '" + str(doc_id) + "';")
        sql+= ("\nDELETE FROM " + self.schema_name + ".doc_x_arc"
               " WHERE doc_id = '" + str(doc_id) + "';")
        sql+= ("\nDELETE FROM " + self.schema_name + ".doc_x_connec"
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
                sql+= ("INSERT INTO " + self.schema_name + ".doc_x_connec (doc_id, connec_id)"
                       " VALUES ('" + str(doc_id) + "', '" + str(feature_id) + "');")
                
        self.controller.execute_sql(sql, log_sql=True)
                                              
        self.close_dialog()


    def document_autocomplete(self):
        """ Once we select 'element_id' using autocomplete, 
            fill widgets with current values 
        """

        self.dlg.doc_id.setCompleter(self.completer)
        object_id = utils_giswater.getWidgetText("doc_id")

        # Get values from database
        sql = ("SELECT doc_type, tagcat_id, observ, path"
               " FROM " + self.schema_name + ".doc"
               " WHERE id = '" + object_id + "'")
        row = self.controller.get_row(sql)

        # Fill widgets
        columns_length = self.dao.get_columns_length()
        for i in range(0, columns_length):
            column_name = self.dao.get_column_name(i)
            utils_giswater.setWidgetText(column_name, row[column_name])
            
            