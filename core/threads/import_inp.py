import traceback
from datetime import date
from itertools import count, islice
from typing import Any

from psycopg2.extras import execute_values

try:
    from wntr.epanet.util import FlowUnits, HydParam, from_si
    from wntr.network.model import WaterNetworkModel
except ImportError:
    pass

from qgis.PyQt.QtCore import pyqtSignal

from ...libs import lib_vars, tools_db, tools_log
from .task import GwTask


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


class GwImportInpTask(GwTask):

    message_logged = pyqtSignal(str, str)

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
        self.network: WaterNetworkModel = network
        self.workcat: str = workcat
        self.exploitation: int = exploitation
        self.sector: int = sector
        self.municipality: int = municipality
        self.catalogs: dict[str, Any] = catalogs
        self.log: list[str] = []
        self.mappings: dict[str, dict[str, str]] = {"curves": {}, "patterns": {}}
        self.arccat_db: list[str] = []
        self.db_units = None
        self.exception: str = ""

    def run(self) -> bool:
        super().run()
        try:
            self._log_message("Validating inputs...", end="")
            self._validate_inputs()
            self._log_message("done!")

            self._log_message("Getting units from DB...", end="")
            self._get_db_units()
            self._log_message("done!")

            self._log_message("Creating workcat...", end="")
            self._create_workcat_id()
            self._log_message("done!")

            self._log_message("Creating new node catalogs...", end="")
            self._create_new_node_catalogs()
            self._log_message("done!")

            # Get existing catalogs in DB
            cat_arc_ids = get_rows("SELECT id FROM cat_arc", commit=False)
            if cat_arc_ids:
                self.arccat_db += [x[0] for x in cat_arc_ids]

            self._log_message("Creating new varc catalogs...")
            self._create_new_varc_catalogs()
            self._log_message("done!")

            self._log_message("Creating new pipe catalogs...")
            self._create_new_pipe_catalogs()
            self._log_message("done!")

            self._log_message("Inserting patterns into DB...")
            self._save_patterns()
            self._log_message("done!")

            self._log_message("Inserting curves into DB...")
            self._save_curves()
            self._log_message("done!")

            self._log_message("Inserting junctions into DB...")
            self._save_junctions_to_v_edit_node()
            self._log_message("done!")

            execute_sql("select 1", commit=True)
            self._log_message("ALL DONE! INP successfully imported.")
            return True
        except Exception as e:
            self.exception = traceback.format_exc()
            self.log.append(f"{e}")
            tools_db.dao.rollback()
            return False

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

    def _create_new_node_catalogs(self):
        cat_node_ids = get_rows("SELECT id FROM cat_node", commit=False)
        nodecat_db: list[str] = []
        if cat_node_ids:
            nodecat_db = [x[0] for x in cat_node_ids]

        node_catalogs = ["junctions", "reservoirs", "tanks"]

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
        varc_catalogs: list[str] = ["pumps", "valves"]

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
                INSERT INTO cat_mat_arc (id, descript)
                SELECT 'UNKNOWN', 'Unknown'
                WHERE NOT EXISTS (
                    SELECT 1
                    FROM cat_mat_arc
                    WHERE id = 'UNKNOWN'
                );
                """,
                commit=False,
            )

            sql = """
                INSERT INTO cat_arc (id, arc_type, matcat_id, dint)
                VALUES (%s, %s, 'UNKNOWN', 999)
            """
            _id = self.catalogs[varc_type]
            arctype_id = self.catalogs["features"][varc_type]
            execute_sql(sql, (_id, arctype_id), commit=False)
            self.arccat_db.append(_id)

    def _create_new_pipe_catalogs(self):
        if "pipes" in self.catalogs:
            pipe_catalog = self.catalogs["pipes"].items()
            for (pipe_dint, pipe_roughness), catalog in pipe_catalog:
                if catalog in self.arccat_db:
                    continue

                arctype_id = self.catalogs["features"]["pipes"]

                material = self.catalogs["materials"][pipe_roughness]

                sql = """
                    INSERT INTO cat_arc (id, arc_type, matcat_id, dint)
                    VALUES (%s, %s, %s, %s);
                """
                execute_sql(
                    sql, (catalog, arctype_id, material, pipe_dint), commit=False
                )
                self.arccat_db.append(catalog)

    def _save_patterns(self):
        pattern_rows = get_rows("SELECT pattern_id FROM inp_pattern", commit=False)
        patterns_db: list[str] = []
        if pattern_rows:
            patterns_db = [x[0] for x in pattern_rows]

        for pattern_name, pattern in self.network.patterns.items():
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

            execute_sql(
                "INSERT INTO inp_pattern (pattern_id) VALUES (%s)",
                (pattern_name,),
                commit=False,
            )

            sql = (
                "INSERT INTO inp_pattern_value (pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12) "
                "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
            )
            for b in batched(pattern.multipliers, 12):
                # Fill up the last batch
                while len(b) < 12:
                    b: tuple[Any] = b + (None,)
                values = (pattern_name,) + b
                execute_sql(sql, values, commit=False)

    def _save_curves(self) -> None:
        curve_rows = get_rows("SELECT id FROM inp_curve", commit=False)
        curves_db: set[str] = set()
        if curve_rows:
            curves_db = {x[0] for x in curve_rows}

        for curve_name, curve in self.network.curves.items():
            if curve.curve_type is None:
                message = f'The "{curve_name}" curve does not have a specified curve type and was not imported.'
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

            curve_type: str = curve.curve_type
            if curve.curve_type == "HEAD":
                curve_type = "PUMP"

            execute_sql(
                "INSERT INTO inp_curve (id, curve_type) VALUES (%s, %s)",
                (curve_name, curve_type),
                commit=False,
            )

            for x, y in curve.points:
                if curve_type != "VOLUME":
                    x = from_si(FlowUnits[self.db_units], x, HydParam.Flow)
                execute_sql(
                    "INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES (%s, %s, %s)",
                    (curve_name, x, y),
                    commit=False,
                )

    def _save_junctions_to_v_edit_node(self) -> None:
        sql = """
            INSERT INTO v_edit_node (the_geom, code, elevation, nodecat_id, epa_type, expl_id, sector_id, muni_id, state, state_type, workcat_id)
            VALUES %s
            RETURNING node_id, code
        """

        template = (
            "(ST_SetSRID(ST_Point(%s, %s),%s), %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        )

        params = []

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
            params.append(
                (
                    x,
                    y,
                    srid,
                    j_name,
                    j.elevation,
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

        junctions = toolsdb_execute_values(
            sql, params, template, fetch=True, commit=True
        )

        print(junctions)

    def _log_message(self, message: str, end: str="\n"):
        self.log.append(message)
        self.message_logged.emit(message, end)
