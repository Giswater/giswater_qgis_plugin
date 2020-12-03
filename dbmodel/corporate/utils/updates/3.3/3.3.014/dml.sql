/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

INSERT INTO audit_cat_table(id, description, sys_role_id, sys_criticity, qgis_criticity)
    VALUES ('ext_cat_raster', 'Catalog of rasters', 'role_edit', 0, 0)
    ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_table(id, description, sys_role_id, sys_criticity, qgis_criticity)
    VALUES ('ext_raster_dem', 'Table to store raster DEM', 'role_edit', 0, 0)
    ON CONFLICT (id) DO NOTHING;


