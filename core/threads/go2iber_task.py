"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
import importlib

from qgis.PyQt.QtCore import pyqtSignal
from qgis.PyQt.QtWidgets import QTextEdit
from qgis.core import QgsApplication

from .epa_file_manager import GwEpaFileManager
from ..utils import tools_gw
from ...libs import lib_vars, tools_log, tools_qt, tools_qgis
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
        self.ig_execute_model = importlib.import_module('.execute_model', package=f'{self.ibergis_folder}.core.threads')
        print("go2iber init 40")
        self.ig_feedback_class = importlib.import_module('.feedback', package=f'{self.ibergis_folder}.core.utils')
        self.cur_process = None
        self.cur_text = None
        self.ig_feedback = None

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
        self.ibergis_folder = self.go2iber.ibergis_folder

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
        self.go2epa_task.go2epa_execute_epa = False
        self.go2epa_task.go2epa_import_result = False
        self.go2epa_task.result_name = self.result_name
        self.go2epa_task.file_inp = self.folder_path + os.sep + "Iber_SWMM.inp"
        self.go2epa_task.file_rpt = self.folder_path + os.sep + "Iber_SWMM.rpt"  # TODO: Check if this is necessary
        print("go2iber run 30")
        # Create folders path
        os.makedirs(self.folder_path, exist_ok=True)
        self.go2epa_task.main_process()
        print("go2iber run 40")

        # - Execute model with IBERGIS plugin
        params = {
            "dialog": self.dlg_go2iber,
            "folder_path": self.folder_path,
            "do_generate_inp": False,
            "do_export": True,
            "do_run": True,
            "do_import": True,
            "do_write_inlets": False,
            "pinlet_layer": None,  # TODO: Generate pinlet layer from pgully
        }
        self.ig_feedback = self.ig_feedback_class.Feedback()
        self.ig_execute_model = self.ig_execute_model.DrExecuteModel("Execute IberGIS Model", params, self.ig_feedback)
        self.ig_execute_model.progress_changed.connect(self._progress_changed)
        self.ig_feedback.progressChanged.connect(self._progress_changed)
        # Show tab log
        tools_gw.set_tabs_enabled(self.dlg_go2iber)
        self.dlg_go2iber.mainTab.setCurrentIndex(1)

        self.ig_execute_model.run()

        # - Import results to IBERGIS mainly, but rpt to Giswater

        status = True

        return status

    def _progress_changed(self, process, progress, text, new_line):
        # Progress bar
        if progress is not None:
            self.dlg_go2iber.progress_bar.setValue(progress)

        # TextEdit log
        txt_infolog = self.dlg_go2iber.findChild(QTextEdit, 'tab_log_txt_infolog')
        cur_text = tools_qt.get_text(self.dlg_go2iber, txt_infolog, return_string_null=False)
        if process and process != self.cur_process:
            cur_text = f"{cur_text}\n" \
                       f"--------------------\n" \
                       f"{process}\n" \
                       f"--------------------\n\n"
            self.cur_process = process
            self.cur_text = None

        if self.cur_text:
            cur_text = self.cur_text

        end_line = '\n' if new_line else ''
        if text:
            txt_infolog.setText(f"{cur_text}{text}{end_line}")
        else:
            txt_infolog.setText(f"{cur_text}{end_line}")
        txt_infolog.show()
        # Scroll to the bottom
        scrollbar = txt_infolog.verticalScrollBar()
        scrollbar.setValue(scrollbar.maximum())

    def finished(self, result):

        super().finished(result)

        self.dlg_go2iber.btn_cancel.setEnabled(False)
        self.dlg_go2iber.btn_accept.setEnabled(True)

        if not self.isCanceled() and result:
            self.ig_execute_model._create_results_folder()
            self.ig_execute_model._delete_raster_results()

        if self.timer:
            self.timer.stop()
        if self.isCanceled():
            return

        if self.function_failed:
            if self.json_result is None or not self.json_result:
                msg = "Function failed finished"
                tools_log.log_warning(msg)
            if self.complet_result:
                if self.complet_result.get('status') == "Failed":
                    tools_gw.manage_json_exception(self.complet_result)
            if self.rpt_result:
                if "Failed" in self.rpt_result.get('status'):
                    tools_gw.manage_json_exception(self.rpt_result)

        if self.error_msg:
            title = "Task aborted - {0}"
            title_params = (self.description(),)
            tools_qt.show_info_box(self.error_msg, title=title, title_params=title_params)
            return

        if self.exception:
            title = "Task aborted - {0}"
            title_params = (self.description(),)
            tools_qt.show_info_box(self.exception, title=title, title_params=title_params)
            raise self.exception

        # If Database exception, show dialog after task has finished
        if lib_vars.session_vars['last_error']:
            tools_qt.show_exception_message(msg=lib_vars.session_vars['last_error_msg'])

    def cancel(self):
        msg = "Task canceled - {0}"
        msg_params = (self.description(),)
        tools_qgis.show_info(msg, msg_params=msg_params)
        self._close_file()
        super().cancel()
