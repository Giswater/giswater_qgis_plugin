"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except ImportError:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT < 29900:
    from qgis.PyQt.QtGui import QStringListModel
else:
    from qgis.PyQt.QtCore import QStringListModel

from qgis.core import QgsExpression, QgsFeatureRequest
from qgis.PyQt.QtCore import Qt, QDate
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtWidgets import QAbstractItemView, QTableView, QCompleter

from functools import partial
from datetime import datetime

from .. import utils_giswater
from .parent_manage import ParentManage
from ..ui_manager import WorkcatEnd, NewWorkcat
from ..ui_manager import WorkcatEndList


class ManageWorkcatEnd(ParentManage):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control 'Workcat end' of toolbar 'edit' """
        ParentManage.__init__(self, iface, settings, controller, plugin_dir)


    def manage_workcat_end(self):
        
        self.remove_selection(True)
        
        # Create the dialog and signals
        self.dlg_work_end = WorkcatEnd()
        self.load_settings(self.dlg_work_end)
        self.set_edit_arc_downgrade_force('True')
        
        # Capture the current layer to return it at the end of the operation
        self.cur_active_layer = self.iface.activeLayer()

        self.set_selectionbehavior(self.dlg_work_end)

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
            self.dlg_work_end.tab_feature.removeTab(4)
        else:
            self.layers['gully'] = self.controller.get_group_layers('gully')

        # Set icons
        self.set_icon(self.dlg_work_end.btn_insert, "111")
        self.set_icon(self.dlg_work_end.btn_delete, "112")
        self.set_icon(self.dlg_work_end.btn_snapping, "137")

        # Adding auto-completion to a QLineEdit
        self.table_object = "cat_work"
        self.set_completer_object(self.dlg_work_end, self.table_object)

        # Set signals
        self.dlg_work_end.btn_accept.clicked.connect(partial(self.manage_workcat_end_accept))
        self.dlg_work_end.btn_cancel.clicked.connect(partial(self.manage_close, self.dlg_work_end, self.table_object, self.cur_active_layer,  force_downgrade=True))
        self.dlg_work_end.rejected.connect(partial(self.manage_close, self.dlg_work_end, self.table_object, self.cur_active_layer,  force_downgrade=True, show_warning=True))
        self.dlg_work_end.workcat_id_end.editTextChanged.connect(partial(self.fill_workids))
        self.dlg_work_end.btn_new_workcat.clicked.connect(partial(self.new_workcat))
        self.dlg_work_end.btn_insert.clicked.connect(partial(self.insert_feature, self.dlg_work_end, self.table_object))
        self.dlg_work_end.btn_delete.clicked.connect(partial(self.delete_records, self.dlg_work_end, self.table_object))
        self.dlg_work_end.btn_snapping.clicked.connect(partial(self.selection_init, self.dlg_work_end, self.table_object))
        self.dlg_work_end.workcat_id_end.activated.connect(partial(self.fill_workids))
        self.dlg_work_end.tab_feature.currentChanged.connect(partial(self.tab_feature_changed, self.dlg_work_end, self.table_object))

        # Set values
        self.fill_fields()

        # Adding auto-completion to a QLineEdit for default feature
        geom_type = "arc"
        viewname = "v_edit_" + geom_type
        self.set_completer_feature_id(self.dlg_work_end.feature_id, geom_type, viewname)

        # Set default tab 'arc'
        self.dlg_work_end.tab_feature.setCurrentIndex(0)
        self.geom_type = "arc"
        self.tab_feature_changed(self.dlg_work_end, self.table_object)

        # Open dialog
        self.open_dialog(self.dlg_work_end, maximize_button=False)


    def set_edit_arc_downgrade_force(self, value):
        
        # Update (or insert) on config_param_user the value of edit_arc_downgrade_force to true
        sql = ("SELECT * FROM config_param_user "
               "WHERE parameter = 'edit_arc_downgrade_force' AND cur_user=current_user")
        row = self.controller.get_row(sql, log_info=False)
        if row:
            sql = (f"UPDATE config_param_user "
                   f"SET value = '{value}' "
                   f"WHERE parameter = 'edit_arc_downgrade_force' AND cur_user=current_user")
            self.controller.execute_sql(sql, log_sql=True)
        else:
            sql = (f"INSERT INTO config_param_user (parameter, value, cur_user) "
                   f"VALUES ('edit_arc_downgrade_force', '{value}', current_user)")
            self.controller.execute_sql(sql, commit=self.autocommit)


    def fill_fields(self):
        """ Fill dates and combo cat_work """

        sql = ("SELECT value FROM config_param_user "
               "WHERE parameter = 'enddate_vdefault' and cur_user = current_user")
        row = self.controller.get_row(sql, log_info=False)
        if row:
            enddate = self.manage_dates(row[0]).date()
            self.dlg_work_end.enddate.setDate(enddate)
        else:
            enddate = QDate.currentDate()
        utils_giswater.setCalendarDate(self.dlg_work_end, "enddate", enddate)

        sql = "SELECT id FROM cat_work"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_work_end, self.dlg_work_end.workcat_id_end, rows, allow_nulls=False)
        utils_giswater.set_autocompleter(self.dlg_work_end.workcat_id_end)
        sql = ("SELECT value FROM config_param_user "
               "WHERE parameter = 'workcat_id_end_vdefault' and cur_user = current_user")
        row = self.controller.get_row(sql, log_info=False)
        if row:
            utils_giswater.setWidgetText(self.dlg_work_end, self.dlg_work_end.workcat_id_end, row[0])


    def manage_dates(self, date_value):
        """ Manage dates """

        date_result = None
        try:
            date_result = str(date_value)
            date_result = date_result.replace("-", "/")
            date_result = datetime.strptime(date_result, '%Y/%m/%d')
        except Exception as e:
            self.controller.log_warning(str(e))
        finally:
            return date_result


    def fill_workids(self):
        """ Auto fill descriptions and workid's """
        
        workcat_id = utils_giswater.getWidgetText(self.dlg_work_end, self.dlg_work_end.workcat_id_end)
        if not workcat_id:
            return
        sql = (f"SELECT descript, builtdate "
               f"FROM cat_work "
               f"WHERE id = '{workcat_id}'")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setText(self.dlg_work_end, self.dlg_work_end.descript, row['descript'])
            utils_giswater.setCalendarDate(self.dlg_work_end, self.dlg_work_end.builtdate, row['builtdate'], False)
        else:
            utils_giswater.setText(self.dlg_work_end, self.dlg_work_end.descript, '')
            utils_giswater.setCalendarDate(self.dlg_work_end, self.dlg_work_end.builtdate, None, False)


    def get_list_selected_id(self, qtable):
        
        selected_list = qtable.model()
        self.selected_list = []
        ids_list = ""
        if selected_list is None:
            self.manage_close(self.dlg_work_end, self.table_object, self.cur_active_layer,  force_downgrade=False)
            return

        for x in range(0, selected_list.rowCount()):
            index = selected_list.index(x, 0)
            id_ = selected_list.data(index)
            self.selected_list.append(id_)
            ids_list += f"'{id_}',"
        ids_list = ids_list[:-1]

        return ids_list


    def manage_workcat_end_accept(self):
        """ Get elements from all the tables and update his data """

        if self.workcat_id_end == 'null' or self.workcat_id_end is None:
            message = "Please select a workcat id end"
            self.controller.show_warning(message)
            return

        ids_list = self.get_list_selected_id(self.dlg_work_end.tbl_cat_work_x_arc)
        row = None
        if ids_list:
            sql = (f"SELECT * FROM v_ui_arc_x_relations "
                   f"WHERE arc_id IN ( {ids_list}) AND arc_state = '1'")
            row = self.controller.get_row(sql)
            ids_list = None

        if row:
            self.dlg_work = WorkcatEndList()
            self.load_settings(self.dlg_work)

            self.dlg_work.btn_cancel.clicked.connect(partial(self.close_dialog_workcat_list, self.dlg_work))
            self.dlg_work.btn_accept.clicked.connect(self.exec_downgrade)
            self.set_completer()

            table_relations = "v_ui_arc_x_relations"
            self.dlg_work.arc_id.textChanged.connect(
                partial(self.filter_by_id, self.dlg_work.tbl_arc_x_relations, self.dlg_work.arc_id, table_relations))

            self.tbl_arc_x_relations = self.dlg_work.findChild(QTableView, "tbl_arc_x_relations")
            self.tbl_arc_x_relations.setSelectionBehavior(QAbstractItemView.SelectRows)

            filter_ = ""
            for row in self.selected_list:
                filter_ += f"arc_id = '{row}' OR "
            filter_ = filter_[:-3] + ""
            filter_ += " AND arc_state = '1' "

            self.fill_table(self.tbl_arc_x_relations, table_relations, filter_)
            self.tbl_arc_x_relations.doubleClicked.connect(
                partial(self.open_selected_object, self.tbl_arc_x_relations))
            
            self.open_dialog(self.dlg_work)

        # TODO: Function update_geom_type() don't use parameter ids_list
        else:
            # Update tablename of every geom_type
            ids_list = self.get_list_selected_id(self.dlg_work_end.tbl_cat_work_x_arc)
            self.update_geom_type("arc", ids_list)
            ids_list = self.get_list_selected_id(self.dlg_work_end.tbl_cat_work_x_node)
            self.update_geom_type("node", ids_list)
            ids_list = self.get_list_selected_id(self.dlg_work_end.tbl_cat_work_x_connec)
            self.update_geom_type("connec", ids_list)
            ids_list = self.get_list_selected_id(self.dlg_work_end.tbl_cat_work_x_element)
            self.update_geom_type("element", ids_list)
            if str(self.project_type) == 'ud':
                ids_list = self.get_list_selected_id(self.dlg_work_end.tbl_cat_work_x_gully)
                self.update_geom_type("gully", ids_list)

            self.manage_close(self.dlg_work_end, self.table_object, self.cur_active_layer, force_downgrade=True)


    def update_geom_type(self, geom_type, ids_list):
        """ Get elements from @geom_type and update his corresponding table """

        tablename = "v_edit_" + geom_type
        if self.selected_list is None:
            return

        sql = ""
        for id_ in self.selected_list:
            sql += (f"UPDATE {tablename} "
                    f"SET state = '0', workcat_id_end = '{self.workcat_id_end}', "
                    f"enddate = '{self.enddate}' "
                    f"WHERE {geom_type}_id = '{id_}';\n")
        if sql != "":
            status = self.controller.execute_sql(sql, log_sql=False)
            if status:
                self.controller.show_info("Features updated successfully!")


    def fill_table(self, widget, table_name, filter_):
        """ Set a model with selected filter.
        Attach that model to selected table """

        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        # Set model
        self.model = QSqlTableModel()
        self.model.setTable(table_name)
        self.model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        if filter_:
            self.model.setFilter(filter_)
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
        sql = (f"SELECT sys_type"
               f" FROM v_edit_arc"
               f" WHERE arc_id = '{arc_id}'")
        row = self.controller.get_row(sql)
        if not row:
            return

        arc_type = row[0].lower()
        arc_table = "v_edit_man_" + arc_type
        layer_arc= self.controller.get_layer_by_tablename(arc_table)

        aux = "\"arc_id\" = "
        aux += f"'{arc_id}'"
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
        title = "Disconnect elements"
        answer = self.controller.ask_question(message, title)
        if not answer:
            return

        # Update tablename of every geom_type
        ids_list = self.get_list_selected_id(self.dlg_work_end.tbl_cat_work_x_arc)
        self.update_geom_type("arc", ids_list)

        self.canvas.refresh()
        self.dlg_work.close()
        self.manage_workcat_end_accept()


    def set_completer(self):
        """ Set autocompleters of the form """

        # Adding auto-completion to a QLineEdit - visit_id
        self.completer = QCompleter()
        self.dlg_work.arc_id.setCompleter(self.completer)
        model = QStringListModel()

        model.setStringList(self.selected_list)
        self.completer.setModel(model)


    def filter_by_id(self, table, widget_txt, tablename):

        id_ = utils_giswater.getWidgetText(self.dlg_work, widget_txt)
        if id_ != 'null':
            expr = f" arc_id = '{id_}'"
            # Refresh model with selected filter
            table.model().setFilter(expr)
            table.model().select()
        else:
            self.fill_table_relations(table, self.schema_name + "." + tablename)


    def fill_table_relations(self, widget, table_name):
        """ Set a model with selected filter. Attach that model to selected table """

        filter_ = ""
        for row in self.selected_list:
            filter_ += f"arc_id = '{row}' OR "
        filter_ = filter_[:-3] + ""
        filter_ += " AND arc_state = '1' "

        # Set model
        model = QSqlTableModel()
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.setFilter(filter_)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())

        # Attach model to table view
        widget.setModel(model)
        widget.show()


    def close_dialog_workcat_list(self, dlg=None):
        """ Close dialog """

        if dlg is None or type(dlg) is bool:
            dlg = self.dlg
        try:
            self.save_settings(dlg)
            dlg.close()
            map_tool = self.canvas.mapTool()
            # If selected map tool is from the plugin, set 'Pan' as current one
            if map_tool.toolName() == '':
                self.iface.actionPan().trigger()
        except AttributeError:
            pass

        self.open_dialog(self.dlg_work_end)


    def manage_close(self, dialog, table_object, cur_active_layer=None, force_downgrade=False, show_warning=False):
        """ Close dialog and disconnect snapping """

        self.close_dialog(dialog)
        self.hide_generic_layers()
        self.disconnect_snapping()
        self.disconnect_signal_selection_changed()
        if force_downgrade:
            sql = ("SELECT feature_type, feature_id, log_message "
                   "FROM audit_log_data "
                   "WHERE  fprocesscat_id = '28' AND user_name = current_user")
            rows = self.controller.get_rows(sql, log_sql=False)
            ids_ = ""
            if rows:
                for row in rows:
                    ids_ += str(row[1]) + ", "
                    state_statetype = str(row['log_message']).split(',')
                    sql = (f"UPDATE {row[0].lower()} "
                           f"SET state = '{state_statetype[0]}', state_type = '{state_statetype[1]}' "
                           f"WHERE {row[0]}_id = '{row[1]}';")
                    self.controller.execute_sql(sql)

                self.set_edit_arc_downgrade_force('False')
                ids_ = ids_[:-2]
                if show_warning and len(ids_) != 0:
                    msg = 'These items could not be downgrade to state 0'
                    self.controller.show_info_box(msg, title="Warning", inf_text=str(ids_))
                sql = ("DELETE FROM audit_log_data "
                       "WHERE fprocesscat_id ='28' AND user_name = current_user")
                self.controller.execute_sql(sql)

        self.canvas.refresh()


    def new_workcat(self):

        self.dlg_new_workcat = NewWorkcat()
        self.load_settings(self.dlg_new_workcat)

        utils_giswater.setCalendarDate(self.dlg_new_workcat, self.dlg_new_workcat.builtdate, None, True)
        table_object = "cat_work"
        self.set_completer_widget(table_object,self.dlg_new_workcat.cat_work_id, 'id')

        # Set signals
        self.dlg_new_workcat.btn_accept.clicked.connect(partial(self.manage_new_workcat_accept, table_object))
        self.dlg_new_workcat.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_new_workcat))

        # Open dialog
        self.open_dialog(self.dlg_new_workcat)


    def manage_new_workcat_accept(self, table_object):
        """ Insert table 'cat_work'. Add cat_work """

        # Get values from dialog
        values = ""
        fields = ""
        
        cat_work_id = utils_giswater.getWidgetText(self.dlg_new_workcat, self.dlg_new_workcat.cat_work_id)
        if cat_work_id != "null":
            fields += 'id, '
            values += f"'{cat_work_id}', "
        descript = utils_giswater.getWidgetText(self.dlg_new_workcat, "descript")
        if descript != "null":
            fields += 'descript, '
            values += f"'{descript}', "
        link = utils_giswater.getWidgetText(self.dlg_new_workcat, "link")
        if link != "null":
            fields += 'link, '
            values += f"'{link}', "
        workid_key_1 = utils_giswater.getWidgetText(self.dlg_new_workcat, "workid_key_1")
        if workid_key_1 != "null":
            fields += 'workid_key1, '
            values += f"'{workid_key_1}', "
        workid_key_2 = utils_giswater.getWidgetText(self.dlg_new_workcat, "workid_key_2")
        if workid_key_2 != "null":
            fields += 'workid_key2, '
            values += f"'{workid_key_2}', "
        builtdate = self.dlg_new_workcat.builtdate.dateTime().toString('yyyy-MM-dd')

        if builtdate != "null":
            fields += 'builtdate, '
            values += f"'{builtdate}', "

        if values == "":
            return

        fields = fields[:-2]
        values = values[:-2]
        if cat_work_id == 'null':
            msg = "Work_id field is empty"
            self.controller.show_info_box(msg, "Warning")
        else:
            # Check if this element already exists
            sql = (f"SELECT DISTINCT(id)"
                   f" FROM {table_object}"
                   f" WHERE id = '{cat_work_id}'")
            row = self.controller.get_row(sql, log_info=False, log_sql=True)
            if row is None:
                sql = f"INSERT INTO cat_work ({fields}) VALUES ({values})"
                self.controller.execute_sql(sql, log_sql=True)
                sql = "SELECT id FROM cat_work ORDER BY id"
                rows = self.controller.get_rows(sql)
                if rows:
                    utils_giswater.fillComboBox(self.dlg_work_end, self.dlg_work_end.workcat_id_end, rows)
                    aux = self.dlg_work_end.workcat_id_end.findText(str(cat_work_id))
                    self.dlg_work_end.workcat_id_end.setCurrentIndex(aux)

                self.close_dialog(self.dlg_new_workcat)

            else:
                msg = "This Workcat already exist"
                self.controller.show_info_box(msg, "Warning")
        
