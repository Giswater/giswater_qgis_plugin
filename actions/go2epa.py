"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from datetime import datetime
from PyQt4.QtCore import QSettings, QTime
from PyQt4.QtGui import QDoubleValidator, QIntValidator, QFileDialog, QCheckBox, QDateEdit,  QTimeEdit, QSpinBox

import os
import sys
from functools import partial

from ui.result_compare_selector import ResultCompareSelector

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


class Go2Epa(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'go2epa' """
        self.minor_version = "3.0"
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)


    def set_project_type(self, project_type):
        self.project_type = project_type


    def go2epa(self):
        """ Button 23: Open form to set INP, RPT and project """

        # Initialize variables
        self.file_inp = None
        self.file_rpt = None
        self.project_name = None

        # Get giswater properties file
        users_home = os.path.expanduser("~")
        filename = "giswater_" + self.minor_version + ".properties"
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
        self.dlg = FileManager()
        utils_giswater.setDialog(self.dlg)
        # self.dlg.setWindowTitle("Options Table")

        # Set widgets
        self.dlg.txt_file_inp.setText(self.file_inp)
        self.dlg.txt_file_rpt.setText(self.file_rpt)
        self.dlg.txt_result_name.setText(self.project_name)

        # Set signals
        self.dlg.btn_file_inp.clicked.connect(self.go2epa_select_file_inp)
        self.dlg.btn_file_rpt.clicked.connect(self.go2epa_select_file_rpt)
        self.dlg.btn_accept.clicked.connect(self.go2epa_accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)
        if self.project_type == 'ws':
            self.dlg.btn_hs_ds.setText("Dscenario Selector")
            self.dlg.chk_export_subcatch.setVisible(False)
            self.dlg.btn_options.clicked.connect(self.ws_options)
            self.dlg.btn_times.clicked.connect(self.ws_times)
            tableleft = "sector"
            tableright = "inp_selector_sector"
            field_id_left = "sector_id"
            field_id_right = "sector_id"
            self.dlg.btn_sector_selection.pressed.connect(partial(self.sector_selection, tableleft, tableright, field_id_left, field_id_right))
            tableleft = "cat_dscenario"
            tableright = "inp_selector_dscenario"
            field_id_left = "dscenario_id"
            field_id_right = "dscenario_id"
            self.dlg.btn_hs_ds.pressed.connect(partial(self.sector_selection, tableleft, tableright, field_id_left, field_id_right))

        if self.project_type == 'ud':
            self.dlg.btn_hs_ds.setText("Hydrology selector")
            self.dlg.btn_hs_ds.clicked.connect(self.ud_hydrology_selector)
            self.dlg.btn_options.clicked.connect(self.ud_options)
            self.dlg.btn_times.clicked.connect(self.ud_times)
            tableleft = "sector"
            tableright = "inp_selector_sector"
            field_id_left = "sector_id"
            field_id_right = "sector_id"
            self.dlg.btn_sector_selection.pressed.connect(partial(self.sector_selection, tableleft, tableright, field_id_left, field_id_right))

        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg, 'file_manager')
        self.dlg.exec_()


    def sector_selection(self, tableleft, tableright, field_id_left, field_id_right):
        """ Load the tables in the selection form """

        dlg_psector_sel = Multirow_selector()
        utils_giswater.setDialog(dlg_psector_sel)
        dlg_psector_sel.btn_ok.pressed.connect(dlg_psector_sel.close)
        dlg_psector_sel.setWindowTitle("Selector")
        self.multi_row_selector(dlg_psector_sel, tableleft, tableright, field_id_left, field_id_right)
        dlg_psector_sel.exec_()


    def ws_options(self):
        """ Open dialog ws_options.ui """
        
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

        self.dlg_wsoptions.chk_enabled.setChecked(True)

        # Set values from widgets of type QComboBox
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_opti_units ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("units", rows, False)

        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_opti_headloss ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("headloss", rows, False)
        sql = "SELECT DISTINCT(pattern_id) FROM "+self.schema_name+".inp_pattern ORDER BY pattern_id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("pattern", rows, False)

        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_opti_unbal ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("unbalanced", rows, False)

        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_opti_hyd ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("hydraulics", rows, False)

        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_opti_qual ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("quality", rows, False)

        sql = "SELECT id FROM "+self.schema_name+".inp_value_opti_valvemode ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("valve_mode", rows, False)

        sql = "SELECT id FROM "+self.schema_name+".anl_mincut_result_cat ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("valve_mode_mincut_result", rows, False)

        sql = "SELECT id FROM "+self.schema_name+".ext_cat_period ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("rtc_period_id", rows, False)

        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_opti_rtc_coef ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("rtc_coefficient", rows, False)

        # TODO
        if self.dlg_wsoptions.valve_mode.currentText() == "MINCUT RESULTS":
            self.dlg_wsoptions.valve_mode_mincut_result.setEnabled(False)

        if self.dlg_wsoptions.hydraulics.currentText() == "":
            self.dlg_wsoptions.hydraulics_fname.setEnabled(False)
        else:
            self.dlg_wsoptions.hydraulics_fname.setEnabled(True)

        # TODO
        if self.dlg_wsoptions.quality.currentText() == "TRACE":
            self.dlg_wsoptions.node_id.setEnabled(False)
        else:
            self.dlg_wsoptions.node_id.setEnabled(True)

        if utils_giswater.isChecked(self.dlg_wsoptions.chk_enabled):
            self.dlg_wsoptions.rtc_period_id.setEnabled(True)
            self.dlg_wsoptions.rtc_coefficient.setEnabled(True)
        # TODO
        self.dlg_wsoptions.unbalanced.currentIndexChanged.connect(partial(self.enable_linetext, "unbalanced", "unbalanced_n", "STOP"))
        self.dlg_wsoptions.hydraulics.currentIndexChanged.connect(partial(self.enable_linetext, "hydraulics", "hydraulics_fname", ""))
        self.dlg_wsoptions.quality.currentIndexChanged.connect(partial(self.enable_linetext, "quality", "node_id", "TRACE"))
        self.dlg_wsoptions.valve_mode.currentIndexChanged.connect(partial(self.enable_linetext, "valve_mode", "valve_mode_mincut_result", "MINCUT RESULTS"))
        self.dlg_wsoptions.chk_enabled.stateChanged.connect(self.enable_per_coef)

        self.dlg_wsoptions.btn_accept.pressed.connect(partial(self.insert_or_update, True, 'inp_options', self.dlg_wsoptions))
        self.dlg_wsoptions.btn_cancel.pressed.connect(self.dlg_wsoptions.close)
        self.go2epa_options_get_data('inp_options')
        self.dlg_wsoptions.exec_()


    def ws_times(self):
        """ Open dialog ws_times.ui"""
        
        dlg_wstimes = WStimes()
        utils_giswater.setDialog(dlg_wstimes)
        dlg_wstimes.duration.setValidator(QIntValidator())
        sql = "SELECT id FROM "+self.schema_name+".inp_value_times ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("statistic", rows, False)
        dlg_wstimes.btn_accept.pressed.connect(partial(self.insert_or_update, True, 'inp_times', dlg_wstimes))
        dlg_wstimes.btn_cancel.pressed.connect(dlg_wstimes.close)
        self.go2epa_options_get_data('inp_times')
        dlg_wstimes.exec_()


    def enable_per_coef(self):
        """ Enable or dissable cbx """
        self.dlg_wsoptions.rtc_period_id.setEnabled(utils_giswater.isChecked("chk_enabled"))
        self.dlg_wsoptions.rtc_coefficient.setEnabled(utils_giswater.isChecked("chk_enabled"))


    def enable_linetext(self, widget1, widget2, text):
        """ Enable or disable txt """
        if utils_giswater.getWidgetText(widget1) == text:
            utils_giswater.setWidgetEnabled(widget2, False)
        else:
            utils_giswater.setWidgetEnabled(widget2, True)


    def ud_options(self):
        """ Dialog ud_options.ui """
        
        # Create dialog
        dlg_udoptions = UDoptions()
        utils_giswater.setDialog(dlg_udoptions)

        dlg_udoptions.min_slope.setValidator(QDoubleValidator())
        dlg_udoptions.lengthening_step.setValidator(QDoubleValidator())
        dlg_udoptions.max_trials.setValidator(QIntValidator())
        dlg_udoptions.sys_flow_tol.setValidator(QIntValidator())
        dlg_udoptions.variable_step.setValidator(QIntValidator())
        dlg_udoptions.min_surfarea.setValidator(QIntValidator())
        dlg_udoptions.head_tolerance.setValidator(QDoubleValidator())
        dlg_udoptions.lat_flow_tol.setValidator(QIntValidator())

        # Set values from widgets of type QComboBox
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_options_fu ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("flow_units", rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_options_fr ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("flow_routing", rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_options_lo ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("link_offsets", rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_options_fme ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("force_main_equation", rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_options_nfl ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("normal_flow_limited", rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_options_id ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("inertial_damping", rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".value_yesno ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("allow_ponding", rows, False)
        utils_giswater.fillComboBox("skip_steady_state", rows, False)
        utils_giswater.fillComboBox("ignore_rainfall", rows, False)
        utils_giswater.fillComboBox("ignore_snowmelt", rows, False)
        utils_giswater.fillComboBox("ignore_groundwater", rows, False)
        utils_giswater.fillComboBox("ignore_routing", rows, False)
        utils_giswater.fillComboBox("ignore_quality", rows, False)
        update = True
        dlg_udoptions.btn_accept.pressed.connect(partial(self.insert_or_update, update, 'inp_options', dlg_udoptions))
        dlg_udoptions.btn_cancel.pressed.connect(dlg_udoptions.close)
        self.go2epa_options_get_data('inp_options')
        dlg_udoptions.exec_()


    def ud_times(self):
        """ Dialog ud_times.ui """
        
        dlg_udtimes = UDtimes()
        utils_giswater.setDialog(dlg_udtimes)
        dlg_udtimes.dry_days.setValidator(QIntValidator())
        update = True
        dlg_udtimes.btn_accept.pressed.connect(partial(self.insert_or_update, update, 'inp_options', dlg_udtimes))
        dlg_udtimes.btn_cancel.pressed.connect(dlg_udtimes.close)
        self.go2epa_options_get_data('inp_options')
        dlg_udtimes.exec_()


    def ud_hydrology_selector(self):
        """ Dialog hydrology_selector.ui """
        
        self.dlg_hydrology_selector = HydrologySelector()
        utils_giswater.setDialog(self.dlg_hydrology_selector)

        self.dlg_hydrology_selector.btn_accept.pressed.connect(self.dlg_hydrology_selector.close)
        self.dlg_hydrology_selector.hydrology.currentIndexChanged.connect(self.update_labels)
        self.dlg_hydrology_selector.txt_name.textChanged.connect(partial(self.filter_cbx_by_text, "cat_hydrology", self.dlg_hydrology_selector.txt_name, self.dlg_hydrology_selector.hydrology))

        sql = "SELECT DISTINCT(name) FROM " + self.schema_name + ".cat_hydrology ORDER BY name"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("hydrology", rows, False)
        self.update_labels()
        self.dlg_hydrology_selector.exec_()


    def update_labels(self):
        """ Show text in labels from SELECT """
        sql = "SELECT infiltration, text FROM "+self.schema_name + ".cat_hydrology"
        sql += " WHERE name = '"+str(self.dlg_hydrology_selector.hydrology.currentText())+"'"
        row = self.dao.get_row(sql)
        if row is not None:
            utils_giswater.setText("infiltration", row[0])
            utils_giswater.setText("descript", row[1])


    def filter_cbx_by_text(self, tablename, widgettxt, widgetcbx):
        sql = "SELECT DISTINCT(name) FROM " + self.schema_name + "." + str(tablename)
        sql += " WHERE name LIKE '%" + str(widgettxt.text()) + "%'"
        sql += " ORDER BY name "
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox(widgetcbx, rows, False)
        self.update_labels()


    def insert_or_update(self, update, tablename, dialog):
        """ INSERT or UPDATE tables according :param update"""
        
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
                            value = date.dateTime().toString('yyyy-MM-dd')
                        elif widget_type is QTimeEdit:
                            aux = 0
                            widget_day = str(column_name) + "_day"
                            day = utils_giswater.getText(widget_day)
                            if day != "null":
                                aux = int(day) * 24
                            time = dialog.findChild(QTimeEdit, str(column_name))
                            timeparts = time.dateTime().toString('HH:mm:ss').split(':')
                            h = int(timeparts[0]) + int(aux)
                            aux = str(h) + ":" + str(timeparts[1]) + ":00"
                            value = aux
                        elif widget_type is QSpinBox:
                            x = dialog.findChild(QSpinBox, str(column_name))
                            value = x.value()
                        else:
                            value = utils_giswater.getWidgetText(column_name)
                        if value == 'null':
                            sql += column_name + " = null, "
                        elif value is None:
                            pass
                        else:
                            if type(value) is not bool and widget_type is not QSpinBox:
                                value = value.replace(",", ".")
                            sql += column_name + " = '" + str(value) + "', "
                sql = sql[:len(sql) - 2]
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
                                values += date.dateTime().toString('yyyy-MM-dd') + ", "
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


    def go2epa_select_file_inp(self):
        """ Select INP file """
        
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


    def go2epa_select_file_rpt(self):
        """ Select RPT file """
        
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


    def go2epa_accept(self):
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
        self.close_dialog()


    def go2epa_express(self):
        """ Button 24: Open giswater in silent mode
        Executes all options of File Manager: Export INP, Execute EPA software and Import results
        """
        self.execute_giswater("go2epa_express", 24)


    def go2epa_result_selector(self):
        """ Button 25. Result selector """

        # Create the dialog and signals
        self.dlg = ResultCompareSelector()
        utils_giswater.setDialog(self.dlg)
        self.dlg.btn_accept.pressed.connect(self.result_selector_accept)
        self.dlg.btn_cancel.pressed.connect(self.close_dialog)

        # Set values from widgets of type QComboBox
        sql = "SELECT DISTINCT(result_id) FROM " + self.schema_name + ".rpt_cat_result ORDER BY result_id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("rpt_selector_result_id", rows)
        utils_giswater.fillComboBox("rpt_selector_compare_id", rows)

        # Get current data from tables 'rpt_selector_result' and 'rpt_selector_compare'
        sql = "SELECT result_id FROM " + self.schema_name + ".rpt_selector_result"
        row = self.dao.get_row(sql)
        if row:
            utils_giswater.setWidgetText("rpt_selector_result_id", row["result_id"])
        sql = "SELECT result_id FROM " + self.schema_name + ".rpt_selector_compare"
        row = self.dao.get_row(sql)
        if row:
            utils_giswater.setWidgetText("rpt_selector_compare_id", row["result_id"])

        # Open the dialog
        self.dlg.exec_()


    def go2epa_giswater_jar(self):
        """ Button 36: Open giswater.jar with selected .gsw file """

        if 'nt' in sys.builtin_module_names:
            self.execute_giswater("go2epa_giswater_jar", 36)
        else:
            self.controller.show_info("Function not supported in this Operating System")


    def result_selector_accept(self):
        """ Update current values to the table """

        # Get new values from widgets of type QComboBox
        rpt_selector_result_id = utils_giswater.getWidgetText("rpt_selector_result_id")
        rpt_selector_compare_id = utils_giswater.getWidgetText("rpt_selector_compare_id")

        # Set project user
        user = self.controller.get_project_user()

        # Delete previous values
        sql = "DELETE FROM " + self.schema_name + ".rpt_selector_result"
        self.dao.execute_sql(sql)
        sql = "DELETE FROM " + self.schema_name + ".rpt_selector_compare"
        self.dao.execute_sql(sql)

        # Set new values to tables 'rpt_selector_result' and 'rpt_selector_compare'
        sql = "INSERT INTO " + self.schema_name + ".rpt_selector_result (result_id, cur_user)"
        sql += " VALUES ('" + rpt_selector_result_id + "', '" + user + "')"
        self.dao.execute_sql(sql)
        sql = "INSERT INTO " + self.schema_name + ".rpt_selector_compare (result_id, cur_user)"
        sql += " VALUES ('" + rpt_selector_compare_id + "', '" + user + "')"
        self.dao.execute_sql(sql)

        # Show message to user
        message = "Values has been updated"
        self.controller.show_info(message)
        self.close_dialog(self.dlg)


    def go2epa_options_get_data(self, tablename):
        """ Get data from selected table """
        
        sql = "SELECT * FROM " + self.schema_name + "." + tablename
        row = self.dao.get_row(sql)
        if not row:
            self.controller.show_warning("Any data found in table " + tablename)
            return None
        
        # Iterate over all columns and populate its corresponding widget
        columns = []
        for i in range(0, len(row)):
            column_name = self.dao.get_column_name(i)
            widget_type = utils_giswater.getWidgetType(column_name)

            if widget_type is QCheckBox:
                utils_giswater.setChecked(column_name, row[column_name])
            elif widget_type is QDateEdit:
                utils_giswater.setCalendarDate(column_name, datetime.strptime(row[column_name], '%Y-%m-%d'))
            elif widget_type is QTimeEdit:
                timeparts = str(row[column_name]).split(':')
                if len(timeparts) < 3:
                    timeparts.append("0")
                days = int(timeparts[0]) / 24
                hours = int(timeparts[0]) % 24
                minuts = int(timeparts[1])
                seconds = int(timeparts[2])
                time = QTime(hours, minuts, seconds)
                utils_giswater.setTimeEdit(column_name, time)
                utils_giswater.setText(column_name + "_day", days)
            else:
                utils_giswater.setWidgetText(column_name, row[column_name])
                
            columns.append(column_name)
            
        return columns
