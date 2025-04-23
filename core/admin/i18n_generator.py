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
from collections import defaultdict
import logging


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

    # region MAIN

    def _check_translate_options(self):
        """ Check the translation options selected by the user """

        self.dlg_qm.lbl_info.clear()
        msg = ''
        self.language = tools_qt.get_combo_value(self.dlg_qm, self.dlg_qm.cmb_language, 0)
        self.lower_lang = self.language.lower()
        self.schema_i18n = "i18n"

        py_msg = tools_qt.is_checked(self.dlg_qm, self.dlg_qm.chk_py_msg)
        if py_msg:
            status_py_msg = self._create_py_files()
            if status_py_msg is True:
                msg += "Python translation successful\n"
            elif status_py_msg is False:
                msg += "Python translation failed\n"
            elif status_py_msg is None:
                msg += "Python translation canceled\n"

        self._create_path_dic()
        for type_db_file in self.path_dic:
            
            if tools_qt.is_checked(self.dlg_qm, self.path_dic[type_db_file]['checkbox']):
                status_all_db_msg, dbtable = self._create_all_db_files(self.path_dic[type_db_file]["path"], type_db_file)
                if status_all_db_msg is True:
                    msg += f"{type_db_file} translation successful\n"
                elif status_all_db_msg is False:
                    msg += f"{type_db_file} translation failed in table: {dbtable}\n"
                elif status_all_db_msg is None:
                    msg += f"Database translation canceled\n"        

        if msg != '':
            tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', msg)

    # endregion
    # region PY files

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
    
    # endregion
    # region Database files
    
    def _create_all_db_files(self, cfg_path, file_type):
        """ Read the values of the database and update the i18n files """

        print(cfg_path)
            
        file_name = f"{self.path_dic[file_type]["name"]}"

        # Check if file exist
        if os.path.exists(cfg_path + file_name):
            msg = "Are you sure you want to overwrite this file?"
            answer = tools_qt.show_question(msg, "Overwrite", parameter=f"\n\n{cfg_path}{file_name}")
            if not answer:
                return None, ""
        else:
            os.makedirs(cfg_path, exist_ok=True)

        # Get All table values
        self._write_header(cfg_path + file_name, file_type)
        dbtables = self.path_dic[file_type]["tables"]
        for dbtable in dbtables:
            dbtable_rows, dbtable_columns = self._get_table_values(dbtable)
            if not dbtable_rows:
                return False, dbtable
            else:
                if "json" in dbtable:
                    self._write_dbjson_values(dbtable_rows, cfg_path + file_name)
                else:
                    self._write_table_values(dbtable_rows, dbtable_columns, dbtable, cfg_path + file_name, file_type)            

        return True, ""
    
    # endregion
    # region Gen. any table files

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
            colums = ["project_type", "context", "source", "ex_en_us", "in_en_us", "na_en_us"]
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

        if table == 'dbconfig_form_fields_json':
            colums = ["source", "formname", "formtype", "project_type", "context", "source_code", "hint", "text", "lb_en_us"]
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

        elif table == 'dbconfig_engine':
            colums = ["project_type", "context", "parameter", "method", "lb_en_us", "ds_en_us", "pl_en_us"]
            lang_colums = [f"lb_{self.lower_lang}", f"auto_lb_{self.lower_lang}", f"va_auto_lb_{self.lower_lang}", f"ds_{self.lower_lang}", f"auto_ds_{self.lower_lang}", f"va_auto_ds_{self.lower_lang}", f"pl_{self.lower_lang}", f"auto_pl_{self.lower_lang}", f"va_auto_pl_{self.lower_lang}"]


        # Make the query
        sql=""
        if self.lower_lang == 'en_us':
            sql = (f"SELECT {", ".join(colums)} "
               f"FROM {self.schema_i18n}.{table} "
               f"ORDER BY context;")
        else:
            sql = (f"SELECT {", ".join(colums)}, {", ".join(lang_colums)} "
               f"FROM {self.schema_i18n}.{table} "
               f"ORDER BY context;")
        rows = self._get_rows(sql, self.cursor_i18n)
        print(sql)

        # Return the corresponding information
        if not rows:
            return False
        return rows, colums


    def _write_table_values(self, rows, columns, table, path, file_type):
        """
        Generate a string and write into file
            :param rows: List of values ([List][List])
            :param path: Full destination path (String)
            :return: (Boolean)
        """

        file = open(path, "a")
        j=0
        for i, row in enumerate(rows): #(For row in rows)
            if row['project_type'] in self.path_dic[file_type]["project_type"]: # Avoid the unwnated project_types
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
                                f"WHERE id = '{row['lb_en_us']}' AND feature_class = '{row['feature_class']}' AND feature_type = '{row['feature_type']}';\n")
                
                elif 'dbconfig_engine' in table:
                    line += (f"UPDATE {row['context']} SET label = '{texts[0]}', descript = '{texts[1]}', placeholder = '{texts[2]}' "
                                f"WHERE parameter = '{row['parameter']}' AND method = '{row['method']}';\n")

                file.write(line)

        file.close()
        del file

    # endregion
    # region Generate from Json
    def _write_dbjson_values(self, rows, path):
        closing = False
        with open(path, "a") as file:
            updates = {}
            for row in rows:
                if row["context"] == "config_form_fields":
                    closing = True
                    key = (row["source"], row["context"], row["text"], row["formname"], row["formtype"])
                else:
                    key = (row["source"], row["context"], row["text"])
                updates.setdefault(key, []).append(row)

            for (source, context, original_text, *extra), related_rows in updates.items():
                if context == "config_report":
                    column = "filterparam"
                elif context == "config_toolbox":
                    column = "inputparams"
                elif context == "config_form_fields":
                    column = "widgetcontrols"
                else:
                    continue  # unknown context

                # parse JSON-like data
                if context != "config_form_fields":
                    try:
                        json_data = ast.literal_eval(original_text)
                    except (ValueError, SyntaxError):
                        continue
                else:
                    modified = original_text.replace("'", "\"")
                    modified = modified.replace("False", "false").replace("True", "true").replace("None", "null")
                    try:
                        json_data = json.loads(modified)
                    except json.JSONDecodeError as e:
                        print(f"Error decoding JSON: {e}")
                        continue

                for row in related_rows:
                    key_hint = row["hint"].split('_')[0]
                    default_text = row.get("lb_en_us", "")
                    translated = (
                        row.get(f"lb_{self.lower_lang}")
                        or row.get(f"auto_lb_{self.lower_lang}")
                        or default_text
                    )

                    if ", " in default_text:
                        default_list = default_text.split(", ")
                        translated_list = translated.split(", ")
                        for item in json_data:
                            if isinstance(item, dict) and key_hint in item and "comboNames" in item:
                                if set(default_list).intersection(item["comboNames"]):
                                    item["comboNames"] = [
                                        t if d in default_list else d
                                        for d, t in zip(default_list, translated_list)
                                    ]
                    else:
                        if isinstance(json_data, dict):
                            for key, value in json_data.items():
                                if key == key_hint and value == default_text:
                                    json_data[key] = translated
                        elif isinstance(json_data, list):
                            for item in json_data:
                                if isinstance(item, dict) and key_hint in item and item[key_hint] == default_text:
                                    item[key_hint] = translated
                        else:
                            print("Unexpected json_data structure!")

                new_text = json.dumps(json_data).replace("'", "''")

                if context == "config_form_fields":
                    line = (
                        f"UPDATE {context} SET {column} = '{new_text}' "
                        f"WHERE formname = '{related_rows[0]['formname']}' "
                        f"AND formtype = '{related_rows[0]['formtype']}' "
                        f"AND columnname = '{source}';\n"
                    )
                else:
                    line = f"UPDATE {context} SET {column} = '{new_text}' WHERE id = {source};\n"

                file.write(line)

            if closing:
                file.write(f"UPDATE config_param_system SET value = FALSE WHERE parameter = 'admin_config_control_trigger';")


    # endregion
    # region Extra functions

    def _write_header(self, path, file_type):
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
                  f'*/\n\n\n'
                  f'SET search_path = SCHEMA_NAME, public, pg_catalog;\n')
        if file_type in ["ws", "ud"]:
            header += f"UPDATE config_param_system SET value = FALSE WHERE parameter = 'admin_config_control_trigger';\n\n"
        
        file.write(header)
        file.close()
        del file

    def _save_user_values(self):
        """ Save selected user values """

        host = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_host, return_string_null=False)
        port = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_port, return_string_null=False)
        db = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_db, return_string_null=False)
        user = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_user, return_string_null=False)
        py_msg = tools_qt.is_checked(self.dlg_qm, self.dlg_qm.chk_py_msg)
        db_msg = tools_qt.is_checked(self.dlg_qm, self.dlg_qm.chk_db_files)

        tools_gw.set_config_parser('i18n_generator', 'txt_host', f"{host}", "user", "session", prefix=False)
        tools_gw.set_config_parser('i18n_generator', 'txt_port', f"{port}", "user", "session", prefix=False)
        tools_gw.set_config_parser('i18n_generator', 'txt_db', f"{db}", "user", "session", prefix=False)
        tools_gw.set_config_parser('i18n_generator', 'txt_user', f"{user}", "user", "session", prefix=False)
        tools_gw.set_config_parser('i18n_generator', 'chk_py_msg', f"{py_msg}", "user", "session", prefix=False)
        tools_gw.set_config_parser('i18n_generator', 'chk_db_files', f"{db_msg}", "user", "session", prefix=False)


    def _load_user_values(self):
        """
        Load last selected user values
            :return: Dictionary with values
        """

        host = tools_gw.get_config_parser('i18n_generator', 'txt_host', "user", "session", False)
        port = tools_gw.get_config_parser('i18n_generator', 'txt_port', "user", "session", False)
        db = tools_gw.get_config_parser('i18n_generator', 'txt_db', "user", "session", False)
        user = tools_gw.get_config_parser('i18n_generator', 'txt_user', "user", "session", False)
        py_msg = tools_gw.get_config_parser('i18n_generator', 'chk_py_msg', "user", "session", False)
        db_msg = tools_gw.get_config_parser('i18n_generator', 'chk_db_files', "user", "session", False)

        tools_qt.set_widget_text(self.dlg_qm, 'txt_host', host)
        tools_qt.set_widget_text(self.dlg_qm, 'txt_port', port)
        tools_qt.set_widget_text(self.dlg_qm, 'txt_db', db)
        tools_qt.set_widget_text(self.dlg_qm, 'txt_user', user)
        tools_qt.set_checked(self.dlg_qm, self.dlg_qm.chk_py_msg, py_msg)
        tools_qt.set_checked(self.dlg_qm, self.dlg_qm.chk_db_files, db_msg)


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
            tools_qt.set_checked(self.dlg_qm, self.dlg_qm.chk_db_files, False)
            self.dlg_qm.chk_db_files.setEnabled(False)
        else:
            self.dlg_qm.chk_db_files.setEnabled(True)


    def _create_path_dic(self):
        
        major_version = tools_qgis.get_major_version(plugin_dir=self.plugin_dir).replace(".", "")
        ver_build = tools_qgis.get_build_version(plugin_dir=self.plugin_dir)

        self.path_dic = {
            "db": {
                "path": f"{self.plugin_dir}{os.sep}dbmodel{os.sep}updates{os.sep}{major_version}{os.sep}{ver_build}"
                        f"{os.sep}i18n{os.sep}{self.language}{os.sep}",
                "name": "dml.sql",
                "project_type": [self.project_type, "utils"],
                "checkbox": self.dlg_qm.chk_db_files,
                "tables": [ "dbparam_user", "dbconfig_param_system", "dbconfig_form_fields", "dbconfig_typevalue", 
                    "dbfprocess", "dbmessage", "dbconfig_csv", "dbconfig_form_tabs", "dbconfig_report", 
                    "dbconfig_toolbox", "dbfunction", "dbtypevalue", "dbconfig_form_tableview",
                    "dbtable", "dbconfig_form_fields_feat", "su_basic_tables", "su_feature", "dbjson", 
                    "dbconfig_form_fields_json"
                 ]
            },
            "i18n": {
                "path": f"{self.plugin_dir}{os.sep}dbmodel{os.sep}i18n{os.sep}{self.language}{os.sep}",
                "name": "dml.sql",
                "project_type": [self.project_type, "utils"],
                "checkbox": self.dlg_qm.chk_i18n_files,
                "tables": [ "dbparam_user", "dbconfig_param_system", "dbconfig_form_fields", "dbconfig_typevalue", 
                    "dbfprocess", "dbmessage", "dbconfig_csv", "dbconfig_form_tabs", "dbconfig_report", 
                    "dbconfig_toolbox", "dbfunction", "dbtypevalue", "dbconfig_form_tableview",
                    "dbtable", "dbconfig_form_fields_feat", "su_basic_tables", "su_feature", "dbjson", 
                    "dbconfig_form_fields_json"
                 ]
            },
            "am": {
                "path": f"{self.plugin_dir}{os.sep}dbmodel{os.sep}am{os.sep}i18n{os.sep}",
                "name": f"{self.language}.sql",
                "project_type": ["am"],
                "checkbox": self.dlg_qm.chk_am_files,
                "tables": ["dbconfig_engine", "dbconfig_form_tableview", "su_basic_tables"]
            },
            "cm": {
                "path": f"{self.plugin_dir}{os.sep}dbmodel{os.sep}updates{os.sep}{major_version}{os.sep}{ver_build}"
                        f"{os.sep}i18n{os.sep}{self.language}{os.sep}",
                "name": f"{self.language}.sql",
                "project_type": ["cm"],
                "checkbox": self.dlg_qm.chk_cm_files,
                "tables": [] #["dbtable", "dbconfig_form_fields", "dbconfig_form_tabs", "dbconfig_param_system", "sys_typevalue", "dbconfig_form_fields_json"]
            }
        }


    # endregion
