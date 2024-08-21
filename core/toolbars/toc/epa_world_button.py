"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import json
from functools import partial

from typing import List, Tuple, Optional
from qgis.PyQt.QtCore import QObject, QPoint
from qgis.PyQt.QtWidgets import QMenu, QAction
from qgis.PyQt.QtGui import QCursor
from qgis.core import QgsMapLayerStyle
from ..dialog import GwAction
from ...utils import tools_gw
from ....libs import tools_qgis, tools_db


def get_available_contexts() -> List[str]:
    """Fetch distinct contexts from the sys_style table, excluding TEMPLAYER."""

    sql = "SELECT DISTINCT context FROM sys_style WHERE context != 'TEMPLAYER'"
    rows = tools_db.get_rows(sql)
    return [row[0] for row in rows] if rows else []


def get_contexts_params() -> List[Tuple[str, str]]:

    sql = """
    SELECT DISTINCT ON (c.id) c.id, c.idval, c.addparam
      FROM config_typevalue c
      JOIN sys_style s ON c.id = s.context
     WHERE c.typevalue = 'sys_style_context'
       AND s.context != 'TEMPLAYER'
    """
    rows = tools_db.get_rows(sql)

    if not rows:
        return []

    # Process rows to extract the order and sort them accordingly
    processed_rows = []
    for row in rows:
        id, idval, addparam = row
        order_by = 999  # Default order if not specified
        if addparam:
            try:
                order_by = addparam.get("orderBy", 999)
            except Exception:
                pass

        processed_rows.append((id, idval, order_by))

    # Sort the rows by order_by
    processed_rows.sort(key=lambda x: x[2])

    return [(row[0], row[1]) for row in processed_rows]


def get_styles_for_context(context: str) -> List[Tuple[str, str]]:
    """Fetch styles from the sys_style table for a given context."""

    sql = f"SELECT idval, stylevalue FROM sys_style WHERE context = '{context}'"
    rows = tools_db.get_rows(sql)
    return [(row[0], row[1]) for row in rows] if rows else []


def apply_styles_to_layers(context: str) -> None:
    """Apply styles to layers based on the selected context."""

    styles = get_styles_for_context(context)
    for layername, qml in styles:
        layer = tools_qgis.get_layer_by_tablename(layername)
        if layer:
            valid_qml, error_message = tools_gw.validate_qml(qml)
            if not valid_qml:
                msg = "The QML file is invalid"
                tools_qgis.show_warning(msg, parameter=error_message, title=context)
            else:
                style_manager = layer.styleManager()
                style_name = context

                if style_manager is None or style_manager.currentStyle() == context:
                    continue

                # Set the style or add it if it doesn't exist
                if not style_manager.setCurrentStyle(style_name):
                    style = QgsMapLayerStyle()
                    style.readFromLayer(layer)
                    style_manager.addStyle(style_name, style)
                    style_manager.setCurrentStyle(style_name)
                    tools_qgis.create_qml(layer, qml)


class GwEpaWorldButton(GwAction):
    """Button 308: Switch EPA world"""

    def __init__(self, icon_path: str, action_name: str, text: str, toolbar: QObject, action_group: QObject):
        super().__init__(icon_path, action_name, text, toolbar, action_group)
        self.menu: QMenu = QMenu()
        self._populate_menu()
        self.action.setMenu(self.menu)
        self.action.setCheckable(False)

    def clicked_event(self) -> None:
        """Show the menu directly when the button is clicked."""

        cursor = QCursor()
        x = cursor.pos().x()
        y = cursor.pos().y()
        click_point = QPoint(x + 5, y + 5)
        self.menu.exec_(click_point)

    def _populate_menu(self) -> None:
        """Populate the menu with available contexts."""

        # contexts = get_available_contexts()
        contexts_params = get_contexts_params()
        for context_id, context_alias in contexts_params:
            action: QAction = QAction(context_alias, self.menu)
            action.triggered.connect(partial(self._apply_context, context_id))
            self.menu.addAction(action)

    def _apply_context(self, context: str) -> None:
        """Apply styles for the selected context."""

        apply_styles_to_layers(context)
        tools_qgis.show_info(f"Applied styles for context: {context}")
