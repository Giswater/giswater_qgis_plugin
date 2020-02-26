/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/02/13
INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (114, 'Arc fusion', 'edit', 'utils') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (115, 'Test functions', 'admin', 'utils') ON CONFLICT (id) DO NOTHING;

UPDATE audit_cat_function
set sample_query = '{"WS":{"client":{"device":3, "infoType":100, "lang":"ES"},"data":{"iterative":"start", "resultId":"test1", "useNetworkGeom":"false", "dumpSubcatch":"true"}},
"UD":{"client":{"device":3, "infoType":100, "lang":"ES"},"data":{"iterative":"start", "resultId":"test1", "useNetworkGeom":"false", "dumpSubcatch":"true"}}}'
where function_name='gw_fct_pg2epa_main';

UPDATE audit_cat_function
set sample_query = 'gw_fct_arc_divide(''node_id'')'
where function_name='gw_fct_arc_divide';

UPDATE audit_cat_function
set sample_query = '{"WS":{"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "version":"3.3.019", "fprocesscat_id":1}},"UD":{"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "version":"3.3.019", "fprocesscat_id":1}}}'
where function_name='gw_fct_audit_check_project';

UPDATE audit_cat_function
set sample_query = '{"WS":{"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic", "rolePermissions":"role_master", "activeLayer":"", "visibleLayer":["None", "None", "v_anl_mincut_result_cat", "v_anl_mincut_result_valve", "v_anl_mincut_result_connec", "v_anl_mincut_result_node", "v_anl_mincut_result_arc", "v_edit_exploitation", "v_edit_dma", "ve_node_wtp", "ve_node_source", "ve_node_waterwell", "ve_node_tank", "ve_node_netsamplepoint", "ve_node_netelement", "ve_node_flexunion", "ve_node_expantank", "ve_node_register", "ve_node_pump", "ve_node_hydrant", "ve_node_pressure_meter", "ve_node_flowmeter", "ve_node_reduction", "ve_node_filter", "ve_node_manhole", "ve_node_air_valve", "ve_node_check_valve", "ve_node_green_valve", "ve_node_pr_reduc_valve", "ve_node_outfall_valve", "ve_node_shutoff_valve", "ve_node_curve", "ve_node_endline", "ve_node_junction", "ve_node_t", "ve_node_x", "ve_node_water_connection", "ve_arc_varc", "ve_arc_pipe", "ve_connec_greentap", "ve_connec_fountain", "ve_connec_tap", "ve_connec_wjoin", "v_edit_link", "v_edit_dimensions", "v_edit_element", "v_edit_samplepoint", "v_edit_cad_auxcircle", "v_edit_cad_auxpoint", "v_edit_inp_connec", "inp_energy", "inp_reactions", "macroexploitation", "cat_mat_node", "cat_mat_arc", "cat_node", "cat_arc", "inp_cat_mat_roughness", "cat_connec", "cat_mat_element", "cat_element", "cat_owner", "cat_soil", "cat_pavement", "cat_work", "cat_presszone", "cat_builder", "cat_brand_model", "cat_brand", "cat_users", "ext_municipality", "v_ext_streetaxis", "v_ext_plot"], "coordinates":{"epsg":25831, "xcoord":418896.1541621131,"ycoord":4576599.51751637, "zoomRatio":1020.7091061537468}}},"UD":{"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic", "rolePermissions":"role_master", "activeLayer":"", "visibleLayer":["None", "None","v_edit_node","ve_node_chamber", "ve_node_change", "ve_node_circ_manhole", "ve_node_highpoint", "ve_node_jump", "ve_node_junction", "ve_node_netelement", "ve_node_netgully", "ve_node_netinit", "ve_node_outfall", "ve_node_owerflow_storage", "ve_node_pump_station", "ve_node_rect_manhole", "ve_node_register", "ve_node_sandbox", "ve_node_sewer_storage", "ve_node_valve", "ve_node_virtual_node", "ve_node_weir", "ve_node_wwtp"], "coordinates":{"epsg":25831, "xcoord":419211.489,"ycoord":4576528.2, "zoomRatio":1020.7091061537468}}}}'
where function_name='gw_api_getinfofromcoordinates';

-- 2020/02/21
INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (116, 'Mincut results', 'om', 'ws') ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, context, descript, sys_role_id, 
isdeprecated, istoolbox, alias, isparametric)
VALUES (2802, 'gw_fct_visit_multiplier', 'utils', 'function', null, null, null,'Function desmultiplier visits when multifeature', 'role_om',
false, false, null, false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, context, descript, sys_role_id, 
isdeprecated, istoolbox, alias, isparametric)
VALUES (2804, 'gw_fct_admin_manage_schema', 'utils', 'function', null, null, null,'Function to manage (repair, update, compare) giswater schemas', 'role_admin',
false, false, null, false) ON CONFLICT (id) DO NOTHING;

--2020/02/24
INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox,isparametric)
VALUES (2806, 'gw_fct_admin_test_ci', 'utils','function', 'Function used in continous integration to test database processes', 
'role_admin', FALSE, FALSE, FALSE) ON CONFLICT (id) DO NOTHING;


INSERT INTO audit_cat_table(id, context, description, sys_role_id, sys_criticity, qgis_criticity,  isdeprecated)
    VALUES ('ext_cat_raster', 'external catalog', 'Catalog of rasters', 'role_edit', 0, 0, false)
    ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_table(id, context, description, sys_role_id, sys_criticity, qgis_criticity,  isdeprecated)
    VALUES ('ext_raster_dem', 'external table', 'Table to store raster DEM', 'role_edit', 0, 0, false)
    ON CONFLICT (id) DO NOTHING;
    
INSERT INTO audit_cat_table(id, context, description, sys_role_id, sys_criticity, qgis_criticity,isdeprecated)
VALUES ('ext_district', 'table to external', 'Catalog of districts', 'role_edit', 0, 0, false) ON CONFLICT (id) DO NOTHING;


--2020/02/25
INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3042,'Arc with state 2 cant be divided by node with state 1.', 'To divide an arc, the state of the node has to be the same', 2,true,NULL, false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3044,'Can''t detect any arc to divide.', null, 2,true,NULL, false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3046,'Selected node type doesn''t divide arc. Node type: ', null, 2,true,NULL, false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3048,'Flow length is longer than length of exit arc feature', 'Please review your project!', 2,true,'ud', false) ON CONFLICT (id) DO NOTHING;


