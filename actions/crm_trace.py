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
        sql = "SELECT name FROM exploitation ORDER BY name"
        rows = self.controller.get_rows(sql, log_sql=True)
        utils_giswater.fillComboBox(self.dlg_trace, 'cbo_expl', rows)

        # Open dialog
        self.open_dialog(self.dlg_trace)


    def process(self):
        """ Main process """

        # Get selected 'exploitation'
        expl_name = utils_giswater.getWidgetText(self.dlg_trace, 'cbo_expl')
        self.controller.log_info(str(expl_name))

        # Execute synchronization script
        self.execute_script(expl_name)


    def execute_script(self, expl_name='ZA'):
        """ Execute synchronization script """

        self.controller.log_info("execute_script")

        if expl_name is None:
            self.controller.show_warning("Any exploitation selected")
            return

        # Get python synchronization script path
        try:
            script_path = self.controller.cfgp_user['guk_script_path'].value
        except KeyError as e:
            self.controller.log_warning(str(e))
            return

        # Check if script path exists
        if not os.path.exists(script_path):
            self.controller.log_warning("File not found", parameter=script_path)
            return

        # Execute script
        args = ['python', script_path, expl_name]
        self.controller.log_info(str(args))
        try:
            status = subprocess.call(args)
            self.controller.log_info(status)
        except Exception as e:
            self.controller.show_warning(str(e))

        msg = "Process executed successfully. Open script .log file to get more details"
        self.controller.show_info(msg, duration=20)

