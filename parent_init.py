'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from qgis.utils import iface
from qgis.gui import QgsMessageBar
from PyQt4.Qt import QTableView, QDate
from PyQt4.QtCore import QSettings, Qt
from PyQt4.QtGui import QLabel, QComboBox, QDateEdit, QPushButton, QLineEdit, QIcon
from PyQt4.QtSql import QSqlTableModel

from functools import partial
import os
import sys  
import urlparse
import webbrowser

import utils_giswater
from dao.controller import DaoController
from init.add_sum import Add_sum
from ui.ws_catalog import WScatalog
from ui.ud_catalog import UDcatalog

from models.sys_feature_cat import SysFeatureCat
        

class ParentDialog(object):   
    
    def __init__(self, dialog, layer, feature):
        ''' Constructor class '''     
        self.dialog = dialog
        self.layer = layer
        self.feature = feature  
        self.iface = iface    
        self.init_config()     
        self.set_signals()    
        
        # Set default encoding 
        reload(sys)
        sys.setdefaultencoding('utf-8')   #@UndefinedVariable    
    
        
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
                     
        # Get schema_name and DAO object                
        self.dao = self.controller.dao
        self.schema_name = self.controller.schema_name  
       
        
    def set_signals(self):
        
        try:
            self.dialog.parent().accepted.connect(self.save)
            self.dialog.parent().rejected.connect(self.close_dialog)
        except:
            pass
        
            
    def translate_form(self, context_name):
        ''' Translate widgets of the form to current language '''
        # Get objects of type: QLabel
        widget_list = self.dialog.findChildren(QLabel)
        for widget in widget_list:
            self.translate_widget(context_name, widget)
            
            
    def translate_widget(self, context_name, widget):
        ''' Translate widget text '''
        if widget:
            widget_name = widget.objectName()
            text = self.controller.tr(widget_name, context_name)
            if text != widget_name:
                widget.setText(text)         
         
    
    def load_data(self):
        ''' Load data from related tables '''
        pass
    
                
    def save(self):
        ''' Save feature '''
        self.dialog.save()
        self.close_dialog()     
        layer = self.iface.activeLayer()
        layer.commitChanges()
        
        
    def close_dialog(self):
        ''' Close form without saving ''' 
        self.dialog.parent().setVisible(False)         
        
        
    def set_model_to_table(self, widget, table_name, filter_): 
        ''' Set a model with selected filter.
        Attach that model to selected table '''

        # Set model
        model = QSqlTableModel();
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)        
        model.setFilter(filter_)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())      

        # Attach model to table view
        widget.setModel(model)    
        
        
    def delete_records(self, widget, table_name):
        ''' Delete selected elements of the table '''

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()   
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message' ) 
            return
        
        inf_text = ""
        list_doc_id = ""
        row_index = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            doc_id_ = widget.model().record(row).value("doc_id")
            id_ = widget.model().record(row).value("id")
            if doc_id_ == None:
                doc_id_ = widget.model().record(row).value("element_id")
            inf_text += str(doc_id_)+", "
            list_id += str(id_)+", "
            list_doc_id = list_doc_id+str(doc_id_)+", "
            row_index += str(row+1)+", "
            
        row_index = row_index[:-2]
        inf_text = inf_text[:-2]
        list_doc_id = list_doc_id[:-2]
        list_id = list_id[:-2]
  
        answer = self.controller.ask_question("Are you sure you want to delete these records?", "Delete records", list_doc_id)
        if answer:
            sql = "DELETE FROM "+self.schema_name+"."+table_name 
            sql+= " WHERE id::integer IN ("+list_id+")"
            self.controller.execute_sql(sql)
            widget.model().select()
 
         
    def delete_records_hydro(self, widget):
        ''' Delete selected elements of the table '''

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()    
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message' ) 
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

        answer = self.controller.ask_question("Are you sure you want to delete these records?", "Delete records", list_id)
        table_name = '"rtc_hydrometer_x_connec"'
        table_name2 = '"rtc_hydrometer"'
        if answer:
            sql = "DELETE FROM "+self.schema_name+"."+table_name 
            sql+= " WHERE hydrometer_id IN ("+list_id+")"
            self.controller.execute_sql(sql)

            sql = "DELETE FROM "+self.schema_name+"."+table_name2 
            sql+= " WHERE hydrometer_id IN ("+list_id+")"
            self.controller.execute_sql(sql)
            
            widget.model().select()
            
                   
    def insert_records(self):
        ''' Insert value  Hydrometer | Hydrometer'''
        
        # Create the dialog and signals
        self.dlg_sum = Add_sum()
        utils_giswater.setDialog(self.dlg_sum)
        # Set signals
        self.dlg_sum.findChild(QPushButton, "btn_accept").clicked.connect(self.btn_accept)
        self.dlg_sum.findChild(QPushButton, "btn_close").clicked.connect(self.btn_close)
        
        # Open the dialog
        self.dlg_sum.exec_() 
        
        
    def btn_accept(self):
        ''' Save new value oh hydrometer'''
  
        # Get widget text - hydtometer_id
        widget_hydro = self.dlg_sum.findChild(QLineEdit, "hydrometer_id_new")          
        self.hydro_id = widget_hydro.text()

        # Get connec_id       
        widget_connec = self.dialog.findChild(QLineEdit, "connec_id")          
        self.connec_id = widget_connec.text()

        # Check if Hydrometer_id already exists
        sql = "SELECT DISTINCT(hydrometer_id) FROM "+self.schema_name+".rtc_hydrometer WHERE hydrometer_id = '"+self.hydro_id+"'" 
        row = self.dao.get_row(sql)
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
        ''' Close form without saving '''
        self.dlg_sum.close_dialog()
          
        
    def open_selected_document(self):
        ''' Get value from selected cell ("PATH")
        Open the document ''' 
        
        # Check if clicked value is from the column "PATH"
        position_column = self.tbl_document.currentIndex().column()
        if position_column == 4:      
            # Get data from address in memory (pointer)
            self.path = self.tbl_document.selectedIndexes()[0].data()

            # Parse a URL into components
            url = urlparse.urlsplit(self.path)

            # Check if path is URL
            if url.scheme == "http":
                # If path is URL open URL in browser
                webbrowser.open(self.path) 
            else: 
                # If its not URL ,check if file exist
                if not os.path.exists(self.path):
                    message = "File not found!"
                    self.controller.show_warning(message, context_name='ui_message')
                else:
                    # Open the document
                    os.startfile(self.path)   
    
    
    def open_selected_document_event(self):
        ''' Get value from selected cell ("PATH")
        Open the document ''' 
        
        # Check if clicked value is from the column "PATH"
        position_column = self.tbl_event.currentIndex().column()
        if position_column == 7:      
            # Get data from address in memory (pointer)
            self.path = self.tbl_event.selectedIndexes()[0].data()

            sql = "SELECT value FROM "+self.schema_name+".config_param_system"
            sql += " WHERE parameter = 'om_visit_absolute_path'"
            row = self.dao.get_row(sql)
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

                    
    def open_selected_document_from_table(self):
        ''' Button - Open document from table document'''
        
        self.tbl_document = self.dialog.findChild(QTableView, "tbl_document")
        # Get selected rows
        selected_list = self.tbl_document.selectionModel().selectedRows()    
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message) 
            return
        
        inf_text = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = self.tbl_document.model().record(row).value("path")
            inf_text+= str(id_)+", "
        inf_text = inf_text[:-2]
        self.path = inf_text 
        
        sql = "SELECT value FROM "+self.schema_name+".config_param_system"
        sql += " WHERE parameter = 'doc_absolute_path'"
        row = self.dao.get_row(sql)
        if row is None:
            message = "Parameter not set in table 'config_param_system'"
            self.controller.show_warning(message, parameter='doc_absolute_path')
            return

        # Full path= path + value from row
        self.full_path =row[0]+self.path
       
        # Parse a URL into components
        url=urlparse.urlsplit(self.full_path)

        # Check if path is URL
        if url.scheme=="http":
            # If path is URL open URL in browser
            webbrowser.open(self.full_path) 
        else: 
            # If its not URL ,check if file exist
            if not os.path.exists(self.full_path):
                message = "File not found:"+self.full_path 
                self.controller.show_warning(message, context_name='ui_message')
            else:
                # Open the document
                os.startfile(self.full_path)    
                

    def set_filter_table(self, widget):
        ''' Get values selected by the user and sets a new filter for its table model '''
        
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
        doc_user_value = utils_giswater.getWidgetText("doc_user")
        if doc_user_value != 'null':
            expr+= " AND user_name = '"+doc_user_value+"'"
  
        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select() 
        
        
    def set_filter_table_man(self, widget):
        ''' Get values selected by the user and sets a new filter for its table model '''
        
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
        ''' Configuration of tables 
        Set visibility of columns
        Set width of columns '''
        
        widget = utils_giswater.getWidget(widget)
        if not widget:
            return

        # Set width and alias of visible columns
        columns_to_delete = []
        sql = "SELECT column_index, width, alias, status"
        sql += " FROM "+self.schema_name+".config_client_forms"
        sql += " WHERE table_id = '"+table_name+"'"
        sql += " ORDER BY column_index"
        rows = self.controller.get_rows(sql)
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


    def fill_tbl_document(self, widget, table_name, filter_):
        ''' Fill the table control to show documents'''

        # Get widgets
        doc_user = self.dialog.findChild(QComboBox, "doc_user")
        doc_type = self.dialog.findChild(QComboBox, "doc_type")
        doc_tag = self.dialog.findChild(QComboBox, "doc_tag")
        self.date_document_to = self.dialog.findChild(QDateEdit, "date_document_to")
        self.date_document_from = self.dialog.findChild(QDateEdit, "date_document_from")

        # Set signals
        doc_user.activated.connect(partial(self.set_filter_table, widget))
        doc_type.activated.connect(partial(self.set_filter_table, widget))
        doc_tag.activated.connect(partial(self.set_filter_table, widget))
        self.date_document_to.dateChanged.connect(partial(self.set_filter_table, widget))
        self.date_document_from.dateChanged.connect(partial(self.set_filter_table, widget))
        #self.tbl_document.doubleClicked.connect(self.open_selected_document)

        # Fill ComboBox tagcat_id
        sql = "SELECT DISTINCT(tagcat_id)"
        sql+= " FROM "+table_name
        sql+= " ORDER BY tagcat_id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("doc_tag", rows)

        # Fill ComboBox doccat_id
        sql = "SELECT DISTINCT(doc_type)"
        sql+= " FROM "+table_name
        sql+= " ORDER BY doc_type"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("doc_type", rows)

        # Fill ComboBox doc_user
        sql = "SELECT DISTINCT(user_name)"
        sql+= " FROM "+table_name
        sql+= " ORDER BY user_name"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("doc_user", rows)
        
        # Set model of selected widget
        self.set_model_to_table(widget, table_name, filter_)
        
        
    def fill_tbl_document_man(self, widget, table_name, filter_):
        ''' Fill the table control to show documents'''
        
        # Get widgets  
        doc_type = self.dialog.findChild(QComboBox, "doc_type")
        doc_tag = self.dialog.findChild(QComboBox, "doc_tag")
        self.date_document_to = self.dialog.findChild(QDateEdit, "date_document_to")
        self.date_document_from = self.dialog.findChild(QDateEdit, "date_document_from")
        date = QDate.currentDate()
        self.date_document_to.setDate(date)

        btn_open_path = self.dialog.findChild(QPushButton,"btn_open_path")
        btn_open_path.clicked.connect(self.open_selected_document_from_table) 
        
        # Set signals
        doc_type.activated.connect(partial(self.set_filter_table_man, widget))
        doc_tag.activated.connect(partial(self.set_filter_table_man, widget))
        self.date_document_to.dateChanged.connect(partial(self.set_filter_table_man, widget))
        self.date_document_from.dateChanged.connect(partial(self.set_filter_table_man, widget))
        #self.tbl_document.doubleClicked.connect(self.open_selected_document)

        # Fill ComboBox tagcat_id
        sql = "SELECT DISTINCT(tagcat_id)"
        sql+= " FROM "+table_name
        sql+= " ORDER BY tagcat_id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("doc_tag", rows)

        # Fill ComboBox doc_type
        sql = "SELECT DISTINCT(doc_type)"
        sql+= " FROM "+table_name
        sql+= " ORDER BY doc_type"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("doc_type", rows)

        # Set model of selected widget
        self.set_model_to_table(widget, table_name, filter_)
    

    def fill_table(self, widget, table_name, filter_): 
        ''' Fill info tab of node '''
        self.set_model_to_table(widget, table_name, filter_)     
        
             
    def fill_tbl_event(self, widget, table_name, filter_):
        ''' Fill the table control to show documents'''
        
        #table_name_event_type = self.schema_name+'."om_visit_parameter_type"'
        table_name_event_id = self.schema_name+'."om_visit_parameter"'
        
        # Get widgets  
        event_type = self.dialog.findChild(QComboBox, "event_type")
        event_id = self.dialog.findChild(QComboBox, "event_id")
        self.date_event_to = self.dialog.findChild(QDateEdit, "date_event_to")
        self.date_event_from = self.dialog.findChild(QDateEdit, "date_event_from")
        date = QDate.currentDate();
        self.date_event_to.setDate(date);

        # Set signals
        event_type.activated.connect(partial(self.set_filter_table_event, widget))
        event_id.activated.connect(partial(self.set_filter_table_event2, widget))
        self.date_event_to.dateChanged.connect(partial(self.set_filter_table_event, widget))
        self.date_event_from.dateChanged.connect(partial(self.set_filter_table_event, widget))
    
        feature_key = self.controller.get_layer_primary_key()
        if feature_key == 'node_id':
            feature = 'NODE'
        if feature_key == 'connec_id':
            feature = 'CONNEC'
        if feature_key == 'arc_id':
            feature = 'ARC'
        if feature_key == 'gully_id':
            feature = 'GULLY'
             
        # Fill ComboBox event_id
        sql = "SELECT DISTINCT(id)"
        sql+= " FROM "+table_name_event_id
        sql+= " WHERE feature = '"+feature+"' OR feature = 'ALL'" 
        sql+= " ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("event_id", rows)
           
        # Fill ComboBox event_type
        sql = "SELECT DISTINCT(parameter_type)"
        sql+= " FROM "+table_name_event_id
        sql+= " WHERE feature = '"+feature+"' OR feature = 'ALL'" 
        sql+= " ORDER BY parameter_type"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("event_type", rows)
        
        # Set model of selected widget
        self.set_model_to_table(widget, table_name, filter_)    
        
        # On doble click open_event_gallery
        ''' Button - Open gallery from table event'''
        
    
    def set_filter_table_event(self, widget):
        ''' Get values selected by the user and sets a new filter for its table model '''

        # Get selected dates
        date_from = self.date_event_from.date().toString('yyyyMMdd') 
        date_to = self.date_event_to.date().toString('yyyyMMdd') 
        if (date_from > date_to):
            message = "Selected date interval is not valid"
            self.controller.show_warning(message, context_name='ui_message')                   
            return
        
        # Cascade filter 
        table_name_event_id = self.schema_name+'."om_visit_parameter"'
        event_type_value = utils_giswater.getWidgetText("event_type")
        # Get type of feature
        feature_key = self.controller.get_layer_primary_key()
        if feature_key == 'node_id':
            feature = 'NODE'
        if feature_key == 'connec_id':
            feature = 'CONNEC'
        if feature_key == 'arc_id':
            feature = 'ARC'
        if feature_key == 'gully_id':
            feature = 'GULLY'

        # Fill ComboBox event_id
        sql = "SELECT DISTINCT(id)"
        sql+= " FROM "+table_name_event_id
        sql+= " WHERE (feature = '"+feature+"' OR feature = 'ALL')"
        if event_type_value != 'null':
            sql+= " AND parameter_type= '"+event_type_value+"'" 
        sql+= " ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("event_id", rows)
        # End cascading filter
            
        # Set filter to model
        expr = self.field_id+" = '"+self.id+"'"
        expr += " AND tstamp >= '"+date_from+"' AND tstamp <= '"+date_to+"'"
        
        # Get selected values in Comboboxes        
        event_type_value = utils_giswater.getWidgetText("event_type")
        if event_type_value != 'null': 
            expr+= " AND parameter_type = '"+event_type_value+"'"
        event_id = utils_giswater.getWidgetText("event_id")
        if event_id != 'null': 
            expr+= " AND parameter_id = '"+event_id+"'"
            
        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select() 
       
        
    def set_filter_table_event2(self, widget):
        ''' Get values selected by the user and sets a new filter for its table model '''
        ''' Cascading filter '''
        
        # Get selected dates
        date_from = self.date_event_from.date().toString('yyyyMMdd') 
        date_to = self.date_event_to.date().toString('yyyyMMdd') 
        if (date_from > date_to):
            message = "Selected date interval is not valid"
            self.controller.show_warning(message, context_name='ui_message')                   
            return

        # Set filter
        expr = self.field_id+" = '"+self.id+"'"
        expr += " AND tstamp >= '"+date_from+"' AND tstamp <= '"+date_to+"'"
        
        # Get selected values in Comboboxes        
        event_type_value = utils_giswater.getWidgetText("event_type")
        if event_type_value != 'null': 
            expr+= " AND parameter_type = '"+event_type_value+"'"
        event_id = utils_giswater.getWidgetText("event_id")
        if event_id != 'null': 
            expr+= " AND parameter_id = '"+event_id+"'"
            
        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select() 
        
        
    def fill_tbl_hydrometer(self, widget, table_name, filter_):
        ''' Fill the table control to show documents'''

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
        ''' Get values selected by the user and sets a new filter for its table model '''

        # Get selected dates
        date_from = self.date_el_from.date().toString('yyyyMMdd') 
        date_to = self.date_el_to.date().toString('yyyyMMdd') 
        if (date_from > date_to):
            message = "Selected date interval is not valid"
            self.controller.show_warning(message, context_name='ui_message')                   
            return
        
        # Set filter
        expr = self.field_id+" = '"+self.id+"'"
        expr+= " AND date >= '"+date_from+"' AND date <= '"+date_to+"'"
  
        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select() 
        
        
    def set_tabs_visibility(self,num_el):
        ''' Hide some tabs '''   

        for i in xrange(num_el,-1,-1):
            # Get name of selected layer 
            selected_layer = self.layer.name() 
            # Get name of current tab
            tab_text = self.tab_main.tabText(i)
            if selected_layer != tab_text :
                self.tab_main.removeTab(i) 

        # For virtual arc remove tab Costs
        if self.layer.name() == "Varc":
            self.tab_main.removeTab(4)          
                
                
    def set_image(self, widget):
        
        # Manage 'cat_shape'
        arc_id = utils_giswater.getWidgetText("arc_id") 
        cur_layer = self.iface.activeLayer()  
        table_name = self.controller.get_layer_source_table_name(cur_layer) 
        column_name = cur_layer.name().lower()+"_cat_shape"
    
        # Get cat_shape value from database       
        sql = "SELECT "+column_name+"" 
        sql+= " FROM "+self.schema_name+"."+table_name+""
        sql+= " WHERE arc_id = '"+arc_id+"'"
        row = self.dao.get_row(sql)

        if row is not None:
            if row[0] != 'VIRTUAL': 
                utils_giswater.setImage(widget, row[0])
            # If selected table is Virtual hide tab cost
            else :
                self.tab_main.removeTab(4)  
    
    
    def action_centered(self, feature, canvas, layer):

        layer.setSelectedFeatures([feature.id()])
        canvas.zoomToSelected(layer)
        
    
    def action_zoom_in(self, feature, canvas, layer):
        
        layer.setSelectedFeatures([feature.id()])
        canvas.zoomToSelected(layer)
        canvas.zoomIn()  


    def action_zoom_out(self, feature, canvas, layer):

        layer.setSelectedFeatures([feature.id()])
        canvas.zoomToSelected(layer)
        canvas.zoomOut()
        
      
    def action_enabled(self, action, layer):
        
        status = layer.startEditing()
        self.change_status(action, status,layer)


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
            
        # Set signals
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
            self.controller.log_info(str(node_type))
            self.node_type_text = node_type
                  
        sql = "SELECT DISTINCT(matcat_id) as matcat_id " 
        sql += " FROM "+self.schema_name+".cat_"+geom_type
        if wsoftware == 'ws' and geom_type == 'node':
            sql += " WHERE "+geom_type+"type_id = '"+self.node_type_text+"'"
        sql += " ORDER BY matcat_id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.matcat_id, rows)

        sql = "SELECT DISTINCT("+self.field2+")"
        sql += " FROM "+self.schema_name+".cat_"+geom_type
        if wsoftware == 'ws' and geom_type == 'node':
            sql += " WHERE "+geom_type+"type_id = '"+self.node_type_text+"'"
        sql += " ORDER BY "+self.field2
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.filter2, rows)

        if wsoftware == 'ws':
            if geom_type == 'node':
                sql = "SELECT "+self.field3
                sql+= " FROM (SELECT DISTINCT(regexp_replace(trim(' nm' FROM "+self.field3+"), '-', '', 'g')::int) as x, "+self.field3
                sql+= " FROM "+self.schema_name+".cat_"+geom_type+" ORDER BY x) AS "+self.field3
            elif geom_type == 'arc':
                sql = "SELECT DISTINCT("+self.field3+"), (trim('mm' from "+self.field3+")::int) AS x, "+self.field3
                sql+= " FROM "+self.schema_name+".cat_"+geom_type+" ORDER BY x"
            elif geom_type == 'connec':
                sql = "SELECT DISTINCT(TRIM(TRAILING ' ' from "+self.field3+")) AS "+self.field3
                sql+= " FROM "+self.schema_name+".cat_"+geom_type+" ORDER BY "+self.field3                
        else:
            if geom_type == 'node':
                sql = "SELECT DISTINCT("+self.field3+") AS "+self.field3
                sql+= " FROM "+self.schema_name+".cat_"+geom_type
                sql+= " ORDER BY "+self.field3
            elif geom_type == 'arc':
                sql = "SELECT DISTINCT("+self.field3+"), (trim('mm' from "+self.field3+")::int) AS x, "+self.field3
                sql+= " FROM "+self.schema_name+".cat_"+geom_type+" ORDER BY x"            
              
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.filter3, rows)

        
    def fill_filter2(self, wsoftware, geom_type):

        # Get values from filters          
        mats = utils_giswater.getWidgetText(self.dlg_cat.matcat_id) 
        
        # Set SQL query             
        sql_where = None
        sql = "SELECT DISTINCT("+self.field2+")"
        sql+= " FROM "+self.schema_name+".cat_"+geom_type
          
        # Build SQL filter
        if mats != "null":
            if sql_where is None:
                sql_where = " WHERE"
            sql_where+= " matcat_id = '"+mats+"'"
        if wsoftware == 'ws' and self.node_type_text is not None:
            if sql_where is None:
                sql_where = " WHERE"
            else:
                sql_where+= " AND"            
            sql_where+= " "+geom_type+"type_id = '"+self.node_type_text+"'"
        sql+= sql_where+" ORDER BY "+self.field2
                
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.filter2, rows)
        self.fill_filter3(wsoftware, geom_type)

        
    def fill_filter3(self, wsoftware, geom_type):
        
        # Get values from filters
        mats = utils_giswater.getWidgetText(self.dlg_cat.matcat_id)                                
        filter2 = utils_giswater.getWidgetText(self.dlg_cat.filter2)  
         
        # Set SQL query       
        sql_where = None   
        if wsoftware == 'ws' and geom_type != 'connec':             
            sql = "SELECT "+self.field3 
            sql+= " FROM (SELECT DISTINCT(regexp_replace(trim(' nm'from "+self.field3+"),'-','', 'g')::int) as x, "+self.field3
        elif wsoftware == 'ws' and geom_type == 'connec':
            sql = "SELECT DISTINCT(TRIM(TRAILING ' ' from "+self.field3+")) as "+self.field3       
        else:
            sql = "SELECT DISTINCT("+self.field3+")"
        sql+= " FROM "+self.schema_name+".cat_"+geom_type
        
        # Build SQL filter                
        if wsoftware == 'ws' and self.node_type_text is not None:        
            sql_where = " WHERE "+geom_type+"type_id = '"+self.node_type_text+"'"
        if mats != "null":
            if sql_where is None:
                sql_where = " WHERE"
            else:
                sql_where+= " AND"                 
            sql_where+= " matcat_id = '"+mats+"'"
        if filter2 != "null":
            if sql_where is None:
                sql_where = " WHERE"
            else:
                sql_where+= " AND"       
            sql_where+= " "+self.field2+" = '"+filter2+"'"
        if wsoftware == 'ws' and geom_type != 'connec':              
            sql+= sql_where+" ORDER BY x) AS "+self.field3
        else:
            sql+= sql_where+" ORDER BY "+self.field3
                
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.filter3, rows)

        
    def fill_catalog_id(self, wsoftware, geom_type):
        
        # Get values from filters
        mats = utils_giswater.getWidgetText(self.dlg_cat.matcat_id)                                
        filter2 = utils_giswater.getWidgetText(self.dlg_cat.filter2)  
        filter3 = utils_giswater.getWidgetText(self.dlg_cat.filter3)  

        # Set SQL query
        sql_where = None  
        sql = "SELECT DISTINCT(id) as id" 
        sql+= " FROM "+self.schema_name+".cat_"+geom_type
        
        if wsoftware == 'ws' and self.node_type_text is not None:
            sql_where = " WHERE "+geom_type+"type_id = '"+self.node_type_text+"'"
        if mats != "null":
            if sql_where is None:
                sql_where = " WHERE"
            else:
                sql_where+= " AND"                 
            sql_where+= " matcat_id = '"+mats+"'"
        if filter2 != "null":
            if sql_where is None:
                sql_where = " WHERE"
            else:
                sql_where+= " AND"                 
            sql_where+= " "+self.field2+" = '"+filter2+"'"
        if filter3 != "null":
            if sql_where is None:
                sql_where = " WHERE"
            else:
                sql_where+= " AND"                 
            sql_where+= " "+self.field3+" = '"+filter3+"'"
        sql+= sql_where+" ORDER BY id"
        
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
        # Key: field tablename
        # Value: Object of the class SysFeatureCat
        sql = "SELECT * FROM " + self.schema_name + ".sys_feature_cat"
        rows = self.dao.get_rows(sql)
        if not rows:
            return

        for row in rows:
            tablename = row['tablename']
            elem = SysFeatureCat(row['id'], row['type'], row['orderby'], row['tablename'], row['shortcut_key'])
            self.feature_cat[tablename] = elem


    def project_read(self):

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
            self.controller.log_info("File not found", parameter=icon_path)

