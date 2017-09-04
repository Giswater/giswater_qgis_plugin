"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-

from PyQt4.QtGui import QTableView, QAbstractItemView
from PyQt4.QtSql import QSqlQueryModel, QSqlTableModel

import os
import sys
from functools import partial



plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater


from ..ui.multirow_selector import Multirow_selector       # @UnresolvedImport

from parent import ParentAction


class Wsom(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control Management toolbar actions """
        self.minor_version = "3.0"
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)


    def set_project_type(self, project_type):
        self.project_type = project_type