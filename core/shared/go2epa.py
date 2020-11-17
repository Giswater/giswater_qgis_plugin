"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
import sys
from functools import partial

from qgis.PyQt.QtCore import QDate, QStringListModel, QTime, Qt
from qgis.PyQt.QtSql import QSqlQueryModel
from qgis.PyQt.QtWidgets import QWidget, QCheckBox, QDateEdit, QTimeEdit, QComboBox, QCompleter, QFileDialog, \
    QTableView, QAbstractItemView
from qgis.core import QgsApplication

from .go2epa_options import GwGo2EpaOptions
from ..btn_admin import GwAdmin
from ..tasks.task_go2epa import GwGo2EpaTask
from ..ui.ui_manager import Go2EpaUI, HydrologySelector, Multirow_selector
from ..utils import tools_gw
from ... import global_vars
from ...lib import tools_qgis, tools_qt


class GwGo2Epa:

    def __init__(self):
        """ Class to control toolbar 'go2epa' """

        self.g2epa_opt = GwGo2EpaOptions()
        self.iterations = 0
        self.controller = global_vars.controller
        self.project_type = self.controller.get_project_type()
        self.plugin_dir = global_vars.plugin_dir


    def go2epa(self):
        """ Button 23: Open form to set INP, RPT and project """

        # Show form in docker?
        self.controller.init_docker('qgis_form_docker')

        # Create dialog
        self.dlg_go2epa = Go2EpaUI()
        tools_gw.load_settings(self.dlg_go2epa)
        self.load_user_values()
        if self.project_type in 'ws':
            self.dlg_go2epa.chk_export_subcatch.setVisible(False)

        # Set signals
        self.set_signals()

        if self.project_type == 'ws':
            tableleft = "cat_dscenario"
            tableright = "selector_inp_demand"
            field_id_left = "dscenario_id"
            field_id_right = "dscenario_id"
            self.dlg_go2epa.btn_hs_ds.clicked.connect(
                partial(self.sector_selection, tableleft, tableright, field_id_left, field_id_right, aql=""))

        elif self.project_type == 'ud':
            self.dlg_go2epa.btn_hs_ds.clicked.connect(self.ud_hydrology_selector)

        # Check OS and enable/disable checkbox execute EPA software
        if sys.platform != "win32":
            tools_qt.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_exec, False)
            self.dlg_go2epa.chk_exec.setEnabled(False)
            self.dlg_go2epa.chk_exec.setText('Execute EPA software (Runs only on Windows)')

        self.set_completer_result(self.dlg_go2epa.txt_result_name, 'v_ui_rpt_cat_result', 'result_id')

        if self.controller.dlg_docker:
            self.controller.manage_translation('go2epa', self.dlg_go2epa)
            self.controller.dock_dialog(self.dlg_go2epa)
            self.dlg_go2epa.btn_cancel.clicked.disconnect()
            self.dlg_go2epa.btn_cancel.clicked.connect(self.controller.close_docker)
        else:
            tools_gw.open_dialog(self.dlg_go2epa, dlg_name='go2epa')


    def set_signals(self):

        self.dlg_go2epa.txt_result_name.textChanged.connect(partial(self.check_result_id))
        self.dlg_go2epa.btn_file_inp.clicked.connect(self.go2epa_select_file_inp)
        self.dlg_go2epa.btn_file_rpt.clicked.connect(self.go2epa_select_file_rpt)
        self.dlg_go2epa.btn_accept.clicked.connect(self.go2epa_accept)
        self.dlg_go2epa.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_go2epa))
        self.dlg_go2epa.rejected.connect(partial(tools_gw.close_dialog, self.dlg_go2epa))
        self.dlg_go2epa.btn_options.clicked.connect(self.epa_options)


    def check_inp_chk(self, file_inp):

        if file_inp is None:
            msg = "Select valid INP file"
            tools_gw.show_warning(msg, parameter=str(file_inp))
            return False


    def check_rpt(self):

        file_inp = tools_qt.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_inp)
        file_rpt = tools_qt.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_rpt)

        # Control execute epa software
        if tools_qt.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_exec):
            if self.check_inp_chk(file_inp) is False:
                return False

            if file_rpt is None:
                msg = "Select valid RPT file"
                tools_gw.show_warning(msg, parameter=str(file_rpt))
                return False

            if not tools_qt.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export):
                if not os.path.exists(file_inp):
                    msg = "File INP not found"
                    tools_gw.show_warning(msg, parameter=str(file_rpt))
                    return False


    def check_fields(self):

        file_inp = tools_qt.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_inp)
        file_rpt = tools_qt.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_rpt)
        result_name = tools_qt.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_result_name, False, False)

        # Check if at least one process is selected
        export_checked = tools_qt.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export)
        exec_checked = tools_qt.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_exec)
        import_result_checked = tools_qt.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_import_result)

        if not export_checked and not exec_checked and not import_result_checked:
            msg = "You need to select at least one process"
            self.controller.show_info_box(msg, title="Go2Epa")
            return False

        # Control export INP
        if tools_qt.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export):
            if self.check_inp_chk(file_inp) is False:
                return False

        # Control execute epa software
        if self.check_rpt() is False:
            return False

        # Control import result
        if tools_qt.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_import_result):
            if file_rpt is None:
                msg = "Select valid RPT file"
                tools_gw.show_warning(msg, parameter=str(file_rpt))
                return False
            if not tools_qt.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_exec):
                if not os.path.exists(file_rpt):
                    msg = "File RPT not found"
                    tools_gw.show_warning(msg, parameter=str(file_rpt))
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

        sql = (f"SELECT result_id FROM rpt_cat_result "
               f"WHERE result_id = '{result_name}' LIMIT 1")
        row = self.controller.get_row(sql)
        if row:
            msg = "Result name already exists, do you want overwrite?"
            answer = self.controller.ask_question(msg, title="Alert")
            if not answer:
                return False

        return True


    def load_user_values(self):
        """ Load QGIS settings related with file_manager """

        self.dlg_go2epa.txt_result_name.setMaxLength(16)
        self.result_name = tools_gw.get_parser_value('go2epa', 'go2epa_RESULT_NAME')
        self.dlg_go2epa.txt_result_name.setText(self.result_name)
        self.file_inp = tools_gw.get_parser_value('go2epa', 'go2epa_FILE_INP')
        self.dlg_go2epa.txt_file_inp.setText(self.file_inp)
        self.file_rpt = tools_gw.get_parser_value('go2epa', 'go2epa_FILE_RPT')
        self.dlg_go2epa.txt_file_rpt.setText(self.file_rpt)

        value = tools_gw.get_parser_value('go2epa', 'go2epa_chk_NETWORK_GEOM')
        tools_qt.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_only_check, value)
        value = tools_gw.get_parser_value('go2epa', 'go2epa_chk_INP')
        tools_qt.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export, value)
        value = tools_gw.get_parser_value('go2epa', 'go2epa_chk_UD')
        tools_qt.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export_subcatch, value)
        value = tools_gw.get_parser_value('go2epa', 'go2epa_chk_EPA')
        tools_qt.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_exec, value)
        value = tools_gw.get_parser_value('go2epa', 'go2epa_chk_RPT')
        tools_qt.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_import_result, value)


    def save_user_values(self):
        """ Save QGIS settings related with file_manager """

        tools_gw.set_parser_value('go2epa', 'go2epa_RESULT_NAME',
                         f"{tools_qt.getWidgetText(self.dlg_go2epa, 'txt_result_name', return_string_null=False)}")
        tools_gw.set_parser_value('go2epa', 'go2epa_FILE_INP',
                         f"{tools_qt.getWidgetText(self.dlg_go2epa, 'txt_file_inp', return_string_null=False)}")
        tools_gw.set_parser_value('go2epa', 'go2epa_FILE_RPT',
                         f"{tools_qt.getWidgetText(self.dlg_go2epa, 'txt_file_rpt', return_string_null=False)}")
        tools_gw.set_parser_value('go2epa', 'go2epa_chk_NETWORK_GEOM',
                         f"{tools_qt.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_only_check)}")
        tools_gw.set_parser_value('go2epa', 'go2epa_chk_INP',
                         f"{tools_qt.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export)}")
        tools_gw.set_parser_value('go2epa', 'go2epa_chk_UD',
                         f"{tools_qt.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export_subcatch)}")
        tools_gw.set_parser_value('go2epa', 'go2epa_chk_EPA',
                         f"{tools_qt.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_exec)}")
        tools_gw.set_parser_value('go2epa', 'go2epa_chk_RPT',
                         f"{tools_qt.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_import_result)}")


    def sector_selection(self, tableleft, tableright, field_id_left, field_id_right, aql=""):
        """ Load the tables in the selection form """

        dlg_psector_sel = Multirow_selector('dscenario')
        tools_gw.load_settings(dlg_psector_sel)
        dlg_psector_sel.btn_ok.clicked.connect(dlg_psector_sel.close)

        if tableleft == 'cat_dscenario':
            dlg_psector_sel.setWindowTitle(" Dscenario selector")
            tools_qt.setWidgetText(dlg_psector_sel, dlg_psector_sel.lbl_filter,
                                   tools_gw.tr('Filter by: Dscenario name', context_name='labels'))
            tools_qt.setWidgetText(dlg_psector_sel, dlg_psector_sel.lbl_unselected,
                                   tools_gw.tr('Unselected dscenarios', context_name='labels'))
            tools_qt.setWidgetText(dlg_psector_sel, dlg_psector_sel.lbl_selected,
                                   tools_gw.tr('Selected dscenarios', context_name='labels'))

        self.multi_row_selector(dlg_psector_sel, tableleft, tableright, field_id_left, field_id_right, aql=aql)

        tools_gw.open_dialog(dlg_psector_sel)


    def epa_options(self):
        """ Open dialog api_epa_options.ui.ui """

        self.g2epa_opt.go2epa_options()
        return


    def ud_hydrology_selector(self):
        """ Dialog hydrology_selector.ui """

        self.dlg_hydrology_selector = HydrologySelector()
        tools_gw.load_settings(self.dlg_hydrology_selector)

        self.dlg_hydrology_selector.btn_accept.clicked.connect(self.save_hydrology)
        self.dlg_hydrology_selector.hydrology.currentIndexChanged.connect(self.update_labels)
        self.dlg_hydrology_selector.txt_name.textChanged.connect(
            partial(self.filter_cbx_by_text, "cat_hydrology", self.dlg_hydrology_selector.txt_name,
                    self.dlg_hydrology_selector.hydrology))

        sql = "SELECT DISTINCT(name), hydrology_id FROM cat_hydrology ORDER BY name"
        rows = self.controller.get_rows(sql)
        if not rows:
            message = "Any data found in table"
            tools_gw.show_warning(message, parameter='cat_hydrology')
            return False

        tools_qt.fill_combo_values(self.dlg_hydrology_selector.hydrology, rows)

        sql = ("SELECT DISTINCT(t1.name) FROM cat_hydrology AS t1 "
               "INNER JOIN selector_inp_hydrology AS t2 ON t1.hydrology_id = t2.hydrology_id "
               "WHERE t2.cur_user = current_user")
        row = self.controller.get_row(sql)
        if row:
            tools_qt.setWidgetText(self.dlg_hydrology_selector, self.dlg_hydrology_selector.hydrology, row[0])
        else:
            tools_qt.setWidgetText(self.dlg_hydrology_selector, self.dlg_hydrology_selector.hydrology, 0)

        self.update_labels()
        tools_gw.open_dialog(self.dlg_hydrology_selector)


    def save_hydrology(self):

        hydrology_id = tools_qt.get_combo_value(self.dlg_hydrology_selector, self.dlg_hydrology_selector.hydrology, 1)
        sql = ("SELECT cur_user FROM selector_inp_hydrology "
               "WHERE cur_user = current_user")
        row = self.controller.get_row(sql)
        if row:
            sql = (f"UPDATE selector_inp_hydrology "
                   f"SET hydrology_id = {hydrology_id} "
                   f"WHERE cur_user = current_user")
        else:
            sql = (f"INSERT INTO selector_inp_hydrology (hydrology_id, cur_user) "
                   f"VALUES('{hydrology_id}', current_user)")
        self.controller.execute_sql(sql)

        message = "Values has been update"
        tools_gw.show_info(message)
        tools_gw.close_dialog(self.dlg_hydrology_selector)


    def update_labels(self):
        """ Show text in labels from SELECT """

        sql = (f"SELECT infiltration, text FROM cat_hydrology"
               f" WHERE name = '{self.dlg_hydrology_selector.hydrology.currentText()}'")
        row = self.controller.get_row(sql)
        if row is not None:
            tools_qt.setWidgetText(self.dlg_hydrology_selector, self.dlg_hydrology_selector.infiltration, row[0])
            tools_qt.setWidgetText(self.dlg_hydrology_selector, self.dlg_hydrology_selector.descript, row[1])


    def filter_cbx_by_text(self, tablename, widgettxt, widgetcbx):

        sql = (f"SELECT DISTINCT(name), hydrology_id FROM {tablename}"
               f" WHERE name LIKE '%{widgettxt.text()}%'"
               f" ORDER BY name ")
        rows = self.controller.get_rows(sql)
        if not rows:
            message = "Check the table 'cat_hydrology' "
            tools_gw.show_warning(message)
            return False
        tools_qt.fill_combo_values(widgetcbx, rows)
        self.update_labels()


    def go2epa_select_file_inp(self):
        """ Select INP file """

        self.file_inp = tools_qt.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_inp)
        # Set default value if necessary
        if self.file_inp is None or self.file_inp == '':
            self.file_inp = global_vars.plugin_dir

        # Get directory of that file
        folder_path = os.path.dirname(self.file_inp)
        if not os.path.exists(folder_path):
            folder_path = os.path.dirname(__file__)
        os.chdir(folder_path)
        message = tools_gw.tr("Select INP file")
        widget_is_checked = tools_qt.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export)
        if widget_is_checked:
            self.file_inp, filter_ = QFileDialog.getSaveFileName(None, message, "", '*.inp')
        else:
            self.file_inp, filter_ = QFileDialog.getOpenFileName(None, message, "", '*.inp')
        tools_qt.setWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_inp, self.file_inp)


    def go2epa_select_file_rpt(self):
        """ Select RPT file """

        # Set default value if necessary
        if self.file_rpt is None or self.file_rpt == '':
            self.file_rpt = global_vars.plugin_dir

        # Get directory of that file
        folder_path = os.path.dirname(self.file_rpt)
        if not os.path.exists(folder_path):
            folder_path = os.path.dirname(__file__)
        os.chdir(folder_path)
        message = tools_gw.tr("Select RPT file")
        widget_is_checked = tools_qt.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export)
        if widget_is_checked:
            self.file_rpt, filter_ = QFileDialog.getSaveFileName(None, message, "", '*.rpt')
        else:
            self.file_rpt, filter_ = QFileDialog.getOpenFileName(None, message, "", '*.rpt')
        tools_qt.setWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_rpt, self.file_rpt)


    def go2epa_accept(self):
        """ Save INP, RPT and result name into GSW file """

        # Save user values
        self.save_user_values()

        self.dlg_go2epa.txt_infolog.clear()
        self.dlg_go2epa.txt_file_rpt.setStyleSheet(None)
        status = self.check_fields()
        if status is False:
            return

        # Get widgets values
        self.result_name = tools_qt.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_result_name, False, False)
        self.net_geom = tools_qt.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_only_check)
        self.export_inp = tools_qt.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export)
        self.export_subcatch = tools_qt.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export_subcatch)
        self.file_inp = tools_qt.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_inp)
        self.exec_epa = tools_qt.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_exec)
        self.file_rpt = tools_qt.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_rpt)
        self.import_result = tools_qt.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_import_result)

        # Check for sector selector
        if self.export_inp:
            sql = "SELECT sector_id FROM selector_sector LIMIT 1"
            row = self.controller.get_row(sql)
            if row is None:
                msg = "You need to select some sector"
                self.controller.show_info_box(msg)
                return

        # Set background task 'Go2Epa'
        description = f"Go2Epa"
        self.task_go2epa = GwGo2EpaTask(description, self)
        QgsApplication.taskManager().addTask(self.task_go2epa)
        QgsApplication.taskManager().triggerTask(self.task_go2epa)


    def set_completer_result(self, widget, viewname, field_name):
        """ Set autocomplete of widget 'feature_id'
            getting id's from selected @viewname
        """

        result_name = tools_qt.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_result_name)

        # Adding auto-completion to a QLineEdit
        self.completer = QCompleter()
        self.completer.setCaseSensitivity(Qt.CaseInsensitive)
        widget.setCompleter(self.completer)
        model = QStringListModel()

        sql = f"SELECT {field_name} FROM {viewname}"
        rows = self.controller.get_rows(sql)

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

        result_id = tools_qt.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_result_name)
        sql = (f"SELECT result_id FROM v_ui_rpt_cat_result"
               f" WHERE result_id = '{result_id}'")
        row = self.controller.get_row(sql, log_info=False)
        if not row:
            self.dlg_go2epa.chk_only_check.setChecked(False)
            self.dlg_go2epa.chk_only_check.setEnabled(False)
        else:
            self.dlg_go2epa.chk_only_check.setEnabled(True)


    def go2epa_options_get_data(self, tablename, dialog):
        """ Get data from selected table """

        sql = f"SELECT * FROM {tablename}"
        row = self.controller.get_row(sql)
        if not row:
            message = "Any data found in table"
            tools_gw.show_warning(message, parameter=tablename)
            return None

        # Iterate over all columns and populate its corresponding widget
        columns = []
        for i in range(0, len(row)):
            column_name = self.controller.dao.get_column_name(i)
            widget = dialog.findChild(QWidget, column_name)
            widget_type = tools_qt.getWidgetType(dialog, widget)
            if row[column_name] is not None:
                if widget_type is QCheckBox:
                    tools_qt.setChecked(dialog, widget, row[column_name])
                elif widget_type is QComboBox:
                    tools_qt.set_combo_value(widget, row[column_name], 0)
                elif widget_type is QDateEdit:
                    dateaux = row[column_name].replace('/', '-')
                    date = QDate.fromString(dateaux, 'dd-MM-yyyy')
                    tools_qt.setCalendarDate(dialog, widget, date)
                elif widget_type is QTimeEdit:
                    timeparts = str(row[column_name]).split(':')
                    if len(timeparts) < 3:
                        timeparts.append("0")
                    days = int(timeparts[0]) / 24
                    hours = int(timeparts[0]) % 24
                    minuts = int(timeparts[1])
                    seconds = int(timeparts[2])
                    time = QTime(hours, minuts, seconds)
                    tools_qt.setTimeEdit(dialog, widget, time)
                    tools_qt.setWidgetText(dialog, column_name + "_day", days)
                else:
                    tools_qt.setWidgetText(dialog, widget, str(row[column_name]))

            columns.append(column_name)

        return columns


    def update_sql(self):
        usql = GwAdmin()
        usql.init_sql()


    def multi_row_selector(self, dialog, tableleft, tableright, field_id_left, field_id_right, name='name',
                           hide_left=[0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22,
                                      23, 24, 25, 26, 27, 28, 29, 30], hide_right=[1, 2, 3], aql=""):
        """
        :param dialog:
        :param tableleft: Table to consult and load on the left side
        :param tableright: Table to consult and load on the right side
        :param field_id_left: ID field of the left table
        :param field_id_right: ID field of the right table
        :param name: field name (used in add_lot.py)
        :param hide_left: Columns to hide from the left table
        :param hide_right: Columns to hide from the right table
        :param aql: (add query left) Query added to the left side (used in basic.py def basic_exploitation_selector())
        :return:
        """

        # fill QTableView all_rows
        tbl_all_rows = dialog.findChild(QTableView, "all_rows")
        tbl_all_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
        schema_name = global_vars.schema_name.replace('"', '')
        query_left = f"SELECT * FROM {schema_name}.{tableleft} WHERE {name} NOT IN "
        query_left += f"(SELECT {schema_name}.{tableleft}.{name} FROM {schema_name}.{tableleft}"
        query_left += f" RIGHT JOIN {schema_name}.{tableright} ON {tableleft}.{field_id_left} = {tableright}.{field_id_right}"
        query_left += f" WHERE cur_user = current_user)"
        query_left += f" AND  {field_id_left} > -1"
        query_left += aql

        self.fill_table_by_query(tbl_all_rows, query_left + f" ORDER BY {name};")
        self.hide_colums(tbl_all_rows, hide_left)
        tbl_all_rows.setColumnWidth(1, 200)

        # fill QTableView selected_rows
        tbl_selected_rows = dialog.findChild(QTableView, "selected_rows")
        tbl_selected_rows.setSelectionBehavior(QAbstractItemView.SelectRows)

        query_right = f"SELECT {tableleft}.{name}, cur_user, {tableleft}.{field_id_left}, {tableright}.{field_id_right}"
        query_right += f" FROM {schema_name}.{tableleft}"
        query_right += f" JOIN {schema_name}.{tableright} ON {tableleft}.{field_id_left} = {tableright}.{field_id_right}"

        query_right += " WHERE cur_user = current_user"

        self.fill_table_by_query(tbl_selected_rows, query_right + f" ORDER BY {name};")
        self.hide_colums(tbl_selected_rows, hide_right)
        tbl_selected_rows.setColumnWidth(0, 200)

        # Button select
        dialog.btn_select.clicked.connect(partial(self.multi_rows_selector, tbl_all_rows, tbl_selected_rows,
                                                  field_id_left, tableright, field_id_right, query_left, query_right,
                                                  field_id_right))

        # Button unselect
        query_delete = f"DELETE FROM {schema_name}.{tableright}"
        query_delete += f" WHERE current_user = cur_user AND {tableright}.{field_id_right}="
        dialog.btn_unselect.clicked.connect(partial(self.unselector, tbl_all_rows, tbl_selected_rows, query_delete,
                                                    query_left, query_right, field_id_right))

        # QLineEdit
        dialog.txt_name.textChanged.connect(partial(self.query_like_widget_text, dialog, dialog.txt_name,
                                                    tbl_all_rows, tableleft, tableright, field_id_right, field_id_left,
                                                    name, aql))

        # Order control
        tbl_all_rows.horizontalHeader().sectionClicked.connect(partial(self.order_by_column, tbl_all_rows, query_left))
        tbl_selected_rows.horizontalHeader().sectionClicked.connect(
            partial(self.order_by_column, tbl_selected_rows, query_right))


    def order_by_column(self, qtable, query, idx):
        """
        :param qtable: QTableView widget
        :param query: Query for populate QsqlQueryModel
        :param idx: The index of the clicked column
        :return:
        """
        oder_by = {0: "ASC", 1: "DESC"}
        sort_order = qtable.horizontalHeader().sortIndicatorOrder()
        col_to_sort = qtable.model().headerData(idx, Qt.Horizontal)
        query += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
        self.fill_table_by_query(qtable, query)
        tools_qgis.refresh_map_canvas()


    def hide_colums(self, widget, comuns_to_hide):
        for i in range(0, len(comuns_to_hide)):
            widget.hideColumn(comuns_to_hide[i])


    def unselector(self, qtable_left, qtable_right, query_delete, query_left, query_right, field_id_right):

        selected_list = qtable_right.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_gw.show_warning(message)
            return
        expl_id = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = str(qtable_right.model().record(row).value(field_id_right))
            expl_id.append(id_)
        for i in range(0, len(expl_id)):
            global_vars.controller.execute_sql(query_delete + str(expl_id[i]))

        # Refresh
        oder_by = {0: "ASC", 1: "DESC"}
        sort_order = qtable_left.horizontalHeader().sortIndicatorOrder()
        idx = qtable_left.horizontalHeader().sortIndicatorSection()
        col_to_sort = qtable_left.model().headerData(idx, Qt.Horizontal)
        query_left += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
        self.fill_table_by_query(qtable_left, query_left)

        sort_order = qtable_right.horizontalHeader().sortIndicatorOrder()
        idx = qtable_right.horizontalHeader().sortIndicatorSection()
        col_to_sort = qtable_right.model().headerData(idx, Qt.Horizontal)
        query_right += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
        self.fill_table_by_query(qtable_right, query_right)
        tools_qgis.refresh_map_canvas()


    def multi_rows_selector(self, qtable_left, qtable_right, id_ori,
                            tablename_des, id_des, query_left, query_right, field_id):
        """
            :param qtable_left: QTableView origin
            :param qtable_right: QTableView destini
            :param id_ori: Refers to the id of the source table
            :param tablename_des: table destini
            :param id_des: Refers to the id of the target table, on which the query will be made
            :param query_right:
            :param query_left:
            :param field_id:
        """

        selected_list = qtable_left.selectionModel().selectedRows()

        if len(selected_list) == 0:
            message = "Any record selected"
            tools_gw.show_warning(message)
            return
        expl_id = []
        curuser_list = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = qtable_left.model().record(row).value(id_ori)
            expl_id.append(id_)
            curuser = qtable_left.model().record(row).value("cur_user")
            curuser_list.append(curuser)
        for i in range(0, len(expl_id)):
            # Check if expl_id already exists in expl_selector
            sql = (f"SELECT DISTINCT({id_des}, cur_user)"
                   f" FROM {tablename_des}"
                   f" WHERE {id_des} = '{expl_id[i]}' AND cur_user = current_user")
            row = global_vars.controller.get_row(sql)

            if row:
                # if exist - show warning
                message = "Id already selected"
                global_vars.controller.show_info_box(message, "Info", parameter=str(expl_id[i]))
            else:
                sql = (f"INSERT INTO {tablename_des} ({field_id}, cur_user) "
                       f" VALUES ({expl_id[i]}, current_user)")
                global_vars.controller.execute_sql(sql)

        # Refresh
        oder_by = {0: "ASC", 1: "DESC"}
        sort_order = qtable_left.horizontalHeader().sortIndicatorOrder()
        idx = qtable_left.horizontalHeader().sortIndicatorSection()
        col_to_sort = qtable_left.model().headerData(idx, Qt.Horizontal)
        query_left += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
        self.fill_table_by_query(qtable_right, query_right)

        sort_order = qtable_right.horizontalHeader().sortIndicatorOrder()
        idx = qtable_right.horizontalHeader().sortIndicatorSection()
        col_to_sort = qtable_right.model().headerData(idx, Qt.Horizontal)
        query_right += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
        self.fill_table_by_query(qtable_left, query_left)
        tools_qgis.refresh_map_canvas()


    def fill_table_by_query(self, qtable, query):
        """
        :param qtable: QTableView to show
        :param query: query to set model
        """

        model = QSqlQueryModel()
        model.setQuery(query, db=self.controller.db)
        qtable.setModel(model)
        qtable.show()

        # Check for errors
        if model.lastError().isValid():
            tools_gw.show_warning(model.lastError().text())


    def query_like_widget_text(self, dialog, text_line, qtable, tableleft, tableright, field_id_r, field_id_l,
                               name='name', aql=''):
        """ Fill the QTableView by filtering through the QLineEdit"""

        schema_name = global_vars.schema_name.replace('"', '')
        query = tools_qt.getWidgetText(dialog, text_line, return_string_null=False).lower()
        sql = (f"SELECT * FROM {schema_name}.{tableleft} WHERE {name} NOT IN "
               f"(SELECT {tableleft}.{name} FROM {schema_name}.{tableleft}"
               f" RIGHT JOIN {schema_name}.{tableright}"
               f" ON {tableleft}.{field_id_l} = {tableright}.{field_id_r}"
               f" WHERE cur_user = current_user) AND LOWER({name}::text) LIKE '%{query}%'"
               f"  AND  {field_id_l} > -1")
        sql += aql
        self.fill_table_by_query(qtable, sql)