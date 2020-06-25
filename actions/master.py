"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtWidgets import QDateEdit, QLineEdit, QTableView, QAbstractItemView
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtCore import Qt

from functools import partial

from lib import qt_tools
from .manage_new_psector import ManageNewPsector
from ..ui_manager import PsectorManagerUi
from ..ui_manager import PriceManagerUi
from .parent import ParentAction
from .duplicate_psector import DuplicatePsector


class Master(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'master' """
        self.config_dict = {}
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.manage_new_psector = ManageNewPsector(iface, settings, controller, plugin_dir)



    def set_project_type(self, project_type):
        self.project_type = project_type


    def master_new_psector(self, psector_id=None):
        """ Button 45: New psector """
        self.manage_new_psector.new_psector(psector_id, 'plan')


    def master_psector_mangement(self):
        """ Button 46: Psector management """

        # Create the dialog and signals
        self.dlg_psector_mng = PsectorManagerUi()

        self.load_settings(self.dlg_psector_mng)
        table_name = "v_edit_plan_psector"
        column_id = "psector_id"

        # Tables
        self.qtbl_psm = self.dlg_psector_mng.findChild(QTableView, "tbl_psm")
        self.qtbl_psm.setSelectionBehavior(QAbstractItemView.SelectRows)


        # Set signals
        self.dlg_psector_mng.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_psector_mng))
        self.dlg_psector_mng.rejected.connect(partial(self.close_dialog, self.dlg_psector_mng))
        self.dlg_psector_mng.btn_delete.clicked.connect(partial(
            self.multi_rows_delete, self.dlg_psector_mng, self.qtbl_psm, table_name, column_id, 'lbl_vdefault_psector',
            'plan_psector_vdefault'))
        self.dlg_psector_mng.btn_update_psector.clicked.connect(partial(self.update_current_psector, self.dlg_psector_mng, self.qtbl_psm))
        self.dlg_psector_mng.btn_duplicate.clicked.connect(self.psector_duplicate)
        self.dlg_psector_mng.txt_name.textChanged.connect(partial(self.filter_by_text, self.dlg_psector_mng, self.qtbl_psm, self.dlg_psector_mng.txt_name, table_name))
        self.dlg_psector_mng.tbl_psm.doubleClicked.connect(partial(self.charge_psector, self.qtbl_psm))
        self.fill_table_psector(self.qtbl_psm, table_name)
        self.set_table_columns(self.dlg_psector_mng, self.qtbl_psm, table_name)
        self.set_label_current_psector(self.dlg_psector_mng)

        # Open form
        self.dlg_psector_mng.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.open_dialog(self.dlg_psector_mng, dlg_name="psector_manager")


    def update_current_psector(self, dialog, qtbl_psm):
      
        selected_list = qtbl_psm.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        row = selected_list[0].row()
        psector_id = qtbl_psm.model().record(row).value("psector_id")
        aux_widget = QLineEdit()
        aux_widget.setText(str(psector_id))
        self.upsert_config_param_user(dialog, aux_widget, "plan_psector_vdefault")

        message = "Values has been updated"
        self.controller.show_info(message)

        self.fill_table(qtbl_psm, "plan_psector")
        self.set_table_columns(dialog, qtbl_psm, "plan_psector")
        self.set_label_current_psector(dialog)
        self.open_dialog(dialog)


    def upsert_config_param_user(self, dialog,  widget, parameter):
        """ Insert or update values in tables with current_user control """

        tablename = "config_param_user"
        sql = (f"SELECT * FROM {tablename}"
               f" WHERE cur_user = current_user")
        rows = self.controller.get_rows(sql)
        exist_param = False
        if type(widget) != QDateEdit:
            if qt_tools.getWidgetText(dialog, widget) != "":
                for row in rows:
                    if row[0] == parameter:
                        exist_param = True
                if exist_param:
                    sql = f"UPDATE {tablename} SET value = "
                    if widget.objectName() != 'edit_state_vdefault':
                        sql += (f"'{qt_tools.getWidgetText(dialog, widget)}'"
                                f" WHERE cur_user = current_user AND parameter = '{parameter}'")
                    else:
                        sql += (f"(SELECT id FROM value_state"
                                f" WHERE name = '{qt_tools.getWidgetText(dialog, widget)}')"
                                f" WHERE cur_user = current_user AND parameter = 'edit_state_vdefault'")
                else:
                    sql = f'INSERT INTO {tablename} (parameter, value, cur_user)'
                    if widget.objectName() != 'edit_state_vdefault':
                        sql += f" VALUES ('{parameter}', '{qt_tools.getWidgetText(dialog, widget)}', current_user)"
                    else:
                        sql += (f" VALUES ('{parameter}',"
                                f" (SELECT id FROM value_state"
                                f" WHERE name = '{qt_tools.getWidgetText(dialog, widget)}'), current_user)")
        else:
            for row in rows:
                if row[0] == parameter:
                    exist_param = True
            _date = widget.dateTime().toString('yyyy-MM-dd')
            if exist_param:
                sql = (f"UPDATE {tablename}"
                       f" SET value = '{_date}'"
                       f" WHERE cur_user = current_user AND parameter = '{parameter}'")
            else:
                sql = (f"INSERT INTO {tablename} (parameter, value, cur_user)"
                       f" VALUES ('{parameter}', '{_date}', current_user);")
        self.controller.execute_sql(sql)


    def filter_by_text(self, dialog, table, widget_txt, tablename):

        result_select = qt_tools.getWidgetText(dialog, widget_txt)
        if result_select != 'null':
            expr = f" name ILIKE '%{result_select}%'"
            # Refresh model with selected filter
            table.model().setFilter(expr)
            table.model().select()
        else:
            self.fill_table(table, tablename)


    def charge_psector(self, qtbl_psm):

        selected_list = qtbl_psm.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        row = selected_list[0].row()
        psector_id = qtbl_psm.model().record(row).value("psector_id")
        self.close_dialog(self.dlg_psector_mng)
        self.master_new_psector(psector_id)


    def multi_rows_delete(self, dialog, widget, table_name, column_id, label, config_param, is_price=False):
        """ Delete selected elements of the table
        :param QTableView widget: origin
        :param table_name: table origin
        :param column_id: Refers to the id of the source table
        """

        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        inf_text = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = widget.model().record(row).value(str(column_id))
            inf_text += str(id_)+", "
            list_id += f"'{id_}', "
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        message = "Are you sure you want to delete these records?"
        answer = self.controller.ask_question(message, "Delete records", inf_text)

        if answer:
            if is_price is True:
                sql = "DELETE FROM selector_plan_result WHERE result_id in ("
                if list_id != '':
                    sql += f"{list_id}) AND cur_user = current_user;"
                    self.controller.execute_sql(sql, log_sql=True)
                    qt_tools.setWidgetText(dialog, label, '')
            sql = (f"DELETE FROM {table_name}"
                   f" WHERE {column_id} IN ({list_id});")
            self.controller.execute_sql(sql)
            widget.model().select()
            self.clean_label(dialog, label, list_id, config_param)


    def clean_label(self, dialog, label, list_id, config_param):
        row = self.controller.get_config(config_param, sql_added=f" AND value IN ({list_id})")
        if row is not None:
            sql = (f"DELETE FROM config_param_user "
                   f" WHERE parameter = '{config_param}' AND cur_user = current_user"
                   f" AND value = '{row[0]}'")
            self.controller.execute_sql(sql)
            qt_tools.setWidgetText(dialog, label, '')


    def master_estimate_result_manager(self):
        """ Button 50: Plan estimate result manager """

        # Create the dialog and signals
        self.dlg_merm = PriceManagerUi()
        self.load_settings(self.dlg_merm)

        # Set current value
        sql = (f"SELECT name FROM plan_result_cat WHERE result_id IN (SELECT result_id FROM selector_plan_result "
               f"WHERE cur_user = current_user)")
        row = self.controller.get_row(sql, log_sql=True)
        if row:
            qt_tools.setWidgetText(self.dlg_merm, 'lbl_vdefault_price', str(row[0]))

        # Tables
        tablename = 'plan_result_cat'
        self.tbl_om_result_cat = self.dlg_merm.findChild(QTableView, "tbl_om_result_cat")
        qt_tools.set_qtv_config(self.tbl_om_result_cat)

        # Set signals
        self.dlg_merm.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_merm))
        self.dlg_merm.rejected.connect(partial(self.close_dialog, self.dlg_merm))
        self.dlg_merm.btn_delete.clicked.connect(partial(self.delete_merm, self.dlg_merm))
        self.dlg_merm.btn_update_result.clicked.connect(partial(self.update_price_vdefault))
        self.dlg_merm.txt_name.textChanged.connect(partial(self.filter_merm, self.dlg_merm, tablename))

        set_edit_strategy = QSqlTableModel.OnManualSubmit
        self.fill_table(self.tbl_om_result_cat, tablename, set_edit_strategy)
        self.set_table_columns(self.tbl_om_result_cat, self.dlg_merm.tbl_om_result_cat, tablename)

        # Open form
        self.dlg_merm.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.open_dialog(self.dlg_merm, dlg_name="price_manager")


    def update_price_vdefault(self):
        selected_list = self.dlg_merm.tbl_om_result_cat.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        row = selected_list[0].row()
        price_name = self.dlg_merm.tbl_om_result_cat.model().record(row).value("name")
        result_id = self.dlg_merm.tbl_om_result_cat.model().record(row).value("result_id")
        qt_tools.setWidgetText(self.dlg_merm, 'lbl_vdefault_price', price_name)
        sql = (f"DELETE FROM selector_plan_result WHERE current_user = cur_user;"
               f"\nINSERT INTO selector_plan_result (result_id, cur_user)"
               f" VALUES({result_id}, current_user);")
        status = self.controller.execute_sql(sql)
        if status:
            message = "Values has been updated"
            self.controller.show_info(message)

        # Refresh canvas
        self.iface.mapCanvas().refreshAllLayers()


    def delete_merm(self, dialog):
        """ Delete selected row from 'master_estimate_result_manager' dialog from selected tab """

        self.multi_rows_delete(dialog, dialog.tbl_om_result_cat, 'plan_result_cat', 'result_id', 'lbl_vdefault_price', '', is_price=True)


    def filter_merm(self, dialog, tablename):
        """ Filter rows from 'master_estimate_result_manager' dialog from selected tab """

        self.filter_by_text(dialog, dialog.tbl_om_result_cat, dialog.txt_name, tablename)


    def psector_duplicate(self):
        """" Button 51: Duplicate psector """
        selected_list = self.qtbl_psm.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        row = selected_list[0].row()
        psector_id = self.qtbl_psm.model().record(row).value("psector_id")
        self.duplicate_psector = DuplicatePsector(self.iface, self.settings, self.controller, self.plugin_dir)
        self.duplicate_psector.is_duplicated.connect(partial(self.fill_table_psector, self.qtbl_psm, 'plan_psector'))
        self.duplicate_psector.is_duplicated.connect(partial(self.set_label_current_psector, self.dlg_psector_mng))
        self.duplicate_psector.manage_duplicate_psector(psector_id)

