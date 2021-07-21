"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-

from qgis.PyQt import QtCore
from qgis.PyQt.QtWidgets import QDialog, QShortcut
from qgis.PyQt.QtGui import QKeySequence

from ... import global_vars
from ..utils import tools_gw


class GwDialog(QDialog):

    def __init__(self, subtag=None):

        super().__init__()
        self.setupUi(self)
        self.subtag = subtag
        # Connect the help shortcut
        action_help_shortcut = tools_gw.get_config_parser("system", f"help_shortcut", "user", "init", prefix=False)
        sh = QShortcut(QKeySequence(f"{action_help_shortcut}"), self)
        sh.activated.connect(tools_gw.open_dlg_help)
        # Enable event filter
        self.installEventFilter(self)


    def eventFilter(self, object, event):
        if hasattr(self, "subtag") and self.subtag is not None:
            tag = f'{self.objectName()}_{self.subtag}'
        else:
            tag = str(self.objectName())

        if event.type() == QtCore.QEvent.ActivationChange and self.isActiveWindow():
            global_vars.session_vars['last_focus'] = tag
            return True
        return False
