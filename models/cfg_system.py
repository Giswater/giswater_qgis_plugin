class CfgSystem(object):
    """ Class to serialize table 'config_param_system' """

    def __init__(self, parameter, value, data_type, context, descript, label):

        self.parameter = parameter
        self.value = value
        self.data_type = data_type
        self.context = context
        self.descript = descript
        self.label = label