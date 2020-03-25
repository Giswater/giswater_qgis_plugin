"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtWidgets import QDateEdit, QLineEdit, QTableView, QAbstractItemView
from qgis.PyQt.QtGui import QDoubleValidator
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtCore import Qt

import operator
from functools import partial

from .. import utils_giswater
from .manage_new_psector import ManageNewPsector
from ..ui_manager import Psector_management
from ..ui_manager import EstimateResultNew
from ..ui_manager import EstimateResultSelector
from ..ui_manager import EstimateResultManager
from ..ui_manager import Multirow_selector
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
        self.dlg_psector_mng = Psector_management()

        self.load_settings(self.dlg_psector_mng)
        table_name = "v_edit_plan_psector"
        column_id = "psector_id"

        # Tables
        self.qtbl_psm = self.dlg_psector_mng.findChild(QTableView, "tbl_psm")
        self.qtbl_psm.setSelectionBehavior(QAbstractItemView.SelectRows)

        # Set signals
        self.dlg_psector_mng.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_psector_mng))
        self.dlg_psector_mng.rejected.connect(partial(self.close_dialog, self.dlg_psector_mng))
        self.dlg_psector_mng.btn_delete.clicked.connect(partial(self.multi_rows_delete, self.dlg_psector_mng, self.qtbl_psm, table_name, column_id))
        self.dlg_psector_mng.btn_update_psector.clicked.connect(partial(self.update_current_psector, self.dlg_psector_mng, self.qtbl_psm))
        self.dlg_psector_mng.btn_duplicate.clicked.connect(self.psector_duplicate)
        self.dlg_psector_mng.txt_name.textChanged.connect(partial(self.filter_by_text, self.dlg_psector_mng, self.qtbl_psm, self.dlg_psector_mng.txt_name, table_name))
        self.dlg_psector_mng.tbl_psm.doubleClicked.connect(partial(self.charge_psector, self.qtbl_psm))
        self.fill_table_psector(self.qtbl_psm, table_name)
        self.set_table_columns(self.dlg_psector_mng, self.qtbl_psm, table_name)
        self.set_label_current_psector(self.dlg_psector_mng)

        # Open form
        self.dlg_psector_mng.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.open_dialog(self.dlg_psector_mng, dlg_name="psector_management")


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
        self.upsert_config_param_user(dialog, aux_widget, "psector_vdefault")

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
            if utils_giswater.getWidgetText(dialog, widget) != "":
                for row in rows:
                    if row[1] == parameter:
                        exist_param = True
                if exist_param:
                    sql = f"UPDATE {tablename} SET value = "
                    if widget.objectName() != 'state_vdefault':
                        sql += (f"'{utils_giswater.getWidgetText(dialog, widget)}'"
                                f" WHERE cur_user = current_user AND parameter = '{parameter}'")
                    else:
                        sql += (f"(SELECT id FROM value_state"
                                f" WHERE name = '{utils_giswater.getWidgetText(dialog, widget)}')"
                                f" WHERE cur_user = current_user AND parameter = 'state_vdefault'")
                else:
                    sql = f'INSERT INTO {tablename} (parameter, value, cur_user)'
                    if widget.objectName() != 'state_vdefault':
                        sql += f" VALUES ('{parameter}', '{utils_giswater.getWidgetText(dialog, widget)}', current_user)"
                    else:
                        sql += (f" VALUES ('{parameter}',"
                                f" (SELECT id FROM value_state"
                                f" WHERE name = '{utils_giswater.getWidgetText(dialog, widget)}'), current_user)")
        else:
            for row in rows:
                if row[1] == parameter:
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

        result_select = utils_giswater.getWidgetText(dialog, widget_txt)
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


    def multi_rows_delete(self, dialog, widget, table_name, column_id):
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
            sql = (f"DELETE FROM {table_name}"
                   f" WHERE {column_id} IN ({list_id})")
            self.controller.execute_sql(sql)
            widget.model().select()
            row = self.controller.get_config('psector_vdefault', sql_added=f" AND value IN ({list_id})")
            if row is not None:
                sql = (f"DELETE FROM config_param_user "
                       f" WHERE parameter = 'psector_vdefault' AND cur_user = current_user"
                       f" AND value = '{row[0]}'")
                self.controller.execute_sql(sql)
                utils_giswater.setWidgetText(dialog, 'lbl_vdefault_psector', '')


    def master_psector_selector(self):
        """ Button 47: Psector selector """

        # Create the dialog and signals
        self.dlg_psector_selector = Multirow_selector('psector')
        self.load_settings(self.dlg_psector_selector)
        self.dlg_psector_selector.btn_ok.clicked.connect(partial(self.close_dialog, self.dlg_psector_selector))
        self.dlg_psector_selector.setWindowTitle("Psector selector")
        utils_giswater.setWidgetText(self.dlg_psector_selector, self.dlg_psector_selector.lbl_filter, 
            self.controller.tr('Filter by: Psector name', context_name='labels'))
        utils_giswater.setWidgetText(self.dlg_psector_selector, self.dlg_psector_selector.lbl_unselected, 
            self.controller.tr('Unselected psectors', context_name='labels'))
        utils_giswater.setWidgetText(self.dlg_psector_selector, self.dlg_psector_selector.lbl_selected, 
            self.controller.tr('Selected psectors', context_name='labels'))

        tableleft = "plan_psector"
        tableright = "selector_psector"
        field_id_left = "psector_id"
        field_id_right = "psector_id"
        self.multi_row_selector(self.dlg_psector_selector, tableleft, tableright, field_id_left, field_id_right)
        self.open_dialog(self.dlg_psector_selector, dlg_name="multirow_selector", maximize_button=False)

        
    def master_estimate_result_new(self, tablename=None, result_id=None, index=0):
        """ Button 38: New estimate result """

        # Create dialog 
        dlg_estimate_result_new = EstimateResultNew()
        self.load_settings(dlg_estimate_result_new)

        # Set signals
        dlg_estimate_result_new.btn_close.clicked.connect(partial(self.close_dialog, dlg_estimate_result_new))
        dlg_estimate_result_new.prices_coefficient.setValidator(QDoubleValidator())

        self.populate_cmb_result_type(dlg_estimate_result_new.cmb_result_type, 'plan_result_type', False)

        if result_id != 0 and result_id:         
            sql = (f"SELECT * FROM {tablename} "
                   f" WHERE result_id = '{result_id}' AND current_user = cur_user")
            row = self.controller.get_row(sql)
            if row is None:
                message = "Any record found for current user in table"
                self.controller.show_warning(message, parameter='plan_result_cat')
                return

            utils_giswater.setWidgetText(dlg_estimate_result_new, dlg_estimate_result_new.result_id, row['result_id'])
            dlg_estimate_result_new.cmb_result_type.setCurrentIndex(index)
            utils_giswater.setWidgetText(dlg_estimate_result_new, dlg_estimate_result_new.prices_coefficient, row['network_price_coeff'])
            utils_giswater.setWidgetText(dlg_estimate_result_new, dlg_estimate_result_new.observ, row['descript'])
            dlg_estimate_result_new.result_id.setEnabled(False)
            dlg_estimate_result_new.cmb_result_type.setEnabled(False)
            dlg_estimate_result_new.prices_coefficient.setEnabled(False)
            dlg_estimate_result_new.observ.setEnabled(False)
            dlg_estimate_result_new.btn_calculate.setText("Close")
            dlg_estimate_result_new.btn_calculate.clicked.connect(partial(self.close_dialog))
        else:
            dlg_estimate_result_new.btn_calculate.clicked.connect(partial(self.master_estimate_result_new_calculate, dlg_estimate_result_new))            
        # TODO pending translation
        # Manage i18n of the form and open it
        # self.controller.translate_form(dlg_estimate_result_new, 'estimate_result_new')

        self.open_dialog(dlg_estimate_result_new, dlg_name="plan_estimate_result_new", maximize_button=False)


    def populate_cmb_result_type(self, combo, table_name, allow_nulls=True):

        sql = (f"SELECT id, name"
               f" FROM {table_name}"
               f" ORDER BY name")
        rows = self.controller.get_rows(sql)
        if not rows:
            return
        
        combo.blockSignals(True)
        combo.clear()
        if allow_nulls:
            combo.addItem("", "")
        records_sorted = sorted(rows, key=operator.itemgetter(1))
        for record in records_sorted:
            combo.addItem(record[1], record)
        combo.blockSignals(False)


    def master_estimate_result_new_calculate(self, dialog):
        """ Execute function 'gw_fct_plan_estimate_result' """

        # Get values from form
        result_id = utils_giswater.getWidgetText(dialog, "result_id")
        combo = utils_giswater.getWidget(dialog, "cmb_result_type")
        elem = combo.itemData(combo.currentIndex())
        result_type = str(elem[0])
        coefficient = utils_giswater.getWidgetText(dialog, "prices_coefficient")
        observ = utils_giswater.getWidgetText(dialog, "observ")

        if result_id == 'null':
            message = "Please, introduce a result name"
            self.controller.show_warning(message)
            return
        if coefficient == 'null':
            message = "Please, introduce a coefficient value"
            self.controller.show_warning(message)  
            return          

        extras = (f'"parameters":{{"coefficient":{coefficient}, "description":"{observ}"'
                  f'", "resultType":"{result_type}", "resultId":"{result_id}"}}')
        extras += ', "saveOnDatabase":' + str(utils_giswater.isChecked(dialog, dialog.chk_save)).lower()
        body = self.create_body(extras=extras)
        result = self.controller.get_json('gw_fct_plan_result', body, log_sql=True)
        if not result: return False

        if result['status'] == "Accepted":
            self.add_layer.populate_info_text(dialog, result['body']['data'])
        message = result['message']['text']
        if message is not None:
            self.controller.show_info_box(message)
        # Refresh canvas and close dialog
        self.iface.mapCanvas().refreshAllLayers()


    def master_estimate_result_selector(self):
        """ Button 49: Estimate result selector """

        # Create dialog 
        self.dlg_estimate_result_selector = EstimateResultSelector()
        self.load_settings(self.dlg_estimate_result_selector)
        
        # Populate combo
        self.populate_combo(self.dlg_estimate_result_selector.rpt_selector_result_id, 'plan_result_selector')

        # Set current value
        table_name = "om_result_cat"
        sql = (f"SELECT name FROM {table_name} "
               f" WHERE cur_user = current_user AND result_type = 1 AND result_id = (SELECT result_id FROM plan_result_selector)")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(self.dlg_estimate_result_selector, self.dlg_estimate_result_selector.rpt_selector_result_id, str(row[0]))
            
        # Set signals
        self.dlg_estimate_result_selector.btn_accept.clicked.connect(partial(self.master_estimate_result_selector_accept))
        self.dlg_estimate_result_selector.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_estimate_result_selector))
        # TODO pending translation
        # Manage i18n of the form and open it
        # self.controller.translate_form(self.dlg_estimate_result_selector, 'estimate_result_selector')
        self.open_dialog(self.dlg_estimate_result_selector, dlg_name="plan_estimate_result_selector",  maximize_button=False)


    def populate_combo(self, combo, table_result):

        table_name = "om_result_cat"
        sql = (f"SELECT name, result_id"
               f" FROM {table_name} "
               f" WHERE cur_user = current_user"
               f" AND result_type = 1"
               f" ORDER BY name")
        rows = self.controller.get_rows(sql)
        if not rows:
            return

        combo.blockSignals(True)
        combo.clear()
        records_sorted = sorted(rows, key=operator.itemgetter(1))
        for record in records_sorted:
            combo.addItem(record[0], record)
        combo.blockSignals(False)
        
        # Check if table exists
        if not self.controller.check_table(table_result):
            message = "Table not found"
            self.controller.show_warning(message, parameter=table_result)
            return
        
        sql = (f"SELECT result_id FROM {table_result} "
               f" WHERE cur_user = current_user")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setSelectedItem(self.dlg_estimate_result_selector, combo, str(row[0]))


    def upsert(self, combo, tablename):
        
        # Check if table exists
        if not self.controller.check_table(tablename):
            message = "Table not found"
            self.controller.show_warning(message, parameter=tablename)
            return
                
        result_id = utils_giswater.get_item_data(self.dlg_estimate_result_selector, combo, 1)
        sql = (f"DELETE FROM {tablename} WHERE current_user = cur_user;"
               f"\nINSERT INTO {tablename} (result_id, cur_user)"
               f" VALUES({result_id}, current_user);")
        status = self.controller.execute_sql(sql)
        if status:
            message = "Values has been updated"
            self.controller.show_info(message)

        # Refresh canvas
        self.iface.mapCanvas().refreshAllLayers()
        self.close_dialog(self.dlg_estimate_result_selector)
        

    def master_estimate_result_selector_accept(self):
        """ Update value of table 'plan_result_selector' """
        
        self.upsert(self.dlg_estimate_result_selector.rpt_selector_result_id, 'plan_result_selector')


    def master_estimate_result_manager(self):
        """ Button 50: Plan estimate result manager """

        # Create the dialog and signals
        self.dlg_merm = EstimateResultManager()
        self.load_settings(self.dlg_merm)

        #TODO activar este boton cuando sea necesario
        self.dlg_merm.btn_delete.setVisible(False)

        # Tables
        tablename = 'om_result_cat'
        self.tbl_om_result_cat = self.dlg_merm.findChild(QTableView, "tbl_om_result_cat")
        self.tbl_om_result_cat.setSelectionBehavior(QAbstractItemView.SelectRows)

        # Set signals
        self.dlg_merm.tbl_om_result_cat.doubleClicked.connect(partial(self.charge_plan_estimate_result, self.dlg_merm))
        self.dlg_merm.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_merm))
        self.dlg_merm.rejected.connect(partial(self.close_dialog, self.dlg_merm))
        self.dlg_merm.btn_delete.clicked.connect(partial(self.delete_merm, self.dlg_merm))
        self.dlg_merm.txt_name.textChanged.connect(partial(self.filter_merm, self.dlg_merm, tablename))

        set_edit_strategy = QSqlTableModel.OnManualSubmit
        self.fill_table(self.tbl_om_result_cat, tablename, set_edit_strategy)
        #self.set_table_columns(self.tbl_om_result_cat, tablename)

        # Open form
        self.dlg_merm.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.open_dialog(self.dlg_merm, dlg_name="plan_estimate_result_manager")


    def charge_plan_estimate_result(self, dialog):
        """ Send selected plan to 'plan_estimate_result_new.ui' """

        selected_list = dialog.tbl_om_result_cat.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        
        row = selected_list[0].row()
        result_id = dialog.tbl_om_result_cat.model().record(row).value("result_id")
        self.close_dialog(dialog)
        self.master_estimate_result_new('om_result_cat', result_id, 0)


    def delete_merm(self, dialog):
        """ Delete selected row from 'master_estimate_result_manager' dialog from selected tab """
        
        self.multi_rows_delete(dialog, dialog.tbl_om_result_cat, 'plan_result_cat', 'result_id')


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

