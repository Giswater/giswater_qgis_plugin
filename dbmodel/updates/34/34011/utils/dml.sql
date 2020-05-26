/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/25
DELETE FROM config_param_system WHERE parameter = 'custom_giswater_folder;
DELETE FROM config_param_system WHERE parameter = 'sys_scada_schema;
DELETE FROM config_param_system WHERE parameter = 'sys_utils_schema;
DELETE FROM config_param_system WHERE parameter = 'chk_state_topo;
DELETE FROM config_param_system WHERE parameter = 'link_searchbuffer;
DELETE FROM config_param_system WHERE parameter = 'nodetype_change_enabled;
DELETE FROM config_param_system WHERE parameter = 'inventory_update_date;
DELETE FROM config_param_system WHERE parameter = 'rev_node_depth_tol;
DELETE FROM config_param_system WHERE parameter = 'rev_node_top_elev_tol;
DELETE FROM config_param_system WHERE parameter = 'rev_node_ymax_tol;
DELETE FROM config_param_system WHERE parameter = 'rev_node_geom1_tol;
DELETE FROM config_param_system WHERE parameter = 'rev_node_geom2_tol;
DELETE FROM config_param_system WHERE parameter = 'rev_arc_y2_tol;
DELETE FROM config_param_system WHERE parameter = 'rev_arc_geom1_tol;
DELETE FROM config_param_system WHERE parameter = 'rev_arc_geom2_tol;
DELETE FROM config_param_system WHERE parameter = 'rev_connec_y2_tol;
DELETE FROM config_param_system WHERE parameter = 'rev_connec_geom1_tol;
DELETE FROM config_param_system WHERE parameter = 'rev_connec_geom2_tol;
DELETE FROM config_param_system WHERE parameter = 'rev_gully_ymax_tol;
DELETE FROM config_param_system WHERE parameter = 'rev_gully_sandbox_tol;
DELETE FROM config_param_system WHERE parameter = 'rev_gully_connec_geom1_tol;
DELETE FROM config_param_system WHERE parameter = 'rev_gully_connec_geom2_tol;
DELETE FROM config_param_system WHERE parameter = 'rev_gully_units_tol;
DELETE FROM config_param_system WHERE parameter = 'sys_api_service;
DELETE FROM config_param_system WHERE parameter = 'sys_custom_views;
DELETE FROM config_param_system WHERE parameter = 'code_vd;
DELETE FROM config_param_system WHERE parameter = 'audit_function_control;
DELETE FROM config_param_system WHERE parameter = 'node2arc;
DELETE FROM config_param_system WHERE parameter = 'api_sensibility_factor_web;
DELETE FROM config_param_system WHERE parameter = 'api_sensibility_factor_desktop;
DELETE FROM config_param_system WHERE parameter = 'inp_fast_buildup;
DELETE FROM config_param_system WHERE parameter = 'api_selector_label;
			
UPDATE config_param_system SET parameter = 'basic_info_sensibility_factor', value ='{"mobile":2, "web":1, "desktop":1}'	' WHERE parameter = 'api_sensibility_factor_web';
UPDATE config_param_system SET parameter = 'edit_review_node_tolerance', value ='{"topelev":1, "elevation":1, "depth":1, "ymax":1}'	' WHERE parameter = 'rev_node_elevation_tol';
UPDATE config_param_system SET parameter = 'edit_review_arc_tolerance', value ='{"y1":1,"y2":1}'	' WHERE parameter = 'rev_arc_y1_tol';
UPDATE config_param_system SET parameter = 'edit_review_connec_tolerance', value ='{"y1":1,"y2":1}'	' WHERE parameter = 'rev_connec_y1_tol';
UPDATE config_param_system SET parameter = 'edit_review_gully_tolerance', value ='{"topelev":1, "ymax":1,"sandbox":0.1, "units":1}'	' WHERE parameter = 'rev_gully_top_elev_tol';
			
UPDATE config_param_system SET parameter = 'admin_crm_schema' WHERE parameter = 'sys_crm_schema';
UPDATE config_param_system SET parameter = 'admin_currency' WHERE parameter = 'sys_currency';
UPDATE config_param_system SET parameter = 'admin_crm_script_folderpath' WHERE parameter = 'crm_daily_script_folderpath';
UPDATE config_param_system SET parameter = 'admin_daily_updates' WHERE parameter = 'sys_daily_updates';
UPDATE config_param_system SET parameter = 'admin_daily_updates_mails' WHERE parameter = 'daily_update_mails';
UPDATE config_param_system SET parameter = 'admin_exploitation_x_user' WHERE parameter = 'sys_exploitation_x_user';
UPDATE config_param_system SET parameter = 'admin_i18n_update_mode' WHERE parameter = 'i18n_update_mode';
UPDATE config_param_system SET parameter = 'admin_python_folderpath' WHERE parameter = 'python_folderpath';
UPDATE config_param_system SET parameter = 'admin_raster_dem' WHERE parameter = 'sys_raster_dem';
UPDATE config_param_system SET parameter = 'admin_role_permisions' WHERE parameter = 'sys_role_permissions';
UPDATE config_param_system SET parameter = 'admin_i18n_update_mode' WHERE parameter = 'i18n_update_mode';
UPDATE config_param_system SET parameter = 'admin_python_folderpath' WHERE parameter = 'python_folderpath';
UPDATE config_param_system SET parameter = 'admin_raster_dem' WHERE parameter = 'sys_raster_dem';
UPDATE config_param_system SET parameter = 'admin_role_permisions' WHERE parameter = 'sys_role_permissions';
UPDATE config_param_system SET parameter = 'admin_schema_info' WHERE parameter = 'schema_manager';
UPDATE config_param_system SET parameter = 'admin_utils_schema' WHERE parameter = 'ext_utils_schema';
UPDATE config_param_system SET parameter = 'admin_vpn_permissions' WHERE parameter = 'sys_vpn_permissions';
UPDATE config_param_system SET parameter = 'admin_publish_user' WHERE parameter = 'api_publish_user';
UPDATE config_param_system SET parameter = 'basic_info_canvasmargin' WHERE parameter = 'api_canvasmargin';
UPDATE config_param_system SET parameter = 'basic_search_arc' WHERE parameter = 'api_search_arc';
UPDATE config_param_system SET parameter = 'basic_search_connec' WHERE parameter = 'api_search_connec';
UPDATE config_param_system SET parameter = 'basic_search_element' WHERE parameter = 'api_search_element';
UPDATE config_param_system SET parameter = 'basic_search_exploitation' WHERE parameter = 'api_search_exploitation';
UPDATE config_param_system SET parameter = 'basic_search_gully' WHERE parameter = 'api_search_gully';
UPDATE config_param_system SET parameter = 'basic_search_hydrometer' WHERE parameter = 'api_search_hydrometer';
UPDATE config_param_system SET parameter = 'basic_search_muni' WHERE parameter = 'api_search_muni';
UPDATE config_param_system SET parameter = 'basic_search_network_null' WHERE parameter = 'api_search_network_null';
UPDATE config_param_system SET parameter = 'basic_search_node' WHERE parameter = 'api_search_node';
UPDATE config_param_system SET parameter = 'basic_search_postnumber' WHERE parameter = 'api_search_postnumber';
UPDATE config_param_system SET parameter = 'basic_search_psector' WHERE parameter = 'api_search_psector';
UPDATE config_param_system SET parameter = 'basic_search_street' WHERE parameter = 'api_search_street';
UPDATE config_param_system SET parameter = 'basic_search_visit' WHERE parameter = 'api_search_visit';
UPDATE config_param_system SET parameter = 'basic_search_workcat' WHERE parameter = 'api_search_workcat';
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
UPDATE config_param_system SET parameter = 'edit_orphannode_delete' WHERE parameter = 'orphannode_delete';
UPDATE config_param_system SET parameter = 'edit_slope_direction' WHERE parameter = 'geom_slp_direction';
UPDATE config_param_system SET parameter = 'edit_state_topocontrol' WHERE parameter = 'state_topocontrol';
UPDATE config_param_system SET parameter = 'edit_topocontrol_disable_error' WHERE parameter = 'edit_topocontrol_dsbl_error';
UPDATE config_param_system SET parameter = 'edit_vnode_update_tolerance' WHERE parameter = 'vnode_update_tolerance';
UPDATE config_param_system SET parameter = 'epa_subcatchment_concat_prefix_id' WHERE parameter = 'inp_subc_seq_id_prefix';
UPDATE config_param_system SET parameter = 'om_mincut_enable_alerts' WHERE parameter = 'sys_mincutalerts_enable';
UPDATE config_param_system SET parameter = 'om_mincut_valvestatus_unaccess' WHERE parameter = 'om_mincut_valvestat_using_valveunaccess';
UPDATE config_param_system SET parameter = 'om_profile_guitarlegend' WHERE parameter = 'profile_guitarlegend';
UPDATE config_param_system SET parameter = 'om_profile_guitartext' WHERE parameter = 'profile_guitartext';
UPDATE config_param_system SET parameter = 'om_profile_stylesheet' WHERE parameter = 'profile_stylesheet';
UPDATE config_param_system SET parameter = 'om_profile_vdefault' WHERE parameter = 'profile_vdefault';
UPDATE config_param_system SET parameter = 'utils_grafanalytics_dynamic_symbology' WHERE parameter = 'mapzones_dynamic_symbology';
UPDATE config_param_system SET parameter = 'utils_grafanalytics_status' WHERE parameter = 'om_dynamicmapzones_status';
UPDATE config_param_system SET parameter = 'utils_import_visit_parameters' WHERE parameter = 'utils_csv2pg_om_visit_parameters';
UPDATE config_param_system SET parameter = 'edit_feature_usefid_on_linkid' WHERE parameter = 'edit_automatic_insert_link';
UPDATE config_param_system SET parameter = 'admin_crm_periodseconds_vdefault' WHERE parameter = 'vdefault_rtc_period_seconds';
UPDATE config_param_system SET parameter = 'edit_arc_samenode_control' WHERE parameter = 'samenode_init_end_control';
UPDATE config_param_system SET parameter = 'edit_node_doublegeom' WHERE parameter = 'insert_double_geometry';
UPDATE config_param_system SET parameter = 'admin_version' WHERE parameter = 'ApiVersion';
UPDATE config_param_system SET parameter = 'admin_transaction_db' WHERE parameter = 'sys_transaction_db';
UPDATE config_param_system SET parameter = 'admin_customform_param' WHERE parameter = 'custom_form_param';