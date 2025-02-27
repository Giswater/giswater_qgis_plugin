"""
Copyright © 2025 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""

# -*- coding: utf-8 -*-
import osmnx as ox
import psycopg2
from shapely.wkt import loads
from shapely.ops import transform
from pyproj import Transformer
import pandas as pd
import geopandas as gpd
import numpy as np

from functools import partial
from ..ui.ui_manager import GwAdminImportOsmUi
from ..utils import tools_gw
from ...libs import lib_vars, tools_db, tools_qgis, tools_qt
from qgis.PyQt.QtWidgets import QCheckBox
from qgis.PyQt.QtCore import Qt

ox.settings.useful_tags_way = ox.settings.useful_tags_way + ["surface"]


class GwImportOsm:

    def __init__(self):
        self.plugin_dir = lib_vars.plugin_dir
        self.schema_name = lib_vars.schema_name
        self.project_type_selected = None


    def init_dialog(self, schema_name):
        """ Constructor """
        
        self.schema_name = schema_name

        # Initialize the UI
        self.dlg_import_osm = GwAdminImportOsmUi(self)
        tools_gw.load_settings(self.dlg_import_osm)

        self.dlg_import_osm.setWindowTitle(f'Import OSM Streetaxis - {self.schema_name}')
        
        self.load_municipalities()

        self.dlg_import_osm.btn_execute.clicked.connect(partial(self.run))
        self.dlg_import_osm.btn_close.clicked.connect(partial(self.close_dialog))

        tools_gw.open_dialog(self.dlg_import_osm, dlg_name='admin_import_osm')


    def load_municipalities(self):
        """ Get municipalities and add a checkbox widget for each of them """
        sql = (f"""
            SELECT muni_id, name
            FROM {self.schema_name}.ext_municipality;
        """)
        chk_municipalities = tools_db.get_rows(sql)

        for chk_muni in chk_municipalities:
            widget = QCheckBox()
            widget.setObjectName(f'chk_{chk_muni[0]}')
            widget.setLayoutDirection(Qt.LeftToRight)
            widget.setText(chk_muni[1])
            self.dlg_import_osm.verticalLayout_checkbox.addWidget(widget)


    def run(self):
        """ Start import process """

        # Get selected municipalities
        checked_municipalities = self.get_checked_municipalities()        

        if not checked_municipalities:
            tools_qgis.show_warning("No municipalities selected", dialog=self.dlg_import_osm)
            return
        
        TABLE_NAME = "om_streetaxis"

        cur = tools_db.dao.get_cursor()        

        # Fetch `muni_id` and geometry
        cur.execute(f"""
            SELECT m.muni_id, ST_AsText(m.the_geom)
            FROM {self.schema_name}.ext_municipality m            
            WHERE m.muni_id in {checked_municipalities};
        """)
        municipalities = cur.fetchall()

        # Initialize a DataFrame to store all road edges
        all_edges = pd.DataFrame()

        # Process each municipality
        for muni_id, boundary_geom_wkt in municipalities:
            if not boundary_geom_wkt or muni_id == 0:
                tools_qgis.show_warning(f"Skipping muni_id {muni_id}: Invalid geometry", dialog=self.dlg_import_osm)
                continue

            try:
                # Convert WKT to geometry
                boundary_geom = loads(boundary_geom_wkt)

                # Transform boundary geometry to EPSG:4326
                transformer = Transformer.from_crs("EPSG:25831", "EPSG:4326", always_xy=True)
                boundary_geom = transform(transformer.transform, boundary_geom)

                # Ensure the geometry is valid
                if not boundary_geom.is_valid:
                    tools_qgis.show_warning(f"Skipping muni_id {muni_id}: Invalid geometry.", dialog=self.dlg_import_osm)
                    continue

                tools_qgis.show_info(f"Processing muni_id {muni_id}")

                # Download road network for this municipality
                graph = ox.graph_from_polygon(boundary_geom, custom_filter=None)

                # Convert the graph to a GeoDataFrame
                edges = ox.graph_to_gdfs(graph, nodes=False)

                # Add necessary columns
                edges['muni_id'] = muni_id                
                edges['code'] = edges['osmid'].apply(lambda x: x[0] if isinstance(x, list) else x)
                edges['name'] = edges['name'].fillna('Unnamed Road')

                edges['maxspeed'] = edges['maxspeed'].apply(
                    lambda x: int(x[0]) if isinstance(x, list) and x and str(x[0]).isdigit() else (
                        int(x) if pd.notna(x) and str(x).isdigit() else None))
                edges['maxspeed'] = np.where(edges['maxspeed'].isnull(), None, edges['maxspeed'])

                edges['lanes'] = edges['lanes'].apply(
                    lambda x: int(x[0]) if isinstance(x, list) and x and str(x[0]).isdigit() else (
                        int(x) if pd.notna(x) and str(x).isdigit() else 1))
                edges['oneway'] = edges['oneway'].fillna(False).astype(bool)

                # Convert NaN into None
                if 'access' not in edges:
                    edges['access'] = None
                else:
                    edges['access'] = edges['access'].replace(np.nan, None)                               

                # Set pedestrian attribute
                edges['pedestrian'] = edges['highway'].apply(lambda h: h in ['footway', 'path', 'pedestrian'])

                # Handle road type and surface attributes
                edges['road_type'] = edges['highway']
                edges['surface'] = edges['surface'].fillna('unknown') if 'surface' in edges.columns else 'unknown'

                # Transform geometries to EPSG:25831
                transformer = Transformer.from_crs("EPSG:4326", "EPSG:25831", always_xy=True)
                edges['the_geom'] = edges['geometry'].apply(lambda geom: transform(transformer.transform, geom).wkt)

                # Select required columns
                edges = edges[['code', 'name', 'the_geom', 'maxspeed', 'lanes', 'oneway',
                            'pedestrian', 'road_type', 'surface', 'muni_id', 'access']]

                # Append to the global DataFrame
                all_edges = pd.concat([all_edges, edges], ignore_index=True)

            except Exception as e:
                tools_qgis.show_warning(f"Error processing muni_id {muni_id}: {e}", dialog=self.dlg_import_osm)
                continue

        # Debug: Show summary        
        if len(all_edges) > 0:
            tools_qgis.show_info(f"Total municipalities processed: {len(all_edges['muni_id'].unique())}")

        # Insert data into the database
        errors = 0
        success = 0

        for _, row in all_edges.iterrows():
            try:            
                cur.execute(f"""
                    INSERT INTO {self.schema_name}.{TABLE_NAME} (code, name, the_geom, maxspeed, lanes, oneway, pedestrian, road_type, surface, muni_id, access_info, expl_id)
                    VALUES (%s, %s, ST_GeomFromText(%s, 25831), %s, %s, %s, %s, %s, %s, %s, %s, %s)
                """, (row['code'], row['name'], row['the_geom'], row['maxspeed'], row['lanes'], row['oneway'], row['pedestrian'],
                    row['road_type'], row['surface'], row['muni_id'], row['access'], 0))

                tools_db.dao.commit()
                success += 1

            except Exception as e:
                tools_db.dao.rollback()
                tools_qgis.show_warning(f"Error inserting row: {e}", self.dlg_import_osm)
                tools_qgis.show_warning(f"Failing data: {row.to_dict()}", self.dlg_import_osm)
                errors += 1

        try:
            cur.execute(f"""
                    UPDATE {self.schema_name}.{TABLE_NAME} as osms
                    SET expl_id = COALESCE((SELECT expl_id FROM {self.schema_name}.exploitation as exp WHERE ST_Contains(exp.the_geom, osms.the_geom) IS TRUE), 0)                 
                """)

            tools_db.dao.commit()
            success += 1
        except Exception as e:
            tools_db.dao.rollback()
            tools_qgis.show_warning(f"Error updating expl_id: {e}", self.dlg_import_osm)
            errors += 1

        # Show summary
        tools_qgis.show_info(f"Data insertion completed: {success} successful, {errors} errors.")

        # Close dialog and cursor
        cur.close()
        self.close_dialog()


    def get_checked_municipalities(self):
        """ Get selected municipalities and checks if there are already imported """

        all_munis = self.dlg_import_osm.findChildren(QCheckBox)
        selected_munis = list()

        # Get selected municipalities
        for muni in all_munis:
            if muni.isChecked():
                selected_munis.append(int(muni.objectName()[-1:]))

        # Check if selected municipalities are already on om_streetaxis
        sql = f"""
            SELECT DISTINCT muni_id
            FROM {self.schema_name}.om_streetaxis;
        """
        imported_munis = tools_db.get_rows(sql)

        if imported_munis is not None:
            for imported_muni in imported_munis:
                # Check if imported_muni is selected
                if imported_muni[0] in selected_munis:
                    # Ask if user wants to overwrite the municipaly imports       
                    result = tools_qt.show_question(f"""This municipality is already imported on om_streetaxis. Id: {imported_muni[0]}. Do you want to overwrite it?""", "Info", force_action=True)
                    if not result:
                        selected_munis.remove(imported_muni[0])
                        self.dlg_import_osm.findChild(QCheckBox, f"chk_{imported_muni[0]}").setChecked(False)                        
                        tools_qgis.show_info(f"Municipality with ID: {imported_muni[0]} deleted from selection")
                    else:
                        # Delete municipality imports
                        status = tools_db.execute_sql(f"DELETE FROM {self.schema_name}.om_streetaxis WHERE muni_id = {imported_muni[0]};", commit=False)
                        if status:
                            tools_db.dao.commit()
                        else:
                            tools_db.dao.rollback()
                            return None
                    


        # Return selected_municipalities as id list 
        #        Example: (0,1,2)
        checked_municipalities = "("        

        for muni in selected_munis:
            checked_municipalities += str(muni) + ", "

        checked_municipalities = checked_municipalities[:-2] + ")"

        if len(checked_municipalities) < 3:
            return None
    
        return checked_municipalities

    
    def close_dialog(self):
        """ Close dialog """
        tools_gw.close_dialog(self.dlg_import_osm, delete_dlg=True)

