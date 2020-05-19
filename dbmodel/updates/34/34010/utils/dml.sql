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
