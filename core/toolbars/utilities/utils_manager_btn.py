"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import json

from functools import partial
from sip import isdeleted

from qgis.PyQt.QtCore import Qt, QPoint
from qgis.PyQt.QtGui import QKeySequence
from qgis.PyQt.QtWidgets import QAction, QMenu, QTableView, QAbstractItemView
from qgis.PyQt.QtSql import QSqlTableModel

from qgis.gui import QgsMapToolEmitPoint

from ..dialog import GwAction
from ...ui.ui_manager import GwMapzoneManagerUi, GwMapzoneConfigUi
from ...utils.snap_manager import GwSnapManager
from ...shared.info import GwInfo
from ...shared.psector import GwPsector
from ...utils import tools_gw
from .... import global_vars
from ....libs import tools_qgis, tools_qt, lib_vars, tools_db, tools_os


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

        self.snapper_manager = GwSnapManager(self.iface)
        self.snapper_manager.set_snapping_layers()


    def clicked_event(self):

        button = self.action.associatedWidgets()[1]
        menu_point = button.mapToGlobal(QPoint(0, button.height()))
        self.menu.popup(menu_point)


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


    def _prices_manager(self):
        self.psector = GwPsector()
        self.psector.manage_prices()

    # region mapzone manager functions

    def _mapzones_manager(self):

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
        self.mapzone_mng_dlg.btn_toggle_active.clicked.connect(partial(self._manage_toggle_active))
        self.mapzone_mng_dlg.btn_create.clicked.connect(partial(self._manage_create))
        self.mapzone_mng_dlg.btn_update.clicked.connect(partial(self._manage_update))
        self.mapzone_mng_dlg.btn_delete.clicked.connect(partial(self._manage_delete))
        self.mapzone_mng_dlg.main_tab.currentChanged.connect(partial(self._manage_current_changed))
        self.mapzone_mng_dlg.finished.connect(partial(tools_gw.close_dialog, self.mapzone_mng_dlg, True))

        self._manage_current_changed()

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
        """ Fill mapzone table with data from its corresponding table """

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

    # region config button

    def _manage_config(self):
        """ Dialog from config button """

        # Get selected row
        tableview = self.mapzone_mng_dlg.main_tab.currentWidget()
        selected_list = tableview.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=self.mapzone_mng_dlg)
            return

        # Get selected mapzone data
        index = tableview.selectionModel().currentIndex()
        self.mapzone_id = index.sibling(index.row(), 0).data()
        self.mapzone_type = tableview.objectName().split('_')[-1].lower()
        graphconfig = index.sibling(index.row(), tools_qt.get_col_index_by_col_name(tableview, 'graphconfig')).data()

        # Build dialog
        self.config_dlg = GwMapzoneConfigUi()
        tools_gw.load_settings(self.config_dlg)

        # Button icons
        tools_gw.add_icon(self.config_dlg.btn_snapping_nodeParent, "137")
        tools_gw.add_icon(self.config_dlg.btn_snapping_toArc, "137")
        tools_gw.add_icon(self.config_dlg.btn_snapping_forceClosed, "137")

        # Set variables
        self._reset_config_vars()

        # Fill preview
        if graphconfig:
            tools_qt.set_widget_text(self.config_dlg, 'txt_preview', graphconfig)

        # Connect signals
        self.child_type = None
        self.config_dlg.btn_snapping_nodeParent.clicked.connect(
            partial(self.get_snapped_feature_id, self.config_dlg, self.config_dlg.btn_snapping_nodeParent, 'v_edit_node', 'nodeParent', None,
                    self.child_type))
        self.config_dlg.btn_snapping_toArc.clicked.connect(
            partial(self.get_snapped_feature_id, self.config_dlg, self.config_dlg.btn_snapping_toArc, 'v_edit_arc', 'toArc', None,
                    self.child_type))
        self.config_dlg.btn_add_nodeParent.clicked.connect(
            partial(self._add_node_parent, self.config_dlg)
        )
        # Force closed
        self.config_dlg.btn_snapping_forceClosed.clicked.connect(
            partial(self.get_snapped_feature_id, self.config_dlg, self.config_dlg.btn_snapping_forceClosed, 'v_edit_node', 'forceClosed', None,
                    self.child_type))
        self.config_dlg.btn_add_forceClosed.clicked.connect(
            partial(self._add_force_closed, self.config_dlg)
        )
        # Preview
        self.config_dlg.btn_clear_preview.clicked.connect(partial(self._clear_preview, self.config_dlg))
        # Dialog buttons
        self.config_dlg.btn_accept.clicked.connect(partial(self._accept_config, self.config_dlg))
        self.config_dlg.btn_cancel.clicked.connect(self.config_dlg.reject)
        self.config_dlg.finished.connect(partial(tools_gw.close_dialog, self.config_dlg, True))

        # Enable/disable certain widgets
        tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_snapping_nodeParent, True)
        tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_snapping_toArc, False)
        tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_add_nodeParent, False)

        tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_snapping_forceClosed, True)
        tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_add_forceClosed, False)

        tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_clear_preview, True)

        # Open dialog
        tools_gw.open_dialog(self.config_dlg, 'mapzone_config')


    def _reset_config_vars(self, mode=0):
        """
        Reset config variables

            :param mode: which variables to reset {0: all, 1: nodeParent & toArc, 2: only forceClosed}
        """

        if mode in (0, 1):
            self.node_parent = None
            tools_qt.set_widget_text(self.config_dlg, 'txt_nodeParent', '')
            self.to_arc_list = set()
            tools_qt.set_widget_text(self.config_dlg, 'txt_toArc', '')
            tools_qt.set_widget_enabled(self.config_dlg, 'btn_snapping_toArc', False)
            tools_qt.set_widget_enabled(self.config_dlg, 'btn_add_nodeParent', False)
        if mode in (0, 2):
            self.force_closed_list = set()
            tools_qt.set_widget_text(self.config_dlg, 'txt_forceClosed', '')
            tools_qt.set_widget_enabled(self.config_dlg, 'btn_add_forceClosed', False)



    def get_snapped_feature_id(self, dialog, action, layer_name, option, widget_name, child_type):
        """ Snap feature and set a value into dialog """

        layer = tools_qgis.get_layer_by_tablename(layer_name)
        if not layer:
            action.setChecked(False)
            return
        # if widget_name is not None:
        #     widget = dialog.findChild(QWidget, widget_name)
        #     if widget is None:
        #         action.setChecked(False)
        #         return
        # Block the signals of the dialog so that the key ESC does not close it
        dialog.blockSignals(True)

        self.vertex_marker = self.snapper_manager.vertex_marker

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Disable snapping
        self.snapper_manager.set_snapping_status()

        # if we are doing info over connec or over node
        if option in ('arc', 'set_to_arc'):
            self.snapper_manager.config_snap_to_arc()
        elif option == 'node':
            self.snapper_manager.config_snap_to_node()
        # Set signals
        tools_gw.disconnect_signal('mapzone_manager_snapping', 'get_snapped_feature_id_xyCoordinates_mouse_moved')
        tools_gw.connect_signal(self.canvas.xyCoordinates, partial(self._mouse_moved, layer),
                                'mapzone_manager_snapping', 'get_snapped_feature_id_xyCoordinates_mouse_moved')

        tools_gw.disconnect_signal('mapzone_manager_snapping', 'get_snapped_feature_id_ep_canvasClicked_get_id')
        emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(emit_point)
        tools_gw.connect_signal(emit_point.canvasClicked, partial(self._get_id, dialog, action, option, emit_point, child_type),
                                'mapzone_manager_snapping', 'get_snapped_feature_id_ep_canvasClicked_get_id')


    def _mouse_moved(self, layer, point):
        """ Mouse motion detection """

        # Set active layer
        self.iface.setActiveLayer(layer)
        layer_name = tools_qgis.get_layer_source_table_name(layer)

        # Get clicked point
        self.vertex_marker.hide()
        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if result.isValid():
            layer = self.snapper_manager.get_snapped_layer(result)
            # Check feature
            viewname = tools_qgis.get_layer_source_table_name(layer)
            if viewname == layer_name:
                self.snapper_manager.add_marker(result, self.vertex_marker)


    def _get_id(self, dialog, action, option, emit_point, child_type, point, event):
        """ Get selected attribute from snapped feature """

        # @options{'key':['att to get from snapped feature', 'function to call']}
        options = {'nodeParent': ['node_id', '_set_node_parent'], 'toArc': ['arc_id', '_set_to_arc'],
                   'forceClosed': ['node_id', '_set_force_closed']}

        if event == Qt.RightButton:
            self._cancel_snapping_tool(dialog, action)
            return

        try:
            # Refresh all layers to avoid selecting old deleted features
            global_vars.canvas.refreshAllLayers()
            # Get coordinates
            event_point = self.snapper_manager.get_event_point(point=point)
            # Snapping
            result = self.snapper_manager.snap_to_current_layer(event_point)
            if not result.isValid():
                return
            # Get the point. Leave selection
            snapped_feat = self.snapper_manager.get_snapped_feature(result)
            feat_id = snapped_feat.attribute(f'{options[option][0]}')
            getattr(self, options[option][1])(snapped_feat, feat_id, child_type)
        except Exception as e:
            tools_qgis.show_warning(f"Exception in info (def _get_id)", parameter=e)
        finally:
            self.snapper_manager.recover_snapping_options()
            if option == 'nodeParent':
                self._cancel_snapping_tool(dialog, action)


    def _set_node_parent(self, snapped_feat, feat_id, child_type):
        """
        Function called in def _get_id(self, dialog, action, option, point, event):
            getattr(self, options[option][1])(feat_id, child_type)

            :param feat_id: Id of the snapped feature
        """

        self.node_parent = (snapped_feat, feat_id)

        tools_qt.set_widget_text(self.config_dlg, 'txt_nodeParent', f"{feat_id}")
        tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_snapping_toArc, True)


    def _set_to_arc(self, snapped_feat, feat_id, child_type):
        """
        Function called in def _get_id(self, dialog, action, option, point, event):
            getattr(self, options[option][1])(feat_id, child_type)

            :param feat_id: Id of the snapped feature
        """

        # Set variable, set widget text and enable add button
        self.to_arc_list.add(int(feat_id))

        tools_qt.set_widget_text(self.config_dlg, 'txt_toArc', f"{self.to_arc_list}")
        tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_add_nodeParent, True)


    def _set_force_closed(self, snapped_feat, feat_id, child_type):
        """
        Function called in def _get_id(self, dialog, action, option, point, event):
            getattr(self, options[option][1])(feat_id, child_type)

            :param feat_id: Id of the snapped feature
        """

        # Set variable, set widget text and enable add button
        self.force_closed_list.add(feat_id)

        tools_qt.set_widget_text(self.config_dlg, 'txt_forceClosed', f"{self.force_closed_list}")
        tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_add_forceClosed, True)


    def _add_node_parent(self, dialog):
        """ ADD button for nodeParent """

        node_parent_feat, node_parent_id = self.node_parent
        to_arc_list = json.dumps(list(self.to_arc_list))
        preview = tools_qt.get_text(dialog, 'txt_preview')

        parameters = f'"action": "PREVIEW", "configZone": "{self.mapzone_type}", "mapzoneId": "{self.mapzone_id}", ' \
                     f'"nodeParent": "{node_parent_id}", "toArc": {to_arc_list}'
        if preview:
            parameters += f', "config": {preview}'
        extras = f'"parameters": {{{parameters}}}'
        body = tools_gw.create_body(extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_config_mapzones', body)
        if json_result is None:
            return

        if 'status' in json_result and json_result['status'] == 'Accepted':
            if json_result['message']:
                level = 1
                if 'level' in json_result['message']:
                    level = int(json_result['message']['level'])
                tools_qgis.show_message(json_result['message']['text'], level, dialog=dialog)

            preview = json_result['body']['data'].get('preview')
            if preview:
                tools_qt.set_widget_text(dialog, 'txt_preview', json.dumps(preview))

            self._cancel_snapping_tool(dialog, dialog.btn_add_nodeParent)
            self._reset_config_vars(1)


    def _add_force_closed(self, dialog):
        """ ADD button for forceClosed """

        force_closed_list = json.dumps(list(self.force_closed_list))
        preview = tools_qt.get_text(dialog, 'txt_preview')

        parameters = f'"action": "PREVIEW", "configZone": "{self.mapzone_type}", "mapzoneId": "{self.mapzone_id}", ' \
                     f'"forceClosed": {force_closed_list}'
        if preview:
            parameters += f', "config": {preview}'
        extras = f'"parameters": {{{parameters}}}'
        body = tools_gw.create_body(extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_config_mapzones', body)
        if json_result is None:
            return

        if 'status' in json_result and json_result['status'] == 'Accepted':
            if json_result['message']:
                level = 1
                if 'level' in json_result['message']:
                    level = int(json_result['message']['level'])
                tools_qgis.show_message(json_result['message']['text'], level, dialog=dialog)

            preview = json_result['body']['data'].get('preview')
            if preview:
                tools_qt.set_widget_text(dialog, 'txt_preview', json.dumps(preview))

            self._cancel_snapping_tool(dialog, dialog.btn_add_forceClosed)
            self._reset_config_vars(2)


    def _clear_preview(self, dialog):
        """ Set preview textbox to '' """

        tools_qt.set_widget_text(dialog, 'txt_preview', '')


    def _accept_config(self, dialog):
        """ Accept button for config dialog """

        preview = tools_qt.get_text(dialog, 'txt_preview')

        if not preview:
            return
        parameters = f'"action": "UPDATE", "configZone": "{self.mapzone_type}", "mapzoneId": "{self.mapzone_id}", ' \
                     f'"config": {preview}'
        extras = f'"parameters": {{{parameters}}}'
        body = tools_gw.create_body(extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_config_mapzones', body)
        if json_result is None:
            return

        if 'status' in json_result and json_result['status'] == 'Accepted':
            if json_result['message']:
                level = 1
                if 'level' in json_result['message']:
                    level = int(json_result['message']['level'])
                tools_qgis.show_message(json_result['message']['text'], level)

            self._reset_config_vars(0)
            tools_gw.close_dialog(dialog)
            self._manage_current_changed()


    def _cancel_snapping_tool(self, dialog, action):

        tools_qgis.disconnect_snapping(False, None, self.vertex_marker)
        tools_gw.disconnect_signal('mapzone_manager_snapping')
        dialog.blockSignals(False)
        action.setChecked(False)
        # self.signal_activate.emit()

    # endregion

    def _manage_toggle_active(self):
        # Get selected row
        tableview = self.mapzone_mng_dlg.main_tab.currentWidget()
        view = tableview.objectName().replace('tbl_', '')
        selected_list = tableview.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=self.mapzone_mng_dlg)
            return

        # Get selected mapzone data
        index = tableview.selectionModel().currentIndex()
        mapzone_id = index.sibling(index.row(), 0).data()
        active = index.sibling(index.row(), tools_qt.get_col_index_by_col_name(tableview, 'active')).data()
        active = tools_os.set_boolean(active)
        field_id = tableview.model().headerData(0, Qt.Horizontal)

        sql = f"UPDATE {view} SET active = {str(not active).lower()} WHERE {field_id} = {mapzone_id}"
        tools_db.execute_sql(sql)

        # Refresh tableview
        self._manage_current_changed()


    def _manage_create(self):
        # Get selected row
        tableview = self.mapzone_mng_dlg.main_tab.currentWidget()
        view = tableview.objectName().replace('tbl_', '')
        selected_list = tableview.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=self.mapzone_mng_dlg)
            return

        # Get selected mapzone data
        index = tableview.selectionModel().currentIndex()
        mapzone_id = index.sibling(index.row(), 0).data()
        field_id = tableview.model().headerData(0, Qt.Horizontal)


    def _manage_update(self):
        # Get selected row
        tableview = self.mapzone_mng_dlg.main_tab.currentWidget()
        view = tableview.objectName().replace('tbl_', '')
        selected_list = tableview.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=self.mapzone_mng_dlg)
            return

        # Get selected mapzone data
        index = tableview.selectionModel().currentIndex()
        mapzone_id = index.sibling(index.row(), 0).data()
        field_id = tableview.model().headerData(0, Qt.Horizontal)


    def _manage_delete(self):
        # Get selected row
        tableview = self.mapzone_mng_dlg.main_tab.currentWidget()
        view = tableview.objectName().replace('tbl_', '')
        selected_list = tableview.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=self.mapzone_mng_dlg)
            return

        # Get selected mapzone data
        index = tableview.selectionModel().currentIndex()
        mapzone_id = index.sibling(index.row(), 0).data()
        field_id = tableview.model().headerData(0, Qt.Horizontal)

        message = "Are you sure you want to delete these records?"
        answer = tools_qt.show_question(message, "Delete records", index.sibling(index.row(), 1).data(), force_action=True)
        if answer:
            sql = f"DELETE FROM {view} WHERE {field_id} = {mapzone_id}"
            tools_db.execute_sql(sql)

            # Refresh tableview
            self._manage_current_changed()

    # endregion

    # endregion
