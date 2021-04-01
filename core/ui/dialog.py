"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import configparser
import os
import webbrowser

from qgis.PyQt import QtCore
from qgis.PyQt.QtWidgets import QDialog, QWhatsThis

from ... import global_vars


class GwDialog(QDialog):

    def __init__(self, subtag=None):

        super().__init__()
        self.setupUi(self)
        self.subtag = subtag
        # Enable event filter
        self.installEventFilter(self)


    def eventFilter(self, object, event):

        if event.type() == QtCore.QEvent.EnterWhatsThisMode and self.isActiveWindow():
            QWhatsThis.leaveWhatsThisMode()
            parser = configparser.ConfigParser()
            path = f"{global_vars.plugin_dir}{os.sep}config{os.sep}giswater.config"
            if not os.path.exists(path):
                # print(f"File not found: {path}")
                webbrowser.open_new_tab('https://giswater.gitbook.io/giswater-manual')
                return True

            parser.read(path)
            if self.subtag is not None:
                tag = f'{self.objectName()}_{self.subtag}'
            else:
                tag = str(self.objectName())

            try:
                web_tag = parser.get('web_tag', tag)
                webbrowser.open_new_tab(f'https://giswater.gitbook.io/giswater-manual/{web_tag}')
            except Exception:
                webbrowser.open_new_tab('https://giswater.gitbook.io/giswater-manual')
            finally:
                return True

        return False