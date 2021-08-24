"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from ..dialog import GwAction
from ...ui.ui_manager import GwGo2EpaSelectorUi
from ...utils import tools_gw
from .... import global_vars
from ....lib import tools_qt, tools_db, tools_qgis


class GwGo2EpaSelectorButton(GwAction):
    """ Button 29: Go2epa selector """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.project_type = global_vars.project_type


    def clicked_event(self):
        """ Button 29: Epa result selector """

        self._open_go2epa_selector()


    # region private functions

    def _open_go2epa_selector(self):

        # Create the dialog and signals
        self.dlg_go2epa_result = GwGo2EpaSelectorUi('go2epa')
        tools_gw.load_settings(self.dlg_go2epa_result)
        if self.project_type == 'ud':
            tools_qt.remove_tab(self.dlg_go2epa_result.tabWidget, "tab_time")
        if self.project_type == 'ws':
            tools_qt.remove_tab(self.dlg_go2epa_result.tabWidget, "tab_datetime")
        self.dlg_go2epa_result.btn_accept.clicked.connect(self._result_selector_accept)
        self.dlg_go2epa_result.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_go2epa_result))
        self.dlg_go2epa_result.rejected.connect(partial(tools_gw.close_dialog, self.dlg_go2epa_result))

        # Set values from widgets of type QComboBox
        sql = ("SELECT DISTINCT(result_id), result_id "
               "FROM v_ui_rpt_cat_result WHERE status = 'COMPLETED' ORDER BY result_id")
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_go2epa_result.rpt_selector_result_id, rows)
        tools_qt.set_combo_value(self.dlg_go2epa_result.rpt_selector_result_id,
                                 tools_gw.get_config_parser('btn_go2epa_selector', 'rpt_selector_result', 'user',
                                                            'session'), 0)

        rows = tools_db.get_rows(sql, add_empty_row=True)
        tools_qt.fill_combo_values(self.dlg_go2epa_result.rpt_selector_compare_id, rows)
        tools_qt.set_combo_value(self.dlg_go2epa_result.rpt_selector_result_id,
                                 tools_gw.get_config_parser('btn_go2epa_selector', 'rpt_selector_compare', 'user',
                                                            'session'), 0)

        if self.project_type == 'ws':

            sql = ("SELECT DISTINCT time, time FROM rpt_arc "
                   "WHERE result_id ILIKE '%%' ORDER BY time")
            rows = tools_db.get_rows(sql, add_empty_row=True)
            tools_qt.fill_combo_values(self.dlg_go2epa_result.cmb_time_to_show, rows)
            tools_qt.fill_combo_values(self.dlg_go2epa_result.cmb_time_to_compare, rows)

            tools_qt.set_combo_value(self.dlg_go2epa_result.cmb_time_to_show,
                                     tools_gw.get_config_parser('btn_go2epa_selector', 'time_to_show', 'user',
                                                                'session', prefix=False), 0)
            tools_qt.set_combo_value(self.dlg_go2epa_result.cmb_time_to_compare,
                                     tools_gw.get_config_parser('btn_go2epa_selector', 'time_to_compare', 'user',
                                                                'session', prefix=False), 0)

            self.dlg_go2epa_result.rpt_selector_result_id.currentIndexChanged.connect(partial(
                self._populate_time, self.dlg_go2epa_result.rpt_selector_result_id, self.dlg_go2epa_result.cmb_time_to_show))
            self.dlg_go2epa_result.rpt_selector_compare_id.currentIndexChanged.connect(partial(
                self._populate_time, self.dlg_go2epa_result.rpt_selector_compare_id, self.dlg_go2epa_result.cmb_time_to_compare))

        elif self.project_type == 'ud':

            # Populate GroupBox Selector date
            result_id = tools_qt.get_combo_value(self.dlg_go2epa_result, self.dlg_go2epa_result.rpt_selector_result_id, 0)
            sql = (f"SELECT DISTINCT(resultdate), resultdate FROM rpt_arc "
                   f"WHERE result_id = '{result_id}' "
                   f"ORDER BY resultdate")
            rows = tools_db.get_rows(sql)
            if rows is not None:
                tools_qt.fill_combo_values(self.dlg_go2epa_result.cmb_sel_date, rows)
                selector_date = tools_qt.get_combo_value(self.dlg_go2epa_result, self.dlg_go2epa_result.cmb_sel_date, 0)
                sql = (f"SELECT DISTINCT(resulttime), resulttime FROM rpt_arc "
                       f"WHERE result_id = '{result_id}' "
                       f"AND resultdate = '{selector_date}' "
                       f"ORDER BY resulttime")
                rows = tools_db.get_rows(sql, add_empty_row=True)
                tools_qt.fill_combo_values(self.dlg_go2epa_result.cmb_sel_time, rows)

                tools_qt.set_combo_value(self.dlg_go2epa_result.cmb_sel_date,
                                         tools_gw.get_config_parser('btn_go2epa_selector', 'sel_date', 'user',
                                                                    'session', prefix=False), 0)
                tools_qt.set_combo_value(self.dlg_go2epa_result.cmb_sel_time,
                                         tools_gw.get_config_parser('btn_go2epa_selector', 'sel_time', 'user',
                                                                    'session', prefix=False), 0)

            self.dlg_go2epa_result.rpt_selector_result_id.currentIndexChanged.connect(
                partial(self._populate_date_time, self.dlg_go2epa_result.cmb_sel_date))

            self.dlg_go2epa_result.cmb_sel_date.currentIndexChanged.connect(
                partial(self._populate_time, self.dlg_go2epa_result.rpt_selector_result_id,
                        self.dlg_go2epa_result.cmb_sel_time))

            # Populate GroupBox Selector compare
            result_id_to_comp = tools_qt.get_combo_value(self.dlg_go2epa_result,
                                                         self.dlg_go2epa_result.rpt_selector_result_id, 0)
            sql = (f"SELECT DISTINCT(resultdate), resultdate FROM rpt_arc "
                   f"WHERE result_id = '{result_id_to_comp}' "
                   f"ORDER BY resultdate ")
            rows = tools_db.get_rows(sql)
            if rows:
                tools_qt.fill_combo_values(self.dlg_go2epa_result.cmb_com_date, rows)
                selector_cmp_date = tools_qt.get_combo_value(self.dlg_go2epa_result, self.dlg_go2epa_result.cmb_com_date, 0)
                sql = (f"SELECT DISTINCT(resulttime), resulttime FROM rpt_arc "
                       f"WHERE result_id = '{result_id_to_comp}' "
                       f"AND resultdate = '{selector_cmp_date}' "
                       f"ORDER BY resulttime")
                rows = tools_db.get_rows(sql, add_empty_row=True)
                tools_qt.fill_combo_values(self.dlg_go2epa_result.cmb_com_time, rows)

                tools_qt.set_combo_value(self.dlg_go2epa_result.cmb_com_date,
                                         tools_gw.get_config_parser('btn_go2epa_selector', 'com_date', 'user',
                                                                    'session', prefix=False), 0)
                tools_qt.set_combo_value(self.dlg_go2epa_result.cmb_com_time,
                                         tools_gw.get_config_parser('btn_go2epa_selector', 'com_time', 'user',
                                                                    'session', prefix=False), 0)

            self.dlg_go2epa_result.rpt_selector_compare_id.currentIndexChanged.connect(partial(
                self._populate_date_time, self.dlg_go2epa_result.cmb_com_date))
            self.dlg_go2epa_result.cmb_com_date.currentIndexChanged.connect(partial(
                self._populate_time, self.dlg_go2epa_result.rpt_selector_compare_id, self.dlg_go2epa_result.cmb_com_time))

        # Get current data from tables 'rpt_selector_result' and 'rpt_selector_compare'
        sql = "SELECT result_id FROM selector_rpt_main"
        row = tools_db.get_row(sql)
        if row:
            tools_qt.set_combo_value(self.dlg_go2epa_result.rpt_selector_result_id, row["result_id"], 0)
        sql = "SELECT result_id FROM selector_rpt_compare"
        row = tools_db.get_row(sql)
        if row:
            tools_qt.set_combo_value(self.dlg_go2epa_result.rpt_selector_compare_id, row["result_id"], 0)

        # Open the dialog
        tools_gw.open_dialog(self.dlg_go2epa_result, dlg_name='go2epa_selector')


    def _result_selector_accept(self):
        """ Update current values to the table """

        # Set project user
        user = global_vars.current_user

        # Delete previous values
        sql = (f"DELETE FROM selector_rpt_main WHERE cur_user = '{user}';\n"
               f"DELETE FROM selector_rpt_compare WHERE cur_user = '{user}';\n")
        sql += (f"DELETE FROM selector_rpt_main_tstep WHERE cur_user = '{user}';\n"
                f"DELETE FROM selector_rpt_compare_tstep WHERE cur_user = '{user}';\n")
        tools_db.execute_sql(sql)

        # Get new values from widgets of type QComboBox
        rpt_selector_result_id = tools_qt.get_combo_value(
            self.dlg_go2epa_result, self.dlg_go2epa_result.rpt_selector_result_id)
        rpt_selector_compare_id = tools_qt.get_combo_value(
            self.dlg_go2epa_result, self.dlg_go2epa_result.rpt_selector_compare_id)

        if rpt_selector_result_id not in (None, -1, ''):
            sql = (f"INSERT INTO selector_rpt_main (result_id, cur_user)"
                   f" VALUES ('{rpt_selector_result_id}', '{user}');\n")
            tools_db.execute_sql(sql)

            tools_gw.set_config_parser('btn_go2epa_selector', 'rpt_selector_result', f'{rpt_selector_result_id}')

        if rpt_selector_compare_id not in (None, -1, ''):
            sql = (f"INSERT INTO selector_rpt_compare (result_id, cur_user)"
                   f" VALUES ('{rpt_selector_compare_id}', '{user}');\n")
            tools_db.execute_sql(sql)

            tools_gw.set_config_parser('btn_go2epa_selector', 'rpt_selector_compare', f'{rpt_selector_compare_id}')

        if self.project_type == 'ws':
            time_to_show = tools_qt.get_combo_value(self.dlg_go2epa_result, self.dlg_go2epa_result.cmb_time_to_show)
            time_to_compare = tools_qt.get_combo_value(self.dlg_go2epa_result, self.dlg_go2epa_result.cmb_time_to_compare)
            if time_to_show not in (None, -1, ''):
                sql = (f"INSERT INTO selector_rpt_main_tstep (timestep, cur_user)"
                       f" VALUES ('{time_to_show}', '{user}');\n")
                tools_db.execute_sql(sql)

                tools_gw.set_config_parser('btn_go2epa_selector', 'time_to_show', f'{time_to_show}', prefix=False)

            if time_to_compare not in (None, -1, ''):
                sql = (f"INSERT INTO selector_rpt_compare_tstep (timestep, cur_user)"
                       f" VALUES ('{time_to_compare}', '{user}');\n")
                tools_db.execute_sql(sql)

                tools_gw.set_config_parser('btn_go2epa_selector', 'time_to_compare', f'{time_to_compare}', prefix=False)

        elif self.project_type == 'ud':
            sel_date = tools_qt.get_combo_value(self.dlg_go2epa_result, self.dlg_go2epa_result.cmb_sel_date)
            sel_time = tools_qt.get_combo_value(self.dlg_go2epa_result, self.dlg_go2epa_result.cmb_sel_time)
            com_date = tools_qt.get_combo_value(self.dlg_go2epa_result, self.dlg_go2epa_result.cmb_com_date)
            com_time = tools_qt.get_combo_value(self.dlg_go2epa_result, self.dlg_go2epa_result.cmb_com_time)

            if sel_date not in (None, -1, ''):
                sql = (f"INSERT INTO selector_rpt_main_tstep (resultdate, resulttime, cur_user)"
                       f" VALUES ('{sel_date}', '{sel_time}', '{user}');\n")
                tools_db.execute_sql(sql)

                tools_gw.set_config_parser('btn_go2epa_selector', 'sel_date', f'{sel_date}', prefix=False)
                tools_gw.set_config_parser('btn_go2epa_selector', 'sel_time', f'{sel_time}', prefix=False)

            if com_date not in (None, -1, ''):
                sql = (f"INSERT INTO selector_rpt_compare_tstep (resultdate, resulttime, cur_user)"
                       f" VALUES ('{com_date}', '{com_time}', '{user}');\n")
                tools_db.execute_sql(sql)

                tools_gw.set_config_parser('btn_go2epa_selector', 'com_date', f'{com_date}', prefix=False)
                tools_gw.set_config_parser('btn_go2epa_selector', 'com_time', f'{com_time}', prefix=False)

        # Show message to user
        message = "Values has been updated"
        tools_qgis.show_info(message)
        tools_gw.close_dialog(self.dlg_go2epa_result)


    def _populate_time(self, combo_result, combo_time):
        """ Populate combo times """

        result_id = tools_qt.get_combo_value(self.dlg_go2epa_result, combo_result)
        if self.project_type == 'ws':
            field = "time"
        else:
            field = "resulttime"

        sql = (f"SELECT DISTINCT {field}, {field} "
               f"FROM rpt_arc "
               f"WHERE result_id ILIKE '{result_id}' "
               f"ORDER BY {field};")

        rows = tools_db.get_rows(sql, add_empty_row=True)
        tools_qt.fill_combo_values(combo_time, rows)


    def _populate_date_time(self, combo_date):

        result_id = tools_qt.get_combo_value(self.dlg_go2epa_result, self.dlg_go2epa_result.rpt_selector_result_id, 0)
        sql = (f"SELECT DISTINCT(resultdate), resultdate FROM rpt_arc "
               f"WHERE result_id = '{result_id}' "
               f"ORDER BY resultdate")
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(combo_date, rows)

    # endregion