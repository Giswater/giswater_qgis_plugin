"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import Qt, QDate, QObject, QStringListModel, pyqtSignal
from qgis.PyQt.QtGui import QStandardItemModel, QStandardItem
from qgis.PyQt.QtWidgets import QAbstractItemView, QDialogButtonBox, QCompleter, QLineEdit, QFileDialog, QTableView
from qgis.PyQt.QtWidgets import QTextEdit, QPushButton, QComboBox, QTabWidget
import os
import sys
import subprocess
import webbrowser
from functools import partial

from .. import utils_giswater
from ..dao.om_visit_event import OmVisitEvent
from ..dao.om_visit import OmVisit
from ..dao.om_visit_x_arc import OmVisitXArc
from ..dao.om_visit_x_connec import OmVisitXConnec
from ..dao.om_visit_x_node import OmVisitXNode
from ..dao.om_visit_x_gully import OmVisitXGully
from ..dao.om_visit_parameter import OmVisitParameter
from ..ui_manager import NewVisitUi
from ..ui_manager import EventStandard
from ..ui_manager import EventUDarcStandard
from ..ui_manager import VisitEventRehab
from ..ui_manager import VisitManagement
from .parent_manage import ParentManage
from .manage_document import ManageDocument


class ManageVisit(ParentManage, QObject):

    # event emitted when a new Visit is added when GUI is closed/accepted
    visit_added = pyqtSignal(int)

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control 'Add visit' of toolbar 'edit' """
        QObject.__init__(self)
        ParentManage.__init__(self, iface, settings, controller, plugin_dir)

    def manage_visit(self, visit_id=None, geom_type=None, feature_id=None, single_tool=True, expl_id=None, tag=None):
        # Get expl_id from previus dialog
        self.expl_id = expl_id
        # Get layers of every geom_type
        self.reset_lists()
        self.reset_layers()
        self.layers['arc'] = self.controller.get_group_layers('arc')
        self.layers['node'] = self.controller.get_group_layers('node')
        self.layers['connec'] = self.controller.get_group_layers('connec')
        self.layers['element'] = self.controller.get_group_layers('element')
        # Remove 'gully' for 'WS'
        if self.controller.get_project_type() != 'ws':
            self.layers['gully'] = self.controller.get_group_layers('gully')

        # Reset geometry
        self.x = None
        self.y = None
        self.dlg_add_visit = NewVisitUi(tag)
        self.load_settings(self.dlg_add_visit)
        # Set icons
        self.set_icon(self.dlg_add_visit.btn_feature_insert, "111")
        self.set_icon(self.dlg_add_visit.btn_feature_delete, "112")
        self.set_icon(self.dlg_add_visit.btn_feature_snapping, "137")
        self.set_icon(self.dlg_add_visit.btn_doc_insert, "111")
        self.set_icon(self.dlg_add_visit.btn_doc_delete, "112")
        self.set_icon(self.dlg_add_visit.btn_doc_new, "134")
        self.set_icon(self.dlg_add_visit.btn_open_doc, "170")
        self.set_icon(self.dlg_add_visit.btn_add_geom, "133")

        # Tab 'Data'/'Visit'
        self.visit_id = self.dlg_add_visit.findChild(QLineEdit, "visit_id")
        self.user_name = self.dlg_add_visit.findChild(QLineEdit, "user_name")
        self.ext_code = self.dlg_add_visit.findChild(QLineEdit, "ext_code")
        self.visitcat_id = self.dlg_add_visit.findChild(QComboBox, "visitcat_id")

        # tab 'Event'
        self.tbl_event = self.dlg_add_visit.findChild(QTableView, "tbl_event")
        self.parameter_type_id = self.dlg_add_visit.findChild(QComboBox, "parameter_type_id")
        self.parameter_id = self.dlg_add_visit.findChild(QComboBox, "parameter_id")

        # Tab 'Relations'
        self.feature_type = self.dlg_add_visit.findChild(QComboBox, "feature_type")
        self.tbl_relation = self.dlg_add_visit.findChild(QTableView, "tbl_relation")

        # tab 'Document'
        self.doc_id = self.dlg_add_visit.findChild(QLineEdit, "doc_id")
        self.btn_doc_insert = self.dlg_add_visit.findChild(QPushButton, "btn_doc_insert")
        self.btn_doc_delete = self.dlg_add_visit.findChild(QPushButton, "btn_doc_delete")
        self.btn_doc_new = self.dlg_add_visit.findChild(QPushButton, "btn_doc_new")
        self.btn_open_doc = self.dlg_add_visit.findChild(QPushButton, "btn_open_doc")
        self.tbl_document = self.dlg_add_visit.findChild(QTableView, "tbl_document")
        self.tbl_document.setSelectionBehavior(QAbstractItemView.SelectRows)

        self.set_selectionbehavior(self.dlg_add_visit)
        # Set current date and time
        current_date = QDate.currentDate()
        self.dlg_add_visit.startdate.setDate(current_date)
        self.dlg_add_visit.enddate.setDate(current_date)

        # set User name get from controller login
        if self.controller.user and self.user_name:
            self.user_name.setText(str(self.controller.user))

        self.fill_combos(visit_id=visit_id)
        # Set autocompleters of the form
        self.set_completers()
        if self.controller.get_project_type() != 'ud':
            utils_giswater.remove_tab_by_tabName(self.dlg_add_visit.tab_feature, "tab_gully")
        self.parameter_type_id.currentIndexChanged.connect(partial(self.set_parameter_id_combo))
        self.parameter_id.currentIndexChanged.connect(partial(self.manage_tabs))
        self.set_parameter_id_combo()
        self.manage_tabs()
        self.dlg_add_visit.btn_feature_insert.clicked.connect(partial(self.get_table_object))

        # Open the dialog
        self.open_dialog(self.dlg_add_visit, dlg_name="visit")


    def get_table_object(self):
        tables_name = {0: 'arc', 1: 'node', 2: 'connec', 3: 'gully'}
        idx = self.dlg_add_visit.tab_feature.currentIndex()
        self.geom_type = f"{tables_name[idx]}"
        self.insert_feature(self.dlg_add_visit, "om_visit", remove_ids=False)


    def manage_tabs(self):
        num_tabs = self.dlg_add_visit.tab_feature.count()
        for x in range(0, num_tabs):
            self.dlg_add_visit.tab_feature.setTabEnabled(x, True)
        feature_type = utils_giswater.get_item_data(self.dlg_add_visit, self.dlg_add_visit.parameter_id, 2)

        if feature_type in (None, -1):
            return

        for x in range(0, num_tabs):
            tab_name = self.dlg_add_visit.tab_feature.widget(x).objectName().lower()
            if tab_name != f"tab_{feature_type.lower()}":
                self.dlg_add_visit.tab_feature.setTabEnabled(x, False)


    def fill_combos(self, visit_id):
        # Visit tab
        # Fill ComboBox visitcat_id
        # save result in self.visitcat_ids to get id depending on selected combo
        sql = ("SELECT id, name FROM om_visit_cat"
               " WHERE active is true"
               " ORDER BY name")
        self.visitcat_ids = self.controller.get_rows(sql)

        if self.visitcat_ids:
            utils_giswater.set_item_data(self.dlg_add_visit.visitcat_id, self.visitcat_ids, 1)
            # now get default value to be show in visitcat_id
            row = self.controller.get_config('om_visit_cat_vdefault')
            if row:
                # if int then look for default row ans set it
                try:
                    utils_giswater.set_combo_itemData(self.dlg_add_visit.visitcat_id, row[0], 0)
                    for i in range(0, self.dlg_add_visit.visitcat_id.count()):
                        elem = self.dlg_add_visit.visitcat_id.itemData(i)
                        if str(row[0]) == str(elem[0]):
                            utils_giswater.setWidgetText(self.dlg_add_visit.visitcat_id, (elem[1]))
                except TypeError:
                    pass
                except ValueError:
                    pass
            elif visit_id is not None:
                sql = (f"SELECT visitcat_id"
                       f" FROM om_visit"
                       f" WHERE id ='{visit_id}' ")
                id_visitcat = self.controller.get_row(sql)
                sql = (f"SELECT id, name"
                       f" FROM om_visit_cat"
                       f" WHERE active is true AND id ='{id_visitcat[0]}' "
                       f" ORDER BY name")
                row = self.controller.get_row(sql)
                utils_giswater.set_combo_itemData(self.dlg_add_visit.visitcat_id, str(row[1]), 1)

        # Fill ComboBox status
        rows = self.get_values_from_catalog('om_typevalue', 'visit_status')
        if rows:
            utils_giswater.set_item_data(self.dlg_add_visit.status, rows, 1, sort_combo=True)
            if visit_id is not None:
                sql = (f"SELECT status "
                       f"FROM om_visit "
                       f"WHERE id ='{visit_id}' ")
                status = self.controller.get_row(sql)
                utils_giswater.set_combo_itemData(self.dlg_add_visit.status, str(status[0]), 0)


        # Event tab
        # Fill ComboBox parameter_type_id
        sql = ("SELECT id, id "
               "FROM om_visit_parameter_type "
               "ORDER BY id")
        parameter_type_ids = self.controller.get_rows(sql)
        utils_giswater.set_item_data(self.dlg_add_visit.parameter_type_id, parameter_type_ids, 1)


    def set_parameter_id_combo(self):
        """set parameter_id combo basing on current selections."""
        p_type_id = utils_giswater.get_item_data(self.dlg_add_visit, self.dlg_add_visit.parameter_type_id)
        self.dlg_add_visit.parameter_id.clear()
        sql = (f"SELECT id, parameter_type, feature_type, descript"
               f" FROM config_visit_parameter"
               f" WHERE UPPER (parameter_type) = '{p_type_id}'"   
               f" ORDER BY id;")

        rows = self.controller.get_rows(sql, log_sql=True)

        if rows:
            utils_giswater.set_item_data(self.dlg_add_visit.parameter_id, rows, 3)
        self.parameter_id.currentIndexChanged.emit(self.parameter_id.currentIndex())


    def set_completers(self):
        """ Set autocompleters of the form """

        # Adding auto-completion to a QLineEdit - visit_id
        self.completer = QCompleter()
        self.dlg_add_visit.visit_id.setCompleter(self.completer)
        model = QStringListModel()

        sql = "SELECT DISTINCT(id) FROM om_visit"
        rows = self.controller.get_rows(sql, commit=self.autocommit)
        values = []
        if rows:
            for row in rows:
                values.append(str(row[0]))

        model.setStringList(values)
        self.completer.setModel(model)

        # Adding auto-completion to a QLineEdit - document_id
        self.completer = QCompleter()
        self.dlg_add_visit.doc_id.setCompleter(self.completer)
        model = QStringListModel()

        sql = "SELECT DISTINCT(id) FROM v_ui_document"
        rows = self.controller.get_rows(sql, commit=self.autocommit)
        values = []
        if rows:
            for row in rows:
                values.append(str(row[0]))

        model.setStringList(values)
        self.completer.setModel(model)