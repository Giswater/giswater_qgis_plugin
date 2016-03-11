# -*- coding: utf-8 -*-
from qgis.gui import * # @UnusedWildImport

from ui.generic_dialog import GenericDialog
import utils


class PointMapTool(QgsMapTool):

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
        
        
    def setDao(self, dao):
        self.dao = dao
    
        
    def canvasPressEvent(self, e):
            
        pass
        

    def canvasReleaseEvent(self, e):
        
        # Create new dialog
        self.dlg = GenericDialog()
        
        #p = self.toMapCoordinates(e.pos())      
        #action = self.iface.actionPan()
        #action.trigger()
        
        self.dlg.lblInfo.setText("You have selected a '"+self.elem_type+"'")
        
        self.schema_name = self.dao.get_schema_name()
        
        # Define and execute query to populate first combo box: cboOptions
        sql = "SELECT id, man_table, epa_table FROM "+self.schema_name+".arc_type WHERE type = '"+self.elem_type+"' UNION "
        sql+= "SELECT id, man_table, epa_table FROM "+self.schema_name+".node_type WHERE type = '"+self.elem_type+"' ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils.fillComboBox(self.dlg.cboOptions, rows)
        
        # Define signals
        self.dlg.cboOptions.currentIndexChanged.connect(self.getCatalog)
        self.dlg.btnAccept.clicked.connect(self.do_test)
        
        # Show dialog
        self.dlg.show()                

    
    def getCatalog(self):
        """ Define and execute query to populate second combo box: cboOptions_2 """
        elem_type_id = self.dlg.cboOptions.currentText() 
        sql = "SELECT id FROM "+self.schema_name+".cat_arc WHERE arctype_id = '"+elem_type_id+"' UNION "
        sql+= "SELECT id FROM "+self.schema_name+".cat_node WHERE nodetype_id = '"+elem_type_id+"' ORDER BY id"   
        rows = self.dao.get_rows(sql)
        utils.fillComboBox(self.dlg.cboOptions_2, rows)     
        
        
    def do_test(self):
        pass
        
        