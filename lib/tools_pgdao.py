"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-

from .. import global_vars
from qgis.core import QgsDataSourceUri


def get_uri():
    """ Set the component parts of a RDBMS data source URI
    :return: QgsDataSourceUri() with the connection established according to the parameters of the controller.
    """

    uri = QgsDataSourceUri()
    uri.setConnection(global_vars.controller.credentials['host'], global_vars.controller.credentials['port'],
                      global_vars.controller.credentials['db'], global_vars.controller.credentials['user'],
                      global_vars.controller.credentials['password'])
    return uri