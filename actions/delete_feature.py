"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import json
from collections import OrderedDict


try:
    from qgis.core import Qgis
except ImportError:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT < 29900:
    from qgis.PyQt.QtGui import QStringListModel
else:
    from qgis.PyQt.QtCore import QStringListModel

from qgis.PyQt.QtWidgets import QRadioButton, QPushButton, QTableView, QAbstractItemView, QTextEdit, QFileDialog, \
    QLineEdit, QWidget, QComboBox, QLabel, QCheckBox, QCompleter, QScrollArea, QSpinBox, QAbstractButton, \
    QHeaderView, QListView, QFrame, QScrollBar, QDoubleSpinBox, QPlainTextEdit, QGroupBox, QTableView
from ..ui_manager import DelFeature
from functools import partial

from .. import utils_giswater
from .api_parent import ApiParent


class DeleteFeature(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control 'Workcat end' of toolbar 'edit' """
        ApiParent.__init__(self, iface, settings, controller, plugin_dir)


    def manage_delete_feature(self):

        # Create the dialog and signals
        self.dlg_delete_feature = DelFeature()
        self.load_settings(self.dlg_delete_feature)

        # Populate combo feature type
        sql = 'SELECT DISTINCT(feature_type) AS id, feature_type AS idval FROM cat_feature'
        rows = self.controller.get_rows(sql)
        utils_giswater.set_item_data(self.dlg_delete_feature.feature_type, rows, 1)

        # Disable button delete feature
        self.dlg_delete_feature.btn_delete.setEnabled(False)

        # Configure feature_id as typeahead
        completer = QCompleter()
        model = QStringListModel()
        self.filter_typeahead(self.dlg_delete_feature.feature_id, completer, model)

        # Set listeners
        self.dlg_delete_feature.feature_id.textChanged.connect(
            partial(self.filter_typeahead, self.dlg_delete_feature.feature_id, completer, model))

        # Set button snapping
        self.dlg_delete_feature.btn_snapping.clicked.connect(partial(self.set_active_layer))
        self.dlg_delete_feature.btn_snapping.clicked.connect(partial(self.selection_init, self.dlg_delete_feature))
        self.set_icon(self.dlg_delete_feature.btn_snapping, "137")

        # Set listeners
        self.dlg_delete_feature.btn_cancel.clicked.connect(partial(self.close_dialog, self.dlg_delete_feature))
        self.dlg_delete_feature.rejected.connect(self.disconnect_signal_selection_changed)
        self.dlg_delete_feature.rejected.connect(partial(self.save_settings, self.dlg_delete_feature))

        self.dlg_delete_feature.btn_relations.clicked.connect(partial(self.show_feature_relation))
        self.dlg_delete_feature.btn_delete.clicked.connect(partial(self.delete_feature_relation))
        self.dlg_delete_feature.feature_type.currentIndexChanged.connect(partial(self.set_active_layer))

        # Open dialog
        self.open_dialog(self.dlg_delete_feature)


    def filter_typeahead(self, widget, completer, model):

        # Get feature_type and feature_id
        feature_type = utils_giswater.getWidgetText(self.dlg_delete_feature, self.dlg_delete_feature.feature_type)
        feature_id = utils_giswater.getWidgetText(self.dlg_delete_feature, self.dlg_delete_feature.feature_id)

        # Get child layer
        sql = f"SELECT array_agg({feature_type}_id) FROM {feature_type} WHERE {feature_type}_id LIKE '%{feature_id}%' LIMIT 10"
        self.rows_typeahead = self.controller.get_rows(sql, log_sql=True, commit=True)
        self.rows_typeahead = self.rows_typeahead[0][0]

        if self.rows_typeahead is None:
            model.setStringList([''])
            return

        self.set_completer_object_api(completer, model, widget, self.rows_typeahead)



    def show_feature_relation(self):

        # Get feature_type and feature_id
        feature_type = utils_giswater.getWidgetText(self.dlg_delete_feature, self.dlg_delete_feature.feature_type)
        feature_id = utils_giswater.getWidgetText(self.dlg_delete_feature, self.dlg_delete_feature.feature_id)

        feature = '"type":"' + feature_type + '"'
        extras = '"feature_id":"' + feature_id + '"'
        body = self.create_body(feature=feature, extras=extras)
        sql = f"SELECT gw_fct_get_feature_relation($${{{body}}}$$)"
        row = self.controller.get_row(sql, log_sql=True, commit=True)

        if not row:
            return

        # Construct message result
        result_msg = ''
        for value in row[0]['body']['data']['info']['values']:
            result_msg += value['message'] + '\n\n'

        utils_giswater.setWidgetText(self.dlg_delete_feature, self.dlg_delete_feature.txt_infolog, result_msg)

        # Enable button delete feature
        if result_msg != '':
            self.dlg_delete_feature.btn_delete.setEnabled(True)


    def delete_feature_relation(self):

        # Get feature_type and feature_id
        feature_type = utils_giswater.getWidgetText(self.dlg_delete_feature, self.dlg_delete_feature.feature_type)
        feature_id = utils_giswater.getWidgetText(self.dlg_delete_feature, self.dlg_delete_feature.feature_id)

        feature = '"type":"' + feature_type + '"'
        extras = '"feature_id":"' + feature_id + '"'
        body = self.create_body(feature=feature, extras=extras)
        sql = f"SELECT gw_fct_set_delete_feature($${{{body}}}$$)::text"
        row = self.controller.get_row(sql, log_sql=True, commit=True)

        if not row or row[0] is None:
            self.controller.show_message("Function gw_fct_set_delete_feature executed with no result ", 3)
            return
        complet_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]

        # Populate tab info
        qtabwidget = self.dlg_delete_feature.mainTab
        qtextedit = self.dlg_delete_feature.txt_infolog_delete
        data = complet_result[0]['body']['data']
        for k, v in list(data.items()):
            if str(k) == "info":
                change_tab = self.populate_info_text(self.dlg_delete_feature, qtabwidget, qtextedit, data)
        # Close dialog
        if not change_tab:
            self.close_dialog(self.dlg_delete_feature)


    def selection_init(self, dialog):
        """ Set canvas map tool to an instance of class 'MultipleSelection' """

        self.disconnect_signal_selection_changed()
        self.iface.actionSelect().trigger()
        self.connect_signal_selection_changed(dialog)


    def connect_signal_selection_changed(self, dialog):
        """ Connect signal selectionChanged """

        try:
            self.canvas.selectionChanged.connect(partial(self.manage_selection))
        except:
            pass



    def manage_selection(self):
        """ Slot function for signal 'canvas.selectionChanged' """

        # Get feature_type and feature_id
        feature_type = utils_giswater.getWidgetText(self.dlg_delete_feature, self.dlg_delete_feature.feature_type).lower()
        layer_name = 'v_edit_' + feature_type
        layer = self.controller.get_layer_by_tablename(layer_name)
        field_id = feature_type + "_id"

        # Iterate over layer
        if layer.selectedFeatureCount() > 0:
            # Get selected features of the layer
            features = layer.selectedFeatures()
            for feature in features:
                # Append 'feature_id' into the list
                selected_id = feature.attribute(field_id)
            utils_giswater.setWidgetText(self.dlg_delete_feature, self.dlg_delete_feature.feature_id, str(selected_id))

    def set_active_layer(self):

        #Get current layer and remove selection
        self.current_layer = self.iface.activeLayer()
        self.current_layer.removeSelection()

        # Set active layer
        layer_name = 'v_edit_' + utils_giswater.getWidgetText(self.dlg_delete_feature,self.dlg_delete_feature.feature_type).lower()
        layer = self.controller.get_layer_by_tablename(layer_name)
        self.iface.setActiveLayer(layer)
        self.controller.set_layer_visible(layer)

        # Clear feature id field
        utils_giswater.setWidgetText(self.dlg_delete_feature, self.dlg_delete_feature.feature_id, '')
