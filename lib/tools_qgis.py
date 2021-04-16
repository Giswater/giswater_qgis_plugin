"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import configparser
import console
import os.path
import shlex
import sys
from random import randrange

from qgis.PyQt.QtCore import Qt, QTimer, QSettings
from qgis.PyQt.QtGui import QColor
from qgis.PyQt.QtWidgets import QDockWidget, QApplication
from qgis.core import QgsExpressionContextUtils, QgsProject, QgsPointLocator, \
    QgsSnappingUtils, QgsTolerance, QgsPointXY, QgsFeatureRequest, QgsRectangle, QgsSymbol, \
    QgsLineSymbol, QgsRendererCategory, QgsCategorizedSymbolRenderer, QgsGeometry
from qgis.core import QgsVectorLayer

from . import tools_log, tools_qt, tools_os
from .. import global_vars

# List of user parameters (optionals)
user_parameters = {'log_sql': None, 'show_message_durations': None, 'aux_context': 'ui_message'}


def show_message(text, message_level=1, duration=10, context_name=None, parameter=None, title="", logger_file=True):
    """
    Show message to the user with selected message level
        :param text: The text to be shown (String)
        :param message_level: {INFO = 0(blue), WARNING = 1(yellow), CRITICAL = 2(red), SUCCESS = 3(green)}
        :param duration: The duration of the message (int)
        :param context_name: Where to look for translating the message
        :param parameter: A text to show after the message (String)
        :param title: The title of the message (String)
        :param logger_file: Whether it should log the message in a file or not (bool)
    """

    global user_parameters

    # Get optional parameter 'show_message_durations'
    dev_duration = None
    if 'show_message_durations' in user_parameters:
        dev_duration = user_parameters['show_message_durations']
    # If is set, use this value
    if dev_duration not in (None, "None"):
        duration = int(dev_duration)

    msg = None
    if text:
        msg = tools_qt.tr(text, context_name, user_parameters['aux_context'])
        if parameter:
            msg += f": {parameter}"

    # Show message
    if len(global_vars.session_vars['threads']) == 0:
        global_vars.iface.messageBar().pushMessage(title, msg, message_level, duration)

    # Check if logger to file
    if global_vars.logger and logger_file:
        global_vars.logger.info(text)


def show_info(text, duration=10, context_name=None, parameter=None, logger_file=True, title=""):
    """
    Show information message to the user
        :param text: The text to be shown (String)
        :param duration: The duration of the message (int)
        :param context_name: Where to look for translating the message
        :param parameter: A text to show after the message (String)
        :param logger_file: Whether it should log the message in a file or not (bool)
        :param title: The title of the message (String) """

    show_message(text, 0, duration, context_name, parameter, title, logger_file)


def show_warning(text, duration=10, context_name=None, parameter=None, logger_file=True, title=""):
    """
    Show warning message to the user
        :param text: The text to be shown (String)
        :param duration: The duration of the message (int)
        :param context_name: Where to look for translating the message
        :param parameter: A text to show after the message (String)
        :param logger_file: Whether it should log the message in a file or not (bool)
        :param title: The title of the message (String) """

    show_message(text, 1, duration, context_name, parameter, title, logger_file)


def show_critical(text, duration=10, context_name=None, parameter=None, logger_file=True, title=""):
    """
    Show critical message to the user
        :param text: The text to be shown (String)
        :param duration: The duration of the message (int)
        :param context_name: Where to look for translating the message
        :param parameter: A text to show after the message (String)
        :param logger_file: Whether it should log the message in a file or not (bool)
        :param title: The title of the message (String) """

    show_message(text, 2, duration, context_name, parameter, title, logger_file)


def get_visible_layers(as_str_list=False, as_list=False):
    """
    Return string as {...} or [...] or list with name of table in DB of all visible layer in TOC
        False, False --> return str like {"name1", "name2", "..."}

        True, False --> return str like ["name1", "name2", "..."]

        xxxx, True --> return list like ['name1', 'name2', '...']
    """

    layers_name = []
    visible_layer = '{'
    if as_str_list:
        visible_layer = '['
    layers = get_project_layers()
    for layer in layers:
        if not check_query_layer(layer): continue
        if is_layer_visible(layer):
            table_name = get_layer_source_table_name(layer)
            if not check_query_layer(layer): continue
            layers_name.append(table_name)
            visible_layer += f'"{table_name}", '
    visible_layer = visible_layer[:-2]

    if as_list:
        return layers_name

    if as_str_list:
        visible_layer += ']'
    else:
        visible_layer += '}'

    return visible_layer


def get_plugin_metadata(parameter, default_value, plugin_dir=global_vars.plugin_dir):
    """ Get @parameter from metadata.txt file """

    # Check if metadata file exists
    metadata_file = os.path.join(plugin_dir, 'metadata.txt')
    if not os.path.exists(metadata_file):
        message = f"Metadata file not found: {metadata_file}"
        global_vars.iface.messageBar().pushMessage("", message, 1, 20)
        return default_value

    value = None
    try:
        metadata = configparser.ConfigParser()
        metadata.read(metadata_file)
        value = metadata.get('general', parameter)
    except configparser.NoOptionError:
        message = f"Parameter not found: {parameter}"
        global_vars.iface.messageBar().pushMessage("", message, 1, 20)
        value = default_value
    finally:
        return value


def get_plugin_version():
    """ Get plugin version from metadata.txt file """

    # Check if metadata file exists
    plugin_version = None
    message = None
    metadata_file = os.path.join(global_vars.plugin_dir, 'metadata.txt')
    if not os.path.exists(metadata_file):
        message = f"Metadata file not found: {metadata_file}"
        return plugin_version, message

    metadata = configparser.ConfigParser()
    metadata.read(metadata_file)
    plugin_version = metadata.get('general', 'version')
    if plugin_version is None:
        message = "Plugin version not found"

    return plugin_version, message


def get_major_version(default_version='3.5', plugin_dir=global_vars.plugin_dir):
    """ Get plugin higher version from metadata.txt file """

    major_version = get_plugin_metadata('version', default_version, plugin_dir)[0:3]
    return major_version


def get_build_version(default_version='35001', plugin_dir=global_vars.plugin_dir):
    """ Get plugin build version from metadata.txt file """

    build_version = get_plugin_metadata('version', default_version, plugin_dir).replace(".", "")
    return build_version


def get_project_variables():
    """ Manage QGIS project variables """

    global_vars.project_vars = {}
    global_vars.project_vars['info_type'] = get_project_variable('gwInfoType')
    global_vars.project_vars['add_schema'] = get_project_variable('gwAddSchema')
    global_vars.project_vars['main_schema'] = get_project_variable('gwMainSchema')
    global_vars.project_vars['project_role'] = get_project_variable('gwProjectRole')
    global_vars.project_vars['project_type'] = get_project_variable('gwProjectType')


def enable_python_console():
    """ Enable Python console and Log Messages panel """

    # Manage Python console
    python_console = global_vars.iface.mainWindow().findChild(QDockWidget, 'PythonConsole')
    if python_console:
        python_console.setVisible(True)
    else:
        console.show_console()

    # Manage Log Messages panel
    message_log = global_vars.iface.mainWindow().findChild(QDockWidget, 'MessageLog')
    if message_log:
        message_log.setVisible(True)


def get_project_variable(var_name):
    """ Get project variable """

    value = None
    try:
        value = QgsExpressionContextUtils.projectScope(QgsProject.instance()).variable(var_name)
    except Exception:
        pass
    finally:
        return value


def get_project_layers():
    """ Return layers in the same order as listed in TOC """

    layers = [layer.layer() for layer in QgsProject.instance().layerTreeRoot().findLayers()]

    return layers


def get_layer_source(layer):
    """ Get database connection paramaters of @layer """

    # Initialize variables
    layer_source = {'db': None, 'schema': None, 'table': None, 'service': None, 'host': None, 'port': None,
                    'user': None, 'password': None, 'sslmode': None}

    if layer is None:
        return layer_source

    if layer.providerType() != 'postgres':
        return layer_source
    
    # Get dbname, host, port, user and password
    uri = layer.dataProvider().dataSourceUri()

    # split with quoted substrings preservation
    splt = shlex.split(uri)

    list_uri = []
    for v in splt:
        if '=' in v:
            elem_uri = tuple(v.split('='))
            if len(elem_uri) == 2:
                list_uri.append(elem_uri)

    splt_dct = dict(list_uri)
    if 'service' in splt_dct:
        splt_dct['service'] = splt_dct['service']
    if 'dbname' in splt_dct:
        splt_dct['db'] = splt_dct['dbname']
    if 'table' in splt_dct:
        splt_dct['schema'], splt_dct['table'] = splt_dct['table'].split('.')

    for key in layer_source.keys():
        layer_source[key] = splt_dct.get(key)

    return layer_source


def get_layer_source_table_name(layer):
    """ Get table or view name of selected layer """

    if layer is None:
        return None

    uri_table = None
    uri = layer.dataProvider().dataSourceUri().lower()
    pos_ini = uri.find('table=')
    pos_end_schema = uri.rfind('.')
    pos_fi = uri.find('" ')
    if pos_ini != -1 and pos_fi != -1:
        uri_table = uri[pos_end_schema + 2:pos_fi]

    return uri_table


def get_layer_schema(layer):
    """ Get table or view schema_name of selected layer """

    if layer is None:
        return None

    table_schema = None
    uri = layer.dataProvider().dataSourceUri().lower()

    pos_ini = uri.find('table=')
    pos_end_schema = uri.rfind('.')
    pos_fi = uri.find('" ')
    if pos_ini != -1 and pos_fi != -1:
        table_schema = uri[pos_ini + 7:pos_end_schema - 1]

    return table_schema


def get_primary_key(layer=None):
    """ Get primary key of selected layer """

    uri_pk = None
    if layer is None:
        layer = global_vars.iface.activeLayer()
    if layer is None:
        return uri_pk
    uri = layer.dataProvider().dataSourceUri().lower()
    pos_ini = uri.find('key=')
    pos_end = uri.rfind('srid=')
    if pos_ini != -1:
        uri_pk = uri[pos_ini + 5:pos_end - 2]

    return uri_pk


def get_layer_by_tablename(tablename, show_warning_=False, log_info=False, schema_name=None):
    """ Iterate over all layers and get the one with selected @tablename """

    # Check if we have any layer loaded
    layers = get_project_layers()
    if len(layers) == 0:
        return None

    # Iterate over all layers
    layer = None
    get_project_variables()
    if schema_name is None:
        if 'main_schema' in global_vars.project_vars:
            schema_name = global_vars.project_vars['main_schema']
        else:
            tools_log.log_warning("Key not found", parameter='main_schema')

    for cur_layer in layers:
        uri_table = get_layer_source_table_name(cur_layer)
        table_schema = get_layer_schema(cur_layer)
        if (uri_table is not None and uri_table == tablename) and schema_name in ('', None, table_schema):
            layer = cur_layer
            break

    if layer is None and show_warning_:
        show_warning("Layer not found", parameter=tablename)

    if layer is None and log_info:
        tools_log.log_info("Layer not found", parameter=tablename)

    return layer


def manage_snapping_layer(layername, snapping_type=0, tolerance=15.0):
    """ Manage snapping of @layername """

    layer = get_layer_by_tablename(layername)
    if not layer:
        return
    if snapping_type == 0:
        snapping_type = QgsPointLocator.Vertex
    elif snapping_type == 1:
        snapping_type = QgsPointLocator.Edge
    elif snapping_type == 2:
        snapping_type = QgsPointLocator.All

    QgsSnappingUtils.LayerConfig(layer, snapping_type, tolerance, QgsTolerance.Pixels)


def select_features_by_ids(feature_type, expr, layers=None):
    """ Select features of layers of group @feature_type applying @expr """

    if layers is None: return

    if feature_type not in layers: return

    # Build a list of feature id's and select them
    for layer in layers[feature_type]:
        if expr is None:
            layer.removeSelection()
        else:
            it = layer.getFeatures(QgsFeatureRequest(expr))
            id_list = [i.id() for i in it]
            if len(id_list) > 0:
                layer.selectByIds(id_list)
            else:
                layer.removeSelection()


def get_points_from_geometry(layer, feature):
    """ Get the start point and end point of the feature """

    list_points = None

    geom = feature.geometry()
    if layer.geometryType() == 0:
        points = geom.asPoint()
        list_points = f'"x1":{points.x()}, "y1":{points.y()}'
    elif layer.geometryType() in (1, 2):
        points = geom.asPolyline()
        init_point = points[0]
        last_point = points[-1]
        list_points = f'"x1":{init_point.x()}, "y1":{init_point.y()}'
        list_points += f', "x2":{last_point.x()}, "y2":{last_point.y()}'
    else:
        tools_log.log_info(str(type("NO FEATURE TYPE DEFINED")))

    return list_points


def disconnect_snapping(action_pan=True, emit_point=None, vertex_marker=None):
    """ Select 'Pan' as current map tool and disconnect snapping """

    try:
        global_vars.canvas.xyCoordinates.disconnect()
    except TypeError as e:
        tools_log.log_info(f"{type(e).__name__} --> {e}")

    if emit_point is not None:
        try:
            emit_point.canvasClicked.disconnect()
        except TypeError as e:
            tools_log.log_info(f"{type(e).__name__} --> {e}")

    if vertex_marker is not None:
        try:
            vertex_marker.hide()
        except AttributeError as e:
            tools_log.log_info(f"{type(e).__name__} --> {e}")

    if action_pan:
        global_vars.iface.actionPan().trigger()


def refresh_map_canvas(_restore_cursor=False):
    """ Refresh all layers present in map canvas """

    global_vars.canvas.refreshAllLayers()
    for layer_refresh in global_vars.canvas.layers():
        layer_refresh.triggerRepaint()

    if _restore_cursor:
        restore_cursor()


def set_cursor_wait():
    """ Change cursor to 'WaitCursor' """
    QApplication.setOverrideCursor(Qt.WaitCursor)


def restore_cursor():
    """ Restore to previous cursors """
    QApplication.restoreOverrideCursor()


def disconnect_signal_selection_changed():
    """ Disconnect signal selectionChanged """

    try:
        global_vars.canvas.selectionChanged.disconnect()
    except Exception:
        pass
    finally:
        global_vars.iface.actionPan().trigger()


def select_features_by_expr(layer, expr):
    """ Select features of @layer applying @expr """

    if not layer:
        return

    if expr is None:
        layer.removeSelection()
    else:
        it = layer.getFeatures(QgsFeatureRequest(expr))
        # Build a list of feature id's from the previous result and select them
        id_list = [i.id() for i in it]
        if len(id_list) > 0:
            layer.selectByIds(id_list)
        else:
            layer.removeSelection()


def get_max_rectangle_from_coords(list_coord):
    """
    Returns the minimum rectangle(x1, y1, x2, y2) of a series of coordinates
        :param list_coord: list of coords in format ['x1 y1', 'x2 y2',....,'x99 y99']
    """

    coords = list_coord.group(1)
    polygon = coords.split(',')
    x, y = polygon[0].split(' ')
    min_x = x  # start with something much higher than expected min
    min_y = y
    max_x = x  # start with something much lower than expected max
    max_y = y
    for i in range(0, len(polygon)):
        x, y = polygon[i].split(' ')
        if x < min_x:
            min_x = x
        if x > max_x:
            max_x = x
        if y < min_y:
            min_y = y
        if y > max_y:
            max_y = y

    return max_x, max_y, min_x, min_y


def zoom_to_rectangle(x1, y1, x2, y2, margin=5):
    """ Generate an extension on the canvas according to the received coordinates """

    rect = QgsRectangle(float(x1) + margin, float(y1) + margin, float(x2) - margin, float(y2) - margin)
    global_vars.canvas.setExtent(rect)
    global_vars.canvas.refresh()


def get_composers_list():
    """ Returns the list of project composer """

    layour_manager = QgsProject.instance().layoutManager().layouts()
    active_composers = [layout for layout in layour_manager]
    return active_composers


def get_composer_index(name):
    """ Returns the index of the selected composer name"""

    index = 0
    composers = get_composers_list()
    for comp_view in composers:
        composer_name = comp_view.name()
        if composer_name == name:
            break
        index += 1

    return index


def get_geometry_vertex(list_coord=None):
    """
    Return list of QgsPoints taken from geometry
        :param list_coord: list of coors in format ['x1 y1', 'x2 y2',....,'x99 y99']
    """

    coords = list_coord.group(1)
    polygon = coords.split(',')
    points = []

    for i in range(0, len(polygon)):
        x, y = polygon[i].split(' ')
        point = QgsPointXY(float(x), float(y))
        points.append(point)

    return points


def reset_rubber_band(rubber_band):
    """ Reset QgsRubberBand """
    rubber_band.reset()


def restore_user_layer(layer_name, user_current_layer=None):
    """ Set active layer, preferably @user_current_layer else @layer_name """

    if user_current_layer:
        global_vars.iface.setActiveLayer(user_current_layer)
    else:
        layer = get_layer_by_tablename(layer_name)
        if layer:
            global_vars.iface.setActiveLayer(layer)


def set_layer_categoryze(layer, cat_field, size, color_values, unique_values=None):
    """
    :param layer: QgsVectorLayer to be categorized (QgsVectorLayer)
    :param cat_field: Field to categorize (String)
    :param size: Size of feature (int)
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


def remove_layer_from_toc(layer_name, group_name):
    """
    Remove layer from toc if exist
        :param layer_name: Name's layer (String)
        :param group_name: Name's group (String)
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
        group = root.findGroup(group_name)
        if group:
            layers = group.findLayers()
            if not layers:
                root.removeChildNode(group)
        remove_layer_from_toc(layer_name, group_name)


def get_plugin_settings_value(key, default_value=""):
    """ Get @value of QSettings located in @key """

    key = global_vars.plugin_name + "/" + key
    value = global_vars.qgis_settings.value(key, default_value)
    return value


def set_plugin_settings_value(key, value):
    """ Set @value to QSettings of selected @value located in @key """

    global_vars.qgis_settings.setValue(global_vars.plugin_name + "/" + key, value)


def get_layer_by_layername(layername, log_info=False):
    """ Get layer with selected @layername (the one specified in the TOC) """

    layer = QgsProject.instance().mapLayersByName(layername)
    if layer:
        layer = layer[0]
    elif not layer and log_info:
        layer = None
        tools_log.log_info("Layer not found", parameter=layername)

    return layer


def is_layer_visible(layer):
    """ Return is @layer is visible or not """

    visible = False
    if layer:
        visible = QgsProject.instance().layerTreeRoot().findLayer(layer.id()).itemVisibilityChecked()

    return visible


def set_layer_visible(layer, recursive=True, visible=True):
    """
    Set layer visible
        :param layer: layer to set visible (QgsVectorLayer)
        :param recursive: Whether it affects just the layer or all of its parents (bool)
        :param visible: Whether the layer will be visible or not (bool)
    """

    if layer:
        if recursive:
            QgsProject.instance().layerTreeRoot().findLayer(layer.id()).setItemVisibilityCheckedParentRecursive(visible)
        else:
            QgsProject.instance().layerTreeRoot().findLayer(layer.id()).setItemVisibilityChecked(visible)


def set_layer_index(layer_name):
    """ Force reload dataProvider of layer """

    layer = get_layer_by_tablename(layer_name)
    if layer:
        layer.dataProvider().reloadData()
        layer.triggerRepaint()


def load_qml(layer, qml_path):
    """
    Apply QML style located in @qml_path in @layer
        :param layer: layer to set qml (QgsVectorLayer)
        :param qml_path: desired path (String)
        :return: True or False (bool)
    """

    if layer is None:
        return False

    if not os.path.exists(qml_path):
        tools_log.log_warning("File not found", parameter=qml_path)
        return False

    if not qml_path.endswith(".qml"):
        tools_log.log_warning("File extension not valid", parameter=qml_path)
        return False

    layer.loadNamedStyle(qml_path)
    layer.triggerRepaint()

    return True


def set_margin(layer, margin):
    """ Generates a margin around the layer so that it is fully visible on the canvas """

    if layer.extent().isNull():
        return

    extent = QgsRectangle()
    extent.setMinimal()
    extent.combineExtentWith(layer.extent())
    xmin = extent.xMinimum() - margin
    ymin = extent.yMinimum() - margin
    xmax = extent.xMaximum() + margin
    ymax = extent.yMaximum() + margin
    extent.set(xmin, ymin, xmax, ymax)
    global_vars.iface.mapCanvas().setExtent(extent)
    global_vars.iface.mapCanvas().refresh()


def create_qml(layer, style):
    """ Generates a qml file through a json of styles (@style) and puts it in the received @layer """

    config_folder = f'{global_vars.user_folder_dir}{os.sep}temp'
    if not os.path.exists(config_folder):
        os.makedirs(config_folder)
    path_temp_file = f"{config_folder}{os.sep}temporal_layer.qml"
    file = open(path_temp_file, 'w')
    file.write(style)
    file.close()
    del file
    load_qml(layer, path_temp_file)


def draw_point(point, rubber_band=None, color=QColor(255, 0, 0, 100), width=3, duration_time=None):
    """
    Draw a point on the canvas
        :param point: (QgsPointXY)
        :param rubber_band: (QgsRubberBand)
        :param color: Color of the point (QColor)
        :param width: width of the point (int)
        :param duration_time: Time in milliseconds that the point will be visible. Ex: 3000 for 3 seconds (int)
    """

    rubber_band.reset(0)
    rubber_band.setIconSize(10)
    rubber_band.setColor(color)
    rubber_band.setWidth(width)
    rubber_band.addPoint(point)

    # wait to simulate a flashing effect
    if duration_time is not None:
        QTimer.singleShot(duration_time, rubber_band.reset)


def draw_polyline(points, rubber_band, color=QColor(255, 0, 0, 100), width=5, duration_time=None):
    """
    Draw 'line' over canvas following list of points
        :param points: list of QgsPointXY (points[QgsPointXY_1, QgsPointXY_2, ..., QgsPointXY_x])
        :param rubber_band: (QgsRubberBand)
        :param color: Color of the point (QColor)
        :param width: width of the point (int)
        :param duration_time: Time in milliseconds that the point will be visible. Ex: 3000 for 3 seconds (int)
     """

    rubber_band.setIconSize(20)
    polyline = QgsGeometry.fromPolylineXY(points)
    rubber_band.setToGeometry(polyline, None)
    rubber_band.setColor(color)
    rubber_band.setWidth(width)
    rubber_band.show()

    # wait to simulate a flashing effect
    if duration_time is not None:
        QTimer.singleShot(duration_time, rubber_band.reset)


def get_geometry_from_json(feature):
    """
    Get coordinates from GeoJson and return QGsGeometry

    functions called in:
        getattr(f"get_{feature['geometry']['type'].lower()}")(feature)
        def _get_vertex_from_point(feature)
        _get_vertex_from_linestring(feature)
        _get_vertex_from_multilinestring(feature)
        _get_vertex_from_polygon(feature)
        _get_vertex_from_multipolygon(feature)

        :param feature: feature to get geometry type and coordinates (GeoJson)
        :return: Geometry of the feature (QgsGeometry)

    """

    try:
        coordinates = getattr(sys.modules[__name__], f"_get_vertex_from_{feature['geometry']['type'].lower()}")(feature)
        type_ = feature['geometry']['type']
        geometry = f"{type_}{coordinates}"
        return QgsGeometry.fromWkt(geometry)
    except AttributeError as e:
        tools_log.log_info(f"{type(e).__name__} --> {e}")
        return None


def get_locale():

    locale = "en_US"
    try:
        # Get locale of QGIS application
        override = QSettings().value('locale/overrideFlag')
        if tools_os.set_boolean(override):
            locale = QSettings().value('locale/globalLocale')
        else:
            locale = QSettings().value('locale/userLocale')
    except AttributeError as e:
        locale = "en_US"
        tools_log.log_info(f"{type(e).__name__} --> {e}")
    finally:
        return locale


def hilight_feature_by_id(qtable, layer_name, field_id, rubber_band, width, index):
    """ Based on the received index and field_id, the id of the received field_id is searched within the table
     and is painted in red on the canvas """

    rubber_band.reset()
    layer = get_layer_by_tablename(layer_name)
    if not layer: return

    row = index.row()
    column_index = tools_qt.get_col_index_by_col_name(qtable, field_id)
    _id = index.sibling(row, column_index).data()
    feature = tools_qt.get_feature_by_id(layer, _id, field_id)
    try:
        geometry = feature.geometry()
        rubber_band.setToGeometry(geometry, None)
        rubber_band.setColor(QColor(255, 0, 0, 100))
        rubber_band.setWidth(width)
        rubber_band.show()
    except AttributeError:
        pass


def check_query_layer(layer):
    """
    Check for query layer and/or bad layer, if layer is a simple table, or an added layer from query, return False
        :param layer: Layer to be checked (QgsVectorLayer)
        :return: True/False (Boolean)
    """

    try:
        # TODO:: Find differences between PostgreSQL and query layers, and replace this if condition.
        table_uri = layer.dataProvider().dataSourceUri()
        if 'SELECT row_number() over ()' in str(table_uri) or 'srid' not in str(table_uri) or \
                layer is None or type(layer) != QgsVectorLayer:
            return False
        return True
    except Exception:
        return False


# region private functions

def _get_vertex_from_point(feature):
    """
    Manage feature geometry when is Point

    This function is called in def get_geometry_from_json(feature)
            geometry = getattr(f"get_{feature['geometry']['type'].lower()}")(feature)

        :param feature: feature to get geometry type and coordinates (GeoJson)
        :return: Coordinates of the feature (String)

    """
    return f"({feature['geometry']['coordinates'][0]} {feature['geometry']['coordinates'][1]})"


def _get_vertex_from_linestring(feature):
    """
    Manage feature geometry when is LineString

    This function is called in def get_geometry_from_json(feature)
          geometry = getattr(f"get_{feature['geometry']['type'].lower()}")(feature)

        :param feature: feature to get geometry type and coordinates (GeoJson)
        :return: Coordinates of the feature (String)
    """
    return _get_vertex_from_points(feature)


def _get_vertex_from_multilinestring(feature):
    """
    Manage feature geometry when is MultiLineString

    This function is called in def get_geometry_from_json(feature)
          geometry = getattr(f"get_{feature['geometry']['type'].lower()}")(feature)

        :param feature: feature to get geometry type and coordinates (GeoJson)
        :return: Coordinates of the feature (String)
    """
    return _get_multi_coordinates(feature)


def _get_vertex_from_polygon(feature):
    """
    Manage feature geometry when is Polygon

    This function is called in def get_geometry_from_json(feature)
          geometry = getattr(f"get_{feature['geometry']['type'].lower()}")(feature)

        :param feature: feature to get geometry type and coordinates (GeoJson)
        :return: Coordinates of the feature (String)
    """
    return _get_multi_coordinates(feature)


def _get_vertex_from_multipolygon(feature):
    """
    Manage feature geometry when is MultiPolygon

    This function is called in def get_geometry_from_json(feature)
          geometry = getattr(f"get_{feature['geometry']['type'].lower()}")(feature)

        :param feature: feature to get geometry type and coordinates (GeoJson)
        :return: Coordinates of the feature (String)
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


def _get_vertex_from_points(feature):
    """
    Get coordinates of the received feature, to be a point
        :param feature: Json with the information of the received feature (GeoJson)
        :return: Coordinates of the feature received (String)
    """

    coordinates = "("
    for coords in feature['geometry']['coordinates']:
        coordinates += f"{coords[0]} {coords[1]}, "
    coordinates = coordinates[:-2] + ")"
    return coordinates


def _get_multi_coordinates(feature):
    """
    Get coordinates of the received feature, can be a line
        :param feature: Json with the information of the received feature (GeoJson)
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


# endregion

