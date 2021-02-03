"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-

from qgis.PyQt.QtWidgets import QComboBox, QCheckBox, QDoubleSpinBox, QSpinBox, QWidget, QLineEdit
from qgis.PyQt.QtCore import pyqtSignal
from qgis.core import QgsTask
from qgis.gui import QgsDateTimeEdit

from .task import GwTask
from ..utils import tools_gw
from ...lib import tools_db, tools_log, tools_qgis, tools_qt
from ... import global_vars


class GwMincutTask(GwTask):
    """ This shows how to subclass QgsTask """

    task_finished = pyqtSignal(list)

    def __init__(self, description, mincut_class, element_id):
        super().__init__(description, QgsTask.CanCancel)
        self.mincut_class = mincut_class
        self.element_id = element_id
        self.exception = None


    def run(self):
        """ Automatic mincut: Execute function 'gw_fct_mincut' """
        try:
            real_mincut_id = tools_qt.get_text(self.mincut_class.dlg_mincut, self.mincut_class.dlg_mincut.result_mincut_id)
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

            tools_qt.set_widget_text(self.mincut_class.dlg_mincut, self.mincut_class.dlg_mincut.result_mincut_id, real_mincut_id)

            extras = f'"action":"mincutNetwork", '
            extras += f'"mincutId":"{real_mincut_id}", "arcId":"{self.element_id}"'
            body = tools_gw.create_body(extras=extras)
            self.complet_result = tools_gw.execute_procedure('gw_fct_setmincut', body)
            return True
        except KeyError as e:
            self.exception = e
            return False


    def finished(self, result):
        if self.exception is not None:
            msg = f"<b>Key: </b>{self.exception}<br>"
            msg += f"<b>key container: </b>'body/data/ <br>"
            msg += f"<b>Python file: </b>{__name__} <br>"
            msg += f"<b>Python function:</b> {self.__class__.__name__} <br>"
            tools_qt.show_exception_message("Key on returned json from ddbb is missed.", msg)
            self.task_finished.emit([False, self.complet_result])
        elif self.complet_result in (False, None) or ('status' in self.complet_result and self.complet_result['status'] == 'Failed'):
            self.task_finished.emit([False, self.complet_result])
        elif 'mincutOverlap' in self.complet_result or self.complet_result['status'] == 'Accepted':
            self.task_finished.emit([True, self.complet_result])

    def cancel(self):
        super().cancel()