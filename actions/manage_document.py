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
from giswater.ui_manager import AddDoc
from giswater.ui_manager import DocManagement
from giswater.actions.parent_manage import ParentManage


class ManageDocument(ParentManage):

    def __init__(self, iface, settings, controller, plugin_dir, single_tool=True):
        """ Class to control action 'Add document' of toolbar 'edit' """
        ParentManage.__init__(self, iface, settings, controller, plugin_dir) 

        # parameter to set if the document manager is working as
        # single tool or integrated in another tool
        self.single_tool_mode = single_tool
        self.previous_dialog = None


    def edit_add_file(self):
        self.manage_document()
                

    def manage_document(self, tablename=None, qtable=None, item_id=None, feature=None):
        """ Button 34: Add document """
        self.controller.restore_info()
        # Create the dialog and signals
        self.dlg_add_doc = AddDoc()
        self.load_settings(self.dlg_add_doc)
        self.doc_id = None           

        # Capture the current layer to return it at the end of the operation
        cur_active_layer = self.iface.activeLayer()

        self.set_selectionbehavior(self.dlg_add_doc)
        
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
            self.dlg_add_doc.tab_feature.removeTab(3)
        else:
            self.layers['gully'] = self.controller.api_get_group_layers('gully')
        
        # Remove all previous selections
        if self.single_tool_mode:
            self.remove_selection(True)
        if feature is not None:
            layer = self.iface.activeLayer()
            layer.selectByIds([feature.id()])
        
        # Set icons
        self.set_icon(self.dlg_add_doc.btn_insert, "111")
        self.set_icon(self.dlg_add_doc.btn_delete, "112")
        self.set_icon(self.dlg_add_doc.btn_snapping, "137")
        # TODO pending translation
        # Manage i18n of the form
        # self.controller.translate_form(self.dlg, 'file')
                
        # Fill combo boxes
        self.populate_combo(self.dlg_add_doc, "doc_type", "doc_type")

        # Adding auto-completion to a QLineEdit
        table_object = "doc"        
        self.set_completer_object(self.dlg_add_doc, table_object)
        geom_type = 'arc'
        # Adding auto-completion to a QLineEdit for default feature
        viewname = "ve_" + geom_type
        self.set_completer_feature_id(self.dlg_add_doc.feature_id, geom_type, viewname)

        # Set signals
        self.dlg_add_doc.path_url.clicked.connect(partial(self.open_web_browser, self.dlg_add_doc, "path"))
        self.dlg_add_doc.path_doc.clicked.connect(partial(self.get_file_dialog, self.dlg_add_doc, "path"))
        self.dlg_add_doc.btn_accept.clicked.connect(partial(self.manage_document_accept, table_object, tablename, qtable, item_id))        
        self.dlg_add_doc.btn_cancel.clicked.connect(partial(self.manage_close, self.dlg_add_doc, table_object, cur_active_layer))
        self.dlg_add_doc.rejected.connect(partial(self.manage_close, self.dlg_add_doc, table_object, cur_active_layer))
        self.dlg_add_doc.tab_feature.currentChanged.connect(partial(self.tab_feature_changed, self.dlg_add_doc,  table_object))
        self.dlg_add_doc.doc_id.textChanged.connect(partial(self.exist_object, self.dlg_add_doc, table_object))
        self.dlg_add_doc.btn_insert.clicked.connect(partial(self.insert_feature, self.dlg_add_doc, table_object))
        self.dlg_add_doc.btn_delete.clicked.connect(partial(self.delete_records, self.dlg_add_doc,  table_object))
        self.dlg_add_doc.btn_snapping.clicked.connect(partial(self.selection_init, self.dlg_add_doc, table_object))
        if feature:
            self.dlg_add_doc.tabWidget.currentChanged.connect(partial(self.fill_table_doc, self.dlg_add_doc, geom_type, feature[geom_type+"_id"]))


        # Set default tab 'arc'
        self.dlg_add_doc.tab_feature.setCurrentIndex(0)
        self.geom_type = "arc"
        self.tab_feature_changed(self.dlg_add_doc, table_object)

        # Open the dialog
        self.open_dialog(self.dlg_add_doc, maximize_button=False)
        return self.dlg_add_doc


    def fill_table_doc(self, dialog, geom_type, feature_id):
        widget = "tbl_doc_x_" + geom_type
        widget = dialog.findChild(QTableView, widget)
        widget.setSelectionBehavior(QAbstractItemView.SelectRows)
        expr_filter = geom_type + "_id = '" + str(feature_id) + "'"
        # Set model of selected widget
        table_name = self.schema_name + ".ve_" + geom_type
        self.set_model_to_table(widget, table_name, expr_filter)


    def manage_document_accept(self, table_object, tablename=None, qtable=None, item_id=None):
        """ Insert or update table 'document'. Add document to selected feature """
        
        # Get values from dialog
        doc_id = utils_giswater.getWidgetText(self.dlg_add_doc, "doc_id", return_string_null=False)
        doc_type = utils_giswater.getWidgetText(self.dlg_add_doc, "doc_type", return_string_null=False)
        observ = utils_giswater.getWidgetText(self.dlg_add_doc, "observ", return_string_null=False)
        path = utils_giswater.getWidgetText(self.dlg_add_doc, "path", return_string_null=False)
        if doc_type == 'null':
            message = "You need to insert doc_type"
            self.controller.show_warning(message)
            return

        # Check if this document already exists
        sql = ("SELECT DISTINCT(id)"
               " FROM " + self.schema_name + "." + str(table_object) + ""
               " WHERE id = '" + str(doc_id) + "'")
        row = self.controller.get_row(sql, log_info=False)

        # If document not exists perform an INSERT
        if row is None:
            if doc_id == 'null':
                sql = ("INSERT INTO " + self.schema_name + ".doc (doc_type, path, observ)"
                       " VALUES ('" + doc_type + "', '" + path + "', '" + observ + "') RETURNING id;")
                new_doc_id = self.controller.execute_returning(sql, search_audit=False, log_sql=True)
                sql = ""
                doc_id = str(new_doc_id[0])
            else:
                sql = ("INSERT INTO " + self.schema_name + ".doc (id, doc_type, path, observ)"
                       " VALUES ('" + doc_id + "', '" + doc_type + "', '" + path + "', '" + observ + "');")

        # If document exists perform an UPDATE
        else:
            message = "Are you sure you want to update the data?"
            answer = self.controller.ask_question(message)
            if not answer:
                return
            sql = ("UPDATE " + self.schema_name + ".doc "
                   " SET doc_type = '" + doc_type + "', observ = '" + observ + "', path = '" + path + "'"
                   " WHERE id = '" + str(doc_id) + "';")

        # Manage records in tables @table_object_x_@geom_type
        sql += ("\nDELETE FROM " + self.schema_name + ".doc_x_node"
                " WHERE doc_id = '" + str(doc_id) + "';")
        sql += ("\nDELETE FROM " + self.schema_name + ".doc_x_arc"
                " WHERE doc_id = '" + str(doc_id) + "';")
        sql += ("\nDELETE FROM " + self.schema_name + ".doc_x_connec"
                " WHERE doc_id = '" + str(doc_id) + "';")
        if self.project_type == 'ud':        
            sql += ("\nDELETE FROM " + self.schema_name + ".doc_x_gully"
                    " WHERE doc_id = '" + str(doc_id) + "';")

        if self.list_ids['arc']:
            for feature_id in self.list_ids['arc']:
                sql += ("\nINSERT INTO " + self.schema_name + ".doc_x_arc (doc_id, arc_id)"
                        " VALUES ('" + str(doc_id) + "', '" + str(feature_id) + "');")
        if self.list_ids['node']:
            for feature_id in self.list_ids['node']:
                sql += ("\nINSERT INTO " + self.schema_name + ".doc_x_node (doc_id, node_id)"
                        " VALUES ('" + str(doc_id) + "', '" + str(feature_id) + "');")
        if self.list_ids['connec']:
            for feature_id in self.list_ids['connec']:
                sql += ("\nINSERT INTO " + self.schema_name + ".doc_x_connec (doc_id, connec_id)"
                        " VALUES ('" + str(doc_id) + "', '" + str(feature_id) + "');")
        if self.project_type == 'ud' and self.list_ids['gully']:
            for feature_id in self.list_ids['gully']:
                sql += ("\nINSERT INTO " + self.schema_name + ".doc_x_gully (doc_id, gully_id)"
                        " VALUES ('" + str(doc_id) + "', '" + str(feature_id) + "');")

        status = self.controller.execute_sql(sql)
        if status:
            self.doc_id = doc_id            
            self.manage_close(self.dlg_add_doc, table_object)  

        if tablename is None:
            return
        else:
            sql = ("INSERT INTO " + self.schema_name +".doc_x_"+str(tablename)+"(doc_id, "+str(tablename)+"_id) "
                   " VALUES('"+str(doc_id)+"', '"+str(item_id)+"')")
            self.controller.execute_sql(sql)
            expr = "" + str(tablename) + "_id = '" + str(item_id) + "'"
            self.fill_table_object(qtable, self.schema_name + ".v_ui_doc_x_"+str(tablename)+"", expr_filter=expr)


    def edit_document(self):
        """ Button 66: Edit document """
        self.controller.restore_info()
        # Create the dialog
        self.dlg_man = DocManagement()
        self.load_settings(self.dlg_man)
        self.dlg_man.tbl_document.setSelectionBehavior(QAbstractItemView.SelectRows)
                
        # Adding auto-completion to a QLineEdit
        table_object = "doc"        
        self.set_completer_object(self.dlg_man, table_object)
                
        # Set a model with selected filter. Attach that model to selected table
        self.fill_table_object(self.dlg_man.tbl_document, self.schema_name + "." + table_object)                
        self.set_table_columns(self.dlg_man, self.dlg_man.tbl_document, table_object)
        
        # Set dignals
        self.dlg_man.doc_id.textChanged.connect(partial(self.filter_by_id, self.dlg_man, self.dlg_man.tbl_document, self.dlg_man.doc_id, table_object))
        self.dlg_man.tbl_document.doubleClicked.connect(partial(self.open_selected_object, self.dlg_man, self.dlg_man.tbl_document, table_object))
        self.dlg_man.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_man))
        self.dlg_man.rejected.connect(partial(self.close_dialog, self.dlg_man))
        self.dlg_man.btn_delete.clicked.connect(partial(self.delete_selected_object, self.dlg_man.tbl_document, table_object))
                                
        # Open form
        self.open_dialog(self.dlg_man)
        
                    