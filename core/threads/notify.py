"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import json
import threading
from collections import OrderedDict

from qgis.PyQt.QtCore import pyqtSignal, QObject

from ..utils import tools_backend_calls
from ... import global_vars
from ...lib import tools_log, tools_db


class GwNotify(QObject):

    # :var conn_failed:
    # some times, when user click so fast 2 actions, LISTEN channel is stopped, and we need to re-LISTEN all channels
    # Notify cannot use 'iface', directly or indirectly or open dialogs
    conn_failed = False
    list_channels = None
    task_start = pyqtSignal()
    task_finished = pyqtSignal()


    def __init__(self):
        """ Class to control notify from PostgresSql """

        QObject.__init__(self)
        self.iface = global_vars.iface
        self.canvas = global_vars.canvas
        self.settings = global_vars.giswater_settings
        self.plugin_dir = global_vars.plugin_dir


    def start_listening(self, list_channels):
        """
        :param list_channels: List of channels to be listened
        """

        self.list_channels = list_channels
        for channel_name in list_channels:
            tools_db.execute_sql(f'LISTEN "{channel_name}";')

        thread = threading.Thread(target=self._wait_notifications)
        thread.start()


    def task_stopped(self, task):

        tools_log.log_info('Task "{name}" was cancelled'.format(name=task.description()))


    def task_completed(self, exception, result):
        """ Called when run is finished.
        Exception is not None if run raises an exception. Result is the return value of run
        """

        tools_log.log_info("task_completed")

        if exception is None:
            if result is None:
                msg = 'Completed with no exception and no result'
                tools_log.log_info(msg)
            else:
                tools_log.log_info('Task {name} completed\n'
                                   'Total: {total} (with {iterations} '
                                   'iterations)'.format(name=result['task'], total=result['total'],
                                                        iterations=result['iterations']))
        else:
            tools_log.log_info("Exception: {}".format(exception))
            raise exception


    def stop_listening(self, list_channels):
        """
        :param list_channels: List of channels to be unlistened
        """

        for channel_name in list_channels:
            tools_db.execute_sql(f'UNLISTEN "{channel_name}";')


    # region private functions

    def _wait_notifications(self):

        try:
            if self.conn_failed:
                for channel_name in self.list_channels:
                    tools_db.execute_sql(f'LISTEN "{channel_name}";')

                self.conn_failed = False

            # Check if any notification to process
            dao = global_vars.dao
            dao.get_poll()

            executed_notifies = []
            while dao.conn.notifies:
                # We take the poll of notifies, from this we take the last one, if it is not in the list, we put it in
                # the list and execute it. If there is one like it in the executed list, it means that of all those that
                # were in the initial poll we have executed the last one and we do not want to execute the previous ones
                notify = dao.conn.notifies.pop()
                if notify in executed_notifies:
                    continue
                executed_notifies.append(notify)

                msg = f'<font color="blue"><bold>Got NOTIFY: </font>'
                msg += f'<font color="black"><bold>{notify.pid}, {notify.channel}, {notify.payload} </font>'
                tools_log.log_info(msg, tab_name="Giswater Notify")
                try:
                    complet_result = json.loads(notify.payload, object_pairs_hook=OrderedDict)
                    self._execute_functions(complet_result)
                except Exception:
                    pass

            # Initialize thread
            thread = threading.Timer(interval=1, function=self._wait_notifications)
            thread.start()

        except AttributeError:
            self.conn_failed = True


    def _execute_functions(self, complet_result):
        """
        functions called in -> getattr(tools_backend_calls, function_name)(**params)
            def set_layer_index(self, **kwargs)
            def refresh_attribute_table(self, **kwargs)
            def refresh_canvas(self, **kwargs)
            def show_message(self, **kwargs)

        """

        global_vars.session_vars['threads'].append(self)
        self.task_start.emit()
        for function in complet_result['functionAction']['functions']:
            function_name = function['name']
            params = function['parameters']
            try:
                tools_log.log_info(f"Execute function: {function_name} {params}", tab_name="Giswater Notify")
                getattr(tools_backend_calls, function_name)(**params)
            except AttributeError as e:
                # If function_name not exist as python function
                tools_log.log_warning(f"Exception error: {e}", tab_name="Giswater Notify")
        global_vars.session_vars['threads'].remove(self)
        self.task_finished.emit()

    # endregion