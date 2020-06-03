"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsSimpleFillSymbolLayer, QgsRendererCategory, QgsCategorizedSymbolRenderer

import os
import random
from functools import partial

from .. import utils_giswater
from ..ui_manager import Multirow_selector, SelectorUi
from .api_search import ApiSearch
from .api_parent import ApiParent


class Basic(ApiParent):

    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control toolbar 'basic' """

        self.minor_version = "3.0"
        ApiParent.__init__(self, iface, settings, controller, plugin_dir)
        self.login_file = os.path.join(self.plugin_dir, 'config', 'login.auth')
        self.logged = False
        self.api_search = None


    def set_giswater(self, giswater):
        self.giswater = giswater


    def set_project_type(self, project_type):
        self.project_type = project_type


    def basic_filter_selectors(self):
        """ Button 142: Filter selector """

        selector_values = f'{{"exploitation": {{"ids":"None", "filter":""}}, "state":{{"ids":"None", "filter":""}}, "hydrometer":{{"ids":"None", "filter":""}}}}'
        self.dlg_selector = SelectorUi()
        self.load_settings(self.dlg_selector)
        self.dlg_selector.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_selector))
        self.dlg_selector.rejected.connect(partial(self.save_settings, self.dlg_selector))
        self.get_selector(self.dlg_selector, selector_values)
        self.open_dialog(self.dlg_selector, dlg_name='selector', maximize_button=False)
		
        # repaint mapzones and refresh canvas
        self.set_mapzones_style()
        self.refresh_map_canvas()


    def set_mapzones_style(self):

        row = self.controller.get_config('utils_grafanalytics_dynamic_symbology', 'value', 'config_param_system')
        if row and row[0].lower() == 'true':
            extras = f'"mapzones":""'
            body = self.create_body(extras=extras)
            dbreturn = self.controller.get_json('gw_fct_getmapzonestyle', body, log_sql=True)
            if not dbreturn: return False

            for mapzone in dbreturn['body']['data']['mapzones']:

                #loop for each mapzone returned on json
                lyr = self.controller.get_layer_by_tablename(mapzone['layer'])
                categories = []

                if lyr:
                    #loop for each id returned on json
                    for id in mapzone['values']:
                        # initialize the default symbol for this geometry type
                        symbol = QgsSymbol.defaultSymbol(lyr.geometryType())
                        symbol.setOpacity(float(mapzone['opacity']))

                        #setting color
                        try:
                            R = id['stylesheet']['color'][0]
                            G = id['stylesheet']['color'][1]
                            B = id['stylesheet']['color'][2]
                        except TypeError:
                            R = random.randint(0, 255)
                            G = random.randint(0, 255)
                            B = random.randint(0, 255)

                        #setting sytle
                        layer_style = {}
                        layer_style['color'] = '{}, {}, {}'.format(int(R), int(G), int(B))
                        symbolLayer = QgsSimpleFillSymbolLayer.create(layer_style)

                        if symbolLayer is not None:
                            symbol.changeSymbolLayer(0, symbolLayer)
                        category = QgsRendererCategory(id['id'], symbol, str(id['id']))
                        categories.append(category)

                        # apply symbol to layer renderer
                        lyr.setRenderer(QgsCategorizedSymbolRenderer(mapzone['idname'], categories))

                        # repaint layer
                        lyr.triggerRepaint()


    def basic_api_search(self):
        """ Button 143: ApiSearch """

        if self.api_search is None:
            self.api_search = ApiSearch(self.iface, self.settings, self.controller, self.plugin_dir)

        self.api_search.api_search()

