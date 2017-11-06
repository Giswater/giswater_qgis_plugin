"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtGui import QAbstractItemView, QTableView, QFileDialog, QComboBox, QIcon
from PyQt4.QtSql import QSqlTableModel, QSqlQueryModel

import os
import sys
import webbrowser
import ConfigParser
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater    


class ParentAction():

    def __init__(self, iface, settings, controller, plugin_dir):  
        ''' Class constructor '''

        # Initialize instance attributes
        self.giswater_version = "3.0"
        self.iface = iface
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir       
        self.dao = self.controller.dao         
        self.schema_name = self.controller.schema_name
        self.project_type = None
          
        # Get files to execute giswater jar (only in Windows)
        if 'nt' in sys.builtin_module_names: 
            self.plugin_version = self.get_plugin_version()
            self.java_exe = self.get_java_exe()              
            (self.giswater_file_path, self.giswater_build_version) = self.get_giswater_jar() 
            self.gsw_file = self.controller.plugin_settings_value('gsw_file')   
    
    
    def set_controller(self, controller):
        """ Set controller class """
        
        self.controller = controller
        self.schema_name = self.controller.schema_name       
        
    
    def get_plugin_version(self):
        ''' Get plugin version from metadata.txt file '''
               
        # Check if metadata file exists    
        metadata_file = os.path.join(self.plugin_dir, 'metadata.txt')
        if not os.path.exists(metadata_file):
            message = "Metadata file not found at: "+metadata_file
            self.controller.show_warning(message, 10, context_name='ui_message')
            return None
          
        metadata = ConfigParser.ConfigParser()
        metadata.read(metadata_file)
        plugin_version = metadata.get('general', 'version')
        if plugin_version is None:
            msg = "Plugin version not found"
            self.controller.show_warning(msg, 10, context_name='ui_message')
        
        return plugin_version
               
       
    def get_giswater_jar(self):
        ''' Get executable Giswater file and build version from windows registry '''
             
        reg_hkey = "HKEY_LOCAL_MACHINE"
        reg_path = "SOFTWARE\\Giswater\\"+self.giswater_version
        reg_name = "InstallFolder"
        giswater_folder = utils_giswater.get_reg(reg_hkey, reg_path, reg_name)
        if giswater_folder is None:
            message = "Cannot get giswater folder from windows registry at: "+reg_path
            self.controller.show_warning(message, 10, context_name='ui_message')
            return (None, None)
            
        # Check if giswater folder exists
        if not os.path.exists(giswater_folder):
            message = "Giswater folder not found at: "+giswater_folder
            self.controller.show_warning(message, 10, context_name='ui_message')
            return (None, None)           
            
        # Check if giswater executable file file exists
        giswater_file_path = giswater_folder+"\giswater.jar"
        if not os.path.exists(giswater_file_path):
            message = "Giswater executable file not found at: "+giswater_file_path
            self.controller.show_warning(message, 10, context_name='ui_message')
            return (None, None) 

        # Get giswater major version
        reg_name = "MajorVersion"
        major_version = utils_giswater.get_reg(reg_hkey, reg_path, reg_name)
        if major_version is None:
            message = "Cannot get giswater major version from windows registry at: "+reg_path
            self.controller.show_warning(message, 10, context_name='ui_message')
            return (giswater_file_path, None)    

        # Get giswater minor version
        reg_name = "MinorVersion"
        minor_version = utils_giswater.get_reg(reg_hkey, reg_path, reg_name)
        if minor_version is None:
            message = "Cannot get giswater major version from windows registry at: "+reg_path
            self.controller.show_warning(message, 10, context_name='ui_message')
            return (giswater_file_path, None)  
                        
        # Get giswater build version
        reg_name = "BuildVersion"
        build_version = utils_giswater.get_reg(reg_hkey, reg_path, reg_name)
        if build_version is None:
            message = "Cannot get giswater build version from windows registry at: "+reg_path
            self.controller.show_warning(message, 10, context_name='ui_message')
            return (giswater_file_path, None)        
        
        giswater_build_version = major_version+'.'+minor_version+'.'+build_version
        return (giswater_file_path, giswater_build_version)
    
           
    def get_java_exe(self):
        ''' Get executable Java file from windows registry '''

        reg_hkey = "HKEY_LOCAL_MACHINE"
        reg_path = "SOFTWARE\\JavaSoft\\Java Runtime Environment"
        reg_name = "CurrentVersion"
        java_version = utils_giswater.get_reg(reg_hkey, reg_path, reg_name)
        
        # Check if java version exists (64 bits)
        if java_version is None:
            reg_path = "SOFTWARE\\Wow6432Node\\JavaSoft\\Java Runtime Environment" 
            java_version = utils_giswater.get_reg(reg_hkey, reg_path, reg_name)   
            # Check if java version exists (32 bits)            
            if java_version is None:
                message = "Cannot get current Java version from windows registry at: "+reg_path
                self.controller.show_warning(message, 10, context_name='ui_message')
                return None
      
        # Get java folder
        reg_path+= "\\"+java_version
        reg_name = "JavaHome"
        java_folder = utils_giswater.get_reg(reg_hkey, reg_path, reg_name)
        if java_folder is None:
            message = "Cannot get Java folder from windows registry at: "+reg_path
            self.controller.show_warning(message, 10, context_name='ui_message')
            return None         

        # Check if java folder exists
        if not os.path.exists(java_folder):
            message = "Java folder not found at: "+java_folder
            self.controller.show_warning(message, 10, context_name='ui_message')
            return None  

        # Check if java executable file exists
        java_exe = java_folder+"/bin/java.exe"
        if not os.path.exists(java_exe):
            message = "Java executable file not found at: "+java_exe
            self.controller.show_warning(message, 10, context_name='ui_message')
            return None  
                
        return java_exe
                        

    def execute_giswater(self, parameter, index_action):
        ''' Executes giswater with selected parameter '''

        if self.giswater_file_path is None or self.java_exe is None:
            return               
        
        # Check if gsw file exists. If not giswater will open with the last .gsw file
        if self.gsw_file != "" and not os.path.exists(self.gsw_file):
            message = "GSW file not found at: "+self.gsw_file
            self.controller.show_info(message, 10, context_name='ui_message')
            self.gsw_file = ""          
        
        # Start program     
        aux = '"'+self.giswater_file_path+'"'
        if self.gsw_file != "":
            aux+= ' "'+self.gsw_file+'"'
            program = [self.java_exe, "-jar", self.giswater_file_path, self.gsw_file, parameter]
        else:
            program = [self.java_exe, "-jar", self.giswater_file_path, "", parameter]
            
        self.controller.start_program(program)               
        
        # Compare Java and Plugin versions
        if self.plugin_version <> self.giswater_build_version:
            msg = "Giswater and plugin versions are different. \n"
            msg+= "Giswater version: "+self.giswater_build_version
            msg+= " - Plugin version: "+self.plugin_version
            self.controller.show_info(msg, 10, context_name='ui_message')
        # Show information message    
        else:
            msg = "Executing... "+aux
            self.controller.show_info(msg, context_name='ui_message')
        
        
    def open_web_browser(self, widget):
        """ Display url using the default browser """
        
        url = utils_giswater.getWidgetText(widget) 
        if url == 'null':
            url = 'www.giswater.org'
        webbrowser.open(url)    
        

    def get_file_dialog(self, widget):
        """ Get file dialog """
        
        # Check if selected file exists. Set default value if necessary
        file_path = utils_giswater.getWidgetText(widget)
        if file_path is None or file_path == 'null' or not os.path.exists(str(file_path)): 
            folder_path = self.plugin_dir   
        else:     
            folder_path = os.path.dirname(file_path) 
                
        # Open dialog to select file
        os.chdir(folder_path)
        file_dialog = QFileDialog()
        file_dialog.setFileMode(QFileDialog.AnyFile)        
        msg = "Select file"
        folder_path = file_dialog.getOpenFileName(parent=None, caption=self.controller.tr(msg))
        if folder_path:
            utils_giswater.setWidgetText(widget, str(folder_path))            
                
                
    def get_folder_dialog(self, widget):
        """ Get folder dialog """
        
        # Check if selected folder exists. Set default value if necessary
        folder_path = utils_giswater.getWidgetText(widget)
        if folder_path is None or folder_path == 'null' or not os.path.exists(folder_path): 
            folder_path = self.plugin_dir
                
        # Open dialog to select folder
        os.chdir(folder_path)
        file_dialog = QFileDialog()
        file_dialog.setFileMode(QFileDialog.Directory)      
        msg = "Select folder"
        folder_path = file_dialog.getExistingDirectory(parent=None, caption=self.controller.tr(msg))
        if folder_path:
            utils_giswater.setWidgetText(widget, str(folder_path))


    def load_settings(self, dialog=None):
        """ Load QGIS settings related with dialog position and size """
         
        if dialog is None:
            dialog = self.dlg
                    
        width = self.controller.plugin_settings_value(dialog.objectName() + "_width", dialog.width())
        height = self.controller.plugin_settings_value(dialog.objectName() + "_height", dialog.height())
        x = self.controller.plugin_settings_value(dialog.objectName() + "_x")
        y = self.controller.plugin_settings_value(dialog.objectName() + "_y")
        if x < 0 or y < 0:
            dialog.resize(width, height)
        else:
            dialog.setGeometry(x, y, width, height)


    def save_settings(self, dialog=None):
        """ Save QGIS settings related with dialog position and size """
                
        if dialog is None:
            dialog = self.dlg
            
        self.controller.plugin_settings_set_value(dialog.objectName() + "_width", dialog.width())
        self.controller.plugin_settings_set_value(dialog.objectName() + "_height", dialog.height())
        self.controller.plugin_settings_set_value(dialog.objectName() + "_x", dialog.pos().x())
        self.controller.plugin_settings_set_value(dialog.objectName() + "_y", dialog.pos().y())
        
        
    def close_dialog(self, dlg=None): 
        """ Close dialog """

        if dlg is None or type(dlg) is bool:
            dlg = self.dlg
        try:
            self.save_settings(dlg)
            dlg.close()
            map_tool = self.iface.mapCanvas().mapTool()
            # If selected map tool is from the plugin, set 'Pan' as current one 
            if map_tool.toolName() == '':
                self.iface.actionPan().trigger() 
        except AttributeError:
            pass
        
        
    def multi_row_selector(self, dialog, tableleft, tableright, field_id_left, field_id_right):
        
        # fill QTableView all_rows
        tbl_all_rows = dialog.findChild(QTableView, "all_rows")
        tbl_all_rows.setSelectionBehavior(QAbstractItemView.SelectRows)

        query_left = "SELECT * FROM " + self.schema_name + "." + tableleft + " WHERE name NOT IN "
        query_left += "(SELECT name FROM " + self.schema_name + "." + tableleft
        query_left += " RIGHT JOIN " + self.schema_name + "." + tableright + " ON " + tableleft + "." + field_id_left + " = " + tableright + "." + field_id_right
        query_left += " WHERE cur_user = current_user)"
        self.fill_table_by_query(tbl_all_rows, query_left)
        self.hide_colums(tbl_all_rows, [0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15])
        tbl_all_rows.setColumnWidth(1, 200)

        # fill QTableView selected_rows
        tbl_selected_rows = dialog.findChild(QTableView, "selected_rows")
        tbl_selected_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
        query_right = "SELECT name, cur_user, " + tableleft + "." + field_id_left + ", " + tableright + "." + field_id_right + " FROM " + self.schema_name + "." + tableleft
        query_right += " JOIN " + self.schema_name + "." + tableright + " ON " + tableleft + "." + field_id_left + " = " + tableright + "." + field_id_right
        query_right += " WHERE cur_user = current_user"
        self.fill_table_by_query(tbl_selected_rows, query_right)
        self.hide_colums(tbl_selected_rows, [1, 2, 3])
        tbl_selected_rows.setColumnWidth(0, 200)
        # Button select
        dialog.btn_select.pressed.connect(partial(self.multi_rows_selector, tbl_all_rows, tbl_selected_rows, field_id_left, tableright, "id", query_left, query_right, field_id_right))

        # Button unselect
        query_delete = "DELETE FROM " + self.schema_name + "." + tableright
        query_delete += " WHERE current_user = cur_user AND " + tableright + "." + field_id_right + "="
        dialog.btn_unselect.pressed.connect(partial(self.unselector, tbl_all_rows, tbl_selected_rows, query_delete, query_left, query_right, field_id_right))
        # QLineEdit
        dialog.txt_name.textChanged.connect(partial(self.query_like_widget_text, dialog.txt_name, tbl_all_rows, tableleft, tableright, field_id_right))


    def hide_colums(self, widget, comuns_to_hide):
        for i in range(0, len(comuns_to_hide)):
            widget.hideColumn(comuns_to_hide[i])


    def unselector(self, qtable_left, qtable_right, query_delete, query_left, query_right, field_id_right):
        """ """

        selected_list = qtable_right.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message')
            return
        expl_id = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = str(qtable_right.model().record(row).value(field_id_right))
            expl_id.append(id_)
        for i in range(0, len(expl_id)):
            self.controller.execute_sql(query_delete + str(expl_id[i]))

        # Refresh
        self.fill_table_by_query(qtable_left, query_left)
        self.fill_table_by_query(qtable_right, query_right)
        self.iface.mapCanvas().refresh()


    def multi_rows_selector(self, qtable_left, qtable_right, id_ori, tablename_des, id_des, query_left, query_right,
                            field_id):
        """
        :param qtable_left: QTableView origin
        :param qtable_right: QTableView destini
        :param id_ori: Refers to the id of the source table
        :param tablename_des: table destini
        :param id_des: Refers to the id of the target table, on which the query will be made
        :param query_right:
        :param query_left:
        :param field_id:
        """

        selected_list = qtable_left.selectionModel().selectedRows()

        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message')
            return
        expl_id = []
        curuser_list = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = qtable_left.model().record(row).value(id_ori)
            expl_id.append(id_)
            curuser = qtable_left.model().record(row).value("cur_user")
            curuser_list.append(curuser)
        for i in range(0, len(expl_id)):
            # Check if expl_id already exists in expl_selector
            sql = "SELECT DISTINCT(" + id_des + ", cur_user)"
            sql += " FROM " + self.schema_name + "." + tablename_des
            sql += " WHERE " + id_des + " = '" + str(expl_id[i])
            row = self.dao.get_row(sql)
            if row:
                # if exist - show warning
                self.controller.show_info_box("Id " + str(expl_id[i]) + " is already selected!", "Info")
            else:
                sql = 'INSERT INTO ' + self.schema_name + '.' + tablename_des + ' (' + field_id + ', cur_user) '
                sql += " VALUES (" + str(expl_id[i]) + ", current_user)"
                self.controller.execute_sql(sql)

        # Refresh
        self.fill_table_by_query(qtable_right, query_right)
        self.fill_table_by_query(qtable_left, query_left)
        self.iface.mapCanvas().refresh()


    def fill_table_psector(self, widget, table_name, column_id):
        """ Set a model with selected filter.
        Attach that model to selected table """
        
        # Set model
        self.model = QSqlTableModel()
        self.model.setTable(self.schema_name+"."+table_name)
        self.model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        self.model.setSort(0, 0)
        self.model.select()

        # Check for errors
        if self.model.lastError().isValid():
            self.controller.show_warning(self.model.lastError().text())
        # Attach model to table view
        widget.setModel(self.model)
        # put combobox in qtableview
        sql = "SELECT * FROM " + self.schema_name+"."+table_name + " ORDER BY " + column_id
        rows = self.controller.get_rows(sql)
        for x in range(len(rows)):
            combo = QComboBox()
            sql = "SELECT DISTINCT(priority) FROM " + self.schema_name+"."+table_name
            row = self.controller.get_rows(sql)
            utils_giswater.fillComboBox(combo, row, False)
            row = rows[x]
            priority = row[4]
            utils_giswater.setSelectedItem(combo, str(priority))
            i = widget.model().index(x, 4)
            widget.setIndexWidget(i, combo)
            #combo.setStyleSheet("background:#F2F2F2")
            combo.setStyleSheet("background:#E6E6E6")
            combo.currentIndexChanged.connect(partial(self.update_combobox_values, widget, combo, x))


    def update_combobox_values(self, widget, combo, x):
        """ Insert combobox.currentText into widget (QTableView) """

        index = widget.model().index(x, 4)
        widget.model().setData(index, combo.currentText())


    def save_table(self, widget, table_name, column_id):
        """ Save widget (QTableView) into model"""

        if self.model.submitAll():
            self.model.database().commit()
        else:
            self.model.database().rollback()
        self.fill_table_psector(widget, table_name, column_id)


    def fill_table(self, widget, table_name):
        """ Set a model with selected filter.
        Attach that model to selected table """

        # Set model
        self.model = QSqlTableModel()
        self.model.setTable(table_name)
        self.model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        self.model.setSort(0, 0)
        self.model.select()

        # Check for errors
        if self.model.lastError().isValid():
            self.controller.show_warning(self.model.lastError().text())
        # Attach model to table view
        widget.setModel(self.model)


    def fill_table_by_query(self, qtable, query):
        """
        :param qtable: QTableView to show
        :param query: query to set model
        """
        model = QSqlQueryModel()
        model.setQuery(query)
        qtable.setModel(model)
        qtable.show()


    def query_like_widget_text(self, text_line, qtable, tableleft, tableright, field_id):
        """ Fill the QTableView by filtering through the QLineEdit"""
        query = text_line.text()
        sql = "SELECT * FROM " + self.schema_name + "." + tableleft + " WHERE name NOT IN "
        sql += "(SELECT name FROM " + self.schema_name + "." + tableleft
        sql += " RIGHT JOIN " + self.schema_name + "." + tableright + " ON " + tableleft + "." + field_id + " = " + tableright + "." + field_id
        sql += " WHERE cur_user = current_user) AND name LIKE '%" + query + "%'"
        self.fill_table_by_query(qtable, sql)
        
        
    def set_icon(self, widget, icon):
        """ Set @icon to selected @widget """

        # Get icons folder
        icons_folder = os.path.join(self.plugin_dir, 'icons')           
        icon_path = os.path.join(icons_folder, str(icon) + ".png")           
        if os.path.exists(icon_path):
            widget.setIcon(QIcon(icon_path))
        else:
            self.controller.log_info("File not found", parameter=icon_path)
                    
