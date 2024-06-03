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

            self.catalogs: Catalogs = Catalogs.from_network_model(self.network)

            return True
        except Exception as e:
            self.exception: str = traceback.format_exc()
            self.log.append(f"{e}")
            return False


@dataclass(frozen=True)
class Catalogs:
    """
    Represents the catalogs for each type of element in the INP file,
    with the best correspondence in the DB.
    If a INP file doesn't have a type of node, its property receives `None`.
    """

    db_arcs: dict[str, tuple[float, float]]
    db_materials: dict[str, list[float]]
    db_nodes: dict[str, str]
    inp_junctions: Optional[list[str]]
    inp_pipes: dict[tuple[float, float], list[str]]
    inp_pumps: Optional[list[str]]
    inp_reservoirs: Optional[list[str]]
    inp_tanks: Optional[list[str]]
    inp_valves: Optional[list[str]]

    @classmethod
    def from_network_model(cls, wn: wntr.network.WaterNetworkModel):
        # Get node catalog from DB
        rows = tools_db.get_rows("""
                SELECT n.id, f.epa_default
                FROM cat_node AS n
                JOIN cat_feature_node AS f ON (n.nodetype_id = f.id)
            """)

        db_node_catalog: dict[str, str] = {}
        if rows:
            db_node_catalog = dict(
                sorted({_id: epa_default for _id, epa_default in rows}.items())
            )

        # Get arc catalog from DB
        rows = tools_db.get_rows("""
                SELECT a.id, a.dint, r.roughness
                FROM cat_arc AS a
                JOIN cat_mat_roughness AS r USING (matcat_id)
            """)

        db_arc_catalog: dict[str, tuple[float, float]] = {}
        if rows:
            unsorted_dict = {
                _id: (float(dint), float(roughness)) for _id, dint, roughness in rows
            }
            db_arc_catalog = dict(sorted(unsorted_dict.items()))

        # Get roughness catalog
        rows = tools_db.get_rows("""
                SELECT matcat_id, array_agg(roughness)
                FROM cat_mat_roughness
                GROUP BY matcat_id
            """)
        db_mat_roughness_cat: dict[str, list[float]] = {}
        if rows:
            unsorted_dict = {
                _id: [float(x) for x in array_rough] for _id, array_rough in rows
            }
            db_mat_roughness_cat = dict(sorted(unsorted_dict.items()))

        # Get possible catalogs of the network
        junction_catalogs: Optional[list[str]] = (
            [
                _id
                for _id, epa_default in db_node_catalog.items()
                if epa_default == "JUNCTION"
            ]
            if wn.num_junctions > 0
            else None
        )

        tank_catalogs: Optional[list[str]] = (
            [
                _id
                for _id, epa_default in db_node_catalog.items()
                if epa_default == "TANK"
            ]
            if wn.num_tanks > 0
            else None
        )

        reservoir_catalogs: Optional[list[str]] = (
            [
                _id
                for _id, epa_default in db_node_catalog.items()
                if epa_default == "RESERVOIR"
            ]
            if wn.num_reservoirs > 0
            else None
        )

        pipe_types = set()
        for _, pipe in wn.pipes():
            diameter = float(round(pipe.diameter * 1000))
            roughness = float(pipe.roughness)
            pipe_types.add((diameter, roughness))

        pipe_catalogs: dict[tuple[float, float], list[str]] = {}
        for pipe_type in sorted(pipe_types):
            pipe_catalogs[pipe_type] = [
                _id for _id, dr_pair in db_arc_catalog.items() if dr_pair == pipe_type
            ]

        pump_catalogs: Optional[list[str]] = [] if wn.num_pumps > 0 else None

        valve_catalogs: Optional[list[str]] = [] if wn.num_valves > 0 else None

        return cls(
            db_arc_catalog,
            db_mat_roughness_cat,
            db_node_catalog,
            junction_catalogs,
            pipe_catalogs,
            pump_catalogs,
            reservoir_catalogs,
            tank_catalogs,
            valve_catalogs,
        )
