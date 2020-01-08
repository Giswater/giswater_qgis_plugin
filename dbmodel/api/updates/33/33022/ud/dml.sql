/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/01/07
UPDATE config_api_form_fields SET reload_field = '{"reload":["cat_grate_matcat"]}'
WHERE column_id='gratecat_id ' and formtype='feature';

UPDATE config_api_form_fields SET reload_field = '{"reload":["cat_matcat_id"]}'
WHERE column_id='connecat_id' and formtype='feature';

UPDATE config_api_form_fields SET reload_field = '{"reload":["cat_matcat_id"]}'
WHERE column_id='nodecat_id' and formtype='feature';

UPDATE config_api_form_fields SET reload_field = '{"reload":["cat_matcat_id", "cat_shape", "cat_geom1", "cat_geom2"]}'
WHERE column_id='arccat_id ' and formtype='feature';

UPDATE config_api_form_fields SET reload_field = '{"reload":["sys_top_elev", "sys_ymax", "sys_elev"]}'
WHERE (column_id='top_elev' or column_id='custom_top_elev' or column_id='ymax' or column_id='custom_ymax' or 
column_id='elev' or column_id='custom_elev') and formtype='feature';

UPDATE config_api_form_fields SET reload_field = '{"reload":["sys_y1", "sys_elev1", "z1", "r1", "slope"]}'
WHERE (column_id='y1' or column_id='custom_y1' or column_id='elev1' or column_id='custom_elev1') and formtype='feature';

UPDATE config_api_form_fields SET reload_field = '{"reload":["sys_y2", "sys_elev2", "z2", "r2", "slope"]}'
WHERE (column_id='y2' or column_id='custom_y2' or column_id='elev2' or column_id='custom_elev2') and formtype='feature';