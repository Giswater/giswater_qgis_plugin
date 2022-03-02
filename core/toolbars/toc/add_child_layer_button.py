"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import json

from functools import partial

from qgis.core import QgsProject
from qgis.PyQt.QtCore import QPoint, Qt
from qgis.PyQt.QtWidgets import QAction, QMenu
from qgis.PyQt.QtGui import QCursor

from ..dialog import GwAction
from ...utils import tools_gw
from ....lib import tools_qgis, tools_db


class GwAddChildLayerButton(GwAction):
    """ Button 306: Add child layer """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)


    def clicked_event(self):

        self._add_child_layer()


    # region private functions

    def _add_child_layer(self):

        # Create main menu and get cursor click position
        main_menu = QMenu()
        cursor = QCursor()
        x = cursor.pos().x()
        y = cursor.pos().y()
        click_point = QPoint(x + 5, y + 5)

        # Get load layers
        layer_list = []

        for layer in QgsProject.instance().mapLayers().values():
            layer_list.append(tools_qgis.get_layer_source_table_name(layer))

        body = tools_gw.create_body()
        json_result = tools_gw.execute_procedure('gw_fct_getaddlayervalues', body)
        if not json_result or json_result['status'] == 'Failed':
            return False

        dict_menu = {}

        for field in json_result['body']['data']['fields']:
            if field['context'] is not None:
                context = json.loads(field['context'])
                if 'level_1' in context and context['level_1'] not in dict_menu:
                    menu_level_1 = main_menu.addMenu(f"{context['level_1']}")
                    dict_menu[context['level_1']] = menu_level_1
                if 'level_2' in context and f"{context['level_1']}_{context['level_2']}" not in dict_menu:
                    menu_level_2 = dict_menu[context['level_1']].addMenu(f"{context['level_2']}")
                    dict_menu[f"{context['level_1']}_{context['level_2']}"] = menu_level_2
                if 'level_3' in context and f"{context['level_1']}_{context['level_2']}_{context['level_3']}" not in dict_menu:
                    menu_level_3 = dict_menu[f"{context['level_1']}_{context['level_2']}"].addMenu(f"{context['level_3']}")
                    dict_menu[f"{context['level_1']}_{context['level_2']}_{context['level_3']}"] = menu_level_3

                alias = field['layerName'] if field['layerName'] is not None else field['tableName']
                if 'level_3' in context:
                    if f"{context['level_1']}_{context['level_2']}_{context['level_3']}_load_all" not in dict_menu:
                        action = QAction("Load all", dict_menu[f"{context['level_1']}_{context['level_2']}_{context['level_3']}"],checkable=True)
                        action.triggered.connect(partial(self._manage_load_all, fields=json_result['body']['data']['fields'],
                        group=context['level_1'], sub_group=context['level_2'], sub_sub_group=context['level_3']))
                        dict_menu[f"{context['level_1']}_{context['level_2']}_{context['level_3']}"].addAction(action)
                        dict_menu[f"{context['level_1']}_{context['level_2']}_{context['level_3']}_load_all"] = True
                    action = QAction(alias, dict_menu[f"{context['level_1']}_{context['level_2']}_{context['level_3']}"],checkable=True)
                    dict_menu[f"{context['level_1']}_{context['level_2']}_{context['level_3']}"].addAction(action)
                else:
                    if f"{context['level_1']}_{context['level_2']}_load_all" not in dict_menu:
                        action = QAction("Load all", dict_menu[f"{context['level_1']}_{context['level_2']}"],checkable=True)
                        action.triggered.connect(partial(self._manage_load_all, fields=json_result['body']['data']['fields'],
                                                         group=context['level_1'], sub_group=context['level_2']))
                        dict_menu[f"{context['level_1']}_{context['level_2']}"].addAction(action)
                        dict_menu[f"{context['level_1']}_{context['level_2']}_load_all"] = True
                    action = QAction(alias, dict_menu[f"{context['level_1']}_{context['level_2']}"],checkable=True)
                    dict_menu[f"{context['level_1']}_{context['level_2']}"].addAction(action)

                if f"{field['tableName']}" in layer_list:
                    action.setChecked(True)

                layer_name = field['tableName']
                if field['geomField'] == "None":
                    the_geom = None
                else:
                    the_geom = field['geomField']
                geom_field = field['tableId'].replace(" ", "")
                style_id = field['style_id']
                group = context['level_1']
                sub_group = context['level_2']
                action.triggered.connect(partial(self._check_action_ischecked, layer_name, the_geom, geom_field,
                                                 group, sub_group, style_id, alias))

        main_menu.exec_(click_point)


    def _manage_load_all(self, fields, group, sub_group, sub_sub_group=None):

        for field in fields:
            if field['context'] is not None:
                context = json.loads(field['context'])
                if ('level_3' in context and context['level_3'] == sub_sub_group) or \
                   (sub_sub_group is None and context['level_1'] == group and context['level_2'] == sub_group):
                    layer_name = field['tableName']
                    if field['geomField'] == "None":
                        the_geom = None
                    else:
                        the_geom = field['geomField']
                    geom_field = field['tableId'].replace(" ", "")
                    style_id = field['style_id']
                    group = context['level_1']
                    sub_group = context['level_2']

                    layer = tools_qgis.get_layer_by_tablename(layer_name)
                    if layer is None:
                        tools_gw.add_layer_database(layer_name, the_geom, geom_field, group, sub_group, style_id, field['layerName'])

    def _check_action_ischecked(self, tablename, the_geom=None, field_id=None, group=None,
                                sub_group=None, style_id=None, alias=None, is_checked=None):
        """ Control if user check or uncheck action menu, then add or remove layer from toc
        :param tablename: Postgres table name (String)
        :param the_geom: Geometry field of the table (String)
        :param field_id: Field id of the table (String)
        :param child_layers: List of layers (StringList)
        :param group: Name of the group that will be created in the toc (String)
        :param style_id: Id of the style we want to load (integer or String)
        :param is_checked: This parameter is sent by the action itself with the trigger (Bool)
        """
        if is_checked:
                layer = tools_qgis.get_layer_by_tablename(tablename)
                if layer is None:
                    tools_gw.add_layer_database(tablename, the_geom, field_id, group, sub_group, style_id, alias)
        else:
            layer = tools_qgis.get_layer_by_tablename(tablename)
            if layer is not None:
                tools_qgis.remove_layer_from_toc(tablename, group, sub_group)

    # endregion
