"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import configparser
import inspect
import json
import os
import random
import re
import sys
import traceback
if 'nt' in sys.builtin_module_names:
    import ctypes
from collections import OrderedDict
from functools import partial

from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtCore import Qt, QTimer, QStringListModel, QVariant, QPoint, QDate, QCoreApplication, QSettings, QTranslator
from qgis.PyQt.QtGui import QCursor, QPixmap, QColor, QFontMetrics, QStandardItemModel, QIcon
from qgis.PyQt.QtWidgets import QSpacerItem, QSizePolicy, QLineEdit, QLabel, QComboBox, QGridLayout, QTabWidget,\
    QCompleter, QFileDialog, QPushButton, QTableView, QFrame, QCheckBox, QDoubleSpinBox, QSpinBox, QDateEdit,\
    QTextEdit, QToolButton, QWidget, QGroupBox, QToolBox, QRadioButton
from qgis.core import QgsProject, QgsPointXY, QgsGeometry, QgsVectorLayer, QgsField, QgsFeature, \
    QgsSymbol, QgsSimpleFillSymbolLayer, QgsRendererCategory, QgsCategorizedSymbolRenderer,  QgsPointLocator, \
    QgsSnappingConfig, QgsSnappingUtils, QgsTolerance, QgsFeatureRequest, QgsDataSourceUri, QgsCredentials, QgsRectangle
from qgis.gui import QgsVertexMarker, QgsMapCanvas, QgsMapToolEmitPoint, QgsDateTimeEdit

from ...lib.tools_qgis import MultipleSelection
from ..models.sys_feature_cat import SysFeatureCat
from ..ui.ui_manager import GwDialog, GwMainWindow, DialogTextUi, DockerUi
from ... import global_vars
from ...lib import tools_qgis, tools_pgdao, tools_qt, tools_log, tools_config, tools_os, tools_db
from ...lib.tools_qt import GwHyperLinkLabel


class SnappingConfigManager(object):

    def __init__(self, iface):
        """ Class constructor """

        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.previous_snapping = None
        self.controller = None
        self.is_valid = False

        # Snapper
        self.snapping_config = self.get_snapping_options()
        self.snapping_config.setEnabled(True)
        self.snapper = self.get_snapper()
        proj = QgsProject.instance()
        proj.writeEntry('Digitizing', 'SnappingMode', 'advanced')

        # Set default vertex marker
        color = QColor(255, 100, 255)
        self.vertex_marker = QgsVertexMarker(self.canvas)
        self.vertex_marker.setIconType(QgsVertexMarker.ICON_CROSS)
        self.vertex_marker.setColor(color)
        self.vertex_marker.setIconSize(15)
        self.vertex_marker.setPenWidth(3)


    def init_snapping_config(self):
        pass


    def set_controller(self, controller):
        self.controller = controller


    def set_snapping_layers(self):
        """ Set main snapping layers """

        self.layer_arc = tools_qgis.get_layer_by_tablename('v_edit_arc')
        self.layer_connec = tools_qgis.get_layer_by_tablename('v_edit_connec')
        self.layer_gully = tools_qgis.get_layer_by_tablename('v_edit_gully')
        self.layer_node = tools_qgis.get_layer_by_tablename('v_edit_node')


    def get_snapping_options(self):
        """ Function that collects all the snapping options """

        global_snapping_config = QgsProject.instance().snappingConfig()
        return global_snapping_config


    def store_snapping_options(self):
        """ Store the project user snapping configuration """

        # Get an array containing the snapping options for all the layers
        self.previous_snapping = self.get_snapping_options()


    def enable_snapping(self, enable=False):
        """ Enable/Disable snapping of all layers """

        QgsProject.instance().blockSignals(True)

        layers = self.controller.get_layers()
        # Loop through all the layers in the project
        for layer in layers:
            if type(layer) != QgsVectorLayer:
                continue
            layer_settings = self.snapping_config.individualLayerSettings(layer)
            layer_settings.setEnabled(enable)
            self.snapping_config.setIndividualLayerSettings(layer, layer_settings)

        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snappingConfigChanged.emit(self.snapping_config)


    def set_snap_mode(self, mode=3):
        """ Defines on which layer the snapping is performed
        :param mode: 1 = ActiveLayer, 2=AllLayers, 3=AdvancedConfiguration (int or SnappingMode)
        """

        snapping_options = self.get_snapping_options()
        if snapping_options:
            QgsProject.instance().blockSignals(True)
            snapping_options.setMode(mode)
            QgsProject.instance().setSnappingConfig(snapping_options)
            QgsProject.instance().blockSignals(False)
            QgsProject.instance().snappingConfigChanged.emit(snapping_options)


    def snap_to_arc(self):
        """ Set snapping to 'arc' """

        QgsProject.instance().blockSignals(True)
        self.set_snapping_layers()
        layer_settings = self.snap_to_layer(self.layer_arc, QgsPointLocator.All, True)
        if layer_settings:
            layer_settings.setType(2)
            layer_settings.setTolerance(15)
            layer_settings.setEnabled(True)
        else:
            layer_settings = QgsSnappingConfig.IndividualLayerSettings(True, 2, 15, 1)
        self.snapping_config.setIndividualLayerSettings(self.layer_arc, layer_settings)
        self.restore_snap_options(self.snapping_config)


    def snap_to_node(self):
        """ Set snapping to 'node' """

        QgsProject.instance().blockSignals(True)
        layer_settings = self.snap_to_layer(self.layer_node, QgsPointLocator.Vertex, True)
        if layer_settings:
            layer_settings.setType(1)
            layer_settings.setTolerance(15)
            layer_settings.setEnabled(True)
        else:
            layer_settings = QgsSnappingConfig.IndividualLayerSettings(True, 1, 15, 1)
        self.snapping_config.setIndividualLayerSettings(self.layer_node, layer_settings)
        self.restore_snap_options(self.snapping_config)


    def snap_to_connec(self):
        """ Set snapping to 'connec' and 'gully' """

        QgsProject.instance().blockSignals(True)
        snapping_config = self.get_snapping_options()
        layer_settings = self.snap_to_layer(tools_qgis.get_layer_by_tablename('v_edit_connec'), QgsPointLocator.Vertex, True)
        if layer_settings:
            layer_settings.setType(1)
            layer_settings.setTolerance(15)
            layer_settings.setEnabled(True)
        else:
            layer_settings = QgsSnappingConfig.IndividualLayerSettings(True, 1, 15, 1)
        snapping_config.setIndividualLayerSettings(tools_qgis.get_layer_by_tablename('v_edit_connec'), layer_settings)
        self.restore_snap_options(self.snapping_config)


    def snap_to_gully(self):

        QgsProject.instance().blockSignals(True)
        snapping_config = self.get_snapping_options()
        layer_settings = self.snap_to_layer(tools_qgis.get_layer_by_tablename('v_edit_gully'), QgsPointLocator.Vertex, True)
        if layer_settings:
            layer_settings.setType(1)
            layer_settings.setTolerance(15)
            layer_settings.setEnabled(True)
        else:
            layer_settings = QgsSnappingConfig.IndividualLayerSettings(True, 1, 15, 1)
        snapping_config.setIndividualLayerSettings(tools_qgis.get_layer_by_tablename('v_edit_gully'), layer_settings)
        self.restore_snap_options(self.snapping_config)


    def snap_to_layer(self, layer, point_locator=QgsPointLocator.All, set_settings=False):
        """ Set snapping to @layer """

        if layer is None:
            return

        QgsSnappingUtils.LayerConfig(layer, point_locator, 15, QgsTolerance.Pixels)
        if set_settings:
            layer_settings = self.snapping_config.individualLayerSettings(layer)
            layer_settings.setEnabled(True)
            self.snapping_config.setIndividualLayerSettings(layer, layer_settings)
            return layer_settings


    def restore_snap_options(self, snappings_options):
        """ Function that applies selected snapping configuration """

        QgsProject.instance().blockSignals(True)
        if snappings_options is None and self.snapping_config:
            snappings_options = self.snapping_config
        QgsProject.instance().setSnappingConfig(snappings_options)
        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snappingConfigChanged.emit(self.snapping_config)


    def recover_snapping_options(self):
        """ Function to restore the previous snapping configuration """

        self.restore_snap_options(self.previous_snapping)


    def get_snapper(self):
        """ Return snapper """

        snapper = QgsMapCanvas.snappingUtils(self.canvas)
        return snapper


    def snap_to_current_layer(self, event_point, vertex_marker=None):

        self.is_valid = False
        if event_point is None:
            return None, None

        result = self.snapper.snapToCurrentLayer(event_point, QgsPointLocator.All)
        if vertex_marker:
            if result.isValid():
                # Get the point and add marker on it
                point = QgsPointXY(result.point())
                vertex_marker.setCenter(point)
                vertex_marker.show()

        self.is_valid = result.isValid()
        return result


    def snap_to_background_layers(self, event_point, vertex_marker=None):

        self.is_valid = False
        if event_point is None:
            return None, None

        result = self.snapper.snapToMap(event_point)
        if vertex_marker:
            if result.isValid():
                # Get the point and add marker on it
                point = QgsPointXY(result.point())
                vertex_marker.setCenter(point)
                vertex_marker.show()

        self.is_valid = result.isValid()
        return result


    def add_marker(self, result, vertex_marker=None, icon_type=None):

        if not result.isValid():
            return None

        if vertex_marker is None:
            vertex_marker = self.vertex_marker

        point = result.point()
        if icon_type:
            vertex_marker.setIconType(icon_type)
        vertex_marker.setCenter(point)
        vertex_marker.show()

        return point


    def remove_marker(self, vertex_marker=None):

        if vertex_marker is None:
            vertex_marker = self.vertex_marker

        vertex_marker.hide()


    def get_event_point(self, event=None, point=None):
        """ Get point """

        event_point = None
        x = None
        y = None
        try:
            if event:
                x = event.pos().x()
                y = event.pos().y()
            if point:
                map_point = self.canvas.getCoordinateTransform().transform(point)
                x = map_point.x()
                y = map_point.y()
            event_point = QPoint(x, y)
        except:
            pass
        finally:
            return event_point


    def get_snapped_layer(self, result):

        layer = None
        if result.isValid():
            layer = result.layer()

        return layer


    def get_snapped_point(self, result):

        point = None
        if result.isValid():
            point = QgsPointXY(result.point())

        return point


    def get_snapped_feature_id(self, result):

        feature_id = None
        if result.isValid():
            feature_id = result.featureId()

        return feature_id


    def get_snapped_feature(self, result, select_feature=False):

        if not result.isValid():
            return None

        snapped_feat = None
        try:
            layer = result.layer()
            feature_id = result.featureId()
            feature_request = QgsFeatureRequest().setFilterFid(feature_id)
            snapped_feat = next(layer.getFeatures(feature_request))
            if select_feature and snapped_feat:
                self.select_snapped_feature(result, feature_id)
        except:
            pass
        finally:
            return snapped_feat


    def select_snapped_feature(self, result, feature_id):

        if not result.isValid():
            return

        layer = result.layer()
        layer.select([feature_id])


    def result_is_valid(self):
        return self.is_valid


    def add_point(self, vertex_marker):
        """ Create the appropriate map tool and connect to the corresponding signal """

        # Declare return variable
        return_point = {}

        active_layer = global_vars.iface.activeLayer()
        if active_layer is None:
            active_layer = tools_qgis.get_layer_by_tablename('version')
            global_vars.iface.setActiveLayer(active_layer)

        # Vertex marker
        vertex_marker.setColor(QColor(255, 100, 255))
        vertex_marker.setIconSize(15)
        vertex_marker.setIconType(QgsVertexMarker.ICON_CROSS)
        vertex_marker.setPenWidth(3)

        # Snapper
        emit_point = QgsMapToolEmitPoint(global_vars.canvas)
        global_vars.canvas.setMapTool(emit_point)
        global_vars.canvas.xyCoordinates.connect(partial(self.mouse_move, vertex_marker))
        emit_point.canvasClicked.connect(partial(self.get_xy, vertex_marker, return_point, emit_point))

        return return_point


    def mouse_move(self, vertex_marker, point):

        # Hide marker and get coordinates
        vertex_marker.hide()
        event_point = self.get_event_point(point=point)

        # Snapping
        result = self.snap_to_background_layers(event_point)
        if result.isValid():
            self.add_marker(result, vertex_marker)
        else:
            vertex_marker.hide()


    def get_xy(self, vertex_marker, return_point, emit_point, point):
        """ Get coordinates of selected point """

        # Setting x, y coordinates from point
        return_point['x'] = point.x()
        return_point['y'] = point.y()

        message = "Geometry has been added!"
        show_info(message)
        emit_point.canvasClicked.disconnect()
        global_vars.canvas.xyCoordinates.disconnect()
        global_vars.iface.mapCanvas().refreshAllLayers()
        vertex_marker.hide()


def load_settings(dialog):
    """ Load user UI settings related with dialog position and size """
    # Get user UI config file
    try:
        x = get_config_parser('dialogs_position', f"{dialog.objectName()}_x")
        y = get_config_parser('dialogs_position', f"{dialog.objectName()}_y")
        width = get_config_parser('dialogs_position', f"{dialog.objectName()}_width")
        height = get_config_parser('dialogs_position', f"{dialog.objectName()}_height")

        v_screens = ctypes.windll.user32
        screen_x = v_screens.GetSystemMetrics(78)  # Width of virtual screen
        screen_y = v_screens.GetSystemMetrics(79)  # Height of virtual screen
        monitors = v_screens.GetSystemMetrics(80)  # Will return an integer of the number of display monitors present.

        if (int(x) < 0 and monitors == 1) or (int(y) < 0 and monitors == 1):
            dialog.resize(int(width), int(height))
        else:
            if int(x) > screen_x:
                x = int(screen_x) - int(width)
            if int(y) > screen_y:
                y = int(screen_y)
            dialog.setGeometry(int(x), int(y), int(width), int(height))
    except:
        pass

# TODO Start Generic Section

def save_settings(dialog):
    """ Save user UI related with dialog position and size """
    try:
        set_config_parser('dialogs_position', f"{dialog.objectName()}_width", f"{dialog.property('width')}")
        set_config_parser('dialogs_position', f"{dialog.objectName()}_height", f"{dialog.property('height')}")
        set_config_parser('dialogs_position', f"{dialog.objectName()}_x", f"{dialog.pos().x() + 8}")
        set_config_parser('dialogs_position', f"{dialog.objectName()}_y", f"{dialog.pos().y() + 31}")
    except Exception as e:
        pass


def get_config_parser(section: str, parameter: str) -> str:
    """ Load a simple parser value """
    value = None
    try:
        parser = configparser.ConfigParser(comment_prefixes='/', inline_comment_prefixes='/', allow_no_value=True)
        main_folder = os.path.join(os.path.expanduser("~"), global_vars.plugin_name)
        path = main_folder + os.sep + "config" + os.sep + 'user.config'
        if not os.path.exists(path):
            return value
        parser.read(path)
        value = parser[section][parameter]
    except:
        return value
    return value


def set_config_parser(section: str, parameter: str, value: str):
    """  Save simple parser value """
    try:
        parser = configparser.ConfigParser(comment_prefixes='/', inline_comment_prefixes='/', allow_no_value=True)
        main_folder = os.path.join(os.path.expanduser("~"), global_vars.plugin_name)
        config_folder = main_folder + os.sep + "config" + os.sep
        if not os.path.exists(config_folder):
            os.makedirs(config_folder)
        path = config_folder + 'user.config'
        parser.read(path)

        # Check if section dialogs_position exists in file
        if section not in parser:
            parser.add_section(section)
        parser[section][parameter] = value
        with open(path, 'w') as configfile:
            parser.write(configfile)
            configfile.close()
    except Exception as e:
        return None


def save_current_tab(dialog, tab_widget, selector_name):
    """ Save the name of current tab used by the user into QSettings()
    :param dialog: QDialog
    :param tab_widget: QTabWidget
    :param selector_name: Name of the selector (String)
    """
    try:
        index = tab_widget.currentIndex()
        tab = tab_widget.widget(index)
        if tab:
            tab_name = tab.objectName()
            dlg_name = dialog.objectName()
            set_config_parser('last_tabs', f"{dlg_name}_{selector_name}", f"{tab_name}")

    except Exception as e:
        pass


def open_dialog(dlg, dlg_name=None, info=True, maximize_button=True, stay_on_top=True, title=None):
    """ Open dialog """

    # Check database connection before opening dialog
    if not global_vars.controller.check_db_connection():
        return

    # Manage translate
    if dlg_name:
        manage_translation(dlg_name, dlg)

    # Set window title
    if title is not None:
        dlg.setWindowTitle(title)

    # Manage stay on top, maximize/minimize button and information button
    # if info is True maximize flag will be ignored
    # To enable maximize button you must set info to False
    flags = Qt.WindowCloseButtonHint
    if info:
        flags |= Qt.WindowSystemMenuHint | Qt.WindowContextHelpButtonHint
    else:
        if maximize_button:
            flags |= Qt.WindowMinMaxButtonsHint

    if stay_on_top:
        flags |= Qt.WindowStaysOnTopHint

    dlg.setWindowFlags(flags)

    # Open dialog
    if issubclass(type(dlg), GwDialog):
        dlg.open()
    elif issubclass(type(dlg), GwMainWindow):
        dlg.show()
    else:
        dlg.show()


def close_dialog(dlg):
    """ Close dialog """

    try:
        save_settings(dlg)
        dlg.close()
        map_tool = global_vars.canvas.mapTool()
        # If selected map tool is from the plugin, set 'Pan' as current one
        if map_tool.toolName() == '':
            global_vars.iface.actionPan().trigger()
    except AttributeError:
        pass

    global_vars.schema = None


def create_body(form='', feature='', filter_fields='', extras=None):
    """ Create and return parameters as body to functions"""

    client = f'$${{"client":{{"device":4, "infoType":1, "lang":"ES"}}, '
    form = f'"form":{{{form}}}, '
    feature = f'"feature":{{{feature}}}, '
    filter_fields = f'"filterFields":{{{filter_fields}}}'
    page_info = f'"pageInfo":{{}}'
    data = f'"data":{{{filter_fields}, {page_info}'
    if extras is not None:
        data += ', ' + extras
    data += f'}}}}$$'
    body = "" + client + form + feature + data

    return body


def refresh_legend(controller):
    """ This function solves the bug generated by changing the type of feature.
    Mysteriously this bug is solved by checking and unchecking the categorization of the tables.
    # TODO solve this bug
    """

    layers = [tools_qgis.get_layer_by_tablename('v_edit_node'),
              tools_qgis.get_layer_by_tablename('v_edit_connec'),
              tools_qgis.get_layer_by_tablename('v_edit_gully')]

    for layer in layers:
        if layer:
            ltl = QgsProject.instance().layerTreeRoot().findLayer(layer.id())
            ltm = global_vars.iface.layerTreeView().model()
            legendNodes = ltm.layerLegendNodes(ltl)
            for ln in legendNodes:
                current_state = ln.data(Qt.CheckStateRole)
                ln.setData(Qt.Unchecked, Qt.CheckStateRole)
                ln.setData(Qt.Checked, Qt.CheckStateRole)
                ln.setData(current_state, Qt.CheckStateRole)


def get_cursor_multiple_selection():
    """ Set cursor for multiple selection """

    path_cursor = os.path.join(global_vars.controller.plugin_dir, f"icons{os.sep}shared", '201.png')
    if os.path.exists(path_cursor):
        cursor = QCursor(QPixmap(path_cursor))
    else:
        cursor = QCursor(Qt.ArrowCursor)

    return cursor


def hide_parent_layers(excluded_layers=[]):
    """ Hide generic layers """

    layers_changed = {}
    layer = tools_qgis.get_layer_by_tablename("v_edit_arc")
    if layer and "v_edit_arc" not in excluded_layers:
        layers_changed[layer] = tools_qgis.is_layer_visible(layer)
        tools_qgis.set_layer_visible(layer)
    layer = tools_qgis.get_layer_by_tablename("v_edit_node")
    if layer and "v_edit_node" not in excluded_layers:
        layers_changed[layer] = tools_qgis.is_layer_visible(layer)
        tools_qgis.set_layer_visible(layer)
    layer = tools_qgis.get_layer_by_tablename("v_edit_connec")
    if layer and "v_edit_connec" not in excluded_layers:
        layers_changed[layer] = tools_qgis.is_layer_visible(layer)
        tools_qgis.set_layer_visible(layer)
    layer = tools_qgis.get_layer_by_tablename("v_edit_element")
    if layer and "v_edit_element" not in excluded_layers:
        layers_changed[layer] = tools_qgis.is_layer_visible(layer)
        tools_qgis.set_layer_visible(layer)

    if global_vars.project_type == 'ud':
        layer = tools_qgis.get_layer_by_tablename("v_edit_gully")
        if layer and "v_edit_gully" not in excluded_layers:
            layers_changed[layer] = tools_qgis.is_layer_visible(layer)
            tools_qgis.set_layer_visible(layer)

    return layers_changed


def get_plugin_version():
    """ Get plugin version from metadata.txt file """

    # Check if metadata file exists
    metadata_file = os.path.join(global_vars.plugin_dir, 'metadata.txt')
    if not os.path.exists(metadata_file):
        message = "Metadata file not found"
        show_warning(message, parameter=metadata_file)
        return None

    metadata = configparser.ConfigParser()
    metadata.read(metadata_file)
    plugin_version = metadata.get('general', 'version')
    if plugin_version is None:
        message = "Plugin version not found"
        show_warning(message)

    return plugin_version


def draw_by_json(complet_result, rubber_band, margin=None, reset_rb=True, color=QColor(255, 0, 0, 100), width=3):

    try:
        if complet_result['body']['feature']['geometry'] is None:
            return
        if complet_result['body']['feature']['geometry']['st_astext'] is None:
            return
    except KeyError:
        return

    list_coord = re.search('\((.*)\)', str(complet_result['body']['feature']['geometry']['st_astext']))
    max_x, max_y, min_x, min_y = tools_qgis.get_max_rectangle_from_coords(list_coord)

    if reset_rb:
        rubber_band.reset()
    if str(max_x) == str(min_x) and str(max_y) == str(min_y):
        point = QgsPointXY(float(max_x), float(max_y))
        draw_point(point, rubber_band, color, width)
    else:
        points = tools_qgis.get_geometry_vertex(list_coord)
        draw_polyline(points, rubber_band, color, width)
    if margin is not None:
        tools_qgis.zoom_to_rectangle(max_x, max_y, min_x, min_y, margin)


def draw_point(point, rubber_band=None, color=QColor(255, 0, 0, 100), width=3, duration_time=None, is_new=False):
    """
    :param duration_time: integer milliseconds ex: 3000 for 3 seconds
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
    """ Draw 'line' over canvas following list of points
     :param duration_time: integer milliseconds ex: 3000 for 3 seconds
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



def enable_feature_type(dialog, widget_name='tbl_relation', ids=None):

    feature_type = tools_qt.get_widget(dialog, 'feature_type')
    widget_table = tools_qt.get_widget(dialog, widget_name)
    if feature_type is not None and widget_table is not None:
        if len(ids) > 0:
            feature_type.setEnabled(False)
        else:
            feature_type.setEnabled(True)


def reset_feature_list(ids, list_ids):
    """ Reset list of selected records """

    ids = []
    list_ids = {'arc': [], 'node': [], 'connec': [], 'gully': [], 'element': []}

    return ids, list_ids


def reset_feature_layers(layers):
    """ Reset list of layers """

    layers = {'arc': [], 'node': [], 'connec': [], 'gully': [], 'element': []}

    return layers


def get_signal_change_tab(dialog, excluded_layers=[]):
    """ Set geom_type and layer depending selected tab
        @table_object = ['doc' | 'element' | 'cat_work']
    """

    tab_idx = dialog.tab_feature.currentIndex()
    geom_type = "arc"

    if dialog.tab_feature.widget(tab_idx).objectName() == 'tab_arc':
        geom_type = "arc"
    elif dialog.tab_feature.widget(tab_idx).objectName() == 'tab_node':
        geom_type = "node"
    elif dialog.tab_feature.widget(tab_idx).objectName() == 'tab_connec':
        geom_type = "connec"
    elif dialog.tab_feature.widget(tab_idx).objectName() == 'tab_gully':
        geom_type = "gully"
    elif dialog.tab_feature.widget(tab_idx).objectName() == 'tab_elem':
        geom_type = "element"
    hide_parent_layers(excluded_layers=excluded_layers)
    viewname = f"v_edit_{geom_type}"

    # Adding auto-completion to a QLineEdit
    set_completer_feature_id(dialog.feature_id, geom_type, viewname)
    global_vars.iface.actionPan().trigger()
    return geom_type


def set_completer_feature_id(widget, geom_type, viewname):
    """ Set autocomplete of widget 'feature_id'
        getting id's from selected @viewname
    """
    if geom_type == '':
        return
    # Adding auto-completion to a QLineEdit
    completer = QCompleter()
    completer.setCaseSensitivity(Qt.CaseInsensitive)
    widget.setCompleter(completer)
    model = QStringListModel()
    sql = (f"SELECT {geom_type}_id"
           f" FROM {viewname}")
    row = global_vars.controller.get_rows(sql)
    if row:
        for i in range(0, len(row)):
            aux = row[i]
            row[i] = str(aux[0])
        model.setStringList(row)
        completer.setModel(model)


def insert_pg_layer(tablename=None, the_geom="the_geom", field_id="id", child_layers=None,
                         group="GW Layers", style_id="-1"):
    """ Put selected layer into TOC
    :param tablename: Postgres table name (String)
    :param the_geom: Geometry field of the table (String)
    :param field_id: Field id of the table (String)
    :param child_layers: List of layers (StringList)
    :param group: Name of the group that will be created in the toc (String)
    :param style_id: Id of the style we want to load (integer or String)
    """

    uri = tools_pgdao.get_uri()
    schema_name = global_vars.controller.credentials['schema'].replace('"', '')
    if child_layers is not None:
        for layer in child_layers:
            if layer[0] != 'Load all':
                vlayer = tools_qgis.get_layer_by_tablename(layer[0])
                if vlayer: continue
                uri.setDataSource(schema_name, f"{layer[0]}", the_geom, None, layer[1] + "_id")
                vlayer = QgsVectorLayer(uri.uri(), f'{layer[0]}', "postgres")
                group = layer[4] if layer[4] is not None else group
                group = group if group is not None else 'GW Layers'
                tools_qt.add_layer_to_toc(vlayer, group)
                style_id = layer[3]
                if style_id is not None:
                    body = f'$${{"data":{{"style_id":"{style_id}"}}}}$$'
                    style = get_json('gw_fct_getstyle', body)
                    if style['status'] == 'Failed': return
                    if 'styles' in style['body']:
                        if 'style' in style['body']['styles']:
                            qml = style['body']['styles']['style']
                            create_qml(vlayer, qml)
    else:
        uri.setDataSource(schema_name, f'{tablename}', the_geom, None, field_id)
        vlayer = QgsVectorLayer(uri.uri(), f'{tablename}', 'postgres')
        tools_qt.add_layer_to_toc(vlayer, group)
        # The triggered function (action.triggered.connect(partial(...)) as the last parameter sends a boolean,
        # if we define style_id = None, style_id will take the boolean of the triggered action as a fault,
        # therefore, we define it with "-1"
        if style_id not in (None, "-1"):
            body = f'$${{"data":{{"style_id":"{style_id}"}}}}$$'
            style = get_json('gw_fct_getstyle', body)
            if style['status'] == 'Failed': return
            if 'styles' in style['body']:
                if 'style' in style['body']['styles']:
                    qml = style['body']['styles']['style']
                    create_qml(vlayer, qml)
    global_vars.iface.mapCanvas().refresh()


def create_qml(layer, style):

    main_folder = os.path.join(os.path.expanduser("~"), global_vars.plugin_name)
    config_folder = main_folder + os.sep + "temp" + os.sep
    if not os.path.exists(config_folder):
        os.makedirs(config_folder)
    path_temp_file = config_folder + 'temp_qml.qml'
    file = open(path_temp_file, 'w')
    file.write(style)
    file.close()
    del file
    tools_qgis.load_qml(layer, path_temp_file)


def add_temp_layer(dialog, data, layer_name, force_tab=True, reset_text=True, tab_idx=1, del_old_layers=True,
                   group='GW Temporal Layers', disable_tabs=True):
    """ Add QgsVectorLayer into TOC
    :param dialog: Dialog where to find the tab to be displayed and the textedit to be filled (QDialog or QMainWindow)
    :param data: Json with information
    :param layer_name: Name that will be given to the layer (String)
    :param force_tab: Boolean that tells us if we want to show the tab or not (Boolean)
    :param reset_text:It allows us to delete the text from the Qtexedit log, or add text below (Boolean)
    :param tab_idx: Log tab index (Integer)
    :param del_old_layers:Delete layers added in previous operations (Boolean)
    :param group: Name of the group to which we want to add the layer (String)
    :param disable_tabs: set all tabs, except the last, enabled or disabled (boolean).
    :return: Dictionary with text as result of previuos data (String), and list of layers added (QgsVectorLayer).
    """

    text_result = None
    temp_layers_added = []
    srid = global_vars.srid
    for k, v in list(data.items()):
        if str(k) == "info":
            text_result, change_tab = fill_log(dialog, data, force_tab, reset_text, tab_idx, disable_tabs)
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
                    tools_qgis.remove_layer_from_toc(layer_name, group)
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
                    tools_qgis.load_qml(v_layer, qml_path)
                elif 'category_field' in data[k] and data[k]['category_field']:
                    cat_field = data[k]['category_field']
                    size = data[k]['size'] if 'size' in data[k] and data[k]['size'] else 2
                    color_values = {'NEW': QColor(0, 255, 0), 'DUPLICATED': QColor(255, 0, 0),
                                    'EXISTS': QColor(240, 150, 0)}
                    tools_qgis.set_layer_categoryze(v_layer, cat_field, size, color_values)
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


def fill_log(dialog, data, force_tab=True, reset_text=True, tab_idx=1, call_disable_tabs=True):
    """ Populate txt_infolog QTextEdit widget
    :param dialog: QDialog
    :param data: Json
    :param force_tab: Force show tab (boolean)
    :param reset_text: Reset(or not) text for each iteration (boolean)
    :param tab_idx: index of tab to force (integer)
    :param call_disable_tabs: set all tabs, except the last, enabled or disabled (boolean)
    :return: Text received from data (String)
    """

    change_tab = False
    text = tools_qt.get_text(dialog, dialog.txt_infolog, return_string_null=False)

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

    tools_qt.set_widget_text(dialog, 'txt_infolog', text + "\n")
    qtabwidget = dialog.findChild(QTabWidget, 'mainTab')
    if qtabwidget is not None:
        if change_tab and qtabwidget is not None:
            qtabwidget.setCurrentIndex(tab_idx)
        if call_disable_tabs:
            disable_tabs(dialog)

    return text, change_tab


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
        geometry = get_geometry_from_json(feature)
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


def get_geometry_from_json(feature):
    """ Get coordinates from GeoJson and return QGsGeometry
    :param feature: feature to get geometry type and coordinates (GeoJson)
    :return: Geometry of the feature (QgsGeometry)
    functions  called in -> getattr(f"get_{feature['geometry']['type'].lower()}")(feature)
        def get_vertex_from_point(feature)
        get_vertex_from_linestring(feature)
        get_vertex_from_multilinestring(feature)
        get_vertex_from_polygon(feature)
        get_vertex_from_multipolygon(feature)
    """

    try:
        coordinates = getattr(sys.modules[__name__], f"get_vertex_from_{feature['geometry']['type'].lower()}")(feature)
        type_ = feature['geometry']['type']
        geometry = f"{type_}{coordinates}"
        return QgsGeometry.fromWkt(geometry)
    except AttributeError as e:
        tools_log.log_info(f"{type(e).__name__} --> {e}")
        return None


def get_vertex_from_point(feature):
    """ Manage feature geometry when is Point
    :param feature: feature to get geometry type and coordinates (GeoJson)
    :return: Coordinates of the feature (String)
    This function is called in def get_geometry_from_json(feature)
          geometry = getattr(f"get_{feature['geometry']['type'].lower()}")(feature)
    """
    return f"({feature['geometry']['coordinates'][0]} {feature['geometry']['coordinates'][1]})"


def get_vertex_from_linestring(feature):
    """ Manage feature geometry when is LineString
    :param feature: feature to get geometry type and coordinates (GeoJson)
    :return: Coordinates of the feature (String)
    This function is called in def get_geometry_from_json(feature)
          geometry = getattr(f"get_{feature['geometry']['type'].lower()}")(feature)
    """
    return get_vertex_from_points(feature)


def get_vertex_from_multilinestring(feature):
    """ Manage feature geometry when is MultiLineString
    :param feature: feature to get geometry type and coordinates (GeoJson)
    :return: Coordinates of the feature (String)
    This function is called in def get_geometry_from_json(feature)
          geometry = getattr(f"get_{feature['geometry']['type'].lower()}")(feature)
    """
    return get_multi_coordinates(feature)


def get_vertex_from_polygon(feature):
    """ Manage feature geometry when is Polygon
    :param feature: feature to get geometry type and coordinates (GeoJson)
    :return: Coordinates of the feature (String)
    This function is called in def get_geometry_from_json(feature)
          geometry = getattr(f"get_{feature['geometry']['type'].lower()}")(feature)
    """
    return get_multi_coordinates(feature)


def get_vertex_from_multipolygon(feature):
    """ Manage feature geometry when is MultiPolygon
    :param feature: feature to get geometry type and coordinates (GeoJson)
    :return: Coordinates of the feature (String)
    This function is called in def get_geometry_from_json(feature)
          geometry = getattr(f"get_{feature['geometry']['type'].lower()}")(feature)
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


def get_vertex_from_points(feature):
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


def disable_widgets(dialog, result, enable):

    try:
        widget_list = dialog.findChildren(QWidget)
        for widget in widget_list:
            for field in result['fields']:
                if widget.property('columnname') == field['columnname']:
                    if type(widget) in (QDoubleSpinBox, QLineEdit, QSpinBox, QTextEdit):
                        widget.setReadOnly(not enable)
                        widget.setStyleSheet("QWidget { background: rgb(242, 242, 242); color: rgb(0, 0, 0)}")
                    elif type(widget) in (QComboBox, QCheckBox, QgsDateTimeEdit):
                        widget.setEnabled(enable)
                        widget.setStyleSheet("QWidget {color: rgb(0, 0, 0)}")
                    elif type(widget) is QPushButton:
                        # Manage the clickability of the buttons according to the configuration
                        # in the table config_api_form_fields simultaneously with the edition,
                        # but giving preference to the configuration when iseditable is True
                        if not field['iseditable']:
                            widget.setEnabled(field['iseditable'])
                    break

    except RuntimeError as e:
        pass


def enable_all(dialog, result):
    try:
        widget_list = dialog.findChildren(QWidget)
        for widget in widget_list:
            if widget.property('keepDisbled'):
                continue
            for field in result['fields']:
                if widget.objectName() == field['widgetname']:
                    if type(widget) in (QSpinBox, QDoubleSpinBox, QLineEdit, QTextEdit):
                        widget.setReadOnly(not field['iseditable'])
                        if not field['iseditable']:
                            widget.setFocusPolicy(Qt.NoFocus)
                            widget.setStyleSheet("QWidget { background: rgb(242, 242, 242); color: rgb(0, 0, 0)}")
                        else:
                            widget.setFocusPolicy(Qt.StrongFocus)
                            widget.setStyleSheet(None)
                    elif type(widget) in (QComboBox, QgsDateTimeEdit):
                        widget.setEnabled(field['iseditable'])
                        widget.setStyleSheet(None)
                        widget.focusPolicy(Qt.StrongFocus) if widget.setEnabled(
                            field['iseditable']) else widget.setFocusPolicy(Qt.NoFocus)
                    elif type(widget) in (QCheckBox, QPushButton):
                        widget.setEnabled(field['iseditable'])
                        widget.focusPolicy(Qt.StrongFocus) if widget.setEnabled(
                            field['iseditable']) else widget.setFocusPolicy(Qt.NoFocus)
    except RuntimeError:
        pass


def set_stylesheet(field, widget, wtype='label'):

    if field['stylesheet'] is not None:
        if wtype in field['stylesheet']:
            widget.setStyleSheet("QWidget{" + field['stylesheet'][wtype] + "}")
    return widget


def delete_selected_rows(widget, table_object):
    """ Delete selected objects of the table (by object_id) """

    # Get selected rows
    selected_list = widget.selectionModel().selectedRows()
    if len(selected_list) == 0:
        message = "Any record selected"
        show_warning(message)
        return

    inf_text = ""
    list_id = ""
    field_object_id = "id"

    if table_object == "element":
        field_object_id = table_object + "_id"
    elif "v_ui_om_visitman_x_" in table_object:
        field_object_id = "visit_id"

    for i in range(0, len(selected_list)):
        row = selected_list[i].row()
        id_ = widget.model().record(row).value(str(field_object_id))
        inf_text += f"{id_}, "
        list_id += f"'{id_}', "
    inf_text = inf_text[:-2]
    list_id = list_id[:-2]
    message = "Are you sure you want to delete these records?"
    title = "Delete records"
    answer = tools_qt.ask_question(message, title, inf_text)
    if answer:
        sql = (f"DELETE FROM {table_object} "
               f"WHERE {field_object_id} IN ({list_id})")
        global_vars.controller.execute_sql(sql)
        widget.model().select()


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
        tools_qt.set_widget_text(dialog, btn_accept, 'Close')


def set_style_mapzones():

    extras = f'"mapzones":""'
    body = create_body(extras=extras)
    json_return = get_json('gw_fct_getstylemapzones', body)
    if not json_return or json_return['status'] == 'Failed':
        return False

    for mapzone in json_return['body']['data']['mapzones']:

        # Loop for each mapzone returned on json
        lyr = tools_qgis.get_layer_by_tablename(mapzone['layer'])
        categories = []
        status = mapzone['status']
        if status == 'Disable':
            pass

        if lyr:
            # Loop for each id returned on json
            for id in mapzone['values']:
                # initialize the default symbol for this geometry type
                symbol = QgsSymbol.defaultSymbol(lyr.geometryType())
                symbol.setOpacity(float(mapzone['opacity']))

                # Setting simp
                R = random.randint(0, 255)
                G = random.randint(0, 255)
                B = random.randint(0, 255)
                if status == 'Stylesheet':
                    try:
                        R = id['stylesheet']['color'][0]
                        G = id['stylesheet']['color'][1]
                        B = id['stylesheet']['color'][2]
                    except TypeError:
                        R = random.randint(0, 255)
                        G = random.randint(0, 255)
                        B = random.randint(0, 255)

                elif status == 'Random':
                    R = random.randint(0, 255)
                    G = random.randint(0, 255)
                    B = random.randint(0, 255)

                # Setting sytle
                layer_style = {'color': '{}, {}, {}'.format(int(R), int(G), int(B))}
                symbol_layer = QgsSimpleFillSymbolLayer.create(layer_style)

                if symbol_layer is not None:
                    symbol.changeSymbolLayer(0, symbol_layer)
                category = QgsRendererCategory(id['id'], symbol, str(id['id']))
                categories.append(category)

                # apply symbol to layer renderer
                lyr.setRenderer(QgsCategorizedSymbolRenderer(mapzone['idname'], categories))

                # repaint layer
                lyr.triggerRepaint()


def manage_feature_cat():
    """ Manage records from table 'cat_feature' """

    # Dictionary to keep every record of table 'cat_feature'
    # Key: field tablename
    # Value: Object of the class SysFeatureCat
    feature_cat = {}
    sql = ("SELECT cat_feature.* FROM cat_feature "
           "WHERE active IS TRUE ORDER BY id")
    rows = global_vars.controller.get_rows(sql)

    # If rows ara none, probably the conection has broken so try again
    if not rows:
        rows = global_vars.controller.get_rows(sql)
        if not rows:
            return None

    msg = "Field child_layer of id: "
    for row in rows:
        tablename = row['child_layer']
        if not tablename:
            msg += f"{row['id']}, "
            continue
        elem = SysFeatureCat(row['id'], row['system_id'], row['feature_type'], row['shortcut_key'],
                             row['parent_layer'], row['child_layer'])
        feature_cat[tablename] = elem

    feature_cat = OrderedDict(sorted(feature_cat.items(), key=lambda t: t[0]))

    if msg != "Field child_layer of id: ":
        show_warning(msg + "is not defined in table cat_feature")

    return feature_cat


def populate_basic_info(dialog, result, field_id, my_json=None, new_feature_id=None, new_feature=None,
                        layer_new_feature=None, feature_id=None, feature_type=None, layer=None):

    fields = result[0]['body']['data']
    if 'fields' not in fields:
        return
    grid_layout = dialog.findChild(QGridLayout, 'gridLayout')

    for x, field in enumerate(fields["fields"]):

        label = QLabel()
        label.setObjectName('lbl_' + field['label'])
        label.setText(field['label'].capitalize())

        if 'tooltip' in field:
            label.setToolTip(field['tooltip'])
        else:
            label.setToolTip(field['label'].capitalize())

        widget = None
        if field['widgettype'] in ('text', 'textline') or field['widgettype'] == 'typeahead':
            completer = QCompleter()
            widget = add_lineedit(field)
            widget = set_widget_size(widget, field)
            widget = set_data_type(field, widget)
            if field['widgettype'] == 'typeahead':
                widget = set_typeahead(field, dialog, widget, completer)

        elif field['widgettype'] == 'datetime':
            widget = add_calendar(dialog, field)
        elif field['widgettype'] == 'hyperlink':
            widget = add_hyperlink(field)
        elif field['widgettype'] == 'textarea':
            widget = add_textarea(field)
        elif field['widgettype'] in ('combo', 'combobox'):
            widget = add_combo(field)
            widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
        elif field['widgettype'] in ('check', 'checkbox'):
            widget = add_checkbox(field)
            widget.stateChanged.connect(partial(get_values, dialog, widget, my_json))
        elif field['widgettype'] == 'button':
            widget = add_button(dialog, field)
        widget.setProperty('ismandatory', field['ismandatory'])
        grid_layout.addWidget(label, x, 0)
        grid_layout.addWidget(widget, x, 1)

    verticalSpacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
    grid_layout.addItem(verticalSpacer1)

    return result


def construct_form_param_user(dialog, row, pos, _json, temp_layers_added=None):

    field_id = ''
    if 'fields' in row[pos]:
        field_id = 'fields'
    elif 'return_type' in row[pos]:
        if row[pos]['return_type'] not in ('', None):
            field_id = 'return_type'

    if field_id == '':
        return

    for field in row[pos][field_id]:
        if field['label']:
            lbl = QLabel()
            lbl.setObjectName('lbl' + field['widgetname'])
            lbl.setText(field['label'])
            lbl.setMinimumSize(160, 0)
            lbl.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Preferred)
            if 'tooltip' in field:
                lbl.setToolTip(field['tooltip'])

            widget = None
            if field['widgettype'] == 'text' or field['widgettype'] == 'linetext':
                widget = QLineEdit()
                if 'isMandatory' in field:
                    widget.setProperty('is_mandatory', field['isMandatory'])
                else:
                    widget.setProperty('is_mandatory', True)
                widget.setText(field['value'])
                if 'widgetcontrols' in field and field['widgetcontrols']:
                    if 'regexpControl' in field['widgetcontrols']:
                        if field['widgetcontrols']['regexpControl'] is not None:
                            pass
                widget.editingFinished.connect(
                    partial(get_values_changed_param_user, dialog, None, widget, field, _json))
                widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
            elif field['widgettype'] == 'combo':
                widget = add_combo(field)
                widget.currentIndexChanged.connect(
                    partial(get_values_changed_param_user, dialog, None, widget, field, _json))
                widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
            elif field['widgettype'] == 'check':
                widget = QCheckBox()
                if field['value'] is not None and field['value'].lower() == "true":
                    widget.setChecked(True)
                else:
                    widget.setChecked(False)
                widget.stateChanged.connect(partial(get_values_changed_param_user,
                                            dialog, None, widget, field, _json))
                widget.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
            elif field['widgettype'] == 'datetime':
                widget = QgsDateTimeEdit()
                widget.setAllowNull(True)
                widget.setCalendarPopup(True)
                widget.setDisplayFormat('yyyy/MM/dd')
                date = QDate.currentDate()
                if 'value' in field and field['value'] not in ('', None, 'null'):
                    date = QDate.fromString(field['value'].replace('/', '-'), 'yyyy-MM-dd')
                widget.setDate(date)
                widget.dateChanged.connect(partial(get_values_changed_param_user,
                                           dialog, None, widget, field, _json))
                widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
            elif field['widgettype'] == 'spinbox':
                widget = QDoubleSpinBox()
                if 'widgetcontrols' in field and field['widgetcontrols'] and 'spinboxDecimals' in field['widgetcontrols']:
                    widget.setDecimals(field['widgetcontrols']['spinboxDecimals'])
                if 'value' in field and field['value'] not in (None, ""):
                    value = float(str(field['value']))
                    widget.setValue(value)
                widget.valueChanged.connect(partial(get_values_changed_param_user,
                                            dialog, None, widget, field, _json))
                widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
            elif field['widgettype'] == 'button':
                widget = add_button(dialog, field, temp_layers_added)
                widget = set_widget_size(widget, field)

            # Set editable/readonly
            if type(widget) in (QLineEdit, QDoubleSpinBox):
                if 'iseditable' in field:
                    if str(field['iseditable']) == "False":
                        widget.setReadOnly(True)
                        widget.setStyleSheet("QWidget {background: rgb(242, 242, 242);color: rgb(100, 100, 100)}")
                if type(widget) == QLineEdit:
                    if 'placeholder' in field:
                        widget.setPlaceholderText(field['placeholder'])
            elif type(widget) in (QComboBox, QCheckBox):
                if 'iseditable' in field:
                    if str(field['iseditable']) == "False":
                        widget.setEnabled(False)
            widget.setObjectName(field['widgetname'])
            if 'iseditable' in field:
                widget.setEnabled(bool(field['iseditable']))

            add_widget(dialog, field, lbl, widget)


def add_widget(dialog, field, lbl, widget):
    """ Insert widget into layout """

    layout = dialog.findChild(QGridLayout, field['layoutname'])
    if layout in (None, 'null', 'NULL', 'Null'):
        return
    layout.addWidget(lbl, int(field['layoutorder']), 0)
    layout.addWidget(widget, int(field['layoutorder']), 2)
    layout.setColumnStretch(2, 1)


def get_values_changed_param_user(dialog, chk, widget, field, list, value=None):

    elem = {}
    if type(widget) is QLineEdit:
        value = tools_qt.get_text(dialog, widget, return_string_null=False)
    elif type(widget) is QComboBox:
        value = tools_qt.get_combo_value(dialog, widget, 0)
    elif type(widget) is QCheckBox:
        value = tools_qt.isChecked(dialog, widget)
    elif type(widget) is QDateEdit:
        value = tools_qt.get_calendar_date(dialog, widget)

    # When the QDoubleSpinbox contains decimals, for example 2,0001 when collecting the value, the spinbox itself sends
    # 2.0000999999, as in reality we only want, maximum 4 decimal places, we round up, thus fixing this small failure
    # of the widget
    if type(widget) in (QSpinBox, QDoubleSpinBox):
        value = round(value, 4)
    # if chk is None:
    #     elem[widget.objectName()] = value
    elem['widget'] = str(widget.objectName())
    elem['value'] = value
    if chk is not None:
        if chk.isChecked():
            # elem['widget'] = str(widget.objectName())
            elem['chk'] = str(chk.objectName())
            elem['isChecked'] = str(tools_qt.isChecked(dialog, chk))
            # elem['value'] = value

    if 'sys_role_id' in field:
        elem['sys_role_id'] = str(field['sys_role_id'])
    list.append(elem)
    tools_log.log_info(str(list))


def add_button(dialog, field, temp_layers_added=None, module=sys.modules[__name__]):
    """
    :param dialog: (QDialog)
    :param field: Part of json where find info (Json)
    :param temp_layers_added: List of layers added to the toc
    :param module: Module where find 'function_name', if 'function_name' is not in this module
    :return: (QWidget)
    """
    widget = QPushButton()
    widget.setObjectName(field['widgetname'])

    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    if 'value' in field:
        widget.setText(field['value'])
    widget.resize(widget.sizeHint().width(), widget.sizeHint().height())
    function_name = 'no_function_associated'
    real_name = widget.objectName()[5:len(widget.objectName())]
    if 'widgetfunction' in field:
        if field['widgetfunction'] is not None:
            function_name = field['widgetfunction']
            exist = check_python_function(module, function_name)
            if not exist:
                msg = f"widget {real_name} have associated function {function_name}, but {function_name} not exist"
                show_message(msg, 2)
                return widget
        else:
            message = "Parameter button_function is null for button"
            show_message(message, 2, parameter=widget.objectName())

    kwargs = {'dialog': dialog, 'widget': widget, 'message_level': 1, 'function_name': function_name, 'temp_layers_added': temp_layers_added}
    widget.clicked.connect(partial(getattr(module, function_name), **kwargs))

    return widget


def add_spinbox(field):

    widget = None
    if 'value' in field:
        if field['widgettype'] == 'spinbox':
            widget = QSpinBox()
    widget.setObjectName(field['widgetname'])
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    if 'value' in field:
        if field['widgettype'] == 'spinbox' and field['value'] != "":
            widget.setValue(int(field['value']))
    if 'iseditable' in field:
        widget.setReadOnly(not field['iseditable'])
        if not field['iseditable']:
            widget.setStyleSheet("QDoubleSpinBox { background: rgb(0, 250, 0); color: rgb(100, 100, 100)}")

    return widget


def get_values(dialog, widget, _json=None):

    value = None
    if type(widget) in (QDoubleSpinBox, QLineEdit, QSpinBox, QTextEdit) and widget.isReadOnly() is False:
        value = tools_qt.get_text(dialog, widget, return_string_null=False)
    elif type(widget) is QComboBox and widget.isEnabled():
        value = tools_qt.get_combo_value(dialog, widget, 0)
    elif type(widget) is QCheckBox and widget.isEnabled():
        value = tools_qt.isChecked(dialog, widget)
    elif type(widget) is QgsDateTimeEdit and widget.isEnabled():
        value = tools_qt.get_calendar_date(dialog, widget)

    if str(value) == '' or value is None:
        _json[str(widget.property('columnname'))] = None
    else:
        _json[str(widget.property('columnname'))] = str(value)
    return _json

def add_checkbox(field):

    widget = QCheckBox()
    widget.setObjectName(field['widgetname'])
    widget.setProperty('columnname', field['columnname'])
    if 'value' in field:
        if field['value'] in ("t", "true", True):
            widget.setChecked(True)
    if 'iseditable' in field:
        widget.setEnabled(field['iseditable'])
    return widget


def add_textarea(field):
    """ Add widgets QTextEdit type """

    widget = QTextEdit()
    widget.setObjectName(field['widgetname'])
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    if 'value' in field:
        widget.setText(field['value'])

    # Set height as a function of text lines
    font = widget.document().defaultFont()
    fm = QFontMetrics(font)
    text_size = fm.size(0, widget.toPlainText())
    if text_size.height() < 26:
        widget.setMinimumHeight(36)
        widget.setMaximumHeight(36)
    else:
        # Need to modify to avoid scroll
        widget.setMaximumHeight(text_size.height() + 10)

    if 'iseditable' in field:
        widget.setReadOnly(not field['iseditable'])
        if not field['iseditable']:
            widget.setStyleSheet("QLineEdit { background: rgb(242, 242, 242); color: rgb(100, 100, 100)}")

    return widget


def add_hyperlink(field):
    """ functions called in -> widget.clicked.connect(partial(getattr(global_vars.gw_infotools, func_name), widget))
            def open_url(self, widget)"""

    widget = GwHyperLinkLabel()
    widget.setObjectName(field['widgetname'])
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    if 'value' in field:
        widget.setText(field['value'])
    widget.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
    widget.resize(widget.sizeHint().width(), widget.sizeHint().height())
    func_name = 'no_function_associated'
    real_name = widget.objectName()[5:len(widget.objectName())]
    if 'widgetfunction' in field:
        if field['widgetfunction'] is not None:
            func_name = field['widgetfunction']
            exist = check_python_function(global_vars.gw_infotools, func_name)
            if not exist:
                msg = f"widget {real_name} have associated function {func_name}, but {func_name} not exist"
                show_message(msg, 2)
                return widget
        else:
            message = "Parameter widgetfunction is null for widget"
            show_message(message, 2, parameter=real_name)
    else:
        message = "Parameter not found"
        show_message(message, 2, parameter='widgetfunction')
    # Call function-->func_name(widget) or def no_function_associated(self, widget=None, message_level=1)
    widget.clicked.connect(partial(getattr(global_vars.gw_infotools, func_name), widget))

    return widget


def add_calendar(dialog, field):

    widget = QgsDateTimeEdit()
    widget.setObjectName(field['widgetname'])
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    widget.setAllowNull(True)
    widget.setCalendarPopup(True)
    widget.setDisplayFormat('dd/MM/yyyy')
    if 'value' in field and field['value'] not in ('', None, 'null'):
        date = QDate.fromString(field['value'].replace('/', '-'), 'yyyy-MM-dd')
        tools_qt.set_calendar(dialog, widget, date)
    else:
        widget.clear()
    btn_calendar = widget.findChild(QToolButton)

    btn_calendar.clicked.connect(partial(tools_qt.set_calendar_empty, widget))

    return widget


def set_typeahead(field, dialog, widget, completer):

    if field['widgettype'] == 'typeahead':
        if 'queryText' not in field or 'queryTextFilter' not in field:
            return widget
        widget.setProperty('typeahead', True)
        model = QStringListModel()
        widget.textChanged.connect(partial(fill_typeahead, completer, model, field, dialog, widget))

    return widget


def fill_typeahead(completer, model, field, dialog, widget):
    """ Set autocomplete of widget @table_object + "_id"
        getting id's from selected @table_object.
        WARNING: Each QLineEdit needs their own QCompleter and their own QStringListModel!!!
    """

    if not widget:
        return
    parent_id = ""
    if 'parentId' in field:
        parent_id = field["parentId"]

    extras = f'"queryText":"{field["queryText"]}"'
    extras += f', "queryTextFilter":"{field["queryTextFilter"]}"'
    extras += f', "parentId":"{parent_id}"'
    extras += f', "parentValue":"{tools_qt.get_text(dialog, "data_" + str(field["parentId"]))}"'
    extras += f', "textToSearch":"{tools_qt.get_text(dialog, widget)}"'
    body = create_body(extras=extras)
    complet_list = get_json('gw_fct_gettypeahead', body)
    if not complet_list or complet_list['status'] == 'Failed':
        return False

    list_items = []
    for field in complet_list['body']['data']:
        list_items.append(field['idval'])
    tools_qt.set_completer_object_api(completer, model, widget, list_items)


def set_data_type(field, widget):

    widget.setProperty('datatype', field['datatype'])
    return widget


def set_widget_size(widget, field):

    if 'widgetdim' in field:
        if field['widgetdim']:
            widget.setMaximumWidth(field['widgetdim'])
            widget.setMinimumWidth(field['widgetdim'])

    return widget


def add_lineedit(field):
    """ Add widgets QLineEdit type """

    widget = QLineEdit()
    widget.setObjectName(field['widgetname'])
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    if 'placeholder' in field:
        widget.setPlaceholderText(field['placeholder'])
    if 'value' in field:
        widget.setText(field['value'])
    if 'iseditable' in field:
        widget.setReadOnly(not field['iseditable'])
        if not field['iseditable']:
            widget.setStyleSheet("QLineEdit { background: rgb(242, 242, 242); color: rgb(100, 100, 100)}")

    return widget


def add_tableview(complet_result, field):
    """ Add widgets QTableView type """

    widget = QTableView()
    widget.setObjectName(field['widgetname'])
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    function_name = 'no_function_asociated'
    real_name = widget.objectName()[5:len(widget.objectName())]
    if 'widgetfunction' in field:
        if field['widgetfunction'] is not None:
            function_name = field['widgetfunction']
            exist = check_python_function(sys.modules[__name__], function_name)
            if not exist:
                msg = f"widget {real_name} have associated function {function_name}, but {function_name} not exist"
                show_message(msg, 2)
                return widget

    # Call def gw_api_open_rpt_result(widget, complet_result) of class ApiCf
    # noinspection PyUnresolvedReferences
    widget.doubleClicked.connect(partial(getattr(sys.modules[__name__], function_name), widget, complet_result))

    return widget


def add_frame(field, x=None):

    widget = QFrame()
    widget.setObjectName(f"{field['widgetname']}_{x}")
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    widget.setFrameShape(QFrame.HLine)
    widget.setFrameShadow(QFrame.Sunken)

    return widget



def add_combo(field):

    widget = QComboBox()
    widget.setObjectName(field['widgetname'])
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    widget = fill_combo(widget, field)
    if 'selectedId' in field:
        tools_qt.set_combo_value(widget, field['selectedId'], 0)
        widget.setProperty('selectedId', field['selectedId'])
    else:
        widget.setProperty('selectedId', None)
    if 'iseditable' in field:
        widget.setEnabled(bool(field['iseditable']))
        if not field['iseditable']:
            widget.setStyleSheet("QComboBox { background: rgb(242, 242, 242); color: rgb(100, 100, 100)}")
    return widget


def fill_combo(widget, field):
    # Generate list of items to add into combo

    widget.blockSignals(True)
    widget.clear()
    widget.blockSignals(False)
    combolist = []
    if 'comboIds' in field:
        if 'isNullValue' in field and field['isNullValue']:
            combolist.append(['', ''])
        for i in range(0, len(field['comboIds'])):
            elem = [field['comboIds'][i], field['comboNames'][i]]
            combolist.append(elem)

    # Populate combo
    for record in combolist:
        widget.addItem(record[1], record)

    return widget


def fill_combo_child(dialog, combo_child):

    child = dialog.findChild(QComboBox, str(combo_child['widgetname']))
    if child:
        fill_combo(child, combo_child)


def manage_child(dialog, combo_parent, combo_child):
    child = dialog.findChild(QComboBox, str(combo_child['widgetname']))
    if child:
        child.setEnabled(True)

        fill_combo_child(dialog, combo_child)
        if 'widgetcontrols' not in combo_child or not combo_child['widgetcontrols'] or \
                'enableWhenParent' not in combo_child['widgetcontrols']:
            return
        #
        if (str(tools_qt.get_combo_value(dialog, combo_parent, 0)) in str(combo_child['widgetcontrols']['enableWhenParent'])) \
                and (tools_qt.get_combo_value(dialog, combo_parent, 0) not in (None, '')):
            # The keepDisbled property is used to keep the edition enabled or disabled,
            # when we activate the layer and call the "enable_all" function
            child.setProperty('keepDisbled', False)
            child.setEnabled(True)
        else:
            child.setProperty('keepDisbled', True)
            child.setEnabled(False)


def get_child(dialog, widget, feature_type, tablename, field_id):
    """ Find QComboBox child and populate it
    :param dialog: QDialog
    :param widget: QComboBox parent
    :param feature_type: PIPE, ARC, JUNCTION, VALVE...
    :param tablename: view of DB
    :param field_id: Field id of tablename
    """

    combo_parent = widget.property('columnname')
    combo_id = tools_qt.get_combo_value(dialog, widget)

    feature = f'"featureType":"{feature_type}", '
    feature += f'"tableName":"{tablename}", '
    feature += f'"idName":"{field_id}"'
    extras = f'"comboParent":"{combo_parent}", "comboId":"{combo_id}"'
    body = create_body(feature=feature, extras=extras)
    result = get_json('gw_fct_getchilds', body)
    if not result or result['status'] == 'Failed':
        return False

    for combo_child in result['body']['data']:
        if combo_child is not None:
            manage_child(dialog, widget, combo_child)


def fill_child(dialog, widget, action, geom_type=''):

    combo_parent = widget.objectName()
    combo_id = tools_qt.get_combo_value(dialog, widget)
    # TODO cambiar por gw_fct_getchilds then unified with get_child if posible
    json_result = get_json('gw_fct_getcombochilds', f"'{action}' ,'' ,'' ,'{combo_parent}', '{combo_id}','{geom_type}'")
    for combo_child in json_result['fields']:
        if combo_child is not None:
            fill_combo_child(dialog, combo_child)


def get_expression_filter(geom_type, list_ids=None, layers=None):
    """ Set an expression filter with the contents of the list.
        Set a model with selected filter. Attach that model to selected table
    """

    list_ids = list_ids[geom_type]
    field_id = geom_type + "_id"
    if len(list_ids) == 0:
        return None

    # Set expression filter with features in the list
    expr_filter = field_id + " IN ("
    for i in range(len(list_ids)):
        expr_filter += f"'{list_ids[i]}', "
    expr_filter = expr_filter[:-2] + ")"

    # Check expression
    (is_valid, expr) = tools_qt.check_expression_filter(expr_filter)
    if not is_valid:
        return None

    # Select features of layers applying @expr
    tools_qgis.select_features_by_ids(geom_type, expr, layers=layers)

    return expr_filter


def get_actions_from_json(json_result, sql):
    """
    Manage options for layers (active, visible, zoom and indexing)
    :param json_result: Json result of a query (Json)
    :return: None
    """

    try:
        actions = json_result['body']['python_actions']
    except KeyError:
        return
    try:
        for action in actions:
            try:
                function_name = action['funcName']
                params = action['params']
                getattr(global_vars.gw_infotools, f"{function_name}")(**params)
            except AttributeError as e:
                # If function_name not exist as python function
                tools_log.log_warning(f"Exception error: {e}")
            except Exception as e:
                tools_log.log_debug(f"{type(e).__name__}: {e}")
    except Exception as e:
        manage_exception(None, f"{type(e).__name__}: {e}", sql, global_vars.schema_name)


def check_python_function(object_, function_name):

    object_functions = [method_name for method_name in dir(object_) if callable(getattr(object_, method_name))]
    return function_name in object_functions


def document_delete(qtable):
    status = tools_qt.delete_rows_qtv(qtable)
    if not status:
        message = "Error deleting data"
        show_warning(message)
        return
    else:
        message = "Document deleted"
        show_info(message)
        qtable.model().select()


# TODO End Generic Section


# TODO tools_gw_config


# TODO tools_gw_db

def get_layer_source_from_credentials(layer_name='v_edit_node'):
    """ Get database parameters from layer @layer_name or database connection settings """

    # Get layer @layer_name
    layer = tools_qgis.get_layer_by_tablename(layer_name)

    # Get database connection settings
    settings = QSettings()
    settings.beginGroup("PostgreSQL/connections")

    if layer is None and settings is None:
        not_version = False
        tools_log.log_warning(f"Layer '{layer_name}' is None and settings is None")
        global_vars.last_error = f"Layer not found: '{layer_name}'"
        return None, not_version

    # Get sslmode from user config file
    tools_config.manage_user_config_file()
    sslmode = tools_config.get_user_setting_value('sslmode', 'disable')

    credentials = None
    not_version = True
    if layer:
        not_version = False
        credentials = global_vars.controller.get_layer_source(layer)
        credentials['sslmode'] = sslmode
        global_vars.schema_name = credentials['schema']
        conn_info = QgsDataSourceUri(layer.dataProvider().dataSourceUri()).connectionInfo()
        status, credentials = connect_to_database_credentials(credentials, conn_info)
        if not status:
            tools_log.log_warning("Error connecting to database (layer)")
            global_vars.last_error = tr("Error connecting to database")
            return None, not_version

        # Put the credentials back (for yourself and the provider), as QGIS removes it when you "get" it
        QgsCredentials.instance().put(conn_info, credentials['user'], credentials['password'])

    elif settings:
        not_version = True
        default_connection = settings.value('selected')
        settings.endGroup()
        credentials = {'db': None, 'schema': None, 'table': None, 'service': None,
                       'host': None, 'port': None, 'user': None, 'password': None, 'sslmode': None}
        if default_connection:
            settings.beginGroup("PostgreSQL/connections/" + default_connection)
            if settings.value('host') in (None, ""):
                credentials['host'] = 'localhost'
            else:
                credentials['host'] = settings.value('host')
            credentials['port'] = settings.value('port')
            credentials['db'] = settings.value('database')
            credentials['user'] = settings.value('username')
            credentials['password'] = settings.value('password')
            credentials['sslmode'] = sslmode
            settings.endGroup()
            status, credentials = connect_to_database_credentials(credentials, max_attempts=0)
            if not status:
                tools_log.log_warning("Error connecting to database (settings)")
                global_vars.last_error = tr("Error connecting to database")
                return None, not_version
        else:
            tools_log.log_warning("Error getting default connection (settings)")
            global_vars.last_error = tr("Error getting default connection")
            return None, not_version

    global_vars.controller.credentials = credentials
    return credentials, not_version


def connect_to_database_credentials(credentials, conn_info=None, max_attempts=2):
    """ Connect to database with selected database @credentials """

    # Check if credential parameter 'service' is set
    if 'service' in credentials and credentials['service']:
        logged = global_vars.controller.connect_to_database_service(credentials['service'], credentials['sslmode'])
        return logged, credentials

    attempt = 0
    logged = False
    while not logged and attempt <= max_attempts:
        attempt += 1
        if conn_info and attempt > 1:
            (success, credentials['user'], credentials['password']) = \
                QgsCredentials.instance().get(conn_info, credentials['user'], credentials['password'])
        logged = global_vars.controller.connect_to_database(credentials['host'], credentials['port'], credentials['db'],
            credentials['user'], credentials['password'], credentials['sslmode'])

    return logged, credentials


def get_json(function_name, parameters=None, schema_name=None, commit=True, log_sql=False,
             log_result=False, json_loads=False, is_notify=False, rubber_band=None):
    """ Manage execution API function
    :param function_name: Name of function to call (text)
    :param parameters: Parameters for function (json) or (query parameters)
    :param commit: Commit sql (bool)
    :param log_sql: Show query in qgis log (bool)
    :return: Response of the function executed (json)
    """

    # Check if function exists
    row = check_function(function_name, schema_name, commit)
    if row in (None, ''):
        show_warning("Function not found in database", parameter=function_name)
        return None

    # Execute function. If failed, always log it
    if schema_name:
        sql = f"SELECT {schema_name}.{function_name}("
    else:
        sql = f"SELECT {function_name}("
    if parameters:
        sql += f"{parameters}"
    sql += f");"

    # Check log_sql for developers
    dev_log_sql = get_config_parser('developers', 'log_sql')
    if dev_log_sql not in (None, "None", "none"):
        log_sql = tools_os.cast_boolean(dev_log_sql)

    row = global_vars.controller.get_row(sql, commit=commit, log_sql=log_sql)
    if not row or not row[0]:
        tools_log.log_warning(f"Function error: {function_name}")
        tools_log.log_warning(sql)
        return None

    # Get json result
    if json_loads:
        # If content of row[0] is not a to json, cast it
        json_result = json.loads(row[0], object_pairs_hook=OrderedDict)
    else:
        json_result = row[0]

    # Log result
    if log_result:
        tools_log.log_info(json_result, stack_level_increase=1)

    # If failed, manage exception
    if 'status' in json_result and json_result['status'] == 'Failed':
        manage_exception_api(json_result, sql, is_notify=is_notify)
        return json_result

    try:
        # Layer styles
        manage_return_manager(json_result, sql, rubber_band)
        manage_layer_manager(json_result, sql)
        get_actions_from_json(json_result, sql)
    except Exception:
        pass

    return json_result


def check_function(function_name, schema_name=None, commit=True):
    """ Check if @function_name exists in selected schema """

    if schema_name is None:
        schema_name = global_vars.schema_name

    schema_name = schema_name.replace('"', '')
    sql = ("SELECT routine_name FROM information_schema.routines "
           "WHERE lower(routine_schema) = %s "
           "AND lower(routine_name) = %s")
    params = [schema_name, function_name]
    row = global_vars.controller.get_row(sql, params=params, commit=commit)
    return row


def manage_exception_api(json_result, sql=None, stack_level=2, stack_level_increase=0, is_notify=False):
    """ Manage exception in JSON database queries and show information to the user """

    try:

        if 'message' in json_result:

            parameter = None
            level = 1
            if 'level' in json_result['message']:
                level = int(json_result['message']['level'])
            if 'text' in json_result['message']:
                msg = json_result['message']['text']
            else:
                parameter = 'text'
                msg = "Key on returned json from ddbb is missed"
            if is_notify is True:
                tools_log.log_info(msg, parameter=parameter, level=level)
            elif not is_notify and global_vars.show_db_exception:
                # Show exception message only if we are not in a task process
                show_message(msg, level, parameter=parameter)

        else:

            stack_level += stack_level_increase
            module_path = inspect.stack()[stack_level][1]
            file_name = tools_os.get_relative_path(module_path, 2)
            function_line = inspect.stack()[stack_level][2]
            function_name = inspect.stack()[stack_level][3]

            # Set exception message details
            title = "Database API execution failed"
            msg = ""
            msg += f"File name: {file_name}\n"
            msg += f"Function name: {function_name}\n"
            msg += f"Line number: {function_line}\n"
            if 'SQLERR' in json_result:
                msg += f"Detail: {json_result['SQLERR']}\n"
            elif 'NOSQLERR' in json_result:
                msg += f"Detail: {json_result['NOSQLERR']}\n"
            if 'SQLCONTEXT' in json_result:
                msg += f"Context: {json_result['SQLCONTEXT']}\n"
            if sql:
                msg += f"SQL: {sql}"

            tools_log.log_warning(msg, stack_level_increase=2)
            # Show exception message only if we are not in a task process
            if global_vars.show_db_exception:
                show_exceptions_msg(title, msg)

    except Exception:
        manage_exception("Unhandled Error")


def manage_return_manager(json_result, sql, rubber_band=None):
    """
    Manage options for layers (active, visible, zoom and indexing)
    :param json_result: Json result of a query (Json)
    :param sql: query executed (String)
    :return: None
    """

    try:
        return_manager = json_result['body']['returnManager']
    except KeyError:
        return
    srid = global_vars.srid
    try:
        margin = None
        opacity = 100

        if 'zoom' in return_manager and 'margin' in return_manager['zoom']:
            margin = return_manager['zoom']['margin']

        if 'style' in return_manager and 'ruberband' in return_manager['style']:
            # Set default values
            width = 3
            color = QColor(255, 0, 0, 125)
            if 'transparency' in return_manager['style']['ruberband']:
                opacity = return_manager['style']['ruberband']['transparency'] * 255
            if 'color' in return_manager['style']['ruberband']:
                color = return_manager['style']['ruberband']['color']
                color = QColor(color[0], color[1], color[2], opacity)
            if 'width' in return_manager['style']['ruberband']:
                width = return_manager['style']['ruberband']['width']
            draw_by_json(json_result, rubber_band, margin, color=color, width=width)

        else:

            for key, value in list(json_result['body']['data'].items()):
                if key.lower() in ('point', 'line', 'polygon'):
                    if key not in json_result['body']['data']:
                        continue
                    if 'features' not in json_result['body']['data'][key]:
                        continue
                    if len(json_result['body']['data'][key]['features']) == 0:
                        continue

                    layer_name = f'{key}'
                    if 'layerName' in json_result['body']['data'][key]:
                        if json_result['body']['data'][key]['layerName']:
                            layer_name = json_result['body']['data'][key]['layerName']

                    tools_qgis.remove_layer_from_toc(layer_name, 'GW Temporal Layers')

                    # Get values for create and populate layer
                    counter = len(json_result['body']['data'][key]['features'])
                    geometry_type = json_result['body']['data'][key]['geometryType']
                    v_layer = QgsVectorLayer(f"{geometry_type}?crs=epsg:{srid}", layer_name, 'memory')

                    populate_vlayer(v_layer, json_result['body']['data'], key, counter)

                    # Get values for set layer style
                    opacity = 100
                    style_type = json_result['body']['returnManager']['style']
                    if 'style' in return_manager and 'transparency' in return_manager['style'][key]:
                        opacity = return_manager['style'][key]['transparency'] * 255

                    if style_type[key]['style'] == 'categorized':
                        color_values = {}
                        for item in json_result['body']['returnManager']['style'][key]['values']:
                            color = QColor(item['color'][0], item['color'][1], item['color'][2], opacity * 255)
                            color_values[item['id']] = color
                        cat_field = str(style_type[key]['field'])
                        size = style_type['width'] if 'width' in style_type and style_type['width'] else 2
                        tools_qgis.set_layer_categoryze(v_layer, cat_field, size, color_values)

                    elif style_type[key]['style'] == 'random':
                        size = style_type['width'] if 'width' in style_type and style_type['width'] else 2
                        if geometry_type == 'Point':
                            v_layer.renderer().symbol().setSize(size)
                        else:
                            v_layer.renderer().symbol().setWidth(size)
                        v_layer.renderer().symbol().setOpacity(opacity)

                    elif style_type[key]['style'] == 'qml':
                        style_id = style_type[key]['id']
                        extras = f'"style_id":"{style_id}"'
                        body = create_body(extras=extras)
                        style = get_json('gw_fct_getstyle', body)
                        if style['status'] == 'Failed': return
                        if 'styles' in style['body']:
                            if 'style' in style['body']['styles']:
                                qml = style['body']['styles']['style']
                                create_qml(v_layer, qml)

                    elif style_type[key]['style'] == 'unique':
                        color = style_type[key]['values']['color']
                        size = style_type['width'] if 'width' in style_type and style_type['width'] else 2
                        color = QColor(color[0], color[1], color[2])
                        if key == 'point':
                            v_layer.renderer().symbol().setSize(size)
                        elif key in ('line', 'polygon'):
                            v_layer.renderer().symbol().setWidth(size)
                        v_layer.renderer().symbol().setColor(color)
                        v_layer.renderer().symbol().setOpacity(opacity)

                    global_vars.iface.layerTreeView().refreshLayerSymbology(v_layer.id())
                    if margin:
                        set_margin(v_layer, margin)

    except Exception as e:
        manage_exception(None, f"{type(e).__name__}: {e}", sql, global_vars.schema_name)


def get_rows_by_feature_type(dialog, table_object, geom_type, ids=None, list_ids=None, layers=None):
    """ Get records of @geom_type associated to selected @table_object """

    object_id = tools_qt.get_text(dialog, table_object + "_id")
    table_relation = table_object + "_x_" + geom_type
    widget_name = "tbl_" + table_relation

    exists = tools_db.check_table(table_relation)
    if not exists:
        tools_log.log_info(f"Not found: {table_relation}")
        return ids, layers, list_ids

    sql = (f"SELECT {geom_type}_id "
           f"FROM {table_relation} "
           f"WHERE {table_object}_id = '{object_id}'")
    rows = global_vars.controller.get_rows(sql, log_info=False)
    if rows:
        for row in rows:
            list_ids[geom_type].append(str(row[0]))
            ids.append(str(row[0]))

        expr_filter = get_expression_filter(geom_type, list_ids=list_ids, layers=layers)
        set_table_model(dialog, widget_name, geom_type, expr_filter)

    return ids, layers, list_ids


def get_project_type(schemaname=None):
    """ Get project type from table 'version' """

    # init variables
    project_type = None
    if schemaname is None:
        schemaname = global_vars.schema_name

    # start process
    tablename = "sys_version"
    exists = tools_db.check_table(tablename, schemaname)
    if exists:
        sql = ("SELECT lower(project_type) FROM " + schemaname + "." + tablename + " ORDER BY id ASC LIMIT 1")
        row = global_vars.controller.get_row(sql)
        if row:
            project_type = row[0]
    else:
        tablename = "version"
        exists = tools_db.check_table(tablename, schemaname)
        if exists:
            sql = ("SELECT lower(wsoftware) FROM " + schemaname + "." + tablename + " ORDER BY id ASC LIMIT 1")
            row = global_vars.controller.get_row(sql)
            if row:
                project_type = row[0]
        else:
            tablename = "version_tm"
            exists = tools_db.check_table(tablename, schemaname)
            if exists:
                project_type = "tm"

    return project_type


def get_group_layers(geom_type):
    """ Get layers of the group @geom_type """

    list_items = []
    sql = ("SELECT child_layer "
           "FROM cat_feature "
           "WHERE upper(feature_type) = '" + geom_type.upper() + "' "
           "UNION SELECT DISTINCT parent_layer "
           "FROM cat_feature "
           "WHERE upper(feature_type) = '" + geom_type.upper() + "';")
    rows = global_vars.controller.get_rows(sql)
    if rows:
        for row in rows:
            layer = tools_qgis.get_layer_by_tablename(row[0])
            if layer:
                list_items.append(layer)

    return list_items


def get_restriction(qgis_project_role):

    role_edit = False
    role_om = False
    role_epa = False
    role_basic = False

    role_master = tools_db.check_role_user("role_master")
    if not role_master:
        role_epa = tools_db.check_role_user("role_epa")
        if not role_epa:
            role_edit = tools_db.check_role_user("role_edit")
            if not role_edit:
                role_om = tools_db.check_role_user("role_om")
                if not role_om:
                    role_basic = tools_db.check_role_user("role_basic")
    super_users = global_vars.settings.value('system_variables/super_users')

    # Manage user 'postgres'
    if global_vars.user == 'postgres' or global_vars.user == 'gisadmin':
        role_master = True

    # Manage super_user
    if super_users is not None:
        if global_vars.user in super_users:
            role_master = True

    if role_basic or qgis_project_role == 'role_basic':
        return 'role_basic'
    elif role_om or qgis_project_role == 'role_om':
        return 'role_om'
    elif role_edit or qgis_project_role == 'role_edit':
        return 'role_edit'
    elif role_epa or qgis_project_role == 'role_epa':
        return 'role_epa'
    elif role_master or qgis_project_role == 'role_master':
        return 'role_master'
    else:
        return 'role_basic'


def get_config(parameter='', columns='value', table='config_param_user', sql_added=None, log_info=True):

    sql = f"SELECT {columns} FROM {table} WHERE parameter = '{parameter}' "
    if sql_added:
        sql += sql_added
    if table == 'config_param_user':
        sql += " AND cur_user = current_user"
    sql += ";"
    row = global_vars.controller.get_row(sql, log_info=log_info)
    return row

# TODO tools_gw_log


# TODO tools_gw_os


# TODO tools_gw_pgdao


# TODO tools_gw_qgis

def show_message(text, message_level=1, duration=10, context_name=None, parameter=None, title=""):
    """ Show message to the user with selected message level
    message_level: {INFO = 0(blue), WARNING = 1(yellow), CRITICAL = 2(red), SUCCESS = 3(green)} """

    # Check duration message for developers
    dev_duration = get_config_parser('developers', 'show_message_durations')
    if dev_duration not in (None, "None"):
        duration = int(duration)

    msg = None
    if text:
        msg = tr(text, context_name)
        if parameter:
            msg += ": " + str(parameter)
    try:

        global_vars.iface.messageBar().pushMessage(title, msg, message_level, duration)
    except AttributeError:
        pass


def show_info( text, duration=10, context_name=None, parameter=None, logger_file=True, title=""):
    """ Show information message to the user """

    show_message(text, 0, duration, context_name, parameter, title)
    if global_vars.logger and logger_file:
        global_vars.logger.info(text)


def show_warning(text, duration=10, context_name=None, parameter=None, logger_file=True, title=""):
    """ Show warning message to the user """

    show_message(text, 1, duration, context_name, parameter, title)
    if global_vars.logger and logger_file:
        global_vars.logger.warning(text)


def show_critical(text, duration=10, context_name=None, parameter=None, logger_file=True, title=""):
    """ Show warning message to the user """

    show_message(text, 2, duration, context_name, parameter, title)
    if global_vars.logger and logger_file:
        global_vars.logger.critical(text)


def manage_layer_manager(json_result, sql):
    """
    Manage options for layers (active, visible, zoom and indexing)
    :param json_result: Json result of a query (Json)
    :return: None
    """

    try:
        layermanager = json_result['body']['layerManager']
    except KeyError:
        return

    try:

        # force visible and in case of does not exits, load it
        if 'visible' in layermanager:
            for lyr in layermanager['visible']:
                layer_name = [key for key in lyr][0]
                layer = tools_qgis.get_layer_by_tablename(layer_name)
                if layer is None:
                    the_geom = lyr[layer_name]['geom_field']
                    field_id = lyr[layer_name]['pkey_field']
                    if lyr[layer_name]['group_layer'] is not None:
                        group = lyr[layer_name]['group_layer']
                    else:
                        group = "GW Layers"
                    style_id = lyr[layer_name]['style_id']
                    insert_pg_layer(layer_name, the_geom, field_id, group=group, style_id=style_id)
                tools_qgis.set_layer_visible(layer)

        # force reload dataProvider in order to reindex.
        if 'index' in layermanager:
            for lyr in layermanager['index']:
                layer_name = [key for key in lyr][0]
                layer = tools_qgis.get_layer_by_tablename(layer_name)
                if layer:
                    tools_qgis.set_layer_index(layer)

        # Set active
        if 'active' in layermanager:
            layer = tools_qgis.get_layer_by_tablename(layermanager['active'])
            if layer:
                global_vars.iface.setActiveLayer(layer)

        # Set zoom to extent with a margin
        if 'zoom' in layermanager:
            layer = tools_qgis.get_layer_by_tablename(layermanager['zoom']['layer'])
            if layer:
                prev_layer = global_vars.iface.activeLayer()
                global_vars.iface.setActiveLayer(layer)
                global_vars.iface.zoomToActiveLayer()
                margin = layermanager['zoom']['margin']
                set_margin(layer, margin)
                if prev_layer:
                    global_vars.iface.setActiveLayer(prev_layer)

        # Set snnaping options
        if 'snnaping' in layermanager:
            snapper_manager = SnappingConfigManager(global_vars.iface)
            for layer_name in layermanager['snnaping']:
                layer = tools_qgis.get_layer_by_tablename(layer_name)
                if layer:
                    QgsProject.instance().blockSignals(True)
                    layer_settings = snapper_manager.snap_to_layer(layer, QgsPointLocator.All, True)
                    if layer_settings:
                        layer_settings.setType(2)
                        layer_settings.setTolerance(15)
                        layer_settings.setEnabled(True)
                    else:
                        layer_settings = QgsSnappingConfig.IndividualLayerSettings(True, 2, 15, 1)
                    snapping_config = snapper_manager.get_snapping_options()
                    snapping_config.setIndividualLayerSettings(layer, layer_settings)
                    QgsProject.instance().blockSignals(False)
                    QgsProject.instance().snappingConfigChanged.emit(snapping_config)
            snapper_manager.set_snap_mode()
            del snapper_manager


    except Exception as e:
        manage_exception(None, f"{type(e).__name__}: {e}", sql, global_vars.schema_name)


def set_margin(layer, margin):
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


def selection_init(dialog, table_object, query=False, geom_type=None, layers=None):
    """ Set canvas map tool to an instance of class 'MultipleSelection' """
    if geom_type is None:
        geom_type = get_signal_change_tab(dialog)
        if geom_type in ('all', None):
            geom_type = 'arc'
    multiple_selection = MultipleSelection(layers, geom_type, table_object=table_object, dialog=dialog, query=query)
    global_vars.canvas.setMapTool(multiple_selection)
    cursor = get_cursor_multiple_selection()
    global_vars.canvas.setCursor(cursor)


def selection_changed(dialog, table_object, geom_type, query=False, layers=None,
                      list_ids={"arc":[], "node":[], "connec":[], "gully":[], "element":[]}, lazy_widget=None,
                      lazy_init_function=None):
    """ Slot function for signal 'canvas.selectionChanged' """
    tools_qgis.disconnect_signal_selection_changed()
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

        tools_qgis.select_features_by_ids(geom_type, expr, layers=layers)

    # Reload contents of table 'tbl_@table_object_x_@geom_type'
    if query:
        insert_feature_to_plan(dialog, geom_type, ids=ids)
        layers = remove_selection()
        reload_qtable(dialog, geom_type)
    else:
        load_table(dialog, table_object, geom_type, expr_filter)
        tools_qt.set_lazy_init(table_object, lazy_widget=lazy_widget, lazy_init_function=lazy_init_function)

    # Remove selection in generic 'v_edit' layers
    layers = remove_selection(False)

    enable_feature_type(dialog, table_object, ids=ids)

    return ids, layers, list_ids


def insert_feature(dialog, table_object, query=False, remove_ids=True, geom_type=None, ids=None, layers=None,
                   list_ids=None, lazy_widget=None, lazy_init_function=None):
    """ Select feature with entered id. Set a model with selected filter.
        Attach that model to selected table
    """

    tools_qgis.disconnect_signal_selection_changed()

    if geom_type in ('all', None):
        geom_type = get_signal_change_tab(dialog)

    # Clear list of ids
    if remove_ids:
        ids = []

    field_id = f"{geom_type}_id"
    feature_id = tools_qt.get_text(dialog, "feature_id")
    expr_filter = f"{field_id} = '{feature_id}'"

    # Check expression
    (is_valid, expr) = tools_qt.check_expression_filter(expr_filter)
    if not is_valid:
        return None

    # Select features of layers applying @expr
    tools_qgis.select_features_by_ids(geom_type, expr, layers=layers)

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
        load_table(dialog, table_object, geom_type, expr_filter)
        tools_qt.set_lazy_init(table_object, lazy_widget=lazy_widget, lazy_init_function=lazy_init_function)

    # Update list
    list_ids[geom_type] = ids
    enable_feature_type(dialog, table_object, ids=ids)
    connect_signal_selection_changed(dialog, table_object, geom_type)

    tools_log.log_info(list_ids[geom_type])

    return ids, layers, list_ids


def remove_selection(remove_groups=True, layers=None):
    """ Remove all previous selections """

    layer = tools_qgis.get_layer_by_tablename("v_edit_arc")
    if layer:
        layer.removeSelection()
    layer = tools_qgis.get_layer_by_tablename("v_edit_node")
    if layer:
        layer.removeSelection()
    layer = tools_qgis.get_layer_by_tablename("v_edit_connec")
    if layer:
        layer.removeSelection()
    layer = tools_qgis.get_layer_by_tablename("v_edit_element")
    if layer:
        layer.removeSelection()

    if global_vars.project_type == 'ud':
        layer = tools_qgis.get_layer_by_tablename("v_edit_gully")
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


def insert_feature_to_plan(dialog, geom_type, ids=None):
    """ Insert features_id to table plan_@geom_type_x_psector """

    value = tools_qt.get_text(dialog, dialog.psector_id)
    for i in range(len(ids)):
        sql = f"INSERT INTO plan_psector_x_{geom_type} ({geom_type}_id, psector_id) "
        sql += f"VALUES('{ids[i]}', '{value}') ON CONFLICT DO NOTHING;"
        global_vars.controller.execute_sql(sql)
        reload_qtable(dialog, geom_type)


def connect_signal_selection_changed(dialog, table_object, query=False, geom_type=None, layers=None, form=None,
                                    list_ids=None):
    """ Connect signal selectionChanged """

    try:
        if geom_type in ('all', None):
            geom_type = 'arc'
        if form == "psector":
            global_vars.canvas.selectionChanged.connect(
                partial(selection_changed, dialog, table_object, geom_type, query, layers=layers,
                        list_ids=list_ids))
        else:
            global_vars.canvas.selectionChanged.connect(
                partial(selection_changed, dialog, table_object, geom_type, query, layers=layers))
    except Exception as e:
        tools_log.log_info(f"connect_signal_selection_changed: {e}")


# TODO tools_gw_qt

def tr(message, context_name=None):
    """ Translate @message looking it in @context_name """

    if context_name is None:
        context_name = global_vars.plugin_name

    value = None
    try:
        value = QCoreApplication.translate(context_name, message)
    except TypeError:
        value = QCoreApplication.translate(context_name, str(message))
    finally:
        # If not translation has been found, check into 'ui_message' context
        if value == message:
            value = QCoreApplication.translate('ui_message', message)

    return value


def translate_tooltip(context_name, widget, idx=None):
    """ Translate tooltips widgets of the form to current language
        If we find a translation, it will be put
        If the object does not have a tooltip we will put the object text itself as a tooltip
    """

    if type(widget) is QTabWidget:
        widget_name = widget.widget(idx).objectName()
        tooltip = tr(f'tooltip_{widget_name}', context_name)
        if tooltip not in (f'tooltip_{widget_name}', None, 'None'):
            widget.setTabToolTip(idx, tooltip)
        elif widget.toolTip() in ("", None):
            widget.setTabToolTip(idx, widget.tabText(idx))
    else:
        widget_name = widget.objectName()
        tooltip = tr(f'tooltip_{widget_name}', context_name)
        if tooltip not in (f'tooltip_{widget_name}', None, 'None'):
            widget.setToolTip(tooltip)
        elif widget.toolTip() in ("", None):
            if type(widget) is QGroupBox:
                widget.setToolTip(widget.title())
            else:
                widget.setToolTip(widget.text())



def translate_form(dialog, context_name):
    """ Translate widgets of the form to current language """
    type_widget_list = [QCheckBox, QGroupBox, QLabel, QPushButton, QRadioButton, QTabWidget]
    for widget_type in type_widget_list:
        widget_list = dialog.findChildren(widget_type)
        for widget in widget_list:
            translate_widget(context_name, widget)

    # Translate title of the form
    text = tr('title', context_name)
    if text != 'title':
        dialog.setWindowTitle(text)


def translate_widget(context_name, widget):
    """ Translate widget text """

    if not widget:
        return

    widget_name = ""
    try:
        if type(widget) is QTabWidget:
            num_tabs = widget.count()
            for i in range(0, num_tabs):
                widget_name = widget.widget(i).objectName()
                text = tr(widget_name, context_name)
                if text not in (widget_name, None, 'None'):
                    widget.setTabText(i, text)
                else:
                    widget_text = widget.tabText(i)
                    text = tr(widget_text, context_name)
                    if text != widget_text:
                        widget.setTabText(i, text)
                translate_tooltip(context_name, widget, i)
        elif type(widget) is QToolBox:
            num_tabs = widget.count()
            for i in range(0, num_tabs):
                widget_name = widget.widget(i).objectName()
                text = tr(widget_name, context_name)
                if text not in (widget_name, None, 'None'):
                    widget.setItemText(i, text)
                else:
                    widget_text = widget.itemText(i)
                    text = tr(widget_text, context_name)
                    if text != widget_text:
                        widget.setItemText(i, text)
                translate_tooltip(context_name, widget.widget(i))
        elif type(widget) is QGroupBox:
            widget_name = widget.objectName()
            text = tr(widget_name, context_name)
            if text not in (widget_name, None, 'None'):
                widget.setTitle(text)
            else:
                widget_title = widget.title()
                text = tr(widget_title, context_name)
                if text != widget_title:
                    widget.setTitle(text)
            translate_tooltip(context_name, widget)
        else:
            widget_name = widget.objectName()
            text = tr(widget_name, context_name)
            if text not in (widget_name, None, 'None'):
                widget.setText(text)
            else:
                widget_text = widget.text()
                text = tr(widget_text, context_name)
                if text != widget_text:
                    widget.setText(text)
            translate_tooltip(context_name, widget)

    except Exception as e:
        tools_log.log_info(f"{widget_name} --> {type(e).__name__} --> {e}")


def add_translator(locale_path, log_info=False):
    """ Add translation file to the list of translation files to be used for translations """

    if os.path.exists(locale_path):
        global_vars.translator = QTranslator()
        global_vars.translator.load(locale_path)
        QCoreApplication.installTranslator(global_vars.translator)
        if log_info:
            tools_log.log_info("Add translator", parameter=locale_path)
    else:
        if log_info:
            tools_log.log_info("Locale not found", parameter=locale_path)


def manage_translation(context_name, dialog=None, log_info=False):
    """ Manage locale and corresponding 'i18n' file """

    # Get locale of QGIS application
    try:
        locale = QSettings().value('locale/userLocale').lower()
    except AttributeError:
        locale = "en"

    if locale == 'es_es':
        locale = 'es'
    elif locale == 'es_ca':
        locale = 'ca'
    elif locale == 'en_us':
        locale = 'en'

    # If user locale file not found, set English one by default
    locale_path = os.path.join(global_vars.plugin_dir, 'i18n', f'giswater_{locale}.qm')
    if not os.path.exists(locale_path):
        if log_info:
            tools_log.log_info("Locale not found", parameter=locale_path)
        locale_default = 'en'
        locale_path = os.path.join(global_vars.plugin_dir, 'i18n', f'giswater_{locale_default}.qm')
        # If English locale file not found, exit function
        # It means that probably that form has not been translated yet
        if not os.path.exists(locale_path):
            if log_info:
                tools_log.log_info("Locale not found", parameter=locale_path)
            return

    # Add translation file
    add_translator(locale_path)

    # If dialog is set, then translate form
    if dialog:
        translate_form(dialog, context_name)


def show_exceptions_msg(title=None, msg="", window_title="Information about exception", pattern=None):
    """ Show exception message in dialog """

    global_vars.dlg_info = DialogTextUi()
    global_vars.dlg_info.btn_accept.setVisible(False)
    global_vars.dlg_info.btn_close.clicked.connect(lambda: global_vars.dlg_info.close())
    global_vars.dlg_info.setWindowTitle(window_title)
    if title:
        global_vars.dlg_info.lbl_text.setText(title)
    tools_qt.set_widget_text(global_vars.dlg_info, global_vars.dlg_info.txt_infolog, msg)
    global_vars.dlg_info.setWindowFlags(Qt.WindowStaysOnTopHint)
    if pattern is None:
        pattern = "File\sname:|Function\sname:|Line\snumber:|SQL:|SQL\sfile:|Detail:|Context:|Description|Schema name"
    tools_qt.set_text_bold(global_vars.dlg_info.txt_infolog, pattern)

    # Show dialog only if we are not in a task process
    if global_vars.show_db_exception:
        show_dlg_info()


def manage_exception(title=None, description=None, sql=None, schema_name=None):
    """ Manage exception and show information to the user """

    # Get traceback
    trace = traceback.format_exc()
    exc_type, exc_obj, exc_tb = sys.exc_info()
    path = exc_tb.tb_frame.f_code.co_filename
    file_name = os.path.split(path)[1]
    #folder_name = os.path.dirname(path)

    # Set exception message details
    msg = ""
    msg += f"Error type: {exc_type}\n"
    msg += f"File name: {file_name}\n"
    msg += f"Line number: {exc_tb.tb_lineno}\n"
    msg += f"{trace}\n"
    if description:
        msg += f"Description: {description}\n"
    if sql:
        msg += f"SQL:\n {sql}\n\n"
    msg += f"Schema name: {schema_name}"

    # Show exception message in dialog and log it
    show_exceptions_msg(title, msg)
    tools_log.log_warning(msg)

    # Log exception message
    tools_log.log_warning(msg)

    # Show exception message only if we are not in a task process
    if global_vars.show_db_exception:
        show_exceptions_msg(title, msg)


def manage_exception_db(exception=None, sql=None, stack_level=2, stack_level_increase=0, filepath=None, schema_name=None):
    """ Manage exception in database queries and show information to the user """

    show_exception_msg = True
    description = ""
    if exception:
        description = str(exception)
        if 'unknown error' in description:
            show_exception_msg = False

    try:
        stack_level += stack_level_increase
        module_path = inspect.stack()[stack_level][1]
        file_name = tools_os.get_relative_path(module_path, 2)
        function_line = inspect.stack()[stack_level][2]
        function_name = inspect.stack()[stack_level][3]

        # Set exception message details
        msg = ""
        msg += f"File name: {file_name}\n"
        msg += f"Function name: {function_name}\n"
        msg += f"Line number: {function_line}\n"
        if exception:
            msg += f"Description:\n{description}\n"
        if filepath:
            msg += f"SQL file:\n{filepath}\n\n"
        if sql:
            msg += f"SQL:\n {sql}\n\n"
        msg += f"Schema name: {schema_name}"

        # Show exception message in dialog and log it
        if show_exception_msg:
            title = "Database error"
            show_exceptions_msg(title, msg)
        else:
            tools_log.log_warning("Exception message not shown to user")
        tools_log.log_warning(msg, stack_level_increase=2)

    except Exception:
        manage_exception("Unhandled Error")


def show_dlg_info():
    """ Show dialog with exception message generated in function show_exceptions_msg """

    if global_vars.dlg_info:
        global_vars.dlg_info.show()

def dock_dialog(dialog):

    positions = {8: Qt.BottomDockWidgetArea, 4: Qt.TopDockWidgetArea,
                 2: Qt.RightDockWidgetArea, 1: Qt.LeftDockWidgetArea}
    try:
        global_vars.dlg_docker.setWindowTitle(dialog.windowTitle())
        global_vars.dlg_docker.setWidget(dialog)
        global_vars.dlg_docker.setWindowFlags(Qt.WindowContextHelpButtonHint)
        global_vars.iface.addDockWidget(positions[global_vars.dlg_docker.position], global_vars.dlg_docker)
    except RuntimeError as e:
        tools_log.log_warning(f"{type(e).__name__} --> {e}")


def init_docker(docker_param='qgis_info_docker'):
    """ Get user config parameter @docker_param """

    global_vars.show_docker = True
    if docker_param == 'qgis_main_docker':
        # Show 'main dialog' in docker depending its value in user settings
        qgis_main_docker = tools_config.get_user_setting_value(docker_param, 'true')
        value = qgis_main_docker.lower()
    else:
        # Show info or form in docker?
        row = get_config(docker_param)
        if not row:
            global_vars.dlg_docker = None
            global_vars.docker_type = None
            return None
        value = row[0].lower()

    # Check if docker has dialog of type 'form' or 'main'
    if docker_param == 'qgis_info_docker':
        if global_vars.dlg_docker:
            if global_vars.docker_type:
                if global_vars.docker_type != 'qgis_info_docker':
                    global_vars.show_docker = False
                    return None

    if value == 'true':
        close_docker()
        global_vars.docker_type = docker_param
        global_vars.dlg_docker = DockerUi()
        global_vars.dlg_docker.dlg_closed.connect(close_docker)
        manage_docker_options()
    else:
        global_vars.dlg_docker = None
        global_vars.docker_type = None

    return global_vars.dlg_docker


def close_docker():
    """ Save QDockWidget position (1=Left, 2=Right, 4=Top, 8=Bottom),
        remove from iface and del class
    """
    try:
        if global_vars.dlg_docker:
            if not global_vars.dlg_docker.isFloating():
                docker_pos = global_vars.iface.mainWindow().dockWidgetArea(global_vars.dlg_docker)
                widget = global_vars.dlg_docker.widget()
                if widget:
                    widget.close()
                    del widget
                    global_vars.dlg_docker.setWidget(None)
                    global_vars.docker_type = None
                    set_config_parser('docker_info', 'position', f'{docker_pos}')
                global_vars.iface.removeDockWidget(global_vars.dlg_docker)
                global_vars.dlg_docker = None
    except AttributeError:
        global_vars.docker_type = None
        global_vars.dlg_docker = None


def manage_docker_options():
    """ Check if user want dock the dialog or not """

    # Load last docker position
    try:
        # Docker positions: 1=Left, 2=Right, 4=Top, 8=Bottom
        pos = int(get_config_parser('docker_info', 'position'))
        global_vars.dlg_docker.position = 2
        if pos in (1, 2, 4, 8):
            global_vars.dlg_docker.position = pos
    except:
        global_vars.dlg_docker.position = 2


def set_table_model(dialog, table_object, geom_type, expr_filter):
    """ Sets a TableModel to @widget_name attached to
        @table_name and filter @expr_filter
    """

    expr = None
    if expr_filter:
        # Check expression
        (is_valid, expr) = tools_qt.check_expression_filter(expr_filter)  # @UnusedVariable
        if not is_valid:
            return expr

    # Set a model with selected filter expression
    #TODO:: Remove this if/else, parametize geom_type, send all layers maybe?
    if geom_type in ("v_rtc_hydrometer"):
        table_name = geom_type
    else:
        table_name = f"v_edit_{geom_type}"
    if global_vars.schema_name not in table_name:
        table_name = global_vars.schema_name + "." + table_name

    # Set the model
    model = QSqlTableModel(db=global_vars.controller.db)
    model.setTable(table_name)
    model.setEditStrategy(QSqlTableModel.OnManualSubmit)
    model.select()
    if model.lastError().isValid():
        show_warning(model.lastError().text())
        return expr

    # Attach model to selected widget
    if type(table_object) is str:
        widget = tools_qt.get_widget(dialog, table_object)
        if not widget:
            message = "Widget not found"
            tools_log.log_info(message, parameter=table_object)
            return expr
    elif type(table_object) is QTableView:
        # parent_vars.controller.log_debug(f"set_table_model: {table_object.objectName()}")
        widget = table_object
    else:
        msg = "Table_object is not a table name or QTableView"
        tools_log.log_info(msg)
        return expr

    if expr_filter:
        widget.setModel(model)
        widget.model().setFilter(expr_filter)
        widget.model().select()
    else:
        widget.setModel(None)

    return expr


def set_tablemodel_config(dialog, widget, table_name, sort_order=0, isQStandardItemModel=False, schema_name=None):
    """ Configuration of tables. Set visibility and width of columns """

    widget = tools_qt.get_widget(dialog, widget)
    if not widget:
        return

    if schema_name is not None:
        config_table = f"{schema_name}.config_form_tableview"
    else:
        config_table = f"config_form_tableview"

    # Set width and alias of visible columns
    columns_to_delete = []
    sql = (f"SELECT columnindex, width, alias, status"
           f" FROM {config_table}"
           f" WHERE tablename = '{table_name}'"
           f" ORDER BY columnindex")
    rows = global_vars.controller.get_rows(sql, log_info=False)
    if not rows:
        return

    for row in rows:
        if not row['status']:
            columns_to_delete.append(row['columnindex'] - 1)
        else:
            width = row['width']
            if width is None:
                width = 100
            widget.setColumnWidth(row['columnindex'] - 1, width)
            widget.model().setHeaderData(row['columnindex'] - 1, Qt.Horizontal, row['alias'])

    # Set order
    if isQStandardItemModel:
        widget.model().sort(0, sort_order)
    else:
        widget.model().setSort(0, sort_order)
        widget.model().select()
    # Delete columns
    for column in columns_to_delete:
        widget.hideColumn(column)

    return widget


def add_icon(widget, icon):
    """ Set @icon to selected @widget """

    # Get icons folder
    icons_folder = os.path.join(global_vars.plugin_dir, f"icons{os.sep}shared")
    icon_path = os.path.join(icons_folder, str(icon) + ".png")
    if os.path.exists(icon_path):
        widget.setIcon(QIcon(icon_path))
    else:
        tools_log.log_info("File not found", parameter=icon_path)


def add_headers(widget, field):

    standar_model = widget.model()
    if standar_model is None:
        standar_model = QStandardItemModel()
    # Related by Qtable
    widget.setModel(standar_model)
    widget.horizontalHeader().setStretchLastSection(True)

    # # Get headers
    headers = []
    for x in field['value'][0]:
        headers.append(x)
    # Set headers
    standar_model.setHorizontalHeaderLabels(headers)

    return widget


def set_calendar_by_user_param(dialog, widget, table_name, value, parameter):
    """ Executes query and set QDateEdit """

    sql = (f"SELECT {value} FROM {table_name}"
           f" WHERE parameter = '{parameter}' AND cur_user = current_user")
    row = global_vars.controller.get_row(sql)
    if row:
        if row[0]:
            row[0] = row[0].replace('/', '-')
        date = QDate.fromString(row[0], 'yyyy-MM-dd')
    else:
        date = QDate.currentDate()
    tools_qt.set_calendar(dialog, widget, date)


def load_table(dialog, table_object, geom_type, expr_filter):
    """ Reload @widget with contents of @tablename applying selected @expr_filter """

    if type(table_object) is str:
        widget_name = f"tbl_{table_object}_x_{geom_type}"
        widget = tools_qt.get_widget(dialog, widget_name)
        if not widget:
            message = "Widget not found"
            tools_log.log_info(message, parameter=widget_name)
            return None
    elif type(table_object) is QTableView:
        widget = table_object
    else:
        msg = "Table_object is not a table name or QTableView"
        tools_log.log_info(msg)
        return None

    expr = set_table_model(dialog, widget, geom_type, expr_filter)
    return expr


def reload_qtable(dialog, geom_type):
    """ Reload QtableView """

    value = tools_qt.get_text(dialog, dialog.psector_id)
    expr = f"psector_id = '{value}'"
    qtable = tools_qt.get_widget(dialog, f'tbl_psector_x_{geom_type}')
    tools_qt.fill_table_by_expr(qtable, f"plan_psector_x_{geom_type}", expr)
    set_tablemodel_config(dialog, qtable, f"plan_psector_x_{geom_type}")
    tools_qgis.refresh_map_canvas()


def set_completer_object(dialog, table_object, field_object_id="id"):
    """ Set autocomplete of widget @table_object + "_id"
        getting id's from selected @table_object
    """

    widget = tools_qt.get_widget(dialog, table_object + "_id")
    if not widget:
        return

    # Set SQL
    if table_object == "element":
        field_object_id = table_object + "_id"
    sql = (f"SELECT DISTINCT({field_object_id})"
           f" FROM {table_object}"
           f" ORDER BY {field_object_id}")

    rows = global_vars.controller.get_rows(sql)
    if rows is None:
        return

    for i in range(0, len(rows)):
        aux = rows[i]
        rows[i] = str(aux[0])

    # Set completer and model: add autocomplete in the widget
    completer = QCompleter()
    completer.setCaseSensitivity(Qt.CaseInsensitive)
    widget.setCompleter(completer)
    model = QStringListModel()
    model.setStringList(rows)
    completer.setModel(model)


def set_completer_widget(tablename, widget, field_id):
    """ Set autocomplete of widget @table_object + "_id"
        getting id's from selected @table_object
    """

    if not widget:
        return

    # Set SQL
    sql = (f"SELECT DISTINCT({field_id})"
           f" FROM {tablename}"
           f" ORDER BY {field_id}")
    row = global_vars.controller.get_rows(sql)
    for i in range(0, len(row)):
        aux = row[i]
        row[i] = str(aux[0])

    # Set completer and model: add autocomplete in the widget
    completer = QCompleter()
    completer.setCaseSensitivity(Qt.CaseInsensitive)
    widget.setCompleter(completer)
    model = QStringListModel()
    model.setStringList(row)
    completer.setModel(model)


def set_dates_from_to(widget_from, widget_to, table_name, field_from, field_to):

    sql = (f"SELECT MIN(LEAST({field_from}, {field_to})),"
           f" MAX(GREATEST({field_from}, {field_to}))"
           f" FROM {table_name}")
    row = global_vars.controller.get_row(sql, log_sql=False)
    current_date = QDate.currentDate()
    if row:
        if row[0]:
            widget_from.setDate(row[0])
        else:
            widget_from.setDate(current_date)
        if row[1]:
            widget_to.setDate(row[1])
        else:
            widget_to.setDate(current_date)


def set_columns_config(widget, table_name, sort_order=0, isQStandardItemModel=False):
    """ Configuration of tables. Set visibility and width of columns """

    # Set width and alias of visible columns
    columns_to_delete = []
    sql = (f"SELECT columnindex, width, alias, status FROM config_form_tableview"
           f" WHERE tablename = '{table_name}' ORDER BY columnindex")
    rows = global_vars.controller.get_rows(sql, log_info=True)
    if not rows:
        return widget

    for row in rows:
        if not row['status']:
            columns_to_delete.append(row['columnindex'] - 1)
        else:
            width = row['width']
            if width is None:
                width = 100
            widget.setColumnWidth(row['columnindex'] - 1, width)
            if row['alias'] is not None:
                widget.model().setHeaderData(row['columnindex'] - 1, Qt.Horizontal, row['alias'])

    # Set order
    if isQStandardItemModel:
        widget.model().sort(sort_order, Qt.AscendingOrder)
    else:
        widget.model().setSort(sort_order, Qt.AscendingOrder)
        widget.model().select()
    # Delete columns
    for column in columns_to_delete:
        widget.hideColumn(column)

    return widget


def manage_close(dialog, table_object, cur_active_layer=None, excluded_layers=[], single_tool_mode=None, layers=None):
    """ Close dialog and disconnect snapping """

    if cur_active_layer:
        global_vars.iface.setActiveLayer(cur_active_layer)
    # some tools can work differently if standalone or integrated in
    # another tool
    if single_tool_mode is not None:
        layers = remove_selection(single_tool_mode, layers=layers)
    else:
        layers = remove_selection(True, layers=layers)

    tools_qt.reset_model(dialog, table_object, "arc")
    tools_qt.reset_model(dialog, table_object, "node")
    tools_qt.reset_model(dialog, table_object, "connec")
    tools_qt.reset_model(dialog, table_object, "element")
    if global_vars.project_type == 'ud':
        tools_qt.reset_model(dialog, table_object, "gully")
    tools_qt.tools_gw.close_dialog(dialog)
    tools_qt.tools_gw.hide_parent_layers(excluded_layers=excluded_layers)
    tools_qgis.disconnect_snapping()
    tools_qgis.disconnect_signal_selection_changed()

    return layers


def delete_feature_at_plan(dialog, geom_type, list_id):
    """ Delete features_id to table plan_@geom_type_x_psector"""

    value = tools_qt.get_text(dialog, dialog.psector_id)
    sql = (f"DELETE FROM plan_psector_x_{geom_type} "
           f"WHERE {geom_type}_id IN ({list_id}) AND psector_id = '{value}'")
    global_vars.controller.execute_sql(sql)


def delete_records(dialog, table_object, query=False, geom_type=None, layers=None, ids=None, list_ids=None,
                   lazy_widget=None, lazy_init_function=None):
    """ Delete selected elements of the table """

    tools_qgis.disconnect_signal_selection_changed()
    geom_type = get_signal_change_tab(dialog, table_object)
    if type(table_object) is str:
        widget_name = f"tbl_{table_object}_x_{geom_type}"
        widget = tools_qt.get_widget(dialog, widget_name)
        if not widget:
            message = "Widget not found"
            show_warning(message, parameter=widget_name)
            return
    elif type(table_object) is QTableView:
        widget = table_object
    else:
        msg = "Table_object is not a table name or QTableView"
        tools_log.log_info(msg)
        return

    # Control when QTableView is void or has no model
    try:
        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
    except AttributeError:
        selected_list = []

    if len(selected_list) == 0:
        message = "Any record selected"
        tools_qt.show_info_box(message)
        return

    if query:
        full_list = widget.model()
        for x in range(0, full_list.rowCount()):
            ids.append(widget.model().record(x).value(f"{geom_type}_id"))
    else:
        ids = list_ids[geom_type]

    field_id = geom_type + "_id"

    del_id = []
    inf_text = ""
    list_id = ""
    for i in range(0, len(selected_list)):
        row = selected_list[i].row()
        id_feature = widget.model().record(row).value(field_id)
        inf_text += f"{id_feature}, "
        list_id += f"'{id_feature}', "
        del_id.append(id_feature)
    inf_text = inf_text[:-2]
    list_id = list_id[:-2]
    message = "Are you sure you want to delete these records?"
    title = "Delete records"
    answer = tools_qt.ask_question(message, title, inf_text)
    if answer:
        for el in del_id:
            ids.remove(el)
    else:
        return

    expr_filter = None
    expr = None
    if len(ids) > 0:

        # Set expression filter with features in the list
        expr_filter = f'"{field_id}" IN ('
        for i in range(len(ids)):
            expr_filter += f"'{ids[i]}', "
        expr_filter = expr_filter[:-2] + ")"

        # Check expression
        (is_valid, expr) = tools_qt.check_expression_filter(expr_filter)  # @UnusedVariable
        if not is_valid:
            return

    # Update model of the widget with selected expr_filter
    if query:
        delete_feature_at_plan(dialog, geom_type, list_id)
        reload_qtable(dialog, geom_type)
    else:
        load_table(dialog, table_object, geom_type, expr_filter)
        tools_qt.set_lazy_init(table_object, lazy_widget=lazy_widget, lazy_init_function=lazy_init_function)

    # Select features with previous filter
    # Build a list of feature id's and select them
    tools_qgis.select_features_by_ids(geom_type, expr, layers=layers)

    if query:
        layers = remove_selection(layers=layers)

    # Update list
    list_ids[geom_type] = ids
    enable_feature_type(dialog, table_object, ids=ids)
    connect_signal_selection_changed(dialog, table_object, geom_type)

    return ids, layers, list_ids


def exist_object(dialog, table_object, single_tool_mode=None, layers=None, ids=None, list_ids=None):
    """ Check if selected object (document or element) already exists """

    # Reset list of selected records
    reset_feature_list(ids, list_ids)

    field_object_id = "id"
    if table_object == "element":
        field_object_id = table_object + "_id"
    object_id = tools_qt.get_text(dialog, table_object + "_id")

    # Check if we already have data with selected object_id
    sql = (f"SELECT * "
           f" FROM {table_object}"
           f" WHERE {field_object_id} = '{object_id}'")
    row = global_vars.controller.get_row(sql, log_info=False)

    # If object_id not found: Clear data
    if not row:
        reset_widgets(dialog, table_object)
        if table_object == 'element':
            set_combo_from_param_user(dialog, 'state', 'value_state', 'edit_state_vdefault', field_name='name')
            set_combo_from_param_user(dialog, 'expl_id', 'exploitation', 'edit_exploitation_vdefault',
                      field_id='expl_id', field_name='name')
            set_calendar_by_user_param(dialog, 'builtdate', 'config_param_user', 'value', 'edit_builtdate_vdefault')
            set_combo_from_param_user(dialog, 'workcat_id', 'cat_work',
                      'edit_workcat_vdefault', field_id='id', field_name='id')

        if single_tool_mode is not None:
            layers = remove_selection(single_tool_mode, layers=layers)
        else:
            layers = remove_selection(True, layers=layers)
        tools_qt.reset_model(dialog, table_object, "arc")
        tools_qt.reset_model(dialog, table_object, "node")
        tools_qt.reset_model(dialog, table_object, "connec")
        tools_qt.reset_model(dialog, table_object, "element")
        if global_vars.project_type == 'ud':
            tools_qt.reset_model(dialog, table_object, "gully")

        return layers, ids, list_ids

    # Fill input widgets with data of the @row
    fill_widgets(dialog, table_object, row)

    # Check related 'arcs'
    ids, layers, list_ids = get_rows_by_feature_type(dialog, table_object, "arc", ids=ids, list_ids=list_ids, layers=layers)

    # Check related 'nodes'
    ids, layers, list_ids = get_rows_by_feature_type(dialog, table_object, "node", ids=ids, list_ids=list_ids, layers=layers)

    # Check related 'connecs'
    ids, layers, list_ids = get_rows_by_feature_type(dialog, table_object, "connec", ids=ids, list_ids=list_ids, layers=layers)

    # Check related 'elements'
    ids, layers, list_ids = get_rows_by_feature_type(dialog, table_object, "element", ids=ids, list_ids=list_ids, layers=layers)

    # Check related 'gullys'
    if global_vars.project_type == 'ud':
        ids, layers, list_ids = get_rows_by_feature_type(dialog, table_object, "gully", ids=ids, list_ids=list_ids, layers=layers)

    return layers, ids, list_ids


def reset_widgets(dialog, table_object):
    """ Clear contents of input widgets """

    if table_object == "doc":
        tools_qt.set_widget_text(dialog, "doc_type", "")
        tools_qt.set_widget_text(dialog, "observ", "")
        tools_qt.set_widget_text(dialog, "path", "")
    elif table_object == "element":
        tools_qt.set_widget_text(dialog, "elementcat_id", "")
        tools_qt.set_widget_text(dialog, "state", "")
        tools_qt.set_widget_text(dialog, "expl_id", "")
        tools_qt.set_widget_text(dialog, "ownercat_id", "")
        tools_qt.set_widget_text(dialog, "location_type", "")
        tools_qt.set_widget_text(dialog, "buildercat_id", "")
        tools_qt.set_widget_text(dialog, "workcat_id", "")
        tools_qt.set_widget_text(dialog, "workcat_id_end", "")
        tools_qt.set_widget_text(dialog, "comment", "")
        tools_qt.set_widget_text(dialog, "observ", "")
        tools_qt.set_widget_text(dialog, "path", "")
        tools_qt.set_widget_text(dialog, "rotation", "")
        tools_qt.set_widget_text(dialog, "verified", "")
        tools_qt.set_widget_text(dialog, dialog.num_elements, "")


def fill_widgets(dialog, table_object, row):
    """ Fill input widgets with data int he @row """

    if table_object == "doc":

        tools_qt.set_widget_text(dialog, "doc_type", row["doc_type"])
        tools_qt.set_widget_text(dialog, "observ", row["observ"])
        tools_qt.set_widget_text(dialog, "path", row["path"])

    elif table_object == "element":

        state = ""
        if row['state']:
            sql = (f"SELECT name FROM value_state"
                   f" WHERE id = '{row['state']}'")
            row_aux = global_vars.controller.get_row(sql)
            if row_aux:
                state = row_aux[0]

        expl_id = ""
        if row['expl_id']:
            sql = (f"SELECT name FROM exploitation"
                   f" WHERE expl_id = '{row['expl_id']}'")
            row_aux = global_vars.controller.get_row(sql)
            if row_aux:
                expl_id = row_aux[0]

        tools_qt.set_widget_text(dialog, "code", row['code'])
        sql = (f"SELECT elementtype_id FROM cat_element"
               f" WHERE id = '{row['elementcat_id']}'")
        row_type = global_vars.controller.get_row(sql)
        if row_type:
            tools_qt.set_widget_text(dialog, "element_type", row_type[0])

        tools_qt.set_widget_text(dialog, "elementcat_id", row['elementcat_id'])
        tools_qt.set_widget_text(dialog, "num_elements", row['num_elements'])
        tools_qt.set_widget_text(dialog, "state", state)
        tools_qt.set_combo_value(dialog.state_type, f"{row['state_type']}", 0)
        tools_qt.set_widget_text(dialog, "expl_id", expl_id)
        tools_qt.set_widget_text(dialog, "ownercat_id", row['ownercat_id'])
        tools_qt.set_widget_text(dialog, "location_type", row['location_type'])
        tools_qt.set_widget_text(dialog, "buildercat_id", row['buildercat_id'])
        tools_qt.set_widget_text(dialog, "builtdate", row['builtdate'])
        tools_qt.set_widget_text(dialog, "workcat_id", row['workcat_id'])
        tools_qt.set_widget_text(dialog, "workcat_id_end", row['workcat_id_end'])
        tools_qt.set_widget_text(dialog, "comment", row['comment'])
        tools_qt.set_widget_text(dialog, "observ", row['observ'])
        tools_qt.set_widget_text(dialog, "link", row['link'])
        tools_qt.set_widget_text(dialog, "verified", row['verified'])
        tools_qt.set_widget_text(dialog, "rotation", row['rotation'])
        if str(row['undelete']) == 'True':
            dialog.undelete.setChecked(True)


def set_combo_from_param_user(dialog, widget, table_name, parameter, field_id='id', field_name='id'):
    """ Executes query and set combo box """

    sql = (f"SELECT t1.{field_name} FROM {table_name} as t1"
           f" INNER JOIN config_param_user as t2 ON t1.{field_id}::text = t2.value::text"
           f" WHERE parameter = '{parameter}' AND cur_user = current_user")
    row = global_vars.controller.get_row(sql)
    if row:
        tools_qt.set_widget_text(dialog, widget, row[0])


def show_warning_detail(text, detail_text, context_name=None):
    """ Show warning message with a button to show more details """

    inf_text = "Press 'Show Me' button to get more details..."
    widget = global_vars.iface.messageBar().createMessage(tr(text, context_name), tr(inf_text))
    button = QPushButton(widget)
    button.setText(tr("Show Me"))
    button.clicked.connect(partial(tools_qt.show_details, detail_text, tr('Warning details')))
    widget.layout().addWidget(button)
    global_vars.iface.messageBar().pushWidget(widget, 1)

    if global_vars.logger:
        global_vars.logger.warning(text + "\n" + detail_text)


