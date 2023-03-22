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


def _get_sectors():
    sectors = "NULL"

    # get selected selectors
    sql = f'SELECT sector_id FROM selector_sector WHERE cur_user = current_user'
    rows = tools_db.get_rows(sql)
    if rows:
        sectors = ", ".join(str(x[0]) for x in rows)

    return sectors


def _get_layers():

    arc_layers = tools_gw.get_layers_from_feature_type('arc')
    node_layers = tools_gw.get_layers_from_feature_type('node')
    connec_layers = tools_gw.get_layers_from_feature_type('connec')
    gully_layers = tools_gw.get_layers_from_feature_type('gully')
    link_layers = tools_gw.get_layers_from_feature_type('link')

    return arc_layers, node_layers, connec_layers, gully_layers, link_layers


def set_epa_world(_set_epa_world=None):
    # Get layers
    arc_layers, node_layers, connec_layers, gully_layers, link_layers = _get_layers()

    # Get set_epa_world from config
    if _set_epa_world is None:
        _set_epa_world = tools_os.set_boolean(tools_gw.get_config_parser("epa_world", "epa_world_active", 'user', 'session'), False)

    if not _set_epa_world:
        # disable filters
        for layer in arc_layers + node_layers + connec_layers + gully_layers + link_layers:
            layer.setSubsetString(None)
    else:
        sectors = _get_sectors()
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

    return _set_epa_world


class GwEpaWorldButton(GwAction):
    """ Button 308: Switch EPA world """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.action.setCheckable(True)
        # Apply filter if epa world active
        checked = set_epa_world()
        # Set action checked
        self._action_set_checked(checked)


    def clicked_event(self):

        self._switch_epa_world()


    # region private functions


    def _switch_epa_world(self):
        # Check world type
        epa_world_active = tools_os.set_boolean(tools_gw.get_config_parser("epa_world", "epa_world_active", 'user', 'session'))

        # Apply filters
        _set_epa_world = not epa_world_active
        set_epa_world(_set_epa_world)

        tools_gw.set_config_parser("epa_world", "epa_world_active", str(not epa_world_active), 'user', 'session')

        # Set action checked
        self._action_set_checked(_set_epa_world)

        # Show message
        if _set_epa_world:
            msg = "Epa world activated"
        else:
            msg = "Epa world deactivated"
        tools_qgis.show_info(msg)


    def _action_set_checked(self, checked):
        # Set checked
        self.action.setChecked(checked)

    # endregion
