# -*- coding: utf-8 -*-
from PyQt4.QtGui import QCompleter, QLineEdit, QStringListModel

import os.path
import subprocess

import utils_giswater
from ..ui.add_element import Add_element    # @UnresolvedImport
from ..ui.add_file import Add_file          # @UnresolvedImport


class Ed():
   
    def __init__(self, iface, settings, controller, plugin_dir):
        ''' Class to control Management toolbar actions '''    
        self.iface = iface
        self.settings = settings
        self.controller = controller
        self.plugin_dir= plugin_dir       
        self.dao = self.controller.getDao()             
        self.schema_name = self.controller.schema_name    
        
        # Get files to execute giswater jar
        self.java_exe = self.settings.value('files/java_exe')          
        self.giswater_jar = self.settings.value('files/giswater_jar')          
        self.gsw_file = self.settings.value('files/gsw_file')  
        
        # Get tables or views specified in 'db' config section         
        self.table_arc = self.settings.value('db/table_arc', 'v_edit_arc')        
        self.table_node = self.settings.value('db/table_node', 'v_edit_node')   
        self.table_connec = self.settings.value('db/table_connec', 'v_edit_connec')   
        self.table_version = self.settings.value('db/table_version', 'version')                               
    
                  
    def close_dialog(self, dlg=None): 
        ''' Close dialog '''
        if dlg is None:
            dlg = self.dlg   
        dlg.close()    
                
                
            
    def ed_search_plus(self):   
        ''' Button 32. Open dialog to select street and portal number ''' 
        if self.search_plus is not None:
            self.search_plus.dlg.setVisible(True) 
            
                
    def ed_add_element(self):
        ''' Button 33. Add element '''
          
        # Create the dialog and signals
        self.dlg = Add_element()
        utils_giswater.setDialog(self.dlg)
        self.dlg.btn_accept.pressed.connect(self.ed_add_element_accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)
        
        # Check if at least one node is checked          
        layer = self.iface.activeLayer()  
        count = layer.selectedFeatureCount()   
        
        if count == 0:
            self.controller.show_info("You have to select at least one feature!")
            return 
        elif count > 1:  
            self.controller.show_info("More than one feature selected. Only the first one will be processed!")
        
        # Fill  comboBox elementcat_id
        sql = "SELECT DISTINCT(elementcat_id) FROM "+self.schema_name+".element ORDER BY elementcat_id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("elementcat_id", rows) 
        
        # Fill  comboBox state
        sql = "SELECT DISTINCT(state) FROM "+self.schema_name+".element ORDER BY state"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("state", rows)
        
        # Fill comboBox location_type 
        sql = "SELECT DISTINCT(location_type) FROM "+self.schema_name+".element ORDER BY location_type"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("location_type", rows)
        
        # Fill comboBox workcat_id 
        sql = "SELECT DISTINCT(workcat_id) FROM "+self.schema_name+".element ORDER BY workcat_id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("workcat_id", rows)
        
        # Fill comboBox buildercat_id
        sql = "SELECT DISTINCT(buildercat_id) FROM "+self.schema_name+".element ORDER BY buildercat_id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("buildercat_id", rows)
        
        # Fill comboBox ownercat_id 
        sql = "SELECT DISTINCT(ownercat_id) FROM "+self.schema_name+".element ORDER BY ownercat_id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("ownercat_id", rows)
        
        # Fill comboBox verified
        sql = "SELECT DISTINCT(verified) FROM "+self.schema_name+".element ORDER BY verified"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("verified", rows)
        
        # Open the dialog
        self.dlg.exec_()    
        
        
    def ed_add_element_accept(self):
           
        # Get values from comboboxes-elementcat_id
        self.elementcat_id = utils_giswater.getWidgetText("elementcat_id")  
        
        # Get state from combobox
        self.state = utils_giswater.getWidgetText("state")   
               
        # Get element_id entered by user
        self.element_id = utils_giswater.getWidgetText("element_id")
        self.annotation = utils_giswater.getWidgetText("annotation")
        self.observ = utils_giswater.getWidgetText("observ")
        self.comment = utils_giswater.getWidgetText("comment")
        self.location_type = utils_giswater.getWidgetText("location_type")
        self.workcat_id = utils_giswater.getWidgetText("workcat_id")
        self.buildercat_id = utils_giswater.getWidgetText("buildercat_id")
        #self.builtdate = utils_giswater.getWidgetText("builtdate")
        self.ownercat_id = utils_giswater.getWidgetText("ownercat_id")
        #self.enddate = utils_giswater.getWidgetText("enddate")
        self.rotation = utils_giswater.getWidgetText("rotation")
        self.link = utils_giswater.getWidgetText("link")
        self.verified = utils_giswater.getWidgetText("verified")
     
        # Execute data to database Elements 
        sql = "INSERT INTO "+self.schema_name+".element (element_id, elementcat_id, state, location_type"
        sql+= ", workcat_id, buildercat_id, ownercat_id, rotation, comment, annotation, observ, link, verified) "
        sql+= " VALUES ('"+self.element_id+"', '"+self.elementcat_id+"', '"+self.state+"', '"+self.location_type+"', '"
        sql+= self.workcat_id+"', '"+self.buildercat_id+"', '"+self.ownercat_id+"', '"+self.rotation+"', '"+self.comment+"', '"
        sql+= self.annotation+"','"+self.observ+"','"+self.link+"','"+self.verified+"')"
        self.dao.execute_sql(sql) 
        
        # Get layers
        layers = self.iface.legendInterface().layers()
        if len(layers) == 0:
            return
         
        # Initialize variables                    
        self.layer_arc = None
        table_arc = '"'+self.schema_name+'"."'+self.table_arc+'"'
        table_node = '"'+self.schema_name+'"."'+self.table_node+'"'
        table_connec = '"'+self.schema_name+'"."'+self.table_connec+'"'
   
        # Iterate over all layers to get the ones set in config file        
        for cur_layer in layers:     
            uri = cur_layer.dataProvider().dataSourceUri().lower()   
            pos_ini = uri.find('table=')
            pos_fi = uri.find('" ')  
            uri_table = uri 

            if pos_ini <> -1 and pos_fi <> -1:
                uri_table = uri[pos_ini+6:pos_fi+1]    
                
                # Table 'arc'                       
                if table_arc == uri_table:  
                    self.layer_arc = cur_layer
                    self.count_arc = self.layer_arc.selectedFeatureCount()  
                    # Get all selected features-arcs
                    features_arcs = self.layer_arc.selectedFeatures()
                    i = 0
                    while (i < self.count_arc):
                     
                        feature = features_arcs[i]
                        # Get arc_id from current arc
                        self.arc_id = feature.attribute('arc_id')
                        print(self.arc_id)
                        # Convert i to str ,for exporting index to database
                        #j=str(i)
                        # Execute data of all arcs to database Elements 
                        #sql = "INSERT INTO "+self.schema_name+".element (element_id,elementcat_id,state,location_type,workcat_id,buildercat_id,ownercat_id,rotation,comment,annotation,observ,link) "
                        #sql+= " VALUES ('"+self.element_id+"''"+j+"','"+self.elementcat_id+"','"+self.state+"','"+self.location_type+"','"+self.workcat_id+"','"+self.buildercat_id+"','"+self.ownercat_id+"','"+self.rotation+"','"+self.comment+"','"+self.annotation+"','"+self.observ+"','"+self.link+"')"
                        #print("for data base element")
                        #print (sql)
                        #self.dao.execute_sql(sql)                        
                        # Execute id(automaticaly),element_id and arc_id to element_x_arc
                        ''' data base for arc element_x_arc doesn't exist 
                        sql = "INSERT INTO "+self.schema_name+".element_x_arc (arc_id,element_id) "
                        sql+= " VALUES ('"+self.arc_id+"','"+self.element_id+"')"
                        '''
                        i=i+1
                      
                # Table 'node'   
                if table_node == uri_table:  
                    self.layer_node = cur_layer
                    self.count_node = self.layer_node.selectedFeatureCount()  
                    # Get all selected features-arcs
                    features_nodes = self.layer_node.selectedFeatures()
                    i = 0
                    while (i < self.count_node):
                          
                        # Get node_id from current node
                        feature_node = features_nodes[i]
                        self.node_id = feature_node.attribute('node_id')

                        # Execute id(automaticaly),element_id and node_id to element_x_node
                        sql = "INSERT INTO "+self.schema_name+".element_x_node (node_id, element_id) "
                        sql+= " VALUES ('"+self.node_id+"', '"+self.element_id+"')"
                        self.dao.execute_sql(sql)   
                        i+=1
                 
                # Table 'connec'       
                if table_connec == uri_table:  
                    self.layer_connec = cur_layer
                    self.count_connec = self.layer_connec.selectedFeatureCount()  
                    # Get all selected features-arcs
                    features_connecs = self.layer_connec.selectedFeatures()
                    i = 0
                    while (i < self.count_connec):

                        # Get connec_id from current connec
                        feature_connec = features_connecs[i]
                        self.connec_id = feature_connec.attribute('connec_id')

                        # Execute id(automaticaly),element_id and node_id to element_x_node
                        sql = "INSERT INTO "+self.schema_name+".element_x_connec (connec_id, element_id) "
                        sql+= " VALUES ('"+self.connec_id+"', '"+self.element_id+"')"
                        self.dao.execute_sql(sql)   
                        i+=1
                
        # Show message to user
        self.controller.show_info("Values has been updated")
        self.close_dialog()
    
    
    def ed_add_file(self):
        ''' Button 34. Add file '''
                        
        # Create the dialog and signals
        self.dlg = Add_file()
        utils_giswater.setDialog(self.dlg)
        self.dlg.btn_accept.pressed.connect(self.ed_add_file_accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)
        
        # Check if at least one node is checked          
        layer = self.iface.activeLayer()  
        count = layer.selectedFeatureCount()           
        if count == 0:
            self.controller.show_info("You have to select at least one feature!")
            return 
        elif count > 1:  
            self.controller.show_info("More than one feature selected. Only the first one will be processed!") 
        
        # Fill comboBox elementcat_id
        sql = "SELECT DISTINCT(doc_type) FROM "+self.schema_name+".doc ORDER BY doc_type"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("doc_type", rows) 
        
        # Fill comboBox tagcat_id
        sql = "SELECT DISTINCT(tagcat_id) FROM "+self.schema_name+".doc ORDER BY tagcat_id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("tagcat_id", rows) 
        
        # Adding auto-completion to a QLineEdit
        self.edit = self.dlg.findChild(QLineEdit,"doc_id")
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
        
        # Set signal to reach sellected value from QCompleter
        self.completer.activated.connect(self.ed_add_file_autocomplete)
        
        # Open the dialog
        self.dlg.exec_()
        
        
    def ed_add_file_autocomplete(self):    

        # Qcompleter event- get selected value
        self.dlg.doc_id.setCompleter(self.completer)
        self.doc_id = utils_giswater.getWidgetText("doc_id") 
        
        
    def ed_add_file_accept(self):   
        
        # Get values from comboboxes
        self.doc_id = utils_giswater.getWidgetText("doc_id") 
        self.doc_type = utils_giswater.getWidgetText("doc_type")   
        self.tagcat_id = utils_giswater.getWidgetText("tagcat_id")  
        self.observ = utils_giswater.getWidgetText("observ")
        self.link = utils_giswater.getWidgetText("link")
        
        # Execute data to database DOC 
        sql = "INSERT INTO "+self.schema_name+".doc (id, doc_type, path, observ, tagcat_id) "
        sql+= " VALUES ('"+self.doc_id+"', '"+self.doc_type+"', '"+self.link+"', '"+self.observ+"', '"+self.tagcat_id+"')"
        self.dao.execute_sql(sql)
        
        # Get layers
        layers = self.iface.legendInterface().layers()
        if len(layers) == 0:
            return
         
        # Initialize variables                    
        self.layer_arc = None
        table_arc = '"'+self.schema_name+'"."'+self.table_arc+'"'
        table_node = '"'+self.schema_name+'"."'+self.table_node+'"'
        table_connec = '"'+self.schema_name+'"."'+self.table_connec+'"'
   
        # Iterate over all layers to get the ones set in config file        
        for cur_layer in layers:     
            uri = cur_layer.dataProvider().dataSourceUri().lower()   
            pos_ini = uri.find('table=')
            pos_fi = uri.find('" ')  
            uri_table = uri 

            if pos_ini <> -1 and pos_fi <> -1:
                uri_table = uri[pos_ini+6:pos_fi+1]   
                
                # Table 'arc                        
                if table_arc == uri_table:  
                    self.layer_arc = cur_layer
                    self.count_arc = self.layer_arc.selectedFeatureCount()  
                    # Get all selected features-arcs
                    features_arcs = self.layer_arc.selectedFeatures()
                    i=0
                    while (i<self.count_arc):
                     
                        # Get arc_id from current arc
                        feature = features_arcs[i]
                        self.arc_id = feature.attribute('arc_id')
                        self.doc_id = utils_giswater.getWidgetText("doc_id")
                                              
                        # Execute id(automaticaly),element_id and arc_id to element_x_arc
                        sql = "INSERT INTO "+self.schema_name+".doc_x_arc (arc_id, doc_id) "
                        sql+= " VALUES ('"+self.arc_id+"', '"+self.doc_id+"')"
                        i+=1
                        self.dao.execute_sql(sql) 
             
            if pos_ini <> -1 and pos_fi <> -1:
                uri_table = uri[pos_ini+6:pos_fi+1] 
                
                # Table 'node'                          
                if table_node == uri_table:  
                    self.layer_node = cur_layer
                    self.count_node = self.layer_node.selectedFeatureCount()  
                    # Get all selected features-arcs
                    features_nodes = self.layer_node.selectedFeatures()
                    i = 0
                    while (i<self.count_node):

                        # Get arc_id from current arc
                        feature = features_nodes[i]
                        self.node_id = feature.attribute('node_id')
                        self.doc_id = utils_giswater.getWidgetText("doc_id")
                                              
                        # Execute id(automaticaly),element_id and arc_id to element_x_arc
                        sql = "INSERT INTO "+self.schema_name+".doc_x_node (node_id,doc_id) "
                        sql+= " VALUES ('"+self.node_id+"','"+self.doc_id+"')"
                        i+=1
                        self.dao.execute_sql(sql) 
                        
            if pos_ini <> -1 and pos_fi <> -1:
                uri_table = uri[pos_ini+6:pos_fi+1]
                
                # Table 'connec'                              
                if table_connec == uri_table:  
                    self.layer_connec = cur_layer
                    self.count_connec = self.layer_connec.selectedFeatureCount()  
                    # Get all selected features-arcs
                    features_connecs = self.layer_connec.selectedFeatures()
                    i = 0
                    while (i<self.count_connec):
                     
                        # Get arc_id from current arc
                        feature = features_connecs[i]
                        self.connec_id = feature.attribute('connec_id')
                        self.doc_id = utils_giswater.getWidgetText("doc_id")

                        # Execute id(automaticaly),element_id and arc_id to element_x_arc
                        sql = "INSERT INTO "+self.schema_name+".doc_x_connec (connec_id, doc_id) "
                        sql+= " VALUES ('"+self.connec_id+"', '"+self.doc_id+"')"
                        self.dao.execute_sql(sql)  
                        i+=1
        
        # Show message to user
        self.controller.show_info("Values has been updated")
        self.close_dialog()         
        
            
    def ed_giswater_jar(self):   
        ''' Button 36. Open giswater.jar with selected .gsw file '''
        
        # Check if java.exe file exists
        if not os.path.exists(self.java_exe):
            self.controller.show_warning("Java Runtime executable file not found at: "+self.java_exe), 10
            return  
        
        # Check if giswater.jar file exists
        if not os.path.exists(self.giswater_jar):
            self.controller.show_warning("Giswater executable file not found at: "+self.giswater_jar), 10
            return  
                  
        # Check if gsw file exists. If not giswater will opened anyway with the last .gsw file
        if not os.path.exists(self.gsw_file):
            self.controller.show_info("GSW file not found at: "+self.gsw_file), 10
            self.gsw_file = ""    
        
        # Execute process
        aux = '"'+self.giswater_jar+'"'
        if self.gsw_file != "":
            aux+= ' "'+self.gsw_file+'"'
            subprocess.Popen([self.java_exe, "-jar", self.giswater_jar, self.gsw_file, "ed_giswater_jar"])
        else:
            subprocess.Popen([self.java_exe, "-jar", self.giswater_jar, "", "ed_giswater_jar"])
        
        # Show information message    
        self.controller.show_info("Executing... "+aux)
                                            
        