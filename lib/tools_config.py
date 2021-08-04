"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import configparser
import os

from . import tools_log
from .. import global_vars

config_parser = None
project_config_file = None


def get_user_setting_value(section, parameter, default_value=None):
    """ Get value from user settings file 'init.config' of selected @parameter located in @section """

    value = default_value
    if config_parser is None:
        return value

    _check_config_parser(section, parameter, value)
    value = config_parser.get(section, parameter).lower()

    return value


def set_config_parser_value(section, parameter, value):
    """ Set @value from user settings file of selected @parameter located in @section """

    if config_parser is None:
        return value

    _check_config_parser(section, parameter, value)
    config_parser.set(section, parameter, value)
    _save_config_parser()


def manage_init_config_file():
    """ Manage user configuration file 'init.config' """

    global config_parser

    config_parser = configparser.ConfigParser(comment_prefixes=';', allow_no_value=True)
    project_config_file = f"{global_vars.user_folder_dir}{os.sep}config{os.sep}init.config"
    if not os.path.exists(project_config_file):
        tools_log.log_info(f"File not found: {project_config_file}")
        _save_config_parser()

    config_parser.read(project_config_file)


# region private functions


def _save_config_parser():
    """ Save user settings file """

    try:
        with open(f"{global_vars.user_folder_dir}{os.sep}config{os.sep}init.config", 'w') as configfile:
            config_parser.write(configfile)
            configfile.close()
    except Exception as e:
        tools_log.log_warning(str(e))


def _check_config_parser(section, parameter, value=None):
    """ Check if @section and @parameter exists in user settings file. If not add them with @value """

    # Check if @section exists
    if not config_parser.has_section(section):
        config_parser.add_section(section)
        config_parser.set(section, parameter, value)
        _save_config_parser()
    # Check if @parameter exists
    if not config_parser.has_option(section, parameter):
        config_parser.set(section, parameter, value)
        _save_config_parser()

# endregion
