/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','NETWORK','NETWORK');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES(3308, 'gw_fct_admin_create_message', 'utils', 'function', 'json', 'json', 'Function to create sys_message efficiently', 'role_admin', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_typevalue VALUES (
'tabname_typevalue','tab_municipality','tab_municipality','tabMunicipality');

INSERT INTO config_form_tabs VALUES ('selector_basic','tab_municipality','Muni','Municipality','role_basic',NULL,NULL,0,'{4,5}');

INSERT INTO config_param_system VALUES (
'basic_selector_tab_municipality',
'{"table":"ext_municipality","selector":"selector_municipality","table_id":"muni_id","selector_id":"muni_id","label":"muni_id, ''- '', name","orderBy":"muni_id","manageAll":true,"selectionMode":"keepPreviousUsingShift","query_filter":"AND muni_id > 0","typeaheadFilter":" AND lower(concat(muni_id, '' - '', name))","typeaheadForced":true,"explFromMuni":true}',
'Variable to configura all options related to search for the specificic tab','Selector variables',NULL,NULL,FALSE,NULL,'utils',NULL,NULL,'json','text');

UPDATE config_form_fields SET widgettype='combo',
dv_querytext='SELECT id, id as idval FROM sys_feature_type WHERE classlevel = 1 OR classlevel = 2',
dv_orderby_id=true WHERE formname='v_edit_dimensions' AND formtype='form_feature' AND columnname='feature_type' AND tabname='tab_none';

-- 21/06/2024
DELETE FROM sys_foreignkey WHERE typevalue_name = 'psector_type' AND target_table='plan_psector';
DELETE FROM plan_typevalue WHERE typevalue='psector_type' AND id='1';

INSERT INTO edit_typevalue VALUES ('presszone_type', 'BUSTER', 'BUSTER');
INSERT INTO edit_typevalue VALUES ('presszone_type', 'TANK', 'TANK');
INSERT INTO edit_typevalue VALUES ('presszone_type', 'PRV', 'PRV');
INSERT INTO edit_typevalue VALUES ('presszone_type', 'PSV', 'PSV');
INSERT INTO edit_typevalue VALUES ('presszone_type', 'PUMP', 'PUMP');
INSERT INTO edit_typevalue VALUES ('presszone_type', 'UNDEFINED', 'UNDEFINED');