# -*- coding: utf-8 -*-


class ManAddfieldsParameter():
    """ Class to serialize table 'man_addfields_parameter' """
    
    def __init__(self, row):
        """ Class constructor """
        self.id = row['id']
        self.param_name = row['param_name']
        self.featurecat_id = row['featurecat_id']
        self.is_mandatory = row['is_mandatory']
        self.data_type = row['data_type']
        self.field_length = row['field_length']
        self.num_decimals = row['num_decimals']
        self.form_label = row['form_label']
        self.form_widget = row['form_widget']
        self.widget = None

