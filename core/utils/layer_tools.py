"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsCategorizedSymbolRenderer, QgsDataSourceUri, QgsFeature, QgsField, QgsGeometry, QgsFillSymbol,\
QgsMarkerSymbol, QgsLayerTreeLayer, QgsLineSymbol, QgsProject, QgsRectangle, QgsRendererCategory, \
QgsSymbol, QgsVectorLayer, QgsVectorLayerExporter
from qgis.PyQt.QtCore import QVariant
from qgis.PyQt.QtGui import QColor
from qgis.PyQt.QtWidgets import QPushButton, QTabWidget

import os
from random import randrange
import sys

from lib import qt_tools

from ... import global_vars



def get_uri():
    """ Set the component parts of a RDBMS data source URI
    :return: QgsDataSourceUri() with the connection established according to the parameters of the controller.
    """

    uri = QgsDataSourceUri()
    uri.setConnection(global_vars.controller.credentials['host'], global_vars.controller.credentials['port'],
                      global_vars.controller.credentials['db'], global_vars.controller.credentials['user'],
                      global_vars.controller.credentials['password'])
    return uri


def manage_geometry(geometry):
    """ Get QgsGeometry and return as text
     :param geometry: (QgsGeometry)
     :return: (String)
    """
    geometry = geometry.asWkt().replace('Z (', ' (')
    geometry = geometry.replace(' 0)', ')')
    return geometry


def from_dxf_to_toc(dxf_layer, dxf_output_filename):
    """  Read a dxf file and put result into TOC
    :param dxf_layer: (QgsVectorLayer)
    :param dxf_output_filename: Name of layer into TOC (string)
    :return: dxf_layer (QgsVectorLayer)
    """

    QgsProject.instance().addMapLayer(dxf_layer, False)
    root = QgsProject.instance().layerTreeRoot()
    my_group = root.findGroup(dxf_output_filename)
    if my_group is None:
        my_group = root.insertGroup(0, dxf_output_filename)
    my_group.insertLayer(0, dxf_layer)
    global_vars.canvas.refreshAllLayers()
    return dxf_layer


def export_layer_to_db(layer, crs):
    """ Export layer to postgres database
    :param layer: (QgsVectorLayer)
    :param crs: QgsVectorLayer.crs() (crs)
    """

    sql = f'DROP TABLE "{layer.name()}";'
    global_vars.controller.execute_sql(sql, log_sql=True)

    schema_name = global_vars.controller.credentials['schema'].replace('"', '')
    uri = get_uri()
    uri.setDataSource(schema_name, layer.name(), None, "", layer.name())

    error = QgsVectorLayerExporter.exportLayer(
        layer, uri.uri(), global_vars.controller.credentials['user'], crs, False)
    if error[0] != 0:
        global_vars.controller.log_info(F"ERROR --> {error[1]}")


def from_postgres_to_toc(tablename=None, the_geom="the_geom", field_id="id", child_layers=None,
    group="GW Layers", style_id="-1"):
    """ Put selected layer into TOC
    :param tablename: Postgres table name (String)
    :param the_geom: Geometry field of the table (String)
    :param field_id: Field id of the table (String)
    :param child_layers: List of layers (StringList)
    :param group: Name of the group that will be created in the toc (String)
    :param style_id: Id of the style we want to load (integer or String)
    """

    uri = get_uri()
    schema_name = global_vars.controller.credentials['schema'].replace('"', '')
    if child_layers is not None:
        for layer in child_layers:
            if layer[0] != 'Load all':
                uri.setDataSource(schema_name, f'{layer[0]}', the_geom, None, layer[1] + "_id")
                vlayer = QgsVectorLayer(uri.uri(), f'{layer[0]}', "postgres")
                group = layer[4] if layer[4] is not None else group
                group = group if group is not None else 'GW Layers'
                check_for_group(vlayer, group)
                style_id = layer[3]
                if style_id is not None:
                    body = f'$${{"data":{{"style_id":"{style_id}"}}}}$$'
                    style = global_vars.controller.get_json('gw_fct_getstyle', body, log_sql=True)
                    if 'styles' in style['body']:
                        if 'style' in style['body']['styles']:
                            qml = style['body']['styles']['style']
                            create_qml(vlayer, qml)
    else:
        uri.setDataSource(schema_name, f'{tablename}', the_geom, None, field_id)
        vlayer = QgsVectorLayer(uri.uri(), f'{tablename}', 'postgres')
        check_for_group(vlayer, group)
        # The triggered function (action.triggered.connect(partial(...)) as the last parameter sends a boolean,
        # if we define style_id = None, style_id will take the boolean of the triggered action as a fault,
        # therefore, we define it with "-1"
        if style_id not in (None, "-1"):
            body = f'$${{"data":{{"style_id":"{style_id}"}}}}$$'
            style = global_vars.controller.get_json('gw_fct_getstyle', body, log_sql=True)
            if 'styles' in style['body']:
                if 'style' in style['body']['styles']:
                    qml = style['body']['styles']['style']
                    create_qml(vlayer, qml)
    global_vars.iface.mapCanvas().refresh()


def create_qml(layer, style):

    main_folder = os.path.join(os.path.expanduser("~"), global_vars.controller.plugin_name)
    config_folder = main_folder + os.sep + "temp" + os.sep
    if not os.path.exists(config_folder):
        os.makedirs(config_folder)
    path_temp_file = config_folder + 'temp_qml.qml'
    file = open(path_temp_file, 'w')
    file.write(style)
    file.close()
    del file
    load_qml(layer, path_temp_file)


def check_for_group(layer, group=None):
    """ If the function receives a group name, check if it exists or not and put the layer in this group
    :param layer: (QgsVectorLayer)
    :param group: Name of the group that will be created in the toc (string)
    """

    if group is None:
        QgsProject.instance().addMapLayer(layer)
    else:
        QgsProject.instance().addMapLayer(layer, False)
        root = QgsProject.instance().layerTreeRoot()
        my_group = root.findGroup(group)
        if my_group is None:
            my_group = root.insertGroup(0, group)
        my_group.insertLayer(0, layer)


def add_temp_layer(dialog, data, layer_name, force_tab=True, reset_text=True, tab_idx=1, del_old_layers=True,
                   group='GW Temporal Layers', disable_tabs=True):
    """ Add QgsVectorLayer into TOC
    :param dialog:
    :param data:
    :param layer_name:
    :param force_tab:
    :param reset_text:
    :param tab_idx:
    :param del_old_layers:
    :param group:
    :param disable_tabs: set all tabs, except the last, enabled or disabled (boolean).
    :return: Dictionary with text as result of previuos data (String), and list of layers added (QgsVectorLayer).
    """

    text_result = None
    temp_layers_added = []
    srid = global_vars.srid
    for k, v in list(data.items()):
        if str(k) == "info":
            text_result = populate_info_text(dialog, data, force_tab, reset_text, tab_idx, disable_tabs)
        elif k in ('point', 'line', 'polygon'):
            if 'values' in data[k]:
                key = 'values'
            elif 'features' in data[k]:
                key = 'features'
            else:
                continue
            counter = len(data[k][key])
            if counter > 0:
                counter = len(data[k][key])
                geometry_type = data[k]['geometryType']
                try:
                    if not layer_name:
                        layer_name = data[k]['layerName']
                except KeyError:
                    layer_name = 'Temporal layer'
                if del_old_layers:
                    delete_layer_from_toc(layer_name)
                v_layer = QgsVectorLayer(f"{geometry_type}?crs=epsg:{srid}", layer_name, 'memory')
                layer_name = None
                # TODO This if controls if the function already works with GeoJson or is still to be refactored
                # once all are refactored the if should be: if 'feature' not in data [k]: continue
                if key == 'values':
                    populate_vlayer_old(v_layer, data, k, counter, group)
                elif key == 'features':
                    populate_vlayer(v_layer, data, k, counter, group)
                if 'qmlPath' in data[k] and data[k]['qmlPath']:
                    qml_path = data[k]['qmlPath']
                    load_qml(v_layer, qml_path)
                elif 'category_field' in data[k] and data[k]['category_field']:
                    cat_field = data[k]['category_field']
                    size = data[k]['size'] if 'size' in data[k] and data[k]['size'] else 2
                    color_values = {'NEW': QColor(0, 255, 0), 'DUPLICATED': QColor(255, 0, 0),
                                    'EXISTS': QColor(240, 150, 0)}
                    categoryze_layer(v_layer, cat_field, size, color_values)
                else:
                    if geometry_type == 'Point':
                        v_layer.renderer().symbol().setSize(3.5)
                        v_layer.renderer().symbol().setColor(QColor("red"))
                    elif geometry_type == 'LineString':
                        v_layer.renderer().symbol().setWidth(1.5)
                        v_layer.renderer().symbol().setColor(QColor("red"))
                    v_layer.renderer().symbol().setOpacity(0.7)
                temp_layers_added.append(v_layer)
                global_vars.iface.layerTreeView().refreshLayerSymbology(v_layer.id())
    return {'text_result': text_result, 'temp_layers_added': temp_layers_added}


def set_layers_visible(layers):
    """ Set layers visibles in the canvas
    :param layers: list of layer names
    :return:
    """
    for layer in layers:
        lyr = global_vars.controller.get_layer_by_tablename(layer)
        if lyr:
            global_vars.controller.set_layer_visible(lyr)


def categoryze_layer(layer, cat_field, size, color_values, unique_values=None):
    """
    :param layer: QgsVectorLayer to be categorized (QgsVectorLayer)
    :param cat_field: Field to categorize (string)
    :param size: Size of feature (integer)
    """

    # get unique values
    fields = layer.fields()
    fni = fields.indexOf(cat_field)
    if not unique_values:
        unique_values = layer.dataProvider().uniqueValues(fni)
    categories = []

    for unique_value in unique_values:
        # initialize the default symbol for this geometry type
        symbol = QgsSymbol.defaultSymbol(layer.geometryType())
        if type(symbol) in (QgsLineSymbol, ):
            symbol.setWidth(size)
        else:
            symbol.setSize(size)

        # configure a symbol layer
        try:
            color = color_values.get(str(unique_value))
            symbol.setColor(color)
        except Exception:
            color = QColor(randrange(0, 256), randrange(0, 256), randrange(0, 256))
            symbol.setColor(color)

        # create renderer object
        category = QgsRendererCategory(unique_value, symbol, str(unique_value))
        # entry for the list of category items
        categories.append(category)

        # create renderer object
    renderer = QgsCategorizedSymbolRenderer(cat_field, categories)

    # assign the created renderer to the layer
    if renderer is not None:
        layer.setRenderer(renderer)

    layer.triggerRepaint()
    global_vars.iface.layerTreeView().refreshLayerSymbology(layer.id())


def set_layer_symbology(layer, properties=None):
    """ Set the received symbology in the corresponding layer
    :param layer: (QgsVectorLayer)
    :param properties: Properties that we want to put on the layer (dictionary)
            example: {'capstyle': 'round', 'customdash': '5;2', 'customdash_map_unit_scale': '3x:0,0,0,0,0,0',
            'customdash_unit': 'MM', 'draw_inside_polygon': '0', 'joinstyle': 'round',
            'line_color': '76,119,220,255', 'line_style': 'solid', 'line_width': '1.6',
            'line_width_unit': 'MM', 'offset': '0', 'offset_map_unit_scale': '3x:0,0,0,0,0,0',
            'offset_unit': 'MM', 'ring_filter': '0', 'use_custom_dash': '0',
            'width_map_unit_scale': '3x:0,0,0,0,0,0'}
    :return:
    """
    renderer = layer.renderer()
    symbol = renderer.symbol()

    if type(symbol) == QgsLineSymbol:
        layer.renderer().setSymbol(QgsLineSymbol.createSimple(properties))
    elif type(symbol) == QgsMarkerSymbol:
        layer.renderer().setSymbol(QgsMarkerSymbol.createSimple(properties))
    elif type(symbol) == QgsFillSymbol:
        layer.renderer().setSymbol(QgsFillSymbol.createSimple(properties))

    layer.triggerRepaint()
    global_vars.iface.layerTreeView().refreshLayerSymbology(layer.id())


def populate_info_text(dialog, data, force_tab=True, reset_text=True, tab_idx=1, call_disable_tabs=True):
    """ Populate txt_infolog QTextEdit widget
    :param dialog: QDialog
    :param data: Json
    :param force_tab: Force show tab (boolean)
    :param reset_text: Reset(or not) text for each iteration (boolean)
    :param tab_idx: index of tab to force (integer)
    :param disable_tabs: set all tabs, except the last, enabled or disabled (boolean)
    :return: Text received from data (String)
    """

    change_tab = False
    text = qt_tools.getWidgetText(dialog, dialog.txt_infolog, return_string_null=False)

    if reset_text:
        text = ""
    for item in data['info']['values']:
        if 'message' in item:
            if item['message'] is not None:
                text += str(item['message']) + "\n"
                if force_tab:
                    change_tab = True
            else:
                text += "\n"

    qt_tools.setWidgetText(dialog, 'txt_infolog', text + "\n")
    qtabwidget = dialog.findChild(QTabWidget, 'mainTab')
    if qtabwidget is not None:
        if change_tab and qtabwidget is not None:
            qtabwidget.setCurrentIndex(tab_idx)
        if call_disable_tabs:
            disable_tabs(dialog)

    return text


def disable_tabs(dialog):
    """ Disable all tabs in the dialog except the log one and change the state of the buttons
    :param dialog: Dialog where tabs are disabled (QDialog)
    :return:
    """

    qtabwidget = dialog.findChild(QTabWidget, 'mainTab')
    for x in range(0, qtabwidget.count() - 1):
        qtabwidget.widget(x).setEnabled(False)

    btn_accept = dialog.findChild(QPushButton, 'btn_accept')
    if btn_accept:
        btn_accept.hide()

    btn_cancel = dialog.findChild(QPushButton, 'btn_cancel')
    if btn_cancel:
        qt_tools.setWidgetText(dialog, btn_accept, 'Close')


def populate_vlayer(virtual_layer, data, layer_type, counter, group='GW Temporal Layers'):
    """
    :param virtual_layer: Memory QgsVectorLayer (QgsVectorLayer)
    :param data: Json
    :param layer_type: point, line, polygon...(string)
    :param counter: control if json have values (integer)
    :param group: group to which we want to add the layer (string)
    :return:
    """

    prov = virtual_layer.dataProvider()
    # Enter editing mode
    virtual_layer.startEditing()

    # Add headers to layer
    if counter > 0:
        for key, value in list(data[layer_type]['features'][0]['properties'].items()):
            if key == 'the_geom':
                continue
            prov.addAttributes([QgsField(str(key), QVariant.String)])

    for feature in data[layer_type]['features']:
        geometry = get_geometry(feature)
        if not geometry:
            continue
        attributes = []
        fet = QgsFeature()
        fet.setGeometry(geometry)
        for key, value in feature['properties'].items():
            if key == 'the_geom':
                continue
            attributes.append(value)

        fet.setAttributes(attributes)
        prov.addFeatures([fet])

    # Commit changes
    virtual_layer.commitChanges()
    QgsProject.instance().addMapLayer(virtual_layer, False)
    root = QgsProject.instance().layerTreeRoot()
    my_group = root.findGroup(group)
    if my_group is None:
        my_group = root.insertGroup(0, group)
    my_group.insertLayer(0, virtual_layer)


def get_geometry(feature):
    """ Get coordinates from GeoJson and return QGsGeometry
    :param feature: feature to get geometry type and coordinates (GeoJson)
    :return: Geometry of the feature (QgsGeometry)
    functions  called in -> getattr(self, f"get_{feature['geometry']['type'].lower()}")(feature)
        def get_point(self, feature)
        get_linestring(self, feature)
        get_multilinestring(self, feature)
        get_polygon(self, feature)
        get_multipolygon(self, feature)
    """

    try:
        coordinates = getattr(sys.modules[__name__], f"get_{feature['geometry']['type'].lower()}")(feature)
        type_ = feature['geometry']['type']
        geometry = f"{type_}{coordinates}"
        return QgsGeometry.fromWkt(geometry)
    except AttributeError as e:
        global_vars.controller.log_info(f"{type(e).__name__} --> {e}")
        return None


def get_point(feature):
    """ Manage feature geometry when is Point
    :param feature: feature to get geometry type and coordinates (GeoJson)
    :return: Coordinates of the feature (String)
    This function is called in def get_geometry(self, feature)
          geometry = getattr(self, f"get_{feature['geometry']['type'].lower()}")(feature)
    """
    return f"({feature['geometry']['coordinates'][0]} {feature['geometry']['coordinates'][1]})"


def get_linestring(feature):
    """ Manage feature geometry when is LineString
    :param feature: feature to get geometry type and coordinates (GeoJson)
    :return: Coordinates of the feature (String)
    This function is called in def get_geometry(self, feature)
          geometry = getattr(self, f"get_{feature['geometry']['type'].lower()}")(feature)
    """
    return get_coordinates(feature)


def get_multilinestring(feature):
    """ Manage feature geometry when is MultiLineString
    :param feature: feature to get geometry type and coordinates (GeoJson)
    :return: Coordinates of the feature (String)
    This function is called in def get_geometry(self, feature)
          geometry = getattr(self, f"get_{feature['geometry']['type'].lower()}")(feature)
    """
    return get_multi_coordinates(feature)


def get_polygon(feature):
    """ Manage feature geometry when is Polygon
    :param feature: feature to get geometry type and coordinates (GeoJson)
    :return: Coordinates of the feature (String)
    This function is called in def get_geometry(self, feature)
          geometry = getattr(self, f"get_{feature['geometry']['type'].lower()}")(feature)
    """
    return get_multi_coordinates(feature)


def get_multipolygon(feature):
    """ Manage feature geometry when is MultiPolygon
    :param feature: feature to get geometry type and coordinates (GeoJson)
    :return: Coordinates of the feature (String)
    This function is called in def get_geometry(self, feature)
          geometry = getattr(self, f"get_{feature['geometry']['type'].lower()}")(feature)
    """

    coordinates = "("
    for coords in feature['geometry']['coordinates']:
        coordinates += "("
        for cc in coords:
            coordinates += "("
            for c in cc:
                coordinates += f"{c[0]} {c[1]}, "
            coordinates = coordinates[:-2] + "), "
        coordinates = coordinates[:-2] + "), "
    coordinates = coordinates[:-2] + ")"
    return coordinates


def get_coordinates(feature):
    """ Get coordinates of the received feature, to be a point
    :param feature: Json with the information of the received feature (geoJson)
    :return: Coordinates of the feature received (String)
    """

    coordinates = "("
    for coords in feature['geometry']['coordinates']:
        coordinates += f"{coords[0]} {coords[1]}, "
    coordinates = coordinates[:-2] + ")"
    return coordinates


def get_multi_coordinates(feature):
    """ Get coordinates of the received feature, can be a line
    :param feature: Json with the information of the received feature (geoJson)
    :return: Coordinates of the feature received (String)
    """

    coordinates = "("
    for coords in feature['geometry']['coordinates']:
        coordinates += "("
        for c in coords:
            coordinates += f"{c[0]} {c[1]}, "
        coordinates = coordinates[:-2] + "), "
    coordinates = coordinates[:-2] + ")"
    return coordinates


def populate_vlayer_old(virtual_layer, data, layer_type, counter, group='GW Temporal Layers'):
    """
    :param virtual_layer: Memory QgsVectorLayer (QgsVectorLayer)
    :param data: Json
    :param layer_type: point, line, polygon...(string)
    :param counter: control if json have values (integer)
    :param group: group to which we want to add the layer (string)
    :return:
    """

    prov = virtual_layer.dataProvider()

    # Enter editing mode
    virtual_layer.startEditing()
    if counter > 0:
        for key, value in list(data[layer_type]['values'][0].items()):
            # add columns
            if str(key) != 'the_geom':
                prov.addAttributes([QgsField(str(key), QVariant.String)])

    # Add features
    for item in data[layer_type]['values']:
        attributes = []
        fet = QgsFeature()

        for k, v in list(item.items()):
            if str(k) != 'the_geom':
                attributes.append(v)
            if str(k) in 'the_geom':
                sql = f"SELECT St_AsText('{v}')"
                row = global_vars.controller.get_row(sql, log_sql=False)
                if row and row[0]:
                    geometry = QgsGeometry.fromWkt(str(row[0]))
                    fet.setGeometry(geometry)
        fet.setAttributes(attributes)
        prov.addFeatures([fet])

    # Commit changes
    virtual_layer.commitChanges()
    QgsProject.instance().addMapLayer(virtual_layer, False)
    root = QgsProject.instance().layerTreeRoot()
    my_group = root.findGroup(group)
    if my_group is None:
        my_group = root.insertGroup(0, group)

    my_group.insertLayer(0, virtual_layer)


def delete_layer_from_toc(layer_name):
    """ Delete layer from toc if exist
     :param layer_name: Name's layer (string)
    """

    layer = None
    for lyr in list(QgsProject.instance().mapLayers().values()):
        if lyr.name() == layer_name:
            layer = lyr
            break
    if layer is not None:
        # Remove layer
        QgsProject.instance().removeMapLayer(layer)

        # Remove group if is void
        root = QgsProject.instance().layerTreeRoot()
        group = root.findGroup('GW Temporal Layers')
        if group:
            layers = group.findLayers()
            if not layers:
                root.removeChildNode(group)
        delete_layer_from_toc(layer_name)


def load_qml(layer, qml_path):
    """ Apply QML style located in @qml_path in @layer
    :param layer: layer to set qml (QgsVectorLayer)
    :param qml_path: desired path (string)
    :return: True or False (boolean)
    """

    if layer is None:
        return False

    if not os.path.exists(qml_path):
        global_vars.controller.log_warning("File not found", parameter=qml_path)
        return False

    if not qml_path.endswith(".qml"):
        global_vars.controller.log_warning("File extension not valid", parameter=qml_path)
        return False

    layer.loadNamedStyle(qml_path)
    layer.triggerRepaint()

    return True


def zoom_to_group(group_name, buffer=10):
    """ Make zoom to extent of the received group
    :param group_name: Group name where to zoom
    :param buffer: Space left between the group zoom and the canvas (integer)
    :return: False if don't find the group
    """

    extent = QgsRectangle()
    extent.setMinimal()

    # Iterate through layers from certain group and combine their extent
    root = QgsProject.instance().layerTreeRoot()
    group = root.findGroup(group_name)  # Adjust this to fit your group's name
    if not group:
        return False
    for child in group.children():
        if isinstance(child, QgsLayerTreeLayer):
            extent.combineExtentWith(child.layer().extent())

    xmax = extent.xMaximum() + buffer
    xmin = extent.xMinimum() - buffer
    ymax = extent.yMaximum() + buffer
    ymin = extent.yMinimum() - buffer
    extent.set(xmin, ymin, xmax, ymax)
    global_vars.iface.mapCanvas().setExtent(extent)
    global_vars.iface.mapCanvas().refresh()

