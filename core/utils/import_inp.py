"""
This file is part of Giswater 4
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
import json
import os

from enum import Enum
from functools import partial
from pathlib import Path
from typing import Optional, Tuple

from qgis.PyQt.QtWidgets import QMenu, QFileDialog, QComboBox

from ...libs import tools_log, tools_qgis, tools_qt, lib_vars
from ... import global_vars



class ProjectType(Enum):
    WS = "ws"
    UD = "ud"

class GwInpConfig:
    """ Class to store the configuration of the import INP process, as well as serializing/deserializing it """

    def __init__(self, file_path: Optional[Path] = None, workcat: Optional[str] = None, exploitation: Optional[int] = None,
                 sector: Optional[int] = None, municipality: Optional[int] = None, dscenario: Optional[str] = None,
                 raingage: Optional[str] = None, catalogs: Optional[dict] = None) -> None:
        self.file_path: Optional[Path] = file_path
        self.workcat: Optional[str] = workcat
        self.exploitation: Optional[int] = exploitation
        self.sector: Optional[int] = sector
        self.municipality: Optional[int] = municipality
        self.dscenario: Optional[str] = dscenario
        self.raingage: Optional[str] = raingage
        self.catalogs: Optional[dict] = catalogs

    def serialize(self) -> dict:
        return_dict = {
            "file_path": str(self.file_path),
            "workcat": self.workcat,
            "exploitation": self.exploitation,
            "sector": self.sector,
            "municipality": self.municipality,
            "catalogs": self.catalogs
        }
        if self.dscenario:
            return_dict["dscenario"] = self.dscenario
        if self.raingage:
            return_dict["raingage"] = self.raingage

        return return_dict

    def deserialize(self, data: dict) -> None:
        self.file_path = data.get("file_path")
        self.workcat = data.get("workcat")
        self.exploitation = data.get("exploitation")
        self.sector = data.get("sector")
        self.municipality = data.get("municipality")
        self.dscenario = data.get("dscenario")
        self.catalogs = data.get("catalogs")

    def write_to_file(self, file_path: Path) -> None:
        """Write the serialized configuration to a file."""
        data = self.serialize()
        # Convert tuple keys to strings
        data_serializable = self.convert_keys(data)
        with file_path.open("w") as file:
            json.dump(data_serializable, file, indent=4)

    def read_from_file(self, file_path: Path) -> None:
        """Read the configuration from a file and deserialize it."""
        with file_path.open("r") as file:
            try:
                data = json.load(file)
            except json.JSONDecodeError as e:
                tools_log.log_error(f"Error reading configuration file: {e}")
                return
        self.deserialize(data)

    def convert_keys(self, obj):
        """ Recursively converts keys to strings in a dictionary. """
        if isinstance(obj, dict):
            return {str(k): self.convert_keys(v) for k, v in obj.items()}
        return obj


def create_load_menu(self_cls):
    """Create a drop-down menu for the load button"""

    menu = QMenu(self_cls.dlg_config)
    action_load_last = menu.addAction("Load from last import")
    action_load_from_file = menu.addAction("Load from file...")

    # Connect actions to their respective slots
    action_load_last.triggered.connect(partial(_load_last_config, self_cls))
    action_load_from_file.triggered.connect(partial(_load_config_from_file, self_cls))

    return menu

def _load_last_config(self_cls):
    """Load the last saved configuration"""

    load_config(self_cls)

def _load_config_from_file(self_cls):
    """Load configuration from a file"""

    config_folder = f'{lib_vars.user_folder_dir}{os.sep}core{os.sep}temp'
    result: Tuple[str, str] = QFileDialog.getOpenFileName(
        None, "Select a configuration file", config_folder, "JSON files (*.json)"
    )
    file_path_str: str = result[0]
    if file_path_str:
        config_path: Path = Path(file_path_str)
        config = GwInpConfig()
        config.read_from_file(config_path)
        load_config(self_cls, config)

def save_config_to_file(self_cls):
    """Save configuration to a file"""

    result: Tuple[str, str] = QFileDialog.getSaveFileName(
        None, "Save configuration file", "", "JSON files (*.json)"
    )
    file_path_str: str = result[0]
    if file_path_str:
        config_path: Path = Path(file_path_str)
        workcat, exploitation, sector, municipality, dscenario, catalogs = self_cls._get_config_values()
        save_config(self_cls, workcat=workcat, exploitation=exploitation, sector=sector, municipality=municipality, dscenario=dscenario, catalogs=catalogs, _config_path=config_path)

def save_config(self_cls, workcat: Optional[str] = None, exploitation: Optional[int] = None, sector: Optional[int] = None,
                    municipality: Optional[int] = None, dscenario: Optional[str] = None, raingage: Optional[str] = None, catalogs: Optional[dict] = None, _config_path: Optional[Path] = None) -> None:

    try:
        if _config_path is None:
            config_folder = f'{lib_vars.user_folder_dir}{os.sep}core{os.sep}temp'
            if not os.path.exists(config_folder):
                os.makedirs(config_folder)
            file_name = "import_epanet_config.json" if global_vars.project_type == ProjectType.WS else "import_swmm_config.json"
            path_temp_file = f"{config_folder}{os.sep}{file_name}"
            config_path: Path = Path(path_temp_file)
        else:
            config_path = _config_path
        config = GwInpConfig(file_path=self_cls.file_path, workcat=workcat, exploitation=exploitation, sector=sector,
                                municipality=municipality, dscenario=dscenario, raingage=raingage, catalogs=catalogs)
        config.write_to_file(config_path)
        tools_log.log_info(f"Configuration saved to {config_path}")
    except Exception as e:
        tools_qgis.show_warning(f"Error saving the configuration: {e}", dialog=self_cls.dlg_config)

def load_config(self_cls, config: Optional[GwInpConfig] = None) -> Optional[GwInpConfig]:

    if config is None:
        config_folder = f'{lib_vars.user_folder_dir}{os.sep}core{os.sep}temp'
        file_name = "import_epanet_config.json" if global_vars.project_type == ProjectType.WS else "import_swmm_config.json"
        path_temp_file = f"{config_folder}{os.sep}{file_name}"
        config_path: Path = Path(path_temp_file)
        if not os.path.exists(config_path):
            return None
        config = GwInpConfig()
        config.read_from_file(config_path)
    if not config.file_path:
        return None

    # Fill 'Basic' tab widgets
    tools_qt.set_widget_text(self_cls.dlg_config, 'txt_workcat', config.workcat)
    if global_vars.project_type == ProjectType.WS:
        tools_qt.set_widget_text(self_cls.dlg_config, 'txt_dscenario', config.dscenario)
    elif global_vars.project_type == ProjectType.UD:
        tools_qt.set_widget_text(self_cls.dlg_config, 'txt_raingage', config.raingage)
    tools_qt.set_combo_value(self_cls.dlg_config.cmb_expl, config.exploitation, 0)
    tools_qt.set_combo_value(self_cls.dlg_config.cmb_sector, config.sector, 0)
    tools_qt.set_combo_value(self_cls.dlg_config.cmb_muni, config.municipality, 0)

    # Fill tables from catalogs
    if global_vars.project_type == ProjectType.WS:
        _set_combo_values_from_epanet_catalogs(self_cls, config.catalogs)
    elif global_vars.project_type == ProjectType.UD:
        _set_combo_values_from_swmm_catalogs(self_cls, config.catalogs)

    if str(self_cls.file_path) != str(config.file_path):
        tools_qgis.show_warning("The configuration file doesn't match the selected INP file. Some options may not be loaded.", dialog=self_cls.dlg_config)
    else:
        tools_qgis.show_success("Configuration loaded successfully", dialog=self_cls.dlg_config)

    return config

def _set_combo_values_from_epanet_catalogs(self_cls, catalogs):
    # Set features
    for feature_type, (combo,) in self_cls.tbl_elements["features"].items():
        feat_catalog = catalogs.get("features", {}).get(str(feature_type))
        if feat_catalog:
            combo.setCurrentText(feat_catalog)

    # Set materials
    for roughness, (combo,) in self_cls.tbl_elements["materials"].items():
        material_catalog = catalogs.get("materials", {}).get(str(roughness))
        if material_catalog:
            combo.setCurrentText(material_catalog)

    # Set nodes and arcs tables
    elements = [
        ("junctions", catalogs.get("junctions")),
        ("reservoirs", catalogs.get("reservoirs")),
        ("tanks", catalogs.get("tanks")),
        ("pumps", catalogs.get("pumps")),
        ("valves", catalogs.get("valves")),
    ]

    for element_type, element_catalog in elements:
        if element_type == "pipes":
            continue

        if element_type not in self_cls.tbl_elements:
            continue

        combo: QComboBox = self_cls.tbl_elements[element_type][0]
        if element_catalog:
            combo.setCurrentText(element_catalog)
            # TODO: manage CREATE_NEW option (the widget is in self.tbl_elements[element_type][1])

    if catalogs.get("pipes") is not None:
        for dint_rough_str, pipe_catalog in catalogs["pipes"].items():
            dint_rough_tuple = tuple(map(float, dint_rough_str.strip("()").split(", ")))
            if dint_rough_tuple not in self_cls.tbl_elements["pipes"]:
                continue

            combo: QComboBox = self_cls.tbl_elements["pipes"][dint_rough_tuple][0]
            if pipe_catalog:
                combo.setCurrentText(pipe_catalog)

def _set_combo_values_from_swmm_catalogs(self_cls, catalogs):
    tools_qgis.show_warning("Catalogs are not implemented for SWMM yet", dialog=self_cls.dlg_config)
