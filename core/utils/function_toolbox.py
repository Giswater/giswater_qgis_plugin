"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os

from qgis.core import QgsVectorLayer, QgsVectorLayerExporter, QgsProject, QgsDataSourceUri
from qgis.PyQt.QtWidgets import QWidget

from ..utils.tools_giswater import getWidgetText, open_file_path, create_body, delete_layer_from_toc
from ... import global_vars


def gw_function_dxf(**kwargs):
    """ Function called in def add_button(self, dialog, field): -->
            widget.clicked.connect(partial(getattr(self, function_name), dialog, widget)) """

    path, filter_ = open_file_path(filter_="DXF Files (*.dxf)")
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
        value = getWidgetText(dialog, widget, add_quote=False)
        extras += f'"{widget_name}":"{value}", '
    extras = extras[:-2]
    body = create_body(extras)
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