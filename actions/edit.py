"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.Qt import QDate
from PyQt4.QtGui import QDateEdit

import os
import sys
from datetime import datetime
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater

from ui.config_edit import ConfigEdit                   
from actions.manage_element import ManageElement        
from actions.manage_document import ManageDocument      
from parent import ParentAction


class Edit(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'edit' """
                
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.manage_document = ManageDocument(iface, settings, controller, plugin_dir)
        self.manage_element = ManageElement(iface, settings, controller, plugin_dir)
        

    def set_project_type(self, project_type):
        self.project_type = project_type


    def edit_add_feature(self, layername):
        """ Button 01, 02: Add 'node' or 'arc' """
                
        # Set active layer and triggers action Add Feature
        layer = self.controller.get_layer_by_layername(layername)
        if layer:
            self.iface.setActiveLayer(layer)
            layer.startEditing()
            self.iface.actionAddFeature().trigger()
        else:
            message = "Selected layer name not found"
            self.controller.show_warning(message, parameter=layername)


    def edit_add_element(self):
        """ Button 33: Add element """       
        self.manage_element.manage_element()


    def edit_add_file(self):
        """ Button 34: Add document """   
        self.manage_document.manage_document()


    def add_new_doc(self):
        """ Call function of button Add document """
        self.edit_add_file()
        
    
    def edit_document(self):
        """ Button 66: Edit document """          
        self.manage_document.edit_document()        
        
            
    def edit_element(self):
        """ Button 67: Edit element """          
        self.manage_element.edit_element()


    def edit_config_edit(self):
        """ Button 98: Open a dialog showing data from table 'config_param_user' """

        # Create the dialog and signals
        self.dlg = ConfigEdit()
        utils_giswater.setDialog(self.dlg)
        self.load_settings(self.dlg)
        self.dlg.btn_accept.pressed.connect(self.edit_config_edit_accept)
        self.dlg.btn_cancel.pressed.connect(partial(self.close_dialog, self.dlg))
        self.dlg.rejected.connect(partial(self.save_settings, self.dlg))
        
        # Set values from widgets of type QComboBox and dates
        sql = "SELECT DISTINCT(name) FROM " + self.schema_name + ".value_state ORDER BY name"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("state_vdefault", rows,False)
        sql = "SELECT DISTINCT(name) FROM " + self.schema_name + ".value_state_type ORDER BY name"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("statetype_vdefault", rows,False)
        sql = "SELECT id FROM " + self.schema_name + ".cat_work ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("workcat_vdefault", rows,False)
        sql = "SELECT id FROM " + self.schema_name + ".value_verified ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("verified_vdefault", rows,False)

        sql = 'SELECT value FROM ' + self.schema_name + '.config_param_user'
        sql += ' WHERE "cur_user" = current_user AND parameter = ' + "'builtdate_vdefault'"
        row = self.controller.get_row(sql)
        if row is not None:
            date_value = datetime.strptime(row[0], '%Y-%m-%d')
        else:
            date_value = QDate.currentDate()
        utils_giswater.setCalendarDate("builtdate_vdefault", date_value)

        sql = 'SELECT value FROM ' + self.schema_name + '.config_param_user'
        sql += ' WHERE "cur_user" = current_user AND parameter = ' + "'enddate_vdefault'"
        row = self.controller.get_row(sql)
        if row is not None:
            date_value = datetime.strptime(row[0], '%Y-%m-%d')
        else:
            date_value = QDate.currentDate()
        utils_giswater.setCalendarDate("enddate_vdefault", date_value)

        sql = "SELECT id FROM " + self.schema_name + ".cat_arc ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("arccat_vdefault", rows,False)
        sql = "SELECT id FROM " + self.schema_name + ".cat_node ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("nodecat_vdefault", rows,False)
        sql = "SELECT id FROM " + self.schema_name + ".cat_connec ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("connecat_vdefault", rows,False)
        sql = "SELECT id FROM " + self.schema_name + ".cat_element ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("elementcat_vdefault", rows,False)
        sql = "SELECT DISTINCT(name) FROM " + self.schema_name + ".exploitation ORDER BY name"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("exploitation_vdefault", rows,False)
        sql = "SELECT DISTINCT(name) FROM " + self.schema_name + ".ext_municipality ORDER BY name"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("municipality_vdefault", rows,False)
        sql = "SELECT DISTINCT(name) FROM " + self.schema_name + ".sector ORDER BY name"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("sector_vdefault", rows,False)
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".cat_pavement ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("pavementcat_vdefault", rows,False)
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".cat_soil ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("soilcat_vdefault", rows,False)
        #sql = "SELECT DISTINCT(name) FROM " + self.schema_name + ".om_visit_cat ORDER BY name"
        #rows = self.controller.get_rows(sql)postgres
        #utils_giswater.fillComboBox("visitcat_vdefault", rows)
        sql = ("SELECT name FROM " + self.schema_name + ".dma ORDER BY name")
        rows = self.controller.get_row(sql)
        utils_giswater.fillComboBox("dma_vdefault", rows,False)
        sql = ("SELECT value FROM " + self.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND parameter = 'virtual_layer_polygon'")
        rows = self.controller.get_row(sql)
        utils_giswater.setText(self.dlg.virtual_layer_polygon, rows,False)
        sql = ("SELECT value FROM " + self.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND parameter = 'virtual_layer_point'")        
        rows = self.controller.get_row(sql)
        utils_giswater.setText(self.dlg.virtual_layer_point, rows,False)
        sql = ("SELECT value FROM " + self.schema_name + ".config_param_user"
               " WHERE cur_user = current_user AND parameter = 'virtual_layer_line'")           
        rows = self.controller.get_row(sql)
        utils_giswater.setText(self.dlg.virtual_layer_line, rows,False)

        # WS
        sql = "SELECT id FROM " + self.schema_name + ".cat_presszone ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("presszone_vdefault", rows,False)
        self.populate_combo_ws(self.dlg.wtpcat_vdefault, "ETAP")
        self.populate_combo_ws("hydrantcat_vdefault", "HYDRANT")
        self.populate_combo_ws("filtercat_vdefault", "FILTER")
        self.populate_combo_ws("pumpcat_vdefault", "PUMP")
        self.populate_combo_ws("waterwellcat_vdefault", "WATERWELL")
        self.populate_combo_ws("metercat_vdefault", "METER")
        self.populate_combo_ws("tankcat_vdefault", "TANK")
        self.populate_combo_ws("manholecat_vdefault", "MANHOLE")
        self.populate_combo_ws("valvecat_vdefault", "VALVE")
        self.populate_combo_ws("registercat_vdefault", "REGISTER")
        self.populate_combo_ws("sourcecat_vdefault", "SOURCE")
        self.populate_combo_ws("junctioncat_vdefault", "JUNCTION")
        self.populate_combo_ws("expansiontankcat_vdefault", "EXPANSIONTANK")
        self.populate_combo_ws("netwjoincat_vdefault", "NETWJOIN")
        self.populate_combo_ws("reductioncat_vdefault", "REDUCTION")
        self.populate_combo_ws("netelementcat_vdefault", "NETELEMENT")
        self.populate_combo_ws("netsamplepointcat_vdefault", "NETSAMPLEPOINT")
        self.populate_combo_ws("flexunioncat_vdefault", "FLEXUNION")

        # UD
        sql = "SELECT id FROM " + self.schema_name + ".node_type ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("nodetype_vdefault", rows)
        sql = "SELECT id FROM " + self.schema_name + ".arc_type ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("arctype_vdefault", rows)
        sql = "SELECT id FROM " + self.schema_name + ".connec_type ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("connectype_vdefault", rows)

        # Set current values
        sql = ("SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
               " WHERE cur_user = current_user")
        rows = self.controller.get_rows(sql)
        for row in rows:
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
            utils_giswater.setChecked("chk_" + str(row[0]), True)

        # TODO: Parametrize it
        self.utils_sql("name","value_state", "id", "state_vdefault")
        self.utils_sql("name","exploitation", "expl_id", "exploitation_vdefault")
        self.utils_sql("name","ext_municipality", "muni_id", "municipality_vdefault")
        self.utils_sql("id","cat_soil", "id", "soilcat_vdefault")

        if self.project_type == 'ws':
            self.dlg.config_tab_vdefault.removeTab(2)
            #self.dlg.tab_config.removeTab(1)
        elif self.project_type == 'ud':
            self.dlg.config_tab_vdefault.removeTab(1)

        self.dlg.exec_()


    def edit_config_edit_accept(self):
        
        # TODO: Parametrize it. Loop through all widgets
        if utils_giswater.isChecked("chk_state_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.state_vdefault, "state_vdefault", "config_param_user")
        else:
            self.delete_row("state_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_statetype_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.statetype_vdefault, "statetype_vdefault","config_param_user")
        else:
            self.delete_row("statetype_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_workcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.workcat_vdefault, "workcat_vdefault", "config_param_user")
        else:
            self.delete_row("workcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_verified_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.verified_vdefault, "verified_vdefault", "config_param_user")
        else:
            self.delete_row("verified_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_builtdate_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.builtdate_vdefault, "builtdate_vdefault", "config_param_user")
        else:
            self.delete_row("builtdate_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_enddate_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.enddate_vdefault, "enddate_vdefault", "config_param_user")
        else:
            self.delete_row("enddate_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_arccat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.arccat_vdefault, "arccat_vdefault", "config_param_user")
        else:
            self.delete_row("arccat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_nodecat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.nodecat_vdefault, "nodecat_vdefault", "config_param_user")
        else:
            self.delete_row("nodecat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_connecat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.connecat_vdefault, "connecat_vdefault", "config_param_user")
        else:
            self.delete_row("connecat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_elementcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.elementcat_vdefault, "elementcat_vdefault", "config_param_user")
        else:
            self.delete_row("elementcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_exploitation_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.exploitation_vdefault, "exploitation_vdefault", "config_param_user")
        else:
            self.delete_row("exploitation_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_municipality_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.municipality_vdefault, "municipality_vdefault", "config_param_user")
        else:
            self.delete_row("municipality_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_sector_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.sector_vdefault, "sector_vdefault", "config_param_user")
        else:
            self.delete_row("sector_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_pavementcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.pavementcat_vdefault, "pavementcat_vdefault","config_param_user")
        else:
            self.delete_row("pavementcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_soilcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.soilcat_vdefault, "soilcat_vdefault","config_param_user")
        else:
            self.delete_row("soilcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_dma_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.dma_vdefault, "dma_vdefault","config_param_user")
        else:
            self.delete_row("dma_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_visitcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.visitcat_vdefault, "visitcat_vdefault", "config_param_user")
        else:
            self.delete_row("visitcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_virtual_layer_polygon"):
            self.insert_or_update_config_param_curuser(self.dlg.virtual_layer_polygon, "virtual_layer_polygon", "config_param_user")
        else:
            self.delete_row("virtual_layer_polygon", "config_param_user")
        if utils_giswater.isChecked("chk_virtual_layer_point"):
            self.insert_or_update_config_param_curuser(self.dlg.virtual_layer_point, "virtual_layer_point", "config_param_user")
        else:
            self.delete_row("virtual_layer_point", "config_param_user")
        if utils_giswater.isChecked("chk_virtual_layer_line"):
            self.insert_or_update_config_param_curuser(self.dlg.virtual_layer_line, "virtual_layer_line", "config_param_user")
        else:
            self.delete_row("virtual_layer_line", "config_param_user")

        if utils_giswater.isChecked("chk_dim_tooltip"):
            self.insert_or_update_config_param_curuser("chk_dim_tooltip", "dim_tooltip", "config_param_user")
        else:
            self.delete_row("dim_tooltip", "config_param_user")

        # WS

        if utils_giswater.isChecked("chk_presszone_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.presszone_vdefault, "presszone_vdefault","config_param_user")
        else:
            self.delete_row("presszone_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_wtpcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.wtpcat_vdefault, "wtpcat_vdefault","config_param_user")
        else:
            self.delete_row("wtpcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_netsamplepointcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.netsamplepointcat_vdefault,"netsamplepointcat_vdefault", "config_param_user")
        else:
                self.delete_row("netsamplepointcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_netelementcat_vdefault"):
                self.insert_or_update_config_param_curuser(self.dlg.netelementcat_vdefault, "netelementcat_vdefault","config_param_user")
        else:
                self.delete_row("netelementcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_flexunioncat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.flexunioncat_vdefault, "flexunioncat_vdefault","config_param_user")
        else:
            self.delete_row("flexunioncat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_tankcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.tankcat_vdefault, "tankcat_vdefault","config_param_user")
        else:
            self.delete_row("tankcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_hydrantcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.hydrantcat_vdefault, "hydrantcat_vdefault","config_param_user")
        else:
            self.delete_row("hydrantcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_junctioncat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.junctioncat_vdefault, "junctioncat_vdefault","config_param_user")
        else:
            self.delete_row("junctioncat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_pumpcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.pumpcat_vdefault, "pumpcat_vdefault","config_param_user")
        else:
            self.delete_row("pumpcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_reductioncat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.reductioncat_vdefault, "reductioncat_vdefault","config_param_user")
        else:
            self.delete_row("reductioncat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_valvecat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.valvecat_vdefault, "valvecat_vdefault","config_param_user")
        else:
            self.delete_row("valvecat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_manholecat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.manholecat_vdefault, "manholecat_vdefault","config_param_user")
        else:
            self.delete_row("manholecat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_metercat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.metercat_vdefault, "metercat_vdefault","config_param_user")
        else:
            self.delete_row("metercat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_sourcecat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.sourcecat_vdefault, "sourcecat_vdefault","config_param_user")
        else:
            self.delete_row("sourcecat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_waterwellcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.waterwellcat_vdefault, "waterwellcat_vdefault","config_param_user")
        else:
            self.delete_row("waterwellcat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_filtercat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.filtercat_vdefault, "filtercat_vdefault","config_param_user")
        else:
            self.delete_row("filtercat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_registercat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.registercat_vdefault, "registercat_vdefault","config_param_user")
        else:
            self.delete_row("registercat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_netwjoincat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.netwjoincat_vdefault, "netwjoincat_vdefault","config_param_user")
        else:
            self.delete_row("netwjoincat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_expansiontankcat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.expansiontankcat_vdefault,"expansiontankcat_vdefault", "config_param_user")
        else:
            self.delete_row("expansiontankcat_vdefault", "config_param_user")
        # UD
        if utils_giswater.isChecked("chk_nodetype_vdefault"):
            sql = "SELECT name FROM " + self.schema_name + ".value_state WHERE id::text = "
            sql += "(SELECT value FROM " + self.schema_name + ".config_param_user WHERE parameter = 'exploitation_vdefault')::text"
            row = self.controller.get_row(sql)
            if row:
                utils_giswater.setWidgetText("exploitation_vdefault", str(row[0]))
            self.insert_or_update_config_param_curuser(self.dlg.nodetype_vdefault, "nodetype_vdefault", "config_param_user")
        else:
            self.delete_row("nodetype_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_arctype_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.arctype_vdefault, "arctype_vdefault", "config_param_user")
        else:
            self.delete_row("arctype_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_connectype_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.connectype_vdefault, "connectype_vdefault", "config_param_user")
        else:
            self.delete_row("connectype_vdefault", "config_param_user")

        message = "Values has been updated"
        self.controller.show_info(message)
        self.close_dialog(self.dlg)


    def insert_or_update_config_param_curuser(self, widget, parameter, tablename):
        """ Insert or update value of @parameter in @tablename with current_user control """

        sql = ("SELECT parameter FROM " + self.schema_name + "." + tablename + ""
               " WHERE cur_user = current_user AND parameter = '" + str(parameter) + "'")
        exist_param = self.controller.get_row(sql)

        if type(widget) != QDateEdit:
            if utils_giswater.getWidgetText(widget) != "":
                if exist_param:
                    sql = "UPDATE " + self.schema_name + "." + tablename + " SET value = "
                    if widget.objectName() == 'state_vdefault':
                        sql += "(SELECT id FROM " + self.schema_name + ".value_state WHERE name = '" + str(utils_giswater.getWidgetText(widget)) + "')"
                        sql += " WHERE parameter = 'state_vdefault' "
                    elif widget.objectName() == 'exploitation_vdefault':
                        sql += "(SELECT expl_id FROM " + self.schema_name + ".exploitation WHERE name = '" + str(utils_giswater.getWidgetText(widget)) + "')"
                        sql += " WHERE parameter = 'exploitation_vdefault' "
                    elif widget.objectName() == 'municipality_vdefault':
                        sql += "(SELECT muni_id FROM " + self.schema_name + ".ext_municipality WHERE name = '" + str(utils_giswater.getWidgetText(widget)) + "')"
                        sql += " WHERE parameter = 'municipality_vdefault' "
                    elif widget.objectName() == 'visitcat_vdefault':
                        sql += "(SELECT id FROM " + self.schema_name + ".om_visit_cat WHERE name = '" + str(utils_giswater.getWidgetText(widget)) + "')"
                        sql += " WHERE parameter = 'visitcat_vdefault' "
                    else:
                        sql += "'" + str(utils_giswater.getWidgetText(widget)) + "' WHERE parameter = '" + parameter + "'"
                else:
                    sql = 'INSERT INTO ' + self.schema_name + '.' + tablename + '(parameter, value, cur_user)'
                    if widget.objectName() == 'state_vdefault':
                        sql += " VALUES ('" + parameter + "', (SELECT id FROM " + self.schema_name + ".value_state WHERE name ='" + str(utils_giswater.getWidgetText(widget)) + "'), current_user)"
                    elif widget.objectName() == 'exploitation_vdefault':
                        sql += " VALUES ('" + parameter + "', (SELECT expl_id FROM " + self.schema_name + ".exploitation WHERE name ='" + str(utils_giswater.getWidgetText(widget)) + "'), current_user)"
                    elif widget.objectName() == 'municipality_vdefault':
                        sql += " VALUES ('" + parameter + "', (SELECT muni_id FROM " + self.schema_name + ".ext_municipality WHERE name ='" + str(utils_giswater.getWidgetText(widget)) + "'), current_user)"
                    elif widget.objectName() == 'visitcat_vdefault':
                        sql += " VALUES ('" + parameter + "', (SELECT id FROM " + self.schema_name + ".om_visit_cat WHERE name ='" + str(utils_giswater.getWidgetText(widget)) + "'), current_user)"
                    else:
                        sql += " VALUES ('" + parameter + "', '" + str(utils_giswater.getWidgetText(widget)) + "', current_user)"
        else:
            if exist_param:
                sql = "UPDATE " + self.schema_name + "." + tablename + " SET value = "
                _date = widget.dateTime().toString('yyyy-MM-dd')
                sql += "'" + str(_date) + "' WHERE parameter = '" + parameter + "'"
            else:
                sql = 'INSERT INTO ' + self.schema_name + '.' + tablename + '(parameter, value, cur_user)'
                _date = widget.dateTime().toString('yyyy-MM-dd')
                sql += " VALUES ('" + parameter + "', '" + _date + "', current_user)"

        self.controller.execute_sql(sql)

    def delete_row(self,  parameter, tablename):
        """ Delete value of @parameter in @tablename with current_user control """        
        sql = ("DELETE FROM " + self.schema_name + "." + tablename + ""
               " WHERE cur_user = current_user AND parameter = '" + parameter + "'")
        self.controller.execute_sql(sql)


    def populate_combo(self, widget, table_name, field_name="id"):
        """ Executes query and fill combo box """

        sql = ("SELECT " + field_name + ""
               " FROM " + self.schema_name + "." + table_name + " ORDER BY " + field_name)
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(widget, rows,False)
        if len(rows) > 0:
            utils_giswater.setCurrentIndex(widget, 1)


    def populate_combo_ws(self, widget, node_type):
        
        sql = ("SELECT cat_node.id FROM " + self.schema_name + ".cat_node"
               " INNER JOIN " + self.schema_name + ".node_type ON cat_node.nodetype_id = node_type.id"
               " WHERE node_type.type = '" + type + "'")
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(widget, rows,False)


    def utils_sql(self,sel, table, atribute, value):
        
        sql = ("SELECT "+sel+" FROM " + self.schema_name + "." + table + " WHERE " + atribute + "::text = "
               "(SELECT value FROM " + self.schema_name + ".config_param_user WHERE parameter = '" + value + "')::text")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(value, str(row[0]))   
                     
            