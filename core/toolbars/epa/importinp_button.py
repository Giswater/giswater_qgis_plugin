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
)
from sip import isdeleted

from .... import global_vars
from ....libs import tools_db, tools_qgis, tools_qt
from ...models.plugin_toolbar import GwPluginToolbar
from ...threads.parse_inp import Catalogs, GwParseInpTask
from ...ui.dialog import GwDialog
from ...ui.ui_manager import GwInpConfigImportUi, GwInpParsingUi
from ...utils import tools_gw
from ..dialog import GwAction

CREATE_NEW = "Create new"


class ProjectType(Enum):
    WS = "ws"
    UD = "ud"


class GwImportInp(GwAction):
    """Button 22: Import INP"""

    def __init__(
        self,
        icon_path: str,
        action_name: str,
        text: str,
        toolbar: GwPluginToolbar,
        action_group: QActionGroup,
    ) -> None:
        super().__init__(icon_path, action_name, text, toolbar, action_group)

    def clicked_event(self) -> None:
        """Start the Import INP workflow"""

        # WS
        if global_vars.project_type == ProjectType.WS.value:
            try:
                import wntr

                file_path: Optional[Path] = self._get_file()

                if not file_path:
                    return

                self.parse_inp_file(file_path)

            except ImportError:
                message: str = "wntr package not installed. Open OSGeo4W Shell and execute 'python -m pip install wntr'."
                tools_qgis.show_message(message)

        # UD
        if global_vars.project_type == ProjectType.UD.value:
            try:
                import swmm_api

                file_path: Optional[Path] = self._get_file()

                if not file_path:
                    return

                self.parse_inp_file(file_path)

            except ImportError:
                message: str = "swmm-api package not installed. Open OSGeo4W Shell and execute 'python -m pip install swmm-api'."
                tools_qgis.show_message(message)

    def parse_inp_file(self, file_path: Path) -> None:
        """Parse INP file, showing a log to the user"""

        # Create and show parsing dialog
        self.dlg_inp_parsing = GwInpParsingUi()
        tools_gw.load_settings(self.dlg_inp_parsing)
        self.dlg_inp_parsing.rejected.connect(
            partial(tools_gw.save_settings, self.dlg_inp_parsing)
        )
        tools_gw.open_dialog(self.dlg_inp_parsing, dlg_name="parse_inp")

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

        self.dlg_config = GwInpConfigImportUi()
        tools_gw.load_settings(self.dlg_config)
        self.dlg_config.rejected.connect(
            partial(tools_gw.save_settings, self.dlg_config)
        )

        # Get catalogs from thread
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
            if rec_catalog is not None:
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

        self._fill_combo_boxes()

        tools_gw.open_dialog(self.dlg_config, dlg_name="dlg_inp_config_import")

    def _fill_combo_boxes(self):
        # Fill exploitation combo
        cmb_expl: QComboBox = self.dlg_config.cmb_expl
        expl_value: str = cmb_expl.currentText()

        rows = tools_db.get_rows("""
            SELECT expl_id, name
            FROM exploitation
            WHERE expl_id > 0
        """)
        cmb_expl.clear()
        tools_qt.fill_combo_values(cmb_expl, rows, add_empty=True)
        cmb_expl.setCurrentText(expl_value)

        # Fill sector combo
        cmb_sector: QComboBox = self.dlg_config.cmb_sector
        sector_value: str = cmb_sector.currentText()

        rows = tools_db.get_rows("""
            SELECT sector_id, name
            FROM sector
            WHERE sector_id > 0
        """)
        cmb_sector.clear()
        tools_qt.fill_combo_values(cmb_sector, rows, add_empty=True)
        cmb_sector.setCurrentText(sector_value)

        elements = [
            ("junctions", self.catalogs.inp_junctions, self.catalogs.db_nodes),
            ("reservoirs", self.catalogs.inp_reservoirs, self.catalogs.db_nodes),
            ("tanks", self.catalogs.inp_tanks, self.catalogs.db_nodes),
            ("pumps", self.catalogs.inp_pumps, self.catalogs.db_arcs),
            ("valves", self.catalogs.inp_valves, self.catalogs.db_arcs),
        ]

        for element_type, element_catalog, db_catalog in elements:
            if element_type == "pipes":
                continue

            if element_type not in self.tbl_elements:
                continue

            combo: QComboBox = self.tbl_elements[element_type][0]
            old_value: str = combo.currentText()

            combo.clear()
            combo.addItems(["", CREATE_NEW])
            if len(element_catalog) > 0:
                combo.insertSeparator(combo.count())
                combo.addItem("Recommended catalogs:")
                combo.model().item(combo.count() - 1).setEnabled(False)
                combo.addItems(element_catalog)
            if len(db_catalog) > len(element_catalog):
                combo.insertSeparator(combo.count())
                combo.addItem("Other catalogs:")
                combo.model().item(combo.count() - 1).setEnabled(False)
                combo.addItems(cat for cat in db_catalog if cat not in element_catalog)
            combo.setCurrentText(old_value)

        if self.catalogs.inp_pipes is not None:
            for pipe_type, pipe_catalog in self.catalogs.inp_pipes.items():
                if pipe_type not in self.tbl_elements["pipes"]:
                    continue

                combo: QComboBox = self.tbl_elements["pipes"][pipe_type][0]
                old_value: str = combo.currentText()

                combo.addItems(["", CREATE_NEW])
                if len(pipe_catalog) > 0:
                    combo.insertSeparator(combo.count())
                    combo.addItem("Recommended catalogs:")
                    combo.model().item(combo.count() - 1).setEnabled(False)
                    combo.addItems(pipe_catalog)
                if len(self.catalogs.db_arcs) > len(pipe_catalog):
                    combo.insertSeparator(combo.count())
                    combo.addItem("Other catalogs:")
                    combo.model().item(combo.count() - 1).setEnabled(False)
                    combo.addItems(
                        cat for cat in self.catalogs.db_arcs if cat not in pipe_catalog
                    )
                    combo.setCurrentText(old_value)

    def _toggle_enabled_new_catalog_field(
        self, field: QTableWidgetItem, text: str
    ) -> None:
        field.setFlags(
            Qt.ItemIsEnabled | Qt.ItemIsEditable
            if text == CREATE_NEW
            else Qt.NoItemFlags
        )

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

    def _calculate_elapsed_time(self, dialog: GwDialog) -> None:
        tf: float = time()  # Final time
        td: float = tf - self.t0  # Delta time
        self._update_time_elapsed(f"Exec. time: {timedelta(seconds=round(td))}", dialog)

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

    def _update_time_elapsed(self, text: str, dialog: GwDialog) -> None:
        lbl_time: QLabel = dialog.findChild(QLabel, "lbl_time")
        lbl_time.setText(text)
