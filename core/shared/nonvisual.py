"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import sys

from functools import partial
from qgis.PyQt.QtCore import QRegExp
from qgis.PyQt.QtGui import QRegExpValidator
from qgis.PyQt.QtWidgets import QAbstractItemView, QPushButton, QTableView, QTableWidget, QComboBox, QTabWidget, QWidget, QTableWidgetItem
from qgis.PyQt.QtSql import QSqlTableModel
from ..models.item_delegates import ReadOnlyDelegate, EditableDelegate
from ..ui.ui_manager import GwNonVisualManagerUi, GwNonVisualControlsUi, GwNonVisualCurveUi, GwNonVisualPatternUDUi, \
    GwNonVisualPatternWSUi, GwNonVisualRulesUi, GwNonVisualTimeseriesUi
from ..utils.snap_manager import GwSnapManager
from ..utils import tools_gw
from ...lib import tools_qgis, tools_qt, tools_db, tools_os, tools_log
from ... import global_vars


class GwNonVisual:

    def __init__(self):
        """ Class to control 'Add element' of toolbar 'edit' """

        self.iface = global_vars.iface
        self.schema_name = global_vars.schema_name
        self.canvas = global_vars.canvas
        self.dialog = None
        self.manager_dlg = None


    def manage_nonvisual(self):
        """  """

        # Get dialog
        self.manager_dlg = GwNonVisualManagerUi()
        tools_gw.load_settings(self.manager_dlg)

        # Make and populate tabs
        self._manage_tabs_manager()

        # Connect dialog signals
        self.manager_dlg.btn_cancel.clicked.connect(self.manager_dlg.reject)
        self.manager_dlg.finished.connect(partial(tools_gw.close_dialog, self.manager_dlg))
        self.manager_dlg.main_tab.currentChanged.connect(
            partial(self._fill_manager_table, set_edit_triggers=QTableView.DoubleClicked))


        # Open dialog
        tools_gw.open_dialog(self.manager_dlg, dlg_name=f'dlg_nonvisual_manager')


    def _manage_tabs_manager(self):

        # ws = ['curves', 'patterns', 'controls', 'rules']
        # ud = ['curves', 'patterns', 'controls', 'timeseries', 'lids']
        views = ['v_edit_inp_curve','v_edit_inp_pattern','v_edit_inp_controls', 'v_edit_inp_rules']

        # Select all views
        # sql = f"SELECT views"
        # rows = tools_db.get_rows(sql)
        # if rows:
        # views = [x[0] for x in rows]

        module = sys.modules[__name__]

        for view in views:
            qtableview = QTableView()
            qtableview.setObjectName(f"tbl_{view}")
            tab_idx = self.manager_dlg.main_tab.addTab(qtableview, f"{view.split('_')[-1].capitalize()}")
            self.manager_dlg.main_tab.widget(tab_idx).setObjectName(view)

            function_name = f"get_{view.split('_')[-1]}"
            _id = 0
            kwargs = {'id':_id}
            qtableview.doubleClicked.connect(partial(getattr(self, function_name), **kwargs))

        self._fill_manager_table(set_edit_triggers=QTableView.DoubleClicked)


    def _fill_manager_table(self, set_edit_triggers=QTableView.DoubleClicked, expr=None):
        """  """

        table_name = f"{self.manager_dlg.main_tab.currentWidget().objectName()}"
        widget = self.manager_dlg.main_tab.currentWidget()

        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        # Set model
        model = QSqlTableModel(db=global_vars.qgis_db_credentials)
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnFieldChange)
        model.setSort(0, 0)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            tools_qgis.show_warning(model.lastError().text())
        # Attach model to table view
        if expr:
            widget.setModel(model)
            widget.model().setFilter(expr)
        else:
            widget.setModel(model)
        widget.setSortingEnabled(True)

        # Set widget & model properties
        tools_qt.set_tableview_config(widget, selection=QAbstractItemView.SelectRows, edit_triggers=set_edit_triggers, sectionResizeMode=0)
        tools_gw.set_tablemodel_config(self.manager_dlg, widget, f"{table_name[len(f'{self.schema_name}.'):]}")

        # Sort the table by feature id
        model.sort(1, 0)


    def get_nonvisual(self, object_name):
        """  """

        if object_name is None:
            return

        # Execute method get_{object_name}
        getattr(self, f'get_{object_name.lower()}')()


    def get_roughness(self):
        """  """
        pass

    # region curves
    def get_curves(self, curve_id=None):
        """  """

        # Get dialog
        self.dialog = GwNonVisualCurveUi()
        tools_gw.load_settings(self.dialog)

        # Define variables
        tbl_curve_value = self.dialog.tbl_curve_value
        cmb_expl_id = self.dialog.cmb_expl_id
        cmb_curve_type = self.dialog.cmb_curve_type

        # Populate combobox
        sql = "SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL"
        rows = tools_db.get_rows(sql)
        if rows:
            tools_qt.fill_combo_values(cmb_expl_id, rows, index_to_show=1)

        # Create & fill cmb_curve_type
        curve_type_headers, curve_type_list = self._create_curve_type_lists()
        tools_qt.fill_combo_values(cmb_curve_type, [[x, x] for x in curve_type_list])

        # Populate data if editing curve
        if curve_id:
            self._populate_curve_widgets(curve_id)

        # Connect dialog signals
        cmb_curve_type.currentIndexChanged.connect(partial(self._manage_curve_type, curve_type_headers, tbl_curve_value))
        tbl_curve_value.cellChanged.connect(partial(self._onCellChanged, tbl_curve_value))
        tbl_curve_value.cellChanged.connect(partial(self._manage_curve_value, tbl_curve_value))
        self.dialog.btn_accept.clicked.connect(partial(self._accept_curves, (curve_id is None)))
        self._connect_dialog_signals()

        # Set initial curve_value table headers
        self._manage_curve_type(curve_type_headers, tbl_curve_value, 0)
        # Set scale-to-fit
        tools_qt.set_tableview_config(tbl_curve_value, sectionResizeMode=1, edit_triggers=QTableView.DoubleClicked)

        # Open dialog
        tools_gw.open_dialog(self.dialog, dlg_name=f'dlg_nonvisual_curve')


    def _create_curve_type_lists(self):
        curve_type_list = []
        curve_type_headers = {}
        if not curve_type_list:
            if global_vars.project_type == 'ws':
                curve_type_list = ['HEADLOSS', 'VOLUME', 'PUMP', 'EFFICIENCY']
                curve_type_headers = {
                    "HEADLOSS": ['Flow', 'Headloss'], "VOLUME": ['Height', 'Volume'], "PUMP": ['Flow', 'Head'],
                    "EFFICIENCY": ['Flow', 'Efficiency']
                }
            elif global_vars.project_type == 'ud':
                curve_type_list = ['CONTROL', 'DIVERSION', 'PUMP-TYPE1', 'PUMP-TYPE2', 'PUMP-TYPE3', 'PUMP-TYPE4',
                                   'RATING', 'SHAPE', 'STORAGE', 'TIDAL', 'WEIR']
                curve_type_headers = {
                    "CONTROL": ['Value', 'Setting'], "DIVERSION": ['Inflow', 'Outflow'],
                    "PUMP-TYPE1": ['Volume', 'Flow'], "PUMP-TYPE2": ['Depth', 'Flow'], "PUMP-TYPE3": ['Head', 'Flow'],
                    "PUMP-TYPE4": ['Depth', 'Flow'], "RATING": ['Head', 'Outflow'],
                    "SHAPE": ['Depth/\nFull Depth', 'Width/\nFull Depth'],
                    "STORAGE": ['Depth', 'Area'], "TIDAL": ['Hour', 'Stage'], "WEIR": ['Head', 'Coefficient']
                }
        else:
            curve_type_list = []  # TODO: populate with parameter passed in constructor (improve modularity)
            curve_type_headers = {}  # TODO: same as list
        return curve_type_headers, curve_type_list


    def _populate_curve_widgets(self, curve_id):

        # Variables
        txt_id = self.dialog.txt_curve_id
        txt_descript = self.dialog.txt_descript
        cmb_expl_id = self.dialog.cmb_expl_id
        cmb_curve_type = self.dialog.cmb_curve_type
        txt_log = self.dialog.txt_log
        tbl_curve_value = self.dialog.tbl_curve_value

        sql = f"SELECT * FROM v_edit_inp_curve WHERE id = '{curve_id}'"
        row = tools_db.get_row(sql)
        if not row:
            return

        # Populate text & combobox widgets
        tools_qt.set_widget_text(self.dialog, txt_id, curve_id)
        tools_qt.set_widget_enabled(self.dialog, txt_id, False)
        tools_qt.set_widget_text(self.dialog, txt_descript, row['descript'])
        tools_qt.set_widget_text(self.dialog, cmb_expl_id, row['expl_id'])
        tools_qt.set_widget_text(self.dialog, cmb_curve_type, row['curve_type'])
        tools_qt.set_widget_text(self.dialog, txt_log, row['log'])

        # Populate table curve_values
        sql = f"SELECT x_value, y_value FROM v_edit_inp_curve_value WHERE curve_id = '{curve_id}'"
        rows = tools_db.get_rows(sql)
        if not rows:
            return

        for n, row in enumerate(rows):
            tbl_curve_value.setItem(n, 0, QTableWidgetItem(f"{row[0]}"))
            tbl_curve_value.setItem(n, 1, QTableWidgetItem(f"{row[1]}"))
            tbl_curve_value.insertRow(tbl_curve_value.rowCount())


    def _manage_curve_type(self, curve_type_headers, table, index):
        """  """

        curve_type = tools_qt.get_text(self.dialog, 'cmb_curve_type')
        if curve_type:
            headers = curve_type_headers.get(curve_type)
            table.setHorizontalHeaderLabels(headers)


    def _manage_curve_value(self, table, row, column):
        # Control data depending on curve type
        valid = True
        if column == 0:
            # If not first row, check if previous row has a smaller value than current row
            if row - 1 >= 0:
                cur_cell = table.item(row, column)
                prev_cell = table.item(row-1, column)
                if None not in (cur_cell, prev_cell):
                    if cur_cell.data(0) not in (None, '') and prev_cell.data(0) not in (None, ''):
                        cur_value = float(cur_cell.data(0))
                        prev_value = float(prev_cell.data(0))
                        if cur_value < prev_value:
                            valid = False

        # If first check is valid, check all rows for column for final validation
        if valid:
            # Create list with column values
            x_values = []
            y_values = []
            for n in range(0, table.rowCount()):
                x_item = table.item(n, 0)
                if x_item is not None:
                    if x_item.data(0) not in (None, ''):
                        x_values.append(float(x_item.data(0)))
                    else:
                        x_values.append(None)
                else:
                    x_values.append(None)

                y_item = table.item(n, 1)
                if y_item is not None:
                    if y_item.data(0) not in (None, ''):
                        y_values.append(float(y_item.data(0)))
                    else:
                        y_values.append(None)
                else:
                    y_values.append(None)


            # Iterate through values
            for i, n in enumerate(x_values):
                if i == 0 or n is None:
                    continue
                if n > x_values[i-1]:
                    continue
                valid = False
                break
            curve_type = tools_qt.get_text(self.dialog, 'cmb_curve_type')
            if curve_type == 'PUMP':
                for i, n in enumerate(y_values):
                    if i == 0 or n is None:
                        continue
                    if n < y_values[i - 1]:
                        continue
                    valid = False
                    break

        self._set_curve_values_valid(valid)


    def _set_curve_values_valid(self, valid):
        self.dialog.btn_accept.setEnabled(valid)


    def _accept_curves(self, is_new=True):
        # Variables
        txt_id = self.dialog.txt_curve_id
        txt_descript = self.dialog.txt_descript
        cmb_expl_id = self.dialog.cmb_expl_id
        cmb_curve_type = self.dialog.cmb_curve_type
        txt_log = self.dialog.txt_log
        tbl_curve_value = self.dialog.tbl_curve_value

        # Get widget values
        curve_id = tools_qt.get_text(self.dialog, txt_id, add_quote=True)
        curve_type = tools_qt.get_combo_value(self.dialog, cmb_curve_type)
        descript = tools_qt.get_text(self.dialog, txt_descript, add_quote=True)
        expl_id = tools_qt.get_combo_value(self.dialog, cmb_expl_id)
        log = tools_qt.get_text(self.dialog, txt_log, add_quote=True)

        if is_new:
            # Check that there are no empty fields
            if not curve_id or curve_id == 'null':
                tools_qt.set_stylesheet(txt_id)
                return
            tools_qt.set_stylesheet(txt_id, style="")

            # Insert inp_curve
            sql = f"INSERT INTO inp_curve (id, curve_type, descript, expl_id, log)" \
                  f"VALUES({curve_id}, '{curve_type}', {descript}, {expl_id}, {log})"
            result = tools_db.execute_sql(sql, commit=False)
            if not result:
                msg = "There was an error inserting curve."
                tools_qgis.show_warning(msg)
                global_vars.dao.rollback()
                return

            # Insert inp_pattern_value
            values = list()
            for y in range(0, tbl_curve_value.rowCount()):
                values.append(list())
                for x in range(0, tbl_curve_value.columnCount()):
                    value = "null"
                    item = tbl_curve_value.item(y, x)
                    if item is not None and item.data(0) not in (None, ''):
                        value = item.data(0)
                    values[y].append(value)

            is_empty = True
            for row in values:
                if row == (['null'] * tbl_curve_value.columnCount()):
                    continue
                is_empty = False

            if is_empty:
                msg = "You need at least one row of values."
                tools_qgis.show_warning(msg)
                global_vars.dao.rollback()
                return

            for row in values:
                if row == (['null'] * tbl_curve_value.columnCount()):
                    continue

                sql = f"INSERT INTO inp_curve_value (curve_id, x_value, y_value) " \
                      f"VALUES ({curve_id}, "
                for x in row:
                    sql += f"{x}, "
                sql = sql.rstrip(', ') + ")"
                result = tools_db.execute_sql(sql, commit=False)
                if not result:
                    msg = "There was an error inserting curve value."
                    tools_qgis.show_warning(msg)
                    global_vars.dao.rollback()
                    return

            # Commit and close dialog
            global_vars.dao.commit()
        tools_gw.close_dialog(self.dialog)
    # endregion

    # region patterns
    def get_patterns(self):
        """ """

        # Get dialog
        if global_vars.project_type == 'ws':
            self.dialog = GwNonVisualPatternWSUi()
        elif global_vars.project_type == 'ud':
            self.dialog = GwNonVisualPatternUDUi()
        else:
            tools_log.log_warning(f"get_patterns: project type '{global_vars.project_type}' not supported")
            return
        tools_gw.load_settings(self.dialog)

        # Manage widgets depending on the project_type
        #    calls -> def _manage_ws_patterns_dlg(self):
        #             def _manage_ud_patterns_dlg(self):
        getattr(self, f'_manage_{global_vars.project_type}_patterns_dlg')()

        # Connect dialog signals
        self._connect_dialog_signals()

        # Open dialog
        tools_gw.open_dialog(self.dialog, dlg_name=f'dlg_nonvisual_pattern_{global_vars.project_type}')


    def _manage_ws_patterns_dlg(self):
        # Variables
        tbl_pattern_value = self.dialog.tbl_pattern_value
        cmb_expl_id = self.dialog.cmb_expl_id

        # Populate combobox
        sql = "SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL"
        rows = tools_db.get_rows(sql)
        if rows:
            tools_qt.fill_combo_values(cmb_expl_id, rows, index_to_show=1)

        # Signals
        tbl_pattern_value.cellChanged.connect(partial(self._onCellChanged, tbl_pattern_value))
        # TODO: Connect signal to draw graphic?

        # Connect OK button to insert all inp_pattern and inp_pattern_value data to database
        self.dialog.btn_accept.clicked.connect(self._accept_pattern_ws)


    def _accept_pattern_ws(self):
        # Variables
        txt_id = self.dialog.txt_pattern_id
        txt_observ = self.dialog.txt_observ
        cmb_expl_id = self.dialog.cmb_expl_id
        txt_log = self.dialog.txt_log
        tbl_pattern_value = self.dialog.tbl_pattern_value

        # Get widget values
        pattern_id = tools_qt.get_text(self.dialog, txt_id, add_quote=True)
        observ = tools_qt.get_text(self.dialog, txt_observ, add_quote=True)
        expl_id = tools_qt.get_combo_value(self.dialog, cmb_expl_id)
        log = tools_qt.get_text(self.dialog, txt_log, add_quote=True)

        # Check that there are no empty fields
        if not pattern_id or pattern_id == 'null':
            tools_qt.set_stylesheet(txt_id)
            return
        tools_qt.set_stylesheet(txt_id, style="")

        # Insert inp_pattern
        sql = f"INSERT INTO inp_pattern (pattern_id, observ, expl_id, log)" \
              f"VALUES({pattern_id}, {observ}, {expl_id}, {log})"
        result = tools_db.execute_sql(sql, commit=False)
        if not result:
            msg = "There was an error inserting pattern."
            tools_qgis.show_warning(msg)
            global_vars.dao.rollback()
            return

        # Insert inp_pattern_value
        values = list()
        for y in range(0, tbl_pattern_value.rowCount()):
            values.append(list())
            for x in range(0, tbl_pattern_value.columnCount()):
                value = "null"
                item = tbl_pattern_value.item(y, x)
                if item is not None and item.data(0) not in (None, ''):
                    value = item.data(0)
                values[y].append(value)

        is_empty = True
        for row in values:
            if row == (['null'] * tbl_pattern_value.columnCount()):
                continue
            is_empty = False

        if is_empty:
            msg = "You need at least one row of values."
            tools_qgis.show_warning(msg)
            global_vars.dao.rollback()
            return

        for row in values:
            if row == (['null'] * tbl_pattern_value.columnCount()):
                continue

            sql = f"INSERT INTO inp_pattern_value (pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12) " \
                  f"VALUES ({pattern_id}, "
            for x in row:
                sql += f"{x}, "
            sql = sql.rstrip(', ') + ")"
            result = tools_db.execute_sql(sql, commit=False)
            if not result:
                msg = "There was an error inserting pattern value."
                tools_qgis.show_warning(msg)
                global_vars.dao.rollback()
                return

        # Commit and close dialog
        global_vars.dao.commit()
        tools_gw.close_dialog(self.dialog)


    def _manage_ud_patterns_dlg(self):
        # Variables
        cmb_pattern_type = self.dialog.cmb_pattern_type
        cmb_expl_id = self.dialog.cmb_expl_id

        # Populate combobox
        sql = "SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL"
        rows = tools_db.get_rows(sql)
        if rows:
            tools_qt.fill_combo_values(cmb_expl_id, rows, index_to_show=1)

        sql = "SELECT id, idval FROM inp_typevalue WHERE typevalue = 'inp_typevalue_pattern'"
        rows = tools_db.get_rows(sql)
        if rows:
            tools_qt.fill_combo_values(cmb_pattern_type, rows)

        # Signals
        cmb_pattern_type.currentIndexChanged.connect(partial(self._manage_patterns_tableviews, cmb_pattern_type))

        self._manage_patterns_tableviews(cmb_pattern_type)

        # Connect OK button to insert all inp_pattern and inp_pattern_value data to database
        self.dialog.btn_accept.clicked.connect(self._accept_pattern_ud)


    def _manage_patterns_tableviews(self, cmb_pattern_type):

        # Variables
        tbl_monthly = self.dialog.tbl_monthly
        tbl_daily = self.dialog.tbl_daily
        tbl_hourly = self.dialog.tbl_hourly
        tbl_weekend = self.dialog.tbl_weekend

        # Hide all tables
        tbl_monthly.setVisible(False)
        tbl_daily.setVisible(False)
        tbl_hourly.setVisible(False)
        tbl_weekend.setVisible(False)

        # Only show the pattern_type one
        pattern_type = tools_qt.get_combo_value(self.dialog, cmb_pattern_type)
        self.dialog.findChild(QTableWidget, f"tbl_{pattern_type.lower()}").setVisible(True)


    def _accept_pattern_ud(self):

        # Variables
        txt_id = self.dialog.txt_pattern_id
        txt_observ = self.dialog.txt_observ
        cmb_expl_id = self.dialog.cmb_expl_id
        cmb_pattern_type = self.dialog.cmb_pattern_type
        txt_log = self.dialog.txt_log

        # Get widget values
        pattern_id = tools_qt.get_text(self.dialog, txt_id, add_quote=True)
        pattern_type = tools_qt.get_combo_value(self.dialog, cmb_pattern_type)
        observ = tools_qt.get_text(self.dialog, txt_observ, add_quote=True)
        expl_id = tools_qt.get_combo_value(self.dialog, cmb_expl_id)
        log = tools_qt.get_text(self.dialog, txt_log, add_quote=True)

        # Check that there are no empty fields
        if not pattern_id or pattern_id == 'null':
            tools_qt.set_stylesheet(txt_id)
            return
        tools_qt.set_stylesheet(txt_id, style="")

        table = self.dialog.findChild(QTableWidget, f"tbl_{pattern_type.lower()}")

        # Insert inp_pattern
        sql = f"INSERT INTO inp_pattern (pattern_id, pattern_type, observ, expl_id, log)" \
              f"VALUES({pattern_id}, '{pattern_type}', {observ}, {expl_id}, {log})"
        result = tools_db.execute_sql(sql, commit=False)
        if not result:
            msg = "There was an error inserting pattern."
            tools_qgis.show_warning(msg)
            global_vars.dao.rollback()
            return

        # Insert inp_pattern_value
        values = list()
        for y in range(0, table.rowCount()):
            values.append(list())
            for x in range(0, table.columnCount()):
                value = "null"
                item = table.item(y, x)
                if item is not None and item.data(0) not in (None, ''):
                    value = item.data(0)
                values[y].append(value)

        is_empty = True
        for row in values:
            if row == (['null'] * table.columnCount()):
                continue
            is_empty = False

        if is_empty:
            msg = "You need at least one row of values."
            tools_qgis.show_warning(msg)
            global_vars.dao.rollback()
            return

        for row in values:
            if row == (['null'] * table.columnCount()):
                continue

            sql = f"INSERT INTO inp_pattern_value (pattern_id, "
            for n, x in enumerate(row):
                sql += f"factor_{n+1}, "
            sql = sql.rstrip(', ') + ")"
            sql += f"VALUES ({pattern_id}, "
            for x in row:
                sql += f"{x}, "
            sql = sql.rstrip(', ') + ")"
            result = tools_db.execute_sql(sql, commit=False)
            if not result:
                msg = "There was an error inserting pattern value."
                tools_qgis.show_warning(msg)
                global_vars.dao.rollback()
                return

        # Commit and close dialog
        global_vars.dao.commit()
        tools_gw.close_dialog(self.dialog)

    # endregion

    # region controls
    def get_controls(self):
        """  """

        # Get dialog
        self.dialog = GwNonVisualControlsUi()
        tools_gw.load_settings(self.dialog)

        # Populate sector id combobox
        self._populate_cmb_sector_id(self.dialog.cmb_sector_id)

        # Connect dialog signals
        self.dialog.btn_accept.clicked.connect(self._accept_controls)
        self._connect_dialog_signals()

        # Open dialog
        tools_gw.open_dialog(self.dialog, dlg_name=f'dlg_nonvisual_controls')


    def _accept_controls(self):

        # Variables
        cmb_sector_id = self.dialog.cmb_sector_id
        chk_active = self.dialog.chk_active
        txt_text = self.dialog.txt_text

        # Get widget values
        sector_id = tools_qt.get_combo_value(self.dialog, cmb_sector_id)
        active = tools_qt.is_checked(self.dialog, chk_active)
        text = tools_qt.get_text(self.dialog, txt_text, add_quote=True)

        # Check that there are no empty fields
        if not text or text == 'null':
            tools_qt.set_stylesheet(txt_text)
            return
        tools_qt.set_stylesheet(txt_text, style="")

        # Insert inp_controls
        sql = f"INSERT INTO inp_controls (sector_id,text,active)" \
              f"VALUES({sector_id}, {text}, {active})"
        result = tools_db.execute_sql(sql, commit=False)
        if not result:
            msg = "There was an error inserting control."
            tools_qgis.show_warning(msg)
            global_vars.dao.rollback()
            return

        # Commit and close dialog
        global_vars.dao.commit()
        tools_gw.close_dialog(self.dialog)

    # endregion

    # region rules
    def get_rules(self):
        """  """

        # Get dialog
        self.dialog = GwNonVisualRulesUi()
        tools_gw.load_settings(self.dialog)

        # Populate sector id combobox
        self._populate_cmb_sector_id(self.dialog.cmb_sector_id)

        # Connect dialog signals
        self.dialog.btn_accept.clicked.connect(self._accept_rules)
        self._connect_dialog_signals()

        # Open dialog
        tools_gw.open_dialog(self.dialog, dlg_name=f'dlg_nonvisual_rules')


    def _accept_rules(self):

        # Variables
        cmb_sector_id = self.dialog.cmb_sector_id
        chk_active = self.dialog.chk_active
        txt_text = self.dialog.txt_text

        # Get widget values
        sector_id = tools_qt.get_combo_value(self.dialog, cmb_sector_id)
        active = tools_qt.is_checked(self.dialog, chk_active)
        text = tools_qt.get_text(self.dialog, txt_text, add_quote=True)

        # Check that there are no empty fields
        if not text or text == 'null':
            tools_qt.set_stylesheet(txt_text)
            return
        tools_qt.set_stylesheet(txt_text, style="")

        # Insert inp_controls
        sql = f"INSERT INTO inp_rules (sector_id,text,active)" \
              f"VALUES({sector_id}, {text}, {active})"
        result = tools_db.execute_sql(sql, commit=False)
        if not result:
            msg = "There was an error inserting control."
            tools_qgis.show_warning(msg)
            global_vars.dao.rollback()
            return

        # Commit and close dialog
        global_vars.dao.commit()
        tools_gw.close_dialog(self.dialog)

    # endregion

    # region timeseries
    def get_timeseries(self):
        """  """

        # Get dialog
        self.dialog = GwNonVisualTimeseriesUi()
        tools_gw.load_settings(self.dialog)

        # Variables
        cmb_timeser_type = self.dialog.cmb_timeser_type
        cmb_times_type = self.dialog.cmb_times_type
        cmb_expl_id = self.dialog.cmb_expl_id
        tbl_timeseries_value = self.dialog.tbl_timeseries_value

        # Populate combobox
        sql = "SELECT id, idval FROM inp_typevalue WHERE typevalue = 'inp_value_timserid'"
        rows = tools_db.get_rows(sql)
        if rows:
            tools_qt.fill_combo_values(cmb_timeser_type, rows, index_to_show=1)

        sql = "SELECT id, idval FROM inp_typevalue WHERE typevalue = 'inp_typevalue_timeseries'"
        rows = tools_db.get_rows(sql)
        if rows:
            tools_qt.fill_combo_values(cmb_times_type, rows, index_to_show=1)

        sql = "SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL"
        rows = tools_db.get_rows(sql)
        if rows:
            tools_qt.fill_combo_values(cmb_expl_id, rows, index_to_show=1)

        # Set scale-to-fit
        tools_qt.set_tableview_config(tbl_timeseries_value, sectionResizeMode=1, edit_triggers=QTableView.DoubleClicked)

        # Connect dialog signals
        tbl_timeseries_value.cellChanged.connect(partial(self._onCellChanged, tbl_timeseries_value))
        self.dialog.btn_accept.clicked.connect(self._accept_timeseries)
        self._connect_dialog_signals()

        # Open dialog
        tools_gw.open_dialog(self.dialog, dlg_name=f'dlg_nonvisual_timeseries')


    def _accept_timeseries(self):

        # Variables
        txt_id = self.dialog.txt_id
        txt_idval = self.dialog.txt_idval
        cmb_timeser_type = self.dialog.cmb_timeser_type
        cmb_times_type = self.dialog.cmb_times_type
        txt_descript = self.dialog.txt_descript
        cmb_expl_id = self.dialog.cmb_expl_id
        txt_fname = self.dialog.txt_fname
        txt_log = self.dialog.txt_log
        tbl_timeseries_value = self.dialog.tbl_timeseries_value

        # Get widget values
        timeseries_id = tools_qt.get_text(self.dialog, txt_id, add_quote=True)
        idval = tools_qt.get_text(self.dialog, txt_idval, add_quote=True)
        timeser_type = tools_qt.get_combo_value(self.dialog, cmb_timeser_type)
        times_type = tools_qt.get_combo_value(self.dialog, cmb_times_type)
        descript = tools_qt.get_text(self.dialog, txt_descript, add_quote=True)
        fname = tools_qt.get_text(self.dialog, txt_fname, add_quote=True)
        expl_id = tools_qt.get_combo_value(self.dialog, cmb_expl_id)
        log = tools_qt.get_text(self.dialog, txt_log, add_quote=True)

        # Check that there are no empty fields
        if not timeseries_id or timeseries_id == 'null':
            tools_qt.set_stylesheet(txt_id)
            return
        tools_qt.set_stylesheet(txt_id, style="")

        # Insert inp_timeseries
        sql = f"INSERT INTO inp_timeseries (id, timser_type, times_type, idval, descript, fname, expl_id, log)" \
              f"VALUES({timeseries_id}, '{timeser_type}', '{times_type}', {idval}, {descript}, {fname}, '{expl_id}', {log})"
        result = tools_db.execute_sql(sql, commit=False)
        if not result:
            msg = "There was an error inserting timeseries."
            tools_qgis.show_warning(msg)
            global_vars.dao.rollback()
            return

        if fname not in (None, 'null'):
            sql = ""  # No need to insert to inp_timeseries_value?

        # Insert inp_timeseries_value
        values = list()
        for y in range(0, tbl_timeseries_value.rowCount()):
            values.append(list())
            for x in range(0, tbl_timeseries_value.columnCount()):
                value = "null"
                item = tbl_timeseries_value.item(y, x)
                if item is not None and item.data(0) not in (None, ''):
                    value = item.data(0)
                    try:  # Try to convert to float, otherwise put quotes
                        value = float(value)
                    except ValueError:
                        value = f"'{value}'"
                values[y].append(value)

        # Check if table is empty
        is_empty = True
        for row in values:
            if row == (['null'] * tbl_timeseries_value.columnCount()):
                continue
            is_empty = False

        if is_empty:
            msg = "You need at least one row of values."
            tools_qgis.show_warning(msg)
            global_vars.dao.rollback()
            return

        if times_type == 'ABSOLUTE':
            for row in values:
                if row == (['null'] * tbl_timeseries_value.columnCount()):
                    continue
                if 'null' in (row[0], row[1], row[2]):
                    msg = "You have to fill in 'date', 'time' and 'value' fields!"
                    tools_qgis.show_warning(msg)
                    global_vars.dao.rollback()
                    return

                sql = f"INSERT INTO inp_timeseries_value (timser_id, date, hour, value) "
                sql += f"VALUES ({timeseries_id}, {row[0]}, {row[1]}, {row[2]})"

                result = tools_db.execute_sql(sql, commit=False)
                if not result:
                    msg = "There was an error inserting pattern value."
                    tools_qgis.show_warning(msg)
                    global_vars.dao.rollback()
                    return
        elif times_type == 'RELATIVE':

            for row in values:
                if row == (['null'] * tbl_timeseries_value.columnCount()):
                    continue
                if 'null' in (row[1], row[2]):
                    msg = "You have to fill in 'time' and 'value' fields!"
                    tools_qgis.show_warning(msg)
                    global_vars.dao.rollback()
                    return

                sql = f"INSERT INTO inp_timeseries_value (timser_id, time, value) "
                sql += f"VALUES ({timeseries_id}, {row[1]}, {row[2]})"

                result = tools_db.execute_sql(sql, commit=False)
                if not result:
                    msg = "There was an error inserting pattern value."
                    tools_qgis.show_warning(msg)
                    global_vars.dao.rollback()
                    return

        # Commit and close dialog
        global_vars.dao.commit()
        tools_gw.close_dialog(self.dialog)

    # endregion

    # region private functions
    def _connect_dialog_signals(self):

        # self.dialog.btn_accept.clicked.connect(self.dialog.accept)
        self.dialog.btn_cancel.clicked.connect(self.dialog.reject)
        self.dialog.rejected.connect(partial(tools_gw.close_dialog, self.dialog))


    def _onCellChanged(self, table, row, column):
        """ Note: row & column parameters are passed by the signal """

        # Add a new row if the edited row is the last one
        if row >= (table.rowCount()-1):
            headers = ['Multiplier' for n in range(0, table.rowCount()+1)]
            table.insertRow(table.rowCount())
            table.setVerticalHeaderLabels(headers)
        # Remove "last" row (empty one) if the real last row is empty
        elif row == (table.rowCount()-2):
            for n in range(0, table.columnCount()):
                item = table.item(row, n)
                if item is not None:
                    if item.data(0) not in (None, ''):
                        return
            table.setRowCount(table.rowCount()-1)


    def _populate_cmb_sector_id(self, combobox):
        sql = f"SELECT sector_id as id, name as idval FROM v_edit_sector WHERE sector_id > 0"
        rows = tools_db.get_rows(sql)
        if rows:
            tools_qt.fill_combo_values(combobox, rows, index_to_show=1)

    # endregion
