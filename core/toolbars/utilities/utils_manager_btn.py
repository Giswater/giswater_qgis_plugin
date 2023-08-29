"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial
from sip import isdeleted

from qgis.PyQt.QtGui import QKeySequence
from qgis.PyQt.QtWidgets import QAction, QMenu, QTableView, QAbstractItemView
from qgis.PyQt.QtSql import QSqlTableModel

from ..dialog import GwAction
from ...ui.ui_manager import GwMapzoneManagerUi, GwMapzoneConfigUi
from ...shared.info import GwInfo
from ...shared.psector import GwPsector
from ...utils import tools_gw
from .... import global_vars
from ....libs import tools_qgis, tools_qt, lib_vars


class GwUtilsManagerButton(GwAction):
    """ Button 217: Utils manager """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)

        # First add the menu before adding it to the toolbar
        if toolbar is not None:
            toolbar.removeAction(self.action)

        self.info_feature = GwInfo('data')

        self.menu = QMenu()
        self.menu.setObjectName("GW_utils_menu")
        self._fill_utils_menu()

        self.menu.aboutToShow.connect(self._fill_utils_menu)

        if toolbar is not None:
            self.action.setMenu(self.menu)
            toolbar.addAction(self.action)


    def clicked_event(self):

        if self.menu.property('last_selection') is not None:
            self.info_feature.add_feature(self.menu.property('last_selection'), action=self)


    # region private functions


    def _fill_utils_menu(self):
        """ Fill add arc menu """

        # disconnect and remove previuos signals and actions
        actions = self.menu.actions()
        for action in actions:
            action.disconnect()
            self.menu.removeAction(action)
            del action
        action_group = self.action.property('action_group')

        buttons = [['Mapzones manager', '_mapzones_manager'], ['Prices manager', '_prices_manager']]

        for button in buttons:
            button_name = button[0]
            button_function = button[1]
            obj_action = QAction(str(button_name), action_group)
            obj_action.setObjectName(button_name)
            obj_action.setProperty('action_group', action_group)
            # if f"{feature_cat.shortcut_key}" not in global_vars.shortcut_keys:
            #     obj_action.setShortcut(QKeySequence(str(feature_cat.shortcut_key)))
            # try:
            #     obj_action.setShortcutVisibleInContextMenu(True)
            # except Exception:
            #     pass
            self.menu.addAction(obj_action)
            obj_action.triggered.connect(partial(getattr(self, button_function)))
            # obj_action.triggered.connect(partial(self._save_last_selection, self.menu, feature_cat))


    def _save_last_selection(self, menu, feature_cat):
        menu.setProperty("last_selection", feature_cat)


    def _mapzones_manager(self):
        print(f"mapzones manager")
        # Create dialog
        self.mapzone_mng_dlg = GwMapzoneManagerUi()
        tools_gw.load_settings(self.mapzone_mng_dlg)

        # Add icons
        # tools_gw.add_icon(self.dlg_dscenario.btn_toc, "306", sub_folder="24x24")
        # tools_gw.add_icon(self.dlg_dscenario.btn_insert, "111", sub_folder="24x24")
        # tools_gw.add_icon(self.dlg_dscenario.btn_delete, "112", sub_folder="24x24")
        # tools_gw.add_icon(self.dlg_dscenario.btn_snapping, "137")

        default_tab_idx = 0
        tabs = ['sector', 'dma', 'presszone', 'dqa']
        for tab in tabs:
            view = f'v_edit_{tab}'
            qtableview = QTableView()
            qtableview.setObjectName(f"tbl_{view}")
            # qtableview.clicked.connect(partial(self._manage_highlight, qtableview, view))
            tab_idx = self.mapzone_mng_dlg.main_tab.addTab(qtableview, f"{view.split('_')[-1].capitalize()}")
            self.mapzone_mng_dlg.main_tab.widget(tab_idx).setObjectName(view)

            # if view.split('_')[-1].upper() == self.selected_dscenario_type:
            #     default_tab_idx = tab_idx

        # self.dlg_dscenario.main_tab.setCurrentIndex(default_tab_idx)

        # Connect signals
        self.mapzone_mng_dlg.btn_config.clicked.connect(partial(self._manage_config))
        # self.mapzone_mng_dlg.btn_toc.clicked.connect(partial(self._manage_add_layers))
        # self.mapzone_mng_dlg.btn_insert.clicked.connect(partial(self._manage_insert))
        # self.mapzone_mng_dlg.btn_delete.clicked.connect(partial(self._manage_delete))
        # self.mapzone_mng_dlg.btn_snapping.clicked.connect(partial(self._manage_select))
        self.mapzone_mng_dlg.main_tab.currentChanged.connect(partial(self._manage_current_changed))
        # self.mapzone_mng_dlg.finished.connect(self._selection_end)
        self.mapzone_mng_dlg.finished.connect(partial(tools_gw.close_dialog, self.mapzone_mng_dlg, True))

        self._manage_current_changed()

        # sql = f"SELECT name FROM v_edit_cat_dscenario WHERE dscenario_id = {self.selected_dscenario_id}"
        # row = tools_db.get_row(sql)
        # dscenario_name = row[0]
        # title = f"Dscenario {self.selected_dscenario_id} - {dscenario_name}"
        tools_gw.open_dialog(self.mapzone_mng_dlg, 'mapzone_manager')


    def _manage_current_changed(self):
        """ Manages tab changes """

        # Fill current table
        self._fill_mapzone_table()

        # # Refresh txt_feature_id
        # tools_qt.set_widget_text(self.dlg_dscenario, self.dlg_dscenario.txt_feature_id, '')
        # self.dlg_dscenario.txt_feature_id.setStyleSheet(None)
        #
        # # Manage insert typeahead
        # # Get index of selected tab
        # index_tab = self.dlg_dscenario.main_tab.currentIndex()
        # tab_name = self.dlg_dscenario.main_tab.widget(index_tab).objectName()
        # enable = tab_name not in self.filter_disabled
        #
        # # Populate typeahead
        # if enable:
        #     self._manage_feature_type()
        #     table_name = f"v_edit_{tab_name.replace('dscenario_', '')}"
        #     feature_type = self.feature_type
        #     if self.filter_dict.get(tab_name):
        #         table_name = self.filter_dict[tab_name]['filter_table']
        #         feature_type = self.filter_dict[tab_name]['feature_type']
        #     tools_gw.set_completer_widget(table_name, self.dlg_dscenario.txt_feature_id, feature_type, add_id=True)
        #
        # # Deactivate btn_snapping functionality
        # self._selection_end()
        #
        # # Enable/disable filter & buttons
        # self._enable_widgets(enable)


    def _fill_mapzone_table(self, set_edit_triggers=QTableView.DoubleClicked, expr=None):
        """ Fill dscenario table with data from its corresponding table """

        # Manage exception if dialog is closed
        if isdeleted(self.mapzone_mng_dlg):
            return

        self.table_name = f"{self.mapzone_mng_dlg.main_tab.currentWidget().objectName()}"
        widget = self.mapzone_mng_dlg.main_tab.currentWidget()

        if self.schema_name not in self.table_name:
            self.table_name = self.schema_name + "." + self.table_name

        # Set model
        model = QSqlTableModel(db=lib_vars.qgis_db_credentials)
        model.setTable(self.table_name)
        # model.setFilter(f"dscenario_id = {self.selected_dscenario_id}")
        model.setEditStrategy(QSqlTableModel.OnFieldChange)
        model.setSort(0, 0)
        model.select()
        # # Set item delegates
        # readonly_delegate = ReadOnlyDelegate(widget)
        # widget.setItemDelegateForColumn(0, readonly_delegate)
        # widget.setItemDelegateForColumn(1, readonly_delegate)
        # editable_delegate = EditableDelegate(widget)
        # for x in range(2, model.columnCount()):
        #     widget.setItemDelegateForColumn(x, editable_delegate)


        # Check for errors
        if model.lastError().isValid():
            tools_qgis.show_warning(model.lastError().text(), dialog=self.mapzone_mng_dlg)
        # Attach model to table view
        if expr:
            widget.setModel(model)
            widget.model().setFilter(expr)
        else:
            widget.setModel(model)
        widget.setSortingEnabled(True)

        # Set widget & model properties
        tools_qt.set_tableview_config(widget, selection=QAbstractItemView.SelectRows, edit_triggers=set_edit_triggers, sectionResizeMode=0)
        tools_gw.set_tablemodel_config(self.mapzone_mng_dlg, widget, f"{self.table_name[len(f'{self.schema_name}.'):]}")

        # Hide unwanted columns
        col_idx = tools_qt.get_col_index_by_col_name(widget, 'dscenario_id')
        if col_idx not in (None, False):
            widget.setColumnHidden(col_idx, True)

        geom_col_idx = tools_qt.get_col_index_by_col_name(widget, 'the_geom')
        if geom_col_idx not in (None, False):
            widget.setColumnHidden(geom_col_idx, True)

        # Sort the table by feature id
        model.sort(1, 0)


    def _manage_config(self):
        self.config_dlg = GwMapzoneConfigUi()
        tools_gw.load_settings(self.config_dlg)

        tools_gw.open_dialog(self.config_dlg, 'mapzone_config')


    def _prices_manager(self):
        self.psector = GwPsector()
        self.psector.manage_prices()

    # endregion
