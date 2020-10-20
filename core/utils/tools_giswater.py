"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtWidgets import QTabWidget, QCompleter, QWidget, QFileDialog, QPushButton
from qgis.PyQt.QtCore import Qt, QTimer, QStringListModel, QVariant
from qgis.PyQt.QtGui import QCursor, QPixmap, QColor
from qgis.core import QgsProject, QgsExpression, QgsPointXY, QgsGeometry, QgsVectorLayer, QgsField, QgsFeature, \
    QgsSymbol, QgsSimpleFillSymbolLayer, QgsRendererCategory, QgsCategorizedSymbolRenderer

import configparser
from ... import global_vars
import os
import sys
import re
import random
if 'nt' in sys.builtin_module_names:
    import ctypes

from ...lib.tools_qt import getWidgetText, setWidgetText, getWidget
from ..ui.ui_manager import GwDialog, GwMainWindow
from ...lib import tools_qgis
from ...lib.tools_pgdao import get_uri


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


def populate_info_text(dialog, data, force_tab=True, reset_text=True, tab_idx=1):

    change_tab = False
    text = getWidgetText(dialog, 'txt_infolog', return_string_null=False)
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

    setWidgetText(dialog, 'txt_infolog', text + "\n")
    qtabwidget = dialog.findChild(QTabWidget, 'mainTab')
    if change_tab and qtabwidget is not None:
        qtabwidget.setCurrentIndex(tab_idx)

    return change_tab


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


def check_expression(expr_filter, log_info=False):
    """ Check if expression filter @expr is valid """

    if log_info:
        global_vars.controller.log_info(expr_filter)
    expr = QgsExpression(expr_filter)
    if expr.hasParserError():
        message = "Expression Error"
        global_vars.controller.log_warning(message, parameter=expr_filter)
        return False, expr

    return True, expr


def get_cursor_multiple_selection():
    """ Set cursor for multiple selection """

    path_folder = os.path.join(os.path.dirname(__file__), os.pardir)
    path_cursor = os.path.join(path_folder, 'icons', '201.png')

    print(path_folder)
    print(path_cursor)

    if os.path.exists(path_cursor):
        cursor = QCursor(QPixmap(path_cursor))
    else:
        cursor = QCursor(Qt.ArrowCursor)

    return cursor


def hide_generic_layers(excluded_layers=[]):
    """ Hide generic layers """

    layer = global_vars.controller.get_layer_by_tablename("v_edit_arc")
    if layer and "v_edit_arc" not in excluded_layers:
        global_vars.controller.set_layer_visible(layer)
    layer = global_vars.controller.get_layer_by_tablename("v_edit_node")
    if layer and "v_edit_node" not in excluded_layers:
        global_vars.controller.set_layer_visible(layer)
    layer = global_vars.controller.get_layer_by_tablename("v_edit_connec")
    if layer and "v_edit_connec" not in excluded_layers:
        global_vars.controller.set_layer_visible(layer)
    layer = global_vars.controller.get_layer_by_tablename("v_edit_element")
    if layer and "v_edit_element" not in excluded_layers:
        global_vars.controller.set_layer_visible(layer)

    if global_vars.project_type == 'ud':
        layer = global_vars.controller.get_layer_by_tablename("v_edit_gully")
        if layer and "v_edit_gully" not in excluded_layers:
            global_vars.controller.set_layer_visible(layer)


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


def manage_actions(json_result, sql):
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
                getattr(global_vars.controller.gw_infotools, f"{function_name}")(**params)
            except AttributeError as e:
                # If function_name not exist as python function
                global_vars.controller.log_warning(f"Exception error: {e}")
            except Exception as e:
                global_vars.controller.log_debug(f"{type(e).__name__}: {e}")
    except Exception as e:
        global_vars.controller.manage_exception(None, f"{type(e).__name__}: {e}", sql)


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

    feature_type = getWidget(dialog, 'feature_type')
    widget_table = getWidget(dialog, widget_name)
    if feature_type is not None and widget_table is not None:
        if len(ids) > 0:
            feature_type.setEnabled(False)
        else:
            feature_type.setEnabled(True)


def reset_lists(ids, list_ids):
    """ Reset list of selected records """

    ids = []
    list_ids = {}
    list_ids['arc'] = []
    list_ids['node'] = []
    list_ids['connec'] = []
    list_ids['gully'] = []
    list_ids['element'] = []

    return ids, list_ids


def reset_layers(layers):
    """ Reset list of layers """

    layers = {}
    layers['arc'] = []
    layers['node'] = []
    layers['connec'] = []
    layers['gully'] = []
    layers['element'] = []

    return layers


def tab_feature_changed(dialog, table_object, excluded_layers=[]):
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

    uri = get_uri()
    schema_name = global_vars.controller.credentials['schema'].replace('"', '')
    if child_layers is not None:
        for layer in child_layers:
            if layer[0] != 'Load all':
                uri.setDataSource(schema_name, f"{layer[0]}", the_geom, None, layer[1] + "_id")
                vlayer = QgsVectorLayer(uri.uri(), f'{layer[0]}', "postgres")
                group = layer[4] if layer[4] is not None else group
                group = group if group is not None else 'GW Layers'
                check_for_group(vlayer, group)
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
        check_for_group(vlayer, group)
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
                    tools_qgis.categoryze_layer(v_layer, cat_field, size, color_values)
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


def populate_info_text_(dialog, data, force_tab=True, reset_text=True, tab_idx=1, call_disable_tabs=True):
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
    text = getWidgetText(dialog, dialog.txt_infolog, return_string_null=False)

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

    setWidgetText(dialog, 'txt_infolog', text + "\n")
    qtabwidget = dialog.findChild(QTabWidget, 'mainTab')
    if qtabwidget is not None:
        if change_tab and qtabwidget is not None:
            qtabwidget.setCurrentIndex(tab_idx)
        if call_disable_tabs:
            disable_tabs(dialog)

    return text


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
        setWidgetText(dialog, btn_accept, 'Close')


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


# Doesn't work because of hasattr and getattr
'''
def set_selector(dialog, widget, is_alone, controller):
	"""  Send values to DB and reload selectors
	:param dialog: QDialog
	:param widget: QCheckBox that contains the information to generate the json (QCheckBox)
	:param is_alone: Defines if the selector is unique (True) or multiple (False) (Boolean)
	"""
	
	# Get current tab name
	index = dialog.main_tab.currentIndex()
	tab_name = dialog.main_tab.widget(index).objectName()
	selector_type = dialog.main_tab.widget(index).property("selector_type")
	qgis_project_add_schema = controller.plugin_settings_value('gwAddSchema')
	widget_all = dialog.findChild(QCheckBox, f'chk_all_{tab_name}')
	
	if widget_all is None or (widget_all is not None and widget.objectName() != widget_all.objectName()):
		extras = (f'"selectorType":"{selector_type}", "tabName":"{tab_name}", '
				  f'"id":"{widget.objectName()}", "isAlone":"{is_alone}", "value":"{widget.isChecked()}", '
				  f'"addSchema":"{qgis_project_add_schema}"')
	else:
		check_all = qt_tools.isChecked(dialog, widget_all)
		extras = f'"selectorType":"{selector_type}", "tabName":"{tab_name}", "checkAll":"{check_all}",  ' \
				 f'"addSchema":"{qgis_project_add_schema}"'
	
	body = create_body(extras=extras)
	json_result = controller.get_json('gw_fct_setselectors', body)
	
	if str(tab_name) == 'tab_exploitation':
	    # Zoom to exploitation
        x1 = json_result['body']['data']['geometry']['x1']
        y1 = json_result['body']['data']['geometry']['y1']
        x2 = json_result['body']['data']['geometry']['x2']
        y2 = json_result['body']['data']['geometry']['y2']
        if x1 is not None:
            self.tools_qgis.zoom_to_rectangle(x1, y1, x2, y2, margin=0)
                
        # getting mapzones style
		self.set_style_mapzones()
	
	# Refresh canvas
	controller.set_layer_index('v_edit_arc')
	controller.set_layer_index('v_edit_node')
	controller.set_layer_index('v_edit_connec')
	controller.set_layer_index('v_edit_gully')
	controller.set_layer_index('v_edit_link')
	controller.set_layer_index('v_edit_plan_psector')
	
	get_selector(dialog, f'"{selector_type}"', controller, is_setselector=json_result)
	
	widget_filter = qt_tools.getWidget(dialog, f"txt_filter_{tab_name}")
	if widget_filter and qt_tools.getWidgetText(dialog, widget_filter, False, False) not in (None, ''):
		widget_filter.textChanged.emit(widget_filter.text())


def manage_all(dialog, widget_all, controller):
	
	key_modifier = QApplication.keyboardModifiers()
	status = qt_tools.isChecked(dialog, widget_all)
	index = dialog.main_tab.currentIndex()
	widget_list = dialog.main_tab.widget(index).findChildren(QCheckBox)
	if key_modifier == Qt.ShiftModifier:
		return
	
	for widget in widget_list:
		if widget_all is not None:
			if widget == widget_all or widget.objectName() == widget_all.objectName():
				continue
		widget.blockSignals(True)
		qt_tools.setChecked(dialog, widget, status)
		widget.blockSignals(False)
	
	set_selector(dialog, widget_all, False, controller)


def get_selector(dialog, selector_type, controller, filter=False, widget=None, text_filter=None, current_tab=None,
				 is_setselector=None):
	""" Ask to DB for selectors and make dialog
	:param dialog: Is a standard dialog, from file api_selectors.ui, where put widgets
	:param selector_type: list of selectors to ask DB ['exploitation', 'state', ...]
	"""
	main_tab = dialog.findChild(QTabWidget, 'main_tab')
	
	# Set filter
	if filter is not False:
		main_tab = dialog.findChild(QTabWidget, 'main_tab')
		text_filter = qt_tools.getWidgetText(dialog, widget)
		if text_filter in ('null', None):
			text_filter = ''
		
		# Set current_tab
		index = dialog.main_tab.currentIndex()
		current_tab = dialog.main_tab.widget(index).objectName()
	
	# Profilactic control of nones
	if text_filter is None:
		text_filter = ''
	if is_setselector is None:
		# Built querytext
		form = f'"currentTab":"{current_tab}"'
		extras = f'"selectorType":{selector_type}, "filterText":"{text_filter}"'
		body = create_body(form=form, extras=extras)
		json_result = controller.get_json('gw_fct_getselectors', body)
	else:
		json_result = is_setselector
		for x in range(dialog.main_tab.count() - 1, -1, -1):
			dialog.main_tab.widget(x).deleteLater()
	
	if not json_result:
		return False
	
	for form_tab in json_result['body']['form']['formTabs']:
		
		if filter and form_tab['tabName'] != str(current_tab):
			continue
		
		selection_mode = form_tab['selectionMode']
		
		# Create one tab for each form_tab and add to QTabWidget
		tab_widget = QWidget(main_tab)
		tab_widget.setObjectName(form_tab['tabName'])
		tab_widget.setProperty('selector_type', form_tab['selectorType'])
		if filter:
			main_tab.removeTab(index)
			main_tab.insertTab(index, tab_widget, form_tab['tabLabel'])
		else:
			main_tab.addTab(tab_widget, form_tab['tabLabel'])
		
		# Create a new QGridLayout and put it into tab
		gridlayout = QGridLayout()
		gridlayout.setObjectName("grl_" + form_tab['tabName'])
		tab_widget.setLayout(gridlayout)
		field = {}
		i = 0
		
		if 'typeaheadFilter' in form_tab:
			label = QLabel()
			label.setObjectName('lbl_filter')
			label.setText('Filter:')
			if qt_tools.getWidget(dialog, 'txt_filter_' + str(form_tab['tabName'])) is None:
				widget = QLineEdit()
				widget.setObjectName('txt_filter_' + str(form_tab['tabName']))
				widget.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
				widget.textChanged.connect(partial(get_selector, dialog, selector_type, filter=True,
												   widget=widget, current_tab=current_tab))
				widget.textChanged.connect(partial(self.manage_filter, dialog, widget, 'save'))
				widget.setLayoutDirection(Qt.RightToLeft)
				setattr(self, f"var_txt_filter_{form_tab['tabName']}", '')
			else:
				widget = qt_tools.getWidget(dialog, 'txt_filter_' + str(form_tab['tabName']))
			
			field['layoutname'] = gridlayout.objectName()
			field['layoutorder'] = i
			i = i + 1
			self.put_widgets(dialog, field, label, widget)
			widget.setFocus()
		
		if 'manageAll' in form_tab:
			if (form_tab['manageAll']).lower() == 'true':
				if qt_tools.getWidget(dialog, f"lbl_manage_all_{form_tab['tabName']}") is None:
					label = QLabel()
					label.setObjectName(f"lbl_manage_all_{form_tab['tabName']}")
					label.setText('Check all')
				else:
					label = qt_tools.getWidget(dialog, f"lbl_manage_all_{form_tab['tabName']}")
				
				if qt_tools.getWidget(dialog, f"chk_all_{form_tab['tabName']}") is None:
					widget = QCheckBox()
					widget.setObjectName('chk_all_' + str(form_tab['tabName']))
					widget.stateChanged.connect(partial(self.manage_all, dialog, widget))
					widget.setLayoutDirection(Qt.RightToLeft)
				
				else:
					widget = qt_tools.getWidget(dialog, f"chk_all_{form_tab['tabName']}")
				field['layoutname'] = gridlayout.objectName()
				field['layoutorder'] = i
				i = i + 1
				chk_all = widget
				self.put_widgets(dialog, field, label, widget)
		
		for order, field in enumerate(form_tab['fields']):
			label = QLabel()
			label.setObjectName('lbl_' + field['label'])
			label.setText(field['label'])
			
			widget = self.add_checkbox(field)
			widget.stateChanged.connect(partial(self.set_selection_mode, dialog, widget, selection_mode))
			widget.setLayoutDirection(Qt.RightToLeft)
			
			field['layoutname'] = gridlayout.objectName()
			field['layoutorder'] = order + i
			self.put_widgets(dialog, field, label, widget)
		
		vertical_spacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
		gridlayout.addItem(vertical_spacer1)
	
	# Set last tab used by user as current tab
	tabname = json_result['body']['form']['currentTab']
	tab = main_tab.findChild(QWidget, tabname)
	
	if tab:
		main_tab.setCurrentWidget(tab)
	
	if is_setselector is not None and hasattr(self, 'widget_filter'):
		widget = dialog.main_tab.findChild(QLineEdit, f'txt_filter_{tabname}')
		if widget:
			widget.blockSignals(True)
			index = dialog.main_tab.currentIndex()
			tab_name = dialog.main_tab.widget(index).objectName()
			value = getattr(self, f"var_txt_filter_{tab_name}")
			qt_tools.setWidgetText(dialog, widget, f'{value}')
			widget.blockSignals(False)


def manage_filter(dialog, widget, action):
	index = dialog.main_tab.currentIndex()
	tab_name = dialog.main_tab.widget(index).objectName()
	if action == 'save':
		setattr(self, f"var_txt_filter_{tab_name}", qt_tools.getWidgetText(dialog, widget))
	else:
		setattr(self, f"var_txt_filter_{tab_name}", '')

'''''
