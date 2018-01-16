"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtCore import QTime, Qt, QPoint
from PyQt4.QtGui import QComboBox, QCheckBox, QDateEdit, QSpinBox, QTimeEdit
from PyQt4.QtGui import QDoubleValidator, QLineEdit, QTabWidget, QTableView, QAbstractItemView
from qgis.gui import QgsMapCanvasSnapper, QgsMapToolEmitPoint
from qgis.core import QgsFeatureRequest

import os
import sys
from datetime import datetime
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater

from ..ui.config_master import ConfigMaster                             # @UnresolvedImport
from ..ui.psector_management import Psector_management                  # @UnresolvedImport
from ..ui.plan_psector import Plan_psector                              # @UnresolvedImport
from ..ui.plan_estimate_result_new import EstimateResultNew             # @UnresolvedImport
from ..ui.plan_estimate_result_selector import EstimateResultSelector   # @UnresolvedImport
from ..ui.multirow_selector import Multirow_selector                    # @UnresolvedImport
from ..models.config_param_system import ConfigParamSystem              # @UnresolvedImport

from parent import ParentAction


class Master(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'master' """
        self.minor_version = "3.0"
        self.config_dict = {}
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)


    def set_project_type(self, project_type):
        self.project_type = project_type


    def master_new_psector(self, psector_id=None, enable_tabs=False):
        """ Button 45: New psector """

        # Create the dialog and signals
        self.dlg = Plan_psector()
        utils_giswater.setDialog(self.dlg)
        self.list_elemets = {}
        update = False  # if false: insert; if true: update
        tab_arc_node_other = self.dlg.findChild(QTabWidget, "tabWidget_2")
        tab_arc_node_other.setTabEnabled(0, enable_tabs)
        tab_arc_node_other.setTabEnabled(1, enable_tabs)
        tab_arc_node_other.setTabEnabled(2, enable_tabs)

        # tab General elements
        self.psector_id = self.dlg.findChild(QLineEdit, "psector_id")
        self.priority = self.dlg.findChild(QComboBox, "priority")
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".value_priority ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("priority", rows, False)

        scale = self.dlg.findChild(QLineEdit, "scale")
        scale.setValidator(QDoubleValidator())
        rotation = self.dlg.findChild(QLineEdit, "rotation")
        rotation.setValidator(QDoubleValidator())

        # tab Bugdet
        sum_expenses = self.dlg.findChild(QLineEdit, "sum_expenses")
        other = self.dlg.findChild(QLineEdit, "other")
        other.setValidator(QDoubleValidator())
        other_cost = self.dlg.findChild(QLineEdit, "other_cost")

        sum_oexpenses = self.dlg.findChild(QLineEdit, "sum_oexpenses")
        gexpenses = self.dlg.findChild(QLineEdit, "gexpenses")
        gexpenses.setValidator(QDoubleValidator())
        gexpenses_cost = self.dlg.findChild(QLineEdit, "gexpenses_cost")
        self.dlg.gexpenses_cost.textChanged.connect(partial(self.cal_percent, sum_oexpenses, gexpenses, gexpenses_cost))

        sum_gexpenses = self.dlg.findChild(QLineEdit, "sum_gexpenses")
        vat = self.dlg.findChild(QLineEdit, "vat")
        vat.setValidator(QDoubleValidator())
        vat_cost = self.dlg.findChild(QLineEdit, "vat_cost")
        self.dlg.gexpenses_cost.textChanged.connect(partial(self.cal_percent, sum_gexpenses, vat, vat_cost))

        sum_vexpenses = self.dlg.findChild(QLineEdit, "sum_vexpenses")

        self.dlg.other.textChanged.connect(partial(self.cal_percent, sum_expenses, other, other_cost))
        self.dlg.other_cost.textChanged.connect(partial(self.sum_total, sum_expenses, other_cost, sum_oexpenses))
        self.dlg.gexpenses.textChanged.connect(partial(self.cal_percent, sum_oexpenses, gexpenses, gexpenses_cost))
        self.dlg.gexpenses_cost.textChanged.connect(partial(self.sum_total, sum_oexpenses, gexpenses_cost, sum_gexpenses))
        self.dlg.vat.textChanged.connect(partial(self.cal_percent, sum_gexpenses, vat, vat_cost))
        self.dlg.vat_cost.textChanged.connect(partial(self.sum_total, sum_gexpenses, vat_cost, sum_vexpenses))

        # Tables
        # tab Elements
        tbl_arc_plan = self.dlg.findChild(QTableView, "tbl_arc_plan")
        tbl_arc_plan.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.fill_table(tbl_arc_plan, self.schema_name + ".plan_arc_x_psector")

        tbl_node_plan = self.dlg.findChild(QTableView, "tbl_node_plan")
        tbl_node_plan.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.fill_table(tbl_node_plan, self.schema_name + ".plan_node_x_psector")

        tbl_other_plan = self.dlg.findChild(QTableView, "tbl_other_plan")
        tbl_other_plan.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.fill_table(tbl_other_plan, self.schema_name + ".plan_other_x_psector")

        # tab Elements
        self.dlg.btn_add_arc_plan.pressed.connect(partial(self.snapping, "v_edit_arc", "plan_arc_x_psector", tbl_arc_plan, "arc"))
        self.dlg.btn_del_arc_plan.pressed.connect(partial(self.multi_rows_delete, tbl_arc_plan, "plan_arc_x_psector", "id"))

        self.dlg.btn_add_node_plan.pressed.connect(partial(self.snapping, "v_edit_node", "plan_node_x_psector", tbl_node_plan, "node"))
        self.dlg.btn_del_node_plan.pressed.connect(partial(self.multi_rows_delete, tbl_node_plan, "plan_node_x_psector", "id"))

        self.dlg.btn_del_other_plan.pressed.connect(partial(self.multi_rows_delete, tbl_other_plan, "plan_other_x_psector", "id"))

        ##
        # if a row is selected from mg_psector_mangement(button 46)
        # Si psector_id contiene "1" o "0" python lo toma como boolean, si es True, quiere decir que no contiene valor
        # y por lo tanto es uno nuevo. Convertimos ese valor en 0 ya que ningun id va a ser 0. de esta manera si psector_id
        # tiene un valor distinto de 0, es que el sector ya existe y queremos hacer un update.
        ##
        if isinstance(psector_id, bool):
            psector_id = 0

        if psector_id != 0:

            sql = "SELECT psector_id, name, priority, descript, text1, text2, observ, atlas_id, scale, rotation "
            sql += " FROM " + self.schema_name + ".plan_psector"
            sql += " WHERE psector_id = " + str(psector_id)
            row = self.dao.get_row(sql)
            if row is None:
                return

            self.psector_id.setText(str(row["psector_id"]))
            utils_giswater.setRow(row)
            utils_giswater.fillWidget("name")
            utils_giswater.fillWidget("descript")
            index = self.priority.findText(row["priority"], Qt.MatchFixedString)
            if index >= 0:
                self.priority.setCurrentIndex(index)
            utils_giswater.fillWidget("text1")
            utils_giswater.fillWidget("text2")
            utils_giswater.fillWidget("observ")
            utils_giswater.fillWidget("atlas_id")
            utils_giswater.fillWidget("scale")
            utils_giswater.fillWidget("rotation")

            # Fill tables tbl_arc_plan, tbl_node_plan, tbl_v_plan_other_x_psector with selected filter
            expr = " psector_id = " + str(psector_id)
            tbl_arc_plan.model().setFilter(expr)
            tbl_arc_plan.model().select()

            expr = " psector_id = " + str(psector_id)
            tbl_node_plan.model().setFilter(expr)
            tbl_node_plan.model().select()

            # Total other Prices
            total_other_price = 0
            sql = "SELECT SUM(budget) FROM " + self.schema_name + ".v_plan_other_x_psector"
            sql += " WHERE psector_id = '" + str(psector_id) + "'"
            row = self.dao.get_row(sql)
            if row is not None:
                if row[0]:
                    total_other_price = row[0]
            utils_giswater.setText("sum_v_plan_other_x_psector", total_other_price)

            # Total arcs
            total_arcs = 0
            sql = "SELECT SUM(budget) FROM " + self.schema_name + ".v_plan_arc_x_psector"
            sql += " WHERE psector_id = '" + str(psector_id) + "'"
            row = self.dao.get_row(sql)
            if row is not None:
                if row[0]:
                    total_arcs = row[0]
            utils_giswater.setText("sum_v_plan_x_arc_psector", total_arcs)

            # Total nodes
            total_nodes = 0
            sql = "SELECT SUM(budget) FROM " + self.schema_name + ".v_plan_node_x_psector"
            sql += " WHERE psector_id = '" + str(psector_id) + "'"
            row = self.dao.get_row(sql)
            if row is not None:
                if row[0]:
                    total_nodes = row[0]
            utils_giswater.setText("sum_v_plan_x_node_psector", total_nodes)

            sum_expenses = total_other_price + total_arcs + total_nodes
            utils_giswater.setText("sum_expenses", sum_expenses)
            update = True

        # Buttons
        self.dlg.btn_accept.pressed.connect(partial(self.insert_or_update_new_psector, update, 'plan_psector'))
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)
        self.dlg.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg.open()


    def master_psector_mangement(self):
        """ Button 46: Psector management """

        # Create the dialog and signals
        self.dlg = Psector_management()
        utils_giswater.setDialog(self.dlg)
        table_name = "plan_psector"
        column_id = "psector_id"

        # Tables
        self.tbl_psm = self.dlg.findChild(QTableView, "tbl_psm")
        self.tbl_psm.setSelectionBehavior(QAbstractItemView.SelectRows)  # Select by rows instead of individual cells

        # Set signals
        self.dlg.btn_accept.pressed.connect(self.charge_psector)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)
        self.dlg.btn_save.pressed.connect(partial(self.save_table, self.tbl_psm, "plan_psector", column_id))
        self.dlg.btn_delete.clicked.connect(partial(self.multi_rows_delete, self.tbl_psm, table_name, column_id))
        self.dlg.btn_current_psector.clicked.connect(self.update_current_psector)
        self.dlg.txt_name.textChanged.connect(partial(self.filter_by_text, self.tbl_psm, self.dlg.txt_name, "plan_psector"))

        self.fill_table_psector(self.tbl_psm, "plan_psector", column_id)
        self.dlg.exec_()


    def update_current_psector(self):
      
        selected_list = self.tbl_psm.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        row = selected_list[0].row()
        psector_id = self.tbl_psm.model().record(row).value("psector_id")
        sql = "SELECT * FROM " + self.schema_name + ".selector_psector WHERE cur_user = current_user"
        rows = self.controller.get_rows(sql)
        if rows:
            sql = "UPDATE " + self.schema_name + ".selector_psector SET psector_id="
            sql += "'" + str(psector_id) + "' WHERE cur_user = current_user"
        else:
            sql = 'INSERT INTO ' + self.schema_name + '.selector_psector (psector_id, cur_user)'
            sql += " VALUES ('" + str(psector_id) + "', current_user)"

        aux_widget = QLineEdit()
        aux_widget.setText(str(psector_id))
        self.insert_or_update_config_param_curuser(aux_widget, "psector_vdefault", "config_param_user")
        self.controller.execute_sql(sql)
        message = "Values has been updated"
        self.controller.show_info(message)

        self.fill_table(self.tbl_psm, self.schema_name + ".plan_psector")

        self.dlg.exec_()


    def master_config_master(self):
        """ Button 99: Open a dialog showing data from table 'config_param_system' """

        # Create the dialog and signals
        self.dlg = ConfigMaster()
        utils_giswater.setDialog(self.dlg)
        self.load_settings(self.dlg)
        self.dlg.btn_accept.pressed.connect(self.master_config_master_accept)
        self.dlg.btn_cancel.pressed.connect(partial(self.close_dialog, self.dlg))
        self.dlg.rejected.connect(partial(self.save_settings, self.dlg))
        # Get records from tables 'config' and 'config_param_system' and fill corresponding widgets
        self.select_config("config")
        self.select_config_param_system("config_param_system") 

        if self.project_type == 'ws':
            self.dlg.tab_topology.removeTab(1)

        sql = "SELECT name FROM" + self.schema_name + ".plan_psector ORDER BY name"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("psector_vdefault", rows)
        sql = "SELECT scale FROM" + self.schema_name + ".plan_psector ORDER BY scale"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("psector_scale_vdefault", rows)
        sql = "SELECT rotation FROM" + self.schema_name + ".plan_psector ORDER BY rotation"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("psector_rotation_vdefault", rows)
        sql = "SELECT gexpenses FROM" + self.schema_name + ".plan_psector ORDER BY gexpenses"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("psector_gexpenses_vdefault", rows)
        sql = "SELECT vat FROM" + self.schema_name + ".plan_psector ORDER BY vat"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("psector_vat_vdefault", rows)
        sql = "SELECT other FROM" + self.schema_name + ".plan_psector ORDER BY other"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("psector_other_vdefault", rows)

        sql = "SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
        sql += " WHERE parameter = 'psector_vdefault'"
        row = self.dao.get_row(sql)
        if row:
            utils_giswater.setChecked("chk_psector_enabled", True)
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
        sql = "SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
        sql += " WHERE parameter = 'psector_scale_vdefault'"
        row = self.dao.get_row(sql)
        if row:
            utils_giswater.setChecked("chk_psector_scale_vdefault", True)
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
        sql = "SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
        sql += " WHERE parameter = 'psector_rotation_vdefault'"
        row = self.dao.get_row(sql)
        if row:
            utils_giswater.setChecked("chk_psector_rotation_vdefault", True)
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
        sql = "SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
        sql += " WHERE parameter = 'psector_gexpenses_vdefault'"
        row = self.dao.get_row(sql)
        if row:
            utils_giswater.setChecked("chk_psector_gexpenses_vdefault", True)
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
        sql = "SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
        sql += " WHERE parameter = 'psector_vat_vdefault'"
        row = self.dao.get_row(sql)
        if row:
            utils_giswater.setChecked("chk_psector_vat_vdefault", True)
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
        sql = "SELECT parameter, value FROM " + self.schema_name + ".config_param_user"
        sql += " WHERE parameter = 'psector_other_vdefault'"
        row = self.dao.get_row(sql)
        if row:
            utils_giswater.setChecked("chk_psector_other_vdefault", True)
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
            
        self.dlg.exec_()


    def select_config_param_system(self, tablename): 
        """ Get data from table 'config_param_system' and fill widgets according to the name of the field 'parameter' """
        
        self.config_dict = {}
        sql = "SELECT parameter, value, context "
        sql += " FROM " + self.schema_name + "." + tablename + " ORDER BY parameter"     
        rows = self.controller.get_rows(sql)
        for row in rows:
            config = ConfigParamSystem(row['parameter'], row['value'], row['context'])
            self.config_dict[row['parameter']] = config
        utils_giswater.fillWidgets(rows)       
        

    def select_config(self, tablename):
        """ Get data from table 'config' and fill widgets according to the name of the columns """

        sql = "SELECT * FROM " + self.schema_name + "." + tablename
        row = self.dao.get_row(sql)
        if not row:
            self.controller.show_warning("Any data found in table " + tablename)
            return None
        
        # Iterate over all columns and populate its corresponding widget
        columns = []
        for i in range(0, len(row)):

            column_name = self.dao.get_column_name(i)
            widget_type = utils_giswater.getWidgetType(column_name)
            if widget_type is QCheckBox:
                utils_giswater.setChecked(column_name, row[column_name])
            elif widget_type is QDateEdit:
                utils_giswater.setCalendarDate(column_name, datetime.strptime(row[column_name], '%Y-%m-%d'))
            elif widget_type is QTimeEdit:
                timeparts = str(row[column_name]).split(':')
                if len(timeparts) < 3:
                    timeparts.append("0")
                days = int(timeparts[0]) / 24
                hours = int(timeparts[0]) % 24
                minuts = int(timeparts[1])
                seconds = int(timeparts[2])
                time = QTime(hours, minuts, seconds)
                utils_giswater.setTimeEdit(column_name, time)
                utils_giswater.setText(column_name + "_day", days)
            else:
                utils_giswater.setWidgetText(column_name, row[column_name])
            columns.append(column_name)

        return columns


    def master_config_master_accept(self):
        """ Button 99: Slot for 'btn_accept' """
        
        if utils_giswater.isChecked("chk_psector_enabled"):
            self.insert_or_update_config_param_curuser(self.dlg.psector_vdefault, "psector_vdefault", "config_param_user")
        else:
            self.delete_row("psector_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_psector_scale_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.psector_scale_vdefault, "psector_scale_vdefault", "config_param_user")
        else:
            self.delete_row("psector_scale_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_psector_rotation_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.psector_rotation_vdefault, "psector_rotation_vdefault", "config_param_user")
        else:
            self.delete_row("psector_rotation_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_psector_gexpenses_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.psector_gexpenses_vdefault, "psector_gexpenses_vdefault", "config_param_user")
        else:
            self.delete_row("psector_gexpenses_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_psector_vat_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.psector_vat_vdefault, "psector_vat_vdefault", "config_param_user")
        else:
            self.delete_row("psector_vat_vdefault", "config_param_user")
        if utils_giswater.isChecked("chk_psector_other_vdefault"):
            self.insert_or_update_config_param_curuser(self.dlg.psector_other_vdefault, "psector_other_vdefault", "config_param_user")
        else:
            self.delete_row("psector_other_vdefault", "config_param_user")
            
        # Update tables 'confog' and 'config_param_system'            
        self.update_config("config", self.dlg)
        self.update_config_param_system("config_param_system")
        
        message = "Values has been updated"
        self.controller.show_info(message)

        self.close_dialog(self.dlg)


    def update_config_param_system(self, tablename):
        """ Update table @tablename """
        
        # Get all parameters from dictionary object
        for config in self.config_dict.itervalues():
            value = utils_giswater.getWidgetText(str(config.parameter))      
            if value is not None:           
                value = value.replace('null', '')
                sql = "UPDATE " + self.schema_name + "." + tablename
                sql += " SET value = '" + str(value) + "'"
                sql += " WHERE parameter = '" + str(config.parameter) + "';"            
                self.controller.execute_sql(sql)      
                
                
    def update_config(self, tablename, dialog):
        """ Update table @tablename from values get from @dialog """

        sql = "SELECT * FROM " + self.schema_name + "." + tablename
        row = self.dao.get_row(sql)
        columns = []
        for i in range(0, len(row)):
            column_name = self.dao.get_column_name(i)
            if column_name != 'id': 
                columns.append(column_name)

        if columns is None:
            return
        
        sql = "UPDATE " + self.schema_name + "." + tablename + " SET "
        for column_name in columns:         
            widget_type = utils_giswater.getWidgetType(column_name)
            if widget_type is QCheckBox:
                value = utils_giswater.isChecked(column_name)
            elif widget_type is QDateEdit:
                date = dialog.findChild(QDateEdit, str(column_name))
                value = date.dateTime().toString('yyyy-MM-dd')
            elif widget_type is QTimeEdit:
                aux = 0
                widget_day = str(column_name) + "_day"
                day = utils_giswater.getText(widget_day)
                if day != "null":
                    aux = int(day) * 24
                time = dialog.findChild(QTimeEdit, str(column_name))
                timeparts = time.dateTime().toString('HH:mm:ss').split(':')
                h = int(timeparts[0]) + int(aux)
                aux = str(h) + ":" + str(timeparts[1]) + ":00"
                value = aux
            elif widget_type is QSpinBox:
                x = dialog.findChild(QSpinBox, str(column_name))
                value = x.value()
            else:
                value = utils_giswater.getWidgetText(column_name)
              
            if value is not None:  
                if value == 'null':
                    sql += column_name + " = null, "
                else:
                    if type(value) is not bool and widget_type is not QSpinBox:
                        value = value.replace(",", ".")
                    sql += column_name + " = '" + str(value) + "', "

        sql = sql[:- 2]          
        self.controller.execute_sql(sql)
                        

    def insert_or_update_config_param_curuser(self, widget, parameter, tablename):
        """ Insert or update values in tables with current_user control """

        sql = 'SELECT * FROM ' + self.schema_name + '.' + tablename 
        sql += ' WHERE "cur_user" = current_user'
        rows = self.controller.get_rows(sql)
        exist_param = False
        if type(widget) != QDateEdit:
            if utils_giswater.getWidgetText(widget) != "":
                for row in rows:
                    if row[1] == parameter:
                        exist_param = True
                if exist_param:
                    sql = "UPDATE " + self.schema_name + "." + tablename + " SET value="
                    if widget.objectName() != 'state_vdefault':
                        sql += "'" + utils_giswater.getWidgetText(widget) + "' WHERE parameter='" + parameter + "'"
                    else:
                        sql += "(SELECT id FROM " + self.schema_name + ".value_state WHERE name ='" + utils_giswater.getWidgetText(widget) + "')"
                        sql += " WHERE parameter = 'state_vdefault' "
                else:
                    sql = 'INSERT INTO ' + self.schema_name + '.' + tablename + '(parameter, value, cur_user)'
                    if widget.objectName() != 'state_vdefault':
                        sql += " VALUES ('" + parameter + "', '" + utils_giswater.getWidgetText(widget) + "', current_user)"
                    else:
                        sql += " VALUES ('" + parameter + "', (SELECT id FROM " + self.schema_name + ".value_state WHERE name ='" + utils_giswater.getWidgetText(widget) + "'), current_user)"
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
        sql += ' WHERE "cur_user" = current_user and parameter = ' + "'" + parameter + "'"
        self.controller.execute_sql(sql)


    def filter_by_text(self, table, widget_txt, tablename):

        result_select = utils_giswater.getWidgetText(widget_txt)
        if result_select != 'null':
            expr = " name LIKE '%" + result_select + "%'"
            # Refresh model with selected filter
            table.model().setFilter(expr)
            table.model().select()
        else:
            self.fill_table(self.tbl_psm, self.schema_name + "." + tablename)


    def charge_psector(self):

        selected_list = self.tbl_psm.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        row = selected_list[0].row()
        psector_id = self.tbl_psm.model().record(row).value("psector_id")
        self.close_dialog()
        self.master_new_psector(psector_id, True)


    def snapping(self, layername, tablename, table_view, elem_type):
        # Create the appropriate map tool and connect the gotPoint() signal
        map_canvas = self.iface.mapCanvas()
        self.emit_point = QgsMapToolEmitPoint(map_canvas)
        map_canvas.setMapTool(self.emit_point)
        utils_giswater.setWidgetText("btn_add_arc_plan", "Editing")
        utils_giswater.setWidgetText("btn_add_node_plan", "Editing")
        self.emit_point.canvasClicked.connect(partial(self.click_button_add, layername, tablename, table_view, elem_type))


    def click_button_add(self, layername, tablename, table_view, elem_type, point, button):
        """
        :param layer_view: it is the view we are using
        :param tablename:  Is the name of the table that we will use to make the SELECT and INSERT
        :param table_view: it's QTableView we are using, need ir for upgrade his own view
        :param elem_type: Used to buy the object that we "click" with the type of object we want to add or delete
        :param point: param inherited from signal canvasClicked
        :param button: param inherited from signal canvasClicked
        """

        if button == Qt.LeftButton:

            layernames_node = ["v_edit_node"]
            layernames_arc = ["v_edit_arc"]
            canvas = self.iface.mapCanvas()
            snapper = QgsMapCanvasSnapper(canvas)
            map_point = canvas.getCoordinateTransform().transform(point)
            x = map_point.x()
            y = map_point.y()
            event_point = QPoint(x, y)

            # Snapping
            (retval, result) = snapper.snapToBackgroundLayers(event_point)  # @UnusedVariable

            # That's the snapped point
            if result:
                # Check feature
                for snapped_feat in result:
                    element_type = snapped_feat.layer.name()
                    feat_type = None
                    if element_type in layernames_node:
                        feat_type = 'node'
                    elif element_type in layernames_arc:
                        feat_type = 'arc'

                    if feat_type:
                        # Get the point. Leave selection
                        feature = next(snapped_feat.layer.getFeatures(QgsFeatureRequest().setFilterFid(snapped_feat.snappedAtGeometry)))
                        element_id = feature.attribute(feat_type + '_id')
                        snapped_feat.layer.select([snapped_feat.snappedAtGeometry])
                        # Get depth of feature
                        if feat_type == elem_type:
                            sql = ("SELECT * FROM " + self.schema_name + "." + tablename + ""
                                   " WHERE " + feat_type+"_id = '" + element_id+"' AND psector_id = '" + self.psector_id.text() + "'")
                            row = self.controller.get_row(sql)
                            if not row:
                                self.list_elemets[element_id] = feat_type
                            else:
                                message = "This id already exists"
                                self.controller.show_info(message)
                        else:
                            message = self.tr("You are trying to introduce")+" "+feat_type+" "+self.tr("in a")+" "+elem_type
                            self.controller.show_info(message)

        elif button == Qt.RightButton:
            for element_id, feat_type in self.list_elemets.items():
                sql = ("INSERT INTO " + self.schema_name + "." + tablename + "(" + feat_type + "_id, psector_id)"
                       " VALUES (" + element_id + ", " + self.psector_id.text() + ")")
                self.controller.execute_sql(sql)
            table_view.model().select()
            self.emit_point.canvasClicked.disconnect()
            self.list_elemets.clear()
            self.dlg.btn_add_arc_plan.setText('Add')
            self.dlg.btn_add_node_plan.setText('Add')


    def insert_or_update_new_psector(self, update, tablename):

        sql = "SELECT * FROM " + self.schema_name + "." + tablename
        row = self.controller.get_row(sql)
        columns = []
        for i in range(0, len(row)):
            column_name = self.dao.get_column_name(i)
            columns.append(column_name)

        if update:
            if columns is not None:
                sql = "UPDATE " + self.schema_name + "." + tablename + " SET "
                for column_name in columns:
                    if column_name != 'psector_id':
                        widget_type = utils_giswater.getWidgetType(column_name)
                        if widget_type is QCheckBox:
                            value = utils_giswater.isChecked(column_name)
                        elif widget_type is QDateEdit:
                            date = self.dlg.findChild(QDateEdit, str(column_name))
                            value = date.dateTime().toString('yyyy-MM-dd HH:mm:ss')
                        else:
                            value = utils_giswater.getWidgetText(column_name)
                        if value is None or value == 'null':
                            sql += column_name + " = null, "
                        else:
                            if type(value) is not bool:
                                value = value.replace(",", ".")
                            sql += column_name + " = '" + str(value) + "', "

                sql = sql[:len(sql) - 2]
                sql += " WHERE psector_id = '" + self.psector_id.text() + "'"

        else:
            values = "VALUES("
            if columns is not None:
                sql = "INSERT INTO " + self.schema_name + "." + tablename+" ("
                for column_name in columns:
                    if column_name != 'psector_id':
                        widget_type = utils_giswater.getWidgetType(column_name)
                        if widget_type is not None:
                            if widget_type is QCheckBox:
                                values += utils_giswater.isChecked(column_name)+", "
                            elif widget_type is QDateEdit:
                                date = self.dlg.findChild(QDateEdit, str(column_name))
                                values += date.dateTime().toString('yyyy-MM-dd HH:mm:ss')+", "
                            else:
                                value = utils_giswater.getWidgetText(column_name)
                            if value is None or value == 'null':
                                sql += column_name + ", "
                                values += "null, "
                            else:
                                values += "'" + value + "',"
                                sql += column_name + ", "
                sql = sql[:len(sql) - 2]+") "
                values = values[:len(values)-2] + ")"
                sql += values
                
        self.controller.execute_sql(sql)
        
        self.close_dialog()


    def multi_rows_delete(self, widget, table_name, column_id):
        """ Delete selected elements of the table
        :param QTableView widget: origin
        :param table_name: table origin
        :param column_id: Refers to the id of the source table
        """

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        inf_text = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = widget.model().record(row).value(str(column_id))
            inf_text += str(id_)+", "
            list_id = list_id+"'"+str(id_)+"', "
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        answer = self.controller.ask_question("Are you sure you want to delete these records?", "Delete records", inf_text)

        if answer:
            sql = "DELETE FROM "+self.schema_name+"."+table_name
            sql += " WHERE "+column_id+" IN ("+list_id+")"
            self.controller.execute_sql(sql)
            widget.model().select()


    # TODO: Enhance using utils_giswater
    def cal_percent(self, widged_total, widged_percent, widget_result):
        text = str((float(widged_total.text()) * float(widged_percent.text())/100))
        widget_result.setText(text)


    def sum_total(self, widget_total, widged_percent, widget_result):
        text = str((float(widget_total.text()) + float(widged_percent.text())))
        widget_result.setText(text)


    def master_psector_selector(self):
        """ Button 47: Psector selector """

        # Create the dialog and signals
        self.dlg = Multirow_selector()
        utils_giswater.setDialog(self.dlg)
        self.dlg.btn_ok.pressed.connect(self.close_dialog)
        self.dlg.setWindowTitle("Psector")
        tableleft = "plan_psector"
        tableright = "selector_psector"
        field_id_left = "psector_id"
        field_id_right = "psector_id"
        self.multi_row_selector(self.dlg, tableleft, tableright, field_id_left, field_id_right)
        self.dlg.exec_()
        
        
    def master_estimate_result_new(self):
        """ Button 38: New estimate result """

        # Create dialog 
        self.dlg = EstimateResultNew()
        utils_giswater.setDialog(self.dlg)
        
        # Set signals
        self.dlg.btn_calculate.clicked.connect(self.master_estimate_result_new_calculate)
        self.dlg.btn_close.clicked.connect(self.close_dialog)
        self.dlg.prices_coefficient.setValidator(QDoubleValidator())

        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'estimate_result_new')
        self.dlg.exec_()


    def master_estimate_result_new_calculate(self):
        """ Execute function 'gw_fct_plan_estimate_result' """

        # Get values from form
        result_name = utils_giswater.getWidgetText("result_name")
        coefficient = utils_giswater.getWidgetText("prices_coefficient")
        observ = utils_giswater.getWidgetText("observ")
        if result_name == 'null':
            message = "Please, introduce a result name"
            self.controller.show_warning(message)  
            return          
        if coefficient == 'null':
            message = "Please, introduce a coefficient value"
            self.controller.show_warning(message)  
            return          
        
        # Execute function 'gw_fct_plan_estimate_result'
        sql = "SELECT " + self.schema_name + ".gw_fct_plan_estimate_result('" + result_name + "', " + coefficient + ", '" + observ + "')"
        status = self.controller.execute_sql(sql)
        if status:
            message = "Values has been updated"
            self.controller.show_info(message)
        
        # Refresh canvas and close dialog
        self.iface.mapCanvas().refreshAllLayers()
        self.close_dialog()      


    def master_estimate_result_selector(self):
        """ Button 49: Estimate result selector """

        # Create dialog 
        self.dlg = EstimateResultSelector()
        utils_giswater.setDialog(self.dlg)
        
        # Set signals
        self.dlg.btn_accept.clicked.connect(self.master_estimate_result_selector_accept)
        self.dlg.btn_cancel.clicked.connect(self.close_dialog)

        # Fill combo box
        sql = "SELECT result_id FROM "+self.schema_name+".plan_result_cat "
        sql += " WHERE cur_user = current_user ORDER BY result_id"
        rows = self.controller.get_rows(sql)
        if not rows:
            return
        
        utils_giswater.fillComboBox("rpt_selector_result_id", rows, False)
        
        # Get selected value from table 'plan_selector_result'
        sql = "SELECT result_id FROM "+self.schema_name+".plan_selector_result"
        sql += " WHERE cur_user = current_user"   
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setSelectedItem("rpt_selector_result_id", str(row[0]))
        elif row is None and self.controller.last_error:   
            self.controller.log_info(sql)        
            return                
            
        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'estimate_result_selector')
        self.dlg.exec_()


    def master_estimate_result_selector_accept(self):
        """ Update value of table 'plan_selector_result' """
    
        # Get selected value and upsert the table
        result_id = utils_giswater.getWidgetText("rpt_selector_result_id")
        fields = ['result_id']
        values = [result_id]
        status = self.controller.execute_upsert('plan_selector_result', 'cur_user', 'current_user', fields, values)
        if status:
            message = "Values has been updated"
            self.controller.show_info(message)        
        
        # Refresh canvas
        self.iface.mapCanvas().refreshAllLayers()
