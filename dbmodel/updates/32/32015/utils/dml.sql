/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE audit_cat_table SET isdeprecated=true WHERE id='price_simple';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='om_visit_value_criticity';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='dattrib';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='dattrib_type';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='ext_rtc_scada_x_data';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='ext_rtc_scada_x_value';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='ext_rtc_hydrometer_x_value';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_rtc_scada';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_rtc_scada_data';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_rtc_scada_value';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='config';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='config_api_cat_widgettype';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='config_api_cat_formtemplate';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='config_api_cat_datatype';


UPDATE sys_csv2pg_cat SET readheader=false, orderby=1 WHERE id=1;
UPDATE sys_csv2pg_cat SET readheader=false, orderby=1 WHERE id=1;
UPDATE sys_csv2pg_cat SET readheader=false, orderby=2 WHERE id=3;
UPDATE sys_csv2pg_cat SET readheader=false, orderby=3  WHERE id=4;
UPDATE sys_csv2pg_cat SET readheader=true, orderby=4  WHERE id=8;
UPDATE sys_csv2pg_cat SET readheader=false, orderby=5  WHERE id=9;
UPDATE sys_csv2pg_cat SET readheader=true, orderby=6  WHERE id=10;
UPDATE sys_csv2pg_cat SET readheader=true, orderby=7  WHERE id=11;
UPDATE sys_csv2pg_cat SET readheader=true, orderby=8  WHERE id=12;
UPDATE sys_csv2pg_cat SET readheader=false, orderby=9  WHERE id=13;
UPDATE sys_csv2pg_cat SET name='Import node visits', name_i18n='Import node visits', readheader=false, orderby=10  WHERE id=14;
UPDATE sys_csv2pg_cat SET readheader=false, orderby=11  WHERE id=15;
UPDATE sys_csv2pg_cat SET readheader=false, orderby=12  WHERE id=16;
UPDATE sys_csv2pg_cat SET readheader=false, orderby=13  WHERE id=17;
UPDATE sys_csv2pg_cat SET name='Import visit file', name_i18n='import visit file', csv_structure='Import visit file', readheader=true, orderby=14  WHERE id=18;

--28/06/2019
INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2716, 'gw_fct_admin_manage_child_views', 'utils', 'function', 'Control the creation of child custom views', 'role_admin',false,false,false);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2718, 'gw_trg_edit_foreignkey', 'utils', 'trigger', 'Trigger to manage foreign keys with not possibility to create an automatic db fk', 'role_edit',false,false,false);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2720, 'gw_trg_node_interpolate', 'ud', 'function', 'Function to interpolate nodes', 'role_edit',false,false,false);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2722, 'gw_fct_admin_schema_copy', 'utils', 'function', 'Function to copy data from schema to schema', 'role_admin',false,false,false);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2724, 'gw_fct_admin_schema_manage_ct', 'utils', 'function', 'Function to admin constraints of schema', 'role_admin',false,false,false);

UPDATE audit_cat_function SET isdeprecated=true WHERE function_name='gw_trg_man_addfields_value_control';

UPDATE audit_cat_error SET error_message = 'You don''t have permissions to manage with psector', 
		hint_message = 'Please check if your profile has role_master in order to manage with plan issues' WHERE id=1080;
		
UPDATE audit_cat_error SET hint_message = 'You need to have at least one psector created to add planified elements' WHERE id=1081;


UPDATE audit_cat_function SET function_name ='gw_fct_pg2epa_main', descript='Main function of go2epa workflow' WHERE id=2646;

INSERT INTO audit_cat_function VALUES (2726, 'gw_fct_rpt2pg_main', 'utils', 'function', NULL, NULL, NULL, 'Main function of pg2epa workflow', 'role_epa', false, false, NULL, false);

INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('plan_statetype_reconstruct','4','integer', 'plan', 'Value used to identify reconstruct arcs in order to manage length of planified network') ON CONFLICT (parameter) DO NOTHING;
							
INSERT INTO price_cat_simple SELECT DISTINCT pricecat_id FROM _price_simple_ WHERE pricecat_id IS NOT NULL ON CONFLICT (id) DO NOTHING;
							
INSERT INTO price_compost SELECT id, unit, descript, text, price, pricecat_id FROM _price_simple_ ON CONFLICT (id) DO NOTHING;