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
from ...libs import tools_qgis, tools_log, tools_qt


class GwToggleValveTask(GwTask):

    task_finished = pyqtSignal(list)

    def __init__(self, description='', params=None):

        super().__init__(description)
        self.params = params
        self.result = None
        self.json_result = None

    def run(self):

        super().run()

        body = self.params['body']
        # Execute setfields
        self.json_result = tools_gw.execute_procedure('gw_fct_setfields', body, is_thread=True, aux_conn=self.aux_conn)
        if not self.json_result:
            tools_log.log_info("Function gw_fct_setfields failed")
            return False

        # Execute mapzonestrigger
        if self.json_result and self.json_result['status'] != 'Failed':
            self.json_result = tools_gw.execute_procedure('gw_fct_setmapzonestrigger', body, is_thread=True, aux_conn=self.aux_conn)
            if not self.json_result:
                tools_log.log_info("Function gw_fct_setmapzonestrigger failed")
                return False
            tools_log.log_info("Function gw_fct_setmapzonestrigger finished successfully")

        # Refresh canvas
        tools_qgis.refresh_map_canvas()

        return True

    def finished(self, result):

        super().finished(result)

        if self.isCanceled():
            self.setProgress(100)
            return

        # Handle exception
        if self.exception is not None:
            msg = f"<b>{tools_qt.tr("key")}: </b>{self.exception}<br>"
            msg += f"<b>{tools_qt.tr("key container")}: </b>'body/data/ <br>"
            msg += f"<b>{tools_qt.tr("Python file")}: </b>{__name__} <br>"
            msg += f"<b>{tools_qt.tr("Python function")}:</b> {self.__class__.__name__} <br>"
            title = "Key on returned json from ddbb is missed."
            tools_qt.show_exception_message(title, msg)
            return

        if self.json_result:
            if self.json_result['level'] in (1, 2):
                tools_qt.show_info_box(self.json_result['text'])
            if self.json_result['level'] == 0:
                tools_qgis.show_info(self.json_result['text'])

        self.setProgress(100)
