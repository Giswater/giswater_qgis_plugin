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
UPDATE sys_table SET id ='config_typevalue_fk' WHERE id ='typevalue_fk';
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
UPDATE sys_table SET id ='config_form_images' WHERE id ='config_api_images';
UPDATE sys_table SET id ='config_info_layer' WHERE id ='config_api_layer';
UPDATE sys_table SET id ='config_form_list' WHERE id ='config_api_list';
UPDATE sys_table SET id ='config_info_table_x_type' WHERE id ='config_api_tableinfo_x_infotype';
UPDATE sys_table SET id ='config_form_typevalue' WHERE id ='config_api_typevalue';
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
UPDATE sys_table SET sys_sequence ='config_form_images_id_seq' WHERE id ='config_form_images';
UPDATE sys_table SET sys_sequence ='config_form_list_id_seq' WHERE id ='config_form_list';
UPDATE sys_table SET sys_sequence ='config_info_table_x_type_id_seq' WHERE id ='config_info_table_x_type';
UPDATE sys_table SET sys_sequence ='config_csv_id_seq' WHERE id ='config_csv';
UPDATE sys_table SET sys_sequence ='config_csv_param_id_seq' WHERE id ='config_csv_param';
UPDATE sys_table SET sys_sequence ='samplepoint_id_seq' WHERE id ='samplepoint';
UPDATE sys_table SET sys_sequence ='audit_arc_traceability_id_seq' WHERE id ='audit_arc_traceability';
UPDATE sys_table SET sys_sequence ='config_typevalue_fk_id_seq' WHERE id ='config_typevalue_fk';
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

