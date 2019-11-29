"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsEditorWidgetSetup, QgsFieldConstraints, QgsMessageLog, QgsLayerTreeLayer, QgsProject
from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtWidgets import QMessageBox

import json
import threading
from collections import OrderedDict

from .parent import ParentAction


class NotifyFunctions(ParentAction):
    # :var conn_failed: some times, when user click so fast 2 actions, LISTEN channel is stopped, and we need to
    #                   re-LISTEN all channels
    conn_failed = False
    list_channels = None
    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control notify from PostgresSql """

        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir


    def start_listening(self, list_channels):
        """
        :param list_channels: List of channels to be listened
        """
        self.list_channels = list_channels
        for channel_name in list_channels:
            self.controller.execute_sql(f"LISTEN {channel_name};")

        thread = threading.Thread(target=self.wait_notifications)
        thread.start()


    def task_stopped(self, task):

        self.controller.log_info('Task "{name}" was cancelled'.format(name=task.description()))


    def task_completed(self, exception, result):
        """ Called when run is finished.
        Exception is not None if run raises an exception. Result is the return value of run
        """

        self.controller.log_info("task_completed")

        if exception is None:
            if result is None:
                msg = 'Completed with no exception and no result'
                self.controller.log_info(msg)
            else:
                self.controller.log_info('Task {name} completed\n'
                    'Total: {total} (with {iterations} '
                    'iterations)'.format(name=result['task'], total=result['total'],
                                         iterations=result['iterations']))
        else:
            self.controller.log_info("Exception: {}".format(exception))
            raise exception


    def stop_listening(self, list_channels):
        """
        :param list_channels: List of channels to be unlistened
        """

        for channel_name in list_channels:
            self.controller.execute_sql(f"UNLISTEN {channel_name};")


    def wait_notifications(self):
        try:
            if self.conn_failed:
                for channel_name in self.list_channels:
                    self.controller.execute_sql(f"LISTEN {channel_name};")
                self.conn_failed = False

            # Initialize thread
            thread = threading.Timer(interval=0.1, function=self.wait_notifications)
            thread.start()

            # Check if any notification to process
            conn = self.controller.dao.conn
            conn.poll()
            while conn.notifies:
                notify = conn.notifies.pop()
                msg = f'<font color="blue"><bold>Got NOTIFY: </font>'
                msg += f'<font color="black"><bold>{notify.pid}, {notify.channel}, {notify.payload} </font>'
                self.controller.log_info(msg)
                if notify.payload:
                    try:
                        complet_result = json.loads(notify.payload, object_pairs_hook=OrderedDict)
                        self.execute_functions(complet_result)
                    except Exception as e:
                        pass

        except AttributeError:
            self.conn_failed = True


    def execute_functions(self, complet_result):
        """
        functions called in -> getattr(self, function_name)(**params):
            def indexing_spatial_layer(self, **kwargs)
            def refresh_attribute_table(self, **kwargs)
            def refresh_canvas(self, **kwargs)
            def show_message(self, **kwargs)
        """

        for function in complet_result['functionAction']['functions']:
            function_name = function['name']
            params = function['parameters']
            try:
                getattr(self, function_name)(**params)
            except AttributeError as e:
                # If function_name not exist as python function
                self.controller.log_warning(f"Exception error: {e}")


    # Functions called by def wait_notifications(...)
    def indexing_spatial_layer(self, **kwargs):
        """ Force reload dataProvider of layer """
        """ Function called in def wait_notifications(...) -->  getattr(self, function_name)(**params) """
        # Get list of layer names
        layers_name_list = kwargs['tableName']
        if not layers_name_list:
            return
        if type(layers_name_list) == str:
            self.controller.indexing_spatial_layer(layers_name_list)
        if type(layers_name_list) == list:
            for layer_name in layers_name_list:
                self.controller.indexing_spatial_layer(layer_name)


    def refresh_attribute_table(self, **kwargs):
        """ Function called in def wait_notifications(...) -->  getattr(self, function_name)(**params) """
        """ Set layer fields configured according to client configuration.
            At the moment manage:
                Column names as alias, combos and typeahead as ValueMap"""

        # Get list of layer names
        layers_name_list = kwargs['tableName']
        if not layers_name_list:
            return

        for layer_name in layers_name_list:
            layer = self.controller.get_layer_by_tablename(layer_name)
            if not layer:
                msg = f"Layer {layer_name} does not found, therefore, not configured"
                self.controller.log_info(msg)
                continue

            feature = '"tableName":"' + str(layer_name) + '", "id":""'
            body = self.create_body(feature=feature)
            sql = f"SELECT gw_api_getinfofromid($${{{body}}}$$)"
            row = self.controller.get_row(sql, log_sql=True, commit=True)
            if not row:
                self.controller.log_info(f'NOT ROW FOR: {sql}')
                continue

            # When info is nothing
            if 'results' in row[0]:
                if row[0]['results'] == 0:
                    self.controller.log_info(f"{row[0]['message']['text']}")
                    continue

            complet_result = row[0]
            for field in complet_result['body']['data']['fields']:
                _values = {}
                # Get column index
                fieldIndex = layer.fields().indexFromName(field['column_id'])

                # Hide selected fields according table config_api_form_fields.hidden
                if 'hidden' in field:
                    self.set_column_visibility(layer, field['column_id'], field['hidden'])
                # Set multiline fields according table config_api_form_fields.widgetcontrols['setQgisMultiline']
                if field['widgetcontrols'] is not None and 'setQgisMultiline' in field['widgetcontrols']:
                    self.set_column_multiline(layer, field, fieldIndex)
                # Set alias column
                if field['label']:
                    layer.setFieldAlias(fieldIndex, field['label'])

                # Set field constraints
                if field['widgetcontrols'] and 'setQgisConstraints' in field['widgetcontrols']:
                    if field['widgetcontrols']['setQgisConstraints'] is True:
                        layer.setFieldConstraint(fieldIndex, QgsFieldConstraints.ConstraintNotNull,
                                             QgsFieldConstraints.ConstraintStrengthSoft)
                        layer.setFieldConstraint(fieldIndex, QgsFieldConstraints.ConstraintUnique,
                                             QgsFieldConstraints.ConstraintStrengthHard)

                # Manage editability
                self.set_read_only(layer, field, fieldIndex)

                # Manage fields
                if field['widgettype'] == 'combo':
                    if 'comboIds' in field:
                        for i in range(0, len(field['comboIds'])):
                            _values[field['comboNames'][i]] = field['comboIds'][i]
                    # Set values into valueMap
                    editor_widget_setup = QgsEditorWidgetSetup('ValueMap', {'map': _values})
                    layer.setEditorWidgetSetup(fieldIndex, editor_widget_setup)


    def refresh_canvas(self, **kwargs):
        """ Function called in def wait_notifications(...) -->  getattr(self, function_name)(**params) """
        # Note: canvas.refreshAllLayers() mysteriously that leaves the layers broken
        # self.canvas.refreshAllLayers()

        all_layers = self.controller.get_layers()
        for layer in all_layers:
            layer.triggerRepaint()


    def show_message(self, **kwargs):
        """
        PERFORM pg_notify(current_user,
                  '{"functionAction":{"functions":[{"name":"show_message","parameters":
                  {"message":"line 1 \n line 2","tabName":"Notify channel",
                  "styleSheet":{"level":1,"color":"red","bold":true}}}]},"user":"postgres","schema":"api_ws_sample"}');

        functions called in -> getattr(self, function_name)(**params):
        Show message in console log,
        :param kwargs: dict with all needed
        :param kwargs['message']: message to show
        :param kwargs['tabName']: tab where the info will be displayed
        :param kwargs['styleSheet']:  define text format (message type, color, and bold), 0 = Info(black), 1 = Warning(orange), 2 = Critical(red), 3 = Success(blue), 4 = None(black)
        :param kwargs['styleSheet']['level']: 0 = Info(black), 1 = Warning(orange), 2 = Critical(red), 3 = Success(blue), 4 = None(black)
        :param kwargs['styleSheet']['color']: can be like "red", "green", "orange", "pink"...typical html colors
        :param kwargs['styleSheet']['bold']: if is true, then print as bold
        :return:
        """

        # Set default styleSheet
        color = "black"
        level = 0
        bold = ''

        msg = kwargs['message'] if 'message' in kwargs else 'No message found'
        tab_name = kwargs['tabName'] if 'tabName' in kwargs else 'Notify channel'
        if 'styleSheet' in kwargs:
            color = kwargs['styleSheet']['color'] if 'color' in kwargs['styleSheet'] else "black"
            level = kwargs['styleSheet']['level'] if 'level' in kwargs['styleSheet'] else 0
            if 'bold' in kwargs['styleSheet']:
                bold = 'b' if kwargs['styleSheet']['bold'] else ''
            else:
                bold = ''

        msg = f'<font color="{color}"><{bold}>{msg}</font>'
        QgsMessageLog.logMessage(msg, tab_name, level)


    # Another used functions
    def set_column_visibility(self, layer, col_name, hidden):
        """ Hide selected fields according table config_api_form_fields.hidden """

        config = layer.attributeTableConfig()
        columns = config.columns()
        for column in columns:
            if column.name == str(col_name):
                column.hidden = hidden
                break
        config.setColumns(columns)
        layer.setAttributeTableConfig(config)


    def set_column_multiline(self, layer, field, fieldIndex):
        """ Set multiline selected fields according table config_api_form_fields.widgetcontrols['setQgisMultiline'] """

        if field['widgettype'] == 'text':
            if field['widgetcontrols'] and 'setQgisMultiline' in field['widgetcontrols']:
                editor_widget_setup = QgsEditorWidgetSetup('TextEdit', {'IsMultiline': field['widgetcontrols']['setQgisMultiline']})
                layer.setEditorWidgetSetup(fieldIndex, editor_widget_setup)


    def set_read_only(self, layer, field, field_index):
        """ Set field readOnly according to client configuration into config_api_form_fields (field 'iseditable')"""

        # Get layer config
        config = layer.editFormConfig()
        try:
            # Set field editability
            config.setReadOnly(field_index, not field['iseditable'])
        except KeyError as e:
            # Control if key 'iseditable' not exist
            pass
        finally:
            # Set layer config
            layer.setEditFormConfig(config)


    #  TODO unused functions atm
    def show_messagebox(self, **kwargs):
        """ Shows a message box with detail information """

        msg = kwargs['message'] if 'message' in kwargs else 'No message found'
        title = kwargs['title'] if 'title' in kwargs else 'New message'
        inf_text = kwargs['inf_text'] if 'inf_text' in kwargs else 'Info text'
        # color = "black"
        # bold = ''
        # if 'styleSheet' in kwargs:
        #     color = kwargs['styleSheet']['color'] if 'color' in kwargs['styleSheet'] else "black"
        #     if 'bold' in kwargs['styleSheet']:
        #         bold = 'b' if kwargs['styleSheet']['bold'] else ''
        #     else:
        #         bold = ''
        # msg = f'<font color="{color}"><{bold}>{msg}</font>'
        msg_box = QMessageBox()
        msg_box.setText(msg)
        if title:
            title = self.controller.tr(title)
            msg_box.setWindowTitle(title)
        if inf_text:
            inf_text = self.controller.tr(inf_text)
            msg_box.setInformativeText(inf_text)
        msg_box.setWindowFlags(Qt.WindowStaysOnTopHint)
        msg_box.setStandardButtons(QMessageBox.Ok)
        msg_box.setDefaultButton(QMessageBox.Ok)
        msg_box.open()


    def raise_notice(self, **kwargs):
        """ Function called in def wait_notifications(...) -->  getattr(self, function_name)(**params)
            Used to show raise notices sent by postgresql
        """

        msg_list = kwargs['msg']
        for msg in msg_list:
            self.controller.log_info(f"{msg}")


    def refreshCanvas(self, **kwargs):

        self.all_layers = []
        root = QgsProject.instance().layerTreeRoot()
        self.get_all_layers(root)
        for layer_name in self.all_layers:
            layer = self.controller.get_layer_by_tablename(layer_name)
            layer.triggerRepaint()


    def get_all_layers(self, group):

        for child in group.children():
            if isinstance(child, QgsLayerTreeLayer):
                self.all_layers.append(child.layer().name())
                child.layer().name()
            else:
                self.get_all_layers(child)

