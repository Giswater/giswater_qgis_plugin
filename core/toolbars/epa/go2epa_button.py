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
import json

from qgis.PyQt.QtCore import QStringListModel, Qt
from qgis.PyQt.QtSql import QSqlQueryModel
from qgis.PyQt.QtWidgets import QWidget, QComboBox, QCompleter, QFileDialog, QTableView, QAbstractItemView, \
    QGroupBox, QSpacerItem, QSizePolicy, QGridLayout
from qgis.core import QgsApplication

from ...threads.epa_file_manager import GwEpaFileManager
from ...utils import tools_gw
from ...ui.ui_manager import GwGo2EpaUI, GwHydrologySelectorUi, GwMultirowSelectorUi, GwGo2EpaOptionsUi
from .... import global_vars
from ....lib import tools_qgis, tools_qt, tools_db
from ..dialog import GwAction


class GwGo2EpaButton(GwAction):
    """ Button 23: Go2epa """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.project_type = global_vars.project_type
        self.epa_options_list = []


    def clicked_event(self):

        self._open_go2epa()


    def check_result_id(self):
        """ Check if selected @result_id already exists """

        self.dlg_go2epa.txt_result_name.setStyleSheet(None)
        result_id = tools_qt.get_text(self.dlg_go2epa, self.dlg_go2epa.txt_result_name)
        sql = (f"SELECT result_id FROM v_ui_rpt_cat_result"
               f" WHERE result_id = '{result_id}'")
        row = tools_db.get_row(sql, log_info=False)
        if not row:
            self.dlg_go2epa.chk_only_check.setChecked(False)
            self.dlg_go2epa.chk_only_check.setEnabled(False)
        else:
            self.dlg_go2epa.chk_only_check.setEnabled(True)


    # region private functions
    def _multi_rows_selector(self, qtable_left, qtable_right, id_ori, tablename_des, id_des, query_left, query_right,
                             field_id):
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
            tools_qgis.show_warning(message)
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
            row = tools_db.get_row(sql)

            if row:
                # if exist - show warning
                message = "Id already selected"
                tools_qt.show_info_box(message, "Info", parameter=str(expl_id[i]))
            else:
                sql = (f"INSERT INTO {tablename_des} ({field_id}, cur_user) "
                       f" VALUES ({expl_id[i]}, current_user)")
                tools_db.execute_sql(sql)

        # Refresh
        oder_by = {0: "ASC", 1: "DESC"}
        sort_order = qtable_left.horizontalHeader().sortIndicatorOrder()
        idx = qtable_left.horizontalHeader().sortIndicatorSection()
        col_to_sort = qtable_left.model().headerData(idx, Qt.Horizontal)
        query_left += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
        self._fill_table_by_query(qtable_right, query_right)

        sort_order = qtable_right.horizontalHeader().sortIndicatorOrder()
        idx = qtable_right.horizontalHeader().sortIndicatorSection()
        col_to_sort = qtable_right.model().headerData(idx, Qt.Horizontal)
        query_right += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
        self._fill_table_by_query(qtable_left, query_left)
        tools_qgis.refresh_map_canvas()


    def _open_go2epa(self):

        self._go2epa()


    def _go2epa(self):
        """ Button 23: Open form to set INP, RPT and project """

        # Show form in docker?
        tools_gw.init_docker('qgis_form_docker')

        # Create dialog
        self.dlg_go2epa = GwGo2EpaUI()
        tools_gw.load_settings(self.dlg_go2epa)
        self._load_user_values()
        if self.project_type in 'ws':
            self.dlg_go2epa.chk_export_subcatch.setVisible(False)

        # Set signals
        self._set_signals()
        self.dlg_go2epa.btn_cancel.setEnabled(False)

        tableleft = "cat_dscenario"
        tableright = "selector_inp_dscenario"
        field_id_left = "dscenario_id"
        field_id_right = "dscenario_id"
        self.dlg_go2epa.btn_hs_ds.clicked.connect(
            partial(self._sector_selection, tableleft, tableright, field_id_left, field_id_right, aql=""))

        # Check OS and enable/disable checkbox execute EPA software
        if sys.platform != "win32":
            tools_qt.set_checked(self.dlg_go2epa, self.dlg_go2epa.chk_exec, False)
            self.dlg_go2epa.chk_exec.setEnabled(False)
            self.dlg_go2epa.chk_exec.setText('Execute EPA software (Runs only on Windows)')

        self._set_completer_result(self.dlg_go2epa.txt_result_name, 'v_ui_rpt_cat_result', 'result_id')
        self.check_result_id()
        if global_vars.session_vars['dialog_docker']:
            tools_qt.manage_translation('go2epa', self.dlg_go2epa)
            tools_gw.docker_dialog(self.dlg_go2epa)
            self.dlg_go2epa.btn_close.clicked.disconnect()
            self.dlg_go2epa.btn_close.clicked.connect(tools_gw.close_docker)
        else:
            tools_gw.open_dialog(self.dlg_go2epa, dlg_name='go2epa')


    def _set_signals(self):

        self.dlg_go2epa.btn_cancel.clicked.connect(self._cancel_task)
        self.dlg_go2epa.txt_result_name.textChanged.connect(partial(self.check_result_id))
        self.dlg_go2epa.btn_file_inp.clicked.connect(self._go2epa_select_file_inp)
        self.dlg_go2epa.btn_file_rpt.clicked.connect(self._go2epa_select_file_rpt)
        self.dlg_go2epa.btn_accept.clicked.connect(self._go2epa_accept)
        self.dlg_go2epa.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_go2epa))
        self.dlg_go2epa.rejected.connect(partial(tools_gw.close_dialog, self.dlg_go2epa))
        self.dlg_go2epa.btn_options.clicked.connect(self._go2epa_options)


    def _check_inp_chk(self, file_inp):

        if file_inp is None:
            msg = "Select valid INP file"
            tools_qgis.show_warning(msg, parameter=str(file_inp))
            return False

        return True


    def _check_rpt(self):

        file_inp = tools_qt.get_text(self.dlg_go2epa, self.dlg_go2epa.txt_file_inp)
        file_rpt = tools_qt.get_text(self.dlg_go2epa, self.dlg_go2epa.txt_file_rpt)

        # Control execute epa software
        if tools_qt.is_checked(self.dlg_go2epa, self.dlg_go2epa.chk_exec):
            if not self._check_inp_chk(file_inp):
                return False

            if file_rpt is None:
                msg = "Select valid RPT file"
                tools_qgis.show_warning(msg, parameter=str(file_rpt))
                return False

            if not tools_qt.is_checked(self.dlg_go2epa, self.dlg_go2epa.chk_export):
                if not os.path.exists(file_inp):
                    msg = "File INP not found"
                    tools_qgis.show_warning(msg, parameter=str(file_inp))
                    return False

        return True


    def _check_fields(self):

        file_inp = tools_qt.get_text(self.dlg_go2epa, self.dlg_go2epa.txt_file_inp)
        file_rpt = tools_qt.get_text(self.dlg_go2epa, self.dlg_go2epa.txt_file_rpt)
        result_name = tools_qt.get_text(self.dlg_go2epa, self.dlg_go2epa.txt_result_name, False, False)

        # Check if at least one process is selected
        export_checked = tools_qt.is_checked(self.dlg_go2epa, self.dlg_go2epa.chk_export)
        exec_checked = tools_qt.is_checked(self.dlg_go2epa, self.dlg_go2epa.chk_exec)
        import_result_checked = tools_qt.is_checked(self.dlg_go2epa, self.dlg_go2epa.chk_import_result)

        if not export_checked and not exec_checked and not import_result_checked:
            msg = "You need to select at least one process"
            tools_qt.show_info_box(msg, title="Go2Epa")
            return False

        # Control export INP
        if export_checked:
            if not self._check_inp_chk(file_inp):
                return False

        # Control execute epa software
        if not self._check_rpt():
            return False

        # Control import result
        if import_result_checked:
            if file_rpt is None:
                msg = "Select valid RPT file"
                tools_qgis.show_warning(msg, parameter=str(file_rpt))
                return False
            if not tools_qt.is_checked(self.dlg_go2epa, self.dlg_go2epa.chk_exec):
                if not os.path.exists(file_rpt):
                    msg = "File RPT not found"
                    tools_qgis.show_warning(msg, parameter=str(file_rpt))
                    return False
            else:
                if not self._check_rpt():
                    return False

        # Control result name
        if result_name == '':
            self.dlg_go2epa.txt_result_name.setStyleSheet("border: 1px solid red")
            msg = "This parameter is mandatory. Please, set a value"
            tools_qt.show_details(msg, title="Rpt fail", inf_text=None)
            return False

        self.dlg_go2epa.txt_result_name.setStyleSheet(None)

        sql = (f"SELECT result_id FROM rpt_cat_result "
               f"WHERE result_id = '{result_name}' LIMIT 1")
        row = tools_db.get_row(sql)
        if import_result_checked and not export_checked and not exec_checked:
            if not row:
                msg = "Result name not found. It's not possible to import RPT file into database"
                tools_qt.show_info_box(msg, "Import RPT file")
                return False
        else:
            if row:
                msg = "Result name already exists, do you want overwrite?"
                answer = tools_qt.show_question(msg, title="Alert")
                if not answer:
                    return False

        return True


    def _load_user_values(self):
        """ Load QGIS settings related with file_manager """

        self.dlg_go2epa.txt_result_name.setMaxLength(16)
        self.result_name = tools_gw.get_config_parser('btn_go2epa', 'go2epa_RESULT_NAME', "user", "session")
        self.dlg_go2epa.txt_result_name.setText(self.result_name)
        self.file_inp = tools_gw.get_config_parser('btn_go2epa', 'go2epa_FILE_INP', "user", "session")
        self.dlg_go2epa.txt_file_inp.setText(self.file_inp)
        self.file_rpt = tools_gw.get_config_parser('btn_go2epa', 'go2epa_FILE_RPT', "user", "session")
        self.dlg_go2epa.txt_file_rpt.setText(self.file_rpt)

        value = tools_gw.get_config_parser('btn_go2epa', 'go2epa_chk_NETWORK_GEOM', "user", "session")
        tools_qt.set_checked(self.dlg_go2epa, self.dlg_go2epa.chk_only_check, value)
        value = tools_gw.get_config_parser('btn_go2epa', 'go2epa_chk_INP', "user", "session")
        tools_qt.set_checked(self.dlg_go2epa, self.dlg_go2epa.chk_export, value)
        value = tools_gw.get_config_parser('btn_go2epa', 'go2epa_chk_UD', "user", "session")
        tools_qt.set_checked(self.dlg_go2epa, self.dlg_go2epa.chk_export_subcatch, value)
        value = tools_gw.get_config_parser('btn_go2epa', 'go2epa_chk_EPA', "user", "session")
        tools_qt.set_checked(self.dlg_go2epa, self.dlg_go2epa.chk_exec, value)
        value = tools_gw.get_config_parser('btn_go2epa', 'go2epa_chk_RPT', "user", "session")
        tools_qt.set_checked(self.dlg_go2epa, self.dlg_go2epa.chk_import_result, value)


    def _save_user_values(self):
        """ Save QGIS settings related with file_manager """

        txt_result_name = f"{tools_qt.get_text(self.dlg_go2epa, 'txt_result_name', return_string_null=False)}"
        tools_gw.set_config_parser('btn_go2epa', 'go2epa_RESULT_NAME', f"{txt_result_name}")
        txt_file_inp = f"{tools_qt.get_text(self.dlg_go2epa, 'txt_file_inp', return_string_null=False)}"
        tools_gw.set_config_parser('btn_go2epa', 'go2epa_FILE_INP', f"{txt_file_inp}")
        txt_file_rpt = f"{tools_qt.get_text(self.dlg_go2epa, 'txt_file_rpt', return_string_null=False)}"
        tools_gw.set_config_parser('btn_go2epa', 'go2epa_FILE_RPT', f"{txt_file_rpt}")
        chk_only_check = f"{tools_qt.is_checked(self.dlg_go2epa, self.dlg_go2epa.chk_only_check)}"
        tools_gw.set_config_parser('btn_go2epa', 'go2epa_chk_NETWORK_GEOM', f"{chk_only_check}")
        chk_export = f"{tools_qt.is_checked(self.dlg_go2epa, self.dlg_go2epa.chk_export)}"
        tools_gw.set_config_parser('btn_go2epa', 'go2epa_chk_INP', f"{chk_export}")
        chk_export_subcatch = f"{tools_qt.is_checked(self.dlg_go2epa, self.dlg_go2epa.chk_export_subcatch)}"
        tools_gw.set_config_parser('btn_go2epa', 'go2epa_chk_UD', f"{chk_export_subcatch}")
        chk_exec = f"{tools_qt.is_checked(self.dlg_go2epa, self.dlg_go2epa.chk_exec)}"
        tools_gw.set_config_parser('btn_go2epa', 'go2epa_chk_EPA', f"{chk_exec}")
        chk_import_result = f"{tools_qt.is_checked(self.dlg_go2epa, self.dlg_go2epa.chk_import_result)}"
        tools_gw.set_config_parser('btn_go2epa', 'go2epa_chk_RPT', f"{chk_import_result}")


    def _sector_selection(self, tableleft, tableright, field_id_left, field_id_right, aql=""):
        """ Load the tables in the selection form """

        dlg_psector_sel = GwMultirowSelectorUi('dscenario')
        tools_gw.load_settings(dlg_psector_sel)
        dlg_psector_sel.btn_ok.clicked.connect(dlg_psector_sel.close)

        if tableleft == 'cat_dscenario':
            dlg_psector_sel.setWindowTitle(" Dscenario selector")
            tools_qt.set_widget_text(dlg_psector_sel, dlg_psector_sel.lbl_filter,
                                     tools_qt.tr('Filter by: Dscenario name', context_name='labels'))
            tools_qt.set_widget_text(dlg_psector_sel, dlg_psector_sel.lbl_unselected,
                                     tools_qt.tr('Unselected dscenarios', context_name='labels'))
            tools_qt.set_widget_text(dlg_psector_sel, dlg_psector_sel.lbl_selected,
                                     tools_qt.tr('Selected dscenarios', context_name='labels'))

        self._multi_row_selector(dlg_psector_sel, tableleft, tableright, field_id_left, field_id_right, aql=aql)

        tools_gw.open_dialog(dlg_psector_sel)


    def _go2epa_select_file_inp(self):
        """ Select INP file """

        self.file_inp = tools_qt.get_text(self.dlg_go2epa, self.dlg_go2epa.txt_file_inp)
        # Set default value if necessary
        if self.file_inp is None or self.file_inp == '':
            self.file_inp = global_vars.plugin_dir

        # Get directory of that file
        folder_path = os.path.dirname(self.file_inp)
        if not os.path.exists(folder_path):
            folder_path = os.path.dirname(__file__)
        os.chdir(folder_path)
        message = tools_qt.tr("Select INP file")
        widget_is_checked = tools_qt.is_checked(self.dlg_go2epa, self.dlg_go2epa.chk_export)
        if widget_is_checked:
            self.file_inp, filter_ = QFileDialog.getSaveFileName(None, message, "", '*.inp')
        else:
            self.file_inp, filter_ = QFileDialog.getOpenFileName(None, message, "", '*.inp')
        tools_qt.set_widget_text(self.dlg_go2epa, self.dlg_go2epa.txt_file_inp, self.file_inp)


    def _go2epa_select_file_rpt(self):
        """ Select RPT file """

        # Set default value if necessary
        if self.file_rpt is None or self.file_rpt == '':
            self.file_rpt = global_vars.plugin_dir

        # Get directory of that file
        folder_path = os.path.dirname(self.file_rpt)
        if not os.path.exists(folder_path):
            folder_path = os.path.dirname(__file__)
        os.chdir(folder_path)
        message = tools_qt.tr("Select RPT file")
        widget_is_checked = tools_qt.is_checked(self.dlg_go2epa, self.dlg_go2epa.chk_export)
        if widget_is_checked:
            self.file_rpt, filter_ = QFileDialog.getSaveFileName(None, message, "", '*.rpt')
        else:
            self.file_rpt, filter_ = QFileDialog.getOpenFileName(None, message, "", '*.rpt')
        tools_qt.set_widget_text(self.dlg_go2epa, self.dlg_go2epa.txt_file_rpt, self.file_rpt)


    def _go2epa_accept(self):
        """ Save INP, RPT and result name into GSW file """

        # Save user values
        self._save_user_values()

        self.dlg_go2epa.txt_infolog.clear()
        self.dlg_go2epa.txt_file_rpt.setStyleSheet(None)
        status = self._check_fields()
        if status is False:
            return

        # Get widgets values
        self.result_name = tools_qt.get_text(self.dlg_go2epa, self.dlg_go2epa.txt_result_name, False, False)
        self.net_geom = tools_qt.is_checked(self.dlg_go2epa, self.dlg_go2epa.chk_only_check)
        self.export_inp = tools_qt.is_checked(self.dlg_go2epa, self.dlg_go2epa.chk_export)
        self.export_subcatch = tools_qt.is_checked(self.dlg_go2epa, self.dlg_go2epa.chk_export_subcatch)
        self.file_inp = tools_qt.get_text(self.dlg_go2epa, self.dlg_go2epa.txt_file_inp)
        self.exec_epa = tools_qt.is_checked(self.dlg_go2epa, self.dlg_go2epa.chk_exec)
        self.file_rpt = tools_qt.get_text(self.dlg_go2epa, self.dlg_go2epa.txt_file_rpt)
        self.import_result = tools_qt.is_checked(self.dlg_go2epa, self.dlg_go2epa.chk_import_result)

        # Check for sector selector
        if self.export_inp:
            sql = "SELECT sector_id FROM selector_sector WHERE sector_id > 0 LIMIT 1"
            row = tools_db.get_row(sql)
            if row is None:
                msg = "You need to select some sector"
                tools_qt.show_info_box(msg)
                return

        self.dlg_go2epa.btn_cancel.setEnabled(True)

        # Set background task 'Go2Epa'
        description = f"Go2Epa"
        self.go2epa_task = GwEpaFileManager(description, self)
        QgsApplication.taskManager().addTask(self.go2epa_task)
        QgsApplication.taskManager().triggerTask(self.go2epa_task)


    def _cancel_task(self):

        if hasattr(self, 'go2epa_task'):
            self.go2epa_task.cancel()


    def _set_completer_result(self, widget, viewname, field_name):
        """ Set autocomplete of widget 'feature_id'
            getting id's from selected @viewname
        """

        result_name = tools_qt.get_text(self.dlg_go2epa, self.dlg_go2epa.txt_result_name)

        # Adding auto-completion to a QLineEdit
        self.completer = QCompleter()
        self.completer.setCaseSensitivity(Qt.CaseInsensitive)
        widget.setCompleter(self.completer)
        model = QStringListModel()

        sql = f"SELECT {field_name} FROM {viewname}"
        rows = tools_db.get_rows(sql)

        if rows:
            for i in range(0, len(rows)):
                aux = rows[i]
                rows[i] = str(aux[0])

            model.setStringList(rows)
            self.completer.setModel(model)
            if result_name in rows:
                self.dlg_go2epa.chk_only_check.setEnabled(True)


    def _multi_row_selector(self, dialog, tableleft, tableright, field_id_left, field_id_right, name='name',
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
        :param aql: (add query left) Query added to the left side (used in dialog.py def basic_exploitation_selector())
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

        self._fill_table_by_query(tbl_all_rows, query_left + f" ORDER BY {name};")
        self._hide_colums(tbl_all_rows, hide_left)
        tbl_all_rows.setColumnWidth(1, 200)

        # fill QTableView selected_rows
        tbl_selected_rows = dialog.findChild(QTableView, "selected_rows")
        tbl_selected_rows.setSelectionBehavior(QAbstractItemView.SelectRows)

        query_right = f"SELECT {tableleft}.{name}, cur_user, {tableleft}.{field_id_left}, {tableright}.{field_id_right}"
        query_right += f" FROM {schema_name}.{tableleft}"
        query_right += f" JOIN {schema_name}.{tableright} ON {tableleft}.{field_id_left} = {tableright}.{field_id_right}"

        query_right += " WHERE cur_user = current_user"

        self._fill_table_by_query(tbl_selected_rows, query_right + f" ORDER BY {name};")
        self._hide_colums(tbl_selected_rows, hide_right)
        tbl_selected_rows.setColumnWidth(0, 200)

        # Button select
        dialog.btn_select.clicked.connect(partial(self._multi_rows_selector, tbl_all_rows, tbl_selected_rows,
                                                  field_id_left, tableright, field_id_right, query_left,
                                                  query_right,
                                                  field_id_right))

        # Button unselect
        query_delete = f"DELETE FROM {schema_name}.{tableright}"
        query_delete += f" WHERE current_user = cur_user AND {tableright}.{field_id_right}="
        dialog.btn_unselect.clicked.connect(partial(self._unselector, tbl_all_rows, tbl_selected_rows, query_delete,
                                                    query_left, query_right, field_id_right))

        # QLineEdit
        dialog.txt_name.textChanged.connect(partial(self._query_like_widget_text, dialog, dialog.txt_name,
                                                    tbl_all_rows, tableleft, tableright, field_id_right,
                                                    field_id_left,
                                                    name, aql))

        # Order control
        tbl_all_rows.horizontalHeader().sectionClicked.connect(
            partial(self._order_by_column, tbl_all_rows, query_left))
        tbl_selected_rows.horizontalHeader().sectionClicked.connect(
            partial(self._order_by_column, tbl_selected_rows, query_right))


    def _order_by_column(self, qtable, query, idx):
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
        self._fill_table_by_query(qtable, query)
        tools_qgis.refresh_map_canvas()


    def _hide_colums(self, widget, comuns_to_hide):

        for i in range(0, len(comuns_to_hide)):
            widget.hideColumn(comuns_to_hide[i])


    def _unselector(self, qtable_left, qtable_right, query_delete, query_left, query_right, field_id_right):

        selected_list = qtable_right.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message)
            return
        expl_id = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = str(qtable_right.model().record(row).value(field_id_right))
            expl_id.append(id_)
        for i in range(0, len(expl_id)):
            tools_db.execute_sql(query_delete + str(expl_id[i]))

        # Refresh
        oder_by = {0: "ASC", 1: "DESC"}
        sort_order = qtable_left.horizontalHeader().sortIndicatorOrder()
        idx = qtable_left.horizontalHeader().sortIndicatorSection()
        col_to_sort = qtable_left.model().headerData(idx, Qt.Horizontal)
        query_left += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
        self._fill_table_by_query(qtable_left, query_left)

        sort_order = qtable_right.horizontalHeader().sortIndicatorOrder()
        idx = qtable_right.horizontalHeader().sortIndicatorSection()
        col_to_sort = qtable_right.model().headerData(idx, Qt.Horizontal)
        query_right += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
        self._fill_table_by_query(qtable_right, query_right)
        tools_qgis.refresh_map_canvas()


    def _fill_table_by_query(self, qtable, query):
        """
        :param qtable: QTableView to show
        :param query: query to set model
        """

        model = QSqlQueryModel()
        model.setQuery(query, db=global_vars.qgis_db_credentials)
        qtable.setModel(model)
        qtable.show()

        # Check for errors
        if model.lastError().isValid():
            tools_qgis.show_warning(model.lastError().text())


    def _query_like_widget_text(self, dialog, text_line, qtable, tableleft, tableright, field_id_r, field_id_l,
                               name='name', aql=''):
        """ Fill the QTableView by filtering through the QLineEdit"""

        schema_name = global_vars.schema_name.replace('"', '')
        query = tools_qt.get_text(dialog, text_line, return_string_null=False).lower()
        sql = (f"SELECT * FROM {schema_name}.{tableleft} WHERE {name} NOT IN "
               f"(SELECT {tableleft}.{name} FROM {schema_name}.{tableleft}"
               f" RIGHT JOIN {schema_name}.{tableright}"
               f" ON {tableleft}.{field_id_l} = {tableright}.{field_id_r}"
               f" WHERE cur_user = current_user) AND LOWER({name}::text) LIKE '%{query}%'"
               f"  AND  {field_id_l} > -1")
        sql += aql
        self._fill_table_by_query(qtable, sql)


    def _go2epa_options(self):
        """ Button 23: Open form to set INP, RPT and project """

        # Clear list
        self.epa_options_list = []

        # Create dialog
        self.dlg_go2epa_options = GwGo2EpaOptionsUi()
        tools_gw.load_settings(self.dlg_go2epa_options)

        form = '"formName":"epaoptions"'
        body = tools_gw.create_body(form=form)
        json_result = tools_gw.execute_procedure('gw_fct_getconfig', body)
        if not json_result or json_result['status'] == 'Failed':
            return False

        tools_gw.build_dialog_options(
            self.dlg_go2epa_options, json_result['body']['form']['formTabs'], 0, self.epa_options_list)
        grbox_list = self.dlg_go2epa_options.findChildren(QGroupBox)
        for grbox in grbox_list:
            widget_list = grbox.findChildren(QWidget)
            if len(widget_list) == 0:
                grbox.setVisible(False)
            else:
                layout_list = grbox.findChildren(QGridLayout)
                for lyt in layout_list:
                    spacer = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
                    lyt.addItem(spacer)

        # Event on change from combo parent
        self._get_event_combo_parent(json_result)
        self.dlg_go2epa_options.btn_accept.clicked.connect(partial(self._update_values, self.epa_options_list))
        self.dlg_go2epa_options.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_go2epa_options))
        self.dlg_go2epa_options.rejected.connect(partial(tools_gw.close_dialog, self.dlg_go2epa_options))

        tools_gw.open_dialog(self.dlg_go2epa_options, dlg_name='go2epa_options')


    def _update_values(self, _json):

        my_json = json.dumps(_json)
        form = '"formName":"epaoptions"'
        extras = f'"fields":{my_json}'
        body = tools_gw.create_body(form=form, extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_setconfig', body)
        if not json_result or json_result['status'] == 'Failed':
            return False

        message = "Values has been updated"
        tools_qgis.show_info(message)
        # Close dialog
        tools_gw.close_dialog(self.dlg_go2epa_options)


    def _get_event_combo_parent(self, complet_result):

        for field in complet_result['body']['form']['formTabs'][0]["fields"]:
            if field['isparent']:
                widget = self.dlg_go2epa_options.findChild(QComboBox, field['widgetname'])
                if widget:
                    widget.currentIndexChanged.connect(partial(self._fill_child, self.dlg_go2epa_options, widget))


    def _fill_child(self, dialog, widget):

        combo_parent = widget.objectName()
        combo_id = tools_qt.get_combo_value(dialog, widget)
        # TODO cambiar por gw_fct_getchilds then unified with tools_gw.get_child if posible
        json_result = tools_gw.execute_procedure('gw_fct_getcombochilds', f"'epaoptions', '', '', '{combo_parent}', '{combo_id}', ''")
        if not json_result or json_result['status'] == 'Failed':
            return False

        for combo_child in json_result['fields']:
            if combo_child is not None:
                tools_gw.manage_combo_child(dialog, widget, combo_child)

    # endregion