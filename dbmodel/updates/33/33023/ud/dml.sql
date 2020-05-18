/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/01/10
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, csvversion) 
VALUES (80, 11, 'rpt_control_actions_taken', 'Control Actions', '{"from":"5.0.022", "to":null,"language":"english"}');

--2020/01/20
UPDATE config_api_form_fields SET reload_field = '{"reload":["cat_matcat_id", "cat_shape", "cat_geom1", "cat_geom2"]}',
isautoupdate = TRUE
WHERE column_id='arccat_id' and formtype='feature';


UPDATE config_api_form_fields SET iseditable = 'FALSE'
WHERE column_id='slope' and formtype='feature';