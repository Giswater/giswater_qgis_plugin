"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import pyqtSignal

from .task import GwTask
from ..utils import tools_gw
from ...lib import tools_db, tools_qt, tools_log


class GwAutoMincutTask(GwTask):

    task_finished = pyqtSignal(list)

    def __init__(self, description, mincut_class, element_id):

        super().__init__(description)
        self.mincut_class = mincut_class
        self.element_id = element_id
        self.exception = None


    def run(self):
        """ Automatic mincut: Execute function 'gw_fct_mincut' """

        super().run()

        try:
            real_mincut_id = tools_qt.get_text(self.mincut_class.dlg_mincut, 'result_mincut_id')
            if self.mincut_class.is_new:
                self.mincut_class.set_id_val()
                self.mincut_class.is_new = False
                sql = ("INSERT INTO om_mincut (mincut_state)"
                       " VALUES (0) RETURNING id;")
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
            extras = (f'"action":"mincutNetwork", "mincutId":"{real_mincut_id}", "arcId":"{self.element_id}", '
                      f'"usePsectors":"{use_planified}"')
            self.body = tools_gw.create_body(extras=extras)
            self.complet_result = tools_gw.execute_procedure('gw_fct_setmincut', self.body, aux_conn=self.aux_conn, is_thread=True)
            if self.isCanceled():
                return False
            if not self.complet_result or self.complet_result['status'] == 'Failed':
                return False

            return True

        except KeyError as e:
            self.exception = e
            return False


    def finished(self, result):

        super().finished(result)

        sql = f"SELECT gw_fct_setmincut("
        if self.body:
            sql += f"{self.body}"
        sql += f");"
        tools_gw.manage_json_response(self.complet_result, sql, None)

        # If user cancel task
        if self.isCanceled():
            self.task_finished.emit([False, self.complet_result])

        # If sql function return null
        elif self.complet_result is None:
            self.task_finished.emit([False, self.complet_result])
            msg = f"Error. Database returned null. Check postgres function 'gw_fct_setmincut'"
            tools_log.log_warning(msg)

        # Handle python exception
        elif self.exception is not None:
            msg = f"<b>Key: </b>{self.exception}<br>"
            msg += f"<b>key container: </b>'body/data/ <br>"
            msg += f"<b>Python file: </b>{__name__} <br>"
            msg += f"<b>Python function:</b> {self.__class__.__name__} <br>"
            tools_qt.show_exception_message("Key on returned json from ddbb is missed.", msg)
            self.task_finished.emit([False, self.complet_result])

        # Task finished but postgres function failed
        elif 'status' in self.complet_result and self.complet_result['status'] == 'Failed':
            self.task_finished.emit([False, self.complet_result])
            tools_gw.manage_json_exception(self.complet_result)

        # Task finished with Accepted result
        elif 'mincutOverlap' in self.complet_result or self.complet_result['status'] == 'Accepted':
            self.task_finished.emit([True, self.complet_result])
