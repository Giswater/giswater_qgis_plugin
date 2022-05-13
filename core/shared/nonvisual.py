"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from qgis.PyQt.QtCore import QRegExp
from qgis.PyQt.QtGui import QRegExpValidator
from qgis.PyQt.QtWidgets import QAbstractItemView, QPushButton, QTableView, QComboBox

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

        # Connect dialog signals
        self.manager_dlg.btn_cancel.clicked.connect(self.manager_dlg.reject)
        self.manager_dlg.finished.connect(partial(tools_gw.close_dialog, self.manager_dlg))

        # Open dialog
        tools_gw.open_dialog(self.manager_dlg, dlg_name=f'dlg_nonvisual_manager')


    def get_nonvisual(self, object_name):
        """  """

        if object_name is None:
            return

        # Execute method get_{object_name}
        getattr(self, f'get_{object_name.lower()}')()


    def get_roughness(self):
        """  """
        pass


    def get_curves(self):
        """  """

        # Get dialog
        self.dialog = GwNonVisualCurveUi()
        tools_gw.load_settings(self.dialog)

        # Define variables
        tbl_curve_value = self.dialog.tbl_curve_value

        # Connect dialog signals
        tbl_curve_value.cellChanged.connect(partial(self._onCellChanged, tbl_curve_value))
        self._connect_dialog_signals()

        # Open dialog
        tools_gw.open_dialog(self.dialog, dlg_name=f'dlg_nonvisual_curve')


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


    def get_controls(self):
        """  """

        # Get dialog
        self.dialog = GwNonVisualControlsUi()
        tools_gw.load_settings(self.dialog)

        # Connect dialog signals
        self._connect_dialog_signals()

        # Open dialog
        tools_gw.open_dialog(self.dialog, dlg_name=f'dlg_nonvisual_controls')


    def get_rules(self):
        """  """

        # Get dialog
        self.dialog = GwNonVisualRulesUi()
        tools_gw.load_settings(self.dialog)

        # Connect dialog signals
        self._connect_dialog_signals()

        # Open dialog
        tools_gw.open_dialog(self.dialog, dlg_name=f'dlg_nonvisual_rules')


    def get_timeseries(self):
        """  """

        # Get dialog
        self.dialog = GwNonVisualTimeseriesUi()
        tools_gw.load_settings(self.dialog)

        # Connect dialog signals
        self._connect_dialog_signals()

        # Open dialog
        tools_gw.open_dialog(self.dialog, dlg_name=f'dlg_nonvisual_timeseries')


    def _connect_dialog_signals(self):

        # self.dialog.btn_accept.clicked.connect(self.dialog.accept)
        self.dialog.btn_cancel.clicked.connect(self.dialog.reject)
        self.dialog.rejected.connect(partial(tools_gw.close_dialog, self.dialog))


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
        pattern_id = tools_qt.get_text(self.dialog, txt_id)
        observ = tools_qt.get_text(self.dialog, txt_observ)
        expl_id = tools_qt.get_combo_value(self.dialog, cmb_expl_id)
        log = tools_qt.get_text(self.dialog, txt_log)

        # Check that there are no empty fields
        if not pattern_id or pattern_id == 'null':
            tools_qt.set_stylesheet(txt_id)
            return
        tools_qt.set_stylesheet(txt_id, style="")

        # Insert inp_pattern
        sql = f"INSERT INTO inp_pattern (pattern_id, observ, expl_id, log)" \
              f"VALUES('{pattern_id}', '{observ}', {expl_id}, '{log}')"
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

        for row in values:
            if row == (['null'] * tbl_pattern_value.columnCount()):
                continue

            sql = f"INSERT INTO inp_pattern_value (pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12) " \
                  f"VALUES ('{pattern_id}', "
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
        pass


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
