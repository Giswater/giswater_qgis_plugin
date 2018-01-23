"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtCore import QObject, SIGNAL
from PyQt4.QtCore import Qt

import os
import sys

from PyQt4.QtSql import QSqlQueryModel, QSqlTableModel

import utils_giswater
import operator
from functools import partial

from PyQt4.QtGui import QAbstractItemView, QDoubleValidator,QIntValidator, QTableView
from PyQt4.QtGui import QCheckBox, QLineEdit, QComboBox, QDateEdit, QLabel
from ui.plan_psector import Plan_psector
from actions.parent_manage import ParentManage

from qgis.core import QgsMapToPixel, QgsPoint, QgsFeature, QgsGeometry

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)

from actions.multiple_selection import MultipleSelection
class ManageNewPsector(ParentManage):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control 'New Psector' of toolbar 'master' """
        ParentManage.__init__(self, iface, settings, controller, plugin_dir)

    def master_new_psector(self, psector_id=None, psector_type=None):
        """ Button 45: New psector """
        # Create the dialog and signals
        self.dlg = Plan_psector()
        utils_giswater.setDialog(self.dlg)
        self.psector_type = str(psector_type)
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
        self.cmb_psector_type = self.dlg.findChild(QComboBox, "psector_type")
        self.cmb_expl_id = self.dlg.findChild(QComboBox, "expl_id")
        self.cmb_sector_id = self.dlg.findChild(QComboBox, "sector_id")
        self.cmb_result_id = self.dlg.findChild(QComboBox, "result_id")
        scale = self.dlg.findChild(QLineEdit, "scale")
        scale.setValidator(QDoubleValidator())
        rotation = self.dlg.findChild(QLineEdit, "rotation")
        rotation.setValidator(QDoubleValidator())
        atlas_id = self.dlg.findChild(QLineEdit, "atlas_id")
        atlas_id.setValidator(QIntValidator())

        self.populate_combos(self.dlg.psector_type, 'name', 'id', self.psector_type + '_psector_cat_type', False)
        self.populate_combos(self.cmb_expl_id, 'name', 'expl_id', 'exploitation', False)
        self.populate_combos(self.cmb_sector_id, 'name', 'sector_id', 'sector', False)
        self.populate_combos(self.cmb_result_id, 'name', 'result_id', self.psector_type + '_result_cat', False)


        self.priority = self.dlg.findChild(QComboBox, "priority")
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".value_priority ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("priority", rows, False)


        # tab Bugdet
        sum_expenses = self.dlg.findChild(QLineEdit, "sum_expenses")
        self.double_validator(sum_expenses)

        other = self.dlg.findChild(QLineEdit, "other")
        self.double_validator(other)
        other_cost = self.dlg.findChild(QLineEdit, "other_cost")
        self.double_validator(other_cost)
        sum_oexpenses = self.dlg.findChild(QLineEdit, "sum_oexpenses")
        self.double_validator(sum_oexpenses)

        gexpenses = self.dlg.findChild(QLineEdit, "gexpenses")
        self.double_validator(gexpenses)
        gexpenses_cost = self.dlg.findChild(QLineEdit, "gexpenses_cost")
        self.double_validator(gexpenses_cost)
        sum_gexpenses = self.dlg.findChild(QLineEdit, "sum_gexpenses")
        self.double_validator(sum_gexpenses)

        vat = self.dlg.findChild(QLineEdit, "vat")
        self.double_validator(vat)

        vat_cost = self.dlg.findChild(QLineEdit, "vat_cost")
        self.double_validator(vat_cost)
        sum_vexpenses = self.dlg.findChild(QLineEdit, "sum_vexpenses")
        self.double_validator(sum_vexpenses)


        self.dlg.gexpenses_cost.textChanged.connect(partial(self.cal_percent, sum_oexpenses, gexpenses, gexpenses_cost))
        self.dlg.gexpenses_cost.textChanged.connect(partial(self.cal_percent, sum_gexpenses, vat, vat_cost))
        self.dlg.vat.textChanged.connect(partial(self.cal_percent, sum_gexpenses, vat, vat_cost))
        self.dlg.sum_oexpenses.textChanged.connect(partial(self.cal_percent,  sum_oexpenses, gexpenses, gexpenses_cost))

        self.dlg.other.textChanged.connect(partial(self.cal_percent, sum_expenses, other, other_cost))
        self.dlg.other_cost.textChanged.connect(partial(self.sum_total, sum_expenses, other_cost, sum_oexpenses))
        self.dlg.gexpenses.textChanged.connect(partial(self.cal_percent, sum_oexpenses, gexpenses, gexpenses_cost))
        self.dlg.gexpenses_cost.textChanged.connect(partial(self.sum_total, sum_oexpenses, gexpenses_cost, sum_gexpenses))
        self.dlg.vat_cost.textChanged.connect(partial(self.sum_total, sum_gexpenses, vat_cost, sum_vexpenses))


        self.enable_tabs(False)
        self.enable_buttons(False)

        # Tables
        # tab Elements
        self.qtbl_arc = self.dlg.findChild(QTableView, "tbl_psector_x_arc")
        self.qtbl_arc.setSelectionBehavior(QAbstractItemView.SelectRows)

        self.qtbl_node = self.dlg.findChild(QTableView, "tbl_psector_x_node")
        self.qtbl_node.setSelectionBehavior(QAbstractItemView.SelectRows)

        all_rows = self.dlg.findChild(QTableView, "all_rows")
        all_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
        selected_rows = self.dlg.findChild(QTableView, "selected_rows")
        selected_rows.setSelectionBehavior(QAbstractItemView.SelectRows)

        ##
        # if a row is selected from mg_psector_mangement(button 46 or button 81)
        # Si psector_id contiene "1" o "0" python lo toma como boolean, si es True, quiere decir que no contiene valor
        # y por lo tanto es uno nuevo. Convertimos ese valor en 0 ya que ningun id va a ser 0. de esta manera si psector_id
        # tiene un valor distinto de 0, es que el sector ya existe y queremos hacer un update.
        ##
        if isinstance(psector_id, bool):
            psector_id = 0

        if psector_id != 0:
            self.enable_tabs(True)
            self.enable_buttons(True)
            self.dlg.name.setEnabled(False)
            self.fill_table(self.qtbl_arc, self.schema_name + "." + self.psector_type + "_psector_x_arc")
            self.fill_table(self.qtbl_node, self.schema_name + "." + self.psector_type + "_psector_x_node")

            sql = "SELECT psector_id, name, psector_type, expl_id, sector_id, priority, descript, text1, text2, observ, atlas_id, scale, rotation, active "
            sql += " FROM " + self.schema_name + "." + self.psector_type + "_psector"
            sql += " WHERE psector_id = " + str(psector_id)
            row = self.dao.get_row(sql)
            if row is None:
                return
            self.psector_id.setText(str(row['psector_id']))
            utils_giswater.set_combo_itemData(self.cmb_psector_type, row['psector_type'], 0, 1)
            utils_giswater.set_combo_itemData(self.cmb_expl_id, row['expl_id'], 0, 1)
            utils_giswater.set_combo_itemData(self.cmb_sector_id, row['sector_id'], 0, 1)

            utils_giswater.setRow(row)
            utils_giswater.setChecked("active", row['active'])
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

            # Fill tables tbl_arc_plan, tbl_node_plan, tbl_v_plan/om_other_x_psector with selected filter
            expr = " psector_id = " + str(psector_id)
            self.qtbl_arc.model().setFilter(expr)
            self.qtbl_arc.model().select()

            expr = " psector_id = " + str(psector_id)
            self.qtbl_node.model().setFilter(expr)
            self.qtbl_node.model().select()

            self.populate_budget(psector_id)
            update = True



        # Set signals
        self.dlg.btn_accept.pressed.connect(partial(self.insert_or_update_new_psector, update, self.psector_type + '_psector', True))
        self.dlg.tabWidget.currentChanged.connect(partial(self.check_tab_position, update))
        self.dlg.btn_cancel.pressed.connect(partial(self.close_psector, cur_active_layer))
        self.dlg.rejected.connect(partial(self.close_psector, cur_active_layer))
        #self.dlg.psector_type.currentIndexChanged.connect(partial(self.enable_combos))
        self.lbl_descript = self.dlg.findChild(QLabel, "lbl_descript")
        self.dlg.all_rows.clicked.connect(partial(self.show_description))
        self.dlg.btn_select.clicked.connect(partial(self.update_total, self.dlg.selected_rows))
        self.dlg.btn_unselect.clicked.connect(partial(self.update_total, self.dlg.selected_rows))
        self.dlg.btn_insert.pressed.connect(partial(self.insert_feature, table_object, True))
        self.dlg.btn_delete.pressed.connect(partial(self.delete_records, table_object, True))
        self.dlg.btn_snapping.pressed.connect(partial(self.selection_init, table_object, True))
        self.dlg.btn_composer.pressed.connect(partial(self.composer))
        self.dlg.btn_rapport.pressed.connect(partial(self.rapport))
        self.dlg.tab_feature.currentChanged.connect(partial(self.tab_feature_changed, table_object))
        self.dlg.name.textChanged.connect(partial(self.enable_relation_tab, self.psector_type + '_psector'))

        self.dlg.txt_name.textChanged.connect(partial(self.query_like_widget_text, self.dlg.txt_name, self.dlg.all_rows, 'v_price_compost', 'v_edit_'+self.psector_type + '_psector_x_other', "id"))


        sql = ("SELECT other, gexpenses, vat FROM " + self.schema_name + "." + self.psector_type + "_psector "
               " WHERE psector_id='"+str(psector_id)+"'")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(self.dlg.other, row[0])
            utils_giswater.setWidgetText(self.dlg.gexpenses, row[1])
            utils_giswater.setWidgetText(self.dlg.vat, row[2])

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


    def update_total(self, qtable):
        """ Show description of product plan/om _psector as label"""
        selected_list = qtable.model()
        if selected_list is None:
            return
        total = 0
        psector_id = utils_giswater.getWidgetText('psector_id')
        for x in range(0, selected_list.rowCount()):
            if int(qtable.model().record(x).value('psector_id')) == int(psector_id):
                total = total + float(qtable.model().record(x).value('total_budget'))
        utils_giswater.setText('lbl_total', str(total))


    def composer(self):
        self.controller.log_info(str("COMPOSER"))
    def rapport(self):
        self.controller.log_info(str("RAPPORT"))



    def populate_budget(self, psector_id):
        sql = ("SELECT total_arc, total_node, total_other FROM " + self.schema_name + ".v_" + self.psector_type + "_psector")
        sql += " WHERE psector_id = '" + str(psector_id) + "'"
        row = self.controller.get_row(sql)
        sum_expenses = 0
        if row is not None:
            if row[0]:
                utils_giswater.setText("sum_v_plan_x_arc_psector", row[0])
                sum_expenses += row[0]
            else:
                utils_giswater.setText("sum_v_plan_x_arc_psector", 0)
            if row[1]:
                utils_giswater.setText("sum_v_plan_x_node_psector", row[1])
                sum_expenses += row[1]
            else:
                utils_giswater.setText("sum_v_plan_x_node_psector", 0)
            if row[2]:
                utils_giswater.setText("sum_v_plan_other_x_psector", row[2])
                sum_expenses += row[2]
            else:
                utils_giswater.setText("sum_v_plan_other_x_psector", 0)

            utils_giswater.setText("sum_expenses", str(sum_expenses))


    def show_description(self):
        """ Show description of product plan/om _psector as label"""
        index = self.dlg.all_rows.currentIndex()
        selected_list = self.dlg.all_rows.selectionModel().selectedRows()
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            des = self.dlg.all_rows.model().record(row).value('descript')
        utils_giswater.setText(self.lbl_descript, des)


    def double_validator(self, widget):
        validator = QDoubleValidator(-9999999, 99, 2)
        validator.setNotation(QDoubleValidator().StandardNotation)
        widget.setValidator(validator)


    def enable_tabs(self, enabled):
        self.dlg.tabWidget.setTabEnabled(1, enabled)
        self.dlg.tabWidget.setTabEnabled(2, enabled)
        self.dlg.tabWidget.setTabEnabled(3, enabled)


    def enable_buttons(self, enabled):
        self.dlg.btn_insert.setEnabled(enabled)
        self.dlg.btn_delete.setEnabled(enabled)
        self.dlg.btn_snapping.setEnabled(enabled)

    def selection_init(self, table_object, querry=True):
        """ Set canvas map tool to an instance of class 'MultipleSelection' """

        multiple_selection = MultipleSelection(self.iface, self.controller, self.layers[self.geom_type],
                                               parent_manage=self, table_object=table_object)
        self.canvas.setMapTool(multiple_selection)
        self.disconnect_signal_selection_changed()
        self.connect_signal_selection_changed(table_object, querry)

        cursor = self.get_cursor_multiple_selection()
        self.canvas.setCursor(cursor)

    def connect_signal_selection_changed(self, table_object, querry=True):
        """ Connect signal selectionChanged """

        try:
            self.canvas.selectionChanged.connect(partial(self.selection_changed, table_object, self.geom_type, querry))
        except Exception:
            pass


    def enable_relation_tab(self, tablename):
        sql = ("SELECT name FROM " + self.schema_name + "." + tablename + " "
               " WHERE LOWER(name)='" + utils_giswater.getWidgetText(self.dlg.name) + "'")
        rows = self.controller.get_rows(sql)
        if not rows:
            if self.dlg.name.text() != '':
                self.enable_tabs(True)
            else:
                self.enable_tabs(False)
        else:
            self.enable_tabs(False)


    def check_tab_position(self, update):
        self.dlg.name.setEnabled(False)
        if self.dlg.tabWidget.currentIndex() == 1 and utils_giswater.getWidgetText(self.dlg.psector_id) == 'null':
            self.insert_or_update_new_psector(update, tablename=''+self.psector_type + '_psector', close_dlg=False)
        if self.dlg.tabWidget.currentIndex() == 2:
            tableleft = "v_price_compost"
            tableright = "v_edit_" + self.psector_type + "_psector_x_other"
            field_id_left = "id"
            field_id_right = "price_id"
            self.multi_row_selector(self.dlg, tableleft, tableright, field_id_left, field_id_right)
            self.update_total(self.dlg.selected_rows)
        if self.dlg.tabWidget.currentIndex() == 3:
            self.populate_budget(utils_giswater.getWidgetText('psector_id'))


        sql = ("SELECT other, gexpenses, vat FROM " + self.schema_name + "." + self.psector_type + "_psector "
               " WHERE psector_id='" + str(utils_giswater.getWidgetText('psector_id')) + "'")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(self.dlg.other, row[0])
            utils_giswater.setWidgetText(self.dlg.gexpenses, row[1])
            utils_giswater.setWidgetText(self.dlg.vat, row[2])


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
        total = float(utils_giswater.getWidgetText(widget_total))
        percent = float(utils_giswater.getWidgetText(widget_percent))
        text = float(total) * float(percent) / 100
        utils_giswater.setWidgetText(widget_result, text)
        #text = str((float(utils_giswater.getWidgetText(widget_total)) * float(utils_giswater.getWidgetText(widget_percent)) / 100))

        #widget_result.setText(text)


    def sum_total(self, widget_total, widged_percent, widget_result):
        text = (float(utils_giswater.getWidgetText(widget_total))+float(utils_giswater.getWidgetText(widged_percent)))
        utils_giswater.setWidgetText(widget_result, text)
        # text = str((float(widget_total.text()) + float(widged_percent.text())))
        # widget_result.setText(text)


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
        sql =("SELECT name FROM "+ self.schema_name + "." + self.psector_type + "_psector "
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
        else:
            self.enable_tabs(True)
            self.enable_buttons(True)
        # if name_exist and update:
        #     msg = "The name is current in use"
        #     self.controller.show_warning(msg)
        #     return
        #

        sql = ("SELECT DISTINCT(column_name) FROM information_schema.columns WHERE table_name='"+tablename+"'")
        rows = self.controller.get_rows(sql)
        columns = []
        for i in range(0, len(rows)):
            column_name = rows[i]
            columns.append(str(column_name[0]))
        # self.controller.log_info(str(columns))
        # sql = "SELECT * FROM " + self.schema_name + "." + tablename
        # row = self.controller.get_rows(sql)
        # columns = []
        # for i in range(0, len(row)):
        #     column_name = self.dao.get_column_name(i)
        #     columns.append(column_name)
        # self.controller.log_info(str(columns))

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
                        elif (widget_type is QComboBox) and (column_name == 'expl_id' or column_name == 'sector_id'
                              or column_name == 'result_id' or column_name == 'psector_type'):
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
                sql += " WHERE psector_id = '" + utils_giswater.getWidgetText(self.psector_id) + "'"

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
                                values += "'" + value + "', "
                                sql += column_name + ", "


                sql = sql[:len(sql) - 2] + ") "
                values = values[:len(values) - 2] + ")"
                sql += values

        if not update:
            sql += "RETURNING psector_id"
            new_psector_id = self.controller.execute_returning(sql, search_audit=False)
            utils_giswater.setText(self.dlg.psector_id, str(new_psector_id[0]))
        else:
            self.controller.execute_sql(sql)
        self.dlg.tabWidget.setTabEnabled(1, True)

        if close_dlg:
            self.close_dialog()


    def multi_row_selector(self, dialog, tableleft, tableright, field_id_left, field_id_right):

        # fill QTableView all_rows
        tbl_all_rows = dialog.findChild(QTableView, "all_rows")
        tbl_all_rows.setSelectionBehavior(QAbstractItemView.SelectRows)

        query_left = "SELECT * FROM " + self.schema_name + "." + tableleft + " WHERE id NOT IN "
        query_left += "(SELECT price_id FROM " + self.schema_name + "." + tableleft
        query_left += " RIGHT JOIN " + self.schema_name + "." + tableright + " ON " + tableleft + "." + field_id_left + " = " + tableright + "." + field_id_right + "::text)"

        self.fill_table_by_query(tbl_all_rows, query_left)
        self.hide_colums(tbl_all_rows, [2, 3])
        tbl_all_rows.setColumnWidth(0, 175)
        tbl_all_rows.setColumnWidth(1, 115)
        tbl_all_rows.setColumnWidth(4, 115)

        # fill QTableView selected_rows
        tbl_selected_rows = dialog.findChild(QTableView, "selected_rows")
        tbl_selected_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
        query_right = "SELECT "+tableright + ".unit, " +tableright + "."+field_id_right+", " + tableright + ".price, " + tableright + ".measurement, " + tableright + ".total_budget"
        query_right += " FROM " + self.schema_name + "." + tableleft
        query_right += " JOIN " + self.schema_name + "." + tableright + " ON " + tableleft + "." + field_id_left + " = " + tableright + "." + field_id_right + "::text"
        query_right += " WHERE psector_id='"+utils_giswater.getWidgetText('psector_id')+"'"

        self.fill_table(tbl_selected_rows, self.schema_name+".v_edit_" + self.psector_type + "_psector_x_other", True)
        self.hide_colums(tbl_selected_rows, [0, 1, 4, 8])
        tbl_selected_rows.setColumnWidth(2, 60)
        tbl_selected_rows.setColumnWidth(5, 60)
        tbl_selected_rows.setColumnWidth(7, 92)

        # Button select
        dialog.btn_select.pressed.connect(
            partial(self.multi_rows_selector, tbl_all_rows, tbl_selected_rows, 'id', tableright, "price_id",
                    query_left, query_right, 'id'))

        # Button unselect
        query_delete = "DELETE FROM " + self.schema_name + "." + tableright
        query_delete += " WHERE  " + tableright + "." + field_id_right + "="
        dialog.btn_unselect.pressed.connect(
            partial(self.unselector, tbl_all_rows, tbl_selected_rows, query_delete, query_left, query_right,
                    field_id_right))


    def multi_rows_selector(self, qtable_left, qtable_right, id_ori,
                            tablename_des, id_des, query_left, query_right, field_id):
        """
            :param qtable_left: QTableView origin
            :param qtable_right: QTableView destini
            :param id_ori: Refers to the id of the source table
            :param tablename_des: table destini
            :param id_des: Refers to the id of the target table, on which the query will be made
            :param query_right:
            :param query_left:
            :param field_id:
        """

        selected_list = qtable_left.selectionModel().selectedRows()

        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        expl_id = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = qtable_left.model().record(row).value(id_ori)
            expl_id.append(id_)

        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            values = ""
            psector_id = utils_giswater.getWidgetText('psector_id')
            values += "'" + str(psector_id) + "', "
            if qtable_left.model().record(row).value('unit') != None:
                values += "'" + str(qtable_left.model().record(row).value('unit')) + "', "
            else:
                values += 'null, '
            if qtable_left.model().record(row).value('id') != None:
                values += "'" + str(qtable_left.model().record(row).value('id')) + "', "
            else:
                values += 'null, '
            if qtable_left.model().record(row).value('description') != None:
                values += "'" + str(qtable_left.model().record(row).value('description')) + "', "
            else:
                values += 'null, '
            if qtable_left.model().record(row).value('price') != None:
                values += "'" + str(qtable_left.model().record(row).value('price')) + "', "
            else:
                values += 'null, '
            values = values[:len(values) - 2]
            # Check if expl_id already exists in expl_selector
            sql = ("SELECT DISTINCT(" + id_des + ")"
                   " FROM " + self.schema_name + "." + tablename_des + ""
                   " WHERE " + id_des + " = '" + str(expl_id[i]) + "'")
            row = self.controller.get_row(sql)
            if row:
                # if exist - show warning
                self.controller.show_info_box("Id " + str(expl_id[i]) + " is already selected!", "Info")
            else:
                sql = ("INSERT INTO " + self.schema_name + "." + tablename_des + " (psector_id, unit, price_id, descript, price) "
                       " VALUES (" +values+")")
                self.controller.execute_sql(sql)

        # Refresh
        self.fill_table(qtable_right, self.schema_name + ".v_edit_" + self.psector_type + "_psector_x_other", True)
        self.fill_table_by_query(qtable_left, query_left)


    def unselector(self, qtable_left, qtable_right, query_delete, query_left, query_right, field_id_right):

        selected_list = qtable_right.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        expl_id = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = str(qtable_right.model().record(row).value(field_id_right))
            expl_id.append(id_)
        for i in range(0, len(expl_id)):
            sql = (query_delete + "'" + str(expl_id[i]) + "' AND psector_id ='"+utils_giswater.getWidgetText('psector_id') +"'")
            self.controller.execute_sql(sql)

        # Refresh
        self.fill_table_by_query(qtable_left, query_left)
        self.fill_table(qtable_right, self.schema_name + ".v_edit_" + self.psector_type + "_psector_x_other", True)



    def query_like_widget_text(self, text_line, qtable, tableleft, tableright, field_id):
        """ Populate the QTableView by filtering through the QLineEdit"""
        query = utils_giswater.getWidgetText(text_line).lower()
        if query == 'null':
            query = ""
        sql = ("SELECT * FROM " + self.schema_name + "." + tableleft + " WHERE LOWER("+field_id+") "
               " LIKE '%"+query+"%' AND "+field_id+" NOT IN("
               " SELECT price_id FROM " + self.schema_name + "." + tableright + " "
               " WHERE psector_id='"+utils_giswater.getWidgetText('psector_id') + "')")
        self.fill_table_by_query(qtable, sql)


    def fill_table_by_query(self, qtable, query):
        """
        :param qtable: QTableView to show
        :param query: query to set model
        """

        model = QSqlQueryModel()
        model.setQuery(query)
        qtable.setModel(model)
        qtable.show()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())

    def fill_table(self, widget, table_name, hidde=False):
        """ Set a model with selected filter.
        Attach that model to selected table
        @setEditStrategy:
            0: OnFieldChange
            1: OnRowChange
            2: OnManualSubmit
        """

        # Set model
        model = QSqlTableModel()
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnFieldChange)
        model.setSort(0, 0)
        model.select()
        # When change some field we need to refresh Qtableview and filter by psector_id
        model.dataChanged.connect(partial(self.refresh_table, widget))
        model.dataChanged.connect(partial(self.update_total, widget))

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())
        # Attach model to table view
        widget.setModel(model)

        if hidde:
            self.refresh_table(widget)

    def refresh_table(self, widget):
        """ Refresh qTableView 'selected_rows' """
        widget.selectAll()
        selected_list = widget.selectionModel().selectedRows()
        widget.clearSelection()
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            if str(widget.model().record(row).value('psector_id')) != utils_giswater.getWidgetText('psector_id'):
                widget.hideRow(i)

