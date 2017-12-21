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

        # Capture the current layer to return it at the end of the operation
        cur_active_layer = self.iface.activeLayer()

        self.set_selectionbehavior(self.dlg)

        self.reset_lists()
        self.layers['arc'] = self.controller.get_group_layers('arc')
        self.layers['node'] = self.controller.get_group_layers('node')
        self.layers['connec'] = self.controller.get_group_layers('connec')
        self.layers['element'] = self.controller.get_group_layers('element')
        for layer in self.layers['arc']:
            layer.removeSelection()
        for layer in self.layers['node']:
            layer.removeSelection()
        for layer in self.layers['connec']:
            layer.removeSelection()
        for layer in self.layers['element']:
            layer.removeSelection()
        # Remove 'gully' for 'WS'
        self.project_type = self.controller.get_project_type()
        if self.project_type == 'ws':
            self.dlg.tab_feature.removeTab(4)
        else:
            self.layers['gully'] = self.controller.get_group_layers('gully')


        # # Set icons
        self.set_icon(self.dlg.btn_insert, "111")
        self.set_icon(self.dlg.btn_delete, "112")
        self.set_icon(self.dlg.btn_snapping, "137")

        # Adding auto-completion to a QLineEdit
        table_object = "cat_work"
        self.set_completer_object(table_object)

        modelo = self.dlg.tbl_cat_work_x_arc.model()
        tablename = 'v_edit_arc'
        geom_type = 'arc'
        self.dlg.btn_accept.pressed.connect(partial(self.manage_wk_end_accept,self.dlg.tbl_cat_work_x_arc, tablename, geom_type))
        self.dlg.btn_cancel.pressed.connect(partial(self.manage_close, table_object, cur_active_layer))

        self.dlg.tab_feature.currentChanged.connect(partial(self.tab_feature_changed, table_object))
        #self.dlg.feature_id.textChanged.connect(partial(self.exist_object, table_object))

        self.dlg.btn_insert.pressed.connect(partial(self.insert_geom_has_group, table_object))
        self.dlg.btn_delete.pressed.connect(partial(self.delete_records, table_object, True))
        self.dlg.btn_snapping.pressed.connect(partial(self.snapping_init, table_object))


        # Adding auto-completion to a QLineEdit for default feature
        geom_type = "node"
        viewname = "v_edit_" + geom_type

        self.set_completer_feature_id(geom_type, viewname)
        # # Set default tab 'arc'
        self.dlg.tab_feature.setCurrentIndex(0)
        self.geom_type = "arc"
        self.tab_feature_changed(table_object)


        self.dlg.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg.open()


    def manage_wk_end_accept(self, widget, tablename, geom_type):
        selected_list = widget.model()
        for x in range(0, selected_list.rowCount()):
            self.controller.log_info(str(x))
            self.controller.log_info(str("TEST"))

            index = selected_list.index(x,0)
            self.controller.log_info(str(selected_list.data(index)))
            sql = (" UPDATE " + self.schema_name + "." + tablename + " SET state='0' WHERE "+geom_type+"_id ='"+str(selected_list.data(index))+"'")
            self.controller.log_info(str(sql))
            #status = self.controller.execute_sql(sql)








        pass

