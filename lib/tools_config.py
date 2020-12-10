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


def check_user_settings(parameter, value=None, section='system'):
    """ Check if @section and @parameter exists in user settings file. If not add them with @value """

    # Check if @section exists
    if not global_vars.session_vars['user_settings'].has_section(section):
        global_vars.session_vars['user_settings'].add_section(section)
        global_vars.session_vars['user_settings'].set(section, parameter, value)
        save_user_settings()

    # Check if @parameter exists
    if not global_vars.session_vars['user_settings'].has_option(section, parameter):
        global_vars.session_vars['user_settings'].set(section, parameter, value)
        save_user_settings()


def get_user_setting_value(parameter, default_value=None, section='system'):
    """ Get value from user settings file of selected @parameter located in @section """

    value = default_value
    if global_vars.session_vars['user_settings'] is None:
        return value

    check_user_settings(parameter, value)
    value = global_vars.session_vars['user_settings'].get(section, parameter).lower()

    return value


def set_user_settings_value(parameter, value, section='system'):
    """ Set @value from user settings file of selected @parameter located in @section """

    if global_vars.session_vars['user_settings'] is None:
        return value

    check_user_settings(parameter, value)
    global_vars.session_vars['user_settings'].set(section, parameter, value)
    save_user_settings()


def save_user_settings():
    """ Save user settings file """

    try:
        with open(global_vars.session_vars['user_settings_path'], 'w') as configfile:
            global_vars.session_vars['user_settings'].write(configfile)
            configfile.close()
    except Exception as e:
        tools_log.log_warning(str(e))


def manage_user_config_file():
    """ Manage user configuration file """

    if global_vars.session_vars['user_settings']:
        return

    global_vars.session_vars['user_settings'] = configparser.ConfigParser(comment_prefixes='/', inline_comment_prefixes='/', allow_no_value=True)
    main_folder = os.path.join(os.path.expanduser("~"), global_vars.plugin_name)
    config_folder = main_folder + os.sep + "config" + os.sep
    global_vars.session_vars['user_settings_path'] = config_folder + 'user.config'
    if not os.path.exists(global_vars.session_vars['user_settings_path']):
        tools_log.log_info(f"File not found: {global_vars.session_vars['user_settings_path']}")
        save_user_settings()
    else:
        tools_log.log_info(f"User settings file: {global_vars.session_vars['user_settings_path']}")

    # Open file
    global_vars.session_vars['user_settings'].read(global_vars.session_vars['user_settings_path'])