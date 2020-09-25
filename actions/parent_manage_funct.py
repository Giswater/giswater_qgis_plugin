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

from lib import tools_qt
import global_vars
from actions.parent_functs import check_expression, get_cursor_multiple_selection, set_table_columns, refresh_map_canvas
from lib.tools_qgis import snap_to_background_layers, get_event_point, add_marker, selection_changed, \
    select_features_by_ids
from core.utils.tools_giswater import close_dialog, hide_generic_layers


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


################################################################
################################################################
################################################################
################################################################




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
    widget = tools_qt.getWidget(dialog, widget_name)
    if widget:
        widget.setModel(None)


def reset_widgets(dialog, table_object):
    """ Clear contents of input widgets """

    if table_object == "doc":
        tools_qt.setWidgetText(dialog, "doc_type", "")
        tools_qt.setWidgetText(dialog, "observ", "")
        tools_qt.setWidgetText(dialog, "path", "")
    elif table_object == "element":
        tools_qt.setWidgetText(dialog, "elementcat_id", "")
        tools_qt.setWidgetText(dialog, "state", "")
        tools_qt.setWidgetText(dialog, "expl_id", "")
        tools_qt.setWidgetText(dialog, "ownercat_id", "")
        tools_qt.setWidgetText(dialog, "location_type", "")
        tools_qt.setWidgetText(dialog, "buildercat_id", "")
        tools_qt.setWidgetText(dialog, "workcat_id", "")
        tools_qt.setWidgetText(dialog, "workcat_id_end", "")
        tools_qt.setWidgetText(dialog, "comment", "")
        tools_qt.setWidgetText(dialog, "observ", "")
        tools_qt.setWidgetText(dialog, "path", "")
        tools_qt.setWidgetText(dialog, "rotation", "")
        tools_qt.setWidgetText(dialog, "verified", "")
        tools_qt.setWidgetText(dialog, dialog.num_elements, "")


def fill_widgets(dialog, table_object, row):
    """ Fill input widgets with data int he @row """

    if table_object == "doc":

        tools_qt.setWidgetText(dialog, "doc_type", row["doc_type"])
        tools_qt.setWidgetText(dialog, "observ", row["observ"])
        tools_qt.setWidgetText(dialog, "path", row["path"])

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

        tools_qt.setWidgetText(dialog, "code", row['code'])
        sql = (f"SELECT elementtype_id FROM cat_element"
               f" WHERE id = '{row['elementcat_id']}'")
        row_type = global_vars.controller.get_row(sql)
        if row_type:
            tools_qt.setWidgetText(dialog, "element_type", row_type[0])

        tools_qt.setWidgetText(dialog, "elementcat_id", row['elementcat_id'])
        tools_qt.setWidgetText(dialog, "num_elements", row['num_elements'])
        tools_qt.setWidgetText(dialog, "state", state)
        tools_qt.set_combo_itemData(dialog.state_type, f"{row['state_type']}", 0)
        tools_qt.setWidgetText(dialog, "expl_id", expl_id)
        tools_qt.setWidgetText(dialog, "ownercat_id", row['ownercat_id'])
        tools_qt.setWidgetText(dialog, "location_type", row['location_type'])
        tools_qt.setWidgetText(dialog, "buildercat_id", row['buildercat_id'])
        tools_qt.setWidgetText(dialog, "builtdate", row['builtdate'])
        tools_qt.setWidgetText(dialog, "workcat_id", row['workcat_id'])
        tools_qt.setWidgetText(dialog, "workcat_id_end", row['workcat_id_end'])
        tools_qt.setWidgetText(dialog, "comment", row['comment'])
        tools_qt.setWidgetText(dialog, "observ", row['observ'])
        tools_qt.setWidgetText(dialog, "link", row['link'])
        tools_qt.setWidgetText(dialog, "verified", row['verified'])
        tools_qt.setWidgetText(dialog, "rotation", row['rotation'])
        if str(row['undelete']) == 'True':
            dialog.undelete.setChecked(True)


def get_records_geom_type(dialog, table_object, geom_type, ids=None, list_ids=None, layers=None):
    """ Get records of @geom_type associated to selected @table_object """

    object_id = tools_qt.getWidgetText(dialog, table_object + "_id")
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
    object_id = tools_qt.getWidgetText(dialog, table_object + "_id")

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



def set_combo(dialog, widget, table_name, parameter, field_id='id', field_name='id'):
    """ Executes query and set combo box """

    sql = (f"SELECT t1.{field_name} FROM {table_name} as t1"
           f" INNER JOIN config_param_user as t2 ON t1.{field_id}::text = t2.value::text"
           f" WHERE parameter = '{parameter}' AND cur_user = current_user")
    row = global_vars.controller.get_row(sql)
    if row:
        tools_qt.setWidgetText(dialog, widget, row[0])


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
    tools_qt.setCalendarDate(dialog, widget, date)


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
    set_completer_widget(viewname, dialog.feature_id, concat(str(geom_type),"_id" ))

    global_vars.iface.actionPan().trigger()

    return geom_type


def set_completer_object(dialog, table_object):
    """ Set autocomplete of widget @table_object + "_id"
        getting id's from selected @table_object
    """

    widget = tools_qt.getWidget(dialog, table_object + "_id")
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
        widget = tools_qt.getWidget(dialog, widget_name)
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
        widget = tools_qt.getWidget(dialog, table_object)
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


def enable_feature_type(dialog, widget_name='tbl_relation', ids=None):

    feature_type = tools_qt.getWidget(dialog, 'feature_type')
    widget_table = tools_qt.getWidget(dialog, widget_name)
    if feature_type is not None and widget_table is not None:
        if len(ids) > 0:
            feature_type.setEnabled(False)
        else:
            feature_type.setEnabled(True)


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

