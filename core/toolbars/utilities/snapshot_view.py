"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from functools import partial

from qgis.PyQt.QtCore import QDateTime, QVariant, QDate
from qgis.PyQt.QtWidgets import QCheckBox, QLabel, QLineEdit, QWidget, QMenu, QAction, QPushButton
from qgis.core import QgsGeometry, QgsPointXY, QgsVectorLayer, QgsFeature, QgsProject, QgsField, QgsSymbol, QgsRuleBasedRenderer
from qgis.PyQt.QtGui import QColor
from ..dialog import GwAction
from ...ui.ui_manager import GwSnapshotViewUi
from ...utils import tools_gw
from ...utils.selection_mode import GwSelectionMode
from ....libs import lib_vars, tools_qt, tools_db, tools_qgis
from ...utils.select_manager import GwSelectManager
from .... import global_vars


class GwSnapshotViewButton(GwAction):
    """ Button 68: Snapshot View """

    def __init__(self, icon_path, action_name, text, toolbar, action_group):

        super().__init__(icon_path, action_name, text, toolbar, action_group)

    def clicked_event(self):

        self._open_snapshot_view()

    # region private functions

    def _open_snapshot_view(self):
        """ Get dialog """

        # Get yesterday date
        yesterday = QDateTime.currentDateTime().addDays(-1)

        # Get first snapshot date
        first_snapshot_date = self._get_first_snapshot_date()

        # Check previosly if are available snapshots
        if not first_snapshot_date or first_snapshot_date > yesterday.date().toPyDate():
            # Show warning
            msg = "No snapshots available. Please create a snapshot first or wait for tomorrow to travel since today."
            tools_qgis.show_warning(msg)
            return

        # Create form and body
        form = {"formName": "generic", "formType": "snapshot_view"}
        body = {"client": {"cur_user": tools_db.current_user}, "form": form}

        # Execute procedure
        json_result = tools_gw.execute_procedure('gw_fct_get_dialog', body)

        # Create dialog
        self.dlg_snapshot_view = GwSnapshotViewUi(self)
        tools_gw.load_settings(self.dlg_snapshot_view)
        tools_gw.manage_dlg_widgets(self, self.dlg_snapshot_view, json_result)

        # Get dynamic widgets
        self.dlg_snapshot_view.findChild(QLineEdit, "tab_none_extension").setObjectName("txt_coordinates")
        self.btn_coordinate_actions = self.dlg_snapshot_view.findChild(QPushButton, "tab_none_btn_grid")
        self.features = self.dlg_snapshot_view.findChildren(QCheckBox)
        self.date = self.dlg_snapshot_view.findChild(QWidget, "tab_none_date")

        # Convert first_snapshot_date to QDateTime for widget
        q_first_snapshot_date = QDateTime(QDate(first_snapshot_date.year, first_snapshot_date.month, first_snapshot_date.day))

        # Set minimum date to first snapshot date
        self.date.setMinimumDateTime(q_first_snapshot_date)

        # Set yesterday as default date and maximum date
        self.date.setDateTime(yesterday)
        self.date.setMaximumDateTime(yesterday)

        # Handle coordinate actions
        self._handle_coordinates_actions()

        # Hide gully checkbox if project type is not UD
        if self.project_type != 'ud':
            self.dlg_snapshot_view.findChild(QCheckBox, "tab_none_chk_gully").hide()
            self.dlg_snapshot_view.findChild(QLabel, "lbl_tab_none_chk_gully").hide()

        # Open form
        tools_gw.open_dialog(self.dlg_snapshot_view, 'snapshot_view')

    def _get_first_snapshot_date(self):
        """ Get first snapshot date """

        # Get the first snapshot date
        sql = f"SELECT min(date)::date FROM audit.snapshot WHERE schema = '{lib_vars.schema_name}';"
        result = tools_db.get_row(sql)

        # Check if result is not None
        if result and result[0]:
            return result[0]
        else:
            return None

    def _handle_coordinates_actions(self):
        """Populate the coordinates actions button with actions"""
        try:

            # Create menu
            menu = QMenu(self.btn_coordinate_actions)

            # Get translations
            calc_expl = tools_qt.tr("Calculate from exploitation", "snapshot_view")
            calc_muni = tools_qt.tr("Calculate from municipality", "snapshot_view")
            cur_canvas = tools_qt.tr("Use current map canvas extent", "snapshot_view")
            draw_canvas = tools_qt.tr("Draw on map canvas", "snapshot_view")

            # Create actions for the menu
            dict_menu = {
                calc_expl: menu.addMenu(calc_expl),
                calc_muni: menu.addMenu(calc_muni),
                cur_canvas: QAction(cur_canvas, self.btn_coordinate_actions),
                draw_canvas: QAction(draw_canvas, self.btn_coordinate_actions)
            }

            # Fill actions from exploitation
            result = tools_db.get_rows(f"SELECT expl_id, name FROM {lib_vars.schema_name}.exploitation WHERE the_geom IS NOT NULL;")
            if result:
                for row in result:
                    action = QAction(f"{row[0]} - {row[1]}", self.btn_coordinate_actions)
                    dict_menu[calc_expl].addAction(action)
                    action.triggered.connect(partial(self._update_current_polygon, "exploitation", "expl_id", row[0]))

            # Fill actions from municipality
            result = tools_db.get_rows(f"SELECT muni_id, name FROM {lib_vars.schema_name}.ext_municipality WHERE the_geom IS NOT NULL;")
            if result:
                for row in result:
                    action = QAction(f"{row[0]} - {row[1]}", self.btn_coordinate_actions)
                    dict_menu[calc_muni].addAction(action)
                    action.triggered.connect(partial(self._update_current_polygon, "ext_municipality", "muni_id", row[0]))

            # Map Canvas Extent
            dict_menu[cur_canvas].triggered.connect(partial(self._update_current_polygon, "map_canvas"))
            menu.addAction(dict_menu[cur_canvas])

            # Draw on map canvas
            dict_menu[draw_canvas].triggered.connect(partial(self._update_current_polygon, "draw"))
            menu.addAction(dict_menu[draw_canvas])

            # Assign the menu to the button
            self.btn_coordinate_actions.setMenu(menu)

        except Exception as e:
            msg = "Failed to load layers"
            param = str(e)
            tools_qgis.show_warning(msg, dialog=self.dlg_snapshot_view, parameter=param)

    def _update_current_polygon(self, origin, id_name=None, id=None):
        """ Update polygon """
        xmin, xmax, ymin, ymax = None, None, None, None
        if origin == "map_canvas":
            extent = self.iface.mapCanvas().extent()
            xmin = extent.xMinimum()
            xmax = extent.xMaximum()
            ymin = extent.yMinimum()
            ymax = extent.yMaximum()
            tools_qt.set_widget_text(self.dlg_snapshot_view, "txt_coordinates", f"{xmin},{xmax},{ymin},{ymax} [EPSG:25831]")

        elif origin in ("exploitation", "ext_municipality"):
            sql = f"SELECT ST_Xmin(the_geom), ST_Xmax(the_geom), ST_Ymin(the_geom), ST_Ymax(the_geom) FROM {lib_vars.schema_name}.{origin} where {id_name} = {id};"
            xmin, xmax, ymin, ymax = tools_db.get_row(sql)
            tools_qt.set_widget_text(self.dlg_snapshot_view, "txt_coordinates", f"{xmin},{xmax},{ymin},{ymax} [EPSG:25831]")

        elif origin == "draw":
            select_manager = GwSelectManager(self, None, self.dlg_snapshot_view, GwSelectionMode.DEFAULT, self.dlg_snapshot_view)
            global_vars.canvas.setMapTool(select_manager)
            cursor = tools_gw.get_cursor_multiple_selection()
            global_vars.canvas.setCursor(cursor)


def close_dlg(**kwargs):
    """ Close form """

    dialog = kwargs["dialog"]
    tools_gw.close_dialog(dialog)


def run(**kwargs):
    """ Button run clicked """

    dlg = kwargs["class"]

    # Get coordinates
    txt_coordinates = tools_qt.get_text(dlg.dlg_snapshot_view, "txt_coordinates")
    polygon = None

    if txt_coordinates != "null":
        # Parse coordinates and create polygon
        coordinates = list(map(float, txt_coordinates.split(" [EPSG")[0].split(",")))
        polygon = QgsGeometry.fromPolygonXY([[
            QgsPointXY(coordinates[0], coordinates[2]),
            QgsPointXY(coordinates[1], coordinates[2]),
            QgsPointXY(coordinates[1], coordinates[3]),
            QgsPointXY(coordinates[0], coordinates[3]),
            QgsPointXY(coordinates[0], coordinates[2])  # Close the polygon
        ]])

    # Check null values
    if not polygon or dlg.date.dateTime().isNull() or not any([feature.isChecked() for feature in dlg.features]):
        msg = "Required fields are missing"
        tools_qgis.show_warning(msg, dialog=dlg.dlg_snapshot_view)
        return

    # Create json input data
    form = {
        "date": dlg.date.dateTime().toString("yyyy-MM-dd"),
        "polygon": f'{polygon.asWkt()}',
        "features": [feature.objectName().split('_')[-1] for feature in dlg.features if feature.isChecked()]
    }

    body = {"client": {"cur_user": tools_db.current_user}, "form": form}

    # Execute procedure
    result = tools_gw.execute_procedure('gw_fct_getsnapshot', body, schema_name='audit')

    if result.get("status") == "Accepted" and result.get("body").get("data"):
        layers = result['body']['data']
        add_layers_temp(layers, f"Snapshot - {form['date']}")
        tools_gw.close_dialog(dlg.dlg_snapshot_view)
    else:
        msg = "No results"
        tools_qgis.show_warning(msg, dialog=dlg.dlg_snapshot_view)


def add_layers_temp(layers, group):
    """Creates temporary layers from a given list of layers and adds them to specified subgroups under a main group in QGIS."""

    for i, layer in enumerate(layers):
        if not layer['features']:
            continue

        geometry_type = layer['geometryType']
        aux_layer_name = layer['layerName']
        layer_group = layer.get('group', '')  # Get the subgroup name from the layer

        # Remove existing layer with the same name from the group
        tools_qgis.remove_layer_from_toc(aux_layer_name, group)

        # Create a new memory layer
        v_layer = QgsVectorLayer(f"{geometry_type}?crs=epsg:{lib_vars.data_epsg}", aux_layer_name, 'memory')
        prov = v_layer.dataProvider()

        v_layer.startEditing()

        # Get unique attributes before adding features
        unique_attributes = set()
        for feature in layer['features']:
            for key in feature['properties'].keys():
                if key != 'the_geom':
                    unique_attributes.add(key)
        unique_attributes.add("color")  # Add color attribute

        # Add unique attributes to the layer
        prov.addAttributes([QgsField(str(key), QVariant.String) for key in unique_attributes])
        v_layer.updateFields()

        # Add features with their attributes and colors
        for feature in layer['features']:
            geometry = tools_qgis.get_geometry_from_json(feature)
            if not geometry:
                continue

            fet = QgsFeature()
            fet.setGeometry(geometry)

            attributes = []
            for key in unique_attributes:
                value = feature['properties'].get(key, "")  # Get the value or an empty string if not exists
                if key == "color":
                    value = feature.get('color', 'blue')  # If no color, use blue by default
                attributes.append(value)

            fet.setAttributes(attributes)
            prov.addFeatures([fet])

        v_layer.commitChanges()

        # Add the layer to the project under the main group
        QgsProject.instance().addMapLayer(v_layer, False)
        root = QgsProject.instance().layerTreeRoot()

        # Ensure the main group exists
        main_group = root.findGroup(group) or root.insertGroup(0, group)

        # Check if the subgroup exists under the main group, if not, create it
        subgroup = main_group.findGroup(layer_group) or main_group.insertGroup(0, layer_group)
        subgroup.insertLayer(i, v_layer)

        # Apply rule-based style
        apply_layer_style(v_layer, layer_group, aux_layer_name)


def apply_layer_style(layer, layer_group, layer_origin):
    """Applies styling to a layer based on its geometry type and feature colors."""

    # Get reference symbol style from layer_group
    layer_node = QgsProject.instance().mapLayersByName(layer_group)[0]
    renderer = layer_node.renderer()
    reference_symbol = QgsSymbol.defaultSymbol(layer.geometryType())
    if isinstance(renderer, QgsRuleBasedRenderer):
        root_rule_group = renderer.rootRule()
        for rule in root_rule_group.children():
            if rule.label() == layer_origin:
                reference_symbol = rule.symbol().clone()
                break

    # Check which colors are present in the layer features
    has_colors = {'red': False, 'yellow': False}
    for feature in layer.getFeatures():
        color = feature['color']
        if color in has_colors:
            has_colors[color] = True

    def create_colored_rule(color_name, label):
        """Helper to create a rule with the correct color and style."""
        rule = QgsRuleBasedRenderer.Rule(symbol=reference_symbol.clone())
        rule.setLabel(label)
        rule.setFilterExpression(f"\"color\" = '{color_name}'")
        rule.symbol().setOpacity(0.5)
        color = QColor(color_name)
        if layer.geometryType() == 1:
            rule.symbol().symbolLayer(0).setColor(color)
        else:
            rule.symbol().symbolLayer(0).setFillColor(color)
        return rule

    # Create root rule
    root_rule = QgsRuleBasedRenderer.Rule(None)

    # Add rules based on available feature colors
    if has_colors['red']:
        root_rule.appendChild(create_colored_rule('red', 'Deleted'))
    if has_colors['yellow']:
        root_rule.appendChild(create_colored_rule('yellow', 'Updated'))

    # Blue features always present
    root_rule.appendChild(create_colored_rule('blue', 'Existent'))

    # Apply the rule-based renderer
    renderer = QgsRuleBasedRenderer(root_rule)
    layer.setRenderer(renderer)
    layer.triggerRepaint()
