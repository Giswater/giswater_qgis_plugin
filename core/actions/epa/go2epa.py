"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsApplication
from qgis.PyQt.QtCore import QDate, QStringListModel, QTime, Qt
from qgis.PyQt.QtWidgets import QWidget, QCheckBox, QDateEdit, QTimeEdit, QComboBox, QCompleter, QFileDialog

import os
import sys
from functools import partial

from .... import global_vars
from lib import qt_tools
from ..epa.go2epa_options import GwGo2EpaOptions
from ...tasks.tsk_go2epa import GwGo2EpaTask
from ...admin import GwAdmin
from ....ui_manager import Go2EpaUI, HydrologySelector, Multirow_selector
from ...utils.giswater_tools import close_dialog, get_parser_value, load_settings, open_dialog, set_parser_value

from ....actions.parent_functs import multi_row_selector


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
        load_settings(self.dlg_go2epa)
        self.load_user_values()
        if self.project_type in 'ws':
            self.dlg_go2epa.chk_export_subcatch.setVisible(False)

        # Set signals
        self.set_signals()

        if self.project_type == 'ws':
            self.dlg_go2epa.btn_hs_ds.setText("Dscenario Selector")
            tableleft = "cat_dscenario"
            tableright = "selector_inp_demand"
            field_id_left = "dscenario_id"
            field_id_right = "dscenario_id"
            self.dlg_go2epa.btn_hs_ds.clicked.connect(
                partial(self.sector_selection, tableleft, tableright, field_id_left, field_id_right, aql=""))

        elif self.project_type == 'ud':
            self.dlg_go2epa.btn_hs_ds.setText("Hydrology selector")
            self.dlg_go2epa.btn_hs_ds.clicked.connect(self.ud_hydrology_selector)

        # Check OS and enable/disable checkbox execute EPA software
        if sys.platform != "win32":
            qt_tools.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_exec, False)
            self.dlg_go2epa.chk_exec.setEnabled(False)
            self.dlg_go2epa.chk_exec.setText('Execute EPA software (Runs only on Windows)')

        self.set_completer_result(self.dlg_go2epa.txt_result_name, 'v_ui_rpt_cat_result', 'result_id')

        if self.controller.dlg_docker:
            self.controller.manage_translation('go2epa', self.dlg_go2epa)
            self.controller.dock_dialog(self.dlg_go2epa)
            self.dlg_go2epa.btn_cancel.clicked.disconnect()
            self.dlg_go2epa.btn_cancel.clicked.connect(self.controller.close_docker)
        else:
            open_dialog(self.dlg_go2epa, dlg_name='go2epa')


    def set_signals(self):

        self.dlg_go2epa.txt_result_name.textChanged.connect(partial(self.check_result_id))
        self.dlg_go2epa.btn_file_inp.clicked.connect(self.go2epa_select_file_inp)
        self.dlg_go2epa.btn_file_rpt.clicked.connect(self.go2epa_select_file_rpt)
        self.dlg_go2epa.btn_accept.clicked.connect(self.go2epa_accept)
        self.dlg_go2epa.btn_cancel.clicked.connect(partial(close_dialog, self.dlg_go2epa))
        self.dlg_go2epa.rejected.connect(partial(close_dialog, self.dlg_go2epa))
        self.dlg_go2epa.btn_options.clicked.connect(self.epa_options)


    def check_inp_chk(self, file_inp):

        if file_inp is None:
            msg = "Select valid INP file"
            self.controller.show_warning(msg, parameter=str(file_inp))
            return False


    def check_rpt(self):

        file_inp = qt_tools.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_inp)
        file_rpt = qt_tools.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_rpt)

        # Control execute epa software
        if qt_tools.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_exec):
            if self.check_inp_chk(file_inp) is False:
                return False

            if file_rpt is None:
                msg = "Select valid RPT file"
                self.controller.show_warning(msg, parameter=str(file_rpt))
                return False

            if not qt_tools.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export):
                if not os.path.exists(file_inp):
                    msg = "File INP not found"
                    self.controller.show_warning(msg, parameter=str(file_rpt))
                    return False


    def check_fields(self):

        file_inp = qt_tools.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_inp)
        file_rpt = qt_tools.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_rpt)
        result_name = qt_tools.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_result_name, False, False)

        # Control export INP
        if qt_tools.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export):
            if self.check_inp_chk(file_inp) is False:
                return False

        # Control execute epa software
        if self.check_rpt() is False:
            return False

        # Control import result
        if qt_tools.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_import_result):
            if file_rpt is None:
                msg = "Select valid RPT file"
                self.controller.show_warning(msg, parameter=str(file_rpt))
                return False
            if not qt_tools.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_exec):
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
        self.result_name = get_parser_value('go2epa', 'go2epa_RESULT_NAME')
        self.dlg_go2epa.txt_result_name.setText(self.result_name)
        self.file_inp = get_parser_value('go2epa', 'go2epa_FILE_INP')
        self.dlg_go2epa.txt_file_inp.setText(self.file_inp)
        self.file_rpt = get_parser_value('go2epa', 'go2epa_FILE_RPT')
        self.dlg_go2epa.txt_file_rpt.setText(self.file_rpt)

        value = get_parser_value('go2epa', 'go2epa_chk_NETWORK_GEOM')
        qt_tools.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_only_check, value)
        value = get_parser_value('go2epa', 'go2epa_chk_INP')
        qt_tools.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export, value)
        value = get_parser_value('go2epa', 'go2epa_chk_UD')
        qt_tools.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export_subcatch, value)
        value = get_parser_value('go2epa', 'go2epa_chk_EPA')
        qt_tools.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_exec, value)
        value = get_parser_value('go2epa', 'go2epa_chk_RPT')
        qt_tools.setChecked(self.dlg_go2epa, self.dlg_go2epa.chk_import_result, value)


    def save_user_values(self):
        """ Save QGIS settings related with file_manager """

        set_parser_value('go2epa', 'go2epa_RESULT_NAME',
                         f"{qt_tools.getWidgetText(self.dlg_go2epa, 'txt_result_name', return_string_null=False)}")
        set_parser_value('go2epa', 'go2epa_FILE_INP',
                         f"{qt_tools.getWidgetText(self.dlg_go2epa, 'txt_file_inp', return_string_null=False)}")
        set_parser_value('go2epa', 'go2epa_FILE_RPT',
                         f"{qt_tools.getWidgetText(self.dlg_go2epa, 'txt_file_rpt', return_string_null=False)}")
        set_parser_value('go2epa', 'go2epa_chk_NETWORK_GEOM',
                         f"{qt_tools.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_only_check)}")
        set_parser_value('go2epa', 'go2epa_chk_INP',
                         f"{qt_tools.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export)}")
        set_parser_value('go2epa', 'go2epa_chk_UD',
                         f"{qt_tools.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export_subcatch)}")
        set_parser_value('go2epa', 'go2epa_chk_EPA',
                         f"{qt_tools.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_exec)}")
        set_parser_value('go2epa', 'go2epa_chk_RPT',
                         f"{qt_tools.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_import_result)}")


    def sector_selection(self, tableleft, tableright, field_id_left, field_id_right, aql=""):
        """ Load the tables in the selection form """

        dlg_psector_sel = Multirow_selector('dscenario')
        load_settings(dlg_psector_sel)
        dlg_psector_sel.btn_ok.clicked.connect(dlg_psector_sel.close)

        if tableleft == 'cat_dscenario':
            dlg_psector_sel.setWindowTitle(" Dscenario selector")
            qt_tools.setWidgetText(dlg_psector_sel, dlg_psector_sel.lbl_filter,
                                   self.controller.tr('Filter by: Dscenario name', context_name='labels'))
            qt_tools.setWidgetText(dlg_psector_sel, dlg_psector_sel.lbl_unselected,
                                   self.controller.tr('Unselected dscenarios', context_name='labels'))
            qt_tools.setWidgetText(dlg_psector_sel, dlg_psector_sel.lbl_selected,
                                   self.controller.tr('Selected dscenarios', context_name='labels'))

        multi_row_selector(dlg_psector_sel, tableleft, tableright, field_id_left, field_id_right, aql=aql)

        open_dialog(dlg_psector_sel)


    def epa_options(self):
        """ Open dialog api_epa_options.ui.ui """

        self.g2epa_opt.go2epa_options()
        return


    def ud_hydrology_selector(self):
        """ Dialog hydrology_selector.ui """

        self.dlg_hydrology_selector = HydrologySelector()
        load_settings(self.dlg_hydrology_selector)

        self.dlg_hydrology_selector.btn_accept.clicked.connect(self.save_hydrology)
        self.dlg_hydrology_selector.hydrology.currentIndexChanged.connect(self.update_labels)
        self.dlg_hydrology_selector.txt_name.textChanged.connect(
            partial(self.filter_cbx_by_text, "cat_hydrology", self.dlg_hydrology_selector.txt_name,
                    self.dlg_hydrology_selector.hydrology))

        sql = "SELECT DISTINCT(name), hydrology_id FROM cat_hydrology ORDER BY name"
        rows = self.controller.get_rows(sql)
        if not rows:
            message = "Any data found in table"
            self.controller.show_warning(message, parameter='cat_hydrology')
            return False

        qt_tools.set_item_data(self.dlg_hydrology_selector.hydrology, rows)

        sql = ("SELECT DISTINCT(t1.name) FROM cat_hydrology AS t1 "
               "INNER JOIN selector_inp_hydrology AS t2 ON t1.hydrology_id = t2.hydrology_id "
               "WHERE t2.cur_user = current_user")
        row = self.controller.get_row(sql)
        if row:
            qt_tools.setWidgetText(self.dlg_hydrology_selector, self.dlg_hydrology_selector.hydrology, row[0])
        else:
            qt_tools.setWidgetText(self.dlg_hydrology_selector, self.dlg_hydrology_selector.hydrology, 0)

        self.update_labels()
        open_dialog(self.dlg_hydrology_selector)


    def save_hydrology(self):

        hydrology_id = qt_tools.get_item_data(self.dlg_hydrology_selector, self.dlg_hydrology_selector.hydrology, 1)
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
        self.controller.show_info(message)
        close_dialog(self.dlg_hydrology_selector)


    def update_labels(self):
        """ Show text in labels from SELECT """

        sql = (f"SELECT infiltration, text FROM cat_hydrology"
               f" WHERE name = '{self.dlg_hydrology_selector.hydrology.currentText()}'")
        row = self.controller.get_row(sql)
        if row is not None:
            qt_tools.setText(self.dlg_hydrology_selector, self.dlg_hydrology_selector.infiltration, row[0])
            qt_tools.setText(self.dlg_hydrology_selector, self.dlg_hydrology_selector.descript, row[1])


    def filter_cbx_by_text(self, tablename, widgettxt, widgetcbx):

        sql = (f"SELECT DISTINCT(name), hydrology_id FROM {tablename}"
               f" WHERE name LIKE '%{widgettxt.text()}%'"
               f" ORDER BY name ")
        rows = self.controller.get_rows(sql)
        if not rows:
            message = "Check the table 'cat_hydrology' "
            self.controller.show_warning(message)
            return False
        qt_tools.set_item_data(widgetcbx, rows)
        self.update_labels()


    def go2epa_select_file_inp(self):
        """ Select INP file """

        self.file_inp = qt_tools.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_inp)
        # Set default value if necessary
        if self.file_inp is None or self.file_inp == '':
            self.file_inp = global_vars.plugin_dir

        # Get directory of that file
        folder_path = os.path.dirname(self.file_inp)
        if not os.path.exists(folder_path):
            folder_path = os.path.dirname(__file__)
        os.chdir(folder_path)
        message = self.controller.tr("Select INP file")
        self.file_inp, filter_ = QFileDialog.getSaveFileName(None, message, "", '*.inp')
        qt_tools.setWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_inp, self.file_inp)


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
        message = self.controller.tr("Select RPT file")
        self.file_rpt, filter_ = QFileDialog.getSaveFileName(None, message, "", '*.rpt')
        qt_tools.setWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_rpt, self.file_rpt)


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
        self.result_name = qt_tools.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_result_name, False, False)
        self.net_geom = qt_tools.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_only_check)
        self.export_inp = qt_tools.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export)
        self.export_subcatch = qt_tools.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_export_subcatch)
        self.file_inp = qt_tools.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_inp)
        self.exec_epa = qt_tools.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_exec)
        self.file_rpt = qt_tools.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_file_rpt)
        self.import_result = qt_tools.isChecked(self.dlg_go2epa, self.dlg_go2epa.chk_import_result)

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

        result_name = qt_tools.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_result_name)

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

        result_id = qt_tools.getWidgetText(self.dlg_go2epa, self.dlg_go2epa.txt_result_name)
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
            self.controller.show_warning(message, parameter=tablename)
            return None

        # Iterate over all columns and populate its corresponding widget
        columns = []
        for i in range(0, len(row)):
            column_name = self.controller.dao.get_column_name(i)
            widget = dialog.findChild(QWidget, column_name)
            widget_type = qt_tools.getWidgetType(dialog, widget)
            if row[column_name] is not None:
                if widget_type is QCheckBox:
                    qt_tools.setChecked(dialog, widget, row[column_name])
                elif widget_type is QComboBox:
                    qt_tools.set_combo_itemData(widget, row[column_name], 0)
                elif widget_type is QDateEdit:
                    dateaux = row[column_name].replace('/', '-')
                    date = QDate.fromString(dateaux, 'dd-MM-yyyy')
                    qt_tools.setCalendarDate(dialog, widget, date)
                elif widget_type is QTimeEdit:
                    timeparts = str(row[column_name]).split(':')
                    if len(timeparts) < 3:
                        timeparts.append("0")
                    days = int(timeparts[0]) / 24
                    hours = int(timeparts[0]) % 24
                    minuts = int(timeparts[1])
                    seconds = int(timeparts[2])
                    time = QTime(hours, minuts, seconds)
                    qt_tools.setTimeEdit(dialog, widget, time)
                    qt_tools.setText(dialog, column_name + "_day", days)
                else:
                    qt_tools.setWidgetText(dialog, widget, str(row[column_name]))

            columns.append(column_name)

        return columns


    def update_sql(self):
        usql = GwAdmin()
        usql.init_sql()

