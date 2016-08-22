# -*- coding: utf-8 -*-
from qgis.gui import QgsMessageBar
from PyQt4.QtCore import QSettings
from PyQt4.QtGui import QLabel

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

