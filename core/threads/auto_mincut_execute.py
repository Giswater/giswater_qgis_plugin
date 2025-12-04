"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import pyqtSignal

from .task import GwTask
from ..utils import tools_gw
from ...libs import tools_db, tools_qt, tools_log


class GwAutoMincutTask(GwTask):

    task_finished = pyqtSignal(list)

    def __init__(self, description, mincut_class, element_id, action="mincutNetwork", timer=None):

        super().__init__(description)
        self.mincut_class = mincut_class
        self.element_id = element_id
        self.mincut_action = action
        self.exception = None
        self.timer = timer

    def run(self):
        """ Automatic mincut: Execute function 'gw_fct_mincut' """

        super().run()

        try:
            real_mincut_id = tools_qt.get_text(self.mincut_class.dlg_mincut, 'result_mincut_id')
            if self.mincut_class.is_new:
                self.mincut_class.set_id_val()
                self.mincut_class.is_new = False
                sql = ("INSERT INTO om_mincut (mincut_state)"
                       " VALUES (4) RETURNING id;")
                new_mincut_id = tools_db.execute_returning(sql)
                if new_mincut_id[0] < 1:
                    real_mincut_id = 1
                    sql = (f"UPDATE om_mincut SET(id) = (1) "
                           f"WHERE id = {new_mincut_id[0]};")
                    tools_db.execute_sql(sql)
                else:
                    real_mincut_id = new_mincut_id[0]

            tools_qt.set_widget_text(self.mincut_class.dlg_mincut, 'result_mincut_id', real_mincut_id)
            use_planified = tools_qt.is_checked(self.mincut_class.dlg_mincut, 'chk_use_planified')

            mincut_result_type = tools_qt.get_combo_value(self.mincut_class.dlg_mincut, self.mincut_class.dlg_mincut.type, 0)

            date_start_predict = self.mincut_class.dlg_mincut.cbx_date_start_predict.date()
            time_start_predict = self.mincut_class.dlg_mincut.cbx_hours_start_predict.time()
            forecast_start_predict = date_start_predict.toString(
                'yyyy-MM-dd') + " " + time_start_predict.toString('HH:mm:ss')

            # Get prediction date - end
            date_end_predict = self.mincut_class.dlg_mincut.cbx_date_end_predict.date()
            time_end_predict = self.mincut_class.dlg_mincut.cbx_hours_end_predict.time()
            forecast_end_predict = date_end_predict.toString('yyyy-MM-dd') + " " + time_end_predict.toString('HH:mm:ss')

            extras = (f'"action":"{self.mincut_action}", "mincutId":"{real_mincut_id}", "arcId":"{self.element_id}", '
                      f'"usePsectors":"{use_planified}", "mincutType":"{mincut_result_type}", '
                      f'"forecastStart":"{forecast_start_predict}", '
                      f'"forecastEnd":"{forecast_end_predict}"')
            self.body = tools_gw.create_body(extras=extras)
            msg = "Task 'Mincut execute' execute procedure '{0}' with parameters: '{1}', '{2}', '{3}'"
            msg_params = ("gw_fct_setmincut", self.body, f"aux_conn={self.aux_conn}", "is_thread=True",)
            tools_log.log_info(msg, msg_params=msg_params)
            self.complet_result = tools_gw.execute_procedure('gw_fct_setmincut', self.body, aux_conn=self.aux_conn, is_thread=True)
            if self.isCanceled():
                return False
            if not self.complet_result or self.complet_result['status'] == 'Failed':
                return False

            self.mincut_class._reset_form_has_changes()

            return True

        except KeyError as e:
            self.exception = e
            return False

    def finished(self, result):

        super().finished(result)

        sql = "SELECT gw_fct_setmincut("
        if self.body:
            sql += f"{self.body}"
        sql += ");"
        msg = "Task 'Mincut execute' manage json response with parameters: '{0}', '{1}', '{2}'"
        msg_params = (self.complet_result, sql, "None",)
        tools_log.log_info(msg, msg_params=msg_params)
        tools_gw.manage_json_response(self.complet_result, sql, None)

        if self.timer:
            self.timer.stop()
        # If user cancel task
        if self.isCanceled():
            self.task_finished.emit([False, self.complet_result])

        # If sql function return null
        elif self.complet_result is None:
            self.task_finished.emit([False, self.complet_result])
            msg = "Error. Database returned null. Check postgres function '{0}'"
            msg_params = ("gw_fct_setmincut",)
            tools_log.log_warning(msg, msg_params=msg_params)

        # Handle python exception
        elif self.exception is not None:
            msg = f'''<b>{tools_qt.tr('key')}: </b>{self.exception}<br>'''
            msg += f'''<b>{tools_qt.tr('key container')}: </b>'body/data/ <br>'''
            msg += f'''<b>{tools_qt.tr('Python file')}: </b>{__name__} <br>'''
            msg += f'''<b>{tools_qt.tr('Python function')}:</b> {self.__class__.__name__} <br>'''
            title = "Key on returned json from ddbb is missed."
            tools_qt.show_exception_message(title, msg)
            self.task_finished.emit([False, self.complet_result])

        # Task finished but postgres function failed
        elif self.complet_result.get('status') == 'Failed':
            self.task_finished.emit([False, self.complet_result])
            tools_gw.manage_json_exception(self.complet_result)

        # Task finished with Accepted result
        elif 'mincutOverlap' in self.complet_result or self.complet_result.get('status') == 'Accepted':
            self.task_finished.emit([True, self.complet_result])
