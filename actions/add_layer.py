"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsCategorizedSymbolRenderer, QgsDataSourceUri, QgsFeature, QgsField, QgsGeometry, QgsProject, QgsRendererCategory, QgsSimpleFillSymbolLayer, QgsSymbol, QgsVectorLayer, QgsVectorLayerExporter

from qgis.PyQt.QtCore import QVariant
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


    def manage_geometry(self, geometry):
        """ Get QgsGeometry and return as text """
        geometry = geometry.asWkt().replace('Z (', ' (')
        geometry = geometry.replace(' 0)', ')')
        return geometry


    def from_dxf_to_toc(self, dxf_layer, dxf_output_filename):
        """  Read a dxf file and put result into TOC
        :param dxf_layer:
        :param dxf_output_filename:
        :return:
        """

        QgsProject.instance().addMapLayer(dxf_layer, False)
        root = QgsProject.instance().layerTreeRoot()
        my_group = root.findGroup(dxf_output_filename)
        if my_group is None:
            my_group = root.insertGroup(0, dxf_output_filename)
        my_group.insertLayer(0, dxf_layer)
        self.canvas.refreshAllLayers()
        return dxf_layer


    def set_datasource(self, layer):
        schema_name = self.controller.credentials['schema'].replace('"', '')
        uri = QgsDataSourceUri()
        uri.setConnection(self.controller.credentials['host'], self.controller.credentials['port'],
                          self.controller.credentials['db'], self.controller.credentials['user'],
                          self.controller.credentials['password'])
        uri.setDataSource(schema_name, layer.name(), None, "", layer.name())
        return layer


    def export_layer_to_db(self, layer, crs):
        sql = f'DROP TABLE "{layer.name()}";'
        self.controller.execute_sql(sql, log_sql=True)

        schema_name = self.controller.credentials['schema'].replace('"', '')
        uri = QgsDataSourceUri()
        uri.setConnection(self.controller.credentials['host'], self.controller.credentials['port'],
                          self.controller.credentials['db'], self.controller.credentials['user'],
                          self.controller.credentials['password'])
        uri.setDataSource(schema_name, layer.name(), None, "", layer.name())

        error = QgsVectorLayerExporter.exportLayer(layer, uri.uri(), self.controller.credentials['user'], crs, False)

        if error[0] != 0:
            self.controller.log_info(F"ERROR --> {error[1]}")


    def from_postgres_to_toc(self, tablename=None, the_geom="the_geom", field_id="id",  child_layers=None, group='GW Layers'):
        """ Put selected layer into TOC"""
        schema_name = self.controller.credentials['schema'].replace('"', '')
        uri = QgsDataSourceUri()
        uri.setConnection(self.controller.credentials['host'], self.controller.credentials['port'],
                          self.controller.credentials['db'], self.controller.credentials['user'],
                          self.controller.credentials['password'])
        if child_layers is not None:
            for layer in child_layers:
                if layer[0] != 'Load all':
                    uri.setDataSource(schema_name, f'{layer[0]}', the_geom, None, layer[1] + "_id")
                    vlayer = QgsVectorLayer(uri.uri(), f'{layer[0]}', "postgres")
                    self.check_for_group(vlayer, group)
        else:
            uri.setDataSource(schema_name, f'{tablename}', the_geom, None, field_id)
            vlayer = QgsVectorLayer(uri.uri(), f'{tablename}', "postgres")
            self.check_for_group(vlayer, group)
        self.iface.mapCanvas().refresh()


    def check_for_group(self, layer, group=None):
        """ If the function receives a group name, check if it exists or not and put the layer in this group """
        if group is None:
            QgsProject.instance().addMapLayer(layer)
        else:
            root = QgsProject.instance().layerTreeRoot()
            my_group = root.findGroup(group)
            if my_group is None:
                my_group = root.insertGroup(0, group)
            my_group.insertLayer(0, layer)


    def add_temp_layer(self, dialog, data, function_name, force_tab=True, reset_text=True, tab_idx=1, del_old_layers=True):
        if del_old_layers:
            self.delete_layer_from_toc(function_name)
        srid = self.controller.plugin_settings_value('srid')
        for k, v in list(data.items()):
            if str(k) == "info":
                self.populate_info_text(dialog, data, force_tab, reset_text, tab_idx)
            else:
                counter = len(data[k]['values'])
                if counter > 0:
                    counter = len(data[k]['values'])
                    geometry_type = data[k]['geometryType']
                    v_layer = QgsVectorLayer(f"{geometry_type}?crs=epsg:{srid}", function_name, 'memory')
                    self.populate_vlayer(v_layer, data, k, counter)
                    # TODO delete this 'if' when all functions are refactored
                    if 'qmlPath' in data[k] and data[k]['qmlPath']:
                        qml_path = data[k]['qmlPath']
                        self.load_qml(v_layer, qml_path)
                    elif 'category_field' in data[k] and data[k]['category_field']:
                        field = data[k]['category_field']
                        self.categoryze_layer(v_layer, field)


    def categoryze_layer(self, layer, cat_field):

        # get unique values
        fields = layer.fields()
        fni = fields.indexOf(cat_field)
        unique_values = layer.dataProvider().uniqueValues(fni)

        categories = []
        for unique_value in unique_values:
            # initialize the default symbol for this geometry type
            symbol = QgsSymbol.defaultSymbol(layer.geometryType())

            # configure a symbol layer
            layer_style = {}
            layer_style['color'] = '%d, %d, %d' % (randrange(0, 256), randrange(0, 256), randrange(0, 256))
            layer_style['outline'] = '#000000'
            symbol_layer = QgsSimpleFillSymbolLayer.create(layer_style)

            # replace default symbol layer with the configured one
            if symbol_layer is not None:
                symbol.changeSymbolLayer(0, symbol_layer)

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

        return change_tab



    def populate_vlayer(self, virtual_layer, data, layer_type, counter):

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
                    geometry = QgsGeometry.fromWkt(str(row[0]))
                    fet.setGeometry(geometry)
            fet.setAttributes(attributes)
            prov.addFeatures([fet])

        # Commit changes
        virtual_layer.commitChanges()
        QgsProject.instance().addMapLayer(virtual_layer, False)
        root = QgsProject.instance().layerTreeRoot()
        my_group = root.findGroup('GW Functions results')
        if my_group is None:
            my_group = root.insertGroup(0, 'GW Functions results')

        my_group.insertLayer(0, virtual_layer)


    def delete_layer_from_toc(self, layer_name):
        """ Delete layer from toc if exist """

        layer = None
        for lyr in list(QgsProject.instance().mapLayers().values()):
            if lyr.name() == layer_name:
                layer = lyr
                break
        if layer is not None:
            QgsProject.instance().removeMapLayer(layer)
            self.delete_layer_from_toc(layer_name)


    def load_qml(self, layer, qml_path):
        """ Apply QML style located in @qml_path in @layer """

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