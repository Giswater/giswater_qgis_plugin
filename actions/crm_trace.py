"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtWidgets import QRadioButton, QPushButton

import os
import subprocess
from .. import utils_giswater
from ..ui_manager import DlgTrace
from functools import partial

from .api_parent import ApiParent


class CrmTrace(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control 'Trace' of toolbar 'edit' """
        ApiParent.__init__(self, iface, settings, controller, plugin_dir)


    def manage_trace(self):

        self.controller.log_info("manage_trace")

        # Create the dialog and signals
        self.dlg_trace = DlgTrace()
        self.load_settings(self.dlg_trace)

        # Set listeners
        self.dlg_trace.btn_accept.clicked.connect(self.process)
        self.dlg_trace.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_trace))
        self.dlg_trace.rejected.connect(partial(self.save_settings, self.dlg_trace))

        # Fill combo 'exploitation'
        sql = "SELECT name FROM exploitation WHERE active = True ORDER BY name"
        rows = self.controller.get_rows(sql, log_sql=True)
        utils_giswater.fillComboBox(self.dlg_trace, 'cbo_expl', rows, allow_nulls=False)

        # Open dialog
        self.open_dialog(self.dlg_trace)


    def process(self):
        """ Main process """

        # Get selected 'exploitation'
        expl_name = utils_giswater.getWidgetText(self.dlg_trace, 'cbo_expl')
        self.controller.log_info(str(expl_name))

        # Execute synchronization script
        status = self.execute_script(expl_name)

        # Execute PG function 'gw_fct_odbc2pg_main'
        if status:
            self.execute_odbc2pg()


    def execute_script(self, expl_name=None):
        """ Execute synchronization script """

        self.controller.log_info("execute_script")

        if expl_name is None or expl_name == 'null':
            self.controller.show_warning("Any exploitation selected")
            return False

        # Get python synchronization script path
        try:
            param_name = 'crm_daily_script_folderpath'
            script_folder = self.controller.cfgp_system[param_name].value
            script_path = script_folder + os.sep + 'main.py'
        except KeyError as e:
            self.controller.show_warning(str(e))
            return False

        # Check if script path exists
        if not os.path.exists(script_path):
            msg = "File not found: {}. Check config system parameter: '{}'".format(script_path, param_name)
            self.controller.show_warning(msg, duration=20)
            return False

        # Get database current user
        cur_user = self.controller.get_current_user()

        # Execute script
        args = ['python', script_path, expl_name, cur_user, self.schema_name]
        self.controller.log_info(str(args))
        try:
            status = subprocess.call(args)
            self.controller.log_info(str(status))
            msg = "Process executed successfully. Open script .log file to get more details"
            self.controller.show_info(msg, duration=20)
        except Exception as e:
            self.controller.show_warning(str(e))
            return False
        finally:
            self.close_dialog(self.dlg_trace)
            return True


    def execute_odbc2pg(self, function_name='gw_fct_odbc2pg_main'):
        """ Execute PG function @function_name """

        self.controller.log_info("execute_odbc2pg")
        exists = self.controller.check_function(function_name)
        if not exists:
            self.controller.show_warning("Function not found", parameter=function_name)
            return False

