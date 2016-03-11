# -*- coding: utf-8 -*-
from qgis.gui import * # @UnusedWildImport
from qgis.core import * # @UnusedWildImport
from PyQt4.Qt import * # @UnusedWildImport

from ui.generic_dialog import GenericDialog
import utils


class GenericMapTool(QgsMapTool):

    def __init__(self, iface, settings, action, index_action, dao):
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.settings = settings
        self.index_action = index_action
        self.dao = dao        
        self.srid = self.settings.value('status/srid')
        self.elem_type = self.settings.value('actions/'+str(index_action)+'_elem_type')
        self.schema_name = self.dao.get_schema_name()        
        QgsMapTool.__init__(self, self.canvas)
        self.setAction(action)

        self.rubberBand = QgsRubberBand(self.canvas, QGis.Line)
        mFillColor = QColor(254, 178, 76, 63);
        self.rubberBand.setColor(mFillColor)
        self.rubberBand.setWidth(1)
        self.reset()        
        

    def reset(self):
        self.startPoint = self.endPoint = None
        self.isEmittingPoint = False
        self.rubberBand.reset(QGis.Polygon)
    
        
    def canvasPressEvent(self, e):

        # Get map coordinates
        self.coords = self.toMapCoordinates(e.pos())  
        #action = self.iface.actionPan()
        #action.trigger()
        
        self.startPoint = self.toMapCoordinates(e.pos())
        self.endPoint = self.startPoint
        self.isEmittingPoint = True
        self.showRect(self.startPoint, self.endPoint)
                       
        
    def canvasReleaseEvent(self, e):
        
        # TODO: This check only applies if we're drawing an arc 
        self.endPoint = self.toMapCoordinates(e.pos())         
        if self.startPoint.x() == self.endPoint.x() or self.startPoint.y() == self.endPoint.y():
            print "You have to draw a line"
            return     
             
        self.isEmittingPoint = False
        self.rubberBand.hide()
        
        # Create new dialog
        self.dlg = GenericDialog()
                
        self.dlg.lblInfo.setText("You have selected a '"+self.elem_type+"'")
               
        # Define and execute query to populate first combo box: cboOptions
        sql = "SELECT id, man_table, epa_table FROM "+self.schema_name+".arc_type WHERE type = '"+self.elem_type+"' UNION "
        sql+= "SELECT id, man_table, epa_table FROM "+self.schema_name+".node_type WHERE type = '"+self.elem_type+"' ORDER BY id"
        self.rows_elem_type = self.dao.get_rows(sql)
        #print sql
        utils.fillComboBox(self.dlg.cboOptions, self.rows_elem_type)
        
        # Define signals
        self.dlg.cboOptions.currentIndexChanged.connect(self.getCatalog)
        self.dlg.btnAccept.clicked.connect(self.createElem)
                
        # Show dialog
        self.dlg.show()        
            
    
    def canvasMoveEvent(self, e):
        
        if not self.isEmittingPoint:
            return
        self.endPoint = self.toMapCoordinates(e.pos())
        self.showLine(self.startPoint, self.endPoint)        
        
        
    def showLine(self, startPoint, endPoint):
        
        self.rubberBand.reset(QGis.Line)
        if startPoint.x() == endPoint.x() or startPoint.y() == endPoint.y():
            return
        point1 = QgsPoint(startPoint.x(), startPoint.y())
        point2 = QgsPoint(endPoint.x(), endPoint.y())
        self.rubberBand.addPoint(point1, False)
        self.rubberBand.addPoint(point2, True)
        #print str(endPoint.x()) + " " + str(endPoint.y())
        self.rubberBand.show()        
        
        
    def showRect(self, startPoint, endPoint):
        
        self.rubberBand.reset(QGis.Polygon)
        if startPoint.x() == endPoint.x() or startPoint.y() == endPoint.y():
            return
        point1 = QgsPoint(startPoint.x(), startPoint.y())
        point2 = QgsPoint(startPoint.x(), endPoint.y())
        point3 = QgsPoint(endPoint.x(), endPoint.y())
        point4 = QgsPoint(endPoint.x(), startPoint.y())
    
        self.rubberBand.addPoint(point1, False)
        self.rubberBand.addPoint(point2, False)
        self.rubberBand.addPoint(point3, False)
        self.rubberBand.addPoint(point4, True)    # true to update canvas
        #print str(endPoint.x()) + " " + str(endPoint.y())
        self.rubberBand.show()        

    
    def getCatalog(self):
        """ Define and execute query to populate second combo box: cboOptions_2 """
        self.elem_type_id = self.dlg.cboOptions.currentText() 
        sql = "SELECT id FROM "+self.schema_name+".cat_arc WHERE arctype_id = '"+self.elem_type_id+"' UNION "
        sql+= "SELECT id FROM "+self.schema_name+".cat_node WHERE nodetype_id = '"+self.elem_type_id+"' ORDER BY id"  
        #print sql 
        rows = self.dao.get_rows(sql)
        utils.fillComboBox(self.dlg.cboOptions_2, rows)     
        
        
    def createElem(self):
        """ Create new element (arc or node) """
        self.category = self.dlg.cboOptions_2.currentText() 
        
        # TODO: Get if is 'node' or 'arc'
        # TODO: Get default values for fields 'state' and 'verified'
        
        # Get selected sector 
        sql = "SELECT * FROM "+self.schema_name+".sector_selection"
        row = self.dao.get_row(sql) 
        sector_id = row[0]
        
        # Get next 'node_id'
        sql = "SELECT MAX(node_id) FROM "+self.schema_name+".node"  
        row = self.dao.get_row(sql) 
        node_id = int(row[0])
                 
        # Insert into 'node' or 'arc'    
        coord_x = int(self.coords[0])
        coord_y = int(self.coords[1])
        the_geom = "ST_GeomFromText('POINT("+str(coord_x)+" "+str(coord_y)+")', "+str(self.srid)+")"            
        sql = "INSERT INTO "+self.schema_name+".node (node_id, nodecat_id, epa_type, sector_id, state, verified, the_geom) VALUES ("
        sql+= "'"+str(node_id+1)+"', '"+self.category+"', '"+self.elem_type_id+"', '"+sector_id+"', 'PLANIFIED', 'TO REVIEW', "+the_geom+");" 
        print sql 
        self.dao.execute_sql(sql)
        self.dao.commit()
        
        # TODO: Insert into 'man_table' and 'epa_table'
        for row in self.rows_elem_type:
            if self.elem_type_id in row[0]:
                man_table = row[1]
                epa_table = row[2]
                break
            
        sql = "INSERT INTO "+man_table+"x"
        
        
        