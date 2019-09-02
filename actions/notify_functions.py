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
        # self.thread._stop()

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





    def refreshCanvas(self, **kwargs):
        self.canvas.refreshAllLayers()
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


    def refresh_canvas(self, **kwargs):
        self.canvas.refreshAllLayers()
        all_layers = self.controller.get_layers()
        for layer in all_layers:
            layer.triggerRepaint()

    def refresh_attribute_table(self, **kwargs):
        """ Set layer fields configured according to client configuration.
            At the moment manage:
                ValueMap as combos and alias"""


        # layers_list = self.settings.value('system_variables/set_layer_config')
        layers_name_list = kwargs['tableName']
        if not layers_name_list:
            return
        for layer_name in layers_name_list:
            layer = self.controller.get_layer_by_tablename(layer_name)
            if not layer:
                msg = f"Layer {layer_name} does not found, therefore, not configured"
                print(msg)
                # TODO show_warning use self.iface.messageBar().pushMessage("", msg, message_level, duration)
                # TODO mysteriously that leaves the system locked
                # self.controller.show_warning(msg, duration=0)
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
            print(f"{complet_result['body']['data']['fields']}")
            for field in complet_result['body']['data']['fields']:
                if field['widgettype'] != 'combo':
                    continue

                fieldIndex = layer.fields().indexFromName(field['column_id'])
                if field['label']:
                    layer.setFieldAlias(fieldIndex, field['label'])

                _values = {}
                if 'comboIds' in field:
                    for i in range(0, len(field['comboIds'])):
                        _values[field['comboNames'][i]] = field['comboIds'][i]

                editor_widget_setup = QgsEditorWidgetSetup('ValueMap', {'map': _values})
                layer.setEditorWidgetSetup(fieldIndex, editor_widget_setup)
            print(f'LAYER: {layer.name()}')


    def getinfofromid(self, *argv):
        for arg in argv:
            print(arg)




#--insert into api_ws_sample.v_edit_node (node_id, sector_id, dma_id, muni_id, expl_id)VALUES(999999, 2, 2, 1, 1)
# --DELETE FROM api_ws_sample.node WHERE node_id ='999999'
# SELECT * FROM api_ws_sample.node  WHERE node_id ='999999999'
#
# /*
# CREATE TRIGGER bmaps_trg_notify_trigger_api_ws_sample
#  AFTER INSERT
#  ON api_ws_sample.node
#  FOR EACH ROW
#  EXECUTE PROCEDURE api_ws_sample.bmaps_trg_notify_trigger('node');
# */
#
# CREATE OR REPLACE FUNCTION api_ws_sample.bmaps_trg_notify_trigger()
# RETURNS trigger AS
# $BODY$
# DECLARE
#
# BEGIN
# RAISE NOTICE 'test 10';
# PERFORM pg_notify('watchers', '{"functionAction":{"name":"getinfofromid", "param":{"tableName":"'||TG_ARGV[0]||'"}}}');
# --EXECUTE 'insert into api_ws_sample.v_edit_node (node_id, sector_id, dma_id, muni_id, expl_id)VALUES(999999999, 2, 2, 1, 1)';
# RAISE NOTICE 'test rais %', TG_ARGV[0];
# RETURN new;
# END;
# $BODY$
#  LANGUAGE plpgsql VOLATILE
#  COST 100;