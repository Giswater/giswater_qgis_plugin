"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import random

from qgis.core import QgsTask, QgsApplication

from ..lib import tools_log


class GwTestTask:

    def _task_started(self, task, wait_time):
        """ Dumb test function.
        to break the task raise an exception
        to return a successful result return it.
        This will be passed together with the exception (None in case of success) to the on_finished method
        """

        tools_log.log_info("Started task '{}'".format(task.description()))

        wait_time = wait_time / 100
        total = 0
        iterations = 0
        for i in range(101):
            sleep(wait_time)
            task.setProgress(i)
            total += random.randint(0, 100)
            iterations += 1
            # Check if task is canceled to handle it...
            if task.isCanceled():
                self._task_stopped(task)
                return None

            # Example of Raise exception to abort task
            if random.randint(0, 1000) == 10:
                raise Exception('Bad value!')

        # return True
        self._task_completed(None, {'total': total, 'iterations': iterations, 'task': task.description()})


    def _task_stopped(self, task):
        """"""
        tools_log.log_info('Task "{name}" was cancelled'.format(name=task.description()))


    def _task_completed(self, exception, result):
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


    def _task_example(self):
        """ Add task example to taskManager """

        tools_log.log_info("task_example")
        task1 = QgsTask.fromFunction('task_example', self._task_started, on_finished=self._task_completed, wait_time=20)
        QgsApplication.taskManager().addTask(task1)

