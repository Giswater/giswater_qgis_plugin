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
import re
import sys
from collections import OrderedDict
from functools import partial
from sip import isdeleted

from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtGui import QDoubleValidator, QIntValidator, QKeySequence, QColor
from qgis.PyQt.QtSql import QSqlQueryModel, QSqlTableModel
from qgis.PyQt.QtWidgets import QAbstractItemView, QAction, QCheckBox, QComboBox, QDateEdit, QLabel, \
    QLineEdit, QTableView, QWidget, QDoubleSpinBox, QTextEdit, QPushButton, QGridLayout
from qgis.core import QgsLayoutExporter, QgsProject, QgsRectangle, QgsPointXY, QgsGeometry
from qgis.gui import QgsMapToolEmitPoint

from .document import GwDocument, global_vars
from ..shared.psector_duplicate import GwPsectorDuplicate
from ..toolbars.edit.arc_fusion_button import GwArcFusionButton
from ..ui.ui_manager import GwPsectorUi, GwPsectorRapportUi, GwPsectorManagerUi, GwPriceManagerUi, GwReplaceArc
from ..utils import tools_gw
from ...lib import tools_db, tools_qgis, tools_qt, tools_log, tools_os
from ..utils.snap_manager import GwSnapManager


class GwPsector:

    def __init__(self):
        """ Class to control 'New Psector' of toolbar 'master' """

        self.iface = global_vars.iface
        self.canvas = global_vars.canvas
        self.schema_name = global_vars.schema_name
        self.rubber_band = tools_gw.create_rubberband(self.canvas)
        self.emit_point = None
        self.vertex_marker = None
        self.dict_to_update = {}
        self.my_json = {}


    def get_psector(self, psector_id=None, list_coord=None):
        """ Buttons 45 and 81: New psector """

        row = tools_gw.get_config_value(parameter='admin_currency', columns='value::text', table='config_param_system')
        if row:
            self.sys_currency = json.loads(row[0], object_pairs_hook=OrderedDict)

        # Create the dialog and signals
        self.dlg_plan_psector = GwPsectorUi()
        tools_gw.load_settings(self.dlg_plan_psector)

        # Capture the current layer to return it at the end of the operation
        cur_active_layer = self.iface.activeLayer()
        widget_list = self.dlg_plan_psector.findChildren(QTableView)
        for widget in widget_list:
            tools_qt.set_tableview_config(widget)
        self.project_type = tools_gw.get_project_type()

        # Get layers of every feature_type
        self.list_elemets = {}
        self.dict_to_update = {}

        # Get layers of every feature_type

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
        self.layers['gully'] = []
        self.layers['element'] = []
        self.layers['arc'] = tools_gw.get_layers_from_feature_type('arc')
        self.layers['node'] = tools_gw.get_layers_from_feature_type('node')
        self.layers['connec'] = tools_gw.get_layers_from_feature_type('connec')
        if self.project_type.upper() == 'UD':
            self.layers['gully'] = tools_gw.get_layers_from_feature_type('gully')
        else:
            tools_qt.remove_tab(self.dlg_plan_psector.tab_feature, 'tab_gully')

        self.update = False  # if false: insert; if true: update

        self.feature_type = "arc"

        self.all_layers_checked = self._check_for_layers()
        if self.all_layers_checked:
            tools_qt.set_checked(self.dlg_plan_psector, self.dlg_plan_psector.chk_enable_all, True)

        # Remove all previous selections
        self.layers = tools_gw.remove_selection(True, layers=self.layers)

        # Set icons
        tools_gw.add_icon(self.dlg_plan_psector.btn_insert, "111", sub_folder="24x24")
        tools_gw.add_icon(self.dlg_plan_psector.btn_delete, "112", sub_folder="24x24")
        tools_gw.add_icon(self.dlg_plan_psector.btn_snapping, "137")
        tools_gw.add_icon(self.dlg_plan_psector.btn_select_arc, "310", sub_folder="24x24")
        tools_gw.add_icon(self.dlg_plan_psector.btn_arc_fusion, "17", sub_folder="24x24")
        tools_gw.add_icon(self.dlg_plan_psector.btn_set_to_arc, "209")
        tools_gw.add_icon(self.dlg_plan_psector.btn_doc_insert, "111", sub_folder="24x24")
        tools_gw.add_icon(self.dlg_plan_psector.btn_doc_delete, "112", sub_folder="24x24")
        tools_gw.add_icon(self.dlg_plan_psector.btn_doc_new, "34", sub_folder="24x24")
        tools_gw.add_icon(self.dlg_plan_psector.btn_open_doc, "170")

        table_object = "psector"

        # tab General elements
        self.psector_id = self.dlg_plan_psector.findChild(QLineEdit, "psector_id")
        self.ext_code = self.dlg_plan_psector.findChild(QLineEdit, "ext_code")
        self.cmb_psector_type = self.dlg_plan_psector.findChild(QComboBox, "psector_type")
        self.cmb_expl_id = self.dlg_plan_psector.findChild(QComboBox, "expl_id")
        self.cmb_status = self.dlg_plan_psector.findChild(QComboBox, "status")
        self.workcat_id = self.dlg_plan_psector.findChild(QComboBox, "workcat_id")
        self.parent_id = self.dlg_plan_psector.findChild(QLineEdit, "parent_id")

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

        # Manage other_price tab variables
        self.price_loaded = False
        self.header_exist = None
        self.load_signals = False

        # Populate combo status
        sql = "SELECT id, idval FROM plan_typevalue WHERE typevalue = 'value_priority'"
        rows = tools_db.get_rows(sql)

        tools_qt.fill_combo_values(self.dlg_plan_psector.priority, rows, 1)

        # Populate combo expl_id
        sql = ("SELECT expl_id, name from exploitation "
               " JOIN selector_expl USING (expl_id) "
               " WHERE exploitation.expl_id != 0 and cur_user = current_user")
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.cmb_expl_id, rows, 1)

        # Populate combo workcat_id
        sql = "SELECT id as id, id as idval FROM cat_work"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_plan_psector.workcat_id, rows, add_empty=True)

        # Populate combo status
        sql = "SELECT id, idval FROM plan_typevalue WHERE typevalue = 'psector_status'"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.cmb_status, rows, 1)

        # tab Bugdet
        gexpenses = self.dlg_plan_psector.findChild(QLineEdit, "gexpenses")
        tools_qt.double_validator(gexpenses)
        vat = self.dlg_plan_psector.findChild(QLineEdit, "vat")
        tools_qt.double_validator(vat)
        other = self.dlg_plan_psector.findChild(QLineEdit, "other")
        tools_qt.double_validator(other)

        self.set_tabs_enabled(False)
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
        all_rows.horizontalHeader().setSectionResizeMode(3)

        # if a row is selected from mg_psector_mangement(button 46 or button 81)
        # if psector_id contains "1" or "0" python takes it as boolean, if it is True, it means that it does not
        # contain a value and therefore it is a new one. We convert that value to 0 since no id will be 0 in this way
        # if psector_id has a value other than 0, it is that the sector already exists and we want to do an update.
        if isinstance(psector_id, bool):
            psector_id = 0
        self.delete_psector_selector('selector_plan_psector')

        # tab 'Document'
        self.doc_id = self.dlg_plan_psector.findChild(QLineEdit, "doc_id")
        self.tbl_document = self.dlg_plan_psector.findChild(QTableView, "tbl_document")

        if psector_id is not None:

            self.set_tabs_enabled(True)
            self.enable_buttons(True)
            self.dlg_plan_psector.name.setEnabled(True)
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
                   f"text3, text4, text5, text6, num_value, observ, atlas_id, scale, rotation, active, ext_code, status, workcat_id, parent_id"
                   f" FROM plan_psector "
                   f"WHERE psector_id = {psector_id}")
            row = tools_db.get_row(sql)

            if not row:
                return

            self.dlg_plan_psector.setWindowTitle(f"Plan psector - {row['name']} ({row['psector_id']})")
            self.psector_id.setText(str(row['psector_id']))
            if str(row['ext_code']) != 'None':
                self.ext_code.setText(str(row['ext_code']))
            sql = (f"SELECT id, idval FROM plan_typevalue WHERE typevalue = 'psector_type' AND "
                   f"id = '{row['psector_type']}'")
            result = tools_db.get_row(sql)
            tools_qt.set_combo_value(self.cmb_psector_type, str(result['idval']), 1)
            sql = (f"SELECT name FROM exploitation "
                   f"WHERE expl_id = {row['expl_id']}")
            result = tools_db.get_row(sql)
            tools_qt.set_combo_value(self.cmb_expl_id, str(result['name']), 1)
            tools_qt.set_combo_value(self.cmb_status, str(row['status']), 0)
            # Check if expl_id already exists in expl_selector
            sql = ("SELECT DISTINCT(expl_id, cur_user)"
                   " FROM selector_expl"
                   f" WHERE expl_id = '{row['expl_id']}' AND cur_user = current_user")
            exist = tools_db.get_row(sql)
            if exist is None:
                sql = ("INSERT INTO selector_expl (expl_id, cur_user) "
                       f" VALUES ({str(row['expl_id'])}, current_user)"
                       f" ON CONFLICT DO NOTHING;")
                tools_db.execute_sql(sql)
                msg = "Your exploitation selector has been updated"
                tools_qgis.show_warning(msg, 1, dialog=self.dlg_plan_psector)
            workcat_id = row['workcat_id']
            tools_qt.set_combo_value(self.workcat_id, workcat_id, 0)

            tools_qt.set_checked(self.dlg_plan_psector, "active", row['active'])
            self.fill_widget(self.dlg_plan_psector, "name", row)
            self.fill_widget(self.dlg_plan_psector, "descript", row)
            tools_qt.set_combo_value(self.dlg_plan_psector.priority, str(row["priority"]), 0)
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
            self.fill_widget(self.dlg_plan_psector, "parent_id", row)

            # Fill tables tbl_arc_plan, tbl_node_plan, tbl_v_plan/om_other_x_psector with selected filter
            expr = " psector_id = " + str(psector_id)
            self.qtbl_arc.model().setFilter(expr)
            self.qtbl_arc.model().select()
            self.qtbl_arc.clicked.connect(
                partial(tools_qgis.hilight_feature_by_id, self.qtbl_arc, "v_edit_arc", "arc_id", self.rubber_band, 5))

            expr = " psector_id = " + str(psector_id)
            self.qtbl_node.model().setFilter(expr)
            self.qtbl_node.model().select()
            self.qtbl_node.clicked.connect(partial(
                tools_qgis.hilight_feature_by_id, self.qtbl_node, "v_edit_node", "node_id", self.rubber_band, 10))

            expr = " psector_id = " + str(psector_id)
            self.qtbl_connec.model().setFilter(expr)
            self.qtbl_connec.model().select()
            self.qtbl_connec.clicked.connect(partial(
                tools_qgis.hilight_feature_by_id, self.qtbl_connec, "v_edit_connec", "connec_id", self.rubber_band, 10))
            self.qtbl_connec.clicked.connect(partial(self._enable_set_to_arc))

            if self.project_type.upper() == 'UD':
                expr = " psector_id = " + str(psector_id)
                self.qtbl_gully.model().setFilter(expr)
                self.qtbl_gully.model().select()
                self.qtbl_gully.clicked.connect(partial(
                    tools_qgis.hilight_feature_by_id, self.qtbl_gully, "v_edit_gully", "gully_id", self.rubber_band, 10))
                self.qtbl_gully.clicked.connect(partial(self._enable_set_to_arc))

            self.populate_budget(self.dlg_plan_psector, psector_id)
            self.update = True
            psector_id_aux = tools_qt.get_text(self.dlg_plan_psector, self.dlg_plan_psector.psector_id)
            if psector_id_aux != 'null':
                sql = (f"DELETE FROM selector_plan_psector "
                       f"WHERE cur_user = current_user")
                tools_db.execute_sql(sql)
                self.insert_psector_selector('selector_plan_psector', 'psector_id', psector_id_aux)
            sql = (f"DELETE FROM selector_psector "
                   f"WHERE cur_user = current_user AND psector_id = '{psector_id_aux}'")
            tools_db.execute_sql(sql)
            self.insert_psector_selector('selector_psector', 'psector_id', psector_id_aux)

            self.dlg_plan_psector.rejected.connect(self.rubber_band.reset)

            if not list_coord:

                sql = f"SELECT st_astext(st_envelope(the_geom)) FROM v_edit_plan_psector WHERE psector_id = {psector_id}"
                row = tools_db.get_row(sql)
                if row[0]:
                    list_coord = re.search('\(\((.*)\)\)', str(row[0]))

            if list_coord:
                # Get canvas extend in order to create a QgsRectangle
                ext = self.canvas.extent()
                start_point = QgsPointXY(ext.xMinimum(), ext.yMaximum())
                end_point = QgsPointXY(ext.xMaximum(), ext.yMinimum())
                canvas_rec = QgsRectangle(start_point, end_point)
                canvas_width = ext.xMaximum() - ext.xMinimum()
                canvas_height = ext.yMaximum() - ext.yMinimum()

                points = tools_qgis.get_geometry_vertex(list_coord)
                polygon = QgsGeometry.fromPolygonXY([points])
                psector_rec = polygon.boundingBox()
                tools_gw.reset_rubberband(self.rubber_band)
                rb_duration = tools_gw.get_config_parser("system", "show_psector_ruberband_duration", "user", "init", prefix=False)
                if rb_duration == "0": rb_duration = None
                tools_qgis.draw_polygon(points, self.rubber_band, duration_time=rb_duration)

                # Manage Zoom to rectangle
                if not canvas_rec.intersects(psector_rec) or (psector_rec.width() < (canvas_width * 10) / 100 or psector_rec.height() < (canvas_height * 10) / 100):
                    max_x, max_y, min_x, min_y = tools_qgis.get_max_rectangle_from_coords(list_coord)
                    tools_qgis.zoom_to_rectangle(max_x, max_y, min_x, min_y, margin=50)

            filter_ = "psector_id = '" + str(psector_id) + "'"
            message = tools_qt.fill_table(self.tbl_document, f"v_ui_doc_x_psector", filter_)
            if message:
                tools_qgis.show_warning(message, dialog=self.dlg_plan_psector)
            self.tbl_document.doubleClicked.connect(partial(tools_qt.document_open, self.tbl_document, 'path'))

            self._connect_editing_finished()
        else:
            # Set psector_status vdefault
            sql = "SELECT id, idval FROM plan_typevalue WHERE typevalue = 'psector_status' and id = '2'"
            result = tools_db.get_row(sql)
            tools_qt.set_combo_value(self.cmb_status, str(result[1]), 1)

            # Set check active True as default for new pesectors
            tools_qt.set_checked(self.dlg_plan_psector, "active", True)

        if self.dlg_plan_psector.tab_feature.currentIndex() != 1:
            self.dlg_plan_psector.btn_arc_fusion.setEnabled(False)
        if self.dlg_plan_psector.tab_feature.currentIndex() not in (2, 3):
            self.dlg_plan_psector.btn_set_to_arc.setEnabled(False)

        sql = "SELECT state_id FROM selector_state WHERE cur_user = current_user"
        rows = tools_db.get_rows(sql)
        self.all_states = rows
        self.delete_psector_selector('selector_state')
        self.insert_psector_selector('selector_state', 'state_id', '1')

        # Exclude the layer v_edit_element for adding relations
        self.excluded_layers = ['v_edit_element']

        # Set signals
        excluded_layers = ["v_edit_arc", "v_edit_node", "v_edit_connec", "v_edit_element", "v_edit_gully",
                           "v_edit_element"]
        layers_visibility = tools_gw.get_parent_layers_visibility()
        self.dlg_plan_psector.rejected.connect(partial(tools_gw.restore_parent_layers_visibility, layers_visibility))
        self.dlg_plan_psector.btn_accept.clicked.connect(partial(self._manage_accept, psector_id))
        self.dlg_plan_psector.btn_accept.clicked.connect(
            partial(self.insert_or_update_new_psector, 'v_edit_plan_psector', True))
        self.dlg_plan_psector.tabWidget.currentChanged.connect(partial(self.check_tab_position))
        self.dlg_plan_psector.btn_cancel.clicked.connect(partial(self.close_psector, cur_active_layer))
        if hasattr(self, 'dlg_psector_mng'):
            self.dlg_plan_psector.rejected.connect(partial(self.fill_table, self.dlg_psector_mng, self.qtbl_psm, 'v_ui_plan_psector'))
        self.dlg_plan_psector.rejected.connect(partial(self.close_psector, cur_active_layer))
        self.dlg_plan_psector.chk_enable_all.stateChanged.connect(partial(self._enable_layers))

        self.lbl_descript = self.dlg_plan_psector.findChild(QLabel, "lbl_descript")
        self.dlg_plan_psector.all_rows.clicked.connect(partial(self.show_description))

        self.dlg_plan_psector.btn_delete.setShortcut(QKeySequence(Qt.Key_Delete))

        self.dlg_plan_psector.btn_insert.clicked.connect(
            partial(tools_gw.insert_feature, self, self.dlg_plan_psector, table_object, True, True, None, None))
        self.dlg_plan_psector.btn_delete.clicked.connect(
            partial(tools_gw.delete_records, self, self.dlg_plan_psector, table_object, True, None, None))
        self.dlg_plan_psector.btn_snapping.clicked.connect(
            partial(tools_gw.selection_init, self, self.dlg_plan_psector, table_object, True))
        self.dlg_plan_psector.btn_select_arc.clicked.connect(
            partial(self._replace_arc))
        self.dlg_plan_psector.btn_arc_fusion.clicked.connect(
            partial(self._arc_fusion))
        self.dlg_plan_psector.btn_set_to_arc.clicked.connect(
            partial(self._set_to_arc))


        self.dlg_plan_psector.btn_rapports.clicked.connect(partial(self.open_dlg_rapports))
        self.dlg_plan_psector.tab_feature.currentChanged.connect(
            partial(tools_gw.get_signal_change_tab, self.dlg_plan_psector, excluded_layers))
        self.dlg_plan_psector.tab_feature.currentChanged.connect(
            partial(tools_qgis.disconnect_snapping, False, self.emit_point, self.vertex_marker))
        self.dlg_plan_psector.tab_feature.currentChanged.connect(
            partial(self._manage_tab_feature_buttons))
        self.dlg_plan_psector.name.textChanged.connect(partial(self.enable_relation_tab, 'plan_psector'))
        viewname = 'v_edit_plan_psector_x_other'
        self.dlg_plan_psector.txt_name.textChanged.connect(
            partial(self.query_like_widget_text, self.dlg_plan_psector, self.dlg_plan_psector.txt_name,
                    self.dlg_plan_psector.all_rows, 'v_price_compost', viewname, "id"))

        self.dlg_plan_psector.gexpenses.returnPressed.connect(partial(self.calculate_percents, 'plan_psector', 'gexpenses'))
        self.dlg_plan_psector.vat.returnPressed.connect(partial(self.calculate_percents, 'plan_psector', 'vat'))
        self.dlg_plan_psector.other.returnPressed.connect(partial(self.calculate_percents, 'plan_psector', 'other'))

        self.dlg_plan_psector.btn_doc_insert.clicked.connect(self.document_insert)
        self.dlg_plan_psector.btn_doc_delete.clicked.connect(partial(tools_qt.delete_rows_tableview, self.tbl_document))
        self.dlg_plan_psector.btn_doc_new.clicked.connect(partial(self.manage_document, self.tbl_document))
        self.dlg_plan_psector.btn_open_doc.clicked.connect(partial(tools_qt.document_open, self.tbl_document, 'path'))
        self.cmb_status.currentIndexChanged.connect(partial(self.show_status_warning))

        # Create list for completer QLineEdit
        sql = "SELECT DISTINCT(id) FROM v_ui_document ORDER BY id"
        list_items = tools_db.create_list_for_completer(sql)
        tools_qt.set_completer_lineedit(self.dlg_plan_psector.doc_id, list_items)

        if psector_id is not None:
            sql = (f"SELECT other, gexpenses, vat "
                   f"FROM plan_psector "
                   f"WHERE psector_id = '{psector_id}'")
            row = tools_db.get_row(sql)

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
        viewname = "v_edit_" + self.feature_type
        tools_gw.set_completer_widget(viewname, self.dlg_plan_psector.feature_id, str(self.feature_type) + "_id")

        # Set default tab 'arc'
        self.dlg_plan_psector.tab_feature.setCurrentIndex(0)
        tools_gw.get_signal_change_tab(self.dlg_plan_psector, excluded_layers)

        widget_to_ignore = ('btn_accept', 'btn_cancel', 'btn_rapports', 'btn_open_doc')
        restriction = ('role_basic', 'role_om', 'role_epa', 'role_om')
        self.set_restriction_by_role(self.dlg_plan_psector, widget_to_ignore, restriction)

        # Open dialog
        tools_gw.open_dialog(self.dlg_plan_psector, dlg_name='plan_psector')


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


    def update_total(self, dialog):
        """ Show description of product plan/om _psector as label """

        total_result = 0
        widgets = dialog.tab_other_prices.findChildren(QLabel)
        symbol = tools_gw.get_config_value(parameter="admin_currency", columns="value::json->> 'symbol'",
                                           table="config_param_system")[0]
        for widget in widgets:
            if 'widget_total' in widget.objectName():
                total_result = float(total_result) + float(widget.text().replace(symbol, '').strip())
        tools_qt.set_widget_text(dialog, 'lbl_total_count', f'{"{:.2f}".format(total_result)} {symbol}')


    def open_dlg_rapports(self):

        default_file_name = tools_qt.get_text(self.dlg_plan_psector, self.dlg_plan_psector.name)

        self.dlg_psector_rapport = GwPsectorRapportUi()
        tools_gw.load_settings(self.dlg_psector_rapport)

        tools_qt.set_widget_text(self.dlg_psector_rapport, 'txt_composer_path', default_file_name + " comp.pdf")
        tools_qt.set_widget_text(self.dlg_psector_rapport, 'txt_csv_detail_path', default_file_name + " detail.csv")
        tools_qt.set_widget_text(self.dlg_psector_rapport, 'txt_csv_path', default_file_name + ".csv")

        self.dlg_psector_rapport.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_psector_rapport))
        self.dlg_psector_rapport.btn_ok.clicked.connect(partial(self.generate_rapports))
        self.dlg_psector_rapport.btn_path.clicked.connect(
            partial(tools_qt.get_folder_path, self.dlg_psector_rapport, self.dlg_psector_rapport.txt_path))

        value = tools_gw.get_config_parser('btn_psector', 'psector_rapport_path', "user", "session")
        tools_qt.set_widget_text(self.dlg_psector_rapport, self.dlg_psector_rapport.txt_path, value)
        value = tools_gw.get_config_parser('btn_psector', 'psector_rapport_chk_composer', "user", "session")
        tools_qt.set_checked(self.dlg_psector_rapport, self.dlg_psector_rapport.chk_composer, value)
        value = tools_gw.get_config_parser('btn_psector', 'psector_rapport_chk_csv_detail', "user", "session")
        tools_qt.set_checked(self.dlg_psector_rapport, self.dlg_psector_rapport.chk_csv_detail, value)
        value = tools_gw.get_config_parser('btn_psector', 'psector_rapport_chk_csv', "user", "session")
        tools_qt.set_checked(self.dlg_psector_rapport, self.dlg_psector_rapport.chk_csv, value)

        if tools_qt.get_text(self.dlg_psector_rapport, self.dlg_psector_rapport.txt_path) == 'null':
            if 'nt' in sys.builtin_module_names:
                plugin_dir = os.path.expanduser("~\Documents")
            else:
                plugin_dir = os.path.expanduser("~")
            tools_qt.set_widget_text(self.dlg_psector_rapport, self.dlg_psector_rapport.txt_path, plugin_dir)
        self.populate_cmb_templates()

        # Open dialog
        tools_gw.open_dialog(self.dlg_psector_rapport, dlg_name='psector_rapport')


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

        row = tools_gw.get_config_value(f'composer_plan_vdefault')
        if row:
            tools_qt.set_combo_value(self.dlg_psector_rapport.cmb_templates, row[0], 1)


    def generate_rapports(self):

        txt_path = f"{tools_qt.get_text(self.dlg_psector_rapport, 'txt_path')}"
        tools_gw.set_config_parser('btn_psector', 'psector_rapport_path', txt_path)
        chk_composer = f"{tools_qt.is_checked(self.dlg_psector_rapport, 'chk_composer')}"
        tools_gw.set_config_parser('btn_psector', 'psector_rapport_chk_composer', chk_composer)
        chk_csv_detail = f"{tools_qt.is_checked(self.dlg_psector_rapport, 'chk_csv_detail')}"
        tools_gw.set_config_parser('btn_psector', 'psector_rapport_chk_csv_detail', chk_csv_detail)
        chk_csv = f"{tools_qt.is_checked(self.dlg_psector_rapport, 'chk_csv')}"
        tools_gw.set_config_parser('btn_psector', 'psector_rapport_chk_csv', chk_csv)

        folder_path = tools_qt.get_text(self.dlg_psector_rapport, self.dlg_psector_rapport.txt_path)
        if folder_path is None or folder_path == 'null' or not os.path.exists(folder_path):
            tools_qt.get_folder_path(self.dlg_psector_rapport.txt_path)
            folder_path = tools_qt.get_text(self.dlg_psector_rapport, self.dlg_psector_rapport.txt_path)

        # Generate Composer
        if tools_qt.is_checked(self.dlg_psector_rapport, self.dlg_psector_rapport.chk_composer):
            file_name = tools_qt.get_text(self.dlg_psector_rapport, 'txt_composer_path')
            if file_name is None or file_name == 'null':
                message = "File name is required"
                tools_qgis.show_warning(message, dialog=self.dlg_plan_psector)
            if file_name.find('.pdf') is False:
                file_name += '.pdf'
            path = folder_path + '/' + file_name
            self.generate_composer(path)

        # Generate csv detail
        if tools_qt.is_checked(self.dlg_psector_rapport, self.dlg_psector_rapport.chk_csv_detail):
            file_name = tools_qt.get_text(self.dlg_psector_rapport, 'txt_csv_path')
            viewname = f"v_plan_current_psector_budget_detail"
            if file_name is None or file_name == 'null':
                message = "Price list csv file name is required"
                tools_qgis.show_warning(message, dialog=self.dlg_plan_psector)
            if file_name.find('.csv') is False:
                file_name += '.csv'
            path = folder_path + '/' + file_name
            self.generate_csv(path, viewname)

        # Generate csv
        if tools_qt.is_checked(self.dlg_psector_rapport, self.dlg_psector_rapport.chk_csv):
            file_name = tools_qt.get_text(self.dlg_psector_rapport, 'txt_csv_detail_path')
            viewname = f"v_plan_current_psector_budget"
            if file_name is None or file_name == 'null':
                message = "Price list csv file name is required"
                tools_qgis.show_warning(message, dialog=self.dlg_plan_psector)
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
                    tools_qgis.show_info(message, parameter=path, dialog=self.dlg_plan_psector)
                    status, message = tools_os.open_file(path)
                    if status is False and message is not None:
                        tools_qgis.show_warning(message, parameter=path, dialog=self.dlg_plan_psector)
                else:
                    message = "Cannot create file, check if its open"
                    tools_qgis.show_warning(message, parameter=path, dialog=self.dlg_plan_psector)
            except Exception as e:
                tools_log.log_warning(str(e))
                msg = "Cannot create file, check if selected composer is the correct composer"
                tools_qgis.show_warning(msg, parameter=path, dialog=self.dlg_plan_psector)
            finally:
                designer_window.close()
        else:
            tools_qgis.show_warning("Layout not found", parameter=layout_name, dialog=self.dlg_plan_psector)


    def generate_csv(self, path, viewname):

        # Get columns name in order of the table
        sql = (f"SELECT column_name FROM information_schema.columns"
               f" WHERE table_name = '{viewname}'"
               f" AND table_schema = '" + self.schema_name.replace('"', '') + "'"
               f" ORDER BY ordinal_position")
        rows = tools_db.get_rows(sql)
        columns = []

        if not rows or rows is None or rows == '':
            message = "CSV not generated. Check fields from table or view"
            tools_qgis.show_warning(message, parameter=viewname, dialog=self.dlg_plan_psector)
            return
        for i in range(0, len(rows)):
            column_name = rows[i]
            columns.append(str(column_name[0]))

        psector_id = f"{tools_qt.get_text(self.dlg_plan_psector, self.dlg_plan_psector.psector_id)}"
        sql = f"SELECT * FROM {viewname} WHERE psector_id = '{psector_id}'"
        rows = tools_db.get_rows(sql)
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
        rows = tools_db.get_rows(sql)
        columns = []
        for i in range(0, len(rows)):
            column_name = rows[i]
            columns.append(str(column_name[0]))

        sql = (f"SELECT total_arc, total_node, total_other, pem, pec, pec_vat, gexpenses, vat, other, pca"
               f" FROM v_plan_current_psector"
               f" WHERE psector_id = '{psector_id}'")
        row = tools_db.get_row(sql)
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

        if tools_qt.get_text(dialog, 'pec') not in ('null', None):
            pec = float(tools_qt.get_text(dialog, 'pec'))
        else:
            pec = 0

        if tools_qt.get_text(dialog, 'pem') not in ('null', None):
            pem = float(tools_qt.get_text(dialog, 'pem'))
        else:
            pem = 0

        res = f"{round(pec - pem, 2):.02f}"
        tools_qt.set_widget_text(dialog, 'pec_pem', res)


    def calc_pecvat_pec(self, dialog):

        if tools_qt.get_text(dialog, 'pec_vat') not in ('null', None):
            pec_vat = float(tools_qt.get_text(dialog, 'pec_vat'))
        else:
            pec_vat = 0

        if tools_qt.get_text(dialog, 'pec') not in ('null', None):
            pec = float(tools_qt.get_text(dialog, 'pec'))
        else:
            pec = 0
        res = f"{round(pec_vat - pec, 2):.02f}"
        tools_qt.set_widget_text(dialog, 'pecvat_pem', res)


    def calc_pca_pecvat(self, dialog):

        if tools_qt.get_text(dialog, 'pca') not in ('null', None):
            pca = float(tools_qt.get_text(dialog, 'pca'))
        else:
            pca = 0

        if tools_qt.get_text(dialog, 'pec_vat') not in ('null', None):
            pec_vat = float(tools_qt.get_text(dialog, 'pec_vat'))
        else:
            pec_vat = 0
        res = f"{round(pca - pec_vat, 2):.02f}"
        tools_qt.set_widget_text(dialog, 'pca_pecvat', res)


    def calculate_percents(self, tablename, field):

        field_value = f"{tools_qt.get_text(self.dlg_plan_psector, field)}"
        psector_id = tools_qt.get_text(self.dlg_plan_psector, "psector_id")
        sql = f"UPDATE {tablename} SET {field} = '{field_value}' WHERE psector_id = '{psector_id}'"
        tools_db.execute_sql(sql)
        self.populate_budget(self.dlg_plan_psector, psector_id)


    def show_description(self):
        """ Show description of product plan/om _psector as label"""

        selected_list = self.dlg_plan_psector.all_rows.selectionModel().selectedRows()
        des = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            des = self.dlg_plan_psector.all_rows.model().record(row).value('descript')
        tools_qt.set_widget_text(self.dlg_plan_psector, self.lbl_descript, des)


    def set_tabs_enabled(self, enabled):

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


    def enable_relation_tab(self, tablename):

        psector_name = f"{tools_qt.get_text(self.dlg_plan_psector, self.dlg_plan_psector.name)}"
        sql = f"SELECT name FROM {tablename} WHERE LOWER(name) = '{psector_name}'"
        rows = tools_db.get_rows(sql)
        if not rows:
            if self.dlg_plan_psector.name.text() != '':
                self.set_tabs_enabled(True)
            else:
                self.set_tabs_enabled(False)
        else:
            self.set_tabs_enabled(False)


    def delete_psector_selector(self, tablename):

        sql = (f"DELETE FROM {tablename}"
               f" WHERE cur_user = current_user;")
        tools_db.execute_sql(sql)


    def insert_psector_selector(self, tablename, field, value):

        sql = (f"INSERT INTO {tablename} ({field}, cur_user) "
               f"VALUES ('{value}', current_user);")
        tools_db.execute_sql(sql)


    def check_tab_position(self):

        self.dlg_plan_psector.name.setEnabled(False)
        self.insert_or_update_new_psector(tablename=f'v_edit_plan_psector', close_dlg=False)
        self.update = True
        psector_id = tools_qt.get_text(self.dlg_plan_psector, 'psector_id')
        if self.dlg_plan_psector.tabWidget.currentIndex() == 3:
            tableleft = "v_price_compost"
            tableright = f"v_edit_plan_psector_x_other"
            if not self.load_signals:
                self.price_selector(self.dlg_plan_psector, tableleft, tableright)
        elif self.dlg_plan_psector.tabWidget.currentIndex() == 4:
            self.populate_budget(self.dlg_plan_psector, psector_id)
        elif self.dlg_plan_psector.tabWidget.currentIndex() == 5:
            expr = f"psector_id = '{psector_id}'"
            message = tools_qt.fill_table(self.tbl_document, f"{self.schema_name}.v_ui_doc_x_psector", expr)
            tools_gw.set_tablemodel_config(self.dlg_plan_psector, self.tbl_document, "v_ui_doc_x_psector")
            if message:
                tools_qgis.show_warning(message)

        sql = f"SELECT other, gexpenses, vat  FROM plan_psector WHERE psector_id = '{psector_id}'"
        row = tools_db.get_row(sql)
        if row:
            tools_qt.set_widget_text(self.dlg_plan_psector, self.dlg_plan_psector.other, row[0])
            tools_qt.set_widget_text(self.dlg_plan_psector, self.dlg_plan_psector.gexpenses, row[1])
            tools_qt.set_widget_text(self.dlg_plan_psector, self.dlg_plan_psector.vat, row[2])

        widget_to_ignore = ('btn_accept', 'btn_cancel', 'btn_rapports', 'btn_open_doc')
        restriction = ('role_basic', 'role_om', 'role_epa', 'role_om')
        self.set_restriction_by_role(self.dlg_plan_psector, widget_to_ignore, restriction)


    def set_restriction_by_role(self, dialog, widget_to_ignore, restriction):
        """
        Set all widget enabled(False) or readOnly(True) except those on the tuple
            :param dialog:
            :param widget_to_ignore: tuple = ('widgetname1', 'widgetname2', 'widgetname3', ...)
            :param restriction: roles that do not have access. tuple = ('role1', 'role1', 'role1', ...)
        """

        role = global_vars.project_vars['project_role']
        role = tools_gw.get_role_permissions(role)
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
        rows = tools_db.get_rows(sql)
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
                tools_db.execute_sql(sql)
        except TypeError:
            # Control if self.all_states is None (object of type 'NoneType' has no len())
            pass


    def close_psector(self, cur_active_layer=None):
        """ Close dialog and disconnect snapping """

        try:
            tools_gw.reset_rubberband(self.rubber_band)
            self._clear_my_json()
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
            tools_qgis.disconnect_snapping()
            tools_gw.disconnect_signal('psector')
            tools_qgis.disconnect_signal_selection_changed()
        except RuntimeError:
            pass


    def reset_model_psector(self, feature_type):
        """ Reset model of the widget """

        table_relation = "" + feature_type + "_plan"
        widget_name = "tbl_" + table_relation
        widget = tools_qt.get_widget(self.dlg_plan_psector, widget_name)
        if widget:
            widget.setModel(None)


    def check_name(self, psector_name):
        """ Check if name of new psector exist or not """

        sql = (f"SELECT name FROM plan_psector"
               f" WHERE name = '{psector_name}'")
        row = tools_db.get_row(sql)
        if row is None:
            return False
        return True


    def insert_or_update_new_psector(self, tablename, close_dlg=False):

        psector_name = tools_qt.get_text(self.dlg_plan_psector, "name", return_string_null=False)
        if psector_name == "":
            message = "Mandatory field is missing. Please, set a value"
            tools_qgis.show_warning(message, parameter='Name', dialog=self.dlg_plan_psector)
            return

        rotation = tools_qt.get_text(self.dlg_plan_psector, "rotation", return_string_null=False)
        if rotation == "":
            tools_qt.set_widget_text(self.dlg_plan_psector, self.dlg_plan_psector.rotation, 0)

        name_exist = self.check_name(psector_name)

        if name_exist and not self.update:
            message = "The name is current in use"
            tools_qgis.show_warning(message, dialog=self.dlg_plan_psector)
            return
        else:
            self.set_tabs_enabled(True)
            self.enable_buttons(True)

        viewname = f"'v_edit_plan_psector'"
        sql = (f"SELECT column_name FROM information_schema.columns "
               f"WHERE table_name = {viewname} "
               f"AND table_schema = '" + self.schema_name.replace('"', '') + "' "
               f"ORDER BY ordinal_position;")
        rows = tools_db.get_rows(sql)
        if not rows or rows is None or rows == '':
            message = "Check fields from table or view"
            tools_qgis.show_warning(message, parameter=viewname, dialog=self.dlg_plan_psector)
            return
        columns = []
        for row in rows:
            columns.append(str(row[0]))

        if not self.update:

            values = "VALUES("
            if columns:
                sql = f"INSERT INTO {tablename} ("
                for column_name in columns:
                    if column_name != 'psector_id':
                        widget_type = tools_qt.get_widget_type(self.dlg_plan_psector, column_name)
                        if widget_type is not None:
                            value = None
                            if widget_type is QCheckBox:
                                value = str(tools_qt.is_checked(self.dlg_plan_psector, column_name)).upper()
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

            sql += " RETURNING psector_id;"
            new_psector_id = tools_db.execute_returning(sql)

            tools_qt.set_widget_text(self.dlg_plan_psector, self.dlg_plan_psector.psector_id, str(new_psector_id[0]))
            if new_psector_id:
                row = tools_gw.get_config_value('plan_psector_vdefault')
                if row:
                    sql = (f"UPDATE config_param_user "
                           f" SET value = $${new_psector_id[0]}$$ "
                           f" WHERE parameter = 'plan_psector_vdefault'"
                           f" AND cur_user=current_user; ")
                else:
                    sql = (f"INSERT INTO config_param_user (parameter, value, cur_user) "
                           f" VALUES ('plan_psector_vdefault', '{new_psector_id[0]}', current_user);")
            tools_db.execute_sql(sql)

        self.dlg_plan_psector.tabWidget.setTabEnabled(1, True)
        self.delete_psector_selector('selector_plan_psector')
        psector_id = tools_qt.get_text(self.dlg_plan_psector, self.dlg_plan_psector.psector_id)
        self.insert_psector_selector('selector_plan_psector', 'psector_id', psector_id)

        if close_dlg:
            json_result = self.set_plan()
            if json_result.get('status') == 'Accepted':
                self.reload_states_selector()
                tools_gw.close_dialog(self.dlg_plan_psector)

        # Refresh selectors UI if it is open and and the form will close
        if close_dlg:
            tools_gw.refresh_selectors()


    def set_plan(self):

        # TODO: Check this
        extras = f'"psectorId":"{tools_qt.get_text(self.dlg_plan_psector, self.psector_id)}"'
        body = tools_gw.create_body(extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_setplan', body)
        tools_gw.manage_current_selections_docker(json_result)
        return json_result


    def price_selector(self, dialog, tableleft, tableright):


        self.load_signals = True

        # fill QTableView all_rows
        tbl_all_rows = dialog.findChild(QTableView, "all_rows")
        tbl_all_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.fill_table(dialog, tbl_all_rows, tableleft)
        tools_gw.set_tablemodel_config(dialog, tbl_all_rows, tableleft)

        if not self.price_loaded:
            self.price_loaded = True
            self.count = -1
            psector_id = tools_qt.get_text(dialog, 'psector_id')
            self._manage_widgets_price(dialog, tableright, psector_id, print_all_rows=True, print_headers=True)

        # Button select (Create new labels)
        dialog.btn_select.clicked.connect(
            partial(self.create_label, dialog, tbl_all_rows, 'id', tableright, "price_id"))
        tbl_all_rows.doubleClicked.connect(
            partial(self.create_label, dialog, tbl_all_rows, 'id', tableright, "price_id"))

        # Button unselect
        dialog.btn_remove.clicked.connect(
            partial(self.rows_unselector, dialog, tableright))


    def create_label(self, dialog, tbl_all_rows, id_ori, tableright, id_des):

        selected_list = tbl_all_rows.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=dialog)
            return
        expl_id = []
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = tbl_all_rows.model().record(row).value(id_ori)
            expl_id.append(id_)

        psector_id = tools_qt.get_text(dialog, 'psector_id')

        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            values = ""
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

            row = tools_db.get_row(sql)
            if row is not None:
                # if exist - show warning
                message = "Id already selected"
                tools_qt.show_info_box(message, "Info", parameter=str(expl_id[i]))
            else:
                sql = (f"INSERT INTO {tableright}"
                       f" (psector_id, unit, price_id, observ, price) "
                       f" VALUES ({values})")
                tools_db.execute_sql(sql)

        self._manage_widgets_price(dialog, tableright, psector_id, expl_id)


    def _manage_widgets_price(self, dialog, tableright, psector_id, print_all_rows=False, print_headers=True):

        layout = dialog.findChild(QGridLayout, 'lyt_price')

        for i in reversed(range(layout.count())):
            if layout.itemAt(i).widget():
                layout.itemAt(i).widget().deleteLater()
        self._add_price_widgets(dialog, tableright, psector_id, print_all_rows=print_all_rows, print_headers=print_headers)
        self.update_total(dialog)


    def _add_price_widgets(self, dialog, tableright, psector_id, expl_id=[], editable_widgets=['measurement','observ']
                           , print_all_rows=False, print_headers=False):

        extras = (f'"tableName":"{tableright}", "psectorId":{psector_id}')
        body = tools_gw.create_body(extras=extras)
        complet_result = tools_gw.execute_procedure('gw_fct_getwidgetprices', body)

        if not complet_result or complet_result['fields'] == {}:
            return


        if print_headers or self.header_exist is None:
            self.header_exist = True
            pos = 1
            self.count = self.count + 1
            for key in complet_result['fields'][0].keys():
                if key != 'id':
                    lbl = QLabel()
                    lbl.setObjectName(f"lbl_{key}_{self.count}")
                    lbl.setText(f"  {key}  ")
    
                    layout = dialog.findChild(QGridLayout, 'lyt_price')
                    layout.addWidget(lbl, self.count, pos)
                    layout.setColumnStretch(2, 1)
                    pos = pos + 1

        for field in complet_result['fields']:
            if field['price_id'] in expl_id or print_all_rows:
                self.count = self.count + 1
                pos = 0

                # Create check
                check = QCheckBox()
                check.setObjectName(f"{field['id']}")

                layout = dialog.findChild(QGridLayout, 'lyt_price')
                layout.addWidget(check, self.count, pos)
                layout.setColumnStretch(2, 1)
                pos = pos + 1

                for key in complet_result['fields'][0].keys():
                    if key != 'id':
                        if key not in editable_widgets:
                            widget = QLabel()
                            widget.setObjectName(f"widget_{key}_{field['price_id']}")
                            widget.setText(f"  {field.get(key)}  ")
                        else:
                            widget = QLineEdit()
                            widget.setObjectName(f"widget_{key}_{field['price_id']}")
                            if f"widget_{key}_{field['price_id']}" in self.dict_to_update:
                                text = self.dict_to_update[f"widget_{key}_{field['price_id']}"][key]
                            else:
                                text = field.get(key) if field.get(key) is not None else ''

                            widget.setText(f"{text}")
                            widget.editingFinished.connect(partial(self._manage_updates_prices, widget, key, field['price_id']))
                            widget.editingFinished.connect(partial(self._manage_widgets_price, dialog, tableright, psector_id, print_all_rows=True ))
                            widget.editingFinished.connect(partial(self.update_total, dialog))

                        layout = dialog.findChild(QGridLayout, 'lyt_price')
                        layout.addWidget(widget, self.count, pos)
                        layout.setColumnStretch(2, 1)
                        pos = pos + 1


    def _manage_updates_prices(self, widget, key, price_id):

        self.dict_to_update[f"widget_{key}_{price_id}"] = {"price_id":price_id, key:widget.text()}
        self._update_otherprice()


    def _update_otherprice(self):

        sql = ""
        _filter = ""
        if self.dict_to_update:
            for main_key in self.dict_to_update:
                sub_list = list(self.dict_to_update[main_key].keys())
                for sub_key in sub_list:
                    if sub_key == 'price_id':
                        _filter = self.dict_to_update[main_key][sub_key]
                    else:
                        sql += f"UPDATE v_edit_plan_psector_x_other SET {sub_key} = '{self.dict_to_update[main_key][sub_key]}' " \
                               f"WHERE psector_id = {tools_qt.get_text(self.dlg_plan_psector, self.psector_id)} AND price_id = '{_filter}';\n"
            tools_db.execute_sql(sql)


    def _manage_widgets(self, dialog, lbl, widget, count, pos):

        layout = dialog.findChild(QGridLayout, 'lyt_price')

        layout.addWidget(lbl, count, pos)
        layout.addWidget(widget, count, pos+1)
        layout.setColumnStretch(2, 1)


    def rows_unselector(self, dialog, tableright):

        query = (f"DELETE FROM {tableright}"
                 f" WHERE {tableright}.id = ")

        select_widgets = dialog.tab_other_prices.findChildren(QCheckBox)
        selected_ids = []
        count = 0
        for check in select_widgets:
            if check.isChecked():
                selected_ids.append(check.objectName())
            else:
                count = count + 1

        psector_id = tools_qt.get_text(dialog, 'psector_id')
        for i in range(0, len(selected_ids)):
            sql = f"{query}'{selected_ids[i]}' AND psector_id = '{psector_id}'"
            tools_db.execute_sql(sql)

        layout = dialog.findChild(QGridLayout, 'lyt_price')

        for i in reversed(range(layout.count())):
            if layout.itemAt(i).widget():
                layout.itemAt(i).widget().deleteLater()
        self._add_price_widgets(dialog, tableright, psector_id, print_all_rows=True, print_headers=True)
        self.update_total(dialog)

    def query_like_widget_text(self, dialog, text_line, qtable, tableleft, tableright, field_id):
        """ Populate the QTableView by filtering through the QLineEdit """

        schema_name = self.schema_name.replace('"', '')
        psector_id = tools_qt.get_text(dialog, 'psector_id')
        query = tools_qt.get_text(dialog, text_line).lower()
        if query == 'null':
            query = ""
        sql = (f"SELECT * FROM {schema_name}.{tableleft} WHERE LOWER ({field_id})"
               f" LIKE '%{query}%' AND {field_id} NOT IN (SELECT price_id FROM {schema_name}.{tableright}"
               f" WHERE psector_id = '{psector_id}')")
        self.fill_table_by_query(qtable, sql)


    def fill_table_by_query(self, qtable, query):
        """
        :param qtable: QTableView to show
        :param query: query to set model
        """

        model = QSqlQueryModel()
        model.setQuery(query, db=global_vars.qgis_db_credentials)
        qtable.setModel(model)
        qtable.show()

        # Check for errors
        if model.lastError().isValid():
            tools_qgis.show_warning(model.lastError().text())


    def fill_table(self, dialog, widget, table_name, hidde=False, set_edit_triggers=QTableView.NoEditTriggers, expr=None):
        """ Set a model with selected filter.
            Attach that model to selected table
            @setEditStrategy:
            0: OnFieldChange
            1: OnRowChange
            2: OnManualSubmit
        """

        # Manage exception if dialog is closed
        if isdeleted(dialog):
            return

        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        # Set model
        model = QSqlTableModel(db=global_vars.qgis_db_credentials)
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnFieldChange)
        model.setSort(0, 0)
        model.select()

        # When change some field we need to refresh Qtableview and filter by psector_id
        model.beforeUpdate.connect(partial(self.manage_update_state, model))
        model.dataChanged.connect(partial(self.refresh_table, dialog, widget))
        widget.setEditTriggers(set_edit_triggers)

        # Check for errors
        if model.lastError().isValid():
            tools_qgis.show_warning(model.lastError().text(), dialog=dialog)
        # Attach model to table view
        if expr:
            widget.setModel(model)
            widget.model().setFilter(expr)
        else:
            widget.setModel(model)

        if hidde:
            self.refresh_table(dialog, widget)


    def refresh_table(self, dialog, widget):
        """ Refresh qTableView """

        widget.selectAll()
        selected_list = widget.selectionModel().selectedRows()
        widget.clearSelection()
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            if str(widget.model().record(row).value('psector_id')) != tools_qt.get_text(dialog, 'psector_id'):
                widget.hideRow(i)


    def manage_update_state(self, model, row, record):
        """
        Manage new state of planned features.
            :param model: QSqlModel of QTableView
            :param row: index of updating row (passed by signal)
            :param record: QSqlRecord (passed by signal)
        """

        # Get table name via current tab name (arc, node, connec or gully)
        index_tab = self.dlg_plan_psector.tab_feature.currentIndex()
        tab_name = self.dlg_plan_psector.tab_feature.tabText(index_tab)
        table_name = tab_name.lower()

        # Get selected feature's state
        feature_id = record.value(f'{table_name}_id')  # Get the id
        sql = f"SELECT {table_name}.state FROM {table_name} WHERE {table_name}_id='{feature_id}';"
        sql_row = tools_db.get_row(sql)
        if sql_row:
            old_state = sql_row[0]  # Original state
            new_state = record.value('state')  # New state
            if old_state == 2 and new_state == 0:
                msg = "This value is mandatory for planned feature. If you are looking to unlink feature from this " \
                      "psector please delete row. If delete is not allowed its because feature is only used on this " \
                      "psector and needs to be removed from canvas"
                tools_qgis.show_warning(msg, dialog=self.dlg_plan_psector)
                model.revert()


    def document_insert(self):
        """ Insert a document related to the current visit """

        doc_id = self.doc_id.text()
        psector_id = self.psector_id.text()
        if not doc_id:
            message = "You need to insert doc_id"
            tools_qgis.show_warning(message, dialog=self.dlg_plan_psector)
            return
        if not psector_id:
            message = "You need to insert psector_id"
            tools_qgis.show_warning(message, dialog=self.dlg_plan_psector)
            return

        # Check if document already exist
        sql = (f"SELECT doc_id"
               f" FROM doc_x_psector"
               f" WHERE doc_id = '{doc_id}' AND psector_id = '{psector_id}'")
        row = tools_db.get_row(sql)
        if row:
            msg = "Document already exist"
            tools_qgis.show_warning(msg, dialog=self.dlg_plan_psector)
            return

        # Insert into new table
        sql = (f"INSERT INTO doc_x_psector (doc_id, psector_id)"
               f" VALUES ('{doc_id}', {psector_id})")
        status = tools_db.execute_sql(sql)
        if status:
            message = "Document inserted successfully"
            tools_qgis.show_info(message, dialog=self.dlg_plan_psector)

        self.dlg_plan_psector.tbl_document.model().select()


    def manage_document(self, qtable):
        """ Access GUI to manage documents e.g Execute action of button 34 """

        psector_id = tools_qt.get_text(self.dlg_plan_psector, self.dlg_plan_psector.psector_id)
        manage_document = GwDocument(single_tool=False)
        dlg_docman = manage_document.get_document(tablename='psector', qtable=qtable, item_id=psector_id)
        dlg_docman.btn_accept.clicked.connect(partial(tools_gw.set_completer_object, dlg_docman, 'doc'))
        tools_qt.remove_tab(dlg_docman.tabWidget, 'tab_rel')


    def show_status_warning(self):

        mode = tools_gw.get_config_value('plan_psector_execute_action', table='config_param_system')
        if mode is None:
            return

        mode = json.loads(mode[0])
        if mode['mode'] == 'obsolete':
            msg = "WARNING: You have updated the status value. If you click 'Accept' on the main dialog, " \
                  "a process that updates the state & state_type values of all that features that belong to the " \
                  "psector, according to the system variables plan_psector_statetype, " \
                  "plan_statetype_planned and plan_statetype_ficticious, will be triggered."
            tools_qt.show_details(msg, 'Message warning')
        elif mode['mode'] == 'onService':
            if tools_qt.get_combo_value(self.dlg_plan_psector, self.cmb_status) == '0':
                msg = "WARNING: You have updated the status value. If you click 'Accept' on the main dialog, " \
                      "this psector will be executed. Planified features will turn on service and deleted features " \
                      "will turn obsolete. To mantain traceability, a copy of planified features will be inserted " \
                      "on the psector."
                tools_qt.show_details(msg, 'Message warning')


    def master_new_psector(self, psector_id=None):
        """ Button 45: New psector """
        self.get_psector(psector_id)


    def manage_psectors(self):
        """ Button 46: Psector management """

        # Create the dialog and signals
        self.dlg_psector_mng = GwPsectorManagerUi()

        tools_gw.load_settings(self.dlg_psector_mng)
        table_name = "v_ui_plan_psector"
        column_id = "psector_id"

        # Tables
        self.qtbl_psm = self.dlg_psector_mng.findChild(QTableView, "tbl_psm")
        self.qtbl_psm.setSelectionBehavior(QAbstractItemView.SelectRows)
        tools_qt.set_tableview_config(self.qtbl_psm, sectionResizeMode=0)

        # Set signals
        self.dlg_psector_mng.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_psector_mng))
        self.dlg_psector_mng.rejected.connect(partial(tools_gw.close_dialog, self.dlg_psector_mng))
        self.dlg_psector_mng.btn_delete.clicked.connect(partial(
            self.multi_rows_delete, self.dlg_psector_mng, self.qtbl_psm, table_name, column_id, 'lbl_vdefault_psector', 'psector'))
        self.dlg_psector_mng.btn_delete.clicked.connect(partial(tools_gw.refresh_selectors))
        self.dlg_psector_mng.btn_update_psector.clicked.connect(
            partial(self.update_current_psector, self.dlg_psector_mng, self.qtbl_psm))
        self.dlg_psector_mng.btn_duplicate.clicked.connect(self.psector_duplicate)
        self.dlg_psector_mng.txt_name.textChanged.connect(partial(
            self.filter_by_text, self.dlg_psector_mng, self.qtbl_psm, self.dlg_psector_mng.txt_name, table_name))
        self.dlg_psector_mng.tbl_psm.doubleClicked.connect(partial(self.charge_psector, self.qtbl_psm))
        self.fill_table(self.dlg_psector_mng, self.qtbl_psm, table_name)
        tools_gw.set_tablemodel_config(self.dlg_psector_mng, self.qtbl_psm, table_name)
        selection_model = self.qtbl_psm.selectionModel()
        selection_model.selectionChanged.connect(partial(self._fill_txt_infolog))
        self.set_label_current_psector(self.dlg_psector_mng)
        # Open form
        self.dlg_psector_mng.setWindowFlags(Qt.WindowStaysOnTopHint)
        tools_gw.open_dialog(self.dlg_psector_mng, dlg_name="psector_manager")


    def update_current_psector(self, dialog, qtbl_psm):

        selected_list = qtbl_psm.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=dialog)
            return
        row = selected_list[0].row()
        psector_id = qtbl_psm.model().record(row).value("psector_id")
        aux_widget = QLineEdit()
        aux_widget.setText(str(psector_id))
        self.upsert_config_param_user(dialog, aux_widget, "plan_psector_vdefault")

        message = "Values has been updated"
        tools_qgis.show_info(message, dialog=dialog)

        self.fill_table(dialog, qtbl_psm, "v_ui_plan_psector")
        tools_gw.set_tablemodel_config(dialog, qtbl_psm, "v_ui_plan_psector")
        self.set_label_current_psector(dialog)
        tools_gw.open_dialog(dialog)


    def upsert_config_param_user(self, dialog, widget, parameter):
        """ Insert or update values in tables with current_user control """

        tablename = "config_param_user"
        sql = (f"SELECT * FROM {tablename}"
               f" WHERE cur_user = current_user")
        rows = tools_db.get_rows(sql)
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
        tools_db.execute_sql(sql)


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
            tools_qgis.show_warning(message, dialog=self.dlg_psector_mng)
            return
        row = selected_list[0].row()
        psector_id = qtbl_psm.model().record(row).value("psector_id")
        keep_open_form = tools_gw.get_config_parser('dialogs_actions', 'psector_manager_keep_open', "user", "init", prefix=True)
        if tools_os.set_boolean(keep_open_form, False) is not True:
            tools_gw.close_dialog(self.dlg_psector_mng)
        self.master_new_psector(psector_id)
        # Refresh canvas
        tools_qgis.refresh_map_canvas()


    def multi_rows_delete(self, dialog, widget, table_name, column_id, label, action):
        """
        Delete selected elements of the table
            :param dialog: (QDialog)
            :param QTableView widget: origin
            :param table_name: table origin
            :param column_id: Refers to the id of the source table
        """
        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=dialog)
            return
        cur_psector = tools_gw.get_config_value('plan_psector_vdefault')
        inf_text = ""
        list_id = ""
        for i in range(0, len(selected_list)):
            row = selected_list[i].row()
            id_ = widget.model().record(row).value(str(column_id))
            if cur_psector and (str(id_) == str(cur_psector[0])):
                message = ("You are trying to delete your current psector. "
                           "Please, change your current psector before delete.")
                tools_qt.show_exception_message('Current psector', tools_qt.tr(message))
                return
            inf_text += f'"{id_}", '
            list_id += f'"{id_}", '
        inf_text = inf_text[:-2]
        list_id = list_id[:-2]

        if action == 'psector':
            feature = f'"id":[{inf_text}], "featureType":"PSECTOR"'
            body = tools_gw.create_body(feature=feature)
            result = tools_gw.execute_procedure('gw_fct_getcheckdelete', body)
            if result is not None and result['status'] == "Accepted":
                if result['message']:
                    answer = tools_qt.show_question(result['message']['text'])
                    if answer:
                        feature += f', "tableName":"{table_name}", "idName":"{column_id}"'
                        body = tools_gw.create_body(feature=feature)
                        tools_gw.execute_procedure('gw_fct_setdelete', body)

        elif action == 'price':
            message = "Are you sure you want to delete these records?"
            answer = tools_qt.show_question(message, "Delete records", inf_text)
            if answer:
                sql = "DELETE FROM selector_plan_result WHERE result_id in ("
                if list_id != '':
                    sql += f"{list_id}) AND cur_user = current_user;"
                    tools_db.execute_sql(sql)
                    tools_qt.set_widget_text(dialog, label, '')
                sql = (f"DELETE FROM {table_name}"
                       f" WHERE {column_id} IN ({list_id});")
                tools_db.execute_sql(sql)
        widget.model().select()


    def manage_prices(self):
        """ Button 50: Plan estimate result manager """

        # Create the dialog and signals
        self.dlg_merm = GwPriceManagerUi()
        tools_gw.load_settings(self.dlg_merm)

        # Set current value
        sql = (f"SELECT name FROM plan_result_cat WHERE result_id IN (SELECT result_id FROM selector_plan_result "
               f"WHERE cur_user = current_user)")
        row = tools_db.get_row(sql)
        if row:
            tools_qt.set_widget_text(self.dlg_merm, 'lbl_vdefault_price', str(row[0]))

        # Tables
        tablename = 'plan_result_cat'
        self.tbl_om_result_cat = self.dlg_merm.findChild(QTableView, "tbl_om_result_cat")
        tools_qt.set_tableview_config(self.tbl_om_result_cat)

        # Set signals
        self.dlg_merm.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_merm))
        self.dlg_merm.rejected.connect(partial(tools_gw.close_dialog, self.dlg_merm))
        self.dlg_merm.btn_delete.clicked.connect(partial(self.delete_merm, self.dlg_merm))
        self.dlg_merm.btn_update_result.clicked.connect(partial(self.update_price_vdefault))
        self.dlg_merm.txt_name.textChanged.connect(partial(self.filter_merm, self.dlg_merm, tablename))

        self.fill_table(self.dlg_merm, self.tbl_om_result_cat, tablename)
        tools_gw.set_tablemodel_config(self.tbl_om_result_cat, self.dlg_merm.tbl_om_result_cat, tablename)

        # Open form
        self.dlg_merm.setWindowFlags(Qt.WindowStaysOnTopHint)
        tools_gw.open_dialog(self.dlg_merm, dlg_name="price_manager")


    def update_price_vdefault(self):

        selected_list = self.dlg_merm.tbl_om_result_cat.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=self.dlg_merm)
            return
        row = selected_list[0].row()
        price_name = self.dlg_merm.tbl_om_result_cat.model().record(row).value("name")
        result_id = self.dlg_merm.tbl_om_result_cat.model().record(row).value("result_id")
        tools_qt.set_widget_text(self.dlg_merm, 'lbl_vdefault_price', price_name)
        sql = (f"DELETE FROM selector_plan_result WHERE current_user = cur_user;"
               f"\nINSERT INTO selector_plan_result (result_id, cur_user)"
               f" VALUES({result_id}, current_user);")
        status = tools_db.execute_sql(sql)
        if status:
            message = "Values has been updated"
            tools_qgis.show_info(message, dialog=self.dlg_merm)

        # Refresh canvas
        self.iface.mapCanvas().refreshAllLayers()


    def delete_merm(self, dialog):
        """ Delete selected row from 'manage_prices' dialog from selected tab """

        self.multi_rows_delete(dialog, dialog.tbl_om_result_cat, 'plan_result_cat',
                               'result_id', 'lbl_vdefault_price', 'price')


    def filter_merm(self, dialog, tablename):
        """ Filter rows from 'manage_prices' dialog from selected tab """

        self.filter_by_text(dialog, dialog.tbl_om_result_cat, dialog.txt_name, tablename)


    def psector_duplicate(self):
        """" Button 51: Duplicate psector """

        selected_list = self.qtbl_psm.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=self.dlg_psector_mng)
            return

        row = selected_list[0].row()
        psector_id = self.qtbl_psm.model().record(row).value("psector_id")
        self.duplicate_psector = GwPsectorDuplicate()
        self.duplicate_psector.is_duplicated.connect(partial(self.fill_table, self.dlg_psector_mng, self.qtbl_psm, 'v_ui_plan_psector'))
        self.duplicate_psector.is_duplicated.connect(partial(self.set_label_current_psector, self.dlg_psector_mng))
        self.duplicate_psector.manage_duplicate_psector(psector_id)


    def set_label_current_psector(self, dialog):

        sql = ("SELECT t1.psector_id, t1.name FROM plan_psector AS t1 "
               " INNER JOIN config_param_user AS t2 ON t1.psector_id::text = t2.value "
               " WHERE t2.parameter='plan_psector_vdefault' AND cur_user = current_user")
        row = tools_db.get_row(sql)
        if not row:
            return
        tools_qt.set_widget_text(dialog, 'lbl_vdefault_psector', row[1])
        extras = (f'"selectorType":"selector_basic", "tabName":"tab_psector", "id":{row[0]}, '
                  f'"isAlone":"False", "disableParent":"False", '
                  f'"value":"True"')
        body = tools_gw.create_body(extras=extras)
        result = tools_gw.execute_procedure("gw_fct_getselectors", body)
        tools_gw.manage_current_selections_docker(result)


    def zoom_to_selected_features(self, layer, feature_type=None, zoom=None):
        """ Zoom to selected features of the @layer with @feature_type """

        if not layer:
            return

        global_vars.iface.setActiveLayer(layer)
        global_vars.iface.actionZoomToSelected().trigger()

        if feature_type and zoom:

            # Set scale = scale_zoom
            if feature_type in ('node', 'connec', 'gully'):
                scale = zoom

            # Set scale = max(current_scale, scale_zoom)
            elif feature_type == 'arc':
                scale = global_vars.iface.mapCanvas().scale()
                if int(scale) < int(zoom):
                    scale = zoom
            else:
                scale = 5000

            if zoom is not None:
                scale = zoom

            global_vars.iface.mapCanvas().zoomScale(float(scale))


    # region private functions


    def _manage_accept(self, psector_id):

        if not self.my_json:
            return

        updates = ""
        for key, value in self.my_json.items():
            updates += f"{key} = '{value}', "
        if updates:
            updates = updates[:-2]
            sql = f"UPDATE v_edit_plan_psector SET {updates} WHERE psector_id = {psector_id}"
            if tools_db.execute_sql(sql):
                msg = "Psector values updated successfully"
                tools_qgis.show_info(msg)
            self._clear_my_json()


    def _clear_my_json(self):
        self.my_json = {}


    def _connect_editing_finished(self):
        try:
            # Widgets
            dialog = self.dlg_plan_psector
            widgets = dialog.General.findChildren(QWidget)
            more_widgets = dialog.additional_info.findChildren(QWidget)
            widgets.extend(more_widgets)
            for widget in widgets:
                if type(widget) == QLineEdit:
                    widget.editingFinished.connect(partial(tools_gw.get_values, dialog, widget, self.my_json))
                elif type(widget) == QComboBox:
                    widget.currentIndexChanged.connect(partial(tools_gw.get_values, dialog, widget, self.my_json))
                elif type(widget) == QCheckBox:
                    if widget.objectName() == 'chk_enable_all':
                        continue
                    widget.stateChanged.connect(partial(tools_gw.get_values, dialog, widget, self.my_json))
                elif type(widget) == QTextEdit:
                    widget.textChanged.connect(partial(tools_gw.get_values, dialog, widget, self.my_json))
        except RuntimeError:
            pass


    def _fill_txt_infolog(self, selected):
        """
         Fill txt_infolog from epa_result_manager form with current data selected for columns:
             'name', 'priority', 'status', 'exploitation', 'type', 'descript', 'text1', 'text2', 'observ'
         """

        # Get id of selected row
        row = selected.indexes()
        if not row:
            return

        msg = ""

        cols = ['Name', 'Priority', 'Status', 'expl_id', 'Descript', 'text1', 'text2', 'Observ']

        for col in cols:
            # Get column index for column
            col_ind = tools_qt.get_col_index_by_col_name(self.qtbl_psm, f"{col.lower()}")
            text = f'{row[col_ind].data()}'
            msg += f"<b>{col}: </b><br>{text}<br><br>"

        # Set message text into widget
        tools_qt.set_widget_text(self.dlg_psector_mng, 'txt_infolog', msg)


    def _enable_layers(self, is_cheked):
        """ Manage checkbox state and act accordingly with the layers """

        layers = ['v_plan_psector_arc', 'v_plan_psector_connec', 'v_plan_psector_gully', 'v_plan_psector_link',
                  'v_plan_psector_node']
        if is_cheked == 0:  # user unckeck it
            for layer_name in layers:
                layer = tools_qgis.get_layer_by_tablename(layer_name)
                if layer:
                    tools_qgis.set_layer_visible(layer, False, False)

        elif is_cheked == 2:  # user check it
            self._check_layers_visible('v_plan_psector_arc', 'the_geom', 'arc_id')
            self._check_layers_visible('v_plan_psector_connec', 'the_geom', 'connec_id')
            self._check_layers_visible('v_plan_psector_link', 'the_geom', 'link_id')
            self._check_layers_visible('v_plan_psector_node', 'the_geom', 'node_id')
            if self.project_type == 'ud':
                self._check_layers_visible('v_plan_psector_gully', 'the_geom', 'gully_id')


    def _refresh_tables_relations(self):
        # Refresh tableview tbl_psector_x_arc, tbl_psector_x_connec, tbl_psector_x_gully
        tools_gw.load_tableview_psector(self.dlg_plan_psector, 'arc')
        tools_gw.load_tableview_psector(self.dlg_plan_psector, 'node')
        tools_gw.load_tableview_psector(self.dlg_plan_psector, 'connec')
        if self.project_type.upper() == 'UD':
            tools_gw.load_tableview_psector(self.dlg_plan_psector, 'gully')
        tools_gw.set_tablemodel_config(self.dlg_plan_psector, "tbl_psector_x_arc", 'plan_psector_x_arc',
                                       isQStandardItemModel=True)
        tools_gw.set_tablemodel_config(self.dlg_plan_psector, "tbl_psector_x_connec", 'plan_psector_x_connec',
                                       isQStandardItemModel=True)
        if self.project_type.upper() == 'UD':
            tools_gw.set_tablemodel_config(self.dlg_plan_psector, "tbl_psector_x_gully", 'plan_psector_x_gully',
                                           isQStandardItemModel=True)


    def _check_layers_visible(self, layer_name, the_geom, field_id):
        """ Check layers visibility and add it if it is not in the toc """

        layer = tools_qgis.get_layer_by_tablename(layer_name)
        if layer is None:
            tools_gw.add_layer_database(layer_name, the_geom, field_id)
        if layer and QgsProject.instance().layerTreeRoot().findLayer(layer).isVisible() is False:
            tools_qgis.set_layer_visible(layer, True, True)


    def _check_for_layers(self):
        """ Return if ALL this layers in the list are checked or not """

        all_checked = True
        layers = ['v_plan_psector_arc', 'v_plan_psector_connec', 'v_plan_psector_gully', 'v_plan_psector_link',
                  'v_plan_psector_node']
        for layer_name in layers:
            if self.project_type == 'ws' and layer_name == 'v_plan_psector_gully':
                continue
            layer = tools_qgis.get_layer_by_tablename(layer_name)
            if layer is None or QgsProject.instance().layerTreeRoot().findLayer(layer).isVisible() is False:
                all_checked = False
        return all_checked


    def _set_to_arc(self):

        if hasattr(self, 'emit_point') and self.emit_point is not None:
            tools_gw.disconnect_signal('psector', 'set_to_arc_ep_canvasClicked_set_arc_id')
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        self.snapper_manager = GwSnapManager(self.iface)
        self.snapper = self.snapper_manager.get_snapper()
        self.layer_arc = tools_qgis.get_layer_by_tablename("v_edit_arc")

        # Vertex marker
        self.vertex_marker = self.snapper_manager.vertex_marker

        # Store user snapping configuration
        self.previous_snapping = self.snapper_manager.get_snapping_options()

        # Set signals
        tools_gw.connect_signal(self.canvas.xyCoordinates, self._mouse_move_arc, 'psector',
                                'set_to_arc_xyCoordinates_mouse_move_arc')
        tools_gw.connect_signal(self.emit_point.canvasClicked, partial(self._set_arc_id),
                                'psector', 'set_to_arc_ep_canvasClicked_set_arc_id')


    def _set_arc_id(self, point):

        # Check if there is a connec/gully selected
        tab_idx = self.dlg_plan_psector.tab_feature.currentIndex()
        selected_rows = []
        selected_qtbl = None
        if tab_idx == 2:
            selected_rows = self.qtbl_connec.selectionModel().selectedRows()
            selected_qtbl = self.qtbl_connec
            if len(selected_rows) == 0:
                message = "Any record selected"
                tools_qgis.show_warning(message, dialog=self.dlg_plan_psector)
                return
        elif tab_idx == 3:
            selected_rows = self.qtbl_gully.selectionModel().selectedRows()
            selected_qtbl = self.qtbl_gully
            if len(selected_rows) == 0:
                message = "Any record selected"
                tools_qgis.show_warning(message, dialog=self.dlg_plan_psector)
                return

        # Get the point
        event_point = self.snapper_manager.get_event_point(point=point)
        self.arc_id = None

        # Manage current psector
        sql = ("SELECT t1.psector_id FROM plan_psector AS t1 "
               " INNER JOIN config_param_user AS t2 ON t1.psector_id::text = t2.value "
               " WHERE t2.parameter='plan_psector_vdefault' AND cur_user = current_user")
        row = tools_db.get_row(sql)
        current_psector = row[0]
        selected_psector = tools_qt.get_text(self.dlg_plan_psector, self.psector_id)

        if str(current_psector) != str(selected_psector):
            message = "This psector does not match the current one. Value of current psector will be updated."
            tools_qt.show_info_box(message)

            sql = (f"UPDATE config_param_user "
                   f"SET value = '{selected_psector}' "
                   f"WHERE parameter = 'plan_psector_vdefault' AND cur_user=current_user")
            tools_db.execute_sql(sql)

        # Snap point
        result = self.snapper_manager.snap_to_current_layer(event_point)

        if result.isValid():
            # Check feature
            layer = self.snapper_manager.get_snapped_layer(result)
            if layer == self.layer_arc:
                # Get the point
                snapped_feat = self.snapper_manager.get_snapped_feature(result)
                self.arc_id = snapped_feat.attribute('arc_id')
                self.arc_cat_id = snapped_feat.attribute('arccat_id')

                # Set highlight
                feature = tools_qt.get_feature_by_id(layer, self.arc_id, 'arc_id')
                try:
                    geometry = feature.geometry()
                    self.rubber_band.setToGeometry(geometry, None)
                    self.rubber_band.setColor(QColor(255, 0, 0, 100))
                    self.rubber_band.setWidth(5)
                    self.rubber_band.show()
                except AttributeError:
                    pass

        if self.arc_id is None: return

        for row in selected_rows:
            cell = row.siblingAtColumn(tools_qt.get_col_index_by_col_name(selected_qtbl, 'arc_id'))
            selected_qtbl.model().setData(cell, self.arc_id)

        # Force a map refresh
        tools_qgis.force_refresh_map_canvas()


    def _replace_arc(self):

        if hasattr(self, 'emit_point') and self.emit_point is not None:
            tools_gw.disconnect_signal('psector', 'replace_arc_ep_canvasClicked_open_arc_replace_form')
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        self.snapper_manager = GwSnapManager(self.iface)
        self.snapper = self.snapper_manager.get_snapper()
        self.layer_arc = tools_qgis.get_layer_by_tablename("v_edit_arc")

        # Vertex marker
        self.vertex_marker = self.snapper_manager.vertex_marker

        # Store user snapping configuration
        self.previous_snapping = self.snapper_manager.get_snapping_options()

        # Set signals
        tools_gw.connect_signal(self.canvas.xyCoordinates, self._mouse_move_arc, 'psector',
                                'replace_arc_xyCoordinates_mouse_move_arc')
        tools_gw.connect_signal(self.emit_point.canvasClicked, self._open_arc_replace_form, 'psector',
                                'replace_arc_ep_canvasClicked_open_arc_replace_form')


    def _open_arc_replace_form(self, point):

        self.dlg_replace_arc = GwReplaceArc()
        tools_gw.load_settings(self.dlg_replace_arc)

        event_point = self.snapper_manager.get_event_point(point=point)
        self.arc_id = None

        # Manage current psector
        sql = ("SELECT t1.psector_id FROM plan_psector AS t1 "
               " INNER JOIN config_param_user AS t2 ON t1.psector_id::text = t2.value "
               " WHERE t2.parameter='plan_psector_vdefault' AND cur_user = current_user")
        row = tools_db.get_row(sql)
        current_psector = row[0]
        selected_psector = tools_qt.get_text(self.dlg_plan_psector, self.psector_id)

        if str(current_psector) != str(selected_psector):
            message = "This psector does not match the current one. Value of current psector will be updated."
            tools_qt.show_info_box(message)

            sql = (f"UPDATE config_param_user "
                   f"SET value = '{selected_psector}' "
                   f"WHERE parameter = 'plan_psector_vdefault' AND cur_user=current_user")
            tools_db.execute_sql(sql)

        # Snap point
        result = self.snapper_manager.snap_to_current_layer(event_point)

        if result.isValid():
            # Check feature
            layer = self.snapper_manager.get_snapped_layer(result)
            if layer == self.layer_arc:
                # Get the point
                snapped_feat = self.snapper_manager.get_snapped_feature(result)
                self.arc_id = snapped_feat.attribute('arc_id')
                self.arc_cat_id = snapped_feat.attribute('arccat_id')

                # Set highlight
                feature = tools_qt.get_feature_by_id(layer, self.arc_id, 'arc_id')
                try:
                    geometry = feature.geometry()
                    self.rubber_band.setToGeometry(geometry, None)
                    self.rubber_band.setColor(QColor(255, 0, 0, 100))
                    self.rubber_band.setWidth(5)
                    self.rubber_band.show()
                except AttributeError:
                    pass

        if self.arc_id is None: return

        # Populate combo arccat
        sql = "SELECT cat_arc.id AS id, cat_arc.id as idval FROM cat_arc WHERE id IS NOT NULL AND active IS TRUE "
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_replace_arc.cmb_newarccat, rows, 1)

        # Set text current arccat
        self.dlg_replace_arc.txt_current_arccat.setText(self.arc_cat_id)

        # Disconnect Snapping
        self.snapper_manager.recover_snapping_options()
        tools_qgis.disconnect_snapping(False, None, self.vertex_marker)
        tools_gw.disconnect_signal('psector')

        # Disable tab log
        tools_gw.disable_tab_log(self.dlg_replace_arc)

        # Triggers
        self.dlg_replace_arc.btn_accept.clicked.connect(partial(self._set_plan_replace_feature))
        self.dlg_replace_arc.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_replace_arc))
        self.dlg_replace_arc.rejected.connect(partial(tools_gw.reset_rubberband, self.rubber_band))

        # Open form
        tools_gw.open_dialog(self.dlg_replace_arc, dlg_name="replace_arc")


    def _set_plan_replace_feature(self):

        new_arc_cat = f'"{tools_qt.get_combo_value(self.dlg_replace_arc, self.dlg_replace_arc.cmb_newarccat)}"'

        feature = f'"featureType":"ARC", "ids":["{self.arc_id}"]'
        extras = f'"catalog":{new_arc_cat}'
        body = tools_gw.create_body(feature=feature, extras=extras)
        json_result = tools_gw.execute_procedure('gw_fct_setfeaturereplaceplan', body)

        # Force a map refresh
        tools_qgis.force_refresh_map_canvas()
        # Refresh tableview tbl_psector_x_arc, tbl_psector_x_connec, tbl_psector_x_gully
        self._refresh_tables_relations()

        message = json_result['message']['text']
        if message is not None:
            tools_qt.show_info_box(message)

        text_result, change_tab = tools_gw.fill_tab_log(self.dlg_replace_arc, json_result['body']['data'])

        if not change_tab:
            self.dlg_replace_arc.close()
            tools_gw.reset_rubberband(self.rubber_band)


    def _arc_fusion(self):

        if hasattr(self, 'emit_point') and self.emit_point is not None:
            tools_gw.disconnect_signal('psector', 'replace_arc_ep_canvasClicked_open_arc_replace_form')
        self.emit_point = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.emit_point)
        self.snapper_manager = GwSnapManager(self.iface)
        self.snapper = self.snapper_manager.get_snapper()
        self.layer_node = tools_qgis.get_layer_by_tablename("v_edit_node")

        # Vertex marker
        self.vertex_marker = self.snapper_manager.vertex_marker

        # Store user snapping configuration
        self.previous_snapping = self.snapper_manager.get_snapping_options()

        # Set signals
        tools_gw.connect_signal(self.canvas.xyCoordinates, self._mouse_move_node, 'psector',
                                'arc_fusion_xyCoordinates_mouse_move_node')
        tools_gw.connect_signal(self.emit_point.canvasClicked, self._perform_arc_fusion, 'psector',
                                'arc_fusion_ep_canvasClicked_open_arc_fusion_form')


    def _perform_arc_fusion(self, point):

        # Snap point
        event_point = self.snapper_manager.get_event_point(point=point)
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if result.isValid():
            # Check feature
            layer = self.snapper_manager.get_snapped_layer(result)
            if layer == self.layer_node:
                # Get the point
                snapped_feat = self.snapper_manager.get_snapped_feature(result)
                self.node_id = snapped_feat.attribute('node_id')
                self.node_state = snapped_feat.attribute('state')

                # Manage current psector
                sql = ("SELECT t1.psector_id FROM plan_psector AS t1 "
                       " INNER JOIN config_param_user AS t2 ON t1.psector_id::text = t2.value "
                       " WHERE t2.parameter='plan_psector_vdefault' AND cur_user = current_user")
                row = tools_db.get_row(sql)
                current_psector = row[0]
                selected_psector = tools_qt.get_text(self.dlg_plan_psector, self.psector_id)

                if str(current_psector) != str(selected_psector):
                    message = "This psector does not match the current one. Value of current psector will be updated."
                    tools_qt.show_info_box(message)

                    sql = (f"UPDATE config_param_user "
                           f"SET value = '{selected_psector}' "
                           f"WHERE parameter = 'plan_psector_vdefault' AND cur_user=current_user")
                    tools_db.execute_sql(sql)

                # Execute setarcfusion
                workcat_id = tools_qt.get_combo_value(self.dlg_plan_psector, self.workcat_id)
                feature_id = f'"id":["{self.node_id}"]'
                extras = f'"enddate":null'
                if workcat_id not in (None, 'null', ''):
                    extras += f', "workcatId":"{workcat_id}"'
                extras += f', "psectorId": "{selected_psector}"'
                extras += f', "action_mode": 1'
                extras += f', "state_type": null'
                body = tools_gw.create_body(feature=feature_id, extras=extras)
                # Execute SQL function and show result to the user
                result = tools_gw.execute_procedure('gw_fct_setarcfusion', body)
                if not result or result['status'] == 'Failed':
                    return

                # Force a map refresh
                tools_qgis.force_refresh_map_canvas()
                # Refresh tables
                self._refresh_tables_relations()


    def _manage_tab_feature_buttons(self):
        tab_idx = self.dlg_plan_psector.tab_feature.currentIndex()

        # Disable all by default
        self.dlg_plan_psector.btn_select_arc.setEnabled(False)
        self.dlg_plan_psector.btn_arc_fusion.setEnabled(False)
        self.dlg_plan_psector.btn_set_to_arc.setEnabled(False)

        if tab_idx == 0:
            # Enable btn select_arc
            self.dlg_plan_psector.btn_select_arc.setEnabled(True)

        if tab_idx == 1:
            # Enable btn arc_fusion
            self.dlg_plan_psector.btn_arc_fusion.setEnabled(True)

        # Tabs connec/gully
        if self.qtbl_connec.selectionModel() is None:
            return
        if tab_idx == 2 and self.qtbl_connec.selectionModel().selectedRows():
            self._enable_set_to_arc()
        elif tab_idx == 3 and self.qtbl_gully.selectionModel().selectedRows():
            self._enable_set_to_arc()


    def _enable_set_to_arc(self):
        self.dlg_plan_psector.btn_set_to_arc.setEnabled(True)


    def _mouse_move_arc(self, point):

        if not self.layer_arc:
            return

        # Set active layer
        self.iface.setActiveLayer(self.layer_arc)

        # Get clicked point and add marker
        self.vertex_marker.hide()
        event_point = self.snapper_manager.get_event_point(point=point)
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if result.isValid():
            self.snapper_manager.add_marker(result, self.vertex_marker)


    def _mouse_move_node(self, point):

        if not self.layer_node:
            return

        # Set active layer
        self.iface.setActiveLayer(self.layer_node)

        # Get clicked point and add marker
        self.vertex_marker.hide()
        event_point = self.snapper_manager.get_event_point(point=point)
        result = self.snapper_manager.snap_to_current_layer(event_point)
        if result.isValid():
            self.snapper_manager.add_marker(result, self.vertex_marker)

    # endregion
