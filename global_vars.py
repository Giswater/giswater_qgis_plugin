"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import sys

from qgis.PyQt.QtCore import QSettings

from .libs import lib_vars


# region system variables (values are initialized on load project without changes during session)
gw_dev_mode = False
iface = None                            # Instance of class QGisInterface. Provides the hook to manipulate QGIS application at runtime
canvas = None                           # Instance of class QgsMapCanvas. Contains "canvas", "mapTool", "xyCoordinates", "Cursor", "Extent"
list_configs = [                        # List of configuration files
    'init',
    'session',
    'dev',
    'giswater',
    'user_params']
project_loaded = False                  # True when selected project has been loaded
configs = {}                            # Dictionary of configuration files. Value is an array of 2 columns:
                                        # [0]-> Filepath. [1]-> Instance of class ConfigParser
configs['init'] = [None, None]          # User configuration file: init.config (located in user config folder)
configs['session'] = [None, None]       # Session configuration file: session.config (located in user config folder)
configs['dev'] = [None, None]           # Developer configuration file: dev.config (located in plugin config folder)
configs['giswater'] = [None, None]      # Plugin configuration file: giswater.config (located in plugin config folder)
configs['user_params'] = [None, None]   # Settings configuration file: user_params.config (plugin config folder)
project_type = None                     # Project type get from table "sys_version"
signal_manager = None                   # Instance of class GwSignalManager. Found in "/core/utils/signal_manager.py"
giswater_settings = None                # Instance of class QSettings. QGIS settings related to Giswater variables such as toolbars and checkable actions
exec_procedure_max_retries = None       # Maximum number of execution retries of a PostgreSQL function
load_project_menu = None
# endregion


# region global user variables (values are initialized on load project without changes during session)
shortcut_keys = []                      # An instance of used shortcut_keys for Giswater menu. This keys are configurated on file "init.config" from user config path "/user/AppData/Roaming/Giswater/"
feature_cat = None                      # Dictionary to keep every record of table 'cat_feature'. Stored here to avoid executing gw_fct_getcatfeaturevalues multiple times
# endregion


# region Dynamic Variables (variables may change value during user's session)
snappers = []                              # A list of all the snapper managers, used to disable them in 'Reset plugin' action
active_rubberbands = []                    # A list of all active rubber bands, used to disable them in 'Reset plugin' action
active_signals = {}                        # A dictionary containing all connected signals, first key is dlg_name/file_name, then there are all the signal names.
# endregion


# region Init Variables Functions

def init_global(p_iface, p_canvas, p_plugin_dir, p_plugin_name, p_user_folder_dir):
    """ Function to initialize the global variables needed to load plugin """

    global iface, canvas
    iface = p_iface
    canvas = p_canvas
    lib_vars.plugin_dir = p_plugin_dir
    lib_vars.plugin_name = p_plugin_name
    lib_vars.user_folder_dir = p_user_folder_dir


def init_giswater_settings(setting_file):
    """ Function to set Giswater settings: stored in the registry (on Windows) or .ini file (on Unix) """

    global giswater_settings
    giswater_settings = QSettings(setting_file, QSettings.IniFormat)
    giswater_settings.setIniCodec(sys.getfilesystemencoding())


def init_qgis_settings(p_plugin_name):
    """ Function to set QGIS settings: stored in the registry (on Windows) or .ini file (on Unix) """

    lib_vars.plugin_name = p_plugin_name

# endregion