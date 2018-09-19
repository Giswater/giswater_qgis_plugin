"""
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
from qgis.core import QgsComposition
from PyQt4.QtGui import QAbstractItemView, QDoubleValidator,QIntValidator, QTableView, QKeySequence, QCompleter
from PyQt4.QtGui import QCheckBox, QLineEdit, QComboBox, QDateEdit, QLabel, QStringListModel
from PyQt4.QtSql import QSqlQueryModel, QSqlTableModel
from PyQt4.QtCore import Qt

import os
import sys
import csv
import operator
import subprocess
import webbrowser
from functools import partial

import utils_giswater
from giswater.ui_manager import Plan_psector
from giswater.ui_manager import Psector_rapport
from giswater.actions.parent_manage import ParentManage
from giswater.actions.multiple_selection import MultipleSelection
from giswater.actions.manage_document import ManageDocument


class ManageNewPsector(ParentManage):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control 'New Psector' of toolbar 'master' """
        ParentManage.__init__(self, iface, settings, controller, plugin_dir)


    def new_psector(self, psector_id=None, plan_om=None):
        """ Buttons 45 and 81: New psector """
        
        # Create the dialog and signals
        self.dlg_plan_psector = Plan_psector()

        self.load_settings(self.dlg_plan_psector)
        self.plan_om = str(plan_om)
        self.dlg_plan_psector.setWindowTitle(self.plan_om + " psector")
        
        # Capture the current layer to return it at the end of the operation
        cur_active_layer = self.iface.activeLayer()
        self.set_selectionbehavior(self.dlg_plan_psector)
        self.project_type = self.controller.get_project_type()

        # Get layers of every geom_type
        self.list_elemets = {}
        self.reset_lists()
        self.reset_layers()
        self.layers['arc'] = self.controller.get_group_layers('arc')
        self.layers['node'] = self.controller.get_group_layers('node')
        self.update = False  # if false: insert; if true: update

        # Remove all previous selections
        self.remove_selection(True)

        # Set icons
        self.set_icon(self.dlg_plan_psector.btn_insert, "111")
        self.set_icon(self.dlg_plan_psector.btn_delete, "112")
        self.set_icon(self.dlg_plan_psector.btn_snapping, "137")
        self.set_icon(self.dlg_plan_psector.btn_doc_insert, "111")
        self.set_icon(self.dlg_plan_psector.btn_doc_delete, "112")
        self.set_icon(self.dlg_plan_psector.btn_doc_new, "34")
        self.set_icon(self.dlg_plan_psector.btn_open_doc, "170")

        table_object = "psector"

        # tab General elements
        self.psector_id = self.dlg_plan_psector.findChild(QLineEdit, "psector_id")
        self.cmb_psector_type = self.dlg_plan_psector.findChild(QComboBox, "psector_type")
        self.cmb_expl_id = self.dlg_plan_psector.findChild(QComboBox, "expl_id")
        self.cmb_sector_id = self.dlg_plan_psector.findChild(QComboBox, "sector_id")
        self.cmb_result_id = self.dlg_plan_psector.findChild(QComboBox, "result_id")
        self.dlg_plan_psector.lbl_result_id.setVisible(True)
        self.cmb_result_id.setVisible(True)

        scale = self.dlg_plan_psector.findChild(QLineEdit, "scale")
        scale.setValidator(QDoubleValidator())
        rotation = self.dlg_plan_psector.findChild(QLineEdit, "rotation")
        rotation.setValidator(QDoubleValidator())
        atlas_id = self.dlg_plan_psector.findChild(QLineEdit, "atlas_id")
        atlas_id.setValidator(QIntValidator())

        self.populate_combos(self.dlg_plan_psector.psector_type, 'name', 'id', self.plan_om + '_psector_cat_type', False)
        self.populate_combos(self.cmb_expl_id, 'name', 'expl_id', 'exploitation', False)
        self.populate_combos(self.cmb_sector_id, 'name', 'sector_id', 'sector', False)

        if self.plan_om == 'om':
            self.populate_result_id(self.dlg_plan_psector.result_id, self.plan_om + '_result_cat')
            utils_giswater.remove_tab_by_tabName(self.dlg_plan_psector.tabWidget, 'tab_document')
            self.dlg_plan_psector.chk_enable_all.setVisible(False)
        elif self.plan_om == 'plan':
            self.dlg_plan_psector.lbl_result_id.setVisible(False)
            self.cmb_result_id.setVisible(False)
            self.dlg_plan_psector.chk_enable_all.setEnabled(False)

        self.priority = self.dlg_plan_psector.findChild(QComboBox, "priority")
        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".value_priority ORDER BY id"
        rows = self.controller.get_rows(sql)
        utils_giswater.fillComboBox(self.dlg_plan_psector, self.priority, rows, False)

        # tab Bugdet
        total_arc = self.dlg_plan_psector.findChild(QLineEdit, "total_arc")
        self.double_validator(total_arc)
        total_node = self.dlg_plan_psector.findChild(QLineEdit, "total_node")
        self.double_validator(total_node)
        total_other = self.dlg_plan_psector.findChild(QLineEdit, "total_other")
        self.double_validator(total_other)
        pem = self.dlg_plan_psector.findChild(QLineEdit, "pem")
        self.double_validator(pem)
        pec_pem = self.dlg_plan_psector.findChild(QLineEdit, "pec_pem")
        self.double_validator(pec_pem)
        pec = self.dlg_plan_psector.findChild(QLineEdit, "pec")
        self.double_validator(pec)
        pec_vat = self.dlg_plan_psector.findChild(QLineEdit, "pec_vat")
        self.double_validator(pec_vat)
        pca = self.dlg_plan_psector.findChild(QLineEdit, "pca")
        self.double_validator(pca)
        gexpenses = self.dlg_plan_psector.findChild(QLineEdit, "gexpenses")
        self.double_validator(gexpenses)
        vat = self.dlg_plan_psector.findChild(QLineEdit, "vat")
        self.double_validator(vat)
        other = self.dlg_plan_psector.findChild(QLineEdit, "other")
        self.double_validator(other)

        self.enable_tabs(False)
        self.enable_buttons(False)

        # Tables
        # tab Elements
        self.qtbl_arc = self.dlg_plan_psector.findChild(QTableView, "tbl_psector_x_arc")
        self.qtbl_arc.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.qtbl_node = self.dlg_plan_psector.findChild(QTableView, "tbl_psector_x_node")
        self.qtbl_node.setSelectionBehavior(QAbstractItemView.SelectRows)
        all_rows = self.dlg_plan_psector.findChild(QTableView, "all_rows")
        all_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
        selected_rows = self.dlg_plan_psector.findChild(QTableView, "selected_rows")
        selected_rows.setSelectionBehavior(QAbstractItemView.SelectRows)

        # if a row is selected from mg_psector_mangement(button 46 or button 81)
        # Si psector_id contiene "1" o "0" python lo toma como boolean, si es True, quiere decir que no contiene valor
        # y por lo tanto es uno nuevo. Convertimos ese valor en 0 ya que ningun id va a ser 0. de esta manera si psector_id
        # tiene un valor distinto de 0, es que el sector ya existe y queremos hacer un update.
        if isinstance(psector_id, bool):
            psector_id = 0
        self.delete_psector_selector(self.plan_om + '_psector_selector')
        # tab 'Document'
        self.doc_id = self.dlg_plan_psector.findChild(QLineEdit, "doc_id")
        self.tbl_document = self.dlg_plan_psector.findChild(QTableView, "tbl_document")

        if psector_id != 0:
            
            self.enable_tabs(True)
            self.enable_buttons(True)
            self.dlg_plan_psector.name.setEnabled(True)
            self.dlg_plan_psector.chk_enable_all.setDisabled(False)
            sql = ("SELECT enable_all FROM " + self.schema_name + "." + self.plan_om+"_psector "
                   " WHERE psector_id = '"+str(psector_id)+"'")
            row = self.controller.get_row(sql)
            if row:
                self.dlg_plan_psector.chk_enable_all.setChecked(row[0])
            self.fill_table(self.dlg_plan_psector, self.qtbl_arc, self.plan_om + "_psector_x_arc", set_edit_triggers=QTableView.DoubleClicked)
            self.set_table_columns(self.dlg_plan_psector, self.qtbl_arc, self.plan_om + "_psector_x_arc")
            self.fill_table(self.dlg_plan_psector, self.qtbl_node, self.plan_om + "_psector_x_node", set_edit_triggers=QTableView.DoubleClicked)
            self.set_table_columns(self.dlg_plan_psector, self.qtbl_node, self.plan_om + "_psector_x_node")
            sql = ("SELECT psector_id, name, psector_type, expl_id, sector_id, priority, descript, text1, text2,"
                   " observ, atlas_id, scale, rotation, active "
                   " FROM " + self.schema_name + "." + self.plan_om + "_psector"
                   " WHERE psector_id = " + str(psector_id))
            row = self.controller.get_row(sql)
            if not row:
                return
            
            self.psector_id.setText(str(row['psector_id']))
            sql = ("SELECT name FROM " + self.schema_name + ".plan_psector_cat_type WHERE id = " + str(row['psector_type']))
            result = self.controller.get_row(sql)
            utils_giswater.set_combo_itemData(self.cmb_psector_type, str(result['name']), 1)
            sql = ("SELECT name FROM " + self.schema_name + ".exploitation WHERE expl_id = " + str(row['expl_id']))
            result = self.controller.get_row(sql)
            utils_giswater.set_combo_itemData(self.cmb_expl_id, str(result['name']), 1)
            sql = ("SELECT name FROM " + self.schema_name + ".sector WHERE sector_id = " + str(row['sector_id']))
            result = self.controller.get_row(sql)
            utils_giswater.set_combo_itemData(self.cmb_sector_id, str(result['name']), 1)

            # utils_giswater.setRow(row)
            utils_giswater.setChecked(self.dlg_plan_psector, "active", row['active'])
            utils_giswater.fillWidget(self.dlg_plan_psector, "name", row)
            utils_giswater.fillWidget(self.dlg_plan_psector, "descript", row)
            index = self.priority.findText(row["priority"], Qt.MatchFixedString)
            if index >= 0:
                self.priority.setCurrentIndex(index)
            utils_giswater.fillWidget(self.dlg_plan_psector, "text1", row)
            utils_giswater.fillWidget(self.dlg_plan_psector, "text2", row)
            utils_giswater.fillWidget(self.dlg_plan_psector, "observ", row)
            utils_giswater.fillWidget(self.dlg_plan_psector, "atlas_id", row)
            utils_giswater.fillWidget(self.dlg_plan_psector, "scale", row)
            utils_giswater.fillWidget(self.dlg_plan_psector, "rotation", row)

            # Fill tables tbl_arc_plan, tbl_node_plan, tbl_v_plan/om_other_x_psector with selected filter
            expr = " psector_id = " + str(psector_id)
            self.qtbl_arc.model().setFilter(expr)
            self.qtbl_arc.model().select()

            expr = " psector_id = " + str(psector_id)
            self.qtbl_node.model().setFilter(expr)
            self.qtbl_node.model().select()

            self.populate_budget(self.dlg_plan_psector, psector_id)
            self.update = True
            if utils_giswater.getWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.psector_id) != 'null':
                sql = ("DELETE FROM " + self.schema_name + "."+self.plan_om + "_psector_selector "
                       " WHERE cur_user= current_user")
                self.controller.execute_sql(sql)
                self.insert_psector_selector(self.plan_om + '_psector_selector', 'psector_id',
                                             utils_giswater.getWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.psector_id))
            if self.plan_om == 'plan':
                sql = ("DELETE FROM " + self.schema_name + ".selector_psector"
                       " WHERE cur_user = current_user AND psector_id='" + ""
                       "" + utils_giswater.getWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.psector_id) + "'")
                self.controller.execute_sql(sql)
                self.insert_psector_selector('selector_psector', 'psector_id', utils_giswater.getWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.psector_id))

            layer = self.controller.get_layer_by_tablename('v_edit_'+self.plan_om+'_psector')
            expr_filter = "psector_id = '" + str(psector_id) + "'"
            (is_valid, expr) = self.check_expression(expr_filter)  # @UnusedVariable
            if not is_valid:
                return
            self.select_features_by_expr(layer, expr)
            self.zoom_to_selected_features(layer)
            layer.removeSelection()

            filter_ = "psector_id = '" + str(psector_id) + "'"
            self.fill_table_object(self.tbl_document, self.schema_name + ".v_ui_doc_x_psector", filter_)
            self.tbl_document.doubleClicked.connect(partial(self.document_open))

        sql = ("SELECT state_id FROM " + self.schema_name + ".selector_state WHERE cur_user = current_user")
        rows = self.controller.get_rows(sql)
        self.all_states = rows
        self.delete_psector_selector('selector_state')
        self.insert_psector_selector('selector_state', 'state_id', '1')

        # Set signals
        self.dlg_plan_psector.btn_accept.clicked.connect(partial(self.insert_or_update_new_psector, "v_edit_" + self.plan_om + '_psector', True))
        self.dlg_plan_psector.tabWidget.currentChanged.connect(partial(self.check_tab_position))
        self.dlg_plan_psector.btn_cancel.clicked.connect(partial(self.close_psector, cur_active_layer))
        self.dlg_plan_psector.psector_type.currentIndexChanged.connect(partial(self.populate_result_id, self.dlg_plan_psector.result_id, self.plan_om + '_result_cat'))
        self.dlg_plan_psector.rejected.connect(partial(self.close_psector, cur_active_layer))
        self.dlg_plan_psector.chk_enable_all.stateChanged.connect(partial(self.enable_all))


        self.lbl_descript = self.dlg_plan_psector.findChild(QLabel, "lbl_descript")
        self.dlg_plan_psector.all_rows.clicked.connect(partial(self.show_description))
        self.dlg_plan_psector.btn_select.clicked.connect(partial(self.update_total, self.dlg_plan_psector, self.dlg_plan_psector.selected_rows))
        self.dlg_plan_psector.btn_unselect.clicked.connect(partial(self.update_total, self.dlg_plan_psector, self.dlg_plan_psector.selected_rows))
        self.dlg_plan_psector.btn_insert.clicked.connect(partial(self.insert_feature, self.dlg_plan_psector, table_object, True))
        self.dlg_plan_psector.btn_delete.clicked.connect(partial(self.delete_records,self.dlg_plan_psector, table_object, True))
        self.dlg_plan_psector.btn_delete.setShortcut(QKeySequence(Qt.Key_Delete))
        self.dlg_plan_psector.btn_snapping.clicked.connect(partial(self.selection_init, self.dlg_plan_psector, table_object, True))

        self.dlg_plan_psector.btn_rapports.clicked.connect(partial(self.open_dlg_rapports))
        self.dlg_plan_psector.tab_feature.currentChanged.connect(partial(self.tab_feature_changed, self.dlg_plan_psector, table_object))
        self.dlg_plan_psector.name.textChanged.connect(partial(self.enable_relation_tab, self.plan_om + '_psector'))
        self.dlg_plan_psector.txt_name.textChanged.connect(partial(self.query_like_widget_text, self.dlg_plan_psector, self.dlg_plan_psector.txt_name,
            self.dlg_plan_psector.all_rows, 'v_price_compost', 'v_edit_'+self.plan_om + '_psector_x_other', "id"))

        self.dlg_plan_psector.gexpenses.returnPressed.connect(partial(self.calulate_percents, self.plan_om + '_psector', psector_id, 'gexpenses'))
        self.dlg_plan_psector.vat.returnPressed.connect(partial(self.calulate_percents, self.plan_om + '_psector', psector_id, 'vat'))
        self.dlg_plan_psector.other.returnPressed.connect(partial(self.calulate_percents, self.plan_om + '_psector', psector_id, 'other'))

        self.dlg_plan_psector.btn_doc_insert.clicked.connect(self.document_insert)
        self.dlg_plan_psector.btn_doc_delete.clicked.connect(self.document_delete)
        self.dlg_plan_psector.btn_doc_new.clicked.connect(partial(self.manage_document, self.tbl_document))
        self.dlg_plan_psector.btn_open_doc.clicked.connect(self.document_open)

        self.set_completer()

        sql = ("SELECT other, gexpenses, vat FROM " + self.schema_name + "." + self.plan_om + "_psector "
               " WHERE psector_id = '" + str(psector_id) + "'")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.other, row[0])
            utils_giswater.setWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.gexpenses, row[1])
            utils_giswater.setWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.vat, row[2])

        # Adding auto-completion to a QLineEdit for default feature
        self.geom_type = "arc"
        viewname = "v_edit_" + self.geom_type
        self.set_completer_feature_id(self.dlg_plan_psector.feature_id, self.geom_type, viewname)

        # Set default tab 'arc'
        self.dlg_plan_psector.tab_feature.setCurrentIndex(0)
        self.geom_type = "arc"
        self.tab_feature_changed(self.dlg_plan_psector, table_object)

        # Open dialog
        self.open_dialog(self.dlg_plan_psector, maximize_button=False)


    def enable_all(self):
        
        value = utils_giswater.isChecked(self.dlg_plan_psector, "chk_enable_all")
        psector_id = utils_giswater.getWidgetText(self.dlg_plan_psector, "psector_id")
        sql = ("SELECT gw_fct_plan_psector_enableall("+str(value)+", '"+str(psector_id)+"')")
        self.controller.execute_sql(sql)
        self.reload_qtable(self.dlg_plan_psector, 'arc', self.plan_om)
        self.reload_qtable(self.dlg_plan_psector, 'node', self.plan_om)
        sql = ("UPDATE " + self.schema_name + ".plan_psector "
               " SET enable_all = '" + str(value) + "' "
               " WHERE psector_id = '" + str(psector_id) + "'")
        self.controller.execute_sql(sql, log_sql=True)
        self.refresh_map_canvas()


    def update_total(self, dialog, qtable):
        """ Show description of product plan/om _psector as label """
        
        selected_list = qtable.model()
        if selected_list is None:
            return
        total = 0
        psector_id = utils_giswater.getWidgetText(dialog, 'psector_id')
        for x in range(0, selected_list.rowCount()):
            if int(qtable.model().record(x).value('psector_id')) == int(psector_id):
                if str(qtable.model().record(x).value('total_budget')) != 'NULL':
                    total += float(qtable.model().record(x).value('total_budget'))
        utils_giswater.setText(dialog, 'lbl_total', str(total))


    def open_dlg_rapports(self, previous_dialog):#, self.dlg_plan_psector

        default_file_name = utils_giswater.getWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.name)

        self.dlg_psector_rapport = Psector_rapport()
        self.load_settings(self.dlg_psector_rapport)

        utils_giswater.setWidgetText(self.dlg_psector_rapport, 'txt_composer_path', default_file_name + " comp.pdf")
        utils_giswater.setWidgetText(self.dlg_psector_rapport, 'txt_csv_detail_path', default_file_name + " detail.csv")
        utils_giswater.setWidgetText(self.dlg_psector_rapport, 'txt_csv_path', default_file_name + ".csv")

        self.dlg_psector_rapport.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_psector_rapport))
        self.dlg_psector_rapport.btn_ok.clicked.connect(partial(self.generate_rapports))
        self.dlg_psector_rapport.btn_path.clicked.connect(partial(self.get_folder_dialog, self.dlg_psector_rapport.txt_path))

        utils_giswater.setWidgetText(self.dlg_psector_rapport, self.dlg_psector_rapport.txt_path,
            self.controller.plugin_settings_value('psector_rapport_path'))
        utils_giswater.setChecked(self.dlg_psector_rapport, self.dlg_psector_rapport.chk_composer,
            bool(self.controller.plugin_settings_value('psector_rapport_chk_composer')))
        utils_giswater.setChecked(self.dlg_psector_rapport, self.dlg_psector_rapport.chk_csv_detail,
            self.controller.plugin_settings_value('psector_rapport_chk_csv_detail'))
        utils_giswater.setChecked(self.dlg_psector_rapport, self.dlg_psector_rapport.chk_csv,
            self.controller.plugin_settings_value('psector_rapport_chk_csv'))
        if utils_giswater.getWidgetText(self.dlg_psector_rapport, self.dlg_psector_rapport.txt_path) == 'null':
            if 'nt' in sys.builtin_module_names:
                plugin_dir = os.path.expanduser("~\Documents")
            else:
                plugin_dir = os.path.expanduser("~")
            utils_giswater.setWidgetText(self.dlg_psector_rapport, self.dlg_psector_rapport.txt_path, plugin_dir)
        self.populate_cmb_templates()
        
        # Open dialog
        self.open_dialog(self.dlg_psector_rapport, maximize_button=False)     


    def populate_cmb_templates(self):
        
        composers = self.iface.activeComposers()
        index = 0
        records = []
        for comp_view in composers:
            elem = [index, comp_view.composerWindow().windowTitle()]
            records.append(elem)
            index = index +1
        utils_giswater.set_item_data(self.dlg_psector_rapport.cmb_templates, records, 1)
        sql = ("SELECT value FROM " + self.schema_name + ".config_param_user "
               " WHERE parameter = 'composer_" + self.plan_om + "_vdefault' AND cur_user= current_user")
        row = self.controller.get_row(sql)
        if not row:
            return
        utils_giswater.setWidgetText(self.dlg_psector_rapport, self.dlg_psector_rapport.cmb_templates, row[0])


    def generate_rapports(self):
        
        self.controller.plugin_settings_set_value("psector_rapport_path", 
            utils_giswater.getWidgetText(self.dlg_psector_rapport, 'txt_path'))
        self.controller.plugin_settings_set_value("psector_rapport_chk_composer", 
            utils_giswater.isChecked(self.dlg_psector_rapport, 'chk_composer'))
        self.controller.plugin_settings_set_value("psector_rapport_chk_csv_detail", 
            utils_giswater.isChecked(self.dlg_psector_rapport, 'chk_csv_detail'))
        self.controller.plugin_settings_set_value("psector_rapport_chk_csv", 
            utils_giswater.isChecked(self.dlg_psector_rapport, 'chk_csv'))
        
        folder_path = utils_giswater.getWidgetText(self.dlg_psector_rapport, self.dlg_psector_rapport.txt_path)
        if folder_path is None or folder_path == 'null' or not os.path.exists(folder_path):
            self.get_folder_dialog(self.dlg_psector_rapport.txt_path)
            folder_path = utils_giswater.getWidgetText(self.dlg_psector_rapport, self.dlg_psector_rapport.txt_path)
            
        # Generate Composer
        if utils_giswater.isChecked(self.dlg_psector_rapport, self.dlg_psector_rapport.chk_composer):
            file_name = utils_giswater.getWidgetText(self.dlg_psector_rapport, 'txt_composer_path')
            if file_name is None or file_name == 'null':
                message = "File name is required"
                self.controller.show_warning(message)
            if file_name.find('.pdf') is False:
                file_name += '.pdf'
            path = folder_path + '/' + file_name
            self.generate_composer(path)

        # Generate csv detail
        if utils_giswater.isChecked(self.dlg_psector_rapport, self.dlg_psector_rapport.chk_csv_detail):
            file_name = utils_giswater.getWidgetText(self.dlg_psector_rapport, 'txt_csv_path')
            viewname = "v_" + self.plan_om + "_current_psector_budget_detail"
            if self.plan_om == 'om' and self.dlg_plan_psector.psector_type.currentIndex() == 0:
                viewname = 'v_om_current_psector_budget_detail_rec'
            elif self.plan_om == 'om' and self.dlg_plan_psector.psector_type.currentIndex() == 1:
                viewname = 'v_om_current_psector_budget_detail_reh'
            if file_name is None or file_name == 'null':
                message = "Price list csv file name is required"
                self.controller.show_warning(message)
            if file_name.find('.csv') is False:
                file_name += '.csv'
            path = folder_path + '/' + file_name
            self.generate_csv(path, viewname)

        # Generate csv
        if utils_giswater.isChecked(self.dlg_psector_rapport, self.dlg_psector_rapport.chk_csv):
            file_name = utils_giswater.getWidgetText(self.dlg_psector_rapport, 'txt_csv_detail_path')
            viewname = "v_" + self.plan_om + "_current_psector_budget"
            if file_name is None or file_name == 'null':
                message = "Price list csv file name is required"
                self.controller.show_warning(message)
            if file_name.find('.csv') is False:
                file_name += '.csv'
            path = folder_path + '/' + file_name
            self.generate_csv(path, viewname)
        self.close_dialog(self.dlg_psector_rapport)


    def generate_composer(self, path):

        index = utils_giswater.get_item_data(self.dlg_psector_rapport, self.dlg_psector_rapport.cmb_templates, 0)
        comp_view = self.iface.activeComposers()[index]
        my_comp = comp_view.composition()
        if my_comp is not None:
            my_comp.setAtlasMode(QgsComposition.PreviewAtlas)
            try:
                result = my_comp.exportAsPDF(path)
                if result:
                    message = "Document PDF created in"
                    self.controller.show_info(message, parameter=path)
                    os.startfile(path)
                else:
                    message = "Cannot create file, check if its open"
                    self.controller.show_warning(message, parameter=path)
            except:
                msg = "Cannot create file, check if selected composer is the correct composer"
                self.controller.show_warning(msg, parameter=path)


    def generate_csv(self, path, viewname):

        # Get columns name in order of the table
        sql = ("SELECT column_name FROM information_schema.columns"
               " WHERE table_name = '" + str(viewname) + "'"
               " AND table_schema = '" + self.schema_name.replace('"', '') + "'"
               " ORDER BY ordinal_position")
        rows = self.controller.get_rows(sql)
        columns = []

        if not rows or rows is None or rows == '':
            message = "CSV not generated. Check fields from table or view: "
            self.controller.show_warning(message, parameter=viewname)
            return
        for i in range(0, len(rows)):
            column_name = rows[i]
            columns.append(str(column_name[0]))

        sql = ("SELECT * FROM " + self.schema_name + "." + viewname + ""
               " WHERE psector_id = '" + str(utils_giswater.getWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.psector_id)) + "'")
        rows = self.controller.get_rows(sql)
        all_rows = []
        all_rows.append(columns)
        if not rows or rows is None or rows == '':
            return
        for i in rows:
            all_rows.append(i)

        with open(path, "w") as output:
            writer = csv.writer(output, lineterminator='\n')
            writer.writerows(all_rows)


    def populate_budget(self, dialog, psector_id):
        
        sql = ("SELECT DISTINCT(column_name) FROM information_schema.columns"
               " WHERE table_name = 'v_" + self.plan_om + "_current_psector'")
        rows = self.controller.get_rows(sql)
        columns = []
        for i in range(0, len(rows)):
            column_name = rows[i]
            columns.append(str(column_name[0]))

        sql = ("SELECT total_arc, total_node, total_other, pem, pec, pec_vat, gexpenses, vat, other, pca"
               " FROM " + self.schema_name + ".v_" + self.plan_om + "_current_psector"
               " WHERE psector_id = '" + str(psector_id) + "'")
        row = self.controller.get_row(sql)
        if row:
            for column_name in columns:
                if column_name in row:
                    if row[column_name] is not None:
                        utils_giswater.setText(dialog, column_name, row[column_name])
                    else:
                        utils_giswater.setText(dialog, column_name, 0)

        self.calc_pec_pem(dialog)
        self.calc_pecvat_pec(dialog)
        self.calc_pca_pecvat(dialog)


    def calc_pec_pem(self, dialog):
        
        if str(utils_giswater.getWidgetText(dialog, 'pec')) != 'null':
            pec = float(utils_giswater.getWidgetText(dialog, 'pec'))
        else:
            pec = 0
        if str(utils_giswater.getWidgetText(dialog, 'pem')) != 'null':
            pem = float(utils_giswater.getWidgetText(dialog, 'pem'))
        else:
            pem = 0
        res = pec - pem
        utils_giswater.setWidgetText(dialog, 'pec_pem', res)


    def calc_pecvat_pec(self, dialog):

        if str(utils_giswater.getWidgetText(dialog, 'pec_vat')) != 'null':
            pec_vat = float(utils_giswater.getWidgetText(dialog, 'pec_vat'))
        else:
            pec_vat = 0
        if str(utils_giswater.getWidgetText(dialog, 'pec')) != 'null':
            pec = float(utils_giswater.getWidgetText(dialog, 'pec'))
        else:
            pec = 0
        res = pec_vat - pec
        utils_giswater.setWidgetText(dialog, 'pecvat_pem', res)


    def calc_pca_pecvat(self, dialog):
        
        if str(utils_giswater.getWidgetText(dialog, 'pca')) != 'null':
            pca = float(utils_giswater.getWidgetText(dialog, 'pca'))
        else:
            pca = 0
        if str(utils_giswater.getWidgetText(dialog, 'pec_vat')) != 'null':
            pec_vat = float(utils_giswater.getWidgetText(dialog, 'pec_vat'))
        else:
            pec_vat = 0
        res = pca - pec_vat
        utils_giswater.setWidgetText(dialog, 'pca_pecvat', res)


    def calulate_percents(self, tablename, psector_id, field):
        
        psector_id = utils_giswater.getWidgetText(self.dlg_plan_psector, "psector_id")
        sql = ("UPDATE " + self.schema_name + "." + tablename + " "
               " SET " + field + " = '" + utils_giswater.getText(self.dlg_plan_psector, field) + "'"
               " WHERE psector_id = '" + str(psector_id) + "'")
        self.controller.execute_sql(sql)
        self.populate_budget(self.dlg_plan_psector, psector_id)


    def show_description(self):
        """ Show description of product plan/om _psector as label"""
        
        selected_list = self.dlg_plan_psector.all_rows.selectionModel().selectedRows()
        des = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            des = self.dlg_plan_psector.all_rows.model().record(row).value('descript')
        utils_giswater.setText(self.dlg_plan_psector, self.lbl_descript, des)


    def double_validator(self, widget):
        validator = QDoubleValidator(-9999999, 99, 2)
        validator.setNotation(QDoubleValidator().StandardNotation)
        widget.setValidator(validator)


    def enable_tabs(self, enabled):
        self.dlg_plan_psector.tabWidget.setTabEnabled(1, enabled)
        self.dlg_plan_psector.tabWidget.setTabEnabled(2, enabled)
        self.dlg_plan_psector.tabWidget.setTabEnabled(3, enabled)
        self.dlg_plan_psector.tabWidget.setTabEnabled(4, enabled)


    def enable_buttons(self, enabled):
        self.dlg_plan_psector.btn_insert.setEnabled(enabled)
        self.dlg_plan_psector.btn_delete.setEnabled(enabled)
        self.dlg_plan_psector.btn_snapping.setEnabled(enabled)


    def selection_init(self, dialog, table_object, query=True):
        """ Set canvas map tool to an instance of class 'MultipleSelection' """

        multiple_selection = MultipleSelection(self.iface, self.controller, self.layers[self.geom_type],
                                               manage_new_psector=self, table_object=table_object)
        self.canvas.setMapTool(multiple_selection)
        self.disconnect_signal_selection_changed()
        self.connect_signal_selection_changed(dialog, table_object, query)

        cursor = self.get_cursor_multiple_selection()
        self.canvas.setCursor(cursor)


    def connect_signal_selection_changed(self, dialog, table_object, query=True):
        """ Connect signal selectionChanged """

        try:
            self.canvas.selectionChanged.connect(partial(self.selection_changed, dialog, table_object, self.geom_type, query))
        except Exception:
            pass


    def enable_relation_tab(self, tablename):
        
        sql = ("SELECT name FROM " + self.schema_name + "." + tablename + " "
               " WHERE LOWER(name) = '" + utils_giswater.getWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.name) + "'")
        rows = self.controller.get_rows(sql)
        if not rows:
            if self.dlg_plan_psector.name.text() != '':
                self.enable_tabs(True)
            else:
                self.enable_tabs(False)
        else:
            self.enable_tabs(False)


    def delete_psector_selector(self, tablename):
        sql = ("DELETE FROM " + self.schema_name + "." + tablename + ""
               " WHERE cur_user = current_user")
        self.controller.execute_sql(sql)


    def insert_psector_selector(self, tablename, field, value):
        sql = ("INSERT INTO " + self.schema_name + "." + tablename + " (" + field + ", cur_user)"
               " VALUES ('" + str(value) + "', current_user)")
        self.controller.execute_sql(sql)


    def check_tab_position(self):
        
        self.dlg_plan_psector.name.setEnabled(False)
        self.insert_or_update_new_psector(tablename='v_edit_'+self.plan_om + '_psector', close_dlg=False)
        self.update = True
        if self.dlg_plan_psector.tabWidget.currentIndex() == 2:
            tableleft = "v_price_compost"
            tableright = "v_edit_" + self.plan_om + "_psector_x_other"
            field_id_right = "price_id"
            self.price_selector(self.dlg_plan_psector, tableleft, tableright, field_id_right)
            self.update_total(self.dlg_plan_psector, self.dlg_plan_psector.selected_rows)
        elif self.dlg_plan_psector.tabWidget.currentIndex() == 3:
            self.populate_budget(self.dlg_plan_psector, utils_giswater.getWidgetText(self.dlg_plan_psector, 'psector_id'))
        elif self.dlg_plan_psector.tabWidget.currentIndex() == 4:
            psector_id = utils_giswater.getWidgetText(self.dlg_plan_psector, 'psector_id')
            expr = "psector_id = '" + str(psector_id) + "'"
            self.fill_table_object(self.tbl_document, self.schema_name + ".v_ui_doc_x_psector", expr_filter=expr)

        sql = ("SELECT other, gexpenses, vat"
               " FROM " + self.schema_name + "." + self.plan_om + "_psector "
               " WHERE psector_id = '" + str(utils_giswater.getWidgetText(self.dlg_plan_psector, 'psector_id')) + "'")
        row = self.controller.get_row(sql)
        if row:
            utils_giswater.setWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.other, row[0])
            utils_giswater.setWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.gexpenses, row[1])
            utils_giswater.setWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.vat, row[2])

        self.dlg_plan_psector.chk_enable_all.setEnabled(True)


    def populate_result_id(self, combo, table_name):

        index = self.dlg_plan_psector.psector_type.itemData(self.dlg_plan_psector.psector_type.currentIndex())
        sql = ("SELECT result_type, name FROM " + self.schema_name + "." + table_name + ""
               " WHERE result_type = " + str(index[0]) + " ORDER BY name DESC")
        rows = self.controller.get_rows(sql)
        if not rows:
            return False

        records = []
        for row in rows:
            elem = [row[0], row[1]]
            records.append(elem)

        combo.blockSignals(True)
        combo.clear()

        records_sorted = sorted(records, key=operator.itemgetter(1))
        for record in records_sorted:
            combo.addItem(record[1], record)
        combo.blockSignals(False)


    def populate_combos(self, combo, field_name, field_id, table_name, allow_nulls=True):
        
        sql = ("SELECT DISTINCT(" + field_id + "), " + field_name + ""
               " FROM " + self.schema_name + "." + table_name + " ORDER BY " + field_name)
        rows = self.dao.get_rows(sql)
        if not rows:
            return
        combo.blockSignals(True)
        combo.clear()
        if allow_nulls:
            combo.addItem("", "")
        records_sorted = sorted(rows, key=operator.itemgetter(1))
        for record in records_sorted:
            combo.addItem(record[1], record)
        combo.blockSignals(False)


    def reload_states_selector(self):
        
        self.delete_psector_selector('selector_state')
        for x in range(0, len(self.all_states)):
            sql = ("INSERT INTO " + self.schema_name + ".selector_state (state_id, cur_user)"
                   " VALUES ('" + str(self.all_states[x][0]) + "', current_user)")
            self.controller.execute_sql(sql)


    def close_psector(self, cur_active_layer=None):
        """ Close dialog and disconnect snapping """
        
        self.reload_states_selector()
        if cur_active_layer:
            self.iface.setActiveLayer(cur_active_layer)
        self.remove_selection(True)
        self.reset_model_psector("arc")
        self.reset_model_psector("node")
        self.reset_model_psector("other")
        self.close_dialog(self.dlg_plan_psector)
        self.hide_generic_layers()
        self.disconnect_snapping()
        self.disconnect_signal_selection_changed()


    def reset_model_psector(self, geom_type):
        """ Reset model of the widget """
        
        table_relation = "" + geom_type + "_plan"
        widget_name = "tbl_" + table_relation
        widget = utils_giswater.getWidget(self.dlg_plan_psector, widget_name)
        if widget:
            widget.setModel(None)


    def check_name(self, psector_name):
        """ Check if name of new psector exist or not """

        sql = ("SELECT name FROM " + self.schema_name + "." + self.plan_om + "_psector"
               " WHERE name = '" + psector_name + "'")
        row = self.controller.get_row(sql)
        if row is None:
            return False
        return True


    def insert_or_update_new_psector(self, tablename, close_dlg=False):

        psector_name = utils_giswater.getWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.name, return_string_null=False)
        if psector_name == "":
            message = "Mandatory field is missing. Please, set a value"
            self.controller.show_warning(message, parameter='Name')
            return

        rotation = utils_giswater.getWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.rotation, return_string_null=False)
        if rotation == "":
            utils_giswater.setWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.rotation, 0)

        name_exist = self.check_name(psector_name)
        if name_exist and not self.update:
            message = "The name is current in use"
            self.controller.show_warning(message)
            return
        else:
            self.enable_tabs(True)
            self.enable_buttons(True)

        sql = ("SELECT column_name FROM information_schema.columns"
               " WHERE table_name = '" + "v_edit_" + self.plan_om + "_psector'"
               " AND table_schema = '" + self.schema_name.replace('"', '') + "'"
               " ORDER BY ordinal_position")
        rows = self.controller.get_rows(sql)

        columns = []
        for i in range(0, len(rows)):
            column_name = rows[i]
            columns.append(str(column_name[0]))

        if self.update:
            if columns:
                sql = "UPDATE " + self.schema_name + "." + tablename + " SET "
                for column_name in columns:
                    if column_name != 'psector_id':
                        widget_type = utils_giswater.getWidgetType(self.dlg_plan_psector, column_name)
                        if widget_type is QCheckBox:
                            value = utils_giswater.isChecked(self.dlg_plan_psector, column_name)
                        elif widget_type is QDateEdit:
                            date = self.dlg_plan_psector.findChild(QDateEdit, str(column_name))
                            value = date.dateTime().toString('yyyy-MM-dd HH:mm:ss')
                        elif (widget_type is QComboBox) and (column_name == 'expl_id' or column_name == 'sector_id'
                              or column_name == 'result_id' or column_name == 'psector_type'):
                            combo = utils_giswater.getWidget(self.dlg_plan_psector, column_name)
                            elem = combo.itemData(combo.currentIndex())
                            value = str(elem[0])
                        else:
                            value = utils_giswater.getWidgetText(self.dlg_plan_psector, column_name)
                        if value is None or value == 'null':
                            sql += column_name + " = null, "
                        else:
                            if type(value) is not bool:
                                value = value.replace(",", ".")
                            sql += column_name + " = '" + str(value) + "', "

                sql = sql[:len(sql) - 2]
                sql += " WHERE psector_id = '" + utils_giswater.getWidgetText(self.dlg_plan_psector, self.psector_id) + "'"

        else:
            values = "VALUES("
            if columns:
                sql = "INSERT INTO " + self.schema_name + "." + tablename + " ("
                for column_name in columns:
                    if column_name != 'psector_id':
                        widget_type = utils_giswater.getWidgetType(self.dlg_plan_psector, column_name)
                        if widget_type is not None:
                            if widget_type is QCheckBox:
                                value = str(utils_giswater.isChecked(self.dlg_plan_psector, column_name)).upper()
                            elif widget_type is QDateEdit:
                                date = self.dlg_plan_psector.findChild(QDateEdit, str(column_name))
                                values += date.dateTime().toString('yyyy-MM-dd HH:mm:ss') + ", "
                            elif (widget_type is QComboBox) and (column_name == 'expl_id' or column_name == 'sector_id'
                                or column_name == 'result_id' or column_name == 'psector_type'):
                                combo = utils_giswater.getWidget(self.dlg_plan_psector, column_name)
                                elem = combo.itemData(combo.currentIndex())
                                value = str(elem[0])
                            else:
                                value = utils_giswater.getWidgetText(self.dlg_plan_psector, column_name)
                            if value is None or value == 'null':
                                sql += column_name + ", "
                                values += "null, "
                            else:
                                values += "'" + value + "', "
                                sql += column_name + ", "

                sql = sql[:len(sql) - 2] + ") "
                values = values[:len(values) - 2] + ")"
                sql += values

        if not self.update:
            sql += " RETURNING psector_id"
            new_psector_id = self.controller.execute_returning(sql, search_audit=False, log_sql=True)
            utils_giswater.setText(self.dlg_plan_psector, self.dlg_plan_psector.psector_id, str(new_psector_id[0]))

            if new_psector_id and self.plan_om == 'plan':
                sql = ("SELECT parameter FROM " + self.schema_name + ".config_param_user "
                       " WHERE parameter = 'psector_vdefault' AND cur_user = current_user")
                row = self.controller.get_row(sql)
                if row:
                    sql = ("UPDATE " + self.schema_name + ".config_param_user "
                           " SET value = '" + str(new_psector_id[0]) + "' "
                           " WHERE parameter = 'psector_vdefault'")
                else:
                    sql = ("INSERT INTO " + self.schema_name + ".config_param_user (parameter, value, cur_user) "
                           " VALUES ('psector_vdefault', '" + str(new_psector_id[0]) + "', current_user)")
                self.controller.execute_sql(sql, log_sql=True)
        else:
            self.controller.execute_sql(sql, log_sql=True)
            
        self.dlg_plan_psector.tabWidget.setTabEnabled(1, True)
        self.delete_psector_selector(self.plan_om+'_psector_selector')
        self.insert_psector_selector(self.plan_om+'_psector_selector', 'psector_id', utils_giswater.getWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.psector_id))

        if close_dlg:
            self.reload_states_selector()
            self.close_dialog(self.dlg_plan_psector)


    def price_selector(self, dialog, tableleft, tableright,  field_id_right):

        # fill QTableView all_rows
        tbl_all_rows = dialog.findChild(QTableView, "all_rows")
        tbl_all_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.fill_table(dialog, tbl_all_rows, tableleft)
        self.set_table_columns(dialog, tbl_all_rows, tableleft)

        # fill QTableView selected_rows
        tbl_selected_rows = dialog.findChild(QTableView, "selected_rows")
        tbl_selected_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
        expr = " psector_id = '" + str(utils_giswater.getWidgetText(dialog, 'psector_id')) + "'"
        # Refresh model with selected filter
        self.fill_table(dialog, tbl_selected_rows, tableright, True, QTableView.DoubleClicked, expr)
        self.set_table_columns(dialog, tbl_selected_rows, tableright)

        # Button select
        dialog.btn_select.clicked.connect(partial(self.rows_selector, dialog, tbl_all_rows, tbl_selected_rows, 'id', tableright, "price_id", 'id'))
        tbl_all_rows.doubleClicked.connect(partial(self.rows_selector, dialog, tbl_all_rows, tbl_selected_rows, 'id', tableright, "price_id", 'id'))

        # Button unselect
        dialog.btn_unselect.clicked.connect(partial(self.rows_unselector, dialog, tbl_selected_rows, tableright, field_id_right))


    def rows_selector(self, dialog, tbl_all_rows, tbl_selected_rows, id_ori, tableright, id_des, field_id):
        """
            :param qtable_left: QTableView origin
            :param qtable_right: QTableView destini
            :param id_ori: Refers to the id of the source table
            :param tablename_des: table destini
            :param id_des: Refers to the id of the target table, on which the query will be made
            :param query_right:
            :param query_left:
            :param field_id:
        """

        selected_list = tbl_all_rows.selectionModel().selectedRows()

        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        expl_id = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = tbl_all_rows.model().record(row).value(id_ori)
            expl_id.append(id_)

        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            values = ""
            psector_id = utils_giswater.getWidgetText(dialog, 'psector_id')
            values += "'" + str(psector_id) + "', "
            if tbl_all_rows.model().record(row).value('unit') != None:
                values += "'" + str(tbl_all_rows.model().record(row).value('unit')) + "', "
            else:
                values += 'null, '
            if tbl_all_rows.model().record(row).value('id') != None:
                values += "'" + str(tbl_all_rows.model().record(row).value('id')) + "', "
            else:
                values += 'null, '
            if tbl_all_rows.model().record(row).value('description') != None:
                values += "'" + str(tbl_all_rows.model().record(row).value('description')) + "', "
            else:
                values += 'null, '
            if tbl_all_rows.model().record(row).value('price') != None:
                values += "'" + str(tbl_all_rows.model().record(row).value('price')) + "', "
            else:
                values += 'null, '
            values = values[:len(values) - 2]
            # Check if expl_id already exists in expl_selector
            sql = ("SELECT DISTINCT(" + id_des + ")"
                   " FROM " + self.schema_name + "." + tableright + ""
                   " WHERE " + id_des + " = '" + str(expl_id[i]) + "'"
                   " AND psector_id = '"+psector_id+"'")

            row = self.controller.get_row(sql, log_info=True)
            if row is not None:
                # if exist - show warning
                message = "Id already selected"
                self.controller.show_info_box(message, "Info", parameter=str(expl_id[i]))
            else:
                sql = ("INSERT INTO " + self.schema_name + "." + tableright + ""
                       " (psector_id, unit, price_id, descript, price) "
                       " VALUES (" + values + ")")
                self.controller.execute_sql(sql)

        # Refresh
        expr = " psector_id = '" + str(utils_giswater.getWidgetText(dialog, 'psector_id')) + "'"
        # Refresh model with selected filter
        self.fill_table(dialog, tbl_selected_rows, tableright, True, QTableView.DoubleClicked, expr)
        self.set_table_columns(dialog, tbl_selected_rows, tableright)
        self.update_total(self.dlg_plan_psector, self.dlg_plan_psector.selected_rows)

    def rows_unselector(self, dialog, tbl_selected_rows, tableright, field_id_right):
        
        query = ("DELETE FROM " + self.schema_name + "." + tableright + ""
               " WHERE  " + tableright + "." + field_id_right + " = ")
        selected_list = tbl_selected_rows.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_warning(message)
            return
        expl_id = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = str(tbl_selected_rows.model().record(row).value(field_id_right))
            expl_id.append(id_)
        for i in range(0, len(expl_id)):
            sql = (query + "'" + str(expl_id[i]) + "'"
                   " AND psector_id = '" + utils_giswater.getWidgetText(dialog, 'psector_id') + "'")
            self.controller.execute_sql(sql)

        # Refresh
        expr = " psector_id = '" + str(utils_giswater.getWidgetText(dialog, 'psector_id')) + "'"
        # Refresh model with selected filter
        self.fill_table(dialog, tbl_selected_rows, tableright, True, QTableView.DoubleClicked, expr)
        self.set_table_columns(dialog, tbl_selected_rows, tableright)
        self.update_total(self.dlg_plan_psector, self.dlg_plan_psector.selected_rows)


    def query_like_widget_text(self, dialog, text_line, qtable, tableleft, tableright, field_id):
        """ Populate the QTableView by filtering through the QLineEdit"""
        
        query = utils_giswater.getWidgetText(dialog, text_line).lower()
        if query == 'null':
            query = ""
        sql = ("SELECT * FROM " + self.schema_name + "." + tableleft + " WHERE LOWER(" + field_id + ")"
               " LIKE '%"+query+"%' AND " + field_id + " NOT IN ("
               " SELECT price_id FROM " + self.schema_name + "." + tableright + ""
               " WHERE psector_id = '" + utils_giswater.getWidgetText(dialog, 'psector_id') + "')")
        self.fill_table_by_query(qtable, sql)


    def fill_table_by_query(self, qtable, query):
        """
        :param qtable: QTableView to show
        :param query: query to set model
        """

        model = QSqlQueryModel()
        model.setQuery(query)
        qtable.setModel(model)
        qtable.show()

        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())


    def fill_table(self, dialog, widget, table_name, hidde=False, set_edit_triggers=QTableView.NoEditTriggers, expr=None):
        """ Set a model with selected filter.
        Attach that model to selected table
        @setEditStrategy:
            0: OnFieldChange
            1: OnRowChange
            2: OnManualSubmit
        """

        # Set model
        model = QSqlTableModel()
        model.setTable(self.schema_name+"."+table_name)
        model.setEditStrategy(QSqlTableModel.OnFieldChange)
        model.setSort(0, 0)
        model.select()

        # When change some field we need to refresh Qtableview and filter by psector_id
        model.dataChanged.connect(partial(self.refresh_table, dialog, widget))
        model.dataChanged.connect(partial(self.update_total, dialog, widget))
        widget.setEditTriggers(set_edit_triggers)
        
        # Check for errors
        if model.lastError().isValid():
            self.controller.show_warning(model.lastError().text())
        # Attach model to table view
        if expr:
            widget.setModel(model)
            widget.model().setFilter(expr)
        else:
            widget.setModel(model)

        if hidde:
            self.refresh_table(dialog, widget)


    def refresh_table(self, dialog, widget):
        """ Refresh qTableView 'selected_rows' """
        
        widget.selectAll()
        selected_list = widget.selectionModel().selectedRows()
        widget.clearSelection()
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            if str(widget.model().record(row).value('psector_id')) != utils_giswater.getWidgetText(dialog, 'psector_id'):
                widget.hideRow(i)


    def document_insert(self):
        """ Insert a document related to the current visit """

        doc_id = self.doc_id.text()
        psector_id = self.psector_id.text()
        if not doc_id:
            message = "You need to insert doc_id"
            self.controller.show_warning(message)
            return
        if not psector_id:
            message = "You need to insert psector_id"
            self.controller.show_warning(message)
            return
        # Check if document already exist
        sql = ("SELECT doc_id"
               " FROM " + self.schema_name + ".doc_x_psector"
               " WHERE doc_id = '" + str(doc_id) + "' AND psector_id = '" + str(psector_id) + "'")
        row = self.controller.get_row(sql, commit=self.autocommit)
        if row:
            message = "Document already exist"
            self.controller.show_warning(message)
            return

        # Insert into new table
        sql = ("INSERT INTO " + self.schema_name + ".doc_x_psector (doc_id, psector_id)"
               " VALUES ('" + str(doc_id) + "', " + str(psector_id) + ")")
        status = self.controller.execute_sql(sql, commit=self.autocommit)
        if status:
            message = "Document inserted successfully"
            self.controller.show_info(message)

        self.dlg_plan_psector.tbl_document.model().select()


    def document_delete(self):
        """ Delete record from selected rows in tbl_document """

        # Get selected rows. 0 is the column of the pk 0 'id'
        selected_list = self.tbl_document.selectionModel().selectedRows(0)
        if len(selected_list) == 0:
            message = "Any record selected"
            self.controller.show_info_box(message)
            return

        selected_id = []
        for index in selected_list:
            doc_id = index.data()
            selected_id.append(str(doc_id))
        message = "Are you sure you want to delete these records?"
        title = "Delete records"
        answer = self.controller.ask_question(message, title, ','.join(selected_id))
        if answer:
            sql = ("DELETE FROM " + self.schema_name + ".doc_x_psector"
            " WHERE id IN ({})".format(','.join(selected_id)))
            status = self.controller.execute_sql(sql)
            if not status:
                message = "Error deleting data"
                self.controller.show_warning(message)
                return
            else:
                message = "Event deleted"
                self.controller.show_info(message)
                self.dlg_plan_psector.tbl_document.model().select()


    def manage_document(self, qtable):
        """ Access GUI to manage documents e.g Execute action of button 34 """
        
        psector_id = utils_giswater.getText(self.dlg_plan_psector, self.dlg_plan_psector.psector_id)
        manage_document = ManageDocument(self.iface, self.settings, self.controller, self.plugin_dir, single_tool=False)
        dlg_docman = manage_document.manage_document(tablename='psector', qtable=qtable, item_id=psector_id)
        dlg_docman.btn_accept.clicked.connect(partial(self.set_completer_object, dlg_docman, 'doc'))
        utils_giswater.remove_tab_by_tabName(dlg_docman.tabWidget, 'tab_rel')


    def document_open(self):
        """ Open selected document """

        # Get selected rows
        field_index = self.tbl_document.model().fieldIndex('path')
        selected_list = self.dlg_plan_psector.tbl_document.selectionModel().selectedRows(field_index)
        if not selected_list:
            message = "Any record selected"
            self.controller.show_info_box(message)
            return
        elif len(selected_list) > 1:
            message = "More then one document selected. Select just one document."
            self.controller.show_warning(message)
            return

        path = selected_list[0].data()
        # Check if file exist
        if os.path.exists(path):
            # Open the document
            if sys.platform == "win32":
                os.startfile(path)
            else:
                opener = "open" if sys.platform == "darwin" else "xdg-open"
                subprocess.call([opener, path])
        else:
            webbrowser.open(path)


    def set_completer(self):
        """ Set autocompleter """

        # Adding auto-completion to a QLineEdit - document_id
        self.completer = QCompleter()
        self.dlg_plan_psector.doc_id.setCompleter(self.completer)
        model = QStringListModel()

        sql = "SELECT DISTINCT(id) FROM " + self.schema_name + ".v_ui_document"
        rows = self.controller.get_rows(sql, commit=self.autocommit)
        values = []
        if rows:
            for row in rows:
                values.append(str(row[0]))

        model.setStringList(values)
        self.completer.setModel(model)

