import traceback
from datetime import date
from itertools import count, islice
from typing import Any

from wntr.epanet.util import FlowUnits, HydParam, from_si
from wntr.network.model import WaterNetworkModel

from ...libs import lib_vars, tools_db
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


class GwImportInpTask(GwTask):
    def __init__(
        self,
        description: str,
        filepath,
        network,
        workcat,
        exploitation,
        sector,
        catalogs,
    ) -> None:
        super().__init__(description)
        self.filepath = filepath
        self.network: WaterNetworkModel = network
        self.workcat: str = workcat
        self.exploitation: str = exploitation
        self.sector: str = sector
        self.catalogs: dict[str, Any] = catalogs
        self.log: list[str] = []
        self.mappings: dict[str, dict[str, str]] = {"curves": {}, "patterns": {}}

    def run(self) -> bool:
        super().run()
        try:
            # Some validations
            if not self.workcat:
                message = "Please enter a Workcat_id to proceed with this import."
                raise ValueError(message)

            if not self.exploitation:
                message = "Please select an exploitation to proceed with this import."
                raise ValueError(message)

            if not self.sector:
                message = "Please select a sector to proceed with this import."
                raise ValueError(message)

            # Get units of project
            units_row = get_row(
                "SELECT value FROM vi_options WHERE parameter = 'UNITS'",
                commit=False,
            )

            if not units_row:
                raise ValueError("Units not specified in the Giswater project.")

            self.db_units = units_row[0]

            # Create workcat
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

            # Create new node catalogs
            cat_node_ids = get_rows("SELECT id FROM cat_node", commit=False)
            nodecat_db: list[str] = []
            if cat_node_ids:
                nodecat_db = [x[0] for x in cat_node_ids]

            node_catalogs = [
                ("junctions", "JUNCTION"),
                ("reservoirs", "SOURCE"),
                ("tanks", "TANK"),
            ]

            for node_type, cat_feature in node_catalogs:
                if node_type not in self.catalogs:
                    continue

                if self.catalogs[node_type] in nodecat_db:
                    continue

                sql = """
                    INSERT INTO cat_feature (id, system_id, feature_type)
                    VALUES (%s, %s, 'NODE')
                    ON CONFLICT (id) DO NOTHING;
                """
                execute_sql(sql, (cat_feature, cat_feature), commit=False)

                sql = """
                    INSERT INTO cat_node (id, nodetype_id)
                    VALUES (%s, %s)
                """
                execute_sql(
                    sql,
                    (self.catalogs[node_type], cat_feature),
                    commit=False,
                )
                nodecat_db.append(self.catalogs[node_type])

            # Create virtual arc catalogs
            cat_arc_ids = get_rows("SELECT id FROM cat_arc", commit=False)
            arccat_db: list[str] = []
            if cat_arc_ids:
                arccat_db = [x[0] for x in cat_arc_ids]

            varc_catalogs: list[str] = ["pumps", "valves"]

            for varc_type in varc_catalogs:
                if varc_type not in self.catalogs:
                    continue

                if self.catalogs[varc_type] in arccat_db:
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

                execute_sql(
                    """
                    INSERT INTO cat_feature (id, system_id, feature_type)
                    VALUES ('VARC', 'VARC', 'ARC')
                    ON CONFLICT (id) DO NOTHING;
                    """,
                    commit=False,
                )

                sql = """
                    INSERT INTO cat_arc (id, arctype_id, matcat_id, dint)
                    VALUES (%s, 'VARC', 'UNKNOWN', 999)
                """
                execute_sql(sql, (self.catalogs[varc_type],), commit=False)
                arccat_db.append(self.catalogs[varc_type])

            # Create new pipe catalogs
            if "pipes" in self.catalogs:
                pipe_catalog = self.catalogs["pipes"].items()
                for (pipe_dint, pipe_roughness), catalog in pipe_catalog:
                    if catalog in arccat_db:
                        continue

                    execute_sql(
                        """
                        INSERT INTO cat_feature (id, system_id, feature_type)
                        VALUES ('PIPE', 'PIPE', 'ARC')
                        ON CONFLICT (id) DO NOTHING;
                        """,
                        commit=False,
                    )

                    material = self.catalogs["materials"][pipe_roughness]

                    sql = """
                        INSERT INTO cat_arc (id, arctype_id, matcat_id, dint)
                        VALUES (%s, 'PIPE', %s, %s);
                    """
                    execute_sql(sql, (catalog, material, pipe_dint), commit=False)
                    arccat_db.append(catalog)

            # Save patterns
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

            # Save curves
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

            execute_sql("select 1", commit=True)
            return True
        except Exception as e:
            self.exception: str = traceback.format_exc()
            self.log.append(f"{e}")
            tools_db.dao.rollback()
            return False
