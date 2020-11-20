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
from functools import partial
from random import randrange

from qgis.gui import QgsMapTool, QgsRubberBand
from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtGui import QColor, QCursor, QPixmap
from qgis.PyQt.QtWidgets import QDockWidget, QApplication, QPushButton
from qgis.core import QgsExpressionContextUtils, QgsProject, QgsPointLocator, \
    QgsSnappingUtils, QgsTolerance, QgsPointXY, QgsFeatureRequest, QgsRectangle, QgsSymbol, \
    QgsLineSymbol, QgsRendererCategory, QgsCategorizedSymbolRenderer

from . import tools_qt, tools_log
from .. import global_vars
from ..core.utils import tools_gw


class MultipleSelection(QgsMapTool):

    def __init__(self, layers, geom_type,
                 mincut=None, parent_manage=None, manage_new_psector=None, table_object=None, dialog=None, query=None):
        """
        Class constructor
        :param layers: dict of list of layers {'arc': [v_edit_node, ...]}
        :param geom_type:
        :param mincut:
        :param parent_manage:
        :param manage_new_psector:
        :param table_object:
        :param dialog:
        :param query:
        """


        self.layers = layers
        self.geom_type = geom_type
        self.iface = global_vars.iface
        self.canvas = global_vars.canvas
        self.mincut = mincut
        self.parent_manage = parent_manage
        self.manage_new_psector = manage_new_psector
        self.table_object = table_object
        self.dialog = dialog
        self.query = query

        # Call superclass constructor and set current action
        QgsMapTool.__init__(self, self.canvas)

        self.controller = global_vars.controller
        self.rubber_band = QgsRubberBand(self.canvas, 2)
        self.rubber_band.setColor(QColor(255, 100, 255))
        self.rubber_band.setFillColor(QColor(254, 178, 76, 63))
        self.rubber_band.setWidth(1)
        self.reset()
        self.selected_features = []


    def reset(self):

        self.start_point = self.end_point = None
        self.is_emitting_point = False
        self.reset_rubber_band()


    def canvasPressEvent(self, event):

        if event.button() == Qt.LeftButton:
            self.start_point = self.toMapCoordinates(event.pos())
            self.end_point = self.start_point
            self.is_emitting_point = True
            self.show_rect(self.start_point, self.end_point)


    def canvasReleaseEvent(self, event):

        self.is_emitting_point = False
        rectangle = self.get_rectangle()
        selected_rectangle = None
        key = QApplication.keyboardModifiers()

        if event.button() != Qt.LeftButton:
            self.rubber_band.hide()
            return

        # Disconnect signal to enhance process
        # We will reconnect it when processing last layer of the group
        disconnect_signal_selection_changed()

        #TODO:: Refactor manage_new_psector and mincut call

        # if self.manage_new_psector:
        #     self.manage_new_psector.disconnect_signal_selection_changed()

        for i, layer in enumerate(self.layers[self.geom_type]):
            if i == len(self.layers[self.geom_type]) - 1:
                # if self.mincut:
                #     self.mincut.connect_signal_selection_changed("mincut_connec")
                #
                # if self.parent_manage:
                #     connect_signal_selection_changed(self.dialog, self.table_object, layers=self.layers)

                # if self.manage_new_psector:
                #     self.manage_new_psector.connect_signal_selection_changed(
                #         self.manage_new_psector.dlg_plan_psector, self.table_object)
                connect_signal_selection_changed(self.dialog, self.table_object, query=self.query,
                                                 geom_type = self.geom_type, layers = self.layers)


                # Selection by rectangle
            if rectangle:
                if selected_rectangle is None:
                    selected_rectangle = self.canvas.mapSettings().mapToLayerCoordinates(layer, rectangle)
                # If Ctrl+Shift clicked: remove features from selection
                if key == (Qt.ControlModifier | Qt.ShiftModifier):
                    layer.selectByRect(selected_rectangle, layer.RemoveFromSelection)
                # If Ctrl clicked: add features to selection
                elif key == Qt.ControlModifier:
                    layer.selectByRect(selected_rectangle, layer.AddToSelection)
                # If Ctrl not clicked: add features to selection
                else:
                    layer.selectByRect(selected_rectangle, layer.AddToSelection)

            # Selection one by one
            else:
                event_point = self.get_event_point(event)
                result = self.snap_to_background_layers(event_point)
                if result.isValid():
                    # Get the point. Leave selection
                    self.get_snapped_feature(result, True)

        self.rubber_band.hide()


    def canvasMoveEvent(self, event):

        if not self.is_emitting_point:
            return

        self.end_point = self.toMapCoordinates(event.pos())
        self.show_rect(self.start_point, self.end_point)


    def show_rect(self, start_point, end_point):

        self.reset_rubber_band()
        if start_point.x() == end_point.x() or start_point.y() == end_point.y():
            return

        point1 = QgsPointXY(start_point.x(), start_point.y())
        point2 = QgsPointXY(start_point.x(), end_point.y())
        point3 = QgsPointXY(end_point.x(), end_point.y())
        point4 = QgsPointXY(end_point.x(), start_point.y())

        self.rubber_band.addPoint(point1, False)
        self.rubber_band.addPoint(point2, False)
        self.rubber_band.addPoint(point3, False)
        self.rubber_band.addPoint(point4, True)
        self.rubber_band.show()


    def get_rectangle(self):

        if self.start_point is None or self.end_point is None:
            return None
        elif self.start_point.x() == self.end_point.x() or self.start_point.y() == self.end_point.y():
            return None

        return QgsRectangle(self.start_point, self.end_point)


    def deactivate(self):

        self.rubber_band.hide()
        QgsMapTool.deactivate(self)


    def activate(self):
        pass


    def reset_rubber_band(self):

        try:
            self.rubber_band.reset(2)
        except:
            pass


def get_visible_layers(as_list=False):
    """ Return string as {...} or [...] with name of table in DB of all visible layer in TOC """

    visible_layer = '{'
    if as_list is True:
        visible_layer = '['
    layers = global_vars.controller.get_layers()
    for layer in layers:
        if global_vars.controller.is_layer_visible(layer):
            table_name = global_vars.controller.get_layer_source_table_name(layer)
            table = layer.dataProvider().dataSourceUri()
            # TODO:: Find differences between PostgreSQL and query layers, and replace this if condition.
            if 'SELECT row_number() over ()' in str(table) or 'srid' not in str(table):
                continue

            visible_layer += f'"{table_name}", '
    visible_layer = visible_layer[:-2]

    if as_list is True:
        visible_layer += ']'
    else:
        visible_layer += '}'
    return visible_layer


def get_value_from_metadata(parameter, default_value):
    """ Get @parameter from metadata.txt file """

    # Check if metadata file exists
    metadata_file = os.path.join(global_vars.plugin_dir, 'metadata.txt')
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


def get_qgis_project_variables():
    """ Manage QGIS project variables """

    project_vars = {}
    project_vars['infotype'] = get_project_variable('gwInfoType')
    project_vars['add_schema'] = get_project_variable('gwAddSchema')
    project_vars['main_schema'] = get_project_variable('gwMainSchema')
    project_vars['role'] = get_project_variable('gwProjectRole')
    project_vars['projecttype'] = get_project_variable('gwProjectType')

    return project_vars


def enable_python_console():
    """ Enable Python console and Log Messages panel if parameter 'enable_python_console' = True """

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


def qgis_get_layers():
    """ Return layers in the same order as listed in TOC """

    layers = [layer.layer() for layer in QgsProject.instance().layerTreeRoot().findLayers()]

    return layers


def qgis_get_layer_source(layer):
    """ Get database connection paramaters of @layer """

    # Initialize variables
    layer_source = {'db': None, 'schema': None, 'table': None,
                    'host': None, 'port': None, 'user': None, 'password': None, 'sslmode': None}

    if layer is None:
        return layer_source

    if layer.providerType() != 'postgres':
        return layer_source
    
    # Get dbname, host, port, user and password
    uri = layer.dataProvider().dataSourceUri()

    # Initialize variables
    layer_source = {'db': None, 'schema': None, 'table': None, 'service': None,
                    'host': None, 'port': None, 'user': None, 'password': None, 'sslmode': None}

    # split with quoted substrings preservation
    splt = shlex.split(uri)

    splt_dct = dict([tuple(v.split('=')) for v in splt if '=' in v])
    splt_dct['db'] = splt_dct['dbname']
    splt_dct['schema'], splt_dct['table'] = splt_dct['table'].split('.')

    for key in layer_source.keys():
        layer_source[key] = splt_dct.get(key)

    return layer_source


def qgis_get_layer_source_table_name(layer):
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


def qgis_get_layer_schema(layer):
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


def qgis_get_layer_primary_key(layer=None):
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


def qgis_get_layer_by_tablename(tablename, show_warning=False, log_info=False, schema_name=None):
    """ Iterate over all layers and get the one with selected @tablename """

    # Check if we have any layer loaded
    layers = qgis_get_layers()
    if len(layers) == 0:
        return None

    # Iterate over all layers
    layer = None
    project_vars = get_qgis_project_variables()
    if schema_name is None:
        schema_name = project_vars['main_schema']
    for cur_layer in layers:
        uri_table = qgis_get_layer_source_table_name(cur_layer)
        table_schema = qgis_get_layer_schema(cur_layer)
        if (uri_table is not None and uri_table == tablename) and schema_name in ('', None, table_schema):
            layer = cur_layer
            break

    if layer is None and show_warning:
        pass
        #self.show_warning("Layer not found", parameter=tablename)

    if layer is None and log_info:
        pass
        #self.log_info("Layer not found", parameter=tablename)

    return layer


def qgis_manage_snapping_layer(layername, snapping_type=0, tolerance=15.0):
    """ Manage snapping of @layername """

    layer = qgis_get_layer_by_tablename(layername)
    if not layer:
        return
    if snapping_type == 0:
        snapping_type = QgsPointLocator.Vertex
    elif snapping_type == 1:
        snapping_type = QgsPointLocator.Edge
    elif snapping_type == 2:
        snapping_type = QgsPointLocator.All

    QgsSnappingUtils.LayerConfig(layer, snapping_type, tolerance, QgsTolerance.Pixels)


# Snapping utilities
# TODO: Maybe find a better solution
def get_layer(tablename):
    return global_vars.controller.get_layer_by_tablename(tablename)


def remove_selection(remove_groups=True, layers=None):
    """ Remove all previous selections """

    layer = global_vars.controller.get_layer_by_tablename("v_edit_arc")
    if layer:
        layer.removeSelection()
    layer = global_vars.controller.get_layer_by_tablename("v_edit_node")
    if layer:
        layer.removeSelection()
    layer = global_vars.controller.get_layer_by_tablename("v_edit_connec")
    if layer:
        layer.removeSelection()
    layer = global_vars.controller.get_layer_by_tablename("v_edit_element")
    if layer:
        layer.removeSelection()

    if global_vars.project_type == 'ud':
        layer = global_vars.controller.get_layer_by_tablename("v_edit_gully")
        if layer:
            layer.removeSelection()

    try:
        if remove_groups:
            for layer in layers['arc']:
                layer.removeSelection()
            for layer in layers['node']:
                layer.removeSelection()
            for layer in layers['connec']:
                layer.removeSelection()
            for layer in layers['gully']:
                layer.removeSelection()
            for layer in layers['element']:
                layer.removeSelection()
    except:
        pass

    global_vars.canvas.refresh()

    return layers


def selection_init(dialog, table_object, query=False, geom_type=None, layers=None):
    """ Set canvas map tool to an instance of class 'MultipleSelection' """

    geom_type = tools_gw.tab_feature_changed(dialog)
    if geom_type in ('all', None):
        geom_type = 'arc'
    multiple_selection = MultipleSelection(layers, geom_type, parent_manage=None,
                                           table_object=table_object, dialog=dialog, query=query)
    global_vars.canvas.setMapTool(multiple_selection)

    cursor = get_cursor_multiple_selection()
    global_vars.canvas.setCursor(cursor)


def selection_changed(dialog, table_object, geom_type, query=False, plan_om=None, layers=None,
                      list_ids={"arc":[], "node":[], "connec":[], "gully":[], "element":[]}, lazy_widget=None,
                      lazy_init_function=None):
    """ Slot function for signal 'canvas.selectionChanged' """
    disconnect_signal_selection_changed()
    field_id = f"{geom_type}_id"

    ids = []
    if layers is None: return

    # Iterate over all layers of the group
    for layer in layers[geom_type]:
        if layer.selectedFeatureCount() > 0:
            # Get selected features of the layer
            features = layer.selectedFeatures()
            for feature in features:
                # Append 'feature_id' into the list
                selected_id = feature.attribute(field_id)
                if selected_id not in ids:
                    ids.append(selected_id)

    for id in ids:
        list_ids[geom_type].append(int(id))

    expr_filter = None
    if len(ids) > 0:
        # Set 'expr_filter' with features that are in the list
        expr_filter = f'"{field_id}" IN ('
        for i in range(len(ids)):
            expr_filter += f"'{ids[i]}', "
        expr_filter = expr_filter[:-2] + ")"

        # Check expression
        (is_valid, expr) = tools_qt.check_expression_filter(expr_filter)  # @UnusedVariable
        if not is_valid:
            return

        select_features_by_ids(geom_type, expr, layers=layers)

    # Reload contents of table 'tbl_@table_object_x_@geom_type'
    if query:
        insert_feature_to_plan(dialog, geom_type, ids=ids)
        if plan_om == 'plan':
            layers = remove_selection()
        tools_qt.reload_qtable(dialog, geom_type)
    else:
        tools_qt.reload_table(dialog, table_object, geom_type, expr_filter)
        tools_qt.set_lazy_init(table_object, lazy_widget=lazy_widget, lazy_init_function=lazy_init_function)

    # Remove selection in generic 'v_edit' layers
    if plan_om == 'plan':
        layers = remove_selection(False)

    tools_gw.enable_feature_type(dialog, table_object, ids=ids)

    return ids, layers, list_ids


def select_features_by_ids(geom_type, expr, layers=None):
    """ Select features of layers of group @geom_type applying @expr """

    if layers is None: return

    if not geom_type in layers: return

    # Build a list of feature id's and select them
    for layer in layers[geom_type]:
        if expr is None:
            layer.removeSelection()
        else:
            it = layer.getFeatures(QgsFeatureRequest(expr))
            id_list = [i.id() for i in it]
            if len(id_list) > 0:
                layer.selectByIds(id_list)
            else:
                layer.removeSelection()


def insert_feature(dialog, table_object, query=False, remove_ids=True, geom_type=None, ids=None, layers=None,
                   list_ids=None, lazy_widget=None, lazy_init_function=None):
    """ Select feature with entered id. Set a model with selected filter.
        Attach that model to selected table
    """

    disconnect_signal_selection_changed()

    if geom_type in ('all', None):
        geom_type = tools_gw.tab_feature_changed(dialog)

    # Clear list of ids
    if remove_ids:
        ids = []

    field_id = f"{geom_type}_id"
    feature_id = tools_qt.getWidgetText(dialog, "feature_id")
    expr_filter = f"{field_id} = '{feature_id}'"

    # Check expression
    (is_valid, expr) = tools_qt.check_expression_filter(expr_filter)
    if not is_valid:
        return None

    # Select features of layers applying @expr
    select_features_by_ids(geom_type, expr, layers=layers)

    if feature_id == 'null':
        message = "You need to enter a feature id"
        tools_qt.show_info_box(message)
        return

    # Iterate over all layers of the group
    for layer in layers[geom_type]:
        if layer.selectedFeatureCount() > 0:
            # Get selected features of the layer
            features = layer.selectedFeatures()
            for feature in features:
                # Append 'feature_id' into the list
                selected_id = feature.attribute(field_id)
                if selected_id not in ids:
                    ids.append(selected_id)
        if feature_id not in ids:
            # If feature id doesn't exist in list -> add
            ids.append(str(feature_id))

    # Set expression filter with features in the list
    expr_filter = f'"{field_id}" IN (  '
    for i in range(len(ids)):
        expr_filter += f"'{ids[i]}', "
    expr_filter = expr_filter[:-2] + ")"

    # Check expression
    (is_valid, expr) = tools_qt.check_expression_filter(expr_filter)
    if not is_valid:
        return

    # Select features with previous filter
    # Build a list of feature id's and select them
    for layer in layers[geom_type]:
        it = layer.getFeatures(QgsFeatureRequest(expr))
        id_list = [i.id() for i in it]
        if len(id_list) > 0:
            layer.selectByIds(id_list)

    # Reload contents of table 'tbl_???_x_@geom_type'
    if query:
        insert_feature_to_plan(dialog, geom_type, ids=ids)
        layers = remove_selection()
    else:
        tools_qt.reload_table(dialog, table_object, geom_type, expr_filter)
        tools_qt.set_lazy_init(table_object, lazy_widget=lazy_widget, lazy_init_function=lazy_init_function)

    # Update list
    list_ids[geom_type] = ids
    tools_gw.enable_feature_type(dialog, table_object, ids=ids)
    connect_signal_selection_changed(dialog, table_object, geom_type)

    tools_log.log_info(list_ids[geom_type])

    return ids, layers, list_ids


def insert_feature_to_plan(dialog, geom_type, ids=None):
    """ Insert features_id to table plan_@geom_type_x_psector """

    value = tools_qt.getWidgetText(dialog, dialog.psector_id)
    for i in range(len(ids)):
        sql = f"INSERT INTO plan_psector_x_{geom_type} ({geom_type}_id, psector_id) "
        sql += f"VALUES('{ids[i]}', '{value}') ON CONFLICT DO NOTHING;"
        global_vars.controller.execute_sql(sql)
        tools_qt.reload_qtable(dialog, geom_type)


def disconnect_snapping():
    """ Select 'Pan' as current map tool and disconnect snapping """

    try:
        global_vars.iface.actionPan().trigger()
        global_vars.canvas.xyCoordinates.disconnect()
    except:
        pass


def refresh_map_canvas(restore_cursor=False):
    """ Refresh all layers present in map canvas """

    global_vars.canvas.refreshAllLayers()
    for layer_refresh in global_vars.canvas.layers():
        layer_refresh.triggerRepaint()

    if restore_cursor:
        set_cursor_restore()


def set_cursor_wait():
    """ Change cursor to 'WaitCursor' """
    QApplication.setOverrideCursor(Qt.WaitCursor)


def set_cursor_restore():
    """ Restore to previous cursors """
    QApplication.restoreOverrideCursor()


def get_cursor_multiple_selection():
    """ Set cursor for multiple selection """

    path_folder = os.path.join(os.path.dirname(__file__), os.pardir)
    path_cursor = os.path.join(path_folder, f"icons{os.sep}shared", '201.png')
    if os.path.exists(path_cursor):
        cursor = QCursor(QPixmap(path_cursor))
    else:
        cursor = QCursor(Qt.ArrowCursor)

    return cursor


def disconnect_signal_selection_changed():
    """ Disconnect signal selectionChanged """

    try:
        global_vars.canvas.selectionChanged.disconnect()
    except Exception as e:
        pass
    finally:
        global_vars.iface.actionPan().trigger()


def connect_signal_selection_changed(dialog, table_object, query=False, geom_type=None, layers=None, form=None,
                                    list_ids=None):
    """ Connect signal selectionChanged """

    try:
        if geom_type in ('all', None):
            geom_type = 'arc'
        if form == "psector":
            global_vars.canvas.selectionChanged.connect(
                partial(selection_changed, dialog, table_object, geom_type, query, plan_om='plan',
                        layers=layers, list_ids=list_ids))
        else:
            global_vars.canvas.selectionChanged.connect(
                partial(selection_changed, dialog, table_object, geom_type, query, layers=layers))
    except Exception as e:
        tools_log.log_info(f"connect_signal_selection_changed: {e}")


def zoom_to_selected_features(layer, geom_type=None, zoom=None):
    """ Zoom to selected features of the @layer with @geom_type """

    if not layer:
        return

    global_vars.iface.setActiveLayer(layer)
    global_vars.iface.actionZoomToSelected().trigger()

    if geom_type and zoom:

        # Set scale = scale_zoom
        if geom_type in ('node', 'connec', 'gully'):
            scale = zoom

        # Set scale = max(current_scale, scale_zoom)
        elif geom_type == 'arc':
            scale = global_vars.iface.mapCanvas().scale()
            if int(scale) < int(zoom):
                scale = zoom
        else:
            scale = 5000

        if zoom is not None:
            scale = zoom

        global_vars.iface.mapCanvas().zoomScale(float(scale))


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
    """ Returns the minimum rectangle(x1, y1, x2, y2) of a series of coordinates
    :type list_coord: list of coors in format ['x1 y1', 'x2 y2',....,'x99 y99']
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

    rect = QgsRectangle(float(x1) + margin, float(y1) + margin, float(x2) - margin, float(y2) - margin)
    global_vars.canvas.setExtent(rect)
    global_vars.canvas.refresh()


def get_composers_list():

    layour_manager = QgsProject.instance().layoutManager().layouts()
    active_composers = [layout for layout in layour_manager]
    return active_composers


def get_composer_index(name):

    index = 0
    composers = get_composers_list()
    for comp_view in composers:
        composer_name = comp_view.name()
        if composer_name == name:
            break
        index += 1

    return index


def get_geometry_vertex(list_coord=None):
    """ Return list of QgsPoints taken from geometry
    :type list_coord: list of coors in format ['x1 y1', 'x2 y2',....,'x99 y99']
    """

    coords = list_coord.group(1)
    polygon = coords.split(',')
    points = []

    for i in range(0, len(polygon)):
        x, y = polygon[i].split(' ')
        point = QgsPointXY(float(x), float(y))
        points.append(point)

    return points


def resetRubberbands(rubber_band):

    rubber_band.reset()


def restore_user_layer(user_current_layer=None):

    if user_current_layer:
        global_vars.iface.setActiveLayer(user_current_layer)
    else:
        layer = global_vars.controller.get_layer_by_tablename('v_edit_node')
        if layer:
            global_vars.iface.setActiveLayer(layer)


def set_layer_categoryze(layer, cat_field, size, color_values, unique_values=None):
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


def remove_layer_from_toc(layer_name, group_name):
    """ Delete layer from toc if exist

     :param layer_name: Name's layer (string)
     :param group_name: Name's group (string)
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


def plugin_settings_value(key, default_value=""):

    key = global_vars.plugin_name + "/" + key
    value = global_vars.qgis_settings.value(key, default_value)
    return value


def plugin_settings_set_value(key, value):
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