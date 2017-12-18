"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-

from PyQt4.QtCore import Qt

import os
import sys
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater

from ui.workcat_end import WorkcatEnd
from actions.parent_manage import ParentManage


class ManageWorkcatEnd(ParentManage):
    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control 'Workcat end' of toolbar 'edit' """
        ParentManage.__init__(self, iface, settings, controller, plugin_dir)

    def manage_workcat_end(self):

        # Create the dialog and signals
        self.dlg = WorkcatEnd()
        utils_giswater.setDialog(self.dlg)

        # Remove 'gully' for 'WS'
        self.project_type = self.controller.get_project_type()
        # if self.project_type == 'ws':
        #     self.dlg.tab_feature.removeTab(3)
        #     self.dlg.tab_feature.removeTab(3)

        # # Set icons
        self.set_icon(self.dlg.btn_insert, "111")
        self.set_icon(self.dlg.btn_delete, "112")
        self.set_icon(self.dlg.btn_snapping, "137")

        # Adding auto-completion to a QLineEdit
        table_object = "cat_work"
        self.set_completer_object(table_object)

        #self.dlg.btn_accept.pressed.connect(self.manage_document_accept)
        self.dlg.btn_cancel.pressed.connect(self.dlg.close)
        self.dlg.tab_feature.currentChanged.connect(partial(self.tab_feature_changed, table_object))
        #self.dlg.feature_id.textChanged.connect(partial(self.exist_object, table_object))
        self.dlg.btn_insert.pressed.connect(partial(self.insert_geom, table_object, True))
        #self.dlg.btn_delete.pressed.connect(partial(self.delete_records, table_object))
        #self.dlg.btn_snapping.pressed.connect(partial(self.snapping_init, table_object))


        # Adding auto-completion to a QLineEdit for default feature
        geom_type = "node"
        viewname = "v_edit_" + geom_type

        self.set_completer_feature_id(geom_type, viewname)
        # # Set default tab 'arc'
        self.dlg.tab_feature.setCurrentIndex(0)
        self.geom_type = "arc"
        self.tab_feature_changed(table_object)

        self.dlg.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg.exec_()

