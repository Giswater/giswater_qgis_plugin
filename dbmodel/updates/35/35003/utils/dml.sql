/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/02/27
INSERT INTO sys_fprocess VALUES (367, 'Check graf config', 'ws');

INSERT INTO sys_function VALUES (3026, 'gw_fct_setchangevalvestatus', 'ws', 'function', 'json', 'json', 'Function that changes status valve', 'role_om');


--2021/03/01
DELETE FROM config_param_user WHERE parameter = 'qgis_toolbar_hidebuttons';
DELETE FROM sys_param_user WHERE id = 'qgis_toolbar_hidebuttons';

DELETE FROM sys_function WHERE id = 2784 OR id = 2786;
DELETE FROM sys_fprocess WHERE fid = 206;

UPDATE sys_function set sample_query=NULL WHERE sample_query='false';


UPDATE value_state SET name = 'OPERATIVE' WHERE name ='ON_SERVICE';
UPDATE value_state SET name = 'OPERATIVO' WHERE name ='EN_SERVICIO';
UPDATE value_state SET name = 'OPERATIU' WHERE name ='EN_SERVEI';

UPDATE value_state_type SET name = 'OPERATIVE' WHERE name ='ON_SERVICE';
UPDATE value_state_type SET name = 'OPERATIVO' WHERE name ='EN_SERVICIO';
UPDATE value_state_type SET name = 'OPERATIU' WHERE name ='EN_SERVEI';


--2021/03/05
INSERT INTO sys_function VALUES (3028, 'gw_fct_getaddfeaturevalues', 'utils', 'function', 'json', 'json', 'Function that return cat_feature values', 'role_basic');
INSERT INTO sys_function VALUES (3030, 'gw_fct_debugsql', 'utils', 'function', 'json', 'json', 'Function that allows debugging giving error information', 'role_basic');


--2021/03/25

UPDATE config_form_list SET columnname = 'not_used';
ALTER TABLE config_form_list DROP CONSTRAINT config_form_list_pkey;
ALTER TABLE config_form_list ADD CONSTRAINT "config_form_list_pkey" PRIMARY KEY ("tablename", "device", "listtype", "columnname");

UPDATE config_form_fields SET dv_parent_id = 'muni_id' WHERE formname = 'v_om_mincut' AND columnname = 'streetname' AND formtype ='form_feature';
UPDATE config_form_fields SET dv_parent_id = 'matcat_id' WHERE formname = 'upsert_catalog_arc' AND columnname = 'matcat_id' AND formtype ='form_catalog';
UPDATE config_form_fields SET dv_parent_id = 'matcat_id' WHERE formname = 'upsert_catalog_node' AND columnname = 'matcat_id' AND formtype ='form_catalog';
UPDATE config_form_fields SET dv_parent_id = 'matcat_id' WHERE formname = 'upsert_catalog_connec' AND columnname = 'matcat_id' AND formtype ='form_catalog';


UPDATE config_form_fields SET tabname = 'main';
UPDATE config_form_fields set tabname = 'data' WHERE formtype = 'form_feature' AND formname ILIKE 've_%_%';
ALTER TABLE config_form_fields DROP CONSTRAINT config_form_fields_pkey;
ALTER TABLE config_form_fields ADD CONSTRAINT config_form_fields_pkey PRIMARY KEY(formname, formtype, columnname, tabname);

