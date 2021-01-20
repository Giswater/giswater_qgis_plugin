"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
import psycopg2
import psycopg2.extras
import subprocess
from functools import partial

from ..ui.ui_manager import GwAdminTranslationUi
from ..utils import tools_gw
from ... import global_vars
from ...lib import tools_qt, tools_qgis, tools_db


class GwI18NGenerator:

    def __init__(self):
        self.plugin_dir = global_vars.plugin_dir


    def init_dialog(self):

        self.dlg_qm = GwAdminTranslationUi()
        tools_gw.load_settings(self.dlg_qm)
        self.load_user_values()

        self.dlg_qm.btn_translate.setEnabled(False)
        # Mysteriously without the partial the function check_connection is not called
        self.dlg_qm.btn_connection.clicked.connect(partial(self.check_connection))
        self.dlg_qm.btn_translate.clicked.connect(self.check_translate_options)
        self.dlg_qm.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_qm))
        self.dlg_qm.rejected.connect(self.save_user_values)
        self.dlg_qm.rejected.connect(self.close_db)
        tools_gw.open_dialog(self.dlg_qm, dlg_name='admin_translation')


    def check_connection(self):
        """ Check connection to database """
        self.dlg_qm.cmb_language.clear()
        self.dlg_qm.lbl_info.clear()
        self.close_db()
        host = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_host)
        port = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_port)
        db = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_db)
        user = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_user)
        password = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_pass)
        status = self.init_db(host, port, db, user, password)

        if not status:
            self.dlg_qm.btn_translate.setEnabled(False)
            tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', self.last_error)
            return
        self.populate_cmb_language()


    def populate_cmb_language(self):
        """ Populate combo with languages values """ 
        self.dlg_qm.btn_translate.setEnabled(True)
        host = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_host)
        tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', f'Connected to {host}')
        sql = "SELECT id, idval FROM i18n.cat_language"
        rows = self.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_qm.cmb_language, rows, 1)
        language = tools_gw.get_config_parser('i18n_generator', 'qm_lang_language', "user", "init")

        tools_qt.set_combo_value(self.dlg_qm.cmb_language, language, 1)


    def check_translate_options(self):
        py_msg = tools_qt.is_checked(self.dlg_qm, self.dlg_qm.chk_py_msg)
        db_msg = tools_qt.is_checked(self.dlg_qm, self.dlg_qm.chk_db_msg)
        self.dlg_qm.lbl_info.clear()
        msg = ''
        self.language = tools_qt.get_combo_value(self.dlg_qm, self.dlg_qm.cmb_language, 0)
        self.lower_lang = self.language.lower()
        if py_msg:
            status_py_msg = self.create_py_files()
            if status_py_msg is True:
                msg += "Python translation successful\n"
            elif status_py_msg is False:
                msg += "Python translation failed\n"
            elif status_py_msg is None:
                msg += "Python translation canceled\n"

        if db_msg:
            status_cfg_msg = self.create_db_files()
            if status_cfg_msg is True:
                msg += "Data base translation successful\n"
            elif status_cfg_msg is False:
                msg += "Data base translation failed\n"
            elif status_cfg_msg is None:
                msg += "Data base translation canceled\n"

        if msg != '':
            tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', msg)


    def create_py_files(self):
        """ Read the values of the database and generate the ts and qm files """
        # On the database, the dialog_name column must match the name of the ui file (no extension).
        # Also, open_dialog function must be called, passed as parameter dlg_name = 'ui_file_name_without_extension'

        key_label = f'lb_{self.lower_lang}'
        key_tooltip = f'tt_{self.lower_lang}'
        key_message = f'ms_{self.lower_lang}'

        # Get python messages values
        sql = f"SELECT source, ms_en_en, {key_message} FROM i18n.pymessage;"
        py_messages = self.get_rows(sql)

        # Get python toolbars and buttons values
        sql = f"SELECT source, lb_en_en, {key_label} FROM i18n.pytoolbar;"
        py_toolbars = self.get_rows(sql)

        # Get python dialog values
        sql = (f"SELECT dialog_name, source, lb_en_en, {key_label}, tt_en_en, {key_tooltip} "
               f" FROM i18n.pydialog "
               f" ORDER BY dialog_name;")
        py_dialogs = self.get_rows(sql)

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
            if py_tlb[key_label] is None:
                py_tlb[key_label] = py_tlb['lb_en_en']
                if py_tlb['lb_en_en'] is None:
                    py_tlb[key_label] = py_tlb['source']

            line += f"\t\t\t<translation>{py_tlb[key_label]}</translation>\n"
            line += f"\t\t</message>\n"
            line = line.replace("&", "")
            ts_file.write(line)
        line = '\t</context>\n\n'
        line += '\t<!-- PYTHON MESSAGES -->\n'
        line += '\t<context>\n'
        ts_file.write(line)

        # Create children for message
        for py_msg in py_messages:
            line = f"\t\t<message>\n"
            line += f"\t\t\t<source>{py_msg['source']}</source>\n"
            if py_msg[key_message] is None:
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
                title = self.get_title(py_dialogs, name, key_label)
                if title:
                    line += f'\t\t<message>\n'
                    line += f'\t\t\t<source>title</source>\n'
                    line += f'\t\t\t<translation>{title}</translation>\n'
                    line += f'\t\t</message>\n'

            # Create child for labels
            line += f"\t\t<message>\n"
            line += f"\t\t\t<source>{py_dlg['source']}</source>\n"
            if py_dlg[key_label] is None:
                py_dlg[key_label] = py_dlg['lb_en_en']

            line += f"\t\t\t<translation>{py_dlg[key_label]}</translation>\n"
            line += f"\t\t</message>\n"

            # Create child for tooltip
            line += f"\t\t<message>\n"
            line += f"\t\t\t<source>tooltip_{py_dlg['source']}</source>\n"
            if py_dlg[key_label] is None:
                py_dlg[key_tooltip] = py_dlg['lb_en_en']
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


    def get_title(self, py_dialogs, name, key_label):
        title = None
        for py in py_dialogs:
            if py['source'] == f'dlg_{name}':
                title = py[key_label]
                if not title:
                    title = py['lb_en_en']
                return title
        return title


    def create_db_files(self):
        """ Read the values of the database and update the i18n files """

        higher_version = tools_qgis.get_higher_version().replace(".", "")
        ver_build = tools_qgis.get_build_version()

        cfg_path = f"{self.plugin_dir}{os.sep}dbmodel{os.sep}updates{os.sep}{higher_version}{os.sep}{ver_build}" \
                   f"{os.sep}i18n{os.sep}{self.language}{os.sep}"
        file_name = f'dml.sql'

        # Check if file exist
        if os.path.exists(cfg_path + file_name):
            msg = "Are you sure you want to overwrite this file?"
            answer = tools_qt.show_question(msg, "Overwrite", parameter=f"\n\n{cfg_path}{file_name}")
            if not answer:
                return
        else:
            os.makedirs(cfg_path, exist_ok=True)

        self.write_header(cfg_path + file_name)

        rows = self.get_dbdialog_values()
        status = self.write_dbdialog_values(rows, cfg_path + file_name)

        rows = self.get_dbmessages_values()
        status = self.write_dbmessages_values(rows, cfg_path + file_name)


        return status


    def get_dbdialog_values(self):
        # Get db messages values
        sql = (f"SELECT source, project_type, context, formname, formtype, lb_en_en, lb_{self.lower_lang}, tt_en_en, "
               f"tt_{self.lower_lang}"
               f" FROM i18n.dbdialog "
               f" ORDER BY context, formname;")
        rows = self.get_rows(sql)
        if not rows:
            return False
        return rows


    def get_dbmessages_values(self):
        # Get db messages values
        sql = (f"SELECT source, project_type, context, ms_en_en, ms_{self.lower_lang}, ht_en_en, ht_{self.lower_lang}"
               f" FROM i18n.dbmessage "
               f" ORDER BY context;")
        rows = self.get_rows(sql)
        if not rows:
            return False
        return rows


    def write_header(self, path):
        file = open(path, "w")
        header = (f'/*\n'
                  f'This file is part of Giswater 3\n'
                  f'The program is free software: you can redistribute it and/or modify it under the terms of the GNU '
                  f'General Public License as published by the Free Software Foundation, either version 3 of the '
                  f'License, or (at your option) any later version.\n'
                  f'This version of Giswater is provided by Giswater Association,\n'
                  f'*/\n\n\n'
                  f'SET search_path = SCHEMA_NAME, public, pg_catalog;\n\n')
        file.write(header)
        file.close()
        del file


    def write_dbdialog_values(self, rows, path):
        """ Generate a string and write into file
        :param rows: List of values ([List][list])
        :param path: Full destination path (String)
        :return: (Boolean)
        """

        file = open(path, "a")

        for row in rows:
            table = row['context'] if row['context'] is not None else ""
            form_name = row['formname']if row['formname'] is not None else ""
            form_type = row['formtype']if row['formtype'] is not None else ""
            source = row['source']if row['source'] is not None else ""
            lbl_value = row[f'lb_{self.lower_lang}'] if row[f'lb_{self.lower_lang}'] is not None else row['lb_en_en']
            lbl_value = lbl_value if lbl_value is not None else ""
            if row[f'tt_{self.lower_lang}'] is not None:
                tt_value = row[f'tt_{self.lower_lang}']
            elif row[f'tt_en_en'] is not None:
                tt_value = row[f'tt_en_en']
            else:
                tt_value = row['lb_en_en']
            tt_value = tt_value if tt_value is not None else ""
            line = f'SELECT gw_fct_admin_schema_i18n($$'
            if row['context'] in ('config_param_system', 'sys_param_user'):
                line += (f'{{"data":'
                         f'{{"table":"{table}", '
                         f'"formname":"{form_name}", '
                         f'"label":{{"column":"label", "value":"{lbl_value}"}}, '
                         f'"tooltip":{{"column":"descript", "value":"{tt_value}"}}')
            elif row['context'] not in ('config_param_system', 'sys_param_user'):
                line += (f'{{"data":'
                         f'{{"table":"{table}", '
                         f'"formname":"{form_name}", '
                         f'"label":{{"column":"label", "value":"{lbl_value}"}}, '
                         f'"tooltip":{{"column":"tooltip", "value":"{tt_value}"}}')

            # Clause WHERE for each context
            if row['context'] == 'config_form_fields':
                line += (f', "clause":"WHERE columnname = \'{source}\' '
                         f'AND formname = \'{form_name}\' AND formtype = \'{form_type}\'"')
            elif row['context'] == 'config_form_tabs':
                line += (f', "clause":"WHERE formname = \'{form_name}\' '
                         f'AND columnname = \'{source}\' AND formtype = \'{form_type}\'"')
            elif row['context'] == 'config_form_groupbox':
                line += (f', "clause":"WHERE formname = \'{form_name}\' '
                         f'AND layout_id  = \'{source}\'"')
            elif row['context'] == 'config_form_actions':
                line += f', "clause":"WHERE actioname  = \'{source}\''
            elif row['context'] == 'config_param_system':
                line += f', "clause":"WHERE parameter = \'{source}\'"'
            elif row['context'] == 'sys_param_user':
                line += f', "clause":"WHERE id = \'{source}\'"'

            line += f'}}}}$$);\n'
            file.write(line)
        file.close()
        del file
        return True

    def write_dbmessages_values(self, rows, path):

        """ Generate a string and write into file
        :param rows: List of values ([List][list])
        :param path: Full destination path (String)
        :return: (Boolean)
        """

        file = open(path, "a")

        for row in rows:
            table = row['context'] if row['context'] is not None else ""
            source = row['source'] if row['source'] is not None else ""
            ms_value = row[f'ms_{self.lower_lang}'] if row[f'ms_{self.lower_lang}'] is not None else row['ms_en_en']
            ht_value = ms_value if ms_value is not None else ""

            line = f'SELECT gw_fct_admin_schema_i18n($$'
            line += (f'{{"data":'
                     f'{{"table":"{table}", '
                     f'"formname":null, '
                     f'"label":{{"column":"error_message", "value":"{ms_value}"}}, '
                     f'"tooltip":{{"column":"hint_message", "value":"{ht_value}"}}')

            # Clause WHERE for each context
            if row['context'] == 'sys_message':
                line += f', "clause":"WHERE id = \'{source}\' "'

            line += f'}}}}$$);\n'
            file.write(line)
        file.close()
        del file
        return True


    def save_user_values(self):
        """ Save selected user values """

        host = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_host, return_string_null=False)
        port = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_port, return_string_null=False)
        db = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_db, return_string_null=False)
        user = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_user, return_string_null=False)
        language = tools_qt.get_combo_value(self.dlg_qm, self.dlg_qm.cmb_language, 0)
        py_msg = tools_qt.is_checked(self.dlg_qm, self.dlg_qm.chk_py_msg)
        db_msg = tools_qt.is_checked(self.dlg_qm, self.dlg_qm.chk_db_msg)
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_host', f"{host}", "user", "init")
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_port', f"{port}", "user", "init")
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_db', f"{db}", "user", "init")
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_user', f"{user}", "user", "init")
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_language', f"{language}", "user", "init")
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_py_msg', f"{py_msg}", "user", "init")
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_db_msg', f"{db_msg}", "user", "init")


    def load_user_values(self):
        """ Load last selected user values
        :return: Dictionary with values
        """

        host = tools_gw.get_config_parser('i18n_generator', 'qm_lang_host', "user", "init")
        port = tools_gw.get_config_parser('i18n_generator', 'qm_lang_port', "user", "init")
        db = tools_gw.get_config_parser('i18n_generator', 'qm_lang_db', "user", "init")
        user = tools_gw.get_config_parser('i18n_generator', 'qm_lang_user', "user", "init")
        py_msg = tools_gw.get_config_parser('i18n_generator', 'qm_lang_py_msg', "user", "init")
        db_msg = tools_gw.get_config_parser('i18n_generator', 'qm_lang_db_msg', "user", "init")
        tools_qt.set_widget_text(self.dlg_qm, 'txt_host', host)
        tools_qt.set_widget_text(self.dlg_qm, 'txt_port', port)
        tools_qt.set_widget_text(self.dlg_qm, 'txt_db', db)
        tools_qt.set_widget_text(self.dlg_qm, 'txt_user', user)
        tools_qt.set_checked(self.dlg_qm, self.dlg_qm.chk_py_msg, py_msg)
        tools_qt.set_checked(self.dlg_qm, self.dlg_qm.chk_db_msg, db_msg)
        

    def init_db(self, host, port, db, user, password):
        """ Initializes database connection """

        self.conn = None
        self.cursor = None
        try:
            self.conn = psycopg2.connect(database=db, user=user, port=port, password=password, host=host)
            self.cursor = self.conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
            status = True
        except psycopg2.DatabaseError as e:
            self.last_error = e
            status = False
        return status


    def close_db(self):
        """ Close database connection """

        try:
            status = True
            if self.cursor:
                self.cursor.close()
            if self.conn:
                self.conn.close()
            del self.cursor
            del self.conn
        except Exception as e:
            self.last_error = e
            status = False

        return status


    def commit(self):
        """ Commit current database transaction """
        self.conn.commit()


    def rollback(self):
        """ Rollback current database transaction """
        self.conn.rollback()


    def get_rows(self, sql, commit=True):
        """ Get multiple rows from selected query """

        self.last_error = None
        rows = None
        try:
            self.cursor.execute(sql)
            rows = self.cursor.fetchall()
            if commit:
                self.commit()
        except Exception as e:
            self.last_error = e
            if commit:
                self.rollback()
        finally:
            return rows
