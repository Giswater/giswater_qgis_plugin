/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

INSERT INTO sys_table(id, context, description, sys_role_id, sys_criticity, qgis_criticity)
    VALUES ('ext_cat_raster', 'external catalog', 'Catalog of rasters', 'role_edit', 0, 0, false)
    ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, context, description, sys_role_id, sys_criticity, qgis_criticity)
    VALUES ('ext_raster_dem', 'external table', 'Table to store raster DEM', 'role_edit', 0, 0, false)
    ON CONFLICT (id) DO NOTHING;
 
UPDATE sys_table SET context='view from external schema'  WHERE id IN ('ext_cat_raster','ext_raster_dem');



