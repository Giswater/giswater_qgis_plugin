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
from PyQt4.QtGui import QCheckBox, QRadioButton, QAction, QWidget, QComboBox, QLineEdit,QPushButton
from PyQt4.QtCore import QSettings
import psycopg2

from dao.controller import DaoController
from ui_manager import ReadsqlCreateProject


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

        # Get widgets from form

        self.chk_schema_ddl_dml = self.dlg_info_show_info.findChild(QRadioButton, 'rdb_ud')
        self.chk_schema_view = self.dlg_info_show_info.findChild(QRadioButton, 'rdb_ws')

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

        self.cmb_locale = 'EN'
        self.filter_srid_value = self.controller.plugin_settings_value('srid')
        print(self.filter_srid_value)
        #TODO: Populate combo project type with all projects types (Dinamic)
        cmb_project_type = self.dlg_info_show_info.findChild(QComboBox, 'cmb_project_type')
        cmb_project_type.addItem('ws')
        cmb_project_type.addItem('ud')
        cmb_project_type.addItem('tree manage')

        # # RadioButton FK & Not null
        # self.rdb_enable_fk = self.dlg_info_show_info.findChild(QRadioButton, 'rdb_enable_fk')
        # self.rdb_disable_fk = self.dlg_info_show_info.findChild(QRadioButton, 'rdb_disable_fk')
        # self.rdb_enable_null = self.dlg_info_show_info.findChild(QRadioButton, 'rdb_enable_null')
        # self.rdb_disable_null = self.dlg_info_show_info.findChild(QRadioButton, 'rdb_disable_null')

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
        self.folderLocale = self.sql_dir + '\i18n/' + self.cmb_locale + '/'
        self.folderUtils = self.sql_dir + '\utils/'
        self.folderUpdates = self.sql_dir + '\updates/'
        self.folderExemple = self.sql_dir, '\example/'
        self.folderPath = ''

        # Set Listeners
        self.dlg_info_show_info.btn_schema_create.clicked.connect(partial(self.open_create_project))
        self.dlg_info_show_info.btn_schema_rename.clicked.connect(partial(self.rename_project_data_schema))
        self.dlg_info_show_info.btn_api_create.clicked.connect(partial(self.implement_api))
        self.dlg_info_show_info.btn_schema_custom_load_file.clicked.connect(partial(self.load_custom_sql_files))
        self.dlg_info_show_info.btn_api_custom_load_file.clicked.connect(partial(self.load_custom_sql_files))
        self.dlg_info_show_info.btn_schema_file_to_db.clicked.connect(partial(self.schema_file_to_db))
        self.dlg_info_show_info.btn_api_file_to_db_2.clicked.connect(partial(self.api_file_to_db))

        cmb_project_type.currentIndexChanged.connect(partial(self.populate_data_shcema_name, cmb_project_type))


        # self.chk_schema_update.stateChanged.connect(partial(self.check_primary_to_foreing, self.chk_schema_update, self.chk_schema_reload_update_funcion, self.chk_schema_reload_update_trigger))
        # self.chk_api_update.stateChanged.connect(partial(self.check_primary_to_foreing, self.chk_api_update, self.chk_api_reload_update_funcion, self.chk_api_reload_update_trigger))
        # self.chk_schema_reload_update_funcion.stateChanged.connect(partial(self.check_foreing_to_primary, self.chk_schema_reload_update_funcion, self.chk_schema_update))
        # self.chk_schema_reload_update_trigger.stateChanged.connect(partial(self.check_foreing_to_primary, self.chk_schema_reload_update_trigger, self.chk_schema_update))
        # self.chk_api_reload_update_funcion.stateChanged.connect(partial(self.check_foreing_to_primary, self.chk_api_reload_update_funcion,self.chk_api_update))
        # self.chk_api_reload_update_trigger.stateChanged.connect(partial(self.check_foreing_to_primary, self.chk_api_reload_update_trigger,self.chk_api_update))

        # TODO:: Descomentar esto
        # if self.check_relaod_views() is True:
        #     self.chk_schema_view.setEnabled(False)
        #     self.chk_api_view.setEnabled(False)
        # if self.check_version_schema() is False:
        #     self.chk_schema_ddl_dml.setEnabled(False)
        #     self.chk_api_ddl_dml.setEnabled(False)

        # Open dialog
        self.dlg_info_show_info.show()

    def load_base(self):

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
        if self.process_folder(self.folderLocale, utils_giswater.getWidgetText(self.dlg_info_show_info, self.cmb_locale)) is False:
            if self.process_folder(self.folderLocale, 'EN') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(
                    self.folderLocale + utils_giswater.getWidgetText(self.dlg_info_show_info, self.cmb_locale)), self.folderLocale + utils_giswater.getWidgetText(self.dlg_info_show_info,self.cmb_locale))
                if status is False:
                    return False
        else:
            status = self.executeFiles(os.listdir(self.folderLocale + utils_giswater.getWidgetText(self.dlg_info_show_info, self.cmb_locale)), self.folderLocale + utils_giswater.getWidgetText(self.dlg_info_show_info, self.cmb_locale))
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
        if self.process_folder(self.folderLocale, utils_giswater.getWidgetText(self.dlg_info_show_info, self.cmb_locale)) is False:
            if self.process_folder(self.folderLocale, 'EN') is False:
                return False
            else:
                status = self.executeFiles(os.listdir(
                    self.folderLocale + utils_giswater.getWidgetText(self.dlg_info_show_info, self.cmb_locale)), self.folderLocale + utils_giswater.getWidgetText(self.dlg_info_show_info,self.cmb_locale))
                if status is False:
                    return False
        else:
            status = self.executeFiles(os.listdir(self.folderLocale + utils_giswater.getWidgetText(self.dlg_info_show_info, self.cmb_locale)), self.folderLocale + utils_giswater.getWidgetText(self.dlg_info_show_info, self.cmb_locale))
            if status is False:
                return False

        print(status)
        return True

    def load_update_ddl_dml(self):

        status = True

        folders = os.listdir(self.folderUpdates + '')
        for folder in folders:
            if str(folder) > str(self.version):
                sub_folders = os.listdir(self.folderUpdates + folder)
                for sub_folder in sub_folders:
                    if str(sub_folder) > str(self.version):
                        if self.process_folder(self.folderUpdates + folder + '/' + sub_folder + '/' + self.project_type + '/','') is False:
                            print(False)
                            return False
                        else:
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
                        if self.process_folder(self.folderUpdates + folder + '/' + sub_folder + '/i18n/' + str(
                                utils_giswater.getWidgetText(self.dlg_info_show_info, self.cmb_locale) + '/'), '') is False:
                            if self.process_folder(self.folderLocale, 'EN') is False:
                                return False
                            else:
                                status = self.executeFiles(os.listdir(
                                    self.folderLocale + utils_giswater.getWidgetText(self.dlg_info_show_info,
                                                                                     self.cmb_locale)),
                                    self.folderLocale + utils_giswater.getWidgetText(self.dlg_info_show_info,
                                                                                     self.cmb_locale))
                                if status is False:
                                    return False
                        else:
                            status = self.executeFiles(os.listdir(self.folderUpdates + folder + '/' + sub_folder + '/utils/'), self.folderUpdates + folder + '/' + sub_folder + '/utils/')
                            if status is False:
                                print(False)
                                return False

        print(status)
        return True

    def load_views(self):

        status = True

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

    def load_fct(self):

        status = True

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

    def load_rules(self):

        status = True

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

    def load_fk(self):

        status = True
        print(status)
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

    def load_trg(self):

        status = True

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
    def load_sql(self):
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
        if self.rdb_import_data.isChecked():
            print("rdb_import_data")
            self.load_base_no_ct()
            self.execute_import_data()
            self.load_fk()
            self.load_rules()
            self.load_trg()
            self.load_dev_data()
            # self.execute_last_process()
            return
        elif self.rdb_no_ct.isChecked():
            print(str("rdb_no_ct"))
            self.load_base_no_ct()
            self.load_update_ddl_dml()
            self.load_views()
            # self.execute_last_process()
            return
        elif self.rdb_sample.isChecked():
            print(str("rdb_sample"))
            self.load_base()
            self.update_ddl_dml()
            self.load_views()
            self.load_sample_data()
            # self.execute_last_process()
            return
        elif self.rdb_sample_dev.isChecked():
            print(str("rdb_sample_dev"))
            self.load_base()
            self.load_update_ddl_dml()
            self.load_views()
            self.load_sample_data()
            self.load_dev_data()
            # self.execute_last_process()
            return
        elif self.rdb_data.isChecked():
            print(str("rdb_data"))
            self.load_base()
            self.load_update_ddl_dml()
            self.load_views()
            # self.execute_last_process()
            return

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
        self.load_trg()
        self.load_fk()
        self.load_rules()
        self.load_views()
        # self.execute_last_process()

    def implement_api(self):
        self.load_base()
        self.load_update_ddl_dml()
        self.load_views()
        # self.execute_last_process()

    def load_custom_sql_files(self):
        self.load_sql()
        # self.execute_last_process()


    # CHECKBOX CALLING FUNCTIONS

    def update_ddl_dml(self):
        self.load_update_ddl_dml()
        # self.execute_last_process()

    def reload_views(self):
        self.load_views()
        # self.execute_last_process()

    def reload_update_fk(self):
        self.load_fk()
        # self.execute_last_process()

    def reload_update_rules(self):
        self.load_rules()
        # self.execute_last_process()

    def reload_update_fct(self):
        self.load_fct()
        # self.execute_last_process()

    def reload_update_trg(self):
        self.load_trg()
        # self.execute_last_process()


    # OTHER FUNCTIONS

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
        self.filter_srid_value = utils_giswater.getWidgetText(self.dlg_readsql_create_project, self.filter_srid)

    def process_folder(self, folderPath, filePattern):
        status = True

        try:
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
            self.update_ddl_dml()
        if self.chk_api_view.isChecked():
            self.reload_views()
        if self.chk_api_fk.isChecked():
            self.reload_update_fk()
        if self.chk_api_rules.isChecked():
            self.reload_update_rules()
        if self.chk_api_funcion.isChecked():
            self.reload_update_fct()
        if self.chk_api_trigger.isChecked():
            self.reload_update_trg()

    def check_foreing_to_primary(self, foreing_widget, primary_widget):
        if foreing_widget.isChecked() == False:
            primary_widget.setChecked(False)

    def check_primary_to_foreing(self, primary_widget, foreing_widget1, foreing_widget2):
        if primary_widget.isChecked() == False:
            foreing_widget1.setChecked(False)
            foreing_widget2.setChecked(False)
        elif primary_widget.isChecked() == True:
            foreing_widget1.setChecked(True)
            foreing_widget2.setChecked(True)

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
        # sql = ("SELECT giswater FROM" + self.schema_name + ".version WHERE wsoftware = '" + self.project_type + "'")
        # row = self.controller.get_row(sql)
        # if row > 'python_version':
        #     return False

        return True

    def open_create_project(self):

        # Create dialog
        self.dlg_readsql_create_project = ReadsqlCreateProject()
        self.load_settings(self.dlg_readsql_create_project)

        permisions = False

        # Find Widgets in form
        self.project_name = self.dlg_readsql_create_project.findChild(QLineEdit, 'project_name')
        self.project_title = self.dlg_readsql_create_project.findChild(QLineEdit, 'project_title')
        self.project_author = self.dlg_readsql_create_project.findChild(QLineEdit, 'author')
        self.project_date = self.dlg_readsql_create_project.findChild(QLineEdit, 'date')

        self.rdb_no_ct = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_no_ct')
        self.rdb_sample = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_sample')
        self.rdb_sample_dev = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_sample_dev')
        self.rdb_data = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_data')

        self.data_file = self.dlg_readsql_create_project.findChild(QLineEdit, 'data_file')
        self.btn_push_file  = self.dlg_readsql_create_project.findChild(QPushButton, 'btn_push_file')


        if permisions is False:
            self.rdb_no_ct.setEnabled(False)
            self.rdb_sample_dev.setEnabled(False)

        self.filter_srid = self.dlg_readsql_create_project.findChild(QLineEdit, 'filter')

        self.rdb_import_data = self.dlg_readsql_create_project.findChild(QRadioButton, 'rdb_import_data')

        # TODO::
        cmb_project_type = self.dlg_readsql_create_project.findChild(QComboBox, 'cmb_project_type')
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
        self.dlg_readsql_create_project.btn_accept.clicked.connect(partial(self.executeFiles))
        self.cmb_locale.currentIndexChanged.connect(partial(self.update_locale))
        self.rdb_import_data.toggled.connect(partial(self.enable_datafile))
        self.filter_srid.textChanged.connect(partial(self.filter_srid_changed))

        # Open dialog
        self.dlg_readsql_create_project.show()

    def executeFiles(self, filelist, filedir):
        schema_name = self.schema_name.replace('"','')
        filter_srid_value = self.filter_srid_value.replace('"','')
        for file in filelist:
            try:
                f = open(filedir + '/' + file, 'r')
                if f:
                    f_to_read = str(f.read().replace("SCHEMA_NAME", schema_name).replace("SRID", filter_srid_value).decode(str('utf-8-sig')))
                    # f_to_read = str(f.read().replace("SRID", filter_srid_value))
                    # f_to_read = f_to_read.decode(str('utf-8-sig'))
                    status = self.controller.execute_sql(str(f_to_read))
                    if status is False:
                        print(str(file))
                        return False
                else:
                    return False
            except:
                print "Command skipped. Unexpected error"
                # self.dao.rollback()
                # self.dao.close()
                # print lengthy error description!!
                # sys.exit(2)
        return True