"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os

from qgis.PyQt import uic, QtCore
from ...core.ui.basic_dialog import GwDialog


def get_ui_class(ui_file_name):
    """ Get UI Python class from @ui_file_name """
    # Folder that contains UI files
    ui_file_path = os.path.abspath(os.path.join(os.path.dirname(__file__), ui_file_name))
    return uic.loadUiType(ui_file_path)[0]


# region SHARED
FORM_CLASS = get_ui_class('dialog_text.ui')
class DialogTextUi(GwDialog, FORM_CLASS):
    pass
# endregion
