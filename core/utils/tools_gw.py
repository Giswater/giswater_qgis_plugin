"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import configparser
import os
import random
import re
import sys
if 'nt' in sys.builtin_module_names:
    import ctypes
from functools import partial
from collections import OrderedDict

from qgis.PyQt.QtCore import Qt, QTimer, QStringListModel, QVariant, QPoint, QDate
from qgis.PyQt.QtGui import QCursor, QPixmap, QColor, QFontMetrics
from qgis.PyQt.QtWidgets import QSpacerItem, QSizePolicy, QLineEdit, QLabel, QComboBox, QGridLayout, QTabWidget,\
    QCompleter, QFileDialog, QPushButton, QTableView, QFrame, QCheckBox, QDoubleSpinBox, QSpinBox, QDateEdit,\
    QTextEdit, QToolButton
from qgis.core import QgsProject, QgsExpression, QgsPointXY, QgsGeometry, QgsVectorLayer, QgsField, QgsFeature, \
    QgsSymbol, QgsSimpleFillSymbolLayer, QgsRendererCategory, QgsCategorizedSymbolRenderer,  QgsPointLocator, \
    QgsSnappingConfig, QgsSnappingUtils, QgsTolerance, QgsFeatureRequest
from qgis.gui import QgsVertexMarker, QgsMapCanvas, QgsMapToolEmitPoint, QgsDateTimeEdit

from ..models.sys_feature_cat import SysFeatureCat
from ..ui.ui_manager import GwDialog, GwMainWindow
from ... import global_vars
from ...lib import tools_qgis, tools_pgdao, tools_qt
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

        self.layer_arc = self.controller.get_layer_by_tablename('v_edit_arc')
        self.layer_connec = self.controller.get_layer_by_tablename('v_edit_connec')
        self.layer_gully = self.controller.get_layer_by_tablename('v_edit_gully')
        self.layer_node = self.controller.get_layer_by_tablename('v_edit_node')


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


    def set_snapping_mode(self, mode=3):
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
        layer_settings = self.snap_to_layer(self.layer_arc, QgsPointLocator.All, True)
        if layer_settings:
            layer_settings.setType(2)
            layer_settings.setTolerance(15)
            layer_settings.setEnabled(True)
        else:
            layer_settings = QgsSnappingConfig.IndividualLayerSettings(True, 2, 15, 1)
        self.snapping_config.setIndividualLayerSettings(self.layer_arc, layer_settings)
        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snappingConfigChanged.emit(self.snapping_config)


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
        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snappingConfigChanged.emit(self.snapping_config)


    def snap_to_connec(self):
        """ Set snapping to 'connec' and 'gully' """

        QgsProject.instance().blockSignals(True)
        snapping_config = self.get_snapping_options()
        layer_settings = self.snap_to_layer(tools_qgis.get_layer('v_edit_connec'), QgsPointLocator.Vertex, True)
        if layer_settings:
            layer_settings.setType(1)
            layer_settings.setTolerance(15)
            layer_settings.setEnabled(True)
        else:
            layer_settings = QgsSnappingConfig.IndividualLayerSettings(True, 1, 15, 1)
        snapping_config.setIndividualLayerSettings(tools_qgis.get_layer('v_edit_connec'), layer_settings)
        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snappingConfigChanged.emit(snapping_config)


    def snap_to_gully(self):

        QgsProject.instance().blockSignals(True)
        snapping_config = self.get_snapping_options()
        layer_settings = self.snap_to_layer(tools_qgis.get_layer('v_edit_gully'), QgsPointLocator.Vertex, True)
        if layer_settings:
            layer_settings.setType(1)
            layer_settings.setTolerance(15)
            layer_settings.setEnabled(True)
        else:
            layer_settings = QgsSnappingConfig.IndividualLayerSettings(True, 1, 15, 1)
        snapping_config.setIndividualLayerSettings(tools_qgis.get_layer('v_edit_gully'), layer_settings)
        QgsProject.instance().blockSignals(False)
        QgsProject.instance().snappingConfigChanged.emit(snapping_config)


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
        if snappings_options:
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
            active_layer = global_vars.controller.get_layer_by_tablename('version')
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
        global_vars.controller.show_info(message)
        emit_point.canvasClicked.disconnect()
        global_vars.canvas.xyCoordinates.disconnect()
        global_vars.iface.mapCanvas().refreshAllLayers()
        vertex_marker.hide()


def load_settings(dialog):
    """ Load user UI settings related with dialog position and size """
    # Get user UI config file
    try:
        x = get_parser_value('dialogs_position', f"{dialog.objectName()}_x")
        y = get_parser_value('dialogs_position', f"{dialog.objectName()}_y")
        width = get_parser_value('dialogs_position', f"{dialog.objectName()}_width")
        height = get_parser_value('dialogs_position', f"{dialog.objectName()}_height")

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


def save_settings(dialog):
    """ Save user UI related with dialog position and size """
    try:
        set_parser_value('dialogs_position', f"{dialog.objectName()}_width", f"{dialog.property('width')}")
        set_parser_value('dialogs_position', f"{dialog.objectName()}_height", f"{dialog.property('height')}")
        set_parser_value('dialogs_position', f"{dialog.objectName()}_x", f"{dialog.pos().x() + 8}")
        set_parser_value('dialogs_position', f"{dialog.objectName()}_y", f"{dialog.pos().y() + 31}")
    except Exception as e:
        pass


def get_parser_value(section: str, parameter: str) -> str:
    """ Load a simple parser value """
    value = None
    try:
        parser = configparser.ConfigParser(comment_prefixes=';', allow_no_value=True)
        main_folder = os.path.join(os.path.expanduser("~"), global_vars.plugin_name)
        path = main_folder + os.sep + "config" + os.sep + 'user.config'
        if not os.path.exists(path):
            return value
        parser.read(path)
        value = parser[section][parameter]
    except:
        return value
    return value


def set_parser_value(section: str, parameter: str, value: str):
    """  Save simple parser value """
    try:
        parser = configparser.ConfigParser(comment_prefixes=';', allow_no_value=True)
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
    :param tab_widget:  QTabWidget
    :param selector_name: Name of the selector (String)
    """
    try:
        index = tab_widget.currentIndex()
        tab = tab_widget.widget(index)
        if tab:
            tab_name = tab.objectName()
            dlg_name = dialog.objectName()
            set_parser_value('last_tabs', f"{dlg_name}_{selector_name}", f"{tab_name}")

    except Exception as e:
        pass


def open_dialog(dlg, dlg_name=None, info=True, maximize_button=True, stay_on_top=True, title=None):
    """ Open dialog """

    # Check database connection before opening dialog
    if not global_vars.controller.check_db_connection():
        return

    # Set window title
    if title is not None:
        dlg.setWindowTitle(title)
    else:
        if dlg_name:
            global_vars.controller.manage_translation(dlg_name, dlg)

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


# Currently in parent_maptool
# def set_action_pan(controller):
# 	""" Set action 'Pan' """
# 	try:
# 		controller.iface.actionPan().trigger()
# 	except Exception:
# 		pass


def refresh_legend(controller):
    """ This function solves the bug generated by changing the type of feature.
    Mysteriously this bug is solved by checking and unchecking the categorization of the tables.
    # TODO solve this bug
    """
    layers = [controller.get_layer_by_tablename('v_edit_node'),
              controller.get_layer_by_tablename('v_edit_connec'),
              controller.get_layer_by_tablename('v_edit_gully')]

    for layer in layers:
        if layer:
            ltl = QgsProject.instance().layerTreeRoot().findLayer(layer.id())
            ltm = controller.iface.layerTreeView().model()
            legendNodes = ltm.layerLegendNodes(ltl)
            for ln in legendNodes:
                current_state = ln.data(Qt.CheckStateRole)
                ln.setData(Qt.Unchecked, Qt.CheckStateRole)
                ln.setData(Qt.Checked, Qt.CheckStateRole)
                ln.setData(current_state, Qt.CheckStateRole)


def get_cursor_multiple_selection():
    """ Set cursor for multiple selection """

    path_folder = os.path.join(os.path.dirname(__file__), os.pardir)
    path_cursor = os.path.join(path_folder, f"icons{os.sep}shared", '201.png')

    if os.path.exists(path_cursor):
        cursor = QCursor(QPixmap(path_cursor))
    else:
        cursor = QCursor(Qt.ArrowCursor)

    return cursor


def hide_generic_layers(excluded_layers=[]):
    """ Hide generic layers """
    layers_changed = {}
    layer = global_vars.controller.get_layer_by_tablename("v_edit_arc")
    if layer and "v_edit_arc" not in excluded_layers:
        layers_changed[layer] = global_vars.controller.is_layer_visible(layer)
        global_vars.controller.set_layer_visible(layer)
    layer = global_vars.controller.get_layer_by_tablename("v_edit_node")
    if layer and "v_edit_node" not in excluded_layers:
        layers_changed[layer] = global_vars.controller.is_layer_visible(layer)
        global_vars.controller.set_layer_visible(layer)
    layer = global_vars.controller.get_layer_by_tablename("v_edit_connec")
    if layer and "v_edit_connec" not in excluded_layers:
        layers_changed[layer] = global_vars.controller.is_layer_visible(layer)
        global_vars.controller.set_layer_visible(layer)
    layer = global_vars.controller.get_layer_by_tablename("v_edit_element")
    if layer and "v_edit_element" not in excluded_layers:
        layers_changed[layer] = global_vars.controller.is_layer_visible(layer)
        global_vars.controller.set_layer_visible(layer)

    if global_vars.project_type == 'ud':
        layer = global_vars.controller.get_layer_by_tablename("v_edit_gully")
        if layer and "v_edit_gully" not in excluded_layers:
            layers_changed[layer] = global_vars.controller.is_layer_visible(layer)
            global_vars.controller.set_layer_visible(layer)

    return layers_changed


def get_plugin_version():
    """ Get plugin version from metadata.txt file """

    # Check if metadata file exists
    metadata_file = os.path.join(global_vars.plugin_dir, 'metadata.txt')
    if not os.path.exists(metadata_file):
        message = "Metadata file not found"
        global_vars.controller.show_warning(message, parameter=metadata_file)
        return None

    metadata = configparser.ConfigParser()
    metadata.read(metadata_file)
    plugin_version = metadata.get('general', 'version')
    if plugin_version is None:
        message = "Plugin version not found"
        global_vars.controller.show_warning(message)

    return plugin_version


def draw(complet_result, rubber_band, margin=None, reset_rb=True, color=QColor(255, 0, 0, 100), width=3):

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
        points = tools_qgis.get_points(list_coord)
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

    feature_type = tools_qt.getWidget(dialog, 'feature_type')
    widget_table = tools_qt.getWidget(dialog, widget_name)
    if feature_type is not None and widget_table is not None:
        if len(ids) > 0:
            feature_type.setEnabled(False)
        else:
            feature_type.setEnabled(True)


def reset_lists(ids, list_ids):
    """ Reset list of selected records """

    ids = []
    list_ids = {'arc': [], 'node': [], 'connec': [], 'gully': [], 'element': []}

    return ids, list_ids


def reset_layers(layers):
    """ Reset list of layers """

    layers = {'arc': [], 'node': [], 'connec': [], 'gully': [], 'element': []}

    return layers


def tab_feature_changed(dialog, excluded_layers=[]):
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
    hide_generic_layers(excluded_layers=excluded_layers)
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


def open_file_path(filter_="All (*.*)"):
    """ Open QFileDialog """
    msg = global_vars.controller.tr("Select DXF file")
    path, filter_ = QFileDialog.getOpenFileName(None, msg, "", filter_)

    return path, filter_


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

    uri = tools_pgdao.get_uri()
    schema_name = global_vars.controller.credentials['schema'].replace('"', '')
    if child_layers is not None:
        for layer in child_layers:
            if layer[0] != 'Load all':
                uri.setDataSource(schema_name, f"{layer[0]}", the_geom, None, layer[1] + "_id")
                vlayer = QgsVectorLayer(uri.uri(), f'{layer[0]}', "postgres")
                group = layer[4] if layer[4] is not None else group
                group = group if group is not None else 'GW Layers'
                tools_qt.add_layer_to_toc(vlayer, group)
                style_id = layer[3]
                if style_id is not None:
                    body = f'$${{"data":{{"style_id":"{style_id}"}}}}$$'
                    style = global_vars.controller.get_json('gw_fct_getstyle', body)
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
            style = global_vars.controller.get_json('gw_fct_getstyle', body)
            if style['status'] == 'Failed': return
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
            text_result, change_tab = populate_info_text(dialog, data, force_tab, reset_text, tab_idx, disable_tabs)
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
                    remove_layer_from_toc(layer_name)
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


def populate_info_text(dialog, data, force_tab=True, reset_text=True, tab_idx=1, call_disable_tabs=True):
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
    text = tools_qt.getWidgetText(dialog, dialog.txt_infolog, return_string_null=False)

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

    tools_qt.setWidgetText(dialog, 'txt_infolog', text + "\n")
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
    functions  called in -> getattr(f"get_{feature['geometry']['type'].lower()}")(feature)
        def get_point(feature)
        get_linestring(feature)
        get_multilinestring(feature)
        get_polygon(feature)
        get_multipolygon(feature)
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
    This function is called in def get_geometry(feature)
          geometry = getattr(f"get_{feature['geometry']['type'].lower()}")(feature)
    """
    return f"({feature['geometry']['coordinates'][0]} {feature['geometry']['coordinates'][1]})"


def get_linestring(feature):
    """ Manage feature geometry when is LineString
    :param feature: feature to get geometry type and coordinates (GeoJson)
    :return: Coordinates of the feature (String)
    This function is called in def get_geometry(feature)
          geometry = getattr(f"get_{feature['geometry']['type'].lower()}")(feature)
    """
    return get_coordinates(feature)


def get_multilinestring(feature):
    """ Manage feature geometry when is MultiLineString
    :param feature: feature to get geometry type and coordinates (GeoJson)
    :return: Coordinates of the feature (String)
    This function is called in def get_geometry(feature)
          geometry = getattr(f"get_{feature['geometry']['type'].lower()}")(feature)
    """
    return get_multi_coordinates(feature)


def get_polygon(feature):
    """ Manage feature geometry when is Polygon
    :param feature: feature to get geometry type and coordinates (GeoJson)
    :return: Coordinates of the feature (String)
    This function is called in def get_geometry(feature)
          geometry = getattr(f"get_{feature['geometry']['type'].lower()}")(feature)
    """
    return get_multi_coordinates(feature)


def get_multipolygon(feature):
    """ Manage feature geometry when is MultiPolygon
    :param feature: feature to get geometry type and coordinates (GeoJson)
    :return: Coordinates of the feature (String)
    This function is called in def get_geometry(feature)
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


def remove_layer_from_toc(layer_name):
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
        remove_layer_from_toc(layer_name)


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
        tools_qt.setWidgetText(dialog, btn_accept, 'Close')


def set_style_mapzones():

    extras = f'"mapzones":""'
    body = create_body(extras=extras)
    json_return = global_vars.controller.get_json('gw_fct_getstylemapzones', body)
    if not json_return or json_return['status'] == 'Failed':
        return False

    for mapzone in json_return['body']['data']['mapzones']:

        # Loop for each mapzone returned on json
        lyr = global_vars.controller.get_layer_by_tablename(mapzone['layer'])
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
        global_vars.controller.show_warning(msg + "is not defined in table cat_feature")

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
            widget = QComboBox()
            fill_combo(widget, field)
            widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
        elif field['widgettype'] in ('check', 'checkbox'):
            widget = add_checkbox(field)
            widget.stateChanged.connect(partial(get_values, dialog, widget, my_json))
        elif field['widgettype'] == 'button':
            widget = add_button(dialog, field)

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

            put_widgets(dialog, field, lbl, widget)


def put_widgets(dialog, field, lbl, widget):
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
        value = tools_qt.getWidgetText(dialog, widget, return_string_null=False)
    elif type(widget) is QComboBox:
        value = tools_qt.get_item_data(dialog, widget, 0)
    elif type(widget) is QCheckBox:
        value = tools_qt.isChecked(dialog, widget)
    elif type(widget) is QDateEdit:
        value = tools_qt.getCalendarDate(dialog, widget)

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
    global_vars.controller.log_info(str(list))


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
            exist = global_vars.controller.check_python_function(module, function_name)
            if not exist:
                msg = f"widget {real_name} have associated function {function_name}, but {function_name} not exist"
                global_vars.controller.show_message(msg, 2)
                return widget
        else:
            message = "Parameter button_function is null for button"
            global_vars.controller.show_message(message, 2, parameter=widget.objectName())

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
        value = tools_qt.getWidgetText(dialog, widget, return_string_null=False)
    elif type(widget) is QComboBox and widget.isEnabled():
        value = tools_qt.get_item_data(dialog, widget, 0)
    elif type(widget) is QCheckBox and widget.isEnabled():
        value = tools_qt.isChecked(dialog, widget)
    elif type(widget) is QgsDateTimeEdit and widget.isEnabled():
        value = tools_qt.getCalendarDate(dialog, widget)

    if str(value) == '' or value is None:
        _json[str(widget.property('columnname'))] = None
    else:
        _json[str(widget.property('columnname'))] = str(value)


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
            exist = global_vars.controller.check_python_function(tools_qt, func_name)
            if not exist:
                msg = f"widget {real_name} have associated function {func_name}, but {func_name} not exist"
                global_vars.controller.show_message(msg, 2)
                return widget
        else:
            message = "Parameter widgetfunction is null for widget"
            global_vars.controller.show_message(message, 2, parameter=real_name)
    else:
        message = "Parameter not found"
        global_vars.controller.show_message(message, 2, parameter='widgetfunction')
    # Call function (self, widget) or def no_function_associated(self, widget=None, message_level=1)
    widget.clicked.connect(partial(getattr(tools_qt, func_name), widget))

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
        tools_qt.setCalendarDate(dialog, widget, date)
    else:
        widget.clear()
    btn_calendar = widget.findChild(QToolButton)

    btn_calendar.clicked.connect(partial(tools_qt.set_calendar_empty, widget))

    return widget


def set_typeahead(field, dialog, widget, completer):

    if field['widgettype'] == 'typeahead':
        if 'queryText' not in field or 'queryTextFilter' not in field:
            return widget
        model = QStringListModel()
        widget.textChanged.connect(partial(populate_lineedit, completer, model, field, dialog, widget))

    return widget


def populate_lineedit(completer, model, field, dialog, widget):
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
    extras += f', "parentValue":"{tools_qt.getWidgetText(dialog, "data_" + str(field["parentId"]))}"'
    extras += f', "textToSearch":"{tools_qt.getWidgetText(dialog, widget)}"'
    body = create_body(extras=extras)
    complet_list = global_vars.controller.get_json('gw_fct_gettypeahead', body)
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
            exist = global_vars.controller.check_python_function(sys.modules[__name__], function_name)
            if not exist:
                msg = f"widget {real_name} have associated function {function_name}, but {function_name} not exist"
                global_vars.controller.show_message(msg, 2)
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
        tools_qt.set_combo_itemData(widget, field['selectedId'], 0)
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
        if (str(tools_qt.get_item_data(dialog, combo_parent, 0)) in str(combo_child['widgetcontrols']['enableWhenParent'])) \
                and (tools_qt.get_item_data(dialog, combo_parent, 0) not in (None, '')):
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
    combo_id = tools_qt.get_item_data(dialog, widget)

    feature = f'"featureType":"{feature_type}", '
    feature += f'"tableName":"{tablename}", '
    feature += f'"idName":"{field_id}"'
    extras = f'"comboParent":"{combo_parent}", "comboId":"{combo_id}"'
    body = create_body(feature=feature, extras=extras)
    result = global_vars.controller.get_json('gw_fct_getchilds', body)
    if not result or result['status'] == 'Failed':
        return False

    for combo_child in result['body']['data']:
        if combo_child is not None:
            manage_child(dialog, widget, combo_child)


def fill_child(dialog, widget, action, geom_type=''):

    combo_parent = widget.objectName()
    combo_id = tools_qt.get_item_data(dialog, widget)
    # TODO cambiar por gw_fct_getchilds then unified with get_child if posible
    json_result = global_vars.controller.get_json('gw_fct_getcombochilds', f"'{action}' ,'' ,'' ,'{combo_parent}', '{combo_id}','{geom_type}'")
    for combo_child in json_result['fields']:
        if combo_child is not None:
            fill_combo_child(dialog, combo_child)


def cast_boolean(param):
    """ Receives a string and returns a bool """
    bool_dict = {"True": True, "true": True, "False": False, "false": False}
    try:
        return bool_dict[param]
    except KeyError:
        return True