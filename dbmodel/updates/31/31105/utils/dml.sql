/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2018/10/27
UPDATE om_visit_parameter SET ismultifeature=TRUE WHERE form_type='event_standard';


-- 2018/10/28
SELECT setval('SCHEMA_NAME.config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('sys_custom_views', 'FALSE', 'Boolean', 'System', 'Utils');
INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('sys_currency', '{"id":"EUR", "descript":"EURO", "symbol":€"}', 'Json', 'System', 'Utils');

-- 2018/11/03
INSERT INTO sys_fprocess_cat VALUES (33, 'Update project data schema', 'System', 'Project data schema', 'utils');

INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2510, 'gw_fct_utils_csv2pg_import_dbprices', 'role_edit', FALSE, 'Function imports prices from csv file into database');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2512, 'gw_fct_utils_csv2pg_import_omvisit', 'role_edit', FALSE,'Function imports visits from csv file into database' );
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2514, 'gw_fct_utils_csv2pg_import_elements', 'role_edit',  FALSE,'Function imports elements from csv file into database');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2516, 'gw_fct_utils_csv2pg_import_addfields', 'role_edit', FALSE,'Function imports personalized fields from csv file into database');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2518, 'gw_fct_utils_csv2pg_export_epa_inp', 'role_epa', FALSE,'Function indicates the correct inp data export depending on project type');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2520, 'gw_fct_utils_csv2pg_import_epanet_rpt', 'role_epa', FALSE,'Function imports epanet model results from rpt file into database');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2522, 'gw_fct_utils_csv2pg_import_epanet_inp', 'role_admin',FALSE,'Function imports network data from epanet inp file into database');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2524, 'gw_fct_utils_csv2pg_import_swmm_inp', 'role_admin', FALSE,'Function imports network data from swmm inp file into database');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2526, 'gw_fct_utils_csv2pg_export_epanet_inp', 'role_epa', FALSE,'Function exports epanet model data from database into inp file');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2528, 'gw_fct_utils_csv2pg_export_swmm_inp', 'role_epa', FALSE,'Function exports swmm model data from database into inp file');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2530, 'gw_fct_utils_csv2pg_import_swmm_rpt', 'role_epa', FALSE,'Function imports swmm model results from rpt file into database');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2532, 'gw_fct_utils_csv2pg_import_epa_inp', 'role_epa', FALSE,'Function indicates the correct inp data import depending on project type');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2536, 'gw_fct_utils_csv2pg_import_epa_rpt', 'role_epa', FALSE,'Function indicates the correct rpt data import depending on project type');

-- 2018/11/08
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2534, 'gw_fct_repair_link', 'role_edit', FALSE,'Function allows to conected link geometries defined by user with the network');


-- 2018/11/11
SELECT setval('SCHEMA_NAME.config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('utils_csv2pg_om_visit_parameters', '{"p1", "p2", "p3"}', 'array', 'System', 'Utils');


INSERT INTO sys_fprocess_cat VALUES (34, 'Dynamic minimun sector analysis', 'EDIT', 'Mincut minimun sector analysis', 'ws');

INSERT INTO audit_cat_table VALUES ('dattrib', 'om', 'Table to store dynamic mapzones', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('dattrib_type', 'om', 'Table to store the different types of dynamic mapzones', 'role_admin', 0, NULL, NULL, 0, NULL, NULL, NULL);


--2018/11/20
INSERT INTO audit_cat_table VALUES ('v_ui_doc_x_psector', 'om', null, null, 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('v_ui_hydrometer', 'om', null, null, 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('v_ui_plan_psector', 'om', null, null, 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('v_ui_workcat_polygon_all', 'om', null, null, 0, NULL, NULL, 0, NULL, NULL, NULL);


-- 2018/11/23
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2538, 'gw_fct_dinlet', 'role_om', FALSE, NULL);
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2540, 'gw_fct_inlet_flowtrace', 'role_om', FALSE, NULL);

-- 2018/12/14
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript)  VALUES (2542, 'gw_trg_arc_vnodelink_update', 'role_edit',FALSE, 'Function recreates link when arc was updated');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript)  VALUES (2544, 'gw_trg_link_connecrotation_update', 'role_edit', FALSE, 'Function sets connec''s label_rotation depending on link''s position');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript)  VALUES (2546, 'gw_fct_admin_schema_update', 'role_edit',FALSE, NULL);
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript)  VALUES (2548, 'gw_trg_om_visit', 'role_om', FALSE, 'Function allowing to automatically insert new workcat_id same as code of the visit');

INSERT INTO audit_cat_param_user VALUES ('edit_link_connecrotation_update', 'edit', 'Used to rotate label and symbol of connec using the links angle', 'role_edit');


-- 2018/12/17
INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('edit_connect_update_statetype', '{"connec":{"status":"FALSE", "state_type":"11"}, "gully":{"status":"FALSE", "state_type":"11"}}', 'json', 'edit', 'If TRUE, when you connect an element to the network, its state_type will be updated to value of the json');

-- 2018/12/22
INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('om_visit_parameters', '{"AutoNewWorkcat":"FALSE"}', 'json', 'om', 'Visit parameters. AutoNewWorkcat IF TRUE, automatic workcat is created with same id that visit');

-- 2018/12/24
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2550, 'gw_fct_admin_schema_dropdeprecated_rel', 'role_admin',FALSE, 'Function that eliminates deprecated sequences, views, tables and functions');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2552, 'gw_fct_admin_role_permissions', 'role_admin', FALSE, 'Function that assignes roles to database');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2554, 'gw_fct_admin_schema_utils_fk', 'role_admin', FALSE, 'Function that creates foreign keys for utils schema');

--2018/12/25
INSERT INTO audit_cat_table VALUES ('audit_cat_sequence', 'role_admin', null, null, 0, NULL, NULL, 0, NULL, NULL, NULL);


-- 2019/01/15
INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('edit_publish_sysvdefault', 'TRUE', 'boolean', 'edit', 'System default value for publish');

INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('edit_inventory_sysvdefault', 'TRUE', 'boolean', 'edit', 'System default value for inventory');

INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('edit_uncertain_sysvdefault', 'FALSE', 'boolean', 'edit', 'System default value for uncertain');

INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2558, 'gw_api_get_featureinfo', 'role_basic', FALSE, 'Function to provide information aboute feature');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2560, 'gw_api_get_featureupsert', 'role_basic', FALSE, 'Function to upsert features');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2562, 'gw_api_get_formfields', 'role_basic', FALSE,  'Get fields of a form');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2564, 'gw_api_get_widgetjson', 'role_basic', FALSE, 'Get widget type of a field');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2566, 'gw_api_getattributetable', 'role_basic', FALSE, 'Get atrribute tcatalog of a feature');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2570, 'gw_api_getconfig', 'role_basic', FALSE, 'Get configs fields and data');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2572, 'gw_api_getchilds', 'role_basic', FALSE, 'Get child view fields and data');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2574, 'gw_api_getfeatureinsert', 'role_basic', FALSE, 'Function to insert features');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2576, 'gw_api_getgo2epa', 'role_basic', FALSE, 'Function called to get the epa forms');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2578, 'gw_api_getinfocrossection', 'role_basic', FALSE, 'Function called to get info of crossection for arc features');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2580, 'gw_api_getinfofromcoordinates', 'role_basic', FALSE, 'Get information by feature coordinates');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2582, 'gw_api_getinfofromid', 'role_basic', FALSE, 'Get information by feature id');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2584, 'gw_api_getinfofromlist', 'role_basic', FALSE, 'Function to get info from lists');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2586, 'gw_api_getinfoplan', 'role_basic', FALSE, 'Get information about plan cost');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2588, 'gw_api_getinsertfeature', 'role_basic', FALSE, 'Function to insert features');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2590, 'gw_api_getlayersfromcoordinates', 'role_basic', FALSE,  'Get information about layer by coordinates');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2592, 'gw_api_getlist', 'role_basic', FALSE, 'Function to call lists');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2594, 'gw_api_getmessage', 'role_basic', FALSE, 'Get message');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2596, 'gw_api_getpermissions', 'role_basic', FALSE, 'Get information about permissions');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2598, 'gw_api_getrowinsert', 'role_basic', FALSE, 'Function called to get eow insert' );
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2600, 'gw_api_getsearch', 'role_basic', FALSE, 'Get search form fields');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2602, 'gw_api_gettypeahead', 'role_basic', FALSE, 'Function called to fill typeahead widgets');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2604, 'gw_api_getvisit', 'role_basic', FALSE, 'Get visit form fiels');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2606, 'gw_api_setconfig', 'role_basic', FALSE, 'Set new config values');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2608, 'gw_api_setdelete', 'role_basic', FALSE, 'Set delete feature');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2610, 'gw_api_setfields', 'role_basic', FALSE, 'Function called to set fields on feature');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2612, 'gw_api_setfileinsert', 'role_basic', FALSE, 'Set insert visit file');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2614, 'gw_api_setgo2epa', 'role_basic', FALSE, 'Function called to execute changes on go2epa forms');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2616, 'gw_api_setinsert', 'role_basic', FALSE, 'Set insert feature');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2618, 'gw_api_setsearch', 'role_basic', FALSE, 'Search elements by defined fields');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2620, 'gw_api_setsearch_add', 'role_basic', FALSE, 'Search address by defined fields');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2622, 'gw_api_setvisit', 'role_basic', FALSE, 'Set new visit values');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2624, 'gw_fct_json_object_delete_keys', 'role_basic', FALSE, 'Auxiliar function with goal to delete json keys');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2626, 'gw_fct_json_object_set_key', 'role_basic', FALSE, 'Auxiliar function with goal to delete json keys');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2628, 'gw_api_gettoolbarbuttons', 'role_basic', FALSE, 'Function called to define toolbar on client projects');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2630, 'gw_api_getgeometry', 'role_basic', FALSE, 'Function called to pass geometry to client projects');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2632, 'gw_trg_visit_update_enddate', 'role_basic', FALSE, 'Function that sets the visits enddate to current date');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2634, 'gw_fct_refresh_mat_view', 'role_basic', FALSE, 'Function that sets the visits enddate to current date');
INSERT INTO audit_cat_function (id, function_name, sys_role_id, isdeprecated, descript) VALUES (2636, 'gw_fct_admin_schema_renameviews', 'role_basic', FALSE, 'Function that sets the visits enddate to current date');
