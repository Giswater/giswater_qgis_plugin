# -*- coding: utf-8 -*-
from qgis.gui import *       # @UnusedWildImport
from PyQt4.QtCore import *   # @UnusedWildImport
from PyQt4.QtGui import *    # @UnusedWildImport


class MoveNode(QgsMapTool):

    def __init__(self, iface, settings, action, index_action, controller):
        ''' Class constructor '''        
        
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.settings = settings        
        self.index_action = index_action
        self.srid = self.settings.value('status/srid')        
        self.elem_type = self.settings.value('actions/'+str(index_action)+'_elem_type')
        self.show_help = bool(int(self.settings.value('status/show_help', 1)))  
        self.controller = controller
        self.dao = controller.getDao()   
        self.schema_name = self.dao.get_schema_name() 
        
        # Call superclass constructor and set current action                
        QgsMapTool.__init__(self, self.canvas)
        self.setAction(action) 
            
     
    def move_node(self, node_id, x, y):
        ''' Move selected node to the current point '''
        
        sql = "SET search_path = sample_ws, public;"
        self.dao.execute_sql(sql)     

        # Update node geometry
        the_geom = "ST_GeomFromText('POINT("+str(x)+" "+str(y)+")', "+self.srid+")";
        sql = "UPDATE "+self.schema_name+".node SET the_geom = "+the_geom
        sql+= " WHERE node_id = '"+node_id+"'"
        status = self.dao.execute_sql(sql) 
        if status:
            # Execute function
            sql = "SELECT "+self.schema_name+".gw_fct_node2arc('"+node_id+"')"
            status = self.dao.execute_sql(sql)   
            return status  


    def showInfo(self, text, duration = 3):
        self.iface.messageBar().pushMessage("", text, QgsMessageBar.INFO, duration)    
        
    
    ''' QgsMapTool inherited event functions '''    
       
    def activate(self):
        ''' Show help message when action is activated '''
        if self.show_help:
            self.showInfo(self.controller.tr("Click a point on the map to move selected node"))
            

    def canvasReleaseEvent(self, e):
        
        # Get clicked point, current layer and number of selected features             
        self.point = self.toMapCoordinates(e.pos())             
        layer = self.iface.activeLayer()  
        count = layer.selectedFeatureCount()     
        if count == 0:
            self.showInfo(self.controller.tr("You have to select at least one feature!"))
            return 
        elif count > 1:  
            self.showInfo(self.controller.tr("More than one feature selected. Only the first one will be processed!"))   
                    
        # Get selected features (nodes)           
        features = layer.selectedFeatures()
        feature = features[0]
        node_id = feature.attribute('node_id') 
        
        # Move selected node to the current point
        status = self.move_node(node_id, int(self.point.x()), int(self.point.y()))  
        if not status:
            self.showWarning(self.controller.tr("move_node_error"))          
        
        
    def canvasPressEvent(self, e):
        pass    
            
        