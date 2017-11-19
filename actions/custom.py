"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtCore import QDate
from PyQt4.QtSql import QSqlTableModel
from PyQt4.QtGui import QDateEdit,QPushButton, QFileDialog, QMessageBox, QAbstractItemView, QTableView
import os
import sys
import csv
from datetime import datetime
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater

from ..ui.selector_date import SelectorDate         # @UnresolvedImport
from ..ui.ud_om_add_visit_file import AddVisitFile  # @UnresolvedImport
from ..ui.dlg_custom_table import Dlg_Custom_table
from parent import ParentAction


class Custom(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control Management toolbar actions """
        self.minor_version = "3.0"
        # Call ParentAction constructor      
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)

        # Set project user
        self.current_user = self.controller.get_project_user()


    def custom_selector_date(self):
        """ Button 91. Selector date """
        
        self.dlg_selector_date = SelectorDate()
        utils_giswater.setDialog(self.dlg_selector_date)

        self.widget_date_from = self.dlg_selector_date.findChild(QDateEdit, "date_from")
        self.widget_date_to = self.dlg_selector_date.findChild(QDateEdit, "date_to")
        self.dlg_selector_date.findChild(QPushButton, "btn_accept").clicked.connect(self.update_dates_into_db)

        self.widget_date_from.dateChanged.connect(partial(self.update_date_to))
        self.widget_date_to.dateChanged.connect(partial(self.update_date_from))

        self.get_default_dates()
        utils_giswater.setCalendarDate(self.widget_date_from, self.from_date)
        utils_giswater.setCalendarDate(self.widget_date_to, self.to_date)
        self.dlg_selector_date.exec_()


    def update_date_to(self):
        """ If 'date from' is upper than 'date to' set 'date to' 1 day more than 'date from' """
        from_date = self.widget_date_from.date().toString('yyyy-MM-dd')
        to_date = self.widget_date_to.date().toString('yyyy-MM-dd')
        if from_date >= to_date:
            to_date = self.widget_date_from.date().addDays(1).toString('yyyy-MM-dd')
            utils_giswater.setCalendarDate(self.widget_date_to, datetime.strptime(to_date, '%Y-%m-%d'))


    def update_date_from(self):
        """ If 'date to' is lower than 'date from' set 'date from' 1 day less than 'date to' """
        from_date = self.widget_date_from.date().toString('yyyy-MM-dd')
        to_date = self.widget_date_to.date().toString('yyyy-MM-dd')
        if to_date <= from_date:
            from_date = self.widget_date_to.date().addDays(-1).toString('yyyy-MM-dd')
            utils_giswater.setCalendarDate(self.widget_date_from, datetime.strptime(from_date, '%Y-%m-%d'))


    def update_dates_into_db(self):
        """ Insert or update dates into data base """
        
        from_date = self.widget_date_from.date().toString('yyyy-MM-dd')
        to_date = self.widget_date_to.date().toString('yyyy-MM-dd')
        sql = "SELECT * FROM sanejament.selector_date WHERE cur_user = '" + self.current_user + "'"
        row = self.controller.get_row(sql)
        if row is None:
            sql = ("INSERT INTO sanejament.selector_date (from_date, to_date, context, cur_user)"
                " VALUES('"+from_date+"', '"+to_date+"', 'om_visit', '"+self.current_user+"')")
        else:
            sql = ("UPDATE sanejament.selector_date SET(from_date, to_date) = "
                "('" + from_date + "', '" + to_date + "') WHERE cur_user = '" + self.current_user + "'")

        self.dao.execute_sql(sql)

        self.dlg_selector_date.close()


    def custom_import_visit_csv(self):
        """ Button 92. Import visit from CSV file """

        self.dlg_import_visit_csv = AddVisitFile()
        utils_giswater.setDialog(self.dlg_import_visit_csv)
        self.dlg_import_visit_csv.findChild(QPushButton, "btn_accept").clicked.connect(self.import_visit_csv)
        self.dlg_import_visit_csv.findChild(QPushButton, "btn_cancel").clicked.connect(self.dlg_import_visit_csv.close)

        btn_file_csv = self.dlg_import_visit_csv.findChild(QPushButton, "btn_file_csv")
        btn_file_csv.clicked.connect(partial(self.select_file_csv))

        self.fill_combos()
        self.get_default_dates()

        utils_giswater.setWidgetText(self.dlg_import_visit_csv.txt_file_csv,self.controller.plugin_settings_value('LAST_CSV'))

        self.dlg_import_visit_csv.exec_()



    def save_csv_path(self):
        """ Save QGIS settings related with csv path """
        self.controller.plugin_settings_set_value("LAST_CSV", utils_giswater.getWidgetText('txt_file_csv'))


    def fill_combos(self):
        """ Fill combos """
        sql = "SELECT short_des FROM sanejament.om_visit_cat"
        rows = self.controller.get_rows(sql)
        if rows:
            utils_giswater.fillComboBox("visit_cat", rows, False)


    def select_file_csv(self):
        """ Select CSV file """
        self.file_inp = utils_giswater.getWidgetText('txt_file_csv')
        # Set default value if necessary
        if self.file_inp is None or self.file_inp == '':
            self.file_inp = self.plugin_dir
        # Get directory of that file
        folder_path = os.path.dirname(self.file_inp)
        if not os.path.exists(folder_path):
            folder_path = os.path.dirname(__file__)
        os.chdir(folder_path)
        msg = self.controller.tr("Select CSV file")
        self.file_inp = QFileDialog.getOpenFileName(None, msg, "", '*.csv')
        self.dlg_import_visit_csv.txt_file_csv.setText(self.file_inp)


    def import_visit_csv(self):
        
        path = utils_giswater.getWidgetText("txt_file_csv")
        catalog = utils_giswater.getWidgetText("visit_cat")
        #feature_type = utils_giswater.getWidgetText(self.feature_type).lower()
        if path != 'null':
            #self.dlg_import_visit_csv.progressBar.setVisible(True)
            message = 'Segur que vols actualitzar la taula  ?'
            #reply = QMessageBox.question(None, 'Actualitzacio de taules', message, QMessageBox.No | QMessageBox.Yes)
            #if reply == QMessageBox.Yes:
                #self.deleteTable()
            self.read_csv(path)
                #self.enableTrueAll()


    # C:/owncloud/Shared/Tecnics/feines/f697_AT_SBD_vialitat_2017/ampliacio_giswater_21/codi/pous.csv


    def read_csv(self, path):
        self.save_csv_path()
        cabecera = True
        fields = ""
        feature_type = ""
        cont = 0
        from_date = self.from_date.toString('dd/MM/yyyy')
        to_date = self.to_date.toString('dd/MM/yyyy')

        self.dlg_import_visit_csv.progressBar.setVisible(True)
        self.dlg_import_visit_csv.progressBar.setValue(cont)

        with open(path, 'rb') as csvfile:
            row_count = sum(1 for rows in csvfile)  # counts rows in csvfile, using var "row_count" to do progresbar
            self.dlg_import_visit_csv.progressBar.setMaximum(row_count -20)  # -20 for see 100% complete progress
            csvfile.seek(0)  # Position the cursor at position 0 of the file
            self.reader = csv.reader(csvfile, delimiter=',')

            for self.row in self.reader:
                
                values = "'"            
                cont += 1

                for x in range(0, len(self.row)):
                    self.row[x] = self.row[x].replace("'", "''")
                    self.row[x] = self.row[x].replace(",", ".")
                    
                if cabecera:
                    if len(self.row) == 17:
                        feature_type = "arc"
                    if len(self.row) == 16:
                        feature_type = "node"
                    sql = "DELETE FROM sanejament.temp_om_visit_" + str(feature_type)
                    self.controller.execute_sql(sql)
                    for field in self.row:
                        fields += field + ", "
                    fields = fields[:-2]
                    cabecera = False
                    
                else:
                    #if from_date <= self.row[0] <= to_date:
                    for value in self.row:
                        if len(value) != 0:
                            values += str(value) + "', '"
                        else:
                            values = values[:-1]
                            values += "null, '"
                            
                    values = values[:-3]
                    sql = ("INSERT INTO sanejament.temp_om_visit_" + str(feature_type) + " (" + str(fields) + ")"
                           " VALUES (" + str(values) + ")")

                    status = self.controller.execute_sql(sql)
                    if not status:
                        self.controller.log_info(str(sql))
                        return
                    self.dlg_import_visit_csv.progressBar.setValue(cont)

        sql = (" SELECT sanejament.gw_fct_om_visit('"+str(self.dlg_import_visit_csv.visit_cat.currentIndex()+1)+ "', '" + str(feature_type)+"')")
        row = self.controller.get_row(sql, commit=True)

        # if str(row[0]) == '0':
        #     message = "The import has been success"
        #     QMessageBox.information(None, "Info", self.controller.tr(message, context_name='ui_message'))
        # else:
        #     # TODO mostrar tabla de cambios
        #     QMessageBox.critical(None, "Alerta", "Hay cambios en las tablas, revisalas")
        #     sql = ("SELECT * FROM sanejament.temp_om_log")
        #     rows = self.controller.get_rows(sql)
        #     #self.controller.log_info(str(rows[0]))

        if str(row[0]) == '0':
            self.controller.log_info(str("TEST"))
            self.dlg_import_visit_csv.close()
            self.open_custom_table('sanejament.temp_om_visit_' + str(feature_type), 'id', 'codi')


    def open_custom_table(self, table_name,column_id, filter_field):
        """   """

        dlg_custom_table = Dlg_Custom_table()
        utils_giswater.setDialog(dlg_custom_table)
        model = QSqlTableModel()

        custom_table = dlg_custom_table.findChild(QTableView, "custom_table")
        custom_table.setSelectionBehavior(QAbstractItemView.SelectRows)  # Select by rows instead of individual cells

        dlg_custom_table.btn_accept.pressed.connect(dlg_custom_table.close)
        dlg_custom_table.btn_cancel.pressed.connect(dlg_custom_table.close)

        dlg_custom_table.btn_save.pressed.connect(partial(self.save_table, model, custom_table, table_name, column_id))
        dlg_custom_table.btn_delete.clicked.connect(partial(self.multi_rows_delete, custom_table, table_name, column_id))
        dlg_custom_table.txt_name.textChanged.connect(partial(self.filter_by_text, model, custom_table, dlg_custom_table.txt_name, table_name, filter_field))

        self.fill_custom_table(model, custom_table, table_name)
        dlg_custom_table.exec_()


    def filter_by_text(self, model, custom_table, widget_txt, table_name, filter_field):
        """   """
        result_select = utils_giswater.getWidgetText(widget_txt)
        if result_select != 'null':
            expr = filter_field +" LIKE '%" + result_select + "%'"
            # Refresh model with selected filter
            custom_table.model().setFilter(expr)
            custom_table.model().select()
        else:
            self.fill_custom_table(model, custom_table, table_name)


    def fill_custom_table(self, model, custom_table, table_name):
        """ Set a model with selected filter.
        Attach that model to selected table """

        # Set model
        self.controller.log_info(str("11111"))
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        model.setSort(0, 0)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())

        # Attach model to table view
        custom_table.setModel(model)


    def save_table(self, model, custom_table, table_name, column_id):
        """ Save widget (QTableView) into model"""

        if model.submitAll():
            model.database().commit()
        else:
            model.database().rollback()
        self.fill_custom_table(custom_table, table_name, column_id)


    def multi_rows_delete(self, custom_table, table_name, column_id):
        """ Delete selected elements of the table
        :param table_name: table origin
        :param column_id: Refers to the id of the source table
        """

        # Get selected rows
        selected_list = custom_table.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return

        inf_text = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = custom_table.model().record(row).value(str(column_id))
            inf_text += str(id_)+", "
            list_id = list_id+"'"+str(id_)+"', "
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]
        answer = self.controller.ask_question("Are you sure you want to delete these records?", "Delete records", inf_text)

        if answer:
            sql = "DELETE FROM "+table_name
            sql += " WHERE "+column_id+" IN ("+list_id+")"
            self.controller.execute_sql(sql)
            custom_table.model().select()


    def get_default_dates(self):
        """ Load the dates from the DB for the current_user and set vars (self.from_date, self.to_date) """

        sql = ("SELECT from_date, to_date FROM sanejament.selector_date WHERE cur_user='"+self.current_user+"'")
        row = self.controller.get_row(sql)
        if row:
            self.from_date = QDate(row[0])
            self.to_date = QDate(row[1])
        else:
            self.from_date = QDate.currentDate()
            self.to_date = QDate.currentDate().addDays(1)
            
            