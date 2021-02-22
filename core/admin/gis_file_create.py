"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
import shutil

from ...lib import tools_log, tools_qt, tools_db, tools_qgis
from ..utils import tools_gw


class GwGisFileCreate:

    def __init__(self, plugin_dir):

        self.plugin_dir = plugin_dir
        self.host = None
        self.port = None
        self.db = None
        self.user = None
        self.password = None
        self.srid = None


    def gis_project_database(self, folder_path=None, filename=None, project_type='ws', schema='ws_sample',
                             export_passwd=False, roletype='admin', chk_sample=False, get_database_parameters=True):

        # Get locale of QGIS application
        locale = tools_qgis.get_locale()
        
        # Get folder with QGS templates
        gis_extension = "qgs"
        gis_folder = self.plugin_dir + os.sep + "resources" + os.sep + "templates" + os.sep + "qgisproject"
        gis_locale_path = gis_folder + os.sep + locale

        # If QGIS template locale folder not found, use English one
        if not os.path.exists(gis_locale_path):
            tools_log.log_info("Locale gis folder not found", parameter=gis_locale_path)
            gis_locale_path = gis_folder + os.sep + "en_US"

        # Check if template_path and folder_path exists
        # Set default project for type sample
        if chk_sample:
            roletype = 'admin_sample'

        template_path = f"{gis_locale_path}{os.sep}{project_type}_{roletype}.{gis_extension}"
        if not os.path.exists(template_path):
            tools_qgis.show_warning("Template GIS file not found", parameter=template_path, duration=20)
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
            message = "Do you want to overwrite file?"
            answer = tools_qt.show_question(message, "overwrite file")
            if not answer:
                return False, qgs_path

        # Create destination file from template file
        tools_log.log_info("Creating GIS file... " + qgs_path)
        shutil.copyfile(template_path, qgs_path)

        if get_database_parameters:
            # Get database parameters from layer source
            status = self._get_database_parameters(schema)
            if not status:
                return False, None

        # Read file content
        with open(qgs_path) as f:
            content = f.read()

        # Connect to sqlite database
        sqlite_conn, self.cursor = tools_gw.create_sqlite_conn("srid")

        # Replace spatialrefsys and extent parameters
        content = self._replace_spatial_parameters(self.srid, content, sqlite_conn)
        content = self._replace_extent_parameters(schema, content)

        # Replace SCHEMA_NAME for schemaName parameter. SRID_VALUE for srid parameter
        content = content.replace("SCHEMA_NAME", schema)
        content = content.replace("SRID_VALUE", str(self.srid))

        # Replace __DBNAME__ for db parameter. __HOST__ for host parameter, __PORT__ for port parameter
        content = content.replace("__DBNAME__", self.db)
        content = content.replace("__HOST__", self.host)

        # Manage username and password
        credentials = self.port
        if export_passwd:
            credentials = self.port + " username=" + self.user + " password=" + self.password
        content = content.replace("__PORT__", credentials)

        # Write contents and show message
        try:
            with open(qgs_path, "w") as f:
                f.write(content)
            tools_qgis.show_info("GIS file generated successfully", parameter=qgs_path)
            message = "Do you want to open GIS project?"
            answer = tools_qt.show_question(message, "GIS file generated successfully")
            if answer:
                return True, qgs_path
            return False, qgs_path
        except IOError:
            message = "File cannot be created. Check if it is already opened"
            tools_qgis.show_warning(message, parameter=qgs_path)


    def set_database_parameters(self, host, port, db, user, password, srid):

        self.host = host
        self.port = port
        self.db = db
        self.user = user
        self.password = password
        self.srid = srid


    # region private functions

    def _get_database_parameters(self, schema):
        """ Get database parameters from layer source """

        layer_source, not_version = tools_db.get_layer_source_from_credentials('disable')
        if layer_source is None:
            tools_qgis.show_warning("Error getting database parameters")
            return False

        self.set_database_parameters(layer_source['host'], layer_source['port'], layer_source['db'],
                                     layer_source['user'], layer_source['password'],
                                     tools_db.get_srid('v_edit_node', schema))

        return True


    def _replace_spatial_parameters(self, srid, content, sqlite_conn):

        aux = content
        if sqlite_conn:
            sql = (f"SELECT parameters, srs_id, srid, auth_name || ':' || auth_id as auth_id, description, "
                   f"projection_acronym, is_geo "
                   f"FROM srs "
                   f"WHERE srid = '{srid}'")
            self.cursor.execute(sql)
            row = self.cursor.fetchone()

        else:
            sql = (f"SELECT proj4text as parameters, 2104 as srs_id, srid, auth_name || ':' || auth_srid as auth_id, "
                   f"'ETRS89 / UTM zone 31N' as description, 'UTM' as projection_acronym, 0 as is_geo "
                   f"FROM spatial_ref_sys "
                   f"WHERE srid = '{srid}'")
            row = tools_db.get_row(sql)

        if row:
            aux = aux.replace("__PROJ4__", row[0])
            aux = aux.replace("__SRSID__", str(row[1]))
            aux = aux.replace("__SRID__", str(row[2]))
            aux = aux.replace("__AUTHID__", row[3])
            aux = aux.replace("__DESCRIPTION__", row[4])
            aux = aux.replace("__PROJECTIONACRONYM__", row[5])
            geo = "false"
            if row[6] != 0:
                geo = "true"
            aux = aux.replace("__GEOGRAPHICFLAG__", geo)

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

    # endregion