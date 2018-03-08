# -*- coding: utf-8 -*-
import logging
import inspect
import os
import time


class Logger():
    
    def __init__(self, controller, log_name, log_level, log_suffix, 
                 folder_has_tstamp=False, file_has_tstamp=True, remove_previous=False): 
        """ Class constructor """
        
        # Create logger
        self.controller = controller
        self.logger_file = logging.getLogger(log_name)
        self.logger_file.setLevel(log_level)
        
        # Define log folder
        main_folder = os.path.join(os.path.dirname(__file__), os.pardir)
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
        filepath+= ".log"
        
        self.log_folder = log_folder
        self.controller.log_info(filepath, logger_file=False)          
        if remove_previous and os.path.exists(filepath):
            os.remove(filepath)
        
        # Define format
        log_format = '%(asctime)s [%(levelname)s] - %(message)s\n'
        log_date = '%d/%m/%Y %H:%M:%S'
        formatter = logging.Formatter(log_format, log_date)
        
        # Create file handler
        fh = logging.FileHandler(filepath) 
        fh.setFormatter(formatter)
        self.logger_file.addHandler(fh)    
        
        # Initialize number of errors in current process
        self.num_errors = 0
                
                
    def log(self, msg=None, log_level=logging.INFO, stack_level=2):
        """ Logger message into logger file with selected level """
        
        try:
            module_path = inspect.stack()[stack_level][1]  
            function_line = inspect.stack()[stack_level][2]
            function_name = inspect.stack()[stack_level][3]
            header = "{" + module_path + " | Line " + str(function_line) + " (" + str(function_name) + ")}"        
            text = header
            if msg:
                text+= "\n" + str(msg)    
            self.logger_file.log(log_level, text)
        except Exception as e:
            self.controller.log_warning("Error logging: " + str(e), logger_file=False)
        
    
    def debug(self, msg=None, stack_level=2, stack_level_increase=0):
        """ Logger message into logger file with level = DEBUG """
        self.log(msg, logging.DEBUG, stack_level + stack_level_increase + 1)
        
        
    def info(self, msg=None, stack_level=2, stack_level_increase=0):
        """ Logger message into logger file with level = INFO """
        self.log(msg, logging.INFO, stack_level + stack_level_increase + 1)
        
            
    def warning(self, msg=None, stack_level=2, stack_level_increase=0, sum_error=True):
        """ Logger message into logger file with level = WARNING """
        self.log(msg, logging.WARNING, stack_level + stack_level_increase + 1)
        if sum_error:
            self.num_errors+= 1
        
                