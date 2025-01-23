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
from ....threads.import_inp.import_swmm_task import GwImportInpTask
from ....utils import tools_gw
from ...dialog import GwAction
from ....threads.import_inp import parse_swmm_task

CREATE_NEW = "Create new"
TESTING_MODE = False


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

        # TODO: remove this message once it's not in developement
        msg = "Import INP is still in developement. It may not work as intended yet. Please report any unexpected behaviour to the Giswater team."
        tools_qgis.show_warning(msg, duration=30)

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
        # global Catalogs
        self.catalogs: parse_swmm_task.Catalogs = self.parse_inp_task.catalogs

        # Fill nodes table
        tbl_nodes: QTableWidget = self.dlg_config.tbl_nodes

        node_elements = [
            ("junctions", self.catalogs.inp_junctions, "JUNCTION"),
            ("outfalls", self.catalogs.inp_outfalls, "OUTFALL"),
            ("dividers", self.catalogs.inp_dividers, "DIVIDER"),
            ("storage", self.catalogs.inp_storage, "STORAGE"),
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
        tbl_arcs.setColumnCount(8)
        tbl_arcs.setHorizontalHeaderLabels(["EPA type", "SHAPE", "geom1", "geom2", "geom3", "geom4", "Arc catalog", "New catalog name"])

        if self.catalogs.inp_conduits:
            self.tbl_elements["conduits"] = {}

            for cat_tuple, rec_catalog in self.catalogs.inp_conduits.items():
                row: int = tbl_arcs.rowCount()
                tbl_arcs.setRowCount(row + 1)

                first_column = QTableWidgetItem("CONDUIT")
                first_column.setFlags(Qt.ItemIsEnabled)
                tbl_arcs.setItem(row, 0, first_column)

                for idx, prop in enumerate(cat_tuple):
                    value = str(prop) if prop is not None else ''
                    item = QTableWidgetItem(value)
                    item.setFlags(Qt.ItemIsEnabled)
                    tbl_arcs.setItem(row, idx+1, item)

                combo_cat = QComboBox()
                tbl_arcs.setCellWidget(row, 6, combo_cat)

                new_cat_name = QTableWidgetItem("")
                new_cat_name.setFlags(Qt.NoItemFlags)
                tbl_arcs.setItem(row, 7, new_cat_name)
                combo_cat.currentTextChanged.connect(
                    partial(self._toggle_enabled_new_catalog_field, new_cat_name)
                )

                self.tbl_elements["conduits"][cat_tuple] = (
                    combo_cat,
                    new_cat_name,
                )

        # Fill arcs table with pumps and valves
        arc_elements = [
            ("pumps", self.catalogs.inp_pumps, "PUMP"),
            ("orifices", self.catalogs.inp_orifice, "ORIFICE"),
            ("weirs", self.catalogs.inp_weir, "WEIR"),
            ("outlets", self.catalogs.inp_outlet, "OUTLET"),
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
            tbl_arcs.setCellWidget(row, 6, combo_cat)

            new_cat_name = QTableWidgetItem("")
            new_cat_name.setFlags(Qt.NoItemFlags)
            tbl_arcs.setItem(row, 7, new_cat_name)
            combo_cat.currentTextChanged.connect(
                partial(self._toggle_enabled_new_catalog_field, new_cat_name)
            )

            self.tbl_elements[element] = (combo_cat, new_cat_name)

        # Fill materials table
        tbl_material: QTableWidget = self.dlg_config.tbl_material

        if self.catalogs.roughness_catalog:
            self.tbl_elements["materials"] = {}
            roughnesses = {roughness for roughness in self.catalogs.roughness_catalog}

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
            ("JUNCTIONS", self.catalogs.inp_junctions, ("MANHOLE",), "NODE"),
            ("OUTFALLS", self.catalogs.inp_outfalls, ("MANHOLE",), "NODE"),
            ("DIVIDERS", self.catalogs.inp_dividers, ("MANHOLE",), "NODE"),
            ("STORAGE", self.catalogs.inp_storage, ("STORAGE",), "NODE"),
            ("CONDUITS", self.catalogs.inp_conduits, ("CONDUIT",), "ARC"),
            ("PUMPS", self.catalogs.inp_pumps, ("VARC",), "ARC"),
            ("ORIFICES", self.catalogs.inp_orifice, ("VARC",), "ARC"),
            ("WEIRS", self.catalogs.inp_weir, ("VARC",), "ARC"),
            ("OUTLETS", self.catalogs.inp_outlet, ("VARC",), "ARC"),
        ]

        self.tbl_elements["features"] = {}

        for tag, rec_catalog, feature_class, feature_type in feature_types:
            if rec_catalog is None:
                continue

            if tag == "CONDUITS" and not rec_catalog:
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

        self._manage_widgets_visibility()

        tools_gw.open_dialog(self.dlg_config, dlg_name="dlg_inp_config_import")

    def _manage_widgets_visibility(self):
        # Hide 'Demand dscenario' widget for UD
        tools_qt.set_widget_visible(self.dlg_config, "lbl_dscenario", False)
        tools_qt.set_widget_visible(self.dlg_config, "txt_dscenario", False)

        # Disable the whole dialog if testing mode
        if TESTING_MODE:
            tools_gw.set_tabs_enabled(self.dlg_config)

        # Default raingage widget
        subcatchments = self.catalogs.inp_subcatchments
        print(subcatchments)
        has_empty = any([x[1] for x in subcatchments if x[1] == '*'] if subcatchments else [])
        if not has_empty:
            tools_qt.set_widget_visible(self.dlg_config, 'lbl_raingage', False)
            tools_qt.set_widget_visible(self.dlg_config, 'txt_raingage', False)

    def _importinp_accept(self):
        # Manage force commit mode
        force_commit = tools_qt.is_checked(self.dlg_config, "chk_force_commit")
        if force_commit is None:
            force_commit = False

        if TESTING_MODE:

            # Delete the network before importing
            queries = [
                'SELECT gw_fct_admin_manage_migra($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"action":"TRUE"}, "aux_params":null}}$$);',
                'UPDATE arc SET node_1 = NULL, node_2 = NULL;',
                'DELETE FROM ext_rtc_scada_x_data;',
                'DELETE FROM inp_inflows CASCADE;',
                'DELETE FROM inp_dwf CASCADE;',
                'DELETE FROM connec CASCADE;',
                'DELETE FROM node CASCADE;',
                'DELETE FROM gully CASCADE;',
                'DELETE FROM inp_subcatchment CASCADE;',
                'DELETE FROM raingage CASCADE;',
                'DELETE FROM inp_conduit CASCADE;',
                'DELETE FROM inp_pump CASCADE;',
                'DELETE FROM inp_orifice CASCADE;',
                'DELETE FROM inp_outlet CASCADE;',
                'DELETE FROM inp_outfall CASCADE;',
                'DELETE FROM inp_storage CASCADE;',
                'DELETE FROM inp_curve_value CASCADE;',
                'DELETE FROM inp_curve CASCADE;',
                'DELETE FROM inp_pattern_value CASCADE;',
                'DELETE FROM inp_pattern CASCADE;',
                'DELETE FROM inp_timeseries_value CASCADE;',
                'DELETE FROM inp_timeseries CASCADE;',
                'DELETE FROM inp_controls CASCADE;',
                'DELETE FROM inp_files CASCADE;',
                'DELETE FROM arc CASCADE;',
                "DELETE FROM cat_work WHERE id = 'import_inp_test';",
                "DELETE FROM cat_dscenario WHERE expl_id = 1;",
                "DELETE FROM cat_arc CASCADE;"
                "DELETE FROM cat_material CASCADE;",
                "DELETE FROM sector WHERE sector_id = 1;",
                "DELETE FROM ext_municipality WHERE muni_id = 1;",
                "DELETE FROM exploitation WHERE expl_id = 1;",
                "INSERT INTO cat_material (id, feature_type, n) VALUES ('PVC', '{ARC}', 0.011), ('Brick', '{ARC}', 0.014);",
                "INSERT INTO exploitation (expl_id, name, macroexpl_id, descript, active) VALUES (1, 'expl_1_import_inp_test', 0, 'Created by import inp in TESTING MODE', true);",
                "INSERT INTO ext_municipality (muni_id, name, observ, active) VALUES (1, 'muni_1_import_inp_test', 'Created by import inp in TESTING MODE', true);",
                "INSERT INTO sector (sector_id, name, macrosector_id, descript, active) VALUES (1, 'sector_1_import_inp_test', 0, 'Created by import inp in TESTING MODE', true);"
            ]
            for sql in queries:
                result = tools_db.execute_sql(sql, commit=force_commit)
                if not result:
                    return


            # Set variables
            workcat = "import_inp_test"
            exploitation = 1
            sector = 1
            municipality = 1
            raingage = None
            catalogs = {
                'conduits': {
                    ('CIRCULAR', 0.2, 0.0, 0.0, 0.0): 'CC020',
                    ('CIRCULAR', 0.315, 0.0, 0.0, 0.0): 'CC0315',
                    ('CIRCULAR', 0.4, 0.0, 0.0, 0.0): 'CC040',
                    ('CIRCULAR', 0.6, 0.0, 0.0, 0.0): 'CC060',
                    ('CIRCULAR', 0.8, 0.0, 0.0, 0.0): 'CC080',
                    ('CIRCULAR', 1.0, 0.0, 0.0, 0.0): 'CC100',
                    ('EGG', 1.5, 0.0, 0.0, 0.0): 'EGG150',
                    ('EGG', 1.5, 1.0, 0.0, 0.0): 'EGG150-1',
                    ('FORCE_MAIN', 0.18, 100.0, 0.0, 0.0): 'FM18',
                    ('FORCE_MAIN', 0.25, 100.0, 0.0, 0.0): 'FM25',
                    ('RECT_CLOSED', 1.5, 1.5, 0.0, 0.0): 'RC150',
                    ('RECT_CLOSED', 2.0, 2.0, 0.0, 0.0): 'RC200',
                    ('RECT_OPEN', 1.0, 1.0, 0.0, 0.0): 'RO100',
                    ('RECT_OPEN', 2.0, 2.0, 0.0, 0.0): 'RO200'
                },
                'materials': {
                    0.011: 'PVC',
                    0.014: 'Brick'
                },
                'features': {
                    'junctions': 'CIRC_MANHOLE',
                    'outfalls': 'RECT_MANHOLE',
                    'storage': 'SEWER_STORAGE',
                    'dividers': 'JUNCTION',
                    'conduits': 'CONDUIT',
                    'pumps': 'VARC',
                    'weirs': 'VARC',
                    'orifices': 'VARC',
                    'outlets': 'VARC'
                },
                'junctions': 'C_MANHOLE_100',
                'outfalls': 'R_MANHOLE_100',
                'storage': 'SEW_STORAGE-01',
                'dividers': 'INP-DIVIDER',
                'pumps': 'INP-PUMP',
                'weirs': 'INP-WEIR',
                'orifices': 'INP-ORIFICE',
                'outlets': 'INP-OUTLET'
            }

            # Show tab log
            self.dlg_config.mainTab.setCurrentIndex(self.dlg_config.mainTab.count()-1)

            # Set background task 'Import INP'
            description = "Import INP (TESTING MODE)"
            self.import_inp_task = GwImportInpTask(
                description,
                self.file_path,
                self.parse_inp_task.network,
                workcat,
                exploitation,
                sector,
                municipality,
                raingage,
                catalogs,
                force_commit=force_commit
            )

            # Create timer
            self.t0: float = time()
            self.timer: QTimer = QTimer()
            self.timer.timeout.connect(
                partial(self._update_config_dialog, self.dlg_config)
            )
            self.timer.start(1000)
            self.import_inp_task.message_logged.connect(self._message_logged)
            self.import_inp_task.progress_changed.connect(self._progress_changed)
            self.import_inp_task.taskCompleted.connect(self.timer.stop)

            # Run task
            QgsApplication.taskManager().addTask(self.import_inp_task)
            QgsApplication.taskManager().triggerTask(self.import_inp_task)
            return

        # Workcat
        workcat: str = self.dlg_config.txt_workcat.text().strip()

        if workcat == "":
            message = "Please enter a Workcat_id to proceed with this import."
            tools_qt.show_info_box(message)
            return

        sql: str = "SELECT id FROM cat_work WHERE id = %s"
        row = tools_db.get_row(sql, params=(workcat,))
        if row is not None:
            message = f'The Workcat_id "{workcat}" is already in use. Please enter a different ID.'
            tools_qt.show_info_box(message)
            return

        # Exploitation
        exploitation = tools_qt.get_combo_value(self.dlg_config, "cmb_expl")

        if exploitation == "":
            message = "Please select an exploitation to proceed with this import."
            tools_qt.show_info_box(message)
            return

        # Sector
        sector = tools_qt.get_combo_value(self.dlg_config, "cmb_sector")

        if sector == "":
            message = "Please select a sector to proceed with this import."
            tools_qt.show_info_box(message)
            return

        # Municipality
        municipality = tools_qt.get_combo_value(self.dlg_config, "cmb_muni")

        if municipality == "":
            message = "Please select a municipality to proceed with this import."
            tools_qt.show_info_box(message)
            return

        # Raingage
        raingage = tools_qt.get_text(self.dlg_config, "txt_raingage")

        if self.dlg_config.txt_raingage.isVisible() and raingage in ("", "null", None):
            message = "Please select a default raingage to proceed with this import."
            tools_qt.show_info_box(message)
            return

        # Tables (Arcs and Nodes)
        catalogs = {"conduits": {}, "materials": {}, "features": {}}

        for _input, result in [
            (self.tbl_elements, catalogs),
            (self.tbl_elements["conduits"], catalogs["conduits"]),
            (self.tbl_elements["materials"], catalogs["materials"]),
            (self.tbl_elements["features"], catalogs["features"]),
        ]:
            for element in _input:
                if type(_input[element]) is not tuple:
                    continue

                combo = _input[element][0]
                combo_value = combo.currentText()

                if combo_value == "":
                    message = "Please select a catalog item for all elements in the tabs: Features, Nodes, Arcs, Materials."
                    tools_qt.show_info_box(message)
                    return

                new_catalog = None

                if len(_input[element]) > 1:
                    new_catalog_cell = _input[element][1]
                    new_catalog = new_catalog_cell.text().strip()

                    if combo_value == CREATE_NEW and new_catalog == "":
                        message = f'Please enter a new catalog name when the "{CREATE_NEW}" option is selected.'
                        tools_qt.show_info_box(message)
                        return

                result[element] = (
                    new_catalog if combo_value == CREATE_NEW else combo_value
                )

        # Show tab log
        self.dlg_config.mainTab.setCurrentIndex(self.dlg_config.mainTab.count()-1)

        # Set background task 'Import INP'
        description = "Import INP"
        self.import_inp_task = GwImportInpTask(
            description,
            self.file_path,
            self.parse_inp_task.network,
            workcat,
            exploitation,
            sector,
            municipality,
            raingage,
            catalogs,
            force_commit=force_commit
        )

        # Create timer
        self.t0: float = time()
        self.timer: QTimer = QTimer()
        self.timer.timeout.connect(
            partial(self._update_config_dialog, self.dlg_config)
        )
        self.timer.start(1000)
        self.import_inp_task.message_logged.connect(self._message_logged)
        self.import_inp_task.progress_changed.connect(self._progress_changed)
        self.import_inp_task.taskCompleted.connect(self.timer.stop)

        QgsApplication.taskManager().addTask(self.import_inp_task)
        QgsApplication.taskManager().triggerTask(self.import_inp_task)

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

        # Fill municipality combo
        cmb_muni: QComboBox = self.dlg_config.cmb_muni
        muni_value: str = cmb_muni.currentText()

        rows = tools_db.get_rows("""
            SELECT muni_id, name
            FROM ext_municipality
            WHERE muni_id > 0
        """)
        cmb_muni.clear()
        tools_qt.fill_combo_values(cmb_muni, rows, add_empty=True)
        cmb_muni.setCurrentText(muni_value)

        self.catalogs = Catalogs.from_network_model(self.parse_inp_task.network)

        # Fill nodes and arcs tables
        elements = [
            ("junctions", self.catalogs.inp_junctions, self.catalogs.db_nodes),
            ("outfalls", self.catalogs.inp_outfalls, self.catalogs.db_nodes),
            ("dividers", self.catalogs.inp_dividers, self.catalogs.db_nodes),
            ("storage", self.catalogs.inp_storage, self.catalogs.db_nodes),
            ("conduits", self.catalogs.inp_conduits, self.catalogs.db_arcs),
            ("pumps", self.catalogs.inp_pumps, self.catalogs.db_arcs),
            ("orifices", self.catalogs.inp_orifice, self.catalogs.db_arcs),
            ("weirs", self.catalogs.inp_weir, self.catalogs.db_arcs),
            ("outlets", self.catalogs.inp_outlet, self.catalogs.db_arcs),
        ]

        for element_type, element_catalog, db_catalog in elements:
            if element_type == "conduits":
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

        if self.catalogs.inp_conduits is not None:
            for pipe_type, pipe_catalog in self.catalogs.inp_conduits.items():
                if pipe_type not in self.tbl_elements["conduits"]:
                    continue

                combo: QComboBox = self.tbl_elements["conduits"][pipe_type][0]
                old_value: str = combo.currentText()

                combo.clear()
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

        # Fill materials
        for roughness, (combo,) in self.tbl_elements["materials"].items():
            material_catalog = [
                mat
                for mat, roughnesses in self.catalogs.db_materials.items()
                if roughness == roughnesses
            ]

            old_value: str = combo.currentText()
            combo.clear()
            combo.addItem("")
            if len(material_catalog) > 0:
                combo.insertSeparator(combo.count())
                combo.addItem("Recommended materials:")
                combo.model().item(combo.count() - 1).setEnabled(False)
                combo.addItems(material_catalog)
            if len(self.catalogs.db_materials) > len(material_catalog):
                combo.insertSeparator(combo.count())
                combo.addItem("Other materials:")
                combo.model().item(combo.count() - 1).setEnabled(False)
                combo.addItems(
                    mat
                    for mat in self.catalogs.db_materials
                    if mat not in material_catalog
                )
            combo.setCurrentText(old_value)

        # Fill features
        feature_types = {
            "junctions": ("NODE", ("MANHOLE",)),
            "outfalls": ("NODE", ("MANHOLE",)),
            "dividers": ("NODE", ("MANHOLE",)),
            "storage": ("NODE", ("STORAGE",)),
            "conduits": ("ARC", ("CONDUIT",)),
            "pumps": ("ARC", ("VARC",)),
            "valves": ("ARC", ("VARC",)),
            "orifices": ("ARC", ("VARC",)),
            "weirs": ("ARC", ("VARC",)),
            "outlets": ("ARC", ("VARC",)),
        }
        for element_type, (combo,) in self.tbl_elements["features"].items():
            system_catalog = [
                feat_id
                for feat_id, (feature_class, _) in self.catalogs.db_features.items()
                if feature_class in feature_types[element_type][0]
            ]
            feat_catalog = [
                feat_id
                for feat_id, (_, feat_type) in self.catalogs.db_features.items()
                if feat_type in feature_types[element_type][1]
            ]

            old_value: str = combo.currentText()
            combo.clear()
            combo.addItem("")
            if len(feat_catalog) > 0:
                combo.insertSeparator(combo.count())
                combo.addItem("Recommended feature ids:")
                combo.model().item(combo.count() - 1).setEnabled(False)
                combo.addItems(feat_catalog)
            if len(system_catalog) > len(feat_catalog):
                combo.insertSeparator(combo.count())
                combo.addItem("Other feature ids:")
                combo.model().item(combo.count() - 1).setEnabled(False)
                combo.addItems(
                    feat for feat in system_catalog if feat not in feat_catalog
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

    def _update_config_dialog(self, dialog: GwDialog):
        if not dialog.isVisible():
            self.timer.stop()
            return

        self._calculate_elapsed_time(dialog)

        if isdeleted(self.parse_inp_task) or not self.parse_inp_task.isActive():
            self.timer.stop()
            self.dlg_config.progressBar.setVisible(False)

    def _calculate_elapsed_time(self, dialog: GwDialog) -> None:
        tf: float = time()  # Final time
        td: float = tf - self.t0  # Delta time
        self._update_time_elapsed(f"Exec. time: {timedelta(seconds=round(td))}", dialog)

    def _update_time_elapsed(self, text: str, dialog: GwDialog) -> None:
        lbl_time: QLabel = dialog.findChild(QLabel, "lbl_time")
        lbl_time.setText(text)

    def _message_logged(self, message: str, end: str="\n"):

        print(f"message: {message}")
        data = {"info": {"values": [{"message": message}]}}
        tools_gw.fill_tab_log(self.dlg_config, data, reset_text=True, close=False, end=end, call_set_tabs_enabled=False)

    def _progress_changed(self, process: str, progress: int, text: str, new_line: bool) -> None:
        # Progress bar
        if progress is not None:
            self.dlg_config.progressBar.setValue(progress)

        # TextEdit log
        txt_infolog = self.dlg_config.findChild(QTextEdit, 'txt_infolog')
        cur_text = tools_qt.get_text(self.dlg_config, txt_infolog, return_string_null=False)
        if process and process not in (self.cur_process, "Generate INP algorithm"):
            cur_text = f"{cur_text}\n" \
                       f"--------------------\n" \
                       f"{process}\n" \
                       f"--------------------\n\n"
            self.cur_process = process
            self.cur_text = None

        # Generate INP log is cumulative, so it's saved until the process ends
        if process == "Generate INP algorithm" and not self.cur_text:
            self.cur_text = cur_text

        if self.cur_text:
            cur_text = self.cur_text

        end_line = '\n' if new_line else ''
        txt_infolog.setText(f"{cur_text}{text}{end_line}")
        txt_infolog.show()
        # Scroll to the bottom
        scrollbar = txt_infolog.verticalScrollBar()
        scrollbar.setValue(scrollbar.maximum())
