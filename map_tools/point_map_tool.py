# -*- coding: utf-8 -*-
from qgis.gui import * # @UnusedWildImport
from qgis.core import (QgsFeatureRequest, QgsExpression)
from PyQt4.QtCore import *   # @UnusedWildImport
from PyQt4.QtGui import *    # @UnusedWildImport


class PointMapTool(QgsMapTool):

    def __init__(self, iface, settings, action, index_action, controller):
        ''' Class constructor '''    
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.settings = settings
        self.index_action = index_action
        self.srid = self.settings.value('status/srid')
        self.node_type = self.settings.value('insert_values/'+str(index_action)+'_node_type')
        self.epa_type = self.settings.value('insert_values/'+str(index_action)+'_epa_type')
        self.dao = controller.getDao()   
        self.schema_name = self.dao.get_schema_name()   
        self.table_node = self.settings.value('db/table_node', 'v_edit_node')          
        QgsMapTool.__init__(self, self.canvas)
        self.setAction(action) 
            
     
    def insert_node(self, x, y):
        ''' Insert a new node in the selected coordinates '''
        if self.node_type is not None:        
            the_geom = "ST_GeomFromText('POINT("+str(x)+" "+str(y)+")', "+self.srid+")";
            sql = "INSERT INTO "+self.schema_name+"."+self.table_node+" (node_type, epa_type, the_geom)"
            sql+= " VALUES ('"+self.node_type+"', '"+self.epa_type+"', "+the_geom+");";
            status = self.dao.execute_sql(sql)   
            return status  
      

    def get_last_id(self, view_name, field_name):
        ''' Get last feature inserted '''      
        last_id = -1 
        sql = "SELECT max(cast("+field_name+" as int)) FROM "+self.schema_name+"."+view_name;
        row = self.dao.get_row(sql)  
        if row:
            if row[0] is not None:
                last_id = int(row[0])  
        return last_id
    
    
    
    ''' QgsMapTools inherited event functions '''
   
    def canvasPressEvent(self, e):
        pass
        

    def canvasReleaseEvent(self, e):
           
        # Get clicked point and current layer               
        self.point = self.toMapCoordinates(e.pos())             
        layer = self.iface.activeLayer()     
        
        # Insert new node into the point
        status = self.insert_node(int(self.point.x()), int(self.point.y()))  
        if status:
            # Get node_id of that new node. Open its feature form
            last_id = self.get_last_id(layer.name(), "node_id")  
            if last_id != -1:
                filter_expr = "node_id = "+str(last_id)     
                expr = QgsExpression(filter_expr)
                f_request = QgsFeatureRequest(expr)
                f_iterator = layer.getFeatures(f_request)
                for feature in f_iterator: 
                    self.iface.openFeatureForm(layer, feature)
                    break
            else:
                print "Error getting last node inserted"
        else:
            print "Error inserting node"          
        
        