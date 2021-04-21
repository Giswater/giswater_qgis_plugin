"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from qgis.PyQt.QtCore import QStringListModel
from qgis.PyQt.QtWidgets import QCompleter

from ..dialog import GwAction
from ...ui.ui_manager import GwFeatureDeleteUi
from ...utils import tools_gw
from .... import global_vars
from ....lib import tools_qgis, tools_qt, tools_db


class GwFeatureDeleteButton(GwAction):
    """ Button 69: Delete feature """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.dlg_feature_delete = None


    def clicked_event(self):

        # Create the dialog and signals
        self.dlg_feature_delete = GwFeatureDeleteUi()
        tools_gw.load_settings(self.dlg_feature_delete)

        # Populate combo feature type
        sql = 'SELECT DISTINCT(feature_type) AS id, feature_type AS idval FROM cat_feature'
        rows = tools_db.get_rows(sql)
        tools_qt.fill_combo_values(self.dlg_feature_delete.feature_type, rows, 1)

        # Set active layer
        layer_name = 'v_edit_' + tools_qt.get_text(self.dlg_feature_delete, self.dlg_feature_delete.feature_type).lower()
        layer = tools_qgis.get_layer_by_tablename(layer_name)
        self.iface.setActiveLayer(layer)
        tools_qgis.set_layer_visible(layer)

        # Disable button delete feature
        self.dlg_feature_delete.btn_delete.setEnabled(False)

        # Configure feature_id as typeahead
        completer = QCompleter()
        model = QStringListModel()
        self._filter_typeahead(self.dlg_feature_delete.feature_id, completer, model)

        # Set listeners
        self.dlg_feature_delete.feature_id.textChanged.connect(
            partial(self._filter_typeahead, self.dlg_feature_delete.feature_id, completer, model))

        # Set button snapping
        self.dlg_feature_delete.btn_snapping.clicked.connect(partial(self._set_active_layer))
        self.dlg_feature_delete.btn_snapping.clicked.connect(partial(self._selection_init))
        tools_gw.add_icon(self.dlg_feature_delete.btn_snapping, "137")

        # Set listeners
        self.dlg_feature_delete.btn_cancel.clicked.connect(partial(tools_gw.close_dialog, self.dlg_feature_delete))
        self.dlg_feature_delete.rejected.connect(tools_qgis.disconnect_signal_selection_changed)
        self.dlg_feature_delete.rejected.connect(partial(tools_gw.save_settings, self.dlg_feature_delete))

        self.dlg_feature_delete.btn_relations.clicked.connect(partial(self._show_feature_relation))
        self.dlg_feature_delete.btn_delete.clicked.connect(partial(self._delete_feature_relation))
        self.dlg_feature_delete.feature_type.currentIndexChanged.connect(partial(self._set_active_layer))

        # Open dialog
        tools_gw.open_dialog(self.dlg_feature_delete, dlg_name='feature_delete')


    def _filter_typeahead(self, widget, completer, model):

        # Get feature_type and feature_id
        feature_type = tools_qt.get_text(self.dlg_feature_delete, self.dlg_feature_delete.feature_type)
        feature_id = tools_qt.get_text(self.dlg_feature_delete, self.dlg_feature_delete.feature_id)

        # Get child layer
        sql = (f"SELECT array_agg({feature_type}_id) FROM {feature_type} "
               f"WHERE {feature_type}_id LIKE '%{feature_id}%' LIMIT 10")
        rows_typeahead = tools_db.get_rows(sql)
        rows_typeahead = rows_typeahead[0][0]

        if rows_typeahead is None:
            model.setStringList([''])
            return

        tools_qt.set_completer_object(completer, model, widget, rows_typeahead)
        self.dlg_feature_delete.feature_id.setStyleSheet(None)


    def connect_signal_selection_changed(self):
        """ Connect signal selectionChanged """

        try:
            self.canvas.selectionChanged.connect(partial(self._manage_selection))
        except:
            pass


    # region private functions

    def _show_feature_relation(self):

        # Get feature_type and feature_id
        feature_type = tools_qt.get_text(self.dlg_feature_delete, self.dlg_feature_delete.feature_type)
        feature_id = tools_qt.get_text(self.dlg_feature_delete, self.dlg_feature_delete.feature_id)
        if feature_id in (None, "null"):
            message = f"Select one"
            tools_qgis.show_warning(message, parameter=feature_type)
            return
        feature = '"type":"' + feature_type + '"'
        extras = '"feature_id":"' + feature_id + '"'
        body = tools_gw.create_body(feature=feature, extras=extras)
        result = tools_gw.execute_procedure('gw_fct_getfeaturerelation', body)
        if not result or ('status' in result and result['status'] == 'Failed'):
            return False

        # Construct message result
        result_msg = ''
        for value in result['body']['data']['info']['values']:
            result_msg += value['message'] + '\n\n'

        tools_qt.set_widget_text(self.dlg_feature_delete, self.dlg_feature_delete.txt_feature_infolog, result_msg)

        # Enable button delete feature
        if result_msg != '':
            self.dlg_feature_delete.btn_delete.setEnabled(True)


    def _delete_feature_relation(self):

        # Get feature_type and feature_id
        feature_type = tools_qt.get_text(self.dlg_feature_delete, self.dlg_feature_delete.feature_type)
        feature_id = tools_qt.get_text(self.dlg_feature_delete, self.dlg_feature_delete.feature_id)
        
        if feature_id == 'null':
            self.dlg_feature_delete.feature_id.setStyleSheet("border: 1px solid red")
            return
        self.dlg_feature_delete.feature_id.setStyleSheet(None)
        feature = '"type":"' + feature_type + '"'
        extras = '"feature_id":"' + feature_id + '"'
        body = tools_gw.create_body(feature=feature, extras=extras)
        complet_result = tools_gw.execute_procedure('gw_fct_setfeaturedelete', body)

        if not complet_result:
            tools_qgis.show_message("Function gw_fct_setfeaturedelete executed with no result ", 3)
            return

        if 'status' in complet_result and complet_result['status'] == 'Failed':
            return False

        # Populate tab info
        change_tab = False
        data = complet_result['body']['data']
        for k, v in list(data.items()):
            if str(k) == "info":
                change_tab = tools_gw.fill_tab_log(self.dlg_feature_delete, data)

        self.dlg_feature_delete.btn_cancel.setText('Accept')

        # Close dialog
        if not change_tab:
            tools_gw.close_dialog(self.dlg_feature_delete)


    def _selection_init(self):
        """ Set canvas map tool to an instance of class 'GwSelectManager' """

        tools_qgis.disconnect_signal_selection_changed()
        self.iface.actionSelect().trigger()
        self.connect_signal_selection_changed()


    def _manage_selection(self):
        """ Slot function for signal 'canvas.selectionChanged' """

        # Get feature_type and feature_id
        feature_type = tools_qt.get_text(self.dlg_feature_delete, self.dlg_feature_delete.feature_type).lower()
        layer_name = 'v_edit_' + feature_type
        layer = tools_qgis.get_layer_by_tablename(layer_name)
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
                tools_qt.set_widget_text(self.dlg_feature_delete, self.dlg_feature_delete.feature_id, str(selected_id))


    def _set_active_layer(self):

        self.dlg_feature_delete.feature_id.setStyleSheet(None)

        # Get current layer and remove selection
        current_layer = self.iface.activeLayer()
        current_layer.removeSelection()

        # Set active layer
        layer_name = 'v_edit_' + tools_qt.get_text(self.dlg_feature_delete, self.dlg_feature_delete.feature_type).lower()
        layer = tools_qgis.get_layer_by_tablename(layer_name)
        self.iface.setActiveLayer(layer)
        tools_qgis.set_layer_visible(layer)

        # Clear feature id field
        tools_qt.set_widget_text(self.dlg_feature_delete, self.dlg_feature_delete.feature_id, '')
        self.dlg_feature_delete.feature_id.setStyleSheet(None)

    # endregion