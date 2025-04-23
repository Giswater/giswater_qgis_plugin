"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
import datetime
import os
from functools import partial
from pathlib import Path
from time import time

from qgis.core import QgsApplication
from qgis.PyQt.QtCore import QTimer

from ....threads.quantized_demands import GwQuantizedDemands
from ....ui.ui_manager import QuantizedDemandsUi
from ..... import global_vars
from .....libs import tools_qt
from ....utils import tools_gw


class QuantizedDemands:
    def __init__(self):
        self.message = ""
        pass

    def clicked_event(self):

        self.dlg_epa = QuantizedDemandsUi(self)
        dlg = self.dlg_epa
        tools_gw.load_settings(self.dlg_epa)

        # Load user values
        widgets = [
            "data_inp_input_file",
            "data_config_file",
            "data_output_folder",
            "txt_filename",
        ]
        for widget in widgets:
            value = tools_gw.get_config_parser(
                "quantized_demands",
                widget,
                "user",
                "session",
            )
            tools_qt.set_widget_text(self.dlg_epa, widget, value)

        # Set signals
        self.dlg_epa.btn_ok.clicked.connect(self._execute_quantized_demands)
        self.dlg_epa.btn_cancel.clicked.connect(self.dlg_epa.reject)

        self.dlg_epa.btn_push_inp_input_file.clicked.connect(
            partial(self._get_file_dialog, self.dlg_epa.data_inp_input_file)
        )

        dlg.btn_push_config_file.clicked.connect(
            partial(self._get_file_dialog, dlg.data_config_file)
        )
        dlg.btn_push_output_folder.clicked.connect(
            partial(tools_qt.get_folder_path, dlg, dlg.data_output_folder)
        )

        self.dlg_epa.rejected.connect(partial(self._save_user_values, self.dlg_epa))
        self.dlg_epa.rejected.connect(partial(tools_gw.close_dialog, self.dlg_epa))

        tools_gw.disable_tab_log(dlg)
        tools_gw.open_dialog(self.dlg_epa, dlg_name="quantized_demands")

    def _execute_quantized_demands(self):
        if not self._validate_inputs():
            return
        if not self._ovewrite_existing_files(self.output_folder, self.file_name):
            return

        self.dlg_epa.btn_ok.setEnabled(False)
        self.dlg_epa.btn_cancel.clicked.disconnect()
        self.quantized_demands = GwQuantizedDemands(
            "Quantized Demands",
            self.input_file,
            self.config,
            self.output_folder,
            self.file_name,
        )
        self.dlg_epa.btn_cancel.clicked.connect(self.quantized_demands.cancel)
        self.quantized_demands.status.connect(self._manage_messages)
        self.quantized_demands.ended.connect(self._manage_messages)
        self.quantized_demands.ended.connect(
            partial(self.dlg_epa.btn_ok.setEnabled, True)
        )
        self.quantized_demands.ended.connect(
            partial(self.dlg_epa.btn_cancel.clicked.connect, self.dlg_epa.reject)
        )

        # Timer
        self.t0 = time()
        self.timer = QTimer()
        self.timer.timeout.connect(self._on_timer_timeout)
        self.timer.start(500)
        self.dlg_epa.rejected.connect(self.timer.stop)
        self.quantized_demands.ended.connect(self.timer.stop)

        QgsApplication.taskManager().addTask(self.quantized_demands)

    def _get_file_dialog(self, widget):
        """Get file dialog"""

        tools_qt.get_open_file_path(self.dlg_epa, widget, message="Select file")

    def _manage_messages(self, message):
        self.message += message
        self.message += "\n\n"

        tools_gw.fill_tab_log(
            self.dlg_epa,
            {"info": {"values": [{"message": self.message}]}},
            close=False,
            call_set_tabs_enabled=False,
        )

    def _on_timer_timeout(self):
        elapsed_time = time() - self.t0
        text = str(datetime.timedelta(seconds=round(elapsed_time)))
        self.dlg_epa.lbl_timer.setText(text)

    def _ovewrite_existing_files(self, folder, file_name):
        prefix = f"{folder}/{file_name}"
        exists = lambda sufix: Path(prefix + sufix).exists()
        sufixes = [".inp", ".csv"]
        sufixes_that_exist = list(filter(exists, sufixes))

        if len(sufixes_that_exist) == 1:
            file = f"{file_name}{sufixes_that_exist[0]}"
            msg = f"The file {file} already exists. Do you want to overwrite it?"
            return tools_qt.show_question(msg)

        elif len(sufixes_that_exist) > 1:
            file_names = [f'"{file_name}{sufix}"' for sufix in sufixes_that_exist]
            all_files = ", ".join(file_names)
            msg = f"The files {all_files} already exist. Do you want to overwrite them?"
            return tools_qt.show_question(msg)

        return True

    def _save_user_values(self, dialog):
        """Save last user values"""
        text_widgets = [
            "data_inp_input_file",
            "data_config_file",
            "data_output_folder",
            "txt_filename",
        ]
        for widget in text_widgets:
            value = tools_qt.get_text(dialog, widget, False, False)
            tools_gw.set_config_parser(
                "quantized_demands",
                widget,
                f"{value}",
            )

    def _validate_inputs(self):
        dlg = self.dlg_epa

        # Input INP file
        input_file = self.dlg_epa.data_inp_input_file.toPlainText()
        if not input_file:
            tools_qt.show_info_box("You should select an input INP file!")
            return False

        # Config file
        config_file = dlg.data_config_file.toPlainText()
        if not config_file or not Path(config_file).exists():
            tools_qt.show_info_box("You should select an config file!")
            return False

        try:
            config = ConfigQD(config_file)
        except Exception as e:
            tools_qt.show_info_box(f"Configuration file couldn't be imported:\n{e}")
            return False

        # Output
        output_folder = dlg.data_output_folder.toPlainText()
        if not output_folder:
            tools_qt.show_info_box("You should select an output folder!")
            return False
        elif not Path(output_folder).exists():
            tools_qt.show_info_box(
                f'"{output_folder}" does not exist. Please select a valid folder.'
            )
            return False

        file_name = dlg.txt_filename.text()
        if not file_name:
            tools_qt.show_info_box("You should inform a file name!")
            return False

        self.input_file = input_file
        self.config = config
        self.output_folder = output_folder
        self.file_name = file_name
        return True


class ConfigQD:
    def __init__(self, config_file):
        self.options = {}
        self.input_flows = {}
        self._flow_list = []
        self._flow_list_unit = None
        self._flow_list_timestep = None
        self._parse_file(config_file)

        required_options = ["model_timestep"]
        for option in required_options:
            if option not in self.options:
                raise ValueError(f"{option} not found in [OPTIONS] section.")

    def _convert2lps(self, value, unit):
        convert_from = {
            "LPS": lambda x: x,
            "LPM": lambda x: x / 60,
            "CMH": lambda x: x * 1000 / 60 / 60,
            "CMD": lambda x: x * 1000 / 24 / 60 / 60,
        }
        return convert_from[unit](value)

    def _convert2seconds(self, value, unit):
        convert_from = {
            "seconds": lambda x: x,
            "minutes": lambda x: x * 60,
            "hours": lambda x: x * 60 * 60,
        }
        return convert_from[unit.lower()](value)

    def _parse_file(self, config_file):
        with open(config_file) as file:
            section = ""
            for line in file:
                tokens = self._strip_comments(line).split()
                if len(tokens) == 0:
                    continue
                elif len(tokens) == 1 and tokens[0].lower() == "[options]":
                    section = "options"
                elif len(tokens) == 1 and tokens[0].lower() == "[inputflows]":
                    section = "input flows"
                elif section == "options":
                    self._process_option(tokens)
                elif section == "input flows":
                    self._process_input_flows(tokens)

        if not self._flow_list:
            raise ValueError("Values for input flows not informed.")
        if self._flow_list_unit is None:
            raise ValueError("Unit for values of input flows not informed.")
        if self._flow_list_timestep is None:
            raise ValueError("Timestep for input flows not informed.")

        self.input_flows["values"] = [
            self._convert2lps(x, self._flow_list_unit) for x in self._flow_list
        ]
        self.input_flows["timestep"] = self._flow_list_timestep

    def _process_leak_flow(self, tokens):
        value = float(tokens[1])
        unit = tokens[2].upper()
        self.options["leak_flow"] = self._convert2lps(value, unit)

    def _process_model_timestep(self, tokens):
        value = int(tokens[1])
        unit = tokens[2].lower()
        self.options["model_timestep"] = self._convert2seconds(value, unit)

    def _process_option(self, tokens):
        first_token = tokens[0].lower()

        options = {
            "leak_flow": self._process_leak_flow,
            "model_timestep": self._process_model_timestep,
            "volume_distribution": self._process_volume_distribution,
        }

        if first_token in options:
            options[first_token](tokens)

    def _process_input_flows(self, tokens):
        first_token = tokens[0].lower()

        if first_token == "values":
            _, *values = tokens
            self._flow_list += list(map(float, values))
        elif first_token == "unit":
            self._flow_list_unit = tokens[1].upper()
        elif first_token == "timestep":
            value = int(tokens[1])
            ts_unit = tokens[2].lower()
            self._flow_list_timestep = self._convert2seconds(value, ts_unit)

    def _process_volume_distribution(self, tokens):
        value = tokens[1].lower()
        if value in ("simple", "hourly"):
            self.options["volume_distribution"] = value
        else:
            raise ValueError("Value_distribution must be SIMPLE or HOURLY.")

    def _strip_comments(self, str):
        index = str.find(";")
        return str if index == -1 else str[:index]
