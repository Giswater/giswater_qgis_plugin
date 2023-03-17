"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-

from ..dialog import GwAction
from ...utils import tools_gw
from ....lib import tools_qgis, tools_db, tools_os
from .... import global_vars


class GwEpaWorldButton(GwAction):
    """ Button 308: Switch EPA world """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.action.setCheckable(True)
        # Apply filter if epa world active
        epa_world_active = tools_os.set_boolean(tools_gw.get_config_parser("epa_world", "epa_world_active", 'user', 'session'), False)

        set_epa_world = epa_world_active
        self._set_epa_world(set_epa_world)


    def clicked_event(self):

        self._switch_epa_world()


    # region private functions


    def _switch_epa_world(self):
        # Check world type
        epa_world_active = tools_os.set_boolean(tools_gw.get_config_parser("epa_world", "epa_world_active", 'user', 'session'))

        # Apply filters
        set_epa_world = not epa_world_active
        self._set_epa_world(set_epa_world)

        tools_gw.set_config_parser("epa_world", "epa_world_active", str(not epa_world_active), 'user', 'session')


    def _set_epa_world(self, set_epa_world):
        # Get layers
        arc_layers, node_layers, connec_layers, gully_layers, link_layers = self._get_layers()

        if not set_epa_world:
            # disable filters
            for layer in arc_layers + node_layers + connec_layers + gully_layers + link_layers:
                layer.setSubsetString(None)
        else:
            sectors = self._get_sectors()
            inp_options_networkmode = tools_gw.get_config_value('inp_options_networkmode')
            sql = f"is_operative = true AND epa_type != 'UNDEFINED' AND sector_id IN ({sectors})"
            # arc and node
            for layer in arc_layers + node_layers:
                layer.setSubsetString(sql)

            if global_vars.project_type == 'ws':
                # ws connec
                for layer in connec_layers:
                    if inp_options_networkmode == 4:
                        layer.setSubsetString(sql)
                    else:
                        layer.setSubsetString("FALSE")

                # ws link
                for layer in link_layers:
                    if inp_options_networkmode == 4:
                        layer.setSubsetString(sql.replace('is_operative = true AND epa_type != \'UNDEFINED\' AND ', ''))
                    else:
                        layer.setSubsetString("FALSE")

            elif global_vars.project_type == 'ud':
                # ud connec
                for layer in connec_layers:
                    layer.setSubsetString("FALSE")

                # ud gully
                for layer in gully_layers:
                    if inp_options_networkmode == 2:
                        layer.setSubsetString(sql)
                    else:
                        layer.setSubsetString("FALSE")

                # ud link
                for layer in link_layers:
                    layer.setSubsetString("FALSE")

        # Set checked
        if set_epa_world:
            self.action.setChecked(True)
        else:
            self.action.setChecked(False)


    def _get_layers(self):

        arc_layers = tools_gw.get_layers_from_feature_type('arc')
        node_layers = tools_gw.get_layers_from_feature_type('node')
        connec_layers = tools_gw.get_layers_from_feature_type('connec')
        gully_layers = tools_gw.get_layers_from_feature_type('gully')
        link_layers = tools_gw.get_layers_from_feature_type('link')

        return arc_layers, node_layers, connec_layers, gully_layers, link_layers


    def _get_sectors(self):
        sectors = ""

        # get selected selectors
        sql = f'SELECT sector_id FROM selector_sector WHERE cur_user = current_user'
        rows = tools_db.get_rows(sql)
        if rows:
            sectors = ", ".join(str(x[0]) for x in rows)

        return sectors

    # endregion
