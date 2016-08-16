# -*- coding: utf-8 -*-
from qgis.gui import * # @UnusedWildImport
from qgis.core import (QgsFeatureRequest, QgsExpression)
from PyQt4.QtCore import *   # @UnusedWildImport
from PyQt4.QtGui import *    # @UnusedWildImport


class PointMapTool(QgsMapTool):

    def __init__(self, iface, settings, action, index_action, controller, srid):
        ''' Class constructor '''    
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.settings = settings
        self.index_action = index_action
        self.srid = srid
        self.elem_type_type = self.settings.value('insert_values/'+str(index_action)+'_elem_type_type')
        self.dao = controller.getDao()   
        self.schema_name = controller.get_schema_name()   
        self.table_node = self.settings.value('db/table_node', 'v_edit_node')          
        QgsMapTool.__init__(self, self.canvas)
        self.setAction(action) 
            
     
    def insert_node(self, x, y):
        ''' Insert a new node in the selected coordinates '''
        
        if self.srid is None:
            self.srid = self.settings.value('db/srid')  
        if self.schema_name is None:
            self.schema_name = self.settings.value('db/schema_name')  
            
        if self.elem_type is not None:   
            # Get elem_type_id and epa_default from selected elem_type_type (get only first record)
            sql = "SELECT node_type.id, node_type.epa_default"
            sql+= " FROM "+self.schema_name+".node_type"
            sql+= " INNER JOIN "+self.schema_name+".cat_node ON cat_node.nodetype_id = node_type.id"
            sql+= " WHERE node_type.type = '"+self.elem_type_type+"'"
            sql+= " ORDER BY node_type.id ASC"
            sql+= " LIMIT 1"
            row = self.dao.get_row(sql)  
            if row:
                elem_type_id = row[0]
                epa_default = row[1]
                # Insert element with selected coordinates
                the_geom = "ST_GeomFromText('POINT("+str(x)+" "+str(y)+")', "+str(self.srid)+")";
                sql = "INSERT INTO "+self.schema_name+"."+self.table_node+" (node_type, epa_type, the_geom)"
                sql+= " VALUES ('"+elem_type_id+"', '"+epa_default+"', "+the_geom+")" 
                sql+= " RETURNING node_id;";
                row = self.dao.get_row(sql)
                self.dao.commit()
                last_id = -1
                if row:
                    last_id = row[0]
                return last_id 
    
    
    ''' QgsMapTools inherited event functions '''
   
    def canvasPressEvent(self, e):
        pass
        

    def canvasReleaseEvent(self, e):
           
        # Get clicked point and current layer               
        self.point = self.toMapCoordinates(e.pos())             
        layer = self.iface.activeLayer()     
        
        # Insert new node into selected point. Open its feature form
        last_id = self.insert_node(int(self.point.x()), int(self.point.y()))  
        if last_id != -1:
            filter_expr = "node_id = "+str(last_id)    
            expr = QgsExpression(filter_expr)
            f_request = QgsFeatureRequest(expr)
            f_iterator = layer.getFeatures(f_request)
            for feature in f_iterator: 
                self.iface.openFeatureForm(layer, feature)
                break
        else:
            print "Error inserting node"          
        
        