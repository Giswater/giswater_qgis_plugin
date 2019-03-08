from builtins import object
# -*- coding: utf-8 -*-


class SysFeatureCat(object):
    """ Class to serialize table 'sys_feature_cat' """
    
    def __init__(self, id_, type_, orderby, tablename, shortcut_key, layername=None):
        """ Class constructor """
        self.id = id_
        self.type = type_
        self.orderby = orderby
        self.tablename = tablename
        self.shortcut_key = shortcut_key
        self.layername = layername

