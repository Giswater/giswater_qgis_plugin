"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import sys

from qgis.PyQt.QtCore import QSettings


# region system variables (values are initialized on load project without changes during session)

iface = None                            # An instance of interface that provides the hook by which you can manipulate the QGIS application at run time. Type "QgsInterface"
canvas = None                           # An insance of QGIS canvas. Contains "canvas", "mapTool", "xyCoordinates", "Cursor", "Extent"
plugin_dir = None                       # An instance of plugin directory path
plugin_name = None                      # An instance of plugin name
user_folder_dir = None                  # An instance of configurable user variables directory path
schema_name = None                      # An instance of schema name retrieved from qgis project connection with PostgreSql
project_type = None                     # An instance of project type getting from "version" table from PostgreSql
srid = None                             # An instance of srid parameter retrieved from qgis project layer "v_edit_node"
logger = None                           # An instance of GwLogger class thats found in "/lib/tools_log.py"
giswater_settings = None                # An instance of QGIS settings relating to Giswater variables such as toolbars and actions chekeables"
qgis_settings = None                    # An instance of QGIS settings"
current_user = None                     # An instance of user credential used to establish the connection with PostgreSql
qgis_db_credentials = None              # An instance of QSqlDatabase (QPSQL) used to manage QTableView widgets
dao = None                              # An instance of GwPgDao class thats found in "/lib/tools_db.py"
dao_db_credentials = None               # An instance of credentials used to establish the connection with PostgreSql. Saving {db, schema, table, service, host, port, user, password, sslmode}
pg_version = None                       # An instance of PostgreSql version of current connection
notify = None                           # An instance of GwNotify
project_vars = {}                       # An instance of project variables from QgsProject relating to Giswater
project_vars['info_type'] = None        # gwInfoType
project_vars['add_schema'] = None       # gwAddSchema
project_vars['main_schema'] = None      # gwMainSchema
project_vars['project_role'] = None     # gwProjectRole
project_vars['project_type'] = None     # gwProjectType
epsg = None                             # An instance of project epsg
# endregion


# region global user variables (values are initialized on load project without changes during session)
shortcut_keys = []                      # An instance of used shortcut_keys for Giswater menu. This keys are configurated on file "init.config" from user config path "/user/AppData/Roaming/Giswater/"
user_level = {                          # An instance used to know user level and user level configuration
    'level': None,                      # initial=1, normal=2, expert=3
    'showquestion': None,               # Used for show help (default config show for level 1 and 2)
    'showsnapmessage': None,            # Used to indicate to the user that they can snapping
    'showselectmessage': None,          # Used to indicate to the user that they can select
    'showadminadvanced': None}          # Manage advanced tab, fields manager tab and sample dev radio button from admin
date_format = None                      # Display format of the dates allowed in the forms: dd/MM/yyyy or dd-MM-yyyy or yyyy/MM/dd or yyyy-MM-dd
# endregion



# region Dynamic Variables (variables may change value during user's session)

session_vars = {}
session_vars['last_error'] = None       # An instance of the last database runtime error
session_vars['last_error_msg'] = None   # An instance of the last database runtime error message used in threads
session_vars['threads'] = []            # An instance of the different threads for the execution of the Giswater functionalities (type:list)
session_vars['dialog_docker'] = None    # An instance of GwDocker from "/core/ui/docker.py" which is used to mount a docker form
session_vars['info_docker'] = None      # An instance of current status of the info docker form configured by user. Can be True or False
session_vars['docker_type'] = None      # An instance of current status of the docker form configured by user. Can be configured "qgis_info_docker" and "qgis_form_docker"
session_vars['logged_status'] = None    # An instance of connection status. Can be True or False
session_vars['last_focus'] = None       # An instance of the last focused dialog's tag

info_templates = {}                     # Stores all the needed variables for the info template.
                                        # The first key is the feature_id, then has these keys:
                                        # 'dlg', 'json', 'open', 'my_json_{feature_id}', 'last_json_{feature_id}'

# endregion

# region Init Variables Functions

def init_global(p_iface, p_canvas, p_plugin_dir, p_plugin_name, p_user_folder_dir):
    """ Function to initialize the global variables needed to load plugin """

    global iface, canvas, plugin_dir, plugin_name, user_folder_dir
    iface = p_iface
    canvas = p_canvas
    plugin_dir = p_plugin_dir
    plugin_name = p_plugin_name
    user_folder_dir = p_user_folder_dir


def init_giswater_settings(setting_file):
    """ Function to set Giswater settings: stored in the registry (on Windows) or .ini file (on Unix) """

    global giswater_settings
    giswater_settings = QSettings(setting_file, QSettings.IniFormat)
    giswater_settings.setIniCodec(sys.getfilesystemencoding())


def init_qgis_settings(p_plugin_name):
    """ Function to set QGIS settings: stored in the registry (on Windows) or .ini file (on Unix) """

    global plugin_name, qgis_settings
    plugin_name = p_plugin_name
    qgis_settings = QSettings()
    qgis_settings.setIniCodec(sys.getfilesystemencoding())

# endregion