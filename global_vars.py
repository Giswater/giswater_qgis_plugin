"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
import sys

from qgis.PyQt.QtCore import QSettings


iface = None
canvas = None
plugin_dir = None
plugin_name = None
roaming_user_dir = None
schema_name = None
project_type = None
srid = None
logger = None
settings = None
qgis_settings = None
project_vars = {}
session_vars = {'user_settings': None, 'user_settings_path': None, 'min_log_level': 20, 'min_message_level': 0,
                'last_error': None, 'show_db_exception': True, 'dlg_info': None, 'current_user': None,
                'dlg_docker': None, 'show_docker': None, 'docker_type': None, 'logged': None,
                'db': None, 'postgresql_version': None, 'dao': None, 'credentials': None}


def init_global(p_iface, p_canvas, p_plugin_dir, p_plugin_name, p_roaming_user_dir):

    global iface, canvas, plugin_dir, plugin_name, roaming_user_dir
    iface = p_iface
    canvas = p_canvas
    plugin_dir = p_plugin_dir
    plugin_name = p_plugin_name
    roaming_user_dir = p_roaming_user_dir


def init_settings(setting_file):

    global settings
    settings = QSettings(setting_file, QSettings.IniFormat)
    settings.setIniCodec(sys.getfilesystemencoding())


def init_qgis_settings(p_plugin_name):

    global plugin_name, qgis_settings
    plugin_name = p_plugin_name
    qgis_settings = QSettings()
    qgis_settings.setIniCodec(sys.getfilesystemencoding())

