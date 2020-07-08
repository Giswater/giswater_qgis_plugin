"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
from functools import partial

from .. import utils_giswater

from .api_parent import ApiParent


class GwActions(ApiParent):
    def __init__(self, iface, settings, controller, plugin_dir):
        """ Class to control functions called from data base """

        ApiParent.__init__(self, iface, settings, controller, plugin_dir)

    def test1(self, **params):
        print("test1")
        print(f"test 1--> {params}")

    def test2(self, **params):
        print("test2")
        print(f"test 2--> {params}")


    def load_qml(self, **params):
        """ Apply QML style located in @qml_path in @layer
        :param params:[{"funcName": "load_qml",
                        "params": {"layerName": "v_edit_arc",
                        "qmlPath": "C:\\xxxx\\xxxx\\xxxx\\qml_file.qml"}}]
        :return: Boolean value
        """
        # Get layer
        layer = self.controller.get_layer_by_tablename(params['layerName']) if 'layerName' in params else None
        if layer is None:
            return False

        # Get qml path
        qml_path = params['qmlPath'] if 'mlPath' in params else None

        if not os.path.exists(qml_path):
            self.controller.log_warning("File not found", parameter=qml_path)
            return False

        if not qml_path.endswith(".qml"):
            self.controller.log_warning("File extension not valid", parameter=qml_path)
            return False

        layer.loadNamedStyle(qml_path)
        layer.triggerRepaint()

        return True
