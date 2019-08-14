# -*- coding: utf-8 -*-


class SysFeatureCat(object):
    """ Class to serialize table 'sys_feature_cat' """

    def __init__(self, id_, system_id, feature_type, type_, shortcut_key, parent_layer, child_layer):

        self.id = id_
        self.system_id = system_id
        self.feature_type = feature_type
        self.type = type_
        self.shortcut_key = shortcut_key
        self.parent_layer = parent_layer
        self.child_layer = child_layer
    

