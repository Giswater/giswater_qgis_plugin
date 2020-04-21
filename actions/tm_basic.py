"""
This file is part of tree_manage 1.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from functools import partial

from qgis.PyQt.QtCore import QDate
from qgis.PyQt.QtWidgets import QAbstractItemView, QTableView
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.core import QgsFeatureRequest
from .parent import ParentAction
from .tm_parent import TmParentAction
from .tm_manage_visit import TmManageVisit
from .tm_planning_unit import TmPlanningUnit
from ..ui.tm.month_manage import MonthManage
from ..ui.tm.month_selector import MonthSelector
from ..ui.tm.new_prices import NewPrices
from ..ui.tm.price_management import PriceManagement
from ..ui.tm.tree_manage import TreeManage
from ..ui.tm.tree_selector import TreeSelector
from ..ui.tm.incident_manager import IncidentManager
from ..ui_manager import IncidentPlanning

from .. import utils_giswater


class TmBasic(TmParentAction):
    
    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'basic' """
        
        TmParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.manage_visit = TmManageVisit(iface, settings, controller, plugin_dir)
        self.selected_camp = None
        self.campaign_id = None
        self.campaign_name = None
        self.rows_cmb_poda_type = None
        self.rows_cmb_builder = None
        self.parent = ParentAction(iface, settings, controller, plugin_dir)

    def set_tree_manage(self, tree_manage):
        self.tree_manage = tree_manage


    def basic_new_prices(self, dialog=None):
        """ Button 303: Price generator """
        
        # Close previous dialog
        if dialog is not None:
            self.close_dialog(dialog)
        self.dlg_new_campaign = NewPrices()
        self.load_settings(self.dlg_new_campaign)

        # Set default dates
        current_year = QDate.currentDate().year()
        start_date = QDate.fromString(str(int(current_year)) + '-11-01', 'yyyy-MM-dd')
        self.dlg_new_campaign.start_date.setDate(start_date)
        end_date = QDate.fromString(str(int(current_year)+1) + '-10-31', 'yyyy-MM-dd')
        self.dlg_new_campaign.end_date.setDate(end_date)

        table_name = 'cat_campaign'
        field_id = 'id'
        field_name = 'name'
        self.dlg_new_campaign.rejected.connect(partial(self.close_dialog, self.dlg_new_campaign))
        self.dlg_new_campaign.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_new_campaign))
        self.dlg_new_campaign.btn_accept.clicked.connect(partial(self.manage_new_price_catalog))
        
        self.populate_cmb_years(table_name, field_id, field_name,  self.dlg_new_campaign.cbx_years)
        self.set_completer_object(table_name, self.dlg_new_campaign.txt_campaign, field_name)
        
        if self.rows_cmb_poda_type is None:
            self.update_cmb_poda_type()     

        if self.rows_cmb_builder is None:
            self.update_cmb_builder()

        self.open_dialog(self.dlg_new_campaign)


    def manage_new_price_catalog(self):

        table_name = "cat_price"
        new_camp = self.dlg_new_campaign.txt_campaign.text()

        if new_camp is None or new_camp == '':
            msg = "Has de possar l'any corresponent"
            self.controller.show_warning(msg)
            return
        sql = (f"SELECT id FROM cat_campaign "
               f" WHERE name = '{new_camp}'")
        row = self.controller.get_row(sql)

        # If campaign not exist, create new one
        if row is None:
            start_date = utils_giswater.getCalendarDate(self.dlg_new_campaign, self.dlg_new_campaign.start_date)
            end_date = utils_giswater.getCalendarDate(self.dlg_new_campaign, self.dlg_new_campaign.end_date)
            sql = (f"INSERT INTO cat_campaign(name, start_date, end_date) "
                   f" VALUES('{new_camp}', '{start_date}', '{end_date}');")
            self.controller.execute_sql(sql)
            sql = "SELECT currval('cat_campaign_id_seq');"
            row = self.controller.get_row(sql)
            
            # Update contents of variable 'self.cmb_poda_type'
            self.update_cmb_poda_type()
          
        # Get id_campaign            
        id_new_camp = str(row[0])

        # Check if want copy any campaign or do new price list
        copy_years = self.dlg_new_campaign.chk_campaign.isChecked()
        if copy_years:
            id_old_camp = utils_giswater.get_item_data(self.dlg_new_campaign, self.dlg_new_campaign.cbx_years)
            # If checkbox is checked but don't have any campaign selected do return.
            if id_old_camp == -1:
                msg = "No tens cap any seleccionat, desmarca l'opcio de copiar preus"
                self.controller.show_warning(msg)
                return
        else:
            id_old_camp = 0

        sql = (f"SELECT DISTINCT(campaign_id) FROM {table_name} "
               f" WHERE campaign_id = '{id_new_camp}'")
        row = self.controller.get_row(sql)

        if not row or row is None:
            sql = f"SELECT create_price('{id_new_camp}','{id_old_camp}')"
            self.controller.execute_sql(sql)
        else:
            message = f"Estas a punt de sobreescriure els preus de la campanya {new_camp} "
            answer = self.controller.ask_question(message, "Warning")
            if not answer:
                return
            else:
                sql = f"SELECT create_price('{id_new_camp}','{id_old_camp}')"
                self.controller.execute_sql(sql)

        # Close perevious dialog
        self.close_dialog(self.dlg_new_campaign)
        self.manage_prices(id_new_camp)


    def manage_prices(self, id_camp, dialog=None):

        dlg_prices_management = PriceManagement()
        self.load_settings(dlg_prices_management)
        if id_camp is None:
            id_camp = self.get_campaing_id(dialog)
            dlg_prices_management.rejected.connect(partial(self.check_prices, dialog))

        # Set dialog and signals
        dlg_prices_management.btn_close.clicked.connect(partial(self.close_dialog, dlg_prices_management))
        dlg_prices_management.rejected.connect(partial(self.close_dialog, dlg_prices_management))
        
        # Populate QTableView
        table_view = 'v_edit_price'
        self.fill_table_prices(dlg_prices_management.tbl_price_list, table_view, id_camp, set_edit_triggers=QTableView.DoubleClicked)
        self.set_table_columns(dlg_prices_management, dlg_prices_management.tbl_price_list, table_view, 'basic_cat_price')

        self.open_dialog(dlg_prices_management)


    def update_cmb_poda_type(self):

        sql = ("SELECT DISTINCT(work_id), work_name"
               " FROM v_plan_mu"
               " ORDER BY work_name")
        self.rows_cmb_poda_type = self.controller.get_rows(sql)
        
        if not self.rows_cmb_poda_type:
            self.controller.log_info("Error in update_cmb_poda_type")           

    def update_cmb_builder(self):

        sql = ("SELECT DISTINCT(id), name"
               " FROM cat_builder"
               " ORDER BY name")
        self.rows_cmb_builder = self.controller.get_rows(sql)
        
        if not self.rows_cmb_builder:
            self.controller.log_info("Error in update_cmb_builder")


    def fill_table_prices(self, qtable, table_view, new_camp, set_edit_triggers=QTableView.NoEditTriggers):
        """ Set a model with selected filter and attach it to selected table
        @setEditStrategy: 0: OnFieldChange, 1: OnRowChange, 2: OnManualSubmit
        """
        if self.schema_name not in table_view:
            table_view = self.schema_name + "." + table_view

        # Set model
        model = QSqlTableModel()
        model.setTable(table_view)
        model.setEditStrategy(QSqlTableModel.OnFieldChange)
        model.setSort(2, 0)
        model.select()

        qtable.setEditTriggers(set_edit_triggers)
        
        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())
            return
        
        # Attach model to table view
        expr = f"campaign_id = '{new_camp}'"
        qtable.setModel(model)
        qtable.model().setFilter(expr)


    def main_tree_manage(self):
        """ Button 301: Tree selector """

        dlg_tree_manage = TreeManage()
        self.load_settings(dlg_tree_manage)
        dlg_tree_manage.btn_accept.setEnabled(False)
        table_name = 'cat_campaign'
        field_id = 'id'
        field_name = 'name'
        self.populate_cmb_years(table_name,  field_id, field_name, dlg_tree_manage.cbx_campaigns)
        self.populate_cmb_years(table_name,  field_id, field_name, dlg_tree_manage.cbx_pendientes)

        dlg_tree_manage.rejected.connect(partial(self.close_dialog, dlg_tree_manage))
        dlg_tree_manage.btn_cancel.clicked.connect(partial(self.close_dialog, dlg_tree_manage))
        dlg_tree_manage.btn_accept.clicked.connect(partial(self.get_year, dlg_tree_manage))
        dlg_tree_manage.btn_update_price.clicked.connect(partial(self.get_campaing_id, dlg_tree_manage))
        dlg_tree_manage.btn_update_price.clicked.connect(partial(self.manage_prices, None, dlg_tree_manage))
        dlg_tree_manage.txt_campaign.textChanged.connect(partial(self.check_prices, dlg_tree_manage))

        self.set_completer_object(table_name, dlg_tree_manage.txt_campaign, field_name)
        self.open_dialog(dlg_tree_manage)


    def check_prices(self, dialog):
        sql = (f"SELECT * FROM v_edit_price " 
              f"WHERE name = '{dialog.txt_campaign.text()}'"
               f" AND price is null")
        rows = self.controller.get_rows(sql)
        if not rows:
            dialog.btn_accept.setEnabled(True)
        else:
            dialog.btn_accept.setEnabled(False)


    def populate_cmb_years(self, table_name, field_id, field_name, combo, reverse=False):

        sql = (f"SELECT DISTINCT({field_id})::text, {field_name}::text"
               f" FROM {table_name}"
               f" WHERE {field_name}::text != ''")
        rows = self.controller.get_rows(sql)
        if rows is None:
            return

        utils_giswater.set_item_data(combo, rows, 1, reverse)


    def get_campaing_id(self, dialog):
        sql = (f"SELECT id FROM cat_campaign "
               f" WHERE name = '{dialog.txt_campaign.text()}'")
        row = self.controller.get_row(sql)
        if row is None:
            message = "No hi ha preus per aquest any"
            self.controller.show_warning(message)
            return None
        self.campaign_id = row[0]
        return row[0]

    
    def get_year(self, dialog):
               
        update = False
        self.selected_camp = None

        if dialog.txt_campaign.text() != '':
            status = self.get_campaing_id(dialog)
            if not status: return None
            sql = f"DELETE FROM selector_planning WHERE cur_user=current_user;"
            sql += f"INSERT INTO selector_planning VALUES ('{status}', current_user);"
            self.controller.execute_sql(sql, log_sql=True)
            if utils_giswater.isChecked(dialog, dialog.chk_campaign) and utils_giswater.get_item_data(dialog, dialog.cbx_campaigns, 0) != -1:
                self.selected_camp = utils_giswater.get_item_data(dialog, dialog.cbx_campaigns, 0)
                sql = (f"SELECT DISTINCT(campaign_id) FROM planning"
                       f" WHERE campaign_id ='{self.selected_camp}'")
                row = self.controller.get_row(sql)
                if row:
                    update = True
            else:
                self.selected_camp = self.campaign_id

            self.campaign_name = dialog.txt_campaign.text()
            self.close_dialog(dialog)
            bool_dic = {False: "false", True: "true"}
            cmb_pending = utils_giswater.get_item_data(dialog, dialog.cbx_pendientes)
            chk_pending = utils_giswater.isChecked(dialog, dialog.chk_pendiente)
            cmb_campaign = utils_giswater.get_item_data(dialog, dialog.cbx_campaigns)
            chk_campaign = utils_giswater.isChecked(dialog, dialog.chk_campaign)
            extras = f'"parameters":{{'
            extras += f'"txt_campaign":{self.campaign_id}, '
            extras += f'"cbx_pendientes":{cmb_pending}, '
            extras += f'"chk_pendiente":{bool_dic[chk_pending]}, '
            extras += f'"cbx_campaigns":{cmb_campaign}, '
            extras += f'"chk_campaign":{bool_dic[chk_campaign]}}}'
            body = self.parent.create_body(extras=extras)
            sql = ("SELECT tm_fct_copy_planning($${" + body + "}$$)::text")
            row = self.controller.get_row(sql)
            self.tree_selector(update)

        else:
            message = "Any recuperat es obligatori"
            self.controller.show_warning(message)
        
        self.controller.log_info("get_year_end")
        

    def tree_selector(self, update=False):

        dlg_selector = TreeSelector()
        self.load_settings(dlg_selector)
        dlg_selector.setWindowTitle("Tree selector")
        dlg_selector.lbl_year.setText(self.campaign_name)
        dlg_selector.all_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
        dlg_selector.selected_rows.setSelectionBehavior(QAbstractItemView.SelectRows)

        tableleft = 'v_plan_mu'
        tableright = 'planning'
        table_view = 'v_plan_mu_year'
        id_table_left = 'mu_id'
        id_table_right = 'mu_id'
        
        # Get data to fill combo from memory
        if self.rows_cmb_poda_type is None:
            self.update_cmb_poda_type()   

        utils_giswater.set_item_data(dlg_selector.cmb_poda_type, self.rows_cmb_poda_type, 1, sort_combo=False)

        # Get data to fill combo from memory
        if self.rows_cmb_builder is None:
            self.update_cmb_builder()   

        utils_giswater.set_item_data(dlg_selector.cmb_builder, self.rows_cmb_builder, 1, sort_combo=False)

        filter_builder = [['','']]
        for item in self.rows_cmb_builder:
            filter_builder.append(item)
        utils_giswater.set_item_data(dlg_selector.cmb_filter_builder, filter_builder, 1, sort_combo=False)

        # Populate QTableView
        self.fill_table(dlg_selector, table_view, set_edit_triggers=QTableView.NoEditTriggers, update=True)
        if update:
            self.insert_into_planning(tableright)

        # Need fill table before set table columns, and need re-fill table for upgrade fields
        self.set_table_columns(dlg_selector, dlg_selector.selected_rows, table_view, 'basic_year_right')
        self.fill_table(dlg_selector, table_view, set_edit_triggers=QTableView.NoEditTriggers)

        self.fill_main_table(dlg_selector, tableleft)
        self.set_table_columns(dlg_selector, dlg_selector.all_rows, tableleft, 'basic_year_left')

        # Set signals
        dlg_selector.chk_permanent.stateChanged.connect(partial(self.force_chk_current, dlg_selector))
        dlg_selector.btn_select.clicked.connect(partial(self.rows_selector, dlg_selector, id_table_left, tableright, id_table_right, tableleft, table_view))
        dlg_selector.all_rows.doubleClicked.connect(partial(self.rows_selector, dlg_selector, id_table_left, tableright, id_table_right, tableleft, table_view))
        dlg_selector.btn_unselect.clicked.connect(partial(self.rows_unselector, dlg_selector, tableright, id_table_right, tableleft, table_view))
        dlg_selector.selected_rows.doubleClicked.connect(partial(self.rows_unselector, dlg_selector, tableright, id_table_right, tableleft, table_view))
        dlg_selector.txt_search.textChanged.connect(partial(self.fill_main_table, dlg_selector, tableleft, set_edit_triggers=QTableView.NoEditTriggers))
        dlg_selector.txt_selected_filter.textChanged.connect(partial(self.fill_table, dlg_selector, table_view, set_edit_triggers=QTableView.NoEditTriggers))
        dlg_selector.cmb_filter_builder.currentIndexChanged.connect(partial(self.fill_table, dlg_selector, table_view, set_edit_triggers=QTableView.NoEditTriggers))
        dlg_selector.btn_close.clicked.connect(partial(self.close_dialog, dlg_selector))
        dlg_selector.btn_close.clicked.connect(partial(self.close_dialog, dlg_selector))
        dlg_selector.rejected.connect(partial(self.close_dialog, dlg_selector))  
        
        self.open_dialog(dlg_selector)
        

    def force_chk_current(self, dialog):

        if dialog.chk_permanent.isChecked():
            dialog.chk_current.setChecked(True)


    def fill_main_table(self, dialog, table_name, set_edit_triggers=QTableView.NoEditTriggers, refresh_model=True):
        """ Set a model with selected filter and attach it to selected table
        @setEditStrategy: 0: OnFieldChange, 1: OnRowChange, 2: OnManualSubmit
        """

        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        # Set model
        model = QSqlTableModel()
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnFieldChange)
        
        dialog.all_rows.setEditTriggers(set_edit_triggers)
        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())
            return

        # Get all ids from Qtable selected_rows
        id_all_selected_rows = self.select_all_rows(dialog.selected_rows, 'mu_id')

        # Convert id_all_selected_rows to string
        ids = "0, "
        for x in range(0, len(id_all_selected_rows)):
            ids += str(id_all_selected_rows[x]) + ", "
        ids = ids[:-2] + ""
        expr = (f" mu_name ILIKE '%{dialog.txt_search.text()}%'"
                f" AND mu_id NOT IN ({ids})"
                f" AND campaign_id = {self.campaign_id}"
                f" OR (campaign_id IS null AND mu_id NOT IN ({ids}))")
        (is_valid, exp) = self.check_expression(expr)
        if not is_valid:
            return
        model.setFilter(expr)
        
        # Refresh model?
        if refresh_model:               
            model.select()
                    
        # Attach model to table view
        dialog.all_rows.setModel(model)
             


    def fill_table(self, dialog, table_view, set_edit_triggers=QTableView.NoEditTriggers, update=False):
        """ Set a model with selected filter and attach it to selected table
        @setEditStrategy: 0: OnFieldChange, 1: OnRowChange, 2: OnManualSubmit
        """

        if self.schema_name not in table_view:
            table_view = self.schema_name + "." + table_view

        # Set model
        model = QSqlTableModel()
        model.setTable(table_view)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.setSort(2, 0)
        model.select()
                
        dialog.selected_rows.setEditTriggers(set_edit_triggers)
        
        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())
        builder = utils_giswater.get_item_data(dialog, dialog.cmb_filter_builder, 1)
        # Create expresion
        expr = f" mu_name ILIKE '%{dialog.txt_selected_filter.text()}%'"
        if builder:
            expr += f" AND builder ILIKE '%{builder}%'"

        if self.selected_camp is not None:
            expr += f" AND campaign_id = '{self.campaign_id}'"
            if update:
                expr += f" OR campaign_id = '{self.selected_camp}'"
 
        # Attach model to table or view
        dialog.selected_rows.setModel(model)
        dialog.selected_rows.model().setFilter(expr)

        # Set year to plan to all rows in list
        for x in range(0, model.rowCount()):
            i = int(dialog.selected_rows.model().fieldIndex('campaign_id'))
            index = dialog.selected_rows.model().index(x, i)
            model.setData(index, self.campaign_id)
            
        self.calculate_total_price(dialog, self.campaign_id)


    def calculate_total_price(self, dialog, year):
        """ Update QLabel @lbl_total_price with sum of all price in @select_rows """
        
        selected_list = dialog.selected_rows.model()
        if selected_list is None:
            return
        total = 0
        
        # Sum all price
        for x in range(0, selected_list.rowCount()):
            if str(dialog.selected_rows.model().record(x).value('campaign_id')) == str(year):
                if str(dialog.selected_rows.model().record(x).value('price')) != 'NULL':
                    total += float(dialog.selected_rows.model().record(x).value('price'))
                    
        utils_giswater.setText(dialog, dialog.lbl_total_price, str(total))


    def insert_into_planning(self, tableright):
        
        sql = (f"SELECT * FROM {tableright} "
               f"WHERE campaign_id::text = '{self.selected_camp}'")
        rows = self.controller.get_rows(sql)

        if not rows:
            return
        
        for row in rows:
            insert_values = ""
            function_values = ""
            if row['mu_id'] is not None:
                insert_values += f"'{row['mu_id']}', "
                function_values += f"{int(row['mu_id'])}, "
            else:
                insert_values += 'null, '
            if row['work_id'] is not None:
                insert_values += f"'{row['work_id']}', "
                function_values += f"{row['work_id']}, "
            else:
                insert_values += 'null, '
            if str(row['price']) != 'NULL':
                insert_values += f"'{row['price']}', "
            else:
                insert_values += 'null, '
            insert_values += f"'{self.campaign_id}', "
            insert_values = insert_values[:len(insert_values) - 2]
            function_values += f"{self.campaign_id}, "
            function_values = function_values[:len(function_values) - 2]
            # Check if mul_id and year_ already exists in planning
            sql = (f"SELECT  mu_id  "
                   f" FROM {tableright}"
                   f" WHERE mu_id = '{row['mu_id']}'"
                   f" AND campaign_id ='{self.campaign_id}'")
            row = self.controller.get_row(sql)
            if row is None:
                sql = (f"INSERT INTO {tableright}"
                       f" (mu_id, work_id, price, campaign_id) "
                       f" VALUES ({insert_values});")
                sql += f"\nSELECT set_plan_price({function_values});"
                self.controller.execute_sql(sql)


    def rows_selector(self, dialog, id_table_left, table_view, id_table_right, tableleft, tableright):
        """ Copy the selected lines in the qtable_all_rows and in the table
        :param dialog: QDialog
        :param id_table_left: Field id of table left
        :param tableright: Name of table or view used to populate QtableView on right side
        :param id_table_right: Field id of table right
        :param tableleft: Name of table or view used to populate QtableView on left side
        :param table_view: Table or view where find and insert values
        :return:
        """
        # tableleft = 'v_plan_mu'
        # tableright = 'planning'
        # table_view = 'v_plan_mu_year'
        
        left_selected_list = dialog.all_rows.selectionModel().selectedRows()
        if len(left_selected_list) == 0:
            message = "Cap registre seleccionat"
            self.controller.show_warning(message)
            return
        
        # Get all selected ids
        field_list = []
        for i in range(0, len(left_selected_list)):
            row = left_selected_list[i].row()
            id_ = dialog.all_rows.model().record(row).value(id_table_left)
            field_list.append(id_)

        # Select all rows and get all id
        self.select_all_rows(dialog.selected_rows, id_table_right)
        if utils_giswater.isChecked(dialog, dialog.chk_current):
            current_poda_type = utils_giswater.get_item_data(dialog, dialog.cmb_poda_type, 0)
            # current_poda_name = utils_giswater.get_item_data(dialog, dialog.cmb_poda_type, 1)
            if current_poda_type is None:
                message = "No heu seleccionat cap poda"
                self.controller.show_warning(message)
                return
            
        if utils_giswater.isChecked(dialog, dialog.chk_permanent):
            for i in range(0, len(left_selected_list)):
                row = left_selected_list[i].row()
                sql = (f"UPDATE cat_mu "
                       f" SET work_id = '{current_poda_type}'"
                       f" WHERE id = '{dialog.all_rows.model().record(row).value('mu_id')}'")
                self.controller.execute_sql(sql)
        builder = utils_giswater.get_item_data(dialog, dialog.cmb_builder, 0)
        for i in range(0, len(left_selected_list)):
            row = left_selected_list[i].row()
            values = ""
            function_values = ""
            if dialog.all_rows.model().record(row).value('mu_id') is not None:
                values += f"{dialog.all_rows.model().record(row).value('mu_id')}, "
                function_values += f"{dialog.all_rows.model().record(row).value('mu_id')}, "
            else:
                values += 'null, '

            if dialog.all_rows.model().record(row).value('work_id') is not None:
                if utils_giswater.isChecked(dialog, dialog.chk_current):
                    values += f"{current_poda_type}, "
                    function_values += f"{current_poda_type}, "
                else:
                    values += f"{dialog.all_rows.model().record(row).value('work_id')}, "
                    function_values += f"{dialog.all_rows.model().record(row).value('work_id')}, "
            else:
                values += 'null, '

            values += f"{self.campaign_id}, "
            values += f"{builder}, "
            values = values[:len(values) - 2]
            function_values += f"{self.campaign_id}, "
            function_values = function_values[:len(function_values) - 2]

            # Check if mul_id and year_ already exists in planning
            sql = (f"SELECT {id_table_right}"
                   f" FROM {table_view}"
                   f" WHERE {id_table_right} = '{field_list[i]}'"
                   f" AND campaign_id = '{self.campaign_id}';")
            row = self.controller.get_row(sql, log_sql=True)

            if row is not None:
                # if exist - show warning
                message = "Aquest registre ja esta seleccionat"
                self.controller.show_info_box(message, "Info", parameter=str(field_list[i]))
            else:
                sql = (f"INSERT INTO {table_view}"
                       f" (mu_id, work_id, campaign_id, builder_id) VALUES ({values})")
                self.controller.execute_sql(sql)
                sql = f"SELECT set_plan_price({function_values})"
                self.controller.execute_sql(sql, log_sql=True)

        # Refresh tables
        self.fill_table(dialog, tableright, set_edit_triggers=QTableView.NoEditTriggers)
        self.fill_main_table(dialog, tableleft)


    def rows_unselector(self, dialog, tableright, field_id_right, tableleft, table_view):

        sql = (f"DELETE FROM {tableright}"
               f" WHERE campaign_id = '{self.campaign_id}' AND {field_id_right} = ")
        selected_list = dialog.selected_rows.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Cap registre seleccionat"
            self.controller.show_warning(message)
            return
        
        field_list = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = str(dialog.selected_rows.model().record(row).value(field_id_right))
            field_list.append(id_)
        for i in range(0, len(field_list)):
            _sql = sql + f"'{field_list[i]}'"
            self.controller.execute_sql(_sql, log_sql=True)
            
        # Refresh tables
        self.fill_table(dialog, table_view, set_edit_triggers=QTableView.NoEditTriggers)
        self.fill_main_table(dialog, tableleft)


    def basic_month_manage(self):
        """ Button 302: Planned year manage """
        
        month_manage = MonthManage()

        self.load_settings(month_manage)
        month_manage.setWindowTitle("Planificador mensual")

        table_name = 'planning'
        self.set_completer_object(table_name, month_manage.txt_plan_code, 'plan_code')
        table_name = 'cat_campaign'
        field_id = 'id'
        field_name = 'name'
        self.populate_cmb_years(table_name, field_id, field_name, month_manage.cbx_years, reverse=True)

        month_manage.rejected.connect(partial(self.close_dialog, month_manage))
        month_manage.btn_cancel.clicked.connect(partial(self.close_dialog, month_manage))
        month_manage.btn_accept.clicked.connect(partial(self.get_planned_camp, month_manage))

        month_manage.exec_()


    def get_planned_camp(self, dialog):

        if str(utils_giswater.getWidgetText(dialog, dialog.txt_plan_code)) == 'null':
            message = "El camp text a no pot estar vuit"
            self.controller.show_warning(message)
            return

        self.plan_code = utils_giswater.getWidgetText(dialog, dialog.txt_plan_code)
        self.planned_camp_id = utils_giswater.get_item_data(dialog, dialog.cbx_years, 0)
        self.planned_camp_name = utils_giswater.get_item_data(dialog, dialog.cbx_years, 1)
        sql = f"DELETE FROM selector_planning WHERE cur_user=current_user;"
        sql += f"INSERT INTO selector_planning VALUES ('{self.planned_camp_id}', current_user);"
        self.controller.execute_sql(sql, log_sql=True)

        if self.planned_camp_id == -1:
            message = "No hi ha cap any planificat"
            self.controller.show_warning(message)
            return
        
        sql = f"DELETE FROM selector_planning WHERE cur_user=current_user;"
        sql += f"INSERT INTO selector_planning VALUES ('{self.planned_camp_id}', current_user);"
        self.controller.execute_sql(sql, log_sql=True)

        self.controller.log_info(str(self.planned_camp_id))
        self.close_dialog(dialog)
        self.month_selector()


    def month_selector(self):
        
        month_selector = MonthSelector()
        
        self.load_settings(month_selector)
        month_selector.all_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
        month_selector.selected_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
        month_selector.setWindowTitle("Planificador mensual")

        # Set label with selected text from previus dialog
        month_selector.lbl_plan_code.setText(self.plan_code)
        month_selector.lbl_year.setText(self.planned_camp_name)

        sql = (f"SELECT start_date, end_date FROM cat_campaign "
               f" WHERE id ='{self.planned_camp_id}'")
        row = self.controller.get_row(sql)
        if row is not None:
            start_date = QDate.fromString(str(row[0]), 'yyyy-MM-dd')
            end_date = QDate.fromString(str(row[1]), 'yyyy-MM-dd')
        else:
            start_date = QDate.currentDate()
            end_date = QDate.currentDate().addYears(1)

        utils_giswater.setCalendarDate(month_selector, month_selector.date_inici, start_date)
        utils_giswater.setCalendarDate(month_selector, month_selector.date_fi, end_date)

        view_name = 'v_plan_mu_year'
        tableleft = 'planning'
        id_table_left = 'mu_id'

        # Left QTableView
        expr = " AND ( plan_code is NULL OR plan_code = '')"

        self.fill_table_planned_month(month_selector.all_rows, month_selector.txt_search, view_name, expr)
        month_selector.txt_search.textChanged.connect(
            partial(self.fill_table_planned_month, month_selector.all_rows, month_selector.txt_search, view_name, expr, QTableView.NoEditTriggers))
        month_selector.btn_select.clicked.connect(
            partial(self.month_selector_row, month_selector, id_table_left, tableleft, view_name))
        self.set_table_columns(month_selector, month_selector.all_rows, view_name, 'basic_month_left')

        # Right QTableView
        expr = " AND plan_code = '" + self.plan_code + "'"

        self.fill_table_planned_month(month_selector.selected_rows, month_selector.txt_selected_filter, view_name, expr)
        month_selector.txt_selected_filter.textChanged.connect(
            partial(self.fill_table_planned_month, month_selector.selected_rows, month_selector.txt_selected_filter, view_name, expr, QTableView.NoEditTriggers))
        month_selector.btn_unselect.clicked.connect(
            partial(self.month_unselector_row, month_selector, id_table_left, tableleft, view_name))
        self.set_table_columns(month_selector, month_selector.selected_rows, view_name, 'basic_month_right')

        self.calculate_total_price(month_selector, self.planned_camp_id)

        # Get data to fill combo from memory
        self.update_cmb_builder()
        utils_giswater.set_item_data(month_selector.cmb_builder, self.rows_cmb_builder, 1, sort_combo=False)

        month_selector.btn_close.clicked.connect(partial(self.close_dialog, month_selector))
        month_selector.rejected.connect(partial(self.close_dialog, month_selector))

        month_selector.exec_()


    def month_selector_row(self, dialog, id_table_left, tableleft, view_name):
        
        left_selected_list = dialog.all_rows.selectionModel().selectedRows()
        if len(left_selected_list) == 0:
            message = "Cap registre seleccionat"
            self.controller.show_warning(message)
            return

        # Get all selected ids
        field_list = []
        for i in range(0, len(left_selected_list)):
            row = left_selected_list[i].row()
            id_ = dialog.all_rows.model().record(row).value(id_table_left)
            field_list.append(id_)

        # Get dates
        plan_month_start = utils_giswater.getCalendarDate(dialog, dialog.date_inici)
        plan_month_end = utils_giswater.getCalendarDate(dialog, dialog.date_fi)
        chk_builder = utils_giswater.isChecked(dialog, dialog.chk_builder)
        builder = utils_giswater.get_item_data(dialog, dialog.cmb_builder)
        # Update values
        for i in range(0, len(left_selected_list)):
            row = left_selected_list[i].row()
            sql = (f"UPDATE {tableleft} "
                   f" SET plan_code ='{self.plan_code}', "
                   f" plan_month_start = '{plan_month_start}', "
                   f" plan_month_end = '{plan_month_end}' ")
            if chk_builder:
                sql += f", builder_id = {builder} "
            sql += (f" WHERE id='{dialog.all_rows.model().record(row).value('id')}'"
                    f" AND mu_id ='{dialog.all_rows.model().record(row).value('mu_id')}'"
                    f" AND campaign_id = '{self.planned_camp_id}'")
            self.controller.execute_sql(sql)

        # Refresh QTableViews and recalculate price
        expr = " AND ( plan_code is NULL OR plan_code = '')"
        self.fill_table_planned_month(dialog.all_rows, dialog.txt_search, view_name, expr)
        expr = f" AND plan_code = '{self.plan_code}'"
        self.fill_table_planned_month(dialog.selected_rows, dialog.txt_selected_filter, view_name, expr)
        self.calculate_total_price(dialog, self.planned_camp_id)


    def month_unselector_row(self, dialog, id_table_left, tableleft, view_name):
        
        left_selected_list = dialog.selected_rows.selectionModel().selectedRows()
        if len(left_selected_list) == 0:
            message = "Cap registre seleccionat"
            self.controller.show_warning(message)
            return

        # Get all selected ids
        field_list = []
        for i in range(0, len(left_selected_list)):
            row = left_selected_list[i].row()
            id_ = dialog.selected_rows.model().record(row).value(id_table_left)
            field_list.append(id_)
        chk_builder = utils_giswater.isChecked(dialog, dialog.chk_builder)
        builder = utils_giswater.get_item_data(dialog, dialog.cmb_builder)
        for i in range(0, len(left_selected_list)):
            row = left_selected_list[i].row()
            sql = (f"UPDATE {tableleft} "
                   f" SET plan_code = null, "
                   f" plan_month_start = null, "
                   f" plan_month_end = null ")
            if chk_builder:
                sql += f", builder_id = {builder} "
            sql += (f" WHERE mu_id = '{dialog.selected_rows.model().record(row).value('mu_id')}'"
                    f" AND campaign_id = '{self.planned_camp_id}'")
            self.controller.execute_sql(sql)

        # Refresh QTableViews and recalculate price
        expr = " AND ( plan_code is NULL OR plan_code = '')"
        self.fill_table_planned_month(dialog.all_rows, dialog.txt_search, view_name, expr)
        expr = f" AND plan_code = '{self.plan_code}'"
        self.fill_table_planned_month(dialog.selected_rows, dialog.txt_selected_filter, view_name, expr)
        self.calculate_total_price(dialog, self.planned_camp_id)


    def fill_table_planned_month(self, qtable, txt_filter, tableright, expression=None, set_edit_triggers=QTableView.NoEditTriggers):
        """ Set a model with selected filter and attach it to selected table
        @setEditStrategy: 0: OnFieldChange, 1: OnRowChange, 2: OnManualSubmit
        """
        if self.schema_name not in tableright:
            tableright = f"{self.schema_name}.{tableright}"

        # Set model
        model = QSqlTableModel()
        model.setTable(tableright)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.setSort(2, 0)
        model.select()
        qtable.setEditTriggers(set_edit_triggers)
        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())

        # Create expresion
        expr = (f" mu_name ILIKE '%{txt_filter.text()}%' "
                f" AND campaign_id = '{self.planned_camp_id}' ")

        if expression is not None:
            expr += expression

        qtable.setModel(model)
        qtable.model().setFilter(expr)


    def select_all_rows(self, qtable, id, clear_selection=True):
        """ Return list of index in @qtable """
                       
        # Select all rows and get all id
        qtable.selectAll()
        right_selected_list = qtable.selectionModel().selectedRows()
        right_field_list = []
        for i in range(0, len(right_selected_list)):
            row = right_selected_list[i].row()
            id_ = qtable.model().record(row).value(id)
            right_field_list.append(id_)
        if clear_selection:
            qtable.clearSelection()
                    
        return right_field_list


    def get_table_columns(self, tablename):

        # Get columns name in order of the table
        sql = (f"SELECT column_name FROM information_schema.columns"
               f" WHERE table_name = '{tablename}'"
               f" AND table_schema = '" + self.schema_name.replace('"', '') + "'"
               f" ORDER BY ordinal_position")
        column_names = self.controller.get_rows(sql)
        return column_names


    def accept_changes(self, dialog, tableleft):
        
        model = dialog.selected_rows.model()
        model.database().transaction()
        if model.submitAll():
            model.database().commit()
            dialog.selected_rows.selectAll()
            id_all_selected_rows = dialog.selected_rows.selectionModel().selectedRows()
            for x in range(0, len(id_all_selected_rows)):
                row = id_all_selected_rows[x].row()
                if dialog.selected_rows.model().record(row).value('work_id') is not None:
                    work_id = str(dialog.selected_rows.model().record(row).value('work_id'))
                    mu_id = str(dialog.selected_rows.model().record(row).value('mu_id'))
                    sql = (f"UPDATE {tableleft}"
                           f" SET work_id = '{work_id}' "
                           f" WHERE mu_id = '{mu_id}'")
                    self.controller.execute_sql(sql)
        else:
            model.database().rollback()


    def cancel_changes(self, dialog):

        model = dialog.selected_rows.model()
        model.revertAll()
        model.database().rollback()


    def add_visit(self):
        """ Button 304: Add visit """
        
        self.manage_visit.manage_visit()
        

    def open_planning_unit(self):

        plan_unit = TmPlanningUnit(self.iface, self.settings, self.controller, self.plugin_dir)
        plan_unit.open_form()


    def open_incident_manager(self):
        """ Button 309: Add visit """

        self.dlg_incident_manager = IncidentManager()
        self.load_settings(self.dlg_incident_manager)

        sql = "SELECT id, idval FROM om_visit_typevalue WHERE typevalue = 'incident_status'"
        rows = self.controller.get_rows(sql, log_sql=True)
        utils_giswater.set_item_data(self.dlg_incident_manager.cmb_status, rows, 1, add_empty=True)

        self.set_dates_from_to(self.dlg_incident_manager.date_from, self.dlg_incident_manager.date_to,
                               'v_ui_om_visit_incident', 'incident_date', 'incident_date')

        # Poulate TableView
        utils_giswater.set_qtv_config(self.dlg_incident_manager.tbl_incident, edit_triggers=QTableView.NoEditTriggers)
        table_name = "v_ui_om_visit_incident"
        self.update_table(self.dlg_incident_manager, self.dlg_incident_manager.tbl_incident, table_name)

        # Signals
        self.dlg_incident_manager.txt_visit_id.textChanged.connect(partial(self.update_table, self.dlg_incident_manager, self.dlg_incident_manager.tbl_incident, table_name))
        self.dlg_incident_manager.cmb_status.currentIndexChanged.connect(partial(self.update_table, self.dlg_incident_manager, self.dlg_incident_manager.tbl_incident, table_name))
        self.dlg_incident_manager.btn_process.clicked.connect(partial(self.open_incident_planning, 'PROCESS'))
        self.dlg_incident_manager.btn_discard.clicked.connect(partial(self.open_incident_planning, 'DISCARD'))
        self.dlg_incident_manager.btn_zoom.clicked.connect(partial(self.zoom_to_element))
        self.dlg_incident_manager.btn_image.clicked.connect(partial(self.open_image))
        self.dlg_incident_manager.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_incident_manager))
        self.dlg_incident_manager.date_from.dateChanged.connect(partial(self.update_table, self.dlg_incident_manager, self.dlg_incident_manager.tbl_incident, table_name))
        self.dlg_incident_manager.date_to.dateChanged.connect(partial(self.update_table, self.dlg_incident_manager, self.dlg_incident_manager.tbl_incident, table_name))


        # Open form
        self.dlg_incident_manager.setWindowTitle("Incident Manager")
        self.dlg_incident_manager.exec_()


    def update_table(self, dialog, qtable, table_name):

        visit_id = utils_giswater.getWidgetText(dialog, dialog.txt_visit_id)
        status_id = utils_giswater.get_item_data(dialog, dialog.cmb_status, 1)
        visit_start = dialog.date_from.date()
        visit_end = dialog.date_to.date()

        date_from = visit_start.toString('ddMMyyyy')
        date_to = visit_end.toString('ddMMyyyy')

        if date_from > date_to:
            message = "Selected date interval is not valid"
            self.controller.show_warning(message)
            return

        expr_filter = f"1=1 "

        format_low = 'dd-MM-yyyy' + ' 00:00:00.000'
        format_high = 'dd-MM-yyyy' + ' 23:59:59.999'
        interval = "'" + str(visit_start.toString(format_low)) + "'::timestamp AND '" + str(
            visit_end.toString(format_high)) + "'::timestamp"

        # expr_filter = " AND (incident_date BETWEEN " + str(interval) + ")"

        # if visit_id not in (None, '', 'null'): expr_filter += f" AND visit_id::text LIKE '%{visit_id}%'"
        if status_id: expr_filter += f" AND status ='{status_id}'"

        self.fill_table_incident(qtable, table_name, expr_filter=expr_filter)

        self.get_id_list()


    def fill_table_incident(self, qtable, table_name,  expr_filter=None):

        expr = None
        if expr_filter:
            # Check expression
            (is_valid, expr) = self.check_expression(expr_filter)  # @UnusedVariable
            if not is_valid:
                return expr

        # Set a model with selected filter expression
        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        # Set model
        model = QSqlTableModel()
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnFieldChange)
        model.setSort(0, 0)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())
        # Attach model to table view
        if expr:
            qtable.setModel(model)
            qtable.model().setFilter(expr_filter)
        else:
            qtable.setModel(model)

        return expr


    def get_id_list(self):

        self.ids = []
        column_index = utils_giswater.get_col_index_by_col_name(self.dlg_incident_manager.tbl_incident, 'node_id')
        for x in range(0, self.dlg_incident_manager.tbl_incident.model().rowCount()):
            _id = self.dlg_incident_manager.tbl_incident.model().data(self.dlg_incident_manager.tbl_incident.model().index(x, column_index))
            self.ids.append(_id)


    def open_incident_planning(self, action):

        self.dlg_incident_planning = IncidentPlanning()
        self.load_settings(self.dlg_incident_planning)


        #Hide widgets
        if action == 'DISCARD':
            self.dlg_incident_planning.lbl_campaign_id.setVisible(False)
            self.dlg_incident_planning.lbl_work_id.setVisible(False)
            self.dlg_incident_planning.lbl_builder_id.setVisible(False)
            self.dlg_incident_planning.lbl_priority_id.setVisible(False)
            self.dlg_incident_planning.campaign_id.setVisible(False)
            self.dlg_incident_planning.work_id.setVisible(False)
            self.dlg_incident_planning.builder_id.setVisible(False)
            self.dlg_incident_planning.priority_id.setVisible(False)
        else:
            sql = "SELECT id, name FROM cat_campaign"
            rows = self.controller.get_rows(sql, log_sql=True)
            utils_giswater.set_item_data(self.dlg_incident_planning.campaign_id, rows, 1)
            sql = "SELECT id, name FROM cat_work"
            rows = self.controller.get_rows(sql, add_empty_row=True)
            utils_giswater.set_item_data(self.dlg_incident_planning.work_id, rows, 1)
            sql = "SELECT id, name FROM cat_builder"
            rows = self.controller.get_rows(sql, add_empty_row=True)
            utils_giswater.set_item_data(self.dlg_incident_planning.builder_id, rows, 1)
            sql = "SELECT id, name FROM cat_priority"
            rows = self.controller.get_rows(sql, add_empty_row=True)
            utils_giswater.set_item_data(self.dlg_incident_planning.priority_id, rows, 1)

        # Get record selected
        selected_list = self.dlg_incident_manager.tbl_incident.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        elif len(selected_list) > 1:
            message = "More than one record selected"
            self.controller.show_warning(message)
            return

        row = selected_list[0].row()

        # Get object_id from selected row
        self.visit_id = self.dlg_incident_manager.tbl_incident.model().record(row).value("visit_id")
        self.node_id = self.dlg_incident_manager.tbl_incident.model().record(row).value("node_id")
        self.incident_date = self.dlg_incident_manager.tbl_incident.model().record(row).value("incident_date")
        self.incident_user = self.dlg_incident_manager.tbl_incident.model().record(row).value("incident_user")
        self.parameter_id = self.dlg_incident_manager.tbl_incident.model().record(row).value("parameter_id")
        self.incident_comment = self.dlg_incident_manager.tbl_incident.model().record(row).value("incident_comment")
        if self.incident_comment in (None, 'null', 'NULL'):
            self.incident_comment = ''
        utils_giswater.setWidgetText(self.dlg_incident_planning, self.dlg_incident_planning.visit_id, self.visit_id)
        utils_giswater.setWidgetText(self.dlg_incident_planning, self.dlg_incident_planning.node_id, self.node_id)
        utils_giswater.setCalendarDate(self.dlg_incident_planning, self.dlg_incident_planning.incident_date, self.incident_date)
        utils_giswater.setWidgetText(self.dlg_incident_planning, self.dlg_incident_planning.incident_user, self.incident_user)
        utils_giswater.setWidgetText(self.dlg_incident_planning, self.dlg_incident_planning.parameter_id, self.parameter_id)
        utils_giswater.setWidgetText(self.dlg_incident_planning, self.dlg_incident_planning.incident_comment, self.incident_comment)
        utils_giswater.setWidgetText(self.dlg_incident_planning, self.dlg_incident_planning.process_user, self.controller.get_current_user())

        utils_giswater.setCalendarDate(self.dlg_incident_planning, self.dlg_incident_planning.process_date, None)

        # Set signals
        self.dlg_incident_planning.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_incident_planning))
        self.dlg_incident_planning.btn_accept.clicked.connect(partial(self.manage_incident_planning, action))

        self.open_dialog(self.dlg_incident_planning)


    def manage_incident_planning(self, action):

        if action == 'PROCESS':

            campaign_id = utils_giswater.get_item_data(self.dlg_incident_planning, self.dlg_incident_planning.campaign_id, 0)
            work_id =utils_giswater.get_item_data(self.dlg_incident_planning, self.dlg_incident_planning.work_id, 0)
            priority_id = utils_giswater.get_item_data(self.dlg_incident_planning, self.dlg_incident_planning.priority_id, 0)
            builder_id = utils_giswater.get_item_data(self.dlg_incident_planning, self.dlg_incident_planning.builder_id, 0)

            if self.visit_id in ('', None, 'null') or campaign_id in ('', None, 'null') or work_id in ('', None, 'null')\
                    or priority_id in ('', None, 'null') or builder_id in ('', None, 'null'):
                message = "Some parameters are missing."
                self.controller.show_info(message)
                return

            extras = f'"visit_id":{self.visit_id}'
            extras += f', "campaign_id":{campaign_id}'
            extras += f', "work_id":{work_id}'
            body = self.create_body(extras=extras)
            result = self.controller.get_json('tm_fct_incident_check_plan', body, log_sql=True)

            if result['message']['level'] == 1:
                message = str(result['body']['data'] ['info']) + '\n' + "Continue?"
                answer = self.controller.ask_question(message)
                if not answer:
                    return

            extras = f'"action":"{action}"'
            extras += f', "visit_id":{self.visit_id}'
            extras += f', "process_date":"{utils_giswater.getCalendarDate(self.dlg_incident_planning, self.dlg_incident_planning.process_date)}"'
            extras += f', "campaign_id":{utils_giswater.get_item_data(self.dlg_incident_planning, self.dlg_incident_planning.campaign_id, 0)}'
            extras += f', "builder_id":{utils_giswater.get_item_data(self.dlg_incident_planning, self.dlg_incident_planning.builder_id, 0)}'
            extras += f', "priority_id":{utils_giswater.get_item_data(self.dlg_incident_planning, self.dlg_incident_planning.priority_id, 0)}'
            extras += f', "work_id":{utils_giswater.get_item_data(self.dlg_incident_planning, self.dlg_incident_planning.work_id, 0)}'
            extras += f', "incident_comment":"{utils_giswater.getWidgetText(self.dlg_incident_planning, self.dlg_incident_planning.incident_comment)}"'
            body = self.create_body(extras=extras)

            result = self.controller.get_json('tm_fct_incident', body, log_sql=True)

        elif action == 'DISCARD':
            extras = f'"action":"{action}"'
            extras += f', "visit_id":{self.visit_id}'
            extras += f', "process_date":"{utils_giswater.getCalendarDate(self.dlg_incident_planning, self.dlg_incident_planning.process_date)}"'
            extras += f', "incident_comment":"{utils_giswater.getWidgetText(self.dlg_incident_planning, self.dlg_incident_planning.incident_comment)}"'
            body = self.create_body(extras=extras)

            result = self.controller.get_json('tm_fct_incident', body, log_sql=True)

        if result['status'] == "Accepted":
            self.close_dialog(self.dlg_incident_planning)
            self.update_table(self.dlg_incident_manager, self.dlg_incident_manager.tbl_incident,"v_ui_om_visit_incident")


    def zoom_to_element(self):

        # Get record selected
        selected_list = self.dlg_incident_manager.tbl_incident.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        elif len(selected_list) > 1:
            message = "More than one record selected"
            self.controller.show_warning(message)
            return

        row = selected_list[0].row()

        # Get object_id from selected row
        node_id = self.dlg_incident_manager.tbl_incident.model().record(row).value("node_id")

        # Select node of shortest path on v_edit_node for ZOOM SELECTION
        expr_filter = f"node_id IN ({node_id})"
        (is_valid, expr) = self.check_expression(expr_filter, True)  # @UnusedVariable

        if not is_valid:
            return

        self.layer_node = self.controller.get_layer_by_tablename("v_edit_node")
        it = self.layer_node.getFeatures(QgsFeatureRequest(expr))
        self.id_list = [i.id() for i in it]
        self.layer_node.selectByIds(self.id_list)

        # Center shortest path in canvas - ZOOM SELECTION
        self.canvas.zoomToSelected(self.layer_node)


    def open_image(self):
        return


    def select_features_by_ids(self, geom_type, expr, layer_name):
        """ Select features of layers of group @geom_type applying @expr """

        # Build a list of feature id's and select them
        layer = self.controller.get_layer_by_tablename(layer_name)
        if expr is None:
            layer.removeSelection()
        else:
            it = layer.getFeatures(QgsFeatureRequest(expr))
            id_list = [i.id() for i in it]
            if len(id_list) > 0:
                layer.selectByIds(id_list)
            else:
                layer.removeSelection()
