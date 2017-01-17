# -*- coding: utf-8 -*-
from qgis.utils import iface
from qgis.gui import QgsMessageBar
from PyQt4.QtCore import QSettings, Qt
from PyQt4.QtGui import QLabel, QComboBox, QDateEdit
from PyQt4.QtSql import QSqlTableModel

from functools import partial
import os.path
import sys  

import utils_giswater
from controller import DaoController
        
        
class ParentDialog(object):   
    
    def __init__(self, dialog, layer, feature):
        ''' Constructor class '''     
        self.dialog = dialog
        self.layer = layer
        self.feature = feature
        self.context_name = "ws_parent"    
        self.iface = iface    
        self.init_config() 
        self.set_signals()            
    
        
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
            self.close()
            return
            
        # Set plugin settings            
        self.settings = QSettings(setting_file, QSettings.IniFormat)
        self.settings.setIniCodec(sys.getfilesystemencoding())
        
        # Set QGIS settings. Stored in the registry (on Windows) or .ini file (on Unix) 
        self.qgis_settings = QSettings()
        self.qgis_settings.setIniCodec(sys.getfilesystemencoding())            
        
        # Set controller to handle settings and database connection
        self.controller = DaoController(self.settings, self.plugin_name, iface)
        self.controller.set_qgis_settings(self.qgis_settings)             
        status = self.controller.set_database_connection()      
        if not status:
            message = self.controller.last_error
            self.controller.show_warning(message) 
            return 
          
        # Get schema_name and DAO object                
        self.dao = self.controller.dao
        self.schema_name = self.controller.schema_name          
            
    
    def set_signals(self):
        try: 
            self.dialog.parent().accepted.connect(self.save)
            self.dialog.parent().rejected.connect(self.close)
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
         
       
    def load_tab_add_info(self):
        ''' Load data from tab 'Add. info' '''                
        pass

    def load_tab_analysis(self):
        ''' Load data from tab 'Analysis' '''          
        pass
                
    def load_tab_document(self):
        ''' Load data from tab 'Document' '''   
        pass
                
    def load_tab_picture(self):
        ''' Load data from tab 'Document' '''   
        pass
                
    def load_tab_event(self):
        ''' Load data from tab 'Event' '''   
        pass
                
    def load_tab_log(self):
        ''' Load data from tab 'Log' '''   
        pass
        
    def load_tab_rtc(self):
        ''' Load data from tab 'RTC' '''   
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
        ''' Save tab from tab 'Document' '''   
        pass
                
    def save_tab_picture(self):
        ''' Save tab from tab 'Document' '''   
        pass
                
    def save_tab_event(self):
        ''' Save tab from tab 'Event' '''   
        pass
                
    def save_tab_log(self):
        ''' Save tab from tab 'Log' '''   
        pass
        
    def save_tab_rtc(self):
        ''' Save tab from tab 'RTC' '''   
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
            self.controller.execute_sql(sql)
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
                self.controller.show_warning(message, context_name='ui_message')
               
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
            self.controller.show_warning(message, context_name='ui_message')                   
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
        sql+= " FROM "+self.schema_name+".config_ui_forms"
        sql+= " WHERE ui_table = '"+table_name+"'"
        sql+= " ORDER BY column_index"
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
        self.tbl_document.doubleClicked.connect(self.open_selected_document)

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
        

    def fill_table(self, widget, table_name, filter_): 
        ''' Fill info tab of node '''
        self.set_model_to_table(widget, table_name, filter_)                  
                
        