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
import sqlite3
import webbrowser

if 'nt' in sys.builtin_module_names:
    import ctypes
from collections import OrderedDict
from functools import partial

from qgis.PyQt.QtCore import Qt, QStringListModel, QVariant, QDate, QSettings, QLocale
from qgis.PyQt.QtGui import QCursor, QPixmap, QColor, QFontMetrics, QStandardItemModel, QIcon, QStandardItem, \
    QIntValidator, QDoubleValidator
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtWidgets import QSpacerItem, QSizePolicy, QLineEdit, QLabel, QComboBox, QGridLayout, QTabWidget, \
    QCompleter, QPushButton, QTableView, QFrame, QCheckBox, QDoubleSpinBox, QSpinBox, QDateEdit, QTextEdit, \
    QToolButton, QWidget, QApplication, QDockWidget, QMenu
from qgis.core import Qgis, QgsProject, QgsPointXY, QgsVectorLayer, QgsField, QgsFeature, QgsSymbol, \
    QgsFeatureRequest, QgsSimpleFillSymbolLayer, QgsRendererCategory, QgsCategorizedSymbolRenderer,  QgsPointLocator, \
    QgsSnappingConfig, QgsCoordinateTransform, QgsCoordinateReferenceSystem, QgsApplication, QgsVectorFileWriter, \
    QgsCoordinateTransformContext, QgsFieldConstraints, QgsEditorWidgetSetup, QgsRasterLayer, QgsDataSourceUri, QgsProviderRegistry
from qgis.gui import QgsDateTimeEdit, QgsRubberBand

from ..models.cat_feature import GwCatFeature
from ..ui.dialog import GwDialog
from ..ui.main_window import GwMainWindow
from ..ui.docker import GwDocker
from ..ui.ui_manager import GwSelectorUi
from . import tools_backend_calls
from ..load_project_menu import GwMenuLoad
from ..utils.select_manager import GwSelectManager
from ..utils.snap_manager import GwSnapManager
from ... import global_vars
from ...lib import tools_qgis, tools_qt, tools_log, tools_os, tools_db
from ...lib.tools_qt import GwHyperLinkLabel, GwHyperLinkLineEdit


def load_settings(dialog, plugin='core'):
    """ Load user UI settings related with dialog position and size """

    # Get user UI config file
    try:
        x = get_config_parser('dialogs_position', f"{dialog.objectName()}_x", "user", "session", plugin=plugin)
        y = get_config_parser('dialogs_position', f"{dialog.objectName()}_y", "user", "session", plugin=plugin)
        width = get_config_parser('dialogs_dimension', f"{dialog.objectName()}_width", "user", "session", plugin=plugin)
        height = get_config_parser('dialogs_dimension', f"{dialog.objectName()}_height", "user", "session", plugin=plugin)

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
    except Exception:
        pass


def save_settings(dialog, plugin='core'):
    """ Save user UI related with dialog position and size """

    # Ensure that 'plugin' parameter isn't being populated with int from signal
    try:
        plugin = int(plugin)
        plugin = 'core'
    except ValueError:
        pass

    try:
        x, y = dialog.geometry().x(), dialog.geometry().y()
        w, h = dialog.geometry().width(), dialog.geometry().height()
        set_config_parser('dialogs_dimension', f"{dialog.objectName()}_width", f"{w}", plugin=plugin)
        set_config_parser('dialogs_dimension', f"{dialog.objectName()}_height", f"{h}", plugin=plugin)
        set_config_parser('dialogs_position', f"{dialog.objectName()}_x", f"{x}", plugin=plugin)
        set_config_parser('dialogs_position', f"{dialog.objectName()}_y", f"{y}", plugin=plugin)
    except Exception:
        pass


def initialize_parsers():
    """ Initialize parsers of configuration files: init, session, giswater, user_params """

    for config in global_vars.list_configs:
        filepath, parser = _get_parser_from_filename(config)
        global_vars.configs[config][0] = filepath
        global_vars.configs[config][1] = parser


def get_config_parser(section: str, parameter: str, config_type, file_name, prefix=True, get_comment=False,
                      chk_user_params=True, get_none=False, force_reload=False, plugin='core') -> str:
    """ Load a simple parser value """

    if config_type not in ("user", "project"):
        tools_log.log_warning(f"get_config_parser: Reference config_type = '{config_type}' it is not managed")
        return None

    # Get configuration filepath and parser object
    path = global_vars.configs[file_name][0]
    parser = global_vars.configs[file_name][1]

    if plugin != 'core':
        path = f"{global_vars.user_folder_dir}{os.sep}{plugin}{os.sep}config{os.sep}{file_name}.config"
        parser = None
        chk_user_params = False

    # Needed to avoid errors with giswater plugins
    if path is None:
        tools_log.log_warning(f"get_config_parser: Config file is not set")
        return None

    value = None
    raw_parameter = parameter
    if parser is None:
        if plugin == 'core':
            tools_log.log_info(f"Creating parser for file: {path}")
        parser = configparser.ConfigParser(comment_prefixes=";", allow_no_value=True)
        parser.read(path)

    # If project has already been loaded and filename is 'init' or 'session', always read and parse file
    if force_reload or (global_vars.project_loaded and file_name in ('init', 'session')):
        parser = configparser.ConfigParser(comment_prefixes=";", allow_no_value=True)
        parser.read(path)

    if config_type == 'user' and prefix and global_vars.project_type is not None:
        parameter = f"{global_vars.project_type}_{parameter}"

    if not parser.has_section(section) or not parser.has_option(section, parameter):
        if chk_user_params and config_type in "user":
            value = _check_user_params(section, raw_parameter, file_name, prefix=prefix)
            set_config_parser(section, raw_parameter, value, config_type, file_name, prefix=prefix, chk_user_params=False)
    else:
        value = parser[section][parameter]

    # If there is a value and you don't want to get the comment, it only gets the value part
    if value is not None and not get_comment:
        value = value.split('#')[0].strip()

    if not get_none and str(value) in "None":
        value = None

    # Check if the parameter exists in the inventory, if not creates it
    if chk_user_params and config_type in "user":
        _check_user_params(section, raw_parameter, file_name, prefix)

    return value


def set_config_parser(section: str, parameter: str, value: str = None, config_type="user", file_name="session",
                      comment=None, prefix=True, chk_user_params=True, plugin='core'):
    """ Save simple parser value """

    if config_type not in ("user", "project"):
        tools_log.log_warning(f"set_config_parser: Reference config_type = '{config_type}' it is not managed")
        return None

    # Get configuration filepath and parser object
    path = global_vars.configs[file_name][0]

    if plugin != 'core':
        path = f"{global_vars.user_folder_dir}{os.sep}{plugin}{os.sep}config{os.sep}{file_name}.config"
        chk_user_params = False

    try:

        parser = configparser.ConfigParser(comment_prefixes=";", allow_no_value=True)
        parser.read(path)

        raw_parameter = parameter
        if config_type == 'user' and prefix and global_vars.project_type is not None:
            parameter = f"{global_vars.project_type}_{parameter}"

        # Check if section exists in file
        if section not in parser:
            parser.add_section(section)

        # Cast to str because parser only allow strings
        value = f"{value}"
        if value is not None:
            # Add the comment to the value if there is one
            if comment is not None:
                value += f" #{comment}"
            # If the previous value had an inline comment, don't remove it
            else:
                prev = get_config_parser(section, parameter, config_type, file_name, False, True, False)
                if prev is not None and "#" in prev:
                    value += f" #{prev.split('#')[1]}"
            parser.set(section, parameter, value)
            # Check if the parameter exists in the inventory, if not creates it
            if chk_user_params and config_type in "user":
                _check_user_params(section, raw_parameter, file_name, prefix)
        else:
            parser.set(section, parameter)  # This is just for writing comments

        with open(path, 'w') as configfile:
            parser.write(configfile)
            configfile.close()

    except Exception as e:
        tools_log.log_warning(f"set_config_parser exception [{type(e).__name__}]: {e}")
        return


def save_current_tab(dialog, tab_widget, selector_name):
    """
    Save the name of current tab used by the user into QSettings()
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
            set_config_parser('dialogs_tab', f"{dlg_name}_{selector_name}", f"{tab_name}")
    except Exception:
        pass


def open_dialog(dlg, dlg_name=None, stay_on_top=True, title=None, hide_config_widgets=False):
    """ Open dialog """

    # Check database connection before opening dialog
    if (dlg_name != 'admin_credentials' and dlg_name != 'admin_ui') and not tools_db.check_db_connection():
        return

    # Manage translate
    if dlg_name:
        tools_qt.manage_translation(dlg_name, dlg)

    # Set window title
    if title is not None:
        dlg.setWindowTitle(title)

    # Manage stay on top, maximize/minimize button and information button
    flags = Qt.WindowCloseButtonHint | Qt.WindowMinMaxButtonsHint

    if stay_on_top:
        flags |= Qt.WindowStaysOnTopHint

    dlg.setWindowFlags(flags)

    if hide_config_widgets:
        hide_widgets_form(dlg, dlg_name)

    # Open dialog
    if issubclass(type(dlg), GwDialog):
        dlg.open()
    elif issubclass(type(dlg), GwMainWindow):
        dlg.show()
    else:
        dlg.show()


def close_dialog(dlg, delete_dlg=True, plugin='core'):
    """ Close dialog """

    save_settings(dlg, plugin=plugin)
    global_vars.session_vars['last_focus'] = None
    dlg.close()
    if delete_dlg:
        try:
            dlg.deleteLater()
        except RuntimeError:
            pass


def connect_signal(obj, pfunc, section, signal_name):
    """
    Connects a signal like this -> obj.connect(pfunc) and stores it in global_vars.active_signals
    :param obj: the object to which the signal will be connected
    :param pfunc: the partial object containing the function to connect and the arguments if needed
    :param section: the name of the parent category
    :param signal_name: the name of the signal. Should be {functionname}_{obj}_{pfunc} like -> {replace_arc}_{xyCoordinates}_{mouse_move_arc}
    :return: the signal. If failed to connect it will return None
    """

    if section not in global_vars.active_signals:
        global_vars.active_signals[section] = {}
    # If the signal is already connected, don't reconnect it, just return it.
    if signal_name in global_vars.active_signals[section]:
        _, signal, _ = global_vars.active_signals[section][signal_name]
        return signal
    # Try to connect signal and save it in the dict
    try:
        signal = obj.connect(pfunc)
        global_vars.active_signals[section][signal_name] = (obj, signal, pfunc)
        return signal
    except Exception as e:
        pass
    return None


def disconnect_signal(section, signal_name=None, pop=True):
    """
    Disconnects a signal
        :param section: the name of the parent category
        :param signal_name: the name of the signal
        :param pop: should always be True, if False it won't remove the signal from the dict.
        :return: 2 things -> (object which had the signal connected, partial function that was connected with the signal)
                 (None, None) if it couldn't find the signal
    """

    if section not in global_vars.active_signals:
        return None, None

    if signal_name is None:
        old_signals = []
        for signal in global_vars.active_signals[section]:
            old_signals.append(disconnect_signal(section, signal, False))
        for signal in old_signals:
            global_vars.active_signals[section].pop(signal, None)
    if signal_name not in global_vars.active_signals[section]:
        return None, None

    obj, signal, pfunc = global_vars.active_signals[section][signal_name]
    try:
        obj.disconnect(signal)
    except Exception as e:
        pass
    finally:
        if pop:
            global_vars.active_signals[section].pop(signal_name, None)
            return obj, pfunc
        return signal_name


def reconnect_signal(section, signal_name):
    """
    Disconnects and reconnects a signal
        :param section: the name of the parent category
        :param signal_name: the name of the signal
        :return: True if successfully reconnected, False otherwise (bool)
    """

    obj, pfunc = disconnect_signal(section, signal_name)  # Disconnect the signal
    if obj is not None and pfunc is not None:
        connect_signal(obj, pfunc, section, signal_name)  # Reconnect it
        return True
    return False


def create_body(form='', feature='', filter_fields='', extras=None):
    """ Create and return parameters as body to functions"""

    info_types = {'full': 1}
    info_type = info_types.get(global_vars.project_vars['info_type'])
    lang = QSettings().value('locale/globalLocale', QLocale().name())

    client = f'$${{"client":{{"device":4, "lang":"{lang}"'
    if info_type is not None:
        client += f', "infoType":{info_type}'
    if global_vars.project_epsg is not None:
        client += f', "epsg":{global_vars.project_epsg}'
    client += f'}}, '

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


def refresh_legend():
    """ This function solves the bug generated by changing the type of feature.
    Mysteriously this bug is solved by checking and unchecking the categorization of the tables.
    """

    layers = [tools_qgis.get_layer_by_tablename('v_edit_node'),
              tools_qgis.get_layer_by_tablename('v_edit_connec'),
              tools_qgis.get_layer_by_tablename('v_edit_gully')]

    for layer in layers:
        if layer:
            ltl = QgsProject.instance().layerTreeRoot().findLayer(layer.id())
            ltm = global_vars.iface.layerTreeView().model()
            legend_nodes = ltm.layerLegendNodes(ltl)
            for ln in legend_nodes:
                current_state = ln.data(Qt.CheckStateRole)
                ln.setData(Qt.Unchecked, Qt.CheckStateRole)
                ln.setData(Qt.Checked, Qt.CheckStateRole)
                ln.setData(current_state, Qt.CheckStateRole)


def get_cursor_multiple_selection():
    """ Set cursor for multiple selection """

    path_cursor = os.path.join(global_vars.plugin_dir, f"icons{os.sep}dialogs{os.sep}20x20", '201.png')
    if os.path.exists(path_cursor):
        cursor = QCursor(QPixmap(path_cursor))
    else:
        cursor = QCursor(Qt.ArrowCursor)

    return cursor


def hide_parent_layers(excluded_layers=[]):
    """ Hide generic layers """

    layers_changed = {}
    list_layers = ["v_edit_arc", "v_edit_node", "v_edit_connec", "v_edit_element"]
    if global_vars.project_type == 'ud':
        list_layers.append("v_edit_gully")

    for layer_name in list_layers:
        layer = tools_qgis.get_layer_by_tablename(layer_name)
        if layer and layer_name not in excluded_layers:
            layers_changed[layer] = tools_qgis.is_layer_visible(layer)
            tools_qgis.set_layer_visible(layer)

    return layers_changed


def draw_by_json(complet_result, rubber_band, margin=None, reset_rb=True, color=QColor(255, 0, 0, 100), width=3):

    try:
        if complet_result['body']['feature']['geometry'] is None:
            return
        if complet_result['body']['feature']['geometry']['st_astext'] is None:
            return
    except KeyError:
        return

    list_coord = re.search(r'\((.*)\)', str(complet_result['body']['feature']['geometry']['st_astext']))
    max_x, max_y, min_x, min_y = tools_qgis.get_max_rectangle_from_coords(list_coord)

    if reset_rb:
        reset_rubberband(rubber_band)
    if str(max_x) == str(min_x) and str(max_y) == str(min_y):
        point = QgsPointXY(float(max_x), float(max_y))
        tools_qgis.draw_point(point, rubber_band, color, width)
    else:
        points = tools_qgis.get_geometry_vertex(list_coord)
        tools_qgis.draw_polyline(points, rubber_band, color, width)
    if margin is not None:
        tools_qgis.zoom_to_rectangle(max_x, max_y, min_x, min_y, margin, change_crs=False)


def enable_feature_type(dialog, widget_name='tbl_relation', ids=None):

    feature_type = tools_qt.get_widget(dialog, 'feature_type')
    widget_table = tools_qt.get_widget(dialog, widget_name)
    if feature_type is not None and widget_table is not None:
        if len(ids) > 0:
            feature_type.setEnabled(False)
        else:
            feature_type.setEnabled(True)


def reset_feature_list():
    """ Reset list of selected records """

    ids = []
    list_ids = {'arc': [], 'node': [], 'connec': [], 'gully': [], 'element': []}

    return ids, list_ids


def get_signal_change_tab(dialog, excluded_layers=[]):
    """ Set feature_type and layer depending selected tab """

    tab_idx = dialog.tab_feature.currentIndex()
    tab_name = {'tab_arc': 'arc', 'tab_node': 'node', 'tab_connec': 'connec', 'tab_gully': 'gully',
                'tab_elem': 'element'}

    feature_type = tab_name.get(dialog.tab_feature.widget(tab_idx).objectName(), 'arc')
    hide_parent_layers(excluded_layers=excluded_layers)
    viewname = f"v_edit_{feature_type}"

    # Adding auto-completion to a QLineEdit
    set_completer_feature_id(dialog.feature_id, feature_type, viewname)
    global_vars.iface.actionPan().trigger()
    return feature_type


def set_completer_feature_id(widget, feature_type, viewname):
    """ Set autocomplete of widget 'feature_id'
        getting id's from selected @viewname
    """

    if feature_type == '':
        return

    # Adding auto-completion to a QLineEdit
    completer = QCompleter()
    completer.setCaseSensitivity(Qt.CaseInsensitive)
    widget.setCompleter(completer)
    model = QStringListModel()
    sql = (f"SELECT {feature_type}_id"
           f" FROM {viewname}")
    row = tools_db.get_rows(sql)
    if row:
        for i in range(0, len(row)):
            aux = row[i]
            row[i] = str(aux[0])
        model.setStringList(row)
        completer.setModel(model)


def add_layer_database(tablename=None, the_geom="the_geom", field_id="id", group="GW Layers", sub_group=None, style_id="-1", alias=None, sub_sub_group=None):
    """
    Put selected layer into TOC
        :param tablename: Postgres table name (String)
        :param the_geom: Geometry field of the table (String)
        :param field_id: Field id of the table (String)
        :param child_layers: List of layers (StringList)
        :param group: Name of the group that will be created in the toc (String)
        :param style_id: Id of the style we want to load (integer or String)
    """

    tablename_og = tablename
    schema_name = global_vars.dao_db_credentials['schema'].replace('"', '')
    uri = tools_db.get_uri()
    uri.setDataSource(schema_name, f'{tablename}', the_geom, None, field_id)
    if the_geom:
        try:
            uri.setSrid(f"{global_vars.data_epsg}")
        except:
            pass
    create_groups = get_config_parser("system", "force_create_qgis_group_layer", "user", "init", prefix=False)
    create_groups = tools_os.set_boolean(create_groups, default=False)
    if sub_group:
        sub_group = sub_group.capitalize()
    if sub_sub_group:
        sub_sub_group = sub_sub_group.capitalize()

    if the_geom == "rast":
        connString = f"PG: dbname={global_vars.dao_db_credentials['db']} host={global_vars.dao_db_credentials['host']} " \
                     f"user={global_vars.dao_db_credentials['user']} password={global_vars.dao_db_credentials['password']} " \
                     f"port={global_vars.dao_db_credentials['port']} mode=2 schema={global_vars.dao_db_credentials['schema']} " \
                     f"column={the_geom} table={tablename}"
        if alias: tablename = alias
        layer = QgsRasterLayer(connString, tablename)
        tools_qt.add_layer_to_toc(layer, group, sub_group, create_groups=create_groups)

    else:
        if alias: tablename = alias
        layer = QgsVectorLayer(uri.uri(), f'{tablename}', 'postgres')
        tools_qt.add_layer_to_toc(layer, group, sub_group, create_groups=create_groups, sub_sub_group=sub_sub_group)

        # The triggered function (action.triggered.connect(partial(...)) as the last parameter sends a boolean,
        # if we define style_id = None, style_id will take the boolean of the triggered action as a fault,
        # therefore, we define it with "-1"
        if style_id in (None, "-1"):
            # Get style_id from tablename
            sql = f"SELECT id FROM sys_style WHERE idval = '{tablename_og}'"
            row = tools_db.get_row(sql)
            if row:
                style_id = row[0]

        # Apply style to layer if it has one configured
        if style_id not in (None, "-1"):
            body = f'$${{"data":{{"style_id":"{style_id}"}}}}$$'
            style = execute_procedure('gw_fct_getstyle', body)
            if style is None or style['status'] == 'Failed':
                return
            if 'styles' in style['body']:
                if 'style' in style['body']['styles']:
                    qml = style['body']['styles']['style']
                    tools_qgis.create_qml(layer, qml)

        # Set layer config
        if tablename:
            feature = '"tableName":"' + str(tablename_og) + '", "isLayer":true'
            extras = '"infoType":"' + str(global_vars.project_vars['info_type']) + '"'
            body = create_body(feature=feature, extras=extras)
            json_result = execute_procedure('gw_fct_getinfofromid', body)
            config_layer_attributes(json_result, layer, alias)

    global_vars.iface.mapCanvas().refresh()


def add_layer_temp(dialog, data, layer_name, force_tab=True, reset_text=True, tab_idx=1, del_old_layers=True,
                   group='GW Temporal Layers', call_set_tabs_enabled=True, close=True):
    """
    Add QgsVectorLayer into TOC
        :param dialog: Dialog where to find the tab to be displayed and the textedit to be filled (QDialog or QMainWindow)
        :param data: Json with information
        :param layer_name: Name that will be given to the layer (String)
        :param force_tab: Boolean that tells us if we want to show the tab or not (bool)
        :param reset_text: It allows us to delete the text from the Qtexedit log, or add text below (bool)
        :param tab_idx: Log tab index (int)
        :param del_old_layers: Delete layers added in previous operations (bool)
        :param group: Name of the group to which we want to add the layer (String)
        :param call_set_tabs_enabled: set all tabs, except the last, enabled or disabled (bool).
        :param close: Manage buttons accept, cancel, close...  in function def fill_tab_log(...) (bool).
        :return: Dictionary with text as result of previuos data (String), and list of layers added (QgsVectorLayer).
    """

    text_result = None
    temp_layers_added = []
    srid = global_vars.data_epsg
    i = 0
    for k, v in list(data.items()):
        if str(k) == "info":
            text_result, change_tab = fill_tab_log(dialog, data, force_tab, reset_text, tab_idx, call_set_tabs_enabled, close)
        elif k in ('point', 'line', 'polygon'):
            if 'features' not in data[k]:
                continue
            counter = len(data[k]['features'])
            if counter > 0:
                counter = len(data[k]['features'])
                geometry_type = data[k]['geometryType']
                aux_layer_name = layer_name
                try:
                    if not layer_name:
                        aux_layer_name = data[k]['layerName']
                except KeyError:
                    aux_layer_name = str(k)
                if del_old_layers:
                    tools_qgis.remove_layer_from_toc(aux_layer_name, group)
                v_layer = QgsVectorLayer(f"{geometry_type}?crs=epsg:{srid}", aux_layer_name, 'memory')
                # This function already works with GeoJson
                fill_layer_temp(v_layer, data, k, counter, group=group, sort_val=i)

                # Increase iterator
                i = i + 1

                qml_path = data[k].get('qmlPath')
                category_field = data[k].get('category_field')
                if qml_path:
                    tools_qgis.load_qml(v_layer, qml_path)
                elif category_field:
                    cat_field = data[k]['category_field']
                    size = data[k].get('size', default=2)
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


def config_layer_attributes(json_result, layer, layer_name, thread=None):

    for field in json_result['body']['data']['fields']:
        valuemap_values = {}

        # Get column index
        field_index = layer.fields().indexFromName(field['columnname'])

        # Hide selected fields according table config_form_fields.hidden
        if 'hidden' in field:
            config = layer.attributeTableConfig()
            columns = config.columns()
            for column in columns:
                if column.name == str(field['columnname']):
                    column.hidden = field['hidden']
                    break
            config.setColumns(columns)
            layer.setAttributeTableConfig(config)

        # Set alias column
        if field['label']:
            layer.setFieldAlias(field_index, field['label'])

        # widgetcontrols
        widgetcontrols = field.get('widgetcontrols')
        if widgetcontrols:
            if widgetcontrols.get('setQgisConstraints') is True:
                layer.setFieldConstraint(field_index, QgsFieldConstraints.ConstraintNotNull,
                                         QgsFieldConstraints.ConstraintStrengthSoft)
                layer.setFieldConstraint(field_index, QgsFieldConstraints.ConstraintUnique,
                                         QgsFieldConstraints.ConstraintStrengthHard)

        if field.get('ismandatory') is False:
            layer.setFieldConstraint(field_index, QgsFieldConstraints.ConstraintNotNull,
                                     QgsFieldConstraints.ConstraintStrengthSoft)

        # Manage editability
        # Get layer config
        config = layer.editFormConfig()
        try:
            # Set field editability
            config.setReadOnly(field_index, not field['iseditable'])
        except KeyError:
            pass
        finally:
            # Set layer config
            layer.setEditFormConfig(config)

        # delete old values on ValueMap
        editor_widget_setup = QgsEditorWidgetSetup('ValueMap', {'map': valuemap_values})
        layer.setEditorWidgetSetup(field_index, editor_widget_setup)

        # Manage ValueRelation configuration
        use_vr = 'widgetcontrols' in field and field['widgetcontrols'] \
                 and 'valueRelation' in field['widgetcontrols'] and field['widgetcontrols']['valueRelation']
        if use_vr:
            value_relation = field['widgetcontrols']['valueRelation']
            if value_relation.get('activated'):
                try:
                    vr_layer = value_relation['layer']
                    vr_layer = tools_qgis.get_layer_by_tablename(vr_layer).id()  # Get layer id
                    vr_key_column = value_relation['keyColumn']  # Get 'Key'
                    vr_value_column = value_relation['valueColumn']  # Get 'Value'
                    vr_allow_nullvalue = value_relation['nullValue']  # Get null values
                    vr_filter_expression = value_relation['filterExpression']  # Get 'FilterExpression'
                    if vr_filter_expression is None:
                        vr_filter_expression = ''

                    # Create and apply ValueRelation config
                    editor_widget_setup = QgsEditorWidgetSetup('ValueRelation', {'Layer': f'{vr_layer}',
                                                                                 'Key': f'{vr_key_column}',
                                                                                 'Value': f'{vr_value_column}',
                                                                                 'AllowNull': f'{vr_allow_nullvalue}',
                                                                                 'FilterExpression': f'{vr_filter_expression}'})
                    layer.setEditorWidgetSetup(field_index, editor_widget_setup)

                except Exception as e:
                    if thread:
                        thread.exception = e
                        thread.vr_errors.add(layer_name)
                        if 'layer' in value_relation:
                            thread.vr_missing.add(value_relation['layer'])
                        thread.message = f"ValueRelation for {thread.vr_errors} switched to ValueMap because " \
                                         f"layers {thread.vr_missing} are not present on QGIS project"
                    use_vr = False

        if not use_vr:
            # Manage new values in ValueMap
            if field['widgettype'] == 'combo':
                if 'comboIds' in field:
                    # Set values
                    for i in range(0, len(field['comboIds'])):
                        valuemap_values[field['comboNames'][i]] = field['comboIds'][i]
                # Set values into valueMap
                editor_widget_setup = QgsEditorWidgetSetup('ValueMap', {'map': valuemap_values})
                layer.setEditorWidgetSetup(field_index, editor_widget_setup)
            elif field['widgettype'] == 'check':
                config = {'CheckedState': 'true', 'UncheckedState': 'false'}
                editor_widget_setup = QgsEditorWidgetSetup('CheckBox', config)
                layer.setEditorWidgetSetup(field_index, editor_widget_setup)
            elif field['widgettype'] == 'datetime':
                config = {'allow_null': True,
                          'calendar_popup': True,
                          'display_format': 'yyyy-MM-dd',
                          'field_format': 'yyyy-MM-dd',
                          'field_iso_format': False}
                editor_widget_setup = QgsEditorWidgetSetup('DateTime', config)
                layer.setEditorWidgetSetup(field_index, editor_widget_setup)
            elif field['widgettype'] == 'textarea':
                editor_widget_setup = QgsEditorWidgetSetup('TextEdit', {'IsMultiline': 'True'})
                layer.setEditorWidgetSetup(field_index, editor_widget_setup)
            else:
                editor_widget_setup = QgsEditorWidgetSetup('TextEdit', {'IsMultiline': 'False'})
                layer.setEditorWidgetSetup(field_index, editor_widget_setup)

        # multiline: key comes from widgecontrol but it's used here in order to set false when key is missing
        if field['widgettype'] == 'text':
            if field['widgetcontrols'] and 'setMultiline' in field['widgetcontrols']:
                editor_widget_setup = QgsEditorWidgetSetup('TextEdit',
                                                           {'IsMultiline': field['widgetcontrols']['setMultiline']})
            else:
                editor_widget_setup = QgsEditorWidgetSetup('TextEdit', {'IsMultiline': False})
            layer.setEditorWidgetSetup(field_index, editor_widget_setup)


def load_missing_layers(filter, group="GW Layers", sub_group=None):
    """ Adds any missing Mincut layers to TOC """

    sql = f"SELECT id, alias FROM sys_table WHERE id LIKE '{filter}' AND alias IS NOT NULL"
    rows = tools_db.get_rows(sql)
    if rows:
        for tablename, alias in rows:
            lyr = tools_qgis.get_layer_by_tablename(tablename)
            if not lyr:
                add_layer_database(tablename, alias=alias, group=group, sub_group=sub_group)


def fill_tab_log(dialog, data, force_tab=True, reset_text=True, tab_idx=1, call_set_tabs_enabled=True, close=True):
    """
    Populate txt_infolog QTextEdit widget
        :param dialog: QDialog
        :param data: Json
        :param force_tab: Force show tab (bool)
        :param reset_text: Reset(or not) text for each iteration (bool)
        :param tab_idx: index of tab to force (int)
        :param call_set_tabs_enabled: set all tabs, except the last, enabled or disabled (bool)
        :param close: Manage buttons accept, cancel, close... (bool)
        :return: Text received from data (String)
    """

    change_tab = False
    text = tools_qt.get_text(dialog, dialog.txt_infolog, return_string_null=False)

    if reset_text:
        text = ""
    if 'info' in data and 'values' in data['info']:
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
        qtabwidget.setTabEnabled(qtabwidget.count() - 1, True)
        if change_tab and qtabwidget is not None:
            qtabwidget.setCurrentIndex(tab_idx)
        if call_set_tabs_enabled:
            set_tabs_enabled(dialog)
    if close:
        try:
            dialog.btn_accept.disconnect()
            dialog.btn_accept.hide()
        except AttributeError:
            pass

        try:
            if hasattr(dialog, 'btn_cancel'):
                dialog.btn_cancel.disconnect()
                dialog.btn_cancel.setText("Close")
                dialog.btn_cancel.clicked.connect(lambda: dialog.close())
            if hasattr(dialog, 'btn_close'):
                dialog.btn_close.disconnect()
                dialog.btn_close.setText("Close")
                dialog.btn_close.clicked.connect(lambda: dialog.close())
        except AttributeError:
            # Control if btn_cancel exist
            pass

    return text, change_tab


def disable_tab_log(dialog):
    qtabwidget = dialog.findChild(QTabWidget, 'mainTab')
    if qtabwidget and qtabwidget.widget(qtabwidget.count() - 1).objectName() in ('tab_info', 'tab_infolog', 'tab_loginfo', 'tab_info_log'):
        qtabwidget.setTabEnabled(qtabwidget.count() - 1, False)


def fill_layer_temp(virtual_layer, data, layer_type, counter, group='GW Temporal Layers', sort_val=None):
    """
    :param virtual_layer: Memory QgsVectorLayer (QgsVectorLayer)
    :param data: Json
    :param layer_type: point, line, polygon...(String)
    :param counter: control if json have values (int)
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
        geometry = tools_qgis.get_geometry_from_json(feature)
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
    my_group.insertLayer(sort_val, virtual_layer)


def enable_widgets(dialog, result, enable):

    try:
        widget_list = dialog.findChildren(QWidget)
        for widget in widget_list:
            for field in result['fields']:
                if widget.property('columnname') == field['columnname']:
                    if type(widget) in (QDoubleSpinBox, QLineEdit, QSpinBox, QTextEdit, GwHyperLinkLineEdit):
                        widget.setReadOnly(not enable)
                        widget.setStyleSheet("QWidget { background: rgb(242, 242, 242); color: rgb(0, 0, 0)}")
                        if type(widget) == GwHyperLinkLineEdit:
                            widget.setStyleSheet("QLineEdit { background: rgb(242, 242, 242); color:blue; text-decoration: underline; border: none;}")
                    elif type(widget) in (QComboBox, QCheckBox, QgsDateTimeEdit):
                        widget.setEnabled(enable)
                        widget.setStyleSheet("QWidget {color: rgb(0, 0, 0)}")
                    elif type(widget) is QPushButton:
                        # Manage the clickability of the buttons according to the configuration
                        # in the table config_form_fields simultaneously with the edition,
                        # but giving preference to the configuration when iseditable is True
                        if not field['iseditable']:
                            widget.setEnabled(field['iseditable'])
                    break

    except RuntimeError:
        pass


def enable_all(dialog, result):

    try:
        widget_list = dialog.findChildren(QWidget)
        for widget in widget_list:
            if widget.property('keepDisbled'):
                continue
            for field in result['fields']:
                if widget.property('columnname') == field['columnname']:
                    if type(widget) in (QSpinBox, QDoubleSpinBox, QLineEdit, QTextEdit, GwHyperLinkLineEdit):
                        widget.setReadOnly(not field['iseditable'])
                        if not field['iseditable']:
                            widget.setFocusPolicy(Qt.NoFocus)
                            widget.setStyleSheet("QWidget { background: rgb(242, 242, 242); color: rgb(0, 0, 0)}")
                            if type(widget) == GwHyperLinkLineEdit:
                                widget.setStyleSheet("QLineEdit { background: rgb(242, 242, 242); color:blue; text-decoration: underline; border: none;}")
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

    if field.get('stylesheet') is not None:
        if wtype in field['stylesheet']:
            widget.setStyleSheet("QWidget{" + field['stylesheet'][wtype] + "}")
    return widget


def delete_selected_rows(widget, table_object):
    """ Delete selected objects of the table (by object_id) """

    # Get selected rows
    selected_list = widget.selectionModel().selectedRows()
    if len(selected_list) == 0:
        message = "Any record selected"
        tools_qgis.show_warning(message)
        return

    inf_text = ""
    list_id = ""
    field_object_id = "id"

    if table_object == "v_edit_element":
        field_object_id = "element_id"
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
    answer = tools_qt.show_question(message, title, inf_text)
    if answer:
        sql = (f"DELETE FROM {table_object} "
               f"WHERE {field_object_id} IN ({list_id})")
        tools_db.execute_sql(sql)
        widget.model().select()


def set_tabs_enabled(dialog):
    """ Disable all tabs in the dialog except the log one and change the state of the buttons
    :param dialog: Dialog where tabs are disabled (QDialog)
    :return:
    """

    qtabwidget = dialog.findChild(QTabWidget, 'mainTab')
    for x in range(0, qtabwidget.count() - 1):
        qtabwidget.widget(x).setEnabled(False)
    qtabwidget.setTabEnabled(qtabwidget.count()-1, True)

    btn_accept = dialog.findChild(QPushButton, 'btn_accept')
    if btn_accept:
        btn_accept.hide()

    btn_cancel = dialog.findChild(QPushButton, 'btn_cancel')
    if btn_cancel:
        tools_qt.set_widget_text(dialog, btn_accept, 'Close')


def set_style_mapzones():
    """ Puts the received styles, in the received layers in the json sent by the gw_fct_getstylemapzones function """

    extras = f'"mapzones":""'
    body = create_body(extras=extras)
    json_return = execute_procedure('gw_fct_getstylemapzones', body)
    if not json_return or json_return['status'] == 'Failed':
        return False

    for mapzone in json_return['body']['data']['mapzones']:

        # Loop for each mapzone returned on json
        lyr = tools_qgis.get_layer_by_tablename(mapzone['layer'])
        categories = []
        status = mapzone['status']
        if status == 'Disable':
            continue

        if lyr:
            # Loop for each id returned on json
            for id in mapzone['values']:
                # initialize the default symbol for this geometry type
                symbol = QgsSymbol.defaultSymbol(lyr.geometryType())
                symbol.setOpacity(float(mapzone['transparency']))

                # Setting simp
                R = random.randint(0, 255)
                G = random.randint(0, 255)
                B = random.randint(0, 255)
                if status == 'Stylesheet':
                    try:
                        R = id['stylesheet']['color'][0]
                        G = id['stylesheet']['color'][1]
                        B = id['stylesheet']['color'][2]
                    except (TypeError, KeyError):
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

    body = create_body()
    result = execute_procedure('gw_fct_getcatfeaturevalues', body)
    # If result ara none, probably the conection has broken so try again
    if not result:
        result = execute_procedure('gw_fct_getcatfeaturevalues', body)
        if not result:
            return None

    msg = "Field child_layer of id: "
    for value in result['body']['data']['values']:
        tablename = value['child_layer']
        if not tablename:
            msg += f"{value['id']}, "
            continue
        elem = GwCatFeature(value['id'], value['system_id'], value['feature_type'], value['shortcut_key'],
                            value['parent_layer'], value['child_layer'])

        feature_cat[tablename] = elem

    feature_cat = OrderedDict(sorted(feature_cat.items(), key=lambda t: t[0]))

    if msg != "Field child_layer of id: ":
        tools_qgis.show_warning(f"{msg} is not defined in table cat_feature")

    return feature_cat


def build_dialog_info(dialog, result, my_json=None):

    fields = result['body']['data']
    if 'fields' not in fields:
        return
    grid_layout = dialog.findChild(QGridLayout, 'gridLayout')

    for order, field in enumerate(fields["fields"]):
        if field.get('hidden'):
            continue

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

        if 'ismandatory' in field:
            widget.setProperty('ismandatory', field['ismandatory'])

        if 'layoutorder' in field and field['layoutorder'] is not None:
            order = field['layoutorder']
        grid_layout.addWidget(label, order, 0)
        grid_layout.addWidget(widget, order, 1)

    vertical_spacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
    grid_layout.addItem(vertical_spacer1)

    return result


def build_dialog_options(dialog, row, pos, _json, temp_layers_added=None, module=sys.modules[__name__]):

    field_id = ''
    if 'fields' in row[pos]:
        field_id = 'fields'
    elif row[pos].get('return_type') not in ('', None):
        field_id = 'return_type'

    if field_id == '':
        return

    for field in row[pos][field_id]:

        check_parameters(field)

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
                    widget.setProperty('ismandatory', field['isMandatory'])
                else:
                    widget.setProperty('ismandatory', False)
                if 'value' in field:
                    widget.setText(field['value'])
                    widget.setProperty('value', field['value'])
                widgetcontrols = field.get('widgetcontrols')
                if widgetcontrols and widgetcontrols.get('regexpControl') is not None:
                    pass
                widget.editingFinished.connect(partial(get_dialog_changed_values, dialog, None, widget, field, _json))
                widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
                datatype = field.get('datatype')
                if datatype == 'int':
                    widget.setValidator(QIntValidator())
                elif datatype == 'float':
                    widget.setValidator(QDoubleValidator())
            elif field['widgettype'] == 'combo':
                widget = add_combo(field)
                widget.currentIndexChanged.connect(partial(get_dialog_changed_values, dialog, None, widget, field, _json))
                signal = field.get('signal')
                if signal:
                    widget.currentIndexChanged.connect(partial(getattr(module, signal), dialog))
                    getattr(module, signal)(dialog)
                widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
            elif field['widgettype'] == 'check':
                widget = QCheckBox()
                if field['value'] is not None and field['value'].lower() == "true":
                    widget.setChecked(True)
                else:
                    widget.setChecked(False)
                widget.stateChanged.connect(partial(get_dialog_changed_values, dialog, None, widget, field, _json))
                widget.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
            elif field['widgettype'] == 'datetime':
                widget = QgsDateTimeEdit()
                widget.setAllowNull(True)
                widget.setCalendarPopup(True)
                widget.setDisplayFormat('yyyy/MM/dd')
                if global_vars.date_format in ("dd/MM/yyyy", "dd-MM-yyyy", "yyyy/MM/dd", "yyyy-MM-dd"):
                    widget.setDisplayFormat(global_vars.date_format)
                date = QDate.currentDate()
                if field.get('value') not in ('', None, 'null'):
                    date = QDate.fromString(field['value'].replace('/', '-'), 'yyyy-MM-dd')
                widget.setDate(date)
                widget.valueChanged.connect(partial(get_dialog_changed_values, dialog, None, widget, field, _json))
                widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
            elif field['widgettype'] == 'spinbox':
                widget = QDoubleSpinBox()
                widgetcontrols = field.get('widgetcontrols')
                if widgetcontrols:
                    spinboxDecimals = widgetcontrols.get('spinboxDecimals')
                    if spinboxDecimals is not None:
                        widget.setDecimals(spinboxDecimals)
                    maximumNumber = widgetcontrols.get('maximumNumber')
                    if maximumNumber is not None:
                        widget.setMaximum(maximumNumber)
                if field.get('value') not in (None, ""):
                    value = float(str(field['value']))
                    widget.setValue(value)
                widget.valueChanged.connect(partial(get_dialog_changed_values, dialog, None, widget, field, _json))
                widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
            elif field['widgettype'] == 'button':
                widget = add_button(dialog, field, temp_layers_added, module)
                widget = set_widget_size(widget, field)

            if widget is None:
                continue

            # Set editable/readonly
            iseditable = field.get('iseditable')
            if type(widget) in (QLineEdit, QDoubleSpinBox):
                if iseditable in (False, "False"):
                    widget.setReadOnly(True)
                    widget.setStyleSheet("QWidget {background: rgb(242, 242, 242);color: rgb(100, 100, 100)}")
                if type(widget) == QLineEdit:
                    if 'placeholder' in field:
                        widget.setPlaceholderText(field['placeholder'])
            elif type(widget) in (QComboBox, QCheckBox):
                if iseditable in (False, "False"):
                    widget.setEnabled(False)
            widget.setObjectName(field['widgetname'])
            if iseditable is not None:
                widget.setEnabled(bool(iseditable))

            add_widget(dialog, field, lbl, widget)


def check_parameters(field):
    """ Check that all the parameters necessary to mount the form are correct """

    msg = ""
    if 'widgettype' not in field:
        msg += "widgettype not found. "

    if 'widgetname' not in field:
        msg += "widgetname not found. "

    if field.get('widgettype') not in ('text', 'linetext', 'combo', 'check', 'datetime', 'spinbox', 'button'):
        msg += "widgettype is wrongly configured. Needs to be in " \
               "('text', 'linetext', 'combo', 'check', 'datetime', 'spinbox', 'button')"

    if 'layoutorder' not in field:
        msg += "layoutorder not found. "

    if msg != "":
        tools_qgis.show_warning(msg)


def add_widget(dialog, field, lbl, widget):
    """ Insert widget into layout """

    layout = dialog.findChild(QGridLayout, field['layoutname'])
    if layout in (None, 'null', 'NULL', 'Null'):
        return
    layout.addWidget(lbl, int(field['layoutorder']), 0)
    layout.addWidget(widget, int(field['layoutorder']), 2)
    layout.setColumnStretch(2, 1)


def get_dialog_changed_values(dialog, chk, widget, field, list, value=None):

    elem = {}
    if type(widget) is QLineEdit:
        value = tools_qt.get_text(dialog, widget, return_string_null=False)
    elif type(widget) is QComboBox:
        value = tools_qt.get_combo_value(dialog, widget, 0)
    elif type(widget) is QCheckBox:
        value = tools_qt.is_checked(dialog, widget)
    elif type(widget) is QDateEdit:
        value = tools_qt.get_calendar_date(dialog, widget)

    # When the QDoubleSpinbox contains decimals, for example 2,0001 when collecting the value, the spinbox itself sends
    # 2.0000999999, as in reality we only want, maximum 4 decimal places, we round up, thus fixing this small failure
    # of the widget
    if type(widget) in (QSpinBox, QDoubleSpinBox):
        value = round(value, 4)

    elem['widget'] = str(widget.objectName())
    elem['value'] = value
    if chk is not None:
        if chk.isChecked():
            elem['chk'] = str(chk.objectName())
            elem['isChecked'] = str(tools_qt.is_checked(dialog, chk))

    if 'sys_role_id' in field:
        elem['sys_role_id'] = str(field['sys_role_id'])

    # Search for the widget and remove it if it's in the list
    idx_del = None
    for i in range(len(list)):
        if list[i]['widget'] == elem['widget']:
            idx_del = i
            break
    if idx_del is not None:
        list.pop(idx_del)

    list.append(elem)


def add_button(dialog, field, temp_layers_added=None, module=sys.modules[__name__]):
    """
    :param dialog: (QDialog)
    :param field: Part of json where find info (Json)
    :param temp_layers_added: List of layers added to the toc
    :param module: Module where find 'function_name', if 'function_name' is not in this module
    :return: (QWidget)

    functions called in -> widget.clicked.connect(partial(getattr(module, function_name), **kwargs)) atm:
        None
    """

    widget = QPushButton()
    widget.setObjectName(field['widgetname'])

    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    if 'value' in field:
        widget.setText(field['value'])
        widget.setProperty('value', field['value'])
    widget.resize(widget.sizeHint().width(), widget.sizeHint().height())
    function_name = None
    real_name = widget.objectName()
    if 'data_' in widget.objectName():
        real_name = widget.objectName()[5:len(widget.objectName())]
    if 'widgetfunction' in field:
        function_name = field['widgetfunction'].get('functionName')
        if function_name is not None:
            if function_name:
                exist = tools_os.check_python_function(module, function_name)
                if not exist:
                    msg = f"widget {real_name} have associated function {function_name}, but {function_name} not exist"
                    tools_qgis.show_message(msg, 2)
                    return widget
            else:
                message = "Parameter button_function is null for button"
                tools_qgis.show_message(message, 2, parameter=widget.objectName())

    kwargs = {'dialog': dialog, 'widget': widget, 'message_level': 1, 'function_name': function_name,
              'temp_layers_added': temp_layers_added}

    if function_name:
        widget.clicked.connect(partial(getattr(module, function_name), **kwargs))

    return widget


def add_spinbox(field):

    widget = None
    if field['widgettype'] == 'spinbox':
        widget = QSpinBox()
    elif field['widgettype'] == 'doubleSpinbox':
        widget = QDoubleSpinBox()
        if field.get('widgetcontrols') and 'spinboxDecimals' in field['widgetcontrols']:
            widget.setDecimals(field['widgetcontrols']['spinboxDecimals'])

    if 'min' in field['widgetcontrols']['maxMinValues']:
        widget.setMinimum(field['widgetcontrols']['maxMinValues']['min'])
    if 'max' in field['widgetcontrols']['maxMinValues']:
        widget.setMaximum(field['widgetcontrols']['maxMinValues']['max'])

    widget.setObjectName(field['widgetname'])
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    if 'value' in field:
        if field['widgettype'] == 'spinbox' and field['value'] != "":
            widget.setValue(int(field['value']))
        elif field['widgettype'] == 'doubleSpinbox' and field['value'] != "":
            widget.setValue(float(field['value']))
    if 'iseditable' in field:
        widget.setReadOnly(not field['iseditable'])
        if not field['iseditable']:
            widget.setStyleSheet("QDoubleSpinBox { background: rgb(0, 250, 0); color: rgb(100, 100, 100)}")

    return widget


def get_values(dialog, widget, _json=None, ignore_editability=False):

    value = None

    if type(widget) in (QDoubleSpinBox, QLineEdit, QSpinBox, QTextEdit, GwHyperLinkLineEdit):
        if widget.isReadOnly() and not ignore_editability:
            return _json
        value = tools_qt.get_text(dialog, widget, return_string_null=False)
    elif type(widget) is QComboBox:
        if not widget.isEnabled() and not ignore_editability:
            return _json
        value = tools_qt.get_combo_value(dialog, widget, 0)
    elif type(widget) is QCheckBox:
        if not widget.isEnabled() and not ignore_editability:
            return _json
        value = tools_qt.is_checked(dialog, widget)
    elif type(widget) is QgsDateTimeEdit:
        if not widget.isEnabled() and not ignore_editability:
            return _json
        value = tools_qt.get_calendar_date(dialog, widget)

    key = str(widget.property('columnname')) if widget.property('columnname') else widget.objectName()
    if key == '' or key is None:
        return _json

    if str(value) == '' or value is None:
        _json[key] = None
    else:
        _json[key] = str(value)
    return _json


def add_checkbox(field):

    widget = QCheckBox()
    widget.setObjectName(field['widgetname'])
    widget.setProperty('columnname', field['columnname'])
    if field.get('value') in ("t", "true", True):
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
        widget.setProperty('value', field['value'])

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
    """
    functions called in -> widget.clicked.connect(partial(getattr(tools_backend_calls, func_name), widget))
        module = tools_backend_calls -> def open_url(self, widget)

    """

    is_editable = field.get('iseditable')
    if is_editable:
        widget = GwHyperLinkLineEdit()
    else:
        widget = GwHyperLinkLabel()
    widget.setObjectName(field['widgetname'])
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    if 'value' in field:
        widget.setText(field['value'])
        widget.setProperty('value', field['value'])
    widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
    widget.resize(widget.sizeHint().width(), widget.sizeHint().height())
    func_name = None
    real_name = widget.objectName()
    if 'data_' in widget.objectName():
        real_name = widget.objectName()[5:len(widget.objectName())]
    if 'widgetfunction' in field:
        func_name = field['widgetfunction'].get('functionName')
        if func_name is not None:
            if func_name:
                exist = tools_os.check_python_function(tools_backend_calls, func_name)
                if not exist:
                    msg = f"widget {real_name} have associated function {func_name}, but {func_name} not exist"
                    tools_qgis.show_message(msg, 2)
                    return widget
            else:
                message = "Parameter widgetfunction is null for widget hyperlink"
                tools_qgis.show_message(message, 2, parameter=real_name)
        else:
            tools_log.log_info(field['widgetfunction'])
    else:
        message = "Parameter widgetfunction not found for widget type hyperlink"
        tools_qgis.show_message(message, 2)

    if func_name is not None:
        # Call function-->func_name(widget) or def no_function_associated(self, widget=None, message_level=1)
        widget.clicked.connect(partial(getattr(tools_backend_calls, func_name), widget))

    return widget


def add_calendar(dialog, field):

    widget = QgsDateTimeEdit()
    widget.setObjectName(field['widgetname'])
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    widget.setAllowNull(True)
    widget.setCalendarPopup(True)
    widget.setDisplayFormat('dd/MM/yyyy')
    if field.get('value') not in ('', None, 'null'):
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
    extras += f', "parentValue":"{tools_qt.get_text(dialog, "data_" + str(parent_id))}"'
    extras += f', "textToSearch":"{tools_qt.get_text(dialog, widget)}"'
    body = create_body(extras=extras)
    complet_list = execute_procedure('gw_fct_gettypeahead', body)
    if not complet_list or complet_list['status'] == 'Failed':
        return False

    list_items = []
    for field in complet_list['body']['data']:
        list_items.append(field['idval'])
    tools_qt.set_completer_object(completer, model, widget, list_items)


def set_data_type(field, widget):

    widget.setProperty('datatype', field['datatype'])
    return widget


def set_widget_size(widget, field):

    if field.get('widgetcontrols') and field['widgetcontrols'].get('widgetdim'):
        widget.setMaximumWidth(field['widgetcontrols']['widgetdim'])
        widget.setMinimumWidth(field['widgetcontrols']['widgetdim'])

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
        widget.setProperty('value', field['value'])
    if 'iseditable' in field:
        widget.setReadOnly(not field['iseditable'])
        if not field['iseditable']:
            widget.setStyleSheet("QLineEdit { background: rgb(242, 242, 242); color: rgb(100, 100, 100)}")

    return widget


def add_tableview(complet_result, field, module=sys.modules[__name__]):
    """ Add widgets QTableView type.
    Function called in -> widget.doubleClicked.connect(partial(getattr(sys.modules[__name__], function_name), widget, complet_result))
        module = class GwInfo(QObject) -> gw_api_open_rpt_result(widget, complet_result)
    """

    widget = QTableView()
    widget.setObjectName(field['widgetname'])
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    function_name = 'no_function_asociated'
    real_name = widget.objectName()
    if 'data_' in widget.objectName():
        real_name = widget.objectName()[5:len(widget.objectName())]
    if 'widgetfunction' in field:
        if field['widgetfunction'].get('functionName') is not None:
            function_name = f"_{field['widgetfunction']['functionName']}"
            exist = tools_os.check_python_function(sys.modules[__name__], function_name)
            if not exist:
                msg = f"widget {real_name} have associated function {function_name}, but {function_name} not exist"
                tools_qgis.show_message(msg, 2)
                return widget

    # noinspection PyUnresolvedReferences
    widget.doubleClicked.connect(partial(getattr(module, function_name), widget, complet_result))

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
    comboIds = field.get('comboIds')
    comboNames = field.get('comboNames')
    if 'comboIds' in field and 'comboNames' in field:
        if tools_os.set_boolean(field.get('isNullValue'), True):
            combolist.append(['', ''])
        for i in range(0, len(field['comboIds'])):
            elem = [comboIds[i], comboNames[i]]
            combolist.append(elem)
    else:
        msg = f"key 'comboIds' or/and comboNames not found WHERE widgetname='{field['widgetname']}' " \
              f"AND widgettype='{field['widgettype']}'"
        tools_qgis.show_message(msg, 2)
    # Populate combo
    for record in combolist:
        widget.addItem(record[1], record)

    return widget


def fill_combo_child(dialog, combo_child):

    if 'widgetname' in combo_child:
        child = dialog.findChild(QComboBox, str(combo_child['widgetname']))
        if child is not None:
            fill_combo(child, combo_child)


def manage_combo_child(dialog, combo_parent, combo_child):

    if 'widgetname' in combo_child:
        child = dialog.findChild(QComboBox, str(combo_child['widgetname']))

        if child:
            child.setEnabled(True)

            fill_combo_child(dialog, combo_child)
            if 'widgetcontrols' not in combo_child or not combo_child['widgetcontrols'] or \
                    'enableWhenParent' not in combo_child['widgetcontrols']:
                return

            combo_value = tools_qt.get_combo_value(dialog, combo_parent, 0)
            if (str(combo_value) in str(combo_child['widgetcontrols']['enableWhenParent'])) \
                    and (combo_value not in (None, '')):
                # The keepDisbled property is used to keep the edition enabled or disabled,
                # when we activate the layer and call the "enable_all" function
                child.setProperty('keepDisbled', False)
                child.setEnabled(True)
            else:
                child.setProperty('keepDisbled', True)
                child.setEnabled(False)


def fill_child(dialog, widget, action, feature_type=''):

    combo_parent = widget.objectName()
    combo_id = tools_qt.get_combo_value(dialog, widget)
    # TODO cambiar por gw_fct_getchilds then unified with get_child if posible
    json_result = execute_procedure('gw_fct_getcombochilds', f"'{action}' ,'' ,'' ,'{combo_parent}', '{combo_id}','{feature_type}'")
    if json_result is None:
        return

    for combo_child in json_result['fields']:
        if combo_child is not None:
            fill_combo_child(dialog, combo_child)


def get_expression_filter(feature_type, list_ids=None, layers=None):
    """ Set an expression filter with the contents of the list.
        Set a model with selected filter. Attach that model to selected table
    """

    list_ids = list_ids[feature_type]
    field_id = feature_type + "_id"
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
    tools_qgis.select_features_by_ids(feature_type, expr, layers=layers)

    return expr_filter


def get_actions_from_json(json_result, sql):
    """
    Manage options for layers (active, visible, zoom and indexing)
    :param json_result: Json result of a query (Json)
    :param sql: query executed (String)
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
                getattr(tools_backend_calls, f"{function_name}")(**params)
            except AttributeError as e:
                # If function_name not exist as python function
                tools_log.log_warning(f"Exception error: {e}")
            except Exception as e:
                tools_log.log_debug(f"{type(e).__name__}: {e}")
    except Exception as e:
        tools_qt.manage_exception(None, f"{type(e).__name__}: {e}", sql, global_vars.schema_name)


def exec_pg_function(function_name, parameters=None, commit=True, schema_name=None, log_sql=False, rubber_band=None,
        aux_conn=None, is_thread=False, check_function=True):
    """ Manage execution of database function @function_name
        If execution failed, execute it again up to the value indicated in parameter 'exec_procedure_max_retries'
    """

    # Define dictionary with results
    dict_result= {}
    status = False
    function_failed = False
    json_result = None
    complet_result = None

    attempt = 0
    while json_result is None and attempt < global_vars.exec_procedure_max_retries:
        attempt += 1
        if attempt == 1:
            tools_log.log_info(f"Starting process...")
        else:
            tools_log.log_info(f"Retrieving process ({attempt}/{global_vars.exec_procedure_max_retries})...")
        json_result = execute_procedure(function_name, parameters, schema_name, commit, log_sql, rubber_band, aux_conn,
            is_thread, check_function)
        complet_result = json_result
        if json_result is None or not json_result:
            function_failed = True
        elif 'status' in json_result:
            if json_result['status'] == 'Failed':
                tools_log.log_warning(json_result)
                function_failed = True
            else:
                status = True
            break

    dict_result['status'] = status
    dict_result['function_failed'] = function_failed
    dict_result['json_result'] = json_result
    dict_result['complet_result'] = complet_result

    return dict_result


def execute_procedure(function_name, parameters=None, schema_name=None, commit=True, log_sql=False, rubber_band=None,
        aux_conn=None, is_thread=False, check_function=True):
    """ Manage execution database function
    :param function_name: Name of function to call (text)
    :param parameters: Parameters for function (json) or (query parameters)
    :param commit: Commit sql (bool)
    :param log_sql: Show query in qgis log (bool)
    :param aux_conn: Auxiliar connection to database used by threads (psycopg2.connection)
    :return: Response of the function executed (json)
    """

    # Check if function exists
    if check_function:
        row = tools_db.check_function(function_name, schema_name, commit, aux_conn=aux_conn)
        if row in (None, ''):
            tools_qgis.show_warning("Function not found in database", parameter=function_name)
            return None

    # Manage schema_name and parameters
    if schema_name:
        sql = f"SELECT {schema_name}.{function_name}("
    elif schema_name is None and global_vars.schema_name:
        sql = f"SELECT {global_vars.schema_name}.{function_name}("
    else:
        sql = f"SELECT {function_name}("
    if parameters:
        sql += f"{parameters}"
    sql += f");"

    # Get log_sql for developers
    dev_log_sql = get_config_parser('log', 'log_sql', "user", "init", False)
    if dev_log_sql in ("True", "False"):
        log_sql = tools_os.set_boolean(dev_log_sql)

    # Execute database function
    row = tools_db.get_row(sql, commit=commit, log_sql=log_sql, aux_conn=aux_conn)
    if not row or not row[0]:
        tools_log.log_warning(f"Function error: {function_name}")
        tools_log.log_warning(sql)
        return None

    # Get json result
    json_result = row[0]
    if log_sql:
        tools_log.log_db(json_result, header="SERVER RESPONSE")

    # All functions called from python should return 'status', if not, something has probably failed in postrgres
    if 'status' not in json_result:
        manage_json_exception(json_result, sql)
        return False

    # If failed, manage exception
    if json_result.get('status') == 'Failed':
        manage_json_exception(json_result, sql, is_thread=is_thread)
        return json_result

    try:
        if json_result["body"]["feature"]["geometry"] and global_vars.data_epsg != global_vars.project_epsg:
            json_result = manage_json_geometry(json_result)
    except Exception:
        pass

    if not is_thread:
        manage_json_response(json_result, sql, rubber_band)

    return json_result


def manage_json_geometry(json_result):

    # Set QgsCoordinateReferenceSystem
    data_epsg = QgsCoordinateReferenceSystem(str(global_vars.data_epsg))
    project_epsg = QgsCoordinateReferenceSystem(str(global_vars.project_epsg))

    tform = QgsCoordinateTransform(data_epsg, project_epsg, QgsProject.instance())

    list_coord = re.search('\((.*)\)', str(json_result['body']['feature']['geometry']['st_astext']))
    points = tools_qgis.get_geometry_vertex(list_coord)

    for point in points:
        if str(global_vars.data_epsg) == '2052' and str(global_vars.project_epsg) == '102566':
            clear_list = list_coord.group(1)
            updated_list = list_coord.group(1).replace('-', '').replace(' ', ' -')
            json_result['body']['feature']['geometry']['st_astext'] = json_result['body']['feature']['geometry']['st_astext'].replace(clear_list, updated_list)
        elif str(global_vars.data_epsg) != str(global_vars.project_epsg):
            new_coords = tform.transform(point)
            json_result['body']['feature']['geometry']['st_astext'] = json_result['body']['feature']['geometry']['st_astext'].replace(str(point.x()), str(new_coords.x()))
            json_result['body']['feature']['geometry']['st_astext'] = json_result['body']['feature']['geometry']['st_astext'].replace(str(point.y()), str(new_coords.y()))

    return json_result


def manage_json_response(complet_result, sql=None, rubber_band=None):

    if complet_result not in (None, False):
        try:
            manage_json_return(complet_result, sql, rubber_band)
            manage_layer_manager(complet_result)
            get_actions_from_json(complet_result, sql)
        except Exception:
            pass


def manage_json_exception(json_result, sql=None, stack_level=2, stack_level_increase=0, is_thread=False):
    """ Manage exception in JSON database queries and show information to the user """

    try:

        if 'message' in json_result:
            level = 1
            if 'level' in json_result['message']:
                level = int(json_result['message']['level'])
            if 'text' in json_result['message']:
                msg = json_result['message']['text']
            else:
                msg = json_result['message']

            # Show exception message only if we are not in a task process
            if len(global_vars.session_vars['threads']) == 0:
                tools_qgis.show_message(msg, level)
            else:
                tools_log.log_info(msg)

        else:

            stack_level += stack_level_increase
            if stack_level >= len(inspect.stack()):
                stack_level = len(inspect.stack()) - 1
            module_path = inspect.stack()[stack_level][1]
            file_name = tools_os.get_relative_path(module_path, 2)
            function_line = inspect.stack()[stack_level][2]
            function_name = inspect.stack()[stack_level][3]

            # Set exception message details
            title = "Database execution failed"
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
                msg += f"SQL: {sql}\n"
            if 'MSGERR' in json_result:
                msg += f"Message error: {json_result['MSGERR']}"
            global_vars.session_vars['last_error_msg'] = msg

            if is_thread:
                return

            tools_log.log_warning(msg, stack_level_increase=2)
            # Show exception message only if we are not in a task process
            if len(global_vars.session_vars['threads']) == 0:
                tools_qt.show_exception_message(title, msg)

    except Exception:
        tools_qt.manage_exception("Unhandled Error")


def manage_json_return(json_result, sql, rubber_band=None, i=None):
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

    srid = global_vars.data_epsg
    try:
        margin = None
        opacity = 100
        i = 0

        if 'zoom' in return_manager and 'margin' in return_manager['zoom']:
            margin = return_manager['zoom']['margin']

        if 'style' in return_manager and 'ruberband' in return_manager['style']:
            width = 3
            color = QColor(255, 0, 0, 125)
            if 'transparency' in return_manager['style']['ruberband']:
                opacity = return_manager['style']['ruberband']['transparency'] * 255
            if 'color' in return_manager['style']['ruberband']:
                color = return_manager['style']['ruberband']['color']
                color = QColor(int(color[0]), int(color[1]), int(color[2]), int(opacity))
            if 'width' in return_manager['style']['ruberband']:
                width = return_manager['style']['ruberband']['width']
            draw_by_json(json_result, rubber_band, margin, color=color, width=width)

        else:

            for key, value in list(json_result['body']['data'].items()):
                if key.lower() in ('point', 'line', 'polygon'):
                    if key not in json_result['body']['data']:
                        continue

                    # Remove the layer if it exists
                    layer_name = f'{key}'
                    if json_result['body']['data'][key].get('layerName'):
                        layer_name = json_result['body']['data'][key]['layerName']
                    tools_qgis.remove_layer_from_toc(layer_name, 'GW Temporal Layers')

                    if 'features' not in json_result['body']['data'][key]:
                        continue
                    if len(json_result['body']['data'][key]['features']) == 0:
                        continue

                    # Get values for create and populate layer
                    counter = len(json_result['body']['data'][key]['features'])
                    geometry_type = json_result['body']['data'][key]['geometryType']
                    v_layer = QgsVectorLayer(f"{geometry_type}?crs=epsg:{srid}", layer_name, 'memory')
                    fill_layer_temp(v_layer, json_result['body']['data'], key, counter, sort_val=i)

                    # Increase iterator
                    i = i+1

                    # Get values for set layer style
                    opacity = 100
                    style_type = json_result['body']['returnManager']['style']

                    if 'style' in return_manager and 'values' in return_manager['style'][key]:
                        if 'transparency' in return_manager['style'][key]['values']:
                            opacity = return_manager['style'][key]['values']['transparency']
                    if style_type[key]['style'] == 'categorized':
                        if 'transparency' in return_manager['style'][key]:
                            opacity = return_manager['style'][key]['transparency']
                        color_values = {}
                        for item in json_result['body']['returnManager']['style'][key]['values']:
                            color = QColor(item['color'][0], item['color'][1], item['color'][2], int(opacity * 255))
                            color_values[item['id']] = color
                        cat_field = str(style_type[key]['field'])
                        size = style_type[key]['width'] if style_type[key].get('width') else 2
                        tools_qgis.set_layer_categoryze(v_layer, cat_field, size, color_values)

                    elif style_type[key]['style'] == 'random':
                        size = style_type['width'] if style_type.get('width') else 2
                        if geometry_type == 'Point':
                            v_layer.renderer().symbol().setSize(size)
                        else:
                            v_layer.renderer().symbol().setWidth(size)
                        v_layer.renderer().symbol().setOpacity(opacity)

                    elif style_type[key]['style'] == 'qml':
                        style_id = style_type[key]['id']
                        extras = f'"style_id":"{style_id}"'
                        body = create_body(extras=extras)
                        style = execute_procedure('gw_fct_getstyle', body)
                        if style is None or style.get('status') == 'Failed':
                            return
                        if 'styles' in style['body']:
                            if 'style' in style['body']['styles']:
                                qml = style['body']['styles']['style']
                                tools_qgis.create_qml(v_layer, qml)

                    elif style_type[key]['style'] == 'unique':
                        color = style_type[key]['values']['color']
                        size = style_type['width'] if style_type.get('width') else 2
                        color = QColor(color[0], color[1], color[2])
                        if key == 'point':
                            v_layer.renderer().symbol().setSize(size)
                        elif key in ('line', 'polygon'):
                            v_layer.renderer().symbol().setWidth(size)
                        v_layer.renderer().symbol().setColor(color)
                        v_layer.renderer().symbol().setOpacity(opacity)

                    global_vars.iface.layerTreeView().refreshLayerSymbology(v_layer.id())
                    if margin:
                        tools_qgis.set_margin(v_layer, margin)

    except Exception as e:
        tools_qt.manage_exception(None, f"{type(e).__name__}: {e}", sql, global_vars.schema_name)
    finally:
        # Clean any broken temporal layers (left with no data)
        tools_qgis.clean_layer_group_from_toc('GW Temporal Layers')


def get_rows_by_feature_type(class_object, dialog, table_object, feature_type):
    """ Get records of @feature_type associated to selected @table_object """

    object_id = tools_qt.get_text(dialog, table_object + "_id")
    table_relation = table_object + "_x_" + feature_type
    widget_name = "tbl_" + table_relation

    exists = tools_db.check_table(table_relation)
    if not exists:
        tools_log.log_info(f"Not found: {table_relation}")
        return

    sql = (f"SELECT {feature_type}_id "
           f"FROM {table_relation} "
           f"WHERE {table_object}_id = '{object_id}'")
    rows = tools_db.get_rows(sql, log_info=False)
    if rows:
        for row in rows:
            class_object.list_ids[feature_type].append(str(row[0]))
            class_object.ids.append(str(row[0]))

        expr_filter = get_expression_filter(feature_type, class_object.list_ids, class_object.layers)
        table_name = f"v_edit_{feature_type}"
        tools_qt.set_table_model(dialog, widget_name, table_name, expr_filter)


def get_project_type(schemaname=None):
    """ Get project type from table 'sys_version' """

    project_type = None
    if schemaname is None and global_vars.schema_name is None:
        return None
    elif schemaname in (None, 'null', ''):
        schemaname = global_vars.schema_name

    tablename = "sys_version"
    exists = tools_db.check_table(tablename, schemaname)
    if not exists:
        tools_qgis.show_warning(f"Table not found: '{tablename}'")
        return None

    sql = f"SELECT lower(project_type) FROM {schemaname}.{tablename} ORDER BY id DESC LIMIT 1"
    row = tools_db.get_row(sql)
    if row:
        project_type = row[0]

    return project_type


def get_project_info(schemaname=None):
    """ Get project information from table 'sys_version' """

    project_info_dict = None
    if schemaname is None and global_vars.schema_name is None:
        return None
    elif schemaname in (None, 'null', ''):
        schemaname = global_vars.schema_name

    tablename = "sys_version"
    exists = tools_db.check_table(tablename, schemaname)
    if not exists:
        tools_qgis.show_warning(f"Table not found: '{tablename}'")
        return None

    sql = (f"SELECT lower(project_type), epsg, giswater, language "
           f"FROM {schemaname}.{tablename} "
           f"ORDER BY id DESC LIMIT 1")
    row = tools_db.get_row(sql)
    if row:
        project_info_dict = {'project_type': row[0],
                             'project_epsg': row[1],
                             'project_version': row[2],
                             'project_language': row[3],
                             }

    return project_info_dict


def get_layers_from_feature_type(feature_type):
    """ Get layers of the group @feature_type """

    list_items = []
    sql = (f"SELECT child_layer "
           f"FROM cat_feature "
           f"WHERE upper(feature_type) = '{feature_type.upper()}' "
           f"UNION SELECT DISTINCT parent_layer "
           f"FROM cat_feature "
           f"WHERE upper(feature_type) = '{feature_type.upper()}';")
    rows = tools_db.get_rows(sql)
    if rows:
        for row in rows:
            layer = tools_qgis.get_layer_by_tablename(row[0])
            if layer:
                list_items.append(layer)

    return list_items


def get_role_permissions(qgis_project_role):

    role_master = False
    role_edit = False
    role_om = False
    role_epa = False
    role_basic = False

    role_admin = tools_db.check_role_user("role_admin")
    if not role_admin:
        role_master = tools_db.check_role_user("role_master")
        if not role_master:
            role_epa = tools_db.check_role_user("role_epa")
            if not role_epa:
                role_edit = tools_db.check_role_user("role_edit")
                if not role_edit:
                    role_om = tools_db.check_role_user("role_om")
                    if not role_om:
                        role_basic = tools_db.check_role_user("role_basic")

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
    elif role_admin or qgis_project_role == 'role_admin':
        return 'role_admin'
    else:
        return 'role_basic'


def get_config_value(parameter='', columns='value', table='config_param_user', sql_added=None, log_info=True):

    if not tools_db.check_table(table):
        tools_log.log_warning(f"Table not found: {table}")
        return None

    sql = f"SELECT {columns} FROM {table} WHERE parameter = '{parameter}' "
    if sql_added:
        sql += sql_added
    if table == 'config_param_user':
        sql += " AND cur_user = current_user"
    sql += ";"
    row = tools_db.get_row(sql, log_info=log_info)
    return row


def manage_layer_manager(json_result, sql=None):
    """
    Manage options for layers (active, visible, zoom and indexing)
    :param json_result: Json result of a query (Json)
    :param sql: query executed (String)
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
                    add_layer_database(layer_name, the_geom, field_id, group=group, style_id=style_id)
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
                tools_qgis.set_margin(layer, margin)
                if prev_layer:
                    global_vars.iface.setActiveLayer(prev_layer)

        # Set snnaping options
        if 'snnaping' in layermanager:
            snapper_manager = GwSnapManager(global_vars.iface)
            for layer_name in layermanager['snnaping']:
                layer = tools_qgis.get_layer_by_tablename(layer_name)
                if layer:
                    QgsProject.instance().blockSignals(True)
                    segment_flag = get_vertex_flag(2)
                    layer_settings = snapper_manager.config_snap_to_layer(layer, QgsPointLocator.All, True)
                    if layer_settings:
                        layer_settings.setTypeFlag(segment_flag)
                        layer_settings.setTolerance(15)
                        layer_settings.setEnabled(True)
                    else:
                        layer_settings = QgsSnappingConfig.IndividualLayerSettings(True, segment_flag, 15, 1)
                    snapping_config = snapper_manager.get_snapping_options()
                    snapping_config.setIndividualLayerSettings(layer, layer_settings)
                    QgsProject.instance().blockSignals(False)
                    QgsProject.instance().snappingConfigChanged.emit(snapping_config)
            snapper_manager.set_snap_mode()
            del snapper_manager

    except Exception as e:
        tools_qt.manage_exception(None, f"{type(e).__name__}: {e}", sql, global_vars.schema_name)


def selection_init(class_object, dialog, table_object, query=False):
    """ Set canvas map tool to an instance of class 'GwSelectManager' """

    try:
        class_object.feature_type = get_signal_change_tab(dialog, excluded_layers=class_object.excluded_layers)
    except AttributeError:
        # In case the dialog has no tab
        pass

    if class_object.feature_type in ('all', None):
        class_object.feature_type = 'arc'

    select_manager = GwSelectManager(class_object, table_object, dialog, query)
    global_vars.canvas.setMapTool(select_manager)
    cursor = get_cursor_multiple_selection()
    global_vars.canvas.setCursor(cursor)


def selection_changed(class_object, dialog, table_object, query=False, lazy_widget=None, lazy_init_function=None):
    """ Slot function for signal 'canvas.selectionChanged' """

    tools_qgis.disconnect_signal_selection_changed()
    field_id = f"{class_object.feature_type}_id"

    ids = []
    if class_object.layers is None:
        return

    # Iterate over all layers of the group
    for layer in class_object.layers[class_object.feature_type]:
        if layer.selectedFeatureCount() > 0:
            # Get selected features of the layer
            features = layer.selectedFeatures()
            for feature in features:
                # Append 'feature_id' into the list
                selected_id = feature.attribute(field_id)
                if selected_id not in ids:
                    ids.append(selected_id)

    class_object.list_ids[class_object.feature_type] = ids

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

        tools_qgis.select_features_by_ids(class_object.feature_type, expr, class_object.layers)

    # Reload contents of table 'tbl_@table_object_x_@feature_type'
    if query:
        _insert_feature_psector(dialog, class_object.feature_type, ids=ids)
        remove_selection()
        load_tableview_psector(dialog, class_object.feature_type)
    else:
        load_tablename(dialog, table_object, class_object.feature_type, expr_filter)
        tools_qt.set_lazy_init(table_object, lazy_widget=lazy_widget, lazy_init_function=lazy_init_function)

    enable_feature_type(dialog, table_object, ids=ids)
    class_object.ids = ids


def insert_feature(class_object, dialog, table_object, query=False, remove_ids=True, lazy_widget=None,
                   lazy_init_function=None):
    """ Select feature with entered id. Set a model with selected filter.
        Attach that model to selected table
    """

    tools_qgis.disconnect_signal_selection_changed()
    feature_type = get_signal_change_tab(dialog)
    # Clear list of ids
    if remove_ids:
        class_object.ids = []

    field_id = f"{feature_type}_id"
    feature_id = tools_qt.get_text(dialog, "feature_id")
    expr_filter = f"{field_id} = '{feature_id}'"

    # Check expression
    (is_valid, expr) = tools_qt.check_expression_filter(expr_filter)
    if not is_valid:
        return None

    # Select features of layers applying @expr
    tools_qgis.select_features_by_ids(feature_type, expr, layers=class_object.layers)

    if feature_id == 'null':
        message = "You need to enter a feature id"
        tools_qt.show_info_box(message)
        return

    # Iterate over all layers of the group
    for layer in class_object.layers[feature_type]:
        if layer.selectedFeatureCount() > 0:
            # Get selected features of the layer
            features = layer.selectedFeatures()
            for feature in features:
                # Append 'feature_id' into the list
                selected_id = feature.attribute(field_id)
                if selected_id not in class_object.ids:
                    class_object.ids.append(selected_id)
        if feature_id not in class_object.ids:
            # If feature id doesn't exist in list -> add
            class_object.ids.append(str(feature_id))

    # Set expression filter with features in the list
    expr_filter = f'"{field_id}" IN (  '
    for i in range(len(class_object.ids)):
        expr_filter += f"'{class_object.ids[i]}', "
    expr_filter = expr_filter[:-2] + ")"

    # Check expression
    (is_valid, expr) = tools_qt.check_expression_filter(expr_filter)
    if not is_valid:
        return

    # Select features with previous filter
    # Build a list of feature id's and select them
    for layer in class_object.layers[feature_type]:
        it = layer.getFeatures(QgsFeatureRequest(expr))
        id_list = [i.id() for i in it]
        if len(id_list) > 0:
            layer.selectByIds(id_list)

    # Reload contents of table 'tbl_xxx_xxx_@feature_type'
    if query:
        _insert_feature_psector(dialog, feature_type, ids=class_object.ids)
        layers = remove_selection(True, class_object.layers)
        class_object.layers = layers
    else:
        load_tablename(dialog, table_object, feature_type, expr_filter)
        tools_qt.set_lazy_init(table_object, lazy_widget=lazy_widget, lazy_init_function=lazy_init_function)

    # Update list
    class_object.list_ids[feature_type] = class_object.ids
    enable_feature_type(dialog, table_object, ids=class_object.ids)
    connect_signal_selection_changed(class_object, dialog, table_object, feature_type)


def remove_selection(remove_groups=True, layers=None):
    """ Remove all previous selections """

    list_layers = ["v_edit_arc", "v_edit_node", "v_edit_connec", "v_edit_element"]
    if global_vars.project_type == 'ud':
        list_layers.append("v_edit_gully")

    for layer_name in list_layers:
        layer = tools_qgis.get_layer_by_tablename(layer_name)
        if layer:
            layer.removeSelection()

    if remove_groups and layers is not None:
        for key, elems in layers.items():
            for layer in layers[key]:
                if layer:
                    layer.removeSelection()

    global_vars.canvas.refresh()

    return layers


def connect_signal_selection_changed(class_object, dialog, table_object, query=False):
    """ Connect signal selectionChanged """

    try:
        global_vars.canvas.selectionChanged.connect(
            partial(selection_changed, class_object, dialog, table_object, query))
    except Exception as e:
        tools_log.log_info(f"connect_signal_selection_changed: {e}")


def docker_dialog(dialog):

    positions = {8: Qt.BottomDockWidgetArea, 4: Qt.TopDockWidgetArea,
                 2: Qt.RightDockWidgetArea, 1: Qt.LeftDockWidgetArea}
    try:
        global_vars.session_vars['dialog_docker'].setWindowTitle(dialog.windowTitle())
        global_vars.session_vars['dialog_docker'].setWidget(dialog)
        global_vars.session_vars['dialog_docker'].setWindowFlags(Qt.WindowContextHelpButtonHint)
        global_vars.iface.addDockWidget(positions[global_vars.session_vars['dialog_docker'].position],
                                        global_vars.session_vars['dialog_docker'])
    except RuntimeError as e:
        tools_log.log_warning(f"{type(e).__name__} --> {e}")


def init_docker(docker_param='qgis_info_docker'):
    """ Get user config parameter @docker_param """

    global_vars.session_vars['info_docker'] = True
    # Show info or form in docker?
    row = get_config_value(docker_param)
    if not row:
        global_vars.session_vars['dialog_docker'] = None
        global_vars.session_vars['docker_type'] = None
        return None
    value = row[0].lower()

    # Check if docker has dialog of type 'form' or 'main'
    if docker_param == 'qgis_info_docker':
        if global_vars.session_vars['dialog_docker']:
            if global_vars.session_vars['docker_type']:
                if global_vars.session_vars['docker_type'] != 'qgis_info_docker':
                    global_vars.session_vars['info_docker'] = False
                    return None

    if value == 'true':
        close_docker()
        global_vars.session_vars['docker_type'] = docker_param
        global_vars.session_vars['dialog_docker'] = GwDocker()
        global_vars.session_vars['dialog_docker'].dlg_closed.connect(partial(close_docker, option_name='position'))
        manage_docker_options()
    else:
        global_vars.session_vars['dialog_docker'] = None
        global_vars.session_vars['docker_type'] = None

    return global_vars.session_vars['dialog_docker']


def close_docker(option_name='position'):
    """ Save QDockWidget position (1=Left, 2=Right, 4=Top, 8=Bottom),
        remove from iface and del class
    """

    try:
        if global_vars.session_vars['dialog_docker']:
            if not global_vars.session_vars['dialog_docker'].isFloating():
                docker_pos = global_vars.iface.mainWindow().dockWidgetArea(global_vars.session_vars['dialog_docker'])
                widget = global_vars.session_vars['dialog_docker'].widget()
                if widget:
                    widget.close()
                    del widget
                    global_vars.session_vars['dialog_docker'].setWidget(None)
                    global_vars.session_vars['docker_type'] = None
                    set_config_parser('docker', option_name, f'{docker_pos}')
                global_vars.iface.removeDockWidget(global_vars.session_vars['dialog_docker'])
                global_vars.session_vars['dialog_docker'] = None
    except AttributeError:
        global_vars.session_vars['docker_type'] = None
        global_vars.session_vars['dialog_docker'] = None


def manage_docker_options(option_name='position'):
    """ Check if user want dock the dialog or not """

    # Load last docker position
    try:
        # Docker positions: 1=Left, 2=Right, 4=Top, 8=Bottom
        pos = int(get_config_parser('docker', option_name, "user", "session"))
        global_vars.session_vars['dialog_docker'].position = 2
        if pos in (1, 2, 4, 8):
            global_vars.session_vars['dialog_docker'].position = pos
    except Exception:
        global_vars.session_vars['dialog_docker'].position = 2


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
    sql = (f"SELECT columnindex, width, alias, visible, style"
           f" FROM {config_table}"
           f" WHERE tablename = '{table_name}'"
           f" ORDER BY columnindex")
    rows = tools_db.get_rows(sql)

    if not rows:
        return

    for row in rows:
        if not row['visible']:
            columns_to_delete.append(row['columnindex'])
        else:
            style = row.get('style')
            if style:
                stretch = style.get('stretch')
                if stretch is not None:
                    stretch = 1 if stretch else 0
                    widget.horizontalHeader().setSectionResizeMode(row['columnindex'], stretch)
            width = row['width']
            if width is None:
                width = 100
            widget.setColumnWidth(row['columnindex'], width)
            if row['alias'] is not None:
                widget.model().setHeaderData(row['columnindex'], Qt.Horizontal, row['alias'])

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


def add_icon(widget, icon, sub_folder="20x20"):
    """ Set @icon to selected @widget """

    # Get icons folder
    icons_folder = os.path.join(global_vars.plugin_dir, f"icons{os.sep}dialogs{os.sep}{sub_folder}")
    icon_path = os.path.join(icons_folder, str(icon) + ".png")
    if os.path.exists(icon_path):
        widget.setIcon(QIcon(icon_path))
        if type(widget) is QPushButton:
            widget.setProperty('has_icon', True)
    else:
        tools_log.log_info("File not found", parameter=icon_path)


def add_tableview_header(widget, field):

    model = widget.model()
    if model is None:
        model = QStandardItemModel()
    # Related by Qtable
    widget.setModel(model)
    widget.horizontalHeader().setStretchLastSection(True)

    # Get headers
    headers = []
    for x in field['value'][0]:
        headers.append(x)
    # Set headers
    model.setHorizontalHeaderLabels(headers)

    return widget


def fill_tableview_rows(widget, field):

    model = widget.model()
    for item in field['value']:
        row = []
        for value in item.values():
            if value is None:
                value = ""
            if issubclass(type(value), dict):
                value = json.dumps(value)
            row.append(QStandardItem(str(value)))
        if len(row) > 0:
            model.appendRow(row)

    return widget


def set_calendar_from_user_param(dialog, widget, table_name, value, parameter):
    """ Executes query and set QDateEdit """

    sql = (f"SELECT {value} FROM {table_name}"
           f" WHERE parameter = '{parameter}' AND cur_user = current_user")
    row = tools_db.get_row(sql)
    if row and row[0]:
        date = QDate.fromString(row[0].replace('/', '-'), 'yyyy-MM-dd')
    else:
        date = QDate.currentDate()
    tools_qt.set_calendar(dialog, widget, date)


def load_tablename(dialog, table_object, feature_type, expr_filter):
    """ Reload @widget with contents of @tablename applying selected @expr_filter """

    widget_name = None
    if type(table_object) is str:
        widget_name = f"tbl_{table_object}_x_{feature_type}"
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

    table_name = f"v_edit_{feature_type}"
    expr = tools_qt.set_table_model(dialog, widget, table_name, expr_filter)
    if widget_name is not None:
        set_tablemodel_config(dialog, widget_name, table_name)

    return expr


def load_tableview_psector(dialog, feature_type):
    """ Reload QtableView """

    value = tools_qt.get_text(dialog, dialog.psector_id)
    expr = f"psector_id = '{value}'"
    qtable = tools_qt.get_widget(dialog, f'tbl_psector_x_{feature_type}')
    message = tools_qt.fill_table(qtable, f"plan_psector_x_{feature_type}", expr, QSqlTableModel.OnFieldChange)
    if message:
        tools_qgis.show_warning(message)
    set_tablemodel_config(dialog, qtable, f"plan_psector_x_{feature_type}")
    tools_qgis.refresh_map_canvas()


def set_completer_object(dialog, tablename, field_id="id"):
    """ Set autocomplete of widget @table_object + "_id"
        getting id's from selected @table_object

        TODO: Refactor. It should have this params: (dialog, widget, tablename, field_id="id")
            The widget might not be called '@table_object + "_id"'
    """

    widget_name = tablename + "_id"
    if tablename == "v_edit_element":  # TODO: remove this when refactored
        widget_name = "element_id"

    widget = tools_qt.get_widget(dialog, widget_name)
    if not widget:
        return

    set_completer_widget(tablename, widget, field_id)


def set_completer_widget(tablename, widget, field_id, add_id=False):
    """ Set autocomplete of widget @table_object + "_id"
        getting id's from selected @table_object
    """

    if not widget:
        return
    if type(tablename) == list and type(field_id) == list:
        return set_multi_completer_widget(tablename, widget, field_id, add_id=add_id)
    if add_id:
        field_id += '_id'

    sql = (f"SELECT DISTINCT({field_id})"
           f" FROM {tablename}"
           f" ORDER BY {field_id}")
    rows = tools_db.get_rows(sql)
    tools_qt.set_completer_rows(widget, rows)


def set_multi_completer_widget(tablenames: list, widget, fields_id: list, add_id=False):
    """ Set autocomplete of widget @table_object + "_id"
        getting id's from selected @table_object
    """

    if not widget:
        return

    sql = ""
    idx = 0
    for tablename in tablenames:
        field_id = fields_id[idx]
        if add_id:
            field_id += '_id'
        if sql != "":
            sql += " UNION "
        sql += (f"SELECT DISTINCT({field_id}) as a"
                f" FROM {tablename}")
        idx += 1
    sql += f" ORDER BY a"

    rows = tools_db.get_rows(sql)
    tools_qt.set_completer_rows(widget, rows)


def set_dates_from_to(widget_from, widget_to, table_name, field_from, field_to, max_back_date=None, max_fwd_date=None):
    """
    Builds query to populate @widget_from & @widget_to dates
        :param widget_from:
        :param widget_to:
        :param table_name:
        :param field_from:
        :param field_to:
        :param max_back_date: a PostgreSQL valid interval (eg. '1 year')
        :param max_fwd_date: a PostgreSQL valid interval (eg. '1 year')
    """

    min_sql = f"MIN(LEAST({field_from}, {field_to}))"
    max_sql = f"MAX(GREATEST({field_from}, {field_to}))"
    if max_back_date:
        min_sql = f"GREATEST({min_sql}, now() - interval '{max_back_date}')"
    if max_fwd_date:
        max_sql = f"LEAST({max_sql}, now() + interval '{max_fwd_date}')"

    sql = f"SELECT {min_sql}, {max_sql} FROM {table_name}"
    row = tools_db.get_row(sql)
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


def manage_close(dialog, table_object, cur_active_layer=None, single_tool_mode=None, layers=None):
    """ Close dialog and disconnect snapping """

    tools_qgis.disconnect_snapping()
    tools_qgis.disconnect_signal_selection_changed()
    if cur_active_layer:
        global_vars.iface.setActiveLayer(cur_active_layer)
    # some tools can work differently if standalone or integrated in another tool
    if single_tool_mode is not None:
        layers = remove_selection(single_tool_mode, layers=layers)
    else:
        layers = remove_selection(True, layers=layers)

    list_feature_type = ['arc', 'node', 'connec', 'element']
    if global_vars.project_type == 'ud':
        list_feature_type.append('gully')
    for feature_type in list_feature_type:
        tools_qt.reset_model(dialog, table_object, feature_type)

    close_dialog(dialog)

    return layers


def delete_records(class_object, dialog, table_object, query=False, lazy_widget=None, lazy_init_function=None):
    """ Delete selected elements of the table """

    tools_qgis.disconnect_signal_selection_changed()
    feature_type = get_signal_change_tab(dialog)
    if type(table_object) is str:
        widget_name = f"tbl_{table_object}_x_{feature_type}"
        widget = tools_qt.get_widget(dialog, widget_name)
        if not widget:
            message = "Widget not found"
            tools_qgis.show_warning(message, parameter=widget_name)
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
            class_object.ids.append(widget.model().record(x).value(f"{feature_type}_id"))
    else:
        class_object.ids = class_object.list_ids[feature_type]

    field_id = feature_type + "_id"

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
    answer = tools_qt.show_question(message, title, inf_text)
    if answer:
        for el in del_id:
            class_object.ids.remove(el)
    else:
        return

    expr_filter = None
    expr = None
    if len(class_object.ids) > 0:

        # Set expression filter with features in the list
        expr_filter = f'"{field_id}" IN ('
        for i in range(len(class_object.ids)):
            expr_filter += f"'{class_object.ids[i]}', "
        expr_filter = expr_filter[:-2] + ")"

        # Check expression
        (is_valid, expr) = tools_qt.check_expression_filter(expr_filter)  # @UnusedVariable
        if not is_valid:
            return

    # Update model of the widget with selected expr_filter
    if query:
        _delete_feature_psector(dialog, feature_type, list_id)
        load_tableview_psector(dialog, feature_type)
    else:
        load_tablename(dialog, table_object, feature_type, expr_filter)
        tools_qt.set_lazy_init(table_object, lazy_widget=lazy_widget, lazy_init_function=lazy_init_function)

    # Select features with previous filter
    # Build a list of feature id's and select them
    tools_qgis.select_features_by_ids(feature_type, expr, layers=class_object.layers)

    if query:
        class_object.layers = remove_selection(layers=class_object.layers)

    # Update list
    class_object.list_ids[feature_type] = class_object.ids
    enable_feature_type(dialog, table_object, ids=class_object.ids)
    connect_signal_selection_changed(class_object, dialog, table_object, query)


def get_parent_layers_visibility():
    """ Get layer visibility to restore when dialog is closed
    :return: example: {<QgsMapLayer: 'Arc' (postgres)>: True, <QgsMapLayer: 'Node' (postgres)>: False,
                       <QgsMapLayer: 'Connec' (postgres)>: True, <QgsMapLayer: 'Element' (postgres)>: False}
    """

    layers_visibility = {}
    for layer_name in ["v_edit_arc", "v_edit_node", "v_edit_connec", "v_edit_element", "v_edit_gully"]:
        layer = tools_qgis.get_layer_by_tablename(layer_name)
        if layer:
            layers_visibility[layer] = tools_qgis.is_layer_visible(layer)

    return layers_visibility


def restore_parent_layers_visibility(layers):
    """ Receive a dictionary with the layer and if it has to be active or not
    :param layers: example: {<QgsMapLayer: 'Arc' (postgres)>: True, <QgsMapLayer: 'Node' (postgres)>: False,
                             <QgsMapLayer: 'Connec' (postgres)>: True, <QgsMapLayer: 'Element' (postgres)>: False}
    """

    for layer, visibility in layers.items():
        tools_qgis.set_layer_visible(layer, False, visibility)


def create_rubberband(canvas, geometry_type=1):
    """ Creates a rubberband and adds it to the global list """

    rb = QgsRubberBand(canvas, geometry_type)
    global_vars.active_rubberbands.append(rb)
    return rb


def reset_rubberband(rb, geometry_type=None):
    """ Resets a rubberband and tries to remove it from the global list """

    if geometry_type:
        rb.reset(geometry_type)
    else:
        rb.reset()

    try:
        global_vars.active_rubberbands.remove(rb)
    except ValueError:
        pass


def set_epsg():

    epsg = tools_qgis.get_epsg()
    global_vars.project_epsg = epsg


def refresh_selectors(tab_name=None):
    """ Refreshes the selectors' UI if it's open """

    # Get the selector UI if it's open
    windows = [x for x in QApplication.allWidgets() if getattr(x, "isVisible", False)
               and (issubclass(type(x), GwSelectorUi))]

    if windows:
        try:
            dialog = windows[0]
            selector = dialog.property('GwSelector')
            if tab_name is None:
                tab_name = dialog.main_tab.widget(dialog.main_tab.currentIndex()).objectName()
            selector.get_selector(dialog, '"selector_basic"', filter=True, current_tab=tab_name)
        except Exception:
            pass


def open_dlg_help():
    """ Opens the help page for the last focused dialog """

    parser = configparser.ConfigParser()
    path = f"{global_vars.plugin_dir}{os.sep}config{os.sep}giswater.config"
    if not os.path.exists(path):
        webbrowser.open_new_tab('https://giswater.gitbook.io/giswater-manual')
        return True

    parser.read(path)
    try:
        web_tag = parser.get('web_tag', global_vars.session_vars['last_focus'])
        webbrowser.open_new_tab(f'https://giswater.gitbook.io/giswater-manual/{web_tag}')
    except Exception:
        webbrowser.open_new_tab('https://giswater.gitbook.io/giswater-manual')
    finally:
        return True


def manage_current_selections_docker(result, open=False):
    """
    Manage labels for the current_selections docker
        :param result: looks the data in result['body']['data']['userValues']
        :param open: if it has to create a new docker or just update it
    """

    if not result or 'body' not in result or 'data' not in result['body']:
        return

    title = "Gw Selectors: "
    if 'userValues' in result['body']['data']:
        for user_value in result['body']['data']['userValues']:
            if user_value['parameter'] == 'plan_psector_vdefault' and user_value['value']:
                sql = f"SELECT name FROM plan_psector WHERE psector_id = {user_value['value']}"
                row = tools_db.get_row(sql, log_info=False)
                if row:
                    title += f"{row[0]} | "
            elif user_value['parameter'] == 'utils_workspace_vdefault' and user_value['value']:
                sql = f"SELECT name FROM cat_workspace WHERE id = {user_value['value']}"
                row = tools_db.get_row(sql, log_info=False)
                if row:
                    title += f"{row[0]} | "
            elif user_value['value']:
                title += f"{user_value['value']} | "

        if global_vars.session_vars['current_selections'] is None:
            global_vars.session_vars['current_selections'] = QDockWidget(title[:-3])
        else:
            global_vars.session_vars['current_selections'].setWindowTitle(title[:-3])
        if open:
            global_vars.iface.addDockWidget(Qt.LeftDockWidgetArea, global_vars.session_vars['current_selections'])


def create_sqlite_conn(file_name):
    """ Creates an sqlite connection to a file """

    status = False
    cursor = None
    try:
        db_path = f"{global_vars.plugin_dir}{os.sep}resources{os.sep}gis{os.sep}{file_name}.sqlite"
        tools_log.log_info(db_path)
        if os.path.exists(db_path):
            conn = sqlite3.connect(db_path)
            cursor = conn.cursor()
            status = True
        else:
            tools_log.log_warning("Config database file not found", parameter=db_path)
    except Exception as e:
        tools_log.log_warning(str(e))

    return status, cursor


def manage_user_config_folder(user_folder_dir):
    """ Check if user config folder exists. If not create empty files init.config and session.config """

    try:
        config_folder = f"{user_folder_dir}{os.sep}config{os.sep}"
        if not os.path.exists(config_folder):
            tools_log.log_info(f"Creating user config folder: {config_folder}")
            os.makedirs(config_folder)

        # Check if config files exists. If not create them empty
        filepath = f"{config_folder}{os.sep}init.config"
        if not os.path.exists(filepath):
            open(filepath, 'a').close()
        filepath = f"{config_folder}{os.sep}session.config"
        if not os.path.exists(filepath):
            open(filepath, 'a').close()

    except Exception as e:
        tools_log.log_warning(f"manage_user_config_folder: {e}")


def check_old_userconfig(user_folder_dir):
    """ Function to transfer user configuration from version 3.5.023 or older to new `.../core/` folder """

    # Move all files in old config folder to new core config folder
    old_folder_path = f"{user_folder_dir}{os.sep}config"
    if os.path.exists(old_folder_path):
        for file in os.listdir(old_folder_path):
            old = f"{old_folder_path}{os.sep}{file}"
            new = f"{user_folder_dir}{os.sep}core{os.sep}config{os.sep}{file}"
            if os.path.exists(new):
                os.remove(new)
            os.rename(old, new)
        os.removedirs(old_folder_path)

    # Remove old log folder
    old_folder_path = f"{user_folder_dir}{os.sep}log"
    if os.path.exists(old_folder_path):
        for file in os.listdir(old_folder_path):
            path = f"{old_folder_path}{os.sep}{file}"
            os.remove(path)
        os.removedirs(old_folder_path)


def user_params_to_userconfig():
    """ Function to load all the variables from user_params.config to their respective user config files """

    parser = global_vars.configs['user_params'][1]
    if parser is None:
        return

    # Get the sections of the user params inventory
    inv_sections = parser.sections()

    # For each section (inventory)
    for section in inv_sections:

        file_name = section.split('.')[0]
        section_name = section.split('.')[1]
        parameters = parser.options(section)

        # For each parameter (inventory)
        for parameter in parameters:

            # Manage if parameter need prefix and project_type is not defined
            if parameter.startswith("_") and global_vars.project_type is None:
                continue
            if parameter.startswith("#"):
                continue
                
            _pre = False
            inv_param = parameter
            # If it needs a prefix
            if parameter.startswith("_"):
                _pre = True
                parameter = inv_param[1:]
            # If it's just a comment line
            if parameter.startswith("#"):
                # tools_log.log_info(f"set_config_parser: {file_name} {section_name} {parameter}")
                set_config_parser(section_name, parameter, None, "user", file_name, prefix=False, chk_user_params=False)
                continue

            # If it's a normal value
            # Get value[section][parameter] of the user config file
            value = get_config_parser(section_name, parameter, "user", file_name, _pre, True, False, True)

            # If this value (user config file) is None (doesn't exist, isn't set, etc.)
            if value is None:
                # Read the default value for that parameter
                value = get_config_parser(section, inv_param, "project", "user_params", False, True, False, True)
                # Set value[section][parameter] in the user config file
                set_config_parser(section_name, parameter, value, "user", file_name, None, _pre, False)
            else:
                value2 = get_config_parser(section, inv_param, "project", "user_params", False, True, False, True)
                if value2 is not None:
                    # If there's an inline comment in the inventory but there isn't one in the user config file, add it
                    if "#" not in value and "#" in value2:
                        # Get the comment (inventory) and set it (user config file)
                        comment = value2.split('#')[1]
                        set_config_parser(section_name, parameter, value.strip(), "user", file_name, comment, _pre, False)


def remove_deprecated_config_vars():
    """ Removes all deprecated variables defined at giswater.config """

    if global_vars.user_folder_dir is None:
        return

    init_parser = configparser.ConfigParser()
    session_parser = configparser.ConfigParser()
    path_folder = os.path.join(tools_os.get_datadir(), global_vars.user_folder_dir)
    project_types = get_config_parser('system', 'project_types', "project", "giswater").split(',')

    # Remove deprecated sections for init
    path = f"{path_folder}{os.sep}core{os.sep}config{os.sep}init.config"
    if not os.path.exists(path):
        tools_log.log_warning(f"File not found: {path}")
        return

    init_parser.read(path)
    vars = get_config_parser('system', 'deprecated_section_init', "project", "giswater")
    if vars is not None:
        for var in vars.split(','):
            section = var.split('.')[0].strip()
            if not init_parser.has_section(section):
                continue
            init_parser.remove_section(section)

    with open(path, 'w') as configfile:
        init_parser.write(configfile)
        configfile.close()

    # Remove deprecated sections for session
    path = f"{path_folder}{os.sep}core{os.sep}config{os.sep}session.config"
    if not os.path.exists(path):
        tools_log.log_warning(f"File not found: {path}")
        return

    session_parser.read(path)
    vars = get_config_parser('system', 'deprecated_section_session', "project", "giswater")
    if vars is not None:
        for var in vars.split(','):
            section = var.split('.')[0].strip()
            if not session_parser.has_section(section):
                continue
            session_parser.remove_section(section)

    with open(path, 'w') as configfile:
        session_parser.write(configfile)
        configfile.close()

    # Remove deprecated vars for init
    path = f"{path_folder}{os.sep}core{os.sep}config{os.sep}init.config"
    if not os.path.exists(path):
        tools_log.log_warning(f"File not found: {path}")
        return

    init_parser.read(path)
    vars = get_config_parser('system', 'deprecated_vars_init', "project", "giswater")
    if vars is not None:
        for var in vars.split(','):
            section = var.split('.')[0].strip()
            if not init_parser.has_section(section):
                continue
            option = var.split('.')[1].strip()
            if option.startswith('_'):
                for proj in project_types:
                    init_parser.remove_option(section, f"{proj}{option}")
            else:
                init_parser.remove_option(section, option)

    with open(path, 'w') as configfile:
        init_parser.write(configfile)
        configfile.close()

    # Remove deprecated vars for session
    path = f"{path_folder}{os.sep}core{os.sep}config{os.sep}session.config"
    if not os.path.exists(path):
        tools_log.log_warning(f"File not found: {path}")
        return

    session_parser.read(path)
    vars = get_config_parser('system', 'deprecated_vars_session', "project", "giswater")
    if vars is not None:
        for var in vars.split(','):
            section = var.split('.')[0].strip()
            if not session_parser.has_section(section):
                continue
            option = var.split('.')[1].strip()
            if option.startswith('_'):
                for proj in project_types:
                    session_parser.remove_option(section, f"{proj}{option}")
            else:
                session_parser.remove_option(section, option)

    with open(path, 'w') as configfile:
        session_parser.write(configfile)
        configfile.close()


def hide_widgets_form(dialog, dlg_name):

    row = get_config_value(parameter=f'qgis_form_{dlg_name}_hidewidgets', columns='value::text', table='config_param_system')
    if row:
        widget_list = dialog.findChildren(QWidget)
        for widget in widget_list:
            if widget.objectName() and f'"{widget.objectName()}"' in row[0]:
                lbl_widget = dialog.findChild(QLabel, f"lbl_{widget.objectName()}")
                if lbl_widget:
                    lbl_widget.setVisible(False)
                widget.setVisible(False)


def get_project_version(schemaname=None):
    """ Get project version from table 'sys_version' """

    if schemaname in (None, 'null', ''):
        schemaname = global_vars.schema_name

    project_version = None
    tablename = "sys_version"
    exists = tools_db.check_table(tablename, schemaname)
    if not exists:
        tools_qgis.show_warning(f"Table not found: '{tablename}'")
        return None

    sql = f"SELECT giswater FROM {schemaname}.{tablename} ORDER BY id DESC LIMIT 1"
    row = tools_db.get_row(sql)
    if row:
        project_version = row[0]

    return project_version


def export_layers_to_gpkg(layers, path):
    """ This function is not used on Giswater Project at the moment. """

    uri = tools_db.get_uri()
    schema_name = global_vars.dao_db_credentials['schema'].replace('"', '')
    is_first = True
    options = QgsVectorFileWriter.SaveVectorOptions()
    options.driverName = "GPKG"

    for layer in layers:

        uri.setDataSource(schema_name, f"{layer['name']}", "the_geom", None, f"{layer['id']}")
        vlayer = QgsVectorLayer(uri.uri(), f"{layer['name']}", 'postgres')

        if is_first:
            options.layerName = vlayer.name()
            QgsVectorFileWriter.writeAsVectorFormatV2(vlayer, path, QgsCoordinateTransformContext(), options)
            is_first = False
        else:
            # switch mode to append layer instead of overwriting the file
            options.actionOnExistingFile = QgsVectorFileWriter.CreateOrOverwriteLayer
            options.layerName = vlayer.name()
            QgsVectorFileWriter.writeAsVectorFormatV2(vlayer, path, QgsCoordinateTransformContext(), options)


# region compatibility QGIS version functions

def set_snapping_type(layer_settings, value):

    if Qgis.QGIS_VERSION_INT < 31200:
        layer_settings.setType(value)
    elif Qgis.QGIS_VERSION_INT >= 31200:
        layer_settings.setTypeFlag(value)


def get_segment_flag(default_value):

    if Qgis.QGIS_VERSION_INT >= 32600:
        segment_flag = Qgis.SnappingType.Segment
    elif Qgis.QGIS_VERSION_INT >= 31200:
        segment_flag = QgsSnappingConfig.SnappingTypes.SegmentFlag
    else:
        segment_flag = default_value

    return segment_flag


def get_vertex_flag(default_value):

    if Qgis.QGIS_VERSION_INT >= 32600:
        vertex_flag = Qgis.SnappingType.Vertex
    elif Qgis.QGIS_VERSION_INT >= 31200:
        vertex_flag = QgsSnappingConfig.SnappingTypes.VertexFlag
    else:
        vertex_flag = default_value

    return vertex_flag


def get_sysversion_addparam():
    """ Gets addparam field from table sys_version """
    sql = f"SELECT addparam FROM sys_version ORDER BY id DESC limit 1"
    row = tools_db.get_row(sql, is_admin=True)

    if row:
        return row[0]

    return None


def create_giswater_menu(project_loaded=False):
    """ Create Giswater menu """
    if global_vars.load_project_menu is None:
        global_vars.load_project_menu = GwMenuLoad()
    global_vars.load_project_menu.read_menu(project_loaded)


def unset_giswater_menu():
    """ Unset Giswater menu (when plugin is disabled or reloaded) """

    menu_giswater = global_vars.iface.mainWindow().menuBar().findChild(QMenu, "Giswater")
    if menu_giswater not in (None, "None"):
        menu_giswater.clear()  # I think it's good to clear the menu before deleting it, just in case
        menu_giswater.deleteLater()
        global_vars.load_project_menu = None

# endregion


# region private functions

def _insert_feature_psector(dialog, feature_type, ids=None):
    """ Insert features_id to table plan_@feature_type_x_psector """

    value = tools_qt.get_text(dialog, dialog.psector_id)
    for i in range(len(ids)):
        sql = f"INSERT INTO plan_psector_x_{feature_type} ({feature_type}_id, psector_id) "
        sql += f"VALUES('{ids[i]}', '{value}') ON CONFLICT DO NOTHING;"
        tools_db.execute_sql(sql)
        load_tableview_psector(dialog, feature_type)


def _delete_feature_psector(dialog, feature_type, list_id):
    """ Delete features_id to table plan_@feature_type_x_psector"""

    value = tools_qt.get_text(dialog, dialog.psector_id)
    sql = (f"DELETE FROM plan_psector_x_{feature_type} "
           f"WHERE {feature_type}_id IN ({list_id}) AND psector_id = '{value}'")
    tools_db.execute_sql(sql)


def _check_user_params(section, parameter, file_name, prefix=False):
    """ Check if a parameter exists in the config/user_params.config
        If it doesn't exist, it creates it and assigns 'None' as a default value
    """

    if section == "i18n_generator" or parameter == "dev_commit":
        return

    # Check if the parameter needs the prefix or not
    if prefix and global_vars.project_type is not None:
        parameter = f"_{parameter}"

    # Get the value of the parameter (the one get_config_parser is looking for) in the inventory
    check_value = get_config_parser(f"{file_name}.{section}", parameter, "project", "user_params", False,
                                    get_comment=True, chk_user_params=False)
    # If it doesn't exist in the inventory, add it with "None" as value
    if check_value is None:
        set_config_parser(f"{file_name}.{section}", parameter, None, "project", "user_params", prefix=False,
                          chk_user_params=False)
    else:
        return check_value


def _get_parser_from_filename(filename):
    """ Get parser of file @filename.config """

    if filename in ('init', 'session'):
        folder = f"{global_vars.user_folder_dir}{os.sep}core"
    elif filename in ('dev', 'giswater', 'user_params'):
        folder = global_vars.plugin_dir
    else:
        return None, None

    parser = configparser.ConfigParser(comment_prefixes=";", allow_no_value=True)
    filepath = f"{folder}{os.sep}config{os.sep}{filename}.config"
    if not os.path.exists(filepath):
        tools_log.log_warning(f"File not found: {filepath}")
        return filepath, None

    if not parser.read(filepath):
        tools_log.log_warning(f"Error parsing file: {filepath}")
        return filepath, None

    return filepath, parser

# endregion
