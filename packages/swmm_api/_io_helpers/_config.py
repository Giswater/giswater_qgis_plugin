import dataclasses
import json
import os
from contextlib import contextmanager
from pathlib import Path


# CONFIG = {
#     'encoding': 'utf-8',  # if ('linux' in sys.platform) else 'iso-8859-1'
#     'gis_decimals': 3,  # write swmm file - decimals of coordinates, vertices and polygons
#     'exe_path': None,  # run swmm with EPA exe
#     'swmm_version': '5.1.015',  # how to read and write infiltration section (syntax changes in version 5.1.015)
#     'section_separator': '_' * 100
# }


@dataclasses.dataclass
class _Config:
    """Configuration class for SWMM-related operations.

    Attributes:
        encoding (str): The default string encoding. Typically, `utf-8`, but can be `iso-8859-1` depending on the platform.
        gis_decimals (int): The number of decimal places to use for GIS data (e.g., coordinates, vertices, polygons) when writing inp-file.
        exe_path (str | Path): The path to the SWMM executable. If `None`, SWMM will not run automatically.
        swmm_version (str): The SWMM version to target for compatibility. This affects syntax for specific sections like infiltration.
        section_separator (str): A string used to separate sections in generated outputs.
        comment_prefix (str): String how all comments begin. default=`;;`
        comment_empty_section (str): String how all empty sections are written to the inp-file. default=`;; No Data`
        init_print_epa_swmm_run (bool): if the standard commandline output should be shown when running with the EPA SWMM CLI. default=False
        default_temp_run (str or function): str of built-in function (`swmm5_run_progress`, `swmm5_run_owa`, `swmm5_run_epa`, `swmm5_run`) or custom function with the first argument being the inp-filename.
    """
    encoding: str = 'utf-8'
    gis_decimals: int = 3
    exe_path: str or Path = None
    swmm_version: str = '5.1.015'
    section_separator: str = '_' * 100
    comment_prefix: str = ';;'
    comment_empty_section: str = comment_prefix + ' No Data'
    init_print_epa_swmm_run: bool = False
    default_temp_run: str = 'swmm5_run_epa'

    CONFIG_FILE_NAME = "swmm-api_config.json"

    def __getitem__(self, item):
        """Retrieve the value of a configuration attribute by key.

        Args:
            item (str): The name of the attribute to retrieve.

        Returns:
            Any: The value of the requested attribute.

        Raises:
            AttributeError: If the attribute does not exist.
        """
        return self.__getattribute__(item)

    def __setitem__(self, item, value):
        """Set the value of a configuration attribute by key.

        Args:
            item (str): The name of the attribute to set.
            value (Any): The new value for the attribute.

        Returns:
            None
        """
        return self.__setattr__(item, value)

    @classmethod
    def get_config_file_path(cls) -> Path:
        """Get the path to the configuration file in the user's configuration directory.

        Returns:
            Path: The full path to the configuration file.
        """
        config_dir = Path(os.path.expanduser("~/.config"))
        config_dir.mkdir(parents=True, exist_ok=True)
        return config_dir / cls.CONFIG_FILE_NAME

    @classmethod
    def load(cls) -> "_Config":
        """Load the configuration from the file if it exists. Otherwise, create a new instance.

        Returns:
            _Config: The loaded or default configuration object.
        """
        config_path = cls.get_config_file_path()
        if config_path.exists():
            with config_path.open("r", encoding="utf-8") as f:
                data = json.load(f)
            return cls(**data)
        return cls()

    def save(self):
        """Save the current configuration to the file.

        Returns:
            None
        """
        config_path = self.get_config_file_path()
        with config_path.open("w", encoding="utf-8") as f:
            json.dump(dataclasses.asdict(self), f, indent=4)

    def update_from_dict(self, config_data: dict):
        """Update the configuration with values from a dictionary.

        Args:
            config_data (dict): A dictionary containing configuration keys and values.

        Returns:
            None
        """
        for key, value in config_data.items():
            if hasattr(self, key):
                setattr(self, key, value)
            else:
                raise AttributeError(f"Invalid configuration key: {key}")

    @contextmanager
    def temporary_override(self, **overrides):
        """Temporarily override configuration parameters within a context.

        Args:
            **overrides: Keyword arguments representing configuration keys
                         and their temporary values.

        Yields:
            _Config: The configuration object with temporary overrides.
        """
        # Save the original values
        original_values = {key: getattr(self, key) for key in overrides.keys() if hasattr(self, key)}

        # Apply overrides
        try:
            for key, value in overrides.items():
                setattr(self, key, value)
            yield self
        finally:
            # Restore original values
            for key, value in original_values.items():
                setattr(self, key, value)

CONFIG = _Config.load()


def main():
    CONFIG = _Config.load()
    CONFIG.save()


if __name__ == '__main__':
    main()
