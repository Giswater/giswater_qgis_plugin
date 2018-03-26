"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.Qt import QDate

from functools import partial

import utils_giswater

from ui_manager import WorkcatEnd
from actions.parent_manage import ParentManage


class ManageWorkcatEnd(ParentManage):
    
    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control 'Workcat end' of toolbar 'edit' """
        ParentManage.__init__(self, iface, settings, controller, plugin_dir)


    def manage_workcat_end(self):

        # Create the dialog and signals
        self.dlg = WorkcatEnd()
        utils_giswater.setDialog(self.dlg)
        self.load_settings(self.dlg)

        # Capture the current layer to return it at the end of the operation
        cur_active_layer = self.iface.activeLayer()

        self.set_selectionbehavior(self.dlg)

        # Get layers of every geom_type
        self.reset_lists()
        self.reset_layers()    
        self.layers['arc'] = self.controller.get_group_layers('arc')
        self.layers['node'] = self.controller.get_group_layers('node')
        self.layers['connec'] = self.controller.get_group_layers('connec')
        self.layers['element'] = self.controller.get_group_layers('element')
            
        # Remove 'gully' for 'WS'
        self.project_type = self.controller.get_project_type()
        if self.project_type == 'ws':
            self.dlg.tab_feature.removeTab(4)
        else:
            self.layers['gully'] = self.controller.get_group_layers('gully')

        # Remove all previous selections
        self.remove_selection(True)
        
        # Set icons
        self.set_icon(self.dlg.btn_insert, "111")
        self.set_icon(self.dlg.btn_delete, "112")
        self.set_icon(self.dlg.btn_snapping, "137")

        # Adding auto-completion to a QLineEdit
        table_object = "cat_work"
        self.set_completer_object(table_object)

        # Set signals
        self.dlg.btn_accept.pressed.connect(partial(self.manage_workcat_end_accept))
        self.dlg.btn_cancel.pressed.connect(partial(self.manage_close, table_object, cur_active_layer))
        self.dlg.rejected.connect(partial(self.manage_close, table_object, cur_active_layer))

        self.dlg.btn_insert.pressed.connect(partial(self.insert_feature, table_object))
        self.dlg.btn_delete.pressed.connect(partial(self.delete_records, table_object))
        self.dlg.btn_snapping.pressed.connect(partial(self.selection_init, table_object))

        self.dlg.workcat_id_end.activated.connect(partial(self.fill_workids))
        self.dlg.tab_feature.currentChanged.connect(partial(self.tab_feature_changed, table_object))

        # Set values
        self.fill_fields()

        # Adding auto-completion to a QLineEdit for default feature
        geom_type = "arc"
        viewname = "v_edit_" + geom_type
        self.set_completer_feature_id(geom_type, viewname)
        
        # Set default tab 'arc'
        self.dlg.tab_feature.setCurrentIndex(0)
        self.geom_type = "arc"
        self.tab_feature_changed(table_object)

        # Open dialog
        self.open_dialog(self.dlg, maximize_button=False)     


    def fill_fields(self):
        """ Fill dates and combo cat_work """
        
        sql = ("SELECT value FROM " + self.controller.schema_name + ".config_param_user "
               " WHERE parameter = 'enddate_vdefault' and cur_user = current_user")
        row = self.controller.get_row(sql, log_info=False)
        if row:
            enddate = QDate.fromString(row[0], 'yyyy-MM-dd')
        else:
            enddate = QDate.currentDate()
        utils_giswater.setCalendarDate("enddate", enddate)

        sql = ("SELECT id FROM " + self.controller.schema_name + ".cat_work")
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg.workcat_id_end, rows)
        utils_giswater.set_autocompleter(self.dlg.workcat_id_end)


    def fill_workids(self):
        """ Auto fill descriptions and workid's """
        
        workcat_id = utils_giswater.getWidgetText(self.dlg.workcat_id_end)
        sql = ("SELECT descript, builtdate"
               " FROM " + self.controller.schema_name + ".cat_work"
               " WHERE id = '" + workcat_id + "'")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setText(self.dlg.descript, row['descript'])
            utils_giswater.setCalendarDate(self.dlg.builtdate, row['builtdate'], False)


    def manage_workcat_end_accept(self):
        """ Get elements from all the tables and update his data """
        
        self.enddate = utils_giswater.getCalendarDate("enddate")
        self.workcat_id_end = utils_giswater.getWidgetText("workcat_id_end")

        # Update tablename of every geom_type
        self.update_geom_type("arc")
        self.update_geom_type("node")
        self.update_geom_type("connec")
        self.update_geom_type("element")
        if self.project_type == 'ud':        
            self.update_geom_type("gully")
            
        self.dlg.close()
         
            
    def update_geom_type(self, geom_type):
        """ Get elements from @geom_type and update his corresponding table """
        
        widget = "tbl_cat_work_x_" + geom_type
        tablename = "v_edit_" + geom_type
        widget = utils_giswater.getWidget(widget)
        selected_list = widget.model()
        if selected_list is None:
            return
        
        sql = ""
        for x in range(0, selected_list.rowCount()):
            index = selected_list.index(x,0)
            sql += ("UPDATE " + self.schema_name + "." + tablename + ""
                   " SET state = '0', workcat_id_end = '" + str(self.workcat_id_end) + "',"
                   " enddate = '" + str(self.enddate) + "'"
                   " WHERE " + geom_type + "_id = '" + str(selected_list.data(index)) + "';\n")
        
        self.controller.execute_sql(sql, log_sql=True)

