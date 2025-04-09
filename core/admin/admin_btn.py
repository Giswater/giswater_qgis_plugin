"""
This file is part of Giswater
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
from sip import isdeleted
from time import time
from datetime import timedelta

from qgis.PyQt.QtCore import QSettings, Qt, QDate, QTimer
from qgis.PyQt.QtGui import QPixmap
from qgis.PyQt.QtSql import QSqlTableModel, QSqlQueryModel
from qgis.PyQt.QtWidgets import QRadioButton, QPushButton, QAbstractItemView, QTextEdit, QFileDialog, \
    QLineEdit, QWidget, QComboBox, QLabel, QCheckBox, QScrollArea, QSpinBox, QAbstractButton, \
    QHeaderView, QListView, QFrame, QScrollBar, QDoubleSpinBox, QPlainTextEdit, QGroupBox, QTableView, QDockWidget, \
    QGridLayout, QTabWidget
from qgis.core import QgsProject, QgsTask, QgsApplication, QgsMessageLog
from qgis.gui import QgsDateTimeEdit
from qgis.utils import reloadPlugin

from .gis_file_create import GwGisFileCreate
from ..threads.task import GwTask
from ..ui.ui_manager import GwAdminUi, GwAdminDbProjectUi, GwAdminRenameProjUi, GwAdminProjectInfoUi, \
    GwAdminGisProjectUi, GwAdminFieldsUi, GwCredentialsUi, GwReplaceInFileUi, GwAdminDbProjectAssetUi, \
    GwAdminDbProjectAuditUi, GwAdminCmProjectUi

from ..utils import tools_gw
from ... import global_vars
from .i18n_generator import GwI18NGenerator
from .schema_i18n_update import GwSchemaI18NUpdate
from .i18n_manager import GwSchemaI18NManager
from .import_osm import GwImportOsm
from ...libs import lib_vars, tools_qt, tools_qgis, tools_log, tools_db, tools_os
from ..ui.docker import GwDocker
from ..threads.project_schema_create import GwCreateSchemaTask
from ..threads.project_schema_asset_create import GwCreateSchemaAssetTask
from ..threads.project_schema_audit_create import GwCreateSchemaAuditTask
from ..threads.project_schema_utils_create import GwCreateSchemaUtilsTask
from ..threads.project_schema_cm_create import GwCreateSchemaCmTask
from ..threads.project_schema_update import GwUpdateSchemaTask
from ..threads.project_schema_copy import GwCopySchemaTask
from ..threads.project_schema_rename import GwRenameSchemaTask


class GwAdminButton:

    def __init__(self):
        """ Class to control toolbar 'om_ws' """

        # Initialize instance attributes
        self.iface = global_vars.iface
        self.settings = global_vars.giswater_settings
        self.plugin_dir = lib_vars.plugin_dir
        self.schema_name = lib_vars.schema_name
        self.plugin_version, self.message = tools_qgis.get_plugin_version()
        self.canvas = global_vars.canvas
        self.project_type = None
        self.project_epsg = None
        self.dlg_readsql = None
        self.dlg_info = None
        self.dlg_readsql_create_project = None
        self.dlg_readsql_create_cm_project = None
        self.project_type_selected = None
        self.schema_type = None
        self.form_enabled = True
        self.lower_postgresql_version = int(tools_qgis.get_plugin_metadata('minorPgVersion', '9.5', lib_vars.plugin_dir)
                                            .replace('.', ''))
        self.upper_postgresql_version = int(tools_qgis.get_plugin_metadata('majorPgVersion', '14.99', lib_vars.plugin_dir)
                                            .replace('.', ''))
        self.total_sql_files = 0    # Total number of SQL files to process
        self.current_sql_file = 0   # Current number of SQL file
        self.progress_value = 0     # (current_sql_file / total_sql_files) * 100
        self.progress_ratio = 0.8   # Ratio to apply to 'progress_value'

    def init_sql(self, set_database_connection=False, username=None, show_dialog=True):
        """ Button 100: Execute SQL. Info show info """

        # Populate combo connections
        default_connection = self._populate_combo_connections()
        # Bug #733 was here
        # Check if connection is still False
        if set_database_connection:
            connection_status, not_version, layer_source = tools_db.set_database_connection()
        else:
            connection_status = lib_vars.session_vars['logged_status']

        settings = QSettings()
        settings.beginGroup(f"PostgreSQL/connections/{default_connection}")
        self.is_service = settings.value('service')
        if not connection_status and not self.is_service:
            self._create_credentials_form(set_connection=default_connection)
            return

        if not connection_status and self.is_service:
            self.form_enabled = False

        # Set label status connection
        self.icon_folder = f"{self.plugin_dir}{os.sep}icons{os.sep}dialogs{os.sep}"
        self.status_ok = QPixmap(f"{self.icon_folder}140.png")
        self.status_ko = QPixmap(f"{self.icon_folder}138.png")
        self.status_no_update = QPixmap(f"{self.icon_folder}139.png")

        # Create the dialog and signals
        self._init_show_database()
        self._info_show_database(connection_status=connection_status, username=username, show_dialog=show_dialog)

    def create_project_data_other_schema(self):
        """ Create other schema """

        project = self.other_project

        setattr(self, f"{project}_schema_name", tools_qt.get_text(getattr(self, f"dlg_readsql_create_{project}_project"), 'project_name'))
        setattr(self, f"{project}_schema_description", tools_qt.get_text(getattr(self, f"dlg_readsql_create_{project}_project"), 'project_descript'))

        # Save in settings
        tools_gw.set_config_parser('btn_admin', f'project_name_{project}_schema', getattr(self, f"{project}_schema_name"), prefix=False)
        tools_gw.set_config_parser('btn_admin', f'{project}_project_descript', getattr(self, f"{project}_schema_description"), prefix=False)

        if not self._check_project_name(getattr(self, f"{project}_schema_name"), getattr(self, f"{project}_schema_description")):
            return

        answer = tools_qt.show_question("This process will take time (few minutes). Are you sure to continue?", f"Create {project} schema")
        if not answer:
            return

        self.create_process(project)

    def create_project_data_cm_schema(self):
        """ Create cm schema """
        self.cm_schema_name = tools_qt.get_text(self.dlg_readsql_create_cm_project, 'project_name')
        self.cm_schema_description = tools_qt.get_text(self.dlg_readsql_create_cm_project, 'project_descript')

        # Save in settings
        tools_gw.set_config_parser('btn_admin', 'project_name_cm_schema', f'{self.cm_schema_name}', prefix=False)
        tools_gw.set_config_parser('btn_admin', 'cm_project_descript', f'{self.cm_schema_description}',
                                   prefix=False)

        if not self._check_project_name(self.cm_schema_name, self.cm_schema_description):
            return

        answer = tools_qt.show_question("This process will take time (few minutes). Are you sure to continue?",
                                        "Create cm schema")
        if not answer:
            return

        self.start_create_cm_project_data_schema_task()

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
        self.folder_locale = os.path.join(self.sql_dir, 'i18n', self.locale)
        self.folder_childviews = os.path.join(self.sql_dir, 'childviews', self.locale)

        # Save in settings
        tools_gw.set_config_parser('btn_admin', 'project_name_schema', f'{project_name_schema}', prefix=False)
        tools_gw.set_config_parser('btn_admin', 'project_descript', f'{project_descript}', prefix=False)
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

        if self.rdb_sample_full.isChecked() or self.rdb_sample_inv.isChecked():
            if self.locale != 'en_US' or str(self.project_epsg) != '25831':
                msg = ("This functionality is only allowed with the locality 'en_US' and SRID 25831."
                       "\nDo you want change it and continue?")
                result = tools_qt.show_question(msg, "Info Message", force_action=True)
                if result:
                    self.project_epsg = '25831'
                    project_srid = '25831'
                    self.locale = 'en_US'
                    project_locale = 'en_US'
                    self.folder_locale = os.path.join(self.sql_dir, 'i18n', project_locale)
                    tools_qt.set_widget_text(self.dlg_readsql_create_project, 'srid_id', '25831')
                    tools_qt.set_combo_value(self.cmb_locale, 'en_US', 0)
                else:
                    return

        params = {'is_test': is_test, 'project_type': project_type, 'exec_last_process': exec_last_process,
                  'project_name_schema': project_name_schema, 'project_locale': project_locale,
                  'project_srid': project_srid, 'example_data': example_data}

        if hasattr(self, 'task_rename_schema') and not isdeleted(self.task_rename_schema):
            self.task_rename_schema.task_finished.connect(partial(self.start_create_project_data_schema_task, project_name_schema, params))
        else:
            self.start_create_project_data_schema_task(project_name_schema, params)

    def start_create_project_data_schema_task(self, project_name_schema, params):
        self.error_count = 0
        # We retrieve the desired name of the schema, since in case there had been a schema with the same name, we had
        # changed the value of self.schema in the function _rename_project_data_schema or _execute_last_process
        self.schema = project_name_schema
        # Set background task 'GwCreateSchemaTask'
        self.t0 = time()
        self.timer = QTimer()
        self.timer.timeout.connect(partial(self._calculate_elapsed_time, self.dlg_readsql_create_project))

        self.timer.start(1000)

        description = f"Create schema"
        self.task_create_schema = GwCreateSchemaTask(self, description, params, timer=self.timer)
        QgsApplication.taskManager().addTask(self.task_create_schema)
        QgsApplication.taskManager().triggerTask(self.task_create_schema)

    def create_process(self, process_name=""):
        self.error_count = 0
        # We retrieve the desired name of the schema, since in case there had been a schema with the same name, we had
        # changed the value of self.schema in the function _rename_project_data_schema or _execute_last_process

        self.t0 = time()
        self.timer = QTimer()
        if hasattr(self, f"{process_name}"):
            self.timer.timeout.connect(partial(self._calculate_elapsed_time, getattr(self, f"dlg_readsql_create_{process_name}_project")))

        self.timer.start(1000)

        description = f"Create {process_name} schema"

        match(process_name):
            case "asset":
               self.task_create_schema = GwCreateSchemaAssetTask(self, description, self.timer)
            case "audit" | "audit_activation":
                list_process = []
                if process_name == "audit":
                    list_process.append('load_audit_structure')
                else:
                    list_process.append('load_audit_activation')

                self.task_create_schema = GwCreateSchemaAuditTask(self, description, self.timer, list_process=list_process)

        QgsApplication.taskManager().addTask(self.task_create_schema)
        QgsApplication.taskManager().triggerTask(self.task_create_schema)

    def start_create_cm_project_data_schema_task(self):
        self.cm_error_count = 0
        # We retrieve the desired name of the schema, since in case there had been a schema with the same name, we had
        # changed the value of self.schema in the function _rename_project_data_schema or _execute_last_process

        # Set background task 'GwCreateSchemaCmTask'
        self.t0 = time()
        self.timer = QTimer()
        self.timer.timeout.connect(partial(self._calculate_elapsed_time, self.dlg_readsql_create_cm_project))

        self.timer.start(1000)

        description = "Create cm schema"
        self.task_create_cm_schema = GwCreateSchemaCmTask(self, description, self.timer)
        QgsApplication.taskManager().addTask(self.task_create_cm_schema)
        QgsApplication.taskManager().triggerTask(self.task_create_cm_schema)

    def manage_process_result(self, project_name, project_type, is_test=False, is_utils=False, dlg=None):
        """"""

        status = (self.error_count == 0)
        self._manage_result_message(status, parameter="Create project")
        if status:
            tools_db.dao.commit()
            if is_utils is False:
                self._close_dialog_admin(self.dlg_readsql_create_project)
            if not is_test:
                self._populate_data_schema_name(self.cmb_project_type)
                self._manage_utils()
                if project_name is not None and is_utils is False:
                    tools_qt.set_widget_text(self.dlg_readsql, 'cmb_project_type', project_type)
                    tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.project_schema_name, project_name)
                    self._set_info_project()
        else:
            tools_db.dao.rollback()
            # Reset count error variable to 0
            self.error_count = 0
            tools_qt.show_exception_message(msg=lib_vars.session_vars['last_error_msg'])
            tools_qgis.show_info("A rollback on schema will be done.")
            if dlg:
                tools_gw.close_dialog(dlg)

    def manage_other_process_result(self):
        """"""

        status = (self.error_count == 0)
        self._manage_result_message(status, parameter=f"Process finished with success")
        if status:
            tools_db.dao.commit()
            if hasattr(self, f"other_project"):
                self._close_dialog_admin(getattr(self, f"dlg_readsql_create_{self.other_project}_project"))
                if self.other_project == "audit":
                    self.dlg_readsql.btn_activate_audit.setEnabled(True)
                    self.dlg_readsql.btn_reload_audit_triggers.setEnabled(True)
                    self.dlg_readsql.btn_create_audit.setEnabled(False)

        else:
            tools_db.dao.rollback()
            # Reset count error variable to 0
            self.error_count = 0
            tools_qt.show_exception_message(msg=lib_vars.session_vars['last_error_msg'])
            tools_qgis.show_info("A rollback on schema will be done.")
            if hasattr(self, f"other_project"):
                tools_gw.close_dialog(getattr(self, f"dlg_readsql_create_{self.other_project}_project"))

    def manage_cm_process_result(self):
        """"""

        status = (self.cm_error_count == 0)
        self._manage_result_message(status, parameter="Create cm schema")
        if status:
            tools_db.dao.commit()
            self._close_dialog_admin(self.dlg_readsql_create_cm_project)
        else:
            tools_db.dao.rollback()
            # Reset count error variable to 0
            self.cm_error_count = 0
            tools_qt.show_exception_message(msg=lib_vars.session_vars['last_error_msg'])
            tools_qgis.show_info("A rollback on schema will be done.")
            if self.dlg_readsql_create_cm_projectdlg:
                tools_gw.close_dialog(self.dlg_readsql_create_cm_project)

    def execute_last_process(self, new_project=False, schema_name=None, schema_type='', locale=False, srid=None):
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
        result = tools_gw.execute_procedure('gw_fct_admin_schema_lastprocess', body, self.schema_name, commit=False)
        if result is None or ('status' in result and result['status'] == 'Failed'):
            self.error_count = self.error_count + 1

        return result

    def cancel_task(self, task_name: str):
        if hasattr(self, task_name):
            task = getattr(self, task_name)
            if not isdeleted(task):
                task.cancel()

    # TODO: Rename this function => Update all versions from changelog file.
    def update(self, project_type):
        """"""

        msg = "Are you sure to update the project schema to last version?"
        result = tools_qt.show_question(msg, "Info")
        if result:
            # Manage Log Messages panel and open tab Giswater PY
            message_log = self.iface.mainWindow().findChild(QDockWidget, 'MessageLog')
            message_log.setVisible(True)
            QgsMessageLog.logMessage("", f"{lib_vars.plugin_name.capitalize()} PY", 0)

            # Manage Log Messages in tab log
            main_tab = self.dlg_readsql_show_info.findChild(QTabWidget, 'mainTab')
            main_tab.setCurrentWidget(main_tab.findChild(QWidget, "tab_loginfo"))
            main_tab.setTabEnabled(main_tab.currentIndex(), True)
            self.infolog_updates = self.dlg_readsql_show_info.findChild(QTextEdit, 'tab_log_txt_infolog')
            self.infolog_updates.setReadOnly(True)
            self.message_infolog = ''
            self.infolog_updates.setText(self.message_infolog)

            # Create timer
            self.t0 = time()
            self.timer = QTimer()
            self.timer.timeout.connect(partial(self._calculate_elapsed_time, self.dlg_readsql_show_info))
            self.timer.start(1000)

            description = f"Update schema"
            params = {'project_type': project_type}
            self.task_update_schema = GwUpdateSchemaTask(self, description, params, timer=self.timer)
            QgsApplication.taskManager().addTask(self.task_update_schema)
            QgsApplication.taskManager().triggerTask(self.task_update_schema)

    def load_updates(self, project_type=None, update_changelog=False, schema_name=None, dict_update_folders=None):
        """"""

        # Get current schema selected
        if schema_name is None:
            schema_name = self._get_schema_name()

        self.schema = schema_name
        self.locale = self.project_language

        self.task1 = GwTask('Manage schema')
        QgsApplication.taskManager().addTask(self.task1)
        self.task1.setProgress(0)
        status = self._load_fct_ftrg()
        self.task1.setProgress(20)
        self.task1.setProgress(40)
        if status:
            status = self.update_dict_folders(False, project_type=project_type, dict_update_folders=dict_update_folders)
        self.task1.setProgress(60)
        if status:
            status = self.execute_last_process(schema_name=schema_name, locale=True)
        self.task1.setProgress(100)

        if update_changelog is False:
            status = (self.error_count == 0)
            self._manage_result_message(status, parameter="Load updates")
            if status:
                tools_db.dao.commit()
            else:
                tools_db.dao.rollback()

            # Reset count error variable to 0
            self.error_count = 0

        return status

    def init_dialog_create_project(self, project_type=None):
        """ Initialize dialog (only once) """

        self.dlg_readsql_create_project = GwAdminDbProjectUi(self)
        tools_gw.load_settings(self.dlg_readsql_create_project)
        self.dlg_readsql_create_project.btn_cancel_task.hide()

        # Find Widgets in form
        self.project_name = self.dlg_readsql_create_project.findChild(QLineEdit, 'project_name')
        self.project_descript = self.dlg_readsql_create_project.findChild(QLineEdit, 'project_descript')
        self.rdb_sample_inv = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_sample_inv')
        self.rdb_sample_full = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_sample_full')
        self.rdb_empty = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_empty')

        # Load user values
        self.project_name.setText(tools_gw.get_config_parser('btn_admin', 'project_name_schema', "user", "session",
                                                             False, force_reload=True))
        self.project_descript.setText(tools_gw.get_config_parser('btn_admin', 'project_descript', "user", "session",
                                                                 False, force_reload=True))
        create_schema_type = tools_gw.get_config_parser('btn_admin', 'create_schema_type', "user", "session", False,
                                                        force_reload=True)
        if create_schema_type:
            chk_widget = self.dlg_readsql_create_project.findChild(QWidget, create_schema_type)
            try:
                chk_widget.setChecked(True)
            except:
                pass

        # TODO: do and call listener for buton + table -> temp_csv

        # Manage SRID
        self._manage_srid()

        # Fill combo 'project_type'
        self.cmb_create_project_type = self.dlg_readsql_create_project.findChild(QComboBox, 'cmb_create_project_type')
        for aux in self.project_types:
            self.cmb_create_project_type.addItem(str(aux))

        if project_type:
            tools_qt.set_widget_text(self.dlg_readsql_create_project, self.cmb_create_project_type, project_type)
            self._change_project_type(self.cmb_create_project_type)

        # Get combo locale
        self.cmb_locale = self.dlg_readsql_create_project.findChild(QComboBox, 'cmb_locale')

        # Populate combo with all locales
        status, sqlite_cur = tools_gw.create_sqlite_conn("config")
        list_locale = self._select_active_locales(sqlite_cur)
        tools_qt.fill_combo_values(self.cmb_locale, list_locale)
        locale = tools_gw.get_config_parser('btn_admin', 'project_locale', 'user', 'session', False, force_reload=True)
        tools_qt.set_combo_value(self.cmb_locale, locale, 0, add_new=False)

        # Set shortcut keys
        self.dlg_readsql_create_project.key_escape.connect(partial(tools_gw.close_dialog, self.dlg_readsql_create_project, False))

        # Get database connection name
        self.connection_name = str(tools_qt.get_text(self.dlg_readsql, self.cmb_connection))

        # Set signals
        self._set_signals_create_project()

    def  init_dialog_create_other_project(self):
        """ Initialize dialog (only once) """
        project = self.other_project

        match (project):
            case "asset":
                dialog = GwAdminDbProjectAssetUi(self)
            case "audit":
                dialog = GwAdminDbProjectAuditUi(self)

        setattr(self, f"dlg_readsql_create_{project}_project", dialog)

        tools_gw.load_settings(dialog)
        dialog.btn_cancel_task.hide()

        # Find Widgets in form
        setattr(self, f"project_{project}_name", dialog.findChild(QLineEdit, 'project_name'))
        setattr(self, f"project_{project}_descript", dialog.findChild(QLineEdit, 'project_descript'))

        # Load user values
        name = tools_gw.get_config_parser('btn_admin', f'project_name_{project}_schema', "user", "session", False, force_reload=True)
        getattr(self, f"project_{project}_name").setText(name)

        descript = tools_gw.get_config_parser('btn_admin', f'{project}_project_descript', "user", "session", False, force_reload=True)
        getattr(self, f"project_{project}_descript").setText(descript)

        # Set shortcut keys
        dialog.key_escape.connect(partial(tools_gw.close_dialog, dialog, False))

        # Set signals
        dialog.btn_cancel_task.clicked.connect(partial(self.cancel_task, f'task_create_{project}_schema'))
        dialog.btn_accept.clicked.connect(partial(self.create_project_data_other_schema))
        dialog.btn_close.clicked.connect(partial(tools_gw.close_dialog, dialog, False))

        return dialog

    def init_dialog_create_cm_project(self):
        """ Initialize dialog (only once) """

        self.dlg_readsql_create_cm_project = GwAdminCmProjectUi(self)
        tools_gw.load_settings(self.dlg_readsql_create_cm_project)
        self.dlg_readsql_create_cm_project.btn_cancel_task.hide()

        # Find Widgets in form
        self.project_cm_name = self.dlg_readsql_create_cm_project.findChild(QLineEdit, 'project_name')
        self.project_cm_descript = self.dlg_readsql_create_cm_project.findChild(QLineEdit, 'project_descript')

        # Load user values
        self.project_cm_name.setText(
            tools_gw.get_config_parser('btn_admin', 'project_name_cm_schema', "user", "session",
                                       False, force_reload=True))
        self.project_cm_descript.setText(
            tools_gw.get_config_parser('btn_admin', 'cm_project_descript', "user", "session",
                                       False, force_reload=True))

        # Set shortcut keys
        self.dlg_readsql_create_cm_project.key_escape.connect(
            partial(tools_gw.close_dialog, self.dlg_readsql_create_cm_project, False))

        # Set signals
        # self.dlg_readsql_create_cm_project.btn_cancel_task.clicked.connect(self.cancel_task)
        self.dlg_readsql_create_cm_project.btn_accept.clicked.connect(partial(self.create_project_data_cm_schema))
        self.dlg_readsql_create_cm_project.btn_close.clicked.connect(
            partial(tools_gw.close_dialog, self.dlg_readsql_create_cm_project, False))

    # region 'Create Project'

    def load_base(self, dict_folders):
        """"""
        for folder in dict_folders.keys():
            status = self._execute_files(folder, set_progress_bar=True)
            if not tools_os.set_boolean(status, False) and tools_os.set_boolean(self.dev_commit, False) is False:
                return False

        return True

    def load_sql_folder(self, dict_folders):
        """"""
        for folder in dict_folders.keys():
            status = self._execute_sql_files(folder, set_progress_bar=True)
            if not tools_os.set_boolean(status, False) and tools_os.set_boolean(self.dev_commit, False) is False:
                return False

        return True

    def load_cm_folder(self, dict_folders):
        """"""
        for folder in dict_folders.keys():
            status = self._execute_cm_files(folder, set_progress_bar=True)
            if not tools_os.set_boolean(status, False) and tools_os.set_boolean(self.dev_commit, False) is False:
                return False

        return True

    def load_locale(self):

        if self._process_folder(self.folder_locale) is False:
            folder_locale = os.path.join(self.sql_dir, 'i18n', 'en_US')
            if self._process_folder(folder_locale) is False:
                return False
            else:
                status = self._execute_files(folder_locale, True, set_progress_bar=True)
                if tools_os.set_boolean(status, False) is False and tools_os.set_boolean(self.dev_commit, False) is False:
                    return False
        else:
            status = self._execute_files(self.folder_locale, True, set_progress_bar=True)
            if tools_os.set_boolean(status, False) is False and tools_os.set_boolean(self.dev_commit, False) is False:
                return False

        return True

    def update_minor_dict_folders(self, folder_update, new_project, project_type, no_ct):

        folder_utils = os.path.join(folder_update, 'utils')
        if self._process_folder(folder_utils) is True:
            status = self._load_sql(folder_utils, no_ct, set_progress_bar=True)
            if tools_os.set_boolean(status, False) is False:
                return False

        if new_project:
            folder_project = project_type
        else:
            folder_project = self.project_type_selected
        folder_project_type = os.path.join(folder_update, folder_project)
        if self._process_folder(folder_project_type):
            status = self._load_sql(folder_project_type, no_ct, set_progress_bar=True)
            if tools_os.set_boolean(status, False) is False:
                return False

        folder_locale = os.path.join(folder_update, 'i18n', self.locale)
        if self._process_folder(folder_locale) is True:
            status = self._execute_files(folder_locale, True, set_progress_bar=True)
            if tools_os.set_boolean(status, False) is False:
                return False

        return True

    def update_dict_folders(self, new_project=False, project_type=False, no_ct=False, dict_update_folders=None):
        """"""

        if not os.path.exists(self.folder_updates):
            tools_qgis.show_message("The update folder was not found in sql folder")
            self.error_count = self.error_count + 1
            return

        for folder in dict_update_folders.keys():
            sub_folders = sorted(os.listdir(folder))
            for sub_folder in sub_folders:
                folder_update = os.path.join(self.folder_updates, folder, sub_folder)
                if new_project:
                    if str(sub_folder) > '31100' and str(sub_folder) <= str(self.plugin_version).replace('.', ''):
                        status = self.update_minor_dict_folders(folder_update, new_project, project_type, no_ct)
                        if tools_os.set_boolean(status, False) is False:
                            return False
                else:
                    if str(sub_folder) > str(self.project_version).replace('.', '') and str(sub_folder) > '31100' and str(sub_folder) <= str(self.plugin_version).replace('.', ''):
                        status = self.update_minor_dict_folders(folder_update, new_project, project_type, no_ct)
                        if tools_os.set_boolean(status, False) is False:
                            return False
        return True

    def load_childviews(self):
        if self._process_folder(self.folder_childviews) is False:
            folder_childviews = os.path.join(self.sql_dir, 'childviews', 'en_US')
            if self._process_folder(folder_childviews) is False:
                return False
            else:
                status = self._execute_files(folder_childviews, True, set_progress_bar=True)
                if tools_os.set_boolean(status, False) is False and tools_os.set_boolean(self.dev_commit, False) is False:
                    return False
        else:
            status = self._execute_files(self.folder_childviews, True, set_progress_bar=True)
            if tools_os.set_boolean(status, False) is False and tools_os.set_boolean(self.dev_commit, False) is False:
                return False

        return True

    def load_sample_data(self, project_type):

        tools_db.dao.commit()
        folder = os.path.join(self.folder_example, 'user', project_type)
        status = self._execute_files(folder, set_progress_bar=True)
        if not tools_os.set_boolean(status, False) and tools_os.set_boolean(self.dev_commit, False) is False:
            return False

        return True

    def load_inv_data(self, project_type):
        tools_db.dao.commit()
        folder = os.path.join(self.folder_example, 'inv', project_type)
        status = self._execute_files(folder, set_progress_bar=True)
        if not tools_os.set_boolean(status, False) and tools_os.set_boolean(self.dev_commit, False) is False:
            return False

        return True

    def load_dev_data(self, project_type):
        """"""

        folder = os.path.join(self.folder_example, 'dev', project_type)
        status = self._execute_files(folder, set_progress_bar=True)
        if not tools_os.set_boolean(status, False) and tools_os.set_boolean(self.dev_commit, False) is False:
            return False

        return True

    # endregion

    # region private functions

    def _fill_table(self, qtable, table_name, model, expr_filter, edit_strategy=QSqlTableModel.OnManualSubmit):
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
            if 'Unable to find table' in model.lastError().text():
                tools_db.reset_qsqldatabase_connection()
            else:
                tools_qgis.show_warning(model.lastError().text())
        # Attach model to table view
        qtable.setModel(model)

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
        self.sql_dir = os.path.normpath(os.path.join(lib_vars.plugin_dir, 'dbmodel'))
        if not os.path.exists(self.sql_dir):
            tools_qgis.show_message(f"SQL folder not found: {self.sql_dir}")
            return

        self.project_version = '0'

        # Get locale of QGIS application
        self.locale = tools_qgis.get_locale()

        # Declare all file variables
        self.file_pattern_ddl = "ddl"
        self.file_pattern_fct = "fct"
        self.file_pattern_ftrg = "ftrg"
        self.file_pattern_schema_model = "schema_model"

        # Declare all folders
        if self.schema_name is not None and self.project_type is not None:
            self.folder_software = os.path.join(self.sql_dir, self.project_type)
        else:
            self.folder_software = ""

        self.folder_locale = os.path.join(self.sql_dir, 'i18n', self.locale)
        self.folder_utils = os.path.join(self.sql_dir, 'utils')
        self.folder_updates = os.path.join(self.sql_dir, 'updates')
        self.folder_example = os.path.join(self.sql_dir, 'example')

        # Declare asset db folders
        self.sql_asset_dir = os.path.join(self.sql_dir, 'am')
        self.folder_base = os.path.join(self.sql_asset_dir, 'base')
        self.folder_i18n = os.path.join(self.sql_asset_dir, 'i18n')
        self.folder_asset_updates = os.path.join(self.sql_asset_dir, 'updates')

        # Declare audit db folders
        self.sql_audit_dir = os.path.join(self.sql_dir, 'corporate', 'audit')
        self.folder_audit_structure = os.path.join(self.sql_audit_dir, 'structure')
        self.folder_audit_activate = os.path.join(self.sql_audit_dir, 'activate')

        # Declare cm db folders (QUE ES ESTO?)
        self.sql_cm_dir = os.path.join(self.sql_dir, 'cm')
        self.folder_utils_cm = os.path.join(self.sql_cm_dir, 'utils')
        self.folder_i18n_cm = os.path.join(self.sql_cm_dir, 'i18n')
        self.folder_example_cm = os.path.join(self.sql_cm_dir, 'example')

        # Variable to commit changes even if schema creation fails
        self.dev_commit = tools_gw.get_config_parser('system', 'force_commit', "user", "init", prefix=True)

        # Create dialog object
        self.dlg_readsql = GwAdminUi(self)
        tools_gw.load_settings(self.dlg_readsql)
        self.cmb_project_type = self.dlg_readsql.findChild(QComboBox, 'cmb_project_type')

        if lib_vars.user_level['level'] not in lib_vars.user_level['showadminadvanced']:
            tools_qt.remove_tab(self.dlg_readsql.tab_main, "tab_advanced")
        if global_vars.gw_dev_mode is not True:
            tools_qt.remove_tab(self.dlg_readsql.tab_main, "tab_dev")

        self.project_types = tools_gw.get_config_parser('system', 'project_types', "project", "giswater", False,
                                                        force_reload=True)
        self.project_types = self.project_types.split(',')

        # Populate combo types
        self.cmb_project_type.clear()
        for aux in self.project_types:
            self.cmb_project_type.addItem(str(aux))

        # Get widgets form
        self.cmb_connection = self.dlg_readsql.findChild(QComboBox, 'cmb_connection')
        self.lbl_schema_name = self.dlg_readsql.findChild(QLabel, 'lbl_schema_name')

        # Checkbox SCHEMA
        self.chk_schema_view = self.dlg_readsql.findChild(QCheckBox, 'chk_schema_view')
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
        self.dlg_readsql.btn_reload_fct_ftrg.clicked.connect(partial(self._reload_fct_ftrg))
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
        self.dlg_readsql.btn_create_qgis_template.clicked.connect(partial(self._create_qgis_template))
        self.dlg_readsql.btn_translation.clicked.connect(partial(self._manage_translations))
        self.dlg_readsql.btn_gis_create.clicked.connect(partial(self._open_form_create_gis_project))
        self.dlg_readsql.dlg_closed.connect(partial(self._save_selection))
        self.dlg_readsql.dlg_closed.connect(partial(self._save_custom_sql_path, self.dlg_readsql))
        self.dlg_readsql.dlg_closed.connect(partial(self._close_dialog_admin, self.dlg_readsql))

        self.dlg_readsql.btn_create_utils.clicked.connect(partial(self._create_utils))
        self.dlg_readsql.btn_update_utils.clicked.connect(partial(self._update_utils))

        self.dlg_readsql.btn_create_field.clicked.connect(partial(self._open_manage_field, 'create'))
        self.dlg_readsql.btn_update_field.clicked.connect(partial(self._open_manage_field, 'update'))
        self.dlg_readsql.btn_delete_field.clicked.connect(partial(self._open_manage_field, 'delete'))
        self.dlg_readsql.btn_update_translation.clicked.connect(partial(self._update_translations))
        self.dlg_readsql.btn_import_osm_streetaxis.clicked.connect(partial(self._import_osm))

        self.dlg_readsql.btn_create_asset.clicked.connect(
            partial(self._open_create_other_project, "Create Asset Project", "admin_assetdbproject", "asset"))

        self.dlg_readsql.btn_create_audit.clicked.connect(
            partial(self._open_create_other_project, "Create Audit Project", "admin_auditdbproject", "audit"))

        self.dlg_readsql.btn_activate_audit.clicked.connect(partial(self._activate_audit))

        self.dlg_readsql.btn_reload_audit_triggers.clicked.connect(partial(self._reload_audit_triggers))

        self.dlg_readsql.btn_create_cm.clicked.connect(partial(self._open_create_cm_project))

        self.dlg_readsql.btn_i18n.clicked.connect(partial(self._i18n_manager))

    def _activate_audit(self):
        """ Activate audit functionality """

        sql = (f"SELECT schema_name, schema_name FROM information_schema.schemata "
               f"WHERE schema_name = 'audit'")
        rows = tools_db.get_rows(sql, commit=False)

        if rows is not None:
            answer = tools_qt.show_question("This process will active snapshot. Are you sure to continue?", f"Activate water netowrk snapshot")
            if not answer:
                return
            self.create_process("audit_activation")
        else:
            tools_qgis.show_warning("Schema audit not found, please create it first")

    def _reload_audit_triggers(self):
        """ Update audit triggers to start or stop auditing a table """

        schema_name = tools_qt.get_text(self.dlg_readsql, 'project_schema_name')
        result = tools_gw.execute_procedure('gw_fct_update_audit_triggers', schema_name=schema_name)

        if result:
            tools_qgis.show_success("Triggers updated successfully")

    def _manage_translations(self):
        """ Initialize the translation functionalities """

        qm_gen = GwI18NGenerator()
        qm_gen.init_dialog()
        dict_info = tools_gw.get_project_info(self._get_schema_name())
        qm_gen.pass_schema_info(dict_info, self._get_schema_name())

    def _update_translations(self):
        """ Initialize the translation functionalities """

        qm_i18n_up = GwSchemaI18NUpdate()
        qm_i18n_up.init_dialog()
        dict_info = tools_gw.get_project_info(self._get_schema_name())
        qm_i18n_up.pass_schema_info(dict_info, self._get_schema_name())

    def _i18n_manager(self):
        """ Initialize the i18n functionalities """

        qm_i18n_manager = GwSchemaI18NManager()
        qm_i18n_manager.init_dialog()

    def _import_osm(self):
        """ Initialize import osm streetaxis functionality """

        dlg_import_osm = GwImportOsm()
        dlg_import_osm.init_dialog(self._get_schema_name())

    def _info_show_database(self, connection_status=True, username=None, show_dialog=False):
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
            tools_qt.fill_combo_values(self.cmb_connection, self.list_connections)

        # Set last connection for default
        tools_qt.set_combo_value(self.cmb_connection, str(last_connection), 1)

        # Set title
        window_title = f'Giswater ({self.plugin_version})'
        self.dlg_readsql.setWindowTitle(window_title)

        self.form_enabled = True
        message = ''

        if self.is_service and connection_status is False:
            self.form_enabled = False
            message = 'There is an error in the configuration of the pgservice file, ' \
                      'please check it or consult your administrator'
            ignore_widgets = ['cmb_connection', 'btn_gis_create', 'cmb_project_type', 'project_schema_name']
            tools_qt.enable_dialog(self.dlg_readsql, False, ignore_widgets)
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

        if not tools_db.check_role(self.username, is_admin=True) and not show_dialog:
            tools_log.log_warning(f"User not found: {self.username}")
            return

        # Check PostgreSQL Version
        if int(self.postgresql_version) not in range(self.lower_postgresql_version, self.upper_postgresql_version) and self.form_enabled:
            message = "Incompatible version of PostgreSQL"
            self.form_enabled = False

        # Check super_user
        super_user = tools_db.check_super_user(self.username)
        force_superuser = tools_gw.get_config_parser('system', 'force_superuser', 'user', 'init', False,
                                                     force_reload=True)
        if not super_user and not force_superuser:
            message = "You don't have permissions to administrate project schemas on this connection"
            self.form_enabled = False

        elif self.form_enabled:
            plugin_version = self.plugin_version
            project_version = self.project_version
            # Only get the x.y.zzz, not x.y.zzz.n
            try:
                plugin_version_l = str(self.plugin_version).split('.')
                if len(plugin_version_l) >= 4:
                    plugin_version = f'{plugin_version_l[0]}'
                    for i in range(1, 3):
                        plugin_version = f"{plugin_version}.{plugin_version_l[i]}"
            except Exception:
                pass
            try:
                project_version_l = str(self.project_version).split('.')
                if len(project_version_l) >= 4:
                    project_version = f'{project_version_l[0]}'
                    for i in range(1, 3):
                        project_version = f"{project_version}.{project_version_l[i]}"
            except Exception:
                pass
            schema_name = tools_qt.get_text(self.dlg_readsql, 'project_schema_name')
            if any(x in str(tools_db.dao_db_credentials['db']) for x in ('.', ',')):
                message = "Database name contains special characters that are not supported"
                self.form_enabled = False
            if schema_name == 'null':
                tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.lbl_status_text, '')
                tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.lbl_schema_name, '')
            elif str(plugin_version) > str(project_version):
                self.dlg_readsql.lbl_status.setPixmap(self.status_no_update)
                tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.lbl_status_text,
                                         '(Schema version is lower than plugin version, please update schema)')
                self.dlg_readsql.btn_info.setEnabled(True)
            elif str(plugin_version) < str(project_version):
                self.dlg_readsql.lbl_status.setPixmap(self.status_no_update)
                tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.lbl_status_text,
                                         '(Schema version is higher than plugin version, please update plugin)')
                self.dlg_readsql.btn_info.setEnabled(True)
            else:
                self.dlg_readsql.lbl_status.setPixmap(self.status_ok)
                tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.lbl_status_text, '')
                self.dlg_readsql.btn_info.setEnabled(False)
            tools_qt.enable_dialog(self.dlg_readsql, True)

        if self.form_enabled is False:
            ignore_widgets = ['cmb_connection', 'btn_gis_create', 'cmb_project_type', 'project_schema_name']
            tools_qt.enable_dialog(self.dlg_readsql, False, ignore_widgets)
            self.dlg_readsql.lbl_status.setPixmap(self.status_ko)
            tools_qt.set_widget_text(self.dlg_readsql, 'lbl_status_text', message)
            tools_qt.set_widget_text(self.dlg_readsql, 'lbl_schema_name', '')

        # Load last schema name selected and project type
        tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.cmb_project_type,
                                 tools_gw.get_config_parser('btn_admin', 'project_type', "user", "session", False,
                                                            force_reload=True))
        tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.project_schema_name,
                                 tools_gw.get_config_parser('btn_admin', 'schema_name', "user", "session", False,
                                                            force_reload=True))

        # Set custom sql path
        folder_path = tools_gw.get_config_parser("btn_admin", "custom_sql_path", "user", "session", force_reload=True)
        tools_qt.set_widget_text(self.dlg_readsql, "custom_path_folder", folder_path)

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
        qgis_file_export = self.dlg_create_gis_project.chk_export_passwd.isChecked()
        tools_gw.set_config_parser('btn_admin', 'qgis_file_export', qgis_file_export, prefix=False)

        gis_file = tools_qt.get_text(self.dlg_create_gis_project, 'txt_gis_file')
        if gis_file is None or gis_file == 'null':
            tools_qgis.show_warning("GIS file name not set")
            return

        project_type = tools_qt.get_text(self.dlg_readsql, 'cmb_project_type')
        schema_name = tools_qt.get_text(self.dlg_readsql, 'project_schema_name')

        # Get roletype and export password
        roletype = tools_qt.get_text(self.dlg_create_gis_project, 'txt_roletype')
        export_passwd = tools_qt.is_checked(self.dlg_create_gis_project, 'chk_export_passwd')

        if export_passwd and not self.is_service:
            msg = "Credentials will be stored in GIS project file. Do you want to continue?"
            answer = tools_qt.show_question(msg, "Warning")
            if not answer:
                return

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
        self.dlg_create_gis_project = GwAdminGisProjectUi(self)
        tools_gw.load_settings(self.dlg_create_gis_project)

        schema_name = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.project_schema_name)
        tools_qt.set_widget_text(self.dlg_create_gis_project, 'txt_gis_file', schema_name)
        qgis_file_path = tools_gw.get_config_parser('btn_admin', 'qgis_file_path', "user", "session", prefix=False,
                                                    force_reload=True)
        if qgis_file_path is None:
            qgis_file_path = os.path.expanduser("~")
        tools_qt.set_widget_text(self.dlg_create_gis_project, 'txt_gis_folder', qgis_file_path)
        qgis_file_export = tools_gw.get_config_parser('btn_admin', 'qgis_file_export', "user", "session", prefix=False,
                                                      force_reload=True)
        qgis_file_export = tools_os.set_boolean(qgis_file_export, False)
        self.dlg_create_gis_project.chk_export_passwd.setChecked(qgis_file_export)
        self.dlg_create_gis_project.txt_gis_folder.setEnabled(False)
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

    def _load_sql(self, path_folder, no_ct=False, utils_schema_name=None, set_progress_bar=False):
        """"""

        for (path, ficheros, archivos) in os.walk(path_folder):
            status = self._execute_files(path, no_ct=no_ct, utils_schema_name=utils_schema_name,
                                         set_progress_bar=set_progress_bar)
            if not tools_os.set_boolean(status, False):
                return False

        return True

    """ Functions execute process """

    def _check_project_name(self, project_name, project_descript):
        """ Check if @project_name and @project_descript are is valid """

        sql = f"SELECT word FROM pg_get_keywords() ORDER BY 1;"
        pg_keywords = tools_db.get_rows(sql, commit=False)

        # Check if project name is valid
        if project_name == 'null':
            msg = "The 'Project_name' field is required."
            tools_qt.show_info_box(msg, "Info")
            return False
        elif any(c.isupper() for c in project_name) is True:
            msg = "The project name can't have any upper-case characters"
            tools_qt.show_info_box(msg, "Info")
            return False
        elif (bool(re.match('^[a-z0-9_]*$', project_name))) is False:
            msg = "The project name has invalid character"
            tools_qt.show_info_box(msg, "Info")
            return False
        elif [project_name] in pg_keywords:
            msg = "The project name can't be a PostgreSQL reserved keyword"
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
        new_name = self._bk_schema_name(list_schemas, f"{project_name}_bk_", 0)

        msg = f"This 'Project_name' is already exist. Do you want rename old schema to '{new_name}"
        result = tools_qt.show_question(msg, "Info", force_action=True)
        if result:
            self._rename_project_data_schema(str(project_name), str(new_name))
            return True
        else:
            return False

    def _bk_schema_name(self, list_schemas, project_name, i):
        """ Check for available bk schema name """

        if f"{project_name}{i}" not in list_schemas:
            return f"{project_name}{i}"
        else:
            return self._bk_schema_name(list_schemas, project_name, i + 1)

    def _rename_project_data_schema(self, schema, create_project=None):
        """"""
        if create_project is None:
            self.schema = tools_qt.get_text(self.dlg_readsql_rename, self.dlg_readsql_rename.schema_rename_copy)
            if str(self.schema) == str(schema):
                msg = "Please, select a diferent project name than current."
                tools_qt.show_info_box(msg, "Info")
                return
        else:
            self.schema = str(create_project)

        # Check if the new project name already exists
        sql = "SELECT schema_name, schema_name FROM information_schema.schemata"
        rows = tools_db.get_rows(sql, commit=self.dev_commit)
        for row in rows:
            if str(self.schema) == str(row[0]):
                msg = "This project name alredy exist."
                tools_qt.show_info_box(msg, "Info")
                return
            else:
                continue

        # Create timer
        self.t0 = time()
        self.timer = QTimer()
        if hasattr(self, 'dlg_readsql_rename') and not isdeleted(self.dlg_readsql_rename) and self.dlg_readsql_rename.isVisible():
            self.timer.timeout.connect(partial(self._calculate_elapsed_time, self.dlg_readsql_rename))
        self.timer.start(1000)

        # Set background task 'GwRenameSchemaTask'
        description = f"Rename schema"
        params = {'schema': schema, 'new_schema_name': self.schema}
        self.task_rename_schema = GwRenameSchemaTask(self, description, params, timer=self.timer)
        QgsApplication.taskManager().addTask(self.task_rename_schema)
        QgsApplication.taskManager().triggerTask(self.task_rename_schema)

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
            tools_db.dao.commit()
        else:
            tools_db.dao.rollback()

        # Reset count error variable to 0
        self.error_count = 0

    def _get_schema_name(self):
        """"""
        schema_name = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.project_schema_name)
        return schema_name

    def _load_fct_ftrg(self):
        """"""

        folder = os.path.join(self.folder_utils, self.file_pattern_fct)

        status = self._execute_files(folder)
        if not tools_os.set_boolean(status, False) and tools_os.set_boolean(self.dev_commit, False) is False:
            return False

        folder = os.path.join(self.folder_utils, self.file_pattern_ftrg)
        status = self._execute_files(folder)
        if not tools_os.set_boolean(status, False) and tools_os.set_boolean(self.dev_commit, False) is False:
            return False

        folder = os.path.join(self.folder_software, self.file_pattern_fct)
        status = self._execute_files(folder)
        if not tools_os.set_boolean(status, False) and tools_os.set_boolean(self.dev_commit, False) is False:
            return False

        folder = os.path.join(self.folder_software, self.file_pattern_ftrg)
        status = self._execute_files(folder)
        if not tools_os.set_boolean(status, False) and tools_os.set_boolean(self.dev_commit, False) is False:
            return False

        return True

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
        try:
            sslmode_dict = {0: 'prefer', 1: 'disable', 3: 'require'}
            sslmode = sslmode_dict.get(sslmode_settings, 'prefer')
        except ValueError:
            sslmode = sslmode_settings
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
            plugin_version = self.plugin_version
            project_version = self.project_version
            # Only get the x.y.zzz, not x.y.zzz.n
            try:
                plugin_version_l = str(self.plugin_version).split('.')
                if len(plugin_version_l) >= 4:
                    plugin_version = f'{plugin_version_l[0]}'
                    for i in range(1, 3):
                        plugin_version = f"{plugin_version}.{plugin_version_l[i]}"
            except Exception:
                pass
            try:
                project_version_l = str(self.project_version).split('.')
                if len(project_version_l) >= 4:
                    project_version = f'{project_version_l[0]}'
                    for i in range(1, 3):
                        project_version = f"{project_version}.{project_version_l[i]}"
            except Exception:
                pass
            if any(x in str(credentials['db']) for x in ('.', ',')):
                message = 'Database name contains special characters that are not supported'
                self.form_enabled = False
            elif str(plugin_version) > str(project_version):
                self.dlg_readsql.lbl_status.setPixmap(self.status_no_update)
                tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.lbl_status_text,
                '(Schema version is lower than plugin version, please update schema)')
                self.dlg_readsql.btn_info.setEnabled(True)
            elif str(plugin_version) < str(project_version):
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

            # Get username
            self.username = self._get_user_connection(connection_name)

            # Check PostgreSQL Version
            self.postgresql_version = tools_db.get_pg_version()
            if int(self.postgresql_version) not in range(self.lower_postgresql_version,
                                                         self.upper_postgresql_version) and self.form_enabled:
                message = "Incompatible version of PostgreSQL"
                self.form_enabled = False

            if self.form_enabled is False:
                ignore_widgets = ['cmb_connection', 'btn_gis_create', 'cmb_project_type', 'project_schema_name']
                tools_qt.enable_dialog(self.dlg_readsql, False, ignore_widgets)
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

    def _open_update_info(self):
        """"""

        # Create dialog
        self.dlg_readsql_show_info = GwAdminProjectInfoUi(self)
        tools_gw.load_settings(self.dlg_readsql_show_info)

        info_updates = self.dlg_readsql_show_info.findChild(QTextEdit, 'info_updates')
        self.message_update = ''

        self._read_info_version()

        info_updates.setText(self.message_update)

        if str(self.message_update) == '':
            self.dlg_readsql_show_info.btn_update.setEnabled(False)

        # Disable tab log
        tools_gw.disable_tab_log(self.dlg_readsql_show_info)

        # Set listeners
        self.dlg_readsql_show_info.btn_close.clicked.connect(partial(self._close_dialog_admin, self.dlg_readsql_show_info))
        self.dlg_readsql_show_info.btn_update.clicked.connect(partial(self.update, self.project_type_selected))

        # Set shortcut keys
        self.dlg_readsql_show_info.key_escape.connect(partial(tools_gw.close_dialog, self.dlg_readsql_show_info))

        # Open dialog
        tools_gw.open_dialog(self.dlg_readsql_show_info, dlg_name='admin_projectinfo')

    def _read_info_version(self):
        """"""

        if not os.path.exists(self.folder_updates):
            tools_qgis.show_message("The update folder was not found in sql folder")
            return

        folders = sorted(os.listdir(self.folder_updates))
        for folder in folders:
            sub_folders = sorted(os.listdir(os.path.join(self.folder_updates, folder)))
            for sub_folder in sub_folders:
                if str(sub_folder) > str(self.project_version).replace('.', ''):
                    folder_aux = os.path.join(self.folder_updates, folder, sub_folder)
                    if self._process_folder(folder_aux):
                        self._read_changelog(sorted(os.listdir(folder_aux)), folder_aux)

        return True

    def _close_dialog_admin(self, dlg):
        """ Close dialog """
        tools_gw.close_dialog(dlg, delete_dlg=False)
        self.schema = None

    def _update_locale(self):
        """"""
        # TODO: Check this!
        cmb_locale = tools_qt.get_combo_value(self.dlg_readsql, self.cmb_locale, 0)
        self.folder_locale = os.path.join(self.sql_dir, 'i18n', cmb_locale)

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
        rows = tools_db.get_rows(sql, commit=self.dev_commit)
        if rows is None:
            return

        result_list = []
        for row in rows:
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
            self._set_buttons_enabled()
            return

        tools_qt.fill_combo_values(self.dlg_readsql.project_schema_name, result_list)
        self._set_buttons_enabled()

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
        self.last_srids = tools_db.get_rows(sql, commit=self.dev_commit)

        # Populate Table
        self.model_srid = QSqlQueryModel()
        self.model_srid.setQuery(sql, db=lib_vars.qgis_db_credentials)
        self.tbl_srid.setModel(self.model_srid)
        self.tbl_srid.show()

    def _set_info_project(self):
        """"""

        if self.is_service and self.form_enabled is False:
            return

        # set variables from table version
        schema_name = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.project_schema_name)

        self.postgresql_version = tools_db.get_pg_version()
        self.postgis_version = tools_db.get_postgis_version()
        self.pgrouting_version = tools_db.get_pgrouting_version()
        tools_db.check_pg_extension('tablefunc')
        tools_db.check_pg_extension('unaccent')
        tools_db.check_pg_extension('fuzzystrmatch')

        if schema_name == 'null':
            tools_qt.enable_tab_by_tab_name(self.dlg_readsql.tab_main, "others", False)

            msg = (f'PostgreSQL version: {self.postgresql_version}\n'
                   f'PostGis version: {self.postgis_version}\n'
                   f'pgRouting version: {self.pgrouting_version}\n \n')
            self.software_version_info.setText(msg)

        else:
            first_dict_info = tools_gw.get_project_info(schema_name, order_direction="ASC")
            last_dict_info = tools_gw.get_project_info(schema_name)

            self.project_type = last_dict_info['project_type']
            self.project_epsg = last_dict_info['project_epsg']
            self.project_version = last_dict_info['project_version']
            self.project_language = last_dict_info['project_language']
            project_date_create = first_dict_info['project_date'].strftime('%d-%m-%Y %H:%M:%S')
            project_date_update = last_dict_info['project_date'].strftime('%d-%m-%Y %H:%M:%S')
            if project_date_create == project_date_update:
                project_date_update = ''
            msg = (f'PostgreSQL version: {self.postgresql_version}\n'
                   f'PostGis version: {self.postgis_version}\n'
                   f'PgRouting version: {self.pgrouting_version}\n \n'
                   f'Schema name: {schema_name}\n'
                   f'Version: {self.project_version}\n'
                   f'EPSG: {self.project_epsg}\n'
                   f'Language: {self.project_language}\n'
                   f'Date of creation: {project_date_create}\n'
                   f'Date of last update: {project_date_update}\n')

            self.software_version_info.setText(msg)

            # Set label schema name
            self.lbl_schema_name.setText(str(schema_name))

        # Update windowTitle
        window_title = f'Giswater ({self.plugin_version})'
        self.dlg_readsql.setWindowTitle(window_title)

        plugin_version = self.plugin_version
        project_version = self.project_version
        # Only get the x.y.zzz, not x.y.zzz.n
        try:
            plugin_version_l = str(self.plugin_version).split('.')
            if len(plugin_version_l) >= 4:
                plugin_version = f'{plugin_version_l[0]}'
                for i in range(1, 3):
                    plugin_version = f"{plugin_version}.{plugin_version_l[i]}"
        except Exception:
            pass
        try:
            project_version_l = str(self.project_version).split('.')
            if len(project_version_l) >= 4:
                project_version = f'{project_version_l[0]}'
                for i in range(1, 3):
                    project_version = f"{project_version}.{project_version_l[i]}"
        except Exception:
            pass

        if schema_name == 'null' and self.form_enabled:
            tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.lbl_status_text, '')
            tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.lbl_schema_name, '')

        elif str(plugin_version) > str(project_version) and self.form_enabled:
            self.dlg_readsql.lbl_status.setPixmap(self.status_no_update)
            tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.lbl_status_text,
                                     '(Schema version is lower than plugin version, please update schema)')
            self.dlg_readsql.btn_info.setEnabled(True)

        elif str(plugin_version) < str(project_version) and self.form_enabled:
            self.dlg_readsql.lbl_status.setPixmap(self.status_no_update)
            tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.lbl_status_text,
                                     '(Schema version is higher than plugin version, please update plugin)')
            self.dlg_readsql.btn_info.setEnabled(False)

        elif self.postgresql_version is None or self.postgis_version is None or self.pgrouting_version is None:
            ignore_widgets = ['cmb_connection', 'btn_gis_create', 'cmb_project_type', 'project_schema_name']
            tools_qt.enable_dialog(self.dlg_readsql, False, ignore_widgets)
            self.dlg_readsql.lbl_status.setPixmap(self.status_ko)
            tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.lbl_status_text,
                                      '(Unable to create one extension. Packages must be installed, consult your administrator)')
            tools_qt.set_widget_text(self.dlg_readsql, 'lbl_schema_name', '')

        elif self.form_enabled:
            self.dlg_readsql.lbl_status.setPixmap(self.status_ok)
            tools_qt.set_widget_text(self.dlg_readsql, self.dlg_readsql.lbl_status_text, '')
            self.dlg_readsql.btn_info.setEnabled(False)

    def _process_folder(self, folderpath, filepattern=''):
        """"""

        try:
            os.listdir(os.path.join(folderpath, filepattern))
            return True
        except Exception:
            return False

    def _reload_fct_ftrg(self):
        """"""
        self._load_fct_ftrg()
        status = (self.error_count == 0)
        if status:
            tools_db.dao.commit()
        else:
            tools_qt.show_info_box("Reload failed", title="Error")
            tools_db.dao.rollback()
            if hasattr(self, 'task_rename_schema'):
                self.task_rename_schema.cancel()

        # Reset count error variable to 0
        self.error_count = 0

    def _set_signals_create_project(self):
        """"""
        self.dlg_readsql_create_project.btn_cancel_task.clicked.connect(partial(self.cancel_task, 'task_create_schema'))
        self.dlg_readsql_create_project.btn_accept.clicked.connect(partial(self.create_project_data_schema))
        self.dlg_readsql_create_project.btn_close.clicked.connect(
            partial(self._close_dialog_admin, self.dlg_readsql_create_project))
        self.cmb_create_project_type.currentIndexChanged.connect(
            partial(self._change_project_type, self.cmb_create_project_type))
        self.cmb_locale.currentIndexChanged.connect(partial(self._update_locale))
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

        self._update_time_elapsed("", self.dlg_readsql_create_project)

        # Open dialog
        self.dlg_readsql_create_project.setWindowTitle(f"Create Project - {self.connection_name}")
        tools_gw.open_dialog(self.dlg_readsql_create_project, dlg_name='admin_dbproject')

    def _open_create_other_project(self, title, dlg_name, other_project):
        """Create Other Project"""

        self.other_project = other_project
        self.init_dialog_create_other_project()

        # Open dialog
        getattr(self, f"dlg_readsql_create_{other_project}_project").setWindowTitle(title)
        tools_gw.open_dialog(getattr(self, f"dlg_readsql_create_{other_project}_project"), dlg_name=dlg_name)

    def _open_create_cm_project(self):
        """Create Cm Project"""

        if self.dlg_readsql_create_cm_project is None:
            self.init_dialog_create_cm_project()

        self._update_time_elapsed("", self.dlg_readsql_create_cm_project)

        # Open dialog
        self.dlg_readsql_create_cm_project.setWindowTitle(f"Create Cm Project")
        tools_gw.open_dialog(self.dlg_readsql_create_cm_project, dlg_name='admin_cmdbproject')

    def _open_rename(self):
        """"""

        # Open rename if schema is updated
        if str(self.plugin_version) != str(self.project_version):
            msg = "The schema version has to be updated to make rename"
            tools_qt.show_info_box(msg, "Info")
            return

        # Create dialog
        self.dlg_readsql_rename = GwAdminRenameProjUi(self)
        tools_gw.load_settings(self.dlg_readsql_rename)

        schema = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.project_schema_name)

        # Set listeners
        self.dlg_readsql_rename.btn_accept.clicked.connect(partial(self._rename_project_data_schema, schema, None))
        self.dlg_readsql_rename.btn_cancel.clicked.connect(partial(self._close_dialog_admin, self.dlg_readsql_rename))

        # Set shortcut keys
        self.dlg_readsql_rename.key_escape.connect(partial(tools_gw.close_dialog, self.dlg_readsql_rename))

        # Open dialog
        self.dlg_readsql_rename.setWindowTitle(f'Rename project - {schema}')
        self.dlg_readsql_rename.schema_rename_copy.setText(schema)
        tools_gw.open_dialog(self.dlg_readsql_rename, dlg_name='admin_renameproj')

    def _execute_files(self, filedir, i18n=False, no_ct=False, utils_schema_name=None, set_progress_bar=False):
        """"""

        if not os.path.exists(filedir):
            tools_log.log_info(f"Folder not found: {filedir}")
            return True
        # Skipping metadata folders for Mac OS
        if '.DS_Store' in filedir:
            return True
        tools_log.log_info(f"Processing folder: {filedir}")
        filelist = sorted(os.listdir(filedir))
        status = True
        if utils_schema_name:
            schema_name = utils_schema_name
        elif self.schema is None:
            schema_name = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.project_schema_name)
            schema_name = schema_name.replace('"', '')
        else:
            schema_name = self.schema.replace('"', '')
        if self.project_epsg:
            self.project_epsg = str(self.project_epsg).replace('"', '')
        else:
            msg = "There is no project selected or it is not valid. Please check the first tab..."
            tools_qgis.show_warning(msg)

        # Manage folders 'i18n'
        manage_i18n = i18n
        if 'i18n' in filedir:
            manage_i18n = True

        if manage_i18n:
            files_to_execute = [f"{self.project_type_selected}_schema_model.sql", f"{self.project_type_selected}_dml.sql", f"dml.sql"]
            for file in files_to_execute:
                status = True
                if file in filelist:
                    tools_log.log_info(os.path.join(filedir, file))
                    self.current_sql_file += 1
                    status = self._read_execute_file(filedir, file, schema_name, self.project_epsg, set_progress_bar)
                if not tools_os.set_boolean(status, False) and tools_os.set_boolean(self.dev_commit, False) is False:
                    return False

        else:
            for file in filelist:
                if ".sql" in file:
                    if (no_ct is True and "tablect.sql" not in file) or no_ct is False:
                        tools_log.log_info(os.path.join(filedir, file))
                        self.current_sql_file += 1
                        status = self._read_execute_file(filedir, file, schema_name, self.project_epsg, set_progress_bar)
                        if not tools_os.set_boolean(status, False) and not tools_os.set_boolean(self.dev_commit, False):
                            return False

        return status

    def _read_execute_file(self, filedir, file, schema_name, project_epsg, set_progress_bar=False):
        """"""

        status = False
        f = None
        try:

            # Manage progress bar
            if set_progress_bar:
                if hasattr(self, 'task_create_schema') and not isdeleted(self.task_create_schema):
                    self.progress_value = int(float(self.current_sql_file / self.total_sql_files) * 100)
                    self.progress_value = int(self.progress_value * self.progress_ratio)
                    self.task_create_schema.set_progress(self.progress_value)

            if hasattr(self, 'task_create_schema') and not isdeleted(self.task_create_schema) and self.task_create_schema.isCanceled():
                return False

            filepath = os.path.join(filedir, file)
            f = open(filepath, 'r', encoding="utf8")
            if f:
                f_to_read = str(f.read().replace("SCHEMA_NAME", schema_name).replace("SRID_VALUE", project_epsg))
                status = tools_db.execute_sql(str(f_to_read), filepath=filepath, commit=self.dev_commit, is_thread=True)
                if tools_os.set_boolean(status, False) is False:
                    self.error_count = self.error_count + 1
                    tools_log.log_info(f"_read_execute_file error {filepath}")
                    tools_log.log_info(f"Message: {lib_vars.session_vars['last_error']}")
                    self.message_infolog = f"_read_execute_file error {filepath}\nMessage: {lib_vars.session_vars['last_error']}"
                    if tools_os.set_boolean(self.dev_commit, False) is False:
                        tools_db.dao.rollback()

                    if hasattr(self, 'task_create_schema') and not isdeleted(self.task_create_schema):
                        self.task_create_schema.db_exception = (lib_vars.session_vars['last_error'], str(f_to_read), filepath)
                        self.task_create_schema.cancel()

                    return False

        except Exception as e:
            self.error_count = self.error_count + 1
            tools_log.log_info(f"_read_execute_file exception: {file}")
            tools_log.log_info(str(e))
            self.message_infolog = f"_read_execute_file exception: {file}\n {str(e)}"
            if tools_os.set_boolean(self.dev_commit, False) is False:
                tools_db.dao.rollback()
            if hasattr(self, 'task_create_schema') and not isdeleted(self.task_create_schema):
                self.task_create_schema.cancel()
            status = False

        finally:
            if f:
                f.close()
            return status

    # QUE ES ESTO, tenog que traer i18n?
    def _execute_cm_files(self, filedir, set_progress_bar=False):
        """"""

        if not os.path.exists(filedir):
            tools_log.log_info(f"Folder not found: {filedir}")
            return True

        tools_log.log_info(f"Processing folder: {filedir}")

        dirlist = sorted(os.listdir(filedir))
        status = True
        # Manage folders 'i18n'
        if 'i18n' in filedir:
            dirlist = [f"{self.project_language}.sql"]
        for folder in dirlist:
            folder_path = os.path.join(filedir, folder)  # Construct full path

            if not os.path.isdir(folder_path):  # Ensure it's a directory
                continue
            filelist = sorted(os.listdir(folder_path))
            for file in filelist:
                if file.endswith(".sql"):
                    filepath = os.path.join(folder_path, file)  # Full path to the SQL file

                    self.current_sql_file += 1
                    status = self._read_execute_cm_file(filepath, set_progress_bar)

                    # If execution fails and dev_commit is False, stop processing
                    if not tools_os.set_boolean(status, False) and not tools_os.set_boolean(self.dev_commit, False):
                        return False

        return status  # Return final status

    def _read_execute_cm_file(self, filepath, set_progress_bar=False):
        """"""

        status = False
        f = None

        PARENT_SCHEMA = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.project_schema_name)
        SCHEMA_SRID = str(self.project_epsg)
        SCHEMA_NAME = self.cm_schema_name

        try:
            # Manage progress bar
            if set_progress_bar:
                if hasattr(self, 'task_create_cm_schema') and not isdeleted(self.task_create_cm_schema):
                    self.progress_value = int(float(self.current_sql_file / self.total_sql_files) * 100)
                    self.progress_value = int(self.progress_value * self.progress_ratio)
                    self.task_create_cm_schema.set_progress(self.progress_value)

            if hasattr(self, 'task_create_cm_schema') and not isdeleted(
                    self.task_create_cm_schema) and self.task_create_cm_schema.isCanceled():
                return False

            f = open(filepath, 'r', encoding="utf8")
            if f:
                f_to_read = str(
                    f.read().replace("SCHEMA_NAME", SCHEMA_NAME).replace("SRID_VALUE", SCHEMA_SRID).replace(
                        "PARENT_SCHEMA", PARENT_SCHEMA))
                status = tools_db.execute_sql(str(f_to_read), filepath=filepath, commit=self.dev_commit, is_thread=True)
                if tools_os.set_boolean(status, False) is False:
                    self.cm_error_count = self.cm_error_count + 1
                    if tools_os.set_boolean(self.dev_commit, False) is False:
                        tools_db.dao.rollback()

                    if hasattr(self, 'task_create_cm_schema') and not isdeleted(self.task_create_cm_schema):
                        self.task_create_cm_schema.db_exception = (
                        lib_vars.session_vars['last_error'], str(f_to_read), filepath)
                        self.task_create_cm_schema.cancel()

                    return False

        except Exception as e:
            self.error_count = self.error_count + 1
            tools_log.log_info(f"_read_execute_file exception: {filepath}")
            tools_log.log_info(str(e))
            self.message_infolog = f"_read_execute_file exception: {filepath}\n {str(e)}"
            if tools_os.set_boolean(self.dev_commit, False) is False:
                tools_db.dao.rollback()
            if hasattr(self, 'task_create_schema') and not isdeleted(self.task_create_schema):
                self.task_create_schema.cancel()
            status = False

        finally:
            if f:
                f.close()
            return status

    def _execute_sql_files(self, filedir, set_progress_bar=False):
        """"""

        if not os.path.exists(filedir):
            tools_log.log_info(f"Folder not found: {filedir}")
            return True

        tools_log.log_info(f"Processing folder: {filedir}")

        filelist = sorted(os.listdir(filedir))
        status = True
        # Manage folders 'i18n'
        if 'i18n' in filedir:
            filelist = [f"{self.project_language}.sql"]
        for file in filelist:
            if ".sql" in file:
                filepath = os.path.join(filedir, file)
                self.current_sql_file += 1
                status = self._read_execute_sql_file(filepath, set_progress_bar)
                if not tools_os.set_boolean(status, False) and not tools_os.set_boolean(self.dev_commit, False):
                    return False

        return status

    def _read_execute_sql_file(self, filepath, set_progress_bar=False):
        """"""

        status = False
        f = None

        PARENT_SCHEMA = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.project_schema_name)
        SCHEMA_SRID = str(self.project_epsg)
        SCHEMA_NAME = ""
        if hasattr(self, f'{self.other_project}_schema_name'):
            SCHEMA_NAME = getattr(self, f'{self.other_project}_schema_name')

        try:
            # Manage progress bar
            if set_progress_bar:
                if hasattr(self, 'task_create_schema') and not isdeleted(self.task_create_schema):
                    self.progress_value = int(float(self.current_sql_file / self.total_sql_files) * 100)
                    self.progress_value = int(self.progress_value * self.progress_ratio)
                    self.task_create_schema.set_progress(self.progress_value)

            if hasattr(self, 'task_create_schema') and not isdeleted(self.task_create_schema) and self.task_create_schema.isCanceled():
                return False

            f = open(filepath, 'r', encoding="utf8")
            if f:
                f_to_read = str(f.read().replace("SCHEMA_NAME", SCHEMA_NAME).replace("SCHEMA_SRID", SCHEMA_SRID).replace("PARENT_SCHEMA", PARENT_SCHEMA))
                status = tools_db.execute_sql(str(f_to_read), filepath=filepath, commit=self.dev_commit, is_thread=True)
                if tools_os.set_boolean(status, False) is False:
                    self.error_count = self.error_count + 1
                    if tools_os.set_boolean(self.dev_commit, False) is False:
                        tools_db.dao.rollback()

                    if hasattr(self, 'task_create_schema') and not isdeleted(self.task_create_schema):
                        self.task_create_schema.db_exception = (lib_vars.session_vars['last_error'], str(f_to_read), filepath)
                        self.task_create_schema.cancel()

                    return False

        except Exception as e:
            self.error_count = self.error_count + 1
            tools_log.log_info(f"_read_execute_file exception: {filepath}")
            tools_log.log_info(str(e))
            self.message_infolog = f"_read_execute_file exception: {filepath}\n {str(e)}"
            if tools_os.set_boolean(self.dev_commit, False) is False:
                tools_db.dao.rollback()
            if hasattr(self, 'task_create_schema') and not isdeleted(self.task_create_schema):
                self.task_create_schema.cancel()
            status = False

        finally:
            if f:
                f.close()
            return status

    def _read_changelog(self, filelist, filedir):
        """ Read contents of file 'changelog.txt' """

        f = None
        if "changelog.txt" not in filelist:
            tools_log.log_warning(f"File 'changelog.txt' not found in: {filedir}")
            return True

        try:
            filepath = os.path.join(filedir, 'changelog.txt')
            f = open(filepath, 'r')
            if f:
                f_to_read = str(f.read()) + '\n'
                self.message_update = self.message_update + '\n' + str(f_to_read)
            else:
                return False
        except Exception as e:
            tools_log.log_warning(f"Error reading file 'changelog.txt': {e}")
            return False
        finally:
            if f:
                f.close()

        return True

    def _copy_schema(self):
        """"""

        # Create dialog
        self.dlg_readsql_copy = GwAdminRenameProjUi(self)
        tools_gw.load_settings(self.dlg_readsql_copy)

        schema = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.project_schema_name)

        # Set listeners
        self.dlg_readsql_copy.btn_accept.clicked.connect(partial(self._copy_project_start, schema))
        self.dlg_readsql_copy.btn_cancel.clicked.connect(partial(self._close_dialog_admin, self.dlg_readsql_copy))

        # Set shortcut keys
        self.dlg_readsql_copy.key_escape.connect(partial(tools_gw.close_dialog, self.dlg_readsql_copy))

        # Open dialog
        self.dlg_readsql_copy.setWindowTitle('Copy project - ' + schema)
        tools_gw.open_dialog(self.dlg_readsql_copy, dlg_name='admin_renameproj')

    def _copy_project_start(self, schema):
        """"""

        new_schema_name = tools_qt.get_text(self.dlg_readsql_copy, self.dlg_readsql_copy.schema_rename_copy)
        sql = "SELECT schema_name, schema_name FROM information_schema.schemata"
        rows = tools_db.get_rows(sql, commit=self.dev_commit)

        for row in rows:
            if str(new_schema_name) == str(row[0]):
                msg = "This project name alredy exist."
                tools_qt.show_info_box(msg, "Info")
                return
            else:
                continue

        # Create timer
        self.t0 = time()
        self.timer = QTimer()
        self.timer.timeout.connect(partial(self._calculate_elapsed_time, self.dlg_readsql_copy))
        self.timer.start(1000)

        # Set background task 'GwCopySchemaTask'
        description = f"Copy schema"
        params = {'schema': schema}
        self.task_copy_schema = GwCopySchemaTask(self, description, params, timer=self.timer)
        QgsApplication.taskManager().addTask(self.task_copy_schema)
        QgsApplication.taskManager().triggerTask(self.task_copy_schema)

    def _delete_schema(self):
        """"""

        project_name = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.project_schema_name)
        if project_name is None:
            msg = "Please, select a project to delete"
            tools_qt.show_info_box(msg, "Info")
            return

        sql = f"SELECT value FROM {project_name}.config_param_system WHERE parameter='admin_isproduction'"
        row = tools_db.get_row(sql)
        if row and tools_os.set_boolean(row[0], default=False):
            msg = f"The schema '{project_name}' is being used in production! It can't be deleted."
            tools_qt.show_info_box(msg, "Warning")
            return

        msg = f"Are you sure you want delete schema '{project_name}' ?"
        result = tools_qt.show_question(msg, "Info", force_action=True)
        if result:
            sql = f'DROP SCHEMA {project_name} CASCADE;'
            status = tools_db.execute_sql(sql)
            if status:
                msg = "Process finished successfully"
                tools_qt.show_info_box(msg, "Info", parameter="Delete schema")
                self._populate_data_schema_name(self.dlg_readsql.cmb_project_type)
                self._manage_utils()
                self._set_info_project()

    def _build_replace_dlg(self, replace_json):

        # Build the dialog
        self.dlg_replace = GwReplaceInFileUi(self)
        self.dlg_replace.setWindowFlags(Qt.WindowStaysOnTopHint)
        tools_gw.load_settings(self.dlg_replace)

        # Add a widget for each word to replace
        self._add_replace_widgets(replace_json)

        # Connect signals
        self.dlg_replace.btn_accept.clicked.connect(partial(self._dlg_replace_accept))
        self.dlg_replace.btn_cancel.clicked.connect(partial(self.dlg_replace.reject))
        self.dlg_replace.finished.connect(partial(tools_gw.save_settings, self.dlg_replace))

        resp = self.dlg_replace.exec_()  # We do exec_() because we want the execution to stop until the dlg is closed
        if resp == 0:
            return False
        return True

    def _add_replace_widgets(self, replace_json):

        idx = 0
        for item in replace_json:
            for key in item:
                # Add section label
                section = key
                section_lbl = QLabel()
                section_lbl.setText(f"<b>{section}</b>")
                field = {"layoutname": 'lyt_replace', "layoutorder": idx}
                tools_gw.add_widget(self.dlg_replace, field, section_lbl, None)
                idx += 1
                for i in item[key]:
                    # Add widget label
                    lbl = QLabel()
                    lbl.setText(f"{i}")
                    # Add widget Line Edit
                    widget = QLineEdit()
                    widget.setObjectName(f"{i}")
                    field = {"layoutname": 'lyt_replace', "layoutorder": idx}

                    tools_gw.add_widget(self.dlg_replace, field, lbl, widget)
                    idx += 1
        # Add final vertical spacer
        spacer = tools_qt.add_verticalspacer()
        lyt_replace = self.dlg_replace.findChild(QGridLayout, 'lyt_replace')
        lyt_replace.addItem(spacer)

    def _dlg_replace_accept(self):

        dict_to_replace_unordered = {}
        for widget in self.dlg_replace.findChildren(QLineEdit):
            dict_to_replace_unordered[f'{widget.objectName()}'] = f'{widget.text()}'

        dict_to_replace = {}
        for k in sorted(dict_to_replace_unordered, key=len, reverse=True):
            dict_to_replace[k] = dict_to_replace_unordered[k]

        all_valid = True
        news = []
        for key in dict_to_replace:
            valid = True
            old = key
            new = dict_to_replace[key]
            if len(new) <= 0:
                # if the string is empty
                tools_qt.set_stylesheet(self.dlg_replace.findChild(QLineEdit, f'{old}'))
                self.dlg_replace.findChild(QLineEdit, f'{old}').setToolTip('Can\'t be empty')
                valid, all_valid = False, False
            elif len(new) > 16:
                # if the string is too long
                tools_qt.set_stylesheet(self.dlg_replace.findChild(QLineEdit, f'{old}'))
                self.dlg_replace.findChild(QLineEdit, f'{old}').setToolTip('Must have less than 16 characters')
                valid, all_valid = False, False
            elif new in news:
                # if the string is duplicated with other new strings
                tools_qt.set_stylesheet(self.dlg_replace.findChild(QLineEdit, f'{old}'))
                self.dlg_replace.findChild(QLineEdit, f'{old}').setToolTip('All new names should be unique')
                valid, all_valid = False, False
            else:
                # Search if the object already exists
                sql = f"SELECT count(csv1) FROM temp_csv WHERE csv1 ILIKE '{new}'"
                row = tools_db.get_row(sql, log_info=False, commit=False)
                if row and row[0] is not None:
                    try:
                        matches = int(row[0])
                        if matches > 0:
                            tools_qt.set_stylesheet(self.dlg_replace.findChild(QLineEdit, f'{old}'))
                            self.dlg_replace.findChild(QLineEdit, f'{old}').setToolTip('Another object has this name')
                            valid, all_valid = False, False
                    except Exception as e:
                        tools_log.log_info(f"{type(e).__name__} --> {e}")
            if valid:
                news.append(new)
                tools_qt.set_stylesheet(self.dlg_replace.findChild(QLineEdit, f'{old}'), style="")
                self.dlg_replace.findChild(QLineEdit, f'{old}').setToolTip('')

        # If none of the new words are in the file
        if all_valid:
            msg = "This will modify your inp file, so a backup will be created.\n" \
                  "Do you want to proceed?"
            if not tools_qt.show_question(msg):
                return

            # Replace the words
            try:
                # Read the contents of the file
                with open(self.file_inp, 'r', encoding='utf-8') as file:
                    contents = file.read()
                # Save a backup of the file
                with open(f"{self.file_inp}.old", 'w', encoding='utf-8') as file:
                    file.write(contents)
                # Replace the words
                for key in dict_to_replace:
                    old = key
                    new = dict_to_replace[key]
                    contents = tools_os.ireplace(old, new, contents)
                # Write the file with new contents
                with open(f"{self.file_inp}", 'w', encoding='utf-8') as file:
                    file.write(contents)
            except Exception as e:
                tools_log.log_error(f"Exception when replacing inp strings: {e}")
            del contents

            # Close the dlg
            self.dlg_replace.accept()

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
            self.folder_path = tools_gw.get_config_parser('system', 'folder_path', "project", "dev", False,
                                                          force_reload=True)

            self.text_replace_labels = tools_gw.get_config_parser('qgis_project_text_replace', 'labels', "project",
                                                                  "dev", False, force_reload=True)
            self.text_replace_labels = self.text_replace_labels.split(',')
            self.xml_set_labels = tools_gw.get_config_parser('qgis_project_xml_set', 'labels', "project", "dev", False,
                                                             force_reload=True)
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
                                                                       "project", "dev", False, force_reload=True)
                        self.text_replace = self.text_replace.split(',')
                        tools_log.log_info("Replacing template text", parameter=self.text_replace[1])
                        f_to_read = re.sub(str(self.text_replace[0]),
                                           str(self.text_replace[1]), f_to_read)

                    for text_replace in self.xml_set_labels:
                        text_replace = text_replace.replace(" ", "")
                        self.text_replace = tools_gw.get_config_parser('qgis_project_xml_set', text_replace, "project",
                                                                       "dev", False, force_reload=True)
                        self.text_replace = self.text_replace.split(',')
                        tools_log.log_info("Replacing template text", parameter=self.text_replace[1])
                        f_to_read = re.sub(str(self.text_replace[0]),
                                           str(self.text_replace[1]), f_to_read)

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
            self.dlg_readsql.cmb_formname_fields.clear()
            return

        else:
            tools_qt.get_widget(self.dlg_readsql, self.dlg_readsql.grb_manage_addfields).setEnabled(True)

            if not tools_db.check_table('cat_feature', schema_name):
                tools_log.log_warning(f"Table not found: 'cat_feature'")
                return

            sql = (f"SELECT cat_feature.id, cat_feature.id "
                   f"FROM {schema_name}.cat_feature WHERE id <> 'LINK' "
                   f"AND active IS TRUE ORDER BY id")
            rows = tools_db.get_rows(sql, commit=self.dev_commit)

            tools_qt.fill_combo_values(self.dlg_readsql.cmb_formname_fields, rows)

    def _open_manage_field(self, action):
        """"""

        # Create the dialog and signals
        self.dlg_manage_fields = GwAdminFieldsUi(self)
        tools_gw.load_settings(self.dlg_manage_fields)
        self.model_update_table = None

        # Remove unused tabs
        for x in range(self.dlg_manage_fields.tab_add_fields.count() - 1, -1, -1):
            if str(self.dlg_manage_fields.tab_add_fields.widget(x).objectName()) not in (f'tab_{action}', 'tab_infolog'):
                tools_qt.remove_tab(
                    self.dlg_manage_fields.tab_add_fields, self.dlg_manage_fields.tab_add_fields.widget(x).objectName())

        form_name_fields = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.cmb_formname_fields)
        is_multi_addfield = tools_qt.is_checked(self.dlg_readsql, self.dlg_readsql.chk_add_fields_multi)

        window_title = ""

        match action:
            case 'create':
                if is_multi_addfield:
                    window_title = f'Create multi field'
                else:
                    window_title = 'Create field on "' + str(form_name_fields) + '"'
                self._manage_create_field(form_name_fields, is_multi_addfield)
            case 'update':
                if is_multi_addfield:
                    window_title = f'Update multi field'
                else:
                    window_title = 'Update field on "' + str(form_name_fields) + '"'
                self._manage_update_field(self.dlg_manage_fields, form_name_fields, is_multi_addfield, tableview='ve_config_addfields')
            case 'delete':
                if is_multi_addfield:
                    window_title = f'Delete multi field'
                else:
                    window_title = 'Delete field on "' + str(form_name_fields) + '"'
                self._manage_delete_field(form_name_fields, is_multi_addfield)
            case _:
                tools_qgis.show_warning("No action detected")

        # Set listeners
        self.dlg_manage_fields.btn_accept.clicked.connect(
            partial(self._manage_accept, action, form_name_fields, is_multi_addfield))
        self.dlg_manage_fields.btn_cancel.clicked.connect(partial(self._close_dialog_admin, self.dlg_manage_fields))
        self.dlg_manage_fields.tbl_update.doubleClicked.connect(
            partial(self._update_selected_addfild, self.dlg_manage_fields.tbl_update, is_multi_addfield))
        self.dlg_manage_fields.btn_open.clicked.connect(
            partial(self._update_selected_addfild, self.dlg_manage_fields.tbl_update, is_multi_addfield))

        tools_gw.open_dialog(self.dlg_manage_fields, dlg_name='admin_addfields')
        self.dlg_manage_fields.setWindowTitle(window_title)

    def _update_selected_addfild(self, widget, is_multi_addfield):
        """"""

        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return

        # Create the dialog and signals
        self._close_dialog_admin(self.dlg_manage_fields)
        self.dlg_manage_fields = GwAdminFieldsUi(self)
        tools_gw.load_settings(self.dlg_manage_fields)
        self.model_update_table = None

        form_name_fields = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.cmb_formname_fields)
        self.dlg_manage_fields.columnname.setEnabled(False)
        self.dlg_manage_fields.datatype.setEnabled(False)
        self.dlg_manage_fields.widgettype.setEnabled(False)

        # Set listeners
        self.dlg_manage_fields.btn_accept.clicked.connect(
            partial(self._manage_accept, 'update', form_name_fields))
        self.dlg_manage_fields.btn_cancel.clicked.connect(partial(self._manage_close_dlg, self.dlg_manage_fields))

        # Remove unused tabs
        for x in range(self.dlg_manage_fields.tab_add_fields.count() - 1, -1, -1):
            if str(self.dlg_manage_fields.tab_add_fields.widget(x).objectName()) not in (str('tab_create'), 'tab_infolog'):
                tools_qt.remove_tab(self.dlg_manage_fields.tab_add_fields,
                                               self.dlg_manage_fields.tab_add_fields.widget(x).objectName())

        if is_multi_addfield:
                window_title = f'Update multi field'
        else:
            window_title = 'Update field on "' + str(form_name_fields) + '"'
        self.dlg_manage_fields.setWindowTitle(window_title)
        self._manage_create_field(form_name_fields, is_multi_addfield)

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

    def _manage_create_field(self, form_name, is_multi_addfield):
        """"""

        schema_name = tools_qt.get_text(self.dlg_readsql, 'project_schema_name')

        # Alter visibility on widget that is only for multicreate action
        self.dlg_manage_fields.lbl_multifeaturetype.setVisible(is_multi_addfield)
        self.dlg_manage_fields.featuretype.setVisible(is_multi_addfield)

        if is_multi_addfield:
             # Populate featuretype combo
            rows = [['ALL', 'ALL'], ['NODE', 'NODE'], ['ARC', 'ARC'], ['CONNEC', 'CONNEC']]
            if self.project_type == 'ud':
                rows += [['GULLY', 'GULLY']]
            tools_qt.fill_combo_values(self.dlg_manage_fields.featuretype, rows)

        # Populate widgettype combo
        sql = (f"SELECT DISTINCT(id), idval FROM {schema_name}.config_typevalue "
               f"WHERE typevalue = 'widgettype_typevalue' AND addparam->>'createAddfield' = 'TRUE'")
        rows = tools_db.get_rows(sql, commit=self.dev_commit)
        tools_qt.fill_combo_values(self.dlg_manage_fields.widgettype, rows)

        # Populate datatype combo
        sql = (f"SELECT id, idval FROM {schema_name}.config_typevalue "
               f"WHERE typevalue = 'datatype_typevalue' AND addparam->>'createAddfield' = 'TRUE'")
        rows = tools_db.get_rows(sql, commit=self.dev_commit)
        tools_qt.fill_combo_values(self.dlg_manage_fields.datatype, rows)

        # Populate layoutname combo
        sql = (f"SELECT id, idval FROM {schema_name}.config_typevalue "
               f"WHERE typevalue = 'layout_name_typevalue' AND addparam->>'createAddfield' = 'TRUE'")
        rows = tools_db.get_rows(sql, commit=self.dev_commit)
        tools_qt.fill_combo_values(self.dlg_manage_fields.layoutname, rows)

        # Set default value for formtype widget
        tools_qt.set_widget_text(self.dlg_manage_fields, self.dlg_manage_fields.formtype, 'feature')

    def _manage_update_field(self, dialog, form_name, is_multi_addfield, tableview):
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
        self.model_update_table = QSqlTableModel(db=lib_vars.qgis_db_credentials)
        qtable.setSelectionBehavior(QAbstractItemView.SelectRows)
        if is_multi_addfield:
            expr_filter = f"cat_feature_id IS NULL"
        else:
            expr_filter = f"cat_feature_id = '{form_name}'"

        self._fill_table(qtable, tableview, self.model_update_table, expr_filter)
        tools_gw.set_tablemodel_config(dialog, qtable, tableview, schema_name=schema_name)

    def _manage_delete_field(self, form_name, is_multi_addfield):
        """"""

        schema_name = tools_qt.get_text(self.dlg_readsql, 'project_schema_name')
        if schema_name is None:
            tools_qt.enable_tab_by_tab_name(self.dlg_readsql.tab_main, "others", False)
            return
        else:
            tools_qt.enable_tab_by_tab_name(self.dlg_readsql.tab_main, "others", True)

        # Populate widgettype combo
        if is_multi_addfield:
            sql = (f"SELECT DISTINCT(columnname), columnname "
                f"FROM {schema_name}.ve_config_addfields "
                f"WHERE cat_feature_id IS NULL")
        else:
            sql = (f"SELECT DISTINCT(columnname), columnname "
                    f"FROM {schema_name}.ve_config_addfields "
                    f"WHERE cat_feature_id = '{form_name}'")

        rows = tools_db.get_rows(sql, commit=self.dev_commit)
        tools_qt.fill_combo_values(self.dlg_manage_fields.cmb_fields, rows)

    def _manage_close_dlg(self, dlg_to_close):
        """"""

        self._close_dialog_admin(dlg_to_close)
        if dlg_to_close.objectName() == 'dlg_man_addfields':
            self._open_manage_field('update')

    def _manage_accept(self, action, form_name, is_multi=False):
        """"""

        schema_name = tools_qt.get_text(self.dlg_readsql, 'project_schema_name')
        # save prev user value
        sql = f"SELECT value FROM {schema_name}.config_param_system WHERE parameter = 'admin_config_control_trigger'"
        row = tools_db.get_row(sql)
        config_trg_user_value = row[0] if row is not None else True
        # set admin_config_control_trigger to true to force config_form_fields trigger
        sql = (f"UPDATE {schema_name}.config_param_system "
               f"SET value = 'TRUE' "
               f"WHERE parameter = 'admin_config_control_trigger'")
        tools_db.execute_sql(sql)

        # Execute manage add fields function
        param_name = tools_qt.get_text(self.dlg_manage_fields, self.dlg_manage_fields.columnname)
        sql = (f"SELECT param_name FROM {schema_name}.sys_addfields "
               f"WHERE param_name = '{param_name}' AND cat_feature_id = '{form_name}' ")
        row = tools_db.get_row(sql)

        # Check feature type selected for multi addfields actions
        if is_multi:
            feature_type = tools_qt.get_selected_item(self.dlg_manage_fields, self.dlg_manage_fields.featuretype)

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
                        and widget.objectName() != 'qt_spinbox_lineedit':

                    value = None

                    if type(widget) in (QLineEdit, QSpinBox, QDoubleSpinBox):
                        value = tools_qt.get_text(self.dlg_manage_fields, widget, return_string_null=False)
                    elif isinstance(widget, QComboBox):
                        value = tools_qt.get_combo_value(self.dlg_manage_fields, widget, 0)
                    elif type(widget) is QCheckBox:
                        value = tools_qt.is_checked(self.dlg_manage_fields, widget)
                    elif isinstance(widget, QgsDateTimeEdit):
                        value = tools_qt.get_calendar_date(self.dlg_manage_fields, widget)
                    elif type(widget) is QPlainTextEdit:
                        value = widget.document().toPlainText()

                    if str(widget.objectName()) not in (None, 'null', '', ""):
                        _json[str(widget.objectName())] = value
                        result_json = json.dumps(_json)

            # Create body
            if is_multi:
                feature = '"featureType":"' + feature_type + '"'
            else:
                feature = '"catFeature":"' + form_name + '"'
            extras = '"action":"CREATE", "parameters":' + result_json + ''
            body = tools_gw.create_body(feature=feature, extras=extras)
            body = body.replace('""', 'null')

            # Execute manage add fields function
            json_result = tools_gw.execute_procedure('gw_fct_admin_manage_addfields', body, schema_name)
            if not json_result or json_result['status'] == 'Failed':
                # set admin_config_control_trigger with prev user value
                sql = (f"UPDATE {schema_name}.config_param_system "
                    f"SET value = '{config_trg_user_value}' "
                    f"WHERE parameter = 'admin_config_control_trigger'")
                tools_db.execute_sql(sql)
                return
            self._manage_json_message(json_result, parameter="Field configured in 'config_form_fields'")

        elif action == 'update':

            list_widgets = self.dlg_manage_fields.tab_create.findChildren(QWidget)

            _json = {}
            result_json = None
            for widget in list_widgets:
                if type(widget) not in (
                        QScrollArea, QFrame, QWidget, QScrollBar, QLabel, QAbstractButton, QHeaderView, QListView, QGroupBox,
                        QTableView) and widget.objectName() != 'qt_spinbox_lineedit':

                    value = None
                    if type(widget) in (QLineEdit, QSpinBox, QDoubleSpinBox):
                        value = tools_qt.get_text(self.dlg_manage_fields, widget, return_string_null=False)
                    elif isinstance(widget, QComboBox):
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
            if is_multi:
                feature = '"featureType":"' + feature_type + '"'
            else:
                feature = '"catFeature":"' + form_name + '"'
            extras = '"action":"UPDATE", "parameters":' + result_json + ''
            body = tools_gw.create_body(feature=feature, extras=extras)
            body = body.replace('""', 'null')

            # Execute manage add fields function
            json_result = tools_gw.execute_procedure('gw_fct_admin_manage_addfields', body, schema_name)
            self._manage_json_message(json_result, parameter="Field update in 'config_form_fields'")
            if not json_result or json_result['status'] == 'Failed':
                return

        elif action == 'delete':

            field_value = tools_qt.get_text(self.dlg_manage_fields, self.dlg_manage_fields.cmb_fields)

            sql = (f"SELECT feature_type FROM {schema_name}.sys_addfields "
                f"WHERE param_name = '{field_value}'")
            feature_type = tools_db.get_row(sql)[0]

            # Create body
            if is_multi:
                feature = '"featureType":"' + feature_type + '"'
            else:
                feature = '"catFeature":"' + form_name + '"'
            extras = '"action":"DELETE", "parameters":{"columnname":"' + field_value + '"}'
            body = tools_gw.create_body(feature=feature, extras=extras)

            # Execute manage add fields function
            json_result = tools_gw.execute_procedure('gw_fct_admin_manage_addfields', body, schema_name)
            self._manage_json_message(json_result, parameter="Delete function")

        # set admin_config_control_trigger with prev user value
        sql = (f"UPDATE {schema_name}.config_param_system "
               f"SET value = '{config_trg_user_value}' "
               f"WHERE parameter = 'admin_config_control_trigger'")
        tools_db.execute_sql(sql)

    def _change_project_type(self, widget):
        """ Take current project type changed """

        self.project_type_selected = tools_qt.get_text(self.dlg_readsql, widget)
        self.folder_software = os.path.join(self.sql_dir, self.project_type_selected)

    def _insert_inp_into_db(self, folder_path=None):
        """"""

        # Convert any file codec to utf-8
        BLOCKSIZE = 1048576  # This is the number of bytes that will be read at a time (for handling big files)
        srcfile = folder_path
        trgfile = f"{folder_path}_utf8"
        from_codec = tools_os.get_encoding_type(folder_path)  # Get file codec

        try:
            with open(srcfile, 'r', encoding=from_codec) as f, open(trgfile, 'w', encoding='utf-8') as e:
                while True:
                    text = f.read(BLOCKSIZE)
                    if not text:
                        break
                    e.write(text)

            os.remove(srcfile)  # remove old encoding file
            os.rename(trgfile, srcfile)  # rename new encoding
        except UnicodeDecodeError:
            tools_qgis.show_warning('Decode error reading inp file')
        except UnicodeEncodeError:
            tools_qgis.show_warning('Encode error reading inp file')

        # Read the file
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
                        # If text in between double-quotes, put all the text in a single column (if tab-separated)
                        if str(list_aux[x]).startswith('"') and str(list_aux[x]).endswith('"'):
                            dirty_list.append(list_aux[x].strip('"'))
                            continue

                        aux = list_aux[x].split(" ")
                        str_aux = ""
                        for i in range(len(aux)):
                            # If the text starts with `;` it means it's the annotation for that line, so we put all
                            # the annotation text in a single string to then insert it to csv39
                            if str(aux[i]).startswith(';'):
                                final_col = ' '.join(aux[i:])
                                dirty_list.append(final_col)
                                break
                            # If text is between double-quotes, insert it without the quotes
                            #     This includes "xxxx" and ""
                            if str(aux[i]).startswith('"') and str(aux[i]).endswith('"'):
                                if aux[i] == '""':
                                    aux[i] = '\n'
                                dirty_list.append(aux[i].strip('"'))
                                continue

                            # If text starts with '"', initialize str_aux variable
                            #     This will insert "xxx yy" as a single string
                            if str(aux[i]).startswith('"'):
                                str_aux = str(aux[i])
                                continue
                            if str_aux:
                                str_aux = f'{str_aux} {str(aux[i])}'
                                if str(aux[i]).endswith('"'):
                                    dirty_list.append(str_aux.strip('"'))
                                    str_aux = ""
                                continue

                            # Text without quotes is inserted as-is
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
                    csv_col = str(x + 1)
                    if sp_n[x] != "''":
                        if sp_n[x].strip().replace("\n", "").startswith(';') and x == len(sp_n) - 1:
                            csv_col = "39"
                        sql += "csv" + csv_col + ", "
                        value = "$$" + sp_n[x].strip().replace("\n", "") + "$$, "
                        values += value.replace("$$$$", "null")
                    else:
                        sql += "csv" + csv_col + ", "
                        values = "VALUES(null, "
                sql = sql[:-2] + ") "
                values = values[:-2] + ");\n"
                sql += values

            if progress % 500 == 0:
                tools_db.execute_sql(sql, commit=self.dev_commit)
                sql = ""

        if sql != "":
            tools_db.execute_sql(sql, commit=self.dev_commit)

        _file.close()
        del _file

    def _populate_functions_dlg(self, dialog, result):
        """"""

        status = False
        if len(result) != 0:
            dialog.setWindowTitle(result['alias'])
            dialog.txt_info.setText(str(result['descript']))
            self.function_list = []
            tools_gw.build_dialog_options(dialog, result, 0, self.function_list)
            status = True

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
            tools_qgis.show_info(msg_ok, parameter=parameter)
        else:
            if msg_error is None:
                msg_error = "Process finished with some errors"
            tools_qgis.show_warning(msg_error, parameter=parameter)

    def _manage_json_message(self, json_result, parameter=None, title=None):
        """ Manage message depending result @status """

        message = json_result.get('message')
        if message:

            level = message.get('level')
            if level is not None:
                level = int(level)
            else:
                level = 1
            msg = message.get('text')
            if msg is None:
                msg = "Key on returned json from ddbb is missed"

            tools_qgis.show_message(msg, level, parameter=parameter, title=title)

        data = json_result['body'].get('data')
        tools_gw.fill_tab_log(self.dlg_manage_fields, data)
        qtabwidget = self.dlg_manage_fields.findChild(QTabWidget, 'tab_add_fields')
        if qtabwidget is not None:
            # Remove unused tabs
            for x in range(qtabwidget.count() - 1, -1, -1):
                qtabwidget.setTabEnabled(x, False)
            qtabwidget.setTabEnabled(qtabwidget.count() - 1, True)
            qtabwidget.setCurrentIndex(qtabwidget.count() - 1)

    def _save_selection(self):
        """"""

        # Save last Project schema name and type selected
        schema_name = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.project_schema_name, False, False)
        project_type = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.cmb_project_type)
        tools_gw.set_config_parser('btn_admin', 'project_type', f'{project_type}', prefix=False)
        tools_gw.set_config_parser('btn_admin', 'schema_name', f'{schema_name}', prefix=False)

    def _create_credentials_form(self, set_connection):
        """"""

        self.dlg_credentials = GwCredentialsUi(self)
        tools_gw.load_settings(self.dlg_credentials)
        if str(self.list_connections) != '[]':
            tools_qt.fill_combo_values(self.dlg_credentials.cmb_connection, self.list_connections)
        else:
            msg = "You don't have any connection to PostGIS database configurated. " \
                  "Check your QGIS data source manager and create at least one"
            tools_qt.show_info_box(msg, "Info")
            return

        tools_qt.set_widget_text(self.dlg_credentials, self.dlg_credentials.cmb_connection, str(set_connection))

        self.dlg_credentials.btn_accept.clicked.connect(partial(self._set_credentials, self.dlg_credentials))
        self.dlg_credentials.cmb_connection.currentIndexChanged.connect(
            partial(self._set_credentials, self.dlg_credentials, new_connection=True))

        sslmode_list = [['disable', 'disable'], ['allow', 'allow'], ['prefer', 'prefer'], ['require', 'require'],
                        ['verify - ca', 'verify - ca'], ['verify - full', 'verify - full']]
        tools_qt.fill_combo_values(self.dlg_credentials.cmb_sslmode, sslmode_list, 0)
        tools_qt.set_widget_text(self.dlg_credentials, self.dlg_credentials.cmb_sslmode, 'prefer')

        tools_gw.open_dialog(self.dlg_credentials, dlg_name='admin_credentials')

    def _manage_user_params(self):
        """"""

        # Update variable composer_path on config_param_user
        folder_name = os.path.dirname(os.path.abspath(__file__))
        composers_path_vdef = os.path.normpath(os.path.normpath(folder_name + os.sep + os.pardir)) + os.sep + \
            'resources' + os.sep + 'templates' + os.sep + 'qgiscomposer' + os.sep + 'en_US'
        sql = (f"UPDATE {self.schema_name}.config_param_user "
               f"SET value = '{composers_path_vdef}' "
               f"WHERE parameter = 'qgis_composers_folderpath' AND cur_user = current_user")
        tools_db.execute_sql(sql, commit=self.dev_commit)

    def _select_active_locales(self, sqlite_cursor):

        sql = f"SELECT locale as id, name as idval FROM locales WHERE active = 1"
        sqlite_cursor.execute(sql)
        return sqlite_cursor.fetchall()

    def _save_custom_sql_path(self, dialog):

        folder_path = tools_qt.get_text(dialog, "custom_path_folder")
        if folder_path == "null":
            folder_path = None
        tools_gw.set_config_parser("btn_admin", "custom_sql_path", f"{folder_path}", "user", "session")

    def _manage_docker(self):
        """ Puts the dialog in a docker, depending on the user configuration """

        try:
            tools_gw.close_docker('admin_position')
            lib_vars.session_vars['docker_type'] = 'qgis_form_docker'
            lib_vars.session_vars['dialog_docker'] = GwDocker(self)
            lib_vars.session_vars['dialog_docker'].dlg_closed.connect(partial(tools_gw.close_docker, 'admin_position'))
            tools_gw.manage_docker_options('admin_position')
            tools_gw.docker_dialog(self.dlg_readsql)
            self.dlg_readsql.dlg_closed.connect(partial(tools_gw.close_docker, 'admin_position'))
            self._set_buttons_enabled()
        except Exception as e:
            tools_log.log_info(str(e))
            tools_gw.open_dialog(self.dlg_readsql, dlg_name='admin_ui')

    def _set_buttons_enabled(self):
        """ Disable/enable buttons """

        # Check schema name
        schema_name = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.project_schema_name)

        # Buttons delete, rename and copy schema
        self.dlg_readsql.btn_delete.setEnabled(schema_name != "null")
        self.dlg_readsql.btn_schema_rename.setEnabled(schema_name != "null")
        self.dlg_readsql.btn_copy.setEnabled(schema_name != "null")

        # Check project type
        project_type = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.cmb_project_type)

        # Button create asset schema
        self.dlg_readsql.btn_create_asset.setEnabled(project_type == "ws" and schema_name != "null")

        # Check if audit schema exists
        sql = "SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'audit'"
        rows = tools_db.get_rows(sql)

        # Buttons to manage audit
        self.dlg_readsql.btn_create_audit.setEnabled(schema_name != "null" and rows is None)
        self.dlg_readsql.btn_activate_audit.setEnabled(schema_name != "null" and rows is not None)
        self.dlg_readsql.btn_reload_audit_triggers.setEnabled(schema_name != "null" and rows is not None)

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
            tools_qt.fill_combo_values(self.dlg_readsql.cmb_utils_ws, ws_result_list)

        if not ud_result_list:
            self.dlg_readsql.cmb_utils_ud.clear()
        else:
            tools_qt.fill_combo_values(self.dlg_readsql.cmb_utils_ud, ud_result_list)

    def _create_utils(self):

        # Manage cmb_utils_projecttypes null values
        self.ws_project_name = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.cmb_utils_ws, return_string_null=False)
        self.ud_project_name = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.cmb_utils_ud, return_string_null=False)

        if self.ws_project_name == "" or self.ud_project_name == "":
            msg = "You need to have a ws and ud schema created to create a utils schema"
            tools_qgis.show_message(msg, 0)
            return

        # Get giswater version for ws and ud project selected
        self.ws_project_result = None
        self.ud_project_result = None

        sql = f"SELECT giswater, language, epsg FROM {self.ws_project_name}.sys_version ORDER BY id DESC LIMIT 1"
        row = tools_db.get_row(sql)
        if row:
            self.ws_project_result = row

        sql = f"SELECT giswater, language, epsg FROM {self.ud_project_name}.sys_version ORDER BY id DESC LIMIT 1"
        row = tools_db.get_row(sql)
        if row:
            self.ud_project_result = row

        if self.ws_project_result[0] != self.ud_project_result[0]:
            msg = (f"You need to select same version for ws and ud projects. "
                   f"Versions: WS - {self.ws_project_result[0]} ; UD - {self.ud_project_result[0]}")
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

        self.error_count = 0
        # Set background task 'GwCreateSchemaTask'
        description = f"Create schema"
        params = {'is_test': False, 'project_type': 'utils', 'exec_last_process': False,
                  'project_name_schema': 'utils', 'project_locale': self.ws_project_result[1],
                  'project_srid': self.ws_project_result[2], 'example_data': False, 'schema_version': None,
                  'schema_utils': 'utils', 'schema_ws': self.ws_project_name, 'schema_ud': self.ud_project_name,
                  'main_project_version': self.ws_project_result[0]}
        self.task_create_schema = GwCreateSchemaUtilsTask(self, description, params)
        QgsApplication.taskManager().addTask(self.task_create_schema)
        QgsApplication.taskManager().triggerTask(self.task_create_schema)

    def _update_utils(self, schema_name=None):

        if schema_name is None:
            self.ws_project_name = tools_qt.get_text(self.dlg_readsql, self.dlg_readsql.cmb_utils_ws, return_string_null=False)
        else:
            self.ws_project_name = schema_name
        sql = f"SELECT value FROM utils.config_param_system WHERE parameter = 'utils_version'"
        row = tools_db.get_row(sql)
        if row:
            self._update_utils_schema(row, schema_name)

    def _load_base_utils(self):

        folder = os.path.join(self.sql_dir, 'corporate', 'utils', 'utils')
        status = self._execute_files(folder, utils_schema_name='utils')
        if not tools_os.set_boolean(status, False) and tools_os.set_boolean(self.dev_commit, False) is False:
            return False
        folder = os.path.join(self.sql_dir, 'corporate', 'utils', 'utils', 'fct')
        status = self._execute_files(folder, utils_schema_name='utils')
        if not tools_os.set_boolean(status, False) and tools_os.set_boolean(self.dev_commit, False) is False:
            return False
        folder = os.path.join(self.sql_dir, 'corporate', 'utils', 'ws')
        status = self._execute_files(folder, utils_schema_name=self.ws_project_name)
        if not tools_os.set_boolean(status, False) and tools_os.set_boolean(self.dev_commit, False) is False:
            return False
        folder = os.path.join(self.sql_dir, 'corporate', 'utils', 'ud')
        status = self._execute_files(folder, utils_schema_name=self.ud_project_name)
        if not tools_os.set_boolean(status, False) and tools_os.set_boolean(self.dev_commit, False) is False:
            return False

        return True

    def _update_utils_schema(self, schema_version=None, schema_name=None):

        folder_utils_updates = os.path.join(self.sql_dir, 'corporate', 'utils', 'updates')

        if not os.path.exists(folder_utils_updates):
            tools_qgis.show_message("The update folder was not found in sql folder")
            self.error_count = self.error_count + 1
            return False

        folders = sorted(os.listdir(folder_utils_updates))
        for folder in folders:
            sub_folders = sorted(os.listdir(os.path.join(folder_utils_updates, folder)))

            for sub_folder in sub_folders:
                aux = str(self.ws_project_result[0]).replace('.', '')
                if (schema_version is None and sub_folder <= aux) or schema_version is not None and (schema_version < sub_folder < aux):
                    folder_update = os.path.join(folder_utils_updates, folder, sub_folder, 'utils')
                    if self._process_folder(folder_update):
                        status = self._load_sql(folder_update, utils_schema_name='utils')
                        if tools_os.set_boolean(status, False) is False:
                            return False
                    if self.project_type_selected == 'ws':
                        folder_update = os.path.join(folder_utils_updates, folder, sub_folder, 'ws')
                        if self._process_folder(folder_update):
                            if schema_name is None:
                                schema_name = self.ws_project_name
                            status = self._load_sql(folder_update, utils_schema_name=schema_name)
                            if tools_os.set_boolean(status, False) is False:
                                return False
                    if self.project_type_selected == 'ud':
                        folder_update = os.path.join(folder_utils_updates, folder, sub_folder, 'ud')
                        if self._process_folder(folder_update):
                            if schema_name is None:
                                schema_name = self.ud_project_name
                            status = self._load_sql(folder_update, utils_schema_name=schema_name)
                            if tools_os.set_boolean(status, False) is False:
                                return False
                    folder_update = os.path.join(folder_utils_updates, folder, sub_folder, 'i18n', self.locale)
                    if self._process_folder(folder_update) is True:
                        status = self._execute_files(folder_update, True)
                        if tools_os.set_boolean(status, False) is False:
                            return False

        return True

    def _calculate_elapsed_time(self, dialog):

        tf = time()  # Final time
        td = tf - self.t0  # Delta time
        self._update_time_elapsed(f"Exec. time: {timedelta(seconds=round(td))}", dialog)

    def _update_time_elapsed(self, text, dialog):

        if isdeleted(dialog):
            self.timer.stop()
            return

        lbl_time = dialog.findChild(QLabel, 'lbl_time')
        lbl_time.setText(text)

    # endregion
