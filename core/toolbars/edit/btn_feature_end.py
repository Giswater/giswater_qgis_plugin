"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from datetime import datetime
from functools import partial

from qgis.PyQt.QtCore import QDate, QStringListModel
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtWidgets import QAbstractItemView, QTableView, QCompleter
from qgis.core import QgsExpression, QgsFeatureRequest

from ...toolbars.parent_dialog import GwParentAction
from ...ui.ui_manager import FeatureEndUi, InfoWorkcatUi, FeatureEndConnecUi
from ...utils import tools_gw
from ....lib import tools_qgis, tools_qt, tools_log


class GwEndFeatureButton(GwParentAction):

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        super().__init__(icon_path, action_name, text, toolbar, action_group)


    def clicked_event(self):
        # Get layers of every geom_type

        # Setting lists
        self.ids = []
        self.list_ids = {}
        self.list_ids['arc'] = []
        self.list_ids['node'] = []
        self.list_ids['connec'] = []
        self.list_ids['gully'] = []
        self.list_ids['element'] = []

        # Setting layers
        self.layers = {}
        self.layers['arc'] = []
        self.layers['node'] = []
        self.layers['connec'] = []
        self.layers['gully'] = []
        self.layers['element'] = []

        self.layers['arc'] = tools_gw.get_group_layers('arc')
        self.layers['node'] = tools_gw.get_group_layers('node')
        self.layers['connec'] = tools_gw.get_group_layers('connec')
        self.layers['element'] = [self.controller.get_layer_by_tablename('v_edit_element')]

        self.layers = tools_qgis.remove_selection(True, layers=self.layers)

        # Create the dialog and signals
        self.dlg_work_end = FeatureEndUi()
        tools_gw.load_settings(self.dlg_work_end)
        self.set_edit_arc_downgrade_force('True')

        # Set default geom_type and viewname
        geom_type = "arc"
        viewname = "v_edit_" + geom_type

        # Capture the current layer to return it at the end of the operation
        self.cur_active_layer = self.iface.activeLayer()

        widget_list = self.dlg_work_end.findChildren(QTableView)
        for widget in widget_list:
            tools_qt.set_qtv_config(widget)

        # Remove 'gully' for 'WS'
        self.project_type = tools_gw.get_project_type()
        if self.project_type == 'ws':
            tools_qt.remove_tab(self.dlg_work_end.tab_feature, 'tab_gully')
        else:
            self.layers['gully'] = tools_gw.get_group_layers('gully')

        # Set icons
        tools_gw.add_icon(self.dlg_work_end.btn_insert, "111")
        tools_gw.add_icon(self.dlg_work_end.btn_delete, "112")
        tools_gw.add_icon(self.dlg_work_end.btn_snapping, "137")
        tools_gw.add_icon(self.dlg_work_end.btn_new_workcat, "193")


        # Adding auto-completion to a QLineEdit
        self.table_object = "cat_work"
        tools_qt.set_completer_object(self.dlg_work_end, self.table_object)

        # Set signals
        self.dlg_work_end.btn_accept.clicked.connect(partial(self.manage_workcat_end_accept))
        self.dlg_work_end.btn_cancel.clicked.connect(
            partial(self.manage_close, self.dlg_work_end, self.table_object, self.cur_active_layer, force_downgrade=True))
        self.dlg_work_end.rejected.connect(partial(self.manage_close, self.dlg_work_end,
                                                   self.table_object, self.cur_active_layer, force_downgrade=True, show_warning=True))
        self.dlg_work_end.workcat_id_end.editTextChanged.connect(partial(self.fill_workids))
        self.dlg_work_end.btn_new_workcat.clicked.connect(partial(self.new_workcat))
        # TODO: Set variables self.ids, self.layers, self.list_ids using return parameters
        self.dlg_work_end.btn_insert.clicked.connect(partial(tools_qgis.insert_feature, self.dlg_work_end, self.table_object,
                                                             geom_type=geom_type, ids=self.ids, layers=self.layers,
                                                             list_ids=self.list_ids))
        # TODO: Set variables self.ids, self.layers, self.list_ids using return parameters
        self.dlg_work_end.btn_delete.clicked.connect(partial(tools_qt.delete_records, self.dlg_work_end, self.table_object,
                                                             geom_type=geom_type, layers=self.layers, ids=self.ids,
                                                             list_ids=self.list_ids))
        # TODO: Set variables self.ids, self.layers, self.list_ids using return parameters
        self.dlg_work_end.btn_snapping.clicked.connect(
            partial(tools_gw.selection_init, self.dlg_work_end, self.table_object, geom_type=geom_type, layers=self.layers))
        self.dlg_work_end.workcat_id_end.activated.connect(partial(self.fill_workids))
        self.dlg_work_end.tab_feature.currentChanged.connect(
            partial(tools_gw.get_signal_change_tab, self.dlg_work_end, excluded_layers=["v_edit_element"]))

        # Set values
        self.fill_fields()

        # Adding auto-completion to a QLineEdit for default feature
        tools_qt.set_completer_widget(viewname, self.dlg_work_end.feature_id, str(geom_type) + "_id")

        # Set default tab 'arc'
        self.dlg_work_end.tab_feature.setCurrentIndex(0)
        tools_gw.get_signal_change_tab(self.dlg_work_end, excluded_layers=["v_edit_element"])

        # Open dialog
        tools_gw.open_dialog(self.dlg_work_end, dlg_name='feature_end', maximize_button=False)



    def set_edit_arc_downgrade_force(self, value):

        # Update (or insert) on config_param_user the value of edit_arc_downgrade_force to true
        row = tools_gw.get_config('edit_arc_downgrade_force')
        if row:
            sql = (f"UPDATE config_param_user "
                   f"SET value = '{value}' "
                   f"WHERE parameter = 'edit_arc_downgrade_force' AND cur_user=current_user")
            self.controller.execute_sql(sql)
        else:
            sql = (f"INSERT INTO config_param_user (parameter, value, cur_user) "
                   f"VALUES ('edit_arc_downgrade_force', '{value}', current_user)")
            self.controller.execute_sql(sql)


    def fill_fields(self):
        """ Fill dates and combos cat_work/state type end """

        sql = 'SELECT id as id, name as idval FROM value_state_type WHERE id IS NOT NULL AND state = 0'
        rows = self.controller.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_work_end.cmb_statetype_end, rows, 1)
        row = tools_gw.get_config('edit_statetype_0_vdefault')
        if row:
            tools_qt.set_combo_value(self.dlg_work_end.cmb_statetype_end, row[0], 0)
        row = tools_gw.get_config('edit_enddate_vdefault')

        if row:
            enddate = self.manage_dates(row[0]).date()
            self.dlg_work_end.enddate.setDate(enddate)
        else:
            enddate = QDate.currentDate()
        tools_qt.set_calendar(self.dlg_work_end, "enddate", enddate)

        sql = "SELECT id FROM cat_work"
        rows = self.controller.get_rows(sql)
        tools_qt.fillComboBox(self.dlg_work_end, self.dlg_work_end.workcat_id_end, rows, allow_nulls=False)
        tools_qt.set_autocompleter(self.dlg_work_end.workcat_id_end)
        row = tools_gw.get_config('edit_workcat_vdefault')
        if row:
            tools_qt.set_widget_text(self.dlg_work_end, self.dlg_work_end.workcat_id_end, row[0])


    def manage_dates(self, date_value):
        """ Manage dates """

        date_result = None
        try:
            date_result = str(date_value)
            date_result = date_result.replace("-", "/")
            date_result = datetime.strptime(date_result, '%Y/%m/%d')
        except Exception as e:
            tools_log.log_warning(str(e))
        finally:
            return date_result


    def fill_workids(self):
        """ Auto fill descriptions and workid's """

        workcat_id = tools_qt.get_text(self.dlg_work_end, self.dlg_work_end.workcat_id_end)
        if not workcat_id:
            return
        sql = (f"SELECT descript, builtdate "
               f"FROM cat_work "
               f"WHERE id = '{workcat_id}'")
        row = self.controller.get_row(sql)
        if row:
            tools_qt.set_widget_text(self.dlg_work_end, self.dlg_work_end.descript, row['descript'])
            tools_qt.set_calendar(self.dlg_work_end, self.dlg_work_end.builtdate, row['builtdate'], False)
        else:
            tools_qt.set_widget_text(self.dlg_work_end, self.dlg_work_end.descript, '')
            tools_qt.set_calendar(self.dlg_work_end, self.dlg_work_end.builtdate, None, False)


    def get_list_selected_id(self, qtable):

        selected_list = qtable.model()
        self.selected_list = []
        ids_list = ""
        if selected_list is None:
            self.manage_close(self.dlg_work_end, self.table_object, self.cur_active_layer, force_downgrade=False)
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

        # Setting values
        self.workcat_id_end = tools_qt.get_text(self.dlg_work_end, self.dlg_work_end.workcat_id_end)
        self.enddate = tools_qt.get_calendar_date(self.dlg_work_end, self.dlg_work_end.enddate)
        self.statetype_id_end = tools_qt.get_combo_value(self.dlg_work_end, self.dlg_work_end.cmb_statetype_end, 0)

        if self.workcat_id_end in ('null', None):
            message = "Please select a workcat id end"
            tools_gw.show_warning(message)
            return

        ids_list = self.get_list_selected_id(self.dlg_work_end.tbl_cat_work_x_arc)
        row = None
        if ids_list:
            sql = (f"SELECT * FROM v_ui_arc_x_relations "
                   f"WHERE arc_id IN ( {ids_list}) AND arc_state = '1'")
            row = self.controller.get_row(sql)

        if row:
            self.dlg_work = FeatureEndConnecUi()
            tools_gw.load_settings(self.dlg_work)

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

            tools_gw.open_dialog(self.dlg_work, dlg_name='feature_end_connec')

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

            # Remove selection for all layers in TOC
            for layer in self.iface.mapCanvas().layers():
                if layer.type() == layer.VectorLayer:
                    layer.removeSelection()
            self.iface.mapCanvas().refresh()


    def update_geom_type(self, geom_type, ids_list):
        """ Get elements from @geom_type and update his corresponding table """

        tablename = "v_edit_" + geom_type
        if self.selected_list is None:
            return

        sql = ""
        for id_ in self.selected_list:
            sql += (f"UPDATE {tablename} "
                    f"SET state = '0', state_type = '{self.statetype_id_end}', workcat_id_end = '{self.workcat_id_end}', "
                    f"enddate = '{self.enddate}' "
                    f"WHERE {geom_type}_id = '{id_}';\n")
        if sql != "":
            status = self.controller.execute_sql(sql, log_sql=False)
            if status:
                tools_gw.show_info("Features updated successfully!")

        # TODO: Check this
        feature = f'"featureType":"{geom_type}", "featureId":"{ids_list}"'
        body = tools_gw.create_body(feature=feature)
        tools_gw.get_json('gw_fct_setendfeature', body)


    def fill_table(self, widget, table_name, filter_):
        """ Set a model with selected filter.
        Attach that model to selected table """

        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        # Set model
        self.model = QSqlTableModel(db=self.controller.db)
        self.model.setTable(table_name)
        self.model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        if filter_:
            self.model.setFilter(filter_)
        self.model.setSort(0, 0)
        self.model.select()

        # Check for errors
        if self.model.lastError().isValid():
            tools_gw.show_warning(self.model.lastError().text())

        # Attach model to table view
        widget.setModel(self.model)


    def open_selected_object(self, widget):
        """ Open object form with selected record of the table """

        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_gw.show_warning(message)
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
        layer_arc = self.controller.get_layer_by_tablename(arc_table)

        aux = "\"arc_id\" = "
        aux += f"'{arc_id}'"
        expr = QgsExpression(aux)
        if expr.hasParserError():
            message = "Expression Error"
            tools_gw.show_warning(message, parameter=expr.parserErrorString())
            return

        id_list = None
        if layer_arc:
            # Get a featureIterator from this expression:
            it = layer_arc.getFeatures(QgsFeatureRequest(expr))
            id_list = [i for i in it]
            if id_list:
                self.iface.openFeatureForm(layer_arc, id_list[0])

        # Zoom to object
        if id_list:
            canvas = self.iface.mapCanvas()
            layer_arc.selectByIds([id_list[0].id()])
            canvas.zoomToSelected(layer_arc)
            canvas.zoomIn()


    def exec_downgrade(self):

        message = "Are you sure you want to disconnect this elements?"
        title = "Disconnect elements"
        answer = tools_qt.ask_question(message, title)
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
        completer = QCompleter()
        self.dlg_work.arc_id.setCompleter(completer)
        model = QStringListModel()

        model.setStringList(self.selected_list)
        completer.setModel(model)


    def filter_by_id(self, table, widget_txt, tablename):

        id_ = tools_qt.get_text(self.dlg_work, widget_txt)
        if id_ != 'null':
            expr = f" arc_id = '{id_}'"
            # Refresh model with selected filter
            table.model().setFilter(expr)
            table.model().select()
        else:
            self.fill_table_relations(table, self.schema_name + "." + tablename)


    def fill_table_relations(self, widget, table_name):
        """ Set a model with selected filter. Attach that model to selected table """

        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        filter_ = ""
        for row in self.selected_list:
            filter_ += f"arc_id = '{row}' OR "
        filter_ = filter_[:-3] + ""
        filter_ += " AND arc_state = '1' "

        # Set model
        model = QSqlTableModel(db=self.controller.db)
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.setFilter(filter_)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            tools_gw.show_warning(model.lastError().text())

        # Attach model to table view
        widget.setModel(model)
        widget.show()


    def close_dialog_workcat_list(self, dlg=None):
        """ Close dialog """
        tools_gw.close_dialog(dlg)
        tools_gw.open_dialog(self.dlg_work_end)


    def manage_close(self, dialog, table_object, cur_active_layer=None, force_downgrade=False, show_warning=False):
        """ Close dialog and disconnect snapping """

        tools_gw.close_dialog(dialog)
        tools_gw.hide_parent_layers(excluded_layers=["v_edit_element"])
        tools_qgis.disconnect_snapping()
        tools_qgis.disconnect_signal_selection_changed()
        if force_downgrade:
            sql = ("SELECT feature_type, feature_id, log_message "
                   "FROM audit_log_data "
                   "WHERE  fid = 128 AND cur_user = current_user")
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

                ids_ = ids_[:-2]
                if show_warning and len(ids_) != 0:
                    msg = 'These items could not be downgrade to state 0'
                    tools_qt.show_info_box(msg, title="Warning", inf_text=str(ids_))
                sql = ("DELETE FROM audit_log_data "
                       "WHERE fid = 128 AND cur_user = current_user")
                self.controller.execute_sql(sql)
        self.set_edit_arc_downgrade_force('False')
        self.canvas.refresh()


    def new_workcat(self):

        self.dlg_new_workcat = InfoWorkcatUi()
        tools_gw.load_settings(self.dlg_new_workcat)

        tools_qt.set_calendar(self.dlg_new_workcat, self.dlg_new_workcat.builtdate, None, True)
        table_object = "cat_work"
        tools_qt.set_completer_widget(table_object, self.dlg_new_workcat.cat_work_id, 'id')

        # Set signals
        self.dlg_new_workcat.btn_accept.clicked.connect(partial(self.manage_new_workcat_accept, table_object))
        self.dlg_new_workcat.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_new_workcat))

        # Open dialog
        tools_gw.open_dialog(self.dlg_new_workcat, dlg_name='info_workcat')


    def manage_new_workcat_accept(self, table_object):
        """ Insert table 'cat_work'. Add cat_work """

        # Get values from dialog
        values = ""
        fields = ""

        cat_work_id = tools_qt.get_text(self.dlg_new_workcat, self.dlg_new_workcat.cat_work_id)
        if cat_work_id != "null":
            fields += 'id, '
            values += f"'{cat_work_id}', "
        descript = tools_qt.get_text(self.dlg_new_workcat, "descript")
        if descript != "null":
            fields += 'descript, '
            values += f"'{descript}', "
        link = tools_qt.get_text(self.dlg_new_workcat, "link")
        if link != "null":
            fields += 'link, '
            values += f"'{link}', "
        workid_key_1 = tools_qt.get_text(self.dlg_new_workcat, "workid_key_1")
        if workid_key_1 != "null":
            fields += 'workid_key1, '
            values += f"'{workid_key_1}', "
        workid_key_2 = tools_qt.get_text(self.dlg_new_workcat, "workid_key_2")
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
            tools_qt.show_info_box(msg, "Warning")
        else:
            # Check if this element already exists
            sql = (f"SELECT DISTINCT(id)"
                   f" FROM {table_object}"
                   f" WHERE id = '{cat_work_id}'")
            row = self.controller.get_row(sql, log_info=False)
            if row is None:
                sql = f"INSERT INTO cat_work ({fields}) VALUES ({values})"
                self.controller.execute_sql(sql)
                sql = "SELECT id FROM cat_work ORDER BY id"
                rows = self.controller.get_rows(sql)
                if rows:
                    tools_qt.fillComboBox(self.dlg_work_end, self.dlg_work_end.workcat_id_end, rows)
                    aux = self.dlg_work_end.workcat_id_end.findText(str(cat_work_id))
                    self.dlg_work_end.workcat_id_end.setCurrentIndex(aux)

                tools_gw.close_dialog(self.dlg_new_workcat)

            else:
                msg = "This Workcat already exist"
                tools_qt.show_info_box(msg, "Warning")

