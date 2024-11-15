from datetime import timedelta
from enum import Enum
from functools import partial
from pathlib import Path
from time import time
from typing import Optional, Tuple

from qgis.core import QgsApplication
from qgis.PyQt.QtCore import Qt, QTimer
from qgis.PyQt.QtWidgets import (
    QActionGroup,
    QComboBox,
    QFileDialog,
    QLabel,
    QTableWidget,
    QTableWidgetItem,
    QTextEdit,
)
from sip import isdeleted

from ..... import global_vars
from .....libs import tools_db, tools_qgis, tools_qt
from ....models.plugin_toolbar import GwPluginToolbar
from ....ui.dialog import GwDialog
from ....ui.ui_manager import GwInpConfigImportUi, GwInpParsingUi
from ....threads.import_inp.import_epanet_task import GwImportInpTask
from ....utils import tools_gw
from ...dialog import GwAction

CREATE_NEW = "Create new"
TESTING_MODE = True


class ProjectType(Enum):
    WS = "ws"
    UD = "ud"


class GwImportSwmm:
    """Button 22: Import INP"""

    def __init__(self) -> None:
        self.file_path: Optional[Path] = None
        self.cur_process = None
        self.cur_text = None

    def clicked_event(self) -> None:
        """Start the Import INP workflow"""

        msg = "Import INP is only available for WS (WNTR projects)"
        tools_qgis.show_warning(msg)

        try:
            import swmm_api
            from ....threads.import_inp import parse_swmm_task

            global Catalogs, GwParseInpTask
            Catalogs = parse_swmm_task.Catalogs
            GwParseInpTask = parse_swmm_task.GwParseInpTask

            self.file_path: Optional[Path] = self._get_file()

            if not self.file_path:
                return

            self.parse_inp_file(self.file_path)

        except ImportError:
            message: str = (
                "Couldn't import swmm_api package. "
                "Try to reload the Giswater plugin. "
                "If the issue persists restart QGIS."
            )
            tools_qgis.show_message(message)

    def _get_file(self) -> Optional[Path]:
        # Load a select file dialog for select a file with .inp extension
        result: Tuple[str, str] = QFileDialog.getOpenFileName(
            None, "Select an INP file", "", "INP files (*.inp)"
        )
        file_path_str: str = result[0]
        if file_path_str:
            file_path: Path = Path(file_path_str)

            # Check if the file extension is .inp
            if file_path.suffix == ".inp":
                return file_path
            else:
                tools_qgis.show_warning("The file selected is not an INP file")
                return

    def parse_inp_file(self, file_path: Path) -> None:
        """Parse INP file, showing a log to the user"""

        # Create and show parsing dialog
        self.dlg_inp_parsing = GwInpParsingUi(self)
        tools_gw.load_settings(self.dlg_inp_parsing)
        self.dlg_inp_parsing.rejected.connect(
            partial(tools_gw.save_settings, self.dlg_inp_parsing)
        )
        tools_gw.open_dialog(self.dlg_inp_parsing, dlg_name="parse_inp")

        global GwParseInpTask
        self.parse_inp_task = GwParseInpTask(
            "Parse INP task", file_path, self.dlg_inp_parsing
        )
        QgsApplication.taskManager().addTask(self.parse_inp_task)
        QgsApplication.taskManager().triggerTask(self.parse_inp_task)

        # Create timer
        self.t0: float = time()
        self.timer: QTimer = QTimer()
        self.timer.timeout.connect(
            partial(self._update_parsing_dialog, self.dlg_inp_parsing)
        )
        self.timer.start(1000)
        self.parse_inp_task.taskCompleted.connect(self.timer.stop)
        self.parse_inp_task.taskCompleted.connect(self.dlg_inp_parsing.close)
        self.parse_inp_task.taskCompleted.connect(self.open_config_dialog)

    def open_config_dialog(self) -> None:
        """Open the config INP import dialog"""

        self.dlg_config = GwInpConfigImportUi(self)
        tools_gw.load_settings(self.dlg_config)
        self.dlg_config.rejected.connect(
            partial(tools_gw.save_settings, self.dlg_config)
        )
        self.dlg_config.btn_reload.clicked.connect(self._fill_combo_boxes)
        self.dlg_config.btn_cancel.clicked.connect(self.dlg_config.reject)
        self.dlg_config.btn_accept.clicked.connect(self._importinp_accept)

        # Get catalogs from thread
        global Catalogs
        self.catalogs: Catalogs = self.parse_inp_task.catalogs

        # Fill nodes table
        tbl_nodes: QTableWidget = self.dlg_config.tbl_nodes

        node_elements = [
            ("junctions", self.catalogs.inp_junctions, "JUNCTION"),
            ("reservoirs", self.catalogs.inp_reservoirs, "RESERVOIR"),
            ("tanks", self.catalogs.inp_tanks, "TANK"),
        ]

        self.tbl_elements = {}

        for element, rec_catalog, tag in node_elements:
            if rec_catalog is not None:
                row: int = tbl_nodes.rowCount()
                tbl_nodes.setRowCount(row + 1)

                first_column = QTableWidgetItem(tag)
                first_column.setFlags(Qt.ItemIsEnabled)
                tbl_nodes.setItem(row, 0, first_column)

                combo_cat = QComboBox()
                tbl_nodes.setCellWidget(row, 1, combo_cat)

                new_cat_name = QTableWidgetItem("")
                new_cat_name.setFlags(Qt.NoItemFlags)
                tbl_nodes.setItem(row, 2, new_cat_name)
                combo_cat.currentTextChanged.connect(
                    partial(self._toggle_enabled_new_catalog_field, new_cat_name)
                )

                self.tbl_elements[element] = (combo_cat, new_cat_name)

        # Fill arcs table with the pipes
        tbl_arcs: QTableWidget = self.dlg_config.tbl_arcs

        if self.catalogs.inp_pipes:
            self.tbl_elements["pipes"] = {}

            for (diameter, roughness), rec_catalog in self.catalogs.inp_pipes.items():
                row: int = tbl_arcs.rowCount()
                tbl_arcs.setRowCount(row + 1)

                first_column = QTableWidgetItem("PIPE")
                first_column.setFlags(Qt.ItemIsEnabled)
                tbl_arcs.setItem(row, 0, first_column)

                d_column = QTableWidgetItem(str(diameter))
                d_column.setFlags(Qt.ItemIsEnabled)
                tbl_arcs.setItem(row, 1, d_column)

                r_column = QTableWidgetItem(str(roughness))
                r_column.setFlags(Qt.ItemIsEnabled)
                tbl_arcs.setItem(row, 2, r_column)

                combo_cat = QComboBox()
                tbl_arcs.setCellWidget(row, 3, combo_cat)

                new_cat_name = QTableWidgetItem("")
                new_cat_name.setFlags(Qt.NoItemFlags)
                tbl_arcs.setItem(row, 4, new_cat_name)
                combo_cat.currentTextChanged.connect(
                    partial(self._toggle_enabled_new_catalog_field, new_cat_name)
                )

                self.tbl_elements["pipes"][(diameter, roughness)] = (
                    combo_cat,
                    new_cat_name,
                )

        # Fill arcs table with pumps and valves
        arc_elements = [
            ("pumps", self.catalogs.inp_pumps, "PUMP"),
            ("valves", self.catalogs.inp_valves, "VALVE"),
        ]

        for element, rec_catalog, tag in arc_elements:
            if rec_catalog is None:
                continue

            row: int = tbl_arcs.rowCount()
            tbl_arcs.setRowCount(row + 1)

            first_column = QTableWidgetItem(tag)
            first_column.setFlags(Qt.ItemIsEnabled)
            tbl_arcs.setItem(row, 0, first_column)

            combo_cat = QComboBox()
            tbl_arcs.setCellWidget(row, 3, combo_cat)

            new_cat_name = QTableWidgetItem("")
            new_cat_name.setFlags(Qt.NoItemFlags)
            tbl_arcs.setItem(row, 4, new_cat_name)
            combo_cat.currentTextChanged.connect(
                partial(self._toggle_enabled_new_catalog_field, new_cat_name)
            )

            self.tbl_elements[element] = (combo_cat, new_cat_name)

        # Fill materials table
        tbl_material: QTableWidget = self.dlg_config.tbl_material

        if self.catalogs.inp_pipes:
            self.tbl_elements["materials"] = {}
            roughnesses = {roughness for (_, roughness) in self.catalogs.inp_pipes}

            for roughness in roughnesses:
                row: int = tbl_material.rowCount()
                tbl_material.setRowCount(row + 1)

                first_column = QTableWidgetItem(str(roughness))
                first_column.setFlags(Qt.ItemIsEnabled)
                tbl_material.setItem(row, 0, first_column)

                combo_mat = QComboBox()
                tbl_material.setCellWidget(row, 1, combo_mat)

                self.tbl_elements["materials"][roughness] = (combo_mat,)

        # Fill Features table
        tbl_feature: QTableWidget = self.dlg_config.tbl_feature

        feature_types = [
            ("JUNCTIONS", self.catalogs.inp_junctions, ("JUNCTION",), "NODE"),
            ("PIPES", self.catalogs.inp_pipes, ("PIPE",), "ARC"),
            ("PUMPS", self.catalogs.inp_pumps, ("VARC",), "ARC"),
            (
                "RESERVOIRS",
                self.catalogs.inp_reservoirs,
                ("SOURCE", "WATERWELL", "WTP"),
                "NODE",
            ),
            ("TANKS", self.catalogs.inp_tanks, ("TANK",), "NODE"),
            ("VALVES", self.catalogs.inp_valves, ("VARC",), "ARC"),
        ]

        self.tbl_elements["features"] = {}

        for tag, rec_catalog, feature_class, feature_type in feature_types:
            if rec_catalog is None:
                continue

            if tag == "PIPES" and not rec_catalog:
                continue

            row: int = tbl_feature.rowCount()
            tbl_feature.setRowCount(row + 1)

            first_column = QTableWidgetItem(tag)
            first_column.setFlags(Qt.ItemIsEnabled)
            tbl_feature.setItem(row, 0, first_column)

            combo_feat = QComboBox()
            tbl_feature.setCellWidget(row, 1, combo_feat)

            self.tbl_elements["features"][tag.lower()] = (combo_feat,)

        self._fill_combo_boxes()

        tools_gw.open_dialog(self.dlg_config, dlg_name="dlg_inp_config_import")


    def _update_parsing_dialog(self, dialog: GwDialog) -> None:
        if not dialog.isVisible():
            self.timer.stop()
            return

        tools_gw.fill_tab_log(
            dialog,
            {"info": {"values": [{"message": msg} for msg in self.parse_inp_task.log]}},
        )
        self._calculate_elapsed_time(dialog)

        if isdeleted(self.parse_inp_task) or not self.parse_inp_task.isActive():
            self.timer.stop()
            self.dlg_inp_parsing.progressBar.setVisible(False)
