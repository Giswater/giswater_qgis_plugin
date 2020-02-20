# -*- coding: utf-8 -*-
"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""



try:
    from qgis.core import Qgis
except ImportError:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT < 29900:
    from qgis.core import QgsPoint as QgsPointXY
    from qgis.PyQt.QtGui import QStringListModel
else:
    from qgis.core import QgsPointXY
    from qgis.PyQt.QtCore import QStringListModel

from qgis.PyQt.QtCore import QDate, QSortFilterProxyModel, Qt, QDateTime, QSettings
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
import urlparse as parse
import webbrowser
import json


from .. import utils_giswater
from .manage_visit import ManageVisit
from .parent_manage import ParentManage
from ..ui_manager import AddLot
from ..ui_manager import Lot_selector
from ..ui_manager import BasicTable
from ..ui_manager import LoadManagement
from ..ui_manager import LotManagement
from ..ui_manager import WorkManagement
from ..ui_manager import ResourcesManagement
from ..ui_manager import TeamManagement


class AddNewLot(ParentManage):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control 'Add basic visit' of toolbar 'edit' """

        ParentManage.__init__(self, iface, settings, controller, plugin_dir)
        self.ids = []
        self.rb_red = QgsRubberBand(self.canvas)
        self.rb_red.setColor(Qt.darkRed)
        self.rb_red.setIconSize(20)
        self.rb_list = []
        self.lot_date_format = 'yyyy-MM-dd'
        self.max_id = 0


    def manage_lot(self, lot_id=None, is_new=True, visitclass_id=None):

        # turnoff autocommit of this and base class. Commit will be done at dialog button box level management
        self.autocommit = True
        self.remove_ids = False
        self.is_new_lot = is_new
        self.cmb_position = 17  # Variable used to set the position of the QCheckBox in the relations table

        self.srid = self.controller.plugin_settings_value('srid')
        # Get layers of every geom_type
        self.reset_lists()
        self.reset_layers()
        self.layers['arc'] = [self.controller.get_layer_by_tablename('v_edit_arc')]
        self.layers['node'] = [self.controller.get_layer_by_tablename('v_edit_node')]
        self.layers['connec'] = [self.controller.get_layer_by_tablename('v_edit_connec')]

        # Add 'gully' for 'UD' projects
        if self.controller.get_project_type() == 'ud':
            self.layers['gully'] = [self.controller.get_layer_by_tablename('v_edit_gully')]

        self.dlg_lot = AddLot()
        self.load_settings(self.dlg_lot)
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
        self.set_icon(self.dlg_lot.btn_feature_insert, "111")
        self.set_icon(self.dlg_lot.btn_feature_delete, "112")
        self.set_icon(self.dlg_lot.btn_feature_snapping, "137")

        # Set date format to date widgets
        utils_giswater.set_regexp_date_validator(self.dlg_lot.startdate, self.dlg_lot.btn_accept, 1)
        utils_giswater.set_regexp_date_validator(self.dlg_lot.enddate, self.dlg_lot.btn_accept, 1)
        utils_giswater.set_regexp_date_validator(self.dlg_lot.real_startdate, self.dlg_lot.btn_accept, 1)
        utils_giswater.set_regexp_date_validator(self.dlg_lot.real_enddate, self.dlg_lot.btn_accept, 1)
        self.dlg_lot.enddate.textChanged.connect(self.check_dates_consistency)

        self.lot_id = self.dlg_lot.findChild(QLineEdit, "lot_id")
        self.user_name = self.dlg_lot.findChild(QLineEdit, "user_name")
        self.visit_class = self.dlg_lot.findChild(QComboBox, "cmb_visit_class")

        # Tab 'Relations'
        self.feature_type = self.dlg_lot.findChild(QComboBox, "feature_type")
        self.tbl_relation = self.dlg_lot.findChild(QTableView, "tbl_relation")
        utils_giswater.set_qtv_config(self.tbl_relation)
        utils_giswater.set_qtv_config(self.dlg_lot.tbl_visit)
        self.feature_type.setEnabled(False)

        # Fill QWidgets of the form
        self.fill_fields(lot_id)

        # Tab 'Loads'
        self.tbl_load = self.dlg_lot.findChild(QTableView, "tbl_load")
        utils_giswater.set_qtv_config(self.tbl_load)

        new_lot_id = lot_id
        if lot_id is None:
            new_lot_id = self.get_next_id('om_visit_lot', 'id')
        utils_giswater.setWidgetText(self.dlg_lot, self.lot_id, new_lot_id)

        self.geom_type = utils_giswater.get_item_data(self.dlg_lot, self.visit_class, 2).lower()
        if self.geom_type != '':
            viewname = "v_edit_" + self.geom_type
            self.set_completer_feature_id(self.dlg_lot.feature_id, self.geom_type, viewname)
        else:
            self.geom_type = 'arc'
        self.clear_selection()

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
        self.dlg_lot.cmb_visit_class.currentIndexChanged.connect(partial(self.populate_cmb_team))
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

        self.dlg_lot.btn_cancel.clicked.connect(partial(self.manage_rejected))
        self.dlg_lot.rejected.connect(partial(self.manage_rejected))
        self.dlg_lot.rejected.connect(partial(self.reset_rb_list, self.rb_list))
        self.dlg_lot.btn_accept.clicked.connect(partial(self.save_lot))
        self.set_lot_headers()
        self.set_active_layer()

        self.set_icon(self.dlg_lot.btn_open_image, "136b")
        self.dlg_lot.btn_open_image.clicked.connect(partial(self.open_load_image, self.tbl_load, 'v_ui_om_vehicle_x_parameters'))

        if lot_id is not None:
            self.set_values(lot_id)
            self.geom_type = utils_giswater.get_item_data(self.dlg_lot, self.visit_class, 2).lower()
            self.populate_table_relations(lot_id)
            self.update_id_list()
            self.set_dates_from_to(self.dlg_lot.date_event_from, self.dlg_lot.date_event_to, 've_visit_emb_neteja',
                                   'startdate', 'enddate')
            self.reload_table_visit()
            self.manage_cmb_status()

        # Enable or disable QWidgets
        self.dlg_lot.txt_ot_type.setReadOnly(True)
        self.dlg_lot.txt_wotype_id.setReadOnly(True)
        self.dlg_lot.txt_ot_address.setReadOnly(True)

        # Check if enable or disable tab relation if
        self.set_tab_dis_enabled()

        # Set autocompleters of the form
        self.set_completers()
        self.hilight_features(self.rb_list)

        # Get columns to ignore for tab_visit when export csv
        table_name = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.cmb_visit_class, 3)

        if table_name is not None:

            sql = "SELECT column_id FROM config_client_forms WHERE location_type = 'tbl_visit' AND status IS NOT TRUE AND table_id = '"+str(table_name)+"'"
            rows = self.controller.get_rows(sql, commit=True)
            result_visit = []
            if rows is not None:
                for row in rows:
                    result_visit.append(row[0])
            else:
                result_visit = ''
        else:
            result_visit = ''

        # Get columns to ignore for tab_relations when export csv
        sql = "SELECT column_id FROM config_client_forms WHERE location_type = 'lot' AND status IS NOT TRUE AND table_id = 've_lot_x_"+str(self.geom_type)+"'"
        rows = self.controller.get_rows(sql, commit=True)
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

        # Open the dialog
        self.open_dialog(self.dlg_lot, dlg_name="add_lot")


    def manage_cmb_status(self):
        """ Control of status_lot and widgets according to the selected status_lot """

        value = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.cmb_status, 0)
        # Set all options enabled
        all_index = ['1', '2', '3', '4', '5', '6', '7']
        utils_giswater.set_combo_item_select_unselectable(self.dlg_lot.cmb_status, all_index, 0, (1 | 32))
        self.dlg_lot.btn_validate_all.setEnabled(True)

        combo_list = self.dlg_lot.tbl_visit.findChildren(QComboBox)
        for combo in combo_list:
            combo.setEnabled(True)
        self.dlg_lot.btn_delete_visit.setEnabled(True)

        # Disable options of QComboBox according combo selection
        if value in (1, 2, 3, 7):
            utils_giswater.set_combo_item_select_unselectable(self.dlg_lot.cmb_status, ['4', '5', '6'], 0)
        elif value in (4, 5):
            utils_giswater.set_combo_item_select_unselectable(self.dlg_lot.cmb_status, ['1', '2', '3', '7'], 0)
        elif value in [6]:
            utils_giswater.set_combo_item_select_unselectable(self.dlg_lot.cmb_status, ['1', '2', '3', '4', '7'], 0)
            self.dlg_lot.btn_validate_all.setEnabled(False)
            for combo in combo_list:
                combo.setEnabled(False)
            self.dlg_lot.btn_delete_visit.setEnabled(False)
        self.disbale_actions(value)


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
            self.controller.show_warning(message)
            return

        index = selected_list[0]
        row = index.row()
        column_index = utils_giswater.get_col_index_by_col_name(qtable, 'visit_id')
        visit_id = index.sibling(row, column_index).data()

        sql = ("SELECT value FROM om_visit_event_photo WHERE visit_id = " + visit_id)
        rows = self.controller.get_rows(sql, commit=True)
        # TODO:: Open manage photos when visit have more than one
        for row in rows:
            webbrowser.open(row[0])


    def validate_all(self, qtable):
        """ Set all QComboBox with validated option """

        model = qtable.model()
        for x in range(0, model.rowCount()):
            index = qtable.model().index(x, self.cmb_position)
            cmb = qtable.indexWidget(index)
            utils_giswater.set_combo_itemData(cmb, '5', 0)


    def manage_team(self):
        """ Open dialog of teams """

        self.max_id = self.get_max_id('cat_team')
        self.dlg_basic_table = BasicTable()
        self.load_settings(self.dlg_basic_table)
        self.dlg_basic_table.setWindowTitle("Team management")
        table_name = 'cat_team'

        # @setEditStrategy: 0: OnFieldChange, 1: OnRowChange, 2: OnManualSubmit
        self.fill_table(self.dlg_basic_table.tbl_basic, table_name, QSqlTableModel.OnManualSubmit)
        self.set_table_columns(self.dlg_basic_table, self.dlg_basic_table.tbl_basic, table_name)
        self.dlg_basic_table.btn_cancel.clicked.connect(partial(self.cancel_changes, self.dlg_basic_table.tbl_basic))
        self.dlg_basic_table.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_basic_table))
        self.dlg_basic_table.btn_accept.clicked.connect(partial(self.save_table, self.dlg_basic_table, self.dlg_basic_table.tbl_basic, manage_type='team_selector'))
        self.dlg_basic_table.btn_accept.clicked.connect(partial(self.close_dialog, self.dlg_basic_table))
        self.dlg_basic_table.btn_add_row.clicked.connect(partial(self.add_row, self.dlg_basic_table.tbl_basic))
        self.dlg_basic_table.rejected.connect(partial(self.save_settings, self.dlg_basic_table))
        self.open_dialog(self.dlg_basic_table)


    def populate_cmb_team(self):
        """ Fill ComboBox cmb_assigned_to """
        visit_class = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.cmb_visit_class, 0)

        sql = ("SELECT DISTINCT(cat_team.id), idval "
               "FROM cat_team ")
        if visit_class:
            sql += ("JOIN om_team_x_visitclass ON cat_team.id = om_team_x_visitclass.team_id "
                    "WHERE active is True AND visitclass_id = " + str(visit_class) + " ")
        else:
            sql += ("WHERE active is True ")
        sql += ("ORDER BY idval")

        rows = self.controller.get_rows(sql, commit=True)
        if rows:
            utils_giswater.set_item_data(self.dlg_lot.cmb_assigned_to, rows, 1)


    def cancel_changes(self, qtable):

        model = qtable.model()
        model.revertAll()
        model.database().rollback()


    def add_row(self, qtable, populate=False):
        """ Append new record to model with correspondent id """

        self.max_id += 1
        model = qtable.model()
        record = model.record()
        record.setValue("id", self.max_id)
        model.insertRecord(model.rowCount(), record)
        if populate:
            self.put_combo_populate(qtable, populate)


    def put_combo_populate(self, qtable, array_json):
        for _json in array_json:
            combo = QComboBox()
            _json = json.loads(_json)
            idx = qtable.model().index(qtable.model().rowCount()-1, _json['pos'])
            qtable.setIndexWidget(idx, combo)
            self.populate_combo_filters(combo, _json['table'])


    def get_max_id(self, table_name):

        sql = ("SELECT MAX(id) FROM " + table_name)
        row = self.controller.get_row(sql, commit=True)
        if row[0] is not None:
            return int(row[0])
        return 0


    def save_table(self, dialog, qtable, manage_type=None):

        model = qtable.model()
        if model.submitAll():
            if manage_type == 'team_selector':
                sql = ("SELECT id, idval FROM cat_team WHERE active is True ORDER BY idval")
                rows = self.controller.get_rows(sql, commit=True)
                if rows:
                    utils_giswater.set_item_data(self.dlg_resources_man.cmb_team, rows, 1)
            elif manage_type == 'vehicle':
                sql = ("SELECT id, idval FROM ext_cat_vehicle ORDER BY idval")
                rows = self.controller.get_rows(sql, commit=True)
                if rows:
                    utils_giswater.set_item_data(self.dlg_resources_man.cmb_vehicle, rows, 1)
        else:
            print(str(model.lastError().text()))


    def manage_widget_lot(self, lot_id):

        # Fill ComboBox cmb_ot
        sql = ("SELECT ext_workorder.ct, ext_workorder.class_id,  ext_workorder.wotype_id, ext_workorder.wotype_name, "
               " ext_workorder.address, ext_workorder.serie, ext_workorder.visitclass_id "
               " FROM ext_workorder "
               " LEFT JOIN om_visit_lot ON om_visit_lot.serie = ext_workorder.serie ")
        if lot_id:
            _sql = ("SELECT serie FROM om_visit_lot "
                    " WHERE id = '"+str(lot_id)+"'")
            ct = self.controller.get_row(_sql, commit=True)
            sql += " OR ext_workorder.serie = '"+str(ct[0])+"'"
        sql += " order by ct"
        rows = self.controller.get_rows(sql, commit=True)

        self.list_to_show = ['']  # List to show
        self.list_to_work = [['', '', '', '', '', '', '']]  # List to work (find feature)

        if rows:
            for row in rows:
                self.list_to_show.append(row[0])
                # elem = (0-class_id, 1-wotype_id, 2-wotype_name, 3-address, 4-serie,5-visitclass_id)
                elem = [row[1], row[2], row[3], row[4], row[5], row[6]]
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
        startdate = utils_giswater.getWidgetText(self.dlg_lot, self.dlg_lot.startdate)
        enddate = utils_giswater.getWidgetText(self.dlg_lot, self.dlg_lot.enddate, False, False)

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
        utils_giswater.setWidgetText(self.dlg_lot, self.dlg_lot.txt_ot_type, item[0])
        utils_giswater.setWidgetText(self.dlg_lot, self.dlg_lot.txt_wotype_id, item[2])
        utils_giswater.setWidgetText(self.dlg_lot, self.dlg_lot.txt_ot_address, item[3])
        utils_giswater.setWidgetText(self.dlg_lot, self.dlg_lot.descript, item[1])
        utils_giswater.set_combo_itemData(self.dlg_lot.cmb_visit_class, str(item[5]), 0)

        # Enable/Disable visit class combo according selected OT
        if utils_giswater.getWidgetText(self.dlg_lot, self.dlg_lot.cmb_ot) == 'null':
            self.dlg_lot.cmb_visit_class.setEnabled(True)
        else:
            self.dlg_lot.cmb_visit_class.setEnabled(False)


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
        feature_type = utils_giswater.get_item_data(None, self.dlg_lot.cmb_visit_class, 2).lower()

        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        message = "Are you sure you want to delete these records? \n"
        msg_records = ""
        id_list = "(  "
        for x in range(0, len(selected_list)):
            # Get index of row and row[index]
            row_index = selected_list[x]
            row = row_index.row()
            index_visit = utils_giswater.get_col_index_by_col_name(qtable, 'visit_id')
            visit_id = row_index.sibling(row, index_visit).data()
            # Get index of column 'feature_id' and get value of this column in current row
            index_feature = utils_giswater.get_col_index_by_col_name(qtable, str(feature_type) + '_id')
            feature_id = row_index.sibling(row, index_feature).data()
            id_list += "'" + feature_id + "', "
            msg_records += "visit_id: "+str(visit_id)+", "+str(feature_type)+"_id = '"+str(feature_id)+"';\n"
        id_list = id_list[:-2] + ")"
        answer = self.controller.ask_question(message, "Delete records", msg_records)
        if answer:
            sql = ("DELETE FROM om_visit_x_"+str(feature_type)+" "
                   " WHERE visit_id = '"+str(visit_id)+"' "
                   " AND "+str(feature_type)+"_id IN "+str(id_list)+";\n")
            self.controller.execute_sql(sql, commit=True)

        self.reload_table_visit()


    def open_visit(self, qtable):

        selected_list = qtable.selectionModel().selectedRows()

        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        index = selected_list[0]
        row = index.row()
        column_index = utils_giswater.get_col_index_by_col_name(qtable, 'visit_id')
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
        utils_giswater.setWidgetText(self.dlg_lot, self.dlg_lot.startdate, current_date.toString(self.lot_date_format))

        # Set current user
        sql = "SELECT current_user"
        row = self.controller.get_row(sql, commit=self.autocommit)
        utils_giswater.setWidgetText(self.dlg_lot, self.user_name, row[0])

        # Fill ComboBox cmb_ot
        ot_result = self.manage_widget_lot(lot_id)

        # Fill ComboBox cmb_visit_class
        if ot_result:
            sql = ("SELECT DISTINCT(om_visit_class.id), om_visit_class.idval, feature_type, tablename "
                   " FROM om_visit_class"
                   " INNER JOIN om_visit_class_x_wo "
                   " ON om_visit_class_x_wo.visitclass_id = om_visit_class.id "
                   " INNER JOIN config_api_visit "
                   " ON config_api_visit.visitclass_id = om_visit_class_x_wo.visitclass_id "
                   " WHERE ismultifeature is False AND feature_type IS NOT null")
        else:
            sql = ("SELECT DISTINCT(id), idval, feature_type, tablename FROM om_visit_class"
                   " INNER JOIN config_api_visit ON config_api_visit.visitclass_id = om_visit_class.id")

        visitclass_ids = self.controller.get_rows(sql, commit=True)
        if visitclass_ids:
            visitclass_ids.append(['', '', '', ''])
        else:
            visitclass_ids = []
            visitclass_ids.append(['', '', '', ''])
        utils_giswater.set_item_data(self.dlg_lot.cmb_visit_class, visitclass_ids, 1)

        # Fill ComboBox cmb_assigned_to
        self.populate_cmb_team()

        # Fill ComboBox cmb_status
        rows = self.get_values_from_catalog('om_typevalue', 'lot_cat_status')
        if rows:
            utils_giswater.set_item_data(self.dlg_lot.cmb_status, rows, 1, sort_combo=False)
            utils_giswater.set_combo_item_select_unselectable(self.dlg_lot.cmb_status, ['4', '5', '6'], 0)
            utils_giswater.set_combo_itemData(self.dlg_lot.cmb_status, '1', 0)

        # Relations tab
        # fill feature_type
        sql = ("SELECT id, id"
               " FROM sys_feature_type"
               " WHERE net_category = 1"
               " ORDER BY id")
        feature_type = self.controller.get_rows(sql, commit=self.autocommit)
        if feature_type:
            utils_giswater.set_item_data(self.dlg_lot.feature_type, feature_type, 1)


    def get_next_id(self, table_name, pk):

        sql = "SELECT max("+str(pk)+"::integer) FROM "+str(table_name)+";"
        row = self.controller.get_row(sql)
        if not row or not row[0]:
            return 0
        else:
            return row[0] + 1


    def event_feature_type_selected(self, dialog):
        """ Manage selection change in feature_type combo box.
        THis means that have to set completer for feature_id QTextLine and
        setup model for features to select table """

        # 1) set the model linked to selecte features
        # 2) check if there are features related to the current visit
        # 3) if so, select them => would appear in the table associated to the model
        self.geom_type = self.feature_type.currentText().lower()

        viewname = "v_edit_" + self.geom_type
        self.set_completer_feature_id(dialog.feature_id, self.geom_type, viewname)
        self.set_lot_headers()


    def clear_selection(self, remove_groups=True):
        """ Remove all previous selections """

        layer = self.controller.get_layer_by_tablename("v_edit_arc")
        if layer:
            layer.removeSelection()
        layer = self.controller.get_layer_by_tablename("v_edit_node")
        if layer:
            layer.removeSelection()
        layer = self.controller.get_layer_by_tablename("v_edit_connec")
        if layer:
            layer.removeSelection()
        layer = self.controller.get_layer_by_tablename("v_edit_element")
        if layer:
            layer.removeSelection()

        if self.project_type == 'ud':
            layer = self.controller.get_layer_by_tablename("v_edit_gully")
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

        sql = ("SELECT om_visit_lot.*, ext_workorder.ct FROM om_visit_lot LEFT JOIN ext_workorder using (serie) "
               "WHERE id ='" + str(lot_id) + "'")
        lot = self.controller.get_row(sql, commit=True)
        if lot:
            if lot['ct'] is not None:
                value = lot['ct']
                utils_giswater.setWidgetText(self.dlg_lot, self.dlg_lot.cmb_ot, value)
            index = self.dlg_lot.cmb_ot.currentIndex()
            self.set_ot_fields(index)
            utils_giswater.setWidgetText(self.dlg_lot, self.dlg_lot.startdate, lot['startdate'])
            utils_giswater.setWidgetText(self.dlg_lot, self.dlg_lot.enddate, lot['enddate'])
            utils_giswater.setWidgetText(self.dlg_lot, self.dlg_lot.real_startdate, lot['real_startdate'])
            utils_giswater.setWidgetText(self.dlg_lot, self.dlg_lot.real_enddate, lot['real_enddate'])
            utils_giswater.set_combo_itemData(self.dlg_lot.cmb_visit_class, str(lot['visitclass_id']), 0)
            utils_giswater.set_combo_itemData(self.dlg_lot.cmb_assigned_to, str(lot['team_id']), 0)
            utils_giswater.set_combo_itemData(self.dlg_lot.cmb_status, str(lot['status']), 0)
            if lot['status'] in (4, 5):
                self.dlg_lot.cmb_assigned_to.setEnabled(False)
            utils_giswater.set_combo_itemData(self.dlg_lot.feature_type, lot['feature_type'], 0)
        self.set_lot_headers()


    def populate_visits(self, widget, table_name, expr_filter=None):
        """ Set a model with selected filter. Attach that model to selected table """

        if self.schema_name not in table_name:
            table_name = str(self.schema_name) + "."+ str(table_name)

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
            self.controller.show_warning(model.lastError().text())

        # Attach model to table view
        widget.setModel(model)


    def update_id_list(self):

        feature_type = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.feature_type, 1).lower()
        list_ids = self.get_table_values(self.tbl_relation, feature_type)
        for id_ in list_ids:
            if id_ not in self.ids:
                self.ids.append(id_)

        self.check_for_ids()


    def get_table_values(self, qtable, geom_type):

        if qtable.model() is None:
            return []
        column_index = utils_giswater.get_col_index_by_col_name(qtable, geom_type + '_id')
        model = qtable.model()

        id_list = []
        for i in range(0, model.rowCount()):
            i = model.index(i, column_index)
            id_list.append(i.data())
        return id_list


    def activate_selection(self, dialog, action, action_name):

        self.set_active_layer()
        self.dropdown.setDefaultAction(action)
        self.disconnect_signal_selection_changed()
        self.iface.mainWindow().findChild(QAction, action_name).triggered.connect(
            partial(self.selection_changed_by_expr, dialog, self.layer_lot, self.geom_type))
        self.iface.mainWindow().findChild(QAction, action_name).trigger()


    def selection_changed_by_expr(self, dialog, layer, geom_type):

        self.canvas.selectionChanged.connect(partial(self.manage_selection, dialog, layer, geom_type))


    def manage_selection(self, dialog, layer, geom_type):
        """ Slot function for signal 'canvas.selectionChanged' """

        field_id = geom_type + "_id"
        # Iterate over layer
        if layer.selectedFeatureCount() > 0:
            # Get selected features of the layer
            features = layer.selectedFeatures()
            for feature in features:
                # Append 'feature_id' into the list
                selected_id = feature.attribute(field_id)
                if selected_id not in self.ids:
                    self.ids.append(selected_id)
        self.reload_table_relations()
        self.check_for_ids()


    def reload_table_relations(self):
        """ Reload @widget with contents of @tablename applying selected @expr_filter """

        standard_model = self.tbl_relation.model()
        feature_type = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.feature_type, 1).lower()
        lot_id = utils_giswater.getWidgetText(self.dlg_lot, self.lot_id)
        id_list = self.get_table_values(self.tbl_relation, feature_type)
        layer_name = 'v_edit_' + utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.feature_type, 0).lower()
        field_id = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.feature_type, 0).lower() + str('_id')
        layer = self.controller.get_layer_by_tablename(layer_name)

        for feature_id in self.ids:
            item = []
            if feature_id not in id_list:
                feature = self.get_feature_by_id(layer, feature_id, field_id)
                item.append('')
                item.append(feature_id)
                item.append(str(feature_type))
                item.append(feature.attribute('code'))
                item.append(utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.cmb_visit_class, 0))
                item.append(lot_id)
                item.append(1)  # Set status field of the table relation
                item.append('No visitat')
                item.append('')
                if Qgis.QGIS_VERSION_INT < 29900:
                    item.append(feature.geometry().asWkb().encode('hex').upper())
                else:
                    sql = "SELECT ST_GeomFromText('"+str(feature.geometry().asWkt())+"', "+str(self.srid)+")"
                    the_geom = self.controller.get_row(sql, commit=True, log_sql=True)
                    item.append(the_geom[0])
                row = []
                for value in item:
                    row.append(QStandardItem(str(value)))
                if len(row) > 0:
                    standard_model.appendRow(row)
        self.hilight_features(self.rb_list)
        self.set_dates_from_to(self.dlg_lot.date_event_from, self.dlg_lot.date_event_to, 've_visit_emb_neteja',
                               'startdate', 'enddate')
        self.reload_table_visit()


    def insert_row(self):
        """ Insert single row into QStandardItemModel """

        standard_model = self.tbl_relation.model()
        feature_id = utils_giswater.getWidgetText(self.dlg_lot, self.dlg_lot.feature_id)
        lot_id = utils_giswater.getWidgetText(self.dlg_lot, self.lot_id)
        layer_name = 'v_edit_' + utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.feature_type, 0).lower()
        field_id = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.feature_type, 0).lower() + str('_id')
        layer = self.controller.get_layer_by_tablename(layer_name)
        feature = self.get_feature_by_id(layer, feature_id, field_id)
        if feature is False:
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

        self.disconnect_signal_selection_changed()
        feature_type = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.feature_type, 0).lower()
        # Get selected rows
        index_list = qtable.selectionModel().selectedRows()

        if len(index_list) == 0:
            message = "Any record selected"
            self.controller.show_info_box(message)
            return
        index = index_list[0]
        model = qtable.model()

        for i in range(len(index_list) - 1, -1, -1):
            row = index_list[i].row()
            column_index = utils_giswater.get_col_index_by_col_name(qtable, feature_type + '_id')
            feature_id = index.sibling(row, column_index).data()
            list_ids = self.get_table_values(self.tbl_relation, feature_type)
            list_ids.remove(feature_id)
            model.takeRow(row)

        self.check_for_ids()
        self.hilight_features(self.rb_list)
        self.set_dates_from_to(self.dlg_lot.date_event_from, self.dlg_lot.date_event_to, 've_visit_emb_neteja',
                               'startdate', 'enddate')
        self.reload_table_visit()


    def set_active_layer(self):

        self.current_layer = self.iface.activeLayer()
        # Set active layer
        layer_name = 'v_edit_' + utils_giswater.get_item_data(self.dlg_lot, self.visit_class, 2).lower()

        self.layer_lot = self.controller.get_layer_by_tablename(layer_name)
        self.iface.setActiveLayer(self.layer_lot)
        self.controller.set_layer_visible(self.layer_lot)


    def selection_init(self, dialog):
        """ Set canvas map tool to an instance of class 'MultipleSelection' """

        self.disconnect_signal_selection_changed()
        self.iface.actionSelect().trigger()
        self.connect_signal_selection_changed(dialog)


    def connect_signal_selection_changed(self, dialog):
        """ Connect signal selectionChanged """

        try:
            self.canvas.selectionChanged.connect(partial(self.manage_selection, dialog, self.layer_lot, self.geom_type))
        except:
            pass


    def set_tab_dis_enabled(self):
        self.ids = []
        feature_type = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.cmb_visit_class, 2)
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
        utils_giswater.set_combo_itemData(self.feature_type, feature_type, 1)
        self.fill_tab_load()


    def reload_table_visit(self):

        feature_type = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.cmb_visit_class, 2)
        object_id = utils_giswater.getWidgetText(self.dlg_lot, self.dlg_lot.txt_filter)
        lot_id = utils_giswater.getWidgetText(self.dlg_lot, self.dlg_lot.lot_id, False, False)
        visit_start = self.dlg_lot.date_event_from.date()
        visit_end = self.dlg_lot.date_event_to.date()
        # Get selected dates
        date_from = visit_start.toString('yyyyMMdd 00:00:00')
        date_to = visit_end.toString('yyyyMMdd 23:59:59')
        if date_from > date_to:
            message = "Selected date interval is not valid"
            self.controller.show_warning(message)
            return

        visit_class_id = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.cmb_visit_class, 0)
        if visit_class_id == '':
            return

        standard_model = QStandardItemModel()
        self.dlg_lot.tbl_visit.setModel(standard_model)
        self.dlg_lot.tbl_visit.horizontalHeader().setStretchLastSection(True)

        table_name = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.cmb_visit_class, 3)

        if table_name is None:
            return

        # Create interval dates
        format_low = self.lot_date_format + ' 00:00:00.000'
        format_high = self.lot_date_format + ' 23:59:59.999'
        interval = "'"+str(visit_start.toString(format_low))+"'::timestamp AND '"+str(visit_end.toString(format_high))+"'::timestamp"

        expr_filter = "(startdate BETWEEN "+str(interval)+") AND (enddate BETWEEN "+str(interval)+" OR enddate is NULL)"

        if object_id != 'null':
            expr_filter += " AND "+str(feature_type)+"_id::TEXT ILIKE '%"+str(object_id)+"%'"
        if lot_id != '':
            expr_filter += " AND lot_id='"+str(lot_id)+"'"

        columns_name = self.controller.get_columns_list(table_name)

        # Get headers
        headers = []
        for x in columns_name:
            headers.append(x[0])

        # Set headers to model
        standard_model.setHorizontalHeaderLabels(headers)

        # Hide columns
        self.set_table_columns(self.dlg_lot, self.dlg_lot.tbl_visit, table_name, isQStandardItemModel=True)

        # Populate model visit
        sql = ("SELECT * FROM " + str(table_name) +""
               " WHERE lot_id ='"+str(lot_id)+"'"
               " AND "+str(expr_filter)+"")
        rows = self.controller.get_rows(sql, commit=True)

        if rows is None:
            return

        for row in rows:
            item = []
            for value in row:
                if value is not None:
                    if type(value) != unicode:
                        item.append(QStandardItem(str(value)))
                    else:
                        item.append(QStandardItem(value))
                else:
                    item.append(QStandardItem(None))
            if len(row) > 0:
                standard_model.appendRow(item)

        combo_values = self.get_values_from_catalog('om_typevalue', 'visit_cat_status')
        if combo_values is None:
            return
        self.put_combobox(self.dlg_lot.tbl_visit, rows, 'status', 17, combo_values)


    def put_combobox(self, qtable, rows, field, widget_pos, combo_values):
        """ Set one column of a QtableView as QComboBox with values from database. """
        for x in range(0, len(rows)):
            combo = QComboBox()
            row = rows[x]

            # Populate QComboBox
            utils_giswater.set_item_data(combo, combo_values, 1)

            # Set QCombobox to wanted item
            utils_giswater.set_combo_itemData(combo, str(row[field]), 0)

            # Get index and put QComboBox into QTableView at inde   x position
            idx = qtable.model().index(x, widget_pos)
            qtable.setIndexWidget(idx, combo)
            combo.currentIndexChanged.connect(partial(self.update_status, combo, qtable, x, widget_pos))


    def update_status(self, combo, qtable, pos_x, widget_pos):
        """ Update values from QComboBox to QTableView """
        elem = combo.itemData(combo.currentIndex())
        i = qtable.model().index(pos_x, widget_pos)
        qtable.model().setData(i, elem[0])
        i = qtable.model().index(pos_x, widget_pos+1)
        qtable.model().setData(i, elem[1])


    def populate_table_relations(self, lot_id):

        standard_model = self.tbl_relation.model()
        feature_type = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.cmb_visit_class, 2).lower()
        if feature_type:
            sql = ("SELECT * FROM ve_lot_x_"+str(feature_type)+" "
                   "WHERE lot_id ='"+str(lot_id)+"'")
            rows = self.controller.get_rows(sql, commit=True)
            self.set_table_columns(self.dlg_lot, self.dlg_lot.tbl_relation, "ve_lot_x_" + str(feature_type),
                                   isQStandardItemModel=True)
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

        feature_type = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.cmb_visit_class, 2).lower()
        if feature_type == '':
            return
        columns_name = self.controller.get_columns_list('ve_lot_x_' + str(feature_type))
        standard_model = QStandardItemModel()
        self.tbl_relation.setModel(standard_model)
        self.tbl_relation.horizontalHeader().setStretchLastSection(True)

        # Get headers
        headers = []
        for x in columns_name:
            headers.append(x[0])

        # Set headers
        standard_model.setHorizontalHeaderLabels(headers)

        self.set_table_columns(self.dlg_lot, self.dlg_lot.tbl_relation, "ve_lot_x_" + str(feature_type),
                               isQStandardItemModel=True)


    def save_lot(self):

        lot = {}
        index = self.dlg_lot.cmb_ot.currentIndex()
        item = self.list_to_work[index]

        lot['id'] = utils_giswater.getWidgetText(self.dlg_lot, self.dlg_lot.lot_id, False, False)
        lot['startdate'] = utils_giswater.getWidgetText(self.dlg_lot, self.dlg_lot.startdate, False, False)
        lot['enddate'] = utils_giswater.getWidgetText(self.dlg_lot, self.dlg_lot.enddate, False, False)
        lot['team_id'] = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.cmb_assigned_to, 0, True)
        lot['feature_type'] = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.cmb_visit_class, 2).lower()
        lot['status'] = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.cmb_status, 0)
        lot['class_id'] = item[0]
        lot['adreca'] = item[3]
        lot['serie'] = item[4]
        lot['visitclass_id'] = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.cmb_visit_class, 0)

        keys = ""
        values = ""
        update = ""

        for key, value in list(lot.items()):
            keys += "" + key + ", "
            if value not in ('', None):
                if type(value) in (int, bool):
                    values += "$$"+str(value)+"$$, "
                    update += ""+str(key)+"=$$"+str(value)+"$$, "
                else:
                    values += "$$"+str(value)+"$$, "
                    update += str(key)+ "=$$"+str(value)+"$$, "
            else:
                values += "null, "
                update += key + "=null, "

        keys = keys[:-2]
        values = values[:-2]
        update = update[:-2]

        if self.is_new_lot is True:
            sql = ("INSERT INTO om_visit_lot("+str(keys)+") "
                   " VALUES ("+str(values)+") RETURNING id")
            row = self.controller.execute_returning(sql, commit=True)
            lot_id = row[0]
            sql = ("INSERT INTO selector_lot "
                   "(lot_id, cur_user) VALUES("+str(lot_id)+", current_user);")
            self.controller.execute_sql(sql)
            self.refresh_map_canvas()
        else:
            lot_id = utils_giswater.getWidgetText(self.dlg_lot, 'lot_id', False, False)
            sql = ("UPDATE om_visit_lot "
                   " SET "+str(update)+""
                   " WHERE id = '"+str(lot_id)+"'; \n")
            self.controller.execute_sql(sql)

        self.save_relations(lot, lot_id)
        sql = ("SELECT gw_fct_lot_psector_geom(" + str(lot_id) + ")")
        self.controller.execute_sql(sql)
        status = self.save_visits()

        if status:
            self.iface.mapCanvas().refreshAllLayers()
            self.manage_rejected()


    def save_relations(self, lot, lot_id):

        # Manage relations
        if not lot['feature_type']:
            return

        sql = ("DELETE FROM om_visit_lot_x_"+str(lot['feature_type'])+" "
               "WHERE lot_id = '"+str(lot_id)+"'; \n")

        model_rows = self.read_standaritemmodel(self.tbl_relation)

        if model_rows is None:
            return

        # Save relations
        for item in model_rows:
            keys = "lot_id, "
            values = "$$"+str(lot_id)+"$$, "
            for key, value in list(item.items()):
                if key in (lot['feature_type'] + '_id', 'code', 'status', 'observ', 'validate'):
                    if value not in ('', None):
                        keys += key + ", "
                        values += "$$"+str(value)+"$$, "
            keys = keys[:-2]
            values = values[:-2]
            sql += ("INSERT INTO om_visit_lot_x_"+str(lot['feature_type'])+"("+str(keys)+") "
                    "VALUES ("+str(values)+"); \n")
        status = self.controller.execute_sql(sql)
        return status


    def save_visits(self):

        # Manage visits
        status = False
        table_name = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.cmb_visit_class, 3)

        model_rows = self.read_standaritemmodel(self.dlg_lot.tbl_visit)
        if not model_rows:
            return True

        sql = ""
        for item in model_rows:
            visit_id = None
            status = None
            for key, value in list(item.items()):
                if key == "Id visita":
                    visit_id = str(value)
                if key == "Estat visita":
                    if value not in ('', None):
                        _sql = ("SELECT id FROM om_typevalue WHERE id = '" + str(value) + "' AND typevalue = 'visit_cat_status'")
                        result = self.controller.get_row(_sql, commit=True)
                        if result not in ('', None):
                            status = "$$" + str(result[0]) + "$$ "
            if visit_id and status:
                sql += ("UPDATE "+str(table_name)+" "
                        "SET (status) = ("+str(status)+") "
                        "WHERE visit_id = '"+str(visit_id)+"';\n")
        if sql != "":
            status = self.controller.execute_sql(sql)

        return status


    def set_completers(self):
        """ Set autocompleters of the form """

        # Adding auto-completion to a QLineEdit - lot_id
        self.completer = QCompleter()
        self.dlg_lot.lot_id.setCompleter(self.completer)
        model = QStringListModel()

        sql = "SELECT DISTINCT(id) FROM om_visit"
        rows = self.controller.get_rows(sql, commit=self.autocommit)
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


    def hilight_features(self, rb_list):

        self.reset_rb_list(rb_list)
        feature_type = utils_giswater.get_item_data(self.dlg_lot, self.visit_class, 2).lower()
        layer = self.iface.activeLayer()
        if not layer:
            return

        field_id = feature_type + "_id"
        for _id in self.ids:
            feature = self.get_feature_by_id(layer, _id, field_id)
            geometry = feature.geometry()
            rb = QgsRubberBand(self.canvas)
            rb.setToGeometry(geometry, None)
            rb.setColor(QColor(255, 0, 0, 100))
            rb.setWidth(5)
            rb.show()
            rb_list.append(rb)


    def zoom_to_feature(self, qtable):

        feature_type = utils_giswater.get_item_data(self.dlg_lot, self.visit_class, 2).lower()
        selected_list = qtable.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        index = selected_list[0]
        row = index.row()
        column_index = utils_giswater.get_col_index_by_col_name(qtable, feature_type + '_id')
        feature_id = index.sibling(row, column_index).data()
        expr_filter = "\""+str(feature_type)+"_id\" IN ('"+str(feature_id)+"')"

        # Check expression
        (is_valid, expr) = self.check_expression(expr_filter)

        self.select_features_by_ids(feature_type, expr)
        self.iface.actionZoomActualSize().trigger()

        layer = self.iface.activeLayer()
        features = layer.selectedFeatures()

        for f in features:
            if feature_type == 'arc':
                list_coord = f.geometry().asPolyline()
            else:
                return
                # TODO
                list_coord = [str(f.geometry().asPoint()) + " " + str(f.geometry().asPoint())]
            break

        coords = "LINESTRING( "
        for c in list_coord:
            coords += c[0] + " " + c[1] + ","
        coords = coords[:-1] + ")"
        list_coord = re.search('\((.*)\)', str(coords))
        points = self.get_points(list_coord)
        self.draw_polyline(points)


    def manage_rejected(self):

        self.disconnect_signal_selection_changed()
        layer = self.iface.activeLayer()
        if layer:
            layer.removeSelection()
        self.save_settings(self.dlg_lot)
        self.save_user_values(self.dlg_lot)
        self.iface.actionPan().trigger()
        self.close_dialog(self.dlg_lot)


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
        self.dlg_lot_man = LotManagement()
        self.load_settings(self.dlg_lot_man)
        self.load_user_values(self.dlg_lot_man)
        self.dlg_lot_man.tbl_lots.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.populate_combo_filters(self.dlg_lot_man.cmb_actuacio, 'ext_workorder_type')
        rows = self.get_values_from_catalog('om_typevalue', 'lot_cat_status')
        if rows:
            rows.insert(0, ['', ''])
            utils_giswater.set_item_data(self.dlg_lot_man.cmb_estat, rows, 1, sort_combo=False)

        # Populate combo date type
        rows = [['Data inici', 'Data inici'],['Data fi', 'Data fi'], ['Data inici planificada', 'Data inici planificada'],
                ['Data final planificada', 'Data final planificada']]
        utils_giswater.set_item_data(self.dlg_lot_man.cmb_date_filter_type, rows, 1, sort_combo=False)

        table_object = "v_ui_om_visit_lot"

        # set timeStart and timeEnd as the min/max dave values get from model
        current_date = QDate.currentDate()
        sql = ('SELECT MIN(startdate), MAX(startdate)'
               ' FROM om_visit_lot')
        row = self.controller.get_row(sql, commit=self.autocommit)
        if row:
            if row[0]:
                self.dlg_lot_man.date_event_from.setDate(row[0])
            if row[1]:
                self.dlg_lot_man.date_event_to.setDate(row[1])
            else:
                self.dlg_lot_man.date_event_to.setDate(current_date)

        # Set a model with selected filter. Attach that model to selected table
        self.fill_table_object(self.dlg_lot_man.tbl_lots, self.schema_name + "." + table_object)
        self.set_table_columns(self.dlg_lot_man, self.dlg_lot_man.tbl_lots, table_object)

        # manage open and close the dialog
        self.dlg_lot_man.rejected.connect(partial(self.save_user_values, self.dlg_lot_man))
        self.dlg_lot_man.btn_accept.clicked.connect(partial(self.open_lot, self.dlg_lot_man, self.dlg_lot_man.tbl_lots))
        self.dlg_lot_man.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_lot_man))

        # Set signals
        self.dlg_lot_man.btn_path.clicked.connect(partial(self.select_path, self.dlg_lot_man, 'txt_path'))
        self.dlg_lot_man.btn_export.clicked.connect(
            partial(self.export_model_to_csv, self.dlg_lot_man, self.dlg_lot_man.tbl_lots, 'txt_path', '',
                    self.lot_date_format))
        self.dlg_lot_man.tbl_lots.doubleClicked.connect(
            partial(self.open_lot, self.dlg_lot_man, self.dlg_lot_man.tbl_lots))
        self.dlg_lot_man.btn_open.clicked.connect(partial(self.open_lot, self.dlg_lot_man, self.dlg_lot_man.tbl_lots))
        self.dlg_lot_man.btn_delete.clicked.connect(partial(self.delete_lot, self.dlg_lot_man.tbl_lots))
        self.dlg_lot_man.btn_work_register.clicked.connect(partial(self.open_work_register))
        self.dlg_lot_man.btn_manage_load.clicked.connect(partial(self.open_load_manage))
        self.dlg_lot_man.btn_lot_selector.clicked.connect(partial(self.lot_selector))


        # Set filter events
        self.dlg_lot_man.txt_codi_ot.textChanged.connect(self.filter_lot)
        self.dlg_lot_man.cmb_actuacio.currentIndexChanged.connect(self.filter_lot)
        self.dlg_lot_man.txt_address.textChanged.connect(self.filter_lot)
        self.dlg_lot_man.cmb_estat.currentIndexChanged.connect(self.filter_lot)
        self.dlg_lot_man.chk_assignacio.stateChanged.connect(self.filter_lot)
        self.dlg_lot_man.date_event_from.dateChanged.connect(self.filter_lot)
        self.dlg_lot_man.date_event_to.dateChanged.connect(self.filter_lot)
        self.dlg_lot_man.cmb_date_filter_type.currentIndexChanged.connect(self.filter_lot)
        self.dlg_lot_man.cmb_date_filter_type.currentIndexChanged.connect(self.manage_date_filter)
        self.dlg_lot_man.chk_show_nulls.stateChanged.connect(self.filter_lot)

        # Get date filter vdefault (last selection)
        date_filter_vdef = QSettings().value('vdefault/date_filter')
        if date_filter_vdef:
            utils_giswater.set_combo_itemData(self.dlg_lot_man.cmb_date_filter_type, str(date_filter_vdef), 1)

        # Open form
        self.filter_lot()
        self.open_dialog(self.dlg_lot_man, dlg_name="visit_management")


    def open_load_manage(self):

        self.dlg_load_manager = LoadManagement()
        self.load_settings(self.dlg_load_manager)
        self.dlg_load_manager.tbl_loads.setSelectionBehavior(QAbstractItemView.SelectRows)

        # Tab 'Loads'
        self.tbl_load = self.dlg_load_manager.findChild(QTableView, "tbl_loads")
        utils_giswater.set_qtv_config(self.tbl_load)

        # Add combo into column vehicle_id
        sql = ("SELECT id, idval"
               " FROM ext_cat_vehicle"
               " ORDER BY id")
        combo_values = self.controller.get_rows(sql, commit=True)

        # Populate cmb_vehicle on tab Loads
        self.dlg_load_manager.cmb_filter_vehicle.addItem('', '')
        utils_giswater.set_item_data(self.dlg_load_manager.cmb_filter_vehicle, combo_values, 1, combo_clear=False)

        self.set_icon(self.dlg_load_manager.btn_open_image, "136b")
        self.dlg_load_manager.btn_open_image.clicked.connect(partial(self.open_load_image, self.tbl_load, 'v_ui_om_vehicle_x_parameters'))

        # @setEditStrategy: 0: OnFieldChange, 1: OnRowChange, 2: OnManualSubmit
        self.fill_table(self.dlg_load_manager.tbl_loads, 'v_ui_om_vehicle_x_parameters', QSqlTableModel.OnManualSubmit)
        self.set_table_columns(self.dlg_load_manager, self.dlg_load_manager.tbl_loads, 'v_ui_om_vehicle_x_parameters')
        self.dlg_load_manager.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_load_manager))
        self.dlg_load_manager.rejected.connect(partial(self.save_settings, self.dlg_load_manager))
        self.dlg_load_manager.cmb_filter_vehicle.currentIndexChanged.connect(partial(self.filter_loads))
        self.dlg_load_manager.btn_path.clicked.connect(partial(self.select_path, self.dlg_load_manager, 'txt_path'))

        self.dlg_load_manager.btn_export_load.clicked.connect(partial(self.export_model_to_csv, self.dlg_load_manager, self.tbl_load, 'txt_path', '', 'yyyy-MM-dd hh:mm:ss'))

        # Hide columns tbl_loads on load tab
        self.hide_colums(self.dlg_load_manager.tbl_loads, [0])

        # Open dialog
        self.open_dialog(self.dlg_load_manager)


    def open_work_register(self):

        self.dlg_work_register = WorkManagement()
        self.load_settings(self.dlg_work_register)

        table_object = 'om_visit_lot_x_user'
        self.dlg_work_register.tbl_work.setSelectionBehavior(QAbstractItemView.SelectRows)

        # Set a model with selected filter. Attach that model to selected table
        self.fill_table_object(self.dlg_work_register.tbl_work, self.schema_name + "." + table_object)
        self.set_table_columns(self.dlg_work_register, self.dlg_work_register.tbl_work, table_object)

        # Set filter events
        self.dlg_work_register.txt_team_filter.textChanged.connect(self.filter_team)

        # Set listeners
        self.dlg_work_register.btn_path.clicked.connect(partial(self.select_path, self.dlg_work_register, 'txt_path'))
        self.dlg_work_register.btn_accept.clicked.connect(partial(self.manage_accept, self.dlg_work_register.tbl_work))
        self.dlg_work_register.date_event_from.dateChanged.connect(partial(self.filter_team))
        self.dlg_work_register.date_event_to.dateChanged.connect(partial(self.filter_team))

        # Get columns to ignore for tab_relations when export csv
        sql = "SELECT column_id FROM config_client_forms WHERE location_type = 'tbl_user' AND status IS NOT TRUE AND table_id = 'om_visit_lot_x_user'"
        rows = self.controller.get_rows(sql, commit=True)
        result_relation = []
        if rows is not None:
            for row in rows:
                result_relation.append(row[0])
        else:
            result = ''

        # set timeStart and timeEnd as the min/max dave values get from model
        current_date = QDate.currentDate()
        sql = ('SELECT MIN(starttime), MAX(endtime)'
               ' FROM om_visit_lot_x_user')
        row = self.controller.get_row(sql, commit=self.autocommit)
        if row:
            if row[0]:
                self.dlg_work_register.date_event_from.setDate(row[0])
            if row[1]:
                self.dlg_work_register.date_event_to.setDate(row[1])
            else:
                self.dlg_work_register.date_event_to.setDate(current_date)

        # TODO: Disable columns user_id + team_id

        self.dlg_work_register.btn_export_user.clicked.connect(partial(self.export_model_to_csv, self.dlg_work_register,
                                                                       self.dlg_work_register.tbl_work, 'txt_path',
                                                                       result_relation, 'dd-MM-yyyy hh:mm:ss'))

        # Open form
        self.dlg_work_register.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_work_register.show()


    def manage_accept(self, widget):

        model = widget.model()
        status = model is not None and model.submitAll()
        if not status:
            return

        # Close dialog
        self.close_dialog(self.dlg_work_register)


    def filter_team(self):

        # Refresh model with selected filter
        filter = utils_giswater.getWidgetText(self.dlg_work_register, self.dlg_work_register.txt_team_filter)

        if filter == 'null':
            filter = ''

        visit_start = self.dlg_work_register.date_event_from.date()
        visit_end = self.dlg_work_register.date_event_to.date()

        if visit_start > visit_end:
            message = "Selected date interval is not valid"
            self.controller.show_warning(message)
            return

        # Create interval dates
        format_low = self.lot_date_format + ' 00:00:00.000'
        format_high = self.lot_date_format + ' 23:59:59.999'
        interval = "'"+str(visit_start.toString(format_low))+"'::timestamp AND '"+str(visit_end.toString(format_high))+"'::timestamp"

        expr_filter = ("(starttime BETWEEN "+str(interval)+" OR starttime IS NULL) "
                       "AND (endtime BETWEEN "+str(interval)+" OR endtime IS NULL)")

        expr_filter += " AND team_id::text LIKE '%"+str(filter)+"%'"

        self.dlg_work_register.tbl_work.model().setFilter(expr_filter)
        self.dlg_work_register.tbl_work.model().select()


    def filter_loads(self):

        # Refresh model with selected filter
        filter = utils_giswater.getWidgetText(self.dlg_load_manager, self.dlg_load_manager.cmb_filter_vehicle)

        if filter == 'null':
            expr_filter = ''
        else:
            expr_filter = " vehicle = '"+str(filter)+"'"

        self.dlg_load_manager.tbl_loads.model().setFilter(expr_filter)
        self.dlg_load_manager.tbl_loads.model().select()


    def lot_selector(self):

        self.dlg_lot_sel = Lot_selector()
        self.load_settings(self.dlg_lot_sel)

        self.dlg_lot_sel.btn_ok.clicked.connect(partial(self.close_dialog, self.dlg_lot_sel))
        self.dlg_lot_sel.rejected.connect(partial(self.close_dialog, self.dlg_lot_sel))
        self.dlg_lot_sel.rejected.connect(partial(self.save_settings, self.dlg_lot_sel))
        self.dlg_lot_sel.setWindowTitle("Selector de lots")
        utils_giswater.setWidgetText(self.dlg_lot_sel, 'lbl_filter',
                                     self.controller.tr('Filtrar per: Lot id', context_name='labels'))
        utils_giswater.setWidgetText(self.dlg_lot_sel, 'lbl_unselected',
                                     self.controller.tr('Lots disponibles:', context_name='labels'))
        utils_giswater.setWidgetText(self.dlg_lot_sel, 'lbl_selected',
                                     self.controller.tr('Lots seleccionats', context_name='labels'))

        tableleft = "v_ui_om_visit_lot"
        tableright = "selector_lot"
        field_id_left = "id"
        field_id_right = "lot_id"

        hide_left = [1, 2, 4, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
        hide_right = [1, 2, 3, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

        self.populate_lot_selector(self.dlg_lot_sel, tableleft, tableright, field_id_left, field_id_right,
                                hide_left, hide_right)
        self.dlg_lot_sel.btn_select.clicked.connect(partial(self.set_visible_lot_layers, True))
        self.dlg_lot_sel.btn_unselect.clicked.connect(partial(self.set_visible_lot_layers, True))

        # Open dialog
        self.open_dialog(self.dlg_lot_sel, maximize_button=False)


    def populate_lot_selector(self, dialog, tableleft, tableright, field_id_left, field_id_right, hide_left, hide_right):

        # Get rows id on table lot manager
        model = self.dlg_lot_man.tbl_lots.model()
        data = ['']
        for row in range(model.rowCount()):
            index = model.index(row, 0)
            data.append(str(model.data(index)))

        # fill QTableView all_rows
        tbl_all_rows = dialog.findChild(QTableView, "all_rows")
        tbl_all_rows.setSelectionBehavior(QAbstractItemView.SelectRows)

        query_left = "SELECT * FROM "+tableleft+" WHERE id NOT IN "
        query_left += "(SELECT "+tableleft+".id FROM "+tableleft+""
        query_left += " RIGHT JOIN "+tableright+" ON "+tableleft+"."+field_id_left+" = "+tableright+"."+field_id_right+""
        query_left += " WHERE cur_user = current_user)"
        query_left += " AND id::text = ANY(ARRAY" + str(data) + ")"
        query_left += " AND "+field_id_left+" > -1 ORDER BY id desc"

        self.fill_table_by_query(tbl_all_rows, query_left)
        self.hide_colums(tbl_all_rows, hide_left)
        tbl_all_rows.setColumnWidth(1, 200)

        # fill QTableView selected_rows
        tbl_selected_rows = dialog.findChild(QTableView, "selected_rows")
        tbl_selected_rows.setSelectionBehavior(QAbstractItemView.SelectRows)

        query_right = "SELECT "+tableright+".lot_id, * FROM " + tableleft + ""
        query_right += " JOIN "+tableright+" ON "+tableleft+"."+field_id_left+" = "+tableright+"."+field_id_right+""
        query_right += " WHERE cur_user = current_user AND lot_id::text = ANY(ARRAY" + str(data) + ") ORDER BY " + tableleft +".id desc"

        self.fill_table_by_query(tbl_selected_rows, query_right)
        self.hide_colums(tbl_selected_rows, hide_right)
        tbl_selected_rows.setColumnWidth(0, 200)
        # Button select
        dialog.btn_select.clicked.connect(partial(self.multi_rows_selector, tbl_all_rows, tbl_selected_rows, field_id_left, tableright, field_id_right, query_left, query_right, field_id_right))

        # Button unselect
        query_delete = "DELETE FROM "+tableright+""
        query_delete += " WHERE current_user = cur_user AND "+tableright+"."+field_id_right+"="
        dialog.btn_unselect.clicked.connect(partial(self.unselector, tbl_all_rows, tbl_selected_rows, query_delete, query_left, query_right, field_id_right))
        # QLineEdit
        dialog.txt_name.textChanged.connect(
            partial(self.filter_lot_selector, dialog, dialog.txt_name, tbl_all_rows, tableleft, tableright,
                    field_id_right, field_id_left))
        dialog.txt_status_filter.textChanged.connect(
            partial(self.filter_lot_selector, dialog, dialog.txt_status_filter, tbl_all_rows, tableleft, tableright,
                    field_id_right, field_id_left))
        dialog.txt_wotype_filter.textChanged.connect(
            partial(self.filter_lot_selector, dialog, dialog.txt_wotype_filter, tbl_all_rows, tableleft, tableright,
                    field_id_right, field_id_left))


    def filter_lot_selector(self, dialog, text_line, qtable, tableleft, tableright, field_id_r, field_id_l):
        """ Fill the QTableView by filtering through the QLineEdit"""
        filter_id = utils_giswater.getWidgetText(dialog, dialog.txt_name)
        filter_status = utils_giswater.getWidgetText(dialog, dialog.txt_status_filter)
        filter_wotype = utils_giswater.getWidgetText(dialog, dialog.txt_wotype_filter)

        if str(filter_id) == 'null':
            filter_id = ''
        if str(filter_status) == 'null':
            filter_status = ''
        if str(filter_wotype) == 'null':
            filter_wotype = ''

        sql = ("SELECT * FROM " + self.schema_name + "." + tableleft + " WHERE id::text NOT IN "
                "(SELECT " + tableleft + ".id::text FROM " + self.schema_name + "." + tableleft + ""
                " RIGHT JOIN " + self.schema_name + "." + tableright + ""
                " ON " + tableleft + "." + field_id_l + " = " + tableright + "." + field_id_r + ""
                " WHERE cur_user = current_user) AND LOWER(id::text) LIKE '%" + str(filter_id) + "%'"
                " AND LOWER("+'"Estat"'+"::text) LIKE '%" + str(filter_status) + "%'"
                " AND (LOWER("+'"Tipus actuacio"'+"::text) LIKE '%" + str(filter_wotype) + "%'")
        if filter_wotype in (None, ''):
            sql += " OR LOWER("+'"Tipus actuacio"'+"::text) IS NULL)"
        else:
            sql += ")"
        self.fill_table_by_query(qtable, sql)


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
        query +=" ORDER BY " +col_to_sort + " " + oder_by[sort_order]+""
        self.fill_table_by_query(qtable, query)
        self.refresh_map_canvas()


    def set_visible_lot_layers(self, zoom=False):
        """ Set visible lot layers """

        # Refresh extension of layer
        layer = self.controller.get_layer_by_tablename("v_lot")
        if layer:
            self.controller.set_layer_visible(layer)
            if zoom:
                # Refresh extension of layer
                layer.updateExtents()
                # Zoom to executed mincut
                self.iface.setActiveLayer(layer)
                self.iface.zoomToActiveLayer()


    def save_user_values(self, dialog):

        cur_user = self.controller.get_current_user()
        csv_path = utils_giswater.getWidgetText(dialog, dialog.txt_path)
        self.controller.plugin_settings_set_value(dialog.objectName() + cur_user, csv_path)


    def load_user_values(self, dialog):

        cur_user = self.controller.get_current_user()
        csv_path = self.controller.plugin_settings_value(dialog.objectName() + cur_user)
        utils_giswater.setWidgetText(dialog, dialog.txt_path, str(csv_path))


    def select_path(self, dialog, widget_name):

        widget = utils_giswater.getWidget(dialog, str(widget_name))
        csv_path = utils_giswater.getWidgetText(dialog, widget)
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

        utils_giswater.setWidgetText(dialog, widget, csv_path)


    def export_model_to_csv(self, dialog, qtable, widget_name, columns=(''), date_format='yyyy-MM-dd'):
        """
        :param columns: tuple of columns to not export ('column1', 'column2', '...')
        """

        widget = utils_giswater.getWidget(dialog, str(widget_name))
        csv_path = utils_giswater.getWidgetText(dialog, widget)
        if str(csv_path) == 'null':
            msg = "Select a valid path."
            self.controller.show_info_box(msg, "Info")
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
                answer = self.controller.ask_question(msg, "Overwrite")
                if answer:
                    self.write_to_csv(csv_path, all_rows)
            else:
                self.write_to_csv(csv_path, all_rows)
        except Exception as e:
            print(str(e))
            msg = "File path doesn't exist or you dont have permission or file is opened"
            self.controller.show_warning(msg)
            pass


    def write_to_csv(self, folder_path=None, all_rows=None):

        with open(folder_path, "w") as output:
            writer = csv.writer(output, lineterminator='\n')
            writer.writerows(all_rows)
        message = "El fitxer csv ha estat exportat correctament"
        self.controller.show_info(message)


    def populate_combo_filters(self, combo, table_name, fields="id, idval"):

        sql = ("SELECT "+str(fields)+" "
               "FROM "+str(table_name)+" "
               "ORDER BY idval")
        rows = self.controller.get_rows(sql, commit=True)
        if rows:
            rows.append(['', ''])
            utils_giswater.set_item_data(combo, rows, 1)


    def delete_lot(self, qtable):
        """ Delete selected lots """

        selected_list = qtable.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        elif len(selected_list) > 1:
            message = "Please, select only one row"
            self.controller.show_warning(message)
            return
        message = "Are you sure you want to delete this lot?"
        answer = self.controller.ask_question(message, "Delete lots")
        if answer:
            result = selected_list[0].row()

            # Get object_id from selected row
            selected_object_id = qtable.model().record(result).value('id')
            sql = ("SELECT id "
                   "FROM om_visit WHERE lot_id = " + str(selected_object_id) + " "
                   "ORDER BY id")
            rows = self.controller.get_rows(sql, commit=True)

            if str(rows) != "[]":
                message = "This lot has associated visits and will be deleted. Do you want to continue?"
                answer = self.controller.ask_question(message, "Delete lots")
                if not answer:
                    return

                sql = ("DELETE FROM om_visit "
                       " WHERE lot_id =" + str(selected_object_id) + "")
                self.controller.execute_sql(sql)

            for x in range(0, len(selected_list)):
                row = selected_list[x].row()
                _id = qtable.model().record(row).value('id')
                sql = ("DELETE FROM om_visit_lot "
                       " WHERE id ='" + str(_id) + "'")
                self.controller.execute_sql(sql)
            self.filter_lot()

    def open_lot(self, dialog, qtable):
        """ Open object form with selected record of the table """

        selected_list = qtable.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        row = selected_list[0].row()

        # Get object_id from selected row
        selected_object_id = qtable.model().record(row).value('id')
        visitclass_id = qtable.model().record(row).value('visitclass_id')

        # Close this dialog and open selected object
        dialog.close()
        sql = ("INSERT INTO selector_lot(lot_id, cur_user) "
               " VALUES("+str(selected_object_id)+", current_user) "
               " ON CONFLICT DO NOTHING;")
        self.controller.execute_sql(sql)
        # set previous dialog
        self.manage_lot(selected_object_id, is_new=False, visitclass_id=visitclass_id)


    def filter_lot(self):
        """ Filter om_visit in self.dlg_lot_man.tbl_lots based on (id AND text AND between dates) """

        serie = utils_giswater.getWidgetText(self.dlg_lot_man, self.dlg_lot_man.txt_codi_ot)
        actuacio = utils_giswater.get_item_data(self.dlg_lot_man, self.dlg_lot_man.cmb_actuacio, 0)
        adreca = utils_giswater.getWidgetText(self.dlg_lot_man, self.dlg_lot_man.txt_address, False, False)
        status = utils_giswater.get_item_data(self.dlg_lot_man, self.dlg_lot_man.cmb_estat, 1, add_quote=True)
        assignat = utils_giswater.isChecked(self.dlg_lot_man, self.dlg_lot_man.chk_assignacio)

        # Get show null values
        show_nulls = self.dlg_lot_man.chk_show_nulls.isChecked()

        # Get date type
        date_type = utils_giswater.getWidgetText(self.dlg_lot_man, self.dlg_lot_man.cmb_date_filter_type)
        if date_type == 'Data inici':
            filter_name = 'Data inici'
        elif date_type == 'Data fi':
            filter_name = 'Data fi'
        elif date_type == 'Data inici planificada':
            filter_name = 'Data inici planificada'
        elif date_type == 'Data final planificada':
            filter_name = 'Data final planificada'
        else:
            return

        visit_start = self.dlg_lot_man.date_event_from.date()
        visit_end = self.dlg_lot_man.date_event_to.date()

        if visit_start > visit_end:
            message = "Selected date interval is not valid"
            self.controller.show_warning(message)
            return

        # Create interval dates
        format_low = self.lot_date_format + ' 00:00:00.000'
        format_high = self.lot_date_format + ' 23:59:59.999'
        interval = "'"+str(visit_start.toString(format_low))+"'::timestamp AND '"+str(visit_end.toString(format_high))+"'::timestamp"

        expr_filter = ("(\"" + str(filter_name) + "\" BETWEEN " + str(interval) + " ")
        if show_nulls:
            expr_filter += " OR \"" + str(filter_name) + "\" IS NULL) "
        else:
            expr_filter += ") "
        if serie != 'null':
            expr_filter += " AND \"Serie\" ILIKE '%"+str(serie)+"%'"
        if actuacio != '' and actuacio != -1:
            expr_filter += " AND wotype_id ILIKE '%"+str(actuacio)+"%' "
        if adreca != '':
            expr_filter += " AND \"Carrer\" ILIKE '%"+str(adreca)+"%' "
        if status != '':
            expr_filter += " AND \"Estat\"::TEXT ILIKE '%"+str(status)+"%'"
        if assignat:
            expr_filter += " AND \"Serie\" IS NULL "

        # Refresh model with selected filter
        self.dlg_lot_man.tbl_lots.model().setFilter(expr_filter)
        self.dlg_lot_man.tbl_lots.model().select()


    def check_for_ids(self):
        if len(self.ids) != 0:
            self.visit_class.setEnabled(False)
        else:
            layer = self.iface.activeLayer()
            if layer:
                layer.removeSelection()
            self.iface.actionPan().trigger()
            self.visit_class.setEnabled(True)


    """ FUNCTIONS RELATED WITH TAB LOAD"""
    def fill_tab_load(self):
        """ Fill tab 'Load' """
        table_load = "v_ui_om_vehicle_x_parameters"
        filter = "lot_id = '" + str(utils_giswater.getWidgetText(self.dlg_lot, self.dlg_lot.lot_id)) + "'"

        self.fill_tbl_load_man(self.dlg_lot, self.tbl_load, table_load, filter)
        self.set_columns_config(self.tbl_load, table_load)

    def set_columns_config(self, widget, table_name, sort_order=0, isQStandardItemModel=False):
        """ Configuration of tables. Set visibility and width of columns """

        # Set width and alias of visible columns
        columns_to_delete = []
        sql = ("SELECT column_index, width, alias, status"
               " FROM config_client_forms"
               " WHERE table_id = '" + table_name + "'"
               " ORDER BY column_index")
        rows = self.controller.get_rows(sql, log_info=False, commit=True)
        if not rows:
            return widget

        for row in rows:
            if not row['status']:
                columns_to_delete.append(row['column_index'] - 1)
            else:
                width = row['width']
                if width is None:
                    width = 100
                widget.setColumnWidth(row['column_index'] - 1, width)
                if row['alias'] is not None:
                    widget.model().setHeaderData(row['column_index'] - 1, Qt.Horizontal, row['alias'])

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
        self.set_model_to_table(widget, self.schema_name + "." + table_name, expr_filter)

    def open_load_image(self, qtable, pg_table):

        selected_list = qtable.selectionModel().selectedRows(0)

        if selected_list == 0 or str(selected_list) == '[]':
            message = "Any load selected"
            self.controller.show_info_box(message)
            return

        elif len(selected_list) > 1:
            message = "More then one event selected. Select just one"
            self.controller.show_warning(message)
            return

        # Get path of selected image
        sql = ("SELECT image FROM " + pg_table + ""
               " WHERE rid = '" + str(selected_list[0].data()) + "'")
        row = self.controller.get_row(sql, commit=True)
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
                self.controller.show_warning(message, parameter=path)
            else:
                # Open the image
                os.startfile(path)


    def resources_management(self):

        # Create the dialog
        self.dlg_resources_man = ResourcesManagement()
        self.load_settings(self.dlg_resources_man)

        # Populate combos
        sql = ("SELECT id, idval FROM cat_team WHERE active is True ORDER BY idval")
        rows = self.controller.get_rows(sql, commit=True)
        if rows:
            utils_giswater.set_item_data(self.dlg_resources_man.cmb_team, rows, 1)

        sql = ("SELECT id, idval FROM ext_cat_vehicle ORDER BY idval")
        rows = self.controller.get_rows(sql, commit=True)
        if rows:
            utils_giswater.set_item_data(self.dlg_resources_man.cmb_vehicle, rows, 1)

        # Set signals
        self.dlg_resources_man.btn_team_create.clicked.connect(partial(self.manage_team))
        self.dlg_resources_man.btn_team_selector.clicked.connect(partial(self.open_team_selector))
        self.dlg_resources_man.btn_team_delete.clicked.connect(partial(self.delete_team))

        self.dlg_resources_man.btn_vehicle_create.clicked.connect(partial(self.manage_vehicle, True))
        self.dlg_resources_man.btn_vehicle_update.clicked.connect(partial(self.manage_vehicle, False))
        self.dlg_resources_man.btn_vehicle_delete.clicked.connect(partial(self.delete_vehicle))

        self.dlg_resources_man.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_resources_man))
        self.dlg_resources_man.rejected.connect(partial(self.save_settings, self.dlg_resources_man))

        # Open form
        self.open_dialog(self.dlg_resources_man)


    def open_team_selector(self):

        # Create the dialog
        self.dlg_team_man = TeamManagement()
        self.load_settings(self.dlg_team_man)

        # Set signals
        self.dlg_team_man.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_team_man))
        self.dlg_team_man.rejected.connect(partial(self.save_settings, self.dlg_team_man))

        # Tab Users
        self.populate_team_selectors(self.dlg_team_man, "cat_users", "v_om_user_x_team", "id", "user_id",
                                     [0,2], [0,2,3,4,5,6],
                                     "all_user_rows", "selected_user_rows", "btn_user_select", "btn_user_unselect")
        # Tab Vehciles
        self.populate_team_selectors(self.dlg_team_man, "ext_cat_vehicle", "v_om_team_x_vehicle", "idval", "vehicle",
                                     [0], [0, 5, 6, 7],
                                     "all_vehicle_rows", "selected_vehicle_rows", "btn_vehicle_select", "btn_vehicle_unselect")
        # Tab Visitclass
        self.populate_team_selectors(self.dlg_team_man, "om_visit_class", "v_om_team_x_visitclass", "idval", "visitclass",
                                     [0, 3, 4, 5, 6, 7, 8, 9], [0, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                                    "all_visitclass_rows", "selected_visitclass_rows", "btn_visitclass_select",
                                    "btn_visitclass_unselect")
        # Open form
        self.open_dialog(self.dlg_team_man)


    def populate_team_selectors(self, dialog, tableleft, tableright, field_id_left, field_id_right,
                                hide_left, hide_right, table_all, table_selected, button_select, button_unselect):

        # Get team selected
        filter_team = utils_giswater.getWidgetText(self.dlg_resources_man, "cmb_team")

        # Set window title
        dialog.setWindowTitle("Administrador d'equips - " + str(filter_team))

        # Get widgets
        btn_select = dialog.findChild(QPushButton, button_select)
        btn_unselect = dialog.findChild(QPushButton, button_unselect)

        # fill QTableView all_rows
        tbl_all_rows = dialog.findChild(QTableView, table_all)
        tbl_all_rows.setSelectionBehavior(QAbstractItemView.SelectRows)

        query_left = "SELECT * FROM " + tableleft + " WHERE id NOT IN "
        query_left += "(SELECT " + tableleft + ".id FROM " + tableleft + ""
        query_left += " RIGHT JOIN " + tableright + " ON " + tableleft + "." + field_id_left + "::text = " + tableright + "." + field_id_right + "::text"
        query_left += " WHERE team = '" + str(filter_team) + "')"

        self.fill_table_by_query(tbl_all_rows, query_left)
        self.hide_colums(tbl_all_rows, hide_left)
        tbl_all_rows.setColumnWidth(1, 200)

        # fill QTableView selected_rows
        tbl_selected_rows = dialog.findChild(QTableView, table_selected)
        tbl_selected_rows.setSelectionBehavior(QAbstractItemView.SelectRows)

        query_right = "SELECT * FROM " + tableleft + ""
        query_right += " JOIN " + tableright + " ON " + tableleft + "." + field_id_left + "::text = " + tableright + "." + field_id_right + "::text"
        query_right += " WHERE team = '" + str(filter_team) + "'"

        self.fill_table_by_query(tbl_selected_rows, query_right)
        self.hide_colums(tbl_selected_rows, hide_right)
        tbl_selected_rows.setColumnWidth(0, 200)
        # Button select
        btn_select.clicked.connect(
            partial(self.multi_rows_team_selector, tbl_all_rows, tbl_selected_rows, field_id_left, tableright,
                    field_id_right, query_left, query_right, field_id_right, filter_team))

        # Button unselect
        btn_unselect.clicked.connect(
            partial(self.team_unselector, tbl_all_rows, tbl_selected_rows, query_left, query_right,
                    field_id_right, tableright, tableleft, filter_team))


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
            self.controller.show_warning(message)
            return
        id_list = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = qtable_left.model().record(row).value(id_ori)
            id_list.append(id_)
        for i in range(0, len(id_list)):
            # Check if id_list already exists in id_selector
            sql = ("SELECT DISTINCT(" + id_des + ")"
                   " FROM " + self.schema_name + "." + tablename_des + ""
                   " WHERE " + id_des + " = '" + str(id_list[i]) + "' AND team = '" + filter_team + "'")
            row = self.controller.get_row(sql)

            if row:
                # if exist - show warning
                message = "Id already selected"
                self.controller.show_info_box(message, "Info", parameter=str(id_list[i]))
            else:
                sql = ("INSERT INTO " + self.schema_name + "." + tablename_des + " (" + field_id + ", team) "
                       " VALUES ('" + str(id_list[i]) + "', '" + filter_team + "')")
                self.controller.execute_sql(sql)

        # Refresh
        self.fill_table_by_query(qtable_right, query_right)
        self.fill_table_by_query(qtable_left, query_left)


    def team_unselector(self, qtable_left, qtable_right, query_left, query_right, field_id_right, tableright, tableleft, filter_team):

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
            query_delete = "DELETE FROM " + tableright + ""
            query_delete += " WHERE " + tableright + "." + field_id_right + "= '" + str(expl_id[i]) + "' "
            query_delete += " AND team = '" + str(filter_team) + "'"

            self.controller.execute_sql(query_delete)

        # Refresh
        self.fill_table_by_query(qtable_left, query_left)
        self.fill_table_by_query(qtable_right, query_right)

    def delete_team(self):

        # Get team selected
        filter_team = utils_giswater.getWidgetText(self.dlg_resources_man, "cmb_team")
        message = "You are trying delete team '" + str(filter_team) + "'. Do you want continue?"
        answer = self.controller.ask_question(message, "Delete team")
        if answer:
            sql = ("SELECT * FROM om_vehicle_x_parameters JOIN cat_team ON cat_team.id = om_vehicle_x_parameters.team_id WHERE cat_team.idval = '" + str(filter_team) + "'")
            rows = self.controller.get_rows(sql, log_sql=True)
            if rows:
                msg = "This team have some relations on om_vehicle_x_parameters table. Abort delete transaction."
                self.controller.show_info_box(msg, "Info")
                return
            sql = ("DELETE FROM cat_team WHERE idval = '" + str(filter_team) + "'")
            status = self.controller.execute_sql(sql)
            if status:
                msg = "Successful removal."
                self.controller.show_info_box(msg, "Info")
                sql = ("SELECT id, idval FROM cat_team WHERE active is True ORDER BY idval")
                rows = self.controller.get_rows(sql, commit=True)
                if rows:
                    utils_giswater.set_item_data(self.dlg_resources_man.cmb_team, rows, 1)


    def delete_vehicle(self):

        # Get vehicle selected
        filter_vehicle = utils_giswater.getWidgetText(self.dlg_resources_man, "cmb_vehicle")
        message = "You are trying delete vehicle '" + str(filter_vehicle) + "'. Do you want continue?"
        answer = self.controller.ask_question(message, "Delete vehicle")
        if answer:
            sql = ("DELETE FROM ext_cat_vehicle WHERE idval = '" + str(filter_vehicle) + "'")
            status = self.controller.execute_sql(sql)
            if status:
                msg = "Successful removal."
                self.controller.show_info_box(msg, "Info")
                sql = ("SELECT id, idval FROM ext_cat_vehicle ORDER BY idval")
                rows = self.controller.get_rows(sql, commit=True)
                if rows:
                    utils_giswater.set_item_data(self.dlg_resources_man.cmb_vehicle, rows, 1)


    def manage_vehicle(self, add_vehicle=False):
        """ Open dialog of teams """

        self.max_id = self.get_max_id('ext_cat_vehicle')
        self.dlg_basic_table = BasicTable()
        self.load_settings(self.dlg_basic_table)
        self.dlg_basic_table.setWindowTitle("Vehicle management")
        table_name = 'ext_cat_vehicle'

        # @setEditStrategy: 0: OnFieldChange, 1: OnRowChange, 2: OnManualSubmit
        self.fill_table(self.dlg_basic_table.tbl_basic, table_name, QSqlTableModel.OnManualSubmit)
        self.set_table_columns(self.dlg_basic_table, self.dlg_basic_table.tbl_basic, table_name)
        self.dlg_basic_table.btn_cancel.clicked.connect(partial(self.cancel_changes, self.dlg_basic_table.tbl_basic))
        self.dlg_basic_table.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_basic_table))
        self.dlg_basic_table.btn_accept.clicked.connect(
            partial(self.save_table, self.dlg_basic_table, self.dlg_basic_table.tbl_basic, manage_type='vehicle'))
        self.dlg_basic_table.btn_accept.clicked.connect(partial(self.close_dialog, self.dlg_basic_table))
        self.dlg_basic_table.btn_add_row.clicked.connect(partial(self.add_row, self.dlg_basic_table.tbl_basic))
        self.dlg_basic_table.rejected.connect(partial(self.save_settings, self.dlg_basic_table))

        if not add_vehicle:
            self.dlg_basic_table.btn_add_row.setVisible(False)
        self.open_dialog(self.dlg_basic_table)


    def manage_date_filter(self):

        # Get date type
        date_type = utils_giswater.getWidgetText(self.dlg_lot_man, self.dlg_lot_man.cmb_date_filter_type)

        settings = QSettings()
        settings.setValue("vdefault/date_filter", str(date_type))
