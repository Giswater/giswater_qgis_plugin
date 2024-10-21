"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os

from qgis.PyQt import QtCore
from qgis.PyQt.QtWidgets import QDialog, QShortcut, QWidget, QSizePolicy, QStackedLayout
from qgis.PyQt.QtGui import QKeySequence, QIcon

from qgis.gui import QgsMessageBar

from ... import global_vars
from ..utils import tools_gw
from ...libs import lib_vars


class GwDialog(QDialog):

    key_escape = QtCore.pyqtSignal()

    def __init__(self, class_obj, subtag=None):

        super().__init__()
        self.setupUi(self)
        # Create message bar
        try:
            # Wrap the existing layout in a widget
            main_widget = QWidget()
            main_widget.setLayout(self.layout())

            # Create a stacked layout to overlay the message bar
            self.stacked_layout = QStackedLayout(self)
            self.setLayout(self.stacked_layout)
            self.stacked_layout.setStackingMode(1)

            # Create the message bar
            self._messageBar = QgsMessageBar()
            self._messageBar.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)  # Full width, fixed height
            self._messageBar.setMaximumHeight(30)
            self._messageBar.hide()  # Hide the message bar initially

            # Add message bar to stacked layout
            self.stacked_layout.addWidget(self._messageBar)

            # Add the main widget to the stacked layout
            self.stacked_layout.addWidget(main_widget)
        except Exception as e:
            print("Exception in GwDialog:", e)
            self._messageBar = global_vars.iface

        self.setProperty('class_obj', class_obj)
        self.subtag = subtag
        # Connect the help shortcut
        action_help_shortcut = tools_gw.get_config_parser("actions_shortcuts", f"shortcut_help", "user", "init", prefix=False)
        sh = QShortcut(QKeySequence(f"{action_help_shortcut}"), self)
        sh.activated.connect(tools_gw.open_dlg_help)
        # Set window icon
        icon_folder = f"{lib_vars.plugin_dir}{os.sep}icons"
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
            lib_vars.session_vars['last_focus'] = tag
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

    def messageBar(self):
        return self._messageBar
