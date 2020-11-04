"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import QStringListModel
from qgis.PyQt.QtWidgets import QCompleter

from functools import partial

from ....lib import tools_qt
from ..parent_dialog import GwParentAction
from ...utils.tools_gw import load_settings, open_dialog, save_settings, close_dialog, create_body, \
    populate_info_text_ as populate_info_text
from ...ui.ui_manager import FeatureDelete

from ....lib.tools_qt import set_completer_object_api, set_icon
from ....lib.tools_qgis import disconnect_signal_selection_changed


class GwDeleteFeatureButton(GwParentAction):

    def __init__(self, icon_path, action_name, text, toolbar, action_group):
        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.dlg_feature_delete = None


    def clicked_event(self):

        # Create the dialog and signals
        self.dlg_feature_delete = FeatureDelete()
        load_settings(self.dlg_feature_delete)

        # Populate combo feature type
        sql = 'SELECT DISTINCT(feature_type) AS id, feature_type AS idval FROM cat_feature'
        rows = self.controller.get_rows(sql)
        tools_qt.set_item_data(self.dlg_feature_delete.feature_type, rows, 1)

        # Set active layer
        layer_name = 'v_edit_' + tools_qt.getWidgetText(self.dlg_feature_delete, self.dlg_feature_delete.feature_type).lower()
        layer = self.controller.get_layer_by_tablename(layer_name)
        self.iface.setActiveLayer(layer)
        self.controller.set_layer_visible(layer)

        # Disable button delete feature
        self.dlg_feature_delete.btn_delete.setEnabled(False)

        # Configure feature_id as typeahead
        completer = QCompleter()
        model = QStringListModel()
        self.filter_typeahead(self.dlg_feature_delete.feature_id, completer, model)

        # Set listeners
        self.dlg_feature_delete.feature_id.textChanged.connect(
            partial(self.filter_typeahead, self.dlg_feature_delete.feature_id, completer, model))

        # Set button snapping
        self.dlg_feature_delete.btn_snapping.clicked.connect(partial(self.set_active_layer))
        self.dlg_feature_delete.btn_snapping.clicked.connect(partial(self.selection_init))
        set_icon(self.dlg_feature_delete.btn_snapping, "137")

        # Set listeners
        self.dlg_feature_delete.btn_cancel.clicked.connect(partial(close_dialog, self.dlg_feature_delete))
        self.dlg_feature_delete.rejected.connect(disconnect_signal_selection_changed)
        self.dlg_feature_delete.rejected.connect(partial(save_settings, self.dlg_feature_delete))

        self.dlg_feature_delete.btn_relations.clicked.connect(partial(self.show_feature_relation))
        self.dlg_feature_delete.btn_delete.clicked.connect(partial(self.delete_feature_relation))
        self.dlg_feature_delete.feature_type.currentIndexChanged.connect(partial(self.set_active_layer))

        # Open dialog
        open_dialog(self.dlg_feature_delete, dlg_name='feature_delete')


    def filter_typeahead(self, widget, completer, model):

        # Get feature_type and feature_id
        feature_type = tools_qt.getWidgetText(self.dlg_feature_delete, self.dlg_feature_delete.feature_type)
        feature_id = tools_qt.getWidgetText(self.dlg_feature_delete, self.dlg_feature_delete.feature_id)

        # Get child layer
        sql = (f"SELECT array_agg({feature_type}_id) FROM {feature_type} "
               f"WHERE {feature_type}_id LIKE '%{feature_id}%' LIMIT 10")
        rows_typeahead = self.controller.get_rows(sql)
        rows_typeahead = rows_typeahead[0][0]

        if rows_typeahead is None:
            model.setStringList([''])
            return

        set_completer_object_api(completer, model, widget, rows_typeahead)
        self.dlg_feature_delete.feature_id.setStyleSheet(None)


    def show_feature_relation(self):

        # Get feature_type and feature_id
        feature_type = tools_qt.getWidgetText(self.dlg_feature_delete, self.dlg_feature_delete.feature_type)
        feature_id = tools_qt.getWidgetText(self.dlg_feature_delete, self.dlg_feature_delete.feature_id)
        if feature_id in (None, "null"):
            message = f"Select one"
            self.controller.show_warning(message, parameter=feature_type)
            return
        feature = '"type":"' + feature_type + '"'
        extras = '"feature_id":"' + feature_id + '"'
        body = create_body(feature=feature, extras=extras)
        result = self.controller.get_json('gw_fct_getfeaturerelation', body)
        if not result or ('status' in result and result['status'] == 'Failed'):
            return False

        # Construct message result
        result_msg = ''
        for value in result['body']['data']['info']['values']:
            result_msg += value['message'] + '\n\n'

        tools_qt.setWidgetText(self.dlg_feature_delete, self.dlg_feature_delete.txt_feature_infolog, result_msg)

        # Enable button delete feature
        if result_msg != '':
            self.dlg_feature_delete.btn_delete.setEnabled(True)


    def delete_feature_relation(self):

        # Get feature_type and feature_id
        feature_type = tools_qt.getWidgetText(self.dlg_feature_delete, self.dlg_feature_delete.feature_type)
        feature_id = tools_qt.getWidgetText(self.dlg_feature_delete, self.dlg_feature_delete.feature_id)
        
        if feature_id == 'null':
            self.dlg_feature_delete.feature_id.setStyleSheet("border: 1px solid red")
            return

        feature = '"type":"' + feature_type + '"'
        extras = '"feature_id":"' + feature_id + '"'
        body = create_body(feature=feature, extras=extras)
        complet_result = self.controller.get_json('gw_fct_setfeaturedelete', body)

        if not complet_result:
            self.controller.show_message("Function gw_fct_setfeaturedelete executed with no result ", 3)
            return

        if 'status' in complet_result and complet_result['status'] == 'Failed':
            return False

        # Populate tab info
        change_tab = False
        data = complet_result['body']['data']
        for k, v in list(data.items()):
            if str(k) == "info":
                change_tab = populate_info_text(self.dlg_feature_delete, data)

        self.dlg_feature_delete.btn_cancel.setText('Accept')

        # Close dialog
        if not change_tab:
            close_dialog(self.dlg_feature_delete)


    def selection_init(self):
        """ Set canvas map tool to an instance of class 'MultipleSelection' """

        disconnect_signal_selection_changed()
        self.iface.actionSelect().trigger()
        self.connect_signal_selection_changed()


    def connect_signal_selection_changed(self):
        """ Connect signal selectionChanged """

        try:
            self.canvas.selectionChanged.connect(partial(self.manage_selection))
        except:
            pass


    def manage_selection(self):
        """ Slot function for signal 'canvas.selectionChanged' """

        # Get feature_type and feature_id
        feature_type = tools_qt.getWidgetText(self.dlg_feature_delete, self.dlg_feature_delete.feature_type).lower()
        layer_name = 'v_edit_' + feature_type
        layer = self.controller.get_layer_by_tablename(layer_name)
        field_id = feature_type + "_id"

        # Iterate over layer
        if layer.selectedFeatureCount() > 0:
            selected_id = None
            # Get selected features of the layer
            features = layer.selectedFeatures()
            for feature in features:
                # Append 'feature_id' into the list
                selected_id = feature.attribute(field_id)

            if selected_id:
                tools_qt.setWidgetText(self.dlg_feature_delete, self.dlg_feature_delete.feature_id, str(selected_id))


    def set_active_layer(self):
        self.dlg_feature_delete.feature_id.setStyleSheet(None)

        # Get current layer and remove selection
        current_layer = self.iface.activeLayer()
        current_layer.removeSelection()

        # Set active layer
        layer_name = 'v_edit_' + \
                     tools_qt.getWidgetText(self.dlg_feature_delete, self.dlg_feature_delete.feature_type).lower()
        layer = self.controller.get_layer_by_tablename(layer_name)
        self.iface.setActiveLayer(layer)
        self.controller.set_layer_visible(layer)

        # Clear feature id field
        tools_qt.setWidgetText(self.dlg_feature_delete, self.dlg_feature_delete.feature_id, '')
        self.dlg_feature_delete.feature_id.setStyleSheet(None)