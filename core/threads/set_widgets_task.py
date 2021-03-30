"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import pyqtSignal
from qgis.PyQt.QtWidgets import QGridLayout, QSizePolicy, QSpacerItem, QLineEdit
from qgis.core import QgsTask

from .task import GwTask
from ..utils import tools_gw
from ... import global_vars
from ...lib import tools_qt


class GWSetWidgetsTask(GwTask):
    """ This shows how to subclass QgsTask """

    task_finished = pyqtSignal(list)

    def __init__(self, description, info, params):

        super().__init__(description, QgsTask.CanCancel)
        self.info = info
        self.params = params



    def run(self):
        """ Automatic mincut: Execute function 'gw_fct_mincut' """
        super().run()
        new_feature = self.params['new_feature']
        complet_result = self.params['complet_result']
        self.dlg_cf = self.params['dlg_cf']
        layout_list = []
        for field in complet_result['body']['data']['fields']:
            if 'hidden' in field and field['hidden']:
                continue
            label, widget = self.info._set_widgets(self.dlg_cf, complet_result, field, new_feature)
            if widget is None:
                continue
            layout = self.dlg_cf.findChild(QGridLayout, field['layoutname'])
            if layout is not None:
                # Take the QGridLayout with the intention of adding a QSpacerItem later
                if layout not in layout_list and layout.objectName() not in ('lyt_top_1', 'lyt_bot_1', 'lyt_bot_2'):
                    layout_list.append(layout)

                if field['layoutname'] in ('lyt_top_1', 'lyt_bot_1', 'lyt_bot_2'):
                    layout.addWidget(label, 0, field['layoutorder'])
                    layout.addWidget(widget, 1, field['layoutorder'])
                else:
                    tools_gw.add_widget(self.dlg_cf, field, label, widget)

        for layout in layout_list:
            vertical_spacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
            layout.addItem(vertical_spacer1)
        return True



    def finished(self, result):
        super().finished(result)
        tools_gw.open_dialog(self.dlg_cf, dlg_name='info_feature')


