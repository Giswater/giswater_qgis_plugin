"""
This file is part of Pavements
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
from qgis.PyQt.QtWidgets import QAbstractItemView, QAction, QCheckBox, QComboBox, QCompleter, QFileDialog, \
    QHBoxLayout, QLineEdit, QTableView, QToolButton, QWidget, QDateEdit, QPushButton, QMenu, QActionGroup
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
from .... import global_vars

from ....libs import lib_vars, tools_qgis, tools_qt, tools_db, tools_pgdao, tools_log
from ...utils import tools_gw
from ..dialog import GwAction

class Campaign:

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        self.ids = []
        self.canvas = global_vars.canvas
        self.campaign_date_format = 'yyyy-MM-dd'
        self.max_id = 0
        self.param_options = None
        self.plugin_name = 'Giswater'
        self.plugin_dir = lib_vars.plugin_dir
        self.schemaname = lib_vars.schema_name
        self.iface = global_vars.iface



    def create_campaign(self, campaign_id=None, is_new=True, class_id=None):
        """Manage the creation or update of a lot by initializing and configuring the dialog UI,
        setting up layers, actions, signals, and loading necessary data (including project-specific settings)
        before finally opening the dialog for user interaction."""

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
            self.layers['gully'] = [tools_qgis.get_layer_by_tablename('v_edit_gully')]

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

        tools_qt.check_date(self.dlg_lot.startdate, self.dlg_lot.btn_accept, 1)
        tools_qt.check_date(self.dlg_lot.enddate, self.dlg_lot.btn_accept, 1)
        tools_qt.check_date(self.dlg_lot.real_startdate, self.dlg_lot.btn_accept, 1)
        tools_qt.check_date(self.dlg_lot.real_enddate, self.dlg_lot.btn_accept, 1)
        self.dlg_lot.enddate.textChanged.connect(self.check_dates_consistency)

        self.lot_id = self.dlg_lot.findChild(QLineEdit, "lot_id")
        self.user_name = self.dlg_lot.findChild(QLineEdit, "user_name")

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

        new_lot_id = lot_id
        if lot_id is None:
            new_lot_id = self.get_next_id('om_visit_lot', 'id')
        tools_qt.set_widget_text(self.dlg_lot, self.lot_id, new_lot_id)


        if self.feature_type != '':
            viewname = "v_edit_" + self.feature_type.currentText()
            tools_gw.set_completer_feature_id(self.dlg_lot.feature_id, self.feature_type.currentText(), viewname)
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

        if lot_id is not None and visitclass_id not in (None, '', 'NULL'):
            self.set_values(lot_id)
            self.update_id_list()

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

        # Get columns to ignore for tab_relations when export csv
        sql = "SELECT columnname FROM config_form_tableview WHERE location_type = 'lot' AND visible IS NOT TRUE AND objectname = 've_lot_x_"+str(self.feature_type)+"'"
        rows = tools_db.get_rows(sql)
        result_relation = []
        if rows is not None:
            for row in rows:
                result_relation.append(row[0])
        else:
            result = ''

        # Set listeners for export csv
        self.dlg_lot.btn_export_rel.clicked.connect(
            partial(self.export_model_to_csv, self.dlg_lot, self.dlg_lot.tbl_relation, 'txt_path_rel', result_relation,
                    self.lot_date_format))
        self.dlg_lot.btn_path.clicked.connect(partial(self.select_path, self.dlg_lot, 'txt_path'))
        self.dlg_lot.btn_path_rel.clicked.connect(partial(self.select_path, self.dlg_lot, 'txt_path_rel'))
        self.check_for_ids()

        # Open the dialog
        tools_gw.open_dialog(self.dlg_lot, dlg_name="add_lot")





