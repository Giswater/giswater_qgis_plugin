"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from qgis.core import QgsApplication
from qgis.PyQt.QtWidgets import QLabel, QTabWidget, QCheckBox

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
        tools_gw.populate_dynamic_widgets(self.dialog, json_result, self)

        # Get dynamic widgets
        self.versions_check = self.dialog.findChild(QCheckBox, "tab_data_versions_check")
        self.qgisproj_check = self.dialog.findChild(QCheckBox, "tab_data_qgisproj_check")
        self.verified_exceptions = self.dialog.findChild(QCheckBox, "tab_data_verified_exceptions")
        self.om_check = self.dialog.findChild(QCheckBox, "tab_data_om_check")
        self.graph_check = self.dialog.findChild(QCheckBox, "tab_data_graph_check")
        self.epa_check = self.dialog.findChild(QCheckBox, "tab_data_epa_check")
        self.plan_check = self.dialog.findChild(QCheckBox, "tab_data_plan_check")
        self.admin_check = self.dialog.findChild(QCheckBox, "tab_data_admin_check")

        versions_check_value = tools_gw.get_config_parser('admin_checkproject', 'versions_check', "user", "session")
        qgisproj_check_value = tools_gw.get_config_parser('admin_checkproject', 'qgisproj_check', "user", "session")
        verified_exceptions_value = tools_gw.get_config_parser('admin_checkproject', 'verified_exceptions', "user", "session")
        om_check_value = tools_gw.get_config_parser('admin_checkproject', 'om_check', "user", "session")
        graph_check_value = tools_gw.get_config_parser('admin_checkproject', 'graph_check', "user", "session")
        epa_check_value = tools_gw.get_config_parser('admin_checkproject', 'epa_check', "user", "session")
        plan_check_value = tools_gw.get_config_parser('admin_checkproject', 'plan_check', "user", "session")
        admin_check_value = tools_gw.get_config_parser('admin_checkproject', 'admin_check', "user", "session")

        if versions_check_value not in (None, 'None', ''):
            tools_qt.set_checked(self.dialog, self.versions_check, versions_check_value)
        if qgisproj_check_value not in (None, 'None', ''):
            tools_qt.set_checked(self.dialog, self.qgisproj_check, qgisproj_check_value)
        if verified_exceptions_value not in (None, 'None', ''):
            tools_qt.set_checked(self.dialog, self.verified_exceptions, verified_exceptions_value)
        if om_check_value not in (None, 'None', ''):
            tools_qt.set_checked(self.dialog, self.om_check, om_check_value)
        if graph_check_value not in (None, 'None', ''):
            tools_qt.set_checked(self.dialog, self.graph_check, graph_check_value)
        if epa_check_value not in (None, 'None', ''):
            tools_qt.set_checked(self.dialog, self.epa_check, epa_check_value)
        if plan_check_value not in (None, 'None', ''):
            tools_qt.set_checked(self.dialog, self.plan_check, plan_check_value)
        if admin_check_value not in (None, 'None', ''):
            tools_qt.set_checked(self.dialog, self.admin_check, admin_check_value)

        # Disable the "Log" tab initially
        tools_gw.disable_tab_log(self.dialog)

        # Hide progress bar and timer label initially
        self.dialog.progressBar.setVisible(False)
        lbl_time = self.dialog.findChild(QLabel, "lbl_time")
        if lbl_time:
            lbl_time.setVisible(False)

        # Set listeners
        self.dialog.btn_accept.clicked.connect(self._on_accept_clicked)
        self.dialog.rejected.connect(partial(tools_gw.close_dialog, self.dialog))

        # Open the dialog
        tools_gw.open_dialog(self.dialog, dlg_name=form_type)

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

        show_versions = tools_qt.is_checked(self.dialog, "tab_data_versions_check")
        show_qgis_project = tools_qt.is_checked(self.dialog, "tab_data_qgisproj_check")

        # Set parameters and re-run the project check task
        params = {"layers": layers, "init_project": "false", "dialog": self.dialog,
                  "show_versions": show_versions, "show_qgis_project": show_qgis_project}

        # Save dialog values
        self._save_dlg_values()

        self.project_check_task = GwProjectCheckTask('check_project', params)

        # Connect task completion to execute checkdatabase
        self.project_check_task.taskCompleted.connect(self._execute_checkdatabase)

        QgsApplication.taskManager().addTask(self.project_check_task)
        QgsApplication.taskManager().triggerTask(self.project_check_task)

    def _execute_checkdatabase(self):
        """Executes `gw_fct_setcheckdatabase` and updates the Log tab with results."""

        # Collect selected checkboxes
        check_parameters = self._get_selected_checks()
        if not any(check_parameters.values()):
            print("No checkboxes selected. Skipping gw_fct_setcheckdatabase.")
            return

        # Format parameters properly
        parameters = ', '.join([f'"{key}": {str(value).lower()}' for key, value in check_parameters.items()])
        extras = f'"parameters": {{{parameters}}}'
        body = tools_gw.create_body(extras=extras)

        # Execute procedure
        json_result = tools_gw.execute_procedure('gw_fct_setcheckdatabase', body)

        if not json_result or json_result.get("status") != "Accepted":
            print(f"Failed to execute gw_fct_setcheckdatabase: {json_result}")
            return
        tools_gw.fill_tab_log(self.dialog, json_result['body']['data'], reset_text=False)

    def _get_selected_checks(self):
        """Returns a dictionary of the selected checkboxes using `is_checked` from tools_qt,
        excluding system health checkboxes.
        """
        result_json = {}

        # Find all QCheckBox widgets inside the dialog
        list_widgets = self.dialog.findChildren(QCheckBox)

        for widget in list_widgets:
            widget_name = widget.objectName()  # Get the checkbox name
            checked_value = tools_qt.is_checked(self.dialog, widget)

            # Exclude "versions_check" and "qgisproj_check"
            if widget_name in ["tab_data_versions_check", "tab_data_qgisproj_check"]:
                continue  # Skip these checkboxes

            # Store only checkboxes with valid names
            if widget_name and checked_value:
                result_json[widget_name] = checked_value

        return result_json

    def _on_task_finished(self):
        """Hides progress indicators when the project check is complete."""
        self.dialog.progressBar.setVisible(False)
        lbl_time = self.dialog.findChild(QLabel, "lbl_time")
        if lbl_time:
            lbl_time.setVisible(False)


    def _save_dlg_values(self):
        """ Save dialog values """

        versions_check = self.versions_check.isChecked()
        qgisproj_check = self.qgisproj_check.isChecked()
        verified_exceptions = self.verified_exceptions.isChecked()
        om_check = self.om_check.isChecked()
        graph_check = self.graph_check.isChecked()
        epa_check = self.epa_check.isChecked()
        plan_check = self.plan_check.isChecked()
        admin_check = self.admin_check.isChecked()

        tools_gw.set_config_parser('admin_checkproject', 'versions_check', versions_check)
        tools_gw.set_config_parser('admin_checkproject', 'qgisproj_check', qgisproj_check)
        tools_gw.set_config_parser('admin_checkproject', 'verified_exceptions', verified_exceptions)
        tools_gw.set_config_parser('admin_checkproject', 'om_check', om_check)
        tools_gw.set_config_parser('admin_checkproject', 'graph_check', graph_check)
        tools_gw.set_config_parser('admin_checkproject', 'epa_check', epa_check)
        tools_gw.set_config_parser('admin_checkproject', 'plan_check', plan_check)
        tools_gw.set_config_parser('admin_checkproject', 'admin_check', admin_check)

    # endregion
