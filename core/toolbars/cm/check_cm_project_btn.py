"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from .project_check_cm import GwProjectCheckCMTask
from ..dialog import GwAction

from qgis.PyQt.QtWidgets import QLabel, QTabWidget, QCheckBox, QWidget, QTextEdit
from qgis.core import QgsApplication

from ...utils import tools_gw
from ....libs import tools_qgis, tools_qt
from ...ui.ui_manager import CheckProjectCmUi


class GwCheckCMProjectButton(GwAction):
    """ Button 89: Check Project CM """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        super().__init__(icon_path, action_name, text, toolbar, action_group)

    def clicked_event(self):
        self._open_check_project()

    # region private functions

    def _open_check_project(self):
        """Fetches form configuration, dynamically populates widgets, and opens the dialog."""

        # Define the form type and create the body
        form_type = "check_project_cm"
        body = tools_gw.create_body(form=f'"formName":"generic","formType":"{form_type}"')

        # Fetch dialog configuration from the database
        json_result = tools_gw.execute_procedure('gw_fct_getdialogcm', body, schema_name='cm')

        # Check for a valid result
        if not json_result or json_result.get("status") != "Accepted":
            print(f"Failed to fetch dialog configuration: {json_result}")
            return

        # Store the dialog as an instance variable to prevent garbage collection
        self.dialog = CheckProjectCmUi(self)
        tools_gw.load_settings(self.dialog)

        # Populate the dialog with fields
        self._populate_dynamic_widgets(self.dialog, json_result)

        # Disable the "Log" tab initially
        tools_gw.disable_tab_log(self.dialog)

        # Hide progress bar and timer label initially
        self.dialog.progressBar.setVisible(False)
        lbl_time = self.dialog.findChild(QLabel, "lbl_time")
        if lbl_time:
            lbl_time.setVisible(False)

        # Set listeners
        self.dialog.btn_accept.clicked.connect(self._on_accept_clicked)

        # Open the dialog
        tools_gw.open_dialog(self.dialog, dlg_name=form_type)

    def _populate_dynamic_widgets(self, dialog, complet_result):
        """Creates and populates all widgets dynamically into the dialog layout."""

        # Retrieve the tablename from the JSON response if available
        tablename = complet_result['body']['form'].get('tableName', 'default_table')
        old_widget_pos = 0

        # Loop through fields and add them to the appropriate layouts
        for field in complet_result['body']['data']['fields']:
            # Skip hidden fields
            if field.get('hidden'):
                continue

            # Pass required parameters (dialog, result, field, tablename, class_info)
            label, widget = tools_gw.set_widgets(dialog, complet_result, field, tablename, self)

            if widget is None:
                continue

            # Add widgets to the layout
            old_widget_pos = tools_gw.add_widget_combined(dialog, field, label, widget, old_widget_pos)

    def _on_accept_clicked(self):
        """Handles the Accept button click event and starts the project check task."""
        self._start_project_check()

    def _start_project_check(self):
        """Re-executes the project check process after Accept is pressed."""

        # Retrieve layers in the same order as listed in TOC
        layers = tools_qgis.get_project_layers()

        # Find the log widget and pass it directly to the task for reliability
        log_widget = self.dialog.findChild(QTextEdit, "txt_infolog")

        # Set parameters and re-run the project check task.
        params = {"layers": layers, "init_project": "false", "dialog": self.dialog,
                  "log_widget": log_widget}

        self.project_check_task = GwProjectCheckCMTask('check_project', params)

        # Connect task signals to UI updates
        self.project_check_task.task_started.connect(self._on_task_started)
        self.project_check_task.task_finished.connect(self._on_task_finished)

        QgsApplication.taskManager().addTask(self.project_check_task)

    def _on_task_started(self):
        """Disables controls and shows progress indicators when the task starts."""
        self.dialog.btn_accept.setEnabled(False)
        
        # Find the QTabWidget and the specific tab to switch to
        tab_widget = self.dialog.findChild(QTabWidget, "mainTab")
        log_tab = self.dialog.findChild(QWidget, "tab_log")
        if tab_widget and log_tab:
            tab_widget.setCurrentWidget(log_tab)

        tools_qt.enable_tab_by_tab_name(self.dialog.mainTab, "tab_data", False)
        self.dialog.progressBar.setVisible(True)
        self.dialog.lbl_time.setVisible(True)

    def _on_task_finished(self):
        """Enables controls and hides progress indicators when the task is complete."""
        self.dialog.btn_accept.setEnabled(True)
        tools_qt.enable_tab_by_tab_name(self.dialog.mainTab, "tab_data", True)
        self.dialog.progressBar.setVisible(False)
        self.dialog.lbl_time.setVisible(False)

    # endregion

