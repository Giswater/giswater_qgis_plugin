/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/25

-- system param updates
DELETE FROM config_param_system WHERE parameter = 'custom_giswater_folder';
DELETE FROM config_param_system WHERE parameter = 'sys_scada_schema';
DELETE FROM config_param_system WHERE parameter = 'sys_utils_schema';
DELETE FROM config_param_system WHERE parameter = 'chk_state_topo';
DELETE FROM config_param_system WHERE parameter = 'link_searchbuffer';
DELETE FROM config_param_system WHERE parameter = 'nodetype_change_enabled';
DELETE FROM config_param_system WHERE parameter = 'inventory_update_date';
DELETE FROM config_param_system WHERE parameter = 'rev_node_depth_tol';
DELETE FROM config_param_system WHERE parameter = 'rev_node_top_elev_tol';
DELETE FROM config_param_system WHERE parameter = 'rev_node_ymax_tol';
DELETE FROM config_param_system WHERE parameter = 'rev_node_geom1_tol';
DELETE FROM config_param_system WHERE parameter = 'rev_node_geom2_tol';
DELETE FROM config_param_system WHERE parameter = 'rev_arc_y2_tol';
DELETE FROM config_param_system WHERE parameter = 'rev_arc_geom1_tol';
DELETE FROM config_param_system WHERE parameter = 'rev_arc_geom2_tol';
DELETE FROM config_param_system WHERE parameter = 'rev_connec_y2_tol';
DELETE FROM config_param_system WHERE parameter = 'rev_connec_geom1_tol';
DELETE FROM config_param_system WHERE parameter = 'rev_connec_geom2_tol';
DELETE FROM config_param_system WHERE parameter = 'rev_gully_ymax_tol';
DELETE FROM config_param_system WHERE parameter = 'rev_gully_sandbox_tol';
DELETE FROM config_param_system WHERE parameter = 'rev_gully_connec_geom1_tol';
DELETE FROM config_param_system WHERE parameter = 'rev_gully_connec_geom2_tol';
DELETE FROM config_param_system WHERE parameter = 'rev_gully_units_tol';
DELETE FROM config_param_system WHERE parameter = 'sys_api_service';
DELETE FROM config_param_system WHERE parameter = 'sys_custom_views';
DELETE FROM config_param_system WHERE parameter = 'code_vd';
DELETE FROM config_param_system WHERE parameter = 'audit_function_control';
DELETE FROM config_param_system WHERE parameter = 'node2arc';
DELETE FROM config_param_system WHERE parameter = 'api_sensibility_factor_mobile';
DELETE FROM config_param_system WHERE parameter = 'api_sensibility_factor_desktop';
DELETE FROM config_param_system WHERE parameter = 'inp_fast_buildup';
DELETE FROM config_param_system WHERE parameter = 'api_selector_label';
DELETE FROM config_param_system WHERE parameter = 'profile_stylesheet';

UPDATE config_param_system SET parameter = 'basic_info_sensibility_factor', value ='{"mobile":2, "web":1, "desktop":1}', context='system',
descript='Sensibility factor web', label='Sensibility factor web:' WHERE parameter = 'api_sensibility_factor_web';
UPDATE config_param_system SET parameter = 'edit_review_node_tolerance', value ='{"topelev":1, "elevation":1, "depth":1, "ymax":1}'
WHERE parameter = 'rev_node_elevation_tol';
UPDATE config_param_system SET parameter = 'edit_review_arc_tolerance', value ='{"y1":1,"y2":1}' WHERE parameter = 'rev_arc_y1_tol';
UPDATE config_param_system SET parameter = 'edit_review_connec_tolerance', value ='{"y1":1,"y2":1}'	WHERE parameter = 'rev_connec_y1_tol';
UPDATE config_param_system SET parameter = 'edit_review_gully_tolerance', value ='{"topelev":1, "ymax":1,"sandbox":0.1, "units":1}'
WHERE parameter = 'rev_gully_top_elev_tol';
UPDATE config_param_system SET parameter = 'admin_crm_schema' WHERE parameter = 'sys_crm_schema';
UPDATE config_param_system SET parameter = 'admin_currency' WHERE parameter = 'sys_currency';
UPDATE config_param_system SET parameter = 'admin_crm_script_folderpath', label='Folder to store scripts to execute daily'
WHERE parameter = 'crm_daily_script_folderpath';
UPDATE config_param_system SET parameter = 'admin_daily_updates' WHERE parameter = 'sys_daily_updates';
UPDATE config_param_system SET parameter = 'admin_daily_updates_mails' WHERE parameter = 'daily_update_mails';
UPDATE config_param_system SET parameter = 'admin_exploitation_x_user' WHERE parameter = 'sys_exploitation_x_user';
UPDATE config_param_system SET parameter = 'admin_i18n_update_mode' WHERE parameter = 'i18n_update_mode';
UPDATE config_param_system SET parameter = 'admin_python_folderpath', label='Folder to path for python' WHERE parameter = 'python_folderpath';
UPDATE config_param_system SET parameter = 'admin_raster_dem' WHERE parameter = 'sys_raster_dem';
UPDATE config_param_system SET parameter = 'admin_role_permisions' WHERE parameter = 'sys_role_permissions';
UPDATE config_param_system SET parameter = 'admin_i18n_update_mode' WHERE parameter = 'i18n_update_mode';
UPDATE config_param_system SET parameter = 'admin_python_folderpath' WHERE parameter = 'python_folderpath';
UPDATE config_param_system SET parameter = 'admin_raster_dem' WHERE parameter = 'sys_raster_dem';
UPDATE config_param_system SET parameter = 'admin_role_permisions' WHERE parameter = 'sys_role_permissions';
UPDATE config_param_system SET parameter = 'admin_schema_info', isenabled=FALSE WHERE parameter = 'schema_manager';
UPDATE config_param_system SET parameter = 'admin_utils_schema' WHERE parameter = 'ext_utils_schema';
UPDATE config_param_system SET parameter = 'admin_vpn_permissions', datatype='boolean' WHERE parameter = 'sys_vpn_permissions';
UPDATE config_param_system SET parameter = 'admin_publish_user' WHERE parameter = 'api_publish_user';
UPDATE config_param_system SET parameter = 'basic_info_canvasmargin', context='system', descript='Canvas margin', label='Canvas margin:'
WHERE parameter = 'api_canvasmargin';
UPDATE config_param_system SET parameter = 'basic_search_network_arc', label='Search arc:' WHERE parameter = 'api_search_arc';
UPDATE config_param_system SET parameter = 'basic_search_network_connec', label='Search connec:' WHERE parameter = 'api_search_connec';
UPDATE config_param_system SET parameter = 'basic_search_network_element', label='Search element:' WHERE parameter = 'api_search_element';
UPDATE config_param_system SET parameter = 'basic_search_exploitation', label='Search exploitation:' WHERE parameter = 'api_search_exploitation';
UPDATE config_param_system SET parameter = 'basic_search_network_gully', label='Search gully:' WHERE parameter = 'api_search_gully';
UPDATE config_param_system SET parameter = 'basic_search_hydrometer', label='Search hydrometer:' WHERE parameter = 'api_search_hydrometer';
UPDATE config_param_system SET parameter = 'basic_search_muni', label='Search municipality:' WHERE parameter = 'api_search_muni';
UPDATE config_param_system SET parameter = 'basic_search_network_null', label='Search network null:' WHERE parameter = 'api_search_network_null';
UPDATE config_param_system SET parameter = 'basic_search_network_node', label='Search node:' WHERE parameter = 'api_search_node';
UPDATE config_param_system SET parameter = 'basic_search_postnumber', label='Search postnumber:' WHERE parameter = 'api_search_postnumber';
UPDATE config_param_system SET parameter = 'basic_search_psector', label='Search psector:' WHERE parameter = 'api_search_psector';
UPDATE config_param_system SET parameter = 'basic_search_street', label='Search street:' WHERE parameter = 'api_search_street';
UPDATE config_param_system SET parameter = 'basic_search_visit', label='Search visit:' WHERE parameter = 'api_search_visit';
UPDATE config_param_system SET parameter = 'basic_search_workcat', label='Search workcat:' WHERE parameter = 'api_search_workcat';
UPDATE config_param_system SET parameter = 'basic_selector_exploitation' WHERE parameter = 'api_selector_exploitation';
UPDATE config_param_system SET parameter = 'edit_feature_buffer_on_mapzone' WHERE parameter = 'proximity_buffer';
UPDATE config_param_system SET parameter = 'edit_arc_enable nodes_update' WHERE parameter = 'edit_enable_arc_nodes_update';
UPDATE config_param_system SET parameter = 'edit_arc_searchnodes' WHERE parameter = 'arc_searchnodes';
UPDATE config_param_system SET parameter = 'edit_connec_autofill_ccode' WHERE parameter = 'customer_code_autofill';
UPDATE config_param_system SET parameter = 'edit_connec_proximity' WHERE parameter = 'connec_proximity';
UPDATE config_param_system SET parameter = 'edit_gully_proximity' WHERE parameter = 'gully_proximity';
UPDATE config_param_system SET parameter = 'edit_hydro_link_absolute_path' WHERE parameter = 'hydrometer_link_absolute_path';
UPDATE config_param_system SET parameter = 'edit_arc_insert_automatic_endpoint' WHERE parameter = 'nodeinsert_arcendpoint';
UPDATE config_param_system SET parameter = 'edit_node_proximity' WHERE parameter = 'node_proximity';
UPDATE config_param_system SET parameter = 'edit_arc_orphannode_delete' WHERE parameter = 'orphannode_delete';
UPDATE config_param_system SET parameter = 'edit_slope_direction' WHERE parameter = 'geom_slp_direction';
UPDATE config_param_system SET parameter = 'edit_state_topocontrol' WHERE parameter = 'state_topocontrol';
UPDATE config_param_system SET parameter = 'edit_topocontrol_disable_error' WHERE parameter = 'edit_topocontrol_dsbl_error';
UPDATE config_param_system SET parameter = 'edit_vnode_update_tolerance' WHERE parameter = 'vnode_update_tolerance';
UPDATE config_param_system SET parameter = 'epa_subcatchment_concat_prefix_id', label='Configure prefix on subcathcments' WHERE parameter = 'inp_subc_seq_id_prefix';
UPDATE config_param_system SET parameter = 'om_mincut_enable_alerts' WHERE parameter = 'sys_mincutalerts_enable';
UPDATE config_param_system SET parameter = 'om_mincut_valvestatus_unaccess' WHERE parameter = 'om_mincut_valvestat_using_valveunaccess';
UPDATE config_param_system SET parameter = 'om_profile_guitarlegend' WHERE parameter = 'profile_guitarlegend';
UPDATE config_param_system SET parameter = 'om_profile_guitartext' WHERE parameter = 'profile_guitartext';
UPDATE config_param_system SET parameter = 'om_profile_stylesheet' WHERE parameter = 'profile_stylesheet';
UPDATE config_param_system SET parameter = 'om_profile_vdefault' WHERE parameter = 'profile_vdefault';
UPDATE config_param_system SET parameter = 'utils_grafanalytics_dynamic_symbology', label='Mapzones dynamic symbology' 
WHERE parameter = 'mapzones_dynamic_symbology';
UPDATE config_param_system SET parameter = 'utils_grafanalytics_status' WHERE parameter = 'om_dynamicmapzones_status';
UPDATE config_param_system SET parameter = 'utils_import_visit_parameters' WHERE parameter = 'utils_csv2pg_om_visit_parameters';
UPDATE config_param_system SET parameter = 'edit_feature_usefid_on_linkid' WHERE parameter = 'edit_automatic_insert_link';
UPDATE config_param_system SET parameter = 'admin_crm_periodseconds_vdefault' WHERE parameter = 'vdefault_rtc_period_seconds';
UPDATE config_param_system SET parameter = 'edit_arc_samenode_control' WHERE parameter = 'samenode_init_end_control';
UPDATE config_param_system SET parameter = 'edit_node_doublegeom' WHERE parameter = 'insert_double_geometry';
UPDATE config_param_system SET parameter = 'admin_version', context='system', label='Version' WHERE parameter = 'ApiVersion';
UPDATE config_param_system SET parameter = 'admin_transaction_db' WHERE parameter = 'sys_transaction_db';
UPDATE config_param_system SET parameter = 'admin_customform_param' WHERE parameter = 'custom_form_param';
UPDATE config_param_system SET parameter = 'admin_customform_param' WHERE parameter = 'custom_form_param';
UPDATE config_param_system SET parameter = 'basic_selector_mincut' WHERE parameter = 'api_selector_mincut';
UPDATE config_param_system SET parameter = 'edit_hydrant_use_firecode_seq', label='Use hydrant fire_code sequence' WHERE parameter = 'use_fire_code_seq';
UPDATE config_param_system SET label='Parameters used for visits' WHERE parameter = 'om_visit_duration_vdefault';
UPDATE config_param_system SET label='State type for reconstructed elements' WHERE parameter = 'plan_statetype_reconstruct';
UPDATE config_param_system SET isenabled=FALSE WHERE parameter = 'admin_superusers';

UPDATE config_param_system SET context='search' WHERE context='api_search';


-- user param updates
DELETE FROM sys_param_user WHERE id = 'audit_project_epa_result';	
DELETE FROM sys_param_user WHERE id = 'audit_project_plan_result';
DELETE FROM sys_param_user WHERE id = 'gullytype_vdefault';
DELETE FROM sys_param_user WHERE id = 'qgistemplate_folder_path';
DELETE FROM sys_param_user WHERE id = 'epaversion';
DELETE FROM sys_param_user WHERE id = 'gully_vdefault';

UPDATE sys_param_user SET id ='utils_checkproject_qgislayer' WHERE id = 'audit_project_layer_log';
UPDATE sys_param_user SET id ='utils_checkproject_database' WHERE id = 'audit_project_user_control';
UPDATE sys_param_user SET id ='utils_debug_mode' WHERE id = 'debug_mode';
UPDATE sys_param_user SET id ='qgis_dim_tooltip' WHERE id = 'dim_tooltip';
UPDATE sys_param_user SET id ='basic_search_exploitation_vdefaut' WHERE id = 'search_exploitation_vdefault';
UPDATE sys_param_user SET id ='basic_search_municipality_vdefaut' WHERE id = 'search_municipality_vdefault';
UPDATE sys_param_user SET id ='utils_formlabel_show_columname' WHERE id = 'api_form_show_columname_on_label';
UPDATE sys_param_user SET id ='edit_arc_category_vdefault' WHERE id = 'arc_category_vdefault';
UPDATE sys_param_user SET id ='edit_arc_downgrade_force' WHERE id = 'edit_arc_downgrade_force';
UPDATE sys_param_user SET id ='edit_arc_fluid_vdefault' WHERE id = 'arc_fluid_vdefault';
UPDATE sys_param_user SET id ='edit_arc_function_vdefault' WHERE id = 'arc_function_vdefault';
UPDATE sys_param_user SET id ='edit_arc_location_vdefault' WHERE id = 'arc_location_vdefault';
UPDATE sys_param_user SET id ='edit_arccat_vdefault' WHERE id = 'arccat_vdefault';
UPDATE sys_param_user SET id ='edit_arctype_vdefault' WHERE id = 'arctype_vdefault';
UPDATE sys_param_user SET id ='edit_builtdate_vdefault' WHERE id = 'builtdate_vdefault';
UPDATE sys_param_user SET id ='edit_cadtools_baselayer_vdefault' WHERE id = 'cad_tools_base_layer_vdefault';
UPDATE sys_param_user SET id ='edit_connecat_vdefault' WHERE id = 'connecat_vdefault';
UPDATE sys_param_user SET id ='edit_connec_automatic_link' WHERE id = 'edit_connect_force_automatic_connect2network';
UPDATE sys_param_user SET id ='edit_connect_downgrade_link' WHERE id = 'edit_connect_force_downgrade_linkvnode';
UPDATE sys_param_user SET id ='edit_connectype_vdefault' WHERE id = 'connectype_vdefault';
UPDATE sys_param_user SET id ='edit_disable_statetopocontrol' WHERE id = 'edit_disable_statetopocontrol';
UPDATE sys_param_user SET id ='edit_dma_vdefault' WHERE id = 'dma_vdefault';
UPDATE sys_param_user SET id ='edit_doctype_vdefault' WHERE id = 'document_type_vdefault';
UPDATE sys_param_user SET id ='edit_elementcat_vdefault' WHERE id = 'elementcat_vdefault';
UPDATE sys_param_user SET id ='edit_enddate_vdefault' WHERE id = 'enddate_vdefault';
UPDATE sys_param_user SET id ='edit_exploitation_vdefault' WHERE id = 'exploitation_vdefault';
UPDATE sys_param_user SET id ='edit_feature_category_vdefault' WHERE id = 'feature_category_vdefault';
UPDATE sys_param_user SET id ='edit_feature_fluid_vdefault' WHERE id = 'feature_fluid_vdefault';
UPDATE sys_param_user SET id ='edit_feature_function_vdefault' WHERE id = 'feature_function_vdefault';
UPDATE sys_param_user SET id ='edit_feature_location_vdefault' WHERE id = 'feature_location_vdefault';
UPDATE sys_param_user SET id ='edit_featureval_category_vdefault' WHERE id = 'featureval_category_vdefault';
UPDATE sys_param_user SET id ='edit_featureval_fluid_vdefault' WHERE id = 'featureval_fluid_vdefault';
UPDATE sys_param_user SET id ='edit_featureval_function_vdefault' WHERE id = 'featureval_function_vdefault';
UPDATE sys_param_user SET id ='edit_featureval_location_vdefault' WHERE id = 'featureval_location_vdefault';
UPDATE sys_param_user SET id ='edit_gratecat_vdefault' WHERE id = 'gratecat_vdefault';
UPDATE sys_param_user SET id ='edit_gully_autoupdate_polgeom' WHERE id = 'edit_gully_automatic_update_polgeom';
UPDATE sys_param_user SET id ='edit_gully_category_vdefault' WHERE id = 'gully_category_vdefault';
UPDATE sys_param_user SET id ='edit_gully_doublegeom' WHERE id = 'edit_gully_doublegeom';
UPDATE sys_param_user SET id ='edit_gully_fluid_vdefault' WHERE id = 'gully_fluid_vdefault';
UPDATE sys_param_user SET id ='edit_gully_automatic_link' WHERE id = 'edit_gully_force_automatic_connect2network';
UPDATE sys_param_user SET id ='edit_gully_function_vdefault' WHERE id = 'gully_function_vdefault';
UPDATE sys_param_user SET id ='edit_gully_location_vdefault' WHERE id = 'gully_location_vdefault';
UPDATE sys_param_user SET id ='edit_link_update_connecrotation' WHERE id = 'edit_link_connecrotation_update';
UPDATE sys_param_user SET id ='edit_municipality_vdefault' WHERE id = 'municipality_vdefault';
UPDATE sys_param_user SET id ='edit_node_category_vdefault' WHERE id = 'node_category_vdefault';
UPDATE sys_param_user SET id ='edit_node_fluid_vdefault' WHERE id = 'node_fluid_vdefault';
UPDATE sys_param_user SET id ='edit_node_function_vdefault' WHERE id = 'node_function_vdefault';
UPDATE sys_param_user SET id ='edit_node_location_vdefault' WHERE id = 'node_location_vdefault';
UPDATE sys_param_user SET id ='edit_nodecat_vdefault' WHERE id = 'nodecat_vdefault';
UPDATE sys_param_user SET id ='edit_noderotation_disable_update' WHERE id = 'edit_noderotation_update_dissbl';
UPDATE sys_param_user SET id ='edit_nodetype_vdefault' WHERE id = 'nodetype_vdefault';
UPDATE sys_param_user SET id ='edit_ownercat_vdefault' WHERE id = 'ownercat_vdefault';
UPDATE sys_param_user SET id ='edit_pavementcat_vdefault' WHERE id = 'pavementcat_vdefault';
UPDATE sys_param_user SET id ='edit_sector_vdefault' WHERE id = 'sector_vdefault';
UPDATE sys_param_user SET id ='edit_soilcat_vdefault' WHERE id = 'soilcat_vdefault';
UPDATE sys_param_user SET id ='edit_state_vdefault' WHERE id = 'state_vdefault';
UPDATE sys_param_user SET id ='edit_statetype_0_vdefault' WHERE id = 'statetype_0_vdefault';
UPDATE sys_param_user SET id ='edit_statetype_1_vdefault' WHERE id = 'statetype_1_vdefault';
UPDATE sys_param_user SET id ='edit_statetype_2_vdefault' WHERE id = 'statetype_2_vdefault';
UPDATE sys_param_user SET id ='edit_upsert_elevation_from_dem' WHERE id = 'edit_upsert_elevation_from_dem';
UPDATE sys_param_user SET id ='edit_verified_vdefault' WHERE id = 'verified_vdefault';
UPDATE sys_param_user SET id ='edit_workcat_end_vdefault' WHERE id = 'workcat_id_end_vdefault';
UPDATE sys_param_user SET id ='edit_workcat_vdefault' WHERE id = 'workcat_vdefault';
UPDATE sys_param_user SET id ='om_profile_stylesheet' WHERE id = 'profile_stylesheet';
UPDATE sys_param_user SET id ='om_visit_cat_vdefault' WHERE id = 'visitcat_vdefault';
UPDATE sys_param_user SET id ='om_visit_class_vdefault' WHERE id = 'visitclass_vdefault';
UPDATE sys_param_user SET id ='om_visit_enddate_vdefault' WHERE id = 'visitenddate_vdefault';
UPDATE sys_param_user SET id ='om_visit_extcode_vdefault' WHERE id = 'visitextcode_vdefault';
UPDATE sys_param_user SET id ='om_visit_parameter_vdefault' WHERE id = 'visitparameter_vdefault';
UPDATE sys_param_user SET id ='om_visit_paramvalue_vdefault' WHERE id = 'visitparametervalue_vdefault';
UPDATE sys_param_user SET id ='om_visit_startdate_vdefault' WHERE id = 'visitstartdate_vdefault';
UPDATE sys_param_user SET id ='om_visit_status_vdefault' WHERE id = 'visitstatus_vdefault';
UPDATE sys_param_user SET id ='plan_psector_gexpenses_vdefault' WHERE id = 'psector_gexpenses_vdefault';
UPDATE sys_param_user SET id ='plan_psector_measurement_vdefault' WHERE id = 'psector_measurement_vdefault';
UPDATE sys_param_user SET id ='plan_psector_other_vdefault' WHERE id = 'psector_other_vdefault';
UPDATE sys_param_user SET id ='plan_psector_vat_vdefault' WHERE id = 'psector_vat_vdefault';
UPDATE sys_param_user SET id ='plan_psector_vdefault' WHERE id = 'psector_vdefault';
UPDATE sys_param_user SET id ='qgis_composers_folderpath' WHERE id = 'qgis_composers_path';
UPDATE sys_param_user SET id ='cur_trans' WHERE id = 'utils_cur_trans';
UPDATE sys_param_user SET dv_querytext = 'SELECT id, idval FROM edit_typevalue WHERE typevalue =''value_verified''' WHERE id = 'edit_verified_vdefault';
UPDATE sys_param_user SET dv_querytext = 'SELECT presszone.id, presszone.descript AS idval FROM presszone WHERE presszone.id IS NOT NULL' WHERE id = 'presszone_vdefault';
UPDATE sys_param_user SET widgettype = 'check' where id = 'utils_debug_mode';
UPDATE sys_param_user SET layoutorder=6 where id = 'edit_builtdate_vdefault';


UPDATE sys_table set sys_sequence = null where id IN ('config_param_system', 'config_param_user');

UPDATE config_param_system SET datatype = 'json', widgettype = 'linetext' WHERE parameter = 'edit_review_node_tolerance';
UPDATE config_param_system SET datatype = 'json', widgettype = 'linetext' WHERE parameter = 'edit_review_arc_tolerance';
UPDATE config_param_system SET datatype = 'json', widgettype = 'linetext' WHERE parameter = 'edit_review_connec_tolerance';
UPDATE config_param_system SET datatype = 'json', widgettype = 'linetext' WHERE parameter = 'edit_review_gully_tolerance';

UPDATE sys_function SET function_type ='trigger function' WHERE function_type ='function trigger';

INSERT INTO sys_function VALUES (2928, 'gw_fct_getstylemapzones','utils','function','json','json','Function to get style from mapzones','role_basic',false);

UPDATE config_form_fields SET dv_querytext = replace (dv_querytext, 'SELECT id, descript as idval FROM presszone', 
'SELECT presszone_id as id , name as idval FROM presszone') where dv_querytext like '%FROM presszone%';
UPDATE config_form_fields SET columnname = 'presszone_id' WHERE formname like '%presszone%' AND columnname ='id';
DELETE FROM config_form_fields WHERE formname IN ('exploitation', 'presszone');
UPDATE config_form_fields SET formname = 'print' WHERE formname = 'printGeneric';


UPDATE sys_table SET id = 'sys_addfields' WHERE id = 'man_addfields_parameter';
UPDATE sys_table SET id = 'config_visit_parameter_action', sys_sequence = null, sys_sequence_field = null WHERE id = 'om_visit_parameter_x_parameter';
UPDATE sys_table SET id = 'config_visit_class_x_parameter' WHERE id = 'om_visit_class_x_parameter';
UPDATE sys_table SET id = 'config_visit_class_x_workorder' WHERE id = 'om_visit_class_x_wo';
UPDATE sys_table SET id = 'config_file' WHERE id = 'om_visit_filetype_x_extension';
UPDATE sys_table SET id = 'config_visit_parameter' WHERE id = 'om_visit_parameter';
UPDATE sys_table SET id = 'plan_price_cat' WHERE id = 'price_cat_simple';
UPDATE sys_table SET id = 'plan_price' WHERE id = 'price_compost';
UPDATE sys_table SET id = 'plan_price_compost' WHERE id ='price_compost_value';

DELETE FROM sys_function WHERE function_name = 'gw_fct_fill_om_tables';
DELETE FROM sys_function WHERE function_name = 'gw_fct_fill_doc_tables';


UPDATE sys_foreignkey SET target_table = 'config_visit_parameter' WHERE target_table = 'om_visit_parameter';
UPDATE sys_foreignkey SET target_table = 'sys_addfields' WHERE target_table = 'man_addfields_parameter';


UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'om_visit_parameter', 'config_visit_parameter') WHERE dv_querytext like '%om_visit_parameter%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'om_visit_filetype_x_extension', 'config_file') WHERE dv_querytext like '%visit_fil%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'price_compost', 'plan_price') WHERE dv_querytext like '%price_compost%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'price_cat_simple', 'plan_price_cat') WHERE dv_querytext like '%price_cat_simple%';

DELETE FROM sys_image WHERE idval ='bmaps';
UPDATE sys_image SET id = 1 WHERE idval = 'ws_shape';

--2020/06/02
INSERT INTO om_typevalue (typevalue, id, idval)
SELECT 'visit_type', id, idval FROM om_visit_type;

INSERT INTO om_typevalue (typevalue, id, idval)
SELECT 'visit_status', id, idval FROM om_visit_cat_status;

INSERT INTO om_typevalue (typevalue, id, idval)
SELECT 'visit_param_action', id, action_name FROM om_visit_parameter_cat_action;

INSERT INTO om_typevalue (typevalue, id, idval)
SELECT 'visit_form_type', id, id FROM om_visit_parameter_form_type;

INSERT INTO om_typevalue (typevalue, id, idval)
SELECT 'visit_param_type', id, id FROM om_visit_parameter_type;

INSERT INTO plan_typevalue (typevalue, id, idval)
SELECT 'psector_type', id, name FROM plan_psector_cat_type;

INSERT INTO plan_typevalue (typevalue, id, idval)
SELECT 'result_type', id, name FROM plan_result_type;

INSERT INTO plan_typevalue (typevalue, id, idval)
SELECT 'price_units', id, id FROM price_value_unit;


INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field)
VALUES ('om_typevalue', 'visit_type', 'config_visit_class', 'visit_type');

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field)
VALUES ('om_typevalue', 'visit_status', 'om_visit', 'status');

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field)
VALUES ('om_typevalue', 'visit_param_action', 'config_visit_parameter_action', 'action_type');

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field)
VALUES ('om_typevalue', 'visit_form_type', 'config_visit_parameter', 'form_type');

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field)
VALUES ('om_typevalue', 'visit_param_type', 'config_visit_parameter', 'parameter_type');

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field)
VALUES ('plan_typevalue', 'psector_type', 'plan_psector', 'psector_type');

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field)
VALUES ('plan_typevalue', 'price_units', 'plan_price', 'unit');



UPDATE sys_table SET isdeprecated=true WHERE id='om_visit_type';
UPDATE sys_table SET isdeprecated=true WHERE id='om_visit_cat_status';
UPDATE sys_table SET isdeprecated=true WHERE id='om_visit_parameter_cat_action';
UPDATE sys_table SET isdeprecated=true WHERE id='om_visit_parameter_form_type';
UPDATE sys_table SET isdeprecated=true WHERE id='om_visit_parameter_type';
UPDATE sys_table SET isdeprecated=true WHERE id='plan_psector_cat_type';
UPDATE sys_table SET isdeprecated=true WHERE id='plan_result_type';
UPDATE sys_table SET isdeprecated=true WHERE id='price_value_unit';