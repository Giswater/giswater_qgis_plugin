"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-


from .. import global_vars
from ..lib import tools_qgis, tools_log, tools_db
from ..core.utils import tools_gw


class DaoController:

    def __init__(self, plugin_name, iface, logger_name='plugin', create_logger=True):
        """ Class constructor """

        if create_logger:
            tools_log.set_logger(self, logger_name)




