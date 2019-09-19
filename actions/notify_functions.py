"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-



try:
    from qgis.core import Qgis
except ImportError:
    from qgis.core import QGis as Qgis

from qgis.core import QgsEditorWidgetSetup, QgsLayerTreeLayer, QgsProject, QgsTask, QgsApplication

import json
import threading
from collections import OrderedDict
from functools import partial
from .parent import ParentAction

class NotifyFunctions(ParentAction):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control notify from PostgresSql """
        ParentAction.__init__(self, iface, settings, controller, plugin_dir)
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir
        

    def start_listening(self, channel_name, target=None, args=()):
        """
        :param channel_name: Channel to be listened
        :param target:  is the callable object to be invoked by the run()
                        method. Defaults to None, meaning nothing is called.
        :param args: is the argument tuple for the target invocation. Defaults to ().
        :return:
        """
        self.controller.execute_sql(f"LISTEN {channel_name};")
        self.thread = threading.Thread(target=getattr(self, target), args=args)
        self.thread.start()
        # task1 = QgsTask.fromFunction('start listening', getattr(self, target)(args), on_finished=self.task_completed, wait_time=20)
        # QgsApplication.taskManager().addTask(task1)

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

    def kill(self):
        self.killed = True

    def stop_listening(self, channel_name):
        self.controller.execute_sql(f"UNLISTEN {channel_name};")
        

    def wait_notifications(self, conn):
        while True:
            conn.poll()
            while conn.notifies:
                notify = conn.notifies.pop(0)
                print(f"Got NOTIFY:{notify.pid}, {notify.channel}, {notify.payload}")
                if not notify.payload:
                    continue

                complet_result = [json.loads(notify.payload, object_pairs_hook=OrderedDict)]
                for function in complet_result[0]['functionAction']['functions']:
                    function_name = function['name']
                    params = function['parameters']
                    getattr(self, function_name)(**params)


    def refresh_canvas(self, **kwargs):
        # Note: canvas.refreshAllLayers() mysteriously that leaves the layers broken
        # self.canvas.refreshAllLayers()

        all_layers = self.controller.get_layers()
        for layer in all_layers:
            layer.triggerRepaint()

    def refresh_attribute_table(self, **kwargs):
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
                print(msg)
                continue

            feature = '"tableName":"' + str(layer_name) + '", "id":""'
            body = self.create_body(feature=feature)
            sql = f"SELECT gw_api_getinfofromid($${{{body}}}$$)"
            row = self.controller.get_row(sql, log_sql=True, commit=True)
            if not row:
                print(f'NOT ROW FOR: {sql}')
                # self.controller.show_message("NOT ROW FOR: " + sql, 2)
                continue

            # When info is nothing
            if 'results' in row[0]:
                if row[0]['results'] == 0:
                    print(f"{row[0]['message']['text']}")
                    # self.controller.show_message(row[0]['message']['text'], 1)
                    continue

            complet_result = row[0]
            for field in complet_result['body']['data']['fields']:
                _values = {}
                # Get column index
                fieldIndex = layer.fields().indexFromName(field['column_id'])

                # Hide selected fields according table config_api_form_fields.hidden
                if 'hidden' in field:
                    self.set_column_visibility(layer, field['column_id'], field['hidden'])

                # Set alias column
                if field['label']:
                    layer.setFieldAlias(fieldIndex, field['label'])

                # Get values
                if field['widgettype'] == 'combo':
                    if 'comboIds' in field:
                        for i in range(0, len(field['comboIds'])):
                            _values[field['comboNames'][i]] = field['comboIds'][i]
                    # Set values into valueMap
                    editor_widget_setup = QgsEditorWidgetSetup('ValueMap', {'map': _values})
                    layer.setEditorWidgetSetup(fieldIndex, editor_widget_setup)




    # TODO unused functions atm
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



    def refreshCanvas(self, **kwargs):

        self.all_layers = []
        root = QgsProject.instance().layerTreeRoot()
        self.get_all_layers(root)
        print(self.all_layers)
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

    def test(self, **kwargs):
        print("TESTTESTTEST")
    def test0(self, **kwargs):
        print("IN TEST0")
        for k, v in kwargs.items():
            print(f'TEST 0 KEY: {k}, VALUE: {v}')
        print("OUT TEST 0")
    # params = {'param11':'test1'}
    def test1(self, param11):
        # **params in call need to be in this format {'param11':'test1'}
        print("IN TEST 1")
        print(param11)

    # params = {'param11':'test1'}
    def test2(self, param21, param22):
        print("IN TEST 2")
        print(f'{param21}, {param22}')
        print("OUT TEST 2")

    def test3(self, **kwargs):
        print("IN TEST 3")
        print(kwargs['param'])
        list_name = kwargs['param']
        print(list_name)
        for x in list_name:
            print(x)
        # for k, v in kwargs.items():
        #     print(f'TEST 3 KEY: {k}, VALUE: {v}')
        print("OUT TEST 3")