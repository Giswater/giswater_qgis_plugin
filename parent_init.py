"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from qgis.core import QgsExpression, QgsFeatureRequest, QgsPoint
from qgis.utils import iface
from qgis.gui import QgsMessageBar, QgsMapCanvasSnapper, QgsMapToolEmitPoint
from PyQt4.Qt import QDate, QDateTime
from PyQt4.QtCore import QSettings, Qt, QPoint
from PyQt4.QtGui import QLabel, QComboBox, QDateEdit, QDateTimeEdit, QPushButton, QLineEdit, QIcon, QWidget, QDialog, QTextEdit
from PyQt4.QtGui import QAction, QAbstractItemView, QCompleter, QStringListModel, QIntValidator, QDoubleValidator
from PyQt4.QtSql import QSqlTableModel

from functools import partial
from datetime import datetime
import os
import sys  
import urlparse
import webbrowser

import utils_giswater
from dao.controller import DaoController
from init.add_sum import Add_sum
from ui.ws_catalog import WScatalog
from ui.ud_catalog import UDcatalog
from actions.manage_document import ManageDocument
from actions.manage_element import ManageElement
from models.sys_feature_cat import SysFeatureCat
from models.man_addfields_parameter import ManAddfieldsParameter


class ParentDialog(QDialog):   
    
    def __init__(self, dialog, layer, feature):
        """ Constructor class """  
        
        self.dialog = dialog
        self.layer = layer
        self.feature = feature  
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.layer_tablename = None        
        self.init_config()     
        self.set_signals()    
        
        # Set default encoding 
        reload(sys)
        sys.setdefaultencoding('utf-8')   #@UndefinedVariable    
    
        QDialog.__init__(self)        

        
    def init_config(self):    
     
        # Initialize plugin directory
        cur_path = os.path.dirname(__file__)
        self.plugin_dir = os.path.abspath(cur_path)
        self.plugin_name = os.path.basename(self.plugin_dir) 

        # Get config file
        setting_file = os.path.join(self.plugin_dir, 'config', self.plugin_name+'.config')
        if not os.path.isfile(setting_file):
            message = "Config file not found at: "+setting_file
            self.iface.messageBar().pushMessage(message, QgsMessageBar.WARNING, 20)  
            self.close_dialog()
            return
            
        # Set plugin settings
        self.settings = QSettings(setting_file, QSettings.IniFormat)
        self.settings.setIniCodec(sys.getfilesystemencoding())
        
        # Set QGIS settings. Stored in the registry (on Windows) or .ini file (on Unix) 
        self.qgis_settings = QSettings()
        self.qgis_settings.setIniCodec(sys.getfilesystemencoding())  
        
        # Set controller to handle settings and database connection
        self.controller = DaoController(self.settings, self.plugin_name, iface)
        self.controller.plugin_dir = self.plugin_dir
        self.controller.set_qgis_settings(self.qgis_settings)  
        status = self.controller.set_database_connection()      
        if not status:
            message = self.controller.last_error
            self.controller.show_warning(message) 
            return 
             
        # Manage locale and corresponding 'i18n' file
        self.controller.manage_translation(self.plugin_name)
         
        # Load QGIS settings related with dialog position and size            
        #self.load_settings(self.dialog)        

        # Get schema_name and DAO object                
        self.schema_name = self.controller.schema_name  
        self.project_type = self.controller.get_project_type()
        
        # Get viewname of selected layer
        self.layer_tablename = self.controller.get_layer_source_table_name(self.layer)
        
        self.btn_save_custom_fields = None
     
       
    def load_default(self):
        """ Load default user values from table 'config_param_user' """
        
        # Builddate
        sql = ("SELECT value FROM " + self.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND parameter = 'builtdate_vdefault'")
        row = self.controller.get_row(sql)
        if row:
            date_value = datetime.strptime(row[0], '%Y-%m-%d')
        else:
            date_value = QDateTime.currentDateTime()
        utils_giswater.setCalendarDate("builtdate", date_value)

        # Exploitation
        sql = ("SELECT name FROM " + self.schema_name + ".exploitation WHERE expl_id::text = "
               "(SELECT value FROM " + self.schema_name + ".config_param_user WHERE parameter = 'exploitation_vdefault')::text")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText("expl_id", str(row[0]))

        # State
        sql = ("SELECT name FROM " + self.schema_name + ".value_state WHERE id::text = "
               "(SELECT value FROM " + self.schema_name + ".config_param_user WHERE parameter = 'state_vdefault')::text")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText("state", str(row[0]))

        # Verified
        sql = ("SELECT value FROM " + self.schema_name + ".config_param_user"
               " WHERE parameter = 'verified_vdefault' and cur_user = current_user")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText("verified", str(row[0]))


    def load_type_default(self, widget, cat_id):

        sql = ("SELECT value FROM " + self.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND parameter = '" + str(cat_id) + "'")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(widget, str(row[0]))


    def set_signals(self):
        
        try:
            self.dialog.parent().accepted.connect(self.save)
            self.dialog.parent().rejected.connect(self.reject_dialog)
        except:
            pass
        
            
    def translate_form(self, context_name):
        """ Translate widgets of the form to current language """
        # Get objects of type: QLabel
        widget_list = self.dialog.findChildren(QLabel)
        for widget in widget_list:
            self.translate_widget(context_name, widget)
            
            
    def translate_widget(self, context_name, widget):
        """ Translate widget text """
        if widget:
            widget_name = widget.objectName()
            text = self.controller.tr(widget_name, context_name)
            if text != widget_name:
                widget.setText(text)         
         
                
    def save(self, commit=True):
        """ Save feature """
        
        # Save and close dialog    
        self.dialog.save()      
        self.iface.actionSaveEdits().trigger()           
        self.close_dialog()
        
        if commit:
            # Commit changes and show error details to the user (if any)     
            status = self.iface.activeLayer().commitChanges()
            if not status:
                self.parse_commit_error_message()
    
    
    def parse_commit_error_message(self):       
        """ Parse commit error message to make it more readable """
        
        msg = self.iface.activeLayer().commitErrors()
        if 'layer not editable' in msg:                
            return
        
        main_text = msg[0][:-1]
        error_text = msg[2].lstrip()
        error_pos = error_text.find("ERROR")
        detail_text_1 = error_text[:error_pos-1] + "\n\n"
        context_pos = error_text.find("CONTEXT")    
        detail_text_2 = error_text[error_pos:context_pos-1] + "\n"   
        detail_text_3 = error_text[context_pos:]
        detail_text = detail_text_1 + detail_text_2 + detail_text_3
        self.controller.show_warning_detail(main_text, detail_text)    
        

    def close_dialog(self):
        """ Close form """ 
        self.set_action_identify()
        self.controller.plugin_settings_set_value("check_topology_node", "0")        
        self.controller.plugin_settings_set_value("check_topology_arc", "0")        
        self.controller.plugin_settings_set_value("close_dlg", "0")           
        self.save_settings(self.dialog)     
        self.dialog.parent().setVisible(False)  
        
        
    def set_action_identify(self):
        """ Set action 'Identify' """  
        try:
            self.iface.actionIdentify().trigger()     
        except Exception:          
            pass           
        
        
    def reject_dialog(self, close=False):
        """ Reject dialog without saving """ 
        self.set_action_identify()        
        self.controller.plugin_settings_set_value("check_topology_node", "0")        
        self.controller.plugin_settings_set_value("check_topology_arc", "0")        
        self.controller.plugin_settings_set_value("close_dlg", "0")                           
        if close:
            self.dialog.parent().setVisible(False)         
        

    def load_settings(self, dialog=None):
        """ Load QGIS settings related with dialog position and size """
         
        if dialog is None:
            dialog = self.dialog
                    
        key = self.layer.name()                    
        width = self.controller.plugin_settings_value(key + "_width", dialog.parent().width())
        height = self.controller.plugin_settings_value(key + "_height", dialog.parent().height())
        x = self.controller.plugin_settings_value(key + "_x")
        y = self.controller.plugin_settings_value(key + "_y")                                    
        if x == "" or y == "":
            dialog.resize(width, height)
        else:
            dialog.setGeometry(x, y, width, height)
            
            
    def save_settings(self, dialog=None):
        """ Save QGIS settings related with dialog position and size """
                
        if dialog is None:
            dialog = self.dialog
            
        key = self.layer.name()         
        self.controller.plugin_settings_set_value(key + "_width", dialog.parent().width())
        self.controller.plugin_settings_set_value(key + "_height", dialog.parent().height())
        self.controller.plugin_settings_set_value(key + "_x", dialog.parent().pos().x())
        self.controller.plugin_settings_set_value(key + "_y", dialog.parent().pos().y())                     
        
        
    def set_model_to_table(self, widget, table_name, expr_filter): 
        """ Set a model with selected filter.
        Attach that model to selected table """

        # Set model
        model = QSqlTableModel();
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)        
        model.setFilter(expr_filter)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())      

        # Attach model to table view
        if widget:
            widget.setModel(model)   
        else:
            self.controller.log_info("set_model_to_table: widget not found") 
        
        
    def manage_document(self):
        """ Execute action of button 34 """
                
        manage_document = ManageDocument(self.iface, self.settings, self.controller, self.plugin_dir)          
        manage_document.manage_document()
        self.set_completer_object(self.table_object)                 
        
        
    def manage_element(self):
        """ Execute action of button 33 """
                
        manage_element = ManageElement(self.iface, self.settings, self.controller, self.plugin_dir)          
        manage_element.manage_element()
        self.set_completer_object(self.table_object)                    
                
        
    def delete_records(self, widget, table_name):
        """ Delete selected objects (elements or documents) of the @widget """

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()   
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message) 
            return
        
        inf_text = ""
        list_object_id = ""
        row_index = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            object_id = widget.model().record(row).value("doc_id")
            id_ = widget.model().record(row).value("id")
            if object_id is None:
                object_id = widget.model().record(row).value("element_id")
            inf_text += str(object_id)+", "
            list_id += str(id_)+", "
            list_object_id = list_object_id+str(object_id)+", "
            row_index += str(row+1)+", "
            
        row_index = row_index[:-2]
        inf_text = inf_text[:-2]
        list_object_id = list_object_id[:-2]
        list_id = list_id[:-2]
  
        message = "Are you sure you want to delete these records?"
        answer = self.controller.ask_question(message, "Delete records", list_object_id)
        if answer:
            sql = ("DELETE FROM " + self.schema_name + "." + table_name + ""
                   " WHERE id::integer IN (" + list_id + ")")
            self.controller.execute_sql(sql, log_sql=True)
            widget.model().select()
 
         
    def delete_records_hydro(self, widget):
        """ Delete selected elements of the table """

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()    
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message) 
            return
        
        inf_text = ""
        list_id = ""
        row_index = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = widget.model().record(row).value("hydrometer_id")
            inf_text+= str(id_)+", "
            list_id = list_id+"'"+str(id_)+"', "
            row_index += str(row+1)+", "
            
        row_index = row_index[:-2]
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]

        message = "Are you sure you want to delete these records?"
        answer = self.controller.ask_question(message, "Delete records", list_id)
        table_name = '"rtc_hydrometer_x_connec"'
        table_name2 = '"rtc_hydrometer"'
        if answer:
            sql = ("DELETE FROM " + self.schema_name + "." + table_name + ""
                   " WHERE hydrometer_id IN ("+list_id+")")
            self.controller.execute_sql(sql)
            sql = ("DELETE FROM " + self.schema_name + "." + table_name2 + ""
                   " WHERE hydrometer_id IN ("+list_id+")")
            self.controller.execute_sql(sql)
            widget.model().select()
            
                   
    def insert_records(self):
        """ Insert value Hydrometer | Hydrometer"""
        
        # Create the dialog and signals
        self.dlg_sum = Add_sum()
        utils_giswater.setDialog(self.dlg_sum)
        
        # Set signals
        self.dlg_sum.findChild(QPushButton, "btn_accept").clicked.connect(self.btn_accept)
        self.dlg_sum.findChild(QPushButton, "btn_close").clicked.connect(self.btn_close)
        
        # Open the dialog
        self.dlg_sum.exec_() 
        
        
    def btn_accept(self):
        """ Save new value oh hydrometer"""
  
        # Get widget text - hydtometer_id
        widget_hydro = self.dlg_sum.findChild(QLineEdit, "hydrometer_id_new")          
        self.hydro_id = widget_hydro.text()

        # Get connec_id       
        widget_connec = self.dialog.findChild(QLineEdit, "connec_id")          
        self.connec_id = widget_connec.text()

        # Check if Hydrometer_id already exists
        sql = "SELECT DISTINCT(hydrometer_id) FROM "+self.schema_name+".rtc_hydrometer WHERE hydrometer_id = '"+self.hydro_id+"'" 
        row = self.controller.get_row(sql)
        if row:
        # if exist - show warning
            self.controller.show_info_box("Hydrometer_id "+self.hydro_id+" exist in data base!", "Info")
        else:
        # in not exist insert hydrometer_id
            # if not exist - insert new Hydrometer id
            # Insert hydrometer_id in v_rtc_hydrometer
            sql = "INSERT INTO "+self.schema_name+".rtc_hydrometer (hydrometer_id) "
            sql+= " VALUES ('"+self.hydro_id+"')"
            self.controller.execute_sql(sql) 
            
            # insert hydtometer_id and connec_id in rtc_hydrometer_x_connec
            sql = "INSERT INTO "+self.schema_name+".rtc_hydrometer_x_connec (hydrometer_id, connec_id) "
            sql+= " VALUES ('"+self.hydro_id+"','"+self.connec_id+"')"
            self.controller.execute_sql(sql) 
        
            # Refresh table in Qtableview
            # Fill tab Hydrometer
            table_hydrometer = "v_rtc_hydrometer"
            self.fill_tbl_hydrometer(self.tbl_hydrometer, self.schema_name+"."+table_hydrometer, self.filter)
          
            self.dlg_sum.close_dialog()
                
              
    def btn_close(self):
        """ Close form without saving """
        self.dlg_sum.close_dialog()
          
    
    def open_selected_document_event(self):
        """ Get value from selected cell ("PATH")
        Open the document """ 
        
        # Check if clicked value is from the column "PATH"
        position_column = self.tbl_event.currentIndex().column()
        if position_column == 7:      
            # Get data from address in memory (pointer)
            self.path = self.tbl_event.selectedIndexes()[0].data()

            sql = "SELECT value FROM "+self.schema_name+".config_param_system"
            sql += " WHERE parameter = 'om_visit_absolute_path'"
            row = self.controller.get_row(sql)
            if not row:
                message = "Parameter not set in table 'config_param_system'"
                self.controller.show_warning(message, parameter='om_visit_absolute_path')
                return
            
            # Full path= path + value from row
            self.full_path = row[0]+self.path
            
            # Parse a URL into components
            url = urlparse.urlsplit(self.full_path)
        
            # Check if path is URL
            if url.scheme == "http":
                # If path is URL open URL in browser
                webbrowser.open(self.full_path) 
            else: 
                # If its not URL ,check if file exist
                if not os.path.exists(self.full_path):
                    message = "File not found!"
                    self.controller.show_warning(message)
                else:
                    # Open the document
                    os.startfile(self.full_path)          

                    
    def open_selected_document(self, widget):
        """ Open selected document of the @widget """
        
        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()    
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message) 
            return
        
        inf_text = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = widget.model().record(row).value("path")
            inf_text+= str(id_) + ", "
        inf_text = inf_text[:-2]
        path_relative = inf_text 
        
        # Get 'doc_absolute_path' from table 'config_param_system'
        sql = ("SELECT value FROM " + self.schema_name + ".config_param_system"
               " WHERE parameter = 'doc_absolute_path'")
        row = self.controller.get_row(sql)
        if row is None:
            message = "Parameter not set in table 'config_param_system'"
            self.controller.show_warning(message, parameter='doc_absolute_path')
            return
    
        # Parse a URL into components
        path_absolute = row[0] + path_relative
        self.controller.log_info(path_absolute)        
        url = urlparse.urlsplit(path_absolute)

        # Check if path is URL
        if url.scheme == "http":
            # If path is URL open URL in browser
            webbrowser.open(path_absolute) 
        else: 
            # Check if 'path_absolute' exists
            if os.path.exists(path_absolute):
                os.startfile(path_absolute)    
            else:
                # Check if 'path_relative' exists
                if os.path.exists(path_relative):
                    os.startfile(path_relative)    
                else:
                    message = "File not found"
                    self.controller.show_warning(message, parameter=path_absolute)
        
        
    def set_filter_table_man(self, widget):
        """ Get values selected by the user and sets a new filter for its table model """
        
        # Get selected dates
        date_from = self.date_document_from.date().toString('yyyyMMdd') 
        date_to = self.date_document_to.date().toString('yyyyMMdd') 
        if (date_from > date_to):
            message = "Selected date interval is not valid"
            self.controller.show_warning(message)                   
            return
        
        # Set filter
        expr = self.field_id+" = '"+self.id+"'"
        expr+= " AND date >= '"+date_from+"' AND date <= '"+date_to+"'"
        
        # Get selected values in Comboboxes        
        doc_type_value = utils_giswater.getWidgetText("doc_type")
        if doc_type_value != 'null': 
            expr+= " AND doc_type = '"+doc_type_value+"'"
        doc_tag_value = utils_giswater.getWidgetText("doc_tag")
        if doc_tag_value != 'null': 
            expr+= " AND tagcat_id = '"+doc_tag_value+"'"
  
        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()  
        
        
    def set_configuration(self, widget, table_name):
        """ Configuration of tables. Set visibility and width of columns """
        
        widget = utils_giswater.getWidget(widget)
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
                columns_to_delete.append(row['column_index']-1)
            else:
                width = row['width']
                if width is None:
                    width = 100
                widget.setColumnWidth(row['column_index']-1, width)
                widget.model().setHeaderData(row['column_index']-1, Qt.Horizontal, row['alias'])
    
        # Set order
        widget.model().setSort(0, Qt.AscendingOrder)    
        widget.model().select()

        # Delete columns        
        for column in columns_to_delete:
            widget.hideColumn(column) 
        
        
    def fill_tbl_document_man(self, widget, table_name, expr_filter):
        """ Fill the table control to show documents """
        
        # Get widgets  
        widget.setSelectionBehavior(QAbstractItemView.SelectRows)        
        self.doc_id = self.dialog.findChild(QLineEdit, "doc_id")             
        doc_type = self.dialog.findChild(QComboBox, "doc_type")
        date_document_to = self.dialog.findChild(QDateEdit, "date_document_to")
        date_document_from = self.dialog.findChild(QDateEdit, "date_document_from")
        btn_open_doc = self.dialog.findChild(QPushButton, "btn_open_doc")
        btn_doc_delete = self.dialog.findChild(QPushButton, "btn_doc_delete")         
        btn_doc_insert = self.dialog.findChild(QPushButton, "btn_doc_insert")         
        btn_doc_new = self.dialog.findChild(QPushButton, "btn_doc_new")         
 
        # Set signals
        doc_type.activated.connect(partial(self.set_filter_table_man, widget))
        date_document_to.dateChanged.connect(partial(self.set_filter_table_man, widget))
        date_document_from.dateChanged.connect(partial(self.set_filter_table_man, widget))
        self.tbl_document.doubleClicked.connect(partial(self.open_selected_document, widget))
        btn_open_doc.clicked.connect(partial(self.open_selected_document, widget)) 
        btn_doc_delete.clicked.connect(partial(self.delete_records, widget, table_name))            
        btn_doc_insert.clicked.connect(partial(self.add_object, widget, "doc"))            
        btn_doc_new.clicked.connect(self.manage_document)            

        # Set dates
        date = QDate.currentDate()
        date_document_to.setDate(date)
        
        # Fill ComboBox doc_type
        sql = ("SELECT id"
               " FROM " + self.schema_name + ".doc_type"
               " ORDER BY id")
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("doc_type", rows)
        
        # Set model of selected widget
        table_name = self.schema_name + "." + table_name   
        self.set_model_to_table(widget, table_name, expr_filter)
        
        # Adding auto-completion to a QLineEdit
        self.table_object = "doc"        
        self.set_completer_object(self.table_object)        
        
        
    def set_completer_object(self, table_object):
        """ Set autocomplete of widget @table_object + "_id" 
            getting id's from selected @table_object 
        """
        
        widget = utils_giswater.getWidget(table_object + "_id")
        if not widget:
            return
        
        # Set SQL
        field_object_id = "id"
        if table_object == "element":
            field_object_id = table_object + "_id"
        sql = ("SELECT DISTINCT(" + field_object_id + ")"
               " FROM " + self.schema_name + "." + table_object)
        row = self.controller.get_rows(sql)
        for i in range(0, len(row)):
            aux = row[i]
            row[i] = str(aux[0])

        # Set completer and model: add autocomplete in the widget
        self.completer = QCompleter()
        widget.setCompleter(self.completer)
        model = QStringListModel()
        model.setStringList(row)
        self.completer.setModel(model)        
    
    
    def add_object(self, widget, table_object):
        """ Add object (document or element) to selected feature """
        
        # Get values from dialog
        field_object_id = table_object + "_id"
        object_id = utils_giswater.getWidgetText(field_object_id)
        if object_id == 'null':
            message = "You need to insert " + str(field_object_id)
            self.controller.show_warning(message)
            return
        
        # Check if this document is already associated to current feature
        tablename = table_object + "_x_" + self.geom_type
        sql = ("SELECT *"
               " FROM " + self.schema_name + "." + tablename + ""
               " WHERE " + self.field_id + " = '" + self.id + "'"
               " AND " + field_object_id + " = '" + object_id + "'")
        row = self.controller.get_row(sql, log_info=False, log_sql=True)
        
        # If object already exist show warning message
        if row:
            message = "Object already associated with this feature"
            self.controller.show_warning(message)

        # If object not exist perform an INSERT
        else:
            sql = ("INSERT INTO " + self.schema_name + "." + tablename + ""
                   "(" + field_object_id + ", " + self.field_id + ")"
                   " VALUES ('" + str(object_id) + "', '" + str(self.id) + "');")
            self.controller.execute_sql(sql, log_sql=True)
            widget.model().select()        
            
            
    def fill_tbl_element_man(self, widget, table_name, expr_filter):
        """ Fill the table control to show elements """
        
        # Get widgets  
        widget.setSelectionBehavior(QAbstractItemView.SelectRows)        
        self.element_id = self.dialog.findChild(QLineEdit, "element_id")             
        open_element = self.dialog.findChild(QPushButton, "open_element")
        btn_delete = self.dialog.findChild(QPushButton, "btn_delete")         
        btn_insert = self.dialog.findChild(QPushButton, "btn_insert")         
        new_element = self.dialog.findChild(QPushButton, "new_element")         
 
        # Set signals
        self.tbl_element.doubleClicked.connect(partial(self.open_selected_element, widget))
        open_element.clicked.connect(partial(self.open_selected_element, widget)) 
        btn_delete.clicked.connect(partial(self.delete_records, widget, table_name))            
        btn_insert.clicked.connect(partial(self.add_object, widget, "element"))            
        new_element.clicked.connect(self.manage_element)            
        
        # Set model of selected widget
        table_name = self.schema_name + "." + table_name   
        self.set_model_to_table(widget, table_name, expr_filter)
        
        # Adding auto-completion to a QLineEdit
        self.table_object = "element"        
        self.set_completer_object(self.table_object)   
                    

    def open_selected_element(self, widget):  
        """ Open form of selected element of the @widget?? """  
            
        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()    
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message) 
            return
              
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            element_id = widget.model().record(row).value("element_id")
            break
        
        # Get feature with selected element_id
        expr_filter = "element_id = "
        expr_filter += "'" + str(element_id) + "'"    
        (is_valid, expr) = self.check_expression(expr_filter)   #@UnusedVariable       
        if not is_valid:
            return     
  
        # Get layer 'element'
        layer = self.controller.get_layer_by_tablename("element", log_info=True)
        if not layer:
            return
        
        # Get a featureIterator from this expression:     
        it = layer.getFeatures(QgsFeatureRequest(expr))
        id_list = [i for i in it]
        if id_list:
            self.iface.openFeatureForm(layer, id_list[0])        
        
        
    def check_expression(self, expr_filter, log_info=False):
        """ Check if expression filter @expr is valid """
        
        if log_info:
            self.controller.log_info(expr_filter)
        expr = QgsExpression(expr_filter)
        if expr.hasParserError():
            message = "Expression Error"
            self.controller.log_warning(message, parameter=expr_filter)      
            return (False, expr)
        return (True, expr)
            
             
    def fill_tbl_event(self, widget, table_name, filter_):
        """ Fill the table control to show documents """
        
        table_name_event_id = self.schema_name + ".om_visit_parameter"
        
        # Get widgets  
        event_type = self.dialog.findChild(QComboBox, "event_type")
        event_id = self.dialog.findChild(QComboBox, "event_id")
        self.date_event_to = self.dialog.findChild(QDateEdit, "date_event_to")
        self.date_event_from = self.dialog.findChild(QDateEdit, "date_event_from")
        date = QDate.currentDate()
        self.date_event_to.setDate(date)

        # Set signals
        event_type.activated.connect(partial(self.set_filter_table_event, widget))
        event_id.activated.connect(partial(self.set_filter_table_event2, widget))
        self.date_event_to.dateChanged.connect(partial(self.set_filter_table_event, widget))
        self.date_event_from.dateChanged.connect(partial(self.set_filter_table_event, widget))

        feature_key = self.controller.get_layer_primary_key()
        if feature_key == 'node_id':
            feature_type = 'NODE'
        if feature_key == 'connec_id':
            feature_type = 'CONNEC'
        if feature_key == 'arc_id':
            feature_type = 'ARC'
        if feature_key == 'gully_id':
            feature_type = 'GULLY'

        # Fill ComboBox event_id
        sql = "SELECT DISTINCT(id)"
        sql += " FROM " + table_name_event_id
        sql += " WHERE feature_type = '" + feature_type + "' OR feature_type = 'ALL'"
        sql += " ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("event_id", rows)

        # Fill ComboBox event_type
        sql = "SELECT DISTINCT(parameter_type)"
        sql += " FROM " + table_name_event_id
        sql += " WHERE feature_type = '" + feature_type + "' OR feature_type = 'ALL'"
        sql += " ORDER BY parameter_type"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("event_type", rows)

        # Set model of selected widget
        self.set_model_to_table(widget, table_name, filter_)

        # On doble click open_event_gallery
        """ Button - Open gallery from table event"""


    def set_filter_table_event(self, widget):
        """ Get values selected by the user and sets a new filter for its table model """

        # Get selected dates
        date_from = self.date_event_from.date().toString('yyyyMMdd') 
        date_to = self.date_event_to.date().toString('yyyyMMdd') 
        if date_from > date_to:
            message = "Selected date interval is not valid"
            self.controller.show_warning(message)
            return

        # Cascade filter
        table_name_event_id = self.schema_name+'."om_visit_parameter"'
        event_type_value = utils_giswater.getWidgetText("event_type")
        # Get type of feature
        feature_key = self.controller.get_layer_primary_key()
        if feature_key == 'node_id':
            feature_type = 'NODE'
        if feature_key == 'connec_id':
            feature_type = 'CONNEC'
        if feature_key == 'arc_id':
            feature_type = 'ARC'
        if feature_key == 'gully_id':
            feature_type = 'GULLY'

        # Fill ComboBox event_id
        sql = "SELECT DISTINCT(id)"
        sql += " FROM " + table_name_event_id
        sql += " WHERE (feature_type = '" + feature_type + "' OR feature_type = 'ALL')"
        if event_type_value != 'null':
            sql += " AND parameter_type= '" + event_type_value + "'"
        sql += " ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("event_id", rows)
        # End cascading filter

        # Set filter to model
        expr = self.field_id + " = '" + self.id + "'"
        expr += " AND tstamp >= '" + date_from + "' AND tstamp <= '" + date_to + "'"

        # Get selected values in Comboboxes
        event_type_value = utils_giswater.getWidgetText("event_type")
        if event_type_value != 'null':
            expr+= " AND parameter_type = '" + event_type_value + "'"
        event_id = utils_giswater.getWidgetText("event_id")
        if event_id != 'null': 
            expr += " AND parameter_id = '" + event_id + "'"
            
        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()


    def set_filter_table_event2(self, widget):
        """ Get values selected by the user and sets a new filter for its table model """
        """ Cascading filter """

        # Get selected dates
        date_from = self.date_event_from.date().toString('yyyyMMdd')
        date_to = self.date_event_to.date().toString('yyyyMMdd')
        if (date_from > date_to):
            message = "Selected date interval is not valid"
            self.controller.show_warning(message)
            return

        # Set filter
        expr = self.field_id+" = '"+self.id+"'"
        expr += " AND tstamp >= '"+date_from+"' AND tstamp <= '"+date_to+"'"

        # Get selected values in Comboboxes
        event_type_value = utils_giswater.getWidgetText("event_type")
        if event_type_value != 'null':
            expr+= " AND parameter_type = '" + event_type_value + "'"
        event_id = utils_giswater.getWidgetText("event_id")
        if event_id != 'null':
            expr+= " AND parameter_id = '" + event_id + "'"

        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()


    def fill_tbl_hydrometer(self, widget, table_name, filter_):
        """ Fill the table control to show documents"""

        # Get widgets
        self.date_el_to = self.dialog.findChild(QDateEdit, "date_el_to")
        self.date_el_from = self.dialog.findChild(QDateEdit, "date_el_from")
        date = QDate.currentDate();
        self.date_el_to.setDate(date);

        # Set signals
        self.date_el_to.dateChanged.connect(partial(self.set_filter_hydrometer, widget))
        self.date_el_from.dateChanged.connect(partial(self.set_filter_hydrometer, widget))
        #self.tbl_document.doubleClicked.connect(self.open_selected_document)

        # Set model of selected widget
        self.set_model_to_table(widget, table_name, filter_)


    def set_filter_hydrometer(self, widget):
        """ Get values selected by the user and sets a new filter for its table model """

        # Get selected dates
        date_from = self.date_el_from.date().toString('yyyyMMdd')
        date_to = self.date_el_to.date().toString('yyyyMMdd')
        if (date_from > date_to):
            message = "Selected date interval is not valid"
            self.controller.show_warning(message)
            return

        # Set filter
        expr = self.field_id+" = '"+self.id+"'"
        expr+= " AND date >= '" + date_from + "' AND date <= '" + date_to + "'"

        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()


    def action_centered(self, feature, canvas, layer):
        """ Center map to current feature """
        layer.selectByIds([feature.id()])
        canvas.zoomToSelected(layer)


    def action_zoom_in(self, feature, canvas, layer):
        """ Zoom in """
        layer.selectByIds([feature.id()])
        canvas.zoomToSelected(layer)
        canvas.zoomIn()


    def action_zoom_out(self, feature, canvas, layer):
        """ Zoom out """
        layer.selectByIds([feature.id()])
        canvas.zoomToSelected(layer)
        canvas.zoomOut()


    def action_enabled(self, action, layer):
        """ Enable/Disable edition """

        action_widget = self.dialog.findChild(QAction, "actionCopyPaste")
        if action_widget:
            action_widget.setEnabled(action.isChecked())
        action_widget = self.dialog.findChild(QAction, "actionRotation")
        if action_widget:
            action_widget.setEnabled(action.isChecked())
        if self.btn_save_custom_fields:
            self.btn_save_custom_fields.setEnabled(action.isChecked())

        status = layer.startEditing()
        self.change_status(action, status, layer)


    def change_status(self, action, status, layer):

        if status:
            layer.startEditing()
            action.setActive(True)
        else:
            layer.rollBack()
            

    def catalog(self, wsoftware, geom_type, node_type=None):

        # Set dialog depending water software
        if wsoftware == 'ws':
            self.dlg_cat = WScatalog()
            self.field2 = 'pnom'
            self.field3 = 'dnom'
        elif wsoftware == 'ud':
            self.dlg_cat = UDcatalog()
            self.field2 = 'shape'
            self.field3 = 'geom1'
        utils_giswater.setDialog(self.dlg_cat)
        self.dlg_cat.open()
        self.dlg_cat.btn_ok.pressed.connect(partial(self.fill_geomcat_id, geom_type))
        self.dlg_cat.btn_cancel.pressed.connect(self.dlg_cat.close)
        self.dlg_cat.matcat_id.currentIndexChanged.connect(partial(self.fill_catalog_id, wsoftware, geom_type))
        self.dlg_cat.matcat_id.currentIndexChanged.connect(partial(self.fill_filter2, wsoftware, geom_type))
        self.dlg_cat.matcat_id.currentIndexChanged.connect(partial(self.fill_filter3, wsoftware, geom_type))
        self.dlg_cat.filter2.currentIndexChanged.connect(partial(self.fill_catalog_id, wsoftware, geom_type))
        self.dlg_cat.filter2.currentIndexChanged.connect(partial(self.fill_filter3, wsoftware, geom_type))
        self.dlg_cat.filter3.currentIndexChanged.connect(partial(self.fill_catalog_id, wsoftware, geom_type))

        self.node_type_text = None
        if wsoftware == 'ws' and geom_type == 'node':
            self.node_type_text = node_type
        sql = "SELECT DISTINCT(matcat_id) AS matcat_id "
        sql += " FROM "+self.schema_name+".cat_"+geom_type
        if wsoftware == 'ws' and geom_type == 'node':
            sql += " WHERE "+geom_type+"type_id IN(SELECT DISTINCT (id) AS id FROM " + self.schema_name+"."+geom_type+"_type "
            sql += " WHERE type='"+self.layer.name().upper()+"')"
        sql += " ORDER BY matcat_id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.matcat_id, rows)

        sql = "SELECT DISTINCT("+self.field2+")"
        sql += " FROM "+self.schema_name+".cat_"+geom_type
        if wsoftware == 'ws' and geom_type == 'node':
            sql += " WHERE "+geom_type+"type_id IN(SELECT DISTINCT (id) AS id FROM " + self.schema_name+"."+geom_type+"_type "
            sql += " WHERE type='" + self.layer.name().upper() + "')"
        sql += " ORDER BY "+self.field2
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.filter2, rows)

        if wsoftware == 'ws':
            if geom_type == 'node':
                sql = "SELECT "+self.field3
                sql += " FROM (SELECT DISTINCT(regexp_replace(trim(' nm' FROM "+self.field3+"), '-', '', 'g')::int) as x, "+self.field3
                sql += " FROM "+self.schema_name+".cat_"+geom_type+" WHERE "+self.field2 + " LIKE '%"+self.dlg_cat.filter2.currentText()+"%' "
                sql += " AND matcat_id LIKE '%"+self.dlg_cat.matcat_id.currentText()+"%' AND "+geom_type+"type_id IN "
                sql += "(SELECT id FROM "+self.schema_name+"."+geom_type+"_type WHERE type LIKE '%"+self.layer.name().upper()+"%')"
                sql += " ORDER BY x) AS "+self.field3
            elif geom_type == 'arc':
                sql = "SELECT DISTINCT("+self.field3+"), (trim('mm' from "+self.field3+")::int) AS x, "+self.field3
                sql += " FROM "+self.schema_name+".cat_"+geom_type+" ORDER BY x"
            elif geom_type == 'connec':
                sql = "SELECT DISTINCT(TRIM(TRAILING ' ' from "+self.field3+")) AS "+self.field3
                sql += " FROM "+self.schema_name+".cat_"+geom_type+" ORDER BY "+self.field3
        else:
            if geom_type == 'node':
                sql = "SELECT DISTINCT("+self.field3+") AS "+self.field3
                sql += " FROM "+self.schema_name+".cat_"+geom_type
                sql += " ORDER BY "+self.field3
            elif geom_type == 'arc':
                sql = "SELECT DISTINCT("+self.field3+"), (trim('mm' from "+self.field3+")::int) AS x, "+self.field3
                sql += " FROM "+self.schema_name+".cat_"+geom_type+" ORDER BY x"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.filter3, rows)
        self.fill_catalog_id(wsoftware, geom_type)


    def fill_filter2(self, wsoftware, geom_type):

        # Get values from filters
        mats = utils_giswater.getWidgetText(self.dlg_cat.matcat_id)

        # Set SQL query
        sql_where = None
        sql = "SELECT DISTINCT("+self.field2+")"
        sql += " FROM "+self.schema_name+".cat_"+geom_type

        # Build SQL filter
        if mats != "null":
            if sql_where is None:
                sql_where = " WHERE "
            sql_where += " matcat_id = '"+mats+"'"
        if wsoftware == 'ws':
            if sql_where is None:
                sql_where = " WHERE "
            else:
                sql_where += " AND "
            sql_where += geom_type + "type_id IN(SELECT DISTINCT (id) AS id FROM " + self.schema_name + "." + geom_type + "_type "
            sql_where += " WHERE type='" + self.layer.name().upper() + "')"
        if sql_where is not None:
            sql += str(sql_where)+" ORDER BY " + str(self.field2)
        else:
            sql += " ORDER BY " + str(self.field2)

        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.filter2, rows)
        self.fill_filter3(wsoftware, geom_type)


    def fill_filter3(self, wsoftware, geom_type):

        if wsoftware == 'ws':
            if geom_type == 'node':
                sql = "SELECT "+self.field3
                sql += " FROM (SELECT DISTINCT(regexp_replace(trim(' nm' FROM "+self.field3+"), '-', '', 'g')::int) as x, "+self.field3
                sql += " FROM "+self.schema_name+".cat_"+geom_type
                sql += " WHERE ("+self.field2 + " LIKE '%"+self.dlg_cat.filter2.currentText()+"%' OR "+self.field2 + " is null) "
                sql += " AND (matcat_id LIKE '%"+self.dlg_cat.matcat_id.currentText()+"%' OR matcat_id is null)"
                sql += " AND "+geom_type+"type_id IN "
                sql += "(SELECT id FROM "+self.schema_name+"."+geom_type+"_type WHERE type LIKE '%"+self.layer.name().upper()+"%')"
                sql += " ORDER BY x) AS "+self.field3
            elif geom_type == 'arc':
                sql = "SELECT "+self.field3
                sql += " FROM (SELECT DISTINCT(regexp_replace(trim(' nm' FROM "+self.field3+"), '-', '', 'g')::int) as x, "+self.field3
                sql += " FROM "+self.schema_name+".cat_"+geom_type
                sql += " WHERE "+geom_type+"type_id IN "
                sql += "(SELECT id FROM "+self.schema_name+"."+geom_type+"_type WHERE type LIKE '%"+self.layer.name().upper()+"%')"
                sql += " AND (" + self.field2 + " LIKE '%" + self.dlg_cat.filter2.currentText() + "%' OR " + self.field2 + " is null) "
                sql += " AND (matcat_id LIKE '%" + self.dlg_cat.matcat_id.currentText() + "%' OR matcat_id is null)"
                sql += " ORDER BY x) AS "+self.field3
            elif geom_type == 'connec':
                sql = "SELECT DISTINCT(TRIM(TRAILING ' ' from "+self.field3+")) AS "+self.field3
                sql += " FROM "+self.schema_name+".cat_"+geom_type+" ORDER BY "+self.field3
        else:
            if geom_type == 'node' or geom_type == 'arc':
                sql = "SELECT DISTINCT("+self.field3+") FROM "+self.schema_name+".cat_"+geom_type
                sql += " WHERE (matcat_id LIKE '%"+self.dlg_cat.matcat_id.currentText()+"%' OR matcat_id is null) "
                sql += " AND ("+self.field2+" LIKE '%"+self.dlg_cat.filter2.currentText()+"%' OR "+self.field2 + " is null) "
                sql += " ORDER BY "+self.field3

        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.filter3, rows)
        self.fill_catalog_id(wsoftware, geom_type)


    def fill_catalog_id(self, wsoftware, geom_type):

        # Get values from filters
        mats = utils_giswater.getWidgetText(self.dlg_cat.matcat_id)
        filter2 = utils_giswater.getWidgetText(self.dlg_cat.filter2)
        filter3 = utils_giswater.getWidgetText(self.dlg_cat.filter3)

        # Set SQL query
        sql_where = None
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".cat_"+geom_type

        if wsoftware == 'ws':
            sql_where = " WHERE "+geom_type+"type_id IN(SELECT DISTINCT (id) FROM " + self.schema_name + "."+geom_type+"_type"
            sql_where += " WHERE type='"+self.layer.name().upper()+"')"
        if self.dlg_cat.matcat_id.currentText() != 'null':
            if sql_where is None:
                sql_where = " WHERE "
            else:
                sql_where += " AND "
            sql_where += " (matcat_id LIKE '%"+self.dlg_cat.matcat_id.currentText()+"%' or matcat_id is null)"
        if self.dlg_cat.filter2.currentText() != 'null':
            if sql_where is None:
                sql_where = " WHERE "
            else:
                sql_where += " AND "
            sql_where += "("+self.field2+" LIKE '%"+self.dlg_cat.filter2.currentText()+"%' OR " + self.field2 + " is null)"
        if self.dlg_cat.filter3.currentText() != 'null':
            if sql_where is None:
                sql_where = " WHERE "
            else:
                sql_where += " AND "
            sql_where += "("+self.field3+"::text LIKE '%"+self.dlg_cat.filter3.currentText()+"%' OR " + self.field3 + " is null)"
        if sql_where is not None:
            sql += str(sql_where)+" ORDER BY id"
        else:
            sql += " ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.id, rows)


    def fill_geomcat_id(self, geom_type):
        
        catalog_id = utils_giswater.getWidgetText(self.dlg_cat.id)
        self.dlg_cat.close()
        if geom_type == 'node':
            utils_giswater.setWidgetText(self.nodecat_id, catalog_id)
        elif geom_type == 'arc':
            utils_giswater.setWidgetText(self.arccat_id, catalog_id)
        else:
            utils_giswater.setWidgetText(self.connecat_id, catalog_id)


    def manage_feature_cat(self):

        # Dictionary to keep every record of table 'sys_feature_cat'
        # Key: field tablename. Value: Object of the class SysFeatureCat
        sql = "SELECT * FROM " + self.schema_name + ".sys_feature_cat"
        rows = self.controller.get_rows(sql)
        if not rows:
            return

        for row in rows:
            tablename = row['tablename']
            elem = SysFeatureCat(row['id'], row['type'], row['orderby'], row['tablename'], row['shortcut_key'])
            self.feature_cat[tablename] = elem


    def project_read(self):
        """ Function called every time a QGIS project is loaded """

        # Check if we have any layer loaded
        layers = self.iface.legendInterface().layers()
        if len(layers) == 0:
            return

        self.manage_feature_cat()

        # Iterate over all layers to get the ones specified in 'db' config section
        for cur_layer in layers:
            uri_table = self.controller.get_layer_source_table_name(cur_layer)  # @UnusedVariable
            if uri_table is not None:
                if uri_table in self.feature_cat.keys():
                    elem = self.feature_cat[uri_table]
                    elem.layername = cur_layer.name()


    def set_icon(self, widget, icon):
        """ Set @icon to selected @widget """

        # Get icons folder
        icons_folder = os.path.join(self.plugin_dir, 'icons')
        icon_path = os.path.join(icons_folder, str(icon) + ".png")
        if os.path.exists(icon_path):
            widget.setIcon(QIcon(icon_path))
        else:
            # If not found search in icons/widgets folder
            icons_folder = os.path.join(self.plugin_dir, 'icons', 'widgets')
            icon_path = os.path.join(icons_folder, str(icon) + ".png")
            if os.path.exists(icon_path):
                widget.setIcon(QIcon(icon_path))
            else:
                self.controller.log_info("File not found", parameter=icon_path)


    def action_help(self, wsoftware, geom_type):
        """ Open PDF file with selected @wsoftware and @geom_type """

        # Get locale of QGIS application
        locale = QSettings().value('locale/userLocale').lower()
        if locale == 'es_es':
            locale = 'es'
        elif locale == 'es_ca':
            locale = 'ca'
        elif locale == 'en_us':
            locale = 'en'

        # Get PDF file
        pdf_folder = os.path.join(self.plugin_dir, 'png')
        pdf_path = os.path.join(pdf_folder, wsoftware + "_" + geom_type + "_" + locale + ".pdf")

        # Open PDF if exists. If not open Spanish version
        if os.path.exists(pdf_path):
            os.system(pdf_path)
        else:
            locale = "es"
            pdf_path = os.path.join(pdf_folder, wsoftware + "_" + geom_type + "_" + locale + ".pdf")
            if os.path.exists(pdf_path):
                os.system(pdf_path)
            else:
                self.controller.show_warning("File not found", parameter=pdf_path)


    def manage_custom_fields(self, featurecat_id=None, tab_to_remove=None):
        """ Management of custom fields """

        # Check if corresponding widgets already exists
        self.form_layout_widget = self.dialog.findChild(QWidget, 'widget_form_layout')
        if not self.form_layout_widget:
            self.controller.log_info("widget not found")
            if tab_to_remove is not None:
                self.tab_main.removeTab(tab_to_remove)
            return False

        self.form_layout = self.form_layout_widget.layout()
        if self.form_layout is None:
            self.controller.log_info("layout not found")
            if tab_to_remove is not None:
                self.tab_main.removeTab(tab_to_remove)
            return False

        # Search into table 'man_addfields_parameter' parameters of selected @featurecat_id
        sql = "SELECT * FROM " + self.schema_name + ".man_addfields_parameter"
        if featurecat_id is not None:
            sql += " WHERE featurecat_id = '" + featurecat_id + "' OR featurecat_id IS NULL"
        sql += " ORDER BY id"
        rows = self.controller.get_rows(sql, log_info=False)
        if not rows:
            if tab_to_remove is not None:
                self.tab_main.removeTab(tab_to_remove)
            return False

        # Create a widget for every parameter
        self.parameters = {}
        for row in rows:
            self.manage_widget(row)

        # Add 'Save' button
        self.btn_save_custom_fields = QPushButton()
        self.btn_save_custom_fields.setText("Save")
        self.btn_save_custom_fields.setObjectName("btn_save")
        self.btn_save_custom_fields.clicked.connect(self.save_custom_fields)
        self.btn_save_custom_fields.setEnabled(self.layer.isEditable())
        self.form_layout.addRow(None, self.btn_save_custom_fields)
        
        return True


    def manage_widget(self, row):
        """ Create a widget for every parameter """

        # Create instance of object ManAddfieldsParameter
        parameter = ManAddfieldsParameter(row)
        
        # Check widget type
        if parameter.form_widget == 'QLineEdit':
            widget = QLineEdit()
        elif parameter.form_widget == 'QComboBox':
            widget = QComboBox()
        elif parameter.form_widget == 'QDateEdit':
            widget = QDateEdit()
            widget.setCalendarPopup(True)
        elif parameter.form_widget == 'QDateTimeEdit':
            widget = QDateTimeEdit()
            widget.setCalendarPopup(True)
        else:
            return
        
        # Manage data_type
        if parameter.data_type == 'integer':
            validator = QIntValidator(-9999999, 9999999)
            widget.setValidator(validator)     
        elif parameter.data_type == 'double' or parameter.data_type == 'numeric':
            if parameter.num_decimals is None:              
                parameter.num_decimals = 3    
            validator = QDoubleValidator(-9999999, 9999999, parameter.num_decimals)
            validator.setNotation(QDoubleValidator().StandardNotation)
            widget.setValidator(validator)       
            
        # Manage field_length
        if parameter.field_length and parameter.form_widget == 'QLineEdit':
            widget.setMaxLength(parameter.field_length) 

        # Create label of custom field
        label = QLabel()
        label_text = parameter.form_label
        if parameter.is_mandatory:
            label_text += " *"
        label.setText(label_text)
        widget.setObjectName(parameter.param_name)

        # Check if selected feature has value in table 'man_addfields_value'
        value_param = self.get_param_value(row['id'], self.id)
        if type(widget) is QDateEdit:
            if value_param is None:
                value_param = QDate.currentDate() 
            else:
                value_param = QDate.fromString(value_param, 'yyyy/MM/dd')
            utils_giswater.setCalendarDate(widget, value_param)
        elif type(widget) is QDateTimeEdit:
            if value_param is None:
                value_param = QDateTime.currentDateTime() 
            else:
                value_param = QDateTime.fromString(value_param, 'yyyy/MM/dd hh:mm:ss')
            utils_giswater.setCalendarDate(widget, value_param)
        else: 
            if value_param is None:
                value_param = str(row['default_value'])
            utils_giswater.setWidgetText(widget, value_param)
            
        # Add to parameters dictionary
        parameter.widget = widget
        self.parameters[parameter.id] = parameter

        # Add row with custom label and widget
        self.form_layout.addRow(label, widget)


    def get_param_value(self, parameter_id, feature_id):
        """ Get value_param from selected @parameter_id and @feature_id from table 'man_addfields_value' """

        value_param = None
        sql = ("SELECT value_param FROM " + self.schema_name + ".man_addfields_value"
               " WHERE parameter_id = " + str(parameter_id) + " AND feature_id = '" + str(feature_id) + "'")
        row = self.controller.get_row(sql, log_info=False)
        if row:
            value_param = row[0]

        return value_param


    def save_custom_fields(self):
        """ Save data into table 'man_addfields_value' """

        # Check if all mandatory fields are set
        for parameter_id, parameter in self.parameters.iteritems():
            if parameter.is_mandatory:
                widget = parameter.widget            
                if type(widget) is QDateEdit or type(widget) is QDateTimeEdit:
                    value_param = utils_giswater.getCalendarDate(widget)
                else:            
                    value_param = utils_giswater.getWidgetText(widget)
                if value_param == 'null':  
                    msg = "This paramater is mandatory. Please, set a value"   
                    self.controller.show_warning(msg, parameter=parameter.param_name)
                    return               
                          
        # Delete previous data
        sql = ("DELETE FROM " + self.schema_name + ".man_addfields_value"
               " WHERE feature_id = '" + str(self.id) + "'")
        status = self.controller.execute_sql(sql)
        if not status:
            return

        # Iterate over all widgets and execute one inserts per widget
        for parameter_id, parameter in self.parameters.iteritems():
            widget = parameter.widget
            if type(widget) is QDateEdit or type(widget) is QDateTimeEdit:
                value_param = utils_giswater.getCalendarDate(widget)
            else:            
                value_param = utils_giswater.getWidgetText(widget)
            if value_param != 'null':
                sql = ("INSERT INTO " + self.schema_name + ".man_addfields_value (feature_id, parameter_id, value_param)"
                       " VALUES ('" + str(self.id) + "', " + str(parameter_id) + ", '" + str(value_param) + "');")      
                self.controller.execute_sql(sql, log_sql=True)
                  

    def check_link(self, open_link=False):
        """ Check if exist URL from field 'link' in main tab """
        
        field_link = "link"
        widget = self.tab_main.findChild(QTextEdit, field_link)
        if widget:
            url = utils_giswater.getWidgetText(widget)
            if url == 'null':
                self.dialog.findChild(QAction, "actionLink").setEnabled(False)
            else:
                self.dialog.findChild(QAction, "actionLink").setEnabled(True)
                if open_link:
                    webbrowser.open(url)                 
                
                
    def get_node_from_point(self, point, arc_searchnodes):
        """ Get closest node from selected point """
        
        node = None
        srid = self.controller.plugin_settings_value('srid')        
        geom_point = "ST_SetSRID(ST_Point(" + str(point.x()) + ", " + str(point.y()) + "), " + str(srid) + ")"     
        sql = "SELECT node_id FROM " + self.schema_name + ".v_edit_node" 
        sql += " WHERE ST_DWithin(" + str(geom_point) + ", the_geom, " + str(arc_searchnodes) + ")" 
        sql += " ORDER BY ST_Distance(" + str(geom_point) + ", the_geom) LIMIT 1"           
        row = self.controller.get_row(sql, log_sql=True)  
        if row:
            node = row[0]
        
        return node
    
    
    def get_layer(self, sys_feature_cat_id):
        """ Get layername from dictionary feature_cat given @sys_feature_cat_id """
                             
        if self.feature_cat is None:
            self.controller.log_info("self.feature_cat is None")
            return None
            
        # Iterate over all dictionary
        for feature_cat in self.feature_cat.itervalues():           
            if sys_feature_cat_id == feature_cat.id:
                layer = self.controller.get_layer_by_layername(feature_cat.layername)
                return layer

        return None


    def action_copy_paste(self, geom_type):

        self.set_snapping()
        self.emit_point.canvasClicked.connect(partial(self.manage_snapping, geom_type))


    def set_snapping(self):

        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        self.snapper = QgsMapCanvasSnapper(self.canvas)


    def manage_snapping(self, geom_type, point):

        # Get node of snapping
        map_point = self.canvas.getCoordinateTransform().transform(point)
        x = map_point.x()
        y = map_point.y()
        event_point = QPoint(x, y)

        # Snapping
        (retval, result) = self.snapper.snapToBackgroundLayers(event_point)  # @UnusedVariable

        # That's the snapped point
        if not result:
            self.disable_copy_paste()            
            return
        
        layername = self.iface.activeLayer().name().lower()        
        is_valid = False
        for snapped_point in result:
            # Check that snapped point belongs to active layer
            if snapped_point.layer.name().lower() == layername:
                # Get only one feature
                point = QgsPoint(snapped_point.snappedVertex)  # @UnusedVariable
                snapped_feature = next(snapped_point.layer.getFeatures(QgsFeatureRequest().setFilterFid(snapped_point.snappedAtGeometry)))
                snapped_feature_attr = snapped_feature.attributes()
                # Leave selection
                snapped_point.layer.select([snapped_point.snappedAtGeometry])
                is_valid = True
                break
        
        if not is_valid:
            message = "Any of the snapped features belong to selected layer"
            self.controller.show_info(message, parameter=self.iface.activeLayer().name(), duration=10)
            self.disable_copy_paste()
            return

        aux = "\"" + str(geom_type) + "_id\" = "
        aux += "'" + str(self.id) + "'"
        expr = QgsExpression(aux)
        if expr.hasParserError():
            message = "Expression Error: " + str(expr.parserErrorString())
            self.controller.show_warning(message)
            self.disable_copy_paste()            
            return

        layer = self.iface.activeLayer()
        fields = layer.dataProvider().fields()
        layer.startEditing()
        it = layer.getFeatures(QgsFeatureRequest(expr))
        feature_list = [i for i in it]
        if not feature_list:
            self.disable_copy_paste()            
            return
        
        # Select only first element of the feature list
        feature = feature_list[0]
        feature_id = feature.attribute(str(geom_type) + '_id')
        message = "Selected snapped feature_id to copy values from: " + str(snapped_feature_attr[0]) + "\n"
        message += "Do you want to copy its values to the current node?\n\n"
        # Replace id because we don't have to copy it!
        snapped_feature_attr[0] = feature_id
        snapped_feature_attr_aux = []
        fields_aux = []

        # Iterate over all fields and copy only specific ones
        for i in range(0, len(fields)):
            if fields[i].name() == 'sector_id' or fields[i].name() == 'dma_id' or fields[i].name() == 'expl_id' \
                or fields[i].name() == 'state' or fields[i].name() == 'state_type' \
                or fields[i].name() == layername+'_workcat_id' or fields[i].name() == layername+'_builtdate' \
                or fields[i].name() == 'verified' or fields[i].name() == str(geom_type) + 'cat_id':
                snapped_feature_attr_aux.append(snapped_feature_attr[i])
                fields_aux.append(fields[i].name())
            if self.project_type == 'ud':
                if fields[i].name() == str(geom_type) + '_type':
                    snapped_feature_attr_aux.append(snapped_feature_attr[i])
                    fields_aux.append(fields[i].name())

        for i in range(0, len(fields_aux)):
            message += str(fields_aux[i]) + ": " + str(snapped_feature_attr_aux[i]) + "\n"

        # Ask confirmation question showing fields that will be copied
        answer = self.controller.ask_question(message, "Update records", None)
        if answer:
            for i in range(0, len(fields)):
                for x in range(0, len(fields_aux)):
                    if fields[i].name() == fields_aux[x]:
                        layer.changeAttributeValue(feature.id(), i, snapped_feature_attr_aux[x])

            layer.commitChanges()
            self.dialog.refreshFeature()
            
        self.disable_copy_paste()
            

    def disable_copy_paste(self):
        """ Disable actionCopyPaste and set action 'Identify' """
        
        action_widget = self.dialog.findChild(QAction, "actionCopyPaste")
        if action_widget:
            action_widget.setChecked(False) 
        self.set_action_identify()


    def init_filters(self, dialog):
        """ Init Qcombobox filters and fill with all 'items' if no match """
        exploitation = dialog.findChild(QComboBox, 'expl_id')
        dma = dialog.findChild(QComboBox, 'dma_id')
        self.dmae_items = [dma.itemText(i) for i in range(dma.count())]
        exploitation.currentIndexChanged.connect(partial(self.filter_dma, exploitation, dma))

        state = dialog.findChild(QComboBox, 'state')
        state_type = dialog.findChild(QComboBox, 'state_type')
        self.state_type_items = [state_type.itemText(i) for i in range(state_type.count())]
        state.currentIndexChanged.connect(partial(self.filter_state_type, state, state_type))

        muni_id = dialog.findChild(QComboBox, 'muni_id')
        street_1 = dialog.findChild(QComboBox, 'streetaxis_id')
        street_2 = dialog.findChild(QComboBox, 'streetaxis2_id')
        self.street_items = [street_1.itemText(i) for i in range(street_1.count())]
        muni_id.currentIndexChanged.connect(partial(self.filter_streets, muni_id, street_1))
        muni_id.currentIndexChanged.connect(partial(self.filter_streets, muni_id, street_2))


    def filter_streets(self, muni_id, street):

        self.controller.log_info(str("11111"))
        sql = ("SELECT name FROM "+ self.schema_name + ".ext_streetaxis"
               " WHERE muni_id = (SELECT muni_id FROM " + self.schema_name + ".ext_municipality "
               " WHERE name = '"+utils_giswater.getWidgetText(muni_id)+"')")
        rows = self.controller.get_rows(sql)
        if rows:
            list_items = [rows[i] for i in range(len(rows))]
            utils_giswater.fillComboBox(street, list_items)
        else:
            utils_giswater.fillComboBoxList(street, self.street_items)


    def filter_dma(self,exploitation, dma):
        sql = ("SELECT name FROM "+ self.schema_name + ".dma"
               " WHERE dma_id = (SELECT expl_id FROM " + self.schema_name + ".exploitation "
               " WHERE name = '"+utils_giswater.getWidgetText(exploitation)+"')")
        rows = self.controller.get_rows(sql)
        if rows:
            list_items = [rows[i] for i in range(len(rows))]
            utils_giswater.fillComboBox(dma, list_items)
        else:
            utils_giswater.fillComboBoxList(dma, self.state_type_items)


    def filter_state_type(self, state, state_type):

        sql = ("SELECT name FROM " + self.schema_name + ".value_state_type"
               " WHERE state = (SELECT id FROM " + self.schema_name + ".value_state "
               " WHERE name = '"+utils_giswater.getWidgetText(state)+"')")
        rows = self.controller.get_rows(sql)
        if rows:
            list_items = [rows[i] for i in range(len(rows))]
            utils_giswater.fillComboBox(state_type, list_items)
        else:
            utils_giswater.fillComboBoxList(state_type, self.state_type_items)
        
        