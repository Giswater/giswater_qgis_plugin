/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/09
SELECT gw_fct_admin_schema_manage_triggers('notify',null);

-- 13/11/2019
UPDATE config_typevalue_fk SET target_table='ext_cat_raster' WHERE target_table='cat_raster';
