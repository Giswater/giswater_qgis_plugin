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

if Qgis.QGIS_VERSION_INT < 29900:
    pass
    import ConfigParser as configparser
else:
    pass
    import configparser

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


    def kill(self):
        self.killed = True

    def stop_listening(self, channel_name):
        self.controller.execute_sql(f"UNLISTEN {channel_name};")
        self.thread._stop()

    def wait_notifications(self, conn):
        while True:
            conn.poll()
            while conn.notifies:
                notify = conn.notifies.pop(0)
                print(f"Got NOTIFY:{notify.pid}, {notify.channel}, {notify.payload}")
                if not notify.payload:
                    continue

                complet_result = [json.loads(notify.payload, object_pairs_hook=OrderedDict)]
                print("\n--------------------------------------------------")
                self.controller.log_info(str(complet_result[0]['functionAction']))
                function_name = complet_result[0]['functionAction']['name']
                print(function_name)
                # (partial(getattr(self, function_name), dialog, self.my_json))
                getattr(self, function_name)('test param', 'test param2')

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