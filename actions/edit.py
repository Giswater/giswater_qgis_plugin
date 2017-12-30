"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.Qt import QDate
from PyQt4.QtGui import QDateEdit
from PyQt4.QtGui import QCheckBox

import os
import sys
from datetime import datetime
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater

from ui.config_edit import ConfigEdit                   # @UnresolvedImport
from ui.topology_tools import TopologyTools             # @UnresolvedImport

from actions.manage_element import ManageElement        # @UnresolvedImport
from actions.manage_document import ManageDocument      # @UnresolvedImport
from actions.manage_workcat_end import ManageWorkcatEnd
from parent import ParentAction




class Edit(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'edit' """
                
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.manage_document = ManageDocument(iface, settings, controller, plugin_dir)
        self.manage_element = ManageElement(iface, settings, controller, plugin_dir)
        self.manage_workcat_end = ManageWorkcatEnd(iface, settings, controller, plugin_dir)

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
        
        
    def edit_arc_topo_repair(self):
        """ Button 19: Topology repair """
        
        # Create dialog to check wich topology functions we want to execute
        self.dlg = TopologyTools()
        if self.project_type == 'ws':
            self.dlg.tab_review.removeTab(1)
            
        # Set signals
        self.dlg.btn_accept.clicked.connect(self.edit_arc_topo_repair_accept)
        self.dlg.btn_cancel.clicked.connect(self.close_dialog)

        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'topology_tools')
        self.dlg.exec_()


    def edit_arc_topo_repair_accept(self):
        """ Button 19: Executes functions that are selected """

        # Review/Utils
        if self.dlg.check_node_orphan.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_node_orphan();"
            self.controller.execute_sql(sql)
        if self.dlg.check_node_duplicated.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_node_duplicated();"
            self.controller.execute_sql(sql)
        if self.dlg.check_topology_coherence.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_node_topological_consistency();"
            self.controller.execute_sql(sql)
        if self.dlg.check_arc_same_start_end.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_arc_same_startend();"
            self.controller.execute_sql(sql)
        if self.dlg.check_arcs_without_nodes_start_end.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_arc_no_startend_node();"
            self.controller.execute_sql(sql)
        if self.dlg.check_connec_duplicated.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_connec_duplicated();"
            self.controller.execute_sql(sql)

        # Review/UD
        if self.dlg.check_node_sink.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_node_sink();"
            self.controller.execute_sql(sql)
        if self.dlg.check_node_flow_regulator.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_node_flowregulator();"
            self.controller.execute_sql(sql)
        if self.dlg.check_node_exit_upper_node_entry.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_node_exit_upper_intro();"
            self.controller.execute_sql(sql)
        if self.dlg.check_arc_intersection_without_node.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_arc_intersection();"
            self.controller.execute_sql(sql)
        if self.dlg.check_inverted_arcs.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_anl_arc_inverted();"
            self.controller.execute_sql(sql)

        # Builder
        if self.dlg.check_create_nodes_from_arcs.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_built_nodefromarc();"
            self.controller.execute_sql(sql)

        # Repair
        if self.dlg.check_arc_searchnodes.isChecked():
            sql = "SELECT "+self.schema_name+".gw_fct_repair_arc_searchnodes();"
            self.controller.execute_sql(sql)

        # Close the dialog
        self.close_dialog()

        # Refresh map canvas
        self.refresh_map_canvas()


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

    def edit_end_feature(self):
        """ Button 68: Edit end feature """
        self.manage_workcat_end.manage_workcat_end()


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
        utils_giswater.fillComboBox("state_vdefault", rows)
        sql = "SELECT id FROM " + self.schema_name + ".cat_work ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("workcat_vdefault", rows)
        sql = "SELECT id FROM " + self.schema_name + ".value_verified ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("verified_vdefault", rows)

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
        utils_giswater.fillComboBox("arccat_vdefault", rows)
        sql = "SELECT id FROM " + self.schema_name + ".cat_node ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("nodecat_vdefault", rows)
        sql = "SELECT id FROM " + self.schema_name + ".cat_connec ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("connecat_vdefault", rows)
        sql = "SELECT id FROM " + self.schema_name + ".cat_element ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("elementcat_vdefault", rows)  
        sql = "SELECT DISTINCT(name) FROM " + self.schema_name + ".exploitation ORDER BY name"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("exploitation_vdefault", rows)              
        sql = "SELECT DISTINCT(name) FROM " + self.schema_name + ".ext_municipality ORDER BY name"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("municipality_vdefault", rows)
        sql = "SELECT DISTINCT(name) FROM " + self.schema_name + ".om_visit_cat ORDER BY name"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("visitcat_vdefault", rows)
        sql = 'SELECT value FROM ' + self.schema_name + '.config_param_user'
        sql += ' WHERE "cur_user" = current_user AND parameter = ' + "'virtual_layer_polygon'"
        row = self.controller.get_row(sql)
        utils_giswater.setText(self.dlg.virtual_layer_polygon, row)
        sql = 'SELECT value FROM ' + self.schema_name + '.config_param_user'
        sql += ' WHERE "cur_user" = current_user AND parameter = ' + "'virtual_layer_point'"
        row = self.controller.get_row(sql)
        utils_giswater.setText(self.dlg.virtual_layer_point, row)
        sql = 'SELECT value FROM ' + self.schema_name + '.config_param_user'
        sql += ' WHERE "cur_user" = current_user AND parameter = ' + "'virtual_layer_line'"
        row = self.controller.get_row(sql)
        utils_giswater.setText(self.dlg.virtual_layer_line, row)

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

        # TODO PARAMETRIZAR ESTO!!!!!
        # Manage parameters 'state_vdefault', 'exploitation_vdefault', 'municipality_vdefault', 'visitcat_vdefault'
        sql = "SELECT name FROM " + self.schema_name + ".value_state WHERE id::text = "
        sql += "(SELECT value FROM " + self.schema_name + ".config_param_user WHERE parameter = 'state_vdefault')::text"
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText("state_vdefault", str(row[0]))

        sql = "SELECT name FROM " + self.schema_name + ".exploitation WHERE expl_id::text = "
        sql += "(SELECT value FROM " + self.schema_name + ".config_param_user WHERE parameter = 'exploitation_vdefault')::text"
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText("exploitation_vdefault", str(row[0]))

        sql = "SELECT name FROM " + self.schema_name + ".ext_municipality WHERE muni_id::text = "
        sql += "(SELECT value FROM " + self.schema_name + ".config_param_user WHERE parameter = 'municipality_vdefault')::text"
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText("municipality_vdefault", str(row[0]))

        sql = "SELECT name FROM " + self.schema_name + ".om_visit_cat WHERE id::text = "
        sql += "(SELECT value FROM " + self.schema_name + ".config_param_user WHERE parameter = 'visitcat_vdefault')::text"
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText("visitcat_vdefault", str(row[0]))

        if self.project_type == 'ws':
            self.dlg.tab_config.removeTab(1)
            self.dlg.tab_config.removeTab(1)
        elif self.project_type == 'ud':
            self.dlg.tab_config.removeTab(1)

        self.dlg.exec_()


    def edit_config_edit_accept(self):
        
        # TODO: Parametrize it. Loop through all widgets
        if utils_giswater.isChecked("chk_state_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.state_vdefault, "state_vdefault", "config_param_user")
        else:
            self.delete_row("state_vdefault", "config_param_user")
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
        sql = 'DELETE FROM ' + self.schema_name + '.' + tablename
        sql += ' WHERE "cur_user" = current_user AND parameter = ' + "'" + parameter + "'"
        self.controller.execute_sql(sql)


    def populate_combo(self, widget, table_name, field_name="id"):
        """ Executes query and fill combo box """

        sql = "SELECT " + field_name
        sql += " FROM " + self.schema_name + "." + table_name + " ORDER BY " + field_name
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox(widget, rows)
        if len(rows) > 0:
            utils_giswater.setCurrentIndex(widget, 1)
        
