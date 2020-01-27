"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-

from qgis.PyQt.QtGui import QStandardItem, QStandardItemModel
from qgis.PyQt.QtWidgets import QFileDialog

import csv
import json
import os
from collections import OrderedDict
from encodings.aliases import aliases
from functools import partial

from .. import utils_giswater
from .api_config import ApiConfig
from .api_manage_composer import ApiManageComposer
from .gw_toolbox import GwToolBox
from .parent import ParentAction
from .manage_visit import ManageVisit
from ..ui_manager import Csv2Pg


class Utils(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'om_ws' """

        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        
        self.manage_visit = ManageVisit(iface, settings, controller, plugin_dir)
        self.toolbox = GwToolBox(iface, settings, controller, plugin_dir)


    def set_project_type(self, project_type):
        self.project_type = project_type


    def api_config(self):

        self.config = ApiConfig(self.iface, self.settings, self.controller, self.plugin_dir)
        self.config.api_config()


    def utils_import_csv(self):
        """ Button 83: Import CSV """

        self.func_name  = None
        self.dlg_csv = Csv2Pg()
        self.load_settings(self.dlg_csv)
        # Get roles from BD
        roles = self.controller.get_rolenames()
        temp_tablename = 'temp_csv2pg'
        self.populate_cmb_unicodes(self.dlg_csv.cmb_unicode_list)
        self.populate_combos(self.dlg_csv.cmb_import_type, 'id', 'name_i18n, csv_structure, functionname, readheader', 'sys_csv2pg_cat', roles)

        self.dlg_csv.lbl_info.setWordWrap(True)
        utils_giswater.setWidgetText(self.dlg_csv, self.dlg_csv.cmb_unicode_list, 'utf8')
        self.dlg_csv.rb_comma.setChecked(False)
        self.dlg_csv.rb_semicolon.setChecked(True)

        # Signals
        self.dlg_csv.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_csv))
        self.dlg_csv.rejected.connect(partial(self.close_dialog, self.dlg_csv))
        self.dlg_csv.btn_accept.clicked.connect(partial(self.write_csv, self.dlg_csv, temp_tablename))
        self.dlg_csv.cmb_import_type.currentIndexChanged.connect(partial(self.update_info, self.dlg_csv))
        self.dlg_csv.cmb_import_type.currentIndexChanged.connect(partial(self.get_function_name))
        self.dlg_csv.btn_file_csv.clicked.connect(partial(self.select_file_csv))
        self.dlg_csv.cmb_unicode_list.currentIndexChanged.connect(partial(self.preview_csv, self.dlg_csv))
        self.dlg_csv.rb_comma.clicked.connect(partial(self.preview_csv, self.dlg_csv))
        self.dlg_csv.rb_semicolon.clicked.connect(partial(self.preview_csv, self.dlg_csv))
        self.get_function_name()
        self.load_settings_values()

        if str(utils_giswater.getWidgetText(self.dlg_csv, self.dlg_csv.txt_file_csv)) != 'null':
            self.preview_csv(self.dlg_csv)
        self.dlg_csv.progressBar.setVisible(False)

        # Open dialog
        self.open_dialog(self.dlg_csv)


    def get_function_name(self):

        self.func_name = utils_giswater.get_item_data(self.dlg_csv, self.dlg_csv.cmb_import_type, 3)
        self.controller.log_info(str(self.func_name))


    def populate_cmb_unicodes(self, combo):
        """ Populate combo with full list of codes """

        unicode_list = []
        for item in list(aliases.items()):
            unicode_list.append(str(item[0]))
            sorted_list = sorted(unicode_list, key=str.lower)
        utils_giswater.set_autocompleter(combo, sorted_list)


    def update_info(self, dialog):
        """ Update the tag according to item selected from cmb_import_type """

        dialog.lbl_info.setText(utils_giswater.get_item_data(self.dlg_csv, self.dlg_csv.cmb_import_type, 2))


    def load_settings_values(self):
        """ Load QGIS settings related with csv options """

        cur_user = self.controller.get_current_user()
        utils_giswater.setWidgetText(self.dlg_csv, self.dlg_csv.txt_file_csv,
            self.controller.plugin_settings_value('Csv2Pg_txt_file_csv_' + cur_user))

        unicode = self.controller.plugin_settings_value('Csv2Pg_cmb_unicode_list_' + cur_user)
        if not unicode:
            unicode = 'latin1'
        utils_giswater.setWidgetText(self.dlg_csv, self.dlg_csv.cmb_unicode_list, unicode)
        
        if str(self.controller.plugin_settings_value('Csv2Pg_rb_comma_' + cur_user)).upper() == 'TRUE':
            self.dlg_csv.rb_comma.setChecked(True)
        else:
            self.dlg_csv.rb_semicolon.setChecked(True)


    def save_settings_values(self):
        """ Save QGIS settings related with csv options """

        cur_user = self.controller.get_current_user()
        self.controller.plugin_settings_set_value("Csv2Pg_txt_file_csv_" + cur_user,
            utils_giswater.getWidgetText(self.dlg_csv, 'txt_file_csv'))
        self.controller.plugin_settings_set_value("Csv2Pg_cmb_unicode_list_" + cur_user,
            utils_giswater.getWidgetText(self.dlg_csv, 'cmb_unicode_list'))
        self.controller.plugin_settings_set_value("Csv2Pg_rb_comma_" + cur_user,
            bool(self.dlg_csv.rb_comma.isChecked()))
        self.controller.plugin_settings_set_value("Csv2Pg_rb_semicolon_" + cur_user,
            bool(self.dlg_csv.rb_semicolon.isChecked()))


    def validate_params(self, dialog):
        """ Validate if params are valids """

        label_aux = utils_giswater.getWidgetText(dialog, dialog.txt_import)
        path = self.get_path(dialog)
        self.preview_csv(dialog)
        if path is None or path == 'null':
            return False
        return True


    def get_path(self, dialog):
        """ Take the file path if exist. AND if not exit ask it """

        path = utils_giswater.getWidgetText(dialog, dialog.txt_file_csv)
        if path is None or path == 'null' or not os.path.exists(path):
            message = "Please choose a valid path"
            self.controller.show_message(message, message_level=0)
            return None
        if path.find('.csv') == -1:
            message = "Please choose a csv file"
            self.controller.show_message(message, message_level=0)
            return None

        return path


    def get_delimiter(self, dialog):

        delimiter = ';'
        if dialog.rb_semicolon.isChecked():
            delimiter = ';'
        elif dialog.rb_comma.isChecked():
            delimiter = ','
        return delimiter


    def preview_csv(self, dialog):
        """ Show current file in QTableView acorrding to selected delimiter and unicode """

        path = self.get_path(dialog)
        if path is None:
            return

        delimiter = self.get_delimiter(dialog)
        model = QStandardItemModel()
        _unicode = utils_giswater.getWidgetText(dialog, dialog.cmb_unicode_list)
        dialog.tbl_csv.setModel(model)
        dialog.tbl_csv.horizontalHeader().setStretchLastSection(True)

        try:
            with open(path, "r", encoding=_unicode) as file_input:
                self.read_csv_file(model, file_input, delimiter, _unicode)
        except Exception as e:
            self.controller.show_warning(str(e))


    def read_csv_file(self, model, file_input, delimiter, _unicode):

        rows = csv.reader(file_input, delimiter=delimiter)
        for row in rows:
            unicode_row = [x for x in row]
            items = [QStandardItem(field) for field in unicode_row]
            model.appendRow(items)


    def delete_table_csv(self, temp_tablename, csv2pgcat_id_aux):
        """ Delete records from temp_csv2pg for current user and selected cat """

        sql = (f"DELETE FROM {temp_tablename} "
               f"WHERE csv2pgcat_id = '{csv2pgcat_id_aux}' AND user_name = current_user")
        self.controller.execute_sql(sql, log_sql=True)


    def write_csv(self, dialog, temp_tablename):
        """ Write csv in postgre and call gw_fct_utils_csv2pg function """

        insert_status = True
        if not self.validate_params(dialog):
            return

        csv2pgcat_id_aux = utils_giswater.get_item_data(dialog, dialog.cmb_import_type, 0)
        self.delete_table_csv(temp_tablename, csv2pgcat_id_aux)
        path = utils_giswater.getWidgetText(dialog, dialog.txt_file_csv)
        label_aux = utils_giswater.getWidgetText(dialog, dialog.txt_import, return_string_null=False)
        delimiter = self.get_delimiter(dialog)
        _unicode = utils_giswater.getWidgetText(dialog, dialog.cmb_unicode_list)

        try:
            with open(path, 'r', encoding=_unicode) as csvfile:
                insert_status = self.insert_into_db(dialog, csvfile, delimiter, _unicode)
                csvfile.close()
                del csvfile
        except Exception as e:
            self.controller.show_warning("EXCEPTION: " + str(e))

        self.save_settings_values()
        if insert_status is False:
            return

        extras = f'"importParam":"{label_aux}"'
        extras += f', "csv2pgCat":"{csv2pgcat_id_aux}"'
        body = self.create_body(extras=extras)
        sql = ("SELECT " + str(self.func_name) + "($${" + body + "}$$)::text")
        row = self.controller.get_row(sql, log_sql=True, commit=True)
        if not row:
            self.controller.show_warning("NOT ROW FOR: " + sql)
            message = "Import failed"
            self.controller.show_info_box(message)
            return
        else:
            complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]
            if complet_result[0]['status'] == "Accepted":
                self.populate_info_text(dialog, complet_result[0]['body']['data'])
            message = complet_result[0]['message']['text']
            self.controller.show_info_box(message)


    def insert_into_db(self, dialog, csvfile, delimiter, _unicode):

        sql = ""
        progress = 0
        dialog.progressBar.setVisible(True)
        dialog.progressBar.setValue(progress)
        # counts rows in csvfile, using var "row_count" to do progressbar
        row_count = sum(1 for rows in csvfile)  # @UnusedVariable
        if row_count > 20:
            row_count -= 20
        dialog.progressBar.setMaximum(row_count)  # -20 for see 100% complete progress
        csvfile.seek(0)  # Position the cursor at position 0 of the file
        reader = csv.reader(csvfile, delimiter=delimiter)
        csv2pgcat_id_aux = utils_giswater.get_item_data(dialog, dialog.cmb_import_type, 0)
        readheader = utils_giswater.get_item_data(dialog, dialog.cmb_import_type, 4)
        for row in reader:
            if readheader is False:
                readheader = True
                continue
            if len(row) > 0:
                sql += "INSERT INTO temp_csv2pg (csv2pgcat_id, "
                values = f"VALUES({csv2pgcat_id_aux}, "
                for x in range(0, len(row)):
                        sql += f"csv{x + 1}, "
                        value = f"$$" + row[x].strip().replace("\n", "") + "$$, "
                        value = str(value)
                        values += value.replace("$$$$", "null")
                sql = sql[:-2] + ") "
                values = values[:-2] + ");\n"
                sql += values
                progress += 1
            dialog.progressBar.setValue(progress)

            if progress % 500 == 0:
                status = self.controller.execute_sql(sql, commit=True)
                if not status:
                    return False
                sql = ""
        if sql != "":
            status = self.controller.execute_sql(sql, commit=True)
            if not status:
                return False

        return True


    def populate_combos(self, combo, field_id, fields, table_name, roles):

        if roles is None:
            return

        sql = (f"SELECT DISTINCT({field_id}), {fields}"
               f" FROM {table_name}"
               f" WHERE sys_role IN {roles} AND formname='importcsv' AND isdeprecated is not True")
        rows = self.controller.get_rows(sql, log_sql=True)
        if not rows:
            message = "You do not have permission to execute this application"
            self.dlg_csv.lbl_info.setText(self.controller.tr(message))
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


        utils_giswater.set_item_data(combo, rows, 1, True, True, 1)
        self.update_info(self.dlg_csv)


    def select_file_csv(self):
        """ Select CSV file """

        file_csv = utils_giswater.getWidgetText(self.dlg_csv, 'txt_file_csv')
        # Set default value if necessary
        if file_csv is None or file_csv == '':
            file_csv = self.plugin_dir
        # Get directory of that file
        folder_path = os.path.dirname(file_csv)
        if not os.path.exists(folder_path):
            folder_path = os.path.dirname(__file__)
        os.chdir(folder_path)
        message = self.controller.tr("Select CSV file")
        file_csv, filter_ = QFileDialog.getOpenFileName(None, message, "", '*.csv')
        utils_giswater.setWidgetText(self.dlg_csv, self.dlg_csv.txt_file_csv, file_csv)

        self.save_settings_values()
        self.preview_csv(self.dlg_csv)


    def insert_selector_audit(self, fprocesscat_id):
        """ Insert @fprocesscat_id for current_user in table 'selector_audit' """

        tablename = "selector_audit"
        sql = (f"SELECT * FROM {tablename} "
               f"WHERE fprocesscat_id = {fprocesscat_id} AND cur_user = current_user;")
        row = self.controller.get_row(sql)
        if not row:
            sql = (f"INSERT INTO {tablename} (fprocesscat_id, cur_user) "
                   f"VALUES ({fprocesscat_id}, current_user);")
        self.controller.execute_sql(sql)


    def utils_toolbox(self):

        self.toolbox.open_toolbox()


    def utils_print_composer(self):

        self.api_composer = ApiManageComposer(self.iface, self.settings, self.controller, self.plugin_dir)
        self.api_composer.composer()

