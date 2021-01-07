"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-


class GwSysFeatureCat(object):
    """ Class to serialize table 'cat_feature' """

    def __init__(self, id_, system_id, feature_type, shortcut_key, parent_layer, child_layer):

        self.id = id_
        self.system_id = system_id
        self.feature_type = feature_type
        self.shortcut_key = shortcut_key
        self.parent_layer = parent_layer
        self.child_layer = child_layer


