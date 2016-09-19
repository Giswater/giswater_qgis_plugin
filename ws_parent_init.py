# -*- coding: utf-8 -*-
from qgis.gui import QgsMessageBar
from PyQt4.QtCore import QSettings
from PyQt4.QtGui import QLabel
from PyQt4.QtSql import QSqlTableModel

import os.path
import sys  

import utils_giswater
from controller import DaoController
        
        
class ParentDialog(object):   
    
    def __init__(self, iface, dialog, layer, feature):
        ''' Constructor class '''     
        self.iface = iface
        self.dialog = dialog
        self.layer = layer
        self.feature = feature
        self.init_config()             
    
        
    def init_config(self):    
        
        # initialize plugin directory
        user_folder = os.path.expanduser("~") 
        self.plugin_name = 'giswater'  
        self.plugin_dir = os.path.join(user_folder, '.qgis2/python/plugins/'+self.plugin_name)    
        
        # Get config file
        setting_file = os.path.join(self.plugin_dir, 'config', self.plugin_name+'.config')
        if not os.path.isfile(setting_file):
            message = "Config file not found at: "+setting_file
            self.iface.messageBar().pushMessage(message, QgsMessageBar.WARNING, 5)  
            self.close()
            return
            
        self.settings = QSettings(setting_file, QSettings.IniFormat)
        self.settings.setIniCodec(sys.getfilesystemencoding())
        
        # Set controller to handle settings and database connection
        # TODO: Try to make only one connection
        self.controller = DaoController(self.settings, self.plugin_name, self.iface)
        status = self.controller.set_database_connection()      
        if not status:
            message = self.controller.getLastError()
            self.iface.messageBar().pushMessage(message, QgsMessageBar.WARNING, 5) 
            return 
             
        self.schema_name = self.settings.value("db/schema_name")           
        self.dao = self.controller.dao
            
            
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
            text = utils_giswater.tr(context_name, widget_name)
            if text != widget_name:
                widget.setText(text)         
         
       
    def load_tab_add_info(self):
        ''' Load data from tab 'Add. info' '''                
        pass

    def load_tab_analysis(self):
        ''' Load data from tab 'Analysis' '''          
        pass
                
    def load_tab_document(self):
        ''' TODO: Load data from tab 'Document' '''   
        pass
                
    def load_tab_picture(self):
        ''' TODO: Load data from tab 'Document' '''   
        pass
                
    def load_tab_event(self):
        ''' TODO: Load data from tab 'Event' '''   
        pass
                
    def load_tab_log(self):
        ''' TODO: Load data from tab 'Log' '''   
        pass
        
    def load_tab_rtc(self):
        ''' TODO: Load data from tab 'RTC' '''   
        pass
    
    def load_data(self):
        ''' Load data from related tables '''
        
        self.load_tab_add_info()
        self.load_tab_analysis()
        self.load_tab_document()
        self.load_tab_picture()
        self.load_tab_event()
        self.load_tab_log()
        self.load_tab_rtc()
        

    def save_tab_add_info(self):
        ''' Save tab from tab 'Add. info' '''                
        pass

    def save_tab_analysis(self):
        ''' Save tab from tab 'Analysis' '''          
        pass
                
    def save_tab_document(self):
        ''' TODO: Save tab from tab 'Document' '''   
        pass
                
    def save_tab_picture(self):
        ''' TODO: Save tab from tab 'Document' '''   
        pass
                
    def save_tab_event(self):
        ''' TODO: Save tab from tab 'Event' '''   
        pass
                
    def save_tab_log(self):
        ''' TODO: Save tab from tab 'Log' '''   
        pass
        
    def save_tab_rtc(self):
        ''' TODO: Save tab from tab 'RTC' '''   
        pass
        
                        
    def save_data(self):
        ''' Save data from related tables '''        
        self.save_tab_add_info()
        self.save_tab_analysis()
        self.save_tab_document()
        self.save_tab_picture()
        self.save_tab_event()
        self.save_tab_log()
        self.save_tab_rtc()       
                
        
        
    ''' Slot functions '''           
               
    def save(self):
        ''' Save feature '''
        self.save_data()   
        self.dialog.accept()
        self.layer.commitChanges()    
        self.close()     
        
        
    def close(self):
        ''' Close form without saving '''
        self.layer.rollBack()   
        self.dialog.parent().setVisible(False)    
        
        
    def set_model_to_table(self, widget, table_name, filter_): 
        ''' Set a model with selected filter.
        Attach that model to selected table '''
        
        # Set model
        model = QSqlTableModel();
        model.setTable(table_name)
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
            self.controller.show_warning("Any record selected")
            return
        
        inf_text = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = widget.model().record(row).value("id")
            inf_text+= str(id_)+", "
            list_id = list_id+"'"+str(id_)+"', "
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        answer = self.controller.ask_question("Are you sure you want to delete these records?", "Delete records", inf_text)
        if answer:
            sql = "DELETE FROM "+self.schema_name+"."+table_name 
            sql+= " WHERE id IN ("+list_id+")"
            self.dao.execute_sql(sql)
            widget.model().select()
            
   
    def open_selected_document(self):
        ''' Get value from selected cell ("PATH")
        Open the document ''' 
        
        # Check if clicked value is from the column "PATH"
        position_column = self.tbl_document.currentIndex().column()
        if position_column == 4:      
            # Get data from address in memory (pointer)
            self.path = self.tbl_document.selectedIndexes()[0].data()
            # Check if file exist
            if not os.path.exists(self.path):
                message = "File not found!"
                self.controller.show_warning(message)                
            else:
                # Open the document
                os.startfile(self.path)                      


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
        
        # TODO: Bug because 'user' is a reserverd word
#         doc_user_value = utils_giswater.getWidgetText("doc_user")
#         if doc_user_value != 'null': 
#             expr+= " AND user = '"+doc_user_value+"'"
  
        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()   
        
        
        
    def set_configuration(self, widget, table_name):
        ''' Configuration of tables 
        Set visibility of columns
        Set width of columns'''

        # Hide columns
        #--------------
        # Get indexes of hidden columns
        sql = "SELECT column_index FROM "+self.schema_name+".config_ui_forms WHERE status = FALSE AND ui_table = '"+table_name+"'"
        # Get rows
        rows_index_false = self.dao.get_rows(sql)
        for row in rows_index_false:
            ind = row[0]-1
            widget.hideColumn(ind)     
            
        # Set width of columns
        #-------------
        # Get indexes of visible columns
        sql = "SELECT column_index FROM "+self.schema_name+".config_ui_forms WHERE status = TRUE AND ui_table = '"+table_name+"'"
        rows_index_true = self.dao.get_rows(sql)
        # Get indexes of visible columns
        # Get width of colums and set width
        sql = "SELECT width FROM "+self.schema_name+".config_ui_forms WHERE status = TRUE AND ui_table = '"+table_name+"'"
        rows_width = self.dao.get_rows(sql)
        
        for row_index,row_width in zip(rows_index_true,rows_width):
            widget.setColumnWidth(row_index[0],row_width[0])
                
        
        
