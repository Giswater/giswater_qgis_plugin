"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-

from .. import global_vars
from . import tools_log


def check_user_settings(parameter, value=None, section='system'):
    """ Check if @section and @parameter exists in user settings file. If not add them with @value """

    # Check if @section exists
    if not global_vars.user_settings.has_section(section):
        global_vars.user_settings.add_section(section)
        global_vars.user_settings.set(section, parameter, value)
        save_user_settings()

    # Check if @parameter exists
    if not global_vars.user_settings.has_option(section, parameter):
        global_vars.user_settings.set(section, parameter, value)
        save_user_settings()


def get_user_setting_value(parameter, default_value=None, section='system'):
    """ Get value from user settings file of selected @parameter located in @section """

    value = default_value
    if global_vars.user_settings is None:
        return value

    check_user_settings(parameter, value)
    value = global_vars.user_settings.get(section, parameter).lower()

    return value


def set_user_settings_value(parameter, value, section='system'):
    """ Set @value from user settings file of selected @parameter located in @section """

    if global_vars.user_settings is None:
        return value

    check_user_settings(parameter, value)
    global_vars.user_settings.set(section, parameter, value)
    save_user_settings()


def save_user_settings():
    """ Save user settings file """

    try:
        with open(global_vars.user_settings_path, 'w') as configfile:
            global_vars.user_settings.write(configfile)
            configfile.close()
    except Exception as e:
        tools_log.log_warning(str(e))