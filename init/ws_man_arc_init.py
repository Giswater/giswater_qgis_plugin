'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-

from PyQt4.QtGui import QComboBox, QDateEdit, QPushButton, QTableView, QTabWidget, QLineEdit, QDialogButtonBox
from PyQt4.QtCore import Qt
from functools import partial

import utils_giswater
from parent_init import ParentDialog
from ui.add_sum import Add_sum          # @UnresolvedImport
from PyQt4.Qt import left


def formOpen(dialog, layer, feature):
    ''' Function called when a connec is identified in the map '''
    
    global feature_dialog
    utils_giswater.setDialog(dialog)
    # Create class to manage Feature Form interaction  
    feature_dialog = ManArcDialog(dialog, layer, feature)
    init_config()

    
def init_config():
     
    # Manage 'arccat_id'
    arccat_id = utils_giswater.getWidgetText("arccat_id") 
    utils_giswater.setSelectedItem("arccat_id", arccat_id)   

	# Manage 'state'
    state = utils_giswater.getWidgetText("state") 
    utils_giswater.setSelectedItem("state", state)   
    
    # Set button signals      
    #feature_dialog.dialog.findChild(QPushButton, "btn_accept").clicked.connect(feature_dialog.save)            
    #feature_dialog.dialog.findChild(QPushButton, "btn_close").clicked.connect(feature_dialog.close)  
    #feature_dialog.dialog.findChild(QDialogButtonBox, "ok").clicked.connect(feature_dialog.save)
     
class ManArcDialog(ParentDialog):   
    
    def __init__(self, dialog, layer, feature):
        ''' Constructor class '''
        super(ManArcDialog, self).__init__(dialog, layer, feature)      
        self.init_config_form()
        
        
    def init_config_form(self):
        ''' Custom form initial configuration '''
      
        table_element = "v_ui_element_x_arc" 
        table_document = "v_ui_doc_x_arc"   
        table_event_arc = "v_ui_om_visit_x_arc"

 
        
        self.table_varc = self.schema_name+'."v_edit_man_varc"'
        self.table_siphon = self.schema_name+'."v_edit_man_siphon"'
        self.table_conduit = self.schema_name+'."v_edit_man_conduit"'
        self.table_waccel = self.schema_name+'."v_edit_man_waccel"'
        

        # Define class variables
        self.field_id = "arc_id"        
        self.id = utils_giswater.getWidgetText(self.field_id, False)  
        self.filter = self.field_id+" = '"+str(self.id)+"'"                    
        self.connec_type = utils_giswater.getWidgetText("cat_arctype_id", False)        
        self.connecat_id = utils_giswater.getWidgetText("arccat_id", False) 
        # Get widget controls      
        self.tab_main = self.dialog.findChild(QTabWidget, "tab_main")  
        self.tbl_element = self.dialog.findChild(QTableView, "tbl_element")   
        self.tbl_document = self.dialog.findChild(QTableView, "tbl_document") 
        self.tbl_event = self.dialog.findChild(QTableView, "tbl_event_arc")  
        self.tbl_price_arc = self.dialog.findChild(QTableView, "tbl_price_arc")
        
        # Load data from related tables
        self.load_data()
        
        # Set layer in editing mode
        # self.layer.startEditing()
        
        # Manage tab visibility
        self.set_tabs_visibility(4)  
        
        # Fill the info table
        self.fill_table(self.tbl_element, self.schema_name+"."+table_element, self.filter)
        
        # Configuration of info table
        self.set_configuration(self.tbl_element, table_element)    
        
        # Fill the tab Document
        self.fill_tbl_document_man(self.tbl_document, self.schema_name+"."+table_document, self.filter)
        #self.tbl_document.doubleClicked.connect(self.open_selected_document)
        
        # Configuration of table Document
        self.set_configuration(self.tbl_document, table_document)
        
        # Fill tab event | arc
        self.fill_tbl_event(self.tbl_event, self.schema_name+"."+table_event_arc, self.filter)
        self.tbl_event.doubleClicked.connect(self.open_selected_document_event)

        # Configuration of table event | arc
        self.set_configuration(self.tbl_event, table_event_arc)
  
        # Fill tab costs 
        self.fill_costs()
        
        
        # Set signals          
        self.dialog.findChild(QPushButton, "btn_doc_delete").clicked.connect(partial(self.delete_records, self.tbl_document, table_document))            
        self.dialog.findChild(QPushButton, "delete_row_info").clicked.connect(partial(self.delete_records, self.tbl_element, table_element))       

   
    def fill_costs(self):
        ''' Fill tab costs '''
        
        # Get arc_id
        widget_arc = self.dialog.findChild(QLineEdit, "arc_id")          
        self.arc_id = widget_arc.text()
        
        self.length = self.dialog.findChild(QLineEdit, "length")
        self.budget = self.dialog.findChild(QLineEdit, "budget")
        
        arc_cost = self.dialog.findChild(QLineEdit, "arc_cost")
        cost_unit = self.dialog.findChild(QLineEdit, "cost_unit")
        arc_cost_2 = self.dialog.findChild(QLineEdit, "arc_cost_2")
        m2mlbottom = self.dialog.findChild(QLineEdit, "m2mlbottom")
        m2bottom_cost = self.dialog.findChild(QLineEdit, "m2bottom_cost")
        m3protec_cost = self.dialog.findChild(QLineEdit, "m3protec_cost")
        m3exc_cost = self.dialog.findChild(QLineEdit, "m3exc_cost")
        m3fill_cost = self.dialog.findChild(QLineEdit, "m3fill_cost")
        m3excess_cost = self.dialog.findChild(QLineEdit, "m3excess_cost")
        m2trenchl_cost = self.dialog.findChild(QLineEdit, "m2trenchl_cost")
        m2pavement_cost = self.dialog.findChild(QLineEdit, "m2pavement_cost")
        m2mlbase = self.dialog.findChild(QLineEdit, "m2mlbase")
        m3mlprotec = self.dialog.findChild(QLineEdit, "m3mlprotec")
        m3mlexc = self.dialog.findChild(QLineEdit, "m3mlexc")
        m3mlfill = self.dialog.findChild(QLineEdit, "m3mlfill")
        m3mlexcess = self.dialog.findChild(QLineEdit, "m3mlexcess")
        m2mltrenchl = self.dialog.findChild(QLineEdit, "m2mltrenchl_2")
        m2mlpavement = self.dialog.findChild(QLineEdit, "m2mlpavement")
        base_cost = self.dialog.findChild(QLineEdit, "base_cost")
        protec_cost = self.dialog.findChild(QLineEdit, "protec_cost")
        exc_cost = self.dialog.findChild(QLineEdit, "exc_cost")
        fill_cost = self.dialog.findChild(QLineEdit, "fill_cost")
        excess_cost = self.dialog.findChild(QLineEdit, "excess_cost")
        trenchl_cost = self.dialog.findChild(QLineEdit, "trenchl_cost")
        pav_cost = self.dialog.findChild(QLineEdit, "pav_cost")   
        cost = self.dialog.findChild(QLineEdit, "cost")     
        
        rec_y = self.dialog.findChild(QLineEdit, "rec_y")
        total_y = self.dialog.findChild(QLineEdit, "total_y") 
        
        m2mlpav = self.dialog.findChild(QLineEdit, "m2mlpav") 
        m2mlbottom_2 = self.dialog.findChild(QLineEdit, "m2mlbottom_2")    
        
        
        z1 = self.dialog.findChild(QLineEdit, "z1")
        z2 = self.dialog.findChild(QLineEdit, "z2")
        bulk = self.dialog.findChild(QLineEdit, "bulk")
        
        b = self.dialog.findChild(QLineEdit, "b")
        b_2 = self.dialog.findChild(QLineEdit, "b_2")
        y_param = self.dialog.findChild(QLineEdit, "y_param")
        m3mlfill_2 = self.dialog.findChild(QLineEdit, "m3mlfill_2")
        m3mlexc_2 = self.dialog.findChild(QLineEdit, "m3mlexc_2")
        m3mlexcess_2 = self.dialog.findChild(QLineEdit, "m3mlexcess_2")
        m2mltrenchl_2 = self.dialog.findChild(QLineEdit, "m2mltrenchl_2")
        m2trenchl_cost_2 = self.dialog.findChild(QLineEdit, "m2trenchl_cost_2")
        calculed_y = self.dialog.findChild(QLineEdit, "calculed_y")  
        thickness = self.dialog.findChild(QLineEdit, "thickness")
        m2mltrenchl = self.dialog.findChild(QLineEdit, "m2mltrenchl")
        width = self.dialog.findChild(QLineEdit, "width")
        
        dext = self.dialog.findChild(QLineEdit, "dext")
        area = self.dialog.findChild(QLineEdit, "area")
        dext.setText('None')
        area.setText('None')
        
        cost_unit.setText('None')
        arc_cost.setText('None')
        m2mlbottom.setText('None')    
        arc_cost_2.setText('None') 
        m2bottom_cost.setText('None')  
        m3protec_cost.setText('None') 
        m3exc_cost.setText('None') 
        m3excess_cost.setText('None')  
        m3fill_cost.setText('None') 
        m3mlexcess.setText('None') 
        m2trenchl_cost.setText('None')  
        m2mltrenchl_2.setText('None') 
        m3mlprotec.setText('None')  
        m3mlexc.setText('None') 
        m3mlfill.setText('None') 
        base_cost.setText('None') 
        protec_cost.setText('None') 
        exc_cost.setText('None')  
        fill_cost.setText('None') 
        excess_cost.setText('None') 
        trenchl_cost.setText('None') 
        pav_cost.setText('None')  
        cost.setText('None')  
        m2pavement_cost.setText('None') 
        m2mlpavement.setText('None') 
        
        rec_y.setText('None') 
        total_y.setText('None') 
        m2mlpav.setText('None') 
        m2mlbottom_2.setText('None') 



        z1.setText('None') 
        z2.setText('None') 
        bulk.setText('None') 
        #geom1.setText('None') 
        b.setText('None') 
        b_2.setText('None') 
        y_param.setText('None') 
        m3mlfill_2.setText('None') 
        m3mlexc_2.setText('None') 
        m3mlexcess_2.setText('None') 
        m2mltrenchl_2.setText('None') 
        thickness.setText('None') 
        #m2trenchl_cost_2.setText('None') 
        #calculed_y.setText('None') 
        m2mltrenchl.setText('None') 
        width.setText('None') 
        
        # Get values from database        
        sql = "SELECT *"
        sql+= " FROM "+self.schema_name+".v_plan_cost_arc" 
        sql+= " WHERE arc_id = '"+self.arc_id+"'"    
        row = self.dao.get_row(sql)
        if row is None:
            return
        
        cost_unit.setText(str(row['cost_unit']))
        arc_cost.setText(str(row['arc_cost']))
        m2mlbottom.setText(str(row['m2mlbottom']))    
        arc_cost_2.setText(str(row['arc_cost'])) 
        m2bottom_cost.setText(str(row['m2bottom_cost'])) 
        m3protec_cost.setText(str(row['m3protec_cost'])) 
        m3exc_cost.setText(str(row['m3exc_cost'])) 
        m3excess_cost.setText(str(row['m3excess_cost'])) 
        m3fill_cost.setText(str(row['m3fill_cost'])) 
        m3mlexcess.setText(str(row['m3mlexcess'])) 
        m2trenchl_cost.setText(str(row['m2trenchl_cost'])) 
        m2mltrenchl_2.setText(str(row['m2mltrenchl'])) 
        m3mlprotec.setText(str(row['m3mlprotec'])) 
        m3mlexc.setText(str(row['m3mlexc'])) 
        m3mlfill.setText(str(row['m3mlfill'])) 
        base_cost.setText(str(row['base_cost'])) 
        protec_cost.setText(str(row['protec_cost'])) 
        exc_cost.setText(str(row['exc_cost'])) 
        fill_cost.setText(str(row['fill_cost'])) 
        excess_cost.setText(str(row['excess_cost'])) 
        trenchl_cost.setText(str(row['trenchl_cost'])) 
        pav_cost.setText(str(row['pav_cost']))   
        cost.setText(str(row['cost']))  
        m2pavement_cost.setText(str(row['m2pav_cost']))  
        m2mlpavement.setText(str(row['m2mlpav']))  
        
        rec_y.setText(str(row['rec_y']))
        total_y.setText(str(row['total_y']))
        m2mlpav.setText(str(row['m2mlpav']))
        m2mlbottom_2.setText(str(row['m2mlbottom']))
        
        dext.setText(str(row['dext']))
        area.setText(str(row['area']))

        z1.setText(str(row['z1']))
        z2.setText(str(row['z2']))
        bulk.setText(str(row['bulk']))
        #geom1.setText(str(row['geom1']))
        b.setText(str(row['b']))
        b_2.setText(str(row['b']))
        y_param.setText(str(row['y_param']))
        m3mlfill_2.setText(str(row['m3mlfill']))
        m3mlexc_2.setText(str(row['m3mlexc']))
        m3mlexcess_2.setText(str(row['m3mlexcess']))
        m2mltrenchl_2.setText(str(row['m2mltrenchl']))
        thickness.setText(str(row['thickness']))
        #m2trenchl_cost_2.setText(str(row['m2trenchl_cost']))
        #calculed_y.setText(str(row['calculed_y'])) 
        m2mltrenchl.setText(str(row['m2mltrenchl']))
        width.setText(str(row['width']))


        # Get values from database        
        sql = "SELECT length,budget"
        sql+= " FROM "+self.schema_name+".v_plan_arc" 
        sql+= " WHERE arc_id = '"+self.arc_id+"'"    
        row = self.dao.get_row(sql)
        
        self.length.setText(str(row['length'])) 
        self.budget.setText(str(row['budget'])) 
        
        
        # Get arccat_id and soilcat_id from v_plan_cost_arc
        arccat_id = None
        sql = "SELECT arccat_id FROM "+self.schema_name+".v_plan_cost_arc WHERE arc_id = '"+self.arc_id+"'" 
        row = self.dao.get_row(sql)
        arccat_id = row[0]

        # Fill QLineEdit 
        element = None
        sql = "SELECT descript FROM "+self.schema_name+".v_price_x_arc WHERE arc_id = '"+self.arc_id+"' AND identif = 'element'" 
        row = self.dao.get_row(sql)
        if row != None:
            element = row[0]

        m2bottom = None
        sql = "SELECT descript FROM "+self.schema_name+".v_price_x_arc WHERE arc_id = '"+self.arc_id+"' AND identif = 'm2bottom'" 
        row = self.dao.get_row(sql)
        if row != None:
            m2bottom = row[0]
        
        m3protec = None
        sql = "SELECT descript FROM "+self.schema_name+".v_price_x_arc WHERE arc_id = '"+self.arc_id+"' AND identif = 'm3protec'" 
        row = self.dao.get_row(sql)
        if row != None:
            m3protec = row[0]
        
        arc_element = self.dialog.findChild(QLineEdit, "arc_element")
        arc_bottom = self.dialog.findChild(QLineEdit, "arc_bottom")
        arc_protection = self.dialog.findChild(QLineEdit, "arc_protection")
        
        arc_element.setText('None')
        arc_bottom.setText('None')
        arc_protection.setText('None')
        
        arc_element.setText(element)
        arc_element.setAlignment(Qt.AlignJustify)
        arc_bottom.setText(m2bottom)
        arc_bottom.setAlignment(Qt.AlignJustify)
        arc_protection.setText(m3protec)
        arc_protection.setAlignment(Qt.AlignJustify)
        
        
        # Fill QLineEdit -> Soilcat
        m3exc = None
        sql = "SELECT descript FROM "+self.schema_name+".v_price_x_arc WHERE arc_id = '"+self.arc_id+"' AND identif= 'm3exc'" 
        row = self.dao.get_row(sql)
        if row != None:
            m3exc = row[0]
        
        m3fill = None
        sql = "SELECT descript FROM "+self.schema_name+".v_price_x_arc WHERE arc_id = '"+self.arc_id+"' AND identif= 'm3fill'" 
        row = self.dao.get_row(sql)
        if row != None:
            m3fill = row[0]
        
        m3excess = None
        sql = "SELECT descript FROM "+self.schema_name+".v_price_x_arc WHERE arc_id = '"+self.arc_id+"' AND identif= 'm3excess'" 
        row = self.dao.get_row(sql)
        if row != None:
            m3excess = row[0]
        
        m2trenchl = None
        sql = "SELECT descript FROM "+self.schema_name+".v_price_x_arc WHERE arc_id = '"+self.arc_id+"' AND identif= 'm2trenchl'" 
        row = self.dao.get_row(sql)
        if row != None:
            m2trenchl = row[0]
        
        soil_excavation = self.dialog.findChild(QLineEdit, "soil_excavation")
        soil_filling = self.dialog.findChild(QLineEdit, "soil_filling")
        soil_excess = self.dialog.findChild(QLineEdit, "soil_excess")
        soil_trenchlining = self.dialog.findChild(QLineEdit, "soil_trenchlining")
        
        soil_excavation.setText('None')
        soil_filling.setText('None')
        soil_excess.setText('None')
        soil_trenchlining.setText('None')
        
        soil_excavation.setText(m3exc)
        soil_excavation.setAlignment(Qt.AlignJustify)
        soil_filling.setText(m3fill)
        soil_filling.setAlignment(Qt.AlignJustify)
        soil_excess.setText(m3excess)
        soil_excess.setAlignment(Qt.AlignJustify)
        soil_trenchlining.setText(m2trenchl)
        soil_trenchlining.setAlignment(Qt.AlignJustify)
        