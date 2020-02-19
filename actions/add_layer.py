"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import json
from collections import OrderedDict

from qgis.core import QgsCategorizedSymbolRenderer, QgsDataSourceUri, QgsFeature, QgsField, QgsGeometry, QgsMarkerSymbol,\
    QgsLayerTreeLayer, QgsLineSymbol, QgsProject, QgsRectangle, QgsRendererCategory, QgsSimpleFillSymbolLayer, QgsSymbol,\
    QgsVectorLayer, QgsVectorLayerExporter

from qgis.PyQt.QtCore import QVariant
from qgis.PyQt.QtGui import QColor
from qgis.PyQt.QtWidgets import QTabWidget

import os
from random import randrange
from .. import utils_giswater


class AddLayer(object):

    def __init__(self, iface, settings, controller, plugin_dir):
        # Initialize instance attributes
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.settings = settings
        self.controller = controller
        self.plugin_dir = plugin_dir
        self.dao = self.controller.dao
        self.schema_name = self.controller.schema_name
        self.project_type = None
        self.uri = None


    def set_uri(self):

        self.uri = QgsDataSourceUri()
        self.uri.setConnection(self.controller.credentials['host'], self.controller.credentials['port'],
                          self.controller.credentials['db'], self.controller.credentials['user'],
                          self.controller.credentials['password'])
        return self.uri


    def manage_geometry(self, geometry):
        """ Get QgsGeometry and return as text
         :param geometry: (QgsGeometry)
         """
        geometry = geometry.asWkt().replace('Z (', ' (')
        geometry = geometry.replace(' 0)', ')')
        return geometry


    def from_dxf_to_toc(self, dxf_layer, dxf_output_filename):
        """  Read a dxf file and put result into TOC
        :param dxf_layer: (QgsVectorLayer)
        :param dxf_output_filename: Name of layer into TOC (string)
        :return: dxf_layer (QgsVectorLayer)
        """

        QgsProject.instance().addMapLayer(dxf_layer, False)
        root = QgsProject.instance().layerTreeRoot()
        my_group = root.findGroup(dxf_output_filename)
        if my_group is None:
            my_group = root.insertGroup(0, dxf_output_filename)
        my_group.insertLayer(0, dxf_layer)
        self.canvas.refreshAllLayers()
        return dxf_layer


    def export_layer_to_db(self, layer, crs):
        """ Export layer to postgres database
        :param layer: (QgsVectorLayer)
        :param crs: QgsVectorLayer.crs() (crs)
        """
        sql = f'DROP TABLE "{layer.name()}";'
        self.controller.execute_sql(sql, log_sql=True)

        schema_name = self.controller.credentials['schema'].replace('"', '')
        self.set_uri()
        self.uri.setDataSource(schema_name, layer.name(), None, "", layer.name())

        error = QgsVectorLayerExporter.exportLayer(layer, self.uri.uri(), self.controller.credentials['user'], crs, False)

        if error[0] != 0:
            self.controller.log_info(F"ERROR --> {error[1]}")


    def from_postgres_to_toc(self, tablename=None, the_geom="the_geom", field_id="id",  child_layers=None, group="GW Layers"):
        """ Put selected layer into TOC
        :param tablename: Postgres table name (string)
        :param the_geom: Geometry field of the table (string)
        :param field_id: Field id of the table (string)
        :param child_layers: List of layers (stringList)
        :param group: Name of the group that will be created in the toc (string)
        """
        self.set_uri()
        schema_name = self.controller.credentials['schema'].replace('"', '')
        if child_layers is not None:
            for layer in child_layers:
                if layer[0] != 'Load all':
                    self.uri.setDataSource(schema_name, f'{layer[0]}', the_geom, None, layer[1] + "_id")
                    vlayer = QgsVectorLayer(self.uri.uri(), f'{layer[0]}', "postgres")
                    self.check_for_group(vlayer, group)
        else:
            self.uri.setDataSource(schema_name, f'{tablename}', the_geom, None, field_id)
            vlayer = QgsVectorLayer(self.uri.uri(), f'{tablename}', 'postgres')
            self.check_for_group(vlayer, group)
        self.iface.mapCanvas().refresh()


    def check_for_group(self, layer, group=None):
        """ If the function receives a group name, check if it exists or not and put the layer in this group
        :param layer: (QgsVectorLayer)
        :param group: Name of the group that will be created in the toc (string)
        """

        if group is None:
            QgsProject.instance().addMapLayer(layer)
        else:
            QgsProject.instance().addMapLayer(layer, False)
            root = QgsProject.instance().layerTreeRoot()
            my_group = root.findGroup(group)
            if my_group is None:
                my_group = root.insertGroup(0, group)
            my_group.insertLayer(0, layer)


    def add_temp_layer(self, dialog, data, layer_name, force_tab=True, reset_text=True, tab_idx=1, del_old_layers=True, group='GW Temporal Layers'):
        """ Add QgsVectorLayer into TOC
        :param dialog:
        :param data:
        :param layer_name:
        :param force_tab:
        :param reset_text:
        :param tab_idx:
        :param del_old_layers:
        :param group:
        :return:
        """
        colors = {'rnd':QColor(randrange(0, 256), randrange(0, 256), randrange(0, 256))}
        text_result = None
        temp_layers_added = []
        if del_old_layers:
            self.delete_layer_from_toc(layer_name)
        srid = self.controller.plugin_settings_value('srid')
        for k, v in list(data.items()):
            if str(k) == 'setVisibleLayers':
                self.set_layers_visible(v)
            elif str(k) == "info":
                text_result = self.populate_info_text(dialog, data, force_tab, reset_text, tab_idx)
            elif k in ('point', 'line', 'polygon'):
                if 'values' in data[k]:
                    key = 'values'
                elif 'features' in data[k]:
                    key = 'features'
                else: continue
                counter = len(data[k][key])
                if counter > 0:
                    counter = len(data[k][key])
                    geometry_type = data[k]['geometryType']
                    geometry_type = "MultiLineString"
                    v_layer = QgsVectorLayer(f"{geometry_type}?crs=epsg:{srid}", layer_name, 'memory')
                    # TODO This if controls if the function already works with GeoJson or is still to be refactored
                    # once all are refactored the if should be: if 'feature' not in data [k]: continue
                    if key=='values':
                        self.populate_vlayer_old(v_layer, data, k, counter, group)
                    elif key=='features':
                        self.populate_vlayer(v_layer, data, k, counter, group)
                    if 'qmlPath' in data[k] and data[k]['qmlPath']:
                        qml_path = data[k]['qmlPath']
                        self.load_qml(v_layer, qml_path)
                    elif 'category_field' in data[k] and data[k]['category_field']:
                        cat_field = data[k]['category_field']
                        size = data[k]['size'] if 'size' in data[k] and data[k]['size'] else 2
                        self.categoryze_layer(v_layer, cat_field, size)
                    temp_layers_added.append(v_layer)
                    self.iface.setActiveLayer(v_layer)
        return {'text_result':text_result, 'temp_layers_added':temp_layers_added}


    def set_layers_visible(self, layers):
        for layer in layers:
            lyr = self.controller.get_layer_by_tablename(layer)
            if lyr:
                self.controller.set_layer_visible(lyr)


    def categoryze_layer(self, layer, cat_field, size):
        """
        :param layer: QgsVectorLayer to be categorized (QgsVectorLayer)
        :param cat_field: Field to categorize (string)
        :param size: Size of feature (integer)
        """

        # get unique values
        fields = layer.fields()
        fni = fields.indexOf(cat_field)
        unique_values = layer.dataProvider().uniqueValues(fni)
        categories = []
        color_values={'NEW':QColor(0, 255, 0), 'DUPLICATED':QColor(255, 0, 0), 'EXISTS':QColor(240, 150, 0)}
        for unique_value in unique_values:
            # initialize the default symbol for this geometry type
            symbol = QgsSymbol.defaultSymbol(layer.geometryType())
            if type(symbol) in (QgsLineSymbol, ):
                symbol.setWidth(size)
            else:
                symbol.setSize(size)

            # configure a symbol layer
            # layer_style = {}
            # layer_style['color'] = '%d, %d, %d' % (randrange(0, 256), randrange(0, 256), randrange(0, 256))
            # layer_style['color'] = '255,0,0'
            # layer_style['outline'] = '#000000'
            try:
                color = color_values.get(unique_value)
                symbol.setColor(color)
            except:
                color = QColor(randrange(0, 256), randrange(0, 256), randrange(0, 256))
                symbol.setColor(color)
            # layer_style['horizontal_anchor_point'] = '6'
            # layer_style['offset_map_unit_scale'] = '6'
            # layer_style['outline_width'] = '6'
            # layer_style['outline_width_map_unit_scale'] = '6'
            # layer_style['size'] = '6'
            # layer_style['size_map_unit_scale'] = '6'
            # layer_style['vertical_anchor_point'] = '6'

            # symbol_layer = QgsSimpleFillSymbolLayer.create(layer_style)
            # print(f"Symbollaye --> {symbol_layer}")
            # # replace default symbol layer with the configured one
            # if symbol_layer is not None:
            #     symbol.changeSymbolLayer(0, symbol_layer)

            # create renderer object
            category = QgsRendererCategory(unique_value, symbol, str(unique_value))
            # entry for the list of category items
            categories.append(category)

            # create renderer object
        renderer = QgsCategorizedSymbolRenderer(cat_field, categories)

        # assign the created renderer to the layer
        if renderer is not None:
            layer.setRenderer(renderer)

        layer.triggerRepaint()
        self.iface.layerTreeView().refreshLayerSymbology(layer.id())


    def populate_info_text(self, dialog, data, force_tab=True, reset_text=True, tab_idx=1):
        """ Populate txt_infolog QTextEdit widget
        :param data: Json
        :param force_tab: Force show tab (boolean)
        :param reset_text: Reset(or not) text for each iteration (boolean)
        :param tab_idx: index of tab to force (integer)
        :return:
        """
        change_tab = False
        text = utils_giswater.getWidgetText(dialog, dialog.txt_infolog, return_string_null=False)

        if reset_text:
            text = ""
        for item in data['info']['values']:
            if 'message' in item:
                if item['message'] is not None:
                    text += str(item['message']) + "\n"
                    if force_tab:
                        change_tab = True
                else:
                    text += "\n"

        utils_giswater.setWidgetText(dialog, 'txt_infolog', text+"\n")
        qtabwidget = dialog.findChild(QTabWidget,'mainTab')
        if change_tab and qtabwidget is not None:
            qtabwidget.setCurrentIndex(tab_idx)

        return text


    def populate_vlayer(self, virtual_layer, data, layer_type, counter, group='GW Temporal Layers'):
        """
        :param virtual_layer: Memory QgsVectorLayer (QgsVectorLayer)
        :param data: Json
        :param layer_type: point, line, polygon...(string)
        :param counter: control if json have values (integer)
        :param group: group to which we want to add the layer (string)
        :return:
        """

        prov = virtual_layer.dataProvider()
        # Enter editing mode
        virtual_layer.startEditing()
        # Add headers to layer
        features = {"features": [{"type": "Feature", "geometry": {"type": "MultiLineString", "coordinates": [
            [[419418.604538204, 4576587.39708993], [419386.547859086, 4576550.83543964],
             [419374.190982704, 4576537.05157141], [419367.780046771, 4576530.18263702],
             [419361.249111979, 4576523.43070146], [419344.130282415, 4576507.76685047],
             [419303.345688097, 4576472.0231901], [419292.65279446, 4576462.65227914],
             [419282.033900121, 4576453.20736893], [419279.688923425, 4576451.24438755],
             [419277.229947809, 4576449.40540494], [419274.664973193, 4576447.699421],
             [419272.006999448, 4576446.13543565], [419269.268026457, 4576444.72144882],
             [419266.460054099, 4576443.46346044], [419263.596082249, 4576442.36547049],
             [419259.820135538, 4576441.20111651], [419253.764178457, 4576440.37748757],
             [419246.771246665, 4576439.87949077], [419214.160399611, 4576441.6258473]]]},
                                  "properties": {"id": "1-10240C", "code": "10240C"}}, {"type": "Feature", "geometry": {
            "type": "MultiLineString",
            "coordinates": [[[418994.144073596, 4576900.55921535], [418930.758391086, 4576803.58709719]]]},
                                                                                        "properties": {"id": "1-10222C",
                                                                                                       "code": "10222C"}},
                                 {"type": "Feature", "geometry": {"type": "MultiLineString", "coordinates": [
                                     [[418983.262756564, 4576671.46316412], [418961.830990572, 4576566.31818666]]]},
                                  "properties": {"id": "1-9120C", "code": "9120C"}}, {"type": "Feature", "geometry": {
                "type": "MultiLineString",
                "coordinates": [[[419126.982364387, 4576642.01548638], [419097.993522268, 4576502.15151354]]]},
                                                                                      "properties": {"id": "1-10120C",
                                                                                                     "code": "10120C"}},
                                 {"type": "Feature", "geometry": {"type": "MultiLineString", "coordinates": [
                                     [[419132.991237241, 4576504.91449937], [419125.20742448, 4576464.07122522],
                                      [419124.804449792, 4576462.11030012], [419124.353642678, 4576460.16201852],
                                      [419123.855347086, 4576458.22722303], [419123.309906961, 4576456.30675628],
                                      [419122.71766625, 4576454.40146087], [419122.078968898, 4576452.51217944],
                                      [419121.394158853, 4576450.6397546], [419120.663580059, 4576448.78502896],
                                      [419119.887576465, 4576446.94884515], [419119.066492014, 4576445.13204579],
                                      [419118.200670655, 4576443.33547349], [419117.290456333, 4576441.55997087],
                                      [419116.336192994, 4576439.80638055], [419115.338224584, 4576438.07554515],
                                      [419114.29689505, 4576436.36830728], [419113.212548337, 4576434.68550958],
                                      [419113.212548342, 4576434.68550957], [419060.692190378, 4576355.80543402]]]},
                                  "properties": {"id": "1-10110C", "code": "10110C"}}, {"type": "Feature", "geometry": {
                "type": "MultiLineString",
                "coordinates": [[[418994.750675272, 4576544.66640619], [418927.935350063, 4576444.1233729]]]},
                                                                                        "properties": {"id": "1-9110C",
                                                                                                       "code": "9110C"}},
                                 {"type": "Feature", "geometry": {"type": "MultiLineString", "coordinates": [
                                     [[419043.112147532, 4576780.8151097], [418930.758235886, 4576803.58686019],
                                      [418853.411985102, 4576819.33168774]]]},
                                  "properties": {"id": "1-10220C", "code": "10220C"}}, {"type": "Feature", "geometry": {
                "type": "MultiLineString", "coordinates": [
                    [[419082.807123629, 4576840.6177766], [419045.252125659, 4576785.12806806],
                     [419043.51814334, 4576781.80710011], [419043.112147532, 4576780.8151097],
                     [419042.20915693, 4576778.2971341], [419041.348166183, 4576774.68216922],
                     [419020.414396676, 4576663.89724698]]]}, "properties": {"id": "1-10230C", "code": "10230C"}},
                                 {"type": "Feature", "geometry": {"type": "MultiLineString", "coordinates": [
                                     [[419361.898078351, 4576637.27558888], [419244.317018618, 4576623.6276784],
                                      [419222.018078058, 4576622.77818964], [419126.982364387, 4576642.01548638],
                                      [419020.414396676, 4576663.89724698], [418983.262756564, 4576671.46316412],
                                      [418850.362043866, 4576698.90586399]]]},
                                  "properties": {"id": "1-11000C", "code": "11000C"}}, {"type": "Feature", "geometry": {
                "type": "MultiLineString", "coordinates": [
                    [[419529.785474402, 4576509.31887959], [419482.809536649, 4576467.95989764],
                     [419426.318898702, 4576418.05273294], [419382.782880691, 4576379.82596842],
                     [419324.38090525, 4576328.85694898], [419246.865556182, 4576260.68588562],
                     [419204.623471888, 4576223.3349734], [419186.339872754, 4576207.16841539]]]},
                                                                                        "properties": {"id": "1-9150C",
                                                                                                       "code": "9150C"}},
                                 {"type": "Feature", "geometry": {"type": "MultiLineString", "coordinates": [
                                     [[419239.868242898, 4576735.32060145], [419223.963749308, 4576635.04533322],
                                      [419222.018078058, 4576622.77818964], [419221.495269673, 4576610.37147408],
                                      [419217.015099506, 4576504.05298638], [419216.496467073, 4576491.74536995],
                                      [419214.160399611, 4576441.6258473], [419204.623471888, 4576223.3349734]]]},
                                  "properties": {"id": "1-11011C", "code": "11011C"}}, {"type": "Feature", "geometry": {
                "type": "MultiLineString", "coordinates": [
                    [[418927.247237777, 4576956.41273458], [418927.247237754, 4576956.41273457],
                     [418927.882996706, 4576955.35563019], [418928.532745416, 4576954.30810073],
                     [418929.196365749, 4576953.27027208], [418929.87373957, 4576952.24227015],
                     [418930.564748743, 4576951.22422086], [418931.269275131, 4576950.21625011],
                     [418931.987200599, 4576949.21848381], [418932.718407011, 4576948.23104787],
                     [418933.462776232, 4576947.25406819], [418934.220190126, 4576946.28767068],
                     [418934.990530557, 4576945.33198126], [418935.773679388, 4576944.38712583],
                     [418936.569518486, 4576943.45323029], [418937.377929713, 4576942.53042056],
                     [418938.198794934, 4576941.61882254], [418939.031996013, 4576940.71856215],
                     [418939.877414814, 4576939.82976528], [418940.734933203, 4576938.95255785],
                     [418941.604433042, 4576938.08706576], [418942.485796196, 4576937.23341493],
                     [418943.37890453, 4576936.39173126], [418944.283639908, 4576935.56214066],
                     [418945.199884193, 4576934.74476904], [418946.12751925, 4576933.9397423],
                     [418947.066426944, 4576933.14718635], [418948.016489138, 4576932.36722711],
                     [418948.977587697, 4576931.59999047], [418949.949604485, 4576930.84560235],
                     [418950.932421367, 4576930.10418866], [418951.925920206, 4576929.3758753],
                     [418952.929982867, 4576928.66078818], [418953.944491214, 4576927.9590532],
                     [418994.144073596, 4576900.55921535], [419082.807123629, 4576840.6177766],
                     [419170.488907242, 4576781.58513269], [419239.868242898, 4576735.32060145],
                     [419282.241837377, 4576706.07489742], [419316.048515037, 4576677.73918245],
                     [419361.898078351, 4576637.27558888], [419418.604538204, 4576587.39708993],
                     [419435.550376624, 4576573.16923304], [419440.154332635, 4576569.67826826],
                     [419456.570175582, 4576558.08438549], [419529.785474402, 4576509.31887959]]]},
                                                                                        "properties": {"id": "1-10000C",
                                                                                                       "code": "10000C"}},
                                 {"type": "Feature", "geometry": {"type": "MultiLineString", "coordinates": [
                                     [[418848.832074042, 4576635.60948228], [418857.861986619, 4576633.56350444],
                                      [418861.832948306, 4576632.1205195], [418865.58991221, 4576630.11853997],
                                      [418961.830990572, 4576566.31818666], [418994.750675272, 4576544.66640619],
                                      [419035.828281647, 4576518.40967268], [419040.909232753, 4576516.0156973],
                                      [419048.784156795, 4576513.04172825], [419086.915787664, 4576504.15682423],
                                      [419097.993522268, 4576502.15151354], [419132.991237241, 4576504.91449937],
                                      [419154.484171111, 4576506.61131505], [419217.015099506, 4576504.05298638]]]},
                                  "properties": {"id": "1-10100C", "code": "10100C"}}, {"type": "Feature", "geometry": {
                "type": "MultiLineString", "coordinates": [
                    [[418927.247237777, 4576956.41273458], [418916.203954148, 4576950.89108966],
                     [418907.70912028, 4576947.91789563], [418893.348566424, 4576943.14148732],
                     [418886.523633513, 4576940.45951189], [418880.07769711, 4576936.95954455],
                     [418874.151755822, 4576932.72858447], [418871.972777554, 4576930.57860496],
                     [418866.874622422, 4576924.57705977], [418862.705870726, 4576918.32972244],
                     [418859.879899551, 4576912.88877494], [418857.305926587, 4576904.69685438],
                     [418855.824943054, 4576896.20393703], [418854.335966879, 4576857.55931435],
                     [418853.411985102, 4576819.33168774], [418850.362043866, 4576698.90586399],
                     [418848.832074042, 4576635.60948228], [418846.022131482, 4576511.0046995],
                     [418846.352129535, 4576505.76275082], [418847.603118491, 4576501.05579712],
                     [418848.813113011, 4576499.15281627], [418849.13925736, 4576498.61994148],
                     [418849.479855049, 4576498.09723032], [418849.83464457, 4576497.58495119],
                     [418850.20337027, 4576497.08337277], [418850.585776494, 4576496.59276374],
                     [418850.98160759, 4576496.11339279], [418851.390607903, 4576495.6455286],
                     [418851.812521778, 4576495.18943985], [418852.247093564, 4576494.74539522],
                     [418852.694067604, 4576494.31366339], [418853.153188246, 4576493.89451306],
                     [418853.624199836, 4576493.48821289], [418854.106846719, 4576493.09503157],
                     [418854.600873242, 4576492.71523779], [418855.106023751, 4576492.34910023],
                     [418855.622042592, 4576491.99688757], [418927.935350054, 4576444.12337287],
                     [419054.340139305, 4576360.99021579], [419057.742106796, 4576358.4332416],
                     [419060.692190368, 4576355.805434], [419062.42506225, 4576354.06428542],
                     [419065.21503586, 4576350.8413176], [419156.099179373, 4576232.54349572],
                     [419173.597620129, 4576210.35397516], [419173.88779552, 4576210.00153827],
                     [419174.190380312, 4576209.66405666], [419174.504830469, 4576209.34166632],
                     [419174.830601952, 4576209.03450328], [419175.167150726, 4576208.74270355],
                     [419175.513932754, 4576208.46640312], [419175.870403999, 4576208.20573801],
                     [419176.236020423, 4576207.96084422], [419176.610237991, 4576207.73185778],
                     [419176.992512664, 4576207.51891468], [419177.382300407, 4576207.32215093],
                     [419177.779057183, 4576207.14170255], [419178.182238954, 4576206.97770555],
                     [419178.591301684, 4576206.83029592], [419179.005701336, 4576206.69960968],
                     [419179.424893873, 4576206.58578285], [419179.848335258, 4576206.48895143],
                     [419180.275481454, 4576206.40925142], [419180.705788425, 4576206.34681884],
                     [419181.138712133, 4576206.3017897], [419181.573708542, 4576206.2743],
                     [419182.010233615, 4576206.26448576], [419182.447743315, 4576206.27248298],
                     [419182.885693605, 4576206.29842768], [419183.323540449, 4576206.34245585],
                     [419183.760739809, 4576206.40470352], [419184.196747649, 4576206.48530669],
                     [419184.631019931, 4576206.58440137], [419185.063012619, 4576206.70212356],
                     [419185.492181676, 4576206.83860929], [419185.917983065, 4576206.99399455],
                     [419186.339861131, 4576207.16841055]]]}, "properties": {"id": "1-9100C", "code": "9100C"}},
                                 {"type": "Feature", "geometry": {"type": "MultiLineString", "coordinates": [
                                     [[418495.823965748, 4577563.76548043], [418516.004234077, 4577567.19907515],
                                      [418612.38320262, 4577583.59758441], [418716.361945338, 4577601.35046709]]]},
                                  "properties": {"id": "1-10300C", "code": "10300C"}}, {"type": "Feature", "geometry": {
                "type": "MultiLineString", "coordinates": [
                    [[418612.38320262, 4577583.59758441], [418593.821630337, 4577691.96948399],
                     [418593.59941209, 4577697.8265014], [418593.299266123, 4577705.73746359],
                     [418580.772762102, 4577784.43376928], [418580.712967841, 4577784.80941977],
                     [418565.072165053, 4577881.49569843], [418564.07645685, 4577890.29946341],
                     [418552.035735494, 4577959.32356393], [418533.293661032, 4578067.81935053]]]},
                                                                                        "properties": {"id": "1-10480C",
                                                                                                       "code": "10480C"}},
                                 {"type": "Feature", "geometry": {"type": "MultiLineString", "coordinates": [
                                     [[418516.004234077, 4577567.19907515], [418497.84745305, 4577674.52844263],
                                      [418496.81119315, 4577681.93380461], [418495.939257118, 4577688.16486878],
                                      [418481.840018424, 4577767.25488393], [418472.189234876, 4577822.24873221],
                                      [418463.816298692, 4577875.35261552], [418439.907651245, 4578020.89576291]]]},
                                  "properties": {"id": "1-10320C", "code": "10320C"}}, {"type": "Feature", "geometry": {
                "type": "MultiLineString", "coordinates": [
                    [[418495.823965748, 4577563.76548043], [418462.965925267, 4577595.58589858],
                     [418445.556928381, 4577616.22305383], [418426.303269573, 4577643.66239992],
                     [418410.098180633, 4577667.97003333], [418398.633340747, 4577685.16729316],
                     [418393.91017099, 4577692.94397712], [418362.431850533, 4577744.7729315],
                     [418360.897795365, 4577747.6303707], [418333.12261042, 4577799.36638632],
                     [418327.613856761, 4577813.37129672], [418324.270407028, 4577826.62980428],
                     [418320.926957294, 4577847.72812501], [418320.334626555, 4577851.35967656],
                     [418311.242482205, 4577907.10318062], [418308.129615212, 4577924.16630339]]]},
                                                                                        "properties": {"id": "1-10400C",
                                                                                                       "code": "10400C"}},
                                 {"type": "Feature", "geometry": {"type": "MultiLineString", "coordinates": [
                                     [[418308.129615212, 4577924.16630339], [418404.282617882, 4577999.3362767],
                                      [418439.331194395, 4578023.31688168], [418474.840936388, 4578044.53049378],
                                      [418508.50601646, 4578059.74895464], [418533.120723978, 4578069.95224089],
                                      [418577.392610099, 4578081.82725201], [418631.81013679, 4578092.20347532]]]},
                                  "properties": {"id": "1-10450C", "code": "10450C"}}, {"type": "Feature", "geometry": {
                "type": "MultiLineString", "coordinates": [
                    [[418716.361945338, 4577601.35046709], [418696.546241105, 4577713.12545041],
                     [418696.288960407, 4577714.64340653], [418681.558362991, 4577801.55393128],
                     [418681.421044796, 4577802.35268292], [418666.455193507, 4577889.4059553],
                     [418651.467315393, 4577975.52860877], [418631.81013679, 4578092.20347532]]]},
                                                                                        "properties": {"id": "1-10001C",
                                                                                                       "code": "10001C"}},
                                 {"type": "Feature", "geometry": {"type": "MultiLineString", "coordinates": [
                                     [[418651.467315393, 4577975.52860877], [418552.035735494, 4577959.32356393]]]},
                                  "properties": {"id": "1-10330C", "code": "10330C"}}, {"type": "Feature", "geometry": {
                "type": "MultiLineString", "coordinates": [
                    [[418666.455193507, 4577889.4059553], [418565.072165053, 4577881.49569843],
                     [418463.816298692, 4577875.35261552], [418364.91061499, 4577859.54549045],
                     [418320.334626555, 4577851.35967656]]]}, "properties": {"id": "1-10350C", "code": "10350C"}},
                                 {"type": "Feature", "geometry": {"type": "MultiLineString", "coordinates": [
                                     [[418681.421044796, 4577802.35268292], [418580.772762102, 4577784.43376928],
                                      [418481.840018424, 4577767.25488393], [418384.493517302, 4577751.45909607],
                                      [418360.897795365, 4577747.6303707]]]},
                                  "properties": {"id": "1-10360C", "code": "10360C"}}, {"type": "Feature", "geometry": {
                "type": "MultiLineString", "coordinates": [
                    [[418696.288960407, 4577714.64340653], [418593.59941209, 4577697.8265014],
                     [418496.81119315, 4577681.93380461], [418410.098180633, 4577667.97003333]]]},
                                                                                        "properties": {"id": "1-10310C",
                                                                                                       "code": "10310C"}},
                                 {"type": "Feature", "geometry": {"type": "MultiLineString", "coordinates": [
                                     [[418353.482357947, 4577925.24715997], [418364.91061499, 4577859.54549045],
                                      [418374.715840074, 4577805.42626907], [418384.493517302, 4577751.45909607],
                                      [418393.91017099, 4577692.94397712]]]},
                                  "properties": {"id": "1-10410C", "code": "10410C"}}, {"type": "Feature", "geometry": {
                "type": "MultiLineString",
                "coordinates": [[[418374.715840074, 4577805.42626907], [418472.189234876, 4577822.24873221]]]},
                                                                                        "properties": {"id": "1-10420C",
                                                                                                       "code": "10420C"}}]}
        if counter > 0:
            #for key, value in list(data[layer_type]['features'][0]['properties'].items()):
            for key, value  in features['features'][0]['properties'].items():
                if key == 'the_geom': continue
                prov.addAttributes([QgsField(str(key), QVariant.String)])


        #for feature in data[layer_type]['features']:
        for feature in features['features']:
            geometry = self.get_geometry(feature)
            if not geometry: continue
            attributes = []
            fet = QgsFeature()
            fet.setGeometry(geometry)
            for key, value in feature['properties'].items():
                if key =='the_geom': continue

                attributes.append(value)

            fet.setAttributes(attributes)
            prov.addFeatures([fet])

        # Commit changes
        virtual_layer.commitChanges()
        QgsProject.instance().addMapLayer(virtual_layer, False)
        root = QgsProject.instance().layerTreeRoot()
        my_group = root.findGroup(group)
        if my_group is None:
            my_group = root.insertGroup(0, group)
        my_group.insertLayer(0, virtual_layer)


    def get_geometry(self, feature):
        """ Get coordinates from GeoJson and return QGsGeometry
        :param feature: feature to get geometry type and coordinates (GeoJson)
        :return: Geometry of the feature (QgsGeometry)
        functions  called in -> getattr(self, f"get_{feature['geometry']['type'].lower()}")(feature):
            def get_point(self, feature)
            get_linestring(self, feature)
            get_multilinestring(self, feature)
            get_polygon(self, feature)
            get_multipolygon(self, feature)
        """
        try:
            coordinates = getattr(self, f"get_{feature['geometry']['type'].lower()}")(feature)
            type_ = feature['geometry']['type']
            geometry = f"{type_}{coordinates}"
            return QgsGeometry.fromWkt(geometry)
        except AttributeError as e:
            print(f"{type(e).__name__} --> {e}")
            return None


    def get_point(self, feature):
        """ Manage feature geometry when is Point
        :param feature: feature to get geometry type and coordinates (GeoJson)
        :return: Coordinates of the feature (String)
        This function is called in def get_geometry(self, feature)
              geometry = getattr(self, f"get_{feature['geometry']['type'].lower()}")(feature)
          """
        return f"({feature['geometry']['coordinates'][0]} {feature['geometry']['coordinates'][1]})"


    def get_linestring(self, feature):
        """ Manage feature geometry when is LineString
        :param feature: feature to get geometry type and coordinates (GeoJson)
        :return: Coordinates of the feature (String)
        This function is called in def get_geometry(self, feature)
              geometry = getattr(self, f"get_{feature['geometry']['type'].lower()}")(feature)
          """
        return self.get_coordinates(feature)


    def get_multilinestring(self, feature):
        """ Manage feature geometry when is MultiLineString
        :param feature: feature to get geometry type and coordinates (GeoJson)
        :return: Coordinates of the feature (String)
        This function is called in def get_geometry(self, feature)
              geometry = getattr(self, f"get_{feature['geometry']['type'].lower()}")(feature)
          """
        return self.get_multi_coordinates(feature)


    def get_polygon(self, feature):
        """ Manage feature geometry when is Polygon
        :param feature: feature to get geometry type and coordinates (GeoJson)
        :return: Coordinates of the feature (String)
        This function is called in def get_geometry(self, feature)
              geometry = getattr(self, f"get_{feature['geometry']['type'].lower()}")(feature)
          """
        return self.get_multi_coordinates(feature)


    def get_multipolygon(self, feature):
        """ Manage feature geometry when is MultiPolygon
        :param feature: feature to get geometry type and coordinates (GeoJson)
        :return: Coordinates of the feature (String)
        This function is called in def get_geometry(self, feature)
              geometry = getattr(self, f"get_{feature['geometry']['type'].lower()}")(feature)
          """
        return self.get_multi_coordinates(feature)


    def get_coordinates(self, feature):
        coordinates = "("
        for coords in feature['geometry']['coordinates']:
            coordinates += f"{coords[0]} {coords[1]}, "
        coordinates = coordinates[:-2]+")"
        return coordinates


    def get_multi_coordinates(self, feature):

        coordinates = "("
        for coords in feature['geometry']['coordinates']:
            coordinates += "("
            for c in coords:
                coordinates += f"{c[0]} {c[1]}, "
            coordinates = coordinates[:-2] + "), "
        coordinates = coordinates[:-2] + ")"
        return coordinates


    def populate_vlayer_old(self, virtual_layer, data, layer_type, counter, group='GW Temporal Layers'):
        """
        :param virtual_layer: Memory QgsVectorLayer (QgsVectorLayer)
        :param data: Json
        :param layer_type: point, line, polygon...(string)
        :param counter: control if json have values (integer)
        :param group: group to which we want to add the layer (string)
        :return:
        """
        prov = virtual_layer.dataProvider()

        # Enter editing mode
        virtual_layer.startEditing()
        if counter > 0:
            for key, value in list(data[layer_type]['values'][0].items()):
                # add columns
                if str(key) != 'the_geom':
                    prov.addAttributes([QgsField(str(key), QVariant.String)])

        # Add features
        for item in data[layer_type]['values']:
            attributes = []
            fet = QgsFeature()

            for k, v in list(item.items()):
                if str(k) != 'the_geom':
                    attributes.append(v)
                if str(k) in 'the_geom':
                    sql = f"SELECT St_AsText('{v}')"
                    row = self.controller.get_row(sql, log_sql=False)
                    if row and row[0]:
                        geometry = QgsGeometry.fromWkt(str(row[0]))
                        fet.setGeometry(geometry)
            fet.setAttributes(attributes)
            prov.addFeatures([fet])

        # Commit changes
        virtual_layer.commitChanges()
        QgsProject.instance().addMapLayer(virtual_layer, False)
        root = QgsProject.instance().layerTreeRoot()
        my_group = root.findGroup(group)
        if my_group is None:
            my_group = root.insertGroup(0, group)

        my_group.insertLayer(0, virtual_layer)


    def delete_layer_from_toc(self, layer_name):
        """ Delete layer from toc if exist
         :param layer_name: Name's layer (string)
         """

        layer = None
        for lyr in list(QgsProject.instance().mapLayers().values()):
            if lyr.name() == layer_name:
                layer = lyr
                break
        if layer is not None:
            QgsProject.instance().removeMapLayer(layer)
            self.delete_layer_from_toc(layer_name)


    def load_qml(self, layer, qml_path):
        """ Apply QML style located in @qml_path in @layer
        :param layer: layer to set qml (QgsVectorLayer)
        :param qml_path: desired path (string)
        """

        if layer is None:
            return False

        if not os.path.exists(qml_path):
            self.controller.log_warning("File not found", parameter=qml_path)
            return False

        if not qml_path.endswith(".qml"):
            self.controller.log_warning("File extension not valid", parameter=qml_path)
            return False

        layer.loadNamedStyle(qml_path)
        layer.triggerRepaint()

        return True


    def zoom_to_group(self, group_name, buffer=10):
        extent = QgsRectangle()
        extent.setMinimal()

        # Iterate through layers from certain group and combine their extent
        root = QgsProject.instance().layerTreeRoot()
        group = root.findGroup(group_name)  # Adjust this to fit your group's name
        if not group: return False
        for child in group.children():
            if isinstance(child, QgsLayerTreeLayer):
                extent.combineExtentWith(child.layer().extent())

        xmax = extent.xMaximum() + buffer
        xmin = extent.xMinimum() - buffer
        ymax = extent.yMaximum() + buffer
        ymin = extent.yMinimum() - buffer
        extent.set(xmin, ymin, xmax, ymax)
        self.iface.mapCanvas().setExtent(extent)
        self.iface.mapCanvas().refresh()