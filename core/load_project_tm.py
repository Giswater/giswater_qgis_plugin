"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsEditorWidgetSetup, QgsFieldConstraints, QgsProject, QgsApplication
from qgis.PyQt.QtCore import QPoint, Qt
from qgis.PyQt.QtWidgets import QAction, QApplication, QDockWidget, QMenu, QToolBar, QToolButton
from qgis.PyQt.QtGui import QCursor, QIcon, QPixmap

import os
import json
from functools import partial

from .. import global_vars
from ..lib.qgis_tools import QgisTools
from .manage_layers import ManageLayers
from ..ui_manager import DialogTextUi
from ..actions.basic import Basic
from ..actions.edit import Edit
from ..actions.go2epa import Go2Epa
from ..actions.master import Master
from ..actions.mincut import MincutParent
from ..actions.notify_functions import NotifyFunctions
from ..actions.om import Om
from ..actions.tm_basic import TmBasic
from ..actions.update_sql import UpdateSQL
from ..actions.utils import Utils
from ..actions.custom import Custom
from ..actions.add_layer import AddLayer
from ..actions.check_project_result import CheckProjectResult
from ..actions.task_config_layer_fields import TaskConfigLayerFields


class LoadProject:

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to manage layers. Refactor code from giswater.py """

        self.iface = iface
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir
        self.qgis_tools = QgisTools(iface, self.plugin_dir)
        self.list_to_hide = []


    def project_read(self, show_warning=True):
        """ Function executed when a user opens a QGIS project (*.qgs) """

        # Check if loaded project is valid for Giswater
        if not self.check_project(show_warning):
            return

        # Force commit before opening project and set new database connection
        if not self.manage_controller(show_warning):
            return

        # Manage schema name
        self.controller.get_current_user()
        layer_source = self.qgis_tools.qgis_get_layer_source(self.layer_node)
        self.schema_name = layer_source['schema']
        self.schema_name = self.schema_name.replace('"', '')
        self.controller.plugin_settings_set_value("schema_name", self.schema_name)
        self.controller.set_schema_name(self.schema_name)

        # Manage locale and corresponding 'i18n' file
        self.controller.manage_translation(self.plugin_name)

        # Set PostgreSQL parameter 'search_path'
        self.controller.set_search_path(layer_source['schema'])

        # Check if schema exists
        self.schema_exists = self.controller.check_schema(self.schema_name)
        if not self.schema_exists:
            self.controller.show_warning("Selected schema not found", parameter=self.schema_name)

        # Get SRID from table node
        self.srid = self.controller.get_srid('v_edit_node', self.schema_name)
        self.controller.plugin_settings_set_value("srid", self.srid)

        # Get variables from qgis project
        self.project_vars = self.qgis_tools.get_qgis_project_variables()
        global_vars.set_project_vars(self.project_vars)

        # Check that there are no layers (v_edit_node) with the same view name, coming from different schemes
        status = self.check_layers_from_distinct_schema()
        if status is False: return

        self.parent = ParentAction(self.iface, global_vars.settings, self.controller, self.plugin_dir)

        # Get water software from table 'version'
        self.project_type = self.controller.get_project_type()
        if self.project_type is None:
            return

        # Initialize toolbars
        self.initialize_toolbars()
        self.get_buttons_to_hide()

        # Manage project read of type 'tm'
        if self.project_type == 'tm':
            self.project_read_tm()
            return

        # Manage project read of type 'pl'
        elif self.project_type == 'pl':
            self.project_read_pl()
            return

        # Set custom plugin toolbars (one action class per toolbar)
        if self.project_type == 'ws':
            self.mincut = MincutParent(self.iface, global_vars.settings, self.controller, self.plugin_dir)

        # Manage records from table 'cat_feature'
        self.manage_feature_cat()

        # Manage snapping layers
        self.manage_snapping_layers()

        # Manage actions of the different plugin_toolbars
        self.manage_toolbars()

        # Set actions to controller class for further management
        self.controller.set_actions(self.actions)

        # Set objects for map tools classes
        self.manage_map_tools()

        # Check roles of this user to show or hide toolbars
        self.check_user_roles()

        # Create a thread to listen selected database channels
        if global_vars.settings.value('system_variables/use_notify').upper() == 'TRUE':
            self.notify = NotifyFunctions(self.iface, global_vars.settings, self.controller, self.plugin_dir)
            self.notify.set_controller(self.controller)
            list_channels = ['desktop', self.controller.current_user]
            self.notify.start_listening(list_channels)

        # Save toolbar position after save project
        self.iface.actionSaveProject().triggered.connect(self.save_toolbars_position)

        # Hide info button if giswater project is loaded
        if show_warning:
            self.set_info_button_visible(False)

        # Open automatically 'search docker' depending its value in user settings
        open_search = self.controller.get_user_setting_value('open_search', 'true')
        if open_search == 'true':
            self.basic.basic_api_search()

        # call dynamic mapzones repaint
        self.parent.set_style_mapzones()

        # Manage layers and check project
        self.manage_layers = ManageLayers(self.iface, global_vars.settings, self.controller, self.plugin_dir)
        self.manage_layers.set_params(self.project_type, self.schema_name, self.project_vars['infotype'],
                                     self.project_vars['add_schema'])
        self.controller.log_info("Start load_project")
        if not self.manage_layers.config_layers():
            self.controller.log_info("False load_project")
            return

        # Log it
        message = "Project read successfully"
        self.controller.log_info(message)


    def check_project(self, show_warning):
        """ # Check if loaded project is valid for Giswater """

        # Check if table 'v_edit_node' is loaded
        self.layer_node = self.controller.get_layer_by_tablename("v_edit_node")
        if not self.layer_node and show_warning:
            layer_arc = self.controller.get_layer_by_tablename("v_edit_arc")
            layer_connec = self.controller.get_layer_by_tablename("v_edit_connec")
            if layer_arc or layer_connec:
                title = "Giswater plugin cannot be loaded"
                msg = "QGIS project seems to be a Giswater project, but layer 'v_edit_node' is missing"
                self.controller.show_warning(msg, 20, title=title)
                return False

        return True


    def manage_controller(self, show_warning, force_commit=False):
        """ Set new database connection. If force_commit=True then force commit before opening project """

        try:
            if self.controller.dao and force_commit:
                self.controller.log_info("Force commit")
                self.controller.dao.commit()
        except Exception as e:
            self.controller.log_info(str(e))
        finally:
            self.connection_status, not_version = self.controller.set_database_connection()
            if not self.connection_status or not_version:
                message = self.controller.last_error
                if show_warning:
                    if message:
                        self.controller.show_warning(message, 15)
                    self.controller.log_warning(str(self.controller.layer_source))
                return False

            return True


    def check_layers_from_distinct_schema(self):

        layers = self.controller.get_layers()
        repeated_layers = {}
        for layer in layers:
            layer_toc_name = self.controller.get_layer_source_table_name(layer)
            if layer_toc_name == 'v_edit_node':
                layer_source = self.controller.get_layer_source(layer)
                repeated_layers[layer_source['schema'].replace('"', '')] = 'v_edit_node'

        if len(repeated_layers) > 1:
            if self.project_vars['main_schema'] is None or self.project_vars['add_schema'] is None:
                self.dlg_dtext = DialogTextUi()
                self.dlg_dtext.btn_accept.hide()
                self.dlg_dtext.btn_close.clicked.connect(lambda: self.dlg_dtext.close())
                msg = "QGIS project has more than one layer v_edit_node comming from differents schemas. " \
                      "If you are looking for manage two schemas, it is mandatory to define wich is the master and " \
                      "wich is the other one. To do this yo need to configure the  QGIS project setting this project " \
                      "variables: gwMainSchema and gwAddSchema."

                self.dlg_dtext.txt_infolog.setText(msg)
                self.dlg_dtext.open()
                return False

            # If there are layers with a different schema, the one that the user has in the project variable
            # 'gwMainSchema' is taken as the schema_name.
            self.schema_name = self.project_vars['main_schema']
            self.controller.set_schema_name(self.project_vars['main_schema'])

        return True


    def initialize_toolbars(self):
        """ Initialize toolbars """

        self.basic = Basic(self.iface, global_vars.settings, self.controller, self.plugin_dir)
        self.utils = Utils(self.iface, global_vars.settings, self.controller, self.plugin_dir)
        self.go2epa = Go2Epa(self.iface, global_vars.settings, self.controller, self.plugin_dir)
        self.om = Om(self.iface, global_vars.settings, self.controller, self.plugin_dir)
        self.edit = Edit(self.iface, global_vars.settings, self.controller, self.plugin_dir)
        self.master = Master(self.iface, global_vars.settings, self.controller, self.plugin_dir)
        self.custom = Custom(self.iface, global_vars.settings, self.controller, self.plugin_dir)


    def get_buttons_to_hide(self):

        try:
            # db format of value for parameter qgis_toolbar_hidebuttons -> {"index_action":[199, 74,75]}
            row = self.controller.get_config('qgis_toolbar_hidebuttons')
            if not row: return
            json_list = json.loads(row[0], object_pairs_hook=OrderedDict)
            self.list_to_hide = [str(x) for x in json_list['action_index']]
        except KeyError:
            pass
        except json.JSONDecodeError:
            # Control if json have a correct format
            pass
        finally:
            # TODO remove this line when do you want enabled api info for epa
            self.list_to_hide.append('199')



