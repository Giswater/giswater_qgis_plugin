"""
This file is part of Giswater 3
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
import time

from ..ui.ui_manager import GwSchemaI18NUpdateUi
from ..utils import tools_gw
from ...libs import lib_vars, tools_qt, tools_qgis, tools_db


class GwSchemaI18NUpdate:

    def __init__(self):
        self.plugin_dir = lib_vars.plugin_dir
        self.schema_name = lib_vars.schema_name
        self.project_type_selected = None


    def init_dialog(self):
        """ Constructor """

        self.dlg_qm = GwSchemaI18NUpdateUi(self)
        tools_gw.load_settings(self.dlg_qm)
        self._load_user_values()
        self.dev_commit = tools_gw.get_config_parser('system', 'force_commit', "user", "init", prefix=True)
        self._set_signals()

        self.dlg_qm.btn_translate.setEnabled(False)
        # Mysteriously without the partial the function check_connection is not called
    
        self.project_types = tools_gw.get_config_parser('system', 'project_types_translation', "project", "giswater", False,
                                                        force_reload=True)
        self.project_types = self.project_types.split(',')

        # Populate combo types
        self.dlg_qm.cmb_projecttype.clear()
        for aux in self.project_types:
            self.dlg_qm.cmb_projecttype.addItem(str(aux))

        tools_gw.open_dialog(self.dlg_qm, dlg_name='admin_update_translation')


    def pass_schema_info(self, schema_info, schema_name):
        self.project_type = schema_info['project_type']
        self.project_epsg = schema_info['project_epsg']
        self.project_version = schema_info['project_version']
        self.project_language = schema_info['project_language']
        self.schema_name = schema_name

    # region private functions

    def _set_signals(self):
        self.dlg_qm.btn_connection.clicked.connect(partial(self._check_connection))
        self.dlg_qm.btn_connection_dest.clicked.connect(partial(self._check_connection_dest))
        self.dlg_qm.btn_translate.clicked.connect(self.schema_i18n_update)
        self.dlg_qm.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_qm))
        self.dlg_qm.rejected.connect(self._save_user_values)
        self.dlg_qm.rejected.connect(self._close_db)
        self.dlg_qm.rejected.connect(self._close_db_dest)

        self.dlg_qm.cmb_projecttype.currentIndexChanged.connect(partial(self._populate_data_schema_name, self.dlg_qm.cmb_projecttype))


    def _check_connection(self):
        """ Check connection to database """

        self.dlg_qm.cmb_language.clear()
        self.dlg_qm.lbl_info.clear()
        self._close_db()
        # Connection with origin db
        host_org = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_host)
        port_org = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_port)
        db_org = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_db)
        user_org = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_user)
        password_org = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_pass)
        print(f'host:{host_org}, port: {port_org}, db: {db_org}, user:{user_org}, pass: {password_org}')
        status_org = self._init_db_org(host_org, port_org, db_org, user_org, password_org)

        if host_org != '188.245.226.42' and port_org != '5432' and db_org != 'giswater':
            self.dlg_qm.btn_translate.setEnabled(False)
            tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', self.last_error)
            return
        
        if not status_org:
            self.dlg_qm.btn_translate.setEnabled(False)
            tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', self.last_error)
            return
        
        self._populate_cmb_language()

    def _check_connection_dest(self):
        """ Check connection to database """

        self.dlg_qm.lbl_info.clear()
        self._close_db_dest()
        
        # Connection with destiny db
        host_dest = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_host_dest)
        port_dest = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_port_dest)
        db_dest = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_db_dest)
        user_dest = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_user_dest)
        password_dest = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_pass_dest)
        status_dest = self._init_db_dest(host_dest, port_dest, db_dest, user_dest, password_dest)

        if not status_dest:
            tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', self.last_error)
            return
        
        tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', f'Connected to {host_dest}')
        
    def _populate_cmb_language(self):
        """ Populate combo with languages values """

        self.dlg_qm.btn_translate.setEnabled(True)
        host_org = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_host)
        tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', f'Connected to {host_org}')
        sql = "SELECT id, idval FROM i18n.cat_language"
        rows = self._get_rows(sql, self.cursor_org)
        tools_qt.fill_combo_values(self.dlg_qm.cmb_language, rows)
        language = tools_gw.get_config_parser('i18n_generator', 'qm_lang_language', "user", "session", False)

        tools_qt.set_combo_value(self.dlg_qm.cmb_language, language, 0, add_new=False)

    def _populate_data_schema_name(self, widget):
        """"""

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
                if result is not None and result[0] == filter_.upper():
                    elem = [row[0], row[0]]
                    result_list.append(elem)
        if not result_list:
            self.dlg_qm.cmb_schema.clear()
            return

        tools_qt.fill_combo_values(self.dlg_qm.cmb_schema, result_list)

    def _change_project_type(self, widget):
        """ Take current project type changed """

        self.project_type_selected = tools_qt.get_text(self.dlg_qm, widget)

    def schema_i18n_update(self):
        self.language = tools_qt.get_combo_value(self.dlg_qm, self.dlg_qm.cmb_language, 0)
        self.lower_lang = self.language.lower()
        msg = ''

        status_cfg_msg, errors = self._copy_db_files()
        if status_cfg_msg is True:
            msg += "Database translation successful\n"
            self._commit_dest()
        elif status_cfg_msg is False:
            msg += "Database translation failed\n"
        elif status_cfg_msg is None:
            msg += "Database translation canceled\n"

        if errors:
            msg += f'. There have been errors translating: {', '.join(errors)}'
        
        self._close_db_dest()
        self._close_db()

        tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', msg)

    def _copy_db_files(self):
        """ Read the values of the database and generate the ts and qm files """

        # On the database, the dialog_name column must match the name of the ui file (no extension).
        # Also, open_dialog function must be called, passed as parameter dlg_name = 'ui_file_name_without_extension'
        self.project_type = tools_qt.get_text(self.dlg_qm, self.dlg_qm.cmb_projecttype, 0)
        self.schema = tools_qt.get_text(self.dlg_qm, self.dlg_qm.cmb_schema, 0)
        messages = []

        # Get db_message values
        db_messages = self._get_dbmessages_values()
        if not db_messages:
            messages.append('db_message')  # Corregido: usar append en lugar de expand
        else:
            self._write_dbmessages_values(db_messages)

        # Get db_dialog values
        db_dialogs = self._get_dbdialog_values()
        if not db_dialogs:
            messages.append('db_dialogs')  # Corregido
        else:
            print('db_dialog')
            self._write_dbdialog_values(db_dialogs)

        # Get db_fprocess values
        db_fprocesses = self._get_dbfprocess_values()
        if not db_fprocesses:
            messages.append('db_fprocesses')  # Corregido
        else:
            self._write_dbfprocess_values(db_fprocesses)

        # Mostrar mensaje de error si hay errores
        if messages:  # Corregido: Verifica si hay elementos en la lista
            tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', f'Error translating: {', '.join(messages)}')
            return False, messages
        else:
            return True, None


        #Get db_feature values

    def _get_dbdialog_values(self):
        """ Get db dialog values """

        sql = (f"SELECT source, formname, formtype, project_type, context, lb_en_us, lb_{self.lower_lang}, auto_lb_{self.lower_lang}, tt_en_us, "
               f"tt_{self.lower_lang}, auto_tt_{self.lower_lang} "
               f"FROM i18n.dbdialog "
               f"ORDER BY context, formname;")
        rows = self._get_rows(sql, self.cursor_org)

        tools_qt.set_widget_text(self.dlg_qm, 'lbl_info_2', f"Updating db_dialog...")
        
        if not rows:
            return False
        return rows
    
    def _write_dbdialog_values(self, db_dialogs):
        status = True
        errors = []
        i=0
        j=0
        for db_dialog in db_dialogs:
            i+=1
            if db_dialog['project_type'] == self.project_type or db_dialog['project_type'] == 'utils':
                j+=1
                source = [db_dialog['formname'], db_dialog['formtype'], db_dialog['source']]
                label = db_dialog[f'lb_{self.lower_lang}']
                if label is None:
                    label = db_dialog[f'auto_lb_{self.lower_lang}']
                    if label is None:
                        label = db_dialog['lb_en_us']
                        if label is None:
                            label = source[2]
                            if label is None:
                                label = ""
                tooltip = db_dialog[f'tt_{self.lower_lang}']
                if tooltip is None:
                    tooltip = db_dialog[f'auto_tt_{self.lower_lang}']
                    if tooltip is None:
                        tooltip = db_dialog['tt_en_us']
                        if tooltip is None:
                            tooltip = db_dialog['lb_en_us']
                            if tooltip is None:
                                tooltip = ""

                tooltip = tooltip.replace("'", "''") 
                label = label.replace("'", "''")
                
                sql_text = None

                if db_dialog['context'] == 'config_form_fields':
                    sql_1 = f"UPDATE {self.schema}.config_param_system SET value = TRUE WHERE parameter = 'admin_config_control_trigger'"
                    self.cursor_dest.execute(sql_1)
                    self.conn_dest.commit()

                    sql_text = (f"UPDATE {self.schema}.{db_dialog['context']} SET label = '{label}', tooltip = '{tooltip}' "
                        f"WHERE formname = '{source[0]}' and formtype = '{source[1]}' and columnname = '{source[2]}'")
                    
                    sql_2 = f"UPDATE {self.schema}.config_param_system SET value = FALSE WHERE parameter = 'admin_config_control_trigger'"
                    self.cursor_dest.execute(sql_2)
                    self.conn_dest.commit()

                elif db_dialog['context'] == 'sys_param_user':
                    sql_text = (f"UPDATE {self.schema}.{db_dialog['context']} SET label = '{label}', descript = '{tooltip}' "
                        f"WHERE id = '{source[2]}'")

                elif db_dialog['context'] == 'config_param_system':
                    sql_text = (f"UPDATE {self.schema}.{db_dialog['context']} SET label = '{label}', descript = '{tooltip}' "
                        f"WHERE parameter = '{source[2]}'")

                elif db_dialog['context'] == 'config_typevalue':
                    print(f'Total:{i}, {db_dialog['project_type']}: {j}')
                    sql_text = (f"UPDATE {self.schema}.{db_dialog['context']} SET idval = '{tooltip}' "
                        f"WHERE id = '{source[2]}' and typevalue = '{source[0]}'")

                try:
                    self.cursor_dest.execute(sql_text)
                    self.conn_dest.commit()
                except Exception as e:
                    print(e)
                    self.conn_dest.rollback()
                    break
    
    def _get_dbmessages_values(self):
        """ Get db messages values """

        sql = (f"SELECT source, project_type, context, ms_en_us, ms_{self.lower_lang}, auto_ms_{self.lower_lang}, ht_en_us, ht_{self.lower_lang}, auto_ht_{self.lower_lang}"
               f" FROM i18n.dbmessage "
               f" ORDER BY project_type;")
        rows = self._get_rows(sql, self.cursor_org)
        tools_qt.set_widget_text(self.dlg_qm, 'lbl_info_2', f"Updating db_messages...")
        if not rows:
            return False
        return rows

    def _write_dbmessages_values(self, db_messages):
        i = 0
        j = 0
        for db_message in db_messages:
            i += 1
            if db_message['project_type'] == self.project_type or db_message['project_type'] == 'utils':
                j += 1
                source = db_message['source']
                error_ms = db_message[f'ms_{self.lower_lang}']
                if error_ms is None:
                    error_ms = db_message[f'auto_ms_{self.lower_lang}']
                    if error_ms is None:
                        error_ms = db_message['ms_en_us']
                        if error_ms is None:
                            error_ms = ""
                hint_ms = db_message[f'ht_{self.lower_lang}']
                if hint_ms is None:
                    hint_ms = db_message[f'auto_ht_{self.lower_lang}']
                    if hint_ms is None:
                        hint_ms = db_message['ht_en_us']
                        if hint_ms is None:
                            hint_ms = ""

                error_ms = error_ms.replace("'", "''") 
                hint_ms = hint_ms.replace("'", "''")
                print(f'Total:{i}, {db_message['project_type']}: {j}')
                try:
                    sql = (f"UPDATE {self.schema}.sys_message "
                        f"SET error_message = '{error_ms}',  hint_message = '{hint_ms}'"
                        f"WHERE id = '{source}'")
                    self.cursor_dest.execute(sql)
                    self.conn_dest.commit()
                except Exception as e:
                    self.conn_dest.rollback()
                    break
    
    def _get_dbfprocess_values(self):
        """ Get db messages values """

        sql = (f"SELECT source, project_type, context, ex_en_us, ex_{self.lower_lang}, auto_ex_{self.lower_lang}, in_en_us, in_{self.lower_lang}, auto_in_{self.lower_lang}"
               f" FROM i18n.dbfprocess "
               f" ORDER BY context;")
        rows = self._get_rows(sql, self.cursor_org)
        tools_qt.set_widget_text(self.dlg_qm, 'lbl_info_2', f"Updating db_fprocess...")
        if not rows:
            return False
        return rows

    def _write_dbfprocess_values(self, db_fprocesses):
        i = 0
        j = 0
        for db_fprocess in db_fprocesses:
            i += 1
            if db_fprocess['project_type'] == self.project_type or db_fprocess['project_type'] == 'utils':
                j += 1
                source = db_fprocess['source']
                ex_msg = db_fprocess[f'ex_{self.lower_lang}']
                if ex_msg is None:
                    ex_msg = db_fprocess[f'auto_ex_{self.lower_lang}']
                    if ex_msg is None:
                        ex_msg = db_fprocess['ex_en_us']
                        if ex_msg is None:
                            ex_msg = ""
                in_msg = db_fprocess[f'in_{self.lower_lang}']
                if in_msg is None:
                    in_msg = db_fprocess[f'auto_in_{self.lower_lang}']
                    if in_msg is None:
                        in_msg = db_fprocess['in_en_us']
                        if in_msg is None:
                            in_msg = ""

                ex_msg = ex_msg.replace("'", "''") 
                in_msg = in_msg.replace("'", "''")
                print(f'Total:{i}, {db_fprocess['project_type']}: {j}')
                try:
                    sql = (f"UPDATE {self.schema}.sys_fprocess "
                        f"SET except_msg = '{ex_msg}', info_msg = '{in_msg}' "
                        f"WHERE fid = '{source}'")
                    self.cursor_dest.execute(sql)
                    self.conn_dest.commit()
                except Exception as e:
                    self.conn_dest.rollback()
                    break

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

    def _init_db_org(self, host, port, db, user, password):
        """Initializes database connection"""

        try:
            self.conn_org = psycopg2.connect(database=db, user=user, port=port, password=password, host=host)
            self.cursor_org = self.conn_org.cursor(cursor_factory=psycopg2.extras.DictCursor)
        
            return True
        except psycopg2.DatabaseError as e:
            self.last_error = e
            return False
    
    def _init_db_dest(self, host, port, db, user, password):
        """Initializes database connection"""

        try:
            self.conn_dest = psycopg2.connect(database=db, user=user, port=port, password=password, host=host)
            self.cursor_dest = self.conn_dest.cursor(cursor_factory=psycopg2.extras.DictCursor)
        
            return True
        except psycopg2.DatabaseError as e:
            self.last_error = e
            return False

    def _close_db(self):
        """ Close database connection """

        try:
            status = True
            if self.cursor_org:
                self.cursor_org.close()
            if self.conn_org:
                self.conn_org.close()
            del self.cursor_org
            del self.conn_org
        except Exception as e:
            self.last_error = e
            status = False

    def _close_db_dest(self):
        """ Close database connection """

        try:
            status = True
            if self.cursor_dest:
                self.cursor_dest.close()
            if self.conn_dest:
                self.conn_dest.close()
            del self.cursor_dest
            del self.conn_dest
        except Exception as e:
            self.last_error = e
            status = False

        return status


    def _commit(self):
        """ Commit current database transaction """
        self.conn_org.commit()

    def _commit_dest(self):
        """ Commit current database transaction """
        self.conn_dest.commit()

    def _rollback(self):
        """ Rollback current database transaction """
        self.conn_org.rollback()


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

    # endregion
