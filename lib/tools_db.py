"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtWidgets import QTabWidget
from qgis.PyQt.QtWidgets import QWidget, QGridLayout, QLabel, QLineEdit, QSizePolicy, QCheckBox, QSpacerItem, \
    QApplication
from qgis.PyQt.QtCore import Qt

from functools import partial

from .. import global_vars
from . import tools_qt
from .tools_qgis import zoom_to_rectangle
from ..core.utils import tools_gw


def make_list_for_completer(sql):
    """ Prepare a list with the necessary items for the completer
    :param sql: Query to be executed, where will we get the list of items (string)
    :return list_items: List with the result of the query executed (List) ["item1","item2","..."]
    """

    rows = global_vars.controller.get_rows(sql)
    list_items = []
    if rows:
        for row in rows:
            list_items.append(str(row[0]))
    return list_items