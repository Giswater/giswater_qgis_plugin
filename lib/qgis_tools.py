"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsExpressionContextUtils, QgsProject
from qgis.PyQt.QtWidgets import QDockWidget

import configparser
import os.path


class QgisTools:

    def __init__(self, iface, plugin_dir):
        """ Constructor
        :param iface: An interface instance that will be passed to this class
            which provides the hook by which you can manipulate the QGIS
            application at run time.
        :type iface: QgsInterface
        """

        self.iface = iface
        self.plugin_dir = plugin_dir


    def get_value_from_metadata(self, parameter, default_value):
        """ Get @parameter from metadata.txt file """

        # Check if metadata file exists
        metadata_file = os.path.join(self.plugin_dir, 'metadata.txt')
        if not os.path.exists(metadata_file):
            message = f"Metadata file not found: {metadata_file}"
            self.iface.messageBar().pushMessage("", message, 1, 20)
            return default_value

        value = None
        try:
            metadata = configparser.ConfigParser()
            metadata.read(metadata_file)
            value = metadata.get('general', parameter)
        except configparser.NoOptionError:
            message = f"Parameter not found: {parameter}"
            self.iface.messageBar().pushMessage("", message, 1, 20)
            value = default_value
        finally:
            return value


    def enable_python_console(self):
        """ Enable Python console and Log Messages panel if parameter 'enable_python_console' = True """

        # Manage Python console
        python_console = self.iface.mainWindow().findChild(QDockWidget, 'PythonConsole')
        if python_console:
            python_console.setVisible(True)
        else:
            import console
            console.show_console()

        # Manage Log Messages panel
        message_log = self.iface.mainWindow().findChild(QDockWidget, 'MessageLog')
        if message_log:
            message_log.setVisible(True)


    def get_project_variable(self, var_name):
        """ Get project variable """

        value = None
        try:
            value = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable(var_name)
        except Exception:
            pass
        finally:
            return value


    def qgis_get_layers(self):
        """ Return layers in the same order as listed in TOC """

        layers = [layer.layer() for layer in QgsProject.instance().layerTreeRoot().findLayers()]

        return layers


    def qgis_get_layer_source(self, layer):
        """ Get database connection paramaters of @layer """

        # Initialize variables
        layer_source = {'db': None, 'schema': None, 'table': None, 'service': None,
                        'host': None, 'port': None, 'user': None, 'password': None, 'sslmode': None}

        if layer is None:
            return layer_source

        # Get dbname, host, port, user and password
        uri = layer.dataProvider().dataSourceUri()
        pos_db = uri.find('dbname=')
        pos_host = uri.find(' host=')
        pos_port = uri.find(' port=')
        pos_user = uri.find(' user=')
        pos_password = uri.find(' password=')
        pos_sslmode = uri.find(' sslmode=')
        pos_key = uri.find(' key=')
        if pos_db != -1 and pos_host != -1:
            uri_db = uri[pos_db + 8:pos_host - 1]
            layer_source['db'] = uri_db
        if pos_host != -1 and pos_port != -1:
            uri_host = uri[pos_host + 6:pos_port]
            layer_source['host'] = uri_host
        if pos_port != -1:
            if pos_user != -1:
                pos_end = pos_user
            elif pos_sslmode != -1:
                pos_end = pos_sslmode
            elif pos_key != -1:
                pos_end = pos_key
            else:
                pos_end = pos_port + 10
            uri_port = uri[pos_port + 6:pos_end]
            layer_source['port'] = uri_port
        if pos_user != -1 and pos_password != -1:
            uri_user = uri[pos_user + 7:pos_password - 1]
            layer_source['user'] = uri_user
        if pos_password != -1 and pos_sslmode != -1:
            uri_password = uri[pos_password + 11:pos_sslmode - 1]
            layer_source['password'] = uri_password

            # Get schema and table or view name
        pos_table = uri.find('table=')
        pos_end_schema = uri.rfind('.')
        pos_fi = uri.find('" ')
        if pos_table != -1 and pos_fi != -1:
            uri_schema = uri[pos_table + 6:pos_end_schema]
            uri_table = uri[pos_end_schema + 2:pos_fi]
            layer_source['schema'] = uri_schema
            layer_source['table'] = uri_table

        return layer_source


    def qgis_get_layer_source_table_name(self, layer):
        """ Get table or view name of selected layer """

        if layer is None:
            return None

        uri_table = None
        uri = layer.dataProvider().dataSourceUri().lower()
        pos_ini = uri.find('table=')
        pos_end_schema = uri.rfind('.')
        pos_fi = uri.find('" ')
        if pos_ini != -1 and pos_fi != -1:
            uri_table = uri[pos_end_schema + 2:pos_fi]

        return uri_table


    def qgis_get_layer_primary_key(self, layer=None):
        """ Get primary key of selected layer """

        uri_pk = None
        if layer is None:
            layer = self.iface.activeLayer()
        if layer is None:
            return uri_pk
        uri = layer.dataProvider().dataSourceUri().lower()
        pos_ini = uri.find('key=')
        pos_end = uri.rfind('srid=')
        if pos_ini != -1:
            uri_pk = uri[pos_ini + 5:pos_end - 2]

        return uri_pk

