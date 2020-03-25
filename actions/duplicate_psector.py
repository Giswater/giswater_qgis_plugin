"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import pyqtSignal, QObject

from functools import partial

from .. import utils_giswater
from .parent_manage import ParentManage
from ..ui_manager import DupPsector


class DuplicatePsector(ParentManage, QObject):

    is_duplicated = pyqtSignal()
    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control 'Workcat end' of toolbar 'edit' """

        QObject.__init__(self)
        ParentManage.__init__(self, iface, settings, controller, plugin_dir)


    def manage_duplicate_psector(self, psector_id=None):

        # Create the dialog and signals
        self.dlg_duplicate_psector = DupPsector()
        self.load_settings(self.dlg_duplicate_psector)

        # Populate combo duplicate psector
        sql = "SELECT psector_id, name FROM plan_psector"
        rows = self.controller.get_rows(sql)
        utils_giswater.set_item_data(self.dlg_duplicate_psector.duplicate_psector, rows, 1)

        # Set QComboBox with selected psector
        utils_giswater.set_combo_itemData(self.dlg_duplicate_psector.duplicate_psector, str(psector_id), 0)

        # Set listeners
        self.dlg_duplicate_psector.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_duplicate_psector))
        self.dlg_duplicate_psector.btn_accept.clicked.connect(partial(self.duplicate_psector))

        # Open dialog
        self.open_dialog(self.dlg_duplicate_psector)


    def duplicate_psector(self):

        id_psector = utils_giswater.get_item_data(self.dlg_duplicate_psector, self.dlg_duplicate_psector.duplicate_psector, 0)
        new_psector_name = utils_giswater.getWidgetText(self.dlg_duplicate_psector,
                                                        self.dlg_duplicate_psector.new_psector_name)

        # Create body
        feature = '"type":"PSECTOR"'
        extras = f'"psector_id":"{id_psector}", "new_psector_name":"{new_psector_name}"'
        body = self.create_body(feature=feature, extras=extras)
        body = body.replace('""', 'null')
        complet_result = self.controller.get_json('gw_fct_duplicate_psector', body)
        if not complet_result:
            message = 'Function gw_fct_duplicate_psector executed with no result'
            self.controller.show_message(message, 3)
            return

        # Populate tab info
        data = complet_result['body']['data']
        for k, v in list(data.items()):
            if str(k) == "info":
                change_tab = self.add_layer.populate_info_text(self.dlg_duplicate_psector, data)

        # Close dialog
        if not change_tab:
            self.close_dialog(self.dlg_duplicate_psector)
        else:
            utils_giswater.getWidget(self.dlg_duplicate_psector, self.dlg_duplicate_psector.btn_accept).setEnabled(False)
            self.dlg_duplicate_psector.setWindowTitle(f'SUCCESS IN DUPLICATING PSECTOR')
        self.is_duplicated.emit()
