"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsSymbol, QgsRendererCategory, QgsCategorizedSymbolRenderer, QgsSimpleFillSymbolLayer

import random
from collections import OrderedDict

from ..models.sys_feature_cat import SysFeatureCat


class PgMan:

    def __init__(self, controller):
        """ Class to manage layers. Refactor code from giswater.py """

        self.controller = controller


    def create_body(self, form='', feature='', filter_fields='', extras=None):
        """ Create and return parameters as body to functions"""

        client = f'$${{"client":{{"device":4, "infoType":1, "lang":"ES"}}, '
        form = f'"form":{{{form}}}, '
        feature = f'"feature":{{{feature}}}, '
        filter_fields = f'"filterFields":{{{filter_fields}}}'
        page_info = f'"pageInfo":{{}}'
        data = f'"data":{{{filter_fields}, {page_info}'
        if extras is not None:
            data += ', ' + extras
        data += f'}}}}$$'
        body = "" + client + form + feature + data

        return body


    def set_style_mapzones(self):

        extras = f'"mapzones":""'
        body = self.create_body(extras=extras)

        # self.controller.log_info(f"SELECT gw_fct_getstylemapzones ({body})")
        json_return = self.controller.get_json('gw_fct_getstylemapzones', body)
        if not json_return:
            return False

        for mapzone in json_return['body']['data']['mapzones']:

            # self.controller.log_info(f"Mapzone: ({mapzone})")
            # Loop for each mapzone returned on json
            lyr = self.controller.get_layer_by_tablename(mapzone['layer'])
            categories = []
            status = mapzone['status']
            if status == 'Disable':
                pass

            if lyr:
                # Loop for each id returned on json
                for id in mapzone['values']:
                    # initialize the default symbol for this geometry type
                    symbol = QgsSymbol.defaultSymbol(lyr.geometryType())
                    symbol.setOpacity(float(mapzone['opacity']))

                    # Setting simp
                    R = random.randint(0, 255)
                    G = random.randint(0, 255)
                    B = random.randint(0, 255)
                    if status == 'Stylesheet':
                        try:
                            R = id['stylesheet']['color'][0]
                            G = id['stylesheet']['color'][1]
                            B = id['stylesheet']['color'][2]
                        except TypeError:
                            R = random.randint(0, 255)
                            G = random.randint(0, 255)
                            B = random.randint(0, 255)

                    elif status == 'Random':
                        R = random.randint(0, 255)
                        G = random.randint(0, 255)
                        B = random.randint(0, 255)

                    # Setting sytle
                    layer_style = {'color': '{}, {}, {}'.format(int(R), int(G), int(B))}
                    symbol_layer = QgsSimpleFillSymbolLayer.create(layer_style)

                    if symbol_layer is not None:
                        symbol.changeSymbolLayer(0, symbol_layer)
                    category = QgsRendererCategory(id['id'], symbol, str(id['id']))
                    categories.append(category)

                    # apply symbol to layer renderer
                    lyr.setRenderer(QgsCategorizedSymbolRenderer(mapzone['idname'], categories))

                    # repaint layer
                    lyr.triggerRepaint()


    def manage_feature_cat(self):
        """ Manage records from table 'cat_feature' """

        # Dictionary to keep every record of table 'cat_feature'
        # Key: field tablename
        # Value: Object of the class SysFeatureCat
        feature_cat = {}
        sql = ("SELECT cat_feature.* FROM cat_feature "
                   "WHERE active IS TRUE ORDER BY id")
        rows = self.controller.get_rows(sql)
        
        # If rows ara none, probably the conection has broken so try again
        if not rows:
            rows = self.controller.get_rows(sql)
            if not rows:
                return None
        
        msg = "Field child_layer of id: "
        for row in rows:
            tablename = row['child_layer']
            if not tablename:
                msg += f"{row['id']}, "
                continue
            elem = SysFeatureCat(row['id'], row['system_id'], row['feature_type'], row['shortcut_key'],
                                 row['parent_layer'], row['child_layer'])
            feature_cat[tablename] = elem

        feature_cat = OrderedDict(sorted(feature_cat.items(), key=lambda t: t[0]))

        if msg != "Field child_layer of id: ":
            self.controller.show_warning(msg + "is not defined in table cat_feature")

        return feature_cat

