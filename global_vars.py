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
user_folder_dir = None
schema_name = None
project_type = None
srid = None
logger = None
settings = None
qgis_settings = None
current_user = None
db = None
dao = None
credentials = None
shortcut_keys = []
project_vars = {}
session_vars = {'last_error': None, 'show_db_exception': True,
                'dlg_docker': None, 'show_docker': None, 'docker_type': None, 'logged': None,
                'postgresql_version': None, }


def init_global(p_iface, p_canvas, p_plugin_dir, p_plugin_name, p_user_folder_dir):

    global iface, canvas, plugin_dir, plugin_name, user_folder_dir
    iface = p_iface
    canvas = p_canvas
    plugin_dir = p_plugin_dir
    plugin_name = p_plugin_name
    user_folder_dir = p_user_folder_dir


def init_settings(setting_file):

    global settings
    settings = QSettings(setting_file, QSettings.IniFormat)
    settings.setIniCodec(sys.getfilesystemencoding())


def init_qgis_settings(p_plugin_name):

    global plugin_name, qgis_settings
    plugin_name = p_plugin_name
    qgis_settings = QSettings()
    qgis_settings.setIniCodec(sys.getfilesystemencoding())

