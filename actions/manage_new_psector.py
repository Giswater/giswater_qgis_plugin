"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtCore import Qt

import os
import sys
import utils_giswater
import operator
from functools import partial

from PyQt4.QtGui import QAbstractItemView, QDoubleValidator, QTableView
from PyQt4.QtGui import QCheckBox, QLineEdit, QComboBox, QDateEdit
from ui.plan_psector import Plan_psector
from actions.parent_manage import ParentManage

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)


class ManageNewPsector(ParentManage):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control 'New Psector' of toolbar 'master' """
        ParentManage.__init__(self, iface, settings, controller, plugin_dir)

    def master_new_psector(self, psector_id=None):
        """ Button 45: New psector """
        # Create the dialog and signals
        self.dlg = Plan_psector()
        utils_giswater.setDialog(self.dlg)

        # Capture the current layer to return it at the end of the operation
        cur_active_layer = self.iface.activeLayer()
        self.set_selectionbehavior(self.dlg)
        self.project_type = self.controller.get_project_type()

        # Get layers of every geom_type
        self.list_elemets = {}
        self.reset_lists()
        self.reset_layers()
        self.layers['arc'] = self.controller.get_group_layers('arc')
        self.layers['node'] = self.controller.get_group_layers('node')
        update = False  # if false: insert; if true: update

        # Remove all previous selections
        self.remove_selection(True)

        # Set icons
        self.set_icon(self.dlg.btn_insert, "111")
        self.set_icon(self.dlg.btn_delete, "112")
        self.set_icon(self.dlg.btn_snapping, "137")
        table_object = "psector"

        # tab General elements
        self.psector_id = self.dlg.findChild(QLineEdit, "psector_id")
        self.cbx_expl_id = self.dlg.findChild(QComboBox, "expl_id")
        self.cbx_sector_id = self.dlg.findChild(QComboBox, "sector_id")
        self.populate_combos(self.cbx_expl_id, 'name', 'expl_id', 'exploitation')
        self.populate_combos(self.cbx_sector_id, 'name', 'sector_id', 'sector')
        self.priority = self.dlg.findChild(QComboBox, "priority")
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".plan_value_ps_priority ORDER BY id"
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
        tbl_arc_plan = self.dlg.findChild(QTableView, "tbl_psector_x_arc")
        tbl_arc_plan.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.fill_table(tbl_arc_plan, self.schema_name + ".plan_arc_x_psector")

        tbl_node_plan = self.dlg.findChild(QTableView, "tbl_psector_x_node")
        tbl_node_plan.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.fill_table(tbl_node_plan, self.schema_name + ".plan_node_x_psector")

        tbl_other_plan = self.dlg.findChild(QTableView, "tbl_psector_x_other")
        tbl_other_plan.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.fill_table(tbl_other_plan, self.schema_name + ".plan_other_x_psector")

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


        # Set signals
        self.dlg.btn_accept.pressed.connect(partial(self.insert_or_update_new_psector, update, 'plan_psector'))
        self.dlg.btn_cancel.pressed.connect(partial(self.close_psector, cur_active_layer))
        self.dlg.rejected.connect(partial(self.close_psector, cur_active_layer))

        self.dlg.btn_insert.pressed.connect(partial(self.insert_feature, table_object))
        self.dlg.btn_delete.pressed.connect(partial(self.delete_records, table_object))
        self.dlg.btn_snapping.pressed.connect(partial(self.selection_init, table_object))

        self.dlg.tab_feature.currentChanged.connect(partial(self.tab_feature_changed, table_object))

        # Adding auto-completion to a QLineEdit for default feature
        self.geom_type = "arc"
        viewname = "v_edit_" + self.geom_type
        self.set_completer_feature_id(self.geom_type, viewname)

        # Set default tab 'arc'
        self.dlg.tab_feature.setCurrentIndex(0)
        self.geom_type = "arc"
        self.tab_feature_changed(table_object)
        self.dlg.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg.open()


    def populate_combos(self, combo, field, id, table_name):
        sql = ("SELECT DISTINCT("+id+"), "+field+" FROM "+self.schema_name+"."+table_name+" ORDER BY "+field+"")
        rows = self.dao.get_rows(sql)
        combo.blockSignals(True)
        combo.clear()
        records_sorted = sorted(rows, key=operator.itemgetter(1))
        for record in records_sorted:
            combo.addItem(str(record[1]), record)
        combo.blockSignals(False)
        self.controller.log_info(str(utils_giswater.getWidgetText(combo)))
        # self.controller.log_info(str(rows))
        # utils_giswater.fillComboBox("expl_id", rows, False)
        # sql = ("SELECT DISTINCT(name), sector_id FROM "+self.schema_name+".sector ORDER BY name")
        # rows = self.dao.get_rows(sql)
        # utils_giswater.fillComboBox("sector_id", rows, False)


    # TODO: Enhance using utils_giswater
    def cal_percent(self, widget_total, widget_percent, widget_result):
        text = str((float(widget_total.text()) * float(widget_percent.text())/100))
        widget_result.setText(text)


    def sum_total(self, widget_total, widged_percent, widget_result):
        text = str((float(widget_total.text()) + float(widged_percent.text())))
        widget_result.setText(text)


    def close_psector(self, cur_active_layer=None):
        """ Close dialog and disconnect snapping """

        if cur_active_layer:
            self.iface.setActiveLayer(cur_active_layer)
        self.remove_selection(True)
        self.reset_model_psector("arc")
        self.reset_model_psector("node")
        self.reset_model_psector("other")
        self.close_dialog()
        self.hide_generic_layers()
        self.disconnect_snapping()
        self.disconnect_signal_selection_changed()

    def reset_model_psector(self, geom_type):
        """ Reset model of the widget """
        table_relation = "" + geom_type + "_plan"
        widget_name = "tbl_" + table_relation
        widget = utils_giswater.getWidget(widget_name)
        if widget:
            widget.setModel(None)

    def insert_or_update_new_psector(self, update, tablename):
        value = '*'
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
                sql = "INSERT INTO " + self.schema_name + "." + tablename + " ("
                self.controller.log_info(str(columns))
                for column_name in columns:
                    self.controller.log_info(str(column_name))
                    self.controller.log_info(str(values))
                    if column_name != 'psector_id':
                        widget_type = utils_giswater.getWidgetType(column_name)
                        if widget_type is not None:
                            if widget_type is QCheckBox:
                                values += utils_giswater.isChecked(column_name) + ", "
                                value = '*'
                            elif widget_type is QDateEdit:
                                date = self.dlg.findChild(QDateEdit, str(column_name))
                                values += date.dateTime().toString('yyyy-MM-dd HH:mm:ss') + ", "
                                value = '*'
                            elif (widget_type is QComboBox) and (column_name == 'expl_id' or column_name == 'sector_id'):
                                combo = utils_giswater.getWidget(column_name)
                                elem = combo.itemData(combo.currentIndex())
                                values += str(elem[0]) + ", "
                                value = '*'
                            else:
                                value = utils_giswater.getWidgetText(column_name)
                            if value is None or value == 'null':
                                sql += column_name + ", "
                                values += "null, "
                            elif value != '*':
                                values += "'" + value + "',"
                                sql += column_name + ", "

                    self.controller.log_info(str(values))
                sql = sql[:len(sql) - 2] + ") "
                values = values[:len(values) - 2] + ")"
                sql += values
        self.controller.log_info(str(sql))
        self.controller.execute_sql(sql)

        self.close_dialog()
            # update = False  # if false: insert; if true: update
            # tab_feature = self.dlg.findChild(QTabWidget, "tab_feature")
            # # tab_feature.setTabEnabled(0, enable_tabs)
            # # tab_feature.setTabEnabled(1, enable_tabs)
            # # tab_feature.setTabEnabled(2, enable_tabs)
            #
            # # tab General elements
            # self.psector_id = self.dlg.findChild(QLineEdit, "psector_id")
            # self.priority = self.dlg.findChild(QComboBox, "priority")
            # sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".value_priority ORDER BY id"
            # rows = self.dao.get_rows(sql)
            # utils_giswater.fillComboBox("priority", rows, False)
            #
            # scale = self.dlg.findChild(QLineEdit, "scale")
            # scale.setValidator(QDoubleValidator())
            # rotation = self.dlg.findChild(QLineEdit, "rotation")
            # rotation.setValidator(QDoubleValidator())
            #
            # # tab Bugdet
            # sum_expenses = self.dlg.findChild(QLineEdit, "sum_expenses")
            # other = self.dlg.findChild(QLineEdit, "other")
            # other.setValidator(QDoubleValidator())
            # other_cost = self.dlg.findChild(QLineEdit, "other_cost")
            #
            # sum_oexpenses = self.dlg.findChild(QLineEdit, "sum_oexpenses")
            # gexpenses = self.dlg.findChild(QLineEdit, "gexpenses")
            # gexpenses.setValidator(QDoubleValidator())
            # gexpenses_cost = self.dlg.findChild(QLineEdit, "gexpenses_cost")
            # self.dlg.gexpenses_cost.textChanged.connect(partial(self.cal_percent, sum_oexpenses, gexpenses, gexpenses_cost))
            #
            # sum_gexpenses = self.dlg.findChild(QLineEdit, "sum_gexpenses")
            # vat = self.dlg.findChild(QLineEdit, "vat")
            # vat.setValidator(QDoubleValidator())
            # vat_cost = self.dlg.findChild(QLineEdit, "vat_cost")
            # self.dlg.gexpenses_cost.textChanged.connect(partial(self.cal_percent, sum_gexpenses, vat, vat_cost))
            #
            # sum_vexpenses = self.dlg.findChild(QLineEdit, "sum_vexpenses")
            #
            # self.dlg.other.textChanged.connect(partial(self.cal_percent, sum_expenses, other, other_cost))
            # self.dlg.other_cost.textChanged.connect(partial(self.sum_total, sum_expenses, other_cost, sum_oexpenses))
            # self.dlg.gexpenses.textChanged.connect(partial(self.cal_percent, sum_oexpenses, gexpenses, gexpenses_cost))
            # self.dlg.gexpenses_cost.textChanged.connect(partial(self.sum_total, sum_oexpenses, gexpenses_cost, sum_gexpenses))
            # self.dlg.vat.textChanged.connect(partial(self.cal_percent, sum_gexpenses, vat, vat_cost))
            # self.dlg.vat_cost.textChanged.connect(partial(self.sum_total, sum_gexpenses, vat_cost, sum_vexpenses))
            #
            # # Tables
            # # tab Elements
            # tbl_arc_plan = self.dlg.findChild(QTableView, "tbl_arc_plan")
            # tbl_arc_plan.setSelectionBehavior(QAbstractItemView.SelectRows)
            # self.fill_table(tbl_arc_plan, self.schema_name + ".plan_arc_x_psector")
            #
            # tbl_node_plan = self.dlg.findChild(QTableView, "tbl_node_plan")
            # tbl_node_plan.setSelectionBehavior(QAbstractItemView.SelectRows)
            # self.fill_table(tbl_node_plan, self.schema_name + ".plan_node_x_psector")
            #
            # tbl_other_plan = self.dlg.findChild(QTableView, "tbl_other_plan")
            # tbl_other_plan.setSelectionBehavior(QAbstractItemView.SelectRows)
            # self.fill_table(tbl_other_plan, self.schema_name + ".plan_other_x_psector")
            #
            # # tab Elements
            # self.dlg.tab_feature.currentChanged.connect(partial(self.tab_feature_changed))
            # self.geom_type = "arc"
            # table_name = "plan_" + self.geom_type + "_x_psector"
            # qtable_plan = "tbl_" + self.geom_type + "_plan"
            # view ="v_edit_" + self.geom_type
            #
            # #self.dlg.btn_snapping.pressed.connect(partial(self.selection_init, view, table_name, qtable_plan, geom_type))
            # self.dlg.btn_snapping.pressed.connect(partial(self.selection_init, qtable_plan))
            #
            # # self.dlg.btn_add_arc_plan.pressed.connect(partial(self.snapping, "v_edit_arc", "plan_arc_x_psector", tbl_arc_plan, "arc"))
            # # self.dlg.btn_del_arc_plan.pressed.connect(partial(self.multi_rows_delete, tbl_arc_plan, "plan_arc_x_psector", "id"))
            # #
            # # self.dlg.btn_add_node_plan.pressed.connect(partial(self.snapping, "v_edit_node", "plan_node_x_psector", tbl_node_plan, "node"))
            # # self.dlg.btn_del_node_plan.pressed.connect(partial(self.multi_rows_delete, tbl_node_plan, "plan_node_x_psector", "id"))
            # #
            # # self.dlg.btn_del_other_plan.pressed.connect(partial(self.multi_rows_delete, tbl_other_plan, "plan_other_x_psector", "id"))
            #
            # ##
            # # if a row is selected from mg_psector_mangement(button 46)
            # # Si psector_id contiene "1" o "0" python lo toma como boolean, si es True, quiere decir que no contiene valor
            # # y por lo tanto es uno nuevo. Convertimos ese valor en 0 ya que ningun id va a ser 0. de esta manera si psector_id
            # # tiene un valor distinto de 0, es que el sector ya existe y queremos hacer un update.
            # ##
            # if isinstance(psector_id, bool):
            #     psector_id = 0
            #
            # if psector_id != 0:
            #
            #     sql = "SELECT psector_id, name, priority, descript, text1, text2, observ, atlas_id, scale, rotation "
            #     sql += " FROM " + self.schema_name + ".plan_psector"
            #     sql += " WHERE psector_id = " + str(psector_id)
            #     row = self.dao.get_row(sql)
            #     if row is None:
            #         return
            #
            #     self.psector_id.setText(str(row["psector_id"]))
            #     utils_giswater.setRow(row)
            #     utils_giswater.fillWidget("name")
            #     utils_giswater.fillWidget("descript")
            #     index = self.priority.findText(row["priority"], Qt.MatchFixedString)
            #     if index >= 0:
            #         self.priority.setCurrentIndex(index)
            #     utils_giswater.fillWidget("text1")
            #     utils_giswater.fillWidget("text2")
            #     utils_giswater.fillWidget("observ")
            #     utils_giswater.fillWidget("atlas_id")
            #     utils_giswater.fillWidget("scale")
            #     utils_giswater.fillWidget("rotation")
            #
            #     # Fill tables tbl_arc_plan, tbl_node_plan, tbl_v_plan_other_x_psector with selected filter
            #     expr = " psector_id = " + str(psector_id)
            #     tbl_arc_plan.model().setFilter(expr)
            #     tbl_arc_plan.model().select()
            #
            #     expr = " psector_id = " + str(psector_id)
            #     tbl_node_plan.model().setFilter(expr)
            #     tbl_node_plan.model().select()
            #
            #     # Total other Prices
            #     total_other_price = 0
            #     sql = "SELECT SUM(budget) FROM " + self.schema_name + ".v_plan_other_x_psector"
            #     sql += " WHERE psector_id = '" + str(psector_id) + "'"
            #     row = self.dao.get_row(sql)
            #     if row is not None:
            #         if row[0]:
            #             total_other_price = row[0]
            #     utils_giswater.setText("sum_v_plan_other_x_psector", total_other_price)
            #
            #     # Total arcs
            #     total_arcs = 0
            #     sql = "SELECT SUM(budget) FROM " + self.schema_name + ".v_plan_arc_x_psector"
            #     sql += " WHERE psector_id = '" + str(psector_id) + "'"
            #     row = self.dao.get_row(sql)
            #     if row is not None:
            #         if row[0]:
            #             total_arcs = row[0]
            #     utils_giswater.setText("sum_v_plan_x_arc_psector", total_arcs)
            #
            #     # Total nodes
            #     total_nodes = 0
            #     sql = "SELECT SUM(budget) FROM " + self.schema_name + ".v_plan_node_x_psector"
            #     sql += " WHERE psector_id = '" + str(psector_id) + "'"
            #     row = self.dao.get_row(sql)
            #     if row is not None:
            #         if row[0]:
            #             total_nodes = row[0]
            #     utils_giswater.setText("sum_v_plan_x_node_psector", total_nodes)
            #
            #     sum_expenses = total_other_price + total_arcs + total_nodes
            #     utils_giswater.setText("sum_expenses", sum_expenses)
            #     update = True
            #
            # # Buttons
            # self.dlg.btn_accept.pressed.connect(partial(self.insert_or_update_new_psector, update, 'plan_psector'))
            # self.dlg.btn_cancel.pressed.connect(self.close_dialog)
            # self.dlg.setWindowFlags(Qt.WindowStaysOnTopHint)


