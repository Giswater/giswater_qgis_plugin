"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-

from qgis.core import QgsLocatorFilter, QgsLocatorResult, QgsPointXY

from .info import GwInfo
from .psector import GwPsector
from .workcat import GwWorkcat
from ..utils import tools_gw
from ... import global_vars
from ...libs import lib_vars, tools_qgis, tools_os


class GwSearchLocatorFilter(QgsLocatorFilter):
    """Giswater search provider for QGIS locator (prefix: gw)."""

    def __init__(self):
        super().__init__()
        self.iface = global_vars.iface
        self.canvas = global_vars.canvas
        self.rubber_band = tools_gw.create_rubberband(self.canvas)
        self.manage_new_psector = GwPsector()
        self.min_text_length = int(tools_gw.get_config_parser("search_location", "min_text_length", "user", "init", False) or 1)
        self.max_results = int(tools_gw.get_config_parser("search_location", "max_results", "user", "init", False) or 80)
        self.use_without_prefix = tools_os.set_boolean(
            tools_gw.get_config_parser("search_location", "use_without_prefix", "user", "init", False))
    def clone(self):
        return GwSearchLocatorFilter()

    def name(self):
        return "gw_locator_search"

    def displayName(self):
        return "Giswater Search"

    def prefix(self):
        # QGIS requires plugin prefixes with >= 3 chars.
        return "gws"

    def useWithoutPrefix(self):
        return self.use_without_prefix

    def fetchResults(self, string, context, feedback):
        if feedback and feedback.isCanceled():
            return
        search_text = self._parse_query(string, context)
        if not search_text or len(search_text) < self.min_text_length:
            return

        response = self._get_search_results(search_text)
        if not response:
            return

        groups = response.get("body", {}).get("data", {}).get("searchResults", [])
        if not isinstance(groups, list):
            return

        emitted = 0
        group_index = 0
        for group in groups:
            if feedback and feedback.isCanceled():
                return
            section = group.get("section", "")

            alias = (group.get("alias") or "").strip()
            table_name = group.get("tableName")
            exec_func = group.get("execFunc")
            values = group.get("values", []) or []
            if not values:
                group_index += 1
                continue

            item_index = 0
            for value_item in values:
                display_name = value_item.get("displayName")
                if not display_name:
                    continue
                result = QgsLocatorResult()
                result.filter = self
                result.displayString = display_name
                result.description = ""
                # Keep results grouped by alias and preserve backend order.
                result.group = alias or section
                result.groupScore = max(0.0, 1.0 - (group_index * 0.01))
                result.score = max(0.0, 1.0 - (item_index * 0.0001))
                result.userData = {
                    "section": section,
                    "tableName": table_name,
                    "execFunc": exec_func,
                    "filterKey": value_item.get("key"),
                    "filterValue": value_item.get("value"),
                    "value": value_item.get("value"),
                    "searchAdd": group.get("searchAdd", False),
                }
                self.resultFetched.emit(result)
                emitted += 1
                item_index += 1
                if emitted >= self.max_results:
                    return
            group_index += 1

    def triggerResult(self, result):
        item = result.userData if isinstance(result.userData, dict) else None
        if not item:
            return

        action_data = self._execute_search_selection(item)
        if not action_data:
            return

        geometry = action_data.get("geometry") or {}
        x1 = geometry.get("xcoord")
        y1 = geometry.get("ycoord")
        if x1 is not None and y1 is not None:
            point = QgsPointXY(float(x1), float(y1))
            tools_qgis.draw_point(point, self.rubber_band, duration_time=5000)
            tools_qgis.zoom_to_rectangle(x1, y1, x1, y1, margin=100)
            self.canvas.refresh()

        section = item.get("section", "")
        table_name = action_data.get("funcTable")
        feature_id = action_data.get("funcValue")
        if section.startswith("basic_search_v2_tab_network") and table_name and feature_id is not None:
            custom_form = GwInfo(tab_type="data")
            custom_form.get_info_from_id(table_name, tab_type="data", feature_id=feature_id, is_add_schema=False)
        elif section == "basic_search_v2_tab_workcat" and feature_id is not None:
            workcat_instance = GwWorkcat(global_vars.iface, global_vars.canvas)
            workcat_instance.workcat_open_table_items({"sys_id": feature_id, "filter_text": "", "display_name": ""})
        elif section == "basic_search_v2_tab_psector" and feature_id is not None:
            self.manage_new_psector.get_psector(feature_id, None)
        elif section == "basic_search_v2_tab_hydrometer" and table_name and feature_id is not None:
            custom_form = GwInfo(tab_type="data")
            custom_form.get_info_from_id(table_name, tab_type="data", feature_id=feature_id, is_add_schema=False)

    def _parse_query(self, query, context):
        text = (query or "").strip()
        if not text:
            return ""
        # Always allow explicit prefix in query text and strip it.
        if text.lower().startswith("gws "):
            return text[4:].strip()

        # Optional strict mode:
        # - when prefixless search is disabled, accept raw text only if the
        #   locator context is currently using the "gws" prefix.
        if self.use_without_prefix:
            return text

        using_prefix = bool(getattr(context, "usingPrefix", False))
        active_prefix = (self.activePrefix() or "").lower()
        if not (using_prefix and active_prefix == "gws"):
            return ""
        return text

    def _get_search_results(self, search_text):
        body = {
            "data": {
                "parameters": {"searchText": search_text},
                "addSchema": lib_vars.project_vars.get("add_schema"),
            }
        }
        result = tools_gw.execute_procedure("gw_fct_getsearch", body, rubber_band=self.rubber_band)
        if not result or result.get("status") == "Failed":
            return None
        return result

    def _execute_search_selection(self, item):
        body = {
            "data": {
                "section": item.get("section"),
                "value": item.get("value"),
                "filterKey": item.get("filterKey"),
                "filterValue": item.get("filterValue"),
                "execFunc": item.get("execFunc"),
                "tableName": item.get("tableName"),
                "searchAdd": str(item.get("searchAdd", False)).lower(),
            }
        }
        result = tools_gw.execute_procedure("gw_fct_setsearch", body, rubber_band=self.rubber_band)
        if not result or result.get("status") == "Failed":
            return None
        data = result.get("body", {}).get("data")
        if not isinstance(data, dict):
            data = result.get("data")
        return data if isinstance(data, dict) else None
