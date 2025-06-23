"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import re
import psycopg2
import psycopg2.extras
from functools import partial
import datetime
import ast
import json

from ..ui.ui_manager import GwSchemaI18NUpdateUi
from ..utils import tools_gw
from ...libs import lib_vars, tools_qt, tools_db
from PyQt5.QtWidgets import QApplication


class GwSchemaI18NUpdate:

    def __init__(self):
        self.plugin_dir = lib_vars.plugin_dir
        self.schema_name = lib_vars.schema_name
        self.project_type_selected = None

    def init_dialog(self):
        """ Constructor """

        self.dlg_qm = GwSchemaI18NUpdateUi(self)  # Initialize the UI
        tools_gw.load_settings(self.dlg_qm)
        self._load_user_values()  # keep values
        self.dev_commit = tools_gw.get_config_parser('system', 'force_commit', "user", "init", prefix=True)
        self._set_signals()  # Set all the signals to wait for response

        self.dlg_qm.btn_translate.setEnabled(False)

        # Get the project_types (ws, ud)
        self.tables_dic()
        self.dlg_qm.cmb_projecttype.clear()
        for shcema_type in self.dbtables_dic:
            self.dlg_qm.cmb_projecttype.addItem(shcema_type)

        tools_gw.open_dialog(self.dlg_qm, dlg_name='admin_update_translation')

    # region private functions

    def _set_signals(self):
        # Mysteriously without the partial the function check_connection is not called
        self.dlg_qm.btn_connection.clicked.connect(partial(self._check_connection, True))
        self.dlg_qm.btn_translate.clicked.connect(self.schema_i18n_update)
        self.dlg_qm.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_qm))
        self.dlg_qm.rejected.connect(self._save_user_values)
        self.dlg_qm.rejected.connect(self._close_db)
        self.dlg_qm.rejected.connect(self._close_db_dest)

        # Populate schema names
        self.dlg_qm.cmb_projecttype.currentIndexChanged.connect(partial(self._populate_data_schema_name, self.dlg_qm.cmb_projecttype))

    def _check_connection(self, set_languages):
        """ Check connection to database """

        self.dlg_qm.lbl_info.clear()
        self._close_db()
        # Connection with origin db
        host_i18n = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_host)
        port_i18n = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_port)
        db_i18n = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_db)
        user_i18n = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_user)
        password_i18n = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_pass)
        status_i18n, e = self._init_db_i18n(host_i18n, port_i18n, db_i18n, user_i18n, password_i18n)
        # Send messages
        if 'password authentication failed' in str(self.last_error):
            self.dlg_qm.btn_translate.setEnabled(False)
            msg = "Incorrect user or password"
            tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', msg)
            QApplication.processEvents()
            return
        elif host_i18n != '188.245.226.42' and port_i18n != '5432' and db_i18n != 'giswater' or not status_i18n or e:
            self.dlg_qm.btn_translate.setEnabled(False)
            tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', self.last_error)
            QApplication.processEvents()
            return

        if set_languages:
            self._populate_cmb_language()

    def _populate_cmb_language(self):
        """ Populate combo with languages values """
        self.dlg_qm.cmb_language.clear()
        self.dlg_qm.btn_translate.setEnabled(True)
        host_org = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_host)
        msg = "Succesfully connected to {0}"
        msg_params = (host_org,)
        tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', msg, msg_params)
        sql = "SELECT id, idval FROM i18n.cat_language"
        rows = self._get_rows(sql, self.cursor_i18n)
        tools_qt.fill_combo_values(self.dlg_qm.cmb_language, rows)
        language = tools_gw.get_config_parser('i18n_generator', 'qm_lang_language', "user", "session", False)

        tools_qt.set_combo_value(self.dlg_qm.cmb_language, language, 0, add_new=False)

    def _populate_data_schema_name(self, widget):
         # Get filter
        filter_ = tools_qt.get_text(self.dlg_qm, widget)
        if filter_ in (None, 'null') and self.project_type_selected:
            filter_ = self.project_type_selected
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
                if result is not None and result[0] in [filter_.upper(), filter_.lower()]:
                    elem = [row[0], row[0]]
                    result_list.append(elem)
        if not result_list:
            if filter_ == "am":
                result_list.append(["am", "am"])
            else:
                self.dlg_qm.cmb_schema.clear()
                return

        tools_qt.fill_combo_values(self.dlg_qm.cmb_schema, result_list)

    def _change_project_type(self, widget):
        """ Take current project type changed """
        self.project_type_selected = tools_qt.get_text(self.dlg_qm, widget)

    # endregion

    # region Main program

    def schema_i18n_update(self):
        """ Main program to run the the shcmea_i18n_update """

        # Connect in case of repeated actions
        self._check_connection(False)
        self.cursor_dest = tools_db.dao.get_cursor()
        self.conn_dest = tools_db.dao
        # Initalize the language and the message (for errors,etc)
        self.language = tools_qt.get_combo_value(self.dlg_qm, self.dlg_qm.cmb_language, 0)
        self.lower_lang = self.language.lower()

        # Run the updater of db_files and look at the result
        status_cfg_msg, errors = self._copy_db_files()
        msg = f'''{tools_qt.tr('In schema')} {self.project_type}:'''
        if status_cfg_msg is True:
            msg += f'''{tools_qt.tr('Database translation successful to')} {self.lower_lang}.\n'''
            self._commit_dest()
        elif status_cfg_msg is False:
            msg += f'''{tools_qt.tr('Database translation failed.')}\n'''
        elif status_cfg_msg is None:
            msg += f'''{tools_qt.tr('Database translation canceled.')}\n'''

        # Look for errors
        if errors:
            msg += f'''{tools_qt.tr('There have been errors translating:')} {', '.join(errors)}'''

        self._change_lang()

        # Close connections
        self._close_db()
        self._close_db_dest()

        self.dlg_qm.lbl_info.clear()
        tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', msg)
        tools_qt.show_info_box(msg)

    def _copy_db_files(self):
        """ Read the values of the database and update the ones in the project """

        # On the database, the dialog_name column must match the name of the ui file (no extension).
        # Also, open_dialog function must be called, passed as parameter dlg_name = 'ui_file_name_without_extension'
        self.project_type = tools_qt.get_text(self.dlg_qm, self.dlg_qm.cmb_projecttype, 0)
        self.schema = tools_qt.get_text(self.dlg_qm, self.dlg_qm.cmb_schema, 0)
        messages = []

        if self.project_type != "am":
            sql_1 = f"UPDATE {self.schema}.config_param_system SET value = FALSE WHERE parameter = 'admin_config_control_trigger'"
            self.cursor_dest.execute(sql_1)
            self._commit_dest

        dbtables = self.dbtables_dic[self.project_type]['dbtables']
        schema_i18n = "i18n"
        for dbtable in dbtables:
            dbtable = f"{schema_i18n}.{dbtable}"
            dbtable_rows, dbtable_columns = self._get_table_values(dbtable)
            if not dbtable_rows:
                messages.append(dbtable)  # Corregido
            else:
                if "json" in dbtable:
                    self._write_dbjson_values(dbtable_rows)
                else:
                    self._write_table_values(dbtable_rows, dbtable_columns, dbtable)

        if self.project_type != "am":
            sql_2 = f"UPDATE {self.schema}.config_param_system SET value = TRUE WHERE parameter = 'admin_config_control_trigger'"
            self.cursor_dest.execute(sql_2)
            self._commit_dest()

        # Mostrar mensaje de error si hay errores
        if messages:  # Corregido: Verifica si hay elementos en la lista
            msg = "Error translating: {0}"
            msg_params = (', '.join(messages),)
            tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', msg, msg_params)
            return False, messages
        else:
            return True, None

        # Get db_feature values

    # endregion

    # region Alter any table
    def _get_table_values(self, table):
        """ Get table values """

        # Update the part the of the program in process
        self.dlg_qm.lbl_info.clear()
        msg = "Updating {0}..."
        msg_params = (table,)
        tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', msg, msg_params)
        QApplication.processEvents()
        columns = []
        lang_columns = []

        if 'dbconfig_form_fields' in table:
            columns = ["source", "formname", "formtype", "project_type", "context", "source_code", "lb_en_us", "tt_en_us"]
            lang_columns = [f"lb_{self.lower_lang}", f"auto_lb_{self.lower_lang}", f"va_auto_lb_{self.lower_lang}",
                            f"tt_{self.lower_lang}", f"auto_tt_{self.lower_lang}", f"va_auto_tt_{self.lower_lang}"]
            if 'feat' in table:
                columns = [col.replace("formname", "feature_type") for col in columns]
            elif 'json' in table:
                columns = columns[:-1]
                columns.extend(["hint", "text"])
                lang_columns = lang_columns[:3]

        elif 'dbparam_user' in table:
            columns = ["source", "formname", "project_type", "context", "source_code", "lb_en_us", "tt_en_us"]
            lang_columns = [f"lb_{self.lower_lang}", f"auto_lb_{self.lower_lang}", f"va_auto_lb_{self.lower_lang}",
                            f"tt_{self.lower_lang}", f"auto_tt_{self.lower_lang}", f"va_auto_tt_{self.lower_lang}"]

        elif 'dbconfig_param_system' in table:
            columns = ["source", "project_type", "context", "source_code", "lb_en_us", "tt_en_us"]
            lang_columns = [f"lb_{self.lower_lang}", f"auto_lb_{self.lower_lang}", f"va_auto_lb_{self.lower_lang}",
                            f"tt_{self.lower_lang}", f"auto_tt_{self.lower_lang}", f"va_auto_tt_{self.lower_lang}"]

        elif 'dbconfig_typevalue' in table:
            columns = ["source", "formname", "formtype", "project_type", "context", "source_code", "tt_en_us"]
            lang_columns = [f"tt_{self.lower_lang}", f"auto_tt_{self.lower_lang}", f"va_auto_tt_{self.lower_lang}"]

        elif 'dbmessage' in table:
            columns = ["source", "project_type", "context", "log_level", "ms_en_us", "ht_en_us"]
            lang_columns = [f"ms_{self.lower_lang}", f"auto_ms_{self.lower_lang}", f"va_auto_ms_{self.lower_lang},"
                            f"ht_{self.lower_lang}", f"auto_ht_{self.lower_lang}", f"va_auto_ht_{self.lower_lang}"]

        elif 'dbfprocess' in table:
            columns = ["source", "project_type", "context", "ex_en_us", "in_en_us", "na_en_us"]
            lang_columns = [f"ex_{self.lower_lang}", f"auto_ex_{self.lower_lang}", f"va_auto_ex_{self.lower_lang},"
                            f"in_{self.lower_lang}", f"auto_in_{self.lower_lang}", f"va_auto_in_{self.lower_lang}",
                            f"na_{self.lower_lang}", f"auto_na_{self.lower_lang}", f"va_auto_na_{self.lower_lang}"]

        elif 'dbconfig_csv' in table:
            columns = ["source", "project_type", "context", "al_en_us", "ds_en_us"]
            lang_columns = [f"al_{self.lower_lang}", f"auto_al_{self.lower_lang}", f"va_auto_al_{self.lower_lang}",
                            f"ds_{self.lower_lang}", f"auto_ds_{self.lower_lang}", f"va_auto_ds_{self.lower_lang}"]

        elif 'dbconfig_form_tabs' in table:
            columns = ["formname", "source", "project_type", "context", "lb_en_us", "tt_en_us"]
            lang_columns = [f"lb_{self.lower_lang}", f"auto_lb_{self.lower_lang}", f"va_auto_lb_{self.lower_lang}",
                            f"tt_{self.lower_lang}", f"auto_tt_{self.lower_lang}", f"va_auto_tt_{self.lower_lang}"]

        elif 'dbconfig_report' in table:
            columns = ["source", "project_type", "context", "al_en_us", "ds_en_us"]
            lang_columns = [f"al_{self.lower_lang}", f"auto_al_{self.lower_lang}", f"va_auto_al_{self.lower_lang}",
                            f"ds_{self.lower_lang}", f"auto_ds_{self.lower_lang}", f"va_auto_ds_{self.lower_lang}"]

        elif 'dbconfig_toolbox' in table:
            columns = ["source", "project_type", "context", "al_en_us", "ob_en_us"]
            lang_columns = [f"al_{self.lower_lang}", f"auto_al_{self.lower_lang}", f"va_auto_al_{self.lower_lang}",
                             f"ob_{self.lower_lang}", f"auto_ob_{self.lower_lang}", f"va_auto_ob_{self.lower_lang}"]

        elif 'dbfunction' in table:
            columns = ["source", "project_type", "context", "ds_en_us"]
            lang_columns = [f"ds_{self.lower_lang}", f"auto_ds_{self.lower_lang}", f"va_auto_ds_{self.lower_lang}"]

        elif 'dbtypevalue' in table:
            columns = ["source", "project_type", "context", "typevalue", "vl_en_us", "ds_en_us"]
            lang_columns = [f"vl_{self.lower_lang}", f"auto_vl_{self.lower_lang}", f"va_auto_vl_{self.lower_lang}",
                            f"ds_{self.lower_lang}", f"auto_ds_{self.lower_lang}", f"va_auto_ds_{self.lower_lang}"]

        elif 'dbconfig_form_tableview' in table:
            columns = ["source", "columnname", "project_type", "context", "location_type", "al_en_us"]
            lang_columns = [f"al_{self.lower_lang}", f"auto_al_{self.lower_lang}", f"va_auto_al_{self.lower_lang}"]

        elif 'dbjson' in table:
            columns = ["source", "project_type", "context", "hint", "text", "lb_en_us"]
            lang_columns = [f"lb_{self.lower_lang}", f"auto_lb_{self.lower_lang}", f"va_auto_lb_{self.lower_lang}"]

        elif 'dbtable' in table:
            columns = ["source", "project_type", "context", "al_en_us", "ds_en_us"]
            lang_columns = [f"al_{self.lower_lang}", f"auto_al_{self.lower_lang}", f"va_auto_al_{self.lower_lang}",
                            f"ds_{self.lower_lang}", f"auto_ds_{self.lower_lang}", f"va_auto_ds_{self.lower_lang}"]

        elif 'dbconfig_engine' in table:
            columns = ["project_type", "context", "parameter", "method", "lb_en_us", "ds_en_us", "pl_en_us"]
            lang_columns = [f"lb_{self.lower_lang}", f"auto_lb_{self.lower_lang}", f"va_auto_lb_{self.lower_lang}",
                            f"ds_{self.lower_lang}", f"auto_ds_{self.lower_lang}", f"va_auto_ds_{self.lower_lang}",
                            f"pl_{self.lower_lang}", f"auto_pl_{self.lower_lang}", f"va_auto_pl_{self.lower_lang}"]

        elif 'su_basic_tables' in table:
            columns = ["project_type", "context", "source", "na_en_us", "ob_en_us"]
            lang_columns = [f"na_{self.lower_lang}", f"auto_na_{self.lower_lang}", f"va_auto_na_{self.lower_lang}",
                            f"ob_{self.lower_lang}", f"auto_ob_{self.lower_lang}", f"va_auto_ob_{self.lower_lang}"]

        # Make the query
        sql = ""
        if self.lower_lang == 'en_us':
            sql = (f"SELECT {", ".join(columns)} "
               f"FROM {table} "
               f"ORDER BY context")
        else:
            sql = (f"SELECT {", ".join(columns)}, {", ".join(lang_columns)} "
               f"FROM {table} "
               f"ORDER BY context")
        rows = self._get_rows(sql, self.cursor_i18n)

        # Return the corresponding information
        if not rows:
            return False
        return rows, columns

    def _write_table_values(self, rows, columns, table):

        schema_type = [self.project_type]
        if self.project_type in ["ud", "ws"]:
            schema_type.append("utils")

        forenames = []
        for column in columns:
            if column[-5:] == "en_us":
                forenames.append(column.split("_")[0])

        for i, row in enumerate(rows):  # (For row in rows)
            if row['project_type'] in schema_type:  # Chose wanted schema types (ws, ud, cm, am...)

                texts = []
                for forename in forenames:
                    value = row.get(f'{forename}_{self.lower_lang}')

                    if not value and self.lower_lang != 'en_us':
                        value = row.get(f'auto_{forename}_{self.lower_lang}')

                    if not value:
                        value = row.get(f'{forename}_en_us')

                    if not value and forename == 'tt' and table in [
                        "dbconfig_form_fields", "dbconfig_param_system",
                        "dbparam_user", "dbconfig_form_fields_feat"]:
                        value = row.get('lb_en_us')

                    if not value:
                        texts.append('NULL')
                    else:
                        escaped_value = value.replace("'", "''")
                        texts.append(f"'{escaped_value}'")

                for j, text in enumerate(texts):
                    if "\n" in texts[j] and texts[j] is not None:
                        texts[j] = self._replace_invalid_characters(texts[j])

                sql_text = ""
                # Define the query depending on the table
                if 'dbconfig_form_fields' in table:
                    if 'feat' in table:
                        feature_types = ['ARC', 'CONNEC', 'NODE', 'GULLY', 'LINK', 'ELEMENT']
                        for feature_type in feature_types:
                            if row['feature_type'] == feature_type:
                                formname = row['feature_type'].lower()
                                sql_text = (f'UPDATE {self.schema}.{row['context']} SET label = {texts[0]}, tooltip = {texts[1]} '
                                        f'WHERE formname LIKE \'%_{formname}%\' AND formtype = \'{row['formtype']}\' AND columnname = \'{row['source']}\' ')
                                break
                    else:
                        sql_text = (f"UPDATE {self.schema}.{row['context']} SET label = {texts[0]}, tooltip = {texts[1]} "
                                f"WHERE formname = '{row['formname']}' AND formtype = '{row['formtype']}' AND columnname = '{row['source']}';\n")

                elif 'dbparam_user' in table:
                    sql_text = (f"UPDATE {self.schema}.{row['context']} SET label = {texts[0]}, descript = {texts[1]} "
                                f"WHERE id = '{row['source']}';\n")

                elif 'dbconfig_param_system' in table:
                    sql_text = (f"UPDATE {self.schema}.{row['context']} SET label = {texts[0]}, descript = {texts[1]} "
                                f"WHERE parameter = '{row['source']}';\n")

                elif 'dbconfig_typevalue' in table:
                    sql_text = (f"UPDATE {self.schema}.{row['context']} SET idval = {texts[0]} "
                                f"WHERE id = '{row['source']}' AND typevalue = '{row['formname']}';\n")

                elif 'dbmessage' in table:
                    sql_text = (f"UPDATE {self.schema}.{row['context']} SET error_message = {texts[0]}, hint_message = {texts[1]} "
                                f"WHERE id = '{row['source']}';\n")

                elif 'dbfprocess' in table:
                    sql_text = (f"UPDATE {self.schema}.{row['context']} SET except_msg = {texts[0]}, info_msg = {texts[1]}, fprocess_name = {texts[2]} "
                                f"WHERE fid = '{row['source']}';\n")

                elif 'dbconfig_csv' in table:
                    sql_text = (f"UPDATE {self.schema}.{row['context']} SET alias = {texts[0]}, descript = {texts[1]} "
                                f"WHERE fid = '{row['source']}';\n")

                elif 'dbconfig_form_tabs' in table:
                    sql_text = (f"UPDATE {self.schema}.{row['context']} SET label = {texts[0]}, tooltip = {texts[1]} "
                                f"WHERE formname = '{row['formname']}' AND tabname = '{row['source']}';\n")

                elif 'dbconfig_report' in table:
                    sql_text = (f"UPDATE {self.schema}.{row['context']} SET alias = {texts[0]}, descript = {texts[1]} "
                                f"WHERE id = '{row['source']}';\n")

                elif 'dbconfig_toolbox' in table:
                    sql_text = (f"UPDATE {self.schema}.{row['context']} SET alias = {texts[0]}, observ = {texts[1]} "
                                f"WHERE id = '{row['source']}';\n")

                elif 'dbfunction' in table:
                    sql_text = (f"UPDATE {self.schema}.{row['context']} SET descript = {texts[0]} "
                                f"WHERE id = '{row['source']}';\n")

                elif 'dbtypevalue' in table:
                    sql_text = (f"UPDATE {self.schema}.{row['context']} SET idval = {texts[0]}, descript = {texts[1]} "
                                f"WHERE id = '{row['source']}' AND typevalue = '{row['typevalue']}';\n")

                elif 'dbconfig_form_tableview' in table:
                    sql_text = (f"UPDATE {self.schema}.{row['context']} SET alias = {texts[0]} "
                                f"WHERE objectname = '{row['source']}' AND columnname = '{row['columnname']}';\n")

                elif 'dbtable' in table:
                    sql_text = (f"UPDATE {self.schema}.{row['context']} SET alias = {texts[0]}, descript = {texts[1]} "
                                f"WHERE id = '{row['source']}';\n")

                elif 'dbconfig_engine' in table:
                    sql_text = (f"UPDATE {self.schema}.{row['context']} SET label = {texts[0]}, descript = {texts[1]}, placeholder = {texts[2]} "
                                f"WHERE parameter = '{row['parameter']}' AND method = '{row['method']}';\n")

                elif 'su_basic_tables' in table:
                    if self.schema == "am":
                        sql_text = (f"UPDATE {self.schema}.{row['context']} SET idval = {texts[0]} "
                                    f"WHERE id = '{row['source']}';\n")

                try:
                    self.cursor_dest.execute(sql_text)
                    self._commit_dest()
                except Exception as e:
                    print(e)
                    tools_db.dao.rollback()

    def _write_dbjson_values(self, rows):
        query = ""
        updates = {}
        for row in rows:
            if row["context"] == "config_form_fields":
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
                query_text = (
                    f"UPDATE {self.schema}.{context} SET {column} = '{new_text}'::json "
                    f"WHERE formname = '{related_rows[0]['formname']}' "
                    f"AND formtype = '{related_rows[0]['formtype']}' "
                    f"AND columnname = '{source}';\n"
                )
            else:
                query_text = f"UPDATE {self.schema}.{context} SET {column} = '{new_text}'::json WHERE id = {source};\n"

            query += query_text

        try:
            self.cursor_dest.execute(query)
            self.conn_dest.commit()
        except Exception as e:
            self.conn_dest.rollback()
            print(e)

    # endregion

    # region Extra fucntions
    def _change_lang(self):
        query = f"UPDATE {self.schema}.sys_version SET language = '{self.language}'"
        try:
            self.cursor_dest.execute(query)
            self._commit_dest()
        except Exception as e:
            tools_db.dao.rollback()

    def _save_user_values(self):
        """ Save selected user values """

        host = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_host, return_string_null=False)
        port = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_port, return_string_null=False)
        db = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_db, return_string_null=False)
        user = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_user, return_string_null=False)
        language = tools_qt.get_combo_value(self.dlg_qm, self.dlg_qm.cmb_language, 0)
        py_msg = False
        db_msg = False
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_host', f"{host}", "user", "session", prefix=False)
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_port', f"{port}", "user", "session", prefix=False)
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_db', f"{db}", "user", "session", prefix=False)
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_user', f"{user}", "user", "session", prefix=False)
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_language', f"{language}", "user", "session", prefix=False)
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_py_msg', f"{py_msg}", "user", "session", prefix=False)
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_db_msg', f"{db_msg}", "user", "session", prefix=False)

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

    def _load_user_values(self):
        """
        Load last selected user values
            :return: Dictionary with values
        """

        host = tools_gw.get_config_parser('i18n_generator', 'qm_lang_host', "user", "session", False)
        port = tools_gw.get_config_parser('i18n_generator', 'qm_lang_port', "user", "session", False)
        db = tools_gw.get_config_parser('i18n_generator', 'qm_lang_db', "user", "session", False)
        user = tools_gw.get_config_parser('i18n_generator', 'qm_lang_user', "user", "session", False)
        py_msg = tools_gw.get_config_parser('i18n_generator', 'qm_lang_py_msg', "user", "session", False)
        db_msg = tools_gw.get_config_parser('i18n_generator', 'qm_lang_db_msg', "user", "session", False)
        tools_qt.set_widget_text(self.dlg_qm, 'txt_host', host)
        tools_qt.set_widget_text(self.dlg_qm, 'txt_port', port)
        tools_qt.set_widget_text(self.dlg_qm, 'txt_db', db)
        tools_qt.set_widget_text(self.dlg_qm, 'txt_user', user)

    def _init_db_i18n(self, host, port, db, user, password):
        """Initializes database connection"""
        e = ''
        try:
            self.conn_i18n = psycopg2.connect(database=db, user=user, port=port, password=password, host=host)
            self.cursor_i18n = self.conn_i18n.cursor(cursor_factory=psycopg2.extras.DictCursor)
            return True, e
        except psycopg2.DatabaseError as e:
            self.last_error = e
            return False, e

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

    def _close_db_dest(self):
        """ Close database connection """

        try:
            status = True
            if self.cursor_dest:
                self.cursor_dest.close()
            del self.cursor_dest
        except Exception as e:
            self.last_error = e
            status = False

        return status

    def _commit(self):
        """ Commit current database transaction """
        self.conn_i18n.commit()

    def _commit_dest(self):
        """ Commit current database transaction """
        tools_db.dao.commit()

    def _rollback(self):
        """ Rollback current database transaction """
        self.conn_i18n.rollback()

    def _get_rows(self, sql, cursor, commit=True):
        """ Get multiple rows from selected query """

        self.last_error = None
        rows = None
        try:
            cursor.execute(sql)
            rows = cursor.fetchall()
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

    def _delete_table(self, table, cur, conn):
        query = f"DROP TABLE IF EXISTS {table}"
        try:
            cur.execute(query)
            conn.commit()
        except Exception as e:
            print(e)
            conn.rollback()

    def _copy_table_from_another_db(self, full_table_org, full_table_dest, cur_org, cur_dest, conn_dest):
        # Fetch existing rows from cat_feature
        schema_org = full_table_org.split('.')[0]
        table_org = full_table_org.split('.')[1]
        schema_dest = full_table_dest.split('.')[0]
        table_dest = full_table_dest.split('.')[1]

        query = f"SELECT * FROM {schema_org}.{table_org}"
        cur_org.execute(query)
        rows = cur_org.fetchall()

        # Fetch column names and types
        query = f"""SELECT column_name, data_type FROM information_schema.columns 
                    WHERE table_schema = '{schema_org}' AND table_name = '{table_org}';"""
        cur_org.execute(query)
        column_types = cur_org.fetchall()

        # Remove 'lastupdate' before joining
        filtered_columns = [f"{col[0]} {col[1]}" for col in column_types if col[0].lower() != 'lastupdate']

        # Generate CREATE TABLE statement
        columns_def = ", ".join(filtered_columns)

        create_table_query = f"DROP TABLE IF EXISTS {schema_dest}.{table_dest};\n"
        create_table_query += f"CREATE TABLE IF NOT EXISTS {schema_dest}.{table_dest} ({columns_def}, CONSTRAINT {table_org}_pkey PRIMARY KEY (id));\n"

        # Generate INSERT statements
        column_names = ", ".join([col[0] for col in column_types if col[0].lower() != 'lastupdate'])
        insert_queries = ""
        for row in rows:
            # Create a proper insert query for each row
            values = ", ".join([
                "NULL" if value is None
                else f"'{value.replace("'", "''")}'" if isinstance(value, str)  # String values need to be quoted
                else str(value).replace("'", "''")  # For other types like integers and floats
                for value in row if not isinstance(value, datetime.datetime)
            ])
            insert_queries += f"INSERT INTO {schema_dest}.{table_dest} ({column_names}) VALUES ({values});\n"

        # Final SQL query
        final_query = create_table_query + insert_queries

        cur_dest.execute(final_query)
        conn_dest.commit()

    def tables_dic(self):
        self.dbtables_dic = {
            "ws": {
                "dbtables": ["dbparam_user", "dbconfig_param_system", "dbconfig_form_fields", "dbconfig_typevalue",
                    "dbfprocess", "dbmessage", "dbconfig_csv", "dbconfig_form_tabs", "dbconfig_report",
                    "dbconfig_toolbox", "dbfunction", "dbtypevalue", "dbconfig_form_fields_feat",
                    "dbconfig_form_tableview", "dbtable", "dbjson", "dbconfig_form_fields_json"
                 ]
            },
            "ud": {
                "dbtables": ["dbparam_user", "dbconfig_param_system", "dbconfig_form_fields", "dbconfig_typevalue",
                    "dbfprocess", "dbmessage", "dbconfig_csv", "dbconfig_form_tabs", "dbconfig_report",
                    "dbconfig_toolbox", "dbfunction", "dbtypevalue", "dbconfig_form_fields_feat",
                    "dbconfig_form_tableview", "dbtable", "dbjson", "dbconfig_form_fields_json"
                 ]
            },
            "am": {
                "dbtables": ["dbconfig_engine", "dbconfig_form_tableview", "su_basic_tables"]
            },
            "cm": {
                "dbtables": ["dbconfig_form_fields", "dbconfig_form_tabs", "dbconfig_param_system",
                             "dbtypevalue", "dbconfig_form_fields_json"]
            },
        }

    # endregion