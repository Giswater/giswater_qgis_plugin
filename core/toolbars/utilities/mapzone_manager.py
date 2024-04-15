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
from qgis.PyQt.QtWidgets import QAction, QMenu, QTableView, QAbstractItemView, QGridLayout, QLabel, QWidget, QComboBox
from qgis.PyQt.QtSql import QSqlTableModel

from qgis.gui import QgsMapToolEmitPoint

from .toolbox_btn import GwToolBoxButton
from ...ui.ui_manager import GwMapzoneManagerUi, GwMapzoneConfigUi, GwInfoGenericUi
from ...utils.snap_manager import GwSnapManager
from ...utils import tools_gw
from .... import global_vars
from ....libs import lib_vars, tools_qgis, tools_qt, tools_db, tools_os


class GwMapzoneManager:

    def __init__(self):
        """ Class to control 'Add element' of toolbar 'edit' """

        self.plugin_dir = lib_vars.plugin_dir
        self.iface = global_vars.iface
        self.schema_name = lib_vars.schema_name
        self.canvas = global_vars.canvas

        self.snapper_manager = GwSnapManager(self.iface)
        self.snapper_manager.set_snapping_layers()
        self.vertex_marker = self.snapper_manager.vertex_marker
        self.rubber_band = tools_gw.create_rubberband(global_vars.canvas)

        self.feature_types = ['sector_id', 'dma_id', 'presszone_id', 'dqa_id', 'drainzone_id']
        self.mapzone_mng_dlg = None
        self.netscenario_id = None


    def manage_mapzones(self):

        # Create dialog
        self.mapzone_mng_dlg = GwMapzoneManagerUi()
        tools_gw.load_settings(self.mapzone_mng_dlg)

        # Add icons
        tools_gw.add_icon(self.mapzone_mng_dlg.btn_execute, "311", sub_folder="24x24")

        default_tab_idx = 0
        tabs = ['sector', 'dma', 'presszone', 'dqa']
        if global_vars.project_type == 'ud':
            tabs = ['drainzone']
        for tab in tabs:
            view = f'v_ui_{tab}'
            qtableview = QTableView()
            qtableview.setObjectName(f"tbl_{view}")
            qtableview.clicked.connect(partial(self._manage_highlight, qtableview, view))
            qtableview.doubleClicked.connect(partial(self.manage_update, self.mapzone_mng_dlg, None))
            tab_idx = self.mapzone_mng_dlg.main_tab.addTab(qtableview, f"{view.split('_')[-1].capitalize()}")
            self.mapzone_mng_dlg.main_tab.widget(tab_idx).setObjectName(view)

            # if view.split('_')[-1].upper() == self.selected_dscenario_type:
            #     default_tab_idx = tab_idx

        # self.dlg_dscenario.main_tab.setCurrentIndex(default_tab_idx)

        # Connect signals
        self.mapzone_mng_dlg.txt_name.textChanged.connect(partial(self._txt_name_changed))
        self.mapzone_mng_dlg.chk_show_all.toggled.connect(partial(self._manage_current_changed))
        self.mapzone_mng_dlg.btn_execute.clicked.connect(partial(self._open_mapzones_analysis))
        self.mapzone_mng_dlg.btn_config.clicked.connect(partial(self.manage_config, self.mapzone_mng_dlg, None))
        self.mapzone_mng_dlg.btn_toggle_active.clicked.connect(partial(self._manage_toggle_active))
        self.mapzone_mng_dlg.btn_create.clicked.connect(partial(self.manage_create, self.mapzone_mng_dlg, None))
        self.mapzone_mng_dlg.btn_update.clicked.connect(partial(self.manage_update, self.mapzone_mng_dlg, None))
        self.mapzone_mng_dlg.btn_delete.clicked.connect(partial(self._manage_delete))
        self.mapzone_mng_dlg.main_tab.currentChanged.connect(partial(self._manage_current_changed))
        self.mapzone_mng_dlg.btn_cancel.clicked.connect(self.mapzone_mng_dlg.reject)
        self.mapzone_mng_dlg.finished.connect(partial(tools_gw.reset_rubberband, self.rubber_band, None))
        self.mapzone_mng_dlg.finished.connect(partial(tools_gw.close_dialog, self.mapzone_mng_dlg, True))
        self.mapzone_mng_dlg.chk_active.stateChanged.connect(partial(self._filter_active, self.mapzone_mng_dlg))


        self._manage_current_changed()
        self.mapzone_mng_dlg.main_tab.currentChanged.connect(partial(self._filter_active, self.mapzone_mng_dlg, None))

        tools_gw.open_dialog(self.mapzone_mng_dlg, 'mapzone_manager')

    def _manage_highlight(self, qtableview, view, index):
        """ Creates rubberband to indicate which feature is selected """

        tools_gw.reset_rubberband(self.rubber_band)
        table = view.replace("v_ui", "v_edit")
        feature_type = 'feature_id'

        for x in self.feature_types:
            col_idx = tools_qt.get_col_index_by_col_name(qtableview, x)
            if col_idx is not None and col_idx is not False:
                feature_type = x
                break
        if feature_type != 'feature_id':
            table = f"v_edit_{feature_type.split('_')[0]}"
        tools_qgis.highlight_feature_by_id(qtableview, table, feature_type, self.rubber_band, 5, index)

    def _txt_name_changed(self, text):
        show_inactive = self.mapzone_mng_dlg.chk_active.isChecked()
        expr = f"name ilike '%{text}%'"
        if not show_inactive:
            expr += " and active is true"
        self._fill_mapzone_table(expr=expr)

    def _manage_current_changed(self):
        """ Manages tab changes """
        if self.mapzone_mng_dlg is None or isdeleted(self.mapzone_mng_dlg):
            return
        # Get the state of the "show inactive" checkbox
        show_inactive = self.mapzone_mng_dlg.chk_active.isChecked()

        # Refresh txt_feature_id
        tools_qt.set_widget_text(self.mapzone_mng_dlg, self.mapzone_mng_dlg.txt_name, '')

        # Reset rubberband
        tools_gw.reset_rubberband(self.rubber_band)

        # Build the filter expression based on the state of the "show inactive" checkbox
        expr = "" if show_inactive else "active is true"

        # Fill current table
        self._fill_mapzone_table(expr=expr)

    def _fill_mapzone_table(self, set_edit_triggers=QTableView.NoEditTriggers, expr=None):
        """ Fill mapzone table with data from its corresponding table """
        # Manage exception if dialog is closed
        if self.mapzone_mng_dlg is None or isdeleted(self.mapzone_mng_dlg):
            return

        self.table_name = f"{self.mapzone_mng_dlg.main_tab.currentWidget().objectName()}"
        widget = self.mapzone_mng_dlg.main_tab.currentWidget()

        if self.schema_name not in self.table_name:
            self.table_name = self.schema_name + "." + self.table_name

        show_all = tools_qt.is_checked(self.mapzone_mng_dlg, 'chk_show_all')
        # Set model
        model = QSqlTableModel(db=lib_vars.qgis_db_credentials)
        table_name = self.table_name
        if show_all:
            table_name = table_name.replace('v_ui_', '')
        model.setTable(table_name)
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
            if 'Unable to find table' in model.lastError().text():
                tools_db.reset_qsqldatabase_connection(self.mapzone_mng_dlg)
            else:
                tools_qgis.show_warning(model.lastError().text(), dialog=self.mapzone_mng_dlg)
        # Attach model to table view
        if expr:
            widget.setModel(model)
            widget.model().setFilter(expr)
        else:
            widget.setModel(model)
        widget.setSortingEnabled(True)

        # Set widget & model properties
        tools_qt.set_tableview_config(widget, selection=QAbstractItemView.SelectRows, edit_triggers=set_edit_triggers,
                                      sectionResizeMode=0)
        tools_gw.set_tablemodel_config(self.mapzone_mng_dlg, widget, f"{self.table_name[len(f'{self.schema_name}.'):]}")

        # Hide unwanted columns
        col_idx = tools_qt.get_col_index_by_col_name(widget, 'dscenario_id')
        if col_idx not in (None, False):
            widget.setColumnHidden(col_idx, True)

        geom_col_idx = tools_qt.get_col_index_by_col_name(widget, 'the_geom')
        if geom_col_idx not in (None, False):
            widget.setColumnHidden(geom_col_idx, True)

        # Sort the table
        model.sort(0, 0)

    def _filter_active(self, dialog, active):
        """ Filters manager table by active """

        widget_table = dialog.main_tab.currentWidget()

        if active is None:
            active = dialog.chk_active.checkState()

        search_text = dialog.txt_name.text()
        expr = ""
        if not active:
            expr = f"active is true"

        if search_text:
            if expr:
                expr += " and "
            expr += f"name ilike '%{search_text}%'"
        # Refresh model with selected filter
        widget_table.model().setFilter(expr)
        widget_table.model().select()

    def _open_mapzones_analysis(self):
        """ Opens the toolbox 'mapzones_analysis' with the current type of mapzone set """

        # Execute toolbox function
        toolbox_btn = GwToolBoxButton(None, None, None, None, None)
        dlg_functions = toolbox_btn.open_function_by_id(2768)

        # Set mapzone type in combo graphClass
        mapzone_type = self.mapzone_mng_dlg.main_tab.tabText(self.mapzone_mng_dlg.main_tab.currentIndex())
        tools_qt.set_combo_value(dlg_functions.findChild(QComboBox, 'graphClass'), f"{mapzone_type.upper()}", 0)

    # region config button

    def manage_config(self, dialog, tableview=None):
        """ Dialog from config button """

        # Get selected row
        if tableview is None:
            tableview = dialog.main_tab.currentWidget()
        selected_list = tableview.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=dialog)
            return

        # Get selected mapzone data
        index = tableview.selectionModel().currentIndex()
        self.mapzone_type = tableview.objectName().split('_')[-1].lower()
        col_idx = tools_qt.get_col_index_by_col_name(tableview, f'{self.mapzone_type}_id')
        self.mapzone_id = index.sibling(index.row(), col_idx).data()
        col_idx = tools_qt.get_col_index_by_col_name(tableview, f'name')
        if col_idx is None:
            col_idx = tools_qt.get_col_index_by_col_name(tableview, f'{self.mapzone_type}_name')
        mapzone_name = index.sibling(index.row(), col_idx).data()
        col_idx = tools_qt.get_col_index_by_col_name(tableview, 'graphconfig')
        graphconfig = index.sibling(index.row(), col_idx).data()

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
        # nodeParent
        self.config_dlg.btn_snapping_nodeParent.clicked.connect(
            partial(self.get_snapped_feature_id, self.config_dlg, self.config_dlg.btn_snapping_nodeParent,
                    'v_edit_node', 'nodeParent', None,
                    self.child_type))
        self.config_dlg.txt_nodeParent.textEdited.connect(partial(self._txt_node_parent_finished))
        # toArc
        self.config_dlg.btn_snapping_toArc.clicked.connect(
            partial(self.get_snapped_feature_id, self.config_dlg, self.config_dlg.btn_snapping_toArc, 'v_edit_arc',
                    'toArc', None,
                    self.child_type))
        self.config_dlg.btn_add_nodeParent.clicked.connect(
            partial(self._add_node_parent, self.config_dlg)
        )
        self.config_dlg.btn_remove_nodeParent.clicked.connect(
            partial(self._remove_node_parent, self.config_dlg)
        )
        # Force closed
        self.config_dlg.btn_snapping_forceClosed.clicked.connect(
            partial(self.get_snapped_feature_id, self.config_dlg, self.config_dlg.btn_snapping_forceClosed,
                    'v_edit_node', 'forceClosed', None,
                    self.child_type))
        self.config_dlg.btn_add_forceClosed.clicked.connect(
            partial(self._add_force_closed, self.config_dlg)
        )
        self.config_dlg.btn_remove_forceClosed.clicked.connect(
            partial(self._remove_force_closed, self.config_dlg)
        )
        # Preview
        self.config_dlg.btn_clear_preview.clicked.connect(partial(self._clear_preview, self.config_dlg))
        # Dialog buttons
        self.config_dlg.btn_accept.clicked.connect(partial(self._accept_config, self.config_dlg))
        self.config_dlg.btn_cancel.clicked.connect(self.config_dlg.reject)
        self.config_dlg.finished.connect(partial(self._config_dlg_finished, self.config_dlg))

        # Enable/disable certain widgets
        tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_snapping_nodeParent, True)
        tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_snapping_toArc, False)
        tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_add_nodeParent, False)
        tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_remove_nodeParent, False)

        tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_snapping_forceClosed, True)
        tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_add_forceClosed, False)
        tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_remove_forceClosed, False)

        tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_clear_preview, True)

        # Hide widgets for UD projects
        if global_vars.project_type == 'ud':
            tools_qt.set_widget_visible(self.config_dlg, self.config_dlg.lbl_toArc, False)
            tools_qt.set_widget_visible(self.config_dlg, self.config_dlg.btn_snapping_toArc, False)
            tools_qt.set_widget_visible(self.config_dlg, self.config_dlg.txt_toArc, False)

        # Open dialog
        dlg_title = f"Mapzone config - {mapzone_name}"
        if self.netscenario_id is not None:
            dlg_title += f" (Netscenario {self.netscenario_id})"
        tools_gw.open_dialog(self.config_dlg, 'mapzone_config', title=dlg_title)


    def _config_dlg_finished(self, dialog):

        self._cancel_snapping_tool(dialog, None)
        self.iface.actionPan().trigger()
        tools_gw.close_dialog(dialog)


    def _reset_config_vars(self, mode=0):
        """
        Reset config variables

            :param mode: which variables to reset {0: all, 1: nodeParent (& toArc), 2: toArc, 3: forceClosed}
        """

        if mode in (0, 1):
            self.node_parent = None
            tools_qt.set_widget_text(self.config_dlg, 'txt_nodeParent', '')
            tools_qt.set_widget_enabled(self.config_dlg, 'btn_snapping_toArc', False)
            tools_qt.set_widget_enabled(self.config_dlg, 'btn_add_nodeParent', False)
            tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_remove_nodeParent, False)
        if mode in (0, 1, 2):
            self.to_arc_list = set()
            tools_qt.set_widget_text(self.config_dlg, 'txt_toArc', '')
        if mode in (0, 3):
            self.force_closed_list = set()
            tools_qt.set_widget_text(self.config_dlg, 'txt_forceClosed', '')
            tools_qt.set_widget_enabled(self.config_dlg, 'btn_add_forceClosed', False)
            tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_remove_forceClosed, False)

    def get_snapped_feature_id(self, dialog, action, layer_name, option, widget_name, child_type):
        """ Snap feature and set a value into dialog """

        layer = tools_qgis.get_layer_by_tablename(layer_name)
        if not layer:
            action.setChecked(False)
            return

        self.vertex_marker = self.snapper_manager.vertex_marker

        # Set signals
        tools_gw.disconnect_signal('mapzone_manager_snapping', 'get_snapped_feature_id_xyCoordinates_mouse_moved')
        tools_gw.connect_signal(self.canvas.xyCoordinates, partial(self._mouse_moved, layer),
                                'mapzone_manager_snapping', 'get_snapped_feature_id_xyCoordinates_mouse_moved')

        tools_gw.disconnect_signal('mapzone_manager_snapping', 'get_snapped_feature_id_ep_canvasClicked_get_id')
        emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(emit_point)
        tools_gw.connect_signal(emit_point.canvasClicked,
                                partial(self._get_id, dialog, action, option, emit_point, child_type),
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
            getattr(self, options[option][1])(feat_id)
        except Exception as e:
            tools_qgis.show_warning(f"Exception in info (def _get_id)", parameter=e)
        finally:
            if option == 'nodeParent':
                self._cancel_snapping_tool(dialog, action)


    def _txt_node_parent_finished(self, text):
        self._set_node_parent(text, False)


    def _set_node_parent(self, feat_id, set_text=True):
        """
        Function called in def _get_id(self, dialog, action, option, point, event):
            getattr(self, options[option][1])(feat_id)

            :param feat_id: Id of the snapped feature
        """

        self.node_parent = feat_id

        if set_text:
            tools_qt.set_widget_text(self.config_dlg, 'txt_nodeParent', f"{feat_id}")
        tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_snapping_toArc, bool(feat_id))
        tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_remove_nodeParent, bool(feat_id))
        if global_vars.project_type == 'ud':
            tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_add_nodeParent, bool(feat_id))

        self._reset_config_vars(2 if bool(feat_id) else 1)

    def _set_to_arc(self, feat_id):
        """
        Function called in def _get_id(self, dialog, action, option, point, event):
            getattr(self, options[option][1])(feat_id)

            :param feat_id: Id of the snapped feature
        """

        # Set variable, set widget text and enable add button

        self.to_arc_list.add(feat_id)
        to_arc_list_aux = [int(to_arc) for to_arc in self.to_arc_list]
        tools_qt.set_widget_text(self.config_dlg, 'txt_toArc', f"{to_arc_list_aux}")
        tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_add_nodeParent, True)
        tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_remove_nodeParent, True)

    def _set_force_closed(self, feat_id):
        """
        Function called in def _get_id(self, dialog, action, option, point, event):
            getattr(self, options[option][1])(feat_id)

            :param feat_id: Id of the snapped feature
        """

        # Set variable, set widget text and enable add button

        self.force_closed_list.add(feat_id)
        force_closed_list_aux = [int(force_closed) for force_closed in self.force_closed_list]
        tools_qt.set_widget_text(self.config_dlg, 'txt_forceClosed', f"{force_closed_list_aux}")
        tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_add_forceClosed, True)
        tools_qt.set_widget_enabled(self.config_dlg, self.config_dlg.btn_remove_forceClosed, True)

    def _add_node_parent(self, dialog):
        """ ADD button for nodeParent """

        node_parent_id = self.node_parent
        to_arc_list = json.dumps(list(self.to_arc_list))
        preview = tools_qt.get_text(dialog, 'txt_preview')

        parameters = f'"action": "ADD", "configZone": "{self.mapzone_type}", "mapzoneId": "{self.mapzone_id}", ' \
                     f'"nodeParent": "{node_parent_id}", "toArc": {to_arc_list}'
        if self.netscenario_id is not None:
            parameters += f', "netscenarioId": {self.netscenario_id}'
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

    def _remove_node_parent(self, dialog):
        """ REMOVE button for nodeParent """

        node_parent_id = self.node_parent
        preview = tools_qt.get_text(dialog, 'txt_preview')

        parameters = f'"action": "REMOVE", "configZone": "{self.mapzone_type}", "mapzoneId": "{self.mapzone_id}", ' \
                     f'"nodeParent": "{node_parent_id}"'
        if self.netscenario_id is not None:
            parameters += f', "netscenarioId": {self.netscenario_id}'
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

            self._cancel_snapping_tool(dialog, dialog.btn_remove_nodeParent)
            self._reset_config_vars(1)

    def _add_force_closed(self, dialog):
        """ ADD button for forceClosed """

        force_closed_list = json.dumps(list(self.force_closed_list))
        preview = tools_qt.get_text(dialog, 'txt_preview')

        parameters = f'"action": "ADD", "configZone": "{self.mapzone_type}", "mapzoneId": "{self.mapzone_id}", ' \
                     f'"forceClosed": {force_closed_list}'
        if self.netscenario_id is not None:
            parameters += f', "netscenarioId": {self.netscenario_id}'
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
            self._reset_config_vars(3)

    def _remove_force_closed(self, dialog):
        """ ADD button for forceClosed """

        force_closed_list = json.dumps(list(self.force_closed_list))
        preview = tools_qt.get_text(dialog, 'txt_preview')

        parameters = f'"action": "REMOVE", "configZone": "{self.mapzone_type}", "mapzoneId": "{self.mapzone_id}", ' \
                     f'"forceClosed": {force_closed_list}'
        if self.netscenario_id is not None:
            parameters += f', "netscenarioId": {self.netscenario_id}'
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
            self._reset_config_vars(3)

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
        if self.netscenario_id is not None:
            parameters += f', "netscenarioId": {self.netscenario_id}'
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

            self._get_graph_config()
            self._reset_config_vars(0)
            tools_gw.close_dialog(dialog)
            self._manage_current_changed()

    def _get_graph_config(self):
        context = "OPERATIVE" if self.netscenario_id is None else "NETSCENARIO"
        extras = f'"context":"{context}", "mapzone": "{self.mapzone_type}", "mapzoneId": "{self.mapzone_id}"'
        if self.netscenario_id is not None:
            extras += f', "netscenarioId": {self.netscenario_id}'
        body = tools_gw.create_body(extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_getgraphconfig', body)
        if json_result is None:
            return

    def _cancel_snapping_tool(self, dialog, action):

        tools_qgis.disconnect_snapping(False, None, self.vertex_marker)
        tools_gw.disconnect_signal('mapzone_manager_snapping')
        dialog.blockSignals(False)
        if action:
            action.setChecked(False)
        # self.signal_activate.emit()

    # endregion

    def _manage_toggle_active(self):
        # Get selected row
        tableview = self.mapzone_mng_dlg.main_tab.currentWidget()
        view = tableview.objectName().replace('tbl_', '').replace('v_ui_', 'v_edit_')
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

        sql = f"UPDATE {view} SET active = {str(not active).lower()} WHERE {field_id}::text = '{mapzone_id}'"
        tools_db.execute_sql(sql)

        # Refresh tableview
        self._manage_current_changed()


    def manage_create(self, dialog, tableview=None):

        if tableview is None:
            tableview = dialog.main_tab.currentWidget()
        tablename = tableview.objectName().replace('tbl_', '').replace('v_ui_', 'v_edit_')
        field_id = tableview.model().headerData(0, Qt.Horizontal)

        # Execute getinfofromid
        feature = f'"tableName":"{tablename}"'
        body = tools_gw.create_body(feature=feature)
        json_result = tools_gw.execute_procedure('gw_fct_getinfofromid', body)
        if json_result is None or json_result['status'] == 'Failed':
            return
        result = json_result

        dlg_title = f"New {tablename.split('_')[-1].capitalize()}"

        self._build_generic_info(dlg_title, result, tablename, field_id, force_action="INSERT")


    def manage_update(self, dialog, tableview=None):
        # Get selected row
        if tableview is None:
            tableview = dialog.main_tab.currentWidget()
        tablename = tableview.objectName().replace('tbl_', '').replace('v_ui_', 'v_edit_')
        selected_list = tableview.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=dialog)
            return

        # Get selected mapzone data
        index = tableview.selectionModel().currentIndex()
        col_name = f"{tablename.split('_')[-1].lower()}_id"
        if col_name == 'valve_id':
            col_name = 'node_id'
        col_idx = tools_qt.get_col_index_by_col_name(tableview, col_name)

        mapzone_id = index.sibling(index.row(), col_idx).data()
        field_id = tableview.model().headerData(col_idx, Qt.Horizontal)

        # Execute getinfofromid
        _id = f"{mapzone_id}"
        if self.netscenario_id is not None:
            _id = f"{self.netscenario_id}, {mapzone_id}"
        feature = f'"tableName":"{tablename}", "id": "{_id}"'
        body = tools_gw.create_body(feature=feature)
        json_result = tools_gw.execute_procedure('gw_fct_getinfofromid', body)
        if json_result is None or json_result['status'] == 'Failed':
            return
        result = json_result

        dlg_title = f"Update {tablename.split('_')[-1].capitalize()} ({mapzone_id})"

        self._build_generic_info(dlg_title, result, tablename, field_id, force_action="UPDATE")


    def _manage_delete(self):
        # Get selected row
        tableview = self.mapzone_mng_dlg.main_tab.currentWidget()
        view = tableview.objectName().replace('tbl_', '').replace('v_ui_', 'v_edit_')
        selected_list = tableview.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=self.mapzone_mng_dlg)
            return

        # Get selected mapzone data
        field_id = tableview.model().headerData(0, Qt.Horizontal)
        mapzone_ids = [index.sibling(index.row(), 0).data() for index in selected_list]

        message = "Are you sure you want to delete these records?"
        answer = tools_qt.show_question(message, "Delete records", [index.sibling(index.row(), 1).data() for index in selected_list], force_action=True)
        if answer:
            # Build WHERE IN clause for SQL
            where_clause = f"{field_id} IN ({', '.join(map(str, mapzone_ids))})"

            # Construct SQL DELETE statement
            sql = f"DELETE FROM {view} WHERE {where_clause}"
            tools_db.execute_sql(sql)

            # Refresh tableview
            self._manage_current_changed()


    def _build_generic_info(self, dlg_title, result, tablename, field_id, force_action=None):
        # Build dlg
        self.add_dlg = GwInfoGenericUi()
        tools_gw.load_settings(self.add_dlg)
        self.my_json_add = {}
        tools_gw.build_dialog_info(self.add_dlg, result, my_json=self.my_json_add)
        layout = self.add_dlg.findChild(QGridLayout, 'lyt_main_1')
        self.add_dlg.actionEdit.setVisible(False)
        # Disable widgets if updating
        if force_action == "UPDATE":
            tools_qt.set_widget_enabled(self.add_dlg, f'tab_none_{field_id}', False)  # sector_id/dma_id/...
        # Populate netscenario_id
        if self.netscenario_id is not None:
            tools_qt.set_widget_text(self.add_dlg, f'tab_none_netscenario_id', self.netscenario_id)
            tools_qt.set_widget_enabled(self.add_dlg, f'tab_none_netscenario_id', False)
            tools_qt.set_checked(self.add_dlg, 'tab_none_active', True)
            field_id = ['netscenario_id', field_id]

        # Get every widget in the layout
        widgets = []
        for row in range(layout.rowCount()):
            for column in range(layout.columnCount()):
                item = layout.itemAtPosition(row, column)
                if item is not None:
                    widget = item.widget()
                    if widget is not None and type(widget) != QLabel:
                        widgets.append(widget)
        # Get all widget's values
        for widget in widgets:
            tools_gw.get_values(self.add_dlg, widget, self.my_json_add, ignore_editability=True)
        # Remove Nones from self.my_json_add
        keys_to_remove = []
        for key, value in self.my_json_add.items():
            if value is None:
                keys_to_remove.append(key)
        for key in keys_to_remove:
            del self.my_json_add[key]
        # Signals
        self.add_dlg.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.add_dlg))
        self.add_dlg.dlg_closed.connect(partial(tools_gw.close_dialog, self.add_dlg))
        self.add_dlg.dlg_closed.connect(self._manage_current_changed)
        self.add_dlg.btn_accept.clicked.connect(
            partial(self._accept_add_dlg, self.add_dlg, tablename, field_id, None, self.my_json_add, result, force_action))
        # Open dlg
        tools_gw.open_dialog(self.add_dlg, dlg_name='info_generic', title=dlg_title)


    def _accept_add_dlg(self, dialog, tablename, pkey, feature_id, my_json, complet_result, force_action):
        if not my_json:
            return

        list_mandatory = []
        list_filter = []

        for field in complet_result['body']['data']['fields']:
            if field['ismandatory']:
                widget = dialog.findChild(QWidget, field['widgetname'])
                if not widget:
                    continue
                widget.setStyleSheet(None)
                value = tools_qt.get_text(dialog, widget)
                if value in ('null', None, ''):
                    widget.setStyleSheet("border: 1px solid red")
                    list_mandatory.append(field['widgetname'])
                else:
                    elem = [field['columnname'], value]
                    list_filter.append(elem)

        if list_mandatory:
            msg = "Some mandatory values are missing. Please check the widgets marked in red."
            tools_qgis.show_warning(msg, dialog=dialog)
            tools_qt.set_action_checked("actionEdit", True, dialog)
            return False

        fields = json.dumps(my_json)
        id_val = ""
        if pkey:
            if not isinstance(pkey, list):
                pkey = [pkey]
            for pk in pkey:
                results = pk.split(',')
                for result in results:
                    widget_name = f"tab_none_{result}"
                    value = tools_qt.get_widget_value(dialog, widget_name)
                    id_val += f"{value}, "
            id_val = id_val[:-2]
        # if id_val in (None, '', 'None'):
        #     id_val = feature_id
        feature = f'"id":"{id_val}", '
        feature += f'"tableName":"{tablename}"'
        extras = f'"fields":{fields}'
        if force_action:
            extras += f', "force_action":"{force_action}"'
        body = tools_gw.create_body(feature=feature, extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_upsertfields', body)
        if json_result and json_result.get('status') == 'Accepted':
            tools_gw.close_dialog(dialog)
            return

        tools_qgis.show_warning('Error', parameter=json_result, dialog=dialog)
