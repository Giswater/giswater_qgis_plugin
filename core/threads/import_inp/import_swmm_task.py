import traceback
from datetime import date
from itertools import count, islice
from typing import Any
from datetime import datetime
from math import isnan

from psycopg2.extras import execute_values

try:
    from swmm_api import SwmmInput
    from swmm_api.input_file.section_labels import (
        OPTIONS, REPORT, FILES,
        JUNCTIONS, OUTFALLS, DIVIDERS, STORAGE,
        CONDUITS, PUMPS, ORIFICES, WEIRS, OUTLETS,
        XSECTIONS, COORDINATES, VERTICES,
        PATTERNS, CURVES, TIMESERIES, CONTROLS, LID_CONTROLS, LID_USAGE,
        LOSSES
    )
    from swmm_api.input_file.sections import (
        Conduit, CrossSection, Pattern, TimeseriesData, TimeseriesFile
    )
except ImportError:
    SwmmInput = None

    OPTIONS, REPORT, FILES = None, None, None
    JUNCTIONS, OUTFALLS, DIVIDERS, STORAGE = None, None, None, None
    CONDUITS, PUMPS, ORIFICES, WEIRS, OUTLETS = None, None, None, None, None
    XSECTIONS, COORDINATES, VERTICES = None, None, None
    PATTERNS, CURVES, TIMESERIES, CONTROLS, LID_CONTROLS, LID_USAGE  = None, None, None, None, None, None
    LOSSES = None

    Conduit, CrossSection, Pattern, TimeseriesData, TimeseriesFile = None, None, None, None, None
    pass

from qgis.PyQt.QtCore import pyqtSignal

from ....libs import lib_vars, tools_db, tools_log
from ...utils import tools_gw
from ..task import GwTask


def lerp_progress(subtask_progress: int, global_min: int, global_max: int) -> int:
    global_progress = global_min + ((subtask_progress - 0) / (100 - 0)) * (global_max - global_min)

    return int(global_progress)


def batched(iterable, n):
    # batched('ABCDEFG', 3) --> ABC DEF G
    if n < 1:
        raise ValueError("n must be at least one")
    it = iter(iterable)
    while batch := tuple(islice(it, n)):
        yield batch


def to_yesno(x: bool):
    return "YES" if x else "NO"


def nan_to_none(x):
    return None if (isinstance(x, float) and isnan(x)) else x


def execute_sql(sql, params=None, /, log_sql=False, **kwargs) -> bool:
    sql = tools_db._get_sql(sql, log_sql, params)
    result: bool = tools_db.execute_sql(
        sql,
        log_sql=log_sql,
        is_thread=True,
        **kwargs,
    )
    if lib_vars.session_vars.get("last_error"):
        raise lib_vars.session_vars["last_error"]
    return result


def get_row(sql, params=None, /, **kwargs):
    result = tools_db.get_row(sql, params=params, is_thread=True, **kwargs)
    if lib_vars.session_vars.get("last_error"):
        raise lib_vars.session_vars["last_error"]
    return result


def get_rows(sql, params=None, /, **kwargs):
    result = tools_db.get_rows(sql, params=params, is_thread=True, **kwargs)
    if lib_vars.session_vars.get("last_error"):
        raise lib_vars.session_vars["last_error"]
    return result


# TODO: refactor into toolsdb and tools_pgdao
def toolsdb_execute_values(
    sql, argslist, template=None, page_size=100, fetch=False, commit=True
):
    if tools_db.dao is None:
        tools_log.log_warning(
            "The connection to the database is broken.", parameter=sql
        )
        return None

    tools_db.dao.last_error = None
    result = None

    try:
        cur = tools_db.dao.get_cursor()
        result = execute_values(cur, sql, argslist, template, page_size, fetch)
        if commit:
            tools_db.dao.commit()
    except Exception as e:
        tools_db.dao.last_error = e
        if commit:
            tools_db.dao.rollback()

    lib_vars.session_vars["last_error"] = tools_db.dao.last_error
    if lib_vars.session_vars.get("last_error"):
        raise lib_vars.session_vars["last_error"]

    return result


def get_geometry_from_link(inp, link) -> str:

    from_node = link.from_node
    if from_node not in inp[COORDINATES]:
        return "null"
    to_node = link.to_node
    if to_node not in inp[COORDINATES]:
        return "null"

    start_node_x, start_node_y = inp[COORDINATES][from_node].x, inp[COORDINATES][from_node].y
    end_node_x, end_node_y = inp[COORDINATES][to_node].x, inp[COORDINATES][to_node].y
    vertices = inp[VERTICES][link.name].vertices if link.name in inp[VERTICES] else []

    coordinates = f"{start_node_x} {start_node_y},"
    for v in vertices:
        coordinates += f"{v[0]} {v[1]},"
    coordinates += f"{end_node_x} {end_node_y}"

    return f"LINESTRING({coordinates})"


class GwImportInpTask(GwTask):

    message_logged = pyqtSignal(str, str)
    progress_changed = pyqtSignal(str, int, str, bool)  # (Process, Progress, Text, '\n')

    # Progress percentages
    PROGRESS_INIT = 0
    PROGRESS_VALIDATE = 5
    PROGRESS_OPTIONS = 10
    PROGRESS_CATALOGS = 30
    PROGRESS_NONVISUAL = 50
    PROGRESS_VISUAL = 90
    PROGRESS_SOURCES = 97
    PROGRESS_END = 100

    def __init__(
        self,
        description: str,
        filepath,
        network,
        workcat,
        exploitation,
        sector,
        municipality,
        catalogs,
    ) -> None:
        super().__init__(description)
        self.filepath = filepath
        self.network: SwmmInput = network
        self.workcat: str = workcat
        self.exploitation: int = exploitation
        self.sector: int = sector
        self.municipality: int = municipality
        self.dscenario_id: int = None
        self.catalogs: dict[str, Any] = catalogs
        self.log: list[str] = []
        self.mappings: dict[str, dict[str, str]] = {"curves": {}, "patterns": {}, "timeseries": {}}
        self.arccat_db: list[str] = []
        self.db_units = None
        self.exception: str = ""

        self.node_ids: dict[str, str] = {}

    def run(self) -> bool:
        super().run()
        try:
            self.progress_changed.emit("Validate inputs", self.PROGRESS_INIT, "Validating inputs...", False)
            self._validate_inputs()
            self.progress_changed.emit("Validate inputs", self.PROGRESS_VALIDATE, "done!", True)

            self.progress_changed.emit("Getting options", self.PROGRESS_VALIDATE, "Importing options...", False)
            self._save_options()
            self.progress_changed.emit("Getting options", self.PROGRESS_OPTIONS, "done!", True)

            if FILES in self.network:
                self.progress_changed.emit("Getting options", self.PROGRESS_VALIDATE, "Importing files...", False)
                self._save_files()
                self.progress_changed.emit("Getting options", self.PROGRESS_OPTIONS, "done!", True)

            # self.progress_changed.emit("Getting options", self.PROGRESS_OPTIONS, "Getting units...", False)
            # self._get_db_units()
            # self.progress_changed.emit("Getting options", self.PROGRESS_OPTIONS, "done!", True)

            self._manage_catalogs()

            self._manage_nonvisual()

            self._manage_visual()

            # self.progress_changed.emit("Sources", self.PROGRESS_VISUAL, "Importing sources...", False)
            # self._save_sources()
            # self.progress_changed.emit("Sources", self.PROGRESS_SOURCES, "done!", True)

            execute_sql("select 1", commit=True)
            self.progress_changed.emit("", self.PROGRESS_END, "ALL DONE! INP successfully imported.", True)
            return True
        except Exception as e:
            self.exception = traceback.format_exc()
            self._log_message(f"{traceback.format_exc()}")
            tools_db.dao.rollback()
            return False

    def _manage_catalogs(self) -> None:
        self.progress_changed.emit("Create catalogs", lerp_progress(0, self.PROGRESS_OPTIONS, self.PROGRESS_CATALOGS), "Creating workcat", True)
        self._create_workcat_id()
        self.progress_changed.emit("Create catalogs", lerp_progress(20, self.PROGRESS_OPTIONS, self.PROGRESS_CATALOGS), "Creating new node catalogs", True)
        self._create_new_node_catalogs()

        # Get existing catalogs in DB
        cat_arc_ids = get_rows("SELECT id FROM cat_arc", commit=False)
        if cat_arc_ids:
            self.arccat_db += [x[0] for x in cat_arc_ids]

        self.progress_changed.emit("Create catalogs", lerp_progress(50, self.PROGRESS_OPTIONS, self.PROGRESS_CATALOGS), "Creating new varc catalogs", True)
        self._create_new_varc_catalogs()
        self.progress_changed.emit("Create catalogs", lerp_progress(70, self.PROGRESS_OPTIONS, self.PROGRESS_CATALOGS), "Creating new pipe catalogs", True)
        self._create_new_conduit_catalogs()

    def _manage_nonvisual(self) -> None:
        if PATTERNS in self.network:
            self.progress_changed.emit("Non-visual objects", lerp_progress(0, self.PROGRESS_CATALOGS, self.PROGRESS_NONVISUAL), "Importing patterns", True)
            self._save_patterns()

        if CURVES in self.network:
            self.progress_changed.emit("Non-visual objects", lerp_progress(40, self.PROGRESS_CATALOGS, self.PROGRESS_NONVISUAL), "Importing curves", True)
            self._save_curves()

        if TIMESERIES in self.network:
            self.progress_changed.emit("Non-visual objects", lerp_progress(60, self.PROGRESS_CATALOGS, self.PROGRESS_NONVISUAL), "Importing timeseries", True)
            self._save_timeseries()

        if CONTROLS in self.network:
            self.progress_changed.emit("Non-visual objects", lerp_progress(80, self.PROGRESS_CATALOGS, self.PROGRESS_NONVISUAL), "Importing controls", True)
            self._save_controls()

        if LID_CONTROLS in self.network:
            self.progress_changed.emit("Non-visual objects", lerp_progress(80, self.PROGRESS_CATALOGS, self.PROGRESS_NONVISUAL), "Importing LIDs", True)
            self._save_lids()

    def _manage_visual(self) -> None:
        self.progress_changed.emit("Visual objects", lerp_progress(0, self.PROGRESS_NONVISUAL, self.PROGRESS_VISUAL), "Importing junctions", True)
        self._save_junctions()

        self.progress_changed.emit("Visual objects", lerp_progress(30, self.PROGRESS_NONVISUAL, self.PROGRESS_VISUAL), "Importing outfalls", True)
        self._save_outfalls()

        self.progress_changed.emit("Visual objects", lerp_progress(40, self.PROGRESS_NONVISUAL, self.PROGRESS_VISUAL), "Importing dividers", True)
        self._save_dividers()

        self.progress_changed.emit("Visual objects", lerp_progress(45, self.PROGRESS_NONVISUAL, self.PROGRESS_VISUAL), "Importing storage units", True)
        self._save_storage()

        self.progress_changed.emit("Visual objects", lerp_progress(50, self.PROGRESS_NONVISUAL, self.PROGRESS_VISUAL), "Importing pumps", True)
        self._save_pumps()

        self.progress_changed.emit("Visual objects", lerp_progress(60, self.PROGRESS_NONVISUAL, self.PROGRESS_VISUAL), "Importing orifices", True)
        self._save_orifices()

        self.progress_changed.emit("Visual objects", lerp_progress(65, self.PROGRESS_NONVISUAL, self.PROGRESS_VISUAL), "Importing weirs", True)
        self._save_weirs()

        self.progress_changed.emit("Visual objects", lerp_progress(70, self.PROGRESS_NONVISUAL, self.PROGRESS_VISUAL), "Importing outlets", True)
        self._save_outlets()

        self.progress_changed.emit("Visual objects", lerp_progress(80, self.PROGRESS_NONVISUAL, self.PROGRESS_VISUAL), "Importing conduits", True)
        self._save_conduits()

    def _get_db_units(self) -> None:
        units_query = "SELECT value FROM vi_options WHERE parameter = 'UNITS'"
        units_row = get_row(units_query, commit=False)
        if not units_row:
            raise ValueError("Units not specified in the Giswater project.")
        self.db_units = units_row[0]

    def _validate_inputs(self) -> None:
        if not self.workcat:
            message = "Please enter a Workcat_id to proceed with this import."
            raise ValueError(message)

        if not self.exploitation:
            message = "Please select an exploitation to proceed with this import."
            raise ValueError(message)

        if not self.sector:
            message = "Please select a sector to proceed with this import."
            raise ValueError(message)

        if not self.municipality:
            message = "Please select a municipality to proceed with this import."
            raise ValueError(message)

    def _save_options(self):
        """
            Import options to table 'config_param_user'.
        """
        params_map = {

        }

        # List to accumulate parameters for batch update
        update_params = []

        options_dict: dict = self.network[OPTIONS]

        # Iterate over each option
        for k, v in options_dict.items():
            parameter = params_map.get(k.lower(), k.lower())
            parameter = f"inp_options_{parameter}"
            value = f"{v}"
            if type(v) is bool:
                value = to_yesno(v)
            update_params.append((value, parameter))

        report_dict: dict = self.network[REPORT]

        # Iterate over each option
        for k, v in report_dict.items():
            parameter = params_map.get(k.lower(), k.lower())
            parameter = f"inp_report_{parameter}"
            value = f"{v}"
            if type(v) is bool:
                value = to_yesno(v)
            update_params.append((value, parameter))

        # SQL query for batch update
        sql = """
            UPDATE config_param_user
            SET value = data.value
            FROM (VALUES %s) AS data(value, parameter)
            WHERE config_param_user.parameter::text = data.parameter::text;
        """
        template = "(%s, %s)"

        print("OPTIONS:")
        print(update_params)

        # Execute batch update
        toolsdb_execute_values(sql, update_params, template, fetch=False, commit=False)

    def _save_files(self):
        """
            Import options to table 'config_param_user'.
        """

        params = []
        for k, v in self.network[FILES].items():
            actio_type, file_type = k.split(' ')[0], k.split(' ')[1]
            fname = v
            params.append((actio_type, file_type, fname))

        # SQL query for batch update
        sql = """
            INSERT INTO inp_files (actio_type, file_type, fname)
            VALUES %s
        """
        template = "(%s, %s, %s)"

        print("FILES:")
        print(params)

        # Execute batch update
        toolsdb_execute_values(sql, params, template, fetch=False, commit=False)

    def _create_workcat_id(self):
        sql = """
            INSERT INTO cat_work (id, descript, builtdate, active)
            VALUES (%s, %s, %s, TRUE)
        """
        description = f"Importing the file {self.filepath.name}"
        builtdate: date = date.today()

        execute_sql(
            sql,
            (self.workcat, description, builtdate),
            commit=False,
        )

    def _create_demand_dscenario(self):
        extras = '"parameters": {'
        extras += '"name": "demands_import_inp",'  # TODO: ask user for name?
        extras += '"descript": "Demand dscenario used when importing INP file",'
        extras += '"parent": null,'
        extras += '"type": "DEMAND",'
        extras += '"active": "true",'
        extras += f'"expl": "{self.exploitation}"'
        extras += '}'
        body = tools_gw.create_body(extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_create_dscenario_empty', body, commit=False, is_thread=True)
        if not json_result or json_result.get('status') != 'Accepted':
            message = "Error executing gw_fct_create_dscenario_empty"
            raise ValueError(message)

        self.dscenario_id = json_result['body']['data'].get('dscenario_id')
        if self.dscenario_id is None:
            message = "Function gw_fct_create_dscenario_empty returned no dscenario_id"
            raise ValueError(message)

    def _create_new_node_catalogs(self):
        cat_node_ids = get_rows("SELECT id FROM cat_node", commit=False)
        nodecat_db: list[str] = []
        if cat_node_ids:
            nodecat_db = [x[0] for x in cat_node_ids]

        node_catalogs = ["junctions", "outfalls", "dividers", "storage"]

        for node_type in node_catalogs:
            if node_type not in self.catalogs:
                continue

            if self.catalogs[node_type] in nodecat_db:
                continue

            nodetype_id: str = self.catalogs["features"][node_type]

            sql = """
                INSERT INTO cat_node (id, node_type)
                VALUES (%s, %s)
            """
            execute_sql(
                sql,
                (self.catalogs[node_type], nodetype_id),
                commit=False,
            )
            nodecat_db.append(self.catalogs[node_type])

    def _create_new_varc_catalogs(self) -> None:
        varc_catalogs: list[str] = ["pumps", "orifices", "weirs", "outlets"]

        for varc_type in varc_catalogs:
            if varc_type not in self.catalogs:
                continue

            if self.catalogs[varc_type] in self.arccat_db:
                continue

            # cat_mat_arc has an INSERT rule.
            # So it's not possible to use ON CONFLICT.
            # So, we perform a conditional INSERT here.
            execute_sql(
                """
                INSERT INTO cat_mat_arc (id, descript, n)
                SELECT 'Unknown', 'Unknown', 0.013
                WHERE NOT EXISTS (
                    SELECT 1
                    FROM cat_mat_arc
                    WHERE id = 'Unknown'
                );
                """,
                commit=False,
            )

            sql = """
                INSERT INTO cat_arc (id, arc_type, shape, geom1)
                VALUES (%s, %s, 'VIRTUAL', 0)
            """
            _id = self.catalogs[varc_type]
            arctype_id = self.catalogs["features"][varc_type]
            execute_sql(sql, (_id, arctype_id), commit=False)
            self.arccat_db.append(_id)

    def _create_new_conduit_catalogs(self):
        if "conduits" in self.catalogs:
            conduit_catalog = self.catalogs["conduits"].items()
            for (shape, geom1, geom2, geom3, geom4), catalog in conduit_catalog:
                if catalog in self.arccat_db:
                    continue

                arctype_id = self.catalogs["features"]["conduits"]

                sql = """
                    INSERT INTO cat_arc (id, arc_type, shape, geom1, geom2, geom3, geom4)
                    VALUES (%s, %s, %s, %s, %s, %s, %s);
                """
                execute_sql(
                    sql, (catalog, arctype_id, shape, geom1, geom2, geom3, geom4), commit=False
                )
                self.arccat_db.append(catalog)

    def _save_patterns(self):
        pattern_rows = get_rows("SELECT pattern_id FROM inp_pattern", commit=False)
        patterns_db: list[str] = []
        if pattern_rows:
            patterns_db = [x[0] for x in pattern_rows]

        for pattern_name, pattern in self.network[PATTERNS].items():
            if pattern_name in patterns_db:
                for i in count(2):
                    new_name = f"{pattern_name}_{i}"
                    if new_name in patterns_db:
                        continue
                    message = f'The pattern "{pattern_name}" has been renamed to "{new_name}" to avoid a collision with an existing pattern.'
                    self._log_message(message)
                    self.mappings["patterns"][pattern_name] = new_name
                    pattern_name = new_name
                    break

            pattern_type = pattern.cycle
            execute_sql(
                "INSERT INTO inp_pattern (pattern_id, pattern_type) VALUES (%s, %s)",
                (pattern_name, pattern_type),
                commit=False,
            )

            fields_str = "pattern_id"
            values_str = "%s"
            values = (pattern_name,)
            for idx, f in enumerate(pattern.factors):
                fields_str += f",factor_{idx+1}"
                values_str += ",%s"
                values += (f,)

            sql = (
                f"INSERT INTO inp_pattern_value ({fields_str}) "
                f"VALUES ({values_str})"
            )
            execute_sql(sql, values, commit=False)

    def _save_curves(self) -> None:
        curve_rows = get_rows("SELECT id FROM inp_curve", commit=False)
        curves_db: set[str] = set()
        if curve_rows:
            curves_db = {x[0] for x in curve_rows}

        for curve_name, curve in self.network[CURVES].items():
            if curve.kind is None:
                message = f'The "{curve_name}" curve does not have a specified curve type and was not imported.'
                self._log_message(message)
                continue

            if curve_name in curves_db:
                for i in count(2):
                    new_name = f"{curve_name}_{i}"
                    if new_name in curves_db:
                        continue
                    message = f'The curve "{curve_name}" has been renamed to "{new_name}" to avoid a collision with an existing curve.'
                    self.mappings["curves"][curve_name] = new_name
                    curve_name = new_name
                    break

            curve_type: str = curve.kind

            execute_sql(
                "INSERT INTO inp_curve (id, curve_type) VALUES (%s, %s)",
                (curve_name, curve_type),
                commit=False,
            )

            for x, y in curve.points:
                execute_sql(
                    "INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES (%s, %s, %s)",
                    (curve_name, x, y),
                    commit=False,
                )

    def _save_timeseries(self) -> None:
        ts_rows = get_rows("SELECT id FROM inp_timeseries", commit=False)
        ts_db: set[str] = set()
        if ts_rows:
            ts_db = {x[0] for x in ts_rows}

        def format_ts(ts_data: tuple) -> tuple:
            ts_data_f = tuple()
            if not ts_data:
                return ts_data_f
            def format_time(time, value) -> tuple:
                if isinstance(time, float):
                    total_minutes = int(time * 60)
                    hh = total_minutes // 60
                    mm = total_minutes % 60
                    return (f"{hh:02}:{mm:02}", value)
                if isinstance(time, datetime):
                    date_str = time.strftime("%m/%d/%Y")
                    time_str = time.strftime("%H:%M")
                    return (f"{date_str}", f"{time_str}", value)
                return tuple()

            ts_data_f = format_time(ts_data[0], ts_data[1])
            return ts_data_f

        for ts_name, ts in self.network[TIMESERIES].items():
            if ts is None:
                message = f'The timeseries "{ts_name}" was not imported.'
                self._log_message(message)
                continue

            if ts_name in ts_db:
                for i in count(2):
                    new_name = f"{ts_name}_{i}"
                    if new_name in ts_db:
                        continue
                    message = f'The curve "{ts_name}" has been renamed to "{new_name}" to avoid a collision with an existing curve.'
                    self.mappings["timeseries"][ts_name] = new_name
                    ts_name = new_name
                    break

            fname = None
            times_type = None
            if type(ts) is TimeseriesFile:  # TODO: import timeseries from file?
                fname = ts.filename
                times_type = "FILE"
            elif type(ts) is TimeseriesData:
                times_type = "ABSOLUTE" if isinstance(ts.data[0][0], datetime) else "RELATIVE"

            execute_sql(
                "INSERT INTO inp_timeseries (id, timser_type, times_type, fname) VALUES (%s, 'Other', %s, %s)",
                (ts_name, times_type, fname),
                commit=False,
            )

            if times_type == "FILE":  # TODO: import timeseries from file?
                continue

            for ts_data in ts.data:
                ts_data_f = format_ts(ts_data)
                if len(ts_data_f) == 2:
                    fields = "timser_id, time, value"
                    values = "%s, %s, %s"
                elif len(ts_data_f) == 3:
                    fields = "timser_id, date, hour, value"
                    values = "%s, %s, %s, %s"
                else:
                    continue

                execute_sql(
                    f"INSERT INTO inp_timeseries_value ({fields}) VALUES ({values})",
                    (ts_name,) + ts_data_f,
                    commit=False,
                )

    def _save_controls(self) -> None:
        controls_rows = get_rows("SELECT text FROM inp_controls", commit=False)
        controls_db: set[str] = set()
        if controls_rows:
            controls_db = {x[0] for x in controls_rows}

        for control_name, control in self.network[CONTROLS].items():
            text = control.to_inp_line()
            if text in controls_db:
                msg = f"The control '{control_name}' is already on database. Skipping..."
                self._log_message(msg)
                continue
            sql = "INSERT INTO inp_controls (sector_id, text, active) VALUES (%s, %s, true)"
            params = (self.sector, text)
            execute_sql(sql, params, commit=False)

    def _save_lids(self) -> None:
        lid_rows = get_rows("SELECT lidco_id FROM inp_lid", commit=False)
        lids_db: set[str] = set()
        if lid_rows:
            lids_db = {x[0] for x in lid_rows}

        for lid_name, lid in self.network[LID_CONTROLS].items():
            if lid_name in lids_db:
                # Manage if lid already exists
                for i in count(2):
                    new_name = f"{lid_name}_{i}"
                    if new_name in lids_db:
                        continue
                    message = f'The curve "{lid_name}" has been renamed to "{new_name}" to avoid a collision with an existing curve.'
                    self.mappings["curves"][lid_name] = new_name
                    lid_name = new_name
                    break

            lid_type: str = lid.lid_kind
            sql = "INSERT INTO inp_lid (lidco_id, lidco_type) VALUES (%s, %s)"
            params = (lid_name, lid_type)
            execute_sql(sql, params, commit=False)

            # Insert lid_values
            sql = """
                INSERT INTO inp_lid_value (lidco_id, lidlayer, value_2, value_3, value_4, value_5, value_6, value_7, value_8)
                VALUES %s
            """
            template = "(%s, %s, %s, %s, %s, %s, %s, %s, %s)"
            params = []
            for k, v in lid.layer_dict.items():
                if k == 'SURFACE':
                    lid_values = (lid_name, k, v.StorHt, v.VegFrac, v.Rough, v.Slope, v.Xslope, None, None)
                elif k == 'SOIL':
                    lid_values = (lid_name, k, v.Thick, v.Por, v.FC, v.WP, v.Ksat, v.Kcoeff, v.Suct)
                elif k == 'PAVEMENT':
                    lid_values = (lid_name, k, v.Thick, v.Vratio, v.FracImp, v.Perm, v.Vclog, v.Treg, v.Freg)
                elif k == 'STORAGE':
                    lid_values = (lid_name, k, v.Height, v.Vratio, v.Seepage, v.Vclog, v.Covrd, None, None)
                elif k == 'DRAIN':
                    lid_values = (lid_name, k, v.Coeff, v.Expon, v.Offset, v.Delay, v.open_level, v.close_level, v.Qcurve)
                elif k == 'DRAINMAT':
                    lid_values = (lid_name, k, v.Thick, v.Vratio, v.Rough, None, None, None, None)
                else:
                    continue
                params.append(lid_values)
            toolsdb_execute_values(sql, params, template, commit=False)

    def _save_junctions(self) -> None:
        feature_class = self.catalogs['features']['junctions']

        node_sql = """ 
            INSERT INTO node (
                the_geom, code, node_type, nodecat_id, epa_type, expl_id, sector_id, muni_id, state, state_type, workcat_id, top_elev, ymax
            ) VALUES %s
            RETURNING node_id, code
        """  # --"depth", arc_id, annotation, observ, "comment", label_x, label_y, label_rotation, staticpressure, feature_type
        node_template = (
            "(ST_SetSRID(ST_Point(%s, %s),%s), %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        )

        man_sql = f"""
            INSERT INTO man_{feature_class.split('_')[-1].lower()} (
                node_id
            ) VALUES %s
        """
        man_template = "(%s)"

        inp_sql = """
            INSERT INTO inp_junction (
                node_id, y0, ysur, apond
            ) VALUES %s
        """  # --outfallparam
        inp_template = (
            "(%s, %s, %s, %s)"
        )

        node_params = []

        inp_dict = {}

        for j_name, j in self.network[JUNCTIONS].items():
            if j_name not in self.network[COORDINATES]:
                self._log_message(f"ERROR: JUNCTION '{j_name}' has no coordinates in [COORDINATES] section.")
                continue
            x, y = self.network[COORDINATES][j_name].x, self.network[COORDINATES][j_name].y
            srid = lib_vars.data_epsg
            node_type = feature_class
            nodecat_id = self.catalogs["junctions"]
            epa_type = "JUNCTION"
            expl_id = self.exploitation
            sector_id = self.sector
            muni_id = self.municipality
            state = 1
            state_type = 2
            workcat_id = self.workcat
            node_params.append(
                (
                    x, y, srid,  # the_geom
                    j_name,  # code
                    node_type,
                    nodecat_id,
                    epa_type,
                    expl_id,
                    sector_id,
                    muni_id,
                    state,
                    state_type,
                    workcat_id,
                    j.elevation,
                    j.depth_max,
                )
            )
            inp_dict[j_name] = {
                "y0": j.depth_init,
                "ysur": j.depth_surcharge,
                "apond": j.area_ponded,
                "outfallparam": None,
            }

        # Insert into parent table
        junctions = toolsdb_execute_values(
            node_sql, node_params, node_template, fetch=True, commit=False
        )
        print(junctions)
        if not junctions:
            self._log_message("Junctions couldn't be inserted!")
            return

        man_params = []
        inp_params = []

        for j in junctions:
            node_id = j[0]
            code = j[1]

            self.node_ids[code] = node_id

            man_params.append(
                (node_id,)
            )

            inp_data = inp_dict[code]
            inp_params.append(
                (node_id, inp_data["y0"], inp_data["ysur"], inp_data["apond"])
            )

        # Insert into inp table
        toolsdb_execute_values(
            inp_sql, inp_params, inp_template, fetch=False, commit=False
        )
        # Insert into man table
        toolsdb_execute_values(
            man_sql, man_params, man_template, fetch=False, commit=False
        )

    def _save_outfalls(self) -> None:
        feature_class = self.catalogs['features']['outfalls']

        node_sql = """ 
            INSERT INTO node (
                the_geom, code, node_type, nodecat_id, epa_type, expl_id, sector_id, muni_id, state, state_type, workcat_id, top_elev
            ) VALUES %s
            RETURNING node_id, code
        """  # --"depth", arc_id, annotation, observ, "comment", label_x, label_y, label_rotation, staticpressure, feature_type
        node_template = (
            "(ST_SetSRID(ST_Point(%s, %s),%s), %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        )

        man_sql = f"""
            INSERT INTO man_{feature_class.split('_')[-1].lower()} (
                node_id
            ) VALUES %s
        """
        man_template = "(%s)"

        inp_sql = """
            INSERT INTO inp_outfall (
                node_id, outfall_type, stage, curve_id, timser_id, gate
            ) VALUES %s
        """  # --pattern_id, peak_factor, source_type, source_quality, source_pattern_id
        inp_template = (
            "(%s, %s, %s, %s, %s, %s)"
        )

        node_params = []

        inp_dict = {}

        for o_name, o in self.network[OUTFALLS].items():
            if o_name not in self.network[COORDINATES]:
                self._log_message(f"ERROR: OUTFALL '{o_name}' has no coordinates in [COORDINATES] section.")
                continue
            x, y = self.network[COORDINATES][o_name].x, self.network[COORDINATES][o_name].y
            srid = lib_vars.data_epsg
            nodecat_id = self.catalogs["outfalls"]
            epa_type = "OUTFALL"
            expl_id = self.exploitation
            sector_id = self.sector
            muni_id = self.municipality
            state = 1
            state_type = 2
            workcat_id = self.workcat
            elevation = o.elevation
            node_params.append(
                (
                    x, y, srid,  # the_geom
                    o_name,  # code
                    feature_class,
                    nodecat_id,
                    epa_type,
                    expl_id,
                    sector_id,
                    muni_id,
                    state,
                    state_type,
                    workcat_id,
                    elevation
                )
            )
            inp_dict[o_name] = {
                "outfall_type": o.kind,
                "stage": o.data if o.kind == 'FIXED' else None,
                "curve_id": o.data if o.kind == 'TIDAL' else None,
                "timser_id": o.data if o.kind == 'TIMESERIES' else None,
                "gate": to_yesno(o.has_flap_gate)
            }

        # Insert into parent table
        outfalls = toolsdb_execute_values(
            node_sql, node_params, node_template, fetch=True, commit=False
        )
        print(outfalls)
        if not outfalls:
            self._log_message("Outfalls couldn't be inserted!")
            return

        man_params = []
        inp_params = []

        for o in outfalls:
            node_id = o[0]
            code = o[1]

            self.node_ids[code] = node_id

            man_params.append(
                (node_id,)
            )

            inp_data = inp_dict[code]
            inp_params.append(
                (node_id, inp_data["outfall_type"], inp_data["stage"], inp_data["curve_id"], inp_data["timser_id"], inp_data["gate"])
            )

        # Insert into inp table
        toolsdb_execute_values(
            inp_sql, inp_params, inp_template, fetch=False, commit=False
        )
        # Insert into man table
        toolsdb_execute_values(
            man_sql, man_params, man_template, fetch=False, commit=False
        )

    def _save_dividers(self) -> None:
        feature_class = self.catalogs['features']['dividers']

        node_sql = """ 
            INSERT INTO node (
                the_geom, code, node_type, nodecat_id, epa_type, expl_id, sector_id, muni_id, state, state_type, workcat_id, top_elev
            ) VALUES %s
            RETURNING node_id, code
        """  # --"depth", arc_id, annotation, observ, "comment", label_x, label_y, label_rotation, staticpressure, feature_type
        node_template = (
            "(ST_SetSRID(ST_Point(%s, %s),%s), %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        )

        man_sql = f"""
            INSERT INTO man_{feature_class.split('_')[-1].lower()} (
                node_id
            ) VALUES %s
        """
        man_template = "(%s)"

        inp_sql = """
            INSERT INTO inp_divider (
                node_id, divider_type, arc_id, curve_id, qmin, ht, cd, y0, ysur, apond
            ) VALUES %s
        """  # --
        inp_template = (
            "(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        )

        node_params = []

        inp_dict = {}

        for d_name, d in self.network[DIVIDERS].items():
            if d_name not in self.network[COORDINATES]:
                self._log_message(f"ERROR: DIVIDER '{d_name}' has no coordinates in [COORDINATES] section.")
                continue
            x, y = self.network[COORDINATES][d_name].x, self.network[COORDINATES][d_name].y
            srid = lib_vars.data_epsg
            nodecat_id = self.catalogs["dividers"]
            epa_type = "DIVIDER"
            expl_id = self.exploitation
            sector_id = self.sector
            muni_id = self.municipality
            state = 1
            state_type = 2
            workcat_id = self.workcat
            elevation = d.elevation
            node_params.append(
                (
                    x, y, srid,  # the_geom
                    d_name,  # code
                    feature_class,
                    nodecat_id,
                    epa_type,
                    expl_id,
                    sector_id,
                    muni_id,
                    state,
                    state_type,
                    workcat_id,
                    elevation,
                )
            )
            inp_dict[d_name] = {
                "divider_type": d.kind,
                "arc_id": d.link,
                "curve_id": d.data if d.kind == "TABULAR" else None,
                "qmin": (d.data[0] if isinstance(d.data, tuple) else d.data) if d.kind in ("WEIR", "CUTOFF") else None,
                "ht": d.data[1] if d.kind == "WEIR" else None,
                "cd": d.data[2] if d.kind == "WEIR" else None,
                "y0": d.depth_init,
                "ysur": d.depth_surcharge,
                "apond": d.area_ponded,
            }

        # Insert into parent table
        dividers = toolsdb_execute_values(
            node_sql, node_params, node_template, fetch=True, commit=False
        )
        print(dividers)
        if not dividers:
            self._log_message("Dividers couldn't be inserted!")
            return

        man_params = []
        inp_params = []

        for d in dividers:
            node_id = d[0]
            code = d[1]

            self.node_ids[code] = node_id

            man_params.append(
                (node_id,)
            )

            inp_data = inp_dict[code]
            inp_params.append(
                (node_id, inp_data["divider_type"], inp_data["arc_id"], inp_data["curve_id"],
                 inp_data["qmin"], inp_data["ht"], inp_data["cd"], inp_data["y0"], inp_data["ysur"], inp_data["apond"])
            )

        # Insert into inp table
        toolsdb_execute_values(
            inp_sql, inp_params, inp_template, fetch=False, commit=False
        )
        # Insert into man table
        toolsdb_execute_values(
            man_sql, man_params, man_template, fetch=False, commit=False
        )

    def _save_storage(self) -> None:
        feature_class = self.catalogs['features']['storage']

        node_sql = """ 
            INSERT INTO node (
                the_geom, code, node_type, nodecat_id, epa_type, expl_id, sector_id, muni_id, state, state_type, workcat_id, top_elev
            ) VALUES %s
            RETURNING node_id, code
        """  # --"depth", arc_id, annotation, observ, "comment", label_x, label_y, label_rotation, staticpressure, feature_type
        node_template = (
            "(ST_SetSRID(ST_Point(%s, %s),%s), %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        )

        man_sql = f"""
            INSERT INTO man_{feature_class.split('_')[-1].lower()} (
                node_id
            ) VALUES %s
        """
        man_template = "(%s)"

        inp_sql = """
            INSERT INTO inp_storage (
                node_id, storage_type, curve_id, a1, a2, a0, fevap, sh, hc, imd, y0, ysur, apond
            ) VALUES %s
        """  # --
        inp_template = (
            "(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        )

        node_params = []

        inp_dict = {}

        for s_name, s in self.network[STORAGE].items():
            if s_name not in self.network[COORDINATES]:
                self._log_message(f"ERROR: STORAGE '{s_name}' has no coordinates in [COORDINATES] section.")
                continue
            x, y = self.network[COORDINATES][s_name].x, self.network[COORDINATES][s_name].y
            srid = lib_vars.data_epsg
            nodecat_id = self.catalogs["storage"]
            epa_type = "STORAGE"
            expl_id = self.exploitation
            sector_id = self.sector
            muni_id = self.municipality
            state = 1
            state_type = 2
            workcat_id = self.workcat
            elevation = s.elevation
            node_params.append(
                (
                    x, y, srid,  # the_geom
                    s_name,  # code
                    feature_class,
                    nodecat_id,
                    epa_type,
                    expl_id,
                    sector_id,
                    muni_id,
                    state,
                    state_type,
                    workcat_id,
                    elevation,
                )
            )
            inp_dict[s_name] = {
                "storage_type": s.kind,
                "curve_id": s.data if s.kind == "TABULAR" else None,
                "a1": s.data[0] if s.kind == "FUNCTIONAL" else None,
                "a2": s.data[1] if s.kind == "FUNCTIONAL" else None,
                "a0": s.data[2] if s.kind == "FUNCTIONAL" else None,
                "fevap": s.frac_evaporation,
                "sh": s.suction_head,
                "hc": s.hydraulic_conductivity,
                "imd": s.moisture_deficit_init,
                "y0": s.depth_init,
                "ysur": s.depth_surcharge,
                "apond": None,
            }

        # Insert into parent table
        storage = toolsdb_execute_values(
            node_sql, node_params, node_template, fetch=True, commit=False
        )
        print(storage)
        if not storage:
            self._log_message("Dividers couldn't be inserted!")
            return

        man_params = []
        inp_params = []

        for s in storage:
            node_id = s[0]
            code = s[1]

            self.node_ids[code] = node_id

            man_params.append(
                (node_id,)
            )

            inp_data = inp_dict[code]
            inp_params.append(
                (node_id, inp_data["storage_type"], inp_data["curve_id"], inp_data["a1"], inp_data["a2"], inp_data["a0"],
                 inp_data["fevap"], inp_data["sh"], inp_data["hc"], inp_data["imd"], inp_data["y0"], inp_data["ysur"],
                 inp_data["apond"])
            )

        # Insert into inp table
        toolsdb_execute_values(
            inp_sql, inp_params, inp_template, fetch=False, commit=False
        )
        # Insert into man table
        toolsdb_execute_values(
            man_sql, man_params, man_template, fetch=False, commit=False
        )

    def _save_pumps(self) -> None:
        feature_class = self.catalogs['features']['pumps']

        arc_sql = """ 
            INSERT INTO arc (
                the_geom, code, node_1, node_2, arc_type, arccat_id, epa_type, expl_id, sector_id, muni_id, state, state_type, workcat_id, dma_id
            ) VALUES %s
            RETURNING arc_id, code
        """  # --"depth", arc_id, annotation, observ, "comment", label_x, label_y, label_rotation, staticpressure, feature_type
        arc_template = (
            "(ST_GeomFromText(%s, %s), %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, 0)"
        )

        man_sql = f"""
            INSERT INTO man_{feature_class.lower()} (
                arc_id
            ) VALUES %s
        """
        man_template = "(%s)"

        inp_sql = """
            INSERT INTO inp_pump (
                arc_id, curve_id, status, startup, shutoff
            ) VALUES %s
        """  # --
        inp_template = (
            "(%s, %s, %s, %s, %s)"
        )

        arc_params = []

        inp_dict = {}

        for p_name, p in self.network[PUMPS].items():
            geometry = get_geometry_from_link(self.network, p)

            srid = lib_vars.data_epsg
            try:
                node_1 = self.node_ids[p.from_node]
                node_2 = self.node_ids[p.to_node]
            except KeyError as e:
                self._log_message(f"Node not found: {e}")
                continue
            arccat_id = self.catalogs["pumps"]
            epa_type = "PUMP"
            expl_id = self.exploitation
            sector_id = self.sector
            muni_id = self.municipality
            state = 1
            state_type = 2
            workcat_id = self.workcat
            arc_params.append(
                (
                    geometry, srid,  # the_geom
                    p_name,  # code
                    node_1,
                    node_2,
                    feature_class,
                    arccat_id,
                    epa_type,
                    expl_id,
                    sector_id,
                    muni_id,
                    state,
                    state_type,
                    workcat_id,
                )
            )
            inp_dict[p_name] = {
                "curve_id": p.curve_name,
                "status": p.status,
                "startup": p.depth_on,
                "shutoff": p.depth_off,
            }

        # Insert into parent table
        pumps = toolsdb_execute_values(
            arc_sql, arc_params, arc_template, fetch=True, commit=False
        )
        print(pumps)
        if not pumps:
            self._log_message("Pumps couldn't be inserted!")
            return

        man_params = []
        inp_params = []

        for p in pumps:
            arc_id = p[0]
            code = p[1]
            man_params.append(
                (arc_id,)
            )

            inp_data = inp_dict[code]
            inp_params.append(
                (arc_id, inp_data["curve_id"], inp_data["status"], inp_data["startup"], inp_data["shutoff"])
            )

        # Insert into inp table
        toolsdb_execute_values(
            inp_sql, inp_params, inp_template, fetch=False, commit=False
        )
        # Insert into man table
        toolsdb_execute_values(
            man_sql, man_params, man_template, fetch=False, commit=False
        )

    def _save_orifices(self) -> None:
        feature_class = self.catalogs['features']['orifices']

        arc_sql = """ 
            INSERT INTO arc (
                the_geom, code, node_1, node_2, arc_type, arccat_id, epa_type, expl_id, sector_id, muni_id, state, state_type, workcat_id, dma_id
            ) VALUES %s
            RETURNING arc_id, code
        """  # --"depth", arc_id, annotation, observ, "comment", label_x, label_y, label_rotation, staticpressure, feature_type
        arc_template = (
            "(ST_GeomFromText(%s, %s), %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, 0)"
        )

        man_sql = f"""
            INSERT INTO man_{feature_class.lower()} (
                arc_id
            ) VALUES %s
        """
        man_template = "(%s)"

        inp_sql = """
            INSERT INTO inp_orifice (
                arc_id, ori_type, offsetval, cd, orate, flap, shape, geom1, geom2, geom3, geom4, close_time
            ) VALUES %s
        """  # --
        inp_template = (
            "(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        )

        arc_params = []

        inp_dict = {}

        for o_name, o in self.network[ORIFICES].items():
            geometry = get_geometry_from_link(self.network, o)

            srid = lib_vars.data_epsg
            try:
                node_1 = self.node_ids[o.from_node]
                node_2 = self.node_ids[o.to_node]
            except KeyError as e:
                self._log_message(f"Node not found: {e}")
                continue
            xs = self.network[XSECTIONS][o_name]
            arccat_id = self.catalogs["orifices"]
            epa_type = "ORIFICE"
            expl_id = self.exploitation
            sector_id = self.sector
            muni_id = self.municipality
            state = 1
            state_type = 2
            workcat_id = self.workcat
            arc_params.append(
                (
                    geometry, srid,  # the_geom
                    o_name,  # code
                    node_1,
                    node_2,
                    feature_class,
                    arccat_id,
                    epa_type,
                    expl_id,
                    sector_id,
                    muni_id,
                    state,
                    state_type,
                    workcat_id,
                )
            )
            inp_dict[o_name] = {
                "ori_type": o.orientation,
                "offsetval": o.offset,
                "cd": o.discharge_coefficient,
                "orate": o.hours_to_open,
                "flap": to_yesno(o.has_flap_gate),
                "shape": xs.shape,
                "geom1": xs.height,
                "geom2": xs.parameter_2,
                "geom3": xs.parameter_3,
                "geom4": xs.parameter_4,
                "close_time": None,
            }

        # Insert into parent table
        orifices = toolsdb_execute_values(
            arc_sql, arc_params, arc_template, fetch=True, commit=False
        )
        print(orifices)
        if not orifices:
            self._log_message("Orifices couldn't be inserted!")
            return

        man_params = []
        inp_params = []

        for o in orifices:
            arc_id = o[0]
            code = o[1]
            man_params.append(
                (arc_id,)
            )

            inp_data = inp_dict[code]
            inp_params.append(
                (arc_id, inp_data["ori_type"], inp_data["offsetval"], inp_data["cd"], inp_data["orate"], inp_data["flap"],
                 inp_data["shape"], inp_data["geom1"], inp_data["geom2"], inp_data["geom3"], inp_data["geom4"],
                 inp_data["close_time"],
                )
            )

        # Insert into inp table
        toolsdb_execute_values(
            inp_sql, inp_params, inp_template, fetch=False, commit=False
        )
        # Insert into man table
        toolsdb_execute_values(
            man_sql, man_params, man_template, fetch=False, commit=False
        )

    def _save_weirs(self) -> None:
        feature_class = self.catalogs['features']['weirs']

        arc_sql = """ 
            INSERT INTO arc (
                the_geom, code, node_1, node_2, arc_type, arccat_id, epa_type, expl_id, sector_id, muni_id, state, state_type, workcat_id, dma_id
            ) VALUES %s
            RETURNING arc_id, code
        """  # --"depth", arc_id, annotation, observ, "comment", label_x, label_y, label_rotation, staticpressure, feature_type
        arc_template = (
            "(ST_GeomFromText(%s, %s), %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, 0)"
        )

        man_sql = f"""
            INSERT INTO man_{feature_class.lower()} (
                arc_id
            ) VALUES %s
        """
        man_template = "(%s)"

        inp_sql = """
            INSERT INTO inp_weir (
                arc_id, weir_type, offsetval, cd, ec, cd2, flap, geom1, geom2, geom3, geom4, surcharge, road_width, road_surf, coef_curve
            ) VALUES %s
        """  # --
        inp_template = (
            "(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        )

        arc_params = []

        inp_dict = {}

        for w_name, w in self.network[WEIRS].items():
            geometry = get_geometry_from_link(self.network, w)

            srid = lib_vars.data_epsg
            try:
                node_1 = self.node_ids[w.from_node]
                node_2 = self.node_ids[w.to_node]
            except KeyError as e:
                self._log_message(f"Node not found: {e}")
                continue
            xs = self.network[XSECTIONS][w_name]
            arccat_id = self.catalogs["weirs"]
            epa_type = "WEIR"
            expl_id = self.exploitation
            sector_id = self.sector
            muni_id = self.municipality
            state = 1
            state_type = 2
            workcat_id = self.workcat
            arc_params.append(
                (
                    geometry, srid,  # the_geom
                    w_name,  # code
                    node_1,
                    node_2,
                    feature_class,
                    arccat_id,
                    epa_type,
                    expl_id,
                    sector_id,
                    muni_id,
                    state,
                    state_type,
                    workcat_id,
                )
            )
            inp_dict[w_name] = {
                "weir_type": w.form,
                "offsetval": w.height_crest,
                "cd": w.discharge_coefficient,
                "ec": w.n_end_contractions,
                "cd2": w.discharge_coefficient_end,
                "flap": to_yesno(w.has_flap_gate),
                "geom1": xs.height,
                "geom2": xs.parameter_2,
                "geom3": xs.parameter_3,
                "geom4": xs.parameter_4,
                "surcharge": to_yesno(w.can_surcharge),
                "road_width": nan_to_none(w.road_width),
                "road_surf": nan_to_none(w.road_surface),
                "coef_curve": nan_to_none(w.coefficient_curve),
            }

        # Insert into parent table
        weirs = toolsdb_execute_values(
            arc_sql, arc_params, arc_template, fetch=True, commit=False
        )
        print(weirs)
        if not weirs:
            self._log_message("Weirs couldn't be inserted!")
            return

        man_params = []
        inp_params = []

        for w in weirs:
            arc_id = w[0]
            code = w[1]
            man_params.append(
                (arc_id,)
            )

            inp_data = inp_dict[code]
            inp_params.append(
                (arc_id, inp_data["weir_type"], inp_data["offsetval"], inp_data["cd"], inp_data["ec"], inp_data["cd2"],
                 inp_data["flap"], inp_data["geom1"], inp_data["geom2"], inp_data["geom3"], inp_data["geom4"],
                 inp_data["surcharge"], inp_data["road_width"], inp_data["road_surf"], inp_data["coef_curve"],
                )
            )

        # Insert into inp table
        toolsdb_execute_values(
            inp_sql, inp_params, inp_template, fetch=False, commit=False
        )
        # Insert into man table
        toolsdb_execute_values(
            man_sql, man_params, man_template, fetch=False, commit=False
        )

    def _save_outlets(self) -> None:
        feature_class = self.catalogs['features']['outlets']

        arc_sql = """ 
            INSERT INTO arc (
                the_geom, code, node_1, node_2, arc_type, arccat_id, epa_type, expl_id, sector_id, muni_id, state, state_type, workcat_id, dma_id
            ) VALUES %s
            RETURNING arc_id, code
        """  # --"depth", arc_id, annotation, observ, "comment", label_x, label_y, label_rotation, staticpressure, feature_type
        arc_template = (
            "(ST_GeomFromText(%s, %s), %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, 0)"
        )

        man_sql = f"""
            INSERT INTO man_{feature_class.lower()} (
                arc_id
            ) VALUES %s
        """
        man_template = "(%s)"

        inp_sql = """
            INSERT INTO inp_outlet (
                arc_id, outlet_type, offsetval, curve_id, cd1, cd2, flap
            ) VALUES %s
        """  # --
        inp_template = (
            "(%s, %s, %s, %s, %s, %s, %s)"
        )

        arc_params = []

        inp_dict = {}

        for o_name, o in self.network[OUTLETS].items():
            geometry = get_geometry_from_link(self.network, o)

            srid = lib_vars.data_epsg
            try:
                node_1 = self.node_ids[o.from_node]
                node_2 = self.node_ids[o.to_node]
            except KeyError as e:
                self._log_message(f"Node not found: {e}")
                continue
            arccat_id = self.catalogs["outlets"]
            epa_type = "OUTLET"
            expl_id = self.exploitation
            sector_id = self.sector
            muni_id = self.municipality
            state = 1
            state_type = 2
            workcat_id = self.workcat
            arc_params.append(
                (
                    geometry, srid,  # the_geom
                    o_name,  # code
                    node_1,
                    node_2,
                    feature_class,
                    arccat_id,
                    epa_type,
                    expl_id,
                    sector_id,
                    muni_id,
                    state,
                    state_type,
                    workcat_id,
                )
            )
            inp_dict[o_name] = {
                "outlet_type": o.curve_type,
                "offsetval": o.offset,
                "curve_id": o.curve_description if o.curve_type in ("TABULAR/DEPTH", "TABULAR/HEAD") else None,  # TODO: use enum
                "cd1": o.curve_description[0] if o.curve_type in ("FUNCTIONAL/DEPTH", "FUNCTIONAL/HEAD") else None,
                "cd2": o.curve_description[1] if o.curve_type in ("FUNCTIONAL/DEPTH", "FUNCTIONAL/HEAD") else None,
                "flap": to_yesno(o.has_flap_gate),
            }

        # Insert into parent table
        outlets = toolsdb_execute_values(
            arc_sql, arc_params, arc_template, fetch=True, commit=False
        )
        print(outlets)
        if not outlets:
            self._log_message("Outlets couldn't be inserted!")
            return

        man_params = []
        inp_params = []

        for o in outlets:
            arc_id = o[0]
            code = o[1]
            man_params.append(
                (arc_id,)
            )

            inp_data = inp_dict[code]
            inp_params.append(
                (arc_id, inp_data["outlet_type"], inp_data["offsetval"], inp_data["curve_id"],
                 inp_data["cd1"], inp_data["cd2"], inp_data["flap"],
                )
            )

        # Insert into inp table
        toolsdb_execute_values(
            inp_sql, inp_params, inp_template, fetch=False, commit=False
        )
        # Insert into man table
        toolsdb_execute_values(
            man_sql, man_params, man_template, fetch=False, commit=False
        )

    def _save_conduits(self) -> None:
        feature_class = self.catalogs['features']['conduits']
        # TODO: get rid of dma_id
        arc_sql = """ 
            INSERT INTO arc (
                the_geom, code, node_1, node_2, arc_type, arccat_id, epa_type, expl_id, sector_id, muni_id, state, state_type, workcat_id, dma_id
            ) VALUES %s
            RETURNING arc_id, code
        """  # --"depth", arc_id, annotation, observ, "comment", label_x, label_y, label_rotation, staticpressure, feature_type
        arc_template = (
            "(ST_GeomFromText(%s, %s), %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        )

        man_sql = f"""
            INSERT INTO man_{feature_class.split('_')[-1].lower()} (
                arc_id
            ) VALUES %s
        """
        man_template = "(%s)"

        inp_sql = """
            INSERT INTO inp_conduit (
                arc_id, barrels, culvert, kentry, kexit, kavg, flap, q0, qmax, seepage, custom_n
            ) VALUES %s
        """  # --
        inp_template = (
            "(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        )

        arc_params = []

        inp_dict = {}

        for c_name, c in self.network[CONDUITS].items():
            geometry = get_geometry_from_link(self.network, c)

            srid = lib_vars.data_epsg
            try:
                node_1 = self.node_ids[c.from_node]
                node_2 = self.node_ids[c.to_node]
            except KeyError as e:
                self._log_message(f"Node not found: {e}")
                continue
            xs = self.network[XSECTIONS][c_name]
            arccat_id = self.catalogs["conduits"][(xs.shape, xs.height, xs.parameter_2, xs.parameter_3, xs.parameter_4)]
            epa_type = "CONDUIT"
            expl_id = self.exploitation
            sector_id = self.sector
            muni_id = self.municipality
            state = 1
            state_type = 2
            workcat_id = self.workcat
            dma_id = 0  # TODO: get rid of dma_id
            arc_params.append(
                (
                    geometry,
                    srid,
                    c_name,
                    node_1,
                    node_2,
                    feature_class,
                    arccat_id,
                    epa_type,
                    expl_id,
                    sector_id,
                    muni_id,
                    state,
                    state_type,
                    workcat_id,
                    dma_id,  # TODO: get rid of dma_id
                )
            )
            inp_dict[c_name] = {
                "barrels": xs.n_barrels,
                "culvert": nan_to_none(xs.culvert),
                "kentry": None,
                "kexit": None,
                "kavg": None,
                "flap": None,
                "q0": c.flow_initial,
                "qmax": nan_to_none(c.flow_max),
                "seepage": None,
                "custom_n": None,
            }
            if c_name in self.network[LOSSES]:
                loss = self.network[LOSSES][c_name]
                inp_dict[c_name]["kentry"] = loss.entrance
                inp_dict[c_name]["kexit"] = loss.exit
                inp_dict[c_name]["kavg"] = loss.average
                inp_dict[c_name]["flap"] = to_yesno(loss.has_flap_gate)
                inp_dict[c_name]["seepage"] = loss.seepage_rate

        # Insert into parent table
        conduits = toolsdb_execute_values(
            arc_sql, arc_params, arc_template, fetch=True, commit=False
        )
        print(conduits)
        if not conduits:
            self._log_message("Conduits couldn't be inserted!")
            return

        man_params = []
        inp_params = []

        for c in conduits:
            arc_id = c[0]
            code = c[1]
            man_params.append(
                (arc_id,)
            )

            inp_data = inp_dict[code]
            inp_params.append(
                (arc_id, inp_data["barrels"], inp_data["culvert"], inp_data["kentry"], inp_data["kexit"], inp_data["kavg"],
                 inp_data["flap"], inp_data["q0"], inp_data["qmax"], inp_data["seepage"], inp_data["custom_n"],
                 )
            )

        # Insert into inp table
        toolsdb_execute_values(
            inp_sql, inp_params, inp_template, fetch=False, commit=False
        )
        # Insert into man table
        toolsdb_execute_values(
            man_sql, man_params, man_template, fetch=False, commit=False
        )

    def _save_sources(self):
        for s_name, s in self.network.sources():
            # Get source properties
            node_name = s.node_name
            source_type = s.source_type
            source_quality = s.strength_timeseries.base_value
            source_pattern_id = s.strength_timeseries.pattern_name

            # Get node_id & epa_type of related node
            sql = """
                SELECT node_id, epa_type FROM node WHERE code = %s
            """
            params = (node_name,)
            row = get_row(sql, params)
            if not row:
                self._log_message(f"Couldn't find node '{node_name}' for source '{s_name}'.")
                continue
            node_id, epa_type = row

            # Update source columns
            sql = f"""
                UPDATE inp_{epa_type.lower()} 
                SET source_type = %s, source_quality = %s, source_pattern_id = %s 
                WHERE node_id = %s;
            """
            params = (source_type, source_quality, source_pattern_id, node_id)
            execute_sql(sql, params)

    def _log_message(self, message: str):
        self.log.append(message)
        self.progress_changed.emit("", None, f"{message}", True)
