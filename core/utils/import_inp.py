"""
This file is part of Giswater 4
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
import json
from pathlib import Path
from typing import Optional

from ...libs import tools_log


class GwInpConfig:
    """ Class to store the configuration of the import INP process, as well as serializing/deserializing it """

    def __init__(self, file_path: Optional[Path] = None, workcat: Optional[str] = None, exploitation: Optional[int] = None,
                 sector: Optional[int] = None, municipality: Optional[int] = None, dscenario: Optional[str] = None,
                 catalogs: Optional[dict] = None) -> None:
        self.file_path: Optional[Path] = file_path
        self.workcat: Optional[str] = workcat
        self.exploitation: Optional[int] = exploitation
        self.sector: Optional[int] = sector
        self.municipality: Optional[int] = municipality
        self.dscenario: Optional[str] = dscenario
        self.catalogs: Optional[dict] = catalogs

    def serialize(self) -> dict:
        return {
            "file_path": str(self.file_path),
            "workcat": self.workcat,
            "exploitation": self.exploitation,
            "sector": self.sector,
            "municipality": self.municipality,
            "dscenario": self.dscenario,
            "catalogs": self.catalogs
        }

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
