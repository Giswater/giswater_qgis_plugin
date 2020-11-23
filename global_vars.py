"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import sys

from qgis.PyQt.QtCore import QSettings


iface = None
canvas = None
plugin_dir = None
plugin_name = None


# TODO: Proper initialization
schema_name = None
project_type = None

controller = None
settings = None
qgis_settings = None
project_vars = {}
action_select_arc = None
action_select_plot = None
srid = None
logger = None

# TODO: Temporal variables? Create and move into new file?
user_settings = None
user_settings_path = None

min_log_level = 20
min_message_level = 0

last_error = None

show_db_exception = True

dlg_info = None

gw_infotools = None

user = None

translator = None

current_user = None

dlg_docker = None
show_docker = None
docker_type = None


def init_global(p_iface, p_canvas, p_plugin_dir, p_plugin_name):

    global iface, canvas, plugin_dir, plugin_name
    iface = p_iface
    canvas = p_canvas
    plugin_dir = p_plugin_dir
    plugin_name = p_plugin_name


def init_settings(setting_file):

    global settings
    settings = QSettings(setting_file, QSettings.IniFormat)
    settings.setIniCodec(sys.getfilesystemencoding())


def init_qgis_settings(p_plugin_name):

    global plugin_name, qgis_settings
    plugin_name = p_plugin_name
    qgis_settings = QSettings()
    qgis_settings.setIniCodec(sys.getfilesystemencoding())


# def plugin_settings_set_value(key, value):
#
#     global plugin_name
#     qgis_settings.setValue(plugin_name + "/" + key, value)
#
#
# def plugin_settings_value(key, default_value=""):
#
#     global plugin_name, qgis_settings
#     key = plugin_name + "/" + key
#     value = qgis_settings.value(key, default_value)
#     return value

