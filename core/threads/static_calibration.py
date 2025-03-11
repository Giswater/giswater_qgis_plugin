"""
This file is part of Giswater 4
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
"""
import configparser
import copy
import csv
import os
import re
from functools import partial

from qgis.core import QgsTask
from qgis.PyQt.QtCore import pyqtSignal
from scipy.optimize import root_scalar

from .task import GwTask
from ... import global_vars
from ...libs import tools_db
from ..utils import tools_gw

try:
    import wntr
    from wntr.epanet.util import from_si, to_si, FlowUnits, HydParam
except ImportError:
    wntr = None
    from_si = None
    to_si = None
    FlowUnits = None
    HydParam = None


class GwStaticCalibration(GwTask):
    ended = pyqtSignal(str)
    report = pyqtSignal(dict)
    status = pyqtSignal(dict)

    def __init__(
        self,
        description,
        input_file,
        config,
        output_folder,
        file_name,
    ):
        super().__init__(description, QgsTask.CanCancel)
        self.input_file = input_file
        self.config = config
        self.output_folder = output_folder
        self.file_name = file_name

    def run(self):
        try:
            self.status.emit({"message": "Reading input files...", "step": "first"})
            static_calibration = Calibrations(self, self.input_file, self.config)

            if self.isCanceled():
                self.ended.emit("Task canceled.")
                return False

            static_calibration.execute()

            if self.isCanceled():
                self.ended.emit("Task canceled.")
                return False

            self.status.emit({"message": "Saving output files...", "step": "last"})
            inp_file = f"{self.output_folder}/{self.file_name}.inp"
            wntr.network.write_inpfile(static_calibration.calibrated_network, inp_file)
            csv_file = f"{self.output_folder}/{self.file_name}.csv"
            report = static_calibration.report()
            static_calibration.write_csv_report(csv_file, report_obj=report)

            self.report.emit(report)
            msg = "Process finished.\n\n"
            msg += "INP file created on:\n"
            msg += f"{inp_file}\n\n"
            msg += "Report file created on:\n"
            msg += f"{csv_file}"
            self.ended.emit(msg)
            return True
        except Exception as e:
            self.ended.emit(str(e))
            return False


class Calibrator:
    """Calibrate an EPANET network"""

    def __init__(self, network, checker, modders, tolerance=0.0001, maxiter=None):
        self.checker = checker
        self.modders = modders
        self.network = network
        self.tolerance = tolerance
        self.maxiter = maxiter

    def check_difference(self, network, modder, factor):
        modded_network = modder.apply_factor(network, factor)
        return self.checker.difference(modded_network)

    def calibrate(self):
        """Return a calibrated network"""

        wn = copy.deepcopy(self.network)
        if abs(self.checker.difference(wn)) < self.tolerance:
            self.success = True
            return wn

        for i, modder in enumerate(self.modders):
            # print(modder.__class__.__name__)
            bracket = modder.bracket
            wn0 = modder.apply_factor(wn, bracket[0])
            diff0 = self.checker.difference(wn0)
            wn1 = modder.apply_factor(wn, bracket[1])
            diff1 = self.checker.difference(wn1)

            # If both brackets have the same sign, a root cannot be found,
            # take the nearest result to the next iteration of the loop
            if (diff0 >= 0 and diff1 >= 0) or (diff0 < 0 and diff1 < 0):
                wn = wn0 if abs(diff0) < abs(diff1) else wn1
                if i + 1 == len(self.modders):
                    self.success = False
            else:
                difference = lambda factor: self.check_difference(wn, modder, factor)
                results = root_scalar(
                    difference,
                    bracket=bracket,
                    xtol=self.tolerance,
                    maxiter=self.maxiter,
                )
                if results.converged:
                    wn = modder.apply_factor(wn, results.root)
                    self.success = True
                else:
                    self.success = False
        return wn


def zero_time_value(network, target, attribute, hyd_param):
    # Set duration to zero for performance
    duration = network.options.time.duration
    network.options.time.duration = 0

    results = wntr.sim.EpanetSimulator(network).run_sim()
    for ext in ("inp", "bin", "rpt"):
        os.remove(f"temp.{ext}")

    if target in network.link_name_list:
        result = results.link[attribute].loc[0, target]
    elif target in network.node_name_list:
        result = results.node[attribute].loc[0, target]

    # Restore original duration
    network.options.time.duration = duration

    # Unit convertion
    units = network.options.hydraulic.inpfile_units
    return from_si(FlowUnits[units], result, hyd_param)


class FlowChecker:
    def __init__(self, target_arc, target_value):
        self.target_arc = target_arc
        self.target_value = target_value

    def difference(self, network):
        return self.target_value - self.value(network)

    def value(self, network):
        return zero_time_value(network, self.target_arc, "flowrate", HydParam.Flow)


class PressureChecker:
    def __init__(self, target_node, target_value):
        self.target_node = target_node
        self.target_value = target_value

    def difference(self, network):
        return self.target_value - self.value(network)

    def value(self, network):
        return zero_time_value(network, self.target_node, "pressure", HydParam.Pressure)


def modify_links(network, links, factor, fn):
    wn = copy.deepcopy(network)
    for link_name in links:
        if (link_name + "_n2a") in wn.link_name_list:
            link_name += "_n2a"
        elif link_name not in wn.link_name_list:
            raise ValueError(f'The link "{link_name}" does not exist in the network.')
        link = wn.get_link(link_name)
        fn(wn, link, factor)
    return wn


def modify_nodes(network, nodes, factor, fn):
    wn = copy.deepcopy(network)
    for node_name in nodes:
        if node_name not in wn.node_name_list:
            raise ValueError(f'The node "{node_name}" does not exist in the network.')
        node = wn.get_node(node_name)
        fn(wn, node, factor)
    return wn


class DiameterModder:
    def __init__(self, arcs, brackets={}):
        self.arcs = arcs
        self.bracket = brackets.get("dint_multiplier", None)

    def modify_feature(self, network, feature, factor):
        if feature.link_type == "Pipe":
            feature.diameter *= factor

    def apply_factor(self, network, factor):
        return modify_links(network, self.arcs, factor, self.modify_feature)


class ElevationModder:
    def __init__(self, nodes, brackets={}):
        self.nodes = nodes
        self.bracket = brackets.get("elevation_offset", None)

    def modify_feature(self, network, feature, factor):
        if hasattr(feature, "elevation"):
            feature.elevation += factor

    def apply_factor(self, network, factor):
        return modify_nodes(network, self.nodes, factor, self.modify_feature)


class MinorLossModder:
    def __init__(self, arcs, brackets={}):
        self.arcs = arcs
        self.bracket = brackets.get("minorloss_km", None)

    def modify_feature(self, network, feature, factor):
        if feature.link_type == "Pipe":
            feature.minor_loss = factor * feature.length / 1000

    def apply_factor(self, network, factor):
        return modify_links(network, self.arcs, factor, self.modify_feature)


class PowerModder:
    def __init__(self, pumps, brackets={}):
        self.pumps = pumps
        self.bracket = brackets.get("power", None)

    def modify_feature(self, network, feature, factor):
        if feature.link_type != "Pump":
            raise ValueError(f'The link "{feature.name}" is not a pump.')

        units = network.options.hydraulic.inpfile_units
        power = to_si(FlowUnits[units], factor, HydParam.Power)
        if feature.pump_type == "POWER":
            feature.power = power
        else:
            name = feature.name
            start_node_name = feature.start_node_name
            end_node_name = feature.end_node_name
            network.remove_link(name)
            network.add_pump(name, start_node_name, end_node_name, pump_parameter=power)

    def apply_factor(self, network, factor):
        return modify_links(network, self.pumps, factor, self.modify_feature)


class RoughnessModder:
    def __init__(self, arcs, brackets={}):
        self.arcs = arcs
        self.bracket = brackets.get("roughness", None)

    def modify_feature(self, network, feature, factor):
        units = network.options.hydraulic.inpfile_units
        if feature.link_type == "Pipe":
            feature.roughness = to_si(FlowUnits[units], factor, HydParam.RoughnessCoeff)

    def apply_factor(self, network, factor):
        return modify_links(network, self.arcs, factor, self.modify_feature)


class SettingModder:
    def __init__(self, valves, brackets={}):
        self.hyd_param = {
            "PRV": HydParam.Pressure,
            "PSV": HydParam.Pressure,
            "PBV": HydParam.Pressure,
            "FCV": HydParam.Flow,
        }
        self.valves = valves
        self.bracket = brackets.get("setting", None)

    def modify_feature(self, network, feature, factor):
        units = network.options.hydraulic.inpfile_units
        if feature.link_type != "Valve":
            raise ValueError(f'The link "{feature.name}" is not a valve.')
        feature.initial_status = wntr.network.LinkStatus.Active
        valve_type = feature.valve_type
        if valve_type == "TCV":
            feature.initial_setting = factor
        elif valve_type in self.hyd_param.keys():
            feature.initial_setting = to_si(
                FlowUnits[units], factor, self.hyd_param[valve_type]
            )
        else:
            raise ValueError(f"Cannot calibrate {valve_type} ({feature.name}).")

    def apply_factor(self, network, factor):
        return modify_links(network, self.valves, factor, self.modify_feature)


def losses_modders(arcs, brackets={}):
    return [
        RoughnessModder(arcs, brackets),
        MinorLossModder(arcs, brackets),
        DiameterModder(arcs, brackets),
    ]


class Calibrations:
    checkers = {"flow": FlowChecker, "pressure": PressureChecker}
    default_brackets = {
        "dint_multiplier": [0.5, 2],
        "minorloss_km": [0, 100],
        "power": [0.001, 3000],
        "roughness": [0, 0.1],
        "setting": [0.0001, 1000],
        "elevation_offset": [-5, 5],
    }
    brackets = {}
    for key, value in default_brackets.items():
        raw_string = tools_gw.get_config_parser(
            "static_calibration",
            key,
            "user",
            "init",
            prefix=False,
        )
        if raw_string is None:
            raw_string = ", ".join(map(str, value))
            tools_gw.set_config_parser(
                "static_calibration",
                key,
                raw_string,
                "user",
                "init",
                prefix=False,
            )
        brackets[key] = [float(x) for x in raw_string.split(",")]
    modders = {
        "diameter": DiameterModder,
        "elevation": ElevationModder,
        "losses": losses_modders,
        "power": PowerModder,
        "setting": SettingModder,
    }
    changes = {
        "nodes": ["elevation"],
        "pipes": ["diameter", "losses"],
        "pumps": ["power"],
        "valves": ["setting"],
    }

    def __init__(self, task, inp_file, config):
        self.task = task
        self.accuracy = config.options["accuracy"]
        self.trials = config.options["trials"]
        self.calibrations = config.scenarios.values()
        self._fill_brackets()
        self._check_input()
        if not wntr:
            raise ImportError("WNTR not installed.")

        # Apparently WNTR expects one of the first lines of the
        # [OPTIONS] section to be UNITS
        with open(inp_file) as f:
            inp_str = f.read()
        fixed_str = re.sub(
            r"(\[options]\s*$)(.+?)(^\s*units.*?$)",
            r"\1\n\3\2",
            inp_str,
            flags=re.MULTILINE | re.IGNORECASE | re.DOTALL,
        )
        temp_file = inp_file + ".temp"
        with open(temp_file, "w") as t:
            t.write(fixed_str)
        self.network = wntr.network.WaterNetworkModel(temp_file)
        os.remove(temp_file)

    def _check_input(self):
        for calibration in self.calibrations:
            if calibration["calibration_mode"] not in self.modders:
                raise ValueError(
                    f'"{calibration["calibration_mode"]}" is not a valid calibration_mode.'
                )
            if calibration["target_parameter"] not in self.checkers:
                raise ValueError(
                    f'"{calibration["target_parameter"]}" is not a valid target_parameter.'
                )

    def _fill_brackets(self):
        for calibration in self.calibrations:
            for key, value in self.brackets.items():
                if key not in calibration["brackets"]:
                    calibration["brackets"][key] = value

    def execute(self):
        wn = copy.deepcopy(self.network)
        total_steps = len(self.calibrations)
        for index, calibration in enumerate(self.calibrations):
            name = calibration["name"]
            calibration_mode = calibration["calibration_mode"]
            target_parameter = calibration["target_parameter"]
            target_id = calibration["target_id"]
            target_val = calibration["target_val"]
            features = calibration["features"]
            brackets = calibration["brackets"]

            if self.task:
                self.task.status.emit(
                    {
                        "message": f'Executing calibration "{name}" ({index+1}/{total_steps})...',
                        "step": index + 1,
                        "steps": total_steps,
                    }
                )

            checker = self.checkers[target_parameter](target_id, target_val)
            modders = self.modders[calibration_mode](features, brackets)
            if type(modders) != list:
                modders = [modders]
            calibrator = Calibrator(wn, checker, modders, self.accuracy, self.trials)
            wn = calibrator.calibrate()

            if self.task and self.task.isCanceled():
                return

            calibration["success"] = calibrator.success
        self.calibrated_network = wn

    def report_arc_changes(self):
        units = FlowUnits[self.network.options.hydraulic.inpfile_units]
        report = []
        for calibration in self.calibrations:
            if calibration["calibration_mode"] not in self.changes["pipes"]:
                continue
            for arc in calibration["features"]:
                pipe = self.calibrated_network.get_link(arc)
                if pipe.link_type != "Pipe":
                    continue
                old_pipe = self.network.get_link(arc)
                if old_pipe.link_type != "Pipe":
                    continue
                obj = {}
                obj["scenario_id"] = calibration["name"]
                obj["arc_id"] = arc
                obj["dint"] = round(
                    from_si(units, pipe.diameter, HydParam.PipeDiameter), 3
                )
                obj["roughness"] = round(
                    from_si(units, pipe.roughness, HydParam.RoughnessCoeff), 3
                )
                obj["minorloss"] = round(pipe.minor_loss, 3)
                obj["old_dint"] = round(
                    from_si(units, old_pipe.diameter, HydParam.PipeDiameter), 3
                )
                obj["old_roughness"] = round(
                    from_si(units, old_pipe.roughness, HydParam.RoughnessCoeff), 3
                )
                obj["old_minorloss"] = round(old_pipe.minor_loss, 3)
                report.append(obj)
        return report

    def report_node_changes(self):
        units = FlowUnits[self.network.options.hydraulic.inpfile_units]
        report = []
        for calibration in self.calibrations:
            if calibration["calibration_mode"] not in self.changes["nodes"]:
                continue
            for node_name in calibration["features"]:
                node = self.calibrated_network.get_node(node_name)
                old_node = self.network.get_node(node_name)
                if not hasattr(old_node, "elevation"):
                    continue
                obj = {}
                obj["scenario_id"] = calibration["name"]
                obj["node_id"] = node_name
                obj["elevation"] = round(
                    from_si(units, node.elevation, HydParam.Elevation), 3
                )
                obj["old_elevation"] = round(
                    from_si(units, old_node.elevation, HydParam.Elevation), 3
                )
                report.append(obj)
        return report

    def report_pump_changes(self):
        units = FlowUnits[self.network.options.hydraulic.inpfile_units]
        report = []
        for calibration in self.calibrations:
            if calibration["calibration_mode"] not in self.changes["pumps"]:
                continue
            for link in calibration["features"]:
                node = link
                if (link + "_n2a") in self.calibrated_network.link_name_list:
                    link += "_n2a"
                pump = self.calibrated_network.get_link(link)
                if pump.link_type != "Pump":
                    continue
                old_pump = self.network.get_link(link)
                if old_pump.link_type != "Pump":
                    continue
                obj = {}
                obj["scenario_id"] = calibration["name"]
                obj["node_id"] = node
                obj["power"] = round(from_si(units, pump.power, HydParam.Power), 3)
                if old_pump.pump_type == "POWER":
                    obj["old_power"] = round(
                        from_si(units, old_pump.power, HydParam.Power), 3
                    )
                else:
                    obj["old_power"] = ""
                report.append(obj)
        return report

    def report_valve_changes(self):
        units = FlowUnits[self.network.options.hydraulic.inpfile_units]
        hyd_param = {
            "PRV": HydParam.Pressure,
            "PSV": HydParam.Pressure,
            "PBV": HydParam.Pressure,
            "FCV": HydParam.Flow,
        }
        report_valves = []
        report_virtualvalves = []
        rows = tools_db.get_rows(
            f"""
            select arc_id from inp_virtualvalve;
            """
        )
        virtualvalves = [x[0] for x in rows] if rows else []
        for calibration in self.calibrations:
            if calibration["calibration_mode"] not in self.changes["valves"]:
                continue
            for link in calibration["features"]:
                node = link
                if (link + "_n2a") in self.calibrated_network.link_name_list:
                    link += "_n2a"
                valve = self.calibrated_network.get_link(link)
                if valve.link_type != "Valve":
                    continue
                old_valve = self.network.get_link(link)
                if old_valve.link_type != "Valve":
                    continue
                obj = {}
                obj["scenario_id"] = calibration["name"]
                if node in virtualvalves:
                    obj["arc_id"] = node
                else:
                    obj["node_id"] = node
                obj["valv_type"] = valve.valve_type
                obj["setting"] = round(
                    from_si(
                        units,
                        valve.initial_setting,
                        hyd_param[valve.valve_type],
                    ),
                    3,
                )
                obj["status"] = valve.initial_status
                obj["old_setting"] = round(
                    from_si(
                        units,
                        old_valve.initial_setting,
                        hyd_param[valve.valve_type],
                    ),
                    3,
                )
                obj["old_status"] = old_valve.initial_status
                if node in virtualvalves:
                    report_virtualvalves.append(obj)
                else:
                    report_valves.append(obj)
        return report_valves, report_virtualvalves

    def report_status(self):
        report = []
        for calibration in self.calibrations:
            target_parameter = calibration["target_parameter"]
            target_id = calibration["target_id"]
            target_val = calibration["target_val"]

            checker = self.checkers[target_parameter](target_id, target_val)

            obj = {}
            obj["scenario_id"] = calibration["name"]
            obj["status"] = "OK" if calibration["success"] else "Failed"
            obj["input_value"] = round(checker.value(self.network), 3)
            obj["target_value"] = target_val
            obj["output_value"] = round(checker.value(self.calibrated_network), 3)
            report.append(obj)
        return report

    def report(self):
        valves, virtualvalves = self.report_valve_changes()
        return {
            "status": self.report_status(),
            "nodes": self.report_node_changes(),
            "pipes": self.report_arc_changes(),
            "pumps": self.report_pump_changes(),
            "valves": valves,
            "virtualvalves": virtualvalves,
        }

    def write_csv_report(self, file, report_obj=None):
        if not report_obj:
            report_obj = self.report()
        with open(file, "w", newline="") as f:
            for section, items in report_obj.items():
                if items:
                    f.write(f"[{section}]\n")
                    columns = items[0].keys()
                    writer = csv.DictWriter(f, fieldnames=columns)
                    writer.writeheader()
                    writer.writerows(items)
                    f.write("\n")
