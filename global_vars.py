"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import QSettings
import sys

settings = None
qgis_settings = None
plugin_name = None
qgis_tools = None
project_vars = {}


def init_settings(setting_file):

    global settings
    settings = QSettings(setting_file, QSettings.IniFormat)
    settings.setIniCodec(sys.getfilesystemencoding())


def init_qgis_settings(p_plugin_name):

    global plugin_name, qgis_settings
    plugin_name = p_plugin_name
    qgis_settings = QSettings()
    qgis_settings.setIniCodec(sys.getfilesystemencoding())


def init_qgis_tools(p_qgis_tools):

    global qgis_tools
    qgis_tools = p_qgis_tools


def plugin_settings_set_value(key, value):

    global plugin_name
    qgis_settings.setValue(plugin_name + "/" + key, value)


def plugin_settings_value(key, default_value=""):

    global plugin_name, qgis_settings
    key = plugin_name + "/" + key
    value = qgis_settings.value(key, default_value)
    return value


def set_project_vars(p_project_vars):
    global project_vars
    project_vars = p_project_vars


def get_project_vars():
    return project_vars

