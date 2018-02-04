"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
import os
import sys
from functools import partial
from datetime import datetime
from PyQt4.QtCore import QDate
from PyQt4.QtGui import QPushButton, QDateEdit

import utils_giswater

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)

from parent import ParentAction
from actions.manage_visit import ManageVisit
from ..ui.selector_date import SelectorDate


class Om(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'om_ws' """
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.manage_visit = ManageVisit(iface, settings, controller, plugin_dir)

        # Set project user
        self.current_user = self.controller.get_project_user()


    def set_project_type(self, project_type):
        self.project_type = project_type


    def om_add_visit(self):
        """ Button 64: Add visit """
        self.manage_visit.manage_visit()               


    def om_visit_management(self):
        """ Button 65: Visit management """
        # TODO:
        self.controller.log_info("om_visit_management")


    def selector_date(self):
        """ Button 84: Selector dates """

        self.dlg_selector_date = SelectorDate()
        utils_giswater.setDialog(self.dlg_selector_date)
        self.controller.log_info(str(self.current_user))
        self.widget_date_from = self.dlg_selector_date.findChild(QDateEdit, "date_from")
        self.widget_date_to = self.dlg_selector_date.findChild(QDateEdit, "date_to")
        self.dlg_selector_date.findChild(QPushButton, "btn_accept").clicked.connect(self.update_dates_into_db)

        self.widget_date_from.dateChanged.connect(partial(self.update_date_to))
        self.widget_date_to.dateChanged.connect(partial(self.update_date_from))

        self.get_default_dates()
        utils_giswater.setCalendarDate(self.widget_date_from, self.from_date)
        utils_giswater.setCalendarDate(self.widget_date_to, self.to_date)
        self.dlg_selector_date.exec_()


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

        self.dlg_selector_date.close()
        self.refresh_map_canvas()


    def update_date_to(self):
        """ If 'date from' is upper than 'date to' set 'date to' 1 day more than 'date from' """
        from_date = self.widget_date_from.date().toString('yyyy-MM-dd')
        to_date = self.widget_date_to.date().toString('yyyy-MM-dd')
        if from_date >= to_date:
            to_date = self.widget_date_from.date().addDays(1).toString('yyyy-MM-dd')
            utils_giswater.setCalendarDate(self.widget_date_to, datetime.strptime(to_date, '%Y-%m-%d'))


    def update_date_from(self):
        """ If 'date to' is lower than 'date from' set 'date from' 1 day less than 'date to' """
        from_date = self.widget_date_from.date().toString('yyyy-MM-dd')
        to_date = self.widget_date_to.date().toString('yyyy-MM-dd')
        if to_date <= from_date:
            from_date = self.widget_date_to.date().addDays(-1).toString('yyyy-MM-dd')
            utils_giswater.setCalendarDate(self.widget_date_from, datetime.strptime(from_date, '%Y-%m-%d'))


    def get_default_dates(self):
        """ Load the dates from the DB for the current_user and set vars (self.from_date, self.to_date) """

        sql = ("SELECT from_date, to_date FROM " + self.controller.schema_name + ".selector_date"
               " WHERE cur_user = '" + self.current_user + "'")
        row = self.controller.get_row(sql)
        if row:
            self.from_date = QDate(row[0])
            self.to_date = QDate(row[1])
        else:
            self.from_date = QDate.currentDate()
            self.to_date = QDate.currentDate().addDays(1)
            
            