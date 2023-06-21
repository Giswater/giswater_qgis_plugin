"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
import sys
import subprocess
import webbrowser

from functools import partial
from qgis.PyQt.QtCore import QDate, QRegExp, Qt
from qgis.PyQt.QtWidgets import QComboBox, QDateEdit, QLineEdit, QMessageBox, QTableView, QWidget, QDoubleSpinBox, QSpinBox
from qgis.core import QgsEditorWidgetSetup, QgsFieldConstraints, QgsMessageLog, QgsLayerTreeLayer, QgsVectorLayer, QgsDataSourceUri
from qgis.gui import QgsDateTimeEdit
from qgis.PyQt.QtWidgets import QComboBox

from ... import global_vars
from ..shared.document import GwDocument
from ..shared.element import GwElement
from ..shared.info import GwInfo
from ..shared.visit import GwVisit
from ..utils import tools_gw
from ...libs import lib_vars, tools_qgis, tools_qt, tools_log, tools_os, tools_db

from ..shared.mincut_tools import filter_by_days, filter_by_dates

def add_object(**kwargs):
    """
    Open form of selected element of the @qtable??
        function called in module tools_gw: def add_button(module=sys.modules[__name__], **kwargs):
        at lines:   widget.clicked.connect(partial(getattr(module, function_name), **kwargs))
    """
    dialog = kwargs['dialog']
    button = kwargs['widget']
    index_tab = dialog.tab_main.currentIndex()
    tab_name = dialog.tab_main.widget(index_tab).objectName()
    func_params = kwargs['func_params']
    complet_result = kwargs['complet_result']
    feature_type = complet_result['body']['feature']['featureType']
    feature_id = complet_result['body']['feature']['id']
    field_id = str(complet_result['body']['feature']['idName'])
    qtable_name = func_params['targetwidget']
    qtable = tools_qt.get_widget(dialog, f"{qtable_name}")
    filter_sign = '='
    if button.property('widgetcontrols') is not None and 'filterSign' in button.property('widgetcontrols'):
        if button.property('widgetcontrols')['filterSign'] is not None:
            filter_sign = button.property('widgetcontrols')['filterSign']

    # Get values from dialog
    object_id = tools_qt.get_text(dialog, f"{func_params['sourcewidget']}")
    if object_id == 'null':
        message = "You need to insert data"
        tools_qgis.show_warning(message, parameter=func_params['sourcewidget'])
        return

    # Check if this object exists
    view_object = f"v_ui_{func_params['sourceview']}"
    sql = ("SELECT * FROM " + view_object + ""
           " WHERE id = '" + object_id + "'")
    row = tools_db.get_row(sql, log_sql=True)
    if not row:
        tools_qgis.show_warning("Object id not found", parameter=object_id)
        return

    # Check if this object is already associated to current feature
    field_object_id = dialog.findChild(QWidget, func_params['sourcewidget']).property('columnname')
    tablename = func_params['sourceview'] + "_x_" + feature_type
    sql = ("SELECT * FROM " + str(tablename) + ""
           " WHERE " + str(field_id) + " = '" + str(feature_id) + "'"
           " AND " + str(field_object_id) + " = '" + str(object_id) + "'")
    row = tools_db.get_row(sql, log_info=False)

    # If object already exist show warning message
    if row:
        message = "Object already associated with this feature"
        tools_qgis.show_warning(message)
    # If object not exist perform an INSERT
    else:
        sql = ("INSERT INTO " + tablename + " "
               "(" + str(field_object_id) + ", " + str(field_id) + ")"
               " VALUES ('" + str(object_id) + "', '" + str(feature_id) + "');")
        tools_db.execute_sql(sql, log_sql=False)
        if qtable.objectName() == 'tbl_document':
            date_to = dialog.tab_main.findChild(QDateEdit, 'date_document_to')
            if date_to:
                current_date = QDate.currentDate()
                date_to.setDate(current_date)

        linkedobject = ""
        if qtable.property('linkedobject') is not None:
            linkedobject = qtable.property('linkedobject')

        filter_fields = f'"{field_id}":{{"value":"{feature_id}","filterSign":"{filter_sign}"}}'
        fill_tbl(complet_result, dialog, qtable.objectName(), linkedobject, filter_fields)


def delete_object(**kwargs):
    """ Delete selected objects (elements or documents) of the @widget
         function called in module tools_gw: def add_button(module=sys.modules[__name__], **kwargs):
        at lines:   widget.clicked.connect(partial(getattr(module, function_name), **kwargs))
    """
    dialog = kwargs['dialog']
    try:
        index_tab = dialog.tab_main.currentIndex()
        tab_name = dialog.tab_main.widget(index_tab).objectName()
    except:
        tab_name = 'main'
    func_params = kwargs['func_params']
    complet_result = kwargs['complet_result']

    if 'featureType' in complet_result['body']['feature']:
        feature_type = complet_result['body']['feature']['featureType']
        tablename = f"v_ui_{func_params['sourceview']}_x_{feature_type}"
    else:
        tablename = f"v_ui_{func_params['sourceview']}"

    qtable_name = func_params['targetwidget']
    qtable = tools_qt.get_widget(dialog, f"{qtable_name}")



    # Get selected rows
    selected_list = qtable.selectionModel().selectedRows()
    if len(selected_list) == 0:
        message = "Any record selected"
        tools_qgis.show_warning(message)
        return

    inf_text = ""
    list_object_id = ""
    row_index = ""
    list_id = ""
    for i in range(0, len(selected_list)):
        index = selected_list[i]
        row = index.row()
        column_index = tools_qt.get_col_index_by_col_name(qtable, func_params['columnfind'])
        object_id = index.sibling(row, column_index).data()
        column_index = tools_qt.get_col_index_by_col_name(qtable, 'id')
        id_ = index.sibling(row, column_index).data()

        inf_text += str(object_id) + ", "
        list_id += str(id_) + ", "
        list_object_id = list_object_id + str(object_id) + ", "
        row_index += str(row + 1) + ", "

    list_object_id = list_object_id[:-2]
    list_id = list_id[:-2]
    message = "Are you sure you want to delete these records?"
    answer = tools_qt.show_question(message, "Delete records", list_object_id)
    if answer:
        sql = ("DELETE FROM " + tablename + ""
               " WHERE id::integer IN (" + list_id + ")")
        tools_db.execute_sql(sql, log_sql=False)
        _reload_table(**kwargs)


def open_visit_manager(**kwargs):
    dialog = kwargs['dialog']
    complet_result = kwargs['complet_result']
    func_params = kwargs['func_params']
    feature_type = complet_result['body']['feature']['featureType']
    feature_id = complet_result['body']['feature']['id']

    manage_visit = GwVisit()
    # manage_visit.visit_added.connect(_update_visit_table)
    manage_visit.manage_visits(feature_type, feature_id)


def manage_document(doc_id, **kwargs):
    """ Function called in class tools_gw.add_button(...) -->
        widget.clicked.connect(partial(getattr(self, function_name), **kwargs)) """
    feature = None
    complet_result = kwargs['complet_result']
    feature_type = complet_result['body']['feature']['featureType']
    feature_id = complet_result['body']['feature']['id']
    field_id = str(complet_result['body']['feature']['idName'])
    table_parent = str(complet_result['body']['feature']['tableParent'])
    schema_name = str(complet_result['body']['feature']['schemaName'])

    # When click button 'new_element' element id is the signal emited by the button
    if doc_id is False:
        layer = tools_qgis.get_layer_by_tablename(table_parent, False, False, schema_name)
        if layer:
            expr_filter = f"{field_id} = '{feature_id}'"
            feature = tools_qgis.get_feature_by_expr(layer, expr_filter)

    doc = GwDocument()
    doc.get_document(feature=feature, feature_type=feature_type)
    # If document exist
    if doc_id:
        tools_qt.set_widget_text(doc.dlg_add_doc, "doc_id", doc_id)
        doc.dlg_add_doc.btn_accept.clicked.connect(partial(_reload_table, **kwargs))
    # If we are creating a new element
    else:
        doc.dlg_add_doc.btn_accept.clicked.connect(partial(_manage_document_new, doc, **kwargs))


def open_selected_path(**kwargs):
    """ Open selected path of the @widget
        function called in module tools_gw: def add_tableview(complet_result, field, module=sys.modules[__name__])
        at lines:   widget.doubleClicked.connect(partial(getattr(module, function_name), **kwargs))
    """
    func_params = kwargs['func_params']
    qtable = kwargs['qtable'] if 'qtable' in kwargs else tools_qt.get_widget(kwargs['dialog'], f"{func_params['targetwidget']}")

    # Get selected rows
    selected_list = qtable.selectionModel().selectedRows()
    if len(selected_list) == 0:
        message = "Any record selected"
        tools_qgis.show_warning(message)
        return
    elif len(selected_list) > 1:
        message = "Select just one document"
        tools_qgis.show_warning(message)
        return

    # Get document path (can be relative or absolute)
    index = selected_list[0]
    row = index.row()
    column_index = tools_qt.get_col_index_by_col_name(qtable, func_params['columnfind'])
    path = index.sibling(row, column_index).data()

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


def filter_table(**kwargs):
    """
         Function called in module GwInfo: def _set_filter_listeners(self, complet_result, dialog, widget_list, columnname, widgetname)
         at lines:  widget.textChanged.connect(partial(getattr(tools_backend_calls, widgetfunction), **kwargs))
                    widget.currentIndexChanged.connect(partial(getattr(tools_backend_calls, widgetfunction), **kwargs))

         Might be called in tools_gw also: def set_filter_listeners(complet_result, dialog, widget_list, columnname, widgetname, feature_id=None)
         at lines:  widget.textChanged.connect(partial(getattr(module, function_name), **kwargs))
                    widget.currentIndexChanged.connect(partial(getattr(module, function_name), **kwargs))
                    widget.dateChanged.connect(partial(getattr(module, function_name), **kwargs))
                    widget.valueChanged.connect(partial(getattr(module, function_name), **kwargs))
     """

    complet_result = kwargs['complet_result']
    model = kwargs['model']
    dialog = kwargs['dialog']
    widget_list = kwargs['widget_list']
    widgetname = kwargs['widgetname']
    linkedobject = kwargs['linkedobject']
    feature_id = kwargs['feature_id']
    func_params = kwargs.get('func_params')

    field_id = func_params.get('field_id')
    if field_id is None:
        field_id = str(complet_result['body']['feature']['idName'])
    feature_id = complet_result['body']['feature']['id']
    filter_fields = f'"{field_id}":{{"value":"{feature_id}","filterSign":"="}}, '
    colname = None
    if func_params:
        colname = func_params.get('columnfind')
    filter_fields = get_filter_qtableview(dialog, widget_list, complet_result, filter_fields)
    try:
        index_tab = dialog.tab_main.currentIndex()
        tab_name = dialog.tab_main.widget(index_tab).objectName()
    except:
        tab_name = 'main'
    complet_list = _get_list(complet_result, '', tab_name, filter_fields, widgetname, 'form_feature', linkedobject, feature_id, id_name=field_id)
    if complet_list is False:
        return False
    for field in complet_list['body']['data']['fields']:
        qtable = dialog.findChild(QTableView, field['widgetname'])
        if qtable:
            if field['value'] is None:
                model.removeRows(0, model.rowCount())
                return complet_list
            model.clear()
            tools_gw.add_tableview_header(qtable, field)
            tools_gw.fill_tableview_rows(qtable, field)
            tools_gw.set_tablemodel_config(dialog, qtable, field['widgetname'], 1, True)
            tools_qt.set_tableview_config(qtable)

    return complet_list

def filter_table_mincut(**kwargs):
    """
         Function called in module GwInfo: def _set_filter_listeners(self, complet_result, dialog, widget_list, columnname, widgetname)
         at lines:  widget.textChanged.connect(partial(getattr(tools_backend_calls, widgetfunction), **kwargs))
                    widget.currentIndexChanged.connect(partial(getattr(tools_backend_calls, widgetfunction), **kwargs))
     """

    complet_result = kwargs['complet_result']
    model = kwargs['model']
    dialog = kwargs['dialog']
    widget_list = kwargs['widget_list']
    widgetname = kwargs['widgetname']
    linkedobject = kwargs['linkedobject']
    feature_id = kwargs['feature_id']
    func_params = kwargs['func_params']

    filter_fields = get_filter_qtableview_mincut(dialog, widget_list, func_params)
    try:
        index_tab = dialog.tab_main.currentIndex()
        tab_name = dialog.tab_main.widget(index_tab).objectName()
    except:
        tab_name = 'main'
    complet_list = _get_list(complet_result, '', tab_name, filter_fields, widgetname, 'form_feature', linkedobject, feature_id)
    if complet_list is False:
        return False
    for field in complet_list['body']['data']['fields']:
        qtable = dialog.findChild(QTableView, field['widgetname'])
        if qtable:
            if field['value'] is None:
                model.removeRows(0, model.rowCount())
                return complet_list
            model.clear()
            tools_gw.add_tableview_header(qtable, field)
            tools_gw.fill_tableview_rows(qtable, field)
            tools_gw.set_tablemodel_config(dialog, qtable, field['widgetname'], 1, True)
            tools_qt.set_tableview_config(qtable)

    return complet_list

def open_rpt_result(**kwargs):
    """
    Open form of selected element of the @qtable??
        function called in module tools_gw: def add_tableview(complet_result, field, module=sys.modules[__name__])
        at lines:   widget.doubleClicked.connect(partial(getattr(module, function_name), **kwargs))
    """

    qtable = kwargs['qtable']
    complet_list = kwargs['complet_result']
    func_params = kwargs['func_params']
    # Get selected rows
    selected_list = qtable.selectionModel().selectedRows()
    if len(selected_list) == 0:
        message = "Any record selected"
        tools_qgis.show_warning(message)
        return

    index = selected_list[0]
    row = index.row()
    table_name = complet_list['body']['feature']['tableName']
    column_index = tools_qt.get_col_index_by_col_name(qtable, func_params['columnfind'])
    feature_id = index.sibling(row, column_index).data()
    info_feature = GwInfo('tab_data')
    complet_result, dialog = info_feature.open_form(table_name=table_name, feature_id=feature_id, tab_type='tab_data')

    if not complet_result:
        tools_log.log_info("FAIL open_rpt_result")
        return


def set_layer_index(**kwargs):
    """ Force reload dataProvider of layer """
    """ Function called in def wait_notifications(...) -->  getattr(self, function_name)(**params) """

    # Get list of layer names
    layers_name_list = kwargs['tableName']
    if not layers_name_list:
        return
    if type(layers_name_list) == str:
        tools_qgis.set_layer_index(layers_name_list)
    if type(layers_name_list) == list:
        for layer_name in layers_name_list:
            tools_qgis.set_layer_index(layer_name)


def get_info_node(**kwargs):
    """ Function called in class tools_gw.add_button(...) -->
            widget.clicked.connect(partial(getattr(self, function_name), **kwargs)) """

    dialog = kwargs['dialog']
    widget = kwargs['widget']

    feature_id = tools_qt.get_text(dialog, widget)
    if widget.property('value') not in (None, ''):
        feature_id = widget.property('value')
    custom_form = GwInfo('tab_data')
    complet_result, dialog = custom_form.open_form(table_name='v_edit_node', feature_id=feature_id,
                                                       tab_type='tab_data', is_docker=False)
    if not complet_result:
        tools_log.log_info("FAIL open_node")
        return


def set_style_mapzones(**kwargs):
    """ A bridge function to call tools_gw->set_style_mapzones """
    """ Function called in def get_actions_from_json(...) --> getattr(tools_backend_calls, f"{function_name}")(**params) """

    tools_gw.set_style_mapzones()


def add_query_layer(**kwargs):
    """ Create and add a QueryLayer to ToC """
    """ Function called in def get_actions_from_json(...) --> getattr(tools_backend_calls, f"{function_name}")(**params) """

    query = kwargs.get('query')
    layer_name = kwargs.get('layerName', default='QueryLayer')
    group = kwargs.get('group', default='GW Layers')

    uri = tools_db.get_uri()

    querytext = f"(SELECT row_number() over () AS _uid_,* FROM ({query}) AS query_table)"
    pk = '_uid_'

    uri.setDataSource("", querytext, None, "", pk)
    vlayer = QgsVectorLayer(uri.uri(False), f'{layer_name}', "postgres")

    if vlayer.isValid():
        tools_qt.add_layer_to_toc(vlayer, group)


def refresh_attribute_table(**kwargs):
    """ Set layer fields configured according to client configuration.
        At the moment manage:
            Column names as alias, combos and typeahead as ValueMap"""
    """ Function called in def wait_notifications(...) -->  getattr(self, function_name)(**params) """

    # Get list of layer names
    layers_name_list = kwargs['tableName']
    if not layers_name_list:
        return

    for layer_name in layers_name_list:
        layer = tools_qgis.get_layer_by_tablename(layer_name)
        if not layer:
            msg = f"Layer {layer_name} does not found, therefore, not configured"
            tools_log.log_info(msg)
            continue

        # Get sys variale
        qgis_project_infotype = lib_vars.project_vars['info_type']

        feature = '"tableName":"' + str(layer_name) + '", "id":"", "isLayer":true'
        extras = f'"infoType":"{qgis_project_infotype}"'
        body = tools_gw.create_body(feature=feature, extras=extras)
        result = tools_gw.execute_procedure('gw_fct_getinfofromid', body)
        if not result:
            continue
        for field in result['body']['data']['fields']:
            _values = {}
            # Get column index
            field_idx = layer.fields().indexFromName(field['columnname'])

            # Hide selected fields according table config_form_fields.hidden
            if 'hidden' in field:
                kwargs = {"layer": layer, "field": field['columnname'], "hidden": field['hidden']}
                set_column_visibility(**kwargs)

            # Set multiline fields according table config_form_fields.widgetcontrols['setMultiline']
            if field['widgetcontrols'] is not None and field['widgetcontrols'].get('setMultiline'):
                kwargs = {"layer": layer, "field": field, "fieldIndex": field_idx}
                set_column_multiline(**kwargs)
            # Set alias column
            if field['label']:
                layer.setFieldAlias(field_idx, field['label'])

            # Set field constraints
            if field['widgetcontrols'] and 'setQgisConstraints' in field['widgetcontrols']:
                if field['widgetcontrols']['setQgisConstraints'] is True:
                    layer.setFieldConstraint(field_idx, QgsFieldConstraints.ConstraintNotNull,
                                             QgsFieldConstraints.ConstraintStrengthSoft)
                    layer.setFieldConstraint(field_idx, QgsFieldConstraints.ConstraintUnique,
                                             QgsFieldConstraints.ConstraintStrengthHard)

            # Manage editability
            kwargs = {"layer": layer, "field": field, "fieldIndex": field_idx}
            set_read_only(**kwargs)

            # Manage fields
            if field['widgettype'] == 'combo':
                if 'comboIds' in field:
                    for i in range(0, len(field['comboIds'])):
                        _values[field['comboNames'][i]] = field['comboIds'][i]
                # Set values into valueMap
                editor_widget_setup = QgsEditorWidgetSetup('ValueMap', {'map': _values})
                layer.setEditorWidgetSetup(field_idx, editor_widget_setup)
            elif field['widgettype'] == 'check':
                config = {'CheckedState': 'true', 'UncheckedState': 'false'}
                editor_widget_setup = QgsEditorWidgetSetup('CheckBox', config)
                layer.setEditorWidgetSetup(field_idx, editor_widget_setup)
            elif field['widgettype'] == 'datetime':
                config = {'allow_null': True,
                          'calendar_popup': True,
                          'display_format': 'yyyy-MM-dd',
                          'field_format': 'yyyy-MM-dd',
                          'field_iso_format': False}
                editor_widget_setup = QgsEditorWidgetSetup('DateTime', config)
                layer.setEditorWidgetSetup(field_idx, editor_widget_setup)


def refresh_canvas(**kwargs):
    """ Function called in def wait_notifications(...) -->  getattr(self, function_name)(**params) """

    # Note: canvas.refreshAllLayers() mysteriously that leaves the layers broken
    # self.canvas.refreshAllLayers()
    # Get list of layer names
    try:
        layers_name_list = kwargs['tableName']
        if not layers_name_list:
            return
        if type(layers_name_list) == str:
            layer = tools_qgis.get_layer_by_tablename(layers_name_list)
            layer.triggerRepaint()
        elif type(layers_name_list) == list:
            for layer_name in layers_name_list:
                tools_qgis.set_layer_index(layer_name)
    except Exception:
        all_layers = tools_qgis.get_project_layers()
        for layer in all_layers:
            layer.triggerRepaint()


def set_column_visibility(**kwargs):
    """ Hide selected fields according table config_form_fields.hidden """

    try:
        layer = kwargs["layer"]
        if type(layer) is str:
            layer = tools_qgis.get_layer_by_tablename(layer)
        col_name = kwargs["field"]
        hidden = kwargs["hidden"]
    except Exception as e:
        tools_log.log_info(f"{kwargs}-->{type(e).__name__} --> {e}")
        return

    config = layer.attributeTableConfig()
    columns = config.columns()
    for column in columns:
        if column.name == str(col_name):
            column.hidden = hidden
            break
    config.setColumns(columns)
    layer.setAttributeTableConfig(config)


def set_column_multiline(**kwargs):
    """ Set multiline selected fields according table config_form_fields.widgetcontrols['setMultiline'] """

    try:
        field = kwargs["field"]
        layer = kwargs["layer"]
        if type(layer) is str:
            layer = tools_qgis.get_layer_by_tablename(layer)
        field_index = kwargs["fieldIndex"]
    except Exception as e:
        tools_log.log_info(f"{type(e).__name__} --> {e}")
        return

    if field['widgettype'] == 'text':
        if field['widgetcontrols'] and field['widgetcontrols'].get('setMultiline'):
            editor_widget_setup = QgsEditorWidgetSetup(
                'TextEdit', {'IsMultiline': field['widgetcontrols']['setMultiline']})
            layer.setEditorWidgetSetup(field_index, editor_widget_setup)


def set_read_only(**kwargs):
    """ Set field readOnly according to client configuration into config_form_fields (field 'iseditable') """

    try:
        field = kwargs["field"]
        layer = kwargs["layer"]
        if type(layer) is str:
            layer = tools_qgis.get_layer_by_tablename(layer)
        field_index = kwargs["fieldIndex"]
    except Exception as e:
        tools_log.log_info(f"{type(e).__name__} --> {e}")
        return
    # Get layer config
    config = layer.editFormConfig()
    try:
        # Set field editability
        config.setReadOnly(field_index, not field['iseditable'])
    except KeyError:
        # Control if key 'iseditable' not exist
        pass
    finally:
        # Set layer config
        layer.setEditFormConfig(config)


def load_qml(**kwargs):
    """ Apply QML style located in @qml_path in @layer
    :param kwargs:{"layerName": "v_edit_arc", "qmlPath": "C:\\xxxx\\xxxx\\xxxx\\qml_file.qml"}
    :return: Boolean value
    """

    # Get layer
    layer = tools_qgis.get_layer_by_tablename(kwargs['layerName']) if 'layerName' in kwargs else None
    if layer is None:
        return False

    # Get qml path
    qml_path = kwargs.get('qmlPath')

    if not os.path.exists(qml_path):
        tools_log.log_warning("File not found", parameter=qml_path)
        return False

    if not qml_path.endswith(".qml"):
        tools_log.log_warning("File extension not valid", parameter=qml_path)
        return False

    layer.loadNamedStyle(qml_path)
    layer.triggerRepaint()

    return True


def update_catfeaturevalues(**kwargs):
    """
    Reload global_vars.feature_cat

    """
    global_vars.feature_cat = tools_gw.manage_feature_cat()


def open_url(widget):
    """ Function called in def add_hyperlink(field): -->
        widget.clicked.connect(partial(getattr(tools_backend_calls, func_name), widget)) """

    status, message = tools_os.open_file(widget.text())
    if status is False and message is not None:
        tools_qgis.show_warning(message, parameter=widget.text())


def fill_tbl(complet_result, dialog, widgetname, linkedobject, filter_fields):
    """ Put filter widgets into layout and set headers into QTableView """
    no_tabs = False
    try:
        index_tab = dialog.tab_main.currentIndex()
        tab_name = dialog.tab_main.widget(index_tab).objectName()
    except:
        tab_name = 'main'
        no_tabs = True
    complet_list = _get_list(complet_result, '', tab_name, filter_fields, widgetname, 'form_feature', linkedobject)

    if complet_list is False:
        return False, False
    for field in complet_list['body']['data']['fields']:
        if 'hidden' in field and field['hidden']: continue

        widget = dialog.findChild(QTableView, field['widgetname'])
        if widget is None: continue
        widget = tools_gw.add_tableview_header(widget, field)
        widget = tools_gw.fill_tableview_rows(widget, field)
        widget = tools_gw.set_tablemodel_config(dialog, widget, field['widgetname'], 1, True)
        tools_qt.set_tableview_config(widget)

    widget_list = []
    if no_tabs:
        widget_list.extend(dialog.findChildren(QComboBox, QRegExp(f"{tab_name}_")))
        widget_list.extend(dialog.findChildren(QTableView, QRegExp(f"{tab_name}_")))
        widget_list.extend(dialog.findChildren(QLineEdit, QRegExp(f"{tab_name}_")))
    else:
        widget_list.extend(dialog.tab_main.widget(index_tab).findChildren(QComboBox, QRegExp(f"{tab_name}_")))
        widget_list.extend(dialog.tab_main.widget(index_tab).findChildren(QTableView, QRegExp(f"{tab_name}_")))
        widget_list.extend(dialog.tab_main.widget(index_tab).findChildren(QLineEdit, QRegExp(f"{tab_name}_")))
    return complet_list, widget_list


def get_filter_qtableview(dialog, widget_list, complet_result, filter_fields = ''):

    for widget in widget_list:
        if widget.property('isfilter'):
            columnname = widget.property('columnname')
            if widget.property('widgetfunction'):
                if widget.property('widgetfunction')['parameters'] \
                        and 'columnfind' in widget.property('widgetfunction')['parameters']:
                    columnname = widget.property('widgetfunction')['parameters']['columnfind']
            filter_sign = "ILIKE"
            column_id = 0
            if widget.property('widgetcontrols') is not None and 'filterSign' in widget.property('widgetcontrols'):
                if widget.property('widgetcontrols')['filterSign'] is not None:
                    filter_sign = widget.property('widgetcontrols')['filterSign']
            if widget.property('widgetcontrols') is not None and 'columnId' in widget.property('widgetcontrols'):
                if widget.property('widgetcontrols')['columnId'] is not None:
                    column_id = widget.property('widgetcontrols')['columnId']
            if type(widget) == QComboBox:
                value = tools_qt.get_combo_value(dialog, widget, column_id)
                if value == -1:
                    value = None
            elif type(widget) is QgsDateTimeEdit:
                value = tools_qt.get_calendar_date(dialog, widget, date_format='yyyy-MM-dd')
            else:
                value = tools_qt.get_text(dialog, widget, False, False)

            if not value:
                continue

            filter_fields += f'"{columnname}":{{"value":"{value}","filterSign":"{filter_sign}"}}, '

    if filter_fields != "":
        filter_fields = filter_fields[:-2]

    return filter_fields


def get_filter_qtableview_mincut(dialog, widget_list, func_params, filter_fields = ''):

    for widget in widget_list:
        if widget.property('isfilter'):
            functions = None
            if widget.property('widgetfunction') is not None:
                widgetfunction = widget.property('widgetfunction')
                if isinstance(widgetfunction, list):
                    functions = widgetfunction
                else:
                    functions = [widgetfunction]

                for f in functions:
                    if 'isFilter' in f and f['isFilter']: continue
                    columnname = widget.property('columnname')
                    parameters = f['parameters']
                    filter_sign = "ILIKE"
                    column_id = 0

                    if 'columnfind' in parameters:
                        columnname = parameters['columnfind']

                    if widget.property('widgetcontrols') is not None and 'filterSign' in widget.property('widgetcontrols'):
                        if widget.property('widgetcontrols')['filterSign'] is not None:
                            filter_sign = widget.property('widgetcontrols')['filterSign']
                    if widget.property('widgetcontrols') is not None and 'columnId' in widget.property('widgetcontrols'):
                        if widget.property('widgetcontrols')['columnId'] is not None:
                            column_id = widget.property('widgetcontrols')['columnId']
                    if type(widget) == QComboBox:
                        value = tools_qt.get_combo_value(dialog, widget, column_id)
                        if value == -1:
                            value = None
                    elif type(widget) is QgsDateTimeEdit:
                        value = tools_qt.get_calendar_date(dialog, widget, date_format='yyyy-MM-dd')
                    else:
                        value = tools_qt.get_text(dialog, widget, False, False)

                    if value in (None, ''):
                        continue

                    if type(widget) in (QDoubleSpinBox, QSpinBox, QgsDateTimeEdit):
                        if not widget.isEnabled():
                            continue

                    if widget.objectName() == "main_spm_next_days":
                        filter_fields += filter_by_days(dialog, widget)
                    elif type(widget) is QgsDateTimeEdit:
                        filter_fields += filter_by_dates(dialog, widget)
                    else:
                        filter_fields += f'"{columnname}":{{"value":"{value}","filterSign":"{filter_sign}"}}, '

    if filter_fields != "":
        filter_fields = filter_fields[:-2]

    return filter_fields

# region private functions


def _get_list(complet_result, form_name='', tab_name='', filter_fields='', widgetname='', formtype='', linkedobject='', feature_id='', id_name=None):

    form = f'"formName":"{form_name}", "tabName":"{tab_name}", "widgetname":"{widgetname}", "formtype":"{formtype}"'
    id_name = complet_result['body']['feature']['idName'] if id_name is None else id_name
    feature = f'"tableName":"{linkedobject}", "idName":"{id_name}", "id":"{feature_id}"'
    body = tools_gw.create_body(form, feature, filter_fields)
    json_result = tools_gw.execute_procedure('gw_fct_getlist', body, log_sql=True)
    if json_result is None or json_result['status'] == 'Failed':
        return False
    complet_list = json_result
    if not complet_list:
        return False

    return complet_list


def _manage_document_new(doc, **kwargs):
    """ Get inserted doc_id and add it to current feature """

    if doc.doc_id is None:
        return
    dialog = kwargs['dialog']
    func_params = kwargs['func_params']

    tools_qt.set_widget_text(dialog,  f"{func_params['sourcewidget']}", doc.doc_id)
    add_object(**kwargs)


def _reload_table(**kwargs):
    """ Get inserted element_id and add it to current feature """
    dialog = kwargs['dialog']
    no_tabs = False
    try:
        index_tab = dialog.tab_main.currentIndex()
        tab_name = dialog.tab_main.widget(index_tab).objectName()
        list_tables = dialog.tab_main.widget(index_tab).findChildren(QTableView)
    except:
        no_tabs = True
        tab_name = 'main'
        list_tables = dialog.findChildren(QTableView)


    complet_result = kwargs['complet_result']
    feature_id = complet_result['body']['feature']['id']
    field_id = str(complet_result['body']['feature']['idName'])
    widget_list = []
    if no_tabs:
        widget_list.extend(dialog.findChildren(QComboBox, QRegExp(f"{tab_name}_")))
        widget_list.extend(dialog.findChildren(QTableView, QRegExp(f"{tab_name}_")))
        widget_list.extend(dialog.findChildren(QLineEdit, QRegExp(f"{tab_name}_")))
    else:
        widget_list.extend(dialog.tab_main.widget(index_tab).findChildren(QComboBox, QRegExp(f"{tab_name}_")))
        widget_list.extend(dialog.tab_main.widget(index_tab).findChildren(QTableView, QRegExp(f"{tab_name}_")))
        widget_list.extend(dialog.tab_main.widget(index_tab).findChildren(QLineEdit, QRegExp(f"{tab_name}_")))

    for table in list_tables:
        widgetname = table.objectName()
        columnname = table.property('columnname')
        if columnname is None:
            if no_tabs:
                msg = f"widget {widgetname} has not columnname and cant be configured"
            else:
                msg = f"widget {widgetname} in tab {dialog.tab_main.widget(index_tab).objectName()} has not columnname and cant be configured"
            tools_qgis.show_info(msg, 1)
            continue

        # Get value from filter widgets
        filter_fields = get_filter_qtableview(dialog, widget_list, kwargs['complet_result'])

        # if tab dont have any filter widget
        if filter_fields in ('', None):
            filter_fields = f'"{field_id}":{{"value":"{feature_id}","filterSign":"="}}'

        if no_tabs:
            filter_fields = f''
            widgetname = columnname
        linkedobject = table.property('linkedobject')
        complet_list, widget_list = fill_tbl(complet_result, dialog, widgetname, linkedobject, filter_fields)
        if complet_list is False:
            return False

# endregion


def get_selector(**kwargs):
    """
    Refreshes the selectors if the selector dialog is open

    Function connected -> global_vars.signal_manager.refresh_selectors.connect(tools_gw.refresh_selectors)
    """

    tab_name = kwargs.get('tab')
    global_vars.signal_manager.refresh_selectors.emit(tab_name)


def show_message(**kwargs):
    """
    Shows a message in the message bar.

    Function connected -> global_vars.signal_manager.show_message.connect(tools_qgis.show_message)
    """

    text = kwargs.get('text', default='No message found')
    level = kwargs.get('level', default=1)
    duration = kwargs.get('duration', default=10)

    global_vars.signal_manager.show_message.emit(text, level, duration)


def manage_duplicate_dscenario_copyfrom(dialog):
    """ Function called in def build_dialog_options(...) -->  getattr(module, signal)(dialog) """

    dscenario_id = tools_qt.get_combo_value(dialog, 'copyFrom')
    sql = f"SELECT descript, parent_id, dscenario_type, active, expl_id FROM v_edit_cat_dscenario WHERE dscenario_id = {dscenario_id}"
    row = tools_db.get_row(sql)

    if row:
        tools_qt.set_widget_text(dialog, 'name', "")
        tools_qt.set_widget_text(dialog, 'descript', row[0])
        tools_qt.set_widget_text(dialog, 'parent', row[1])
        tools_qt.set_widget_text(dialog, 'type', row[2])
        tools_qt.set_widget_text(dialog, 'active', row[3])
        tools_qt.set_combo_value(dialog.findChild(QComboBox, 'expl'), f"{row[4]}", 0)

# region unused functions atm

def get_all_layers(group, all_layers):

    for child in group.children():
        if isinstance(child, QgsLayerTreeLayer):
            all_layers.append(child.layer().name())
            child.layer().name()
        else:
            get_all_layers(child)

# endregion
