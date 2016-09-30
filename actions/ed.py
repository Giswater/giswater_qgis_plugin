# -*- coding: utf-8 -*-
from PyQt4.QtGui import QCompleter, QLineEdit, QStringListModel

import os
import sys
  
plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater      
         
from ..ui.add_element import Add_element    # @UnresolvedImport
from ..ui.add_file import Add_file          # @UnresolvedImport


class Ed():
   
    def __init__(self, iface, settings, controller, plugin_dir):
        
        ''' Class to control Management toolbar actions '''    
        self.iface = iface
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir       
        self.dao = self.controller.dao             
        self.schema_name = self.controller.schema_name    
        
        # Get files to execute giswater jar
        self.java_exe = self.settings.value('files/java_exe')          
        self.giswater_jar = self.settings.value('files/giswater_jar')          
        self.gsw_file = self.settings.value('files/gsw_file')  
        
        # Get tables or views specified in 'db' config section         
        self.table_arc = self.settings.value('db/table_arc', 'v_edit_arc')        
        self.table_node = self.settings.value('db/table_node', 'v_edit_node')   
        self.table_connec = self.settings.value('db/table_connec', 'v_edit_connec')   
        self.table_gully = self.settings.value('db/table_gully', 'v_edit_gully') 
        self.table_version = self.settings.value('db/table_version', 'version')                               
    
                  
    def close_dialog(self, dlg=None): 
        ''' Close dialog '''
        if dlg is None or type(dlg) is bool:
            dlg = self.dlg
        try:
            dlg.close()
        except AttributeError as e:
            print "AttributeError: "+str(e)    
                  
            
    def ed_search_plus(self):   
        ''' Button 32. Open search plus dialog ''' 
        try:
            if self.search_plus is not None:         
                self.search_plus.dlg.setVisible(True)             
        except RuntimeError as e:
            print "Error ed_search_plus: "+str(e)
            
                
    def ed_check(self):
        ''' Initial check for buttons 33 and 34 '''
        
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
        elif count > 1:  
            message = "More than one feature selected. Only the first one will be processed!"
            self.controller.show_info(message, context_name='ui_message') 

        return True
    
    
    def populate_combo(self, widget, table_name, field_name="id"): 
        ''' Executes query and fill combo box ''' 
        sql = "SELECT "+field_name+" FROM "+self.schema_name+"."+table_name+" ORDER BY "+field_name
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox(widget, rows)
        if len(rows) > 0:  
            utils_giswater.setCurrentIndex(widget, 1);             
        
                          
    def ed_add_element(self):
        ''' Button 33. Add element '''
          
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
        self.populate_combo("elementcat_id", "cat_element")
        self.populate_combo("ownercat_id", "cat_owner")
        self.populate_combo("verified", "value_verified")
        
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
           
        # Get values from dialog
        element_id = utils_giswater.getWidgetText("element_id")
        elementcat_id = utils_giswater.getWidgetText("elementcat_id")  
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

        # Check if we already have data with selected element_id
        sql = "SELECT DISTINCT(element_id) FROM "+self.schema_name+".element WHERE element_id = '"+element_id+"'"    
        row = self.dao.get_row(sql)
        if row:
            answer = self.controller.ask_question("Are you sure you want change the data?")
            if answer:
                sql = "UPDATE "+self.schema_name+".element"
                sql+= " SET element_id = '"+element_id+"', elementcat_id= '"+elementcat_id+"',state = '"+state+"', location_type = '"+location_type+"'"
                sql+= ", workcat_id= '"+workcat_id+"',buildercat_id = '"+buildercat_id+"', ownercat_id = '"+ownercat_id+"'"
                sql+= ", rotation= '"+rotation+"',comment = '"+comment+"', annotation = '"+annotation+"', observ= '"+observ+"',link = '"+link+"', verified = '"+verified+"'"
                sql+= " WHERE element_id = '"+element_id+"'" 
                self.dao.execute_sql(sql)  
            else:
                self.close_dialog(self.dlg)
        else:
            sql = "INSERT INTO "+self.schema_name+".element (element_id, elementcat_id, state, location_type"
            sql+= ", workcat_id, buildercat_id, ownercat_id, rotation, comment, annotation, observ, link, verified) "
            sql+= " VALUES ('"+element_id+"', '"+elementcat_id+"', '"+state+"', '"+location_type+"', '"
            sql+= workcat_id+"', '"+buildercat_id+"', '"+ownercat_id+"', '"+rotation+"', '"+comment+"', '"
            sql+= annotation+"','"+observ+"','"+link+"','"+verified+"')"
            status = self.controller.execute_sql(sql) 
            if not status:
                message = "Error inserting element in table, you need to review data"
                self.controller.show_warning(message, context_name='ui_message') 
                return
        
        # Add document to selected feature
        self.ed_add_to_feature("element", element_id)
                
        # Show message to user
        message = "Values has been updated"
        self.controller.show_info(message, context_name='ui_message')
        self.close_dialog()
    
    
    def ed_add_file(self):
        ''' Button 34. Add file '''
                        
        # Create the dialog and signals
        self.dlg = Add_file()
        utils_giswater.setDialog(self.dlg)
        self.dlg.btn_accept.pressed.connect(self.ed_add_file_accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)
        
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

        # Initialize variables                    
        table_arc = self.schema_name+'."'+self.table_arc+'"'
        table_node = self.schema_name+'."'+self.table_node+'"'
        table_connec = self.schema_name+'."'+self.table_connec+'"'
        table_gully = self.schema_name+'."'+self.table_gully+'"'
        
        # Get schema and table name of selected layer       
        (uri_schema, uri_table) = self.controller.get_layer_source(self.layer)   #@UnusedVariable
        if uri_table is None:
            self.controller.show_warning("Error getting table name from selected layer")
            return

        if table_arc in uri_table:  
            elem_type = "arc"
            field_id = "arc_id"
        elif table_node in uri_table:  
            elem_type = "node"
            field_id = "node_id"
        elif table_connec in uri_table:  
            elem_type = "connec"
            field_id = "connec_id"
        elif table_gully in uri_table:  
            elem_type = "gully"
            field_id = "gully_id"

        # Get selected features
        features = self.layer.selectedFeatures()
        for feature in features:
            elem_id = feature.attribute(field_id)
            sql = "INSERT INTO "+self.schema_name+"."+table_name+"_x_"+elem_type+" ("+field_id+", "+table_name+"_id) "
            sql+= " VALUES ('"+elem_id+"', '"+value_id+"')"
            self.dao.execute_sql(sql)   
                          
        
    def ed_add_file_accept(self): 
        ''' Insert or update document. Add document to selected feature '''  
        
        # Get values from dialog
        doc_id = utils_giswater.getWidgetText("doc_id") 
        doc_type = utils_giswater.getWidgetText("doc_type")   
        tagcat_id = utils_giswater.getWidgetText("tagcat_id")  
        observ = utils_giswater.getWidgetText("observ")
        path = utils_giswater.getWidgetText("path")
        
        # Check if this document already exists
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".doc WHERE id = '"+doc_id+"'" 
        row = self.dao.get_row(sql)
        if row:
            answer = self.controller.ask_question("Are you sure you want change the data?")
            if answer:
                sql = "UPDATE "+self.schema_name+".doc "
                sql+= " SET doc_type = '"+doc_type+"', tagcat_id= '"+tagcat_id+"',observ = '"+observ+"', path = '"+path+"'"
                sql+= " WHERE id = '"+doc_id+"'" 
                self.dao.execute_sql(sql) 
            else:
                self.close_dialog(self.dlg) 
        else:
            sql = "INSERT INTO "+self.schema_name+".doc (id, doc_type, path, observ, tagcat_id) "
            sql+= " VALUES ('"+doc_id+"', '"+doc_type+"', '"+path+"', '"+observ+"', '"+tagcat_id+"')"
            status = self.controller.execute_sql(sql) 
            if not status:
                message = "Error inserting element in table, you need to review data"
                self.controller.show_warning(message, context_name='ui_message')
                return
        
        # Add document to selected feature
        self.ed_add_to_feature("doc", doc_id)
           
        # Show message to user
        message = "Values has been updated"
        self.controller.show_info(message, context_name='ui_message')
        self.close_dialog()  
                
            
    def ed_giswater_jar(self):   
        ''' Button 36. Open giswater.jar with selected .gsw file '''
        
        # Check if java.exe file exists
        if not os.path.exists(self.java_exe):
            message = "Java Runtime executable file not found at: "+self.java_exe
            self.controller.show_warning(message, 10, context_name='ui_message')
            return  
        
        # Check if giswater.jar file exists
        if not os.path.exists(self.giswater_jar):
            message = "Giswater executable file not found at: "+self.giswater_jar
            self.controller.show_warning(message, 10, context_name='ui_message')
            return  
                  
        # Check if gsw file exists. If not giswater will opened anyway with the last .gsw file
        if not os.path.exists(self.gsw_file):
            message = "GSW file not found at: "+self.giswater_jar
            self.controller.show_info(message, 10, context_name='ui_message')
            self.gsw_file = "" 
            
        # Start program     
        aux = '"'+self.giswater_jar+'"'
        if self.gsw_file != "":
            aux+= ' "'+self.gsw_file+'"'
            program = [self.java_exe, "-jar", self.giswater_jar, self.gsw_file, "ed_giswater_jar"]
        else:
            program = [self.java_exe, "-jar", self.giswater_jar, "", "ed_giswater_jar"]
            
        self.controller.start_program(program)               
        
        # Show information message    
        message = "Executing... "+aux
        self.controller.show_info(message, context_name='ui_message')
                                            
        