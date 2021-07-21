"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-

from qgis.PyQt import QtCore
from qgis.PyQt.QtWidgets import QDockWidget

from ... import global_vars


class GwDocker(QDockWidget):
    dlg_closed = QtCore.pyqtSignal()


    def __init__(self, subtag=None):

        super().__init__()
        # TODO: Check try/catch. Strange error: "GwDocker object has no attribute 'setupUi"
        try:
            self.setupUi(self)
        except Exception:
            pass
        self.subtag = subtag


    def closeEvent(self, event):

        self.dlg_closed.emit()
        return super().closeEvent(event)


    def event(self, event):

        if (event.type() in QtCore.QEvent.WindowActivate or event.type() == QtCore.QEvent.Show) \
                and self.isActiveWindow():
            if hasattr(self, "subtag") and self.subtag is not None:
                tag = f'{self.widget().objectName()}_{self.subtag}'
            else:
                tag = str(self.widget().objectName())
            global_vars.session_vars['last_focus'] = tag
        return super().event(event)
