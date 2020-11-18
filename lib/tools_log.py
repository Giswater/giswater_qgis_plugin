"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import logging
import inspect
import os
import time
import sys

from qgis.core import QgsMessageLog


from .. import global_vars
from ..core.utils import tools_gw
from ..lib import tools_log

class Logger(object):

    def __init__(self, controller, log_name, log_level, log_suffix, folder_has_tstamp=False, file_has_tstamp=True,
            remove_previous=False):
        """ Class constructor """

        # Create logger
        self.controller = controller
        self.logger_file = logging.getLogger(log_name)
        self.logger_file.setLevel(log_level)

        # Define log folder in users folder
        main_folder = os.path.join(os.path.expanduser("~"), self.controller.plugin_name)
        log_folder = main_folder + os.sep + "log" + os.sep
        if folder_has_tstamp:
            tstamp = str(time.strftime(log_suffix))
            log_folder += tstamp + os.sep
        if not os.path.exists(log_folder):
            os.makedirs(log_folder)

        # Define filename
        filepath = log_folder + log_name
        if file_has_tstamp:
            tstamp = str(time.strftime(log_suffix))
            filepath += "_" + tstamp
        filepath += ".log"

        self.log_folder = log_folder
        tools_log.log_info(f"Log file: {filepath}", logger_file=False)
        if remove_previous and os.path.exists(filepath):
            os.remove(filepath)

        # Define format
        log_format = '%(asctime)s [%(levelname)s] - %(message)s\n'
        log_date = '%d/%m/%Y %H:%M:%S'
        formatter = logging.Formatter(log_format, log_date)

        # Create file handler
        self.fh = logging.FileHandler(filepath)
        self.fh.setFormatter(formatter)
        self.logger_file.addHandler(self.fh)

        # Initialize number of errors in current process
        self.num_errors = 0


    def close_logger(self):
        """ Close logger file """

        try:
            self.logger_file.removeHandler(self.fh)
            self.fh.flush()
            self.fh.close()
            del self.fh
        except Exception:
            pass


    def log(self, msg=None, log_level=logging.INFO, stack_level=2):
        """ Logger message into logger file with selected level """

        try:
            module_path = inspect.stack()[stack_level][1]
            file_name = os.path.basename(module_path)
            function_line = inspect.stack()[stack_level][2]
            function_name = inspect.stack()[stack_level][3]
            header = "{" + file_name + " | Line " + str(function_line) + " (" + str(function_name) + ")}"
            text = header
            if msg:
                text += "\n" + str(msg)
            self.logger_file.log(log_level, text)

        except Exception as e:
            tools_log.log_warning("Error logging: " + str(e), logger_file=False)


    def debug(self, msg=None, stack_level=2, stack_level_increase=0):
        """ Logger message into logger file with level DEBUG (10) """
        self.log(msg, logging.DEBUG, stack_level + stack_level_increase + 1)


    def info(self, msg=None, stack_level=2, stack_level_increase=0):
        """ Logger message into logger file with level INFO (20) """
        self.log(msg, logging.INFO, stack_level + stack_level_increase + 1)


    def warning(self, msg=None, stack_level=2, stack_level_increase=0, sum_error=True):
        """ Logger message into logger file with level WARNING (30) """
        self.log(msg, logging.WARNING, stack_level + stack_level_increase + 1)
        if sum_error:
            self.num_errors += 1


    def error(self, msg=None, stack_level=2, stack_level_increase=0, sum_error=True):
        """ Logger message into logger file with level ERROR (40) """
        self.log(msg, logging.ERROR, stack_level + stack_level_increase + 1)
        if sum_error:
            self.num_errors += 1


    def critical(self, msg=None, stack_level=2, stack_level_increase=0, sum_error=True):
        """ Logger message into logger file with level CRITICAL (50) """
        self.log(msg, logging.CRITICAL, stack_level + stack_level_increase + 1)
        if sum_error:
            self.num_errors += 1


def set_logger(self, logger_name=None):
    """ Set logger class """
    if global_vars.logger is None:
        if logger_name is None:
            logger_name = 'plugin'
        global_vars.min_log_level = int(global_vars.settings.value('status/log_level'))
        log_suffix = global_vars.settings.value('status/log_suffix')
        global_vars.logger = Logger(self, logger_name, global_vars.min_log_level, log_suffix)
        if global_vars.min_log_level == 10:
            global_vars.min_message_level = 0
        elif global_vars.min_log_level == 20:
            global_vars.min_message_level = 0
        elif global_vars.min_log_level == 30:
            global_vars.min_message_level = 1
        elif global_vars.min_log_level == 40:
            global_vars.min_message_level = 2

def qgis_log_message(text=None, message_level=0, context_name=None, parameter=None, tab_name=None):
    """ Write message into QGIS Log Messages Panel with selected message level
        @message_level: {INFO = 0, WARNING = 1, CRITICAL = 2, SUCCESS = 3, NONE = 4}
    """

    msg = None
    if text:
        msg = tools_gw.tr(text, context_name)
        if parameter:
            msg += ": " + str(parameter)

    if tab_name is None:
        tab_name = global_vars.plugin_name
    if message_level >= global_vars.min_message_level:
        QgsMessageLog.logMessage(msg, tab_name, message_level)

    return msg


def log_message(text=None, message_level=0, context_name=None, parameter=None, logger_file=True,
                stack_level_increase=0, tab_name=None):
    """ Write message into QGIS Log Messages Panel """

    msg = qgis_log_message(text, message_level, context_name, parameter, tab_name)
    if global_vars.logger and logger_file:
        if message_level == 0:
            global_vars.logger.info(msg, stack_level_increase=stack_level_increase)
        elif message_level == 1:
            global_vars.logger.warning(msg, stack_level_increase=stack_level_increase)
        elif message_level == 2:
            global_vars.logger.error(msg, stack_level_increase=stack_level_increase)
        elif message_level == 4:
            global_vars.logger.debug(msg, stack_level_increase=stack_level_increase)


def log_debug(text=None, context_name=None, parameter=None, logger_file=True,
              stack_level_increase=0, tab_name=None):
    """ Write debug message into QGIS Log Messages Panel """

    msg = qgis_log_message(text, 0, context_name, parameter, tab_name)
    if global_vars.logger and logger_file:
        global_vars.logger.debug(msg, stack_level_increase=stack_level_increase)


def log_info(text=None, context_name=None, parameter=None, logger_file=True,
             stack_level_increase=0, tab_name=None, level=0):
    """ Write information message into QGIS Log Messages Panel """

    msg = qgis_log_message(text, level, context_name, parameter, tab_name)
    if global_vars.logger and logger_file:
        global_vars.logger.info(msg, stack_level_increase=stack_level_increase)


def log_warning(text=None, context_name=None, parameter=None, logger_file=True,
                stack_level_increase=0, tab_name=None):
    """ Write warning message into QGIS Log Messages Panel """

    msg = qgis_log_message(text, 1, context_name, parameter, tab_name)
    if global_vars.logger and logger_file:
        global_vars.logger.warning(msg, stack_level_increase=stack_level_increase)


def log_error(text=None, context_name=None, parameter=None, logger_file=True,
              stack_level_increase=0, tab_name=None):
    """ Write error message into QGIS Log Messages Panel """

    msg = qgis_log_message(text, 2, context_name, parameter, tab_name)
    if global_vars.logger and logger_file:
        global_vars.logger.error(msg, stack_level_increase=stack_level_increase)