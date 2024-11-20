import traceback
from datetime import date
from itertools import count, islice
from typing import Any
from datetime import datetime

from psycopg2.extras import execute_values

try:
    from swmm_api import SwmmInput
    from swmm_api.input_file.section_labels import (
        OPTIONS, REPORT,
        JUNCTIONS, OUTFALLS, DIVIDERS, STORAGE,
        CONDUITS, PUMPS, ORIFICES, WEIRS, OUTLETS,
        XSECTIONS,
        PATTERNS, CURVES, TIMESERIES
    )
    from swmm_api.input_file.sections import (
        Conduit, CrossSection, Pattern, TimeseriesData, TimeseriesFile
    )
except ImportError:
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


def get_geometry_from_link(link) -> str:

    start_node_x, start_node_y = link.start_node.coordinates
    end_node_x, end_node_y = link.end_node.coordinates
    vertices = link.vertices

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

            # self.progress_changed.emit("Getting options", self.PROGRESS_OPTIONS, "Getting units...", False)
            # self._get_db_units()
            # self.progress_changed.emit("Getting options", self.PROGRESS_OPTIONS, "done!", True)

            self._manage_catalogs()

            self._manage_nonvisual()

            # self._manage_visual()

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
        self.progress_changed.emit("Non-visual objects", lerp_progress(0, self.PROGRESS_CATALOGS, self.PROGRESS_NONVISUAL), "Importing patterns", True)
        self._save_patterns()

        self.progress_changed.emit("Non-visual objects", lerp_progress(40, self.PROGRESS_CATALOGS, self.PROGRESS_NONVISUAL), "Importing curves", True)
        self._save_curves()

        self.progress_changed.emit("Non-visual objects", lerp_progress(60, self.PROGRESS_CATALOGS, self.PROGRESS_NONVISUAL), "Importing timeseries", True)
        self._save_timeseries()

        # self.progress_changed.emit("Non-visual objects", lerp_progress(80, self.PROGRESS_CATALOGS, self.PROGRESS_NONVISUAL), "Importing controls and rules", True)
        # self._save_controls_and_rules()

    def _manage_visual(self) -> None:
        self.progress_changed.emit("Visual objects", lerp_progress(0, self.PROGRESS_NONVISUAL, self.PROGRESS_VISUAL), "Importing junctions", True)
        self._save_junctions()

        self.progress_changed.emit("Visual objects", lerp_progress(30, self.PROGRESS_NONVISUAL, self.PROGRESS_VISUAL), "Importing reservoirs", True)
        self._save_reservoirs()

        self.progress_changed.emit("Visual objects", lerp_progress(40, self.PROGRESS_NONVISUAL, self.PROGRESS_VISUAL), "Importing tanks", True)
        self._save_tanks()

        self.progress_changed.emit("Visual objects", lerp_progress(50, self.PROGRESS_NONVISUAL, self.PROGRESS_VISUAL), "Importing pumps", True)
        self._save_pumps()

        self.progress_changed.emit("Visual objects", lerp_progress(60, self.PROGRESS_NONVISUAL, self.PROGRESS_VISUAL), "Importing valves", True)
        self._save_valves()

        self.progress_changed.emit("Visual objects", lerp_progress(70, self.PROGRESS_NONVISUAL, self.PROGRESS_VISUAL), "Importing pipes", True)
        self._save_pipes()

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
                value = "YES" if v else "NO"
            update_params.append((value, parameter))

        report_dict: dict = self.network[REPORT]

        # Iterate over each option
        for k, v in report_dict.items():
            parameter = params_map.get(k.lower(), k.lower())
            parameter = f"inp_report_{parameter}"
            value = f"{v}"
            if type(v) is bool:
                value = "YES" if v else "NO"
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

    def _save_controls_and_rules(self) -> None:
        from wntr.network.controls import Control, Rule

        controls_rows = get_rows("SELECT text FROM inp_controls", commit=False)
        controls_db: set[str] = set()
        if controls_rows:
            controls_db = {x[0] for x in controls_rows}

        rules_rows = get_rows("SELECT text FROM inp_rules", commit=False)
        rules_db: set[str] = set()
        if rules_rows:
            rules_db = {x[0] for x in rules_rows}

        for control_name, control in self.network.controls():
            control_dict = control.to_dict()
            condition = control.condition
            then_actions = control_dict.get("then_actions")
            else_actions = control_dict.get("else_actions")
            priority = control.priority
            if type(control) is Control:
                text = f"IF {condition} THEN {' AND '.join(then_actions)} PRIORITY {priority}"
                if text in controls_db:
                    msg = f"The control '{control_name}' is already on database. Skipping..."
                    self._log_message(msg)
                    continue

                sql = "INSERT INTO inp_controls (sector_id, text, active) VALUES (%s, %s, true)"
                params = (self.sector, text)
                execute_sql(sql, params, commit=False)
            elif type(control) is Rule:
                text = f"RULE {control.name}\nIF {condition}\nTHEN {'\nAND '.join(then_actions)}"
                if else_actions:
                    text += f"\nELSE {else_actions}"
                text += f"\nPRIORITY {priority}"
                if text in rules_db:
                    msg = f"The rule '{control_name}' is already on database. Skipping..."
                    self._log_message(msg)
                    continue

                sql = "INSERT INTO inp_rules (sector_id, text, active) VALUES (%s, %s, true)"
                params = (self.sector, text)
                execute_sql(sql, params, commit=False)


    def _save_junctions(self) -> None:
        node_sql = """ 
            INSERT INTO node (
                the_geom, code, nodecat_id, epa_type, expl_id, sector_id, muni_id, state, state_type, workcat_id, elevation
            ) VALUES %s
            RETURNING node_id, code
        """  # --"depth", arc_id, annotation, observ, "comment", label_x, label_y, label_rotation, staticpressure, feature_type
        node_template = (
            "(ST_SetSRID(ST_Point(%s, %s),%s), %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        )

        man_sql = """
            INSERT INTO man_junction (
                node_id
            ) VALUES %s
        """
        man_template = "(%s)"

        inp_sql = """
            INSERT INTO inp_junction (
                node_id, demand, emitter_coeff, init_quality
            ) VALUES %s
        """  # --pattern_id, peak_factor, source_type, source_quality, source_pattern_id
        inp_template = (
            "(%s, %s, %s, %s)"
        )

        demands_sql = """
            INSERT INTO inp_dscenario_demand (dscenario_id, feature_id, feature_type, demand, pattern_id, demand_type, source)
            VALUES %s
        """
        demands_template = (
            "(%s, %s, 'NODE', %s, %s, null, %s)"
        )
        demands_params = []

        node_params = []

        inp_dict = {}

        for j_name, j in self.network.junctions():
            x, y = j.coordinates
            srid = lib_vars.data_epsg
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
                    nodecat_id,
                    epa_type,
                    expl_id,
                    sector_id,
                    muni_id,
                    state,
                    state_type,
                    workcat_id,
                    j.elevation,
                )
            )
            inp_dict[j_name] = {
                "demand": j.base_demand,
                "pattern_id": None,
                "peak_factor": None,
                "emitter_coeff": j.emitter_coefficient,
                "init_quality": j.initial_quality,
                "source_type": None,
                "source_quality": None,
                "source_pattern_id": None
            }

            # If only one demand timeseries, set pattern_id in inp_dict; otherwise, populate demands_params
            if j.demand_timeseries_list:
                inp_dict[j_name]["pattern_id"] = j.demand_timeseries_list[0].pattern_name
                if len(j.demand_timeseries_list) > 1:
                    for d in j.demand_timeseries_list:
                        demands_params.append(
                            (
                                self.dscenario_id,
                                j_name,
                                d.base_value,
                                d.pattern_name,
                                d.category,
                            )
                        )

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
                (node_id, inp_data["demand"], inp_data["emitter_coeff"], inp_data["init_quality"])
            )

        # Update demands_params to replace j_name with node_id
        for i, demand_param in enumerate(demands_params):
            j_name = demand_param[1]  # Get the original j_name
            node_id = self.node_ids.get(j_name)  # Find the node_id associated with j_name
            if node_id is not None:
                demands_params[i] = (demand_param[0], node_id, *demand_param[2:])
            else:
                self._log_message(f"Node ID for {j_name} not found!")

        # Insert into inp table
        toolsdb_execute_values(
            inp_sql, inp_params, inp_template, fetch=False, commit=False
        )
        # Insert into man table
        toolsdb_execute_values(
            man_sql, man_params, man_template, fetch=False, commit=False
        )
        # Insert demands into dscenario table
        toolsdb_execute_values(
            demands_sql, demands_params, demands_template, fetch=False, commit=False
        )


    def _save_reservoirs(self) -> None:
        feature_class = self.catalogs['features']['reservoirs'].lower()

        node_sql = """ 
            INSERT INTO node (
                the_geom, code, nodecat_id, epa_type, expl_id, sector_id, muni_id, state, state_type, workcat_id
            ) VALUES %s
            RETURNING node_id, code
        """  # --"depth", arc_id, annotation, observ, "comment", label_x, label_y, label_rotation, staticpressure, feature_type
        node_template = (
            "(ST_SetSRID(ST_Point(%s, %s),%s), %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        )

        man_sql = f"""
            INSERT INTO man_{feature_class} (
                node_id
            ) VALUES %s
        """
        man_template = "(%s)"

        inp_sql = """
            INSERT INTO inp_reservoir (
                node_id, pattern_id, head, init_quality
            ) VALUES %s
        """  # --pattern_id, peak_factor, source_type, source_quality, source_pattern_id
        inp_template = (
            "(%s, %s, %s, %s)"
        )

        node_params = []

        inp_dict = {}

        for r_name, r in self.network.reservoirs():
            x, y = r.coordinates
            srid = lib_vars.data_epsg
            nodecat_id = self.catalogs["reservoirs"]
            epa_type = "RESERVOIR"
            expl_id = self.exploitation
            sector_id = self.sector
            muni_id = self.municipality
            state = 1
            state_type = 2
            workcat_id = self.workcat
            node_params.append(
                (
                    x, y, srid,  # the_geom
                    r_name,  # code
                    nodecat_id,
                    epa_type,
                    expl_id,
                    sector_id,
                    muni_id,
                    state,
                    state_type,
                    workcat_id,
                )
            )
            inp_dict[r_name] = {
                "pattern_id": r.head_pattern_name,
                "head": r.head,
                "init_quality": r.initial_quality,
                "source_type": None,
                "source_quality": None,
                "source_pattern_id": None
            }

        # Insert into parent table
        reservoirs = toolsdb_execute_values(
            node_sql, node_params, node_template, fetch=True, commit=False
        )
        print(reservoirs)
        if not reservoirs:
            self._log_message("Reservoirs couldn't be inserted!")
            return

        man_params = []
        inp_params = []

        for r in reservoirs:
            node_id = r[0]
            code = r[1]

            self.node_ids[code] = node_id

            man_params.append(
                (node_id,)
            )

            inp_data = inp_dict[code]
            inp_params.append(
                (node_id, inp_data["pattern_id"], inp_data["head"], inp_data["init_quality"])
            )

        # Insert into inp table
        toolsdb_execute_values(
            inp_sql, inp_params, inp_template, fetch=False, commit=False
        )
        # Insert into man table
        toolsdb_execute_values(
            man_sql, man_params, man_template, fetch=False, commit=False
        )

    def _save_tanks(self) -> None:
        feature_class = self.catalogs['features']['tanks'].lower()

        node_sql = """ 
            INSERT INTO node (
                the_geom, code, nodecat_id, epa_type, expl_id, sector_id, muni_id, state, state_type, workcat_id, elevation
            ) VALUES %s
            RETURNING node_id, code
        """  # --"depth", arc_id, annotation, observ, "comment", label_x, label_y, label_rotation, staticpressure, feature_type
        node_template = (
            "(ST_SetSRID(ST_Point(%s, %s),%s), %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        )

        man_sql = f"""
            INSERT INTO man_{feature_class} (
                node_id
            ) VALUES %s
        """
        man_template = "(%s)"

        inp_sql = """
            INSERT INTO inp_tank (
                node_id, initlevel, minlevel, maxlevel, diameter, minvol, curve_id, overflow, mixing_model, mixing_fraction, reaction_coeff, init_quality
            ) VALUES %s
        """  # --
        inp_template = (
            "(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        )

        node_params = []

        inp_dict = {}

        for t_name, t in self.network.tanks():
            x, y = t.coordinates
            srid = lib_vars.data_epsg
            nodecat_id = self.catalogs["tanks"]
            epa_type = "TANK"
            expl_id = self.exploitation
            sector_id = self.sector
            muni_id = self.municipality
            state = 1
            state_type = 2
            workcat_id = self.workcat
            elevation = t.elevation
            node_params.append(
                (
                    x, y, srid,  # the_geom
                    t_name,  # code
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
            inp_dict[t_name] = {
                "initlevel": t.init_level,
                "minlevel": t.min_level,
                "maxlevel": t.max_level,
                "diameter": t.diameter,
                "minvol": t.min_vol,
                "curve_id": t.vol_curve_name,
                "overflow": "Yes" if t.overflow else "No",
                "mixing_model": t.mixing_model,
                "mixing_fraction": t.mixing_fraction,
                "reaction_coeff": t.bulk_coeff,
                "init_quality": t.initial_quality,
                "source_type": None,
                "source_quality": None,
                "source_pattern_id": None,
            }

        # Insert into parent table
        tanks = toolsdb_execute_values(
            node_sql, node_params, node_template, fetch=True, commit=False
        )
        print(tanks)
        if not tanks:
            self._log_message("Tanks couldn't be inserted!")
            return

        man_params = []
        inp_params = []

        for t in tanks:
            node_id = t[0]
            code = t[1]

            self.node_ids[code] = node_id

            man_params.append(
                (node_id,)
            )

            inp_data = inp_dict[code]
            inp_params.append(
                (node_id, inp_data["initlevel"], inp_data["minlevel"], inp_data["maxlevel"], inp_data["diameter"],
                 inp_data["minvol"], inp_data["curve_id"], inp_data["overflow"], inp_data["mixing_model"],
                 inp_data["mixing_fraction"], inp_data["reaction_coeff"], inp_data["init_quality"])
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
        feature_class = self.catalogs['features']['pumps'].lower()

        arc_sql = """ 
            INSERT INTO arc (
                the_geom, code, node_1, node_2, arccat_id, epa_type, expl_id, sector_id, muni_id, state, state_type, workcat_id
            ) VALUES %s
            RETURNING arc_id, code
        """  # --"depth", arc_id, annotation, observ, "comment", label_x, label_y, label_rotation, staticpressure, feature_type
        arc_template = (
            "(ST_GeomFromText(%s, %s), %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        )

        man_sql = f"""
            INSERT INTO man_{feature_class} (
                arc_id
            ) VALUES %s
        """
        man_template = "(%s)"

        inp_sql = """
            INSERT INTO inp_virtualpump (
                arc_id, power, curve_id, speed, pattern_id, status, effic_curve_id, energy_price, energy_pattern_id, pump_type
            ) VALUES %s
        """  # --
        inp_template = (
            "(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        )

        arc_params = []

        inp_dict = {}

        for p_name, p in self.network.pumps():
            geometry = get_geometry_from_link(p)

            srid = lib_vars.data_epsg
            try:
                node_1 = self.node_ids[p.start_node_name]
                node_2 = self.node_ids[p.end_node_name]
            except KeyError as e:
                self._log_message(f"Node not found: {e}")
                continue
            arccat_id = self.catalogs["pumps"]
            epa_type = "VIRTUALPUMP"
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
                "power": None,
                "curve_id": None,
                "speed": p.base_speed,
                "pattern_id": p.speed_pattern_name,
                "status": p.initial_status.name.upper(),
                "effic_curve_id": p.efficiency.name if p.efficiency else None,
                "energy_price": p.energy_price,
                "energy_pattern_id": p.energy_pattern,
                "pump_type": None,
            }
            if p.pump_type == "POWER":
                inp_dict[p_name]["power"] = p.power
                inp_dict[p_name]["pump_type"] = "FLOWPUMP"
            elif p.pump_type == "HEAD":
                inp_dict[p_name]["curve_id"] = p.pump_curve_name
                inp_dict[p_name]["pump_type"] = "PRESSPUMP"

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
                (arc_id, inp_data["power"], inp_data["curve_id"], inp_data["speed"], inp_data["pattern_id"],
                 inp_data["status"], inp_data["effic_curve_id"], inp_data["energy_price"],
                 inp_data["energy_pattern_id"], inp_data["pump_type"])
            )

        # Insert into inp table
        toolsdb_execute_values(
            inp_sql, inp_params, inp_template, fetch=False, commit=False
        )
        # Insert into man table
        toolsdb_execute_values(
            man_sql, man_params, man_template, fetch=False, commit=False
        )

    def _save_valves(self) -> None:
        feature_class = self.catalogs['features']['valves'].lower()

        arc_sql = """ 
            INSERT INTO arc (
                the_geom, code, node_1, node_2, arccat_id, epa_type, expl_id, sector_id, muni_id, state, state_type, workcat_id
            ) VALUES %s
            RETURNING arc_id, code
        """  # --"depth", arc_id, annotation, observ, "comment", label_x, label_y, label_rotation, staticpressure, feature_type
        arc_template = (
            "(ST_GeomFromText(%s, %s), %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        )

        man_sql = f"""
            INSERT INTO man_{feature_class} (
                arc_id
            ) VALUES %s
        """
        man_template = "(%s)"

        inp_sql = """
            INSERT INTO inp_virtualvalve (
                arc_id, valv_type, pressure, diameter, flow, coef_loss, curve_id, minorloss, status, init_quality
            ) VALUES %s
        """  # --
        inp_template = (
            "(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        )

        arc_params = []

        inp_dict = {}

        for v_name, v in self.network.valves():
            geometry = get_geometry_from_link(v)

            srid = lib_vars.data_epsg
            try:
                node_1 = self.node_ids[v.start_node_name]
                node_2 = self.node_ids[v.end_node_name]
            except KeyError as e:
                self._log_message(f"Node not found: {e}")
                continue
            arccat_id = self.catalogs["valves"]
            epa_type = "VIRTUALVALVE"
            expl_id = self.exploitation
            sector_id = self.sector
            muni_id = self.municipality
            state = 1
            state_type = 2
            workcat_id = self.workcat
            arc_params.append(
                (
                    geometry, srid,  # the_geom
                    v_name,  # code
                    node_1,
                    node_2,
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
            inp_dict[v_name] = {
                "valv_type": v.valve_type,
                "pressure": None,
                "diameter": v.diameter,
                "flow": None,
                "coef_loss": None,
                "curve_id": None,
                "minorloss": v.minor_loss,
                "status": v.initial_status.name.upper(),
                "init_quality": None,
            }

            # TODO: refactor this so all values go to one 'setting' column (except curve_id).
            valve_key_map = {
                "PRV": "pressure",
                "PSV": "pressure",
                "PBV": "pressure",
                "FCV": "flow",
                "TCV": "coef_loss",
                "GPV": "curve_id",
            }
            key = valve_key_map.get(v.valve_type)
            if key:
                inp_dict[v_name][key] = v.initial_setting

        # Insert into parent table
        valves = toolsdb_execute_values(
            arc_sql, arc_params, arc_template, fetch=True, commit=False
        )
        print(valves)
        if not valves:
            self._log_message("Valves couldn't be inserted!")
            return

        man_params = []
        inp_params = []

        for v in valves:
            arc_id = v[0]
            code = v[1]
            man_params.append(
                (arc_id,)
            )

            inp_data = inp_dict[code]
            inp_params.append(
                (arc_id, inp_data["valv_type"], inp_data["pressure"], inp_data["diameter"], inp_data["flow"],
                 inp_data["coef_loss"], inp_data["curve_id"], inp_data["minorloss"], inp_data["status"],
                 inp_data["init_quality"])
            )
            print(inp_params)

        # Insert into inp table
        toolsdb_execute_values(
            inp_sql, inp_params, inp_template, fetch=False, commit=False
        )
        # Insert into man table
        toolsdb_execute_values(
            man_sql, man_params, man_template, fetch=False, commit=False
        )

    def _save_pipes(self) -> None:
        feature_class = self.catalogs['features']['pipes'].lower()

        arc_sql = """ 
            INSERT INTO arc (
                the_geom, code, node_1, node_2, arccat_id, epa_type, expl_id, sector_id, muni_id, state, state_type, workcat_id
            ) VALUES %s
            RETURNING arc_id, code
        """  # --"depth", arc_id, annotation, observ, "comment", label_x, label_y, label_rotation, staticpressure, feature_type
        arc_template = (
            "(ST_GeomFromText(%s, %s), %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        )

        man_sql = f"""
            INSERT INTO man_{feature_class} (
                arc_id
            ) VALUES %s
        """
        man_template = "(%s)"

        inp_sql = """
            INSERT INTO inp_pipe (
                arc_id, minorloss, status, custom_roughness, custom_dint, reactionparam, reactionvalue, bulk_coeff, wall_coeff
            ) VALUES %s
        """  # --
        inp_template = (
            "(%s, %s, %s, %s, %s, %s, %s, %s, %s)"
        )

        arc_params = []

        inp_dict = {}

        for p_name, p in self.network.pipes():
            geometry = get_geometry_from_link(p)

            srid = lib_vars.data_epsg
            try:
                node_1 = self.node_ids[p.start_node_name]
                node_2 = self.node_ids[p.end_node_name]
            except KeyError as e:
                self._log_message(f"Node not found: {e}")
                continue
            arccat_id = self.catalogs["pipes"][(round(p.diameter*1000, 0), p.roughness)]
            epa_type = "PIPE"
            expl_id = self.exploitation
            sector_id = self.sector
            muni_id = self.municipality
            state = 1
            state_type = 2
            workcat_id = self.workcat
            arc_params.append(
                (
                    geometry,
                    srid,
                    p_name,
                    node_1,
                    node_2,
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
                "minorloss": p.minor_loss,
                "status": p.initial_status.name.upper(),
                "custom_roughness": p.roughness,
                "custom_dint": p.diameter,
                "reactionparam": None,
                "reactionvalue": None,
                "bulk_coeff": p.bulk_coeff,
                "wall_coeff": p.wall_coeff,
            }

        # Insert into parent table
        pipes = toolsdb_execute_values(
            arc_sql, arc_params, arc_template, fetch=True, commit=False
        )
        print(pipes)
        if not pipes:
            self._log_message("Pipes couldn't be inserted!")
            return

        man_params = []
        inp_params = []

        for p in pipes:
            arc_id = p[0]
            code = p[1]
            man_params.append(
                (arc_id,)
            )

            inp_data = inp_dict[code]
            inp_params.append(
                (arc_id, inp_data["minorloss"], inp_data["status"], inp_data["custom_roughness"], inp_data["custom_dint"],
                 inp_data["reactionparam"], inp_data["reactionvalue"], inp_data["bulk_coeff"], inp_data["wall_coeff"],
                 )
            )
            print(inp_params)

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
