"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""


# -*- coding: utf-8 -*-

try:
    from qgis.core import Qgis
except ImportError:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT < 29900:
    pass
else:
    from builtins import range

from qgis.PyQt.QtGui import QStandardItem, QStandardItemModel
from qgis.PyQt.QtWidgets import QDateEdit, QFileDialog, QCheckBox, QDoubleSpinBox

import csv
import json
import operator
import os

from collections import OrderedDict
from encodings.aliases import aliases
from functools import partial

import utils_giswater
from giswater.actions.api_config import ApiConfig
from giswater.actions.api_manage_composer import ApiManageComposer
from giswater.actions.gw_toolbox import GwToolBox
from giswater.actions.parent import ParentAction
from giswater.actions.manage_visit import ManageVisit
from giswater.ui_manager import Toolbox
from giswater.ui_manager import Csv2Pg


class Utils(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'om_ws' """
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        
        self.manage_visit = ManageVisit(iface, settings, controller, plugin_dir)
        self.toolbox = GwToolBox(iface, settings, controller, plugin_dir)


    def set_project_type(self, project_type):
        self.project_type = project_type


    def utils_arc_topo_repair(self):
        """ Button 19: Topology repair """

        # Create dialog to check wich topology functions we want to execute
        self.dlg_toolbox = Toolbox()
        self.load_settings(self.dlg_toolbox)
        project_type = self.controller.get_project_type()

        # Remove tab WS or UD
        if project_type == 'ws':
            utils_giswater.remove_tab_by_tabName(self.dlg_toolbox.tabWidget_3, "tab_edit_ud")
        elif project_type == 'ud':
            utils_giswater.remove_tab_by_tabName(self.dlg_toolbox.tabWidget_3, "tab_edit_ws")

        role_admin = self.controller.check_role_user("role_admin")
        role_master = self.controller.check_role_user("role_master")
        role_edit = self.controller.check_role_user("role_edit")

        # Manage user 'postgres'
        if self.controller.user == 'postgres' or self.controller.user == 'gisadmin':
            role_admin = True

        # Remove tab for role
        if role_admin:
            pass
        elif role_master:
            utils_giswater.remove_tab_by_tabName(self.dlg_toolbox.Admin, "tab_admin")
        elif role_edit:
            utils_giswater.remove_tab_by_tabName(self.dlg_toolbox.Admin, "tab_admin")
            utils_giswater.remove_tab_by_tabName(self.dlg_toolbox.Admin, "tab_master")

        # Set signals
        self.dlg_toolbox.btn_accept.clicked.connect(self.utils_arc_topo_repair_accept)
        self.dlg_toolbox.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_toolbox))
        self.dlg_toolbox.rejected.connect(partial(self.close_dialog, self.dlg_toolbox))

        # Open dialog
        self.open_dialog(self.dlg_toolbox, dlg_name='toolbox', maximize_button=False)


    def utils_arc_topo_repair_accept(self):
        """ Button 19: Executes functions that are selected """

        # Delete previous values for current user
        tablename = "selector_audit"
        sql = ("DELETE FROM " + self.schema_name + "." + tablename + ""
               " WHERE cur_user = current_user;\n")
        self.controller.execute_sql(sql)

        # Edit - Utils - Check project / data
        if self.dlg_toolbox.check_qgis_project.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_audit_check_project(1);")
            self.controller.execute_sql(sql)
            self.insert_selector_audit(1)
        if self.dlg_toolbox.check_user_vdefault_parameters.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_audit_check_project(19);")
            self.controller.execute_sql(sql)
            self.insert_selector_audit(19)

        # Edit - Utils - Topology Builder
        if self.dlg_toolbox.check_create_nodes_from_arcs.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_built_nodefromarc();")
            self.controller.execute_sql(sql)

        # Edit - Utils - Topology review
        if self.dlg_toolbox.check_node_orphan.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_anl_node_orphan();")
            self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_node_duplicated.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_anl_node_duplicated();")
            self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_topology_coherence.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_anl_node_topological_consistency();")
            self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_arc_same_start_end.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_anl_arc_same_startend();")
            self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_arcs_without_nodes_start_end.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_anl_arc_no_startend_node();")
            self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_connec_duplicated.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_anl_connec_duplicated();")
            self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_mincut_data.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_edit_audit_check_data(25);")
            self.controller.execute_sql(sql)
            self.insert_selector_audit(25)
        if self.dlg_toolbox.check_profile_tool_data.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_edit_audit_check_data(26);")
            self.controller.execute_sql(sql)
            self.insert_selector_audit(26)

        # Edit - Utils - Topology Repair
        if self.dlg_toolbox.check_arc_searchnodes.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_repair_arc_searchnodes();")
            self.controller.execute_sql(sql)

        # Edit - UD
        if self.dlg_toolbox.check_node_sink.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_anl_node_sink();")
            self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_node_flow_regulator.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_anl_node_flowregulator();")
            self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_node_exit_upper_node_entry.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_anl_node_exit_upper_intro();")
            self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_arc_intersection_without_node.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_anl_arc_intersection();")
            self.controller.execute_sql(sql)
        if self.dlg_toolbox.check_inverted_arcs.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_anl_arc_inverted();")
            self.controller.execute_sql(sql)

        # Master - Prices
        if self.dlg_toolbox.check_reconstruction_price.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_plan_audit_check_data(15);")
            self.controller.execute_sql(sql)
            self.insert_selector_audit(15)
        if self.dlg_toolbox.check_rehabilitation_price.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_plan_audit_check_data(16);")
            self.controller.execute_sql(sql)
            self.insert_selector_audit(16)

        # Master - Advanced_topology_review
        if self.dlg_toolbox.check_arc_multi_psector.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_plan_anl_topology(20);")
            self.controller.execute_sql(sql)
            self.insert_selector_audit(20)
        if self.dlg_toolbox.check_node_multi_psector.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_plan_anl_topology(21);")
            self.controller.execute_sql(sql)
            self.insert_selector_audit(21)
        if self.dlg_toolbox.check_node_orphan_2.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_plan_anl_topology(22);")
            self.controller.execute_sql(sql)
            self.insert_selector_audit(22)
        if self.dlg_toolbox.check_node_duplicated_2.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_plan_anl_topology(23);")
            self.controller.execute_sql(sql)
            self.insert_selector_audit(23)
        if self.dlg_toolbox.check_arcs_without_nodes_start_end_2.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_plan_anl_topology(24);")
            self.controller.execute_sql(sql)
            self.insert_selector_audit(24)

        # Admin - Check data
        if self.dlg_toolbox.check_schema_data.isChecked():
            sql = ("SELECT "+self.schema_name+".gw_fct_audit_check_project(2);")
            self.controller.execute_sql(sql)
            self.insert_selector_audit(2)

        # Close the dialog
        self.close_dialog(self.dlg_toolbox)

        # Refresh map canvas
        self.refresh_map_canvas()


    def api_config(self):
        self.config = ApiConfig(self.iface, self.settings, self.controller, self.plugin_dir)
        self.config.api_config()


    def utils_import_csv(self):
        """ Button 83: Import CSV """
        self.func_name  = None
        self.dlg_csv = Csv2Pg()
        self.load_settings(self.dlg_csv)
        roles = self.controller.get_rolenames()

        temp_tablename = 'temp_csv2pg'
        self.populate_cmb_unicodes(self.dlg_csv.cmb_unicode_list)
        self.populate_combos(self.dlg_csv.cmb_import_type, 'id', 'name_i18n, csv_structure, functionname', 'sys_csv2pg_cat', roles, False)

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
        self.open_dialog(self.dlg_csv, maximize_button=False)


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
        utils_giswater.setWidgetText(self.dlg_csv, self.dlg_csv.cmb_unicode_list,
            self.controller.plugin_settings_value('Csv2Pg_cmb_unicode_list_' + cur_user))
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
            self.controller.show_warning(message)
            return None
        if path.find('.csv') == -1:
            message = "Please choose a csv file"
            self.controller.show_warning(message)
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
            if Qgis.QGIS_VERSION_INT < 29900:
                with open(path, "r") as file_input:
                    self.read_csv_file(model, file_input, delimiter, _unicode)
            else:
                with open(path, "r", encoding=_unicode) as file_input:
                    self.read_csv_file(model, file_input, delimiter, _unicode)

        except Exception as e:
            self.controller.show_warning(str(e))


    def read_csv_file(self, model, file_input, delimiter, _unicode):
        rows = csv.reader(file_input, delimiter=delimiter)
        for row in rows:
            if Qgis.QGIS_VERSION_INT < 29900:
                unicode_row = [x.decode(str(_unicode)) for x in row]
            else:
                unicode_row = [x for x in row]
            items = [QStandardItem(field) for field in unicode_row]
            model.appendRow(items)


    def delete_table_csv(self, temp_tablename, csv2pgcat_id_aux):
        """ Delete records from temp_csv2pg for current user and selected cat """
        sql = ("DELETE FROM " + self.schema_name + "." + temp_tablename + " "
               " WHERE csv2pgcat_id = '" + str(csv2pgcat_id_aux) + "' AND user_name = current_user")
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
            if Qgis.QGIS_VERSION_INT < 29900:
                with open(path, 'r') as csvfile:
                    insert_status = self.insert_into_db(dialog, csvfile, delimiter, csv2pgcat_id_aux, _unicode, temp_tablename)
            else:
                with open(path, 'r', encoding=_unicode) as csvfile:
                    insert_status = self.insert_into_db(dialog, csvfile, delimiter, csv2pgcat_id_aux, _unicode, temp_tablename)
        except Exception as e:
            self.controller.show_warning(str(e))
            self.controller.log_info(str(insert_status))
        self.save_settings_values()
        if insert_status is False:
            return
        extras = '"importParam":"' + label_aux + '"'
        extras += ', "csv2pgCat":"' + str(csv2pgcat_id_aux) + '"'
        body = self.create_body(extras=extras)
        sql = ("SELECT " + self.schema_name + "." + str(self.func_name) + "($${" + body + "}$$)::text")
        row = self.controller.get_row(sql, log_sql=True, commit=True)
        if not row:
            self.controller.show_warning("NOT ROW FOR: " + sql)
            message = "Import failed"
            self.controller.show_info_box(message)
            return
        else:
            complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]
            if complet_result[0]['status'] == "Accepted":
                qtabwidget = dialog.mainTab
                qtextedit = dialog.txt_infolog
                self.populate_info_text(dialog, qtabwidget, qtextedit, complet_result[0]['body']['data'])
            message = complet_result[0]['message']['text']
            self.controller.show_info_box(message)





    def insert_into_db(self, dialog, csvfile, delimiter, csv2pgcat_id_aux, _unicode, temp_tablename):
        cabecera = True
        fields = "csv2pgcat_id, "
        progress = 0
        dialog.progressBar.setVisible(True)
        dialog.progressBar.setValue(progress)
        # counts rows in csvfile, using var "row_count" to do progresbar
        row_count = sum(1 for rows in csvfile)  # @UnusedVariable
        if row_count > 20:
            row_count -= 20
        dialog.progressBar.setMaximum(row_count)  # -20 for see 100% complete progress
        csvfile.seek(0)  # Position the cursor at position 0 of the file
        reader = csv.reader(csvfile, delimiter=delimiter)
        for row in reader:
            values = "'" + str(csv2pgcat_id_aux) + "', '"
            progress += 1

            for x in range(0, len(row)):
                row[x] = row[x].replace("'", "''")
            if cabecera:
                for x in range(1, len(row) + 1):
                    fields += 'csv' + str(x) + ", "
                cabecera = False
                fields = fields[:-2]
            else:
                for value in row:
                    if len(value) != 0:
                        if Qgis.QGIS_VERSION_INT < 29900:
                            values += str(value.decode(str(_unicode))) + "', '"
                        else:
                            values += str(value) + "', '"
                    else:
                        values = values[:-1]
                        values += "null, '"
                values = values[:-3]
                sql = ("INSERT INTO " + self.controller.schema_name + "." + temp_tablename + " ("
                       + str(fields) + ") VALUES (" + str(values) + ")")

                status = self.controller.execute_sql(sql)
                if not status:
                    return False
                dialog.progressBar.setValue(progress)
                return True


    def populate_combos(self, combo, field_id, fields, table_name, roles, allow_nulls=True):

        if roles is None:
            return

        sql = ("SELECT DISTINCT(" + field_id + "), " + fields + ""
               " FROM " + self.schema_name + "." + table_name + ""
               " WHERE sys_role IN " + roles + " AND formname='importcsv' AND isdeprecated is not True")
        rows = self.controller.get_rows(sql, log_sql=True)
        if not rows:
            message = "You do not have permission to execute this application"
            self.dlg_csv.lbl_info.setText(self.controller.tr(message))
            self.dlg_csv.lbl_info.setStyleSheet("QLabel{color: red;}")
            self.dlg_csv.setEnabled(False)
            return

        combo.blockSignals(True)
        combo.clear()
        if allow_nulls:
            combo.addItem("", "")
        records_sorted = sorted(rows, key=operator.itemgetter(1))
        for record in records_sorted:
            combo.addItem(record[1], record)
        combo.blockSignals(False)

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
        file_csv = QFileDialog.getOpenFileName(None, message, "", '*.csv')
        self.controller.set_path_from_qfiledialog(self.dlg_csv.txt_file_csv, file_csv)
        self.save_settings_values()
        self.preview_csv(self.dlg_csv)


    def insert_selector_audit(self, fprocesscat_id):
        """ Insert @fprocesscat_id for current_user in table 'selector_audit' """

        tablename = "selector_audit"
        sql = ("SELECT * FROM " + self.schema_name + "." + tablename + ""
               " WHERE fprocesscat_id = " + str(fprocesscat_id) + " AND cur_user = current_user;")
        row = self.controller.get_row(sql)
        if not row:
            sql = ("INSERT INTO " + self.schema_name + "." + tablename + " (fprocesscat_id, cur_user)"
                   " VALUES (" + str(fprocesscat_id) + ", current_user);")
        self.controller.execute_sql(sql)


    def utils_toolbox(self):
        self.toolbox.open_toolbox()


    def utils_print_composer(self):
        self.api_composer = ApiManageComposer(self.iface, self.settings, self.controller, self.plugin_dir)
        self.api_composer.composer()