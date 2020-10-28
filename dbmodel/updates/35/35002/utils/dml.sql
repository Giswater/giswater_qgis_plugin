/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_param_user SET id = 'edit_insert_elevation_from_dem', label = 'Insert elevation from DEM:'
WHERE id = 'edit_upsert_elevation_from_dem';

UPDATE sys_param_user SET layoutorder = layoutorder+1 WHERE layoutorder > 17 AND layoutname = 'lyt_other';


INSERT INTO sys_param_user(id, formname, descript, sys_role,  label, isenabled, layoutorder, project_type, isparent, 
isautoupdate, datatype, widgettype, ismandatory, layoutname, iseditable,  isdeprecated)
VALUES ('edit_update_elevation_from_dem', 'config', 'If true, the the elevation will be automatically updated from the DEM raster',
'role_edit', 'Update elevation from DEM:', TRUE, 18, 'utils', FALSE, FALSE, 'boolean', 'check', FALSE, 'lyt_other',
TRUE, FALSE) ON CONFLICT (id) DO NOTHING;


DELETE FROM sys_table WHERE id = 'config_form_groupbox';


--2020/09/15
UPDATE config_visit_parameter SET data_type = lower(data_type);

-- 2020/16/09
UPDATE config_function set layermanager = '{"visible": ["v_edit_dimensions"]}' WHERE id = 2824;

--2020/09/16
INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query)
VALUES ('2998', 'gw_fct_user_check_data', 'utils', 'function','json', 'json', 
'Function to analyze data quality using queries defined by user', 'role_om', NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query)
VALUES ('3000', 'gw_fct_audit_log_project', 'utils', 'function','json', 'json', 
'Function that executes all check functions and copy data into statistic table (audit_fid_log)', 'role_om', NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox(id, alias, isparametric, functionparams, inputparams, observ, active)
VALUES (2998,'User check data', TRUE, '{"featureType":[]}', 
'[{"widgetname":"checkType", "label":"Check type:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"comboIds":["User"],"comboNames":["User"], "selectedId":"User"}]',
null, TRUE) ON CONFLICT (id) DO NOTHING;

--2020/09/17
DELETE FROM sys_param_user WHERE id IN ('qgis_qml_linelayer_path', 'qgis_qml_pointlayer_path','qgis_qml_polygonlayer_path');

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query)
VALUES ('3002', 'gw_fct_setplan', 'utils', 'function','json', 'json', 
'Function that returns qgis layer configuration for masterplan', 'role_master', NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function(id, function_name, returnmanager, layermanager, actions)
VALUES ('3002', 'gw_fct_setplan','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',
'{"visible": ["v_plan_current_psector"], "zoom":{"layer":"v_plan_current_psector", "margin":20}}',null) ON CONFLICT (id) DO NOTHING;


--2020/09/24
DELETE FROM sys_function WHERE id = 2660;
DELETE FROM sys_function WHERE id = 2588;
DELETE FROM sys_function WHERE id = 2722;

--2020/09/25
INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type)
VALUES (3140, 'Node is connected to arc which is involved in psector', 
	'Try replacing node with feature replace tool or disconnect it using end feature tool', 2,TRUE,'utils') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type)
VALUES (3142, 'Node is involved in psector', 
	'Node is going to be disconnected and set to obsolete.', 1,TRUE,'utils') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query)
VALUES (3004, 'gw_fct_setendfeature', 'utils', 'function','json', 'json', 
'Function that controls actions related to setting feature to obsolete', 'role_edit', NULL) ON CONFLICT (id) DO NOTHING;

UPDATE sys_function SET function_name='gw_fct_getcheckdelete' WHERE function_name='gw_fct_check_delete';

--2020/10/13
UPDATE sys_function SET function_name = 'gw_fct_setarcdivide' WHERE function_name='gw_fct_arc_divide';
UPDATE config_function SET  function_name = 'gw_fct_setarcdivide' WHERE function_name='gw_fct_arc_divide';

UPDATE sys_function SET function_name = 'gw_fct_setarcfusion' WHERE function_name='gw_fct_arc_fusion';
UPDATE config_function SET  function_name = 'gw_fct_setarcfusion' WHERE function_name='gw_fct_arc_fusion';

UPDATE sys_function SET function_name = 'gw_fct_setfeaturereplace' WHERE function_name='gw_fct_feature_replace';
UPDATE config_function SET  function_name = 'gw_fct_setfeaturereplace' WHERE function_name='gw_fct_feature_replace';

UPDATE sys_function SET function_name = 'gw_fct_setfeaturedelete' WHERE function_name='gw_fct_feature_delete';
UPDATE config_function SET  function_name = 'gw_fct_setfeaturedelete' WHERE function_name='gw_fct_feature_delete';

UPDATE sys_function SET function_name = 'gw_fct_setmincutoverlap' WHERE function_name='gw_fct_mincut_result_overlap';
UPDATE config_function SET  function_name = 'gw_fct_setmincutoverlap' WHERE function_name='gw_fct_mincut_result_overlap';

UPDATE sys_function SET function_name = 'gw_fct_setcheckproject' WHERE function_name='gw_fct_audit_check_project';
UPDATE config_function SET  function_name = 'gw_fct_setcheckproject' WHERE function_name='gw_fct_audit_check_project';

UPDATE sys_function SET function_name = 'gw_fct_setlinktonetwork' WHERE function_name='gw_fct_connect_to_network';
UPDATE config_function SET  function_name = 'gw_fct_setlinktonetwork' WHERE function_name='gw_fct_connect_to_network';

UPDATE sys_function SET function_name = 'gw_fct_setelevfromdem ' WHERE function_name='gw_fct_connect_to_network';
UPDATE config_function SET  function_name = 'gw_fct_setelevfromdem ' WHERE function_name='gw_fct_connect_to_network';

UPDATE sys_function SET function_name = 'gw_fct_setnodefromarc ' WHERE function_name='gw_fct_node_builtfromarc';
UPDATE config_function SET  function_name = 'gw_fct_setnodefromarc ' WHERE function_name='gw_fct_node_builtfromarc';

UPDATE sys_function SET function_name = 'gw_fct_grafanalytics_downstream_recursive' WHERE function_name='gw_fct_flow_exit_recursive';
UPDATE config_function SET  function_name = 'gw_fct_grafanalytics_downstream_recursive' WHERE function_name='gw_fct_flow_exit_recursive';

UPDATE sys_function SET function_name = 'gw_fct_grafanalytics_downstream' WHERE function_name='gw_fct_flow_exit';
UPDATE config_function SET  function_name = 'gw_fct_grafanalytics_downstream' WHERE function_name='gw_fct_flow_exit';

UPDATE sys_function SET function_name = 'gw_fct_grafanalytics_upstream_recursive' WHERE function_name='gw_fct_flow_trace_recursive';
UPDATE config_function SET  function_name = 'gw_fct_grafanalytics_upstream_recursive' WHERE function_name='gw_fct_flow_trace_recursive';

UPDATE sys_function SET function_name = 'gw_fct_grafanalytics_upstream' WHERE function_name='gw_fct_flow_trace';
UPDATE config_function SET  function_name = 'gw_fct_grafanalytics_upstream' WHERE function_name='gw_fct_flow_trace';

--2020/10/16
INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query)
VALUES (3006, 'gw_fct_setmapzonestrigger', 'ws', 'function','json', 'json', 
'Function that executes mapzone calculation if valve is being closed or opened', 'role_edit', NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function(id, function_name,  actions)
VALUES (3006, 'gw_fct_setmapzonestrigger', '[{"funcName": "set_layer_index", "params": {"tableName": ["v_edit_dma", "v_edit_sector", "v_edit_dqa", "v_edit_presszone"]}}]')
ON CONFLICT (id) DO NOTHING;

--2020/10/19
INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (300, 'Null values on crm.hydrometer field code', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type)
VALUES (3146, 'Backup name is missing', 'Insert value in key backupName', 2, TRUE, 'utils') ON CONFLICT (id) DO NOTHING ;

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type)
VALUES (3148, 'Backup name already exists', 'Try with other name or delete the existing one before', 2, TRUE, 'utils') ON CONFLICT (id) DO NOTHING ;

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type)
VALUES (3150, 'Backup has no data related to table', 'Please check it before continue', 2, TRUE, 'utils') ON CONFLICT (id) DO NOTHING ;

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type)
VALUES (3152, 'Null values on geom1 or geom2 fields on element catalog', 'Please check it before continue', 2, TRUE, 'utils') ON CONFLICT (id) DO NOTHING ;

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type)
VALUES (3154, 'It is not possible to add this connec to psector because it is related to node', 'Move endpoint of link closer than 0.01m to relate it to parent arc', 2, TRUE, 'utils') ON CONFLICT (id) DO NOTHING ;

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type)
VALUES (3156, 'Input parameter has null value', 'Please check it before continue', 2, TRUE, 'utils') ON CONFLICT (id) DO NOTHING ;

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type)
VALUES (3158, 'Value of the function variable is null', 'Please check it before continue', 2, TRUE, 'utils') ON CONFLICT (id) DO NOTHING ;

--2020/10/21
INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (301, 'Planned connecs without reference link', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (302, 'Check values of system variables', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (303, 'Check cat_feature field active', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (304, 'Check cat_feature field code_autofill', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (305, 'Check cat_feature_node field num_arcs', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (306, 'Check cat_feature_node field isarcdivide', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (307, 'Check cat_feature_node field graf_delimiter', 'ws') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (308, 'Check cat_feature_node field isexitupperintro', 'ud') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (309, 'Check cat_feature_node field choose_hemisphere', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (310, 'Check cat_feature_node field isprofilesurface', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (311, 'Check child view man table definition', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (312, 'Check child view addfields', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (313, 'Find not existing child views', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (314, 'Find active features without child views', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (315, 'Check definition on config_info_layer_x_type', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (316, 'Check definition on config_form_fields', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (317, 'Find ve_* views not defined in cat_feature', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (318, 'Check config_form_fields field datatype', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (319, 'Check config_form_fields field widgettype', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (320, 'Check config_form_fields field dv_querytext', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (321, 'Check config_form_fields for addfields definition', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (322, 'Check config_form_fields layoutorder duplicated', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (323, 'Check cat_arc field active', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (324, 'Check cat_arc field cost', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (325, 'Check cat_arc field m2bottom_cost', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (326, 'Check cat_arc field m3protec_cost', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (327, 'Check cat_node field active', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (328, 'Check cat_node field cost', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (329, 'Check cat_node field cost_column', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (330, 'Check cat_node field estimated_depth', 'ws') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (331, 'Check cat_node field estimated_y', 'ud') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (332, 'Check cat_connec field active', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (333, 'Check cat_connec field cost_ut', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (334, 'Check cat_connec field cost_ml', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (335, 'Check cat_connec field cost_m3', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (336, 'Check cat_pavement field thickness', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (337, 'Check cat_pavement field m2cost', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (338, 'Check cat_soil field y_param', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (339, 'Check cat_soil field b', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (340, 'Check cat_soil field m3exc_cost', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (341, 'Check cat_soil field m3fill_cost', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (342, 'Check cat_soil field m3excess_cost', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (343, 'Check cat_soil field m2trenchl_cost', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (344, 'Check cat_grate field active', 'ud') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (345, 'Check cat_grate field cost_ut', 'ud') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (346, 'Check plan_arc_x_pavement rows number', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (347, 'Check plan_arc_x_pavement field pavcat_id', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (348, 'Check final nodes of arc state=2 in psector', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (349, 'Check compatibility of DB and plugin version', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (350, 'Check host of QGIS layers', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (351, 'Check DB name of QGIS layers', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (352, 'Check schema name of QGIS layers', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (353, 'Check user name of QGIS layers', 'utils') ON CONFLICT (fid) DO NOTHING ;



