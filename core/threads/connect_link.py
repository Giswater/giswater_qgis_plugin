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
        self.json_result = None

    def run(self):

        super().run()

        try:
            msg = "Task 'Connect link' execute function '{0}' with parameters: '{1}', '{2}'"
            msg_params = ("_link_selected_features", self.element_type, f"selected_arc={self.selected_arc}",)
            tools_log.log_info(msg, msg_params=msg_params)
            result = self._link_selected_features(self.element_type, self.selected_arc)
            self.connect_link_class.cancel_map_tool()
            return result
        except KeyError as e:
            self.exception = e
            return False

    def finished(self, result):
        super().finished(result)
        msg = "Task 'Connect link' execute function '{0}' from '{1}' with parameters: '{2}'"
        msg_params = ("manage_result", "connect_link_buttom.py", self.element_type,)
        tools_log.log_info(msg, msg_params=msg_params)
        self.connect_link_class.manage_result(self.json_result)

    def _link_selected_features(self, feature_type, selected_arc=None):
        """ Link selected @feature_type to the pipe """

        # Get selected features from layers of selected @feature_type
        feature_id = f'"id":{self.connect_link_class.ids}'

        pipe_diameter = 'null' if not self.connect_link_class.pipe_diameter.text() else f'"{self.connect_link_class.pipe_diameter.text()}"'
        max_distance = 'null' if not self.connect_link_class.max_distance.text() else f'"{self.connect_link_class.max_distance.text()}"'
        linkcat_id = tools_qt.get_combo_value(self.connect_link_class.dlg_connect_link, "tab_none_linkcat")

        extras = (
            f'"feature_type":"{feature_type.upper()}",'
            f'"pipeDiameter":{pipe_diameter},'
            f'"maxDistance":{max_distance},'
            f'"linkcatId":"{linkcat_id}"'
        )

        if selected_arc:
            extras += f', "forcedArcs":["{selected_arc}"]'

        body = tools_gw.create_body(feature=feature_id, extras=extras)

        # Execute SQL function and show result to the user
        msg = "Task 'Connect link' execute procedure '{0}' with parameters: '{1}', '{2}', '{3}'"
        msg_params = ("gw_fct_setlinktonetwork", body, f"aux_conn={self.aux_conn}", "is_thread=True",)
        tools_log.log_info(msg, msg_params=msg_params)
        self.json_result = tools_gw.execute_procedure('gw_fct_setlinktonetwork', body, aux_conn=self.aux_conn, is_thread=True)

        return self.json_result is not None and self.json_result.get('status') == 'Accepted'

