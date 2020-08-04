/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/05/18
SELECT setval('SCHEMA_NAME.sys_foreingkey_id_seq', (SELECT max(id) FROM sys_foreignkey), true);
SELECT setval('SCHEMA_NAME.sys_typevalue_cat_id_seq', (SELECT max(id) FROM sys_typevalue), true);

INSERT INTO sys_typevalue (typevalue_table,typevalue_name)
VALUES ('edit_typevalue','value_verified') ON CONFLICT (typevalue_table, typevalue_name) DO NOTHING;

INSERT INTO sys_typevalue (typevalue_table,typevalue_name)
VALUES ('edit_typevalue','value_review_status') ON CONFLICT (typevalue_table, typevalue_name) DO NOTHING;

INSERT INTO sys_typevalue (typevalue_table,typevalue_name)
VALUES ('edit_typevalue','value_review_validation') ON CONFLICT (typevalue_table,typevalue_name) DO NOTHING;


INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field)
VALUES ('edit_typevalue','value_verified', 'arc', 'verified') ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;	

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field)
VALUES('edit_typevalue','value_verified', 'node', 'verified') ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;	

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field)
VALUES ('edit_typevalue','value_verified', 'connec', 'verified') ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;	

UPDATE config_form_fields SET dv_querytext = 'SELECT id, id as idval FROM edit_typevalue WHERE typevalue = ''value_verified''' where column_id = 'verified';

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field)
VALUES ('plan_typevalue','value_priority', 'plan_psector', 'plan_psector') ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;	

UPDATE config_form_fields SET dv_querytext = 'SELECT idval as id,idval FROM plan_typevalue WHERE typevalue=''value_priority''' WHERE formname = 'v_edit_plan_psector' 
and column_id = 'priority';

--2020/05/23
UPDATE sys_function SET isdeprecated = true WHERE id = 2224;
UPDATE sys_function SET isdeprecated = true WHERE id = 2226;
UPDATE sys_function SET function_name = 'gw_fct_rpt2pg_main', project_type='ws' WHERE id = 2322;
UPDATE sys_function SET function_name = 'gw_fct_rpt2pg_main', project_type='ud' WHERE id = 2726;
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

DELETE FROM sys_function WHERE function_name = 'gw_fct_repair_arc_searchnodes';
DELETE FROM sys_function WHERE function_name = 'gw_fct_get_widgetjson';





--2020/05/25
UPDATE sys_table SET id ='config_csv_param' WHERE id ='sys_csv2pg_config';
UPDATE sys_table SET id ='sys_fprocess' WHERE id ='sys_process_cat';
UPDATE sys_table SET id ='sys_typevalue' WHERE id ='sys_typevalue_cat';
UPDATE sys_table SET id ='sys_function' WHERE id ='audit_cat_function';
UPDATE sys_table SET id ='config_toolbox' WHERE id ='audit_cat_function';
UPDATE sys_table SET id ='config_csv' WHERE id ='sys_csv2pg_cat';
DELETE FROM sys_table WHERE id ='audit_check_feature';
DELETE FROM sys_table WHERE id ='audit_log_feature';
DELETE FROM sys_table WHERE id ='audit_log_project';
DELETE FROM sys_table WHERE id ='audit_log_csv';
UPDATE sys_table SET id ='audit_arc_traceability' WHERE id ='audit_log_arc_traceability';
UPDATE sys_table SET id ='sys_param_user' WHERE id ='audit_cat_param_user';
UPDATE sys_table SET id ='sys_message' WHERE id ='audit_cat_error';
UPDATE sys_table SET id ='sys_table' WHERE id ='audit_cat_table';
UPDATE sys_table SET id ='sys_sequence' WHERE id ='audit_cat_sequence';
DELETE FROM sys_table WHERE id ='audit_cat_column';
DELETE FROM sys_table WHERE id ='audit_price_simple';
DELETE FROM sys_table WHERE id ='config_api_visit';
UPDATE sys_table SET id ='config_mincut_inlet' WHERE id ='anl_mincut_inlet_x_exploitation';
UPDATE sys_table SET id ='config_mincut_valve' WHERE id ='anl_mincut_selector_valve';
UPDATE sys_table SET id ='config_mincut_checkvalve' WHERE id ='anl_mincut_checkvalve';
UPDATE sys_table SET id ='sys_foreignkey' WHERE id ='typevalue_fk';
UPDATE sys_table SET id ='selector_mincut_result' WHERE id ='anl_mincut_result_selector';
UPDATE sys_table SET id ='selector_inp_demand' WHERE id ='inp_selector_dscenario';
UPDATE sys_table SET id ='selector_inp_hydrology' WHERE id ='inp_selector_hydrology';
UPDATE sys_table SET id ='selector_inp_result' WHERE id ='inp_selector_result';
UPDATE sys_table SET id ='selector_sector' WHERE id ='inp_selector_sector';
UPDATE sys_table SET id ='selector_rpt_compare' WHERE id ='rpt_selector_compare';
UPDATE sys_table SET id ='selector_rpt_main' WHERE id ='rpt_selector_result';
UPDATE sys_table SET id ='selector_plan_psector' WHERE id ='plan_psector_selector';
UPDATE sys_table SET id ='selector_plan_result' WHERE id ='plan_result_selector';
UPDATE sys_table SET id ='config_form_actions' WHERE id ='config_api_form_actions';
UPDATE sys_table SET id ='config_form' WHERE id ='config_api_form';
UPDATE sys_table SET id ='config_form_fields' WHERE id ='config_api_form_fields';
UPDATE sys_table SET id ='config_form_groupbox' WHERE id ='config_api_form_groupbox';
UPDATE sys_table SET id ='config_form_tabs' WHERE id ='config_api_form_tabs';
UPDATE sys_table SET id ='sys_image' WHERE id ='config_api_images';
UPDATE sys_table SET id ='config_info_layer' WHERE id ='config_api_layer';
UPDATE sys_table SET id ='config_form_list' WHERE id ='config_api_list';
UPDATE sys_table SET id ='config_info_layer_x_type' WHERE id ='config_api_tableinfo_x_infotype';
UPDATE sys_table SET id ='config_typevalue' WHERE id ='config_api_typevalue';
UPDATE sys_table SET id ='config_form_tableview' WHERE id ='config_client_forms';
UPDATE sys_table SET id ='om_mincut_cat_type' WHERE id ='anl_mincut_cat_type';
UPDATE sys_table SET id ='om_mincut' WHERE id ='anl_mincut_result_cat';
UPDATE sys_table SET id ='om_mincut_arc' WHERE id ='anl_mincut_result_arc';
UPDATE sys_table SET id ='om_mincut_node' WHERE id ='anl_mincut_result_node';
UPDATE sys_table SET id ='om_mincut_connec' WHERE id ='anl_mincut_result_connec';
UPDATE sys_table SET id ='om_mincut_hydrometer' WHERE id ='anl_mincut_result_hydrometer';
UPDATE sys_table SET id ='om_mincut_polygon' WHERE id ='anl_mincut_result_polygon';
UPDATE sys_table SET id ='om_mincut_valve' WHERE id ='anl_mincut_result_valve';
UPDATE sys_table SET id ='om_mincut_valve_unaccess' WHERE id ='anl_mincut_result_valve_unaccess';
UPDATE sys_table SET id ='v_om_mincut_initpoint' WHERE id ='v_anl_mincut_init_point';
UPDATE sys_table SET id ='v_om_mincut_planned_arc' WHERE id ='v_anl_mincut_planified_arc';
UPDATE sys_table SET id ='v_om_mincut_planned_valve' WHERE id ='v_anl_mincut_planified_valve';
UPDATE sys_table SET id ='v_om_mincut_audit' WHERE id ='v_anl_mincut_result_audit';
UPDATE sys_table SET id ='v_om_mincut' WHERE id ='v_anl_mincut_result_cat';
UPDATE sys_table SET id ='v_om_mincut_conflict_arc' WHERE id ='v_anl_mincut_result_conflict_arc';
UPDATE sys_table SET id ='v_om_mincut_conflict_valve' WHERE id ='v_anl_mincut_result_conflict_valve';
UPDATE sys_table SET id ='v_om_mincut_arc' WHERE id ='v_anl_mincut_result_arc';
UPDATE sys_table SET id ='v_om_mincut_connec' WHERE id ='v_anl_mincut_result_connec';
UPDATE sys_table SET id ='v_om_mincut_hydrometer' WHERE id ='v_anl_mincut_result_hydrometer';
UPDATE sys_table SET id ='v_om_mincut_node' WHERE id ='v_anl_mincut_result_node';
UPDATE sys_table SET id ='v_om_mincut_polygon' WHERE id ='v_anl_mincut_result_polygon';
UPDATE sys_table SET id ='v_om_mincut_valve' WHERE id ='v_anl_mincut_result_valve';
UPDATE sys_table SET id ='v_ui_mincut' WHERE id ='v_ui_anl_mincut_result_cat';
UPDATE sys_table SET id ='v_om_mincut_selected_valve' WHERE id ='v_anl_mincut_selected_valve';
DELETE FROM sys_table WHERE id ='value_verified';
DELETE FROM sys_table WHERE id ='value_review_status';
DELETE FROM sys_table WHERE id ='value_review_validation';
DELETE FROM sys_table WHERE id ='value_yesno';
			
UPDATE sys_table SET id ='selector_rpt_compare_tstep' WHERE id ='rpt_selector_hourly_compare';
UPDATE sys_table SET id ='selector_rpt_compare_tstep' WHERE id ='rpt_selector_timestep_compare';
UPDATE sys_table SET id ='selector_rpt_main_tstep' WHERE id ='rpt_selector_hourly';
UPDATE sys_table SET id ='selector_rpt_main_tstep' WHERE id ='rpt_selector_timestep';
						
DELETE FROM sys_table WHERE id ='anl_mincut_cat_cause';
DELETE FROM sys_table WHERE id ='anl_mincut_cat_class';		
DELETE FROM sys_table WHERE id ='anl_mincut_cat_state';		
DELETE FROM sys_table WHERE id ='sys_sequence';		
DELETE FROM sys_table WHERE id ='audit_log_csv2pg';		


UPDATE sys_table SET sys_sequence ='config_form_fields_id_seq' WHERE id ='config_form_fields';
UPDATE sys_table SET sys_sequence ='config_form_groupbox_id_seq' WHERE id ='config_form_groupbox';
UPDATE sys_table SET sys_sequence ='config_form_id_seq' WHERE id ='config_form';
UPDATE sys_table SET sys_sequence ='config_form_layout_id_seq' WHERE id ='config_form_layout';
UPDATE sys_table SET sys_sequence ='sys_image_id_seq' WHERE id ='sys_image';
UPDATE sys_table SET sys_sequence ='config_form_list_id_seq' WHERE id ='config_form_list';
UPDATE sys_table SET sys_sequence ='config_info_layer_x_type_id_seq' WHERE id ='config_info_layer_x_type';
UPDATE sys_table SET sys_sequence ='config_csv_id_seq' WHERE id ='config_csv';
UPDATE sys_table SET sys_sequence ='config_csv_param_id_seq' WHERE id ='config_csv_param';
UPDATE sys_table SET sys_sequence ='samplepoint_id_seq' WHERE id ='samplepoint';
UPDATE sys_table SET sys_sequence ='audit_arc_traceability_id_seq' WHERE id ='audit_arc_traceability';
UPDATE sys_table SET sys_sequence ='sys_foreingkey_id_seq' WHERE id ='sys_foreignkey';
UPDATE sys_table SET sys_sequence ='om_mincut_polygon_polygon_seq' WHERE id ='om_mincut_polygon';

UPDATE sys_table SET sys_sequence ='om_mincut_polygon_polygon_seq' WHERE id ='om_mincut_polygon';

UPDATE sys_table SET sys_sequence ='config_form_tableview_id_seq' WHERE id ='config_form_tableview';

UPDATE sys_table SET sys_sequence ='config_mincut_inlet_id_seq' WHERE id ='config_mincut_inlet';

UPDATE sys_table SET sys_sequence = replace (sys_sequence, 'anl_mincut_result', 'om_mincut');

UPDATE sys_function SET function_name = 'gw_fct_get_featureinfo' WHERE function_name = 'gw_api_get_featureinfo';
UPDATE sys_function SET function_name = 'gw_fct_get_featureupsert' WHERE function_name = 'gw_api_get_featureupsert';
UPDATE sys_function SET function_name = 'gw_fct_get_formfields' WHERE function_name = 'gw_api_get_formfields';
UPDATE sys_function SET function_name = 'gw_fct_get_combochilds' WHERE function_name = 'gw_api_get_combochilds';
UPDATE sys_function SET function_name = 'gw_fct_getinsertformdisabled' WHERE function_name = 'gw_api_getinsertformdisabled';
UPDATE sys_function SET function_name = 'gw_fct_setselectors' WHERE function_name = 'gw_api_setselectors';
UPDATE sys_function SET function_name = 'gw_fct_get_filtervaluesvdef' WHERE function_name = 'gw_api_get_filtervaluesvdef';
UPDATE sys_function SET function_name = 'gw_fct_getunexpected' WHERE function_name = 'gw_api_getunexpected';
UPDATE sys_function SET function_name = 'gw_fct_getcolumnsfromid' WHERE function_name = 'gw_api_getcolumnsfrom_id';
UPDATE sys_function SET function_name = 'gw_fct_getvisitsfromfeature' WHERE function_name = 'gw_api_getvisitsfromfeature';
UPDATE sys_function SET function_name = 'gw_fct_setdimensioning' WHERE function_name = 'gw_api_setdimensioning';
UPDATE sys_function SET function_name = 'gw_fct_setvisitmanager' WHERE function_name = 'gw_api_setvisitmanager';
UPDATE sys_function SET function_name = 'gw_fct_setvehicleload' WHERE function_name = 'gw_api_setvehicleload';
UPDATE sys_function SET function_name = 'gw_fct_getprint' WHERE function_name = 'gw_fct_api_getprint';
UPDATE sys_function SET function_name = 'gw_fct_setprint' WHERE function_name = 'gw_fct_api_setprint';
UPDATE sys_function SET function_name = 'gw_fct_get_visit' WHERE function_name = 'gw_api_get_visit';
UPDATE sys_function SET function_name = 'gw_fct_get_widgetjson' WHERE function_name = 'gw_api_get_widgetjson';
UPDATE sys_function SET function_name = 'gw_fct_get_widgetvalues' WHERE function_name = 'gw_api_get_widgetvalues';
UPDATE sys_function SET function_name = 'gw_fct_getattributetable' WHERE function_name = 'gw_api_getattributetable';
UPDATE sys_function SET function_name = 'gw_fct_getchilds' WHERE function_name = 'gw_api_getchilds';
UPDATE sys_function SET function_name = 'gw_fct_getconfig' WHERE function_name = 'gw_api_getconfig';
UPDATE sys_function SET function_name = 'gw_fct_getdimensioning' WHERE function_name = 'gw_api_getdimensioning';
UPDATE sys_function SET function_name = 'gw_fct_getfeatureinsert' WHERE function_name = 'gw_api_getfeatureinsert';
UPDATE sys_function SET function_name = 'gw_fct_getgeometry' WHERE function_name = 'gw_api_getgeometry';
UPDATE sys_function SET function_name = 'gw_fct_getgo2epa' WHERE function_name = 'gw_api_getgo2epa';
UPDATE sys_function SET function_name = 'gw_fct_getinfocrossection' WHERE function_name = 'gw_api_getinfocrossection';
UPDATE sys_function SET function_name = 'gw_fct_getinfofromcoordinates' WHERE function_name = 'gw_api_getinfofromcoordinates';
UPDATE sys_function SET function_name = 'gw_fct_getinfofromid' WHERE function_name = 'gw_api_getinfofromid';
UPDATE sys_function SET function_name = 'gw_fct_getinfofromlist' WHERE function_name = 'gw_api_getinfofromlist';
UPDATE sys_function SET function_name = 'gw_fct_getinfoplan' WHERE function_name = 'gw_api_getinfoplan';
UPDATE sys_function SET function_name = 'gw_fct_getinsertfeature' WHERE function_name = 'gw_api_getinsertfeature';
UPDATE sys_function SET function_name = 'gw_fct_getlayersfromcoordinates' WHERE function_name = 'gw_api_getlayersfromcoordinates';
UPDATE sys_function SET function_name = 'gw_fct_getlist' WHERE function_name = 'gw_api_getlist';
UPDATE sys_function SET function_name = 'gw_fct_getpermissions' WHERE function_name = 'gw_api_getpermissions';
UPDATE sys_function SET function_name = 'gw_fct_getrowinsert' WHERE function_name = 'gw_api_getrowinsert';
UPDATE sys_function SET function_name = 'gw_fct_getsearch' WHERE function_name = 'gw_api_getsearch';
UPDATE sys_function SET function_name = 'gw_fct_getselectors' WHERE function_name = 'gw_api_getselectors';
UPDATE sys_function SET function_name = 'gw_fct_gettoolbarbuttons' WHERE function_name = 'gw_api_gettoolbarbuttons';
UPDATE sys_function SET function_name = 'gw_fct_gettoolbox' WHERE function_name = 'gw_api_gettoolbox';
UPDATE sys_function SET function_name = 'gw_fct_gettypeahead' WHERE function_name = 'gw_api_gettypeahead';
UPDATE sys_function SET function_name = 'gw_fct_getvisit' WHERE function_name = 'gw_api_getvisit';
UPDATE sys_function SET function_name = 'gw_fct_getvisitmanager' WHERE function_name = 'gw_api_getvisitmanager';
UPDATE sys_function SET function_name = 'gw_fct_setconfig' WHERE function_name = 'gw_api_setconfig';
UPDATE sys_function SET function_name = 'gw_fct_setdelete' WHERE function_name = 'gw_api_setdelete';
UPDATE sys_function SET function_name = 'gw_fct_setfields' WHERE function_name = 'gw_api_setfields';
UPDATE sys_function SET function_name = 'gw_fct_setfileinsert' WHERE function_name = 'gw_api_setfileinsert';
UPDATE sys_function SET function_name = 'gw_fct_setgo2epa' WHERE function_name = 'gw_api_setgo2epa';
UPDATE sys_function SET function_name = 'gw_fct_setinsert' WHERE function_name = 'gw_api_setinsert';
UPDATE sys_function SET function_name = 'gw_fct_setsearch' WHERE function_name = 'gw_api_setsearch';
UPDATE sys_function SET function_name = 'gw_fct_setsearchadd' WHERE function_name = 'gw_api_setsearch_add';
UPDATE sys_function SET function_name = 'gw_fct_setvisit' WHERE function_name = 'gw_api_setvisit';
UPDATE sys_function SET function_name = 'gw_fct_setvisitmanagerend' WHERE function_name = 'gw_api_setvisitmanagerend';
UPDATE sys_function SET function_name = 'gw_fct_setvisitmanagerstart' WHERE function_name = 'gw_api_setvisitmanagerstart';
UPDATE sys_function SET function_name = 'gw_fct_admin_manage_ct' WHERE function_name = 'gw_fct_admin_schema_manage_ct';
UPDATE sys_function SET function_name = 'gw_fct_admin_manage_triggers' WHERE function_name = 'gw_fct_admin_schema_manage_triggers';
UPDATE sys_function SET function_name = 'gw_fct_admin_rename_fixviews' WHERE function_name = 'gw_fct_admin_schema_rename_fixviews';
UPDATE sys_function SET function_name = 'gw_fct_admin_schema_clone' WHERE function_name = 'gw_fct_clone_schema';
UPDATE sys_function SET function_name = 'gw_fct_import_addfields' WHERE function_name = 'gw_fct_utils_csv2pg_import_addfields';
UPDATE sys_function SET function_name = 'gw_fct_import_dbprices' WHERE function_name = 'gw_fct_utils_csv2pg_import_dbprices';
UPDATE sys_function SET function_name = 'gw_fct_import_elements' WHERE function_name = 'gw_fct_utils_csv2pg_import_elements';
UPDATE sys_function SET function_name = 'gw_fct_import_epanet_inp' WHERE function_name = 'gw_fct_utils_csv2pg_import_epanet_inp';
UPDATE sys_function SET function_name = 'gw_fct_import_omvisit' WHERE function_name = 'gw_fct_utils_csv2pg_import_omvisit';
UPDATE sys_function SET function_name = 'gw_fct_import_omvisitlot' WHERE function_name = 'gw_fct_utils_csv2pg_import_omvisitlot';
UPDATE sys_function SET function_name = 'gw_fct_import_swmm_inp' WHERE function_name = 'gw_fct_utils_csv2pg_import_swmm_inp';
UPDATE sys_function SET function_name = 'gw_fct_import_timeseries' WHERE function_name = 'gw_fct_utils_csv2pg_import_timeseries';
UPDATE sys_function SET function_name = 'gw_fct_import_blockdxf' WHERE function_name = 'gw_fct_utils_csv2pg_importblock';
UPDATE sys_function SET function_name = 'gw_fct_export_ui_xml' WHERE function_name = 'gw_fct_utils_export_ui_xml';
UPDATE sys_function SET function_name = 'gw_fct_import_ui_xml' WHERE function_name = 'gw_fct_utils_import_ui_xml';
UPDATE sys_function SET function_name = 'gw_fct_import_ui_xml' WHERE function_name = 'gw_fct_utils_import_ui_xml';
DELETE FROM sys_function WHERE function_name = 'gw_fct_mincut_inlet_flowtrace';

UPDATE config_form_fields SET formname = 'visit_manager' WHERE formname = 'visitManager';

UPDATE sys_table SET sys_sequence = null WHERE id like 'v_inp_vertice';

UPDATE sys_table SET id = 'config_user_x_expl' WHERE id = 'exploitation_x_user';


INSERT INTO sys_function VALUES (2116, 'gw_fct_audit_function','utils','function','void','void','Function to work with messages','role_basic',true) 
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2126, 'gw_fct_node_replace','utils','function','character varying, character varying, date, boolean','character varying','Function used to replace a node','role_edit',false) 
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2890, 'gw_fct_plan_result_rec','utils','function','integer, double precision, text','integer','Function to calculate costs of reconstruction','role_master',false) 
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2892, 'gw_fct_plan_result_reh','utils','function','integer, double precision, text','integer','Function to calculate costs of rehabilitation','role_master',false) 
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2894, 'gw_fct_pg2epa_main','ud','function','json','json','Main function to export epa files','role_epa',false) 
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2431, 'gw_fct_pg2epa_check_data','ud','function','json','json','Function to check result data before inp file creation (it depends only of the whole network consistency)','role_epa',false) 
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2464, 'gw_fct_setvalurn','utils','function','void','int8','Function to set value of urn sequence','role_edit',false) 
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2922, 'gw_fct_admin_role_resetuserprofile','utils','function','json','json','Function to reset user profile values','role_admin',false) 
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2568, 'gw_fct_getcatalog','utils','function','json','json','Function to provide catalog form','role_edit',false) 
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2896, 'gw_fct_createwidgetjson','utils','function','text, text, text, text, text, boolean, text','json','Creates a widget','role_basic',false) 
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2898, 'gw_fct_getlot','utils','function','json','json','Function to provide lot form','role_om',false) 
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2900, 'gw_fct_getprojectvisitforms','utils','function','json','json','Function to provide project visit form','role_om',false) 
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2902, 'gw_fct_pg2epa_inlet_flowtrace','ws','function','text ','integer','Analyze the whole result network checking topological inconsistency','role_epa',false) 
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2904, 'gw_fct_odbc2pg_hydro_filldata','utils','function','json','json','Analyze data for the odbc2pg hdyro data','role_epa',false) 
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2906, 'gw_fct_pg2epa_advancedsettings','ud','function','text ','integer','Provides user defined advanced settings on go2epa process','role_epa',false) 
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2908, 'gw_fct_pg2epa_vdefault','ud','function','json','integer','Function to set default values on go2epa process','role_epa',false) 
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2910, 'gw_fct_pg2epa_manage_varc','ud','function','character varying','json','Function to manage with virtual arcs on go2epa process','role_epa',false) 
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2912, 'gw_fct_setvehicleload','utils','function','json','json','Function to set loads of vehicles (vehicle management)','role_om',false) 
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2858, 'gw_fct_pg2epa_check_result','ud','function','json','json','Function to check result data before inp file creation (it depends for each result)','role_epa',false) 
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2860, 'gw_fct_pg2epa_check_options','ud','function','json','json','Function to check options before inp file creation (it depends for each result)','role_epa',false) 
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2920, 'gw_fct_rpt2pg_import_rpt','ud','function','json','json','Function to import results','role_epa',false) 
ON CONFLICT (id) DO NOTHING;


UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2314;
UPDATE sys_function SET input_params ='character varying, integer', return_type ='void' WHERE id =2324;
UPDATE sys_function SET input_params ='void', return_type ='void' WHERE id =2556;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2642;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2644;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2712;
UPDATE sys_function SET input_params ='json', return_type ='void' WHERE id =2752;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2772;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2790;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2802;
UPDATE sys_function SET input_params ='json', return_type ='void' WHERE id =2804;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2850;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2862;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2102;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2104;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2106;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2108;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2110;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2112;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2114;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2118;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2120;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2122;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2124;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2128;
UPDATE sys_function SET input_params ='character varying, character varying, integer, character varying', return_type ='integer' WHERE id =2130;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2202;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2204;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2206;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2208;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2210;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2212;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2214;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2216;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2218;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2220;
UPDATE sys_function SET input_params ='void', return_type ='character varying' WHERE id =2228;
UPDATE sys_function SET input_params ='void', return_type ='void' WHERE id =2230;
UPDATE sys_function SET input_params ='character varying', return_type ='integer' WHERE id =2234;
UPDATE sys_function SET input_params ='text', return_type ='integer' WHERE id =2238;
UPDATE sys_function SET input_params ='character varying', return_type ='integer' WHERE id =2240;
UPDATE sys_function SET input_params ='aux geometry, aux geometry, var double precision, var double precision, point integer, bool boolean ', return_type ='geometry' WHERE id =2242;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2244;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2302;
UPDATE sys_function SET input_params ='character varying, character varying, integer ', return_type ='json' WHERE id =2304;
UPDATE sys_function SET input_params ='character varying, integer', return_type ='void' WHERE id =2306;
UPDATE sys_function SET input_params ='character varying, integer, text', return_type ='void' WHERE id =2312;
UPDATE sys_function SET input_params ='character varying, boolean', return_type ='integer' WHERE id =2316;
UPDATE sys_function SET input_params ='text ', return_type ='integer' WHERE id =2318;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2322;
UPDATE sys_function SET input_params ='character varying', return_type ='integer' WHERE id =2328;
UPDATE sys_function SET input_params ='character varying', return_type ='integer' WHERE id =2330;
UPDATE sys_function SET input_params ='character varying', return_type ='integer' WHERE id =2332;
UPDATE sys_function SET input_params ='enabled_aux text', return_type ='void' WHERE id =2422;
UPDATE sys_function SET input_params ='character varying', return_type ='void' WHERE id =2424;
UPDATE sys_function SET input_params ='character varying', return_type ='text' WHERE id =2426;
UPDATE sys_function SET input_params ='character varying', return_type ='void' WHERE id =2428;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2430;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2436;
UPDATE sys_function SET input_params ='integer, geometry, double precision', return_type ='void' WHERE id =2438;
UPDATE sys_function SET input_params ='character varying', return_type ='integer' WHERE id =2456;
UPDATE sys_function SET input_params ='void', return_type ='json' WHERE id =2496;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2504;
UPDATE sys_function SET input_params ='text, double precision, double precision', return_type ='json' WHERE id =2508;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2510;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2512;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2514;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2516;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2520;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2522;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2524;
UPDATE sys_function SET input_params ='character varying, text', return_type ='json' WHERE id =2526;
UPDATE sys_function SET input_params ='character varying, text', return_type ='json' WHERE id =2528;
UPDATE sys_function SET input_params ='integer, default 0, default 0', return_type ='character varying' WHERE id =2534;
UPDATE sys_function SET input_params ='void', return_type ='void' WHERE id =2550;
UPDATE sys_function SET input_params ='void', return_type ='void' WHERE id =2552;
UPDATE sys_function SET input_params ='character varying, character varying, integer, integer, boolean, text, text, text', return_type ='json' WHERE id =2558;
UPDATE sys_function SET input_params ='character varying, character varying, public.geometry, integer, integer, character varying, boolean, text, text', return_type ='json' WHERE id =2560;
UPDATE sys_function SET input_params ='character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, json', return_type ='text []' WHERE id =2562;
UPDATE sys_function SET input_params ='text, text, text, text, text, boolean, text', return_type ='json' WHERE id =2564;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2566;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2570;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2572;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2574;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2576;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2578;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2580;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2582;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2584;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2586;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2588;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2590;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2592;
UPDATE sys_function SET input_params ='json, integer', return_type ='json' WHERE id =2594;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2596;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2598;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2600;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2602;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2604;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2606;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2608;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2610;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2612;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2614;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2616;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2618;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2620;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2622;
UPDATE sys_function SET input_params ='json, text ', return_type ='json' WHERE id =2624;
UPDATE sys_function SET input_params ='json, text, anyelement', return_type ='json' WHERE id =2626;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2628;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2630;
UPDATE sys_function SET input_params ='void', return_type ='integer' WHERE id =2634;
UPDATE sys_function SET input_params ='json', return_type ='void' WHERE id =2636;
UPDATE sys_function SET input_params ='void', return_type ='integer' WHERE id =2638;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2640;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2650;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2660;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2670;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2680;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2682;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2684;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2690;
UPDATE sys_function SET input_params ='text, boolean', return_type ='json' WHERE id =2692;
UPDATE sys_function SET input_params ='text, boolean', return_type ='json' WHERE id =2694;
UPDATE sys_function SET input_params ='integer ', return_type ='text' WHERE id =2696;
UPDATE sys_function SET input_params ='json', return_type ='void' WHERE id =2700;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2706;
UPDATE sys_function SET input_params ='json', return_type ='integer' WHERE id =2708;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2710;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2714;
UPDATE sys_function SET input_params ='json', return_type ='void' WHERE id =2716;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2718;
UPDATE sys_function SET input_params ='json', return_type ='void' WHERE id =2722;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2724;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2725;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2726;
UPDATE sys_function SET input_params ='character varying', return_type ='json' WHERE id =2728;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2734;
UPDATE sys_function SET input_params ='json', return_type ='void' WHERE id =2735;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2736;
UPDATE sys_function SET input_params ='void', return_type ='integer' WHERE id =2738;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2746;
UPDATE sys_function SET input_params ='json', return_type ='void' WHERE id =2748;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2760;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2762;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2764;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2766;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2768;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2770;
UPDATE sys_function SET input_params ='text ', return_type ='integer' WHERE id =2774;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2776;
UPDATE sys_function SET input_params ='character varying', return_type ='integer' WHERE id =2778;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2780;
UPDATE sys_function SET input_params ='integer ', return_type ='integer' WHERE id =2300;
UPDATE sys_function SET input_params ='text ', return_type ='json' WHERE id =2782;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2784;
UPDATE sys_function SET input_params ='void', return_type ='json' WHERE id =2786;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2788;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2792;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2794;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2796;
UPDATE sys_function SET input_params ='text ', return_type ='integer' WHERE id =2798;
UPDATE sys_function SET input_params ='text ', return_type ='integer' WHERE id =2800;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2802;
UPDATE sys_function SET input_params ='void', return_type ='json' WHERE id =2806;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2810;
UPDATE sys_function SET input_params ='text, text ', return_type ='void' WHERE id =2818;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2822;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2824;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2826;
UPDATE sys_function SET input_params ='integer, json', return_type ='json' WHERE id =2828;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2830;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2832;
UPDATE sys_function SET input_params ='json', return_type ='integer' WHERE id =2846;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2848;
UPDATE sys_function SET input_params ='character varying', return_type ='integer' WHERE id =2854;
UPDATE sys_function SET input_params ='character varying, character varying, character varying', return_type ='json' WHERE id =2868;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2870;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2872;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2874;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2876;
UPDATE sys_function SET input_params ='character varying, character varying, integer,  timestamp without time zone, timestamp without time zone', return_type ='json' WHERE id =2878;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2880;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2882;
UPDATE sys_function SET input_params ='json', return_type ='json' WHERE id =2884;


UPDATE sys_message SET id = 3112 WHERE id = 10;
UPDATE sys_message SET id = 3114 WHERE id = 20;
UPDATE sys_message SET id = 3116 WHERE id = 30;
UPDATE sys_message SET id = 3118 WHERE id = 40;
UPDATE sys_message SET id = 3120 WHERE id = 50;
UPDATE sys_message SET id = 3122 WHERE id = 60;
UPDATE sys_message SET id = 3124 WHERE id = 70;
UPDATE sys_message SET id = 3126 WHERE id = 80;
UPDATE sys_message SET id = 3128 WHERE id = 90;
UPDATE sys_message SET id = 3130 WHERE id = 100;

DELETE FROM sys_message WHERE id=3004;
DELETE FROM sys_message WHERE id=1108;

UPDATE sys_message SET project_type='ws' WHERE id=3006;
UPDATE sys_message SET project_type='ws' WHERE id=3002;
UPDATE sys_message SET project_type='utils' WHERE id=2122;
UPDATE sys_message SET project_type='utils' WHERE id=2120;
UPDATE sys_message SET project_type='utils' WHERE id=2110;
UPDATE sys_message SET project_type='utils' WHERE id=2108;
UPDATE sys_message SET project_type='ws' WHERE id=2106;
UPDATE sys_message SET project_type='ws' WHERE id=2104;
UPDATE sys_message SET project_type='ws' WHERE id=2102;
UPDATE sys_message SET project_type='ws' WHERE id=2100;
UPDATE sys_message SET project_type='ws' WHERE id=2098;
UPDATE sys_message SET project_type='ws' WHERE id=2096;
UPDATE sys_message SET project_type='utils' WHERE id=2094;
UPDATE sys_message SET project_type='utils' WHERE id=2092;
UPDATE sys_message SET project_type='utils' WHERE id=2090;
UPDATE sys_message SET project_type='utils' WHERE id=2088;
UPDATE sys_message SET project_type='utils' WHERE id=2086;
UPDATE sys_message SET project_type='utils' WHERE id=2084;
UPDATE sys_message SET project_type='utils' WHERE id=2082;
UPDATE sys_message SET project_type='utils' WHERE id=2080;
UPDATE sys_message SET project_type='utils' WHERE id=2078;
UPDATE sys_message SET project_type='ud' WHERE id=2076;
UPDATE sys_message SET project_type='ud' WHERE id=2074;
UPDATE sys_message SET project_type='ws' WHERE id=2072;
UPDATE sys_message SET project_type='ws' WHERE id=2070;
UPDATE sys_message SET project_type='ud' WHERE id=2068;
UPDATE sys_message SET project_type='ud' WHERE id=2066;
UPDATE sys_message SET project_type='ud' WHERE id=2064;
UPDATE sys_message SET project_type='ud' WHERE id=2062;
UPDATE sys_message SET project_type='ud' WHERE id=2060;
UPDATE sys_message SET project_type='ud' WHERE id=2058;
UPDATE sys_message SET project_type='ud' WHERE id=2056;
UPDATE sys_message SET project_type='ud' WHERE id=2054;
UPDATE sys_message SET project_type='utils' WHERE id=2052;
UPDATE sys_message SET project_type='ud' WHERE id=2050;
UPDATE sys_message SET project_type='ud' WHERE id=2048;
UPDATE sys_message SET project_type='utils' WHERE id=2046;
UPDATE sys_message SET project_type='ws' WHERE id=2044;
UPDATE sys_message SET project_type='utils' WHERE id=2042;
UPDATE sys_message SET project_type='utils' WHERE id=2040;
UPDATE sys_message SET project_type='ud' WHERE id=2038;
UPDATE sys_message SET project_type='utils' WHERE id=2036;
UPDATE sys_message SET project_type='utils' WHERE id=2034;
UPDATE sys_message SET project_type='utils' WHERE id=2032;
UPDATE sys_message SET project_type='utils' WHERE id=2030;
UPDATE sys_message SET project_type='utils' WHERE id=2028;
UPDATE sys_message SET project_type='ws' WHERE id=2026;
UPDATE sys_message SET project_type='utils' WHERE id=2024;
UPDATE sys_message SET project_type='utils' WHERE id=2022;
UPDATE sys_message SET project_type='utils' WHERE id=2020;
UPDATE sys_message SET project_type='utils' WHERE id=2018;
UPDATE sys_message SET project_type='utils' WHERE id=2016;
UPDATE sys_message SET project_type='utils' WHERE id=2015;
UPDATE sys_message SET project_type='utils' WHERE id=2014;
UPDATE sys_message SET project_type='utils' WHERE id=2012;
UPDATE sys_message SET project_type='utils' WHERE id=2010;
UPDATE sys_message SET project_type='utils' WHERE id=2008;
UPDATE sys_message SET project_type='utils' WHERE id=2006;
UPDATE sys_message SET project_type='utils' WHERE id=2004;
UPDATE sys_message SET project_type='utils' WHERE id=2002;
UPDATE sys_message SET project_type='utils' WHERE id=1110;
UPDATE sys_message SET project_type='ws' WHERE id=1106;
UPDATE sys_message SET project_type='utils' WHERE id=1104;
UPDATE sys_message SET project_type='utils' WHERE id=1102;
UPDATE sys_message SET project_type='utils' WHERE id=1100;
UPDATE sys_message SET project_type='utils' WHERE id=1098;
UPDATE sys_message SET project_type='utils' WHERE id=1097;
UPDATE sys_message SET project_type='utils' WHERE id=1096;
UPDATE sys_message SET project_type='utils' WHERE id=1094;
UPDATE sys_message SET project_type='utils' WHERE id=1092;
UPDATE sys_message SET project_type='utils' WHERE id=1090;
UPDATE sys_message SET project_type='utils' WHERE id=1088;
UPDATE sys_message SET project_type='utils' WHERE id=1086;
UPDATE sys_message SET project_type='utils' WHERE id=1084;
UPDATE sys_message SET project_type='utils' WHERE id=1083;
UPDATE sys_message SET project_type='utils' WHERE id=1082;
UPDATE sys_message SET project_type='utils' WHERE id=1081;
UPDATE sys_message SET project_type='utils' WHERE id=1080;
UPDATE sys_message SET project_type='ud' WHERE id=1078;
UPDATE sys_message SET project_type='utils' WHERE id=1076;
UPDATE sys_message SET project_type='utils' WHERE id=1074;
UPDATE sys_message SET project_type='utils' WHERE id=1072;
UPDATE sys_message SET project_type='utils' WHERE id=1070;
UPDATE sys_message SET project_type='ud' WHERE id=1068;
UPDATE sys_message SET project_type='utils' WHERE id=1066;
UPDATE sys_message SET project_type='utils' WHERE id=1064;
UPDATE sys_message SET project_type='utils' WHERE id=1062;
UPDATE sys_message SET project_type='utils' WHERE id=1060;
UPDATE sys_message SET project_type='utils' WHERE id=1058;
UPDATE sys_message SET project_type='utils' WHERE id=1056;
UPDATE sys_message SET project_type='utils' WHERE id=1054;
UPDATE sys_message SET project_type='utils' WHERE id=1052;
UPDATE sys_message SET project_type='utils' WHERE id=1050;
UPDATE sys_message SET project_type='ws' WHERE id=1048;
UPDATE sys_message SET project_type='utils' WHERE id=1046;
UPDATE sys_message SET project_type='utils' WHERE id=1044;
UPDATE sys_message SET project_type='utils' WHERE id=1042;
UPDATE sys_message SET project_type='utils' WHERE id=1040;
UPDATE sys_message SET project_type='utils' WHERE id=1038;
UPDATE sys_message SET project_type='utils' WHERE id=1036;
UPDATE sys_message SET project_type='utils' WHERE id=1034;
UPDATE sys_message SET project_type='utils' WHERE id=1032;
UPDATE sys_message SET project_type='utils' WHERE id=1030;
UPDATE sys_message SET project_type='utils' WHERE id=1028;
UPDATE sys_message SET project_type='utils' WHERE id=1026;
UPDATE sys_message SET project_type='ud' WHERE id=1024;
UPDATE sys_message SET project_type='utils' WHERE id=1022;
UPDATE sys_message SET project_type='utils' WHERE id=1020;
UPDATE sys_message SET project_type='utils' WHERE id=1018;
UPDATE sys_message SET project_type='utils' WHERE id=1016;
UPDATE sys_message SET project_type='utils' WHERE id=1014;
UPDATE sys_message SET project_type='utils' WHERE id=1012;
UPDATE sys_message SET project_type='utils' WHERE id=1010;
UPDATE sys_message SET project_type='utils' WHERE id=1008;
UPDATE sys_message SET project_type='utils' WHERE id=1006;
UPDATE sys_message SET project_type='utils' WHERE id=1004;



DELETE FROM sys_function WHERE id = 2594;
UPDATE sys_function SET input_params = 'json' WHERE id = 2820;

UPDATE sys_table SET sys_sequence = null where id = 'config_user_x_expl';



UPDATE sys_function SET function_name = 'gw_fct_feature_delete' WHERE function_name = 'gw_fct_set_delete_feature';
UPDATE sys_function SET function_name = 'gw_fct_link_repair' WHERE function_name = 'gw_fct_repair_link';
UPDATE sys_function SET function_name = 'gw_fct_arc_repair' WHERE function_name = 'gw_fct_repair_arc';
UPDATE sys_function SET function_name = 'gw_fct_psector_duplicate' WHERE function_name = 'gw_fct_duplicate_psector';
UPDATE sys_function SET function_name = 'gw_fct_node_builtfromarc' WHERE function_name = 'gw_fct_built_nodefromarc';
UPDATE sys_function SET function_name = 'gw_fct_getfeaturerelation' WHERE function_name = 'gw_fct_get_feature_relation';
UPDATE sys_function SET function_name = 'gw_fct_getcombochilds' WHERE function_name = 'gw_fct_get_combochilds';
UPDATE sys_function SET function_name = 'gw_fct_getfeatureinfo' WHERE function_name = 'gw_fct_get_featureinfo';
UPDATE sys_function SET function_name = 'gw_fct_getfeatureupsert' WHERE function_name = 'gw_fct_get_featureupsert';
UPDATE sys_function SET function_name = 'gw_fct_getfiltervaluesvdef' WHERE function_name =	'gw_fct_get_filtervaluesvdef';
UPDATE sys_function SET function_name = 'gw_fct_getformfields' WHERE function_name = 'gw_fct_get_formfields';
UPDATE sys_function SET function_name = 'gw_fct_getvisit_main' WHERE function_name = 'gw_fct_get_visit';
UPDATE sys_function SET function_name = 'gw_fct_getwidgetvalues' WHERE function_name = 'gw_fct_get_widgetvalues';


DELETE FROM sys_function WHERE function_name IN ('gw_trg_edit_man_arc', 'gw_trg_edit_man_node', 'gw_trg_edit_man_connec', 'gw_trg_edit_man_gully');
INSERT INTO sys_function VALUES ('1314', 'gw_trg_ui_visitman', 'utils', 'trigger function', NULL, NULL, NULL, 'role_om') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES ('1132', 'gw_trg_plan_psector_x_node', 'utils', 'trigger function', NULL, NULL, NULL, 'role_master') ON CONFLICT (id) DO NOTHING;
UPDATE sys_function SET function_name = 'gw_trg_edit_om_visit' WHERE id=1118;
UPDATE sys_function SET function_name = 'gw_trg_edit_config_sysfields' WHERE id=2742;
UPDATE sys_function SET function_name = 'gw_fct_setlot' WHERE id=2862;
INSERT INTO sys_function VALUES ('2648', 'gw_trg_calculate_period', 'utils', 'trigger function', NULL, NULL, NULL, 'role_epa') ON CONFLICT (id) DO NOTHING;
DELETE FROM sys_function WHERE id = 1102;
UPDATE sys_function SET project_type='ws' WHERE id=2846;
UPDATE sys_function SET function_name = 'gw_fct_pg2epa_valve_status' WHERE id=2332;
UPDATE sys_function SET function_name = 'gw_fct_pg2epa_buildup_supply' WHERE id=2774;
UPDATE sys_function SET function_name = 'gw_fct_om_visit_multiplier' WHERE id=2802;
UPDATE sys_function SET function_name = 'gw_fct_mincut_inverted_flowtrace_engine' WHERE id=2324;
UPDATE sys_function SET function_name = 'gw_fct_import_dxfblock' WHERE id=2504;
UPDATE sys_function SET function_name = 'gw_fct_admin_rename_fixviews' WHERE id=2636;
UPDATE sys_function SET function_name = 'gw_fct_admin_manage_addfields' WHERE id=2690;
UPDATE sys_function SET function_name = 'gw_trg_arc_noderotation_update' WHERE id=1346;
UPDATE sys_function SET function_name = 'gw_fct_node_interpolate' WHERE id=2720;
UPDATE sys_function SET project_type='ws' WHERE id=2854;
UPDATE sys_function SET project_type='ws' WHERE id=2646;
UPDATE sys_function SET project_type='ws' WHERE id=2848;
UPDATE sys_function SET project_type='ws' WHERE id=2850;
UPDATE sys_function SET project_type='ws' WHERE id=2430;
UPDATE sys_function SET project_type='ws' WHERE id=2798;
INSERT INTO sys_function VALUES ('2320', 'gw_fct_mincut_inverted_flowtrace', 'utils', 'trigger function', NULL, NULL, NULL, 'role_om') ON CONFLICT (id) DO NOTHING;
UPDATE sys_function SET project_type='utils' WHERE id=2788;
DELETE FROM sys_function WHERE id = 2828;
UPDATE sys_function SET project_type='utils' WHERE id=2740;
UPDATE sys_function SET project_type='utils' WHERE id=2796;

INSERT INTO sys_function VALUES ('2930', 'gw_trg_visit_expl', 'utils', 'trigger function', NULL, NULL, NULL, 'role_basic') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES ('2932', 'gw_trg_ui_rpt_cat_result', 'utils', 'trigger function', NULL, NULL, NULL, 'role_epa') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES ('2934', 'gw_trg_ui_event', 'utils', 'trigger function', NULL, NULL, NULL, 'role_om') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES ('2936', 'gw_trg_plan_psector_x_connec', 'utils', 'trigger function', NULL, NULL, NULL, 'role_master') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES ('2938', 'gw_trg_plan_psector_link', 'utils', 'trigger function', NULL, NULL, NULL, 'role_master') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES ('2940', 'gw_trg_plan_psector_geom', 'utils', 'trigger function', NULL, NULL, NULL, 'role_master') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES ('2942', 'gw_trg_om_visit_singlevent', 'utils', 'trigger function', NULL, NULL, NULL, 'role_om') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES ('2944', 'gw_trg_om_visit_multievent' ,'utils', 'trigger function', NULL, NULL, NULL, 'role_om') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES ('2946', 'gw_trg_notify', 'utils', 'trigger function', NULL, NULL, NULL, 'role_basic') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES ('2948', 'gw_trg_node_statecontrol', 'utils', 'trigger function', NULL, NULL, NULL, 'role_basic') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES ('1146', 'gw_trg_node_arc_divide', 'utils', 'trigger function', NULL, NULL, NULL, 'role_basic') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES ('2950', 'gw_trg_edit_streetaxis', 'utils', 'trigger function', NULL, NULL, NULL, 'role_basic') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES ('2952', 'gw_trg_edit_plot', 'utils', 'trigger function', NULL, NULL, NULL, 'role_basic') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES ('2954', 'gw_trg_edit_macrodqa', 'ws', 'trigger function', NULL, NULL, NULL, 'role_basic') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES ('2956', 'gw_trg_edit_cad_aux', 'utils', 'trigger function', NULL, NULL, NULL, 'role_basic') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES ('2958', 'gw_trg_edit_address', 'utils', 'trigger function', NULL, NULL, NULL, 'role_basic') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES ('2960', 'gw_trg_ui_hydroval_connec', 'ws', 'trigger function', NULL, NULL, NULL, 'role_basic') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES ('1316', 'gw_trg_ui_visit', 'utils', 'trigger function', NULL, NULL, NULL, 'role_basic') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES ('2962', 'gw_trg_ui_mincut_result_cat', 'ws', 'trigger function', NULL, NULL, NULL, 'role_om') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES ('1348', 'gw_trg_node_rotation_update', 'utils', 'trigger function', NULL, NULL, NULL, 'role_edit') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES ('2964', 'gw_fct_getprofile', 'utils', 'trigger function', NULL, NULL, NULL, 'role_om') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES ('2966', 'gw_fct_setprofile', 'utils', 'trigger function', NULL, NULL, NULL, 'role_om') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES ('2968', 'gw_trg_plan_psector_x_gully', 'ud', 'trigger function', NULL, NULL, NULL, 'role_master') ON CONFLICT (id) DO NOTHING;

