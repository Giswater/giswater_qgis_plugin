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

from actions.multiple_selection import MultipleSelection
class ManageNewPsector(ParentManage, MultipleSelection):

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
        self.dlg.tabWidget.setTabEnabled(1, False)
        self.dlg.tabWidget.setTabEnabled(2, False)
        # self.dlg.tabWidget.setTabEnabled(3, False)

        self.psector_id = self.dlg.findChild(QLineEdit, "psector_id")
        self.cmb_expl_id = self.dlg.findChild(QComboBox, "expl_id")
        self.cmb_sector_id = self.dlg.findChild(QComboBox, "sector_id")

        self.populate_combos(self.dlg.psector_type, 'name', 'id', 'plan_value_psector_type', False)
        self.populate_combos(self.cmb_expl_id, 'name', 'expl_id', 'exploitation', False)
        self.populate_combos(self.cmb_sector_id, 'name', 'sector_id', 'sector', False)
        self.populate_combos(self.dlg.result_type, 'name', 'id', 'plan_value_result_type')
        self.populate_combos(self.dlg.result_id, 'name', 'result_id', 'plan_result_cat')

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
        tbl_arc_plan = self.dlg.findChild(QTableView, "tbl_psector_x_arc")
        tbl_arc_plan.setSelectionBehavior(QAbstractItemView.SelectRows)

        tbl_node_plan = self.dlg.findChild(QTableView, "tbl_psector_x_node")
        tbl_node_plan.setSelectionBehavior(QAbstractItemView.SelectRows)

        tbl_other_plan = self.dlg.findChild(QTableView, "tbl_psector_x_other")
        tbl_other_plan.setSelectionBehavior(QAbstractItemView.SelectRows)


        ##
        # if a row is selected from mg_psector_mangement(button 46)
        # Si psector_id contiene "1" o "0" python lo toma como boolean, si es True, quiere decir que no contiene valor
        # y por lo tanto es uno nuevo. Convertimos ese valor en 0 ya que ningun id va a ser 0. de esta manera si psector_id
        # tiene un valor distinto de 0, es que el sector ya existe y queremos hacer un update.
        ##
        if isinstance(psector_id, bool):
            psector_id = 0

        if psector_id != 0:
            self.enable_combos()
            self.dlg.tabWidget.setTabEnabled(1, True)
            self.dlg.tabWidget.setTabEnabled(2, True)
            self.dlg.tabWidget.setTabEnabled(3, True)
            self.fill_table(tbl_arc_plan, self.schema_name + ".plan_arc_x_psector")
            self.fill_table(tbl_node_plan, self.schema_name + ".plan_node_x_psector")
            #self.fill_table(tbl_other_plan, self.schema_name + ".plan_other_x_psector")

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
        self.dlg.btn_accept.pressed.connect(partial(self.insert_or_update_new_psector, update, 'plan_psector', True))
        self.dlg.tabWidget.currentChanged.connect(partial(self.check_tab_position, update))
        self.dlg.btn_cancel.pressed.connect(partial(self.close_psector, cur_active_layer))
        self.dlg.rejected.connect(partial(self.close_psector, cur_active_layer))
        self.dlg.add_geom.pressed.connect(partial(self.add_geom))
        self.dlg.psector_type.currentIndexChanged.connect(partial(self.enable_combos))

        self.dlg.btn_insert.pressed.connect(partial(self.insert_feature, table_object, True))
        self.dlg.btn_delete.pressed.connect(partial(self.delete_records, table_object, True))
        self.dlg.btn_snapping.pressed.connect(partial(self.selection_init, table_object, True))
        # self.dlg.tbl_psector_x_arc.rowCountChanged.connect(partial(self.test))


        self.dlg.tab_feature.currentChanged.connect(partial(self.tab_feature_changed, table_object))
        self.dlg.name.textChanged.connect(partial(self.enable_relation_tab))

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

    def selection_init(self, table_object, querry=True):
        """ Set canvas map tool to an instance of class 'MultipleSelection' """

        multiple_selection = MultipleSelection(self.iface, self.controller, self.layers[self.geom_type],
                                               parent_manage=self, table_object=table_object)
        self.canvas.setMapTool(multiple_selection)
        self.disconnect_signal_selection_changed()
        self.controller.log_info(str(querry))
        self.connect_signal_selection_changed(table_object, querry)
        self.controller.log_info(str(querry))

        cursor = self.get_cursor_multiple_selection()
        self.canvas.setCursor(cursor)

    def connect_signal_selection_changed(self, table_object, querry=True):
        """ Connect signal selectionChanged """

        try:
            self.canvas.selectionChanged.connect(partial(self.selection_changed, table_object, self.geom_type, querry))
        except Exception:
            pass
    def test(self):
        self.controller.log_info(str("TESTTTT"))
    def enable_combos(self):
        """  Enable QComboBox (result_type and result_id) according psector_type """
        combo = utils_giswater.getWidget(self.dlg.psector_type)
        elem = combo.itemData(combo.currentIndex())
        value = str(elem[0])
        if str(value) == '1':
            self.dlg.result_type.setEnabled(False)
            self.dlg.result_id.setEnabled(False)
        else:
            self.dlg.result_type.setEnabled(True)
            self.dlg.result_id.setEnabled(True)

 
    def enable_relation_tab(self):
        if self.dlg.name.text() != '':
            self.dlg.tabWidget.setTabEnabled(1, True)
        else:
            self.dlg.tabWidget.setTabEnabled(1, False)

    def check_tab_position(self, update):
        if self.dlg.tabWidget.currentIndex() == 1 and utils_giswater.getWidgetText(self.dlg.psector_id) == 'null':
            self.insert_or_update_new_psector(update, tablename='plan_psector', close_dlg=False)
        # else:
        #     update = True
        #     self.insert_or_update_new_psector(update, tablename='plan_psector', close_dlg=False)

    def add_geom(self):
        self.iface.actionSelectPolygon().trigger()

    def populate_combos(self, combo, field, id, table_name, allow_nulls=True):
        sql = ("SELECT DISTINCT("+id+"), "+field+" FROM "+self.schema_name+"."+table_name+" ORDER BY "+field+"")
        rows = self.dao.get_rows(sql)
        combo.blockSignals(True)
        combo.clear()
        if allow_nulls:
            combo.addItem("", "")
        records_sorted = sorted(rows, key=operator.itemgetter(1))
        for record in records_sorted:
            combo.addItem(str(record[1]), record)
        combo.blockSignals(False)


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


    def check_name(self):
        """ Check if name of new psector exist or not """
        exist = False
        sql =("SELECT name FROM "+ self.schema_name + ".plan_psector "
              "WHERE name='"+utils_giswater.getWidgetText(self.dlg.name)+"'")
        row = self.controller.get_row(sql)
        if row:
            exist = True
        return exist


    def insert_or_update_new_psector(self, update, tablename, close_dlg=False):

        name_exist = self.check_name()
        if name_exist and not update:
            msg = "The name is current in use"
            self.controller.show_warning(msg)
            return
        # if name_exist and update:
        #     msg = "The name is current in use"
        #     self.controller.show_warning(msg)
        #     return
        #

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
                        elif (widget_type is QComboBox) and (column_name == 'expl_id' or column_name == 'sector_id' or column_name =='psector_type'):
                            combo = utils_giswater.getWidget(column_name)
                            elem = combo.itemData(combo.currentIndex())
                            value = str(elem[0])
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
                for column_name in columns:
                    if column_name != 'psector_id':
                        widget_type = utils_giswater.getWidgetType(column_name)
                        if widget_type is not None:
                            if widget_type is QCheckBox:
                                values += utils_giswater.isChecked(column_name) + ", "
                            elif widget_type is QDateEdit:
                                date = self.dlg.findChild(QDateEdit, str(column_name))
                                values += date.dateTime().toString('yyyy-MM-dd HH:mm:ss') + ", "
                            elif (widget_type is QComboBox) and \
                                    (column_name == 'expl_id' or column_name == 'sector_id' or column_name == 'psector_type'):
                                combo = utils_giswater.getWidget(column_name)
                                elem = combo.itemData(combo.currentIndex())
                                value = str(elem[0])
                            else:
                                value = utils_giswater.getWidgetText(column_name)
                            if value is None or value == 'null':
                                sql += column_name + ", "
                                values += "null, "
                            else:
                                values += "'" + value + "',"
                                sql += column_name + ", "


                sql = sql[:len(sql) - 2] + ") "
                values = values[:len(values) - 1] + ")"
                sql += values

        if not update:
            sql += "RETURNING psector_id"
            new_psector_id = self.controller.execute_returning(sql, search_audit=False)
            utils_giswater.setText(self.dlg.psector_id, str(new_psector_id[0]))
        else:
            self.controller.execute_sql(sql)
        self.dlg.tabWidget.setTabEnabled(1, True)
        #self.add_plan('arc')
        if close_dlg:
            self.close_dialog()


    def add_plan(self, geom_type):
        """  Add features to plan_table """
        tablename = "plan_" + geom_type + "_x_psector"
        widget = "tbl_psector_x_" + geom_type
        widget = utils_giswater.getWidget(widget)
        selected_list = widget.model()

        if selected_list is None:
            return

        schema_name = self.schema_name.replace('"', '')
        sql = "SELECT column_name FROM information_schema.columns "
        sql += " WHERE table_schema='" + schema_name + "'"
        sql += " AND table_name='" + tablename + "'"
        rows = self.controller.get_rows(sql)

        columns = ''
        for i in range(0, len(rows)):
            columns += str(rows[i][0]) +", "
        columns = columns[:len(columns) - 2]

        sql = ""
        values = ""
        self.controller.log_info(str("SOLUMSNCOUNT: ")+str(selected_list.columnCount()))
        for x in range(0, selected_list.rowCount()):
            row = selected_list[x].row()
            feature_id = widget.model().record(row).value(str(geom_type)+"_id")
            psector_id = widget.model().record(row).value("sector_id")

            descript = widget.model().record(row).value("sector_id")

            for y in range(0, selected_list.columnCount()):
                 # field = selected_list.index(x, y)
                 # self.controller.log_info(str((field.data('psector_id'))))
                 item = widget.item(x,y)
                 self.controller.log_info(str(item.text()))
        #     sql = ("INSERT INTO " + self.schema_name + "." + tablename + "("+columns+") ")

        #     sql += (" VALUES('"+str(selected_list.data))



    # def selection_changed(self, table_object, geom_type):
    #     """ Slot function for signal 'canvas.selectionChanged' """
    #
    #     self.disconnect_signal_selection_changed()
    #
    #     field_id = geom_type + "_id"
    #     self.ids = []
    #
    #     # Iterate over all layers of the group
    #     for layer in self.layers[self.geom_type]:
    #         if layer.selectedFeatureCount() > 0:
    #             # Get selected features of the layer
    #             features = layer.selectedFeatures()
    #             for feature in features:
    #                  # Append 'feature_id' into the list
    #                  selected_id = feature.attribute(field_id)
    #                  if selected_id not in self.ids:
    #                      self.ids.append(selected_id)
    #
    #     if geom_type == 'arc':
    #         self.list_ids['arc'] = self.ids
    #     elif geom_type == 'node':
    #         self.list_ids['node'] = self.ids
    #     elif geom_type == 'connec':
    #         self.list_ids['connec'] = self.ids
    #     elif geom_type == 'gully':
    #         self.list_ids['gully'] = self.ids
    #     elif geom_type == 'element':
    #         self.list_ids['element'] = self.ids
    #
    #     expr_filter = None
    #     if len(self.ids) > 0:
    #         list_id = ''
    #         # Set 'expr_filter' with features that are in the list
    #         expr_filter = "\"" + field_id + "\" IN ("
    #         for i in range(len(self.ids)):
    #             expr_filter += "'" + str(self.ids[i]) + "', "
    #             list_id += "'" + str(self.ids[i]) + "', "
    #             expr_filter = expr_filter[:-2] + ")"
    #         list_id = list_id[:-2]
    #         # Check expression
    #      (is_valid, expr) = self.check_expression(expr_filter)  # @UnusedVariable
    #      self.controller.log_info(str(expr_filter))
    #      self.controller.log_info(str(expr))
    #      if not is_valid:
    #          return
    #
    #      self.select_features_by_ids(geom_type, expr, True)
    #
    #  # Reload contents of table 'tbl_@table_object_x_@geom_type'
    #  self.insert_feature_to_plan(geom_type)
    #
    #  # Remove selection in generic 'v_edit' layers
    #  self.remove_selection(False)
    #
    #  self.connect_signal_selection_changed(table_object)
    #
    #
    # def insert_feature_to_plan(self,geom_type):
    #  """ Reload QtableView """
    #  # combo = utils_giswater.getWidget('sector_id')
    #  # elem = combo.itemData(combo.currentIndex())
    #  # value = str(elem[0])
    #  value = utils_giswater.getWidgetText(self.dlg.psector_id)
    #  for i in range(len(self.ids)):
    #      sql = ("SELECT "+geom_type+"_id FROM "+self.schema_name + ".plan_" +geom_type+"_x_psector "
    #             " WHERE "+geom_type+"_id ='"+str(self.ids[i])+"' AND psector_id='"+str(value)+"'")
    #      row = self.controller.get_row(sql)
    #      if not row:
    #          sql = ("INSERT INTO "+self.schema_name + ".plan_" + geom_type + "_x_psector "
    #                 "("+geom_type+"_id, psector_id) VALUES('"+str(self.ids[i])+"', '"+str(value)+"')")
    #          self.controller.execute_sql(sql)
    #
    #  sql = ("SELECT * FROM "+self.schema_name +".plan_"+geom_type+"_x_psector "
    #          "WHERE psector_id='"+str(value)+"'")
    #  qtable = utils_giswater.getWidget('tbl_psector_x_'+geom_type)
    #  self.fill_table_by_query(qtable, sql)