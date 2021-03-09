"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
from datetime import datetime
from functools import partial

from qgis.PyQt.QtCore import Qt, QDate, QStringListModel, QTime
from qgis.PyQt.QtWidgets import QAbstractItemView, QAction, QCompleter, QLineEdit, QTableView, QTabWidget, QTextEdit
from qgis.PyQt.QtXml import QDomDocument
from qgis.core import QgsApplication,  QgsFeatureRequest, QgsPrintLayout, QgsProject, QgsReadWriteContext,\
    QgsVectorLayer
from qgis.gui import QgsMapToolEmitPoint

from .mincut_tools import GwMincutTools
from .search import GwSearch
from ..threads.auto_mincut_execute import GwAutoMincutTask
from ..utils import tools_gw
from ..utils.snap_manager import GwSnapManager
from ..ui.ui_manager import GwDialogTextUi, GwMincutComposerUi, GwMincutConnecUi, GwMincutEndUi, GwMincutHydrometerUi
from ... import global_vars
from ...lib import tools_qt, tools_qgis, tools_log, tools_db


class GwMincut:

    def __init__(self):

        self.iface = global_vars.iface
        self.canvas = global_vars.canvas
        self.plugin_dir = global_vars.plugin_dir
        self.settings = global_vars.giswater_settings
        self.schema_name = global_vars.schema_name

        # Create separate class to manage 'actionConfig'
        self.mincut_tools = GwMincutTools(self)

        # Get layers of node, arc, connec group
        self.node_group = []
        self.layers = dict()
        self.layers_connec = None
        self.arc_group = []
        self.hydro_list = []
        self.deleted_list = []
        self.ids = []
        self.list_ids = {'arc': [], 'node': [], 'connec': [], 'gully': [], 'element': []}

        # Serialize data of mincut states
        self._set_states()
        self.current_state = None
        self.is_new = True

        self.previous_snapping = None
        self.emit_point = None
        self.vertex_marker = None


    def manage_mincuts(self, dialog):
        """ Button 27: Mincut management """

        self.action = "manage_mincuts"
        self.mincut_tools.set_dialog(dialog)
        self.mincut_tools.get_mincut_manager()


    def load_mincut(self, result_mincut_id):
        """ Load selected mincut """

        self.is_new = False
        # Force fill form mincut
        self.result_mincut_id.setText(str(result_mincut_id))
        sql = (f"SELECT om_mincut.*, cat_users.name AS assigned_to_name, v_ext_streetaxis.descript AS street_name"
               f" FROM om_mincut"
               f" INNER JOIN cat_users ON cat_users.id = om_mincut.assigned_to"
               f" LEFT JOIN v_ext_streetaxis ON v_ext_streetaxis.id = om_mincut.streetaxis_id"
               f" WHERE om_mincut.id = '{result_mincut_id}'")
        row = tools_db.get_row(sql)
        if not row:
            self._enable_widgets('0')
            return

        # Get mincut state name
        mincut_state_name = ''
        if row['mincut_state'] in self.states:
            mincut_state_name = self.states[row['mincut_state']]

        tools_qt.set_widget_text(self.dlg_mincut, self.dlg_mincut.work_order, row['work_order'])
        tools_qt.set_combo_value(self.dlg_mincut.type, row['mincut_type'], 0)
        tools_qt.set_combo_value(self.dlg_mincut.cause, row['anl_cause'], 0)
        tools_qt.set_widget_text(self.dlg_mincut, self.dlg_mincut.state, mincut_state_name)
        extras = f'"mincutId":"{result_mincut_id}"'
        body = tools_gw.create_body(extras=extras)
        result = tools_gw.execute_procedure('gw_fct_getmincut', body)
        if result and result['status'] == 'Accepted':
            tools_gw.add_layer_temp(self.dlg_mincut, result['body']['data'], None, False, call_set_tabs_enabled=False)

        # Manage location
        tools_qt.set_combo_value(self.dlg_mincut.address_add_muni, str(row['muni_id']), 0)
        tools_qt.set_widget_text(self.dlg_mincut, self.dlg_mincut.address_add_street, str(row['street_name']))
        tools_qt.set_widget_text(self.dlg_mincut, self.dlg_mincut.address_add_postnumber, str(row['postnumber']))

        # Manage dates
        self._open_mincut_manage_dates(row)

        tools_qt.set_widget_text(self.dlg_mincut, "pred_description", row['anl_descript'])
        tools_qt.set_widget_text(self.dlg_mincut, "real_description", row['exec_descript'])
        tools_qt.set_widget_text(self.dlg_mincut, "distance", row['exec_from_plot'])
        tools_qt.set_widget_text(self.dlg_mincut, "depth", row['exec_depth'])
        tools_qt.set_widget_text(self.dlg_mincut, "assigned_to", row['assigned_to_name'])

        # Update table 'selector_mincut_result'
        self._update_result_selector(result_mincut_id)
        tools_qgis.refresh_map_canvas()
        self.current_state = str(row['mincut_state'])
        sql = (f"SELECT mincut_class FROM om_mincut"
               f" WHERE id = '{result_mincut_id}'")
        row = tools_db.get_row(sql)
        mincut_class_status = None
        if row[0]:
            mincut_class_status = str(row[0])

        expr_filter = f"result_id={result_mincut_id}"
        tools_qt.set_tableview_config(self.dlg_mincut.tbl_hydro)
        message = tools_qt.fill_table(self.dlg_mincut.tbl_hydro, 'v_om_mincut_hydrometer', expr_filter=expr_filter)
        if message:
            tools_qgis.show_warning(message)

        # Depend of mincut_state and mincut_clase desable/enable widgets
        # Current_state == '0': Planified
        if self.current_state == '0':
            self.dlg_mincut.work_order.setDisabled(False)
            # Group Location
            self.dlg_mincut.address_add_muni.setDisabled(False)
            self.dlg_mincut.address_add_street.setDisabled(False)
            self.dlg_mincut.address_add_postnumber.setDisabled(False)
            # Group Details
            self.dlg_mincut.type.setDisabled(False)
            self.dlg_mincut.cause.setDisabled(False)
            self.dlg_mincut.cbx_recieved_day.setDisabled(False)
            self.dlg_mincut.cbx_recieved_time.setDisabled(False)
            # Group Prediction
            self.dlg_mincut.cbx_date_start_predict.setDisabled(False)
            self.dlg_mincut.cbx_hours_start_predict.setDisabled(False)
            self.dlg_mincut.cbx_date_end_predict.setDisabled(False)
            self.dlg_mincut.cbx_hours_end_predict.setDisabled(False)
            self.dlg_mincut.assigned_to.setDisabled(False)
            self.dlg_mincut.pred_description.setDisabled(False)
            # Group Real Details
            self.dlg_mincut.cbx_date_start.setDisabled(True)
            self.dlg_mincut.cbx_hours_start.setDisabled(True)
            self.dlg_mincut.cbx_date_end.setDisabled(True)
            self.dlg_mincut.cbx_hours_end.setDisabled(True)
            self.dlg_mincut.distance.setDisabled(True)
            self.dlg_mincut.depth.setDisabled(True)
            self.dlg_mincut.appropiate.setDisabled(True)
            self.dlg_mincut.real_description.setDisabled(True)
            self.dlg_mincut.btn_start.setDisabled(False)
            self.dlg_mincut.btn_end.setDisabled(True)
            # Actions
            if mincut_class_status == '1':
                self.action_mincut.setDisabled(False)
                self.action_refresh_mincut.setDisabled(False)
                self.action_custom_mincut.setDisabled(False)
                self.action_change_valve_status.setDisabled(False)
                self.action_add_connec.setDisabled(True)
                self.action_add_hydrometer.setDisabled(True)
            if mincut_class_status == '2':
                self.action_mincut.setDisabled(True)
                self.action_refresh_mincut.setDisabled(True)
                self.action_custom_mincut.setDisabled(True)
                self.action_change_valve_status.setDisabled(True)
                self.action_add_connec.setDisabled(False)
                self.action_add_hydrometer.setDisabled(True)
            if mincut_class_status == '3':
                self.action_mincut.setDisabled(True)
                self.action_refresh_mincut.setDisabled(True)
                self.action_custom_mincut.setDisabled(True)
                self.action_change_valve_status.setDisabled(True)
                self.action_add_connec.setDisabled(True)
                self.action_add_hydrometer.setDisabled(False)
            if mincut_class_status is None:
                self.action_mincut.setDisabled(False)
                self.action_refresh_mincut.setDisabled(False)
                self.action_custom_mincut.setDisabled(True)
                self.action_change_valve_status.setDisabled(True)
                self.action_add_connec.setDisabled(False)
                self.action_add_hydrometer.setDisabled(False)

        # Current_state == '1': In progress
        elif self.current_state == '1':

            self.dlg_mincut.work_order.setDisabled(True)
            # Group Location
            self.dlg_mincut.address_add_muni.setDisabled(True)
            self.dlg_mincut.address_add_street.setDisabled(True)
            self.dlg_mincut.address_add_postnumber.setDisabled(True)
            # Group Details
            self.dlg_mincut.type.setDisabled(True)
            self.dlg_mincut.cause.setDisabled(True)
            self.dlg_mincut.cbx_recieved_day.setDisabled(True)
            self.dlg_mincut.cbx_recieved_time.setDisabled(True)
            # Group Prediction dates
            self.dlg_mincut.cbx_date_start_predict.setDisabled(True)
            self.dlg_mincut.cbx_hours_start_predict.setDisabled(True)
            self.dlg_mincut.cbx_date_end_predict.setDisabled(True)
            self.dlg_mincut.cbx_hours_end_predict.setDisabled(True)
            self.dlg_mincut.assigned_to.setDisabled(True)
            self.dlg_mincut.pred_description.setDisabled(True)
            # Group Real dates
            self.dlg_mincut.cbx_date_start.setDisabled(False)
            self.dlg_mincut.cbx_hours_start.setDisabled(False)
            self.dlg_mincut.cbx_date_end.setDisabled(True)
            self.dlg_mincut.cbx_hours_end.setDisabled(True)
            self.dlg_mincut.distance.setDisabled(False)
            self.dlg_mincut.depth.setDisabled(False)
            self.dlg_mincut.appropiate.setDisabled(False)
            self.dlg_mincut.real_description.setDisabled(False)
            self.dlg_mincut.btn_start.setDisabled(True)
            self.dlg_mincut.btn_end.setDisabled(False)
            # Actions
            self.action_mincut.setDisabled(True)
            self.action_refresh_mincut.setDisabled(True)
            self.action_custom_mincut.setDisabled(True)
            self.action_change_valve_status.setDisabled(True)
            self.action_add_connec.setDisabled(True)
            self.action_add_hydrometer.setDisabled(True)

        # Current_state == '2': Finished, '3':Canceled
        elif self.current_state in ('2', '3'):
            self.dlg_mincut.work_order.setDisabled(True)
            # Group Location
            self.dlg_mincut.address_add_muni.setDisabled(True)
            self.dlg_mincut.address_add_street.setDisabled(True)
            self.dlg_mincut.address_add_postnumber.setDisabled(True)
            # Group Details
            self.dlg_mincut.type.setDisabled(True)
            self.dlg_mincut.cause.setDisabled(True)
            self.dlg_mincut.cbx_recieved_day.setDisabled(True)
            self.dlg_mincut.cbx_recieved_time.setDisabled(True)
            # Group Prediction dates
            self.dlg_mincut.cbx_date_start_predict.setDisabled(True)
            self.dlg_mincut.cbx_hours_start_predict.setDisabled(True)
            self.dlg_mincut.cbx_date_end_predict.setDisabled(True)
            self.dlg_mincut.cbx_hours_end_predict.setDisabled(True)
            self.dlg_mincut.assigned_to.setDisabled(True)
            self.dlg_mincut.pred_description.setDisabled(True)
            # Group Real dates
            self.dlg_mincut.cbx_date_start.setDisabled(True)
            self.dlg_mincut.cbx_hours_start.setDisabled(True)
            self.dlg_mincut.cbx_date_end.setDisabled(True)
            self.dlg_mincut.cbx_hours_end.setDisabled(True)
            self.dlg_mincut.distance.setDisabled(True)
            self.dlg_mincut.depth.setDisabled(True)
            self.dlg_mincut.appropiate.setDisabled(True)
            self.dlg_mincut.real_description.setDisabled(True)
            self.dlg_mincut.btn_start.setDisabled(True)
            self.dlg_mincut.btn_end.setDisabled(True)
            # Actions
            self.action_mincut.setDisabled(True)
            self.action_refresh_mincut.setDisabled(True)
            self.action_custom_mincut.setDisabled(True)
            self.action_change_valve_status.setDisabled(True)
            self.action_add_connec.setDisabled(True)
            self.action_add_hydrometer.setDisabled(True)

        # Common Actions
        self.action_mincut_composer.setDisabled(False)

        return row


    def connect_signal_selection_changed(self, option):
        """ Connect signal selectionChanged """

        try:
            if option == "mincut_connec":
                global_vars.canvas.selectionChanged.connect(partial(self._snapping_selection_connec))
            elif option == "mincut_hydro":
                global_vars.canvas.selectionChanged.connect(partial(self._snapping_selection_hydro))
        except Exception:
            pass


    def set_dialog(self, dialog):
        self.dlg_mincut = dialog


    def init_mincut_form(self):
        """ Custom form initial configuration """

        # Setting lists
        self.mincut_class = 1
        self.user_current_layer = self.iface.activeLayer()
        self._init_mincut_canvas()
        tools_qgis.remove_layer_from_toc('Overlap affected arcs', 'GW Temporal Layers')
        tools_qgis.remove_layer_from_toc('Other mincuts which overlaps', 'GW Temporal Layers')
        tools_qgis.remove_layer_from_toc('Overlap affected connecs', 'GW Temporal Layers')

        tools_gw.load_settings(self.dlg_mincut)
        self.dlg_mincut.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_mincut.btn_cancel_task.hide()
        self.dlg_mincut.btn_cancel.show()

        self.search = GwSearch()
        self.search.open_search(None, self.dlg_mincut)

        # These widgets are put from the database, mysteriously if we do something like:
        # self.dlg_mincut.address_add_muni.text() or self.dlg_mincut.address_add_muni.setDiabled(True) etc...
        # it doesn't count them, and that's why we have to force them
        self.dlg_mincut.address_add_muni = tools_qt.get_widget(self.dlg_mincut, 'address_add_muni')
        self.dlg_mincut.address_add_street = tools_qt.get_widget(self.dlg_mincut, 'address_add_street')
        self.dlg_mincut.address_add_postnumber = tools_qt.get_widget(self.dlg_mincut, 'address_add_postnumber')

        self.result_mincut_id = self.dlg_mincut.findChild(QLineEdit, "result_mincut_id")
        self.customer_state = self.dlg_mincut.findChild(QLineEdit, "customer_state")
        self.work_order = self.dlg_mincut.findChild(QLineEdit, "work_order")
        self.pred_description = self.dlg_mincut.findChild(QTextEdit, "pred_description")
        self.real_description = self.dlg_mincut.findChild(QTextEdit, "real_description")
        self.distance = self.dlg_mincut.findChild(QLineEdit, "distance")
        self.depth = self.dlg_mincut.findChild(QLineEdit, "depth")

        tools_qt.double_validator(self.distance, 0, 9999999, 3)
        tools_qt.double_validator(self.depth, 0, 9999999, 3)
        tools_qt.set_widget_text(self.dlg_mincut, self.dlg_mincut.txt_exec_user, global_vars.current_user)

        # Fill ComboBox type
        sql = ("SELECT id, descript "
               "FROM om_mincut_cat_type "
               "ORDER BY id")
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_mincut.type, rows, 1)

        # Fill ComboBox cause
        sql = ("SELECT id, idval "
               "FROM om_typevalue WHERE typevalue = 'mincut_cause' "
               "ORDER BY id")
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_mincut.cause, rows, 1)

        # Fill ComboBox assigned_to
        sql = ("SELECT id, name "
               "FROM cat_users "
               "ORDER BY name")
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_mincut.assigned_to, rows, 1)

        # Toolbar actions
        action = self.dlg_mincut.findChild(QAction, "actionMincut")
        action.triggered.connect(self._auto_mincut)
        tools_gw.add_icon(action, "126")
        self.action_mincut = action

        action = self.dlg_mincut.findChild(QAction, "actionRefreshMincut")
        action.triggered.connect(partial(self._refresh_mincut, action))
        tools_gw.add_icon(action, "125")
        self.action_refresh_mincut = action

        action = self.dlg_mincut.findChild(QAction, "actionCustomMincut")
        action.triggered.connect(partial(self._custom_mincut, action))
        tools_gw.add_icon(action, "123")
        self.action_custom_mincut = action

        action = self.dlg_mincut.findChild(QAction, "actionChangeValveStatus")
        action.triggered.connect(partial(self._change_valve_status, action))
        tools_gw.add_icon(action, "124")
        self.action_change_valve_status = action

        action = self.dlg_mincut.findChild(QAction, "actionAddConnec")
        action.triggered.connect(self._add_connec)
        tools_gw.add_icon(action, "121")
        self.action_add_connec = action

        action = self.dlg_mincut.findChild(QAction, "actionAddHydrometer")
        action.triggered.connect(self._add_hydrometer)
        tools_gw.add_icon(action, "122")
        self.action_add_hydrometer = action

        action = self.dlg_mincut.findChild(QAction, "actionComposer")
        action.triggered.connect(self._mincut_composer)
        tools_gw.add_icon(action, "181")
        self.action_mincut_composer = action

        # Set shortcut keys
        self.dlg_mincut.key_escape.connect(partial(tools_gw.close_dialog, self.dlg_mincut))

        # Show future id of mincut
        if self.is_new:
            self.set_id_val()

        # Set state name
        if self.states != {}:
            tools_qt.set_widget_text(self.dlg_mincut, self.dlg_mincut.state, str(self.states[0]))

        self.current_state = 0
        self.sql_connec = ""
        self.sql_hydro = ""

        self._refresh_tab_hydro()


    def set_id_val(self):

        # Show future id of mincut
        sql = "SELECT setval('om_mincut_seq', (SELECT max(id::integer) FROM om_mincut), true)"
        row = tools_db.get_row(sql)
        result_mincut_id = '1'
        if not row or row[0] is None or row[0] < 1:
            result_mincut_id = '1'
        elif row[0]:
            result_mincut_id = str(int(row[0]) + 1)

        tools_qt.set_widget_text(self.dlg_mincut, self.dlg_mincut.result_mincut_id, str(result_mincut_id))


    def get_mincut(self):
        """ Button 26: Mincut """

        self.is_new = True
        self.init_mincut_form()
        self.action = "get_mincut"

        # Get current date. Set all QDateEdit to current date
        date_start = QDate.currentDate()
        tools_qt.set_calendar(self.dlg_mincut, "cbx_date_start", date_start)
        tools_qt.set_calendar(self.dlg_mincut, "cbx_date_end", date_start)
        tools_qt.set_calendar(self.dlg_mincut, "cbx_recieved_day", date_start)
        tools_qt.set_calendar(self.dlg_mincut, "cbx_date_start_predict", date_start)
        tools_qt.set_calendar(self.dlg_mincut, "cbx_date_end_predict", date_start)

        # Get current time
        current_time = QTime.currentTime()
        self.dlg_mincut.cbx_recieved_time.setTime(current_time)

        # Enable/Disable widget depending state
        self._enable_widgets('0')

        # Show form in docker?
        self.manage_docker()
        tools_qt.manage_translation('mincut', self.dlg_mincut)


    def manage_docker(self):

        tools_gw.init_docker('qgis_form_docker')
        if global_vars.session_vars['dialog_docker']:
            tools_gw.docker_dialog(self.dlg_mincut)
        else:
            tools_gw.open_dialog(self.dlg_mincut, dlg_name='mincut')

        self._set_signals()


    def set_visible_mincut_layers(self, zoom=False):
        """ Set visible mincut result layers """

        layer_zoomed = None
        layer = tools_qgis.get_layer_by_tablename("v_om_mincut_valve")
        if layer:
            tools_qgis.set_layer_visible(layer)

        layer = tools_qgis.get_layer_by_tablename("v_om_mincut_arc")
        if layer:
            tools_qgis.set_layer_visible(layer)

        layer = tools_qgis.get_layer_by_tablename("v_om_mincut_connec")
        if layer:
            tools_qgis.set_layer_visible(layer)
            if layer.featureCount() > 0:
                layer_zoomed = layer

        layer = tools_qgis.get_layer_by_tablename("v_om_mincut_node")
        if layer:
            tools_qgis.set_layer_visible(layer)
            if layer.featureCount() > 0:
                layer_zoomed = layer

        if zoom and layer_zoomed is not None:
            # Refresh extension of layer
            layer_zoomed.updateExtents()
            # Zoom to executed mincut
            self.iface.setActiveLayer(layer_zoomed)
            self.iface.zoomToActiveLayer()


    # region private functions

    def _set_states(self):
        """ Serialize data of mincut states """

        self.states = {}
        sql = ("SELECT id, idval "
               "FROM om_typevalue WHERE typevalue = 'mincut_state' "
               "ORDER BY id")
        rows = tools_db.get_rows(sql)
        if not rows:
            return

        for row in rows:
            self.states[int(row['id'])] = row['idval']


    def _init_mincut_canvas(self):

        self.list_ids['connec'] = []
        self.hydro_list = []
        self.deleted_list = []

        # Refresh canvas, remove all old selections
        self._remove_selection()

        # Parametrize list of layers
        self.layers['connec'] = tools_gw.get_layers_from_feature_type('connec')
        self.layers_connec = self.layers['connec']

        self.layer_arc = tools_qgis.get_layer_by_tablename("v_edit_arc")

        # Set active and current layer
        self.iface.setActiveLayer(self.layer_arc)
        self.current_layer = self.layer_arc


    def _set_signals(self):

        if global_vars.session_vars['dialog_docker']:
            self.dlg_mincut.dlg_closed.connect(tools_gw.close_docker)
        self.dlg_mincut.btn_cancel_task.clicked.connect(self._cancel_task)

        self.dlg_mincut.btn_accept.clicked.connect(self._accept_save_data)
        self.dlg_mincut.btn_cancel.clicked.connect(self._mincut_close)
        self.dlg_mincut.dlg_closed.connect(self._mincut_close)

        self.dlg_mincut.btn_start.clicked.connect(self._real_start)
        self.dlg_mincut.btn_end.clicked.connect(self._real_end)

        self.dlg_mincut.cbx_date_start_predict.dateChanged.connect(partial(
            self._check_dates_coherence, self.dlg_mincut.cbx_date_start_predict, self.dlg_mincut.cbx_date_end_predict,
            self.dlg_mincut.cbx_hours_start_predict, self.dlg_mincut.cbx_hours_end_predict))
        self.dlg_mincut.cbx_date_end_predict.dateChanged.connect(partial(
            self._check_dates_coherence, self.dlg_mincut.cbx_date_start_predict, self.dlg_mincut.cbx_date_end_predict,
            self.dlg_mincut.cbx_hours_start_predict, self.dlg_mincut.cbx_hours_end_predict))

        self.dlg_mincut.cbx_date_start.dateChanged.connect(partial(
            self._check_dates_coherence, self.dlg_mincut.cbx_date_start, self.dlg_mincut.cbx_date_end,
            self.dlg_mincut.cbx_hours_start, self.dlg_mincut.cbx_hours_end))
        self.dlg_mincut.cbx_date_end.dateChanged.connect(partial(
            self._check_dates_coherence, self.dlg_mincut.cbx_date_start, self.dlg_mincut.cbx_date_end,
            self.dlg_mincut.cbx_hours_start, self.dlg_mincut.cbx_hours_end))


    def _refresh_tab_hydro(self):

        result_mincut_id = tools_qt.get_text(self.dlg_mincut, self.dlg_mincut.result_mincut_id)
        expr_filter = f"result_id={result_mincut_id}"
        tools_qt.set_tableview_config(self.dlg_mincut.tbl_hydro, edit_triggers=QTableView.DoubleClicked)
        message = tools_qt.fill_table(self.dlg_mincut.tbl_hydro, 'v_om_mincut_hydrometer', expr_filter=expr_filter)
        if message:
            tools_qgis.show_warning(message)
        tools_gw.set_tablemodel_config(self.dlg_mincut, self.dlg_mincut.tbl_hydro, 'v_om_mincut_hydrometer')


    def _check_dates_coherence(self, date_from, date_to, time_from, time_to):
        """
        Chek if date_to.date() is >= than date_from.date()
        :param date_from: QDateEdit.date from
        :param date_to: QDateEdit.date to
        :param time_from: QDateEdit to get date in order to set widget_to_set
        :param time_to: QDateEdit to set coherence date
        :return:
        """

        d_from = datetime(date_from.date().year(), date_from.date().month(), date_from.date().day(),
                          time_from.time().hour(), time_from.time().minute())
        d_to = datetime(date_to.date().year(), date_to.date().month(), date_to.date().day(),
                        time_to.time().hour(), time_to.time().minute())

        if d_from > d_to:
            date_to.setDate(date_from.date())
            time_to.setTime(time_from.time())


    def _mincut_close(self):

        tools_qgis.restore_user_layer('v_edit_node', self.user_current_layer)
        self._remove_selection()
        tools_qgis.reset_rubber_band(self.search.rubber_band)

        # If client don't touch nothing just rejected dialog or press cancel
        if not self.dlg_mincut.closeMainWin and self.dlg_mincut.mincutCanceled:
            tools_gw.close_dialog(self.dlg_mincut)
            return

        self.dlg_mincut.closeMainWin = True
        self.dlg_mincut.mincutCanceled = True

        # If id exists in data base on btn_cancel delete
        if self.action == "get_mincut":
            result_mincut_id = self.dlg_mincut.result_mincut_id.text()
            sql = (f"SELECT id FROM om_mincut"
                   f" WHERE id = {result_mincut_id}")
            row = tools_db.get_row(sql)
            if row:
                sql = (f"DELETE FROM om_mincut"
                       f" WHERE id = {result_mincut_id}")
                tools_db.execute_sql(sql)
                tools_qgis.show_info("Mincut canceled!")

        # Rollback transaction
        else:
            global_vars.dao.rollback()

        # Close dialog, save dialog position, and disconnect snapping
        tools_gw.close_dialog(self.dlg_mincut)

        tools_qgis.disconnect_snapping(True, self.emit_point, self.vertex_marker)
        self._remove_selection()
        tools_qgis.refresh_map_canvas()


    def _real_start(self):

        date_start = QDate.currentDate()
        time_start = QTime.currentTime()
        self.dlg_mincut.cbx_date_start.setDate(date_start)
        self.dlg_mincut.cbx_hours_start.setTime(time_start)
        self.dlg_mincut.cbx_date_end.setDate(date_start)
        self.dlg_mincut.cbx_hours_end.setTime(time_start)
        self.dlg_mincut.btn_end.setEnabled(True)
        self.dlg_mincut.distance.setEnabled(True)
        self.dlg_mincut.depth.setEnabled(True)
        self.dlg_mincut.real_description.setEnabled(True)

        # Set state to 'In Progress'
        tools_qt.set_widget_text(self.dlg_mincut, self.dlg_mincut.state, str(self.states[1]))
        self.current_state = 1

        # Enable/Disable widget depending state
        self._enable_widgets('1')


    def _real_end(self):

        # Create the dialog and signals
        self.dlg_fin = GwMincutEndUi()
        tools_gw.load_settings(self.dlg_fin)

        search = GwSearch()
        search.open_search(None, self.dlg_fin)

        # These widgets are put from the database, mysteriously if we do something like:
        # self.dlg_mincut.address_add_muni.text() or self.dlg_mincut.address_add_muni.setDiabled(True) etc...
        # it doesn't count them, and that's why we have to force them
        self.dlg_fin.address_add_muni = tools_qt.get_widget(self.dlg_fin, 'address_add_muni')
        self.dlg_fin.address_add_street = tools_qt.get_widget(self.dlg_fin, 'address_add_street')
        self.dlg_fin.address_add_postnumber = tools_qt.get_widget(self.dlg_fin, 'address_add_postnumber')

        mincut = tools_qt.get_text(self.dlg_mincut, self.dlg_mincut.result_mincut_id)
        tools_qt.set_widget_text(self.dlg_fin, self.dlg_fin.mincut, mincut)
        work_order = tools_qt.get_text(self.dlg_mincut, self.dlg_mincut.work_order)
        if str(work_order) != 'null':
            tools_qt.set_widget_text(self.dlg_fin, self.dlg_fin.work_order, work_order)

        # Manage address
        municipality_current = tools_qt.get_combo_value(self.dlg_mincut, self.dlg_mincut.address_add_muni, 1)
        tools_qt.set_combo_value(self.dlg_fin.address_add_muni, municipality_current, 1)
        address_street_current = tools_qt.get_text(self.dlg_mincut, self.dlg_mincut.address_add_street, False, False)
        tools_qt.set_widget_text(self.dlg_fin, self.dlg_fin.address_add_street, address_street_current)
        address_number_current = tools_qt.get_text(self.dlg_mincut, self.dlg_mincut.address_add_postnumber, False, False)
        tools_qt.set_widget_text(self.dlg_fin, self.dlg_fin.address_add_postnumber, address_number_current)

        # Fill ComboBox exec_user
        sql = ("SELECT name "
               "FROM cat_users "
               "ORDER BY name")
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_box(self.dlg_fin, "exec_user", rows, False)
        assigned_to = tools_qt.get_combo_value(self.dlg_mincut, self.dlg_mincut.assigned_to, 1)
        tools_qt.set_widget_text(self.dlg_fin, "exec_user", str(assigned_to))

        date_start = self.dlg_mincut.cbx_date_start.date()
        time_start = self.dlg_mincut.cbx_hours_start.time()
        self.dlg_fin.cbx_date_start_fin.setDate(date_start)
        self.dlg_fin.cbx_hours_start_fin.setTime(time_start)
        date_end = self.dlg_mincut.cbx_date_end.date()
        time_end = self.dlg_mincut.cbx_hours_end.time()
        self.dlg_fin.cbx_date_end_fin.setDate(date_end)
        self.dlg_fin.cbx_hours_end_fin.setTime(time_end)

        # Set state to 'Finished'
        tools_qt.set_widget_text(self.dlg_mincut, self.dlg_mincut.state, str(self.states[2]))
        self.current_state = 2

        # Enable/Disable widget depending state
        self._enable_widgets('2')

        # Set signals
        self.dlg_fin.btn_accept.clicked.connect(self._real_end_accept)
        self.dlg_fin.btn_cancel.clicked.connect(self._real_end_cancel)
        self.dlg_fin.btn_set_real_location.clicked.connect(self._set_real_location)

        # Open the dialog
        tools_gw.open_dialog(self.dlg_fin, dlg_name='mincut_end')


    def _set_real_location(self):

        # Vertex marker
        self.vertex_marker = self.snapper_manager.vertex_marker

        # Activate snapping of node and arcs
        self.canvas.xyCoordinates.connect(self._mouse_move_node_arc)
        self.emit_point.canvasClicked.connect(self._snapping_node_arc_real_location)


    def _accept_save_data(self):
        """ Slot function button 'Accept' """

        tools_gw.save_settings(self.dlg_mincut)
        mincut_result_state = self.current_state

        # Manage 'address'
        address_exploitation_id = tools_qt.get_combo_value(self.dlg_mincut, self.dlg_mincut.address_add_muni)
        address_street = self.dlg_mincut.address_add_street.property('id_')
        address_number = tools_qt.get_text(self.dlg_mincut, self.dlg_mincut.address_add_postnumber, False, False)

        mincut_result_type = tools_qt.get_combo_value(self.dlg_mincut, self.dlg_mincut.type, 0)
        anl_cause = tools_qt.get_combo_value(self.dlg_mincut, self.dlg_mincut.cause, 0)
        work_order = self.dlg_mincut.work_order.text()

        anl_descript = tools_qt.get_text(self.dlg_mincut, "pred_description", return_string_null=False)
        exec_from_plot = str(self.dlg_mincut.distance.text())
        exec_depth = str(self.dlg_mincut.depth.text())
        exec_descript = tools_qt.get_text(self.dlg_mincut, "real_description", return_string_null=False)
        exec_user = tools_qt.get_text(self.dlg_mincut, "exec_user", return_string_null=False)

        # Get prediction date - start
        date_start_predict = self.dlg_mincut.cbx_date_start_predict.date()
        time_start_predict = self.dlg_mincut.cbx_hours_start_predict.time()
        forecast_start_predict = date_start_predict.toString(
            'yyyy-MM-dd') + " " + time_start_predict.toString('HH:mm:ss')

        # Get prediction date - end
        date_end_predict = self.dlg_mincut.cbx_date_end_predict.date()
        time_end_predict = self.dlg_mincut.cbx_hours_end_predict.time()
        forecast_end_predict = date_end_predict.toString('yyyy-MM-dd') + " " + time_end_predict.toString('HH:mm:ss')

        # Get real date - start
        date_start_real = self.dlg_mincut.cbx_date_start.date()
        time_start_real = self.dlg_mincut.cbx_hours_start.time()
        forecast_start_real = date_start_real.toString('yyyy-MM-dd') + " " + time_start_real.toString('HH:mm:ss')

        # Get real date - end
        date_end_real = self.dlg_mincut.cbx_date_end.date()
        time_end_real = self.dlg_mincut.cbx_hours_end.time()
        forecast_end_real = date_end_real.toString('yyyy-MM-dd') + " " + time_end_real.toString('HH:mm:ss')

        # Check data
        received_day = self.dlg_mincut.cbx_recieved_day.date()
        received_time = self.dlg_mincut.cbx_recieved_time.time()
        received_date = received_day.toString('yyyy-MM-dd') + " " + received_time.toString('HH:mm:ss')

        assigned_to = tools_qt.get_combo_value(self.dlg_mincut, self.dlg_mincut.assigned_to, 0)
        cur_user = global_vars.current_user
        appropiate_status = tools_qt.is_checked(self.dlg_mincut, "appropiate")

        check_data = [str(mincut_result_state), str(anl_cause), str(received_date),
                      str(forecast_start_predict), str(forecast_end_predict)]
        for data in check_data:
            if data == '':
                message = "Mandatory field is missing. Please, set a value"
                tools_qgis.show_warning(message)
                return

        if self.is_new:
            self.set_id_val()
            self.is_new = False

        # Check if id exist in table 'om_mincut'
        result_mincut_id = self.dlg_mincut.result_mincut_id.text()
        sql = (f"SELECT id FROM om_mincut "
               f"WHERE id = '{result_mincut_id}';")
        rows = tools_db.get_rows(sql)

        # If not found Insert just its 'id'
        sql = ""
        if not rows:
            sql = (f"INSERT INTO om_mincut (id) "
                   f"VALUES ('{result_mincut_id}');\n")

        # Update all the fields
        sql += (f"UPDATE om_mincut"
                f" SET mincut_state = '{mincut_result_state}',"
                f" mincut_type = '{mincut_result_type}', anl_cause = '{anl_cause}',"
                f" anl_tstamp = '{received_date}', received_date = '{received_date}',"
                f" forecast_start = '{forecast_start_predict}', forecast_end = '{forecast_end_predict}',"
                f" assigned_to = '{assigned_to}', exec_appropiate = '{appropiate_status}'")

        # Manage fields 'work_order' and 'anl_descript'
        if work_order != "":
            sql += f", work_order = $${work_order}$$"
        if anl_descript != "":
            sql += f", anl_descript = $${anl_descript}$$ "

        # Manage address
        if address_exploitation_id != -1:
            sql += f", muni_id = '{address_exploitation_id}'"
        if address_street:
            sql += f", streetaxis_id = '{address_street}'"
        if address_number:
            sql += f", postnumber = '{address_number}'"

        # If state 'In Progress' or 'Finished'
        if mincut_result_state == 1 or mincut_result_state == 2:
            sql += f", exec_start = '{forecast_start_real}', exec_end = '{forecast_end_real}'"
            if exec_from_plot != '':
                sql += f", exec_from_plot = '{exec_from_plot}'"
            if exec_depth != '':
                sql += f",  exec_depth = '{exec_depth}'"
            if exec_descript != '':
                sql += f", exec_descript = $${exec_descript}$$"
            if exec_user != '':
                sql += f", exec_user = '{exec_user}'"
            else:
                sql += f", exec_user = '{cur_user}'"

        sql += f" WHERE id = '{result_mincut_id}';\n"

        # Update table 'selector_mincut_result'
        sql += (f"DELETE FROM selector_mincut_result WHERE cur_user = current_user;\n"
                f"INSERT INTO selector_mincut_result (cur_user, result_id) VALUES "
                f"(current_user, {result_mincut_id});")

        # Check if any 'connec' or 'hydro' associated
        if self.sql_connec != "":
            sql += self.sql_connec

        if self.sql_hydro != "":
            sql += self.sql_hydro

        status = tools_db.execute_sql(sql, log_error=True)
        if status:
            message = "Values has been updated"
            tools_qgis.show_info(message)
            self._update_result_selector(result_mincut_id)
        else:
            message = "Error updating element in table, you need to review data"
            tools_qgis.show_warning(message)

        # Close dialog and disconnect snapping
        tools_qgis.disconnect_snapping(True, self.emit_point, self.vertex_marker)
        sql = (f"SELECT mincut_state, mincut_class FROM om_mincut "
               f" WHERE id = '{result_mincut_id}'")
        row = tools_db.get_row(sql)
        if not row:
            return

        result_mincut_id_text = self.dlg_mincut.result_mincut_id.text()
        extras = f'"action":"mincutAccept", "mincutClass":{self.mincut_class}, "status":"check", '
        extras += f'"mincutId":"{result_mincut_id_text}"'
        body = tools_gw.create_body(extras=extras)
        result = tools_gw.execute_procedure('gw_fct_setmincut', body)
        if not result or result['status'] == 'Failed':
            return

        if self.mincut_class in (2, 3):
            self._mincut_ok(result)
        if self.mincut_class == 1:
            if result['body']['actions']['overlap'] == 'Ok':
                self._mincut_ok(result)
            elif result['body']['actions']['overlap'] == 'Conflict':
                self.dlg_dtext = GwDialogTextUi()
                tools_gw.load_settings(self.dlg_dtext)
                self.dlg_dtext.btn_close.setText('Cancel')
                self.dlg_dtext.btn_accept.setText('Continue')
                self.dlg_dtext.setWindowTitle('Mincut conflict')
                self.dlg_dtext.btn_accept.clicked.connect(partial(self._force_mincut_overlap))
                self.dlg_dtext.btn_accept.clicked.connect(partial(tools_gw.close_dialog, self.dlg_dtext))
                self.dlg_dtext.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_dtext))
                tools_gw.fill_tab_log(self.dlg_dtext, result['body']['data'], False, close=False)
                tools_gw.open_dialog(self.dlg_dtext)

        self.iface.actionPan().trigger()
        self._remove_selection()


    def _force_mincut_overlap(self):

        result_mincut_id_text = self.dlg_mincut.result_mincut_id.text()
        extras = f'"action":"mincutAccept", "mincutClass":{self.mincut_class}, "status":"continue", '
        extras += f'"mincutId":"{result_mincut_id_text}"'
        body = tools_gw.create_body(extras=extras)
        result = tools_gw.execute_procedure('gw_fct_setmincut', body)
        if not result or result['status'] == 'Failed':
            return
        self._mincut_ok(result)


    def _mincut_ok(self, result):

        # Manage result and force tab log
        tools_gw.fill_tab_log(self.dlg_mincut, result['body']['data'], True, True, tab_idx=3)

        # Set tabs enabled(True/False)
        qtabwidget = self.dlg_mincut.findChild(QTabWidget, 'mainTab')
        qtabwidget.widget(0).setEnabled(False)  # Tab plan
        qtabwidget.widget(1).setEnabled(True)   # Tab Exec
        qtabwidget.widget(2).setEnabled(True)   # Tab hydro
        qtabwidget.widget(3).setEnabled(True)   # Tab Log

        self.dlg_mincut.closeMainWin = False
        self.dlg_mincut.mincutCanceled = True

        if self.mincut_class == 1:
            if 'geometry' in result['body']['data']:
                polygon = result['body']['data']['geometry']
                polygon = polygon[9:len(polygon) - 2]
                polygon = polygon.split(',')
                if polygon[0] == '':
                    message = "Error on create auto mincut, you need to review data"
                    tools_qgis.show_warning(message)
                    tools_qgis.restore_cursor()
                    return
                x1, y1 = polygon[0].split(' ')
                x2, y2 = polygon[2].split(' ')
                tools_qgis.zoom_to_rectangle(x1, y1, x2, y2, margin=0)

        self.dlg_mincut.btn_accept.hide()
        self.dlg_mincut.btn_cancel.setText('Close')
        self.dlg_mincut.btn_cancel.disconnect()
        self.dlg_mincut.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_mincut))
        self.dlg_mincut.btn_cancel.clicked.connect(partial(tools_qgis.restore_user_layer, 'v_edit_node', self.user_current_layer))
        self.dlg_mincut.btn_cancel.clicked.connect(partial(self._remove_selection))
        self.dlg_mincut.btn_cancel.clicked.connect(partial(tools_qgis.reset_rubber_band, self.search.rubber_band))
        self._refresh_tab_hydro()

        self.action_mincut.setEnabled(False)
        self.action_refresh_mincut.setEnabled(False)
        self.action_custom_mincut.setEnabled(False)
        self.action_change_valve_status.setEnabled(False)


    def _update_result_selector(self, result_mincut_id, commit=True):
        """ Update table 'selector_mincut_result' """

        sql = (f"DELETE FROM selector_mincut_result WHERE cur_user = current_user;"
               f"\nINSERT INTO selector_mincut_result (cur_user, result_id) VALUES"
               f" (current_user, {result_mincut_id});")
        status = tools_db.execute_sql(sql, commit)
        if not status:
            message = "Error updating table"
            tools_qgis.show_warning(message, parameter='selector_mincut_result')


    def _real_end_accept(self):

        # Get end_date and end_hour from mincut_end dialog
        exec_start_day = self.dlg_fin.cbx_date_start_fin.date()
        exec_start_time = self.dlg_fin.cbx_hours_start_fin.time()
        exec_end_day = self.dlg_fin.cbx_date_end_fin.date()
        exec_end_time = self.dlg_fin.cbx_hours_end_fin.time()

        # Set new values in mincut dialog also
        self.dlg_mincut.cbx_date_start.setDate(exec_start_day)
        self.dlg_mincut.cbx_hours_start.setTime(exec_start_time)
        self.dlg_mincut.cbx_date_end.setDate(exec_end_day)
        self.dlg_mincut.cbx_hours_end.setTime(exec_end_time)
        tools_qt.set_widget_text(self.dlg_mincut, self.dlg_mincut.work_order, str(self.dlg_fin.work_order.text()))
        municipality = self.dlg_fin.address_add_muni.currentText()
        tools_qt.set_combo_value(self.dlg_mincut.address_add_muni, municipality, 1)
        street = tools_qt.get_text(self.dlg_fin, self.dlg_fin.address_add_street, return_string_null=False)
        tools_qt.set_widget_text(self.dlg_mincut, self.dlg_mincut.address_add_street, street)
        street_id = self.dlg_fin.address_add_street.property('id_')
        self.dlg_mincut.address_add_street.setProperty('id_', street_id)
        number = tools_qt.get_text(self.dlg_fin, self.dlg_fin.address_add_postnumber, return_string_null=False)
        tools_qt.set_widget_text(self.dlg_mincut, self.dlg_mincut.address_add_postnumber, number)
        exec_user = tools_qt.get_text(self.dlg_fin, self.dlg_fin.exec_user)
        tools_qt.set_combo_value(self.dlg_mincut.assigned_to, exec_user, 1)

        self.dlg_fin.close()


    def _real_end_cancel(self):

        # Return to state 'In Progress'
        tools_qt.set_widget_text(self.dlg_mincut, self.dlg_mincut.state, str(self.states[1]))
        self._enable_widgets('1')

        self.dlg_fin.close()


    def _add_connec(self):
        """ B3-121: Connec selector """

        self.mincut_class = 2
        self.dlg_mincut.closeMainWin = True
        self.dlg_mincut.canceled = False
        result_mincut_id_text = self.dlg_mincut.result_mincut_id.text()

        # Check if id exist in om_mincut
        sql = (f"SELECT id FROM om_mincut"
               f" WHERE id = '{result_mincut_id_text}';")
        exist_id = tools_db.get_row(sql)
        if not exist_id:
            sql = (f"INSERT INTO om_mincut (id, mincut_class) "
                   f" VALUES ('{result_mincut_id_text}', 2);")
            tools_db.execute_sql(sql)
            self.is_new = False

        # Disable Auto, Custom, Hydrometer
        self.action_mincut.setDisabled(True)
        self.action_refresh_mincut.setDisabled(True)
        self.action_custom_mincut.setDisabled(True)
        self.action_change_valve_status.setDisabled(True)
        self.action_add_hydrometer.setDisabled(True)

        # Set dialog add_connec
        self.dlg_connec = GwMincutConnecUi()
        self.dlg_connec.setWindowTitle("Connec management")
        tools_gw.load_settings(self.dlg_connec)
        self.dlg_connec.tbl_mincut_connec.setSelectionBehavior(QAbstractItemView.SelectRows)
        # Set icons
        tools_gw.add_icon(self.dlg_connec.btn_insert, "111")
        tools_gw.add_icon(self.dlg_connec.btn_delete, "112")
        tools_gw.add_icon(self.dlg_connec.btn_snapping, "137")

        # Set signals
        self.dlg_connec.btn_insert.clicked.connect(partial(self._insert_connec))
        self.dlg_connec.btn_delete.clicked.connect(partial(self._delete_records_connec))
        self.dlg_connec.btn_snapping.clicked.connect(self._snapping_init_connec)
        self.dlg_connec.btn_accept.clicked.connect(partial(self._accept_connec, self.dlg_connec, "connec"))
        self.dlg_connec.rejected.connect(partial(tools_gw.close_dialog, self.dlg_connec))

        # Set autocompleter for 'customer_code'
        self._set_completer_customer_code(self.dlg_connec.connec_id)

        # On opening form check if result_id already exist in om_mincut_connec
        # if exist show data in form / show selection!!!
        if exist_id:
            # Read selection and reload table
            self._select_features_connec()
        self._snapping_selection_connec()
        for layer in self.layers_connec:
            layer.dataProvider().forceReload()

        tools_gw.open_dialog(self.dlg_connec, dlg_name='mincut_connec')


    def _set_completer_customer_code(self, widget, set_signal=False):
        """ Set autocompleter for 'customer_code' """

        # Get list of 'customer_code'
        sql = "SELECT DISTINCT(customer_code) FROM v_edit_connec"
        rows = tools_db.get_rows(sql)
        values = []
        if rows:
            for row in rows:
                values.append(str(row[0]))

        # Adding auto-completion to a QLineEdit
        self.completer = QCompleter()
        widget.setCompleter(self.completer)
        model = QStringListModel()
        model.setStringList(values)
        self.completer.setModel(model)

        if set_signal:
            # noinspection PyUnresolvedReferences
            self.completer.activated.connect(self._auto_fill_hydro_id)


    def _snapping_init_connec(self):
        """ Snap connec """
        self.feature_type = 'connec'
        tools_gw.selection_init(self, self.dlg_connec, self.dlg_connec.tbl_mincut_connec, False)


    def _snapping_selection_hydro(self):
        """ Snap to connec layers to add its hydrometers """

        self.list_ids['connec'] = []

        for layer in self.layers_connec:
            if layer.selectedFeatureCount() > 0:
                # Get selected features of the layer
                features = layer.selectedFeatures()
                # Get id from all selected features
                for feature in features:
                    connec_id = feature.attribute("connec_id")
                    # Add element
                    if connec_id in self.list_ids['connec']:
                        message = "Feature already in the list"
                        tools_qt.show_info_box(message, parameter=connec_id)
                        return
                    else:
                        self.list_ids['connec'].append(connec_id)

        # Set 'expr_filter' with features that are in the list
        expr_filter = "\"connec_id\" IN ("
        for i in range(len(self.list_ids['connec'])):
            expr_filter += f"'{self.list_ids['connec'][i]}', "
        expr_filter = expr_filter[:-2] + ")"
        if len(self.list_ids['connec']) == 0:
            expr_filter = "\"connec_id\" =''"
        # Check expression
        (is_valid, expr) = tools_qt.check_expression_filter(expr_filter)  # @UnusedVariable
        if not is_valid:
            return

        self._reload_table_hydro(expr_filter)


    def _snapping_selection_connec(self):
        """ Snap to connec layers """

        self.list_ids['connec'] = []

        for layer in self.layers_connec:
            if layer.selectedFeatureCount() > 0:
                # Get selected features of the layer
                features = layer.selectedFeatures()
                # Get id from all selected features
                for feature in features:
                    connec_id = feature.attribute("connec_id")
                    # Add element
                    if connec_id not in self.list_ids['connec']:
                        self.list_ids['connec'].append(connec_id)

        expr_filter = None
        if len(self.list_ids['connec']) > 0:
            # Set 'expr_filter' with features that are in the list
            expr_filter = "\"connec_id\" IN ("
            for i in range(len(self.list_ids['connec'])):
                expr_filter += f"'{self.list_ids['connec'][i]}', "
            expr_filter = expr_filter[:-2] + ")"
            if len(self.list_ids['connec']) == 0:
                expr_filter = "\"connec_id\" =''"
            # Check expression
            (is_valid, expr) = tools_qt.check_expression_filter(expr_filter)  # @UnusedVariable
            if not is_valid:
                return

        self._reload_table_connec(expr_filter)


    def _add_hydrometer(self):
        """ B4-122: Hydrometer selector """

        self.mincut_class = 3
        self.dlg_mincut.closeMainWin = True
        self.dlg_mincut.canceled = False
        self.list_ids['connec'] = []
        result_mincut_id_text = self.dlg_mincut.result_mincut_id.text()

        # Check if id exist in table 'om_mincut'
        sql = (f"SELECT id FROM om_mincut"
               f" WHERE id = '{result_mincut_id_text}';")
        exist_id = tools_db.get_row(sql)
        if not exist_id:
            sql = (f"INSERT INTO om_mincut (id, mincut_class)"
                   f" VALUES ('{result_mincut_id_text}', 3);")
            tools_db.execute_sql(sql)
            self.is_new = False

        # On inserting work order
        self.action_mincut.setDisabled(True)
        self.action_refresh_mincut.setDisabled(True)
        self.action_custom_mincut.setDisabled(True)
        self.action_change_valve_status.setDisabled(True)
        self.action_add_connec.setDisabled(True)

        # Set dialog MincutHydrometer
        self.dlg_hydro = GwMincutHydrometerUi()
        tools_gw.load_settings(self.dlg_hydro)
        self.dlg_hydro.setWindowTitle("Hydrometer management")
        self.dlg_hydro.tbl_hydro.setSelectionBehavior(QAbstractItemView.SelectRows)
        # self.dlg_hydro.btn_snapping.setEnabled(False)

        # Set icons
        tools_gw.add_icon(self.dlg_hydro.btn_insert, "111")
        tools_gw.add_icon(self.dlg_hydro.btn_delete, "112")

        # Set dignals
        self.dlg_hydro.btn_insert.clicked.connect(partial(self._insert_hydro))
        self.dlg_hydro.btn_delete.clicked.connect(partial(self._delete_records_hydro))
        self.dlg_hydro.btn_accept.clicked.connect(partial(self._accept_hydro, self.dlg_hydro, "hydrometer"))

        # Set autocompleter for 'customer_code'
        self._set_completer_customer_code(self.dlg_hydro.customer_code_connec, True)

        # Set signal to reach selected value from QCompleter
        if exist_id:
            # Read selection and reload table
            self._select_features_hydro()

        tools_gw.open_dialog(self.dlg_hydro, dlg_name='mincut_hydrometer')


    def _auto_fill_hydro_id(self):

        # Adding auto-completion to a QLineEdit - hydrometer_id
        self.completer_hydro = QCompleter()
        self.dlg_hydro.hydrometer_cc.setCompleter(self.completer_hydro)
        model = QStringListModel()

        # Get 'connec_id' from 'customer_code'
        customer_code = str(self.dlg_hydro.customer_code_connec.text())
        connec_id = self._get_connec_id_from_customer_code(customer_code)
        if connec_id is None:
            return

        # Get 'hydrometers' related with this 'connec'
        sql = (f"SELECT DISTINCT(hydrometer_customer_code)"
               f" FROM v_rtc_hydrometer"
               f" WHERE connec_id = '{connec_id}'")
        rows = tools_db.get_rows(sql)
        values = []
        for row in rows:
            values.append(str(row[0]))

        model.setStringList(values)
        self.completer_hydro.setModel(model)


    def _insert_hydro(self):
        """ Select feature with entered id. Set a model with selected filter.
            Attach that model to selected table 
        """

        # Check if user entered hydrometer_id
        hydrometer_cc = tools_qt.get_text(self.dlg_hydro, self.dlg_hydro.hydrometer_cc)
        if hydrometer_cc == "null":
            message = "You need to enter hydrometer_id"
            tools_qt.show_info_box(message)
            return

        # Show message if element is already in the list
        if hydrometer_cc in self.hydro_list:
            message = "Selected element already in the list"
            tools_qt.show_info_box(message, parameter=hydrometer_cc)
            return

        # Check if hydrometer_id belongs to any 'connec_id'
        sql = (f"SELECT hydrometer_id FROM v_rtc_hydrometer"
               f" WHERE hydrometer_customer_code = '{hydrometer_cc}'")
        row = tools_db.get_row(sql, log_sql=False)
        if not row:
            message = "Selected hydrometer_id not found"
            tools_qt.show_info_box(message, parameter=hydrometer_cc)
            return

        if row[0] in self.hydro_list:
            message = "Selected element already in the list"
            tools_qt.show_info_box(message, parameter=hydrometer_cc)
            return

        # Set expression filter with 'hydro_list'

        if row[0] in self.deleted_list:
            self.deleted_list.remove(row[0])
        self.hydro_list.append(row[0])
        expr_filter = "\"hydrometer_id\" IN ("
        for i in range(len(self.hydro_list)):
            expr_filter += f"'{self.hydro_list[i]}', "
        expr_filter = expr_filter[:-2] + ")"

        # Reload table
        self._reload_table_hydro(expr_filter)


    def _select_features_group_layers(self, expr):
        """ Select features of the layers filtering by @expr """

        # Iterate over all layers of type 'connec'
        # Select features and them to 'connec_list'
        for layer in self.layers_connec:
            it = layer.getFeatures(QgsFeatureRequest(expr))
            # Build a list of feature id's from the previous result
            id_list = [i.id() for i in it]
            # Select features with these id's
            layer.selectByIds(id_list)
            if layer.selectedFeatureCount() > 0:
                # Get selected features of the layer
                features = layer.selectedFeatures()
                for feature in features:
                    connec_id = feature.attribute("connec_id")
                    # Check if 'connec_id' is already in 'connec_list'
                    if connec_id not in self.list_ids['connec']:
                        self.list_ids['connec'].append(connec_id)


    def _select_features_connec(self):
        """ Select features of 'connec' of selected mincut """

        # Set 'expr_filter' of connecs related with current mincut
        result_mincut_id = tools_qt.get_text(self.dlg_mincut, self.dlg_mincut.result_mincut_id)
        sql = (f"SELECT connec_id FROM om_mincut_connec"
               f" WHERE result_id = {result_mincut_id}")
        rows = tools_db.get_rows(sql)

        expr_filter = "\"connec_id\" IN ("
        if rows:
            for row in rows:
                if row[0] not in self.list_ids['connec'] and row[0] not in self.deleted_list:
                    self.list_ids['connec'].append(row[0])

        if self.list_ids['connec']:
            for connec_id in self.list_ids['connec']:
                expr_filter += f"'{connec_id}', "
            expr_filter = expr_filter[:-2] + ")"
            if len(self.list_ids['connec']) == 0:
                expr_filter = "\"connec_id\" =''"
            # Check expression
            (is_valid, expr) = tools_qt.check_expression_filter(expr_filter)
            if not is_valid:
                return

            # Select features of the layers filtering by @expr
            self._select_features_group_layers(expr)

            # Reload table
            self._reload_table_connec(expr_filter)


    def _select_features_hydro(self):

        self.list_ids['connec'] = []

        # Set 'expr_filter' of connecs related with current mincut
        result_mincut_id = tools_qt.get_text(self.dlg_hydro, self.result_mincut_id)
        sql = (f"SELECT DISTINCT(connec_id) FROM rtc_hydrometer_x_connec AS rtc"
               f" INNER JOIN om_mincut_hydrometer AS anl"
               f" ON anl.hydrometer_id = rtc.hydrometer_id"
               f" WHERE result_id = {result_mincut_id}")
        rows = tools_db.get_rows(sql)
        if rows:
            expr_filter = "\"connec_id\" IN ("
            for row in rows:
                expr_filter += f"'{row[0]}', "
            expr_filter = expr_filter[:-2] + ")"
            if len(self.list_ids['connec']) == 0:
                expr_filter = "\"connec_id\" =''"
            # Check expression
            (is_valid, expr) = tools_qt.check_expression_filter(expr_filter)
            if not is_valid:
                return

            # Select features of the layers filtering by @expr
            self._select_features_group_layers(expr)

        # Get list of 'hydrometer_id' belonging to current result_mincut
        result_mincut_id = tools_qt.get_text(self.dlg_hydro, self.result_mincut_id)
        sql = (f"SELECT hydrometer_id FROM om_mincut_hydrometer"
               f" WHERE result_id = {result_mincut_id}")
        rows = tools_db.get_rows(sql)

        expr_filter = "\"hydrometer_id\" IN ("
        if rows:
            for row in rows:
                if row[0] not in self.hydro_list:
                    self.hydro_list.append(row[0])
        for hyd in self.deleted_list:
            if hyd in self.hydro_list:
                self.hydro_list.remove(hyd)
        for hyd in self.hydro_list:
            expr_filter += f"'{hyd}', "

        expr_filter = expr_filter[:-2] + ")"
        if len(self.hydro_list) == 0:
            expr_filter = "\"hydrometer_id\" =''"
        # Reload contents of table 'hydro' with expr_filter
        self._reload_table_hydro(expr_filter)


    def _insert_connec(self):
        """ Select feature with entered id. Set a model with selected filter.
            Attach that model to selected table 
        """

        tools_qgis.disconnect_signal_selection_changed()

        # Get 'connec_id' from selected 'customer_code'
        customer_code = tools_qt.get_text(self.dlg_connec, self.dlg_connec.connec_id)
        if customer_code == 'null':
            message = "You need to enter a customer code"
            tools_qt.show_info_box(message)
            return

        connec_id = self._get_connec_id_from_customer_code(customer_code)
        if connec_id is None:
            return

        # Iterate over all layers
        for layer in self.layers_connec:
            if layer.selectedFeatureCount() > 0:
                # Get selected features of the layer
                features = layer.selectedFeatures()
                for feature in features:
                    # Append 'connec_id' into 'connec_list'
                    selected_id = feature.attribute("connec_id")
                    if selected_id not in self.list_ids['connec']:
                        self.list_ids['connec'].append(selected_id)

        # Show message if element is already in the list
        if connec_id in self.list_ids['connec']:
            message = "Selected element already in the list"
            tools_qt.show_info_box(message, parameter=connec_id)
            return

        # If feature id doesn't exist in list -> add
        self.list_ids['connec'].append(connec_id)

        expr_filter = None
        if len(self.list_ids['connec']) > 0:

            # Set expression filter with 'connec_list'
            expr_filter = "\"connec_id\" IN ("
            for i in range(len(self.list_ids['connec'])):
                expr_filter += f"'{self.list_ids['connec'][i]}', "
            expr_filter = expr_filter[:-2] + ")"
            if len(self.list_ids['connec']) == 0:
                expr_filter = "\"connec_id\" =''"
            # Check expression
            (is_valid, expr) = tools_qt.check_expression_filter(expr_filter)
            if not is_valid:
                return

            # Select features with previous filter
            for layer in self.layers_connec:
                # Build a list of feature id's and select them
                it = layer.getFeatures(QgsFeatureRequest(expr))
                id_list = [i.id() for i in it]
                layer.selectByIds(id_list)

        # Reload contents of table 'connec'
        self._reload_table_connec(expr_filter)

        self.connect_signal_selection_changed("mincut_connec")


    def _get_connec_id_from_customer_code(self, customer_code):
        """ Get 'connec_id' from @customer_code """

        sql = (f"SELECT connec_id FROM v_edit_connec"
               f" WHERE customer_code = '{customer_code}'")
        row = tools_db.get_row(sql)
        if not row:
            message = "Any connec_id found with this customer_code"
            tools_qt.show_info_box(message, parameter=customer_code)
            return None
        else:
            return str(row[0])


    def _reload_table_connec(self, expr_filter=None):
        """ Reload contents of table 'connec' with selected @expr_filter """

        expr = tools_qt.set_table_model(self.dlg_connec, 'tbl_mincut_connec', "connec", expr_filter)
        tools_gw.set_tablemodel_config(self.dlg_connec, 'tbl_mincut_connec', 'v_edit_connec')
        return expr


    def _reload_table_hydro(self, expr_filter=None):
        """ Reload contents of table 'hydro' """

        expr = tools_qt.set_table_model(self.dlg_hydro, "tbl_hydro", "v_rtc_hydrometer", expr_filter)
        tools_gw.set_tablemodel_config(self.dlg_hydro, "tbl_hydro", 'v_rtc_hydrometer')
        return expr


    def _delete_records_connec(self):
        """ Delete selected rows of the table """

        tools_qgis.disconnect_signal_selection_changed()

        # Get selected rows
        widget = self.dlg_connec.tbl_mincut_connec
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return

        del_id = []
        inf_text = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            # Id to delete
            id_feature = widget.model().record(row).value("connec_id")
            del_id.append(id_feature)
            # Id to ask
            customer_code = widget.model().record(row).value("customer_code")
            inf_text += str(customer_code) + ", "
        inf_text = inf_text[:-2]
        message = "Are you sure you want to delete these records?"
        title = "Delete records"
        answer = tools_qt.show_question(message, title, inf_text)

        if not answer:
            return
        else:
            for el in del_id:
                self.list_ids['connec'].remove(el)

        # Select features which are in the list
        expr_filter = "\"connec_id\" IN ("
        for i in range(len(self.list_ids['connec'])):
            expr_filter += f"'{self.list_ids['connec'][i]}', "
        expr_filter = expr_filter[:-2] + ")"

        if len(self.list_ids['connec']) == 0:
            expr_filter = "connec_id=''"

        # Update model of the widget with selected expr_filter
        expr = self._reload_table_connec(expr_filter)

        # Reload selection
        for layer in self.layers_connec:
            # Build a list of feature id's and select them
            it = layer.getFeatures(QgsFeatureRequest(expr))
            id_list = [i.id() for i in it]
            layer.selectByIds(id_list)

        self.connect_signal_selection_changed("mincut_connec")


    def _delete_records_hydro(self):
        """ Delete selected rows of the table """

        # Get selected rows
        widget = self.dlg_hydro.tbl_hydro
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return

        del_id = []
        inf_text = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_feature = widget.model().record(row).value("hydrometer_customer_code")
            hydro_id = widget.model().record(row).value("hydrometer_id")
            inf_text += str(id_feature) + ", "
            del_id.append(hydro_id)
        inf_text = inf_text[:-2]
        message = "Are you sure you want to delete these records?"
        title = "Delete records"
        answer = tools_qt.show_question(message, title, inf_text)

        if not answer:
            return
        else:
            for el in del_id:
                self.hydro_list.remove(el)
                if el not in self.deleted_list:
                    self.deleted_list.append(el)
        # Select features that are in the list
        expr_filter = "\"hydrometer_id\" IN ("
        for i in range(len(self.hydro_list)):
            expr_filter += f"'{self.hydro_list[i]}', "
        expr_filter = expr_filter[:-2] + ")"

        if len(self.hydro_list) == 0:
            expr_filter = "hydrometer_id=''"

        # Update model of the widget with selected expr_filter
        self._reload_table_hydro(expr_filter)

        self.connect_signal_selection_changed("mincut_hydro")


    def _accept_connec(self, dlg, element):
        """ Slot function widget 'btn_accept' of 'connec' dialog 
            Insert into table 'om_mincut_connec' values of current mincut
        """

        result_mincut_id = tools_qt.get_text(dlg, self.dlg_mincut.result_mincut_id)
        if result_mincut_id == 'null':
            return

        sql = (f"DELETE FROM om_mincut_{element}"
               f" WHERE result_id = {result_mincut_id};\n")
        for element_id in self.list_ids['connec']:
            sql += (f"INSERT INTO om_mincut_{element}"
                    f" (result_id, {element}_id) "
                    f" VALUES ('{result_mincut_id}', '{element_id}');\n")
            # Get hydrometer_id of selected connec
            sql2 = (f"SELECT hydrometer_id FROM v_rtc_hydrometer"
                    f" WHERE connec_id = '{element_id}'")
            rows = tools_db.get_rows(sql2)
            if rows:
                for row in rows:
                    # Hydrometers associated to selected connec inserted to the table om_mincut_hydrometer
                    sql += (f"INSERT INTO om_mincut_hydrometer"
                            f" (result_id, hydrometer_id) "
                            f" VALUES ('{result_mincut_id}', '{row[0]}');\n")

        self.sql_connec = sql
        self.dlg_mincut.btn_start.setDisabled(False)
        tools_gw.close_dialog(self.dlg_connec)


    def _accept_hydro(self, dlg, element):
        """ Slot function widget 'btn_accept' of 'hydrometer' dialog 
            Insert into table 'om_mincut_hydrometer' values of current mincut
        """

        result_mincut_id = tools_qt.get_text(dlg, self.dlg_mincut.result_mincut_id)
        if result_mincut_id == 'null':
            return

        sql = (f"DELETE FROM om_mincut_{element}"
               f" WHERE result_id = {result_mincut_id};\n")
        for element_id in self.hydro_list:
            sql += (f"INSERT INTO om_mincut_{element}"
                    f" (result_id, {element}_id) "
                    f" VALUES ('{result_mincut_id}', '{element_id}');\n")

        self.sql_hydro = sql
        self.dlg_mincut.btn_start.setDisabled(False)
        tools_gw.close_dialog(self.dlg_hydro)


    def _auto_mincut(self):
        """ B1-126: Automatic mincut analysis """

        self.mincut_class = 1
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)

        # Snapper
        self.snapper_manager = GwSnapManager(self.iface)
        self.snapper = self.snapper_manager.get_snapper()

        self._init_mincut_canvas()
        self.dlg_mincut.closeMainWin = True
        self.dlg_mincut.canceled = False

        # Vertex marker
        self.vertex_marker = self.snapper_manager.vertex_marker

        # On inserting work order
        self.action_add_connec.setDisabled(True)
        self.action_add_hydrometer.setDisabled(True)

        # Store user snapping configuration
        self.previous_snapping = self.snapper_manager.get_snapping_options()

        # Set signals
        self.canvas.xyCoordinates.connect(self._mouse_move_node_arc)
        self.emit_point.canvasClicked.connect(self._auto_mincut_snapping)


    def _mouse_move_node_arc(self, point):

        if not self.layer_arc:
            return

        # Set active layer
        self.iface.setActiveLayer(self.layer_arc)

        # Get clicked point
        self.vertex_marker.hide()
        event_point = self.snapper_manager.get_event_point(point=point)

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if result.isValid():
            layer = self.snapper_manager.get_snapped_layer(result)
            # Check feature
            viewname = tools_qgis.get_layer_source_table_name(layer)
            if viewname == 'v_edit_arc':
                self.snapper_manager.add_marker(result, self.vertex_marker)


    def _auto_mincut_snapping(self, point, btn):
        """ Automatic mincut: Snapping to 'node' and 'arc' layers """

        if btn == Qt.RightButton:
            if btn == Qt.RightButton:
                self.action_mincut.setChecked(False)
                tools_qgis.disconnect_snapping(False, self.emit_point, self.vertex_marker)
                return

        # Get coordinates
        event_point = self.snapper_manager.get_event_point(point=point)

        # Set active and current layer
        self.layer_arc = tools_qgis.get_layer_by_tablename("v_edit_arc")
        self.iface.setActiveLayer(self.layer_arc)
        self.current_layer = self.layer_arc

        # Snapping
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if not result.isValid():
            return

        # Check feature
        elem_type = None
        layer = self.snapper_manager.get_snapped_layer(result)
        if layer == self.layer_arc:
            elem_type = 'arc'

        if elem_type:
            # Get the point. Leave selection
            snapped_feat = self.snapper_manager.get_snapped_feature(result)
            feature_id = self.snapper_manager.get_snapped_feature_id(result)
            snapped_point = self.snapper_manager.get_snapped_point(result)
            element_id = snapped_feat.attribute(f'{elem_type}_id')
            layer.select([feature_id])
            description = "Mincut execute"
            self.mincut_task = GwAutoMincutTask(description, self, element_id)

            QgsApplication.taskManager().addTask(self.mincut_task)
            QgsApplication.taskManager().triggerTask(self.mincut_task)
            self.mincut_task.task_finished.connect(
                partial(self._mincut_task_finished, snapped_point, elem_type, element_id))


    def _cancel_task(self):
        """ Cancel GwAutoMincutTask """

        self.action_mincut.setChecked(False)
        tools_qgis.disconnect_snapping(False, self.emit_point, self.vertex_marker)
        self.mincut_task.cancel()


    # noinspection PyUnusedLocal
    def _snapping_node_arc_real_location(self, point, btn):

        # Get coordinates
        event_point = self.snapper_manager.get_event_point(point=point)

        result_mincut_id_text = self.dlg_mincut.result_mincut_id.text()
        srid = global_vars.srid

        sql = (f"UPDATE om_mincut"
               f" SET exec_the_geom = ST_SetSRID(ST_Point({point.x()}, {point.y()}), {srid})"
               f" WHERE id = '{result_mincut_id_text}'")
        status = tools_db.execute_sql(sql)
        if status:
            message = "Real location has been updated"
            tools_qgis.show_info(message)

        # Snapping
        result = self.snapper_manager.snap_to_project_config_layers(event_point)
        if not result.isValid():
            return

        tools_qgis.disconnect_snapping(False, self.emit_point, self.vertex_marker)

        layer = self.snapper_manager.get_snapped_layer(result)

        # Check feature
        layers_arc = tools_gw.get_layers_from_feature_type('arc')
        self.layernames_arc = []
        for layer in layers_arc:
            self.layernames_arc.append(layer.name())

        element_type = layer.name()
        if element_type in self.layernames_arc:
            self.snapper_manager.get_snapped_feature(result, True)


    def _mincut_task_finished(self, snapped_point, elem_type, element_id, signal):

        if not signal[0]:
            return False
        elif signal[1]:
            complet_result = signal[1]
            real_mincut_id = tools_qt.get_text(self.dlg_mincut, self.dlg_mincut.result_mincut_id)
            if 'mincutOverlap' in complet_result and complet_result['mincutOverlap'] != "":
                message = "Mincut done, but has conflict and overlaps with"
                tools_qt.show_info_box(message, parameter=complet_result['mincutOverlap'])
            else:
                message = "Mincut done successfully"
                tools_qgis.show_info(message)

            # Zoom to rectangle (zoom to mincut)
            polygon = complet_result['body']['data']['geometry']
            polygon = polygon[9:len(polygon) - 2]
            polygon = polygon.split(',')
            if polygon[0] == '':
                message = "Error on create auto mincut, you need to review data"
                tools_qgis.show_warning(message)
                tools_qgis.restore_cursor()
                return
            x1, y1 = polygon[0].split(' ')
            x2, y2 = polygon[2].split(' ')
            tools_qgis.zoom_to_rectangle(x1, y1, x2, y2, margin=0)
            sql = (f"UPDATE om_mincut"
                   f" SET mincut_class = 1, "
                   f" anl_the_geom = ST_SetSRID(ST_Point({snapped_point.x()}, "
                   f"{snapped_point.y()}), {global_vars.srid}),"
                   f" anl_user = current_user, anl_feature_type = '{elem_type.upper()}',"
                   f" anl_feature_id = '{element_id}'"
                   f" WHERE id = '{real_mincut_id}'")
            status = tools_db.execute_sql(sql)
            if not status:
                message = "Error updating element in table, you need to review data"
                tools_qgis.show_warning(message)
                tools_qgis.restore_cursor()
                return

            # Enable button CustomMincut, ChangeValveStatus and button Start
            self.dlg_mincut.btn_start.setDisabled(False)
            self.action_refresh_mincut.setDisabled(False)
            self.action_custom_mincut.setDisabled(False)
            self.action_change_valve_status.setDisabled(False)
            self.action_mincut.setDisabled(False)
            self.action_add_connec.setDisabled(True)
            self.action_add_hydrometer.setDisabled(True)
            self.action_mincut_composer.setDisabled(False)
            # Update table 'selector_mincut_result'
            sql = (f"DELETE FROM selector_mincut_result WHERE cur_user = current_user;\n"
                   f"INSERT INTO selector_mincut_result (cur_user, result_id) VALUES"
                   f" (current_user, {real_mincut_id});")
            tools_db.execute_sql(sql, log_error=True)
            # Refresh map canvas
            tools_qgis.refresh_map_canvas()

        # Disconnect snapping and related signals
        tools_qgis.disconnect_snapping(False, self.emit_point, self.vertex_marker)
        self.set_visible_mincut_layers()
        self.snapper_manager.restore_snap_options(self.previous_snapping)
        self._remove_selection()


    def _refresh_mincut(self, action, is_checked):
        """ B2-125: Refreash current mincut """


    def _custom_mincut(self, action, is_checked):
        """ B2-123: Custom mincut analysis. Working just with valve layer """

        # Get Snapper manager
        self.snapper_manager = GwSnapManager(self.iface)

        # Get Emit point and set canvas maptool
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)

        if is_checked is False:
            # Disconnect snapping and related signals
            tools_qgis.disconnect_snapping(False, self.emit_point, self.vertex_marker)
            # Recover snapping options, refresh canvas & set visible layers
            self.snapper_manager.recover_snapping_options()
            return

        # Disconnect other snapping and signals in case wrong user clicks
        tools_qgis.disconnect_snapping(False, self.emit_point, self.vertex_marker)

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Set vertex marker propierties
        self.vertex_marker = self.snapper_manager.vertex_marker

        # Set active and current layer
        self.layer = tools_qgis.get_layer_by_tablename("v_om_mincut_valve")
        self.iface.setActiveLayer(self.layer)
        self.current_layer = self.layer

        # Waiting for signals
        self.canvas.xyCoordinates.connect(self._mouse_move_valve)
        self.emit_point.canvasClicked.connect(partial(self._custom_mincut_snapping, action))


    def _mouse_move_valve(self, point):
        """ Waiting for valves when mouse is moved"""

        # Get clicked point and add marker
        event_point = self.snapper_manager.get_event_point(point=point)
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if result.isValid():
            self.snapper_manager.add_marker(result, self.vertex_marker)


    # noinspection PyUnusedLocal
    def _custom_mincut_snapping(self, action, point, btn):
        """ Custom mincut snapping function """

        # Get clicked point
        event_point = self.snapper_manager.get_event_point(point=point)
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if result.isValid():
            # Get the point. Leave selection
            snapped_feat = self.snapper_manager.get_snapped_feature(result, True)
            element_id = snapped_feat.attribute('node_id')
            if action.objectName() == "actionCustomMincut":
                self._custom_mincut_execute(element_id)
            elif action.objectName() == "actionChangeValveStatus":
                self._change_valve_status_execute(element_id)
            self.snapper_manager.recover_snapping_options()
            tools_qgis.refresh_map_canvas(True)
            self.set_visible_mincut_layers()
            self._remove_selection()
            action.setChecked(False)


    def _custom_mincut_execute(self, elem_id):
        """ Custom mincut. Execute function 'gw_fct_mincut_valve_unaccess' """

        # Change cursor to 'WaitCursor'
        tools_qgis.set_cursor_wait()

        result_mincut_id = tools_qt.get_text(self.dlg_mincut, "result_mincut_id")
        if result_mincut_id != 'null':
            extras = f'"action":"mincutValveUnaccess", "nodeId":{elem_id}, "mincutId":"{result_mincut_id}"'
            body = tools_gw.create_body(extras=extras)
            result = tools_gw.execute_procedure('gw_fct_setmincut', body)
            if result['status'] == 'Accepted' and result['message']:
                level = int(result['message']['level']) if 'level' in result['message'] else 1
                tools_qgis.show_message(result['message']['text'], level)

        # Disconnect snapping and related signals
        tools_qgis.disconnect_snapping(False, self.emit_point, self.vertex_marker)


    def _remove_selection(self):
        """ Remove selected features of all layers """

        for layer in self.canvas.layers():
            if type(layer) is QgsVectorLayer:
                layer.removeSelection()
        self.canvas.refresh()

        for a in self.iface.attributesToolBar().actions():
            if a.objectName() == 'mActionDeselectAll':
                a.trigger()
                break


    def _open_mincut_manage_dates(self, row):
        """ Management of null values in fields of type date """

        self._manage_date(row['anl_tstamp'], "cbx_recieved_day", "cbx_recieved_time")
        self._manage_date(row['forecast_start'], "cbx_date_start_predict", "cbx_hours_start_predict")
        self._manage_date(row['forecast_end'], "cbx_date_end_predict", "cbx_hours_end_predict")
        self._manage_date(row['exec_start'], "cbx_date_start", "cbx_hours_start")
        self._manage_date(row['exec_end'], "cbx_date_end", "cbx_hours_end")


    def _manage_date(self, date_value, widget_date, widget_time):
        """ Manage date of current field """

        if date_value:
            date_time = (str(date_value))
            date = str(date_time.split()[0])
            time = str(date_time.split()[1])
            if date:
                date = date.replace('/', '-')
            qt_date = QDate.fromString(date, 'yyyy-MM-dd')
            qt_time = QTime.fromString(time, 'h:mm:ss')
            tools_qt.set_calendar(self.dlg_mincut, widget_date, qt_date)
            tools_qt.set_time(self.dlg_mincut, widget_time, qt_time)


    def _mincut_composer(self):
        """ Open Composer """

        # Check if path exist
        template_folder = ""
        row = tools_gw.get_config_value('qgis_composers_folderpath')
        if row:
            template_folder = row[0]

        try:
            template_files = os.listdir(template_folder)
        except FileNotFoundError:
            message = "Your composer's path is bad configured. Please, modify it and try again."
            tools_qgis.show_message(message, 1)
            return

        # Set dialog add_connec
        self.dlg_comp = GwMincutComposerUi()
        tools_gw.load_settings(self.dlg_comp)

        # Fill ComboBox cbx_template with templates *.qpt
        self.files_qpt = [i for i in template_files if i.endswith('.qpt')]
        self.dlg_comp.cbx_template.clear()
        self.dlg_comp.cbx_template.addItem('')
        for template in self.files_qpt:
            self.dlg_comp.cbx_template.addItem(str(template))

        # Set signals
        self.dlg_comp.btn_ok.clicked.connect(self._open_composer)
        self.dlg_comp.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_comp))
        self.dlg_comp.rejected.connect(partial(tools_gw.close_dialog, self.dlg_comp))
        self.dlg_comp.cbx_template.currentIndexChanged.connect(self._set_template)

        # Open dialog
        tools_gw.open_dialog(self.dlg_comp, dlg_name='mincut_composer')


    def _set_template(self):

        template = self.dlg_comp.cbx_template.currentText()
        self.template = template[:-4]


    def _open_composer(self):

        # Check if template is selected
        if str(self.dlg_comp.cbx_template.currentText()) == "":
            message = "You need to select a template"
            tools_qgis.show_warning(message)
            return

        # Check if template file exists
        template_path = ""
        row = tools_gw.get_config_value('qgis_composers_folderpath')
        if row:
            template_path = row[0] + f'{os.sep}{self.template}.qpt'

        if not os.path.exists(template_path):
            message = "File not found"
            tools_qgis.show_warning(message, parameter=template_path)
            return

        # Check if composer exist
        composers = tools_qgis.get_composers_list()
        index = tools_qgis.get_composer_index(str(self.template))

        # Composer not found
        if index == len(composers):

            # Create new composer with template selected in combobox(self.template)
            template_file = open(template_path, 'rt')
            template_content = template_file.read()
            template_file.close()
            document = QDomDocument()
            document.setContent(template_content)

            project = QgsProject.instance()
            comp_view = QgsPrintLayout(project)
            comp_view.loadFromTemplate(document, QgsReadWriteContext())

            layout_manager = project.layoutManager()
            layout_manager.addLayout(comp_view)

        else:
            comp_view = composers[index]

        # Manage mincut layout
        self._manage_mincut_layout(comp_view)


    def _manage_mincut_layout(self, layout):
        """ Manage mincut layout """

        if layout is None:
            tools_log.log_warning("Layout not found")
            return

        title = self.dlg_comp.title.text()
        try:
            rotation = float(self.dlg_comp.rotation.text())
        except ValueError:
            rotation = 0

        # Show layout
        self.iface.openLayoutDesigner(layout)

        # Zoom map to extent, rotation, title
        map_item = layout.itemById('Mapa')
        map_item.zoomToExtent(self.canvas.extent())
        map_item.setMapRotation(rotation)
        profile_title = layout.itemById('title')
        profile_title.setText(str(title))

        # Refresh items
        layout.refresh()
        layout.updateBounds()


    def _enable_widgets(self, state):
        """ Enable/Disable widget depending @state """

        # Planified
        if state == '0':

            self.dlg_mincut.work_order.setDisabled(False)
            # Group Location
            self.dlg_mincut.address_add_muni.setDisabled(False)
            self.dlg_mincut.address_add_street.setDisabled(False)
            self.dlg_mincut.address_add_postnumber.setDisabled(False)
            # Group Details
            self.dlg_mincut.type.setDisabled(False)
            self.dlg_mincut.cause.setDisabled(False)
            self.dlg_mincut.cbx_recieved_day.setDisabled(False)
            self.dlg_mincut.cbx_recieved_time.setDisabled(False)
            # Group Prediction
            self.dlg_mincut.cbx_date_start_predict.setDisabled(False)
            self.dlg_mincut.cbx_hours_start_predict.setDisabled(False)
            self.dlg_mincut.cbx_date_end_predict.setDisabled(False)
            self.dlg_mincut.cbx_hours_end_predict.setDisabled(False)
            self.dlg_mincut.assigned_to.setDisabled(False)
            self.dlg_mincut.pred_description.setDisabled(False)
            # Group Real Details
            self.dlg_mincut.cbx_date_start.setDisabled(True)
            self.dlg_mincut.cbx_hours_start.setDisabled(True)
            self.dlg_mincut.cbx_date_end.setDisabled(True)
            self.dlg_mincut.cbx_hours_end.setDisabled(True)
            self.dlg_mincut.distance.setDisabled(True)
            self.dlg_mincut.depth.setDisabled(True)
            self.dlg_mincut.appropiate.setDisabled(True)
            self.dlg_mincut.real_description.setDisabled(True)
            self.dlg_mincut.btn_start.setDisabled(True)
            self.dlg_mincut.btn_end.setDisabled(True)
            # Actions
            self.action_mincut.setDisabled(False)
            self.action_refresh_mincut.setDisabled(True)
            self.action_custom_mincut.setDisabled(True)
            self.action_change_valve_status.setDisabled(True)
            self.action_add_connec.setDisabled(False)
            self.action_add_hydrometer.setDisabled(False)

        # In Progess
        elif state == '1':

            self.dlg_mincut.work_order.setDisabled(True)
            # Group Location
            self.dlg_mincut.address_add_muni.setDisabled(True)
            self.dlg_mincut.address_add_street.setDisabled(True)
            self.dlg_mincut.address_add_postnumber.setDisabled(True)
            # Group Details
            self.dlg_mincut.type.setDisabled(True)
            self.dlg_mincut.cause.setDisabled(True)
            self.dlg_mincut.cbx_recieved_day.setDisabled(True)
            self.dlg_mincut.cbx_recieved_time.setDisabled(True)
            # Group Prediction dates
            self.dlg_mincut.cbx_date_start_predict.setDisabled(True)
            self.dlg_mincut.cbx_hours_start_predict.setDisabled(True)
            self.dlg_mincut.cbx_date_end_predict.setDisabled(True)
            self.dlg_mincut.cbx_hours_end_predict.setDisabled(True)
            self.dlg_mincut.assigned_to.setDisabled(True)
            self.dlg_mincut.pred_description.setDisabled(True)
            # Group Real dates
            self.dlg_mincut.cbx_date_start.setDisabled(False)
            self.dlg_mincut.cbx_hours_start.setDisabled(False)
            self.dlg_mincut.cbx_date_end.setDisabled(False)
            self.dlg_mincut.cbx_hours_end.setDisabled(False)
            self.dlg_mincut.distance.setDisabled(False)
            self.dlg_mincut.depth.setDisabled(False)
            self.dlg_mincut.appropiate.setDisabled(False)
            self.dlg_mincut.real_description.setDisabled(False)
            self.dlg_mincut.btn_start.setDisabled(True)
            self.dlg_mincut.btn_end.setDisabled(False)
            # Actions
            self.action_mincut.setDisabled(True)
            self.action_refresh_mincut.setDisabled(True)
            self.action_custom_mincut.setDisabled(True)
            self.action_change_valve_status.setDisabled(True)
            self.action_add_connec.setDisabled(False)
            self.action_add_hydrometer.setDisabled(False)

        # Finished
        elif state == '2':

            self.dlg_mincut.work_order.setDisabled(True)
            # Group Location
            self.dlg_mincut.address_add_muni.setDisabled(True)
            self.dlg_mincut.address_add_street.setDisabled(True)
            self.dlg_mincut.address_add_postnumber.setDisabled(True)
            # Group Details
            self.dlg_mincut.type.setDisabled(True)
            self.dlg_mincut.cause.setDisabled(True)
            self.dlg_mincut.cbx_recieved_day.setDisabled(True)
            self.dlg_mincut.cbx_recieved_time.setDisabled(True)
            # Group Prediction dates
            self.dlg_mincut.cbx_date_start_predict.setDisabled(True)
            self.dlg_mincut.cbx_hours_start_predict.setDisabled(True)
            self.dlg_mincut.cbx_date_end_predict.setDisabled(True)
            self.dlg_mincut.cbx_hours_end_predict.setDisabled(True)
            self.dlg_mincut.assigned_to.setDisabled(True)
            self.dlg_mincut.pred_description.setDisabled(True)
            # Group Real dates
            self.dlg_mincut.cbx_date_start.setDisabled(True)
            self.dlg_mincut.cbx_hours_start.setDisabled(True)
            self.dlg_mincut.cbx_date_end.setDisabled(True)
            self.dlg_mincut.cbx_hours_end.setDisabled(True)
            self.dlg_mincut.distance.setDisabled(True)
            self.dlg_mincut.depth.setDisabled(True)
            self.dlg_mincut.appropiate.setDisabled(True)
            self.dlg_mincut.real_description.setDisabled(True)
            self.dlg_mincut.btn_start.setDisabled(True)
            self.dlg_mincut.btn_end.setDisabled(True)
            # Actions
            self.action_mincut.setDisabled(True)
            self.action_refresh_mincut.setDisabled(True)
            self.action_custom_mincut.setDisabled(True)
            self.action_change_valve_status.setDisabled(True)
            self.action_add_connec.setDisabled(True)
            self.action_add_hydrometer.setDisabled(True)


    def _change_valve_status(self, action, is_checked):
        """ Change status of selected valve. Execute function gw_fct_setchangevalvestatus """

        if is_checked is False:
            # Disconnect snapping and related signals
            tools_qgis.disconnect_snapping(False, self.emit_point, self.vertex_marker)
            # Recover snapping options, refresh canvas & set visible layers
            self.snapper_manager.recover_snapping_options()
            return

        # Disconnect other snapping and signals in case wrong user clicks
        tools_qgis.disconnect_snapping(False, self.emit_point, self.vertex_marker)

        # Store user snapping configuration
        self.snapper_manager.store_snapping_options()

        # Set vertex marker propierties
        self.vertex_marker = self.snapper_manager.vertex_marker

        # Set active and current layer
        self.layer = tools_qgis.get_layer_by_tablename("v_edit_node")
        self.iface.setActiveLayer(self.layer)
        self.current_layer = self.layer

        # Waiting for signals
        self.canvas.xyCoordinates.connect(self._mouse_move_valve)
        self.emit_point.canvasClicked.connect(partial(self._custom_mincut_snapping, action))


    def _change_valve_status_execute(self, elem_id):
        """ Execute function 'gw_fct_setchangevalvestatus' """

        result_mincut_id = tools_qt.get_text(self.dlg_mincut, "result_mincut_id")
        if result_mincut_id != 'null':
            use_planified = tools_qt.is_checked(self.dlg_mincut, 'chk_use_planified')
            extras = f'"nodeId":{elem_id}, "mincutId":{result_mincut_id}, "usePsectors":"{use_planified}"'
            body = tools_gw.create_body(extras=extras)
            result = tools_gw.execute_procedure('gw_fct_setchangevalvestatus', body, log_sql=True)
            if result['status'] == 'Accepted' and result['message']:
                level = int(result['message']['level']) if 'level' in result['message'] else 1
                tools_qgis.show_message(result['message']['text'], level)

        # Disconnect snapping and related signals
        tools_qgis.disconnect_snapping(False, self.emit_point, self.vertex_marker)


    # endregion