import traceback
from datetime import date
from itertools import count, islice
from typing import Any

import psycopg2
from wntr.epanet.util import FlowUnits, HydParam, from_si
from wntr.network.model import WaterNetworkModel

from ...libs import tools_db
from .task import GwTask


def batched(iterable, n):
    # batched('ABCDEFG', 3) --> ABC DEF G
    if n < 1:
        raise ValueError("n must be at least one")
    it = iter(iterable)
    while batch := tuple(islice(it, n)):
        yield batch


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

            with psycopg2.connect(tools_db.dao.conn_string) as conn:
                with conn.cursor() as cur:
                    if tools_db.dao.set_search_path:
                        cur.execute(tools_db.dao.set_search_path)

                    # Get units of project
                    cur.execute(
                        "SELECT value FROM vi_options WHERE parameter = 'UNITS'"
                    )
                    if cur.rowcount > 0:
                        self.db_units: str = cur.fetchone()[0]
                    else:
                        raise ValueError("Units not specified in the Giswater project.")

                    # Create workcat
                    sql = """
                        INSERT INTO cat_work (id, descript, builtdate, active)
                        VALUES (%s, %s, %s, TRUE)
                    """

                    description = f"Importing the file {self.filepath.name}"
                    builtdate: date = date.today()
                    cur.execute(sql, (self.workcat, description, builtdate))

                    # Save patterns
                    cur.execute("SELECT pattern_id FROM inp_pattern")
                    patterns_db: list[str] = []
                    if cur.rowcount > 0:
                        patterns_db = [x[0] for x in cur.fetchall()]

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

                        cur.execute(
                            "INSERT INTO inp_pattern (pattern_id) VALUES (%s)",
                            (pattern_name,),
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
                            cur.execute(sql, values)

                    # Save curves
                    cur.execute("SELECT id FROM inp_curve")
                    curves_db: set[str] = set()
                    if cur.rowcount > 0:
                        curves_db = {x[0] for x in cur.fetchall()}

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

                        cur.execute(
                            "INSERT INTO inp_curve (id, curve_type) VALUES (%s, %s)",
                            (curve_name, curve_type),
                        )

                        for x, y in curve.points:
                            if curve_type != "VOLUME":
                                x = from_si(FlowUnits[self.db_units], x, HydParam.Flow)
                            cur.execute(
                                "INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES (%s, %s, %s)",
                                (curve_name, x, y),
                            )

            return True
        except Exception as e:
            self.exception: str = traceback.format_exc()
            self.log.append(f"{e}")
            return False
