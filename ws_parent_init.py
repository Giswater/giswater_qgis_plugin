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

