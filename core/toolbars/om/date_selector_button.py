"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from datetime import datetime
from functools import partial

from qgis.PyQt.QtCore import QDate
from qgis.PyQt.QtWidgets import QDateEdit, QPushButton

from ..dialog import GwAction
from ...ui.ui_manager import GwSelectorDateUi
from ...utils import tools_gw
from ....lib import tools_qgis, tools_qt, tools_db
from .... import global_vars


class GwDateSelectorButton(GwAction):
    """ Button 84: Date selector """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        super().__init__(icon_path, action_name, text, toolbar, action_group)


    def clicked_event(self):
        self._open_date_selector()


    # region private functions

    def _open_date_selector(self):
        self.dlg_selector_date = GwSelectorDateUi()
        tools_gw.load_settings(self.dlg_selector_date)
        self.widget_date_from = self.dlg_selector_date.findChild(QDateEdit, "date_from")
        self.widget_date_to = self.dlg_selector_date.findChild(QDateEdit, "date_to")
        self.dlg_selector_date.findChild(QPushButton, "btn_accept").clicked.connect(self._update_dates_into_db)
        self.dlg_selector_date.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_selector_date))
        self.dlg_selector_date.rejected.connect(partial(tools_gw.close_dialog, self.dlg_selector_date))
        self.widget_date_from.dateChanged.connect(partial(self._update_date_to))
        self.widget_date_to.dateChanged.connect(partial(self._update_date_from))

        self._get_default_dates()
        tools_qt.set_calendar(self.dlg_selector_date, self.widget_date_from, self.from_date)
        tools_qt.set_calendar(self.dlg_selector_date, self.widget_date_to, self.to_date)
        tools_gw.open_dialog(self.dlg_selector_date, dlg_name="selector_date")


    def _update_dates_into_db(self):
        """ Insert or update dates into data base """

        # Set project user
        self.current_user = global_vars.current_user

        from_date = self.widget_date_from.date().toString('yyyy-MM-dd')
        to_date = self.widget_date_to.date().toString('yyyy-MM-dd')
        sql = (f"SELECT * FROM selector_date"
               f" WHERE cur_user = '{self.current_user}'")
        row = tools_db.get_row(sql)
        if not row:
            sql = (f"INSERT INTO selector_date"
                   f" (from_date, to_date, context, cur_user)"
                   f" VALUES('{from_date}', '{to_date}', 'om_visit', '{self.current_user}')")
        else:
            sql = (f"UPDATE selector_date"
                   f" SET (from_date, to_date) = ('{from_date}', '{to_date}')"
                   f" WHERE cur_user = '{self.current_user}'")

        tools_db.execute_sql(sql)

        tools_gw.close_dialog(self.dlg_selector_date)
        tools_qgis.refresh_map_canvas()


    def _update_date_to(self):
        """ If 'date from' is upper than 'date to' set 'date to' 1 day more than 'date from' """

        from_date = self.widget_date_from.date().toString('yyyy-MM-dd')
        to_date = self.widget_date_to.date().toString('yyyy-MM-dd')
        if from_date >= to_date:
            to_date = self.widget_date_from.date().addDays(1).toString('yyyy-MM-dd')
            tools_qt.set_calendar(self.dlg_selector_date, self.widget_date_to, datetime.strptime(to_date, '%Y-%m-%d'))


    def _update_date_from(self):
        """ If 'date to' is lower than 'date from' set 'date from' 1 day less than 'date to' """

        from_date = self.widget_date_from.date().toString('yyyy-MM-dd')
        to_date = self.widget_date_to.date().toString('yyyy-MM-dd')
        if to_date <= from_date:
            from_date = self.widget_date_to.date().addDays(-1).toString('yyyy-MM-dd')
            tools_qt.set_calendar(self.dlg_selector_date, self.widget_date_from, datetime.strptime(from_date, '%Y-%m-%d'))


    def _get_default_dates(self):
        """ Load the dates from the DB for the current_user and set vars (self.from_date, self.to_date) """

        # Set project user
        self.current_user = global_vars.current_user

        sql = (f"SELECT from_date, to_date FROM selector_date"
               f" WHERE cur_user = '{self.current_user}'")
        row = tools_db.get_row(sql)
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

    # endregion