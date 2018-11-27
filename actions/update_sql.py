"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
import os
import sys
from functools import partial
from sqlite3 import OperationalError

import utils_giswater
from giswater.actions.parent import ParentAction
from giswater.ui_manager import InfoShowInfo
from PyQt4.QtGui import QCheckBox, QRadioButton, QAction, QWidget, QComboBox, QLineEdit,QPushButton, QTableView, QAbstractItemView, QTextEdit
from PyQt4.QtCore import QSettings
import psycopg2

from dao.controller import DaoController
from ui_manager import ReadsqlCreateProject, ReadsqlRename, ReadsqlShowInfo


class UpdateSQL(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'om_ws' """
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.project_type = controller.get_project_type()


    def init_sql(self):
        """ Button 100: Execute SQL. Info show info """
        print("info")
        # Create the dialog and signals
        self.dlg_info_show_info = InfoShowInfo()
        self.load_settings(self.dlg_info_show_info)
        self.dlg_info_show_info.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_info_show_info))

        # TODO::Get permisions for config_param_system parameter
        #Set user permisions
        self.permisions = False

        # Get widgets from form

        # self.chk_schema_ddl_dml = self.dlg_info_show_info.findChild(QRadioButton, 'rdb_ud')
        # self.chk_schema_view = self.dlg_info_show_info.findChild(QRadioButton, 'rdb_ws')

        # Checkbox SCHEMA & API
        self.chk_schema_ddl_dml = self.dlg_info_show_info.findChild(QCheckBox, 'chk_schema_ddl_dml')
        self.chk_schema_view = self.dlg_info_show_info.findChild(QCheckBox, 'chk_schema_view')
        self.chk_schema_fk = self.dlg_info_show_info.findChild(QCheckBox, 'chk_schema_fk')
        self.chk_schema_rules = self.dlg_info_show_info.findChild(QCheckBox, 'chk_schema_rules')
        self.chk_schema_funcion = self.dlg_info_show_info.findChild(QCheckBox, 'chk_schema_funcion')
        self.chk_schema_trigger = self.dlg_info_show_info.findChild(QCheckBox, 'chk_schema_trigger')
        self.chk_api_ddl_dml = self.dlg_info_show_info.findChild(QCheckBox, 'chk_api_ddl_dml')
        self.chk_api_view = self.dlg_info_show_info.findChild(QCheckBox, 'chk_api_view')
        self.chk_api_fk = self.dlg_info_show_info.findChild(QCheckBox, 'chk_api_fk')
        self.chk_api_rules = self.dlg_info_show_info.findChild(QCheckBox, 'chk_api_rules')
        self.chk_api_funcion = self.dlg_info_show_info.findChild(QCheckBox, 'chk_api_funcion')
        self.chk_api_trigger = self.dlg_info_show_info.findChild(QCheckBox, 'chk_api_trigger')

        btn_info = self.dlg_info_show_info.findChild(QPushButton, 'btn_info')
        self.set_icon(btn_info, '73')


        self.message_update = ''

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
        #TODO: Populate combo project type with all projects types (Dinamic)
        cmb_project_type = self.dlg_info_show_info.findChild(QComboBox, 'cmb_project_type')
        cmb_project_type.addItem('ws')
        cmb_project_type.addItem('ud')
        cmb_project_type.addItem('tree manage')

        self.populate_data_shcema_name(cmb_project_type)
        self.set_info_project()

        # Get version

        sql = ("SELECT giswater from " + self.schema_name + ".version")
        row = self.controller.get_row(sql)
        self.version = row[0].replace('.','')


        # Declare all file variables
        self.file_pattern_fk = "fk"
        self.file_pattern_ddl = "ddl"
        self.file_pattern_dml = "dml"
        self.file_pattern_fct = "fct"
        self.file_pattern_trg = "trg"
        self.file_pattern_view = "view"
        self.file_pattern_rules = "rules"
        self.file_pattern_vdefault = "vdefault"
        self.file_pattern_other = "other"
        self.file_pattern_roles = "roles"

        # Declare sql directory
        self.sql_dir = os.path.normpath(os.path.normpath(os.path.dirname(os.path.abspath(__file__)) + os.sep + os.pardir)) + '\sql'

        # Declare all directorys
        self.folderSoftware = self.sql_dir + '/' + self.project_type + '/'
        self.folderLocale = self.sql_dir + '\i18n/' + str(self.locale) + '/'
        self.folderUtils = self.sql_dir + '\utils/'
        self.folderUpdates = self.sql_dir + '\updates/'
        self.folderExemple = self.sql_dir, '\example/'
        self.folderPath = ''

        # Declare all directorys api
        self.folderSoftwareApi = self.sql_dir + '/api/' + self.project_type + '/'
        self.folderUtilsApi = self.sql_dir + '/api/utils/'
        self.folderUpdatesApi = self.sql_dir + '/api/updates/'
        self.folderLocaleApi = self.sql_dir + '/api\i18n/' + str(self.locale) + '/'
        self.folderExempleApi = self.sql_dir, '/api/example/'

        # Set Listeners
        self.dlg_info_show_info.btn_schema_create.clicked.connect(partial(self.open_create_project))
        self.dlg_info_show_info.btn_schema_rename.clicked.connect(partial(self.open_rename))
        self.dlg_info_show_info.btn_api_create.clicked.connect(partial(self.implement_api))
        self.dlg_info_show_info.btn_qgis_project_create.clicked.connect(partial(self.load_custom_sql_files, self.dlg_info_show_info, "path_folder"))
        self.dlg_info_show_info.btn_schema_custom_load_file.clicked.connect(partial(self.load_custom_sql_files, self.dlg_info_show_info, "schema_path_folder"))
        self.dlg_info_show_info.btn_api_custom_load_file.clicked.connect(partial(self.load_custom_sql_files, self.dlg_info_show_info, "api_path_folder"))
        self.dlg_info_show_info.btn_schema_file_to_db.clicked.connect(partial(self.schema_file_to_db))
        self.dlg_info_show_info.btn_api_file_to_db_2.clicked.connect(partial(self.api_file_to_db))
        btn_info.clicked.connect(partial(self.show_info))
        self.dlg_info_show_info.project_schema_name.currentIndexChanged.connect(partial(self.set_info_project))
        cmb_project_type.currentIndexChanged.connect(partial(self.populate_data_shcema_name, cmb_project_type))
        self.dlg_info_show_info.btn_select_file.clicked.connect(partial(self.get_folder_dialog, self.dlg_info_show_info, "path_folder"))
        self.dlg_info_show_info.btn_schema_select_file.clicked.connect(partial(self.get_folder_dialog, self.dlg_info_show_info, "schema_path_folder"))
        self.dlg_info_show_info.btn_api_select_file.clicked.connect(partial(self.get_folder_dialog, self.dlg_info_show_info, "api_path_folder"))


        if self.check_relaod_views() is True:
            self.chk_schema_view.setEnabled(False)
            self.chk_api_view.setEnabled(False)
            self.btn_schema_rename.setEnabled(False)
        if self.check_version_schema() is False:
            self.chk_schema_ddl_dml.setEnabled(False)
            self.chk_api_ddl_dml.setEnabled(False)

        #TODO::Descomentar
        # if self.permisions is False:
        #     utils_giswater.remove_tab_by_tabName(self.dlg_info_show_info.tab_main, "devtools")
        #     utils_giswater.remove_tab_by_tabName(self.dlg_info_show_info.tab_main, "api")

        # Open dialog
        self.dlg_info_show_info.show()

    def load_base(self, api=False):

        status = True

        # Check is api
        if api:

            if self.process_folder(self.folderSoftwareApi, self.file_pattern_ddl + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderSoftwareApi + self.file_pattern_ddl),
                                           self.folderSoftwareApi + self.file_pattern_ddl)
                if status is False:
                    return False
            if self.process_folder(self.folderSoftwareApi, self.file_pattern_dml + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderSoftwareApi + self.file_pattern_dml),
                                           self.folderSoftwareApi + self.file_pattern_dml)
                if status is False:
                    return False
            if self.process_folder(self.folderSoftwareApi, self.file_pattern_fct + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderSoftwareApi + self.file_pattern_fct),
                                           self.folderSoftwareApi + self.file_pattern_fct)
                if status is False:
                    return False
            if self.process_folder(self.folderSoftwareApi, self.file_pattern_rules + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderSoftwareApi + self.file_pattern_rules),
                                           self.folderSoftwareApi + self.file_pattern_rules)
                if status is False:
                    return False
            if self.process_folder(self.folderSoftwareApi, self.file_pattern_fk + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderSoftwareApi + self.file_pattern_fk),
                                           self.folderSoftwareApi + self.file_pattern_fk)
                if status is False:
                    return False
            if self.process_folder(self.folderSoftwareApi, self.file_pattern_trg + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderSoftwareApi + self.file_pattern_trg),
                                           self.folderSoftwareApi + self.file_pattern_trg)
                if status is False:
                    return False
            if self.process_folder(self.folderUtilsApi, self.file_pattern_ddl + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderUtilsApi + self.file_pattern_ddl),
                                           self.folderUtilsApi + self.file_pattern_ddl)
                if status is False:
                    return False
            if self.process_folder(self.folderUtilsApi, self.file_pattern_dml + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderUtilsApi + self.file_pattern_dml),
                                           self.folderUtilsApi + self.file_pattern_dml)
                if status is False:
                    return False
            if self.process_folder(self.folderUtilsApi, self.file_pattern_fct + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderUtilsApi + self.file_pattern_fct),
                                           self.folderUtilsApi + self.file_pattern_fct)
                if status is False:
                    return False
            if self.process_folder(self.folderUtilsApi, self.file_pattern_rules + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderUtilsApi + self.file_pattern_rules),
                                           self.folderUtilsApi + self.file_pattern_rules)
                if status is False:
                    return False
            if self.process_folder(self.folderUtilsApi, self.file_pattern_fk + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderUtilsApi + self.file_pattern_fk),
                                           self.folderUtilsApi + self.file_pattern_fk)
                if status is False:
                    return False
            if self.process_folder(self.folderUtilsApi, self.file_pattern_trg + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderUtilsApi + self.file_pattern_trg),
                                           self.folderUtilsApi + self.file_pattern_trg)
                if status is False:
                    return False
            if self.process_folder(self.folderLocaleApi,
                                   str(self.locale)) is False:
                if self.process_folder(self.folderLocaleApi, 'EN') is False:
                    return False
                else:
                    status = self.executeFiles(os.listdir(
                        self.folderLocaleApi + str(self.locale)),
                        self.folderLocaleApi + str(self.locale))
                    if status is False:
                        return False
            else:
                status = self.executeFiles(os.listdir(
                    self.folderLocaleApi + str(self.locale)),
                                           self.folderLocaleApi + str(self.locale))
                if status is False:
                    return False
        else:

            if self.process_folder(self.folderSoftware, self.file_pattern_ddl + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderSoftware + self.file_pattern_ddl), self.folderSoftware + self.file_pattern_ddl)
                if status is False:
                    return False
            if self.process_folder(self.folderSoftware, self.file_pattern_dml + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderSoftware + self.file_pattern_dml), self.folderSoftware + self.file_pattern_dml)
                if status is False:
                    return False
            if self.process_folder(self.folderSoftware, self.file_pattern_fct + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderSoftware + self.file_pattern_fct), self.folderSoftware + self.file_pattern_fct)
                if status is False:
                    return False
            if self.process_folder(self.folderSoftware, self.file_pattern_rules + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderSoftware + self.file_pattern_rules), self.folderSoftware + self.file_pattern_rules)
                if status is False:
                    return False
            if self.process_folder(self.folderSoftware, self.file_pattern_fk + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderSoftware + self.file_pattern_fk), self.folderSoftware + self.file_pattern_fk)
                if status is False:
                    return False
            if self.process_folder(self.folderSoftware, self.file_pattern_trg + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderSoftware + self.file_pattern_trg), self.folderSoftware + self.file_pattern_trg)
                if status is False:
                    return False
            if self.process_folder(self.folderUtils, self.file_pattern_ddl + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderUtils + self.file_pattern_ddl), self.folderUtils + self.file_pattern_ddl)
                if status is False:
                    return False
            if self.process_folder(self.folderUtils, self.file_pattern_dml + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderUtils + self.file_pattern_dml), self.folderUtils + self.file_pattern_dml)
                if status is False:
                    return False
            if self.process_folder(self.folderUtils, self.file_pattern_fct + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderUtils + self.file_pattern_fct), self.folderUtils + self.file_pattern_fct)
                if status is False:
                    return False
            if self.process_folder(self.folderUtils, self.file_pattern_rules + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderUtils + self.file_pattern_rules), self.folderUtils + self.file_pattern_rules)
                if status is False:
                    return False
            if self.process_folder(self.folderUtils, self.file_pattern_fk + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderUtils + self.file_pattern_fk), self.folderUtils + self.file_pattern_fk)
                if status is False:
                    return False
            if self.process_folder(self.folderUtils, self.file_pattern_trg + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderUtils + self.file_pattern_trg), self.folderUtils + self.file_pattern_trg)
                if status is False:
                    return False
            if self.process_folder(self.folderLocale, '') is False:
                if self.process_folder(self.sql_dir + '\i18n/', 'EN') is False:
                    return False
                else:
                    status = self.executeFiles(os.listdir(
                        self.sql_dir + '\i18n/' + 'EN'), self.sql_dir + '\i18n/' + 'EN')
                    if status is False:
                        return False
            else:
                status = self.executeFiles(os.listdir(self.folderLocale), self.folderLocale)
                if status is False:
                    return False

        print(status)
        return True

    def load_base_no_ct(self):

        status = True

        if self.process_folder(self.folderSoftware, self.file_pattern_ddl + '/') is False:
            return False
        else:
            status = self.executeFiles(os.listdir(self.folderSoftware + self.file_pattern_ddl), self.folderSoftware + self.file_pattern_ddl)
            if status is False:
                return False
        if self.process_folder(self.folderSoftware, self.file_pattern_dml + '/') is False:
            return False
        else:
            status = self.executeFiles(os.listdir(self.folderSoftware + self.file_pattern_dml), self.folderSoftware + self.file_pattern_dml)
            if status is False:
                return False
        if self.process_folder(self.folderSoftware, self.file_pattern_fct + '/') is False:
            return False
        else:
            status = self.executeFiles(os.listdir(self.folderSoftware + self.file_pattern_fct), self.folderSoftware + self.file_pattern_fct)
            if status is False:
                return False
        if self.process_folder(self.folderUtils, self.file_pattern_ddl + '/') is False:
            return False
        else:
            status = self.executeFiles(os.listdir(self.folderUtils + self.file_pattern_ddl), self.folderUtils + self.file_pattern_ddl)
            if status is False:
                return False
        if self.process_folder(self.folderUtils, self.file_pattern_dml + '/') is False:
            return False
        else:
            status = self.executeFiles(os.listdir(self.folderUtils + self.file_pattern_dml), self.folderUtils + self.file_pattern_dml)
            if status is False:
                return False
        if self.process_folder(self.folderUtils, self.file_pattern_fct + '/') is False:
            return False
        else:
            status = self.executeFiles(os.listdir(self.folderUtils + self.file_pattern_fct), self.folderUtils + self.file_pattern_fct)
            if status is False:
                return False
        if self.process_folder(self.folderLocale, str(self.locale)) is False:
            if self.process_folder(self.folderLocale, 'EN') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(
                    self.folderLocale + str(self.locale)), self.folderLocale + str(self.locale))
                if status is False:
                    return False
        else:
            status = self.executeFiles(os.listdir(self.folderLocale + str(self.locale)), self.folderLocale + str(self.locale))
            if status is False:
                return False

        print(status)
        return True

    def load_update_ddl_dml(self, api=False):

        status = True

        # Check is api
        if api:
            print("api1")
            folders = os.listdir(self.folderUpdatesApi + '')
            print("folders2")
            print(folders)
            for folder in folders:
                sub_folders = os.listdir(self.folderUpdatesApi + folder)
                print("sub_folders3")
                print(sub_folders)

                for sub_folder in sub_folders:
                    print("sub_folder4")
                    print(sub_folder)
                    print("version5")
                    print(self.version)
                    if str(sub_folder) > str(self.version):
                        if self.process_folder(
                                self.folderUpdatesApi + folder + '/' + sub_folder + '/' + self.project_type + '/',
                                '') is False:
                            print(False)
                            return False
                        else:
                            print(self.folderUpdatesApi + folder + '/' + sub_folder + '/' + self.project_type + '/')
                            status = self.executeFiles(os.listdir(
                                self.folderUpdatesApi + folder + '/' + sub_folder + '/' + self.project_type + '/'),
                                                       self.folderUpdatesApi + folder + '/' + sub_folder + '/' + self.project_type + '/')
                            if status is False:
                                print(False)
                                return False
                        if self.process_folder(self.folderUpdatesApi + folder + '/' + sub_folder, '/utils/') is False:
                            print(False)
                            return False
                        else:
                            status = self.executeFiles(
                                os.listdir(self.folderUpdatesApi + folder + '/' + sub_folder + '/utils/'),
                                self.folderUpdatesApi + folder + '/' + sub_folder + '/utils/')
                            if status is False:
                                print(False)
                                return False
                        if self.process_folder(self.folderUpdatesApi + folder + '/' + sub_folder + '/i18n/' + str(self.locale + '/'),
                                               '') is False:
                            if self.process_folder(self.folderLocaleApi, 'EN') is False:
                                return False
                            else:
                                status = self.executeFiles(os.listdir(
                                    self.folderLocaleApi + self.locale),
                                    self.folderLocaleApi + self.locale + '/')
                                if status is False:
                                    return False
                        else:
                            status = self.executeFiles(
                                os.listdir(self.folderUpdatesApi + folder + '/' + sub_folder + '/utils/'),
                                self.folderUpdatesApi + folder + '/' + sub_folder + '/utils/')
                            if status is False:
                                print(False)
                                return False
        else:
            folders = os.listdir(self.folderUpdates + '')
            for folder in folders:
                sub_folders = os.listdir(self.folderUpdates + folder)
                for sub_folder in sub_folders:
                    if str(sub_folder) > str(self.version):
                        if self.process_folder(self.folderUpdates + folder + '/' + sub_folder + '/' + self.project_type + '/','') is False:
                            print(False)
                            return False
                        else:
                            print(self.folderUpdates + folder + '/' + sub_folder + '/' + self.project_type + '/')
                            status = self.executeFiles(os.listdir(self.folderUpdates + folder + '/' + sub_folder + '/' + self.project_type + '/'), self.folderUpdates + folder + '/' + sub_folder + '/' +self.project_type + '/')
                            if status is False:
                                print(False)
                                return False
                        if self.process_folder(self.folderUpdates + folder + '/' + sub_folder, '/utils/') is False:
                            print(False)
                            return False
                        else:
                            status = self.executeFiles(os.listdir(self.folderUpdates + folder + '/' + sub_folder + '/utils/'), self.folderUpdates + folder + '/' + sub_folder + '/utils/')
                            if status is False:
                                print(False)
                                return False
                        if self.process_folder(self.folderUpdates + folder + '/' + sub_folder + '/i18n/' + str(self.locale + '/'), '') is False:
                            if self.process_folder(self.folderLocale, 'EN') is False:
                                return False
                            else:
                                status = self.executeFiles(os.listdir(
                                    self.folderLocale + self.locale),
                                    self.folderLocale + self.locale + '/')
                                if status is False:
                                    return False
                        else:
                            status = self.executeFiles(os.listdir(self.folderUpdates + folder + '/' + sub_folder + '/i18n/' + str(self.locale + '/')), self.folderUpdates + folder + '/' + sub_folder + '/i18n/' + str(self.locale + '/'))
                            if status is False:
                                print(False)
                                return False

        print(status)
        return True

    def load_views(self, api=False):

        status = True

        # Check is api
        if api:
            if self.process_folder(self.folderSoftwareApi, self.file_pattern_view + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderSoftwareApi + self.file_pattern_view), self.folderSoftwareApi + self.file_pattern_view)
                if status is False:
                    return False
            if self.process_folder(self.folderUtilsApi, self.file_pattern_view + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderUtilsApi + self.file_pattern_view), self.folderUtilsApi + self.file_pattern_view)
                if status is False:
                    return False
        else:
            if self.process_folder(self.folderSoftware, self.file_pattern_view + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderSoftware + self.file_pattern_view), self.folderSoftware + self.file_pattern_view)
                if status is False:
                    return False
            if self.process_folder(self.folderUtils, self.file_pattern_view + '/') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderUtils + self.file_pattern_view), self.folderUtils + self.file_pattern_view)
                if status is False:
                    return False

        print(status)
        return True

    def load_sample_data(self):

        status = True

        if self.process_folder(self.folderExemple, 'user/') is False:
            return False
        else:
            status = self.executeFiles(os.listdir(self.folderExemple + 'user/'), self.folderExemple + 'user/')
            if status is False:
                return False

        print(status)
        return True

    def load_dev_data(self):

        status = True

        if self.process_folder(self.folderExemple, 'dev/') is False:
            return False
        else:
            status = self.executeFiles(os.listdir(self.folderExemple + 'dev/'), self.folderExemple + 'dev/')
            if status is False:
                return False

        print(status)
        return True

    def load_fct(self, api=False):

        status = True
        # Check is api
        if api:
            if self.process_folder(self.folderSoftwareApi, self.file_pattern_fct) is False:
                print(False)
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderSoftwareApi + self.file_pattern_fct),
                                           self.folderSoftwareApi + self.file_pattern_fct)
                if status is False:
                    print(False)
                    return False
            if self.process_folder(self.folderUtilsApi, self.file_pattern_fct) is False:
                print(False)
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderUtilsApi + self.file_pattern_fct),
                                           self.folderUtilsApi + self.file_pattern_fct)
                if status is False:
                    print(False)
                    return False
        else:
            if self.process_folder(self.folderSoftware, self.file_pattern_fct) is False:
                print(False)
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderSoftware + self.file_pattern_fct), self.folderSoftware + self.file_pattern_fct)
                if status is False:
                    print(False)
                    return False
            if self.process_folder(self.folderUtils, self.file_pattern_fct) is False:
                print(False)
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderUtils + self.file_pattern_fct), self.folderUtils + self.file_pattern_fct)
                if status is False:
                    print(False)
                    return False

        print(status)
        return True

    def load_rules(self, api=False):

        status = True
        # Check is api
        if api:
            if self.process_folder(self.folderSoftwareApi, self.file_pattern_rules) is False:
                print(False)
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderSoftwareApi + self.file_pattern_rules),
                                           self.folderSoftwareApi + self.file_pattern_rules)
                if status is False:
                    print(False)
                    return False
            if self.process_folder(self.folderUtilsApi, self.file_pattern_rules) is False:
                print(False)
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderUtilsApi + self.file_pattern_rules),
                                           self.folderUtilsApi + self.file_pattern_rules)
                if status is False:
                    print(False)
                    return False
        else:
            if self.process_folder(self.folderSoftware, self.file_pattern_rules) is False:
                print(False)
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderSoftware + self.file_pattern_rules), self.folderSoftware + self.file_pattern_rules)
                if status is False:
                    print(False)
                    return False
            if self.process_folder(self.folderUtils, self.file_pattern_rules) is False:
                print(False)
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderUtils + self.file_pattern_rules), self.folderUtils + self.file_pattern_rules)
                if status is False:
                    print(False)
                    return False

        print(status)
        return True

    def load_fk(self, api=False):

        status = True

        # Check is api
        if api:
            if self.process_folder(self.folderSoftwareApi, self.file_pattern_fk) is False:
                print(False)
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderSoftwareApi + self.file_pattern_fk), self.folderSoftwareApi + self.file_pattern_fk)
                if status is False:
                    print(False)
                    return False
            print(status)
            if self.process_folder(self.folderUtilsApi, self.file_pattern_fk) is False:
                print(False)
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderUtilsApi + self.file_pattern_fk), self.folderUtilsApi + self.file_pattern_fk)
                if status is False:
                    print(False)
                    return False
        else:
            if self.process_folder(self.folderSoftware, self.file_pattern_fk) is False:
                print(False)
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderSoftware + self.file_pattern_fk), self.folderSoftware + self.file_pattern_fk)
                if status is False:
                    print(False)
                    return False
            print(status)
            if self.process_folder(self.folderUtils, self.file_pattern_fk) is False:
                print(False)
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderUtils + self.file_pattern_fk), self.folderUtils + self.file_pattern_fk)
                if status is False:
                    print(False)
                    return False

        print(status)
        return True

    def load_trg(self, api=False):

        status = True

        # Check is api
        if api:
            if self.process_folder(self.folderSoftwareApi, self.file_pattern_trg) is False:
                print(False)
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderSoftwareApi + self.file_pattern_trg),
                                           self.folderSoftwareApi + self.file_pattern_trg)
                if status is False:
                    print(False)
                    return False
            if self.process_folder(self.folderUtilsApi, self.file_pattern_trg) is False:
                print(False)
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderUtilsApi + self.file_pattern_trg),
                                           self.folderUtilsApi + self.file_pattern_trg)
                if status is False:
                    print(False)
                    return False
        else:
            if self.process_folder(self.folderSoftware, self.file_pattern_trg) is False:
                print(False)
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderSoftware + self.file_pattern_trg), self.folderSoftware + self.file_pattern_trg)
                if status is False:
                    print(False)
                    return False
            if self.process_folder(self.folderUtils, self.file_pattern_trg) is False:
                print(False)
                return False
            else:
                status = self.executeFiles(os.listdir(self.folderUtils + self.file_pattern_trg), self.folderUtils + self.file_pattern_trg)
                if status is False:
                    print(False)
                    return False

        print(status)
        return True

    # TODO:: take path folder from widget custom folder
    def load_sql(self, path_folder):
        for (path, ficheros, archivos) in os.walk(path_folder):
            print path
            print ficheros
            print archivos
            status = self.executeFiles(archivos, path)
            if status is False:
                return False
        return

    # FUNCTION EXECUCION PROCESS

    def execute_last_process(self):

        # Execute permissions
        sql = ("SELECT " + self.schema_name + ".gw_fct_utils_permissions();")
        self.controller.execute_sql(sql)

        # Update table version
        # TODO: Update table version

    # TODO
    def execute_import_data(self):
        return


    # BUTTONS CALLING FUNCTIONS

    def create_project_data_schema(self):
        self.schema = utils_giswater.getWidgetText(self.dlg_readsql_create_project, 'project_name')
        if self.rdb_import_data.isChecked():
            print("rdb_import_data")
            self.load_base_no_ct()
            self.execute_import_data()
            self.load_fk()
            self.load_rules()
            self.load_trg()
            self.load_dev_data()
            # self.execute_last_process()
        elif self.rdb_no_ct.isChecked():
            print(str("rdb_no_ct"))
            self.load_base_no_ct()
            self.load_update_ddl_dml()
            self.load_views()
            # self.execute_last_process()
        elif self.rdb_sample.isChecked():
            print(str("rdb_sample"))
            self.load_base()
            self.update_ddl_dml()
            self.load_views()
            self.load_sample_data()
            # self.execute_last_process()
        elif self.rdb_sample_dev.isChecked():
            print(str("rdb_sample_dev"))
            self.load_base()
            self.load_update_ddl_dml()
            self.load_views()
            self.load_sample_data()
            self.load_dev_data()
            # self.execute_last_process()
        elif self.rdb_data.isChecked():
            print(str("rdb_data"))
            self.load_base()
            self.load_update_ddl_dml()
            self.load_views()
            # self.execute_last_process()

        # Insert information into table inp_project_id and version
        schemaName = utils_giswater.getWidgetText(self.dlg_readsql_create_project,self.project_name)
        title = utils_giswater.getWidgetText(self.dlg_readsql_create_project,self.project_title)
        author = utils_giswater.getWidgetText(self.dlg_readsql_create_project, self.project_author)
        date = utils_giswater.getWidgetText(self.dlg_readsql_create_project, self.project_date)

        sql = "INSERT INTO "+schemaName+".inp_project_id VALUES ('"+title+"', '"+author+"', '"+date+"')"
        self.controller.execute_sql(sql)

        self.close_dialog(self.dlg_readsql_create_project)

    def create_sample(self):
        self.load_base()
        self.load_update_ddl_dml()
        self.load_views()
        self.load_sample_data()
        # self.execute_last_process()

    def create_sample_dev(self):
        self.load_base()
        self.load_update_ddl_dml()
        self.load_views()
        self.load_sample_data()
        self.load_dev_data()
        # self.execute_last_process()

    def import_epa_file(self):
        self.load_base_no_ct()
        self.execute_import_data()
        self.load_fk()
        self.load_rules()
        self.load_trg()
        self.load_views()
        # self.execute_last_process()

    def rename_project_data_schema(self):
        self.schema = utils_giswater.getWidgetText(self.dlg_readsql_rename,self.dlg_readsql_rename.schema_rename)
        self.load_trg()
        self.load_fk()
        self.load_rules()
        self.load_views()
        # self.execute_last_process()

    def implement_api(self):
        self.load_base(True)
        self.load_update_ddl_dml(True)
        self.load_views(True)
        # self.execute_last_process()

    def load_custom_sql_files(self, dialog, widget):
        folder_path = utils_giswater.getWidgetText(dialog, widget)
        self.load_sql(folder_path)
        # self.execute_last_process()


    # CHECKBOX CALLING FUNCTIONS

    def update_ddl_dml(self, api=False):
        self.load_update_ddl_dml(api)
        # self.execute_last_process()

    def reload_views(self, api=False):
        self.load_views(api)
        # self.execute_last_process()

    def reload_update_fk(self, api=False):
        self.load_fk(api)
        # self.execute_last_process()

    def reload_update_rules(self, api=False):
        self.load_rules(api)
        # self.execute_last_process()

    def reload_update_fct(self, api=False):
        self.load_fct(api)
        # self.execute_last_process()

    def reload_update_trg(self, api=False):
        self.load_trg(api)
        # self.execute_last_process()


    # OTHER FUNCTIONS

    def show_info(self):
        # Create dialog
        self.dlg_readsql_show_info = ReadsqlShowInfo()
        self.load_settings(self.dlg_readsql_show_info)

        info_updates = self.dlg_readsql_show_info.findChild(QTextEdit, 'info_updates')

        self.read_info_version()

        info_updates.setText(self.message_update)

        #Set listeners
        self.dlg_readsql_create_project.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_readsql_show_info))




        # Open dialog
        self.dlg_readsql_show_info.show()

    def read_info_version(self):
        status = True

        folders = os.listdir(self.folderUpdates + '')
        print(folders)
        for folder in folders:
            print(folder)
            print(self.version)
            sub_folders = os.listdir(self.folderUpdates + folder)
            print(sub_folders)
            for sub_folder in sub_folders:
                print(sub_folder)
                if str(sub_folder) > str(self.version):
                    if self.process_folder(self.folderUpdates + folder + '/' + sub_folder + '/' + self.project_type + '/','') is False:
                        print(False)
                        return False
                    else:
                        status = self.readFiles(os.listdir(self.folderUpdates + folder + '/' + sub_folder + '/' + self.project_type + '/'),self.folderUpdates + folder + '/' + sub_folder + '/' + self.project_type + '/')
                        if status is False:
                            print(False)
                            return False
                    if self.process_folder(self.folderUpdates + folder + '/' + sub_folder, '/utils/') is False:
                        print(False)
                        return False
                    else:
                        status = self.readFiles(
                            os.listdir(self.folderUpdates + folder + '/' + sub_folder + '/utils/'),self.folderUpdates + folder + '/' + sub_folder + '/utils/')
                        if status is False:
                            print(False)
                            return False
                    if self.process_folder(self.folderUpdates + folder + '/' + sub_folder + '/i18n/' + self.locale,'') is False:
                        if self.process_folder(self.folderUpdates + folder + '/' + sub_folder + '/i18n/EN', '') is False:
                            return False
                        else:
                            status = self.readFiles(os.listdir(self.folderUpdates + folder + '/' + sub_folder + '/i18n/EN' ),self.folderUpdates + folder + '/' + sub_folder + '/i18n/EN' )
                            if status is False:
                                return False
                    else:
                        status = self.readFiles(
                            os.listdir(self.folderUpdates + folder + '/' + sub_folder + '/i18n/' + self.locale),
                            self.folderUpdates + folder + '/' + sub_folder + '/i18n/' + self.locale)
                        if status is False:
                            print(False)
                            return False
                else:
                    print("Dont have updates")
        print(status)
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
        print(utils_giswater.getWidgetText(self.dlg_readsql_create_project, self.cmb_locale))
        self.folderLocale = self.sql_dir + '\i18n/' + utils_giswater.getWidgetText(self.dlg_info_show_info, self.cmb_locale) + '/'

    def enable_datafile(self):
        if self.rdb_import_data.isChecked() is True:
            self.data_file.setEnabled(True)
            self.btn_push_file.setEnabled(True)
        else:
            self.data_file.setEnabled(False)
            self.btn_push_file.setEnabled(False)

    def populate_data_shcema_name(self, widget):
        # Get filter
        filter = str(utils_giswater.getWidgetText(self.dlg_info_show_info, widget))
        # Populate Project data schema Name
        sql = ("SELECT schema_name, schema_name FROM information_schema.schemata WHERE schema_name LIKE '%"+filter+"%'")
        rows = self.controller.get_rows(sql)
        utils_giswater.set_item_data(self.dlg_info_show_info.project_schema_name, rows, 1)

    def filter_srid_changed(self):
        filter_value = utils_giswater.getWidgetText(self.dlg_readsql_create_project, self.filter_srid)
        if filter_value is 'null':
            filter_value = ''
        sql = "SELECT substr(srtext, 1, 6) as "+'"Type"'+", srid as "+'"SRID"'+", substr(split_part(srtext, ',', 1), 9) as "+'"Description"'+" FROM public.spatial_ref_sys WHERE CAST(srid AS TEXT) LIKE '"+str(filter_value)+"%' ORDER BY substr(srtext, 1, 6), srid"
        # Populate Table
        self.fill_table_by_query(self.tbl_srid, sql)

    def set_info_project(self):
        schema_name = utils_giswater.getWidgetText(self.dlg_info_show_info, self.dlg_info_show_info.project_schema_name)
        sql = "SELECT title, author, date FROM " + schema_name + ".inp_project_id"
        row = self.controller.get_row(sql)
        print(row)
        if row is None:
            utils_giswater.setWidgetText(self.dlg_info_show_info,
                                         self.dlg_info_show_info.project_schema_title, '')
            utils_giswater.setWidgetText(self.dlg_info_show_info,
                                         self.dlg_info_show_info.project_schema_author, '')
            utils_giswater.setWidgetText(self.dlg_info_show_info,
                                         self.dlg_info_show_info.project_schema_last_update, '')
            return
        utils_giswater.setWidgetText(self.dlg_info_show_info,
                                     self.dlg_info_show_info.project_schema_title, str(row[0]))
        utils_giswater.setWidgetText(self.dlg_info_show_info,
                                     self.dlg_info_show_info.project_schema_author, str(row[1]))
        utils_giswater.setWidgetText(self.dlg_info_show_info,
                                     self.dlg_info_show_info.project_schema_last_update, str(row[2]))

    def process_folder(self, folderPath, filePattern):
        status = True

        try:
            print("test10")
            print(os.listdir(folderPath + filePattern))
        # except Exception, e: print str(e)
        except Exception as e:
            status = False
            print(e)

        return status

    def schema_file_to_db(self):

        if self.chk_schema_ddl_dml.isChecked():
            self.update_ddl_dml()
        if self.chk_schema_view.isChecked():
            self.reload_views()
        if self.chk_schema_fk.isChecked():
            self.reload_update_fk()
        if self.chk_schema_rules.isChecked():
            self.reload_update_rules()
        if self.chk_schema_funcion.isChecked():
            self.reload_update_fct()
        if self.chk_schema_trigger.isChecked():
            self.reload_update_trg()

    def api_file_to_db(self):

        if self.chk_api_ddl_dml.isChecked():
            self.update_ddl_dml(True)
        if self.chk_api_view.isChecked():
            self.reload_views(True)
        if self.chk_api_fk.isChecked():
            self.reload_update_fk(True)
        if self.chk_api_rules.isChecked():
            self.reload_update_rules(True)
        if self.chk_api_funcion.isChecked():
            self.reload_update_fct(True)
        if self.chk_api_trigger.isChecked():
            self.reload_update_trg(True)

    def check_relaod_views(self):

        # sys_custom_views
        sql = ("SELECT value FROM " + self.schema_name + ".config_param_system WHERE parameter = 'sys_custom_views'")
        row = self.controller.get_row(sql)
        if row:
            return True
        return False

    def check_version_schema(self):

        # TODO:: END FUNCION
        # # Python version
        # sql = ("SELECT * FROM ws_sample.audit_log_project WHERE fprocesscat_id=0 AND user_name='' AND enabled=FALSE")
        # row = self.controller.get_row(sql)
        # if xxx:
        #     return False

        return True

    def open_create_project(self):

        # Create dialog
        self.dlg_readsql_create_project = ReadsqlCreateProject()
        self.load_settings(self.dlg_readsql_create_project)


        # Find Widgets in form
        self.project_name = self.dlg_readsql_create_project.findChild(QLineEdit, 'project_name')
        self.project_title = self.dlg_readsql_create_project.findChild(QLineEdit, 'project_title')
        self.project_author = self.dlg_readsql_create_project.findChild(QLineEdit, 'author')
        self.project_date = self.dlg_readsql_create_project.findChild(QLineEdit, 'date')

        self.rdb_no_ct = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_no_ct')
        self.rdb_sample = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_sample')
        self.rdb_sample_dev = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_sample_dev')
        self.rdb_data = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_data')
        self.rdb_import_data = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_import_data')

        self.data_file = self.dlg_readsql_create_project.findChild(QLineEdit, 'data_file')
        self.btn_push_file  = self.dlg_readsql_create_project.findChild(QPushButton, 'btn_push_file')

        if self.permisions is False:
            self.rdb_no_ct.setEnabled(False)
            self.rdb_sample_dev.setEnabled(False)

        self.filter_srid = self.dlg_readsql_create_project.findChild(QLineEdit, 'srid_id')
        utils_giswater.setWidgetText(self.dlg_readsql_create_project, 'srid_id', '25831')
        self.tbl_srid = self.dlg_readsql_create_project.findChild(QTableView, 'tbl_srid')
        self.tbl_srid.setSelectionBehavior(QAbstractItemView.SelectRows)
        sql = "SELECT substr(srtext, 1, 6) as "+'"Type"'+", srid as "+'"SRID"'+", substr(split_part(srtext, ',', 1), 9) as "+'"Description"'+" FROM public.spatial_ref_sys WHERE CAST(srid AS TEXT) LIKE '"+'25831'+"%' ORDER BY substr(srtext, 1, 6), srid"

        # Populate Table
        self.fill_table_by_query(self.tbl_srid, sql)

        # TODO: Populate combo project type with all projects types (Dinamic)
        cmb_project_type = self.dlg_readsql_create_project.findChild(QComboBox, 'cmb_project_type')
        cmb_project_type.addItem('ws')
        cmb_project_type.addItem('ud')
        cmb_project_type.addItem('tree manage')
        # Populate combo with all locales
        self.cmb_locale = self.dlg_readsql_create_project.findChild(QComboBox, 'cmb_locale')
        locales = os.listdir(self.sql_dir + '\i18n/')
        for locale in locales:
            self.cmb_locale.addItem(locale)

        # enable_disable data file widgets
        self.enable_datafile()

        # TODO: Filter line edit and populate table
        self.filter_srid_value = '25831'

        # Set listeners
        self.dlg_readsql_create_project.btn_accept.clicked.connect(partial(self.create_project_data_schema))
        self.dlg_readsql_create_project.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_readsql_create_project))
        self.cmb_locale.currentIndexChanged.connect(partial(self.update_locale))
        self.rdb_import_data.toggled.connect(partial(self.enable_datafile))
        self.filter_srid.textChanged.connect(partial(self.filter_srid_changed))


        # Open dialog
        self.dlg_readsql_create_project.show()

    def open_rename(self):
        # Create dialog
        self.dlg_readsql_rename = ReadsqlRename()
        self.load_settings(self.dlg_readsql_rename)

        # Set listeners
        self.dlg_readsql_rename.btn_accept.clicked.connect(partial(self.rename_project_data_schema))
        self.dlg_readsql_rename.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_readsql_rename))
        print(self.dlg_readsql_rename)

        # Open dialog
        self.dlg_readsql_rename.show()

    def executeFiles(self, filelist, filedir):
        print("test20")
        print(filelist)
        print(filedir)
        if not filelist:
            return
        if self.schema is None:
            schema_name = self.schema_name.replace('"','')
        else:
            schema_name = self.schema.replace('"', '')
        filter_srid_value = str(self.filter_srid_value).replace('"','')
        for file in filelist:
            print(file)
            if ".sql" in file:
                try:
                    f = open(filedir + '/' + file, 'r')
                    if f:
                        f_to_read = str(f.read().replace("SCHEMA_NAME", schema_name).replace("SRID_VALUE", filter_srid_value)).decode(str('utf-8-sig'))
                        self.controller.log_info(str(f_to_read))
                        status = self.controller.execute_sql(str(f_to_read))
                        if status is False:
                            print(str(file))
                            print "Error to execute"
                            self.dao.rollback()
                            return False
                    else:
                        return False
                except Exception as e:
                    print "Command skipped. Unexpected error"
                    print (e)
                    self.dao.rollback()
                    return False
        return True

    def readFiles(self, filelist, filedir):
        for file in filelist:
            print(file)
            if ".txt" in file:
                try:
                    f = open(filedir + '/' + file, 'r')
                    if f:
                        f_to_read = str(f.read()).decode(str('utf-8-sig'))
                        self.controller.log_info(str(f_to_read))
                        self.message_update = self.message_update + '\n' + str(f_to_read)
                    else:
                        return False
                except Exception as e:
                    print "Command skipped. Unexpected error"
                    print (e)
                    self.dao.rollback()
                    return False
        return True