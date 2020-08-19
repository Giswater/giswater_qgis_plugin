"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsPointXY, QgsVectorLayer
from qgis.core import QgsExpression, QgsFeatureRequest, QgsGeometry
from qgis.gui import QgsVertexMarker, QgsDateTimeEdit
from qgis.PyQt.QtCore import Qt, QSettings, QTimer, QDate, QStringListModel
from qgis.PyQt.QtGui import QColor, QStandardItemModel, QStandardItem
from qgis.PyQt.QtWidgets import QLineEdit, QSizePolicy, QWidget, QComboBox, QGridLayout, QSpacerItem, QLabel, QCheckBox
from qgis.PyQt.QtWidgets import QCompleter, QToolButton, QFrame, QSpinBox, QDoubleSpinBox, QDateEdit, QAction
from qgis.PyQt.QtWidgets import QTableView, QTabWidget, QPushButton, QTextEdit, QApplication
from qgis.PyQt.QtSql import QSqlTableModel

import os
import re
import subprocess
import sys
import webbrowser
import json
from functools import partial

from .. import global_vars
from lib import qt_tools
from ..core.utils.hyperlink_label import GwHyperLinkLabel
from ..map_tools.snapping_utils_v3 import SnappingConfigManager
from ..ui_manager import DialogTextUi

from . import parent_vars
from .parent_functs import save_settings, create_body, init_rubber_polygon, resetRubberbands, load_settings, \
    open_dialog, draw, draw_point, get_points, draw_polyline, open_file_path, set_style_mapzones
from ..core.utils.layer_tools import manage_geometry, export_layer_to_db, delete_layer_from_toc, from_dxf_to_toc


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


def get_editable_layers():
    """ Return string as {...}  with name of table in DB of all editable layer in TOC """

    editable_layer = '{'
    layers = global_vars.controller.get_layers()
    for layer in layers:
        if not layer.isReadOnly():
            table_name = global_vars.controller.get_layer_source_table_name(layer)
            editable_layer += f'"{table_name}", '
    editable_layer = editable_layer[:-2] + "}"
    return editable_layer


def set_completer_object_api(completer, model, widget, list_items, max_visible=10):
    """ Set autocomplete of widget @table_object + "_id"
        getting id's from selected @table_object.
        WARNING: Each QLineEdit needs their own QCompleter and their own QStringListModel!!!
    """

    # Set completer and model: add autocomplete in the widget
    completer.setCaseSensitivity(Qt.CaseInsensitive)
    completer.setMaxVisibleItems(max_visible)
    widget.setCompleter(completer)
    completer.setCompletionMode(1)
    model.setStringList(list_items)
    completer.setModel(model)


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

    rows = global_vars.controller.get_rows(sql, log_sql=True)
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


def close_dialog(dlg=None):
    """ Close dialog """

    try:
        save_settings(dlg)
        dlg.close()
    except Exception:
        pass


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


def select_features_by_expr(layer, expr):
    """ Select features of @layer applying @expr """

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


def get_feature_by_id(layer, id, field_id):

    features = layer.getFeatures()
    for feature in features:
        if feature[field_id] == id:
            return feature

    return False


def get_feature_by_expr(layer, expr_filter):

    # Check filter and existence of fields
    expr = QgsExpression(expr_filter)
    if expr.hasParserError():
        message = f"{expr.parserErrorString()}: {expr_filter}"
        global_vars.controller.show_warning(message)
        return

    it = layer.getFeatures(QgsFeatureRequest(expr))
    # Iterate over features
    for feature in it:
        return feature

    return False


def check_actions(action, enabled):

    try:
        action.setChecked(enabled)
    except RuntimeError:
        pass


def api_action_help(geom_type):
    """ Open PDF file with selected @project_type and @geom_type """

    # Get locale of QGIS application
    locale = QSettings().value('locale/userLocale').lower()
    if locale == 'es_es':
        locale = 'es'
    elif locale == 'es_ca':
        locale = 'ca'
    elif locale == 'en_us':
        locale = 'en'
    project_type = global_vars.controller.get_project_type()
    # Get PDF file
    pdf_folder = os.path.join(global_vars.plugin_dir, 'png')
    pdf_path = os.path.join(pdf_folder, f"{project_type}_{geom_type}_{locale}.png")

    # Open PDF if exists. If not open Spanish version
    if os.path.exists(pdf_path):
        os.system(pdf_path)
    else:
        locale = "es"
        pdf_path = os.path.join(pdf_folder, f"{project_type}_{geom_type}_{locale}.png")
        if os.path.exists(pdf_path):
            os.system(pdf_path)
        else:
            message = "File not found"
            global_vars.controller.show_warning(message, parameter=pdf_path)


def set_widget_size(widget, field):

    if 'widgetdim' in field:
        if field['widgetdim']:
            widget.setMaximumWidth(field['widgetdim'])
            widget.setMinimumWidth(field['widgetdim'])

    return widget


def add_button(dialog, field, temp_layers_added=None):

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
            exist = global_vars.controller.check_python_function(sys.modules[__name__], function_name)
            if not exist:
                msg = f"widget {real_name} have associated function {function_name}, but {function_name} not exist"
                global_vars.controller.show_message(msg, 2)
                return widget
        else:
            message = "Parameter button_function is null for button"
            global_vars.controller.show_message(message, 2, parameter=widget.objectName())

    kwargs = {'dialog': dialog, 'widget': widget, 'message_level': 1, 'function_name': function_name, 'temp_layers_added': temp_layers_added}
    widget.clicked.connect(partial(getattr(sys.modules[__name__], function_name), **kwargs))

    return widget


def add_textarea(field):
    """ Add widgets QTextEdit type """

    widget = QTextEdit()
    widget.setObjectName(field['widgetname'])
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    if 'value' in field:
        widget.setText(field['value'])
    if 'iseditable' in field:
        widget.setReadOnly(not field['iseditable'])
        if not field['iseditable']:
            widget.setStyleSheet("QLineEdit { background: rgb(242, 242, 242); color: rgb(100, 100, 100)}")

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


def set_data_type(field, widget):

    widget.setProperty('datatype', field['datatype'])
    return widget


def manage_lineedit(field, dialog, widget, completer):

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
    extras += f', "parentValue":"{qt_tools.getWidgetText(dialog, "data_" + str(field["parentId"]))}"'
    extras += f', "textToSearch":"{qt_tools.getWidgetText(dialog, widget)}"'
    body = create_body(extras=extras)
    complet_list = global_vars.controller.get_json('gw_fct_gettypeahead', body)
    if not complet_list:
        return False

    list_items = []
    for field in complet_list['body']['data']:
        list_items.append(field['idval'])
    set_completer_object_api(completer, model, widget, list_items)


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

    # Call def gw_api_open_rpt_result(self, widget, complet_result) of class ApiCf
    widget.doubleClicked.connect(partial(getattr(sys.modules[__name__], function_name), widget, complet_result))

    return widget


def no_function_associated(**kwargs):

    widget = kwargs['widget']
    message_level = kwargs['message_level']
    message = f"No function associated to"
    global_vars.controller.show_message(message, message_level, parameter=f"{type(widget)} {widget.objectName()}")


def set_headers(widget, field):

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


def populate_table(widget, field):

    standar_model = widget.model()
    for item in field['value']:
        row = []
        for value in item.values():
            row.append(QStandardItem(str(value)))
        if len(row) > 0:
            standar_model.appendRow(row)

    return widget


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


def add_combobox(field):

    widget = QComboBox()
    widget.setObjectName(field['widgetname'])
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    widget = populate_combo(widget, field)
    if 'selectedId' in field:
        qt_tools.set_combo_itemData(widget, field['selectedId'], 0)
        widget.setProperty('selectedId', field['selectedId'])
    else:
        widget.setProperty('selectedId', None)

    return widget


def fill_child(dialog, widget, feature_type, tablename, field_id):
    """ Find QComboBox child and populate it
    :param dialog: QDialog
    :param widget: QComboBox parent
    :param feature_type: PIPE, ARC, JUNCTION, VALVE...
    :param tablename: view of DB
    :param field_id: Field id of tablename
    """

    combo_parent = widget.property('columnname')
    combo_id = qt_tools.get_item_data(dialog, widget)

    feature = f'"featureType":"{feature_type}", '
    feature += f'"tableName":"{tablename}", '
    feature += f'"idName":"{field_id}"'
    extras = f'"comboParent":"{combo_parent}", "comboId":"{combo_id}"'
    body = create_body(feature=feature, extras=extras)
    result = global_vars.controller.get_json('gw_fct_getchilds', body)
    if not result:
        return False

    for combo_child in result['body']['data']:
        if combo_child is not None:
            manage_child(dialog, widget, combo_child)


def manage_child(dialog, combo_parent, combo_child):
    child = dialog.findChild(QComboBox, str(combo_child['widgetname']))
    if child:
        child.setEnabled(True)

        populate_child(dialog, combo_child)
        if 'widgetcontrols' not in combo_child or not combo_child['widgetcontrols'] or \
                'enableWhenParent' not in combo_child['widgetcontrols']:
            return
        #
        if (str(qt_tools.get_item_data(dialog, combo_parent, 0)) in str(combo_child['widgetcontrols']['enableWhenParent'])) \
                and (qt_tools.get_item_data(dialog, combo_parent, 0) not in (None, '')):
            # The keepDisbled property is used to keep the edition enabled or disabled,
            # when we activate the layer and call the "enable_all" function
            child.setProperty('keepDisbled', False)
            child.setEnabled(True)
        else:
            child.setProperty('keepDisbled', True)
            child.setEnabled(False)


def populate_child(dialog, combo_child):

    child = dialog.findChild(QComboBox, str(combo_child['widgetname']))
    if child:
        populate_combo(child, combo_child)


def populate_combo(widget, field):
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


def add_frame(field, x=None):

    widget = QFrame()
    widget.setObjectName(f"{field['widgetname']}_{x}")
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    widget.setFrameShape(QFrame.HLine)
    widget.setFrameShadow(QFrame.Sunken)

    return widget


def add_label(field):
    """ Add widgets QLineEdit type """

    widget = QLabel()
    widget.setTextInteractionFlags(Qt.TextSelectableByMouse)
    widget.setObjectName(field['widgetname'])
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    if 'value' in field:
        widget.setText(field['value'])

    return widget


def set_calendar_empty(widget):
    """ Set calendar empty when click inner button of QgsDateTimeEdit because aesthetically it looks better"""
    widget.setEmpty()


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
            exist = global_vars.controller.check_python_function(sys.modules[__name__], func_name)
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
    widget.clicked.connect(partial(getattr(sys.modules[__name__], func_name), widget))

    return widget


def add_horizontal_spacer():

    widget = QSpacerItem(10, 10, QSizePolicy.Expanding, QSizePolicy.Minimum)
    return widget


def add_vertical_spacer():

    widget = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
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


def draw_polygon(points, border=QColor(255, 0, 0, 100), width=3, duration_time=None, fill_color=None):
    """ Draw 'polygon' over canvas following list of points
    :param duration_time: integer milliseconds ex: 3000 for 3 seconds
    """

    if parent_vars.rubber_polygon is None:
        init_rubber_polygon()


    rb = parent_vars.rubber_polygon
    polygon = QgsGeometry.fromPolygonXY([points])
    rb.setToGeometry(polygon, None)
    rb.setColor(border)
    if fill_color:
        rb.setFillColor(fill_color)
    rb.setWidth(width)
    rb.show()

    # wait to simulate a flashing effect
    if duration_time is not None:
        QTimer.singleShot(duration_time, resetRubberbands)

    return rb


def fill_table(widget, table_name, filter_=None):
    """ Set a model with selected filter.
    Attach that model to selected table """

    if global_vars.schema_name not in table_name:
        table_name = global_vars.schema_name + "." + table_name

    # Set model
    model = QSqlTableModel()
    model.setTable(table_name)
    model.setEditStrategy(QSqlTableModel.OnManualSubmit)
    model.setSort(0, 0)
    if filter_:
        model.setFilter(filter_)
    model.select()

    # Check for errors
    if model.lastError().isValid():
        global_vars.controller.show_warning(model.lastError().text())

    # Attach model to table view
    widget.setModel(model)


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
                widget = manage_lineedit(field, dialog, widget, completer)

        elif field['widgettype'] == 'datetime':
            widget = add_calendar(dialog, field, my_json, new_feature_id=new_feature_id, new_feature=new_feature,
                                  layer_new_feature=layer_new_feature, feature_id=feature_id, feature_type=feature_type,
                                  layer=layer)
            widget = set_auto_update_dateedit(field, dialog, widget)
        elif field['widgettype'] == 'hyperlink':
            widget = add_hyperlink(field)
        elif field['widgettype'] == 'textarea':
            widget = add_textarea(field)
        elif field['widgettype'] in ('combo', 'combobox'):
            widget = QComboBox()
            populate_combo(widget, field)
            widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
        elif field['widgettype'] in ('check', 'checkbox'):
            widget = add_checkbox(field)
            widget.stateChanged.connect(partial(get_values, dialog, widget, my_json, layer))
        elif field['widgettype'] == 'button':
            widget = add_button(dialog, field)

        grid_layout.addWidget(label, x, 0)
        grid_layout.addWidget(widget, x, 1)

    verticalSpacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
    grid_layout.addItem(verticalSpacer1)

    return result


def clear_gridlayout(layout):
    """  Remove all widgets of layout """

    while layout.count() > 0:
        child = layout.takeAt(0).widget()
        if child:
            child.setParent(None)
            child.deleteLater()


def add_calendar(dialog, field, my_json=None, complet_result=None, new_feature_id=None, new_feature=None,
                 layer_new_feature=None, feature_id=None, feature_type=None, layer=None):

    widget = QgsDateTimeEdit()
    widget.setObjectName(field['widgetname'])
    if 'columnname' in field:
        widget.setProperty('columnname', field['columnname'])
    widget.setAllowNull(True)
    widget.setCalendarPopup(True)
    widget.setDisplayFormat('dd/MM/yyyy')
    if 'value' in field and field['value'] not in ('', None, 'null'):
        date = QDate.fromString(field['value'].replace('/', '-'), 'yyyy-MM-dd')
        qt_tools.setCalendarDate(dialog, widget, date)
    else:
        widget.clear()
    btn_calendar = widget.findChild(QToolButton)

    if field['isautoupdate']:
        _json = {}
        btn_calendar.clicked.connect(partial(get_values, dialog, widget, _json, layer))
        btn_calendar.clicked.connect(
            partial(accept, dialog, complet_result[0], _json, p_widget=feature_id, clear_json=True,
                    close_dlg=False, new_feature_id=new_feature_id, new_feature=new_feature,
                    layer_new_feature=layer_new_feature, feature_id=feature_id, feature_type=feature_type))
    else:
        btn_calendar.clicked.connect(partial(get_values, dialog, widget, my_json, layer))
    btn_calendar.clicked.connect(partial(set_calendar_empty, widget))

    return widget


def accept(dialog, complet_result, _json, p_widget=None, clear_json=False, close_dlg=True, new_feature_id=None,
           new_feature=None, layer_new_feature=None, feature_id=None, feature_type=None):
    """
    :param dialog:
    :param complet_result:
    :param _json:
    :param p_widget:
    :param clear_json:
    :param close_dialog:
    :return:
    """

    if _json == '' or str(_json) == '{}':
        if global_vars.controller.dlg_docker:
            global_vars.controller.dlg_docker.setMinimumWidth(dialog.width())
            global_vars.controller.close_docker()
        close_dialog(dialog)
        return

    if None in (new_feature_id, new_feature, layer_new_feature, feature_id, feature_type):
        return

    p_table_id = complet_result['body']['feature']['tableName']
    id_name = complet_result['body']['feature']['idName']
    parent_fields = complet_result['body']['data']['parentFields']
    fields_reload = ""
    list_mandatory = []
    for field in complet_result['body']['data']['fields']:
        if p_widget and (field['widgetname'] == p_widget.objectName()):
            if field['widgetcontrols'] and 'autoupdateReloadFields' in field['widgetcontrols']:
                fields_reload = field['widgetcontrols']['autoupdateReloadFields']

        if field['ismandatory']:
            widget_name = 'data_' + field['columnname']
            widget = dialog.findChild(QWidget, widget_name)
            widget.setStyleSheet(None)
            value = qt_tools.getWidgetText(dialog, widget)
            if value in ('null', None, ''):
                widget.setStyleSheet("border: 1px solid red")
                list_mandatory.append(widget_name)

    if list_mandatory:
        msg = "Some mandatory values are missing. Please check the widgets marked in red."
        global_vars.controller.show_warning(msg)
        return

    # If we create a new feature
    if new_feature_id is not None:
        for k, v in list(_json.items()):
            if k in parent_fields:
                new_feature.setAttribute(k, v)
                _json.pop(k, None)
        layer_new_feature.updateFeature(new_feature)

        status = layer_new_feature.commitChanges()
        if status is False:
            return

        my_json = json.dumps(_json)
        if my_json == '' or str(my_json) == '{}':
            if global_vars.controller.dlg_docker:
                global_vars.controller.dlg_docker.setMinimumWidth(dialog.width())
                global_vars.controller.close_docker()
            close_dialog(dialog)
            return
        if new_feature.attribute(id_name) is not None:
            feature = f'"id":"{new_feature.attribute(id_name)}", '
        else:
            feature = f'"id":"{feature_id}", '

    # If we make an info
    else:
        my_json = json.dumps(_json)
        feature = f'"id":"{feature_id}", '

    feature += f'"featureType":"{feature_type}", '
    feature += f'"tableName":"{p_table_id}"'
    extras = f'"fields":{my_json}, "reload":"{fields_reload}"'
    body = create_body(feature=feature, extras=extras)
    json_result = global_vars.controller.get_json('gw_fct_setfields', body)
    if not json_result:
        return

    if clear_json:
        _json = {}

    if "Accepted" in json_result['status']:
        msg = "OK"
        global_vars.controller.show_message(msg, message_level=3)
        reload_fields(dialog, json_result, p_widget)
    elif "Failed" in json_result['status']:
        # If json_result['status'] is Failed message from database is showed user by get_json-->manage_exception_api
        return

    if close_dlg:
        if global_vars.controller.dlg_docker:
            global_vars.controller.dlg_docker.setMinimumWidth(dialog.width())
            global_vars.controller.close_docker()
        close_dialog(dialog)


def reload_fields(dialog, result, p_widget):
    """
    :param dialog: QDialog where find and set widgets
    :param result: row with info (json)
    :param p_widget: Widget that has changed
    """

    if not p_widget:
        return

    for field in result['body']['data']['fields']:
        widget = dialog.findChild(QLineEdit, f'{field["widgetname"]}')
        if widget:
            value = field["value"]
            qt_tools.setText(dialog, widget, value)
            if not field['iseditable']:
                widget.setStyleSheet("QLineEdit { background: rgb(0, 255, 0); color: rgb(0, 0, 0)}")
            else:
                widget.setStyleSheet(None)
        elif "message" in field:
            level = field['message']['level'] if 'level' in field['message'] else 0
            global_vars.controller.show_message(field['message']['text'], level)


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
                widget = add_combobox(field)
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
                if 'value' in field and field['value'] not in(None, ""):
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
        value = qt_tools.getWidgetText(dialog, widget, return_string_null=False)
    elif type(widget) is QComboBox:
        value = qt_tools.get_item_data(dialog, widget, 0)
    elif type(widget) is QCheckBox:
        value = qt_tools.isChecked(dialog, widget)
    elif type(widget) is QDateEdit:
        value = qt_tools.getCalendarDate(dialog, widget)
    # if chk is None:
    #     elem[widget.objectName()] = value
    elem['widget'] = str(widget.objectName())
    elem['value'] = value
    if chk is not None:
        if chk.isChecked():
            # elem['widget'] = str(widget.objectName())
            elem['chk'] = str(chk.objectName())
            elem['isChecked'] = str(qt_tools.isChecked(dialog, chk))
            # elem['value'] = value

    if 'sys_role_id' in field:
        elem['sys_role_id'] = str(field['sys_role_id'])
    list.append(elem)
    global_vars.controller.log_info(str(list))


def set_widgets_into_composer(dialog, field, my_json=None):

    widget = None
    label = None
    if field['label']:
        label = QLabel()
        label.setObjectName('lbl_' + field['widgetname'])
        label.setText(field['label'].capitalize())
        if field['stylesheet'] is not None and 'label' in field['stylesheet']:
            label = set_setStyleSheet(field, label)
        if 'tooltip' in field:
            label.setToolTip(field['tooltip'])
        else:
            label.setToolTip(field['label'].capitalize())
    if field['widgettype'] == 'text' or field['widgettype'] == 'typeahead':
        widget = add_lineedit(field)
        widget = set_widget_size(widget, field)
        widget = set_data_type(field, widget)
        widget.editingFinished.connect(partial(get_values, dialog, widget, my_json))
        widget.returnPressed.connect(partial(get_values, dialog, widget, my_json))
    elif field['widgettype'] == 'combo':
        widget = add_combobox(field)
        widget = set_widget_size(widget, field)
        widget.currentIndexChanged.connect(partial(get_values, dialog, widget, my_json))
        if 'widgetfunction' in field:
            if field['widgetfunction'] is not None:
                function_name = field['widgetfunction']
                # Call def gw_fct_setprint(self, dialog, my_json): of the class ApiManageComposer
                widget.currentIndexChanged.connect(partial(getattr(sys.modules[__name__], function_name), dialog, my_json))

    return label, widget


def get_values(dialog, widget, _json=None, layer=None):

    value = None
    if type(widget) in(QLineEdit, QSpinBox, QDoubleSpinBox) and widget.isReadOnly() is False:
        value = qt_tools.getWidgetText(dialog, widget, return_string_null=False)
    elif type(widget) is QComboBox and widget.isEnabled():
        value = qt_tools.get_item_data(dialog, widget, 0)
    elif type(widget) is QCheckBox and widget.isEnabled():
        value = qt_tools.isChecked(dialog, widget)
    elif type(widget) is QgsDateTimeEdit and widget.isEnabled():
        value = qt_tools.getCalendarDate(dialog, widget)
    # Only get values if layer is editable or if layer not exist(need for ApiManageComposer)
    if layer is not None or layer.isEditable():
        # If widget.isEditable(False) return None, here control it.
        if str(value) == '' or value is None:
            _json[str(widget.property('columnname'))] = None
        else:
            _json[str(widget.property('columnname'))] = str(value)


'''
def set_function_associated(dialog, widget, field):

    function_name = 'no_function_associated'
    if 'widgetfunction' in field:
        if field['widgetfunction'] is not None:
            function_name = field['widgetfunction']
            exist = global_vars.controller.check_python_function(sys.modules[__name__], function_name)
            if not exist:
                return widget
    else:
        message = "Parameter not found"
        global_vars.controller.show_message(message, 2, parameter='button_function')

    if type(widget) == QLineEdit:
        # Call def gw_fct_setprint(self, dialog, my_json): of the class ApiManageComposer
        widget.editingFinished.connect(partial(getattr(sys.modules[__name__], function_name), dialog, self.my_json))
        widget.returnPressed.connect(partial(getattr(sys.modules[__name__], function_name), dialog, self.my_json))

    return widget
'''


def draw_rectangle(result):
    """ Draw lines based on geometry """

    if result['geometry'] is None:
        return

    list_coord = re.search('\((.*)\)', str(result['geometry']['st_astext']))
    points = get_points(list_coord)
    draw_polyline(points)


def set_setStyleSheet(field, widget, wtype='label'):

    if field['stylesheet'] is not None:
        if wtype in field['stylesheet']:
            widget.setStyleSheet("QWidget{" + field['stylesheet'][wtype] + "}")
    return widget


""" FUNCTIONS ASSOCIATED TO BUTTONS FROM POSTGRES"""

def action_open_url(dialog, result):

    widget = None
    function_name = 'no_function_associated'
    for field in result['fields']:
        if field['linkedaction'] == 'action_link':
            function_name = field['widgetfunction']
            widget = dialog.findChild(GwHyperLinkLabel, field['widgetname'])
            break

    if widget:
        # Call def  function (self, widget)
        getattr(sys.modules[__name__], function_name)(widget)


def set_open_url(widget):

    path = widget.text()
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


def gw_function_dxf(**kwargs):
    """ Function called in def add_button(self, dialog, field): -->
            widget.clicked.connect(partial(getattr(sys.modules[__name__], function_name), **kwargs))
            widget.clicked.connect(partial(getattr(sys.modules[__name__], func_name), widget)) """

    path, filter_ = open_file_path(filter_="DXF Files (*.dxf)")
    if not path:
        return

    dialog = kwargs['dialog']
    widget = kwargs['widget']
    temp_layers_added = kwargs['temp_layer_added']
    complet_result = manage_dxf(dialog, path, False, True)

    for layer in complet_result['temp_layers_added']:
        temp_layers_added.append(layer)
    if complet_result is not False:
        widget.setText(complet_result['path'])

    dialog.btn_run.setEnabled(True)
    dialog.btn_cancel.setEnabled(True)


def manage_dxf(dialog, dxf_path, export_to_db=False, toc=False, del_old_layers=True):
    """ Select a dxf file and add layers into toc
    :param dxf_path: path of dxf file
    :param export_to_db: Export layers to database
    :param toc: insert layers into TOC
    :param del_old_layers: look for a layer with the same name as the one to be inserted and delete it
    :return:
    """

    srid = global_vars.controller.plugin_settings_value('srid')
    # Block the signals so that the window does not appear asking for crs / srid and / or alert message
    global_vars.iface.mainWindow().blockSignals(True)
    dialog.txt_infolog.clear()

    sql = "DELETE FROM temp_table WHERE fid = 206;\n"
    global_vars.controller.execute_sql(sql)
    temp_layers_added = []
    for type_ in ['LineString', 'Point', 'Polygon']:

        # Get file name without extension
        dxf_output_filename = os.path.splitext(os.path.basename(dxf_path))[0]

        # Create layer
        uri = f"{dxf_path}|layername=entities|geometrytype={type_}"
        dxf_layer = QgsVectorLayer(uri, f"{dxf_output_filename}_{type_}", 'ogr')

        # Set crs to layer
        crs = dxf_layer.crs()
        crs.createFromId(srid)
        dxf_layer.setCrs(crs)

        if not dxf_layer.hasFeatures():
            continue

        # Get the name of the columns
        field_names = [field.name() for field in dxf_layer.fields()]

        sql = ""
        geom_types = {0: 'geom_point', 1: 'geom_line', 2: 'geom_polygon'}
        for count, feature in enumerate(dxf_layer.getFeatures()):
            geom_type = feature.geometry().type()
            sql += (f"INSERT INTO temp_table (fid, text_column, {geom_types[int(geom_type)]})"
                    f" VALUES (206, '{{")
            for att in field_names:
                if feature[att] in (None, 'NULL', ''):
                    sql += f'"{att}":null , '
                else:
                    sql += f'"{att}":"{feature[att]}" , '
            geometry = manage_geometry(feature.geometry())
            sql = sql[:-2] + f"}}', (SELECT ST_GeomFromText('{geometry}', {srid})));\n"
            if count != 0 and count % 500 == 0:
                status = global_vars.controller.execute_sql(sql)
                if not status:
                    return False
                sql = ""

        if sql != "":
            status = global_vars.controller.execute_sql(sql)
            if not status:
                return False

        if export_to_db:
            export_layer_to_db(dxf_layer, crs)

        if del_old_layers:
            delete_layer_from_toc(dxf_layer.name())

        if toc:
            if dxf_layer.isValid():
                from_dxf_to_toc(dxf_layer, dxf_output_filename)
                temp_layers_added.append(dxf_layer)

    # Unlock signals
    global_vars.iface.mainWindow().blockSignals(False)

    extras = "  "
    for widget in dialog.grb_parameters.findChildren(QWidget):
        widget_name = widget.property('columnname')
        value = qt_tools.getWidgetText(dialog, widget, add_quote=False)
        extras += f'"{widget_name}":"{value}", '
    extras = extras[:-2]
    body = create_body(extras)
    result = global_vars.controller.get_json('gw_fct_check_importdxf', None, log_sql=True)
    if not result:
        return False

    return {"path": dxf_path, "result": result, "temp_layers_added": temp_layers_added}


def manage_all(dialog, widget_all):

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

    set_selector(dialog, widget_all, False)


def get_selector(dialog, selector_type, filter=False, widget=None, text_filter=None, current_tab=None,
                 is_setselector=None):
    """ Ask to DB for selectors and make dialog
    :param dialog: Is a standard dialog, from file api_selectors.ui, where put widgets
    :param selector_type: list of selectors to ask DB ['exploitation', 'state', ...]
    """

    index = 0
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
        json_result = global_vars.controller.get_json('gw_fct_getselectors', body, log_sql=True)
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
                widget.textChanged.connect(partial(manage_filter, dialog, widget, 'save'))
                widget.setLayoutDirection(Qt.RightToLeft)
                setattr(self, f"var_txt_filter_{form_tab['tabName']}", '')
            else:
                widget = qt_tools.getWidget(dialog, 'txt_filter_' + str(form_tab['tabName']))

            field['layoutname'] = gridlayout.objectName()
            field['layoutorder'] = i
            i = i + 1
            put_widgets(dialog, field, label, widget)
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
                    widget.stateChanged.connect(partial(manage_all, dialog, widget))
                    widget.setLayoutDirection(Qt.RightToLeft)

                else:
                    widget = qt_tools.getWidget(dialog, f"chk_all_{form_tab['tabName']}")
                field['layoutname'] = gridlayout.objectName()
                field['layoutorder'] = i
                i = i + 1
                chk_all = widget
                put_widgets(dialog, field, label, widget)

        for order, field in enumerate(form_tab['fields']):
            label = QLabel()
            label.setObjectName('lbl_' + field['label'])
            label.setText(field['label'])

            widget = add_checkbox(field)
            widget.stateChanged.connect(partial(set_selection_mode, dialog, widget, selection_mode))
            widget.setLayoutDirection(Qt.RightToLeft)

            field['layoutname'] = gridlayout.objectName()
            field['layoutorder'] = order + i
            put_widgets(dialog, field, label, widget)

        vertical_spacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
        gridlayout.addItem(vertical_spacer1)

    # Set last tab used by user as current tab
    tabname = json_result['body']['form']['currentTab']
    tab = main_tab.findChild(QWidget, tabname)

    if tab:
        main_tab.setCurrentWidget(tab)

    if is_setselector is not None:
        widget = dialog.main_tab.findChild(QLineEdit, f'txt_filter_{tabname}')
        if widget:
            widget.blockSignals(True)
            index = dialog.main_tab.currentIndex()
            tab_name = dialog.main_tab.widget(index).objectName()
            value = getattr(self, f"var_txt_filter_{tab_name}")
            qt_tools.setWidgetText(dialog, widget, f'{value}')
            widget.blockSignals(False)


def set_selection_mode(dialog, widget, selection_mode):
    """ Manage selection mode
    :param dialog: QDialog where search all checkbox
    :param widget: QCheckBox that has changed status (QCheckBox)
    :param selection_mode: "keepPrevious", "keepPreviousUsingShift", "removePrevious" (String)
    """

    # Get QCheckBox check all
    index = dialog.main_tab.currentIndex()
    widget_list = dialog.main_tab.widget(index).findChildren(QCheckBox)
    tab_name = dialog.main_tab.widget(index).objectName()
    widget_all = dialog.findChild(QCheckBox, f'chk_all_{tab_name}')

    is_alone = False
    key_modifier = QApplication.keyboardModifiers()

    if selection_mode == 'removePrevious' or \
            (selection_mode == 'keepPreviousUsingShift' and key_modifier != Qt.ShiftModifier):
        is_alone = True
        if widget_all is not None:
            widget_all.blockSignals(True)
            qt_tools.setChecked(dialog, widget_all, False)
            widget_all.blockSignals(False)
        remove_previuos(dialog, widget, widget_all, widget_list)

    set_selector(dialog, widget, is_alone)


def remove_previuos(dialog, widget, widget_all, widget_list):
    """ Remove checks of not selected QCheckBox
    :param dialog: QDialog
    :param widget: QCheckBox that has changed status (QCheckBox)
    :param widget_all: QCheckBox that handles global selection (QCheckBox)
    :param widget_list: List of all QCheckBox in the current tab ([QCheckBox, QCheckBox, ...])
    """

    for checkbox in widget_list:
        # Some selectors.ui dont have widget_all
        if widget_all is not None:
            if checkbox == widget_all or checkbox.objectName() == widget_all.objectName():
                continue
            elif checkbox.objectName() != widget.objectName():
                checkbox.blockSignals(True)
                qt_tools.setChecked(dialog, checkbox, False)
                checkbox.blockSignals(False)

        elif checkbox.objectName() != widget.objectName():
            checkbox.blockSignals(True)
            qt_tools.setChecked(dialog, checkbox, False)
            checkbox.blockSignals(False)


def set_selector(dialog, widget, is_alone):
    """  Send values to DB and reload selectors
    :param dialog: QDialog
    :param widget: QCheckBox that contains the information to generate the json (QCheckBox)
    :param is_alone: Defines if the selector is unique (True) or multiple (False) (Boolean)
    """

    # Get current tab name
    index = dialog.main_tab.currentIndex()
    tab_name = dialog.main_tab.widget(index).objectName()
    selector_type = dialog.main_tab.widget(index).property("selector_type")
    qgis_project_add_schema = global_vars.controller.plugin_settings_value('gwAddSchema')
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
    json_result = global_vars.controller.get_json('gw_fct_setselectors', body, log_sql=True)

    if str(tab_name) == 'tab_exploitation':
        # Reload layer, zoom to layer, style mapzones and refresh canvas
        layer = global_vars.controller.get_layer_by_tablename('v_edit_arc')
        if layer:
            global_vars.iface.setActiveLayer(layer)
            global_vars.iface.zoomToActiveLayer()
        set_style_mapzones()

    # Refresh canvas
    global_vars.controller.set_layer_index('v_edit_arc')
    global_vars.controller.set_layer_index('v_edit_node')
    global_vars.controller.set_layer_index('v_edit_connec')
    global_vars.controller.set_layer_index('v_edit_gully')
    global_vars.controller.set_layer_index('v_edit_link')
    global_vars.controller.set_layer_index('v_edit_plan_psector')

    get_selector(dialog, f'"{selector_type}"', is_setselector=json_result)

    widget_filter = qt_tools.getWidget(dialog, f"txt_filter_{tab_name}")
    if widget_filter and qt_tools.getWidgetText(dialog, widget_filter, False, False) not in (None, ''):
        widget_filter.textChanged.emit(widget_filter.text())


def manage_filter(dialog, widget, action):
    index = dialog.main_tab.currentIndex()
    tab_name = dialog.main_tab.widget(index).objectName()
    if action == 'save':
        setattr(self, f"var_txt_filter_{tab_name}", qt_tools.getWidgetText(dialog, widget))
    else:
        setattr(self, f"var_txt_filter_{tab_name}", '')
