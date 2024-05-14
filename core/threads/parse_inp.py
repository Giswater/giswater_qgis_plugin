import traceback
from dataclasses import dataclass
from pathlib import Path
from typing import Optional

import wntr

from ...libs import tools_db
from ..ui.dialog import GwDialog
from .task import GwTask


class GwParseInpTask(GwTask):
    def __init__(self, description: str, inp_file_path: Path, dialog: GwDialog) -> None:
        super().__init__(description)
        self.inp_file_path: Path = inp_file_path
        self.dialog: GwDialog = dialog
        self.log: list[str] = []

    def run(self) -> bool:
        super().run()
        try:
            self.log.append("Reading INP file...")
            self.network = wntr.network.WaterNetworkModel(self.inp_file_path)
            flow_units: str = self.network.options.hydraulic.inpfile_units

            if flow_units not in ("LPS", "LPM", "MLD", "CMH", "CMD"):
                message: str = (
                    "Flow units should be in liters or cubic meters for importing. "
                    f"INP file units: {flow_units}"
                )
                raise ValueError(message)

            self.log.append("Analyzing catalogs...")

            # Get node catalog from DB
            rows = tools_db.get_rows("""
                SELECT n.id, f.epa_default
                FROM cat_node AS n
                JOIN cat_feature_node AS f ON (n.nodetype_id = f.id)
            """)

            self.db_node_catalog: dict[str, str] = {}
            if rows:
                self.db_node_catalog = {_id: epa_default for _id, epa_default in rows}

            # Get arc catalog from DB
            rows = tools_db.get_rows("""
                SELECT a.id, a.dint, r.roughness
                FROM cat_arc AS a
                JOIN cat_mat_roughness AS r USING (matcat_id)
            """)

            self.db_arc_catalog = {}
            if rows:
                self.db_arc_catalog = {
                    _id: (float(dint), float(roughness))
                    for _id, dint, roughness in rows
                }

            # Get possible catalogs of the network
            junction_catalogs: Optional[list[str]] = (
                [
                    _id
                    for _id, epa_default in self.db_node_catalog.items()
                    if epa_default == "JUNCTION"
                ]
                if self.network.num_junctions > 0
                else None
            )

            tank_catalogs: Optional[list[str]] = (
                [
                    _id
                    for _id, epa_default in self.db_node_catalog.items()
                    if epa_default == "TANK"
                ]
                if self.network.num_tanks > 0
                else None
            )

            reservoir_catalogs: Optional[list[str]] = (
                [
                    _id
                    for _id, epa_default in self.db_node_catalog.items()
                    if epa_default == "RESERVOIR"
                ]
                if self.network.num_reservoirs > 0
                else None
            )

            pipe_catalogs: dict[tuple[float, float], list[str]] = {}
            for _, pipe in self.network.pipes():
                diameter = float(round(pipe.diameter * 1000))
                roughness = float(pipe.roughness)
                pipe_catalogs[(diameter, roughness)] = [
                    _id
                    for _id, dr_pair in self.db_arc_catalog.items()
                    if dr_pair == (diameter, roughness)
                ]

            pump_catalogs: Optional[list[str]] = (
                [] if self.network.num_pumps > 0 else None
            )

            valve_catalogs: Optional[list[str]] = (
                [] if self.network.num_valves > 0 else None
            )

            self.inp_node_catalogs = InpNodeCatalogs(
                junction_catalogs, tank_catalogs, reservoir_catalogs
            )

            self.inp_arc_catalogs = InpArcCatalogs(
                pipe_catalogs, pump_catalogs, valve_catalogs
            )

            print(str(self.inp_arc_catalogs))
            print(str(self.inp_node_catalogs))

            return True
        except Exception as e:
            self.exception: str = traceback.format_exc()
            self.log.append(f"{e}")
            return False


@dataclass(frozen=True)
class InpNodeCatalogs:
    """
    Represents the catalogs for each type of node in the INP file,
    with the best correspondence in the DB.
    If a INP file doesn't have a type of node, its property receives `None`.
    """

    junctions: Optional[list[str]]
    reservoirs: Optional[list[str]]
    tanks: Optional[list[str]]

    def has_junctions(self) -> bool:
        return self.junctions is not None

    def has_reservoirs(self) -> bool:
        return self.reservoirs is not None

    def has_tanks(self) -> bool:
        return self.tanks is not None


@dataclass(frozen=True)
class InpArcCatalogs:
    """
    Represents the catalogs for each type of arc in the INP file,
    with the best correspondence in the DB.
    If a INP file doesn't have a valves or pumps, its property receives `None`.
    If a INP file doesn't have pipes (?!), `pipes` property receives an empty `dict`.
    """

    pipes: dict[tuple[float, float], list[str]]
    pumps: Optional[list[str]]
    valves: Optional[list[str]]

    def has_pipes(self) -> bool:
        return len(self.pipes) > 0

    def has_pumps(self) -> bool:
        return self.pumps is not None

    def has_valves(self) -> bool:
        return self.valves is not None
