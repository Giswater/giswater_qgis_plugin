/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



INSERT INTO sys_fprocess_cat VALUES (35, 'Recursive go2epa process', 'EPA', 'Recursive go2epa process', 'utils');
INSERT INTO sys_fprocess_cat VALUES (36, 'admin check, fk and unique constraints', 'admin', 'admin check,fk and unique constraints', 'utils');
INSERT INTO sys_fprocess_cat VALUES (37, 'admin not null contraints', 'admin', 'admin not null constraints', 'utils');
INSERT INTO sys_fprocess_cat VALUES (38, 'Check inconsistency on editable data', 'edit', 'Check inconsistency on editable data', 'utils');


-- 2019/01/31
INSERT INTO sys_csv2pg_cat VALUES (10, 'Export inp', 'Export inp', null, 'role_epa');
INSERT INTO sys_csv2pg_cat VALUES (11, 'Import rpt', 'Import rpt', null, 'role_epa');
INSERT INTO sys_csv2pg_cat VALUES (12, 'Import inp', 'Import inp', null, 'role_admin');

-- 2019/02/08
SELECT setval('SCHEMA_NAME.config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('vdefault_rtc_period_seconds','2592000','integer', 'rtc', 'Default value used if ext_cat_period doesn''t have date values or they are incorrect');

-- 2019/03/11
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('plan_statetype_ficticius','1','integer', 'plan', 'Value used to identify ficticius arcs in case of new creation on planning operations to keep topology');


-- 2019/02/14
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('customer_code_autofill', 'FALSE', 'boolean', 'System', 'If TRUE, when insert a new connec customer_code will be the same as connec_id');


