"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsDataSourceUri, QgsProject, QgsVectorLayer, QgsVectorLayerExporter
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

    def from_dxf_to_toc(self,dxf_layer, dxf_output_filename):
        # Add layer to TOC
        QgsProject.instance().addMapLayer(dxf_layer, False)
        root = QgsProject.instance().layerTreeRoot()
        my_group = root.findGroup(dxf_output_filename)
        if my_group is None:
            my_group = root.insertGroup(0, dxf_output_filename)
        my_group.insertLayer(0, dxf_layer)


    def from_toc_to_db(self, layer, crs):
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