"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import json
import os
import re
import subprocess
import importlib

from qgis.PyQt.QtCore import pyqtSignal

from .epa_file_manager import GwEpaFileManager
from ..utils import tools_gw
from ... import global_vars
from ...libs import lib_vars, tools_log, tools_qt, tools_db, tools_qgis, tools_os
from .task import GwTask


class GwGo2IberTask(GwTask):
    """ This shows how to subclass QgsTask """

    fake_progress = pyqtSignal()
    step_completed = pyqtSignal(dict, str)

    def __init__(self, description, go2iber, timer=None):

        print("go2iber init 00")
        super().__init__(description)
        self.go2iber = go2iber
        self.json_result = None
        self.rpt_result = None
        self.fid = 140
        self.function_name = None
        self.timer = timer
        print("go2iber init 10")
        self.initialize_variables()
        print("go2iber init 20")
        self.set_variables_from_go2iber()
        print("go2iber init 30")
        self.drain_execute_model = importlib.import_module('.execute_model', package=f'{self.drain_folder}.core.threads')
        print("go2iber init 40")

    def initialize_variables(self):

        self.exception = None
        self.error_msg = None
        self.message = None
        self.common_msg = ""
        self.function_failed = False
        self.complet_result = None
        self.replaced_velocities = False

    def set_variables_from_go2iber(self):
        """ Set variables from object Go2Iber """

        self.dlg_go2iber = self.go2iber.dlg_go2iber
        self.result_name = self.go2iber.result_name
        self.folder_path = self.go2iber.folder_path
        self.drain_folder = self.go2iber.drain_folder

    def run(self):

        super().run()

        print("go2iber run 00")
        self.step_completed.emit({"message": {"level": 1, "text": "GO2IBER - Work in progress"}}, "\n")
        self.step_completed.emit({"message": {"level": 1, "text": "--------------------------"}}, "\n")

        print("go2iber run 10")
        self.initialize_variables()
        print("go2iber run 20")
        # TODO:
        # - Generate INP file with Giswater (go2iber)
        self.go2epa_task = GwEpaFileManager("Go2Epa", self.dlg_go2iber)
        self.go2epa_task.go2epa_export_inp = True
        self.go2epa_task.go2epa_execute_epa = True  # TODO: Check if this is necessary
        self.go2epa_task.go2epa_import_result = True  # TODO: Check if this is necessary
        self.go2epa_task.result_name = self.result_name
        self.go2epa_task.file_inp = self.folder_path + os.sep + "Iber_SWMM.inp"
        self.go2epa_task.file_rpt = self.folder_path + os.sep + "Iber_SWMM.rpt"  # TODO: Check if this is necessary
        print("go2iber run 30")
        self.go2epa_task.main_process()
        print("go2iber run 40")

        # - Execute model with DRAIN plugin
        # params = {
        #     "folder_path": self.folder_path,
        #     "do_generate_inp": False,
        #     "do_export": True,
        #     "do_run": True,
        #     "do_import": True,
        # }
        # self.drain_execute_model = self.dr_execute_model.DrExecuteModel("Execute Drain Model", params)
        # self.drain_execute_model.run()

        # - Import results to DRAIN mainly, but rpt to Giswater

        status = True

        return status

    def finished(self, result):

        super().finished(result)

        self.dlg_go2iber.btn_cancel.setEnabled(False)
        self.dlg_go2iber.btn_accept.setEnabled(True)

        if self.timer:
            self.timer.stop()
        if self.isCanceled():
            return

        if self.function_failed:
            if self.json_result is None or not self.json_result:
                tools_log.log_warning("Function failed finished")
            if self.complet_result:
                if self.complet_result.get('status') == "Failed":
                    tools_gw.manage_json_exception(self.complet_result)
            if self.rpt_result:
                if "Failed" in self.rpt_result.get('status'):
                    tools_gw.manage_json_exception(self.rpt_result)

        if self.error_msg:
            title = f"Task aborted - {self.description()}"
            tools_qt.show_info_box(self.error_msg, title=title)
            return

        if self.exception:
            title = f"Task aborted - {self.description()}"
            tools_qt.show_info_box(self.exception, title=title)
            raise self.exception

        # If Database exception, show dialog after task has finished
        if lib_vars.session_vars['last_error']:
            tools_qt.show_exception_message(msg=lib_vars.session_vars['last_error_msg'])

    def cancel(self):

        tools_qgis.show_info(f"Task canceled - {self.description()}")
        self._close_file()
        super().cancel()
