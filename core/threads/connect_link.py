"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from .task import GwTask
from ...lib import tools_qgis
from ..utils import tools_gw


class GwConnectLink(GwTask):

    def __init__(self, description, connect_link_class, element_type, layer):

        super().__init__(description)
        self.connect_link_class = connect_link_class
        self.element_type = element_type
        self.layer = layer

    def run(self):

        super().run()

        try:
            result = self._link_selected_features(self.element_type, self.layer)
            self.connect_link_class.cancel_map_tool()
            return result
        except KeyError as e:
            self.exception = e
            return False


    def finished(self, result):
        super().finished(result)
        self.connect_link_class.manage_result(self.json_result, self.layer)


    def _link_selected_features(self, feature_type, layer):
        """ Link selected @feature_type to the pipe """

        # Get selected features from layers of selected @feature_type
        aux = "["
        field_id = feature_type + "_id"

        if layer.selectedFeatureCount() > 0:
            # Get selected features of the layer
            features = layer.selectedFeatures()
            for feature in features:
                feature_id = feature.attribute(field_id)
                aux += str(feature_id) + ", "
            list_feature_id = aux[:-2] + "]"
            feature_id = f'"id":"{list_feature_id}"'
            extras = f'"feature_type":"{feature_type.upper()}"'
            body = tools_gw.create_body(feature=feature_id, extras=extras)
            # Execute SQL function and show result to the user
            self.json_result = tools_gw.execute_procedure('gw_fct_setlinktonetwork', body)
            return True

        return False
