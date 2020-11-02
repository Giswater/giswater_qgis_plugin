"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsProject, QgsTask, QgsApplication
from qgis.gui import QgsDateTimeEdit
from qgis.utils import reloadPlugin
from qgis.PyQt.QtCore import QSettings, Qt, QDate
from qgis.PyQt.QtGui import QPixmap
from qgis.PyQt.QtSql import QSqlTableModel, QSqlQueryModel
from qgis.PyQt.QtWidgets import QRadioButton, QPushButton, QAbstractItemView, QTextEdit, QFileDialog, \
    QLineEdit, QWidget, QComboBox, QLabel, QCheckBox, QScrollArea, QSpinBox, QAbstractButton, \
    QHeaderView, QListView, QFrame, QScrollBar, QDoubleSpinBox, QPlainTextEdit, QGroupBox, QTableView

import os
import sys
import random
import re
import json
import subprocess
import xml.etree.cElementTree as ET
from collections import OrderedDict
from functools import partial
from time import sleep

from .. import global_vars
from ..lib import tools_qt
from .btn_admin_gis_project import GwAdminGisProject
from .tasks.parent_task import GwTask
from ..i18n.i18n_generator import GwI18NGenerator
from .ui.ui_manager import MainUi, MainDbProjectUi, MainRenameProjUi, MainProjectInfoUi, \
    MainGisProjectUi, MainImportUi, MainFields, MainVisitClass, MainVisitParam, MainSysFields, Credentials
from .utils.tools_giswater import close_dialog, get_parser_value, load_settings, open_dialog, set_parser_value, \
    create_body, populate_info_text_ as populate_info_text
from ..lib.tools_qt import construct_form_param_user, get_folder_dialog, set_table_columns


class GwAdmin:

    def __init__(self):
        """ Class to control toolbar 'om_ws' """

        # Initialize instance attributes
        self.iface = global_vars.iface
        self.settings = global_vars.settings
        self.controller = global_vars.controller
        self.plugin_dir = global_vars.plugin_dir
        self.schema_name = global_vars.schema_name
        self.plugin_version = global_vars.plugin_version
        self.canvas = global_vars.canvas
        self.project_type = None
        self.dlg_readsql = None
        self.dlg_info = None
        self.dlg_readsql_create_project = None
        self.project_type_selected = None
        self.schema_type = None
        self.project_issample = True


    def init_sql(self, set_database_connection=False, username=None, show_dialog=True):
        """ Button 100: Execute SQL. Info show info """

        # Populate combo connections
        default_connection = self.populate_combo_connections()

        # Bug #733 was here
        # Check if connection is still False
        if set_database_connection:
            connection_status, not_version = self.controller.set_database_connection()
        else:
            connection_status = self.controller.logged

        if not connection_status:
            self.create_credentials_form(set_connection=default_connection)
            return

        # Set label status connection
        self.icon_folder = self.plugin_dir + os.sep + 'icons' + os.sep
        self.status_ok = QPixmap(self.icon_folder + 'status_ok.png')
        self.status_ko = QPixmap(self.icon_folder + 'status_ko.png')
        self.status_no_update = QPixmap(self.icon_folder + 'status_not_updated.png')

        # Create the dialog and signals
        self.init_show_database()

        # Check if we have any layer loaded
        self.info_show_database(username=username, show_dialog=show_dialog)


    def populate_combo_connections(self):

        s = QSettings()
        s.beginGroup("PostgreSQL/connections")
        default_connection = s.value('selected')
        connections = s.childGroups()
        self.list_connections = []
        for con in connections:
            elem = [con, con]
            self.list_connections.append(elem)
        s.endGroup()

        return default_connection


    def init_show_database(self):
        """ Initialization code of the form (to be executed only once) """

        # Get SQL folder and check if exists
        folder_name = os.path.dirname(os.path.abspath(__file__))
        self.sql_dir = os.path.normpath(os.path.normpath(folder_name + os.sep + os.pardir)) + os.sep + 'sql'
        if not os.path.exists(self.sql_dir):
            self.controller.show_message("SQL folder not found", parameter=self.sql_dir)
            return

        self.project_version = '0'

        # Manage super users
        self.super_users = []
        super_users = self.settings.value('system_variables/super_users')
        for super_user in super_users:
            self.super_users.append(str(super_user))

        # Get locale of QGIS application
        self.locale = self.controller.plugin_settings_value('locale/userLocale', 'en_us').lower()
        if self.locale == 'es_es':
            self.locale = 'ES'
        elif self.locale == 'es_ca':
            self.locale = 'CA'
        elif self.locale == 'en_us':
            self.locale = 'EN'

        # Declare all file variables
        self.file_pattern_tablect = "tablect"
        self.file_pattern_ddl = "ddl"
        self.file_pattern_dml = "dml"
        self.file_pattern_fct = "fct"
        self.file_pattern_trg = "trg"
        self.file_pattern_ftrg = "ftrg"
        self.file_pattern_ddlview = "ddlview"
        self.file_pattern_ddlrule = "ddlrule"

        # Declare all folders
        if self.schema_name is not None and self.project_type is not None:
            self.folderSoftware = self.sql_dir + os.sep + self.project_type + os.sep
        else:
            self.folderSoftware = ""

        self.folderLocale = self.sql_dir + os.sep + 'i18n' + os.sep + str(self.locale) + os.sep
        self.folderUtils = self.sql_dir + os.sep + 'utils' + os.sep
        self.folderUpdates = self.sql_dir + os.sep + 'updates' + os.sep
        self.folderExemple = self.sql_dir + os.sep + 'example' + os.sep
        self.folderPath = ''

        # Declare all API folders
        self.folderUpdatesApi = self.sql_dir + os.sep + 'api' + os.sep + 'updates' + os.sep
        self.folderApi = self.sql_dir + os.sep + 'api' + os.sep

        # Check if user have dev permissions
        self.dev_user = self.settings.value('system_variables/devoloper_mode').upper()
        self.read_all_updates = self.settings.value('system_variables/read_all_updates').upper()
        self.dev_commit = self.settings.value('system_variables/dev_commit').upper()

        # Create dialog object
        self.dlg_readsql = MainUi()
        load_settings(self.dlg_readsql)
        self.cmb_project_type = self.dlg_readsql.findChild(QComboBox, 'cmb_project_type')

        if self.dev_user != 'TRUE':
            tools_qt.remove_tab_by_tabName(self.dlg_readsql.tab_main, "schema_manager")
            tools_qt.remove_tab_by_tabName(self.dlg_readsql.tab_main, "api_manager")
            tools_qt.remove_tab_by_tabName(self.dlg_readsql.tab_main, "custom")
            self.project_types = self.settings.value('system_variables/project_types')
        else:
            self.project_types = self.settings.value('system_variables/project_types_dev')

        # Populate combo types
        self.cmb_project_type.clear()
        for aux in self.project_types:
            self.cmb_project_type.addItem(str(aux))

        # Get widgets form
        self.cmb_connection = self.dlg_readsql.findChild(QComboBox, 'cmb_connection')
        self.btn_update_schema = self.dlg_readsql.findChild(QPushButton, 'btn_update_schema')
        self.lbl_schema_name = self.dlg_readsql.findChild(QLabel, 'lbl_schema_name')
        self.btn_constrains = self.dlg_readsql.findChild(QPushButton, 'btn_constrains')

        # Checkbox SCHEMA & API
        self.chk_schema_view = self.dlg_readsql.findChild(QCheckBox, 'chk_schema_view')
        self.chk_schema_funcion = self.dlg_readsql.findChild(QCheckBox, 'chk_schema_funcion')
        self.chk_api_view = self.dlg_readsql.findChild(QCheckBox, 'chk_api_view')
        self.software_version_info = self.dlg_readsql.findChild(QTextEdit, 'software_version_info')

        # Set Listeners
        self.set_signals()

        # Set default project type
        tools_qt.setWidgetText(self.dlg_readsql, self.cmb_project_type, 'ws')

        # Update folderSoftware
        self.change_project_type(self.cmb_project_type)


    def set_signals(self):
        """ Set signals. Function has to be executed only once (during form initialization) """

        self.dlg_readsql.btn_close.clicked.connect(partial(self.close_dialog_admin, self.dlg_readsql))
        self.dlg_readsql.btn_schema_create.clicked.connect(partial(self.open_create_project))
        self.dlg_readsql.btn_custom_load_file.clicked.connect(
            partial(self.load_custom_sql_files, self.dlg_readsql, "custom_path_folder"))
        self.dlg_readsql.btn_update_schema.clicked.connect(partial(self.load_updates, None))
        self.dlg_readsql.btn_schema_file_to_db.clicked.connect(partial(self.schema_file_to_db))
        self.dlg_readsql.btn_info.clicked.connect(partial(self.show_info))
        self.dlg_readsql.project_schema_name.currentIndexChanged.connect(partial(self.set_info_project))
        self.dlg_readsql.project_schema_name.currentIndexChanged.connect(partial(self.update_manage_ui))
        self.cmb_project_type.currentIndexChanged.connect(
            partial(self.populate_data_schema_name, self.cmb_project_type))
        self.cmb_project_type.currentIndexChanged.connect(partial(self.change_project_type, self.cmb_project_type))
        self.cmb_project_type.currentIndexChanged.connect(partial(self.set_info_project))
        self.cmb_project_type.currentIndexChanged.connect(partial(self.update_manage_ui))
        self.dlg_readsql.btn_custom_select_file.clicked.connect(
            partial(get_folder_dialog, self.dlg_readsql, "custom_path_folder"))
        self.cmb_connection.currentIndexChanged.connect(partial(self.event_change_connection))
        self.cmb_connection.currentIndexChanged.connect(partial(self.set_info_project))
        self.dlg_readsql.btn_schema_rename.clicked.connect(partial(self.open_rename))
        self.dlg_readsql.btn_delete.clicked.connect(partial(self.delete_schema))
        self.dlg_readsql.btn_copy.clicked.connect(partial(self.copy_schema))
        self.dlg_readsql.btn_constrains.clicked.connect(partial(self.btn_constrains_changed, self.btn_constrains, True))
        self.dlg_readsql.btn_create_qgis_template.clicked.connect(partial(self.create_qgis_template))
        self.dlg_readsql.btn_translation.clicked.connect(partial(self.manage_translations))
        self.dlg_readsql.btn_gis_create.clicked.connect(partial(self.open_form_create_gis_project))
        self.dlg_readsql.btn_path.clicked.connect(partial(self.select_file_ui))
        self.dlg_readsql.btn_import_ui.clicked.connect(partial(self.execute_import_ui))
        self.dlg_readsql.btn_export_ui.clicked.connect(partial(self.execute_export_ui))
        self.dlg_readsql.dlg_closed.connect(partial(self.save_selection))

        self.dlg_readsql.btn_create_field.clicked.connect(partial(self.open_manage_field, 'create'))
        self.dlg_readsql.btn_update_field.clicked.connect(partial(self.open_manage_field, 'update'))
        self.dlg_readsql.btn_delete_field.clicked.connect(partial(self.open_manage_field, 'delete'))
        self.dlg_readsql.btn_create_view.clicked.connect(partial(self.create_child_view))
        self.dlg_readsql.btn_update_sys_field.clicked.connect(partial(self.update_sys_fields))


    def manage_translations(self):

        qm_gen = GwI18NGenerator()
        qm_gen.init_dialog()


    def info_show_database(self, connection_status=True, username=None, show_dialog=False):

        self.message_update = ''
        self.error_count = 0
        self.schema = None

        # Get last database connection from controller
        self.last_connection = self.get_last_connection()

        # Get database connection user and role
        self.username = username
        if username is None:
            self.username = self.get_user_connection(self.last_connection)

        self.dlg_readsql.btn_info.setText('Update Project Schema')
        self.dlg_readsql.lbl_status_text.setStyleSheet("QLabel {color:red;}")

        # Populate again combo because user could have created one after initialization
        self.populate_combo_connections()

        if str(self.list_connections) != '[]':
            tools_qt.set_item_data(self.cmb_connection, self.list_connections, 1)

        # Set last connection for default
        tools_qt.set_combo_itemData(self.cmb_connection, str(self.last_connection), 1)

        # Set title
        connection = tools_qt.getWidgetText(self.dlg_readsql, self.dlg_readsql.cmb_connection)
        window_title = f'Giswater ({connection} - {self.plugin_version})'
        self.dlg_readsql.setWindowTitle(window_title)

        if connection_status is False:
            msg = "Connection Failed. Please, check connection parameters"
            self.controller.show_message(msg, 1)
            tools_qt.dis_enable_dialog(self.dlg_readsql, False, 'cmb_connection')
            self.dlg_readsql.lbl_status.setPixmap(self.status_ko)
            tools_qt.setWidgetText(self.dlg_readsql, 'lbl_status_text', msg)
            tools_qt.setWidgetText(self.dlg_readsql, 'lbl_schema_name', '')
            open_dialog(self.dlg_readsql, dlg_name='main_ui')
            return

        # Create extension postgis if not exist
        sql = "CREATE EXTENSION IF NOT EXISTS POSTGIS;"
        self.controller.execute_sql(sql)

        # Set projecte type
        self.project_type_selected = tools_qt.getWidgetText(self.dlg_readsql, self.dlg_readsql.cmb_project_type)

        # Manage widgets tabs
        self.populate_data_schema_name(self.cmb_project_type)
        self.set_info_project()
        self.update_manage_ui()
        self.visit_manager()

        if not self.controller.check_role(self.username) and not show_dialog:
            self.controller.log_warning(f"User not found: {self.username}")
            return

        role_admin = self.controller.check_role_user("role_admin", self.username)
        if not role_admin and self.username not in self.super_users:
            msg = "You don't have permissions to administrate project schemas on this connection"
            self.controller.show_message(msg, 1)
            tools_qt.dis_enable_dialog(self.dlg_readsql, False, 'cmb_connection')
            self.dlg_readsql.lbl_status.setPixmap(self.status_ko)
            tools_qt.setWidgetText(self.dlg_readsql, self.dlg_readsql.lbl_status_text, msg)
        else:
            if str(self.plugin_version) > str(self.project_version):
                self.dlg_readsql.lbl_status.setPixmap(self.status_no_update)
                tools_qt.setWidgetText(self.dlg_readsql, self.dlg_readsql.lbl_status_text,
                    '(Schema version is lower than plugin version, please update schema)')
                self.dlg_readsql.btn_info.setEnabled(True)
            elif str(self.plugin_version) < str(self.project_version):
                self.dlg_readsql.lbl_status.setPixmap(self.status_no_update)
                tools_qt.setWidgetText(self.dlg_readsql, self.dlg_readsql.lbl_status_text,
                    '(Schema version is higher than plugin version, please update plugin)')
                self.dlg_readsql.btn_info.setEnabled(True)
            else:
                self.dlg_readsql.lbl_status.setPixmap(self.status_ok)
                tools_qt.setWidgetText(self.dlg_readsql, self.dlg_readsql.lbl_status_text, '')
                self.dlg_readsql.btn_info.setEnabled(False)
            tools_qt.dis_enable_dialog(self.dlg_readsql, True)

        # Load last schema name selected and project type
        if get_parser_value('admin', 'last_project_type_selected') not in ('', None):
            tools_qt.setWidgetText(self.dlg_readsql, self.dlg_readsql.cmb_project_type,
                                   get_parser_value('admin', 'last_project_type_selected'))
        if get_parser_value('admin', 'last_schema_name_selected') not in ('', None):
            tools_qt.setWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name,
                                   get_parser_value('admin', 'last_schema_name_selected'))

        if show_dialog:
            self.manage_docker()


    def manage_docker(self):

        try:
            self.controller.init_docker('qgis_main_docker')
            if self.controller.dlg_docker:
                self.controller.dock_dialog(self.dlg_readsql)
                self.dlg_readsql.dlg_closed.connect(self.controller.close_docker)
            else:
                open_dialog(self.dlg_readsql, dlg_name='main_ui')
        except RuntimeError as e:
            self.controller.log_info(str(e))


    def set_credentials(self, dialog, new_connection=False):

        user_name = tools_qt.getWidgetText(dialog, dialog.txt_user, False, False)
        password = tools_qt.getWidgetText(dialog, dialog.txt_pass, False, False)
        settings = QSettings()
        settings.beginGroup("PostgreSQL/connections")
        default_connection = tools_qt.getWidgetText(dialog, dialog.cmb_connection)
        settings.setValue('selected', default_connection)
        if new_connection:
            connection_status, not_version = self.controller.set_database_connection()
        else:
            if default_connection:
                settings.endGroup()
                settings.beginGroup("PostgreSQL/connections/" + default_connection)
            settings.setValue('password', password)
            settings.setValue('username', user_name)
            settings.endGroup()

        self.close_dialog_admin(dialog)
        self.init_sql(True)


    def gis_create_project(self):

        # Get gis folder, gis file, project type and schema
        gis_folder = tools_qt.getWidgetText(self.dlg_create_gis_project, 'txt_gis_folder')
        if gis_folder is None or gis_folder == 'null':
            self.controller.show_warning("GIS folder not set")
            return

        gis_file = tools_qt.getWidgetText(self.dlg_create_gis_project, 'txt_gis_file')
        if gis_file is None or gis_file == 'null':
            self.controller.show_warning("GIS file name not set")
            return

        project_type = tools_qt.getWidgetText(self.dlg_readsql, 'cmb_project_type')
        schema_name = tools_qt.getWidgetText(self.dlg_readsql, 'project_schema_name')

        # Get roletype and export password
        roletype = tools_qt.getWidgetText(self.dlg_create_gis_project, 'cmb_roletype')
        export_passwd = tools_qt.isChecked(self.dlg_create_gis_project, 'chk_export_passwd')
        sample = self.dlg_create_gis_project.chk_is_sample.isChecked()

        if export_passwd:
            msg = "Credentials will be stored in GIS project file"
            self.controller.show_info_box(msg, "Warning")

        # Generate QGIS project
        self.generate_qgis_project(gis_folder, gis_file, project_type, schema_name, export_passwd, roletype, sample)


    def generate_qgis_project(self, gis_folder, gis_file, project_type, schema_name, export_passwd, roletype, sample,
            get_database_parameters=True):
        """ Generate QGIS project """

        gis = GwAdminGisProject(self.controller, self.plugin_dir)
        result, qgs_path = gis.gis_project_database(gis_folder, gis_file, project_type, schema_name, export_passwd,
            roletype, sample, get_database_parameters)

        self.close_dialog_admin(self.dlg_create_gis_project)
        self.close_dialog_admin(self.dlg_readsql)
        if result is True:
            self.open_project(qgs_path)


    def open_project(self, qgs_path):

        project = QgsProject.instance()
        project.read(qgs_path)

        # Load Giswater plugin
        reloadPlugin('giswater')


    def open_form_create_gis_project(self):

        # Check if exist schema
        schema_name = tools_qt.getWidgetText(self.dlg_readsql, 'project_schema_name')
        if schema_name is None:
            msg = "In order to create a qgis project you have to create a schema first ."
            self.controller.show_info_box(msg)
            return

        # Create GIS project dialog
        self.dlg_create_gis_project = MainGisProjectUi()
        load_settings(self.dlg_create_gis_project)

        # Set default values
        schema_name = tools_qt.getWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name)
        tools_qt.setWidgetText(self.dlg_create_gis_project, 'txt_gis_file', schema_name)
        users_home = os.path.expanduser("~")
        tools_qt.setWidgetText(self.dlg_create_gis_project, 'txt_gis_folder', users_home)

        # Manage widgets
        if self.project_issample:
            self.dlg_create_gis_project.lbl_is_sample.setVisible(True)
            self.dlg_create_gis_project.chk_is_sample.setVisible(True)
        else:
            self.dlg_create_gis_project.lbl_is_sample.setVisible(False)
            self.dlg_create_gis_project.chk_is_sample.setVisible(False)

        # Set listeners
        self.dlg_create_gis_project.btn_gis_folder.clicked.connect(
            partial(get_folder_dialog, self.dlg_create_gis_project, "txt_gis_folder"))
        self.dlg_create_gis_project.btn_accept.clicked.connect(partial(self.gis_create_project))
        self.dlg_create_gis_project.btn_close.clicked.connect(partial(self.close_dialog_admin, self.dlg_create_gis_project))
        self.dlg_create_gis_project.chk_is_sample.stateChanged.connect(partial(self.sample_state_changed))

        # Open MainWindow
        open_dialog(self.dlg_create_gis_project, dlg_name='main_gisproject')


    def sample_state_changed(self):

        checked = self.dlg_create_gis_project.chk_is_sample.isChecked()
        self.dlg_create_gis_project.cmb_roletype.setEnabled(not checked)
        tools_qt.setWidgetText(self.dlg_create_gis_project, self.dlg_create_gis_project.cmb_roletype, 'admin')


    def btn_constrains_changed(self, button, call_function=False):

        lbl_constrains_info = self.dlg_readsql.findChild(QLabel, 'lbl_constrains_info')
        schema_name = tools_qt.getWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name)

        if button.text() == 'OFF':
            button.setText("ON")
            lbl_constrains_info.setText('(Constrains enabled)  ')
            if call_function:
                # Enable constrains
                sql = 'SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"ADD"}}$$)'
                self.controller.execute_sql(sql)

        elif button.text() == 'ON':
            button.setText("OFF")
            lbl_constrains_info.setText('(Constrains dissabled)')
            if call_function:
                # Disable constrains
                sql = 'SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"DROP"}}$$)'
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

            cmb_locale = tools_qt.getWidgetText(self.dlg_readsql, self.cmb_locale)
            folder_i18n = self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'i18n'
            if self.process_folder(folder_i18n + os.sep + self.locale + os.sep, '') is False:
                if self.process_folder(folder_i18n + os.sep, 'EN') is False:
                    return False
                else:
                    status = self.executeFiles(folder_i18n + os.sep + 'EN', True)
                    if status is False and self.dev_commit == 'FALSE':
                        return False
            else:
                status = self.executeFiles(folder_i18n + os.sep + cmb_locale + os.sep, True)
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
                                    status = self.load_sql(self.folderUpdates + folder + os.sep +
                                                           sub_folder + os.sep + 'utils' + os.sep, no_ct=no_ct)
                                    if status is False:
                                        return False
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + project_type + os.sep, ''):
                                    status = self.load_sql(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + project_type + os.sep, no_ct=no_ct)
                                    if status is False:
                                        return False
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep), '') is True:
                                    status = self.executeFiles(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep), True)
                                    if status is False:
                                        return False
                                elif self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN'):
                                    status = self.executeFiles(self.folderUpdates + folder +
                                                               os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', True)
                                    if status is False:
                                        return False

                        else:
                            if str(sub_folder) > '31100' and str(sub_folder) <= str(self.plugin_version).replace('.', ''):
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder, os.sep + 'utils' + os.sep):
                                    status = self.load_sql(self.folderUpdates + folder + os.sep +
                                                           sub_folder + os.sep + 'utils' + os.sep, no_ct=no_ct)
                                    if status is False:
                                        return False
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + project_type + os.sep, ''):
                                    status = self.load_sql(self.folderUpdates + folder + os.sep +
                                                           sub_folder + os.sep + project_type + os.sep, no_ct=no_ct)
                                    if status is False:
                                        return False
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep), ''):
                                    status = self.executeFiles(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep), True)
                                    if status is False:
                                        return False
                                elif self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN'):
                                    status = self.executeFiles(self.folderUpdates + folder +
                                                               os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', True)
                                    if status is False:
                                        return False

                    else:
                        if self.read_all_updates == 'TRUE':
                            if str(sub_folder) > str(self.project_version).replace('.', '') and str(sub_folder) > '31100':
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder, os.sep + 'utils' + os.sep) is True:
                                    status = self.load_sql(self.folderUpdates + folder + os.sep +
                                                           sub_folder + os.sep + 'utils' + os.sep)
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
                                        self.folderUpdates + folder + os.sep + sub_folder +
                                    os.sep + 'i18n' + os.sep + str(self.locale + os.sep),
                                        '') is True:
                                    status = self.executeFiles(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                            self.locale + os.sep), True)
                                    if status is False:
                                        return False
                                elif self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is True:
                                    status = self.executeFiles(self.folderUpdates + folder +
                                                               os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', True)
                                    if status is False:
                                        return False

                        else:
                            if str(sub_folder) > str(self.project_version).replace('.', '') and str(sub_folder) > '31100' and str(sub_folder) <= str(self.plugin_version).replace('.', ''):
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder, os.sep + 'utils' + os.sep) is True:
                                    status = self.load_sql(self.folderUpdates + folder + os.sep +
                                                           sub_folder + os.sep + 'utils' + os.sep)
                                    if status is False:
                                        return False
                                if self.process_folder(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + self.project_type_selected + os.sep,
                                        '') is True:
                                    status = self.load_sql(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + self.project_type_selected + os.sep)
                                    if status is False:
                                        return False
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep), '') is True:
                                    status = self.executeFiles(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep), True)
                                    if status is False:
                                        return False
                                elif self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is True:
                                    status = self.executeFiles(self.folderUpdates + folder +
                                                               os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', True)
                                    if status is False:
                                        return False

        else:

            if not os.path.exists(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + ''):
                return
            folders = sorted(os.listdir(self.sql_dir + os.sep + str(project_type) +
                             os.sep + os.sep + 'updates' + os.sep + ''))
            for folder in folders:
                sub_folders = sorted(os.listdir(self.sql_dir + os.sep + str(project_type) +
                                     os.sep + os.sep + 'updates' + os.sep + folder))
                for sub_folder in sub_folders:
                    if new_project:
                        if self.read_all_updates == 'TRUE':
                            if str(sub_folder) > '31100':
                                if self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep), '') is True:
                                    status = self.executeFiles(self.sql_dir + os.sep + str(project_type) + os.sep + 'updates' + os.sep +
                                                               folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep), True)
                                    if status is False:
                                        return False
                                elif self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', '') is True:
                                    status = self.executeFiles(self.sql_dir + os.sep + str(project_type) + os.sep + 'updates' +
                                                               os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', True)
                                    if status is False:
                                        return False

                        else:
                            if str(sub_folder) > '31100' and str(sub_folder) <= str(self.plugin_version).replace('.', ''):
                                if self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder,
                                                       '') is True:
                                    status = self.load_sql(self.sql_dir + os.sep + str(project_type) +
                                                           os.sep + 'updates' + os.sep + folder + os.sep + sub_folder)
                                    if status is False:
                                        return False
                                if self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep), '') is True:
                                    status = self.executeFiles(self.sql_dir + os.sep + str(
                                        project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep), True)
                                elif self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is True:
                                    status = self.executeFiles(
                                        self.sql_dir + os.sep + str(project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'EN', True)
                                    if status is False:
                                        return False

                    else:
                        if self.read_all_updates == 'TRUE':
                            if str(sub_folder) > str(self.project_version).replace('.', '') and str(sub_folder) > '31100':
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder, os.sep + 'utils' + os.sep) is True:
                                    status = self.load_sql(self.folderUpdates + folder + os.sep +
                                                           sub_folder + os.sep + 'utils' + os.sep)
                                    if status is False:
                                        return False
                                if self.process_folder(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + self.project_type + os.sep,
                                        '') is True:
                                    status = self.load_sql(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + self.project_type + os.sep)
                                    if status is False:
                                        return False
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep), '') is True:
                                    status = self.executeFiles(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                            self.locale + os.sep), True)
                                    if status is False:
                                        return False
                                elif self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is True:
                                    status = self.executeFiles(self.folderUpdates + folder +
                                                               os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', True)
                                    if status is False:
                                        return False

                        else:
                            if str(sub_folder) > str(self.project_version).replace('.', '') and str(sub_folder) > '31100' and str(sub_folder) <= str(self.plugin_version).replace('.', ''):
                                if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder, os.sep + 'utils' + os.sep) is True:
                                    status = self.load_sql(self.folderUpdates + folder + os.sep +
                                                           sub_folder + os.sep + 'utils' + os.sep)
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
                                        self.folderUpdates + folder + os.sep + sub_folder +
                                    os.sep + 'i18n' + os.sep + str(self.locale + os.sep),
                                        '') is True:
                                    status = self.executeFiles(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                            self.locale + os.sep), True)
                                    if status is False:
                                        return False
                                elif self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is True:
                                    status = self.executeFiles(self.folderUpdates + folder +
                                                               os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', True)
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
                                status = self.load_sql(self.folderUpdates + folder + os.sep +
                                                       sub_folder + os.sep + 'utils' + os.sep)
                                if status is False:
                                    return False
                            if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + project_type + os.sep, '') is True:
                                status = self.load_sql(self.folderUpdates + folder + os.sep +
                                                       sub_folder + os.sep + project_type + os.sep)
                                if status is False:
                                    return False
                            if self.process_folder(
                                    self.folderUpdates + folder + os.sep + sub_folder +
                                os.sep + 'i18n' + os.sep + str(self.locale + os.sep),
                                    '') is True:
                                status = self.executeFiles(
                                    self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep), True)
                                if status is False:
                                    return False
                            elif self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is False:
                                status = self.executeFiles(self.folderUpdates + folder +
                                                           os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', True)
                                if status is False:
                                    return False
                    else:
                        if str(sub_folder) > str(self.project_version).replace('.', '') and str(sub_folder) <= '31100':
                            if self.process_folder(self.folderUpdates + folder + os.sep + sub_folder, os.sep + 'utils' + os.sep) is True:
                                status = self.load_sql(self.folderUpdates + folder + os.sep +
                                                       sub_folder + os.sep + 'utils' + os.sep)
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
                                    self.folderUpdates + folder + os.sep + sub_folder +
                                os.sep + 'i18n' + os.sep + str(self.locale + os.sep),
                                    '') is True:
                                status = self.executeFiles(
                                    self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep), True)
                                if status is False:
                                    return False
                            elif self.process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', '') is True:
                                status = self.executeFiles(self.folderUpdates + folder +
                                                           os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN', True)
                                if status is False:
                                    return False

        else:

            if not os.path.exists(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + ''):
                return True

            folders = sorted(os.listdir(self.sql_dir + os.sep + str(project_type) +
                             os.sep + os.sep + 'updates' + os.sep + ''))
            for folder in folders:
                sub_folders = sorted(os.listdir(self.sql_dir + os.sep + str(project_type) +
                                     os.sep + os.sep + 'updates' + os.sep + folder))
                for sub_folder in sub_folders:
                    if new_project:
                        if str(sub_folder) <= '31100':
                            if self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder, '') is True:
                                status = self.load_sql(self.sql_dir + os.sep + str(project_type) + os.sep +
                                                       os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + '')
                                if status is False:
                                    return False
                            if self.process_folder(
                                    self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep +
                                folder + os.sep + sub_folder + os.sep +
                                'i18n' + os.sep + str(self.locale + os.sep),
                                    '') is True:
                                status = self.executeFiles(self.sql_dir + os.sep + str(
                                    project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                    self.locale + os.sep), True)
                                if status is False:
                                    return False
                            elif self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is True:
                                status = self.executeFiles(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' +
                                                           os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN' + os.sep, True)
                                if status is False:
                                    return False

                    else:
                        if str(sub_folder) > str(self.project_version).replace('.', '') and str(sub_folder) <= '31100':
                            if self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder, '') is True:
                                status = self.load_sql(self.sql_dir + os.sep + str(project_type) + os.sep +
                                                       os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + '')
                                if status is False:
                                    return False
                            if self.process_folder(
                                    self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep +
                                folder + os.sep + sub_folder + os.sep +
                                'i18n' + os.sep + str(self.locale + os.sep),
                                    '') is True:
                                status = self.executeFiles(self.sql_dir + os.sep + str(
                                    project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                    self.locale + os.sep), True)
                                if status is False:
                                    return False
                            elif self.process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is True:
                                status = self.executeFiles(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' +
                                                           os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN' + os.sep, True)
                                if status is False:
                                    return False

        return True


    def load_sample_data(self, project_type=False):

        sql = f"UPDATE {self.schema}.sys_version SET sample = True"
        self.controller.execute_sql(sql, commit=False)

        if str(project_type) == 'ws' or str(project_type) == 'ud':
            folder = self.folderExemple + 'user' + os.sep + project_type
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
            self.controller.log_info(f"Folder not found: {self.folderUpdatesApi}")
            return True

        if project_type is False:
            project_type = tools_qt.getWidgetText(self.dlg_readsql, self.dlg_readsql.cmb_project_type)

        folders = sorted(os.listdir(self.folderUpdatesApi + ''))
        self.controller.log_info(str(folders))
        for folder in folders:
            sub_folders = sorted(os.listdir(self.folderUpdatesApi + folder))
            for sub_folder in sub_folders:
                if new_api:
                    if self.read_all_updates == 'TRUE':
                        if self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep, '') is True:
                            status = self.executeFiles(self.folderUpdatesApi + folder +
                                                       os.sep + sub_folder + os.sep + 'utils' + os.sep + '')
                            if status is False:
                                return False
                        if self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + project_type + os.sep, '') is True:
                            status = self.executeFiles(self.folderUpdatesApi + folder +
                                                       os.sep + sub_folder + os.sep + project_type + os.sep + '')
                            if status is False:
                                return False
                        if self.process_folder(
                                self.folderUpdatesApi + folder + os.sep + sub_folder +
                            os.sep + 'i18n' + os.sep + str(self.locale + os.sep),
                                '') is True:
                            status = self.executeFiles(
                                self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                    self.locale + os.sep), True)
                            if status is False:
                                return False
                        elif self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is True:
                            status = self.executeFiles(self.folderUpdatesApi + folder + os.sep +
                                                       sub_folder + os.sep + 'i18n' + os.sep + 'EN' + os.sep, True)
                            if status is False:
                                return False
                        if self.process_folder(self.sql_dir + os.sep + 'api' + os.sep, self.file_pattern_trg) is True:
                            status = self.executeFiles(self.sql_dir + os.sep + 'api' + os.sep + self.file_pattern_trg)
                            if status is False:
                                return False
                        if self.process_folder(self.sql_dir + os.sep + 'api' + os.sep, self.file_pattern_tablect) is True:
                            status = self.executeFiles(self.sql_dir + os.sep + 'api' +
                                                       os.sep + self.file_pattern_tablect)
                            if status is False:
                                return False
                    else:
                        if str(sub_folder) <= str(self.plugin_version).replace('.', ''):
                            if self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep,
                                                   '') is True:
                                status = self.executeFiles(self.folderUpdatesApi + folder +
                                                           os.sep + sub_folder + os.sep + 'utils' + os.sep + '')
                                if status is False:
                                    return False
                            if self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + project_type + os.sep,
                                                   '') is True:
                                status = self.executeFiles(self.folderUpdatesApi + folder +
                                                           os.sep + sub_folder + os.sep + project_type + os.sep + '')
                                if status is False:
                                    return False
                            if self.process_folder(
                                    self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep),
                                    '') is True:
                                status = self.executeFiles(
                                    self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep), True)
                                if status is False:
                                    return False
                            elif self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep,
                                                   'EN') is True:
                                status = self.executeFiles(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN' + os.sep,
                                    True)
                                if status is False:
                                    return False
                            if self.process_folder(self.sql_dir + os.sep + 'api' + os.sep, self.file_pattern_trg) is True:
                                status = self.executeFiles(self.sql_dir + os.sep + 'api' +
                                                           os.sep + self.file_pattern_trg)
                                if status is False:
                                    return False
                            if self.process_folder(self.sql_dir + os.sep + 'api' + os.sep, self.file_pattern_tablect) is True:
                                status = self.executeFiles(self.sql_dir + os.sep + 'api' +
                                                           os.sep + self.file_pattern_tablect)
                                if status is False:
                                    return False

                else:
                    if self.read_all_updates == 'TRUE':
                        if str(sub_folder) > str(self.project_version).replace('.', ''):
                            if self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep, '') is True:
                                status = self.executeFiles(self.folderUpdatesApi + folder +
                                                           os.sep + sub_folder + os.sep + 'utils' + os.sep + '')
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
                                    self.folderUpdatesApi + folder + os.sep + sub_folder +
                                os.sep + 'i18n' + os.sep + str(self.locale + os.sep),
                                    '') is True:
                                status = self.executeFiles(
                                    self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep), True)
                                if status is False:
                                    return False
                            elif self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep, 'EN') is True:
                                status = self.executeFiles(self.folderUpdatesApi + folder + os.sep +
                                                           sub_folder + os.sep + 'i18n' + os.sep + 'EN' + os.sep, True)
                                if status is False:
                                    return False
                            if self.process_folder(self.sql_dir + os.sep + 'api' + os.sep, self.file_pattern_trg) is True:
                                status = self.executeFiles(self.sql_dir + os.sep + 'api' +
                                                           os.sep + self.file_pattern_trg)
                                if status is False:
                                    return False
                            if self.process_folder(self.sql_dir + os.sep + 'api' + os.sep, self.file_pattern_tablect) is True:
                                status = self.executeFiles(self.sql_dir + os.sep + 'api' +
                                                           os.sep + self.file_pattern_tablect)
                                if status is False:
                                    return False
                    else:
                        if str(sub_folder) > str(self.project_version).replace('.', '') and str(sub_folder) <= str(self.plugin_version).replace('.', ''):
                            if self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'utils' + os.sep,
                                                   '') is True:
                                status = self.executeFiles(self.folderUpdatesApi + folder +
                                                           os.sep + sub_folder + os.sep + 'utils' + os.sep + '')
                                if status is False:
                                    return False
                            if self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + project_type + os.sep,
                                                   '') is True:
                                status = self.executeFiles(self.folderUpdatesApi + folder +
                                                           os.sep + sub_folder + os.sep + project_type + os.sep + '')
                                if status is False:
                                    return False
                            if self.process_folder(
                                    self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep),
                                    '') is True:
                                status = self.executeFiles(
                                    self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep), True)
                                if status is False:
                                    return False
                            elif self.process_folder(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep,
                                                   'EN') is True:
                                status = self.executeFiles(self.folderUpdatesApi + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + 'EN' + os.sep,
                                    True)
                                if status is False:
                                    return False
                            if self.process_folder(self.sql_dir + os.sep + 'api' + os.sep, self.file_pattern_trg) is True:
                                status = self.executeFiles(self.sql_dir + os.sep + 'api' +
                                                           os.sep + self.file_pattern_trg)
                                if status is False:
                                    return False
                            if self.process_folder(self.sql_dir + os.sep + 'api' + os.sep, self.file_pattern_tablect) is True:
                                status = self.executeFiles(self.sql_dir + os.sep + 'api' +
                                                           os.sep + self.file_pattern_tablect)
                                if status is False:
                                    return False

        return True


    """ Functions execute process """

    def execute_import_data(self, schema_type=''):

        # Create dialog
        self.dlg_import_inp = MainImportUi()
        load_settings(self.dlg_import_inp)

        # Hide widgets
        self.dlg_import_inp.grb_input_layer.setVisible(False)
        self.dlg_import_inp.grb_selection_type.setVisible(False)

        self.dlg_import_inp.progressBar.setVisible(False)

        if schema_type.lower() == 'ws':
            extras = '"function":2522'
        elif schema_type.lower() == 'ud':
            extras = '"function":2524'
        else:
            self.error_count = self.error_count + 1
            return

        extras += ', "isToolbox":false'
        body = create_body(extras=extras)
        complet_result = self.controller.get_json('gw_fct_gettoolbox', body, schema_name=self.schema, commit=False)
        if not complet_result or complet_result['status'] == 'Failed':
            return False
        self.populate_functions_dlg(self.dlg_import_inp, complet_result['body']['data'])

        # Set listeners
        self.dlg_import_inp.btn_run.clicked.connect(
            partial(self.execute_import_inp, accepted=True, schema_type=schema_type))
        self.dlg_import_inp.btn_close.clicked.connect(partial(self.execute_import_inp, accepted=False))

        # Open dialog
        open_dialog(self.dlg_import_inp, dlg_name='main_importinp')


    def execute_last_process(self, new_project=False, schema_name='', schema_type='', locale=False, srid=None):
        """ Execute last process function """

        if new_project is True:
            extras = '"isNewProject":"' + str('TRUE') + '", '
            extras += '"isSample":"' + str(self.project_issample) + '", '
        else:
            extras = '"isNewProject":"' + str('FALSE') + '", '
        extras += '"gwVersion":"' + str(self.plugin_version) + '", '
        extras += '"projectType":"' + str(schema_type).upper() + '", '
        if srid is None:
            srid = self.project_epsg
        extras += '"epsg":' + str(srid).replace('"', '')
        if new_project is True:
            if str(self.descript) != 'null':
                extras += ', ' + '"descript":"' + str(self.descript) + '"'
            extras += ', ' + '"name":"' + str(schema_name) + '"'
            extras += ', ' + '"author":"' + str(self.username) + '"'
            current_date = QDate.currentDate().toString('dd-MM-yyyy')
            extras += ', ' + '"date":"' + str(current_date) + '"'

        extras += ', "superUsers":' + str(self.super_users).replace("'", '"') + ''

        self.schema_name = schema_name

        # Get current locale
        if not locale:
            locale = tools_qt.getWidgetText(self.dlg_readsql_create_project,
                                            self.dlg_readsql_create_project.cmb_locale)

        client = '"client":{"device":4, "lang":"' + str(locale) + '"}, '
        data = '"data":{' + extras + '}'
        body = "$${" + client + data + "}$$"
        result = self.controller.get_json('gw_fct_admin_schema_lastprocess', body,
                                          schema_name=self.schema_name, commit=False, log_sql=True)
        if result is None or ('status' in result and result['status'] == 'Failed'):
            self.error_count = self.error_count + 1

        return result


    def task_started(self, task, wait_time):
        """ Dumb test function.
        to break the task raise an exception
        to return a successful result return it.
        This will be passed together with the exception (None in case of success) to the on_finished method
        """

        self.controller.log_info("Started task '{}'".format(task.description()))

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

        # return True
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
        task1 = QgsTask.fromFunction('task_example', self.task_started, on_finished=self.task_completed, wait_time=20)
        QgsApplication.taskManager().addTask(task1)


    def check_project_name(self, project_name, project_descript):
        """ Check if @project_name and @project_descript are is valid """

        # Check if project name is valid
        if project_name == 'null':
            msg = "The 'Project_name' field is required."
            self.controller.show_info_box(msg, "Info")
            return False
        elif any(c.isupper() for c in project_name) is True:
            msg = "The 'Project_name' field require only lower caracters"
            self.controller.show_info_box(msg, "Info")
            return False
        elif (bool(re.match('^[a-z0-9_]*$', project_name))) is False:
            msg = "The 'Project_name' field have invalid character"
            self.controller.show_info_box(msg, "Info")
            return False
        if project_descript == 'null':
            msg = "The 'Description' field is required."
            self.controller.show_info_box(msg, "Info")
            return False

        # Check is project name already exists
        sql = "SELECT schema_name, schema_name FROM information_schema.schemata"
        rows = self.controller.get_rows(sql, commit=False)
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
                                    project_name) + "_bk_" + str(i + 1) + "' ?"
                                result = self.controller.ask_question(msg, "Info")
                                i = i + 1
                            else:
                                available = True
                    self.rename_project_data_schema(str(project_name), str(project_name) + "_bk_" + str(i))
                else:
                    return False

        return True


    def create_project_data_schema(self, project_name_schema=None, project_descript=None, project_type=None,
            project_srid=None, project_locale=None, is_test=False, exec_last_process=True, example_data=True):

        # Get project parameters
        if project_name_schema is None or not project_name_schema:
            project_name_schema = tools_qt.getWidgetText(self.dlg_readsql_create_project, 'project_name')
        if project_descript is None or not project_descript:
            project_descript = tools_qt.getWidgetText(self.dlg_readsql_create_project, 'project_descript')
        if project_type is None:
            project_type = tools_qt.getWidgetText(self.dlg_readsql_create_project, 'cmb_create_project_type')
        if project_srid is None:
            project_srid = tools_qt.getWidgetText(self.dlg_readsql_create_project, 'srid_id')
        if project_locale is None:
            project_locale = tools_qt.getWidgetText(self.dlg_readsql_create_project, 'cmb_locale')

        # Set class variables
        self.schema = project_name_schema
        self.descript = project_descript
        self.schema_type = project_type
        self.project_epsg = project_srid
        self.locale = project_locale
        self.project_issample = example_data

        # Save in settings
        set_parser_value('admin', 'project_name_schema', f'{project_name_schema}')
        set_parser_value('admin', 'project_descript', f'{project_descript}')
        inp_file_path = tools_qt.getWidgetText(self.dlg_readsql_create_project, 'data_file')
        set_parser_value('admin', 'inp_file_path', f'{inp_file_path}')

        # Check if project name is valid
        if not self.check_project_name(project_name_schema, project_descript):
            return

        self.controller.log_info(f"Create schema of type '{project_type}': '{project_name_schema}'")

        if not is_test:
            self.task1 = GwTask('Manage schema')
            QgsApplication.taskManager().addTask(self.task1)
            self.task1.setProgress(0)

        if self.rdb_import_data.isChecked():
            self.file_inp = tools_qt.getWidgetText(self.dlg_readsql_create_project, 'data_file')
            if self.file_inp is 'null':
                msg = "The 'Path' field is required for Import INP data."
                self.controller.show_info_box(msg, "Info")
                return

        elif self.rdb_sample.isChecked() or self.rdb_sample_dev.isChecked():
            if self.locale != 'EN' or self.project_epsg != '25831':
                msg = ("This functionality is only allowed with the locality 'EN' and SRID 25831."
                       "\nDo you want change it and continue?")
                result = self.controller.ask_question(msg, "Info Message")
                if result:
                    self.project_epsg = '25831'
                    self.locale = 'EN'
                    tools_qt.setWidgetText(self.dlg_readsql_create_project, 'srid_id', self.project_epsg)
                    tools_qt.setWidgetText(self.dlg_readsql_create_project, 'cmb_locale', self.locale)
                else:
                    return

        # Common execution
        status = self.load_base(project_type=project_type)
        if not status and self.dev_commit == 'FALSE':
            self.manage_process_result(is_test=is_test)
            return

        if not is_test:
            self.task1.setProgress(10)
        status = self.update_30to31(new_project=True, project_type=project_type)
        if not status and self.dev_commit == 'FALSE':
            self.manage_process_result(is_test=is_test)
            return
        if not is_test:
            self.task1.setProgress(20)
        status = self.load_views(project_type=project_type)
        if not status and self.dev_commit == 'FALSE':
            self.manage_process_result(is_test=is_test)
            return
        if not is_test:
            self.task1.setProgress(30)
        status = self.load_trg(project_type=project_type)
        if not status and self.dev_commit == 'FALSE':
            self.manage_process_result(is_test=is_test)
            return
        if not is_test:
            self.task1.setProgress(40)
        status = self.update_31to39(new_project=True, project_type=project_type)
        if not status and self.dev_commit == 'FALSE':
            self.manage_process_result(is_test=is_test)
            return
        if not is_test:
            self.task1.setProgress(50)
        status = self.api(new_api=True, project_type=project_type)
        if not status and self.dev_commit == 'FALSE':
            self.manage_process_result(is_test=is_test)
            return
        if not is_test:
            self.task1.setProgress(60)

        status = True
        if exec_last_process:
            status = self.execute_last_process(new_project=True, schema_name=project_name_schema,
                schema_type=self.schema_type, locale=project_locale, srid=project_srid)

        if not status and self.dev_commit == 'FALSE':
            self.manage_process_result(is_test=is_test)
            return

        # Custom execution
        if self.rdb_import_data.isChecked():
            # TODO:
            if not is_test:
                self.task1.setProgress(100)
            set_parser_value('admin', 'create_schema_type', 'rdb_import_data')
            msg = ("The sql files have been correctly executed."
                   "\nNow, a form will be opened to manage the import inp.")
            self.controller.show_info_box(msg, "Info")
            self.execute_import_data(schema_type=project_type)
            return
        elif self.rdb_sample.isChecked() and example_data:
            set_parser_value('admin', 'create_schema_type', 'rdb_sample')
            self.load_sample_data(project_type=project_type)
            if not is_test:
                self.task1.setProgress(80)
        elif self.rdb_sample_dev.isChecked():
            set_parser_value('admin', 'create_schema_type', 'rdb_sample_dev')
            self.load_sample_data(project_type=project_type)
            self.load_dev_data(project_type=project_type)
            if not is_test:
                self.task1.setProgress(80)
        elif self.rdb_data.isChecked():
            set_parser_value('admin', 'create_schema_type', 'rdb_data')

        self.manage_process_result(project_name_schema, is_test)

        # Update composer path on config_param_user
        self.manage_user_params()


    def manage_process_result(self, schema_name=None, is_test=False):

        if not is_test:
            self.task1.setProgress(100)
        status = (self.error_count == 0)
        self.manage_result_message(status, parameter="Create project")
        if status:
            self.controller.dao.commit()
            self.close_dialog_admin(self.dlg_readsql_create_project)
            if not is_test:
                self.populate_data_schema_name(self.cmb_project_type)
                if schema_name is not None:
                    tools_qt.setWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name, schema_name)
                    self.set_info_project()
        else:
            self.controller.dao.rollback()
            # Reset count error variable to 0
            self.error_count = 0


    def rename_project_data_schema(self, schema, create_project=None):

        if create_project is None or create_project is False:
            close_dlg_rename = True
            self.schema = tools_qt.getWidgetText(self.dlg_readsql_rename, self.dlg_readsql_rename.schema_rename_copy)
            if str(self.schema) == str(schema):
                msg = "Please, select a diferent project name than current."
                self.controller.show_info_box(msg, "Info")
                return
        else:
            close_dlg_rename = False
            self.schema = str(create_project)

        sql = "SELECT schema_name, schema_name FROM information_schema.schemata"
        rows = self.controller.get_rows(sql)
        for row in rows:
            if str(self.schema) == str(row[0]):
                msg = "This project name alredy exist."
                self.controller.show_info_box(msg, "Info")
                return
            else:
                continue

        self.task1 = GwTask('Manage schema')
        QgsApplication.taskManager().addTask(self.task1)
        self.task1.setProgress(0)
        sql = f'ALTER SCHEMA {schema} RENAME TO {self.schema}'
        status = self.controller.execute_sql(sql, commit=False)
        if status:
            self.reload_fct_ftrg(project_type=self.project_type_selected)
            self.task1.setProgress(20)
            self.reload_fct_ftrg(project_type='api')
            self.task1.setProgress(40)
            self.api(False)
            self.task1.setProgress(60)
            sql = ('SELECT ' + str(self.schema) + '.gw_fct_admin_rename_fixviews($${"data":{"currentSchemaName":"'
                   + self.schema + '","oldSchemaName":"' + str(schema) + '"}}$$)::text')
            self.controller.execute_sql(sql, commit=False)
            self.execute_last_process(schema_name=self.schema, locale=True)
        self.task1.setProgress(100)

        # Show message
        status = (self.error_count == 0)
        self.manage_result_message(status, parameter="Rename project")
        if status:
            self.controller.dao.commit()
            self.event_change_connection()
            tools_qt.setWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name, str(self.schema))
            if close_dlg_rename:
                self.close_dialog_admin(self.dlg_readsql_rename)
        else:
            self.controller.dao.rollback()

        # Reset count error variable to 0
        self.error_count = 0


    def load_custom_sql_files(self, dialog, widget):

        folder_path = tools_qt.getWidgetText(dialog, widget)
        self.task1 = GwTask('Manage schema')
        QgsApplication.taskManager().addTask(self.task1)
        self.task1.setProgress(50)
        self.load_sql(folder_path)
        self.task1.setProgress(100)

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
            self.task1 = GwTask('Manage schema')
            QgsApplication.taskManager().addTask(self.task1)
            self.task1.setProgress(50)
            self.task1 = GwTask('Manage schema')
            QgsApplication.taskManager().addTask(self.task1)
            status = self.load_updates(project_type, update_changelog=True)
            if status:
                self.set_info_project()
            self.task1.setProgress(100)
        else:
            return

        status = (self.error_count == 0)
        self.manage_result_message(status, parameter="Update project")
        if status:
            self.controller.dao.commit()
            self.close_dialog_admin(self.dlg_readsql_show_info)
        else:
            self.controller.dao.rollback()

        # Reset count error variable to 0
        self.error_count = 0


    """ Checkbox calling functions """


    def load_updates(self, project_type=None, update_changelog=False, schema_name=None):

        # Get current schema selected
        if schema_name is None:
            schema_name = self.get_schema_name()

        self.schema = schema_name
        self.locale = self.project_language

        self.task1 = GwTask('Manage schema')
        QgsApplication.taskManager().addTask(self.task1)
        self.task1.setProgress(0)
        status = self.load_fct_ftrg(project_type=project_type)
        self.task1.setProgress(20)
        if status:
            status = self.update_30to31(project_type=project_type)
        self.task1.setProgress(40)
        if status:
            status = self.update_31to39(project_type=project_type)
        self.task1.setProgress(60)
        if status:
            status = self.api(project_type=project_type)
        self.task1.setProgress(80)
        if status:
            status = self.execute_last_process(schema_name=schema_name, locale=True)
        self.task1.setProgress(100)

        if update_changelog is False:
            status = (self.error_count == 0)
            self.manage_result_message(status, parameter="Load updates")
            if status:
                self.controller.dao.commit()
            else:
                self.controller.dao.rollback()

            # Reset count error variable to 0
            self.error_count = 0

        return status


    def get_schema_name(self):

        schema_name = tools_qt.getWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name)
        return schema_name


    def reload_tablect(self, project_type=False):
        self.load_tablect(project_type=project_type)


    def reload_fct_ftrg(self, project_type=False):
        self.load_fct_ftrg(project_type=project_type)


    def reload_trg(self, project_type=False):
        self.load_trg(project_type)


    """ Create new connection when change combo connections """

    def event_change_connection(self):

        connection_name = str(tools_qt.getWidgetText(self.dlg_readsql, self.cmb_connection))

        credentials = {'db': None, 'host': None, 'port': None, 'user': None, 'password': None, 'sslmode': None}

        # Get sslmode for database connection
        sslmode = 'prefer'

        settings = QSettings()
        settings.beginGroup("PostgreSQL/connections/" + connection_name)
        if settings.value('host') in (None, ""):
            credentials['host'] = 'localhost'
        else:
            credentials['host'] = settings.value('host')
        credentials['port'] = settings.value('port')
        credentials['db'] = settings.value('database')
        credentials['user'] = settings.value('username')
        credentials['password'] = settings.value('password')
        credentials['sslmode'] = sslmode
        settings.endGroup()

        self.logged = self.controller.connect_to_database(credentials['host'], credentials['port'],
            credentials['db'], credentials['user'], credentials['password'], credentials['sslmode'])

        if not self.logged:
            self.close_dialog_admin(self.dlg_readsql)
            self.create_credentials_form(set_connection=connection_name)
        else:
            if str(self.plugin_version) > str(self.project_version):
                self.dlg_readsql.lbl_status.setPixmap(self.status_no_update)
                tools_qt.setWidgetText(self.dlg_readsql, self.dlg_readsql.lbl_status_text,
                '(Schema version is lower than plugin version, please update schema)')
                self.dlg_readsql.btn_info.setEnabled(True)
            elif str(self.plugin_version) < str(self.project_version):
                self.dlg_readsql.lbl_status.setPixmap(self.status_no_update)
                tools_qt.setWidgetText(self.dlg_readsql, self.dlg_readsql.lbl_status_text,
                '(Schema version is higher than plugin version, please update plugin)')
                self.dlg_readsql.btn_info.setEnabled(True)
            else:
                self.dlg_readsql.lbl_status.setPixmap(self.status_ok)
                tools_qt.setWidgetText(self.dlg_readsql, self.dlg_readsql.lbl_status_text, '')
                self.dlg_readsql.btn_info.setEnabled(False)
            tools_qt.dis_enable_dialog(self.dlg_readsql, True)

            self.populate_data_schema_name(self.cmb_project_type)
            self.set_last_connection(connection_name)

        if self.logged:
            self.username = self.get_user_connection(self.get_last_connection())
            role_admin = self.controller.check_role_user("role_admin", self.username)
            if not role_admin and self.username not in self.super_users:
                tools_qt.dis_enable_dialog(self.dlg_readsql, False, 'cmb_connection')
                self.dlg_readsql.lbl_status.setPixmap(self.status_ko)
                tools_qt.setWidgetText(self.dlg_readsql, 'lbl_status_text',
                    "You don't have permissions to administrate project schemas on this connection")
                tools_qt.setWidgetText(self.dlg_readsql, 'lbl_schema_name', '')


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

    def visit_manager(self):
        # TODO:: Remove tab visitclas. WIP
        tools_qt.remove_tab_by_tabName(self.dlg_readsql.tab_main, "visitclass")
        return
        # Populate visit class
        # TODO:: Populate combo from visitclass manager and wip
        # sql = ("SELECT id, idval FROM config_visit_class")
        # rows = self.controller.get_rows(sql, commit=True)
        # qt_tools.set_item_data(self.dlg_readsql.cmb_visit_class, rows, 1)

        # Set listeners
        self.dlg_readsql.btn_visit_create.clicked.connect(partial(self.create_visit_param))
        self.dlg_readsql.btn_visit_update.clicked.connect(partial(self.update_visit))
        self.dlg_readsql.btn_visit_delete.clicked.connect(partial(self.delete_visit))


    def create_visit_class(self):

        # Create the dialog and signals
        self.dlg_manage_visit_class = MainVisitClass()
        load_settings(self.dlg_manage_visit_class)

        # Manage widgets
        sql = "SELECT id, id as idval FROM sys_feature_type WHERE classlevel = 1 OR classlevel = 2"
        rows = self.controller.get_rows(sql, commit=True)
        tools_qt.set_item_data(self.dlg_manage_visit_class.feature_type, rows, 1)

        sql = "SELECT id, idval FROM om_typevalue WHERE typevalue ='visit_type'"
        rows = self.controller.get_rows(sql)
        tools_qt.set_item_data(self.dlg_manage_visit_class.visit_type, rows, 1)

        # Set listeners

        # Open dialog
        open_dialog(self.dlg_manage_visit_class, dlg_name='main_visitclass')
        return


    def create_visit_param(self):
        return
        # Create the dialog and signals
        self.dlg_manage_visit_param = MainVisitParam()
        load_settings(self.dlg_manage_visit_param)

        # Manage widgets
        sql = "SELECT id, id as idval FROM om_visit_parameter_type"
        rows = self.controller.get_rows(sql, commit=True)
        tools_qt.set_item_data(self.dlg_manage_visit_param.parameter_type, rows, 1)

        sql = "SELECT id, idval FROM config_typevalue WHERE typevalue = 'datatype'"
        rows = self.controller.get_rows(sql, commit=True)
        tools_qt.set_item_data(self.dlg_manage_visit_param.data_type, rows, 1)

        sql = "SELECT id, idval FROM om_typevalue WHERE typevalue = 'visit_form_type'"
        rows = self.controller.get_rows(sql, commit=True)
        tools_qt.set_item_data(self.dlg_manage_visit_param.form_type, rows, 1)

        sql = "SELECT id, idval FROM config_typevalue WHERE typevalue = 'widgettype'"
        rows = self.controller.get_rows(sql, commit=True)
        tools_qt.set_item_data(self.dlg_manage_visit_param.widget_type, rows, 1)

        # Set listeners

        # Open dialog
        open_dialog(self.dlg_manage_visit_param, dlg_name='main_visitparam')
        return


    def update_visit(self):

        return


    def delete_visit(self):

        return

    def show_info(self):

        # Create dialog
        self.dlg_readsql_show_info = MainProjectInfoUi()
        load_settings(self.dlg_readsql_show_info)

        info_updates = self.dlg_readsql_show_info.findChild(QTextEdit, 'info_updates')
        self.message_update = ''

        self.read_info_version()

        info_updates.setText(self.message_update)

        if str(self.message_update) == '':
            self.dlg_readsql_show_info.btn_update.setEnabled(False)

        # Set listeners
        self.dlg_readsql_show_info.btn_close.clicked.connect(partial(self.close_dialog_admin, self.dlg_readsql_show_info))
        self.dlg_readsql_show_info.btn_update.clicked.connect(partial(self.update, self.project_type_selected))

        # Open dialog
        open_dialog(self.dlg_readsql_show_info, dlg_name='main_projectinfo')


    def read_info_version(self):

        if not os.path.exists(self.folderUpdates):
            self.controller.show_message("The updates folder was not found in sql folder.", 1)
            return

        folders = sorted(os.listdir(self.folderUpdates + ''))
        for folder in folders:
            sub_folders = sorted(os.listdir(self.folderUpdates + folder))
            for sub_folder in sub_folders:
                if str(sub_folder) > str(self.project_version).replace('.', ''):
                    folder_aux = self.folderUpdates + folder + os.sep + sub_folder
                    if self.process_folder(folder_aux, ''):
                        status = self.readFiles(sorted(os.listdir(folder_aux + '')), folder_aux + '')
                        if status is False:
                            continue
                else:
                    continue

        return True


    def close_dialog_admin(self, dlg):
        """ Close dialog """
        close_dialog(dlg)
        self.schema = None


    def update_locale(self):

        # TODO: Check this!
        cmb_locale = tools_qt.getWidgetText(self.dlg_readsql, self.cmb_locale)
        self.folderLocale = self.sql_dir + os.sep + 'i18n' + os.sep + cmb_locale + os.sep


    def enable_datafile(self):

        if self.rdb_import_data.isChecked() is True:
            self.data_file.setEnabled(True)
            self.btn_push_file.setEnabled(True)
        else:
            self.data_file.setEnabled(False)
            self.btn_push_file.setEnabled(False)


    def populate_data_schema_name(self, widget):

        # Get filter
        filter_ = tools_qt.getWidgetText(self.dlg_readsql, widget)
        if filter_ in (None, 'null') and self.schema_type:
            filter_ = self.schema_type
        if filter_ is None:
            return

        # Populate Project data schema Name
        sql = "SELECT schema_name FROM information_schema.schemata"
        rows = self.controller.get_rows(sql)
        if rows is None:
            return

        result_list = []
        for row in rows:
            # projects below 3.4
            sql = (f"SELECT EXISTS (SELECT * FROM information_schema.tables "
                   f"WHERE table_schema = '{row[0]}' "
                   f"AND table_name = 'version')")
            exists = self.controller.get_row(sql)
            if exists and str(exists[0]) == 'True':
                sql = f"SELECT wsoftware FROM {row[0]}.version"
                result = self.controller.get_row(sql)
                if result is not None and result[0] == filter_.upper():
                    elem = [row[0], row[0]]
                    result_list.append(elem)
            # projects upper 3.3
            sql = (f"SELECT EXISTS (SELECT * FROM information_schema.tables "
                   f"WHERE table_schema = '{row[0]}' "
                   f"AND table_name = 'sys_version')")
            exists = self.controller.get_row(sql)
            if exists and str(exists[0]) == 'True':
                sql = f"SELECT project_type FROM {row[0]}.sys_version"
                result = self.controller.get_row(sql)
                if result is not None and result[0] == filter_.upper():
                    elem = [row[0], row[0]]
                    result_list.append(elem)
        if not result_list:
            self.dlg_readsql.project_schema_name.clear()
            return

        tools_qt.set_item_data(self.dlg_readsql.project_schema_name, result_list, 1)

    def manage_srid(self):
        """ Manage SRID configuration """

        self.filter_srid = self.dlg_readsql_create_project.findChild(QLineEdit, 'srid_id')
        tools_qt.setWidgetText(self.dlg_readsql_create_project, self.filter_srid, '25831')
        self.tbl_srid = self.dlg_readsql_create_project.findChild(QTableView, 'tbl_srid')
        self.tbl_srid.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.model_srid = QSqlQueryModel()
        self.tbl_srid.setModel(self.model_srid)


    def filter_srid_changed(self):

        filter_value = tools_qt.getWidgetText(self.dlg_readsql_create_project, self.filter_srid)
        if filter_value is 'null':
            filter_value = ''
        sql = ("SELECT substr(srtext, 1, 6) as " + '"Type"' + ", srid as " + '"SRID"' + ", "
               "substr(split_part(srtext, ',', 1), 9) as " + '"Description"' + " "
               "FROM public.spatial_ref_sys "
               "WHERE CAST(srid AS TEXT) LIKE '" + str(filter_value))
        sql += "%' ORDER BY substr(srtext, 1, 6), srid"

        # Populate Table
        self.model_srid = QSqlQueryModel()
        self.model_srid.setQuery(sql, db=self.controller.db)
        self.tbl_srid.setModel(self.model_srid)
        self.tbl_srid.show()


    def set_info_project(self):

        # set variables from table version
        schema_name = tools_qt.getWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name)

        # TODO: Make just one SQL query
        self.project_type = self.controller.get_project_type(schemaname=schema_name)
        self.project_epsg = self.controller.get_project_epsg(schemaname=schema_name)
        self.project_version = self.controller.get_project_version(schemaname=schema_name)
        self.project_language = self.controller.get_project_language(schemaname=schema_name)

        self.postgresql_version = self.controller.get_postgresql_version()
        self.postgis_version = self.controller.get_postgis_version()

        if schema_name is None:
            schema_name = 'Nothing to select'
            self.project_version = "Version not found"
            tools_qt.enable_disable_tab_by_tabName(self.dlg_readsql.tab_main, "others", False)

        # Set label schema name
        self.lbl_schema_name.setText(str(schema_name))

        if schema_name == 'Nothing to select' or schema_name == '':
            result = None
            self.project_issample = None

        if self.project_type:
            msg = ('Database version: ' + str(self.postgresql_version) + '\n' + ''
                   'PostGis version:' + str(self.postgis_version) + ' \n \n' + ''
                   'Schema name: ' + schema_name + '\n' + ''
                   'Version: ' + self.project_version + ' \n' + ''
                   'EPSG: ' + str(self.project_epsg) + ' \n' + ''
                   'Language: ' + str(self.project_language) + ' \n' + '')

            self.software_version_info.setText(msg)

        # Update windowTitle
        connection = tools_qt.getWidgetText(self.dlg_readsql, self.dlg_readsql.cmb_connection)
        window_title = f'Giswater ({connection} - {self.plugin_version})'
        self.dlg_readsql.setWindowTitle(window_title)

        if schema_name == 'Nothing to select' or schema_name == '':
            tools_qt.setWidgetText(self.dlg_readsql, self.dlg_readsql.lbl_status_text, '')
        elif str(self.plugin_version) > str(self.project_version):
            self.dlg_readsql.lbl_status.setPixmap(self.status_no_update)
            tools_qt.setWidgetText(self.dlg_readsql, self.dlg_readsql.lbl_status_text,
                                   '(Schema version is lower than plugin version, please update schema)')
            self.dlg_readsql.btn_info.setEnabled(True)
        elif str(self.plugin_version) < str(self.project_version):
            self.dlg_readsql.lbl_status.setPixmap(self.status_no_update)
            tools_qt.setWidgetText(self.dlg_readsql, self.dlg_readsql.lbl_status_text,
                                   '(Schema version is higher than plugin version, please update plugin)')
            self.dlg_readsql.btn_info.setEnabled(False)
        else:
            self.dlg_readsql.lbl_status.setPixmap(self.status_ok)
            tools_qt.setWidgetText(self.dlg_readsql, self.dlg_readsql.lbl_status_text, '')
            self.dlg_readsql.btn_info.setEnabled(False)


    def process_folder(self, folderPath, filePattern):

        try:
            os.listdir(folderPath + filePattern)
            return True
        except Exception:
            return False


    def schema_file_to_db(self):

        if self.chk_schema_funcion.isChecked():
            self.task1 = GwTask('Manage schema')
            QgsApplication.taskManager().addTask(self.task1)
            self.task1.setProgress(50)
            self.reload_fct_ftrg(self.project_type_selected)
            self.task1.setProgress(100)

        status = (self.error_count == 0)
        self.manage_result_message(status, parameter="Reload")
        if status:
            self.controller.dao.commit()
        else:
            self.controller.dao.rollback()

        # Reset count error variable to 0
        self.error_count = 0


    def init_dialog_create_project(self, project_type=None):
        """ Initialize dialog (only once) """

        self.dlg_readsql_create_project = MainDbProjectUi()
        load_settings(self.dlg_readsql_create_project)

        # Find Widgets in form
        self.project_name = self.dlg_readsql_create_project.findChild(QLineEdit, 'project_name')
        self.project_descript = self.dlg_readsql_create_project.findChild(QLineEdit, 'project_descript')
        self.rdb_sample = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_sample')
        self.rdb_sample_dev = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_sample_dev')
        self.rdb_data = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_data')
        self.rdb_import_data = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_import_data')
        self.data_file = self.dlg_readsql_create_project.findChild(QLineEdit, 'data_file')

        # Load user values
        self.project_name.setText(get_parser_value('admin', 'project_name_schema'))
        self.project_descript.setText(get_parser_value('admin', 'project_descript'))
        create_schema_type = get_parser_value('admin', 'create_schema_type')
        if create_schema_type == 'True':
            tools_qt.setChecked(self.dlg_readsql_create_project, str(create_schema_type))
        if get_parser_value('admin', 'inp_file_path') not in ('null', None):
            self.data_file.setText(get_parser_value('admin', 'inp_file_path'))

        # TODO: do and call listener for buton + table -> temp_csv
        self.btn_push_file = self.dlg_readsql_create_project.findChild(QPushButton, 'btn_push_file')

        if self.dev_user != 'TRUE':
            self.rdb_sample_dev.setVisible(False)

        # Manage SRID
        self.manage_srid()

        # Fill combo 'project_type'
        self.cmb_create_project_type = self.dlg_readsql_create_project.findChild(QComboBox, 'cmb_create_project_type')
        for aux in self.project_types:
            self.cmb_create_project_type.addItem(str(aux))

        if project_type:
            tools_qt.setWidgetText(self.dlg_readsql_create_project, self.cmb_create_project_type, project_type)
            self.change_project_type(self.cmb_create_project_type)

        # Enable_disable data file widgets
        self.enable_datafile()

        # Get combo locale
        self.cmb_locale = self.dlg_readsql_create_project.findChild(QComboBox, 'cmb_locale')

        # Populate combo with all locales
        locales = sorted(os.listdir(self.sql_dir + os.sep + 'i18n' + os.sep))
        for locale in locales:
            self.cmb_locale.addItem(locale)
            if locale == 'EN':
                tools_qt.setWidgetText(self.dlg_readsql_create_project, self.cmb_locale, 'EN')

        # Get database connection name
        self.connection_name = str(tools_qt.getWidgetText(self.dlg_readsql, self.cmb_connection))

        # Set signals
        self.set_signals_create_project()


    def set_signals_create_project(self):

        self.dlg_readsql_create_project.btn_accept.clicked.connect(partial(self.create_project_data_schema))
        self.dlg_readsql_create_project.btn_close.clicked.connect(
            partial(self.close_dialog_admin, self.dlg_readsql_create_project))
        self.dlg_readsql_create_project.btn_push_file.clicked.connect(partial(self.select_file_inp))
        self.cmb_create_project_type.currentIndexChanged.connect(
            partial(self.change_project_type, self.cmb_create_project_type))
        self.cmb_locale.currentIndexChanged.connect(partial(self.update_locale))
        self.rdb_import_data.toggled.connect(partial(self.enable_datafile))
        self.filter_srid.textChanged.connect(partial(self.filter_srid_changed))


    def open_create_project(self):

        # Create dialog and signals
        if self.dlg_readsql_create_project is None:
            self.init_dialog_create_project()

        self.filter_srid_changed()

        # Get project_type from previous dialog
        self.cmb_project_type = tools_qt.getWidgetText(self.dlg_readsql, self.dlg_readsql.cmb_project_type)
        tools_qt.setWidgetText(self.dlg_readsql_create_project, self.cmb_create_project_type,
                               self.cmb_project_type)
        self.change_project_type(self.cmb_create_project_type)

        # Open dialog
        self.dlg_readsql_create_project.setWindowTitle(f"Create Project - {self.connection_name}")
        open_dialog(self.dlg_readsql_create_project, dlg_name='main_dbproject')


    def open_rename(self):

        # Open rename if schema is updated
        if str(self.plugin_version) != str(self.project_version):
            msg = "The schema version has to be updated to make rename"
            self.controller.show_info_box(msg, "Info")
            return

        # Create dialog
        self.dlg_readsql_rename = MainRenameProjUi()
        load_settings(self.dlg_readsql_rename)

        schema = tools_qt.getWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name)

        # Set listeners
        self.dlg_readsql_rename.btn_accept.clicked.connect(partial(self.rename_project_data_schema, schema))
        self.dlg_readsql_rename.btn_cancel.clicked.connect(partial(self.close_dialog_admin, self.dlg_readsql_rename))

        # Open dialog
        self.dlg_readsql_rename.setWindowTitle(f'Rename project - {schema}')
        open_dialog(self.dlg_readsql_rename, dlg_name='main_renameproj')


    def executeFiles(self, filedir, i18n=False, no_ct=False, log_folder=True, log_files=False):

        if not os.path.exists(filedir):
            self.controller.log_info("Folder not found", parameter=filedir)
            return True

        if log_folder:
            self.controller.log_info("Processing folder", parameter=filedir)

        filelist = sorted(os.listdir(filedir))
        status = True
        if self.schema is None:
            schema_name = tools_qt.getWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name)
            schema_name = schema_name.replace('"', '')
        else:
            schema_name = self.schema.replace('"', '')

        self.project_epsg = str(self.project_epsg).replace('"', '')
        if i18n:
            for file in filelist:
                if "utils.sql" in file:
                    if log_files:
                        self.controller.log_info(str(filedir + os.sep + 'utils.sql'))
                    status = self.read_execute_file(filedir, os.sep + 'utils.sql', schema_name, self.project_epsg)
                elif str(self.project_type_selected) + ".sql" in file:
                    if log_files:
                        self.controller.log_info(str(filedir + os.sep + str(self.project_type_selected) + '.sql'))
                    status = self.read_execute_file(filedir, os.sep + str(self.project_type_selected) + '.sql',
                        schema_name, self.project_epsg)
                if not status and self.dev_commit == 'FALSE':
                    return False
        else:
            for file in filelist:
                if ".sql" in file:
                    if (no_ct is True and "tablect.sql" not in file) or no_ct is False:
                        if log_files:
                            self.controller.log_info(str(filedir + os.sep + file))
                        status = self.read_execute_file(filedir, file, schema_name, self.project_epsg)
                        if not status and self.dev_commit == 'FALSE':
                            return False

        return status


    def read_execute_file(self, filedir, file, schema_name, project_epsg):

        status = False
        f = None
        try:
            filepath = filedir + os.sep + file
            f = open(filepath, 'r', encoding="utf8")
            if f:
                f_to_read = str(f.read().replace("SCHEMA_NAME", schema_name).replace("SRID_VALUE", project_epsg))
                if self.dev_commit == 'TRUE':
                    status = self.controller.execute_sql(str(f_to_read), filepath=filepath)
                else:
                    status = self.controller.execute_sql(str(f_to_read), commit=False, filepath=filepath)

                if status is False:
                    self.error_count = self.error_count + 1
                    self.controller.log_info(str("read_execute_file error"), parameter=filepath)
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
            if f:
                f.close()
            return status


    def readFiles(self, filelist, filedir):

        if "changelog.txt" in filelist:
            try:
                f = open(filedir + os.sep + 'changelog.txt', 'r')
                if f:
                    f_to_read = str(f.read()) + '\n'
                    self.message_update = self.message_update + '\n' + str(f_to_read)
                else:
                    return False
            except Exception as e:
                self.controller.log_warning("Error readFiles: " + str(e))
                return False

        return True


    def copy_schema(self):

        # Create dialog
        self.dlg_readsql_copy = MainRenameProjUi()
        load_settings(self.dlg_readsql_copy)

        schema = tools_qt.getWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name)

        # Set listeners
        self.dlg_readsql_copy.btn_accept.clicked.connect(partial(self.copy_project_data_schema, schema))
        self.dlg_readsql_copy.btn_cancel.clicked.connect(partial(self.close_dialog_admin, self.dlg_readsql_copy))

        # Open dialog
        self.dlg_readsql_copy.setWindowTitle('Copy project - ' + schema)
        open_dialog(self.dlg_readsql_copy, dlg_name='main_renameproj')


    def copy_project_data_schema(self, schema):

        new_schema_name = tools_qt.getWidgetText(self.dlg_readsql_copy, self.dlg_readsql_copy.schema_rename_copy)
        sql = "SELECT schema_name, schema_name FROM information_schema.schemata"
        rows = self.controller.get_rows(sql)

        for row in rows:
            if str(new_schema_name) == str(row[0]):
                msg = "This project name alredy exist."
                self.controller.show_info_box(msg, "Info")
                return
            else:
                continue

        self.task1 = GwTask('Manage schema')
        QgsApplication.taskManager().addTask(self.task1)
        self.task1.setProgress(0)
        extras = f'"parameters":{{"source_schema":"{schema}", "dest_schema":"{new_schema_name}"}}'
        body = create_body(extras=extras)
        self.task1.setProgress(50)
        result = self.controller.get_json('gw_fct_admin_schema_clone', body,
                                          schema_name=schema, commit=False)
        if not result or result['status'] == 'Failed':
            return
        self.task1.setProgress(100)

        # Show message
        status = (self.error_count == 0)
        self.manage_result_message(status, parameter="Copy project")
        if status:
            self.controller.dao.commit()
            self.event_change_connection()
            tools_qt.setWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name, str(new_schema_name))
            self.close_dialog_admin(self.dlg_readsql_copy)
        else:
            self.controller.dao.rollback()

        # Reset count error variable to 0
        self.error_count = 0


    def delete_schema(self):

        project_name = tools_qt.getWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name)
        if project_name is None:
            msg = "Please, select a project to delete"
            self.controller.show_info_box(msg, "Info")
            return

        msg = f"Are you sure you want delete schema '{project_name}' ?"
        result = self.controller.ask_question(msg, "Info")
        if result:
            sql = f'DROP SCHEMA {project_name} CASCADE;'
            status = self.controller.execute_sql(sql)
            if status:
                msg = "Process finished successfully"
                self.controller.show_info_box(msg, "Info", parameter="Delete schema")
                self.populate_data_schema_name(self.cmb_project_type)
                self.set_info_project()


    def execute_import_inp(self, accepted=False, schema_type='', is_test=False):

        is_test = False

        if accepted:

            # Set wait cursor
            self.task1 = GwTask('Manage schema')
            QgsApplication.taskManager().addTask(self.task1)
            self.task1.setProgress(0)

            # Insert inp values into database
            self.insert_inp_into_db(self.file_inp)

            # Execute import data
            if schema_type.lower() == 'ws':
                function_name = 'gw_fct_import_epanet_inp'
                useNode2arc = self.dlg_import_inp.findChild(QWidget, 'useNode2arc')
                extras = '"parameters":{"useNode2arc":"' + str(useNode2arc.isChecked()) + '"}'
            elif schema_type.lower() == 'ud':
                function_name = 'gw_fct_import_swmm_inp'
                createSubcGeom = self.dlg_import_inp.findChild(QWidget, 'createSubcGeom')
                extras = '"parameters":{"createSubcGeom":"' + str(createSubcGeom.isChecked()) + '"}'
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

            body = create_body(extras=extras)
            sql = ("SELECT " + str(function_name) + "(" + body + ")::text")
            row = self.controller.get_row(sql, commit=False)
            self.task1 = GwTask('Manage schema')
            QgsApplication.taskManager().addTask(self.task1)
            self.task1.setProgress(50)
            if row:
                complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]
                self.set_log_text(self.dlg_import_inp, complet_result[0]['body']['data'])
                if  complet_result[0]['status'] == 'Failed':
                    msg = "The importation process have been failed"
                    self.controller.show_info_box(msg, "Info")
                    self.controller.dao.rollback()
                    self.error_count = 0

                    # Close dialog
                    self.close_dialog(self.dlg_import_inp)
                    self.close_dialog(self.dlg_readsql_create_project)
                    return

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
        self.close_dialog_admin(self.dlg_import_inp)
        self.close_dialog_admin(self.dlg_readsql_create_project)


    def create_qgis_template(self):

        msg = ("Warning: Are you sure to continue?. This button will update your plugin qgis templates file replacing "
               "all strings defined on the config/system.config file. Be sure your config file is OK before continue")
        result = self.controller.ask_question(msg, "Info")
        if result:
            # Get dev config file
            setting_file = os.path.join(self.plugin_dir, 'config', 'system.config')
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
            self.task1 = GwTask('Manage schema')
            QgsApplication.taskManager().addTask(self.task1)
            self.task1.setProgress(50)

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
                        f_to_read = re.sub(str(self.text_replace[0]), str(self.text_replace[1]), f_to_read)

                    for text_replace in self.xml_set_labels:
                        self.text_replace = self.dev_settings.value('xml_set/' + text_replace)
                        self.controller.log_info("Replacing template text", parameter=self.text_replace[1])
                        f_to_read = re.sub(str(self.text_replace[0]), str(self.text_replace[1]), f_to_read)

                    # Close file
                    f.close()

                    # Open file for write
                    f = open(self.folder_path + os.sep + file, 'w')
                    f.write(f_to_read)

                    # Close file
                    f.close()

            # Set arrow cursor
            self.task1.setProgress(100)

            # Finish proces
            msg = "The QGIS Projects templates was correctly created."
            self.controller.show_info_box(msg, "Info")


    """ Import / Export UI and manage fields """

    def execute_import_ui(self):

        schema_name = tools_qt.getWidgetText(self.dlg_readsql, 'project_schema_name')
        tpath = tools_qt.getWidgetText(self.dlg_readsql, 'tpath')
        form_name_ui = tools_qt.getWidgetText(self.dlg_readsql, 'cmb_formname_ui')
        status_update_childs = self.dlg_readsql.chk_multi_update.isChecked()

        # Control if ui path is invalid or null
        if tpath in (None, 'null'):
            msg = "Please, select a valid UI Path."
            self.controller.show_info_box(msg, "Info")
            return

        with open(str(tpath)) as f:
            content = f.read()
        sql = ("INSERT INTO " + schema_name + ".temp_csv(source, csv1, fid) VALUES('" +
               str(form_name_ui) + "', '" + str(content) + "', 247);")
        status = self.controller.execute_sql(sql)

        # Import xml to database
        sql = ("SELECT " + schema_name + ".gw_fct_import_ui_xml('" + str(form_name_ui) + "', " +
               str(status_update_childs) + ")::text")
        status = self.controller.execute_sql(sql)
        self.manage_result_message(status, parameter="Import data into 'config_form_fields'")

        # Clear temp_csv
        self.clear_temp_table()


    def execute_export_ui(self):

        schema_name = tools_qt.getWidgetText(self.dlg_readsql, 'project_schema_name')
        tpath = tools_qt.getWidgetText(self.dlg_readsql, 'tpath')
        form_name_ui = tools_qt.getWidgetText(self.dlg_readsql, 'cmb_formname_ui')
        status_update_childs = self.dlg_readsql.chk_multi_update.isChecked()

        # Control if ui path is invalid or null
        if tpath is None or tpath == '' or tpath == 'null':
            msg = "Please, select a valid UI Path."
            self.controller.show_info_box(msg, "Info")
            return

        # Export xml from database
        sql = ("SELECT " + schema_name + ".gw_fct_export_ui_xml('"
               + str(form_name_ui) + "', " + str(status_update_childs) + ")::text")
        status = self.controller.execute_sql(sql)
        if status is False:
            msg = "Process finished with some errors"
            self.controller.show_info_box(msg, "Warning", parameter="Function import/export")
            return

        # Populate UI file
        sql = ("SELECT csv1 FROM " + schema_name + ".temp_csv "
               "WHERE cur_user = current_user AND source = '" + str(form_name_ui) + "' "
               "ORDER BY id DESC")
        row = self.controller.get_row(sql)
        if not row:
            return

        data = ET.Element(str(row[0]))
        data = ET.tostring(data)
        data = data.decode('utf-8')

        file_ui = open(tpath, "w")

        # TODO:: dont use replace for remove invalid characters
        data = data.replace(' />', '').replace('<<', '<')

        file_ui.write(data)
        file_ui.close()
        del file_ui
        msg = ("Exported data into '" + str(tpath) + "' successfully."
               "\nDo you want to open the UI form?")
        result = self.controller.ask_question(msg, "Info")
        if result:
            opener = "C:\OSGeo4W64/bin/designer.exe"
            subprocess.Popen([opener, tpath])

        # Clear temp_csv
        self.clear_temp_table()


    def clear_temp_table(self):

        schema_name = tools_qt.getWidgetText(self.dlg_readsql, 'project_schema_name')
        # Clear temp_csv
        sql = f"DELETE FROM {schema_name}.temp_csv WHERE cur_user = current_user"
        status = self.controller.execute_sql(sql)


    def select_file_ui(self):
        """ Select UI file """

        file_ui = tools_qt.getWidgetText(self.dlg_readsql, 'tpath')
        # Set default value if necessary
        if file_ui is None or file_ui == '':
            file_ui = self.plugin_dir

        # Get directory of that file
        folder_path = os.path.dirname(file_ui)
        if not os.path.exists(folder_path):
            folder_path = os.path.dirname(__file__)
        os.chdir(folder_path)
        message = self.controller.tr("Select UI file")
        file_ui, filter_ = QFileDialog.getSaveFileName(None, message, "", '*.ui')
        tools_qt.setWidgetText(self.dlg_readsql, self.dlg_readsql.tpath, str(file_ui))


    def update_manage_ui(self):

        schema_name = tools_qt.getWidgetText(self.dlg_readsql, 'project_schema_name')
        if schema_name is None:
            tools_qt.enable_disable_tab_by_tabName(self.dlg_readsql.tab_main, "others", False)
            return
        else:
            tools_qt.enable_disable_tab_by_tabName(self.dlg_readsql.tab_main, "others", True)

        # Control if schema_version is updated to 3.2
        if str(self.project_version).replace('.', '') < str(self.plugin_version).replace('.', ''):

            tools_qt.getWidget(self.dlg_readsql, self.dlg_readsql.grb_manage_addfields).setEnabled(False)
            tools_qt.getWidget(self.dlg_readsql, self.dlg_readsql.grb_manage_ui).setEnabled(False)
            tools_qt.getWidget(self.dlg_readsql, self.dlg_readsql.grb_manage_childviews).setEnabled(False)
            tools_qt.getWidget(self.dlg_readsql, self.dlg_readsql.grb_manage_sys_fields).setEnabled(False)

            self.dlg_readsql.cmb_feature_name_view.clear()
            self.dlg_readsql.cmb_formname_fields.clear()
            self.dlg_readsql.cmb_formname_ui.clear()
            self.dlg_readsql.cmb_feature_sys_fields.clear()
            return

        else:

            tools_qt.getWidget(self.dlg_readsql, self.dlg_readsql.grb_manage_addfields).setEnabled(True)
            tools_qt.getWidget(self.dlg_readsql, self.dlg_readsql.grb_manage_ui).setEnabled(True)
            tools_qt.getWidget(self.dlg_readsql, self.dlg_readsql.grb_manage_childviews).setEnabled(True)
            tools_qt.getWidget(self.dlg_readsql, self.dlg_readsql.grb_manage_sys_fields).setEnabled(True)

            sql = (f"SELECT cat_feature.child_layer, cat_feature.child_layer FROM {schema_name}.cat_feature "
                   f" ORDER BY id")
            rows = self.controller.get_rows(sql)
            tools_qt.set_item_data(self.dlg_readsql.cmb_formname_ui, rows, 1)

            sql = (f"SELECT cat_feature.id, cat_feature.id FROM {schema_name}.cat_feature "
                   f" ORDER BY id")
            rows = self.controller.get_rows(sql)
            tools_qt.set_item_data(self.dlg_readsql.cmb_formname_fields, rows, 1)
            tools_qt.set_item_data(self.dlg_readsql.cmb_feature_name_view, rows, 1)
            tools_qt.set_item_data(self.dlg_readsql.cmb_feature_sys_fields, rows, 1)


    def create_child_view(self):
        """ Create child view """

        schema_name = tools_qt.getWidgetText(self.dlg_readsql, 'project_schema_name')
        form_name = tools_qt.getWidgetText(self.dlg_readsql, self.dlg_readsql.cmb_feature_name_view)

        # Create body
        feature = '"catFeature":"' + form_name + '"'
        extras = '"multi_create":' + str(
            tools_qt.isChecked(self.dlg_readsql, self.dlg_readsql.chk_multi_create)).lower() + ''
        body = create_body(feature=feature, extras=extras)
        body = body.replace('""', 'null')

        # Execute query
        json_result = self.controller.get_json('gw_fct_admin_manage_child_views', body,
                                          schema_name=schema_name, commit=True)
        self.manage_json_message(json_result, title="Create child view")


    def update_sys_fields(self):

        # Create the dialog and signals
        self.dlg_manage_sys_fields = MainSysFields()
        load_settings(self.dlg_manage_sys_fields)
        self.model_update_table = None
        self.chk_multi_insert = None

        # Remove unused tabs
        form_name_fields = None
        for x in range(self.dlg_manage_sys_fields.tab_sys_add_fields.count() - 1, -1, -1):
            if str(self.dlg_manage_sys_fields.tab_sys_add_fields.widget(x).objectName()) != 'tab_update':
                tab_name = self.dlg_manage_sys_fields.tab_sys_add_fields.widget(x).objectName()
                tools_qt.remove_tab_by_tabName(self.dlg_manage_sys_fields.tab_sys_add_fields, tab_name)
            form_name_fields = tools_qt.getWidgetText(self.dlg_readsql, self.dlg_readsql.cmb_feature_sys_fields)

        self.manage_update_field(self.dlg_manage_sys_fields, form_name_fields, tableview='ve_config_sysfields')

        # Set listeners
        self.dlg_manage_sys_fields.btn_cancel.clicked.connect(partial(self.close_dialog_admin, self.dlg_manage_sys_fields))
        self.dlg_manage_sys_fields.btn_accept.clicked.connect(partial(self.close_dialog_admin, self.dlg_manage_sys_fields))
        self.dlg_manage_sys_fields.tbl_update.doubleClicked.connect(
            partial(self.update_selected_sys_fild, self.dlg_manage_sys_fields.tbl_update))
        self.dlg_manage_sys_fields.btn_open.clicked.connect(
            partial(self.update_selected_sys_fild, self.dlg_manage_sys_fields.tbl_update))

        window_title = 'Update field on "' + str(form_name_fields) + '"'
        self.dlg_manage_sys_fields.setWindowTitle(window_title)
        self.manage_update_sys_field(form_name_fields)

        open_dialog(self.dlg_manage_sys_fields)


    def open_manage_field(self, action):

        # Create the dialog and signals
        self.dlg_manage_fields = MainFields()
        load_settings(self.dlg_manage_fields)
        self.model_update_table = None

        # Remove unused tabs
        for x in range(self.dlg_manage_fields.tab_add_fields.count() - 1, -1, -1):
            if str(self.dlg_manage_fields.tab_add_fields.widget(x).objectName()) != f'tab_{action}':
                tools_qt.remove_tab_by_tabName(
                    self.dlg_manage_fields.tab_add_fields, self.dlg_manage_fields.tab_add_fields.widget(x).objectName())

        form_name_fields = tools_qt.getWidgetText(self.dlg_readsql, self.dlg_readsql.cmb_formname_fields)
        self.chk_multi_insert = tools_qt.isChecked(self.dlg_readsql, self.dlg_readsql.chk_multi_insert)

        window_title = ""
        if action == 'create':
            window_title = 'Create field on "' + str(form_name_fields) + '"'
            self.manage_create_field(form_name_fields)
        elif action == 'update':
            window_title = 'Update field on "' + str(form_name_fields) + '"'
            self.manage_update_field(self.dlg_manage_fields, form_name_fields, tableview='ve_config_addfields')
        elif action == 'delete':
            window_title = 'Delete field on "' + str(form_name_fields) + '"'
            self.manage_delete_field(form_name_fields)

        # Set listeners
        self.dlg_manage_fields.btn_accept.clicked.connect(
            partial(self.manage_accept, action, form_name_fields, self.model_update_table))
        self.dlg_manage_fields.btn_cancel.clicked.connect(partial(self.close_dialog_admin, self.dlg_manage_fields))
        self.dlg_manage_fields.tbl_update.doubleClicked.connect(
            partial(self.update_selected_addfild, self.dlg_manage_fields.tbl_update))
        self.dlg_manage_fields.btn_open.clicked.connect(
            partial(self.update_selected_addfild, self.dlg_manage_fields.tbl_update))

        open_dialog(self.dlg_manage_fields, dlg_name='main_addfields')
        self.dlg_manage_fields.setWindowTitle(window_title)


    # TODO:: Enhance this function and use parametric parameters


    def update_selected_sys_fild(self, widget):

        selected_list = widget.selectionModel().selectedRows()

        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        # Create the dialog and signals
        self.close_dialog_admin(self.dlg_manage_sys_fields)
        self.dlg_manage_sys_fields = MainSysFields()
        load_settings(self.dlg_manage_sys_fields)
        self.model_update_table = None

        form_name_fields = tools_qt.getWidgetText(self.dlg_readsql, self.dlg_readsql.cmb_feature_sys_fields)

        # Set listeners
        self.dlg_manage_sys_fields.btn_accept.clicked.connect(
            partial(self.manage_sys_update, form_name_fields))
        self.dlg_manage_sys_fields.btn_cancel.clicked.connect(
            partial(self.manage_close_dlg, self.dlg_manage_sys_fields))

        # Remove unused tabs
        for x in range(self.dlg_manage_sys_fields.tab_sys_add_fields.count() - 1, -1, -1):
            if str(self.dlg_manage_sys_fields.tab_sys_add_fields.widget(x).objectName()) != str('tab_create'):
                tools_qt.remove_tab_by_tabName(self.dlg_manage_sys_fields.tab_sys_add_fields,
                                               self.dlg_manage_sys_fields.tab_sys_add_fields.widget(x).objectName())

        window_title = 'Update field on "' + str(form_name_fields) + '"'
        self.dlg_manage_sys_fields.setWindowTitle(window_title)
        row = selected_list[0].row()

        for column in range(widget.model().columnCount()):
            index = widget.model().index(row, column)

            result = tools_qt.getWidget(self.dlg_manage_sys_fields,
                                        str(widget.model().headerData(column, Qt.Horizontal)))

            if result is None:
                continue

            value = str(widget.model().data(index))

            if value == 'NULL':
                value = None
            tools_qt.setWidgetText(self.dlg_manage_sys_fields, result, value)

        open_dialog(self.dlg_manage_sys_fields)


    def update_selected_addfild(self, widget):

        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        # Create the dialog and signals
        self.close_dialog_admin(self.dlg_manage_fields)
        self.dlg_manage_fields = MainFields()
        load_settings(self.dlg_manage_fields)
        self.model_update_table = None

        form_name_fields = tools_qt.getWidgetText(self.dlg_readsql, self.dlg_readsql.cmb_formname_fields)
        self.chk_multi_insert = tools_qt.isChecked(self.dlg_readsql, self.dlg_readsql.chk_multi_insert)
        self.dlg_manage_fields.column_id.setEnabled(False)

        # Set listeners
        self.dlg_manage_fields.btn_accept.clicked.connect(
            partial(self.manage_accept, 'update', form_name_fields, self.model_update_table))
        self.dlg_manage_fields.btn_cancel.clicked.connect(partial(self.manage_close_dlg, self.dlg_manage_fields))

        # Remove unused tabs
        for x in range(self.dlg_manage_fields.tab_add_fields.count() - 1, -1, -1):
            if str(self.dlg_manage_fields.tab_add_fields.widget(x).objectName()) != str('tab_create'):
                tools_qt.remove_tab_by_tabName(self.dlg_manage_fields.tab_add_fields,
                                               self.dlg_manage_fields.tab_add_fields.widget(x).objectName())

        window_title = 'Update field on "' + str(form_name_fields) + '"'
        self.dlg_manage_fields.setWindowTitle(window_title)
        self.manage_create_field(form_name_fields)

        row = selected_list[0].row()

        for column in range(widget.model().columnCount()):
            index = widget.model().index(row, column)

            result = tools_qt.getWidget(self.dlg_manage_fields, str(widget.model().headerData(column, Qt.Horizontal)))
            if result is None:
                continue

            value = str(widget.model().data(index))
            if value == 'NULL':
                value = None
            tools_qt.setWidgetText(self.dlg_manage_fields, result, value)

        open_dialog(self.dlg_manage_fields, dlg_name='main_addfields')


    def manage_create_field(self, form_name):

        schema_name = tools_qt.getWidgetText(self.dlg_readsql, 'project_schema_name')

        # Populate widgettype combo
        sql = (f"SELECT DISTINCT(id), idval FROM {schema_name}.config_typevalue "
               f"WHERE typevalue = 'widgettype_typevalue' AND addparam->>'createAddfield' = 'TRUE'")
        rows = self.controller.get_rows(sql)
        tools_qt.set_item_data(self.dlg_manage_fields.widgettype, rows, 1)

        # Populate datatype combo
        sql = (f"SELECT id, idval FROM {schema_name}.config_typevalue "
               f"WHERE typevalue = 'datatype_typevalue' AND addparam->>'createAddfield' = 'TRUE'")
        rows = self.controller.get_rows(sql)
        tools_qt.set_item_data(self.dlg_manage_fields.datatype, rows, 1)

        # Populate widgetfunction combo
        sql = (f"SELECT null as id, null as idval UNION ALL "
               f"SELECT id, idval FROM {schema_name}.config_typevalue "
               f"WHERE typevalue = 'widgetfunction_typevalue' AND addparam->>'createAddfield' = 'TRUE'")
        rows = self.controller.get_rows(sql)
        tools_qt.set_item_data(self.dlg_manage_fields.widgetfunction, rows, 1)

        # Set default value for formtype widget
        tools_qt.setWidgetText(self.dlg_manage_fields, self.dlg_manage_fields.formtype, 'feature')


    def manage_update_sys_field(self, form_name):
        # TODO:: Enhance this function and use parametric parameters

        schema_name = tools_qt.getWidgetText(self.dlg_readsql, 'project_schema_name')

        # Populate table update
        qtable = self.dlg_manage_sys_fields.findChild(QTableView, "tbl_update")
        self.model_update_table = QSqlTableModel(db=self.controller.db)
        qtable.setSelectionBehavior(QAbstractItemView.SelectRows)
        expr_filter = "cat_feature_id = '" + form_name + "'"
        self.fill_table(qtable, 've_config_sysfields', self.model_update_table, expr_filter)
        set_table_columns(self.dlg_manage_sys_fields, qtable, 've_config_sysfields', schema_name=schema_name)


    def manage_update_field(self, dialog, form_name, tableview):

        if form_name is None:
            return

        schema_name = tools_qt.getWidgetText(self.dlg_readsql, 'project_schema_name')
        if schema_name is None:
            tools_qt.enable_disable_tab_by_tabName(self.dlg_readsql.tab_main, "others", False)
            return
        else:
            tools_qt.enable_disable_tab_by_tabName(self.dlg_readsql.tab_main, "others", True)

        # Populate table update
        qtable = dialog.findChild(QTableView, "tbl_update")
        self.model_update_table = QSqlTableModel(db=self.controller.db)
        qtable.setSelectionBehavior(QAbstractItemView.SelectRows)

        if self.chk_multi_insert:
            expr_filter = "cat_feature_id IS NULL"
        else:
            expr_filter = "cat_feature_id = '" + form_name + "'"

        self.fill_table(qtable, tableview, self.model_update_table, expr_filter)
        set_table_columns(dialog, qtable, tableview, schema_name=schema_name)


    def manage_delete_field(self, form_name):

        schema_name = tools_qt.getWidgetText(self.dlg_readsql, 'project_schema_name')
        if schema_name is None:
            tools_qt.enable_disable_tab_by_tabName(self.dlg_readsql.tab_main, "others", False)
            return
        else:
            tools_qt.enable_disable_tab_by_tabName(self.dlg_readsql.tab_main, "others", True)

        # Populate widgettype combo
        if self.chk_multi_insert:
            sql = (f"SELECT DISTINCT(columnname), columnname "
                   f"FROM {schema_name}.ve_config_addfields "
                   f"WHERE cat_feature_id IS NULL ")
        else:
            sql = (f"SELECT DISTINCT(columnname), columnname "
                   f"FROM {schema_name}.ve_config_addfields "
                   f"WHERE cat_feature_id = '" + form_name + "'")

        rows = self.controller.get_rows(sql)
        tools_qt.set_item_data(self.dlg_manage_fields.cmb_fields, rows, 1)


    def manage_close_dlg(self, dlg_to_close):

        self.close_dialog_admin(dlg_to_close)
        if dlg_to_close.objectName() == 'dlg_man_sys_fields':
            self.update_sys_fields()
        elif dlg_to_close.objectName() == 'dlg_man_addfields':
            self.open_manage_field('update')


    def manage_sys_update(self, form_name):

        list_widgets = self.dlg_manage_sys_fields.tab_create.findChildren(QWidget)
        column_id = tools_qt.getWidgetText(self.dlg_manage_sys_fields, self.dlg_manage_sys_fields.column_id)
        sql = f"UPDATE ve_config_sys_fields SET "
        for widget in list_widgets:
            if type(widget) not in (
                    QScrollArea, QFrame, QWidget, QScrollBar, QLabel, QAbstractButton, QHeaderView, QListView,
                    QGroupBox, QTableView) and widget.objectName() not in ('qt_spinbox_lineedit', 'chk_multi_insert'):

                value = None
                if type(widget) in (QLineEdit, QSpinBox, QDoubleSpinBox):
                    value = tools_qt.getWidgetText(self.dlg_manage_sys_fields, widget, return_string_null=False)
                elif type(widget) is QComboBox:
                    value = tools_qt.get_item_data(self.dlg_manage_sys_fields, widget, 0)
                elif type(widget) is QCheckBox:
                    value = tools_qt.isChecked(self.dlg_manage_sys_fields, widget)
                elif type(widget) is QgsDateTimeEdit:
                    value = tools_qt.getCalendarDate(self.dlg_manage_sys_fields, widget)
                elif type(widget) is QPlainTextEdit:
                    value = widget.document().toPlainText()

                if value in ('null', None, ""):
                    value = "null"
                elif type(widget) is not QCheckBox:
                    value = "'" + value + "'"
                sql += f" {widget.objectName()} = {value},"

        sql = sql[:-1]
        sql += f" WHERE cat_feature_id = '{form_name}' and columname = '{column_id}'"
        self.controller.execute_sql(sql)

        # Close dialog
        self.close_dialog_admin(self.dlg_manage_sys_fields)
        self.update_sys_fields()


    def manage_accept(self, action, form_name, model=None):

        schema_name = tools_qt.getWidgetText(self.dlg_readsql, 'project_schema_name')

        # Execute manage add fields function
        param_name = tools_qt.getWidgetText(self.dlg_manage_fields, self.dlg_manage_fields.columnname)
        sql = (f"SELECT param_name FROM {schema_name}.sys_addfields "
               f"WHERE param_name = '{param_name}' AND  cat_feature_id = '{form_name}' ")
        row = self.controller.get_row(sql)

        if action == 'create':

            # Control mandatory widgets
            if tools_qt.getWidgetText(self.dlg_manage_fields, self.dlg_manage_fields.column_id) is 'null' or \
                    tools_qt.getWidgetText(self.dlg_manage_fields, self.dlg_manage_fields.label) is 'null':
                msg = "Column_id and Label fields mandatory. Please set correctly value."
                self.controller.show_info_box(msg, "Info")
                return

            elif row is not None:
                msg = "Column name already exists."
                self.controller.show_info_box(msg, "Info")
                return

            elif tools_qt.getWidgetText(self.dlg_manage_fields, self.dlg_manage_fields.widgettype) == 'combo' and \
                    tools_qt.getWidgetText(self.dlg_manage_fields, self.dlg_manage_fields.dv_querytext) in ('null', None):
                msg = "Parameter 'Query text:' is mandatory for 'combo' widgets. Please set value."
                self.controller.show_info_box(msg, "Info")
                return

            list_widgets = self.dlg_manage_fields.tab_create.findChildren(QWidget)

            _json = {}
            result_json = None
            for widget in list_widgets:
                if type(widget) not in (QScrollArea, QFrame, QWidget, QScrollBar, QLabel, QAbstractButton, QHeaderView, QListView, QGroupBox, QTableView) \
                        and widget.objectName() not in ('qt_spinbox_lineedit', 'chk_multi_insert'):

                    value = None
                    if type(widget) in (QLineEdit, QSpinBox, QDoubleSpinBox):
                        value = tools_qt.getWidgetText(self.dlg_manage_fields, widget, return_string_null=False)
                    elif type(widget) is QComboBox:
                        value = tools_qt.get_item_data(self.dlg_manage_fields, widget, 0)
                    elif type(widget) is QCheckBox:
                        value = tools_qt.isChecked(self.dlg_manage_fields, widget)
                    elif type(widget) is QgsDateTimeEdit:
                        value = tools_qt.getCalendarDate(self.dlg_manage_fields, widget)
                    elif type(widget) is QPlainTextEdit:
                        value = widget.document().toPlainText()

                    if str(widget.objectName()) not in (None, 'null', '', ""):
                        _json[str(widget.objectName())] = value
                        result_json = json.dumps(_json)

            # Create body
            feature = '"catFeature":"' + form_name + '"'
            extras = '"action":"CREATE", "multi_create":' + \
                str(self.chk_multi_insert).lower() + ', "parameters":' + result_json + ''
            body = create_body(feature=feature, extras=extras)
            body = body.replace('""', 'null')

            # Execute manage add fields function
            json_result = self.controller.get_json('gw_fct_admin_manage_addfields', body,
                                              schema_name=schema_name, commit=True)
            self.manage_json_message(json_result, parameter="Field configured in 'config_form_fields'")
            if not json_result or json_result['status'] == 'Failed':
                return

        elif action == 'update':

            list_widgets = self.dlg_manage_fields.tab_create.findChildren(QWidget)

            _json = {}
            result_json = None
            for widget in list_widgets:
                if type(widget) not in (
                        QScrollArea, QFrame, QWidget, QScrollBar, QLabel, QAbstractButton, QHeaderView, QListView, QGroupBox,
                        QTableView) and widget.objectName() not in ('qt_spinbox_lineedit', 'chk_multi_insert'):

                    value = None
                    if type(widget) in (QLineEdit, QSpinBox, QDoubleSpinBox):
                        value = tools_qt.getWidgetText(self.dlg_manage_fields, widget, return_string_null=False)
                    elif type(widget) is QComboBox:
                        value = tools_qt.get_item_data(self.dlg_manage_fields, widget, 0)
                    elif type(widget) is QCheckBox:
                        value = tools_qt.isChecked(self.dlg_manage_fields, widget)
                    elif type(widget) is QgsDateTimeEdit:
                        value = tools_qt.getCalendarDate(self.dlg_manage_fields, widget)
                    elif type(widget) is QPlainTextEdit:
                        value = widget.document().toPlainText()

                    result_json = None
                    if str(widget.objectName()) not in (None, 'null', '', ""):
                        _json[str(widget.objectName())] = value
                        result_json = json.dumps(_json)

            # Create body
            feature = '"catFeature":"' + form_name + '"'
            extras = '"action":"UPDATE"'
            extras += ', "multi_create":' + str(self.chk_multi_insert).lower() + ', "parameters":' + result_json + ''
            body = create_body(feature=feature, extras=extras)
            body = body.replace('""', 'null')

            # Execute manage add fields function
            json_result = self.controller.get_json('gw_fct_admin_manage_addfields', body,
                                              schema_name=schema_name, commit=True)
            self.manage_json_message(json_result, parameter="Field update in 'config_form_fields'")
            if not json_result or json_result['status'] == 'Failed':
                return

        elif action == 'delete':

            field_value = tools_qt.getWidgetText(self.dlg_manage_fields, self.dlg_manage_fields.cmb_fields)

            # Create body
            feature = '"catFeature":"' + form_name + '"'
            extras = '"action":"DELETE", "multi_create":' + str(
                self.chk_multi_insert).lower() + ',"parameters":{"columnname":"' + field_value + '"}'
            body = create_body(feature=feature, extras=extras)

            # Execute manage add fields function
            json_result = self.controller.get_json('gw_fct_admin_manage_addfields', body,
                                              schema_name=schema_name, commit=True)
            self.manage_json_message(json_result, parameter="Delete function")

        # Close dialog
        self.close_dialog_admin(self.dlg_manage_fields)

        if action == 'update':
            self.open_manage_field('update')


    def fill_table(self, qtable, table_name, model, expr_filter, set_edit_strategy=QSqlTableModel.OnManualSubmit):
        """ Set a model with selected filter.
        Attach that model to selected table """

        schema_name = tools_qt.getWidgetText(self.dlg_readsql, 'project_schema_name')
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


    def change_project_type(self, widget):
        """ Take current project type changed """

        self.project_type_selected = tools_qt.getWidgetText(self.dlg_readsql, widget)
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
                sql += "INSERT INTO temp_csv (fid, source, "
                values = "VALUES(239, '" + target + "', "
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
                self.controller.execute_sql(sql, commit=self.dev_user)
                sql = ""

        if sql != "":
            # TODO:: Use dev_commit or dev_user?
            self.controller.execute_sql(sql, commit=self.dev_user)

        _file.close()
        del _file


    def select_file_inp(self):
        """ Select INP file """

        file_inp = tools_qt.getWidgetText(self.dlg_readsql_create_project, 'data_file')
        # Set default value if necessary
        if file_inp is None or file_inp == '':
            file_inp = self.plugin_dir

        # Get directory of that file
        folder_path = os.path.dirname(file_inp)
        if not os.path.exists(folder_path):
            folder_path = os.path.dirname(__file__)
        os.chdir(folder_path)
        message = self.controller.tr("Select INP file")
        file_inp, filter_ = QFileDialog.getOpenFileName(None, message, "", '*.inp')
        self.dlg_readsql_create_project.data_file.setText(file_inp)


    def populate_functions_dlg(self, dialog, result):

        status = False
        for group, function in result['fields'].items():
            if len(function) != 0:
                dialog.setWindowTitle(function[0]['alias'])
                dialog.txt_info.setText(str(function[0]['descript']))
                self.function_list = []
                construct_form_param_user(dialog, function, 0, self.function_list)
                status = True
                break

        return status


    def set_log_text(self, dialog, data):

        for k, v in list(data.items()):
            if str(k) == "info":
                populate_info_text(dialog, data)


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


    def manage_json_message(self, json_result, parameter=None, title=None):
        """ Manage message depending result @status """

        if 'message' in json_result:

            level = 1
            if 'level' in json_result['message']:
                level = int(json_result['message']['level'])
            if 'text' in json_result['message']:
                msg = json_result['message']['text']
            else:
                msg = "Key on returned json from ddbb is missed"

            self.controller.show_message(msg, level, parameter=parameter, title=title)


    def save_selection(self):

        # Save last Project schema name and type selected
        schema_name = tools_qt.getWidgetText(self.dlg_readsql, self.dlg_readsql.project_schema_name)
        project_type = tools_qt.getWidgetText(self.dlg_readsql, self.dlg_readsql.cmb_project_type)
        set_parser_value('admin', 'last_project_type_selected', f'{project_type}')
        set_parser_value('admin', 'last_schema_name_selected', f'{schema_name}')


    def create_credentials_form(self, set_connection):

        self.dlg_credentials = Credentials()

        if str(self.list_connections) != '[]':
            tools_qt.set_item_data(self.dlg_credentials.cmb_connection, self.list_connections, 1)
        else:
            msg = "You don't have any connection configurated on QGIS. Check your connections."
            self.controller.show_info_box(msg, "Info")
            return

        tools_qt.setWidgetText(self.dlg_credentials, self.dlg_credentials.cmb_connection, str(set_connection))

        self.dlg_credentials.btn_accept.clicked.connect(partial(self.set_credentials, self.dlg_credentials))
        self.dlg_credentials.cmb_connection.currentIndexChanged.connect(
            partial(self.set_credentials, self.dlg_credentials, new_connection=True))
        open_dialog(self.dlg_credentials, dlg_name='main_credentials', maximize_button=False)


    def manage_user_params(self):

        # Update variable composer_path on config_param_user
        folder_name = os.path.dirname(os.path.abspath(__file__))
        composers_path_vdef = os.path.normpath(os.path.normpath(folder_name + os.sep + os.pardir)) + os.sep + \
            'templates' + os.sep + 'qgiscomposer' + os.sep + 'en'
        sql = (f"UPDATE {self.schema_name}.config_param_user "
               f"SET value = '{composers_path_vdef}' "
               f"WHERE parameter = 'qgis_composers_folderpath' AND cur_user = current_user")
        self.controller.execute_sql(sql)
