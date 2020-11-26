"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import csv
import json
import os
import operator
import sys
from collections import OrderedDict
from functools import partial

from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtGui import QDoubleValidator, QIntValidator, QKeySequence, QColor
from qgis.PyQt.QtSql import QSqlQueryModel, QSqlTableModel
from qgis.PyQt.QtWidgets import QAbstractItemView, QAction, QCheckBox, QComboBox, QDateEdit, QLabel, \
    QLineEdit, QTableView, QWidget,  QDoubleSpinBox, QTextEdit, QPushButton
from qgis.core import QgsLayoutExporter, QgsPointXY, QgsProject, QgsRectangle
from qgis.gui import QgsRubberBand

from .document import GwDocument, global_vars
from ..shared.psector_duplicate import GwPsectorDuplicate
from ..ui.ui_manager import Plan_psector, PsectorRapportUi, PsectorManagerUi, PriceManagerUi
from ..utils import tools_gw
from ...lib import tools_db, tools_qgis, tools_qt, tools_log


class GwPsector:

    def __init__(self):
        """ Class to control 'New Psector' of toolbar 'master' """

        self.controller = global_vars.controller
        self.iface = global_vars.iface
        self.canvas = global_vars.canvas
        self.schema_name = global_vars.schema_name

        self.rubber_band = QgsRubberBand(self.canvas)


    def new_psector(self, psector_id=None, is_api=False):
        """ Buttons 45 and 81: New psector """

        row = tools_gw.get_config(parameter='admin_currency', columns='value::text', table='config_param_system')
        if row:
            self.sys_currency = json.loads(row[0], object_pairs_hook=OrderedDict)

        # Create the dialog and signals
        self.dlg_plan_psector = Plan_psector()
        tools_gw.load_settings(self.dlg_plan_psector)

        # Capture the current layer to return it at the end of the operation
        cur_active_layer = self.iface.activeLayer()
        widget_list = self.dlg_plan_psector.findChildren(QTableView)
        for widget in widget_list:
            tools_qt.set_qtv_config(widget)
        self.project_type = tools_gw.get_project_type()

        # Get layers of every geom_type
        self.list_elemets = {}

        # Get layers of every geom_type

        # Setting lists
        self.ids = []
        self.list_ids = {}
        self.list_ids['arc'] = []
        self.list_ids['node'] = []
        self.list_ids['connec'] = []
        self.list_ids['gully'] = []
        self.list_ids['element'] = []

        # Setting layers
        self.layers = {}
        self.layers['arc'] = []
        self.layers['node'] = []
        self.layers['connec'] = []
        self.layers['gully'] = []
        self.layers['element'] = []


        self.layers['arc'] = tools_gw.get_group_layers('arc')
        self.layers['node'] = tools_gw.get_group_layers('node')
        self.layers['connec'] = tools_gw.get_group_layers('connec')
        if self.project_type.upper() == 'UD':
            self.layers['gully'] = tools_gw.get_group_layers('gully')
        else:
            tools_qt.remove_tab(self.dlg_plan_psector.tab_feature, 'tab_gully')

        self.update = False  # if false: insert; if true: update

        self.geom_type = "arc"

        # Remove all previous selections
        self.layers = tools_gw.remove_selection(True, layers=self.layers)

        # Set icons
        tools_gw.add_icon(self.dlg_plan_psector.btn_insert, "111")
        tools_gw.add_icon(self.dlg_plan_psector.btn_delete, "112")
        tools_gw.add_icon(self.dlg_plan_psector.btn_snapping, "137")
        tools_gw.add_icon(self.dlg_plan_psector.btn_doc_insert, "111")
        tools_gw.add_icon(self.dlg_plan_psector.btn_doc_delete, "112")
        tools_gw.add_icon(self.dlg_plan_psector.btn_doc_new, "34")
        tools_gw.add_icon(self.dlg_plan_psector.btn_open_doc, "170")

        table_object = "psector"

        # tab General elements
        self.psector_id = self.dlg_plan_psector.findChild(QLineEdit, "psector_id")
        self.ext_code = self.dlg_plan_psector.findChild(QLineEdit, "ext_code")
        self.cmb_psector_type = self.dlg_plan_psector.findChild(QComboBox, "psector_type")
        self.cmb_expl_id = self.dlg_plan_psector.findChild(QComboBox, "expl_id")
        self.cmb_status = self.dlg_plan_psector.findChild(QComboBox, "status")

        scale = self.dlg_plan_psector.findChild(QLineEdit, "scale")
        scale.setValidator(QDoubleValidator())
        rotation = self.dlg_plan_psector.findChild(QLineEdit, "rotation")
        rotation.setValidator(QDoubleValidator())
        atlas_id = self.dlg_plan_psector.findChild(QLineEdit, "atlas_id")
        atlas_id.setValidator(QIntValidator())
        num_value = self.dlg_plan_psector.findChild(QLineEdit, "num_value")
        num_value.setValidator(QIntValidator())
        where = " WHERE typevalue = 'psector_type' "
        self.populate_combos(self.dlg_plan_psector.psector_type, 'idval', 'id', 'plan_typevalue', where)

        # Populate combo status
        sql = "SELECT id, idval FROM plan_typevalue WHERE typevalue = 'value_priority'"
        rows = self.controller.get_rows(sql)
        
        tools_qt.fill_combo_values(self.dlg_plan_psector.priority, rows, 1)

        # Populate combo expl_id
        sql = ("SELECT expl_id, name from exploitation "
               " JOIN selector_expl USING (expl_id) "
               " WHERE exploitation.expl_id != 0 and cur_user = current_user")
        rows = self.controller.get_rows(sql)
        tools_qt.fill_combo_values(self.cmb_expl_id, rows, 1)

        # Populate combo status
        sql = "SELECT id, idval FROM plan_typevalue WHERE typevalue = 'psector_status'"
        rows = self.controller.get_rows(sql)
        tools_qt.fill_combo_values(self.cmb_status, rows, 1)

        # tab Bugdet
        gexpenses = self.dlg_plan_psector.findChild(QLineEdit, "gexpenses")
        tools_qt.double_validator(gexpenses)
        vat = self.dlg_plan_psector.findChild(QLineEdit, "vat")
        tools_qt.double_validator(vat)
        other = self.dlg_plan_psector.findChild(QLineEdit, "other")
        tools_qt.double_validator(other)

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
            tools_gw.set_tablemodel_config(self.dlg_plan_psector, self.qtbl_arc, "plan_psector_x_arc")
            self.fill_table(self.dlg_plan_psector, self.qtbl_node, "plan_psector_x_node",
                set_edit_triggers=QTableView.DoubleClicked)
            tools_gw.set_tablemodel_config(self.dlg_plan_psector, self.qtbl_node, "plan_psector_x_node")
            self.fill_table(self.dlg_plan_psector, self.qtbl_connec, "plan_psector_x_connec",
                set_edit_triggers=QTableView.DoubleClicked)
            tools_gw.set_tablemodel_config(self.dlg_plan_psector, self.qtbl_connec, "plan_psector_x_connec")
            if self.project_type.upper() == 'UD':
                self.fill_table(self.dlg_plan_psector, self.qtbl_gully, "plan_psector_x_gully",
                                set_edit_triggers=QTableView.DoubleClicked)
                tools_gw.set_tablemodel_config(self.dlg_plan_psector, self.qtbl_gully, "plan_psector_x_gully")
            sql = (f"SELECT psector_id, name, psector_type, expl_id, priority, descript, text1, text2, "
                   f"text3, text4, text5, text6, num_value, observ, atlas_id, scale, rotation, active, ext_code, status"
                   f" FROM plan_psector "
                   f"WHERE psector_id = {psector_id}")
            row = self.controller.get_row(sql)

            if not row:
                return

            self.dlg_plan_psector.setWindowTitle(f"Plan psector - {row['name']}")
            self.psector_id.setText(str(row['psector_id']))
            if str(row['ext_code']) != 'None':
                self.ext_code.setText(str(row['ext_code']))
            sql = (f"SELECT id, idval FROM plan_typevalue WHERE typevalue = 'psector_type' AND "
                   f"id = '{row['psector_type']}'")
            result = self.controller.get_row(sql)
            tools_qt.set_combo_value(self.cmb_psector_type, str(result['idval']), 1)
            sql = (f"SELECT name FROM exploitation "
                   f"WHERE expl_id = {row['expl_id']}")
            result = self.controller.get_row(sql)
            tools_qt.set_combo_value(self.cmb_expl_id, str(result['name']), 1)

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
                tools_gw.show_warning(msg, 1)

            tools_qt.set_checked(self.dlg_plan_psector, "active", row['active'])
            self.fill_widget(self.dlg_plan_psector, "name", row)
            self.fill_widget(self.dlg_plan_psector, "descript", row)
            tools_qt.set_combo_value(self.dlg_plan_psector.priority, str(row["priority"]), 1)
            self.fill_widget(self.dlg_plan_psector, "text1", row)
            self.fill_widget(self.dlg_plan_psector, "text2", row)
            self.fill_widget(self.dlg_plan_psector, "text3", row)
            self.fill_widget(self.dlg_plan_psector, "text4", row)
            self.fill_widget(self.dlg_plan_psector, "text5", row)
            self.fill_widget(self.dlg_plan_psector, "text6", row)
            self.fill_widget(self.dlg_plan_psector, "num_value", row)
            self.fill_widget(self.dlg_plan_psector, "observ", row)
            self.fill_widget(self.dlg_plan_psector, "atlas_id", row)
            self.fill_widget(self.dlg_plan_psector, "scale", row)
            self.fill_widget(self.dlg_plan_psector, "rotation", row)

            # Fill tables tbl_arc_plan, tbl_node_plan, tbl_v_plan/om_other_x_psector with selected filter
            expr = " psector_id = " + str(psector_id)
            self.qtbl_arc.model().setFilter(expr)
            self.qtbl_arc.model().select()
            self.qtbl_arc.clicked.connect(
                partial(self.hilight_feature_by_id, self.qtbl_arc, "v_edit_arc", "arc_id", self.rubber_band, 5))

            expr = " psector_id = " + str(psector_id)
            self.qtbl_node.model().setFilter(expr)
            self.qtbl_node.model().select()
            self.qtbl_node.clicked.connect(
                partial(self.hilight_feature_by_id, self.qtbl_node, "v_edit_node", "node_id", self.rubber_band, 1))

            expr = " psector_id = " + str(psector_id)
            self.qtbl_connec.model().setFilter(expr)
            self.qtbl_connec.model().select()
            self.qtbl_connec.clicked.connect(
                partial(self.hilight_feature_by_id, self.qtbl_connec, "v_edit_connec", "connec_id", self.rubber_band, 1))

            if self.project_type.upper() == 'UD':
                expr = " psector_id = " + str(psector_id)
                self.qtbl_gully.model().setFilter(expr)
                self.qtbl_gully.model().select()
                self.qtbl_gully.clicked.connect(
                    partial(self.hilight_feature_by_id, self.qtbl_gully, "v_edit_gully", "gully_id", self.rubber_band, 1))

            self.populate_budget(self.dlg_plan_psector, psector_id)
            self.update = True
            psector_id_aux = tools_qt.get_text(self.dlg_plan_psector, self.dlg_plan_psector.psector_id)
            if psector_id_aux != 'null':
                sql = (f"DELETE FROM selector_plan_psector "
                       f"WHERE cur_user = current_user")
                self.controller.execute_sql(sql)
                self.insert_psector_selector('selector_plan_psector', 'psector_id', psector_id_aux)
            sql = (f"DELETE FROM selector_psector "
                   f"WHERE cur_user = current_user AND psector_id = '{psector_id_aux}'")
            self.controller.execute_sql(sql)
            self.insert_psector_selector('selector_psector', 'psector_id', psector_id_aux)
            layer = None
            if not is_api:
                layername = f'v_edit_plan_psector'
                layer = tools_qgis.get_layer_by_tablename(layername, show_warning=False)

            if layer:

                expr_filter = f"psector_id = '{psector_id}'"
                (is_valid, expr) = tools_qt.check_expression_filter(expr_filter)  # @UnusedVariable
                if not is_valid:
                    return

                tools_qgis.select_features_by_expr(layer, expr)

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
            tools_qt.fill_table_object(self.tbl_document, self.schema_name + ".v_ui_doc_x_psector", filter_)
            self.tbl_document.doubleClicked.connect(partial(tools_qt.document_open, self.tbl_document, 'path'))

        else:

            # Set psector_status vdefault
            sql = "SELECT id, idval FROM plan_typevalue WHERE typevalue = 'psector_status' and id = '2'"
            result = self.controller.get_row(sql)
            tools_qt.set_combo_value(self.cmb_status, str(result[1]), 1)

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
        self.dlg_plan_psector.rejected.connect(partial(self.close_psector, cur_active_layer))
        self.dlg_plan_psector.chk_enable_all.stateChanged.connect(partial(self.enable_all))

        self.lbl_descript = self.dlg_plan_psector.findChild(QLabel, "lbl_descript")
        self.dlg_plan_psector.all_rows.clicked.connect(partial(self.show_description))
        self.dlg_plan_psector.btn_select.clicked.connect(partial(self.update_total,
            self.dlg_plan_psector, self.dlg_plan_psector.selected_rows))
        self.dlg_plan_psector.btn_unselect.clicked.connect(partial(self.update_total,
            self.dlg_plan_psector, self.dlg_plan_psector.selected_rows))
        # TODO: Set variables self.ids, self.layers, self.list_ids using return parameters
        self.dlg_plan_psector.btn_insert.clicked.connect(partial(tools_gw.insert_feature,
            self.dlg_plan_psector, table_object, True, geom_type=self.geom_type, ids=self.ids, layers=self.layers,
                                                                 list_ids=self.list_ids))
        # TODO: Set variables self.ids, self.layers, self.list_ids using return parameters
        self.dlg_plan_psector.btn_delete.clicked.connect(partial(tools_gw.delete_records,
            self.dlg_plan_psector, table_object, True, geom_type=self.geom_type, layers=self.layers,
                                                                 ids=self.ids, list_ids=self.list_ids))
        self.dlg_plan_psector.btn_delete.setShortcut(QKeySequence(Qt.Key_Delete))
        # TODO: Set variables self.ids, self.layers, self.list_ids using return parameters
        self.dlg_plan_psector.btn_snapping.clicked.connect(partial(tools_gw.selection_init,
            self.dlg_plan_psector, table_object, True, None, layers=self.layers))

        self.dlg_plan_psector.btn_rapports.clicked.connect(partial(self.open_dlg_rapports))
        self.dlg_plan_psector.tab_feature.currentChanged.connect(partial(tools_gw.get_signal_change_tab,
            self.dlg_plan_psector, excluded_layers=["v_edit_element"]))
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
        self.dlg_plan_psector.btn_doc_delete.clicked.connect(partial(tools_gw.document_delete, self.tbl_document))
        self.dlg_plan_psector.btn_doc_new.clicked.connect(partial(self.manage_document, self.tbl_document))
        self.dlg_plan_psector.btn_open_doc.clicked.connect(partial(tools_qt.document_open, self.tbl_document, 'path'))
        self.cmb_status.currentIndexChanged.connect(partial(self.show_status_warning))

        # Create list for completer QLineEdit
        sql = "SELECT DISTINCT(id) FROM v_ui_document ORDER BY id"
        list_items = tools_db.make_list_for_completer(sql)
        tools_qt.set_completer_lineedit(self.dlg_plan_psector.doc_id, list_items)

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

            tools_qt.set_widget_text(self.dlg_plan_psector, self.dlg_plan_psector.other, other)
            tools_qt.set_widget_text(self.dlg_plan_psector, self.dlg_plan_psector.gexpenses, gexpenses)
            tools_qt.set_widget_text(self.dlg_plan_psector, self.dlg_plan_psector.vat, vat)

            tools_qt.set_widget_text(self.dlg_plan_psector, 'cur_total_node', self.sys_currency['symbol'])
            tools_qt.set_widget_text(self.dlg_plan_psector, 'cur_total_arc', self.sys_currency['symbol'])
            tools_qt.set_widget_text(self.dlg_plan_psector, 'cur_total_other', self.sys_currency['symbol'])
            tools_qt.set_widget_text(self.dlg_plan_psector, 'cur_pem', self.sys_currency['symbol'])
            tools_qt.set_widget_text(self.dlg_plan_psector, 'cur_pec_pem', self.sys_currency['symbol'])
            tools_qt.set_widget_text(self.dlg_plan_psector, 'cur_pec', self.sys_currency['symbol'])
            tools_qt.set_widget_text(self.dlg_plan_psector, 'cur_pecvat_pem', self.sys_currency['symbol'])
            tools_qt.set_widget_text(self.dlg_plan_psector, 'cur_pec_vat', self.sys_currency['symbol'])
            tools_qt.set_widget_text(self.dlg_plan_psector, 'cur_pca_pecvat', self.sys_currency['symbol'])
            tools_qt.set_widget_text(self.dlg_plan_psector, 'cur_pca', self.sys_currency['symbol'])

        # Adding auto-completion to a QLineEdit for default feature
        viewname = "v_edit_" + self.geom_type
        tools_gw.set_completer_widget(viewname, self.dlg_plan_psector.feature_id, str(self.geom_type) + "_id")

        # Set default tab 'arc'
        self.dlg_plan_psector.tab_feature.setCurrentIndex(0)
        tools_gw.get_signal_change_tab(self.dlg_plan_psector, excluded_layers=["v_edit_element"])

        widget_to_ignore = ('btn_accept', 'btn_cancel', 'btn_rapports', 'btn_open_doc')
        restriction = ('role_basic', 'role_om', 'role_epa', 'role_om')
        self.set_restriction_by_role(self.dlg_plan_psector, widget_to_ignore, restriction)

        # Open dialog
        tools_gw.open_dialog(self.dlg_plan_psector, dlg_name='plan_psector', maximize_button=False)


    def fill_widget(self, dialog, widget, row):

        if type(widget) is str or type(widget) is str:
            widget = dialog.findChild(QWidget, widget)
        if not widget:
            return
        key = widget.objectName()
        if key in row:
            if row[key] is not None:
                value = str(row[key])
                if type(widget) is QLineEdit or type(widget) is QTextEdit:
                    if value == 'None':
                        value = ""
                    widget.setText(value)
            else:
                widget.setText("")
        else:
            widget.setText("")


    def enable_all(self):

        value = tools_qt.isChecked(self.dlg_plan_psector, "chk_enable_all")
        psector_id = tools_qt.get_text(self.dlg_plan_psector, "psector_id")
        sql = f"SELECT gw_fct_plan_psector_enableall({value}, '{psector_id}')"
        self.controller.execute_sql(sql)
        tools_gw.reload_qtable(self.dlg_plan_psector, 'arc')
        tools_gw.reload_qtable(self.dlg_plan_psector, 'node')
        tools_gw.reload_qtable(self.dlg_plan_psector, 'connec')
        if self.project_type.upper() == 'UD':
            tools_gw.reload_qtable(self.dlg_plan_psector, 'gully')

        sql = (f"UPDATE plan_psector "
               f"SET enable_all = '{value}' "
               f"WHERE psector_id = '{psector_id}'")
        self.controller.execute_sql(sql)
        tools_qgis.refresh_map_canvas()


    def update_total(self, dialog, qtable):
        """ Show description of product plan/om _psector as label """

        try:
            model = qtable.model()
            if model is None:
                return

            total = 0
            psector_id = tools_qt.get_text(dialog, 'psector_id')
            for x in range(0, model.rowCount()):
                if int(qtable.model().record(x).value('psector_id')) == int(psector_id):
                    if str(qtable.model().record(x).value('total_budget')) != 'NULL':
                        total += float(qtable.model().record(x).value('total_budget'))
            tools_qt.set_widget_text(dialog, 'lbl_total', str(total))
        except:
            pass


    def open_dlg_rapports(self):

        default_file_name = tools_qt.get_text(self.dlg_plan_psector, self.dlg_plan_psector.name)

        self.dlg_psector_rapport = PsectorRapportUi()
        tools_gw.load_settings(self.dlg_psector_rapport)

        tools_qt.set_widget_text(self.dlg_psector_rapport, 'txt_composer_path', default_file_name + " comp.pdf")
        tools_qt.set_widget_text(self.dlg_psector_rapport, 'txt_csv_detail_path', default_file_name + " detail.csv")
        tools_qt.set_widget_text(self.dlg_psector_rapport, 'txt_csv_path', default_file_name + ".csv")

        self.dlg_psector_rapport.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_psector_rapport))
        self.dlg_psector_rapport.btn_ok.clicked.connect(partial(self.generate_rapports))
        self.dlg_psector_rapport.btn_path.clicked.connect(partial(tools_qt.get_folder_path, self.dlg_psector_rapport,
            self.dlg_psector_rapport.txt_path))

        value = tools_gw.get_config_parser('psector_rapport', 'psector_rapport_path')
        tools_qt.set_widget_text(self.dlg_psector_rapport, self.dlg_psector_rapport.txt_path, value)
        value = tools_gw.get_config_parser('psector_rapport', 'psector_rapport_chk_composer')
        tools_qt.set_checked(self.dlg_psector_rapport, self.dlg_psector_rapport.chk_composer, value)
        value = tools_gw.get_config_parser('psector_rapport', 'psector_rapport_chk_csv_detail')
        tools_qt.set_checked(self.dlg_psector_rapport, self.dlg_psector_rapport.chk_csv_detail, value)
        value = tools_gw.get_config_parser('psector_rapport', 'psector_rapport_chk_csv')
        tools_qt.set_checked(self.dlg_psector_rapport, self.dlg_psector_rapport.chk_csv, value)

        if tools_qt.get_text(self.dlg_psector_rapport, self.dlg_psector_rapport.txt_path) == 'null':
            if 'nt' in sys.builtin_module_names:
                plugin_dir = os.path.expanduser("~\Documents")
            else:
                plugin_dir = os.path.expanduser("~")
            tools_qt.set_widget_text(self.dlg_psector_rapport, self.dlg_psector_rapport.txt_path, plugin_dir)
        self.populate_cmb_templates()

        # Open dialog
        tools_gw.open_dialog(self.dlg_psector_rapport, dlg_name='psector_rapport', maximize_button=False)


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
            tools_qt.fill_combo_values(self.dlg_psector_rapport.cmb_templates, records, 1)

        row = tools_gw.get_config(f'composer_plan_vdefault')
        if row:
            tools_qt.set_combo_value(self.dlg_psector_rapport.cmb_templates, row[0], 1)


    def generate_rapports(self):
        tools_gw.set_config_parser('psector_rapport', 'psector_rapport_path',
                         f"{tools_qt.get_text(self.dlg_psector_rapport, 'txt_path')}")
        tools_gw.set_config_parser('psector_rapport', 'psector_rapport_chk_composer',
                         f"{tools_qt.isChecked(self.dlg_psector_rapport, 'chk_composer')}")
        tools_gw.set_config_parser('psector_rapport', 'psector_rapport_chk_csv_detail',
                         f"{tools_qt.isChecked(self.dlg_psector_rapport, 'chk_csv_detail')}")
        tools_gw.set_config_parser('psector_rapport', 'psector_rapport_chk_csv',
                         f"{tools_qt.isChecked(self.dlg_psector_rapport, 'chk_csv')}")

        folder_path = tools_qt.get_text(self.dlg_psector_rapport, self.dlg_psector_rapport.txt_path)
        if folder_path is None or folder_path == 'null' or not os.path.exists(folder_path):
            tools_qt.get_folder_path(self.dlg_psector_rapport.txt_path)
            folder_path = tools_qt.get_text(self.dlg_psector_rapport, self.dlg_psector_rapport.txt_path)

        # Generate Composer
        if tools_qt.isChecked(self.dlg_psector_rapport, self.dlg_psector_rapport.chk_composer):
            file_name = tools_qt.get_text(self.dlg_psector_rapport, 'txt_composer_path')
            if file_name is None or file_name == 'null':
                message = "File name is required"
                tools_gw.show_warning(message)
            if file_name.find('.pdf') is False:
                file_name += '.pdf'
            path = folder_path + '/' + file_name
            self.generate_composer(path)

        # Generate csv detail
        if tools_qt.isChecked(self.dlg_psector_rapport, self.dlg_psector_rapport.chk_csv_detail):
            file_name = tools_qt.get_text(self.dlg_psector_rapport, 'txt_csv_path')
            viewname = f"v_plan_current_psector_budget_detail"
            if file_name is None or file_name == 'null':
                message = "Price list csv file name is required"
                tools_gw.show_warning(message)
            if file_name.find('.csv') is False:
                file_name += '.csv'
            path = folder_path + '/' + file_name
            self.generate_csv(path, viewname)

        # Generate csv
        if tools_qt.isChecked(self.dlg_psector_rapport, self.dlg_psector_rapport.chk_csv):
            file_name = tools_qt.get_text(self.dlg_psector_rapport, 'txt_csv_detail_path')
            viewname = f"v_plan_current_psector_budget"
            if file_name is None or file_name == 'null':
                message = "Price list csv file name is required"
                tools_gw.show_warning(message)
            if file_name.find('.csv') is False:
                file_name += '.csv'
            path = folder_path + '/' + file_name
            self.generate_csv(path, viewname)

        tools_gw.close_dialog(self.dlg_psector_rapport)


    def generate_composer(self, path):
        # Get layout manager object
        layout_manager = QgsProject.instance().layoutManager()

        # Get our layout
        layout_name = tools_qt.get_text(self.dlg_psector_rapport, self.dlg_psector_rapport.cmb_templates)
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
                    tools_gw.show_info(message, parameter=path)
                    os.startfile(path)
                else:
                    message = "Cannot create file, check if its open"
                    tools_gw.show_warning(message, parameter=path)
            except Exception as e:
                tools_log.log_warning(str(e))
                msg = "Cannot create file, check if selected composer is the correct composer"
                tools_gw.show_warning(msg, parameter=path)
            finally:
                designer_window.close()
        else:
            tools_gw.show_warning("Layout not found", parameter=layout_name)


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
            tools_gw.show_warning(message, parameter=viewname)
            return
        for i in range(0, len(rows)):
            column_name = rows[i]
            columns.append(str(column_name[0]))

        sql = (f"SELECT * FROM {viewname}"
               f" WHERE psector_id = '{tools_qt.get_text(self.dlg_plan_psector, self.dlg_plan_psector.psector_id)}'")
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
                        tools_qt.set_widget_text(dialog, column_name, f"{row[column_name]:.02f}")
                    else:
                        tools_qt.set_widget_text(dialog, column_name, f"{0:.02f}")

        self.calc_pec_pem(dialog)
        self.calc_pecvat_pec(dialog)
        self.calc_pca_pecvat(dialog)


    def calc_pec_pem(self, dialog):

        if tools_qt.get_text(dialog, 'pec') not in('null', None):
            pec = float(tools_qt.get_text(dialog, 'pec'))
        else:
            pec = 0

        if tools_qt.get_text(dialog, 'pem') not in('null', None):
            pem = float(tools_qt.get_text(dialog, 'pem'))
        else:
            pem = 0

        res = f"{round(pec - pem, 2):.02f}"
        tools_qt.set_widget_text(dialog, 'pec_pem', res)


    def calc_pecvat_pec(self, dialog):

        if tools_qt.get_text(dialog, 'pec_vat') not in('null', None):
            pec_vat = float(tools_qt.get_text(dialog, 'pec_vat'))
        else:
            pec_vat = 0

        if tools_qt.get_text(dialog, 'pec') not in('null', None):
            pec = float(tools_qt.get_text(dialog, 'pec'))
        else:
            pec = 0
        res = f"{round(pec_vat - pec, 2):.02f}"
        tools_qt.set_widget_text(dialog, 'pecvat_pem', res)


    def calc_pca_pecvat(self, dialog):

        if tools_qt.get_text(dialog, 'pca') not in('null', None):
            pca = float(tools_qt.get_text(dialog, 'pca'))
        else:
            pca = 0

        if tools_qt.get_text(dialog, 'pec_vat') not in('null', None):
            pec_vat = float(tools_qt.get_text(dialog, 'pec_vat'))
        else:
            pec_vat = 0
        res = f"{round(pca - pec_vat, 2):.02f}"
        tools_qt.set_widget_text(dialog, 'pca_pecvat', res)


    def calulate_percents(self, tablename, psector_id, field):
        psector_id = tools_qt.get_text(self.dlg_plan_psector, "psector_id")

        sql = ("UPDATE " + tablename + " "
               " SET " + field + " = '" + tools_qt.get_text(self.dlg_plan_psector, field) + "'"
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
        tools_qt.set_widget_text(self.dlg_plan_psector, self.lbl_descript, des)


    def enable_tabs(self, enabled):
        self.dlg_plan_psector.tabWidget.setTabEnabled(1, enabled)
        self.dlg_plan_psector.tabWidget.setTabEnabled(2, enabled)
        self.dlg_plan_psector.tabWidget.setTabEnabled(3, enabled)
        self.dlg_plan_psector.tabWidget.setTabEnabled(4, enabled)
        self.dlg_plan_psector.tabWidget.setTabEnabled(5, enabled)


    def enable_buttons(self, enabled):
        self.dlg_plan_psector.btn_insert.setEnabled(enabled)
        self.dlg_plan_psector.btn_delete.setEnabled(enabled)
        self.dlg_plan_psector.btn_snapping.setEnabled(enabled)
        widget_to_ignore = ('btn_accept', 'btn_cancel', 'btn_rapports', 'btn_open_doc')
        restriction = ('role_basic', 'role_om', 'role_epa', 'role_om')
        self.set_restriction_by_role(self.dlg_plan_psector, widget_to_ignore, restriction)


    def connect_signal_selection_changed(self, dialog, table_object, query=True):
        """ Connect signal selectionChanged """

        try:
            # TODO: Set variables self.ids, self.layers, self.list_ids using return parameters
            self.canvas.selectionChanged.connect(
                partial(tools_gw.selection_changed, dialog, table_object, self.geom_type, query, layers=self.layers,
                        list_ids=self.list_ids))
        except Exception:
            pass


    def enable_relation_tab(self, tablename):

        sql = (f"SELECT name FROM {tablename} "
               f" WHERE LOWER(name) = '{tools_qt.get_text(self.dlg_plan_psector, self.dlg_plan_psector.name)}'")
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
            self.populate_budget(self.dlg_plan_psector, tools_qt.get_text(self.dlg_plan_psector, 'psector_id'))
        elif self.dlg_plan_psector.tabWidget.currentIndex() == 4:
            psector_id = tools_qt.get_text(self.dlg_plan_psector, 'psector_id')
            expr = f"psector_id = '{psector_id}'"
            tools_qt.fill_table_object(self.tbl_document, self.schema_name + ".v_ui_doc_x_psector", expr_filter=expr)

        sql = (f"SELECT other, gexpenses, vat"
               f" FROM plan_psector "
               f" WHERE psector_id = '{tools_qt.get_text(self.dlg_plan_psector, 'psector_id')}'")
        row = self.controller.get_row(sql)
        if row:
            tools_qt.set_widget_text(self.dlg_plan_psector, self.dlg_plan_psector.other, row[0])
            tools_qt.set_widget_text(self.dlg_plan_psector, self.dlg_plan_psector.gexpenses, row[1])
            tools_qt.set_widget_text(self.dlg_plan_psector, self.dlg_plan_psector.vat, row[2])

        self.dlg_plan_psector.chk_enable_all.setEnabled(True)

        widget_to_ignore = ('btn_accept', 'btn_cancel', 'btn_rapports', 'btn_open_doc')
        restriction = ('role_basic', 'role_om', 'role_epa', 'role_om')
        self.set_restriction_by_role(self.dlg_plan_psector, widget_to_ignore, restriction)


    def set_restriction_by_role(self, dialog, widget_to_ignore, restriction):
        """
        Set all widget enabled(False) or readOnly(True) except those on the tuple
        :param dialog:
        :param widget_to_ignore: tuple = ('widgetname1', 'widgetname2', 'widgetname3', ...)
        :param restriction: roles that do not have access. tuple = ('role1', 'role1', 'role1', ...)
        :return:
        """

        project_vars = global_vars.project_vars
        role = project_vars['role']
        role = tools_gw.get_restriction(role)
        if role in restriction:
            widget_list = dialog.findChildren(QWidget)
            for widget in widget_list:
                if widget.objectName() in widget_to_ignore:
                    continue
                # Set editable/readonly
                if type(widget) in (QLineEdit, QDoubleSpinBox, QTextEdit):
                    widget.setReadOnly(True)
                    widget.setStyleSheet("QWidget {background: rgb(242, 242, 242);color: rgb(100, 100, 100)}")
                elif type(widget) in (QComboBox, QCheckBox, QTableView, QPushButton):
                    widget.setEnabled(False)


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

        self.rubber_band.reset()
        self.reload_states_selector()
        if cur_active_layer:
            self.iface.setActiveLayer(cur_active_layer)
        self.layers = tools_gw.remove_selection(True, layers=self.layers)
        self.reset_model_psector("arc")
        self.reset_model_psector("node")
        self.reset_model_psector("connec")
        if self.project_type.upper() == 'UD':
            self.reset_model_psector("gully")
        self.reset_model_psector("other")
        tools_gw.close_dialog(self.dlg_plan_psector)
        tools_gw.hide_parent_layers(excluded_layers=["v_edit_element"])
        tools_qgis.disconnect_snapping()
        tools_qgis.disconnect_signal_selection_changed()


    def reset_model_psector(self, geom_type):
        """ Reset model of the widget """

        table_relation = "" + geom_type + "_plan"
        widget_name = "tbl_" + table_relation
        widget = tools_qt.get_widget(self.dlg_plan_psector, widget_name)
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

        psector_name = tools_qt.get_text(self.dlg_plan_psector, "name", return_string_null=False)
        if psector_name == "":
            message = "Mandatory field is missing. Please, set a value"
            tools_gw.show_warning(message, parameter='Name')
            return

        rotation = tools_qt.get_text(self.dlg_plan_psector, "rotation", return_string_null=False)
        if rotation == "":
            tools_qt.set_widget_text(self.dlg_plan_psector, self.dlg_plan_psector.rotation, 0)

        name_exist = self.check_name(psector_name)
        if name_exist and not self.update:
            message = "The name is current in use"
            tools_gw.show_warning(message)
            return
        else:
            self.enable_tabs(True)
            self.enable_buttons(True)

        viewname = f"'v_edit_plan_psector'"
        sql = (f"SELECT column_name FROM information_schema.columns "
               f"WHERE table_name = {viewname} "
               f"AND table_schema = '" + self.schema_name.replace('"', '') + "' "
               f"ORDER BY ordinal_position;")
        rows = self.controller.get_rows(sql)
        if not rows or rows is None or rows == '':
            message = "Check fields from table or view"
            tools_gw.show_warning(message, parameter=viewname)
            return

        columns = []
        for row in rows:
            columns.append(str(row[0]))

        if self.update:
            if columns:
                sql = "UPDATE " + tablename + " SET "
                for column_name in columns:
                    if column_name != 'psector_id':
                        widget_type = tools_qt.get_widget_type(self.dlg_plan_psector, column_name)
                        if widget_type is QCheckBox:
                            value = tools_qt.isChecked(self.dlg_plan_psector, column_name)
                        elif widget_type is QDateEdit:
                            date = self.dlg_plan_psector.findChild(QDateEdit, str(column_name))
                            value = date.dateTime().toString('yyyy-MM-dd HH:mm:ss')
                        elif widget_type is QComboBox:
                            combo = tools_qt.get_widget(self.dlg_plan_psector, column_name)
                            value = str(tools_qt.get_combo_value(self.dlg_plan_psector, combo))
                        else:
                            value = tools_qt.get_text(self.dlg_plan_psector, column_name)
                        if value is None or value == 'null':
                            sql += column_name + " = null, "
                        else:
                            if type(value) is not bool:
                                value = value.replace(",", ".")
                            sql += f"{column_name} = $${value}$$, "

                sql = sql[:len(sql) - 2]
                sql += f" WHERE psector_id = '{tools_qt.get_text(self.dlg_plan_psector, self.psector_id)}'"

        else:
            values = "VALUES("
            if columns:
                sql = f"INSERT INTO {tablename} ("
                for column_name in columns:
                    if column_name != 'psector_id':
                        widget_type = tools_qt.get_widget_type(self.dlg_plan_psector, column_name)
                        if widget_type is not None:
                            value = None
                            if widget_type is QCheckBox:
                                value = str(tools_qt.isChecked(self.dlg_plan_psector, column_name)).upper()
                            elif widget_type is QDateEdit:
                                date = self.dlg_plan_psector.findChild(QDateEdit, str(column_name))
                                values += date.dateTime().toString('yyyy-MM-dd HH:mm:ss') + ", "
                            elif widget_type is QComboBox:
                                combo = tools_qt.get_widget(self.dlg_plan_psector, column_name)
                                value = str(tools_qt.get_combo_value(self.dlg_plan_psector, combo))
                            else:
                                value = tools_qt.get_text(self.dlg_plan_psector, column_name)

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
            new_psector_id = self.controller.execute_returning(sql)
            tools_qt.set_widget_text(self.dlg_plan_psector, self.dlg_plan_psector.psector_id, str(new_psector_id[0]))
            if new_psector_id:
                row = tools_gw.get_config('plan_psector_vdefault')
                if row:
                    sql = (f"UPDATE config_param_user "
                           f" SET value = $${new_psector_id[0]}$$ "
                           f" WHERE parameter = 'plan_psector_vdefault'"
                           f" AND cur_user=current_user; ")
                else:
                    sql = (f"INSERT INTO config_param_user (parameter, value, cur_user) "
                           f" VALUES ('plan_psector_vdefault', '{new_psector_id[0]}', current_user);")
                self.controller.execute_sql(sql)
        else:
            self.controller.execute_sql(sql)

        self.dlg_plan_psector.tabWidget.setTabEnabled(1, True)
        self.delete_psector_selector('selector_plan_psector')
        self.insert_psector_selector('selector_plan_psector', 'psector_id',
                                     tools_qt.get_text(self.dlg_plan_psector, self.dlg_plan_psector.psector_id))
                
        if close_dlg:
            json_result = self.set_plan()
            if 'status' in json_result and json_result['status'] == 'Accepted':
                self.reload_states_selector()
                tools_gw.close_dialog(self.dlg_plan_psector)

            
    def set_plan(self):

        # TODO: Check this
        extras = f'"psectorId":"{tools_qt.get_text(self.dlg_plan_psector, self.psector_id)}"'
        body = tools_gw.create_body(extras=extras)
        json_result = tools_gw.get_json('gw_fct_setplan', body, log_sql=True)
        return json_result
        
        
    def price_selector(self, dialog, tableleft, tableright, field_id_right):

        # fill QTableView all_rows
        tbl_all_rows = dialog.findChild(QTableView, "all_rows")
        tbl_all_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.fill_table(dialog, tbl_all_rows, tableleft)
        tools_gw.set_tablemodel_config(dialog, tbl_all_rows, tableleft)

        # fill QTableView selected_rows
        tbl_selected_rows = dialog.findChild(QTableView, "selected_rows")
        tbl_selected_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
        expr = f" psector_id = '{tools_qt.get_text(dialog, 'psector_id')}'"
        # Refresh model with selected filter
        self.fill_table(dialog, tbl_selected_rows, tableright, True, QTableView.DoubleClicked, expr)
        tools_gw.set_tablemodel_config(dialog, tbl_selected_rows, tableright)

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
            tools_gw.show_warning(message)
            return
        expl_id = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = tbl_all_rows.model().record(row).value(id_ori)
            expl_id.append(id_)

        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            values = ""
            psector_id = tools_qt.get_text(dialog, 'psector_id')
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
                tools_qt.show_info_box(message, "Info", parameter=str(expl_id[i]))
            else:
                sql = (f"INSERT INTO {tableright}"
                       f" (psector_id, unit, price_id, descript, price) "
                       f" VALUES ({values})")
                self.controller.execute_sql(sql)

        # Refresh
        expr = f" psector_id = '{tools_qt.get_text(dialog, 'psector_id')}'"
        # Refresh model with selected filter
        self.fill_table(dialog, tbl_selected_rows, tableright, True, QTableView.DoubleClicked, expr)
        tools_gw.set_tablemodel_config(dialog, tbl_selected_rows, tableright)
        self.update_total(self.dlg_plan_psector, self.dlg_plan_psector.selected_rows)


    def rows_unselector(self, dialog, tbl_selected_rows, tableright, field_id_right):

        query = (f"DELETE FROM {tableright}"
                 f" WHERE {tableright}.{field_id_right} = ")
        selected_list = tbl_selected_rows.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_gw.show_warning(message)
            return
        expl_id = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = str(tbl_selected_rows.model().record(row).value(field_id_right))
            expl_id.append(id_)
        for i in range(0, len(expl_id)):
            sql = (f"{query}'{expl_id[i]}'"
                   f" AND psector_id = '{tools_qt.get_text(dialog, 'psector_id')}'")
            self.controller.execute_sql(sql)

        # Refresh
        expr = f" psector_id = '{tools_qt.get_text(dialog, 'psector_id')}'"
        # Refresh model with selected filter
        self.fill_table(dialog, tbl_selected_rows, tableright, True, QTableView.DoubleClicked, expr)
        tools_gw.set_tablemodel_config(dialog, tbl_selected_rows, tableright)
        self.update_total(self.dlg_plan_psector, self.dlg_plan_psector.selected_rows)


    def query_like_widget_text(self, dialog, text_line, qtable, tableleft, tableright, field_id):
        """ Populate the QTableView by filtering through the QLineEdit"""

        schema_name = self.schema_name.replace('"', '')
        query = tools_qt.get_text(dialog, text_line).lower()
        if query == 'null':
            query = ""
        sql = (f"SELECT * FROM {schema_name}.{tableleft} WHERE LOWER ({field_id})"
               f" LIKE '%{query}%' AND {field_id} NOT IN ("
               f" SELECT price_id FROM {tableright}"
               f" WHERE psector_id = '{tools_qt.get_text(dialog, 'psector_id')}')")
        self.fill_table_by_query(qtable, sql)


    def fill_table_by_query(self, qtable, query):
        """
        :param qtable: QTableView to show
        :param query: query to set model
        """

        model = QSqlQueryModel()
        model.setQuery(query, db=self.controller.db)
        qtable.setModel(model)
        qtable.show()

        # Check for errors
        if model.lastError().isValid():
            tools_gw.show_warning(model.lastError().text())


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
        model = QSqlTableModel(db=self.controller.db)
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
            tools_gw.show_warning(model.lastError().text())
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
            if str(widget.model().record(row).value('psector_id')) != tools_qt.get_text(dialog, 'psector_id'):
                widget.hideRow(i)


    def document_insert(self):
        """ Insert a document related to the current visit """

        doc_id = self.doc_id.text()
        psector_id = self.psector_id.text()
        if not doc_id:
            message = "You need to insert doc_id"
            tools_gw.show_warning(message)
            return
        if not psector_id:
            message = "You need to insert psector_id"
            tools_gw.show_warning(message)
            return

        # Check if document already exist
        sql = (f"SELECT doc_id"
               f" FROM doc_x_psector"
               f" WHERE doc_id = '{doc_id}' AND psector_id = '{psector_id}'")
        row = self.controller.get_row(sql)
        if row:
            msg = "Document already exist"
            tools_gw.show_warning(msg)
            return

        # Insert into new table
        sql = (f"INSERT INTO doc_x_psector (doc_id, psector_id)"
               f" VALUES ('{doc_id}', {psector_id})")
        status = self.controller.execute_sql(sql)
        if status:
            message = "Document inserted successfully"
            tools_gw.show_info(message)

        self.dlg_plan_psector.tbl_document.model().select()


    def manage_document(self, qtable):
        """ Access GUI to manage documents e.g Execute action of button 34 """

        psector_id = tools_qt.get_text(self.dlg_plan_psector, self.dlg_plan_psector.psector_id)
        manage_document = GwDocument(single_tool=False)
        dlg_docman = manage_document.manage_document(tablename='psector', qtable=qtable, item_id=psector_id)
        dlg_docman.btn_accept.clicked.connect(partial(tools_gw.set_completer_object, dlg_docman, 'doc'))
        tools_qt.remove_tab(dlg_docman.tabWidget, 'tab_rel')


    def show_status_warning(self):

        msg = "WARNING: You have updated the status value. If you click 'Accept' on the main dialog, " \
              "a process that updates the state & state_type values of all that features that belong to the psector, " \
              "according to the system variables plan_psector_statetype, " \
              "plan_statetype_planned and plan_statetype_ficticious, will be triggered."
        tools_qt.show_details(msg, 'Message warning')


    def hilight_feature_by_id(self, qtable, layer_name, field_id, rubber_band, width, index):
        """ Based on the received index and field_id, the id of the received field_id is searched within the table
         and is painted in red on the canvas """

        rubber_band.reset()
        layer = tools_qgis.get_layer_by_tablename(layer_name)
        if not layer: return

        row = index.row()
        column_index = tools_qt.get_col_index_by_col_name(qtable, field_id)
        _id = index.sibling(row, column_index).data()
        feature = tools_qt.get_feature_by_id(layer, _id, field_id)
        try:
            geometry = feature.geometry()
            rubber_band.setToGeometry(geometry, None)
            rubber_band.setColor(QColor(255, 0, 0, 100))
            rubber_band.setWidth(width)
            rubber_band.show()
        except AttributeError:
            pass


    def master_new_psector(self, psector_id=None):
        """ Button 45: New psector """
        self.new_psector(psector_id, 'plan')


    def master_psector_mangement(self):
        """ Button 46: Psector management """

        # Create the dialog and signals
        self.dlg_psector_mng = PsectorManagerUi()

        tools_gw.load_settings(self.dlg_psector_mng)
        table_name = "v_ui_plan_psector"
        column_id = "psector_id"

        # Tables
        self.qtbl_psm = self.dlg_psector_mng.findChild(QTableView, "tbl_psm")
        self.qtbl_psm.setSelectionBehavior(QAbstractItemView.SelectRows)

        # Set signals
        self.dlg_psector_mng.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_psector_mng))
        self.dlg_psector_mng.rejected.connect(partial(tools_gw.close_dialog, self.dlg_psector_mng))
        self.dlg_psector_mng.btn_delete.clicked.connect(partial(
            self.multi_rows_delete, self.dlg_psector_mng, self.qtbl_psm, table_name, column_id, 'lbl_vdefault_psector', 'psector'))
        self.dlg_psector_mng.btn_update_psector.clicked.connect(
            partial(self.update_current_psector, self.dlg_psector_mng, self.qtbl_psm))
        self.dlg_psector_mng.btn_duplicate.clicked.connect(self.psector_duplicate)
        self.dlg_psector_mng.txt_name.textChanged.connect(
            partial(self.filter_by_text, self.dlg_psector_mng, self.qtbl_psm, self.dlg_psector_mng.txt_name,
                    table_name))
        self.dlg_psector_mng.tbl_psm.doubleClicked.connect(partial(self.charge_psector, self.qtbl_psm))
        self.fill_table(self.dlg_psector_mng, self.qtbl_psm, table_name)
        tools_gw.set_tablemodel_config(self.dlg_psector_mng, self.qtbl_psm, table_name)
        self.set_label_current_psector(self.dlg_psector_mng)

        # Open form
        self.dlg_psector_mng.setWindowFlags(Qt.WindowStaysOnTopHint)
        tools_gw.open_dialog(self.dlg_psector_mng, dlg_name="psector_manager")


    def update_current_psector(self, dialog, qtbl_psm):

        selected_list = qtbl_psm.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_gw.show_warning(message)
            return
        row = selected_list[0].row()
        psector_id = qtbl_psm.model().record(row).value("psector_id")
        aux_widget = QLineEdit()
        aux_widget.setText(str(psector_id))
        self.upsert_config_param_user(dialog, aux_widget, "plan_psector_vdefault")

        message = "Values has been updated"
        tools_gw.show_info(message)

        self.fill_table(dialog, qtbl_psm, "v_ui_plan_psector")
        tools_gw.set_tablemodel_config(dialog, qtbl_psm, "v_ui_plan_psector")
        self.set_label_current_psector(dialog)
        tools_gw.open_dialog(dialog)


    def upsert_config_param_user(self, dialog, widget, parameter):
        """ Insert or update values in tables with current_user control """

        tablename = "config_param_user"
        sql = (f"SELECT * FROM {tablename}"
               f" WHERE cur_user = current_user")
        rows = self.controller.get_rows(sql)
        exist_param = False
        if type(widget) != QDateEdit:
            if tools_qt.get_text(dialog, widget) != "":
                for row in rows:
                    if row[0] == parameter:
                        exist_param = True
                if exist_param:
                    sql = f"UPDATE {tablename} SET value = "
                    if widget.objectName() != 'edit_state_vdefault':
                        sql += (f"'{tools_qt.get_text(dialog, widget)}'"
                                f" WHERE cur_user = current_user AND parameter = '{parameter}'")
                    else:
                        sql += (f"(SELECT id FROM value_state"
                                f" WHERE name = '{tools_qt.get_text(dialog, widget)}')"
                                f" WHERE cur_user = current_user AND parameter = 'edit_state_vdefault'")
                else:
                    sql = f'INSERT INTO {tablename} (parameter, value, cur_user)'
                    if widget.objectName() != 'edit_state_vdefault':
                        sql += f" VALUES ('{parameter}', '{tools_qt.get_text(dialog, widget)}', current_user)"
                    else:
                        sql += (f" VALUES ('{parameter}',"
                                f" (SELECT id FROM value_state"
                                f" WHERE name = '{tools_qt.get_text(dialog, widget)}'), current_user)")
        else:
            for row in rows:
                if row[0] == parameter:
                    exist_param = True
            _date = widget.dateTime().toString('yyyy-MM-dd')
            if exist_param:
                sql = (f"UPDATE {tablename}"
                       f" SET value = '{_date}'"
                       f" WHERE cur_user = current_user AND parameter = '{parameter}'")
            else:
                sql = (f"INSERT INTO {tablename} (parameter, value, cur_user)"
                       f" VALUES ('{parameter}', '{_date}', current_user);")
        self.controller.execute_sql(sql)


    def filter_by_text(self, dialog, table, widget_txt, tablename):

        result_select = tools_qt.get_text(dialog, widget_txt)
        if result_select != 'null':
            expr = f" name ILIKE '%{result_select}%'"
            # Refresh model with selected filter
            table.model().setFilter(expr)
            table.model().select()
        else:
            self.fill_table(dialog, table, tablename)


    def charge_psector(self, qtbl_psm):

        selected_list = qtbl_psm.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_gw.show_warning(message)
            return
        row = selected_list[0].row()
        psector_id = qtbl_psm.model().record(row).value("psector_id")
        tools_gw.close_dialog(self.dlg_psector_mng)
        self.master_new_psector(psector_id)


    def multi_rows_delete(self, dialog, widget, table_name, column_id, label, action):
        """ Delete selected elements of the table
        :param QTableView widget: origin
        :param table_name: table origin
        :param column_id: Refers to the id of the source table
        """
        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_gw.show_warning(message)
            return
        cur_psector = tools_gw.get_config('plan_psector_vdefault')
        inf_text = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = widget.model().record(row).value(str(column_id))
            if cur_psector is not None and (str(id_) == str(cur_psector[0])):
                message = ("You are trying to delete your current psector. "
                           "Please, change your current psector before delete.")
                tools_gw.show_exceptions_msg('Current psector', tools_gw.tr(message))
                return
            inf_text += f'"{id_}", '
            list_id += f'"{id_}", '
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]

        if action == 'psector':
            feature = f'"id":[{inf_text}], "featureType":"PSECTOR"'
            body = tools_gw.create_body(feature=feature)
            result = tools_gw.get_json('gw_fct_getcheckdelete', body, log_sql=True)
            if result['status'] == "Accepted":
                if result['message']:
                    answer = tools_qt.ask_question(result['message']['text'])
                    if answer:
                        feature += f', "tableName":"{table_name}", "idName":"{column_id}"'
                        body = tools_gw.create_body(feature=feature)
                        result = tools_gw.get_json('gw_fct_setdelete', body, log_sql=True)

        elif action == 'price':
            message = "Are you sure you want to delete these records?"
            answer = tools_qt.ask_question(message, "Delete records", inf_text)
            if answer:
                sql = "DELETE FROM selector_plan_result WHERE result_id in ("
                if list_id != '':
                    sql += f"{list_id}) AND cur_user = current_user;"
                    self.controller.execute_sql(sql)
                    tools_qt.set_widget_text(dialog, label, '')
                sql = (f"DELETE FROM {table_name}"
                       f" WHERE {column_id} IN ({list_id});")
                self.controller.execute_sql(sql)
        widget.model().select()


    def master_estimate_result_manager(self):
        """ Button 50: Plan estimate result manager """

        # Create the dialog and signals
        self.dlg_merm = PriceManagerUi()
        tools_gw.load_settings(self.dlg_merm)

        # Set current value
        sql = (f"SELECT name FROM plan_result_cat WHERE result_id IN (SELECT result_id FROM selector_plan_result "
               f"WHERE cur_user = current_user)")
        row = self.controller.get_row(sql)
        if row:
            tools_qt.set_widget_text(self.dlg_merm, 'lbl_vdefault_price', str(row[0]))

        # Tables
        tablename = 'plan_result_cat'
        self.tbl_om_result_cat = self.dlg_merm.findChild(QTableView, "tbl_om_result_cat")
        tools_qt.set_qtv_config(self.tbl_om_result_cat)

        # Set signals
        self.dlg_merm.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_merm))
        self.dlg_merm.rejected.connect(partial(tools_gw.close_dialog, self.dlg_merm))
        self.dlg_merm.btn_delete.clicked.connect(partial(self.delete_merm, self.dlg_merm))
        self.dlg_merm.btn_update_result.clicked.connect(partial(self.update_price_vdefault))
        self.dlg_merm.txt_name.textChanged.connect(partial(self.filter_merm, self.dlg_merm, tablename))

        # set_edit_strategy = QSqlTableModel.OnManualSubmit
        self.fill_table(self.dlg_merm, self.tbl_om_result_cat, tablename)
        tools_gw.set_tablemodel_config(self.tbl_om_result_cat, self.dlg_merm.tbl_om_result_cat, tablename)

        # Open form
        self.dlg_merm.setWindowFlags(Qt.WindowStaysOnTopHint)
        tools_gw.open_dialog(self.dlg_merm, dlg_name="price_manager")


    def update_price_vdefault(self):
        selected_list = self.dlg_merm.tbl_om_result_cat.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_gw.show_warning(message)
            return
        row = selected_list[0].row()
        price_name = self.dlg_merm.tbl_om_result_cat.model().record(row).value("name")
        result_id = self.dlg_merm.tbl_om_result_cat.model().record(row).value("result_id")
        tools_qt.set_widget_text(self.dlg_merm, 'lbl_vdefault_price', price_name)
        sql = (f"DELETE FROM selector_plan_result WHERE current_user = cur_user;"
               f"\nINSERT INTO selector_plan_result (result_id, cur_user)"
               f" VALUES({result_id}, current_user);")
        status = self.controller.execute_sql(sql)
        if status:
            message = "Values has been updated"
            tools_gw.show_info(message)

        # Refresh canvas
        self.iface.mapCanvas().refreshAllLayers()


    def delete_merm(self, dialog):
        """ Delete selected row from 'master_estimate_result_manager' dialog from selected tab """

        self.multi_rows_delete(dialog, dialog.tbl_om_result_cat, 'plan_result_cat',
                               'result_id', 'lbl_vdefault_price', 'price')


    def filter_merm(self, dialog, tablename):
        """ Filter rows from 'master_estimate_result_manager' dialog from selected tab """
        self.filter_by_text(dialog, dialog.tbl_om_result_cat, dialog.txt_name, tablename)


    def psector_duplicate(self):
        """" Button 51: Duplicate psector """

        selected_list = self.qtbl_psm.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_gw.show_warning(message)
            return
        row = selected_list[0].row()
        psector_id = self.qtbl_psm.model().record(row).value("psector_id")
        self.duplicate_psector = GwPsectorDuplicate()
        self.duplicate_psector.is_duplicated.connect(partial(self.fill_table, self.dlg_psector_mng, self.qtbl_psm, 'v_ui_plan_psector'))
        self.duplicate_psector.is_duplicated.connect(partial(self.set_label_current_psector, self.dlg_psector_mng))
        self.duplicate_psector.manage_duplicate_psector(psector_id)


    def set_label_current_psector(self, dialog):

        sql = ("SELECT t1.name FROM plan_psector AS t1 "
               " INNER JOIN config_param_user AS t2 ON t1.psector_id::text = t2.value "
               " WHERE t2.parameter='plan_psector_vdefault' AND cur_user = current_user")
        row = global_vars.controller.get_row(sql)
        if not row:
            return
        tools_qt.set_widget_text(dialog, 'lbl_vdefault_psector', row[0])


    def zoom_to_selected_features(self, layer, geom_type=None, zoom=None):
        """ Zoom to selected features of the @layer with @geom_type """

        if not layer:
            return

        global_vars.iface.setActiveLayer(layer)
        global_vars.iface.actionZoomToSelected().trigger()

        if geom_type and zoom:

            # Set scale = scale_zoom
            if geom_type in ('node', 'connec', 'gully'):
                scale = zoom

            # Set scale = max(current_scale, scale_zoom)
            elif geom_type == 'arc':
                scale = global_vars.iface.mapCanvas().scale()
                if int(scale) < int(zoom):
                    scale = zoom
            else:
                scale = 5000

            if zoom is not None:
                scale = zoom

            global_vars.iface.mapCanvas().zoomScale(float(scale))