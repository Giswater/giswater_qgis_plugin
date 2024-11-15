import traceback
from dataclasses import dataclass
from pathlib import Path
from typing import Optional

from swmm_api import read_inp_file, SwmmInput
from swmm_api.input_file.section_labels import (
    OPTIONS,
    JUNCTIONS, OUTFALLS, DIVIDERS, STORAGE,
    CONDUITS, PUMPS, ORIFICES, WEIRS, OUTLETS
)
from swmm_api.input_file.sections import (
    Conduit
)

from ....libs import tools_db
from ...ui.dialog import GwDialog
from ..task import GwTask


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
            self.network = read_inp_file(self.inp_file_path)
            flow_units: str = self.network[OPTIONS].get('FLOW_UNITS')

            if flow_units not in ("LPS", "LPM", "CMS"):
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
    db_features: dict[str, tuple[str, str]]
    db_materials: dict[str, list[float]]
    db_nodes: dict[str, str]
    inp_junctions: Optional[list[str]]
    inp_pipes: dict[tuple[float, float], list[str]]
    inp_pumps: Optional[list[str]]
    inp_reservoirs: Optional[list[str]]
    inp_tanks: Optional[list[str]]
    inp_valves: Optional[list[str]]

    @classmethod
    def from_network_model(cls, wn: SwmmInput):
        # Get node catalog from DB
        rows = tools_db.get_rows("""
                SELECT n.id, f.epa_default
                FROM cat_node AS n
                JOIN cat_feature_node AS f ON (n.node_type = f.id)
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

            def tofloat(x):
                return 0.0 if x is None else float(x)

            unsorted_dict = {
                _id: [tofloat(x) for x in array_rough] for _id, array_rough in rows
            }
            db_mat_roughness_cat = dict(sorted(unsorted_dict.items()))

        # Get feature catalog
        rows = tools_db.get_rows("""
                SELECT id, feature_class, feature_type
                FROM cat_feature
            """)
        db_feat_cat: dict[str, tuple[str, str]] = {}
        if rows:
            unsorted_dict = {
                _id: (feat_type, feature_class) for _id, feature_class, feat_type in rows
            }
            db_feat_cat = dict(sorted(unsorted_dict.items()))

        # Get possible catalogs of the network
        junction_catalogs: Optional[list[str]] = (
            [
                _id
                for _id, epa_default in db_node_catalog.items()
                if epa_default == "JUNCTION"
            ]
            if len(wn[JUNCTIONS]) > 0
            else None
        )

        outfall_catalogs: Optional[list[str]] = (
            [
                _id
                for _id, epa_default in db_node_catalog.items()
                if epa_default == "OUTFALL"
            ]
            if len(wn[OUTFALLS]) > 0
            else None
        )

        divider_catalogs: Optional[list[str]] = (
            [
                _id
                for _id, epa_default in db_node_catalog.items()
                if epa_default == "DIVIDER"
            ]
            if len(wn[DIVIDERS]) > 0
            else None
        )

        storage_catalogs: Optional[list[str]] = (
            [
                _id
                for _id, epa_default in db_node_catalog.items()
                if epa_default == "STORAGE"
            ]
            if len(wn[STORAGE]) > 0
            else None
        )

        conduit_types = set()
        for _, conduit in wn[CONDUITS].items():
            conduit: Conduit
            diameter = float(round(conduit.diameter * 1000))
            roughness = float(conduit.roughness)
            conduit_types.add((diameter, roughness))

        conduit_catalogs: dict[tuple[float, float], list[str]] = {}
        for conduit_type in sorted(conduit_types):
            conduit_catalogs[conduit_type] = [
                _id for _id, dr_pair in db_arc_catalog.items() if dr_pair == conduit_type
            ]

        pump_catalogs: Optional[list[str]] = [] if len(wn[PUMPS]) > 0 else None

        orifice_catalogs: Optional[list[str]] = [] if len(wn[ORIFICES]) > 0 else None

        weir_catalogs: Optional[list[str]] = [] if len(wn[WEIRS]) > 0 else None

        outlet_catalogs: Optional[list[str]] = [] if len(wn[OUTLETS]) > 0 else None

        return cls(
            db_arc_catalog,
            db_feat_cat,
            db_mat_roughness_cat,
            db_node_catalog,
            junction_catalogs,
            pipe_catalogs,
            pump_catalogs,
            reservoir_catalogs,
            tank_catalogs,
            valve_catalogs,
        )
