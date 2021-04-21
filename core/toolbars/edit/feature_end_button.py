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
from qgis.gui import QgsRubberBand

from ...toolbars.dialog import GwAction
from ...ui.ui_manager import GwFeatureEndUi, GwInfoWorkcatUi, GwFeatureEndConnecUi
from ...utils import tools_gw
from .... import global_vars
from ....lib import tools_qgis, tools_qt, tools_log, tools_db


class GwFeatureEndButton(GwAction):
    """ Button 68: End feature """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)


    def clicked_event(self):

        # Get layers of every feature_type

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

        self.layers['arc'] = tools_gw.get_layers_from_feature_type('arc')
        self.layers['node'] = tools_gw.get_layers_from_feature_type('node')
        self.layers['connec'] = tools_gw.get_layers_from_feature_type('connec')
        self.layers['element'] = [tools_qgis.get_layer_by_tablename('v_edit_element')]

        self.layers = tools_gw.remove_selection(True, layers=self.layers)

        self.rubber_band = QgsRubberBand(self.canvas)

        # Create the dialog and signals
        self.dlg_work_end = GwFeatureEndUi()
        tools_gw.load_settings(self.dlg_work_end)
        self._set_edit_arc_downgrade_force('True')

        # Capture the current layer to return it at the end of the operation
        self.cur_active_layer = self.iface.activeLayer()

        widget_list = self.dlg_work_end.findChildren(QTableView)
        for widget in widget_list:
            tools_qt.set_tableview_config(widget)

        # Remove 'gully' for 'WS'
        self.project_type = tools_gw.get_project_type()
        if self.project_type == 'ws':
            tools_qt.remove_tab(self.dlg_work_end.tab_feature, 'tab_gully')
        else:
            self.layers['gully'] = tools_gw.get_layers_from_feature_type('gully')

        # Set icons
        tools_gw.add_icon(self.dlg_work_end.btn_insert, "111")
        tools_gw.add_icon(self.dlg_work_end.btn_delete, "112")
        tools_gw.add_icon(self.dlg_work_end.btn_snapping, "137")
        tools_gw.add_icon(self.dlg_work_end.btn_new_workcat, "193")


        # Adding auto-completion to a QLineEdit
        self.table_object = "cat_work"
        tools_gw.set_completer_object(self.dlg_work_end, self.table_object)

        # Set signals
        excluded_layers = ["v_edit_arc", "v_edit_node", "v_edit_connec", "v_edit_element", "v_edit_gully",
                           "v_edit_element"]
        layers_visibility = tools_gw.get_parent_layers_visibility()
        self.dlg_work_end.rejected.connect(partial(tools_gw.restore_parent_layers_visibility, layers_visibility))
        self.dlg_work_end.rejected.connect(lambda: self.rubber_band.reset())
        self.dlg_work_end.btn_accept.clicked.connect(partial(self._end_feature))
        self.dlg_work_end.btn_cancel.clicked.connect(partial(self._manage_close, self.dlg_work_end, True, False))
        self.dlg_work_end.rejected.connect(partial(self._manage_close, self.dlg_work_end, True, True))
        self.dlg_work_end.workcat_id_end.editTextChanged.connect(partial(self._fill_workids))
        self.dlg_work_end.btn_new_workcat.clicked.connect(partial(self._new_workcat))

        self.dlg_work_end.btn_insert.clicked.connect(
            partial(tools_gw.insert_feature, self, self.dlg_work_end, self.table_object, False, False, None, None))
        self.dlg_work_end.btn_delete.clicked.connect(
            partial(tools_gw.delete_records, self, self.dlg_work_end, self.table_object, False, None, None))
        self.dlg_work_end.btn_snapping.clicked.connect(
            partial(tools_gw.selection_init, self, self.dlg_work_end, self.table_object, False))

        self.dlg_work_end.workcat_id_end.activated.connect(partial(self._fill_workids))
        self.dlg_work_end.tab_feature.currentChanged.connect(
            partial(tools_gw.get_signal_change_tab, self.dlg_work_end, excluded_layers))

        self.dlg_work_end.tbl_cat_work_x_arc.clicked.connect(partial(tools_qgis.hilight_feature_by_id,
            self.dlg_work_end.tbl_cat_work_x_arc, "v_edit_arc", "arc_id", self.rubber_band, 5))
        self.dlg_work_end.tbl_cat_work_x_node.clicked.connect(partial(tools_qgis.hilight_feature_by_id,
            self.dlg_work_end.tbl_cat_work_x_node, "v_edit_node", "node_id", self.rubber_band, 10))
        self.dlg_work_end.tbl_cat_work_x_connec.clicked.connect(partial(tools_qgis.hilight_feature_by_id,
            self.dlg_work_end.tbl_cat_work_x_connec, "v_edit_connec", "connec_id", self.rubber_band, 10))
        self.dlg_work_end.tbl_cat_work_x_gully.clicked.connect(partial(tools_qgis.hilight_feature_by_id,
            self.dlg_work_end.tbl_cat_work_x_gully, "v_edit_gully", "gully_id", self.rubber_band, 10))
        self.dlg_work_end.tbl_cat_work_x_element.clicked.connect(partial(tools_qgis.hilight_feature_by_id,
            self.dlg_work_end.tbl_cat_work_x_element, "v_edit_element", "element_id", self.rubber_band, 10))

        # Set values
        self._fill_fields()

        # Adding auto-completion to a QLineEdit for default feature
        tools_gw.set_completer_widget("v_edit_arc", self.dlg_work_end.feature_id, "arc_id")

        # Set default tab 'arc'
        self.dlg_work_end.tab_feature.setCurrentIndex(0)
        tools_gw.get_signal_change_tab(self.dlg_work_end, excluded_layers)

        # Open dialog
        tools_gw.open_dialog(self.dlg_work_end, dlg_name='feature_end', maximize_button=False)


    # region private functions

    def _set_edit_arc_downgrade_force(self, value):

        # Update (or insert) on config_param_user the value of edit_arc_downgrade_force to true
        row = tools_gw.get_config_value('edit_arc_downgrade_force')
        if row:
            sql = (f"UPDATE config_param_user "
                   f"SET value = '{value}' "
                   f"WHERE parameter = 'edit_arc_downgrade_force' AND cur_user=current_user")
            tools_db.execute_sql(sql)
        else:
            sql = (f"INSERT INTO config_param_user (parameter, value, cur_user) "
                   f"VALUES ('edit_arc_downgrade_force', '{value}', current_user)")
            tools_db.execute_sql(sql)


    def _fill_fields(self):
        """ Fill dates and combos cat_work/state type end """

        sql = 'SELECT id as id, name as idval FROM value_state_type WHERE id IS NOT NULL AND state = 0'
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_work_end.cmb_statetype_end, rows, 1)
        row = tools_gw.get_config_value('edit_statetype_0_vdefault')
        if row:
            tools_qt.set_combo_value(self.dlg_work_end.cmb_statetype_end, row[0], 0)
        row = tools_gw.get_config_value('edit_enddate_vdefault')

        if row:
            enddate = self._manage_dates(row[0]).date()
            self.dlg_work_end.enddate.setDate(enddate)
        else:
            enddate = QDate.currentDate()
        tools_qt.set_calendar(self.dlg_work_end, "enddate", enddate)

        sql = "SELECT id FROM cat_work"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_box(self.dlg_work_end, self.dlg_work_end.workcat_id_end, rows, allow_nulls=False)
        tools_qt.set_autocompleter(self.dlg_work_end.workcat_id_end)
        row = tools_gw.get_config_value('edit_workcat_vdefault')
        if row:
            tools_qt.set_widget_text(self.dlg_work_end, self.dlg_work_end.workcat_id_end, row[0])


    def _manage_dates(self, date_value):
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


    def _fill_workids(self):
        """ Auto fill descriptions and workid's """

        workcat_id = tools_qt.get_text(self.dlg_work_end, self.dlg_work_end.workcat_id_end)
        if not workcat_id:
            return
        sql = (f"SELECT descript, builtdate "
               f"FROM cat_work "
               f"WHERE id = '{workcat_id}'")
        row = tools_db.get_row(sql)
        if row:
            tools_qt.set_widget_text(self.dlg_work_end, self.dlg_work_end.descript, row['descript'])
            tools_qt.set_calendar(self.dlg_work_end, self.dlg_work_end.builtdate, row['builtdate'], False)
        else:
            tools_qt.set_widget_text(self.dlg_work_end, self.dlg_work_end.descript, '')
            tools_qt.set_calendar(self.dlg_work_end, self.dlg_work_end.builtdate, None, False)


    def _set_list_selected_id(self, qtable):

        selected_list = qtable.model()
        self.selected_list = []
        if selected_list is None:
            self._manage_close(self.dlg_work_end)
            return

        for x in range(0, selected_list.rowCount()):
            index = selected_list.index(x, 0)
            id_ = selected_list.data(index)
            self.selected_list.append(id_)


    def _end_feature(self):
        """ Get elements from all the tables and update his data """

        # Setting values
        self.workcat_id_end = tools_qt.get_text(self.dlg_work_end, self.dlg_work_end.workcat_id_end)
        self.statetype_id_end = tools_qt.get_combo_value(self.dlg_work_end, self.dlg_work_end.cmb_statetype_end, 0)
        self.enddate = tools_qt.get_calendar_date(self.dlg_work_end, self.dlg_work_end.enddate)
        self.workcatdate = tools_qt.get_calendar_date(self.dlg_work_end, self.dlg_work_end.builtdate)
        self.description = tools_qt.get_text(self.dlg_work_end, self.dlg_work_end.descript, False, False)

        if self.workcat_id_end in ('null', None):
            message = "Please select a workcat id end"
            tools_qgis.show_warning(message)
            return

        self._set_list_selected_id(self.dlg_work_end.tbl_cat_work_x_arc)

        row = None
        if len(self.selected_list) > 0:
            ids = tuple(self.selected_list)

            # When converting it into a tuple, if it only has one element, remove the "," that is added at the end
            if len(self.selected_list) == 1:
                ids = f"{tuple(self.selected_list)}"[:-2] + ")"
                
            sql = (f"SELECT * FROM v_ui_arc_x_relations "
                   f"WHERE arc_id IN {ids} AND arc_state = '1'")
            row = tools_db.get_row(sql, log_sql=True)

        if row:
            self.dlg_work = GwFeatureEndConnecUi()
            tools_gw.load_settings(self.dlg_work)

            self.dlg_work.btn_cancel.clicked.connect(partial(self._close_dialog_workcat_list, self.dlg_work))
            self.dlg_work.btn_accept.clicked.connect(self._exec_downgrade)
            self._set_completer()

            table_relations = "v_ui_arc_x_relations"
            self.dlg_work.arc_id.textChanged.connect(
                partial(self._filter_by_id, self.dlg_work.tbl_arc_x_relations, self.dlg_work.arc_id, table_relations))

            self.tbl_arc_x_relations = self.dlg_work.findChild(QTableView, "tbl_arc_x_relations")
            self.tbl_arc_x_relations.setSelectionBehavior(QAbstractItemView.SelectRows)

            filter_ = ""
            for row in self.selected_list:
                filter_ += f"arc_id = '{row}' OR "
            filter_ = filter_[:-3] + ""
            filter_ += " AND arc_state = '1' "

            tools_qt.fill_table(self.tbl_arc_x_relations, table_relations, filter_)
            self.tbl_arc_x_relations.doubleClicked.connect(
                partial(self._open_selected_object, self.tbl_arc_x_relations))

            tools_gw.open_dialog(self.dlg_work, dlg_name='feature_end_connec')

        else:
            # Update tablename of every feature_type
            self._set_list_selected_id(self.dlg_work_end.tbl_cat_work_x_element)
            self._update_feature_type("element")
            self._set_list_selected_id(self.dlg_work_end.tbl_cat_work_x_connec)
            self._update_feature_type("connec")
            if str(self.project_type) == 'ud':
                self._set_list_selected_id(self.dlg_work_end.tbl_cat_work_x_gully)
                self._update_feature_type("gully")
            self._set_list_selected_id(self.dlg_work_end.tbl_cat_work_x_arc)
            self._update_feature_type("arc")
            self._set_list_selected_id(self.dlg_work_end.tbl_cat_work_x_node)
            self._update_feature_type("node")


            self._manage_close(self.dlg_work_end, True)

            # Remove selection for all layers in TOC
            for layer in self.iface.mapCanvas().layers():
                if layer.type() == layer.VectorLayer:
                    layer.removeSelection()
            self.iface.mapCanvas().refresh()


    def _update_feature_type(self, feature_type):
        """ Get elements from @feature_type and update his corresponding table """

        if len(self.selected_list) == 0:
            return

        id_list = ""
        for id_ in self.selected_list:
            id_list += f'"{id_}", '
        id_list = "[" + id_list[:-2] + "]"

        feature = f'"featureType":"{feature_type}", "featureId":{id_list}'
        extras = f'"state_type":"{self.statetype_id_end}", "workcat_id_end":"{self.workcat_id_end}", '
        extras += f'"enddate":"{self.enddate}", "workcat_date":"{self.workcatdate}", "description":"{self.description}"'
        body = tools_gw.create_body(feature=feature, extras=extras)
        tools_gw.execute_procedure('gw_fct_setendfeature', body)


    def _open_selected_object(self, widget):
        """ Open object form with selected record of the table """

        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return

        row = selected_list[0].row()
        feature_id = widget.model().record(row).value("arc_id")

        self._open_arc_form(feature_id)


    def _open_arc_form(self, arc_id):
        """ Open form corresponding to start or end node of the current arc """

        # Get sys_feature_cat.id from cat_feature.id
        sql = (f"SELECT sys_type"
               f" FROM v_edit_arc"
               f" WHERE arc_id = '{arc_id}'")
        row = tools_db.get_row(sql)
        if not row:
            return

        arc_type = row[0].lower()
        arc_table = "v_edit_man_" + arc_type
        layer_arc = tools_qgis.get_layer_by_tablename(arc_table)

        aux = "\"arc_id\" = "
        aux += f"'{arc_id}'"
        expr = QgsExpression(aux)
        if expr.hasParserError():
            message = "Expression Error"
            tools_qgis.show_warning(message, parameter=expr.parserErrorString())
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


    def _exec_downgrade(self):

        message = "Are you sure you want to disconnect this elements?"
        title = "Disconnect elements"
        answer = tools_qt.show_question(message, title)
        if not answer:
            return

        # Update tablename of every feature_type
        self._set_list_selected_id(self.dlg_work_end.tbl_cat_work_x_arc)
        self._update_feature_type("arc")

        self.canvas.refresh()
        self.dlg_work.close()
        self._end_feature()


    def _set_completer(self):
        """ Set autocompleters of the form """

        # Adding auto-completion to a QLineEdit - visit_id
        completer = QCompleter()
        self.dlg_work.arc_id.setCompleter(completer)
        model = QStringListModel()

        model.setStringList(self.selected_list)
        completer.setModel(model)


    def _filter_by_id(self, table, widget_txt, tablename):

        id_ = tools_qt.get_text(self.dlg_work, widget_txt)
        if id_ != 'null':
            expr = f" arc_id = '{id_}'"
            # Refresh model with selected filter
            table.model().setFilter(expr)
            table.model().select()
        else:
            self._fill_table_relations(table, self.schema_name + "." + tablename)


    def _fill_table_relations(self, widget, table_name):
        """ Set a model with selected filter. Attach that model to selected table """

        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        filter_ = ""
        for row in self.selected_list:
            filter_ += f"arc_id = '{row}' OR "
        filter_ = filter_[:-3] + ""
        filter_ += " AND arc_state = '1' "

        # Set model
        model = QSqlTableModel(db=global_vars.qgis_db_credentials)
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.setFilter(filter_)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            tools_qgis.show_warning(model.lastError().text())

        # Attach model to table view
        widget.setModel(model)
        widget.show()


    def _close_dialog_workcat_list(self, dlg=None):
        """ Close dialog """
        tools_gw.close_dialog(dlg)
        tools_gw.open_dialog(self.dlg_work_end)


    def _manage_close(self, dialog, force_downgrade=False, show_warning=False):
        """ Close dialog and disconnect snapping """

        tools_gw.close_dialog(dialog)
        tools_qgis.disconnect_snapping()
        tools_qgis.disconnect_signal_selection_changed()
        if force_downgrade:
            sql = ("SELECT feature_type, feature_id, log_message "
                   "FROM audit_log_data "
                   "WHERE  fid = 128 AND cur_user = current_user")
            rows = tools_db.get_rows(sql, log_sql=False)
            ids_ = ""
            if rows:
                for row in rows:
                    ids_ += str(row[1]) + ", "
                    state_statetype = str(row['log_message']).split(',')
                    sql = (f"UPDATE {row[0].lower()} "
                           f"SET state = '{state_statetype[0]}', state_type = '{state_statetype[1]}' "
                           f"WHERE {row[0]}_id = '{row[1]}';")
                    tools_db.execute_sql(sql)

                ids_ = ids_[:-2]
                if show_warning and len(ids_) != 0:
                    msg = 'These items could not be downgrade to state 0'
                    tools_qt.show_info_box(msg, title="Warning", inf_text=str(ids_))
                sql = ("DELETE FROM audit_log_data "
                       "WHERE fid = 128 AND cur_user = current_user")
                tools_db.execute_sql(sql)
        self._set_edit_arc_downgrade_force('False')
        self.canvas.refresh()


    def _new_workcat(self):

        self.dlg_new_workcat = GwInfoWorkcatUi()
        tools_gw.load_settings(self.dlg_new_workcat)

        tools_qt.set_calendar(self.dlg_new_workcat, self.dlg_new_workcat.builtdate, None, True)
        table_object = "cat_work"
        tools_gw.set_completer_widget(table_object, self.dlg_new_workcat.cat_work_id, 'id')

        # Set signals
        self.dlg_new_workcat.btn_accept.clicked.connect(partial(self._manage_new_workcat_accept, table_object))
        self.dlg_new_workcat.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_new_workcat))

        # Open dialog
        tools_gw.open_dialog(self.dlg_new_workcat, dlg_name='info_workcat')


    def _manage_new_workcat_accept(self, table_object):
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
            row = tools_db.get_row(sql, log_info=False)
            if row is None:
                sql = f"INSERT INTO cat_work ({fields}) VALUES ({values})"
                tools_db.execute_sql(sql)
                sql = "SELECT id FROM cat_work ORDER BY id"
                rows = tools_db.get_rows(sql)
                if rows:
                    tools_qt.fill_combo_box(self.dlg_work_end, self.dlg_work_end.workcat_id_end, rows)
                    aux = self.dlg_work_end.workcat_id_end.findText(str(cat_work_id))
                    self.dlg_work_end.workcat_id_end.setCurrentIndex(aux)

                tools_gw.close_dialog(self.dlg_new_workcat)

            else:
                msg = "This Workcat already exist"
                tools_qt.show_info_box(msg, "Warning")

    # endregion