"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
import re
import psycopg2
import psycopg2.extras
import subprocess
from functools import partial
import json
import ast

from ..ui.ui_manager import GwAdminTranslationUi
from ..utils import tools_gw
from ...libs import lib_vars, tools_qt, tools_qgis, tools_db
from PyQt5.QtWidgets import QApplication


class GwI18NGenerator:

    def __init__(self):
        self.plugin_dir = lib_vars.plugin_dir
        self.schema_name = lib_vars.schema_name


    def init_dialog(self):
        """ Constructor """

        self.dlg_qm = GwAdminTranslationUi(self)
        tools_gw.load_settings(self.dlg_qm)

        self._load_user_values()

        self.dlg_qm.btn_translate.setEnabled(False)
        # Mysteriously without the partial the function check_connection is not called
        self.dlg_qm.btn_connection.clicked.connect(partial(self._check_connection))
        self.dlg_qm.btn_translate.clicked.connect(self._check_translate_options)
        self.dlg_qm.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_qm))
        self.dlg_qm.rejected.connect(self._save_user_values)
        self.dlg_qm.rejected.connect(self._close_db)
        self.dlg_qm.cmb_language.currentIndexChanged.connect(partial(self._set_editability_dbmessage))
        tools_gw.open_dialog(self.dlg_qm, dlg_name='admin_translation')


    def pass_schema_info(self, schema_info, schema_name):
        self.project_type = schema_info['project_type']
        self.project_epsg = schema_info['project_epsg']
        self.project_version = schema_info['project_version']
        self.project_language = schema_info['project_language']
        self.schema_name = schema_name

    # region private functions


    def _check_connection(self):
        """ Check connection to database """

        self.dlg_qm.cmb_language.clear()
        self.dlg_qm.lbl_info.clear()
        self._close_db()
        host = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_host)
        port = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_port)
        db = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_db)
        user = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_user)
        password = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_pass)
        status = self._init_db(host, port, db, user, password)

        if not status:
            self.dlg_qm.btn_translate.setEnabled(False)
            tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', self.last_error)
            return
        self._populate_cmb_language()


    def _populate_cmb_language(self):
        """ Populate combo with languages values """

        self.dlg_qm.btn_translate.setEnabled(True)
        host = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_host)
        tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', f'Connected to {host}')
        sql = "SELECT id, idval FROM i18n.cat_language"
        rows = self._get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_qm.cmb_language, rows)
        language = tools_gw.get_config_parser('i18n_generator', 'qm_lang_language', "user", "init", False)

        tools_qt.set_combo_value(self.dlg_qm.cmb_language, language, 0)


    def _check_translate_options(self):
        """ Check the translation options selected by the user """
        py_msg = tools_qt.is_checked(self.dlg_qm, self.dlg_qm.chk_py_msg)
        db_msg = tools_qt.is_checked(self.dlg_qm, self.dlg_qm.chk_db_msg)
        refresh_i18n = tools_qt.is_checked(self.dlg_qm, self.dlg_qm.chk_refresh_i18n)
        # missing_translations = tools_qt.is_checked(self.dlg_qm, self.dlg_qm.chk_missing_translations)

        self.dlg_qm.lbl_info.clear()
        msg = ''
        self.language = tools_qt.get_combo_value(self.dlg_qm, self.dlg_qm.cmb_language, 0)
        self.lower_lang = self.language.lower()
        self.schema_i18n = "i18n"
        # TODO ('Next release 3.6.011')
        # if missing_translations:
        #     self._check_missing_dbmessage_values()

        if py_msg:
            status_py_msg = self._create_py_files()
            if status_py_msg is True:
                msg += "Python translation successful\n"
            elif status_py_msg is False:
                msg += "Python translation failed\n"
            elif status_py_msg is None:
                msg += "Python translation canceled\n"

        if db_msg:
            status_cfg_msg = self._create_db_files()
            if status_cfg_msg is True:
                msg += "Database translation successful\n"
            elif status_cfg_msg is False:
                msg += "Database translation failed\n"
            elif status_cfg_msg is None:
                msg += "Database translation canceled\n"

        if refresh_i18n:
            status_i18n_msg, table = self._create_i18n_files()
            if status_i18n_msg is True:
                msg += "Database i18n translation successful\n"
            elif status_i18n_msg is False:
                msg += f"Database i18n translation failed in {table}\n"
            elif status_i18n_msg is None:
                msg += "Database i18n translation canceled\n"

        if msg != '':
            tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', msg)


    def _create_py_files(self):
        """ Read the values of the database and generate the ts and qm files """

        # On the database, the dialog_name column must match the name of the ui file (no extension).
        # Also, open_dialog function must be called, passed as parameter dlg_name = 'ui_file_name_without_extension'

        key_label = f'lb_{self.lower_lang}'
        key_tooltip = f'tt_{self.lower_lang}'
        key_message = f'ms_{self.lower_lang}'

        # Get python messages values

        # Get python toolbars and buttons values
        if self.lower_lang == 'en_us':
            sql = f"SELECT source, ms_en_us FROM i18n.pymessage;"  # ADD new columns
            py_messages = self._get_rows(sql)
            sql = f"SELECT source, lb_en_us FROM i18n.pytoolbar;"
            py_toolbars = self._get_rows(sql)
            # Get python dialog values
            sql = (f"SELECT dialog_name, source, lb_en_us, tt_en_us"
                f" FROM i18n.pydialog"
                f" ORDER BY dialog_name;")
            py_dialogs = self._get_rows(sql)
        else:
            sql = f"SELECT source, ms_en_us, {key_message}, auto_{key_message} FROM i18n.pymessage;"  # ADD new columns
            py_messages = self._get_rows(sql)
            sql = f"SELECT source, lb_en_us, {key_label}, auto_{key_label} FROM i18n.pytoolbar;"
            py_toolbars = self._get_rows(sql)
            # Get python dialog values
            sql = (f"SELECT dialog_name, source, lb_en_us, {key_label}, auto_{key_label}, tt_en_us, {key_tooltip}, auto_{key_tooltip}"
                f" FROM i18n.pydialog"
                f" ORDER BY dialog_name;")
            py_dialogs = self._get_rows(sql)

        ts_path = self.plugin_dir + os.sep + 'i18n' + os.sep + f'giswater_{self.language}.ts'

        # Check if file exist
        if os.path.exists(ts_path):
            msg = "Are you sure you want to overwrite this file?"
            answer = tools_qt.show_question(msg, "Overwrite", parameter=f"\n\n{ts_path}")
            if not answer:
                return None
        ts_file = open(ts_path, "w")

        # Create header
        line = '<?xml version="1.0" encoding="utf-8"?>\n'
        line += '<!DOCTYPE TS>\n'
        line += f'<TS version="2.0" language="{self.language}">\n'
        ts_file.write(line)

        # Create children for toolbars and actions
        line = '\t<!-- TOOLBARS AND ACTIONS -->\n'
        line += '\t<context>\n'
        line += '\t\t<name>giswater</name>\n'
        ts_file.write(line)
        for py_tlb in py_toolbars:
            line = f"\t\t<message>\n"
            line += f"\t\t\t<source>{py_tlb['source']}</source>\n"
            if py_tlb[key_label] is None:  # Afegir aqui l'auto amb un if
                py_tlb[key_label] = py_tlb[f'auto_{key_label}']
                if py_tlb[f'auto_{key_label}'] is None:
                    py_tlb[key_label] = py_tlb['lb_en_us']
                    if py_tlb['lb_en_us'] is None:
                        py_tlb[key_label] = py_tlb['source']

            line += f"\t\t\t<translation>{py_tlb[key_label]}</translation>\n"
            line += f"\t\t</message>\n"
            line = line.replace("&", "")
            ts_file.write(line)

        line = '\t\t<!-- PYTHON MESSAGES -->\n'
        ts_file.write(line)

        # Create children for message
        for py_msg in py_messages:
            line = f"\t\t<message>\n"
            line += f"\t\t\t<source>{py_msg['source']}</source>\n"
            if py_msg[key_message] is None:  # Afegir aqui l'auto amb un if
                py_msg[key_message] = py_msg[f'auto_{key_message}']
                if py_msg[f'auto_{key_message}'] is None:
                    py_msg[key_message] = py_msg['source']
            line += f"\t\t\t<translation>{py_msg[key_message]}</translation>\n"
            line += f"\t\t</message>\n"
            line = line.replace("&", "")
            ts_file.write(line)
        line = '\t</context>\n\n'

        line += '\t<!-- UI TRANSLATION -->\n'
        ts_file.write(line)

        # Create children for ui
        name = None
        for py_dlg in py_dialogs:
            # Create child <context> (ui's name)
            if name and name != py_dlg['dialog_name']:
                line += '\t</context>\n'
                ts_file.write(line)

            if name != py_dlg['dialog_name']:
                name = py_dlg['dialog_name']
                line = '\t<context>\n'
                line += f'\t\t<name>{name}</name>\n'
                title = self._get_title(py_dialogs, name, key_label)
                if title:
                    line += f'\t\t<message>\n'
                    line += f'\t\t\t<source>title</source>\n'
                    line += f'\t\t\t<translation>{title}</translation>\n'
                    line += f'\t\t</message>\n'

            # Create child for labels
            line += f"\t\t<message>\n"
            line += f"\t\t\t<source>{py_dlg['source']}</source>\n"
            if py_dlg[key_label] is None:  # Afegir aqui l'auto amb un if
                if self.lower_lang != 'en_us':
                    py_dlg[key_label] = py_dlg[f'auto_{key_label}']
                if py_tlb[key_label] is None:
                    py_dlg[key_label] = py_dlg['lb_en_us']

            line += f"\t\t\t<translation>{py_dlg[key_label]}</translation>\n"
            line += f"\t\t</message>\n"

            # Create child for tooltip
            line += f"\t\t<message>\n"
            line += f"\t\t\t<source>tooltip_{py_dlg['source']}</source>\n"
            if py_dlg[key_tooltip] is None:  # Afegir aqui l'auto amb un if
                if self.lower_lang != 'en_us':
                    py_dlg[key_tooltip] = py_dlg[f'auto_{key_tooltip}']
                if not py_dlg[key_tooltip]:  # Afegir aqui l'auto amb un if
                    py_dlg[key_tooltip] = py_dlg['tt_en_us']
            line += f"\t\t\t<translation>{py_dlg[key_tooltip]}</translation>\n"
            line += f"\t\t</message>\n"

        # Close last context and TS
        line += '\t</context>\n'
        line += '</TS>\n\n'
        line = line.replace("&", "")
        ts_file.write(line)
        ts_file.close()
        del ts_file

        lrelease_path = f"{self.plugin_dir}{os.sep}resources{os.sep}i18n{os.sep}lrelease.exe"
        status = subprocess.call([lrelease_path, ts_path], shell=False)
        if status == 0:
            return True
        else:
            return False


    def _get_title(self, py_dialogs, name, key_label):
        """ Return title's according language """

        title = None
        for py in py_dialogs:
            if py['source'] == f'dlg_{name}':
                title = py[key_label]
                if not title:  # Afegir aqui l'auto amb un if
                    if self.lower_lang != 'en_us':
                        title = py[f'auto_{key_label}']
                    if not title:
                        title = py['lb_en_us']
                    return title
                return title
        return title

    
    def _create_db_files(self):
        """ Read the values of the database and update the i18n files """

        major_version = tools_qgis.get_major_version(plugin_dir=self.plugin_dir).replace(".", "")
        ver_build = tools_qgis.get_build_version(plugin_dir=self.plugin_dir)

        cfg_path = f"{self.plugin_dir}{os.sep}dbmodel{os.sep}updates{os.sep}{major_version}{os.sep}{ver_build}" \
                   f"{os.sep}i18n{os.sep}{self.language}{os.sep}"
        file_name = f'dml.sql'

        # Check if file exist
        if os.path.exists(cfg_path + file_name):
            msg = "Are you sure you want to overwrite this file?"
            answer = tools_qt.show_question(msg, "Overwrite", parameter=f"\n\n{cfg_path}{file_name}")
            if not answer:
                return None, ""
        else:
            os.makedirs(cfg_path, exist_ok=True)

        # Get All table values
        self._write_header(cfg_path + file_name)
        dbtables = [ "dbparam_user", "dbconfig_param_system", "dbconfig_form_fields", "dbconfig_typevalue", 
                    "dbfprocess", "dbmessage", "dbconfig_csv", "dbconfig_form_tabs", "dbconfig_report", 
                    "dbconfig_toolbox", "dbfunction", "dbtypevalue", "dbconfig_form_tableview",
                    "dbtable", "dbconfig_form_fields_feat", "su_basic_tables", "su_feature", "dbjson"
                 ]

        for dbtable in dbtables:
            dbtable_rows, dbtable_columns = self._get_table_values(dbtable)
            if not dbtable_rows:
                return False, dbtable
            else:
                if dbtable == 'dbjson':
                    self._write_dbjson_values_i18n(dbtable_rows, cfg_path + file_name)
                else:
                    self._write_table_values_i18n(dbtable_rows, dbtable_columns, dbtable, cfg_path + file_name)            

        return True, ""

    
    def _create_i18n_files(self):
        """ Read the values of the database and update the i18n files """

        cfg_path = f"{self.plugin_dir}{os.sep}dbmodel{os.sep}i18n{os.sep}{self.language}{os.sep}"
        file_name = f'dml.sql'


        # Check if file exist
        if os.path.exists(cfg_path + file_name):
            msg = "Are you sure you want to overwrite this file?"
            answer = tools_qt.show_question(msg, "Overwrite", parameter=f"\n\n{cfg_path}{file_name}")
            if not answer:
                return None
        else:
            os.makedirs(cfg_path, exist_ok=True)

        # for project_type in ["ws", "ud"]:
        #     rows = self._get_dbfeature_values(project_type)
        #     if not rows:
        #         return False, f"config_form_fields_{project_type}"
        #     self._write_header(cfg_path + f"{project_type}_{file_name}")
        #     self._write_dbfeature_updates(rows, cfg_path + f"{project_type}_{file_name}")

        # Get All table values
        self._write_header(cfg_path + file_name)
        dbtables = [ "dbparam_user", "dbconfig_param_system", "dbconfig_form_fields", "dbconfig_typevalue", 
                    "dbfprocess", "dbmessage", "dbconfig_csv", "dbconfig_form_tabs", "dbconfig_report", 
                    "dbconfig_toolbox", "dbfunction", "dbtypevalue", "dbconfig_form_tableview", 
                    "dbtable", "dbconfig_form_fields_feat", "su_basic_tables", "su_feature", "dbjson"
                 ]

        for dbtable in dbtables:
            dbtable_rows, dbtable_columns = self._get_table_values(dbtable)
            if not dbtable_rows:
                return False, dbtable
            else:
                if dbtable == 'dbjson':
                    self._write_dbjson_values_i18n(dbtable_rows, cfg_path + file_name)
                else:
                    self._write_table_values_i18n(dbtable_rows, dbtable_columns, dbtable, cfg_path + file_name) 

        return True, ""


    def _check_missing_dbmessage_values(self):
        """ Get db message values from schema_name """

        sql_main = (f"SELECT id, project_type, error_message, hint_message, log_level "
                    f"FROM {self.schema_name}.sys_message "
                    f"WHERE project_type = \'{self.project_type}\' or project_type = 'utils'")
        rows_main = tools_db.get_rows(sql_main)

        if rows_main:
            for row in rows_main:
                # Get values
                source = row['id'] if row['id'] is not None else ""
                project_type = row['project_type'] if row['project_type'] is not None else ""
                ms_msg = row['error_message'] if row['error_message'] is not None else ""
                ht_msg = row['hint_message'] if row['hint_message'] is not None else ""
                log_level = row['log_level'] if row['log_level'] is not None else 2

                sql_i18n = (
                    f" SELECT source, project_type, context, ms_{self.project_language.lower()}, ht_{self.project_language.lower()}"
                    f" FROM i18n.dbmessage "
                    f" WHERE source = \'{source}\'")
                rows_i18n = self._get_rows(sql_i18n)

                if not rows_i18n:
                    sql_insert = (f"INSERT INTO i18n.dbmessage "
                                  f"(source, project_type, context, ms_{self.project_language.lower()}, ht_{self.project_language.lower()}, source_code, log_level) "
                                  f"VALUES ('{source}', '{project_type}', 'sys_message', $${ms_msg}$$, $${ht_msg}$$, 'giswater', {log_level});")
                    self._get_rows(sql_insert)

        
    def _write_header(self, path):
        """
        Write the file header
            :param path: Full destination path (String)
        """

        file = open(path, "w")
        header = (f'/*\n'
                  f'This file is part of Giswater\n'
                  f'The program is free software: you can redistribute it and/or modify it under the terms of the GNU '
                  f'General Public License as published by the Free Software Foundation, either version 3 of the '
                  f'License, or (at your option) any later version.\n'
                  f'This version of Giswater is provided by Giswater Association,\n'
                  f'*/\n\n\n'
                  f'SET search_path = SCHEMA_NAME, public, pg_catalog;\n'
                  f"UPDATE config_param_system SET value = FALSE WHERE parameter = 'admin_config_control_trigger';\n\n")
        file.write(header)
        file.close()
        del file


    def _get_table_values(self, table):
        """ Get table values """

        # Update the part the of the program in process
        self.dlg_qm.lbl_info.clear()
        msg = f"Updating {table}..."
        tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', msg)
        QApplication.processEvents()
        colums = []
        lang_colums = []

        if table == 'dbconfig_form_fields':
            colums = ["source", "formname", "formtype", "project_type", "context", "source_code", "lb_en_us", "tt_en_us"]
            lang_colums = [f"lb_{self.lower_lang}", f"tt_{self.lower_lang}", f"auto_lb_{self.lower_lang}", f"va_auto_lb_{self.lower_lang}", f"auto_tt_{self.lower_lang}", f"va_auto_tt_{self.lower_lang}"]
        
        elif table == 'dbparam_user':
            colums = ["source", "formname", "project_type", "context", "source_code", "lb_en_us", "tt_en_us"]
            lang_colums = [f"lb_{self.lower_lang}", f"tt_{self.lower_lang}", f"auto_lb_{self.lower_lang}", f"va_auto_lb_{self.lower_lang}", f"auto_tt_{self.lower_lang}", f"va_auto_tt_{self.lower_lang}"]
        
        elif table == 'dbconfig_param_system':
            colums = ["source", "project_type", "context", "source_code", "lb_en_us", "tt_en_us"]
            lang_colums = [f"lb_{self.lower_lang}", f"tt_{self.lower_lang}", f"auto_lb_{self.lower_lang}", f"va_auto_lb_{self.lower_lang}", f"auto_tt_{self.lower_lang}", f"va_auto_tt_{self.lower_lang}"]
        
        elif table == 'dbconfig_typevalue':
            colums = ["source", "formname", "formtype", "project_type", "context", "source_code", "tt_en_us"]
            lang_colums = [f"tt_{self.lower_lang}", f"auto_tt_{self.lower_lang}", f"va_auto_tt_{self.lower_lang}"]

        elif table == 'dbmessage':
            colums = ["source", "project_type", "context", "log_level", "ms_en_us", "ht_en_us"]
            lang_colums = [f"ms_{self.lower_lang}", f"auto_ms_{self.lower_lang}", f"va_auto_ms_{self.lower_lang}," f"ht_{self.lower_lang}", f"auto_ht_{self.lower_lang}", f"va_auto_ht_{self.lower_lang}"]
        
        elif table == 'dbfprocess':
            colums = ["source", "project_type", "context", "ex_en_us", "in_en_us", "na_en_us"]
            lang_colums = [f"ex_{self.lower_lang}", f"auto_ex_{self.lower_lang}", f"va_auto_ex_{self.lower_lang}," f"in_{self.lower_lang}", f"auto_in_{self.lower_lang}", f"va_auto_in_{self.lower_lang}", f"na_{self.lower_lang}", f"auto_na_{self.lower_lang}", f"va_auto_na_{self.lower_lang}"]
        
        elif table == 'dbconfig_csv':
            colums = ["source", "project_type", "context", "al_en_us", "ds_en_us"]
            lang_colums = [f"al_{self.lower_lang}", f"auto_al_{self.lower_lang}", f"va_auto_al_{self.lower_lang}", f"ds_{self.lower_lang}", f"auto_ds_{self.lower_lang}", f"va_auto_ds_{self.lower_lang}"]

        elif table == 'dbconfig_form_tabs':
            colums = ["formname", "source", "project_type", "context", "lb_en_us", "tt_en_us"]
            lang_colums = [f"lb_{self.lower_lang}", f"tt_{self.lower_lang}", f"auto_lb_{self.lower_lang}", f"va_auto_lb_{self.lower_lang}", f"auto_tt_{self.lower_lang}", f"va_auto_tt_{self.lower_lang}"]
        
        elif table == 'dbconfig_report':
            colums = ["source", "project_type", "context", "al_en_us", "ds_en_us"]
            lang_colums = [f"al_{self.lower_lang}", f"auto_al_{self.lower_lang}", f"va_auto_al_{self.lower_lang}", f"ds_{self.lower_lang}", f"auto_ds_{self.lower_lang}", f"va_auto_ds_{self.lower_lang}"]
        
        elif table == 'dbconfig_toolbox':
            colums = ["source", "project_type", "context", "al_en_us", "ob_en_us"]
            lang_colums = [f"al_{self.lower_lang}", f"auto_al_{self.lower_lang}", f"va_auto_al_{self.lower_lang}", f"ob_{self.lower_lang}", f"auto_ob_{self.lower_lang}", f"va_auto_ob_{self.lower_lang}"]
       
        elif table == 'dbfunction':
            colums = ["source", "project_type", "context", "ds_en_us"]
            lang_colums = [f"ds_{self.lower_lang}", f"auto_ds_{self.lower_lang}", f"va_auto_ds_{self.lower_lang}"]
       
        elif table == 'dbtypevalue':
            colums = ["source", "project_type", "context", "typevalue", "vl_en_us", "ds_en_us"]
            lang_colums = [f"vl_{self.lower_lang}", f"auto_vl_{self.lower_lang}", f"va_auto_vl_{self.lower_lang}", f"ds_{self.lower_lang}", f"auto_ds_{self.lower_lang}", f"va_auto_ds_{self.lower_lang}"]

        elif table == 'dbconfig_form_tableview':
            colums = ["source", "columnname", "project_type", "context", "location_type", "al_en_us"]
            lang_colums = [f"al_{self.lower_lang}", f"auto_al_{self.lower_lang}", f"va_auto_al_{self.lower_lang}", ]

        elif table == 'dbjson':
            colums = ["source", "project_type", "context", "hint", "text", "lb_en_us"]
            lang_colums = [f"lb_{self.lower_lang}", f"auto_lb_{self.lower_lang}", f"va_auto_lb_{self.lower_lang}"]
        
        elif table == 'dbconfig_form_fields_feat':
            colums = ["feature_type","source", "formname", "formtype", "project_type", "context", "source_code", "lb_en_us", "tt_en_us"]
            lang_colums = [f"lb_{self.lower_lang}", f"tt_{self.lower_lang}", f"auto_lb_{self.lower_lang}", f"va_auto_lb_{self.lower_lang}", f"auto_tt_{self.lower_lang}", f"va_auto_tt_{self.lower_lang}"]

        elif table == 'dbtable':
            colums = ["source", "project_type", "context", "al_en_us", "ds_en_us"]
            lang_colums = [f"al_{self.lower_lang}", f"auto_al_{self.lower_lang}", f"va_auto_al_{self.lower_lang}", f"ds_{self.lower_lang}", f"auto_ds_{self.lower_lang}", f"va_auto_ds_{self.lower_lang}"]
        
        elif table == 'su_basic_tables':
            colums = ["source", "project_type", "context", "na_en_us", "ob_en_us"]
            lang_colums = [f"na_{self.lower_lang}", f"auto_na_{self.lower_lang}", f"va_auto_na_{self.lower_lang}", f"ob_{self.lower_lang}", f"auto_ob_{self.lower_lang}", f"va_auto_ob_{self.lower_lang}"]

        elif table == 'su_feature':
            colums = ["project_type", "context", "feature_class", "feature_type", "lb_en_us", "ds_en_us"]
            lang_colums = [f"lb_{self.lower_lang}", f"auto_lb_{self.lower_lang}", f"va_auto_lb_{self.lower_lang}", f"ds_{self.lower_lang}", f"auto_ds_{self.lower_lang}", f"va_auto_ds_{self.lower_lang}"]
        

        # Make the query
        sql=""
        if self.lower_lang == 'en_us':
            sql = (f"SELECT {", ".join(colums)} "
               f"FROM {self.schema_i18n}.{table} "
               f"ORDER BY context")
        else:
            sql = (f"SELECT {", ".join(colums)}, {", ".join(lang_colums)} "
               f"FROM {self.schema_i18n}.{table} "
               f"ORDER BY context")
        rows = self._get_rows(sql, self.cursor_i18n)
        print(sql)

        # Return the corresponding information
        if not rows:
            return False
        return rows, colums

    def _get_dbfeature_values(self, project_type):
        """ Get db dialog values """
        if self.lower_lang == 'en_us':
            sql = (f"SELECT formname_en_us"
                f" FROM i18n.dbfeature"
                f" WHERE project_type = \'{project_type}\';")
        else:
            sql = (f"SELECT formname_en_us, formname_{self.lower_lang}, auto_formname_{self.lower_lang}"
                f" FROM i18n.dbfeature"
                f" WHERE project_type = \'{project_type}\';")
        rows = self._get_rows(sql)
        if not rows:
            return False
        return rows
    

    def _write_table_values_i18n(self, rows, columns, table, path):
        """
        Generate a string and write into file
            :param rows: List of values ([List][List])
            :param path: Full destination path (String)
            :return: (Boolean)
        """

        file = open(path, "a")
        j=0
        for i, row in enumerate(rows): #(For row in rows)
            if row['project_type'] == self.project_type or row['project_type'] == 'utils': # Avoid the unwnated project_types
                forenames = []
                for column in columns:
                    if column[-5:] == "en_us":
                        forenames.append(column.split("_")[0])

                texts = []
                for forename in forenames:
                    text = row[f'{forename}_{self.lower_lang}']
                    if text is None:
                        if self.lower_lang != 'en_us':
                            text = row[f'auto_{forename}_{self.lower_lang}']
                        if text is None :
                            text = row[f'{forename}_en_us']
                            if text is None:
                                if forename == 'tt' and table in ["dbconfig_form_fields", "dbconfig_param_system", "dbparam_user"]:
                                    text = row[f'lb_en_us']
                                if text is None:
                                    text = ""
                    text = text.replace("'", "''")
                    texts.append(text)
                
                # Check invalid characters
                for i, text in enumerate(texts):
                    if texts[i] is not None:
                        texts[i] = self._replace_invalid_quotation_marks(texts[i])
                        if "\n" in texts[i]:
                            texts[i] = self._replace_invalid_characters(texts[i])

                #Define the query depending on the table
                line = ''
                   
                if 'dbconfig_form_fields' in table:
                    if 'feat' in table:
                        feature_types = ['ARC', 'CONNEC', 'NODE', 'GULLY', 'LINK', 'ELEMENT']
                        for feature_type in feature_types:
                            if row['feature_type'] == feature_type:
                                formname = row['feature_type'].lower()
                                line += (f'UPDATE {row['context']} SET label = \'{texts[0]}\', tooltip = \'{texts[1]}\' '
                                        f'WHERE formname LIKE \'%_{formname}%\' AND formtype = \'{row['formtype']}\' AND columnname = \'{row['source']}\';\n')
                                break
                    else:
                        line += (f"UPDATE {row['context']} SET label = '{texts[0]}', tooltip = '{texts[1]}' "
                                f"WHERE formname = '{row['formname']}' AND formtype = '{row['formtype']}' AND columnname = '{row['source']}';\n")

                elif 'dbparam_user' in table:
                    line += (f"UPDATE {row['context']} SET label = '{texts[0]}', descript = '{texts[1]}' "
                                f"WHERE id = '{row['source']}';\n")

                elif 'dbconfig_param_system' in table:
                    line += (f"UPDATE {row['context']} SET label = '{texts[0]}', descript = '{texts[1]}' "
                                f"WHERE parameter = '{row['source']}';\n")

                elif 'dbconfig_typevalue' in table:
                    line += (f"UPDATE {row['context']} SET idval = '{texts[0]}' "
                                f"WHERE id = '{row['source']}' AND typevalue = '{row['formname']}';\n")

                elif 'dbmessage' in table:
                    line += (f"UPDATE {row['context']} SET error_message = '{texts[0]}', hint_message = '{texts[1]}' "
                                f"WHERE id = '{row['source']}';\n")

                elif 'dbfprocess' in table:
                    line += (f"UPDATE {row['context']} SET except_msg = '{texts[0]}', info_msg = '{texts[1]}', fprocess_name = '{texts[2]}' "
                                f"WHERE fid = '{row['source']}';\n")

                elif 'dbconfig_csv' in table:
                    line += (f"UPDATE {row['context']} SET alias = '{texts[0]}', descript = '{texts[1]}' "
                                f"WHERE fid = '{row['source']}';\n")

                elif 'dbconfig_form_tabs' in table:
                    line += (f"UPDATE {row['context']} SET label = '{texts[0]}', tooltip = '{texts[1]}' "
                                f"WHERE formname = '{row['formname']}' AND tabname = '{row['source']}';\n")

                elif 'dbconfig_report' in table:
                    line += (f"UPDATE {row['context']} SET alias = '{texts[0]}', descript = '{texts[1]}' "
                                f"WHERE id = '{row['source']}';\n")

                elif 'dbconfig_toolbox' in table:
                    line += (f"UPDATE {row['context']} SET alias = '{texts[0]}', observ = '{texts[1]}' "
                                f"WHERE id = '{row['source']}';\n")

                elif 'dbfunction' in table:
                    line += (f"UPDATE {row['context']} SET descript = '{texts[0]}' "
                                f"WHERE id = '{row['source']}';\n")

                elif 'dbtypevalue' in table:
                    line += (f"UPDATE {row['context']} SET idval = '{texts[0]}', descript = '{texts[1]}' "
                                f"WHERE id = '{row['source']}' AND typevalue = '{row['typevalue']}';\n")

                elif 'dbconfig_form_tableview' in table:
                    line += (f"UPDATE {row['context']} SET alias = '{texts[0]}' "
                                f"WHERE objectname = '{row['source']}' AND columnname = '{row['columnname']}';\n")

                elif 'dbtable' in table:
                    line += (f"UPDATE {row['context']} SET alias = '{texts[0]}', descript = '{texts[1]}' "
                                f"WHERE id = '{row['source']}';\n")
                    
                elif 'value_state' == row['context']:
                    line += (f"UPDATE {row['context']} SET name = '{texts[0]}', observ = '{texts[1]}' "
                                f"WHERE id = '{row['source']}';\n")
                
                elif 'value_state_type' == row['context']:
                    line += (f"UPDATE {row['context']} SET name = '{texts[0]}' "
                                f"WHERE id = '{row['source']}';\n")
                    
                elif 'doc_type' == row['context']:
                    line += (f"UPDATE {row['context']} SET id = '{texts[0]}', comment = '{texts[1]}' "
                                f"WHERE id = '{row['source']}';\n")
                    
                elif 'su_feature' in table:
                    line += (f"UPDATE {row['context']} SET id = '{texts[0]}', descript = '{texts[1]}' "
                                f"WHERE id = '{texts[0]}' AND feature_class = '{row['feature_class']}' AND feature_type = '{row['feature_type']}';\n")

                file.write(line)

        file.close()
        del file

    def _write_dbfeature_updates(self, rows, path): ## Parlar amb edgar
        """
            Generate a string and write into file
            :param rows: List of values ([List][List])z
            :param path: Full destination path (String)
            :return: (Boolean)
        """

        file = open(path, "a")
        for row in rows:
            # Get values
            formname = row['formname_en_us'] if row['formname_en_us'] is not None else ""
            formname_lang = row[f'formname_{self.lower_lang}'] if row[f'formname_{self.lower_lang}'] is not None else row[f'auto_formname_{self.lower_lang}']
            formname_lang = formname_lang if formname_lang is not None else row['formname_en_us']

            line = f"""UPDATE config_form_fields SET formname = '{formname_lang}' """ \
                   f"""WHERE formname LIKE '{formname}';\n"""

            file.write(line)
        file.close()
        del file


    def _write_dbjson_values_i18n(self, rows, path):
        updates = {}

        for row in rows:
            key = (row["source"], row["context"], row["text"])
            if key not in updates:
                updates[key] = []
            updates[key].append(row)

        with open(path, "a") as file:
            for (source, context, original_text), related_rows in updates.items():
                column = ""
                if context == "config_report":
                    column = "filterparam"
                elif context == "config_toolbox":
                    column = "inputparams"
                else:
                    continue

                # Safely parse the string as dict
                try:
                    json_data = ast.literal_eval(original_text)
                except (ValueError, SyntaxError):
                    continue  # Skip invalid JSON-like data

                for row in related_rows:
                    key_hint = row["hint"].split('_')[0]
                    default_text = row.get("lb_en_us", "")
                    translated = row.get(f"lb_{self.lower_lang}") or \
                                row.get(f"auto_lb_{self.lower_lang}") or \
                                default_text

                    if key_hint in json_data and json_data[key_hint] == default_text:
                        json_data[key_hint] = translated

                new_text = json.dumps(json_data)
                new_text = str(new_text).replace("'", "''")  # Convert to proper JSON format
                update_line = f"UPDATE {context} SET {column} = '{new_text}' WHERE id = {source};\n"
                file.write(update_line)
            line = "UPDATE config_param_system SET value = TRUE WHERE parameter = 'admin_config_control_trigger';"
            file.write(line)


    def _write_table_values(self, rows, columns, table, path):
        """
        Generate a string and write into file
            :param rows: List of values ([List][List])
            :param path: Full destination path (String)
            :return: (Boolean)
        """

        file = open(path, "a")
        j=0
        for i, row in enumerate(rows): #(For row in rows)
            if row['project_type'] == self.project_type or row['project_type'] == 'utils': # Avoid the unwnated project_types
                forenames = []
                for column in columns:
                    if column[-5:] == "en_us":
                        forenames.append(column.split("_")[0])

                texts = []
                for forename in forenames:
                    text = row[f'{forename}_{self.lower_lang}']
                    if text is None:
                        if self.lower_lang != 'en_us':
                            text = row[f'auto_{forename}_{self.lower_lang}']
                        if text is None :
                            text = row[f'{forename}_en_us']
                            if text is None:
                                if forename == 'tt' and table in ["dbconfig_form_fields", "dbconfig_param_system", "dbparam_user", "dbconfig_form_fields_feat"]:
                                    text = row[f'lb_en_us']
                                if text is None:
                                    text = ""
                    text = text.replace("'", "''")
                    texts.append(text)
                
                # Check invalid characters
                for i, text in enumerate(texts):
                    if text is not None and "\n" in text:
                        texts[i] = self._replace_invalid_characters(text)

                #Define the query depending on the table
                line = (f'SELECT gw_fct_admin_schema_i18n($$ {{"data":'
                        f'{{"data":'
                        f'{{"table":"{row['context']}", ')

                if table == 'dbconfig_form_fields':
                   line += (f'"formname":"{row['formname']}", '
                            f'"label":{{"column":"label", "value":"{texts[0]}"}}, '
                            f'"tooltip":{{"column":"tooltip", "value":"{texts[1]}"}}')
                   line += (f', "clause":"WHERE columnname = \'{row['source']}\' '
                            f'AND formname = \'{row['formname']}\' AND formtype = \'{row['formtype']}\'"')
                
                elif table == 'dbconfig_form_fields_feat':
                    feature_types = ['ARC', 'CONNEC', 'NODE', 'GULLY', 'LINK']
                    for feature_type in feature_types:
                        if row['feature_type'] == feature_type:
                            line += (f'"formname":"{row['formname']}", '
                                    f'"label":{{"column":"label", "value":"{texts[0]}"}}, '
                                    f'"tooltip":{{"column":"tooltip", "value":"{texts[1]}"}}')
                            line += (f', "clause":"WHERE columnname = \'{row['source']}\' '
                                    f'AND formname LIKE \'%_{row['feature_type'].lower()}%\' AND formtype = \'{row['formtype']}\'"')
                            

                            
                elif table == 'dbparam_user':
                    line += (f'"formname":"{row['formname']}", '
                            f'"label":{{"column":"label", "value":"{texts[0]}"}}, '
                            f'"tooltip":{{"column":"descript", "value":"{texts[1]}"}}')
                    line += f', "clause":"WHERE id = \'{row['source']}\'"'

                elif table == 'dbconfig_param_system':
                    line += (f'"formname":null, '
                            f'"label":{{"column":"label", "value":"{texts[0]}"}}, '
                            f'"tooltip":{{"column":"descript", "value":"{texts[1]}"}}')
                    line += f', "clause":"WHERE parameter = \'{row['source']}\'"'

                elif table == 'dbconfig_typevalue':
                    line += (f'"formname":"{row['formname']}", '
                            f'"label":{{"column":"idval", "value":"{texts[0]}"}}, ')
                    line += f', "clause":"WHERE typevalue = \'{row['formname']}\' AND id  = \'{row['source']}\'"'
                    
                elif table == 'dbmessage':
                    line += (f'"formname":null, '
                            f'"label":{{"column":"error_message", "value":"{texts[0]}"}}, '
                            f'"tooltip":{{"column":"hint_message", "value":"{texts[1]}"}}')
                    line += f', "clause":"WHERE id = \'{row['source']}\' "'

                elif table == 'dbfprocess':
                    line += (f'"label":{{"column":"except_msg", "value":"{texts[0]}"}}, '
                            f'"tooltip":{{"column":"info_msg", "value":"{texts[1]}"}}')
                    line += f', "clause":"WHERE fid = \'{row['source']}\' "'

                elif table == 'dbconfig_csv':
                    line += (f'"formname":null, '
                            f'"label":{{"column":"alias", "value":"{texts[0]}"}}, '
                            f'"tooltip":{{"column":"descript", "value":"{texts[1]}"}}')
                    line += f', "clause":"WHERE fid = \'{row['source']}\' "'

                elif table == 'dbconfig_form_tabs':
                    line += (f'"formname":"{row['formname']}", '
                            f'"label":{{"column":"label", "value":"{texts[0]}"}}, '
                            f'"tooltip":{{"column":"tooltip", "value":"{texts[1]}"}}')
                    line += f', "clause":"WHERE formname = \'{row['formname']}\' AND tabname = \'{row['source']}\'"'

                elif table == 'dbconfig_report':
                    line += (f'"formname":null, '
                            f'"label":{{"column":"alias", "value":"{texts[0]}"}}')
                    line += f', "clause":"WHERE id = \'{row['source']}\' "'

                elif table == 'dbconfig_toolbox':
                    line += (f'"formname":null, '
                            f'"label":{{"column":"alias", "value":"{texts[0]}"}}')
                    line += f', "clause":"WHERE id = \'{row['source']}\' "'

                elif table == 'dbfunction':
                    line += (f'"formname":null, '
                            f'"label":{{"column":"descript", "value":"{texts[0]}"}}')
                    line += f', "clause":"WHERE id = \'{row['source']}\' "'

                elif table == 'dbtypevalue':
                    line += (f'"formname":null, '
                            f'"label":{{"column":"idval", "value":"{texts[0]}"}}')
                    line += f', "clause":"WHERE id = \'{row['source']}\' AND typevalue = \'{row['typevalue']}\' "'

                elif table == 'dbconfig_form_tableview':
                    line += (f'"formname":null, '
                            f'"label":{{"column":"alias", "value":"{texts[0]}"}}')
                    line += f', "clause":"WHERE objectname = \'{row["source"]}\' AND columnname = \'{row['columnname']}\' "'
                    
                line += f'}}}}$$);\n'
                file.write(line)
        file.close()
        del file

    
    def _write_dbjson_values(self, rows, path):
        updates = {}

        # Group rows by (source, context, text)
        for row in rows:
            key = (row["source"], row["context"], row["text"])
            if key not in updates:
                updates[key] = []
            updates[key].append(row)

        with open(path, "a") as file:
            for (source, context, original_text), related_rows in updates.items():
                column = ""
                if context == "config_report":
                    column = "filterparam"
                elif context == "config_toolbox":
                    column = "inputparams"
                else:
                    continue  # Skip unknown contexts

                updated_text = original_text
                for row in related_rows:
                    key_hint = row["hint"].split('_')[0]
                    default_text = row.get("lb_en_us", "")
                    base_key = "lb"

                    translated = row.get(f"{base_key}_{self.lower_lang}")
                    if not translated and self.lower_lang != "en_us":
                        translated = row.get(f"auto_{base_key}_{self.lower_lang}")
                    if not translated:
                        translated = row.get(f"{base_key}_en_us") or ""

                    updated_text = updated_text.replace(
                        f"'{key_hint}':'{default_text}'",
                        f"'{key_hint}':'{translated}'"
                    )

                sql = (
                    f"SELECT gw_fct_admin_schema_i18n($$ {{\"data\":{{\"data\":"
                    f"{{\"table\":\"{context}\", \"formname\":null, "
                    f"\"label\":{{\"column\":\"{column}\", \"value\":\"{updated_text}\"}}, "
                    f"\"clause\":\"WHERE id = '{source}'\"}}}}}}$$);\n"
                )
                file.write(sql)


    def _save_user_values(self):
        """ Save selected user values """

        host = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_host, return_string_null=False)
        port = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_port, return_string_null=False)
        db = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_db, return_string_null=False)
        user = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_user, return_string_null=False)
        language = tools_qt.get_combo_value(self.dlg_qm, self.dlg_qm.cmb_language, 0)
        py_msg = tools_qt.is_checked(self.dlg_qm, self.dlg_qm.chk_py_msg)
        db_msg = tools_qt.is_checked(self.dlg_qm, self.dlg_qm.chk_db_msg)
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_host', f"{host}", "user", "init", prefix=False)
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_port', f"{port}", "user", "init", prefix=False)
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_db', f"{db}", "user", "init", prefix=False)
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_user', f"{user}", "user", "init", prefix=False)
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_language', f"{language}", "user", "init", prefix=False)
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_py_msg', f"{py_msg}", "user", "init", prefix=False)
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_db_msg', f"{db_msg}", "user", "init", prefix=False)


    def _load_user_values(self):
        """
        Load last selected user values
            :return: Dictionary with values
        """

        host = tools_gw.get_config_parser('i18n_generator', 'qm_lang_host', "user", "init", False)
        port = tools_gw.get_config_parser('i18n_generator', 'qm_lang_port', "user", "init", False)
        db = tools_gw.get_config_parser('i18n_generator', 'qm_lang_db', "user", "init", False)
        user = tools_gw.get_config_parser('i18n_generator', 'qm_lang_user', "user", "init", False)
        py_msg = tools_gw.get_config_parser('i18n_generator', 'qm_lang_py_msg', "user", "init", False)
        db_msg = tools_gw.get_config_parser('i18n_generator', 'qm_lang_db_msg', "user", "init", False)
        tools_qt.set_widget_text(self.dlg_qm, 'txt_host', host)
        tools_qt.set_widget_text(self.dlg_qm, 'txt_port', port)
        tools_qt.set_widget_text(self.dlg_qm, 'txt_db', db)
        tools_qt.set_widget_text(self.dlg_qm, 'txt_user', user)
        tools_qt.set_checked(self.dlg_qm, self.dlg_qm.chk_py_msg, py_msg)
        tools_qt.set_checked(self.dlg_qm, self.dlg_qm.chk_db_msg, db_msg)


    def _init_db(self, host, port, db, user, password):
        """ Initializes database connection """

        try:
            self.conn_i18n = psycopg2.connect(database=db, user=user, port=port, password=password, host=host)
            self.cursor_i18n = self.conn_i18n.cursor(cursor_factory=psycopg2.extras.DictCursor)
            status = True
        except psycopg2.DatabaseError as e:
            self.last_error = e
            status = False

        return status


    def _close_db(self):
        """ Close database connection """

        try:
            status = True
            if self.cursor_i18n:
                self.cursor_i18n.close()
            if self.conn_i18n:
                self.conn_i18n.close()
            del self.cursor_i18n
            del self.conn_i18n
        except Exception as e:
            self.last_error = e
            status = False

        return status


    def _commit(self):
        """ Commit current database transaction """
        self.conn_i18n.commit()


    def _rollback(self):
        """ Rollback current database transaction """
        self.conn_i18n.rollback()


    def _get_rows(self, sql, commit=True):
        """ Get multiple rows from selected query """

        self.last_error = None
        rows = None
        try:
            self.cursor_i18n.execute(sql)
            rows = self.cursor_i18n.fetchall()
            if commit:
                self._commit()
        except Exception as e:
            self.last_error = e
            if commit:
                self._rollback()
        finally:
            return rows


    def _replace_invalid_characters(self, param):
        """
        This function replaces the characters that break JSON messages
         (", new line, etc.)
            :param param: The text to fix (String)
        """
        param = param.replace("\"", "''")
        param = param.replace("\r", "")
        param = param.replace("\n", " ")

        return param
    
    
    def _replace_invalid_quotation_marks(self, param):
        """
        This function replaces the characters that break JSON messages
         (')
            :param param: The text to fix (String)
        """
        param = re.sub(r"(?<!')'(?!')", "''", param)

        return param


    def _set_editability_dbmessage(self):

        if tools_qt.get_combo_value(self.dlg_qm, self.dlg_qm.cmb_language, 0) == 'en_US':
            tools_qt.set_checked(self.dlg_qm, self.dlg_qm.chk_db_msg, False)
            self.dlg_qm.chk_db_msg.setEnabled(False)
        else:
            self.dlg_qm.chk_db_msg.setEnabled(True)

    # endregion
