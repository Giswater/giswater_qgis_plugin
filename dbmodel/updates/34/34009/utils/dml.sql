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

UPDATE sys_fprocess SET iscustom=false;
UPDATE sys_function SET iscustom=false;

UPDATE sys_function SET function_type = 'function' WHERE function_type IN ('api function','Function to manage messages');

INSERT INTO sys_function VALUES (2866, 'gw_fct_get_combochilds', 'utils', 'function',null, null, 'Function to manage combos', 'role_basic', FALSE, null, TRUE);
INSERT INTO sys_function VALUES (2868, 'gw_fct_getinsertformdisabled', 'utils', 'function',null, null, 'Function to manage disabled forms', 'role_basic', FALSE, null, TRUE);
INSERT INTO sys_function VALUES (2870, 'gw_fct_setselectors', 'utils', 'function',null, null, 'Function to manage selectors', 'role_basic', FALSE, null, TRUE);
INSERT INTO sys_function VALUES (2872, 'gw_fct_get_filtervaluesvdef', 'utils', 'function',null, null, 'Function to manage vdefault of filters', 'role_basic', FALSE, null, TRUE);
INSERT INTO sys_function VALUES (2874, 'gw_fct_getcolumnsfromid', 'utils', 'function',null, null, 'Function to manage colmuns from id', 'role_basic', FALSE, null, TRUE);
INSERT INTO sys_function VALUES (2876, 'gw_api_getunexpected', 'utils', 'function',null, null, 'Function to manage unspected visits', 'role_basic', FALSE, null, TRUE);
INSERT INTO sys_function VALUES (2878, 'gw_fct_getvisitsfromfeature', 'utils', 'function',null, null, 'Function to manage visit from feature', 'role_basic', FALSE, null, TRUE);
INSERT INTO sys_function VALUES (2880, 'gw_fct_setdimensioning', 'utils', 'function',null, null, 'Function to manage dimensioning', 'role_basic', FALSE, null, TRUE);
INSERT INTO sys_function VALUES (2882, 'gw_api_setvisitmanager', 'utils', 'function',null, null, 'Function to manage visit manager', 'role_basic', FALSE, null, TRUE);


INSERT INTO sys_table(id, context, description, sys_role_id, sys_criticity, qgis_criticity,  isdeprecated)
    VALUES ('config_visit_x_feature', 'visit', 'Table to configure visit class related to feature', 'role_om', 0, 0, false)
    ON CONFLICT (id) DO NOTHING;
