# -*- coding: utf-8 -*-
from qgis.gui import *       # @UnusedWildImport
from qgis.core import QgsExpression, QgsFeatureRequest


class Mg():
   
    def __init__(self, iface, settings, controller):
        ''' Class to control Management toolbar actions '''    
        self.iface = iface
        self.settings = settings
        self.controller = controller
        self.schema_name = self.controller.schema_name           
        

    def mg_delete_node(self):
        ''' Button 17. User select one node. 
        Execute SQL function 'gw_fct_delete_node' 
        Show warning (if any) '''

        # Get selected features (from layer 'node')          
        layer = self.iface.activeLayer()  
        count = layer.selectedFeatureCount()     
        if count == 0:
            self.controller.show_message("You have to select at least one feature!")
            return 
        elif count > 1:  
            self.controller.show_message("More than one feature selected. Only the first one will be processed!")     
        
        features = layer.selectedFeatures()
        feature = features[0]
        node_id = feature.attribute('node_id')   
        
        # Execute SQL function and show result to the user
        function_name = "gw_fct_delete_node"
        sql = "SELECT "+self.schema_name+"."+function_name+"('"+str(node_id)+"');"  
        self.controller.get_row(sql)
                    
        # Refresh map canvas
        self.iface.mapCanvas().refresh()     
                
           
    def mg_connec_tool(self):
        ''' Button 20. User select connections from layer 'connec' 
        and executes function: 'gw_fct_connect_to_network' '''      

        # Get selected features (from layer 'connec')
        aux = "{"         
        layer = self.iface.activeLayer()  
        if layer.selectedFeatureCount() == 0:
            self.controller.show_message("You have to select at least one feature!")
            return 
        features = layer.selectedFeatures()
        for feature in features:
            connec_id = feature.attribute('connec_id') 
            aux+= str(connec_id)+", "
        connec_array = aux[:-2]+"}"
        
        # Execute function
        function_name = "gw_fct_connect_to_network"        
        sql = "SELECT "+self.schema_name+"."+function_name+"('"+connec_array+"');"  
        self.controller.execute_sql(sql) 
        
        # Refresh map canvas
        self.iface.mapCanvas().refresh() 
        
        
    def mg_flow_trace(self):
        ''' Button 26. User select one node or arc.
        SQL function fills 3 temporary tables with id's: node_id, arc_id and valve_id
        Returns and integer: error code
        Get these id's and select them in its corresponding layers '''
        
        # Get selected features and layer type: 'arc' or 'node'   
        layer = self.iface.activeLayer()          
        elem_type = layer.name().lower()
        count = layer.selectedFeatureCount()     
        if count == 0:
            self.controller.show_message("You have to select at least one feature!")
            return 
        elif count > 1:  
            self.controller.show_message("More than one feature selected. Only the first one will be processed!")   
         
        features = layer.selectedFeatures()
        feature = features[0]
        elem_id = feature.attribute(elem_type+'_id')   
        
        # Execute SQL function
        function_name = "gw_fct_mincut"
        sql = "SELECT "+self.schema_name+"."+function_name+"('"+str(elem_id)+"', '"+elem_type+"');"  
        result = self.controller.execute_sql(sql) 
        if result:
            # Get 'arc' and 'node' list and select them 
            self.mg_flow_trace_select_features(self.layer_arc, 'arc')                         
            self.mg_flow_trace_select_features(self.layer_node, 'node')     
            
        # Refresh map canvas
        self.iface.mapCanvas().refresh()                         
                
        
    def mg_flow_trace_select_features(self, layer, elem_type):
        
        sql = "SELECT * FROM "+self.schema_name+".anl_mincut_"+elem_type
        sql+= " ORDER BY "+elem_type+"_id"  
        # TODO: Peta
        rows = self.controller.get_rows(sql)
        self.controller.commit()
        
        # Build an expression to select them
        aux = "\""+elem_type+"_id\" IN ("
        for elem in rows:
            aux+= elem[0]+", "
        aux = aux[:-2]+")"
        
        # Get a featureIterator from this expression:
        expr = QgsExpression(aux)
        if expr.hasParserError():
            self.controller.show_message("Expression Error: "+str(expr.parserErrorString()))
            return        
        it = layer.getFeatures(QgsFeatureRequest(expr))
        
        # Build a list of feature id's from the previous result
        id_list = [i.id() for i in it]
        
        # Select features with these id's 
        layer.setSelectedFeatures(id_list)   
        
        
    def mg_flow_exit(self):
        ''' Button 27. Valve analytics ''' 
                
        # Execute SQL function
        function_name = "gw_fct_valveanalytics"
        sql = "SELECT "+self.schema_name+"."+function_name+"();"  
        result = self.dao.get_row(sql) 
        self.dao.commit()   

        # Manage SQL execution result
        if result is None:
            self.showWarning(self.controller.tr("Uncatched error. Open PotgreSQL log file to get more details"))   
            return   
        elif result[0] == 0:
            self.showInfo(self.controller.tr("Process completed"), 50)    
        else:
            self.showWarning(self.controller.tr("Undefined error"))    
            return       
        
                
                