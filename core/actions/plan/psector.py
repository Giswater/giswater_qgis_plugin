"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsLayoutExporter, QgsPointXY, QgsProject, QgsRectangle
from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtGui import QDoubleValidator, QIntValidator, QKeySequence
from qgis.PyQt.QtSql import QSqlQueryModel, QSqlTableModel
from qgis.PyQt.QtWidgets import QAbstractItemView, QAction, QCheckBox, QComboBox, QDateEdit, QLabel, \
    QLineEdit, QTableView

import csv
import json
import os
import operator
import sys
from collections import OrderedDict
from functools import partial

from lib import qt_tools
from ....ui_manager import Plan_psector, PsectorRapportUi
from ....actions.parent_manage import ParentManage
from ....actions.multiple_selection import MultipleSelection
from ..edit.document import GwDocument


class GwPsector(ParentManage):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control 'New Psector' of toolbar 'master' """
        ParentManage.__init__(self, iface, settings, controller, plugin_dir)


    def new_psector(self, psector_id=None, plan_om=None, is_api=False):
        """ Buttons 45 and 81: New psector """

        row = self.controller.get_config(parameter='admin_currency', columns='value::text', table='config_param_system')
        if row:
            self.sys_currency = json.loads(row[0], object_pairs_hook=OrderedDict)

        # Create the dialog and signals
        self.dlg_plan_psector = Plan_psector()
        self.load_settings(self.dlg_plan_psector)
        self.plan_om = str(plan_om)

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
        self.layers['connec'] = self.controller.get_group_layers('connec')
        if self.project_type.upper() == 'UD':
            self.layers['gully'] = self.controller.get_group_layers('gully')
        else:
            qt_tools.remove_tab_by_tabName(self.dlg_plan_psector.tab_feature, 'Gully')

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
        self.ext_code = self.dlg_plan_psector.findChild(QLineEdit, "ext_code")
        self.cmb_psector_type = self.dlg_plan_psector.findChild(QComboBox, "psector_type")
        self.cmb_expl_id = self.dlg_plan_psector.findChild(QComboBox, "expl_id")
        self.cmb_sector_id = self.dlg_plan_psector.findChild(QComboBox, "sector_id")
        self.cmb_result_id = self.dlg_plan_psector.findChild(QComboBox, "result_id")
        self.cmb_status = self.dlg_plan_psector.findChild(QComboBox, "status")
        self.dlg_plan_psector.lbl_result_id.setVisible(True)
        self.cmb_result_id.setVisible(True)

        scale = self.dlg_plan_psector.findChild(QLineEdit, "scale")
        scale.setValidator(QDoubleValidator())
        rotation = self.dlg_plan_psector.findChild(QLineEdit, "rotation")
        rotation.setValidator(QDoubleValidator())
        atlas_id = self.dlg_plan_psector.findChild(QLineEdit, "atlas_id")
        atlas_id.setValidator(QIntValidator())
        where = " WHERE typevalue = 'psector_type' "
        self.populate_combos(self.dlg_plan_psector.psector_type, 'idval', 'id', 'plan_typevalue', where)

        # Populate combo status
        sql = "SELECT id, idval FROM plan_typevalue WHERE typevalue = 'value_priority'"
        rows = self.controller.get_rows(sql)
        qt_tools.set_item_data(self.dlg_plan_psector.priority, rows, 1)

        # Set visible FALSE for cmb_sector
        self.populate_combos(self.cmb_sector_id, 'name', 'sector_id', 'sector')
        self.dlg_plan_psector.lbl_sector.setVisible(False)
        self.cmb_sector_id.setVisible(False)

        # Populate combo expl_id
        sql = ("SELECT expl_id, name from exploitation "
               " JOIN selector_expl USING (expl_id) "
               " WHERE exploitation.expl_id != 0 and cur_user = current_user")
        rows = self.controller.get_rows(sql)
        qt_tools.set_item_data(self.cmb_expl_id, rows, 1)

        # Populate combo status
        sql = "SELECT id, idval FROM plan_typevalue WHERE typevalue = 'psector_status'"
        rows = self.controller.get_rows(sql)
        qt_tools.set_item_data(self.cmb_status, rows, 1)

        if self.plan_om == 'om':
            self.populate_result_id(self.dlg_plan_psector.result_id, 'om_result_cat')
            qt_tools.remove_tab_by_tabName(self.dlg_plan_psector.tabWidget, 'tab_document')
            self.dlg_plan_psector.chk_enable_all.setVisible(False)
        elif self.plan_om == 'plan':
            self.dlg_plan_psector.lbl_result_id.setVisible(False)
            self.cmb_result_id.setVisible(False)
            self.dlg_plan_psector.chk_enable_all.setEnabled(False)

        # tab Bugdet
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
        self.qtbl_connec = self.dlg_plan_psector.findChild(QTableView, "tbl_psector_x_connec")
        self.qtbl_connec.setSelectionBehavior(QAbstractItemView.SelectRows)
        if self.project_type.upper() == 'UD':
            self.qtbl_gully = self.dlg_plan_psector.findChild(QTableView, "tbl_psector_x_gully")
            self.qtbl_gully.setSelectionBehavior(QAbstractItemView.SelectRows)
        all_rows = self.dlg_plan_psector.findChild(QTableView, "all_rows")
        all_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
        selected_rows = self.dlg_plan_psector.findChild(QTableView, "selected_rows")
        selected_rows.setSelectionBehavior(QAbstractItemView.SelectRows)

        # if a row is selected from mg_psector_mangement(button 46 or button 81)
        # Si psector_id contiene "1" o "0" python lo toma como boolean, si es True, quiere decir que no contiene valor
        # y por lo tanto es uno nuevo. Convertimos ese valor en 0 ya que ningun id va a ser 0 de esta manera si psector_id
        # tiene un valor distinto de 0, es que el sector ya existe y queremos hacer un update.
        if isinstance(psector_id, bool):
            psector_id = 0
        self.delete_psector_selector('selector_plan_psector')

        # tab 'Document'
        self.doc_id = self.dlg_plan_psector.findChild(QLineEdit, "doc_id")
        self.tbl_document = self.dlg_plan_psector.findChild(QTableView, "tbl_document")

        if psector_id is not None:

            self.enable_tabs(True)
            self.enable_buttons(True)
            self.dlg_plan_psector.name.setEnabled(True)
            self.dlg_plan_psector.chk_enable_all.setDisabled(False)
            sql = (f"SELECT enable_all "
                   f"FROM plan_psector "
                   f"WHERE psector_id = '{psector_id}'")
            row = self.controller.get_row(sql)
            if row:
                self.dlg_plan_psector.chk_enable_all.setChecked(row[0])
            self.fill_table(self.dlg_plan_psector, self.qtbl_arc, "plan_psector_x_arc",
                set_edit_triggers=QTableView.DoubleClicked)
            self.set_table_columns(self.dlg_plan_psector, self.qtbl_arc, "plan_psector_x_arc")
            self.fill_table(self.dlg_plan_psector, self.qtbl_node, "plan_psector_x_node",
                set_edit_triggers=QTableView.DoubleClicked)
            self.set_table_columns(self.dlg_plan_psector, self.qtbl_node, "plan_psector_x_node")
            self.fill_table(self.dlg_plan_psector, self.qtbl_connec, "plan_psector_x_connec",
                set_edit_triggers=QTableView.DoubleClicked)
            self.set_table_columns(self.dlg_plan_psector, self.qtbl_connec, "plan_psector_x_connec")
            if self.project_type.upper() == 'UD':
                self.fill_table(self.dlg_plan_psector, self.qtbl_gully, "plan_psector_x_gully",
                                set_edit_triggers=QTableView.DoubleClicked)
                self.set_table_columns(self.dlg_plan_psector, self.qtbl_gully, "plan_psector_x_gully")
            sql = (f"SELECT psector_id, name, psector_type, expl_id, sector_id, priority, descript, text1, text2, "
                   f"observ, atlas_id, scale, rotation, active, ext_code, status "
                   f"FROM plan_psector "
                   f"WHERE psector_id = {psector_id}")
            row = self.controller.get_row(sql, log_sql=True)

            if not row:
                return

            self.dlg_plan_psector.setWindowTitle(f"Plan psector - {row['name']}")
            self.psector_id.setText(str(row['psector_id']))
            if str(row['ext_code']) != 'None':
                self.ext_code.setText(str(row['ext_code']))
            sql = (f"SELECT id, idval FROM plan_typevalue WHERE typevalue = 'psector_type' AND "
                   f"id = '{row['psector_type']}'")
            result = self.controller.get_row(sql)
            qt_tools.set_combo_itemData(self.cmb_psector_type, str(result['idval']), 1)
            sql = (f"SELECT name FROM exploitation "
                   f"WHERE expl_id = {row['expl_id']}")
            result = self.controller.get_row(sql)
            qt_tools.set_combo_itemData(self.cmb_expl_id, str(result['name']), 1)

            # Check if expl_id already exists in expl_selector
            sql = ("SELECT DISTINCT(expl_id, cur_user)"
                   " FROM selector_expl"
                   f" WHERE expl_id = '{row['expl_id']}' AND cur_user = current_user")
            exist = self.controller.get_row(sql)
            if exist is None:
                sql = ("INSERT INTO selector_expl (expl_id, cur_user) "
                       f" VALUES ({str(row['expl_id'])}, current_user)"
                       f" ON CONFLICT DO NOTHING;")
                self.controller.execute_sql(sql)
                msg = "Your exploitation selector has been updated"
                self.controller.show_warning(msg, 1)

            sql = (f"SELECT name FROM sector "
                   f"WHERE sector_id = {row['sector_id']}")
            result = self.controller.get_row(sql)
            qt_tools.set_combo_itemData(self.cmb_sector_id, str(result['name']), 1)
            qt_tools.set_combo_itemData(self.cmb_status, str(row['status']), 0)

            qt_tools.setChecked(self.dlg_plan_psector, "active", row['active'])
            qt_tools.fillWidget(self.dlg_plan_psector, "name", row)
            qt_tools.fillWidget(self.dlg_plan_psector, "descript", row)
            qt_tools.set_combo_itemData(self.dlg_plan_psector.priority, str(row["priority"]), 1)
            qt_tools.fillWidget(self.dlg_plan_psector, "text1", row)
            qt_tools.fillWidget(self.dlg_plan_psector, "text2", row)
            qt_tools.fillWidget(self.dlg_plan_psector, "observ", row)
            qt_tools.fillWidget(self.dlg_plan_psector, "atlas_id", row)
            qt_tools.fillWidget(self.dlg_plan_psector, "scale", row)
            qt_tools.fillWidget(self.dlg_plan_psector, "rotation", row)

            # Fill tables tbl_arc_plan, tbl_node_plan, tbl_v_plan/om_other_x_psector with selected filter
            expr = " psector_id = " + str(psector_id)
            self.qtbl_arc.model().setFilter(expr)
            self.qtbl_arc.model().select()
            self.qtbl_arc.clicked.connect(
                partial(self.hilight_feature_by_id, self.qtbl_arc, "v_edit_arc", "arc_id", 5))

            expr = " psector_id = " + str(psector_id)
            self.qtbl_node.model().setFilter(expr)
            self.qtbl_node.model().select()
            self.qtbl_node.clicked.connect(
                partial(self.hilight_feature_by_id, self.qtbl_node, "v_edit_node", "node_id", 1))

            expr = " psector_id = " + str(psector_id)
            self.qtbl_connec.model().setFilter(expr)
            self.qtbl_connec.model().select()
            self.qtbl_connec.clicked.connect(
                partial(self.hilight_feature_by_id, self.qtbl_connec, "v_edit_connec", "connec_id", 1))

            if self.project_type.upper() == 'UD':
                expr = " psector_id = " + str(psector_id)
                self.qtbl_gully.model().setFilter(expr)
                self.qtbl_gully.model().select()
                self.qtbl_gully.clicked.connect(
                    partial(self.hilight_feature_by_id, self.qtbl_gully, "v_edit_gully", "gully_id", 1))

            self.populate_budget(self.dlg_plan_psector, psector_id)
            self.update = True
            psector_id_aux = qt_tools.getWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.psector_id)
            if psector_id_aux != 'null':
                sql = (f"DELETE FROM selector_plan_psector "
                       f"WHERE cur_user = current_user")
                self.controller.execute_sql(sql)
                self.insert_psector_selector('selector_plan_psector', 'psector_id', psector_id_aux)
            if self.plan_om == 'plan':
                sql = (f"DELETE FROM selector_psector "
                       f"WHERE cur_user = current_user AND psector_id = '{psector_id_aux}'")
                self.controller.execute_sql(sql)
                self.insert_psector_selector('selector_psector', 'psector_id', psector_id_aux)
            layer = None
            if not is_api:
                layername = f'v_edit_plan_psector'
                layer = self.controller.get_layer_by_tablename(layername, show_warning=False)

            if layer:

                expr_filter = f"psector_id = '{psector_id}'"
                (is_valid, expr) = self.check_expression(expr_filter)  # @UnusedVariable
                if not is_valid:
                    return

                self.select_features_by_expr(layer, expr)

                # Get canvas extend in order to create a QgsRectangle
                ext = self.canvas.extent()
                startPoint = QgsPointXY(ext.xMinimum(), ext.yMaximum())
                endPoint = QgsPointXY(ext.xMaximum(), ext.yMinimum())
                canvas_rec = QgsRectangle(startPoint, endPoint)
                canvas_width = ext.xMaximum() - ext.xMinimum()
                canvas_height = ext.yMaximum() - ext.yMinimum()
                # Get boundingBox(QgsRectangle) from selected feature
                try:
                    feature = layer.selectedFeatures()[0]
                except IndexError:
                    feature = layer.selectedFeatures()

                if feature != []:
                    if feature.geometry().get() is not None:
                        psector_rec = feature.geometry().boundingBox()
                        # Do zoom when QgsRectangles don't intersect
                        if not canvas_rec.intersects(psector_rec):
                            self.zoom_to_selected_features(layer)
                        if psector_rec.width() < (canvas_width * 10) / 100 or psector_rec.height() < (canvas_height * 10) / 100:
                            self.zoom_to_selected_features(layer)
                        layer.removeSelection()

            filter_ = "psector_id = '" + str(psector_id) + "'"
            self.fill_table_object(self.tbl_document, self.schema_name + ".v_ui_doc_x_psector", filter_)
            self.tbl_document.doubleClicked.connect(partial(self.document_open, self.tbl_document))

        else:

            # Set psector_status vdefault
            sql = "SELECT id, idval FROM plan_typevalue WHERE typevalue = 'psector_status' and id = '2'"
            result = self.controller.get_row(sql)
            qt_tools.set_combo_itemData(self.cmb_status, str(result[1]), 1)

        sql = "SELECT state_id FROM selector_state WHERE cur_user = current_user"
        rows = self.controller.get_rows(sql)
        self.all_states = rows
        self.delete_psector_selector('selector_state')
        self.insert_psector_selector('selector_state', 'state_id', '1')

        # Set signals
        self.dlg_plan_psector.btn_accept.clicked.connect(partial(self.insert_or_update_new_psector,
                                                                 'v_edit_plan_psector', True))
        self.dlg_plan_psector.tabWidget.currentChanged.connect(partial(self.check_tab_position))
        self.dlg_plan_psector.btn_cancel.clicked.connect(partial(self.close_psector, cur_active_layer))
        self.dlg_plan_psector.psector_type.currentIndexChanged.connect(partial(self.populate_result_id,
            self.dlg_plan_psector.result_id, 'plan_result_cat'))
        self.dlg_plan_psector.rejected.connect(partial(self.close_psector, cur_active_layer))
        self.dlg_plan_psector.chk_enable_all.stateChanged.connect(partial(self.enable_all))

        self.lbl_descript = self.dlg_plan_psector.findChild(QLabel, "lbl_descript")
        self.dlg_plan_psector.all_rows.clicked.connect(partial(self.show_description))
        self.dlg_plan_psector.btn_select.clicked.connect(partial(self.update_total,
            self.dlg_plan_psector, self.dlg_plan_psector.selected_rows))
        self.dlg_plan_psector.btn_unselect.clicked.connect(partial(self.update_total,
            self.dlg_plan_psector, self.dlg_plan_psector.selected_rows))
        self.dlg_plan_psector.btn_insert.clicked.connect(partial(self.insert_feature,
            self.dlg_plan_psector, table_object, True))
        self.dlg_plan_psector.btn_delete.clicked.connect(partial(self.delete_records,
            self.dlg_plan_psector, table_object, True))
        self.dlg_plan_psector.btn_delete.setShortcut(QKeySequence(Qt.Key_Delete))
        self.dlg_plan_psector.btn_snapping.clicked.connect(partial(self.selection_init,
            self.dlg_plan_psector, table_object, True))

        self.dlg_plan_psector.btn_rapports.clicked.connect(partial(self.open_dlg_rapports))
        self.dlg_plan_psector.tab_feature.currentChanged.connect(partial(self.tab_feature_changed,
            self.dlg_plan_psector, table_object, excluded_layers=["v_edit_element"]))
        self.dlg_plan_psector.name.textChanged.connect(partial(self.enable_relation_tab, 'plan_psector'))
        viewname = 'v_edit_plan_psector_x_other'
        self.dlg_plan_psector.txt_name.textChanged.connect(partial(self.query_like_widget_text, self.dlg_plan_psector,
            self.dlg_plan_psector.txt_name, self.dlg_plan_psector.all_rows, 'v_price_compost', viewname, "id"))

        self.dlg_plan_psector.gexpenses.returnPressed.connect(partial(self.calulate_percents,
            'plan_psector', 'gexpenses'))
        self.dlg_plan_psector.vat.returnPressed.connect(partial(self.calulate_percents,
            'plan_psector', 'vat'))
        self.dlg_plan_psector.other.returnPressed.connect(partial(self.calulate_percents,
            'plan_psector', 'other'))

        self.dlg_plan_psector.btn_doc_insert.clicked.connect(self.document_insert)
        self.dlg_plan_psector.btn_doc_delete.clicked.connect(
            partial(self.document_delete, self.tbl_document, 'doc_x_psector'))
        self.dlg_plan_psector.btn_doc_new.clicked.connect(partial(self.manage_document, self.tbl_document))
        self.dlg_plan_psector.btn_open_doc.clicked.connect(partial(self.document_open, self.tbl_document))
        self.cmb_status.currentIndexChanged.connect(partial(self.show_status_warning))

        # Create list for completer QLineEdit
        sql = "SELECT DISTINCT(id) FROM v_ui_document ORDER BY id"
        list_items = self.make_list_for_completer(sql)
        self.set_completer_lineedit(self.dlg_plan_psector.doc_id, list_items)
        
        if psector_id is not None:
            sql = (f"SELECT other, gexpenses, vat "
                   f"FROM plan_psector "
                   f"WHERE psector_id = '{psector_id}'")
            row = self.controller.get_row(sql)

            other = 0
            gexpenses = 0
            vat = 0
            if row:
                other = float(row[0]) if row[0] is not None else 0
                gexpenses = float(row[1]) if row[1] is not None else 0
                vat = float(row[2]) if row[2] is not None else 0
    
            qt_tools.setWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.other, other)
            qt_tools.setWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.gexpenses, gexpenses)
            qt_tools.setWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.vat, vat)
    
            qt_tools.setWidgetText(self.dlg_plan_psector, 'cur_total_node', self.sys_currency['symbol'])
            qt_tools.setWidgetText(self.dlg_plan_psector, 'cur_total_arc', self.sys_currency['symbol'])
            qt_tools.setWidgetText(self.dlg_plan_psector, 'cur_total_other', self.sys_currency['symbol'])
            qt_tools.setWidgetText(self.dlg_plan_psector, 'cur_pem', self.sys_currency['symbol'])
            qt_tools.setWidgetText(self.dlg_plan_psector, 'cur_pec_pem', self.sys_currency['symbol'])
            qt_tools.setWidgetText(self.dlg_plan_psector, 'cur_pec', self.sys_currency['symbol'])
            qt_tools.setWidgetText(self.dlg_plan_psector, 'cur_pecvat_pem', self.sys_currency['symbol'])
            qt_tools.setWidgetText(self.dlg_plan_psector, 'cur_pec_vat', self.sys_currency['symbol'])
            qt_tools.setWidgetText(self.dlg_plan_psector, 'cur_pca_pecvat', self.sys_currency['symbol'])
            qt_tools.setWidgetText(self.dlg_plan_psector, 'cur_pca', self.sys_currency['symbol'])

        # Adding auto-completion to a QLineEdit for default feature
        self.geom_type = "arc"
        viewname = "v_edit_" + self.geom_type
        self.set_completer_feature_id(self.dlg_plan_psector.feature_id, self.geom_type, viewname)

        # Set default tab 'arc'
        self.dlg_plan_psector.tab_feature.setCurrentIndex(0)
        self.geom_type = "arc"
        self.tab_feature_changed(self.dlg_plan_psector, table_object, excluded_layers=["v_edit_element"])

        widget_to_ignore = ('btn_accept', 'btn_cancel', 'btn_rapports', 'btn_open_doc')
        restriction = ('role_basic', 'role_om', 'role_epa', 'role_om')
        self.set_restriction(self.dlg_plan_psector, widget_to_ignore, restriction)

        # Open dialog
        self.open_dialog(self.dlg_plan_psector, dlg_name='plan_psector', maximize_button=False)


    def enable_all(self):

        value = qt_tools.isChecked(self.dlg_plan_psector, "chk_enable_all")
        psector_id = qt_tools.getWidgetText(self.dlg_plan_psector, "psector_id")
        sql = f"SELECT gw_fct_plan_psector_enableall({value}, '{psector_id}')"
        self.controller.execute_sql(sql)
        self.reload_qtable(self.dlg_plan_psector, 'arc')
        self.reload_qtable(self.dlg_plan_psector, 'node')
        self.reload_qtable(self.dlg_plan_psector, 'connec')
        if self.project_type.upper() == 'UD':
            self.reload_qtable(self.dlg_plan_psector, 'gully')

        sql = (f"UPDATE plan_psector "
               f"SET enable_all = '{value}' "
               f"WHERE psector_id = '{psector_id}'")
        self.controller.execute_sql(sql, log_sql=True)
        self.refresh_map_canvas()


    def update_total(self, dialog, qtable):
        """ Show description of product plan/om _psector as label """

        try:
            model = qtable.model()
            if model is None:
                return

            total = 0
            psector_id = qt_tools.getWidgetText(dialog, 'psector_id')
            for x in range(0, model.rowCount()):
                if int(qtable.model().record(x).value('psector_id')) == int(psector_id):
                    if str(qtable.model().record(x).value('total_budget')) != 'NULL':
                        total += float(qtable.model().record(x).value('total_budget'))
            qt_tools.setText(dialog, 'lbl_total', str(total))
        except:
            pass


    def open_dlg_rapports(self):

        default_file_name = qt_tools.getWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.name)

        self.dlg_psector_rapport = PsectorRapportUi()
        self.load_settings(self.dlg_psector_rapport)

        qt_tools.setWidgetText(self.dlg_psector_rapport, 'txt_composer_path', default_file_name + " comp.pdf")
        qt_tools.setWidgetText(self.dlg_psector_rapport, 'txt_csv_detail_path', default_file_name + " detail.csv")
        qt_tools.setWidgetText(self.dlg_psector_rapport, 'txt_csv_path', default_file_name + ".csv")

        self.dlg_psector_rapport.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_psector_rapport))
        self.dlg_psector_rapport.btn_ok.clicked.connect(partial(self.generate_rapports))
        self.dlg_psector_rapport.btn_path.clicked.connect(partial(self.get_folder_dialog, self.dlg_psector_rapport,
            self.dlg_psector_rapport.txt_path))

        qt_tools.setWidgetText(self.dlg_psector_rapport, self.dlg_psector_rapport.txt_path,
                               self.controller.plugin_settings_value('psector_rapport_path'))
        qt_tools.setChecked(self.dlg_psector_rapport, self.dlg_psector_rapport.chk_composer,
                            bool(self.controller.plugin_settings_value('psector_rapport_chk_composer')))
        qt_tools.setChecked(self.dlg_psector_rapport, self.dlg_psector_rapport.chk_csv_detail,
                            self.controller.plugin_settings_value('psector_rapport_chk_csv_detail'))
        qt_tools.setChecked(self.dlg_psector_rapport, self.dlg_psector_rapport.chk_csv,
                            self.controller.plugin_settings_value('psector_rapport_chk_csv'))
        if qt_tools.getWidgetText(self.dlg_psector_rapport, self.dlg_psector_rapport.txt_path) == 'null':
            if 'nt' in sys.builtin_module_names:
                plugin_dir = os.path.expanduser("~\Documents")
            else:
                plugin_dir = os.path.expanduser("~")
            qt_tools.setWidgetText(self.dlg_psector_rapport, self.dlg_psector_rapport.txt_path, plugin_dir)
        self.populate_cmb_templates()

        # Open dialog
        self.open_dialog(self.dlg_psector_rapport, dlg_name='psector_rapport', maximize_button=False)


    def populate_cmb_templates(self):

        index = 0
        records = []
        layout_manager = QgsProject.instance().layoutManager()
        layouts = layout_manager.layouts()  # QgsPrintLayout
        for layout in layouts:
            elem = [index, layout.name()]
            records.append(elem)
            index = index + 1

        if records in ([], None):
            # If no composer configured, disable composer pdf file widgets
            self.dlg_psector_rapport.chk_composer.setEnabled(False)
            self.dlg_psector_rapport.chk_composer.setChecked(False)
            self.dlg_psector_rapport.cmb_templates.setEnabled(False)
            self.dlg_psector_rapport.txt_composer_path.setEnabled(False)
            self.dlg_psector_rapport.lbl_composer_disabled.setText('No composers defined.')
            self.dlg_psector_rapport.lbl_composer_disabled.setStyleSheet('color: red')
            return
        else:
            # If composer configured, enable composer pdf file widgets
            self.dlg_psector_rapport.chk_composer.setEnabled(True)
            self.dlg_psector_rapport.cmb_templates.setEnabled(True)
            self.dlg_psector_rapport.txt_composer_path.setEnabled(True)
            self.dlg_psector_rapport.lbl_composer_disabled.setText('')
            qt_tools.set_item_data(self.dlg_psector_rapport.cmb_templates, records, 1)

        row = self.controller.get_config(f'composer_plan_vdefault')
        if row:
            qt_tools.set_combo_itemData(self.dlg_psector_rapport.cmb_templates, row[0], 1)


    def generate_rapports(self):
        
        self.controller.plugin_settings_set_value("psector_rapport_path",
            qt_tools.getWidgetText(self.dlg_psector_rapport, 'txt_path'))
        self.controller.plugin_settings_set_value("psector_rapport_chk_composer",
            qt_tools.isChecked(self.dlg_psector_rapport, 'chk_composer'))
        self.controller.plugin_settings_set_value("psector_rapport_chk_csv_detail",
            qt_tools.isChecked(self.dlg_psector_rapport, 'chk_csv_detail'))
        self.controller.plugin_settings_set_value("psector_rapport_chk_csv",
            qt_tools.isChecked(self.dlg_psector_rapport, 'chk_csv'))
        
        folder_path = qt_tools.getWidgetText(self.dlg_psector_rapport, self.dlg_psector_rapport.txt_path)
        if folder_path is None or folder_path == 'null' or not os.path.exists(folder_path):
            self.get_folder_dialog(self.dlg_psector_rapport.txt_path)
            folder_path = qt_tools.getWidgetText(self.dlg_psector_rapport, self.dlg_psector_rapport.txt_path)

        # Generate Composer
        if qt_tools.isChecked(self.dlg_psector_rapport, self.dlg_psector_rapport.chk_composer):
            file_name = qt_tools.getWidgetText(self.dlg_psector_rapport, 'txt_composer_path')
            if file_name is None or file_name == 'null':
                message = "File name is required"
                self.controller.show_warning(message)
            if file_name.find('.pdf') is False:
                file_name += '.pdf'
            path = folder_path + '/' + file_name
            self.generate_composer(path)

        # Generate csv detail
        if qt_tools.isChecked(self.dlg_psector_rapport, self.dlg_psector_rapport.chk_csv_detail):
            file_name = qt_tools.getWidgetText(self.dlg_psector_rapport, 'txt_csv_path')
            viewname = f"v_plan_current_psector_budget_detail"
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
        if qt_tools.isChecked(self.dlg_psector_rapport, self.dlg_psector_rapport.chk_csv):
            file_name = qt_tools.getWidgetText(self.dlg_psector_rapport, 'txt_csv_detail_path')
            viewname = f"v_plan_current_psector_budget"
            if file_name is None or file_name == 'null':
                message = "Price list csv file name is required"
                self.controller.show_warning(message)
            if file_name.find('.csv') is False:
                file_name += '.csv'
            path = folder_path + '/' + file_name
            self.generate_csv(path, viewname)

        self.close_dialog(self.dlg_psector_rapport)


    def generate_composer(self, path):
        # Get layout manager object
        layout_manager = QgsProject.instance().layoutManager()

        # Get our layout
        layout_name = qt_tools.getWidgetText(self.dlg_psector_rapport, self.dlg_psector_rapport.cmb_templates)
        layout = layout_manager.layoutByName(layout_name)

        # Since qgis 3.4 cant do .setAtlasMode(QgsComposition.PreviewAtlas)
        # then we need to force the opening of the layout designer, trigger the mActionAtlasPreview action and
        # close the layout designer again (finally sentence)
        designer = self.iface.openLayoutDesigner(layout)
        layout_view = designer.view()
        designer_window = layout_view.window()
        action = designer_window.findChild(QAction, 'mActionAtlasPreview')
        action.trigger()

        # Export to PDF file
        if layout:
            try:
                exporter = QgsLayoutExporter(layout)
                exporter.exportToPdf(path, QgsLayoutExporter.PdfExportSettings())
                if os.path.exists(path):
                    message = "Document PDF created in"
                    self.controller.show_info(message, parameter=path)
                    os.startfile(path)
                else:
                    message = "Cannot create file, check if its open"
                    self.controller.show_warning(message, parameter=path)
            except Exception as e:
                self.controller.log_warning(str(e))
                msg = "Cannot create file, check if selected composer is the correct composer"
                self.controller.show_warning(msg, parameter=path)
            finally:
                designer_window.close()
        else:
            self.controller.show_warning("Layout not found", parameter=layout_name)


    def generate_csv(self, path, viewname):

        # Get columns name in order of the table
        sql = (f"SELECT column_name FROM information_schema.columns"
               f" WHERE table_name = '{viewname}'"
               f" AND table_schema = '" + self.schema_name.replace('"', '') + "'"
               f" ORDER BY ordinal_position")
        rows = self.controller.get_rows(sql)
        columns = []

        if not rows or rows is None or rows == '':
            message = "CSV not generated. Check fields from table or view"
            self.controller.show_warning(message, parameter=viewname)
            return
        for i in range(0, len(rows)):
            column_name = rows[i]
            columns.append(str(column_name[0]))

        sql = (f"SELECT * FROM {viewname}"
               f" WHERE psector_id = '{qt_tools.getWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.psector_id)}'")
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

        sql = (f"SELECT DISTINCT(column_name) FROM information_schema.columns"
               f" WHERE table_name = 'v_plan_current_psector'")
        rows = self.controller.get_rows(sql)
        columns = []
        for i in range(0, len(rows)):
            column_name = rows[i]
            columns.append(str(column_name[0]))

        sql = (f"SELECT total_arc, total_node, total_other, pem, pec, pec_vat, gexpenses, vat, other, pca"
               f" FROM v_plan_current_psector"
               f" WHERE psector_id = '{psector_id}'")
        row = self.controller.get_row(sql)
        if row:
            for column_name in columns:
                if column_name in row:
                    if row[column_name] is not None:
                        qt_tools.setText(dialog, column_name, f"{row[column_name]:.02f}")
                    else:
                        qt_tools.setText(dialog, column_name, f"{0:.02f}")

        self.calc_pec_pem(dialog)
        self.calc_pecvat_pec(dialog)
        self.calc_pca_pecvat(dialog)


    def calc_pec_pem(self, dialog):
        
        if qt_tools.getWidgetText(dialog, 'pec') not in('null', None):
            pec = float(qt_tools.getWidgetText(dialog, 'pec'))
        else:
            pec = 0

        if qt_tools.getWidgetText(dialog, 'pem') not in('null', None):
            pem = float(qt_tools.getWidgetText(dialog, 'pem'))
        else:
            pem = 0

        res = f"{round(pec - pem, 2):.02f}"
        qt_tools.setWidgetText(dialog, 'pec_pem', res)


    def calc_pecvat_pec(self, dialog):

        if qt_tools.getWidgetText(dialog, 'pec_vat') not in('null', None):
            pec_vat = float(qt_tools.getWidgetText(dialog, 'pec_vat'))
        else:
            pec_vat = 0

        if qt_tools.getWidgetText(dialog, 'pec') not in('null', None):
            pec = float(qt_tools.getWidgetText(dialog, 'pec'))
        else:
            pec = 0
        res = f"{round(pec_vat - pec, 2):.02f}"
        qt_tools.setWidgetText(dialog, 'pecvat_pem', res)


    def calc_pca_pecvat(self, dialog):
        
        if qt_tools.getWidgetText(dialog, 'pca') not in('null', None):
            pca = float(qt_tools.getWidgetText(dialog, 'pca'))
        else:
            pca = 0

        if qt_tools.getWidgetText(dialog, 'pec_vat') not in('null', None):
            pec_vat = float(qt_tools.getWidgetText(dialog, 'pec_vat'))
        else:
            pec_vat = 0
        res = f"{round(pca - pec_vat, 2):.02f}"
        qt_tools.setWidgetText(dialog, 'pca_pecvat', res)


    def calulate_percents(self, tablename, psector_id, field):
        psector_id = qt_tools.getWidgetText(self.dlg_plan_psector, "psector_id")

        sql = ("UPDATE " + tablename + " "
               " SET " + field + " = '" + qt_tools.getText(self.dlg_plan_psector, field) + "'"
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
        qt_tools.setText(self.dlg_plan_psector, self.lbl_descript, des)


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
        widget_to_ignore = ('btn_accept', 'btn_cancel', 'btn_rapports', 'btn_open_doc')
        restriction = ('role_basic', 'role_om', 'role_epa', 'role_om')
        self.set_restriction(self.dlg_plan_psector, widget_to_ignore, restriction)

    def selection_init(self, dialog, table_object, query=True):
        """ Set canvas map tool to an instance of class 'MultipleSelection' """

        multiple_selection = MultipleSelection(self.iface, self.controller, self.layers[self.geom_type],
                                               manage_new_psector=self, table_object=table_object)
        self.disconnect_signal_selection_changed()
        self.canvas.setMapTool(multiple_selection)
        self.connect_signal_selection_changed(dialog, table_object, query)
        cursor = self.get_cursor_multiple_selection()
        self.canvas.setCursor(cursor)


    def connect_signal_selection_changed(self, dialog, table_object, query=True):
        """ Connect signal selectionChanged """

        try:
            self.canvas.selectionChanged.connect(
                partial(self.selection_changed, dialog, table_object, self.geom_type, query))
        except Exception:
            pass


    def enable_relation_tab(self, tablename):

        sql = (f"SELECT name FROM {tablename} "
               f" WHERE LOWER(name) = '{qt_tools.getWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.name)}'")
        rows = self.controller.get_rows(sql)
        if not rows:
            if self.dlg_plan_psector.name.text() != '':
                self.enable_tabs(True)
            else:
                self.enable_tabs(False)
        else:
            self.enable_tabs(False)


    def delete_psector_selector(self, tablename):

        sql = (f"DELETE FROM {tablename}"
               f" WHERE cur_user = current_user;")
        self.controller.execute_sql(sql)


    def insert_psector_selector(self, tablename, field, value):

        sql = (f"INSERT INTO {tablename} ({field}, cur_user) "
               f"VALUES ('{value}', current_user);")
        self.controller.execute_sql(sql)


    def check_tab_position(self):

        self.dlg_plan_psector.name.setEnabled(False)
        self.insert_or_update_new_psector(tablename=f'v_edit_plan_psector', close_dlg=False)
        self.update = True
        if self.dlg_plan_psector.tabWidget.currentIndex() == 2:
            tableleft = "v_price_compost"
            tableright = f"v_edit_plan_psector_x_other"
            field_id_right = "price_id"
            self.price_selector(self.dlg_plan_psector, tableleft, tableright, field_id_right)
            self.update_total(self.dlg_plan_psector, self.dlg_plan_psector.selected_rows)
        elif self.dlg_plan_psector.tabWidget.currentIndex() == 3:
            self.populate_budget(self.dlg_plan_psector, qt_tools.getWidgetText(self.dlg_plan_psector, 'psector_id'))
        elif self.dlg_plan_psector.tabWidget.currentIndex() == 4:
            psector_id = qt_tools.getWidgetText(self.dlg_plan_psector, 'psector_id')
            expr = f"psector_id = '{psector_id}'"
            self.fill_table_object(self.tbl_document, self.schema_name + ".v_ui_doc_x_psector", expr_filter=expr)

        sql = (f"SELECT other, gexpenses, vat"
               f" FROM plan_psector "
               f" WHERE psector_id = '{qt_tools.getWidgetText(self.dlg_plan_psector, 'psector_id')}'")
        row = self.controller.get_row(sql)
        if row:
            qt_tools.setWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.other, row[0])
            qt_tools.setWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.gexpenses, row[1])
            qt_tools.setWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.vat, row[2])

        self.dlg_plan_psector.chk_enable_all.setEnabled(True)

        widget_to_ignore = ('btn_accept', 'btn_cancel', 'btn_rapports', 'btn_open_doc')
        restriction = ('role_basic', 'role_om', 'role_epa', 'role_om')
        self.set_restriction(self.dlg_plan_psector, widget_to_ignore, restriction)


    def populate_result_id(self, combo, table_name):

        index = self.dlg_plan_psector.psector_type.itemData(self.dlg_plan_psector.psector_type.currentIndex())
        sql = (f"SELECT result_type, name FROM {table_name}"
               f" WHERE result_type = {index[0]} ORDER BY name DESC")
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


    def populate_combos(self, combo, field_name, field_id, table_name, where=None):

        sql = f"SELECT DISTINCT({field_id}), {field_name} FROM {table_name} "
        if where:
            sql += where
        sql += f" ORDER BY {field_name}"
        rows = self.controller.get_rows(sql)
        if not rows:
            return

        combo.blockSignals(True)
        combo.clear()

        records_sorted = sorted(rows, key=operator.itemgetter(1))
        for record in records_sorted:
            combo.addItem(record[1], record)
        combo.blockSignals(False)


    def reload_states_selector(self):

        self.delete_psector_selector('selector_state')
        try:
            for x in range(0, len(self.all_states)):
                sql = (f"INSERT INTO selector_state (state_id, cur_user)"
                       f" VALUES ('{self.all_states[x][0]}', current_user)")
                self.controller.execute_sql(sql)
        except TypeError:
            # Control if self.all_states is None (object of type 'NoneType' has no len())
            pass


    def close_psector(self, cur_active_layer=None):
        """ Close dialog and disconnect snapping """

        self.resetRubberbands()
        self.reload_states_selector()
        if cur_active_layer:
            self.iface.setActiveLayer(cur_active_layer)
        self.remove_selection(True)
        self.reset_model_psector("arc")
        self.reset_model_psector("node")
        self.reset_model_psector("connec")
        if self.project_type.upper() == 'UD':
            self.reset_model_psector("gully")
        self.reset_model_psector("other")
        self.close_dialog(self.dlg_plan_psector)
        self.hide_generic_layers(excluded_layers=["v_edit_element"])
        self.disconnect_snapping()
        self.disconnect_signal_selection_changed()


    def reset_model_psector(self, geom_type):
        """ Reset model of the widget """

        table_relation = "" + geom_type + "_plan"
        widget_name = "tbl_" + table_relation
        widget = qt_tools.getWidget(self.dlg_plan_psector, widget_name)
        if widget:
            widget.setModel(None)


    def check_name(self, psector_name):
        """ Check if name of new psector exist or not """

        sql = (f"SELECT name FROM plan_psector"
               f" WHERE name = '{psector_name}'")
        row = self.controller.get_row(sql)
        if row is None:
            return False
        return True


    def insert_or_update_new_psector(self, tablename, close_dlg=False):

        psector_name = qt_tools.getWidgetText(self.dlg_plan_psector, "name", return_string_null=False)
        if psector_name == "":
            message = "Mandatory field is missing. Please, set a value"
            self.controller.show_warning(message, parameter='Name')
            return

        rotation = qt_tools.getWidgetText(self.dlg_plan_psector, "rotation", return_string_null=False)
        if rotation == "":
            qt_tools.setWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.rotation, 0)

        name_exist = self.check_name(psector_name)
        if name_exist and not self.update:
            message = "The name is current in use"
            self.controller.show_warning(message)
            return
        else:
            self.enable_tabs(True)
            self.enable_buttons(True)

        viewname = f"'v_edit_plan_psector'"
        sql = (f"SELECT column_name FROM information_schema.columns "
               f"WHERE table_name = {viewname} "
               f"AND table_schema = '" + self.schema_name.replace('"', '') + "' "
               f"ORDER BY ordinal_position;")
        rows = self.controller.get_rows(sql, log_sql=True)
        if not rows or rows is None or rows == '':
            message = "Check fields from table or view"
            self.controller.show_warning(message, parameter=viewname)
            return

        columns = []
        for row in rows:
            columns.append(str(row[0]))

        if self.update:
            if columns:
                sql = "UPDATE " + tablename + " SET "
                for column_name in columns:
                    if column_name != 'psector_id':
                        widget_type = qt_tools.getWidgetType(self.dlg_plan_psector, column_name)
                        if widget_type is QCheckBox:
                            value = qt_tools.isChecked(self.dlg_plan_psector, column_name)
                        elif widget_type is QDateEdit:
                            date = self.dlg_plan_psector.findChild(QDateEdit, str(column_name))
                            value = date.dateTime().toString('yyyy-MM-dd HH:mm:ss')
                        elif widget_type is QComboBox:
                            combo = qt_tools.getWidget(self.dlg_plan_psector, column_name)
                            value = str(qt_tools.get_item_data(self.dlg_plan_psector, combo))
                        else:
                            value = qt_tools.getWidgetText(self.dlg_plan_psector, column_name)
                        if value is None or value == 'null':
                            sql += column_name + " = null, "
                        else:
                            if type(value) is not bool:
                                value = value.replace(",", ".")
                            sql += f"{column_name} = $${value}$$, "

                sql = sql[:len(sql) - 2]
                sql += f" WHERE psector_id = '{qt_tools.getWidgetText(self.dlg_plan_psector, self.psector_id)}'"

        else:
            values = "VALUES("
            if columns:
                sql = f"INSERT INTO {tablename} ("
                for column_name in columns:
                    if column_name != 'psector_id':
                        widget_type = qt_tools.getWidgetType(self.dlg_plan_psector, column_name)
                        if widget_type is not None:
                            value = None
                            if widget_type is QCheckBox:
                                value = str(qt_tools.isChecked(self.dlg_plan_psector, column_name)).upper()
                            elif widget_type is QDateEdit:
                                date = self.dlg_plan_psector.findChild(QDateEdit, str(column_name))
                                values += date.dateTime().toString('yyyy-MM-dd HH:mm:ss') + ", "
                            elif widget_type is QComboBox:
                                combo = qt_tools.getWidget(self.dlg_plan_psector, column_name)
                                value = str(qt_tools.get_item_data(self.dlg_plan_psector, combo))
                            else:
                                value = qt_tools.getWidgetText(self.dlg_plan_psector, column_name)

                            if value is None or value == 'null':
                                sql += column_name + ", "
                                values += "null, "
                            else:
                                values += f"$${value}$$, "
                                sql += column_name + ", "

                sql = sql[:len(sql) - 2] + ") "
                values = values[:len(values) - 2] + ")"
                sql += values

        if not self.update:
            sql += " RETURNING psector_id;"
            new_psector_id = self.controller.execute_returning(sql, log_sql=True)
            qt_tools.setText(self.dlg_plan_psector, self.dlg_plan_psector.psector_id, str(new_psector_id[0]))
            if new_psector_id and self.plan_om == 'plan':
                row = self.controller.get_config('plan_psector_vdefault')
                if row:
                    sql = (f"UPDATE config_param_user "
                           f" SET value = $${new_psector_id[0]}$$ "
                           f" WHERE parameter = 'plan_psector_vdefault'"
                           f" AND cur_user=current_user; ")
                else:
                    sql = (f"INSERT INTO config_param_user (parameter, value, cur_user) "
                           f" VALUES ('plan_psector_vdefault', '{new_psector_id[0]}', current_user);")
                self.controller.execute_sql(sql, log_sql=True)
        else:
            self.controller.execute_sql(sql, log_sql=True)

        self.dlg_plan_psector.tabWidget.setTabEnabled(1, True)
        self.delete_psector_selector('selector_plan_psector')
        self.insert_psector_selector('selector_plan_psector', 'psector_id',
                                     qt_tools.getWidgetText(self.dlg_plan_psector, self.dlg_plan_psector.psector_id))

        if close_dlg:
            self.reload_states_selector()
            self.close_dialog(self.dlg_plan_psector)


    def price_selector(self, dialog, tableleft, tableright, field_id_right):

        # fill QTableView all_rows
        tbl_all_rows = dialog.findChild(QTableView, "all_rows")
        tbl_all_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.fill_table(dialog, tbl_all_rows, tableleft)
        self.set_table_columns(dialog, tbl_all_rows, tableleft)

        # fill QTableView selected_rows
        tbl_selected_rows = dialog.findChild(QTableView, "selected_rows")
        tbl_selected_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
        expr = f" psector_id = '{qt_tools.getWidgetText(dialog, 'psector_id')}'"
        # Refresh model with selected filter
        self.fill_table(dialog, tbl_selected_rows, tableright, True, QTableView.DoubleClicked, expr)
        self.set_table_columns(dialog, tbl_selected_rows, tableright)

        # Button select
        dialog.btn_select.clicked.connect(partial(self.rows_selector, dialog, tbl_all_rows, tbl_selected_rows, 'id',
            tableright, "price_id", 'id'))
        tbl_all_rows.doubleClicked.connect(partial(self.rows_selector, dialog, tbl_all_rows, tbl_selected_rows, 'id',
            tableright, "price_id", 'id'))

        # Button unselect
        dialog.btn_unselect.clicked.connect(partial(self.rows_unselector, dialog, tbl_selected_rows,
            tableright, field_id_right))


    def rows_selector(self, dialog, tbl_all_rows, tbl_selected_rows, id_ori, tableright, id_des, field_id):
        """
            :param tbl_all_rows: QTableView origin
            :param tbl_selected_rows: QTableView destini
            :param id_ori: Refers to the id of the source table
            :param tableright: table destini
            :param id_des: Refers to the id of the target table, on which the query will be made
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
            psector_id = qt_tools.getWidgetText(dialog, 'psector_id')
            values += f"'{psector_id}', "
            if tbl_all_rows.model().record(row).value('unit') not in (None, 'null', 'NULL'):
                values += f"'{tbl_all_rows.model().record(row).value('unit')}', "
            else:
                values += 'null, '
            if tbl_all_rows.model().record(row).value('id') not in (None, 'null', 'NULL'):
                values += f"'{tbl_all_rows.model().record(row).value('id')}', "
            else:
                values += 'null, '
            if tbl_all_rows.model().record(row).value('description') not in (None, 'null', 'NULL'):
                values += f"'{tbl_all_rows.model().record(row).value('description')}', "
            else:
                values += 'null, '
            if tbl_all_rows.model().record(row).value('price') not in (None, 'null', 'NULL'):
                values += f"'{tbl_all_rows.model().record(row).value('price')}', "
            else:
                values += 'null, '
            values = values[:len(values) - 2]
            # Check if expl_id already exists in expl_selector
            sql = (f"SELECT DISTINCT({id_des})"
                   f" FROM {tableright}"
                   f" WHERE {id_des} = '{expl_id[i]}'"
                   f" AND psector_id = '{psector_id}'")

            row = self.controller.get_row(sql)
            if row is not None:
                # if exist - show warning
                message = "Id already selected"
                self.controller.show_info_box(message, "Info", parameter=str(expl_id[i]))
            else:
                sql = (f"INSERT INTO {tableright}"
                       f" (psector_id, unit, price_id, descript, price) "
                       f" VALUES ({values})")
                self.controller.execute_sql(sql)

        # Refresh
        expr = f" psector_id = '{qt_tools.getWidgetText(dialog, 'psector_id')}'"
        # Refresh model with selected filter
        self.fill_table(dialog, tbl_selected_rows, tableright, True, QTableView.DoubleClicked, expr)
        self.set_table_columns(dialog, tbl_selected_rows, tableright)
        self.update_total(self.dlg_plan_psector, self.dlg_plan_psector.selected_rows)


    def rows_unselector(self, dialog, tbl_selected_rows, tableright, field_id_right):

        query = (f"DELETE FROM {tableright}"
                 f" WHERE {tableright}.{field_id_right} = ")
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
            sql = (f"{query}'{expl_id[i]}'"
                   f" AND psector_id = '{qt_tools.getWidgetText(dialog, 'psector_id')}'")
            self.controller.execute_sql(sql)

        # Refresh
        expr = f" psector_id = '{qt_tools.getWidgetText(dialog, 'psector_id')}'"
        # Refresh model with selected filter
        self.fill_table(dialog, tbl_selected_rows, tableright, True, QTableView.DoubleClicked, expr)
        self.set_table_columns(dialog, tbl_selected_rows, tableright)
        self.update_total(self.dlg_plan_psector, self.dlg_plan_psector.selected_rows)


    def query_like_widget_text(self, dialog, text_line, qtable, tableleft, tableright, field_id):
        """ Populate the QTableView by filtering through the QLineEdit"""

        schema_name = self.schema_name.replace('"','')
        query = qt_tools.getWidgetText(dialog, text_line).lower()
        if query == 'null':
            query = ""
        sql = (f"SELECT * FROM {schema_name}.{tableleft} WHERE LOWER ({field_id})"
               f" LIKE '%{query}%' AND {field_id} NOT IN ("
               f" SELECT price_id FROM {tableright}"
               f" WHERE psector_id = '{qt_tools.getWidgetText(dialog, 'psector_id')}')")
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
        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        # Set model
        model = QSqlTableModel()
        model.setTable(table_name)
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
            if str(widget.model().record(row).value('psector_id')) != qt_tools.getWidgetText(dialog, 'psector_id'):
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
        sql = (f"SELECT doc_id"
               f" FROM doc_x_psector"
               f" WHERE doc_id = '{doc_id}' AND psector_id = '{psector_id}'")
        row = self.controller.get_row(sql)
        if row:
            msg = "Document already exist"
            self.controller.show_warning(msg)
            return

        # Insert into new table
        sql = (f"INSERT INTO doc_x_psector (doc_id, psector_id)"
               f" VALUES ('{doc_id}', {psector_id})")
        status = self.controller.execute_sql(sql)
        if status:
            message = "Document inserted successfully"
            self.controller.show_info(message)

        self.dlg_plan_psector.tbl_document.model().select()


    def manage_document(self, qtable):
        """ Access GUI to manage documents e.g Execute action of button 34 """
        
        psector_id = qt_tools.getText(self.dlg_plan_psector, self.dlg_plan_psector.psector_id)
        manage_document = GwDocument(single_tool=False)
        dlg_docman = manage_document.manage_document(tablename='psector', qtable=qtable, item_id=psector_id)
        dlg_docman.btn_accept.clicked.connect(partial(self.set_completer_object, dlg_docman, 'doc'))
        qt_tools.remove_tab_by_tabName(dlg_docman.tabWidget, 'tab_rel')


    def show_status_warning(self):

        msg = "WARNING: You have updated the status value. If you click 'Accept' on the main dialog, " \
              "a process that updates the state & state_type values of all that features that belong to the psector, " \
              "according to the system variables plan_psector_statetype, " \
              "plan_statetype_planned and plan_statetype_ficticious, will be triggered."
        self.controller.show_details(msg, 'Message warning')
