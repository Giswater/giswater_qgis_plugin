"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import pyqtSignal, QObject

from functools import partial

from lib import qt_tools

from ...utils.giswater_tools import close_dialog, load_settings, open_dialog, save_settings
from ...utils.layer_tools import populate_info_text
from ....ui_manager import PsectorDuplicate
from .... import global_vars
from ....actions.parent_functs import create_body



class GwPsectorDuplicate(QObject):

    is_duplicated = pyqtSignal()

    def __init__(self):
        """ Class to control 'Workcat end' of toolbar 'edit' """

        super().__init__()

        self.controller = global_vars.controller


    def manage_duplicate_psector(self, psector_id=None):

        # Create the dialog and signals
        self.dlg_duplicate_psector = PsectorDuplicate()
        load_settings(self.dlg_duplicate_psector)

        # Populate combo duplicate psector
        sql = "SELECT psector_id, name FROM plan_psector"
        rows = self.controller.get_rows(sql)
        qt_tools.set_item_data(self.dlg_duplicate_psector.duplicate_psector, rows, 1)

        # Set QComboBox with selected psector
        qt_tools.set_combo_itemData(self.dlg_duplicate_psector.duplicate_psector, str(psector_id), 0)

        # Set listeners
        self.dlg_duplicate_psector.btn_cancel.clicked.connect(partial(close_dialog, self.dlg_duplicate_psector))
        self.dlg_duplicate_psector.btn_accept.clicked.connect(partial(self.duplicate_psector))

        # Open dialog
        open_dialog(self.dlg_duplicate_psector, dlg_name='psector_duplicate')


    def duplicate_psector(self):

        id_psector = qt_tools.get_item_data(self.dlg_duplicate_psector, self.dlg_duplicate_psector.duplicate_psector, 0)
        new_psector_name = qt_tools.getWidgetText(self.dlg_duplicate_psector,
                                                  self.dlg_duplicate_psector.new_psector_name)

        # Create body
        feature = '"type":"PSECTOR"'
        extras = f'"psector_id":"{id_psector}", "new_psector_name":"{new_psector_name}"'
        body = create_body(feature=feature, extras=extras)
        body = body.replace('""', 'null')
        complet_result = self.controller.get_json('gw_fct_psector_duplicate', body)
        if not complet_result:
            message = 'Function gw_fct_psector_duplicate executed with no result'
            self.controller.show_message(message, 3)
            return

        # Populate tab info
        change_tab = False
        data = complet_result['body']['data']
        for k, v in list(data.items()):
            if str(k) == "info":
                change_tab = populate_info_text(self.dlg_duplicate_psector, data)

        # Close dialog
        if not change_tab:
            close_dialog(self.dlg_duplicate_psector)
        else:
            qt_tools.getWidget(self.dlg_duplicate_psector, self.dlg_duplicate_psector.btn_accept).setEnabled(False)
            self.dlg_duplicate_psector.setWindowTitle(f'SUCCESS IN DUPLICATING PSECTOR')

        self.is_duplicated.emit()

