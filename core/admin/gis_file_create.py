"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
import shutil
# TODO: Check this - do not delete this import for the moment
from ..utils import tools_gw  # noqa: F401
from ...libs import tools_log, tools_qt, tools_db, tools_qgis


class GwGisFileCreate:

    def __init__(self, plugin_dir):

        self.plugin_dir = plugin_dir
        self.layer_source = None
        self.srid = None

    def gis_project_database(self, folder_path=None, filename=None, project_type='ws', schema='ws_sample',
                             export_passwd=False, roletype='admin', layer_source=None):

        # Get locale of QGIS application
        locale = tools_qgis.get_locale()

        # Get folder with QGS templates
        gis_extension = "qgs"
        gis_folder = self.plugin_dir + os.sep + "resources" + os.sep + "templates" + os.sep + "qgisproject"
        gis_locale_path = gis_folder + os.sep + locale

        # If QGIS template locale folder not found, use English one
        if not os.path.exists(gis_locale_path):
            msg = "Locale gis folder not found"
            tools_log.log_info(msg, parameter=gis_locale_path)
            gis_locale_path = gis_folder + os.sep + "en_US"

        # Check if template_path and folder_path exists
        template_path = f"{gis_locale_path}{os.sep}{project_type}_{roletype}.{gis_extension}"
        if not os.path.exists(template_path):
            msg = "Template GIS file not found"
            tools_qgis.show_warning(msg, parameter=template_path, duration=20)
            return False, None

        # Manage default parameters
        if folder_path is None:
            folder_path = gis_locale_path

        if filename is None:
            filename = schema

        if not os.path.exists(folder_path):
            os.mkdir(folder_path)

        # Set QGS file path
        qgs_path = folder_path + os.sep + filename + "." + gis_extension
        if os.path.exists(qgs_path):
            msg = "Do you want to overwrite file?"
            title = "Overwrite file"
            answer = tools_qt.show_question(msg, title, force_action=True)
            if not answer:
                return False, qgs_path

        # Create destination file from template file
        msg = "Creating GIS file... {0}"
        msg_params = (qgs_path)
        tools_log.log_info(msg, msg_params=msg_params)
        shutil.copyfile(template_path, qgs_path)

        # Get database parameters from layer source
        self.layer_source = layer_source
        if self.layer_source is None:
            status, self.layer_source = self._get_database_parameters(schema)
            if not status:
                return False, None

        # Read file content
        with open(qgs_path) as f:
            content = f.read()

        # Replace spatialrefsys, extent parameters, connection parameters and schema name
        content = self._replace_spatial_parameters(self.layer_source['srid'], content)
        content = self._replace_extent_parameters(schema, content)
        content = self._replace_connection_parameters(content, export_passwd)
        content = self._set_project_vars(content, export_passwd)
        content = content.replace("SCHEMA_NAME", schema)

        # Write contents and show message
        try:
            with open(qgs_path, "w") as f:
                f.write(content)
            msg = "GIS file generated successfully"
            tools_qgis.show_info(msg, parameter=qgs_path)
            msg = "Do you want to open GIS project?"
            title = "GIS file generated successfully"
            answer = tools_qt.show_question(msg, title, force_action=True)
            if answer:
                return True, qgs_path
            return False, qgs_path
        except IOError:
            msg = "File cannot be created. Check if it is already opened"
            tools_qgis.show_warning(msg, parameter=qgs_path)

    # region private functions

    def _get_database_parameters(self, schema):
        """ Get database parameters from layer source """

        layer_source, not_version = tools_db.get_layer_source_from_credentials('prefer')
        if layer_source is None:
            msg = "Error getting database parameters"
            tools_qgis.show_warning(msg)
            return False, None
        else:
            layer_source['srid'] = tools_db.get_srid('v_edit_node', schema)
            return True, layer_source

    def _replace_spatial_parameters(self, srid, content):

        aux = content
        sql = (f"SELECT 2104 as srs_id, srid, auth_name || ':' || auth_srid as auth_id "
               f"FROM spatial_ref_sys "
               f"WHERE srid = '{srid}'")
        row = tools_db.get_row(sql)

        if row:
            aux = aux.replace("__SRSID__", str(row[0]))
            aux = aux.replace("__SRID__", str(row[1]))
            aux = aux.replace("__AUTHID__", row[2])

        return aux

    def _replace_extent_parameters(self, schema_name, content):

        aux = content
        table_name = "node"
        geom_name = "the_geom"
        sql = (f"SELECT ST_XMax(gometries) AS xmax, ST_XMin(gometries) AS xmin, "
               f"ST_YMax(gometries) AS ymax, ST_YMin(gometries) AS ymin "
               f"FROM "
               f"(SELECT ST_Collect({geom_name}) AS gometries FROM {schema_name}.{table_name}) AS foo")
        row = tools_db.get_row(sql)
        if row:
            valor = row["xmin"]
            if valor is None:
                valor = -1.555992
            aux = aux.replace("__XMIN__", str(valor))

            valor = row["ymin"]
            if valor is None:
                valor = -1.000000
            aux = aux.replace("__YMIN__", str(valor))

            valor = row["xmax"]
            if valor is None:
                valor = 1.555992
            aux = aux.replace("__XMAX__", str(valor))

            valor = row["ymax"]
            if valor is None:
                valor = 1.000000
            aux = aux.replace("__YMAX__", str(valor))

        return aux

    def _replace_connection_parameters(self, content, export_passwd):

        if self.layer_source['service']:
            datasource = f"service='{self.layer_source['service']}'"

        else:
            datasource = (f"dbname='{self.layer_source['db']}' host={self.layer_source['host']} "
                          f"port={self.layer_source['port']}")

            if export_passwd:
                username = self.layer_source['user']
                password = self.layer_source['password']
                datasource += f" username={username} password={password}"

        content = content.replace("__SSLMODE__", self.layer_source['sslmode'])
        content = content.replace("__DATASOURCE__", datasource)

        return content

    def _set_project_vars(self, content, export_passwd):

        content = content.replace("__STORECREDENTIALS__", f"{export_passwd}")

        return content

    # endregion
