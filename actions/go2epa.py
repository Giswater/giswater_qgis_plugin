"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from PyQt4.QtCore import QSettings
from PyQt4.QtGui import QAbstractItemView
from PyQt4.QtGui import QComboBox
from PyQt4.QtGui import QDoubleValidator, QIntValidator, QFileDialog, QCheckBox, QDateEdit
from PyQt4.QtGui import QLabel, QPushButton, QTableView, QLineEdit, QTimeEdit, QSpinBox
from PyQt4.QtSql import QSqlQueryModel
from datetime import date, datetime, timedelta, time
from dateutil.relativedelta import relativedelta
import os
import sys
from functools import partial

plugin_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(plugin_path)
import utils_giswater


from ..ui.file_manager import FileManager   #@UnresolvedImport
from ..ui.multirow_selector import Multirow_selector       #@UnresolvedImport
from ..ui.ws_options import WSoptions       #@UnresolvedImport
from ..ui.ws_times import WStimes       #@UnresolvedImport
from ..ui.ud_options import UDoptions       #@UnresolvedImport
from ..ui.ud_times import UDtimes       #@UnresolvedImport
from ..ui.hydrology_selector import HydrologySelector       #@UnresolvedImport

from parent import ParentAction


class Go2Epa(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control Management toolbar actions """
        self.minor_version = "3.0"
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
            self.dlg_go2epa.btn_opt_hs.setText("Options")
            self.dlg_go2epa.btn_time_opt.setText("Times")
            self.dlg_go2epa.btn_scensel_time.setText("Dscenario Selector")
            self.dlg_go2epa.chk_export_subcatch.setVisible(False)
            self.dlg_go2epa.btn_opt_hs.clicked.connect(self.ws_options)
            self.dlg_go2epa.btn_time_opt.clicked.connect(self.ws_times)
            self.dlg_go2epa.btn_sector_selection.pressed.connect(self.sector_selection)
            #self.dlg_go2epa.btn_scensel_time.clicked.connect()

        if self.project_type == 'ud':
            self.dlg_go2epa.btn_opt_hs.setText("Hydrology selector")
            self.dlg_go2epa.btn_time_opt.setText("Options")
            self.dlg_go2epa.btn_scensel_time.setText("Times")
            self.dlg_go2epa.btn_opt_hs.clicked.connect(self.ud_hydrology_selector)
            self.dlg_go2epa.btn_time_opt.clicked.connect(self.ud_options)
            self.dlg_go2epa.btn_scensel_time.clicked.connect(self.ud_times)
            self.dlg_go2epa.btn_sector_selection.pressed.connect(partial(self.sector_selection,  "sector", "inp_selector_sector", "name", "sector_id", "sector_id"))
        # self.dlg.btn_sector_selection.clicked.connect()
        # self.dlg.btn_option.clicked.connect()

        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg_go2epa, 'file_manager')
        self.dlg_go2epa.exec_()

    def sector_selection(self,  tblnameL, tbelnameR, fieldwhere, fieldONL, fieldONR):
        self.dlg_psector_sel = Multirow_selector()
        utils_giswater.setDialog(self.dlg_psector_sel)

        # Tables
        self.tbl_all_row = self.dlg_psector_sel.findChild(QTableView, "all_row")
        self.tbl_all_row.setSelectionBehavior(QAbstractItemView.SelectRows)
        sql = "SELECT name FROM "+self.controller.schema_name + "." + tblnameL + " WHERE " + fieldwhere + " NOT IN ("
        sql += "SELECT " + fieldwhere + " FROM "+self.controller.schema_name + "." + tblnameL + " RIGTH JOIN "
        sql += self.controller.schema_name + "." + tbelnameR + " ON " + tblnameL + "." + fieldONL + " = " + tbelnameR + "." + fieldONR
        sql += " WHERE cur_user = current_user)"
        self.fill_table_by_query(self.tbl_all_row, sql)

        self.tbl_selected_psector = self.dlg_psector_sel.findChild(QTableView, "selected_row")
        self.tbl_selected_psector.setSelectionBehavior(QAbstractItemView.SelectRows)
        sql = "SELECT name, sector.sector_id FROM "+self.controller.schema_name+"." + tblnameL
        sql += " JOIN "+self.controller.schema_name + "." + tbelnameR + " ON " + tblnameL + "." + fieldONL + " = " + tbelnameR + "." + fieldONR
        sql += " WHERE cur_user=current_user"
        self.fill_table_by_query(self.tbl_selected_psector, sql)
        TOCA PARAMETRIZAR TODO ESTO!!!!
        #self.btn_select.pressed.connect(self.selection)
        query_left = "SELECT * FROM "+self.controller.schema_name+".sector WHERE name NOT IN "
        query_left += "(SELECT name FROM "+self.controller.schema_name+".sector "
        query_left += "RIGHT JOIN "+self.controller.schema_name+".inp_selector_sector ON sector.sector_id = inp_selector_sector.sector_id "
        query_left += "WHERE cur_user = current_user)"

        query_right = "SELECT name, cur_user, sector.sector_id from "+self.controller.schema_name+".sector "
        query_right += "JOIN "+self.controller.schema_name+".inp_selector_sector ON sector.sector_id=inp_selector_sector.sector_id "
        query_right += "WHERE cur_user = current_user"
        field = "sector_id"
        self.dlg_psector_sel.btn_select.pressed.connect(partial(self.multi_rows_selector, self.tbl_all_row, self.tbl_selected_psector, "sector_id", "inp_selector_sector", "sector_id", query_left,query_right, field))


        #self.btn_unselect.pressed.connect(self.unselection)
        query_left = "SELECT * FROM " + self.controller.schema_name+".sector WHERE name NOT IN "
        query_left += "(SELECT name FROM "+ self.controller.schema_name+".sector RIGHT JOIN " + self.controller.schema_name+".inp_selector_sector "
        query_left += "ON sector.sector_id = inp_selector_sector.sector_id where cur_user=current_user)"
        query_right = "SELECT name, cur_user, sector.sector_id from "+self.controller.schema_name+".sector "
        query_right += "JOIN "+self.controller.schema_name+".inp_selector_sector ON sector.sector_id = inp_selector_sector.sector_id "
        query_right += "WHERE cur_user = current_user"

        query_delete = "DELETE FROM "+self.controller.schema_name+".inp_selector_sector "
        query_delete += "WHERE current_user = cur_user and inp_selector_sector.sector_id ="
        self.dlg_psector_sel.btn_unselect.pressed.connect(partial(self.unselector, self.tbl_all_row, self.tbl_selected_psector,
                                                                  query_delete, query_left, query_right, field))

        self.dlg_psector_sel.btn_cancel.pressed.connect(self.dlg_psector_sel.close)
        self.dlg_psector_sel.exec_()


    def unselector(self, qtable_left, qtable_right, sql, query_left, query_right, field):
        """
        :param qtable_left: QTableView origin
        :param qtable_right: QTableView destini
        """
        selected_list = qtable_right.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message')
            return
        expl_id = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = str(qtable_right.model().record(row).value(field))
            expl_id.append(id_)
        for i in range(0, len(expl_id)):
            self.controller.execute_sql(sql + str(expl_id[i]))

        # Refresh
        self.fill_table_by_query(qtable_left, query_left)
        self.fill_table_by_query(qtable_right, query_right)
        self.iface.mapCanvas().refresh()


    def multi_rows_selector(self, qtable_left, qtable_right, id_ori, tablename_des, id_des, query_left, query_right, field):
        """
        :param qtable_left: QTableView origin
        :param qtable_right: QTableView destini
        :param tablename_ori: table origin
        :param id_ori: Refers to the id of the source table
        :param tablename_des: table destini
        :param id_des: Refers to the id of the target table, on which the query will be made
        """
        selected_list = qtable_left.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message, context_name='ui_message')
            return
        expl_id = []
        curuser_list = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = qtable_left.model().record(row).value(id_ori)
            expl_id.append(id_)
            curuser = qtable_left.model().record(row).value("cur_user")
            curuser_list.append(curuser)
        for i in range(0, len(expl_id)):
            # Check if expl_id already exists in expl_selector
            sql = "SELECT DISTINCT(" + id_des + ", cur_user)"
            sql += " FROM " + self.schema_name + "." + tablename_des
            sql += " WHERE " + id_des + " = '" + str(expl_id[i])
            row = self.dao.get_row(sql)
            if row:
                # if exist - show warning
                self.controller.show_info_box("Id " + str(expl_id[i]) + " is already selected!", "Info")
            else:
                sql = 'INSERT INTO ' + self.schema_name + '.' + tablename_des + ' (' + field + ', cur_user) '
                sql += " VALUES (" + str(expl_id[i]) + ", current_user)"
                self.controller.execute_sql(sql)

        # Refresh
        self.fill_table_by_query(qtable_right, query_right)
        self.fill_table_by_query(qtable_left, query_left)
        self.iface.mapCanvas().refresh()

    def filter_all_explot(self, sql, widget):

        sql += widget.text()+"%'"
        self.controller.show_warning(str(sql))
        model = QSqlQueryModel()
        model.setQuery(sql)
        self.tbl_all_psector.setModel(model)
        self.tbl_all_psector.show()


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
        '''
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_valve_opti_crt_coef ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("rtc_coefficient", rows, False)
        '''
        if self.dlg_wsoptions.valve_mode.currentText() == "MINCUT RESULTS":
            self.dlg_wsoptions.valve_mode_mincut_result.setEnabled(False)

        if self.dlg_wsoptions.hydraulics.currentText() == "":
            self.dlg_wsoptions.hydraulics_fname.setEnabled(False)
        else:
            self.dlg_wsoptions.hydraulics_fname.setEnabled(True)

        if self.dlg_wsoptions.quality.currentText() == "TRACE":
            self.dlg_wsoptions.node_id.setEnabled(False)
        else:
            self.dlg_wsoptions.node_id.setEnabled(True)

        if utils_giswater.isChecked(self.dlg_wsoptions.chk_enabled):
            self.dlg_wsoptions.rtc_period_id.setEnabled(True)
            self.dlg_wsoptions.rtc_coefficient.setEnabled(True)

        self.dlg_wsoptions.unbalanced.currentIndexChanged.connect(partial(self.enabled_linetext, self.dlg_wsoptions.unbalanced, self.dlg_wsoptions.unbalanced_n, "STOP",False))
        self.dlg_wsoptions.hydraulics.currentIndexChanged.connect(partial(self.enabled_linetext, self.dlg_wsoptions.hydraulics, self.dlg_wsoptions.hydraulics_fname, "",False))
        self.dlg_wsoptions.quality.currentIndexChanged.connect(partial(self.enabled_linetext, self.dlg_wsoptions.quality, self.dlg_wsoptions.node_id, "TRACE", False))
        self.dlg_wsoptions.valve_mode.currentIndexChanged.connect(partial(self.enabled_linetext, self.dlg_wsoptions.valve_mode, self.dlg_wsoptions.valve_mode_mincut_result, "MINCUT RESULTS", False))
        self.dlg_wsoptions.chk_enabled.stateChanged.connect(self.enable_per_coef)

        update = True
        self.dlg_wsoptions.btn_accept.pressed.connect(partial(self.insert_or_update, update, 'inp_options', self.dlg_wsoptions))
        self.dlg_wsoptions.btn_cancel.pressed.connect(self.dlg_wsoptions.close)
        self.dlg_wsoptions.exec_()

    def ws_times(self):
        self.dlg_wstimes = WStimes()
        utils_giswater.setDialog(self.dlg_wstimes)
        self.dlg_wstimes.duration.setValidator(QIntValidator())
        sql = "SELECT id FROM "+self.schema_name+".inp_value_times ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox("statistic", rows, False)
        update = True
        self.dlg_wstimes.btn_accept.pressed.connect(partial(self.insert_or_update, update, 'inp_times',self.dlg_wstimes))
        self.dlg_wstimes.btn_cancel.pressed.connect(self.dlg_wstimes.close)
        self.dlg_wstimes.exec_()


    def enable_per_coef(self):
        if utils_giswater.isChecked(self.dlg_wsoptions.chk_enabled):
            self.dlg_wsoptions.rtc_period_id.setEnabled(True)
            self.dlg_wsoptions.rtc_coefficient.setEnabled(True)
        else:
            self.dlg_wsoptions.rtc_period_id.setEnabled(False)
            self.dlg_wsoptions.rtc_coefficient.setEnabled(False)


    def enabled_linetext(self, widget1, widget2, text, enabled):
        if widget1.currentText() == text:
            widget2.setEnabled(enabled)
        else:
            widget2.setEnabled(True)

    def ud_options(self):
        # Create dialog
        self.dlg_udoptions = UDoptions()
        utils_giswater.setDialog(self.dlg_udoptions)

        self.dlg_udoptions.min_slope.setValidator(QDoubleValidator())
        self.dlg_udoptions.lengthening_step.setValidator(QDoubleValidator())
        self.dlg_udoptions.max_trials.setValidator(QIntValidator())
        self.dlg_udoptions.sys_flow_tol.setValidator(QIntValidator())
        self.dlg_udoptions.variable_step.setValidator(QIntValidator())
        self.dlg_udoptions.min_surfarea.setValidator(QIntValidator())
        self.dlg_udoptions.head_tolerance.setValidator(QDoubleValidator())
        self.dlg_udoptions.lat_flow_tol.setValidator(QIntValidator())

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
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".value_yesno ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("allow_ponding", rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".value_yesno ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("skip_steady_state", rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".value_yesno ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("ignore_rainfall", rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".value_yesno ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("ignore_snowmelt", rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".value_yesno ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("ignore_groundwater", rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".value_yesno ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("ignore_routing", rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".value_yesno ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("ignore_quality", rows, False)

        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_options_fme ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("force_main_equation", rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_options_nfl ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("normal_flow_limited", rows, False)
        sql = "SELECT DISTINCT(id) FROM "+self.schema_name+".inp_value_options_id ORDER BY id"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("inertial_damping", rows, False)

        update = True
        self.dlg_udoptions.btn_accept.pressed.connect(partial(self.insert_or_update, update, 'inp_options', self.dlg_udoptions))
        self.dlg_udoptions.btn_cancel.pressed.connect(self.dlg_udoptions.close)
        self.dlg_udoptions.exec_()

    def ud_times(self):
        self.dlg_udtimes = UDtimes()
        utils_giswater.setDialog(self.dlg_udtimes)
        self.dlg_udtimes.dry_days.setValidator(QIntValidator())
        update = True
        self.dlg_udtimes.btn_accept.pressed.connect(partial(self.insert_or_update, update, 'inp_options', self.dlg_udtimes))
        self.dlg_udtimes.btn_cancel.pressed.connect(self.dlg_udtimes.close)
        self.dlg_udtimes.exec_()

    def ud_hydrology_selector(self):
        self.dlg_hydrology_selector = HydrologySelector()
        utils_giswater.setDialog(self.dlg_hydrology_selector)

        self.dlg_hydrology_selector.btn_accept.pressed.connect(self.dlg_hydrology_selector.close)

        self.lbl_infiltration = self.dlg_hydrology_selector.findChild(QLabel, "infiltration")
        self.lbl_descript = self.dlg_hydrology_selector.findChild(QLabel, "descript")
        self.dlg_hydrology_selector.hydrology.currentIndexChanged.connect(self.update_labels)

        self.dlg_hydrology_selector.txt_name.textChanged.connect(partial(self.filter_cbx_by_text, "cat_hydrology", self.dlg_hydrology_selector.txt_name, self.dlg_hydrology_selector.hydrology))

        sql = "SELECT DISTINCT(name) FROM " + self.schema_name + ".cat_hydrology ORDER BY name"
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox("hydrology", rows, False)
        self.update_labels()
        self.dlg_hydrology_selector.exec_()


    def update_labels(self):
        sql = "SELECT infiltration, descript FROM "+self.schema_name + ".cat_hydrology WHERE name='"+str(self.dlg_hydrology_selector.hydrology.currentText())+"'"
        row = self.dao.get_row(sql)
        self.lbl_infiltration.setText(str(row[0]))
        self.lbl_descript.setText(str(row[1]))


    def filter_cbx_by_text(self,tablename, widgettxt, widgetcbx):
        sql = "SELECT DISTINCT(name) FROM " + self.schema_name + "." +str(tablename)
        sql += " WHERE name LIKE '%" + str(widgettxt.text()) + "%' "
        sql += "ORDER BY name "
        rows = self.dao.get_rows(sql)
        utils_giswater.fillComboBox(widgetcbx, rows, False)
        self.update_labels()



    def insert_or_update(self, update, tablename, dialog):
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
                            x=dialog.findChild(QSpinBox, str(column_name))
                            value = x.value()
                            self.controller.show_warning(str(column_name) + "..."+str(value))
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

