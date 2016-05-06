# -*- coding: utf-8 -*-
from qgis.gui import * # @UnusedWildImport
from qgis.core import (QgsFeatureRequest, QgsExpression, QGis, QgsPoint)
from PyQt4.QtCore import *   # @UnusedWildImport
from PyQt4.QtGui import *    # @UnusedWildImport
from PyQt4.Qt import * # @UnusedWildImport


class LineMapTool(QgsMapTool):

    def __init__(self, iface, settings, action, index_action, controller):
        ''' Class constructor '''
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.settings = settings
        self.index_action = index_action
        self.srid = self.settings.value('status/srid')
        self.elem_type = self.settings.value('actions/'+str(index_action)+'_elem_type')
        self.dao = controller.getDao()   
        self.schema_name = self.dao.get_schema_name() 
        self.view_name = "v_edit_arc"                    
        QgsMapTool.__init__(self, self.canvas)
        self.setAction(action)

        self.rubberBand = QgsRubberBand(self.canvas, QGis.Line)
        mFillColor = QColor(254, 178, 76, 63);
        self.rubberBand.setColor(mFillColor)
        self.rubberBand.setWidth(2)
        self.reset()        
        

    def reset(self):
        self.start_point = self.end_point = None
        self.isEmittingPoint = False
        self.rubberBand.reset(QGis.Polygon)
        
        
    def show_line(self, start_point, end_point):
        
        self.rubberBand.reset(QGis.Line)
        if start_point.x() == end_point.x() or start_point.y() == end_point.y():
            return
        point1 = QgsPoint(start_point.x(), start_point.y())
        point2 = QgsPoint(end_point.x(), end_point.y())
        self.rubberBand.addPoint(point1, False)
        self.rubberBand.addPoint(point2, True)
        self.rubberBand.show()        
               
        
    def insert_arc(self, start_point, end_point):
        ''' Insert a new arc in the selected coordinates '''
        if self.elem_type is not None:        
            the_geom = "ST_GeomFromText('LINESTRING("+str(start_point.x())+" "+str(start_point.y())+", "+str(end_point.x())+" "+str(end_point.y())+")', "+self.srid+")";
            sql = "INSERT INTO "+self.schema_name+"."+self.view_name+" (epa_type, the_geom) VALUES ('"+self.elem_type+"', "+the_geom+");";
            status = self.dao.execute_sql(sql)   
            return status  
                    

    def get_last_id(self, view_name, field_name):
        ''' Get id of the last feature inserted '''    
        last_id = -1 
        sql = "SELECT max(cast("+field_name+" as int)) FROM "+self.schema_name+"."+view_name;
        row = self.dao.get_row(sql)  
        if row:
            if row[0] is not None:
                last_id = int(row[0])  
        return last_id
    
    
    
    ''' QgsMapTools inherited event functions '''
        
    def canvasPressEvent(self, e):

        # Get map coordinates of starting point        
        self.start_point = self.toMapCoordinates(e.pos())
        self.end_point = self.start_point
        self.isEmittingPoint = True
        self.show_line(self.start_point, self.end_point)
                       
    
    def canvasMoveEvent(self, e):
        
        if not self.isEmittingPoint:
            return
        self.end_point = self.toMapCoordinates(e.pos())
        self.show_line(self.start_point, self.end_point)        
        
        
    def canvasReleaseEvent(self, e):
        
        # Ccheck if we have drawn a line or not 
        self.end_point = self.toMapCoordinates(e.pos())         
        if self.start_point.x() == self.end_point.x() or self.start_point.y() == self.end_point.y():
            print "You have to draw a line"
            return     
        
        layer = self.iface.activeLayer()     
        self.isEmittingPoint = False
        self.rubberBand.hide()
 
        # Insert new arc 
        status = self.insert_arc(self.start_point, self.end_point)  
        if status:
            # Get node_id of that new node. Open its feature form
            last_id = self.get_last_id(layer.name(), "arc_id")  
            if last_id != -1:
                filter_expr = "arc_id = "+str(last_id)     
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
    
        
        