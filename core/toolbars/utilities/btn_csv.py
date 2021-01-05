"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import csv
import json
import os
from functools import partial

from qgis.PyQt.QtGui import QStandardItem, QStandardItemModel
from qgis.PyQt.QtWidgets import QFileDialog

from ..parent_dialog import GwParentAction
from ...ui.ui_manager import Csv2pgUi
from ...utils import tools_gw
from .... import global_vars
from ....lib import tools_qt, tools_log, tools_db, tools_qgis


class GwCSVButton(GwParentAction):

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        super().__init__(icon_path, action_name, text, toolbar, action_group)


    def clicked_event(self):

        self.func_name = None
        self.dlg_csv = Csv2pgUi()
        tools_gw.load_settings(self.dlg_csv)

        # Get roles from BD
        roles = self.get_rolenames()
        temp_tablename = 'temp_csv'
        tools_qt.populate_cmb_unicodes(self.dlg_csv.cmb_unicode_list)
        self.populate_combos(self.dlg_csv.cmb_import_type, 'fid',
                             'alias, config_csv.descript, functionname, readheader, orderby', 'config_csv', roles)

        self.dlg_csv.lbl_info.setWordWrap(True)
        tools_qt.set_widget_text(self.dlg_csv, self.dlg_csv.cmb_unicode_list, 'utf8')
        self.dlg_csv.rb_comma.setChecked(False)
        self.dlg_csv.rb_semicolon.setChecked(True)

        # Signals
        self.dlg_csv.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_csv))
        self.dlg_csv.rejected.connect(partial(tools_gw.close_dialog, self.dlg_csv))
        self.dlg_csv.btn_accept.clicked.connect(partial(self.write_csv, self.dlg_csv, temp_tablename))
        self.dlg_csv.cmb_import_type.currentIndexChanged.connect(partial(self.update_info, self.dlg_csv))
        self.dlg_csv.cmb_import_type.currentIndexChanged.connect(partial(self.get_function_name))
        self.dlg_csv.btn_file_csv.clicked.connect(partial(self.select_file_csv))
        self.dlg_csv.cmb_unicode_list.currentIndexChanged.connect(partial(self.preview_csv, self.dlg_csv))
        self.dlg_csv.rb_comma.clicked.connect(partial(self.preview_csv, self.dlg_csv))
        self.dlg_csv.rb_semicolon.clicked.connect(partial(self.preview_csv, self.dlg_csv))
        self.get_function_name()
        self.load_settings_values()

        if str(tools_qt.get_text(self.dlg_csv, self.dlg_csv.txt_file_csv)) != 'null':
            self.preview_csv(self.dlg_csv)
        self.dlg_csv.progressBar.setVisible(False)

        # Open dialog
        tools_gw.open_dialog(self.dlg_csv, dlg_name='csv')


    def populate_combos(self, combo, field_id, fields, table_name, roles):

        if roles is None:
            return

        sql = (f"SELECT DISTINCT({field_id}), {fields}"
               f" FROM {table_name}"
               f" JOIN sys_function ON function_name =  functionname"
               f" WHERE sys_role IN {roles} AND active is True ORDER BY orderby")
        rows = tools_db.get_rows(sql)
        if not rows:
            message = "You do not have permission to execute this application"
            self.dlg_csv.lbl_info.setText(tools_qt.tr(message, aux_context='ui_message'))
            self.dlg_csv.lbl_info.setStyleSheet("QLabel{color: red;}")

            self.dlg_csv.cmb_import_type.setEnabled(False)
            self.dlg_csv.txt_import.setEnabled(False)
            self.dlg_csv.txt_file_csv.setEnabled(False)
            self.dlg_csv.cmb_unicode_list.setEnabled(False)
            self.dlg_csv.rb_comma.setEnabled(False)
            self.dlg_csv.rb_semicolon.setEnabled(False)
            self.dlg_csv.btn_file_csv.setEnabled(False)
            self.dlg_csv.tbl_csv.setEnabled(False)
            self.dlg_csv.btn_accept.setEnabled(False)
            return


        tools_qt.fill_combo_values(combo, rows, 1, True, True, 1)
        self.update_info(self.dlg_csv)


    def write_csv(self, dialog, temp_tablename):
        """ Write csv in postgres and call gw_fct_utils_csv2pg function """
        self.save_settings_values()
        insert_status = True
        if not self.validate_params(dialog):
            return

        fid_aux = tools_qt.get_combo_value(dialog, dialog.cmb_import_type, 0)
        self.delete_table_csv(temp_tablename, fid_aux)
        path = tools_qt.get_text(dialog, dialog.txt_file_csv)
        label_aux = tools_qt.get_text(dialog, dialog.txt_import, return_string_null=False)
        delimiter = self.get_delimiter(dialog)
        _unicode = tools_qt.get_text(dialog, dialog.cmb_unicode_list)

        try:
            with open(path, 'r', encoding=_unicode) as csvfile:
                insert_status = self.insert_into_db(dialog, csvfile, delimiter, _unicode)
                csvfile.close()
                del csvfile
        except Exception as e:
            tools_qgis.show_warning("EXCEPTION: " + str(e))

        if insert_status is False:
            return

        extras = f'"importParam":"{label_aux}"'
        extras += f', "fid":"{fid_aux}"'
        body = tools_gw.create_body(extras=extras)

        result = tools_gw.get_json(self.func_name, body)
        if not result:
            return
        else:
            if result['status'] == "Accepted":
                tools_gw.fill_tab_log(dialog, result['body']['data'])
            msg = result['message']['text']
            tools_qt.show_info_box(msg)


    def update_info(self, dialog):
        """ Update the tag according to item selected from cmb_import_type """

        dialog.lbl_info.setText(tools_qt.get_combo_value(self.dlg_csv, self.dlg_csv.cmb_import_type, 2))


    def get_function_name(self):

        self.func_name = tools_qt.get_combo_value(self.dlg_csv, self.dlg_csv.cmb_import_type, 3)
        tools_log.log_info(str(self.func_name))


    def select_file_csv(self):
        """ Select CSV file """

        file_csv = tools_qt.get_text(self.dlg_csv, 'txt_file_csv')
        # Set default value if necessary
        if file_csv is None or file_csv == '':
            file_csv = global_vars.plugin_dir
        # Get directory of that file
        folder_path = os.path.dirname(file_csv)
        if not os.path.exists(folder_path):
            folder_path = os.path.dirname(__file__)
        os.chdir(folder_path)
        message = tools_qt.tr("Select CSV file", aux_context='ui_message')
        file_csv, filter_ = QFileDialog.getOpenFileName(None, message, "", '*.csv')
        tools_qt.set_widget_text(self.dlg_csv, self.dlg_csv.txt_file_csv, file_csv)

        self.save_settings_values()
        self.preview_csv(self.dlg_csv)


    def preview_csv(self, dialog):
        """ Show current file in QTableView acorrding to selected delimiter and unicode """

        path = self.get_path(dialog)
        if path is None:
            return

        delimiter = self.get_delimiter(dialog)
        model = QStandardItemModel()
        _unicode = tools_qt.get_text(dialog, dialog.cmb_unicode_list)
        dialog.tbl_csv.setModel(model)
        dialog.tbl_csv.horizontalHeader().setStretchLastSection(True)

        try:
            with open(path, "r", encoding=_unicode) as file_input:
                self.read_csv_file(model, file_input, delimiter, _unicode)
        except Exception as e:
            tools_qgis.show_warning(str(e))


    def load_settings_values(self):
        """ Load QGIS settings related with csv options """

        value = tools_gw.get_config_parser('btn_csv2pg', 'cmb_import_type', "user", "sessions")
        tools_qt.set_combo_value(self.dlg_csv.cmb_import_type, value, 0)

        value = tools_gw.get_config_parser('btn_csv2pg', 'txt_import', "user", "sessions")
        tools_qt.set_widget_text(self.dlg_csv, self.dlg_csv.txt_import, value)

        value = tools_gw.get_config_parser('btn_csv2pg', 'txt_file_csv', "user", "sessions")
        tools_qt.set_widget_text(self.dlg_csv, self.dlg_csv.txt_file_csv, value)

        unicode = tools_gw.get_config_parser('btn_csv2pg', 'cmb_unicode_list', "user", "sessions")
        if not unicode:
            unicode = 'latin1'
        tools_qt.set_widget_text(self.dlg_csv, self.dlg_csv.cmb_unicode_list, unicode)

        if tools_gw.get_config_parser('btn_csv2pg', 'rb_semicolon', "user", "sessions") == 'True':
            self.dlg_csv.rb_semicolon.setChecked(True)
        else:
            self.dlg_csv.rb_comma.setChecked(True)


    def save_settings_values(self):
        """ Save QGIS settings related with csv options """
        tools_gw.set_config_parser('btn_csv2pg', 'cmb_import_type', f"{tools_qt.get_combo_value(self.dlg_csv, 'cmb_import_type', 0)}")
        tools_gw.set_config_parser('btn_csv2pg', 'txt_import', tools_qt.get_text(self.dlg_csv, 'txt_import'))
        tools_gw.set_config_parser('btn_csv2pg', 'txt_file_csv', tools_qt.get_text(self.dlg_csv, 'txt_file_csv'))
        tools_gw.set_config_parser('btn_csv2pg', 'cmb_unicode_list', tools_qt.get_text(self.dlg_csv, 'cmb_unicode_list'))
        tools_gw.set_config_parser('btn_csv2pg', 'rb_semicolon', f"{self.dlg_csv.rb_semicolon.isChecked()}")


    def validate_params(self, dialog):
        """ Validate if params are valids """

        path = self.get_path(dialog)
        self.preview_csv(dialog)
        if path is None or path == 'null':
            return False
        return True


    def delete_table_csv(self, temp_tablename, fid_aux):
        """ Delete records from temp_csv for current user and selected cat """

        sql = (f"DELETE FROM {temp_tablename} "
               f"WHERE fid = '{fid_aux}' AND cur_user = current_user")
        tools_db.execute_sql(sql)


    def get_delimiter(self, dialog):

        delimiter = ';'
        if dialog.rb_semicolon.isChecked():
            delimiter = ';'
        elif dialog.rb_comma.isChecked():
            delimiter = ','
        return delimiter


    def insert_into_db(self, dialog, csvfile, delimiter, _unicode):

        progress = 0
        dialog.progressBar.setVisible(True)
        dialog.progressBar.setValue(progress)
        # Counts rows in csvfile, using var "row_count" to do progressbar
        # noinspection PyUnusedLocal
        row_count = sum(1 for rows in csvfile)
        if row_count > 20:
            row_count -= 20  # -20 for see 100% complete progress
        dialog.progressBar.setMaximum(100)
        csvfile.seek(0)  # Position the cursor at position 0 of the file
        reader = csv.reader(csvfile, delimiter=delimiter,)
        fid_aux = tools_qt.get_combo_value(dialog, dialog.cmb_import_type, 0)
        readheader = tools_qt.get_combo_value(dialog, dialog.cmb_import_type, 4)
        fields = []
        cont = 1
        for row in reader:
            field = {'fid': fid_aux}
            if readheader is False:
                readheader = True
                continue

            for x in range(0, len(row)):
                value = row[x].strip().replace("\n", "")
                field[f"csv{x + 1}"] = f"{value}"
            fields.append(field)
            cont += 1
            progress = (100*cont)/row_count
            dialog.progressBar.setValue(progress)
        dialog.progressBar.setValue(100)
        if not fields: return False

        values = f'"values":{(json.dumps(fields, ensure_ascii=False).encode(_unicode)).decode()}'
        body = tools_gw.create_body(extras=values)
        result = tools_gw.get_json('gw_fct_copy_to_temp_csv', body)

        if 'status' in result and result['status'] == 'Accepted':
            return True

        return False


    def get_path(self, dialog):
        """ Take the file path if exist. AND if not exit ask it """

        path = tools_qt.get_text(dialog, dialog.txt_file_csv)
        if path is None or path == 'null' or not os.path.exists(path):
            message = "Please choose a valid path"
            tools_qgis.show_message(message, message_level=0)
            return None
        if path.find('.csv') == -1:
            message = "Please choose a csv file"
            tools_qgis.show_message(message, message_level=0)
            return None

        return path


    def read_csv_file(self, model, file_input, delimiter, _unicode):

        rows = csv.reader(file_input, delimiter=delimiter)
        for row in rows:
            unicode_row = [x for x in row]
            items = [QStandardItem(field) for field in unicode_row]
            model.appendRow(items)


    def get_rolenames(self):
        """ Get list of rolenames of current user """

        super_users = tools_gw.get_config_parser('system', 'super_users', "project", "init")
        if global_vars.session_vars['current_user'] in super_users:
            roles = "('role_admin', 'role_basic', 'role_edit', 'role_epa', 'role_master', 'role_om')"
        else:
            sql = ("SELECT rolname FROM pg_roles "
                   " WHERE pg_has_role(current_user, oid, 'member')")
            rows = tools_db.get_rows(sql)
            if not rows:
                return None

            roles = "("
            for i in range(0, len(rows)):
                roles += "'" + str(rows[i][0]) + "', "
            roles = roles[:-2]
            roles += ")"

        return roles