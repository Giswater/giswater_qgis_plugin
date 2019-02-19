"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-

from PyQt4.QtCore import QTime, QDate, Qt
from PyQt4.QtGui import QAbstractItemView, QWidget, QCheckBox, QDateEdit, QTimeEdit, QComboBox, QStringListModel
from PyQt4.QtGui import QCompleter, QFileDialog

import csv
import os
import subprocess

from functools import partial

import utils_giswater
from giswater.actions.update_sql import UpdateSQL
from giswater.actions.api_go2epa_options import Go2EpaOptions
from giswater.actions.parent import ParentAction
from giswater.ui_manager import FileManager, Multirow_selector, HydrologySelector
from giswater.ui_manager import EpaResultCompareSelector, EpaResultManager


class Go2Epa(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'go2epa' """
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.g2epa_opt = Go2EpaOptions(iface, settings, controller, plugin_dir)


    def set_project_type(self, project_type):
        self.project_type = project_type


    def go2epa(self):
        """ Button 23: Open form to set INP, RPT and project """
        self.get_last_gsw_file()

        # Create dialog
        self.dlg_go2epa = FileManager()
        self.load_settings(self.dlg_go2epa)
        if self.project_type in 'ws':
            self.dlg_go2epa.chk_export_subcatch.setVisible(False)

        self.dlg_go2epa.progressBar.setMaximum(0)
        self.dlg_go2epa.progressBar.setMinimum(0)
        self.dlg_go2epa.progressBar.setVisible(False)
        # Set widgets
        self.dlg_go2epa.txt_file_inp.setText(self.file_inp)
        self.dlg_go2epa.txt_file_rpt.setText(self.file_rpt)
        self.dlg_go2epa.txt_result_name.setText(self.result_name)
        self.dlg_go2epa.chk_only_check.setChecked(False)
        self.dlg_go2epa.chk_only_check.setEnabled(False)

        # Set signals
        self.dlg_go2epa.txt_result_name.textChanged.connect(partial(self.check_result_id))
        self.dlg_go2epa.btn_file_inp.clicked.connect(self.go2epa_select_file_inp)
        self.dlg_go2epa.btn_file_rpt.clicked.connect(self.go2epa_select_file_rpt)
        self.dlg_go2epa.btn_accept.clicked.connect(self.go2epa_accept)
        self.dlg_go2epa.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_go2epa))
        self.dlg_go2epa.rejected.connect(partial(self.close_dialog, self.dlg_go2epa))
        self.dlg_go2epa.btn_options.clicked.connect(self.epa_options)
        if self.project_type == 'ws':
            self.dlg_go2epa.btn_hs_ds.setText("Dscenario Selector")
            tableleft = "cat_dscenario"
            tableright = "inp_selector_dscenario"
            field_id_left = "dscenario_id"
            field_id_right = "dscenario_id"
            self.dlg_go2epa.btn_hs_ds.clicked.connect(partial(self.sector_selection, tableleft, tableright, field_id_left, field_id_right))

        if self.project_type == 'ud':
            self.dlg_go2epa.btn_hs_ds.setText("Hydrology selector")
            self.dlg_go2epa.btn_hs_ds.clicked.connect(self.ud_hydrology_selector)

        # TODO es realmente result_id de la vista v_ui_rpt_cat_result lo que debemos comparar?
        self.set_completer_result(self.dlg_go2epa.txt_result_name, 'v_ui_rpt_cat_result', 'result_id')

        # Open dialog
        self.dlg_go2epa.show()

    def chk_control(self):
        if utils_giswater.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_import_result):
            file_rpt = utils_giswater.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_rpt)
            result_name = utils_giswater.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_result_name, False, False)
            msg = "RPT file not found"
            if file_rpt is not None:
                if not os.path.exists(file_rpt):
                    self.controller.show_warning(msg, parameter=str(file_rpt))
                    return False
            else:
                self.controller.show_warning(msg, parameter=str(file_rpt))
                return False
            if result_name == '':
                self.dlg_go2epa.txt_file_rpt.setStyleSheet("border: 1px solid red")
                msg = "This parameter is mandatory. Please, set a value"
                self.controller.show_details(msg, title="Rpt fail", inf_text=None)
                return False
            else:
                sql = ("SELECT result_id FROM " + self.schema_name + ".rpt_cat_result "
                       " WHERE result_id='"+str(result_name)+"' LIMIT 1")
                row = self.controller.get_row(sql, log_sql=True)
                self.controller.log_info("ROW: " + str(row))
                if row:
                    msg = "Result name already exists"
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


    def get_last_gsw_file(self, show_warning=True):
        """ Get last GSW file used by Giswater """
        
        # Initialize variables
        self.file_inp = None
        self.file_rpt = None
        self.project_name = None

        # Get last GSW file from giswater properties file
        self.set_java_settings(show_warning)
        # Check if that file exists
        message = "GSW file not found"
        if self.file_gsw is not None:
            if not os.path.exists(self.file_gsw):
                if show_warning:
                    self.controller.show_warning(message, parameter=str(self.file_gsw))
                return False
        else:
            if show_warning:
                self.controller.show_warning(message, parameter=str(self.file_gsw))
            return False
        # Get INP, RPT file path and project name from GSW file
        self.set_gsw_settings()
        self.file_inp = utils_giswater.get_settings_value(self.gsw_settings, 'FILE_INP')
        self.file_rpt = utils_giswater.get_settings_value(self.gsw_settings, 'FILE_RPT')
        self.result_name = self.gsw_settings.value('RESULT_NAME')
        
        return True
            

    def sector_selection(self, tableleft, tableright, field_id_left, field_id_right):
        """ Load the tables in the selection form """

        dlg_psector_sel = Multirow_selector()
        self.load_settings(dlg_psector_sel)
        dlg_psector_sel.btn_ok.clicked.connect(dlg_psector_sel.close)
        if tableleft == 'sector':
            dlg_psector_sel.setWindowTitle(" Sector selector")
            utils_giswater.setWidgetText(dlg_psector_sel, dlg_psector_sel.lbl_filter, self.controller.tr('Filter by: Sector name', context_name='labels'))
            utils_giswater.setWidgetText(dlg_psector_sel, dlg_psector_sel.lbl_unselected, self.controller.tr('Unselected sectors', context_name='labels'))
            utils_giswater.setWidgetText(dlg_psector_sel, dlg_psector_sel.lbl_selected, self.controller.tr('Selected sectors', context_name='labels'))
        if tableleft == 'cat_dscenario':
            dlg_psector_sel.setWindowTitle(" Dscenario selector")
            utils_giswater.setWidgetText(dlg_psector_sel, dlg_psector_sel.lbl_filter, self.controller.tr('Filter by: Dscenario name', context_name='labels'))
            utils_giswater.setWidgetText(dlg_psector_sel, dlg_psector_sel.lbl_unselected, self.controller.tr('Unselected dscenarios', context_name='labels'))
            utils_giswater.setWidgetText(dlg_psector_sel, dlg_psector_sel.lbl_selected, self.controller.tr('Selected dscenarios', context_name='labels'))
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
        self.dlg_hydrology_selector.txt_name.textChanged.connect(partial(self.filter_cbx_by_text, "cat_hydrology", self.dlg_hydrology_selector.txt_name, self.dlg_hydrology_selector.hydrology))

        sql = ("SELECT DISTINCT(name), hydrology_id FROM " + self.schema_name + ".cat_hydrology ORDER BY name")
        rows = self.controller.get_rows(sql)
        if not rows:
            message = "Any data found in table"
            self.controller.show_warning(message, parameter='cat_hydrology')
            return False
        
        utils_giswater.set_item_data(self.dlg_hydrology_selector.hydrology, rows)
 
        sql = ("SELECT DISTINCT(t1.name) FROM " + self.schema_name + ".cat_hydrology AS t1"
               " INNER JOIN " + self.schema_name + ".inp_selector_hydrology AS t2 ON t1.hydrology_id = t2.hydrology_id "
               " WHERE t2.cur_user = current_user")
        row = self.controller.get_row(sql)

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
        row = self.controller.get_row(sql)
        if row:
            sql = ("UPDATE " + self.schema_name + ".inp_selector_hydrology "
                   " SET hydrology_id = "+str(utils_giswater.get_item_data(self.dlg_hydrology_selector, self.dlg_hydrology_selector.hydrology, 1))+""
                   " WHERE cur_user = current_user")
        else:
            sql = ("INSERT INTO " + self.schema_name + ".inp_selector_hydrology (hydrology_id, cur_user)"
                   " VALUES('" +str(utils_giswater.get_item_data(self.dlg_hydrology_selector, self.dlg_hydrology_selector.hydrology, 1))+"', current_user)")
        self.controller.execute_sql(sql)
        message = "Values has been update"
        self.controller.show_info(message)
        self.close_dialog(self.dlg_hydrology_selector)


    def update_labels(self):
        """ Show text in labels from SELECT """
        
        sql = ("SELECT infiltration, text FROM " + self.schema_name + ".cat_hydrology"
               " WHERE name = '" + str(self.dlg_hydrology_selector.hydrology.currentText()) + "'")
        row = self.controller.get_row(sql)
        if row is not None:
            utils_giswater.setText(self.dlg_hydrology_selector, self.dlg_hydrology_selector.infiltration, row[0])
            utils_giswater.setText(self.dlg_hydrology_selector, self.dlg_hydrology_selector.descript, row[1])


    def filter_cbx_by_text(self, tablename, widgettxt, widgetcbx):
        
        sql = ("SELECT DISTINCT(name), hydrology_id FROM " + self.schema_name + "." + str(tablename) + ""
               " WHERE name LIKE '%" + str(widgettxt.text()) + "%'"
               " ORDER BY name ")
        rows = self.controller.get_rows(sql)
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
        if self.file_inp:
            self.dlg_go2epa.txt_file_inp.setText(self.file_inp)


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
        if self.file_rpt:
            self.dlg_go2epa.txt_file_rpt.setText(self.file_rpt)


    def insert_into_inp(self, folder_path=None, all_rows=None):
        progress = 0
        self.dlg_go2epa.progressBar.setFormat("The INP file is begin imported...")
        self.dlg_go2epa.progressBar.setAlignment(Qt.AlignCenter)
        self.dlg_go2epa.progressBar.setVisible(True)
        self.dlg_go2epa.progressBar.setValue(progress)
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
                    else:
                        line += "\t"
            line += "\n"
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
        self.dlg_go2epa.progressBar.setVisible(True)
        self.dlg_go2epa.progressBar.setValue(progress)
        row_count = sum(1 for rows in full_file)  # @UnusedVariable
        self.dlg_go2epa.progressBar.setMaximum(row_count)
        for row in full_file:
            progress += 1
            self.dlg_go2epa.progressBar.setValue(progress)
            sp_n = row.split(' ')
            for x in range(len(sp_n) - 1, -1, -1):
                if sp_n[x] == '' or "**" in sp_n[x] or "--" in sp_n[x]:
                    sp_n.pop(x)
            if len(sp_n) > 0:
                sql += "INSERT INTO " + self.schema_name + ".temp_csv2pg (csv2pgcat_id, "
                values = "VALUES(11, "
                for x in range(0, len(sp_n)):
                    if "''" not in sp_n[x]:
                        sql += "csv" + str(x+1) + ", "
                        value = "'" + sp_n[x].strip().replace("\n", "") + "', "
                        values += value.replace("''", "null")
                    else:
                        sql += "csv" + str(x+1) + ", "
                        values = "VALUES(null, "
                sql = sql[:-2]+") "
                values = values[:-2] + ");\n"
                sql += values
            if progress % 500 == 0:
                self.controller.execute_sql(sql, log_sql=False, commit=True)
                sql = ""
        self.controller.execute_sql(sql, log_sql=False, commit=True)
        _file.close()
        del _file

    def go2epa_accept(self):
        """ Save INP, RPT and result name into GSW file """
        self.dlg_go2epa.txt_file_rpt.setStyleSheet("border: 1px solid gray")
        status = self.chk_control()
        if not status:
            return

        self.dlg_go2epa.progressBar.setVisible(True)
        common_msg = ""
        # Get widgets values
        self.result_name = utils_giswater.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_result_name)
        prev_net_geom = utils_giswater.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_only_check)
        export_inp = utils_giswater.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export)
        export_subcatch = utils_giswater.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export_subcatch)
        self.file_inp = utils_giswater.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_inp)
        exec_epa = utils_giswater.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_exec)
        self.file_rpt = utils_giswater.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_rpt)
        import_result = utils_giswater.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_import_result)

        if self.result_name is 'null':
            message = "You have to set this parameter"
            self.controller.show_warning(message, parameter="Result Name")
            return

        if self.project_type in 'ws':
            opener = self.plugin_dir + "/epa/ws_epanet20012.exe"
            epa_function_call = "gw_fct_pg2epa($$"+str(self.result_name)+"$$, "+str(prev_net_geom)+")"
        elif self.project_type in 'ud':
            opener = self.plugin_dir + "/epa/ud_swmm50022.exe"
            epa_function_call = "gw_fct_pg2epa($$" + str(self.result_name) + "$$, " + str(prev_net_geom) + ", "+str(export_subcatch)+")"
        export_function = "gw_fct_utils_csv2pg_export_epa_inp('" + str(self.result_name) + "')"

        # Export to inp file
        if export_inp is True:
            # Check that all parameters has been set
            if self.file_inp == "null":
                message = "You have to set this parameter"
                self.controller.show_warning(message, parameter="INP file")
                return
            # Call function gw_fct_pg2epa
            sql = ("SELECT " + self.schema_name + "." + epa_function_call)
            row = self.controller.get_row(sql, log_sql=True)

            # Call function gw_fct_utils_csv2pg_export_epa_inp
            sql = ("SELECT " + self.schema_name + "." + export_function)
            row = self.controller.get_row(sql, log_sql=True)

            # Get values from temp_csv2pg and insert into INP file
            sql = ("SELECT csv1, csv2, csv3, csv4, csv5, csv6, csv7, csv8, csv9, csv10, csv11, csv12 "
                   " FROM " + self.schema_name + ".temp_csv2pg "
                   " WHERE csv2pgcat_id=10 AND user_name = current_user ORDER BY id")
            rows = self.controller.get_rows(sql, log_sql=True)
            if rows is None:
                self.controller.show_message("NOT ROW FOR: " + sql, 2)
                self.dlg_go2epa.progressBar.setVisible(False)
                return
            self.insert_into_inp(self.file_inp, rows)
            common_msg += "Export INP finished. \t"

        # Execute epa
        if exec_epa is True:
            if self.file_rpt == "null":
                message = "You have to set this parameter"
                self.controller.show_warning(message, parameter="RPT file")
                self.dlg_go2epa.progressBar.setVisible(False)
                return
            self.dlg_go2epa.progressBar.setMaximum(0)
            self.dlg_go2epa.progressBar.setMinimum(0)
            self.dlg_go2epa.progressBar.setFormat("Epa software is running...")
            self.dlg_go2epa.progressBar.setAlignment(Qt.AlignCenter)
            self.dlg_go2epa.progressBar.setVisible(True)
            subprocess.call([opener, self.file_inp, self.file_rpt])
            common_msg += "EPA model finished. \t"

        # Import to DB
        if import_result is True:
            if os.path.exists(self.file_rpt):
                sql = ("DELETE FROM " + self.schema_name + ".temp_csv2pg "
                       " WHERE user_name=current_user AND csv2pgcat_id=11")
                self.controller.execute_sql(sql, log_sql=True)
                self.insert_rpt_into_db(self.file_rpt)
                common_msg += "Import RPT finished."
            else:
                msg = "Can't export rpt, File not found"
                self.controller.show_warning(msg, parameter=self.file_rpt)
        if common_msg is not None:
            self.controller.show_info(common_msg)

        # Save INP, RPT and result name into GSW file
        self.save_file_parameters()

        self.dlg_go2epa.progressBar.setVisible(False)
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

        sql = ("SELECT "+field_name+" FROM " + self.schema_name + "." + viewname)
        rows = self.controller.get_rows(sql, log_sql=False)

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
        row = self.controller.get_row(sql)
        if not row:
            self.dlg_go2epa.chk_only_check.setChecked(False)
            self.dlg_go2epa.chk_only_check.setEnabled(False)
        else:
            self.dlg_go2epa.chk_only_check.setEnabled(True)
            
                    
    def check_data(self):
        """ Check data executing function 'gw_fct_pg2epa' """
        
        sql = "SELECT " + self.schema_name + ".gw_fct_pg2epa('" + str(self.project_name) + "', 'True');"  
        row = self.controller.get_row(sql, log_sql=False)
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
        rows = self.controller.get_rows(sql, log_sql=False)
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

        self.dlg_go2epa_result.btn_accept.clicked.connect(self.result_selector_accept)
        self.dlg_go2epa_result.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_go2epa_result))
        self.dlg_go2epa_result.rejected.connect(partial(self.close_dialog, self.dlg_go2epa_result))

        # Set values from widgets of type QComboBox
        sql = "SELECT DISTINCT(result_id) FROM " + self.schema_name + ".v_ui_rpt_cat_result ORDER BY result_id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_go2epa_result, self.dlg_go2epa_result.rpt_selector_result_id, rows)
        utils_giswater.fillComboBox(self.dlg_go2epa_result, self.dlg_go2epa_result.rpt_selector_compare_id, rows)

        # Get current data from tables 'rpt_selector_result' and 'rpt_selector_compare'
        sql = "SELECT result_id FROM " + self.schema_name + ".rpt_selector_result"
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(self.dlg_go2epa_result, self.dlg_go2epa_result.rpt_selector_result_id, row["result_id"])
        sql = "SELECT result_id FROM " + self.schema_name + ".rpt_selector_compare"
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(self.dlg_go2epa_result, self.dlg_go2epa_result.rpt_selector_compare_id, row["result_id"])

        # Open the dialog
        self.dlg_go2epa_result.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_go2epa_result.exec_()


    def result_selector_accept(self):
        """ Update current values to the table """

        # Get new values from widgets of type QComboBox
        rpt_selector_result_id = utils_giswater.getWidgetText(self.dlg_go2epa_result, self.dlg_go2epa_result.rpt_selector_result_id)
        rpt_selector_compare_id = utils_giswater.getWidgetText(self.dlg_go2epa_result, self.dlg_go2epa_result.rpt_selector_compare_id)

        # Set project user
        user = self.controller.get_project_user()

        # Delete previous values
        # Set new values to tables 'rpt_selector_result' and 'rpt_selector_compare'
        sql = ("DELETE FROM " + self.schema_name + ".rpt_selector_result;\n"
               "DELETE FROM " + self.schema_name + ".rpt_selector_compare;\n"
               "INSERT INTO " + self.schema_name + ".rpt_selector_result (result_id, cur_user)"
               " VALUES ('" + rpt_selector_result_id + "', '" + user + "');\n"
               "INSERT INTO " + self.schema_name + ".rpt_selector_compare (result_id, cur_user)"
               " VALUES ('" + rpt_selector_compare_id + "', '" + user + "');")
        self.controller.execute_sql(sql)

        # Show message to user
        message = "Values has been updated"
        self.controller.show_info(message)
        self.close_dialog(self.dlg_go2epa_result)


    def go2epa_options_get_data(self, tablename, dialog):
        """ Get data from selected table """
        
        sql = "SELECT * FROM " + self.schema_name + "." + tablename
        row = self.controller.get_row(sql)
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
        rows = self.controller.get_rows(sql)
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