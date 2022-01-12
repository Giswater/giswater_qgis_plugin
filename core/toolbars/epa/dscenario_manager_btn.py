"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import json
import re
from functools import partial
from sip import isdeleted

from qgis.PyQt.QtGui import QRegExpValidator, QStandardItemModel
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtCore import QRegExp
from qgis.PyQt.QtWidgets import QTableView, QAbstractItemView
from qgis.PyQt.QtWidgets import QDialog, QLabel, QLineEdit, QPlainTextEdit

from ..dialog import GwAction
from ..utilities.toolbox_btn import GwToolBoxButton
from ...ui.ui_manager import GwDscenarioManagerUi, GwDscenarioUi
from ...utils import tools_gw
from .... import global_vars
from ....lib import tools_qgis, tools_qt, tools_db


class GwDscenarioManagerButton(GwAction):
    """ Button 215: Dscenario manager """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.rubber_band = tools_gw.create_rubberband(global_vars.canvas)


    def clicked_event(self):

        self._open_dscenario_manager()


    # region private functions

    def _open_dscenario_manager(self):
        """ Open dscenario manager """

        # Main dialog
        self.dlg_dscenario_manager = GwDscenarioManagerUi()
        tools_gw.load_settings(self.dlg_dscenario_manager)

        # Manage active buttons depending on project type
        self._manage_active_functions()

        # Apply filter validator
        self.filter_name = self.dlg_dscenario_manager.findChild(QLineEdit, 'txt_name')
        reg_exp = QRegExp('([^"\'\\\\])*')  # Don't allow " or ' or \ because it breaks the query
        self.filter_name.setValidator(QRegExpValidator(reg_exp))

        # Fill table
        self.tbl_dscenario = self.dlg_dscenario_manager.findChild(QTableView, 'tbl_dscenario')
        # self.fill_table(self.dlg_dscenario_manager, self.tbl_dscenario, 'v_edit_cat_dscenario')
        self._fill_tbl()

        # Connect main dialog signals
        self.dlg_dscenario_manager.txt_name.textChanged.connect(partial(self._fill_tbl))
        self.dlg_dscenario_manager.btn_execute.clicked.connect(partial(self._open_toolbox_function, None))
        self.dlg_dscenario_manager.btn_delete.clicked.connect(partial(self._delete_selected_dscenario))
        self.tbl_dscenario.doubleClicked.connect(self._open_dscenario)

        # selection_model = self.dlg_dscenario_manager.tbl_dscenario.selectionModel()
        # selection_model.selectionChanged.connect(partial(self._fill_info))
        # self.dlg_dscenario_manager.btn_delete.clicked.connect(partial(self._delete_workspace))

        self.dlg_dscenario_manager.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_dscenario_manager))
        self.dlg_dscenario_manager.rejected.connect(partial(tools_gw.save_settings, self.dlg_dscenario_manager))

        # Open dialog
        tools_gw.open_dialog(self.dlg_dscenario_manager, 'dscenario_manager')


    def _manage_active_functions(self):

        values = [[3042, "Manage values"]]
        if global_vars.project_type == 'ws':
            values.append([3110, "Create from CRM"])
            values.append([3112, "Create demand from ToC"])
            values.append([3108, "Create from ToC"])
        if global_vars.project_type == 'ud':
            values.append([3118, "Create from ToC"])
        tools_qt.fill_combo_values(self.dlg_dscenario_manager.cmb_actions, values, index_to_show=1)


    def _open_dscenario(self, index):

        # Get selected dscenario_id
        row = index.row()
        column_index = tools_qt.get_col_index_by_col_name(self.tbl_dscenario, 'dscenario_id')
        self.selected_dscenario_id = index.sibling(row, column_index).data()

        # Create dialog
        self.dlg_dscenario = GwDscenarioUi()
        tools_gw.load_settings(self.dlg_dscenario)

        # Add icons
        tools_gw.add_icon(self.dlg_dscenario.btn_insert, "111")
        tools_gw.add_icon(self.dlg_dscenario.btn_delete, "112")
        tools_gw.add_icon(self.dlg_dscenario.btn_select, "137")

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
        self.layers['gully'] = []
        self.layers['element'] = []
        self.layers['arc'] = tools_gw.get_layers_from_feature_type('arc')
        self.layers['node'] = tools_gw.get_layers_from_feature_type('node')
        self.layers['connec'] = tools_gw.get_layers_from_feature_type('connec')
        if self.project_type.upper() == 'UD':
            self.layers['gully'] = tools_gw.get_layers_from_feature_type('gully')

        # Select all dscenario views
        sql = f"SELECT table_name FROM INFORMATION_SCHEMA.views WHERE table_schema = ANY (current_schemas(false)) " \
              f"AND table_name LIKE 'v_edit_inp_dscenario%'"
        rows = tools_db.get_rows(sql)
        if rows:
            views = [x[0] for x in rows]
            for view in views:
                qtableview = QTableView()
                qtableview.setObjectName(f"tbl_{view}")
                qtableview.clicked.connect(partial(self._manage_highlight, qtableview, view))
                tab_idx = self.dlg_dscenario.main_tab.addTab(qtableview, f"{view.split('_')[-1].capitalize()}")
                self.dlg_dscenario.main_tab.widget(tab_idx).setObjectName(view)

        # Connect signals
        self.dlg_dscenario.btn_insert.clicked.connect(partial(self._manage_insert))
        self.dlg_dscenario.btn_delete.clicked.connect(partial(self._manage_delete))
        self.dlg_dscenario.btn_select.clicked.connect(partial(self._manage_select))

        self.dlg_dscenario.main_tab.currentChanged.connect(partial(self._manage_current_changed))

        self._fill_table()

        tools_gw.open_dialog(self.dlg_dscenario, 'dscenario')


    def _fill_table(self, hidde=False, set_edit_triggers=QTableView.DoubleClicked, expr=None):
        """ Set a model with selected filter.
            Attach that model to selected table
            @setEditStrategy:
            0: OnFieldChange
            1: OnRowChange
            2: OnManualSubmit
        """

        # Manage exception if dialog is closed
        if isdeleted(self.dlg_dscenario):
            return

        table_name = f"{self.dlg_dscenario.main_tab.currentWidget().objectName()}"
        widget = self.dlg_dscenario.main_tab.currentWidget()

        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        # Set model
        model = QSqlTableModel(db=global_vars.qgis_db_credentials)
        model.setTable(table_name)
        model.setFilter(f"dscenario_id = {self.selected_dscenario_id}")
        model.setEditStrategy(QSqlTableModel.OnFieldChange)
        model.setSort(0, 0)
        model.select()

        # When change some field we need to refresh Qtableview and filter by psector_id
        widget.setSelectionBehavior(QAbstractItemView.SelectRows)
        # model.beforeUpdate.connect(partial(self.manage_update_state, model))
        # model.dataChanged.connect(partial(self._fill_tbl, self.filter_name.text()))
        # model.dataChanged.connect(partial(self.update_total, dialog, widget))
        widget.setEditTriggers(set_edit_triggers)

        # Check for errors
        if model.lastError().isValid():
            tools_qgis.show_warning(model.lastError().text())
        # Attach model to table view
        if expr:
            widget.setModel(model)
            widget.model().setFilter(expr)
        else:
            widget.setModel(model)

        geom_col_idx = tools_qt.get_col_index_by_col_name(widget, 'the_geom')
        if geom_col_idx is not False:
            widget.setColumnHidden(geom_col_idx, True)

        # if hidde:
        #     self.refresh_table(dialog, widget)


    def _manage_current_changed(self):

        # Fill current table
        self._fill_table()

        # Manage insert typeahead


    def _manage_highlight(self, qtableview, view, index):

        table = view.replace("_dscenario", "")
        feature_type = 'feature_id'

        feature_types = ['node_id', 'arc_id', 'feature_id', 'connec_id']
        for x in feature_types:
            col_idx = tools_qt.get_col_index_by_col_name(qtableview, x)
            if col_idx is not False:
                feature_type = x
                break
        if feature_type != 'feature_type':
            table = f"v_edit_{feature_type.split('_')[0]}"
        tools_qgis.hilight_feature_by_id(qtableview, table, feature_type, self.rubber_band, 5, index)


    def _manage_insert(self):

        self.dlg_dscenario.main_tab.currentIndex()
        tableview = self.dlg_dscenario.main_tab.currentWidget()
        view = tableview.objectName()

        sql = f"INSERT INTO {view} VALUES ({self.selected_dscenario_id}, '{self.dlg_dscenario.txt_feature_id.text()}');"
        tools_db.execute_sql(sql)

        # Refresh tableview
        self._fill_table()


    def _manage_delete(self):

        tableview = self.dlg_dscenario.main_tab.currentWidget()
        # Get selected row
        selected_list = tableview.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return

        # Get selected feature_id
        view = tableview.objectName()
        col_idx = -1
        feature_type = 'feature_id'

        feature_types = ['node_id', 'arc_id', 'feature_id', 'connec_id']
        for x in feature_types:
            col_idx = tools_qt.get_col_index_by_col_name(tableview, x)
            if col_idx is not False:
                feature_type = x
                break
        index = tableview.selectionModel().currentIndex()
        value = index.sibling(index.row(), col_idx).data()

        message = "Are you sure you want to delete these records?"
        answer = tools_qt.show_question(message, "Delete records", index.sibling(index.row(), col_idx).data())
        if answer:
            sql = f"DELETE FROM {view} WHERE dscenario_id = {self.selected_dscenario_id} AND {feature_type} = '{value}'"
            tools_db.execute_sql(sql)

            # Refresh tableview
            self._fill_table()


    def _manage_select(self):
        tableview = self.dlg_dscenario.main_tab.currentWidget()
        self.feature_type = 'all'
        feature_type = 'feature_id'

        feature_types = ['node_id', 'arc_id', 'feature_id', 'connec_id']
        for x in feature_types:
            col_idx = tools_qt.get_col_index_by_col_name(tableview, x)
            if col_idx is not False:
                feature_type = x
                break

        if feature_type != 'feature_id':
            self.feature_type = feature_type.split('_')[0]

        tools_gw.selection_init(self, self.dlg_dscenario, tableview)


    def _delete_selected_dscenario(self):

        # Get selected row
        selected_list = self.tbl_dscenario.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return

        # Get selected dscenario id
        index = self.tbl_dscenario.selectionModel().currentIndex()
        value = index.sibling(index.row(), 0).data()

        message = "Are you sure you want to delete these records?"
        answer = tools_qt.show_question(message, "Delete records", index.sibling(index.row(), 1).data())
        if answer:
            sql = f"DELETE FROM v_edit_cat_dscenario WHERE dscenario_id = {value}"
            tools_db.execute_sql(sql)

            # Refresh tableview
            self._fill_tbl(self.filter_name.text())


    def _get_list(self, table_name='v_edit_cat_dscenario', filter_name="", filter_id=None):
        """ Mount and execute the query for gw_fct_getlist """

        feature = f'"tableName":"{table_name}"'
        filter_fields = f'"limit": -1, "name": {{"filterSign":"ILIKE", "value":"{filter_name}"}}'
        if filter_id is not None:
            filter_fields += f', "dscenario_id": {{"filterSign":"=", "value":"{filter_id}"}}'
        body = tools_gw.create_body(feature=feature, filter_fields=filter_fields)
        json_result = tools_gw.execute_procedure('gw_fct_getlist', body)
        if json_result is None or json_result['status'] == 'Failed':
            return False
        complet_list = json_result
        if not complet_list:
            return False

        return complet_list


    def _fill_tbl(self, filter_name=""):
        """ Fill table with initial data into QTableView """

        complet_list = self._get_list("v_edit_cat_dscenario", filter_name)

        if complet_list is False:
            return False, False
        for field in complet_list['body']['data']['fields']:
            if 'hidden' in field and field['hidden']: continue
            model = self.tbl_dscenario.model()
            if model is None:
                model = QStandardItemModel()
                self.tbl_dscenario.setModel(model)
            model.removeRows(0, model.rowCount())

            if field['value']:
                self.tbl_dscenario = tools_gw.add_tableview_header(self.tbl_dscenario, field)
                self.tbl_dscenario = tools_gw.fill_tableview_rows(self.tbl_dscenario, field)
            # TODO: config_form_tableview
            # widget = tools_gw.set_tablemodel_config(self.dlg_dscenario_manager, self.tbl_dscenario, 'tbl_dscenario', 1, True)
            tools_qt.set_tableview_config(self.tbl_dscenario)

        return complet_list


    def _open_toolbox_function(self, function=None):

        if function is None:
            function = tools_qt.get_combo_value(self.dlg_dscenario_manager, 'cmb_actions')

        toolbox_btn = GwToolBoxButton(None, None, None, None, None)
        connect = partial(self._fill_tbl, self.filter_name.text())
        toolbox_btn.open_function_by_id(function, connect_signal=connect)
        return

    # endregion
