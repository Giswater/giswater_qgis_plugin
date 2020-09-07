"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsFeatureRequest
from qgis.gui import QgsMapToolEmitPoint, QgsVertexMarker
from qgis.PyQt.QtWidgets import QTableView, QDateEdit, QLineEdit, QTextEdit, QDateTimeEdit, QComboBox, QCompleter, \
    QAbstractItemView
from qgis.PyQt.QtGui import QColor
from qgis.PyQt.QtSql import QSqlTableModel
from qgis.PyQt.QtCore import Qt, QDate, QDateTime, QStringListModel

from functools import partial

from lib import qt_tools
from .. import global_vars
from .parent_functs import check_expression, get_cursor_multiple_selection, set_table_columns, refresh_map_canvas
from ..lib.qgis_tools import snap_to_background_layers, get_event_point, add_marker
from ..core.utils.giswater_tools import close_dialog


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


def reset_model(dialog, table_object, geom_type):
    """ Reset model of the widget """

    table_relation = f"{table_object}_x_{geom_type}"
    widget_name = f"tbl_{table_relation}"
    widget = qt_tools.getWidget(dialog, widget_name)
    if widget:
        widget.setModel(None)


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


def reset_widgets(dialog, table_object):
    """ Clear contents of input widgets """

    if table_object == "doc":
        qt_tools.setWidgetText(dialog, "doc_type", "")
        qt_tools.setWidgetText(dialog, "observ", "")
        qt_tools.setWidgetText(dialog, "path", "")
    elif table_object == "element":
        qt_tools.setWidgetText(dialog, "elementcat_id", "")
        qt_tools.setWidgetText(dialog, "state", "")
        qt_tools.setWidgetText(dialog, "expl_id", "")
        qt_tools.setWidgetText(dialog, "ownercat_id", "")
        qt_tools.setWidgetText(dialog, "location_type", "")
        qt_tools.setWidgetText(dialog, "buildercat_id", "")
        qt_tools.setWidgetText(dialog, "workcat_id", "")
        qt_tools.setWidgetText(dialog, "workcat_id_end", "")
        qt_tools.setWidgetText(dialog, "comment", "")
        qt_tools.setWidgetText(dialog, "observ", "")
        qt_tools.setWidgetText(dialog, "path", "")
        qt_tools.setWidgetText(dialog, "rotation", "")
        qt_tools.setWidgetText(dialog, "verified", "")
        qt_tools.setWidgetText(dialog, dialog.num_elements, "")


def fill_widgets(dialog, table_object, row):
    """ Fill input widgets with data int he @row """

    if table_object == "doc":

        qt_tools.setWidgetText(dialog, "doc_type", row["doc_type"])
        qt_tools.setWidgetText(dialog, "observ", row["observ"])
        qt_tools.setWidgetText(dialog, "path", row["path"])

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

        qt_tools.setWidgetText(dialog, "code", row['code'])
        sql = (f"SELECT elementtype_id FROM cat_element"
               f" WHERE id = '{row['elementcat_id']}'")
        row_type = global_vars.controller.get_row(sql)
        if row_type:
            qt_tools.setWidgetText(dialog, "element_type", row_type[0])

        qt_tools.setWidgetText(dialog, "elementcat_id", row['elementcat_id'])
        qt_tools.setWidgetText(dialog, "num_elements", row['num_elements'])
        qt_tools.setWidgetText(dialog, "state", state)
        qt_tools.set_combo_itemData(dialog.state_type, f"{row['state_type']}", 0)
        qt_tools.setWidgetText(dialog, "expl_id", expl_id)
        qt_tools.setWidgetText(dialog, "ownercat_id", row['ownercat_id'])
        qt_tools.setWidgetText(dialog, "location_type", row['location_type'])
        qt_tools.setWidgetText(dialog, "buildercat_id", row['buildercat_id'])
        qt_tools.setWidgetText(dialog, "builtdate", row['builtdate'])
        qt_tools.setWidgetText(dialog, "workcat_id", row['workcat_id'])
        qt_tools.setWidgetText(dialog, "workcat_id_end", row['workcat_id_end'])
        qt_tools.setWidgetText(dialog, "comment", row['comment'])
        qt_tools.setWidgetText(dialog, "observ", row['observ'])
        qt_tools.setWidgetText(dialog, "link", row['link'])
        qt_tools.setWidgetText(dialog, "verified", row['verified'])
        qt_tools.setWidgetText(dialog, "rotation", row['rotation'])
        if str(row['undelete']) == 'True':
            dialog.undelete.setChecked(True)


def get_records_geom_type(dialog, table_object, geom_type, ids=None, list_ids=None, layers=None):
    """ Get records of @geom_type associated to selected @table_object """

    object_id = qt_tools.getWidgetText(dialog, table_object + "_id")
    table_relation = table_object + "_x_" + geom_type
    widget_name = "tbl_" + table_relation

    exists = global_vars.controller.check_table(table_relation)
    if not exists:
        global_vars.controller.log_info(f"Not found: {table_relation}")
        return ids, layers, list_ids

    sql = (f"SELECT {geom_type}_id "
           f"FROM {table_relation} "
           f"WHERE {table_object}_id = '{object_id}'")
    rows = global_vars.controller.get_rows(sql, log_info=False)
    if rows:
        for row in rows:
            list_ids[geom_type].append(str(row[0]))
            ids.append(str(row[0]))

        expr_filter = get_expr_filter(geom_type, list_ids=list_ids, layers=layers)
        set_table_model(dialog, widget_name, geom_type, expr_filter)

    return ids, layers, list_ids


def exist_object(dialog, table_object, single_tool_mode=None, layers=None, ids=None, list_ids=None):
    """ Check if selected object (document or element) already exists """

    # Reset list of selected records
    reset_lists(ids, list_ids)

    field_object_id = "id"
    if table_object == "element":
        field_object_id = table_object + "_id"
    object_id = qt_tools.getWidgetText(dialog, table_object + "_id")

    # Check if we already have data with selected object_id
    sql = (f"SELECT * "
           f" FROM {table_object}"
           f" WHERE {field_object_id} = '{object_id}'")
    row = global_vars.controller.get_row(sql, log_info=False)

    # If object_id not found: Clear data
    if not row:
        reset_widgets(dialog, table_object)
        if table_object == 'element':
            set_combo(dialog, 'state', 'value_state', 'edit_state_vdefault', field_name='name')
            set_combo(dialog, 'expl_id', 'exploitation', 'edit_exploitation_vdefault',
                      field_id='expl_id', field_name='name')
            set_calendars(dialog, 'builtdate', 'config_param_user', 'value', 'edit_builtdate_vdefault')
            set_combo(dialog, 'workcat_id', 'cat_work',
                      'edit_workcat_vdefault', field_id='id', field_name='id')

        if single_tool_mode is not None:
            layers = remove_selection(single_tool_mode, layers=layers)
        else:
            layers = remove_selection(True, layers=layers)
        reset_model(dialog, table_object, "arc")
        reset_model(dialog, table_object, "node")
        reset_model(dialog, table_object, "connec")
        reset_model(dialog, table_object, "element")
        if global_vars.project_type == 'ud':
            reset_model(dialog, table_object, "gully")

        return layers, ids, list_ids

    # Fill input widgets with data of the @row
    fill_widgets(dialog, table_object, row)

    # Check related 'arcs'
    ids, layers, list_ids = get_records_geom_type(dialog, table_object, "arc", ids=ids, list_ids=list_ids, layers=layers)

    # Check related 'nodes'
    ids, layers, list_ids = get_records_geom_type(dialog, table_object, "node", ids=ids, list_ids=list_ids, layers=layers)

    # Check related 'connecs'
    ids, layers, list_ids = get_records_geom_type(dialog, table_object, "connec", ids=ids, list_ids=list_ids, layers=layers)

    # Check related 'elements'
    ids, layers, list_ids = get_records_geom_type(dialog, table_object, "element", ids=ids, list_ids=list_ids, layers=layers)

    # Check related 'gullys'
    if global_vars.project_type == 'ud':
        ids, layers, list_ids = get_records_geom_type(dialog, table_object, "gully", ids=ids, list_ids=list_ids, layers=layers)

    return layers, ids, list_ids


def populate_combo(dialog, widget, table_name, field_name="id"):
    """ Executes query and fill combo box """

    sql = (f"SELECT {field_name}"
           f" FROM {table_name}"
           f" ORDER BY {field_name}")
    rows = global_vars.controller.get_rows(sql)
    qt_tools.fillComboBox(dialog, widget, rows)
    if rows:
        qt_tools.setCurrentIndex(dialog, widget, 0)


def set_combo(dialog, widget, table_name, parameter, field_id='id', field_name='id'):
    """ Executes query and set combo box """

    sql = (f"SELECT t1.{field_name} FROM {table_name} as t1"
           f" INNER JOIN config_param_user as t2 ON t1.{field_id}::text = t2.value::text"
           f" WHERE parameter = '{parameter}' AND cur_user = current_user")
    row = global_vars.controller.get_row(sql)
    if row:
        qt_tools.setWidgetText(dialog, widget, row[0])


def set_calendars(dialog, widget, table_name, value, parameter):
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
    qt_tools.setCalendarDate(dialog, widget, date)


def add_point(vertex_marker):
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
    global_vars.canvas.xyCoordinates.connect(partial(mouse_move, vertex_marker))
    emit_point.canvasClicked.connect(partial(get_xy, vertex_marker, emit_point, return_point))

    return return_point


def mouse_move(vertex_marker, point):

    # Hide marker and get coordinates
    vertex_marker.hide()
    event_point = get_event_point(point=point)

    # Snapping
    result = snap_to_background_layers(event_point)
    if result.isValid():
        add_marker(result, vertex_marker)
    else:
        vertex_marker.hide()


def get_xy(emit_point, vertex_marker, return_point, point):
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


def tab_feature_changed(dialog, table_object, excluded_layers=[]):
    """ Set geom_type and layer depending selected tab
        @table_object = ['doc' | 'element' | 'cat_work']
    """

    # parent_vars.get_values_from_form(dialog)
    tab_position = dialog.tab_feature.currentIndex()
    geom_type = "arc"
    if tab_position == 0:
        geom_type = "arc"
    elif tab_position == 1:
        geom_type = "node"
    elif tab_position == 2:
        geom_type = "connec"
    elif tab_position == 3:
        geom_type = "element"
    elif tab_position == 4:
        geom_type = "gully"

    hide_generic_layers(excluded_layers=excluded_layers)
    viewname = f"v_edit_{geom_type}"

    # Adding auto-completion to a QLineEdit
    set_completer_feature_id(dialog.feature_id, geom_type, viewname)

    global_vars.iface.actionPan().trigger()


def set_completer_object(dialog, table_object):
    """ Set autocomplete of widget @table_object + "_id"
        getting id's from selected @table_object
    """

    widget = qt_tools.getWidget(dialog, table_object + "_id")
    if not widget:
        return

    # Set SQL
    field_object_id = "id"
    if table_object == "element":
        field_object_id = table_object + "_id"
    sql = (f"SELECT DISTINCT({field_object_id})"
           f" FROM {table_object}")
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


def get_expr_filter(geom_type, list_ids=None, layers=None):
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
    (is_valid, expr) = check_expression(expr_filter)
    if not is_valid:
        return None

    # Select features of layers applying @expr
    select_features_by_ids(geom_type, expr, layers=layers)

    return expr_filter


def reload_table(dialog, table_object, geom_type, expr_filter):
    """ Reload @widget with contents of @tablename applying selected @expr_filter """

    if type(table_object) is str:
        widget_name = f"tbl_{table_object}_x_{geom_type}"
        widget = qt_tools.getWidget(dialog, widget_name)
        if not widget:
            message = "Widget not found"
            global_vars.controller.log_info(message, parameter=widget_name)
            return None
    elif type(table_object) is QTableView:
        widget = table_object
    else:
        msg = "Table_object is not a table name or QTableView"
        global_vars.controller.log_info(msg)
        return None

    expr = set_table_model(dialog, widget, geom_type, expr_filter)
    return expr


def set_table_model(dialog, table_object, geom_type, expr_filter):
    """ Sets a TableModel to @widget_name attached to
        @table_name and filter @expr_filter
    """

    expr = None
    if expr_filter:
        # Check expression
        (is_valid, expr) = check_expression(expr_filter)  # @UnusedVariable
        if not is_valid:
            return expr

    # Set a model with selected filter expression
    table_name = f"v_edit_{geom_type}"
    if global_vars.schema_name not in table_name:
        table_name = global_vars.schema_name + "." + table_name

    # Set the model
    model = QSqlTableModel()
    model.setTable(table_name)
    model.setEditStrategy(QSqlTableModel.OnManualSubmit)
    model.select()
    if model.lastError().isValid():
        global_vars.controller.show_warning(model.lastError().text())
        return expr

    # Attach model to selected widget
    if type(table_object) is str:
        widget = qt_tools.getWidget(dialog, table_object)
        if not widget:
            message = "Widget not found"
            global_vars.controller.log_info(message, parameter=table_object)
            return expr
    elif type(table_object) is QTableView:
        # parent_vars.controller.log_debug(f"set_table_model: {table_object.objectName()}")
        widget = table_object
    else:
        msg = "Table_object is not a table name or QTableView"
        global_vars.controller.log_info(msg)
        return expr

    if expr_filter:
        widget.setModel(model)
        widget.model().setFilter(expr_filter)
        widget.model().select()
    else:
        widget.setModel(None)

    return expr


def apply_lazy_init(widget, lazy_widget=None, lazy_init_function=None):
    """Apply the init function related to the model. It's necessary
    a lazy init because model is changed everytime is loaded."""

    if lazy_widget is None:
        return
    if widget != lazy_widget:
        return
    lazy_init_function(lazy_widget)


def lazy_configuration(widget, init_function):
    """set the init_function where all necessary events are set.
    This is necessary to allow a lazy setup of the events because set_table_events
    can create a table with a None model loosing any event connection."""

    lazy_widget = widget
    lazy_init_function = init_function

    return lazy_widget, lazy_init_function


def select_features_by_ids(geom_type, expr, layers=None):
    """ Select features of layers of group @geom_type applying @expr """

    if not geom_type in layers:
        return

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


def delete_records(dialog, table_object, query=False, geom_type=None, layers=None, ids=None, list_ids=None,
                   lazy_widget=None, lazy_init_function=None):
    """ Delete selected elements of the table """

    disconnect_signal_selection_changed()

    if type(table_object) is str:
        widget_name = f"tbl_{table_object}_x_{geom_type}"
        widget = qt_tools.getWidget(dialog, widget_name)
        if not widget:
            message = "Widget not found"
            global_vars.controller.show_warning(message, parameter=widget_name)
            return
    elif type(table_object) is QTableView:
        widget = table_object
    else:
        msg = "Table_object is not a table name or QTableView"
        global_vars.controller.log_info(msg)
        return

    # Control when QTableView is void or has no model
    try:
        # Get selected rows
        selected_list = widget.selectionModel().selectedRows()
    except AttributeError:
        selected_list = []

    if len(selected_list) == 0:
        message = "Any record selected"
        global_vars.controller.show_info_box(message)
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
    answer = global_vars.controller.ask_question(message, title, inf_text)
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
        (is_valid, expr) = check_expression(expr_filter)  # @UnusedVariable
        if not is_valid:
            return

    # Update model of the widget with selected expr_filter
    if query:
        delete_feature_at_plan(dialog, geom_type, list_id)
        reload_qtable(dialog, geom_type)
    else:
        reload_table(dialog, table_object, geom_type, expr_filter)
        apply_lazy_init(table_object, lazy_widget=lazy_widget, lazy_init_function=lazy_init_function)

    # Select features with previous filter
    # Build a list of feature id's and select them
    select_features_by_ids(geom_type, expr, layers=layers)

    if query:
        layers = remove_selection(layers=layers)

    # Update list
    list_ids[geom_type] = ids
    enable_feature_type(dialog, table_object, ids=ids)
    connect_signal_selection_changed(dialog, table_object, geom_type)

    return ids, layers, list_ids


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

    reset_model(dialog, table_object, "arc")
    reset_model(dialog, table_object, "node")
    reset_model(dialog, table_object, "connec")
    reset_model(dialog, table_object, "element")
    if global_vars.project_type == 'ud':
        reset_model(dialog, table_object, "gully")
    close_dialog(dialog)
    hide_generic_layers(excluded_layers=excluded_layers)
    disconnect_snapping()
    disconnect_signal_selection_changed()

    return layers


def selection_init(dialog, table_object, query=False, geom_type=None, layers=None):
    """ Set canvas map tool to an instance of class 'MultipleSelection' """

    from .multiple_selection import MultipleSelection

    if geom_type in ('all', None):
        geom_type = 'arc'
    multiple_selection = MultipleSelection(layers, geom_type, parent_manage=None,
                                           table_object=table_object, dialog=dialog)
    disconnect_signal_selection_changed()
    global_vars.canvas.setMapTool(multiple_selection)
    connect_signal_selection_changed(dialog, table_object, query, geom_type)
    cursor = get_cursor_multiple_selection()
    global_vars.canvas.setCursor(cursor)


def selection_changed(dialog, table_object, geom_type, query=False, plan_om=None, layers=None, list_ids=None,
                      lazy_widget=None, lazy_init_function=None):
    """ Slot function for signal 'canvas.selectionChanged' """

    disconnect_signal_selection_changed()
    field_id = f"{geom_type}_id"

    ids = []

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

    if geom_type == 'arc':
        list_ids['arc'] = ids
    elif geom_type == 'node':
        list_ids['node'] = ids
    elif geom_type == 'connec':
        list_ids['connec'] = ids
    elif geom_type == 'gully':
        list_ids['gully'] = ids
    elif geom_type == 'element':
        list_ids['element'] = ids

    expr_filter = None
    if len(ids) > 0:
        # Set 'expr_filter' with features that are in the list
        expr_filter = f'"{field_id}" IN ('
        for i in range(len(ids)):
            expr_filter += f"'{ids[i]}', "
        expr_filter = expr_filter[:-2] + ")"

        # Check expression
        (is_valid, expr) = check_expression(expr_filter)  # @UnusedVariable
        if not is_valid:
            return

        select_features_by_ids(geom_type, expr, layers=layers)

    # Reload contents of table 'tbl_@table_object_x_@geom_type'
    if query:
        insert_feature_to_plan(dialog, geom_type, ids=ids)
        if plan_om == 'plan':
            layers = remove_selection()
        reload_qtable(dialog, geom_type)
    else:
        reload_table(dialog, table_object, geom_type, expr_filter)
        apply_lazy_init(table_object, lazy_widget=lazy_widget, lazy_init_function=lazy_init_function)

    # Remove selection in generic 'v_edit' layers
    if plan_om == 'plan':
        layers = remove_selection(False)
    enable_feature_type(dialog, table_object, ids=ids)
    connect_signal_selection_changed(dialog, table_object, geom_type)

    return ids, layers, list_ids


def delete_feature_at_plan(dialog, geom_type, list_id):
    """ Delete features_id to table plan_@geom_type_x_psector"""

    value = qt_tools.getWidgetText(dialog, dialog.psector_id)
    sql = (f"DELETE FROM plan_psector_x_{geom_type} "
           f"WHERE {geom_type}_id IN ({list_id}) AND psector_id = '{value}'")
    global_vars.controller.execute_sql(sql)


def enable_feature_type(dialog, widget_name='tbl_relation', ids=None):

    feature_type = qt_tools.getWidget(dialog, 'feature_type')
    widget_table = qt_tools.getWidget(dialog, widget_name)
    if feature_type is not None and widget_table is not None:
        if len(ids) > 0:
            feature_type.setEnabled(False)
        else:
            feature_type.setEnabled(True)


def insert_feature(dialog, table_object, query=False, remove_ids=True, geom_type=None, ids=None, layers=None,
                   list_ids=None, lazy_widget=None, lazy_init_function=None):
    """ Select feature with entered id. Set a model with selected filter.
        Attach that model to selected table
    """

    disconnect_signal_selection_changed()

    if geom_type in ('all', None):
        tab_feature_changed(dialog, table_object)

    # Clear list of ids
    if remove_ids:
        ids = []

    field_id = f"{geom_type}_id"
    feature_id = qt_tools.getWidgetText(dialog, "feature_id")
    expr_filter = f"{field_id} = '{feature_id}'"

    # Check expression
    (is_valid, expr) = check_expression(expr_filter)
    if not is_valid:
        return None

    # Select features of layers applying @expr
    select_features_by_ids(geom_type, expr, layers=layers)

    if feature_id == 'null':
        message = "You need to enter a feature id"
        global_vars.controller.show_info_box(message)
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
    (is_valid, expr) = check_expression(expr_filter)
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
        reload_table(dialog, table_object, geom_type, expr_filter)
        apply_lazy_init(table_object, lazy_widget=lazy_widget, lazy_init_function=lazy_init_function)

    # Update list
    list_ids[geom_type] = ids
    enable_feature_type(dialog, table_object, ids=ids)
    connect_signal_selection_changed(dialog, table_object, geom_type)

    global_vars.controller.log_info(list_ids[geom_type])

    return ids, layers, list_ids


def insert_feature_to_plan(dialog, geom_type, ids=None):
    """ Insert features_id to table plan_@geom_type_x_psector """

    value = qt_tools.getWidgetText(dialog, dialog.psector_id)
    for i in range(len(ids)):
        sql = (f"SELECT {geom_type}_id "
               f"FROM plan_psector_x_{geom_type} "
               f"WHERE {geom_type}_id = '{ids[i]}' AND psector_id = '{value}'")
        row = global_vars.controller.get_row(sql)
        if not row:
            sql = (f"INSERT INTO plan_psector_x_{geom_type}"
                   f"({geom_type}_id, psector_id) VALUES('{ids[i]}', '{value}')")
            global_vars.controller.execute_sql(sql)
        reload_qtable(dialog, geom_type)


def reload_qtable(dialog, geom_type):
    """ Reload QtableView """

    value = qt_tools.getWidgetText(dialog, dialog.psector_id)
    expr = f"psector_id = '{value}'"
    qtable = qt_tools.getWidget(dialog, f'tbl_psector_x_{geom_type}')
    fill_table_by_expr(qtable, f"plan_psector_x_{geom_type}", expr)
    set_table_columns(dialog, qtable, f"plan_psector_x_{geom_type}")
    refresh_map_canvas()


def fill_table_by_expr(qtable, table_name, expr):
    """
    :param qtable: QTableView to show
    :param expr: expression to set model
    """
    if global_vars.schema_name not in table_name:
        table_name = global_vars.schema_name + "." + table_name

    model = QSqlTableModel()
    model.setTable(table_name)
    model.setFilter(expr)
    model.setEditStrategy(QSqlTableModel.OnFieldChange)
    qtable.setEditTriggers(QTableView.DoubleClicked)
    model.select()
    qtable.setModel(model)
    qtable.show()

    # Check for errors
    if model.lastError().isValid():
        global_vars.controller.show_warning(model.lastError().text())


def disconnect_snapping():
    """ Select 'Pan' as current map tool and disconnect snapping """

    try:
        global_vars.iface.actionPan().trigger()
        global_vars.canvas.xyCoordinates.disconnect()
    except:
        pass


def fill_table_object(widget, table_name, expr_filter=None):
    """ Set a model with selected filter. Attach that model to selected table """

    if global_vars.schema_name not in table_name:
        table_name = global_vars.schema_name + "." + table_name

    # Set model
    model = QSqlTableModel()
    model.setTable(table_name)
    model.setEditStrategy(QSqlTableModel.OnManualSubmit)
    model.sort(0, 1)
    if expr_filter:
        model.setFilter(expr_filter)
    model.select()

    # Check for errors
    if model.lastError().isValid():
        global_vars.controller.show_warning(model.lastError().text())

    # Attach model to table view
    widget.setModel(model)


def filter_by_id(dialog, widget_table, widget_txt, table_object):

    field_object_id = "id"
    if table_object == "element":
        field_object_id = table_object + "_id"
    object_id = qt_tools.getWidgetText(dialog, widget_txt)
    if object_id != 'null':
        expr = f"{field_object_id}::text ILIKE '%{object_id}%'"
        # Refresh model with selected filter
        widget_table.model().setFilter(expr)
        widget_table.model().select()
    else:
        fill_table_object(widget_table, global_vars.schema_name + "." + table_object)


def delete_selected_object(widget, table_object):
    """ Delete selected objects of the table (by object_id) """

    # Get selected rows
    selected_list = widget.selectionModel().selectedRows()
    if len(selected_list) == 0:
        message = "Any record selected"
        global_vars.controller.show_warning(message)
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
    answer = global_vars.controller.ask_question(message, title, inf_text)
    if answer:
        sql = (f"DELETE FROM {table_object} "
               f"WHERE {field_object_id} IN ({list_id})")
        global_vars.controller.execute_sql(sql)
        widget.model().select()


def set_selectionbehavior(dialog):

    # Get objects of type: QTableView
    widget_list = dialog.findChildren(QTableView)
    for widget in widget_list:
        widget.setSelectionBehavior(QAbstractItemView.SelectRows)


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


def connect_signal_selection_changed(dialog, table_object, query=False, geom_type=None, layers=None):
    """ Connect signal selectionChanged """

    try:
        if geom_type in ('all', None):
            geom_type = 'arc'
        global_vars.canvas.selectionChanged.connect(
            partial(selection_changed, dialog, table_object, geom_type, query, layers=layers))
    except Exception as e:
        global_vars.controller.log_info(f"connect_signal_selection_changed: {e}")


def disconnect_signal_selection_changed():
    """ Disconnect signal selectionChanged """

    try:
        global_vars.canvas.selectionChanged.disconnect()
        global_vars.iface.actionPan().trigger()
    except Exception:
        pass


def fill_widget_with_fields(dialog, data_object, field_names):
    """Fill the Widget with value get from data_object limited to
    the list of field_names."""

    for field_name in field_names:
        value = getattr(data_object, field_name)
        if not hasattr(dialog, field_name):
            continue

        widget = getattr(dialog, field_name)
        if type(widget) == QDateEdit:
            widget.setDate(value if value else QDate.currentDate())
        elif type(widget) == QDateTimeEdit:
            widget.setDateTime(value if value else QDateTime.currentDateTime())

        if type(widget) in [QLineEdit, QTextEdit]:
            if value:
                widget.setText(value)
            else:
                widget.clear()
        if type(widget) in [QComboBox]:
            if not value:
                widget.setCurrentIndex(0)
                continue
            # look the value in item text
            index = widget.findText(str(value))
            if index >= 0:
                widget.setCurrentIndex(index)
                continue
            # look the value in itemData
            index = widget.findData(value)
            if index >= 0:
                widget.setCurrentIndex(index)
                continue


def set_model_to_table(widget, table_name, expr_filter):
    """ Set a model with selected filter.
    Attach that model to selected table """

    if global_vars.schema_name not in table_name:
        table_name = global_vars.schema_name + "." + table_name

    # Set model
    model = QSqlTableModel()
    model.setTable(table_name)
    model.setEditStrategy(QSqlTableModel.OnManualSubmit)
    model.setFilter(expr_filter)
    model.select()

    # Check for errors
    if model.lastError().isValid():
        global_vars.controller.show_warning(model.lastError().text())

    # Attach model to table view
    if widget:
        widget.setModel(model)
    else:
        global_vars.controller.log_info("set_model_to_table: widget not found")

