"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial
from sip import isdeleted

from qgis.core import QgsProject
from qgis.PyQt.QtGui import QRegExpValidator, QStandardItemModel, QCursor
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtCore import Qt, QRegExp, QPoint
from qgis.PyQt.QtWidgets import QTableView, QAbstractItemView, QMenu, QCheckBox, QWidgetAction, QComboBox
from qgis.PyQt.QtWidgets import QDialog, QLineEdit

from ..dialog import GwAction
from ..utilities.toolbox_btn import GwToolBoxButton
from ...ui.ui_manager import GwDscenarioManagerUi, GwDscenarioUi
from ...utils import tools_gw
from ...models.item_delegates import ReadOnlyDelegate, EditableDelegate
from .... import global_vars
from ....lib import tools_qgis, tools_qt, tools_db


class GwDscenarioManagerButton(GwAction):
    """ Button 215: Dscenario manager """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.feature_type = 'node'
        self.feature_types = ['node_id', 'arc_id', 'feature_id', 'connec_id', 'nodarc_id', 'rg_id', 'poll_id', 'sector_id', 'lidco_id']
        self.filter_dict = {"inp_dscenario_controls": {"filter_table": "v_edit_sector", "feature_type": "sector"},
                            "inp_dscenario_rules": {"filter_table": "v_edit_sector", "feature_type": "sector"},
                            "inp_dscenario_demand": {"filter_table": ["v_edit_inp_junction", "v_edit_inp_connec"], "feature_type": ["node", "connec"]},
                            "inp_dscenario_raingage": {"filter_table": "v_edit_raingage", "feature_type": "rg"},
                            # DISABLED:
                            # "inp_dscenario_lid_usage": {"filter_table": "v_edit_inp_dscenario_lid_usage", "feature_type": "lidco"},
                            # "inp_dscenario_inflows": {"filter_table": "v_edit_inp_inflows", "feature_type": "node"},
                            # "inp_dscenario_treatment": {"filter_table": "v_edit_inp_treatment", "feature_type": "node"},
                            # "inp_dscenario_flwreg_pump": {"filter_table": "v_edit_inp_pump", "feature_type": "arc"},
                            # "inp_dscenario_flwreg_weir": {"filter_table": "v_edit_inp_weir", "feature_type": "arc"},
                            # "inp_dscenario_flwreg_orifice": {"filter_table": "v_edit_inp_orifice", "feature_type": "arc"},
                            # "inp_dscenario_flwreg_outlet": {"filter_table": "v_edit_inp_outlet", "feature_type": "arc"},
                            # "inp_dscenario_inflows_poll": {"filter_table": "v_edit_inp_inflows_poll", "feature_type": "poll"},
                            # "inp_dscenario_pump_additional": {"filter_table": "v_edit_inp_pump_additional", "feature_type": "node"},
                            }
        self.filter_disabled = ["inp_dscenario_lid_usage", "inp_dscenario_inflows", "inp_dscenario_treatment",
                                "inp_dscenario_flwreg_pump", "inp_dscenario_flwreg_weir", "inp_dscenario_flwreg_orifice",
                                "inp_dscenario_flwreg_outlet", "inp_dscenario_inflows_poll", "inp_dscenario_pump_additional"
                                ]
        self.rubber_band = tools_gw.create_rubberband(global_vars.canvas)


    def clicked_event(self):

        self._open_dscenario_manager()


    # region dscenario manager

    def _open_dscenario_manager(self):
        """ Open dscenario manager """

        # Main dialog
        self.dlg_dscenario_manager = GwDscenarioManagerUi()
        tools_gw.load_settings(self.dlg_dscenario_manager)

        # Manage btn create
        self._manage_btn_create()

        # Apply filter validator
        self.filter_name = self.dlg_dscenario_manager.findChild(QLineEdit, 'txt_name')
        reg_exp = QRegExp('([^"\'\\\\])*')  # Don't allow " or ' or \ because it breaks the query
        self.filter_name.setValidator(QRegExpValidator(reg_exp))

        # Fill table
        self.tbl_dscenario = self.dlg_dscenario_manager.findChild(QTableView, 'tbl_dscenario')
        self._fill_manager_table()

        # Connect main dialog signals
        self.dlg_dscenario_manager.txt_name.textChanged.connect(partial(self._fill_manager_table))
        self.dlg_dscenario_manager.btn_duplicate.clicked.connect(partial(self._duplicate_selected_dscenario))
        self.dlg_dscenario_manager.btn_update.clicked.connect(partial(self._open_toolbox_function, 3042))
        self.dlg_dscenario_manager.btn_delete.clicked.connect(partial(self._delete_selected_dscenario))
        self.dlg_dscenario_manager.btn_delete.clicked.connect(partial(tools_gw.refresh_selectors))
        self.tbl_dscenario.doubleClicked.connect(self._open_dscenario)

        self.dlg_dscenario_manager.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_dscenario_manager))
        self.dlg_dscenario_manager.finished.connect(partial(tools_gw.save_settings, self.dlg_dscenario_manager))
        self.dlg_dscenario_manager.finished.connect(partial(self.save_user_values))

        # Open dialog
        tools_gw.open_dialog(self.dlg_dscenario_manager, 'dscenario_manager')


    def save_user_values(self):
        pass


    def _get_list(self, table_name='v_ui_cat_dscenario', filter_name="", filter_id=None):
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
        """ Fill dscenario manager table with data from v_ui_cat_dscenario """

        complet_list = self._get_list("v_ui_cat_dscenario", filter_name)

        if complet_list is False:
            return False, False
        for field in complet_list['body']['data']['fields']:
            if field.get('hidden'): continue
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


    def _manage_btn_create(self):
        """ Fill btn_create QMenu """

        # Functions
        values = [[3134, "Create empty dscenario"]]
        if global_vars.project_type == 'ws':
            values.append([3110, "Create from CRM"])
            values.append([3112, "Create demand from ToC"])
            values.append([3108, "Create network from ToC"])
            values.append([3158, "Create from Mincut"])
        if global_vars.project_type == 'ud':
            values.append([3118, "Create from ToC"])

        # Create and populate QMenu
        create_menu = QMenu()
        for value in values:
            num = value[0]
            label = value[1]
            action = create_menu.addAction(f"{label}")
            action.triggered.connect(partial(self._open_toolbox_function, num))

        self.dlg_dscenario_manager.btn_create.setMenu(create_menu)


    def _open_toolbox_function(self, function, signal=None, connect=None):
        """ Execute currently selected function from combobox """

        toolbox_btn = GwToolBoxButton(None, None, None, None, None)
        if connect is None:
            connect = [partial(self._fill_manager_table, self.filter_name.text()), partial(tools_gw.refresh_selectors)]
        else:
            if type(connect) != list:
                connect = [connect]
        dlg_functions = toolbox_btn.open_function_by_id(function, connect_signal=connect)
        return dlg_functions


    def _duplicate_selected_dscenario(self):
        """ Duplicates the selected dscenario """

        # Get selected row
        selected_list = self.tbl_dscenario.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=self.dlg_dscenario_manager)
            return

        # Get selected dscenario id
        index = self.tbl_dscenario.selectionModel().currentIndex()
        value = index.sibling(index.row(), 0).data()

        # Execute toolbox function
        dlg_functions = self._open_toolbox_function(3156)
        # Set dscenario_id in combo copyFrom
        tools_qt.set_combo_value(dlg_functions.findChild(QComboBox, 'copyFrom'), f"{value}", 0)
        tools_qt.set_widget_enabled(dlg_functions, 'copyFrom', False)


    def _delete_selected_dscenario(self):
        """ Deletes the selected dscenario """

        # Get selected row
        selected_list = self.tbl_dscenario.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=self.dlg_dscenario_manager)
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
        tools_gw.add_icon(self.dlg_dscenario.btn_toc, "306", sub_folder="24x24")
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
        self.dlg_dscenario.btn_toc.clicked.connect(partial(self._manage_add_layers))
        self.dlg_dscenario.btn_insert.clicked.connect(partial(self._manage_insert))
        self.dlg_dscenario.btn_delete.clicked.connect(partial(self._manage_delete))
        self.dlg_dscenario.btn_snapping.clicked.connect(partial(self._manage_select))
        self.dlg_dscenario.main_tab.currentChanged.connect(partial(self._manage_current_changed))
        self.dlg_dscenario.finished.connect(self._selection_end)
        self.dlg_dscenario.finished.connect(partial(tools_gw.close_dialog, self.dlg_dscenario, True))

        self._manage_current_changed()

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

        self.table_name = f"{self.dlg_dscenario.main_tab.currentWidget().objectName()}"
        widget = self.dlg_dscenario.main_tab.currentWidget()

        if self.schema_name not in self.table_name:
            self.table_name = self.schema_name + "." + self.table_name

        # Set model
        model = QSqlTableModel(db=global_vars.qgis_db_credentials)
        model.setTable(self.table_name)
        model.setFilter(f"dscenario_id = {self.selected_dscenario_id}")
        model.setEditStrategy(QSqlTableModel.OnFieldChange)
        model.setSort(0, 0)
        model.select()
        # Set item delegates
        readonly_delegate = ReadOnlyDelegate(widget)
        widget.setItemDelegateForColumn(0, readonly_delegate)
        widget.setItemDelegateForColumn(1, readonly_delegate)
        editable_delegate = EditableDelegate(widget)
        for x in range(2, model.columnCount()):
            widget.setItemDelegateForColumn(x, editable_delegate)


        # Check for errors
        if model.lastError().isValid():
            tools_qgis.show_warning(model.lastError().text(), dialog=self.dlg_dscenario)
        # Attach model to table view
        if expr:
            widget.setModel(model)
            widget.model().setFilter(expr)
        else:
            widget.setModel(model)
        widget.setSortingEnabled(True)

        # Set widget & model properties
        tools_qt.set_tableview_config(widget, selection=QAbstractItemView.SelectRows, edit_triggers=set_edit_triggers, sectionResizeMode=0)
        tools_gw.set_tablemodel_config(self.dlg_dscenario, widget, f"{self.table_name[len(f'{self.schema_name}.'):]}")

        # Hide unwanted columns
        col_idx = tools_qt.get_col_index_by_col_name(widget, 'dscenario_id')
        if col_idx not in (None, False):
            widget.setColumnHidden(col_idx, True)

        geom_col_idx = tools_qt.get_col_index_by_col_name(widget, 'the_geom')
        if geom_col_idx not in (None, False):
            widget.setColumnHidden(geom_col_idx, True)

        # Sort the table by feature id
        model.sort(1, 0)


    def _manage_current_changed(self):
        """ Manages tab changes """

        # Fill current table
        self._fill_dscenario_table()

        # Refresh txt_feature_id
        tools_qt.set_widget_text(self.dlg_dscenario, self.dlg_dscenario.txt_feature_id, '')
        self.dlg_dscenario.txt_feature_id.setStyleSheet(None)

        # Manage insert typeahead
        # Get index of selected tab
        index_tab = self.dlg_dscenario.main_tab.currentIndex()
        tab_name = self.dlg_dscenario.main_tab.widget(index_tab).objectName()
        enable = tab_name not in self.filter_disabled

        # Populate typeahead
        if enable:
            self._manage_feature_type()
            table_name = f"v_edit_{tab_name.replace('dscenario_', '')}"
            feature_type = self.feature_type
            if self.filter_dict.get(tab_name):
                table_name = self.filter_dict[tab_name]['filter_table']
                feature_type = self.filter_dict[tab_name]['feature_type']
            tools_gw.set_completer_widget(table_name, self.dlg_dscenario.txt_feature_id, feature_type, add_id=True)

        # Deactivate btn_snapping functionality
        self._selection_end()

        # Enable/disable filter & buttons
        self._enable_widgets(enable)


    def _enable_widgets(self, enable):
        """  """

        tools_qt.set_widget_enabled(self.dlg_dscenario, 'txt_feature_id', enable)
        tools_qt.set_widget_enabled(self.dlg_dscenario, 'btn_insert', enable)
        tools_qt.set_widget_enabled(self.dlg_dscenario, 'btn_delete', enable)
        tools_qt.set_widget_enabled(self.dlg_dscenario, 'btn_snapping', enable)


    def _manage_feature_type(self):
        """ Manages current tableview feature type (node, arc, nodarc, etc.) """

        tableview = self.dlg_dscenario.main_tab.currentWidget()
        self.feature_type = 'node'
        feature_type = 'feature_id'

        for x in self.feature_types:
            col_idx = tools_qt.get_col_index_by_col_name(tableview, x)
            if col_idx not in (None, False):
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
            if col_idx not in (None, False):
                feature_type = x
                break
        if feature_type != 'feature_id':
            table = f"v_edit_{feature_type.split('_')[0]}"
        tools_qgis.highlight_feature_by_id(qtableview, table, feature_type, self.rubber_band, 5, index)


    def _manage_add_layers(self):
        """ Opens menu to add/remove layers to ToC """

        # Create main menu and get cursor click position
        main_menu = QMenu()
        cursor = QCursor()
        x = cursor.pos().x()
        y = cursor.pos().y()
        click_point = QPoint(x + 5, y + 5)

        layer_list = []
        for layer in QgsProject.instance().mapLayers().values():
            layer_list.append(tools_qgis.get_layer_source_table_name(layer))

        geom_layers = []
        sql = f"SELECT f_table_name FROM geometry_columns WHERE f_table_schema = '{global_vars.schema_name}' " \
              f"AND f_table_name LIKE 'v_edit_inp_dscenario%';"
        rows = tools_db.get_rows(sql)
        if rows:
            geom_layers = [row[0] for row in rows]

        # Get layers to add
        lyr_filter = "v_edit_inp_dscenario_%"
        sql = f"SELECT id, alias, style_id, addparam FROM sys_table WHERE id LIKE '{lyr_filter}' AND alias IS NOT NULL"
        rows = tools_db.get_rows(sql)
        if rows:
            # LOAD ALL
            widget = QCheckBox()
            widget.setText("Load all")
            widget.setStyleSheet("margin: 5px 5px 5px 8px;")
            widgetAction = QWidgetAction(main_menu)
            widgetAction.setDefaultWidget(widget)
            widgetAction.defaultWidget().stateChanged.connect(partial(self._manage_load_all, main_menu))
            main_menu.addAction(widgetAction)

            # LAYERS
            for tablename, alias, style_id, addparam in rows:
                # Manage alias
                if not alias:
                    alias = tablename.replace('v_edit_inp_dscenario_', '').replace('_', ' ').capitalize()
                # Manage style_id
                if not style_id:
                    style_id = "-1"
                # Manage pkey
                pk = "id"
                if addparam:
                    pk = addparam.get('pkey').replace(' ', '')
                # Manage the_geom
                the_geom = None
                if tablename in geom_layers:
                    the_geom = "the_geom"

                # Create CheckBox
                widget = QCheckBox()
                widget.setText(alias)
                widgetAction = QWidgetAction(main_menu)
                widgetAction.setDefaultWidget(widget)
                main_menu.addAction(widgetAction)

                # Set checked if layer exists
                if f"{tablename}" in layer_list:
                    widget.setChecked(True)
                widget.setStyleSheet("margin: 5px 5px 5px 8px;")

                widgetAction.defaultWidget().stateChanged.connect(
                    partial(self._check_action_ischecked, tablename, the_geom, pk, style_id, alias.strip()))

        main_menu.exec_(click_point)


    def _check_action_ischecked(self, tablename, the_geom, pk, style_id, alias, state):
        """ Control if user check or uncheck action menu, then add or remove layer from toc
        :param tablename: Postgres table name (String)
        :param pk: Field id of the table (String)
        :param style_id: Id of the style we want to load (integer or String)
        :param state: This parameter is sent by the action itself with the trigger (Bool)
        """

        if state == 2:
            layer = tools_qgis.get_layer_by_tablename(tablename)
            if layer is None:
                tools_gw.add_layer_database(tablename, the_geom=the_geom, field_id=pk, group="EPA", sub_group="Dscenario", style_id=style_id, alias=alias)
        elif state == 0:
            layer = tools_qgis.get_layer_by_tablename(tablename)
            if layer is not None:
                tools_qgis.remove_layer_from_toc(alias, "EPA", "Dscenario")


    def _manage_load_all(self, menu, state=None):

        if state == 2:
            for child in menu.actions():
                if not child.isChecked():
                    child.defaultWidget().setChecked(True)


    def _manage_insert(self):
        """ Insert feature to dscenario via the button """

        if self.dlg_dscenario.txt_feature_id.text() == '':
            message = "Feature_id is mandatory."
            self.dlg_dscenario.txt_feature_id.setStyleSheet("border: 1px solid red")
            tools_qgis.show_warning(message, dialog=self.dlg_dscenario)
            return
        self.dlg_dscenario.txt_feature_id.setStyleSheet(None)
        tableview = self.dlg_dscenario.main_tab.currentWidget()
        view = tableview.objectName()

        sql = f"SELECT column_name FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '{self.table_name[len(f'{self.schema_name}.'):]}';"
        rows = tools_db.get_rows(sql)

        if rows[0][0] == 'id':
            # FIELDS
            sql = f"INSERT INTO {view} ({rows[1][0]}, {rows[2][0]}"
            if view in ("inp_dscenario_controls", "inp_dscenario_rules"):
                sql += f", {rows[3][0]}"
            elif view == "inp_dscenario_demand":
                sql += f", feature_type"
            # VALUES
            sql += f")VALUES ({self.selected_dscenario_id}, '{self.dlg_dscenario.txt_feature_id.text()}'"
            if view in ("inp_dscenario_controls", "inp_dscenario_rules"):
                sql += f", ''"
            elif view == "inp_dscenario_demand":
                sql += f", '{self.feature_type.upper()}'"
            sql += f");"
        else:
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
            tools_qgis.show_warning(message, dialog=self.dlg_dscenario)
            return

        # Get selected feature_id
        view = tableview.objectName()
        col_idx = -1
        feature_type = 'feature_id'

        for x in self.feature_types:
            col_idx = tools_qt.get_col_index_by_col_name(tableview, x)
            if col_idx not in (None, False):
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
        try:
            current_layer = self.iface.activeLayer()
            current_layer.removeSelection()
        except AttributeError:
            pass

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
