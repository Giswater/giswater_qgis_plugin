/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2019/01/26
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2640, 'gw_api_getvisitmanager', 'role_om', FALSE, 'To call visit from user');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2642, 'gw_api_setvisitmanager', 'role_om', FALSE,'To update values');


-- 2019/01/31
INSERT INTO sys_csv2pg_cat VALUES (10, 'Export inp', 'Export inp', null, 'role_epa');
INSERT INTO sys_csv2pg_cat VALUES (11, 'Import rpt', 'Import rpt', null, 'role_epa');
INSERT INTO sys_csv2pg_cat VALUES (12, 'Import inp', 'Import inp', null, 'role_admin');

-- 2019/02/02
UPDATE audit_cat_function SET istoolbox=TRUE,  descript=return_type, context=project_type, project_type='utils', function_type='{"featureType":"node"}', 
return_type=null, input_params='[{"name":"nodeTolerance", "type":"float"}]' , sys_role_id='role_edit', isparametric=true WHERE function_name='gw_fct_anl_node_duplicated';

-- 2019/02/08
SELECT setval('SCHEMA_NAME.config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('vdefault_rtc_period_seconds','2592000','integer', 'rtc', 'Default value used if ext_cat_period doesn''t have date values or they are incorrect');

-- 2019/02/14
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('customer_code_autofill', 'FALSE', 'boolean', 'System', 'If TRUE, when insert a new connec customer_code will be the same as connec_id');
