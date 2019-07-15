"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except ImportError:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT < 29900:
    from qgis.gui import QgsMapCanvasSnapper
    import ConfigParser as configparser
else:
    from qgis.gui import QgsMapCanvas
    import configparser

from qgis.core import QgsExpression, QgsFeatureRequest, QgsMapToPixel
from qgis.utils import iface

from qgis.PyQt.QtCore import QSettings, Qt, QUrl, QDate, QDateTime
from qgis.PyQt.QtGui import QIntValidator, QDoubleValidator, QColor, QIcon
from qgis.PyQt.QtWidgets import QLabel, QListWidget, QFileDialog, QListWidgetItem, QComboBox, QDateEdit, QDateTimeEdit
from qgis.PyQt.QtWidgets import QTableView, QPushButton, QLineEdit, QWidget, QDialog, QTextEdit

from functools import partial

import sys
if 'nt' in sys.builtin_module_names:
    import ctypes

import os

from . import utils_giswater
from .dao.controller import DaoController


class ParentDialog(QDialog):
    
    def __init__(self, dialog, layer, feature):
        """ Constructor class """  
        
        self.dialog = dialog
        self.layer = layer
        self.feature = feature  
        self.iface = iface
        self.canvas = self.iface.mapCanvas()    
        self.snapper_manager = None              
        self.tabs_removed = 0
        self.tab_scada_removed = 0        
        self.parameters = None              
        self.init_config()     
        self.set_signals()
        self.dlg_is_destroyed = None

        # Set default encoding 
        if Qgis.QGIS_VERSION_INT < 29900:
            reload(sys)
            sys.setdefaultencoding('utf-8')   #@UndefinedVariable

        super(ParentDialog, self).__init__()

        
    def init_config(self):    
     
        # Initialize plugin directory
        cur_path = os.path.dirname(__file__)
        self.plugin_dir = os.path.abspath(cur_path)
        self.plugin_name = os.path.basename(self.plugin_dir).lower()
        #self.plugin_name = self.get_value_from_metadata('name', 'giswater')

        # Get config file
        setting_file = os.path.join(self.plugin_dir, 'config', self.plugin_name + '.config')
        if not os.path.isfile(setting_file):
            message = "Config file not found at: " + setting_file
            self.iface.messageBar().pushMessage("", message, 1, 20)
            self.close_dialog()
            return
            
        # Set plugin settings
        self.settings = QSettings(setting_file, QSettings.IniFormat)
        self.settings.setIniCodec(sys.getfilesystemencoding())
        
        # Set QGIS settings. Stored in the registry (on Windows) or .ini file (on Unix) 
        self.qgis_settings = QSettings()
        self.qgis_settings.setIniCodec(sys.getfilesystemencoding())  
        
        # Set controller to handle settings and database connection
        self.controller = DaoController(self.settings, self.plugin_name, iface, 'forms')
        self.controller.set_plugin_dir(self.plugin_dir)  
        self.controller.set_qgis_settings(self.qgis_settings)  
        status, not_version = self.controller.set_database_connection()
        if not status:
            message = self.controller.last_error
            self.controller.show_warning(message) 
            self.controller.log_warning(str(self.controller.layer_source))            
            return 
            
        # Manage locale and corresponding 'i18n' file
        self.controller.manage_translation(self.plugin_name)
        
        # Cache error message with log_code = -1 (uncatched error)
        self.controller.get_error_message(-1)            

        # Get schema_name and DAO object                
        self.schema_name = self.controller.schema_name  
        self.project_type = self.controller.get_project_type()

        # If not logged, then close dialog
        if not self.controller.logged:           
            self.dialog.parent().setVisible(False)  
            self.close_dialog(self.dialog)


    def set_signals(self):
        
        try:
            self.dialog.parent().accepted.connect(self.save)
            self.dialog.parent().rejected.connect(self.reject_dialog)
        except:
            pass
         
                
    def save(self, close_dialog=True):
        """ Save feature """

        # Custom fields save 
        status = self.save_custom_fields() 
        if not status:
            self.controller.log_info("save_custom_fields: data not saved")
        
        # General save
        self.dialog.save()     
        self.iface.actionSaveEdits().trigger()    
        
        # Commit changes and show error details to the user (if any)     
        status = self.iface.activeLayer().commitChanges()
        if not status:
            self.parse_commit_error_message()

        # Close dialog
        if close_dialog:
            self.close_dialog()

        sql = ("SELECT value FROM " + self.schema_name + ".config_param_user "
               "WHERE parameter = 'cf_keep_opened_edition' AND cur_user = current_user")
        row = self.controller.get_row(sql, commit=True)
        if row:
            self.iface.activeLayer().startEditing()

        # Close database connection        
        self.controller.close_db()         
        
        # Close logger file
        self.controller.close_logger()
                      
        del self.controller              


    def parse_commit_error_message(self):       
        """ Parse commit error message to make it more readable """
        
        message = self.iface.activeLayer().commitErrors()
        if 'layer not editable' in message:                
            return
        
        main_text = message[0][:-1]
        error_text = message[2].lstrip()
        error_pos = error_text.find("ERROR")
        detail_text_1 = error_text[:error_pos-1] + "\n\n"
        context_pos = error_text.find("CONTEXT")    
        detail_text_2 = error_text[error_pos:context_pos-1] + "\n"   
        detail_text_3 = error_text[context_pos:]
        detail_text = detail_text_1 + detail_text_2 + detail_text_3
        self.controller.show_warning_detail(main_text, detail_text)    
        

    def close_dialog(self, dlg=None):
        """ Close form """ 
        
        if dlg is None or type(dlg) is bool:
            dlg = self.dialog  
        
        try:      
            self.set_action_identify()
            self.controller.plugin_settings_set_value("check_topology_node", "0")        
            self.controller.plugin_settings_set_value("check_topology_arc", "0")        
            self.controller.plugin_settings_set_value("close_dlg", "0")           
            self.save_settings(dlg)     
            dlg.parent().setVisible(False) 
        except:
            dlg.close()
            pass 
        
        
    def set_action_identify(self):
        """ Set action 'Identify' """  
        
        try:
            self.iface.actionIdentify().trigger()     
        except Exception:          
            pass           
        

    def load_settings(self, dialog=None):
        """ Load QGIS settings related with dialog position and size """
        
        if dialog is None:
            dialog = self.dialog

        try:
            key = self.layer.name()
            x = self.controller.plugin_settings_value(key + "_x")
            y = self.controller.plugin_settings_value(key + "_y")
            width = self.controller.plugin_settings_value(key + "_width", dialog.parent().width())
            height = self.controller.plugin_settings_value(key + "_height", dialog.parent().height())

            if x == "" or y == "" or int(x) < 0 or int(y) < 0:
                dialog.resize(int(width), int(height))
            else:
                screens = ctypes.windll.user32
                screen_x = screens.GetSystemMetrics(78)
                screen_y = screens.GetSystemMetrics(79)
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
            dialog = self.dialog
            
        try:
            key = self.layer.name()         
            self.controller.plugin_settings_set_value(key + "_width", dialog.parent().property('width'))
            self.controller.plugin_settings_set_value(key + "_height", dialog.parent().property('height'))
            self.controller.plugin_settings_set_value(key + "_x", dialog.parent().pos().x())
            self.controller.plugin_settings_set_value(key + "_y", dialog.parent().pos().y())        
        except:
            pass             
        

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


    def get_value_from_metadata(self, parameter, default_value):
        """ Get @parameter from metadata.txt file """

        # Check if metadata file exists
        metadata_file = os.path.join(self.plugin_dir, 'metadata.txt')
        if not os.path.exists(metadata_file):
            message = "Metadata file not found: " + metadata_file
            self.iface.messageBar().pushMessage("", message, 1, 20)
            return default_value

        try:
            metadata = configparser.ConfigParser()
            metadata.read(metadata_file)
            value = metadata.get('general', parameter)
        except configparser.NoOptionError:
            message = "Parameter not found: " + parameter
            self.iface.messageBar().pushMessage("", message, 1, 20)
            value = default_value
        finally:
            return value

