# -*- coding: utf-8 -*-


class SysFeatureCat():
    ''' Class to serialize table 'sys_feature_cat' '''
    
    def __init__(self, id, type, orderby, tablename, shortcut_key, layername = None ):
        """ Class constructor """
        self.id = id
        self.type = type
        self.orderby = orderby
        self.tablename = tablename
        self.shortcut_key = shortcut_key
        self.layername =  None

