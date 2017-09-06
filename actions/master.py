"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtCore import QTime
from PyQt4.QtCore import Qt, QPoint
from PyQt4.QtGui import QComboBox, QCheckBox, QDateEdit, QPushButton, QSpinBox, QTimeEdit
from PyQt4.QtGui import QDoubleValidator, QLineEdit, QTabWidget, QTableView, QAbstractItemView

from qgis.gui import QgsMapCanvasSnapper, QgsMapToolEmitPoint
from qgis.core import QgsMapLayerRegistry, QgsFeatureRequest
import os
import sys
from datetime import datetime
from functools import partial

from ..ui.config_master import ConfigMaster
from ..ui.psector_management import Psector_management      # @UnresolvedImport
from ..ui.plan_psector import Plan_psector                  # @UnresolvedImport
from ..ui.plan_estimate_result_new import EstimateResultNew                # @UnresolvedImport
from ..ui.plan_estimate_result_selector import EstimateResultSelector      # @UnresolvedImport
from ..ui.multirow_selector import Multirow_selector       # @UnresolvedImport

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater

from parent import ParentAction


class Master(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control Management toolbar actions """
        self.minor_version = "3.0"
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)


    def set_project_type(self, project_type):
        self.project_type = project_type


    def master_new_psector(self, psector_id=None, enable_tabs=False):
        """ Button 45: New psector """

        # Create the dialog and signals
        self.dlg_new_psector = Plan_psector()
        utils_giswater.setDialog(self.dlg_new_psector)
        self.list_elemets = {}
        update = False  # if false: insert; if true: update
        self.tab_arc_node_other = self.dlg_new_psector.findChild(QTabWidget, "tabWidget_2")
        self.tab_arc_node_other.setTabEnabled(0, enable_tabs)
        self.tab_arc_node_other.setTabEnabled(1, enable_tabs)
        self.tab_arc_node_other.setTabEnabled(2, enable_tabs)

        # tab General elements
        self.psector_id = self.dlg_new_psector.findChild(QLineEdit, "psector_id")
        self.priority = self.dlg_new_psector.findChild(QComboBox, "priority")
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".value_priority ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("priority", rows, False)

        scale = self.dlg_new_psector.findChild(QLineEdit, "scale")
        scale.setValidator(QDoubleValidator())
        rotation = self.dlg_new_psector.findChild(QLineEdit, "rotation")
        rotation.setValidator(QDoubleValidator())

        # tab Bugdet
        sum_expenses = self.dlg_new_psector.findChild(QLineEdit, "sum_expenses")
        other = self.dlg_new_psector.findChild(QLineEdit, "other")
        other.setValidator(QDoubleValidator())
        other_cost = self.dlg_new_psector.findChild(QLineEdit, "other_cost")

        sum_oexpenses = self.dlg_new_psector.findChild(QLineEdit, "sum_oexpenses")
        gexpenses = self.dlg_new_psector.findChild(QLineEdit, "gexpenses")
        gexpenses.setValidator(QDoubleValidator())
        gexpenses_cost = self.dlg_new_psector.findChild(QLineEdit, "gexpenses_cost")
        self.dlg_new_psector.gexpenses_cost.textChanged.connect(partial(self.cal_percent, sum_oexpenses, gexpenses, gexpenses_cost))

        sum_gexpenses = self.dlg_new_psector.findChild(QLineEdit, "sum_gexpenses")
        vat = self.dlg_new_psector.findChild(QLineEdit, "vat")
        vat.setValidator(QDoubleValidator())
        vat_cost = self.dlg_new_psector.findChild(QLineEdit, "vat_cost")
        self.dlg_new_psector.gexpenses_cost.textChanged.connect(partial(self.cal_percent, sum_gexpenses, vat, vat_cost))

        sum_vexpenses = self.dlg_new_psector.findChild(QLineEdit, "sum_vexpenses")

        self.dlg_new_psector.other.textChanged.connect(partial(self.cal_percent, sum_expenses, other, other_cost))
        self.dlg_new_psector.other_cost.textChanged.connect(partial(self.sum_total, sum_expenses, other_cost, sum_oexpenses))
        self.dlg_new_psector.gexpenses.textChanged.connect(partial(self.cal_percent, sum_oexpenses, gexpenses, gexpenses_cost))
        self.dlg_new_psector.gexpenses_cost.textChanged.connect(partial(self.sum_total, sum_oexpenses, gexpenses_cost, sum_gexpenses))
        self.dlg_new_psector.vat.textChanged.connect(partial(self.cal_percent, sum_gexpenses, vat, vat_cost))
        self.dlg_new_psector.vat_cost.textChanged.connect(partial(self.sum_total, sum_gexpenses, vat_cost, sum_vexpenses))

        # Tables
        # tab Elements
        self.tbl_arc_plan = self.dlg_new_psector.findChild(QTableView, "tbl_arc_plan")
        self.tbl_arc_plan.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.fill_table(self.tbl_arc_plan, self.schema_name + ".plan_arc_x_psector")

        self.tbl_node_plan = self.dlg_new_psector.findChild(QTableView, "tbl_node_plan")
        self.tbl_node_plan.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.fill_table(self.tbl_node_plan, self.schema_name + ".plan_node_x_psector")

        self.tbl_other_plan = self.dlg_new_psector.findChild(QTableView, "tbl_other_plan")
        self.tbl_other_plan.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.fill_table(self.tbl_other_plan, self.schema_name + ".plan_other_x_psector")

        # tab Elements
        self.dlg_new_psector.btn_add_arc_plan.pressed.connect(partial(self.snapping, "v_edit_arc", "plan_arc_x_psector", self.tbl_arc_plan, "arc"))
        self.dlg_new_psector.btn_del_arc_plan.pressed.connect(partial(self.multi_rows_delete, self.tbl_arc_plan, "plan_arc_x_psector", "id"))

        self.dlg_new_psector.btn_add_node_plan.pressed.connect(partial(self.snapping, "v_edit_node", "plan_node_x_psector", self.tbl_node_plan, "node"))
        self.dlg_new_psector.btn_del_node_plan.pressed.connect(partial(self.multi_rows_delete, self.tbl_node_plan, "plan_node_x_psector", "id"))

        self.dlg_new_psector.btn_del_other_plan.pressed.connect(partial(self.multi_rows_delete, self.tbl_other_plan, "plan_other_x_psector", "id"))

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
            self.tbl_arc_plan.model().setFilter(expr)
            self.tbl_arc_plan.model().select()

            expr = " psector_id = " + str(psector_id)
            self.tbl_node_plan.model().setFilter(expr)
            self.tbl_node_plan.model().select()

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
        self.dlg_new_psector.btn_accept.pressed.connect(partial(self.insert_or_update_new_psector, update, 'plan_psector'))
        self.dlg_new_psector.btn_cancel.pressed.connect(self.dlg_new_psector.close)
        self.dlg_new_psector.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_new_psector.open()


    def master_psector_mangement(self):
        """ Button 46: Psector management """

        # psm es abreviacion de psector_management
        # Create the dialog and signals
        self.dlg_psector_mangement = Psector_management()
        utils_giswater.setDialog(self.dlg_psector_mangement)
        table_name = "plan_psector"
        column_id = "psector_id"

        # Tables
        self.tbl_psm = self.dlg_psector_mangement.findChild(QTableView, "tbl_psm")
        self.tbl_psm.setSelectionBehavior(QAbstractItemView.SelectRows)  # Select by rows instead of individual cells

        # Set signals
        self.dlg_psector_mangement.btn_accept.pressed.connect(self.charge_psector)
        self.dlg_psector_mangement.btn_cancel.pressed.connect(self.dlg_psector_mangement.close)
        self.dlg_psector_mangement.btn_delete.clicked.connect(partial(self.multi_rows_delete, self.tbl_psm, table_name, column_id))
        self.dlg_psector_mangement.txt_name.textChanged.connect(partial(self.filter_by_text, self.tbl_psm, self.dlg_psector_mangement.txt_name, "plan_psector"))

        self.fill_table(self.tbl_psm, self.schema_name + ".plan_psector")



        self.dlg_psector_mangement.exec_()

    def master_config_master(self):
        """ Button 99: Open a dialog showing data from table 'config_param_system' """

        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, 28)
        self.controller.check_action(True, 99)

        # Create the dialog and signals
        self.dlg_config_master = ConfigMaster()
        utils_giswater.setDialog(self.dlg_config_master)
        self.dlg_config_master.btn_accept.pressed.connect(self.master_config_master_accept)
        self.dlg_config_master.btn_cancel.pressed.connect(self.dlg_config_master.close)

        # Fill all QLineEdit
        sql = "SELECT parameter, value FROM " + self.schema_name + ".config_param_system"
        rows = self.dao.get_rows(sql)
        self.master_options_fill_textview(rows)

        self.om_visit_absolute_path = self.dlg_config_master.findChild(QLineEdit, "om_visit_absolute_path")
        self.doc_absolute_path = self.dlg_config_master.findChild(QLineEdit, "doc_absolute_path")

        self.dlg_config_master.findChild(QPushButton, "om_path_url").clicked.connect(partial(self.open_web_browser, self.om_visit_absolute_path))
        self.dlg_config_master.findChild(QPushButton, "om_path_doc").clicked.connect(partial(self.open_file_dialog, self.om_visit_absolute_path))
        self.dlg_config_master.findChild(QPushButton, "doc_path_url").clicked.connect(partial(self.open_web_browser, self.doc_absolute_path))
        self.dlg_config_master.findChild(QPushButton, "doc_path_doc").clicked.connect(partial(self.open_file_dialog, self.doc_absolute_path))


        # QCheckBox
        self.chk_psector_enabled = self.dlg_config_master.findChild(QCheckBox, 'chk_psector_enabled')
        self.slope_arc_direction = self.dlg_config_master.findChild(QCheckBox, 'slope_arc_direction')

        if self.project_type == 'ws':
            self.slope_arc_direction.setEnabled(False)

        sql = "SELECT name FROM" + self.schema_name + ".plan_psector ORDER BY name"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("psector_vdefault", rows)

        sql = "SELECT parameter, value FROM " + self.schema_name + ".config_param_user WHERE parameter = 'psector_vdefault'"
        row = self.dao.get_row(sql)
        if row:
            utils_giswater.setChecked(self.chk_psector_enabled, True)
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))
        self.master_options_get_data("config")
        self.master_options_get_data("config_param_system")
        self.dlg_config_master.exec_()


    def master_options_fill_textview(self, rows):
        for row in rows:
            utils_giswater.setWidgetText(str(row[0]), str(row[1]))


    def master_options_get_data(self, tablename):
        """ Get data from selected table and fill widgets according to the name of the columns """

        sql = 'SELECT * FROM ' + self.schema_name + "." + tablename
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

        if utils_giswater.isChecked(self.chk_psector_enabled):
            self.insert_or_update_config_param_curuser(self.dlg_config_master.psector_vdefault, "psector_vdefault", "config_param_user")
        else:
            self.delete_row("psector_vdefault", "config_param_user")
        self.update_conf_param_master(True, "config", self.dlg_config_master)

        self.insert_or_update_config_param(self.dlg_config_master.om_visit_absolute_path, "om_visit_absolute_path", "config_param_system")
        self.insert_or_update_config_param(self.dlg_config_master.doc_absolute_path, "doc_absolute_path", "config_param_system")
        message = "Values has been updated"
        self.controller.show_info(message, context_name='ui_message')
        self.dlg_config_master.close()


    def insert_or_update_config_param(self, widget, parameter, tablename):
        """ Insert or update values in tables with out current_user control """

        sql = 'SELECT * FROM ' + self.schema_name + '.' + tablename
        rows = self.controller.get_rows(sql)
        exist_param = False
        for row in rows:
            if row[1] == parameter:
                exist_param = True
        if exist_param:
            sql = "UPDATE " + self.schema_name + "." + tablename + " SET value="
            sql += "'" + widget.text() + "' WHERE parameter='" + parameter + "'"
        else:
            sql = 'INSERT INTO ' + self.schema_name + '.' + tablename + '(parameter, value)'
            sql += " VALUES ('" + parameter + "', " + widget.text() + "'))"
        self.controller.execute_sql(sql)


    def update_conf_param_master(self, update, tablename, dialog):
        """ INSERT or UPDATE tables according :param update """

        sql = "SELECT *"
        sql += " FROM " + self.schema_name + "." + tablename
        row = self.dao.get_row(sql)
        columns = []
        for i in range(0, len(row)):
            column_name = self.dao.get_column_name(i)
            columns.append(column_name)

        if update:
            if columns is not None:
                sql = "UPDATE " + self.schema_name + "." + tablename + " SET "
                for column_name in columns:
                    if column_name != 'id':
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
                        if value == 'null':
                            sql += column_name + " = null, "
                        elif value is None:
                            pass
                        else:
                            if type(value) is not bool and widget_type is not QSpinBox:
                                value = value.replace(",", ".")
                            sql += column_name + " = '" + str(value) + "', "
                sql = sql[:len(sql) - 2]

        else:
            values = "VALUES("
            if columns is not None:
                sql = "INSERT INTO " + self.schema_name + "." + tablename + " ("
                for column_name in columns:
                    if column_name != 'id':
                        widget_type = utils_giswater.getWidgetType(column_name)
                        if widget_type is not None:
                            if widget_type is QCheckBox:
                                values += utils_giswater.isChecked(column_name) + ", "
                            elif widget_type is QDateEdit:
                                date = dialog.findChild(QDateEdit, str(column_name))
                                values += date.dateTime().toString('yyyy-MM-dd') + ", "
                            else:
                                value = utils_giswater.getWidgetText(column_name)
                            if value is None or value == 'null':
                                sql += column_name + ", "
                                values += "null, "
                            else:
                                values += "'" + value + "',"
                                sql += column_name + ", "
                sql = sql[:len(sql) - 2] + ") "
                values = values[:len(values) - 2] + ")"
                sql += values

        self.controller.execute_sql(sql)

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
            self.controller.show_warning(message, context_name='ui_message')
            return
        row = selected_list[0].row()
        psector_id = self.tbl_psm.model().record(row).value("psector_id")
        self.dlg_psector_mangement.close()
        self.master_new_psector(psector_id, True)

    def snapping(self, layer_view, tablename, table_view, elem_type):
        map_canvas = self.iface.mapCanvas()
        # Create the appropriate map tool and connect the gotPoint() signal.
        self.emitPoint = QgsMapToolEmitPoint(map_canvas)
        map_canvas.setMapTool(self.emitPoint)
        self.dlg_new_psector.btn_add_arc_plan.setText('Editing')
        self.dlg_new_psector.btn_add_node_plan.setText('Editing')
        self.emitPoint.canvasClicked.connect(partial(self.click_button_add, layer_view, tablename, table_view, elem_type))


    def click_button_add(self, layer_view, tablename, table_view, elem_type, point, button):
        """
        :param layer_view: it is the view we are using
        :param tablename:  Is the name of the table that we will use to make the SELECT and INSERT
        :param table_view: it's QTableView we are using, need ir for upgrade his own view
        :param elem_type: Used to buy the object that we "click" with the type of object we want to add or delete
        :param point: param inherited from signal canvasClicked
        :param button: param inherited from signal canvasClicked
        """

        if button == Qt.LeftButton:

            node_group = ["Junction", "Valve", "Reduction", "Tank", "Meter", "Manhole", "Source", "Hydrant"]
            arc_group = ["Pipe"]
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
                for snapPoint in result:
                    element_type = snapPoint.layer.name()
                    feat_type = None
                    if element_type in node_group:
                        feat_type = 'node'
                    elif element_type in arc_group:
                        feat_type = 'arc'

                    if feat_type is not None:
                        # Get the point
                        feature = next(snapPoint.layer.getFeatures(QgsFeatureRequest().setFilterFid(snapPoint.snappedAtGeometry)))
                        element_id = feature.attribute(feat_type + '_id')

                        # LEAVE SELECTION
                        snapPoint.layer.select([snapPoint.snappedAtGeometry])
                        # Get depth of feature
                        if feat_type == elem_type:
                            sql = "SELECT * FROM " + self.schema_name + "." + tablename
                            sql += " WHERE " + feat_type+"_id = '" + element_id+"' AND psector_id = '" + self.psector_id.text() + "'"
                            row = self.dao.get_row(sql)
                            if not row:
                                self.list_elemets[element_id] = feat_type
                            else:
                                message = "This id already exists"
                                self.controller.show_info(message, context_name='ui_message')
                        else:
                            message = self.tr("You are trying to introduce")+" "+feat_type+" "+self.tr("in a")+" "+elem_type
                            self.controller.show_info(message, context_name='ui_message')

        elif button == Qt.RightButton:
            for element_id, feat_type in self.list_elemets.items():
                sql = "INSERT INTO " + self.schema_name + "." + tablename + "(" + feat_type + "_id, psector_id)"
                sql += "VALUES (" + element_id + ", " + self.psector_id.text() + ")"
                self.controller.execute_sql(sql)
            table_view.model().select()
            self.emitPoint.canvasClicked.disconnect()
            self.list_elemets.clear()
            self.dlg_new_psector.btn_add_arc_plan.setText('Add')
            self.dlg_new_psector.btn_add_node_plan.setText('Add')


    def insert_or_update_new_psector(self, update, tablename):

        sql = "SELECT *"
        sql += " FROM " + self.schema_name + "." + tablename
        row = self.dao.get_row(sql)
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
                            date = self.dlg_new_psector.findChild(QDateEdit, str(column_name))
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
                                date = self.dlg_new_psector.findChild(QDateEdit, str(column_name))
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
        self.dlg_new_psector.close()


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
            self.controller.show_warning(message, context_name='ui_message')
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


    def cal_percent(self, widged_total, widged_percent, wided_result):
        wided_result.setText(str((float(widged_total.text())*float(widged_percent.text())/100)))


    def sum_total(self, widget_total, widged_percent, wided_result):
        wided_result.setText(str((float(widget_total.text()) + float(widged_percent.text()))))


    def master_psector_selector(self):
        """ Button 47: Psector selector """

        # Create the dialog and signals
        dlg_psector_sel = Multirow_selector()
        utils_giswater.setDialog(dlg_psector_sel)
        dlg_psector_sel.btn_ok.pressed.connect(dlg_psector_sel.close)
        dlg_psector_sel.setWindowTitle("Psector")
        tableleft = "plan_psector"
        tableright = "selector_psector"
        field_id_left = "psector_id"
        field_id_right = "psector_id"
        self.multi_row_selector(dlg_psector_sel, tableleft, tableright, field_id_left, field_id_right)
        dlg_psector_sel.exec_()
        
        
    def master_estimate_result_new(self):
        """ Button 38: New estimate result """

        # Create dialog 
        self.dlg = EstimateResultNew()
        utils_giswater.setDialog(self.dlg)
        
        # Set signals
        self.dlg.btn_calculate.clicked.connect(self.master_estimate_result_new_calculate)
        self.dlg.btn_close.clicked.connect(self.close_dialog)
        self.dlg.text_prices_coeficient.setValidator(QDoubleValidator())

        # Fill combo box
        sql = "SELECT result_id FROM "+self.schema_name+".rpt_cat_result ORDER BY result_id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("result_id", rows, False)
        
        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'estimate_result_new')
        self.dlg.exec_()


    def master_estimate_result_new_calculate(self):
        """ Execute function 'gw_fct_plan_estimate_result' """

        # Get values from form
        result_id = utils_giswater.getWidgetText("result_id")
        coefficient = utils_giswater.getWidgetText("text_prices_coeficient")
        if coefficient == 'null':
            message = "Please, introduce a coefficient value"
            self.controller.show_warning(message, context_name='ui_message')  
            return          
        
        # Execute function 'gw_fct_plan_estimate_result'
        sql = "SELECT "+self.schema_name+".gw_fct_plan_estimate_result('" + result_id + "', " + coefficient + ")"
        status = self.controller.execute_sql(sql)
        if status:
            message = "Values has been updated"
            self.controller.show_info(message, context_name='ui_message')
        
        # Refresh canvas
        self.iface.mapCanvas().refreshAllLayers()


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
            self.controller.show_info(message, context_name='ui_message')        
        
        # Refresh canvas
        self.iface.mapCanvas().refreshAllLayers()
        
