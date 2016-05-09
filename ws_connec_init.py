# -*- coding: utf-8 -*-
from PyQt4.QtCore import *   # @UnusedWildImport
from PyQt4.QtGui import *    # @UnusedWildImport
from qgis.utils import iface

import utils_giswater
from ws_parent_init import ParentDialog


def formOpen(dialog, layer, feature):
    ''' Function called when a connec is identified in the map '''
    
    global feature_dialog
    utils_giswater.setDialog(dialog)
    # Create class to manage Feature Form interaction  
    feature_dialog = ConnecDialog(iface, dialog, layer, feature)
    init_config()

    
def init_config():
     
    feature_dialog.dialog.findChild(QComboBox, "connecat_id").setVisible(False)         
    connecat_id = utils_giswater.getWidgetText("connecat_id", False)
    
    # TODO: Define slots
    
    feature_dialog.dialog.findChild(QPushButton, "btn_accept").clicked.connect(feature_dialog.save)            
    feature_dialog.dialog.findChild(QPushButton, "btn_close").clicked.connect(feature_dialog.close)        


     
class ConnecDialog(ParentDialog):   
    
    def __init__(self, iface, dialog, layer, feature):
        ''' Constructor class '''
        super(ConnecDialog, self).__init__(iface, dialog, layer, feature)      
        self.init_config_connec()
        
        
    def init_config_connec(self):
        ''' Custom form initial configuration for 'Connec' '''
        
        # Define class variables
        self.field_id = "connec_id"
        self.id = utils_giswater.getWidgetText(self.field_id, False)     
        
        # Get widget controls    
        
        # Manage i18n
        self.translate_form('ws_connec')        
        
        # Load data from related tables
        self.load_data()
        
        # Set layer in editing mode
        self.layer.startEditing()
               
   
    def load_tab_analysis(self):
        ''' Load data from tab 'Analysis' '''
        pass
    

    def save_tab_analysis(self):
        ''' Save tab from tab 'Analysis' '''   
        pass
                        
                        
        
    ''' TODO: Slot functions '''  
         

