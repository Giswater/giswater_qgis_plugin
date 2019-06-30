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
        elif self.id and self.id.upper() != 'NULL':
            self.update_filters('value_state_type', 'id', self.geom_type, 'state_type', self.id)
            self.update_filters('dma', 'dma_id', self.geom_type, 'dma_id', self.id)

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


    def init_filters(self, dialog):
        """ Init Qcombobox filters and fill with all 'items' if no match """
        
        exploitation = dialog.findChild(QComboBox, 'expl_id')
        dma = dialog.findChild(QComboBox, 'dma_id')
        self.dma_items = [dma.itemText(i) for i in range(dma.count())]
        exploitation.currentIndexChanged.connect(partial(self.filter_dma, dialog, exploitation, dma))
        if self.project_type == 'ws':
            presszonecat_id = dialog.findChild(QComboBox, 'presszonecat_id')
            self.press_items = [presszonecat_id.itemText(i) for i in range(presszonecat_id.count())]
            exploitation.currentIndexChanged.connect(partial(self.filter_presszonecat_id, dialog, exploitation, presszonecat_id))

        state = dialog.findChild(QComboBox, 'state')
        state_type = dialog.findChild(QComboBox, 'state_type')
        self.state_type_items = [state_type.itemText(i) for i in range(state_type.count())]
        state.currentIndexChanged.connect(partial(self.filter_state_type, dialog, state, state_type))

        muni_id = dialog.findChild(QComboBox, 'muni_id')
        street_1 = dialog.findChild(QComboBox, 'streetaxis_id')
        street_2 = dialog.findChild(QComboBox, 'streetaxis2_id')
        self.street_items = [street_1.itemText(i) for i in range(street_1.count())]
        muni_id.currentIndexChanged.connect(partial(self.filter_streets, dialog, muni_id, street_1))
        muni_id.currentIndexChanged.connect(partial(self.filter_streets, dialog, muni_id, street_2))


    def filter_streets(self, dialog, muni_id, street):

        sql = ("SELECT name FROM "+ self.schema_name + ".ext_streetaxis"
               " WHERE muni_id = (SELECT muni_id FROM " + self.schema_name + ".ext_municipality "
               " WHERE name = '" + utils_giswater.getWidgetText(dialog, muni_id) + "')")
        rows = self.controller.get_rows(sql)
        if rows:
            list_items = [rows[i] for i in range(len(rows))]
            utils_giswater.fillComboBox(dialog, street, list_items)
        else:
            utils_giswater.fillComboBoxList(dialog, street, self.street_items)


    def filter_dma(self, dialog, exploitation, dma):
        """ Populate QCombobox @dma according to selected @exploitation """
        
        sql = ("SELECT t1.name FROM " + self.schema_name + ".dma AS t1"
               " INNER JOIN " + self.schema_name + ".exploitation AS t2 ON t1.expl_id = t2.expl_id "
               " WHERE t2.name = '" + str(utils_giswater.getWidgetText(dialog, exploitation)) + "'")
        rows = self.controller.get_rows(sql)
        if rows:
            list_items = [rows[i] for i in range(len(rows))]
            utils_giswater.fillComboBox(dialog, dma, list_items, allow_nulls=False)
        else:
            utils_giswater.fillComboBoxList(dialog, dma, self.dma_items, allow_nulls=False)


    def filter_presszonecat_id(self, dialog, exploitation, presszonecat_id):
        """ Populate QCombobox @presszonecat_id according to selected @exploitation """

        sql = ("SELECT t1.descript FROM " + self.schema_name + ".cat_presszone AS t1"
               " INNER JOIN " + self.schema_name + ".exploitation AS t2 ON t1.expl_id = t2.expl_id "
               " WHERE t2.name = '" + str(utils_giswater.getWidgetText(dialog, exploitation)) + "'")
        rows = self.controller.get_rows(sql)
        if rows:
            list_items = [rows[i] for i in range(len(rows))]
            utils_giswater.fillComboBox(dialog, presszonecat_id, list_items, allow_nulls=False)
        else:
            utils_giswater.fillComboBoxList(dialog, presszonecat_id, self.press_items, allow_nulls=False)


    def filter_state_type(self, dialog, state, state_type):
        """ Populate QCombobox @state_type according to selected @state """
        
        sql = ("SELECT t1.name FROM " + self.schema_name + ".value_state_type AS t1"
               " INNER JOIN " + self.schema_name + ".value_state AS t2 ON t1.state=t2.id "
               " WHERE t2.name ='" + str(utils_giswater.getWidgetText(dialog, state)) + "'")
        rows = self.controller.get_rows(sql)
        if rows:
            list_items = [rows[i] for i in range(len(rows))]
            utils_giswater.fillComboBox(dialog, state_type, list_items, allow_nulls=False)
        else:
            utils_giswater.fillComboBoxList(dialog, state_type, self.state_type_items, allow_nulls=False)
     
     
    def update_filters(self, table_name, field_id, geom_type, widget, feature_id):
        """ @widget is the field to SET """
        
        sql = ("SELECT " + str(field_id) + " FROM " + self.schema_name + "." + str(table_name) + " "
               " WHERE name = '" + str(utils_giswater.getWidgetText(self.dialog, widget)) + "'")
        row = self.controller.get_row(sql)
        if row:
            sql = ("UPDATE " + self.schema_name + "." + str(geom_type) + " "
                   " SET " + widget + " = '" + str(row[0]) + "'"
                   " WHERE " + str(geom_type) + "_id = '" + str(feature_id) + "'")
            self.controller.execute_sql(sql)


    def get_snapper(self):
        """ Return snapper """

        if Qgis.QGIS_VERSION_INT < 29900:
            snapper = QgsMapCanvasSnapper(self.canvas)
        else:
            snapper = QgsMapCanvas.snappingUtils(self.canvas)

        return snapper


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

