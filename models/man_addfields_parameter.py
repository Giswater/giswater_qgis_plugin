# -*- coding: utf-8 -*-


class ManAddfieldsParameter():
    """ Class to serialize table 'man_addfields_parameter' """
    
    def __init__(self, row):
        """ Class constructor """
        self.id = row['id']
        self.param_name = row['param_name']
        self.cat_feature_id = row['cat_feature_id']
        self.is_mandatory = row['is_mandatory']
        self.datatype_id = row['datatype_id']
        self.field_length = row['field_length']
        self.num_decimals = row['num_decimals']
        self.form_label = row['form_label']
        self.widgettype_id = row['widgettype_id']
        self.dv_table = row['dv_table']
        self.dv_key_column = row['dv_key_column']
        self.sql_text = row['sql_text']
        self.widget = None
        self.value_param = None

