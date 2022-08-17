"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
from functools import partial

try:
    from scipy.interpolate import CubicSpline
    import numpy as np
    scipy_imported = True
except ImportError:
    scipy_imported = False

from qgis.PyQt.QtWidgets import QAbstractItemView, QTableView, QTableWidget, QTableWidgetItem, QSizePolicy, QLineEdit, QGridLayout, QComboBox, QWidget
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.core import Qgis
from ..ui.ui_manager import GwNonVisualManagerUi, GwNonVisualControlsUi, GwNonVisualCurveUi, GwNonVisualPatternUDUi, \
    GwNonVisualPatternWSUi, GwNonVisualRulesUi, GwNonVisualTimeseriesUi, GwNonVisualLidsUi
from ..utils.matplotlib_widget import MplCanvas
from ..utils import tools_gw
from ...lib import tools_qgis, tools_qt, tools_db, tools_os, tools_log
from ... import global_vars


class GwNonVisual:

    def __init__(self):
        """ Class to control 'Add element' of toolbar 'edit' """

        self.plugin_dir = global_vars.plugin_dir
        self.iface = global_vars.iface
        self.schema_name = global_vars.schema_name
        self.canvas = global_vars.canvas
        self.dialog = None
        self.manager_dlg = None
        self.dict_views = {'ws': {'v_edit_inp_curve': 'curves', 'v_edit_inp_pattern': 'patterns',
                                  'v_edit_inp_controls': 'controls', 'v_edit_inp_rules': 'rules'},
                           'ud': {'v_edit_inp_curve': 'curves', 'v_edit_inp_pattern': 'patterns',
                                  'v_edit_inp_timeseries': 'timeseries', 'v_edit_inp_controls': 'controls',
                                  'inp_lid': 'lids'}}
        self.dict_ids = {'v_edit_inp_curve': 'id', 'v_edit_inp_curve_value': 'curve_id',
                         'v_edit_inp_pattern': 'pattern_id', 'v_edit_inp_pattern_value': 'pattern_id',
                         'v_edit_inp_controls': 'id',
                         'v_edit_inp_rules': 'id',
                         'v_edit_inp_timeseries': 'id', 'v_edit_inp_timeseries_value': 'timser_id',
                         'inp_lid': 'lidco_id', 'inp_lid_value': 'lidco_id',
                         }
        self.valid = (True, "")


    def get_nonvisual(self, object_name):
        """ Opens Non-Visual object dialog. Called from 'New Non-Visual object' button. """

        if object_name is None:
            return

        # Execute method get_{object_name}
        getattr(self, f'get_{object_name.lower()}')()

    # region manager
    def manage_nonvisual(self):
        """ Opens Non-Visual objects manager. Called from 'Non-Visual object manager' button. """

        # Get dialog
        self.manager_dlg = GwNonVisualManagerUi()
        tools_gw.load_settings(self.manager_dlg)

        # Make and populate tabs
        self._manage_tabs_manager()

        # Connect dialog signals
        self.manager_dlg.txt_filter.textChanged.connect(partial(self._filter_table, self.manager_dlg))
        self.manager_dlg.main_tab.currentChanged.connect(partial(self._filter_table, self.manager_dlg, None))
        self.manager_dlg.btn_duplicate.clicked.connect(partial(self._duplicate_object, self.manager_dlg))
        self.manager_dlg.btn_create.clicked.connect(partial(self._create_object, self.manager_dlg))
        self.manager_dlg.btn_delete.clicked.connect(partial(self._delete_object, self.manager_dlg))
        self.manager_dlg.btn_cancel.clicked.connect(self.manager_dlg.reject)
        self.manager_dlg.finished.connect(partial(tools_gw.close_dialog, self.manager_dlg))

        # Open dialog
        tools_gw.open_dialog(self.manager_dlg, dlg_name=f'dlg_nonvisual_manager')


    def _manage_tabs_manager(self):
        """ Creates and populates manager tabs """

        dict_views_project = self.dict_views[global_vars.project_type]

        for key in dict_views_project.keys():
            qtableview = QTableView()
            qtableview.setObjectName(f"tbl_{dict_views_project[key]}")
            tab_idx = self.manager_dlg.main_tab.addTab(qtableview, f"{dict_views_project[key].capitalize()}")
            self.manager_dlg.main_tab.widget(tab_idx).setObjectName(key)
            self.manager_dlg.main_tab.widget(tab_idx).setProperty('function', f"get_{dict_views_project[key]}")
            function_name = f"get_{dict_views_project[key]}"
            _id = 0

            self._fill_manager_table(qtableview, key)

            qtableview.doubleClicked.connect(partial(self._get_nonvisual_object, qtableview, function_name))


    def _get_nonvisual_object(self, tbl_view, function_name):
        """ Opens Non-Visual object dialog. Called from manager tables. """

        object_id = tbl_view.selectionModel().selectedRows()[0].data()
        if hasattr(self, function_name):
            getattr(self, function_name)(object_id)


    def _fill_manager_table(self, widget, table_name, set_edit_triggers=QTableView.NoEditTriggers, expr=None):
        """ Fills manager table """

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
            tools_qgis.show_warning(model.lastError().text(), dialog=self.manager_dlg)
        # Attach model to table view
        if expr:
            widget.setModel(model)
            widget.model().setFilter(expr)
        else:
            widget.setModel(model)
        widget.setSortingEnabled(True)

        # Set widget & model properties
        tools_qt.set_tableview_config(widget, selection=QAbstractItemView.SelectRows, edit_triggers=set_edit_triggers,
                                      sectionResizeMode=0, stretchLastSection=False)
        tools_gw.set_tablemodel_config(self.manager_dlg, widget, f"{table_name[len(f'{self.schema_name}.'):]}")

        # Sort the table by feature id
        model.sort(1, 0)


    def _filter_table(self, dialog, text):
        """ Filters manager table by id """

        widget_table = dialog.main_tab.currentWidget()
        tablename = widget_table.objectName()
        id_field = self.dict_ids.get(tablename)

        if text is None:
            text = tools_qt.get_text(dialog, dialog.txt_filter, return_string_null=False)

        expr = f"{id_field}::text ILIKE '%{text}%'"
        # Refresh model with selected filter
        widget_table.model().setFilter(expr)
        widget_table.model().select()


    def _create_object(self, dialog):
        """ Creates a new non-visual object from the manager """

        table = dialog.main_tab.currentWidget()
        function_name = table.property('function')

        getattr(self, function_name)()


    def _duplicate_object(self, dialog):
        """ Duplicates the selected object """

        # Variables
        table = dialog.main_tab.currentWidget()
        function_name = table.property('function')

        # Get selected row
        selected_list = table.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=dialog)
            return

        # Get selected workspace id
        index = table.selectionModel().currentIndex()
        value = index.sibling(index.row(), 0).data()

        try:
            value = int(value)
        except ValueError:
            pass

        # Open dialog with values but no id
        getattr(self, function_name)(value, duplicate=True)


    def _delete_object(self, dialog):
        """ Deletes selected object and its values """

        # Variables
        table = dialog.main_tab.currentWidget()
        tablename = table.objectName()
        tablename_value = f"{tablename}_value"

        # Get selected row
        selected_list = table.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=dialog)
            return

        # Get selected workspace id
        index = table.selectionModel().currentIndex()
        value = index.sibling(index.row(), 0).data()

        message = "Are you sure you want to delete these records?"
        answer = tools_qt.show_question(message, "Delete records", index.sibling(index.row(), 0).data())
        if answer:
            # Add quotes to id if not inp_controls/inp_rules
            if tablename not in ('inp_controls', 'inp_rules'):
                value = f"'{value}'"

            # Delete values
            id_field = self.dict_ids.get(tablename_value)
            if id_field is not None:
                sql = f"DELETE FROM {tablename_value} WHERE {id_field} = {value}"
                result = tools_db.execute_sql(sql, commit=False)
                if not result:
                    msg = "There was an error deleting object values."
                    tools_qgis.show_warning(msg, dialog=dialog)
                    global_vars.dao.rollback()
                    return

            # Delete object from main table
            id_field = self.dict_ids.get(tablename)
            sql = f"DELETE FROM {tablename} WHERE {id_field} = {value}"
            result = tools_db.execute_sql(sql, commit=False)
            if not result:
                msg = "There was an error deleting object."
                tools_qgis.show_warning(msg, dialog=dialog)
                global_vars.dao.rollback()
                return

            # Commit & refresh table
            global_vars.dao.commit()
            self._reload_manager_table()

    # endregion

    # region curves
    def get_curves(self, curve_id=None, duplicate=False):
        """ Opens dialog for curve """

        # Get dialog
        self.dialog = GwNonVisualCurveUi()
        tools_gw.load_settings(self.dialog)

        # Create plot widget
        plot_widget = self._create_plot_widget(self.dialog)

        # Define variables
        tbl_curve_value = self.dialog.tbl_curve_value
        cmb_expl_id = self.dialog.cmb_expl_id
        cmb_curve_type = self.dialog.cmb_curve_type

        # Populate combobox
        sql = "SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id > 0"
        rows = tools_db.get_rows(sql)
        if rows:
            tools_qt.fill_combo_values(cmb_expl_id, rows, index_to_show=1, add_empty=True)

        # Create & fill cmb_curve_type
        curve_type_headers, curve_type_list = self._create_curve_type_lists()
        tools_qt.fill_combo_values(cmb_curve_type, curve_type_list)

        # Populate data if editing curve
        if curve_id:
            self._populate_curve_widgets(curve_id, duplicate=duplicate)
        else:
            self._load_curve_widgets(self.dialog)

        # Treat as new object if curve_id is None or if we're duplicating
        is_new = (curve_id is None) or duplicate

        # Connect dialog signals
        cmb_curve_type.currentIndexChanged.connect(partial(self._manage_curve_type, self.dialog, curve_type_headers, tbl_curve_value))
        tbl_curve_value.cellChanged.connect(partial(self._onCellChanged, tbl_curve_value))
        tbl_curve_value.cellChanged.connect(partial(self._manage_curve_value, self.dialog, tbl_curve_value))
        tbl_curve_value.cellChanged.connect(partial(self._manage_curve_plot, self.dialog, tbl_curve_value, plot_widget))
        self.dialog.btn_accept.clicked.connect(partial(self._accept_curves, self.dialog, is_new, curve_id))
        self._connect_dialog_signals()

        # Set initial curve_value table headers
        self._manage_curve_type(self.dialog, curve_type_headers, tbl_curve_value, 0)
        self._manage_curve_plot(self.dialog, tbl_curve_value, plot_widget, None, None)
        # Set scale-to-fit
        tools_qt.set_tableview_config(tbl_curve_value, sectionResizeMode=1, edit_triggers=QTableView.DoubleClicked)

        # Open dialog
        tools_gw.open_dialog(self.dialog, dlg_name=f'dlg_nonvisual_curve')


    def _create_curve_type_lists(self):
        """ Creates a list & dict to manage curve_values table headers """

        curve_type_list = []
        curve_type_headers = {}
        sql = f"SELECT id, idval, addparam FROM inp_typevalue WHERE typevalue = 'inp_value_curve'"
        rows = tools_db.get_rows(sql)
        if rows:
            curve_type_list = [[row['id'], row['idval']] for row in rows]
            curve_type_headers = {row['id']: row['addparam'].get('header') for row in rows}

        return curve_type_headers, curve_type_list


    def _populate_curve_widgets(self, curve_id, duplicate=False):
        """ Fills in all the values for curve dialog """

        # Variables
        txt_id = self.dialog.txt_curve_id
        txt_descript = self.dialog.txt_descript
        cmb_expl_id = self.dialog.cmb_expl_id
        cmb_curve_type = self.dialog.cmb_curve_type
        tbl_curve_value = self.dialog.tbl_curve_value

        sql = f"SELECT * FROM v_edit_inp_curve WHERE id = '{curve_id}'"
        row = tools_db.get_row(sql)
        if not row:
            return

        # Populate text & combobox widgets
        if not duplicate:
            tools_qt.set_widget_text(self.dialog, txt_id, curve_id)
            tools_qt.set_widget_enabled(self.dialog, txt_id, False)
        tools_qt.set_widget_text(self.dialog, txt_descript, row['descript'])
        tools_qt.set_combo_value(cmb_expl_id, str(row['expl_id']), 0)
        tools_qt.set_widget_text(self.dialog, cmb_curve_type, row['curve_type'])

        # Populate table curve_values
        sql = f"SELECT x_value, y_value FROM v_edit_inp_curve_value WHERE curve_id = '{curve_id}'"
        rows = tools_db.get_rows(sql)
        if not rows:
            return

        for n, row in enumerate(rows):
            tbl_curve_value.setItem(n, 0, QTableWidgetItem(f"{row[0]}"))
            tbl_curve_value.setItem(n, 1, QTableWidgetItem(f"{row[1]}"))
            tbl_curve_value.insertRow(tbl_curve_value.rowCount())


    def _load_curve_widgets(self, dialog):
        """ Load values from session.config """

        # Variables
        cmb_expl_id = dialog.cmb_expl_id
        cmb_curve_type = dialog.cmb_curve_type

        # Get values
        expl_id = tools_gw.get_config_parser('nonvisual_curves', 'cmb_expl_id', "user", "session")
        curve_type = tools_gw.get_config_parser('nonvisual_curves', 'cmb_curve_type', "user", "session")

        # Populate widgets
        tools_qt.set_combo_value(cmb_expl_id, str(expl_id), 0)
        tools_qt.set_widget_text(dialog, cmb_curve_type, curve_type)


    def _save_curve_widgets(self, dialog):
        """ Save values from session.config """

        # Variables
        cmb_expl_id = dialog.cmb_expl_id
        cmb_curve_type = dialog.cmb_curve_type

        # Get values
        expl_id = tools_qt.get_combo_value(dialog, cmb_expl_id)
        curve_type = tools_qt.get_combo_value(dialog, cmb_curve_type)

        # Populate widgets
        tools_gw.set_config_parser('nonvisual_curves', 'cmb_expl_id', expl_id)
        tools_gw.set_config_parser('nonvisual_curves', 'cmb_curve_type', curve_type)


    def _manage_curve_type(self, dialog, curve_type_headers, table, index):
        """ Manage curve values table headers """

        curve_type = tools_qt.get_text(dialog, 'cmb_curve_type')
        if curve_type:
            headers = curve_type_headers.get(curve_type)
            table.setHorizontalHeaderLabels(headers)


    def _manage_curve_value(self, dialog, table, row, column):
        """ Validate data in curve values table """

        # Control data depending on curve type
        valid = True
        self.valid = (True, "")
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
                            self.valid = (False, "Invalid curve. First column values must be ascending.")

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
            # Check that x_values are ascending
            for i, n in enumerate(x_values):
                if i == 0 or n is None:
                    continue
                if n > x_values[i-1]:
                    continue
                valid = False
                self.valid = (False, "Invalid curve. First column values must be ascending.")
                break
            # If PUMP, check that y_values are descending
            curve_type = tools_qt.get_text(dialog, 'cmb_curve_type')
            if curve_type == 'PUMP':
                for i, n in enumerate(y_values):
                    if i == 0 or n is None:
                        continue
                    if n < y_values[i - 1]:
                        continue
                    valid = False
                    self.valid = (False, "Invalid curve. Second column values must be descending.")
                    break

            if valid:
                # Check that all values are in pairs
                x_len = len([x for x in x_values if x is not None])  # Length of the x_values list without Nones
                y_len = len([y for y in y_values if y is not None])  # Length of the y_values list without Nones
                valid = x_len == y_len
                self.valid = (valid, "Invalid curve. Values must go in pairs.")


    def _manage_curve_plot(self, dialog, table, plot_widget, row, column):
        """ Note: row & column parameters are passed by the signal """

        # Clear plot
        plot_widget.axes.cla()

        # Read row values
        values = self._read_tbl_values(table)
        temp_list = []  # String list with all table values
        for v in values:
            temp_list.append(v)

        # Clean nulls of the end of the list
        clean_list = []
        for i, item in enumerate(temp_list):
            last_idx = -1
            for j, value in enumerate(item):
                if value != 'null':
                    last_idx = j
            clean_list.append(item[:last_idx+1])

        # Convert list items to float
        float_list = []
        for lst in clean_list:
            temp_lst = []
            if len(lst) < 2:
                continue
            for item in lst:
                try:
                    value = float(item)
                except ValueError:
                    value = 0
                temp_lst.append(value)
            float_list.append(temp_lst)

        # Create x & y coordinate points to draw line
        # float_list = [[x1, y1], [x2, y2], [x3, y3]]
        x_list = [x[0] for x in float_list]  # x_list = [x1, x2, x3]
        y_list = [x[1] for x in float_list]  # y_list = [y1, y2, y3]

        # Create curve if only one value with curve_type 'PUMP'
        curve_type = tools_qt.get_combo_value(dialog, dialog.cmb_curve_type)
        if scipy_imported and len(x_list) == 1 and curve_type == 'PUMP':
            # Draw curve with points (0, 1.33y), (x, y), (2x, 0)
            x = x_list[0]
            y = y_list[0]
            x_array = np.array([0, x, 2*x])
            y_array = np.array([1.33*y, y, 0])

            # Define x_array as 100 equally spaced values between the min and max of original x_array
            xnew = np.linspace(x_array.min(), x_array.max(), 100)

            # Define spline
            spl = CubicSpline(x_array, y_array)
            y_smooth = spl(xnew)

            x_list = xnew
            y_list = y_smooth

        # Create and draw plot
        plot_widget.axes.plot(x_list, y_list, color='indianred')
        plot_widget.draw()


    def _accept_curves(self, dialog, is_new, curve_id):
        """ Manage accept button (insert & update) """

        # Variables
        txt_id = dialog.txt_curve_id
        txt_descript = dialog.txt_descript
        cmb_expl_id = dialog.cmb_expl_id
        cmb_curve_type = dialog.cmb_curve_type
        tbl_curve_value = dialog.tbl_curve_value

        # Get widget values
        curve_id = tools_qt.get_text(dialog, txt_id, add_quote=True)
        curve_type = tools_qt.get_combo_value(dialog, cmb_curve_type)
        descript = tools_qt.get_text(dialog, txt_descript, add_quote=True)
        expl_id = tools_qt.get_combo_value(dialog, cmb_expl_id)
        if expl_id in (None, ''):
            expl_id = "null"

        valid, msg = self.valid
        if not valid:
            tools_qgis.show_warning(msg, dialog=dialog)
            return

        if is_new:
            # Check that there are no empty fields
            if not curve_id or curve_id == 'null':
                tools_qt.set_stylesheet(txt_id)
                return
            tools_qt.set_stylesheet(txt_id, style="")

            # Insert inp_curve
            sql = f"INSERT INTO inp_curve (id, curve_type, descript, expl_id)" \
                  f"VALUES({curve_id}, '{curve_type}', {descript}, {expl_id})"
            result = tools_db.execute_sql(sql, commit=False)
            if not result:
                msg = "There was an error inserting curve."
                tools_qgis.show_warning(msg, dialog=dialog)
                global_vars.dao.rollback()
                return

            # Insert inp_curve_value
            result = self._insert_curve_values(dialog, tbl_curve_value, curve_id)
            if not result:
                return

            # Commit
            global_vars.dao.commit()
            # Reload manager table
            self._reload_manager_table()
        elif curve_id is not None:
            # Update curve fields
            table_name = 'v_edit_inp_curve'

            curve_type = curve_type.strip("'")
            descript = descript.strip("'")
            fields = f"""{{"curve_type": "{curve_type}", "descript": "{descript}", "expl_id": {expl_id}}}"""

            result = self._setfields(curve_id.strip("'"), table_name, fields)
            if not result:
                return

            # Delete existing curve values
            sql = f"DELETE FROM v_edit_inp_curve_value WHERE curve_id = {curve_id}"
            result = tools_db.execute_sql(sql, commit=False)
            if not result:
                msg = "There was an error deleting old curve values."
                tools_qgis.show_warning(msg, dialog=dialog)
                global_vars.dao.rollback()
                return

            # Insert new curve values
            result = self._insert_curve_values(dialog, tbl_curve_value, curve_id)
            if not result:
                return

            # Commit
            global_vars.dao.commit()
            # Reload manager table
            self._reload_manager_table()

        self._save_curve_widgets(dialog)
        tools_gw.close_dialog(dialog)


    def _insert_curve_values(self, dialog, tbl_curve_value, curve_id):
        """ Insert table values into v_edit_inp_curve_values """

        values = self._read_tbl_values(tbl_curve_value)

        is_empty = True
        for row in values:
            if row == (['null'] * tbl_curve_value.columnCount()):
                continue
            is_empty = False

        if is_empty:
            msg = "You need at least one row of values."
            tools_qgis.show_warning(msg, dialog=dialog)
            global_vars.dao.rollback()
            return False

        for row in values:
            if row == (['null'] * tbl_curve_value.columnCount()):
                continue

            sql = f"INSERT INTO v_edit_inp_curve_value (curve_id, x_value, y_value) " \
                  f"VALUES ({curve_id}, "
            for x in row:
                sql += f"{x}, "
            sql = sql.rstrip(', ') + ")"
            result = tools_db.execute_sql(sql, commit=False)
            if not result:
                msg = "There was an error inserting curve value."
                tools_qgis.show_warning(msg, dialog=dialog)
                global_vars.dao.rollback()
                return False
        return True
    # endregion

    # region patterns
    def get_patterns(self, pattern_id=None, duplicate=False):
        """ Opens dialog for patterns """

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
        getattr(self, f'_manage_{global_vars.project_type}_patterns_dlg')(pattern_id, duplicate=duplicate)

        # Connect dialog signals
        self._connect_dialog_signals()

        # Open dialog
        tools_gw.open_dialog(self.dialog, dlg_name=f'dlg_nonvisual_pattern_{global_vars.project_type}')


    def _manage_ws_patterns_dlg(self, pattern_id, duplicate=False):
        # Variables
        tbl_pattern_value = self.dialog.tbl_pattern_value
        cmb_expl_id = self.dialog.cmb_expl_id

        # Set scale-to-fit for tableview
        tbl_pattern_value.horizontalHeader().setSectionResizeMode(1)
        tbl_pattern_value.horizontalHeader().setMinimumSectionSize(50)

        # Create plot widget
        plot_widget = self._create_plot_widget(self.dialog)

        # Populate combobox
        sql = "SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id > 0"
        rows = tools_db.get_rows(sql)
        if rows:
            tools_qt.fill_combo_values(cmb_expl_id, rows, index_to_show=1, add_empty=True)

        if pattern_id:
            self._populate_ws_patterns_widgets(pattern_id, duplicate=duplicate)
            self._manage_ws_patterns_plot(tbl_pattern_value, plot_widget, None, None)
        else:
            self._load_ws_pattern_widgets(self.dialog)

        # Signals
        tbl_pattern_value.cellChanged.connect(partial(self._onCellChanged, tbl_pattern_value))
        tbl_pattern_value.cellChanged.connect(partial(self._manage_ws_patterns_plot, tbl_pattern_value, plot_widget))

        # Connect OK button to insert all inp_pattern and inp_pattern_value data to database
        is_new = (pattern_id is None) or duplicate
        self.dialog.btn_accept.clicked.connect(partial(self._accept_pattern_ws, self.dialog, is_new))


    def _populate_ws_patterns_widgets(self, pattern_id, duplicate=False):
        """ Fills in all the values for ws pattern dialog """

        # Variables
        txt_id = self.dialog.txt_pattern_id
        txt_observ = self.dialog.txt_observ
        cmb_expl_id = self.dialog.cmb_expl_id
        tbl_pattern_value = self.dialog.tbl_pattern_value

        sql = f"SELECT * FROM v_edit_inp_pattern WHERE pattern_id = '{pattern_id}'"
        row = tools_db.get_row(sql)
        if not row:
            return

        # Populate text & combobox widgets
        if not duplicate:
            tools_qt.set_widget_text(self.dialog, txt_id, pattern_id)
            tools_qt.set_widget_enabled(self.dialog, txt_id, False)
        tools_qt.set_widget_text(self.dialog, txt_observ, row['observ'])
        tools_qt.set_combo_value(cmb_expl_id, str(row['expl_id']), 0)

        # Populate table pattern_values
        sql = f"SELECT factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, " \
              f"factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 " \
              f"FROM v_edit_inp_pattern_value WHERE pattern_id = '{pattern_id}'"
        rows = tools_db.get_rows(sql)
        if not rows:
            return

        for n, row in enumerate(rows):
            for i, cell in enumerate(row):
                value = f"{cell}"
                if value in (None, 'None'):
                    value = ''
                tbl_pattern_value.setItem(n, i, QTableWidgetItem(value))
            tbl_pattern_value.insertRow(tbl_pattern_value.rowCount())
        # Set headers
        headers = ['Multiplier' for n in range(0, tbl_pattern_value.rowCount() + 1)]
        tbl_pattern_value.setVerticalHeaderLabels(headers)


    def _load_ws_pattern_widgets(self, dialog):
        """ Load values from session.config """

        # Variables
        cmb_expl_id = dialog.cmb_expl_id

        # Get values
        expl_id = tools_gw.get_config_parser('nonvisual_patterns', 'cmb_expl_id', "user", "session")

        # Populate widgets
        tools_qt.set_combo_value(cmb_expl_id, str(expl_id), 0)


    def _save_ws_pattern_widgets(self, dialog):
        """ Save values from session.config """

        # Variables
        cmb_expl_id = dialog.cmb_expl_id

        # Get values
        expl_id = tools_qt.get_combo_value(dialog, cmb_expl_id)

        # Populate widgets
        tools_gw.set_config_parser('nonvisual_patterns', 'cmb_expl_id', expl_id)


    def _accept_pattern_ws(self, dialog, is_new):
        """ Manage accept button (insert & update) """

        # Variables
        txt_id = dialog.txt_pattern_id
        txt_observ = dialog.txt_observ
        cmb_expl_id = dialog.cmb_expl_id
        tbl_pattern_value = dialog.tbl_pattern_value

        # Get widget values
        pattern_id = tools_qt.get_text(dialog, txt_id, add_quote=True)
        observ = tools_qt.get_text(dialog, txt_observ, add_quote=True)
        expl_id = tools_qt.get_combo_value(dialog, cmb_expl_id)
        if expl_id in (None, ''):
            expl_id = "null"

        if is_new:
            # Check that there are no empty fields
            if not pattern_id or pattern_id == 'null':
                tools_qt.set_stylesheet(txt_id)
                return
            tools_qt.set_stylesheet(txt_id, style="")

            # Insert inp_pattern
            sql = f"INSERT INTO inp_pattern (pattern_id, observ, expl_id)" \
                  f"VALUES({pattern_id}, {observ}, {expl_id})"
            result = tools_db.execute_sql(sql, commit=False)
            if not result:
                msg = "There was an error inserting pattern."
                tools_qgis.show_warning(msg, dialog=dialog)
                global_vars.dao.rollback()
                return

            # Insert inp_pattern_value
            result = self._insert_ws_pattern_values(dialog, tbl_pattern_value, pattern_id)
            if not result:
                return

            # Commit
            global_vars.dao.commit()
            # Reload manager table
            self._reload_manager_table()
        elif pattern_id is not None:
            # Update inp_pattern
            table_name = 'v_edit_inp_pattern'

            observ = observ.strip("'")
            fields = f"""{{"expl_id": {expl_id}, "observ": "{observ}"}}"""

            result = self._setfields(pattern_id.strip("'"), table_name, fields)
            if not result:
                return

            # Update inp_pattern_value
            sql = f"DELETE FROM v_edit_inp_pattern_value WHERE pattern_id = {pattern_id}"
            result = tools_db.execute_sql(sql, commit=False)
            if not result:
                msg = "There was an error deleting old curve values."
                tools_qgis.show_warning(msg, dialog=dialog)
                global_vars.dao.rollback()
                return
            result = self._insert_ws_pattern_values(dialog, tbl_pattern_value, pattern_id)
            if not result:
                return

            # Commit
            global_vars.dao.commit()
            # Reload manager table
            self._reload_manager_table()

        self._save_ws_pattern_widgets(dialog)
        tools_gw.close_dialog(dialog)


    def _insert_ws_pattern_values(self, dialog, tbl_pattern_value, pattern_id):
        """ Insert table values into v_edit_inp_pattern_values """

        # Insert inp_pattern_value
        values = self._read_tbl_values(tbl_pattern_value)

        is_empty = True
        for row in values:
            if row == (['null'] * tbl_pattern_value.columnCount()):
                continue
            is_empty = False

        if is_empty:
            msg = "You need at least one row of values."
            tools_qgis.show_warning(msg, dialog=dialog)
            global_vars.dao.rollback()
            return False

        for row in values:
            if row == (['null'] * tbl_pattern_value.columnCount()):
                continue

            sql = f"INSERT INTO v_edit_inp_pattern_value (pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, " \
                  f"factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, " \
                  f"factor_15, factor_16, factor_17, factor_18) " \
                  f"VALUES ({pattern_id}, "
            for x in row:
                sql += f"{x}, "
            sql = sql.rstrip(', ') + ")"
            result = tools_db.execute_sql(sql, commit=False)
            if not result:
                msg = "There was an error inserting pattern value."
                tools_qgis.show_warning(msg, dialog=dialog)
                global_vars.dao.rollback()
                return False

        return True


    def _manage_ws_patterns_plot(self, table, plot_widget, row, column):
        """ Note: row & column parameters are passed by the signal """

        # Clear plot
        plot_widget.axes.cla()

        # Read row values
        values = self._read_tbl_values(table)
        temp_list = []  # String list with all table values
        for v in values:
            temp_list.append(v)

        # Clean nulls of the end of the list
        clean_list = []
        for i, item in enumerate(temp_list):
            last_idx = -1
            for j, value in enumerate(item):
                if value != 'null':
                    last_idx = j
            clean_list.append(item[:last_idx+1])

        # Convert list items to float
        float_list = []
        for lst in clean_list:
            temp_lst = []
            for item in lst:
                try:
                    value = float(item)
                except ValueError:
                    value = 0
                temp_lst.append(value)
            float_list.append(temp_lst)

        # Create lists for pandas DataFrame
        x_offset = 0
        for lst in float_list:
            if not lst:
                continue
            # Create lists with x zeros as offset to append new rows to the graph
            df_list = [0] * x_offset
            df_list.extend(lst)

            plot_widget.axes.bar(range(0, len(df_list)), df_list, width=1, align='edge', color='lightcoral', edgecolor='indianred')
            plot_widget.axes.set_xticks(range(0, len(df_list)))
            x_offset += len(lst)

        # Draw plot
        plot_widget.draw()


    def _manage_ud_patterns_dlg(self, pattern_id, duplicate=False):
        # Variables
        cmb_pattern_type = self.dialog.cmb_pattern_type
        cmb_expl_id = self.dialog.cmb_expl_id

        # Set scale-to-fit for tableview
        self._scale_to_fit_pattern_tableviews(self.dialog)

        # Create plot widget
        plot_widget = self._create_plot_widget(self.dialog)

        # Populate combobox
        sql = "SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id > 0"
        rows = tools_db.get_rows(sql)
        if rows:
            tools_qt.fill_combo_values(cmb_expl_id, rows, index_to_show=1, add_empty=True)

        sql = "SELECT id, idval FROM inp_typevalue WHERE typevalue = 'inp_typevalue_pattern'"
        rows = tools_db.get_rows(sql)
        if rows:
            tools_qt.fill_combo_values(cmb_pattern_type, rows)

        if pattern_id:
            self._populate_ud_patterns_widgets(pattern_id, duplicate=duplicate)
        else:
            self._load_ud_pattern_widgets(self.dialog)

        # Signals
        cmb_pattern_type.currentIndexChanged.connect(partial(self._manage_patterns_tableviews, self.dialog, cmb_pattern_type, plot_widget))

        self._manage_patterns_tableviews(self.dialog, cmb_pattern_type, plot_widget)

        # Connect OK button to insert all inp_pattern and inp_pattern_value data to database
        is_new = (pattern_id is None) or duplicate
        self.dialog.btn_accept.clicked.connect(partial(self._accept_pattern_ud, self.dialog, is_new))


    def _scale_to_fit_pattern_tableviews(self, dialog):
        tables = [dialog.tbl_monthly, dialog.tbl_daily, dialog.tbl_hourly, dialog.tbl_weekend]
        for table in tables:
            table.horizontalHeader().setSectionResizeMode(1)
            table.horizontalHeader().setMinimumSectionSize(50)


    def _populate_ud_patterns_widgets(self, pattern_id, duplicate=False):
        """ Fills in all the values for ud pattern dialog """

        # Variables
        txt_id = self.dialog.txt_pattern_id
        txt_observ = self.dialog.txt_observ
        cmb_expl_id = self.dialog.cmb_expl_id
        cmb_pattern_type = self.dialog.cmb_pattern_type

        sql = f"SELECT * FROM v_edit_inp_pattern WHERE pattern_id = '{pattern_id}'"
        row = tools_db.get_row(sql)
        if not row:
            return

        # Populate text & combobox widgets
        if not duplicate:
            tools_qt.set_widget_text(self.dialog, txt_id, pattern_id)
            tools_qt.set_widget_enabled(self.dialog, txt_id, False)
        tools_qt.set_widget_text(self.dialog, txt_observ, row['observ'])
        tools_qt.set_combo_value(cmb_expl_id, str(row['expl_id']), 0)
        tools_qt.set_widget_text(self.dialog, cmb_pattern_type, row['pattern_type'])

        # Populate table pattern_values
        sql = f"SELECT * FROM v_edit_inp_pattern_value WHERE pattern_id = '{pattern_id}'"
        rows = tools_db.get_rows(sql)
        if not rows:
            return

        table = self.dialog.findChild(QTableWidget, f"tbl_{row['pattern_type'].lower()}")
        for n, row in enumerate(rows):
            for i in range(0, table.columnCount()):
                value = f"{row[f'factor_{i+1}']}"
                if value == 'None':
                    value = ''
                table.setItem(n, i, QTableWidgetItem(value))


    def _load_ud_pattern_widgets(self, dialog):
        """ Load values from session.config """

        # Variables
        cmb_expl_id = dialog.cmb_expl_id
        cmb_pattern_type = dialog.cmb_pattern_type

        # Get values
        expl_id = tools_gw.get_config_parser('nonvisual_patterns', 'cmb_expl_id', "user", "session")
        pattern_type = tools_gw.get_config_parser('nonvisual_patterns', 'cmb_pattern_type', "user", "session")

        # Populate widgets
        tools_qt.set_combo_value(cmb_expl_id, str(expl_id), 0)
        tools_qt.set_combo_value(cmb_pattern_type, str(pattern_type), 0)


    def _save_ud_pattern_widgets(self, dialog):
        """ Save values from session.config """

        # Variables
        cmb_expl_id = dialog.cmb_expl_id
        cmb_pattern_type = dialog.cmb_pattern_type

        # Get values
        expl_id = tools_qt.get_combo_value(dialog, cmb_expl_id)
        pattern_type = tools_qt.get_combo_value(dialog, cmb_pattern_type)

        # Populate widgets
        tools_gw.set_config_parser('nonvisual_patterns', 'cmb_expl_id', expl_id)
        tools_gw.set_config_parser('nonvisual_patterns', 'cmb_pattern_type', pattern_type)


    def _manage_patterns_tableviews(self, dialog, cmb_pattern_type, plot_widget):

        # Variables
        tbl_monthly = dialog.tbl_monthly
        tbl_daily = dialog.tbl_daily
        tbl_hourly = dialog.tbl_hourly
        tbl_weekend = dialog.tbl_weekend

        # Hide all tables
        tbl_monthly.setVisible(False)
        tbl_daily.setVisible(False)
        tbl_hourly.setVisible(False)
        tbl_weekend.setVisible(False)

        # Only show the pattern_type one
        pattern_type = tools_qt.get_combo_value(dialog, cmb_pattern_type)
        cur_table = dialog.findChild(QTableWidget, f"tbl_{pattern_type.lower()}")
        cur_table.setVisible(True)
        try:
            cur_table.cellChanged.disconnect()
        except TypeError:
            pass
        cur_table.cellChanged.connect(partial(self._manage_ud_patterns_plot, cur_table, plot_widget))
        self._manage_ud_patterns_plot(cur_table, plot_widget, None, None)


    def _accept_pattern_ud(self, dialog, is_new):
        """ Manage accept button (insert & update) """

        # Variables
        txt_id = dialog.txt_pattern_id
        txt_observ = dialog.txt_observ
        cmb_expl_id = dialog.cmb_expl_id
        cmb_pattern_type = dialog.cmb_pattern_type

        # Get widget values
        pattern_id = tools_qt.get_text(dialog, txt_id, add_quote=True)
        pattern_type = tools_qt.get_combo_value(dialog, cmb_pattern_type)
        observ = tools_qt.get_text(dialog, txt_observ, add_quote=True)
        expl_id = tools_qt.get_combo_value(dialog, cmb_expl_id)
        if expl_id in (None, ''):
            expl_id = "null"

        if is_new:
            # Check that there are no empty fields
            if not pattern_id or pattern_id == 'null':
                tools_qt.set_stylesheet(txt_id)
                return
            tools_qt.set_stylesheet(txt_id, style="")

            # Insert inp_pattern
            sql = f"INSERT INTO inp_pattern (pattern_id, pattern_type, observ, expl_id)" \
                  f"VALUES({pattern_id}, '{pattern_type}', {observ}, {expl_id})"
            result = tools_db.execute_sql(sql, commit=False)
            if not result:
                msg = "There was an error inserting pattern."
                tools_qgis.show_warning(msg, dialog=dialog)
                global_vars.dao.rollback()
                return

            # Insert inp_pattern_value
            result = self._insert_ud_pattern_values(dialog, pattern_type, pattern_id)
            if not result:
                return

            # Commit
            global_vars.dao.commit()
            # Reload manager table
            self._reload_manager_table()
        elif pattern_id is not None:
            # Update inp_pattern
            table_name = 'v_edit_inp_pattern'

            observ = observ.strip("'")
            fields = f"""{{"pattern_type": "{pattern_type}", "expl_id": {expl_id}, "observ": "{observ}"}}"""

            result = self._setfields(pattern_id.strip("'"), table_name, fields)
            if not result:
                return

            # Update inp_pattern_value
            sql = f"DELETE FROM v_edit_inp_pattern_value WHERE pattern_id = {pattern_id}"
            result = tools_db.execute_sql(sql, commit=False)
            if not result:
                msg = "There was an error deleting old pattern values."
                tools_qgis.show_warning(msg, dialog=dialog)
                global_vars.dao.rollback()
                return
            result = self._insert_ud_pattern_values(dialog, pattern_type, pattern_id)
            if not result:
                return

            # Commit
            global_vars.dao.commit()
            # Reload manager table
            self._reload_manager_table()

        self._save_ud_pattern_widgets(dialog)
        tools_gw.close_dialog(dialog)


    def _insert_ud_pattern_values(self, dialog, pattern_type, pattern_id):
        """ Insert table values into v_edit_inp_pattern_values """

        table = dialog.findChild(QTableWidget, f"tbl_{pattern_type.lower()}")

        values = self._read_tbl_values(table)

        is_empty = True
        for row in values:
            if row == (['null'] * table.columnCount()):
                continue
            is_empty = False

        if is_empty:
            msg = "You need at least one row of values."
            tools_qgis.show_warning(msg, dialog=dialog)
            global_vars.dao.rollback()
            return False

        for row in values:
            if row == (['null'] * table.columnCount()):
                continue

            sql = f"INSERT INTO v_edit_inp_pattern_value (pattern_id, "
            for n, x in enumerate(row):
                sql += f"factor_{n + 1}, "
            sql = sql.rstrip(', ') + ")"
            sql += f"VALUES ({pattern_id}, "
            for x in row:
                sql += f"{x}, "
            sql = sql.rstrip(', ') + ")"
            result = tools_db.execute_sql(sql, commit=False)
            if not result:
                msg = "There was an error inserting pattern value."
                tools_qgis.show_warning(msg, dialog=dialog)
                global_vars.dao.rollback()
                return False

        return True


    def _manage_ud_patterns_plot(self, table, plot_widget, row, column):
        """ Note: row & column parameters are passed by the signal """

        # Clear plot
        plot_widget.axes.cla()

        # Read row values
        values = self._read_tbl_values(table)
        temp_list = []  # String list with all table values
        for v in values:
            temp_list.append(v)

        # Clean nulls of the end of the list
        clean_list = []
        for i, item in enumerate(temp_list):
            last_idx = -1
            for j, value in enumerate(item):
                if value != 'null':
                    last_idx = j
            clean_list.append(item[:last_idx+1])

        # Convert list items to float
        float_list = []
        for lst in clean_list:
            temp_lst = []
            for item in lst:
                try:
                    value = float(item)
                except ValueError:
                    value = 0
                temp_lst.append(value)
            float_list.append(temp_lst)

        # Create lists for pandas DataFrame
        x_offset = 0
        for lst in float_list:
            if not lst:
                continue
            # Create lists with x zeros as offset to append new rows to the graph
            df_list = [0] * x_offset
            df_list.extend(lst)

            plot_widget.axes.bar(range(0, len(df_list)), df_list, width=1, align='edge', color='lightcoral', edgecolor='indianred')
            plot_widget.axes.set_xticks(range(0, len(df_list)))
            x_offset += len(lst)

        # Draw plot
        plot_widget.draw()

    # endregion

    # region controls
    def get_controls(self, control_id=None, duplicate=False):
        """ Opens dialog for controls """

        # Get dialog
        self.dialog = GwNonVisualControlsUi()
        tools_gw.load_settings(self.dialog)

        # Populate sector id combobox
        self._populate_cmb_sector_id(self.dialog.cmb_sector_id)

        if control_id is not None:
            self._populate_controls_widgets(control_id)
        else:
            self._load_controls_widgets(self.dialog)

        # Connect dialog signals
        is_new = (control_id is None) or duplicate
        self.dialog.btn_accept.clicked.connect(partial(self._accept_controls, self.dialog, is_new, control_id))
        self._connect_dialog_signals()

        # Open dialog
        tools_gw.open_dialog(self.dialog, dlg_name=f'dlg_nonvisual_controls')


    def _populate_controls_widgets(self, control_id):
        """ Fills in all the values for control dialog """

        # Variables
        cmb_sector_id = self.dialog.cmb_sector_id
        chk_active = self.dialog.chk_active
        txt_text = self.dialog.txt_text

        sql = f"SELECT * FROM v_edit_inp_controls WHERE id = '{control_id}'"
        row = tools_db.get_row(sql)
        if not row:
            return

        # Populate text & combobox widgets
        tools_qt.set_combo_value(cmb_sector_id, str(row['sector_id']), 0)
        tools_qt.set_checked(self.dialog, chk_active, row['active'])
        tools_qt.set_widget_text(self.dialog, txt_text, row['text'])


    def _load_controls_widgets(self, dialog):
        """ Load values from session.config """

        # Variables
        cmb_sector_id = dialog.cmb_sector_id
        chk_active = dialog.chk_active

        # Get values
        sector_id = tools_gw.get_config_parser('nonvisual_controls', 'cmb_sector_id', "user", "session")
        active = tools_gw.get_config_parser('nonvisual_controls', 'chk_active', "user", "session")

        # Populate widgets
        tools_qt.set_combo_value(cmb_sector_id, str(sector_id), 0)
        tools_qt.set_checked(dialog, chk_active, active)


    def _save_controls_widgets(self, dialog):
        """ Save values from session.config """

        # Variables
        cmb_sector_id = dialog.cmb_sector_id
        chk_active = dialog.chk_active

        # Get values
        sector_id = tools_qt.get_combo_value(dialog, cmb_sector_id)
        active = tools_qt.is_checked(dialog, chk_active)

        # Populate widgets
        tools_gw.set_config_parser('nonvisual_controls', 'cmb_sector_id', sector_id)
        tools_gw.set_config_parser('nonvisual_controls', 'chk_active', active)


    def _accept_controls(self, dialog, is_new, control_id):
        """ Manage accept button (insert & update) """

        # Variables
        cmb_sector_id = dialog.cmb_sector_id
        chk_active = dialog.chk_active
        txt_text = dialog.txt_text

        # Get widget values
        sector_id = tools_qt.get_combo_value(dialog, cmb_sector_id)
        active = tools_qt.is_checked(dialog, chk_active)
        text = tools_qt.get_text(dialog, txt_text, add_quote=True)

        if is_new:
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
                tools_qgis.show_warning(msg, dialog=dialog)
                global_vars.dao.rollback()
                return

            # Commit
            global_vars.dao.commit()
            # Reload manager table
            self._reload_manager_table()
        elif control_id is not None:
            table_name = 'v_edit_inp_controls'

            text = text.strip("'")
            text = text.replace("\n", "\\n")
            fields = f"""{{"sector_id": {sector_id}, "active": "{active}", "text": "{text}"}}"""

            result = self._setfields(control_id, table_name, fields)
            if not result:
                return
            # Commit
            global_vars.dao.commit()
            # Reload manager table
            self._reload_manager_table()

        self._save_controls_widgets(dialog)
        tools_gw.close_dialog(dialog)

    # endregion

    # region rules
    def get_rules(self, rule_id=None, duplicate=False):
        """ Opens dialog for rules """

        # Get dialog
        self.dialog = GwNonVisualRulesUi()
        tools_gw.load_settings(self.dialog)

        # Populate sector id combobox
        self._populate_cmb_sector_id(self.dialog.cmb_sector_id)

        if rule_id is not None:
            self._populate_rules_widgets(rule_id)
        else:
            self._load_rules_widgets(self.dialog)

        # Connect dialog signals
        is_new = (rule_id is None) or duplicate
        self.dialog.btn_accept.clicked.connect(partial(self._accept_rules, self.dialog, is_new, rule_id))
        self._connect_dialog_signals()

        # Open dialog
        tools_gw.open_dialog(self.dialog, dlg_name=f'dlg_nonvisual_rules')


    def _populate_rules_widgets(self, rule_id):
        """ Fills in all the values for rule dialog """

        # Variables
        cmb_sector_id = self.dialog.cmb_sector_id
        chk_active = self.dialog.chk_active
        txt_text = self.dialog.txt_text

        sql = f"SELECT * FROM v_edit_inp_rules WHERE id = '{rule_id}'"
        row = tools_db.get_row(sql)
        if not row:
            return

        # Populate text & combobox widgets
        tools_qt.set_combo_value(cmb_sector_id, str(row['sector_id']), 0)
        tools_qt.set_checked(self.dialog, chk_active, row['active'])
        tools_qt.set_widget_text(self.dialog, txt_text, row['text'])


    def _load_rules_widgets(self, dialog):
        """ Load values from session.config """

        # Variables
        cmb_sector_id = dialog.cmb_sector_id
        chk_active = dialog.chk_active

        # Get values
        sector_id = tools_gw.get_config_parser('nonvisual_rules', 'cmb_sector_id', "user", "session")
        active = tools_gw.get_config_parser('nonvisual_rules', 'chk_active', "user", "session")

        # Populate widgets
        tools_qt.set_combo_value(cmb_sector_id, str(sector_id), 0)
        tools_qt.set_checked(dialog, chk_active, active)


    def _save_rules_widgets(self, dialog):
        """ Save values from session.config """

        # Variables
        cmb_sector_id = dialog.cmb_sector_id
        chk_active = dialog.chk_active

        # Get values
        sector_id = tools_qt.get_combo_value(dialog, cmb_sector_id)
        active = tools_qt.is_checked(dialog, chk_active)

        # Populate widgets
        tools_gw.set_config_parser('nonvisual_rules', 'cmb_sector_id', sector_id)
        tools_gw.set_config_parser('nonvisual_rules', 'chk_active', active)


    def _accept_rules(self, dialog, is_new, rule_id):
        """ Manage accept button (insert & update) """

        # Variables
        cmb_sector_id = dialog.cmb_sector_id
        chk_active = dialog.chk_active
        txt_text = dialog.txt_text

        # Get widget values
        sector_id = tools_qt.get_combo_value(dialog, cmb_sector_id)
        active = tools_qt.is_checked(dialog, chk_active)
        text = tools_qt.get_text(dialog, txt_text, add_quote=True)

        if is_new:
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
                tools_qgis.show_warning(msg, dialog=dialog)
                global_vars.dao.rollback()
                return

            # Commit
            global_vars.dao.commit()
            # Reload manager table
            self._reload_manager_table()
        elif rule_id is not None:
            table_name = 'v_edit_inp_rules'

            text = text.strip("'")
            text = text.replace("\n", "\\n")
            fields = f"""{{"sector_id": {sector_id}, "active": "{active}", "text": "{text}"}}"""

            result = self._setfields(rule_id, table_name, fields)
            if not result:
                return
            # Commit
            global_vars.dao.commit()
            # Reload manager table
            self._reload_manager_table()

        self._save_rules_widgets(dialog)
        tools_gw.close_dialog(dialog)

    # endregion

    # region timeseries
    def get_timeseries(self, timser_id=None, duplicate=False):
        """ Opens dialog for timeseries """

        # Get dialog
        self.dialog = GwNonVisualTimeseriesUi()
        tools_gw.load_settings(self.dialog)

        # Variables
        cmb_timeser_type = self.dialog.cmb_timeser_type
        cmb_times_type = self.dialog.cmb_times_type
        cmb_expl_id = self.dialog.cmb_expl_id
        tbl_timeseries_value = self.dialog.tbl_timeseries_value

        # Populate combobox
        self._populate_timeser_combos(cmb_expl_id, cmb_times_type, cmb_timeser_type)

        if timser_id is not None:
            self._populate_timeser_widgets(timser_id, duplicate=duplicate)
        else:
            self._load_timeseries_widgets(self.dialog)

        # Set scale-to-fit
        tools_qt.set_tableview_config(tbl_timeseries_value, sectionResizeMode=1, edit_triggers=QTableView.DoubleClicked)

        is_new = (timser_id is None) or duplicate

        # Connect dialog signals
        cmb_times_type.currentTextChanged.connect(partial(self._manage_times_type, tbl_timeseries_value))
        tbl_timeseries_value.cellChanged.connect(partial(self._onCellChanged, tbl_timeseries_value))
        self.dialog.btn_accept.clicked.connect(partial(self._accept_timeseries, self.dialog, is_new))
        self._connect_dialog_signals()

        self._manage_times_type(tbl_timeseries_value, tools_qt.get_combo_value(self.dialog, cmb_times_type))

        # Open dialog
        tools_gw.open_dialog(self.dialog, dlg_name=f'dlg_nonvisual_timeseries')


    def _populate_timeser_combos(self, cmb_expl_id, cmb_times_type, cmb_timeser_type):
        """ Populates timeseries dialog combos """

        sql = "SELECT id, idval FROM inp_typevalue WHERE typevalue = 'inp_value_timserid'"
        rows = tools_db.get_rows(sql)
        if rows:
            tools_qt.fill_combo_values(cmb_timeser_type, rows, index_to_show=1)
        sql = "SELECT id, idval FROM inp_typevalue WHERE typevalue = 'inp_typevalue_timeseries'"
        rows = tools_db.get_rows(sql)
        if rows:
            tools_qt.fill_combo_values(cmb_times_type, rows, index_to_show=1)
        sql = "SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id > 0"
        rows = tools_db.get_rows(sql)
        if rows:
            tools_qt.fill_combo_values(cmb_expl_id, rows, index_to_show=1, add_empty=True)


    def _populate_timeser_widgets(self, timser_id, duplicate=False):
        """ Fills in all the values for timeseries dialog """

        # Variables
        txt_id = self.dialog.txt_id
        txt_idval = self.dialog.txt_idval
        cmb_timeser_type = self.dialog.cmb_timeser_type
        cmb_times_type = self.dialog.cmb_times_type
        txt_descript = self.dialog.txt_descript
        cmb_expl_id = self.dialog.cmb_expl_id
        txt_fname = self.dialog.txt_fname
        tbl_timeseries_value = self.dialog.tbl_timeseries_value

        sql = f"SELECT * FROM v_edit_inp_timeseries WHERE id = '{timser_id}'"
        row = tools_db.get_row(sql)
        if not row:
            return

        # Populate text & combobox widgets
        if not duplicate:
            tools_qt.set_widget_text(self.dialog, txt_id, timser_id)
            tools_qt.set_widget_enabled(self.dialog, txt_id, False)
        tools_qt.set_widget_text(self.dialog, txt_idval, row['idval'])
        tools_qt.set_widget_text(self.dialog, cmb_timeser_type, row['timser_type'])
        tools_qt.set_widget_text(self.dialog, cmb_times_type, row['times_type'])
        tools_qt.set_widget_text(self.dialog, txt_descript, row['descript'])
        tools_qt.set_combo_value(cmb_expl_id, str(row['expl_id']), 0)
        tools_qt.set_widget_text(self.dialog, txt_fname, row['fname'])

        # Populate table timeseries_values
        sql = f"SELECT id, date, hour, time, value FROM v_edit_inp_timeseries_value WHERE timser_id = '{timser_id}'"
        rows = tools_db.get_rows(sql)
        if not rows:
            return

        row0, row1, row2 = None, None, None
        if row['times_type'] == 'FILE':
            return
        elif row['times_type'] == 'RELATIVE':
            row0, row1, row2 = None, 'time', 'value'
        elif row['times_type'] == 'ABSOLUTE':
            row0, row1, row2 = 'date', 'hour', 'value'

        for n, row in enumerate(rows):
            if row0:
                value = f"{row[row0]}"
                if value in (None, 'None', 'null'):
                    value = ''
                tbl_timeseries_value.setItem(n, 0, QTableWidgetItem(value))
            value = f"{row[row1]}"
            if value in (None, 'None', 'null'):
                value = ''
            tbl_timeseries_value.setItem(n, 1, QTableWidgetItem(value))
            value = f"{row[row2]}"
            if value in (None, 'None', 'null'):
                value = ''
            tbl_timeseries_value.setItem(n, 2, QTableWidgetItem(f"{value}"))
            tbl_timeseries_value.insertRow(tbl_timeseries_value.rowCount())


    def _manage_times_type(self, tbl_timeseries_value, text):
        """ Manage timeseries table columns depending on times_type """

        if text == 'RELATIVE':
            tbl_timeseries_value.setColumnHidden(0, True)
            return
        tbl_timeseries_value.setColumnHidden(0, False)


    def _load_timeseries_widgets(self, dialog):
        """ Load values from session.config """

        # Variables
        cmb_expl_id = dialog.cmb_expl_id
        cmb_timeser_type = dialog.cmb_timeser_type
        cmb_times_type = dialog.cmb_times_type

        # Get values
        expl_id = tools_gw.get_config_parser('nonvisual_timeseries', 'cmb_expl_id', "user", "session")
        timeser_type = tools_gw.get_config_parser('nonvisual_timeseries', 'cmb_timeser_type', "user", "session")
        times_type = tools_gw.get_config_parser('nonvisual_timeseries', 'cmb_times_type', "user", "session")

        # Populate widgets
        tools_qt.set_combo_value(cmb_expl_id, str(expl_id), 0)
        tools_qt.set_combo_value(cmb_timeser_type, str(timeser_type), 0)
        tools_qt.set_combo_value(cmb_times_type, str(times_type), 0)


    def _save_timeseries_widgets(self, dialog):
        """ Save values from session.config """

        # Variables
        cmb_expl_id = dialog.cmb_expl_id
        cmb_timeser_type = dialog.cmb_timeser_type
        cmb_times_type = dialog.cmb_times_type

        # Get values
        expl_id = tools_qt.get_combo_value(dialog, cmb_expl_id)
        timeser_type = tools_qt.get_combo_value(dialog, cmb_timeser_type)
        times_type = tools_qt.get_combo_value(dialog, cmb_times_type)

        # Populate widgets
        tools_gw.set_config_parser('nonvisual_timeseries', 'cmb_expl_id', expl_id)
        tools_gw.set_config_parser('nonvisual_timeseries', 'cmb_timeser_type', timeser_type)
        tools_gw.set_config_parser('nonvisual_timeseries', 'cmb_times_type', times_type)


    def _accept_timeseries(self, dialog, is_new):
        """ Manage accept button (insert & update) """

        # Variables
        txt_id = dialog.txt_id
        txt_idval = dialog.txt_idval
        cmb_timeser_type = dialog.cmb_timeser_type
        cmb_times_type = dialog.cmb_times_type
        txt_descript = dialog.txt_descript
        cmb_expl_id = dialog.cmb_expl_id
        txt_fname = dialog.txt_fname
        tbl_timeseries_value = dialog.tbl_timeseries_value

        # Get widget values
        timeseries_id = tools_qt.get_text(dialog, txt_id, add_quote=True)
        idval = tools_qt.get_text(dialog, txt_idval, add_quote=True)
        timser_type = tools_qt.get_combo_value(dialog, cmb_timeser_type)
        times_type = tools_qt.get_combo_value(dialog, cmb_times_type)
        descript = tools_qt.get_text(dialog, txt_descript, add_quote=True)
        fname = tools_qt.get_text(dialog, txt_fname, add_quote=True)
        expl_id = tools_qt.get_combo_value(dialog, cmb_expl_id)
        if expl_id in (None, ''):
            expl_id = "null"

        if is_new:
            # Check that there are no empty fields
            if not timeseries_id or timeseries_id == 'null':
                tools_qt.set_stylesheet(txt_id)
                return
            tools_qt.set_stylesheet(txt_id, style="")

            # Insert inp_timeseries
            sql = f"INSERT INTO inp_timeseries (id, timser_type, times_type, idval, descript, fname, expl_id)" \
                  f"VALUES({timeseries_id}, '{timser_type}', '{times_type}', {idval}, {descript}, {fname}, {expl_id})"
            result = tools_db.execute_sql(sql, commit=False)
            if not result:
                msg = "There was an error inserting timeseries."
                tools_qgis.show_warning(msg, dialog=dialog)
                global_vars.dao.rollback()
                return

            if fname not in (None, 'null'):
                sql = ""  # No need to insert to inp_timeseries_value?

            # Insert inp_timeseries_value
            result = self._insert_timeseries_value(dialog, tbl_timeseries_value, times_type, timeseries_id)
            if not result:
                return

            # Commit
            global_vars.dao.commit()
            # Reload manager table
            self._reload_manager_table()
        elif timeseries_id is not None:
            # Update inp_timeseries
            table_name = 'v_edit_inp_timeseries'

            idval = idval.strip("'")
            timser_type = timser_type.strip("'")
            times_type = times_type.strip("'")
            descript = descript.strip("'")
            fname = fname.strip("'")
            fields = f"""{{"expl_id": {expl_id}, "idval": "{idval}", "timser_type": "{timser_type}", "times_type": "{times_type}", "descript": "{descript}", "fname": "{fname}"}}"""

            result = self._setfields(timeseries_id.strip("'"), table_name, fields)
            if not result:
                return

            # Update inp_timeseries_value
            sql = f"DELETE FROM v_edit_inp_timeseries_value WHERE timser_id = {timeseries_id}"
            result = tools_db.execute_sql(sql, commit=False)
            if not result:
                msg = "There was an error deleting old timeseries values."
                tools_qgis.show_warning(msg, dialog=dialog)
                global_vars.dao.rollback()
                return
            result = self._insert_timeseries_value(dialog, tbl_timeseries_value, times_type, timeseries_id)
            if not result:
                return

            # Commit
            global_vars.dao.commit()
            # Reload manager table
            self._reload_manager_table()

        self._save_timeseries_widgets(dialog)
        tools_gw.close_dialog(dialog)


    def _insert_timeseries_value(self, dialog, tbl_timeseries_value, times_type, timeseries_id):
        """ Insert table values into v_edit_inp_timeseries_value """

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
            tools_qgis.show_warning(msg, dialog=dialog)
            global_vars.dao.rollback()
            return False

        if times_type == 'ABSOLUTE':
            for row in values:
                if row == (['null'] * tbl_timeseries_value.columnCount()):
                    continue
                if 'null' in (row[0], row[1], row[2]):
                    msg = "You have to fill in 'date', 'time' and 'value' fields!"
                    tools_qgis.show_warning(msg, dialog=dialog)
                    global_vars.dao.rollback()
                    return False

                sql = f"INSERT INTO v_edit_inp_timeseries_value (timser_id, date, hour, value) "
                sql += f"VALUES ({timeseries_id}, {row[0]}, {row[1]}, {row[2]})"

                result = tools_db.execute_sql(sql, commit=False)
                if not result:
                    msg = "There was an error inserting pattern value."
                    tools_qgis.show_warning(msg, dialog=dialog)
                    global_vars.dao.rollback()
                    return False
        elif times_type == 'RELATIVE':

            for row in values:
                if row == (['null'] * tbl_timeseries_value.columnCount()):
                    continue
                if 'null' in (row[1], row[2]):
                    msg = "You have to fill in 'time' and 'value' fields!"
                    tools_qgis.show_warning(msg, dialog=dialog)
                    global_vars.dao.rollback()
                    return False

                sql = f"INSERT INTO v_edit_inp_timeseries_value (timser_id, time, value) "
                sql += f"VALUES ({timeseries_id}, {row[1]}, {row[2]})"

                result = tools_db.execute_sql(sql, commit=False)
                if not result:
                    msg = "There was an error inserting pattern value."
                    tools_qgis.show_warning(msg, dialog=dialog)
                    global_vars.dao.rollback()
                    return False

        return True

    # endregion

    # region lids
    def get_lids(self, lidco_id=None, duplicate=None):
        """ Opens dialog for lids """

        # Get dialog
        self.dialog = GwNonVisualLidsUi()

        # Set dialog not resizable
        self.dialog.setFixedSize(self.dialog.size())

        tools_gw.load_settings(self.dialog)

        is_new = (lidco_id is None) or duplicate

        # Manage decimal validation for QLineEdit
        widget_list = self.dialog.findChildren(QLineEdit)
        for widget in widget_list:
            tools_qt.double_validator(widget, 0, 9999999, 3)

        # Populate LID Type combo
        sql = f"SELECT id, idval FROM inp_typevalue WHERE typevalue = 'inp_value_lidtype' ORDER BY idval"
        rows = tools_db.get_rows(sql)
        if rows:
            tools_qt.fill_combo_values(self.dialog.cmb_lidtype, rows, 1)

        # Populate Control Curve combo
        sql = f"SELECT id FROM v_edit_inp_curve; "
        rows = tools_db.get_rows(sql)
        if rows:
            tools_qt.fill_combo_values(self.dialog.cmb_control_curve, rows)

        # Signals
        self.dialog.cmb_lidtype.currentIndexChanged.connect(partial(self._manage_lids_tabs, self.dialog))
        self.dialog.btn_ok.clicked.connect(partial(self._accept_lids, self.dialog, is_new, lidco_id))

        self._manage_lids_tabs(self.dialog)

        if lidco_id:
            self._populate_lids_widgets(self.dialog, lidco_id, duplicate)
        else:
            self._load_lids_widgets(self.dialog)

        # Open dialog
        tools_gw.open_dialog(self.dialog, dlg_name=f'dlg_nonvisual_lids')


    def _populate_lids_widgets(self, dialog, lidco_id, duplicate=False):
        """ Fills in all the values for lid dialog """

        # Get lidco_type
        cmb_lidtype = dialog.cmb_lidtype

        sql = f"SELECT lidco_type FROM inp_lid WHERE lidco_id='{lidco_id}'"
        row = tools_db.get_row(sql)
        if not row:
            return
        lidco_type = row[0]

        if not duplicate:
            tools_qt.set_widget_text(self.dialog, self.dialog.txt_name, lidco_id)
            tools_qt.set_widget_enabled(self.dialog, self.dialog.txt_name, False)
        tools_qt.set_combo_value(cmb_lidtype, str(lidco_type), 0)

        # Populate tab values
        sql = f"SELECT value_2, value_3, value_4, value_5, value_6, value_7,value_8 " \
              f"FROM inp_lid_value WHERE lidco_id='{lidco_id}'"
        rows = tools_db.get_rows(sql)

        if rows:
            idx = 0
            for i in range(self.dialog.tab_lidlayers.count()):
                if self.dialog.tab_lidlayers.isTabVisible(i):
                    try:
                        row = rows[idx]
                    except IndexError:  # The tab exists in dialog but not in db (drain might be optional)
                        continue

                    # List with all QLineEdit children
                    child_list = self.dialog.tab_lidlayers.widget(i).children()
                    visible_widgets = [widget for widget in child_list if type(widget) == QLineEdit]
                    visible_widgets = self._order_list(visible_widgets)

                    for x, value in enumerate(row):
                        if value in ('null', None):
                            continue
                        try:
                            widget = visible_widgets[x]
                        except IndexError:  # The widget exists in dialog but not in db (db error, extra values)
                            continue
                        tools_qt.set_widget_text(self.dialog, widget, f"{value}")
                    idx += 1


    def _load_lids_widgets(self, dialog):
        """ Load values from session.config """

        # Variable
        cmb_lidtype = dialog.cmb_lidtype

        # Get values
        lidtype = tools_gw.get_config_parser('nonvisual_lids', 'cmb_lidtype', "user", "session")

        # Populate widgets
        tools_qt.set_combo_value(cmb_lidtype, str(lidtype), 0)

        for i in range(dialog.tab_lidlayers.count()):
            if Qgis.QGIS_VERSION_INT >= 32000:
                if not dialog.tab_lidlayers.isTabVisible(i):
                    continue
            else:
                if not dialog.tab_lidlayers.isTabEnabled(i):
                    continue

                # List with all QLineEdit children
                child_list = dialog.tab_lidlayers.widget(i).children()
                visible_widgets = [widget for widget in child_list if
                                   type(widget) == QLineEdit or type(widget) == QComboBox]
                visible_widgets = self._order_list(visible_widgets)

                for y, widget in enumerate(visible_widgets):
                    value = tools_gw.get_config_parser('nonvisual_lids', f"{widget.objectName()}", "user", "session")

                    if type(widget) == QLineEdit:
                        tools_qt.set_widget_text(dialog, widget, str(value))
                    else:
                        tools_qt.set_combo_value(widget, str(value), 0)


    def _save_lids_widgets(self, dialog):
        """ Save values from session.config """

        # Variables
        txt_name = dialog.txt_name
        cmb_lidtype = dialog.cmb_lidtype

        # Get values
        name = tools_qt.get_text(dialog, txt_name)
        lidtype = tools_qt.get_combo_value(dialog, cmb_lidtype)

        for i in range(dialog.tab_lidlayers.count()):
            if dialog.tab_lidlayers.isTabVisible(i):
                tab_name = dialog.tab_lidlayers.widget(i).objectName().upper()
                # List with all QLineEdit children
                child_list = dialog.tab_lidlayers.widget(i).children()
                visible_widgets = [widget for widget in child_list if type(widget) == QLineEdit or type(widget) == QComboBox]
                visible_widgets = self._order_list(visible_widgets)

                for y, widget in enumerate(visible_widgets):
                    if type(widget) == QLineEdit:
                        value = tools_qt.get_text(dialog, widget)
                    else:
                        value = tools_qt.get_combo_value(dialog, widget)
                    tools_gw.set_config_parser('nonvisual_lids', f"{widget.objectName()}", value)

        # Populate widgets
        tools_gw.set_config_parser('nonvisual_lids', 'cmb_lidtype', lidtype)
        tools_gw.set_config_parser('nonvisual_lids', 'txt_name', name)



    def _manage_lids_tabs(self, dialog):

        cmb_lidtype = dialog.cmb_lidtype
        tab_lidlayers = dialog.tab_lidlayers
        lidco_id = str(cmb_lidtype.currentText())

        # Tabs to show
        sql = f"SELECT addparam, id FROM inp_typevalue WHERE typevalue = 'inp_value_lidtype' and idval =  '{lidco_id}'"
        row = tools_db.get_row(sql)

        lidtabs = []
        if row:
            json_result = row[0]
            lid_id = row[1]
            lidtabs = json_result[f"{lid_id}"]

        # Show tabs
        for i in range(tab_lidlayers.count()):
            tab_name = tab_lidlayers.widget(i).objectName().upper()
            if tab_name not in lidtabs:
                if Qgis.QGIS_VERSION_INT >= 32000:
                    tab_lidlayers.setTabVisible(i, False)
                else:
                    tab_lidlayers.setTabEnabled(i, False)

            else:
                if Qgis.QGIS_VERSION_INT >= 32000:
                    tab_lidlayers.setTabVisible(i, True)
                else:
                    tab_lidlayers.setTabEnabled(i, True)

                if tab_name == 'DRAIN':
                    if lid_id == 'RD':
                        tab_lidlayers.setTabText(i, "Roof Drainage")
                    else:
                        tab_lidlayers.setTabText(i, "Drain")
                self._manage_lids_hide_widgets(self.dialog, lid_id)

        # Set image
        self._manage_lids_images(lidco_id)


    def _manage_lids_hide_widgets(self, dialog, lid_id):
        """ Hides widgets that are not necessary in specific tabs """

        # List of widgets
        widgets_hide = {'BC': {'lbl_surface_side_slope', 'txt_surface_side_slope', 'lbl_drain_delay', 'txt_drain_delay'},
                        'RG': {'lbl_surface_side_slope', 'txt_surface_side_slope'},
                        'GR': {'lbl_surface_slope', 'txt_surface_slope'},
                        'IT': {'lbl_surface_side_slope', 'txt_surface_side_slope', 'lbl_drain_delay', 'txt_drain_delay'},
                        'PP': {'lbl_surface_side_slope', 'txt_surface_side_slope', 'lbl_drain_delay', 'txt_drain_delay'},
                        'RB': {'lbl_seepage_rate', 'txt_seepage_rate', 'lbl_clogging_factor_storage', 'txt_clogging_factor_storage'},
                        'RD': {'lbl_vegetation_volume', 'txt_vegetation_volume', 'lbl_surface_side_slope', 'txt_surface_side_slope',
                               'lbl_flow_exponent','lbl_offset', 'lbl_drain_delay', 'lbl_open_level',
                               'lbl_closed_level', 'lbl_control_curve', 'lbl_flow_description', 'txt_flow_exponent',
                               'txt_offset', 'txt_drain_delay', 'txt_open_level', 'txt_closed_level', 'cmb_control_curve',},
                        'VS': {''}}

        # Hide widgets in list
        for i in range(dialog.tab_lidlayers.count()):
            if Qgis.QGIS_VERSION_INT >= 32000:
                if not dialog.tab_lidlayers.isTabVisible(i):
                    continue
            else:
                if not dialog.tab_lidlayers.isTabEnabled(i):
                    continue

            # List of children
            list = dialog.tab_lidlayers.widget(i).children()
            for y in list:
                if type(y) != QGridLayout:
                    y.show()
                    for j in widgets_hide[lid_id]:
                        if j == y.objectName():
                            y.hide()



    def _manage_lids_images(self, lidco_id):
        """ Manage images depending on lidco_id selected"""

        sql = f"SELECT id FROM inp_typevalue WHERE typevalue = 'inp_value_lidtype' and idval = '{lidco_id}'"
        row = tools_db.get_row(sql)
        if not row:
            return

        img = f"ud_lid_{row[0]}"
        tools_qt.add_image(self.dialog, 'lbl_section_image',
                           f"{self.plugin_dir}{os.sep}resources{os.sep}png{os.sep}{img}")


    def _accept_lids(self, dialog, is_new, lidco_id):
        """ Manage accept button (insert & update) """

        # Variables
        cmb_lidtype=dialog.cmb_lidtype
        txt_lidco_id = dialog.txt_name

        # Get widget values
        lidco_type = tools_qt.get_combo_value(dialog, cmb_lidtype)
        lidco_id = tools_qt.get_text(dialog, txt_lidco_id, add_quote=True)

        # Insert in table 'inp_lid'
        if is_new:
            if not lidco_id or lidco_id == 'null':
                tools_qt.set_stylesheet(txt_lidco_id)
                return
            tools_qt.set_stylesheet(txt_lidco_id, style="")

            # Insert in inp_lid
            if lidco_id != '':
                sql = f"INSERT INTO inp_lid(lidco_id, lidco_type) VALUES({lidco_id}, '{lidco_type}')"
                result = tools_db.execute_sql(sql, commit=False)

                if not result:
                    msg = "There was an error inserting lid."
                    tools_qgis.show_warning(msg, dialog=dialog)
                    global_vars.dao.rollback()
                    return False

            # Inserts in table inp_lid_value
            result = self._insert_lids_values(dialog, lidco_id.strip("'"), lidco_type)
            if not result:
                sql = f"DELETE FROM inp_lid WHERE lidco_id ={lidco_id}"
                tools_db.execute_sql(sql, commit=False)
                return

            # Commit
            global_vars.dao.commit()
            # Reload manager table
            self._reload_manager_table()

        elif lidco_id is not None:
            # Update inp_lid fields
            table_name = 'inp_lid'

            fields = f"""{{"lidco_type": "{lidco_type}"}}"""

            result = self._setfields(lidco_id.strip("'"), table_name, fields)
            if not result:
                return

            # Delete existing inp_lid_value values
            sql = f"DELETE FROM inp_lid_value WHERE lidco_id = {lidco_id}"
            result = tools_db.execute_sql(sql, commit=False)
            if not result:
                msg = "There was an error deleting old lid values."
                tools_qgis.show_warning(msg, dialog=dialog)
                global_vars.dao.rollback()
                return

            # Inserts in table inp_lid_value
            result = self._insert_lids_values(dialog, lidco_id.strip("'"), lidco_type)
            if not result:
                return

            # Commit
            global_vars.dao.commit()
            # Reload manager table
            self._reload_manager_table()

        self._save_lids_widgets(dialog)
        tools_gw.close_dialog(dialog)


    def _insert_lids_values(self, dialog, lidco_id, lidco_type):

        control_values = {'BC': {'txt_thickness', 'txt_thickness_storage'},
                    'RG': {'txt_thickness', 'txt_thickness_storage'},
                    'GR': {'txt_thickness', 'drainmat_2'},
                    'IT': {'txt_thickness_storage'},
                    'PP': {'txt_thinkness_pavement', 'txt_thickness_storage'},
                    'RB': {''},
                    'RD': {''},
                    'VS': {'txt_berm_height'}}

        for i in range(dialog.tab_lidlayers.count()):
            if dialog.tab_lidlayers.isTabVisible(i):
                tab_name = dialog.tab_lidlayers.widget(i).objectName().upper()
                # List with all QLineEdit children
                child_list = dialog.tab_lidlayers.widget(i).children()
                visible_widgets = [widget for widget in child_list if type(widget) == QLineEdit or type(widget) == QComboBox]
                visible_widgets = self._order_list(visible_widgets)

                sql = f"INSERT INTO inp_lid_value (lidco_id, lidlayer,"
                for y, widget in enumerate(visible_widgets):
                    sql += f"value_{y + 2}, "
                sql = sql.rstrip(', ') + ")"
                sql += f"VALUES ('{lidco_id}', '{tab_name}', "
                for widget in visible_widgets:
                    value = tools_qt.get_text(dialog, widget.objectName(), add_quote=True)
                    if value == "null":
                        value = "'0'"
                    # Control values that cannot be 0
                    if widget.objectName() in control_values[lidco_type] and value == "'0'":
                        dialog.tab_lidlayers.setCurrentWidget(dialog.tab_lidlayers.widget(i))
                        tools_qt.show_info_box("Marked values must be greater than 0", "LIDS")
                        tools_qt.set_stylesheet(widget)

                        return False
                    tools_qt.set_stylesheet(widget, style="")

                    sql += f"{value}, "
                sql = sql.rstrip(', ') + ")"
                result = tools_db.execute_sql(sql, commit=False)
                if not result:
                    msg = "There was an error inserting lid."
                    tools_qgis.show_warning(msg, dialog=dialog)
                    global_vars.dao.rollback()
                    return False
        return True

    # endregion

    # region private functions
    def _setfields(self, id, table_name, fields):

        feature = f'"id":"{id}", '
        feature += f'"tableName":"{table_name}" '
        extras = f'"fields":{fields}'
        body = tools_gw.create_body(feature=feature, extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_setfields', body, commit=False)

        if (not json_result) or (json_result.get('status') in (None, 'Failed')):
            global_vars.dao.rollback()
            return False

        return True


    def _reload_manager_table(self):

        try:
            self.manager_dlg.main_tab.currentWidget().model().select()
        except:
            pass


    def _connect_dialog_signals(self):

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


    def _read_tbl_values(self, table, clear_nulls=False):

        values = list()
        for y in range(0, table.rowCount()):
            values.append(list())
            for x in range(0, table.columnCount()):
                value = "null"
                item = table.item(y, x)
                if item is not None and item.data(0) not in (None, ''):
                    value = item.data(0)
                if clear_nulls and value == "null":
                    continue
                values[y].append(value)
        return values


    def _populate_cmb_sector_id(self, combobox):

        sql = f"SELECT sector_id as id, name as idval FROM v_edit_sector WHERE sector_id > 0"
        rows = tools_db.get_rows(sql)
        if rows:
            tools_qt.fill_combo_values(combobox, rows, index_to_show=1)


    def _create_plot_widget(self, dialog):

        plot_widget = MplCanvas(dialog, width=5, height=4, dpi=100)
        plot_widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.MinimumExpanding)
        plot_widget.setMinimumSize(100, 100)
        dialog.lyt_plot.addWidget(plot_widget, 0, 0)

        return plot_widget


    def _order_list(self, lst):
        """Order widget list by objectName"""

        for x in range(len(lst)):
            for j in range(0, (len(lst) - x - 1)):
                if lst[j].objectName() > lst[(j + 1)].objectName():
                    lst[j], lst[(j + 1)] = lst[(j + 1)], lst[j]
        return lst

    # endregion
