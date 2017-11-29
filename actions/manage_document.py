"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtCore import Qt
from PyQt4.QtGui import QCompleter, QTabWidget, QTableView, QStringListModel
from PyQt4.QtSql import QSqlTableModel
from qgis.core import QgsFeatureRequest, QgsExpression           

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
             
        self.controller.log_info("manage_document")  
                         
        self.set_layers_by_geom()  

        # Create the dialog and signals
        self.dlg = AddDoc()
        utils_giswater.setDialog(self.dlg)

        self.tab_feature = self.dlg.findChild(QTabWidget, "tab_feature")
        if self.project_type == 'ws':
            self.tab_feature.removeTab(3)        

        # Set icons
        self.set_icon(self.dlg.btn_insert, "111")
        self.set_icon(self.dlg.btn_delete, "112")
        self.set_icon(self.dlg.btn_snapping, "137")

        # Set signals
        self.dlg.btn_accept.pressed.connect(self.edit_add_file_accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)

        # Get widgets
        self.dlg.path_url.clicked.connect(partial(self.open_web_browser, "path"))
        self.dlg.path_doc.clicked.connect(partial(self.get_file_dialog, "path"))

        # Manage i18n of the form
        #self.controller.translate_form(self.dlg, 'file')
                
        # Fill combo boxes
        self.populate_combo("doc_type", "doc_type")

        # Adding auto-completion to a QLineEdit
        self.completer = QCompleter()
        self.dlg.doc_id.setCompleter(self.completer)

        model = QStringListModel()
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".doc"
        row = self.controller.get_rows(sql)
        for i in range(0, len(row)):
            aux = row[i]
            row[i] = str(aux[0])

        model.setStringList(row)
        self.completer.setModel(model)
        
        # Set default tab 0
        self.dlg.tab_feature.setCurrentIndex(0)

        feature = "arc"
        view = "v_edit_arc"

        # Check which tab is selected
        table = "doc"
        self.dlg.tab_feature.currentChanged.connect(partial(self.set_feature, table))
        self.dlg.doc_id.textChanged.connect(partial(self.check_doc_exist, "id", table))
        
        # Adding auto-completion to a QLineEdit for default feature
        self.init_add_element(feature, table, view)

        self.widget = self.dlg.findChild(QTableView, "tbl_doc_x_arc")
        self.dlg.btn_insert.pressed.connect(partial(self.manual_init, self.widget, view, feature + "_id", self.dlg, self.group_pointers_arc))
        self.dlg.btn_delete.pressed.connect(partial(self.delete_records, self.widget, view, feature + "_id", self.group_pointers_arc))
        self.dlg.btn_snapping.pressed.connect(partial(self.snapping_init, self.group_pointers_arc, self.group_layers_arc, feature + "_id", view))

        # Open the dialog
        self.dlg.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg.open()


    def check_doc_exist(self, attribute, table):

        id_ = self.dlg.doc_id.text()

        # Check if we already have data with selected element_id
        sql = ("SELECT DISTINCT(" + str(attribute) + ") FROM " + self.schema_name + "." + str(table) + ""
            " WHERE " + str(attribute) + " = '" + str(id_) + "'")
        row = self.controller.get_row(sql)

        if row:
            # If element exist : load data ELEMENT
            sql = "SELECT * FROM " + self.schema_name + "." + table + " WHERE " + attribute + " = '" + str(id_) + "'"
            row = self.controller.get_row(sql)

            utils_giswater.setWidgetText("doc_type", row['doc_type'])
            self.dlg.observ.setText(str(row['observ']))
            self.dlg.path.setText(str(row['path']))

            self.ids_node = []
            self.ids_arc = []
            self.ids_connec = []
            self.ids = []
            # If element exist : load data RELATIONS

            sql = "SELECT arc_id FROM " + self.schema_name + ".doc_x_arc WHERE doc_id = '" + str(id_) + "'"
            rows = self.controller.get_rows(sql)
            if rows:
                for row in rows:
                    self.ids_arc.append(str(row[0]))
                    self.ids.append(str(row[0]))

                self.manual_init_update(self.ids_arc, "arc_id", self.group_pointers_arc)
                self.reload_table_update("v_edit_arc", "arc_id", self.ids_arc, self.dlg.tbl_doc_x_arc)

            sql = "SELECT node_id FROM " + self.schema_name + ".doc_x_node WHERE doc_id = '" + str(id_) + "'"
            rows = self.controller.get_rows(sql)
            if rows:
                for row in rows:
                    self.ids_node.append(str(row[0]))
                    self.ids.append(str(row[0]))

                self.manual_init_update(self.ids_node, "node_id", self.group_pointers_node)
                self.reload_table_update("v_edit_node", "node_id", self.ids_node, self.dlg.tbl_doc_x_node)

            sql = "SELECT connec_id FROM " + self.schema_name + ".doc_x_connec WHERE doc_id = '" + str(id_) + "'"
            rows = self.controller.get_rows(sql)
            if rows:
                for row in rows:
                    self.ids_connec.append(str(row[0]))
                    self.ids.append(str(row[0]))

                self.reload_table_update("v_edit_connec", "connec_id", self.ids_connec, self.dlg.tbl_doc_x_connec)
                self.manual_init_update(self.ids_connec, "connec_id", self.group_pointers_connec)

        # If element_id not exist: Clear data
        else:
            utils_giswater.setWidgetText("doc_type", str(""))
            self.dlg.observ.setText(str(""))
            self.dlg.path.setText(str(""))
            return


    def reload_table_update(self, table, attribute, ids, widget):

        # Reload table
        table_name = self.schema_name + "." + table
        
        expr = attribute + " = '" + str(ids[0]) + "'"
        if len(ids) > 1:
            for el in range(1, len(ids)):
                expr += " OR " + str(attribute) + " = '" + str(ids[el]) + "'"

        # Set model
        model = QSqlTableModel();
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())

        # Attach model to table view
        widget.setModel(model)
        widget.model().setFilter(expr)


    def delete_records(self, widget, tablename, feature_id, group_pointers):
        """ Delete selected elements of the table """          
                    
        tab_position = self.dlg.tab_feature.currentIndex()
        if tab_position == 0:
            self.ids = self.ids_arc
        elif tab_position == 1:
            self.ids = self.ids_node
        elif tab_position == 2:
            self.ids = self.ids_connec

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_info_box(message)
            return

        del_id = []
        inf_text = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_feature = widget.model().record(row).value(feature_id)
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
                if tab_position == 0:
                    sql = "DELETE FROM " + self.schema_name + ".element_x_arc WHERE arc_id = '" + str(el) + "'"
                    ids = self.ids_arc
                    #self.ids_arc.remove(str(el))
                elif tab_position == 1:
                    sql = "DELETE FROM " + self.schema_name + ".element_x_node WHERE node_id = '" + str(el) + "'"
                    ids = self.ids_node
                    #self.ids_node.remove(str(el))
                elif tab_position == 2:
                    sql = "DELETE FROM " + self.schema_name + ".element_x_connec WHERE connec_id = '" + str(el) + "'"
                    ids = self.ids_connec


        ids = self.ids


       
        # Select features which are in the list
        expr_filter = "\"" + str(feature_id) + "\" IN ("
        for i in range(len(ids)):
            expr_filter += "'" + str(ids[i]) + "', "
        expr_filter = expr_filter[:-2] + ")"

        expr = QgsExpression(expr_filter)
        if expr.hasParserError():
            message = "Expression Error: " + str(expr.parserErrorString())
            self.controller.show_warning(message)
            return
        
        # Update model of the widget with selected expr_filter
        #self.connec_expr_filter = expr_filter     
        expr = self.reload_table(widget, tablename, expr_filter)               

        # Reload selection
        for layer in group_pointers:
            # Build a list of feature id's and select them
            it = layer.getFeatures(QgsFeatureRequest(expr))
            id_list = [i.id() for i in it]
            layer.selectByIds(id_list)


    def reload_table(self, widget, tablename, expr_filter=None):
        """ Reload @widget with contents of @tablename applying selected @expr_filter """
                         
        #table_name = self.schema_name + "." + table_name
#         if expr_filter is None:
#             expr_filter = self.connec_expr_filter        
        expr = self.set_table_model(widget, table_name, expr_filter)
        return expr
    

    def edit_add_file_autocomplete(self):
        """ Once we select 'element_id' using autocomplete, 
            fill widgets with current values 
        """

        self.dlg.doc_id.setCompleter(self.completer)
        doc_id = utils_giswater.getWidgetText("doc_id")

        # Get values from database
        sql = ("SELECT doc_type, tagcat_id, observ, path"
               " FROM " + self.schema_name + ".doc"
               " WHERE id = '" + doc_id + "'")
        row = self.controller.get_row(sql)

        # Fill widgets
        columns_length = self.dao.get_columns_length()
        for i in range(0, columns_length):
            column_name = self.dao.get_column_name(i)
            utils_giswater.setWidgetText(column_name, row[column_name])


    def edit_add_file_accept(self):
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
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".doc WHERE id = '" + doc_id + "'"
        row = self.controller.get_row(sql)
        
        # If document already exist perform an UPDATE
        if row:
            answer = self.controller.ask_question("Are you sure you want change the data?")
            if answer:
                sql = "UPDATE " + self.schema_name + ".doc "
                sql += " SET doc_type = '" + doc_type + "', observ = '" + observ + "', path = '" + path + "'"
                sql += " WHERE id = '" + doc_id + "'"
                status = self.controller.execute_sql(sql)
                if status:
                    #self.ed_add_to_feature("doc", doc_id)
                    message = "Values has been updated"
                    self.controller.show_info(message)

                message = "Values has been updated into table document"
                self.controller.show_info(message)

                sql = "DELETE FROM " + self.schema_name + ".doc_x_node WHERE doc_id = '" + str(doc_id) + "'"
                self.controller.execute_sql(sql)
                sql = "DELETE FROM " + self.schema_name + ".doc_x_arc WHERE doc_id = '" + str(doc_id) + "'"
                self.controller.execute_sql(sql)
                sql = "DELETE FROM " + self.schema_name + ".doc_x_connec WHERE doc_id = '" + str(doc_id) + "'"
                self.controller.execute_sql(sql)

                if self.ids_arc != []:
                    for arc_id in self.ids_arc:
                        sql = "INSERT INTO " + self.schema_name + ".doc_x_arc (doc_id, arc_id )"
                        sql += " VALUES ('" + str(doc_id) + "', '" + str(arc_id) + "')"
                        status = self.controller.execute_sql(sql)
                        if status:
                            message = "Values has been updated into table doc_x_arc"
                            self.controller.show_info(message)
                        if not status:
                            message = "Error inserting element in table, you need to review data"
                            self.controller.show_warning(message)
                            return
                if self.ids_node != []:
                    for node_id in self.ids_node:
                        sql = "INSERT INTO " + self.schema_name + ".doc_x_node (doc_id, node_id )"
                        sql += " VALUES ('" + str(doc_id) + "', '" + str(node_id) + "')"
                        status = self.controller.execute_sql(sql)
                        if status:
                            message = "Values has been updated into table doc_x_node"
                            self.controller.show_info(message)
                        if not status:
                            message = "Error inserting element in table, you need to review data"
                            self.controller.show_warning(message)
                            return
                if self.ids_connec != []:
                    for connec_id in self.ids_connec:
                        sql = "INSERT INTO " + self.schema_name + ".doc_x_connec (doc_id, connec_id )"
                        sql += " VALUES ('" + str(doc_id) + "', '" + str(connec_id) + "')"
                        status = self.controller.execute_sql(sql)
                        if status:
                            message = "Values has been updated into table element_x_connec"
                            self.controller.show_info(message)
                        if not status:
                            message = "Error inserting element in table, you need to review data"
                            self.controller.show_warning(message)
                            return


        # If document doesn't exist perform an INSERT
        else:
            sql = "INSERT INTO " + self.schema_name + ".doc (id, doc_type, path, observ) "
            sql += " VALUES ('" + doc_id + "', '" + doc_type + "', '" + path + "', '" + observ +  "')"
            status = self.controller.execute_sql(sql)
            if status:
                message = "Values has been updated into table document"
                self.controller.show_info(message)

                if self.ids_arc != []:

                    for arc_id in self.ids_arc:
                        sql = "INSERT INTO " + self.schema_name + ".doc_x_arc (doc_id, arc_id )"
                        sql += " VALUES ('" + str(doc_id) + "', '" + str(arc_id) + "')"
                        status = self.controller.execute_sql(sql)
                        if status:
                            message = "Values has been updated into table doc_x_arc"
                            self.controller.show_info(message)
                        if not status:
                            message = "Error inserting element in table, you need to review data"
                            self.controller.show_warning(message)
                            return
                if self.ids_node != []:
                    for node_id in self.ids_node:
                        sql = "INSERT INTO " + self.schema_name + ".doc_x_node (doc_id, node_id )"
                        sql += " VALUES ('" + str(doc_id) + "', '" + str(node_id) + "')"
                        status = self.controller.execute_sql(sql)
                        if status:
                            message = "Values has been updated into table doc_x_node"
                            self.controller.show_info(message)
                        if not status:
                            message = "Error inserting element in table, you need to review data"
                            self.controller.show_warning(message)
                            return
                if self.ids_connec != []:
                    for connec_id in self.ids_connec:
                        sql = "INSERT INTO " + self.schema_name + ".doc_x_connec (doc_id, connec_id )"
                        sql += " VALUES ('" + str(doc_id) + "', '" + str(connec_id) + "')"
                        status = self.controller.execute_sql(sql)
                        if status:
                            message = "Values has been updated into table element_x_connec"
                            self.controller.show_info(message)
                        if not status:
                            message = "Error inserting element in table, you need to review data"
                            self.controller.show_warning(message)
                            return

            if not status:
                message = "Error inserting document in table, you need to review data"
                self.controller.show_warning(message)
                return

        self.close_dialog()

