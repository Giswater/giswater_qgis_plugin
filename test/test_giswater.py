"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import QObject, QSettings

import configparser
import os.path
import sys

from dao.controller import DaoController
from core.btn_admin import GwAdmin
from core.shared.visit_manager import GwVisitManager


class TestGiswater(QObject):

    def __init__(self, iface):
        """ Constructor
        :param iface: An interface instance that will be passed to this class
            which provides the hook by which you can manipulate the QGIS
            application at run time.
        :type iface: QgsInterface
        """

        super(TestGiswater, self).__init__()

        # Initialize instance attributes
        self.iface = iface
        self.controller = None
        self.gw_admin = None

        # Initialize plugin directory
        self.plugin_dir = os.path.dirname(os.path.dirname(__file__))
        self.plugin_name = self.get_value_from_metadata('name', 'giswater')
        self.icon_folder = self.plugin_dir + os.sep + 'icons' + os.sep

        # Check if config file exists
        setting_file = os.path.join(self.plugin_dir, 'config', self.plugin_name + '.config')
        if not os.path.exists(setting_file):
            message = f"Config file not found at: {setting_file}"
            print(message)
            return

        # Set plugin settings
        self.settings = QSettings(setting_file, QSettings.IniFormat)
        self.settings.setIniCodec(sys.getfilesystemencoding())

        # Set QGIS settings. Stored in the registry (on Windows) or .ini file (on Unix)
        self.qgis_settings = QSettings()
        self.qgis_settings.setIniCodec(sys.getfilesystemencoding())


    def init_plugin(self, schema_name=None):
        """ Plugin main initialization function """

        print("init_plugin")

        # Set controller (no database connection yet)
        self.controller = DaoController(self.settings, self.plugin_name, self.iface, create_logger=True)
        self.controller.set_plugin_dir(self.plugin_dir)
        if schema_name:
            self.controller.set_schema_name(schema_name)

        # Set test classes
        self.gw_admin = GwAdmin(self.iface, self.settings, self.controller, self.plugin_dir)
        self.visit_manager = GwVisitManager(self.iface, self.settings, self.controller, self.plugin_dir)


    def get_value_from_metadata(self, parameter, default_value):
        """ Get @parameter from metadata.txt file """

        # Check if metadata file exists
        metadata_file = os.path.join(self.plugin_dir, 'metadata.txt')
        if not os.path.exists(metadata_file):
            message = f"Metadata file not found: {metadata_file}"
            print(message)
            return default_value

        value = None
        try:
            metadata = configparser.ConfigParser()
            metadata.read(metadata_file)
            value = metadata.get('general', parameter)
        except configparser.NoOptionError:
            message = "Parameter not found: {parameter}"
            print(message)
            value = default_value
        finally:
            return value

