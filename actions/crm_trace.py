"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtWidgets import QRadioButton, QPushButton

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
        sql = "SELECT expl_id, name FROM exploitation ORDER BY name"
        rows = self.controller.get_rows(sql, log_sql=True)
        utils_giswater.fillComboBox(self.dlg_trace, 'cbo_expl', rows)

        # Open dialog
        self.open_dialog(self.dlg_trace)


    def process(self):
        """ Main process """

        # Get selected 'exploitation'
        expl = utils_giswater.getWidgetText(self.dlg_trace, 'cbo_expl')
        self.controller.log_info(str(expl))

