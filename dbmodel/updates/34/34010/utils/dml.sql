/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/05/18
SELECT setval('SCHEMA_NAME.config_typevalue_fk_id_seq', (SELECT max(id) FROM config_typevalue_fk), true);
SELECT setval('SCHEMA_NAME.sys_typevalue_cat_id_seq', (SELECT max(id) FROM sys_typevalue), true);

INSERT INTO sys_typevalue (typevalue_table,typevalue_name)
VALUES ('edit_typevalue','value_verified') ON CONFLICT (typevalue_table, typevalue_name) DO NOTHING;

INSERT INTO sys_typevalue (typevalue_table,typevalue_name)
VALUES ('edit_typevalue','value_review_status') ON CONFLICT (typevalue_table, typevalue_name) DO NOTHING;

INSERT INTO sys_typevalue (typevalue_table,typevalue_name)
VALUES ('edit_typevalue','value_review_validation') ON CONFLICT (typevalue_table,typevalue_name) DO NOTHING;


INSERT INTO config_typevalue_fk(typevalue_table, typevalue_name, target_table, target_field)
VALUES ('edit_typevalue','value_verified', 'arc', 'verified') ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;	

INSERT INTO config_typevalue_fk(typevalue_table, typevalue_name, target_table, target_field)
VALUES('edit_typevalue','value_verified', 'node', 'verified') ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;	

INSERT INTO config_typevalue_fk(typevalue_table, typevalue_name, target_table, target_field)
VALUES ('edit_typevalue','value_verified', 'connec', 'verified') ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;	

UPDATE config_form_fields SET dv_querytext = 'SELECT id, id as idval FROM edit_typevalue WHERE typevalue = ''value_verified''' where column_id = 'verified';

--2020/05/23
UPDATE sys_function SET isdeprecated = true WHERE id = 2224;
UPDATE sys_function SET isdeprecated = true WHERE id = 2226;
UPDATE sys_function SET function_name = 'gw_fct_rpt2pg_main' WHERE id = 2232;
UPDATE sys_function SET isdeprecated = true WHERE id = 2308;
UPDATE sys_function SET isdeprecated = true WHERE id = 2310;
UPDATE sys_function SET isdeprecated = false WHERE id = 2322;
UPDATE sys_function SET id = 2300 WHERE id = 2300;
UPDATE sys_function SET id = 2324 WHERE id = 2402;
UPDATE sys_function SET isdeprecated = false WHERE id = 2506;
UPDATE sys_function SET id = 2556 WHERE id = 2554;
UPDATE sys_function SET function_type ='function' WHERE id = 2720;
UPDATE sys_function SET project_type ='utils' WHERE id = 2772;
UPDATE sys_function SET project_type ='utils' WHERE id = 2790;
UPDATE sys_function SET isdeprecated = true WHERE id = 2852;

DELETE FROM sys_function WHERE id = 2704;
DELETE FROM sys_function WHERE id = 2414;
DELETE FROM sys_function WHERE id = 2860;
DELETE FROM sys_function WHERE id = 2858;
DELETE FROM sys_function WHERE id = 2434;
