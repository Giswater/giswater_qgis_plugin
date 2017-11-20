"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtCore import QDate
from PyQt4.QtGui import QDateEdit,QPushButton, QFileDialog, QMessageBox, QLineEdit
import os
import sys
import csv
import math
from datetime import datetime
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater

from ..ui.selector_date import SelectorDate         # @UnresolvedImport
from ..ui.ud_om_add_visit_file import AddVisitFile  # @UnresolvedImport
from ..ui.visit_config import VisitConfig
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
        sql = "SELECT * FROM "+self.controller.schema_name+".selector_date WHERE cur_user = '" + self.current_user + "'"
        row = self.controller.get_row(sql)
        if row is None:
            sql = ("INSERT INTO "+self.controller.schema_name+".selector_date (from_date, to_date, context, cur_user)"
                " VALUES('"+from_date+"', '"+to_date+"', 'om_visit', '"+self.current_user+"')")
        else:
            sql = ("UPDATE "+self.controller.schema_name+".selector_date SET(from_date, to_date) = "
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
        sql = "SELECT short_des FROM "+self.controller.schema_name+".om_visit_cat"
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
                    if self.row[2] == 'inici':
                        feature_type = "arc"
                    if self.row[2] == 'sorrer':
                        feature_type = "node"
                    sql = "DELETE FROM "+self.controller.schema_name+".temp_om_visit_" + str(feature_type)
                    self.controller.execute_sql(sql)
                    for field in self.row:
                        fields += field + ", "
                    fields = fields[:-2]
                    cabecera = False
                    columns = self.row
                else:
                    pos=0
                    for value in self.row:
                        # self.controller.log_info(str(pos))
                        # if pos==9:
                        #     data_type_res_nivell = self.controller.check_data_type_column('temp_om_visit_' + str(feature_type), 'res_nivell')
                        #     if data_type_res_nivell is None:
                        #         message = "Column not found"
                        #         self.controller.show_warning(message, parameter='res_nivell')
                        #         return
                        #
                        #     elif data_type_res_nivell == 'integer' or data_type_res_nivell == 'double precision':
                        #     # Comprobar que el campo del CSV es un entero
                        #         if math.isnan(value):
                        #             message = "Value is not a number"
                        #             self.controller.show_warning(message, parameter=value)
                        #             return
                        #
                        # if str(feature_type) == 'node':
                        #     if pos==2:
                        #         data_type_sorrer = self.controller.check_data_type_column('temp_om_visit_' + str(feature_type), 'sorrer')
                        #         if data_type_sorrer is None:
                        #             message = "Column not found"
                        #             self.controller.show_warning(message, parameter='sorrer')
                        #             return
                        #         elif data_type_sorrer == 'integer' or data_type_sorrer == 'double precision':
                        #             self.controller.log_info(str(data_type_sorrer))
                        #             self.controller.log_info(str(value))
                        #             # Comprobar que el campo del CSV es un entero
                        #             if math.isnan(value):
                        #                 self.controller.log_info(str("nnn"))
                        #                 message = "Value is not a number"
                        #                 self.controller.show_warning(message, parameter=value)
                        #                 return
                        #     self.controller.log_info(str(pos))
                        #     if pos == 3:
                        #         self.controller.log_info(str("tttt"))
                        #         data_type_total = self.controller.check_data_type_column('temp_om_visit_' + str(feature_type), 'total')
                        #
                        #         if data_type_total is None:
                        #             message = "Column not found"
                        #             self.controller.show_warning(message, parameter='total')
                        #             return
                        #         elif data_type_total == 'integer' or data_type_total == 'double precision':
                        #             # Comprobar que el campo del CSV es un entero
                        #             self.controller.log_info(str("!!!!!!!!"))
                        #             if math.isnan(value):
                        #                 self.controller.log_info(str("33333"))
                        #                 message = "Value is not a number"
                        #                 self.controller.show_warning(message, parameter=value)
                        #                 return

                        # if str(feature_type) == 'arc':
                        #     data_type_inici = self.controller.check_data_type_column('temp_om_visit_' + str(feature_type), 'inici')
                        #     if data_type_inici is None:
                        #         message = "Column not found"
                        #         self.controller.show_warning(message, parameter='inici')
                        #         return
                        #     elif data_type_inici == 'integer' or data_type_inici == 'double precision':
                        #         # Comprobar que el campo del CSV es un entero
                        #         if math.isnan(value):
                        #             message = "Value is not a number"
                        #             self.controller.show_warning(message, parameter=value)
                        #             return
                        #
                        #     data_type_final = self.controller.check_data_type_column('temp_om_visit_' + str(feature_type), 'final')
                        #     if data_type_final is None:
                        #         message = "Column not found"
                        #         self.controller.show_warning(message, parameter='final')
                        #         return
                        #     elif data_type_final == 'integer' or data_type_final == 'double precision':
                        #         # Comprobar que el campo del CSV es un entero
                        #         if math.isnan(value):
                        #             message = "Value is not a number"
                        #             self.controller.show_warning(message, parameter=value)
                        #             return

                        if len(value) != 0:
                            values += str(value) + "', '"
                        else:
                            values = values[:-1]
                            values += "null, '"
                        # pos=pos+1
                    values = values[:-3]
                    sql = ("INSERT INTO "+self.controller.schema_name+".temp_om_visit_" + str(feature_type) + " (" + str(fields) + ") VALUES (" + str(values) + ")")
                    status = self.controller.execute_sql(sql)
                    if not status:
                        return
                    self.dlg_import_visit_csv.progressBar.setValue(cont)

        sql = (" SELECT "+self.controller.schema_name+".gw_fct_om_visit('"+str(self.dlg_import_visit_csv.visit_cat.currentIndex()+1)+ "', '" + str(feature_type).upper()+"')")
        row = self.controller.get_row(sql, commit=True)

        if str(row[0]) == '0':
            message = "The import has been success"
            message = "El proces d'importacio ha estat satisfactori"
            QMessageBox.information(None, "Info", self.controller.tr(message, context_name='ui_message'))
        else:
            # TODO mostrar tabla de cambios
            QMessageBox.critical(None, "Alerta", "S'han detectat "+ str(row)+" inconsistencies en les dades d'inventari, si us plau dona-li un cop d'ull a les taules 'review'")



    def get_default_dates(self):
        """ Load the dates from the DB for the current_user and set vars (self.from_date, self.to_date) """

        sql = ("SELECT from_date, to_date FROM "+self.controller.schema_name+".selector_date WHERE cur_user='"+self.current_user+"'")
        row = self.controller.get_row(sql)
        if row:
            self.from_date = QDate(row[0])
            self.to_date = QDate(row[1])
        else:
            self.from_date = QDate.currentDate()
            self.to_date = QDate.currentDate().addDays(1)


    def visit_config(self):

        dlg_visti_config = VisitConfig()
        utils_giswater.setDialog(dlg_visti_config)

        dlg_visti_config.btn_accept.pressed.connect(partial(self.update_visit_config,dlg_visti_config ))
        dlg_visti_config.btn_cancel.pressed.connect(dlg_visti_config.close)
        self.fill_visit_config(dlg_visti_config)

        dlg_visti_config.exec_()


    def fill_visit_config(self, dlg_visti_config):
        sql = ("SELECT * FROM "+self.controller.schema_name+".om_visit_review_config")
        row = self.controller.get_row(sql)
        widget_list = dlg_visti_config.findChildren(QLineEdit)
        for widget in widget_list:
            utils_giswater.setText(widget, row[widget.objectName()])

    def update_visit_config(self, dlg_visti_config):
        widget_list = dlg_visti_config.findChildren(QLineEdit)
        sql = ("UPDATE "+self.controller.schema_name+".om_visit_review_config SET ")
        for widget in widget_list:
            sql += (" "+widget.objectName() +"="+utils_giswater.getWidgetText(widget) +",")
        sql = sql[:-1]
        self.controller.execute_sql(sql)
