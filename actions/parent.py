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

if Qgis.QGIS_VERSION_INT >= 21400 and Qgis.QGIS_VERSION_INT < 29900:
    from PyQt4.QtCore import Qt, QSettings
    from PyQt4.QtGui import QAbstractItemView, QTableView, QFileDialog, QIcon, QApplication, QCursor, QPixmap
    from PyQt4.QtGui import QStringListModel, QCompleter, QAction
    from PyQt4.QtSql import QSqlTableModel, QSqlQueryModel
    from qgis.gui import QgsMapCanvasSnapper
    import ConfigParser as configparser
else:
    from qgis.PyQt.QtCore import Qt, QSettings, QStringListModel
    from qgis.PyQt.QtGui import QIcon, QCursor, QPixmap
    from qgis.PyQt.QtWidgets import QAbstractItemView, QApplication, QCompleter, QFileDialog, QTableView, QAction
    from qgis.PyQt.QtSql import QSqlTableModel, QSqlQueryModel 
    from qgis.gui import QgsMapCanvas
    import configparser 

from qgis.core import QgsExpression, QgsFeatureRequest

import ctypes
import os
import sys
import webbrowser
from functools import partial

import utils_giswater    


class ParentAction(object):

    def __init__(self, iface, settings, controller, plugin_dir):  
        """ Class constructor """

        # Initialize instance attributes
        self.giswater_version = "3.1"
        self.iface = iface
        self.canvas = self.iface.mapCanvas()        
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir       
        self.dao = self.controller.dao         
        self.schema_name = self.controller.schema_name
        self.project_type = None
        self.file_gsw = None
        self.gsw_settings = None

        # Get files to execute giswater jar (only in Windows)
        if 'nt' in sys.builtin_module_names: 
            self.plugin_version = self.get_plugin_version()
            self.java_exe = self.get_java_exe()              
            (self.giswater_file_path, self.giswater_build_version) = self.get_giswater_jar() 
    

    def set_controller(self, controller):
        """ Set controller class """
        
        self.controller = controller
        self.schema_name = self.controller.schema_name       
        
    
    def get_plugin_version(self):
        """ Get plugin version from metadata.txt file """
               
        # Check if metadata file exists    
        metadata_file = os.path.join(self.plugin_dir, 'metadata.txt')
        if not os.path.exists(metadata_file):
            message = "Metadata file not found" + metadata_file
            self.controller.show_warning(message, parameter=metadata_file)
            return None
          
        metadata = configparser.ConfigParser()
        metadata.read(metadata_file)
        plugin_version = metadata.get('general', 'version')
        if plugin_version is None:
            message = "Plugin version not found"
            self.controller.show_warning(message)
        
        return plugin_version
               
       
    def get_giswater_jar(self):
        """ Get executable Giswater file and build version from windows registry """
             
        reg_hkey = "HKEY_LOCAL_MACHINE"
        reg_path = "SOFTWARE\\Giswater\\"+self.giswater_version
        reg_name = "InstallFolder"
        giswater_folder = utils_giswater.get_reg(reg_hkey, reg_path, reg_name)
        if giswater_folder is None:
            message = "Cannot get giswater folder from windows registry"
            self.controller.log_info(message, parameter=reg_path)
            return (None, None)
            
        # Check if giswater folder exists
        if not os.path.exists(giswater_folder):
            message = "Giswater folder not found"
            self.controller.log_info(message, parameter=giswater_folder)
            return (None, None)           
            
        # Check if giswater executable file file exists
        giswater_file_path = giswater_folder+"\giswater.jar"
        if not os.path.exists(giswater_file_path):
            message = "Giswater executable file not found"
            self.controller.log_info(message, parameter=giswater_file_path)
            return (None, None) 

        # Get giswater major version
        reg_name = "MajorVersion"
        major_version = utils_giswater.get_reg(reg_hkey, reg_path, reg_name)
        if major_version is None:
            message = "Cannot get giswater major version from windows registry"
            self.controller.log_info(message, parameter=reg_path)
            return (giswater_file_path, None)    

        # Get giswater minor version
        reg_name = "MinorVersion"
        minor_version = utils_giswater.get_reg(reg_hkey, reg_path, reg_name)
        if minor_version is None:
            message = "Cannot get giswater minor version from windows registry" + reg_path
            self.controller.log_info(message, parameter=reg_path)
            return (giswater_file_path, None)  
                        
        # Get giswater build version
        reg_name = "BuildVersion"
        build_version = utils_giswater.get_reg(reg_hkey, reg_path, reg_name)
        if build_version is None:
            message = "Cannot get giswater build version from windows registry"
            self.controller.log_info(message, parameter=reg_path)
            return (giswater_file_path, None)        
        
        giswater_build_version = major_version + '.' + minor_version + '.' + build_version
        
        return (giswater_file_path, giswater_build_version)
    
           
    def get_java_exe(self):
        """ Get executable Java file from windows registry """

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
                message = "Cannot get current Java version from windows registry"
                self.controller.log_info(message, parameter=reg_path)
                return None
      
        # Get java folder
        reg_path+= "\\"+java_version
        reg_name = "JavaHome"
        java_folder = utils_giswater.get_reg(reg_hkey, reg_path, reg_name)
        if java_folder is None:
            message = "Cannot get Java folder from windows registry"
            self.controller.log_info(message, parameter=reg_path)
            return None         

        # Check if java folder exists
        if not os.path.exists(java_folder):
            message = "Java folder not found"
            self.controller.log_info(message, parameter=java_folder)
            return None  

        # Check if java executable file exists
        java_exe = java_folder+"/bin/java.exe"
        if not os.path.exists(java_exe):
            message = "Java executable file not found"
            self.controller.log_info(message, parameter=java_exe)
            return None  
                
        return java_exe
                        

    def execute_giswater(self, parameter):
        """ Executes giswater with selected parameter """

        if self.giswater_file_path is None or self.java_exe is None:
            return               
        
        # Save database connection parameters into GSW file
        self.save_database_parameters()        
        
        # Check if gsw file exists. If not giswater will open with the last .gsw file
        if self.file_gsw is None:
            self.file_gsw = ""        
        if self.file_gsw:
            if self.file_gsw != "" and not os.path.exists(self.file_gsw):
                message = "GSW file not found"
                self.controller.show_info(message, parameter=self.file_gsw)
                self.file_gsw = ""   
        
        # Start program     
        aux = '"' + self.giswater_file_path + '"'
        if self.file_gsw != "":
            aux+= ' "' + self.file_gsw + '"'
            program = [self.java_exe, "-jar", self.giswater_file_path, self.file_gsw, parameter]
        else:
            program = [self.java_exe, "-jar", self.giswater_file_path, "", parameter]

        self.controller.start_program(program)               
        
        # Compare Java and Plugin versions
        if self.plugin_version != self.giswater_build_version:
            msg = ("Giswater and plugin versions are different. "
                   "Giswater version: " + self.giswater_build_version + ""
                   " - Plugin version: " + self.plugin_version)
            self.controller.show_info(msg, 10)
        # Show information message    
        else:
            message = "Executing..."
            self.controller.show_info(message, parameter=aux)
        

    def set_java_settings(self, show_warning=True):
                        
        # Get giswater properties file
        users_home = os.path.expanduser("~")
        filename = "giswater_" + self.giswater_version + ".properties"
        java_properties_path = users_home + os.sep + "giswater" + os.sep + "config" + os.sep + filename    
        if not os.path.exists(java_properties_path):
            message = "Giswater properties file not found"
            if show_warning:
                self.controller.show_warning(message, parameter=str(java_properties_path))
            return False
                        
        self.java_settings = QSettings(java_properties_path, QSettings.IniFormat)
        self.java_settings.setIniCodec(sys.getfilesystemencoding())        
        self.file_gsw = utils_giswater.get_settings_value(self.java_settings, 'FILE_GSW')   
                
            
    def set_gsw_settings(self):
                  
        if not self.file_gsw:                   
            self.set_java_settings(False)
            
        self.gsw_settings = QSettings(self.file_gsw, QSettings.IniFormat)        
                    

    def save_database_parameters(self):
        """ Save database connection parameters into GSW file """
        
        if self.gsw_settings is None:
            self.set_gsw_settings()
        
        # Get layer version
        layer = self.controller.get_layer_by_tablename('version')
        if not layer:
            return

        # Get database connection paramaters and save them into GSW file
        layer_source = self.controller.get_layer_source_from_credentials()
        if layer_source is None:
            return
                
        self.gsw_settings.setValue('POSTGIS_DATABASE', layer_source['db'])
        self.gsw_settings.setValue('POSTGIS_HOST', layer_source['host'])
        self.gsw_settings.setValue('POSTGIS_PORT', layer_source['port'])
        self.gsw_settings.setValue('POSTGIS_USER', layer_source['user'])
        self.gsw_settings.setValue('POSTGIS_USESSL', 'false')               
        
        
    def open_web_browser(self, dialog, widget=None):
        """ Display url using the default browser """
        
        if widget is not None:           
            url = utils_giswater.getWidgetText(dialog, widget)
            if url == 'null':
                url = 'www.giswater.org'
        else:
            url = 'www.giswater.org'
                     
        webbrowser.open(url)    
        

    def get_file_dialog(self, dialog, widget):
        """ Get file dialog """
        
        # Check if selected file exists. Set default value if necessary
        file_path = utils_giswater.getWidgetText(dialog, widget)
        if file_path is None or file_path == 'null' or not os.path.exists(str(file_path)): 
            folder_path = self.plugin_dir   
        else:     
            folder_path = os.path.dirname(file_path) 
                
        # Open dialog to select file
        os.chdir(folder_path)
        file_dialog = QFileDialog()
        file_dialog.setFileMode(QFileDialog.AnyFile)        
        message = "Select file"
        folder_path = file_dialog.getOpenFileName(parent=None, caption=self.controller.tr(message))
        if folder_path:
            utils_giswater.setWidgetText(dialog, widget, str(folder_path))
                
                
    def get_folder_dialog(self, dialog, widget):
        """ Get folder dialog """
        
        # Check if selected folder exists. Set default value if necessary
        folder_path = utils_giswater.getWidgetText(dialog, widget)
        if folder_path is None or folder_path == 'null' or not os.path.exists(folder_path): 
            folder_path = os.path.expanduser("~")

        # Open dialog to select folder
        os.chdir(folder_path)
        file_dialog = QFileDialog()
        file_dialog.setFileMode(QFileDialog.Directory)      
        message = "Select folder"
        folder_path = file_dialog.getExistingDirectory(parent=None, caption=self.controller.tr(message), directory=folder_path)
        if folder_path:
            utils_giswater.setWidgetText(dialog, widget, str(folder_path))


    def load_settings(self, dialog=None):
        """ Load QGIS settings related with dialog position and size """
        screens = ctypes.windll.user32
        screen_x = screens.GetSystemMetrics(78)
        screen_y = screens.GetSystemMetrics(79)
        if dialog is None:
            dialog = self.dlg
                    
        try:
            x = self.controller.plugin_settings_value(dialog.objectName() + "_x")
            y = self.controller.plugin_settings_value(dialog.objectName() + "_y")
            width = self.controller.plugin_settings_value(dialog.objectName() + "_width", dialog.property('width'))
            height = self.controller.plugin_settings_value(dialog.objectName() + "_height", dialog.property('height'))

            if int(x) < 0 or int(y) < 0:
                dialog.resize(int(width), int(height))
            else:
                if int(x) > screen_x:
                    x = int(screen_x) - int(width)
                if int(y) > screen_y:
                    y = int(screen_y)
                dialog.setGeometry(int(x), int(y), int(width), int(height))
        except:
            pass


    def save_settings(self, dialog=None):
        """ Save QGIS settings related with dialog position and size """
        if dialog is None:
            dialog = self.dlg
        self.controller.plugin_settings_set_value(dialog.objectName() + "_width", dialog.property('width'))
        self.controller.plugin_settings_set_value(dialog.objectName() + "_height", dialog.property('height'))
        self.controller.plugin_settings_set_value(dialog.objectName() + "_x", dialog.pos().x()+8)
        self.controller.plugin_settings_set_value(dialog.objectName() + "_y", dialog.pos().y()+31)
        
        
    def open_dialog(self, dlg=None, dlg_name=None, maximize_button=True, stay_on_top=True): 
        """ Open dialog """

        if dlg is None or type(dlg) is bool:
            dlg = self.dlg
            
        # Manage i18n of the dialog                  
        if dlg_name:      
            self.controller.manage_translation(dlg_name, dlg)      
            
        # Manage stay on top and maximize button
        if maximize_button and stay_on_top:           
            dlg.setWindowFlags(Qt.WindowMinimizeButtonHint | Qt.WindowMaximizeButtonHint | Qt.WindowStaysOnTopHint)       
        elif not maximize_button and stay_on_top:
            dlg.setWindowFlags(Qt.WindowMinimizeButtonHint | Qt.WindowStaysOnTopHint) 
        elif maximize_button and not stay_on_top:
            dlg.setWindowFlags(Qt.WindowMaximizeButtonHint)              

        # Open dialog
        dlg.open()      
    
        
    def close_dialog(self, dlg=None): 
        """ Close dialog """

        if dlg is None or type(dlg) is bool:
            dlg = self.dlg
        try:
            self.save_settings(dlg)
            dlg.close()
            map_tool = self.canvas.mapTool()
            # If selected map tool is from the plugin, set 'Pan' as current one
            if map_tool.toolName() == '':
                self.iface.actionPan().trigger() 
        except AttributeError:
            pass
        
        
    def multi_row_selector(self, dialog, tableleft, tableright, field_id_left, field_id_right, name='name',
                           index=[0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
                                  25, 26, 27, 28, 29, 30]):
        
        # fill QTableView all_rows
        tbl_all_rows = dialog.findChild(QTableView, "all_rows")
        tbl_all_rows.setSelectionBehavior(QAbstractItemView.SelectRows)

        query_left = "SELECT * FROM " + self.schema_name + "." + tableleft + " WHERE " + name + " NOT IN "
        query_left += "(SELECT " + tableleft + "." + name + " FROM " + self.schema_name + "." + tableleft
        query_left += " RIGHT JOIN " + self.schema_name + "." + tableright + " ON " + tableleft + "." + field_id_left + " = " + tableright + "." + field_id_right
        query_left += " WHERE cur_user = current_user)"

        self.fill_table_by_query(tbl_all_rows, query_left)
        self.hide_colums(tbl_all_rows, index)
        tbl_all_rows.setColumnWidth(1, 200)

        # fill QTableView selected_rows
        tbl_selected_rows = dialog.findChild(QTableView, "selected_rows")
        tbl_selected_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
        query_right = "SELECT " + tableleft + "."  + name + ", cur_user, " + tableleft + "." + field_id_left + ", " + tableright + "." + field_id_right + " FROM " + self.schema_name + "." + tableleft
        query_right += " JOIN " + self.schema_name + "." + tableright + " ON " + tableleft + "." + field_id_left + " = " + tableright + "." + field_id_right
        query_right += " WHERE cur_user = current_user"

        self.fill_table_by_query(tbl_selected_rows, query_right)
        self.hide_colums(tbl_selected_rows, [1, 2, 3])
        tbl_selected_rows.setColumnWidth(0, 200)
        # Button select
        dialog.btn_select.clicked.connect(partial(self.multi_rows_selector, tbl_all_rows, tbl_selected_rows, field_id_left, tableright, field_id_right, query_left, query_right, field_id_right))

        # Button unselect
        query_delete = "DELETE FROM " + self.schema_name + "." + tableright
        query_delete += " WHERE current_user = cur_user AND " + tableright + "." + field_id_right + "="
        dialog.btn_unselect.clicked.connect(partial(self.unselector, tbl_all_rows, tbl_selected_rows, query_delete, query_left, query_right, field_id_right))
        # QLineEdit
        dialog.txt_name.textChanged.connect(partial(self.query_like_widget_text, dialog, dialog.txt_name, tbl_all_rows, tableleft, tableright, field_id_right, field_id_left, name))


    def hide_colums(self, widget, comuns_to_hide):
        for i in range(0, len(comuns_to_hide)):
            widget.hideColumn(comuns_to_hide[i])


    def unselector(self, qtable_left, qtable_right, query_delete, query_left, query_right, field_id_right):

        selected_list = qtable_right.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
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
        self.refresh_map_canvas()


    def multi_rows_selector(self, qtable_left, qtable_right, id_ori, 
                            tablename_des, id_des, query_left, query_right, field_id):
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
            self.controller.show_warning(message)
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
            sql = ("SELECT DISTINCT(" + id_des + ", cur_user)"
                   " FROM " + self.schema_name + "." + tablename_des + ""
                   " WHERE " + id_des + " = '" + str(expl_id[i]) + "' AND cur_user = current_user")
            row = self.controller.get_row(sql)

            if row:
                # if exist - show warning
                message = "Id already selected"
                self.controller.show_info_box(message, "Info", parameter=str(expl_id[i]))
            else:
                sql = ("INSERT INTO " + self.schema_name + "." + tablename_des + " (" + field_id + ", cur_user) "
                       " VALUES (" + str(expl_id[i]) + ", current_user)")
                self.controller.execute_sql(sql)

        # Refresh
        self.fill_table_by_query(qtable_right, query_right)
        self.fill_table_by_query(qtable_left, query_left)
        self.refresh_map_canvas()


    def fill_table_psector(self, widget, table_name, set_edit_strategy=QSqlTableModel.OnManualSubmit):
        """ Set a model with selected @table_name. Attach that model to selected table """
        
        # Set model
        self.model = QSqlTableModel()
        self.model.setTable(self.schema_name+"."+table_name)
        self.model.setEditStrategy(set_edit_strategy)
        self.model.setSort(0, 0)
        self.model.select()

        # Check for errors
        if self.model.lastError().isValid():
            self.controller.show_warning(self.model.lastError().text())
            
        # Attach model to table view
        widget.setModel(self.model)


    def fill_table(self, widget, table_name, set_edit_strategy=QSqlTableModel.OnManualSubmit):
        """ Set a model with selected filter.
        Attach that model to selected table """

        # Set model
        self.model = QSqlTableModel()
        self.model.setTable(self.schema_name+"."+table_name)
        self.model.setEditStrategy(set_edit_strategy)
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

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())  
            

    def query_like_widget_text(self, dialog, text_line, qtable, tableleft, tableright, field_id_r, field_id_l, name='name'):
        """ Fill the QTableView by filtering through the QLineEdit"""
        
        query = utils_giswater.getWidgetText(dialog, text_line, return_string_null=False).lower()
        sql = ("SELECT * FROM " + self.schema_name + "." + tableleft + " WHERE " + name + " NOT IN "
               "(SELECT " + tableleft + "." + name + " FROM " + self.schema_name + "." + tableleft + ""
               " RIGHT JOIN " + self.schema_name + "." + tableright + ""
               " ON " + tableleft + "." + field_id_l + " = " + tableright + "." + field_id_r + ""
               " WHERE cur_user = current_user) AND LOWER(" + name + "::text) LIKE '%" + query + "%'")
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
                    

    def check_expression(self, expr_filter, log_info=False):
        """ Check if expression filter @expr_filter is valid """
        
        if log_info:
            self.controller.log_info(expr_filter)
        expr = QgsExpression(expr_filter)
        if expr.hasParserError():
            message = "Expression Error"
            self.controller.log_warning(message, parameter=expr_filter)      
            return (False, expr)
        return (True, expr)               
        

    def refresh_map_canvas(self, restore_cursor=False):
        """ Refresh all layers present in map canvas """
        
        self.canvas.refreshAllLayers()
        for layer_refresh in self.canvas.layers():
            layer_refresh.triggerRepaint()

        if restore_cursor:
            self.set_cursor_restore() 


    def set_cursor_wait(self):
        """ Change cursor to 'WaitCursor' """
        QApplication.setOverrideCursor(Qt.WaitCursor)
            
            
    def set_cursor_restore(self):
        """ Restore to previous cursors """
        QApplication.restoreOverrideCursor() 
        
        
    def get_cursor_multiple_selection(self):
        """ Set cursor for multiple selection """
        
        path_folder = os.path.join(os.path.dirname(__file__), os.pardir) 
        path_cursor = os.path.join(path_folder, 'icons', '201.png')                
        if os.path.exists(path_cursor):      
            cursor = QCursor(QPixmap(path_cursor))    
        else:        
            cursor = QCursor(Qt.ArrowCursor)  
                
        return cursor        
                    
                
    def set_table_columns(self, dialog, widget, table_name):
        """ Configuration of tables. Set visibility and width of columns """

        widget = utils_giswater.getWidget(dialog, widget)
        if not widget:
            return

        # Set width and alias of visible columns
        columns_to_delete = []
        sql = ("SELECT column_index, width, alias, status"
               " FROM " + self.schema_name + ".config_client_forms"
               " WHERE table_id = '" + table_name + "'"
               " ORDER BY column_index")
        rows = self.controller.get_rows(sql, log_info=False)
        if not rows:
            return

        for row in rows:
            if not row['status']:
                columns_to_delete.append(row['column_index'] - 1)
            else:
                width = row['width']
                if width is None:
                    width = 100
                widget.setColumnWidth(row['column_index'] - 1, width)
                widget.model().setHeaderData(row['column_index'] - 1, Qt.Horizontal, row['alias'])

        # Set order
        # widget.model().setSort(0, Qt.AscendingOrder)
        widget.model().select()

        # Delete columns
        for column in columns_to_delete:
            widget.hideColumn(column)


    def connect_signal_selection_changed(self, option):
        """ Connect signal selectionChanged """
            
        try:            
            if option == "mincut_connec":
                self.canvas.selectionChanged.connect(partial(self.snapping_selection_connec))                 
            elif option == "mincut_hydro":
                self.canvas.selectionChanged.connect(partial(self.snapping_selection_hydro))                 
        except Exception:    
            pass
    
    
    def disconnect_signal_selection_changed(self):
        """ Disconnect signal selectionChanged """
        
        try:                     
            self.canvas.selectionChanged.disconnect()  
        except Exception:                     
            pass


    def set_label_current_psector(self, dialog):

        sql = ("SELECT t1.name FROM " + self.schema_name + ".plan_psector AS t1 "
               " INNER JOIN " + self.schema_name + ".config_param_user AS t2 ON t1.psector_id::text = t2.value "
               " WHERE t2.parameter='psector_vdefault' AND cur_user = current_user")
        row = self.controller.get_row(sql)
        if not row:
            return
        utils_giswater.setWidgetText(dialog, 'lbl_vdefault_psector', row[0])


    def multi_rows_delete(self, widget, table_name, column_id):
        """ Delete selected elements of the table
        :param QTableView widget: origin
        :param table_name: table origin
        :param column_id: Refers to the id of the source table
        """

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        inf_text = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = widget.model().record(row).value(str(column_id))
            inf_text += str(id_) + ", "
            list_id = list_id + "'" + str(id_) + "', "
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        message = "Are you sure you want to delete these records?"
        title = "Delete records"
        answer = self.controller.ask_question(message, title, inf_text)
        if answer:
            sql = "DELETE FROM " + self.schema_name + "." + table_name
            sql += " WHERE " + column_id + " IN (" + list_id + ")"
            self.controller.execute_sql(sql)
            widget.model().select()


    def select_features_by_expr(self, layer, expr):
        """ Select features of @layer applying @expr """

        if expr is None:
            layer.removeSelection()
        else:
            it = layer.getFeatures(QgsFeatureRequest(expr))
            # Build a list of feature id's from the previous result and select them
            id_list = [i.id() for i in it]
            if len(id_list) > 0:
                layer.selectByIds(id_list)
            else:
                layer.removeSelection()


    def zoom_to_selected_features(self, layer, geom_type=None, zoom=None):
        """ Zoom to selected features of the @layer with @geom_type """

        if not layer:
            return

        self.iface.setActiveLayer(layer)
        self.iface.actionZoomToSelected().trigger()

        if geom_type:

            # Set scale = scale_zoom
            if geom_type in ('node', 'connec', 'gully'):
                scale = self.scale_zoom

            # Set scale = max(current_scale, scale_zoom)
            elif geom_type == 'arc':
                scale = self.iface.mapCanvas().scale()
                if int(scale) < int(self.scale_zoom):
                    scale = self.scale_zoom
            else:
                scale = 5000

            if zoom is not None:
                scale = zoom

            self.iface.mapCanvas().zoomScale(float(scale))


    def set_completer(self, tablename, widget, field_search, color='black'):
        """ Set autocomplete of widget @table_object + "_id"
            getting id's from selected @table_object
        """

        if not widget:
            return

        # Set SQL
        sql = ("SELECT DISTINCT(" + field_search + ")"
               " FROM " + self.schema_name + "." + tablename + ""
               " ORDER BY " + field_search + "")
        row = self.controller.get_rows(sql)

        for i in range(0, len(row)):
            aux = row[i]
            row[i] = str(aux[0])

        # Set completer and model: add autocomplete in the widget
        self.completer = QCompleter()
        self.completer.setCaseSensitivity(Qt.CaseInsensitive)
        self.completer.setCompletionMode(0)
        self.completer.popup().setStyleSheet("color: "+color+";")
        widget.setCompleter(self.completer)

        model = QStringListModel()
        model.setStringList(row)
        self.completer.setModel(model)
        
        
    def get_snapper(self):
        """ Return snapper """
        
        snapper = None
        try:
            if Qgis.QGIS_VERSION_INT >= 20000 and Qgis.QGIS_VERSION_INT < 29900:
                snapper = QgsMapCanvasSnapper(self.canvas)
            else:
                # TODO: 3.x
                #snapper = QgsMapCanvas.snappingUtils()
                snapper = None
        except:
            pass
        
        return snapper


    def disconect_xyCoordinates(self):
        if hasattr(self, 'xyCoordinates_conected'):
            if self.xyCoordinates_conected:
                self.canvas.xyCoordinates.disconnect()
                self.xyCoordinates_conected = None


