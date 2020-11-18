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

from .. import global_vars

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
        self.controller.log_info(f"Log file: {filepath}", logger_file=False)
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
            self.controller.log_warning("Error logging: " + str(e), logger_file=False)


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
