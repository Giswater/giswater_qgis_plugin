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
from functools import partial

from ..actions.add_layer import AddLayer
from ..actions.check_project_result import CheckProjectResult
from ..actions.task_config_layer_fields import TaskConfigLayerFields


class OpenProject:

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to manage layers. Refactor code from giswater.py """

        self.iface = iface
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir
        self.available_layers = None
        self.hide_form = None
        self.add_layer = None
        self.project_type = None
        self.schema_name = None
        self.qgis_project_infotype = None


    def set_params(self, project_type, schema_name, qgis_project_infotype, qgis_project_add_schema):

        self.project_type = project_type
        self.schema_name = schema_name
        self.qgis_project_infotype = qgis_project_infotype
        self.qgis_project_add_schema = qgis_project_add_schema
        self.add_layer = AddLayer(self.iface, self.settings, self.controller, self.plugin_dir)


    def project_read(self, show_warning=True):
        """ Function executed when a user opens a QGIS project (*.qgs) """

        # Unload plugin before reading opened project
        self.unload(False)

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

