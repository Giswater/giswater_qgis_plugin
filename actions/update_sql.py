"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from qgis.PyQt.QtWidgets import QCheckBox, QRadioButton, QComboBox, QLineEdit,QPushButton, QTableView, QLabel, QAbstractItemView, QTextEdit, QFileDialog
from qgis.PyQt.QtGui import QPixmap
from qgis.PyQt.QtCore import QSettings, Qt

import os
import sys
import re
import json
from functools import partial

import utils_giswater
from giswater.actions.parent import ParentAction
from giswater.ui_manager import Readsql, InfoShowInfo, ReadsqlCreateProject, ReadsqlRename, ReadsqlShowInfo


class UpdateSQL(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'om_ws' """

        # Initialize instance attributes
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.giswater_version = "3.1"
        self.iface = iface
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir
        self.schema_name = self.controller.schema_name
        self.project_type = controller.get_project_type()


    def init_sql(self, connection_status=False):
        """ Button 100: Execute SQL. Info show info """

        # Check if we have any layer loaded
        layers = self.controller.get_layers()

        # Get last database connection from controller
        self.last_connection = self.get_last_connection()

        # Get database connection user and role
        self.username = self.get_user_connection(self.last_connection)

        if self.project_type is not None and len(layers) != 0:
            self.info_show_info()
            return

        # Create the dialog and signals
        self.dlg_readsql = Readsql()
        self.load_settings(self.dlg_readsql)
        self.dlg_readsql.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_readsql))

        # Set label status connection
        self.icon_folder = self.plugin_dir + os.sep + 'icons' + os.sep
        self.status_ok = QPixmap(self.icon_folder + 'status_ok.png')
        self.status_ko = QPixmap(self.icon_folder + 'status_ko.png')

        # Check if user have dev permisions
        self.dev_user = self.settings.value('system_variables/devoloper_mode').upper()
        self.read_all_updates = self.settings.value('system_variables/read_all_updates').upper()
        self.dev_commit = self.settings.value('system_variables/dev_commit').upper()

        # Get plugin version
        self.plugin_version = self.get_plugin_version()
        self.project_data_schema_version = '0'

        # Get widgets from form
        self.cmb_connection = self.dlg_readsql.findChild(QComboBox, 'cmb_connection')
        self.btn_update_schema = self.dlg_readsql.findChild(QPushButton, 'btn_update_schema')
        self.btn_update_api = self.dlg_readsql.findChild(QPushButton, 'btn_update_api')
        self.lbl_schema_name = self.dlg_readsql.findChild(QLabel, 'lbl_schema_name')

        # Checkbox SCHEMA & API
        self.chk_schema_view = self.dlg_readsql.findChild(QCheckBox, 'chk_schema_view')
        self.chk_schema_funcion = self.dlg_readsql.findChild(QCheckBox, 'chk_schema_funcion')
        self.chk_api_view = self.dlg_readsql.findChild(QCheckBox, 'chk_api_view')
        self.chk_api_funcion = self.dlg_readsql.findChild(QCheckBox, 'chk_api_funcion')
        self.software_version_info = self.dlg_readsql.findChild(QTextEdit, 'software_version_info')

        btn_info = self.dlg_readsql.findChild(QPushButton, 'btn_info')
        self.set_icon(btn_info, '73')

        self.btn_constrains = self.dlg_readsql.findChild(QPushButton, 'btn_constrains')

        self.message_update = ''

        # Error counter variable
        self.error_count = 0

        # Get locale of QGIS application
        self.locale = QSettings().value('locale/userLocale').lower()
        if self.locale == 'es_es':
            self.locale = 'ES'
        elif self.locale == 'es_ca':
            self.locale = 'CA'
        elif self.locale == 'en_us':
            self.locale = 'EN'

        self.filter_srid_value = self.controller.plugin_settings_value('srid')
        self.schema = None

        # Get metadata version
        self.version_metadata = self.get_plugin_version()

        if self.dev_user != 'TRUE':
            utils_giswater.remove_tab_by_tabName(self.dlg_readsql.tab_main, "schema_manager")
            utils_giswater.remove_tab_by_tabName(self.dlg_readsql.tab_main, "api_manager")
            utils_giswater.remove_tab_by_tabName(self.dlg_readsql.tab_main, "custom")
            self.project_types = self.settings.value('system_variables/project_types')
        else:
            self.project_types = self.settings.value('system_variables/project_types_dev')

        # Declare sql directory
        self.sql_dir = os.path.normpath(os.path.normpath(os.path.dirname(os.path.abspath(__file__)) + os.sep + os.pardir)) + os.sep + 'sql'
        if not os.path.exists(self.sql_dir):
            self.controller.show_message("SQL folder not found", parameter=self.sql_dir)
            return

        # Populate combo types
        self.cmb_project_type = self.dlg_readsql.findChild(QComboBox, 'cmb_project_type')
        for project_type in self.project_types:
            self.cmb_project_type.addItem(str(project_type))
        self.change_project_type(self.cmb_project_type)

        # Populate combo connections
        s = QSettings()
        s.beginGroup("PostgreSQL/connections")
        connections = s.childGroups()
        list_connections = []
        for con in connections:
            elem = [con, con]
            list_connections.append(elem)

        s.endGroup()
        utils_giswater.set_item_data(self.cmb_connection, list_connections, 1)

        # Declare all file variables
        self.file_pattern_tablect = "tablect"
        self.file_pattern_ddl = "ddl"
        self.file_pattern_dml = "dml"
        self.file_pattern_fct = "fct"
        self.file_pattern_trg = "trg"
        self.file_pattern_ftrg = "ftrg"
        self.file_pattern_ddlview = "ddlview"
        self.file_pattern_ddlrule = "ddlrule"

        # Declare all directorys
        if self.schema_name is not None and self.project_type is not None:
            self.folderSoftware = self.sql_dir + os.sep + self.project_type + os.sep

        self.folderLocale = self.sql_dir + os.sep + 'i18n' + os.sep + str(self.locale) + os.sep
        self.folderUtils = self.sql_dir + os.sep + 'utils' + os.sep
        self.folderUpdates = self.sql_dir + os.sep + 'updates' + os.sep
        self.folderExemple = self.sql_dir + os.sep + 'example' + os.sep
        self.folderPath = ''

        # Declare all directorys api
        self.folderUpdatesApi = self.sql_dir + os.sep + 'api' + os.sep + 'updates' + os.sep
        self.folderApi = self.sql_dir + os.sep + 'api' + os.sep

        # Set Listeners
        self.dlg_readsql.btn_schema_create.clicked.connect(partial(self.open_create_project))
        self.dlg_readsql.btn_api_create.clicked.connect(partial(self.implement_api))

        self.dlg_readsql.btn_custom_load_file.clicked.connect(partial(self.load_custom_sql_files, self.dlg_readsql, "custom_path_folder"))
        self.dlg_readsql.btn_update_schema.clicked.connect(partial(self.load_updates, self.project_type_selected))
        self.dlg_readsql.btn_update_api.clicked.connect(partial(self.update_api))
        self.dlg_readsql.btn_schema_file_to_db.clicked.connect(partial(self.schema_file_to_db))
        self.dlg_readsql.btn_api_file_to_db.clicked.connect(partial(self.api_file_to_db))
        btn_info.clicked.connect(partial(self.show_info))
        self.dlg_readsql.project_schema_name.currentIndexChanged.connect(partial(self.set_info_project))
        self.cmb_project_type.currentIndexChanged.connect(partial(self.populate_data_schema_name, self.cmb_project_type))
        self.cmb_project_type.currentIndexChanged.connect(partial(self.change_project_type, self.cmb_project_type))
        self.cmb_project_type.currentIndexChanged.connect(partial(self.set_info_project))
        self.dlg_readsql.btn_custom_select_file.clicked.connect(partial(self.get_folder_dialog, self.dlg_readsql, "custom_path_folder"))
        self.cmb_connection.currentIndexChanged.connect(partial(self.event_change_connection))
        self.cmb_connection.currentIndexChanged.connect(partial(self.set_info_project))
        self.dlg_readsql.btn_schema_rename.clicked.connect(partial(self.open_rename))
        self.dlg_readsql.btn_delete.clicked.connect(partial(self.delete_schema))
        self.dlg_readsql.btn_constrains.clicked.connect(partial(self.btn_constrains_changed, self.btn_constrains, True))

        # Set last connection for default
        utils_giswater.set_combo_itemData(self.cmb_connection, str(self.last_connection), 1)

        # Open dialog
        self.dlg_readsql.setWindowTitle('Giswater (' + str(utils_giswater.getWidgetText(self.dlg_readsql, self.dlg_readsql.cmb_connection)) + ' - ' + str(self.plugin_version) + ')')
        self.dlg_readsql.show()

        if connection_status is False:
            self.controller.show_message("Connection Failed. Please, check connection parameters", 1)
            utils_giswater.dis_enable_dialog(self.dlg_readsql, False, 'cmb_connection')
            self.dlg_readsql.lbl_status.setPixmap(self.status_ko)
            utils_giswater.setWidgetText(self.dlg_readsql, self.dlg_readsql.lbl_status_text, 'Connection Failed. Please, check connection parameters')
            utils_giswater.setWidgetText(self.dlg_readsql, self.dlg_readsql.lbl_schema_name, '')
            return

        else:
            role_admin = self.controller.check_role_user("role_admin", self.username)
            if not role_admin and self.username != 'postgres' and self.username != 'gisadmin':
                msg = "You don't have permissions to administrate project schemas on this connection"
                self.controller.show_message(msg, 1)
                utils_giswater.dis_enable_dialog(self.dlg_readsql, False, 'cmb_connection')
                self.dlg_readsql.lbl_status.setPixmap(self.status_ko)
                utils_giswater.setWidgetText(self.dlg_readsql, self.dlg_readsql.lbl_status_text, msg)
            else:
                utils_giswater.dis_enable_dialog(self.dlg_readsql, True)
                self.dlg_readsql.lbl_status.setPixmap(self.status_ok)
                utils_giswater.setWidgetText(self.dlg_readsql, self.dlg_readsql.lbl_status_text, '')

        self.populate_data_schema_name(self.cmb_project_type)
        self.set_info_project()


    def btn_constrains_changed(self, button, call_function=False):

        lbl_constrains_info = self.dlg_readsql.findChild(QLabel, 'lbl_constrains_info')
        schema_name = utils_giswater.getWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name)

        if button.text() == 'OFF':
            button.setText("ON")
            lbl_constrains_info.setText('(Constrains enabled)  ')
            if call_function:
                # Enable constrains
                sql = 'SELECT ' + schema_name + '.gw_fct_admin_schema_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"ADD"}}$$)'
                self.controller.execute_sql(sql)

        elif button.text() == 'ON':
            button.setText("OFF")
            lbl_constrains_info.setText('(Constrains dissabled)')
            if call_function:
                # Disable constrains
                sql = 'SELECT ' + schema_name + '.gw_fct_admin_schema_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"DROP"}}$$)'
                self.controller.execute_sql(sql)


    """ Declare all read sql process """

    def load_base(self, project_type=False):

        status = True
        if str(project_type) == 'ws' or str(project_type) == 'ud':

            folder = self.folderUtils + self.file_pattern_ddl
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderUtils + self.file_pattern_dml
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderUtils + self.file_pattern_fct
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False
            folder = self.folderUtils + self.file_pattern_ftrg
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderSoftware + self.file_pattern_ddl
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderSoftware + self.file_pattern_ddlrule
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderSoftware + self.file_pattern_dml
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderSoftware + self.file_pattern_tablect
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderSoftware + self.file_pattern_fct
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderSoftware + self.file_pattern_ftrg
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderUtils + self.file_pattern_tablect
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderUtils + self.file_pattern_ddlrule
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False
            if self.process_folder(self.folderLocale, '') is False:
                if self.process_folder(self.sql_dir + os.sep + 'i18n' + os.sep, 'EN') is False:
                    return False
                else:
                    status = self.executeFiles(self.sql_dir + os.sep + 'i18n' + os.sep + 'EN', True)
                    if status is False:
                        return False
            else:
                status = self.executeFiles(self.folderLocale, True)
                if status is False:
                    return False
        else:

            folder = self.folderSoftware + self.file_pattern_ddl
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderSoftware + self.file_pattern_ddlrule
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderSoftware + self.file_pattern_dml
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderSoftware + self.file_pattern_fct
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderSoftware + self.file_pattern_ftrg
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderSoftware + self.file_pattern_tablect
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            if self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'i18n' + os.sep + utils_giswater.getWidgetText(self.dlg_readsql, self.cmb_locale) + os.sep, '') is False:
                if self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'i18n' + os.sep, 'EN') is False:
                    return False
                else:
                    status = self.executeFiles(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'i18n' + os.sep + 'EN', True)
                    if status is False:
                        return False
            else:
                status = self.executeFiles(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'i18n' + os.sep + utils_giswater.getWidgetText(self.dlg_readsql, self.cmb_locale) + os.sep, True)
                if status is False:
                    return False

        return True


    def load_base_no_ct(self, project_type):

        status = True
        if str(project_type) == 'ws' or str(project_type) == 'ud':
            folder = self.folderUtils + self.file_pattern_ddl
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderUtils + self.file_pattern_dml
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderUtils + self.file_pattern_fct
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderUtils + self.file_pattern_ftrg
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderSoftware + self.file_pattern_ddl
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderSoftware + self.file_pattern_ddlrule
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderSoftware + self.file_pattern_dml
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderSoftware + self.file_pattern_fct
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderSoftware + self.file_pattern_ftrg
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderUtils + self.file_pattern_ddlrule
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            if self.process_folder(self.folderLocale, '') is False:
                if self.process_folder(self.sql_dir + os.sep + 'i18n' + os.sep, 'EN') is False:
                    return False
                else:
                    status = self.executeFiles(self.sql_dir + os.sep + 'i18n' + os.sep + 'EN', True)
                    if status is False:
                        return False
            else:
                status = self.executeFiles(self.folderLocale, True)
                if status is False:
                    return False

        else:
            folder = self.folderSoftware + self.file_pattern_ddl
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderSoftware + self.file_pattern_ddlrule
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderSoftware + self.file_pattern_dml
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderSoftware + self.file_pattern_fct
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderSoftware + self.file_pattern_ftrg
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            if self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'i18n' + os.sep + utils_giswater.getWidgetText(self.dlg_readsql, self.cmb_locale) + os.sep, '') is False:
                if self.process_folder(self.sql_dir + os.sep + 'i18n' + os.sep, 'EN') is False:
                    return False
                else:
                    status = self.executeFiles(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'i18n' + os.sep + 'EN', True)
                    if status is False:
                        return False
            else:
                status = self.executeFiles(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'i18n' + os.sep + utils_giswater.getWidgetText(self.dlg_readsql, self.cmb_locale) + os.sep, True)
                if status is False:
                    return False

        return True


    def update_31to39(self, new_project=False, project_type=False, no_ct=False):

        status = True

        if str(project_type) == 'ws' or str(project_type) == 'ud':
            if not os.path.exists(self.folderUpdates):
                self.controller.show_message("The update folder was not found in sql folder.", 1)
                self.error_count = self.error_count + 1
                return
            folders = os.listdir(self.folderUpdates + '')
            for folder in folders:
                sub_folders = os.listdir(self.folderUpdates + folder)
                for sub_folder in sub_folders:
                    if new_project:
                        if self.read_all_updates == 'TRUE':
                            if str(sub_folder) > '31100':
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder,
                                                       os.sep + 'utils' + os.sep) is True:
                                    status = self.load_sql(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep, no_ct=no_ct)
                                    if status is False:
                                        return False
                                if self.process_folder(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + project_type + os.sep,
                                        '') is True:
                                    status = self.load_sql(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + project_type + os.sep, no_ct=no_ct)
                                    if status is False:
                                        return False
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep), '') is True:
                                    status = self.executeFiles(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                            self.locale + os.sep), True)
                                    if status is False:
                                        return False
                                elif self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is True:
                                    status = self.executeFiles(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', True)
                                    if status is False:
                                        return False
                        else:
                            if str(sub_folder) > '31100' and str(sub_folder) <= str(self.version_metadata).replace('.', ''):
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder,
                                                       os.sep + 'utils' + os.sep) is True:
                                    status = self.load_sql(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep, no_ct=no_ct)
                                    if status is False:
                                        return False
                                if self.process_folder(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + project_type + os.sep,
                                        '') is True:
                                    status = self.load_sql(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + project_type + os.sep, no_ct=no_ct)
                                    if status is False:
                                        return False
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep), '') is True:
                                    status = self.executeFiles(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                            self.locale + os.sep), True)
                                    if status is False:
                                        return False
                                elif self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is True:
                                    status = self.executeFiles(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', True)
                                    if status is False:
                                        return False
                    else:
                        if self.read_all_updates == 'TRUE':
                            if str(sub_folder) > str(self.project_data_schema_version).replace('.', '') and str(sub_folder) > '31100':
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder, os.sep + 'utils' + os.sep) is True:
                                    status = self.load_sql(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep)
                                    if status is False:
                                        return False
                                if self.process_folder(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + self.project_type_selected + os.sep,
                                        '') is True:
                                    status = self.load_sql(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + self.project_type_selected + os.sep)
                                    if status is False:
                                        return False
                                if self.process_folder(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep),
                                        '') is True:
                                    status = self.executeFiles(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                            self.locale + os.sep))
                                    if status is False:
                                        return False
                                elif self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is True:
                                    status = self.executeFiles(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', True)
                                    if status is False:
                                        return False
                        else:
                            if str(sub_folder) > str(self.project_data_schema_version).replace('.', '') and str(sub_folder) > '31100' and str(sub_folder) <= str(self.version_metadata).replace('.', ''):
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder, os.sep + 'utils' + os.sep) is True:
                                    status = self.load_sql(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep)
                                    if status is False:
                                        return False
                                if self.process_folder(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + self.project_type_selected + os.sep,
                                        '') is True:
                                    status = self.load_sql(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + self.project_type_selected + os.sep)
                                    if status is False:
                                        return False
                                if self.process_folder(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep),
                                        '') is True:
                                    status = self.executeFiles(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                            self.locale + os.sep))
                                    if status is False:
                                        return False
                                elif self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is True:
                                    status = self.executeFiles(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', True)
                                    if status is False:
                                        return False
        else:
            if not os.path.exists(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + ''):
                return
            folders = os.listdir(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + '')
            for folder in folders:
                sub_folders = os.listdir(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder)
                for sub_folder in sub_folders:
                    if new_project:
                        if self.read_all_updates == 'TRUE':
                            if str(sub_folder) > '31100':
                                if self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder, '') is True:
                                    status = self.executeFiles(self.sql_dir + os.sep + str(
                                        project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep))
                                    if status is False:
                                        return False
                                elif self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep), '') is True:
                                        status = self.executeFiles(self.sql_dir + os.sep + str(project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'EN', True)
                                        if status is False:
                                            return False

                        else:
                            if str(sub_folder) > '31100' and str(sub_folder) <= str(self.version_metadata).replace('.',''):
                                if self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder,
                                                       '') is True:
                                    status = self.load_sql(self.sql_dir + os.sep + str(project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder)
                                    if status is False:
                                        return False
                                if self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep), '') is True:
                                    status = self.executeFiles(self.sql_dir + os.sep + str(
                                        project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep))
                                elif self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is True:
                                    status = self.executeFiles(self.sql_dir + os.sep + str(project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'EN', True)
                                    if status is False:
                                        return False

                    else:
                        if self.read_all_updates == 'TRUE':
                            if str(sub_folder) > str(self.project_data_schema_version).replace('.', '') and str(sub_folder) > '31100':
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder, os.sep + 'utils' + os.sep) is True:
                                    status = self.load_sql(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep)
                                    if status is False:
                                        return False
                                if self.process_folder(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + self.project_type + os.sep,
                                        '') is True:
                                    status = self.load_sql(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + self.project_type + os.sep)
                                    if status is False:
                                        return False
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep),'') is True:
                                    status = self.executeFiles(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                            self.locale + os.sep))
                                    if status is False:
                                        return False
                                elif self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is True:
                                    status = self.executeFiles(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', True)
                                    if status is False:
                                        return False

                        else:
                            if str(sub_folder) > str(self.project_data_schema_version).replace('.', '') and str(sub_folder) > '31100' and str(sub_folder) <= str(self.version_metadata).replace('.', ''):
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder, os.sep + 'utils' + os.sep) is True:
                                    status = self.load_sql(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep)
                                    if status is False:
                                        return False
                                if self.process_folder(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + self.project_type + os.sep,
                                        '') is True:
                                    status = self.load_sql(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + self.project_type + os.sep)
                                    if status is False:
                                        return False
                                if self.process_folder(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep),
                                        '') is True:
                                    status = self.executeFiles(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                            self.locale + os.sep))
                                    if status is False:
                                        return False
                                elif self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is True:
                                    status = self.executeFiles(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', True)
                                    if status is False:
                                        return False

        return True


    def load_views(self, project_type=False):

        status = True

        if str(project_type) == 'ws' or str(project_type) == 'ud':
            folder = self.folderSoftware + self.file_pattern_ddlview
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderUtils + self.file_pattern_ddlview
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

        else:
            folder = self.folderSoftware + self.file_pattern_ddlview
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

        return True


    def update_30to31(self, new_project=False, project_type=False):

        status = True

        if str(project_type) == 'ws' or str(project_type) == 'ud':
            if not os.path.exists(self.folderUpdates):
                self.controller.show_message("The update folder was not found in sql folder.", 1)
                self.error_count = self.error_count + 1
                return
            folders = os.listdir(self.folderUpdates + '')
            for folder in folders:
                sub_folders = os.listdir(self.folderUpdates + folder)
                for sub_folder in sub_folders:
                    if new_project:
                        if str(sub_folder) <= '31100':
                            if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder, os.sep + 'utils' + os.sep) is True:
                                status = self.load_sql(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep)
                                if status is False:
                                    return False
                            if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + project_type + os.sep, '') is True:
                                status = self.load_sql(self.folderUpdates + folder + os.sep + sub_folder + os.sep + project_type + os.sep)
                                if status is False:
                                    return False
                            if self.process_folder(
                                    self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep),
                                    '') is True:
                                status = self.executeFiles(
                                    self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep))
                                if status is False:
                                    return False
                            elif self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is False:
                                status = self.executeFiles(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', True)
                                if status is False:
                                    return False
                    else:
                        if str(sub_folder) > str(self.project_data_schema_version).replace('.', '') and str(sub_folder) <= '31100':
                            if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder, os.sep + 'utils' + os.sep) is True:
                                status = self.load_sql(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep)
                                if status is False:
                                    return False
                            if self.process_folder(
                                    self.folderUpdates + folder + os.sep + sub_folder + os.sep + self.project_type_selected + os.sep,
                                    '') is True:
                                status = self.load_sql(
                                    self.folderUpdates + folder + os.sep + sub_folder + os.sep + self.project_type_selected + os.sep)
                                if status is False:
                                    return False
                            if self.process_folder(
                                    self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep),
                                    '') is True:
                                status = self.executeFiles(
                                    self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep))
                                if status is False:
                                    return False
                            elif self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', '') is True:
                                status = self.executeFiles(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', True)
                                if status is False:
                                    return False
        else:
            if not os.path.exists(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + ''):
                return
            folders = os.listdir(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + '')
            for folder in folders:
                sub_folders = os.listdir(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder)
                for sub_folder in sub_folders:
                    if new_project:
                        if str(sub_folder) <= '31100':
                            if self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder, '') is True:
                                status = self.load_sql(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + '')
                                if status is False:
                                    return False
                            if self.process_folder(
                                    self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep),
                                    '') is True:
                                status = self.executeFiles(self.sql_dir + os.sep + str(
                                    project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                    self.locale + os.sep))
                                if status is False:
                                    return False
                            elif self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is True:
                                status = self.executeFiles(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN' + os.sep, True)
                                if status is False:
                                    return False

                    else:
                        if str(sub_folder) > str(self.project_data_schema_version).replace('.', '') and str(sub_folder) <= '31100':
                            if self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder, '') is True:
                                status = self.load_sql(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + '')
                                if status is False:
                                    return False
                            if self.process_folder(
                                    self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep),
                                    '') is True:
                                status = self.executeFiles(self.sql_dir + os.sep + str(
                                    project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                    self.locale + os.sep))
                                if status is False:
                                    return False
                            elif self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is True:
                                status = self.executeFiles(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN' + os.sep, True)
                                if status is False:
                                    return False
        return True


    def load_sample_data(self, project_type=False):

        status = True
        if str(project_type) == 'ws' or str(project_type) == 'ud':
            folder = self.folderExemple + 'user' + os.sep+project_type
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

        else:
            folder = self.folderSoftware + 'example' + os.sep + 'user' + os.sep
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

        return True


    def load_dev_data(self, project_type=False):

        status = True
        if str(project_type) == 'ws' or str(project_type) == 'ud':
            folder = self.folderExemple + 'dev' + os.sep + project_type
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False
        else:
            folder = self.folderSoftware + 'example' + os.sep + 'dev' + os.sep
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

        return True


    def load_fct_ftrg(self, project_type=False):

        status = True
        if str(project_type) == 'ws' or str(project_type) == 'ud':
            folder = self.folderUtils + self.file_pattern_fct
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderUtils + self.file_pattern_ftrg
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderSoftware + self.file_pattern_fct
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderSoftware + self.file_pattern_ftrg
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

        else:
            folder = self.folderSoftware + self.file_pattern_fct
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderSoftware + self.file_pattern_ftrg
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

        return True


    def load_tablect(self, project_type=False):

        status = True
        if str(project_type) == 'ws' or str(project_type) == 'ud':
            folder = self.folderSoftware + self.file_pattern_tablect
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderUtils + self.file_pattern_tablect
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

        else:
            folder = self.folderSoftware + self.file_pattern_tablect
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

        return True


    def load_trg(self, project_type=False):

        status = True
        if str(project_type) == 'ws' or str(project_type) == 'ud':

            folder = self.folderUtils + self.file_pattern_trg
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

            folder = self.folderSoftware + self.file_pattern_trg
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

        else:
            folder = self.folderSoftware + self.file_pattern_trg
            status = self.executeFiles(folder)
            if not status and self.dev_commit == 'FALSE':
                return False

        return True


    def load_sql(self, path_folder, no_ct=False):

        for (path, ficheros, archivos) in os.walk(path_folder):
            status = self.executeFiles(path, no_ct=no_ct)
            if status is False:
                return False

        return True


    def api(self, new_api=False, project_type=False):

        status = True
        folder = self.folderApi + self.file_pattern_ftrg
        status = self.executeFiles(folder)
        if not status and self.dev_commit == 'FALSE':
            return False
        folder = self.folderApi + self.file_pattern_fct
        status = self.executeFiles(folder)
        if not status and self.dev_commit == 'FALSE':
            return False
        if not os.path.exists(self.folderUpdatesApi):
            self.controller.show_message("The api folder was not found in sql folder.", 1)
            self.error_count = self.error_count + 1
            return
        folders = os.listdir(self.folderUpdatesApi + '')
        self.controller.log_info(str(folders))
        for folder in folders:
            sub_folders = os.listdir(self.folderUpdatesApi + folder)
            for sub_folder in sub_folders:
                if new_api:
                    if self.read_all_updates == 'TRUE':
                        if self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep, '') is True:
                            status = self.executeFiles(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep + '')
                            if status is False:
                                return False

                        if self.process_folder(
                                self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep),
                                '') is True:
                            status = self.executeFiles(
                                self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                    self.locale + os.sep))
                            if status is False:
                                return False
                        elif self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is True:
                            status = self.executeFiles(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + self.locale + os.sep, True)
                            if status is False:
                                return False
                        if self.process_folder(self.sql_dir + os.sep + 'api' + os.sep, self.file_pattern_trg) is True:
                            status = self.executeFiles(self.sql_dir + os.sep + 'api' + os.sep + self.file_pattern_trg)
                            if status is False:
                                return False
                        if self.process_folder(self.sql_dir + os.sep + 'api' + os.sep, self.file_pattern_tablect) is True:
                            status = self.executeFiles(self.sql_dir + os.sep + 'api' + os.sep + self.file_pattern_tablect)
                            if status is False:
                                return False
                    else:
                        if str(sub_folder) <= str(self.version_metadata).replace('.', ''):
                            self.controller.log_info("TEST72")
                            if self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep,
                                                   '') is True:
                                status = self.executeFiles(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep + '')
                                if status is False:
                                    return False
                            if self.process_folder(
                                    self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep),
                                    '') is True:
                                status = self.executeFiles(
                                    self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep))
                                if status is False:
                                    return False
                            elif self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep,
                                                   'EN') is True:
                                status = self.executeFiles(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + self.locale + os.sep,
                                    True)
                                if status is False:
                                    return False
                            if self.process_folder(self.sql_dir + os.sep + 'api' + os.sep, self.file_pattern_trg) is True:
                                status = self.executeFiles(self.sql_dir + os.sep + 'api' + os.sep + self.file_pattern_trg)
                                if status is False:
                                    return False
                            if self.process_folder(self.sql_dir + os.sep + 'api' + os.sep, self.file_pattern_tablect) is True:
                                status = self.executeFiles(self.sql_dir + os.sep + 'api' + os.sep + self.file_pattern_tablect)
                                if status is False:
                                    return False
                else:
                    if self.read_all_updates == 'TRUE':
                        if str(sub_folder) > str(self.project_data_schema_version).replace('.', ''):
                            if self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep, '') is True:
                                status = self.executeFiles(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep + '')
                                if status is False:
                                    return False
                            if self.process_folder(
                                    self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep),
                                    '') is True:
                                status = self.executeFiles(
                                    self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep))
                                if status is False:
                                    return False
                            elif self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is True:
                                status = self.executeFiles(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN' + os.sep, True)
                                if status is False:
                                    return False
                            if self.process_folder(self.sql_dir + os.sep + 'api' + os.sep, self.file_pattern_trg) is True:
                                status = self.executeFiles(self.sql_dir + os.sep + 'api' + os.sep + self.file_pattern_trg)
                                if status is False:
                                    return False
                            if self.process_folder(self.sql_dir + os.sep + 'api' + os.sep, self.file_pattern_tablect) is True:
                                status = self.executeFiles(self.sql_dir + os.sep + 'api' + os.sep + self.file_pattern_tablect)
                                if status is False:
                                    return False
                    else:
                        if str(sub_folder) <= str(self.version_metadata).replace('.', ''):
                            if self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep,
                                                   '') is True:
                                status = self.executeFiles(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep + '')
                                if status is False:
                                    return False
                            if self.process_folder(
                                    self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep),
                                    '') is True:
                                status = self.executeFiles(
                                    self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep))
                                if status is False:
                                    return False
                            elif self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep,
                                                   'EN') is True:
                                status = self.executeFiles(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN' + os.sep,
                                    True)
                                if status is False:
                                    return False
                            if self.process_folder(self.sql_dir + os.sep + 'api' + os.sep, self.file_pattern_trg) is True:
                                status = self.executeFiles(self.sql_dir + os.sep + 'api' + os.sep + self.file_pattern_trg)
                                if status is False:
                                    return False
                            if self.process_folder(self.sql_dir + os.sep + 'api' + os.sep, self.file_pattern_tablect) is True:
                                status = self.executeFiles(self.sql_dir + os.sep + 'api' + os.sep + self.file_pattern_tablect)
                                if status is False:
                                    return False
        return True


    """ Functions execute process """


    def execute_import_data(self):
        self.insert_inp_into_db(self.file_inp)
        # Execute import data
        sql = ("SELECT " + self.schema + ".gw_fct_utils_csv2pg_import_epa_inp(null)")
        self.controller.execute_sql(sql, commit=False)


    def execute_last_process(self, new_project=False, schema_name='', schema_type='', locale=False):
        """ Execute last process function """

        if new_project is True:
            extras = '"isNewProject":"' + str('TRUE') + '", '
        else:
            extras = '"isNewProject":"' + str('FALSE') + '", '
        extras += '"gwVersion":"' + str(self.version_metadata) + '", '
        extras += '"projectType":"' + str(schema_type).upper() + '", '
        extras += '"epsg":' + str(self.filter_srid_value).replace('"', '')
        if new_project is True:
            if str(self.title) != 'null':
                extras += ', ' + '"title":"' + str(self.title) + '"'
            if str(self.author) != 'null':
                extras += ', ' + '"author":"' + str(self.author) + '"'
            if str(self.date) != 'null':
                extras += ', ' + '"date":"' + str(self.date) + '"'

        self.schema_name = schema_name

        # Get current locale
        if locale:
            locale = ''
        else:
            locale = utils_giswater.getWidgetText(self.dlg_readsql_create_project,
                                                  self.dlg_readsql_create_project.cmb_locale)

        client = '"client":{"device":9, "lang":"'+locale+'"}, '
        data = '"data":{' + extras + '}'
        body = "" + client + data
        sql = ("SELECT " + self.schema_name + ".gw_fct_admin_schema_lastprocess($${" + body + "}$$)::text")
        status = self.controller.execute_sql(sql, commit=False)
        if status is False:
            self.error_count = self.error_count + 1

        return


    """ Buttons calling functions """


    def create_project_data_schema(self):

        self.title = utils_giswater.getWidgetText(self.dlg_readsql_create_project, self.project_title)
        self.author = utils_giswater.getWidgetText(self.dlg_readsql_create_project, self.project_author)
        self.date = utils_giswater.getWidgetText(self.dlg_readsql_create_project, self.project_date)
        project_name = str(utils_giswater.getWidgetText(self.dlg_readsql_create_project, self.project_name))
        schema_type = utils_giswater.getWidgetText(self.dlg_readsql_create_project, self.dlg_readsql_create_project.cmb_create_project_type)
        self.filter_srid_value = utils_giswater.getWidgetText(self.dlg_readsql_create_project, self.dlg_readsql_create_project.srid_id)

        if project_name == 'null':
            msg = "The 'Project_name' field is required."
            self.controller.show_info_box(msg, "Info")
            return
        elif any(c.isupper() for c in project_name) is True:
            msg = "The 'Project_name' field require only lower caracters"
            self.controller.show_info_box(msg, "Info")
            return
        elif (bool(re.match('^[a-z0-9_]*$', project_name))) is False:
            msg = "The 'Project_name' field have invalid character"
            self.controller.show_info_box(msg, "Info")
            return
        if self.title == 'null':
            msg = "The 'Title' field is required."
            self.controller.show_info_box(msg, "Info")
            return

        sql = "SELECT schema_name, schema_name FROM information_schema.schemata"
        rows = self.controller.get_rows(sql)
        available = False
        for row in rows:
            if str(project_name) == str(row[0]):
                i = 0
                msg = "This 'Project_name' is already exist. Do you want rename old schema to '" + str(
                    project_name) + "_bk_" + str(i) + "' ?"
                result = self.controller.ask_question(msg, "Info")
                if result:
                    while available is False:
                        for row in rows:
                            if str(project_name) + "_bk" == str(row[0]) or \
                               str(project_name) + "_bk_" + str(i) == str(row[0]):
                                msg = "This 'Project_name' is already exist. Do you want rename old schema to '" + str(
                                    project_name) + "_bk_" + str(i+1) + "' ?"
                                result = self.controller.ask_question(msg, "Info")
                                i = i + 1
                            else:
                                available = True
                    self.rename_project_data_schema(str(project_name), str(project_name) + "_bk_" + str(i))
                else:
                    return

        self.schema = utils_giswater.getWidgetText(self.dlg_readsql_create_project, 'project_name')
        project_type = utils_giswater.getWidgetText(self.dlg_readsql_create_project, 'cmb_create_project_type')

        # Get value from combo locale
        self.locale = utils_giswater.getWidgetText(self.dlg_readsql_create_project, self.dlg_readsql_create_project.cmb_locale)

        self.set_wait_cursor()
        if self.rdb_import_data.isChecked():
            self.file_inp = utils_giswater.getWidgetText(self.dlg_readsql_create_project,self.dlg_readsql_create_project.data_file)
            if self.file_inp is 'null':
                self.set_arrow_cursor()
                msg = "The 'Path' field is required for Import INP data."
                result = self.controller.show_info_box(msg, "Info")
                return
            self.load_base(project_type=project_type)
            self.update_30to31(new_project=True, project_type=project_type)
            self.load_views(project_type=project_type)
            self.load_trg(project_type=project_type)
            self.update_31to39(new_project=True, project_type=project_type)
            self.api(project_type=project_type)
            self.execute_last_process(new_project=True, schema_name=project_name, schema_type=schema_type)
            self.execute_import_data()

        elif self.rdb_sample.isChecked():
            if utils_giswater.getWidgetText(self.dlg_readsql_create_project, self.dlg_readsql_create_project.cmb_locale) != 'EN':
                msg = "This functionality is only allowed with the locality 'EN'. Do you want change it and continue?"
                result = self.controller.ask_question(msg, "Info Message")
                if result:
                    utils_giswater.setWidgetText(self.dlg_readsql_create_project, self.cmb_locale, 'EN')
                else:
                    self.set_arrow_cursor()
                    return

            self.load_base(project_type=project_type)
            self.update_30to31(new_project=True, project_type=project_type)
            self.load_views(project_type=project_type)
            self.load_trg(project_type=project_type)
            self.update_31to39(new_project=True, project_type=project_type)
            self.api(project_type=project_type)
            self.execute_last_process(new_project=True, schema_name=project_name, schema_type=schema_type)
            self.load_sample_data(project_type=project_type)

        elif self.rdb_sample_dev.isChecked():
            if utils_giswater.getWidgetText(self.dlg_readsql_create_project, self.dlg_readsql_create_project.cmb_locale) != 'EN':
                msg = "This functionality is only allowed with the locality 'EN'. Do you want change it and continue?"
                result = self.controller.ask_question(msg, "Info Message")
                if result:
                    utils_giswater.setWidgetText(self.dlg_readsql_create_project, self.cmb_locale, 'EN')
                else:
                    self.set_arrow_cursor()
                    return

            self.load_base(project_type=project_type)
            self.update_30to31(new_project=True, project_type=project_type)
            self.load_views(project_type=project_type)
            self.load_trg(project_type=project_type)
            self.update_31to39(new_project=True, project_type=project_type)
            self.api(project_type=project_type)
            self.execute_last_process(new_project=True, schema_name=project_name, schema_type=schema_type)
            self.load_sample_data(project_type=project_type)
            self.load_dev_data(project_type=project_type)

        elif self.rdb_data.isChecked():
            self.load_base(project_type=project_type)
            self.update_30to31(new_project=True, project_type=project_type)
            self.load_views(project_type=project_type)
            self.load_trg(project_type=project_type)
            self.update_31to39(new_project=True, project_type=project_type)
            self.api(project_type=project_type)
            self.execute_last_process(new_project=True, schema_name=project_name, schema_type=schema_type)

        self.set_arrow_cursor()

        # Show message if process executed correctly
        if self.error_count == 0:
            self.controller.dao.commit()
            msg = "The project has been created correctly."
            self.controller.show_info_box(msg, "Info")
            self.close_dialog(self.dlg_readsql_create_project)
        else:
            self.controller.dao.rollback()
            msg = "Some errors has occurred. Process has not been executed."
            self.controller.show_info_box(msg, "Info")

        # Reset count error variable to 0
        self.error_count = 0

        # Referesh data main dialog
        self.event_change_connection()
        self.set_info_project()


    def rename_project_data_schema(self, schema, create_project=None):

        if create_project is None or create_project is False:
            close_dlg_rename = True
            self.schema = utils_giswater.getWidgetText(self.dlg_readsql_rename,self.dlg_readsql_rename.schema_rename)
            if str(self.schema) == str(schema):
                msg = "Please, select a diferent project name than current."
                self.controller.show_info_box(msg, "Info")
                return
        else:
            close_dlg_rename = False
            self.schema = str(create_project)

        self.set_wait_cursor()
        sql = 'ALTER SCHEMA ' + str(schema) + ' RENAME TO ' + str(self.schema) + ''
        status = self.controller.execute_sql(sql, commit=False)
        if status:
            self.reload_trg(project_type=self.project_type_selected)
            self.reload_trg(project_type='api')
            self.reload_fct_ftrg(project_type=self.project_type_selected)
            self.reload_fct_ftrg(project_type='api')
            sql = ('SELECT ' + str(self.schema) + '.gw_fct_admin_schema_rename_fixviews($${"data":{"currentSchemaName":"' + self.schema + '","oldSchemaName":"' + str(schema) + '"}}$$)::text')
            status = self.controller.execute_sql(sql, commit=False)
            self.execute_last_process(schema_name=self.schema, locale=True)
        self.set_arrow_cursor()

        # Show message if precess execute correctly
        if self.error_count == 0:
            self.controller.dao.commit()
            self.event_change_connection()
            utils_giswater.setWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name, str(self.schema))
            if close_dlg_rename:
                self.close_dialog(self.dlg_readsql_rename)
            msg = "Rename project has been executed correctly."
            self.controller.show_info_box(msg, "Info")

        else:
            self.controller.dao.rollback()
            msg = "Some error has occurred while the rename process was running."
            self.controller.show_info_box(msg, "Info")

        # Reset count error variable to 0
        self.error_count = 0


    def update_api(self):

        self.set_wait_cursor()
        self.api(False)
        self.set_arrow_cursor()

        # Show message if precess execute correctly
        if self.error_count == 0:
            self.controller.dao.commit()
            msg = "Api has been updated correctly."
            self.controller.show_info_box(msg, "Info")

        else:
            self.controller.dao.rollback()
            msg = "Some error has occurred while the api updated process was running."
            self.controller.show_info_box(msg, "Info")

        # Reset count error variable to 0
        self.error_count = 0


    def implement_api(self):

        self.set_wait_cursor()
        self.api(True)
        self.set_arrow_cursor()


    def load_custom_sql_files(self, dialog, widget):

        folder_path = utils_giswater.getWidgetText(dialog, widget)
        self.set_wait_cursor()
        self.load_sql(folder_path)
        self.set_arrow_cursor()

        # Show message if precess execute correctly
        if self.error_count == 0:
            self.controller.dao.commit()
            msg = "The process has been executed correctly."
            self.controller.show_info_box(msg, "Info")

        else:
            self.controller.dao.rollback()
            msg = "Some error has occurred while the process was running."
            self.controller.show_info_box(msg, "Info")

        # Reset count error variable to 0
        self.error_count = 0


    #TODO:Rename this function => Update all versions from changelog file.
    def update(self, project_type):

        msg = "Are you sure to update the project schema to lastest version?"
        result = self.controller.ask_question(msg, "Info")
        if result:
            self.set_wait_cursor()
            self.load_updates(project_type, update_changelog=True)
            self.set_info_project()
            self.set_arrow_cursor()
        else:
            return

        # Show message if precess execute correctly
        if self.error_count == 0:
            self.controller.dao.commit()
            msg = "The update has been executed correctly."
            self.controller.show_info_box(msg, "Info")

            # Close dialog when process has been execute correctly
            self.close_dialog(self.dlg_readsql_show_info)
        else:
            self.controller.dao.rollback()
            msg = "Some error has occurred while the update process was running."
            self.controller.show_info_box(msg, "Info")

        # Reset count error variable to 0
        self.error_count = 0


    """ Checkbox calling functions """


    def load_updates(self, project_type, update_changelog=False):

        # Get current schema selected
        schema_name = utils_giswater.getWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name)

        self.set_wait_cursor()
        self.load_fct_ftrg(project_type=project_type)
        self.update_30to31(project_type=project_type)
        self.update_31to39(project_type=project_type)
        self.api(project_type=project_type)
        self.execute_last_process(schema_name=schema_name, locale=True)
        self.set_arrow_cursor()

        if update_changelog is False:
            # Show message if precess execute correctly
            if self.error_count == 0:
                self.controller.dao.commit()
                msg = "The update has been executed correctly."
                self.controller.show_info_box(msg, "Info")
            else:
                self.controller.dao.rollback()
                msg = "Some error has occurred while the update process was running."
                self.controller.show_info_box(msg, "Info")

            # Reset count error variable to 0
            self.error_count = 0


    def reload_tablect(self, project_type=False):
        self.load_tablect(project_type=project_type)


    def reload_fct_ftrg(self, project_type=False):
        self.load_fct_ftrg(project_type=project_type)


    def reload_trg(self, project_type=False):
        self.load_trg(project_type)


    """ Create new connection when change combo connections """


    def event_change_connection(self):

        connection_name = str(utils_giswater.getWidgetText(self.dlg_readsql, self.cmb_connection))

        credentials = {'db': None, 'host': None, 'port': None, 'user': None, 'password': None}

        settings = QSettings()
        settings.beginGroup("PostgreSQL/connections/" + connection_name)

        credentials['host'] = settings.value('host')
        credentials['port'] = settings.value('port')
        credentials['db'] = settings.value('database')
        credentials['user'] = settings.value('username')
        credentials['password'] = settings.value('password')

        settings.endGroup()

        self.logged = self.controller.connect_to_database(credentials['host'], credentials['port'],
                                               credentials['db'], credentials['user'],
                                               credentials['password'])

        if not self.logged:
            self.controller.show_message("Connection Failed. Please, check connection parameters.", 1)
            utils_giswater.dis_enable_dialog(self.dlg_readsql, False, ignore_widgets='cmb_connection')
            self.dlg_readsql.lbl_status.setPixmap(self.status_ko)
            utils_giswater.setWidgetText(self.dlg_readsql, self.dlg_readsql.lbl_status_text,
                                         'Connection Failed. Please, check connection parameters')
            utils_giswater.setWidgetText(self.dlg_readsql, self.dlg_readsql.lbl_schema_name, '')
        else:
            utils_giswater.dis_enable_dialog(self.dlg_readsql, True)
            self.dlg_readsql.lbl_status.setPixmap(self.status_ok)
            utils_giswater.setWidgetText(self.dlg_readsql, self.dlg_readsql.lbl_status_text, '')

        self.populate_data_schema_name(self.cmb_project_type)
        self.set_last_connection(connection_name)

        if self.logged:
            self.username = self.get_user_connection(self.get_last_connection())
            role_admin = self.controller.check_role_user("role_admin", self.username)
            if not role_admin and self.username != 'postgres' and self.username != 'gisadmin':
                self.controller.show_message("Connection Failed. You dont have permisions for this connection.", 1)
                utils_giswater.dis_enable_dialog(self.dlg_readsql, False, 'cmb_connection')
                self.dlg_readsql.lbl_status.setPixmap(self.status_ko)
                utils_giswater.setWidgetText(self.dlg_readsql, self.dlg_readsql.lbl_status_text,
                                             "You don't have permissions to administrate project schemas on this connection")
                utils_giswater.setWidgetText(self.dlg_readsql, self.dlg_readsql.lbl_schema_name, '')


    def set_last_connection(self, connection_name):

        settings = QSettings()
        settings.beginGroup("PostgreSQL/connections")
        settings.setValue('selected', connection_name)
        settings.endGroup()


    def get_last_connection(self):

        settings = QSettings()
        settings.beginGroup("PostgreSQL/connections")
        connection_name = settings.value('selected')
        settings.endGroup()
        return connection_name


    def get_user_connection(self, connection_name):

        connection_username = None
        settings = QSettings()
        if connection_name:
            settings.beginGroup("PostgreSQL/connections/" + connection_name)
            connection_username = settings.value('username')
            settings.endGroup()

        return connection_username


    """ Other functions """


    def show_info(self):

        # Create dialog
        self.dlg_readsql_show_info = ReadsqlShowInfo()
        self.load_settings(self.dlg_readsql_show_info)

        info_updates = self.dlg_readsql_show_info.findChild(QTextEdit, 'info_updates')
        self.message_update = ''

        self.read_info_version()

        info_updates.setText(self.message_update)

        if str(self.message_update) == '':
            self.dlg_readsql_show_info.btn_update.setEnabled(False)

        #Set listeners
        self.dlg_readsql_show_info.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_readsql_show_info))
        self.dlg_readsql_show_info.btn_update.clicked.connect(partial(self.update, self.project_type_selected))

        # Open dialog
        self.dlg_readsql_show_info.show()


    def read_info_version(self):

        status = True
        if not os.path.exists(self.folderUpdates):
            self.controller.show_message("The updates folder was not found in sql folder.", 1)
            return
        folders = os.listdir(self.folderUpdates + '')
        for folder in folders:
            sub_folders = os.listdir(self.folderUpdates + folder)
            for sub_folder in sub_folders:
                if str(sub_folder) > str(self.project_data_schema_version).replace('.',''):
                    if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder, '') is True:
                        status = self.readFiles(
                            os.listdir(self.folderUpdates + folder + os.sep + sub_folder + ''), self.folderUpdates + folder + os.sep + sub_folder + '')
                        if status is False:
                            return False
                else:
                    return False

        return True


    def close_dialog(self, dlg=None):

        """ Close dialog """

        if dlg is None or type(dlg) is bool:
            dlg = self.dlg
        try:
            self.save_settings(dlg)
            dlg.close()
            map_tool = self.canvas.mapTool()
            # If selected map tool is from the plugin, set 'Pan' as current one
            if map_tool.toolName() == '':
                self.iface.actionPan().trigger()
        except AttributeError:
            pass

        self.schema = None


    def update_locale(self):

        self.folderLocale = self.sql_dir + os.sep + 'i18n' + os.sep + utils_giswater.getWidgetText(self.dlg_readsql, self.cmb_locale) + os.sep


    def enable_datafile(self):

        if self.rdb_import_data.isChecked() is True:
            self.data_file.setReadOnly(True)
            self.btn_push_file.setEnabled(True)
        else:
            self.data_file.setReadOnly(True)
            self.btn_push_file.setEnabled(False)


    def populate_data_schema_name(self, widget):

        # Get filter
        filter = str(utils_giswater.getWidgetText(self.dlg_readsql, widget))
        result_list = []

        # Populate Project data schema Name
        sql = "SELECT schema_name FROM information_schema.schemata"
        rows = self.controller.get_rows(sql)
        if rows is None:
            return
        for row in rows:
            sql = ("SELECT EXISTS(SELECT * FROM information_schema.tables WHERE table_schema = '" + str(row[0]) + "' "
                   " AND table_name = 'version')")
            exists = self.controller.get_row(sql)
            if str(exists[0]) == 'True':
                sql = ("SELECT wsoftware FROM " + str(row[0]) + ".version")
                result = self.controller.get_row(sql)
                if result is not None and result[0] == filter.upper():
                    elem = [row[0], row[0]]
                    result_list.append(elem)

        utils_giswater.set_item_data(self.dlg_readsql.project_schema_name, result_list, 1)


    def filter_srid_changed(self):

        filter_value = utils_giswater.getWidgetText(self.dlg_readsql_create_project, self.filter_srid)
        if filter_value is 'null':
            filter_value = ''
        sql = "SELECT substr(srtext, 1, 6) as " + '"Type"' + ", srid as "+'"SRID"' + ", substr(split_part(srtext, ',', 1), 9) as "
        sql += '"Description"' + " FROM public.spatial_ref_sys WHERE CAST(srid AS TEXT) LIKE '" + str(filter_value)
        sql += "%' ORDER BY substr(srtext, 1, 6), srid"

        # Populate Table
        self.fill_table_by_query(self.tbl_srid, sql)


    def set_info_project(self):

        schema_name = utils_giswater.getWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name)

        if schema_name is None:

            schema_name = 'Nothing to select'
            self.project_data_schema_version = "Version not found"

        else:
            sql = "SELECT value FROM " + schema_name + ".config_param_system WHERE parameter = 'schema_manager'"
            row = self.controller.get_row(sql)
            if row is None:
                result = ['{"title":"","author":"","date":""}']
            else:
                result = [json.loads(row[0])]

            sql = "SELECT giswater, date::date FROM " + schema_name + ".version order by id desc LIMIT 1"
            row = self.controller.get_row(sql)
            if row is not None:
                self.project_data_schema_version = str(row[0])

        # Set label schema name
        self.lbl_schema_name.setText(str(schema_name))

        # Get parameters
        sql = "SELECT version();"
        result = self.controller.get_row(sql)
        if result:
            database_version = result[0].split(',')
        else:
            database_version = ['']

        sql = "SELECT PostGIS_FULL_VERSION();"
        result = self.controller.get_row(sql)
        if result:
            postgis_version = result[0].split('GEOS=')
        else:
            postgis_version = ['']
        if schema_name == 'Nothing to select' or schema_name == '':
            result = None
        else:
            sql = ("SELECT value FROM " + schema_name + ".config_param_system WHERE parameter = 'schema_manager'")
            result = self.controller.get_row(sql)
        if result is None:
            result = ['{"title":"","author":"","date":""}']
        result = [json.loads(result[0])]

        self.software_version_info.setText('Database version: ' + str(database_version[0]) + '\n' +
                                           '' + str(postgis_version[0]) + ' \n \n' +
                                           'Name: ' + schema_name + '\n' +
                                           'Version: ' + self.project_data_schema_version + ' \n' +
                                           'Title: ' + str(result[0]['title']) + '\n' +
                                           'Author: ' + str(result[0]['author']) + '\n' +
                                           'Date: ' + str(result[0]['date']))

        # Update windowTitle
        self.dlg_readsql.setWindowTitle('Giswater (' + str(
            utils_giswater.getWidgetText(self.dlg_readsql, self.dlg_readsql.cmb_connection)) + ' - ' + str(
            self.plugin_version) + ')')


    def process_folder(self, folderPath, filePattern):

        status = True
        try:
            self.controller.log_info(str(os.listdir(folderPath + filePattern)))
            return status
        except Exception as e:
            return False
            self.controller.log_info(str(e))

        return status


    def schema_file_to_db(self):

        if self.chk_schema_funcion.isChecked():
            self.set_wait_cursor()
            self.reload_fct_ftrg(self.project_type_selected)
            self.set_arrow_cursor()


        # Show message if precess execute correctly
        if self.error_count == 0:
            self.controller.dao.commit()
            msg = "The reload has been executed correctly."
            self.controller.show_info_box(msg, "Info")

        else:
            self.controller.dao.rollback()
            msg = "Some error has occurred while the reload process was running."
            self.controller.show_info_box(msg, "Info")

        # Reset count error variable to 0
        self.error_count = 0


    def api_file_to_db(self):

        if self.chk_api_funcion.isChecked():
            self.set_wait_cursor()
            self.reload_fct_ftrg('api')
            self.set_arrow_cursor()

        # Show message if precess execute correctly
        if self.error_count == 0:
            self.controller.dao.commit()
            msg = "The reload has been executed correctly."
            self.controller.show_info_box(msg, "Info")

        else:
            self.controller.dao.rollback()
            msg = "Some error has occurred while the reload process was running."
            self.controller.show_info_box(msg, "Info")

        # Reset count error variable to 0
        self.error_count = 0


    def open_create_project(self):

        # Create dialog
        self.dlg_readsql_create_project = ReadsqlCreateProject()
        self.load_settings(self.dlg_readsql_create_project)

        # Find Widgets in form
        self.project_name = self.dlg_readsql_create_project.findChild(QLineEdit, 'project_name')
        self.project_title = self.dlg_readsql_create_project.findChild(QLineEdit, 'project_title')
        self.project_author = self.dlg_readsql_create_project.findChild(QLineEdit, 'author')
        self.project_date = self.dlg_readsql_create_project.findChild(QLineEdit, 'date')

        self.rdb_sample = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_sample')
        self.rdb_sample_dev = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_sample_dev')
        self.rdb_data = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_data')
        self.rdb_import_data = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_import_data')

        self.data_file = self.dlg_readsql_create_project.findChild(QLineEdit, 'data_file')
        #TODO:: do and call listener for buton + table -> temp_csv2pg
        self.btn_push_file = self.dlg_readsql_create_project.findChild(QPushButton, 'btn_push_file')

        if self.dev_user != 'TRUE':
            self.rdb_sample_dev.setEnabled(False)

        self.filter_srid = self.dlg_readsql_create_project.findChild(QLineEdit, 'srid_id')
        utils_giswater.setWidgetText(self.dlg_readsql_create_project, 'srid_id', str(self.filter_srid_value))
        self.tbl_srid = self.dlg_readsql_create_project.findChild(QTableView, 'tbl_srid')
        self.tbl_srid.setSelectionBehavior(QAbstractItemView.SelectRows)
        sql = "SELECT substr(srtext, 1, 6) as " + '"Type"' + ", srid as "+'"SRID"' + ", substr(split_part(srtext, ',', 1), 9) as "+'"Description"'+" FROM public.spatial_ref_sys WHERE CAST(srid AS TEXT) LIKE '" + str(self.filter_srid_value)+"%' ORDER BY substr(srtext, 1, 6), srid"

        # Populate Table
        self.fill_table_by_query(self.tbl_srid, sql)

        self.cmb_create_project_type = self.dlg_readsql_create_project.findChild(QComboBox, 'cmb_create_project_type')
        for type in self.project_types:
            self.cmb_create_project_type.addItem(str(type))
        utils_giswater.setWidgetText(self.dlg_readsql_create_project, self.cmb_create_project_type, utils_giswater.getWidgetText(self.dlg_readsql, self.dlg_readsql.cmb_project_type))
        self.change_project_type(self.cmb_create_project_type)

        # Enable_disable data file widgets
        self.enable_datafile()

        # Get combo locale
        self.cmb_locale = self.dlg_readsql_create_project.findChild(QComboBox, 'cmb_locale')

        # Set listeners
        self.dlg_readsql_create_project.btn_accept.clicked.connect(partial(self.create_project_data_schema))
        self.dlg_readsql_create_project.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_readsql_create_project))
        self.dlg_readsql_create_project.btn_push_file.clicked.connect(partial(self.select_file_inp))
        self.cmb_create_project_type.currentIndexChanged.connect(partial(self.change_project_type, self.cmb_create_project_type))
        self.cmb_locale.currentIndexChanged.connect(partial(self.update_locale))
        self.rdb_import_data.toggled.connect(partial(self.enable_datafile))
        self.filter_srid.textChanged.connect(partial(self.filter_srid_changed))

        # Populate combo with all locales
        locales = os.listdir(self.sql_dir + os.sep + 'i18n' + os.sep)
        for locale in locales:
            self.cmb_locale.addItem(locale)
            if locale == 'EN':
                utils_giswater.setWidgetText(self.dlg_readsql_create_project, self.cmb_locale, 'EN')


        # Get connection ddb name
        connection_name = str(utils_giswater.getWidgetText(self.dlg_readsql, self.cmb_connection))

        # Open dialog
        self.dlg_readsql_create_project.setWindowTitle('Create Project - ' + str(connection_name))
        self.dlg_readsql_create_project.show()


    def open_rename(self):

        # Open rename if schema is updated
        if str(self.version_metadata) != str(self.project_data_schema_version):
            msg = "The schema version has to be updated to make rename ."
            self.controller.show_info_box(msg, "Info")
            return

        # Create dialog
        self.dlg_readsql_rename = ReadsqlRename()
        self.load_settings(self.dlg_readsql_rename)

        schema = utils_giswater.getWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name)

        # Set listeners
        self.dlg_readsql_rename.btn_accept.clicked.connect(partial(self.rename_project_data_schema, schema))
        self.dlg_readsql_rename.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_readsql_rename))

        # Open dialog
        self.dlg_readsql_rename.setWindowTitle('Rename project - ' + schema)
        self.dlg_readsql_rename.show()


    def executeFiles(self, filedir, i18n=False, no_ct=False):

        if not os.path.exists(filedir):
            self.controller.log_info("Folder not found", parameter=filedir)
            return True

        self.controller.log_info("Processing folder", parameter=filedir)
        filelist = sorted(os.listdir(filedir))

        if self.schema is None:
            if self.schema_name is None:
                schema_name = utils_giswater.getWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name)
                schema_name = schema_name.replace('"', '')
            else:
                schema_name = self.schema_name.replace('"','')
        else:
            schema_name = self.schema.replace('"', '')
        filter_srid_value = str(self.filter_srid_value).replace('"', '')
        if i18n:
            for file in filelist:
                if "utils.sql" in file :
                    self.controller.log_info(str(filedir + os.sep + 'utils.sql'))
                    self.read_execute_file(filedir, os.sep + 'utils.sql', schema_name, filter_srid_value)
                elif str(self.project_type_selected) + ".sql" in file:
                    self.controller.log_info(str(filedir + os.sep + str(self.project_type_selected) + '.sql'))
                    self.read_execute_file(filedir, os.sep + str(self.project_type_selected) + '.sql', schema_name,
                                           filter_srid_value)
        else:
            for file in filelist:
                if ".sql" in file:
                    if (no_ct is True and "tablect.sql" not in file) or no_ct is False:
                        self.controller.log_info(str(filedir + os.sep + file))
                        self.read_execute_file(filedir, file, schema_name, filter_srid_value)

        return True


    def read_execute_file(self, filedir, file, schema_name, filter_srid_value):

        try:
            f = open(filedir + os.sep + file, 'r')
            if f:
                f_to_read = str(
                    f.read().replace("SCHEMA_NAME", schema_name).replace("SRID_VALUE", filter_srid_value)).decode(
                    str('utf-8-sig'))

                if self.dev_commit == 'TRUE':
                    status = self.controller.execute_sql(str(f_to_read))
                else:
                    status = self.controller.execute_sql(str(f_to_read), commit=False)
                if status is False:
                    self.error_count = self.error_count + 1
                    self.controller.log_info(str("Error to execute"))
                    self.controller.log_info(str('Message: ' + str(self.controller.last_error)))
                    if self.dev_commit == 'TRUE':
                        self.controller.dao.rollback()
                    return False

        except Exception as e:
            self.error_count = self.error_count + 1
            self.controller.log_info(str("Error to execute"))
            self.controller.log_info(str('Message: ' + str(self.controller.last_error)))
            if self.dev_commit == 'TRUE':
                self.controller.dao.rollback()
            return False


    def readFiles(self, filelist, filedir):

        if "changelog.txt" in filelist:
            try:
                f = open(filedir + os.sep + 'changelog.txt', 'r')
                if f:
                    f_to_read = str(f.read()).decode(str('utf-8-sig'))
                    f_to_read = f_to_read + '\n \n'
                    self.message_update = self.message_update + '\n' + str(f_to_read)
                else:
                    return False
            except Exception as e:
                return False
        return True


    def delete_schema(self):

        project_name = utils_giswater.getWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name)
        if project_name is None:
            msg = "You cant delete a None project. Please, select correct one."
            self.controller.show_info_box(msg, "Info")
            return
        msg = "Are you sure you want delete schema '" + str(project_name) + "' ?"
        result = self.controller.ask_question(msg, "Info")
        if result:
            sql = ('DROP SCHEMA ' + str(project_name) + ' CASCADE;')
            status = self.controller.execute_sql(sql)
            if status:
                msg = "The Schema was deleted correctly."
                self.controller.show_info_box(msg, "Info")
        self.populate_data_schema_name(self.cmb_project_type)
        self.set_info_project()


    """ Take current project type changed """

    def change_project_type(self, widget):
        self.project_type_selected = utils_giswater.getWidgetText(self.dlg_readsql, widget)
        self.folderSoftware = self.sql_dir + os.sep + self.project_type_selected + os.sep


    def insert_inp_into_db(self, folder_path=None):
        _file = open(folder_path, "r+")
        full_file = _file.readlines()
        sql = ""
        progress = 0

        for row in full_file:
            progress += 1

            if str(row[0]) != ';':
                list_aux = row.split("\t")
                dirty_list = []
                for x in range(0, len(list_aux)):
                    aux = list_aux[x].split(" ")
                    for i in range(len(aux)):
                        dirty_list.append(aux[i])
            else:
                dirty_list = []
                aux = row
                dirty_list.append(aux)
            for x in range(len(dirty_list) - 1, -1, -1):
                if dirty_list[x] == '' or "**" in dirty_list[x] or "--" in dirty_list[x]:
                    dirty_list.pop(x)

            sp_n = dirty_list

            if len(sp_n) > 0:
                sql += "INSERT INTO " + self.schema + ".temp_csv2pg (csv2pgcat_id, "
                values = "VALUES(12, "
                for x in range(0, len(sp_n)):
                    if "''" not in sp_n[x]:
                        sql += "csv" + str(x + 1) + ", "
                        value = "'" + sp_n[x].strip().replace("\n", "") + "', "
                        values += value.replace("''", "null")
                    else:
                        sql += "csv" + str(x + 1) + ", "
                        values = "VALUES(null, "
                sql = sql[:-2] + ") "
                values = values[:-2] + ");\n"
                sql += values

        if progress % 500 == 0:
            self.controller.execute_sql(sql, log_sql=False, commit=False)
            sql = ""
        if sql != "":
            self.controller.execute_sql(sql, log_sql=False, commit=False)
        _file.close()
        del _file


    def select_file_inp(self):
        """ Select INP file """

        file_inp = utils_giswater.getWidgetText(self.dlg_readsql_create_project, 'data_file')
        # Set default value if necessary
        if file_inp is None or file_inp == '':
            file_inp = self.plugin_dir
        # Get directory of that file
        folder_path = os.path.dirname(file_inp)
        if not os.path.exists(folder_path):
            folder_path = os.path.dirname(__file__)
        os.chdir(folder_path)
        message = self.controller.tr("Select INP file")
        file_inp = QFileDialog.getOpenFileName(None, message, "", '*.inp')
        self.dlg_readsql_create_project.data_file.setText(file_inp)

    """ Info basic """
    def info_show_info(self):
        """ Button 36: Info show info, open giswater and visit web page """

        # Create form
        self.dlg_info = InfoShowInfo()
        self.load_settings(self.dlg_info)

        # Get Plugin, Giswater, PostgreSQL and Postgis version
        postgresql_version = self.controller.get_postgresql_version()
        postgis_version = self.controller.get_postgis_version()
        plugin_version = self.get_plugin_version()
        (giswater_file_path, giswater_build_version) = self.get_giswater_jar()  #@UnusedVariable
        project_version = self.controller.get_project_version()

        message = ("Plugin version:     " + str(plugin_version) + "\n"
                   "Project version:    " + str(project_version) + "\n"
                   "Giswater version:   " + str(giswater_build_version) + "\n"
                   "PostgreSQL version: " + str(postgresql_version) + "\n"
                   "Postgis version:    " + str(postgis_version))
        utils_giswater.setWidgetText(self.dlg_info, self.dlg_info.txt_info, message)

        # Set signals
        self.dlg_info.btn_open_giswater.clicked.connect(self.open_giswater)
        self.dlg_info.btn_open_web.clicked.connect(partial(self.open_web_browser, self.dlg_info, None))
        self.dlg_info.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_info))

        # Open dialog
        self.open_dialog(self.dlg_info, maximize_button=False)


    def open_giswater(self):
        """ Open giswater.jar with last opened .gsw file """

        if 'nt' in sys.builtin_module_names:
            self.execute_giswater("ed_giswater_jar")
        else:
            self.controller.show_info("Function not supported in this Operating System")

