"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os

from qgis.PyQt import QtCore
from qgis.PyQt.QtWidgets import QDialog, QShortcut
from qgis.PyQt.QtGui import QKeySequence, QIcon

from ... import global_vars
from ..utils import tools_gw


class GwDialog(QDialog):

    key_escape = QtCore.pyqtSignal()

    def __init__(self, subtag=None):

        super().__init__()
        self.setupUi(self)
        self.subtag = subtag
        # Connect the help shortcut
        action_help_shortcut = tools_gw.get_config_parser("actions_shortcuts", f"shortcut_help", "user", "init", prefix=False)
        sh = QShortcut(QKeySequence(f"{action_help_shortcut}"), self)
        sh.activated.connect(tools_gw.open_dlg_help)
        # Set window icon
        icon_folder = f"{global_vars.plugin_dir}{os.sep}icons"
        icon_path = f"{icon_folder}{os.sep}dialogs{os.sep}20x20{os.sep}giswater.png"
        giswater_icon = QIcon(icon_path)
        self.setWindowIcon(giswater_icon)
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

    def keyPressEvent(self, event):

        try:
            if event.key() == QtCore.Qt.Key_Escape:
                self.key_escape.emit()
                return super().keyPressEvent(event)
        except RuntimeError:
            # Multiples signals are emited when we use key_scape in order to close dialog
            pass