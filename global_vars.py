"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import sys

from qgis.PyQt.QtCore import QSettings

# static variables
# values are initialized on load project without changes during session
iface = None
canvas = None
plugin_dir = None
plugin_name = None
user_folder_dir = None
schema_name = None
project_type = None
srid = None
logger = None
giswater_settings = None
qgis_settings = None
current_user = None
qgis_db_credentials = None
dao = None
dao_db_credentials = None
pg_version = None
shortcut_keys = []

#qgis project variables
project_vars = {}
project_vars['info_type'] = None
project_vars['add_schema'] = None
project_vars['main_schema'] = None
project_vars['project_role'] = None
project_vars['project_type'] = None


# session dynamic variables
# may change value during user's session
session_vars = {}
session_vars['last_error'] = None
session_vars['threads'] = []
session_vars['dialog_docker'] = None
session_vars['info_docker'] = None
session_vars['docker_type'] = None
session_vars['logged_status'] = None


def init_global(p_iface, p_canvas, p_plugin_dir, p_plugin_name, p_user_folder_dir):

    global iface, canvas, plugin_dir, plugin_name, user_folder_dir
    iface = p_iface
    canvas = p_canvas
    plugin_dir = p_plugin_dir
    plugin_name = p_plugin_name
    user_folder_dir = p_user_folder_dir


def init_giswater_settings(setting_file):
    global giswater_settings
    giswater_settings = QSettings(setting_file, QSettings.IniFormat)
    giswater_settings.setIniCodec(sys.getfilesystemencoding())


def init_qgis_settings(p_plugin_name):

    global plugin_name, qgis_settings
    plugin_name = p_plugin_name
    qgis_settings = QSettings()
    qgis_settings.setIniCodec(sys.getfilesystemencoding())

