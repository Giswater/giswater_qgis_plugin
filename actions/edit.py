"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.Qt import QDate
from PyQt4.QtGui import QDateEdit, QComboBox
from qgis.core import QgsMapLayerRegistry

import os
import sys
from datetime import datetime
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater

from ui.change_node_type import ChangeNodeType          # @UnresolvedImport
from ui.config_edit import ConfigEdit                   # @UnresolvedImport
from ui.topology_tools import TopologyTools             # @UnresolvedImport
from ui.ud_catalog import UDcatalog                     # @UnresolvedImport
from ui.ws_catalog import WScatalog                     # @UnresolvedImport
from edit_2 import Edit_2

from parent import ParentAction


class Edit(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'edit' """
        
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.edit_2 = Edit_2(iface, settings, controller, plugin_dir)


    def set_project_type(self, project_type):
        self.project_type = project_type


    def edit_add_feature(self, layername):
        """ Button 01, 02: Add 'node' or 'arc' """
                
        # Set active layer and triggers action Add Feature
        layer = QgsMapLayerRegistry.instance().mapLayersByName(layername)
        if layer:
            layer = layer[0]
            self.iface.setActiveLayer(layer)
            layer.startEditing()
            self.iface.actionAddFeature().trigger()
        else:
            message = "Selected layer name not found"
            self.controller.show_warning(message, parameter=layername)
        
        
    def edit_arc_topo_repair(self):
        """ Button 19: Topology repair """

        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, 19)
        
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
        self.iface.mapCanvas().refresh()


    def edit_change_elem_type(self):
        """ Button 28: User select one node. A form is opened showing current node_type.type
            Combo to select new node_type.type
            Combo to select new node_type.id
            Combo to select new cat_node.id
        """

        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, 28)
        
        # Check if any active layer
        layer = self.iface.activeLayer()
        if layer is None:
            message = "You have to select a layer"
            self.controller.show_info(message)
            return

        # Check if at least one node is checked          
        count = layer.selectedFeatureCount()
        if count == 0:
            message = "You have to select at least one feature!"
            self.controller.show_info(message)
            return
        elif count > 1:
            message = "More than one feature selected. Only the first one will be processed!"
            self.controller.show_info(message)

        # Get selected features (nodes)
        feature = layer.selectedFeatures()[0]

        # Create the dialog, fill node_type and define its signals
        self.dlg = ChangeNodeType()
        utils_giswater.setDialog(self.dlg)
        self.new_node_type = self.dlg.findChild(QComboBox, "node_node_type_new")
        self.new_nodecat_id = self.dlg.findChild(QComboBox, "node_nodecat_id")

        # Get node_id and nodetype_id from current node
        self.node_id = feature.attribute('node_id')
        if self.project_type == 'ws':
            node_type = feature.attribute('nodetype_id')
        if self.project_type == 'ud':
            node_type = feature.attribute('node_type')
            sql = "SELECT DISTINCT(id) FROM ud30.cat_node ORDER BY id"
            rows = self.controller.get_rows(sql)
            utils_giswater.fillComboBox(self.new_nodecat_id, rows, allow_nulls=False)

        self.dlg.node_node_type.setText(node_type)
        self.new_node_type.currentIndexChanged.connect(self.edit_change_elem_type_get_value)
        self.dlg.btn_catalog.pressed.connect(partial(self.catalog, self.project_type, 'node'))
        self.dlg.btn_accept.pressed.connect(self.edit_change_elem_type_accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)

        # Fill 1st combo boxes-new system node type
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".node_type ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.new_node_type, rows)

        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'change_node_type')

        self.dlg.exec_()


    def edit_change_elem_type_get_value(self, index):
        """ Just select item to 'real' combo 'nodecat_id' (that is hidden) """
        
        if index == -1:
            return

        # Get selected value from 2nd combobox
        node_node_type_new = utils_giswater.getWidgetText(self.new_node_type)

        # When value is selected, enabled 3rd combo box
        if node_node_type_new != 'null':
            # Get selected value from 2nd combobox
            utils_giswater.setWidgetEnabled(self.new_nodecat_id)
            # Fill 3rd combo_box-catalog_id
            sql = "SELECT DISTINCT(id)"
            sql += " FROM " + self.schema_name + ".cat_node"
            sql += " WHERE nodetype_id = '" + node_node_type_new + "'"
            rows = self.controller.get_rows(sql)
            utils_giswater.fillComboBox(self.new_nodecat_id, rows)


    def edit_change_elem_type_accept(self):
        """ Update current type of node and save changes in database """

        old_node_type = utils_giswater.getWidgetText("node_node_type")
        node_node_type_new = utils_giswater.getWidgetText("node_node_type_new")
        node_nodecat_id = utils_giswater.getWidgetText("node_nodecat_id")

        if node_node_type_new != "null":
            if (node_nodecat_id != "null" and self.project_type == 'ws') or (self.project_type == 'ud'):
                sql = "SELECT man_table FROM  " + self.schema_name + ".node_type WHERE id = '" + old_node_type + "'"
                row = self.controller.get_row(sql)
                if not row:
                    return

                # Delete from current table
                sql = "DELETE FROM "+self.schema_name + "." + row[0] + " WHERE node_id ='" + self.node_id + "'"
                self.controller.execute_sql(sql)

                sql = "SELECT man_table FROM "+self.schema_name + ".node_type WHERE id ='" + node_node_type_new + "'"
                row = self.controller.get_row(sql)
                if not row:
                    return

                # Insert into new table
                sql = "INSERT INTO " + self.schema_name + "." + row[0] + "(node_id)"
                sql += " VALUES (" + self.node_id + ")"
                self.controller.execute_sql(sql)

                # Update field 'nodecat_id'
                if self.project_type == 'ws':
                    sql = "UPDATE " + self.schema_name + ".node SET nodecat_id = '" + node_nodecat_id + "'"
                    sql += " WHERE node_id = '" + self.node_id + "'"
                    self.controller.execute_sql(sql)
                # TODO  mirar si el  ""and node_nodecat_id != ''"" hace falta, ya que ahora el combobox no tendra registro vacio
                if self.project_type == 'ud':
                    sql = "UPDATE " + self.schema_name + ".node SET nodecat_id = '" + node_nodecat_id + "'"
                    sql += " WHERE node_id = '" + self.node_id + "'"
                    self.controller.execute_sql(sql)
                    sql = "UPDATE " + self.schema_name + ".node SET node_type = '" + node_node_type_new + "'"
                    sql += " WHERE node_id = '" + self.node_id + "'"
                    self.controller.execute_sql(sql)
            else:
                message = "Field catalog_id required!"
                self.controller.show_warning(message)
        else:
            message = "The node has not been updated because no catalog has been selected!"
            self.controller.show_warning(message)

        # Close form
        self.close_dialog(self.dlg)
        

    def catalog(self, wsoftware, geom_type):
        """ Set dialog depending water software """

        node_type = self.new_node_type.currentText()
        if wsoftware == 'ws':
            self.dlg_cat = WScatalog()
            self.field2 = 'pnom'
            self.field3 = 'dnom'
        elif wsoftware == 'ud':
            self.dlg_cat = UDcatalog()
            self.field2 = 'shape'
            self.field3 = 'geom1'
        utils_giswater.setDialog(self.dlg_cat)
        self.dlg_cat.open()

        # Set signals
        self.dlg_cat.btn_ok.pressed.connect(partial(self.fill_geomcat_id))
        self.dlg_cat.btn_cancel.pressed.connect(partial(self.close_dialog, self.dlg_cat))
        self.dlg_cat.matcat_id.currentIndexChanged.connect(partial(self.fill_catalog_id, wsoftware, geom_type))
        self.dlg_cat.matcat_id.currentIndexChanged.connect(partial(self.fill_filter2, wsoftware, geom_type))
        self.dlg_cat.matcat_id.currentIndexChanged.connect(partial(self.fill_filter3, wsoftware, geom_type))
        self.dlg_cat.filter2.currentIndexChanged.connect(partial(self.fill_catalog_id, wsoftware, geom_type))
        self.dlg_cat.filter2.currentIndexChanged.connect(partial(self.fill_filter3, wsoftware, geom_type))
        self.dlg_cat.filter3.currentIndexChanged.connect(partial(self.fill_catalog_id, wsoftware, geom_type))

        self.node_type_text = None
        if wsoftware == 'ws' and geom_type == 'node':
            self.node_type_text = node_type

        sql = "SELECT DISTINCT(matcat_id) as matcat_id "
        sql += " FROM " + self.schema_name + ".cat_" + geom_type
        if wsoftware == 'ws' and geom_type == 'node':
            sql += " WHERE " + geom_type + "type_id = '" + self.node_type_text + "'"
        sql += " ORDER BY matcat_id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.matcat_id, rows)

        sql = "SELECT DISTINCT(" + self.field2 + ")"
        sql += " FROM " + self.schema_name + ".cat_" + geom_type
        if wsoftware == 'ws' and geom_type == 'node':
            sql += " WHERE " + geom_type + "type_id = '" + self.node_type_text + "'"
        sql += " ORDER BY " + self.field2
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.filter2, rows)

        if wsoftware == 'ws':
            if geom_type == 'node':
                sql = "SELECT " + self.field3
                sql += " FROM (SELECT DISTINCT(regexp_replace(trim(' nm' FROM " + self.field3 + "), '-', '', 'g')::int) as x, " + self.field3
                sql += " FROM " + self.schema_name + ".cat_" + geom_type + " ORDER BY x) AS " + self.field3
            elif geom_type == 'arc':
                sql = "SELECT DISTINCT(" + self.field3 + "), (trim('mm' from " + self.field3 + ")::int) AS x, " + self.field3
                sql += " FROM " + self.schema_name + ".cat_" + geom_type + " ORDER BY x"
            elif geom_type == 'connec':
                sql = "SELECT DISTINCT(TRIM(TRAILING ' ' from " + self.field3 + ")) AS " + self.field3
                sql += " FROM " + self.schema_name + ".cat_" + geom_type + " ORDER BY " + self.field3
        else:
            if geom_type == 'node':
                sql = "SELECT DISTINCT(" + self.field3 + ") AS " + self.field3
                sql += " FROM " + self.schema_name + ".cat_" + geom_type
                sql += " ORDER BY " + self.field3
            elif geom_type == 'arc':
                sql = "SELECT DISTINCT(" + self.field3 + "), (trim('mm' from " + self.field3 + ")::int) AS x, " + self.field3
                sql += " FROM " + self.schema_name + ".cat_" + geom_type + " ORDER BY x"

        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.filter3, rows)


    def fill_filter2(self, wsoftware, geom_type):

        # Get values from filters
        mats = utils_giswater.getWidgetText(self.dlg_cat.matcat_id)

        # Set SQL query
        sql_where = None
        sql = "SELECT DISTINCT(" + self.field2 + ")"
        sql += " FROM " + self.schema_name + ".cat_" + geom_type

        # Build SQL filter
        if mats != "null":
            if sql_where is None:
                sql_where = " WHERE"
            sql_where += " matcat_id = '" + mats + "'"
        if wsoftware == 'ws' and self.node_type_text is not None:
            if sql_where is None:
                sql_where = " WHERE"
            else:
                sql_where += " AND"
            sql_where += " " + geom_type + "type_id = '" + self.node_type_text + "'"
        sql += sql_where + " ORDER BY " + self.field2

        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.filter2, rows)
        self.fill_filter3(wsoftware, geom_type)


    def fill_filter3(self, wsoftware, geom_type):

        # Get values from filters
        mats = utils_giswater.getWidgetText(self.dlg_cat.matcat_id)
        filter2 = utils_giswater.getWidgetText(self.dlg_cat.filter2)

        # Set SQL query
        sql_where = None
        if wsoftware == 'ws' and geom_type != 'connec':
            sql = "SELECT " + self.field3
            sql += " FROM (SELECT DISTINCT(regexp_replace(trim(' nm'from " + self.field3 + "),'-','', 'g')::int) as x, " + self.field3
        elif wsoftware == 'ws' and geom_type == 'connec':
            sql = "SELECT DISTINCT(TRIM(TRAILING ' ' from " + self.field3 + ")) as " + self.field3
        else:
            sql = "SELECT DISTINCT(" + self.field3 + ")"
        sql += " FROM " + self.schema_name + ".cat_" + geom_type

        # Build SQL filter
        if wsoftware == 'ws' and self.node_type_text is not None:
            sql_where = " WHERE " + geom_type + "type_id = '" + self.node_type_text + "'"
        if mats != "null":
            if sql_where is None:
                sql_where = " WHERE"
            else:
                sql_where += " AND"
            sql_where += " matcat_id = '" + mats + "'"
        if filter2 != "null":
            if sql_where is None:
                sql_where = " WHERE"
            else:
                sql_where += " AND"
            sql_where += " " + self.field2 + " = '" + filter2 + "'"
        if wsoftware == 'ws' and geom_type != 'connec':
            sql += sql_where + " ORDER BY x) AS " + self.field3
        else:
            sql += sql_where + " ORDER BY " + self.field3

        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.filter3, rows)


    def fill_catalog_id(self, wsoftware, geom_type):

        # Get values from filters
        mats = utils_giswater.getWidgetText(self.dlg_cat.matcat_id)
        filter2 = utils_giswater.getWidgetText(self.dlg_cat.filter2)
        filter3 = utils_giswater.getWidgetText(self.dlg_cat.filter3)

        # Set SQL query
        sql_where = None
        sql = "SELECT DISTINCT(id) as id"
        sql += " FROM " + self.schema_name + ".cat_" + geom_type

        if wsoftware == 'ws' and self.node_type_text is not None:
            sql_where = " WHERE " + geom_type + "type_id = '" + self.node_type_text + "'"
        if mats != "null":
            if sql_where is None:
                sql_where = " WHERE"
            else:
                sql_where += " AND"
            sql_where += " matcat_id = '" + mats + "'"
        if filter2 != "null":
            if sql_where is None:
                sql_where = " WHERE"
            else:
                sql_where += " AND"
            sql_where += " " + self.field2 + " = '" + filter2 + "'"
        if filter3 != "null":
            if sql_where is None:
                sql_where = " WHERE"
            else:
                sql_where += " AND"
            sql_where += " " + self.field3 + " = '" + filter3 + "'"
        sql += sql_where + " ORDER BY id"

        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_cat.id, rows)


    def fill_geomcat_id(self):
        catalog_id = utils_giswater.getWidgetText(self.dlg_cat.id)
        self.close_dialog(self.dlg_cat)
        self.new_nodecat_id.setEnabled(True)
        utils_giswater.setWidgetText(self.new_nodecat_id, catalog_id)


    def edit_add_element(self):
        """ Button 33: Add element """       
        self.edit_2.edit_add_element()


    def edit_add_file(self):
        """ Button 34: Add document """      
        self.edit_2.edit_add_file()
 
 
    def edit_add_visit(self):
        """ Button 64. Add visit """       
        self.edit_2.edit_add_visit()


    def add_new_doc(self):
        """ Call function of button Add document """
        self.edit_add_file()
        

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
        # QComboBox Utils
        sql = "SELECT DISTINCT(name) FROM " + self.schema_name + ".value_state ORDER BY name"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("state_vdefault", rows)
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".cat_work ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("workcat_vdefault", rows)
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".value_verified ORDER BY id"
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

        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".cat_arc ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("arccat_vdefault", rows)
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".cat_node ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("nodecat_vdefault", rows)
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".cat_connec ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("connecat_vdefault", rows)

        # QComboBox Ud
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".node_type ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("nodetype_vdefault", rows)
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".arc_type ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("arctype_vdefault", rows)
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".connec_type ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("connectype_vdefault", rows)

        sql = "SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
        rows = self.controller.get_rows(sql)
        for row in rows:
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
            utils_giswater.setChecked("chk_" + str(row[0]), True)

        sql = "SELECT name FROM " + self.schema_name + ".value_state WHERE id::text = "
        sql += "(SELECT value FROM " + self.schema_name + ".config_param_user WHERE parameter = 'state_vdefault')::text"
        rows = self.controller.get_rows(sql)
        if rows:
            utils_giswater.setWidgetText("state_vdefault", str(rows[0][0]))

        if self.project_type == 'ws':
            self.dlg.tab_config.removeTab(1)
            self.dlg.tab_config.removeTab(1)
        elif self.project_type == 'ud':
            self.dlg.tab_config.removeTab(1)

        self.dlg.exec_()


    def edit_config_edit_accept(self):

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
        if utils_giswater.isChecked("chk_nodetype_vdefault"):
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
        """ Insert or update values in tables with current_user control """

        sql = 'SELECT * FROM ' + self.schema_name + '.' + tablename + ' WHERE "cur_user" = current_user'
        rows = self.controller.get_rows(sql)
        exist_param = False
        if type(widget) != QDateEdit:
            if widget.currentText() != "":
                for row in rows:
                    if row[1] == parameter:
                        exist_param = True
                if exist_param:
                    sql = "UPDATE " + self.schema_name + "." + tablename + " SET value="
                    if widget.objectName() != 'state_vdefault':
                        sql += "'" + widget.currentText() + "' WHERE parameter='" + parameter + "'"
                    else:
                        sql += "(SELECT id FROM " + self.schema_name + ".value_state WHERE name ='" + widget.currentText() + "')"
                        sql += " WHERE parameter = 'state_vdefault' "
                else:
                    sql = 'INSERT INTO ' + self.schema_name + '.' + tablename + '(parameter, value, cur_user)'
                    if widget.objectName() != 'state_vdefault':
                        sql += " VALUES ('" + parameter + "', '" + widget.currentText() + "', current_user)"
                    else:
                        sql += " VALUES ('" + parameter + "', (SELECT id FROM " + self.schema_name + ".value_state WHERE name ='" + widget.currentText() + "'), current_user)"
        else:
            for row in rows:
                if row[1] == parameter:
                    exist_param = True
            if exist_param:
                sql = "UPDATE " + self.schema_name + "." + tablename + " SET value="
                _date = widget.dateTime().toString('yyyy-MM-dd')
                sql += "'" + str(_date) + "' WHERE parameter='" + parameter + "'"
            else:
                sql = 'INSERT INTO ' + self.schema_name + '.' + tablename + '(parameter, value, cur_user)'
                _date = widget.dateTime().toString('yyyy-MM-dd')
                sql += " VALUES ('" + parameter + "', '" + _date + "', current_user)"

        self.controller.execute_sql(sql)


    def delete_row(self,  parameter, tablename):
        sql = 'DELETE FROM ' + self.schema_name + '.' + tablename
        sql += ' WHERE "cur_user" = current_user AND parameter = ' + "'" + parameter + "'"
        self.controller.execute_sql(sql)


    def edit_dimensions(self):
        """ Button 39: Dimensioning """

        layer = QgsMapLayerRegistry.instance().mapLayersByName("Dimensioning")
        if layer:
            layer = layer[0]
            self.iface.setActiveLayer(layer)
            layer.startEditing()
            # Implement the Add Feature button
            self.iface.actionAddFeature().trigger()
        else:
            message = "Layer name not found"
            self.controller.show_warning(message, parameter="Dimensioning")  

