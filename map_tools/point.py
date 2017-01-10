# -*- coding: utf-8 -*-
from qgis.core import QgsFeatureRequest, QgsExpression
from qgis.gui import QgsMapTool


class PointMapTool(QgsMapTool):

    def __init__(self, iface, settings, action, index_action, controller, srid):
        ''' Class constructor '''   
         
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.settings = settings
        self.index_action = index_action
        self.controller = controller
        self.srid = srid
        self.elem_type_type = self.settings.value('insert_values/'+str(index_action)+'_elem_type_type')
        self.schema_name = controller.schema_name  
        self.dao = controller.dao
        self.table_node = self.settings.value('db/table_node', 'v_edit_node')          
        QgsMapTool.__init__(self, self.canvas)
        self.setAction(action) 
            
     
    def insert_node(self, x, y):
        ''' Insert a new node in the selected coordinates '''
        
        if self.srid is None:
            self.srid = self.controller.plugin_settings_value('srid')  
        if self.schema_name is None:
            self.schema_name = self.controller.plugin_settings_value('schema_name')  
            
        if self.elem_type_type is not None: 
            
            # Get elem_type_id and epa_default from selected elem_type_type (get only first record)
            sql = "SELECT node_type.id, node_type.epa_default"
            sql+= " FROM "+self.schema_name+".node_type"
            wsoftware = self.search_project_type()
            if wsoftware == 'ws':  
                sql+= " INNER JOIN "+self.schema_name+".cat_node ON cat_node.nodetype_id = node_type.id"
            sql+= " WHERE node_type.type = '"+self.elem_type_type+"'"
            sql+= " ORDER BY node_type.id ASC"
            sql+= " LIMIT 1"
            row = self.dao.get_row(sql) 
             
            if row:
                last_id = -1
                elem_type_id = row[0]
                epa_default = row[1]
                # Insert element with selected coordinates
                the_geom = "ST_GeomFromText('POINT("+str(x)+" "+str(y)+")', "+str(self.srid)+")";
                sql = "INSERT INTO "+self.schema_name+"."+self.table_node+" (node_type, epa_type, the_geom)"
                sql+= " VALUES ('"+elem_type_id+"', '"+epa_default+"', "+the_geom+")" 
                sql+= " RETURNING node_id;";
                row = self.dao.get_row(sql)
                self.dao.commit()
                if row is None:
                    self.controller.show_warning_detail(self.tr("Error inserting point"), str(self.dao.last_error))
                    return False
                else:
                    last_id = row[0]
                return last_id 
            else:
                if wsoftware == 'ws':                
                    message = "Any record found in table 'cat_node' related with selected 'node_type.type'"
                    self.controller.show_info(message, context_name='ui_message')
                elif wsoftware == 'ud':                
                    message = "Any record found in table 'node_type' related with selected 'node_type.type'"
                    self.controller.show_info(message, context_name='ui_message')
    
    
    def search_project_type(self):
        ''' Search in table 'version' project type of current QGIS project '''
        
        sql = "SELECT wsoftware FROM "+self.schema_name+".version"
        row = self.dao.get_row(sql)
        if row:                    
            wsoftware = row['wsoftware']
            if wsoftware.lower() == 'epanet':
                return 'ws'                              
            elif wsoftware.lower() == 'epaswmm':
                return 'ud'             
            
    
    ''' QgsMapTools inherited event functions '''
   
    def canvasPressEvent(self, e):
        pass
        

    def canvasReleaseEvent(self, e):
           
        # Get clicked point and current layer
        layer = self.iface.activeLayer()
        self.point = self.toLayerCoordinates(layer, e.pos())
        
        # Insert new node into selected point. Open its feature form
        last_id = self.insert_node(self.point.x(), self.point.y())
        if last_id != -1:
            filter_expr = "node_id = '"+str(last_id)+"'"    
            expr = QgsExpression(filter_expr)
            f_request = QgsFeatureRequest(expr)
            f_iterator = layer.getFeatures(f_request)
            for feature in f_iterator: 
                self.iface.openFeatureForm(layer, feature)
                break
        else:   
            message = "Error inserting node"
            self.controller.show_warning(message, context_name='ui_message')   
        
        