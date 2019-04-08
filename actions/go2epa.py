"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
from __future__ import print_function
from future import standard_library
standard_library.install_aliases()

# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except ImportError:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT < 29900:
    from qgis.PyQt.QtGui import QStringListModel
else:
    from qgis.PyQt.QtCore import QStringListModel
    from builtins import range

from qgis.PyQt.QtCore import QTime, QDate, Qt
from qgis.PyQt.QtWidgets import QAbstractItemView, QWidget, QCheckBox, QDateEdit, QTimeEdit, QComboBox
from qgis.PyQt.QtWidgets import QCompleter, QFileDialog, QMessageBox

import csv, os, re, subprocess
from functools import partial

import utils_giswater
from giswater.actions.api_go2epa_options import Go2EpaOptions
from giswater.actions.api_parent import ApiParent
from giswater.actions.update_sql import UpdateSQL
from giswater.ui_manager import FileManager, Multirow_selector, HydrologySelector
from giswater.ui_manager import EpaResultCompareSelector, EpaResultManager


class Go2Epa(ApiParent):
    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'go2epa' """
        ApiParent.__init__(self, iface, settings, controller, plugin_dir)
        self.g2epa_opt = Go2EpaOptions(iface, settings, controller, plugin_dir)

    def set_project_type(self, project_type):
        self.project_type = project_type

    def go2epa(self):
        """ Button 23: Open form to set INP, RPT and project """

        self.imports_canceled = False
        # Create dialog
        self.dlg_go2epa = FileManager()
        self.load_settings(self.dlg_go2epa)
        self.load_user_values()
        if self.project_type in 'ws':
            self.dlg_go2epa.chk_export_subcatch.setVisible(False)

        # Check if user can use recursion or not
        go2eparecurisve = self.settings.value('system_variables/go2eparecurisve')
        if str(go2eparecurisve) == "FALSE":
            self.dlg_go2epa.chk_recurrent.setVisible(False)
            self.dlg_go2epa.chk_recurrent.setChecked(False)


        self.dlg_go2epa.progressBar.setMaximum(0)
        self.dlg_go2epa.progressBar.setMinimum(0)
        self.show_widgets(False)

        # Set signals
        self.dlg_go2epa.chk_only_check.stateChanged.connect(partial(self.active_recurrent))
        self.dlg_go2epa.chk_recurrent.stateChanged.connect(partial(self.recurrent))
        self.dlg_go2epa.txt_result_name.textChanged.connect(partial(self.check_result_id))
        self.dlg_go2epa.btn_file_inp.clicked.connect(self.go2epa_select_file_inp)
        self.dlg_go2epa.btn_file_rpt.clicked.connect(self.go2epa_select_file_rpt)
        self.dlg_go2epa.btn_accept.clicked.connect(self.go2epa_accept)
        self.dlg_go2epa.btn_cancel.clicked.connect(partial(self.cancel_imports))
        self.dlg_go2epa.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_go2epa))
        self.dlg_go2epa.rejected.connect(partial(self.close_dialog, self.dlg_go2epa))
        self.dlg_go2epa.btn_options.clicked.connect(self.epa_options)
        if self.project_type == 'ws':
            self.dlg_go2epa.btn_hs_ds.setText("Dscenario Selector")
            tableleft = "cat_dscenario"
            tableright = "inp_selector_dscenario"
            field_id_left = "dscenario_id"
            field_id_right = "dscenario_id"
            self.dlg_go2epa.btn_hs_ds.clicked.connect(
                partial(self.sector_selection, tableleft, tableright, field_id_left, field_id_right))

        if self.project_type == 'ud':
            self.dlg_go2epa.btn_hs_ds.setText("Hydrology selector")
            self.dlg_go2epa.btn_hs_ds.clicked.connect(self.ud_hydrology_selector)

        self.set_completer_result(self.dlg_go2epa.txt_result_name, 'v_ui_rpt_cat_result', 'result_id')

        # Open dialog
        self.dlg_go2epa.show()


    def cancel_imports(self):
        self.counter = self.iterations
        self.imports_canceled = True


    def active_recurrent(self, state):
        if state == 2:  # Checked
            self.dlg_go2epa.chk_recurrent.setEnabled(True)
        elif state == 0:  # UnChecked
            self.dlg_go2epa.chk_recurrent.setEnabled(False)
            utils_giswater.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_recurrent, False)
            self.recurrent(0)


    def recurrent(self, state):
        if state == 0:
            utils_giswater.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export, False)
            utils_giswater.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export_subcatch, False)
            utils_giswater.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_exec, False)
            utils_giswater.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_import_result, False)
            self.dlg_go2epa.chk_export.setEnabled(True)
            self.dlg_go2epa.chk_export_subcatch.setEnabled(True)
            self.dlg_go2epa.chk_exec.setEnabled(True)
            self.dlg_go2epa.chk_import_result.setEnabled(True)
        elif state == 2:
            msg = ("You have activated the recursive functionality. It will take a lot of time. Check recursive "
                   "function is well configured and your python console is open. Would you like to contiue?")
            title = "Activate recursive"
            answer = self.controller.ask_question(msg, title)
            if answer:

                utils_giswater.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export, True)
                utils_giswater.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export_subcatch, True)
                utils_giswater.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_exec, True)
                utils_giswater.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_import_result, True)
                self.dlg_go2epa.chk_export.setEnabled(False)
                self.dlg_go2epa.chk_export_subcatch.setEnabled(False)
                self.dlg_go2epa.chk_exec.setEnabled(False)
                self.dlg_go2epa.chk_import_result.setEnabled(False)
            else:
                utils_giswater.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_recurrent, False)


    def check_inp_chk(self, file_inp):
        if file_inp is None:
            msg = "Select valid INP file"
            self.controller.show_warning(msg, parameter=str(file_inp))
            return False


    def check_rpt(self):
        file_inp = utils_giswater.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_inp)
        file_rpt = utils_giswater.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_rpt)
        # Control execute epa software
        if utils_giswater.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_exec):
            if self.check_inp_chk(file_inp) is False:
                return False

            if file_rpt is None:
                msg = "Select valid RPT file"
                self.controller.show_warning(msg, parameter=str(file_rpt))
                return False

            if not utils_giswater.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export):
                if not os.path.exists(file_inp):
                    msg = "File INP not found"
                    self.controller.show_warning(msg, parameter=str(file_rpt))
                    return False


    def check_fields(self):
        file_inp = utils_giswater.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_inp)
        file_rpt = utils_giswater.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_rpt)
        result_name = utils_giswater.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_result_name, False, False)
        # Control export INP
        if utils_giswater.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export):
            if self.check_inp_chk(file_inp) is False:
                return False

        # Control execute epa software
        if self.check_rpt() is False:
            return False

        # Control import result
        if utils_giswater.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_import_result):
            if file_rpt is None:
                    msg = "Select valid RPT file"
                    self.controller.show_warning(msg, parameter=str(file_rpt))
                    return False
            if not utils_giswater.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_exec):
                if not os.path.exists(file_rpt):
                    msg = "File RPT not found"
                    self.controller.show_warning(msg, parameter=str(file_rpt))
                    return False
            else:
                if self.check_rpt() is False:
                    return False

        # Control result name
        if result_name == '':
            self.dlg_go2epa.txt_result_name.setStyleSheet("border: 1px solid red")
            msg = "This parameter is mandatory. Please, set a value"
            self.controller.show_details(msg, title="Rpt fail", inf_text=None)
            return False
        else:
            sql = ("SELECT result_id FROM " + self.schema_name + ".rpt_cat_result "
                   " WHERE result_id='" + str(result_name) + "' LIMIT 1")
            row = self.controller.get_row(sql, log_sql=False, commit=True)
            if row:
                msg = "Result name already exists, do you want override?"
                answer = self.controller.ask_question(msg, title="Alert")
                if not answer:
                    return False
        return True


    def go2epa_sector_selector(self):
        tableleft = "sector"
        tableright = "inp_selector_sector"
        field_id_left = "sector_id"
        field_id_right = "sector_id"
        self.sector_selection(tableleft, tableright, field_id_left, field_id_right)


    def load_user_values(self):
        """ Load QGIS settings related with file_manager """
        cur_user = self.controller.get_current_user()

        self.result_name = self.controller.plugin_settings_value('go2epa_RESULT_NAME' + cur_user)
        self.dlg_go2epa.txt_result_name.setText(self.result_name)
        self.file_inp = self.controller.plugin_settings_value('go2epa_FILE_INP' + cur_user)
        self.dlg_go2epa.txt_file_inp.setText(self.file_inp)
        self.file_rpt = self.controller.plugin_settings_value('go2epa_FILE_RPT' + cur_user)
        self.dlg_go2epa.txt_file_rpt.setText(self.file_rpt)

        value = self.controller.plugin_settings_value('go2epa_chk_NETWORK_GEOM' + cur_user)
        if str(value) == 'true':
            utils_giswater.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_only_check, True)
        value = self.controller.plugin_settings_value('go2epa_chk_RECURSIVE' + cur_user)
        if str(value) == 'true':
            utils_giswater.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_recurrent, True)

        value = self.controller.plugin_settings_value('go2epa_chk_INP' + cur_user)
        if str(value) == 'true':
            utils_giswater.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export, True)
        value = self.controller.plugin_settings_value('go2epa_chk_UD' + cur_user)
        if str(value) == 'true':
            utils_giswater.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export_subcatch, True)
        value = self.controller.plugin_settings_value('go2epa_chk_EPA' + cur_user)
        if str(value) == 'true':
            utils_giswater.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_exec, True)
        value = self.controller.plugin_settings_value('go2epa_chk_RPT' + cur_user)
        if str(value) == 'true':
            utils_giswater.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_import_result, True)


    def save_user_values(self):
        """ Save QGIS settings related with file_manager """
        cur_user = self.controller.get_current_user()
        self.controller.plugin_settings_set_value('go2epa_RESULT_NAME' + cur_user,
                                                  utils_giswater.getWidgetText(self.dlg_go2epa, 'txt_result_name'))
        self.controller.plugin_settings_set_value('go2epa_FILE_INP' + cur_user,
                                                  utils_giswater.getWidgetText(self.dlg_go2epa, 'txt_file_inp'))
        self.controller.plugin_settings_set_value('go2epa_FILE_RPT' + cur_user,
                                                  utils_giswater.getWidgetText(self.dlg_go2epa, 'txt_file_rpt'))

        self.controller.plugin_settings_set_value('go2epa_chk_NETWORK_GEOM' + cur_user,
                                                  utils_giswater.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_only_check))

        self.controller.plugin_settings_set_value('go2epa_chk_RECURSIVE' + cur_user,
                                          utils_giswater.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_recurrent))
        self.controller.plugin_settings_set_value('go2epa_chk_INP' + cur_user,
                                                  utils_giswater.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export))
        self.controller.plugin_settings_set_value('go2epa_chk_UD' + cur_user,
                                                  utils_giswater.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export_subcatch))
        self.controller.plugin_settings_set_value('go2epa_chk_EPA' + cur_user,
                                                  utils_giswater.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_exec))
        self.controller.plugin_settings_set_value('go2epa_chk_RPT' + cur_user,
                                                  utils_giswater.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_import_result))
        

    def sector_selection(self, tableleft, tableright, field_id_left, field_id_right):
        """ Load the tables in the selection form """

        dlg_psector_sel = Multirow_selector()
        self.load_settings(dlg_psector_sel)
        dlg_psector_sel.btn_ok.clicked.connect(dlg_psector_sel.close)
        if tableleft == 'sector':
            dlg_psector_sel.setWindowTitle(" Sector selector")
            utils_giswater.setWidgetText(dlg_psector_sel, dlg_psector_sel.lbl_filter,
                                         self.controller.tr('Filter by: Sector name', context_name='labels'))
            utils_giswater.setWidgetText(dlg_psector_sel, dlg_psector_sel.lbl_unselected,
                                         self.controller.tr('Unselected sectors', context_name='labels'))
            utils_giswater.setWidgetText(dlg_psector_sel, dlg_psector_sel.lbl_selected,
                                         self.controller.tr('Selected sectors', context_name='labels'))
        if tableleft == 'cat_dscenario':
            dlg_psector_sel.setWindowTitle(" Dscenario selector")
            utils_giswater.setWidgetText(dlg_psector_sel, dlg_psector_sel.lbl_filter,
                                         self.controller.tr('Filter by: Dscenario name', context_name='labels'))
            utils_giswater.setWidgetText(dlg_psector_sel, dlg_psector_sel.lbl_unselected,
                                         self.controller.tr('Unselected dscenarios', context_name='labels'))
            utils_giswater.setWidgetText(dlg_psector_sel, dlg_psector_sel.lbl_selected,
                                         self.controller.tr('Selected dscenarios', context_name='labels'))
        self.multi_row_selector(dlg_psector_sel, tableleft, tableright, field_id_left, field_id_right)
        dlg_psector_sel.setWindowFlags(Qt.WindowStaysOnTopHint)
        dlg_psector_sel.exec_()


    def epa_options(self):
        """ Open dialog api_epa_options.ui.ui """
        status = self.g2epa_opt.go2epa_options()
        return


    def ud_hydrology_selector(self):
        """ Dialog hydrology_selector.ui """

        self.dlg_hydrology_selector = HydrologySelector()
        self.load_settings(self.dlg_hydrology_selector)

        self.dlg_hydrology_selector.btn_accept.clicked.connect(self.save_hydrology)
        self.dlg_hydrology_selector.hydrology.currentIndexChanged.connect(self.update_labels)
        self.dlg_hydrology_selector.txt_name.textChanged.connect(
            partial(self.filter_cbx_by_text, "cat_hydrology", self.dlg_hydrology_selector.txt_name,
                    self.dlg_hydrology_selector.hydrology))

        sql = ("SELECT DISTINCT(name), hydrology_id FROM " + self.schema_name + ".cat_hydrology ORDER BY name")
        rows = self.controller.get_rows(sql, commit=True)
        if not rows:
            message = "Any data found in table"
            self.controller.show_warning(message, parameter='cat_hydrology')
            return False

        utils_giswater.set_item_data(self.dlg_hydrology_selector.hydrology, rows)

        sql = ("SELECT DISTINCT(t1.name) FROM " + self.schema_name + ".cat_hydrology AS t1"
               " INNER JOIN " + self.schema_name + ".inp_selector_hydrology AS t2 ON t1.hydrology_id = t2.hydrology_id "
               " WHERE t2.cur_user = current_user")
        row = self.controller.get_row(sql, commit=True)

        if row:
            utils_giswater.setWidgetText(self.dlg_hydrology_selector, self.dlg_hydrology_selector.hydrology, row[0])
        else:
            utils_giswater.setWidgetText(self.dlg_hydrology_selector, self.dlg_hydrology_selector.hydrology, 0)
        self.update_labels()
        self.dlg_hydrology_selector.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_hydrology_selector.exec_()


    def save_hydrology(self):
        sql = ("SELECT cur_user FROM " + self.schema_name + ".inp_selector_hydrology "
               " WHERE cur_user = current_user")
        row = self.controller.get_row(sql, commit=True)
        if row:
            sql = ("UPDATE " + self.schema_name + ".inp_selector_hydrology "
                   "SET hydrology_id = " + str(utils_giswater.get_item_data(self.dlg_hydrology_selector, self.dlg_hydrology_selector.hydrology, 1)) + ""
                   " WHERE cur_user = current_user")
        else:
            sql = ("INSERT INTO " + self.schema_name + ".inp_selector_hydrology (hydrology_id, cur_user)"
                   " VALUES('" + str(utils_giswater.get_item_data(self.dlg_hydrology_selector, self.dlg_hydrology_selector.hydrology, 1)) + "', current_user)")
        self.controller.execute_sql(sql)
        message = "Values has been update"
        self.controller.show_info(message)
        self.close_dialog(self.dlg_hydrology_selector)


    def update_labels(self):
        """ Show text in labels from SELECT """

        sql = ("SELECT infiltration, text FROM " + self.schema_name + ".cat_hydrology"
               " WHERE name = '" + str(self.dlg_hydrology_selector.hydrology.currentText()) + "'")
        row = self.controller.get_row(sql, commit=True)
        if row is not None:
            utils_giswater.setText(self.dlg_hydrology_selector, self.dlg_hydrology_selector.infiltration, row[0])
            utils_giswater.setText(self.dlg_hydrology_selector, self.dlg_hydrology_selector.descript, row[1])


    def filter_cbx_by_text(self, tablename, widgettxt, widgetcbx):

        sql = ("SELECT DISTINCT(name), hydrology_id FROM " + self.schema_name + "." + str(tablename) + ""
               " WHERE name LIKE '%" + str(widgettxt.text()) + "%'"
               " ORDER BY name ")
        rows = self.controller.get_rows(sql, commit=True)
        if not rows:
            message = "Check the table 'cat_hydrology' "
            self.controller.show_warning(message)
            return False
        utils_giswater.set_item_data(widgetcbx, rows)
        self.update_labels()


    def go2epa_select_file_inp(self):
        """ Select INP file """
        self.file_inp = utils_giswater.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_inp)
        # Set default value if necessary
        if self.file_inp is None or self.file_inp == '':
            self.file_inp = self.plugin_dir

        # Get directory of that file
        folder_path = os.path.dirname(self.file_inp)
        if not os.path.exists(folder_path):
            folder_path = os.path.dirname(__file__)
        os.chdir(folder_path)
        message = self.controller.tr("Select INP file")
        self.file_inp = QFileDialog.getSaveFileName(None, message, "", '*.inp')
        self.controller.set_path_from_qfiledialog(self.dlg_go2epa.txt_file_inp, self.file_inp)


    def go2epa_select_file_rpt(self):
        """ Select RPT file """

        # Set default value if necessary
        if self.file_rpt is None or self.file_rpt == '':
            self.file_rpt = self.plugin_dir

        # Get directory of that file
        folder_path = os.path.dirname(self.file_rpt)
        if not os.path.exists(folder_path):
            folder_path = os.path.dirname(__file__)
        os.chdir(folder_path)
        message = self.controller.tr("Select RPT file")
        self.file_rpt = QFileDialog.getSaveFileName(None, message, "", '*.rpt')
        self.controller.set_path_from_qfiledialog(self.dlg_go2epa.txt_file_rpt, self.file_rpt)


    def insert_into_inp(self, folder_path=None, all_rows=None):
        progress = 0
        # sys.stdout.flush()
        self.dlg_go2epa.progressBar.setFormat("The INP file is begin exported...")
        self.dlg_go2epa.progressBar.setAlignment(Qt.AlignCenter)
        self.dlg_go2epa.progressBar.setValue(progress)
        # self.show_widgets(True)
        row_count = sum(1 for rows in all_rows)  # @UnusedVariable
        self.dlg_go2epa.progressBar.setMaximum(row_count)
        file1 = open(folder_path, "w")
        for row in all_rows:
            progress += 1
            self.dlg_go2epa.progressBar.setValue(progress)
            line = ""
            for x in range(0, len(row)):
                if row[x] is not None:
                    line += str(row[x])
                    if len(row[x]) < 4:
                        line += "\t\t\t\t\t"
                    elif len(row[x]) < 8:
                        line += "\t\t\t\t"
                    elif len(row[x]) < 12:
                        line += "\t\t\t"
                    elif len(row[x]) < 16:
                        line += "\t\t"
                    elif len(row[x]) < 20:
                        line += "\t"

            line = line.rstrip() + "\n"
            file1.write(line)
        file1.close()
        del file1


    def insert_rpt_into_db(self, folder_path=None):
        _file = open(folder_path, "r+")
        full_file = _file.readlines()
        sql = ""
        progress = 0
        self.dlg_go2epa.progressBar.setFormat("The RPT file is begin imported...")
        self.dlg_go2epa.progressBar.setAlignment(Qt.AlignCenter)
        self.dlg_go2epa.progressBar.setValue(progress)

        row_count = sum(1 for rows in full_file)  # @UnusedVariable
        self.dlg_go2epa.progressBar.setMaximum(row_count)
        for row in full_file:
            progress += 1
            self.dlg_go2epa.progressBar.setValue(progress)
            dirty_list = row.split(' ')
            for x in range(len(dirty_list) - 1, -1, -1):
                if dirty_list[x] == '' or "**" in dirty_list[x] or "--" in dirty_list[x]:
                    dirty_list.pop(x)

            sp_n = []
            if len(dirty_list) > 0:
                for x in range(0, len(dirty_list)):
                    if bool(re.search('[[0-9][-][0-9]]*', str(dirty_list[x]))):
                        # 0.00-2.56e+007-2.56e+007
                        last_index = 0
                        for i, c in enumerate(dirty_list[x]):
                            if "-" == c:
                                aux = dirty_list[x][last_index:i]
                                last_index = i
                                sp_n.append(aux)
                        aux = dirty_list[x][last_index:i]
                        sp_n.append(aux)
                    else:
                        sp_n.append(dirty_list[x])

            if len(sp_n) > 0:
                sql += "INSERT INTO " + self.schema_name + ".temp_csv2pg (csv2pgcat_id, "
                values = "VALUES(11, "
                for x in range(0, len(sp_n)):
                    if "''" not in sp_n[x]:
                        sql += "csv" + str(x + 1) + ", "
                        value = "'" + sp_n[x].strip().replace("\n", "") + "', "
                        values += value.replace("''", "null")
                    else:
                        sql += "csv" + str(x + 1) + ", "
                        values = "VALUES(null, "
                sql = sql[:-2] + ") "
                values = values[:-2] + ");\n"
                sql += values
            if progress % 500 == 0:
                self.controller.execute_sql(sql, log_sql=False, commit=True)
                sql = ""
        if sql != "":
            self.controller.execute_sql(sql, log_sql=False, commit=True)
        _file.close()
        del _file


    def show_widgets(self, visible=False):
        self.dlg_go2epa.progressBar.setVisible(visible)
        self.dlg_go2epa.lbl_counter.setVisible(visible)


    def go2epa_accept(self):
        """ Save INP, RPT and result name into GSW file """

        self.dlg_go2epa.txt_file_rpt.setStyleSheet("border: 1px solid gray")
        status = self.check_fields()
        if status is False:
            return

        # Get widgets values
        self.result_name = utils_giswater.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_result_name, False, False)
        prev_net_geom = utils_giswater.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_only_check)
        export_inp = utils_giswater.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export)
        export_subcatch = utils_giswater.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export_subcatch)
        self.file_inp = utils_giswater.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_inp)
        exec_epa = utils_giswater.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_exec)
        self.file_rpt = utils_giswater.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_rpt)
        import_result = utils_giswater.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_import_result)
        is_recursive = utils_giswater.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_recurrent)

        if export_inp:
            sql = ("SELECT sector_id FROM " + self.schema_name + ".inp_selector_sector LIMIT 1")
            row = self.controller.get_row(sql, log_sql=False, commit=True)
            if row is None:
                msg = "You need to select some sector"
                # self.controller.show_info_box(text=msg, title="Info")
                msg_box = QMessageBox()
                msg_box.setIcon(3)
                msg_box.setWindowTitle("Warning")
                msg_box.setText(msg)
                msg_box.exec_()
                return

        if self.project_type in 'ws':
            opener = self.plugin_dir + "/epa/ws_epanet20012.exe"
            epa_function_call = "gw_fct_pg2epa($$" + str(self.result_name) + "$$, " + str(prev_net_geom) + ", " + str(
                is_recursive) + ")"
        elif self.project_type in 'ud':
            opener = self.plugin_dir + "/epa/ud_swmm50022.exe"
            epa_function_call = "gw_fct_pg2epa($$" + str(self.result_name) + "$$, " + str(prev_net_geom) + ", " + str(
                export_subcatch) + ", " + str(is_recursive) + ")"

        # export_function = "gw_fct_utils_csv2pg_export_epa_inp('" + str(self.result_name) + "')"
        self.show_widgets(True)
        self.iterations = 1
        self.counter = 0
        if is_recursive:
            extras = '"status":"1"'
            extras += ', "result_id":"' + str(self.result_name) + '"'
            body = self.create_body(extras=extras)
            sql = ("SELECT " + self.schema_name + ".gw_fct_pg2epa_recursive($${" + body + "}$$)::text")
            row = self.controller.get_row(sql, log_sql=True, commit=True)
            utils_giswater.setWidgetText(self.dlg_go2epa, self.dlg_go2epa.lbl_counter, "0/" + str(row[0]))
            self.iterations = int(str(row[0]))

        print("{}:{}".format(self.counter, self.iterations))
        while self.counter < self.iterations:
            common_msg = ""
            # Export to inp file
            if export_inp is True:
                # Call function gw_fct_pg2epa
                sql = ("SELECT " + self.schema_name + "." + epa_function_call)
                row = self.controller.get_row(sql, log_sql=True, commit=True)

                # Get values from temp_csv2pg and insert into INP file
                sql = ("SELECT csv1, csv2, csv3, csv4, csv5, csv6, csv7, csv8, csv9, csv10, csv11, csv12, csv13,"
                       " csv14, csv15, csv16, csv17, csv18, csv19, csv20, csv21, csv22, csv23, csv24, csv25 "
                       " FROM " + self.schema_name + ".temp_csv2pg "
                       " WHERE csv2pgcat_id=10 AND user_name = current_user ORDER BY id")
                rows = self.controller.get_rows(sql, log_sql=True, commit=True)

                if rows is None:
                    self.controller.show_message("NOT ROW FOR: " + sql, 2)
                    self.show_widgets(False)
                    return
                self.insert_into_inp(self.file_inp, rows)
                common_msg += "Export INP finished. "

            # Execute epa
            if exec_epa is True:
                if self.file_rpt == "null":
                    message = "You have to set this parameter"
                    self.controller.show_warning(message, parameter="RPT file")
                    self.show_widgets(False)
                    return

                msg = "INP file not found"
                if self.file_inp is not None:
                    if not os.path.exists(self.file_inp):
                        self.controller.show_warning(msg, parameter=str(self.file_inp))
                        return
                else:
                    self.controller.show_warning(msg, parameter=str(self.file_inp))
                    return

                self.dlg_go2epa.progressBar.setMaximum(0)
                self.dlg_go2epa.progressBar.setMinimum(0)
                self.dlg_go2epa.progressBar.setFormat("Epa software is running...")
                self.dlg_go2epa.progressBar.setAlignment(Qt.AlignCenter)

                subprocess.call([opener, self.file_inp, self.file_rpt], shell=False)
                common_msg += "EPA model finished. "

            # Import to DB
            if import_result is True:
                if os.path.exists(self.file_rpt):

                    # delete previous values of user on temp table
                    sql = ("DELETE FROM " + self.schema_name + ".temp_csv2pg "
                                                               " WHERE user_name=current_user AND csv2pgcat_id=11")
                    self.controller.execute_sql(sql, log_sql=False)

                    # Importing file to temporal table
                    self.insert_rpt_into_db(self.file_rpt)

                    # Call function gw_fct_utils_csv2pg_export_epa_inp to put in order data from temp table to result tables
                    sql = ("SELECT " + self.schema_name + "." + "gw_fct_utils_csv2pg_import_epa_rpt('" + str(
                        self.result_name) + "')")
                    row = self.controller.get_row(sql, log_sql=True, commit=True)

                    # final message
                    common_msg += "Import RPT finished."
                else:
                    msg = "Can't export rpt, File not found"
                    self.controller.show_warning(msg, parameter=self.file_rpt)

            self.counter += 1
            print("{}:{}".format(self.counter, self.iterations))
            utils_giswater.setWidgetText(self.dlg_go2epa, self.dlg_go2epa.lbl_counter,
                                         str(self.counter) + "/" + str(self.iterations))

        if is_recursive:
            extras = '"status":"0"'
            body = self.create_body(extras=extras)
            sql = ("SELECT " + self.schema_name + ".gw_fct_pg2epa_recursive($${" + body + "}$$)::text")
            row = self.controller.get_row(sql, log_sql=True, commit=True)

        if common_msg != "" and self.imports_canceled is False:
            self.controller.show_info(common_msg)

        # Save user values
        self.save_user_values()

        self.show_widgets(False)
        # Close form
        self.close_dialog(self.dlg_go2epa)


    def set_completer_result(self, widget, viewname, field_name):
        """ Set autocomplete of widget 'feature_id'
            getting id's from selected @viewname
        """
        result_name = utils_giswater.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_result_name)

        # Adding auto-completion to a QLineEdit
        self.completer = QCompleter()
        self.completer.setCaseSensitivity(Qt.CaseInsensitive)
        widget.setCompleter(self.completer)
        model = QStringListModel()

        sql = ("SELECT " + field_name + " FROM " + self.schema_name + "." + viewname)
        rows = self.controller.get_rows(sql, log_sql=False, commit=True)

        if rows:
            for i in range(0, len(rows)):
                aux = rows[i]
                rows[i] = str(aux[0])

            model.setStringList(rows)
            self.completer.setModel(model)
            if result_name in rows:
                self.dlg_go2epa.chk_only_check.setEnabled(True)


    def check_result_id(self):
        """ Check if selected @result_id already exists """
        result_id = utils_giswater.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_result_name)
        sql = ("SELECT result_id FROM " + self.schema_name + ".v_ui_rpt_cat_result"
               " WHERE result_id = '" + str(result_id) + "'")
        row = self.controller.get_row(sql, commit=True)
        if not row:
            self.dlg_go2epa.chk_only_check.setChecked(False)
            self.dlg_go2epa.chk_only_check.setEnabled(False)
        else:
            self.dlg_go2epa.chk_only_check.setEnabled(True)


    def check_data(self):
        """ Check data executing function 'gw_fct_pg2epa' """

        sql = "SELECT " + self.schema_name + ".gw_fct_pg2epa('" + str(self.project_name) + "', 'True');"
        row = self.controller.get_row(sql, log_sql=False, commit=True)
        if not row:
            return False

        if row[0] > 0:
            message = ("It is not possible to execute the epa model."
                       "There are errors on your project. Review it!")
            sql_details = ("SELECT table_id, column_id, error_message"
                           " FROM audit_check_data"
                           " WHERE fprocesscat_id = 14 AND result_id = '" + str(self.project_name) + "'")
            inf_text = "For more details execute query:\n" + sql_details
            title = "Execute epa model"
            self.controller.show_info_box(message, title, inf_text, parameter=row[0])
            self.csv_audit_check_data("audit_check_data", "audit_check_data_log.csv")
            return False

        else:
            message = "Data is ok. You can try to generate the INP file"
            title = "Execute epa model"
            self.controller.show_info_box(message, title)
            return True


    def csv_audit_check_data(self, tablename, filename):

        # Get columns name in order of the table
        rows = self.controller.get_columns_list(tablename)
        if not rows:
            message = "Table not found"
            self.controller.show_warning(message, parameter=tablename)
            return

        columns = []
        for i in range(0, len(rows)):
            column_name = rows[i]
            columns.append(str(column_name[0]))
        sql = ("SELECT table_id, column_id, error_message"
               " FROM " + self.schema_name + "." + tablename + ""
               " WHERE fprocesscat_id = 14 AND result_id = '" + self.project_name + "'")
        rows = self.controller.get_rows(sql, log_sql=False, commit=True)
        if not rows:
            message = "No records found with selected 'result_id'"
            self.controller.show_warning(message, parameter=self.project_name)
            return

        all_rows = []
        all_rows.append(columns)
        for i in rows:
            all_rows.append(i)
        path = self.controller.get_log_folder() + filename
        try:
            with open(path, "w") as output:
                writer = csv.writer(output, lineterminator='\n')
                writer.writerows(all_rows)
            message = "File created successfully"
            self.controller.show_info(message, parameter=path, duration=10)
        except IOError:
            message = "File cannot be created. Check if it is already opened"
            self.controller.show_warning(message, parameter=path)


    def save_file_parameters(self):
        """ Save INP, RPT and result name into GSW file """

        self.gsw_settings.setValue('FILE_INP', self.file_inp)
        self.gsw_settings.setValue('FILE_RPT', self.file_rpt)
        self.gsw_settings.setValue('RESULT_NAME', self.result_name)


    def go2epa_result_selector(self):
        """ Button 29: Epa result selector """

        # Create the dialog and signals
        self.dlg_go2epa_result = EpaResultCompareSelector()
        self.load_settings(self.dlg_go2epa_result)
        if self.project_type == 'ud':
            utils_giswater.remove_tab_by_tabName(self.dlg_go2epa_result.tabWidget, "tab_time")
        if self.project_type == 'ws':
            utils_giswater.remove_tab_by_tabName(self.dlg_go2epa_result.tabWidget, "tab_datetime")
        self.dlg_go2epa_result.btn_accept.clicked.connect(self.result_selector_accept)
        self.dlg_go2epa_result.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_go2epa_result))
        self.dlg_go2epa_result.rejected.connect(partial(self.close_dialog, self.dlg_go2epa_result))

        # Set values from widgets of type QComboBox
        sql = ("SELECT DISTINCT(result_id), result_id "
               "FROM " + self.schema_name + ".v_ui_rpt_cat_result ORDER BY result_id")
        rows = self.controller.get_rows(sql)
        utils_giswater.set_item_data(self.dlg_go2epa_result.rpt_selector_result_id, rows)
        rows = [('', '')]
        rows.extend(self.controller.get_rows(sql))
        utils_giswater.set_item_data(self.dlg_go2epa_result.rpt_selector_compare_id, rows)
        if self.project_type == 'ws':
            sql = ("SELECT DISTINCT time, time FROM " + self.schema_name + ".rpt_arc "
                   " WHERE result_id ILIKE '%%' ORDER BY time")
            rows = [('', '')]
            rows.extend(self.controller.get_rows(sql))
            utils_giswater.set_item_data(self.dlg_go2epa_result.cmb_time_to_show, rows)
            utils_giswater.set_item_data(self.dlg_go2epa_result.cmb_time_to_compare, rows)

            self.dlg_go2epa_result.rpt_selector_result_id.currentIndexChanged.connect(partial(
                self.populate_time, self.dlg_go2epa_result.rpt_selector_result_id, self.dlg_go2epa_result.cmb_time_to_show))
            self.dlg_go2epa_result.rpt_selector_compare_id.currentIndexChanged.connect(partial(
                self.populate_time, self.dlg_go2epa_result.rpt_selector_compare_id, self.dlg_go2epa_result.cmb_time_to_compare))

        if self.project_type == 'ud':
            # Populate GroupBox Selector date
            result_id = utils_giswater.get_item_data(self.dlg_go2epa_result, self.dlg_go2epa_result.rpt_selector_result_id, 0)
            sql = ("SELECT DISTINCT(resultdate), resultdate  FROM " + self.schema_name + ".rpt_arc"
                   " WHERE result_id ='"+str(result_id)+"'"
                   " ORDER BY resultdate ")
            rows = self.controller.get_rows(sql, log_sql=False)
            if rows is not None:
                utils_giswater.set_item_data(self.dlg_go2epa_result.cmb_sel_date, rows)
                selector_date = utils_giswater.get_item_data(self.dlg_go2epa_result, self.dlg_go2epa_result.cmb_sel_date, 0)
                sql = ("SELECT DISTINCT(resulttime), resulttime  FROM " + self.schema_name + ".rpt_arc"
                       " WHERE result_id ='"+str(result_id)+"' "
                       " AND resultdate='" + str(selector_date) + "'"
                       " ORDER BY resulttime ")
                rows = [('', '')]
                r = self.controller.get_rows(sql, log_sql=False)
                if r is not None:
                    rows.extend(r)
                utils_giswater.set_item_data(self.dlg_go2epa_result.cmb_sel_time, rows)

            self.dlg_go2epa_result.rpt_selector_result_id.currentIndexChanged.connect(partial(
                self.populate_time, self.dlg_go2epa_result.rpt_selector_result_id, self.dlg_go2epa_result.cmb_sel_date))
            self.dlg_go2epa_result.cmb_sel_date.currentIndexChanged.connect(
                partial(self.populate_date_time, self.dlg_go2epa_result.rpt_selector_result_id, self.dlg_go2epa_result.cmb_sel_date,
                        self.dlg_go2epa_result.cmb_sel_time))

            # Populate GroupBox Selector compare
            result_id_to_comp = utils_giswater.get_item_data(self.dlg_go2epa_result, self.dlg_go2epa_result.rpt_selector_result_id, 0)
            sql = ("SELECT DISTINCT(resultdate), resultdate  FROM " + self.schema_name + ".rpt_arc "
                   " WHERE result_id ='" + str(result_id_to_comp) + "'"
                   " ORDER BY resultdate ")
            rows = self.controller.get_rows(sql, log_sql=False)
            if rows is not None:
                utils_giswater.set_item_data(self.dlg_go2epa_result.cmb_com_date, rows)
                selector_cmp_date = utils_giswater.get_item_data(self.dlg_go2epa_result, self.dlg_go2epa_result.cmb_com_date, 0)
                sql = ("SELECT DISTINCT(resulttime), resulttime  FROM " + self.schema_name + ".rpt_arc "
                       " WHERE result_id ='" + str(result_id_to_comp) + "'"
                       " AND resultdate='" + str(selector_cmp_date) + "'"
                       " ORDER BY resulttime")
                rows = [('', '')]
                r = self.controller.get_rows(sql, log_sql=False)
                if r is not None:
                    rows.extend(r)
                utils_giswater.set_item_data(self.dlg_go2epa_result.cmb_com_time, rows)

            self.dlg_go2epa_result.rpt_selector_result_id.currentIndexChanged.connect(partial(
                self.populate_time, self.dlg_go2epa_result.rpt_selector_result_id, self.dlg_go2epa_result.cmb_com_date))
            self.dlg_go2epa_result.cmb_sel_date.currentIndexChanged.connect(
                partial(self.populate_date_time, self.dlg_go2epa_result.rpt_selector_result_id, self.dlg_go2epa_result.cmb_com_date,
                        self.dlg_go2epa_result.cmb_com_time))


        # Get current data from tables 'rpt_selector_result' and 'rpt_selector_compare'
        sql = "SELECT result_id FROM " + self.schema_name + ".rpt_selector_result"
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.set_combo_itemData(self.dlg_go2epa_result.rpt_selector_result_id, row["result_id"], 0)
        sql = "SELECT result_id FROM " + self.schema_name + ".rpt_selector_compare"
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.set_combo_itemData(self.dlg_go2epa_result.rpt_selector_compare_id, row["result_id"], 0)

        # Open the dialog
        self.dlg_go2epa_result.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_go2epa_result.exec_()

    def populate_date_time(self, combo_result, combo_date, combo_time):
        result_id = utils_giswater.get_item_data(self.dlg_go2epa_result, combo_result)
        date = utils_giswater.get_item_data(self.dlg_go2epa_result, combo_date)
        sql = ("SELECT DISTINCT(resulttime), resulttime  FROM " + self.schema_name + ".rpt_arc "
               " WHERE result_id ='" + str(result_id) + "'"
               " AND resultdate='" + str(date) + "'"
               " ORDER BY resulttime")
        rows = [('', '')]
        r = self.controller.get_rows(sql, log_sql=False)
        if r is not None:
            rows.extend(r)
        utils_giswater.set_item_data(combo_time, rows)


    def populate_time(self, combo_result, combo_time):
        """ Populate combo times """
        result_id = utils_giswater.get_item_data(self.dlg_go2epa_result, combo_result)
        sql = ("SELECT DISTINCT time, time FROM " + self.schema_name + ".rpt_arc "
               " WHERE result_id ILIKE '"+str(result_id)+"' ORDER BY time")
        rows = [('', '')]
        rows.extend(self.controller.get_rows(sql))
        utils_giswater.set_item_data(combo_time, rows)


    def result_selector_accept(self):
        """ Update current values to the table """

        # Set project user
        user = self.controller.get_project_user()
        # Delete previous values
        sql = ("DELETE FROM " + self.schema_name + ".rpt_selector_result WHERE cur_user = '" + user + "';\n"
               "DELETE FROM " + self.schema_name + ".rpt_selector_compare WHERE cur_user = '" + user + "';\n")
        if self.project_type == 'ws':
            sql += ("DELETE FROM " + self.schema_name + ".rpt_selector_hourly WHERE cur_user = '" + user + "';\n"
                    "DELETE FROM " + self.schema_name + ".rpt_selector_hourly_compare "
                    " WHERE cur_user = '" + user + "';\n")
        if self.project_type == 'ud':
            sql += ("DELETE FROM " + self.schema_name + ".rpt_selector_timestep WHERE cur_user = '" + user + "';\n"
                    "DELETE FROM " + self.schema_name + ".rpt_selector_timestep_compare "
                    " WHERE cur_user = '" + user + "';\n")
        self.controller.execute_sql(sql, log_sql=False)

        # Get new values from widgets of type QComboBox
        rpt_selector_result_id = utils_giswater.get_item_data(self.dlg_go2epa_result, self.dlg_go2epa_result.rpt_selector_result_id)
        rpt_selector_compare_id = utils_giswater.get_item_data(self.dlg_go2epa_result, self.dlg_go2epa_result.rpt_selector_compare_id)
        if self.project_type == 'ws':
            time_to_show = utils_giswater.get_item_data(self.dlg_go2epa_result, self.dlg_go2epa_result.cmb_time_to_show)
            time_to_compare = utils_giswater.get_item_data(self.dlg_go2epa_result, self.dlg_go2epa_result.cmb_time_to_compare)

        if self.project_type == 'ud':
            date_to_show = utils_giswater.get_item_data(self.dlg_go2epa_result, self.dlg_go2epa_result.cmb_sel_date)
            time_to_show = utils_giswater.get_item_data(self.dlg_go2epa_result, self.dlg_go2epa_result.cmb_sel_time)
            date_to_compare = utils_giswater.get_item_data(self.dlg_go2epa_result, self.dlg_go2epa_result.cmb_com_date)
            time_to_compare = utils_giswater.get_item_data(self.dlg_go2epa_result, self.dlg_go2epa_result.cmb_com_time)

        if rpt_selector_result_id not in (None, -1, ''):
            sql = ("INSERT INTO " + self.schema_name + ".rpt_selector_result (result_id, cur_user)"
                   " VALUES ('" + str(rpt_selector_result_id) + "', '" + user + "');\n")
            self.controller.execute_sql(sql, log_sql=False)
        if rpt_selector_compare_id not in (None, -1, ''):
            sql = ("INSERT INTO " + self.schema_name + ".rpt_selector_compare (result_id, cur_user)"
                   " VALUES ('" + str(rpt_selector_compare_id) + "', '" + user + "');\n")
            self.controller.execute_sql(sql, log_sql=False)
        if self.project_type == 'ws':
            if time_to_show not in (None, -1, ''):
                sql = ("INSERT INTO " + self.schema_name + ".rpt_selector_hourly(time, cur_user)"
                       " VALUES ('" + str(time_to_show) + "', '" + user + "');\n")
                self.controller.execute_sql(sql, log_sql=False)
            if time_to_compare not in (None, -1, ''):
                sql = ("INSERT INTO " + self.schema_name + ".rpt_selector_hourly_compare(time, cur_user)"
                       " VALUES ('" + str(time_to_compare) + "', '" + user + "');\n")
                self.controller.execute_sql(sql, log_sql=False)

        if self.project_type == 'ud':
            if date_to_show not in (None, -1, ''):
                sql = ("INSERT INTO " + self.schema_name + ".rpt_selector_timestep(resultdate, resulttime, cur_user)"
                       " VALUES ('"+str(date_to_show)+"', '" + str(time_to_show) + "', '" + user + "');\n")
                self.controller.execute_sql(sql, log_sql=False)
            if date_to_compare not in (None, -1, ''):
                sql = ("INSERT INTO " + self.schema_name + ".rpt_selector_timestep_compare(resultdate, resulttime, cur_user)"
                       " VALUES ('"+str(date_to_compare)+"', '" + str(time_to_compare) + "', '" + user + "');\n")
                self.controller.execute_sql(sql, log_sql=False)

        # Show message to user
        message = "Values has been updated"
        self.controller.show_info(message)
        self.close_dialog(self.dlg_go2epa_result)


    def go2epa_options_get_data(self, tablename, dialog):
        """ Get data from selected table """

        sql = "SELECT * FROM " + self.schema_name + "." + tablename
        row = self.controller.get_row(sql, commit=True)
        if not row:
            message = "Any data found in table"
            self.controller.show_warning(message, parameter=tablename)
            return None

        # Iterate over all columns and populate its corresponding widget
        columns = []
        for i in range(0, len(row)):
            column_name = self.dao.get_column_name(i)
            widget = dialog.findChild(QWidget, column_name)
            widget_type = utils_giswater.getWidgetType(dialog, widget)
            if row[column_name] is not None:
                if widget_type is QCheckBox:
                    utils_giswater.setChecked(dialog, widget, row[column_name])
                elif widget_type is QComboBox:
                    utils_giswater.set_combo_itemData(widget, row[column_name], 0)
                elif widget_type is QDateEdit:
                    dateaux = row[column_name].replace('/', '-')
                    date = QDate.fromString(dateaux, 'dd-MM-yyyy')
                    utils_giswater.setCalendarDate(dialog, widget, date)
                elif widget_type is QTimeEdit:
                    timeparts = str(row[column_name]).split(':')
                    if len(timeparts) < 3:
                        timeparts.append("0")
                    days = int(timeparts[0]) / 24
                    hours = int(timeparts[0]) % 24
                    minuts = int(timeparts[1])
                    seconds = int(timeparts[2])
                    time = QTime(hours, minuts, seconds)
                    utils_giswater.setTimeEdit(dialog, widget, time)
                    utils_giswater.setText(dialog, column_name + "_day", days)
                else:
                    utils_giswater.setWidgetText(dialog, widget, str(row[column_name]))

            columns.append(column_name)

        return columns


    def go2epa_result_manager(self):
        """ Button 25: Epa result manager """

        # Create the dialog
        self.dlg_manager = EpaResultManager()
        self.load_settings(self.dlg_manager)

        # Fill combo box and table view
        self.fill_combo_result_id()
        self.dlg_manager.tbl_rpt_cat_result.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.fill_table(self.dlg_manager.tbl_rpt_cat_result, 'v_ui_rpt_cat_result')
        self.set_table_columns(self.dlg_manager, self.dlg_manager.tbl_rpt_cat_result, 'v_ui_rpt_cat_result')

        # Set signals
        self.dlg_manager.btn_delete.clicked.connect(partial(self.multi_rows_delete, self.dlg_manager.tbl_rpt_cat_result,
                                                            'rpt_cat_result', 'result_id'))
        self.dlg_manager.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_manager))
        self.dlg_manager.rejected.connect(partial(self.close_dialog, self.dlg_manager))
        self.dlg_manager.txt_result_id.textChanged.connect(self.filter_by_result_id)

        # Open form
        self.open_dialog(self.dlg_manager)


    def fill_combo_result_id(self):

        sql = "SELECT result_id FROM " + self.schema_name + ".v_ui_rpt_cat_result ORDER BY result_id"
        rows = self.controller.get_rows(sql, commit=True)
        utils_giswater.fillComboBox(self.dlg_manager, self.dlg_manager.txt_result_id, rows)


    def filter_by_result_id(self):

        table = self.dlg_manager.tbl_rpt_cat_result
        widget_txt = self.dlg_manager.txt_result_id
        tablename = 'v_ui_rpt_cat_result'
        result_id = utils_giswater.getWidgetText(self.dlg_manager, widget_txt)
        if result_id != 'null':
            expr = " result_id ILIKE '%" + result_id + "%'"
            # Refresh model with selected filter
            table.model().setFilter(expr)
            table.model().select()
        else:
            self.fill_table(table, tablename)


    def update_sql(self):
        usql = UpdateSQL(self.iface, self.settings, self.controller, self.plugin_dir)
        usql.init_sql()