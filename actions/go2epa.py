'''
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
'''

# -*- coding: utf-8 -*-
from PyQt4.QtCore import Qt, QSettings
from PyQt4.QtGui import QDoubleValidator
from PyQt4.QtGui import QFileDialog, QMessageBox, QCheckBox, QLineEdit, QTableView, QMenu, QPushButton, QComboBox
from PyQt4.QtGui import QTextEdit, QDateEdit, QTimeEdit, QAbstractItemView
from PyQt4.QtSql import QSqlTableModel, QSqlQueryModel
from PyQt4.Qt import QDate, QTime
from qgis.core import QgsMapLayerRegistry

from datetime import datetime, date
import os
import sys
import webbrowser
from functools import partial

from ..ui.ud_options import UDoptions
from ..ui.file_manager import FileManager  # @UnresolvedImport
from ..ui.ws_options import WSoptions

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)


from parent import ParentAction
import utils_giswater


class Go2Epa(ParentAction):
    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control Management toolbar actions """

        # Call ParentAction constructor      
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)

    def close_dialog(self, dlg=None):
        """ Close dialog """

        dlg.close()
        if dlg is None or type(dlg) is bool:
            dlg = self.dlg
        try:
            dlg.close()
        except AttributeError:
            pass

    def set_project_type(self, project_type):
        self.project_type = project_type

    def mg_go2epa(self):
        """ Button 23. Open form to set INP, RPT and project """

        # Initialize variables
        self.file_inp = None
        self.file_rpt = None
        self.project_name = None

        # Uncheck all actions (buttons) except this one
        self.controller.check_actions(False)
        self.controller.check_action(True, 23)

        # Get giswater properties file
        users_home = os.path.expanduser("~")
        filename = "giswater_2.0.properties"
        java_properties_path = users_home + os.sep + "giswater" + os.sep + "config" + os.sep + filename
        if not os.path.exists(java_properties_path):
            msg = "Giswater properties file not found: " + str(java_properties_path)
            self.controller.show_warning(msg)
            return False

        # Get last GSW file from giswater properties file
        java_settings = QSettings(java_properties_path, QSettings.IniFormat)
        java_settings.setIniCodec(sys.getfilesystemencoding())
        file_gsw = utils_giswater.get_settings_value(java_settings, 'FILE_GSW')

        # Check if that file exists
        if not os.path.exists(file_gsw):
            msg = "Last GSW file not found: " + str(file_gsw)
            self.controller.show_warning(msg)
            return False

        # Get INP, RPT file path and project name from GSW file
        self.gsw_settings = QSettings(file_gsw, QSettings.IniFormat)
        self.file_inp = utils_giswater.get_settings_value(self.gsw_settings, 'FILE_INP')
        self.file_rpt = utils_giswater.get_settings_value(self.gsw_settings, 'FILE_RPT')
        self.project_name = self.gsw_settings.value('PROJECT_NAME')

        # Create dialog
        self.dlg_go2epa = FileManager()
        utils_giswater.setDialog(self.dlg_go2epa)

        # Set widgets
        self.dlg_go2epa.txt_file_inp.setText(self.file_inp)
        self.dlg_go2epa.txt_file_rpt.setText(self.file_rpt)
        self.dlg_go2epa.txt_result_name.setText(self.project_name)

        # Set signals
        self.dlg_go2epa.btn_file_inp.clicked.connect(self.mg_go2epa_select_file_inp)
        self.dlg_go2epa.btn_file_rpt.clicked.connect(self.mg_go2epa_select_file_rpt)
        self.dlg_go2epa.btn_accept.clicked.connect(self.mg_go2epa_accept)
        self.dlg_go2epa.btn_cancel.pressed.connect(self.dlg_go2epa.close)

        if self.project_type == 'ws':
            self.dlg_go2epa.btn_opt_hyd.setText("Options")
            self.dlg_go2epa.btn_time_opt.setText("Times")
            self.dlg_go2epa.btn_rep_time.setText("Report")

            self.dlg_go2epa.btn_opt_hyd.clicked.connect(self.ws_options)
            # self.test("ws")
        if self.project_type == 'ud':
            self.dlg_go2epa.btn_opt_hyd.setText("Hydrology selector")
            self.dlg_go2epa.btn_time_opt.setText("Options")
            self.dlg_go2epa.btn_rep_time.setText("Times")

            self.dlg_go2epa.btn_opt_hyd.clicked.connect(self.ud_options)

            # self.test("ud")

        # self.dlg.btn_sector_selection.clicked.connect()
        # self.dlg.btn_option.clicked.connect()




        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg_go2epa, 'file_manager')
        self.dlg_go2epa.exec_()

    def ws_options(self):
        # Create dialog
        self.dlg_wsoptions = WSoptions()
        utils_giswater.setDialog(self.dlg_wsoptions)
        # Allow QTextView only Double text
        self.dlg_wsoptions.viscosity.setValidator(QDoubleValidator())
        self.dlg_wsoptions.trials.setValidator(QDoubleValidator())
        self.dlg_wsoptions.accuracy.setValidator(QDoubleValidator())
        self.dlg_wsoptions.emitter_exponent.setValidator(QDoubleValidator())
        self.dlg_wsoptions.checkfreq.setValidator(QDoubleValidator())
        self.dlg_wsoptions.maxcheck.setValidator(QDoubleValidator())
        self.dlg_wsoptions.damplimit.setValidator(QDoubleValidator())
        self.dlg_wsoptions.node_id.setValidator(QDoubleValidator())
        self.dlg_wsoptions.unbalanced_n.setValidator(QDoubleValidator())
        self.dlg_wsoptions.specific_gravity.setValidator(QDoubleValidator())
        self.dlg_wsoptions.diffusivity.setValidator(QDoubleValidator())
        self.dlg_wsoptions.tolerance.setValidator(QDoubleValidator())
        self.dlg_wsoptions.demand_multiplier.setValidator(QDoubleValidator())

        # Set values from widgets of type QComboBox
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_opti_units ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("units", rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_opti_headloss ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("headloss", rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_opti_hyd ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("hydraulics", rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_opti_qual ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("quality", rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_opti_unbal ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("unbalanced", rows, False)
        sql = "SELECT DISTINCT(pattern_id) FROM "+self.schema_name+".inp_pattern ORDER BY pattern_id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("pattern", rows, False)
        update = True
        self.dlg_wsoptions.btn_accept.pressed.connect(partial(self.insert_or_update, update, 'inp_options', self.dlg_wsoptions))
        self.dlg_wsoptions.btn_cancel.pressed.connect(self.dlg_wsoptions.close)
        self.dlg_wsoptions.exec_()


    def ud_options(self):
        # Create dialog
        self.dlg_udoptions = UDoptions()
        utils_giswater.setDialog(self.dlg_udoptions)
        '''
        self.dlg_udoptions.viscosity.setValidator(QDoubleValidator())
        self.dlg_udoptions.trials.setValidator(QDoubleValidator())
        self.dlg_udoptions.accuracy.setValidator(QDoubleValidator())
        self.dlg_udoptions.emitter_exponent.setValidator(QDoubleValidator())
        self.dlg_udoptions.checkfreq.setValidator(QDoubleValidator())
        self.dlg_udoptions.maxcheck.setValidator(QDoubleValidator())
        self.dlg_udoptions.damplimit.setValidator(QDoubleValidator())
        self.dlg_udoptions.node_id.setValidator(QDoubleValidator())
        self.dlg_udoptions.unbalanced_n.setValidator(QDoubleValidator())
        self.dlg_udoptions.specific_gravity.setValidator(QDoubleValidator())
        self.dlg_udoptions.diffusivity.setValidator(QDoubleValidator())
        self.dlg_udoptions.tolerance.setValidator(QDoubleValidator())
        self.dlg_udoptions.demand_multiplier.setValidator(QDoubleValidator())
        '''



        #Set values from widgets of type QComboBox
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_opti_units ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("units", rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_opti_headloss ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("headloss", rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_opti_hyd ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("hydraulics", rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_opti_qual ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("quality", rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_opti_unbal ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("unbalanced", rows, False)
        sql = "SELECT DISTINCT(pattern_id) FROM "+self.schema_name+".inp_pattern ORDER BY pattern_id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("pattern", rows, False)
        update = True
        self.dlg_wsoptions.btn_accept.pressed.connect(partial(self.insert_or_update, update, 'inp_options', self.dlg_wsoptions))

        self.dlg_udoptions.btn_cancel.pressed.connect(self.dlg_udoptions.close)
        self.dlg_udoptions.exec_()
    def insert_or_update(self, update, tablename, dialog):
        self.test(("qwe"))

        sql = "SELECT *"
        sql += " FROM " + self.schema_name + "." + tablename
        row = self.dao.get_row(sql)

        columns = []
        for i in range(0, len(row)):
            column_name = self.dao.get_column_name(i)
            columns.append(column_name)

        if update:
            if columns is not None:
                sql = "UPDATE " + self.schema_name + "." + tablename + " SET "
                for column_name in columns:
                    if column_name != 'id':
                        widget_type = utils_giswater.getWidgetType(column_name)
                        if widget_type is QCheckBox:
                            value = utils_giswater.isChecked(column_name)
                        elif widget_type is QDateEdit:
                            date = dialog.findChild(QDateEdit, str(column_name))
                            value = date.dateTime().toString('yyyy-MM-dd HH:mm:ss')
                        else:
                            value = utils_giswater.getWidgetText(column_name)
                        if value is None or value == 'null':
                            sql += column_name + " = null, "
                        else:
                            if type(value) is not bool:
                                value = value.replace(",", ".")
                            sql += column_name + " = '" + str(value) + "', "

                sql = sql[:len(sql) - 2]
                #sql += " WHERE psector_id = '" + self.psector_id.text() + "'"

        else:
            values = "VALUES("
            if columns is not None:
                sql = "INSERT INTO " + self.schema_name + "." + tablename + " ("
                for column_name in columns:
                    if column_name != 'id':
                        widget_type = utils_giswater.getWidgetType(column_name)
                        if widget_type is not None:
                            if widget_type is QCheckBox:
                                values += utils_giswater.isChecked(column_name) + ", "
                            elif widget_type is QDateEdit:
                                date = dialog.findChild(QDateEdit, str(column_name))
                                values += date.dateTime().toString('yyyy-MM-dd HH:mm:ss') + ", "
                            else:
                                value = utils_giswater.getWidgetText(column_name)
                            if value is None or value == 'null':
                                sql += column_name + ", "
                                values += "null, "
                            else:
                                values += "'" + value + "',"
                                sql += column_name + ", "
                sql = sql[:len(sql) - 2] + ") "
                values = values[:len(values) - 2] + ")"
                sql += values

        self.controller.execute_sql(sql)
        dialog.close()
    def mg_go2epa_select_file_inp(self):

        # Set default value if necessary
        if self.file_inp is None or self.file_inp == '':
            self.file_inp = self.plugin_dir

        # Get directory of that file
        folder_path = os.path.dirname(self.file_inp)
        if not os.path.exists(folder_path):
            folder_path = os.path.dirname(__file__)
        os.chdir(folder_path)
        msg = self.controller.tr("Select INP file")
        self.file_inp = QFileDialog.getSaveFileName(None, msg, "", '*.inp')
        self.dlg.txt_file_inp.setText(self.file_inp)

    def mg_go2epa_select_file_rpt(self):

        # Set default value if necessary
        if self.file_rpt is None or self.file_rpt == '':
            self.file_rpt = self.plugin_dir

        # Get directory of that file
        folder_path = os.path.dirname(self.file_rpt)
        if not os.path.exists(folder_path):
            folder_path = os.path.dirname(__file__)
        os.chdir(folder_path)
        msg = self.controller.tr("Select RPT file")
        self.file_rpt = QFileDialog.getSaveFileName(None, msg, "", '*.rpt')
        self.dlg.txt_file_rpt.setText(self.file_rpt)

    def mg_go2epa_accept(self):
        """ Save INP, RPT and result name into GSW file """

        # Get widgets values
        self.file_inp = utils_giswater.getWidgetText('txt_file_inp')
        self.file_rpt = utils_giswater.getWidgetText('txt_file_rpt')
        self.project_name = utils_giswater.getWidgetText('txt_result_name')

        # Save INP, RPT and result name into GSW file
        self.gsw_settings.setValue('FILE_INP', self.file_inp)
        self.gsw_settings.setValue('FILE_RPT', self.file_rpt)
        self.gsw_settings.setValue('PROJECT_NAME', self.project_name)

        # Close form
        self.close_dialog(self.dlg)

    def mg_go2epa_express(self):
        """ Button 24. Open giswater in silent mode
        Executes all options of File Manager: 
        Export INP, Execute EPA software and Import results
        """
        self.execute_giswater("mg_go2epa_express", 24)

    def fill_table_by_query(self, qtable, query):
        """
        :param table: QTableView to show
        :param query: query to set model
        """
        model = QSqlQueryModel()
        model.setQuery(query)
        qtable.setModel(model)
        qtable.show()



