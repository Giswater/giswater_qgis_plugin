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
from datetime import datetime, date


from ..ui.ui_manager import GwSchemaI18NManagerUi
from ..utils import tools_gw
from ...libs import lib_vars, tools_qt, tools_qgis, tools_db,tools_log, tools_os
from qgis.PyQt.QtWidgets import QLabel
from PyQt5.QtWidgets import QApplication


class GwSchemaI18NManager:

    def __init__(self):
        self.plugin_dir = lib_vars.plugin_dir
        self.schema_name = lib_vars.schema_name
        self.project_type_selected = None

    def init_dialog(self):
        """ Constructor """
    
        self.dlg_qm = GwSchemaI18NManagerUi(self) #Initialize the UI
        tools_gw.load_settings(self.dlg_qm)
        self._load_user_values() #keep values
        self.dev_commit = tools_gw.get_config_parser('system', 'force_commit', "user", "init", prefix=True)
        self.dlg_qm.btn_update.setEnabled(False)
        self._set_signals() #Set all the signals to wait for response

        #Get the project_types (ws, ud)
        self.project_types = tools_gw.get_config_parser('system', 'project_types', "project", "giswater", False,
                                                        force_reload=True)
        self.project_types = self.project_types.split(',')

        # Populate combo types
        self.dlg_qm.cmb_projecttype.clear()
        for aux in self.project_types:
            self.dlg_qm.cmb_projecttype.addItem(str(aux))

        tools_gw.open_dialog(self.dlg_qm, dlg_name='admin_i18n_manager')
        self._set_values()

    # region Button functions
    def _set_signals(self):
        # Mysteriously without the partial the function check_connection is not called
        self.dlg_qm.btn_connection.clicked.connect(partial(self._check_connection))
        self.dlg_qm.btn_update.clicked.connect(self.missing_dialogs)
        self.dlg_qm.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_qm))
        self.dlg_qm.btn_close.clicked.connect(partial(self._close_db_i18n))
        self.dlg_qm.btn_close.clicked.connect(partial(self._close_db_org))
        self.dlg_qm.rejected.connect(self._save_user_values)
        self.dlg_qm.rejected.connect(self._close_db_org)
        self.dlg_qm.rejected.connect(self._close_db_i18n)
        self.dlg_qm.cmb_updatetype.currentIndexChanged.connect(partial(self._set_values))
        self.dlg_qm.cmb_schema_org.currentIndexChanged.connect(partial(self._set_values))
        
        #Populate schema names
        self.dlg_qm.cmb_projecttype.currentIndexChanged.connect(partial(self._populate_data_schema_name, self.dlg_qm.cmb_projecttype))

    def _set_values(self):
        # Mysteriously without the partial the function check_connection is not called
        self.project_type = tools_qt.get_text(self.dlg_qm, self.dlg_qm.cmb_projecttype, 0)
        up_type = tools_qt.get_text(self.dlg_qm, self.dlg_qm.cmb_updatetype, 0)
        if up_type == "Update from existing schema":
            self.revise_lang = True
            self.schema_org = tools_qt.get_text(self.dlg_qm, self.dlg_qm.cmb_schema_org, 0)
            self._change_update_type(self.dlg_qm.lyt_new_schema, self.dlg_qm.lyt_existing_schema)
        elif up_type == "Create new temporal schema":
            self.revise_lang = False
            self.schema_org = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_schema_org)
            self._change_update_type(self.dlg_qm.lyt_existing_schema, self.dlg_qm.lyt_new_schema)
    
    def _change_update_type(self, previous_layout, new_layout):
        # Disable all widgets in the previous layout
        for i in range(previous_layout.count()):
            widget = previous_layout.itemAt(i).widget()
            if widget is not None:
                widget.setEnabled(False)
        
        # Enable all widgets in the new layout
        for i in range(new_layout.count()):
            widget = new_layout.itemAt(i).widget()
            if widget is not None:
                widget.setEnabled(True)

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
                if result is not None and result[0] == filter_.upper():
                    elem = [row[0], row[0]]
                    result_list.append(elem)
        if not result_list:
            self.dlg_qm.cmb_schema_org.clear()
            return

        tools_qt.fill_combo_values(self.dlg_qm.cmb_schema_org, result_list)

    def _load_user_values(self):
        """
        Load last selected user values
            :return: Dictionary with values
        """

        host = tools_gw.get_config_parser('i18n_generator', 'qm_lang_host', "user", "session", False)
        port = tools_gw.get_config_parser('i18n_generator', 'qm_lang_port', "user", "session", False)
        db = tools_gw.get_config_parser('i18n_generator', 'qm_lang_db', "user", "session", False)
        user = tools_gw.get_config_parser('i18n_generator', 'qm_lang_user', "user", "session", False)
        tools_qt.set_widget_text(self.dlg_qm, 'txt_host', host)
        tools_qt.set_widget_text(self.dlg_qm, 'txt_port', port)
        tools_qt.set_widget_text(self.dlg_qm, 'txt_db', db)
        tools_qt.set_widget_text(self.dlg_qm, 'txt_user', user) 

    def _check_connection(self):
        """ Check connection to database """

        self.dlg_qm.lbl_info.clear()
        self._close_db_org()
        # Connection with origin db
        host_i18n = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_host)
        port_i18n = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_port)
        db_i18n = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_db)
        user_i18n = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_user)
        password_i18n = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_pass)
        status_i18n = self._init_db_i18n(host_i18n, port_i18n, db_i18n, user_i18n, password_i18n)
        status_org = self._init_db_org()

        #Send messages
        if not status_i18n:
            self.dlg_qm.btn_update.setEnabled(False)
            self.dlg_qm.lbl_info.clear()
            tools_qt.show_info_box(f"Error connecting to i18n databse")
            QApplication.processEvents()
            return
        elif host_i18n != '188.245.226.42' and port_i18n != '5432' and db_i18n != 'giswater':
            self.dlg_qm.btn_update.setEnabled(False)
            self.dlg_qm.lbl_info.clear()
            tools_qt.show_info_box(f"Error connecting to i18n databse")
            QApplication.processEvents()
            return
        elif 'password authentication failed' in str(self.last_error):
            self.dlg_qm.btn_update.setEnabled(False)
            self.dlg_qm.lbl_info.clear()
            tools_qt.show_info_box(f"Incorrect user or password")
            QApplication.processEvents()
            return
        else:
            self.dlg_qm.btn_update.setEnabled(True)
            self.dlg_qm.lbl_info.clear()
            tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', f"Successful connection to {db_i18n} database")
            QApplication.processEvents()
        
        if not status_org:
            self.dlg_qm.btn_update.setEnabled(False)
            self.dlg_qm.lbl_info.clear()
            tools_qt.show_info_box(f"Error connecting to origin database")
            QApplication.processEvents()
            return
        elif 'password authentication failed' in str(self.last_error):
            self.dlg_qm.btn_update.setEnabled(False)
            self.dlg_qm.lbl_info.clear()
            tools_qt.show_info_box(f"Error connecting to origin database")
            QApplication.processEvents()
            return
        
    def _init_db_i18n(self, host, port, db, user, password):
        """Initializes database connection"""

        try:
            self.conn_i18n = psycopg2.connect(database=db, user=user, port=port, password=password, host=host)
            self.cursor_i18n = self.conn_i18n.cursor(cursor_factory=psycopg2.extras.DictCursor)
        
            return True
        except psycopg2.DatabaseError as e:
            self.last_error = e
            return False
    
    def _init_db_org(self):
        """Initializes database connection"""

        try:
            self.conn_org = tools_db.dao
            self.cursor_org = tools_db.dao.get_cursor()
            return True
        except psycopg2.DatabaseError as e:
            self.last_error = e
            return False

    def _close_db_org(self):
        """ Close database connection """

        try:
            if self.cursor_org:
                self.cursor_org.close()
            if self.conn_org:
                self.conn_org.close()
            del self.cursor_org
            del self.conn_org
        except Exception as e:
            self.last_error = e

    def _close_db_i18n(self):
        """ Close database connection """
        try:
            if self.cursor_i18n:
                self.cursor_i18n.close()
            if self.conn_i18n:
                self.conn_i18n.close()
            del self.cursor_i18n
            del self.conn_i18n
        except Exception as e:
            self.last_error = e
    
    def _save_user_values(self):
        """ Save selected user values """

        host = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_host, return_string_null=False)
        port = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_port, return_string_null=False)
        db = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_db, return_string_null=False)
        user = tools_qt.get_text(self.dlg_qm, self.dlg_qm.txt_user, return_string_null=False)
        py_msg = False
        db_msg = False
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_host', f"{host}", "user", "session", prefix=False)
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_port', f"{port}", "user", "session", prefix=False)
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_db', f"{db}", "user", "session", prefix=False)
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_user', f"{user}", "user", "session", prefix=False)
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_py_msg', f"{py_msg}", "user", "session", prefix=False)
        tools_gw.set_config_parser('i18n_generator', 'qm_lang_db_msg', f"{db_msg}", "user", "session", prefix=False)

    # endregion
    # region Missing DB Dialogs
    def missing_dialogs(self):
        self.check_for_repeated = tools_qt.is_checked(self.dlg_qm, self.dlg_qm.chk_search_for_repeated)
        tables = ["i18n_proves.dbparam_user", "i18n_proves.dbconfig_param_system", "i18n_proves.dbconfig_form_fields", "i18n_proves.dbconfig_typevalue", "i18n_proves.dbfprocess", "i18n_proves.dbmessage"]
        text_error = ''
        self.dlg_qm.lbl_info.clear()
        for table in tables:
            table_exists = self.detect_table_func(table)
            correct_lang = self._verify_lang()
            if table_exists:
                if correct_lang or not self.revise_lang:
                    text_error += self._update_tables(table)
                else:
                    tools_qt.show_info_box('Incorrect languages, make sure to have the giswater project in english')
                    break
            else:
                tools_qt.show_info_box(f"The table ({table}) does not exists")

            if self.check_for_repeated:
                text_error += self._update_project_type(table)
            self._vacuum_commit(table, self.conn_i18n, self.cursor_i18n)
            
        self.dlg_qm.lbl_info.clear()
        tools_qt.show_info_box(text_error)

    def _update_tables(self, table_i18n):
        table_org = self._find_table_org(table_i18n)
        self._change_table_lyt(table_i18n)
        query = ""
        
        if "sys_message" in table_org:
            query = self._update_dbmessage(table_i18n, table_org)
        elif "sys_fprocess" in table_org:
            query = self._update_dbfprocess(table_i18n, table_org)
        elif "config_form_fields" in table_org:
            query = self._update_config_form_fields(table_i18n, table_org)
        elif "sys_param_user" in table_org:
            query = self._update_sys_param_user(table_i18n, table_org)
        elif "config_param_system" in table_org:
            query = self._update_config_param_system(table_i18n, table_org)
        elif "config_typevalue" in table_org:
            query = self._update_config_typevalue(table_i18n, table_org)
        if query == '':
            return f'{table_i18n}: 1- No update needed. '
        else:
            try:
                self.cursor_i18n.execute(query)
                self.conn_i18n.commit()
                return f'{table_i18n}: 1- Succesfully translated table. '
            except Exception as e:
                self.conn_i18n.rollback()
                return f"An error occured while translating {table_i18n}: {e}\n"
            
    def _update_dbmessage(self, table_i18n, table_org):
        columns_i18n = "project_type, CAST(source AS INTEGER), CAST(log_level AS INTEGER), ms_en_us, ht_en_us"
        columns_org = "project_type, id, log_level, error_message, hint_message"
        query = f"SELECT {columns_i18n} FROM {table_i18n};"
        rows_i18n = self._get_rows(query, self.cursor_i18n)
        query = f"SELECT {columns_org} FROM {self.schema_org}.{table_org};"
        rows_org = self._get_rows(query, self.cursor_org)
        query = ""
        for row_i18n in rows_i18n:
            if row_i18n['ht_en_us'] == None:
                row_i18n['ht_en_us'] = ''
        for i, row_org in enumerate(rows_org):
            if row_org['hint_message'] == None:
                row_org['hint_message'] = ''
            if row_org not in rows_i18n:
                query_row = f"""INSERT INTO {table_i18n} (context, source_code, project_type, log_level, source, ms_en_us, ht_en_us) VALUES """
                query_row += f"""('{table_org}', 'giswater', '{row_org['project_type']}', '{row_org['log_level']}','{row_org['id']}', 
                            {f"'{row_org['error_message'].replace("'", "''")}'" if row_org['error_message'] not in [None, ''] else 'NULL'}, 
                            {f"'{row_org['hint_message'].replace("'", "''")}'" if row_org['hint_message'] not in [None, ''] else 'NULL'})"""
                query_row += " ON CONFLICT (source_code, project_type, context, log_level, source) DO UPDATE"
                query_row += f""" SET ms_en_us = {f"'{row_org['error_message'].replace("'", "''")}'" if row_org['error_message'] != '' or row_org['error_message'] == None else 'NULL'},
                            ht_en_us = {f"'{row_org['hint_message'].replace("'", "''")}'" if row_org['hint_message'] != '' or row_org['hint_message'] == None else 'NULL'}"""
                query_row += ";\n"
                query += query_row
        return query

    def _update_dbfprocess(self, table_i18n, table_org):
        columns_i18n = "project_type, CAST(source AS INTEGER), ex_en_us, in_en_us"
        columns_org = "project_type, fid, except_msg, info_msg"
        query = f"SELECT {columns_i18n} FROM {table_i18n};"
        rows_i18n = self._get_rows(query, self.cursor_i18n)
        query = f"SELECT {columns_org} FROM {self.schema_org}.{table_org};"
        rows_org = self._get_rows(query, self.cursor_org)
        query = ""
        for row_i18n in rows_i18n:
            if row_i18n['in_en_us'] == None:
                row_i18n['in_en_us'] = ''
        for i, row_org in enumerate(rows_org):
            if row_org['info_msg'] == None:
                row_org['info_msg'] = ''
            if row_org not in rows_i18n:
                query_row = f"""INSERT INTO {table_i18n} (context, project_type, source, ex_en_us, in_en_us) VALUES """
                query_row += f"""('{table_org}', '{row_org['project_type']}', '{row_org['fid']}', 
                            {f"'{row_org['except_msg'].replace("'", "''")}'" if row_org['except_msg'] not in [None, ''] else 'NULL'}, 
                            {f"'{row_org['info_msg'].replace("'", "''")}'" if row_org['info_msg'] not in [None, ''] else 'NULL'})"""
                query_row += " ON CONFLICT (project_type, context, source) DO UPDATE"
                query_row += f""" SET ex_en_us = {f"'{row_org['except_msg'].replace("'", "''")}'" if row_org['except_msg'] not in [None, ''] else 'NULL'},
                            in_en_us = {f"'{row_org['info_msg'].replace("'", "''")}'" if row_org['info_msg'] not in [None, ''] else 'NULL'}"""
                query_row += ";\n"
                query += query_row
        return query

    def _update_config_form_fields(self, table_i18n, table_org):
        columns_i18n = "formname, formtype, source, lb_en_us, tt_en_us, project_type"
        columns_org = "formname, formtype, columnname, label, tooltip"
        query = f"SELECT {columns_i18n} FROM {table_i18n};"
        rows_i18n = self._get_rows(query, self.cursor_i18n)
        query = f"SELECT {columns_org} FROM {self.schema_org}.{table_org};"
        rows_org = self._get_rows(query, self.cursor_org)
        query = ""
        for row_i18n in rows_i18n:
            if row_i18n['lb_en_us'] == None:
                row_i18n['lb_en_us'] = ''
            if row_i18n['tt_en_us'] == None:
                row_i18n['tt_en_us'] = ''
        for i, row_org in enumerate(rows_org):
            if row_org['label'] == None:
                row_org['label'] = ''
            if row_org['tooltip'] == None:
                row_org['tooltip'] = ''
            row_org_com = row_org
            row_org_com.append(self.project_type) 
            if row_org_com not in rows_i18n:
                query_row = f"""INSERT INTO {table_i18n} (context, source_code, project_type, source, formname, formtype, lb_en_us, tt_en_us) VALUES """
                query_row += f"""('{table_org}', 'giswater', '{self.project_type}', '{row_org['columnname']}', '{row_org['formname']}', '{row_org['formtype']}',
                        {f"'{row_org['label'].replace("'", "''")}'" if row_org['label'] not in [None, ''] else 'NULL'}, 
                        {f"'{row_org['tooltip'].replace("'", "''")}'" if row_org['tooltip'] not in [None, ''] else 'NULL'})"""
                query_row += " ON CONFLICT (context, source_code, project_type, source, formname, formtype) DO UPDATE"
                query_row += f""" SET lb_en_us = {f"'{row_org['label'].replace("'", "''")}'" if row_org['label'] not in [None, ''] else 'NULL'},
                            tt_en_us = {f"'{row_org['tooltip'].replace("'", "''")}'" if row_org['tooltip'] not in [None, ''] else 'NULL'}""" 
                query_row += ";\n"
                query += query_row
        return query

    def _update_sys_param_user(self, table_i18n, table_org):
        columns_i18n = "project_type, source, formname, lb_en_us, tt_en_us"
        columns_org = "project_type, id, formname, label, descript"

        query = f"SELECT {columns_i18n} FROM {table_i18n};"
        rows_i18n = self._get_rows(query, self.cursor_i18n)

        query = f"SELECT {columns_org} FROM {self.schema_org}.{table_org};"
        rows_org = self._get_rows(query, self.cursor_org)

        query = ""
        for row_i18n in rows_i18n:
            if row_i18n['lb_en_us'] is None:
                row_i18n['lb_en_us'] = ''
            if row_i18n['tt_en_us'] is None:
                row_i18n['tt_en_us'] = ''

        for i, row_org in enumerate(rows_org):
            if row_org['label'] is None:
                row_org['label'] = ''
            if row_org['descript'] is None:
                row_org['descript'] = ''

            # Check if the row from org doesn't exist in i18n, and construct the query
            if row_org not in rows_i18n:
                # Safely handle NULL values and avoid SQL injection
                label = f"'{row_org['label'].replace("'", "''")}'" if row_org['label'] not in [None, ''] else 'NULL'
                descript = f"'{row_org['descript'].replace("'", "''")}'" if row_org['descript'] not in [None, ''] else 'NULL'
                
                query_row = f"""INSERT INTO {table_i18n} (context, source_code, source, formname, project_type, lb_en_us, tt_en_us) 
                                VALUES ('{table_org}', 'giswater', '{row_org['id']}', '{row_org['formname']}', '{row_org['project_type']}',
                                {label}, {descript})
                                ON CONFLICT (context, source_code, project_type, source, formname) 
                                DO UPDATE SET lb_en_us = {label}, tt_en_us = {descript};\n"""
                query += query_row

        return query

    def _update_config_param_system(self, table_i18n, table_org):
        columns_i18n = "project_type, source, lb_en_us, tt_en_us"
        columns_org = "project_type, parameter, label, descript"
        query = f"SELECT {columns_i18n} FROM {table_i18n};"
        rows_i18n = self._get_rows(query, self.cursor_i18n)
        query = f"SELECT {columns_org} FROM {self.schema_org}.{table_org};"
        rows_org = self._get_rows(query, self.cursor_org)
        query = ""
        for row_i18n in rows_i18n:
            if row_i18n['lb_en_us'] == None:
                row_i18n['lb_en_us'] = ''
            if row_i18n['tt_en_us'] == None:
                row_i18n['tt_en_us'] = ''
        for i, row_org in enumerate(rows_org):
            if row_org['label'] == None:
                row_org['label'] = ''
            if row_org['descript'] == None:
                row_org['descript'] = ''  
            if row_org not in rows_i18n:
                query_row = f"""INSERT INTO {table_i18n} (context, source_code, project_type, source, lb_en_us, tt_en_us) VALUES """
                query_row += f"""('{table_org}', 'giswater', '{row_org['project_type']}', '{row_org['parameter']}',
                        {f"'{row_org['label'].replace("'", "''")}'" if row_org['label'] not in [None, ''] else 'NULL'}, 
                        {f"'{row_org['descript'].replace("'", "''")}'" if row_org['descript'] not in [None, ''] else 'NULL'})"""
                query_row += " ON CONFLICT (context, source_code, project_type, source) DO UPDATE"
                query_row += f""" SET lb_en_us = {f"'{row_org['label'].replace("'", "''")}'" if row_org['label'] not in [None, ''] else 'NULL'},
                            tt_en_us = {f"'{row_org['descript'].replace("'", "''")}'" if row_org['descript'] not in [None, ''] else 'NULL'}"""
                query_row += ";\n"
                query += query_row
        return query

    def _update_config_typevalue(self, table_i18n, table_org):
        columns_i18n = "formname, source, tt_en_us"
        columns_org = "typevalue, id, idval"
        query = f"SELECT {columns_i18n} FROM {table_i18n};"
        rows_i18n = self._get_rows(query, self.cursor_i18n)
        query = f"SELECT {columns_org} FROM {self.schema_org}.{table_org};"
        rows_org = self._get_rows(query, self.cursor_org)
        query = ""
        for row_i18n in rows_i18n:
            if row_i18n['tt_en_us'] == None:
                row_i18n['tt_en_us'] = ''
        for i, row_org in enumerate(rows_org):
            if row_org['idval'] == None:
                row_org['idval'] = ''
        for row_org in rows_org:  
            if row_org not in rows_i18n:
                query_row = f"""INSERT INTO {table_i18n} (context, source_code, project_type, source, formname, formtype, tt_en_us) VALUES """
                query_row += f"""('{table_org}', 'giswater', '{self.project_type}', '{row_org['id']}', '{row_org['typevalue']}', 'form_feature',
                        {f"'{row_org['idval'].replace("'", "''")}'" if row_org['idval'] not in [None, ''] else 'NULL'})"""
                query_row += " ON CONFLICT (context, source_code, project_type, source, formname, formtype) DO UPDATE"
                query_row += f""" SET tt_en_us = {f"'{row_org['idval'].replace("'", "''")}'" if row_org['idval'] not in [None, ''] else 'NULL'}"""
                query_row += ";\n"
                query += query_row
        return query
    
    def _verify_lang(self):
        query = f"SELECT language from {self.schema_org}.sys_version"
        self.cursor_org.execute(query)
        language_org = self.cursor_org.fetchone()[0]
        if language_org != 'en_US':
            return False
        return True
    
    #endregion
    # region Rewrite Project_type
    def _update_project_type(self, table):
        """Function to rewrite the repeated rows with different project_type to only one with project_type = 'utils'"""

        # Step 1: Determine column names
        try:
            self._detect_column_names(table)
        except Exception as e:
            return f"Error deleting rows: {e}"

        # Step 2: Get the duplicated rows
        query = self._get_duplicates_rows(table)
        try:
            self.cursor_i18n.execute(query)
            initial_rows = self.cursor_i18n.fetchall()
        except Exception as e:
            return f"Error deleting rows: {e}"

        # Step 3: Create the rows with the correct project_type
        final_rows = []
        primary_rows = []
        final_rows_no_utils = []
        for row in initial_rows:
            primary_row = [row[primary_key] for primary_key in self.primary_keys if primary_key != 'project_type']
            if row['project_type'] in ['ws', 'ud', 'utils']:
                if primary_row not in primary_rows:
                    final_rows.append(row)
                    primary_rows.append(primary_row)
            elif row['project_type'] not in [None, 'None', '']:
                final_rows_no_utils.append(row)

        # Step 4: Delete the initial rows that are duplicates (those that will be replaced by final_rows)
        delete_query = self._delete_duplicates_rows(table)
        try:
            self.cursor_i18n.execute(delete_query)
            self.conn_i18n.commit()  # Commit the deletion
        except Exception as e:
            self.conn_i18n.rollback()  # Rollback in case of error
            return f"Error deleting rows: {e}"

        # Step 5: Insert the unique final rows back into the table
        final_rows_tot = final_rows + final_rows_no_utils if final_rows_no_utils else final_rows
        insert_query = self._add_duplicates_rows(table, final_rows_tot, final_rows)
        if insert_query == "":
            return "No rows to unify"
        try:
            self.cursor_i18n.execute(insert_query)
        except Exception as e:
            self.conn_i18n.rollback()  # Rollback in case of error
            return f"Error inserting rows: {e}"

        self.conn_i18n.commit()  # Commit the insertions
        return f"2- Rows updated successfully.\n"
    
    def _get_duplicates_rows(self, table):
        """Create query to determine the duplicated rows"""

        query = f"""WITH duplicates AS (
                SELECT """
        query += ", ".join([primary_key for primary_key in self.primary_keys if primary_key != 'project_type'])
        query += f""", COUNT(*) AS duplicate_count
                FROM {table}
                GROUP BY """
        query += ", ".join([primary_key for primary_key in self.primary_keys if primary_key != 'project_type'])
        query += f"""\nHAVING COUNT(*) > 1
            )
            SELECT t.*, d.duplicate_count
            FROM {table} t
            JOIN duplicates d
            ON 
        """
        query += "AND ".join([f"""t.{primary_key} = d.{primary_key} """ for primary_key in self.primary_keys if primary_key != 'project_type'])
        query += """ORDER BY source, duplicate_count DESC;"""
        return query
    
    def _delete_duplicates_rows(self, table):
        """Create query to delete the duplicated rows"""

        delete_query = """
            WITH duplicates AS (
                SELECT """ 
        delete_query += ", ".join([primary_key for primary_key in self.primary_keys if primary_key != 'project_type'])
        delete_query += f""", COUNT(*) AS duplicate_count
                FROM {table}
                GROUP BY """
        delete_query += ", ".join([primary_key for primary_key in self.primary_keys if primary_key != 'project_type'])
        delete_query += f"""\nHAVING COUNT(*) > 1
            )
            DELETE FROM {table} WHERE ("""
        delete_query += ", ".join([primary_key for primary_key in self.primary_keys if primary_key != 'project_type'])
        delete_query +=""") IN (SELECT """
        delete_query += ", ".join([primary_key for primary_key in self.primary_keys if primary_key != 'project_type'])
        delete_query +="""  FROM duplicates);"""
        return delete_query
    
    def _add_duplicates_rows(self, table, final_rows_tot, final_rows):
        """Create query to add the correct rows to the table"""

        insert_query = ""
        for k, row in enumerate(final_rows_tot):
            row_keys = list(row.keys())[:-1]
            if k < len(final_rows):
                row_keys.remove('project_type')
            insert_query += f"INSERT INTO {table} ("
            
            # Handle columns (keys)
            insert_query += ", ".join([row_key for row_key in row_keys])
            insert_query += ", project_type) VALUES ("
            
            values = []
            for row_key in row_keys:
                value = row[row_key]
                if isinstance(value, str):  
                    value = f"'{value.replace('\'', '\'\'')}'"  # Escape single quotes in strings
                elif isinstance(value, (datetime, date)):  # Handle timestamps properly
                    value = f"'{value.strftime('%Y-%m-%d %H:%M:%S')}'"
                elif value in [None, 'None', '']:
                    value = "Null"
                else:
                    value = str(value)  # Convert other types directly
                values.append(value)
            # Add processed values to query
            insert_query += ", ".join(values)
            insert_query += ", 'utils');\n" if k < len(final_rows) else ");\n"
        return insert_query

    #endregion
    # region Global funcitons
    def detect_table_func(self, table):
        self.cursor_i18n.execute(f"SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '{table.split('.')[0]}' AND table_name = '{table.split('.')[1]}';")
        result = self.cursor_i18n.fetchone()
        existing_table = result[0] > 0  # Check if count is greater than 0
        return existing_table
    
    def _find_table_org(self, table_i18n):
        query = f'SELECT * FROM {table_i18n}'
        rows = self._get_rows(query, self.cursor_i18n)
        table_org = rows[0]['context']
        if not table_org:
            return False
        return table_org
    
    def _get_rows(self, sql, cursor, commit=True):
        """ Get multiple rows from selected query """
        last_error = None
        rows = None
        try:
            cursor.execute(sql)
            rows = cursor.fetchall()
            if commit:
                cursor._commit()
        except Exception as e:
            last_error = e
            if commit:
                cursor._rollback()
        finally:
            return rows
        
    def _vacuum_commit(self, table, conn, cursor):
        old_isolation_level = conn.isolation_level
        conn.set_isolation_level(0)
        cursor.execute(f"VACUUM FULL {table};")
        cursor.execute(f"ANALYZE {table};")
        conn.set_isolation_level(old_isolation_level)

    def _change_table_lyt(self, table):
        # Update the part the of the program in process
        self.dlg_qm.lbl_info.clear()
        msg = f"Updating {table}..."
        tools_qt.set_widget_text(self.dlg_qm, 'lbl_info', msg)
        QApplication.processEvents()

    def _detect_column_names(self, table):
        query = f"""
            SELECT a.attname AS column_name
            FROM pg_index i
            JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey)
            WHERE i.indrelid = '{table}'::regclass
            AND i.indisprimary;
            """
            
        self.cursor_i18n.execute(query)
        results = self.cursor_i18n.fetchall()
        self.primary_keys = [row['column_name'] for row in results]
    #endregion