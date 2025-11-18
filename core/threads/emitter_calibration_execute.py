"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
import matplotlib.pyplot as plt
import pandas as pd

from copy import deepcopy
from pathlib import Path

from qgis.PyQt.QtCore import pyqtSignal, QObject
from qgis.core import QgsTask

from ... import global_vars
from ...libs import tools_log

try:
    import wntr
    from wntr.network import write_inpfile
    from wntr.sim import EpanetSimulator
except ImportError:
    wntr = None
    write_inpfile = None
    EpanetSimulator = None


class EmitterCalibrationExecute(QgsTask, QObject):
    """This shows how to subclass QgsTask"""

    task_finished = pyqtSignal(list)

    def __init__(
        self,
        description,
        network,
        results,
        config,
        output_file,
        file_name,
        timer,
    ):

        QObject.__init__(self)
        super().__init__(description, QgsTask.Flag.CanCancel)
        self.exception = None
        self.timer = timer

        self.network = network
        self.method = "linear"
        self.delete_extra_points = False
        self.coeff_dma_result = {}
        self.results = results
        self.trials = config.options["trials"]
        self.accuracy = config.options["accuracy"]
        self.config = config
        self.output_folder = output_file
        self.file_name = file_name
        self.efficiency = config.options["default_efficiency"]
        self.emitter = config.options["default_emitter"]

        self.current_dma = None
        self.current_trial = None

        self.result_log = ""

    def run(self):

        # Step 2: Run EPANET iterations to find emitter coefficient
        self._run_iterations()
        # Step 3:
        self._export_network()

        self.task_finished.emit([True, self.result_log])

        return True

    def finished(self, result):

        if self.timer:
            self.timer.stop()

        if result:
            msg = "Task '{0}' completed"
            msg_params = (self.description(),)
            tools_log.log_info(msg, msg_params=msg_params)
        else:
            if self.exception is None:
                msg = "Task '{0}' not successful but without exception"
                msg_params = (self.description(),)
                tools_log.log_info(msg, msg_params=msg_params)
            else:
                msg = "Task '{0}' Exception: {1}"
                msg_params = (self.description(), self.exception,)
                tools_log.log_info(msg, msg_params=msg_params)

    def _run_iterations(self):

        network_junctions = {}
        network_junctions["all_network"] = []
        junctions_by_dma = {}
        network_demand = 0
        effc_by_dma = {"0": f"{self.efficiency}"}
        demand_by_dma = {"0": 0}
        sum_dem_x_c0 = 0
        sum_dem = 0
        junctions_coeff_cal = {}
        network = deepcopy(self.network)

        # Populate all_juntions list and junctions_by_dma json variables
        self._populate_junctions_variables(network_junctions, junctions_by_dma)

        # Populate effc_by_dma and set keys for demand_by_dma
        demand_by_dma, expected_demand = self._populate_effc_demand_variables(
            network_junctions, network_demand, effc_by_dma, demand_by_dma, sum_dem_x_c0, sum_dem
        )

        # -----------------------------------
        # RECURSIVITY FOR ALL NETWORK
        # -----------------------------------

        self.current_dma = "All Network"

        # 2 -------------------- add emitters
        self.min_coeff_mult = 0
        self.mid_coeff_mult = 1
        self.max_coeff_mult = 2

        df_dict = {"coeff": [], "demand": []}
        idx = 0
        interpolated_idx = -1
        interpolated_idx = self._add_emitters_loop(network_junctions, network, expected_demand, df_dict, idx)

        # Check that there is data
        if len(df_dict["demand"]) == 0:
            raise Exception("No demands")
        # Check that objective demand is between limits
        if expected_demand not in df_dict["demand"]:
            raise Exception(
                f"Demand ({expected_demand}) is outside the range of coeff allowed"
            )
        demands_list_plt = []
        # 3 ----- run iterations interpolating
        network = self._run_iterations_interpolating(
            network_junctions, sum_dem, junctions_coeff_cal, expected_demand,
            df_dict, interpolated_idx, demands_list_plt
        )

        self.network = network

        # -----------------------------------
        # RECURSIVITY FOR EACH DMA
        # -----------------------------------

        for dma_id in effc_by_dma:

            # Manage demand_by_dma[dma_id] if is None:
            if network_junctions.get(dma_id) is None:
                continue

            # Set current dma
            self.current_dma = dma_id

            # Get junction demands sum (without emitters) - First epanet
            # Multiply demands by effc - get total_demand
            if effc_by_dma[dma_id] in (None, ""):
                effc = self.efficiency
            else:
                effc = effc_by_dma[dma_id]
            expected_demand = float(demand_by_dma[dma_id]) / float(effc)

            # 2 -------------------- add emitters
            self.min_coeff_mult = 0
            self.mid_coeff_mult = 1.5
            self.max_coeff_mult = 3

            df_dict = {"coeff": [], "demand": []}
            idx = 0
            interpolated_idx = -1
            for l_coeff in [
                self.min_coeff_mult,
                self.mid_coeff_mult,
                self.max_coeff_mult,
            ]:
                # Set emitter coefficients
                for junction_name, junction in network.junctions():
                    if junction_name not in network_junctions[dma_id]:
                        continue
                    junction_coeff = junctions_coeff_cal[junction_name]
                    if junction_coeff is None:
                        continue
                    junction.emitter_coefficient = float(junction_coeff) * l_coeff

                # Run simulation
                self.sim = EpanetSimulator(network)
                self.results = self.sim.run_sim()

                # Get demand by dma
                first_calculed_demands = self._get_total_demand(
                    network_junctions[dma_id]
                )
                # Add values to df_dict
                if (
                    idx > 0
                    and df_dict["demand"][idx - 1]
                    < expected_demand
                    < first_calculed_demands
                ):
                    df_dict["coeff"].append(None)
                    df_dict["demand"].append(expected_demand)
                    interpolated_idx = idx

                df_dict["coeff"].append(l_coeff)
                df_dict["demand"].append(first_calculed_demands)

                idx += 1

            # Check that there is data
            if len(df_dict["demand"]) == 0:
                raise Exception("No demands")
            # Check that objective demand is between limits
            if expected_demand not in df_dict["demand"]:
                raise Exception(
                    f"Demand ({expected_demand}) is outside the range of coeff allowed"
                )
            demands_list_plt = []
            # 3 ----- run iterations interpolating
            for trial in range(self.trials):

                # Set current trial
                self.current_trial = trial

                # Create dataframe
                df = pd.DataFrame(df_dict)
                # Interpolate NaN values
                interpolated_df = df.interpolate(method=self.method)

                # Run epanet with coeff = interpolated value
                coeff = interpolated_df["coeff"][interpolated_idx]
                network = deepcopy(self.network)
                # Set emitter coefficients
                for junction_name, junction in network.junctions():

                    if junction_name not in network_junctions[dma_id]:
                        continue

                    junction_coeff = junctions_coeff_cal[junction_name]
                    if junction_coeff is None:
                        continue
                    junction.emitter_coefficient = float(junction_coeff) * coeff

                # Run simulation
                self.sim = EpanetSimulator(network)
                self.results = self.sim.run_sim()

                # Get demand by dma
                calculated_demands = self._get_total_demand(network_junctions[dma_id])
                demands_list_plt.append(calculated_demands)
                if abs(calculated_demands - expected_demand) < self.accuracy:
                    if not self.delete_extra_points:
                        plt.cla()
                        plt.plot(demands_list_plt, label="demand")
                        ax = plt.subplot()
                        ax.plot(trial, expected_demand, "or", label="expected demand")
                        # plt.axhline(y=expected_demand, linewidth=3, color='r', linestyle='dotted')
                        plt.legend()
                        folder_dir = (
                            Path(global_vars.plugin_dir)
                            / "resources"
                            / "emitter_calibration"
                            / "png"
                        )
                        folder_dir.mkdir(parents=True, exist_ok=True)
                        plt.savefig(folder_dir / f"demand_dma_{dma_id}_plt.png")

                    self.coeff_dma_result[dma_id] = {}
                    self.coeff_dma_result[dma_id]["coeff"] = coeff
                    self.coeff_dma_result[dma_id]["sum_demands"] = calculated_demands

                    # Fill info log
                    self.result_log = (
                        f"{self.result_log}\n"
                        f"- DMA: {dma_id} (Trial:{trial})\n"
                        f'- Demand without emitters: {"{:.8f}".format(demand_by_dma[dma_id])}\n'
                        f'- Demand expected: {"{:.8f}".format(expected_demand)}\n'
                        f'- Demand result: {"{:.8f}".format(calculated_demands)}\n'
                        f'- Coef: {"{:.3f}".format(coeff)}\n\n'
                    )
                    break

                df_dict["coeff"][interpolated_idx] = coeff
                df_dict["demand"][interpolated_idx] = calculated_demands

                # Delete farthest point from dataframe
                if self.delete_extra_points:
                    if interpolated_idx == 1:
                        df_dict["coeff"].pop(len(df_dict["coeff"]) - 1)
                        df_dict["demand"].pop(len(df_dict["demand"]) - 1)
                    elif interpolated_idx == 2:
                        df_dict["coeff"].pop(0)
                        df_dict["demand"].pop(0)
                        interpolated_idx -= 1

                # Now with this dataframe we insert [None, p_f] and interpolate again
                for i in range(len(df_dict["coeff"]) - 1):
                    if (
                        df_dict["demand"][i]
                        < expected_demand
                        < df_dict["demand"][i + 1]
                    ):
                        df_dict["coeff"].insert(i + 1, None)
                        df_dict["demand"].insert(i + 1, expected_demand)
                        interpolated_idx = i + 1
                        break
                self.trial = trial + 1

        self.network = network

    def _run_iterations_interpolating(self, network_junctions, sum_dem, junctions_coeff_cal, expected_demand, df_dict, interpolated_idx, demands_list_plt):
        for trial in range(self.trials):
            # Set current trial
            self.current_trial = trial

            # Create dataframe
            df = pd.DataFrame(df_dict)
            # Interpolate NaN values
            interpolated_df = df.interpolate(method=self.method)

            # Run epanet with coeff = interpolated value
            coeff = interpolated_df["coeff"][interpolated_idx]
            network = deepcopy(self.network)
            # Set emitter coefficients
            for junction_name, junction in network.junctions():
                junction_json = self.config.emitters.get(junction_name)
                if junction_json is None:
                    continue
                junction.emitter_coefficient = (
                    float(junction_json["coefficient"]) * coeff
                )
            # Run simulation
            self.sim = EpanetSimulator(network)
            self.results = self.sim.run_sim()

            # Get demand for all network
            calculated_demands = self._get_total_demand(
                network_junctions["all_network"]
            )
            demands_list_plt.append(calculated_demands)
            if abs(calculated_demands - expected_demand) < self.accuracy:
                for junction_name, junction in network.junctions():
                    junctions_coeff_cal[junction_name] = junction.emitter_coefficient

                if not self.delete_extra_points:
                    plt.cla()
                    plt.plot(demands_list_plt, label="demand")
                    ax = plt.subplot()
                    ax.plot(trial, expected_demand, "or", label="expected_demand")
                    plt.legend()
                    folder_dir = (
                        Path(global_vars.plugin_dir)
                        / "resources"
                        / "emitter_calibration"
                        / "png"
                    )
                    folder_dir.mkdir(parents=True, exist_ok=True)
                    plt.savefig(folder_dir / "demand_all_network_plt.png")

                self.coeff_dma_result["all_network"] = {}
                self.coeff_dma_result["all_network"]["coeff"] = coeff
                self.coeff_dma_result["all_network"]["sum_demands"] = calculated_demands

                # Fill info log
                self.result_log = (
                    f"{self.result_log}\n"
                    f"- All Network: (Trial:{trial})\n"
                    f'- Demand without emitters: {"{:.8f}".format(sum_dem)}\n'
                    f'- Demand expected: {"{:.8f}".format(expected_demand)}\n'
                    f'- Demand result: {"{:.8f}".format(calculated_demands)}\n'
                    f'- Coef: {"{:.3f}".format(coeff)}\n\n'
                )
                break

            df_dict["coeff"][interpolated_idx] = coeff
            df_dict["demand"][interpolated_idx] = calculated_demands

            # Delete farthest point from dataframe
            if self.delete_extra_points:
                if interpolated_idx == 1:
                    df_dict["coeff"].pop(len(df_dict["coeff"]) - 1)
                    df_dict["demand"].pop(len(df_dict["demand"]) - 1)
                elif interpolated_idx == 2:
                    df_dict["coeff"].pop(0)
                    df_dict["demand"].pop(0)
                    interpolated_idx -= 1

            # Now with this dataframe we insert [None, p_f] and interpolate again
            for i in range(len(df_dict["coeff"]) - 1):
                if df_dict["demand"][i] < expected_demand < df_dict["demand"][i + 1]:
                    df_dict["coeff"].insert(i + 1, None)
                    df_dict["demand"].insert(i + 1, expected_demand)
                    interpolated_idx = i + 1
                    break
            self.trial = trial + 1
        return network

    def _add_emitters_loop(self, network_junctions, network, expected_demand, df_dict, idx):
        for l_coeff in [self.min_coeff_mult, self.mid_coeff_mult, self.max_coeff_mult]:
            # Set emitter coefficients
            for junction_name, junction in network.junctions():
                junction_json = self.config.emitters.get(junction_name)
                if junction_json is None or junction_json["coefficient"] is None:
                    junction.emitter_coefficient = float(self.emitter) * l_coeff
                else:
                    junction.emitter_coefficient = (
                        float(junction_json["coefficient"]) * l_coeff
                    )

            # Run simulation
            self.sim = EpanetSimulator(network)
            self.results = self.sim.run_sim()

            # Get demand for all network
            first_calculed_demands = self._get_total_demand(
                network_junctions["all_network"]
            )
            # Add values to df_dict
            if (
                idx > 0
                and df_dict["demand"][idx - 1]
                < expected_demand
                < first_calculed_demands
            ):
                df_dict["coeff"].append(None)
                df_dict["demand"].append(expected_demand)
                interpolated_idx = idx
            df_dict["coeff"].append(l_coeff)
            df_dict["demand"].append(first_calculed_demands)

            idx += 1
        return interpolated_idx

    def _populate_effc_demand_variables(self, network_junctions, network_demand, effc_by_dma, demand_by_dma, sum_dem_x_c0, sum_dem):
        for k, v in self.config.dmas.items():
            dma = v["dma_id"]
            effc_by_dma[dma] = v["efficiency"]
            demand_by_dma[dma] = 0

        for junction in network_junctions["all_network"]:
            try:
                demand = self.results.node["demand"].loc[:, junction]
                junction_demand = demand.sum().sum()
                network_demand += junction_demand
            except Exception:
                continue
        for dma_id in effc_by_dma:
            dma_demand = 0
            if network_junctions.get(dma_id) is None:
                continue
            for junction in network_junctions[dma_id]:
                try:
                    demand = self.results.node["demand"].loc[:, junction]
                    junction_demand = demand.sum().sum()
                    dma_demand += junction_demand
                except Exception:
                    continue
            # Multiply demands for work with wntr units
            demand_by_dma[dma_id] = dma_demand * 1000

            sum_dem_x_c0 += float(demand_by_dma[dma_id]) * float(effc_by_dma[dma_id])
            sum_dem += float(demand_by_dma[dma_id])
        c0_m = float(sum_dem_x_c0) / float(sum_dem)
        expected_demand = float(sum_dem) / float(c0_m)
        demand_by_dma = dict(
            sorted(demand_by_dma.items(), key=lambda item: item[1], reverse=True)
        )

        return demand_by_dma, expected_demand

    def _populate_junctions_variables(self, network_junctions, junctions_by_dma):
        for k, v in self.config.junctions.items():
            dma_id = v["dma_id"]
            if junctions_by_dma.get(dma_id) is None:
                junctions_by_dma[dma_id] = []
            if network_junctions.get(dma_id) is None:
                network_junctions[dma_id] = []
            junctions_by_dma[dma_id].append(k)

            network_junctions["all_network"].append(v["node_id"])
            if v["dma_id"] is not None:
                network_junctions[dma_id].append(v["node_id"])
            else:
                network_junctions["0"].append(v["node_id"])

    def _export_network(self):
        write_inpfile(
            self.network, Path(self.output_folder) / f"{self.file_name}.inp"
        )

    def _get_total_demand(self, junctions):

        demands = 0
        for junction in junctions:
            try:
                demand = self.results.node["demand"].loc[:, junction]
                junction_demand = demand.sum().sum()
                demands += junction_demand
            except Exception:
                continue
        # Multiply demands for work with wntr units
        return demands * 1000
