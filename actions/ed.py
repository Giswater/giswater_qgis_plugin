'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from PyQt4.QtGui import QCompleter, QLineEdit, QStringListModel, QDateTimeEdit, QFileDialog, QPushButton
from qgis.gui import QgsMessageBar

import os
import sys
import webbrowser
from functools import partial
  
plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater      
         
from ..ui.add_element import Add_element    # @UnresolvedImport
from ..ui.add_doc import Add_doc          # @UnresolvedImport


class Ed():
   
    def __init__(self, iface, settings, controller, plugin_dir):     
        ''' Class to control Management toolbar actions '''  
        
        # Initialize instance attributes  
        self.iface = iface
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir       
        self.dao = self.controller.dao             
        self.schema_name = self.controller.schema_name    
        
        # Get files to execute giswater jar   
        self.java_exe = self.settings.value('files/java_exe')          
        self.gsw_file = self.controller.plugin_settings_value('gsw_file')  
        
        # Get tables or views specified in 'db' config section         
        self.table_arc = self.settings.value('db/table_arc', 'v_edit_arc')        
        self.table_node = self.settings.value('db/table_node', 'v_edit_node')   
        self.table_connec = self.settings.value('db/table_connec', 'v_edit_connec')   
        self.table_gully = self.settings.value('db/table_gully', 'v_edit_gully') 
        
        self.table_man_arc = self.settings.value('db/table_man_arc', 'v_edit_man_arc')        
        self.table_man_node = self.settings.value('db/table_man_node', 'v_edit_man_node')   
        self.table_man_connec = self.settings.value('db/table_man_connec', 'v_edit_man_connec')   
        self.table_man_gully = self.settings.value('db/table_man_gully', 'v_edit_man_gully') 
        
        self.table_version = self.settings.value('db/table_version', 'version') 
        
        # Tables connec_group
        self.table_wjoin = self.settings.value('db/table_wjoin', 'v_edit_man_wjoin')
        self.table_tap = self.settings.value('db/table_tap', 'v_edit_man_tap')
        self.table_greentap = self.settings.value('db/table_greentap', 'v_edit_man_greentap')
        self.table_fountain = self.settings.value('db/table_fountain', 'v_edit_man_fountain')
        
        # Tables node_group
        self.table_tank = self.settings.value('db/table_tank', 'v_edit_man_tank')
        self.table_pump = self.settings.value('db/table_pump', 'v_edit_man_pump')
        self.table_source = self.settings.value('db/table_source', 'v_edit_man_source')
        self.table_meter = self.settings.value('db/table_meter', 'v_edit_man_meter')
        self.table_junction = self.settings.value('db/table_junction', 'v_edit_man_junction')
        self.table_waterwell = self.settings.value('db/table_waterwell', 'v_edit_man_waterwell')
        self.table_reduction = self.settings.value('db/table_reduction', 'v_edit_man_reduction')
        self.table_hydrant = self.settings.value('db/table_hydrant', 'v_edit_man_hydrant')
        self.table_valve = self.settings.value('db/table_valve', 'v_edit_man_valve')
        self.table_manhole = self.settings.value('db/table_manhole', 'v_edit_man_manhole')
        
        # Tables arc_group
        self.table_varc = self.settings.value('db/table_varc', 'v_edit_man_varc')  
        self.table_siphon = self.settings.value('db/table_siphon', 'v_edit_man_siphon')
        self.table_conduit = self.settings.value('db/table_conduit', 'v_edit_man_conduit')      
        self.table_waccel = self.settings.value('db/table_waccel', 'v_edit_man_waccel') 
        
        self.table_chamber = self.settings.value('db/table_chamber', 'v_edit_man_chamber') 
        self.table_chamber_pol = self.settings.value('db/table_chamber', 'v_edit_man_chamber_pol') 
        self.table_netgully = self.settings.value('db/table_netgully', 'v_edit_man_netgully') 
        self.table_netgully_pol = self.settings.value('db/table_netgully_pol', 'v_edit_man_netgully_pol')
        self.table_netinit = self.settings.value('db/table_netinit', 'v_edit_man_netinit')     
        self.table_wjump = self.settings.value('db/table_wjump', 'v_edit_man_wjump')  
        self.table_wwtp = self.settings.value('db/table_wwtp', 'v_edit_man_wwtp') 
        self.table_wwtp_pol = self.settings.value('db/table_wwtp_pol', 'v_edit_man_wwtp_pol')
        self.table_storage = self.settings.value('db/table_storage', 'v_edit_man_storage')
        self.table_storage_pol = self.settings.value('db/table_storage_pol', 'v_edit_man_storage_pol')  
        self.table_outfall = self.settings.value('db/table_outfall', 'v_edit_man_outfall')   
        
               
    def close_dialog(self, dlg=None): 
        ''' Close dialog '''
        
        if dlg is None or type(dlg) is bool:
            dlg = self.dlg
        try:
            dlg.close()
        except AttributeError:
            pass    
                  
            
    def ed_search_plus(self):   
        ''' Button 32. Open search plus dialog ''' 
        
        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, 32)
        
        try:
            if self.search_plus is not None:         
                self.search_plus.dlg.setVisible(True)             
        except RuntimeError:
            pass
            
                
    def ed_check(self):
        ''' Initial check for buttons 33 and 34 '''
        
        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, 32)
        
        # Check if at least one node is checked          
        self.layer = self.iface.activeLayer()  
        if self.layer is None:
            message = "You have to select a layer"
            self.controller.show_info(message, context_name='ui_message')  
            return False       
            
        count = self.layer.selectedFeatureCount()   
        if count == 0:
            message = "You have to select at least one feature!"
            self.controller.show_info(message, context_name='ui_message')  
            return False  

        return True
    
    
    def populate_combo(self, widget, table_name, field_name="id"): 
        ''' Executes query and fill combo box ''' 
        
        sql = "SELECT "+field_name+" FROM "+self.schema_name+"."+table_name+" ORDER BY "+field_name
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox(widget, rows)
        if len(rows) > 0:  
            utils_giswater.setCurrentIndex(widget, 1);             


    def ed_giswater_jar(self):   
        ''' Button 36. Open giswater.jar with selected .gsw file '''
        
        # Get giswater information from windows registry
        reg_hkey = "HKEY_LOCAL_MACHINE"
        reg_path = "SOFTWARE\\Giswater\\2.1"
        reg_name = "InstallFolder"
        giswater_folder = utils_giswater.get_reg(reg_hkey, reg_path, reg_name)
        if giswater_folder is None:
            message = "Cannot get giswater folder from windows registry at: "+reg_path
            self.controller.show_info(message, 10, context_name='ui_message')
            return
            
        # Check if giswater folder exists
        if not os.path.exists(giswater_folder):
            message = "Giswater folder not found at: "+giswater_folder
            self.controller.show_warning(message, 10, context_name='ui_message')
            return          
            
        # Check if giswater executable file file exists
        giswater_jar = giswater_folder+"\giswater.jar"
        if not os.path.exists(giswater_jar):
            message = "Giswater executable file not found at: "+giswater_jar
            self.controller.show_warning(message, 10, context_name='ui_message')
            return               

        # Check if java.exe file exists
        if not os.path.exists(self.java_exe):
            message = "Java Runtime executable file not found at: "+self.java_exe
            self.controller.show_warning(message, 10, context_name='ui_message')
            return       
        
        # Check if gsw file exists. If not giswater will open with the last .gsw file
        if self.gsw_file != "" and not os.path.exists(self.gsw_file):
            message = "GSW file not found at: "+self.gsw_file
            self.controller.show_info(message, 10, context_name='ui_message')
            self.gsw_file = ""          
        
        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, 36)                
        
        # Start program     
        aux = '"'+giswater_jar+'"'
        if self.gsw_file != "":
            aux+= ' "'+self.gsw_file+'"'
            program = [self.java_exe, "-jar", giswater_jar, self.gsw_file, "ed_giswater_jar"]
        else:
            program = [self.java_exe, "-jar", giswater_jar, "", "ed_giswater_jar"]
            
        self.controller.start_program(program)               
        
        # Show information message    
        message = "Executing... "+aux
        self.controller.show_info(message, context_name='ui_message')
                                              
                          
    def ed_add_element(self):
        ''' Button 33. Add element '''

        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, 32)       
          
        # Create the dialog and signals
        self.dlg = Add_element()
        utils_giswater.setDialog(self.dlg)
        self.dlg.btn_accept.pressed.connect(self.ed_add_element_accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)
        
        # Manage i18n of the form
        self.controller.translate_form(self.dlg, 'element')            
        
        # Check if we have at least one feature selected
        if not self.ed_check():
            return
            
        # Fill combo boxes
        self.populate_combo("elementcat_id", "cat_element")
        self.populate_combo("state", "value_state")
        self.populate_combo("location_type", "man_type_location")
        self.populate_combo("workcat_id", "cat_work")
        self.populate_combo("buildercat_id", "cat_builder")
        self.populate_combo("ownercat_id", "cat_owner")
        self.populate_combo("verified", "value_verified")
        self.populate_combo("workcat_id_end", "cat_work")
        
        # Adding auto-completion to a QLineEdit
        self.edit = self.dlg.findChild(QLineEdit, "element_id")
        self.completer = QCompleter()
        self.edit.setCompleter(self.completer)
        model = QStringListModel()
        sql = "SELECT DISTINCT(element_id) FROM "+self.schema_name+".element "
        row = self.dao.get_rows(sql)
        for i in range(0,len(row)):
            aux = row[i]
            row[i] = str(aux[0])
            
        model.setStringList(row)
        self.completer.setModel(model)
        
        # Set signal to reach selected value from QCompleter
        self.completer.activated.connect(self.ed_add_el_autocomplete)
        
        # Open the dialog
        self.dlg.exec_()    
        
        
    def get_date(self):
        ''' Get date_from and date_to from ComboBoxes
        Filter the table related on selected value
        '''
        
        # Get widgets
        self.date_document_from = self.dlg.findChild(QDateTimeEdit, "builtdate") 
        self.date_document_to = self.dlg.findChild(QDateTimeEdit, "enddate")     
        
        # Get date
        date_from=self.date_document_from.date() 
        date_to=self.date_document_to.date() 
      
        # Check if interval is valid
        if (date_from < date_to):
            pass
        else :
            message = "Date interval not valid!"
            self.iface.messageBar().pushMessage(message, QgsMessageBar.WARNING, 5) 
            return

        
    def ed_add_el_autocomplete(self):    
        ''' Once we select 'element_id' using autocomplete, fill widgets with current values '''

        self.dlg.element_id.setCompleter(self.completer)
        element_id = utils_giswater.getWidgetText("element_id") 
        
        # Get values from database       
        sql = "SELECT elementcat_id, location_type, ownercat_id, state, workcat_id," 
        sql+= " buildercat_id, annotation, observ, comment, link, verified, rotation"
        sql+= " FROM "+self.schema_name+".element" 
        sql+= " WHERE element_id = '"+element_id+"'"
        row = self.dao.get_row(sql)
        
        # Fill widgets
        columns_length = self.dao.get_columns_length()
        for i in range(0, columns_length):
            column_name = self.dao.get_column_name(i)
            utils_giswater.setWidgetText(column_name, row[column_name]) 

    
    def ed_add_element_accept(self):
        ''' Function for btn_accept of btn_33
        Update or Insert values '''
           
        # Get values from dialog
        element_id = utils_giswater.getWidgetText("element_id")
        elementcat_id = utils_giswater.getWidgetText("elementcat_id")  
        workcat_id_end = utils_giswater.getWidgetText("workcat_id_end") 
        state = utils_giswater.getWidgetText("state")   
        annotation = utils_giswater.getWidgetText("annotation")
        observ = utils_giswater.getWidgetText("observ")
        comment = utils_giswater.getWidgetText("comment")
        location_type = utils_giswater.getWidgetText("location_type")
        workcat_id = utils_giswater.getWidgetText("workcat_id")
        buildercat_id = utils_giswater.getWidgetText("buildercat_id")
        ownercat_id = utils_giswater.getWidgetText("ownercat_id")
        rotation = utils_giswater.getWidgetText("rotation")
        link = utils_giswater.getWidgetText("link")
        verified = utils_giswater.getWidgetText("verified")
        
        if element_id == 'null':
            # Show warning message    
            message = "You need to insert element_id"
            self.controller.show_warning(message, context_name='ui_message')   
            return
        
        # Check if we already have data with selected element_id
        sql = "SELECT DISTINCT(element_id) FROM "+self.schema_name+".element WHERE element_id = '"+element_id+"'"    
        row = self.dao.get_row(sql)
        if row:
            answer = self.controller.ask_question("Are you sure you want change the data?")
            if answer:
                # If data for selected element_id exist than UPDATE
                sql = "UPDATE "+self.schema_name+".element"
                sql+= " SET element_id = '"+element_id+"', elementcat_id= '"+elementcat_id+"',state = '"+state+"', location_type = '"+location_type+"'"
                sql+= ", workcat_id_end= '"+workcat_id_end+"', workcat_id= '"+workcat_id+"',buildercat_id = '"+buildercat_id+"', ownercat_id = '"+ownercat_id+"'"
                sql+= ", rotation= '"+rotation+"',comment = '"+comment+"', annotation = '"+annotation+"', observ= '"+observ+"',link = '"+link+"', verified = '"+verified+"'"
                sql+= " WHERE element_id = '"+element_id+"'" 
                status = self.controller.execute_sql(sql)
                if status:
                    # Inserting value to table_name of feature
                    self.ed_add_to_feature("element", element_id)
                    # Show message to user
                    message = "Values has been updated"
                    self.controller.show_info(message) 
                
            else:
                self.close_dialog(self.dlg)
        else:
            # If data for selected element_id doesn't exist than INSERT
            sql = "INSERT INTO "+self.schema_name+".element (element_id, elementcat_id, state, location_type"
            sql+= ", workcat_id, buildercat_id, ownercat_id, rotation, comment, annotation, observ, link, verified,workcat_id_end) "
            sql+= " VALUES ('"+element_id+"', '"+elementcat_id+"', '"+state+"', '"+location_type+"', '"
            sql+= workcat_id+"', '"+buildercat_id+"', '"+ownercat_id+"', '"+rotation+"', '"+comment+"', '"
            sql+= annotation+"','"+observ+"','"+link+"','"+verified+"','"+workcat_id_end+"')"
            status = self.controller.execute_sql(sql) 
            if status:
                # Inserting value to table_name of feature
                self.ed_add_to_feature("element", element_id) 
                # Show message to user
                message = "Values has been updated"
                self.controller.show_info(message)
            if not status:
                message = "Error inserting element in table, you need to review data"
                self.controller.show_warning(message, context_name='ui_message') 
                return

        self.close_dialog()
    
    
    def ed_add_file(self):
        ''' Button 34. Add file '''

        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, 32)      
                        
        # Create the dialog and signals
        self.dlg = Add_doc()
        utils_giswater.setDialog(self.dlg)
        self.dlg.btn_accept.pressed.connect(self.ed_add_file_accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)
        
        # Get widgets
        self.path = self.dlg.findChild(QLineEdit, "path")
        self.dlg.findChild(QPushButton, "path_url").clicked.connect(partial(self.open_web_browser,self.path))
        self.dlg.findChild(QPushButton, "path_doc").clicked.connect(partial(self.open_file_dialog,self.path))
        
        # Manage i18n of the form
        self.controller.translate_form(self.dlg, 'file')               
        
        # Check if we have at least one feature selected
        if not self.ed_check():
            return
            
        # Fill combo boxes
        self.populate_combo("doc_type", "doc_type")
        self.populate_combo("tagcat_id", "cat_tag")
        
        # Adding auto-completion to a QLineEdit
        self.edit = self.dlg.findChild(QLineEdit, "doc_id")
        self.completer = QCompleter()
        self.edit.setCompleter(self.completer)
        model = QStringListModel()
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".doc "
        row = self.dao.get_rows(sql)
        for i in range(0,len(row)):
            aux = row[i]
            row[i] = str(aux[0])
        
        model.setStringList(row)
        self.completer.setModel(model)
        
        # Set signal to reach selected value from QCompleter
        self.completer.activated.connect(self.ed_add_file_autocomplete)
        # Refresh
        
        # Open the dialog
        self.dlg.exec_()
        
  
    def ed_add_file_autocomplete(self): 
        ''' Once we select 'element_id' using autocomplete, fill widgets with current values '''
        
        self.dlg.doc_id.setCompleter(self.completer)
        doc_id = utils_giswater.getWidgetText("doc_id") 
        
        # Get values from database           
        sql = "SELECT doc_type, tagcat_id, observ, path"
        sql+= " FROM "+self.schema_name+".doc" 
        sql+= " WHERE id = '"+doc_id+"'"
        row = self.dao.get_row(sql)
        
        # Fill widgets
        columns_length = self.dao.get_columns_length()
        for i in range(0, columns_length):
            column_name = self.dao.get_column_name(i)
            utils_giswater.setWidgetText(column_name, row[column_name])       
    
    
    def ed_add_to_feature(self, table_name, value_id):   
        ''' Add document or element to selected features '''
        
        # Get schema and table name of selected layer       
        layer_source = self.controller.get_layer_source(self.layer)
        uri_table = layer_source['table'] 

        if uri_table is None:
            self.controller.show_warning("Error getting table name from selected layer")
            return
        
        field_id= None

        if self.table_arc in uri_table:  
            elem_type = "arc"
            field_id = "arc_id"
        if self.table_node in uri_table: 
            elem_type = "node"
            field_id = "node_id"
        if self.table_connec in uri_table: 
            elem_type = "connec"
            field_id = "connec_id"
        if self.table_gully in uri_table:  
            elem_type = "gully"
            field_id = "gully_id"  
            
        if self.table_man_arc in uri_table:  
            elem_type = "arc"
            field_id = "arc_id"
        if self.table_man_node in uri_table: 
            elem_type = "node"
            field_id = "node_id"
        if self.table_man_connec in uri_table: 
            elem_type = "connec"
            field_id = "connec_id"
        if self.table_man_gully in uri_table:  
            elem_type = "gully"
            field_id = "gully_id"
                 
        if self.table_wjoin in uri_table:  
            elem_type = "connec"
            field_id = "connec_id"
        if self.table_tap in uri_table:  
            elem_type = "connec"
            field_id = "connec_id"
        if self.table_greentap in uri_table:  
            elem_type = "connec"
            field_id = "connec_id"
        if self.table_fountain in uri_table:  
            elem_type = "connec"
            field_id = "connec_id"
             
        if self.table_tank in uri_table:  
            elem_type = "node"
            field_id = "node_id"
        if self.table_pump in uri_table:  
            elem_type = "node"
            field_id = "node_id"    
        if self.table_source in uri_table:  
            elem_type = "node"
            field_id = "node_id"    
        if self.table_meter in uri_table:  
            elem_type = "node"
            field_id = "node_id"
        if self.table_junction in uri_table:  
            elem_type = "node"
            field_id = "node_id"
        if self.table_waterwell in uri_table:  
            elem_type = "node"
            field_id = "node_id"
        if self.table_reduction in uri_table:  
            elem_type = "node"
            field_id = "node_id"
        if self.table_hydrant in uri_table:  
            elem_type = "node"
            field_id = "node_id"
        if self.table_valve in uri_table:  
            elem_type = "node"
            field_id = "node_id"
        if self.table_manhole in uri_table:  
            elem_type = "node"
            field_id = "node_id"
            
        if self.table_chamber in uri_table:  
            elem_type = "node"
            field_id = "node_id"
        if self.table_chamber_pol in uri_table:  
            elem_type = "node"
            field_id = "node_id"
        if self.table_netgully in uri_table:  
            elem_type = "node"
            field_id = "node_id"
        if self.table_netgully_pol in uri_table:  
            elem_type = "node"
            field_id = "node_id"
        if self.table_netinit in uri_table:  
            elem_type = "node"
            field_id = "node_id"
        if self.table_wjump in uri_table:  
            elem_type = "node"
            field_id = "node_id"
        if self.table_wwtp in uri_table:  
            elem_type = "node"
            field_id = "node_id"
        if self.table_wwtp_pol in uri_table:  
            elem_type = "node"
            field_id = "node_id"
        if self.table_storage in uri_table:  
            elem_type = "node"
            field_id = "node_id"
        if self.table_storage_pol in uri_table:  
            elem_type = "node"
            field_id = "node_id"
        if self.table_outfall in uri_table:  
            elem_type = "node"
            field_id = "node_id"
                
        if self.table_varc in uri_table:  
            elem_type = "arc"
            field_id = "arc_id"
        if self.table_siphon in uri_table:  
            elem_type = "arc"
            field_id = "arc_id"
        if self.table_conduit in uri_table:  
            elem_type = "arc"
            field_id = "arc_id"
        if self.table_waccel in uri_table:  
            elem_type = "arc"
            field_id = "arc_id"

        # Get selected features
        features = self.layer.selectedFeatures()
        for feature in features:
            elem_id = feature.attribute(field_id)
            sql = "INSERT INTO "+self.schema_name+"."+table_name+"_x_"+elem_type+" ("+field_id+", "+table_name+"_id) "
            sql+= " VALUES ('"+elem_id+"', '"+value_id+"')"
            
            self.controller.execute_sql(sql) 
            
                          
    def ed_add_file_accept(self): 
        ''' Insert or update document. Add document to selected feature '''  
        
        # Get values from dialog
        doc_id = utils_giswater.getWidgetText("doc_id") 
        doc_type = utils_giswater.getWidgetText("doc_type")   
        tagcat_id = utils_giswater.getWidgetText("tagcat_id")  
        observ = utils_giswater.getWidgetText("observ")
        path = utils_giswater.getWidgetText("path")
        

        if doc_id == 'null':
            # Show warning message    
            message = "You need to insert doc_id"
            self.controller.show_warning(message, context_name='ui_message' )   
            return
        # Check if this document already exists
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".doc WHERE id = '"+doc_id+"'" 
        row = self.dao.get_row(sql)
        if row:
            answer = self.controller.ask_question("Are you sure you want change the data?")
            
            if answer:
                # If document already exist than UPDATE
                sql = "UPDATE "+self.schema_name+".doc "
                sql+= " SET doc_type = '"+doc_type+"', tagcat_id= '"+tagcat_id+"',observ = '"+observ+"', path = '"+path+"'"
                sql+= " WHERE id = '"+doc_id+"'" 
                status = self.controller.execute_sql(sql) 
                if status:
                    # Inserting value to table_name of feature
                    self.ed_add_to_feature("doc", doc_id)
                    # Show message to user
                    message = "Values has been updated"
                    self.controller.show_info(message)
            else:
                
                self.close_dialog(self.dlg) 
        else:
            # If document doesnt exist than INSERT
            sql = "INSERT INTO "+self.schema_name+".doc (id, doc_type, path, observ, tagcat_id) "
            sql+= " VALUES ('"+doc_id+"', '"+doc_type+"', '"+path+"', '"+observ+"', '"+tagcat_id+"')"
            status = self.controller.execute_sql(sql)
            if status:
                # Inserting value to table_name of feature
                self.ed_add_to_feature("doc", doc_id) 
                # Show message to user
                message = "Values has been updated"
                self.controller.show_info(message)
            if not status:
                message = "Error inserting element in table, you need to review data"
                self.controller.show_warning(message, context_name='ui_message')
                return

        self.close_dialog()  
          
        
    def open_file_dialog(self,widget):
        ''' Open File Dialog '''
   
        # Set default value from QLine
        self.file_path = utils_giswater.getWidgetText(widget)
    
        # Check if file exists
        if not os.path.exists(self.file_path):
            message = "File path doesn't exist"
            self.controller.show_warning(message, 10, context_name='ui_message')
            self.file_path = self.plugin_dir
        # Set default value if necessary
        elif self.file_path == 'null': 
            self.file_path = self.plugin_dir
                
        # Get directory of that file
        folder_path = os.path.dirname(self.file_path)
        os.chdir(folder_path)
        msg = "Select file"
        self.file_path = QFileDialog.getOpenFileName(None, self.controller.tr(msg), "")

        # Set text to QLineEdit
        widget.setText(self.file_path)     


    def open_web_browser(self, widget):
        ''' Display url using the default browser '''
    
        url = utils_giswater.getWidgetText(widget) 
        
        if url == 'null' :
            url = 'www.giswater.org'
            webbrowser.open(url)
        else :
            webbrowser.open(url)
            
            