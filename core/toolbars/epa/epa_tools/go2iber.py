"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import importlib

from datetime import timedelta
from functools import partial
from pathlib import Path
from time import time
from typing import Optional, Tuple

from qgis.core import QgsApplication
from qgis.PyQt.QtCore import Qt, QTimer
from qgis.PyQt.QtWidgets import (
    QComboBox,
    QLabel,
    QTableWidget,
    QTableWidgetItem,
    QTextEdit,
)
from sip import isdeleted

from ..go2epa_btn import GwGo2EpaButton
from ....ui.dialog import GwDialog
from ....ui.ui_manager import GwGo2IberUi, GwGo2EpaUI
from ....threads.import_inp.import_epanet_task import GwImportInpTask
from ....threads.go2iber_task import GwGo2IberTask
from ....utils import tools_gw
from .....libs import tools_db, tools_qgis, tools_qt

CREATE_NEW = "Create new"
TESTING_MODE = False


class Go2Iber:
    """Button 47: Go2Iber"""

    def __init__(self) -> None:
        self.drain_folder = tools_qgis.get_plugin_folder("drain")
        self.dr_options_class = importlib.import_module('.options', package=f'{self.drain_folder}.core.shared') if self.drain_folder else None

    def clicked_event(self) -> None:
        """Start the Import INP workflow"""

        print("go2iber")
        self.dlg_go2iber = GwGo2IberUi(self)
        tools_gw.load_settings(self.dlg_go2iber)
        if self.dr_options_class is None:
            msg = "DRAIN plugin not found"
            tools_qgis.show_warning(msg)
            return

        # Connect signals
        self.dlg_go2iber.btn_path.clicked.connect(partial(tools_qt.get_folder_path, self.dlg_go2iber, self.dlg_go2iber.txt_path))
        self.dlg_go2iber.btn_swmm_options.clicked.connect(partial(self._btn_swmm_options_clicked))
        self.dlg_go2iber.btn_iber_options.clicked.connect(partial(self._btn_iber_options_clicked))
        self.dlg_go2iber.btn_accept.clicked.connect(partial(self._btn_accept_clicked))
        self.dlg_go2iber.btn_cancel.clicked.connect(partial(self._btn_cancel_clicked))

        # Open dialog
        msg = "This tool is still in developement, it might not work as intended."
        tools_qgis.show_warning(msg, dialog=self.dlg_go2iber)  # TODO: remove this
        tools_gw.open_dialog(self.dlg_go2iber, dlg_name='go2iber')

    def _btn_swmm_options_clicked(self):
        # tools_gw.execute_class_function(GwGo2EpaUI, '_go2epa_options')
        self.go2epa_btn = GwGo2EpaButton(None, None, None, None, None)
        self.go2epa_btn._go2epa_options()

    def _btn_iber_options_clicked(self):
        if self.dr_options_class is None:
            msg = "DRAIN plugin not found"
            tools_qgis.show_warning(msg)
            return
        self.dr_options = self.dr_options_class.DrOptions(tabs_to_show=["tab_main", "tab_rpt_iber", "tab_plugins"])
        self.dr_options.open_options_dlg()

    def _btn_accept_clicked(self):
        """ Save INP, RPT and result name"""

        # Manage if task is already running
        if hasattr(self, 'go2iber_task') and self.go2iber_task is not None:
            try:
                if self.go2iber_task.isActive():
                    msg = "Go2Iber task is already active!"
                    tools_qgis.show_warning(msg)
                    return
            except RuntimeError:
                pass

        # Save user values
        self._save_user_values()

        self.dlg_go2iber.tab_log_txt_infolog.clear()
        self.dlg_go2iber.txt_result_name.setStyleSheet(None)
        self.dlg_go2iber.txt_path.setStyleSheet(None)
        status = self._check_fields()
        if status is False:
            return

        # Get widgets values
        self.result_name = tools_qt.get_text(self.dlg_go2iber, self.dlg_go2iber.txt_result_name, False, False)
        self.folder_path = tools_qt.get_text(self.dlg_go2iber, self.dlg_go2iber.txt_path)

        # Check for sector selector
        sql = "SELECT sector_id FROM selector_sector WHERE sector_id > 0 LIMIT 1"
        row = tools_db.get_row(sql)
        if row is None:
            msg = "You need to select some sector"
            tools_qt.show_info_box(msg)
            return

        self.dlg_go2iber.btn_accept.setEnabled(False)
        self.dlg_go2iber.btn_cancel.setEnabled(True)

        # Create timer
        self.t0 = time()
        self.timer = QTimer()
        self.timer.timeout.connect(partial(self._calculate_elapsed_time, self.dlg_go2iber))
        self.timer.start(1000)

        # Set background task 'Go2Iber'
        description = "Go2Iber"
        # TODO: Thread that
        #         - Generate INP file with Giswater (go2iber)
        #         - Execute model with DRAIN plugin
        #         - Import results to DRAIN mainly, but rpt to Giswater
        self.go2iber_task = GwGo2IberTask(description, self, timer=self.timer)
        # self.go2iber_task.step_completed.connect(self.step_completed)
        QgsApplication.taskManager().addTask(self.go2iber_task)
        QgsApplication.taskManager().triggerTask(self.go2iber_task)

    def _btn_cancel_clicked(self):

        tools_gw.close_dialog(self.dlg_go2iber)

    def _save_user_values(self):
        """ Save dialog widgets' values """

        txt_result_name = f"{tools_qt.get_text(self.dlg_go2iber, 'txt_result_name', return_string_null=False)}"
        tools_gw.set_config_parser('btn_go2iber', 'go2iber_result_name', f"{txt_result_name}")
        txt_path = f"{tools_qt.get_text(self.dlg_go2iber, 'txt_path', return_string_null=False)}"
        tools_gw.set_config_parser('btn_go2iber', 'go2iber_path', f"{txt_path}")

    def _check_fields(self):

        folder_path = tools_qt.get_text(self.dlg_go2iber, self.dlg_go2iber.txt_path)
        result_name = tools_qt.get_text(self.dlg_go2iber, self.dlg_go2iber.txt_result_name, False, False)

        # Check if at least one process is selected
        # export_checked = tools_qt.is_checked(self.dlg_go2iber, self.dlg_go2iber.chk_export)
        # exec_checked = tools_qt.is_checked(self.dlg_go2iber, self.dlg_go2iber.chk_exec)
        # import_result_checked = tools_qt.is_checked(self.dlg_go2iber, self.dlg_go2iber.chk_import_result)

        # if not export_checked and not exec_checked and not import_result_checked:
        #     msg = "You need to select at least one process"
        #     tools_qt.show_info_box(msg, title="go2iber")
        #     return False

        # Control result name
        if result_name == '':
            self.dlg_go2iber.txt_result_name.setStyleSheet("border: 1px solid red")
            msg = "This parameter is mandatory. Please, set a value"
            title = "Result name"
            tools_qt.show_details(msg, title, inf_text=None)
            return False

        # Control folder path
        if folder_path == '':
            self.dlg_go2iber.txt_path.setStyleSheet("border: 1px solid red")
            msg = "This parameter is mandatory. Please, set a value"
            title = "Folder path"
            tools_qt.show_details(msg, title, inf_text=None)
            return False

        self.dlg_go2iber.txt_result_name.setStyleSheet(None)

        sql = (f"SELECT result_id FROM rpt_cat_result "
               f"WHERE result_id = '{result_name}' LIMIT 1")
        row = tools_db.get_row(sql)
        if row:
            msg = "Result name already exists, do you want overwrite?"
            title = "Alert"
            answer = tools_qt.show_question(msg, title)
            if not answer:
                return False

        return True

    def _calculate_elapsed_time(self, dialog):

        tf = time()  # Final time
        td = tf - self.t0  # Delta time
        self._update_time_elapsed(f"Exec. time: {timedelta(seconds=round(td))}", dialog)

    def _update_time_elapsed(self, text, dialog):

        if isdeleted(dialog):
            self.timer.stop()
            return

        lbl_time = dialog.findChild(QLabel, 'lbl_time')
        lbl_time.setText(text)
