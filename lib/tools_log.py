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
import json

from qgis.core import QgsMessageLog

from .. import global_vars
from . import tools_qt, tools_os


class GwLogger(object):

    def __init__(self, log_name, log_level, log_suffix, folder_has_tstamp=False, file_has_tstamp=True,
                 remove_previous=False):

        # Create logger
        self.logger_file = logging.getLogger(log_name)
        self.logger_file.setLevel(int(log_level))
        self.min_log_level = int(log_level)
        self.log_limit_characters = None
        self.db_limit_characters = None
        self.tab_python = f"{global_vars.plugin_name.capitalize()} PY"
        self.tab_db = f"{global_vars.plugin_name.capitalize()} DB"

        # Define log folder in users folder
        main_folder = os.path.join(tools_os.get_datadir(), global_vars.user_folder_dir)
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

        log_info(f"Log file: {filepath}", logger_file=False, tab_name=self.tab_python)
        if remove_previous and os.path.exists(filepath):
            os.remove(filepath)

        # Initialize number of errors in current process
        self.num_errors = 0

        # Add file handler
        self.add_file_handler(filepath)


    def set_logger_parameters(self, min_log_level, log_limit_characters, db_limit_characters):
        """ Set logger parameters min_log_level, log_limit_characters, db_limit_characters """

        if isinstance(min_log_level, int):
            self.min_log_level = min_log_level
        if isinstance(log_limit_characters, int):
            self.log_limit_characters = log_limit_characters
        if isinstance(db_limit_characters, int):
            self.db_limit_characters = db_limit_characters


    def add_file_handler(self, filepath):
        """ Add file handler """

        log_format = '%(asctime)s [%(levelname)s] - %(message)s\n'
        log_date = '%d/%m/%Y %H:%M:%S'
        formatter = logging.Formatter(log_format, log_date)
        self.fh = logging.FileHandler(filepath)
        self.fh.setFormatter(formatter)
        self.logger_file.addHandler(self.fh)


    def close_logger(self):
        """ Remove file handler """

        try:
            self.logger_file.removeHandler(self.fh)
            self.fh.flush()
            self.fh.close()
            del self.fh
        except Exception:
            pass


    def debug(self, msg=None, stack_level=2, stack_level_increase=0):
        """ Logger message into logger file with level DEBUG (10) """
        self._log(msg, logging.DEBUG, stack_level + stack_level_increase + 1)


    def info(self, msg=None, stack_level=2, stack_level_increase=0):
        """ Logger message into logger file with level INFO (20) """
        self._log(msg, logging.INFO, stack_level + stack_level_increase + 1)


    def warning(self, msg=None, stack_level=2, stack_level_increase=0, sum_error=True):
        """ Logger message into logger file with level WARNING (30) """
        self._log(msg, logging.WARNING, stack_level + stack_level_increase + 1)
        if sum_error:
            self.num_errors += 1


    def error(self, msg=None, stack_level=2, stack_level_increase=0, sum_error=True):
        """ Logger message into logger file with level ERROR (40) """
        self._log(msg, logging.ERROR, stack_level + stack_level_increase + 1)
        if sum_error:
            self.num_errors += 1


    def critical(self, msg=None, stack_level=2, stack_level_increase=0, sum_error=True):
        """ Logger message into logger file with level CRITICAL (50) """
        self._log(msg, logging.CRITICAL, stack_level + stack_level_increase + 1)
        if sum_error:
            self.num_errors += 1


    def _log(self, msg=None, log_level=logging.INFO, stack_level=2):
        """ Logger message into logger file with selected level """

        try:

            # Check session parameter 'min_log_level' to know if we need to log message in logger file
            if log_level < self.min_log_level:
                return

            if stack_level >= len(inspect.stack()):
                stack_level = len(inspect.stack()) - 1
            module_path = inspect.stack()[stack_level][1]
            file_name = os.path.basename(module_path)
            function_line = inspect.stack()[stack_level][2]
            function_name = inspect.stack()[stack_level][3]
            header = "{" + file_name + " | Line " + str(function_line) + " (" + str(function_name) + ")}"
            text = header
            if msg:
                if self.log_limit_characters and len(msg) > int(self.log_limit_characters):
                    msg = msg[:int(self.log_limit_characters)]
                text += f"\n{msg}"
            self.logger_file.log(log_level, text)

        except Exception as e:
            log_warning(f"Error logging: {e}", logger_file=False)


def set_logger(logger_name, min_log_level=20):
    """ Set logger class. This class will generate new logger file """

    if global_vars.logger is None:
        log_suffix = '%Y%m%d'
        global_vars.logger = GwLogger(logger_name, min_log_level, str(log_suffix))
        values = {10: 0, 20: 0, 30: 1, 40: 2}
        global_vars.logger.min_message_level = values.get(int(min_log_level), 0)


def log_debug(text=None, context_name=None, parameter=None, logger_file=True, stack_level_increase=0, tab_name=None):
    """ Write debug message into QGIS Log Messages Panel """

    msg = _qgis_log_message(text, 0, context_name, parameter, tab_name)
    if global_vars.logger and logger_file:
        global_vars.logger.debug(msg, stack_level_increase=stack_level_increase)


def log_info(text=None, context_name=None, parameter=None, logger_file=True, stack_level_increase=0, tab_name=None):
    """ Write information message into QGIS Log Messages Panel """

    msg = _qgis_log_message(text, 0, context_name, parameter, tab_name)
    if global_vars.logger and logger_file:
        global_vars.logger.info(msg, stack_level_increase=stack_level_increase)


def log_warning(text=None, context_name=None, parameter=None, logger_file=True, stack_level_increase=0, tab_name=None):
    """ Write warning message into QGIS Log Messages Panel """

    msg = _qgis_log_message(text, 1, context_name, parameter, tab_name)
    if global_vars.logger and logger_file:
        global_vars.logger.warning(msg, stack_level_increase=stack_level_increase)


def log_error(text=None, context_name=None, parameter=None, logger_file=True, stack_level_increase=0, tab_name=None):
    """ Write error message into QGIS Log Messages Panel """

    msg = _qgis_log_message(text, 2, context_name, parameter, tab_name)
    if global_vars.logger and logger_file:
        global_vars.logger.error(msg, stack_level_increase=stack_level_increase)


def log_db(text=None, color="black", bold='', message_level=0, logger_file=True, stack_level_increase=0):
    """ Write information message into QGIS Log Messages Panel (tab DB) """

    if type(text) is dict:
        text = json.dumps(text)
    msg = f'<font color="{color}"><{bold}>{text}</font>'
    limit = 200
    if global_vars.logger and global_vars.logger.db_limit_characters:
        limit = global_vars.logger.db_limit_characters
    msg = (msg[:limit] + '...') if len(msg) > limit and bold == '' else msg

    # Check session parameter 'min_message_level' to know if we need to log message in QGIS Log Messages Panel
    if global_vars.logger and message_level >= global_vars.logger.min_message_level:
        QgsMessageLog.logMessage(msg, global_vars.logger.tab_db, message_level)

    # Log same message into logger file
    if global_vars.logger and logger_file:
        global_vars.logger.info(text, stack_level_increase=stack_level_increase)


def _qgis_log_message(text=None, message_level=0, context_name=None, parameter=None, tab_name=None):
    """
    Write message into QGIS Log Messages Panel with selected message level
        :param message_level: {INFO = 0, WARNING = 1, CRITICAL = 2, SUCCESS = 3, NONE = 4}
    """

    msg = None
    if text:
        msg = tools_qt.tr(text, context_name)
        if parameter:
            msg += f": {parameter}"

    if tab_name is None:
        tab_name = global_vars.logger.tab_python

    # Check session parameter 'min_message_level' to know if we need to log message in QGIS Log Messages Panel
    if global_vars.logger and message_level >= global_vars.logger.min_message_level:
        QgsMessageLog.logMessage(msg, tab_name, message_level)

    return msg

