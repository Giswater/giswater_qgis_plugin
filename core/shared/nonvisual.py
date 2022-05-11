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

        self.dialog.btn_accept.clicked.connect(self.dialog.accept)
        self.dialog.btn_cancel.clicked.connect(self.dialog.reject)
        self.dialog.finished.connect(partial(tools_gw.close_dialog, self.dialog))


    def _manage_ws_patterns_dlg(self):
        tbl_pattern_value = self.dialog.tbl_pattern_value
        tbl_pattern_value.cellChanged.connect(partial(self._onCellChanged, tbl_pattern_value))
        # TODO: Connect signal to draw graphic?

        # Connect OK button to insert all inp_pattern and inp_pattern_value data to database


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
