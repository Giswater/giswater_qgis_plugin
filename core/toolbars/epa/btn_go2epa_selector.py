"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from .... import global_vars
from ....lib import tools_qt
from ..parent_dialog import GwParentAction
from ...ui.ui_manager import Go2EpaSelectorUi
from ...utils.tools_giswater import close_dialog, load_settings, open_dialog


class GwGo2EpaSelectorButton(GwParentAction):

    def __init__(self, icon_path, text, toolbar, action_group):
        super().__init__(icon_path, text, toolbar, action_group)

        self.project_type = global_vars.project_type


    def clicked_event(self):
        """ Button 29: Epa result selector """

        # Create the dialog and signals
        self.dlg_go2epa_result = Go2EpaSelectorUi()
        load_settings(self.dlg_go2epa_result)
        if self.project_type == 'ud':
            tools_qt.remove_tab_by_tabName(self.dlg_go2epa_result.tabWidget, "tab_time")
        if self.project_type == 'ws':
            tools_qt.remove_tab_by_tabName(self.dlg_go2epa_result.tabWidget, "tab_datetime")
        self.dlg_go2epa_result.btn_accept.clicked.connect(self.result_selector_accept)
        self.dlg_go2epa_result.btn_cancel.clicked.connect(partial(close_dialog, self.dlg_go2epa_result))
        self.dlg_go2epa_result.rejected.connect(partial(close_dialog, self.dlg_go2epa_result))

        # Set values from widgets of type QComboBox
        sql = ("SELECT DISTINCT(result_id), result_id "
               "FROM v_ui_rpt_cat_result ORDER BY result_id")
        rows = self.controller.get_rows(sql)
        tools_qt.set_item_data(self.dlg_go2epa_result.rpt_selector_result_id, rows)
        rows = self.controller.get_rows(sql, add_empty_row=True)
        tools_qt.set_item_data(self.dlg_go2epa_result.rpt_selector_compare_id, rows)

        if self.project_type == 'ws':

            sql = ("SELECT DISTINCT time, time FROM rpt_arc "
                   "WHERE result_id ILIKE '%%' ORDER BY time")
            rows = self.controller.get_rows(sql, add_empty_row=True)
            tools_qt.set_item_data(self.dlg_go2epa_result.cmb_time_to_show, rows)
            tools_qt.set_item_data(self.dlg_go2epa_result.cmb_time_to_compare, rows)

            self.dlg_go2epa_result.rpt_selector_result_id.currentIndexChanged.connect(partial(
                self.populate_time, self.dlg_go2epa_result.rpt_selector_result_id, self.dlg_go2epa_result.cmb_time_to_show))
            self.dlg_go2epa_result.rpt_selector_compare_id.currentIndexChanged.connect(partial(
                self.populate_time, self.dlg_go2epa_result.rpt_selector_compare_id, self.dlg_go2epa_result.cmb_time_to_compare))

        elif self.project_type == 'ud':

            # Populate GroupBox Selector date
            result_id = tools_qt.get_item_data(self.dlg_go2epa_result, self.dlg_go2epa_result.rpt_selector_result_id, 0)
            sql = (f"SELECT DISTINCT(resultdate), resultdate FROM rpt_arc "
                   f"WHERE result_id = '{result_id}' "
                   f"ORDER BY resultdate")
            rows = self.controller.get_rows(sql)
            if rows is not None:
                tools_qt.set_item_data(self.dlg_go2epa_result.cmb_sel_date, rows)
                selector_date = tools_qt.get_item_data(self.dlg_go2epa_result, self.dlg_go2epa_result.cmb_sel_date, 0)
                sql = (f"SELECT DISTINCT(resulttime), resulttime FROM rpt_arc "
                       f"WHERE result_id = '{result_id}' "
                       f"AND resultdate = '{selector_date}' "
                       f"ORDER BY resulttime")
                rows = self.controller.get_rows(sql, add_empty_row=True)
                tools_qt.set_item_data(self.dlg_go2epa_result.cmb_sel_time, rows)

            self.dlg_go2epa_result.rpt_selector_result_id.currentIndexChanged.connect(partial(self.populate_date_time,
                                                                                              self.dlg_go2epa_result.cmb_sel_date))

            self.dlg_go2epa_result.cmb_sel_date.currentIndexChanged.connect(partial(self.populate_time,
                                                                                    self.dlg_go2epa_result.rpt_selector_result_id, self.dlg_go2epa_result.cmb_sel_time))


            # Populate GroupBox Selector compare
            result_id_to_comp = tools_qt.get_item_data(self.dlg_go2epa_result,
                                                       self.dlg_go2epa_result.rpt_selector_result_id, 0)
            sql = (f"SELECT DISTINCT(resultdate), resultdate FROM rpt_arc "
                   f"WHERE result_id = '{result_id_to_comp}' "
                   f"ORDER BY resultdate ")
            rows = self.controller.get_rows(sql)
            if rows:
                tools_qt.set_item_data(self.dlg_go2epa_result.cmb_com_date, rows)
                selector_cmp_date = tools_qt.get_item_data(self.dlg_go2epa_result, self.dlg_go2epa_result.cmb_com_date, 0)
                sql = (f"SELECT DISTINCT(resulttime), resulttime FROM rpt_arc "
                       f"WHERE result_id = '{result_id_to_comp}' "
                       f"AND resultdate = '{selector_cmp_date}' "
                       f"ORDER BY resulttime")
                rows = self.controller.get_rows(sql, add_empty_row=True)
                tools_qt.set_item_data(self.dlg_go2epa_result.cmb_com_time, rows)

            self.dlg_go2epa_result.rpt_selector_compare_id.currentIndexChanged.connect(partial(
                self.populate_date_time, self.dlg_go2epa_result.cmb_com_date))
            self.dlg_go2epa_result.cmb_com_date.currentIndexChanged.connect(partial(self.populate_time,
                                                                                    self.dlg_go2epa_result.rpt_selector_compare_id, self.dlg_go2epa_result.cmb_com_time))

        # Get current data from tables 'rpt_selector_result' and 'rpt_selector_compare'
        sql = "SELECT result_id FROM selector_rpt_main"
        row = self.controller.get_row(sql)
        if row:
            tools_qt.set_combo_itemData(self.dlg_go2epa_result.rpt_selector_result_id, row["result_id"], 0)
        sql = "SELECT result_id FROM selector_rpt_compare"
        row = self.controller.get_row(sql)
        if row:
            tools_qt.set_combo_itemData(self.dlg_go2epa_result.rpt_selector_compare_id, row["result_id"], 0)

        # Open the dialog
        open_dialog(self.dlg_go2epa_result, dlg_name='go2epa_selector')


    def result_selector_accept(self):
        """ Update current values to the table """

        # Set project user
        user = self.controller.get_project_user()

        # Delete previous values
        sql = (f"DELETE FROM selector_rpt_main WHERE cur_user = '{user}';\n"
               f"DELETE FROM selector_rpt_compare WHERE cur_user = '{user}';\n")
        sql += (f"DELETE FROM selector_rpt_main_tstep WHERE cur_user = '{user}';\n"
                f"DELETE FROM selector_rpt_compare_tstep WHERE cur_user = '{user}';\n")
        self.controller.execute_sql(sql)

        # Get new values from widgets of type QComboBox
        rpt_selector_result_id = tools_qt.get_item_data(
            self.dlg_go2epa_result, self.dlg_go2epa_result.rpt_selector_result_id)
        rpt_selector_compare_id = tools_qt.get_item_data(
            self.dlg_go2epa_result, self.dlg_go2epa_result.rpt_selector_compare_id)
        if rpt_selector_result_id not in (None, -1, ''):
            sql = (f"INSERT INTO selector_rpt_main (result_id, cur_user)"
                   f" VALUES ('{rpt_selector_result_id}', '{user}');\n")
            self.controller.execute_sql(sql)

        if rpt_selector_compare_id not in (None, -1, ''):
            sql = (f"INSERT INTO selector_rpt_compare (result_id, cur_user)"
                   f" VALUES ('{rpt_selector_compare_id}', '{user}');\n")
            self.controller.execute_sql(sql)

        if self.project_type == 'ws':
            time_to_show = tools_qt.get_item_data(self.dlg_go2epa_result, self.dlg_go2epa_result.cmb_time_to_show)
            time_to_compare = tools_qt.get_item_data(self.dlg_go2epa_result, self.dlg_go2epa_result.cmb_time_to_compare)
            if time_to_show not in (None, -1, ''):
                sql = (f"INSERT INTO selector_rpt_main_tstep (timestep, cur_user)"
                       f" VALUES ('{time_to_show}', '{user}');\n")
                self.controller.execute_sql(sql)
            if time_to_compare not in (None, -1, ''):
                sql = (f"INSERT INTO selector_rpt_compare_tstep (timestep, cur_user)"
                       f" VALUES ('{time_to_compare}', '{user}');\n")
                self.controller.execute_sql(sql)

        elif self.project_type == 'ud':
            date_to_show = tools_qt.get_item_data(self.dlg_go2epa_result, self.dlg_go2epa_result.cmb_sel_date)
            time_to_show = tools_qt.get_item_data(self.dlg_go2epa_result, self.dlg_go2epa_result.cmb_sel_time)
            date_to_compare = tools_qt.get_item_data(self.dlg_go2epa_result, self.dlg_go2epa_result.cmb_com_date)
            time_to_compare = tools_qt.get_item_data(self.dlg_go2epa_result, self.dlg_go2epa_result.cmb_com_time)
            if date_to_show not in (None, -1, ''):
                sql = (f"INSERT INTO selector_rpt_main_tstep (resultdate, resulttime, cur_user)"
                       f" VALUES ('{date_to_show}', '{time_to_show}', '{user}');\n")
                self.controller.execute_sql(sql)
            if date_to_compare not in (None, -1, ''):
                sql = (f"INSERT INTO selector_rpt_compare_tstep (resultdate, resulttime, cur_user)"
                       f" VALUES ('{date_to_compare}', '{time_to_compare}', '{user}');\n")
                self.controller.execute_sql(sql)

        # Show message to user
        message = "Values has been updated"
        self.controller.show_info(message)
        close_dialog(self.dlg_go2epa_result)


    def populate_time(self, combo_result, combo_time):
        """ Populate combo times """

        result_id = tools_qt.get_item_data(self.dlg_go2epa_result, combo_result)
        if self.project_type == 'ws':
            field = "time"
        else:
            field = "resulttime"

        sql = (f"SELECT DISTINCT {field}, {field} "
               f"FROM rpt_arc "
               f"WHERE result_id ILIKE '{result_id}' "
               f"ORDER BY {field};")

        rows = self.controller.get_rows(sql, add_empty_row=True)
        tools_qt.set_item_data(combo_time, rows)


    def populate_date_time(self, combo_date):

        result_id = tools_qt.get_item_data(self.dlg_go2epa_result, self.dlg_go2epa_result.rpt_selector_result_id, 0)
        sql = (f"SELECT DISTINCT(resultdate), resultdate FROM rpt_arc "
               f"WHERE result_id = '{result_id}' "
               f"ORDER BY resultdate")
        rows = self.controller.get_rows(sql)
        tools_qt.set_item_data(combo_date, rows)

