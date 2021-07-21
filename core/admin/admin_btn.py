"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import json
import os
import random
import re
import sys
import mmap
from functools import partial
from time import sleep

from qgis.PyQt.QtCore import QSettings, Qt, QDate
from qgis.PyQt.QtGui import QPixmap
from qgis.PyQt.QtSql import QSqlTableModel, QSqlQueryModel
from qgis.PyQt.QtWidgets import QRadioButton, QPushButton, QAbstractItemView, QTextEdit, QFileDialog, \
    QLineEdit, QWidget, QComboBox, QLabel, QCheckBox, QScrollArea, QSpinBox, QAbstractButton, \
    QHeaderView, QListView, QFrame, QScrollBar, QDoubleSpinBox, QPlainTextEdit, QGroupBox, QTableView
from qgis.core import QgsProject, QgsTask, QgsApplication
from qgis.gui import QgsDateTimeEdit
from qgis.utils import reloadPlugin

from .gis_file_create import GwGisFileCreate
from ..threads.task import GwTask
from ..ui.ui_manager import GwAdminUi, GwAdminDbProjectUi, GwAdminRenameProjUi, GwAdminProjectInfoUi, \
    GwAdminGisProjectUi, GwAdminImportUi, GwAdminFieldsUi, GwAdminVisitClassUi, GwAdminSysFieldsUi, GwCredentialsUi
from ..utils import tools_gw
from ... import global_vars
from .i18n_generator import GwI18NGenerator
from ...lib import tools_qt, tools_qgis, tools_log, tools_db, tools_os, tools_config
from ..ui.docker import GwDocker
from ..threads.project_schema_create import GwCreateSchemaTask
from ..threads.project_schema_utils_create import GwCreateSchemaUtilsTask


class GwAdminButton:

    def __init__(self):
        """ Class to control toolbar 'om_ws' """

        # Initialize instance attributes
        self.iface = global_vars.iface
        self.settings = global_vars.giswater_settings
        self.plugin_dir = global_vars.plugin_dir
        self.schema_name = global_vars.schema_name
        self.plugin_version, self.message = tools_qgis.get_plugin_version()
        self.canvas = global_vars.canvas
        self.project_type = None
        self.dlg_readsql = None
        self.dlg_info = None
        self.dlg_readsql_create_project = None
        self.project_type_selected = None
        self.schema_type = None
        self.form_enabled = True

        self.lower_postgresql_version = int(tools_gw.get_config_parser('system', 'lower_postgresql_version', "project",
                                                              "giswater", False))
        self.upper_postgresql_version = int(tools_gw.get_config_parser('system', 'upper_postgresql_version', "project",
                                                              "giswater", False))


    def init_sql(self, set_database_connection=False, username=None, show_dialog=True):
        """ Button 100: Execute SQL. Info show info """

        # Populate combo connections
        default_connection = self._populate_combo_connections()
        # Bug #733 was here
        # Check if connection is still False
        layer_source = None
        if set_database_connection:
            connection_status, not_version, layer_source = tools_db.set_database_connection()
        else:
            connection_status = global_vars.session_vars['logged_status']

        settings = QSettings()
        settings.beginGroup(f"PostgreSQL/connections/{default_connection}")
        self.is_service = settings.value('service')
        if not connection_status and not self.is_service:
            self._create_credentials_form(set_connection=default_connection)
            return

        if not connection_status and self.is_service:
            self.form_enabled = False

        # Set label status connection
        self.icon_folder = self.plugin_dir + os.sep + 'icons' + os.sep + 'dialogs' + os.sep + '20x20' + os.sep
        self.status_ok = QPixmap(self.icon_folder + 'status_ok.png')
        self.status_ko = QPixmap(self.icon_folder + 'status_ko.png')
        self.status_no_update = QPixmap(self.icon_folder + 'status_not_updated.png')

        # Create the dialog and signals
        self._init_show_database()
        self._info_show_database(connection_status=connection_status, username=username, show_dialog=show_dialog, layer_source=layer_source)


    def create_project_data_schema(self, project_name_schema=None, project_descript=None, project_type=None,
            project_srid=None, project_locale=None, is_test=False, exec_last_process=True, example_data=True):
        """"""

        # Get project parameters
        if project_name_schema is None or not project_name_schema:
            project_name_schema = tools_qt.get_text(self.dlg_readsql_create_project, 'project_name')
        if project_descript is None or not project_descript:
            project_descript = tools_qt.get_text(self.dlg_readsql_create_project, 'project_descript')
        if project_type is None:
            project_type = tools_qt.get_text(self.dlg_readsql_create_project, 'cmb_create_project_type')
        if project_srid is None:
            project_srid = tools_qt.get_text(self.dlg_readsql_create_project, 'srid_id')
        if project_locale is None:
            project_locale = tools_qt.get_combo_value(self.dlg_readsql_create_project, self.cmb_locale, 0)

        # Set class variables
        self.schema = project_name_schema
        self.descript = project_descript
        self.schema_type = project_type
        self.project_epsg = project_srid
        self.locale = project_locale

        self.folderLocale = self.sql_dir + os.sep + 'i18n' + os.sep + str(self.locale) + os.sep


        # Save in settings
        tools_gw.set_config_parser('btn_admin', 'project_name_schema', f'{project_name_schema}', prefix=False)
        tools_gw.set_config_parser('btn_admin', 'project_descript', f'{project_descript}', prefix=False)
        inp_file_path = tools_qt.get_text(self.dlg_readsql_create_project, 'data_file', False, False)
        tools_gw.set_config_parser('btn_admin', 'inp_file_path', f'{inp_file_path}', prefix=False)
        locale = tools_qt.get_combo_value(self.dlg_readsql_create_project, self.cmb_locale, 0)
        tools_gw.set_config_parser('btn_admin', 'project_locale', f'{locale}', prefix=False)

        # Check if project name is valid
        if not self._check_project_name(project_name_schema, project_descript):
            return

        # Check if srid value is valid
        if self.last_srids is None:
            msg = "This SRID value does not exist on Postgres Database. Please select a diferent one."
            tools_qt.show_info_box(msg, "Info")
            return

        msg = "This process will take time (few minutes). Are you sure to continue?"
        title = "Create example"
        answer = tools_qt.show_question(msg, title)
        if not answer:
            return

        tools_log.log_info(f"Create schema of type '{project_type}': '{project_name_schema}'")

        if self.rdb_import_data.isChecked():
            self.file_inp = tools_qt.get_text(self.dlg_readsql_create_project, 'data_file')
            if self.file_inp == 'null':
                msg = "The 'Path' field is required for Import INP data."
                tools_qt.show_info_box(msg, "Info")
                return
            # Check that the INP file works with the selected project_type
            with open(self.file_inp, 'rb', 0) as file, \
                    mmap.mmap(file.fileno(), 0, access=mmap.ACCESS_READ) as s:
                msg = ""
                # If we're creating a 'ud' project but the INP file is from epanet
                if project_type == 'ud' and s.find(b'[PIPES]') != -1:
                    msg = "The selected INP file does not match with a 'UD' project.\n" \
                          "Please check it before continuing..."
                # If we're creating a 'ws' project but the INP file is from swmm
                if project_type == 'ws' and s.find(b'[CONDUITS]') != -1:
                    msg = "The selected INP file does not match with a 'WS' project.\n" \
                          "Please check it before continuing..."
                if msg:
                    tools_qt.show_info_box(msg, "Warning")
                    return

        elif self.rdb_sample.isChecked() or self.rdb_sample_dev.isChecked():

            if self.locale != 'en_US' or str(self.project_epsg) != '25831':
                msg = ("This functionality is only allowed with the locality 'en_US' and SRID 25831."
                       "\nDo you want change it and continue?")
                result = tools_qt.show_question(msg, "Info Message")
                if result:
                    self.project_epsg = '25831'
                    self.locale = 'en_US'
                    project_locale = 'en_US'
                    self.folderLocale = self.sql_dir + os.sep + 'i18n' + os.sep + project_locale + os.sep
                    tools_qt.set_widget_text(self.dlg_readsql_create_project, 'srid_id', self.project_epsg)
                    tools_qt.set_widget_text(self.dlg_readsql_create_project, 'cmb_locale', self.locale)
                else:
                    return

        # Check postGis version
        major_version = self.postgis_version.split(".")
        if int(major_version[0]) >= 3:
            sql = f"CREATE EXTENSION IF NOT EXISTS postgis_raster;"
            tools_db.execute_sql(sql)

        # We retrieve the desired name of the schema, since in case there had been a schema with the same name, we had
        # changed the value of self.schema in the function _rename_project_data_schema or _execute_last_process
        self.schema = project_name_schema
        # Set background task 'GwCreateSchemaTask'
        description = f"Create schema"
        params = {'is_test': is_test, 'project_type': project_type, 'exec_last_process': exec_last_process,
                  'project_name_schema': project_name_schema, 'project_locale': project_locale,
                  'project_srid': project_srid, 'example_data': example_data}
        self.task_create_schema = GwCreateSchemaTask(self, description, params)
        QgsApplication.taskManager().addTask(self.task_create_schema)
        QgsApplication.taskManager().triggerTask(self.task_create_schema)


    def cancel_task(self):
        self.task_create_schema.cancel()


    # TODO: Rename this function => Update all versions from changelog file.
    def update(self, project_type):
        """"""

        msg = "Are you sure to update the project schema to last version?"
        result = tools_qt.show_question(msg, "Info")
        if result:
            self.task1 = GwTask('Manage schema')
            QgsApplication.taskManager().addTask(self.task1)
            self.task1.setProgress(50)
            self.task1 = GwTask('Manage schema')
            QgsApplication.taskManager().addTask(self.task1)
            status = self.load_updates(project_type, update_changelog=True)
            if status:
                self._set_info_project()
            self.task1.setProgress(100)
        else:
            return

        status = (self.error_count == 0)
        self._manage_result_message(status, parameter="Update project")
        if status:
            global_vars.dao.commit()
            self._close_dialog_admin(self.dlg_readsql_show_info)
        else:
            global_vars.dao.rollback()

        # Reset count error variable to 0
        self.error_count = 0


    """ Checkbox calling functions """

    def load_updates(self, project_type=None, update_changelog=False, schema_name=None):
        """"""
        # Get current schema selected
        if schema_name is None:
            schema_name = self._get_schema_name()

        self.schema = schema_name
        self.locale = self.project_language

        self.task1 = GwTask('Manage schema')
        QgsApplication.taskManager().addTask(self.task1)
        self.task1.setProgress(0)
        status = self._load_fct_ftrg(project_type=project_type)
        self.task1.setProgress(20)
        self.task1.setProgress(40)
        if status:
            status = self._update_31to39(project_type=project_type)
        self.task1.setProgress(60)
        if status:
            status = self._execute_last_process(schema_name=schema_name, locale=True)
        self.task1.setProgress(100)

        if update_changelog is False:
            status = (self.error_count == 0)
            self._manage_result_message(status, parameter="Load updates")
            if status:
                global_vars.dao.commit()
            else:
                global_vars.dao.rollback()

            # Reset count error variable to 0
            self.error_count = 0

        return status


    """ Other functions """

    def visit_manager(self):
        """"""
        # TODO:: Remove tab visitclas. WIP
        tools_qt.remove_tab(self.dlg_readsql.tab_main, "visitclass")
        return
        # Populate visit class
        # TODO:: Populate combo from visitclass manager and wip
        # sql = ("SELECT id, idval FROM config_visit_class")
        # rows = tools_db.get_rows(sql, commit=True)
        # qt_tools.fill_combo_values(self.dlg_readsql.cmb_visit_class, rows, 1)

        # Set listeners
        # self.dlg_readsql.btn_visit_create.clicked.connect(partial(self._create_visit_param))
        # self.dlg_readsql.btn_visit_update.clicked.connect(partial(self.update_visit))
        # self.dlg_readsql.btn_visit_delete.clicked.connect(partial(self.delete_visit))


    def init_dialog_create_project(self, project_type=None):
        """ Initialize dialog (only once) """

        self.dlg_readsql_create_project = GwAdminDbProjectUi()
        tools_gw.load_settings(self.dlg_readsql_create_project)
        self.dlg_readsql_create_project.btn_cancel_task.hide()


        # Find Widgets in form
        self.project_name = self.dlg_readsql_create_project.findChild(QLineEdit, 'project_name')
        self.project_descript = self.dlg_readsql_create_project.findChild(QLineEdit, 'project_descript')
        self.rdb_sample = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_sample')
        self.rdb_sample_dev = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_sample_dev')
        self.rdb_data = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_data')
        self.rdb_import_data = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_import_data')
        self.data_file = self.dlg_readsql_create_project.findChild(QLineEdit, 'data_file')

        # Load user values
        self.project_name.setText(tools_gw.get_config_parser('btn_admin', 'project_name_schema', "user", "session", False))
        self.project_descript.setText(tools_gw.get_config_parser('btn_admin', 'project_descript', "user", "session", False))
        create_schema_type = tools_gw.get_config_parser('btn_admin', 'create_schema_type', "user", "session", False)
        if create_schema_type:
            chk_widget = self.dlg_readsql_create_project.findChild(QWidget, create_schema_type)
            chk_widget.setChecked(True)
        if tools_gw.get_config_parser('btn_admin', 'inp_file_path', "user", "session", False) not in ('null', None):
            self.data_file.setText(tools_gw.get_config_parser('btn_admin', 'inp_file_path', "user", "session", False))

        # TODO: do and call listener for buton + table -> temp_csv
        self.btn_push_file = self.dlg_readsql_create_project.findChild(QPushButton, 'btn_push_file')

        if global_vars.user_level['level'] not in global_vars.user_level['showadminadvanced']:
            self.rdb_sample_dev.setVisible(False)

        # Manage SRID
        self._manage_srid()

        # Fill combo 'project_type'
        self.cmb_create_project_type = self.dlg_readsql_create_project.findChild(QComboBox, 'cmb_create_project_type')
        for aux in self.project_types:
            self.cmb_create_project_type.addItem(str(aux))

        if project_type:
            tools_qt.set_widget_text(self.dlg_readsql_create_project, self.cmb_create_project_type, project_type)
            self._change_project_type(self.cmb_create_project_type)

        # Enable_disable data file widgets
        self._enable_datafile()

        # Get combo locale
        self.cmb_locale = self.dlg_readsql_create_project.findChild(QComboBox, 'cmb_locale')

        # Populate combo with all locales
        status, sqlite_cur = tools_gw.create_sqlite_conn("config")
        list_locale = self._select_active_locales(sqlite_cur)
        tools_qt.fill_combo_values(self.cmb_locale, list_locale, 1)
        locale = tools_gw.get_config_parser('btn_admin', 'project_locale', 'user', 'session', False)
        tools_qt.set_combo_value(self.cmb_locale, locale, 0)

        # Set shortcut keys
        self.dlg_readsql_create_project.key_escape.connect(partial(tools_gw.close_dialog, self.dlg_readsql_create_project))

        # Get database connection name
        self.connection_name = str(tools_qt.get_text(self.dlg_readsql, self.cmb_connection))

        # Set signals
        self._set_signals_create_project()


    def fill_table(self, qtable, table_name, model, expr_filter, edit_strategy=QSqlTableModel.OnManualSubmit):
        """ Set a model with selected filter.
        Attach that model to selected table """

        schema_name = tools_qt.get_text(self.dlg_readsql, 'project_schema_name')
        if schema_name not in table_name:
            table_name = schema_name + "." + table_name

        # Set model
        model.setTable(table_name)
        model.setEditStrategy(edit_strategy)
        if expr_filter is not None:
            model.setFilter(expr_filter)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            tools_qgis.show_warning(model.lastError().text())
        # Attach model to table view
        qtable.setModel(model)


    # region private functions

    def _get_project_epsg(self, schemaname=None):
        """ Get project epsg from table 'version' """

        if schemaname in (None, 'null', ''):
            schemaname = self.schema_name

        project_epsg = None
        tablename = "sys_version"
        exists = tools_db.check_table(tablename, schemaname)
        if exists:
            sql = ("SELECT epsg FROM " + schemaname + "." + tablename + " ORDER BY id DESC LIMIT 1")
            row = tools_db.get_row(sql)
            if row:
                project_epsg = row[0]
        else:
            tablename = "version"
            exists = tools_db.check_table(tablename, schemaname)
            if exists:
                sql = ("SELECT epsg FROM " + schemaname + "." + tablename + " ORDER BY id DESC LIMIT 1")
                row = tools_db.get_row(sql)
                if row:
                    project_epsg = row[0]

        return project_epsg


    def _populate_combo_connections(self):
        """ Fill the combo with the connections that exist in QGis """

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


    def _init_show_database(self):
        """ Initialization code of the form (to be executed only once) """

        # Get SQL folder and check if exists
        folder_name = os.path.dirname(os.path.abspath(__file__))
        self.sql_dir = os.path.normpath(os.path.normpath(folder_name + os.sep + os.pardir)) + os.sep + '..'\
                       + os.sep + 'dbmodel'
        if not os.path.exists(self.sql_dir):
            tools_qgis.show_message("SQL folder not found", parameter=self.sql_dir)
            return

        self.project_version = '0'

        # Get locale of QGIS application
        self.locale = tools_qgis.get_locale()

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

        # Check if user have commit permissions
        self.dev_commit = tools_gw.get_config_parser('system', 'dev_commit', "project", "dev", False)
        self.dev_commit = tools_os.set_boolean(self.dev_commit)

        # Create dialog object
        self.dlg_readsql = GwAdminUi()
        tools_gw.load_settings(self.dlg_readsql)
        self.cmb_project_type = self.dlg_readsql.findChild(QComboBox, 'cmb_project_type')

        if global_vars.user_level['level'] not in global_vars.user_level['showadminadvanced']:
            tools_qt.remove_tab(self.dlg_readsql.tab_main, "tab_schema_manager")
            tools_qt.remove_tab(self.dlg_readsql.tab_main, "tab_advanced")
            self.project_types = tools_gw.get_config_parser('system', 'project_types', "project", "giswater", False)

        else:
            self.project_types = tools_gw.get_config_parser('system', 'project_types', "project", "giswater", False)

        self.project_types = self.project_types.split(',')

        # Populate combo types
        self.cmb_project_type.clear()
        for aux in self.project_types:
            self.cmb_project_type.addItem(str(aux))

        # Get widgets form
        self.cmb_connection = self.dlg_readsql.findChild(QComboBox, 'cmb_connection')
        self.btn_update_schema = self.dlg_readsql.findChild(QPushButton, 'btn_update_schema')
        self.lbl_schema_name = self.dlg_readsql.findChild(QLabel, 'lbl_schema_name')
        self.btn_constrains = self.dlg_readsql.findChild(QPushButton, 'btn_constrains')

        # Checkbox SCHEMA
        self.chk_schema_view = self.dlg_readsql.findChild(QCheckBox, 'chk_schema_view')
        self.chk_schema_funcion = self.dlg_readsql.findChild(QCheckBox, 'chk_schema_funcion')
        self.software_version_info = self.dlg_readsql.findChild(QTextEdit, 'software_version_info')

        self._manage_utils()

        # Set Listeners
        self._set_signals()

        # Set shortcut keys
        self.dlg_readsql.key_escape.connect(partial(tools_gw.close_dialog, self.dlg_readsql))

        # Set default project type
        tools_qt.set_widget_text(self.dlg_readsql, self.cmb_project_type, 'ws')

        # Update folderSoftware
        self._change_project_type(self.cmb_project_type)


    def _set_signals(self):
        """ Set signals. Function has to be executed only once (during form initialization) """

        self.dlg_readsql.btn_close.clicked.connect(partial(self._close_dialog_admin, self.dlg_readsql))
        self.dlg_readsql.btn_schema_create.clicked.connect(partial(self._open_create_project))
        self.dlg_readsql.btn_custom_load_file.clicked.connect(
            partial(self._load_custom_sql_files, self.dlg_readsql, "custom_path_folder"))
        self.dlg_readsql.btn_update_schema.clicked.connect(partial(self.load_updates, None))
        self.dlg_readsql.btn_schema_file_to_db.clicked.connect(partial(self._schema_file_to_db))
        self.dlg_readsql.btn_info.clicked.connect(partial(self._open_update_info))
        self.dlg_readsql.project_schema_name.currentIndexChanged.connect(partial(self._set_info_project))
        self.dlg_readsql.project_schema_name.currentIndexChanged.connect(partial(self._update_manage_ui))
        self.cmb_project_type.currentIndexChanged.connect(partial(self._populate_data_schema_name, self.cmb_project_type))
        self.cmb_project_type.currentIndexChanged.connect(partial(self._change_project_type, self.cmb_project_type))
        self.cmb_project_type.currentIndexChanged.connect(partial(self._set_info_project))
        self.cmb_project_type.currentIndexChanged.connect(partial(self._update_manage_ui))
        self.dlg_readsql.btn_custom_select_file.clicked.connect(
            partial(tools_qt.get_folder_path, self.dlg_readsql, "custom_path_folder"))
        self.cmb_connection.currentIndexChanged.connect(partial(self._event_change_connection))
        self.cmb_connection.currentIndexChanged.connect(partial(self._set_info_project))
        self.dlg_readsql.btn_schema_rename.clicked.connect(partial(self._open_rename))
        self.dlg_readsql.btn_delete.clicked.connect(partial(self._delete_schema))
        self.dlg_readsql.btn_copy.clicked.connect(partial(self._copy_schema))
        self.dlg_readsql.btn_constrains.clicked.connect(partial(self._btn_constrains_changed, self.btn_constrains, True))
        self.dlg_readsql.btn_create_qgis_template.clicked.connect(partial(self._create_qgis_template))
        self.dlg_readsql.btn_translation.clicked.connect(partial(self._manage_translations))
        self.dlg_readsql.btn_gis_create.clicked.connect(partial(self._open_form_create_gis_project))
        self.dlg_readsql.dlg_closed.connect(partial(self._save_selection))
        self.dlg_readsql.dlg_closed.connect(partial(self._close_dialog_admin, self.dlg_readsql))

        self.dlg_readsql.btn_create_utils.clicked.connect(partial(self._create_utils))
        self.dlg_readsql.btn_update_utils.clicked.connect(partial(self._update_utils))

        self.dlg_readsql.btn_create_field.clicked.connect(partial(self._open_manage_field, 'create'))
        self.dlg_readsql.btn_update_field.clicked.connect(partial(self._open_manage_field, 'update'))
        self.dlg_readsql.btn_delete_field.clicked.connect(partial(self._open_manage_field, 'delete'))
        self.dlg_readsql.btn_create_view.clicked.connect(partial(self._create_child_view))
        self.dlg_readsql.btn_update_sys_field.clicked.connect(partial(self._update_sys_fields))


    def _manage_translations(self):
        """ Initialize the translation functionalities """

        qm_gen = GwI18NGenerator()
        qm_gen.init_dialog()


    def _info_show_database(self, connection_status=True, username=None, show_dialog=False, layer_source=None):
        """"""

        self.message_update = ''
        self.error_count = 0
        self.schema = None

        # Get last database connection
        last_connection = self._get_last_connection()

        # Get database connection user and role
        self.username = username
        if username in (None, False):
            self.username = self._get_user_connection(last_connection)

        self.dlg_readsql.btn_info.setText('Update Project Schema')
        self.dlg_readsql.lbl_status_text.setStyleSheet("QLabel {color:red;}")

        # Populate again combo because user could have created one after initialization
        self._populate_combo_connections()

        if str(self.list_connections) != '[]':
            tools_qt.fill_combo_values(self.cmb_connection, self.list_connections, 1)

        # Set last connection for default
        tools_qt.set_combo_value(self.cmb_connection, str(last_connection), 1)

        # Set title
        connection = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.cmb_connection)
        window_title = f'Giswater ({self.plugin_version})'
        self.dlg_readsql.setWindowTitle(window_title)

        self.form_enabled = True
        message = ''

        if self.is_service and connection_status is False:
            self.form_enabled = False
            message = 'There is an error in the configuration of the pgservice file, ' \
                      'please check it or consult your administrator'
            tools_qt.enable_dialog(self.dlg_readsql, False, ['cmb_connection', 'btn_gis_create', 'cmb_project_type', 'project_schema_name'])
            self.dlg_readsql.lbl_status.setPixmap(self.status_ko)
            tools_qt.set_widget_text(self.dlg_readsql, 'lbl_status_text', message)
            tools_qt.set_widget_text(self.dlg_readsql, 'lbl_schema_name', '')
            self.dlg_readsql.btn_gis_create.setEnabled(False)
            self._manage_docker()
            return

        elif connection_status is False:
            self.form_enabled = False
            msg = "Connection Failed. Please, check connection parameters"
            tools_qgis.show_message(msg, 1)
            tools_qt.enable_dialog(self.dlg_readsql, False, 'cmb_connection')
            self.dlg_readsql.lbl_status.setPixmap(self.status_ko)
            tools_qt.set_widget_text(self.dlg_readsql, 'lbl_status_text', msg)
            tools_qt.set_widget_text(self.dlg_readsql, 'lbl_schema_name', '')
            self._manage_docker()
            return

        # Set projecte type
        self.project_type_selected = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.cmb_project_type)

        # Manage widgets tabs
        self._populate_data_schema_name(self.cmb_project_type)
        self._set_info_project()
        self._update_manage_ui()
        self.visit_manager()

        if not tools_db.check_role(self.username) and not show_dialog:
            tools_log.log_warning(f"User not found: {self.username}")
            return

        # Check PostgreSQL Version
        if int(self.postgresql_version) not in range(self.lower_postgresql_version, self.upper_postgresql_version) and self.form_enabled:
            message = "Incompatible version of PostgreSQL"
            self.form_enabled = False

        # Check super_user
        super_user = tools_db.check_super_user(self.username)
        if not super_user:
            message = "You don't have permissions to administrate project schemas on this connection"
            self.form_enabled = False

        elif self.form_enabled:
            if str(self.plugin_version) > str(self.project_version):
                self.dlg_readsql.lbl_status.setPixmap(self.status_no_update)
                tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.lbl_status_text,
                                         '(Schema version is lower than plugin version, please update schema)')
                self.dlg_readsql.btn_info.setEnabled(True)
            elif str(self.plugin_version) < str(self.project_version):
                self.dlg_readsql.lbl_status.setPixmap(self.status_no_update)
                tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.lbl_status_text,
                                         '(Schema version is higher than plugin version, please update plugin)')
                self.dlg_readsql.btn_info.setEnabled(True)
            else:
                self.dlg_readsql.lbl_status.setPixmap(self.status_ok)
                tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.lbl_status_text, '')
                self.dlg_readsql.btn_info.setEnabled(False)
            tools_qt.enable_dialog(self.dlg_readsql, True)

        # Check postgis extension and create if not exist
        postgis_extension = tools_db.check_postgis_version()
        if postgis_extension and self.form_enabled:
            sql = "CREATE EXTENSION IF NOT EXISTS POSTGIS;"
            tools_db.execute_sql(sql)
        elif self.form_enabled:
            self.form_enabled = False
            message = "Unable to create Postgis extension. Packages must be installed, consult your administrator."

        if self.form_enabled is False:
            tools_qt.enable_dialog(self.dlg_readsql, False, ['cmb_connection', 'btn_gis_create', 'cmb_project_type', 'project_schema_name'])
            self.dlg_readsql.lbl_status.setPixmap(self.status_ko)
            tools_qt.set_widget_text(self.dlg_readsql, 'lbl_status_text', message)
            tools_qt.set_widget_text(self.dlg_readsql, 'lbl_schema_name', '')

        # Load last schema name selected and project type
        tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.cmb_project_type,
                                 tools_gw.get_config_parser('btn_admin', 'project_type', "user", "session", False))
        tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.project_schema_name,
                                 tools_gw.get_config_parser('btn_admin', 'schema_name', "user", "session", False))

        if show_dialog:
            self._manage_docker()


    def _set_credentials(self, dialog, new_connection=False):
        """ Set connection parameters in settings """

        user_name = tools_qt.get_text(dialog, dialog.txt_user, False, False)
        password = tools_qt.get_text(dialog, dialog.txt_pass, False, False)
        settings = QSettings()
        settings.beginGroup("PostgreSQL/connections")
        default_connection = tools_qt.get_text(dialog, dialog.cmb_connection)
        settings.setValue('selected', default_connection)
        if new_connection:
            tools_db.set_database_connection()
        else:
            if default_connection:
                settings.endGroup()
                settings.beginGroup("PostgreSQL/connections/" + default_connection)
            settings.setValue('password', password)
            settings.setValue('username', user_name)
            settings.endGroup()

        self._close_dialog_admin(dialog)
        self.init_sql(True)


    def _gis_create_project(self):
        """"""

        # Get gis folder, gis file, project type and schema
        gis_folder = tools_qt.get_text(self.dlg_create_gis_project, 'txt_gis_folder')
        if gis_folder is None or gis_folder == 'null':
            tools_qgis.show_warning("GIS folder not set")
            return

        tools_gw.set_config_parser('btn_admin', 'qgis_file_path', gis_folder, prefix=False)

        gis_file = tools_qt.get_text(self.dlg_create_gis_project, 'txt_gis_file')
        if gis_file is None or gis_file == 'null':
            tools_qgis.show_warning("GIS file name not set")
            return

        project_type = tools_qt.get_text(self.dlg_readsql, 'cmb_project_type')
        schema_name = tools_qt.get_text(self.dlg_readsql, 'project_schema_name')

        # Get roletype and export password
        roletype = tools_qt.get_text(self.dlg_create_gis_project, 'cmb_roletype')
        export_passwd = tools_qt.is_checked(self.dlg_create_gis_project, 'chk_export_passwd')

        if export_passwd:
            msg = "Credentials will be stored in GIS project file"
            tools_qt.show_info_box(msg, "Warning")

        # Generate QGIS project
        self._generate_qgis_project(gis_folder, gis_file, project_type, schema_name, export_passwd, roletype)


    def _generate_qgis_project(self, gis_folder, gis_file, project_type, schema_name, export_passwd, roletype):
        """ Generate QGIS project """

        gis = GwGisFileCreate(self.plugin_dir)
        result, qgs_path = gis.gis_project_database(gis_folder, gis_file, project_type, schema_name, export_passwd,
                                                    roletype)

        self._close_dialog_admin(self.dlg_create_gis_project)
        self._close_dialog_admin(self.dlg_readsql)
        if result:
            self._open_project(qgs_path)


    def _open_project(self, qgs_path):
        """ Open a QGis project """

        project = QgsProject.instance()
        project.read(qgs_path)

        # Load Giswater plugin
        file_name = os.path.basename(self.plugin_dir)
        reloadPlugin(f"{file_name}")


    def _open_form_create_gis_project(self):
        """"""

        # Check if exist schema
        schema_name = tools_qt.get_text(self.dlg_readsql, 'project_schema_name')
        if schema_name is None:
            msg = "In order to create a qgis project you have to create a schema first ."
            tools_qt.show_info_box(msg)
            return

        # Create GIS project dialog
        self.dlg_create_gis_project = GwAdminGisProjectUi()
        tools_gw.load_settings(self.dlg_create_gis_project)

        # Set default values
        schema_name = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.project_schema_name)
        tools_qt.set_widget_text(self.dlg_create_gis_project, 'txt_gis_file', schema_name)
        qgis_file_path = tools_gw.get_config_parser('btn_admin', 'qgis_file_path', "user", "session", prefix=False)
        if qgis_file_path is None:
            qgis_file_path = os.path.expanduser("~")
        tools_qt.set_widget_text(self.dlg_create_gis_project, 'txt_gis_folder', qgis_file_path)
        if self.is_service:
            self.dlg_create_gis_project.lbl_export_user_pass.setVisible(False)
            self.dlg_create_gis_project.chk_export_passwd.setVisible(False)

        # Set listeners
        self.dlg_create_gis_project.btn_gis_folder.clicked.connect(
            partial(tools_qt.get_folder_path, self.dlg_create_gis_project, "txt_gis_folder"))
        self.dlg_create_gis_project.btn_accept.clicked.connect(partial(self._gis_create_project))
        self.dlg_create_gis_project.btn_close.clicked.connect(partial(self._close_dialog_admin, self.dlg_create_gis_project))
        self.dlg_create_gis_project.dlg_closed.connect(partial(self._close_dialog_admin, self.dlg_create_gis_project))

        # Set shortcut keys
        self.dlg_create_gis_project.key_escape.connect(partial(tools_gw.close_dialog, self.dlg_create_gis_project))

        # Open MainWindow
        tools_gw.open_dialog(self.dlg_create_gis_project, dlg_name='admin_gisproject')


    def _btn_constrains_changed(self, button, call_function=False):
        """"""

        lbl_constrains_info = self.dlg_readsql.findChild(QLabel, 'lbl_constrains_info')

        if button.text() == 'OFF':
            button.setText("ON")
            lbl_constrains_info.setText('(Constrains enabled)  ')
            if call_function:
                # Enable constrains
                sql = 'SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"ADD"}}$$)'
                tools_db.execute_sql(sql)

        elif button.text() == 'ON':
            button.setText("OFF")
            lbl_constrains_info.setText('(Constrains dissabled)')
            if call_function:
                # Disable constrains
                sql = 'SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"DROP"}}$$)'
                tools_db.execute_sql(sql)


    """ Declare all read sql process """

    def _load_base(self, project_type=False):
        """"""

        if str(project_type) in ('ws', 'ud'):

            folder = self.folderUtils + self.file_pattern_ddl
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

            folder = self.folderUtils + self.file_pattern_dml
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

            folder = self.folderUtils + self.file_pattern_fct
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

            folder = self.folderUtils + self.file_pattern_ftrg
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

            folder = self.folderSoftware + self.file_pattern_ddl
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

            folder = self.folderSoftware + self.file_pattern_ddlrule
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

            folder = self.folderSoftware + self.file_pattern_dml
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

            folder = self.folderSoftware + self.file_pattern_tablect
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

            folder = self.folderSoftware + self.file_pattern_fct
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

            folder = self.folderSoftware + self.file_pattern_ftrg
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

            folder = self.folderUtils + self.file_pattern_tablect
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

            folder = self.folderUtils + self.file_pattern_ddlrule
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

            if self._process_folder(self.folderLocale, '') is False:
                if self._process_folder(self.sql_dir + os.sep + 'i18n' + os.sep, 'EN') is False:
                    return False
                else:
                    status = self._execute_files(self.sql_dir + os.sep + 'i18n' + os.sep + 'EN', True)
                    if status is False and self.dev_commit is False:
                        return False
            else:
                status = self._execute_files(self.folderLocale, True)
                if status is False and self.dev_commit is False:
                    return False

        return True


    def _update_31to39(self, new_project=False, project_type=False, no_ct=False):
        """"""

        if str(project_type) in ('ws', 'ud'):
            if not os.path.exists(self.folderUpdates):
                tools_qgis.show_message("The update folder was not found in sql folder")
                self.error_count = self.error_count + 1
                return
            folders = sorted(os.listdir(self.folderUpdates + ''))
            for folder in folders:
                sub_folders = sorted(os.listdir(self.folderUpdates + folder))
                for sub_folder in sub_folders:
                    if new_project:
                        if self.dev_commit is True:
                            if str(sub_folder) > '31100':
                                if self._process_folder(self.folderUpdates + folder + os.sep + sub_folder, os.sep + 'utils' + os.sep):
                                    status = self._load_sql(self.folderUpdates + folder + os.sep +
                                                           sub_folder + os.sep + 'utils' + os.sep, no_ct=no_ct)
                                    if status is False:
                                        return False
                                if self._process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + project_type + os.sep, ''):
                                    status = self._load_sql(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + project_type + os.sep, no_ct=no_ct)
                                    if status is False:
                                        return False
                                if self._process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep), '') is True:
                                    status = self._execute_files(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep), True)
                                    if status is False:
                                        return False

                        else:
                            if str(sub_folder) > '31100' and str(sub_folder) <= str(self.plugin_version).replace('.', ''):
                                if self._process_folder(self.folderUpdates + folder + os.sep + sub_folder, os.sep + 'utils' + os.sep):
                                    status = self._load_sql(self.folderUpdates + folder + os.sep +
                                                           sub_folder + os.sep + 'utils' + os.sep, no_ct=no_ct)
                                    if status is False:
                                        return False
                                if self._process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + project_type + os.sep, ''):
                                    status = self._load_sql(self.folderUpdates + folder + os.sep +
                                                           sub_folder + os.sep + project_type + os.sep, no_ct=no_ct)
                                    if status is False:
                                        return False
                                if self._process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep), ''):
                                    status = self._execute_files(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep), True)
                                    if status is False:
                                        return False

                    else:
                        if self.dev_commit is True:
                            if str(sub_folder) > str(self.project_version).replace('.', '') and str(sub_folder) > '31100':
                                if self._process_folder(self.folderUpdates + folder + os.sep + sub_folder, os.sep + 'utils' + os.sep) is True:
                                    status = self._load_sql(self.folderUpdates + folder + os.sep +
                                                           sub_folder + os.sep + 'utils' + os.sep)
                                    if status is False:
                                        return False
                                if self._process_folder(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + self.project_type_selected + os.sep,
                                        '') is True:
                                    status = self._load_sql(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + self.project_type_selected + os.sep)
                                    if status is False:
                                        return False
                                if self._process_folder(self.folderUpdates + folder + os.sep + sub_folder +
                                                       os.sep + 'i18n' + os.sep + str(self.locale + os.sep),
                                        '') is True:
                                    status = self._execute_files(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                            self.locale + os.sep), True)
                                    if status is False:
                                        return False

                        else:
                            if str(sub_folder) > str(self.project_version).replace('.', '') and str(sub_folder) > '31100' and str(sub_folder) <= str(self.plugin_version).replace('.', ''):
                                if self._process_folder(self.folderUpdates + folder + os.sep + sub_folder, os.sep + 'utils' + os.sep) is True:
                                    status = self._load_sql(self.folderUpdates + folder + os.sep +
                                                           sub_folder + os.sep + 'utils' + os.sep)
                                    if status is False:
                                        return False
                                if self._process_folder(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + self.project_type_selected + os.sep,
                                        '') is True:
                                    status = self._load_sql(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + self.project_type_selected + os.sep)
                                    if status is False:
                                        return False
                                if self._process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep), '') is True:
                                    status = self._execute_files(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep), True)
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
                        if self.dev_commit is True:
                            if str(sub_folder) > '31100':
                                if self._process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep), '') is True:
                                    status = self._execute_files(self.sql_dir + os.sep + str(project_type) + os.sep + 'updates' + os.sep +
                                                               folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep), True)
                                    if status is False:
                                        return False
                        else:
                            if str(sub_folder) > '31100' and str(sub_folder) <= str(self.plugin_version).replace('.', ''):
                                if self._process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder,
                                                       '') is True:
                                    status = self._load_sql(self.sql_dir + os.sep + str(project_type) +
                                                           os.sep + 'updates' + os.sep + folder + os.sep + sub_folder)
                                    if status is False:
                                        return False
                                if self._process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep), '') is True:
                                    status = self._execute_files(self.sql_dir + os.sep + str(
                                        project_type) + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep), True)
                    else:
                        if self.dev_commit is True:
                            if str(sub_folder) > str(self.project_version).replace('.', '') and str(sub_folder) > '31100':
                                if self._process_folder(self.folderUpdates + folder + os.sep + sub_folder, os.sep + 'utils' + os.sep) is True:
                                    status = self._load_sql(self.folderUpdates + folder + os.sep +
                                                           sub_folder + os.sep + 'utils' + os.sep)
                                    if status is False:
                                        return False
                                if self._process_folder(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + self.project_type + os.sep,
                                        '') is True:
                                    status = self._load_sql(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + self.project_type + os.sep)
                                    if status is False:
                                        return False
                                if self._process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(self.locale + os.sep), '') is True:
                                    status = self._execute_files(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                            self.locale + os.sep), True)
                                    if status is False:
                                        return False
                        else:
                            if str(sub_folder) > str(self.project_version).replace('.', '') and str(sub_folder) > '31100' and str(sub_folder) <= str(self.plugin_version).replace('.', ''):
                                if self._process_folder(self.folderUpdates + folder + os.sep + sub_folder, os.sep + 'utils' + os.sep) is True:
                                    status = self._load_sql(self.folderUpdates + folder + os.sep +
                                                           sub_folder + os.sep + 'utils' + os.sep)
                                    if status is False:
                                        return False
                                if self._process_folder(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + self.project_type + os.sep,
                                        '') is True:
                                    status = self._load_sql(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + self.project_type + os.sep)
                                    if status is False:
                                        return False
                                if self._process_folder(
                                        self.folderUpdates + folder + os.sep + sub_folder +
                                    os.sep + 'i18n' + os.sep + str(self.locale + os.sep),
                                        '') is True:
                                    status = self._execute_files(
                                        self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                            self.locale + os.sep), True)
                                    if status is False:
                                        return False
        return True


    def _load_views(self, project_type=False):
        """"""

        if str(project_type) == 'ws' or str(project_type) == 'ud':
            folder = self.folderSoftware + self.file_pattern_ddlview
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

            folder = self.folderUtils + self.file_pattern_ddlview
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

        else:
            folder = self.folderSoftware + self.file_pattern_ddlview
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

        return True


    def _update_30to31(self, new_project=False, project_type=False):
        """"""
        if str(project_type) == 'ws' or str(project_type) == 'ud':

            if not os.path.exists(self.folderUpdates):
                tools_qgis.show_message("The update folder was not found in sql folder")
                self.error_count = self.error_count + 1
                return True

            folders = sorted(os.listdir(self.folderUpdates + ''))
            for folder in folders:
                sub_folders = sorted(os.listdir(self.folderUpdates + folder))
                for sub_folder in sub_folders:
                    if new_project:
                        if str(sub_folder) <= '31100':
                            if self._process_folder(self.folderUpdates + folder + os.sep + sub_folder, os.sep + 'utils' + os.sep) is True:
                                status = self._load_sql(self.folderUpdates + folder + os.sep +
                                                       sub_folder + os.sep + 'utils' + os.sep)
                                if status is False:
                                    return False
                            if self._process_folder(self.folderUpdates + folder + os.sep + sub_folder + os.sep + project_type + os.sep, '') is True:
                                status = self._load_sql(self.folderUpdates + folder + os.sep +
                                                       sub_folder + os.sep + project_type + os.sep)
                                if status is False:
                                    return False
                            if self._process_folder(
                                    self.folderUpdates + folder + os.sep + sub_folder +
                                os.sep + 'i18n' + os.sep + str(self.locale + os.sep),
                                    '') is True:
                                status = self._execute_files(
                                    self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep), True)
                                if status is False:
                                    return False
                    else:
                        if str(sub_folder) > str(self.project_version).replace('.', '') and str(sub_folder) <= '31100':
                            if self._process_folder(self.folderUpdates + folder + os.sep + sub_folder, os.sep + 'utils' + os.sep) is True:
                                status = self._load_sql(self.folderUpdates + folder + os.sep +
                                                       sub_folder + os.sep + 'utils' + os.sep)
                                if status is False:
                                    return False
                            if self._process_folder(
                                    self.folderUpdates + folder + os.sep + sub_folder + os.sep + self.project_type_selected + os.sep,
                                    '') is True:
                                status = self._load_sql(
                                    self.folderUpdates + folder + os.sep + sub_folder + os.sep + self.project_type_selected + os.sep)
                                if status is False:
                                    return False
                            if self._process_folder(
                                    self.folderUpdates + folder + os.sep + sub_folder +
                                os.sep + 'i18n' + os.sep + str(self.locale + os.sep),
                                    '') is True:
                                status = self._execute_files(
                                    self.folderUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                        self.locale + os.sep), True)
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
                            if self._process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder, '') is True:
                                status = self._load_sql(self.sql_dir + os.sep + str(project_type) + os.sep +
                                                       os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + '')
                                if status is False:
                                    return False
                            if self._process_folder(
                                    self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep +
                                folder + os.sep + sub_folder + os.sep +
                                'i18n' + os.sep + str(self.locale + os.sep),
                                    '') is True:
                                status = self._execute_files(self.sql_dir + os.sep + str(
                                    project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                    self.locale + os.sep), True)
                                if status is False:
                                    return False
                    else:
                        if str(sub_folder) > str(self.project_version).replace('.', '') and str(sub_folder) <= '31100':
                            if self._process_folder(self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder, '') is True:
                                status = self._load_sql(self.sql_dir + os.sep + str(project_type) + os.sep +
                                                       os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + '')
                                if status is False:
                                    return False
                            if self._process_folder(
                                    self.sql_dir + os.sep + str(project_type) + os.sep + os.sep + 'updates' + os.sep +
                                folder + os.sep + sub_folder + os.sep +
                                'i18n' + os.sep + str(self.locale + os.sep),
                                    '') is True:
                                status = self._execute_files(self.sql_dir + os.sep + str(
                                    project_type) + os.sep + os.sep + 'updates' + os.sep + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                    self.locale + os.sep), True)
                                if status is False:
                                    return False

        return True


    def _load_sample_data(self, project_type=False):

        if str(project_type) == 'ws' or str(project_type) == 'ud':
            folder = self.folderExemple + 'user' + os.sep + project_type
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

        else:
            folder = self.folderSoftware + 'example' + os.sep + 'user' + os.sep
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

        return True


    def _load_dev_data(self, project_type=False):
        """"""

        if str(project_type) == 'ws' or str(project_type) == 'ud':
            folder = self.folderExemple + 'dev' + os.sep + project_type
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False
        else:
            folder = self.folderSoftware + 'example' + os.sep + 'dev' + os.sep
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

        return True


    def _load_fct_ftrg(self, project_type=False):
        """"""

        if str(project_type) == 'ws' or str(project_type) == 'ud':
            folder = self.folderUtils + self.file_pattern_fct
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

            folder = self.folderUtils + self.file_pattern_ftrg
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

            folder = self.folderSoftware + self.file_pattern_fct
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

            folder = self.folderSoftware + self.file_pattern_ftrg
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

        else:
            folder = self.folderSoftware + self.file_pattern_fct
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

            folder = self.folderSoftware + self.file_pattern_ftrg
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

        return True


    def _load_tablect(self, project_type=False):
        """"""

        if str(project_type) == 'ws' or str(project_type) == 'ud':
            folder = self.folderSoftware + self.file_pattern_tablect
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

            folder = self.folderUtils + self.file_pattern_tablect
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

        else:
            folder = self.folderSoftware + self.file_pattern_tablect
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

        return True


    def _load_trg(self, project_type=False):
        """"""

        if str(project_type) == 'ws' or str(project_type) == 'ud':
            folder = self.folderUtils + self.file_pattern_trg
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

            folder = self.folderSoftware + self.file_pattern_trg
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

        else:
            folder = self.folderSoftware + self.file_pattern_trg
            status = self._execute_files(folder)
            if not status and self.dev_commit is False:
                return False

        return True


    def _load_sql(self, path_folder, no_ct=False):
        """"""

        for (path, ficheros, archivos) in os.walk(path_folder):
            status = self._execute_files(path, no_ct=no_ct)
            if not status:
                return False

        return True


    """ Functions execute process """

    def _execute_import_data(self, project_name, project_type):
        """"""

        # Create dialog
        self.dlg_import_inp = GwAdminImportUi()
        tools_gw.load_settings(self.dlg_import_inp)

        # Hide widgets
        self.dlg_import_inp.progressBar.setVisible(False)

        if project_type.lower() == 'ws':
            extras = '"function":2522'
        elif project_type.lower() == 'ud':
            extras = '"function":2524'
        else:
            self.error_count = self.error_count + 1
            return

        schema_name = tools_qt.get_text(self.dlg_readsql_create_project, 'project_name')

        extras += ', "isToolbox":false'
        body = tools_gw.create_body(extras=extras)
        complet_result = tools_gw.execute_procedure('gw_fct_gettoolbox', body, schema_name, False)
        if not complet_result or complet_result['status'] == 'Failed':
            return False
        self._populate_functions_dlg(self.dlg_import_inp, complet_result['body']['data'])

        # Set listeners
        self.dlg_import_inp.btn_run.clicked.connect(partial(self._execute_import_inp, True, project_name, project_type))
        self.dlg_import_inp.btn_close.clicked.connect(partial(self._execute_import_inp, False, project_name, project_type))

        # Open dialog
        tools_gw.open_dialog(self.dlg_import_inp, dlg_name='admin_importinp')


    def _execute_last_process(self, new_project=False, schema_name='', schema_type='', locale=False, srid=None):
        """ Execute last process function """

        if new_project is True:
            extras = '"isNewProject":"' + str('TRUE') + '", '
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

        self.schema_name = schema_name

        # Get current locale
        if not locale:
            locale = tools_qt.get_combo_value(self.dlg_readsql_create_project, self.cmb_locale, 0)

        client = '"client":{"device":4, "lang":"' + str(locale) + '"}, '
        data = '"data":{' + extras + '}'
        body = "$${" + client + data + "}$$"
        result = tools_gw.execute_procedure('gw_fct_admin_schema_lastprocess', body,
                                            schema_name=self.schema_name, commit=False, log_sql=True)
        if result is None or ('status' in result and result['status'] == 'Failed'):
            self.error_count = self.error_count + 1

        return result


    def _task_started(self, task, wait_time):
        """ Dumb test function.
        to break the task raise an exception
        to return a successful result return it.
        This will be passed together with the exception (None in case of success) to the on_finished method
        """

        tools_log.log_info("Started task '{}'".format(task.description()))

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
                self._task_stopped(task)
                return None

            # Example of Raise exception to abort task
            if random.randint(0, 1000) == 10:
                raise Exception('Bad value!')

        # return True
        self._task_completed(None, {'total': total, 'iterations': iterations, 'task': task.description()})


    def _task_stopped(self, task):
        """"""
        tools_log.log_info('Task "{name}" was cancelled'.format(name=task.description()))

    def _task_completed(self, exception, result):
        """ Called when run is finished.
        Exception is not None if run raises an exception. Result is the return value of run
        """

        tools_log.log_info("task_completed")

        if exception is None:
            if result is None:
                msg = 'Completed with no exception and no result'
                tools_log.log_info(msg)
            else:
                tools_log.log_info('Task {name} completed\n'
                                   'Total: {total} (with {iterations} '
                                   'iterations)'.format(name=result['task'], total=result['total'],
                                                        iterations=result['iterations']))
        else:
            tools_log.log_info("Exception: {}".format(exception))
            raise exception


    def _task_example(self):
        """ Add task example to taskManager """

        tools_log.log_info("task_example")
        task1 = QgsTask.fromFunction('task_example', self._task_started, on_finished=self._task_completed, wait_time=20)
        QgsApplication.taskManager().addTask(task1)


    def _check_project_name(self, project_name, project_descript):
        """ Check if @project_name and @project_descript are is valid """

        # Check if project name is valid
        if project_name == 'null':
            msg = "The 'Project_name' field is required."
            tools_qt.show_info_box(msg, "Info")
            return False
        elif any(c.isupper() for c in project_name) is True:
            msg = "The 'Project_name' field require only lower caracters"
            tools_qt.show_info_box(msg, "Info")
            return False
        elif (bool(re.match('^[a-z0-9_]*$', project_name))) is False:
            msg = "The 'Project_name' field have invalid character"
            tools_qt.show_info_box(msg, "Info")
            return False
        if project_descript == 'null':
            msg = "The 'Description' field is required."
            tools_qt.show_info_box(msg, "Info")
            return False

        # Check is project name already exists
        sql = (f"SELECT schema_name, schema_name FROM information_schema.schemata "
               f"WHERE schema_name ILIKE '%{project_name}%'ORDER BY schema_name")
        rows = tools_db.get_rows(sql, commit=False)

        available = True
        if rows is not None:
            for row in rows:
                if f"{project_name}" == f"{row[0]}":
                    available = False
                    break

        if available:
            return True

        list_schemas = [row[0] for row in rows if f"{project_name}" in f"{row[0]}"]
        new_name = self.bk_schema_name(list_schemas, f"{project_name}_bk_", 0)

        msg = f"This 'Project_name' is already exist. Do you want rename old schema to '{new_name}"
        result = tools_qt.show_question(msg, "Info")
        if result:
            self._rename_project_data_schema(str(project_name), str(new_name))
            return True
        else:
            return False


    def bk_schema_name(self, list_schemas, project_name, i):
        """ Check for available bk schema name """

        if f"{project_name}{i}" not in list_schemas:
            return f"{project_name}{i}"
        else:
            return self.bk_schema_name(list_schemas, project_name, i+1)


    def _manage_process_result(self, project_name, project_type, is_test=False, is_utils=False):
        """"""

        status = (self.error_count == 0)
        self._manage_result_message(status, parameter="Create project")
        if status:
            global_vars.dao.commit()
            self._close_dialog_admin(self.dlg_readsql_create_project)
            if not is_test:
                self._populate_data_schema_name(self.cmb_project_type)
                if project_name is not None and is_utils is False:
                    tools_qt.set_widget_text(self.dlg_readsql, 'cmb_project_type', project_type)
                    tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.project_schema_name, project_name)
                    self._set_info_project()
        else:
            global_vars.dao.rollback()
            # Reset count error variable to 0
            self.error_count = 0
            tools_qt.show_exception_message(msg=global_vars.session_vars['last_error_msg'])


    def _rename_project_data_schema(self, schema, create_project=None):
        """"""

        if create_project is None:
            close_dlg_rename = True
            self.schema = tools_qt.get_text(self.dlg_readsql_rename, self.dlg_readsql_rename.schema_rename_copy)
            if str(self.schema) == str(schema):
                msg = "Please, select a diferent project name than current."
                tools_qt.show_info_box(msg, "Info")
                return
        else:
            close_dlg_rename = False
            self.schema = str(create_project)

        sql = "SELECT schema_name, schema_name FROM information_schema.schemata"
        rows = tools_db.get_rows(sql)
        for row in rows:
            if str(self.schema) == str(row[0]):
                msg = "This project name alredy exist."
                tools_qt.show_info_box(msg, "Info")
                return
            else:
                continue

        self.task1 = GwTask('Manage schema')
        QgsApplication.taskManager().addTask(self.task1)
        self.task1.setProgress(0)
        sql = f'ALTER SCHEMA {schema} RENAME TO {self.schema}'
        status = tools_db.execute_sql(sql, commit=False)
        if status:
            self._reload_fct_ftrg(project_type=self.project_type_selected)
            self.task1.setProgress(40)
            sql = ('SELECT ' + str(self.schema) + '.gw_fct_admin_rename_fixviews($${"data":{"currentSchemaName":"'
                   + self.schema + '","oldSchemaName":"' + str(schema) + '"}}$$)::text')
            tools_db.execute_sql(sql, commit=False)
            self._execute_last_process(schema_name=self.schema, locale=True)
        self.task1.setProgress(100)

        # Show message
        status = (self.error_count == 0)
        self._manage_result_message(status, parameter="Rename project")
        if status:
            global_vars.dao.commit()
            self._populate_data_schema_name(self.cmb_project_type)
            tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.project_schema_name, str(self.schema))
            self._set_info_project()
            if close_dlg_rename:
                self._close_dialog_admin(self.dlg_readsql_rename)
        else:
            global_vars.dao.rollback()

        # Reset count error variable to 0
        self.error_count = 0


    def _load_custom_sql_files(self, dialog, widget):
        """"""

        folder_path = tools_qt.get_text(dialog, widget)
        self.task1 = GwTask('Manage schema')
        QgsApplication.taskManager().addTask(self.task1)
        self.task1.setProgress(50)
        self._load_sql(folder_path)
        self.task1.setProgress(100)

        status = (self.error_count == 0)
        self._manage_result_message(status, parameter="Load custom SQL files")
        if status:
            global_vars.dao.commit()
        else:
            global_vars.dao.rollback()

        # Reset count error variable to 0
        self.error_count = 0


    def _get_schema_name(self):
        """"""
        schema_name = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.project_schema_name)
        return schema_name


    def _reload_tablect(self, project_type=False):
        """"""
        self._load_tablect(project_type=project_type)


    def _reload_fct_ftrg(self, project_type=False):
        """"""
        self._load_fct_ftrg(project_type=project_type)


    def _reload_trg(self, project_type=False):
        """"""
        self._load_trg(project_type)


    """ Create new connection when change combo connections """

    def _event_change_connection(self):
        """"""

        connection_name = str(tools_qt.get_text(self.dlg_readsql, self.cmb_connection))

        credentials = {'db': None, 'schema': None, 'table': None, 'service': None,
                       'host': None, 'port': None, 'user': None, 'password': None, 'sslmode': None}

        self.form_enabled = True
        message = ''

        settings = QSettings()
        settings.beginGroup(f"PostgreSQL/connections/{connection_name}")
        credentials['host'] = settings.value('host')
        if settings.value('host') in (None, ""):
            credentials['host'] = 'localhost'
        credentials['port'] = settings.value('port')
        credentials['db'] = settings.value('database')
        credentials['user'] = settings.value('username')
        credentials['password'] = settings.value('password')
        credentials['service'] = settings.value('service')
        self.is_service = credentials['service']

        sslmode_settings = settings.value('sslmode')
        sslmode = sslmode_settings
        if isinstance(sslmode_settings, str):
            sslmode_settings = sslmode_settings.lower().replace("ssl", "")
            sslmode_dict = {'0': 'prefer', '1': 'disable', '3': 'require'}
            sslmode = sslmode_dict.get(sslmode_settings, sslmode_settings)
        credentials['sslmode'] = sslmode
        settings.endGroup()

        self.logged, credentials = tools_db.connect_to_database_credentials(credentials)
        if self.is_service and not self.logged:
            self.form_enabled = False
            message = 'There is an error in the configuration of the pgservice file, ' \
                      'please check it or consult your administrator'
            tools_qt.enable_dialog(self.dlg_readsql, False, ['cmb_connection', 'btn_gis_create', 'cmb_project_type', 'project_schema_name'])
            self.dlg_readsql.lbl_status.setPixmap(self.status_ko)
            tools_qt.set_widget_text(self.dlg_readsql, 'lbl_status_text', message)
            tools_qt.set_widget_text(self.dlg_readsql, 'lbl_schema_name', '')
            self.dlg_readsql.btn_gis_create.setEnabled(False)

        elif not self.logged:
            self._close_dialog_admin(self.dlg_readsql)
            self._create_credentials_form(set_connection=connection_name)
        else:
            if str(self.plugin_version) > str(self.project_version):
                self.dlg_readsql.lbl_status.setPixmap(self.status_no_update)
                tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.lbl_status_text,
                '(Schema version is lower than plugin version, please update schema)')
                self.dlg_readsql.btn_info.setEnabled(True)
            elif str(self.plugin_version) < str(self.project_version):
                self.dlg_readsql.lbl_status.setPixmap(self.status_no_update)
                tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.lbl_status_text,
                '(Schema version is higher than plugin version, please update plugin)')
                self.dlg_readsql.btn_info.setEnabled(True)
            else:
                self.dlg_readsql.lbl_status.setPixmap(self.status_ok)
                tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.lbl_status_text, '')
                self.dlg_readsql.btn_info.setEnabled(False)
            tools_qt.enable_dialog(self.dlg_readsql, True)

            self._populate_data_schema_name(self.cmb_project_type)
            self._set_last_connection(connection_name)

            # Check super_user
            self.username = self._get_user_connection(connection_name)
            super_user = tools_db.check_super_user(self.username)

            if not super_user:
                message = "You don't have permissions to administrate project schemas on this connection"
                self.form_enabled = False

            # Check PostgreSQL Version
            self.postgresql_version = tools_db.get_pg_version()
            if int(self.postgresql_version) not in range(self.lower_postgresql_version,
                                                         self.upper_postgresql_version) and self.form_enabled:
                message = "Incompatible version of PostgreSQL"
                self.form_enabled = False

            # Check postgis extension and create if not exist
            postgis_extension = tools_db.check_postgis_version()
            if postgis_extension and self.form_enabled:
                sql = "CREATE EXTENSION IF NOT EXISTS POSTGIS;"
                tools_db.execute_sql(sql)
            elif self.form_enabled:
                message = "Unable to create Postgis extension. Packages must be installed, consult your administrator."
                self.form_enabled = False
            if self.form_enabled is False:
                tools_qt.enable_dialog(self.dlg_readsql, False, ['cmb_connection', 'btn_gis_create', 'cmb_project_type', 'project_schema_name'])
                self.dlg_readsql.lbl_status.setPixmap(self.status_ko)
                tools_qt.set_widget_text(self.dlg_readsql, 'lbl_status_text', message)
                tools_qt.set_widget_text(self.dlg_readsql, 'lbl_schema_name', '')


    def _set_last_connection(self, connection_name):
        """"""

        settings = QSettings()
        settings.beginGroup("PostgreSQL/connections")
        settings.setValue('selected', connection_name)
        settings.endGroup()


    def _get_last_connection(self):
        """"""

        settings = QSettings()
        settings.beginGroup("PostgreSQL/connections")
        connection_name = settings.value('selected')
        settings.endGroup()
        return connection_name


    def _get_user_connection(self, connection_name):
        """"""

        connection_username = None
        settings = QSettings()
        if connection_name:
            settings.beginGroup(f"PostgreSQL/connections/{connection_name}")
            connection_username = settings.value('username')
            settings.endGroup()

        if connection_username is None or connection_username == "":
            connection_username = tools_db.get_current_user()

        return connection_username


    def _create_visit_class(self):
        """"""

        # Create the dialog and signals
        self.dlg_manage_visit_class = GwAdminVisitClassUi()
        tools_gw.load_settings(self.dlg_manage_visit_class)

        # Manage widgets
        sql = "SELECT id, id as idval FROM sys_feature_type WHERE classlevel = 1 OR classlevel = 2"
        rows = tools_db.get_rows(sql, commit=True)
        tools_qt.fill_combo_values(self.dlg_manage_visit_class.feature_type, rows, 1)

        sql = "SELECT id, idval FROM om_typevalue WHERE typevalue = 'visit_type'"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_manage_visit_class.visit_type, rows, 1)

        # Open dialog
        tools_gw.open_dialog(self.dlg_manage_visit_class, dlg_name='admin_visitclass')
        return


    # FIXME: Function is entirely commented
    def _create_visit_param(self):
        """"""
        """
        # Create the dialog and signals
        self.dlg_manage_visit_param = MainVisitParamUi()
        tools_gw.load_settings(self.dlg_manage_visit_param)

        # Manage widgets
        sql = "SELECT id, id as idval FROM om_visit_parameter_type"
        rows = tools_db.get_rows(sql, commit=True)
        tools_qt.fill_combo_values(self.dlg_manage_visit_param.parameter_type, rows, 1)

        sql = "SELECT id, idval FROM config_typevalue WHERE typevalue = 'datatype'"
        rows = tools_db.get_rows(sql, commit=True)
        tools_qt.fill_combo_values(self.dlg_manage_visit_param.data_type, rows, 1)

        sql = "SELECT id, idval FROM om_typevalue WHERE typevalue = 'visit_form_type'"
        rows = tools_db.get_rows(sql, commit=True)
        tools_qt.fill_combo_values(self.dlg_manage_visit_param.form_type, rows, 1)

        sql = "SELECT id, idval FROM config_typevalue WHERE typevalue = 'widgettype'"
        rows = tools_db.get_rows(sql, commit=True)
        tools_qt.fill_combo_values(self.dlg_manage_visit_param.widget_type, rows, 1)

        # Set listeners

        # Open dialog
        tools_gw.open_dialog(self.dlg_manage_visit_param, dlg_name='admin_visitparam')
        """

        return


    def _update_visit(self):
        """"""
        return


    def _delete_visit(self):
        """"""
        return


    def _open_update_info(self):
        """"""

        # Create dialog
        self.dlg_readsql_show_info = GwAdminProjectInfoUi()
        tools_gw.load_settings(self.dlg_readsql_show_info)

        info_updates = self.dlg_readsql_show_info.findChild(QTextEdit, 'info_updates')
        self.message_update = ''

        self._read_info_version()

        info_updates.setText(self.message_update)

        if str(self.message_update) == '':
            self.dlg_readsql_show_info.btn_update.setEnabled(False)

        # Set listeners
        self.dlg_readsql_show_info.btn_close.clicked.connect(partial(self._close_dialog_admin, self.dlg_readsql_show_info))
        self.dlg_readsql_show_info.btn_update.clicked.connect(partial(self.update, self.project_type_selected))

        # Set shortcut keys
        self.dlg_readsql_show_info.key_escape.connect(partial(tools_gw.close_dialog, self.dlg_readsql_show_info))

        # Open dialog
        tools_gw.open_dialog(self.dlg_readsql_show_info, dlg_name='admin_projectinfo')


    def _read_info_version(self):
        """"""

        if not os.path.exists(self.folderUpdates):
            tools_qgis.show_message("The update folder was not found in sql folder")
            return

        folders = sorted(os.listdir(self.folderUpdates + ''))
        for folder in folders:
            sub_folders = sorted(os.listdir(self.folderUpdates + folder))
            for sub_folder in sub_folders:
                if str(sub_folder) > str(self.project_version).replace('.', ''):
                    folder_aux = self.folderUpdates + folder + os.sep + sub_folder
                    if self._process_folder(folder_aux, ''):
                        status = self._read_files(sorted(os.listdir(folder_aux + '')), folder_aux + '')
                        if status is False:
                            continue
                else:
                    continue

        return True


    def _close_dialog_admin(self, dlg):
        """ Close dialog """
        tools_gw.close_dialog(dlg)
        self.schema = None


    def _update_locale(self):
        """"""
        # TODO: Check this!
        cmb_locale = tools_qt.get_combo_value(self.dlg_readsql, self.cmb_locale, 0)
        self.folderLocale = self.sql_dir + os.sep + 'i18n' + os.sep + cmb_locale + os.sep


    def _enable_datafile(self):
        """"""

        if self.rdb_import_data.isChecked() is True:
            self.data_file.setEnabled(True)
            self.btn_push_file.setEnabled(True)
        else:
            self.data_file.setEnabled(False)
            self.btn_push_file.setEnabled(False)


    def _populate_data_schema_name(self, widget):
        """"""

        # Get filter
        filter_ = tools_qt.get_text(self.dlg_readsql, widget)
        if filter_ in (None, 'null') and self.schema_type:
            filter_ = self.schema_type
        if filter_ is None:
            return
        # Populate Project data schema Name
        sql = "SELECT schema_name FROM information_schema.schemata"
        rows = tools_db.get_rows(sql)
        if rows is None:
            return

        result_list = []
        for row in rows:
            # projects below 3.4
            sql = (f"SELECT EXISTS (SELECT * FROM information_schema.tables "
                   f"WHERE table_schema = '{row[0]}' "
                   f"AND table_name = 'version')")
            exists = tools_db.get_row(sql)
            if exists and str(exists[0]) == 'True':
                sql = f"SELECT wsoftware FROM {row[0]}.version"
                result = tools_db.get_row(sql)
                if result is not None and result[0] == filter_.upper():
                    elem = [row[0], row[0]]
                    result_list.append(elem)
            # projects upper 3.3
            sql = (f"SELECT EXISTS (SELECT * FROM information_schema.tables "
                   f"WHERE table_schema = '{row[0]}' "
                   f"AND table_name = 'sys_version')")
            exists = tools_db.get_row(sql)
            if exists and str(exists[0]) == 'True':
                sql = f"SELECT project_type FROM {row[0]}.sys_version"
                result = tools_db.get_row(sql)
                if result is not None and result[0] == filter_.upper():
                    elem = [row[0], row[0]]
                    result_list.append(elem)
        if not result_list:
            self.dlg_readsql.project_schema_name.clear()
            return

        tools_qt.fill_combo_values(self.dlg_readsql.project_schema_name, result_list, 1)


    def _manage_srid(self):
        """ Manage SRID configuration """

        self.filter_srid = self.dlg_readsql_create_project.findChild(QLineEdit, 'srid_id')
        tools_qt.set_widget_text(self.dlg_readsql_create_project, self.filter_srid, '25831')
        self.tbl_srid = self.dlg_readsql_create_project.findChild(QTableView, 'tbl_srid')
        self.tbl_srid.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.model_srid = QSqlQueryModel()
        self.tbl_srid.setModel(self.model_srid)
        self.tbl_srid.clicked.connect(partial(self._set_selected_srid))


    def _set_selected_srid(self):

        selected_list = self.tbl_srid.selectionModel().selectedRows()
        selected_row = selected_list[0].row()
        srid = self.tbl_srid.model().record(selected_row).value("SRID")
        tools_qt.set_widget_text(self.dlg_readsql_create_project, self.filter_srid, srid)


    def _filter_srid_changed(self):
        """"""

        filter_value = tools_qt.get_text(self.dlg_readsql_create_project, self.filter_srid)
        if filter_value == 'null':
            filter_value = ''
        sql = ("SELECT substr(srtext, 1, 6) as " + '"Type"' + ", srid as " + '"SRID"' + ", "
               "substr(split_part(srtext, ',', 1), 9) as " + '"Description"' + " "
               "FROM public.spatial_ref_sys "
               "WHERE CAST(srid AS TEXT) LIKE '" + str(filter_value))
        sql += "%'  AND  srtext ILIKE 'PROJCS%' ORDER BY substr(srtext, 1, 6), srid"
        self.last_srids = tools_db.get_rows(sql)

        # Populate Table
        self.model_srid = QSqlQueryModel()
        self.model_srid.setQuery(sql, db=global_vars.qgis_db_credentials)
        self.tbl_srid.setModel(self.model_srid)
        self.tbl_srid.show()


    def _set_info_project(self):
        """"""

        if self.is_service and self.form_enabled is False:
            return

        # set variables from table version
        schema_name = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.project_schema_name)

        # TODO: Make just one SQL query
        self.project_type = tools_gw.get_project_type(schemaname=schema_name)
        self.project_epsg = self._get_project_epsg(schemaname=schema_name)
        self.project_version = self._get_project_version(schemaname=schema_name)
        self.project_language = self._get_project_language(schemaname=schema_name)

        self.postgresql_version = tools_db.get_pg_version()
        self.postgis_version = tools_db.get_postgis_version()

        if schema_name is None:
            schema_name = 'Nothing to select'
            self.project_version = "Version not found"
            tools_qt.enable_tab_by_tab_name(self.dlg_readsql.tab_main, "others", False)

        if schema_name in (None, '', 'null'):
            msg = ('Database version: ' + str(self.postgresql_version) + '\n' + ''
                   'PostGis version:' + str(self.postgis_version) + ' \n \n' + '')
            self.software_version_info.setText(msg)
        else:
            msg = ('Database version: ' + str(self.postgresql_version) + '\n' + ''
                   'PostGis version:' + str(self.postgis_version) + ' \n \n' + ''
                   'Schema name: ' + schema_name + '\n' + ''
                   'Version: ' + self.project_version + ' \n' + ''
                   'EPSG: ' + str(self.project_epsg) + ' \n' + ''
                   'Language: ' + str(self.project_language) + ' \n' + '')

            self.software_version_info.setText(msg)

            # Set label schema name
            self.lbl_schema_name.setText(str(schema_name))

        # Update windowTitle
        window_title = f'Giswater ({self.plugin_version})'
        self.dlg_readsql.setWindowTitle(window_title)

        if schema_name == 'Nothing to select' or schema_name == '' and self.form_enabled:
            tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.lbl_status_text, '')
        elif str(self.plugin_version) > str(self.project_version) and self.form_enabled:
            self.dlg_readsql.lbl_status.setPixmap(self.status_no_update)
            tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.lbl_status_text,
                                     '(Schema version is lower than plugin version, please update schema)')
            self.dlg_readsql.btn_info.setEnabled(True)
        elif str(self.plugin_version) < str(self.project_version) and self.form_enabled:
            self.dlg_readsql.lbl_status.setPixmap(self.status_no_update)
            tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.lbl_status_text,
                                     '(Schema version is higher than plugin version, please update plugin)')
            self.dlg_readsql.btn_info.setEnabled(False)
        elif self.form_enabled:
            self.dlg_readsql.lbl_status.setPixmap(self.status_ok)
            tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.lbl_status_text, '')
            self.dlg_readsql.btn_info.setEnabled(False)


    def _process_folder(self, folderpath, filepattern):
        """"""

        try:
            os.listdir(folderpath + filepattern)
            return True
        except Exception:
            return False


    def _schema_file_to_db(self):
        """"""

        if self.chk_schema_funcion.isChecked():
            self.task1 = GwTask('Manage schema')
            QgsApplication.taskManager().addTask(self.task1)
            self.task1.setProgress(50)
            self._reload_fct_ftrg(self.project_type_selected)
            self.task1.setProgress(100)

        status = (self.error_count == 0)
        self._manage_result_message(status, parameter="Reload")
        if status:
            global_vars.dao.commit()
        else:
            global_vars.dao.rollback()

        # Reset count error variable to 0
        self.error_count = 0


    def _set_signals_create_project(self):
        """"""

        self.dlg_readsql_create_project.btn_cancel_task.clicked.connect(self.cancel_task)
        self.dlg_readsql_create_project.btn_accept.clicked.connect(partial(self.create_project_data_schema))
        self.dlg_readsql_create_project.btn_close.clicked.connect(
            partial(self._close_dialog_admin, self.dlg_readsql_create_project))
        self.dlg_readsql_create_project.btn_push_file.clicked.connect(partial(self._select_file_inp))
        self.cmb_create_project_type.currentIndexChanged.connect(
            partial(self._change_project_type, self.cmb_create_project_type))
        self.cmb_locale.currentIndexChanged.connect(partial(self._update_locale))
        self.rdb_import_data.toggled.connect(partial(self._enable_datafile))
        self.filter_srid.textChanged.connect(partial(self._filter_srid_changed))


    def _open_create_project(self):
        """"""

        # Create dialog and signals
        if self.dlg_readsql_create_project is None:
            self.init_dialog_create_project()

        self._filter_srid_changed()

        # Get project_type from previous dialog
        self.cmb_project_type = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.cmb_project_type)
        tools_qt.set_widget_text(self.dlg_readsql_create_project, self.cmb_create_project_type, self.cmb_project_type)
        self._change_project_type(self.cmb_create_project_type)
        self.connection_name = str(tools_qt.get_text(self.dlg_readsql, self.cmb_connection))

        # Open dialog
        self.dlg_readsql_create_project.setWindowTitle(f"Create Project - {self.connection_name}")
        tools_gw.open_dialog(self.dlg_readsql_create_project, dlg_name='admin_dbproject')


    def _open_rename(self):
        """"""

        # Open rename if schema is updated
        if str(self.plugin_version) != str(self.project_version):
            msg = "The schema version has to be updated to make rename"
            tools_qt.show_info_box(msg, "Info")
            return

        # Create dialog
        self.dlg_readsql_rename = GwAdminRenameProjUi()
        tools_gw.load_settings(self.dlg_readsql_rename)

        schema = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.project_schema_name)

        # Set listeners
        self.dlg_readsql_rename.btn_accept.clicked.connect(partial(self._rename_project_data_schema, schema, None))
        self.dlg_readsql_rename.btn_cancel.clicked.connect(partial(self._close_dialog_admin, self.dlg_readsql_rename))

        # Set shortcut keys
        self.dlg_readsql_rename.key_escape.connect(partial(tools_gw.close_dialog, self.dlg_readsql_rename))

        # Open dialog
        self.dlg_readsql_rename.setWindowTitle(f'Rename project - {schema}')
        tools_gw.open_dialog(self.dlg_readsql_rename, dlg_name='admin_renameproj')


    def _execute_files(self, filedir, i18n=False, no_ct=False, log_folder=True, log_files=True, is_utils=False):
        """"""

        if not os.path.exists(filedir):
            tools_log.log_info("Folder not found", parameter=filedir)
            return True
        if log_folder:
            tools_log.log_info("Processing folder", parameter=filedir)
        filelist = sorted(os.listdir(filedir))
        status = True
        if is_utils:
            schema_name = 'utils'
        elif self.schema is None:
            schema_name = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.project_schema_name)
            schema_name = schema_name.replace('"', '')
        else:
            schema_name = self.schema.replace('"', '')
        self.project_epsg = str(self.project_epsg).replace('"', '')
        if i18n:
            for file in filelist:
                if "utils.sql" in file:
                    if log_files:
                        tools_log.log_info(str(filedir + os.sep + 'utils.sql'))
                    status = self._read_execute_file(filedir, os.sep + 'utils.sql', schema_name, self.project_epsg)
                elif str(self.project_type_selected) + ".sql" in file:
                    if log_files:
                        tools_log.log_info(str(filedir + os.sep + str(self.project_type_selected) + '.sql'))
                    status = self._read_execute_file(filedir, os.sep + str(self.project_type_selected) + '.sql',
                        schema_name, self.project_epsg)
                elif file in ("ddl.sql", "ddlview.sql", "dml.sql", "tablect.sql", "trg.sql"):
                    if log_files:
                        tools_log.log_info(str(filedir + os.sep + file))
                    status = self._read_execute_file(filedir, file, schema_name, self.project_epsg)
                if not status and self.dev_commit is False:
                    return False
        else:

            for file in filelist:
                if ".sql" in file:
                    if (no_ct is True and "tablect.sql" not in file) or no_ct is False:
                        if log_files:
                            tools_log.log_info(str(filedir + os.sep + file))
                        status = self._read_execute_file(filedir, file, schema_name, self.project_epsg)
                        if not status and self.dev_commit is False:
                            return False

        return status


    def _read_execute_file(self, filedir, file, schema_name, project_epsg):
        """"""

        status = False
        f = None
        try:
            filepath = filedir + os.sep + file
            f = open(filepath, 'r', encoding="utf8")
            if f:
                f_to_read = str(f.read().replace("SCHEMA_NAME", schema_name).replace("SRID_VALUE", project_epsg))
                if self.dev_commit is True:
                    status = tools_db.execute_sql(str(f_to_read), filepath=filepath)
                else:
                    status = tools_db.execute_sql(str(f_to_read), commit=False, filepath=filepath)

                if status is False:
                    self.error_count = self.error_count + 1
                    tools_log.log_info(str("_read_execute_file error"), parameter=filepath)
                    tools_log.log_info(str('Message: ' + str(global_vars.session_vars['last_error'])))
                    if self.dev_commit is True:
                        global_vars.dao.rollback()
                    return False
        except Exception as e:
            self.error_count = self.error_count + 1
            tools_log.log_info(str("_read_execute_file exception"), parameter=file)
            tools_log.log_info(str(e))
            if self.dev_commit is True:
                global_vars.dao.rollback()
            status = False
        finally:
            if f:
                f.close()
            return status


    def _read_files(self, filelist, filedir):
        """"""

        if "changelog.txt" in filelist:
            try:
                f = open(filedir + os.sep + 'changelog.txt', 'r')
                if f:
                    f_to_read = str(f.read()) + '\n'
                    self.message_update = self.message_update + '\n' + str(f_to_read)
                else:
                    return False
            except Exception as e:
                tools_log.log_warning("Error _read_files: " + str(e))
                return False

        return True


    def _copy_schema(self):
        """"""

        # Create dialog
        self.dlg_readsql_copy = GwAdminRenameProjUi()
        tools_gw.load_settings(self.dlg_readsql_copy)

        schema = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.project_schema_name)

        # Set listeners
        self.dlg_readsql_copy.btn_accept.clicked.connect(partial(self._copy_project_data_schema, schema))
        self.dlg_readsql_copy.btn_cancel.clicked.connect(partial(self._close_dialog_admin, self.dlg_readsql_copy))

        # Set shortcut keys
        self.dlg_readsql_copy.key_escape.connect(partial(tools_gw.close_dialog, self.dlg_readsql_copy))

        # Open dialog
        self.dlg_readsql_copy.setWindowTitle('Copy project - ' + schema)
        tools_gw.open_dialog(self.dlg_readsql_copy, dlg_name='admin_renameproj')


    def _copy_project_data_schema(self, schema):
        """"""

        new_schema_name = tools_qt.get_text(self.dlg_readsql_copy, self.dlg_readsql_copy.schema_rename_copy)
        sql = "SELECT schema_name, schema_name FROM information_schema.schemata"
        rows = tools_db.get_rows(sql)

        for row in rows:
            if str(new_schema_name) == str(row[0]):
                msg = "This project name alredy exist."
                tools_qt.show_info_box(msg, "Info")
                return
            else:
                continue

        self.task1 = GwTask('Manage schema')
        QgsApplication.taskManager().addTask(self.task1)
        self.task1.setProgress(0)
        extras = f'"parameters":{{"source_schema":"{schema}", "dest_schema":"{new_schema_name}"}}'
        body = tools_gw.create_body(extras=extras)
        self.task1.setProgress(50)
        result = tools_gw.execute_procedure('gw_fct_admin_schema_clone', body,
                                            schema_name=schema, commit=False)
        if not result or result['status'] == 'Failed':
            return
        self.task1.setProgress(100)

        # Show message
        status = (self.error_count == 0)
        self._manage_result_message(status, parameter="Copy project")
        if status:
            global_vars.dao.commit()
            self._populate_data_schema_name(self.cmb_project_type)
            tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.project_schema_name, str(new_schema_name))
            self._set_info_project()
            self._close_dialog_admin(self.dlg_readsql_copy)
        else:
            global_vars.dao.rollback()

        # Reset count error variable to 0
        self.error_count = 0


    def _delete_schema(self):
        """"""

        project_name = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.project_schema_name)
        if project_name is None:
            msg = "Please, select a project to delete"
            tools_qt.show_info_box(msg, "Info")
            return

        msg = f"Are you sure you want delete schema '{project_name}' ?"
        result = tools_qt.show_question(msg, "Info")
        if result:
            sql = f'DROP SCHEMA {project_name} CASCADE;'
            status = tools_db.execute_sql(sql)
            if status:
                msg = "Process finished successfully"
                tools_qt.show_info_box(msg, "Info", parameter="Delete schema")
                self._populate_data_schema_name(self.dlg_readsql.cmb_project_type)
                self._set_info_project()


    def _execute_import_inp(self, accepted, project_name, project_type):
        """"""

        if accepted:

            # Set wait cursor
            self.task1 = GwTask('Manage schema')
            QgsApplication.taskManager().addTask(self.task1)
            self.task1.setProgress(0)

            # Insert inp values into database
            self._insert_inp_into_db(self.file_inp)

            # Execute import data
            if project_type.lower() == 'ws':
                function_name = 'gw_fct_import_epanet_inp'
                extras = '"parameters":{}'
            elif project_type.lower() == 'ud':
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

            body = tools_gw.create_body(extras=extras)
            complet_result = tools_gw.execute_procedure(f"{function_name}", body, self.schema)

            self.task1 = GwTask('Manage schema')
            QgsApplication.taskManager().addTask(self.task1)
            self.task1.setProgress(50)

            if complet_result:

                if complet_result['status'] == 'Failed':
                    msg = f'The importation process have been failed!<br>See Info log for more details.'
                    self._set_log_text(self.dlg_import_inp, complet_result['body']['data'])
                    tools_qt.show_info_box(msg, "Info")
                    global_vars.dao.rollback()
                    self.error_count = 0

                    # Close dialog
                    tools_gw.close_dialog(self.dlg_import_inp)
                    tools_gw.close_dialog(self.dlg_readsql_create_project)
                    return
                self._set_log_text(self.dlg_import_inp, complet_result['body']['data'])
            else:
                self.error_count = self.error_count + 1

            self.task1.setProgress(100)
            # Manage process result
            self._manage_process_result(project_name, project_type)

        else:
            msg = "A rollback on schema will be done."
            tools_qt.show_info_box(msg, "Info")
            global_vars.dao.rollback()
            self.error_count = 0


        # Hide button execute
        self.dlg_import_inp.btn_run.setVisible(False)


    def _create_qgis_template(self):
        """"""

        msg = ("Warning: Are you sure to continue?. This button will update your plugin qgis templates file replacing "
               "all strings defined on the config/dev.config file. Be sure your config file is OK before continue")
        result = tools_qt.show_question(msg, "Info")
        if result:
            # Get dev config file
            setting_file = os.path.join(self.plugin_dir, 'config', 'dev.config')
            if not os.path.exists(setting_file):
                message = "File not found"
                tools_qgis.show_warning(message, parameter=setting_file)
                return

            # Set plugin settings
            self.dev_settings = QSettings(setting_file, QSettings.IniFormat)
            self.dev_settings.setIniCodec(sys.getfilesystemencoding())

            # Get values
            self.folder_path = tools_gw.get_config_parser('system', 'folder_path', "project", "dev", False)
            self.folder_path = self.folder_path.replace('"', '')
            self.text_replace_labels = tools_gw.get_config_parser('qgis_project_text_replace', 'labels', "project",
                                                                  "dev", False)
            self.text_replace_labels = self.text_replace_labels.split(',')
            self.xml_set_labels = tools_gw.get_config_parser('qgis_project_xml_set', 'labels', "project", "dev", False)
            self.xml_set_labels = self.xml_set_labels.split(',')

            if not os.path.exists(self.folder_path):
                message = "Folder not found"
                tools_qgis.show_warning(message, parameter=self.folder_path)
                return

            # Set wait cursor
            self.task1 = GwTask('Manage schema')
            QgsApplication.taskManager().addTask(self.task1)
            self.task1.setProgress(50)

            # Start read files
            qgis_files = sorted(os.listdir(self.folder_path))
            for file in qgis_files:
                tools_log.log_info("Reading file", parameter=file)
                # Open file for read
                f = open(self.folder_path + os.sep + file, 'r')
                if f:
                    f_to_read = str(f.read())

                    # Replace into template text
                    for text_replace in self.text_replace_labels:
                        text_replace = text_replace.replace(" ", "")
                        self.text_replace = tools_gw.get_config_parser('qgis_project_text_replace', text_replace,
                                                                       "project", "dev", False)
                        self.text_replace = self.text_replace.split(',')
                        tools_log.log_info("Replacing template text", parameter=self.text_replace[1])
                        # TODO:: Keep replace or remove it and declare 'qgis_project_text_replace' from 'config/dev.config' without '"'.
                        #  Example: "dbname='giswater3'", "dbname='__DBNAME__'" or dbname='giswater3', dbname='__DBNAME__'
                        f_to_read = re.sub(str(self.text_replace[0].replace('"', '')),
                                           str(self.text_replace[1].replace('"', '')), f_to_read)

                    for text_replace in self.xml_set_labels:
                        text_replace = text_replace.replace(" ", "")
                        self.text_replace = tools_gw.get_config_parser('qgis_project_xml_set', text_replace, "project",
                                                                       "dev", False)
                        self.text_replace = self.text_replace.split(',')
                        tools_log.log_info("Replacing template text", parameter=self.text_replace[1])
                        # TODO:: Keep replace or remove it and declare 'qgis_project_xml_set' from 'config/dev.config' without '"'.
                        #  Example: "dbname='giswater3'", "dbname='__DBNAME__'" or dbname='giswater3', dbname='__DBNAME__'
                        f_to_read = re.sub(str(self.text_replace[0].replace('"', '')),
                                           str(self.text_replace[1].replace('"', '')), f_to_read)

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
            tools_qt.show_info_box(msg, "Info")


    def _update_manage_ui(self):
        """"""

        schema_name = tools_qt.get_text(self.dlg_readsql, 'project_schema_name')
        if schema_name in (None, 'null', ''):
            tools_qt.enable_tab_by_tab_name(self.dlg_readsql.tab_main, "others", False)
            return
        else:
            tools_qt.enable_tab_by_tab_name(self.dlg_readsql.tab_main, "others", True)

        # Control if schema_version is updated to 3.2
        if str(self.project_version).replace('.', '') < str(self.plugin_version).replace('.', ''):
            tools_qt.get_widget(self.dlg_readsql, self.dlg_readsql.grb_manage_addfields).setEnabled(False)
            tools_qt.get_widget(self.dlg_readsql, self.dlg_readsql.grb_manage_childviews).setEnabled(False)
            tools_qt.get_widget(self.dlg_readsql, self.dlg_readsql.grb_manage_sys_fields).setEnabled(False)

            self.dlg_readsql.cmb_feature_name_view.clear()
            self.dlg_readsql.cmb_formname_fields.clear()
            self.dlg_readsql.cmb_feature_sys_fields.clear()
            return

        else:
            tools_qt.get_widget(self.dlg_readsql, self.dlg_readsql.grb_manage_addfields).setEnabled(True)
            tools_qt.get_widget(self.dlg_readsql, self.dlg_readsql.grb_manage_childviews).setEnabled(True)
            tools_qt.get_widget(self.dlg_readsql, self.dlg_readsql.grb_manage_sys_fields).setEnabled(True)

            if not tools_db.check_table('cat_feature', schema_name):
                tools_log.log_warning(f"Table not found: 'cat_feature'")
                return

            sql = (f"SELECT cat_feature.id, cat_feature.id "
                   f"FROM {schema_name}.cat_feature "
                   f" ORDER BY id")
            rows = tools_db.get_rows(sql)

            tools_qt.fill_combo_values(self.dlg_readsql.cmb_formname_fields, rows, 1)
            tools_qt.fill_combo_values(self.dlg_readsql.cmb_feature_name_view, rows, 1)
            tools_qt.fill_combo_values(self.dlg_readsql.cmb_feature_sys_fields, rows, 1)


    def _create_child_view(self):
        """ Create child view """

        schema_name = tools_qt.get_text(self.dlg_readsql, 'project_schema_name')
        form_name = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.cmb_feature_name_view)

        # Create body
        feature = '"catFeature":"' + form_name + '"'
        if tools_qt.is_checked(self.dlg_readsql, self.dlg_readsql.chk_multi_create):
            extras = '"action":"MULTI-CREATE"'
        else:
            extras = '"action":"SINGLE-CREATE"'
        body = tools_gw.create_body(feature=feature, extras=extras)
        body = body.replace('""', 'null')

        # Execute query
        json_result = tools_gw.execute_procedure('gw_fct_admin_manage_child_views', body,
                                                 schema_name=schema_name, commit=True)
        self._manage_json_message(json_result, title="Create child view")


    def _update_sys_fields(self):
        """"""
        # Create the dialog and signals
        self.dlg_manage_sys_fields = GwAdminSysFieldsUi()
        tools_gw.load_settings(self.dlg_manage_sys_fields)
        self.model_update_table = None
        self.chk_multi_insert = None

        # Remove unused tabs
        form_name_fields = None
        for x in range(self.dlg_manage_sys_fields.tab_sys_add_fields.count() - 1, -1, -1):
            if str(self.dlg_manage_sys_fields.tab_sys_add_fields.widget(x).objectName()) != 'tab_update':
                tab_name = self.dlg_manage_sys_fields.tab_sys_add_fields.widget(x).objectName()
                tools_qt.remove_tab(self.dlg_manage_sys_fields.tab_sys_add_fields, tab_name)
            form_name_fields = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.cmb_feature_sys_fields)

        self._manage_update_field(self.dlg_manage_sys_fields, form_name_fields, tableview='ve_config_sysfields')

        # Set listeners
        self.dlg_manage_sys_fields.btn_cancel.clicked.connect(partial(self._close_dialog_admin, self.dlg_manage_sys_fields))
        self.dlg_manage_sys_fields.btn_accept.clicked.connect(partial(self._close_dialog_admin, self.dlg_manage_sys_fields))
        self.dlg_manage_sys_fields.tbl_update.doubleClicked.connect(
            partial(self._update_selected_sys_fild, self.dlg_manage_sys_fields.tbl_update))
        self.dlg_manage_sys_fields.btn_open.clicked.connect(
            partial(self._update_selected_sys_fild, self.dlg_manage_sys_fields.tbl_update))

        window_title = 'Update field on "' + str(form_name_fields) + '"'
        self.dlg_manage_sys_fields.setWindowTitle(window_title)
        self._manage_update_sys_field(form_name_fields)

        tools_gw.open_dialog(self.dlg_manage_sys_fields)


    def _open_manage_field(self, action):
        """"""

        # Create the dialog and signals
        self.dlg_manage_fields = GwAdminFieldsUi()
        tools_gw.load_settings(self.dlg_manage_fields)
        self.model_update_table = None

        # Remove unused tabs
        for x in range(self.dlg_manage_fields.tab_add_fields.count() - 1, -1, -1):
            if str(self.dlg_manage_fields.tab_add_fields.widget(x).objectName()) != f'tab_{action}':
                tools_qt.remove_tab(
                    self.dlg_manage_fields.tab_add_fields, self.dlg_manage_fields.tab_add_fields.widget(x).objectName())

        form_name_fields = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.cmb_formname_fields)
        self.chk_multi_insert = tools_qt.is_checked(self.dlg_readsql, self.dlg_readsql.chk_multi_insert)

        window_title = ""
        if action == 'create':
            window_title = 'Create field on "' + str(form_name_fields) + '"'
            self._manage_create_field(form_name_fields)
        elif action == 'update':
            window_title = 'Update field on "' + str(form_name_fields) + '"'
            self._manage_update_field(self.dlg_manage_fields, form_name_fields, tableview='ve_config_addfields')
        elif action == 'delete':
            window_title = 'Delete field on "' + str(form_name_fields) + '"'
            self._manage_delete_field(form_name_fields)

        # Set listeners
        self.dlg_manage_fields.btn_accept.clicked.connect(
            partial(self._manage_accept, action, form_name_fields, self.model_update_table))
        self.dlg_manage_fields.btn_cancel.clicked.connect(partial(self._close_dialog_admin, self.dlg_manage_fields))
        self.dlg_manage_fields.tbl_update.doubleClicked.connect(
            partial(self._update_selected_addfild, self.dlg_manage_fields.tbl_update))
        self.dlg_manage_fields.btn_open.clicked.connect(
            partial(self._update_selected_addfild, self.dlg_manage_fields.tbl_update))

        tools_gw.open_dialog(self.dlg_manage_fields, dlg_name='admin_addfields')
        self.dlg_manage_fields.setWindowTitle(window_title)


    # TODO:: Enhance this function and use parametric parameters

    def _update_selected_sys_fild(self, widget):
        """"""

        selected_list = widget.selectionModel().selectedRows()

        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return

        # Create the dialog and signals
        self._close_dialog_admin(self.dlg_manage_sys_fields)
        self.dlg_manage_sys_fields = GwAdminSysFieldsUi()
        tools_gw.load_settings(self.dlg_manage_sys_fields)
        self.model_update_table = None

        form_name_fields = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.cmb_feature_sys_fields)

        # Set listeners
        self.dlg_manage_sys_fields.btn_accept.clicked.connect(
            partial(self._manage_sys_update, form_name_fields))
        self.dlg_manage_sys_fields.btn_cancel.clicked.connect(
            partial(self._manage_close_dlg, self.dlg_manage_sys_fields))

        # Remove unused tabs
        for x in range(self.dlg_manage_sys_fields.tab_sys_add_fields.count() - 1, -1, -1):
            if str(self.dlg_manage_sys_fields.tab_sys_add_fields.widget(x).objectName()) != str('tab_create'):
                tools_qt.remove_tab(self.dlg_manage_sys_fields.tab_sys_add_fields,
                                               self.dlg_manage_sys_fields.tab_sys_add_fields.widget(x).objectName())

        window_title = 'Update field on "' + str(form_name_fields) + '"'
        self.dlg_manage_sys_fields.setWindowTitle(window_title)
        row = selected_list[0].row()

        for column in range(widget.model().columnCount()):
            index = widget.model().index(row, column)

            result = tools_qt.get_widget(self.dlg_manage_sys_fields,
                                        str(widget.model().headerData(column, Qt.Horizontal)))

            if result is None:
                continue

            value = str(widget.model().data(index))

            if value == 'NULL':
                value = None
            tools_qt.set_widget_text(self.dlg_manage_sys_fields, result, value)

        tools_gw.open_dialog(self.dlg_manage_sys_fields)


    def _update_selected_addfild(self, widget):
        """"""

        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return

        # Create the dialog and signals
        self._close_dialog_admin(self.dlg_manage_fields)
        self.dlg_manage_fields = GwAdminFieldsUi()
        tools_gw.load_settings(self.dlg_manage_fields)
        self.model_update_table = None

        form_name_fields = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.cmb_formname_fields)
        self.chk_multi_insert = tools_qt.is_checked(self.dlg_readsql, self.dlg_readsql.chk_multi_insert)
        self.dlg_manage_fields.columnname.setEnabled(False)

        # Set listeners
        self.dlg_manage_fields.btn_accept.clicked.connect(
            partial(self._manage_accept, 'update', form_name_fields, self.model_update_table))
        self.dlg_manage_fields.btn_cancel.clicked.connect(partial(self._manage_close_dlg, self.dlg_manage_fields))

        # Remove unused tabs
        for x in range(self.dlg_manage_fields.tab_add_fields.count() - 1, -1, -1):
            if str(self.dlg_manage_fields.tab_add_fields.widget(x).objectName()) != str('tab_create'):
                tools_qt.remove_tab(self.dlg_manage_fields.tab_add_fields,
                                               self.dlg_manage_fields.tab_add_fields.widget(x).objectName())

        window_title = 'Update field on "' + str(form_name_fields) + '"'
        self.dlg_manage_fields.setWindowTitle(window_title)
        self._manage_create_field(form_name_fields)

        row = selected_list[0].row()

        for column in range(widget.model().columnCount()):
            index = widget.model().index(row, column)

            result = tools_qt.get_widget(self.dlg_manage_fields, str(widget.model().headerData(column, Qt.Horizontal)))
            if result is None:
                continue

            value = str(widget.model().data(index))
            if value == 'NULL':
                value = None
            tools_qt.set_widget_text(self.dlg_manage_fields, result, str(value))

        tools_gw.open_dialog(self.dlg_manage_fields, dlg_name='admin_addfields')


    def _manage_create_field(self, form_name):
        """"""

        schema_name = tools_qt.get_text(self.dlg_readsql, 'project_schema_name')

        # Populate widgettype combo
        sql = (f"SELECT DISTINCT(id), idval FROM {schema_name}.config_typevalue "
               f"WHERE typevalue = 'widgettype_typevalue' AND addparam->>'createAddfield' = 'TRUE'")
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_manage_fields.widgettype, rows, 1)

        # Populate datatype combo
        sql = (f"SELECT id, idval FROM {schema_name}.config_typevalue "
               f"WHERE typevalue = 'datatype_typevalue' AND addparam->>'createAddfield' = 'TRUE'")
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_manage_fields.datatype, rows, 1)

        # Populate layoutname combo
        sql = (f"SELECT id, idval FROM {schema_name}.config_typevalue "
               f"WHERE typevalue = 'layout_name_typevalue' AND addparam->>'createAddfield' = 'TRUE'")
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_manage_fields.layoutname, rows, 1)

        # Set default value for formtype widget
        tools_qt.set_widget_text(self.dlg_manage_fields, self.dlg_manage_fields.formtype, 'feature')


    def _manage_update_sys_field(self, form_name):
        """"""
        # TODO:: Enhance this function and use parametric parameters

        schema_name = tools_qt.get_text(self.dlg_readsql, 'project_schema_name')

        # Populate table update
        qtable = self.dlg_manage_sys_fields.findChild(QTableView, "tbl_update")
        self.model_update_table = QSqlTableModel(db=global_vars.qgis_db_credentials)
        qtable.setSelectionBehavior(QAbstractItemView.SelectRows)
        expr_filter = "cat_feature_id = '" + form_name + "'"
        self.fill_table(qtable, 've_config_sysfields', self.model_update_table, expr_filter)
        tools_gw.set_tablemodel_config(self.dlg_manage_sys_fields, qtable, 've_config_sysfields', schema_name=schema_name)


    def _manage_update_field(self, dialog, form_name, tableview):
        """"""

        if form_name is None:
            return

        schema_name = tools_qt.get_text(self.dlg_readsql, 'project_schema_name')
        if schema_name is None:
            tools_qt.enable_tab_by_tab_name(self.dlg_readsql.tab_main, "others", False)
            return
        else:
            tools_qt.enable_tab_by_tab_name(self.dlg_readsql.tab_main, "others", True)

        # Populate table update
        qtable = dialog.findChild(QTableView, "tbl_update")
        self.model_update_table = QSqlTableModel(db=global_vars.qgis_db_credentials)
        qtable.setSelectionBehavior(QAbstractItemView.SelectRows)

        if self.chk_multi_insert:
            expr_filter = "cat_feature_id IS NULL"
        else:
            expr_filter = "cat_feature_id = '" + form_name + "'"

        self.fill_table(qtable, tableview, self.model_update_table, expr_filter)
        tools_gw.set_tablemodel_config(dialog, qtable, tableview, schema_name=schema_name)


    def _manage_delete_field(self, form_name):
        """"""

        schema_name = tools_qt.get_text(self.dlg_readsql, 'project_schema_name')
        if schema_name is None:
            tools_qt.enable_tab_by_tab_name(self.dlg_readsql.tab_main, "others", False)
            return
        else:
            tools_qt.enable_tab_by_tab_name(self.dlg_readsql.tab_main, "others", True)

        # Populate widgettype combo
        if self.chk_multi_insert:
            sql = (f"SELECT DISTINCT(columnname), columnname "
                   f"FROM {schema_name}.ve_config_addfields "
                   f"WHERE cat_feature_id IS NULL ")
        else:
            sql = (f"SELECT DISTINCT(columnname), columnname "
                   f"FROM {schema_name}.ve_config_addfields "
                   f"WHERE cat_feature_id = '" + form_name + "'")

        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_manage_fields.cmb_fields, rows, 1)


    def _manage_close_dlg(self, dlg_to_close):
        """"""

        self._close_dialog_admin(dlg_to_close)
        if dlg_to_close.objectName() == 'dlg_man_sys_fields':
            self._update_sys_fields()
        elif dlg_to_close.objectName() == 'dlg_man_addfields':
            self._open_manage_field('update')


    def _manage_sys_update(self, form_name):
        """"""

        schema_name = tools_qt.get_text(self.dlg_readsql, 'project_schema_name')
        list_widgets = self.dlg_manage_sys_fields.tab_create.findChildren(QWidget)
        column_id = tools_qt.get_text(self.dlg_manage_sys_fields, self.dlg_manage_sys_fields.columnname)
        sql = f"UPDATE {schema_name}.ve_config_sysfields SET "
        for widget in list_widgets:
            if type(widget) not in (
                    QScrollArea, QFrame, QWidget, QScrollBar, QLabel, QAbstractButton, QHeaderView, QListView,
                    QGroupBox, QTableView) and widget.objectName() not in ('qt_spinbox_lineedit', 'chk_multi_insert'):

                value = None
                if type(widget) in (QLineEdit, QSpinBox, QDoubleSpinBox):
                    value = tools_qt.get_text(self.dlg_manage_sys_fields, widget, return_string_null=False)
                elif type(widget) is QComboBox:
                    value = tools_qt.get_combo_value(self.dlg_manage_sys_fields, widget, 0)
                elif type(widget) is QCheckBox:
                    value = tools_qt.is_checked(self.dlg_manage_sys_fields, widget)
                elif type(widget) is QgsDateTimeEdit:
                    value = tools_qt.get_calendar_date(self.dlg_manage_sys_fields, widget)
                elif type(widget) is QPlainTextEdit:
                    value = widget.document().toPlainText()

                if value in ('null', None, ""):
                    value = "null"
                elif type(widget) is not QCheckBox:
                    value = "'" + value + "'"
                sql += f" {widget.objectName()} = {value},"

        sql = sql[:-1]
        sql += f" WHERE cat_feature_id = '{form_name}' and columnname = '{column_id}'"
        tools_db.execute_sql(sql)

        # Close dialog
        self._close_dialog_admin(self.dlg_manage_sys_fields)
        self._update_sys_fields()


    def _manage_accept(self, action, form_name, model=None):
        """"""

        schema_name = tools_qt.get_text(self.dlg_readsql, 'project_schema_name')

        # Execute manage add fields function
        param_name = tools_qt.get_text(self.dlg_manage_fields, self.dlg_manage_fields.columnname)
        sql = (f"SELECT param_name FROM {schema_name}.sys_addfields "
               f"WHERE param_name = '{param_name}' AND  cat_feature_id = '{form_name}' ")
        row = tools_db.get_row(sql)

        if action == 'create':

            # Control mandatory widgets
            column_name = tools_qt.get_text(self.dlg_manage_fields, self.dlg_manage_fields.columnname)
            label = tools_qt.get_text(self.dlg_manage_fields, self.dlg_manage_fields.label)
            widget_type = tools_qt.get_text(self.dlg_manage_fields, self.dlg_manage_fields.widgettype)
            dv_query_text = tools_qt.get_text(self.dlg_manage_fields, self.dlg_manage_fields.dv_querytext)
            if column_name == 'null' or label == 'null':
                msg = "Column name and Label fields are mandatory. Please set correct value."
                tools_qt.show_info_box(msg, "Info")
                return

            elif row is not None:
                msg = "Column name already exists."
                tools_qt.show_info_box(msg, "Info")
                return

            elif widget_type == 'combo' and dv_query_text in ('null', None):
                msg = "Parameter 'Query text:' is mandatory for 'combo' widgets. Please set value."
                tools_qt.show_info_box(msg, "Info")
                return

            list_widgets = self.dlg_manage_fields.tab_create.findChildren(QWidget)

            _json = {}
            result_json = None
            for widget in list_widgets:
                if type(widget) not in (QScrollArea, QFrame, QWidget, QScrollBar, QLabel, QAbstractButton, QHeaderView, QListView, QGroupBox, QTableView) \
                        and widget.objectName() not in ('qt_spinbox_lineedit', 'chk_multi_insert'):

                    value = None
                    if type(widget) in (QLineEdit, QSpinBox, QDoubleSpinBox):
                        value = tools_qt.get_text(self.dlg_manage_fields, widget, return_string_null=False)
                    elif type(widget) is QComboBox:
                        value = tools_qt.get_combo_value(self.dlg_manage_fields, widget, 0)
                    elif type(widget) is QCheckBox:
                        value = tools_qt.is_checked(self.dlg_manage_fields, widget)
                    elif type(widget) is QgsDateTimeEdit:
                        value = tools_qt.get_calendar_date(self.dlg_manage_fields, widget)
                    elif type(widget) is QPlainTextEdit:
                        value = widget.document().toPlainText()

                    if str(widget.objectName()) not in (None, 'null', '', ""):
                        _json[str(widget.objectName())] = value
                        result_json = json.dumps(_json)

            # Create body
            feature = '"catFeature":"' + form_name + '"'
            extras = '"action":"CREATE", "multiCreate":' + \
                str(self.chk_multi_insert).lower() + ', "parameters":' + result_json + ''
            body = tools_gw.create_body(feature=feature, extras=extras)
            body = body.replace('""', 'null')

            # Execute manage add fields function
            json_result = tools_gw.execute_procedure('gw_fct_admin_manage_addfields', body,
                                                     schema_name=schema_name, commit=True)
            self._manage_json_message(json_result, parameter="Field configured in 'config_form_fields'")
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
                        value = tools_qt.get_text(self.dlg_manage_fields, widget, return_string_null=False)
                    elif type(widget) is QComboBox:
                        value = tools_qt.get_combo_value(self.dlg_manage_fields, widget, 0)
                    elif type(widget) is QCheckBox:
                        value = tools_qt.is_checked(self.dlg_manage_fields, widget)
                    elif type(widget) is QgsDateTimeEdit:
                        value = tools_qt.get_calendar_date(self.dlg_manage_fields, widget)
                    elif type(widget) is QPlainTextEdit:
                        value = widget.document().toPlainText()

                    result_json = None
                    if str(widget.objectName()) not in (None, 'null', '', ""):
                        _json[str(widget.objectName())] = value
                        result_json = json.dumps(_json)

            # Create body
            feature = '"catFeature":"' + form_name + '"'
            extras = '"action":"UPDATE"'
            extras += ', "multiCreate":' + str(self.chk_multi_insert).lower() + ', "parameters":' + result_json + ''
            body = tools_gw.create_body(feature=feature, extras=extras)
            body = body.replace('""', 'null')

            # Execute manage add fields function
            json_result = tools_gw.execute_procedure('gw_fct_admin_manage_addfields', body,
                                                     schema_name=schema_name, commit=True)
            self._manage_json_message(json_result, parameter="Field update in 'config_form_fields'")
            if not json_result or json_result['status'] == 'Failed':
                return

        elif action == 'delete':

            field_value = tools_qt.get_text(self.dlg_manage_fields, self.dlg_manage_fields.cmb_fields)

            # Create body
            feature = '"catFeature":"' + form_name + '"'
            extras = '"action":"DELETE", "multiCreate":' + str(
                self.chk_multi_insert).lower() + ',"parameters":{"columnname":"' + field_value + '"}'
            body = tools_gw.create_body(feature=feature, extras=extras)

            # Execute manage add fields function
            json_result = tools_gw.execute_procedure('gw_fct_admin_manage_addfields', body,
                                                     schema_name=schema_name, commit=True)
            self._manage_json_message(json_result, parameter="Delete function")

        # Close dialog
        self._close_dialog_admin(self.dlg_manage_fields)

        if action == 'update':
            self._open_manage_field('update')


    def _change_project_type(self, widget):
        """ Take current project type changed """

        self.project_type_selected = tools_qt.get_text(self.dlg_readsql, widget)
        self.folderSoftware = self.sql_dir + os.sep + self.project_type_selected + os.sep


    def _insert_inp_into_db(self, folder_path=None):
        """"""

        _file = open(folder_path, "r+", encoding='utf8')
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
                values = "VALUES(239, $$" + target + "$$, "
                for x in range(0, len(sp_n)):
                    if "''" not in sp_n[x]:
                        sql += "csv" + str(x + 1) + ", "
                        value = "$$" + sp_n[x].strip().replace("\n", "") + "$$, "
                        values += value.replace("$$$$", "null")
                    else:
                        sql += "csv" + str(x + 1) + ", "
                        values = "VALUES(null, "
                sql = sql[:-2] + ") "
                values = values[:-2] + ");\n"
                sql += values

            if progress % 500 == 0:
                # TODO:: Use dev_commit or dev_user?
                tools_db.execute_sql(sql, commit=self.dev_commit)
                sql = ""

        if sql != "":
            # TODO:: Use dev_commit or dev_user?
            tools_db.execute_sql(sql, commit=self.dev_commit)

        _file.close()
        del _file


    def _select_file_inp(self):
        """ Select INP file """

        file_inp = tools_qt.get_text(self.dlg_readsql_create_project, 'data_file')
        # Set default value if necessary
        if file_inp is None or file_inp == '':
            file_inp = self.plugin_dir

        # Get directory of that file
        folder_path = os.path.dirname(file_inp)
        if not os.path.exists(folder_path):
            folder_path = os.path.dirname(__file__)
        os.chdir(folder_path)
        message = tools_qt.tr("Select INP file")
        file_inp, filter_ = QFileDialog.getOpenFileName(None, message, "", '*.inp')
        self.dlg_readsql_create_project.data_file.setText(file_inp)


    def _populate_functions_dlg(self, dialog, result):
        """"""

        status = False
        for group, function in result['fields'].items():
            if len(function) != 0:
                dialog.setWindowTitle(function[0]['alias'])
                dialog.txt_info.setText(str(function[0]['descript']))
                self.function_list = []
                tools_gw.build_dialog_options(dialog, function, 0, self.function_list)
                status = True
                break

        return status


    def _set_log_text(self, dialog, data):
        """"""

        for k, v in list(data.items()):
            if str(k) == "info":
                tools_gw.fill_tab_log(dialog, data)


    def _manage_result_message(self, status, msg_ok=None, msg_error=None, parameter=None):
        """ Manage message depending result @status """

        if status:
            if msg_ok is None:
                msg_ok = "Process finished successfully"
            tools_qt.show_info_box(msg_ok, "Info", parameter=parameter)
        else:
            if msg_error is None:
                msg_error = "Process finished with some errors"
            tools_qt.show_info_box(msg_error, "Warning", parameter=parameter)


    def _manage_json_message(self, json_result, parameter=None, title=None):
        """ Manage message depending result @status """

        if 'message' in json_result:

            level = 1
            if 'level' in json_result['message']:
                level = int(json_result['message']['level'])
            if 'text' in json_result['message']:
                msg = json_result['message']['text']
            else:
                msg = "Key on returned json from ddbb is missed"

            tools_qgis.show_message(msg, level, parameter=parameter, title=title)


    def _save_selection(self):
        """"""

        # Save last Project schema name and type selected
        schema_name = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.project_schema_name, False, False)
        project_type = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.cmb_project_type)
        tools_gw.set_config_parser('btn_admin', 'project_type', f'{project_type}', prefix=False)
        tools_gw.set_config_parser('btn_admin', 'schema_name', f'{schema_name}', prefix=False)


    def _create_credentials_form(self, set_connection):
        """"""

        self.dlg_credentials = GwCredentialsUi()
        tools_gw.load_settings(self.dlg_credentials)
        if str(self.list_connections) != '[]':
            tools_qt.fill_combo_values(self.dlg_credentials.cmb_connection, self.list_connections, 1)
        else:
            msg = "You don't have any connection to PostGIS database configurated. " \
                  "Check your QGIS data source manager and create at least one"
            tools_qt.show_info_box(msg, "Info")
            return

        tools_qt.set_widget_text(self.dlg_credentials, self.dlg_credentials.cmb_connection, str(set_connection))

        self.dlg_credentials.btn_accept.clicked.connect(partial(self._set_credentials, self.dlg_credentials))
        self.dlg_credentials.cmb_connection.currentIndexChanged.connect(
            partial(self._set_credentials, self.dlg_credentials, new_connection=True))
        self.dlg_credentials.cmb_sslmode.currentIndexChanged.connect(
            partial(self._set_user_sslmode))

        sslmode_list = [['disable', 'disable'], ['allow', 'allow'], ['prefer', 'prefer'], ['require', 'require'],
                        ['verify - ca', 'verify - ca'], ['verify - full', 'verify - full']]
        tools_qt.fill_combo_values(self.dlg_credentials.cmb_sslmode, sslmode_list, 0)
        sslmode = tools_config.get_user_setting_value('system', 'sslmode', 'prefer')
        tools_qt.set_widget_text(self.dlg_credentials, self.dlg_credentials.cmb_sslmode, sslmode)

        tools_gw.open_dialog(self.dlg_credentials, dlg_name='admin_credentials', maximize_button=False)


    def _set_user_sslmode(self):

        sslmode = tools_qt.get_text(self.dlg_credentials, self.dlg_credentials.cmb_sslmode, 1)
        tools_config.set_config_parser_value('system', 'sslmode', sslmode.strip("'"))


    def _manage_user_params(self):
        """"""

        # Update variable composer_path on config_param_user
        folder_name = os.path.dirname(os.path.abspath(__file__))
        composers_path_vdef = os.path.normpath(os.path.normpath(folder_name + os.sep + os.pardir)) + os.sep + \
            'resources' + os.sep + 'templates' + os.sep + 'qgiscomposer' + os.sep + 'en_US'
        sql = (f"UPDATE {self.schema_name}.config_param_user "
               f"SET value = '{composers_path_vdef}' "
               f"WHERE parameter = 'qgis_composers_folderpath' AND cur_user = current_user")
        tools_db.execute_sql(sql)


    def _get_project_version(self, schemaname=None):
        """ Get project version from table 'version' """

        if schemaname in (None, 'null', ''):
            schemaname = self.schema_name

        project_version = None
        tablename = "sys_version"
        exists = tools_db.check_table(tablename, schemaname)
        if exists:
            sql = ("SELECT giswater FROM " + schemaname + "." + tablename + " ORDER BY id DESC LIMIT 1")
            row = tools_db.get_row(sql)
            if row:
                project_version = row[0]
        else:
            tablename = "version"
            exists = tools_db.check_table(tablename, schemaname)
            if exists:
                sql = ("SELECT giswater FROM " + schemaname + "." + tablename + " ORDER BY id DESC LIMIT 1")
                row = tools_db.get_row(sql)
                if row:
                    project_version = row[0]

        return project_version


    def _get_project_language(self, schemaname=None):
        """ Get project langugage from table 'version' """

        if schemaname in (None, 'null', ''):
            schemaname = self.schema_name

        project_language = None
        tablename = "sys_version"
        exists = tools_db.check_table(tablename, schemaname)
        if exists:
            sql = ("SELECT language FROM " + schemaname + "." + tablename + " ORDER BY id DESC LIMIT 1")
            row = tools_db.get_row(sql)
            if row:
                project_language = row[0]
        else:
            tablename = "version"
            exists = tools_db.check_table(tablename, schemaname)
            if exists:
                sql = ("SELECT language FROM " + schemaname + "." + tablename + " ORDER BY id DESC LIMIT 1")
                row = tools_db.get_row(sql)
                if row:
                    project_language = row[0]

        # profilactic control in order to upgrade all versionS to 3.5 new strategy of locale
        if project_language == 'EN':
            project_language = 'en_US'
        elif project_language == 'ES':
            project_language = 'es_ES'
        elif project_language == 'CA':
            project_language = 'ca_ES'

        return project_language


    def _select_active_locales(self, sqlite_cursor):

        sql = f"SELECT locale as id, name as idval FROM locales WHERE active = 1"
        sqlite_cursor.execute(sql)
        return sqlite_cursor.fetchall()


    def _manage_docker(self):
        """ Puts the dialog in a docker, depending on the user configuration """

        try:
            tools_gw.close_docker()
            global_vars.session_vars['docker_type'] = 'qgis_form_docker'
            global_vars.session_vars['dialog_docker'] = GwDocker()
            global_vars.session_vars['dialog_docker'].dlg_closed.connect(tools_gw.close_docker)
            tools_gw.manage_docker_options()
            tools_gw.docker_dialog(self.dlg_readsql)
            self.dlg_readsql.dlg_closed.connect(tools_gw.close_docker)
        except Exception as e:
            tools_log.log_info(str(e))
            tools_gw.open_dialog(self.dlg_readsql, dlg_name='admin_ui')


    def _manage_utils(self):

        sql = "SELECT schema_name FROM information_schema.schemata"
        rows = tools_db.get_rows(sql)
        if rows is None:
            return

        ws_result_list = []
        ud_result_list = []

        for row in rows:
            sql = (f"SELECT EXISTS (SELECT * FROM information_schema.tables "
                   f"WHERE table_schema = '{row[0]}' "
                   f"AND table_name = 'sys_version')")
            exists = tools_db.get_row(sql)
            if exists and str(exists[0]) == 'True':
                sql = f"SELECT project_type FROM {row[0]}.sys_version"
                result = tools_db.get_row(sql)
                if result is not None and result[0] == 'WS':
                    elem = [row[0], row[0]]
                    ws_result_list.append(elem)
                elif result is not None and result[0] == 'UD':
                    elem = [row[0], row[0]]
                    ud_result_list.append(elem)

        if not ws_result_list:
            self.dlg_readsql.cmb_utils_ws.clear()
        else:
            tools_qt.fill_combo_values(self.dlg_readsql.cmb_utils_ws, ws_result_list, 1)

        if not ud_result_list:
            self.dlg_readsql.cmb_utils_ud.clear()
        else:
            tools_qt.fill_combo_values(self.dlg_readsql.cmb_utils_ud, ud_result_list, 1)


    def _create_utils(self):

        # Manage cmb_utils_projecttypes null values
        ws_project_name = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.cmb_utils_ws, return_string_null=False)
        ud_project_name = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.cmb_utils_ud, return_string_null=False)

        if ws_project_name == "" or ud_project_name == "":
            msg = "You need to have a ws and ud schema created to create a utils schema"
            tools_qgis.show_message(msg, 0)
            return

        # Get giswater version for ws and ud project selected
        ws_project_result = None
        ud_project_result = None

        sql = f"SELECT giswater, language, epsg FROM {ws_project_name}.sys_version ORDER BY id DESC LIMIT 1"
        row = tools_db.get_row(sql)
        if row:
            ws_project_result = row

        sql = f"SELECT giswater, language, epsg FROM {ud_project_name}.sys_version ORDER BY id DESC LIMIT 1"
        row = tools_db.get_row(sql)
        if row:
            ud_project_result = row

        if ws_project_result[0] != ud_project_result[0]:
            msg = f"You need to select same version for ws and ud projects. Versions: WS - {ws_project_result[0]} ; UD - {ud_project_result[0]}"
            tools_qgis.show_message(msg, 0)
            return

        # Check is project name already exists
        sql = (f"SELECT schema_name FROM information_schema.schemata "
               f"WHERE schema_name ILIKE 'utils' ORDER BY schema_name")
        row = tools_db.get_row(sql, commit=False)

        if row:
            msg = f"Schema Utils already exist."
            tools_qgis.show_message(msg, 0)
            return

        # Set background task 'GwCreateSchemaTask'
        description = f"Create schema"
        params = {'is_test': False, 'project_type': 'utils', 'exec_last_process': False,
                  'project_name_schema': 'utils', 'project_locale': ws_project_result[1],
                  'project_srid': ws_project_result[2], 'example_data': False, 'schema_version': None}
        self.task_create_schema = GwCreateSchemaUtilsTask(self, description, params)
        QgsApplication.taskManager().addTask(self.task_create_schema)
        QgsApplication.taskManager().triggerTask(self.task_create_schema)


    def _update_utils(self):

        ws_project_name = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.cmb_utils_ws, return_string_null=False)
        sql = f"SELECT giswater, language, epsg FROM {ws_project_name}.sys_version ORDER BY id DESC LIMIT 1"
        row = tools_db.get_row(sql)
        if row:
            self._update_utils_schema(row[0])


    def _load_base_utils(self):

        folder = f"{self.sql_dir}{os.sep}corporate{os.sep}utils{os.sep}utils"
        status = self._execute_files(folder, is_utils=True)
        if not status and self.dev_commit is False:
            return False
        folder = f"{self.sql_dir}{os.sep}corporate{os.sep}utils{os.sep}utils{os.sep}fct"
        status = self._execute_files(folder, is_utils=True)
        if not status and self.dev_commit is False:
            return False
        folder = f"{self.sql_dir}{os.sep}corporate{os.sep}utils{os.sep}ws"
        status = self._execute_files(folder, is_utils=True)
        if not status and self.dev_commit is False:
            return False
        folder = f"{self.sql_dir}{os.sep}corporate{os.sep}utils{os.sep}ud"
        status = self._execute_files(folder)
        if not status and self.dev_commit is False:
            return False

        return True


    def _update_utils_schema(self, schema_version=None):

        folderUtilsUpdates = f"{self.sql_dir}{os.sep}corporate{os.sep}utils{os.sep}updates{os.sep}"

        if not os.path.exists(folderUtilsUpdates):
            tools_qgis.show_message("The update folder was not found in sql folder")
            self.error_count = self.error_count + 1
            return

        folders = sorted(os.listdir(folderUtilsUpdates + ''))
        for folder in folders:
            sub_folders = sorted(os.listdir(folderUtilsUpdates + folder))
            for sub_folder in sub_folders:
                if schema_version is not None and str(sub_folder) > str(schema_version).replace('.', ''):
                    if self._process_folder(folderUtilsUpdates + folder + os.sep + sub_folder,
                                            os.sep + 'utils' + os.sep):
                        status = self._load_sql(folderUtilsUpdates + folder + os.sep +
                                                sub_folder + os.sep + 'utils' + os.sep, no_ct=no_ct)
                        if status is False:
                            return False
                    if self._process_folder(
                            folderUtilsUpdates + folder + os.sep + sub_folder + os.sep + project_type + os.sep,
                            ''):
                        status = self._load_sql(
                            folderUtilsUpdates + folder + os.sep + sub_folder + os.sep + project_type + os.sep,
                            no_ct=no_ct)
                        if status is False:
                            return False
                    if self._process_folder(
                            folderUtilsUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                    self.locale + os.sep), '') is True:
                        status = self._execute_files(
                            folderUtilsUpdates + folder + os.sep + sub_folder + os.sep + 'i18n' + os.sep + str(
                                self.locale + os.sep), True)
                        if status is False:
                            return False

    # endregion
