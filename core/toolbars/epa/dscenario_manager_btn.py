"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial
from sip import isdeleted

from qgis.PyQt.QtGui import QRegExpValidator, QStandardItemModel
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtCore import Qt, QRegExp
from qgis.PyQt.QtWidgets import QTableView, QAbstractItemView
from qgis.PyQt.QtWidgets import QDialog, QLineEdit

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
        self.feature_type = 'node'
        self.feature_types = ['node_id', 'arc_id', 'feature_id', 'connec_id', 'nodarc_id']
        self.rubber_band = tools_gw.create_rubberband(global_vars.canvas)


    def clicked_event(self):

        self._open_dscenario_manager()


    # region dscenario manager

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
        self._fill_manager_table()

        # Connect main dialog signals
        self.dlg_dscenario_manager.txt_name.textChanged.connect(partial(self._fill_manager_table))
        self.dlg_dscenario_manager.btn_execute.clicked.connect(partial(self._open_toolbox_function, None))
        self.dlg_dscenario_manager.btn_delete.clicked.connect(partial(self._delete_selected_dscenario))
        self.tbl_dscenario.doubleClicked.connect(self._open_dscenario)

        self.dlg_dscenario_manager.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_dscenario_manager))
        self.dlg_dscenario_manager.finished.connect(partial(tools_gw.save_settings, self.dlg_dscenario_manager))

        # Open dialog
        tools_gw.open_dialog(self.dlg_dscenario_manager, 'dscenario_manager')


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


    def _fill_manager_table(self, filter_name=""):
        """ Fill dscenario manager table with data from v_edit_cat_dscenario """

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


    def _manage_active_functions(self):
        """ Fill combobox with functions """

        values = [[3042, "Manage values"], [3134, "Create empty dscenario"]]
        if global_vars.project_type == 'ws':
            values.append([3110, "Create from CRM"])
            values.append([3112, "Create demand from ToC"])
            values.append([3108, "Create from ToC"])
        if global_vars.project_type == 'ud':
            values.append([3118, "Create from ToC"])
        tools_qt.fill_combo_values(self.dlg_dscenario_manager.cmb_actions, values, index_to_show=1)


    def _open_toolbox_function(self, function=None):
        """ Execute currently selected function from combobox """

        if function is None:
            function = tools_qt.get_combo_value(self.dlg_dscenario_manager, 'cmb_actions')

        toolbox_btn = GwToolBoxButton(None, None, None, None, None)
        connect = partial(self._fill_manager_table, self.filter_name.text())
        toolbox_btn.open_function_by_id(function, connect_signal=connect)
        return


    def _delete_selected_dscenario(self):
        """ Deletes the selected dscenario """

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
            self._fill_manager_table(self.filter_name.text())

    # endregion

    # region dscenario

    def _open_dscenario(self, index):
        """ Create custom dialog for selected dscenario and fill initial table """

        # Get selected dscenario_id
        row = index.row()
        column_index = tools_qt.get_col_index_by_col_name(self.tbl_dscenario, 'dscenario_id')
        self.selected_dscenario_id = index.sibling(row, column_index).data()
        column_index = tools_qt.get_col_index_by_col_name(self.tbl_dscenario, 'dscenario_type')
        self.selected_dscenario_type = index.sibling(row, column_index).data()

        # Create dialog
        self.dlg_dscenario = GwDscenarioUi()
        tools_gw.load_settings(self.dlg_dscenario)

        # Add icons
        tools_gw.add_icon(self.dlg_dscenario.btn_insert, "111", sub_folder="24x24")
        tools_gw.add_icon(self.dlg_dscenario.btn_delete, "112", sub_folder="24x24")
        tools_gw.add_icon(self.dlg_dscenario.btn_snapping, "137")

        default_tab_idx = 0
        # Select all dscenario views
        sql = f"SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_schema = ANY (current_schemas(false)) " \
              f"AND table_name LIKE 'inp_dscenario%'"
        rows = tools_db.get_rows(sql)
        if rows:
            views = [x[0] for x in rows]
            for view in views:
                qtableview = QTableView()
                qtableview.setObjectName(f"tbl_{view}")
                qtableview.clicked.connect(partial(self._manage_highlight, qtableview, view))
                tab_idx = self.dlg_dscenario.main_tab.addTab(qtableview, f"{view.split('_')[-1].capitalize()}")
                self.dlg_dscenario.main_tab.widget(tab_idx).setObjectName(view)

                if view.split('_')[-1].upper() == self.selected_dscenario_type:
                    default_tab_idx = tab_idx

        self.dlg_dscenario.main_tab.setCurrentIndex(default_tab_idx)

        # Connect signals
        self.dlg_dscenario.btn_insert.clicked.connect(partial(self._manage_insert))
        self.dlg_dscenario.btn_delete.clicked.connect(partial(self._manage_delete))
        self.dlg_dscenario.btn_snapping.clicked.connect(partial(self._manage_select))
        self.dlg_dscenario.main_tab.currentChanged.connect(partial(self._manage_current_changed))
        self.dlg_dscenario.finished.connect(self._selection_end)
        self.dlg_dscenario.finished.connect(partial(tools_gw.close_dialog, self.dlg_dscenario, True))

        self._fill_dscenario_table()

        sql = f"SELECT name FROM v_edit_cat_dscenario WHERE dscenario_id = {self.selected_dscenario_id}"
        row = tools_db.get_row(sql)
        dscenario_name = row[0]
        title = f"Dscenario {self.selected_dscenario_id} - {dscenario_name}"
        tools_gw.open_dialog(self.dlg_dscenario, 'dscenario', title=f"{title}")


    def _fill_dscenario_table(self, set_edit_triggers=QTableView.DoubleClicked, expr=None):
        """ Fill dscenario table with data from its corresponding table """

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
        # In order to make the first column not editable, we need to override the QSqlTableModel flags
        model.flags = lambda index: self.flags(index, model)


        # Check for errors
        if model.lastError().isValid():
            tools_qgis.show_warning(model.lastError().text())
        # Attach model to table view
        if expr:
            widget.setModel(model)
            widget.model().setFilter(expr)
        else:
            widget.setModel(model)

        # Set widget & model properties
        tools_qt.set_tableview_config(widget, selection=QAbstractItemView.SelectRows, edit_triggers=set_edit_triggers)
        tools_gw.set_tablemodel_config(self.dlg_dscenario, widget, f"{table_name[len(f'{self.schema_name}.'):]}")

        # Hide unwanted columns
        col_idx = tools_qt.get_col_index_by_col_name(widget, 'dscenario_id')
        if col_idx is not False:
            widget.setColumnHidden(col_idx, True)

        geom_col_idx = tools_qt.get_col_index_by_col_name(widget, 'the_geom')
        if geom_col_idx is not False:
            widget.setColumnHidden(geom_col_idx, True)


    def flags(self, index, model):

        flags = QSqlTableModel.flags(model, index)

        if index.column() == 1:
            flags = Qt.ItemIsSelectable | Qt.ItemIsEnabled
            return flags

        return QSqlTableModel.flags(model, index)


    def _manage_current_changed(self):
        """ Manages tab changes """

        # Fill current table
        self._fill_dscenario_table()

        # Manage insert typeahead
        viewname = "v_edit_" + self.feature_type
        tools_gw.set_completer_widget(viewname, self.dlg_dscenario.txt_feature_id, str(self.feature_type) + "_id")

        # Deactivate btn_snapping functionality
        self._selection_end()


    def _manage_feature_type(self):
        """ Manages current tableview feature type (node, arc, nodarc, etc.) """

        tableview = self.dlg_dscenario.main_tab.currentWidget()
        self.feature_type = 'node'
        feature_type = 'feature_id'

        for x in self.feature_types:
            col_idx = tools_qt.get_col_index_by_col_name(tableview, x)
            if col_idx is not False:
                feature_type = x
                break

        if feature_type != 'feature_id':
            self.feature_type = feature_type.split('_')[0]


    def _manage_highlight(self, qtableview, view, index):
        """ Creates rubberband to indicate which feature is selected """

        table = view.replace("_dscenario", "")
        feature_type = 'feature_id'

        for x in self.feature_types:
            col_idx = tools_qt.get_col_index_by_col_name(qtableview, x)
            if col_idx is not False:
                feature_type = x
                break
        if feature_type != 'feature_id':
            table = f"v_edit_{feature_type.split('_')[0]}"
        tools_qgis.hilight_feature_by_id(qtableview, table, feature_type, self.rubber_band, 5, index)


    def _manage_insert(self):
        """ Insert feature to dscenario via the button """

        tableview = self.dlg_dscenario.main_tab.currentWidget()
        view = tableview.objectName()

        sql = f"INSERT INTO {view} VALUES ({self.selected_dscenario_id}, '{self.dlg_dscenario.txt_feature_id.text()}');"
        tools_db.execute_sql(sql)

        # Refresh tableview
        self._fill_dscenario_table()


    def _manage_delete(self):
        """ Delete features from dscenario via the button """

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

        for x in self.feature_types:
            col_idx = tools_qt.get_col_index_by_col_name(tableview, x)
            if col_idx is not False:
                feature_type = x
                break

        values = []
        for index in selected_list:
            values.append(index.sibling(index.row(), col_idx).data())

        message = "Are you sure you want to delete these records?"
        answer = tools_qt.show_question(message, "Delete records", values)
        if answer:
            for value in values:
                sql = f"DELETE FROM {view} WHERE dscenario_id = {self.selected_dscenario_id} AND {feature_type} = '{value}'"
                tools_db.execute_sql(sql)

            # Refresh tableview
            self._fill_dscenario_table()


    def _manage_select(self):
        """ Button snapping """

        self._manage_feature_type()

        # Get current layer and remove selection
        current_layer = self.iface.activeLayer()
        current_layer.removeSelection()

        # Set active layer
        view_name = self.dlg_dscenario.main_tab.currentWidget().objectName()
        layer_name = 'v_edit_' + self.feature_type
        if self.feature_type == 'nodarc':
            layer_name = view_name.replace("dscenario_", "")
        layer = tools_qgis.get_layer_by_tablename(layer_name)
        self.iface.setActiveLayer(layer)
        tools_qgis.set_layer_visible(layer)

        # Clear feature id field
        #

        self._selection_init()
        # tools_gw.selection_init(self, self.dlg_dscenario, tableview)


    def _selection_init(self):
        """ Set canvas map tool to selection """

        tools_gw.disconnect_signal('dscenario_snapping')
        self.iface.actionSelect().trigger()
        self.connect_signal_selection_changed()


    def connect_signal_selection_changed(self):
        """ Connect signal selectionChanged """

        tools_gw.connect_signal(global_vars.canvas.selectionChanged, partial(self._manage_selection),
                                'dscenario_snapping', 'connect_signal_selection_changed_selectionChanged_manage_selection')

    def _manage_selection(self):
        """ Slot function for signal 'canvas.selectionChanged' """

        # Get feature_type and feature_id
        layer = self.iface.activeLayer()
        field_id = self.feature_type + "_id"

        # Iterate over layer
        if layer.selectedFeatureCount() > 0:
            selected_ids = []
            # Get selected features of the layer
            features = layer.selectedFeatures()
            for feature in features:
                # Append 'feature_id' into the list
                selected_ids.append(feature.attribute(field_id))

            if selected_ids:
                inserted = {f'{self.feature_type}': []}
                tableview = self.dlg_dscenario.main_tab.currentWidget()
                view = tableview.objectName()
                for f in selected_ids:
                    sql = f"INSERT INTO {view} VALUES ({self.selected_dscenario_id}, '{f}');"
                    result = tools_db.execute_sql(sql, log_sql=False, log_error=False, show_exception=False)
                    if result:
                        inserted[f'{self.feature_type}'].append(f)
                self._fill_dscenario_table()

                # Just select the inserted features
                tools_gw.get_expression_filter(self.feature_type, inserted, {f"{self.feature_type}": [layer]})


    def _selection_end(self):
        """ Stop selection mode """

        tools_gw.disconnect_signal('dscenario_snapping')
        tools_gw.remove_selection()
        self.iface.actionPan().trigger()

    # endregion
