"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
from builtins import str
from builtins import range

# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import QDate, Qt
from qgis.PyQt.QtWidgets import QTableView, QAbstractItemView, QLineEdit, QDateEdit, QPushButton

from datetime import datetime
from functools import partial

import utils_giswater
from giswater.actions.add_lot import AddNewLot
from giswater.actions.manage_visit import ManageVisit
from giswater.actions.manage_new_psector import ManageNewPsector
from giswater.actions.parent import ParentAction
from giswater.ui_manager import Psector_management
from giswater.ui_manager import SelectorDate


class Om(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'om_ws' """
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.new_lot = AddNewLot(iface, settings, controller, plugin_dir)
        self.manage_visit = ManageVisit(iface, settings, controller, plugin_dir)
        self.manage_new_psector = ManageNewPsector(iface, settings, controller, plugin_dir)

        # Set project user
        self.current_user = self.controller.get_project_user()


    def set_project_type(self, project_type):
        self.project_type = project_type


    def om_add_visit(self):
        """ Button 64: Add visit """
        self.manage_visit.manage_visit()


    def om_visit_management(self):
        """ Button 65: Visit management """
        self.manage_visit.edit_visit()     
        

    def om_psector(self, psector_id=None):
        """ Button 81: Psector """
        self.manage_new_psector.new_psector(psector_id, 'om')
        

    def om_psector_management(self):
        """ Button 82: Psector management """

        self.dlg_psector_mng = Psector_management()
        self.load_settings(self.dlg_psector_mng)
        table_name = "om_psector"
        column_id = "psector_id"
        self.dlg_psector_mng.lbl_vdefault_psector.setVisible(False)
        self.dlg_psector_mng.btn_update_psector.setVisible(False)
        # Tables
        qtbl_psm = self.dlg_psector_mng.findChild(QTableView, "tbl_psm")
        qtbl_psm.setSelectionBehavior(QAbstractItemView.SelectRows)  # Select by rows instead of individual cells

        # Set signals
        self.dlg_psector_mng.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_psector_mng))
        self.dlg_psector_mng.rejected.connect(partial(self.close_dialog, self.dlg_psector_mng))
        self.dlg_psector_mng.btn_delete.clicked.connect(partial(self.multi_rows_delete, qtbl_psm, table_name, column_id))
        self.dlg_psector_mng.btn_update_psector.clicked.connect(partial(self.update_current_psector, self.dlg_psector_mng, qtbl_psm))
        self.dlg_psector_mng.txt_name.textChanged.connect(partial(self.filter_by_text, qtbl_psm, self.dlg_psector_mng.txt_name, table_name))
        self.dlg_psector_mng.tbl_psm.doubleClicked.connect(partial(self.charge_psector, qtbl_psm))
        self.fill_table_psector(qtbl_psm, table_name)
        self.set_table_columns(self.dlg_psector_mng, qtbl_psm, table_name)
        self.set_label_current_psector(self.dlg_psector_mng)

        # Open form
        self.dlg_psector_mng.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.open_dialog(self.dlg_psector_mng, dlg_name="psector_management")


    def charge_psector(self, qtbl_psm):

        selected_list = qtbl_psm.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        row = selected_list[0].row()
        psector_id = qtbl_psm.model().record(row).value("psector_id")
        self.close_dialog(self.dlg_psector_mng)
        self.om_psector(psector_id)


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
        message = "Are you sure you want to delete these records?"
        title = "Delete records"
        answer = self.controller.ask_question(message, title, inf_text)
        if answer:
            sql = "DELETE FROM "+self.schema_name+"."+table_name
            sql += " WHERE "+column_id+" IN ("+list_id+")"
            self.controller.execute_sql(sql)
            widget.model().select()


    def update_current_psector(self, dialog, qtbl_psm):

        selected_list = qtbl_psm.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        row = selected_list[0].row()
        psector_id = qtbl_psm.model().record(row).value("psector_id")
        sql = "SELECT * FROM " + self.schema_name + ".selector_psector WHERE cur_user = current_user"
        rows = self.controller.get_rows(sql)
        if rows:
            sql = ("UPDATE " + self.schema_name + ".selector_psector"
                   " SET psector_id = '" + str(psector_id) + "'"
                   " WHERE cur_user = current_user")
        else:
            sql = ("INSERT INTO " + self.schema_name + ".selector_psector (psector_id, cur_user)"
                   " VALUES ('" + str(psector_id) + "', current_user)")

        aux_widget = QLineEdit()
        aux_widget.setText(str(psector_id))
        self.insert_or_update_config_param_curuser(dialog, aux_widget, "psector_vdefault", "config_param_user")
        self.controller.execute_sql(sql)
        message = "Values has been updated"
        self.controller.show_info(message)

        self.fill_table(qtbl_psm, "v_ui_plan_psector")
        self.set_table_columns(dialog, qtbl_psm, "v_ui_plan_psector")

        dialog.exec_()


    def insert_or_update_config_param_curuser(self, dialog, widget, parameter, tablename):
        """ Insert or update values in tables with current_user control """

        sql = 'SELECT * FROM ' + self.schema_name + '.' + tablename
        sql += ' WHERE "cur_user" = current_user'
        rows = self.controller.get_rows(sql)
        exist_param = False
        if type(widget) != QDateEdit:
            if utils_giswater.getWidgetText(dialog, widget) != "":
                for row in rows:
                    if row[1] == parameter:
                        exist_param = True
                if exist_param:
                    sql = "UPDATE " + self.schema_name + "." + tablename + " SET value="
                    if widget.objectName() != 'state_vdefault':
                        sql += "'" + utils_giswater.getWidgetText(dialog, widget) + "' WHERE parameter='" + parameter + "'"
                    else:
                        sql += ("(SELECT id FROM " + self.schema_name + ".value_state"
                                " WHERE name = '" + utils_giswater.getWidgetText(dialog, widget) + "')"
                                " WHERE parameter = 'state_vdefault'")
                else:
                    sql = "INSERT INTO " + self.schema_name + "." + tablename + "(parameter, value, cur_user)"
                    if widget.objectName() != 'state_vdefault':
                        sql += " VALUES ('" + parameter + "', '" + utils_giswater.getWidgetText(dialog, widget) + "', current_user)"
                    else:
                        sql += (" VALUES ('" + parameter + "',"
                                " (SELECT id FROM " + self.schema_name + ".value_state"
                                " WHERE name ='" + utils_giswater.getWidgetText(dialog, widget) + "'), current_user)")
        else:
            for row in rows:
                if row[1] == parameter:
                    exist_param = True
            if exist_param:
                sql = "UPDATE " + self.schema_name + "." + tablename + " SET value="
                _date = widget.dateTime().toString('yyyy-MM-dd')
                sql += "'" + str(_date) + "' WHERE parameter='" + parameter + "'"
            else:
                sql = "INSERT INTO " + self.schema_name + "." + tablename + "(parameter, value, cur_user)"
                _date = widget.dateTime().toString('yyyy-MM-dd')
                sql += " VALUES ('" + parameter + "', '" + _date + "', current_user)"
                
        self.controller.execute_sql(sql)


    def filter_by_text(self, table, widget_txt, tablename):

        result_select = utils_giswater.getWidgetText(self.dlg_psector_mng, widget_txt)
        if result_select != 'null':
            expr = " name ILIKE '%" + result_select + "%'"
            # Refresh model with selected filter
            table.model().setFilter(expr)
            table.model().select()
        else:
            self.fill_table(table, tablename)


    def selector_date(self):
        """ Button 84: Selector dates """

        self.dlg_selector_date = SelectorDate()
        self.load_settings(self.dlg_selector_date)
        self.widget_date_from = self.dlg_selector_date.findChild(QDateEdit, "date_from")
        self.widget_date_to = self.dlg_selector_date.findChild(QDateEdit, "date_to")
        self.dlg_selector_date.findChild(QPushButton, "btn_accept").clicked.connect(self.update_dates_into_db)
        self.dlg_selector_date.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_selector_date))
        self.dlg_selector_date.rejected.connect(partial(self.close_dialog, self.dlg_selector_date))
        self.widget_date_from.dateChanged.connect(partial(self.update_date_to))
        self.widget_date_to.dateChanged.connect(partial(self.update_date_from))

        self.get_default_dates()
        utils_giswater.setCalendarDate(self.dlg_selector_date, self.widget_date_from, self.from_date)
        utils_giswater.setCalendarDate(self.dlg_selector_date, self.widget_date_to, self.to_date)
        self.open_dialog(self.dlg_selector_date, dlg_name="selector_date")


    def update_dates_into_db(self):
        """ Insert or update dates into data base """

        from_date = self.widget_date_from.date().toString('yyyy-MM-dd')
        to_date = self.widget_date_to.date().toString('yyyy-MM-dd')
        sql = ("SELECT * FROM " + self.controller.schema_name + ".selector_date"
               " WHERE cur_user = '" + self.current_user + "'")
        row = self.controller.get_row(sql)
        if not row :
            sql = ("INSERT INTO " + self.controller.schema_name + ".selector_date"
                   " (from_date, to_date, context, cur_user)"
                   " VALUES('" + from_date + "', '" + to_date + "', 'om_visit', '" + self.current_user + "')")
        else:
            sql = ("UPDATE " + self.controller.schema_name + ".selector_date"
                   " SET (from_date, to_date) = ('" + from_date + "', '" + to_date + "')"
                   " WHERE cur_user = '" + self.current_user + "'")

        self.controller.execute_sql(sql)

        self.close_dialog(self.dlg_selector_date)
        self.refresh_map_canvas()


    def update_date_to(self):
        """ If 'date from' is upper than 'date to' set 'date to' 1 day more than 'date from' """
        from_date = self.widget_date_from.date().toString('yyyy-MM-dd')
        to_date = self.widget_date_to.date().toString('yyyy-MM-dd')
        if from_date >= to_date:
            to_date = self.widget_date_from.date().addDays(1).toString('yyyy-MM-dd')
            utils_giswater.setCalendarDate(self.dlg_selector_date, self.widget_date_to, datetime.strptime(to_date, '%Y-%m-%d'))


    def update_date_from(self):
        """ If 'date to' is lower than 'date from' set 'date from' 1 day less than 'date to' """
        from_date = self.widget_date_from.date().toString('yyyy-MM-dd')
        to_date = self.widget_date_to.date().toString('yyyy-MM-dd')
        if to_date <= from_date:
            from_date = self.widget_date_to.date().addDays(-1).toString('yyyy-MM-dd')
            utils_giswater.setCalendarDate(self.dlg_selector_date, self.widget_date_from, datetime.strptime(from_date, '%Y-%m-%d'))


    def get_default_dates(self):
        """ Load the dates from the DB for the current_user and set vars (self.from_date, self.to_date) """

        sql = ("SELECT from_date, to_date FROM " + self.controller.schema_name + ".selector_date"
               " WHERE cur_user = '" + self.current_user + "'")
        row = self.controller.get_row(sql)
        try:
            if row:
                self.from_date = QDate(row[0])
                self.to_date = QDate(row[1])
            else:
                self.from_date = QDate.currentDate()
                self.to_date = QDate.currentDate().addDays(1)
        except:
            self.from_date = QDate.currentDate()
            self.to_date = QDate.currentDate().addDays(1)


    def om_add_lot(self):
        """''' Button 74: Add new lot '''"""
        self.new_lot.manage_lot()


    def om_lot_management(self):
        """ '''Button 75: Lot management '''"""
        self.new_lot.lot_manager()

