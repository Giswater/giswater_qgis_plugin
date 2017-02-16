'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from PyQt4.QtGui import QComboBox, QPushButton, QTableView, QTabWidget

from functools import partial

import utils_giswater
from parent_init import ParentDialog


def formOpen(dialog, layer, feature):
    ''' Function called when a node is identified in the map '''

    global feature_dialog
    utils_giswater.setDialog(dialog)
    # Create class to manage Feature Form interaction
    feature_dialog = NodeDialog(dialog, layer, feature)
    init_config()


def init_config():

    # Manage visibility
    feature_dialog.dialog.findChild(QComboBox, "node_type").setVisible(False)
    feature_dialog.dialog.findChild(QComboBox, "nodecat_id").setVisible(False)

    # Manage 'nodecat_id'
    nodecat_id = utils_giswater.getWidgetText("nodecat_id")
    feature_dialog.dialog.findChild(QComboBox, "nodecat_id_dummy").activated.connect(feature_dialog.change_node_cat)
    utils_giswater.setSelectedItem("nodecat_id_dummy", nodecat_id)
    utils_giswater.setSelectedItem("nodecat_id", nodecat_id)

    # Manage 'node_type'
    node_type_id = utils_giswater.getWidgetText("node_type")
    utils_giswater.setSelectedItem("node_type_dummy", node_type_id)
    feature_dialog.dialog.findChild(QComboBox, "node_type_dummy").activated.connect(feature_dialog.change_node_type_id)
    feature_dialog.change_node_type_id(-1)

    # Set 'epa_type' and button signals
    feature_dialog.dialog.findChild(QComboBox, "epa_type").activated.connect(feature_dialog.change_epa_type)
    feature_dialog.dialog.findChild(QPushButton, "btn_accept").clicked.connect(feature_dialog.save)
    feature_dialog.dialog.findChild(QPushButton, "btn_close").clicked.connect(feature_dialog.close)


class NodeDialog(ParentDialog):

    def __init__(self, dialog, layer, feature):
        ''' Constructor class '''
        super(NodeDialog, self).__init__(dialog, layer, feature)
        self.loaded = False
        self.init_config_form()


    def init_config_form(self):
        ''' Custom form initial configuration '''

        # Define local variables
        context_name = "ws_node"    
        table_element = "v_ui_element_x_node" 
        table_document = "v_ui_doc_x_node" 
        table_scada = "v_ui_scada_x_node"        
        
        # Define class variables
        self.field_id = "node_id"
        self.id = utils_giswater.getWidgetText(self.field_id, False)
        self.filter = self.field_id+" = '"+str(self.id)+"'"
        self.node_type = utils_giswater.getWidgetText("node_type", False)
        self.nodecat_id = utils_giswater.getWidgetText("nodecat_id", False)
        self.epa_type = utils_giswater.getWidgetText("epa_type", False)

        # Get widget controls
        self.tab_analysis = self.dialog.findChild(QTabWidget, "tab_analysis")
        self.tab_event = self.dialog.findChild(QTabWidget, "tab_event")
        self.tab_event_2 = self.dialog.findChild(QTabWidget, "tab_event_2")
        self.tab_main = self.dialog.findChild(QTabWidget, "tab_main")
        self.tbl_info = self.dialog.findChild(QTableView, "tbl_info")
        self.tbl_document = self.dialog.findChild(QTableView, "tbl_document")
        self.tbl_rtc = self.dialog.findChild(QTableView, "tbl_rtc")

        # Manage tab visibility
        self.set_tabs_visibility()

        # Manage i18n
        self.translate_form(context_name)

        # Define and execute query to populate combo 'node_type_dummy'
        self.fill_node_type_id()

        # Load data from related tables
        self.load_data()

        # Fill the info table
        self.fill_table(self.tbl_info, self.schema_name+"."+table_element, self.filter)
        
        # Configuration of info table 
        self.set_configuration(self.tbl_info, table_element)

        # Fill the tab Document
        self.fill_tbl_document(self.tbl_document, self.schema_name+"."+table_document, self.filter)
        
        # Configuration of table document
        self.set_configuration(self.tbl_document, table_document)
         
        # Fill the tab Scada
        self.fill_tbl_scada(self.tbl_rtc, self.schema_name+"."+table_scada, self.filter)
         
        # Configuration of table scada
        self.set_configuration(self.tbl_rtc, table_scada)

        # Set signals
        self.dialog.findChild(QPushButton, "btn_element_delete").clicked.connect(partial(self.delete_records, self.tbl_info, table_element))
        self.dialog.findChild(QPushButton, "btn_doc_delete").clicked.connect(partial(self.delete_records, self.tbl_document, table_document))


    def set_tabs_visibility(self):
        ''' Hide some tabs '''

        # Remove tabs: EPANET, Event, Log
        self.tab_main.removeTab(5)
        self.tab_main.removeTab(4)
        self.tab_main.removeTab(2)

        # Get 'epa_type'
        man_visible = False
        index_tab = 0
        if self.epa_type == 'JUNCTION':
            index_tab = 0
            self.epa_table = 'inp_junction'
        elif self.epa_type == 'RESERVOIR' or self.epa_type == 'HYDRANT':
            index_tab = 1
            self.epa_table = 'inp_reservoir'
        elif self.epa_type == 'TANK':
            index_tab = 2
            self.epa_table = 'inp_tank'
            man_visible = True
        elif self.epa_type == 'PUMP':
            index_tab = 3
            self.epa_table = 'inp_pump'
        elif self.epa_type == 'VALVE':
            index_tab = 4
            self.epa_table = 'inp_valve'
        elif self.epa_type == 'SHORTPIPE' or self.epa_type == 'FILTER':
            index_tab = 5
            self.epa_table = 'inp_shortpipe'
        elif self.epa_type == 'MEASURE INSTRUMENT':
            index_tab = 6

        # Tab 'Add. info': Manage visibility of these widgets
        utils_giswater.setWidgetVisible("label_man_tank_vmax", man_visible)
        utils_giswater.setWidgetVisible("label_man_tank_area", man_visible)
        utils_giswater.setWidgetVisible("man_tank_vmax", man_visible)
        utils_giswater.setWidgetVisible("man_tank_area", man_visible)

        # Tab 'EPANET': Hide some tabs depending 'epa_type'
        # Move 'visible' tab to last position and remove previous ones
        self.tab_analysis.tabBar().moveTab(index_tab, 5);
        for i in range(0, self.tab_analysis.count() - 1):    #@UnusedVariable
            self.tab_analysis.removeTab(0)
        self.tab_event.tabBar().moveTab(index_tab, 6);
        for i in range(0, self.tab_event.count() - 1):   #@UnusedVariable
            self.tab_event.removeTab(0)


    def load_tab_add_info(self):
        ''' Load data from tab 'Add. info' '''

        if self.epa_type == 'TANK':
            sql = "SELECT vmax, area"
            sql+= " FROM "+self.schema_name+".man_tank"
            sql+= " WHERE "+self.field_id+" = '"+self.id+"'"
            row = self.dao.get_row(sql)
            if row:
                utils_giswater.setWidgetText("man_tank_vmax", str(row[0]))
                utils_giswater.setWidgetText("man_tank_area", str(row[1]))


    def load_tab_analysis(self):
        ''' Load data from tab 'Analysis' '''

        if self.epa_type == 'JUNCTION':
            # Load combo 'pattern_id'
            combo = self.epa_table + "_pattern_id"
            table_name = "inp_pattern"
            sql = "SELECT pattern_id FROM " + self.schema_name + "." + table_name + " ORDER BY pattern_id"
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox(combo, rows)

            self.fields_junction = ['demand', 'pattern_id']
            sql = "SELECT "
            for i in range(len(self.fields_junction)):
                sql += self.fields_junction[i] + ", "
            sql = sql[:-2]
            sql += " FROM " + self.schema_name + "." + self.epa_table + " WHERE node_id = '" + self.id + "'"
            row = self.dao.get_row(sql)
            if row:
                for i in range(len(self.fields_junction)):
                    widget_name = self.epa_table + "_" + self.fields_junction[i]
                    utils_giswater.setWidgetText(widget_name, str(row[i]))

        elif self.epa_type == 'TANK':
            # Load combo 'curve_id'
            combo = self.epa_table + "_curve_id"
            table_name = "inp_curve_id"
            sql = "SELECT id FROM " + self.schema_name + ".inp_curve_id ORDER BY id"
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox(combo, rows)

            self.fields_tank = ['initlevel', 'minlevel', 'maxlevel', 'diameter', 'minvol', 'curve_id']
            sql = "SELECT "
            for i in range(len(self.fields_tank)):
                sql += self.fields_tank[i] + ", "
            sql = sql[:-2]
            sql += " FROM " + self.schema_name + "." + self.epa_table + " WHERE " + self.field_id + " = '" + self.id + "'"
            row = self.dao.get_row(sql)
            if row:
                for i in range(len(self.fields_tank)):
                    widget_name = self.epa_table + "_" + self.fields_tank[i]
                    utils_giswater.setWidgetText(widget_name, str(row[i]))


    def save_tab_add_info(self):
        ''' Save tab from tab 'Add. info' '''

        if self.epa_type == 'TANK':
            vmax = utils_giswater.getWidgetText("man_tank_vmax", False)
            area = utils_giswater.getWidgetText("man_tank_area", False)
            sql = " UPDATE " + self.schema_name + ".man_tank SET"
            sql += " vmax = " + str(vmax) + ", area = " + str(area)
            sql += " WHERE node_id = '" + self.id + "';"
            self.controller.execute_sql(sql)
            total = self.dao.get_rowcount()
            # Perform an INSERT if any record has been updated
            if total == 0:
                sql = "INSERT INTO " + self.schema_name + ".man_tank (node_id, vmax, area) VALUES"
                sql += " ('" + self.id + "', " + str(vmax) + ", " + str(area) + ");"
                self.controller.execute_sql(sql)


    def save_tab_analysis(self):
        ''' Save tab from tab 'Analysis' '''

        # super(NodeDialog, self).save_tab_analysis()
        if self.epa_type == 'JUNCTION':
            values = []
            sql = "UPDATE " + self.schema_name + "." + self.epa_table + " SET "
            for i in range(len(self.fields_junction)):
                widget_name = self.epa_table + "_" + self.fields_junction[i]
                value = utils_giswater.getWidgetText(widget_name, True)
                values.append(value)
                sql += self.fields_junction[i] + " = " + str(values[i]) + ", "
            sql = sql[:-2]
            sql += " WHERE node_id = '" + self.id + "'"
            self.controller.execute_sql(sql)

        if self.epa_type == 'TANK':
            values = []
            sql = "UPDATE " + self.schema_name + "." + self.epa_table + " SET "
            for i in range(len(self.fields_tank)):
                widget_name = self.epa_table + "_" + self.fields_tank[i]
                value = utils_giswater.getWidgetText(widget_name, True)
                values.append(value)
                sql += self.fields_tank[i] + " = " + str(values[i]) + ", "
            sql = sql[:-2]
            sql += " WHERE node_id = '" + self.id + "'"
            self.controller.execute_sql(sql)


    def fill_node_type_id(self):
        ''' Define and execute query to populate combo 'node_type_dummy' '''

        # Get node_type.type from node_type.id
        sql = "SELECT type FROM " + self.schema_name + ".node_type"
        if self.node_type:
            sql += " WHERE id = '" + self.node_type + "'"
        row = self.dao.get_row(sql)
        if row:
            node_type_type = row[0]
            sql = "SELECT node_type.id"
            sql += " FROM " + self.schema_name + ".node_type INNER JOIN " + self.schema_name + ".cat_node ON node_type.id = cat_node.nodetype_id"
            sql += " WHERE type = '" + node_type_type + "' GROUP BY node_type.id ORDER BY node_type.id"
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("node_type_dummy", rows, False)
            utils_giswater.setWidgetText("node_type_dummy", self.node_type)


    def change_node_type_id(self, index):
        ''' Define and execute query to populate combo 'cat_nodetype_id' '''

        node_type_id = utils_giswater.getWidgetText("node_type_dummy", False)
        if node_type_id:
            utils_giswater.setWidgetText("node_type", node_type_id)
            sql = "SELECT id FROM " + self.schema_name + ".cat_node"
            sql += " WHERE nodetype_id = '" + node_type_id + "' ORDER BY id"
            rows = self.dao.get_rows(sql)
            utils_giswater.fillComboBox("nodecat_id_dummy", rows, False)
            if index == -1:
                utils_giswater.setWidgetText("nodecat_id_dummy", self.nodecat_id)
            self.change_node_cat()

            if self.loaded:
                sql = "SELECT epa_default FROM " + self.schema_name + ".node_type"
                sql += " WHERE id = '" + node_type_id + "'"
                rows = self.dao.get_rows(sql)
                utils_giswater.setWidgetText("epa_type", rows[0][0])
                utils_giswater.setSelectedItem("epa_type", rows[0][0])
                self.change_epa_type(-1)

            else:
                self.loaded = True


    def change_node_cat(self):
        ''' Just select item to 'real' combo 'nodecat_id' (that is hidden) '''
        nodecat_id_dummy = utils_giswater.getWidgetText("nodecat_id_dummy")
        utils_giswater.setWidgetText("nodecat_id", nodecat_id_dummy)


    def change_epa_type(self, index):   #@UnusedVariable
        ''' Refresh form '''
        self.save()
        self.iface.openFeatureForm(self.layer, self.feature)


    def fill_tbl_scada(self, widget, table_name, filter_):
        ''' Fill scada tab of node
        Filter and fill table related with node_id '''
        self.set_model_to_table(widget, table_name, filter_)

