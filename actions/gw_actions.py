"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-

from functools import partial

from .. import utils_giswater

from .api_parent import ApiParent


class GwActions(ApiParent):
    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control functions called from data base """

        ApiParent.__init__(self, iface, settings, controller, plugin_dir)

    def test(self, value):
        print("test")
        print(f"test 2--> {value}")