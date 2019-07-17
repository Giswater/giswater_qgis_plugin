"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis, QgsVectorLayer
except ImportError:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT < 29900:
    from qgis.PyQt.QtGui import QStringListModel
else:
    from qgis.PyQt.QtCore import QStringListModel

from qgis.PyQt.QtWidgets import QRadioButton, QPushButton, QTableView, QAbstractItemView, QTextEdit, QFileDialog
from qgis.PyQt.QtWidgets import QLineEdit, QWidget, QComboBox, QLabel, QCheckBox, QCompleter, QScrollArea, QSpinBox
from qgis.PyQt.QtWidgets import QAbstractButton, QHeaderView, QListView, QFrame, QScrollBar, QDoubleSpinBox, QPlainTextEdit
from qgis.PyQt.QtGui import QPixmap
from qgis.PyQt.QtCore import QSettings, Qt
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.core import QgsTask, QgsApplication
from qgis.gui import QgsDateTimeEdit

import os
import sys
import re
import json
import subprocess
from time import sleep
import random
from functools import partial
from collections import OrderedDict
import xml.etree.cElementTree as ET

import utils_giswater

from giswater.actions.api_parent import ApiParent
from giswater.ui_manager import Readsql, InfoShowInfo, ReadsqlCreateProject, ReadsqlRename, ReadsqlShowInfo, ReadsqlCreateGisProject, ApiImportInp, ManageFields
from giswater.actions.create_gis_project import CreateGisProject



class UpdateSQL(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'om_ws' """

        # Initialize instance attributes
        ApiParent.__init__(self, iface, settings, controller, plugin_dir)
        self.iface = iface
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir
        self.schema_name = self.controller.schema_name
        self.project_type = controller.get_project_type()


    def init_sql(self, connection_status=False):
        """ Button 100: Execute SQL. Info show info """

        # Check if connection is still False
        connection_status, not_version = self.controller.set_database_connection()

        # Set logger file
        self.controller.set_logger()

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

        # Get plugin version from metadata.txt file
        self.plugin_version = self.get_plugin_version()
        self.version_metadata = self.get_plugin_version()
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

        # TODO:: remove this harcorded
        utils_giswater.setWidgetText(self.dlg_readsql, 'tpath', 'C:/Users/Usuari/Desktop/test.ui')

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
        print(str(list_connections))
        if str(list_connections) != '[]':
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
        self.dlg_readsql.project_schema_name.currentIndexChanged.connect(partial(self.update_manage_ui, parent=False))
        self.cmb_project_type.currentIndexChanged.connect(partial(self.populate_data_schema_name, self.cmb_project_type))
        self.cmb_project_type.currentIndexChanged.connect(partial(self.change_project_type, self.cmb_project_type))
        self.cmb_project_type.currentIndexChanged.connect(partial(self.set_info_project))
        self.dlg_readsql.btn_custom_select_file.clicked.connect(partial(self.get_folder_dialog, self.dlg_readsql, "custom_path_folder"))
        self.cmb_connection.currentIndexChanged.connect(partial(self.event_change_connection))
        self.cmb_connection.currentIndexChanged.connect(partial(self.set_info_project))
        self.dlg_readsql.btn_schema_rename.clicked.connect(partial(self.open_rename))
        self.dlg_readsql.btn_delete.clicked.connect(partial(self.delete_schema))
        self.dlg_readsql.btn_constrains.clicked.connect(partial(self.btn_constrains_changed, self.btn_constrains, True))
        self.dlg_readsql.btn_create_qgis_template.clicked.connect(partial(self.create_qgis_template))
        self.dlg_readsql.btn_gis_create.clicked.connect(partial(self.open_form_create_gis_project))
        self.dlg_readsql.btn_path.clicked.connect(partial(self.select_file_ui))
        self.dlg_readsql.btn_import_ui.clicked.connect(partial(self.execute_import_ui))
        self.dlg_readsql.btn_export_ui.clicked.connect(partial(self.execute_export_ui))

        self.dlg_readsql.btn_create_field.clicked.connect(partial(self.open_manage_field, 'Create'))
        self.dlg_readsql.btn_update_field.clicked.connect(partial(self.open_manage_field, 'Update'))
        self.dlg_readsql.btn_delete_field.clicked.connect(partial(self.open_manage_field, 'Delete'))
        self.dlg_readsql.btn_create_view.clicked.connect(partial(self.create_child_view))

        # Set last connection for default
        utils_giswater.set_combo_itemData(self.cmb_connection, str(self.last_connection), 1)

        # Open dialog
        connection = utils_giswater.getWidgetText(self.dlg_readsql, self.dlg_readsql.cmb_connection)
        window_title = 'Giswater (' + str(connection) + ' - ' + str(self.plugin_version) + ')'
        self.dlg_readsql.setWindowTitle(window_title)

        self.dlg_readsql.show()

        super_users = self.settings.value('system_variables/super_users')
        self.super_users = []
        for super_user in super_users:
            print(str(super_user))
            self.super_users.append(str(super_user))

        if connection_status is False:
            self.controller.show_message("Connection Failed. Please, check connection parameters", 1)
            utils_giswater.dis_enable_dialog(self.dlg_readsql, False, 'cmb_connection')
            self.dlg_readsql.lbl_status.setPixmap(self.status_ko)
            utils_giswater.setWidgetText(self.dlg_readsql, self.dlg_readsql.lbl_status_text, 'Connection Failed. Please, check connection parameters')
            utils_giswater.setWidgetText(self.dlg_readsql, self.dlg_readsql.lbl_schema_name, '')
            return

        else:
            role_admin = self.controller.check_role_user("role_admin", self.username)
            if not role_admin and self.username not in self.super_users:
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
        self.update_manage_ui(parent=False)


    def gis_create_project(self):

        # Get gis folder, gis file, project type and schema
        gis_folder = utils_giswater.getWidgetText(self.dlg_create_gis_project, self.dlg_create_gis_project.txt_gis_folder)
        if gis_folder is None or gis_folder == 'null':
            self.controller.show_warning("GIS folder not set")
            return

        gis_file = utils_giswater.getWidgetText(self.dlg_create_gis_project, self.dlg_create_gis_project.txt_gis_file)
        if gis_file is None or gis_file == 'null':
            self.controller.show_warning("GIS file name not set")
            return

        project_type = utils_giswater.getWidgetText(self.dlg_readsql, self.dlg_readsql.cmb_project_type)
        schema_name = utils_giswater.getWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name)

        # Get roletype and export password
        roletype = utils_giswater.getWidgetText(self.dlg_create_gis_project, self.dlg_create_gis_project.cmb_roletype)
        export_passwd = utils_giswater.isChecked(self.dlg_create_gis_project, self.dlg_create_gis_project.chk_export_passwd)
        if export_passwd:
            msg = "Credentials will be stored in GIS project file"
            self.controller.show_info_box(msg, "Warning")

        # Generate QGIS project
        gis = CreateGisProject(self.controller, self.plugin_dir)
        gis.gis_project_database(gis_folder, gis_file, project_type, schema_name, export_passwd, roletype)
        self.close_dialog(self.dlg_create_gis_project)
        self.close_dialog(self.dlg_readsql)


    def open_form_create_gis_project(self):

        # Create GIS project dialog
        self.dlg_create_gis_project = ReadsqlCreateGisProject()
        self.load_settings(self.dlg_create_gis_project)

        # Set default values
        schema_name = utils_giswater.getWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name)
        utils_giswater.setWidgetText(self.dlg_create_gis_project, self.dlg_create_gis_project.txt_gis_file, schema_name)
        users_home = os.path.expanduser("~")
        utils_giswater.setWidgetText(self.dlg_create_gis_project, self.dlg_create_gis_project.txt_gis_folder, users_home)

        # Set listeners
        self.dlg_create_gis_project.btn_gis_folder.clicked.connect(partial(self.get_folder_dialog, self.dlg_create_gis_project, "txt_gis_folder"))
        self.dlg_create_gis_project.btn_accept.clicked.connect(partial(self.gis_create_project))
        self.dlg_create_gis_project.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_create_gis_project))

        # Open MainWindow
        self.dlg_create_gis_project.show()


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

        if str(project_type) in ('ws', 'ud'):

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
                    if status is False and self.dev_commit == 'FALSE':
                        return False
            else:
                status = self.executeFiles(self.folderLocale, True)
                if status is False and self.dev_commit == 'FALSE':
                    return False

        elif str(project_type) in ('pl', 'tm'):

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

            cmb_locale = utils_giswater.getWidgetText(self.dlg_readsql, self.cmb_locale)
            if self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'i18n' + os.sep + self.locale + os.sep, '') is False:
                if self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'i18n' + os.sep, 'EN') is False:
                    return False
                else:
                    status = self.executeFiles(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'i18n' + os.sep + 'EN', True)
                    if status is False and self.dev_commit == 'FALSE':
                        return False
            else:
                status = self.executeFiles(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'i18n' + os.sep + cmb_locale + os.sep, True)
                if status is False and self.dev_commit == 'FALSE':
                    return False

        return True


    def update_31to39(self, new_project=False, project_type=False, no_ct=False):

        if str(project_type) in ('ws', 'ud'):

            if not os.path.exists(self.folderUpdates):
                self.controller.show_message("The update folder was not found in sql folder.", 1)
                self.error_count = self.error_count + 1
                return
            folders = sorted(os.listdir(self.folderUpdates + ''))
            for folder in folders:
                sub_folders = sorted(os.listdir(self.folderUpdates + folder))
                for sub_folder in sub_folders:
                    if new_project:
                        if self.read_all_updates == 'TRUE':
                            if str(sub_folder) > '31100':
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder, os.sep + 'utils' + os.sep):
                                    status = self.load_sql(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep, no_ct=no_ct)
                                    if status is False:
                                        return False
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + project_type + os.sep, ''):
                                    status = self.load_sql(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + project_type + os.sep, no_ct=no_ct)
                                    if status is False:
                                        return False
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.project_data_language + os.sep), '') is True:
                                    status = self.executeFiles(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.project_data_language + os.sep), True)
                                    if status is False:
                                        return False
                                elif self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN'):
                                    status = self.executeFiles(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', True)
                                    if status is False:
                                        return False

                        else:
                            if str(sub_folder) > '31100' and str(sub_folder) <= str(self.version_metadata).replace('.', ''):
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder,  os.sep + 'utils' + os.sep):
                                    status = self.load_sql(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep, no_ct=no_ct)
                                    if status is False:
                                        return False
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + project_type + os.sep, ''):
                                    status = self.load_sql(self.folderUpdates + folder + os.sep + sub_folder + os.sep + project_type + os.sep, no_ct=no_ct)
                                    if status is False:
                                        return False
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.project_data_language + os.sep), ''):
                                    status = self.executeFiles(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.project_data_language + os.sep), True)
                                    if status is False:
                                        return False
                                elif self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN'):
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
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.project_data_language + os.sep),
                                        '') is True:
                                    status = self.executeFiles(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                            self.project_data_language + os.sep), True)
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
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.project_data_language + os.sep),'') is True:
                                    status = self.executeFiles(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.project_data_language + os.sep), True)
                                    if status is False:
                                        return False
                                elif self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is True:
                                    status = self.executeFiles(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', True)
                                    if status is False:
                                        return False

        else:

            if not os.path.exists(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + ''):
                return
            folders = sorted(os.listdir(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + ''))
            for folder in folders:
                sub_folders = sorted(os.listdir(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder))
                for sub_folder in sub_folders:
                    if new_project:
                        if self.read_all_updates == 'TRUE':
                            if str(sub_folder) > '31100':
                                if self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.project_data_language + os.sep), '') is True:
                                    status = self.executeFiles(self.sql_dir + os.sep + str(project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.project_data_language + os.sep), True)
                                    if status is False:
                                        return False
                                elif self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', '') is True:
                                    status = self.executeFiles(self.sql_dir + os.sep + str(project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', True)
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
                                        self.project_data_language + os.sep), '') is True:
                                    status = self.executeFiles(self.sql_dir + os.sep + str(
                                        project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.project_data_language + os.sep), True)
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
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.project_data_language + os.sep),'') is True:
                                    status = self.executeFiles(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                            self.project_data_language + os.sep), True)
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
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.project_data_language + os.sep),
                                        '') is True:
                                    status = self.executeFiles(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                            self.project_data_language + os.sep), True)
                                    if status is False:
                                        return False
                                elif self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is True:
                                    status = self.executeFiles(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', True)
                                    if status is False:
                                        return False

        return True


    def load_views(self, project_type=False):

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

        if str(project_type) == 'ws' or str(project_type) == 'ud':

            if not os.path.exists(self.folderUpdates):
                self.controller.show_message("The update folder was not found in sql folder.", 1)
                self.error_count = self.error_count + 1
                return True

            folders = sorted(os.listdir(self.folderUpdates + ''))
            for folder in folders:
                sub_folders = sorted(os.listdir(self.folderUpdates + folder))
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
                                    self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.project_data_language + os.sep),
                                    '') is True:
                                status = self.executeFiles(
                                    self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.project_data_language + os.sep), True)
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
                                    self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.project_data_language + os.sep),
                                    '') is True:
                                status = self.executeFiles(
                                    self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.project_data_language + os.sep), True)
                                if status is False:
                                    return False
                            elif self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', '') is True:
                                status = self.executeFiles(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', True)
                                if status is False:
                                    return False

        else:

            if not os.path.exists(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + ''):
                return True

            folders = sorted(os.listdir(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + ''))
            for folder in folders:
                sub_folders = sorted(os.listdir(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder))
                for sub_folder in sub_folders:
                    if new_project:
                        if str(sub_folder) <= '31100':
                            if self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder, '') is True:
                                status = self.load_sql(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + '')
                                if status is False:
                                    return False
                            if self.process_folder(
                                    self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.project_data_language + os.sep),
                                    '') is True:
                                status = self.executeFiles(self.sql_dir + os.sep + str(
                                    project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                    self.project_data_language + os.sep), True)
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
                                    self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.project_data_language + os.sep),
                                    '') is True:
                                status = self.executeFiles(self.sql_dir + os.sep + str(
                                    project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                    self.project_data_language + os.sep), True)
                                if status is False:
                                    return False
                            elif self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is True:
                                status = self.executeFiles(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN' + os.sep, True)
                                if status is False:
                                    return False

        return True


    def load_sample_data(self, project_type=False):

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
            if not status:
                return False

        return True


    def api(self, new_api=False, project_type=False):

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

        folders = sorted(os.listdir(self.folderUpdatesApi + ''))
        self.controller.log_info(str(folders))
        for folder in folders:
            sub_folders = sorted(os.listdir(self.folderUpdatesApi + folder))
            for sub_folder in sub_folders:
                if new_api:
                    if self.read_all_updates == 'TRUE':
                        if self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep, '') is True:
                            status = self.executeFiles(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep + '')
                            if status is False:
                                return False
                        if self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + project_type + os.sep, '') is True:
                            status = self.executeFiles(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + project_type + os.sep + '')
                            if status is False:
                                return False
                        if self.process_folder(
                                self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.project_data_language + os.sep),
                                '') is True:
                            status = self.executeFiles(
                                self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                    self.project_data_language + os.sep), True)
                            if status is False:
                                return False
                        elif self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is True:
                            status = self.executeFiles(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + self.project_data_language + os.sep, True)
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
                            if self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + project_type + os.sep,
                                                   '') is True:
                                status = self.executeFiles(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + project_type + os.sep + '')
                                if status is False:
                                    return False
                            if self.process_folder(
                                    self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.project_data_language + os.sep),
                                    '') is True:
                                status = self.executeFiles(
                                    self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.project_data_language + os.sep), True)
                                if status is False:
                                    return False
                            elif self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep,
                                                   'EN') is True:
                                status = self.executeFiles(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + self.project_data_language + os.sep,
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
                                    self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + project_type + os.sep,
                                    '') is True:
                                status = self.executeFiles(
                                    self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep + '')
                                if status is False:
                                    return False
                            if self.process_folder(
                                    self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.project_data_language + os.sep),
                                    '') is True:
                                status = self.executeFiles(
                                    self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.project_data_language + os.sep), True)
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
                        if str(sub_folder) > str(self.project_data_schema_version).replace('.', '') and str(sub_folder) <= str(self.version_metadata).replace('.',''):
                            if self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep,
                                                   '') is True:
                                status = self.executeFiles(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep + '')
                                if status is False:
                                    return False
                            if self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + project_type + os.sep,
                                                   '') is True:
                                status = self.executeFiles(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + project_type + os.sep + '')
                                if status is False:
                                    return False
                            if self.process_folder(
                                    self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.project_data_language + os.sep),
                                    '') is True:
                                status = self.executeFiles(
                                    self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.project_data_language + os.sep), True)
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

    def execute_import_data(self, schema_type=''):

        # Create dialog
        self.dlg_import_inp = ApiImportInp()
        self.load_settings(self.dlg_import_inp)

        self.dlg_import_inp.progressBar.setVisible(False)

        if schema_type.lower() == 'ws':
            extras = '"filterText":"Import inp epanet file"'
        elif schema_type.lower() == 'ud':
            extras = '"filterText":"Import inp swmm file"'
        else:
            self.error_count = self.error_count + 1
            return

        extras += ', "isToolbox":false'
        body = self.create_body(extras=extras)
        sql = ("SELECT " + self.schema_name + ".gw_api_gettoolbox($${" + body + "}$$)::text")
        row = self.controller.get_row(sql, log_sql=True, commit=False)
        if not row or row[0] is None:
            self.controller.show_message("No results for: " + sql, 2)
            return False
        complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]
        status = self.populate_functions_dlg(self.dlg_import_inp, complet_result[0]['body']['data'])

        # Set listeners
        self.dlg_import_inp.btn_run.clicked.connect(partial(self.execute_import_inp, accepted=True, schema_type=schema_type))
        self.dlg_import_inp.btn_close.clicked.connect(partial(self.execute_import_inp, accepted=False))

        # Open dialog
        self.dlg_import_inp.show()


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
        extras += ', "superUsers":' + str(self.super_users).replace("'",'"') + ''
        print(str(self.super_users).replace("'",'"'))
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
        status = self.controller.execute_sql(sql, log_sql=True,commit=False)
        if status is False:
            self.error_count = self.error_count + 1

        return status


    def task_started(self, task, wait_time):
        """ Dumb test function.
        to break the task raise an exception
        to return a successful result return it.
        This will be passed together with the exception (None in case of success) to the on_finished method
        """

        self.controller.log_info('Started task {}'.format(task.description()))

        wait_time = wait_time / 100
        total = 0
        iterations = 0
        for i in range(101):
            sleep(wait_time)
            task.setProgress(i)
            total += random.randint(0, 100)
            iterations += 1
            # Check if task is canceled to handle it...
            if task.isCanceled():
                self.task_stopped(task)
                return None

            # Example of Raise exception to abort task
            if random.randint(0, 1000) == 10:
                raise Exception('Bad value!')

        #return True
        self.task_completed(None, {'total': total, 'iterations': iterations, 'task': task.description()})


    def task_stopped(self, task):

        self.controller.log_info('Task "{name}" was cancelled'.format(name=task.description()))


    def task_completed(self, exception, result):
        """ Called when run is finished.
        Exception is not None if run raises an exception. Result is the return value of run
        """

        self.controller.log_info("task_completed")

        if exception is None:
            if result is None:
                msg = 'Completed with no exception and no result'
                self.controller.log_info(msg)
            else:
                self.controller.log_info('Task {name} completed\n'
                    'Total: {total} (with {iterations} '
                    'iterations)'.format(name=result['task'], total=result['total'],
                                         iterations=result['iterations']))
        else:
            self.controller.log_info("Exception: {}".format(exception))
            raise exception


    def task_example(self):

        self.controller.log_info("task_example")
        task1 = QgsTask.fromFunction('Create project', self.task_started, on_finished=self.task_completed, wait_time=20)
        self.controller.log_info("task_example2")
        QgsApplication.taskManager().addTask(task1)


    def create_project_data_schema(self):

        #Save user values
        self.controller.plugin_settings_set_value('project_title_schema', utils_giswater.getWidgetText(self.dlg_readsql_create_project, 'project_title'))
        self.controller.plugin_settings_set_value('inp_file_path',utils_giswater.getWidgetText(self.dlg_readsql_create_project, 'data_file'))

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
                        # TODO: Check this!
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
        self.locale = utils_giswater.getWidgetText(self.dlg_readsql_create_project, self.dlg_readsql_create_project.cmb_locale)

        # Initial checks
        if self.rdb_import_data.isChecked():
            self.file_inp = utils_giswater.getWidgetText(self.dlg_readsql_create_project, self.dlg_readsql_create_project.data_file)
            if self.file_inp is 'null':
                msg = "The 'Path' field is required for Import INP data."
                self.controller.show_info_box(msg, "Info")
                return

        elif self.rdb_sample.isChecked() or self.rdb_sample_dev.isChecked():
            if self.locale != 'EN' or self.filter_srid_value != '25831':
                msg = "This functionality is only allowed with the locality 'EN' and SRID 25831.\n Do you want change it and continue?"
                result = self.controller.ask_question(msg, "Info Message")
                if result:
                    self.filter_srid_value = '25831'
                    utils_giswater.setWidgetText(self.dlg_readsql_create_project,self.dlg_readsql_create_project.srid_id, '25831')
                    utils_giswater.setWidgetText(self.dlg_readsql_create_project, self.dlg_readsql_create_project.cmb_locale, 'EN')

                else:
                    return

        self.set_wait_cursor()

        # Common execution
        status = self.load_base(project_type=project_type)
        if not status and self.dev_commit == 'FALSE':
            self.manage_process_result()
            return

        status = self.update_30to31(new_project=True, project_type=project_type)
        if not status and self.dev_commit == 'FALSE':
            self.manage_process_result()
            return

        status = self.load_views(project_type=project_type)
        if not status and self.dev_commit == 'FALSE':
            self.manage_process_result()
            return

        status = self.load_trg(project_type=project_type)
        if not status and self.dev_commit == 'FALSE':
            self.manage_process_result()
            return

        status = self.update_31to39(new_project=True, project_type=project_type)
        if not status and self.dev_commit == 'FALSE':
            self.manage_process_result()
            return

        status = self.api(new_api=True, project_type=project_type)
        if not status and self.dev_commit == 'FALSE':
            self.manage_process_result()
            return

        status = self.execute_last_process(new_project=True, schema_name=project_name, schema_type=schema_type)
        if not status and self.dev_commit == 'FALSE':
            self.manage_process_result()
            return

        # Custom execution
        if self.rdb_import_data.isChecked():
            #TODO::
            self.set_arrow_cursor()
            msg = "The sql files have been correctly executed.\nNow, a form will be opened to manage the import inp."
            self.controller.show_info_box(msg, "Info")
            self.execute_import_data(schema_type=schema_type)
            return
        
        elif self.rdb_sample.isChecked():
            self.load_sample_data(project_type=project_type)

        elif self.rdb_sample_dev.isChecked():
            self.load_sample_data(project_type=project_type)
            self.load_dev_data(project_type=project_type)

        elif self.rdb_data.isChecked():
            pass

        self.manage_process_result()


    def manage_process_result(self):

        self.set_arrow_cursor()

        status = (self.error_count == 0)
        self.manage_result_message(status, parameter="Create project")
        if status:
            self.controller.dao.commit()
            self.close_dialog(self.dlg_readsql_create_project)
            # Referesh data main dialog
            self.event_change_connection()
            self.set_info_project()
        else:
            self.controller.dao.rollback()
            # Reset count error variable to 0
            self.error_count = 0


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

        # Show message
        status = (self.error_count == 0)
        self.manage_result_message(status, parameter="Rename project")
        if status:
            self.controller.dao.commit()
            self.event_change_connection()
            utils_giswater.setWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name, str(self.schema))
            if close_dlg_rename:
                self.close_dialog(self.dlg_readsql_rename)
        else:
            self.controller.dao.rollback()

        # Reset count error variable to 0
        self.error_count = 0


    def update_api(self):

        self.set_wait_cursor()
        self.api(False)
        self.set_arrow_cursor()

        status = (self.error_count == 0)
        self.manage_result_message(status, parameter="Update API")
        if status:
            self.controller.dao.commit()
        else:
            self.controller.dao.rollback()

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

        status = (self.error_count == 0)
        self.manage_result_message(status, parameter="Load custom SQL files")
        if status:
            self.controller.dao.commit()
        else:
            self.controller.dao.rollback()

        # Reset count error variable to 0
        self.error_count = 0


    # TODO: Rename this function => Update all versions from changelog file.
    def update(self, project_type):

        msg = "Are you sure to update the project schema to last version?"
        result = self.controller.ask_question(msg, "Info")
        if result:
            self.set_wait_cursor()
            self.load_updates(project_type, update_changelog=True)
            self.set_info_project()
            self.set_arrow_cursor()
        else:
            return

        status = (self.error_count == 0)
        self.manage_result_message(status, parameter="Update project")
        if status:
            self.controller.dao.commit()
            self.close_dialog(self.dlg_readsql_show_info)
        else:
            self.controller.dao.rollback()

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
            status = (self.error_count == 0)
            self.manage_result_message(status, parameter="Load updates")
            if status:
                self.controller.dao.commit()
            else:
                self.controller.dao.rollback()

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
            msg = "Connection Failed. Please, check connection parameters"
            self.controller.show_message(msg, 1)
            utils_giswater.dis_enable_dialog(self.dlg_readsql, False, ignore_widgets='cmb_connection')
            self.dlg_readsql.lbl_status.setPixmap(self.status_ko)
            utils_giswater.setWidgetText(self.dlg_readsql, self.dlg_readsql.lbl_status_text, msg)
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
            if not role_admin and self.username not in self.super_users:
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

        # Set listeners
        self.dlg_readsql_show_info.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_readsql_show_info))
        self.dlg_readsql_show_info.btn_update.clicked.connect(partial(self.update, self.project_type_selected))

        # Open dialog
        self.dlg_readsql_show_info.show()


    def read_info_version(self):

        if not os.path.exists(self.folderUpdates):
            self.controller.show_message("The updates folder was not found in sql folder.", 1)
            return

        folders = sorted(os.listdir(self.folderUpdates + ''))
        for folder in folders:
            sub_folders = sorted(os.listdir(self.folderUpdates + folder))
            for sub_folder in sub_folders:
                if str(sub_folder) > str(self.project_data_schema_version).replace('.',''):
                    if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder, ''):
                        status = self.readFiles(
                            sorted(os.listdir(self.folderUpdates + folder + os.sep + sub_folder + '')), self.folderUpdates + folder + os.sep + sub_folder + '')
                        if status is False:
                            continue
                else:
                    continue

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

        # TODO: Check this!
        cmb_locale = utils_giswater.getWidgetText(self.dlg_readsql, self.cmb_locale)
        self.folderLocale = self.sql_dir + os.sep + 'i18n' + os.sep + cmb_locale + os.sep
        print(self.folderLocale)


    def enable_datafile(self):

        if self.rdb_import_data.isChecked() is True:
            self.data_file.setEnabled(True)
            self.btn_push_file.setEnabled(True)
        else:
            self.data_file.setEnabled(False)
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
            sql = ("SELECT EXISTS(SELECT * FROM information_schema.tables "
                   "WHERE table_schema = '" + str(row[0]) + "' "
                   "AND table_name = 'version')")
            exists = self.controller.get_row(sql)
            if str(exists[0]) == 'True':
                sql = ("SELECT wsoftware FROM " + str(row[0]) + ".version")
                result = self.controller.get_row(sql)
                if result is not None and result[0] == filter.upper():
                    elem = [row[0], row[0]]
                    result_list.append(elem)

        if result_list == []:
            self.dlg_readsql.project_schema_name.clear()
            return

        utils_giswater.set_item_data(self.dlg_readsql.project_schema_name, result_list, 1)


    def filter_srid_changed(self):
        # return
        filter_value = utils_giswater.getWidgetText(self.dlg_readsql_create_project, self.filter_srid)
        if filter_value is 'null':
            filter_value = ''
        sql = ("SELECT substr(srtext, 1, 6) as " + '"Type"' + ", srid as " + '"SRID"' + ", "
               "substr(split_part(srtext, ',', 1), 9) as " + '"Description"' + " "
               "FROM public.spatial_ref_sys "
               "WHERE CAST(srid AS TEXT) LIKE '" + str(filter_value))
        sql += "%' ORDER BY substr(srtext, 1, 6), srid"

        # Populate Table
        self.fill_table_by_query(self.tbl_srid, sql)


    def set_info_project(self):
        # self.project_data_language = 'EN'
        # return

        # Set default lenaguage EN
        self.project_data_language = 'EN'

        schema_name = utils_giswater.getWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name)

        if schema_name is None:
            schema_name = 'Nothing to select'
            self.project_data_schema_version = "Version not found"
            utils_giswater.enable_disable_tab_by_tabName(self.dlg_readsql.tab_main, "others", False)
        else:
            sql = "SELECT giswater FROM " + schema_name + ".version order by id desc LIMIT 1"
            row = self.controller.get_row(sql)
            if row:
                self.project_data_schema_version = str(row[0])
            sql = "SELECT language FROM " + schema_name + ".version order by id desc LIMIT 1"
            row = self.controller.get_row(sql)
            if row:
                self.project_data_language = str(row[0])
            utils_giswater.enable_disable_tab_by_tabName(self.dlg_readsql.tab_main, "others", True)

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
            sql = ("SELECT value FROM " + schema_name + ".config_param_system "
                   "WHERE parameter = 'schema_manager'")
            result = self.controller.get_row(sql)

        if result is None:
            result = ['{"title":"","author":"","date":""}']
        result = [json.loads(result[0])]

        msg = ('Database version: ' + str(database_version[0]) + '\n' + ''
               + str(postgis_version[0]) + ' \n \n' + ''
               'Name: ' + schema_name + '\n' + ''
               'Version: ' + self.project_data_schema_version + ' \n' + ''
               'Language: ' + self.project_data_language + ' \n' + ''
               'Title: ' + str(result[0]['title']) + '\n' + ''
               'Author: ' + str(result[0]['author']) + '\n' + ''
               'Date: ' + str(result[0]['date']))
        self.software_version_info.setText(msg)

        # Update windowTitle
        connection = utils_giswater.getWidgetText(self.dlg_readsql, self.dlg_readsql.cmb_connection)
        window_title = 'Giswater (' + str(connection) + ' - ' + str(self.plugin_version) + ')'
        self.dlg_readsql.setWindowTitle(window_title)


    def process_folder(self, folderPath, filePattern):

        try:
            self.controller.log_info(str(sorted(os.listdir(folderPath + filePattern))))
            return True
        except Exception:
            return False


    def schema_file_to_db(self):

        if self.chk_schema_funcion.isChecked():
            self.set_wait_cursor()
            self.reload_fct_ftrg(self.project_type_selected)
            self.set_arrow_cursor()

        status = (self.error_count == 0)
        self.manage_result_message(status, parameter="Reload")
        if status:
            self.controller.dao.commit()
        else:
            self.controller.dao.rollback()

        # Reset count error variable to 0
        self.error_count = 0


    def api_file_to_db(self):

        if self.chk_api_funcion.isChecked():
            self.set_wait_cursor()
            self.reload_fct_ftrg('api')
            self.set_arrow_cursor()

        # Show message
        if self.error_count == 0:
            self.controller.dao.commit()
            msg = "Process has been executed correctly"
            self.controller.show_info_box(msg, "Info", parameter="Reload")
        else:
            self.controller.dao.rollback()
            msg = "Some error has occurred executing process"
            self.controller.show_info_box(msg, "Warning", parameter="Reload")

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

        #Load user values
        self.project_title.setText(str(self.controller.plugin_settings_value('project_title_schema')))
        if str(self.controller.plugin_settings_value('inp_file_path')) != 'null':
            self.data_file.setText(str(self.controller.plugin_settings_value('inp_file_path')))

        # TODO: do and call listener for buton + table -> temp_csv2pg
        self.btn_push_file = self.dlg_readsql_create_project.findChild(QPushButton, 'btn_push_file')

        if self.dev_user != 'TRUE':
            self.rdb_sample_dev.setVisible(False)

        self.filter_srid = self.dlg_readsql_create_project.findChild(QLineEdit, 'srid_id')
        utils_giswater.setWidgetText(self.dlg_readsql_create_project, 'srid_id', str(self.filter_srid_value))
        self.tbl_srid = self.dlg_readsql_create_project.findChild(QTableView, 'tbl_srid')
        self.tbl_srid.setSelectionBehavior(QAbstractItemView.SelectRows)
        # return comentar
        sql = ("SELECT substr(srtext, 1, 6) as " + '"Type"' + ", srid as " + '"SRID"' + ", "
               "substr(split_part(srtext, ',', 1), 9) as " + '"Description"' + " "
               "FROM public.spatial_ref_sys "
               "WHERE CAST(srid AS TEXT) LIKE '" + str(self.filter_srid_value) + "%' "
               "ORDER BY substr(srtext, 1, 6), srid")

        # Populate Table
        self.fill_table_by_query(self.tbl_srid, sql)
        # return esto
        self.cmb_create_project_type = self.dlg_readsql_create_project.findChild(QComboBox, 'cmb_create_project_type')

        for porject_type in self.project_types:
            self.cmb_create_project_type.addItem(str(porject_type))

        utils_giswater.setWidgetText(self.dlg_readsql_create_project, self.cmb_create_project_type,
                                     utils_giswater.getWidgetText(self.dlg_readsql, self.dlg_readsql.cmb_project_type))

        self.change_project_type(self.cmb_create_project_type)

        # Enable_disable data file widgets
        self.enable_datafile()

        # Get combo locale
        self.cmb_locale = self.dlg_readsql_create_project.findChild(QComboBox, 'cmb_locale')

        # Set listeners
        self.dlg_readsql_create_project.btn_accept.clicked.connect(partial(self.task_example))
        self.dlg_readsql_create_project.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_readsql_create_project))
        self.dlg_readsql_create_project.btn_push_file.clicked.connect(partial(self.select_file_inp))
        self.cmb_create_project_type.currentIndexChanged.connect(partial(self.change_project_type, self.cmb_create_project_type))
        self.cmb_locale.currentIndexChanged.connect(partial(self.update_locale))
        self.rdb_import_data.toggled.connect(partial(self.enable_datafile))
        self.filter_srid.textChanged.connect(partial(self.filter_srid_changed))

        # Populate combo with all locales
        locales = sorted(os.listdir(self.sql_dir + os.sep + 'i18n' + os.sep))
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
            msg = "The schema version has to be updated to make rename"
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
        status = True
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
                    status = self.read_execute_file(filedir, os.sep + 'utils.sql', schema_name, filter_srid_value)
                elif str(self.project_type_selected) + ".sql" in file:
                    self.controller.log_info(str(filedir + os.sep + str(self.project_type_selected) + '.sql'))
                    status = self.read_execute_file(filedir, os.sep + str(self.project_type_selected) + '.sql', schema_name, filter_srid_value)
                if not status and self.dev_commit == 'FALSE':
                    return False
        else:
            for file in filelist:
                if ".sql" in file:
                    if (no_ct is True and "tablect.sql" not in file) or no_ct is False:
                        self.controller.log_info(str(filedir + os.sep + file))
                        status = self.read_execute_file(filedir, file, schema_name, filter_srid_value)
                        if not status and self.dev_commit == 'FALSE':
                            return False

        return status


    def read_execute_file(self, filedir, file, schema_name, filter_srid_value):

        status = False
        try:
            f = open(filedir + os.sep + file, 'r')
            if f:
                f_to_read = str(f.read().replace("SCHEMA_NAME", schema_name).replace("SRID_VALUE", filter_srid_value))
                if Qgis.QGIS_VERSION_INT < 29900:
                    f_to_read.decode(str('utf-8-sig'))

                if self.dev_commit == 'TRUE':
                    status = self.controller.execute_sql(str(f_to_read))
                else:
                    status = self.controller.execute_sql(str(f_to_read), commit=False)

                if status is False:
                    self.error_count = self.error_count + 1
                    self.controller.log_info(str("read_execute_file error"), parameter=filedir + os.sep + file)
                    self.controller.log_info(str('Message: ' + str(self.controller.last_error)))
                    if self.dev_commit == 'TRUE':
                        self.controller.dao.rollback()
                    return False

        except Exception as e:
            self.error_count = self.error_count + 1
            self.controller.log_info(str("read_execute_file exception"), parameter=file)
            self.controller.log_info(str(e))
            if self.dev_commit == 'TRUE':
                self.controller.dao.rollback()
            status = False
        finally:
            return status


    def readFiles(self, filelist, filedir):

        if "changelog.txt" in filelist:
            try:
                f = open(filedir + os.sep + 'changelog.txt', 'r')
                if f:
                    if Qgis.QGIS_VERSION_INT < 29900:
                        f_to_read = str(f.read()).decode(str('utf-8-sig'))
                    else:
                        f_to_read = str(f.read())
                    f_to_read = f_to_read + '\n'
                    self.message_update = self.message_update + '\n' + str(f_to_read)
                else:
                    return False
            except Exception as e:
                self.controller.log_warning("Error readFiles: " + str(e))
                return False

        return True


    def delete_schema(self):

        project_name = utils_giswater.getWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name)
        if project_name is None:
            msg = "Please, select a project to delete"
            self.controller.show_info_box(msg, "Info")
            return

        msg = "Are you sure you want delete schema '" + str(project_name) + "' ?"
        result = self.controller.ask_question(msg, "Info")
        if result:
            sql = ('DROP SCHEMA ' + str(project_name) + ' CASCADE;')
            status = self.controller.execute_sql(sql)
            if status:
                msg = "Process finished successfully"
                self.controller.show_info_box(msg, "Info", parameter="Delete schema")

        self.populate_data_schema_name(self.cmb_project_type)
        self.set_info_project()


    def execute_import_inp(self, accepted=False, schema_type=''):

        if accepted:

            # Set wait cursor
            self.set_wait_cursor()

            # Insert inp values into database
            self.insert_inp_into_db(self.file_inp)

            # Execute import data
            if schema_type.lower() == 'ws':
                function_name = 'gw_fct_utils_csv2pg_import_epanet_inp'
                useNode2arc = self.dlg_import_inp.findChild(QWidget, 'useNode2arc')
                extras = '"parameters":{"useNode2arc":"' + str(useNode2arc.isChecked()) + '"}'
            elif schema_type.lower() == 'ud':
                function_name = 'gw_fct_utils_csv2pg_import_swmm_inp'
                createSubcGeom = self.dlg_import_inp.findChild(QWidget, 'createSubcGeom')
                extras = '"parameters":{"createSubcGeom":' + str(createSubcGeom.isChecked()) + '}'
            else:
                self.error_count = self.error_count + 1
                return

            # Set progressBar ON
            self.dlg_import_inp.progressBar.setMaximum(0)
            self.dlg_import_inp.progressBar.setMinimum(0)
            self.dlg_import_inp.progressBar.setVisible(True)
            self.dlg_import_inp.progressBar.setFormat("Running function: " + str(function_name))
            self.dlg_import_inp.progressBar.setAlignment(Qt.AlignCenter)
            self.dlg_import_inp.progressBar.setFormat("")

            body = self.create_body(extras=extras)
            sql = ("SELECT " + self.schema_name + "." + str(function_name) + "($${" + body + "}$$)::text")
            row = self.controller.get_row(sql, log_sql=True, commit=True)
            if row:
                complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]
                self.set_log_text(self.dlg_import_inp, complet_result[0]['body']['data'])
            else:
                self.error_count = self.error_count + 1

            # Manage process result
            self.manage_process_result()

        else:
            msg = "A rollback on schema will be done."
            self.controller.show_info_box(msg, "Info")
            self.controller.dao.rollback()
            self.error_count = 0

        # Close dialog
        self.close_dialog(self.dlg_import_inp)
        self.close_dialog(self.dlg_readsql_create_project)


    def create_qgis_template(self):

        # Get dev config file
        setting_file = os.path.join(self.plugin_dir, 'config', 'dev.config')
        if not os.path.exists(setting_file):
            message = "File not found"
            self.controller.show_warning(message, parameter=setting_file)
            return

        # Set plugin settings
        self.dev_settings = QSettings(setting_file, QSettings.IniFormat)
        self.dev_settings.setIniCodec(sys.getfilesystemencoding())

        # Get values
        self.folder_path = self.dev_settings.value('general_dev/folder_path')
        self.text_replace_labels = self.dev_settings.value('text_replace/labels')
        self.xml_set_labels = self.dev_settings.value('xml_set/labels')
        if not os.path.exists(self.folder_path):
            message = "Folder not found"
            self.controller.show_warning(message, parameter=self.folder_path)
            return

        # Set wait cursor
        self.set_wait_cursor()

        # Start read files
        qgis_files = sorted(os.listdir(self.folder_path))
        for file in qgis_files:
            self.controller.log_info("Reading file", parameter=file)
            # Open file for read
            f = open(self.folder_path + os.sep + file, 'r')
            if f:
                f_to_read = str(f.read())

                # Replace into template text
                for text_replace in self.text_replace_labels:
                    self.text_replace = self.dev_settings.value('text_replace/' + text_replace)
                    self.controller.log_info("Replacing template text", parameter=self.text_replace[1])
                    f_to_read = str(f_to_read.replace(self.text_replace[0], self.text_replace[1]))

                # Close file
                f.close()

                # Open file for write
                f = open(self.folder_path + os.sep + file, 'w')
                f.write(f_to_read)

                # Close file
                f.close()

        # Set arrow cursor
        self.set_arrow_cursor()

        # Finish proces
        msg = "The QGIS Projects templates was correctly created."
        self.controller.show_info_box(msg, "Info")


    """ Import / Export UI and manage fields """

    def execute_import_ui(self):

        schema_name = utils_giswater.getWidgetText(self.dlg_readsql, 'project_schema_name')
        tpath = utils_giswater.getWidgetText(self.dlg_readsql, 'tpath')
        # tpath = utils_giswater.getWidget(self.dlg_readsql, 'tpath')
        # ui_path = tpath.document().toPlainText()
        form_name_ui = utils_giswater.getWidgetText(self.dlg_readsql, 'cmb_formname_ui')
        status_update_childs = self.dlg_readsql.chk_multi_update.isChecked()

        # Control if ui path is invalid or null
        if tpath is None:
            msg = "Please, select a valid UI Path."
            self.controller.show_info_box(msg, "Info")
            return

        with open(str(tpath)) as f:
            content = f.read()
        sql = ("INSERT INTO " + schema_name + ".temp_csv2pg(source, csv1, csv2pgcat_id) VALUES('" +
               str(form_name_ui) + "', '" + str(content) + "', 20);")
        status = self.controller.execute_sql(sql, log_sql=True, commit=True)

        # Import xml to database
        sql = ("SELECT " + schema_name + ".gw_fct_utils_import_ui_xml('" + str(form_name_ui) + "', " + str(status_update_childs) + ")::text")
        status = self.controller.execute_sql(sql, log_sql=True, commit=True)
        self.manage_result_message(status, parameter="Import data into 'config_api_form_fields'")

        # Clear temp_csv2pg
        self.clear_temp_table()


    def execute_export_ui(self):

        schema_name = utils_giswater.getWidgetText(self.dlg_readsql, 'project_schema_name')
        tpath = utils_giswater.getWidgetText(self.dlg_readsql, 'tpath')
        # tpath = utils_giswater.getWidget(self.dlg_readsql, 'tpath')
        # ui_path = tpath.document().toPlainText()
        form_name_ui = utils_giswater.getWidgetText(self.dlg_readsql, 'cmb_formname_ui')
        status_update_childs = self.dlg_readsql.chk_multi_update.isChecked()


        # Control if ui path is invalid or null
        if tpath is None:
            msg = "Please, select a valid UI Path."
            self.controller.show_info_box(msg, "Info")
            return

        # Export xml from database
        sql = ("SELECT " + schema_name + ".gw_fct_utils_export_ui_xml('" + str(form_name_ui) + "', " + str(status_update_childs) + ")::text")
        status = self.controller.execute_sql(sql, log_sql=True, commit=True)

        # Check status
        if status is False:
            msg = "Process finished with some errors"
            self.controller.show_info_box(msg, "Warning", parameter="Function import/export")
            return

        # Populate UI file
        sql = ("SELECT csv1 FROM " + schema_name + ".temp_csv2pg WHERE user_name = current_user AND source = '" +
               str(form_name_ui) + "' ORDER BY id DESC")
        row = self.controller.get_row(sql, log_sql=True, commit=True)

        data = ET.Element(str(row[0]))
        data = ET.tostring(data)
        file_ui = open(tpath, "w")

        # TODO:: dont use replace for remove invalid characters
        data = data.replace(' />', '').replace('<<', '<')
        file_ui.write(data)
        file_ui.close()
        del file_ui
        msg = "Exported data into '" + str(tpath) + "' successfully. \n Do you want to open the UI form?"
        result = self.controller.ask_question(msg, "Info")

        if result:
            opener = "C:\OSGeo4W64/bin/designer.exe"
            subprocess.Popen([opener, tpath])

        # Clear temp_csv2pg
        self.clear_temp_table()


    def clear_temp_table(self):

        schema_name = utils_giswater.getWidgetText(self.dlg_readsql, 'project_schema_name')
        # Clear temp_csv2pg
        sql = ("DELETE FROM " + schema_name + ".temp_csv2pg WHERE user_name = current_user")
        status = self.controller.execute_sql(sql, log_sql=True, commit=True)


    def select_file_ui(self):
        """ Select UI file """

        file_ui = utils_giswater.getWidgetText(self.dlg_readsql, 'tpath')
        # Set default value if necessary
        if file_ui is None or file_ui == '':
            file_ui = self.plugin_dir

        # Get directory of that file
        folder_path = os.path.dirname(file_ui)
        if not os.path.exists(folder_path):
            folder_path = os.path.dirname(__file__)
        os.chdir(folder_path)
        message = self.controller.tr("Select UI file")

        if Qgis.QGIS_VERSION_INT < 29900:
            file_ui = QFileDialog.getSaveFileName(None, message, "", '*.ui')
        else:
            file_ui, filter_ = QFileDialog.getSaveFileName(None, message, "", '*.ui')

        utils_giswater.setWidgetText(self.dlg_readsql, self.dlg_readsql.tpath, str(file_ui))


    def update_manage_ui(self, parent=False):

        schema_name = utils_giswater.getWidgetText(self.dlg_readsql, 'project_schema_name')
        if schema_name is None:
            utils_giswater.enable_disable_tab_by_tabName(self.dlg_readsql.tab_main, "others", False)
            return
        else:
            utils_giswater.enable_disable_tab_by_tabName(self.dlg_readsql.tab_main, "others", True)

        # Control if schema_version is updated to 3.2
        if str(self.project_data_schema_version).replace('.','') < str(self.version_metadata).replace('.', ''):

            utils_giswater.getWidget(self.dlg_readsql,self.dlg_readsql.grb_manage_addfields).setEnabled(False)
            utils_giswater.getWidget(self.dlg_readsql, self.dlg_readsql.grb_manage_ui).setEnabled(False)
            return

        else:
            # return
            utils_giswater.getWidget(self.dlg_readsql, self.dlg_readsql.grb_manage_addfields).setEnabled(True)
            utils_giswater.getWidget(self.dlg_readsql, self.dlg_readsql.grb_manage_ui).setEnabled(True)

            sql = ("SELECT DISTINCT(child_layer), child_layer FROM " + str(schema_name) + ".cat_feature")
            rows = self.controller.get_rows(sql, log_sql=True, commit=True)
            utils_giswater.set_item_data(self.dlg_readsql.cmb_formname_ui, rows, 1)

            sql = ("SELECT DISTINCT(id), id FROM " + str(schema_name) + ".cat_feature")
            rows = self.controller.get_rows(sql, log_sql=True, commit=True)
            utils_giswater.set_item_data(self.dlg_readsql.cmb_formname_fields, rows, 1)
            utils_giswater.set_item_data(self.dlg_readsql.cmb_feature_name_view, rows, 1)


    def create_child_view(self):
        """ Create child view """

        schema_name = utils_giswater.getWidgetText(self.dlg_readsql, 'project_schema_name')
        form_name = utils_giswater.getWidgetText(self.dlg_readsql, self.dlg_readsql.cmb_feature_name_view)

        # Create body
        feature = '"catFeature":"' + form_name + '"'
        extras = '"multi_create":' + str(utils_giswater.isChecked(self.dlg_readsql,self.dlg_readsql.chk_multi_create)).lower() + ''
        body = self.create_body(feature=feature, extras=extras)
        body = body.replace('""', 'null')

        # Execute query
        sql = ("SELECT " + schema_name + ".gw_fct_admin_manage_child_views($${" + body + "}$$)::text")
        status = self.controller.execute_sql(sql, log_sql=True, commit=True)
        self.manage_result_message(status, parameter="Created child view")


    def open_manage_field(self, action):

        # Create the dialog and signals
        self.dlg_manage_fields = ManageFields()
        self.load_settings(self.dlg_manage_fields)
        self.model_update_table = None

        # Remove unused tabs
        for x in range(self.dlg_manage_fields.tab_add_fields.count() - 1, -1, -1):
            if str(self.dlg_manage_fields.tab_add_fields.widget(x).objectName()) != str(action):
                utils_giswater.remove_tab_by_tabName(self.dlg_manage_fields.tab_add_fields, self.dlg_manage_fields.tab_add_fields.widget(x).objectName())

        form_name_fields = utils_giswater.getWidgetText(self.dlg_readsql, self.dlg_readsql.cmb_formname_fields)

        if action == 'Create':
            window_title = 'Create field on "' + str(form_name_fields) + '"'
            self.dlg_manage_fields.setWindowTitle(window_title)
            self.manage_create_field(form_name_fields)
        elif action == 'Update':
            window_title = 'Create field on "' + str(form_name_fields) + '"'
            self.dlg_manage_fields.setWindowTitle(window_title)
            self.manage_update_field(form_name_fields)
        elif action == 'Delete':
            window_title = 'Delete field on "' + str(form_name_fields) + '"'
            self.dlg_manage_fields.setWindowTitle(window_title)
            self.manage_delete_field(form_name_fields)

        # Set listeners
        self.dlg_manage_fields.btn_accept.clicked.connect(partial(self.manage_accept, action, form_name_fields, self.model_update_table))
        self.dlg_manage_fields.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_manage_fields))

        self.dlg_manage_fields.show()


    def manage_create_field(self, form_name):

        schema_name = utils_giswater.getWidgetText(self.dlg_readsql, 'project_schema_name')

        # Populate widgettype combo
        sql = ("SELECT DISTINCT(id), id FROM " + schema_name + ".man_addfields_cat_widgettype")
        rows = self.controller.get_rows(sql, log_sql=True, commit=True)
        utils_giswater.set_item_data(self.dlg_manage_fields.widgettype, rows, 1)

        # Populate datatype combo
        sql = ("SELECT DISTINCT(id), id FROM " + schema_name + ".man_addfields_cat_datatype")
        rows = self.controller.get_rows(sql, log_sql=True, commit=True)
        utils_giswater.set_item_data(self.dlg_manage_fields.datatype, rows, 1)

        # Set default value for formtype widget
        utils_giswater.setWidgetText(self.dlg_manage_fields, self.dlg_manage_fields.formtype, 'feature')

        # Configure column_id as typeahead
        completer = QCompleter()
        model = QStringListModel()
        self.filter_typeahead(schema_name, form_name, self.dlg_manage_fields.column_id, completer, model)

        # Set listeners
        self.dlg_manage_fields.column_id.textChanged.connect(partial(self.filter_typeahead,schema_name, form_name, self.dlg_manage_fields.column_id, completer, model))


    def manage_update_field(self, form_name):
        # return
        schema_name = utils_giswater.getWidgetText(self.dlg_readsql, 'project_schema_name')

        if schema_name is None:
            utils_giswater.enable_disable_tab_by_tabName(self.dlg_readsql.tab_main, "others", False)
            return
        else:
            utils_giswater.enable_disable_tab_by_tabName(self.dlg_readsql.tab_main, "others", True)

        # Get child layer
        sql = ("SELECT child_layer FROM " + schema_name + ".cat_feature WHERE id = '" + form_name + "'")
        result_child_layer = self.controller.get_row(sql, log_sql=True, commit=True)

        qtable = self.dlg_manage_fields.findChild(QTableView, "tbl_update")
        self.model_update_table = QSqlTableModel()
        expr_filter = "formname ='" + result_child_layer[0] + "'"
        self.fill_table(qtable, 'config_api_form_fields', self.model_update_table, expr_filter)
        self.set_table_columns(self.dlg_manage_fields, qtable, 'config_api_form_fields', schema_name)


    def manage_delete_field(self, form_name):
        # return
        schema_name = utils_giswater.getWidgetText(self.dlg_readsql, 'project_schema_name')

        if schema_name is None:
            utils_giswater.enable_disable_tab_by_tabName(self.dlg_readsql.tab_main, "others", False)
            return
        else:
            utils_giswater.enable_disable_tab_by_tabName(self.dlg_readsql.tab_main, "others", True)

        # Get child layer
        sql = ("SELECT child_layer FROM " + schema_name + ".cat_feature WHERE id = '" + form_name + "'")
        result_child_layer = self.controller.get_row(sql, log_sql=True, commit=True)

        # Populate widgettype combo
        sql = ("SELECT DISTINCT(column_id), column_id FROM " + schema_name + ".config_api_form_fields WHERE formname = '"
               + result_child_layer[0] + "'")
        rows = self.controller.get_rows(sql, log_sql=True, commit=True)
        utils_giswater.set_item_data(self.dlg_manage_fields.cmb_fields, rows, 1)


    def manage_accept(self, action, form_name, model=None):

        schema_name = utils_giswater.getWidgetText(self.dlg_readsql, 'project_schema_name')

        if action == 'Create':

            # Control mandatory widgets
            if utils_giswater.getWidgetText(self.dlg_manage_fields, self.dlg_manage_fields.column_id) is 'null' or \
                    utils_giswater.getWidgetText(self.dlg_manage_fields, self.dlg_manage_fields.label) is 'null':
                msg = "Column_id and Label fields mandatory. Please set correctly value."
                self.controller.show_info_box(msg, "Info")
                return

            elif str(self.rows_typeahead) != '':
                if str(utils_giswater.getWidgetText(self.dlg_manage_fields, self.dlg_manage_fields.column_id)) == str(self.rows_typeahead[0]):
                    msg = "The column id value is already exists."
                    self.controller.show_info_box(msg, "Info")
                    return

            list_widgets = self.dlg_manage_fields.Create.findChildren(QWidget)

            _json = {}
            for widget in list_widgets:
                if type(widget) not in (QScrollArea, QFrame, QWidget, QScrollBar, QLabel, QAbstractButton, QHeaderView, QListView) \
                        and widget.objectName() not in ('qt_spinbox_lineedit', 'chk_multi_insert'):

                    if type(widget) in (QLineEdit, QSpinBox, QDoubleSpinBox):
                        value = utils_giswater.getWidgetText(self.dlg_manage_fields, widget, return_string_null=False)
                    elif type(widget) is QComboBox:
                        value = utils_giswater.get_item_data(self.dlg_manage_fields, widget, 0)
                    elif type(widget) is QCheckBox:
                        value = utils_giswater.isChecked(self.dlg_manage_fields, widget)
                    elif type(widget) is QgsDateTimeEdit :
                        value = utils_giswater.getCalendarDate(self.dlg_manage_fields, widget)
                    elif type(widget) is QPlainTextEdit:
                        value = widget.document().toPlainText()

                    if str(widget.objectName()) not in (None, 'null', '', ""):

                        _json[str(widget.objectName())] = value
                        result_json = json.dumps(_json)

            # Create body
            feature = '"catFeature":"' + form_name + '"'
            extras = '"action":"CREATE", "multi_create":' + str(utils_giswater.isChecked(self.dlg_manage_fields,self.dlg_manage_fields.chk_multi_insert)).lower() + ', "parameters":' + result_json + ''
            body = self.create_body(feature=feature, extras=extras)
            body = body.replace('""', 'null')

            # Execute manage add fields function
            sql = ("SELECT " + schema_name + ".gw_fct_admin_manage_addfields($${" + body + "}$$)::text")
            status = self.controller.execute_sql(sql, log_sql=True, commit=True)
            self.manage_result_message(status, parameter="Created field into 'config_api_form_fields'")
            if not status:
                return

        elif action == 'Update':

            status = model is not None and model.submitAll()
            self.manage_result_message(status, parameter="Update")
            if not status:
                return

        elif action == 'Delete':

            field_value = utils_giswater.getWidgetText(self.dlg_manage_fields, self.dlg_manage_fields.cmb_fields)

            # Create body
            feature = '"catFeature":"' + form_name + '"'
            extras = '"action":"DELETE", "parameters":{"column_id":"' + field_value + '"}'
            body = self.create_body(feature=feature, extras=extras)

            # Execute manage add fields function
            sql = ("SELECT " + schema_name + ".gw_fct_admin_manage_addfields($${" + body + "}$$)::text")
            status = self.controller.execute_sql(sql, log_sql=True, commit=True)
            self.manage_result_message(status, parameter="Delete function")

        # Close dialog
        self.close_dialog(self.dlg_manage_fields)


    def fill_table(self, qtable, table_name, model, expr_filter, set_edit_strategy=QSqlTableModel.OnManualSubmit):
        """ Set a model with selected filter.
        Attach that model to selected table """

        schema_name = utils_giswater.getWidgetText(self.dlg_readsql, 'project_schema_name')
        if schema_name not in table_name:
            table_name = schema_name + "." + table_name

        # Set model
        model.setTable(table_name)
        model.setEditStrategy(set_edit_strategy)
        if expr_filter is not None:
            model.setFilter(expr_filter)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())
        # Attach model to table view
        qtable.setModel(model)


    def filter_typeahead(self, schema_name, form_name, widget, completer, model):
        # return
        filter = utils_giswater.getWidgetText(self.dlg_manage_fields, self.dlg_manage_fields.column_id)
        if filter == 'null':
            filter = ''

        if schema_name is None:
            utils_giswater.enable_disable_tab_by_tabName(self.dlg_readsql.tab_main, "others", False)
            return
        else:
            utils_giswater.enable_disable_tab_by_tabName(self.dlg_readsql.tab_main, "others", True)

        # Get child layer
        sql = ("SELECT child_layer FROM " + schema_name + ".cat_feature WHERE id = '" + form_name + "'")
        result_child_layer = self.controller.get_row(sql, log_sql=True, commit=True)

        sql = ("SELECT array_agg(DISTINCT(column_id)) FROM " + schema_name + ".config_api_form_fields WHERE formname = '" + result_child_layer[0] + "'"
               " AND column_id LIKE '%" + filter + "%'")
        self.rows_typeahead = self.controller.get_rows(sql, log_sql=True, commit=True)
        self.rows_typeahead = self.rows_typeahead[0][0]

        if self.rows_typeahead is None:
            self.rows_typeahead = ''

        self.set_completer_object_api(completer, model, widget, self.rows_typeahead)

    """ Take current project type changed """

    def change_project_type(self, widget):
        self.project_type_selected = utils_giswater.getWidgetText(self.dlg_readsql, widget)
        self.folderSoftware = self.sql_dir + os.sep + self.project_type_selected + os.sep


    def insert_inp_into_db(self, folder_path=None):

        _file = open(folder_path, "r+")
        full_file = _file.readlines()
        sql = ""
        progress = 0
        target = ""
        for row in full_file:
            progress += 1
            row = row.rstrip()
            if len(row) == 0:
                continue
            if str(row[0]) == "[":
                target = str(row)
            if target in ('[TRANSECTS]', '[CONTROLS]', '[RULES]'):
                sp_n = [row]
            elif target in ('[EVAPORATION]', '[TEMPERATURE]'):
                sp_n = re.split(' |\t', row, 1)
            else:
                if str(row[0]) != ';':
                    list_aux = row.split("\t")
                    dirty_list = []
                    for x in range(0, len(list_aux)):
                        aux = list_aux[x].split(" ")
                        for i in range(len(aux)):
                            dirty_list.append(aux[i])
                else:
                    dirty_list = [row]

                for x in range(len(dirty_list) - 1, -1, -1):
                    if dirty_list[x] == '' or "**" in dirty_list[x] or "--" in dirty_list[x] or dirty_list[x] == '; '\
                            or dirty_list[x] == ';' or dirty_list[x] == ';\n':
                        dirty_list.pop(x)
                sp_n = dirty_list

            if len(sp_n) > 0:
                sql += "INSERT INTO " + self.schema + ".temp_csv2pg (csv2pgcat_id, source, "
                values = "VALUES(12, '" + target + "', "
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
            # TODO:: Use dev_commit or dev_user?
            if self.dev_user:
                self.controller.execute_sql(sql, commit=True)
            else:
                self.controller.execute_sql(sql, commit=False)
            sql = ""
        if sql != "":
            # TODO:: Use dev_commit or dev_user?
            if self.dev_user:
                self.controller.execute_sql(sql, commit=True)
            else:
                self.controller.execute_sql(sql, commit=False)

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

        if Qgis.QGIS_VERSION_INT < 29900:
            file_inp = QFileDialog.getOpenFileName(None, message, "", '*.inp')
        else:
            file_inp, filter_ = QFileDialog.getOpenFileName(None, message, "", '*.inp')

        self.dlg_readsql_create_project.data_file.setText(file_inp)


    def populate_functions_dlg(self, dialog, result):

        status = False
        for group, function in result['fields'].items():
            if len(function) != 0:
                dialog.setWindowTitle(function[0]['alias'])
                dialog.txt_info.setText(str(function[0]['descript']))
                self.function_list = []
                self.construct_form_param_user(dialog, function, 0, self.function_list, False)
                status = True
                break

        return status


    def set_log_text(self, dialog, data):

        qtabwidget = dialog.mainTab
        qtextedit = dialog.txt_infolog
        for k, v in list(data.items()):
            if str(k) == "info":
                self.populate_info_text(dialog, qtabwidget, qtextedit, data)


    def info_show_info(self):
        """ Button 36: Info show info, open giswater and visit web page """

        # Create form
        self.dlg_info = InfoShowInfo()
        self.load_settings(self.dlg_info)

        # Get Plugin, Giswater, PostgreSQL and Postgis version
        postgresql_version = self.controller.get_postgresql_version()
        postgis_version = self.controller.get_postgis_version()
        plugin_version = self.get_plugin_version()
        project_version = self.controller.get_project_version()

        message = ("Plugin version:     " + str(plugin_version) + "\n"
                   "Project version:    " + str(project_version) + "\n"
                   "PostgreSQL version: " + str(postgresql_version) + "\n"
                   "Postgis version:    " + str(postgis_version))
        utils_giswater.setWidgetText(self.dlg_info, self.dlg_info.txt_info, message)

        # Set signals
        self.dlg_info.btn_open_web.clicked.connect(partial(self.open_web_browser, self.dlg_info, None))
        self.dlg_info.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_info))

        # Open dialog
        self.open_dialog(self.dlg_info, maximize_button=False)


    def manage_result_message(self, status, msg_ok=None, msg_error=None, parameter=None):
        """ Manage message depending result @status """

        if status:
            if msg_ok is None:
                msg_ok = "Process finished successfully"
            self.controller.show_info_box(msg_ok, "Info", parameter=parameter)
        else:
            if msg_error is None:
                msg_error = "Process finished with some errors"
            self.controller.show_info_box(msg_error, "Warning", parameter=parameter)

