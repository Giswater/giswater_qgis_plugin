"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import configparser
import json
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
        metadata_file = os.path.join(self.plugin_dir, 'metadata66.txt')
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

