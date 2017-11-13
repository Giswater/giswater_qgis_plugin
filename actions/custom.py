"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
import os
import sys
from datetime import datetime, timedelta
from functools import partial

from PyQt4.QtGui import QDateEdit
from PyQt4.QtGui import QPushButton

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
        """ TODO: Button 91. Selector date """
        
        self.dlg_selector_date = SelectorDate()
        utils_giswater.setDialog(self.dlg_selector_date)

        self.date_from = self.dlg_selector_date.findChild(QDateEdit, "date_from")
        self.date_to = self.dlg_selector_date.findChild(QDateEdit, "date_to")

        self.dlg_selector_date.findChild(QPushButton, "btn_accept").clicked.connect(self.update_dates_into_db)

        self.date_from.dateChanged.connect(partial(self.update_date_to))

        self.dlg_selector_date.exec_()

    def update_date_to(self):
        from_date=self.date_from.date().toString('yyyy-MM-dd')
        to_date = self.date_to.date().toString('yyyy-MM-dd')
        if from_date > to_date:
            to_date = self.date_from.date().addDays(1).toString('yyyy-MM-dd')
            utils_giswater.setCalendarDate(self.date_to, datetime.strptime(to_date, '%Y-%m-%d'))


    def update_dates_into_db(self):
        """ Insert or update dates into data base """
        from_date = self.date_from.date().toString('yyyy-MM-dd')
        to_date = self.date_to.date().toString('yyyy-MM-dd')

        sql = "SELECT * FROM sanejament.selector_date WHERE cur_user='"+self.current_user+"'"
        row=self.controller.get_row(sql)
        if row is None:
            self.controller.log_info(str("DO INSERT"))
            sql = "INSERT INTO sanejament.selector_date (from_date, to_date, context, cur_user) "
            sql += " VALUES('"+from_date+"', '"+to_date+"', 'om_visit', '"+self.current_user+"')"

        else:
            self.controller.log_info(str("DO UPDATE"))
            sql = "UPDATE sanejament.selector_date SET(from_date, to_date) = "
            sql += "('"+from_date+"', '"+to_date+"') WHERE cur_user='"+self.current_user+"'"

        self.dao.execute_sql(sql)

        self.dlg_selector_date.close()


    def custom_import_visit_csv(self):
        """ TODO: Button 92. Import visit from CSV file """

        self.dlg_import_visit_csv = AddVisitFile()
        utils_giswater.setDialog(self.dlg_import_visit_csv)
        self.dlg_import_visit_csv.findChild(QPushButton, "btn_accept").clicked.connect(self.import_visit_csv)
        self.dlg_import_visit_csv.findChild(QPushButton, "btn_cancel").clicked.connect(self.dlg_import_visit_csv.close)
        self.dlg_import_visit_csv.findChild(QPushButton, "btn_file_inp").clicked.connect(self.dlg_import_visit_csv.close)

        self.dlg_import_visit_csv.exec_()

    def import_visit_csv(self):
        self.controller.log_info("import_visit_csv")


        
        