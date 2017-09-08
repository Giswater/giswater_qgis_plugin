# -*- coding: utf-8 -*-


class ConfigParamSystem():
    ''' Object mapping of a record in the table 'config_param_system' '''
    
    def __init__(self, parameter, value_, context):
        """ Constructor class """
        self.parameter = parameter
        self.value = value_
        self.context = context
              
        