# -*- coding: utf-8 -*-
"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
from qgis.core import QgsPointXY
from qgis.PyQt.QtCore import QStringListModel, QDate, QSortFilterProxyModel, Qt, QDateTime
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
import urllib.parse
import webbrowser

from .. import utils_giswater
from .manage_visit import ManageVisit
from .parent_manage import ParentManage
from ..ui_manager import LotUi
from ..ui_manager import BasicTable
from ..ui_manager import LotManagement
from ..ui_manager import Multirow_selector
from ..ui_manager import UserManagement


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
        self.cmb_position = 15  # Variable used to set the position of the QCheckBox in the relations table

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

        self.dlg_lot = LotUi()
        self.load_settings(self.dlg_lot)
        self.load_user_values(self.dlg_lot)
        self.dropdown = self.dlg_lot.findChild(QToolButton, 'action_selector')
        self.dropdown.setPopupMode(QToolButton.MenuButtonPopup)

        # Create action and put into QToolButton
        action_by_expression = self.create_action('action_by_expression', self.dlg_lot.action_selector, '204', 'Select by expression')
        action_by_polygon = self.create_action('action_by_polygon', self.dlg_lot.action_selector, '205', 'Select by polygon')
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
        action_by_expression.triggered.connect(partial(self.activate_selection, self.dlg_lot, action_by_expression, 'mActionSelectByExpression'))
        action_by_polygon.triggered.connect(partial(self.activate_selection, self.dlg_lot, action_by_polygon, 'mActionSelectPolygon'))

        # Set widgets signals
        self.dlg_lot.cmb_ot.activated.connect(partial(self.set_ot_fields))
        self.dlg_lot.cmb_ot.editTextChanged.connect(partial(self.filter_by_list, self.dlg_lot.cmb_ot))

        self.dlg_lot.btn_feature_insert.clicked.connect(partial(self.insert_row))
        self.dlg_lot.btn_feature_delete.clicked.connect(partial(self.remove_selection, self.dlg_lot, self.tbl_relation))
        self.dlg_lot.btn_feature_snapping.clicked.connect(partial(self.set_active_layer))
        self.dlg_lot.btn_feature_snapping.clicked.connect(partial(self.selection_init, self.dlg_lot))
        self.dlg_lot.cmb_visit_class.currentIndexChanged.connect(self.set_tab_dis_enabled)
        self.dlg_lot.cmb_visit_class.currentIndexChanged.connect(self.set_active_layer)
        self.dlg_lot.cmb_visit_class.currentIndexChanged.connect(partial(self.event_feature_type_selected, self.dlg_lot))
        self.dlg_lot.cmb_visit_class.currentIndexChanged.connect(partial(self.reload_table_visit))
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
        self.dlg_lot.cmb_man_team.clicked.connect(self.manage_team)
        self.set_lot_headers()
        self.set_active_layer()

        self.set_icon(self.dlg_lot.btn_open_image, "136b")
        self.dlg_lot.btn_open_image.clicked.connect(self.open_load_image)

        if lot_id is not None:
            self.set_values(lot_id)
            self.geom_type = utils_giswater.get_item_data(self.dlg_lot, self.visit_class, 2).lower()
            self.populate_table_relations(lot_id)
            self.update_id_list()
            self.set_dates_from_to(self.dlg_lot.date_event_from, self.dlg_lot.date_event_to, 've_visit_emb_neteja', 'startdate','enddate')
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

            sql = f"SELECT column_id FROM config_client_forms WHERE location_type = 'tbl_visit' AND status IS NOT TRUE AND table_id = '{table_name}'"
            rows = self.controller.get_rows(sql)
            result_visit = []
            if rows is not None:
                for row in rows:
                    result_visit.append(row[0])
            else:
                result_visit = ''
        else:
            result_visit = ''

        # Get columns to ignore for tab_relations when export csv
        sql = f"SELECT column_id FROM config_client_forms WHERE location_type = 'lot' AND status IS NOT TRUE AND table_id = 've_lot_x_{self.geom_type}'"
        rows = self.controller.get_rows(sql)
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
            index = model.index(x, self.cmb_position-1)
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
        rows = self.controller.get_rows(sql)
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
        self.dlg_basic_table.btn_accept.clicked.connect(partial(self.save_basic_table, self.dlg_basic_table.tbl_basic, 'team'))
        self.dlg_basic_table.btn_add_row.clicked.connect(partial(self.add_row, self.dlg_basic_table.tbl_basic))
        self.dlg_basic_table.rejected.connect(partial(self.save_settings, self.dlg_basic_table))
        self.open_dialog(self.dlg_basic_table)


    def populate_cmb_team(self):
        """ Fill ComboBox cmb_assigned_to """

        sql = ("SELECT id, idval "
               "FROM cat_team "
               "WHERE active is True "
               "ORDER BY idval")
        rows = self.controller.get_rows(sql)
        if rows:
            utils_giswater.set_item_data(self.dlg_lot.cmb_assigned_to, rows, 1)


    def cancel_changes(self, qtable):

        model = qtable.model()
        model.revertAll()
        model.database().rollback()


    def add_row(self, qtable):
        """ Append new record to model with correspondent id """

        self.max_id += 1
        model = qtable.model()
        record = model.record()
        record.setValue("id", self.max_id)
        model.insertRecord(model.rowCount(), record)


    def get_max_id(self, table_name):

        sql = ("SELECT MAX(id) FROM " + table_name)
        row = self.controller.get_row(sql)
        if row[0] is not None:
            return int(row[0])

        return 0


    def save_basic_table(self, qtable, manage_type=None):

        model = qtable.model()
        if model.submitAll():
            self.close_dialog(self.dlg_basic_table)
            if manage_type == 'team':
                self.populate_cmb_team()
            else:
                self.controller.log_info(model.lastError().text())


    def manage_widget_lot(self, lot_id):

        # Fill ComboBox cmb_ot
        sql = ("SELECT ext_workorder.ct, ext_workorder.class_id,  ext_workorder.wotype_id, ext_workorder.wotype_name, "
               " ext_workorder.address, ext_workorder.serie, ext_workorder.visitclass_id "
               " FROM ext_workorder "
               " LEFT JOIN om_visit_lot ON om_visit_lot.serie = ext_workorder.serie ")
        if lot_id:
            _sql = (f"SELECT serie FROM om_visit_lot "
                    f" WHERE id = '{lot_id}'")
            ct = self.controller.get_row(_sql)
            sql += f" OR ext_workorder.serie = '{ct[0]}'"
        sql += " order by ct"
        rows = self.controller.get_rows(sql)

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
            self.dlg_lot.startdate.setStyleSheet(None)
            self.dlg_lot.enddate.setStyleSheet(None)
            return

        # Transform text dates as QDate
        if startdate: startdate = startdate.replace('/', '-')
        startdate = QDate.fromString(startdate, self.lot_date_format)
        if enddate: enddate = enddate.replace('/', '-')
        enddate = QDate.fromString(enddate, self.lot_date_format)

        if startdate <= enddate:
            self.dlg_lot.startdate.setStyleSheet(None)
            self.dlg_lot.enddate.setStyleSheet(None)
        else:
            self.dlg_lot.startdate.setStyleSheet("border: 1px solid red")
            self.dlg_lot.enddate.setStyleSheet("border: 1px solid red")


    def set_ot_fields(self, index):

        item = self.list_to_work[index]
        utils_giswater.setWidgetText(self.dlg_lot, self.dlg_lot.txt_ot_type, item[0])
        utils_giswater.setWidgetText(self.dlg_lot, self.dlg_lot.txt_wotype_id, item[2])
        utils_giswater.setWidgetText(self.dlg_lot, self.dlg_lot.txt_ot_address, item[3])
        utils_giswater.setWidgetText(self.dlg_lot, self.dlg_lot.descript,  item[1])
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
            id_list += f"'{feature_id}', "
            msg_records += f"visit_id: {visit_id}, {feature_type}_id = '{feature_id}';\n"
        id_list = id_list[:-2] + ")"
        answer = self.controller.ask_question(message, "Delete records", msg_records)
        if answer:
            sql = (f"DELETE FROM om_visit_x_{feature_type} "
                   f" WHERE visit_id = '{visit_id}' "
                   f" AND {feature_type}_id IN {id_list};\n")
            self.controller.execute_sql(sql)

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

        visitclass_ids = self.controller.get_rows(sql)
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

        sql = f"SELECT max({pk}::integer) FROM {table_name};"
        row = self.controller.get_row(sql)
        if not row or not row[0]:
            return 0
        else:
            return row[0]+1


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
        lot = self.controller.get_row(sql)
        if lot:
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
            table_name = f"{self.schema_name}.{table_name}"

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
        column_index = utils_giswater.get_col_index_by_col_name(qtable, geom_type+'_id')
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
        self.iface.mainWindow().findChild(QAction,action_name).trigger()


    def selection_changed_by_expr(self, dialog, layer, geom_type):

        self.canvas.selectionChanged.connect(partial(self.manage_selection, dialog,  layer, geom_type))


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

                sql = f"SELECT ST_GeomFromText('{feature.geometry().asWkt()}', {self.srid})"
                the_geom = self.controller.get_row(sql, log_sql=True)
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
        i = qtable.model().index(qtable.model().rowCount()-1, self.cmb_position)
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

        for i in range(len(index_list)-1, -1, -1):
            row = index_list[i].row()
            column_index = utils_giswater.get_col_index_by_col_name(qtable, feature_type + '_id')
            feature_id = index.sibling(row, column_index).data()
            self.ids.remove(feature_id)
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
            self.canvas.selectionChanged.connect(partial(self.manage_selection, dialog,  self.layer_lot, self.geom_type))
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

                if feature_type in('', 'null', None, -1):
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
        interval = f"'{visit_start.toString(format_low)}'::timestamp AND '{visit_end.toString(format_high)}'::timestamp"

        expr_filter = f"(startdate BETWEEN {interval}) AND (enddate BETWEEN {interval} OR enddate is NULL)"

        if object_id != 'null':
            expr_filter += f" AND {feature_type}_id::TEXT ILIKE '%{object_id}%'"
        if lot_id != '':
            expr_filter += f" AND lot_id='{lot_id}'"

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
        sql = (f"SELECT * FROM {table_name}"
               f" WHERE lot_id ='{lot_id}'"
               f" AND {expr_filter}")
        rows = self.controller.get_rows(sql)

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
        self.put_combobox(self.dlg_lot.tbl_visit, rows, 'status', 15, combo_values)


    def populate_table_relations(self, lot_id):

        standard_model = self.tbl_relation.model()
        feature_type = utils_giswater.get_item_data(self.dlg_lot, self.dlg_lot.cmb_visit_class, 2).lower()

        sql = (f"SELECT * FROM ve_lot_x_{feature_type} "
               f"WHERE lot_id ='{lot_id}'")
        rows = self.controller.get_rows(sql)
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
                    values += f"$${value}$$, "
                    update += f"{key}=$${value}$$, "
                else:
                    values += f"$${value}$$, "
                    update += f"{key}=$${value}$$, "
            else:
                values += "null, "
                update += f"{key}=null, "

        keys = keys[:-2]
        values = values[:-2]
        update = update[:-2]

        if self.is_new_lot is True:
            sql = (f"INSERT INTO om_visit_lot({keys}) "
                   f" VALUES ({values}) RETURNING id")
            row = self.controller.execute_returning(sql)
            lot_id = row[0]
            sql = (f"INSERT INTO selector_lot "
                   f"(lot_id, cur_user) VALUES({lot_id}, current_user);")
            self.controller.execute_sql(sql)
            self.refresh_map_canvas()
        else:
            lot_id = utils_giswater.getWidgetText(self.dlg_lot, 'lot_id', False, False)
            sql = (f"UPDATE om_visit_lot "
                   f" SET {update}"
                   f" WHERE id = '{lot_id}'; \n")
            self.controller.execute_sql(sql)

        self.save_relations(lot, lot_id)
        status = self.save_visits()
        if status:
            self.manage_rejected()


    def save_relations(self, lot, lot_id):

        # Manage relations
        sql = (f"DELETE FROM om_visit_lot_x_{lot['feature_type']} "
               f"WHERE lot_id = '{lot_id}'; \n")

        model_rows = self.read_standaritemmodel(self.tbl_relation)

        if model_rows is None:
            return

        # Save relations
        for item in model_rows:
            keys = "lot_id, "
            values = f"$${lot_id}$$, "
            for key, value in list(item.items()):
                if key in (lot['feature_type']+'_id', 'code', 'status', 'observ', 'validate'):
                    if value not in('', None):
                        keys += f"{key}, "
                        # if type(value) in (int, bool):
                        #     values += f"$$"+str(value)+"$$, "
                        # else:
                        #     values += "$$" + value + "$$, "
                        values += f"$${value}$$, "
            keys = keys[:-2]
            values = values[:-2]
            sql += (f"INSERT INTO om_visit_lot_x_{lot['feature_type']}({keys}) "
                    f"VALUES ({values}); \n")
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
                if key=="visit_id":
                    visit_id = str(value)
                if key == "status":
                    if value not in('', None):
                        status = f"$${value}$$ "

            if visit_id and status:
                sql += (f"UPDATE {table_name} "
                        f"SET (status) = ({status}) "
                        f"WHERE visit_id = '{visit_id}';\n")
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
        column_index = utils_giswater.get_col_index_by_col_name(qtable, feature_type+'_id')
        feature_id = index.sibling(row, column_index).data()
        # expr_filter = '"{}_id" IN ({})'.format(feature_type, "'"+feature_id+"'")
        expr_filter = f"\"{feature_type}_id\" IN ('{feature_id}')"
        # Check expression
        (is_valid, expr) = self.check_expression(expr_filter)
        
        self.select_features_by_ids(feature_type, expr)
        # self.iface.actionZoomToSelected().trigger()
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
            coords += f"{c[0]} {c[1]},"
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

        table_object = "v_ui_om_visit_lot"

        # set timeStart and timeEnd as the min/max dave values get from model
        current_date = QDate.currentDate()
        sql = (f'SELECT MIN(startdate), MAX(startdate)'
               f' FROM om_visit_lot')
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
            partial(self.export_model_to_csv, self.dlg_lot_man, 'txt_path', self.dlg_lot_man.tbl_lots, '', self.lot_date_format))
        self.dlg_lot_man.tbl_lots.doubleClicked.connect(partial(self.open_lot, self.dlg_lot_man, self.dlg_lot_man.tbl_lots))
        self.dlg_lot_man.btn_open.clicked.connect(partial(self.open_lot, self.dlg_lot_man, self.dlg_lot_man.tbl_lots))
        self.dlg_lot_man.btn_delete.clicked.connect(partial(self.delete_lot, self.dlg_lot_man.tbl_lots))
        self.dlg_lot_man.btn_manage_user.clicked.connect(partial(self.open_user_manage))
        self.dlg_lot_man.btn_manage_vehicle.clicked.connect(partial(self.open_vehicle_manage))

        # Set filter events
        self.dlg_lot_man.txt_codi_ot.textChanged.connect(self.filter_lot)
        self.dlg_lot_man.cmb_actuacio.currentIndexChanged.connect(self.filter_lot)
        self.dlg_lot_man.txt_address.textChanged.connect(self.filter_lot)
        self.dlg_lot_man.cmb_estat.currentIndexChanged.connect(self.filter_lot)
        self.dlg_lot_man.chk_assignacio.stateChanged.connect(self.filter_lot)
        self.dlg_lot_man.date_event_from.dateChanged.connect(self.filter_lot)
        self.dlg_lot_man.date_event_to.dateChanged.connect(self.filter_lot)

        # Open form
        self.open_dialog(self.dlg_lot_man, dlg_name="visit_management")


    def open_vehicle_manage(self):

        self.max_id = self.get_max_id('om_team_x_vehicle')
        self.dlg_basic_table = BasicTable()
        self.load_settings(self.dlg_basic_table)
        self.dlg_basic_table.setWindowTitle("Vehicle management")
        table_name = 'v_om_team_x_vehicle'
        # TODO:: Add trigger editable view into v_om_team_x_vehicle
        # table_name = 'om_team_x_vehicle'

        widget = QPushButton()
        widget.setText(str('Test'))
        widget.setStyleSheet("Text-align:left")
        widget.setFlat(True)
        widget.setObjectName("test")

        # @setEditStrategy: 0: OnFieldChange, 1: OnRowChange, 2: OnManualSubmit
        self.fill_table(self.dlg_basic_table.tbl_basic, table_name, QSqlTableModel.OnManualSubmit)
        self.set_table_columns(self.dlg_basic_table, self.dlg_basic_table.tbl_basic, table_name)
        self.dlg_basic_table.btn_cancel.clicked.connect(partial(self.cancel_changes, self.dlg_basic_table.tbl_basic))
        self.dlg_basic_table.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_basic_table))
        self.dlg_basic_table.btn_accept.clicked.connect(partial(self.save_basic_table, self.dlg_basic_table.tbl_basic, 'vehicle'))
        self.dlg_basic_table.btn_add_row.clicked.connect(partial(self.add_row, self.dlg_basic_table.tbl_basic))
        self.dlg_basic_table.rejected.connect(partial(self.save_settings, self.dlg_basic_table))
        self.open_dialog(self.dlg_basic_table)

        # Populate model visit
        sql = ("SELECT * FROM v_om_team_x_vehicle ORDER BY id")
        rows = self.controller.get_rows(sql)

        if rows is None:
            return

        # Add combo into column team_id
        sql = ("SELECT id, idval"
               " FROM cat_team"
               " ORDER BY id")
        combo_values = self.controller.get_rows(sql)

        if combo_values is None:
            return

        self.put_combobox(self.dlg_basic_table.tbl_basic, rows, 1, 1, combo_values)

        # Add combo into column vehicle_id
        sql = ("SELECT id, idval"
               " FROM ext_cat_vehicle"
               " ORDER BY id")
        combo_values = self.controller.get_rows(sql)

        if combo_values is None:
            return

        self.put_combobox(self.dlg_basic_table.tbl_basic, rows, 2, 2, combo_values)


    def open_user_manage(self):

        self.dlg_user_manage = UserManagement()
        self.load_settings(self.dlg_user_manage)

        table_object = 'om_visit_lot_x_user'
        self.dlg_user_manage.tbl_user.setSelectionBehavior(QAbstractItemView.SelectRows)

        # Set a model with selected filter. Attach that model to selected table
        self.fill_table_object(self.dlg_user_manage.tbl_user, self.schema_name + "." + table_object)
        self.set_table_columns(self.dlg_user_manage, self.dlg_user_manage.tbl_user, table_object)

        # Set filter events
        self.dlg_user_manage.txt_user_filter.textChanged.connect(self.filter_user)

        # Set listeners
        self.dlg_user_manage.btn_path.clicked.connect(partial(self.select_path, self.dlg_user_manage))
        self.dlg_user_manage.btn_accept.clicked.connect(partial(self.manage_accept, self.dlg_user_manage.tbl_user))
        self.dlg_user_manage.date_event_from.dateChanged.connect(partial(self.filter_user))
        self.dlg_user_manage.date_event_to.dateChanged.connect(partial(self.filter_user))

        # Get columns to ignore for tab_relations when export csv
        sql = "SELECT column_id FROM config_client_forms WHERE location_type = 'tbl_user' AND status IS NOT TRUE AND table_id = 'om_visit_lot_x_user'"
        rows = self.controller.get_rows(sql)
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
                self.dlg_user_manage.date_event_from.setDate(row[0])
            if row[1]:
                self.dlg_user_manage.date_event_to.setDate(row[1])
            else:
                self.dlg_user_manage.date_event_to.setDate(current_date)

        # TODO: Disable columns user_id + team_id

        self.dlg_user_manage.btn_export_user.clicked.connect(partial(self.export_model_to_csv, self.dlg_user_manage, self.dlg_user_manage.tbl_user, result_relation, 'yyyy-MM-dd hh:mm:ss'))

        # Open form
        self.open_dialog(self.dlg_user_manage)


    def manage_accept(self, widget):

        model = widget.model()
        status = model is not None and model.submitAll()
        if not status:
            return

        # Close dialog
        self.close_dialog(self.dlg_user_manage)


    def filter_user(self):

        # Refresh model with selected filter
        filter = utils_giswater.getWidgetText(self.dlg_user_manage, self.dlg_user_manage.txt_user_filter)

        if filter == 'null':
            filter = ''


        visit_start = self.dlg_user_manage.date_event_from.date()
        visit_end = self.dlg_user_manage.date_event_to.date()

        if visit_start > visit_end:
            message = "Selected date interval is not valid"
            self.controller.show_warning(message)
            return

        # Create interval dates
        format_low = self.lot_date_format + ' 00:00:00.000'
        format_high = self.lot_date_format + ' 23:59:59.999'
        interval = f"'{visit_start.toString(format_low)}'::timestamp AND '{visit_end.toString(format_high)}'::timestamp"

        expr_filter = (f"(starttime BETWEEN {interval} OR starttime IS NULL) "
                       f"AND (endtime BETWEEN {interval} OR endtime IS NULL)")

        expr_filter += f" AND user_id LIKE '%{filter}%'"

        self.dlg_user_manage.tbl_user.model().setFilter(expr_filter)
        self.dlg_user_manage.tbl_user.model().select()


    def lot_selector(self):

        self.dlg_lot_sel = Multirow_selector()
        self.load_settings(self.dlg_lot_sel)

        self.dlg_lot_sel.btn_ok.clicked.connect(partial(self.close_dialog, self.dlg_lot_sel))
        self.dlg_lot_sel.rejected.connect(partial(self.close_dialog, self.dlg_lot_sel))
        self.dlg_lot_sel.rejected.connect(partial(self.save_settings, self.dlg_lot_sel))
        self.dlg_lot_sel.setWindowTitle("Selector de lots")
        utils_giswater.setWidgetText(self.dlg_lot_sel, 'lbl_filter', self.controller.tr('Filtrar per: Lot id', context_name='labels'))
        utils_giswater.setWidgetText(self.dlg_lot_sel, 'lbl_unselected', self.controller.tr('Lots disponibles:', context_name='labels'))
        utils_giswater.setWidgetText(self.dlg_lot_sel, 'lbl_selected', self.controller.tr('Lots seleccionats', context_name='labels'))

        tableleft = "om_visit_lot"
        tableright = "selector_lot"
        field_id_left = "id"
        field_id_right = "lot_id"
        hide_left = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]
        hide_right = [0, 1, 2]

        self.multi_row_selector(self.dlg_lot_sel, tableleft, tableright, field_id_left, field_id_right, name='id', hide_left=hide_left, hide_right=hide_right)
        self.dlg_lot_sel.btn_select.clicked.connect(partial(self.set_visible_lot_layers, True))
        self.dlg_lot_sel.btn_unselect.clicked.connect(partial(self.set_visible_lot_layers, True))

        # Open dialog
        self.open_dialog(self.dlg_lot_sel, maximize_button=False)


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
        csv_path, filter_ = QFileDialog.getSaveFileName(None, message, "", '*.csv')
        utils_giswater.setWidgetText(dialog, widget, csv_path)


    def export_model_to_csv(self, dialog, qtable, widget_name, columns=(''), date_format='yyyy-MM-dd'):
        """
        :param columns: tuple of columns to not export ('column1', 'column2', '...')
        """

        widget = utils_giswater.getWidget(dialog, str(widget_name))
        csv_path = utils_giswater.getWidgetText(dialog, widget)
        if str(csv_path) == 'null':
            message = "Select a valid path."
            self.controller.show_info_box(message, "Info")
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
            if os.path.exists(csv_path):
                msg = "Are you sure you want to overwrite this file?"
                answer = self.controller.ask_question(msg, "Overwrite")
                if answer:
                    self.write_to_csv(csv_path, all_rows)
            else:
                self.write_to_csv(csv_path, all_rows)
        except:
            msg = "File path doesn't exist or you dont have permission or file is opened"
            self.controller.show_warning(msg)
            pass


    def write_to_csv(self,  folder_path=None, all_rows=None):

        with open(folder_path, "w") as output:
            writer = csv.writer(output, lineterminator='\n')
            writer.writerows(all_rows)
        message = "The csv file has been successfully exported"
        self.controller.show_info(message)


    def populate_combo_filters(self, combo, table_name, fields="id, idval"):

        sql = (f"SELECT {fields} "
               f"FROM {table_name} "
               f"ORDER BY idval")
        rows = self.controller.get_rows(sql)
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
        for x in range(0, len(selected_list)):
            row = selected_list[x].row()
            _id = qtable.model().record(row).value('id')
            feature_type = qtable.model().record(row).value('feature_type')
            sql = (f"DELETE FROM om_visit_lot_x_{feature_type} "
                   f" WHERE lot_id = '{_id}'; \n "
                   f"DELETE FROM om_visit_lot "
                   f" WHERE id ='{_id}'")
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
        sql = (f"INSERT INTO selector_lot(lot_id, cur_user) "
               f" VALUES({selected_object_id}, current_user) "
               f" ON CONFLICT DO NOTHING;")
        self.controller.execute_sql(sql)
        # set previous dialog
        # if hasattr(self, 'previous_dialog'):
        self.manage_lot(selected_object_id, is_new=False, visitclass_id=visitclass_id)


    def filter_lot(self):
        """ Filter om_visit in self.dlg_lot_man.tbl_lots based on (id AND text AND between dates) """

        serie = utils_giswater.getWidgetText(self.dlg_lot_man, self.dlg_lot_man.txt_codi_ot)
        actuacio = utils_giswater.get_item_data(self.dlg_lot_man, self.dlg_lot_man.cmb_actuacio, 0)
        adreca = utils_giswater.getWidgetText(self.dlg_lot_man, self.dlg_lot_man.txt_address, False, False)
        status = utils_giswater.get_item_data(self.dlg_lot_man, self.dlg_lot_man.cmb_estat, 1, add_quote=True)
        assignat = utils_giswater.isChecked(self.dlg_lot_man, self.dlg_lot_man.chk_assignacio)

        visit_start = self.dlg_lot_man.date_event_from.date()
        visit_end = self.dlg_lot_man.date_event_to.date()

        if visit_start > visit_end:
            message = "Selected date interval is not valid"
            self.controller.show_warning(message)
            return

        # Create interval dates
        format_low = self.lot_date_format + ' 00:00:00.000'
        format_high = self.lot_date_format + ' 23:59:59.999'
        interval = f"'{visit_start.toString(format_low)}'::timestamp AND '{visit_end.toString(format_high)}'::timestamp"

        expr_filter = (f"(\"Data inici planificada\" BETWEEN {interval} OR \"Data inici planificada\" IS NULL) "
                       f"AND (\"Data final planificada\" BETWEEN {interval} OR \"Data final planificada\" IS NULL)")
        if serie != 'null':
            expr_filter += f" AND \"Serie\" ILIKE '%{serie}%'"
        if actuacio != '' and actuacio != -1:
            expr_filter += f" AND \"Tipus actuacio\" ILIKE '%{actuacio}%' "
        if adreca != '':
            expr_filter += f" AND adreca ILIKE '%{adreca}%' "
        if status != '':
            expr_filter += f" AND \"Estat\"::TEXT ILIKE '%{status}%'"
        if assignat:
            expr_filter += " AND \"Serie\" IS NULL "

        # Refresh model with selected filter
        self.dlg_lot_man.tbl_lots.model().setFilter(expr_filter)
        self.dlg_lot_man.tbl_lots.model().select()


    def check_for_ids(self):
        if len(self.ids) !=0:
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
        table_load = "om_vehicle_x_parameters"
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
        rows = self.controller.get_rows(sql, log_info=False)
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


    def open_load_image(self):

        selected_list = self.tbl_load.selectionModel().selectedRows(0)
        if selected_list == 0 or str(selected_list) == '[]':
            message = "Any record selected"
            self.controller.show_info_box(message)
            return

        elif len(selected_list) > 1:
            message = "More then one event selected. Select just one"
            self.controller.show_warning(message)
            return
        # Get path of selected image
        sql = ("SELECT image FROM om_vehicle_x_parameters"
               " WHERE id = '" + str(selected_list[0].data()) + "'")
        row = self.controller.get_row(sql)
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
