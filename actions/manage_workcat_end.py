"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.Qt import QDate
from PyQt4.QtCore import Qt
from PyQt4.QtSql import QSqlTableModel, QSqlQueryModel
from PyQt4.QtGui import QAbstractItemView, QTableView, QCompleter, QStringListModel
from qgis.core import QgsExpression, QgsFeatureRequest
from functools import partial

import utils_giswater

from ui_manager import WorkcatEnd
from actions.parent_manage import ParentManage
from ui_manager import WorkcatEndList

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
        #self.remove_selection(True)
        
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

        selected_list = self.dlg.tbl_cat_work_x_arc.model()
        self.selected_list = []
        ids_list = ""
        if selected_list is None:
            return
        for x in range(0, selected_list.rowCount()):
            index = selected_list.index(x, 0)
            id_ = selected_list.data(index)
            self.selected_list.append(id_)
            ids_list = ids_list + "'" + id_ + "'" + ","
        ids_list = ids_list[:-1]

        sql = ("SELECT * FROM " + self.schema_name + ".v_ui_arc_x_relations"
               " WHERE arc_id IN ( " + str(ids_list) + ") AND arc_state = '1'")
        row = self.controller.get_row(sql)
        if row:
            self.dlg_work = WorkcatEndList()
            utils_giswater.setDialog(self.dlg_work)
            self.load_settings(self.dlg_work)

            self.dlg_work.btn_cancel.pressed.connect(partial(self.close_dialog, self.dlg_work))
            self.dlg_work.btn_accept.pressed.connect(self.exec_downgrade)
            self.set_completer()

            table_relations = "v_ui_arc_x_relations"
            self.dlg_work.arc_id.textChanged.connect(partial(self.filter_by_id, self.dlg_work.tbl_arc_x_relations, self.dlg_work.arc_id, table_relations))

            self.tbl_arc_x_relations = self.dlg_work.findChild(QTableView, "tbl_arc_x_relations")
            self.tbl_arc_x_relations.setSelectionBehavior(QAbstractItemView.SelectRows)

            filter = ""
            for row in self.selected_list:
                filter += "arc_id = '" + str(row) + "' OR "
            filter = filter[:-3] + ""
            filter += " AND arc_state = '1' "

            self.fill_table(self.tbl_arc_x_relations, table_relations, filter)

            self.tbl_arc_x_relations.doubleClicked.connect(partial(self.open_selected_object, self.tbl_arc_x_relations))

            self.dlg_work.setWindowFlags(Qt.WindowStaysOnTopHint)
            self.dlg_work.show()
        else:
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

        tablename = "v_edit_" + geom_type
        if self.selected_list is None:
            return
        for id in self.selected_list:
            sql = ("UPDATE " + self.schema_name + "." + tablename + ""
                   " SET state = '0', workcat_id_end = '" + str(self.workcat_id_end) + "',"
                   " enddate = '" + str(self.enddate) + "'"
                   " WHERE " + geom_type + "_id = '" + str(id) + "'")
        status = self.controller.execute_sql(sql, log_sql=True)
        if status:
            self.controller.show_info("Geometry updated successfully!")


    def fill_table(self, widget, table_name, filter):
        """ Set a model with selected filter.
        Attach that model to selected table """

        # Set model
        self.model = QSqlTableModel()
        self.model.setTable(self.schema_name+"."+table_name)
        self.model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        if filter:
            self.model.setFilter(filter)
        self.model.setSort(0, 0)
        self.model.select()

        # Check for errors
        if self.model.lastError().isValid():
            self.controller.show_warning(self.model.lastError().text())
        # Attach model to table view
        widget.setModel(self.model)


    def open_selected_object(self, widget):
        """ Open object form with selected record of the table """

        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        row = selected_list[0].row()
        feature_id = widget.model().record(row).value("arc_id")

        self.open_arc_form(feature_id)


    def open_arc_form(self, arc_id):
        """ Open form corresponding to start or end node of the current arc """

        # Get sys_feature_cat.id from cat_feature.id
        sql = ("SELECT sys_type"
               " FROM " + self.schema_name + ".v_edit_arc"
               " WHERE arc_id = '" + arc_id + "'")
        row = self.controller.get_row(sql)
        if not row:
            return

        arc_type = row[0].lower()
        arc_table = "v_edit_man_" + arc_type
        layer_arc= self.controller.get_layer_by_tablename(arc_table)

        aux = "\"arc_id\" = "
        aux += "'" + str(arc_id) + "'"
        expr = QgsExpression(aux)

        if expr.hasParserError():
            message = "Expression Error"
            self.controller.show_warning(message, parameter=expr.parserErrorString())
            return

        if layer_arc:
            # Get a featureIterator from this expression:
            it = layer_arc.getFeatures(QgsFeatureRequest(expr))
            id_list = [i for i in it]
            if id_list:
                self.iface.openFeatureForm(layer_arc, id_list[0])

        # Zoom to object
        canvas = self.iface.mapCanvas()
        layer_arc.selectByIds([id_list[0].id()])
        canvas.zoomToSelected(layer_arc)
        canvas.zoomIn()


    def exec_downgrade(self):

        message = "Are you sure you want to disconnect this elements?"
        title = "Disconect elements"
        #answer = self.controller.ask_question(message, title, inf_text)
        answer = self.controller.ask_question(message, title)
        if answer:
            # Update (or insert) on config_param_user the value of edit_arc_downgrade_force to true
            sql = ("SELECT * FROM " + self.controller.schema_name + ".config_param_user "
                   " WHERE parameter = 'edit_arc_downgrade_force'")
            row = self.controller.get_row(sql, log_info=False)
            if row:
                sql = ("UPDATE " + self.schema_name + ".config_param_user "
                       " SET value = True "
                       " WHERE parameter = 'edit_arc_downgrade_force'")
                self.controller.execute_sql(sql, log_sql=True)
            else:
                sql = ("INSERT INTO " + self.schema_name + ".config_param_user (edit_arc_downgrade_force)"
                       " VALUES (True)")
                self.controller.execute_sql(sql, commit=self.autocommit)

            # Update tablename of every geom_type
            self.update_geom_type("arc")
            self.update_geom_type("node")
            self.update_geom_type("connec")
            self.update_geom_type("element")
            if self.project_type == 'ud':
                self.update_geom_type("gully")

            # Restore on config_param_user the user's value of edit_arc_downgrade_force to false
            sql = ("UPDATE " + self.schema_name + ".config_param_user "
                   " SET value = False "
                   " WHERE parameter = 'edit_arc_downgrade_force'")
            self.controller.execute_sql(sql, log_sql=True)
            self.dlg_work.close()
        else:
            self.dlg_work.close()
            self.dlg.open()


    def set_completer(self):
        """ Set autocompleters of the form """

        # Adding auto-completion to a QLineEdit - visit_id
        self.completer = QCompleter()
        self.dlg_work.arc_id.setCompleter(self.completer)
        model = QStringListModel()

        model.setStringList(self.selected_list)
        self.completer.setModel(model)


    def filter_by_id(self, table, widget_txt, tablename):

        id_ = utils_giswater.getWidgetText(widget_txt)
        if id_ != 'null':
            expr = " arc_id = '" + id_ + "'"
            # Refresh model with selected filter
            table.model().setFilter(expr)
            table.model().select()
        else:
            self.fill_table_relations(table, self.schema_name + "." + tablename)


    def fill_table_relations(self, widget, table_name):
        """ Set a model with selected filter. Attach that model to selected table """

        filter = ""
        for row in self.selected_list:
            filter += "arc_id = '" + str(row) + "' OR "
        filter = filter[:-3] + ""
        filter += " AND arc_state = '1' "

        # Set model
        model = QSqlTableModel()
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.setFilter(filter)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())

        # Attach model to table view
        widget.setModel(model)
        widget.show()