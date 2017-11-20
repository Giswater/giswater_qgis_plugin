'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
import webbrowser

from PyQt4.QtGui import QAbstractItemView, QCompleter, QStringListModel
from PyQt4.QtGui import QPushButton, QTableView, QTabWidget, QAction, QLineEdit, QComboBox

from functools import partial

import utils_giswater
from parent_init import ParentDialog
from actions.edit import Edit


def formOpen(dialog, layer, feature):
    ''' Function called when a connec is identified in the map '''

    global feature_dialog
    utils_giswater.setDialog(dialog)
    # Create class to manage Feature Form interaction  
    feature_dialog = ManConnecDialog(dialog, layer, feature)
    init_config()

    
def init_config():

    # Manage 'connec_type'
    connec_type = utils_giswater.getWidgetText("connec_type") 
    utils_giswater.setSelectedItem("connec_type", connec_type)
     
    # Manage 'connecat_id'
    connecat_id = utils_giswater.getWidgetText("connecat_id") 
    utils_giswater.setSelectedItem("connecat_id", connecat_id)   
        
     
class ManConnecDialog(ParentDialog, Edit):
    
    def __init__(self, dialog, layer, feature):
        ''' Constructor class '''
        super(ManConnecDialog, self).__init__(dialog, layer, feature)
        self.init_config_form()
        #self.controller.manage_translation('ws_man_connec', dialog)                 

        
    def init_config_form(self):
        ''' Custom form initial configuration '''

        table_element = "v_ui_element_x_connec" 
        table_document = "v_ui_doc_x_connec" 
        table_event_connec = "v_ui_om_visit_x_connec"
        table_hydrometer = "v_rtc_hydrometer"    
        table_hydrometer_value = "v_edit_rtc_hydro_data_x_connec"    
        
        # Initialize variables            
        self.table_wjoin = self.schema_name+'."v_edit_man_wjoin"' 
        self.table_tap = self.schema_name+'."v_edit_man_tap"'
        self.table_greentap = self.schema_name+'."v_edit_man_greentap"'
        self.table_fountain = self.schema_name+'."v_edit_man_fountain"'

        # Set icons tab element
        self.btn_element_insert = self.dialog.findChild(QPushButton, "btn_insert")
        self.btn_element_delete = self.dialog.findChild(QPushButton, "btn_delete")
        self.btn_element_new = self.dialog.findChild(QPushButton, "new_element")
        self.btn_element_open = self.dialog.findChild(QPushButton, "open_element")
        self.set_icon(self.btn_element_insert, "111")
        self.set_icon(self.btn_element_delete, "112")
        self.set_icon(self.btn_element_new, "134")
        self.set_icon(self.btn_element_open, "170")


        # Set icons tab document
        self.btn_doc_insert = self.dialog.findChild(QPushButton, "btn_doc_insert")
        self.btn_doc_delete = self.dialog.findChild(QPushButton, "btn_doc_delete")
        self.btn_doc_new = self.dialog.findChild(QPushButton, "btn_doc_new")
        self.btn_open_doc = self.dialog.findChild(QPushButton, "btn_open_doc")
        self.set_icon(self.btn_doc_insert, "111")
        self.set_icon(self.btn_doc_delete, "112")
        self.set_icon(self.btn_doc_new, "134")
        self.set_icon(self.btn_open_doc, "170")
              
        # Define class variables
        self.field_id = "connec_id"        
        self.id = utils_giswater.getWidgetText(self.field_id, False)  
        self.filter = self.field_id+" = '"+str(self.id)+"'"
        self.connecat_id = self.dialog.findChild(QLineEdit, 'connecat_id')
        self.connec_type = self.dialog.findChild(QComboBox, 'connec_type')        
        
        # Get widget controls      
        self.tab_main = self.dialog.findChild(QTabWidget, "tab_main")  
        self.tbl_info = self.dialog.findChild(QTableView, "tbl_element")
        self.tbl_document = self.dialog.findChild(QTableView, "tbl_document") 
        self.tbl_event = self.dialog.findChild(QTableView, "tbl_event_connec") 
        self.tbl_hydrometer = self.dialog.findChild(QTableView, "tbl_hydrometer") 
        self.tbl_hydrometer_value = self.dialog.findChild(QTableView, "tbl_hydrometer_value")
        self.tbl_hydrometer.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.tbl_hydrometer.clicked.connect(self.check_url)

        # Manage tab visibility
        self.set_tabs_visibility(3)  
              
        # Load data from related tables
        self.load_data()
        
        # Fill the info table
        self.fill_table(self.tbl_info, self.schema_name+"."+table_element, self.filter)
        
        # Configuration of info table
        self.set_configuration(self.tbl_info, table_element)    
        
        # Fill the tab Document
        self.fill_tbl_document_man(self.tbl_document, self.schema_name+"."+table_document, self.filter)
        self.tbl_document.doubleClicked.connect(self.open_selected_document)
        
        # Configuration of table Document
        self.set_configuration(self.tbl_document, table_document)
        
        # Fill tab event | connec
        self.fill_tbl_event(self.tbl_event, self.schema_name+"."+table_event_connec, self.filter)
        self.tbl_event.doubleClicked.connect(self.open_selected_document_event)
        
        # Configuration of table event | connec
        self.set_configuration(self.tbl_event, table_event_connec)
        
        # Fill tab hydrometer | hydrometer
        self.fill_tbl_hydrometer(self.tbl_hydrometer, self.schema_name+"."+table_hydrometer, self.filter)
        
        # Configuration of table hydrometer | hydrometer
        self.set_configuration(self.tbl_hydrometer, table_hydrometer)
       
        # Fill tab hydrometer | hydrometer value
        self.fill_tbl_hydrometer(self.tbl_hydrometer_value, self.schema_name+"."+table_hydrometer_value, self.filter)

        # Configuration of table hydrometer | hydrometer value
        self.set_configuration(self.tbl_hydrometer_value, table_hydrometer_value)

        # ---------------------------------

        self.tbl_element = self.dialog.findChild(QTableView, "tbl_element")
        # Set signals
        self.dialog.findChild(QPushButton, "btn_doc_delete").clicked.connect(partial(self.delete_records, self.tbl_document, table_document))
        self.dialog.findChild(QPushButton, "btn_delete").clicked.connect(partial(self.delete_records, self.tbl_element, table_element))

        self.connec_id = self.dialog.findChild(QLineEdit, 'connec_id')
        self.el_id = self.dialog.findChild(QLineEdit, 'element_id')
        self.doc_id = self.dialog.findChild(QLineEdit, 'doc_id')
        self.dialog.findChild(QPushButton, "btn_insert").clicked.connect(partial(self.insert_records, self.el_id, "element_x_connec", "element_id", "connec", self.connec_id,self.tbl_element))
        self.dialog.findChild(QPushButton, "btn_doc_insert").clicked.connect(partial(self.insert_records, self.doc_id, "doc_x_connec", "doc_id", "connec", self.connec_id, self.tbl_document))

        self.btn_element_new.clicked.connect(self.edit_add_element)
        self.btn_element_open.clicked.connect(self.open_element)

        self.btn_doc_new.clicked.connect(self.edit_add_file)
        self.btn_open_doc.clicked.connect(self.open_document)

        # Adding auto-completion to a QLineEdit - doc_id
        self.doc_id = self.dialog.findChild(QLineEdit, "doc_id")
        self.completer = QCompleter()
        self.doc_id.setCompleter(self.completer)
        model = QStringListModel()

        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".doc"
        rows = self.controller.get_rows(sql)
        values = []
        for row in rows:
            values.append(str(row[0]))

        model.setStringList(values)
        self.completer.setModel(model)
        self.controller.log_info("test4")

        # Adding auto-completion to a QLineEdit - element_id
        self.element_id = self.dialog.findChild(QLineEdit, "element_id")
        self.completer = QCompleter()
        self.element_id.setCompleter(self.completer)
        model = QStringListModel()

        sql = "SELECT DISTINCT(element_id) FROM " + self.schema_name + ".element"
        rows = self.controller.get_rows(sql)
        values = []
        for row in rows:
            values.append(str(row[0]))

        model.setStringList(values)
        self.completer.setModel(model)
        # -----------------------------

        
        # Set signals          
        self.dialog.findChild(QPushButton, "btn_doc_delete").clicked.connect(partial(self.delete_records, self.tbl_document, table_document))            
        #self.dialog.findChild(QPushButton, "delete_row_info_2").clicked.connect(partial(self.delete_records, self.tbl_info, table_element))       
        self.dialog.findChild(QPushButton, "btn_delete_hydrometer").clicked.connect(partial(self.delete_records_hydro, self.tbl_hydrometer))               
        self.dialog.findChild(QPushButton, "btn_add_hydrometer").clicked.connect(self.insert_records)
        self.open_link = self.dialog.findChild(QPushButton, "open_link")
        self.open_link.setEnabled(False)
        self.open_link.clicked.connect(self.open_url)
        feature = self.feature
        canvas = self.iface.mapCanvas()
        layer = self.iface.activeLayer()

        # Toolbar actions
        action = self.dialog.findChild(QAction, "actionEnabled")
        self.dialog.findChild(QAction, "actionZoom").triggered.connect(partial(self.action_zoom_in, feature, canvas, layer))
        self.dialog.findChild(QAction, "actionCentered").triggered.connect(partial(self.action_centered,feature, canvas, layer))
        self.dialog.findChild(QAction, "actionEnabled").triggered.connect(partial(self.action_enabled, action, layer))
        self.dialog.findChild(QAction, "actionZoomOut").triggered.connect(partial(self.action_zoom_out, feature, canvas, layer))
        self.dialog.findChild(QAction, "actionLink").triggered.connect(partial(self.check_link, True))


    def open_element(self):
        # Get selected rows
        selected_list = self.tbl_element.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        row = selected_list[0].row()
        id_element = self.tbl_element.model().record(row).value("element_id")

        self.edit_add_element()
        self.dlg.element_id.setText(str(id_element))
        '''
        element_id = self.element_id.text()
        if element_id != "" :
            self.dlg.element_id.setText(str(element_id))
        '''


    def open_document(self):
        # Get selected rows
        selected_list = self.tbl_document.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        row = selected_list[0].row()
        id_doc = self.tbl_document.model().record(row).value("doc_id")

        self.add_new_doc()
        self.dlg.doc_id.setText(str(id_doc))
        '''
        element_id = self.element_id.text()
        if element_id != "" :
            self.dlg.element_id.setText(str(element_id))
        '''

    def insert_records(self, widget, table, attribute, feature, widget_id, widget_table):

        id_ = widget.text()
        feature_id = widget_id.text()

        # Check if we already have data with selected element_id
        sql = "SELECT DISTINCT(" + str(feature) + "_id) FROM " + self.schema_name + "." + str(table) + " WHERE " + str(attribute) + "= '" + str(id_) + "' and " + str(feature) + "_id = '" + str(feature_id) + "'"
        row = self.dao.get_row(sql)
        if row:
            # If element exist
            message = "Record already exist"
            self.controller.show_info_box(message, context_name='ui_message')

        if not row:
            sql = "INSERT INTO " + self.schema_name + "." + table + " (" + attribute + "," +feature+"_id )"
            sql += " VALUES ('" + str(id_) + "', '" + str(feature_id) + "')"
            status = self.controller.execute_sql(sql)
            if status:
                message = "Values has been updated !"
                self.controller.show_info(message)

        # Reload table
        widget_table.model().select()


    def check_url(self):
        """ Check URL. Enable/Disable button that opens it """
        
        selected_list = self.tbl_hydrometer.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        
        row = selected_list[0].row()
        url = self.tbl_hydrometer.model().record(row).value("hydrometer_link")
        if url != '':
            self.url = url
            self.open_link.setEnabled(True)
        else:
            self.open_link.setEnabled(False)


    def open_url(self):
        """ Open URL """
        webbrowser.open(self.url)
        
