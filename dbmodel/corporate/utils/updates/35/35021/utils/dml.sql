/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


INSERT INTO sys_table (id, descript,sys_role)
VALUES ('address','Table of entrance numbers.','role_edit') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table (id, descript,sys_role)
VALUES ('district','Catalog of districts.','role_edit') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table (id, descript,sys_role)
VALUES ('municipality','Table of town cities and villages.','role_edit') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table (id, descript,sys_role)
VALUES ('plot','Table of urban properties.','role_edit') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table (id, descript,sys_role)
VALUES ('streetaxis','Table of streetaxis.','role_edit') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table (id, descript,sys_role)
VALUES ('type_street','Catalog of street types.','role_edit') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table (id, descript,sys_role)
VALUES ('cat_raster','Catalog of rasters.','role_edit') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table (id, descript,sys_role)
VALUES ('raster_dem','Table to store raster DEM.','role_edit') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table (id, descript,sys_role)
VALUES ('config_param_system','Configuration table of system parameters.','role_admin') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table (id, descript,sys_role)
VALUES ('sys_table','Table with the information of tables and views of the project.','role_admin') ON CONFLICT (id) DO NOTHING;