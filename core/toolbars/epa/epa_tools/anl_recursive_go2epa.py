"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
"""
# -*- coding: utf-8 -*-
import os
import sys
from functools import partial
from pathlib import Path

from qgis.core import QgsApplication
from qgis.PyQt.QtWidgets import  QFileDialog, QLabel
from qgis.PyQt.QtCore import QSettings

from ....ui.ui_manager import RecursiveEpaUi
from ....threads.recursive_epa import GwRecursiveEpa
from ..... import global_vars
from .....libs import tools_qt
from ....utils import tools_gw


class RecursiveEpa():

    def __init__(self):
        # super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.iface = global_vars.iface

    def clicked_event(self):

        self.dlg_epa = RecursiveEpaUi(self)
        tools_gw.load_settings(self.dlg_epa)

        # Load user values
        last_config_path = tools_gw.get_config_parser('recursive_epa', 'config_path', 'user', 'session')
        tools_qt.set_widget_text(self.dlg_epa, self.dlg_epa.data_config_file, last_config_path)
        last_path = tools_gw.get_config_parser('recursive_epa', 'folder_path', 'user', 'session')
        tools_qt.set_widget_text(self.dlg_epa, self.dlg_epa.data_output_folder, last_path)
        last_prefix = tools_gw.get_config_parser('recursive_epa', 'prefix', 'user', 'session')
        tools_qt.set_widget_text(self.dlg_epa, self.dlg_epa.txt_prefix, last_prefix)

        # Set signals
        self.dlg_epa.btn_close.clicked.connect(partial(self.dlg_epa.reject))
        self.dlg_epa.btn_push_config_file.clicked.connect(partial(self._get_file_dialog, self.dlg_epa.data_config_file))
        self.dlg_epa.btn_push_output_folder.clicked.connect(partial(self.get_folder_dialog, self.dlg_epa.data_output_folder))
        self.dlg_epa.btn_accept.clicked.connect(partial(self.execute_epa, self.dlg_epa))
        self.dlg_epa.rejected.connect(partial(self.save_user_values, self.dlg_epa))
        self.dlg_epa.rejected.connect(partial(tools_gw.close_dialog, self.dlg_epa))

        tools_gw.open_dialog(self.dlg_epa, dlg_name='recursive_epa')

    def save_user_values(self, dialog):
        """ Save last user values """
        config_path = tools_qt.get_text(dialog, dialog.data_config_file)
        tools_gw.set_config_parser('recursive_epa', 'config_path', f"{config_path}")
        folder_path = tools_qt.get_text(dialog, dialog.data_output_folder)
        tools_gw.set_config_parser('recursive_epa', 'folder_path', f"{folder_path}")
        prefix = tools_qt.get_text(dialog, dialog.txt_prefix, False, False)
        tools_gw.set_config_parser('recursive_epa', 'prefix', f"{prefix}")

    def execute_epa(self, dlg_epa):
        # Get config path
        config_path = tools_qt.get_text(dlg_epa, dlg_epa.data_config_file)
        if config_path is None or config_path == 'null' or not os.path.exists(config_path):
            self._get_file_dialog(dlg_epa.data_config_file)
            config_path = tools_qt.get_text(dlg_epa, dlg_epa.data_config_file)

        # Get folder path
        folder_path = tools_qt.get_text(dlg_epa, dlg_epa.data_output_folder)
        if folder_path is None or folder_path == 'null' or not os.path.exists(folder_path):
            self.get_folder_dialog(dlg_epa.data_output_folder)
            folder_path = tools_qt.get_text(dlg_epa, dlg_epa.data_output_folder)

        # Get prefix
        prefix = tools_qt.get_text(dlg_epa, dlg_epa.txt_prefix, False, False)

        setting_file = config_path
        if not os.path.exists(setting_file):
            message = f"Config file not found at: {setting_file}"
            self.iface.messageBar().pushMessage("", message, 1, 20)
            return
        settings = QSettings(setting_file, QSettings.IniFormat)
        settings.setIniCodec(sys.getfilesystemencoding())
        list1 = settings.value("list1/list1")
        list2 = settings.value("list2/list1")
        list3 = settings.value("list3/list1")

        msg = "These are the lists that will be used. Do you want to continue?"
        if settings.value("list1/list2") or settings.value("list2/list2") or settings.value("list3/list2"):
            msg = "There are multiple queries configured." + msg
        inf_text = f"{list1}"
        if list2:
            inf_text += f"\n{list2}"
            if list3:
                inf_text += f"\n{list3}"
        response = tools_qt.show_question(msg, inf_text=inf_text, force_action=True)
        if response:
            self.recursive_epa = GwRecursiveEpa("Recursive Go2Epa", prefix, folder_path, settings, global_vars.plugin_dir)
            self.recursive_epa.change_btn_accept.connect(self._enable_cancel_btn)
            self.recursive_epa.time_changed.connect(self._set_remaining_time)
            QgsApplication.taskManager().addTask(self.recursive_epa)
            QgsApplication.taskManager().triggerTask(self.recursive_epa)

    def _get_file_dialog(self, widget):
        # Check if selected file exists. Set default value if necessary
        file_path = tools_qt.get_text(self.dlg_epa, widget)
        if file_path in (None, "null") or not Path(file_path).exists():
            file_path = str(Path.home())

        # Open dialog to select file
        file_dialog = QFileDialog()
        file_dialog.setFileMode(QFileDialog.ExistingFile)
        msg = "Select file"
        file_path = file_dialog.getOpenFileName(
            parent=None, caption=tools_qt.tr(msg), directory=file_path
        )[0]
        if file_path:
            tools_qt.set_widget_text(self.dlg_epa, widget, str(file_path))

    def get_folder_dialog(self, widget):
        """ Get folder dialog """

        # Check if selected folder exists. Set default value if necessary
        tools_qt.get_folder_path(self.dlg_epa, widget)

    def _enable_cancel_btn(self, enable):
        if enable:
            self.dlg_epa.btn_accept.clicked.disconnect()
            self.dlg_epa.btn_accept.setText(f"Cancel")
            self.dlg_epa.btn_accept.clicked.connect(self.recursive_epa.stop_task)
            self.dlg_epa.btn_close.hide()
        else:
            self.dlg_epa.btn_close.show()
            self.dlg_epa.btn_accept.clicked.disconnect()
            self.dlg_epa.btn_accept.setText(f"Accept")
            self.dlg_epa.btn_accept.clicked.connect(partial(self.execute_epa, self.dlg_epa))

    def _set_remaining_time(self, time):
        lbl_time = self.dlg_epa.findChild(QLabel, 'lbl_time')
        lbl_time.setText(time)

