# -*- coding: utf-8 -*-
import os
import subprocess
import platform

from qgis.gui import * # @UnusedWildImport
from qgis.core import * # @UnusedWildImport
from PyQt4 import QtCore, QtGui

from ui.generic_dialog import GenericDialog


class GenericMapTool(QgsMapTool):

    def __init__(self, iface, action, settings, index_action):
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.settings = settings
        self.index_action = index_action
        QgsMapTool.__init__(self, self.canvas)
        self.setAction(action)
        self.loadInfoPlusPointSettings()
    
    
    def loadInfoPlusPointSettings(self):
        ''' Load plugin settings
        '''      
        pass

        
    def canvasPressEvent(self, e):
            
        p = self.toMapCoordinates(e.pos())      
        
        # Create new dialog
        self.dlg = GenericDialog()
        
        # Get current action
        print str(self.index_action)
        if self.index_action == '10':
            elem_type = 'JUNCTION'
        else:
            elem_type = 'RESERVOIR'
            #action = self.iface.actionPan()
            #action.trigger()
        
        self.dlg.lblInfo.setText("You have selected a '"+elem_type+"'")
        
        # Define query to fill first combo box: cboOptions
        sql = "SELECT id, man_table, epa_table FROM arc_type WHERE type = '"+elem_type+"' UNION "
        sql+= "SELECT id, man_table, epa_table FROM node_type WHERE type = '"+elem_type+"' ORDER BY id"
        
        # Execute query and save results in memory
        
        # Define query to fill second combo box: cboOptions
        #elem_type_id = self.dlg.cboOptions.getSelectedItem() 
#         sql = "SELECT id FROM cat_arc WHERE arctype_id = '"+elem_type_id+"' UNION"
#         sql+= "SELECT id FROM cat_node WHERE nodetype_id = '"+elem_type_id+"' ORDER BY id"      
                
        #self.dlg.zoom_PButton.setVisible(self.zoomButtonVisible)
        #self.dlg.form_PButton.setVisible(self.formButtonVisible)
        
        # add listener to selected layer/record
        #self.dlg.cboOptions.clicked.connect(self.)
        self.dlg.btnAccept.clicked.connect(self.do_test)
        #self.dlg.zoom_PButton.clicked.connect(self.doZoomCenterAction)        
        #self.dlg.form_PButton.clicked.connect(self.doShowFeatureForm)
        
        # Show dialog
        self.dlg.show()

        
    def do_test(self):
        ''' show Feature Form
        ''' 
        #self.iface.openFeatureForm(layer, feature, False)
        print "ok"
        
        