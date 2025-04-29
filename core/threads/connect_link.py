"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from .task import GwTask
from ..utils import tools_gw
from ...libs import tools_log, tools_qt


class GwConnectLink(GwTask):

    def __init__(self, description, connect_link_class, element_type, selected_arc=None):

        super().__init__(description)
        self.connect_link_class = connect_link_class
        self.element_type = element_type
        self.selected_arc = selected_arc

    def run(self):

        super().run()

        try:
            tools_log.log_info(
                f"Task 'Connect link' execute function 'def _link_selected_features' with parameters: "
                f"'{self.element_type}', 'selected_arc={self.selected_arc}'"
            )
            result = self._link_selected_features(self.element_type, self.selected_arc)
            self.connect_link_class.cancel_map_tool()
            return result
        except KeyError as e:
            self.exception = e
            return False

    def finished(self, result):
        super().finished(result)
        tools_log.log_info(
            f"Task 'Connect link' execute function 'def manage_result' from 'connect_link_buttom.py' with parameters: "
            f"'{self.element_type}'"
        )
        self.connect_link_class.manage_result(self.json_result)

    def _link_selected_features(self, feature_type, selected_arc=None):
        """ Link selected @feature_type to the pipe """

        # Get selected features from layers of selected @feature_type
        feature_id = f'"id":"{self.connect_link_class.ids}"'

        extras = f'"feature_type": "{feature_type.upper()}", \
                   "pipeDiameter": "{self.connect_link_class.pipe_diameter.text()}", \
                   "maxDistance": "{self.connect_link_class.max_distance.text()}", \
                   "linkcatId": "{tools_qt.get_combo_value(self.connect_link_class.dlg_connect_link, "tab_none_linkcat")}"'

        if selected_arc:
            extras += f', "forcedArcs":["{selected_arc}"]'

        body = tools_gw.create_body(feature=feature_id, extras=extras)

        # Execute SQL function and show result to the user
        tools_log.log_info(
            f"Task 'Connect link' execute procedure 'gw_fct_setlinktonetwork' with parameters: \
            '{body}', 'aux_conn={self.aux_conn}', 'is_thread=True'"
        )
        self.json_result = tools_gw.execute_procedure('gw_fct_setlinktonetwork', body, aux_conn=self.aux_conn, is_thread=True)

        return self.json_result is not None and self.json_result.get('status') == 'Accepted'

