"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial
from sip import isdeleted
from time import time
from datetime import timedelta

from qgis.core import QgsApplication
from qgis.PyQt.QtCore import QTimer
from qgis.PyQt.QtWidgets import QLabel, QGridLayout, QTabWidget, QCheckBox, QWidget

from ..dialog import GwAction
from ...threads.project_check import GwProjectCheckTask
from ...ui.ui_manager import GwProjectCheckUi

from ...utils import tools_gw
from ....libs import tools_qgis, tools_qt


class GwProjectCheckButton(GwAction):
    """ Button 67: Check project """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)


    def clicked_event(self):

        self._open_check_project()


    # region private functions

    def _open_check_project(self):
        """Fetches form configuration, dynamically populates widgets, and opens the dialog."""

        # Define the form type and create the body
        form_type = "check_project"
        body = tools_gw.create_body(form=f'"formName":"generic","formType":"{form_type}"')

        # Fetch dialog configuration from the database
        json_result = tools_gw.execute_procedure('gw_fct_get_dialog', body)

        # Check for a valid result
        if not json_result or json_result.get("status") != "Accepted":
            print(f"Failed to fetch dialog configuration: {json_result}")
            return

        # Store the dialog as an instance variable to prevent garbage collection
        self.dialog = GwProjectCheckUi(self)
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
            tools_gw.add_widget_combined(dialog, field, label, widget)


    def _on_accept_clicked(self):
        """Handles the Accept button click event and starts the project check task."""

        # Enable the "Log" tab after pressing Accept
        qtabwidget = self.dialog.findChild(QTabWidget, 'mainTab')
        if qtabwidget:
            tools_qt.enable_tab_by_tab_name(qtabwidget, "tab_log", True)  # Enable Log tab

        self._start_project_check()


    def _start_project_check(self):
        """Re-executes the project check process after Accept is pressed."""

        # Show progress bar and timer when execution starts
        self.dialog.progressBar.setVisible(True)
        lbl_time = self.dialog.findChild(QLabel, "lbl_time")
        if lbl_time:
            lbl_time.setVisible(True)

        # Retrieve layers in the same order as listed in TOC
        layers = tools_qgis.get_project_layers()

        # Set parameters and re-run the project check task
        params = {"layers": layers, "init_project": "false", "dialog": self.dialog}
        self.project_check_task = GwProjectCheckTask('check_project', params)

        # After `GwProjectCheckTask` completes, execute `gw_fct_setcheckdatabase`
        self._execute_checkdatabase()

        QgsApplication.taskManager().addTask(self.project_check_task)
        QgsApplication.taskManager().triggerTask(self.project_check_task)


    def _execute_checkdatabase(self):
        """Executes `gw_fct_setcheckdatabase` if any checkboxes are selected after `GwProjectCheckTask` completes."""

        # Collect selected checkboxes
        print("hola")
        check_parameters = self._get_selected_checks()
        print(check_parameters)
        # If no checkboxes are selected, do nothing
        if not any(check_parameters.values()):
            print("No checkboxes selected. Skipping gw_fct_setcheckdatabase.")
            return

        # Format parameters properly as a string
        parameters = ', '.join([f'"{key}": {str(value).lower()}' for key, value in check_parameters.items()])
        extras = f'"parameters": {{{parameters}}}'
        print(extras)
        # Create the request body in the correct format
        body = tools_gw.create_body(extras=extras)

        # Execute procedure
        json_result = tools_gw.execute_procedure('gw_fct_setcheckdatabase', body)
        print("execute procedure: ", json_result)
        if not json_result or json_result.get("status") != "Accepted":
            print(f"Failed to execute gw_fct_setcheckdatabase: {json_result}")
        else:
            print("Database check successfully executed!")

    def _get_selected_checks(self):
        """Returns a dictionary of the selected checkboxes using `is_checked` from tools_qt."""
        result_json = {}

        # Find all QCheckBox widgets inside the dialog
        list_widgets = self.dialog.findChildren(QCheckBox)

        for widget in list_widgets:
            widget_name = widget.objectName()  # Get the checkbox name
            checked_value = tools_qt.is_checked(self.dialog, widget)

            # Store only checkboxes with valid names
            if widget_name and checked_value:
                result_json[widget_name] = checked_value

        print("Checkbox Values:", result_json)  # Debugging output
        return result_json

    def _on_task_finished(self):
        """Hides progress indicators when the project check is complete."""
        self.dialog.progressBar.setVisible(False)
        lbl_time = self.dialog.findChild(QLabel, "lbl_time")
        if lbl_time:
            lbl_time.setVisible(False)

    # endregion
