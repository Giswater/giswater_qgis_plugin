"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import Qgis
from qgis.core import QgsPointXY
from qgis.PyQt.QtCore import QStringListModel, QDate, QSortFilterProxyModel, Qt, QDateTime, QSettings
from qgis.PyQt.QtGui import QColor, QStandardItem, QStandardItemModel
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtWidgets import QAbstractItemView, QAction, QCheckBox, QComboBox, QCompleter, QFileDialog, QHBoxLayout
from qgis.PyQt.QtWidgets import QLineEdit, QTableView, QToolButton, QWidget, QDateEdit, QPushButton
from qgis.core import QgsFeatureRequest, QgsGeometry
from qgis.gui import QgsRubberBand

import csv
import os
import re
from functools import partial
import urllib.parse as parse
import webbrowser
import json
from collections import OrderedDict
from ..maptool import GwMaptool

# from ...ui.ui_manager import ManageVisit
from ...ui.ui_manager import AddLotUi
from ...ui.ui_manager import LotSelectorUi
from ...ui.ui_manager import DialogTableUi
from ...ui.ui_manager import LoadManagementUi
from ...ui.ui_manager import LotManagementUi
from ...ui.ui_manager import WorkManagementUi
from ...ui.ui_manager import ResourcesManagementUi
from ...ui.ui_manager import TeamManagemenUi
from ...ui.ui_manager import TeamCreateUi
from ...ui.ui_manager import VehicleCreateUi
from .... import global_vars

from ....libs import lib_vars, tools_qgis, tools_qt, tools_db, tools_pgdao, tools_log
from ...utils import tools_gw


class AddNewLot():

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        """ Class to control 'Add basic visit' of toolbar 'edit' """

        self.ids = []
        self.canvas = global_vars.canvas
        self.rb_red = tools_gw.create_rubberband(self.canvas)
        self.rb_red.setColor(Qt.darkRed)
        self.rb_red.setIconSize(20)
        self.rb_list = []
        self.lot_date_format = 'yyyy-MM-dd'
        self.max_id = 0
        self.signal_selectionChanged = False
        self.param_options = None
        self.plugin_name = 'Giswater'
        self.plugin_dir = lib_vars.plugin_dir
        self.schemaname = lib_vars.schema_name
        self.iface = global_vars.iface

    def manage_lot(self, lot_id=None, is_new=True, visitclass_id=None):

        # turnoff autocommit of this and base class. Commit will be done at dialog button box level management
        self.autocommit = True
        self.remove_ids = False
        self.is_new_lot = is_new
        self.cmb_position = 17  # Variable used to set the position of the QCheckBox in the relations table
        self.layers = {}
        self.srid = lib_vars.data_epsg

        # Get layers of every feature_type
        tools_gw.reset_feature_list()
        tools_gw.reset_layers()
        self.layers['arc'] = [tools_qgis.get_layer_by_tablename('v_edit_arc')]
        self.layers['node'] = [tools_qgis.get_layer_by_tablename('v_edit_node')]
        self.layers['connec'] = [tools_qgis.get_layer_by_tablename('v_edit_connec')]

        # Add 'gully' for 'UD' projects
        if tools_gw.get_project_type() == 'ud':
            self.layers['gully'] = [self.tools_qgis.get_layer_by_tablename('v_edit_gully')]

        self.dlg_lot = AddLotUi(self)
        tools_gw.load_settings(self.dlg_lot)
        self.load_user_values(self.dlg_lot)
        self.dropdown = self.dlg_lot.findChild(QToolButton, 'action_selector')
        self.dropdown.setPopupMode(QToolButton.MenuButtonPopup)

        # Create action and put into QToolButton
        action_by_expression = self.create_action('action_by_expression', self.dlg_lot.action_selector, '204',
                                                  'Select by expression')
        action_by_polygon = self.create_action('action_by_polygon', self.dlg_lot.action_selector, '205',
                                               'Select by polygon')
        self.dropdown.addAction(action_by_expression)
        self.dropdown.addAction(action_by_polygon)
        self.dropdown.setDefaultAction(action_by_expression)

        # Set icons
        tools_gw.add_icon(self.dlg_lot.btn_feature_insert, "111")
        tools_gw.add_icon(self.dlg_lot.btn_feature_delete, "112")
        tools_gw.add_icon(self.dlg_lot.btn_feature_snapping, "137")
        tools_gw.add_icon(self.dlg_lot.btn_refresh_materialize_view, "116")

        # Set date format to date widgets (QUE ES ESTO)
        tools_qt.check_date(self.dlg_lot.startdate, self.dlg_lot.btn_accept, 1)
        tools_qt.check_date(self.dlg_lot.enddate, self.dlg_lot.btn_accept, 1)
        tools_qt.check_date(self.dlg_lot.real_startdate, self.dlg_lot.btn_accept, 1)
        tools_qt.check_date(self.dlg_lot.real_enddate, self.dlg_lot.btn_accept, 1)
        self.dlg_lot.enddate.textChanged.connect(self.check_dates_consistency)

        self.lot_id = self.dlg_lot.findChild(QLineEdit, "lot_id")
        self.user_name = self.dlg_lot.findChild(QLineEdit, "user_name")
        self.visit_class = self.dlg_lot.findChild(QComboBox, "cmb_visit_class")

        # Tab 'Relations'
        self.feature_type = self.dlg_lot.findChild(QComboBox, "feature_type")
        self.tbl_relation = self.dlg_lot.findChild(QTableView, "tbl_relation")
        tools_qt.set_tableview_config(self.tbl_relation)
        tools_qt.set_tableview_config(self.dlg_lot.tbl_visit)
        self.feature_type.setEnabled(False)

        # Fill QWidgets of the form
        self.fill_fields(lot_id)

        # Tab 'Loads', disabled if project type is ws
        if tools_gw.get_project_type() == 'ws':
            tools_qt.enable_tab_by_tab_name(self.dlg_lot.tab_widget, 'LoadsTab', False)

        self.tbl_load = self.dlg_lot.findChild(QTableView, "tbl_load")
        tools_qt.set_tableview_config(self.tbl_load)

        new_lot_id = lot_id
        if lot_id is None:
            new_lot_id = self.get_next_id('om_visit_lot', 'id')
        tools_qt.set_widget_text(self.dlg_lot, self.lot_id, new_lot_id)

        self.feature_type = tools_qt.get_combo_value(self.dlg_lot, self.visit_class, 2).lower()

        if self.feature_type != '':
            viewname = "v_edit_" + self.feature_type
            tools_gw.set_completer_feature_id(self.dlg_lot.feature_id, self.feature_type, viewname)
        else:
            self.feature_type = 'arc'
        self.clear_selection()

        self.event_feature_type_selected(self.dlg_lot)

        # Set actions signals
        action_by_expression.triggered.connect(
            partial(self.activate_selection, self.dlg_lot, action_by_expression, 'mActionSelectByExpression'))
        action_by_polygon.triggered.connect(
            partial(self.activate_selection, self.dlg_lot, action_by_polygon, 'mActionSelectPolygon'))

        # Set widgets signals
        self.dlg_lot.cmb_ot.activated.connect(partial(self.set_ot_fields))
        self.dlg_lot.cmb_ot.editTextChanged.connect(partial(self.filter_by_list, self.dlg_lot.cmb_ot))

        self.dlg_lot.btn_feature_insert.clicked.connect(partial(self.insert_row))
        self.dlg_lot.btn_feature_delete.clicked.connect(partial(self.remove_selection, self.dlg_lot, self.tbl_relation))
        self.dlg_lot.btn_feature_snapping.clicked.connect(partial(self.set_active_layer))
        self.dlg_lot.btn_feature_snapping.clicked.connect(partial(self.selection_init, self.dlg_lot))
        self.dlg_lot.cmb_visit_class.currentIndexChanged.connect(self.set_tab_dis_enabled)
        self.dlg_lot.cmb_visit_class.currentIndexChanged.connect(self.set_active_layer)
        self.dlg_lot.cmb_visit_class.currentIndexChanged.connect(
            partial(self.event_feature_type_selected, self.dlg_lot))
        self.dlg_lot.cmb_visit_class.currentIndexChanged.connect(partial(self.reload_table_visit))
        self.dlg_lot.cmb_visit_class.currentIndexChanged.connect(partial(self.set_lot_headers))
        self.dlg_lot.cmb_assigned_to.currentIndexChanged.connect(partial(self.populate_cmb_visitclass, event_change_team=True))
        self.dlg_lot.cmb_status.currentIndexChanged.connect(partial(self.manage_cmb_status))
        self.dlg_lot.txt_filter.textChanged.connect(partial(self.reload_table_visit))
        self.dlg_lot.date_event_from.dateChanged.connect(partial(self.reload_table_visit))
        self.dlg_lot.date_event_to.dateChanged.connect(partial(self.reload_table_visit))
        self.dlg_lot.btn_validate_all.clicked.connect(partial(self.validate_all, self.dlg_lot.tbl_visit))
        self.dlg_lot.btn_open_photo.clicked.connect(partial(self.open_photo, self.dlg_lot.tbl_visit))
        self.dlg_lot.tbl_relation.doubleClicked.connect(partial(self.zoom_to_feature, self.dlg_lot.tbl_relation))
        self.dlg_lot.tbl_visit.doubleClicked.connect(partial(self.zoom_to_feature, self.dlg_lot.tbl_visit))
        self.dlg_lot.btn_open_visit.clicked.connect(partial(self.open_visit, self.dlg_lot.tbl_visit))
        self.dlg_lot.btn_delete_visit.clicked.connect(partial(self.delete_visit, self.dlg_lot.tbl_visit))

        self.dlg_lot.btn_refresh_materialize_view.clicked.connect(partial(self.refresh_materialize_view))

        self.dlg_lot.btn_cancel.clicked.connect(partial(self.manage_rejected))
        self.dlg_lot.rejected.connect(partial(self.manage_rejected))
        self.dlg_lot.rejected.connect(partial(self.reset_rb_list, self.rb_list))
        self.dlg_lot.btn_accept.clicked.connect(partial(self.save_lot))
        self.set_lot_headers()
        self.set_active_layer()

        tools_gw.add_icon(self.dlg_lot.btn_open_image, "136b")
        print("hola1")
        self.dlg_lot.btn_open_image.clicked.connect(partial(self.open_load_image, self.tbl_load, 'cm.v_ui_om_vehicle_x_parameters'))

        if lot_id is not None and visitclass_id not in (None, '', 'NULL'):
            self.set_values(lot_id)
            tools_qt.get_combo_value(self.dlg_lot, self.visit_class, 2).lower()

            self.update_id_list()
            tools_qt.set_combo_value(self.dlg_lot.cmb_visit_class, visitclass_id, 1)
            table_name = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.cmb_visit_class, 3)

            tools_gw.set_dates_from_to(self.dlg_lot.date_event_from, self.dlg_lot.date_event_to, table_name,
                                   'startdate', 'enddate')
            self.reload_table_visit()
            self.manage_cmb_status()
            self.populate_table_relations(lot_id)

        # Enable or disable QWidgets
        self.dlg_lot.txt_ot_type.setReadOnly(True)
        self.dlg_lot.txt_wotype_id.setReadOnly(True)
        self.dlg_lot.txt_ot_address.setReadOnly(True)
        self.dlg_lot.txt_observ.setReadOnly(True)

        # Check if enable or disable tab relation if
        self.set_tab_dis_enabled()

        # Set autocompleters of the form
        self.set_completers()
        self.hilight_features(self.rb_list)

        # Get columns to ignore for tab_visit when export csv
        table_name = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.cmb_visit_class, 3)

        if table_name is not None:
            sql = "SELECT columnname FROM config_form_tableview WHERE location_type = 'tbl_visit' AND visible IS NOT TRUE AND objectname = '" + str(table_name) + "'"
            rows = tools_db.get_rows(sql)
            result_visit = []
            if rows is not None:
                for row in rows:
                    result_visit.append(row[0])
            else:
                result_visit = ''
        else:
            result_visit = ''

        # Get columns to ignore for tab_relations when export csv
        sql = "SELECT columnname FROM config_form_tableview WHERE location_type = 'lot' AND visible IS NOT TRUE AND objectname = 've_lot_x_" + str(self.feature_type) + "'"
        rows = tools_db.get_rows(sql)
        result_relation = []
        if rows is not None:
            for row in rows:
                result_relation.append(row[0])
        else:
            result = ''

        # Set listeners for export csv
        self.dlg_lot.btn_export_visits.clicked.connect(
            partial(self.export_model_to_csv, self.dlg_lot, self.dlg_lot.tbl_visit, 'txt_path', result_visit,
                    self.lot_date_format))
        self.dlg_lot.btn_export_rel.clicked.connect(
            partial(self.export_model_to_csv, self.dlg_lot, self.dlg_lot.tbl_relation, 'txt_path_rel', result_relation,
                    self.lot_date_format))
        self.dlg_lot.btn_path.clicked.connect(partial(self.select_path, self.dlg_lot, 'txt_path'))
        self.dlg_lot.btn_path_rel.clicked.connect(partial(self.select_path, self.dlg_lot, 'txt_path_rel'))
        self.check_for_ids()

        # Open the dialog
        tools_gw.open_dialog(self.dlg_lot, dlg_name="add_lot")

    def manage_cmb_status(self):
        """ Control of status_lot and widgets according to the selected status_lot """

        value = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.cmb_status, 0)
        # Set all options enabled
        all_index = ['1', '2', '3', '4', '5', '6', '7']
        tools_qt.set_combo_item_select_unselectable(self.dlg_lot.cmb_status, all_index, 0, (1 | 32))
        self.dlg_lot.btn_validate_all.setEnabled(True)

        combo_list = self.dlg_lot.tbl_visit.findChildren(QComboBox)
        for combo in combo_list:
            combo.setEnabled(True)
        self.dlg_lot.btn_delete_visit.setEnabled(True)

        # Disable options of QComboBox according combo selection
        if value in (1, 2, 3, 7):
            tools_qt.set_combo_item_select_unselectable(self.dlg_lot.cmb_status, ['4', '5', '6'], 0)
        elif value in (4, 5):
            tools_qt.set_combo_item_select_unselectable(self.dlg_lot.cmb_status, ['1', '2', '3', '7'], 0)
        elif value in [6]:
            tools_qt.set_combo_item_select_unselectable(self.dlg_lot.cmb_status, ['1', '2', '3', '4', '7'], 0)
            self.dlg_lot.btn_validate_all.setEnabled(False)
            for combo in combo_list:
                combo.setEnabled(False)
            self.dlg_lot.btn_delete_visit.setEnabled(False)
        self.disbale_actions(value)

    # QUE ES ESTO, no call?
    def set_checkbox_values(self):
        """ Set checkbox with the same values as the validate column """

        model = self.dlg_lot.tbl_relation.model()
        for x in range(0, model.rowCount()):
            index = model.index(x, self.cmb_position - 1)
            value = model.data(index)

            widget_cell = self.dlg_lot.tbl_relation.model().index(x, self.cmb_position)
            widget = self.dlg_lot.tbl_relation.indexWidget(widget_cell)
            chk_list = widget.findChildren(QCheckBox)
            if str(value) == 'True':
                chk_list[0].setChecked(True)

    def open_photo(self, qtable):

        selected_list = qtable.selectionModel().selectedRows()

        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return

        index = selected_list[0]
        row = index.row()
        column_index = tools_qt.get_col_index_by_col_name(qtable, 'visit_id')
        visit_id = index.sibling(row, column_index).data()

        sql = ("SELECT value FROM om_visit_event_photo WHERE visit_id = " + visit_id)
        rows = tools_db.get_rows(sql, commit=True)
        # TODO:: Open manage photos when visit have more than one
        for row in rows:
            webbrowser.open(row[0])

    def validate_all(self, qtable):
        """ Set all QComboBox with validated option """

        model = qtable.model()
        for x in range(0, model.rowCount()):
            index = qtable.model().index(x, self.cmb_position)
            cmb = qtable.indexWidget(index)
            tools_qt.set_combo_value(cmb, '5', 0)

    def create_team(self):
        self.dlg_create_team = TeamCreateUi()
        tools_gw.load_settings(self.dlg_create_team)

        self.dlg_create_team.rejected.connect(partial(tools_gw.close_dialog, self.dlg_create_team))
        self.dlg_create_team.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_create_team))
        self.dlg_create_team.btn_accept.clicked.connect(partial(self.save_team))

        # Fill cmb active
        values = [[0, "False"], [1, "True"]]
        tools_qt.fill_combo_values(self.dlg_create_team.cmb_active, values, 1)

        tools_gw.open_dialog(self.dlg_create_team)

    def save_team(self):

        team_name = tools_qt.get_text(self.dlg_create_team, self.dlg_create_team.txt_team)
        team_descript = tools_qt.get_text(self.dlg_create_team, self.dlg_create_team.txt_descript)
        team_active = tools_qt.get_combo_value(self.dlg_create_team, self.dlg_create_team.cmb_active, 1)

        if team_name is None:
            msg = f"El parametre 'Nom equip' es obligatori."
            tools_qgis.show_message(msg, 0)
            return

        sql = ("SELECT DISTINCT(idval) FROM cm.cat_team")
        rows = tools_db.get_rows(sql)
        if rows:
            for row in rows:
                if team_name == row[0]:
                    msg = f"Aquest 'Nom equip' ja existeix."
                    tools_qgis.show_message(msg, 0)
                    return

        sql = (f"INSERT INTO {self.schemaname}.cat_team (idval, descript, active) "
               f"VALUES('{team_name}', '{team_descript}', '{team_active}');")
        tools_db.execute_sql(sql)

        sql = ("SELECT id, idval FROM cm.cat_team WHERE active is True ORDER BY idval")
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_resources_man.cmb_team, rows)

        tools_gw.close_dialog(self.dlg_create_team)

    def create_vehicle(self):
        self.dlg_create_vehicle = VehicleCreateUi()
        tools_gw.load_settings(self.dlg_create_vehicle)

        self.dlg_create_vehicle.rejected.connect(partial(tools_gw.close_dialog, self.dlg_create_vehicle))
        self.dlg_create_vehicle.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_create_vehicle))
        self.dlg_create_vehicle.btn_accept.clicked.connect(partial(self.save_vehicle))

        tools_gw.open_dialog(self.dlg_create_vehicle)

    def save_vehicle(self):

        vehicle_name = tools_qt.get_text(self.dlg_create_vehicle, self.dlg_create_vehicle.txt_vehicle)
        vehicle_descript = tools_qt.get_text(self.dlg_create_vehicle, self.dlg_create_vehicle.txt_descript)
        vehicle_model = tools_qt.get_text(self.dlg_create_vehicle, self.dlg_create_vehicle.txt_model)
        vehicle_plate = tools_qt.get_text(self.dlg_create_vehicle, self.dlg_create_vehicle.txt_plate)

        if vehicle_name is None:
            msg = f"El parametre 'Nom vehicle' es obligatori."
            tools_qgis.show_message(msg, 0)
            return

        sql = ("SELECT DISTINCT(idval) FROM ext_cat_vehicle")
        rows = tools_db.get_rows(sql, commit=True)
        if rows:
            for row in rows:
                if vehicle_name == row[0]:
                    msg = f"Aquest 'Nom vehicle' ja existeix."
                    tools_qgis.show_message(msg, 0)
                    return

        sql = (f"INSERT INTO {self.schemaname}.ext_cat_vehicle (idval, descript, model, number_plate) "
               f"VALUES('{vehicle_name}', '{vehicle_descript}', '{vehicle_model}', '{vehicle_plate}');")
        tools_db.execute_sql(sql)

        sql = ("SELECT id, idval FROM ext_cat_vehicle ORDER BY idval")
        rows = tools_db.get_rows(sql, commit=True)
        tools_qt.fill_combo_values(self.dlg_resources_man.cmb_vehicle, rows)
        tools_qt.fill_combo_valuesa(self.dlg_resources_man.cmb_vehicle, vehicle_name)
        # Populate table_view vehicle
        self.populate_vehicle_views()

        tools_gw.close_dialog(self.dlg_create_vehicle)

    def manage_team(self):
        """ Open dialog of teams """

        self.dlg_basic_table = DialogTableUi()
        tools_gw.load_settings(self.dlg_basic_table)
        self.dlg_basic_table.setWindowTitle("Administrador d'equips")
        table_name = 'v_edit_cat_team'

        # @setEditStrategy: 0: OnFieldChange, 1: OnRowChange, 2: OnManualSubmit
        tools_qt.fill_table(self.dlg_basic_table.tbl_basic, table_name, QSqlTableModel.OnManualSubmit)
        tools_gw.set_tablemodel_config(self.dlg_basic_table, self.dlg_basic_table.tbl_basic, table_name)
        self.dlg_basic_table.btn_cancel.clicked.connect(partial(self.cancel_changes, self.dlg_basic_table.tbl_basic))
        self.dlg_basic_table.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_basic_table))
        self.dlg_basic_table.btn_accept.clicked.connect(partial(self.save_table, self.dlg_basic_table, self.dlg_basic_table.tbl_basic, manage_type='team_selector'))
        self.dlg_basic_table.btn_accept.clicked.connect(partial(tools_gw.close_dialog, self.dlg_basic_table))
        self.dlg_basic_table.rejected.connect(partial(tools_gw.save_settings, self.dlg_basic_table))

        # Rename widgets labels
        self.dlg_basic_table.btn_accept.setText('Acceptar')
        self.dlg_basic_table.btn_cancel.setText('Cancel·lar')

        self.dlg_basic_table.btn_add_row.setVisible(False)

        tools_gw.open_dialog(self.dlg_basic_table)

    def filter_cmb_team(self):
        """ Fill ComboBox cmb_assigned_to """

        visit_class = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.cmb_visit_class, 0)
        sql = ("SELECT DISTINCT(cat_team.id), idval FROM cm.cat_team "
                "JOIN om_team_x_visitclass ON cat_team.id = om_team_x_visitclass.team_id "
                "WHERE om_team_x_visitclass.visitclass_id = " + str(visit_class) + "")
        rows = tools_db.get_rows(sql, commit=True)

        if rows:
            tools_qt.fill_combo_values(self.dlg_lot.cmb_assigned_to, rows)
        else:
            self.dlg_lot.cmb_assigned_to.clear()

    def populate_cmb_team(self):
        """ Fill ComboBox cmb_assigned_to """

        sql = ("SELECT DISTINCT(cat_team.id), idval "
               "FROM cm.cat_team WHERE active is True ORDER BY idval")
        rows = tools_db.get_rows(sql, commit=True)

        if rows:
            tools_qt.fill_combo_values(self.dlg_lot.cmb_assigned_to, rows)
        else:
            self.dlg_lot.cmb_assigned_to.clear()

    # QUE ES ESTO se podria gestion ar logica en db?
    def populate_cmb_visitclass(self, event_change_team=False):
        """ Fill ComboBox cmb_visit_class """
        # Fill ComboBox cmb_visit_class
        self.assiged_to = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.cmb_assigned_to, 0)

        # Check if team have current visit class
        if event_change_team:
            visit_class = tools_qt.get_combo_value(self.dlg_lot.cmb_visit_class, 0)
            if visit_class not in (None, '') and self.assiged_to not in (None, ''):
                sql = (
                    "SELECT DISTINCT(config_visit_class.id) FROM config_visit_class "
                    "JOIN cm.om_team_x_visitclass ON config_visit_class.id = om_team_x_visitclass.visitclass_id "
                    "WHERE config_visit_class.active is True AND team_id = " + str(self.assiged_to) + " "
                    "AND config_visit_class.id = " + str(visit_class) + "")
                result = tools_db.get_row(sql, commit=True)
                if result:
                    return
        self.visit_class.setEnabled(True)
        if self.ot_result:
            sql = (
                "SELECT DISTINCT(config_visit_class.id), config_visit_class.idval, feature_type, "
                "config_visit_class.tablename, param_options::text, config_visit_class.feature_type "
                " FROM config_visit_class"
                " INNER JOIN config_visit_class_x_workorder "
                " ON config_visit_class_x_workorder.visitclass_id = config_visit_class.id ")
        else:
            sql = ("SELECT DISTINCT(config_visit_class.id), idval, feature_type, config_visit_class.tablename, param_options::text, "
                   "config_visit_class.feature_type FROM config_visit_class")
        if self.assiged_to:
            sql += (" JOIN cm.om_team_x_visitclass ON config_visit_class.id = om_team_x_visitclass.visitclass_id "
                    "WHERE config_visit_class.active is True AND team_id = " + str(self.assiged_to) + " ")
        if self.ot_result:
            sql += (" AND ismultifeature is False AND feature_type IS NOT null")

        visitclass_ids = tools_db.get_rows(sql, commit=True)
        if visitclass_ids:
            visitclass_ids.append(['', '', '', '', ''])
        else:
            visitclass_ids = []
            visitclass_ids.append(['', '', '', '', ''])

        tools_qt.fill_combo_values(self.dlg_lot.cmb_visit_class, visitclass_ids, 1)
        tools_qt.set_combo_value(self.dlg_lot.cmb_visit_class, visitclass_ids[0][1], 1)

    def cancel_changes(self, qtable):

        model = qtable.model()
        model.revertAll()
        model.database().rollback()

    def save_table(self, dialog, qtable, manage_type=None):

        model = qtable.model()
        if model.submitAll():
            if manage_type == 'team_selector':
                sql = ("SELECT id, idval FROM cm.cat_team WHERE active is True ORDER BY idval")
                rows = tools_db.get_rows(sql)
                if rows:
                    tools_qt.fill_combo_values(self.dlg_resources_man.cmb_team, rows, 1)
            elif manage_type == 'vehicle':
                sql = ("SELECT id, idval FROM ext_cat_vehicle ORDER BY idval")
                rows = tools_db.get_rows(sql)
                if rows:
                    tools_qt.fill_combo_values(self.dlg_resources_man.cmb_vehicle, rows, 1)
        else:
            print(str(model.lastError().text()))

    def manage_widget_lot(self, lot_id):

        # Fill ComboBox cmb_ot
        sql = ("SELECT ext_workorder.ct, ext_workorder.class_id,  ext_workorder.wotype_id, ext_workorder.wotype_name, "
               " ext_workorder.address, ext_workorder.serie, ext_workorder.visitclass_id, ext_workorder.observations "
               " FROM cm.ext_workorder ")

        if lot_id:
            _sql = ("SELECT serie from cm.om_visit_lot "
                    " WHERE id = '" + str(lot_id) + "'")
            ct = tools_db.get_rows(_sql)
            sql += " WHERE ext_workorder.serie = '" + str(ct[0]) + "'"
        sql += " order by ct desc"

        print(sql)
        rows = tools_db.get_rows(sql)
        print(rows)

        self.list_to_show = ['']  # List to show
        self.list_to_work = [['', '', '', '', '', '', '']]  # List to work (find feature)

        if rows:
            for row in rows:
                self.list_to_show.append(row[0])
                # elem = (0-class_id, 1-wotype_id, 2-wotype_name, 3-address, 4-serie,5-visitclass_id, 6-observations)
                elem = [row[1], row[2], row[3], row[4], row[5], row[6], row[7]]
                self.list_to_work.append(elem)
                ot_result = True
        else:
            ot_result = False

        self.set_model_by_list(self.list_to_show, self.dlg_lot.cmb_ot)

        return ot_result

    def filter_by_list(self, widget):
        """ The combination of this function and the function self.set_model_by_list(List, QCombobox),
        make the QCombobox can filter by text as if it were a ILIKE """

        self.proxy_model.setFilterFixedString(widget.currentText())

    def set_model_by_list(self, string_list, widget):
        """ The combination of this function and the function self.filter_by_list(QCombobox),
        make the QCombobox can filter by text as if it were a ILIKE """

        model = QStringListModel()
        model.setStringList(string_list)
        self.proxy_model = QSortFilterProxyModel()
        self.proxy_model.setSourceModel(model)
        self.proxy_model.setFilterKeyColumn(0)

        proxy_model_aux = QSortFilterProxyModel()
        proxy_model_aux.setSourceModel(model)
        proxy_model_aux.setFilterKeyColumn(0)

        widget.setModel(proxy_model_aux)
        widget.setModelColumn(0)
        completer = QCompleter()

        completer.setModel(self.proxy_model)
        completer.setCompletionColumn(0)
        completer.setCompletionMode(QCompleter.UnfilteredPopupCompletion)
        widget.setCompleter(completer)

    def check_dates_consistency(self):
        """ Check that the date 'from' is lees than the date 'to' """

        # Get dates as text
        startdate = tools_qt.get_text(self.dlg_lot, self.dlg_lot.startdate)
        enddate = tools_qt.get_text(self.dlg_lot, self.dlg_lot.enddate, False, False)

        if enddate == '':
            self.dlg_lot.startdate.setStyleSheet("border: 1px solid gray")
            self.dlg_lot.enddate.setStyleSheet("border: 1px solid gray")
            return

        # Transform text dates as QDate
        startdate = QDate.fromString(startdate, self.lot_date_format)
        enddate = QDate.fromString(enddate, self.lot_date_format)

        if startdate <= enddate:
            self.dlg_lot.startdate.setStyleSheet("border: 1px solid gray")
            self.dlg_lot.enddate.setStyleSheet("border: 1px solid gray")
        else:
            self.dlg_lot.startdate.setStyleSheet("border: 1px solid red")
            self.dlg_lot.enddate.setStyleSheet("border: 1px solid red")

    def set_ot_fields(self, index):

        item = self.list_to_work[index]

        tools_qt.set_widget_text(self.dlg_lot, self.dlg_lot.txt_ot_type, item[0])
        tools_qt.set_widget_text(self.dlg_lot, self.dlg_lot.txt_wotype_id, item[2])
        tools_qt.set_widget_text(self.dlg_lot, self.dlg_lot.txt_ot_address, item[3])
        tools_qt.set_widget_text(self.dlg_lot, self.dlg_lot.txt_observ, item[6])

        # Enable/Disable visit class combo according selected OT
        if (tools_qt.get_text(self.dlg_lot, self.dlg_lot.cmb_ot) == 'null') or \
                tools_gw.get_project_type() == 'ws':
            self.dlg_lot.cmb_visit_class.setEnabled(True)
        else:
            self.dlg_lot.cmb_visit_class.setEnabled(False)
            tools_qt.set_combo_value(self.dlg_lot.cmb_visit_class, str(item[5]), 0)

    def disbale_actions(self, value):
        """ Disable or enabled action according option selected into QComboBox cmb_status
            5=EXECUTAT, 6=REVISAT, 7=CANCEL.LAT
        """

        # Set actions enabled
        self.dlg_lot.action_selector.setEnabled(True)
        self.dlg_lot.btn_feature_insert.setEnabled(True)
        self.dlg_lot.btn_feature_delete.setEnabled(True)
        self.dlg_lot.btn_feature_snapping.setEnabled(True)

        # Set actions disabled
        if value in (5, 6, 7):
            self.dlg_lot.action_selector.setEnabled(False)
            self.dlg_lot.btn_feature_insert.setEnabled(False)
            self.dlg_lot.btn_feature_delete.setEnabled(False)
            self.dlg_lot.btn_feature_snapping.setEnabled(False)

    def delete_visit(self, qtable):
        selected_list = qtable.selectionModel().selectedRows()
        feature_type = tools_qt.get_combo_value(None, self.dlg_lot.cmb_visit_class, 2).lower()

        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return
        message = "Are you sure you want to delete these records? \n"
        msg_records = ""
        id_list = "(  "
        for x in range(0, len(selected_list)):
            # Get index of row and row[index]
            row_index = selected_list[x]
            row = row_index.row()
            index_visit = tools_qt.get_col_index_by_col_name(qtable, 'visit_id')
            visit_id = row_index.sibling(row, index_visit).data()
            # Get index of column 'feature_id' and get value of this column in current row
            index_feature = tools_qt.get_col_index_by_col_name(qtable, str(feature_type) + '_id')
            feature_id = row_index.sibling(row, index_feature).data()
            id_list += "'" + feature_id + "', "
            msg_records += "visit_id: " + str(visit_id) + ", " + str(feature_type) + "_id = '" + str(feature_id) + "';\n"
        id_list = id_list[:-2] + ")"
        answer = tools_qt.show_question(message, "Delete records", msg_records)
        if answer:
            sql = ("DELETE FROM om_visit_x_" + str(feature_type) + " "
                   " WHERE visit_id = '" + str(visit_id) + "' "
                   " AND " + str(feature_type) + "_id IN " + str(id_list) + ";\n")
            tools_db.execute_sql(sql)

        self.reload_table_visit()

    def open_visit(self, qtable):

        selected_list = qtable.selectionModel().selectedRows()

        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return

        index = selected_list[0]
        row = index.row()
        column_index = tools_qt.get_col_index_by_col_name(qtable, 'visit_id')
        visit_id = index.sibling(row, column_index).data()

        manage_visit = ManageVisit(self.iface, self.settings, self.controller, self.plugin_dir)
        manage_visit.manage_visit(visit_id=visit_id)

    def read_standaritemmodel(self, qtable):

        headers = self.get_headers(qtable)
        rows = []
        model = qtable.model()
        if model is not None:
            for x in range(0, model.rowCount()):
                row = {}
                for c in range(0, model.columnCount()):
                    index = model.index(x, c)
                    value = model.data(index)
                    row[headers[c]] = value
                rows.append(row)
        return rows

    def fill_fields(self, lot_id):
        """ Fill combo boxes of the form """

        # Visit tab
        # Set current date and time
        current_date = QDate.currentDate()
        tools_qt.set_widget_text(self.dlg_lot, self.dlg_lot.startdate, current_date.toString(self.lot_date_format))

        # Set current user
        sql = "SELECT current_user"
        row = tools_db.get_rows(sql, commit=self.autocommit)
        tools_qt.set_widget_text(self.dlg_lot, self.user_name, row[0])

        # Fill ComboBox cmb_ot
        self.ot_result = self.manage_widget_lot(lot_id)

        # Fill ComboBox cmb_assigned_to
        self.populate_cmb_team()

        self.populate_cmb_visitclass()

        # Fill ComboBox cmb_status
        rows = tools_db.get_values_from_catalog('om_typevalue', 'lot_cat_status')
        if rows:
            tools_qt.fill_combo_values(self.dlg_lot.cmb_status, rows, 1, sort_combo=False)
            tools_qt.set_combo_item_select_unselectable(self.dlg_lot.cmb_status, ['4', '5', '6'], 0)
            tools_qt.set_combo_value(self.dlg_lot.cmb_status, '1', 0)

        # Relations tab
        # fill feature_type
        sql = ("SELECT id, id"
               " FROM sys_feature_type"
               " WHERE classlevel = 1 or classlevel = 2"
               " ORDER BY id")
        feature_type = tools_db.get_rows(sql, commit=self.autocommit)
        if feature_type:
            tools_qt.fill_combo_values(self.dlg_lot.feature_type, feature_type, 1)

    def get_next_id(self, table_name, pk):
        sql = f"SELECT MAX({pk}::integer) FROM cm.{table_name};"
        row = tools_db.get_rows(sql)

        if row and isinstance(row, list) and len(row) > 0 and isinstance(row[0], tuple):
            max_id = row[0][0] if row[0][0] is not None else 0
        else:
            max_id = 0

        return max_id + 1

    def event_feature_type_selected(self, dialog):
        """ Manage selection change in feature_type combo box.
        This means that have to set completer for feature_id QTextLine and
        setup model for features to select table """

        # 1) set the model linked to selecte features
        # 2) check if there are features related to the current visit
        # 3) if so, select them => would appear in the table associated to the model
        param_options = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.cmb_visit_class, 4)
        if param_options in (None, ''):
            return
        self.param_options = json.loads(param_options, object_pairs_hook=OrderedDict)
        viewname = "v_edit_" + self.feature_type.lower()
        tools_gw.set_completer_feature_id(dialog.feature_id, self.feature_type, viewname)

    def clear_selection(self, remove_groups=True):
        """ Remove all previous selections """

        layer = tools_qgis.get_layer_by_tablename("v_edit_arc")
        if layer:
            layer.removeSelection()
        layer = tools_qgis.get_layer_by_tablename("v_edit_node")
        if layer:
            layer.removeSelection()
        layer = tools_qgis.get_layer_by_tablename("v_edit_connec")
        if layer:
            layer.removeSelection()
        layer = tools_qgis.get_layer_by_tablename("v_edit_element")
        if layer:
            layer.removeSelection()

        if tools_gw.get_project_type() == 'ud':
            layer = tools_qgis.get_layer_by_tablename("v_edit_gully")
            if layer:
                layer.removeSelection()

        try:
            if remove_groups:
                for layer in self.layers['arc']:
                    layer.removeSelection()
                for layer in self.layers['node']:
                    layer.removeSelection()
                for layer in self.layers['connec']:
                    layer.removeSelection()
                for layer in self.layers['gully']:
                    layer.removeSelection()
                for layer in self.layers['element']:
                    layer.removeSelection()
        except:
            pass

        self.canvas.refresh()

    def set_values(self, lot_id):

        sql = ("SELECT om_visit_lot.*, ext_workorder.ct from cm.om_visit_lot LEFT JOIN ext_workorder using (serie) "
               "WHERE id ='" + str(lot_id) + "'")
        lot = tools_db.get_rows(sql, commit=True)
        if lot:
            if lot['ct'] is not None:
                value = lot['ct']
                tools_qt.set_widget_text(self.dlg_lot, self.dlg_lot.cmb_ot, value)
            index = self.dlg_lot.cmb_ot.currentIndex()
            self.set_ot_fields(index)
            tools_qt.set_widget_text(self.dlg_lot, self.dlg_lot.startdate, lot['startdate'])
            tools_qt.set_widget_text(self.dlg_lot, self.dlg_lot.enddate, lot['enddate'])
            tools_qt.set_widget_text(self.dlg_lot, self.dlg_lot.real_startdate, lot['real_startdate'])
            tools_qt.set_widget_text(self.dlg_lot, self.dlg_lot.real_enddate, lot['real_enddate'])
            tools_qt.set_combo_value(self.dlg_lot.cmb_visit_class, str(lot['visitclass_id']), 0)
            tools_qt.set_combo_value(self.dlg_lot.cmb_assigned_to, str(lot['team_id']), 0)
            tools_qt.set_combo_value(self.dlg_lot.cmb_status, str(lot['status']), 0)
            tools_qt.set_widget_text(self.dlg_lot, self.dlg_lot.descript, lot['descript'])
            if lot['status'] in (4, 5):
                self.dlg_lot.cmb_assigned_to.setEnabled(False)
            tools_qt.set_combo_value(self.dlg_lot.feature_type, lot['feature_type'], 0)

    def populate_visits(self, widget, table_name, expr_filter=None):
        """ Set a model with selected filter. Attach that model to selected table """

        if self.schemaname not in table_name:
            table_name = str(self.schemaname) + "." + str(table_name)

        # Set model
        model = QSqlTableModel()
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.sort(0, 1)
        if expr_filter:
            model.setFilter(expr_filter)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            tools_qgis.show_warning(model.lastError().text())

        # Attach model to table view
        widget.setModel(model)

    def update_id_list(self):

        feature_type = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.feature_type, 1).lower()
        sql = "SELECT alias FROM " + self.schemaname + ".config_form_tableview WHERE location_type = 'tbl_relations' AND columnname = '" + str(
            feature_type) + "_id'"
        row = tools_db.get_rows(sql)

        column_name = str(feature_type) + "_id"
        if row:
            column_name = row[0]
        list_ids = self.get_table_values(self.tbl_relation, column_name)
        for id_ in list_ids:
            if id_ not in self.ids:
                self.ids.append(id_)

        self.check_for_ids()

    def get_table_values(self, qtable, column_name):

        if qtable.model() is None:
            return []
        column_index = tools_qt.get_col_index_by_col_name(qtable, column_name)
        model = qtable.model()

        id_list = []
        for i in range(0, model.rowCount()):
            i = model.index(i, column_index)
            id_list.append(i.data())
        return id_list

    def activate_selection(self, dialog, action, action_name):

        self.set_active_layer()
        self.dropdown.setDefaultAction(action)
        tools_qgis.disconnect_signal_selection_changed()
        self.feature_type = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.cmb_visit_class, 2)
        if self.signal_selectionChanged is False:
            self.iface.mainWindow().findChild(QAction, action_name).triggered.connect(
                partial(self.selection_changed_by_expr, dialog, self.layer_lot, self.feature_type, self.param_options))
        self.iface.mainWindow().findChild(QAction, action_name).trigger()

    def selection_changed_by_expr(self, dialog, layer, feature_type, param_options):
        self.signal_selectionChanged = True
        self.canvas.selectionChanged.connect(partial(self.manage_selection, dialog, layer, feature_type, param_options))

    def manage_selection(self, dialog, layer, feature_type, param_options):
        """ Slot function for signal 'canvas.selectionChanged' """
        field_id = feature_type + "_id"
        if param_options and 'featureType' in param_options:
            key = feature_type + "_type"
            sys_type = param_options['featureType']
        elif param_options and 'sysType' in param_options:
            key = "sysType"
            sys_type = param_options['sysType']
        else:
            sys_type = None

        # Iterate over layer
        if layer.selectedFeatureCount() > 0:
            # Get selected features of the layer
            features = layer.selectedFeatures()
            for feature in features:
                # Append 'feature_id' into the list
                selected_id = feature.attribute(field_id)
                state = feature.attribute('state')

                if str(state) != "1":
                    continue

                if sys_type and (feature.attribute(key) == sys_type and selected_id not in self.ids):
                    self.ids.append(str(selected_id))
                elif sys_type is None and selected_id not in self.ids:
                    self.ids.append(str(selected_id))
                else:
                    continue
        self.reload_table_relations()
        self.check_for_ids()

    def reload_table_relations(self):
        """ Reload @widget with contents of @tablename applying selected @expr_filter """

        feature_type = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.feature_type, 1).lower()
        column_name = f"{feature_type}_id"
        id_list = self.get_table_values(self.tbl_relation, column_name)
        field_id = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.feature_type, 0).lower() + str('_id')

        expr_filter = None
        if len(self.ids) > 0:
            expr_filter = f'"{field_id}" IN ('
            for i in range(len(self.ids)):
                if self.ids[i] not in id_list:
                    # Set 'expr_filter' with features that are in the list
                    expr_filter += f"'{self.ids[i]}', "
            for i in range(len(id_list)):
                expr_filter += f"'{id_list[i]}', "
            expr_filter = expr_filter[:-2] + ")"

        # Check expression
        (is_valid, expr) = tools_qt.check_expression_filter(expr_filter)  # @UnusedVariable
        if not is_valid:
            return

        tools_gw.load_tablename(self.dlg_lot, self.tbl_relation, feature_type, expr_filter)
        self.hilight_features(self.rb_list, feature_type)

    def insert_row(self):
        """ Insert single row into QStandardItemModel """

        standard_model = self.tbl_relation.model()
        feature_id = tools_qt.get_text(self.dlg_lot, self.dlg_lot.feature_id)
        lot_id = tools_qt.get_text(self.dlg_lot, self.lot_id)
        layer_name = 'v_edit_' + tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.feature_type, 0).lower()
        field_id = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.feature_type, 0).lower() + str('_id')
        layer = tools_qgis.get_layer_by_tablename(layer_name)
        feature = self.get_feature_by_id(layer, feature_id, field_id)

        if feature is False:
            return

        state = feature.attribute('state')

        if str(state) != "1":
            return

        if feature_id not in self.ids:
            self.ids.append(feature_id)
            self.reload_table_relations()
        self.check_for_ids()

    def get_feature_by_id(self, layer, id_, field_id):

        expr = "" + str(field_id) + "= '" + str(id_) + "'"
        features = layer.getFeatures(QgsFeatureRequest().setFilterExpression(expr))
        for feature in features:
            if feature[field_id] == id_:
                return feature
        return False

    def insert_single_checkbox(self, qtable):
        """ Create one QCheckBox and put into QTableView at position @self.cmb_position """

        cell_widget = QWidget()
        chk = QCheckBox()
        lay_out = QHBoxLayout(cell_widget)
        lay_out.addWidget(chk)
        lay_out.setAlignment(Qt.AlignCenter)
        lay_out.setContentsMargins(0, 0, 0, 0)
        cell_widget.setLayout(lay_out)
        i = qtable.model().index(qtable.model().rowCount() - 1, self.cmb_position)
        qtable.setIndexWidget(i, cell_widget)

    def remove_selection(self, dialog, qtable):

        tools_qgis.disconnect_signal_selection_changed()
        feature_type = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.feature_type, 0).lower()
        table_name = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.cmb_visit_class, 3)
        # Get selected rows
        index_list = qtable.selectionModel().selectedRows()

        if len(index_list) == 0:
            message = "Any record selected"
            tools_qt.show_info_box(message)
            return
        index = index_list[0]
        model = qtable.model()

        sql = "SELECT alias FROM " + self.schemaname + ".config_form_tableview WHERE location_type = 'tbl_relations' AND columnname = '" + str(
            feature_type) + "_id'"
        return_row = tools_db.get_rows(sql)
        if return_row:
            column_name = return_row[0]
        else:
            column_name = f"{feature_type}_id"

        self.ids = self.get_table_values(self.tbl_relation, column_name)

        for i in range(len(index_list) - 1, -1, -1):
            row = index_list[i].row()
            column_index = tools_qt.get_col_index_by_col_name(qtable, column_name)
            feature_id = index.sibling(row, column_index).data()
            self.ids.remove(feature_id)

        model.clear()
        self.reload_table_relations()

        self.check_for_ids()
        tools_gw.set_dates_from_to(self.dlg_lot.date_event_from, self.dlg_lot.date_event_to, table_name,
                               'startdate', 'enddate')
        self.reload_table_visit()
        self.reload_table_visit()

    def set_active_layer(self):

        self.current_layer = self.iface.activeLayer()
        # Set active layer
        visit_class = tools_qt.get_combo_value(self.dlg_lot, self.visit_class, 2)
        if visit_class in (None, ''):
            return
        layer_name = 'v_edit_' + visit_class.lower()

        self.layer_lot = tools_qgis.get_layer_by_tablename(layer_name)
        self.iface.setActiveLayer(self.layer_lot)
        tools_qgis.set_layer_visible(self.layer_lot)

    def selection_init(self, dialog):
        """ Set canvas map tool to an instance of class 'MultipleSelection' """

        tools_qgis.disconnect_signal_selection_changed()
        self.iface.actionSelect().trigger()
        self.connect_signal_selection_changed(dialog)

    def connect_signal_selection_changed(self, dialog):
        """ Connect signal selectionChanged """

        try:
            self.feature_type = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.cmb_visit_class, 2)
            self.canvas.selectionChanged.connect(partial(self.manage_selection, dialog, self.layer_lot, self.feature_type, self.param_options))
        except:
            pass

    def set_tab_dis_enabled(self):
        self.ids = []
        feature_type = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.cmb_visit_class, 2)
        index = 0
        for x in range(0, self.dlg_lot.tab_widget.count()):
            if self.dlg_lot.tab_widget.widget(x).objectName() == 'RelationsTab' or self.dlg_lot.tab_widget.widget(
                    x).objectName() == 'VisitsTab' or self.dlg_lot.tab_widget.widget(x).objectName() == 'LoadsTab':
                index = x

                if feature_type in ('', 'null', None, -1):
                    self.dlg_lot.tab_widget.setTabEnabled(index, False)
                    continue
                else:
                    self.dlg_lot.tab_widget.setTabEnabled(index, True)
        tools_qt.set_combo_value(self.dlg_lot.findChild(QComboBox, "feature_type"), feature_type, 1, add_new=False)
        self.fill_tab_load()

    def reload_table_visit(self):

        feature_type = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.cmb_visit_class, 2)
        object_id = tools_qt.get_text(self.dlg_lot, self.dlg_lot.txt_filter)
        lot_id = tools_qt.get_text(self.dlg_lot, self.dlg_lot.lot_id, False, False)
        visit_start = self.dlg_lot.date_event_from.date()
        visit_end = self.dlg_lot.date_event_to.date()
        # Get selected dates
        date_from = visit_start.toString('yyyyMMdd 00:00:00')
        date_to = visit_end.toString('yyyyMMdd 23:59:59')
        if date_from > date_to:
            message = "Selected date interval is not valid"
            tools_qgis.show_warning(message)
            return

        visit_class_id = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.cmb_visit_class, 0)
        if visit_class_id == '':
            return

        standard_model = QStandardItemModel()
        self.dlg_lot.tbl_visit.setModel(standard_model)
        self.dlg_lot.tbl_visit.horizontalHeader().setStretchLastSection(True)

        table_name = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.cmb_visit_class, 3)

        if table_name is None:
            return

        # Create interval dates
        format_low = self.lot_date_format + ' 00:00:00.000'
        format_high = self.lot_date_format + ' 23:59:59.999'
        interval = "'" + str(visit_start.toString(format_low)) + "'::timestamp AND '" + str(visit_end.toString(format_high)) + "'::timestamp"

        expr_filter = "(startdate BETWEEN " + str(interval) + ") AND (enddate BETWEEN " + str(interval) + " OR enddate is NULL)"

        if object_id != 'null':
            expr_filter += " AND " + str(feature_type) + "_id::TEXT ILIKE '%" + str(object_id) + "%'"
        if lot_id != '':
           expr_filter += " AND lot_id='" + str(lot_id) + "'"

        columns_name = tools_db.get_columns_list(table_name)

        # Get headers
        headers = []
        for x in columns_name:
            headers.append(x[0])

        # Set headers to model
        standard_model.setHorizontalHeaderLabels(headers)

        # Hide columns
        tools_gw.set_tablemodel_config(self.dlg_lot, self.dlg_lot.tbl_visit, table_name, isQStandardItemModel=True)

        # Populate model visit
        sql = ("SELECT * FROM " + str(table_name) + ""
               " WHERE " + str(expr_filter) + "")
        rows = tools_db.get_rows(sql, commit=True)

        if rows is None:
            return

        for row in rows:
            item = []
            for value in row:
                if value is not None:
                    if type(value) != str:
                        item.append(QStandardItem(str(value)))
                    else:
                        item.append(QStandardItem(value))
                else:
                    item.append(QStandardItem(None))
            if len(row) > 0:
                standard_model.appendRow(item)

        combo_values = tools_db.get_values_from_catalog('om_typevalue', 'visit_status')
        if combo_values is None:
            return
        # self.put_combobox(self.dlg_lot.tbl_visit, rows, 'status', 17, combo_values)

    def put_combobox(self, qtable, rows, field, widget_pos, combo_values):
        """ Set one column of a QtableView as QComboBox with values from database. """
        for x in range(0, len(rows)):
            combo = QComboBox()
            row = rows[x]

            # Populate QComboBox
            tools_qt.fill_combo_values(combo, combo_values, 1)

            # Set QCombobox to wanted item
            tools_qt.set_combo_value(combo, str(row[field]), 0)

            # Get index and put QComboBox into QTableView at inde   x position
            idx = qtable.model().index(x, widget_pos)
            qtable.setIndexWidget(idx, combo)
            combo.currentIndexChanged.connect(partial(self.update_status, combo, qtable, x, widget_pos))

    def update_status(self, combo, qtable, pos_x, widget_pos):
        """ Update values from QComboBox to QTableView """
        elem = combo.itemData(combo.currentIndex())
        i = qtable.model().index(pos_x, widget_pos)
        qtable.model().setData(i, elem[0])
        i = qtable.model().index(pos_x, widget_pos + 1)
        qtable.model().setData(i, elem[1])

    def populate_table_relations(self, lot_id):

        standard_model = self.tbl_relation.model()

        feature_type = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.cmb_visit_class, 2).lower()
        if feature_type:
            sql = (f"select * from v_edit_{feature_type} WHERE {feature_type}_id IN (select {feature_type}_id from ve_lot_x_{feature_type} where lot_id = {lot_id})")
            rows = tools_db.get_rows(sql, commit=True)

            if rows is None:
                return
            for row in rows:
                item = []
                for value in row:
                    if value is not None:
                        item.append(QStandardItem(str(value)))
                    else:
                        item.append(QStandardItem(None))

                if len(row) > 0:
                    standard_model.appendRow(item)

    def set_lot_headers(self):

        standard_model = QStandardItemModel()
        self.tbl_relation.setModel(standard_model)
        self.tbl_relation.horizontalHeader().setStretchLastSection(True)

        feature_type = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.cmb_visit_class, 2)
        if feature_type in (None, ''):
            return

        feature_type = feature_type.lower()
        columns_name = tools_db.get_columns_list('v_edit_' + str(feature_type))

        # Get headers
        headers = []
        for x in columns_name:
            headers.append(x[0])

        # Set headers
        standard_model.setHorizontalHeaderLabels(headers)

    def save_lot(self):

        lot = {}
        index = self.dlg_lot.cmb_ot.currentIndex()
        item = self.list_to_work[index]

        lot['id'] = tools_qt.get_text(self.dlg_lot, self.dlg_lot.lot_id, False, False)
        lot['startdate'] = tools_qt.get_text(self.dlg_lot, self.dlg_lot.startdate, False, False)
        lot['enddate'] = tools_qt.get_text(self.dlg_lot, self.dlg_lot.enddate, False, False)
        lot['team_id'] = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.cmb_assigned_to, 0, True)
        lot['feature_type'] = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.cmb_visit_class, 2).lower()
        lot['status'] = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.cmb_status, 0)
        lot['class_id'] = item[0]
        lot['address'] = item[3]
        lot['serie'] = item[4]
        lot['visitclass_id'] = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.cmb_visit_class, 0)
        lot['descript'] = tools_qt.get_text(self.dlg_lot, self.dlg_lot.descript, False, False)

        keys = ""
        values = ""
        update = ""

        for key, value in list(lot.items()):
            keys += "" + key + ", "
            if value not in ('', None):
                if type(value) in (int, bool):
                    values += "$$" + str(value) + "$$, "
                    update += "" + str(key) + "=$$" + str(value) + "$$, "
                else:
                    values += "$$" + str(value) + "$$, "
                    update += str(key) + "=$$" + str(value) + "$$, "
            else:
                values += "null, "
                update += key + "=null, "

        keys = keys[:-2]
        values = values[:-2]
        update = update[:-2]

        if self.is_new_lot is True:
            sql = ("INSERT INTO om_visit_lot(" + str(keys) + ") "
                   " VALUES (" + str(values) + ") RETURNING id")
            row = tools_db.execute_returning(sql)
            if row in (None, False):
                return
            lot_id = row[0]
            sql = ("INSERT INTO selector_lot "
                   "(lot_id, cur_user) VALUES(" + str(lot_id) + ", current_user);")
            tools_db.execute_sql(sql)
            tools_qgis.refresh_map_canvas()
        else:
            lot_id = tools_qt.get_text(self.dlg_lot, 'lot_id', False, False)
            sql = ("UPDATE om_visit_lot "
                   " SET " + str(update) + ""
                   " WHERE id = '" + str(lot_id) + "'; \n")
            tools_db.execute_sql(sql)
        self.save_relations(lot, lot_id, lot['feature_type'])
        sql = ("SELECT gw_fct_lot_psector_geom(" + str(lot_id) + ")")
        tools_db.execute_sql(sql)
        status = self.save_visits()

        if status:
            self.iface.mapCanvas().refreshAllLayers()
            self.manage_rejected()

    def save_relations(self, lot, lot_id, feature_type):

        # Manage relations
        if not feature_type:
            return

        ids = []
        model_rows = self.read_standaritemmodel(self.tbl_relation)

        if model_rows is None:
            return

        # Save relations
        sql = f"SELECT {feature_type}_id from cm.om_visit_lot_x_{feature_type} WHERE lot_id = {lot_id}"
        rows = tools_db.get_rows(sql)

        if rows is not None:
            ids = [f'{x[0]}' for x in rows]

        column_name = f"{feature_type}_id"
        id_list = self.get_table_values(self.tbl_relation, column_name)

        if id_list:
            for id in id_list:
                if id not in ids:
                    sql = f"INSERT INTO om_visit_lot_x_{feature_type} SELECT {lot_id}, {feature_type}_id, code, 1 FROM v_edit_{feature_type} WHERE {feature_type}_id = '{id}' ON CONFLICT (lot_id, {feature_type}_id) DO NOTHING;\n"
                    tools_db.execute_sql(sql)
            for id in ids:
                if id not in id_list:
                    sql = f"DELETE from cm.om_visit_lot_x_{feature_type} WHERE lot_id = {lot_id} AND {feature_type}_id = '{id}'"
                    tools_db.execute_sql(sql)
        else:
            sql = f"DELETE from cm.om_visit_lot_x_{feature_type} WHERE lot_id = {lot_id}"
            tools_db.execute_sql(sql)

    def save_visits(self):

        # Manage visits
        table_name = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.cmb_visit_class, 3)

        model_rows = self.read_standaritemmodel(self.dlg_lot.tbl_visit)
        if not model_rows:
            return True

        sql = ""
        status_aux = True
        for item in model_rows:
            visit_id = None
            status = None

            for key, value in list(item.items()):
                if key == "visit_id":
                    visit_id = str(value)
                if key == "status":
                    if value not in ('', None):
                        _sql = ("SELECT id FROM om_typevalue WHERE id = '" + str(value) + "' AND typevalue = 'visit_status'")
                        result = tools_db.get_rows(_sql, commit=True)
                        if result not in ('', None):
                            status = "$$" + str(result[0]) + "$$ "
            if visit_id and status:
                sql += ("UPDATE " + str(table_name) + " "
                        "SET status = (" + str(status) + ") "
                        "WHERE visit_id = '" + str(visit_id) + "';\n")
        if sql != "":
            status_aux = tools_db.execute_sql(sql)

        return status_aux

    def set_completers(self):
        """ Set autocompleters of the form """

        # Adding auto-completion to a QLineEdit - lot_id
        self.completer = QCompleter()
        self.dlg_lot.lot_id.setCompleter(self.completer)
        model = QStringListModel()

        sql = "SELECT DISTINCT(id) FROM om_visit"
        rows = tools_db.get_rows(sql, commit=self.autocommit)
        values = []
        if rows:
            for row in rows:
                values.append(str(row[0]))

        model.setStringList(values)
        self.completer.setModel(model)

    def reset_rb_list(self, rb_list):

        self.rb_red.reset()
        for rb in rb_list:
            rb.reset()

    def hilight_features(self, rb_list, feature_type=None):

        self.reset_rb_list(rb_list)

        extras = f'"feature_type":"{feature_type}", "ids":"{self.ids}"'
        body = tools_gw.create_body(extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_getfeaturegeom', body)

        if not json_result:
            return

        for feature_geom in json_result['body']['data']:

            geometry = QgsGeometry.fromWkt(str(json_result['body']['data'][feature_geom]['st_astext']))
            rb = QgsRubberBand(self.canvas)
            rb.setToGeometry(geometry, None)
            rb.setColor(QColor(255, 0, 0, 100))
            rb.setWidth(5)
            rb.show()
            rb_list.append(rb)

    def zoom_to_feature(self, qtable):

        feature_type = tools_qt.get_combo_value(self.dlg_lot, self.visit_class, 2).lower()
        selected_list = qtable.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return

        index = selected_list[0]
        row = index.row()
        column_index = tools_qt.get_col_index_by_col_name(qtable, feature_type + '_id')
        feature_id = index.sibling(row, column_index).data()
        expr_filter = "\"" + str(feature_type) + "_id\" IN ('" + str(feature_id) + "')"

        # Check expression
        (is_valid, expr) = tools_qt.check_expression_filter(expr_filter)

        tools_qgis.select_features_by_ids(feature_type, expr)
        self.iface.actionZoomActualSize().trigger()

        layer = self.iface.activeLayer()
        features = layer.selectedFeatures()

        for f in features:
            if feature_type == 'arc':
                list_coord = f.geometry().asPolyline()
            else:
                return
            break

        coords = "LINESTRING( "
        for c in list_coord:
            coords += c[0] + " " + c[1] + ","
        coords = coords[:-1] + ")"
        list_coord = re.search('\((.*)\)', str(coords))
        points = self.get_points(list_coord)
        self.draw_polyline(points)

    def manage_rejected(self):

        tools_qgis.disconnect_signal_selection_changed()
        layer = self.iface.activeLayer()
        if layer:
            layer.removeSelection()
        tools_gw.save_settings(self.dlg_lot)
        self.save_user_values(self.dlg_lot)
        self.iface.actionPan().trigger()
        tools_gw.close_dialog(self.dlg_lot)

    def draw_polyline(self, points, color=QColor(255, 0, 0, 100), width=5, duration_time=None):
        """ Draw 'line' over canvas following list of points """

        self.rb_red.reset()
        rb = self.rb_red
        if Qgis.QGIS_VERSION_INT < 29900:
            polyline = QgsGeometry.fromPolyline(points)
        else:
            polyline = QgsGeometry.fromPolylineXY(points)
        rb.setToGeometry(polyline, None)
        rb.setColor(color)
        rb.setWidth(width)
        rb.show()

    def get_points(self, list_coord=None):
        """ Return list of points taken from geometry
        :type list_coord: list of coors in format ['x1 y1', 'x2 y2',....,'x99 y99']
        """

        coords = list_coord.group(1)
        polygon = coords.split(',')
        points = []

        for i in range(0, len(polygon)):
            x, y = polygon[i].split(' ')
            point = QgsPointXY(float(x), float(y))
            points.append(point)
        return points

    def get_headers(self, qtable):

        headers = []
        if qtable.model() is not None:
            for x in range(0, qtable.model().columnCount()):
                headers.append(qtable.model().headerData(x, Qt.Horizontal))
        return headers

    def lot_manager(self):
        """ Button 75: Lot manager """

        # Create the dialog
        self.autocommit = True
        self.dlg_lot_man = LotManagementUi(self)
        tools_gw.load_settings(self.dlg_lot_man)
        self.load_user_values(self.dlg_lot_man)
        self.dlg_lot_man.tbl_lots.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.populate_combo_filters(self.dlg_lot_man.cmb_actuacio, 'ext_workorder_type')
        rows = tools_db.get_values_from_catalog('om_typevalue', 'lot_cat_status')
        if rows:
            rows.insert(0, ['', ''])
            tools_qt.fill_combo_values(self.dlg_lot_man.cmb_estat, rows, 1, sort_combo=False)

        # Populate combo date type
        rows = [['real_startdate', 'Data inici'], ['real_enddate', 'Data fi'], ['startdate', 'Data inici planificada'],
                ['enddate', 'Data final planificada']]
        tools_qt.fill_combo_values(self.dlg_lot_man.cmb_date_filter_type, rows, 1, sort_combo=False)

        table_object = "v_ui_om_visit_lot"

        # set timeStart and timeEnd as the min/max dave values get from model
        current_date = QDate.currentDate()
        sql = 'SELECT MIN(startdate), MAX(startdate) FROM cm.om_visit_lot'
        row = tools_db.get_rows(sql, commit=self.autocommit)

        # Ensure row contains valid data
        if row and isinstance(row, list) and row[0] and any(row[0]):  # Check if at least one value is not None
            print("entro?")
            if row[0][0]:  # MIN(startdate)
                self.dlg_lot_man.date_event_from.setDate(row[0][0])
            if row[0][1]:  # MAX(startdate)
                self.dlg_lot_man.date_event_to.setDate(row[0][1])
            else:
                self.dlg_lot_man.date_event_to.setDate(current_date)
        else:
            # Handle case when there are no valid dates
            print("No valid dates found.")
            self.dlg_lot_man.date_event_from.setDate(current_date)
            self.dlg_lot_man.date_event_to.setDate(current_date)

        # Hide button manage_load if project is WS
        if tools_gw.get_project_type() == 'ws':
            self.dlg_lot_man.btn_manage_load.hide()

        # Set a model with selected filter. Attach that model to selected table
        tools_qt.fill_table(self.dlg_lot_man.tbl_lots, self.schemaname + "." + table_object)

        # manage open and close the dialog
        self.dlg_lot_man.rejected.connect(partial(self.save_user_values, self.dlg_lot_man))
        self.dlg_lot_man.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_lot_man))

        # Set signals
        self.dlg_lot_man.btn_path.clicked.connect(partial(self.select_path, self.dlg_lot_man, 'txt_path'))
        self.dlg_lot_man.btn_export.clicked.connect(
            partial(self.export_model_to_csv, self.dlg_lot_man, self.dlg_lot_man.tbl_lots, 'txt_path', '',
                    self.lot_date_format))
        self.dlg_lot_man.tbl_lots.doubleClicked.connect(
            partial(self.open_lot, self.dlg_lot_man, self.dlg_lot_man.tbl_lots))
        self.dlg_lot_man.btn_open.clicked.connect(partial(self.open_lot, self.dlg_lot_man, self.dlg_lot_man.tbl_lots))
        self.dlg_lot_man.btn_delete.clicked.connect(partial(self.delete_lot, self.dlg_lot_man.tbl_lots))
        self.dlg_lot_man.btn_work_register.clicked.connect(self.open_work_register)
        self.dlg_lot_man.btn_manage_load.clicked.connect(self.open_load_manage)
        self.dlg_lot_man.btn_lot_selector.clicked.connect(self.LotSelectorUi)

        # Set filter events
        self.dlg_lot_man.txt_codi_ot.textChanged.connect(self.filter_lot)
        self.dlg_lot_man.cmb_actuacio.currentIndexChanged.connect(self.filter_lot)
        self.dlg_lot_man.txt_address.textChanged.connect(self.filter_lot)
        self.dlg_lot_man.cmb_estat.currentIndexChanged.connect(self.filter_lot)
        self.dlg_lot_man.chk_assignacio.stateChanged.connect(self.filter_lot)
        self.dlg_lot_man.date_event_from.dateChanged.connect(self.filter_lot)
        self.dlg_lot_man.date_event_from.dateChanged.connect(partial(self.save_date, self.dlg_lot_man.date_event_from, 'date_event_from'))
        self.dlg_lot_man.date_event_to.dateChanged.connect(self.filter_lot)
        self.dlg_lot_man.date_event_to.dateChanged.connect(partial(self.save_date, self.dlg_lot_man.date_event_to, 'date_event_to'))
        self.dlg_lot_man.cmb_date_filter_type.currentIndexChanged.connect(self.filter_lot)
        self.dlg_lot_man.cmb_date_filter_type.currentIndexChanged.connect(self.manage_date_filter)
        self.dlg_lot_man.chk_show_nulls.stateChanged.connect(self.filter_lot)

        # Get date filter vdefault (last selection)
        date_filter_vdef = QSettings().value('vdefault/date_filter')
        if date_filter_vdef:
            tools_qt.set_combo_value(self.dlg_lot_man.cmb_date_filter_type, str(date_filter_vdef), 1)

        # Open form
        self.filter_lot()

        # Set last user dates for date_event_from and date_event_to
        date_event_from = QDate.fromString(str(tools_qgis.get_plugin_settings_value("lot_manager", 'date_event_from')), 'dd/MM/yyyy')
        date_event_to = QDate.fromString(str(tools_qgis.get_plugin_settings_value("lot_manager", 'date_event_to')), 'dd/MM/yyyy')
        if date_event_from:
            tools_qt.set_calendar(self.dlg_lot_man, self.dlg_lot_man.date_event_from, date_event_from)
        if date_event_to:
            tools_qt.set_calendar(self.dlg_lot_man, self.dlg_lot_man.date_event_to, date_event_to)

        tools_gw.open_dialog(self.dlg_lot_man, dlg_name="visit_management")

    def open_load_manage(self):

        self.dlg_load_manager = LoadManagementUi()
        tools_gw.load_settings(self.dlg_load_manager)
        self.dlg_load_manager.tbl_loads.setSelectionBehavior(QAbstractItemView.SelectRows)

        # Tab 'Loads'
        self.tbl_load = self.dlg_load_manager.findChild(QTableView, "tbl_loads")
        tools_qt.set_tableview_config(self.tbl_load)

        # Add combo into column vehicle_id
        sql = ("SELECT id, idval"
               " FROM ext_cat_vehicle"
               " ORDER BY id")
        combo_values = tools_db.get_rows(sql, commit=True)

        # Populate cmb_vehicle on tab Loads
        self.dlg_load_manager.cmb_filter_vehicle.addItem('', '')
        tools_qt.fill_combo_values(self.dlg_load_manager.cmb_filter_vehicle, combo_values, 1, combo_clear=False)

        tools_gw.add_icon(self.dlg_load_manager.btn_open_image, "136b")
        print("hola2")
        self.dlg_load_manager.btn_open_image.clicked.connect(partial(self.open_load_image, self.tbl_load, 'cm.v_ui_om_vehicle_x_parameters'))

        # @setEditStrategy: 0: OnFieldChange, 1: OnRowChange, 2: OnManualSubmit
        print("hola3")
        tools_qt.fill_table(self.dlg_load_manager.tbl_loads, 'cm.v_ui_om_vehicle_x_parameters', QSqlTableModel.OnManualSubmit)
        print("hola4")
        tools_gw.set_tablemodel_config(self.dlg_load_manager, self.dlg_load_manager.tbl_loads, 'cm.v_ui_om_vehicle_x_parameters')
        self.dlg_load_manager.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_load_manager))
        self.dlg_load_manager.rejected.connect(partial(tools_gw.save_settings, self.dlg_load_manager))
        self.dlg_load_manager.cmb_filter_vehicle.currentIndexChanged.connect(partial(self.filter_loads))
        self.dlg_load_manager.btn_path.clicked.connect(partial(self.select_path, self.dlg_load_manager, 'txt_path'))

        self.dlg_load_manager.btn_export_load.clicked.connect(partial(self.export_model_to_csv, self.dlg_load_manager, self.tbl_load, 'txt_path', '', 'yyyy-MM-dd hh:mm:ss'))

        # Hide columns tbl_loads on load tab
        self.hide_colums(self.dlg_load_manager.tbl_loads, [0])

        # Open dialog
        tools_gw.open_dialog(self.dlg_load_manager)

    def open_work_register(self):

        self.dlg_work_register = WorkManagementUi()
        tools_gw.load_settings(self.dlg_work_register)
        self.dlg_work_register.tbl_work.setSelectionBehavior(QAbstractItemView.SelectRows)

        # Set a model with selected filter. Attach that model to selected table
        table_object = 'v_om_lot_x_user'
        tools_qt.fill_table(self.dlg_work_register.tbl_work, f"{self.schemaname}.{table_object}")

        # Set filter events
        self.dlg_work_register.txt_team_filter.textChanged.connect(self.filter_team)

        # set timeStart and timeEnd as the min/max dave values get from model
        current_date = QDate.currentDate()
        sql = "SELECT MIN(starttime), MAX(endtime) from cm.om_visit_lot_x_user"
        row = tools_db.get_rows(sql)
        if row:
            if row[0]:
                self.dlg_work_register.date_event_from.setDate(row[0])
            self.dlg_work_register.date_event_to.setDate(current_date)

        # Get columns to ignore for tab_relations when export csv
        sql = ("SELECT columnname "
               "FROM config_form_tableview "
               "WHERE location_type = 'tbl_user' AND visible IS NOT TRUE AND objectname = 'om_visit_lot_x_user'")
        rows = tools_db.get_rows(sql, log_info=False)
        result_relation = []
        if rows:
            for row in rows:
                result_relation.append(row[0])

        self.dlg_work_register.btn_export_user.clicked.connect(partial(self.export_model_to_csv, self.dlg_work_register,
                                                                       self.dlg_work_register.tbl_work, 'txt_path',
                                                                       result_relation, 'dd-MM-yyyy hh:mm:ss'))

        # Set listeners
        self.dlg_work_register.btn_path.clicked.connect(partial(self.select_path, self.dlg_work_register, 'txt_path'))
        self.dlg_work_register.btn_accept.clicked.connect(partial(self.accept_work_register, self.dlg_work_register.tbl_work))
        self.dlg_work_register.date_event_from.dateChanged.connect(self.filter_team)
        self.dlg_work_register.date_event_to.dateChanged.connect(self.filter_team)

        # Open form
        self.dlg_work_register.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_work_register.show()

    def accept_work_register(self, widget):

        model = widget.model()
        status = model is not None and model.submitAll()
        if not status:
            return

        # Close dialog
        tools_gw.close_dialog(self.dlg_work_register)

    def filter_team(self):

        # Refresh model with selected filter
        filter = tools_qt.get_text(self.dlg_work_register, self.dlg_work_register.txt_team_filter)
        if filter == 'null':
            filter = ''

        visit_start = self.dlg_work_register.date_event_from.date()
        visit_end = self.dlg_work_register.date_event_to.date()
        if visit_start > visit_end:
            message = "Selected date interval is not valid"
            tools_qgis.show_warning(message)
            return

        # Create interval dates
        format_low = f"{self.lot_date_format} 00:00:00.000"
        format_high = f"{self.lot_date_format} 23:59:59.999"
        interval = f"'{visit_start.toString(format_low)}'::timestamp AND '{visit_end.toString(format_high)}'::timestamp"
        expr_filter = (f'("Data inici" BETWEEN {interval} OR "Data inici" IS NULL) '
                       f'AND ("Data fi" BETWEEN {interval} OR "Data fi" IS NULL) ')
        expr_filter += ' AND "Equip"::text LIKE ' + str("'%") + str(filter) + str("%'") + ''

        self.dlg_work_register.tbl_work.model().setFilter(expr_filter)
        self.dlg_work_register.tbl_work.model().select()

    def filter_loads(self):

        # Refresh model with selected filter
        filter = tools_qt.get_text(self.dlg_load_manager, self.dlg_load_manager.cmb_filter_vehicle)

        if filter == 'null':
            expr_filter = ''
        else:
            expr_filter = " vehicle = '" + str(filter) + "'"

        self.dlg_load_manager.tbl_loads.model().setFilter(expr_filter)
        self.dlg_load_manager.tbl_loads.model().select()

    def LotSelectorUi(self):

        self.dlg_lot_sel = LotSelectorUi()
        tools_gw.load_settings(self.dlg_lot_sel)

        self.dlg_lot_sel.btn_ok.clicked.connect(partial(tools_gw.close_dialog, self.dlg_lot_sel))
        self.dlg_lot_sel.rejected.connect(partial(tools_gw.close_dialog, self.dlg_lot_sel))
        self.dlg_lot_sel.rejected.connect(partial(tools_gw.save_settings, self.dlg_lot_sel))
        self.dlg_lot_sel.setWindowTitle("Selector de lots")
        tools_qt.set_widget_text(self.dlg_lot_sel, 'lbl_filter',
                                     self.controller.tr('Filtrar per: Lot id', context_name='labels'))
        tools_qt.set_widget_text(self.dlg_lot_sel, 'lbl_unselected',
                                     self.controller.tr('Lots disponibles:', context_name='labels'))
        tools_qt.set_widget_text(self.dlg_lot_sel, 'lbl_selected',
                                     self.controller.tr('Lots seleccionats', context_name='labels'))

        tableleft = "v_ui_om_visit_lot"
        tableright = "selector_lot"
        field_id_left = "id"
        field_id_right = "lot_id"

        hide_left = [1, 2, 4, 6, 8, 10, 11, 12, 13, 14, 15, 16]
        hide_right = [1, 2, 4, 6, 8, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

        self.populate_LotSelectorUi(self.dlg_lot_sel, tableleft, tableright, field_id_left, field_id_right,
                                hide_left, hide_right)
        self.dlg_lot_sel.btn_select.clicked.connect(partial(self.set_visible_lot_layers, True))
        self.dlg_lot_sel.btn_unselect.clicked.connect(partial(self.set_visible_lot_layers, True))

        # Open dialog
        tools_gw.open_dialog(self.dlg_lot_sel)

    def populate_LotSelectorUi(self, dialog, tableleft, tableright, field_id_left, field_id_right, hide_left, hide_right):

        # Get rows id on table lot manager
        model = self.dlg_lot_man.tbl_lots.model()
        data = ['']
        for row in range(model.rowCount()):
            index = model.index(row, 0)
            data.append(str(model.data(index)))

        # fill QTableView all_rows
        tbl_all_rows = dialog.findChild(QTableView, "all_rows")
        tbl_all_rows.setSelectionBehavior(QAbstractItemView.SelectRows)

        query_left = "SELECT * FROM " + self.schemaname + "." + tableleft + " WHERE id NOT IN "
        query_left += "(SELECT " + tableleft + ".id FROM " + self.schemaname + "." + tableleft + ""
        query_left += " RIGHT JOIN " + self.schemaname + "." + tableright + " ON " + tableleft + "." + field_id_left + " = " + tableright + "." + field_id_right + ""
        query_left += " WHERE cur_user = current_user)"
        query_left += " AND id::text = ANY(ARRAY" + str(data) + ")"
        query_left += " AND " + field_id_left + " > -1 ORDER BY id desc"

        tools_db.fill_table_by_query(tbl_all_rows, query_left)
        self.hide_colums(tbl_all_rows, hide_left)
        tbl_all_rows.setColumnWidth(1, 200)

        # fill QTableView selected_rows
        tbl_selected_rows = dialog.findChild(QTableView, "selected_rows")
        tbl_selected_rows.setSelectionBehavior(QAbstractItemView.SelectRows)

        query_right = "SELECT  * FROM " + self.schemaname + "." + tableleft + ""
        query_right += " JOIN " + self.schemaname + "." + tableright + " ON " + tableleft + "." + field_id_left + " = " + tableright + "." + field_id_right + ""
        query_right += " WHERE cur_user = current_user AND lot_id::text = ANY(ARRAY" + str(data) + ") ORDER BY " + tableleft + ".id desc"

        tools_db.fill_table_by_query(tbl_selected_rows, query_right)
        self.hide_colums(tbl_selected_rows, hide_right)
        tbl_selected_rows.setColumnWidth(0, 200)
        # Button select
        dialog.btn_select.clicked.connect(partial(self.multi_rows_selector, tbl_all_rows, tbl_selected_rows,
                                                  field_id_left, tableright, field_id_right, query_left,
                                                  query_right, field_id_right, add_sort=False))

        # Button unselect
        query_delete = "DELETE FROM " + tableright + ""
        query_delete += " WHERE current_user = cur_user AND " + tableright + "." + field_id_right + "="
        dialog.btn_unselect.clicked.connect(partial(self.unselector, tbl_all_rows, tbl_selected_rows, query_delete,
                                                    query_left, query_right, field_id_right, add_sort=False))
        # QLineEdit
        dialog.txt_name.textChanged.connect(
            partial(self.filter_LotSelectorUi, dialog, dialog.txt_name, tbl_all_rows, tableleft, tableright,
                    field_id_right, field_id_left, data))
        dialog.txt_status_filter.textChanged.connect(
            partial(self.filter_LotSelectorUi, dialog, dialog.txt_status_filter, tbl_all_rows, tableleft, tableright,
                    field_id_right, field_id_left, data))
        dialog.txt_wotype_filter.textChanged.connect(
            partial(self.filter_LotSelectorUi, dialog, dialog.txt_wotype_filter, tbl_all_rows, tableleft, tableright,
                    field_id_right, field_id_left, data))

    def filter_LotSelectorUi(self, dialog, text_line, qtable, tableleft, tableright, field_id_r, field_id_l, filter_data):
        """ Fill the QTableView by filtering through the QLineEdit"""
        filter_id = tools_qt.get_text(dialog, dialog.txt_name)
        filter_status = tools_qt.get_text(dialog, dialog.txt_status_filter)
        filter_wotype = tools_qt.get_text(dialog, dialog.txt_wotype_filter)

        if str(filter_id) == 'null':
            filter_id = ''
        if str(filter_status) == 'null':
            filter_status = ''
        if str(filter_wotype) == 'null':
            filter_wotype = ''

        sql = ("SELECT * FROM " + self.schemaname + "." + tableleft + " WHERE id::text NOT IN "
                "(SELECT " + tableleft + ".id::text FROM " + self.schemaname + "." + tableleft + ""
                " RIGHT JOIN " + self.schemaname + "." + tableright + ""
                " ON " + tableleft + "." + field_id_l + " = " + tableright + "." + field_id_r + ""
                " WHERE cur_user = current_user) AND LOWER(id::text) LIKE '%" + str(filter_id) + "%'"
                " AND LOWER(status::text) LIKE '%" + str(filter_status) + "%'"
                " AND LOWER(id::text) = ANY(ARRAY" + str(filter_data) + ")"
                " AND (LOWER(wotype_name::text) LIKE '%" + str(filter_wotype) + "%'")
        if filter_wotype in (None, ''):
            sql += " OR LOWER(wotype_name::text) IS NULL"
        sql += " ) ORDER BY id desc"

        tools_db.fill_table_by_query(qtable, sql)

    def order_by_column(self, qtable, query, idx):
        """
        :param qtable: QTableView widget
        :param query: Query for populate QsqlQueryModel
        :param idx: The index of the clicked column
        :return:
        """
        oder_by = {0: "ASC", 1: "DESC"}
        sort_order = qtable.horizontalHeader().sortIndicatorOrder()
        col_to_sort = qtable.model().headerData(idx, Qt.Horizontal)
        query += " ORDER BY " + col_to_sort + " " + oder_by[sort_order] + ""
        tools_db.fill_table_by_query(qtable, query)
        tools_qgis.refresh_map_canvas()

    def set_visible_lot_layers(self, zoom=False):
        """ Set visible lot layers """

        # Refresh extension of layer
        layer = tools_qgis.get_layer_by_tablename("v_lot")
        if layer:
            tools_qgis.set_layer_visible(layer)
            if zoom:
                # Refresh extension of layer
                layer.updateExtents()
                # Zoom to executed mincut
                self.iface.setActiveLayer(layer)
                self.iface.zoomToActiveLayer()

    def save_user_values(self, dialog):

        cur_user = tools_db.get_current_user()
        csv_path = tools_qt.get_text(dialog, dialog.txt_path)
        tools_gw.set_config_parser("lots", dialog.objectName() + cur_user, csv_path)

    def load_user_values(self, dialog):

        cur_user = tools_db.get_current_user()
        csv_path = tools_qgis.get_plugin_settings_value(self.plugin_name, dialog.objectName() + cur_user)
        tools_qt.set_widget_text(dialog, dialog.txt_path, str(csv_path))

    def select_path(self, dialog, widget_name):

        widget = tools_qt.get_widget(dialog, str(widget_name))
        csv_path = tools_qt.get_text(dialog, widget)
        # Set default value if necessary
        if csv_path is None or csv_path == '':
            csv_path = self.plugin_dir

        # Get directory of that file
        folder_path = os.path.dirname(csv_path)
        if not os.path.exists(folder_path):
            folder_path = os.path.dirname(__file__)
        os.chdir(folder_path)
        message = self.controller.tr("Select CSV file")
        if Qgis.QGIS_VERSION_INT < 29900:
            csv_path = QFileDialog.getSaveFileName(None, message, "", '*.csv')
        else:
            csv_path, filter_ = QFileDialog.getSaveFileName(None, message, "", '*.csv')

        tools_qt.set_widget_text(dialog, widget, csv_path)

    def export_model_to_csv(self, dialog, qtable, widget_name, columns=(''), date_format='yyyy-MM-dd'):
        """
        :param columns: tuple of columns to not export ('column1', 'column2', '...')
        """

        widget = tools_qt.get_widget(dialog, str(widget_name))
        csv_path = tools_qt.get_text(dialog, widget)
        if str(csv_path) == 'null':
            msg = "Select a valid path."
            tools_qt.show_info_box(msg, "Info")
            return
        all_rows = []
        row = []
        # Get headers from model
        for h in range(0, qtable.model().columnCount()):
            if qtable.model().headerData(h, Qt.Horizontal) not in columns:
                row.append(str(qtable.model().headerData(h, Qt.Horizontal)))
        all_rows.append(row)
        # Get all rows from model
        for r in range(0, qtable.model().rowCount()):
            row = []
            for c in range(0, qtable.model().columnCount()):
                if qtable.model().headerData(c, Qt.Horizontal) not in columns:
                    value = qtable.model().data(qtable.model().index(r, c))
                    if str(value) == 'NULL':
                        value = ''
                    elif type(value) == QDate or type(value) == QDateTime:
                        value = value.toString(date_format)
                    row.append(value)
            all_rows.append(row)
        # Write list into csv file
        try:
            if os.path.exists(str(csv_path)):
                msg = "Are you sure you want to overwrite this file?"
                answer = tools_qt.show_question(msg, "Overwrite")
                if answer:
                    self.write_to_csv(csv_path, all_rows)
            else:
                self.write_to_csv(csv_path, all_rows)
        except Exception as e:
            print(str(e))
            msg = "File path doesn't exist or you dont have permission or file is opened"
            tools_qgis.show_warning(msg)
            pass

    def write_to_csv(self, folder_path=None, all_rows=None):

        with open(folder_path, "w") as output:
            writer = csv.writer(output, lineterminator='\n')
            writer.writerows(all_rows)
        message = "El fitxer csv ha estat exportat correctament"
        tools_qgis.show_info(message)

    def populate_combo_filters(self, combo, table_name, fields="id, idval"):

        sql = ("SELECT " + str(fields) + " "
               "FROM cm." + str(table_name) + " "
               "ORDER BY idval")
        rows = tools_db.get_rows(sql, commit=True)
        if rows:
            rows.append(['', ''])
            tools_qt.fill_combo_values(combo, rows, 1)

    def delete_lot(self, qtable):
        """ Delete selected lots """

        selected_list = qtable.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return
        elif len(selected_list) > 1:
            message = "Please, select only one row"
            tools_qgis.show_warning(message)
            return
        message = "Are you sure you want to delete this lot?"
        answer = tools_qt.show_question(message, "Delete lots")
        if answer:
            result = selected_list[0].row()

            # Get object_id from selected row
            selected_object_id = qtable.model().record(result).value('id')
            sql = ("SELECT id "
                   "FROM om_visit WHERE lot_id = " + str(selected_object_id) + " "
                   "ORDER BY id")
            rows = tools_db.get_rows(sql)

            if rows not in ("[]", None):
                message = "This lot has associated visits and will be deleted. Do you want to continue?"
                answer = tools_qt.show_question(message, "Delete lots")
                if not answer:
                    return

                sql = ("DELETE FROM om_visit "
                       " WHERE lot_id =" + str(selected_object_id) + "")
                tools_db.execute_sql(sql)

            for x in range(0, len(selected_list)):
                row = selected_list[x].row()
                _id = qtable.model().record(row).value('id')
                sql = ("DELETE from cm.om_visit_lot "
                       " WHERE id ='" + str(_id) + "'")
                tools_db.execute_sql(sql)
            self.filter_lot()

    def open_lot(self, dialog, qtable):
        """ Open object form with selected record of the table """

        selected_list = qtable.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return

        row = selected_list[0].row()

        # Get object_id from selected row
        selected_object_id = qtable.model().record(row).value('id')
        visitclass_id = qtable.model().record(row).value('visitclass_id')

        # Close this dialog and open selected object
        dialog.close()
        sql = ("INSERT INTO selector_lot(lot_id, cur_user) "
               " VALUES(" + str(selected_object_id) + ", current_user) "
               " ON CONFLICT DO NOTHING;")
        tools_db.execute_sql(sql)
        # set previous dialog
        self.manage_lot(selected_object_id, is_new=False, visitclass_id=visitclass_id)

    def filter_lot(self):
        """ Filter om_visit in self.dlg_lot_man.tbl_lots based on (id AND text AND between dates) """

        serie = tools_qt.get_text(self.dlg_lot_man, self.dlg_lot_man.txt_codi_ot)
        actuacio = tools_qt.get_combo_value(self.dlg_lot_man, self.dlg_lot_man.cmb_actuacio, 0)
        adreca = tools_qt.get_text(self.dlg_lot_man, self.dlg_lot_man.txt_address, False, False)
        status = tools_qt.get_combo_value(self.dlg_lot_man, self.dlg_lot_man.cmb_estat, 1)
        assignat = self.dlg_lot_man.chk_assignacio.isChecked()

        # Get show null values
        show_nulls = self.dlg_lot_man.chk_show_nulls.isChecked()

        visit_start = self.dlg_lot_man.date_event_from.date()
        visit_end = self.dlg_lot_man.date_event_to.date()

        if visit_start > visit_end:
            message = "Selected date interval is not valid"
            tools_qgis.show_warning(message)
            return

        # Create interval dates
        format_low = self.lot_date_format + ' 00:00:00.000'
        format_high = self.lot_date_format + ' 23:59:59.999'
        interval = "'" + str(visit_start.toString(format_low)) + "'::timestamp AND '" + str(visit_end.toString(format_high)) + "'::timestamp"

        expr_filter = ("(" + tools_qt.get_combo_value(self.dlg_lot_man, self.dlg_lot_man.cmb_date_filter_type, 0) + " BETWEEN " + str(interval) + " ")
        if show_nulls:
            expr_filter += " OR " + tools_qt.get_combo_value(self.dlg_lot_man, self.dlg_lot_man.cmb_date_filter_type, 0) + "  IS NULL) "
        else:
            expr_filter += ") "
        if serie != 'null':
            expr_filter += " AND serie ILIKE '%" + str(serie) + "%'"
        if actuacio != '' and actuacio != -1:
            expr_filter += " AND wotype_id ILIKE '%" + str(actuacio) + "%' "
        if adreca != '':
            expr_filter += " AND address ILIKE '%" + str(adreca) + "%' "
        if status != '':
            expr_filter += " AND status::TEXT ILIKE '%" + str(status) + "%'"
        if assignat:
            expr_filter += " AND serie IS NULL "

        # Refresh model with selected filter
        self.dlg_lot_man.tbl_lots.model().setFilter(expr_filter)
        self.dlg_lot_man.tbl_lots.model().select()

    def check_for_ids(self):
        row_count = self.dlg_lot.tbl_relation.model().rowCount()
        self.assiged_to = tools_qt.get_combo_value(self.dlg_lot, self.dlg_lot.cmb_assigned_to, 0)
        if row_count != 0:
            self.visit_class.setEnabled(False)
            self.filter_cmb_team()
        else:
            self.populate_cmb_team()
            layer = self.iface.activeLayer()
            if layer:
                layer.removeSelection()
            self.iface.actionPan().trigger()
            self.visit_class.setEnabled(True)

        # Set team_id
        tools_qt.set_combo_value(self.dlg_lot.cmb_assigned_to, str(self.assiged_to), 0)

    """ FUNCTIONS RELATED WITH TAB LOAD"""
    def fill_tab_load(self):
        """ Fill tab 'Load' """
        print("hola5")
        table_load = "cm.v_ui_om_vehicle_x_parameters"
        filter = "lot_id = '" + str(tools_qt.get_text(self.dlg_lot, self.dlg_lot.lot_id)) + "'"

        self.fill_tbl_load_man(self.dlg_lot, self.tbl_load, table_load, filter)
        self.set_columns_config(self.tbl_load, table_load)

    def set_columns_config(self, widget, table_name, sort_order=0, isQStandardItemModel=False):
        """ Configuration of tables. Set visibility and width of columns """

        # Set width and alias of visible columns
        columns_to_delete = []
        sql = ("SELECT columnindex, width, alias, visible"
               " FROM config_form_tableview"
               " WHERE objectname = '" + table_name + "'"
               " ORDER BY columnindex")
        rows = tools_db.get_rows(sql, log_info=False)
        if not rows:
            return widget

        for row in rows:
            if not row['visible']:
                columns_to_delete.append(row['columnindex'] - 1)
            else:
                width = row['width']
                if width is None:
                    width = 100
                widget.setColumnWidth(row['columnindex'] - 1, width)
                if row['alias'] is not None:
                    widget.model().setHeaderData(row['columnindex'] - 1, Qt.Horizontal, row['alias'])

        # Set order
        if isQStandardItemModel:
            widget.model().sort(sort_order, Qt.AscendingOrder)
        else:
            widget.model().setSort(sort_order, Qt.AscendingOrder)
            widget.model().select()
        # Delete columns
        for column in columns_to_delete:
            widget.hideColumn(column)

        return widget

    def fill_tbl_load_man(self, dialog, widget, table_name, expr_filter):
        """ Fill the table control to show documents """

        # Get widgets
        self.date_load_to = self.dlg_lot.findChild(QDateEdit, "date_load_to")
        self.date_load_from = self.dlg_lot.findChild(QDateEdit, "date_load_from")

        # Set model of selected widget
        self.set_model_to_table(widget, table_name, expr_filter)

    def open_load_image(self, qtable, pg_table):

        selected_list = qtable.selectionModel().selectedRows(0)

        if selected_list == 0 or str(selected_list) == '[]':
            message = "Any load selected"
            tools_qt.show_info_box(message)
            return

        elif len(selected_list) > 1:
            message = "More then one event selected. Select just one"
            tools_qgis.show_warning(message)
            return

        # Get path of selected image
        sql = ("SELECT image FROM " + pg_table + ""
               " WHERE rid = '" + str(selected_list[0].data()) + "'")
        row = tools_db.get_rows(sql, commit=True)
        if not row:
            return

        path = str(row[0])

        # Parse a URL into components
        url = parse.urlsplit(path)

        # Open selected image
        # Check if path is URL
        if url.scheme == "http" or url.scheme == "https":
            # If path is URL open URL in browser
            webbrowser.open(path)
        else:
            # If its not URL ,check if file exist
            if not os.path.exists(path):
                message = "File not found"
                tools_qgis.show_warning(message, parameter=path)
            else:
                # Open the image
                os.startfile(path)

    def resources_management(self):

        # Create the dialog
        self.dlg_resources_man = ResourcesManagementUi(self)
        tools_gw.load_settings(self.dlg_resources_man)

        # Populate combos
        sql = ("SELECT id, idval FROM cm.cat_team WHERE active is True ORDER BY idval")
        rows = tools_db.get_rows(sql)
        if rows:
            tools_qt.fill_combo_values(self.dlg_resources_man.cmb_team, rows, 1)

        sql = ("SELECT id, idval FROM cm.ext_cat_vehicle ORDER BY idval")
        rows = tools_db.get_rows(sql)
        if rows:
            tools_qt.fill_combo_values(self.dlg_resources_man.cmb_vehicle, rows, 1)

        self.populate_team_views()
        self.populate_vehicle_views()

        # Set signals
        self.dlg_resources_man.cmb_team.currentIndexChanged.connect(self.populate_team_views)
        self.dlg_resources_man.cmb_vehicle.currentIndexChanged.connect(self.populate_vehicle_views)

        self.dlg_resources_man.btn_team_create.clicked.connect(partial(self.create_team))
        self.dlg_resources_man.btn_team_update.clicked.connect(partial(self.manage_team))
        self.dlg_resources_man.btn_team_selector.clicked.connect(partial(self.open_team_selector))
        self.dlg_resources_man.btn_team_delete.clicked.connect(partial(self.delete_team))

        self.dlg_resources_man.btn_vehicle_create.clicked.connect(partial(self.create_vehicle))
        self.dlg_resources_man.btn_vehicle_update.clicked.connect(partial(self.manage_vehicle))
        self.dlg_resources_man.btn_vehicle_delete.clicked.connect(partial(self.delete_vehicle))

        self.dlg_resources_man.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_resources_man))
        self.dlg_resources_man.rejected.connect(partial(tools_gw.save_settings, self.dlg_resources_man))

        # Open form
        tools_gw.open_dialog(self.dlg_resources_man)

    def populate_team_views(self):

        # Get team selected
        team_name = tools_qt.get_text(self.dlg_resources_man, self.dlg_resources_man.cmb_team)

        # Populate tables
        query = ("SELECT user_id AS " + '"' + "Usuari" + '"' + ", user_name AS " + '"' + "Nom" + '"' + " FROM cm.v_om_team_x_user WHERE team = '" + str(team_name) + "'")
        tools_db.fill_table_by_query(self.dlg_resources_man.tbl_view_team_user, query)

        query = ("SELECT vehicle  AS " + '"' + "Vehicle" + '"' + " FROM cm.v_om_team_x_vehicle WHERE team = '" + str(team_name) + "'")
        tools_db.fill_table_by_query(self.dlg_resources_man.tbl_view_team_vehicle, query)

        query = ("SELECT visitclass  AS " + '"' + "Classe visita" + '"' + " FROM cm.v_om_team_x_visitclass WHERE team = '" + str(team_name) + "'")
        tools_db.fill_table_by_query(self.dlg_resources_man.tbl_view_team_visitclass, query)

    def populate_vehicle_views(self):

        # Get vehicle selected
        vehicle_name = tools_qt.get_text(self.dlg_resources_man, self.dlg_resources_man.cmb_vehicle)

        # Populate tables
        query = ("SELECT * FROM cm.v_ext_cat_vehicle WHERE idval = '" + str(vehicle_name) + "'")
        tools_db.fill_table_by_query(self.dlg_resources_man.tbl_view_vehicle, query)
        self.hide_colums(self.dlg_resources_man.tbl_view_vehicle, [0])

    def open_team_selector(self):

        # Create the dialog
        self.dlg_team_man = TeamManagemenUi(self)
        tools_gw.load_settings(self.dlg_team_man)

        # Set signals
        self.dlg_team_man.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_team_man))
        self.dlg_team_man.rejected.connect(partial(tools_gw.save_settings, self.dlg_team_man))
        self.dlg_team_man.btn_close.clicked.connect(partial(self.populate_team_views))
        self.dlg_team_man.rejected.connect(partial(self.populate_team_views))

        # Tab Users
        self.populate_team_selectors(self.dlg_team_man, "cat_users", "v_om_team_x_user", "id", "user_id", "Usuaris",
                                     [], [], "all_user_rows", "selected_user_rows", "btn_user_select", "btn_user_unselect",
                                     'id AS "Usuaris", name AS "Nom", context AS "Context"', 'user_id AS "Usuaris", name AS "Nom", context AS "Context"')
        # Tab Vehciles
        self.populate_team_selectors(self.dlg_team_man, "ext_cat_vehicle", "v_om_team_x_vehicle", "idval", "vehicle", "Vehicle",
                                     [], [], "all_vehicle_rows", "selected_vehicle_rows", "btn_vehicle_select",
                                     "btn_vehicle_unselect", 'idval AS "Vehicle", descript AS "Descripcio", model AS "Model", number_plate AS "Matricula"',
                                     'vehicle AS "Vehicle", descript AS "Descripcio", model AS "Model", number_plate AS "Matricula"')
        # Tab Visitclass
        self.populate_team_selectors(self.dlg_team_man, "config_visit_class", "v_om_team_x_visitclass", "idval",
                                     "visitclass", "Classe visita", [], [],
                                     "all_visitclass_rows", "selected_visitclass_rows", "btn_visitclass_select",
                                     "btn_visitclass_unselect", 'idval AS "Classe visita", descript AS "Descripcio"',
                                     'idval AS "Classe visita", descript AS "Descripcio"')
        # Open forms
        tools_gw.open_dialog(self.dlg_team_man)

    def populate_team_selectors(self, dialog, tableleft, tableright, field_id_left, field_id_right, alias,
                                hide_left, hide_right, table_all, table_selected, button_select, button_unselect,
                                parameters_left, parameters_right):

        # Get team selected
        filter_team = tools_qt.get_text(self.dlg_resources_man, "cmb_team")

        # Set window title
        dialog.setWindowTitle("Administrador d'equips - " + str(filter_team))

        # Get widgets
        btn_select = dialog.findChild(QPushButton, button_select)
        btn_unselect = dialog.findChild(QPushButton, button_unselect)

        # fill QTableView all_rows
        tbl_all_rows = dialog.findChild(QTableView, table_all)
        tbl_all_rows.setSelectionBehavior(QAbstractItemView.SelectRows)

        query_left = "SELECT " + str(parameters_left) + " FROM " + self.schemaname + "." + tableleft + " WHERE id NOT IN "
        query_left += "(SELECT " + tableleft + ".id FROM " + self.schemaname + "." + tableleft + ""
        query_left += " RIGHT JOIN " + self.schemaname + "." + tableright + " ON " + tableleft + "." + field_id_left + "::text = " + tableright + "." + field_id_right + "::text"
        query_left += " WHERE team = '" + str(filter_team) + "')"
        if tableleft == 'config_visit_class':
            query_left += " AND visit_type = 1"

        tools_db.fill_table_by_query(tbl_all_rows, query_left)
        self.hide_colums(tbl_all_rows, hide_left)
        tbl_all_rows.setColumnWidth(1, 200)

        # fill QTableView selected_rows
        tbl_selected_rows = dialog.findChild(QTableView, table_selected)
        tbl_selected_rows.setSelectionBehavior(QAbstractItemView.SelectRows)

        query_right = "SELECT " + str(parameters_right) + " FROM " + self.schemaname + "." + tableleft + ""
        query_right += " JOIN " + self.schemaname + "." + tableright + " ON " + tableleft + "." + field_id_left + "::text = " + tableright + "." + field_id_right + "::text"
        query_right += " WHERE team = '" + str(filter_team) + "'"

        tools_db.fill_table_by_query(tbl_selected_rows, query_right)
        self.hide_colums(tbl_selected_rows, hide_right)
        tbl_selected_rows.setColumnWidth(0, 200)
        # Button select
        btn_select.clicked.connect(
            partial(self.multi_rows_team_selector, tbl_all_rows, tbl_selected_rows, alias, tableright,
                    field_id_right, query_left, query_right, field_id_right, filter_team))

        # Button unselect
        btn_unselect.clicked.connect(
            partial(self.team_unselector, tbl_all_rows, tbl_selected_rows, query_left, query_right,
                    field_id_right, alias, tableright, tableleft, filter_team))

    def multi_rows_team_selector(self, qtable_left, qtable_right, id_ori,
                            tablename_des, id_des, query_left, query_right, field_id, filter_team):
        """
            :param qtable_left: QTableView origin
            :param qtable_right: QTableView destini
            :param id_ori: Refers to the id of the source table
            :param tablename_des: table destini
            :param id_des: Refers to the id of the target table, on which the query will be made
            :param query_right:
            :param query_left:
            :param field_id:
        """

        selected_list = qtable_left.selectionModel().selectedRows()

        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return
        id_list = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = qtable_left.model().record(row).value(id_ori)
            id_list.append(id_)
        for i in range(0, len(id_list)):
            # Check if id_list already exists in id_selector
            sql = ("SELECT DISTINCT(" + id_des + ")"
                   " FROM " + self.schemaname + "." + tablename_des + ""
                   " WHERE " + id_des + " = '" + str(id_list[i]) + "' AND team = '" + filter_team + "'")
            row = tools_db.get_rows(sql)

            if row:
                # if exist - show warning
                message = "Id already selected"
                tools_qt.show_info_box(message, "Info", parameter=str(id_list[i]))
            else:
                sql = ("INSERT INTO " + self.schemaname + "." + tablename_des + " (" + field_id + ", team) "
                       " VALUES ('" + str(id_list[i]) + "', '" + filter_team + "')")
                tools_db.execute_sql(sql)

        # Refresh
        tools_db.fill_table_by_query(qtable_right, query_right)
        tools_db.fill_table_by_query(qtable_left, query_left)

    def team_unselector(self, qtable_left, qtable_right, query_left, query_right, field_id_right, alias, tableright, tableleft, filter_team):

        selected_list = qtable_right.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return
        expl_id = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = str(qtable_right.model().record(row).value(alias))
            expl_id.append(id_)
        for i in range(0, len(expl_id)):
            query_delete = "DELETE FROM " + tableright + ""
            query_delete += " WHERE " + tableright + "." + field_id_right + "= '" + str(expl_id[i]) + "' "
            query_delete += " AND team = '" + str(filter_team) + "'"

            tools_db.execute_sql(query_delete)

        # Refresh
        tools_db.fill_table_by_query(qtable_left, query_left)
        tools_db.fill_table_by_query(qtable_right, query_right)

    def delete_team(self):

        # Get team selected
        filter_team = tools_qt.get_text(self.dlg_resources_man, "cmb_team")
        message = "You are trying delete team '" + str(filter_team) + "'. Do you want continue?"
        answer = tools_qt.show_question(message, "Delete team")
        if answer:
            sql = ("SELECT * FROM om_vehicle_x_parameters JOIN cat_team ON cat_team.id = om_vehicle_x_parameters.team_id WHERE cat_team.idval = '" + str(filter_team) + "'")
            rows = tools_db.get_rows(sql, log_sql=True)
            if rows:
                msg = "This team have some relations on om_vehicle_x_parameters table. Abort delete transaction."
                tools_qt.show_info_box(msg, "Info")
                return
            sql = ("DELETE FROM cm.cat_team WHERE idval = '" + str(filter_team) + "'")
            status = tools_db.execute_sql(sql)
            if status:
                msg = "Successful removal."
                tools_qt.show_info_box(msg, "Info")
                sql = ("SELECT id, idval FROM cm.cat_team WHERE active is True ORDER BY idval")
                rows = tools_db.get_rows(sql, commit=True)
                if rows:
                    tools_qt.fill_combo_values(self.dlg_resources_man.cmb_team, rows, 1)

    def delete_vehicle(self):

        # Get vehicle selected
        filter_vehicle = tools_qt.get_text(self.dlg_resources_man, "cmb_vehicle")
        message = "You are trying delete vehicle '" + str(filter_vehicle) + "'. Do you want continue?"
        answer = tools_qt.show_question(message, "Delete vehicle")
        if answer:
            sql = ("DELETE FROM ext_cat_vehicle WHERE idval = '" + str(filter_vehicle) + "'")
            tools_db.execute_sql(sql)
            msg = "Successful removal."
            tools_qt.show_info_box(msg, "Info")
            sql = ("SELECT id, idval FROM ext_cat_vehicle ORDER BY idval")
            rows = tools_db.get_rows(sql, commit=True)
            if rows:
                tools_qt.fill_combo_values(self.dlg_resources_man.cmb_vehicle, rows, 1)
            else:
                self.dlg_resources_man.cmb_vehicle.clear()

            # Populate table_view vehicle
            self.populate_vehicle_views()

    def manage_vehicle(self):
        """ Open dialog of teams """

        self.dlg_basic_table = DialogTableUi()
        tools_gw.load_settings(self.dlg_basic_table)
        self.dlg_basic_table.setWindowTitle("Administrador de vehicles")
        table_name = 'v_ext_cat_vehicle'

        # @setEditStrategy: 0: OnFieldChange, 1: OnRowChange, 2: OnManualSubmit
        tools_qt.fill_table(self.dlg_basic_table.tbl_basic, table_name, QSqlTableModel.OnManualSubmit)
        tools_gw.set_tablemodel_config(self.dlg_basic_table, self.dlg_basic_table.tbl_basic, table_name)
        self.dlg_basic_table.btn_cancel.clicked.connect(partial(self.cancel_changes, self.dlg_basic_table.tbl_basic))
        self.dlg_basic_table.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_basic_table))
        self.dlg_basic_table.btn_accept.clicked.connect(
            partial(self.save_table, self.dlg_basic_table, self.dlg_basic_table.tbl_basic, manage_type='vehicle'))
        self.dlg_basic_table.btn_accept.clicked.connect(partial(tools_gw.close_dialog, self.dlg_basic_table))
        self.dlg_basic_table.rejected.connect(partial(tools_gw.save_settings, self.dlg_basic_table))

        # Rename widgets labels
        self.dlg_basic_table.btn_accept.setText('Acceptar')
        self.dlg_basic_table.btn_cancel.setText('Cancel·lar')

        self.dlg_basic_table.btn_add_row.setVisible(False)

        tools_gw.open_dialog(self.dlg_basic_table)

    def manage_date_filter(self):

        # Get date type
        date_type = tools_qt.get_text(self.dlg_lot_man, self.dlg_lot_man.cmb_date_filter_type)

        settings = QSettings()
        settings.setValue("vdefault/date_filter", str(date_type))

    def refresh_materialize_view(self):

        sql = ("REFRESH MATERIALIZED VIEW ext_workorder WITH DATA;")
        tools_db.execute_sql(sql)
        msg = "Data updated successfully."
        tools_qgis.show_info(msg)

        # Refresh combo work_order
        self.manage_widget_lot(None)
        self.set_ot_fields(0)

    def save_date(self, widget, key):

        # Manage date_from, date_to and save into settings variables
        date = tools_qt.get_calendar_date(self.dlg_lot_man, widget, 'dd/MM/yyyy')
        tools_gw.set_config_parser("lots", key, str(date))

    def hide_colums(self, widget, comuns_to_hide):
        for i in range(0, len(comuns_to_hide)):
            widget.hideColumn(comuns_to_hide[i])

    def unselector(self, qtable_left, qtable_right, query_delete, query_left, query_right, field_id_right, add_sort=True):

        selected_list = qtable_right.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        expl_id = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = str(qtable_right.model().record(row).value(field_id_right))
            expl_id.append(id_)
        for i in range(0, len(expl_id)):
            self.controller.execute_sql(query_delete + str(expl_id[i]))

        # Refresh
        if add_sort is True:
            oder_by = {0: "ASC", 1: "DESC"}
            sort_order = qtable_left.horizontalHeader().sortIndicatorOrder()
            idx = qtable_left.horizontalHeader().sortIndicatorSection()
            col_to_sort = qtable_left.model().headerData(idx, Qt.Horizontal)
            query_left += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
        self.fill_table_by_query(qtable_left, query_left)
        if add_sort is True:
            sort_order = qtable_right.horizontalHeader().sortIndicatorOrder()
            idx = qtable_right.horizontalHeader().sortIndicatorSection()
            col_to_sort = qtable_right.model().headerData(idx, Qt.Horizontal)
            query_right += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
        self.fill_table_by_query(qtable_right, query_right)
        self.refresh_map_canvas()

    def set_model_to_table(self, widget, table_name, expr_filter):
        """ Set a model with selected filter.
        Attach that model to selected table """

        # Set model
        model = QSqlTableModel()
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.setFilter(expr_filter)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            tools_qgis.show_warning(model.lastError().text())

        # Attach model to table view
        if widget:
            widget.setModel(model)
        else:
            tools_log.log_info("set_model_to_table: widget not found")

    def multi_rows_selector(self, qtable_left, qtable_right, id_ori,
                            tablename_des, id_des, query_left, query_right, field_id, add_sort=True):
        """
            :param qtable_left: QTableView origin
            :param qtable_right: QTableView destini
            :param id_ori: Refers to the id of the source table
            :param tablename_des: table destini
            :param id_des: Refers to the id of the target table, on which the query will be made
            :param query_right:
            :param query_left:
            :param field_id:
        """

        selected_list = qtable_left.selectionModel().selectedRows()

        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        expl_id = []
        curuser_list = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = qtable_left.model().record(row).value(id_ori)
            expl_id.append(id_)
            curuser = qtable_left.model().record(row).value("cur_user")
            curuser_list.append(curuser)
        for i in range(0, len(expl_id)):
            # Check if expl_id already exists in expl_selector
            sql = (f"SELECT DISTINCT({id_des}, cur_user)"
                   f" FROM {tablename_des}"
                   f" WHERE {id_des} = '{expl_id[i]}' AND cur_user = current_user")
            row = self.controller.get_row(sql)

            if row:
                # if exist - show warning
                message = "Id already selected"
                self.controller.show_info_box(message, "Info", parameter=str(expl_id[i]))
            else:
                sql = (f"INSERT INTO {tablename_des} ({field_id}, cur_user) "
                       f" VALUES ({expl_id[i]}, current_user)")
                self.controller.execute_sql(sql)

        # Refresh
        if add_sort is True:
            oder_by = {0: "ASC", 1: "DESC"}
            sort_order = qtable_left.horizontalHeader().sortIndicatorOrder()
            idx = qtable_left.horizontalHeader().sortIndicatorSection()
            col_to_sort = qtable_left.model().headerData(idx, Qt.Horizontal)
            query_left += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
        self.fill_table_by_query(qtable_right, query_right)

        if add_sort is True:
            sort_order = qtable_right.horizontalHeader().sortIndicatorOrder()
            idx = qtable_right.horizontalHeader().sortIndicatorSection()
            col_to_sort = qtable_right.model().headerData(idx, Qt.Horizontal)
            query_right += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
        self.fill_table_by_query(qtable_left, query_left)
        self.refresh_map_canvas()

    def query_like_widget_text(self, dialog, text_line, qtable, tableleft, tableright, field_id_r, field_id_l,
                               name='name', aql=''):
        """ Fill the QTableView by filtering through the QLineEdit"""

        schema_name = self.schemaname.replace('"', '')
        query = utils_giswater.getWidgetText(dialog, text_line, return_string_null=False).lower()
        sql = (f"SELECT * FROM {schema_name}.{tableleft} WHERE {name} NOT IN "
               f"(SELECT {tableleft}.{name} FROM {schema_name}.{tableleft}"
               f" RIGHT JOIN {schema_name}.{tableright}"
               f" ON {tableleft}.{field_id_l} = {tableright}.{field_id_r}"
               f" WHERE cur_user = current_user) AND LOWER({name}::text) LIKE '%{query}%'"
               f"  AND  {field_id_l} > -1")
        sql += aql
        self.fill_table_by_query(qtable, sql)

    def create_action(self, action_name, action_group, icon_num=None, text=None):
        """ Creates a new action with selected parameters """

        icon = None
        icon_folder = self.plugin_dir + '/icons/'
        icon_path = icon_folder + icon_num + '.png'
        if os.path.exists(icon_path):
            icon = QIcon(icon_path)

        if icon is None:
            action = QAction(text, action_group)
        else:
            action = QAction(icon, text, action_group)
        action.setObjectName(action_name)

        return action
