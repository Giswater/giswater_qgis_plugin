"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.Qt import QDate
from PyQt4.QtCore import Qt
from PyQt4.QtGui import QCompleter, QStringListModel, QDateEdit, QLineEdit, QComboBox
from qgis.core import QgsMapLayerRegistry           # @UnresolvedImport
from qgis.gui import QgsMapToolEmitPoint            # @UnresolvedImport

import os
import sys
from datetime import datetime
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater

from ..ui.change_node_type import ChangeNodeType    # @UnresolvedImport  
from ..ui.add_doc import AddDoc                    # @UnresolvedImport
from ..ui.add_element import AddElement            # @UnresolvedImport             
from ..ui.config_edit import ConfigEdit             # @UnresolvedImport
from ..ui.topology_tools import TopologyTools       # @UnresolvedImport
from ..ui.ud_catalog import UDcatalog
from ..ui.ws_catalog import WScatalog

from parent import ParentAction


class Edit(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'edit' """
        self.minor_version = "3.0"
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        # Get tables or views specified in 'db' config section
        self.table_arc = self.settings.value('db/table_arc', 'v_edit_arc')
        self.table_node = self.settings.value('db/table_node', 'v_edit_node')
        self.table_connec = self.settings.value('db/table_connec', 'v_edit_connec')
        self.table_gully = self.settings.value('db/table_gully', 'v_edit_gully')

        self.table_man_arc = self.settings.value('db/table_man_arc', 'v_edit_man_arc')
        self.table_man_node = self.settings.value('db/table_man_node', 'v_edit_man_node')
        self.table_man_connec = self.settings.value('db/table_man_connec', 'v_edit_man_connec')
        self.table_man_gully = self.settings.value('db/table_man_gully', 'v_edit_man_gully')

        self.table_version = self.settings.value('db/table_version', 'version')

        # Tables connec_group
        self.table_wjoin = self.settings.value('db/table_wjoin', 'v_edit_man_wjoin')
        self.table_tap = self.settings.value('db/table_tap', 'v_edit_man_tap')
        self.table_greentap = self.settings.value('db/table_greentap', 'v_edit_man_greentap')
        self.table_fountain = self.settings.value('db/table_fountain', 'v_edit_man_fountain')

        # Tables node_group
        self.table_tank = self.settings.value('db/table_tank', 'v_edit_man_tank')
        self.table_pump = self.settings.value('db/table_pump', 'v_edit_man_pump')
        self.table_source = self.settings.value('db/table_source', 'v_edit_man_source')
        self.table_meter = self.settings.value('db/table_meter', 'v_edit_man_meter')
        self.table_junction = self.settings.value('db/table_junction', 'v_edit_man_junction')
        self.table_waterwell = self.settings.value('db/table_waterwell', 'v_edit_man_waterwell')
        self.table_reduction = self.settings.value('db/table_reduction', 'v_edit_man_reduction')
        self.table_hydrant = self.settings.value('db/table_hydrant', 'v_edit_man_hydrant')
        self.table_valve = self.settings.value('db/table_valve', 'v_edit_man_valve')
        self.table_manhole = self.settings.value('db/table_manhole', 'v_edit_man_manhole')

        # Tables arc_group
        self.table_varc = self.settings.value('db/table_varc', 'v_edit_man_varc')
        self.table_siphon = self.settings.value('db/table_siphon', 'v_edit_man_siphon')
        self.table_conduit = self.settings.value('db/table_conduit', 'v_edit_man_conduit')
        self.table_waccel = self.settings.value('db/table_waccel', 'v_edit_man_waccel')

        self.table_chamber = self.settings.value('db/table_chamber', 'v_edit_man_chamber')
        self.table_chamber_pol = self.settings.value('db/table_chamber', 'v_edit_man_chamber_pol')
        self.table_netgully = self.settings.value('db/table_netgully', 'v_edit_man_netgully')
        self.table_netgully_pol = self.settings.value('db/table_netgully_pol', 'v_edit_man_netgully_pol')
        self.table_netinit = self.settings.value('db/table_netinit', 'v_edit_man_netinit')
        self.table_wjump = self.settings.value('db/table_wjump', 'v_edit_man_wjump')
        self.table_wwtp = self.settings.value('db/table_wwtp', 'v_edit_man_wwtp')
        self.table_wwtp_pol = self.settings.value('db/table_wwtp_pol', 'v_edit_man_wwtp_pol')
        self.table_storage = self.settings.value('db/table_storage', 'v_edit_man_storage')
        self.table_storage_pol = self.settings.value('db/table_storage_pol', 'v_edit_man_storage_pol')
        self.table_outfall = self.settings.value('db/table_outfall', 'v_edit_man_outfall')


    def set_project_type(self, project_type):
        self.project_type = project_type


    def menu_activate(self, node_type):

        # Set active layer
        layer = QgsMapLayerRegistry.instance().mapLayersByName(node_type)
        if layer:
            layer = layer[0]
            self.iface.setActiveLayer(layer)
            layer.startEditing()
            # Implement the Add Feature button
            self.iface.actionAddFeature().trigger()
        else:
            self.controller.show_warning("Selected layer name not found: " + str(node_type))


    def edit_arc_topo_repair(self):
        """ Button 19. Topology repair """

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
        """ Button 19. Executes functions that are selected """

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
            self.controller.show_info(message, context_name='ui_message')
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
        
        # Get node_id and nodetype_id from current node
        self.node_id = feature.attribute('node_id')
        node_type = feature.attribute('nodetype_id')

        # Create the dialog, fill node_type and define its signals
        self.dlg = ChangeNodeType()
        utils_giswater.setDialog(self.dlg)

        self.dlg.node_node_type.setText(node_type)
        self.dlg.node_node_type_new.currentIndexChanged.connect(self.edit_change_elem_type_get_value)

        self.new_selected_type = self.dlg.findChild(QComboBox, "node_node_type_new")
        self.new_node_nodecat_id = self.dlg.findChild(QComboBox, "node_nodecat_id")

        self.dlg.btn_catalog.pressed.connect(partial(self.catalog, 'ws', 'node'))
        self.dlg.btn_accept.pressed.connect(self.edit_change_elem_type_accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)

        # Fill 1st combo boxes-new system node type
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".node_type ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("node_node_type_new", rows)

        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'change_node_type')

        self.dlg.exec_()


    def catalog(self, wsoftware, geom_type, node_type=None):
        """ Set dialog depending water software """

        node_type = self.new_selected_type.currentText()
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
        self.dlg_cat.btn_ok.pressed.connect(partial(self.fill_geomcat_id, geom_type))
        self.dlg_cat.btn_cancel.pressed.connect(self.dlg_cat.close)
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


    def fill_geomcat_id(self, geom_type):
        catalog_id = utils_giswater.getWidgetText(self.dlg_cat.id)
        self.close_dialog(self.dlg_cat)
        self.new_node_nodecat_id.setEnabled(True)
        utils_giswater.setWidgetText(self.new_node_nodecat_id, catalog_id)


    def edit_add_element(self):
        """ Button 33: Add element """

        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)

        # Create the dialog and signals
        self.dlg = AddElement()
        utils_giswater.setDialog(self.dlg)
        self.set_icon(self.dlg.add_geom, "129")


        self.dlg.btn_accept.pressed.connect(self.ed_add_element_accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)

        # Manage i18n of the form
        self.controller.translate_form(self.dlg, 'element')

        # Check if we have at least one feature selected
        if not self.edit_check():
            return

        # Fill combo boxes
        self.populate_combo("elementcat_id", "cat_element")
        self.populate_combo("state", "value_state")
        self.populate_combo("location_type", "man_type_location")
        self.populate_combo("workcat_id", "cat_work")
        self.populate_combo("buildercat_id", "cat_builder")
        self.populate_combo("ownercat_id", "cat_owner")
        self.populate_combo("verified", "value_verified")
        self.populate_combo("workcat_id_end", "cat_work")

        # Adding auto-completion to a QLineEdit
        self.edit = self.dlg.findChild(QLineEdit, "element_id")
        self.completer = QCompleter()
        self.edit.setCompleter(self.completer)
        model = QStringListModel()
        sql = "SELECT DISTINCT(element_id) FROM " + self.schema_name + ".element "
        row = self.dao.get_rows(sql)
        for i in range(0, len(row)):
            aux = row[i]
            row[i] = str(aux[0])

        model.setStringList(row)
        self.completer.setModel(model)

        # Set signal to reach selected value from QCompleter
        self.completer.activated.connect(self.ed_add_el_autocomplete)
        self.dlg.add_geom.pressed.connect(self.add_point)

        # Open the dialog
        self.dlg.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg.open()


    def edit_add_file(self):
        """ Button 34: Add document """

        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)

        # Create the dialog and signals
        self.dlg = AddDoc()
        utils_giswater.setDialog(self.dlg)
        self.dlg.btn_accept.pressed.connect(self.edit_add_file_accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)

        # Get widgets
        self.dlg.path_url.clicked.connect(partial(self.open_web_browser, "path"))
        self.dlg.path_doc.clicked.connect(partial(self.get_file_dialog, "path"))

        # Manage i18n of the form
        self.controller.translate_form(self.dlg, 'file')

        # Check if we have at least one feature selected
        if not self.edit_check():
            return

        # Fill combo boxes
        self.populate_combo("doc_type", "doc_type")

        # Adding auto-completion to a QLineEdit
        self.completer = QCompleter()
        self.dlg.doc_id.setCompleter(self.completer)

        model = QStringListModel()
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".doc "
        row = self.dao.get_rows(sql)
        for i in range(0, len(row)):
            aux = row[i]
            row[i] = str(aux[0])

        model.setStringList(row)
        self.completer.setModel(model)

        # Set signal to reach selected value from QCompleter
        self.completer.activated.connect(self.edit_add_file_autocomplete)

        # Open the dialog
        self.dlg.exec_()


    def edit_change_elem_type_get_value(self, index):
        """ Just select item to 'real' combo 'nodecat_id' (that is hidden) """

        if index == -1:
            return

        # Get selected value from 2nd combobox
        node_node_type_new = utils_giswater.getWidgetText("node_node_type_new")

        # When value is selected, enabled 3rd combo box
        if node_node_type_new != 'null':
            # Get selected value from 2nd combobox
            utils_giswater.setWidgetEnabled("node_nodecat_id")
            # Fill 3rd combo_box-catalog_id
            sql = "SELECT DISTINCT(id)"
            sql += " FROM " + self.schema_name + ".cat_node"
            sql += " WHERE nodetype_id = '" + node_node_type_new + "'"
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("node_nodecat_id", rows)


    def edit_change_elem_type_accept(self):
        """ Update current type of node and save changes in database """

        old_node_type = utils_giswater.getWidgetText("node_node_type")
        node_node_type_new = utils_giswater.getWidgetText("node_node_type_new")
        node_nodecat_id = utils_giswater.getWidgetText("node_nodecat_id")

        if node_node_type_new != "null":
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
            sql = "UPDATE " + self.schema_name + ".node SET nodecat_id = '" + node_nodecat_id + "'"
            sql += " WHERE node_id = '" + self.node_id + "'"
            self.controller.execute_sql(sql)

        else:
            message = "The node has not been updated because no catalog has been selected!"
            self.controller.show_warning(message)

        # Close form
        self.close_dialog(self.dlg)


    def edit_add_file_autocomplete(self):
        """ Once we select 'element_id' using autocomplete, fill widgets with current values """

        self.dlg.doc_id.setCompleter(self.completer)
        doc_id = utils_giswater.getWidgetText("doc_id")

        # Get values from database
        sql = "SELECT doc_type, tagcat_id, observ, path"
        sql += " FROM " + self.schema_name + ".doc"
        sql += " WHERE id = '" + doc_id + "'"
        row = self.dao.get_row(sql)

        # Fill widgets
        columns_length = self.dao.get_columns_length()
        for i in range(0, columns_length):
            column_name = self.dao.get_column_name(i)
            utils_giswater.setWidgetText(column_name, row[column_name])


    def edit_add_file_accept(self):
        """ Insert or update table 'document'. Add document to selected feature """

        # Get values from dialog
        doc_id = utils_giswater.getWidgetText("doc_id")
        doc_type = utils_giswater.getWidgetText("doc_type")
        tagcat_id = utils_giswater.getWidgetText("tagcat_id")
        observ = utils_giswater.getWidgetText("observ")
        path = utils_giswater.getWidgetText("path")

        if doc_id == 'null':
            # Show warning message
            message = "You need to insert doc_id"
            self.controller.show_warning(message, context_name='ui_message')
            return

        # Check if this document already exists
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".doc WHERE id = '" + doc_id + "'"
        row = self.dao.get_row(sql)
        
        # If document already exist perform an UPDATE
        if row:
            answer = self.controller.ask_question("Are you sure you want change the data?")
            if answer:
                sql = "UPDATE " + self.schema_name + ".doc "
                sql += " SET doc_type = '" + doc_type + "', observ = '" + observ + "', path = '" + path + "'"
                sql += " WHERE id = '" + doc_id + "'"
                status = self.controller.execute_sql(sql)
                if status:
                    self.ed_add_to_feature("doc", doc_id)
                    message = "Values has been updated"
                    self.controller.show_info(message, context_name='ui_message')

        # If document doesn't exist perform an INSERT
        else:
            sql = "INSERT INTO " + self.schema_name + ".doc (id, doc_type, path, observ) "
            sql += " VALUES ('" + doc_id + "', '" + doc_type + "', '" + path + "', '" + observ +  "')"
            status = self.controller.execute_sql(sql)
            if status:
                self.ed_add_to_feature("doc", doc_id)
                message = "Values has been updated"
                self.controller.show_info(message, context_name='ui_message')
            if not status:
                message = "Error inserting element in table, you need to review data"
                self.controller.show_warning(message, context_name='ui_message')
                return

        self.close_dialog()


    def add_point(self):
        """ Create the appropriate map tool and connect to the corresponding signal """
        map_canvas = self.iface.mapCanvas()
        self.emit_point = QgsMapToolEmitPoint(map_canvas)
        map_canvas.setMapTool(self.emit_point)
        self.emit_point.canvasClicked.connect(partial(self.get_xy))


    def get_xy(self, point):
        self.x = point.x()
        self.y = point.y()
        self.emit_point.canvasClicked.disconnect()


    def ed_add_el_autocomplete(self):
        """ Once we select 'element_id' using autocomplete, fill widgets with current values """

        self.dlg.element_id.setCompleter(self.completer)
        element_id = utils_giswater.getWidgetText("element_id")

        # Get values from database
        sql = "SELECT elementcat_id, location_type, ownercat_id, state, workcat_id,"
        sql += " buildercat_id, annotation, observ, comment, link, verified, rotation"
        sql += " FROM " + self.schema_name + ".element"
        sql += " WHERE element_id = '" + element_id + "'"
        row = self.dao.get_row(sql)

        # Fill widgets
        columns_length = self.dao.get_columns_length()
        for i in range(0, columns_length):
            column_name = self.dao.get_column_name(i)
            utils_giswater.setWidgetText(column_name, row[column_name])


    def ed_add_element_accept(self):
        """ Insert or update table 'element'. Add element to selected features """

        # Get values from dialog
        element_id = utils_giswater.getWidgetText("element_id")
        elementcat_id = utils_giswater.getWidgetText("elementcat_id")
        workcat_id_end = utils_giswater.getWidgetText("workcat_id_end")
        state = utils_giswater.getWidgetText("state")
        annotation = utils_giswater.getWidgetText("annotation")
        observ = utils_giswater.getWidgetText("observ")
        comment = utils_giswater.getWidgetText("comment")
        location_type = utils_giswater.getWidgetText("location_type")
        workcat_id = utils_giswater.getWidgetText("workcat_id")
        buildercat_id = utils_giswater.getWidgetText("buildercat_id")
        ownercat_id = utils_giswater.getWidgetText("ownercat_id")
        rotation = utils_giswater.getWidgetText("rotation")
        link = utils_giswater.getWidgetText("link")
        verified = utils_giswater.getWidgetText("verified")

        if element_id == 'null':
            # Show warning message
            message = "You need to insert element_id"
            self.controller.show_warning(message, context_name='ui_message')
            return

        # Get SRID
        srid = self.controller.plugin_settings_value('srid')   

        
        # Check if we already have data with selected element_id
        sql = "SELECT DISTINCT(element_id) FROM " + self.schema_name + ".element WHERE element_id = '" + str(element_id) + "'"
        row = self.dao.get_row(sql)
        
        # If element already exist perform an UPDATE
        if row:
            answer = self.controller.ask_question("Are you sure you want change the data?")
            if answer:
                sql = "UPDATE " + self.schema_name + ".element"
                sql += " SET elementcat_id = '" + elementcat_id + "', state = '" + state + "', location_type = '" + location_type + "'"
                sql += ", workcat_id_end = '" + workcat_id_end + "', workcat_id = '" + workcat_id + "', buildercat_id = '" + buildercat_id + "', ownercat_id = '" + ownercat_id + "'"
                sql += ", rotation = '" + rotation + "',comment = '" + comment + "', annotation = '" + annotation + "', observ = '" + observ + "', link = '" + link + "', verified = '" + verified + "'"
                sql += ", the_geom = ST_SetSRID(ST_MakePoint(" + str(self.x) + "," + str(self.y) + "), " + str(srid) +")"
                sql += " WHERE element_id = '" + element_id + "'"              
                status = self.controller.execute_sql(sql)
                if status:
                    self.ed_add_to_feature("element", element_id)
                    message = "Values has been updated"
                    self.controller.show_info(message)

        # If element doesn't exist perform an INSERT
        else:
            sql = "INSERT INTO " + self.schema_name + ".element (element_id, elementcat_id, state, location_type"
            sql += ", workcat_id, buildercat_id, ownercat_id, rotation, comment, annotation, observ, link, verified, workcat_id_end, the_geom) "
            sql += " VALUES ('" + element_id + "', '" + elementcat_id + "', '" + state + "', '" + location_type + "', '"
            sql += workcat_id + "', '" + buildercat_id + "', '" + ownercat_id + "', '" + rotation + "', '" + comment + "', '"
            sql += annotation + "','" + observ + "','" + link + "','" + verified + "','" + workcat_id_end + "',"
            sql += "ST_SetSRID(ST_MakePoint(" + str(self.x) + "," + str(self.y) + "), " + str(srid) +")"         
            status = self.controller.execute_sql(sql)
            if status:
                self.ed_add_to_feature("element", element_id)
                message = "Values has been updated"
                self.controller.show_info(message)
            if not status:
                message = "Error inserting element in table, you need to review data"
                self.controller.show_warning(message)
                return

        self.close_dialog(self.dlg)
        self.iface.mapCanvas().refreshAllLayers()


    def ed_add_to_feature(self, table_name, value_id):
        """ Add document or element to selected features """

        # Get schema and table name of selected layer
        layer_source = self.controller.get_layer_source(self.layer)
        uri_table = layer_source['table']
        if uri_table is None:
            msg = "Error getting table name from selected layer"
            self.controller.show_warning(msg, context_name='ui_message')
            return

        elem_type = None
        field_id = None

        if self.table_arc in uri_table:
            elem_type = "arc"
            field_id = "arc_id"
        if self.table_node in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_connec in uri_table:
            elem_type = "connec"
            field_id = "connec_id"
        if self.table_gully in uri_table:
            elem_type = "gully"
            field_id = "gully_id"

        if self.table_man_arc in uri_table:
            elem_type = "arc"
            field_id = "arc_id"
        if self.table_man_node in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_man_connec in uri_table:
            elem_type = "connec"
            field_id = "connec_id"
        if self.table_man_gully in uri_table:
            elem_type = "gully"
            field_id = "gully_id"

        if self.table_wjoin in uri_table:
            elem_type = "connec"
            field_id = "connec_id"
        if self.table_tap in uri_table:
            elem_type = "connec"
            field_id = "connec_id"
        if self.table_greentap in uri_table:
            elem_type = "connec"
            field_id = "connec_id"
        if self.table_fountain in uri_table:
            elem_type = "connec"
            field_id = "connec_id"

        if self.table_tank in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_pump in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_source in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_meter in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_junction in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_waterwell in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_reduction in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_hydrant in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_valve in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_manhole in uri_table:
            elem_type = "node"
            field_id = "node_id"

        if self.table_chamber in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_chamber_pol in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_netgully in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_netgully_pol in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_netinit in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_wjump in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_wwtp in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_wwtp_pol in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_storage in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_storage_pol in uri_table:
            elem_type = "node"
            field_id = "node_id"
        if self.table_outfall in uri_table:
            elem_type = "node"
            field_id = "node_id"

        if self.table_varc in uri_table:
            elem_type = "arc"
            field_id = "arc_id"
        if self.table_siphon in uri_table:
            elem_type = "arc"
            field_id = "arc_id"
        if self.table_conduit in uri_table:
            elem_type = "arc"
            field_id = "arc_id"
        if self.table_waccel in uri_table:
            elem_type = "arc"
            field_id = "arc_id"
        if 'v_edit_man_pipe' in uri_table:
            elem_type = "arc"
            field_id = "arc_id"

        if field_id is None:
            self.controller.show_info("Current active layer is different than selected features")
            return

        # Get selected features
        features = self.layer.selectedFeatures()
        for feature in features:
            elem_id = feature.attribute(field_id)

            sql = "SELECT * FROM " + self.schema_name + "." + table_name + "_x_" + elem_type
            sql += " WHERE " + field_id + " = '" + elem_id + "' AND " + value_id + " = " + table_name + "_id"
            row = self.dao.get_row(sql)
            if row is None:
                sql = "INSERT INTO " + self.schema_name + "." + table_name + "_x_" + elem_type + " (" + field_id + ", " + table_name + "_id) "
                sql += " VALUES ('" + elem_id + "', '" + value_id + "')"
                self.controller.execute_sql(sql)


    def edit_check(self):
        """ Initial check for buttons 33 and 34 """

        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, 32)

        # Check if at least one node is checked
        self.layer = self.iface.activeLayer()
        if self.layer is None:
            message = "You have to select a layer"
            self.controller.show_info(message, context_name='ui_message')
            return False

        count = self.layer.selectedFeatureCount()
        if count == 0:
            message = "You have to select at least one feature!"
            self.controller.show_info(message, context_name='ui_message')
            return False

        return True


    def edit_config_edit(self):
        """ Button 98: Open a dialog showing data from table 'config_param_user' """

        # Create the dialog and signals
        self.dlg = ConfigEdit()
        utils_giswater.setDialog(self.dlg)
        self.dlg.btn_accept.pressed.connect(self.edit_config_edit_accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)

        # Set values from widgets of type QComboBox and dates
        # QComboBox Utils
        sql = "SELECT DISTINCT(name) FROM " + self.schema_name + ".value_state ORDER BY name"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("state_vdefault", rows)
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".cat_work ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("workcat_vdefault", rows)
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".value_verified ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("verified_vdefault", rows)

        sql = 'SELECT value FROM ' + self.schema_name + '.config_param_user'
        sql += ' WHERE "cur_user" = current_user AND parameter = ' + "'builtdate_vdefault'"
        row = self.dao.get_row(sql)
        if row is not None:
            date_value = datetime.strptime(row[0], '%Y-%m-%d')
        else:
            date_value = QDate.currentDate()
        utils_giswater.setCalendarDate("builtdate_vdefault", date_value)

        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".cat_arc ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("arccat_vdefault", rows)
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".cat_node ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("nodecat_vdefault", rows)
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".cat_connec ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("connecat_vdefault", rows)

        # QComboBox Ud
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".node_type ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("nodetype_vdefault", rows)
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".arc_type ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("arctype_vdefault", rows)
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".connec_type ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("connectype_vdefault", rows)

        sql = "SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
        rows = self.dao.get_rows(sql)
        for row in rows:
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
            utils_giswater.setChecked("chk_" + str(row[0]), True)

        sql = "SELECT name FROM " + self.schema_name + ".value_state WHERE id::text = "
        sql += "(SELECT value FROM " + self.schema_name + ".config_param_user WHERE parameter = 'state_vdefault')::text"
        rows = self.dao.get_rows(sql)
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
        self.controller.show_info(message, context_name='ui_message')
        self.close_dialog()


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


    def populate_combo(self, widget, table_name, field_name="id"):
        """ Executes query and fill combo box """

        sql = "SELECT " + field_name
        sql += " FROM " + self.schema_name + "." + table_name + " ORDER BY " + field_name
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox(widget, rows)
        if len(rows) > 0:
            utils_giswater.setCurrentIndex(widget, 1)


    def edit_dimensions(self):
        """ Button 39: Dimensioning """

        layer = QgsMapLayerRegistry.instance().mapLayersByName("v_edit_dimensions")
        if layer:
            layer = layer[0]
            self.iface.setActiveLayer(layer)
            layer.startEditing()
            # Implement the Add Feature button
            self.iface.actionAddFeature().trigger()
        else:
            message = "Layer name not found"
            self.controller.show_warning(message, parameter="v_edit_dimensions")
        
        