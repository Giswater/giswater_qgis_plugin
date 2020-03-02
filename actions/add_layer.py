"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import json
from collections import OrderedDict

from qgis.core import QgsCategorizedSymbolRenderer, QgsFillSymbol, QgsDataSourceUri, QgsFeature, QgsField, QgsGeometry, QgsMarkerSymbol,\
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
                    v_layer = QgsVectorLayer(f"{geometry_type}?crs=epsg:{srid}", layer_name, 'memory')

                    #TODO This if controls if the function already works with GeoJson or is still to be refactored
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
                    v_layer.setOpacity(0.5)
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


    def set_layer_symbology(self, layer, properties=None):
        renderer = layer.renderer()
        symbol = renderer.symbol()

        if type(symbol) == QgsLineSymbol:
            layer.renderer().setSymbol(QgsLineSymbol.createSimple(properties))
        elif type(symbol) == QgsMarkerSymbol:
            layer.renderer().setSymbol(QgsMarkerSymbol.createSimple(properties))
        elif type(symbol) == QgsFillSymbol:
            layer.renderer().setSymbol(QgsFillSymbol.createSimple(properties))

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
        if counter > 0:
            for key, value in list(data[layer_type]['features'][0]['properties'].items()):
                if key == 'the_geom': continue
                prov.addAttributes([QgsField(str(key), QVariant.String)])

        for feature in data[layer_type]['features']:
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
        coordinates = "("
        for coords in feature['geometry']['coordinates']:
            coordinates += "("
            for cc in coords:
                coordinates += "("
                for c in cc:
                    coordinates += f"{c[0]} {c[1]}, "
                coordinates = coordinates[:-2] + "), "
            coordinates = coordinates[:-2] + "), "
        coordinates = coordinates[:-2] + ")"
        return coordinates


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