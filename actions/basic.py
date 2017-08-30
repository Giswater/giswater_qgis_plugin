"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from datetime import datetime
from PyQt4.QtCore import QSettings, QTime
from PyQt4.QtGui import QDoubleValidator, QIntValidator, QFileDialog, QCheckBox, QDateEdit,  QTableView, QTimeEdit, QSpinBox, QAbstractItemView
from PyQt4.QtSql import QSqlQueryModel

import os
import sys
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater

from ..ui.file_manager import FileManager   # @UnresolvedImport
from ..ui.multirow_selector import Multirow_selector       # @UnresolvedImport
from ..ui.ws_options import WSoptions       # @UnresolvedImport
from ..ui.ws_times import WStimes       # @UnresolvedImport
from ..ui.ud_options import UDoptions       # @UnresolvedImport
from ..ui.ud_times import UDtimes       # @UnresolvedImport
from ..ui.hydrology_selector import HydrologySelector       # @UnresolvedImport

from parent import ParentAction


class Basic(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control Management toolbar actions """
        self.minor_version = "3.0"
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)


    def set_project_type(self, project_type):
        self.project_type = project_type
        
    
    def basic_exploitation_selector(self):
        """ Button 41: Explotation selector """
        
        # TODO: 
        self.controller.log_info("BASIC")
#         self.dlg_multiexp = Multiexpl_selector()
#         utils_giswater.setDialog(self.dlg_multiexp)
# 
#         self.tbl_all_explot=self.dlg_multiexp.findChild(QTableView, "all_explot")
#         self.tbl_selected_explot = self.dlg_multiexp.findChild(QTableView, "selected_explot")
# 
#         self.btn_select=self.dlg_multiexp.findChild(QPushButton, "btn_select")
#         self.btn_unselect = self.dlg_multiexp.findChild(QPushButton, "btn_unselect")
#         self.txt_short_descript = self.dlg_multiexp.findChild(QLineEdit, 'txt_short_descript')
# 
#         sql = "SELECT * FROM " + self.schema_name + ".exploitation WHERE short_descript LIKE '"
#         self.txt_short_descript.textChanged.connect(partial(self.filter_all_explot, sql, self.txt_short_descript))
# 
#         self.btn_select.pressed.connect(self.selection)
#         self.btn_unselect.pressed.connect(self.unselection)
# 
#         self.dlg_multiexp.btn_cancel.pressed.connect(self.dlg_multiexp.close)
# 
#         self.fill_table(self.tbl_all_explot, self.schema_name + ".exploitation")
#         self.tbl_all_explot.hideColumn(2)
#         self.tbl_all_explot.hideColumn(3)
#         self.tbl_all_explot.hideColumn(4)
#         self.tbl_all_explot.setColumnWidth(0,98)
#         self.tbl_all_explot.setColumnWidth(1,99)
# 
#         self.fill_table(self.tbl_selected_explot, self.schema_name + ".expl_selector")
#         self.tbl_selected_explot.hideColumn(1)
#         self.tbl_selected_explot.setColumnWidth(0,197)
# 
#         self.dlg_multiexp.exec_()


    def filter_all_explot(self,sql, widget):

        sql += widget.text()+"%'"
        model = QSqlQueryModel()
        model.setQuery(sql)
        self.tbl_all_explot.setModel(model)
        self.tbl_all_explot.show()


    def selection(self):

        self.tbl_all_explot = self.dlg_multiexp.findChild(QTableView, "all_explot")
        self.tbl_selected_explot = self.dlg_multiexp.findChild(QTableView, "selected_explot")

        selected_list = self.tbl_all_explot.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message' )
            return

        row_index = ""
        expl_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = self.tbl_all_explot.model().record(row).value("expl_id")

            expl_id += str(id_)+", "
            row_index += str(row+1)+", "

        row_index = row_index[:-2]
        expl_id = expl_id[:-2]

        #sql = "DELETE FROM "+self.schema_name+".exploitation"
        #sql+= " WHERE expl_id IN ("+expl_id+")"
        #self.controller.execute_sql(sql)
        #self.tbl_all_explot.model().select()
        cur_user = self.controller.get_project_user()

        for i in range(0, len(expl_id)):
            # Check if expl_id already exists in expl_selector
            sql = "SELECT DISTINCT(expl_id) FROM "+self.schema_name+".expl_selector WHERE expl_id = '"+expl_id[i]+"'"
            row = self.dao.get_row(sql)
            if row:
                self.controller.show_info_box("Expl_id "+expl_id[i]+" is already selected!", "Info")
            else:
                sql = "INSERT INTO "+self.schema_name+".expl_selector (expl_id,cur_user) "
                sql+= " VALUES ('"+expl_id[i]+"', '"+cur_user+"')"
                self.controller.execute_sql(sql)

        self.fill_table(self.tbl_selected_explot, self.schema_name + ".expl_selector")
        self.fill_table(self.tbl_all_explot, self.schema_name + ".exploitation")
        self.iface.mapCanvas().refresh()


    def unselection(self):

        self.tbl_all_explot = self.dlg_multiexp.findChild(QTableView, "all_explot")
        self.tbl_selected_explot = self.dlg_multiexp.findChild(QTableView, "selected_explot")

        selected_list =self.tbl_selected_explot.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message' )
            return

        row_index = ""
        expl_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = self.tbl_selected_explot.model().record(row).value("expl_id")

            expl_id += str(id_)+", "
            row_index += str(row+1)+", "

        row_index = row_index[:-2]
        expl_id = expl_id[:-2]

        table_name_unselect = "expl_selector"
        sql = "DELETE FROM "+self.schema_name+"."+table_name_unselect
        sql+= " WHERE expl_id IN ("+expl_id+")"
        self.controller.execute_sql(sql)
        self.tbl_all_explot.model().select()

        # Refresh
        self.fill_table(self.tbl_selected_explot, self.schema_name + ".expl_selector")
        self.iface.mapCanvas().refresh()
    


