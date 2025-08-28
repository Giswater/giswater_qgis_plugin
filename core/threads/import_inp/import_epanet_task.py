"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
import traceback
from datetime import date
from itertools import count
from typing import Any

try:
    from wntr.epanet.util import FlowUnits, HydParam, from_si
    from wntr.network.model import WaterNetworkModel
except ImportError:
    pass

from qgis.PyQt.QtCore import pyqtSignal

from ....libs import lib_vars, tools_db
from ...utils import tools_gw
from ..task import GwTask
from ...utils.import_inp import lerp_progress, batched, get_row, get_rows, execute_sql, toolsdb_execute_values


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
        dscenario,
        catalogs,
        state,
        state_type,
        manage_nodarcs: dict[str, bool] = {"pumps": False, "valves": False},
        force_commit: bool = False,
    ) -> None:
        super().__init__(description)
        self.filepath = filepath
        self.network: WaterNetworkModel = network
        self.workcat: str = workcat
        self.exploitation: int = exploitation
        self.sector: int = sector
        self.municipality: int = municipality
        self.dscenario: str = dscenario
        self.dscenario_id: int = None
        self.catalogs: dict[str, Any] = catalogs
        self.state: int = state
        self.state_type: int = state_type
        self.force_commit: bool = force_commit
        self.update_municipality: bool = False
        self.manage_nodarcs: dict[str, bool] = manage_nodarcs
        self.log: list[str] = []
        self.mappings: dict[str, dict[str, str]] = {"curves": {}, "patterns": {}}
        self.arccat_db: list[str] = []
        self.db_units = None
        self.exception: str = ""
        self.debug_mode: bool = False  # TODO: add checkbox or something to manage debug_mode, and put logs into tab_log

        self.node_ids: dict[str, str] = {}

    def run(self) -> bool:
        super().run()
        try:
            # Disable triggers except plan trigger
            self._enable_triggers(False, plan_trigger=True)

            self.progress_changed.emit("Validate inputs", self.PROGRESS_INIT, "Validating inputs...", False)
            self._validate_inputs()
            self.progress_changed.emit("Validate inputs", self.PROGRESS_VALIDATE, "done!", True)

            self.progress_changed.emit("Getting options", self.PROGRESS_VALIDATE, "Importing options...", False)
            self._save_options()
            self.progress_changed.emit("Getting options", self.PROGRESS_OPTIONS, "done!", True)

            self.progress_changed.emit("Getting options", self.PROGRESS_OPTIONS, "Getting units...", False)
            self._get_units()
            self.progress_changed.emit("Getting options", self.PROGRESS_OPTIONS, "done!", True)

            self._manage_nonvisual()

            self._manage_catalogs()

            self._manage_visual()

            if self.update_municipality:
                self._update_municipality()

            if self.network.num_sources > 0:
                self.progress_changed.emit("Sources", self.PROGRESS_VISUAL, "Importing sources...", False)
                self._save_sources()
                self.progress_changed.emit("Sources", self.PROGRESS_SOURCES, "done!", True)

            # Enable plan and topocontrol triggers
            self._enable_triggers(False, plan_trigger=True, geometry_trigger=True)

            if any(self.manage_nodarcs.values()):
                self.progress_changed.emit("Nodarcs", self.PROGRESS_SOURCES, "Managing nodarcs (pumps/valves as nodes)...", False)
                log_str = self._manage_nodarcs()
                self.progress_changed.emit("Nodarcs", self.PROGRESS_END, "done!", True)
                self.progress_changed.emit("Nodarcs", self.PROGRESS_END, log_str, True)

            # Enable ALL triggers
            self._enable_triggers(True)

            execute_sql("select 1", commit=True)
            self.progress_changed.emit("", self.PROGRESS_END, "\n\nALL DONE! INP successfully imported.", True)
            return True
        except Exception:
            self.exception = traceback.format_exc()
            self._log_message(f"{traceback.format_exc()}")
            tools_db.dao.rollback()
            return False

    def _manage_catalogs(self) -> None:
        self.progress_changed.emit("Create catalogs", lerp_progress(0, self.PROGRESS_OPTIONS, self.PROGRESS_CATALOGS), "Creating workcat", True)
        if self.state != 2:
            self._create_workcat_id()
        self.progress_changed.emit("Create catalogs", lerp_progress(10, self.PROGRESS_OPTIONS, self.PROGRESS_CATALOGS), "Creating demand dscenario", True)
        self._create_demand_dscenario()
        self.progress_changed.emit("Create catalogs", lerp_progress(20, self.PROGRESS_OPTIONS, self.PROGRESS_CATALOGS), "Creating new node catalogs", True)
        self._create_new_node_catalogs()

        # Get existing catalogs in DB
        cat_arc_ids = get_rows("SELECT id FROM cat_arc", commit=self.force_commit)
        if cat_arc_ids:
            self.arccat_db += [x[0] for x in cat_arc_ids]

        self.progress_changed.emit("Create catalogs", lerp_progress(50, self.PROGRESS_OPTIONS, self.PROGRESS_CATALOGS), "Creating new varc catalogs", True)
        self._create_new_varc_catalogs()
        self.progress_changed.emit("Create catalogs", lerp_progress(70, self.PROGRESS_OPTIONS, self.PROGRESS_CATALOGS), "Creating new pipe catalogs", True)
        self._create_new_pipe_catalogs()

    def _manage_nonvisual(self) -> None:
        if self.network.num_patterns > 0:
            self.progress_changed.emit("Non-visual objects", lerp_progress(0, self.PROGRESS_CATALOGS, self.PROGRESS_NONVISUAL), "Importing patterns", True)
            self._save_patterns()

        if self.network.num_curves > 0:
            self.progress_changed.emit("Non-visual objects", lerp_progress(40, self.PROGRESS_CATALOGS, self.PROGRESS_NONVISUAL), "Importing curves", True)
            self._save_curves()

        if self.network.num_controls > 0:
            self.progress_changed.emit("Non-visual objects", lerp_progress(80, self.PROGRESS_CATALOGS, self.PROGRESS_NONVISUAL), "Importing controls and rules", True)
            self._save_controls_and_rules()

    def _manage_visual(self) -> None:
        if self.network.num_junctions > 0:
            self.progress_changed.emit("Visual objects", lerp_progress(0, self.PROGRESS_NONVISUAL, self.PROGRESS_VISUAL), "Importing junctions", True)
            self._save_junctions()

        if self.network.num_reservoirs > 0:
            self.progress_changed.emit("Visual objects", lerp_progress(30, self.PROGRESS_NONVISUAL, self.PROGRESS_VISUAL), "Importing reservoirs", True)
            self._save_reservoirs()

        if self.network.num_tanks > 0:
            self.progress_changed.emit("Visual objects", lerp_progress(40, self.PROGRESS_NONVISUAL, self.PROGRESS_VISUAL), "Importing tanks", True)
            self._save_tanks()

        if self.network.num_pumps > 0:
            self.progress_changed.emit("Visual objects", lerp_progress(50, self.PROGRESS_NONVISUAL, self.PROGRESS_VISUAL), "Importing pumps", True)
            self._save_pumps()

        if self.network.num_valves > 0:
            self.progress_changed.emit("Visual objects", lerp_progress(60, self.PROGRESS_NONVISUAL, self.PROGRESS_VISUAL), "Importing valves", True)
            self._save_valves()

        if self.network.num_pipes > 0:
            self.progress_changed.emit("Visual objects", lerp_progress(70, self.PROGRESS_NONVISUAL, self.PROGRESS_VISUAL), "Importing pipes", True)
            self._save_pipes()

    def _enable_triggers(self, enable: bool, plan_trigger: bool = False, geometry_trigger: bool = False) -> None:
        op = "ENABLE" if enable else "DISABLE"
        queries = [
            f'ALTER TABLE arc {op} TRIGGER ALL;',
            f'ALTER TABLE node {op} TRIGGER ALL;',
        ]
        if plan_trigger:
            queries.append('ALTER TABLE arc ENABLE TRIGGER gw_trg_plan_psector_after_arc;')
            queries.append('ALTER TABLE node ENABLE TRIGGER gw_trg_plan_psector_after_node;')
        if geometry_trigger:
            queries.append('ALTER TABLE node ENABLE TRIGGER gw_trg_topocontrol_node;')
        for sql in queries:
            result = tools_db.execute_sql(sql, commit=self.force_commit)
            if not result:
                return

    def _get_units(self) -> None:
        units = self.network.options.hydraulic.inpfile_units
        if not units:
            raise ValueError("Units not specified in the INP file.")
        self.db_units = units

    def _validate_inputs(self) -> None:
        if self.workcat in (None, ""):
            message = "Please enter a Workcat_id to proceed with this import."
            raise ValueError(message)

        if self.exploitation in (None, ""):
            message = "Please select an exploitation to proceed with this import."
            raise ValueError(message)

        if self.sector in (None, ""):
            message = "Please select a sector to proceed with this import."
            raise ValueError(message)

        if self.municipality in (None, ""):
            message = "Please select a municipality to proceed with this import."
            raise ValueError(message)
        if self.municipality == 999999:
            self.municipality = 0
            self.update_municipality = True

    def _save_options(self):
        """
            Import options to table 'config_param_user'.
            "hydraulic" -> inp_options_%
            "energy" -> inp_energy_%
            "reaction" -> inp_reactions_%
            "report" -> inp_report_%
            "time" -> inp_times_%
            "quality" -> inp_options_quality_mode??
        """
        # Define prefixes for each category
        prefix_map = {
            "time": "inp_times_",
            "hydraulic": "inp_options_",
            "report": "inp_report_",
            "quality": "inp_options_",
            "reaction": "inp_reactions_",
            "energy": "inp_energy_",
            # "graphics": "inp_graphics_",
            # "user": "inp_user_"
        }
        params_map = {
            "energy": {
                "global_price": "price",
                "global_pattern": "price_pattern",
                "global_efficiency": "pump_effic",
            },
            "time": {
            },
            "quality": {
                "parameter": "quality_mode",
                "trace_node": "node_id",
            },
            "reaction": {
                "bulk_coeff": "global_bulk",
                "wall_coeff": "global_wall",
                "limiting_potential": "limit_concentration",
                "roughness_correl": "wall_coeff_correlation",
            },
            "hydraulic": {
                "hydraulics_filename": "hydraulics_fname",
                "unbalanced_value": "unbalanced_n",
                "headerror": "max_headerror",
                "flowchange": "max_flowchange",
                "inpfile_units": "units",
            },
            "report": {
                "f-factor": "f_factor",
                "report_filename": "file",
            }
        }

        # List to accumulate parameters for batch update
        update_params = []

        options_dict = dict(self.network.options)

        def process_options(options, category):
            """Recursively process options, including nested dictionaries."""
            for key, value in options.items():
                if isinstance(value, dict):
                    # Recursively process nested dictionaries
                    process_options(value, category)
                else:
                    if category == "report" and type(value) is bool:
                        value = "YES" if value else "NO"
                    prefix = prefix_map.get(category, "inp_options_")
                    param_name = params_map[category].get(key.lower(), key.lower())
                    param_name = f"{prefix}{param_name}"
                    update_params.append((str(value), param_name))

        # Iterate over each category and its options
        for category, options in options_dict.items():
            if category in ("graphics", "user"):
                continue

            process_options(options, category)

        # SQL query for batch update
        sql = """
            UPDATE config_param_user
            SET value = data.value
            FROM (VALUES %s) AS data(value, parameter)
            WHERE config_param_user.parameter::text = data.parameter::text;
        """
        template = "(%s, %s)"

        if self.debug_mode:
            print("OPTIONS:")
            print(update_params)

        # Execute batch update
        toolsdb_execute_values(sql, update_params, template, fetch=False, commit=self.force_commit)

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
            commit=self.force_commit,
        )

    def _create_demand_dscenario(self):
        extras = '"parameters": {'
        extras += f'"name": "{self.dscenario}",'
        extras += '"descript": "Demand dscenario used when importing INP file",'
        extras += '"parent": null,'
        extras += '"type": "DEMAND",'
        extras += '"active": "true",'
        extras += f'"expl": "{self.exploitation}"'
        extras += '}'
        body = tools_gw.create_body(extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_create_dscenario_empty', body, commit=self.force_commit, is_thread=True)
        if not json_result or json_result.get('status') != 'Accepted':
            message = "Error executing gw_fct_create_dscenario_empty"
            raise ValueError(message)

        self.dscenario_id = json_result['body']['data'].get('dscenario_id')
        if self.dscenario_id is None:
            message = "Function gw_fct_create_dscenario_empty returned no dscenario_id"
            raise ValueError(message)

    def _create_new_node_catalogs(self):
        cat_node_ids = get_rows("SELECT id FROM cat_node", commit=self.force_commit)
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
                commit=self.force_commit,
            )
            nodecat_db.append(self.catalogs[node_type])

    def _create_new_varc_catalogs(self) -> None:
        varc_catalogs: list[str] = ["pumps", "valves"]

        # cat_mat_arc has an INSERT rule.
        # So it's not possible to use ON CONFLICT.
        # So, we perform a conditional INSERT here.
        execute_sql(
            """
            INSERT INTO cat_material (id, descript, feature_type)
            SELECT 'UNKNOWN', 'Unknown', '{NODE,ARC,CONNEC,ELEMENT}'
            WHERE NOT EXISTS (
                SELECT 1
                FROM cat_material
                WHERE id = 'UNKNOWN'
            );
            """,
            commit=self.force_commit,
        )

        for varc_type in varc_catalogs:
            if varc_type not in self.catalogs:
                continue

            if self.manage_nodarcs.get(varc_type):
                # Just create the 'VARC' catalog to temporarly insert them as varcs
                execute_sql("""
                    INSERT INTO cat_arc (id, arc_type, matcat_id, dint)
                    VALUES ('VARC', 'VARC', 'UNKNOWN', 999) ON CONFLICT DO NOTHING;
                """,
                commit=self.force_commit)
                continue

            if self.catalogs[varc_type] in self.arccat_db:
                continue

            # cat_mat_arc has an INSERT rule.
            # So it's not possible to use ON CONFLICT.
            # So, we perform a conditional INSERT here.
            execute_sql(
                """
                INSERT INTO cat_material (id, descript, feature_type)
                SELECT 'UNKNOWN', 'Unknown', '{NODE,ARC,CONNEC,ELEMENT}'
                WHERE NOT EXISTS (
                    SELECT 1
                    FROM cat_material
                    WHERE id = 'UNKNOWN'
                );
                """,
                commit=self.force_commit,
            )

            sql = """
                INSERT INTO cat_arc (id, arc_type, matcat_id, dint)
                VALUES (%s, %s, 'UNKNOWN', 999) ON CONFLICT DO NOTHING;
            """
            _id = self.catalogs[varc_type]
            arctype_id = self.catalogs["features"][varc_type]
            execute_sql(sql, (_id, arctype_id), commit=self.force_commit)
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
                print(catalog, arctype_id, material, pipe_dint)
                execute_sql(
                    sql, (catalog, arctype_id, material, pipe_dint), commit=self.force_commit
                )
                self.arccat_db.append(catalog)

    def _save_patterns(self):
        pattern_rows = get_rows("SELECT pattern_id FROM inp_pattern", commit=self.force_commit)
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
                commit=self.force_commit,
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
                execute_sql(sql, values, commit=self.force_commit)

    def _save_curves(self) -> None:
        curve_rows = get_rows("SELECT id FROM inp_curve", commit=self.force_commit)
        curves_db: set[str] = set()
        if curve_rows:
            curves_db = {x[0] for x in curve_rows}

        for curve_name, curve in self.network.curves.items():
            if curve.curve_type is None:
                message = f'The "{curve_name}" curve does not have a specified curve type and was not imported.'
                self._log_message(message)
                continue

            if curve_name in curves_db:
                for i in count(2):
                    new_name = f"{curve_name}_{i}"
                    if new_name in curves_db:
                        continue
                    message = f'The curve "{curve_name}" has been renamed to "{new_name}" to avoid a collision with an existing curve.'
                    self._log_message(message)
                    self.mappings["curves"][curve_name] = new_name
                    curve_name = new_name
                    break

            curve_type: str = curve.curve_type
            if curve.curve_type == "HEAD":
                curve_type = "PUMP"

            execute_sql(
                "INSERT INTO inp_curve (id, curve_type) VALUES (%s, %s)",
                (curve_name, curve_type),
                commit=self.force_commit,
            )

            for x, y in curve.points:
                if curve_type != "VOLUME":
                    x = from_si(FlowUnits[self.db_units], x, HydParam.Flow)
                execute_sql(
                    "INSERT INTO inp_curve_value (curve_id, x_value, y_value) VALUES (%s, %s, %s)",
                    (curve_name, x, y),
                    commit=self.force_commit,
                )

    def _save_controls_and_rules(self) -> None:
        from wntr.network.controls import Control, Rule

        controls_rows = get_rows("SELECT text FROM inp_controls", commit=self.force_commit)
        controls_db: set[str] = set()
        if controls_rows:
            controls_db = {x[0] for x in controls_rows}

        rules_rows = get_rows("SELECT text FROM inp_rules", commit=self.force_commit)
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
                execute_sql(sql, params, commit=self.force_commit)
            elif type(control) is Rule:
                text = f"RULE {control.name}" + "\n" + f"IF {condition}" + "\n" + f"THEN {' AND '.join(then_actions)}"
                if else_actions:
                    text += f"\nELSE {else_actions}"
                text += f"\nPRIORITY {priority}"
                if text in rules_db:
                    msg = f"The rule '{control_name}' is already on database. Skipping..."
                    self._log_message(msg)
                    continue

                sql = "INSERT INTO inp_rules (sector_id, text, active) VALUES (%s, %s, true)"
                params = (self.sector, text)
                execute_sql(sql, params, commit=self.force_commit)

    def _save_junctions(self) -> None:
        node_sql = """ 
            INSERT INTO node (
                the_geom, code, nodecat_id, epa_type, expl_id, sector_id, muni_id, state, state_type, workcat_id, top_elev
            ) VALUES %s
            RETURNING node_id, code
        """
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
        """
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
            state = self.state
            state_type = self.state_type
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
            node_sql, node_params, node_template, fetch=True, commit=self.force_commit
        )
        if self.debug_mode:
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
            inp_sql, inp_params, inp_template, fetch=False, commit=self.force_commit
        )
        # Insert into man table
        toolsdb_execute_values(
            man_sql, man_params, man_template, fetch=False, commit=self.force_commit
        )
        # Insert demands into dscenario table
        toolsdb_execute_values(
            demands_sql, demands_params, demands_template, fetch=False, commit=self.force_commit
        )

    def _save_reservoirs(self) -> None:
        feature_class = self.catalogs['features']['reservoirs'].lower()

        node_sql = """ 
            INSERT INTO node (
                the_geom, code, nodecat_id, epa_type, expl_id, sector_id, muni_id, state, state_type, workcat_id
            ) VALUES %s
            RETURNING node_id, code
        """
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
        """
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
            state = self.state
            state_type = self.state_type
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
            node_sql, node_params, node_template, fetch=True, commit=self.force_commit
        )
        if self.debug_mode:
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
            inp_sql, inp_params, inp_template, fetch=False, commit=self.force_commit
        )
        # Insert into man table
        toolsdb_execute_values(
            man_sql, man_params, man_template, fetch=False, commit=self.force_commit
        )

    def _save_tanks(self) -> None:
        feature_class = self.catalogs['features']['tanks'].lower()

        node_sql = """ 
            INSERT INTO node (
                the_geom, code, nodecat_id, epa_type, expl_id, sector_id, muni_id, state, state_type, workcat_id, top_elev
            ) VALUES %s
            RETURNING node_id, code
        """
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
        """
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
            state = self.state
            state_type = self.state_type
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
            node_sql, node_params, node_template, fetch=True, commit=self.force_commit
        )
        if self.debug_mode:
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
            inp_sql, inp_params, inp_template, fetch=False, commit=self.force_commit
        )
        # Insert into man table
        toolsdb_execute_values(
            man_sql, man_params, man_template, fetch=False, commit=self.force_commit
        )

    def _save_pumps(self) -> None:
        feature_class = self.catalogs['features']['pumps'].lower()
        arccat_id = self.catalogs["pumps"]
        # Set 'fake' catalogs if it will be converted to flwreg
        if self.manage_nodarcs["pumps"]:
            feature_class = "VARC"
            arccat_id = "VARC"

        arc_sql = """ 
            INSERT INTO arc (
                the_geom, code, node_1, node_2, arccat_id, epa_type, expl_id, sector_id, muni_id, state, state_type, workcat_id
            ) VALUES %s
            RETURNING arc_id, code
        """
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
        """
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
            epa_type = "VIRTUALPUMP"
            expl_id = self.exploitation
            sector_id = self.sector
            muni_id = self.municipality
            state = self.state
            state_type = self.state_type
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
                inp_dict[p_name]["pump_type"] = "POWERPUMP"
            elif p.pump_type == "HEAD":
                inp_dict[p_name]["curve_id"] = p.pump_curve_name
                inp_dict[p_name]["pump_type"] = "HEADPUMP"

        # Insert into parent table
        pumps = toolsdb_execute_values(
            arc_sql, arc_params, arc_template, fetch=True, commit=self.force_commit
        )
        if self.debug_mode:
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
            inp_sql, inp_params, inp_template, fetch=False, commit=self.force_commit
        )
        # Insert into man table
        toolsdb_execute_values(
            man_sql, man_params, man_template, fetch=False, commit=self.force_commit
        )

    def _save_valves(self) -> None:
        arc_sql = """ 
            INSERT INTO arc (
                the_geom, code, node_1, node_2, arccat_id, epa_type, expl_id, sector_id, muni_id, state, state_type, workcat_id
            ) VALUES %s
            RETURNING arc_id, code
        """
        arc_template = (
            "(ST_GeomFromText(%s, %s), %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        )

        man_sql_template = """
            INSERT INTO man_{feature_class} (
                arc_id
            ) VALUES %s
        """
        man_template = "(%s)"

        inp_sql = """
            INSERT INTO inp_virtualvalve (
                arc_id, valve_type, setting, diameter, curve_id, minorloss, status, init_quality
            ) VALUES %s
        """
        inp_template = "(%s, %s, %s, %s, %s, %s, %s, %s)"

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

            valve_type = v.valve_type.lower()
            # Get valve-specific feature class and arccat_id
            feature_class = self.catalogs["features"][valve_type]
            arccat_id = self.catalogs[valve_type]

            # Convert to node if required
            if self.manage_nodarcs.get(valve_type, False):
                feature_class = "VARC"
                arccat_id = "VARC"

            arc_params.append(
                (
                    geometry, srid,  # the_geom
                    v_name,  # code
                    node_1,
                    node_2,
                    arccat_id,
                    "VIRTUALVALVE",
                    self.exploitation,
                    self.sector,
                    self.municipality,
                    self.state,
                    self.state_type,
                    self.workcat,
                )
            )

            inp_dict[v_name] = {
                "valve_type": v.valve_type,
                "diameter": v.diameter,
                "setting": v.initial_setting,
                "curve_id": None,
                "minorloss": v.minor_loss,
                "status": v.initial_status.name.upper(),
                "init_quality": None,
                "feature_class": feature_class,  # Store feature_class for later use
            }

        # Insert into parent table
        valves = toolsdb_execute_values(
            arc_sql, arc_params, arc_template, fetch=True, commit=self.force_commit
        )
        if not valves:
            self._log_message("Valves couldn't be inserted!")
            return

        man_params = {}
        inp_params = []

        for v in valves:
            arc_id = v[0]
            code = v[1]
            feature_class = inp_dict[code]["feature_class"]

            if feature_class not in man_params:
                man_params[feature_class] = []
            man_params[feature_class].append((arc_id,))

            inp_data = inp_dict[code]
            inp_params.append(
                (arc_id, inp_data["valve_type"], inp_data["setting"], inp_data["diameter"], inp_data["curve_id"],
                inp_data["minorloss"], inp_data["status"], inp_data["init_quality"])
            )

        # Insert into inp table
        toolsdb_execute_values(
            inp_sql, inp_params, inp_template, fetch=False, commit=self.force_commit
        )

        # Insert into each man table separately
        for feature_class, params in man_params.items():
            man_sql = man_sql_template.format(feature_class=feature_class)
            toolsdb_execute_values(
                man_sql, params, man_template, fetch=False, commit=self.force_commit
            )

    def _save_pipes(self) -> None:
        feature_class = self.catalogs['features']['pipes'].lower()

        arc_sql = """ 
            INSERT INTO arc (
                the_geom, code, node_1, node_2, arccat_id, epa_type, expl_id, sector_id, muni_id, state, state_type, workcat_id
            ) VALUES %s
            RETURNING arc_id, code
        """
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
        """
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
            arccat_id = self.catalogs["pipes"][(round(p.diameter * 1000, 0), p.roughness)]
            epa_type = "PIPE"
            expl_id = self.exploitation
            sector_id = self.sector
            muni_id = self.municipality
            state = self.state
            state_type = self.state_type
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
            arc_sql, arc_params, arc_template, fetch=True, commit=self.force_commit
        )
        if self.debug_mode:
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
            if self.debug_mode:
                print(inp_params)

        # Insert into inp table
        toolsdb_execute_values(
            inp_sql, inp_params, inp_template, fetch=False, commit=self.force_commit
        )
        # Insert into man table
        toolsdb_execute_values(
            man_sql, man_params, man_template, fetch=False, commit=self.force_commit
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
            row = get_row(sql, params, commit=self.force_commit)
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
            execute_sql(sql, params, commit=self.force_commit)

    def _manage_nodarcs(self) -> str:
        """ Transform pumps and valves into nodes """

        extras = ""
        for k, v in self.manage_nodarcs.items():
            if not v:
                continue
            extras += f'"{k}": {{"featureClass": "{self.catalogs["features"][k]}", "catalog": "{self.catalogs[k]}"}},'

        if extras:
            fct_name = "gw_fct_import_epanet_nodarcs"
            extras = extras[:-1]
            body = tools_gw.create_body(extras=extras)
            json_result = tools_gw.execute_procedure(fct_name, body, commit=self.force_commit, is_thread=True)
            if not json_result or json_result.get('status') != 'Accepted':
                message = f"Error executing {fct_name} - {json_result.get('message')}"
                raise ValueError(message)
            try:
                if json_result['body']['data']['info']:
                    info = json_result['body']['data']['info']
                    if isinstance(info, list):
                        logs = [x.get('message') for x in info]
                        logs_str = '\n'.join(logs)
                        return logs_str
            except KeyError:
                pass
            return ""
        return "No nodarcs to manage"

    def _update_municipality(self):
        """ Update the muni_id of all features getting the spatial intersection with the municipality """

        sql = """
            UPDATE node n SET muni_id = (SELECT m.muni_id FROM ext_municipality m WHERE ST_Intersects(m.the_geom, n.the_geom) LIMIT 1) WHERE EXISTS (SELECT 1 FROM ext_municipality m WHERE ST_Intersects(m.the_geom, n.the_geom));
            UPDATE arc a SET muni_id = (SELECT m.muni_id FROM ext_municipality m WHERE ST_Intersects(m.the_geom, a.the_geom) LIMIT 1) WHERE EXISTS (SELECT 1 FROM ext_municipality m WHERE ST_Intersects(m.the_geom, a.the_geom));
        """
        execute_sql(sql, commit=self.force_commit)

    def _log_message(self, message: str):
        self.log.append(message)
        self.progress_changed.emit("", None, f"{message}", True)
