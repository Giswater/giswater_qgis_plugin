"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
from datetime import datetime
from functools import partial

from qgis.PyQt.QtCore import Qt, QDate, QStringListModel, pyqtSignal, QDateTime, QObject
from qgis.PyQt.QtGui import QStandardItemModel, QStandardItem
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtWidgets import QAbstractItemView, QDialogButtonBox, QCompleter, QLineEdit, QFileDialog, QTableView, \
    QTextEdit, QPushButton, QComboBox, QTabWidget, QDateEdit, QDateTimeEdit

from .document import GwDocument
from ..models.om_visit import GwOmVisit
from ..models.om_visit_event import GwOmVisitEvent
from ..models.om_visit_x_arc import GwOmVisitXArc
from ..models.om_visit_x_connec import GwOmVisitXConnec
from ..models.om_visit_x_node import GwOmVisitXNode
from ..models.om_visit_x_gully import GwOmVisitXGully
from ..models.config_visit_parameter import GwConfigVisitParameter
from ..ui.ui_manager import GwVisitUi, GwVisitEventUi, GwVisitEventRehabUi, GwVisitManagerUi
from ..utils import tools_gw
from ..utils.snap_manager import GwSnapManager
from ... import global_vars
from ...lib import tools_qgis, tools_qt, tools_log, tools_db, tools_os


class GwVisit(QObject):

    # event emitted when a new Visit is added when GUI is closed/accepted
    visit_added = pyqtSignal(int)

    def __init__(self):
        """ Class to control 'Add visit' of toolbar 'edit' """

        QObject.__init__(self)
        self.canvas = global_vars.canvas
        self.schema_name = global_vars.schema_name
        self.iface = global_vars.iface
        self.feature_type = None
        self.layers = None
        self.event_parameter_id = None
        self.event_feature_type = None
        self.lazy_widget = None
        self.lazy_init_function = None
        self.snapper_manager = GwSnapManager(self.iface)
        self.vertex_marker = self.snapper_manager.vertex_marker


    def get_visit(self, visit_id=None, feature_type=None, feature_id=None, single_tool=True, expl_id=None, tag=None,
                  open_dlg=True, is_new_from_cf=False):

        """ Button 64. Add visit.
        if visit_id => load record related to the visit_id
        if feature_type => lock feature_type in relations tab
        if feature_id => load related feature basing on feature_type in relation
        if single_tool notify that the tool is used called from another dialog."""

        self.rubber_band = tools_gw.create_rubberband(self.canvas)

        # parameter to set if the dialog is working as single tool or integrated in another tool
        global_vars.single_tool_mode = single_tool

        # bool to distinguish if we entered to edit an exisiting Visit or creating a new one
        self.it_is_new_visit = (not visit_id)
        self.visit_id_value = visit_id

        # Remove previous selection
        for layer in self.canvas.layers():
            if layer.type() == layer.VectorLayer:
                layer.removeSelection()

        self.iface.mapCanvas().refresh()
        # set vars to manage if GUI have to lock the relation
        self.locked_feature_type = feature_type
        self.locked_feature_id = feature_id

        # Create the dialog and signals and related ORM Visit class
        self.current_visit = GwOmVisit()
        self.dlg_add_visit = GwVisitUi(tag)
        tools_gw.load_settings(self.dlg_add_visit)
        # Get layer visibility to restore when dialog is closed
        layers_visibility = {}
        for layer_name in ["v_edit_arc", "v_edit_node", "v_edit_connec", "v_edit_element", "v_edit_gully"]:
            layer = tools_qgis.get_layer_by_tablename(layer_name)
            if layer:
                layers_visibility[layer] = tools_qgis.is_layer_visible(layer)

        self.dlg_add_visit.rejected.connect(partial(tools_gw.restore_parent_layers_visibility, layers_visibility))
        self.dlg_add_visit.rejected.connect(tools_gw.remove_selection)
        self.dlg_add_visit.accepted.connect(partial(tools_gw.restore_parent_layers_visibility, layers_visibility))

        # Get expl_id from previus dialog
        self.expl_id = expl_id

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
        self.layers['element'] = tools_gw.get_layers_from_feature_type('element')
        if tools_gw.get_project_type() == 'ud':
            self.layers['gully'] = tools_gw.get_layers_from_feature_type('gully')

        # Remove 'gully' for 'WS'
        if tools_gw.get_project_type() == 'ws':
            tools_qt.remove_tab(self.dlg_add_visit.tab_feature, 'tab_gully')

        # Feature type of selected parameter
        self.feature_type_parameter = None

        # Reset geometry
        self.point_xy = {"x": None, "y": None}


        # Set icons
        tools_gw.add_icon(self.dlg_add_visit.btn_feature_insert, "111", sub_folder="24x24")
        tools_gw.add_icon(self.dlg_add_visit.btn_feature_delete, "112", sub_folder="24x24")
        tools_gw.add_icon(self.dlg_add_visit.btn_feature_snapping, "137")
        tools_gw.add_icon(self.dlg_add_visit.btn_doc_insert, "111", sub_folder="24x24")
        tools_gw.add_icon(self.dlg_add_visit.btn_doc_delete, "112", sub_folder="24x24")
        tools_gw.add_icon(self.dlg_add_visit.btn_doc_new, "134")
        tools_gw.add_icon(self.dlg_add_visit.btn_open_doc, "170")
        tools_gw.add_icon(self.dlg_add_visit.btn_add_geom, "133")

        # tab events
        self.tabs = self.dlg_add_visit.findChild(QTabWidget, 'tab_widget')
        self.button_box = self.dlg_add_visit.findChild(QDialogButtonBox, 'button_box')
        if visit_id is None:
            self.button_box.button(QDialogButtonBox.Ok).setEnabled(False)

        # Tab 'Data'/'Visit'
        self.visit_id = self.dlg_add_visit.findChild(QLineEdit, "visit_id")
        self.user_name = self.dlg_add_visit.findChild(QLineEdit, "user_name")
        self.ext_code = self.dlg_add_visit.findChild(QLineEdit, "ext_code")
        self.visitcat_id = self.dlg_add_visit.findChild(QComboBox, "visitcat_id")
        self.exploitation = self.dlg_add_visit.findChild(QComboBox, "expl_id")

        # tab 'Event'
        self.tbl_event = self.dlg_add_visit.findChild(QTableView, "tbl_event")
        self.parameter_type_id = self.dlg_add_visit.findChild(QComboBox, "parameter_type_id")
        self.parameter_id = self.dlg_add_visit.findChild(QComboBox, "parameter_id")
        self.cmb_feature_type = self.dlg_add_visit.findChild(QComboBox, "feature_type")

        # tab 'Document'
        self.doc_id = self.dlg_add_visit.findChild(QLineEdit, "doc_id")
        self.btn_doc_insert = self.dlg_add_visit.findChild(QPushButton, "btn_doc_insert")
        self.btn_doc_delete = self.dlg_add_visit.findChild(QPushButton, "btn_doc_delete")
        self.btn_doc_new = self.dlg_add_visit.findChild(QPushButton, "btn_doc_new")
        self.btn_open_doc = self.dlg_add_visit.findChild(QPushButton, "btn_open_doc")
        self.tbl_document = self.dlg_add_visit.findChild(QTableView, "tbl_document")
        self.tbl_document.setSelectionBehavior(QAbstractItemView.SelectRows)

        widget_list = self.dlg_add_visit.findChildren(QTableView)
        for widget in widget_list:
            tools_qt.set_tableview_config(widget)

        # Check the default dates, if it does not exist force today
        _date = QDate.currentDate()
        date_string = tools_gw.get_config_value('om_visit_startdate_vdefault')
        if date_string:
            _date = datetime.strptime(date_string[0], '%Y/%m/%d')
        self.dlg_add_visit.startdate.setDate(_date)

        # Check the default dates, if it does not exist force today
        _date = QDate.currentDate()
        date_string = tools_gw.get_config_value('om_visit_startdate_vdefault')
        if date_string:
            _date = datetime.strptime(date_string[0], '%Y/%m/%d')
        self.dlg_add_visit.startdate.setDate(_date)

        date_string = tools_gw.get_config_value('om_visit_enddate_vdefault')
        if date_string is not None:
            _date = datetime.strptime(date_string[0], '%Y/%m/%d')
        self.dlg_add_visit.enddate.setDate(_date)

        # set User name get from login
        if global_vars.current_user and self.user_name:
            self.user_name.setText(str(global_vars.current_user))

        # set the start tab to be shown (e.g. tab_visit)
        self.current_tab_index = self._tab_index('tab_visit')
        self.tabs.setCurrentIndex(self.current_tab_index)

        # Set signals
        self._set_signals()

        # Set autocompleters of the form
        self._set_completers()

        # Show id of visit. If not set, infer a new value
        self._fill_combos(visit_id=visit_id)
        if not visit_id:
            visit_id = self.current_visit.nextval()

        self.visit_id.setText(str(visit_id))

        if tools_gw.get_project_type() == 'ud':
            self._event_feature_type_selected(self.dlg_add_visit, "gully")
        self._event_feature_type_selected(self.dlg_add_visit, "node")
        self._event_feature_type_selected(self.dlg_add_visit, "connec")
        self._event_feature_type_selected(self.dlg_add_visit, "arc")

        # Force _visit_tab_feature_changed
        excluded_layers = ["v_edit_arc", "v_edit_node", "v_edit_connec", "v_edit_element", "v_edit_gully",
                           "v_edit_element"]
        self.excluded_layers = excluded_layers
        self._visit_tab_feature_changed(self.dlg_add_visit, 'visit', excluded_layers=excluded_layers)

        # Manage relation locking
        if self.locked_feature_type:
            self._set_locked_relation()


        if self.it_is_new_visit is False:
            # Disable widgets when the visit is not new
            # self.dlg_add_visit.btn_feature_insert.setEnabled(False)
            # self.dlg_add_visit.btn_feature_delete.setEnabled(False)
            # self.dlg_add_visit.btn_feature_snapping.setEnabled(False)
            # self.dlg_add_visit.tab_feature.setEnabled(False)
            self.dlg_add_visit.tab_feature.tabBar().setEnabled(False)

            # Zoom to selected geometry or relations
            visit_layer = tools_qgis.get_layer_by_tablename('v_edit_om_visit')
            if visit_layer:
                visit_layer.selectByExpression(f'"id"={visit_id}')
                box = visit_layer.boundingBoxOfSelected()
                visit_layer.removeSelection()
                if not box.isNull():
                    self._zoom_box(box)
                else:
                    for layer in self.layers[self.feature_type]:
                        box = layer.boundingBoxOfSelected()
                        self._zoom_box(box)

        # Open the dialog
        if open_dlg:
            # If the new visit dont come from info emit signal
            if is_new_from_cf is False:
                self.cmb_feature_type.currentIndexChanged.emit(0)
            tools_gw.open_dialog(self.dlg_add_visit, dlg_name="visit")


    def manage_visits(self, feature_type=None, feature_id=None):
        """ Button 65: manage visits """

        # Create the dialog
        self.dlg_visit_manager = GwVisitManagerUi()
        tools_gw.load_settings(self.dlg_visit_manager)
        self.dlg_visit_manager.tbl_visit.setSelectionBehavior(QAbstractItemView.SelectRows)

        if feature_type is None:
            # Set a model with selected filter. Attach that model to selected table
            tools_qt.set_widget_text(self.dlg_visit_manager, self.dlg_visit_manager.lbl_filter, 'Filter by ext_code')
            filed_to_filter = "ext_code"
            table_object = "v_ui_om_visit"
            expr_filter = ""
            message = tools_qt.fill_table(self.dlg_visit_manager.tbl_visit, table_object)
            if message:
                tools_qgis.show_warning(message)
            tools_gw.set_tablemodel_config(self.dlg_visit_manager, self.dlg_visit_manager.tbl_visit, table_object)
        else:
            # Set a model with selected filter. Attach that model to selected table
            tools_qt.set_widget_text(self.dlg_visit_manager, self.dlg_visit_manager.lbl_filter, 'Filter by code')
            filed_to_filter = "code"
            table_object = "v_ui_om_visitman_x_" + str(feature_type)
            expr_filter = f"{feature_type}_id = '{feature_id}'"
            # Refresh model with selected filter
            message = tools_qt.fill_table(self.dlg_visit_manager.tbl_visit, table_object, expr_filter)
            if message:
                tools_qgis.show_warning(message)
            tools_gw.set_tablemodel_config(self.dlg_visit_manager, self.dlg_visit_manager.tbl_visit, table_object)

        # manage save and rollback when closing the dialog
        self.dlg_visit_manager.rejected.connect(partial(tools_gw.close_dialog, self.dlg_visit_manager))
        self.dlg_visit_manager.btn_close.clicked.connect(partial(tools_gw.close_dialog, self.dlg_visit_manager))

        # Set signals
        self.dlg_visit_manager.tbl_visit.doubleClicked.connect(
            partial(self._open_selected_object_visit, self.dlg_visit_manager, self.dlg_visit_manager.tbl_visit, table_object))
        self.dlg_visit_manager.btn_open.clicked.connect(
            partial(self._open_selected_object_visit, self.dlg_visit_manager, self.dlg_visit_manager.tbl_visit, table_object))
        self.dlg_visit_manager.btn_delete.clicked.connect(
            partial(tools_gw.delete_selected_rows, self.dlg_visit_manager.tbl_visit, table_object))
        self.dlg_visit_manager.txt_filter.textChanged.connect(partial(self._filter_visit, self.dlg_visit_manager,
            self.dlg_visit_manager.tbl_visit, self.dlg_visit_manager.txt_filter, table_object, expr_filter, filed_to_filter))

        self.dlg_visit_manager.txt_filter.textChanged.connect(partial(self._filter_visit, self.dlg_visit_manager,
            self.dlg_visit_manager.tbl_visit, self.dlg_visit_manager.txt_filter, table_object, expr_filter, filed_to_filter))

        # set timeStart and timeEnd as the min/max dave values get from model
        tools_gw.set_dates_from_to(self.dlg_visit_manager.date_event_from, self.dlg_visit_manager.date_event_to,
                                   'om_visit', 'startdate', 'enddate')

        # set date events
        self.dlg_visit_manager.date_event_from.dateChanged.connect(partial(self._filter_visit, self.dlg_visit_manager,
            self.dlg_visit_manager.tbl_visit, self.dlg_visit_manager.txt_filter, table_object, expr_filter, filed_to_filter))
        self.dlg_visit_manager.date_event_to.dateChanged.connect(partial(self._filter_visit, self.dlg_visit_manager,
            self.dlg_visit_manager.tbl_visit, self.dlg_visit_manager.txt_filter, table_object, expr_filter, filed_to_filter))

        # Open form
        tools_gw.open_dialog(self.dlg_visit_manager, dlg_name="lot_visitmanager")


    def get_visit_dialog(self):
        return self.dlg_add_visit


    # region private functions

    def _update_table_visit(self, widget, table_name, expr_filter=None, cmb_visitclass=None, id=None):

        """ Set a model with selected filter.
                Attach that model to selected table """
        if self.schema_name not in table_name:
            table_name = self.schema_name + "." + table_name

        # Set model
        model = QSqlTableModel()
        model.setTable(table_name)
        model.setEditStrategy(QSqlTableModel.OnManualSubmit)
        if expr_filter is not None:
            model.setFilter(expr_filter)
        model.select()

        # Check for errors
        if model.lastError().isValid():
            tools_qgis.show_warning(model.lastError().text())

            # Attach model to table view
        if widget:
            widget.setModel(model)
        else:
            tools_log.log_info("set_model_to_table: widget not found")
        current_visit_class = tools_qt.get_combo_value(self.dlg_add_visit, self.dlg_add_visit.visitclass_id, 0)
        feature_key = tools_qgis.get_primary_key()
        feature_type = 'node'
        if feature_key == 'node_id':
            feature_type = 'node'
        elif feature_key == 'connec_id':
            feature_type = 'connec'
        elif feature_key == 'arc_id':
            feature_type = 'arc'
        elif feature_key == 'gully_id':
            feature_type = 'gully'
        # Fill ComboBox cmb_visit_class
        sql = ("SELECT DISTINCT(class_id), om_visit_class.idval"
               " FROM " + self.schema_name + ".v_ui_om_visit_x_" + feature_type + ""
               " JOIN " + self.schema_name + ".om_visit_class ON om_visit_class.id = v_ui_om_visit_x_" + feature_type + ".class_id"
               " WHERE " + str(feature_key) + " IS NOT NULL AND " + str(feature_key) + " = '" + str(id) + "'")
        rows = tools_db.get_rows(sql)
        tools_qt.set_combo_value(cmb_visitclass, rows, 1)
        tools_qt.fill_combo_values(cmb_visitclass, str(current_visit_class), 0)


    def _delete_files(self, qtable, visit_id, event_id):
        """ Delete rows from table om_visit_event_photo, NOT DELETE FILES FROM DISC """

        # Get selected rows
        selected_list = qtable.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qt.show_info_box(message)
            return

        list_values = ""

        for x in range(0, len(selected_list)):
            # Get index of row and row[index]
            row_index = selected_list[x]
            row = row_index.row()
            col_index = tools_qt.get_col_index_by_col_name(qtable, 'value')
            value = row_index.sibling(row, col_index).data()
            if value in self.files_added:
                self.files_added.remove(value)
            if value in self.files_all:
                self.files_all.remove(value)
            list_values += "'" + str(value) + "',\n"
        list_values = list_values[:-2]

        message = "Are you sure you want to delete these records?"
        title = "Delete records"
        answer = tools_qt.show_question(message, title, list_values)
        if answer:
            sql = (f"DELETE FROM om_visit_event_photo "
                   f"WHERE visit_id='{visit_id}' "
                   f"AND event_id='{event_id}' "
                   f"AND value IN ({list_values})")
            tools_db.execute_sql(sql)
            self._populate_tbl_docs_x_event(event_id)
        else:
            return


    def _zoom_box(self, box):
        """
        :param box: (QgsRectangle)
        """
        # When it is a point, and only one, it must be converted into a rectangle to be able to zoom
        if not box.isNull():
            if box.xMinimum() == box.xMaximum() and box.yMinimum() == box.yMaximum():
                box.setXMaximum(box.xMaximum() + 0.0001)
                box.setYMaximum(box.yMaximum() + 0.0001)
                box.setXMaximum(box.xMinimum() + 0.0001)
                box.setYMaximum(box.yMinimum() + 0.0001)
            box.set(box.xMinimum() - 10, box.yMinimum() - 10, box.xMaximum() + 10, box.yMaximum() + 10)
            self.iface.mapCanvas().setExtent(box)
            self.iface.mapCanvas().refresh()


    def _open_selected_object_visit(self, dialog, widget, table_object):

        selected_list = widget.selectionModel().selectedRows()
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qgis.show_warning(message, dialog=dialog)
            return

        row = selected_list[0].row()

        # Get object_id from selected row
        field_object_id = "id"
        if "v_ui_om_visitman_x_" in table_object:
            field_object_id = "visit_id"
        selected_object_id = widget.model().record(row).value(field_object_id)

        # Close this dialog and open selected object
        keep_open_form = tools_gw.get_config_parser('dialogs_actions', 'visit_manager_keep_open', "user", "init", prefix=True)
        if tools_os.set_boolean(keep_open_form, False) is not True:
            dialog.close()

        if table_object == "v_ui_om_visit" or "v_ui_om_visitman_x_" in table_object:
            self.get_visit(visit_id=selected_object_id)

        # Disconnect open visit from table_visit once there opened
        self.dlg_visit_manager.tbl_visit.doubleClicked.disconnect()
        self.dlg_visit_manager.btn_open.clicked.disconnect()
        self.dlg_add_visit.rejected.connect(partial(self._reconnect_table_signals, table_object))
        self.dlg_add_visit.accepted.connect(partial(self._reconnect_table_signals, table_object))


    def _reconnect_table_signals(self, table_object):
        try:
            self.dlg_visit_manager.tbl_visit.doubleClicked.connect(
                partial(self._open_selected_object_visit, self.dlg_visit_manager, self.dlg_visit_manager.tbl_visit,
                        table_object))
        except RuntimeError:
            pass
        try:
            self.dlg_visit_manager.btn_open.clicked.connect(
                partial(self._open_selected_object_visit, self.dlg_visit_manager, self.dlg_visit_manager.tbl_visit,
                        table_object))
        except RuntimeError:
            pass


    def _set_signals(self):

        self.dlg_add_visit.rejected.connect(self._manage_rejected)
        self.dlg_add_visit.rejected.connect(partial(tools_gw.close_dialog, self.dlg_add_visit))
        self.dlg_add_visit.rejected.connect(lambda: tools_gw.reset_rubberband(self.rubber_band))
        self.dlg_add_visit.accepted.connect(partial(self._update_relations, self.dlg_add_visit))
        self.dlg_add_visit.accepted.connect(partial(self._manage_accepted))

        self.dlg_add_visit.btn_event_insert.clicked.connect(self._event_insert)
        self.dlg_add_visit.btn_event_delete.clicked.connect(self._event_delete)
        self.dlg_add_visit.btn_event_update.clicked.connect(self._event_update)
        self.tabs.currentChanged.connect(partial(self._manage_tab_changed, self.dlg_add_visit))
        self.visit_id.textChanged.connect(partial(self._manage_visit_id_change, self.dlg_add_visit))
        self.dlg_add_visit.btn_doc_insert.clicked.connect(self._document_insert)
        self.dlg_add_visit.btn_doc_delete.clicked.connect(self._document_delete)
        self.dlg_add_visit.btn_doc_new.clicked.connect(self._manage_document)
        self.dlg_add_visit.btn_open_doc.clicked.connect(partial(tools_qt.document_open, self.tbl_document, 'path'))
        self.tbl_document.doubleClicked.connect(partial(tools_qt.document_open, self.tbl_document, 'path'))
        self.dlg_add_visit.btn_add_geom.clicked.connect(self._add_feature_clicked)

        # Fill combo boxes of the form and related events
        self.parameter_type_id.currentIndexChanged.connect(partial(self._set_parameter_id_combo, self.dlg_add_visit))
        self.cmb_feature_type.currentIndexChanged.connect(
            partial(self._event_feature_type_selected, self.dlg_add_visit, None))
        self.cmb_feature_type.currentIndexChanged.connect(partial(self._manage_tabs_enabled, True))
        self.parameter_id.currentIndexChanged.connect(self._get_feature_type_of_parameter)
        self.dlg_add_visit.tbl_visit_x_arc.clicked.connect(partial(tools_qgis.hilight_feature_by_id,
            self.dlg_add_visit.tbl_visit_x_arc, "v_edit_arc", "arc_id", self.rubber_band, 5))
        self.dlg_add_visit.tbl_visit_x_node.clicked.connect(partial(tools_qgis.hilight_feature_by_id,
            self.dlg_add_visit.tbl_visit_x_node, "v_edit_node", "node_id", self.rubber_band, 10))
        self.dlg_add_visit.tbl_visit_x_connec.clicked.connect(partial(tools_qgis.hilight_feature_by_id,
            self.dlg_add_visit.tbl_visit_x_connec, "v_edit_connec", "connec_id", self.rubber_band, 10))
        self.dlg_add_visit.tbl_visit_x_gully.clicked.connect(partial(tools_qgis.hilight_feature_by_id,
            self.dlg_add_visit.tbl_visit_x_gully, "v_edit_gully", "gully_id", self.rubber_band, 10))


    def _add_feature_clicked(self):

        self.previous_map_tool = global_vars.canvas.mapTool()
        self.snapper_manager.add_point(self.vertex_marker)
        self.point_xy = self.snapper_manager.point_xy


    def _set_locked_relation(self):
        """ Set feature_type and listed feature_id in @table_name to lock it """

        # Enable tab
        index = self._tab_index('tab_relations')
        self.tabs.setTabEnabled(index, True)

        # set geometry_type
        feature_type_index = self.cmb_feature_type.findText(self.locked_feature_type.upper())
        if feature_type_index < 0:
            return

        # set default combo box value = trigger model and selection of related features
        if self.cmb_feature_type.currentIndex() != feature_type_index:
            self.cmb_feature_type.setCurrentIndex(feature_type_index)
        else:
            self.cmb_feature_type.currentIndexChanged.emit(feature_type_index)

        # Load feature if in @table_name. Select list of related features
        # Set 'expr_filter' with features that are in the list
        if self.locked_feature_id:
            expr_filter = f'"{self.feature_type}_id" IN (\'{self.locked_feature_id}\')'
            (is_valid, expr) = tools_qt.check_expression_filter(expr_filter)
            if not is_valid:
                return

            # do selection allowing @table_name to be linked to canvas selectionChanged
            widget_name = f'tbl_visit_x_{self.feature_type}'
            widget_table = tools_qt.get_widget(self.dlg_add_visit, widget_name)
            tools_qgis.disconnect_signal_selection_changed()
            tools_gw.disconnect_signal('visit')
            tools_gw.connect_signal(global_vars.canvas.selectionChanged,
                                    partial(tools_gw.selection_changed, self, self.dlg_add_visit, widget_table, False),
                                    'visit', 'set_locked_relation_canvas_selectionChanged')
            tools_qgis.select_features_by_ids(self.feature_type, expr, self.layers)
            tools_qgis.disconnect_signal_selection_changed()
            tools_gw.disconnect_signal('visit')


    def _manage_accepted(self):
        """ Do all action when closed the dialog with Ok.
        e.g. all necessary commits and cleanings.
        A) Trigger SELECT gw_fct_om_visit_multiplier (visit_id, feature_type)
        for multiple visits management. """

        # tab Visit
        if self.current_tab_index == self._tab_index('tab_visit'):
            self._manage_leave_visit_tab()

        expl_value = tools_qt.get_combo_value(self.dlg_add_visit, self.exploitation)
        if expl_value not in (None, 'None', ''):
            tools_gw.set_config_parser('btn_add_visit', 'expl_id', expl_value)
        # Remove all previous selections
        tools_qgis.disconnect_signal_selection_changed()
        tools_gw.disconnect_signal('visit')
        self.layers = tools_gw.remove_selection(layers=self.layers)

        # Update geometry field (if user have selected a point)
        if self.point_xy['x'] is not None:
            self._update_geom()

        layer = tools_qgis.get_layer_by_tablename('v_edit_om_visit')
        if layer:
            layer.dataProvider().reloadData()

        # If new visit, execute PG function
        if self.it_is_new_visit:
            self._execute_pgfunction()

        # notify that a new visit has been added
        self.visit_added.emit(self.current_visit.id)

        layer = tools_qgis.get_layer_by_tablename('v_edit_om_visit')
        if layer:
            layer.dataProvider().reloadData()
        tools_qgis.refresh_map_canvas()


    def _execute_pgfunction(self):
        """ Execute function 'gw_fct_om_visit_multiplier' """

        feature = f'"id":"{self.current_visit.id}"'
        body = tools_gw.create_body(feature=feature)
        complet_result = tools_gw.execute_procedure('gw_fct_om_visit_multiplier', body)
        if complet_result is None:
            return
        tools_log.log_info(f"execute_pgfunction: {complet_result}")


    def _update_geom(self):
        """ Update geometry field """

        srid = global_vars.data_epsg
        sql = (f"UPDATE om_visit"
               f" SET the_geom = ST_SetSRID(ST_MakePoint({self.point_xy['x']},{self.point_xy['y']}), {srid})"
               f" WHERE id = {self.current_visit.id}")
        tools_db.execute_sql(sql)


    def _manage_rejected(self):
        """ Do all action when closed the dialog with Cancel or X.
        e.g. all necessary rollbacks and cleanings. """

        try:
            self.canvas.setMapTool(self.previous_map_tool)
            # removed current working visit. This should cascade removing of all related records
            if hasattr(self, 'it_is_new_visit') and self.it_is_new_visit:
                self.current_visit.delete()

            # Remove all previous selections
            tools_qgis.disconnect_signal_selection_changed()
            tools_gw.disconnect_signal('visit')
            self.layers = tools_gw.remove_selection(layers=self.layers)
        except Exception as e:
            tools_log.log_info(f"manage_rejected: {e}")


    def _tab_index(self, tab_name):
        """ Get the index of a tab basing on objectName. """

        for idx in range(self.tabs.count()):
            if self.tabs.widget(idx).objectName() == tab_name:
                return idx
        return -1


    def _manage_visit_id_change(self, dialog, text):
        """ Manage action when the visit id is changed.
        A) Update current Visit record
        B) Fill the GUI values of the current visit
        C) load all related events in the relative table
        D) load all related documents in the relative table. """

        self.event_parameter_id = None
        self.event_feature_type = None
        tools_qt.set_widget_enabled(self.dlg_add_visit, 'parameter_id', True)

        # A) Update current Visit record
        self.current_visit.id = int(text)
        exist = self.current_visit.fetch()
        if exist:
            # B) Fill the GUI values of the current visit
            self._fill_widget_with_fields(self.dlg_add_visit, self.current_visit, self.current_visit.field_names())
            # Get parameter_id and feature_type from his event
            self.event_parameter_id, self.event_feature_type = self._get_data_from_event(self.visit_id_value)
            tools_qt.set_combo_value(self.dlg_add_visit.parameter_id, self.event_parameter_id, 0)

        # C) load all related events in the relative table
        self.filter = f"visit_id = '{text}'"
        table_name = "v_ui_om_event"
        message = tools_qt.fill_table(self.tbl_event, table_name, self.filter)
        if message:
            tools_qgis.show_warning(message)
        tools_gw.set_tablemodel_config(dialog, self.tbl_event, table_name)
        self._manage_events_changed()

        # D) load all related documents in the relative table
        table_name = "v_ui_doc_x_visit"
        message = tools_qt.fill_table(self.tbl_document, table_name, self.filter)
        if message:
            tools_qgis.show_warning(message)
        tools_gw.set_tablemodel_config(dialog, self.tbl_document, table_name)

        # E) load all related Relations in the relative table
        self._set_feature_type_by_visit_id()


    def _set_feature_type_by_visit_id(self):
        """ Set the feature_type in Relation tab basing on visit_id.
        The steps to follow are:
        1) check geometry type looking what table contain records related with visit_id
        2) set gemetry type. """

        selected_feature_type = None
        feature_type_index = None
        for index in range(self.cmb_feature_type.count()):
            # feture_type combobox is filled before the visit_id is changed
            # it will contain all the geometry type allows basing on project type
            feature_type = self.cmb_feature_type.itemText(index).lower()
            if feature_type != '' and feature_type != 'all':
                table_name = f'om_visit_x_{feature_type}'
                sql = f"SELECT id FROM {table_name} WHERE visit_id = '{self.current_visit.id}'"
                rows = tools_db.get_rows(sql, log_info=False)
                if not rows or not rows[0]:
                    continue

                selected_feature_type = feature_type
                feature_type_index = index
                break

        # if no related records found do nothing
        if not selected_feature_type:
            return

        # set default combo box value = trigger model and selection
        # of related features
        if self.cmb_feature_type.currentIndex() != feature_type_index:
            self.cmb_feature_type.setCurrentIndex(feature_type_index)
        else:
            self.cmb_feature_type.currentIndexChanged.emit(feature_type_index)


    def _manage_leave_visit_tab(self):
        """ Manage all the action when leaving the tab_visit
        A) Manage sync between GUI values and Visit record in DB. """

        # A) fill Visit basing on GUI values
        self.current_visit.id = int(self.visit_id.text())
        self.current_visit.startdate = tools_qt.get_calendar_date(self.dlg_add_visit, 'startdate')
        self.current_visit.enddate = tools_qt.get_calendar_date(self.dlg_add_visit, 'enddate')
        self.current_visit.user_name = self.user_name.text()
        self.current_visit.ext_code = self.ext_code.text()
        self.current_visit.visitcat_id = tools_qt.get_combo_value(self.dlg_add_visit, 'visitcat_id', 0)
        self.current_visit.descript = tools_qt.get_text(self.dlg_add_visit, 'descript', False, False)
        self.current_visit.status = tools_qt.get_combo_value(self.dlg_add_visit, 'status', 0)
        if self.expl_id is None:
            self.expl_id = tools_qt.get_combo_value(self.dlg_add_visit, self.exploitation)
        if self.expl_id:
            self.current_visit.expl_id = self.expl_id

        # update or insert but without closing the transaction
        self.current_visit.upsert()


    def _update_relations(self, dialog, delete_old_relations=True):
        """ Save current selected features in every table of feature_type """

        if delete_old_relations:
            for index in range(self.cmb_feature_type.count()):
                # Remove all old relations related with current visit_id and @feature_type
                feature_type = self.cmb_feature_type.itemText(index).lower()
                self._delete_relations_feature_type(feature_type)

        feature_type = tools_qt.get_text(self.dlg_add_visit, self.cmb_feature_type).lower()
        # Save new relations listed in every table of feature_type
        if feature_type == 'all':
            self._update_relations_feature_type("arc")
            self._update_relations_feature_type("node")
            self._update_relations_feature_type("connec")
            if tools_gw.get_project_type() == 'ud':
                self._update_relations_feature_type("gully")
        else:
            self._update_relations_feature_type(self.feature_type)

        widget_name = f"tbl_visit_x_{self.feature_type}"
        tools_gw.enable_feature_type(dialog, widget_name, ids=self.ids)


    def _delete_relations_feature_type(self, feature_type):
        """ Remove all old relations related with current visit_id and @feature_type """

        if feature_type == '' or feature_type.lower() == 'all':
            return

        db_record = None
        if feature_type == 'arc':
            db_record = GwOmVisitXArc()
        elif feature_type == 'node':
            db_record = GwOmVisitXNode()
        elif feature_type == 'connec':
            db_record = GwOmVisitXConnec()
        elif feature_type == 'gully':
            db_record = GwOmVisitXGully()

        # remove all actual saved records related with visit_id
        where_clause = f"visit_id = '{self.visit_id.text()}'"

        if db_record:
            db_record.delete(where_clause=where_clause)


    def _update_relations_feature_type(self, feature_type):
        """ Update relations of specific @feature_type """

        if feature_type == '' or feature_type.lower() == 'all':
            return

        # for each showed element of a specific feature_type create an db entry
        column_name = f"{feature_type}_id"
        widget = tools_qt.get_widget(self.dlg_add_visit, f"tbl_visit_x_{feature_type}")
        if not widget:
            message = "Widget not found"
            tools_log.log_info(message, parameter=f"tbl_visit_x_{feature_type}")
            return None

        # do nothing if model is None or no element is present
        if not widget.model():  # or not widget.rowCount():
            tools_log.log_info(f"Widget model is none: tbl_visit_x_{feature_type}")
            return

        db_record = None
        if feature_type == 'arc':
            db_record = GwOmVisitXArc()
        elif feature_type == 'node':
            db_record = GwOmVisitXNode()
        elif feature_type == 'connec':
            db_record = GwOmVisitXConnec()
        elif feature_type == 'gully':
            db_record = GwOmVisitXGully()

        if db_record:
            for row in range(widget.model().rowCount()):
                # get modelIndex to get data
                index = widget.model().index(row, 0)

                # set common fields
                db_record.id = db_record.max_pk() + 1
                db_record.visit_id = int(self.visit_id.text())

                # set value for column <feature_type>_id
                # db_record.column_name = index.data()
                setattr(db_record, column_name, index.data())

                # than save the showed records
                db_record.upsert()


    def _manage_tab_changed(self, dialog, index):
        """ Do actions when tab is exit and entered. Actions depend on tab index """

        # manage leaving tab
        # tab Visit
        if self.current_tab_index == self._tab_index('tab_visit'):
            self._manage_leave_visit_tab()
            # need to create the relation record that is done only
            # changing tab
            if self.locked_feature_type:
                self._update_relations(dialog)

        # manage arriving tab
        self.current_tab_index = index

        # Set user devault parameter
        parameter_id = tools_gw.get_config_value('om_visit_parameter_vdefault')
        if parameter_id:
            tools_qt.set_combo_value(self.dlg_add_visit.parameter_id, parameter_id[0], 0)


    def _set_parameter_id_combo(self, dialog):
        """ Set parameter_id combo basing on current selections """

        dialog.parameter_id.clear()
        sql = (f"SELECT id, descript "
               f"FROM config_visit_parameter "
               f"WHERE UPPER(parameter_type) = '{self.parameter_type_id.currentText().upper()}' ")
        if self.cmb_feature_type.currentText() != '':
            sql += f"AND UPPER(feature_type) = '{self.cmb_feature_type.currentText().upper()}' "
        sql += f"ORDER BY id"
        rows = tools_db.get_rows(sql)
        if rows:
            tools_qt.fill_combo_values(dialog.parameter_id, rows, 1)

        # Set user devault parameter
        parameter_id = tools_gw.get_config_value('om_visit_parameter_vdefault')
        if parameter_id:
            tools_qt.set_combo_value(self.dlg_add_visit.parameter_id, parameter_id[0], 0)


    def _get_feature_type_of_parameter(self):
        """ Get feature type of selected parameter """

        sql = (f"SELECT feature_type "
               f"FROM config_visit_parameter "
               f"WHERE descript = '{self.parameter_id.currentText()}'")
        row = tools_db.get_row(sql)
        if row:
            self.feature_type_parameter = row[0]
            if self.it_is_new_visit:
                self.feature_type = self.feature_type_parameter.lower()
            self._manage_tabs_enabled(True)


    def _connect_signal_tab_feature_signal(self, connect=True, excluded_layers=[]):

        try:
            if connect:
                self.dlg_add_visit.tab_feature.currentChanged.connect(partial(
                    self._visit_tab_feature_changed, self.dlg_add_visit, 'visit', excluded_layers))
            else:
                self.dlg_add_visit.tab_feature.currentChanged.disconnect()
        except Exception as e:
            tools_log.log_info(f"connect_signal_tab_feature_signal error: {e}")


    def _manage_tabs_enabled(self, enable_tabs=False):
        """ Enable/Disable tabs depending feature_type """

        excluded_layers = ["v_edit_arc", "v_edit_node", "v_edit_connec", "v_edit_element", "v_edit_gully",
                          "v_edit_element"]
        self.excluded_layers = excluded_layers
        if self.feature_type is None:
            return

        self._connect_signal_tab_feature_signal(False, excluded_layers)

        # If feature_type = 'all': enable all tabs
        if self.feature_type == 'all':
            for i in range(self.dlg_add_visit.tab_feature.count()):
                self.dlg_add_visit.tab_feature.setTabEnabled(i, True)
            self._connect_signal_tab_feature_signal(True, excluded_layers)
            return

        # Disable all tabs
        if enable_tabs:
            for i in range(self.dlg_add_visit.tab_feature.count()):
                self.dlg_add_visit.tab_feature.setTabEnabled(i, False)

        self._manage_feature_type_selected()


    def _manage_feature_type_selected(self):

        tab_index = 0
        if self.feature_type == 'arc':
            tab_index = 0
        elif self.feature_type == 'node':
            tab_index = 1
        elif self.feature_type == 'connec':
            tab_index = 2
        elif self.feature_type == 'gully':
            tab_index = 3

        # Enable only tab of this geometry type
        self.dlg_add_visit.tab_feature.setTabEnabled(tab_index, True)
        self.dlg_add_visit.tab_feature.setCurrentIndex(tab_index)

        self._connect_signal_tab_feature_signal(True)

        # tools_gw.hide_parent_layers(excluded_layers=excluded_layers)
        widget_name = f"tbl_visit_x_{self.feature_type}"
        viewname = f"v_edit_{self.feature_type}"
        widget_table = tools_qt.get_widget(self.dlg_add_visit, widget_name)

        try:
            self.dlg_add_visit.btn_feature_insert.clicked.disconnect()
            self.dlg_add_visit.btn_feature_delete.clicked.disconnect()
            self.dlg_add_visit.btn_feature_snapping.clicked.disconnect()
        except Exception as e:
            tools_log.log_info(f"manage_feature_type_selected exception: {e}")
        finally:
            self.dlg_add_visit.btn_feature_insert.clicked.connect(partial(tools_gw.insert_feature, self,
                 self.dlg_add_visit, widget_table, False, False, None, None))
            self.dlg_add_visit.btn_feature_delete.clicked.connect(partial(tools_gw.delete_records, self,
                 self.dlg_add_visit, widget_table, False, self.lazy_widget, self.lazy_init_function))
            self.dlg_add_visit.btn_feature_snapping.clicked.connect(
                partial(self._feature_snapping_clicked, self.dlg_add_visit, 'visit'))

        # Adding auto-completion to a QLineEdit
        tools_gw.set_completer_widget(viewname, self.dlg_add_visit.feature_id, str(self.feature_type) + "_id")


    def _config_relation_table(self, dialog):
        """ Set all actions related to the table, model and selectionModel.
        It's necessary a centralised call because base class can create a None model
        where all callbacks are lost ance can't be registered. """

        if self.feature_type == '':
            return

        # configure model visibility
        tools_gw.set_tablemodel_config(dialog, "tbl_visit_x_arc", "v_edit_arc")
        tools_gw.set_tablemodel_config(dialog, "tbl_visit_x_node", "v_edit_node")
        tools_gw.set_tablemodel_config(dialog, "tbl_visit_x_connec", "v_edit_connec")
        tools_gw.set_tablemodel_config(dialog, "tbl_visit_x_gully", "v_edit_gully")


    def _event_feature_type_selected(self, dialog, feature_type=None):
        """ Manage selection change in feature_type combo box.
        THis means that have to set completer for feature_id QTextLine and
        setup model for features to select table """
        # 1) set the model linked to selecte features
        # 2) check if there are features related to the current visit
        # 3) if so, select them => would appear in the table associated to the model
        if feature_type is None:
            feature_type = self.cmb_feature_type.currentText().lower()

        self.feature_type = feature_type
        if feature_type == '':
            return

        # Fill combo parameter_id depending feature_type
        self._fill_combo_parameter_id()

        if self.event_parameter_id:
            tools_qt.set_combo_value(self.dlg_add_visit.parameter_id, self.event_parameter_id, 0)

        if feature_type.lower() == 'all':
            return

        viewname = f"v_edit_{feature_type}"
        tools_gw.set_completer_widget(viewname, dialog.feature_id, str(feature_type) + "_id")

        # set table model and completer
        widget_name = f'tbl_visit_x_{feature_type}'
        self._get_features_visit_feature_type(self.current_visit.id, feature_type)

        # set the callback to setup all events later
        # its not possible to setup listener in this moment beacouse set_table_model without
        # a valid expression parameter return a None model => no events can be triggered
        widget_table = tools_qt.get_widget(dialog, widget_name)
        self.lazy_widget, self.lazy_init_function = self._lazy_configuration(widget_table, self._config_relation_table)

        # check if there are features related to the current visit
        if not self.visit_id.text():
            return

        self._get_features_visit_feature_type(self.visit_id.text(), feature_type, widget_table)


    def _lazy_configuration(self, widget, init_function):
        """ set the init_function where all necessary events are set.
        This is necessary to allow a lazy setup of the events because set_table_events
        can create a table with a None model loosing any event connection. """

        lazy_widget = widget
        lazy_init_function = init_function

        return lazy_widget, lazy_init_function


    def _get_features_visit_feature_type(self, visit_id, feature_type, widget_table=None):
        """ Get features from table om_visit_x@feature_type of selected @visit_id
        Select them in canvas and automatically load them into @widget_table """

        table_name = f'om_visit_x_{feature_type}'
        sql = f"SELECT {feature_type}_id FROM {table_name} WHERE visit_id = '{visit_id}'"
        rows = tools_db.get_rows(sql, log_info=False)
        if not rows or not rows[0]:
            return

        ids = [f"'{x[0]}'" for x in rows]

        # Select list of related features
        # Set 'expr_filter' with features that are in the list
        expr_filter = f"{feature_type}_id IN ({','.join(ids)})"
        (is_valid, expr) = tools_qt.check_expression_filter(expr_filter)  # @UnusedVariable
        if not is_valid:
            return

        if widget_table is None:
            widget_name = f'tbl_visit_x_{feature_type}'
            widget_table = tools_qt.get_widget(self.dlg_add_visit, widget_name)

        # Do selection allowing @widget_table to be linked to canvas selectionChanged
        tools_qgis.disconnect_signal_selection_changed()
        tools_gw.disconnect_signal('visit')
        tools_gw.connect_signal(global_vars.canvas.selectionChanged,
                                partial(tools_gw.selection_changed, self, self.dlg_add_visit, widget_table, False),
                                'visit', 'get_features_visit_feature_type_canvas_selectionChanged')
        tools_qgis.select_features_by_ids(feature_type, expr, self.layers)
        tools_qgis.disconnect_signal_selection_changed()
        tools_gw.disconnect_signal('visit')


    def _filter_visit(self, dialog, widget_table, widget_txt, table_object, expr_filter, filed_to_filter):
        """ Filter om_visit in self.dlg_visit_manager.tbl_visit based on (id AND text AND between dates) """

        object_id = tools_qt.get_text(dialog, widget_txt)
        visit_start = dialog.date_event_from.date()
        visit_end = dialog.date_event_to.date()
        if visit_start > visit_end:
            message = "Selected date interval is not valid"
            tools_qgis.show_warning(message, dialog=dialog)
            return

        # Create interval dates
        format_low = 'yyyy-MM-dd 00:00:00.000'
        format_high = 'yyyy-MM-dd 23:59:59.999'
        interval = f"'{visit_start.toString(format_low)}'::timestamp AND '{visit_end.toString(format_high)}'::timestamp"

        if table_object == "v_ui_om_visit":
            expr_filter += f"(startdate BETWEEN {interval}) AND (enddate BETWEEN {interval})"
            if object_id != 'null':
                expr_filter += f" AND {filed_to_filter}::TEXT ILIKE '%{object_id}%'"
        else:
            expr_filter += f"AND (visit_start BETWEEN {interval}) AND (visit_end BETWEEN {interval})"
            if object_id != 'null':
                expr_filter += f" AND {filed_to_filter}::TEXT ILIKE '%{object_id}%'"

        # Refresh model with selected filter
        widget_table.model().setFilter(expr_filter)
        widget_table.model().select()


    def _fill_combos(self, visit_id=None):
        """ Fill combo boxes of the form """

        # Visit tab
        # Fill ComboBox visitcat_id
        # save result in self.visitcat_ids to get id depending on selected combo
        sql = ("SELECT id, name"
               " FROM om_visit_cat"
               " WHERE active is true"
               " ORDER BY name")
        self.visitcat_ids = tools_db.get_rows(sql)

        if self.visitcat_ids:
            tools_qt.fill_combo_values(self.dlg_add_visit.visitcat_id, self.visitcat_ids, 1)
            # now get default value to be show in visitcat_id
            row = tools_gw.get_config_value('om_visit_cat_vdefault')
            if row:
                # if int then look for default row ans set it
                try:
                    tools_qt.set_combo_value(self.dlg_add_visit.visitcat_id, row[0], 0)
                    for i in range(0, self.dlg_add_visit.visitcat_id.count()):
                        elem = self.dlg_add_visit.visitcat_id.itemData(i)
                        if str(row[0]) == str(elem[0]):
                            tools_qt.set_widget_text(self.dlg_add_visit.visitcat_id, (elem[1]))
                except TypeError:
                    pass
                except ValueError:
                    pass
            elif visit_id is not None:
                sql = (f"SELECT visitcat_id"
                       f" FROM om_visit"
                       f" WHERE id = '{visit_id}' ")
                id_visitcat = tools_db.get_row(sql)
                sql = (f"SELECT id, name"
                       f" FROM om_visit_cat"
                       f" WHERE active is true AND id = '{id_visitcat[0]}' "
                       f" ORDER BY name")
                row = tools_db.get_row(sql)
                tools_qt.set_combo_value(self.dlg_add_visit.visitcat_id, str(row[1]), 1)

        # Fill ComboBox status
        rows = self._get_values_from_catalog('om_typevalue', 'visit_status')
        if rows:
            tools_qt.fill_combo_values(self.dlg_add_visit.status, rows, 1, sort_combo=True)
            status = tools_gw.get_config_value('om_visit_status_vdefault')
            if status:
                tools_qt.set_combo_value(self.dlg_add_visit.status, str(status[0]), 0)

            if visit_id is not None:
                sql = (f"SELECT status "
                       f"FROM om_visit "
                       f"WHERE id = '{visit_id}'")
                status = tools_db.get_row(sql)
                tools_qt.set_combo_value(self.dlg_add_visit.status, str(status[0]), 0)

        # Fill ComboBox exploitation
        sql = "SELECT exploitation.expl_id, name FROM selector_expl JOIN exploitation USING (expl_id) " \
              "WHERE cur_user=current_user"
        rows = tools_db.get_rows(sql)
        if rows:
            tools_qt.fill_combo_values(self.exploitation, rows, 1, sort_by=0)
            if visit_id is None:
                if self.expl_id is not None:
                    tools_qt.set_combo_value(self.exploitation, self.expl_id, 0, add_new=False)
                else:
                    default_expl = tools_gw.get_config_parser('btn_add_visit', 'expl_id', "user", "session")
                    if default_expl not in (None, 'None', ''):
                        tools_qt.set_combo_value(self.exploitation, default_expl, 0, add_new=False)
            else:
                sql = (f"SELECT expl_id "
                       f"FROM om_visit "
                       f"WHERE id = '{visit_id}'")
                row = tools_db.get_row(sql)
                tools_qt.set_combo_value(self.exploitation, str(row[0]), 0)

        # Relations tab
        # fill feature_type
        sql = ("SELECT 'ALL' as id "
               "UNION SELECT id "
               "FROM sys_feature_type "
               "WHERE classlevel = 1 OR classlevel = 2"
               "ORDER BY id")
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_add_visit.feature_type, rows)

        # Event tab
        # Fill ComboBox parameter_type_id
        sql = "SELECT id, idval FROM om_typevalue WHERE typevalue = 'visit_param_type' ORDER by idval"
        parameter_type_ids = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_add_visit.parameter_type_id, parameter_type_ids, 1)

        # now get default value to be show in parameter_type_id
        row = tools_gw.get_config_value('om_param_type_vdefault', log_info=False)
        if row:
            tools_qt.set_combo_value(self.dlg_add_visit.parameter_type_id, row[0], 0)


    def _fill_combo_parameter_id(self):
        """ Fill combo parameter_id depending feature_type """

        sql = (f"SELECT id, descript "
               f"FROM config_visit_parameter ")
        where = None
        parameter_type_id = tools_qt.get_text(self.dlg_add_visit, "parameter_type_id")
        if parameter_type_id:
            where = f"WHERE parameter_type = '{parameter_type_id}' "
        if self.feature_type:
            if where is None:
                where = f"WHERE UPPER(feature_type) IN ('{self.feature_type.upper()}', 'ALL') "
            else:
                where += f"AND UPPER(feature_type) IN ('{self.feature_type.upper()}', 'ALL') "

        sql += where
        sql += f"ORDER BY id"
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_add_visit.parameter_id, rows, 1)


    def _set_completers(self):
        """ Set autocompleters of the form """

        # Adding auto-completion to a QLineEdit - visit_id
        self.completer = QCompleter()
        self.dlg_add_visit.visit_id.setCompleter(self.completer)
        model = QStringListModel()

        sql = "SELECT DISTINCT(id) FROM om_visit"
        rows = tools_db.get_rows(sql)
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
        rows = tools_db.get_rows(sql)
        values = []
        if rows:
            for row in rows:
                values.append(str(row[0]))

        model.setStringList(values)
        self.completer.setModel(model)


    def _manage_document(self):
        """ Access GUI to manage documents e.g Execute action of button 34 """

        visit_id = tools_qt.get_text(self.dlg_add_visit, self.dlg_add_visit.visit_id)
        manage_document = GwDocument(single_tool=False)
        dlg_docman = manage_document.get_document(
            tablename='visit', qtable=self.dlg_add_visit.tbl_document, item_id=visit_id)
        tools_qt.remove_tab(dlg_docman.tabWidget, 'tab_rel')
        dlg_docman.btn_accept.clicked.connect(partial(tools_gw.set_completer_object, dlg_docman, 'doc'))


    def _event_insert(self):
        """ Add and event basing on form associated to the selected parameter_id. """

        # Parameter to save all selected files associated to events
        self.files_added = []
        self.files_all = []

        # check a parameter_id is selected (can be that no value is available)
        parameter_id = tools_qt.get_combo_value(self.dlg_add_visit, self.dlg_add_visit.parameter_id, 0)
        parameter_text = tools_qt.get_combo_value(self.dlg_add_visit, self.dlg_add_visit.parameter_id, 1)

        if not parameter_id or parameter_id == -1:
            message = "You need to select a valid parameter id"
            tools_qt.show_info_box(message)
            return

        # get form associated
        sql = (f"SELECT form_type"
               f" FROM config_visit_parameter"
               f" WHERE id = '{parameter_id}'")
        row = tools_db.get_row(sql)
        form_type = str(row[0])
        if form_type in ('event_ud_arc_standard', 'event_standard'):
            self.dlg_event = GwVisitEventUi()
            tools_gw.load_settings(self.dlg_event)
            self._populate_position_id()
            dlg_name = 'visit_event'
        elif form_type == 'event_ud_arc_rehabit':
            self.dlg_event = GwVisitEventRehabUi()
            tools_gw.load_settings(self.dlg_event)
            self._populate_position_id()
            dlg_name = 'visit_event_rehab'
            self.dlg_event.position_id.setEnabled(True)
            self.dlg_event.position_value.setEnabled(True)
        else:
            message = "Unrecognised form type"
            tools_qt.show_info_box(message, parameter=form_type)
            return

        # form_type event_ud_arc_rehabit dont have widget value
        if form_type != 'event_ud_arc_rehabit':
            val = tools_gw.get_config_value('om_visit_paramvalue_vdefault')
            if val:
                tools_qt.set_widget_text(self.dlg_event, self.dlg_event.value, val[0])

        # Manage QTableView docx_x_event
        tools_qt.set_tableview_config(self.dlg_event.tbl_docs_x_event)
        self.dlg_event.tbl_docs_x_event.doubleClicked.connect(self._open_file)
        self._populate_tbl_docs_x_event()

        # set fixed values
        self.dlg_event.parameter_id.setText(parameter_text)

        # create an empty Event
        event = GwOmVisitEvent()
        event.id = event.max_pk() + 1
        event.parameter_id = parameter_id
        event.visit_id = int(self.visit_id.text())

        self.dlg_event.btn_add_file.clicked.connect(partial(self._get_added_files, event.visit_id, event.id, save=False))
        self.dlg_event.btn_delete_file.clicked.connect(
            partial(self._delete_files, self.dlg_event.tbl_docs_x_event, event.visit_id, event.id))

        self.dlg_event.setWindowFlags(Qt.WindowStaysOnTopHint)
        tools_qt.manage_translation(dlg_name, self.dlg_event)
        ret = self.dlg_event.exec_()

        # check return
        if not ret:
            # clicked cancel
            return

        for field_name in event.field_names():
            value = None
            if not hasattr(self.dlg_event, field_name):
                continue
            if type(getattr(self.dlg_event, field_name)) is QLineEdit:
                if field_name == 'parameter_id':
                    value = parameter_id
                else:
                    value = getattr(self.dlg_event, field_name).text()
            if type(getattr(self.dlg_event, field_name)) is QTextEdit:
                value = getattr(self.dlg_event, field_name).toPlainText()
            if type(getattr(self.dlg_event, field_name)) is QComboBox:
                value = tools_qt.get_combo_value(self.dlg_event, getattr(self.dlg_event, field_name), index=0)

            if value:
                setattr(event, field_name, value)

        # save new event
        event.upsert()
        self._save_files_added(event.visit_id, event.id)

        # update Table
        self.tbl_event.model().select()
        self._manage_events_changed()


    def _open_file(self):

        # Get row index
        index = self.dlg_event.tbl_docs_x_event.selectionModel().selectedRows()[0]
        column_index = tools_qt.get_col_index_by_col_name(self.dlg_event.tbl_docs_x_event, 'value')
        path = index.sibling(index.row(), column_index).data()
        status, message = tools_os.open_file(path)
        if status is False and message is not None:
            tools_qgis.show_warning(message, parameter=path, dialog=self.dlg_event)


    def _populate_tbl_docs_x_event(self, event_id=0):

        # Create and set model
        model = QStandardItemModel()
        self.dlg_event.tbl_docs_x_event.setModel(model)
        self.dlg_event.tbl_docs_x_event.horizontalHeader().setStretchLastSection(True)
        self.dlg_event.tbl_docs_x_event.horizontalHeader().setSectionResizeMode(3)

        # Get columns name and set headers of model with that
        columns_name = tools_db.get_columns_list('om_visit_event_photo')
        headers = []
        for x in columns_name:
            headers.append(x[0])
        headers = ['value', 'filetype', 'fextension']
        model.setHorizontalHeaderLabels(headers)

        # Get values in order to populate model
        visit_id = tools_qt.get_text(self.dlg_add_visit, self.dlg_add_visit.visit_id)
        sql = (f"SELECT value, filetype, fextension FROM om_visit_event_photo "
               f"WHERE visit_id='{visit_id}' AND event_id='{event_id}'")
        rows = tools_db.get_rows(sql)
        if rows is None:
            return

        for row in rows:
            item = []
            if row[0] not in self.files_all:
                self.files_all.append(str(row[0]))
            for _file in row:
                if _file is not None:
                    if type(_file) != str:
                        item.append(QStandardItem(str(_file)))
                    else:
                        item.append(QStandardItem(_file))
                else:
                    item.append(QStandardItem(None))

            if len(row) > 0:
                model.appendRow(item)


    def _get_added_files(self, visit_id, event_id, save):
        """ Get path of new files """

        file_dialog = QFileDialog()
        file_dialog.setFileMode(QFileDialog.Directory)
        # Get file types from catalog and populate QFileDialog filter
        sql = "SELECT filetype, fextension FROM config_file"
        rows = tools_db.get_rows(sql)
        f_types = rows
        file_types = ""
        for row in rows:
            file_types += f"{row[0]} (*.{row[1]});;"
        file_types += "All (*.*)"
        new_files, filter_ = QFileDialog.getOpenFileNames(None, "Save file path", "", file_types)

        # Add files to QtableView
        if new_files:
            for path in new_files:
                item = []
                if path not in self.files_all and path not in self.files_added:
                    self.files_all.append(path)
                    self.files_added.append(path)
                    filename, file_extension = os.path.splitext(path)
                    file_extension = file_extension.replace('.', '')

                    # Set default file_type = extension, but look for matches with the catalog
                    file_type = file_extension
                    for _types in f_types:
                        if _types[1] == file_extension:
                            file_type = _types[0]
                            break

                    item.append(path)
                    item.append(file_type)
                    item.append(file_extension)
                    row = []
                    for value in item:
                        row.append(QStandardItem(str(value)))
                    if len(row) > 0:
                        self.dlg_event.tbl_docs_x_event.model().appendRow(row)
            if save:
                self._save_files_added(visit_id, event_id)


    def _save_files_added(self, visit_id, event_id):
        """ Save new files into DataBase """

        if self.files_added:
            sql = "SELECT filetype, fextension FROM config_file"
            f_types = tools_db.get_rows(sql)
            sql = ""
            for path in self.files_added:
                filename, file_extension = os.path.splitext(path)
                # Set default file_type = extension, but look for matches with the catalog
                file_extension = file_extension.replace('.', '')
                file_type = file_extension
                for _types in f_types:
                    if _types[1] == file_extension:
                        file_type = _types[0]
                        break

                sql += (f"INSERT INTO om_visit_event_photo "
                        f"(visit_id, event_id, value, filetype, fextension) "
                        f" VALUES('{visit_id}', '{event_id}', '{path}', "
                        f"'{file_type}', ' {file_extension}'); \n")
            tools_db.execute_sql(sql)


    def _manage_events_changed(self):
        """ Action when at a Event model is changed.
        A) if some record is available => enable OK button of VisitDialog """

        state = (self.tbl_event.model().rowCount() > 0)
        self.button_box.button(QDialogButtonBox.Ok).setEnabled(state)


    def _event_update(self):
        """ Update selected event. """

        # Parameter to save all selected files associated to events
        self.files_added = []
        self.files_all = []
        if not self.tbl_event.selectionModel().hasSelection():
            message = "Any record selected"
            tools_qt.show_info_box(message)
            return

        # Get selected rows
        # TODO: use tbl_event.model().fieldIndex(event.pk()) to be pk name independent
        # 0 is the column of the pk 0 'id'
        selected_list = self.tbl_event.selectionModel().selectedRows(0)
        if selected_list == 0:
            message = "Any record selected"
            tools_qt.show_info_box(message)
            return

        elif len(selected_list) > 1:
            message = "More then one event selected. Select just one"
            tools_qgis.show_warning(message, dialog=self.dlg_add_visit)
            return

        # fetch the record
        event = GwOmVisitEvent()
        event.id = selected_list[0].data()

        if not event.fetch():
            return

        # get parameter_id code to select the widget useful to edit the event
        om_event_parameter = GwConfigVisitParameter()
        om_event_parameter.id = event.parameter_id
        parameter_id = event.parameter_id

        if not om_event_parameter.fetch():
            return

        dlg_name = None
        row = selected_list[0].row()
        if om_event_parameter.form_type in ('event_ud_arc_standard', 'event_standard'):

            event_code = self.dlg_add_visit.tbl_event.model().record(row).value('event_code')
            _value = self.dlg_add_visit.tbl_event.model().record(row).value('value')
            position_value = self.dlg_add_visit.tbl_event.model().record(row).value('position_value')
            text = self.dlg_add_visit.tbl_event.model().record(row).value('text')
            self.dlg_event = GwVisitEventUi()
            tools_gw.load_settings(self.dlg_event)
            self._populate_position_id()
            dlg_name = 'visit_event'
            # set fixed values
            if event_code not in ('NULL', None):
                tools_qt.set_widget_text(self.dlg_event, self.dlg_event.event_code, event_code)
            if _value not in ('NULL', None):
                tools_qt.set_widget_text(self.dlg_event, self.dlg_event.value, _value)
            if position_value not in ('NULL', None):
                tools_qt.set_widget_text(self.dlg_event, self.dlg_event.position_value, position_value)
            if text not in ('NULL', None):
                tools_qt.set_widget_text(self.dlg_event, self.dlg_event.text, text)
            self.dlg_event.position_id.setEnabled(False)
            self.dlg_event.position_value.setEnabled(False)

        elif om_event_parameter.form_type == 'event_ud_arc_rehabit':

            position_value = self.dlg_add_visit.tbl_event.model().record(row).value('position_value')
            value1 = self.dlg_add_visit.tbl_event.model().record(row).value('value1')
            value2 = self.dlg_add_visit.tbl_event.model().record(row).value('value2')
            geom1 = self.dlg_add_visit.tbl_event.model().record(row).value('geom1')
            geom2 = self.dlg_add_visit.tbl_event.model().record(row).value('geom2')
            geom3 = self.dlg_add_visit.tbl_event.model().record(row).value('geom3')
            text = self.dlg_add_visit.tbl_event.model().record(row).value('text')
            self.dlg_event = GwVisitEventRehabUi()
            tools_gw.load_settings(self.dlg_event)
            self._populate_position_id()
            dlg_name = 'visit_event_rehab'
            self.dlg_event.position_value.setText(str(position_value))
            self.dlg_event.value1.setText(str(value1))
            self.dlg_event.value2.setText(str(value2))
            self.dlg_event.geom1.setText(str(geom1))
            self.dlg_event.geom2.setText(str(geom2))
            self.dlg_event.geom3.setText(str(geom3))
            tools_qt.set_widget_text(self.dlg_event, self.dlg_event.text, text)
            # disable position_x fields because not allowed in multiple view
            self.dlg_event.position_id.setEnabled(True)
            self.dlg_event.position_value.setEnabled(True)

        elif om_event_parameter.form_type == 'event_standard':

            index = selected_list[0]
            row = index.row()
            column_index = tools_qt.get_col_index_by_col_name(self.dlg_add_visit.tbl_event, 'parameter_id')
            parameter_id = index.sibling(row, column_index).data()
            column_index = tools_qt.get_col_index_by_col_name(self.dlg_add_visit.tbl_event, 'event_code')
            event_code = index.sibling(row, column_index).data()
            column_index = tools_qt.get_col_index_by_col_name(self.dlg_add_visit.tbl_event, 'value')
            _value = index.sibling(row, column_index).data()
            column_index = tools_qt.get_col_index_by_col_name(self.dlg_add_visit.tbl_event, 'text')
            text = index.sibling(row, column_index).data()

            self.dlg_event = GwVisitEventUi()
            tools_gw.load_settings(self.dlg_event)
            if event_code not in ('NULL', None):
                tools_qt.set_widget_text(self.dlg_event, self.dlg_event.event_code, event_code)
            if _value not in ('NULL', None):
                tools_qt.set_widget_text(self.dlg_event, self.dlg_event.value, _value)
            if text not in ('NULL', None):
                tools_qt.set_widget_text(self.dlg_event, self.dlg_event.text, text)

        # Manage QTableView docx_x_event
        tools_qt.set_tableview_config(self.dlg_event.tbl_docs_x_event)
        self.dlg_event.tbl_docs_x_event.doubleClicked.connect(self._open_file)
        self.dlg_event.btn_add_file.clicked.connect(partial(self._get_added_files, event.visit_id, event.id, save=True))
        self.dlg_event.btn_delete_file.clicked.connect(
            partial(self._delete_files, self.dlg_event.tbl_docs_x_event, event.visit_id, event.id))
        self._populate_tbl_docs_x_event(event.id)

        # fill widget values if the values are present
        for field_name in event.field_names():
            if not hasattr(self.dlg_event, field_name):
                continue
            value = None
            if type(getattr(self.dlg_event, field_name)) is QLineEdit:
                value = getattr(self.dlg_event, field_name).text()
            elif type(getattr(self.dlg_event, field_name)) is QTextEdit:
                value = getattr(self.dlg_event, field_name).toPlainText()
            if type(getattr(self.dlg_event, field_name)) is QComboBox:
                value = tools_qt.get_combo_value(self.dlg_event, getattr(self.dlg_event, field_name), index=0)
            setattr(event, field_name, value)

        # set fixed values
        self.dlg_event.parameter_id.setText(parameter_id)

        self.dlg_event.setWindowFlags(Qt.WindowStaysOnTopHint)
        tools_qt.manage_translation(dlg_name, self.dlg_event)
        if self.dlg_event.exec_():

            # set record values basing on widget
            for field_name in event.field_names():
                if not hasattr(self.dlg_event, field_name):
                    continue
                value = None
                if type(getattr(self.dlg_event, field_name)) is QLineEdit:
                    value = getattr(self.dlg_event, field_name).text()
                elif type(getattr(self.dlg_event, field_name)) is QTextEdit:
                    value = getattr(self.dlg_event, field_name).toPlainText()
                elif type(getattr(self.dlg_event, field_name)) is QComboBox:
                    value = tools_qt.get_combo_value(self.dlg_event, getattr(self.dlg_event, field_name), index=0)
                setattr(event, field_name, value)

            # update the record
            event.upsert()

        self._save_files_added(event.visit_id, event.id)

        # update Table
        self.tbl_event.model().select()
        self.tbl_event.setModel(self.tbl_event.model())
        self._manage_events_changed()


    def _event_delete(self):
        """ Delete a selected event. """

        if not self.tbl_event.selectionModel().hasSelection():
            message = "Any record selected"
            tools_qt.show_info_box(message)
            return

        # a fake event to get some ancyllary data
        event = GwOmVisitEvent()

        # Get selected rows
        # TODO: use tbl_event.model().fieldIndex(event.pk()) to be pk name independent
        # 0 is the column of the pk 0 'id'
        selected_list = self.tbl_event.selectionModel().selectedRows(0)
        selected_id = []
        list_id = ""
        any_docs = False
        for index in selected_list:
            selected_id.append(str(index.data()))
            list_id += "Event_id: " + str(index.data())
            sql = (f"SELECT value FROM om_visit_event_photo "
                   f"WHERE event_id='{index.data()}'")
            rows = tools_db.get_rows(sql)
            if rows:
                any_docs = True
                list_id += "(Docs associated)"
            list_id += "\n"

        # ask for deletion
        message = "Are you sure you want to delete these records?"
        if any_docs:
            message += "\nSome events have documents"
        title = "Delete records"
        answer = tools_qt.show_question(message, title, list_id)
        if not answer:
            return

        # do the action
        if not event.delete(pks=selected_id):
            message = "Error deleting records"
            tools_qgis.show_warning(message, dialog=self.dlg_add_visit)
            return

        message = "Records deleted"
        tools_qgis.show_info(message, dialog=self.dlg_add_visit)

        # update Table
        self.tbl_event.model().select()
        self._manage_events_changed()


    def _document_insert(self):
        """ Insert a document related to the current visit. """

        doc_id = self.doc_id.text()
        visit_id = self.visit_id.text()
        if not doc_id:
            message = "You need to insert doc_id"
            tools_qgis.show_warning(message, dialog=self.dlg_add_visit)
            return
        if not visit_id:
            message = "You need to insert visit_id"
            tools_qgis.show_warning(message, dialog=self.dlg_add_visit)
            return

        # Insert into new table
        sql = (f"INSERT INTO doc_x_visit (doc_id, visit_id)"
               f" VALUES ('{doc_id}', {visit_id})")
        status = tools_db.execute_sql(sql)
        if status:
            message = "Document inserted successfully"
            tools_qgis.show_info(message, dialog=self.dlg_add_visit)

        self.dlg_add_visit.tbl_document.model().select()


    def _document_delete(self):
        """ Delete a document from the current visit. """

        # Get selected rows. 0 is the column of the pk 0 'id'
        selected_list = self.tbl_document.selectionModel().selectedRows(0)
        if len(selected_list) == 0:
            message = "Any record selected"
            tools_qt.show_info_box(message)
            return

        selected_id = []
        for index in selected_list:
            doc_id = index.data()
            selected_id.append(str(doc_id))
        message = "Are you sure you want to delete these records?"
        title = "Delete records"
        answer = tools_qt.show_question(message, title, ','.join(selected_id))
        if answer:
            # Delete from table
            sql = (f"DELETE FROM doc_x_visit"
                   f" WHERE id IN ({','.join(selected_id)})")
            status = tools_db.execute_sql(sql)
            if status:
                message = "Documents deleted successfully"
                tools_qgis.show_info(message, dialog=self.dlg_add_visit)

            self.tbl_document.model().select()


    def _populate_position_id(self):

        self.dlg_event.position_id.setEnabled(self.feature_type == 'arc')
        self.dlg_event.position_value.setEnabled(self.feature_type == 'arc')
        node_list = []
        node_1 = None
        node_2 = None
        if self.feature_type != 'all':
            widget_name = f"tbl_visit_x_{self.feature_type}"
            widget_table = tools_qt.get_widget(self.dlg_add_visit, widget_name)
            if widget_table.model():
                node_1 = widget_table.model().record(0).value('node_1')
                node_2 = widget_table.model().record(0).value('node_2')

        node_list.append([node_1, f"node 1: {node_1}"])
        node_list.append([node_2, f"node 2: {node_2}"])
        tools_qt.fill_combo_values(self.dlg_event.position_id, node_list, 1, True, False)


    def _visit_tab_feature_changed(self, dialog, table_object='visit', excluded_layers=[]):
        """ Set feature_type and layer depending selected tab """

        # Get selected tab to set geometry type
        tab_idx = dialog.tab_feature.currentIndex()
        if dialog.tab_feature.widget(tab_idx).objectName() == 'tab_arc':
            self.feature_type = "arc"
        elif dialog.tab_feature.widget(tab_idx).objectName() == 'tab_node':
            self.feature_type = "node"
        elif dialog.tab_feature.widget(tab_idx).objectName() == 'tab_connec':
            self.feature_type = "connec"
        elif dialog.tab_feature.widget(tab_idx).objectName() == 'tab_gully':
            self.feature_type = "gully"
        if self.feature_type == '':
            return

        tools_gw.hide_parent_layers(excluded_layers=excluded_layers)
        widget_name = f"tbl_{table_object}_x_{self.feature_type}"
        viewname = f"v_edit_{self.feature_type}"
        widget_table = tools_qt.get_widget(dialog, widget_name)

        try:
            self.dlg_add_visit.btn_feature_insert.clicked.disconnect()
            self.dlg_add_visit.btn_feature_delete.clicked.disconnect()
            self.dlg_add_visit.btn_feature_snapping.clicked.disconnect()
        except Exception as e:
            tools_log.log_info(f"visit_tab_feature_changed exception: {e}")
        finally:

            self.dlg_add_visit.btn_feature_insert.clicked.connect(
                partial(tools_gw.insert_feature, self, self.dlg_add_visit, widget_table, False, False))

            self.dlg_add_visit.btn_feature_delete.clicked.connect(partial(tools_gw.delete_records, self,
                 self.dlg_add_visit, widget_table, False, self.lazy_widget, self.lazy_init_function))

            self.dlg_add_visit.btn_feature_snapping.clicked.connect(
                partial(self._feature_snapping_clicked, self.dlg_add_visit, 'visit'))

        # Adding auto-completion to a QLineEdit
        tools_gw.set_completer_widget(viewname, dialog.feature_id, str(self.feature_type) + "_id")
        tools_gw.selection_changed(self, dialog, widget_table, False, self.lazy_widget, self.lazy_init_function)

        try:
            self.iface.actionPan().trigger()
        except Exception:
            pass


    def _feature_snapping_clicked(self, dialog, table_object):

        self.previous_map_tool = global_vars.canvas.mapTool()
        tools_gw.selection_init(self, dialog, table_object, False)


    def _get_data_from_event(self, visit_id):
        """ Get parameter_id and feature_type from event of @visit_id """

        parameter_id = None
        feature_type = None
        sql = (f"SELECT visit_id, parameter_id, feature_type "
               f"FROM om_visit_event "
               f"INNER JOIN config_visit_parameter ON parameter_id = config_visit_parameter.id "
               f"WHERE visit_id = {visit_id}")
        row = tools_db.get_row(sql)
        if row:
            parameter_id = row["parameter_id"]
            feature_type = row["feature_type"].lower()

        return parameter_id, feature_type


    def _fill_widget_with_fields(self, dialog, data_object, field_names):
        """ Fill the Widget with value get from data_object limited to
        the list of field_names. """

        for field_name in field_names:
            value = getattr(data_object, field_name)
            if not hasattr(dialog, field_name):
                continue

            widget = getattr(dialog, field_name)
            if type(widget) == QDateEdit:
                widget.setDate(value if value else QDate.currentDate())
            elif type(widget) == QDateTimeEdit:
                widget.setDateTime(value if value else QDateTime.currentDateTime())

            if type(widget) in [QLineEdit, QTextEdit]:
                if value:
                    widget.setText(value)
                else:
                    widget.clear()
            if type(widget) in [QComboBox]:
                if not value:
                    widget.setCurrentIndex(0)
                    continue
                # look the value in item text
                index = widget.findText(str(value))
                if index >= 0:
                    widget.setCurrentIndex(index)
                    continue
                # look the value in itemData
                index = widget.findData(value)
                if index >= 0:
                    widget.setCurrentIndex(index)
                    continue


    def _get_values_from_catalog(self, table_name, typevalue, order_by='id'):

        sql = (f"SELECT id, idval"
               f" FROM {table_name}"
               f" WHERE typevalue = '{typevalue}'"
               f" ORDER BY {order_by}")
        rows = tools_db.get_rows(sql)
        return rows

    # endregion
