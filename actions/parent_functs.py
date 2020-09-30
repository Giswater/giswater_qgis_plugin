"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsCategorizedSymbolRenderer, QgsExpression, QgsFeatureRequest, QgsGeometry, QgsPointLocator, \
    QgsPointXY, QgsProject, QgsRectangle, QgsRendererCategory, QgsSimpleFillSymbolLayer, QgsSnappingConfig, QgsSymbol, \
    QgsVectorLayer
from qgis.gui import QgsRubberBand
from qgis.PyQt.QtCore import Qt, QDate, QStringListModel, QTimer
from qgis.PyQt.QtWidgets import QGroupBox, QAbstractItemView, QTableView, QFileDialog, QApplication, QCompleter, \
    QAction, QWidget, QComboBox, QCheckBox, QPushButton, QLineEdit, QDoubleSpinBox, QTextEdit
from qgis.PyQt.QtGui import QIcon, QColor, QCursor, QPixmap
from qgis.PyQt.QtSql import QSqlTableModel, QSqlQueryModel

import random
import configparser
import os
import re
import subprocess
import sys
import webbrowser

from functools import partial

from .. import global_vars
from lib import qt_tools
from ..core.utils.giswater_tools import close_dialog, open_dialog
from ..core.utils.layer_tools import populate_vlayer, categoryze_layer, create_qml, from_postgres_to_toc
from ..lib.qgis_tools import snap_to_layer, set_snapping_mode, get_snapping_options
from ..ui_manager import DialogTextUi


def open_web_browser(dialog, widget=None):
    """ Display url using the default browser """

    if widget is not None:
        url = qt_tools.getWidgetText(dialog, widget)
        if url == 'null':
            url = 'http://www.giswater.org'
    else:
        url = 'http://www.giswater.org'

    webbrowser.open(url)


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


def get_file_dialog(dialog, widget):
    """ Get file dialog """

    # Check if selected file exists. Set default value if necessary
    file_path = qt_tools.getWidgetText(dialog, widget)
    if file_path is None or file_path == 'null' or not os.path.exists(str(file_path)):
        folder_path = global_vars.plugin_dir
    else:
        folder_path = os.path.dirname(file_path)

    # Open dialog to select file
    os.chdir(folder_path)
    file_dialog = QFileDialog()
    file_dialog.setFileMode(QFileDialog.AnyFile)
    message = "Select file"
    files_path, filter_ = file_dialog.getOpenFileNames(parent=None, caption=global_vars.controller.tr(message))

    file_text = ""
    for file in files_path:
        file_text += f"{file}\n\n"
    if files_path:
        qt_tools.setWidgetText(dialog, widget, str(file_text))
    return files_path



def get_folder_dialog(dialog, widget):
    """ Get folder dialog """

    # Check if selected folder exists. Set default value if necessary
    folder_path = qt_tools.getWidgetText(dialog, widget)
    if folder_path is None or folder_path == 'null' or not os.path.exists(folder_path):
        folder_path = os.path.expanduser("~")

    # Open dialog to select folder
    os.chdir(folder_path)
    file_dialog = QFileDialog()
    file_dialog.setFileMode(QFileDialog.Directory)
    message = "Select folder"
    folder_path = file_dialog.getExistingDirectory(
        parent=None, caption=global_vars.controller.tr(message), directory=folder_path)
    if folder_path:
        qt_tools.setWidgetText(dialog, widget, str(folder_path))


def multi_row_selector(dialog, tableleft, tableright, field_id_left, field_id_right, name='name',
                       hide_left=[0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22,
                                  23, 24, 25, 26, 27, 28, 29, 30], hide_right=[1, 2, 3], aql=""):
    """
    :param dialog:
    :param tableleft: Table to consult and load on the left side
    :param tableright: Table to consult and load on the right side
    :param field_id_left: ID field of the left table
    :param field_id_right: ID field of the right table
    :param name: field name (used in add_lot.py)
    :param hide_left: Columns to hide from the left table
    :param hide_right: Columns to hide from the right table
    :param aql: (add query left) Query added to the left side (used in basic.py def basic_exploitation_selector())
    :return:
    """

    # fill QTableView all_rows
    tbl_all_rows = dialog.findChild(QTableView, "all_rows")
    tbl_all_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
    schema_name = global_vars.schema_name.replace('"', '')
    query_left = f"SELECT * FROM {schema_name}.{tableleft} WHERE {name} NOT IN "
    query_left += f"(SELECT {schema_name}.{tableleft}.{name} FROM {schema_name}.{tableleft}"
    query_left += f" RIGHT JOIN {schema_name}.{tableright} ON {tableleft}.{field_id_left} = {tableright}.{field_id_right}"
    query_left += f" WHERE cur_user = current_user)"
    query_left += f" AND  {field_id_left} > -1"
    query_left += aql

    fill_table_by_query(tbl_all_rows, query_left + f" ORDER BY {name};")
    hide_colums(tbl_all_rows, hide_left)
    tbl_all_rows.setColumnWidth(1, 200)

    # fill QTableView selected_rows
    tbl_selected_rows = dialog.findChild(QTableView, "selected_rows")
    tbl_selected_rows.setSelectionBehavior(QAbstractItemView.SelectRows)

    query_right = f"SELECT {tableleft}.{name}, cur_user, {tableleft}.{field_id_left}, {tableright}.{field_id_right}"
    query_right += f" FROM {schema_name}.{tableleft}"
    query_right += f" JOIN {schema_name}.{tableright} ON {tableleft}.{field_id_left} = {tableright}.{field_id_right}"

    query_right += " WHERE cur_user = current_user"

    fill_table_by_query(tbl_selected_rows, query_right + f" ORDER BY {name};")
    hide_colums(tbl_selected_rows, hide_right)
    tbl_selected_rows.setColumnWidth(0, 200)

    # Button select
    dialog.btn_select.clicked.connect(partial(multi_rows_selector, tbl_all_rows, tbl_selected_rows,
                                              field_id_left, tableright, field_id_right, query_left, query_right, field_id_right))

    # Button unselect
    query_delete = f"DELETE FROM {schema_name}.{tableright}"
    query_delete += f" WHERE current_user = cur_user AND {tableright}.{field_id_right}="
    dialog.btn_unselect.clicked.connect(partial(unselector, tbl_all_rows, tbl_selected_rows, query_delete,
                                                query_left, query_right, field_id_right))

    # QLineEdit
    dialog.txt_name.textChanged.connect(partial(query_like_widget_text, dialog, dialog.txt_name,
                                                tbl_all_rows, tableleft, tableright, field_id_right, field_id_left, name, aql))

    # Order control
    tbl_all_rows.horizontalHeader().sectionClicked.connect(partial(order_by_column, tbl_all_rows, query_left))
    tbl_selected_rows.horizontalHeader().sectionClicked.connect(
        partial(order_by_column, tbl_selected_rows, query_right))


def order_by_column(qtable, query, idx):
    """
    :param qtable: QTableView widget
    :param query: Query for populate QsqlQueryModel
    :param idx: The index of the clicked column
    :return:
    """
    oder_by = {0: "ASC", 1: "DESC"}
    sort_order = qtable.horizontalHeader().sortIndicatorOrder()
    col_to_sort = qtable.model().headerData(idx, Qt.Horizontal)
    query += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
    fill_table_by_query(qtable, query)
    refresh_map_canvas()


def hide_colums(widget, comuns_to_hide):
    for i in range(0, len(comuns_to_hide)):
        widget.hideColumn(comuns_to_hide[i])


def unselector(qtable_left, qtable_right, query_delete, query_left, query_right, field_id_right):

    selected_list = qtable_right.selectionModel().selectedRows()
    if len(selected_list) == 0:
        message = "Any record selected"
        global_vars.controller.show_warning(message)
        return
    expl_id = []
    for i in range(0, len(selected_list)):
        row = selected_list[i].row()
        id_ = str(qtable_right.model().record(row).value(field_id_right))
        expl_id.append(id_)
    for i in range(0, len(expl_id)):
        global_vars.controller.execute_sql(query_delete + str(expl_id[i]))

    # Refresh
    oder_by = {0: "ASC", 1: "DESC"}
    sort_order = qtable_left.horizontalHeader().sortIndicatorOrder()
    idx = qtable_left.horizontalHeader().sortIndicatorSection()
    col_to_sort = qtable_left.model().headerData(idx, Qt.Horizontal)
    query_left += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
    fill_table_by_query(qtable_left, query_left)

    sort_order = qtable_right.horizontalHeader().sortIndicatorOrder()
    idx = qtable_right.horizontalHeader().sortIndicatorSection()
    col_to_sort = qtable_right.model().headerData(idx, Qt.Horizontal)
    query_right += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
    fill_table_by_query(qtable_right, query_right)
    refresh_map_canvas()


def multi_rows_selector(qtable_left, qtable_right, id_ori,
                        tablename_des, id_des, query_left, query_right, field_id):
    """
        :param qtable_left: QTableView origin
        :param qtable_right: QTableView destini
        :param id_ori: Refers to the id of the source table
        :param tablename_des: table destini
        :param id_des: Refers to the id of the target table, on which the query will be made
        :param query_right:
        :param query_left:
        :param field_id:
    """

    selected_list = qtable_left.selectionModel().selectedRows()

    if len(selected_list) == 0:
        message = "Any record selected"
        global_vars.controller.show_warning(message)
        return
    expl_id = []
    curuser_list = []
    for i in range(0, len(selected_list)):
        row = selected_list[i].row()
        id_ = qtable_left.model().record(row).value(id_ori)
        expl_id.append(id_)
        curuser = qtable_left.model().record(row).value("cur_user")
        curuser_list.append(curuser)
    for i in range(0, len(expl_id)):
        # Check if expl_id already exists in expl_selector
        sql = (f"SELECT DISTINCT({id_des}, cur_user)"
               f" FROM {tablename_des}"
               f" WHERE {id_des} = '{expl_id[i]}' AND cur_user = current_user")
        row = global_vars.controller.get_row(sql)

        if row:
            # if exist - show warning
            message = "Id already selected"
            global_vars.controller.show_info_box(message, "Info", parameter=str(expl_id[i]))
        else:
            sql = (f"INSERT INTO {tablename_des} ({field_id}, cur_user) "
                   f" VALUES ({expl_id[i]}, current_user)")
            global_vars.controller.execute_sql(sql)

    # Refresh
    oder_by = {0: "ASC", 1: "DESC"}
    sort_order = qtable_left.horizontalHeader().sortIndicatorOrder()
    idx = qtable_left.horizontalHeader().sortIndicatorSection()
    col_to_sort = qtable_left.model().headerData(idx, Qt.Horizontal)
    query_left += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
    fill_table_by_query(qtable_right, query_right)

    sort_order = qtable_right.horizontalHeader().sortIndicatorOrder()
    idx = qtable_right.horizontalHeader().sortIndicatorSection()
    col_to_sort = qtable_right.model().headerData(idx, Qt.Horizontal)
    query_right += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
    fill_table_by_query(qtable_left, query_left)
    refresh_map_canvas()


def fill_table(widget, table_name, set_edit_strategy=QSqlTableModel.OnManualSubmit, expr_filter=None):
    """ Set a model with selected filter.
    Attach that model to selected table """

    if global_vars.schema_name not in table_name:
        table_name = global_vars.schema_name + "." + table_name

    # Set model
    model = QSqlTableModel()
    model.setTable(table_name)
    model.setEditStrategy(set_edit_strategy)
    model.setSort(0, 0)
    model.select()

    # Check for errors
    if model.lastError().isValid():
        global_vars.controller.show_warning(model.lastError().text())

    # Attach model to table view
    widget.setModel(model)
    if expr_filter:
        widget.model().setFilter(expr_filter)


def fill_table_by_query(qtable, query):
    """
    :param qtable: QTableView to show
    :param query: query to set model
    """

    model = QSqlQueryModel()
    model.setQuery(query)
    qtable.setModel(model)
    qtable.show()

    # Check for errors
    if model.lastError().isValid():
        global_vars.controller.show_warning(model.lastError().text())


def query_like_widget_text(dialog, text_line, qtable, tableleft, tableright, field_id_r, field_id_l,
                           name='name', aql=''):
    """ Fill the QTableView by filtering through the QLineEdit"""

    schema_name = global_vars.schema_name.replace('"', '')
    query = qt_tools.getWidgetText(dialog, text_line, return_string_null=False).lower()
    sql = (f"SELECT * FROM {schema_name}.{tableleft} WHERE {name} NOT IN "
           f"(SELECT {tableleft}.{name} FROM {schema_name}.{tableleft}"
           f" RIGHT JOIN {schema_name}.{tableright}"
           f" ON {tableleft}.{field_id_l} = {tableright}.{field_id_r}"
           f" WHERE cur_user = current_user) AND LOWER({name}::text) LIKE '%{query}%'"
           f"  AND  {field_id_l} > -1")
    sql += aql
    fill_table_by_query(qtable, sql)


def set_icon(widget, icon):
    """ Set @icon to selected @widget """

    # Get icons folder
    icons_folder = os.path.join(global_vars.plugin_dir, 'icons')
    icon_path = os.path.join(icons_folder, str(icon) + ".png")
    if os.path.exists(icon_path):
        widget.setIcon(QIcon(icon_path))
    else:
        global_vars.controller.log_info("File not found", parameter=icon_path)


def check_expression(expr_filter, log_info=False):
    """ Check if expression filter @expr_filter is valid """

    if log_info:
        global_vars.controller.log_info(expr_filter)
    expr = QgsExpression(expr_filter)
    if expr.hasParserError():
        message = "Expression Error"
        global_vars.controller.log_warning(message, parameter=expr_filter)
        return False, expr

    return True, expr


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
    path_cursor = os.path.join(path_folder, 'icons', '201.png')
    if os.path.exists(path_cursor):
        cursor = QCursor(QPixmap(path_cursor))
    else:
        cursor = QCursor(Qt.ArrowCursor)

    return cursor


def set_table_columns(dialog, widget, table_name, sort_order=0, isQStandardItemModel=False, schema_name=None):
    """ Configuration of tables. Set visibility and width of columns """

    widget = qt_tools.getWidget(dialog, widget)
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
        widget.model().sort(sort_order, Qt.AscendingOrder)
    else:
        widget.model().setSort(sort_order, Qt.AscendingOrder)
        widget.model().select()
    # Delete columns
    for column in columns_to_delete:
        widget.hideColumn(column)

    return widget


def disconnect_signal_selection_changed():
    """ Disconnect signal selectionChanged """

    try:
        global_vars.canvas.selectionChanged.disconnect()
    except Exception:
        pass
    finally:
        global_vars.iface.actionPan().trigger()


def set_label_current_psector(dialog):

    sql = ("SELECT t1.name FROM plan_psector AS t1 "
           " INNER JOIN config_param_user AS t2 ON t1.psector_id::text = t2.value "
           " WHERE t2.parameter='plan_psector_vdefault' AND cur_user = current_user")
    row = global_vars.controller.get_row(sql)
    if not row:
        return
    qt_tools.setWidgetText(dialog, 'lbl_vdefault_psector', row[0])


def multi_rows_delete(widget, table_name, column_id):
    """ Delete selected elements of the table
    :param QTableView widget: origin
    :param table_name: table origin
    :param column_id: Refers to the id of the source table
    """

    # Get selected rows
    selected_list = widget.selectionModel().selectedRows()
    if len(selected_list) == 0:
        message = "Any record selected"
        global_vars.controller.show_warning(message)
        return

    inf_text = ""
    list_id = ""
    for i in range(0, len(selected_list)):
        row = selected_list[i].row()
        id_ = widget.model().record(row).value(str(column_id))
        inf_text += f"{id_}, "
        list_id += f"'{id_}', "
    inf_text = inf_text[:-2]
    list_id = list_id[:-2]
    message = "Are you sure you want to delete these records?"
    title = "Delete records"
    answer = global_vars.controller.ask_question(message, title, inf_text)
    if answer:
        sql = f"DELETE FROM {table_name}"
        sql += f" WHERE {column_id} IN ({list_id})"
        global_vars.controller.execute_sql(sql)
        widget.model().select()


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


def hide_void_groupbox(dialog):
    """ Hide empty groupbox """

    grb_list = {}
    grbox_list = dialog.findChildren(QGroupBox)
    for grbox in grbox_list:

        widget_list = grbox.findChildren(QWidget)
        if len(widget_list) == 0:
            grb_list[grbox.objectName()] = 0
            grbox.setVisible(False)

    return grb_list


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


def make_list_for_completer(sql):
    """ Prepare a list with the necessary items for the completer
    :param sql: Query to be executed, where will we get the list of items (string)
    :return list_items: List with the result of the query executed (List) ["item1","item2","..."]
    """

    rows = global_vars.controller.get_rows(sql)
    list_items = []
    if rows:
        for row in rows:
            list_items.append(str(row[0]))
    return list_items


def set_completer_lineedit(qlineedit, list_items):
    """ Set a completer into a QLineEdit
    :param qlineedit: Object where to set the completer (QLineEdit)
    :param list_items: List of items to set into the completer (List)["item1","item2","..."]
    """

    completer = QCompleter()
    completer.setCaseSensitivity(Qt.CaseInsensitive)
    completer.setMaxVisibleItems(10)
    completer.setCompletionMode(0)
    completer.setFilterMode(Qt.MatchContains)
    completer.popup().setStyleSheet("color: black;")
    qlineedit.setCompleter(completer)
    model = QStringListModel()
    model.setStringList(list_items)
    completer.setModel(model)


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


def create_action(action_name, action_group, icon_num=None, text=None):
    """ Creates a new action with selected parameters """

    icon = None
    icon_folder = global_vars.plugin_dir + '/icons/'
    icon_path = icon_folder + icon_num + '.png'
    if os.path.exists(icon_path):
        icon = QIcon(icon_path)

    if icon is None:
        action = QAction(text, action_group)
    else:
        action = QAction(icon, text, action_group)
    action.setObjectName(action_name)

    return action


def set_wait_cursor():
    QApplication.instance().setOverrideCursor(Qt.WaitCursor)


def set_arrow_cursor():
    QApplication.instance().setOverrideCursor(Qt.ArrowCursor)


def delete_layer_from_toc(layer_name):
    """ Delete layer from toc if exist """

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


def set_restriction(dialog, widget_to_ignore, restriction):
    """
    Set all widget enabled(False) or readOnly(True) except those on the tuple
    :param dialog:
    :param widget_to_ignore: tuple = ('widgetname1', 'widgetname2', 'widgetname3', ...)
    :param restriction: roles that do not have access. tuple = ('role1', 'role1', 'role1', ...)
    :return:
    """

    project_vars = global_vars.project_vars
    role = project_vars['role']
    role = global_vars.controller.get_restriction(role)
    if role in restriction:
        widget_list = dialog.findChildren(QWidget)
        for widget in widget_list:
            if widget.objectName() in widget_to_ignore:
                continue
            # Set editable/readonly
            if type(widget) in (QLineEdit, QDoubleSpinBox, QTextEdit):
                widget.setReadOnly(True)
                widget.setStyleSheet("QWidget {background: rgb(242, 242, 242);color: rgb(100, 100, 100)}")
            elif type(widget) in (QComboBox, QCheckBox, QTableView, QPushButton):
                widget.setEnabled(False)


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


def get_values_from_catalog(table_name, typevalue, order_by='id'):

    sql = (f"SELECT id, idval"
           f" FROM {table_name}"
           f" WHERE typevalue = '{typevalue}'"
           f" ORDER BY {order_by}")
    rows = global_vars.controller.get_rows(sql)
    return rows


def integer_validator(value, widget, btn_accept):
    """ Check if the value is an integer or not.
        This function is called in def set_datatype_validator(self, value, widget, btn)
        widget = getattr(self, f"{widget.property('datatype')}_validator")( value, widget, btn)
    """

    if value is None or bool(re.search("^\d*$", value)):
        widget.setStyleSheet(None)
        btn_accept.setEnabled(True)
    else:
        widget.setStyleSheet("border: 1px solid red")
        btn_accept.setEnabled(False)


def double_validator(value, widget, btn_accept):
    """ Check if the value is double or not.
        This function is called in def set_datatype_validator(self, value, widget, btn)
        widget = getattr(self, f"{widget.property('datatype')}_validator")( value, widget, btn)
    """

    if value is None or bool(re.search("^\d*$", value)) or bool(re.search("^\d+\.\d+$", value)):
        widget.setStyleSheet(None)
        btn_accept.setEnabled(True)
    else:
        widget.setStyleSheet("border: 1px solid red")
        btn_accept.setEnabled(False)


def open_file_path(filter_="All (*.*)"):
    """ Open QFileDialog """
    msg = global_vars.controller.tr("Select DXF file")
    path, filter_ = QFileDialog.getOpenFileName(None, msg, "", filter_)

    return path, filter_


def show_exceptions_msg(title, msg=""):

    dlg_info = DialogTextUi()
    dlg_info.btn_accept.setVisible(False)
    dlg_info.btn_close.clicked.connect(partial(close_dialog, dlg_info))
    dlg_info.setWindowTitle(title)
    qt_tools.setWidgetText(dlg_info, dlg_info.txt_infolog, msg)
    open_dialog(dlg_info, dlg_name='dialog_text')


def put_combobox(qtable, rows, field, widget_pos, combo_values):
    """ Set one column of a QtableView as QComboBox with values from database.
    :param qtable: QTableView to fill
    :param rows: List of items to set QComboBox (["..", "..."])
    :param field: Field to set QComboBox (String)
    :param widget_pos: Position of the column where we want to put the QComboBox (integer)
    :param combo_values: List of items to populate QComboBox (["..", "..."])
    :return:
    """

    for x in range(0, len(rows)):
        combo = QComboBox()
        row = rows[x]
        # Populate QComboBox
        qt_tools.set_item_data(combo, combo_values, 1)
        # Set QCombobox to wanted item
        qt_tools.set_combo_itemData(combo, str(row[field]), 1)
        # Get index and put QComboBox into QTableView at index position
        idx = qtable.model().index(x, widget_pos)
        qtable.setIndexWidget(idx, combo)
        # noinspection PyUnresolvedReferences
        combo.currentIndexChanged.connect(partial(update_status, combo, qtable, x, widget_pos))


def update_status(combo, qtable, pos_x, widget_pos):
    """ Update values from QComboBox to QTableView
    :param combo: QComboBox from which we will take the value
    :param qtable: QTableView Where update values
    :param pos_x: Position of the row where we want to update value (integer)
    :param widget_pos:Position of the widget where we want to update value (integer)
    :return:
    """

    elem = combo.itemData(combo.currentIndex())
    i = qtable.model().index(pos_x, widget_pos)
    qtable.model().setData(i, elem[0])
    i = qtable.model().index(pos_x, widget_pos + 1)
    qtable.model().setData(i, elem[1])


def get_feature_by_id(layer, id_, field_id):

    expr = "" + str(field_id) + "= '" + str(id_) + "'"
    features = layer.getFeatures(QgsFeatureRequest().setFilterExpression(expr))
    for feature in features:
        if str(feature[field_id]) == str(id_):
            return feature
    return False


def document_insert(dialog, tablename, field, field_value):
    """ Insert a document related to the current visit
    :param dialog: (QDialog )
    :param tablename: Name of the table to make the queries (string)
    :param field: Field of the table to make the where clause (string)
    :param field_value: Value to compare in the clause where (string)
    """

    doc_id = dialog.doc_id.text()
    if not doc_id:
        message = "You need to insert doc_id"
        global_vars.controller.show_warning(message)
        return

    # Check if document already exist
    sql = (f"SELECT doc_id"
           f" FROM {tablename}"
           f" WHERE doc_id = '{doc_id}' AND {field} = '{field_value}'")
    row = global_vars.controller.get_row(sql)
    if row:
        msg = "Document already exist"
        global_vars.controller.show_warning(msg)
        return

    # Insert into new table
    sql = (f"INSERT INTO {tablename} (doc_id, {field})"
           f" VALUES ('{doc_id}', '{field_value}')")
    status = global_vars.controller.execute_sql(sql)
    if status:
        message = "Document inserted successfully"
        global_vars.controller.show_info(message)

    dialog.tbl_document.model().select()


def document_open(qtable):
    """ Open selected document """

    # Get selected rows
    field_index = qtable.model().fieldIndex('path')
    selected_list = qtable.selectionModel().selectedRows(field_index)
    if not selected_list:
        message = "Any record selected"
        global_vars.controller.show_info_box(message)
        return
    elif len(selected_list) > 1:
        message = "More then one document selected. Select just one document."
        global_vars.controller.show_warning(message)
        return

    path = selected_list[0].data()
    # Check if file exist
    if os.path.exists(path):
        # Open the document
        if sys.platform == "win32":
            os.startfile(path)
        else:
            opener = "open" if sys.platform == "darwin" else "xdg-open"
            subprocess.call([opener, path])
    else:
        webbrowser.open(path)


def document_delete(qtable, tablename):
    """ Delete record from selected rows in tbl_document """

    # Get selected rows. 0 is the column of the pk 0 'id'
    selected_list = qtable.selectionModel().selectedRows(0)
    if len(selected_list) == 0:
        message = "Any record selected"
        global_vars.controller.show_info_box(message)
        return

    selected_id = []
    for index in selected_list:
        doc_id = index.data()
        selected_id.append(str(doc_id))
    message = "Are you sure you want to delete these records?"
    title = "Delete records"
    answer = global_vars.controller.ask_question(message, title, ','.join(selected_id))
    if answer:
        sql = (f"DELETE FROM {tablename}"
               f" WHERE id IN ({','.join(selected_id)})")
        status = global_vars.controller.execute_sql(sql)
        if not status:
            message = "Error deleting data"
            global_vars.controller.show_warning(message)
            return
        else:
            message = "Document deleted"
            global_vars.controller.show_info(message)
            qtable.model().select()


def get_all_actions():

    actions_list = global_vars.iface.mainWindow().findChildren(QAction)
    for action in actions_list:
        global_vars.controller.log_info(str(action.objectName()))
        action.triggered.connect(partial(show_action_name, action))


def show_action_name(action):
    global_vars.controller.log_info(str(action.objectName()))


def get_points(list_coord=None):
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


def draw(complet_result, rubber_band, margin=None, reset_rb=True, color=QColor(255, 0, 0, 100), width=3):

    try:
        if complet_result['body']['feature']['geometry'] is None:
            return
        if complet_result['body']['feature']['geometry']['st_astext'] is None:
            return
    except KeyError:
        return

    list_coord = re.search('\((.*)\)', str(complet_result['body']['feature']['geometry']['st_astext']))
    max_x, max_y, min_x, min_y = get_max_rectangle_from_coords(list_coord)

    if reset_rb:
        rubber_band.reset()
    if str(max_x) == str(min_x) and str(max_y) == str(min_y):
        point = QgsPointXY(float(max_x), float(max_y))
        draw_point(point, rubber_band, color, width)
    else:
        points = get_points(list_coord)
        draw_polyline(points, rubber_band, color, width)
    if margin is not None:
        zoom_to_rectangle(max_x, max_y, min_x, min_y, margin)


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


def hilight_feature_by_id(qtable, layer_name, field_id, rubber_band, width, index):
    """ Based on the received index and field_id, the id of the received field_id is searched within the table
     and is painted in red on the canvas """

    rubber_band.reset()
    layer = global_vars.controller.get_layer_by_tablename(layer_name)
    if not layer: return

    row = index.row()
    column_index = qt_tools.get_col_index_by_col_name(qtable, field_id)
    _id = index.sibling(row, column_index).data()
    feature = get_feature_by_id(layer, _id, field_id)
    try:
        geometry = feature.geometry()
        rubber_band.setToGeometry(geometry, None)
        rubber_band.setColor(QColor(255, 0, 0, 100))
        rubber_band.setWidth(width)
        rubber_band.show()
    except AttributeError:
        pass


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


def resetRubberbands(rubber_band):

    rubber_band.reset()


def restore_user_layer(user_current_layer=None):

    if user_current_layer:
        global_vars.iface.setActiveLayer(user_current_layer)
    else:
        layer = global_vars.controller.get_layer_by_tablename('v_edit_node')
        if layer:
            global_vars.iface.setActiveLayer(layer)



def set_style_mapzones():

    extras = f'"mapzones":""'
    body = create_body(extras=extras)
    json_return = global_vars.controller.get_json('gw_fct_getstylemapzones', body)
    if not json_return:
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
            draw(json_result, rubber_band, margin, color=color, width=width)

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

                    delete_layer_from_toc(layer_name)

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
                        categoryze_layer(v_layer, cat_field, size, color_values)

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
                        style = global_vars.controller.get_json('gw_fct_getstyle', body)
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
                    set_margin(v_layer, margin)

    except Exception as e:
        global_vars.controller.manage_exception(None, f"{type(e).__name__}: {e}", sql)


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
                layer = global_vars.controller.get_layer_by_tablename(layer_name)
                if layer is None:
                    the_geom = lyr[layer_name]['geom_field']
                    field_id = lyr[layer_name]['pkey_field']
                    if lyr[layer_name]['group_layer'] is not None:
                        group = lyr[layer_name]['group_layer']
                    else:
                        group = "GW Layers"
                    style_id = lyr[layer_name]['style_id']
                    from_postgres_to_toc(layer_name, the_geom, field_id, group=group, style_id=style_id)
                global_vars.controller.set_layer_visible(layer)

        # force reload dataProvider in order to reindex.
        if 'index' in layermanager:
            for lyr in layermanager['index']:
                layer_name = [key for key in lyr][0]
                layer = global_vars.controller.get_layer_by_tablename(layer_name)
                if layer:
                    global_vars.controller.set_layer_index(layer)

        # Set active
        if 'active' in layermanager:
            layer = global_vars.controller.get_layer_by_tablename(layermanager['active'])
            if layer:
                global_vars.iface.setActiveLayer(layer)

        # Set zoom to extent with a margin
        if 'zoom' in layermanager:
            layer = global_vars.controller.get_layer_by_tablename(layermanager['zoom']['layer'])
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
            for layer_name in layermanager['snnaping']:
                layer = global_vars.controller.get_layer_by_tablename(layer_name)
                if layer:
                    QgsProject.instance().blockSignals(True)
                    layer_settings = snap_to_layer(layer, QgsPointLocator.All, True)
                    if layer_settings:
                        layer_settings.setType(2)
                        layer_settings.setTolerance(15)
                        layer_settings.setEnabled(True)
                    else:
                        layer_settings = QgsSnappingConfig.IndividualLayerSettings(True, 2, 15, 1)
                    snapping_config = get_snapping_options()
                    snapping_config.setIndividualLayerSettings(layer, layer_settings)
                    QgsProject.instance().blockSignals(False)
                    QgsProject.instance().snappingConfigChanged.emit(
                        snapping_config)
            set_snapping_mode()


    except Exception as e:
        global_vars.controller.manage_exception(None, f"{type(e).__name__}: {e}", sql)


def set_margin(layer, margin):

    extent = QgsRectangle()
    extent.setMinimal()
    extent.combineExtentWith(layer.extent())
    xmax = extent.xMaximum() + margin
    xmin = extent.xMinimum() - margin
    ymax = extent.yMaximum() + margin
    ymin = extent.yMinimum() - margin
    extent.set(xmin, ymin, xmax, ymax)
    global_vars.iface.mapCanvas().setExtent(extent)
    global_vars.iface.mapCanvas().refresh()


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

