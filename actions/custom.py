"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtCore import QDate
from PyQt4.QtGui import QDateEdit,QPushButton, QFileDialog
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
from parent import ParentAction


class Custom(ParentAction):
   
    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control Management toolbar actions """  
                  
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

        self.fill_combos()
        self.get_default_dates()
        
        # TODO: Get csv file from previous execution
        utils_giswater.setWidgetText("txt_file_csv", "/home/david/ownCloud/Shared/Giswater/trams.csv")        

        btn_file_csv = self.dlg_import_visit_csv.findChild(QPushButton, "btn_file_csv")
        btn_file_csv.clicked.connect(partial(self.get_file_dialog, "txt_file_csv"))

        self.dlg_import_visit_csv.exec_()


    def fill_combos(self):
        """ Fill combos """
        sql = "SELECT short_des FROM sanejament.om_visit_cat"
        rows = self.controller.get_rows(sql)
        if rows:
            utils_giswater.fillComboBox("visit_cat", rows, False)


    def get_file_dialog(self, widget):
        """ Get file dialog """

        # Check if selected file exists. Set default value if necessary
        file_path = utils_giswater.getWidgetText(widget)
        if file_path is None or file_path == 'null' or not os.path.exists(str(file_path)):
            folder_path = self.plugin_dir
        else:
            folder_path = os.path.dirname(file_path)

        # Open dialog to select file
        os.chdir(folder_path)
        file_dialog = QFileDialog()
        file_dialog.setFileMode(QFileDialog.ExistingFiles)

        #TODO mostrar solo los csv
        #file_dialog.setNameFilters(["Text files (*.txt)", "Images (*.png *.jpg)"])
        #file_dialog.selectNameFilter("Images (*.png *.jpg)")
        #file_dialog.setNameFilter("All C++ files (*.cpp *.cc *.C *.cxx *.c++)");
        #file_dialog.setNameFilter("*.cpp *.cc *.C *.cxx *.c++");
        msg = "Select file"
        folder_path = file_dialog.getOpenFileName(parent=None, caption=self.controller.tr(msg))
        if folder_path:
            utils_giswater.setText(widget, str(folder_path))


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

        cabecera = True
        fields = ""
        feature_type = ""
        cont = 0
        from_date = self.from_date.toString('dd/MM/yyyy')
        to_date = self.to_date.toString('dd/MM/yyyy')

        self.dlg_import_visit_csv.progressBar.setVisible(True)
        self.dlg_import_visit_csv.progressBar.setValue(cont)

        #danger = "QProgressBar::chunk {background: QLinearGradient( x1: 0, y1: 0, x2: 1, y2: 0,stop: 0 #006eff,stop: 0.4999 #FF0020,stop: 0.5 #FF0019,stop: 1 #FF0000 );border-bottom-right-radius: 5px;border-bottom-left-radius: 5px;border: .px solid black;}";
        #self.dlg_import_visit_csv.progressBar.setStyleSheet(danger)
        with open(path, 'rb') as csvfile:
            row_count = sum(1 for rows in csvfile)  # counts rows in csvfile, using var "row_count" to do progresbar
            self.dlg_import_visit_csv.progressBar.setMaximum(row_count -20)  # -20 for see 100% complete progress
            csvfile.seek(0)  # Position the cursor at position 0 of the file
            self.reader = csv.reader(csvfile, delimiter=',')

            for self.row in self.reader:
                
                values = "'"            
                cont += 1
#                 if cont > 5:
#                     self.controller.log_info("exit")                        
#                     return
                
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
                            self.controller.log_info(str("value: " + str(value)))
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
                    

        # sql = (" SELECT sanejament.gw_fct_om_visit('"+str(self.dlg_import_visit_csv.visit_cat.currentIndex()+1)+ "', '" + str(feature_type)+"')")
        # self.controller.log_info(str("TEST2"))
        # self.controller.log_info(str(sql))
        # self.controller.log_info(str("TEST3"))
        # row=self.controller.get_row(sql, commit=True)
        # self.controller.log_info(str("TEST4"))
        # self.controller.log_info(str(row))


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
            
            