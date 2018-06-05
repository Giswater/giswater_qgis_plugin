"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtCore import QTime, QDate, Qt
from PyQt4.QtGui import QAbstractItemView, QWidget, QCheckBox, QDateEdit, QTimeEdit, QSpinBox
from PyQt4.QtGui import QDoubleValidator, QIntValidator, QFileDialog


import os
import csv
from functools import partial

import utils_giswater
from ui_manager import FileManager
from ui_manager import Multirow_selector
from ui_manager import WSoptions
from ui_manager import WStimes
from ui_manager import UDoptions
from ui_manager import UDtimes
from ui_manager import HydrologySelector
from ui_manager import EpaResultCompareSelector
from ui_manager import EpaResultManager
from parent import ParentAction


class Go2Epa(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'go2epa' """
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)


    def set_project_type(self, project_type):
        self.project_type = project_type


    def go2epa(self):
        """ Button 23: Open form to set INP, RPT and project """

        if not self.get_last_gsw_file():
            return

        # Create dialog
        self.dlg_go2epa = FileManager()
        # utils_giswater.setDialog(self.dlg)
        self.load_settings(self.dlg_go2epa)
        # self.dlg.setWindowTitle("Options Table")

        # Set widgets
        self.dlg_go2epa.txt_file_inp.setText(self.file_inp)
        self.dlg_go2epa.txt_file_rpt.setText(self.file_rpt)
        self.dlg_go2epa.txt_result_name.setText(self.project_name)

        # Hide checkboxes
        self.dlg_go2epa.chk_export.setVisible(False)
        self.dlg_go2epa.chk_export_subcatch.setVisible(False)
        self.dlg_go2epa.chk_exec.setVisible(False)
        self.dlg_go2epa.chk_import.setVisible(False)

        # Set signals
        self.dlg_go2epa.btn_file_inp.clicked.connect(self.go2epa_select_file_inp)
        self.dlg_go2epa.btn_file_rpt.clicked.connect(self.go2epa_select_file_rpt)
        self.dlg_go2epa.btn_accept.clicked.connect(self.go2epa_accept)
        self.dlg_go2epa.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_go2epa))
        self.dlg_go2epa.rejected.connect(partial(self.close_dialog, self.dlg_go2epa))
        if self.project_type == 'ws':
            self.dlg_go2epa.btn_hs_ds.setText("Dscenario Selector")
            self.dlg_go2epa.btn_options.clicked.connect(self.ws_options)
            self.dlg_go2epa.btn_times.clicked.connect(self.ws_times)
            tableleft = "sector"
            tableright = "inp_selector_sector"
            field_id_left = "sector_id"
            field_id_right = "sector_id"
            self.dlg_go2epa.btn_sector_selection.clicked.connect(partial(self.sector_selection, tableleft, tableright, field_id_left, field_id_right))
            tableleft = "cat_dscenario"
            tableright = "inp_selector_dscenario"
            field_id_left = "dscenario_id"
            field_id_right = "dscenario_id"
            self.dlg_go2epa.btn_hs_ds.clicked.connect(partial(self.sector_selection, tableleft, tableright, field_id_left, field_id_right))

        if self.project_type == 'ud':
            self.dlg_go2epa.btn_hs_ds.setText("Hydrology selector")
            self.dlg_go2epa.btn_hs_ds.clicked.connect(self.ud_hydrology_selector)
            self.dlg_go2epa.btn_options.clicked.connect(self.ud_options)
            self.dlg_go2epa.btn_times.clicked.connect(self.ud_times)
            tableleft = "sector"
            tableright = "inp_selector_sector"
            field_id_left = "sector_id"
            field_id_right = "sector_id"
            self.dlg_go2epa.btn_sector_selection.clicked.connect(
                partial(self.sector_selection, tableleft, tableright, field_id_left, field_id_right))

        # Open dialog
        self.open_dialog(self.dlg_go2epa, dlg_name='file_manager', maximize_button=False)

    
    def get_last_gsw_file(self, show_warning=True):
        """ Get last GSW file used by Giswater """
        
        # Initialize variables
        self.file_inp = None
        self.file_rpt = None
        self.project_name = None

        # Get last GSW file from giswater properties file
        self.set_java_settings(show_warning)

        # Check if that file exists
        if not os.path.exists(self.file_gsw):
            message = "GSW file not found"
            if show_warning:            
                self.controller.show_warning(message, parameter=str(self.file_gsw))
            return False
        
        # Get INP, RPT file path and project name from GSW file
        self.set_gsw_settings()
        self.file_inp = utils_giswater.get_settings_value(self.gsw_settings, 'FILE_INP')
        self.file_rpt = utils_giswater.get_settings_value(self.gsw_settings, 'FILE_RPT')
        self.project_name = self.gsw_settings.value('PROJECT_NAME')        
        
        return True
            

    def sector_selection(self, tableleft, tableright, field_id_left, field_id_right):
        """ Load the tables in the selection form """

        dlg_psector_sel = Multirow_selector()
        # utils_giswater.setDialog(dlg_psector_sel)
        self.load_settings(dlg_psector_sel)
        dlg_psector_sel.btn_ok.clicked.connect(dlg_psector_sel.close)
        dlg_psector_sel.setWindowTitle("Selector")
        if tableleft == 'sector':
            utils_giswater.setWidgetText(dlg_psector_sel, dlg_psector_sel.lbl_filter, self.controller.tr('Filter by: Sector name', context_name='labels'))
            utils_giswater.setWidgetText(dlg_psector_sel, dlg_psector_sel.lbl_unselected, self.controller.tr('Unselected sectors', context_name='labels'))
            utils_giswater.setWidgetText(dlg_psector_sel, dlg_psector_sel.lbl_selected, self.controller.tr('Selected sectors', context_name='labels'))
        if tableleft == 'cat_dscenario':
            utils_giswater.setWidgetText(dlg_psector_sel, dlg_psector_sel.lbl_filter, self.controller.tr('Filter by: Dscenario name', context_name='labels'))
            utils_giswater.setWidgetText(dlg_psector_sel, dlg_psector_sel.lbl_unselected, self.controller.tr('Unselected dscenarios', context_name='labels'))
            utils_giswater.setWidgetText(dlg_psector_sel, dlg_psector_sel.lbl_selected, self.controller.tr('Selected dscenarios', context_name='labels'))
        self.multi_row_selector(dlg_psector_sel, tableleft, tableright, field_id_left, field_id_right)
        dlg_psector_sel.setWindowFlags(Qt.WindowStaysOnTopHint)
        dlg_psector_sel.exec_()


    def ws_options(self):
        """ Open dialog ws_options.ui """
        
        # Create dialog
        self.dlg_wsoptions = WSoptions()
        # utils_giswater.setDialog(self.dlg_wsoptions)
        self.load_settings(self.dlg_wsoptions)

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
        sql = "SELECT id FROM "+self.schema_name+".inp_value_opti_units ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_wsoptions, self.dlg_wsoptions.units, rows, False)

        sql = "SELECT id FROM "+self.schema_name+".inp_value_opti_headloss ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_wsoptions, self.dlg_wsoptions.headloss, rows, False)
        sql = "SELECT pattern_id FROM "+self.schema_name+".inp_pattern ORDER BY pattern_id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_wsoptions, self.dlg_wsoptions.pattern, rows, False)

        sql = "SELECT id FROM "+self.schema_name+".inp_value_opti_unbal ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_wsoptions, self.dlg_wsoptions.unbalanced, rows, False)

        sql = "SELECT id FROM "+self.schema_name+".inp_value_opti_hyd ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_wsoptions, self.dlg_wsoptions.hydraulics, rows, False)

        sql = "SELECT id FROM "+self.schema_name+".inp_value_opti_qual ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_wsoptions, self.dlg_wsoptions.quality, rows, False)

        sql = "SELECT id FROM "+self.schema_name+".inp_value_opti_valvemode ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_wsoptions, self.dlg_wsoptions.valve_mode, rows, False)

        sql = "SELECT id FROM "+self.schema_name+".anl_mincut_result_cat ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_wsoptions, self.dlg_wsoptions.valve_mode_mincut_result, rows, False)

        sql = "SELECT id FROM "+self.schema_name+".ext_cat_period ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_wsoptions, self.dlg_wsoptions.rtc_period_id, rows, False)

        sql = "SELECT id FROM "+self.schema_name+".inp_value_opti_rtc_coef ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_wsoptions, self.dlg_wsoptions.rtc_coefficient, rows, False)

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

        if utils_giswater.isChecked(self.dlg_wsoptions, self.dlg_wsoptions.chk_enabled):
            self.dlg_wsoptions.rtc_period_id.setEnabled(True)
            self.dlg_wsoptions.rtc_coefficient.setEnabled(True)
            
        self.dlg_wsoptions.unbalanced.currentIndexChanged.connect(
            partial(self.enable_linetext, self.dlg_wsoptions, self.dlg_wsoptions.unbalanced, self.dlg_wsoptions.unbalanced_n, "STOP"))
        self.dlg_wsoptions.hydraulics.currentIndexChanged.connect(
            partial(self.enable_linetext, self.dlg_wsoptions, self.dlg_wsoptions.hydraulics, self.dlg_wsoptions.hydraulics_fname, ""))
        self.dlg_wsoptions.quality.currentIndexChanged.connect(
            partial(self.enable_linetext, self.dlg_wsoptions, self.dlg_wsoptions.quality, self.dlg_wsoptions.node_id, "TRACE"))
        self.dlg_wsoptions.valve_mode.currentIndexChanged.connect(
            partial(self.enable_linetext, self.dlg_wsoptions, self.dlg_wsoptions.valve_mode, self.dlg_wsoptions.valve_mode_mincut_result, "MINCUT RESULTS"))
        self.dlg_wsoptions.chk_enabled.stateChanged.connect(self.enable_per_coef)

        self.dlg_wsoptions.btn_accept.clicked.connect(
            partial(self.update_table, 'inp_options', self.dlg_wsoptions))
        self.dlg_wsoptions.btn_cancel.clicked.connect(self.dlg_wsoptions.close)
        self.go2epa_options_get_data('inp_options',self.dlg_wsoptions)
        self.dlg_wsoptions.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_wsoptions.exec_()


    def ws_times(self):
        """ Open dialog ws_times.ui"""
        
        dlg_wstimes = WStimes()
        # utils_giswater.setDialog(dlg_wstimes)
        self.load_settings(dlg_wstimes)
        dlg_wstimes.duration.setValidator(QIntValidator())
        sql = "SELECT id FROM "+self.schema_name+".inp_value_times ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(dlg_wstimes.statistic, rows, False)
        dlg_wstimes.btn_accept.clicked.connect(partial(self.update_table, 'inp_times', dlg_wstimes))
        dlg_wstimes.btn_cancel.clicked.connect(dlg_wstimes.close)
        self.go2epa_options_get_data('inp_times', dlg_wstimes)
        dlg_wstimes.setWindowFlags(Qt.WindowStaysOnTopHint)
        dlg_wstimes.exec_()


    def enable_per_coef(self):
        """ Enable or dissable cbx """
        self.dlg_wsoptions.rtc_period_id.setEnabled(utils_giswater.isChecked(self.dlg_wsoptions, self.dlg_wsoptions.chk_enabled))
        self.dlg_wsoptions.rtc_coefficient.setEnabled(utils_giswater.isChecked(self.dlg_wsoptions, self.dlg_wsoptions.chk_enabled))


    def enable_linetext(self, dialog, widget1, widget2, text):
        """ Enable or disable txt """
        if utils_giswater.getWidgetText(dialog, widget1) == text:
            utils_giswater.setWidgetEnabled(dialog, widget2, False)
        else:
            utils_giswater.setWidgetEnabled(dialog, widget2, True)


    def ud_options(self):
        """ Dialog ud_options.ui """
        
        # Create dialog
        dlg_udoptions = UDoptions()
        self.load_settings(dlg_udoptions)

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
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(dlg_udoptions, dlg_udoptions.flow_units, rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_options_fr ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(dlg_udoptions, dlg_udoptions.flow_routing, rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_options_lo ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(dlg_udoptions, dlg_udoptions.link_offsets, rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_options_fme ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(dlg_udoptions, dlg_udoptions.force_main_equation, rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_options_nfl ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(dlg_udoptions, dlg_udoptions.normal_flow_limited, rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_options_id ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(dlg_udoptions, dlg_udoptions.inertial_damping, rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".value_yesno ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(dlg_udoptions, dlg_udoptions.allow_ponding, rows, False)
        utils_giswater.fillComboBox(dlg_udoptions, dlg_udoptions.skip_steady_state, rows, False)
        utils_giswater.fillComboBox(dlg_udoptions, dlg_udoptions.ignore_rainfall, rows, False)
        utils_giswater.fillComboBox(dlg_udoptions, dlg_udoptions.ignore_snowmelt, rows, False)
        utils_giswater.fillComboBox(dlg_udoptions, dlg_udoptions.ignore_groundwater, rows, False)
        utils_giswater.fillComboBox(dlg_udoptions, dlg_udoptions.ignore_routing, rows, False)
        utils_giswater.fillComboBox(dlg_udoptions, dlg_udoptions.ignore_quality, rows, False)
        dlg_udoptions.btn_accept.clicked.connect(partial(self.update_table, 'inp_options', dlg_udoptions))
        dlg_udoptions.btn_cancel.clicked.connect(dlg_udoptions.close)
        self.go2epa_options_get_data('inp_options', dlg_udoptions)
        dlg_udoptions.setWindowFlags(Qt.WindowStaysOnTopHint)
        dlg_udoptions.exec_()


    def ud_times(self):
        """ Dialog ud_times.ui """

        dlg_udtimes = UDtimes()
        self.load_settings(dlg_udtimes)
        dlg_udtimes.dry_days.setValidator(QIntValidator())
        dlg_udtimes.btn_accept.clicked.connect(partial(self.update_table, 'inp_options', dlg_udtimes))
        dlg_udtimes.btn_cancel.clicked.connect(dlg_udtimes.close)
        self.go2epa_options_get_data('inp_options', dlg_udtimes)
        dlg_udtimes.setWindowFlags(Qt.WindowStaysOnTopHint)
        dlg_udtimes.exec_()


    def ud_hydrology_selector(self):
        """ Dialog hydrology_selector.ui """

        self.dlg_hydrology_selector = HydrologySelector()
        # utils_giswater.setDialog(self.dlg_hydrology_selector)
        self.load_settings(self.dlg_hydrology_selector)

        self.dlg_hydrology_selector.btn_accept.clicked.connect(self.save_hydrology)
        self.dlg_hydrology_selector.hydrology.currentIndexChanged.connect(self.update_labels)
        self.dlg_hydrology_selector.txt_name.textChanged.connect(partial(self.filter_cbx_by_text, "cat_hydrology", self.dlg_hydrology_selector.txt_name, self.dlg_hydrology_selector.hydrology))

        sql = ("SELECT DISTINCT(name), hydrology_id FROM " + self.schema_name + ".cat_hydrology ORDER BY name")
        rows = self.controller.get_rows(sql)
        if not rows:
            message = "Any data found in table"
            self.controller.show_warning(message, parameter='cat_hydrology')
            return False
        
        utils_giswater.set_item_data(self.dlg_hydrology_selector.hydrology, rows)
 
        sql = ("SELECT DISTINCT(t1.name) FROM " + self.schema_name + ".cat_hydrology AS t1"
               " INNER JOIN " + self.schema_name + ".inp_selector_hydrology AS t2 ON t1.hydrology_id = t2.hydrology_id "
               " WHERE t2.cur_user = current_user")
        row = self.controller.get_rows(sql)
        if row:
            utils_giswater.setWidgetText(self.dlg_hydrology_selector.hydrology, row[0])
        else:
            utils_giswater.setWidgetText(self.dlg_hydrology_selector.hydrology, 0)
        self.update_labels()
        self.dlg_hydrology_selector.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_hydrology_selector.exec_()


    def save_hydrology(self):
        sql = ("SELECT cur_user FROM " + self.schema_name + ".inp_selector_hydrology "
               " WHERE cur_user = current_user")
        row = self.controller.get_row(sql)
        if row:
            sql = ("UPDATE " + self.schema_name + ".inp_selector_hydrology "
                   " SET hydrology_id = "+str(utils_giswater.get_item_data(self.dlg_hydrology_selector, self.dlg_hydrology_selector.hydrology, 1))+""
                   " WHERE cur_user = current_user")
        else:
            sql = ("INSERT INTO " + self.schema_name + ".inp_selector_hydrology (hydrology_id, cur_user)"
                   " VALUES('" +str(utils_giswater.get_item_data(self.dlg_hydrology_selector, self.dlg_hydrology_selector.hydrology, 1))+"', current_user)")
        self.controller.execute_sql(sql)
        message = "Values has been update"
        self.controller.show_info(message)
        self.close_dialog(self.dlg_hydrology_selector)


    def update_labels(self):
        """ Show text in labels from SELECT """
        
        sql = ("SELECT infiltration, text FROM " + self.schema_name + ".cat_hydrology"
               " WHERE name = '" + str(self.dlg_hydrology_selector.hydrology.currentText()) + "'")
        row = self.controller.get_row(sql)
        if row is not None:
            utils_giswater.setText(self.dlg_hydrology_selector.infiltration, row[0])
            utils_giswater.setText(self.dlg_hydrology_selector.descript, row[1])


    def filter_cbx_by_text(self, tablename, widgettxt, widgetcbx):
        
        sql = ("SELECT DISTINCT(name), hydrology_id FROM " + self.schema_name + "." + str(tablename) + ""
               " WHERE name LIKE '%" + str(widgettxt.text()) + "%'"
               " ORDER BY name ")
        rows = self.controller.get_rows(sql)
        if not rows:
            message = "Check the table 'cat_hydrology' "
            self.controller.show_warning(message)
            return False
        utils_giswater.set_item_data(widgetcbx, rows)
        self.update_labels()


    def update_table(self, tablename, dialog):
        """ INSERT or UPDATE tables according :param update"""
        
        sql = "SELECT * FROM " + self.schema_name + "." + tablename
        row = self.controller.get_row(sql)

        columns = []
        for i in range(0, len(row)):
            column_name = self.dao.get_column_name(i)
            columns.append(column_name)

        if columns is not None:
            sql = "UPDATE " + self.schema_name + "." + tablename + " SET "
            for column_name in columns:
                if column_name != 'id':
                    widget = dialog.findChild(QWidget, column_name)
                    widget_type = utils_giswater.getWidgetType(dialog, widget)
                    if widget_type is QCheckBox:
                        value = utils_giswater.isChecked(dialog, widget)
                    elif widget_type is QDateEdit:
                        date = dialog.findChild(QDateEdit, str(column_name))
                        value = date.dateTime().toString('dd/MM/yyyy')
                    elif widget_type is QTimeEdit:
                        aux = 0
                        widget_day = str(column_name) + "_day"
                        day = utils_giswater.getText(dialog, widget)
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
                        value = utils_giswater.getWidgetText(dialog, widget)
                    if value == 'null':
                        sql += column_name + " = null, "
                    elif value is None:
                        pass
                    else:
                        if type(value) is not bool and widget_type is not QSpinBox:
                            value = value.replace(",", ".")
                        sql += column_name + " = '" + str(value) + "', "
            sql = sql[:len(sql) - 2]
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
        message = self.controller.tr("Select INP file")
        self.file_inp = QFileDialog.getSaveFileName(None, message, "", '*.inp')
        if self.file_inp:
            self.dlg_go2epa.txt_file_inp.setText(self.file_inp)


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
        message = self.controller.tr("Select RPT file")
        self.file_rpt = QFileDialog.getSaveFileName(None, message, "", '*.rpt')
        if self.file_rpt:
            self.dlg_go2epa.txt_file_rpt.setText(self.file_rpt)


    def go2epa_accept(self):
        """ Save INP, RPT and result name into GSW file """

        # Get widgets values
        self.file_inp = utils_giswater.getWidgetText(self.dlg_go2epa.txt_file_inp)
        self.file_rpt = utils_giswater.getWidgetText(self.dlg_go2epa.txt_file_rpt)
        self.project_name = utils_giswater.getWidgetText(self.dlg_go2epa.txt_result_name)
        
        # Check that all parameters has been set
        if self.file_inp == "null":
            message = "You have to set this parameter"
            self.controller.show_warning(message, parameter="INP file")
            return
        if self.file_rpt == "null":
            message = "You have to set this parameter"
            self.controller.show_warning(message, parameter="RPT file")
            return            
        if self.project_name == "null":
            message = "You have to set this parameter"
            self.controller.show_warning(message, parameter="Project Name")
            return     
        
        # Check if selected @result_id already exists
        exists = self.check_result_id(self.project_name)
        if exists:
            message = "Selected 'Result name' already exists. Do you want to overwrite it?"
            answer = self.controller.ask_question(message, 'Result name')
            if not answer:
                return
        
        only_check = utils_giswater.isChecked(self.dlg_go2epa.chk_only_check)
        if only_check:
            self.check_data()
            return
        
        # Execute function 'gw_fct_pg2epa'
        sql = "SELECT " + self.schema_name + ".gw_fct_pg2epa('" + str(self.project_name) + "', 'False');"  
        row = self.controller.get_row(sql, log_sql=True)
        if not row:
            return False        
    
        # Save INP, RPT and result name into GSW file
        self.save_file_parameters()
        
        # Save database connection parameters into GSW file
        self.save_database_parameters()
        
        # Close form
        self.close_dialog(self.dlg_go2epa)
        
        # Execute 'go2epa_express'
        self.go2epa_express()
     
    
    def check_result_id(self, result_id):  
        """ Check if selected @result_id already exists """
        
        sql = ("SELECT * FROM " + self.schema_name + ".v_ui_rpt_cat_result"
               " WHERE result_id = '" + str(result_id) + "'")
        row = self.controller.get_row(sql)
        return row
            
                    
    def check_data(self):
        """ Check data executing function 'gw_fct_pg2epa' """
        
        sql = "SELECT " + self.schema_name + ".gw_fct_pg2epa('" + str(self.project_name) + "', 'True');"  
        row = self.controller.get_row(sql, log_sql=True)
        if not row:
            return False
        
        if row[0] > 0:
            message = ("It is not possible to execute the epa model."
                       "There are errors on your project. Review it!")
            sql_details = ("SELECT table_id, column_id, error_message"
                           " FROM audit_check_data"
                           " WHERE fprocesscat_id = 14 AND result_id = '" + str(self.project_name) + "'")
            inf_text = "For more details execute query:\n" + sql_details
            title = "Execute epa model"
            self.controller.show_info_box(message, title, inf_text, parameter=row[0])
            self.csv_audit_check_data("audit_check_data", "audit_check_data_log.csv")
            return False
         
        else:
            message = "Data is ok. You can try to generate the INP file"
            title = "Execute epa model"
            self.controller.show_info_box(message, title)
            return True


    def csv_audit_check_data(self, tablename, filename):
        
        # Get columns name in order of the table
        rows = self.controller.get_columns_list(tablename)
        if not rows:
            message = "Table not found"
            self.controller.show_warning(message, parameter=tablename)
            return
                            
        columns = []
        for i in range(0, len(rows)):
            column_name = rows[i]
            columns.append(str(column_name[0]))
        sql = ("SELECT table_id, column_id, error_message"
               " FROM " + self.schema_name + "." + tablename + ""
               " WHERE fprocesscat_id = 14 AND result_id = '" + self.project_name + "'")
        rows = self.controller.get_rows(sql, log_sql=True)
        if not rows:
            message = "No records found with selected 'result_id'"
            self.controller.show_warning(message, parameter=self.project_name)
            return
        
        all_rows = []
        all_rows.append(columns)
        for i in rows:
            all_rows.append(i)
        path = self.controller.get_log_folder() + filename
        try:
            with open(path, "w") as output:
                writer = csv.writer(output, lineterminator='\n')
                writer.writerows(all_rows)
            message = "File created successfully"
            self.controller.show_info(message, parameter=path, duration=10)                
        except IOError:
            message = "File cannot be created. Check if it is already opened"
            self.controller.show_warning(message, parameter=path)


    def save_file_parameters(self):
        """ Save INP, RPT and result name into GSW file """
              
        self.gsw_settings.setValue('FILE_INP', self.file_inp)
        self.gsw_settings.setValue('FILE_RPT', self.file_rpt)
        self.gsw_settings.setValue('PROJECT_NAME', self.project_name)
        

    def go2epa_express(self):
        """ Button 24: Open giswater in silent mode
            Executes all options of File Manager: Export INP, Execute EPA software and Import results
        """
        
        self.get_last_gsw_file(False)   
        self.execute_giswater("mg_go2epa_express")


    def go2epa_result_selector(self):
        """ Button 29: Epa result selector """

        # Create the dialog and signals
        self.dlg_go2epa_result = EpaResultCompareSelector()
        # utils_giswater.setDialog(self.dlg)
        self.load_settings(self.dlg_go2epa_result)
        self.dlg_go2epa_result.btn_accept.clicked.connect(self.result_selector_accept)
        self.dlg_go2epa_result.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_go2epa_result))
        self.dlg_go2epa_result.rejected.connect(partial(self.close_dialog, self.dlg_go2epa_result))

        # Set values from widgets of type QComboBox
        sql = "SELECT DISTINCT(result_id) FROM " + self.schema_name + ".v_ui_rpt_cat_result ORDER BY result_id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_go2epa_result.rpt_selector_result_id, rows)
        utils_giswater.fillComboBox(self.dlg_go2epa_result.rpt_selector_compare_id, rows)

        # Get current data from tables 'rpt_selector_result' and 'rpt_selector_compare'
        sql = "SELECT result_id FROM " + self.schema_name + ".rpt_selector_result"
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(self.dlg_go2epa_result.rpt_selector_result_id, row["result_id"])
        sql = "SELECT result_id FROM " + self.schema_name + ".rpt_selector_compare"
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(self.dlg_go2epa_result.rpt_selector_compare_id, row["result_id"])

        # Open the dialog
        self.dlg_go2epa_result.setWindowFlags(Qt.WindowStaysOnTopHint)
        self.dlg_go2epa_result.exec_()


    def result_selector_accept(self):
        """ Update current values to the table """

        # Get new values from widgets of type QComboBox
        rpt_selector_result_id = utils_giswater.getWidgetText(self.dlg_go2epa_result.rpt_selector_result_id)
        rpt_selector_compare_id = utils_giswater.getWidgetText(self.dlg_go2epa_result.rpt_selector_compare_id)

        # Set project user
        user = self.controller.get_project_user()

        # Delete previous values
        # Set new values to tables 'rpt_selector_result' and 'rpt_selector_compare'
        sql = ("DELETE FROM " + self.schema_name + ".rpt_selector_result;\n"
               "DELETE FROM " + self.schema_name + ".rpt_selector_compare;\n"
               "INSERT INTO " + self.schema_name + ".rpt_selector_result (result_id, cur_user)"
               " VALUES ('" + rpt_selector_result_id + "', '" + user + "');\n"
               "INSERT INTO " + self.schema_name + ".rpt_selector_compare (result_id, cur_user)"
               " VALUES ('" + rpt_selector_compare_id + "', '" + user + "');")
        self.controller.execute_sql(sql)

        # Show message to user
        message = "Values has been updated"
        self.controller.show_info(message)
        self.close_dialog(self.dlg_go2epa_result)


    def go2epa_options_get_data(self, tablename, dialog):
        """ Get data from selected table """
        
        sql = "SELECT * FROM " + self.schema_name + "." + tablename
        row = self.controller.get_row(sql)
        if not row:
            message = "Any data found in table"
            self.controller.show_warning(message, parameter=tablename)
            return None

        # Iterate over all columns and populate its corresponding widget
        columns = []
        for i in range(0, len(row)):
            column_name = self.dao.get_column_name(i)
            widget = dialog.findChild(QWidget, column_name)
            widget_type = utils_giswater.getWidgetType(dialog, widget)
            if row[column_name] is not None:
                if widget_type is QCheckBox:
                    utils_giswater.setChecked(dialog, widget, row[column_name])
                elif widget_type is QDateEdit:
                    dateaux = row[column_name].replace('/', '-')
                    date = QDate.fromString(dateaux, 'dd-MM-yyyy')
                    utils_giswater.setCalendarDate(dialog, widget, date)

                elif widget_type is QTimeEdit:
                    timeparts = str(row[column_name]).split(':')
                    if len(timeparts) < 3:
                        timeparts.append("0")
                    days = int(timeparts[0]) / 24
                    hours = int(timeparts[0]) % 24
                    minuts = int(timeparts[1])
                    seconds = int(timeparts[2])
                    time = QTime(hours, minuts, seconds)
                    utils_giswater.setTimeEdit(dialog, widget, time)
                    utils_giswater.setText(dialog, column_name + "_day", days)
                else:
                    utils_giswater.setWidgetText(dialog, widget, row[column_name])

            columns.append(column_name)
            
        return columns
    
    
    def go2epa_result_manager(self):
        """ Button 25: Epa result manager """

        # Create the dialog
        self.dlg_manager = EpaResultManager()
        # utils_giswater.setDialog(self.dlg_manager)
        self.load_settings(self.dlg_manager)

        # Fill combo box and table view
        self.fill_combo_result_id()        
        self.dlg_manager.tbl_rpt_cat_result.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.fill_table(self.dlg_manager.tbl_rpt_cat_result, 'v_ui_rpt_cat_result')
        self.set_table_columns(self.dlg_manager.tbl_rpt_cat_result, 'v_ui_rpt_cat_result')

        # Set signals
        self.dlg_manager.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_manager))
        self.dlg_manager.rejected.connect(partial(self.close_dialog, self.dlg_manager))
        self.dlg_manager.txt_result_id.textChanged.connect(self.filter_by_result_id)

        # Open form
        self.open_dialog(self.dlg_manager) 
            
        
    def fill_combo_result_id(self):
        
        sql = "SELECT result_id FROM " + self.schema_name + ".v_ui_rpt_cat_result ORDER BY result_id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_manager.txt_result_id, rows)


    def filter_by_result_id(self):

        table = self.dlg_manager.tbl_rpt_cat_result
        widget_txt = self.dlg_manager.txt_result_id  
        tablename = 'v_ui_rpt_cat_result'
        result_id = utils_giswater.getWidgetText(widget_txt)
        if result_id != 'null':
            expr = " result_id ILIKE '%" + result_id + "%'"
            # Refresh model with selected filter
            table.model().setFilter(expr)
            table.model().select()
        else:
            self.fill_table(table, tablename)
            
            