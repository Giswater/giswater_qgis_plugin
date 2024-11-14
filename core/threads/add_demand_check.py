"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
"""

import copy
import csv
import itertools
import json
import math
import subprocess
import uuid
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

from qgis.core import QgsTask

from .task import GwTask
from ...libs import tools_db, tools_log

try:
    import wntr
    from wntr.epanet.util import from_si, to_si, FlowUnits, HydParam
except ImportError:
        tools_log.log_error("Couldn't import WNTR Python package. Please check if the Giswater plugin is installed and it has a 'packages' folder in it with 'wntr'.")


class GwAddDemandCheck(GwTask):
    def __init__(
        self, description, input_file, config, output_folder, file_name, results={}
    ):
        super().__init__(description, QgsTask.CanCancel)
        self.input_file = input_file
        self.config = config
        self.output_folder = output_folder
        self.file_name = file_name
        self.partial_file = Path(output_folder) / f"{file_name}-partial.json"
        self.results = results
        self.accuracy = 0.001
        self.executed_simulations = 0
        self.qtd_nodes = len(self.config.junctions)
        self.total_simulations = 2 * self.qtd_nodes + math.comb(self.qtd_nodes, 2)

    def run(self):
        if not self._execute_check_suite():
            return False
        self.cur_step += "\n\nSaving files..."
        self._save_csv_file()
        self._save_in_file()
        self._save_results_to_db()
        self.partial_file.unlink(missing_ok=True)
        return True

    def _check_individual_nodes(self):
        old_steps = self.cur_step
        self.cur_step = old_steps + "\n\nChecking individual nodes..."

        i = 0
        with ThreadPoolExecutor(max_workers=5) as executor:
            for node_name, result in executor.map(
                self._check_node,
                self.config.junctions.keys(),
                self.config.junctions.values(),
            ):
                i += 1

                if self.isCanceled():
                    return False

                self.cur_step = (
                    old_steps
                    + f"\n\nChecking individual nodes ({i}/{self.qtd_nodes})..."
                )

                # Skip node if already done in previous execution
                if result is None:
                    self._update_pairs(node_name)
                    self.total_simulations = (
                        self.executed_simulations
                        + 2 * (self.qtd_nodes - i - 2)
                        + len(self.pairs)
                    )
                    continue

                self.results[node_name] = result

                self._update_pairs(node_name)
                self.total_simulations = (
                    self.executed_simulations
                    + 2 * (self.qtd_nodes - i - 2)
                    + len(self.pairs)
                )

                if self.executed_simulations % 10 == 0:
                    self._save_partial()

        return True

    def _check_node(self, node_name, node):
        dem = node["requiredDemand"]
        press = node["requiredPressure"]

        # Skip node if already done in previous execution
        if node_name in self.results:
            self.executed_simulations += 1
            return node_name, None

        if node_name not in self.network.node_name_list:
            self.executed_simulations += 1
            return node_name, {"error": "Node not found in INP file."}

        # Run double test fist
        double_demand_node = {
            "name": node_name,
            "requiredDemand": 2 * dem,
            "requiredPressure": press,
        }
        test = self._execute_individual_check([double_demand_node])
        double_test = test[node_name]
        self.executed_simulations += 1

        # Use result of double test to check for need of simple test
        if (
            double_test["modelDemand"] + self.accuracy >= dem
            and double_test["modelPressure"] + self.accuracy >= press
        ):
            simple_test = {"status": "ok"}
        elif (
            double_test["modelDemand"] + self.accuracy < dem
            and double_test["modelPressure"] + self.accuracy < press
        ):
            simple_test = {
                "status": "failed",
                "requiredDemand": dem,
                "requiredPressure": press,
                "modelDemand": double_test["modelDemand"],
                "modelPressure": double_test["modelPressure"],
            }
        else:
            test = self._execute_individual_check([node])
            simple_test = test[node_name]
            self.executed_simulations += 1

        return node_name, {
            "simple": simple_test,
            "doubled": double_test,
            "paired": {"status": None},
        }

    def _check_pair(self, pair):
        node1_name, node2_name = pair
        node1 = self.config.junctions[node1_name]
        node2 = self.config.junctions[node2_name]

        # Skip pair if already done in previous execution
        if node2_name in self.results[node1_name]["paired"]:
            self.executed_simulations += 1
            return None

        pair_test = self._execute_individual_check([node1, node2])
        self.executed_simulations += 1

        return pair_test

    def _check_pairs(self):
        qtd_pairs = len(self.pairs)
        old_steps = self.cur_step
        self.cur_step = old_steps + "\n\nChecking node pairs..."

        i = 0
        with ThreadPoolExecutor(max_workers=5) as executor:
            for result in executor.map(self._check_pair, self.pairs):
                i += 1
                self.cur_step = (
                    old_steps + f"\n\nChecking node pairs ({i}/{qtd_pairs})..."
                )

                if self.isCanceled():
                    return False

                # Skip pair if already done in previous execution
                if result is None:
                    continue

                node1_name, node2_name = result.keys()

                for first, second in itertools.permutations((node1_name, node2_name)):
                    if self.results[first]["paired"]["status"] is None:
                        self.results[first]["paired"]["status"] = result[first][
                            "status"
                        ]
                    elif result[first]["status"] == "failed":
                        self.results[first]["paired"]["status"] = "failed"
                    self.results[first]["paired"][second] = result[first]

        return True

    def _create_network(self):
        self.cur_step = "Preparing network model..."
        wn = wntr.network.read_inpfile(self.input_file)
        self.adjusted_demands = wntr.metrics.hydraulic.average_expected_demand(wn)

        # Replace demands with the adjusted demands
        wn.add_pattern("constant_pattern", [1])
        pat = wn.get_pattern("constant_pattern")
        for junction_name, junction in wn.junctions():
            junction.demand_timeseries_list.clear()
            junction.demand_timeseries_list.append(
                (self.adjusted_demands[junction_name], pat)
            )

        wn.options.time.duration = 0
        wn.options.hydraulic.demand_multiplier = 1

        self.network = wn
        self.pairs = self._get_initial_pairs()
        self.total_simulations = 2 * self.qtd_nodes + len(self.pairs)

    def _distance_between(self, p1, p2):
        x1, y1 = p1["x"], p1["y"]
        x2, y2 = p2["x"], p2["y"]
        return math.sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2)

    def _execute_check_suite(self):
        self._create_network()
        if not self._check_individual_nodes():
            return False
        if not self._check_pairs():
            return False
        return True

    def _execute_individual_check(self, nodes):
        test_wn = copy.deepcopy(self.network)
        units = test_wn.options.hydraulic.inpfile_units
        pat = test_wn.get_pattern("constant_pattern")
        for node in nodes:
            junction = test_wn.get_node(node["name"])
            demand = to_si(FlowUnits[units], node["requiredDemand"], HydParam.Demand)
            junction.demand_timeseries_list.append((demand, pat))

        prefix = str(Path.home() / ".temp/") + str(uuid.uuid4()).split("-")[0]
        results = wntr.sim.EpanetSimulator(test_wn).run_sim(file_prefix=prefix).node

        test_results = {}
        for node in nodes:
            node_extra_demand = (
                results["demand"][node["name"]][0].item()
                - self.adjusted_demands[node["name"]]
            )
            model_demand = from_si(
                FlowUnits[units],
                node_extra_demand,
                HydParam.Demand,
            )
            model_pressure = from_si(
                FlowUnits[units],
                results["pressure"][node["name"]][0].item(),
                HydParam.Pressure,
            )
            status = (
                "ok"
                if node["requiredDemand"] <= model_demand + self.accuracy
                and node["requiredPressure"] <= model_pressure + self.accuracy
                else "failed"
            )
            node_result = {
                "status": status,
                "requiredDemand": node["requiredDemand"],
                "requiredPressure": node["requiredPressure"],
                "modelDemand": model_demand,
                "modelPressure": model_pressure,
            }
            test_results[node["name"]] = node_result

        return test_results

    def _get_initial_pairs(self):
        """Get initial set of pairs, based on maximum distance"""
        points = []
        nodes = set(self.config.junctions) & set(self.network.node_name_list)

        for node in nodes:
            x, y = self.network.get_node(node).coordinates
            points.append({"id": node, "x": x, "y": y})

        pairs = set()
        while points:
            p1 = points.pop()
            for p2 in points:
                dist = self._distance_between(p1, p2)
                if dist <= self.config.options["max_distance"]:
                    pairs.add((p1["id"], p2["id"]))
        return pairs

    def _save_csv_file(self):
        file_path = Path(self.output_folder) / f"{self.file_name}.csv"
        header = [
            "node_id",
            "x",
            "y",
            "error",
            "simple",
            "doubled",
            "paired",
            "addparam",
        ]
        with open(file_path, "w", newline="") as csvfile:
            csvwriter = csv.writer(csvfile)
            csvwriter.writerow(header)
            for node_name, test_results in self.results.items():
                error = "error" in test_results
                x, y = (
                    (None, None)
                    if error
                    else self.network.get_node(node_name).coordinates
                )
                simple = None if error else test_results["simple"]["status"]
                doubled = None if error else test_results["doubled"]["status"]
                paired = None if error else test_results["paired"]["status"]
                addparam = json.dumps(test_results)
                csvwriter.writerow(
                    [node_name, x, y, error, simple, doubled, paired, addparam]
                )

    def _save_in_file(self):
        file_path = Path(self.output_folder) / f"{self.file_name}.in"
        o = self.config.options
        with open(file_path, "w") as infile:
            infile.write("[OPTIONS]\n")
            infile.write(f"max_distance           {o['max_distance']}\n")
            infile.write("\n[JUNCTIONS]\n")
            for node in self.config.junctions.values():
                name = node["name"]
                demand = node["requiredDemand"]
                pressure = node["requiredPressure"]
                infile.write(f"{name}\t{demand}\t{pressure}\n")

    def _save_partial(self):
        with open(self.partial_file, "w") as file:
            json.dump(self.results, file)

    def _save_results_to_db(self):
        self.cur_step += "\n\nSaving results to DB..."
        tools_db.execute_sql(
            """
            delete from anl_node
            where fid = 492 and cur_user = current_user;

            insert into anl_node (
                node_id,
                fid,
                nodecat_id,
                expl_id,
                cur_user,
                the_geom
            )
            select
                node_id,
                492,
                nodecat_id,
                expl_id,
                cur_user,
                the_geom
            from anl_node
            where fid = 491 and cur_user = current_user;
            """
        )
        tools_db.execute_sql(self._update_addparam_sql_string())

    def _update_addparam_sql_string(self):
        template = """
            update anl_node
            set addparam = '{json}'
            where fid = 492 and cur_user = current_user and node_id = '{node_id}';
            """
        sql = ""
        for node_name, test_results in self.results.items():
            addparam = json.dumps(test_results, indent=2)
            sql += template.format(json=addparam, node_id=node_name)

        return sql

    def _update_pairs(self, node_name):
        if "error" in self.results[node_name]:
            return
        if self.results[node_name]["simple"]["status"] == "failed":
            to_delete = set()
            for pair in self.pairs:
                n1, n2 = pair
                if node_name == n1 or node_name == n2:
                    to_delete.add(pair)
            self.pairs -= to_delete
        elif self.results[node_name]["doubled"]["status"] == "ok":
            to_delete = set()
            for pair in self.pairs:
                n1, n2 = pair
                if (
                    n1 == node_name
                    and n2 in self.results
                    and self.results[n2]["doubled"]["status"] == "ok"
                ) or (
                    n2 == node_name
                    and n1 in self.results
                    and self.results[n1]["doubled"]["status"] == "ok"
                ):
                    to_delete.add(pair)
            self.pairs -= to_delete
