"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.core import QgsEditorWidgetSetup, QgsFieldConstraints, QgsMessageLog, QgsLayerTreeLayer, QgsProject, \
    QgsVectorLayer, QgsVectorLayerExporter, QgsDataSourceUri
from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtWidgets import QMessageBox, QWidget

import os

from ... import global_vars
from ..utils import tools_gw


def gw_function_dxf(**kwargs):
    """ Function called in def add_button(self, dialog, field): -->
            widget.clicked.connect(partial(getattr(self, function_name), dialog, widget)) """

    path, filter_ = tools_gw.open_file_path(filter_="DXF Files (*.dxf)")
    if not path:
        return

    dialog = kwargs['dialog']
    widget = kwargs['widget']
    temp_layers_added = kwargs['temp_layers_added']
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
            tools_gw.delete_layer_from_toc(dxf_layer.name())

        if toc:
            if dxf_layer.isValid():
                from_dxf_to_toc(dxf_layer, dxf_output_filename)
                temp_layers_added.append(dxf_layer)

    # Unlock signals
    global_vars.iface.mainWindow().blockSignals(False)

    extras = "  "
    for widget in dialog.grb_parameters.findChildren(QWidget):
        widget_name = widget.property('columnname')
        value = tools_gw.getWidgetText(dialog, widget, add_quote=False)
        extras += f'"{widget_name}":"{value}", '
    extras = extras[:-2]
    body = tools_gw.create_body(extras)
    result = global_vars.controller.get_json('gw_fct_check_importdxf', None)
    if not result or result['status'] == 'Failed':
        return False

    return {"path": dxf_path, "result": result, "temp_layers_added": temp_layers_added}



def from_dxf_to_toc(dxf_layer, dxf_output_filename):
    """  Read a dxf file and put result into TOC
    :param dxf_layer: (QgsVectorLayer)
    :param dxf_output_filename: Name of layer into TOC (string)
    :return: dxf_layer (QgsVectorLayer)
    """

    QgsProject.instance().addMapLayer(dxf_layer, False)
    root = QgsProject.instance().layerTreeRoot()
    my_group = root.findGroup(dxf_output_filename)
    if my_group is None:
        my_group = root.insertGroup(0, dxf_output_filename)
    my_group.insertLayer(0, dxf_layer)
    global_vars.canvas.refreshAllLayers()
    return dxf_layer


def manage_geometry(geometry):
    """ Get QgsGeometry and return as text
     :param geometry: (QgsGeometry)
     :return: (String)
    """
    geometry = geometry.asWkt().replace('Z (', ' (')
    geometry = geometry.replace(' 0)', ')')
    return geometry


def export_layer_to_db(layer, crs):
    """ Export layer to postgres database
    :param layer: (QgsVectorLayer)
    :param crs: QgsVectorLayer.crs() (crs)
    """

    sql = f'DROP TABLE "{layer.name()}";'
    global_vars.controller.execute_sql(sql)

    schema_name = global_vars.controller.credentials['schema'].replace('"', '')
    uri = set_uri()
    uri.setDataSource(schema_name, layer.name(), None, "", layer.name())

    error = QgsVectorLayerExporter.exportLayer(
        layer, uri.uri(), global_vars.controller.credentials['user'], crs, False)
    if error[0] != 0:
        global_vars.controller.log_info(F"ERROR --> {error[1]}")


def set_uri():
    """ Set the component parts of a RDBMS data source URI
    :return: QgsDataSourceUri() with the connection established according to the parameters of the controller.
    """

    uri = QgsDataSourceUri()
    uri.setConnection(global_vars.controller.credentials['host'], global_vars.controller.credentials['port'],
                           global_vars.controller.credentials['db'], global_vars.controller.credentials['user'],
                           global_vars.controller.credentials['password'])
    return uri


class GwInfoTools:
    """ Class with functions usually called from the database, either via notify or by executing a get_json """
    def __init__(self):
        """ Class to control functions called from data base """

        self.controller = global_vars.controller


    def set_layer_index(self, **kwargs):
        """ Force reload dataProvider of layer """
        """ Function called in def wait_notifications(...) -->  getattr(self, function_name)(**params) """

        # Get list of layer names
        layers_name_list = kwargs['tableName']
        if not layers_name_list:
            return
        if type(layers_name_list) == str:
            self.controller.set_layer_index(layers_name_list)
        if type(layers_name_list) == list:
            for layer_name in layers_name_list:
                self.controller.set_layer_index(layer_name)


    def refresh_attribute_table(self, **kwargs):
        """ Function called in def wait_notifications(...) -->  getattr(self, function_name)(**params) """
        """ Set layer fields configured according to client configuration.
            At the moment manage:
                Column names as alias, combos and typeahead as ValueMap"""

        # Get list of layer names
        layers_name_list = kwargs['tableName']
        if not layers_name_list:
            return

        for layer_name in layers_name_list:
            layer = self.controller.get_layer_by_tablename(layer_name)
            if not layer:
                msg = f"Layer {layer_name} does not found, therefore, not configured"
                self.controller.log_info(msg)
                continue

            # Get sys variale
            self.qgis_project_infotype = self.controller.plugin_settings_value('infoType')

            feature = '"tableName":"' + str(layer_name) + '", "id":"", "isLayer":true'
            extras = f'"infoType":"{self.qgis_project_infotype}"'
            body = tools_gw.create_body(feature=feature, extras=extras)
            result = self.controller.get_json('gw_fct_getinfofromid', body, is_notify=True)
            if not result:
                continue
            for field in result['body']['data']['fields']:
                _values = {}
                # Get column index
                field_idx = layer.fields().indexFromName(field['columnname'])

                # Hide selected fields according table config_api_form_fields.hidden
                if 'hidden' in field:
                    kwargs = {"layer": layer, "field": field['columnname'], "hidden": field['hidden']}
                    self.set_column_visibility(**kwargs)

                # Set multiline fields according table config_api_form_fields.widgetcontrols['setQgisMultiline']
                if field['widgetcontrols'] is not None and 'setQgisMultiline' in field['widgetcontrols']:
                    kwargs = {"layer": layer, "field": field, "fieldIndex": field_idx}
                    self.set_column_multiline(**kwargs)
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
                self.set_read_only(**kwargs)

                # Manage fields
                if field['widgettype'] == 'combo':
                    if 'comboIds' in field:
                        for i in range(0, len(field['comboIds'])):
                            _values[field['comboNames'][i]] = field['comboIds'][i]
                    # Set values into valueMap
                    editor_widget_setup = QgsEditorWidgetSetup('ValueMap', {'map': _values})
                    layer.setEditorWidgetSetup(field_idx, editor_widget_setup)
                elif field['widgettype'] == 'text':
                    editor_widget_setup = QgsEditorWidgetSetup('TextEdit', {'IsMultiline': 'True'})
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
                else:
                    editor_widget_setup = QgsEditorWidgetSetup('TextEdit', {'IsMultiline': 'True'})
                    layer.setEditorWidgetSetup(field_idx, editor_widget_setup)


    def refresh_canvas(self, **kwargs):
        """ Function called in def wait_notifications(...) -->  getattr(self, function_name)(**params) """
        # Note: canvas.refreshAllLayers() mysteriously that leaves the layers broken
        # self.canvas.refreshAllLayers()
        # Get list of layer names
        try:
            layers_name_list = kwargs['tableName']
            if not layers_name_list:
                return
            if type(layers_name_list) == str:
                layer = self.controller.get_layer_by_tablename(layers_name_list)
                layer.triggerRepaint()
            elif type(layers_name_list) == list:
                for layer_name in layers_name_list:
                    self.controller.set_layer_index(layer_name)
        except:
            all_layers = self.controller.get_layers()
            for layer in all_layers:
                layer.triggerRepaint()


    def set_column_visibility(self, **kwargs):
        """ Hide selected fields according table config_api_form_fields.hidden """

        try:
            layer = kwargs["layer"]
            if type(layer) is str:
                layer = self.controller.get_layer_by_tablename(layer)
            col_name = kwargs["field"]
            hidden = kwargs["hidden"]
        except Exception as e:
            self.controller.log_info(f"{kwargs}-->{type(e).__name__} --> {e}")
            return

        config = layer.attributeTableConfig()
        columns = config.columns()
        for column in columns:
            if column.name == str(col_name):
                column.hidden = hidden
                break
        config.setColumns(columns)
        layer.setAttributeTableConfig(config)


    def set_column_multiline(self, **kwargs):
        """ Set multiline selected fields according table config_api_form_fields.widgetcontrols['setQgisMultiline'] """

        try:
            field = kwargs["field"]
            layer = kwargs["layer"]
            if type(layer) is str:
                layer = self.controller.get_layer_by_tablename(layer)
            field_index = kwargs["fieldIndex"]
        except Exception as e:
            self.controller.log_info(f"{type(e).__name__} --> {e}")
            return

        if field['widgettype'] == 'text':
            if field['widgetcontrols'] and 'setQgisMultiline' in field['widgetcontrols']:
                editor_widget_setup = QgsEditorWidgetSetup(
                    'TextEdit', {'IsMultiline': field['widgetcontrols']['setQgisMultiline']})
                layer.setEditorWidgetSetup(field_index, editor_widget_setup)


    def set_read_only(self, **kwargs):
        """ Set field readOnly according to client configuration into config_api_form_fields (field 'iseditable') """

        try:
            field = kwargs["field"]
            layer = kwargs["layer"]
            if type(layer) is str:
                layer = self.controller.get_layer_by_tablename(layer)
            field_index = kwargs["fieldIndex"]
        except Exception as e:
            self.controller.log_info(f"{type(e).__name__} --> {e}")
            return
        # Get layer config
        config = layer.editFormConfig()
        try:
            # Set field editability
            config.setReadOnly(field_index, not field['iseditable'])
        except KeyError as e:
            # Control if key 'iseditable' not exist
            pass
        finally:
            # Set layer config
            layer.setEditFormConfig(config)


    def load_qml(self, **kwargs):
        """ Apply QML style located in @qml_path in @layer
        :param params:[{"funcName": "load_qml",
                        "params": {"layerName": "v_edit_arc",
                        "qmlPath": "C:\\xxxx\\xxxx\\xxxx\\qml_file.qml"}}]
        :return: Boolean value
        """

        # Get layer
        layer = self.controller.get_layer_by_tablename(kwargs['layerName']) if 'layerName' in kwargs else None
        if layer is None:
            return False

        # Get qml path
        qml_path = kwargs['qmlPath'] if 'qmlPath' in kwargs else None

        if not os.path.exists(qml_path):
            self.controller.log_warning("File not found", parameter=qml_path)
            return False

        if not qml_path.endswith(".qml"):
            self.controller.log_warning("File extension not valid", parameter=qml_path)
            return False

        layer.loadNamedStyle(qml_path)
        layer.triggerRepaint()

        return True


    #  TODO unused functions atm
    def show_message(self, **kwargs):
        """
        PERFORM pg_notify(current_user,
                  '{"functionAction":{"functions":[{"name":"show_message","parameters":
                  {"message":"line 1 \n line 2","tabName":"Notify channel",
                  "styleSheet":{"level":1,"color":"red","bold":true}}}]},"user":"postgres","schema":"api_ws_sample"}');

        functions called in -> getattr(self, function_name)(**params):
        Show message in console log,
        :param kwargs: dict with all needed
        :param kwargs['message']: message to show
        :param kwargs['tabName']: tab where the info will be displayed
        :param kwargs['styleSheet']:  define text format (message type, color, and bold), 0 = Info(black), 1 = Warning(orange), 2 = Critical(red), 3 = Success(blue), 4 = None(black)
        :param kwargs['styleSheet']['level']: 0 = Info(black), 1 = Warning(orange), 2 = Critical(red), 3 = Success(blue), 4 = None(black)
        :param kwargs['styleSheet']['color']: can be like "red", "green", "orange", "pink"...typical html colors
        :param kwargs['styleSheet']['bold']: if is true, then print as bold
        :return:
        """

        # Set default styleSheet
        color = "black"
        level = 0
        bold = ''

        msg = kwargs['message'] if 'message' in kwargs else 'No message found'
        tab_name = kwargs['tabName'] if 'tabName' in kwargs else 'Notify channel'
        if 'styleSheet' in kwargs:
            color = kwargs['styleSheet']['color'] if 'color' in kwargs['styleSheet'] else "black"
            level = kwargs['styleSheet']['level'] if 'level' in kwargs['styleSheet'] else 0
            if 'bold' in kwargs['styleSheet']:
                bold = 'b' if kwargs['styleSheet']['bold'] else ''
            else:
                bold = ''

        msg = f'<font color="{color}"><{bold}>{msg}</font>'
        QgsMessageLog.logMessage(msg, tab_name, level)


    def show_messagebox(self, **kwargs):
        """ Shows a message box with detail information """

        msg = kwargs['message'] if 'message' in kwargs else 'No message found'
        title = kwargs['title'] if 'title' in kwargs else 'New message'
        inf_text = kwargs['inf_text'] if 'inf_text' in kwargs else 'Info text'
        # color = "black"
        # bold = ''
        # if 'styleSheet' in kwargs:
        #     color = kwargs['styleSheet']['color'] if 'color' in kwargs['styleSheet'] else "black"
        #     if 'bold' in kwargs['styleSheet']:
        #         bold = 'b' if kwargs['styleSheet']['bold'] else ''
        #     else:
        #         bold = ''
        # msg = f'<font color="{color}"><{bold}>{msg}</font>'
        msg_box = QMessageBox()
        msg_box.setText(msg)
        if title:
            title = self.controller.tr(title)
            msg_box.setWindowTitle(title)
        if inf_text:
            inf_text = self.controller.tr(inf_text)
            msg_box.setInformativeText(inf_text)
        msg_box.setWindowFlags(Qt.WindowStaysOnTopHint)
        msg_box.setStandardButtons(QMessageBox.Ok)
        msg_box.setDefaultButton(QMessageBox.Ok)
        msg_box.open()

    def raise_notice(self, **kwargs):
        """ Function called in def wait_notifications(...) -->  getattr(self, function_name)(**params)
            Used to show raise notices sent by postgresql
        """

        msg_list = kwargs['msg']
        for msg in msg_list:
            self.controller.log_info(f"{msg}")


    def refreshCanvas(self, **kwargs):

        self.all_layers = []
        root = QgsProject.instance().layerTreeRoot()
        self.get_all_layers(root)
        for layer_name in self.all_layers:
            layer = self.controller.get_layer_by_tablename(layer_name)
            layer.triggerRepaint()


    def get_all_layers(self, group):

        for child in group.children():
            if isinstance(child, QgsLayerTreeLayer):
                self.all_layers.append(child.layer().name())
                child.layer().name()
            else:
                self.get_all_layers(child)