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
from ...lib import tools_log, tools_db, tools_os
from ..utils import tools_gw


class GwNotify(QObject):

    # :var conn_failed:
    # some times, when user click so fast 2 actions, LISTEN channel is stopped, and we need to re-LISTEN all channels
    # Notify cannot use 'iface', directly or indirectly or open dialogs
    conn_failed = False
    list_channels = None
    log_sql = None
    task_start = pyqtSignal()
    task_finished = pyqtSignal()


    def __init__(self):
        """ Class to control notify from PostgresSql """

        QObject.__init__(self)


    def start_listening(self, list_channels=None):
        """
        :param list_channels: List of channels to be listened
        """

        tools_log.log_info("Notifiy started")
        if list_channels:
            self.list_channels = list_channels
        for channel_name in self.list_channels:
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


    def stop_listening(self, list_channels=None):
        """
        :param list_channels: List of channels to be unlistened
        """

        tools_log.log_info("Notifiy stopped")
        if list_channels:
            self.list_channels = list_channels
        for channel_name in self.list_channels:
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
            status = dao.get_poll()

            # If connection has been restarted then reset notify
            if not status:
                self.start_listening()
                tools_log.log_info(f"PostgreSQL PID: {global_vars.dao.pid}")

            executed_notifies = []
            while dao.conn.notifies:
                # We take the poll of notifies, from this we take the last one, if it is not in the list, we put it in
                # the list and execute it. If there is one like it in the executed list, it means that of all those that
                # were in the initial poll we have executed the last one and we do not want to execute the previous ones
                notify = dao.conn.notifies.pop()
                if notify in executed_notifies:
                    continue
                executed_notifies.append(notify)

                # Check parameter 'log_sql'
                log_sql = tools_gw.get_config_parser("log", f"log_sql", "user", "init", False, get_none=True)
                self.log_sql = tools_os.set_boolean(log_sql, False)

                if self.log_sql:
                    msg = f'<font color="blue"><b>GOT SERVER NOTIFY: </font>'
                    msg += f'<font color="black"><b>{notify.pid}, {notify.channel}, {notify.payload} </font>'
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
            if hasattr(tools_backend_calls, function_name):
                getattr(tools_backend_calls, function_name)(**params)
                msg = f'<font color="blue">CLIENT EXECUTION: </font>'
                msg += f'<font color="black">{function_name} {params}</font>'
                if self.log_sql:
                    tools_log.log_info(msg, tab_name="Giswater Notify")
            else:
                msg = f'<font color="red">Python function not found: {function_name}</font>'
                if self.log_sql:
                    tools_log.log_warning(msg, tab_name="Giswater Notify")

        global_vars.session_vars['threads'].remove(self)
        self.task_finished.emit()

    # endregion