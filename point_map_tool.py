# -*- coding: utf-8 -*-
from qgis.gui import * # @UnusedWildImport
from qgis.core import (QgsFeatureRequest, QgsExpression)
from PyQt4.QtCore import *   # @UnusedWildImport
from PyQt4.QtGui import *    # @UnusedWildImport


class PointMapTool(QgsMapTool):

    def __init__(self, iface, settings, action, index_action, controller):
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.settings = settings
        self.index_action = index_action
        self.srid = self.settings.value('status/srid')
        self.elem_type = self.settings.value('actions/'+str(index_action)+'_elem_type')
        self.dao = controller.getDao()   
        self.schema_name = self.dao.get_schema_name()            
        self.view_name = "v_edit_node"            
        QgsMapTool.__init__(self, self.canvas)
        self.setAction(action)
           
        
    def canvasPressEvent(self, e):
        pass
        

    def canvasReleaseEvent(self, e):
           
        # Get clicked point and current layer               
        self.point = self.toMapCoordinates(e.pos())             
        layer = self.iface.activeLayer()     
        
        # Insert new node into the point
        status = self.insertNode(int(self.point.x()), int(self.point.y()))  
        if status:
            # Get node_id of that new node. Open its feature form
            last_id = self.getLastId(layer.name(), "node_id")  
            if last_id != -1:
                filter_expr = "node_id = "+str(last_id)     
                expr = QgsExpression(filter_expr)
                f_request = QgsFeatureRequest(expr)
                f_iterator = layer.getFeatures(f_request)
                for feature in f_iterator: 
                    self.openFeatureForm(layer, feature)
                    break
            else:
                print "Error getting last node inserted"
        else:
            print "Error inserting node"            
            
     
    def insertNode(self, x, y):
        """ Insert a new node in the selected coordinates """
        if self.elem_type is not None:        
            the_geom = "ST_GeomFromText('POINT("+str(x)+" "+str(y)+")', "+self.srid+")";
            sql = "INSERT INTO "+self.schema_name+"."+self.view_name+" (epa_type, the_geom) VALUES ('"+self.elem_type+"', "+the_geom+");";
            status = self.dao.execute_sql(sql)   
            return status  
        else:
            print "self.elem_type is None"
      

    def getLastId(self, view_name, field_name):
        # Get last feature inserted       
        last_id = -1 
        sql = "SELECT max(cast("+field_name+" as int)) FROM "+self.schema_name+"."+view_name;
        row = self.dao.get_row(sql)  
        if row:
            if row[0] is not None:
                last_id = int(row[0])  
        return last_id
    
        
    def openFeatureForm(self, layer, feature):
        """ Open feature form """      
        self.iface.openFeatureForm(layer, feature)
        
        