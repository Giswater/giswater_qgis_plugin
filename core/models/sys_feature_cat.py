# -*- coding: utf-8 -*-


class SysFeatureCat(object):
    """ Class to serialize table 'cat_feature' """

    def __init__(self, id_, system_id, feature_type, shortcut_key, parent_layer, child_layer):

        self.id = id_
        self.system_id = system_id
        self.feature_type = feature_type
        self.shortcut_key = shortcut_key
        self.parent_layer = parent_layer
        self.child_layer = child_layer
    

