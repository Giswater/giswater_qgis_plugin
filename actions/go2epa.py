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
        #self.dlg_go2epa.setWindowTitle("Options Table")

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
            insertfield = "sector_id"
            hide_cols_left = [0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
            hide_cols_right = [0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
            self.dlg_go2epa.btn_sector_selection.pressed.connect(partial(self.sector_selection,  "sector", hide_cols_left, "inp_selector_sector", hide_cols_right, "name", "sector_id", "sector_id", insertfield))
            insertfield = "dscenario_id"
            hide_cols_left = [0, 2]
            hide_cols_right = [0, 2, 3, 4, 5]
            self.dlg_go2epa.btn_scensel_time.clicked.connect(partial(self.sector_selection, "cat_dscenario", hide_cols_left, "inp_selector_dscenario", hide_cols_right, "name", "dscenario_id", "dscenario_id", insertfield))

        if self.project_type == 'ud':
            self.dlg_go2epa.btn_opt_hs.setText("Hydrology selector")
            self.dlg_go2epa.btn_time_opt.setText("Options")
            self.dlg_go2epa.btn_scensel_time.setText("Times")
            self.dlg_go2epa.btn_opt_hs.clicked.connect(self.ud_hydrology_selector)
            self.dlg_go2epa.btn_time_opt.clicked.connect(self.ud_options)
            self.dlg_go2epa.btn_scensel_time.clicked.connect(self.ud_times)
            insertfield = "sector_id"
            hide_cols_left = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
            hide_cols_right = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
            self.dlg_go2epa.btn_sector_selection.pressed.connect(partial(self.sector_selection, "sector", hide_cols_left, "inp_selector_sector", hide_cols_right, "name", "sector_id", "sector_id", insertfield))

        # Manage i18n of the form and open it
        self.controller.translate_form(self.dlg_go2epa, 'file_manager')
        self.dlg_go2epa.exec_()


    def sector_selection(self,  tblnameL, hide_cols_left, tbelnameR, hide_cols_right, fieldwhere, fieldONL, fieldONR, insertfield):
        """ Load the tables in the selection form 
        :param tblnameL: Name of the table to load in the QTableView from SELECT *
        :param fieldwhere: To complete the SELECT with a WHERE
        :param tbelnameR: Name of the table to load in the QTableView from tblnameL
        :param fieldONL: Field left to do the inner
        :param fieldONR: Field right to do the inner
        :param insertfield: Field  to do the insert un function "multi_rows_selector"
        :param hide_cols_left: Columns that want to hide from the right QTableView
        :param hide_cols_right: Columns that want to hide from the left QTableView
        """
        
        dlg_psector_sel = Multirow_selector()
        utils_giswater.setDialog(dlg_psector_sel)

        # Tables
        self.tbl_all_row = dlg_psector_sel.findChild(QTableView, "all_row")
        self.tbl_all_row.setSelectionBehavior(QAbstractItemView.SelectRows)
        tbl_selected_row = dlg_psector_sel.findChild(QTableView, "selected_row")
        tbl_selected_row.setSelectionBehavior(QAbstractItemView.SelectRows)

        query_left = "SELECT * FROM "+self.controller.schema_name + "." + tblnameL + " WHERE " + fieldwhere + " NOT IN ("
        query_left += "SELECT " + fieldwhere + " FROM "+self.controller.schema_name + "." + tblnameL
        query_left += " RIGTH JOIN "+self.controller.schema_name + "." + tbelnameR + " ON " + tblnameL + "." + fieldONL + " = " + tbelnameR + "." + fieldONR
        query_left += " WHERE cur_user = current_user)"
        self.fill_table_by_query(self.tbl_all_row, query_left)

        query_right = "SELECT * FROM "+self.controller.schema_name+"." + tblnameL
        query_right += " JOIN "+self.controller.schema_name + "." + tbelnameR + " ON " + tblnameL + "." + fieldONL + " = " + tbelnameR + "." + fieldONR
        query_right += " WHERE cur_user=current_user"
        self.fill_table_by_query(tbl_selected_row, query_right)

        dlg_psector_sel.btn_select.pressed.connect(partial(self.multi_rows_selector, self.tbl_all_row, tbl_selected_row, fieldONL, tbelnameR, fieldONR, query_left, query_right, insertfield))

        query_delete = "DELETE FROM "+self.controller.schema_name+"."+tbelnameR
        query_delete += " WHERE current_user = cur_user AND "+tbelnameR+"."+fieldONR+"="
        dlg_psector_sel.btn_unselect.pressed.connect(partial(self.unselector, self.tbl_all_row, tbl_selected_row, query_delete, query_left, query_right, insertfield))

        self.hide_colums(self.tbl_all_row, hide_cols_left)
        self.hide_colums(tbl_selected_row, hide_cols_right)

        dlg_psector_sel.txt_name.textChanged.connect(partial(self.query_like_widget_text, dlg_psector_sel.txt_name, query_left))
        dlg_psector_sel.btn_cancel.pressed.connect(dlg_psector_sel.close)
        dlg_psector_sel.exec_()


    def query_like_widget_text(self, widget, query_left):
        """ Fill the QTableView according to the query received and the widget.text """
        query = widget.text()
        query_left += "AND name LIKE '%" + query + "%'"
        self.fill_table_by_query(self.tbl_all_row, query_left)


    def hide_colums(self, widget, comuns_to_hide):
        """ Hide columns in QTableView """
        for i in range(0, len(comuns_to_hide)):
            widget.hideColumn(comuns_to_hide[i])
            

    def unselector(self, qtable_left, qtable_right, query_delete, query_left, query_right, field):
        """ Unselect the selected rows and places them on the other QTableView 
        :param field: Name of the column on which you want to do the search for the unselection
        :param query_right: Update QTableView right
        :param query_left: Update QTableView left
        :param query_delete: Query to delete fields from selected table
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
            self.controller.execute_sql(query_delete + str(expl_id[i]))

        # Refresh
        self.fill_table_by_query(qtable_left, query_left)
        self.fill_table_by_query(qtable_right, query_right)
        self.iface.mapCanvas().refresh()


    def multi_rows_selector(self, qtable_left, qtable_right, id_ori, tablename_des, id_des, query_left, query_right, insertfield):
        """ Places the selected rows into other QTableView 
        :param qtable_left: QTableView origin
        :param qtable_right: QTableView destini
        :param id_ori: Refers to the id of the source table
        :param tablename_des: table destini
        :param id_des: Refers to the id of the target table, on which the query will be made
        :param insertfield: Field  to do the insert un function "multi_rows_selector"
        :param query_right: Update QTableView right
        :param query_left: Update QTableView left
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
                sql = 'INSERT INTO ' + self.schema_name + '.' + tablename_des + ' (' + insertfield + ', cur_user) '
                sql += " VALUES (" + str(expl_id[i]) + ", current_user)"
                self.controller.execute_sql(sql)

        # Refresh
        self.fill_table_by_query(qtable_right, query_right)
        self.fill_table_by_query(qtable_left, query_left)
        self.iface.mapCanvas().refresh()


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
        sql+= " WHERE name = '"+str(self.dlg_hydrology_selector.hydrology.currentText())+"'"
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


    def mg_go2epa_select_file_inp(self):
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
        self.dlg_go2epa.txt_file_inp.setText(self.file_inp)


    def mg_go2epa_select_file_rpt(self):
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
        self.dlg_go2epa.txt_file_rpt.setText(self.file_rpt)


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
        self.close_dialog(self.dlg_go2epa)


    def mg_go2epa_express(self):
        """ Button 24. Open giswater in silent mode
        Executes all options of File Manager: 
        Export INP, Execute EPA software and Import results
        """
        self.execute_giswater("mg_go2epa_express", 24)


    def fill_table_by_query(self, qtable, query):
        """
        :param qtable: QTableView to show
        :param query: query to set model
        """
        model = QSqlQueryModel()
        model.setQuery(query)
        qtable.setModel(model)
        qtable.show()


    def go2epa_options_get_data(self, tablename):
        ''' Get data from selected table '''
        
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
                minuts= int(timeparts[1])
                seconds= int(timeparts[2])
                time = QTime(hours,minuts, seconds)
                utils_giswater.setTimeEdit(column_name, time)
                utils_giswater.setText(column_name + "_day", days)
            else:
                utils_giswater.setWidgetText(column_name, row[column_name])
                
            columns.append(column_name)
            
        return columns
    
    