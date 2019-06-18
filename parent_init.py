"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
from __future__ import absolute_import

from future import standard_library
standard_library.install_aliases()
from builtins import next
from builtins import range

# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except ImportError:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT < 29900:
    from qgis.PyQt.QtGui import QStringListModel
    from giswater.map_tools.snapping_utils_v2 import SnappingConfigManager
    from qgis.gui import QgsMapCanvasSnapper
    import ConfigParser as configparser
else:
    from qgis.PyQt.QtCore import QStringListModel
    from qgis.gui import QgsMapCanvas
    from giswater.map_tools.snapping_utils_v3 import SnappingConfigManager
    import configparser

from qgis.core import QgsExpression, QgsFeatureRequest, QgsPoint, QgsMapToPixel
from qgis.gui import QgsMessageBar, QgsMapToolEmitPoint, QgsVertexMarker, QgsDateTimeEdit
from qgis.utils import iface

from qgis.PyQt.QtCore import QSettings, Qt, QPoint, QUrl, QDate, QDateTime
from qgis.PyQt.QtGui import QIntValidator, QDoubleValidator, QColor, QIcon
from qgis.PyQt.QtWidgets import QLabel, QListWidget, QFileDialog, QListWidgetItem, QComboBox, QDateEdit, QDateTimeEdit
from qgis.PyQt.QtWidgets import QAction, QAbstractItemView, QCompleter, QCheckBox, QFormLayout
from qgis.PyQt.QtWidgets import QTableView, QPushButton, QLineEdit, QWidget, QDialog, QTextEdit
from qgis.PyQt.QtSql import QSqlTableModel, QSqlQueryModel
from qgis.PyQt.QtWebKitWidgets import QWebView
from qgis.PyQt.QtWebKit import QWebSettings

from functools import partial
from datetime import datetime

import sys
if 'nt' in sys.builtin_module_names:
    import ctypes

import os
import urllib.parse
import webbrowser
import subprocess

from . import utils_giswater
from .dao.controller import DaoController
from ui_manager import AddSum
from ui_manager import CFWScatalog
from ui_manager import CFUDcatalog
from ui_manager import LoadDocuments
from ui_manager import EventFull
from ui_manager import AddPicture
from .actions.manage_document import ManageDocument
from .actions.manage_element import ManageElement
from .actions.manage_gallery import ManageGallery
from .models.sys_feature_cat import SysFeatureCat
from .models.man_addfields_parameter import ManAddfieldsParameter
from .map_tools.snapping_utils_v2 import SnappingConfigManager
from .actions.manage_visit import ManageVisit


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
        
        self.btn_save_custom_fields = None
        
        # Manage layers
        self.manage_layers()
        
        # If not logged, then close dialog
        if not self.controller.logged:           
            self.dialog.parent().setVisible(False)  
            self.close_dialog(self.dialog)
        
        # Manage filters only when updating the feature
        if self.id and self.id.upper() != 'NULL':               
            self.init_filters(self.dialog)
            expl_id = self.dialog.findChild(QComboBox, 'expl_id')
            dma_id = self.dialog.findChild(QComboBox, 'dma_id')
            state = self.dialog.findChild(QComboBox, 'state')
            state_type = self.dialog.findChild(QComboBox, 'state_type')
            self.filter_dma(self.dialog, expl_id, dma_id)
            self.filter_state_type(self.dialog, state, state_type)
        else:
            point = self.canvas.mouseLastXY()
            point = QgsMapToPixel.toMapCoordinates(self.canvas.getCoordinateTransform(), point.x(), point.y())
            table_name = self.controller.get_layer_source_table_name(self.layer)
            if table_name not in self.feature_cat:
                return

            id_table = self.feature_cat[table_name].id
            sql = ("SELECT "+self.schema_name+".gw_fct_getinsertform_vdef('" + str(id_table) + "', '"+str(point[0])+"', '"+str(point[1])+"')")
            row = self.controller.get_row(sql, log_sql=True)
            if not row:
                return
            values = row[0]

            # if 'feature_id' in values:
            #     utils_giswater.setWidgetText(self.dialog, self.geom_type + "_id", str(values['feature_id']))
            if 'value' in values['inventory']:
                utils_giswater.setChecked(self.dialog, 'inventory', values['inventory']['value'])
            if 'value' in values['publish']:
                utils_giswater.setChecked(self.dialog, 'publish', values['publish']['value'])
            if 'value' in values['uncertain']:
                utils_giswater.setChecked(self.dialog, 'uncertain', values['uncertain']['value'])
            if 'name' in values['muni_id']:
                utils_giswater.setWidgetText(self.dialog, 'muni_id', values['muni_id']['name'])
            if 'name' in values['sector_id']:
                utils_giswater.setWidgetText(self.dialog, 'sector_id', values['sector_id']['name'])
            if 'name' in values['expl_id']:
                utils_giswater.setWidgetText(self.dialog, 'expl_id', values['expl_id']['name'])
            if 'name' in values['dma_id']:
                utils_giswater.setWidgetText(self.dialog, 'dma_id', values['dma_id']['name'])
            if 'name' in values['state']:
                utils_giswater.setWidgetText(self.dialog, 'state', values['state']['name'])
            if 'name' in values['state_type']:
                utils_giswater.setWidgetText(self.dialog, 'state_type', values['state_type']['name'])
            if 'descript' in values['presszone']:
                utils_giswater.setWidgetText(self.dialog, 'presszonecat_id', values['presszone']['descript'])
            if 'id' in values['cat_id']:
                widget_list = ['nodecat_id', 'arccat_id', 'conneccat_id', 'gratecat_id']
                for w in widget_list:
                    widget = self.dialog.findChild(QWidget, w)
                    if widget:
                        utils_giswater.setWidgetText(self.dialog, widget, values['cat_id']['id'])
                        break
            if 'id' in values['type']:
                widget_list = ['node_type', 'arc_type', 'connec_type', 'gully_type']
                for w in widget_list:
                    widget = self.dialog.findChild(QWidget, w)
                    if widget:
                        utils_giswater.setWidgetText(self.dialog, widget, values['type']['id'])
                        break



    def load_default(self, dialog, feature_type=None):
        """ Load default user values from table 'config_param_user' """
        
        # Builddate
        sql = ("SELECT value FROM " + self.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND parameter = 'builtdate_vdefault'")
        row = self.controller.get_row(sql, log_sql=False)
        if row:
            date_value = datetime.strptime(row[0], '%Y-%m-%d')
            utils_giswater.setCalendarDate(dialog, "builtdate", date_value)

        # State
        sql = ("SELECT name FROM " + self.schema_name + ".value_state WHERE id::text ="
               " (SELECT value FROM " + self.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND  parameter = 'state_vdefault')::text")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(dialog, "state", row[0])
            
        # State type
        sql = ("SELECT name FROM " + self.schema_name + ".value_state_type WHERE id::text ="
               " (SELECT value FROM " + self.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND  parameter = 'statetype_vdefault')::text")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(dialog, "state_type", row[0])

        self.set_vdefault(dialog, 'verified_vdefault', 'verified')
        self.set_vdefault(dialog, 'workcat_vdefault', 'workcat_id')
        self.set_vdefault(dialog, 'soilcat_vdefault', 'soilcat_id')
        if feature_type:
            # Feature type
            sql = ("SELECT id FROM " + self.schema_name + "."+str(feature_type)+"_type WHERE id::text ="
                   " (SELECT value FROM " + self.schema_name + ".config_param_user"
                   " WHERE cur_user = current_user AND  parameter = '" + str(feature_type) + "type_vdefault')::text")
            row = self.controller.get_row(sql)
            if row:
                utils_giswater.setWidgetText(dialog, feature_type + "_type", row[0])

    def set_vdefault(self, dialog, parameter, widget):
        """ Set default values from default values when insert new feature """
        
        sql = ("SELECT value FROM " + self.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND parameter = '" + parameter + "'")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(dialog, widget, str(row[0]))


    def load_type_default(self, dialog, widget, cat_id):

        sql = ("SELECT value FROM " + self.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND parameter = '" + str(cat_id) + "'")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(dialog, widget, row[0])


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
        
        
    def reject_dialog(self, close=False):
        """ Reject dialog without saving """ 
        
        self.set_action_identify()        
        self.controller.plugin_settings_set_value("check_topology_node", "0")        
        self.controller.plugin_settings_set_value("check_topology_arc", "0")        
        self.controller.plugin_settings_set_value("close_dlg", "0")                           
        if close:
            self.dialog.parent().setVisible(False)

        # Close database connection         
        self.controller.close_db()       
        
        # Close logger file
        self.controller.close_logger()
        
        del self.controller  


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
        
        
    def set_model_to_table(self, widget, table_name, expr_filter=None):
        """ Set a model with selected filter.
        Attach that model to selected table """
        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        # Set model
        model = QSqlTableModel()
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        if expr_filter is not None:
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


    def manage_document(self, dialog, doc_id=None, feature=None, table_name=None):
        """ Execute action of button 34 """
                
        doc = ManageDocument(self.iface, self.settings, self.controller, self.plugin_dir)          
        doc.manage_document(feature=feature, geom_type=self.geom_type)
        doc.dlg_add_doc.accepted.connect(partial(self.manage_document_new, dialog, doc, table_name))
        doc.dlg_add_doc.rejected.connect(partial(self.manage_document_new, dialog, doc, table_name))
                 
        # Set completer
        self.set_completer_object(dialog, self.table_object)
        if doc_id:
            utils_giswater.setWidgetText(dialog, "doc_id", doc_id)

        # Open dialog
        doc.open_dialog()


    def manage_document_new(self, dialog, doc, table_name):
        """ Get inserted doc_id and add it to current feature """

        if doc.doc_id is None:
            return

        utils_giswater.setWidgetText(dialog, "doc_id", doc.doc_id)
        self.add_object(self.tbl_document, "doc", "v_ui_document")
        self.set_filter_dates('date', 'date', table_name, self.date_document_from, self.date_document_to)


    def manage_element(self, dialog, element_id=None, feature=None):
        """ Execute action of button 33 """
        
        elem = ManageElement(self.iface, self.settings, self.controller, self.plugin_dir)          
        elem.manage_element(feature=feature, geom_type=self.geom_type)
        elem.dlg_add_element.accepted.connect(partial(self.manage_element_new, dialog, elem))
        elem.dlg_add_element.rejected.connect(partial(self.manage_element_new, dialog, elem))

        # Set completer
        self.set_completer_object(dialog, self.table_object)

        if element_id:
            utils_giswater.setWidgetText(elem.dlg_add_element, "element_id", element_id)

        elem.dlg_add_element.setWindowTitle("Manage element")
        # Open dialog
        elem.open_dialog(elem.dlg_add_element)


    def manage_element_new(self, dialog, elem):
        """ Get inserted element_id and add it to current feature """

        if elem.element_id is None:
            return

        utils_giswater.setWidgetText(dialog, "element_id", elem.element_id)
        self.add_object(self.tbl_element, "element", "v_ui_element")

        self.tbl_element.model().select()


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
            inf_text += str(object_id) + ", "
            list_id += str(id_) + ", "
            list_object_id = list_object_id + str(object_id) + ", "
            row_index += str(row + 1) + ", "

        row_index = row_index[:-2]
        inf_text = inf_text[:-2]
        list_object_id = list_object_id[:-2]
        list_id = list_id[:-2]

        message = "Are you sure you want to delete these records?"
        answer = self.controller.ask_question(message, "Delete records", list_object_id)
        if answer:
            sql = ("DELETE FROM " + self.schema_name + "." + table_name + ""
                   " WHERE id::integer IN (" + list_id + ")")
            self.controller.execute_sql(sql)
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
        title = "Delete records"
        answer = self.controller.ask_question(message, title, list_id)
        table_name = '"rtc_hydrometer_x_connec"'
        table_name2 = '"rtc_hydrometer"'
        if answer:
            sql = ("DELETE FROM " + self.schema_name + "." + table_name + ""
                   " WHERE hydrometer_id IN (" + list_id + ")")
            self.controller.execute_sql(sql)
            sql = ("DELETE FROM " + self.schema_name + "." + table_name2 + ""
                   " WHERE hydrometer_id IN (" + list_id + ")")
            self.controller.execute_sql(sql)
            widget.model().select()
            
                   
    def insert_records(self):
        """ Insert value Hydrometer | Hydrometer"""
        
        # Create the dialog and signals
        self.dlg_sum = AddSum()   
              
        # Set signals
        self.dlg_sum.findChild(QPushButton, "btn_accept").clicked.connect(self.btn_accept)
        self.dlg_sum.findChild(QPushButton, "btn_close").clicked.connect(partial(self.close_dialog, self.dlg_sum))
              
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
        sql = ("SELECT DISTINCT(hydrometer_id) FROM " + self.schema_name + ".rtc_hydrometer"
               " WHERE hydrometer_id = '" + self.hydro_id + "'")
        row = self.controller.get_row(sql)
        if row:
            # if exist - show warning
            message = "Hydrometer_id already exists"
            self.controller.show_info_box(message, "Info", parameter=self.hydro_id)
        else:
            # in not exist insert hydrometer_id
            # if not exist - insert new Hydrometer id
            # Insert hydrometer_id in v_rtc_hydrometer
            sql = "INSERT INTO "+self.schema_name+".rtc_hydrometer (hydrometer_id) "
            sql += " VALUES ('"+self.hydro_id+"')"
            self.controller.execute_sql(sql) 
            
            # insert hydtometer_id and connec_id in rtc_hydrometer_x_connec
            sql = "INSERT INTO "+self.schema_name+".rtc_hydrometer_x_connec (hydrometer_id, connec_id) "
            sql+= " VALUES ('"+self.hydro_id+"','"+self.connec_id+"')"
            self.controller.execute_sql(sql) 
        
            # Refresh table in Qtableview
            # Fill tab Hydrometer
            table_hydrometer = "v_rtc_hydrometer"
            self.fill_tbl_hydrometer(self.tbl_hydrometer, table_hydrometer, self.filter)
          
            self.dlg_sum.close_dialog()
                
              
    def btn_close(self):
        """ Close form without saving """
        self.dlg_sum.close_dialog()

                    
    def open_selected_document(self, widget):
        """ Open selected document of the @widget """
        
        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()    
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message) 
            return
        elif len(selected_list) > 1:
            message = "Select just one document"
            self.controller.show_warning(message)
            return
        
        # Get document path (can be relative or absolute)
        row = selected_list[0].row()
        path = widget.model().record(row).value("path")

        # Check if file exist
        if os.path.exists(path):
            # Open the document
            if sys.platform == "win32":
                os.startfile(path)
            else:
                opener = "open" if sys.platform == "darwin" else "xdg-open"
                subprocess.call([opener, path])
        else:
            webbrowser.open(path)
        
    def set_filter_table_man(self, widget):
        """ Get values selected by the user and sets a new filter for its table model """
         # Get selected dates
        date_from = self.date_document_from.date().toString('yyyyMMdd')
        date_to = self.date_document_to.date().addDays(1).toString('yyyyMMdd')

        if (date_from > date_to):
            message = "Selected date interval is not valid"
            self.controller.show_warning(message)
            return

        # Set filter
        expr = self.field_id+" = '"+self.id+"'"
        expr+= " AND date >= '"+date_from+"' AND date <= '"+date_to+"'"

        # Get selected values in Comboboxes
        doc_type_value = utils_giswater.getWidgetText(self.dialog, "doc_type", return_string_null=False)
        if doc_type_value  not in ('', None):
            expr += " AND doc_type = '"+str(doc_type_value)+"'"

        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()
        
        
    def set_configuration(self, widget, table_name, sort_order=0, isQStandardItemModel=False):
        """ Configuration of tables. Set visibility and width of columns """
        
        widget = utils_giswater.getWidget(self.dialog, widget)
        if not widget:
            return
        # Set width and alias of visible columns
        columns_to_delete = []
        sql = ("SELECT column_index, width, alias, status"
               " FROM " + self.schema_name + ".config_client_forms"
               " WHERE table_id = '" + table_name + "'"
               " ORDER BY column_index")
        rows = self.controller.get_rows(sql, log_sql=False)
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
                if row['alias'] is not None:
                    widget.model().setHeaderData(row['column_index']-1, Qt.Horizontal, row['alias'])

        # Set order
        if not isQStandardItemModel:
            if widget.model() is QSqlTableModel:
                widget.model().setSort(sort_order, Qt.AscendingOrder)
                widget.model().select()
            elif widget.model() is QSqlQueryModel:
                #widget.setModel(model)
                widget.show()

        else:
            widget.model().sort(sort_order, Qt.AscendingOrder)

        # Delete columns
        for column in columns_to_delete:
            widget.hideColumn(column)
        
        
    def fill_tbl_document_man(self, dialog, widget, table_name, expr_filter):
        """ Fill the table control to show documents """
        
        # Get widgets  
        widget.setSelectionBehavior(QAbstractItemView.SelectRows)        
        self.doc_id = self.dialog.findChild(QLineEdit, "doc_id")             
        doc_type = self.dialog.findChild(QComboBox, "doc_type")
        self.date_document_to = self.dialog.findChild(QDateEdit, "date_document_to")
        self.date_document_from = self.dialog.findChild(QDateEdit, "date_document_from")
        btn_open_doc = self.dialog.findChild(QPushButton, "btn_open_doc")
        btn_doc_delete = self.dialog.findChild(QPushButton, "btn_doc_delete")         
        btn_doc_insert = self.dialog.findChild(QPushButton, "btn_doc_insert")         
        btn_doc_new = self.dialog.findChild(QPushButton, "btn_doc_new")         
 
        # Set signals
        doc_type.activated.connect(partial(self.set_filter_table_man, widget))
        self.date_document_to.dateChanged.connect(partial(self.set_filter_table_man, widget))
        self.date_document_from.dateChanged.connect(partial(self.set_filter_table_man, widget))
        self.tbl_document.doubleClicked.connect(partial(self.open_selected_document, widget))
        btn_open_doc.clicked.connect(partial(self.open_selected_document, widget)) 
        btn_doc_delete.clicked.connect(partial(self.delete_records, widget, table_name))            
        btn_doc_insert.clicked.connect(partial(self.add_object, widget, "doc", "v_ui_document"))
        btn_doc_new.clicked.connect(partial(self.manage_document, dialog, None, self.feature, table_name))

        # Set dates
        date = QDate.currentDate()
        self.date_document_to.setDate(date)
        
        # Fill ComboBox doc_type
        sql = ("SELECT id"
               " FROM " + self.schema_name + ".doc_type"
               " ORDER BY id")
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(dialog, "doc_type", rows)
        
        # Set model of selected widget
        self.set_model_to_table(widget, table_name, expr_filter)

        self.set_filter_dates('date', 'date', table_name, self.date_document_from, self.date_document_to)

        # Adding auto-completion to a QLineEdit
        self.table_object = "doc"        
        self.set_completer_object(dialog, self.table_object)


    def set_filter_dates(self, mindate, maxdate, table_name, widget_fromdate, widget_todate):
        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        sql = ("SELECT MIN("+str(mindate)+"), MAX("+str(maxdate)+")"
               " FROM {}".format(str(table_name)))
        row = self.controller.get_row(sql, log_sql=True)
        if row:
            if row[0]:
                widget_fromdate.setDate(row[0])
            else:
                current_date = QDate.currentDate()
                widget_fromdate.setDate(current_date)
            if row[1]:
                widget_todate.setDate(row[1])
            else:
                current_date = QDate.currentDate()
                widget_todate.setDate(current_date)


    def set_completer_object(self, dialog, table_object):
        """ Set autocomplete of widget @table_object + "_id" 
            getting id's from selected @table_object 
        """
        
        widget = utils_giswater.getWidget(dialog, table_object + "_id")
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
        self.completer.setCaseSensitivity(Qt.CaseInsensitive)
        widget.setCompleter(self.completer)
        model = QStringListModel()
        model.setStringList(row)
        self.completer.setModel(model)        


    def add_object(self, widget, table_object, view_object):
        """ Add object (doc or element) to selected feature """
        
        # Get values from dialog
        object_id = utils_giswater.getWidgetText(self.dialog, table_object + "_id")
        if object_id == 'null':
            message = "You need to insert data"
            self.controller.show_warning(message, parameter=table_object + "_id")
            return
        
        # Check if this object exists
        field_object_id = "id"
        sql = ("SELECT * FROM " + self.schema_name + "." + view_object + ""
               " WHERE " + field_object_id + " = '" + object_id + "'")
        row = self.controller.get_row(sql)
        if not row:
            self.controller.show_warning("Object id not found", parameter=object_id)
            return
        
        # Check if this object is already associated to current feature
        field_object_id = table_object + "_id"
        tablename = table_object + "_x_" + self.geom_type
        sql = ("SELECT *"
               " FROM " + self.schema_name + "." + str(tablename) + ""
               " WHERE " + str(self.field_id) + " = '" + str(self.id) + "'"
               " AND " + str(field_object_id) + " = '" + str(object_id) + "'")
        row = self.controller.get_row(sql, log_info=False)
        
        # If object already exist show warning message
        if row:
            message = "Object already associated with this feature"
            self.controller.show_warning(message)

        # If object not exist perform an INSERT
        else:
            sql = ("INSERT INTO " + self.schema_name + "." + tablename + ""
                   "(" + str(field_object_id) + ", " + str(self.field_id) + ")"
                   " VALUES ('" + str(object_id) + "', '" + str(self.id) + "');")
            self.controller.execute_sql(sql)
            widget.model().select()        
            
            
    def fill_tbl_element_man(self, dialog, widget, table_name, expr_filter):
        """ Fill the table control to show elements """
        
        # Get widgets
        widget.setSelectionBehavior(QAbstractItemView.SelectRows)        
        self.element_id = self.dialog.findChild(QLineEdit, "element_id")             
        open_element = self.dialog.findChild(QPushButton, "open_element")
        btn_delete = self.dialog.findChild(QPushButton, "btn_delete")         
        btn_insert = self.dialog.findChild(QPushButton, "btn_insert")         
        new_element = self.dialog.findChild(QPushButton, "new_element")         
 
        # Set signals
        self.tbl_element.doubleClicked.connect(partial(self.open_selected_element, dialog, widget))
        open_element.clicked.connect(partial(self.open_selected_element, dialog, widget))
        btn_delete.clicked.connect(partial(self.delete_records, widget, table_name))            
        btn_insert.clicked.connect(partial(self.add_object, widget, "element", "v_ui_element"))
        new_element.clicked.connect(partial(self.manage_element, dialog, feature=self.feature))
        
        # Set model of selected widget
        self.set_model_to_table(widget, table_name, expr_filter)
        
        # Adding auto-completion to a QLineEdit
        self.table_object = "element"        
        self.set_completer_object(dialog, self.table_object)
                    

    def open_selected_element(self, dialog, widget):
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
        
        # Open selected element

        self.manage_element(dialog, element_id)
        
            
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


    def open_visit(self):
        """ Call button 65: om_visit_management """

        manage_visit = ManageVisit(self.iface, self.settings, self.controller, self.plugin_dir)
        manage_visit.visit_added.connect(self.update_visit_table)
        manage_visit.edit_visit(self.geom_type, self.id)


    def new_visit(self, table_name=None):
        """ Call button 64: om_add_visit """
        # Get expl_id to save it on om_visit and show the geometry of visit
        sql = ("SELECT expl_id FROM " + self.schema_name + ".exploitation "
               " WHERE name ='" + utils_giswater.getWidgetText(self.dialog, 'expl_id') + "'")
        expl_id = self.controller.get_row(sql)

        manage_visit = ManageVisit(self.iface, self.settings, self.controller, self.plugin_dir)
        manage_visit.visit_added.connect(self.update_visit_table)
        # TODO: the following query fix a (for me) misterious bug
        # the DB connection is not available during manage_visit.manage_visit first call
        # so the workaroud is to do a unuseful query to have the dao controller active
        sql = ("SELECT id"
               " FROM " + self.schema_name + ".om_visit"
               " LIMIT 1")
        self.controller.get_rows(sql, commit=True)

        manage_visit.manage_visit(geom_type=self.geom_type, feature_id=self.id, expl_id=expl_id[0])
        self.set_filter_dates('visit_start', 'visit_end', table_name, self.date_event_from, self.date_event_to)


    # creat the new visit GUI
    def update_visit_table(self):
        """Convenience fuction set as slot to update table after a Visit GUI close."""
        self.tbl_event.model().select()


    def tbl_event_clicked(self, table_name):

        # Enable/Disable buttons
        btn_open_gallery = self.dialog.findChild(QPushButton, "btn_open_gallery")
        btn_open_visit_doc = self.dialog.findChild(QPushButton, "btn_open_visit_doc")
        btn_open_visit_event = self.dialog.findChild(QPushButton, "btn_open_visit_event")
        btn_open_gallery.setEnabled(False)
        btn_open_visit_doc.setEnabled(False)
        btn_open_visit_event.setEnabled(True)

        # Get selected row
        selected_list = self.tbl_event.selectionModel().selectedRows()
        selected_row = selected_list[0].row()
        self.visit_id = self.tbl_event.model().record(selected_row).value("visit_id")
        self.event_id = self.tbl_event.model().record(selected_row).value("event_id")
        self.parameter_id = self.tbl_event.model().record(selected_row).value("parameter_id")

        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        sql = ("SELECT gallery, document"
               " FROM " + table_name + ""
               " WHERE event_id = '" + str(self.event_id) + "' AND visit_id = '" + str(self.visit_id) + "'")
        row = self.controller.get_row(sql)
        if not row:
            return

        # If gallery 'True' or 'False'
        if str(row[0]) == 'True':
            btn_open_gallery.setEnabled(True)

        # If document 'True' or 'False'
        if str(row[1]) == 'True':
            btn_open_visit_doc.setEnabled(True)


    def open_gallery(self):
        """ Open gallery of selected record of the table """

        # Open Gallery
        gal = ManageGallery(self.iface, self.settings, self.controller, self.plugin_dir)
        gal.manage_gallery()
        gal.fill_gallery(self.visit_id, self.event_id)


    def open_visit_doc(self):
        """ Open document of selected record of the table """

        # Get all documents for one visit
        sql = ("SELECT doc_id"
               " FROM " + self.schema_name + ".doc_x_visit"
               " WHERE visit_id = '" + str(self.visit_id) + "'")
        rows = self.controller.get_rows(sql)
        if not rows:
            return

        num_doc = len(rows)

        if num_doc == 1:
            # If just one document is attached directly open

            # Get path of selected document
            sql = ("SELECT path"
                   " FROM " + self.schema_name + ".v_ui_document"
                   " WHERE id = '" + str(rows[0][0]) + "'")
            row = self.controller.get_row(sql)
            if not row:
                return

            path = str(row[0])

            # Parse a URL into components
            url = urllib.parse.urlsplit(path)

            # Open selected document
            # Check if path is URL
            if url.scheme == "http" or url.scheme == "https":
                # If path is URL open URL in browser
                webbrowser.open(path)
            else:
                # If its not URL ,check if file exist
                if not os.path.exists(path):
                    message = "File not found"
                    self.controller.show_warning(message, parameter=path)
                else:
                    # Open the document
                    os.startfile(path)
        else:
            # If more then one document is attached open dialog with list of documents
            self.dlg_load_doc = LoadDocuments()

            btn_open_doc = self.dlg_load_doc.findChild(QPushButton, "btn_open")
            btn_open_doc.clicked.connect(self.open_selected_doc)

            lbl_visit_id = self.dlg_load_doc.findChild(QLineEdit, "visit_id")
            lbl_visit_id.setText(str(self.visit_id))

            self.tbl_list_doc = self.dlg_load_doc.findChild(QListWidget, "tbl_list_doc")
            for row in rows:
                item_doc = QListWidgetItem(str(row[0]))
                self.tbl_list_doc.addItem(item_doc)

            self.dlg_load_doc.open()


    def open_selected_doc(self):

        # Selected item from list
        selected_document = self.tbl_list_doc.currentItem().text()

        # Get path of selected document
        sql = ("SELECT path"
               " FROM " + self.schema_name + ".v_ui_document"
               " WHERE id = '" + str(selected_document) + "'")
        row = self.controller.get_row(sql)
        if not row:
            return

        path = str(row[0])

        # Parse a URL into components
        url = urllib.parse.urlsplit(path)

        # Open selected document
        # Check if path is URL
        if url.scheme == "http" or url.scheme == "https":
            # If path is URL open URL in browser
            webbrowser.open(path)
        else:
            # If its not URL ,check if file exist
            if not os.path.exists(path):
                message = "File not found"
                self.controller.show_warning(message, parameter=path)
            else:
                # Open the document
                os.startfile(path)


    def open_visit_event(self):
        """ Open event of selected record of the table """

        # Open dialog event_standard
        self.dlg_event_full = EventFull()

        # Get all data for one visit
        sql = ("SELECT *"
               " FROM " + self.schema_name + ".om_visit_event"
               " WHERE id = '" + str(self.event_id) + "' AND visit_id = '" + str(self.visit_id) + "'")
        row = self.controller.get_row(sql)
        if not row:
            return

        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.id, row['id'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.event_code, row['event_code'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.visit_id, row['visit_id'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.position_id, row['position_id'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.position_value, row['position_value'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.parameter_id, row['parameter_id'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.value, row['value'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.value1, row['value1'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.value2, row['value2'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.geom1, row['geom1'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.geom2, row['geom2'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.geom3, row['geom3'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.xcoord, row['xcoord'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.ycoord, row['ycoord'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.compass, row['compass'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.tstamp, row['tstamp'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.text, row['text'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.index_val, row['index_val'])
        utils_giswater.setWidgetText(self.dlg_event_full, self.dlg_event_full.is_last, row['is_last'])

        self.dlg_event_full.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_event_full))

        self.dlg_event_full.open()


    def update_dlg_event_standard(self):

        value = utils_giswater.getWidgetText("value")
        text = utils_giswater.getWidgetText("text")

        sql = ("UPDATE " + self.schema_name + ".om_visit_event"
                " SET value = '" + str(value) + "', text = '" + str(text) + "'"
                " WHERE id = '" + str(self.event_id) + "' AND visit_id = '" + str(self.visit_id) + "'")
        status = self.controller.execute_sql(sql)
        if status:
            message = "Values has been updated"
            self.controller.show_info_box(message)


    def update_dlg_event_arc_standard(self):

        value = utils_giswater.getWidgetText("value")
        text = utils_giswater.getWidgetText("text")
        position_id = utils_giswater.getWidgetText("position_id")
        position_value = utils_giswater.getWidgetText("position_value")

        sql = ("UPDATE " + self.schema_name + ".om_visit_event"
               " SET value = '" + str(value) + "', text = '" + str(text) + "',"
               " position_id = '" + str(position_id) + "', position_value = '" + str(position_value) + "'"
               " WHERE id = '" + str(self.event_id) + "' AND visit_id = '" + str(self.visit_id) + "'")
        status = self.controller.execute_sql(sql)
        if status:
            message = "Values has been updated"
            self.controller.show_info_box(message)


    def update_dlg_event_arc_rehabit(self):

        value1 = utils_giswater.getWidgetText("value1")
        value2 = utils_giswater.getWidgetText("value2")
        text = utils_giswater.getWidgetText("text")
        position_id = utils_giswater.getWidgetText("position_id")
        position_value = utils_giswater.getWidgetText("position_value")
        geom1 = utils_giswater.getWidgetText("geom1")
        geom2 = utils_giswater.getWidgetText("geom2")
        geom3 = utils_giswater.getWidgetText("geom3")

        sql = ("UPDATE " + self.schema_name + ".om_visit_event"
               " SET value1 = '" + str(value1) + "', value2 = '" + str(value2) + "', text = '" + str(text) + "',"
               " position_id = '" + str(position_id) + "', position_value = '" + str(position_value) + "',"
               " geom1 = '" + str(geom1) + "', geom2 = '" + str(geom2) + "', geom3 = '" + str(geom3) + "'"
               " WHERE id = '" + str(self.event_id) + "' AND visit_id = '" + str(self.visit_id) + "'")
        status = self.controller.execute_sql(sql)
        if status:
            message = "Values has been updated"
            self.controller.show_info_box(message)


    def add_picture(self):

        self.dlg_add_img = AddPicture()

        self.lbl_path = self.dlg_add_img.findChild(QLineEdit, "path")

        # Get file dialog
        btn_path_doc = self.dlg_add_img.findChild(QPushButton, "path_doc")
        btn_path_doc.clicked.connect(partial(self.get_file_dialog, "path"))
        btn_accept = self.dlg_add_img.findChild(QPushButton, "btn_accept")
        btn_accept.clicked.connect(self.save_picture)
        btn_cancel = self.dlg_add_img.findChild(QPushButton, "btn_cancel")
        btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_add_img))

        self.dlg_add_img.open()


    def get_file_dialog(self, widget):
        """ Get file dialog """

        # Check if selected file exists. Set default value if necessary
        file_path = utils_giswater.getWidgetText(self.dlg_add_img, widget)
        if file_path is None or file_path == 'null' or not os.path.exists(str(file_path)):
            folder_path = self.plugin_dir
        else:
            folder_path = os.path.dirname(file_path)
            
        # Open dialog to select file
        os.chdir(folder_path)
        file_dialog = QFileDialog()

        # File dialog select just photos
        file_dialog.setFileMode(QFileDialog.AnyFile)
        if Qgis.QGIS_VERSION_INT < 29900:
            folder_path = file_dialog.getOpenFileName(self, 'Open picture', 'c:\\', "Images (*.png *.jpg)")
        else:
            folder_path, filter_ = file_dialog.getOpenFileName(self, 'Open picture', 'c:\\', "Images (*.png *.jpg)")

        if folder_path:
            utils_giswater.setWidgetText(self.dlg_add_img, widget, str(folder_path))


    def save_picture(self):
        """ Insert picture selected from form dialog to om_visit_event_photo """

        picture_path = utils_giswater.getWidgetText(self.dlg_add_img, self.lbl_path)
        if picture_path == "null":
            message = "Please choose a file"
            self.controller.show_info_box(message)
        else:
            sql = ("SELECT * FROM " + self.schema_name + ".om_visit_event_photo"
                   " WHERE value = '" +str(picture_path) + "'"
                   " AND event_id = '" +str(self.event_id) + "' AND visit_id = '" + str(self.visit_id) + "'")
            row = self.controller.get_row(sql)
            if not row:
                sql = ("INSERT INTO " + self.schema_name + ".om_visit_event_photo (visit_id, event_id, value) "
                      " VALUES ('" + str(self.visit_id) + "', '" + str(self.event_id) + "', '" + str(picture_path) + "')")
                status = self.controller.execute_sql(sql)
                if status:
                    self.close_dialog(self.dlg_add_img)
                    message = "Picture successfully linked to this event"
                    self.controller.show_info_box(message)
            else:
                message = "This picture already exists for this event"
                self.controller.show_info_box(message, "Info")


    def fill_tbl_event(self, widget, table_name, filter_):
        """ Fill the table control to show documents """
        # Get widgets
        widget.setSelectionBehavior(QAbstractItemView.SelectRows)
        event_type = self.dialog.findChild(QComboBox, "event_type")
        event_id = self.dialog.findChild(QComboBox, "event_id")
        self.date_event_to = self.dialog.findChild(QDateEdit, "date_event_to")
        self.date_event_from = self.dialog.findChild(QDateEdit, "date_event_from")

        self.set_dates_from_to(self.date_event_to, self.date_event_from, table_name, 'visit_start', 'visit_end')
        date = QDate.currentDate()
        self.date_event_to.setDate(date)


        btn_open_visit = self.dialog.findChild(QPushButton, "btn_open_visit")
        btn_new_visit = self.dialog.findChild(QPushButton, "btn_new_visit")
        btn_open_gallery = self.dialog.findChild(QPushButton, "btn_open_gallery")
        btn_open_visit_doc = self.dialog.findChild(QPushButton, "btn_open_visit_doc")
        btn_open_visit_event = self.dialog.findChild(QPushButton, "btn_open_visit_event")

        btn_open_gallery.setEnabled(False)
        btn_open_visit_doc.setEnabled(False)
        btn_open_visit_event.setEnabled(False)
        
        # Set signals
        widget.clicked.connect(partial(self.tbl_event_clicked, table_name))
        event_type.activated.connect(partial(self.set_filter_table_event, widget))
        event_id.activated.connect(partial(self.set_filter_table_event2, widget))
        self.date_event_to.dateChanged.connect(partial(self.set_filter_table_event, widget))
        self.date_event_from.dateChanged.connect(partial(self.set_filter_table_event, widget))

        btn_open_visit.clicked.connect(self.open_visit)
        btn_new_visit.clicked.connect(partial(self.new_visit, table_name))
        btn_open_gallery.clicked.connect(self.open_gallery)
        btn_open_visit_doc.clicked.connect(self.open_visit_doc)
        btn_open_visit_event.clicked.connect(self.open_visit_event)

        feature_key = self.controller.get_layer_primary_key()
        if feature_key == 'node_id':
            feature_type = 'NODE'
        if feature_key == 'connec_id':
            feature_type = 'CONNEC'
        if feature_key == 'arc_id':
            feature_type = 'ARC'
        if feature_key == 'gully_id':
            feature_type = 'GULLY'

        table_name_event_id = "om_visit_parameter"
        
        # Fill ComboBox event_id
        sql = ("SELECT DISTINCT(id)"
               " FROM " + self.schema_name + "." + table_name_event_id + ""
               " WHERE feature_type = '" + feature_type + "' OR feature_type = 'ALL'"
               " ORDER BY id")
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dialog, "event_id", rows)

        # Fill ComboBox event_type
        sql = ("SELECT DISTINCT(parameter_type)"
               " FROM " + self.schema_name + "." + table_name_event_id + ""
               " WHERE feature_type = '" + feature_type + "' OR feature_type = 'ALL'"
               " ORDER BY parameter_type")
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dialog, "event_type", rows)

        # Get selected dates
        date_from = self.date_event_from.date().toString('yyyyMMdd 00:00:00')
        date_to = self.date_event_to.date().toString('yyyyMMdd 23:59:59')
        if date_from > date_to:
            message = "Selected date interval is not valid"
            self.controller.show_warning(message)
            return
        filter_ += " AND visit_start >= '" + date_from + "' AND visit_start <= '" + date_to + "'"

        # Set model of selected widget
        self.set_model_to_table(widget, table_name, filter_)
        self.set_filter_dates('visit_start', 'visit_end', table_name, self.date_event_from, self.date_event_to)


    def set_filter_table_event(self, widget):
        """ Get values selected by the user and sets a new filter for its table model """

        # Get selected dates
        date_from = self.date_event_from.date().toString('yyyyMMdd 00:00:00')
        date_to = self.date_event_to.date().toString('yyyyMMdd 23:59:59')

        if date_from > date_to:
            message = "Selected date interval is not valid"
            self.controller.show_warning(message)
            return

        # Cascade filter
        table_name_event_id = "om_visit_parameter"
        event_type_value = utils_giswater.getWidgetText(self.dialog, "event_type")
        
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
        sql = ("SELECT DISTINCT(id)"
               " FROM " + self.schema_name + "." + table_name_event_id + ""
               " WHERE (feature_type = '" + feature_type + "' OR feature_type = 'ALL')")
        if event_type_value != 'null':
            sql += " AND parameter_type = '" + event_type_value + "'"
        sql += " ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dialog, "event_id", rows)
        # End cascading filter

        # Set filter to model
        expr = self.field_id + " = '" + self.id + "'"
        expr += " AND visit_start >= '" + date_from + "' AND visit_start <= '" + date_to + "'"

        # Get selected values in Comboboxes
        event_type_value = utils_giswater.getWidgetText(self.dialog, "event_type")
        if event_type_value != 'null':
            expr += " AND parameter_type = '" + event_type_value + "'"
        event_id = utils_giswater.getWidgetText(self.dialog, "event_id")
        if event_id != 'null': 
            expr += " AND parameter_id = '" + event_id + "'"
            
        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()


    def set_filter_table_event2(self, widget):
        """ Get values selected by the user and sets a new filter for its table model """

        # Get selected dates
        date_from = self.date_event_from.date().toString('yyyyMMdd 00:00:00')
        date_to = self.date_event_to.date().toString('yyyyMMdd 23:59:59')
        if (date_from > date_to):
            message = "Selected date interval is not valid"
            self.controller.show_warning(message)
            return

        # Set filter
        expr = self.field_id + " = '" + self.id + "'"
        expr += " AND tstamp >= '" + date_from + "' AND tstamp <= '" + date_to + "'"

        # Get selected values in Comboboxes
        event_type_value = utils_giswater.getWidgetText(self.dialog, "event_type")
        if event_type_value != 'null':
            expr += " AND parameter_type = '" + event_type_value + "'"
        event_id = utils_giswater.getWidgetText(self.dialog, "event_id")
        if event_id != 'null':
            expr+= " AND parameter_id = '" + event_id + "'"

        # Refresh model with selected filter
        widget.model().setFilter(expr)
        widget.model().select()


    def fill_tbl_hydrometer(self, widget, table_name, filter_):
        """ Fill the table control to show documents"""

        # Get widgets
        self.cat_period_id_filter = self.dialog.findChild(QComboBox, "cat_period_id_filter")
        self.cmb_hyd_customer_code = self.dialog.findChild(QComboBox, "cmb_hyd_customer_code")

        # Populate combo filter hydrometer value
        sql = ("SELECT id, code FROM " + self.schema_name + ".ext_cat_period "
               " WHERE id IN (SELECT cat_period_id FROM "+ self.schema_name + ".v_edit_rtc_hydro_data_x_connec "
               " WHERE connec_id='"+str(self.id)+"')"
               " ORDER BY code")
        rows = [('', '')]
        rows.extend(self.controller.get_rows(sql, log_sql=True))
        utils_giswater.set_item_data(self.cat_period_id_filter, rows, 1)

        sql = ("SELECT hydrometer_id, hydrometer_customer_code "
               " FROM " + self.schema_name + ".v_rtc_hydrometer "
               " WHERE connec_id = '"+str(self.id)+"' "
               " ORDER BY hydrometer_customer_code")
        rows = [('', '')]
        rows.extend(self.controller.get_rows(sql, log_sql=True))
        utils_giswater.set_item_data(self.cmb_hyd_customer_code, rows, 1)

        # Set signals
        if widget == self.tbl_hydrometer_value:
            self.cat_period_id_filter.currentIndexChanged.connect(partial(self.set_filter_hydrometer_values, widget))
            self.cmb_hyd_customer_code.currentIndexChanged.connect(partial(self.set_filter_hydrometer_values, widget))

        # Set model of selected widget
        self.set_model_to_table(widget, table_name, filter_)

    def set_filter_hydrometer_values(self, widget):
        """ Get Filter for table hydrometer value with combo value"""

        # Get combo value
        cat_period_id_filter = utils_giswater.get_item_data(self.dialog, self.cat_period_id_filter)
        hyd_customer_code = utils_giswater.get_item_data(self.dialog, self.cmb_hyd_customer_code)
        # Set filter
        expr = self.field_id + " = '" + self.id + "'"
        if cat_period_id_filter not in (None, ''):
            expr += " AND cat_period_id = '" + cat_period_id_filter + "'"
        if hyd_customer_code not in (None, ''):
            expr += " AND hydrometer_id = '" + hyd_customer_code + "'"
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
        if not action.isChecked():
            message = "Do you want to save the changes?"
            answer = self.controller.ask_question(message, "Save changes")
            if answer:
                self.save(close_dialog=False)
        self.change_status(action, status, layer)


    def change_status(self, action, status, layer):

        if status:
            layer.startEditing()
            action.setChecked(True)
        else:
            layer.rollBack()
            

    def catalog(self, prev_dialog, wsoftware, geom_type, node_type=None):

        # Get key
        layer = self.iface.activeLayer()
        viewname = self.controller.get_layer_source_table_name(layer)
        sql = ("SELECT id FROM " + self.schema_name + ".sys_feature_cat"
               " WHERE tablename = '" + str(viewname) + "'")
        row = self.controller.get_row(sql)
        self.sys_type = str(row[0])

        # Set dialog depending water software
        if wsoftware == 'ws':
            self.dlg_cf_cat = CFWScatalog()
            self.field2 = 'pnom'
            self.field3 = 'dnom'
        elif wsoftware == 'ud':
            self.dlg_cf_cat = CFUDcatalog()
            self.field2 = 'shape'
            self.field3 = 'geom1'

        self.dlg_cf_cat.open()
        self.dlg_cf_cat.btn_ok.clicked.connect(partial(self.fill_geomcat_id, geom_type))
        self.dlg_cf_cat.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_cf_cat))
        self.dlg_cf_cat.rejected.connect(partial(self.close_dialog, self.dlg_cf_cat))        
        self.dlg_cf_cat.matcat_id.currentIndexChanged.connect(partial(self.fill_catalog_id, wsoftware, geom_type))
        self.dlg_cf_cat.matcat_id.currentIndexChanged.connect(partial(self.fill_filter2, wsoftware, geom_type))
        self.dlg_cf_cat.matcat_id.currentIndexChanged.connect(partial(self.fill_filter3, wsoftware, geom_type))
        self.dlg_cf_cat.filter2.currentIndexChanged.connect(partial(self.fill_catalog_id, wsoftware, geom_type))
        self.dlg_cf_cat.filter2.currentIndexChanged.connect(partial(self.fill_filter3, wsoftware, geom_type))
        self.dlg_cf_cat.filter3.currentIndexChanged.connect(partial(self.fill_catalog_id, wsoftware, geom_type))

        self.node_type_text = None
        if wsoftware == 'ws' and geom_type == 'node':
            self.node_type_text = node_type
        sql = "SELECT DISTINCT(matcat_id) AS matcat_id "
        sql += " FROM " + self.schema_name + ".cat_" + geom_type
        if wsoftware == 'ws' and geom_type == 'node':
            sql += " WHERE " + geom_type + "type_id IN"
            sql += " (SELECT DISTINCT (id) AS id FROM " + self.schema_name+"."+geom_type+"_type"
            sql += " WHERE type = '" + str(self.sys_type) + "')"
        sql += " ORDER BY matcat_id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cf_cat, self.dlg_cf_cat.matcat_id, rows)

        sql = "SELECT DISTINCT(" + self.field2 + ")"
        sql += " FROM " + self.schema_name + ".cat_" + geom_type
        if wsoftware == 'ws' and geom_type == 'node':
            sql += " WHERE " + geom_type + "type_id IN"
            sql += " (SELECT DISTINCT (id) AS id FROM " + self.schema_name+"."+geom_type+"_type"
            sql += " WHERE type = '" + str(self.sys_type) + "')"
        sql += " ORDER BY "+self.field2
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cf_cat, self.dlg_cf_cat.filter2, rows)

        if wsoftware == 'ws':
            if geom_type == 'node':
                sql = "SELECT "+self.field3
                sql += " FROM (SELECT DISTINCT(regexp_replace(trim(' nm' FROM "+self.field3+"), '-', '', 'g')::int) as x, "+self.field3
                sql += " FROM "+self.schema_name+".cat_"+geom_type+" WHERE "+self.field2 + " LIKE '%"+self.dlg_cf_cat.filter2.currentText()+"%' "
                sql += " AND matcat_id LIKE '%"+self.dlg_cf_cat.matcat_id.currentText()+"%' AND "+geom_type+"type_id IN "
                sql += "(SELECT id FROM "+self.schema_name+"."+geom_type+"_type WHERE type LIKE '%" + str(self.sys_type) + "%')"
                sql += " ORDER BY x) AS "+self.field3
            elif geom_type == 'arc':
                sql = "SELECT DISTINCT("+self.field3+"), (trim('mm' from "+self.field3+")::int) AS x, "+self.field3
                sql += " FROM "+self.schema_name+".cat_"+geom_type+" ORDER BY x"
            elif geom_type == 'connec':
                sql = "SELECT DISTINCT(TRIM(TRAILING ' ' from " + self.field3 + ")) AS " + self.field3
                sql += " FROM " + self.schema_name + ".cat_" + geom_type
                sql += " WHERE " + geom_type + "type_id IN (SELECT DISTINCT (id) FROM " + self.schema_name + "." + geom_type + "_type WHERE type = '" + str(self.sys_type) + "')"
                sql += " ORDER BY " + self.field3
        else:
            if geom_type == 'node' or geom_type == 'arc' or geom_type == 'connec':
                sql = "SELECT DISTINCT("+self.field3+") AS "+self.field3
                sql += " FROM "+self.schema_name+".cat_"+geom_type
                sql += " ORDER BY "+self.field3
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cf_cat, self.dlg_cf_cat.filter3, rows)
        self.fill_catalog_id(wsoftware, geom_type)


    def fill_filter2(self, wsoftware, geom_type):

        # Get values from filters
        mats = utils_giswater.getWidgetText(self.dlg_cf_cat, self.dlg_cf_cat.matcat_id)

        # Set SQL query
        sql_where = None
        sql = "SELECT DISTINCT(" + self.field2 + ")"
        sql += " FROM " + self.schema_name + ".cat_" + geom_type

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
            sql_where += geom_type + "type_id IN (SELECT DISTINCT (id) AS id FROM " + self.schema_name + "." + geom_type + "_type "
            sql_where += " WHERE type = '" + str(self.sys_type) + "')"
        if sql_where is not None:
            sql += str(sql_where) + " ORDER BY " + str(self.field2)
        else:
            sql += " ORDER BY " + str(self.field2)

        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cf_cat, self.dlg_cf_cat.filter2, rows)
        self.fill_filter3(wsoftware, geom_type)


    def fill_filter3(self, wsoftware, geom_type):

        if wsoftware == 'ws':
            if geom_type == 'node':
                sql = "SELECT "+self.field3
                sql += " FROM (SELECT DISTINCT(regexp_replace(trim(' nm' FROM "+self.field3+"), '-', '', 'g')::int) as x, "+self.field3
                sql += " FROM "+self.schema_name+".cat_"+geom_type
                sql += " WHERE ("+self.field2 + " LIKE '%"+self.dlg_cf_cat.filter2.currentText()+"%' OR "+self.field2 + " is null) "
                sql += " AND (matcat_id LIKE '%"+self.dlg_cf_cat.matcat_id.currentText()+"%' OR matcat_id is null)"
                sql += " AND "+geom_type+"type_id IN "
                sql += "(SELECT id FROM "+self.schema_name+"."+geom_type+"_type WHERE type LIKE '%" + str(self.sys_type) + "%')"
                sql += " ORDER BY x) AS "+self.field3
            elif geom_type == 'arc':
                sql = "SELECT "+self.field3
                sql += " FROM (SELECT DISTINCT(regexp_replace(trim(' nm' FROM "+self.field3+"), '-', '', 'g')::int) as x, "+self.field3
                sql += " FROM "+self.schema_name+".cat_"+geom_type
                sql += " WHERE "+geom_type+"type_id IN "
                sql += "(SELECT id FROM "+self.schema_name+"."+geom_type+"_type WHERE type LIKE '%" + str(self.sys_type) + "%')"
                sql += " AND (" + self.field2 + " LIKE '%" + self.dlg_cf_cat.filter2.currentText() + "%' OR " + self.field2 + " is null) "
                sql += " AND (matcat_id LIKE '%" + self.dlg_cf_cat.matcat_id.currentText() + "%' OR matcat_id is null)"
                sql += " ORDER BY x) AS "+self.field3
            elif geom_type == 'connec':
                sql = "SELECT DISTINCT(TRIM(TRAILING ' ' from "+self.field3+")) AS "+self.field3
                sql += " FROM "+self.schema_name+".cat_"+geom_type
                sql += " WHERE " + geom_type + "type_id IN (SELECT DISTINCT (id) FROM " + self.schema_name + "." + geom_type + "_type WHERE type = '" + str(self.sys_type) + "')"
                sql += " ORDER BY "+self.field3

        else:
            if geom_type == 'node' or geom_type == 'arc' or geom_type == 'connec':
                sql = "SELECT DISTINCT("+self.field3+") FROM "+self.schema_name+".cat_"+geom_type
                sql += " WHERE (matcat_id LIKE '%"+self.dlg_cf_cat.matcat_id.currentText()+"%' OR matcat_id is null) "
                sql += " AND ("+self.field2+" LIKE '%"+self.dlg_cf_cat.filter2.currentText()+"%' OR "+self.field2 + " is null) "
                sql += " ORDER BY "+self.field3

        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cf_cat, self.dlg_cf_cat.filter3, rows)
        self.fill_catalog_id(wsoftware, geom_type)


    def fill_catalog_id(self, wsoftware, geom_type):

        # Set SQL query
        sql_where = None
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".cat_" + geom_type

        if wsoftware == 'ws':
            sql_where = (" WHERE " + geom_type + "type_id IN"
                         " (SELECT DISTINCT (id) FROM " + self.schema_name + "." + geom_type + "_type"
                         " WHERE type = '" + str(self.sys_type) + "')")

        if self.dlg_cf_cat.matcat_id.currentText() != 'null':
            if sql_where is None:
                sql_where = " WHERE "
            else:
                sql_where += " AND "
            sql_where += " (matcat_id LIKE '%"+self.dlg_cf_cat.matcat_id.currentText()+"%' or matcat_id is null)"
            
        if self.dlg_cf_cat.filter2.currentText() != 'null':
            if sql_where is None:
                sql_where = " WHERE "
            else:
                sql_where += " AND "
            sql_where += ("(" + self.field2 + " LIKE '%" + self.dlg_cf_cat.filter2.currentText() + ""
                          "%' OR " + self.field2 + " is null)")
            
        if self.dlg_cf_cat.filter3.currentText() != 'null':
            if sql_where is None:
                sql_where = " WHERE "
            else:
                sql_where += " AND "
            sql_where += ("(" + self.field3 + "::text LIKE '%" + self.dlg_cf_cat.filter3.currentText() + ""
                          "%' OR " + self.field3 + " is null)")
            
        if sql_where is not None:
            sql += str(sql_where) + " ORDER BY id"
        else:
            sql += " ORDER BY id"
            
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cf_cat, self.dlg_cf_cat.id, rows)


    def fill_geomcat_id(self, geom_type):
        
        catalog_id = utils_giswater.getWidgetText(self.dlg_cf_cat, self.dlg_cf_cat.id)
        self.close_dialog(self.dlg_cf_cat)
        if geom_type == 'node':
            utils_giswater.setWidgetText(self.dlg_cf_cat, self.nodecat_id, catalog_id)
        elif geom_type == 'arc':
            utils_giswater.setWidgetText(self.dlg_cf_cat, self.arccat_id, catalog_id)
        else:
            utils_giswater.setWidgetText(self.dlg_cf_cat, self.connecat_id, catalog_id)


    def manage_feature_cat(self):

        self.feature_cat = {}
        
        # Dictionary to keep every record of table 'feature_cat'
        # Key: field tablename. Value: Object of the class SysFeatureCat
        sql = "SELECT * FROM " + self.schema_name + ".cat_feature"
        rows = self.controller.get_rows(sql)
        if not rows:
            return

        for row in rows:
            tablename = row['child_layer']
            elem = SysFeatureCat(row['id'], row['system_id'], row['feature_type'], row['type'], row['shortcut_key'],
                                 row['parent_layer'], row['child_layer'], row['active'])
            self.feature_cat[tablename] = elem


    def manage_layers(self):
        """ Manage layers """

        # Check if we have any layer loaded
        layers = self.controller.get_layers()
        if len(layers) == 0:
            return

        self.manage_feature_cat()

        # Iterate over all layers to get the ones specified in 'db' config section
        for cur_layer in layers:
            uri_table = self.controller.get_layer_source_table_name(cur_layer)  # @UnusedVariable
            if uri_table is not None:
                if uri_table in list(self.feature_cat.keys()):
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
        self.web = QWebView()
        self.web.settings().setAttribute(QWebSettings.PluginsEnabled, True)

        # Get locale of QGIS application
        locale = QSettings().value('locale/userLocale').lower()
        if locale == 'es_es':
            locale = 'es'
        elif locale == 'es_ca':
            locale = 'ca'
        elif locale == 'en_us':
            locale = 'en'

        # Get PDF file
        png_folder = os.path.join(self.plugin_dir, 'png')
        png_path = os.path.join(png_folder, wsoftware + "_" + geom_type + "_" + locale + ".png")
        # Open PDF if exists. If not open Spanish version
        if os.path.exists(png_path):
            self.web.load(QUrl(png_path))
            self.web.show()
        else:
            locale = "es"
            png_path = os.path.join(png_folder, wsoftware + "_" + geom_type + "_" + locale + ".png")
            if os.path.exists(png_path):
                self.web.load(QUrl(png_path))
                self.web.show()
            else:
                message = "File not found"
                self.controller.show_warning(message, parameter=png_path)


    def manage_custom_fields(self, cat_feature_id=None, tab_to_remove=None):
        """ Management of custom fields """

        # Check if corresponding widgets already exists
        self.form_layout_widget = self.dialog.findChild(QWidget, 'widget_form_layout')
        if not self.form_layout_widget:
            self.controller.log_info("widget not found")
            if tab_to_remove:
                self.tab_main.removeTab(tab_to_remove)
                self.tabs_removed += 1                
            return False

        self.form_layout = self.form_layout_widget.layout()
        if self.form_layout is None:
            self.controller.log_info("layout not found")
            if tab_to_remove:
                self.tab_main.removeTab(tab_to_remove)
                self.tabs_removed += 1                
            return False

        # Search into table 'man_addfields_parameter' parameters of selected @cat_feature_id
        sql = "SELECT * FROM " + self.schema_name + ".man_addfields_parameter"
        if cat_feature_id is not None and cat_feature_id != 'null':
            sql += " WHERE cat_feature_id = '" + cat_feature_id + "' OR cat_feature_id IS NULL"
        else:
            sql += " WHERE cat_feature_id IS NULL"
        sql += " ORDER BY id"
        rows = self.controller.get_rows(sql, log_info=False)
        if not rows:
            if tab_to_remove:
                self.tab_main.removeTab(tab_to_remove)
                self.tabs_removed += 1
            return False

        # Set layout properties
        self.form_layout.setRowWrapPolicy(QFormLayout.DontWrapRows);
        self.form_layout.setFieldGrowthPolicy(QFormLayout.FieldsStayAtSizeHint);
        self.form_layout.setFormAlignment(Qt.AlignLeft | Qt.AlignTop);   
        self.form_layout.setLabelAlignment(Qt.AlignLeft)

        # Create a widget for every parameter
        self.parameters = {}
        for row in rows:
            self.manage_widget(row)
        
        return True


    def manage_widget(self, row):
        """ Create a widget for every parameter """

        # Create instance of object ManAddfieldsParameter
        parameter = ManAddfieldsParameter(row)
        
        # Check widget type
        if parameter.widgettype_id == 'QLineEdit':
            widget = QLineEdit()
        elif parameter.widgettype_id == 'QComboBox':
            widget = QComboBox()
        elif parameter.widgettype_id == 'QDateEdit':
            widget = QgsDateTimeEdit()
            widget.setCalendarPopup(True)
            widget.setAllowNull(True)
            widget.setDisplayFormat("dd/MM/yyyy");
        elif parameter.widgettype_id == 'QDateTimeEdit':
            widget = QgsDateTimeEdit()
            widget.setCalendarPopup(True)
            widget.setAllowNull(True)            
            widget.setDisplayFormat("dd/MM/yyyy hh:mm:ss");
        elif parameter.widgettype_id == 'QTextEdit':
            widget = QTextEdit()
        elif parameter.widgettype_id == 'QCheckBox':
            widget = QCheckBox()
        else:
            return
        
        # Manage datatype_id
        if parameter.widgettype_id != 'QTextEdit':
            if parameter.datatype_id == 'integer':
                validator = QIntValidator(-9999999, 9999999)
                widget.setValidator(validator)
            elif parameter.datatype_id == 'double' or parameter.datatype_id == 'numeric':
                if parameter.num_decimals is None:
                    parameter.num_decimals = 3
                validator = QDoubleValidator(-9999999, 9999999, parameter.num_decimals)
                validator.setNotation(QDoubleValidator().StandardNotation)
                widget.setValidator(validator)
            
        # Manage field_length
        if parameter.field_length and parameter.widgettype_id == 'QLineEdit':
            widget.setMaxLength(parameter.field_length) 

        # Create label of custom field
        label = QLabel()
        label_text = parameter.form_label
        if parameter.is_mandatory:
            label_text += " *"
        label.setText(label_text)
        label.setFixedWidth(95)
        
        # Set some widgets properties
        widget.setObjectName(parameter.param_name)
        widget.setFixedWidth(162)

        # Check if selected feature has value in table 'man_addfields_value'
        value_param = self.get_param_value(row['id'], self.id)
        parameter.value_param = value_param        
        parameter.widget = widget
        
        # Manage widget type
        if type(widget) is QDateEdit \
            or (type(widget) is QgsDateTimeEdit and widget.displayFormat() == 'dd/MM/yyyy'):
            if value_param is None or value_param == "":
                widget.clear() 
            else:
                value_param = QDate.fromString(value_param, 'dd/MM/yyyy')
                utils_giswater.setCalendarDate(self.dialog, widget, value_param)

        elif type(widget) is QDateTimeEdit \
            or (type(widget) is QgsDateTimeEdit and widget.displayFormat() == 'dd/MM/yyyy hh:mm:ss'):         
            if value_param is None or value_param == "":
                widget.clear() 
            else:
                value_param = QDateTime.fromString(value_param, 'dd/MM/yyyy hh:mm:ss')
                utils_giswater.setCalendarDate(self.dialog, widget, value_param)

        elif type(widget) is QCheckBox:
            if value_param is None or value_param == '0':
                value_param = 0     
            utils_giswater.setChecked(self.dialog, widget, value_param)
            
        elif type(widget) is QComboBox:
            self.manage_combo_parameter(parameter)
            
        else: 
            if value_param is None:
                value_param = str(row['default_value'])
            utils_giswater.setWidgetText(self.dialog, widget, value_param)
            
        # Add to parameters dictionary
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
               
        # Check if any parameter is set
        if self.parameters is None:
            return True 
                       
        # Delete previous data
        sql = ("DELETE FROM " + self.schema_name + ".man_addfields_value"
               " WHERE feature_id = '" + str(self.id) + "';\n")

        # Iterate over all widgets and execute one insert per widget
        # Abort process if any mandatory field is not set        
        for parameter_id, parameter in self.parameters.items():
            widget = parameter.widget
            if type(widget) is QDateEdit or type(widget) is QDateTimeEdit or type(widget) is QgsDateTimeEdit:
                value_param = utils_giswater.getCalendarDate(self.dialog, widget, 'dd/MM/yyyy', 'dd/MM/yyyy hh:mm:ss')
            elif type(widget) is QCheckBox:
                value_param = utils_giswater.isChecked(self.dialog, widget)
                value_param = (1 if value_param else 0)               
            else:            
                value_param = utils_giswater.getWidgetText(self.dialog, widget)
                
            if value_param == 'null' and parameter.is_mandatory:
                message = "This paramater is mandatory. Please, set a value"
                self.controller.show_warning(message, parameter=parameter.form_label)
                return False                        
            elif value_param != 'null':
                sql += ("INSERT INTO " + self.schema_name + ".man_addfields_value (feature_id, parameter_id, value_param)"
                       " VALUES ('" + str(self.id) + "', " + str(parameter_id) + ", '" + str(value_param) + "');\n")      

        # Execute all SQL's together
        self.controller.execute_sql(sql)
        
        return True
                  
    
    def manage_combo_parameter(self, parameter):
        """ Manage parameter of widgettype_id = 'QComboBox' """
        
        sql = None
        if parameter.dv_table and parameter.dv_key_column:
            sql = ("SELECT " + parameter.dv_key_column + ""
                   " FROM " + self.schema_name + "." + parameter.dv_table + ""
                   " ORDER BY " + parameter.dv_key_column)
        
        elif parameter.sql_text != '':
            sql = parameter.sql_text
            if self.schema_name not in sql:
                sql = sql.replace("FROM ", "FROM " + self.schema_name + ".")
            
        if sql:
            rows = self.controller.get_rows(sql, log_sql=True)
            if rows:
                utils_giswater.fillComboBox(parameter, parameter.widget, rows)
                value_param = parameter.value_param
                if value_param:
                    utils_giswater.setWidgetText(parameter, parameter.widget, value_param)
                 

    def check_link(self, dialog, open_link=False):
        """ Check if exist URL from field 'link' in main tab """
        
        field_link = "link"
        widget = self.tab_main.findChild(QTextEdit, field_link)
        if widget:
            url = utils_giswater.getWidgetText(dialog, widget)
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
        sql = ("SELECT node_id FROM " + self.schema_name + ".v_edit_node" 
               " WHERE ST_DWithin(" + str(geom_point) + ", the_geom, " + str(arc_searchnodes) + ")" 
               " ORDER BY ST_Distance(" + str(geom_point) + ", the_geom) LIMIT 1")          
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
        for feature_cat in self.feature_cat.values():           
            if sys_feature_cat_id == feature_cat.id:
                layer = self.controller.get_layer_by_layername(feature_cat.layername)
                return layer

        return None


    def action_copy_paste(self, geom_type):
        """ Copy some fields from snapped feature to current feature """
        
        # Set map tool emit point and signals   
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        self.snapper = self.get_snapper()
        self.canvas.xyCoordinates.connect(self.action_copy_paste_mouse_move)        
        self.emit_point.canvasClicked.connect(self.action_copy_paste_canvas_clicked)
        self.geom_type = geom_type
        
        # Store user snapping configuration
        self.snapper_manager = SnappingConfigManager(self.iface)
        self.snapper_manager.store_snapping_options()

        # Clear snapping
        self.snapper_manager.clear_snapping()

        # Set snapping 
        layer = self.iface.activeLayer()
        self.snapper_manager.snap_to_layer(layer)                    
        
        # Set marker
        color = QColor(255, 100, 255)
        self.vertex_marker = QgsVertexMarker(self.canvas)
        if geom_type == 'node':           
            self.vertex_marker.setIconType(QgsVertexMarker.ICON_CIRCLE)
        elif geom_type == 'arc':
            self.vertex_marker.setIconType(QgsVertexMarker.ICON_CROSS)
        self.vertex_marker.setColor(color)
        self.vertex_marker.setIconSize(15)
        self.vertex_marker.setPenWidth(3)          


    def action_copy_paste_mouse_move(self, point):
        """ Slot function when mouse is moved in the canvas. 
            Add marker if any feature is snapped 
        """
         
        # Hide marker and get coordinates
        self.vertex_marker.hide()
        map_point = self.canvas.getCoordinateTransform().transform(point)
        x = map_point.x()
        y = map_point.y()
        event_point = QPoint(x, y)

        # Snapping
        (retval, result) = self.snapper_manager.snap_to_current_layer(event_point)
        if not result:
            return
            
        # Check snapped features
        for snapped_point in result:
            self.snapper_manager.add_marker(snapped_point, self.vertex_marker)
            break 


    def action_copy_paste_canvas_clicked(self, point, btn):
        """ Slot function when canvas is clicked """
        
        if btn == Qt.RightButton:
            self.disable_copy_paste() 
            return    
                
        # Get clicked point
        map_point = self.canvas.getCoordinateTransform().transform(point)
        x = map_point.x()
        y = map_point.y()
        event_point = QPoint(x, y)
        
        # Snapping
        (retval, result) = self.snapper_manager.snap_to_current_layer(event_point)
        if not result:
            self.disable_copy_paste()            
            return
                
        layer = self.iface.activeLayer()        
        layername = layer.name()        
        is_valid = False
        for snapped_point in result:        
            # Get only one feature
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

        aux = "\"" + str(self.geom_type) + "_id\" = "
        aux += "'" + str(self.id) + "'"
        expr = QgsExpression(aux)
        if expr.hasParserError():
            message = "Expression Error"
            self.controller.show_warning(message, parameter=expr.parserErrorString())
            self.disable_copy_paste()            
            return

        fields = layer.dataProvider().fields()
        layer.startEditing()
        it = layer.getFeatures(QgsFeatureRequest(expr))
        feature_list = [i for i in it]
        if not feature_list:
            self.disable_copy_paste()            
            return
        
        # Select only first element of the feature list
        feature = feature_list[0]
        feature_id = feature.attribute(str(self.geom_type) + '_id')
        message = ("Selected snapped feature_id to copy values from: " + str(snapped_feature_attr[0]) + "\n"
                   "Do you want to copy its values to the current node?\n\n")
        # Replace id because we don't have to copy it!
        snapped_feature_attr[0] = feature_id
        snapped_feature_attr_aux = []
        fields_aux = []

        # Iterate over all fields and copy only specific ones
        for i in range(0, len(fields)):
            if fields[i].name() == 'sector_id' or fields[i].name() == 'dma_id' or fields[i].name() == 'expl_id' \
                or fields[i].name() == 'state' or fields[i].name() == 'state_type' \
                or fields[i].name() == layername+'_workcat_id' or fields[i].name() == layername+'_builtdate' \
                or fields[i].name() == 'verified' or fields[i].name() == str(self.geom_type) + 'cat_id':
                snapped_feature_attr_aux.append(snapped_feature_attr[i])
                fields_aux.append(fields[i].name())
            if self.project_type == 'ud':
                if fields[i].name() == str(self.geom_type) + '_type':
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
          
        try:  
            self.snapper_manager.recover_snapping_options()               
            self.vertex_marker.hide()           
            self.set_action_identify()
            self.canvas.xyCoordinates.disconnect()        
            self.emit_point.canvasClicked.disconnect()            
        except:
            pass


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


    def load_dma(self, dialog, dma_id, geom_type):
        """ Load name from dma table and set into combobox @dma """
        
        feature_id = utils_giswater.getWidgetText(dialog, geom_type + "_id")
        if feature_id == 'NULL':
            return
                     
        sql = ("SELECT t1.name FROM " + self.schema_name + ".dma AS t1"
               " INNER JOIN " + self.schema_name + "." + str(geom_type) + " AS t2 ON t1.dma_id = t2.dma_id "
               " WHERE t2." + str(geom_type) + "_id = '" + str(feature_id) + "'")
        row = self.controller.get_row(sql, commit=True)
        if not row:
            return

        utils_giswater.setWidgetText(dialog, dma_id, row[0])


    def load_pressure_zone(self, dialog, presszonecat_id, geom_type):
        """ Load id cat_presszone from  table and set into combobox @presszonecat_id """

        feature_id = utils_giswater.getWidgetText(dialog, geom_type + "_id")
        if feature_id.lower() == 'null':
            return
                
        sql = ("SELECT t1.descript FROM " + self.schema_name + ".cat_presszone AS t1"
               " INNER JOIN " + self.schema_name + "." + str(geom_type) + " AS t2 ON t1.id = t2.presszonecat_id "
               " WHERE t2." + str(geom_type) + "_id = '" + str(feature_id) + "'")
        row = self.controller.get_row(sql)
        if not row:
            return

        utils_giswater.setWidgetText(dialog, presszonecat_id, row[0])


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


    def load_state_type(self, dialog, state_type, geom_type):
        """ Load name from value_state_type table and set into combobox @state_type """
        
        feature_id = utils_giswater.getWidgetText(dialog, geom_type + "_id")
        if feature_id == 'NULL':
            return
            
        sql = ("SELECT t1.name FROM " + self.schema_name + ".value_state_type AS t1"
               " INNER JOIN " + self.schema_name + "." + str(geom_type) + " AS t2 ON t1.id = t2.state_type "
               " WHERE t2." + str(geom_type) + "_id = '" + str(feature_id) + "'")
        row = self.controller.get_row(sql)
        if not row:
            return
        
        utils_giswater.setWidgetText(dialog, state_type, row[0])


    def manage_tab_scada(self):
        """ Hide tab 'scada' if no data in the view """

        # Check if data in the view
        sql = ("SELECT * FROM " + self.schema_name + ".v_rtc_scada"
               " WHERE node_id = '" + str(self.id) + "';")
        row = self.controller.get_row(sql, log_info=False)
        if not row:
            self.tab_main.removeTab(6) 
            self.tab_scada_removed = 1
                

    def manage_tab_relations(self, viewname, field_id):
        """ Hide tab 'relations' if no data in the view """
        
        # Check if data in the view
        sql = ("SELECT * FROM " + self.schema_name + "." + viewname + ""
               " WHERE " + str(field_id) + " = '" + str(self.id) + "';")
        row = self.controller.get_row(sql, log_info=False)
        if not row:  
            # Hide tab 'relations'
            self.tab_main.removeTab(2)  
            self.tabs_removed += 1                    
        else:
            # Manage signal 'doubleClicked'
            self.tbl_relations.setEditTriggers(QTableView.NoEditTriggers)
            self.tbl_relations.setSelectionBehavior(QAbstractItemView.SelectRows)
            self.tbl_relations.doubleClicked.connect(partial(self.open_relation, field_id))         
     
     
    def open_relation(self, field_id):  
        """ Open feature form of selected element """
        
        selected_list = self.tbl_relations.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        
        row = selected_list[0].row()

        # Get object_id from selected row
        field_object_id = "child_id"
        if field_id == "arc_id":
            field_object_id = "feature_id"

        selected_object_id = self.tbl_relations.model().record(row).value(field_object_id)        
        sys_type = self.tbl_relations.model().record(row).value("sys_type")                
        tablename = "v_edit_man_" + sys_type.lower()             
        layer = self.controller.get_layer_by_tablename(tablename, log_info=True)        
        if not layer:
            return
        
        # Get field_id from model 'sys_feature_cat'       
        if tablename not in list(self.feature_cat.keys()):
            return 
                         
        field_id = self.feature_cat[tablename].type.lower() + "_id"      
        expr_filter = "\"" + field_id+ "\" = "
        expr_filter += "'" + str(selected_object_id) + "'"
        (is_valid, expr) = self.check_expression(expr_filter)
        if not is_valid:
            return           
                                                  
        it = layer.getFeatures(QgsFeatureRequest(expr))
        features = [i for i in it]                                
        if features != []:                                
            self.iface.openFeatureForm(layer, features[0])        
            
        
    def fill_table(self, widget, table_name, filter_=None):
        """ Set a model with selected filter.
        Attach that model to selected table """ 
        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name
        # Set model
        model = QSqlTableModel()
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.setSort(0, 0)
        if filter_:
            model.setFilter(filter_)        
        model.select()       

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())
                    
        # Attach model to table view
        widget.setModel(model)      


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


    def cf_open_dialog(self, dlg=None, dlg_name=None, maximize_button=True, stay_on_top=True):
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


    def dlg_destroyed(self, layer=None, vertex=None):
        self.dlg_is_destroyed = True

        if layer is not None:
            self.iface.setActiveLayer(layer)
        else:
            if self.layer is not None:
                self.iface.setActiveLayer(self.layer)

        if vertex is not None:
            self.iface.mapCanvas().scene().removeItem(vertex)
        else:
            if hasattr(self, 'vertex_marker'):
                if self.vertex_marker is not None:
                    self.iface.mapCanvas().scene().removeItem(self.vertex_marker)


    def enabled_actions(self, action, enabled):
        if not self.dlg_is_destroyed:
            action.setEnabled(enabled)


    def check_actions(self, action, enabled):
        if not self.dlg_is_destroyed:
            action.setChecked(enabled)
            


    def set_dates_from_to(self, widget_to, widget_from, table_name, field_from, field_to):
        sql = ("SELECT MIN(" + field_from + "), MAX(" + field_to + ")"
               " FROM {}.{}".format(self.schema_name, table_name))
        row = self.controller.get_row(sql, log_sql=False)
        if row:
            if row[0]:
                widget_from.setDate(row[0])
            else:
                current_date = QDate.currentDate()
                widget_from.setDate(current_date)
            if row[1]:
                widget_to.setDate(row[1])
            else:
                current_date = QDate.currentDate()
                widget_to.setDate(current_date)


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

