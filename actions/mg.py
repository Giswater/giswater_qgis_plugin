"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtSql import QSqlTableModel, QSqlQueryModel

from qgis.core import QgsMapLayerRegistry, QgsFeatureRequest

from PyQt4.QtGui import QFileDialog
import os
import sys

from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater

from ..ui.change_node_type import ChangeNodeType                # @UnresolvedImport

from parent import ParentAction                                 # @UnresolvedImport


class Mg(ParentAction):
   
    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control Management toolbar actions """
                  
        # Call ParentAction constructor      
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
    
    def set_project_type(self, project_type):
        self.project_type = project_type
    '''
    def mg_change_elem_type(self):
        """ Button 28: User select one node. A form is opened showing current node_type.type
        Combo to select new node_type.type
        Combo to select new node_type.id
        Combo to select new cat_node.id
        """

        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, 28)

        # Check if at least one node is checked          
        layer = self.iface.activeLayer()
        count = layer.selectedFeatureCount()
        if count == 0:
            message = "You have to select at least one feature!"
            self.controller.show_info(message, context_name='ui_message')
            return
        elif count > 1:
            message = "More than one feature selected. Only the first one will be processed!"
            self.controller.show_info(message, context_name='ui_message')

        # Get selected features (nodes)
        features = layer.selectedFeatures()
        feature = features[0]
        # Get node_id form current node
        self.node_id = feature.attribute('node_id')

        # Get node_type from current node
        node_type = feature.attribute('node_type')

        # Create the dialog, fill node_type and define its signals
        self.dlg = ChangeNodeType()
        self.dlg.node_node_type.setText(node_type)
        self.dlg.node_type_type_new.currentIndexChanged.connect(self.mg_change_elem_type_get_value)
        self.dlg.node_node_type_new.currentIndexChanged.connect(self.mg_change_elem_type_get_value_2)
        self.dlg.node_nodecat_id.currentIndexChanged.connect(self.mg_change_elem_type_get_value_3)
        self.dlg.btn_accept.pressed.connect(self.mg_change_elem_type_accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)

        # Fill 1st combo boxes-new system node type
        sql = "SELECT DISTINCT(type) FROM "+self.schema_name+".node_type ORDER BY type"
        rows = self.dao.get_rows(sql)
        utils_giswater.setDialog(self.dlg)
        utils_giswater.fillComboBox("node_type_type_new", rows)

        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'change_node_type')
        self.dlg.exec_()
    '''
    '''
    def mg_change_elem_type_get_value(self, index):   #@UnusedVariable
        """ Just select item to 'real' combo 'nodecat_id' (that is hidden) """

        # Get selected value from 1st combobox
        self.value_combo1 = utils_giswater.getWidgetText("node_type_type_new")

        # When value is selected, enabled 2nd combo box
        if self.value_combo1 != 'null':
            self.dlg.node_node_type_new.setEnabled(True)
            # Fill 2nd combo_box-custom node type
            sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".node_type WHERE type='"+self.value_combo1+"'"
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("node_node_type_new", rows)
    '''
    '''
    def mg_change_elem_type_get_value_2(self, index):
        """ Just select item to 'real' combo 'nodecat_id' (that is hidden) """

        if index == -1:
            return

        # Get selected value from 2nd combobox
        self.value_combo2 = utils_giswater.getWidgetText("node_node_type_new")

        # When value is selected, enabled 3rd combo box
        if self.value_combo2 != 'null':
            # Get selected value from 2nd combobox
            self.dlg.node_nodecat_id.setEnabled(True)
            # Fill 3rd combo_box-catalog_id
            sql = "SELECT DISTINCT(id)"
            sql += " FROM "+self.schema_name+".cat_node"
            sql += " WHERE nodetype_id='"+self.value_combo2+"'"
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("node_nodecat_id", rows)
    '''
    '''
    def mg_change_elem_type_get_value_3(self, index):   #@UnusedVariable
        self.value_combo3 = utils_giswater.getWidgetText("node_nodecat_id")
    '''
    '''
    def mg_change_elem_type_accept(self):
        """ Update current type of node and save changes in database """

        # Update node_type in the database
        sql = "UPDATE "+self.schema_name+".v_edit_node"
        sql += " SET node_type ='"+self.value_combo2+"'"
        if self.value_combo3 != 'null':
            sql += ", nodecat_id='"+self.value_combo3+"'"
        sql += " WHERE node_id ='"+self.node_id+"'"
        self.controller.execute_sql(sql)

        # Show message to the user
        message = "Node type has been update!"
        self.controller.show_info(message, context_name='ui_message' )

        # Close form
        self.close_dialog()
    '''
    '''
    def open_file_dialog(self, widget):
        """ Open File Dialog """

        # Set default value from QLine
        self.file_path = utils_giswater.getWidgetText(widget)

        # Check if file exists
        if not os.path.exists(self.file_path):
            message = "File path doesn't exist"
            self.controller.show_warning(message, 10, context_name='ui_message')
            self.file_path = self.plugin_dir
        # Set default value if necessary
        elif self.file_path == 'null':
            self.file_path = self.plugin_dir

        # Get directory of that file
        folder_path = os.path.dirname(self.file_path)
        os.chdir(folder_path)
        msg = "Select file"
        self.file_path = QFileDialog.getOpenFileName(None, self.controller.tr(msg), "")

        # Separate path to components
        abs_path = os.path.split(self.file_path)

        # Set text to QLineEdit
        widget.setText(abs_path[0]+'/')
    '''

    def fill_insert_menu(self, table):
        """ Insert menu on QPushButton->QMenu """

        self.menu.clear()
        sql = "SELECT id FROM "+self.schema_name+".value_state"
        sql += " ORDER BY id"
        rows = self.dao.get_rows(sql)
        if not rows:
            return
        # Fill menu
        for row in rows:
            elem = row[0]
            # If not exist in table _selector_state isert to menu
            # Check if we already have data with selected id
            sql = "SELECT id FROM "+self.schema_name+"."+table+" WHERE id = '"+elem+"'"
            row = self.dao.get_row(sql)
            if row is None:
                self.menu.addAction(elem, partial(self.insert, elem, table))


    def insert(self, id_action, table):
        """ On action(select value from menu) execute SQL """

        # Insert value into database
        sql = "INSERT INTO "+self.schema_name+"."+table+" (id) "
        sql += " VALUES ('"+id_action+"')"
        self.controller.execute_sql(sql)
        self.fill_table(self.tbl, self.schema_name+"."+table)

    '''
    def delete_records(self, widget, table_name):
        """ Delete selected elements of the table """

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message')
            return

        inf_text = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = widget.model().record(row).value("id")
            inf_text += str(id_)+", "
            list_id = list_id+"'"+str(id_)+"', "
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        answer = self.controller.ask_question("Are you sure you want to delete these records?", "Delete records", inf_text)
        if answer:
            sql = "DELETE FROM "+self.schema_name+"."+table_name
            sql += " WHERE id IN ("+list_id+")"
            self.controller.execute_sql(sql)
            widget.model().select()

    '''


    def fill_table(self, widget, table_name):
        """ Set a model with selected filter.
        Attach that model to selected table """

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


    def mg_dimensions(self):
        """ Button 39: Dimensioning """

        layer = QgsMapLayerRegistry.instance().mapLayersByName("v_edit_dimensions")[0]
        self.iface.setActiveLayer(layer)
        layer.startEditing()
        # Implement the Add Feature button
        self.iface.actionAddFeature().trigger()



