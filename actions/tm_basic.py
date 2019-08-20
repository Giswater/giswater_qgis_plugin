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

from .tm_parent import TmParentAction
from .tm_manage_visit import TmManageVisit
from .tm_planning_unit import TmPlanningUnit
from ..ui.tm.month_manage import MonthManage
from ..ui.tm.month_selector import MonthSelector
from ..ui.tm.new_prices import NewPrices
from ..ui.tm.price_management import PriceManagement
from ..ui.tm.tree_manage import TreeManage
from ..ui.tm.tree_selector import TreeSelector
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
        start_date = QDate.fromString(str(int(current_year)) + '/11/01', 'yyyy/MM/dd')
        self.dlg_new_campaign.start_date.setDate(start_date)
        end_date = QDate.fromString(str(int(current_year)+1) + '/10/31', 'yyyy/MM/dd')
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

        self.dlg_new_campaign.exec_()


    def manage_new_price_catalog(self):

        table_name = "cat_price"
        new_camp = self.dlg_new_campaign.txt_campaign.text()

        if new_camp is None or new_camp == '':
            msg = "Has de possar l'any corresponent"
            self.controller.show_warning(msg)
            return
        sql = ("SELECT id FROM cat_campaign "
               " WHERE name = '" + str(new_camp) + "'")
        row = self.controller.get_row(sql)

        # If campaign not exist, create new one
        if row is None:
            start_date = utils_giswater.getCalendarDate(self.dlg_new_campaign, self.dlg_new_campaign.start_date)
            end_date = utils_giswater.getCalendarDate(self.dlg_new_campaign, self.dlg_new_campaign.end_date)
            sql = ("INSERT INTO cat_campaign(name, start_date, end_date) "
                   " VALUES('" + str(new_camp) + "', '" + str(start_date) + "', '" + str(end_date) + "');")
            self.controller.execute_sql(sql)
            sql = ("SELECT currval('cat_campaign_id_seq');")
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

        sql = ("SELECT DISTINCT(campaign_id) FROM " + str(table_name) + " "
               " WHERE campaign_id = '" + str(id_new_camp) + "'")
        row = self.controller.get_row(sql)

        if not row or row is None:
            sql = ("SELECT create_price('" + str(id_new_camp) + "','" + str(id_old_camp) + "')")
            self.controller.execute_sql(sql)
        else:
            message = ("Estas a punt de sobreescriure els preus de la campanya " + new_camp + " ")
            answer = self.controller.ask_question(message, "Warning")
            if not answer:
                return
            else:
                sql = ("SELECT create_price('" + str(id_new_camp) + "','" + str(id_old_camp) + "')")
                self.controller.execute_sql(sql)

        # Close perevious dialog
        self.close_dialog(self.dlg_new_campaign)

        # Set dialog and signals
        dlg_prices_management = PriceManagement()
        self.load_settings(dlg_prices_management)
        dlg_prices_management.btn_close.clicked.connect(partial(self.close_dialog, dlg_prices_management))
        dlg_prices_management.rejected.connect(partial(self.close_dialog, dlg_prices_management))
        
        # Populate QTableView
        table_view = 'v_edit_price'
        self.fill_table_prices(dlg_prices_management.tbl_price_list, table_view, id_new_camp, set_edit_triggers=QTableView.DoubleClicked)
        self.set_table_columns(dlg_prices_management, dlg_prices_management.tbl_price_list, table_view, 'basic_cat_price')
        dlg_prices_management.exec_()


    def update_cmb_poda_type(self):

        sql = ("SELECT DISTINCT(work_id), work_name"
               " FROM v_plan_mu"
               " ORDER BY work_name")
        self.rows_cmb_poda_type = self.controller.get_rows(sql)
        
        if not self.rows_cmb_poda_type:
            self.controller.log_info("Error in update_cmb_poda_type")                 


    def fill_table_prices(self, qtable, table_view, new_camp, set_edit_triggers=QTableView.NoEditTriggers):
        """ Set a model with selected filter and attach it to selected table
        @setEditStrategy: 0: OnFieldChange, 1: OnRowChange, 2: OnManualSubmit
        """

        # Set model
        model = QSqlTableModel()
        model.setTable(self.schema_name + "." + table_view)
        model.setEditStrategy(QSqlTableModel.OnFieldChange)
        model.setSort(2, 0)
        model.select()

        qtable.setEditTriggers(set_edit_triggers)
        
        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())
            return
        
        # Attach model to table view
        expr = "campaign_id = '"+new_camp+"'"
        qtable.setModel(model)
        qtable.model().setFilter(expr)


    def main_tree_manage(self):
        """ Button 301: Tree selector """

        dlg_tree_manage = TreeManage()
        self.load_settings(dlg_tree_manage)

        table_name = 'cat_campaign'
        field_id = 'id'
        field_name = 'name'
        self.populate_cmb_years(table_name,  field_id, field_name, dlg_tree_manage.cbx_campaigns)

        dlg_tree_manage.rejected.connect(partial(self.close_dialog, dlg_tree_manage))
        dlg_tree_manage.btn_cancel.clicked.connect(partial(self.close_dialog, dlg_tree_manage))
        dlg_tree_manage.btn_accept.clicked.connect(partial(self.get_year, dlg_tree_manage))
        self.set_completer_object(table_name, dlg_tree_manage.txt_campaign, field_name)

        dlg_tree_manage.exec_()


    def populate_cmb_years(self, table_name, field_id, field_name, combo, reverse=False):

        sql = ("SELECT DISTINCT(" + str(field_id) + ")::text, " + str(field_name) + "::text"
               " FROM " + table_name + ""
               " WHERE " + str(field_name) + "::text != ''")
        rows = self.controller.get_rows(sql)
        if rows is None:
            return

        utils_giswater.set_item_data(combo, rows, 1, reverse)


    def get_year(self, dialog):
               
        update = False
        self.selected_camp = None

        if dialog.txt_campaign.text() != '':
            
            sql = ("SELECT id FROM cat_campaign "
                   " WHERE name = '" + str(dialog.txt_campaign.text()) + "'")
            row = self.controller.get_row(sql)
            if row is None:
                message = "No hi ha preus per aquest any"
                self.controller.show_warning(message)
                return None
            self.campaign_id = row[0]

            if utils_giswater.isChecked(dialog, dialog.chk_campaign) and utils_giswater.get_item_data(dialog, dialog.cbx_campaigns, 0) != -1:
                self.selected_camp = utils_giswater.get_item_data(dialog, dialog.cbx_campaigns, 0)
                sql = ("SELECT DISTINCT(campaign_id) FROM planning"
                       " WHERE campaign_id ='" + str(self.selected_camp) + "'")
                row = self.controller.get_row(sql)
                if row:
                    update = True
            else:
                self.selected_camp = self.campaign_id
                
            self.campaign_name = dialog.txt_campaign.text()
            self.close_dialog(dialog)
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
        dlg_selector.btn_select.clicked.connect(
            partial(self.rows_selector, dlg_selector, id_table_left, tableright, id_table_right, tableleft, table_view))
        dlg_selector.all_rows.doubleClicked.connect(
            partial(self.rows_selector, dlg_selector, id_table_left, tableright, id_table_right, tableleft, table_view))
        dlg_selector.btn_unselect.clicked.connect(
            partial(self.rows_unselector, dlg_selector, tableright, id_table_right, tableleft, table_view))
        dlg_selector.selected_rows.doubleClicked.connect(
            partial(self.rows_unselector, dlg_selector, tableright, id_table_right, tableleft, table_view))   
        dlg_selector.txt_search.textChanged.connect(
            partial(self.fill_main_table, dlg_selector, tableleft, set_edit_triggers=QTableView.NoEditTriggers))
        dlg_selector.txt_selected_filter.textChanged.connect(
            partial(self.fill_table, dlg_selector, table_view, set_edit_triggers=QTableView.NoEditTriggers))
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

        # Set model
        model = QSqlTableModel()
        model.setTable(self.schema_name + "." + table_name)
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

        # Build expression
        expr = (" mu_name ILIKE '%" + dialog.txt_search.text() + "%'"
                " AND mu_id NOT IN (" + ids + ")"
                " AND campaign_id::text = '" + str(self.campaign_id) + "'"
                " OR campaign_id IS null")
        self.controller.log_info(expr)
        # (is_valid, expr) = self.check_expression(expr)  # @UnusedVariable
        # # if not is_valid:
        # #     return
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

        # Set model
        model = QSqlTableModel()
        model.setTable(self.schema_name + "." + table_view)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.setSort(2, 0)
        model.select()
                
        dialog.selected_rows.setEditTriggers(set_edit_triggers)
        
        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())

        # Create expresion
        expr = " mu_name ILIKE '%" + dialog.txt_selected_filter.text() + "%'"
        if self.selected_camp is not None:
            expr += " AND campaign_id = '" + str(self.campaign_id) + "'"
            if update:
                expr += " OR campaign_id = '" + str(self.selected_camp) + "'"

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
        
        sql = ("SELECT * FROM " + tableright + " "
               "WHERE campaign_id::text = '" + str(self.selected_camp) + "'")
        rows = self.controller.get_rows(sql)

        if not rows:
            return
        
        for row in rows:
            insert_values = ""
            function_values = ""
            if row['mu_id'] is not None:
                insert_values += "'" + str(row['mu_id']) + "', "
                function_values += "'" + str(row['mu_id']) + "', "
            else:
                insert_values += 'null, '
            if row['work_id'] is not None:
                insert_values += "'" + str(row['work_id']) + "', "
                function_values += "'" + str(row['work_id']) + "', "
            else:
                insert_values += 'null, '
            if str(row['price']) != 'NULL':
                insert_values += "'" + str(row['price']) + "', "
            else:
                insert_values += 'null, '
            insert_values += "'" + str(self.campaign_id) + "', "
            insert_values = insert_values[:len(insert_values) - 2]
            function_values += "" + str(self.campaign_id) + ", "
            function_values = function_values[:len(function_values) - 2]
            # Check if mul_id and year_ already exists in planning
            sql = ("SELECT  mu_id  "
                   " FROM " + tableright + ""
                   " WHERE mu_id = '" + str(row['mu_id']) + "'"
                   " AND campaign_id ='" + str(self.campaign_id) + "'")
            row = self.controller.get_row(sql)
            if row is None:
                sql = ("INSERT INTO " + tableright + ""
                       " (mu_id, work_id, price, campaign_id) "
                       " VALUES (" + insert_values + ");")
                sql += ("\nSELECT set_plan_price(" + function_values + ");")
                self.controller.execute_sql(sql)


    def rows_selector(self, dialog, id_table_left, tableright, id_table_right, tableleft, table_view):
        """ Copy the selected lines in the qtable_all_rows and in the table """
        
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
                sql = ("UPDATE cat_mu "
                       " SET work_id = '" + str(current_poda_type) + "'"
                       " WHERE id = '" + str(dialog.all_rows.model().record(row).value('mu_id')) + "'")
                self.controller.execute_sql(sql)

        for i in range(0, len(left_selected_list)):
            row = left_selected_list[i].row()
            values = ""
            function_values = ""
            if dialog.all_rows.model().record(row).value('mu_id') is not None:
                values += "'" + str(dialog.all_rows.model().record(row).value('mu_id')) + "', "
                function_values += "'" + str(dialog.all_rows.model().record(row).value('mu_id')) + "', "
            else:
                values += 'null, '

            if dialog.all_rows.model().record(row).value('work_id') is not None:
                if utils_giswater.isChecked(dialog, dialog.chk_current):
                    values += "'" + str(current_poda_type) + "', "
                    function_values += "'" + str(current_poda_type) + "', "
                else:
                    values += "'" + str(dialog.all_rows.model().record(row).value('work_id')) + "', "
                    function_values += "'" + str(dialog.all_rows.model().record(row).value('work_id')) + "', "
            else:
                values += 'null, '

            values += "'" + str(self.campaign_id) + "', "
            values = values[:len(values) - 2]
            function_values += "'" + str(self.campaign_id) + "', "
            function_values = function_values[:len(function_values) - 2]

            # Check if mul_id and year_ already exists in planning
            sql = ("SELECT " + id_table_right + ""
                   " FROM " + tableright + ""
                   " WHERE " + id_table_right + " = '" + str(field_list[i]) + "'"
                   " AND campaign_id = '" + str(self.campaign_id) + "';")
            row = self.controller.get_row(sql, log_sql=True)
            if row is not None:
                # if exist - show warning
                message = "Aquest registre ja esta seleccionat"
                self.controller.show_info_box(message, "Info", parameter=str(field_list[i]))
            else:
                sql = ("INSERT INTO " + tableright + ""
                       " (mu_id, work_id, campaign_id) VALUES (" + values + ")")
                self.controller.execute_sql(sql)
                sql = ("SELECT set_plan_price(" + function_values + ")")
                self.controller.execute_sql(sql)

        # Refresh tables
        self.fill_table(dialog, table_view, set_edit_triggers=QTableView.NoEditTriggers)
        self.fill_main_table(dialog, tableleft)


    def rows_unselector(self, dialog, tableright, field_id_right, tableleft, table_view):

        sql = ("DELETE FROM " + tableright + ""
               " WHERE campaign_id = '" + str(self.campaign_id) + "' AND " + field_id_right + " = ")
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
            _sql = (sql + "'" + str(field_list[i]) + "'")
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

        if self.planned_camp_id == -1:
            message = "No hi ha cap any planificat"
            self.controller.show_warning(message)
            return

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

        sql = ("SELECT start_date, end_date FROM cat_campaign "
               " WHERE id ='" + str(self.planned_camp_id) + "'")
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

        # Update values
        for i in range(0, len(left_selected_list)):
            row = left_selected_list[i].row()
            sql = ("UPDATE " + tableleft + " "
                   " SET plan_code ='" + self.plan_code + "', "
                   " plan_month_start = '" + plan_month_start + "', "
                   " plan_month_end = '" + plan_month_end + "' "
                   " WHERE id='" + str(dialog.all_rows.model().record(row).value('id')) + "'"
                   " AND mu_id ='" + str(dialog.all_rows.model().record(row).value('mu_id')) + "'"
                   " AND campaign_id = '" + self.planned_camp_id + "'")
            self.controller.execute_sql(sql)

        # Refresh QTableViews and recalculate price
        expr = " AND ( plan_code is NULL OR plan_code = '')"
        self.fill_table_planned_month(dialog.all_rows, dialog.txt_search, view_name, expr)
        expr = " AND plan_code = '" + self.plan_code + "'"
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

        for i in range(0, len(left_selected_list)):
            row = left_selected_list[i].row()
            sql = ("UPDATE " + tableleft + " "
                   " SET plan_code = null, "
                   " plan_month_start = null, "
                   " plan_month_end = null "
                   " WHERE mu_id = '" + str(dialog.selected_rows.model().record(row).value('mu_id')) + "'"
                   " AND campaign_id = '" + self.planned_camp_id + "'")
            self.controller.execute_sql(sql)

        # Refresh QTableViews and recalculate price
        expr = " AND ( plan_code is NULL OR plan_code = '')"
        self.fill_table_planned_month(dialog.all_rows, dialog.txt_search, view_name, expr)
        expr = " AND plan_code = '" + self.plan_code + "'"
        self.fill_table_planned_month(dialog.selected_rows, dialog.txt_selected_filter, view_name, expr)
        self.calculate_total_price(dialog, self.planned_camp_id)


    def fill_table_planned_month(self, qtable, txt_filter, tableright, expression=None, set_edit_triggers=QTableView.NoEditTriggers):
        """ Set a model with selected filter and attach it to selected table
        @setEditStrategy: 0: OnFieldChange, 1: OnRowChange, 2: OnManualSubmit
        """

        # Set model
        model = QSqlTableModel()
        model.setTable(self.schema_name + "." + tableright)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.setSort(2, 0)
        model.select()
        qtable.setEditTriggers(set_edit_triggers)
        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())

        # Create expresion
        expr = (" mu_name ILIKE '%" + str(txt_filter.text()) + "%' "
                " AND campaign_id = '" + str(self.planned_camp_id) + "' ")

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
        sql = ("SELECT column_name FROM information_schema.columns"
               " WHERE table_name = '" + tablename + "'"
               " AND table_schema = '" + self.schema_name.replace('"', '') + "'"
               " ORDER BY ordinal_position")
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
                    sql = ("UPDATE " + tableleft + ""
                           " SET work_id = '" + str(work_id) + "' "
                           " WHERE mu_id = '" + str(mu_id) + "'")
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

