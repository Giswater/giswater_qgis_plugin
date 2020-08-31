"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtGui import QStandardItem, QStandardItemModel
from qgis.PyQt.QtWidgets import QFileDialog

import csv
import os
from encodings.aliases import aliases
from functools import partial

from lib import qt_tools
from ...project_check import GwProjectCheck
from .toolbox import GwToolBox
from ..om.visit_manager import GwVisitManager
from ...utils.giswater_tools import close_dialog, get_parser_value, load_settings, open_dialog, set_parser_value

from ....ui_manager import CsvUi

from .... import global_vars

from ....actions.parent_functs import create_body
from ...utils.layer_tools import populate_info_text


class GwUtilities:

    def __init__(self):
        """ Class to control toolbar 'om_ws' """

        self.manage_visit = GwVisitManager()
        self.toolbox = GwToolBox()
        
        self.controller = global_vars.controller
        self.project_type = global_vars.project_type


    def insert_selector_audit(self, fid):
        """ Insert @fid for current_user in table 'selector_audit' """

        tablename = "selector_audit"
        sql = (f"SELECT * FROM {tablename} "
               f"WHERE fid = {fid} AND cur_user = current_user;")
        row = self.controller.get_row(sql)
        if not row:
            sql = (f"INSERT INTO {tablename} (fid, cur_user) "
                   f"VALUES ({fid}, current_user);")
        self.controller.execute_sql(sql)


    def utils_toolbox(self):

        self.toolbox.open_toolbox()


    def utils_show_check_project_result(self):
        """ Show dialog with audit check project result """

        # Return layers in the same order as listed in TOC
        layers = self.controller.get_layers()

        self.check_project_result = GwProjectCheck()
        self.check_project_result.populate_audit_check_project(layers, "false")

