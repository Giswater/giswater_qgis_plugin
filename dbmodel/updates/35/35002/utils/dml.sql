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
isautoupdate, datatype, widgettype, ismandatory, layoutname, iseditable)
VALUES ('edit_update_elevation_from_dem', 'config', 'If true, the the elevation will be automatically updated from the DEM raster',
'role_edit', 'Update elevation from DEM:', TRUE, 18, 'utils', FALSE, FALSE, 'boolean', 'check', FALSE, 'lyt_other',
TRUE) ON CONFLICT (id) DO NOTHING;


DELETE FROM sys_table WHERE id = 'config_form_groupbox';


--2020/09/15
UPDATE config_visit_parameter SET data_type = lower(data_type);

-- 2020/16/09
UPDATE config_function set layermanager = '{"visible": ["v_edit_dimensions"]}' WHERE id = 2824;

--2020/09/16
INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query)
VALUES ('2998', 'gw_fct_user_check_data', 'utils', 'function','json', 'json', 
'Function to analyze data quality using queries defined by user', 'role_om', NULL) ON CONFLICT (id) DO NOTHING;


INSERT INTO config_toolbox(id, alias, isparametric, functionparams, inputparams, observ, active)
VALUES (2998,'User check data', TRUE, '{"featureType":[]}', 
'[{"widgetname":"checkType", "label":"Check type:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"comboIds":["User"],"comboNames":["User"], "selectedId":"User"}]',
null, TRUE) ON CONFLICT (id) DO NOTHING;

--2020/09/17
DELETE FROM sys_param_user WHERE id IN ('qgis_qml_linelayer_path', 'qgis_qml_pointlayer_path','qgis_qml_polygonlayer_path');


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

--2020/11/19
UPDATE sys_table SET sys_sequence=NULL, sys_sequence_field=NULL WHERE id IN ('config_user_x_expl', 'config_param_user', 'config_param_system');

--2020/11/25
UPDATE config_typevalue set id='open_url', idval='open_url' where typevalue='widgetfunction_typevalue' and id='set_open_url';

--2020/12/10
INSERT INTO sys_function VALUES (3014, 'gw_fct_setcsv','utils','function','json','json','Insert values into temp_csv','role_edit', NULL);

--2020/12/14
UPDATE cat_brand SET active = TRUE WHERE active IS NULL;
UPDATE cat_brand_model SET active = TRUE WHERE active IS NULL;
UPDATE cat_builder SET active = TRUE WHERE active IS NULL;
UPDATE cat_mat_arc SET active = TRUE WHERE active IS NULL;
UPDATE cat_mat_node SET active = TRUE WHERE active IS NULL;
UPDATE cat_mat_element SET active = TRUE WHERE active IS NULL;
UPDATE cat_owner SET active = TRUE WHERE active IS NULL;
UPDATE cat_pavement SET active = TRUE WHERE active IS NULL;
UPDATE cat_soil SET active = TRUE WHERE active IS NULL;
UPDATE cat_work SET active = TRUE WHERE active IS NULL;

--2020/12/15
UPDATE dma SET active = TRUE WHERE active IS NULL;
UPDATE macrodma SET active = TRUE WHERE active IS NULL;
UPDATE macrosector SET active = TRUE WHERE active IS NULL;
UPDATE macroexploitation SET active = TRUE WHERE active IS NULL;
UPDATE sector SET active = TRUE WHERE active IS NULL;

UPDATE config_form_fields SET isparent = false  WHERE (formname = 've_arc' OR formname='v_edit_arc' 
OR formname in (select child_layer FROM cat_feature where feature_type='ARC')) AND columnname='arccat_id';

UPDATE config_form_fields SET dv_querytext = concat(dv_querytext, ' AND active IS TRUE ')
WHERE columnname IN ('brand', 'model','buildercat_id', 'cat_matcat_id', 'ownercat_id','soilcat_id', 'workcat_id', 'workcat_id_end',
'muni_id', 'dma_id','macrodma_id','macrosector_id','macroexpl_id', 'sector_id','nodecat_id','arccat_id','connecat_id', 'elementcat_id' ) 
AND (formname ilike 've_arc%' OR formname ilike 've_node%' OR formname ilike 've_connec%' OR formname ilike 've_gully%' 
OR formname in ('v_edit_element','v_edit_node','v_edit_arc','v_edit_connec','v_edit_gully')) and dv_querytext is not null;

UPDATE sys_param_user set dv_querytext = concat(dv_querytext, ' AND active IS TRUE ')
WHERE id IN ('basic_search_exploitation_vdefault','basic_search_municipality_vdefault','edit_arccat_vdefault', 'edit_connecat_vdefault',
'edit_dma_vdefault','edit_elementcat_vdefault','edit_exploitation_vdefault','edit_feature_category_vdefault','edit_feature_fluid_vdefault',
'edit_feature_function_vdefault','edit_feature_location_vdefault','edit_municipality_vdefault','edit_nodecat_vdefault','edit_ownercat_vdefault',
'edit_pavementcat_vdefault','edit_presszone_vdefault','edit_sector_vdefault','edit_soilcat_vdefault','edit_workcat_end_vdefault',
'edit_workcat_vdefault','edit_pavement_vdefault');

UPDATE sys_param_user set dv_querytext = concat(dv_querytext, ' AND cat_node.active IS TRUE ')
FROM cat_feature WHERE upper(cat_feature.id) = upper(replace(replace(sys_param_user.id,'feat_'::text,''::text),'_vdefault',''))
AND feature_type = 'NODE';

UPDATE sys_param_user set dv_querytext = concat(dv_querytext, ' AND cat_arc.active IS TRUE ')
FROM cat_feature WHERE upper(cat_feature.id) = upper(replace(replace(sys_param_user.id,'feat_'::text,''::text),'_vdefault',''))
AND feature_type = 'ARC';

UPDATE sys_param_user set dv_querytext = concat(dv_querytext, ' AND cat_connec.active IS TRUE ')
FROM cat_feature WHERE upper(cat_feature.id) = upper(replace(replace(sys_param_user.id,'feat_'::text,''::text),'_vdefault',''))
AND feature_type = 'CONNEC';

UPDATE man_type_location SET active = TRUE WHERE active IS NULL;
UPDATE man_type_fluid SET active = TRUE WHERE active IS NULL;
UPDATE man_type_category SET active = TRUE WHERE active IS NULL;
UPDATE man_type_function SET active = TRUE WHERE active IS NULL;

UPDATE config_form_fields SET dv_querytext = concat(REPLACE(dv_querytext, 'WHERE ', 'WHERE ('),') AND active IS TRUE ')
WHERE columnname IN ('location_type', 'category_type','fluid_type', 'function_type') 
AND (formname ilike 've_arc%' OR formname ilike 've_node%' OR formname ilike 've_connec%' OR formname ilike 've_gully%' 
OR formname in ('v_edit_element','v_edit_node','v_edit_arc','v_edit_connec','v_edit_gully')) and dv_querytext is not null;

UPDATE sys_function SET function_name = 'gw_fct_setnodefromarc' WHERE id = 2118;

--2021/01/05
UPDATE config_toolbox SET inputparams = '[{"widgetname":"arcSearchNodes", "label":"Start/end points buffer","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layoutorder":1, "value":"0.5"}]'
WHERE id = 2102;

UPDATE config_toolbox SET inputparams = '[{"widgetname":"connecTolerance", "label":"Node tolerance:", "widgettype":"spinbox","datatype":"float","layoutname":"grl_option_parameters","layoutorder":1,"value":0.01}]'
WHERE id = 2106;

UPDATE config_toolbox SET inputparams = '[{"widgetname":"nodeTolerance", "label":"Node tolerance:", "widgettype":"spinbox","datatype":"float","layoutname":"grl_option_parameters","layoutorder":1,"value":0.01}]'
WHERE id = 2108;

UPDATE config_toolbox SET inputparams = '[{"widgetname":"isArcDivide", "label":"Analyse nodes that divide arcs:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":1, "value":"FALSE"}]' 
WHERE id = 2110;

UPDATE config_toolbox SET inputparams =NULL WHERE id = 2202;

--2021/01/12
UPDATE config_toolbox SET inputparams = '[{"widgetname":"state_type", "label":"State:", "widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":3, "dvQueryText":"select value_state_type.id as id, concat(''state: '',value_state.name,'' state type: '', value_state_type.name) as idval from value_state_type join value_state on value_state.id = state where value_state_type.id is not null order by state, id", "selectedId":"2","isparent":"true"},{"widgetname":"workcat_id", "label":"Workcat:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":4, "dvQueryText":"select id as id, id as idval from cat_work where id is not null order by id", "selectedId":"1"},{"widgetname":"builtdate", "label":"Builtdate:", "widgettype":"datetime","datatype":"date","layoutname":"grl_option_parameters","layoutorder":5, "value":null },{"widgetname":"arc_type", "label":"Arc type:", "widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":6, "dvQueryText":"select distinct id as id, id as idval from cat_feature_arc where id is not null order by id", "selectedId":"1"},{"widgetname":"node_type", "label":"Node type:", "widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":7, "dvQueryText":"select distinct id as id, id as idval from cat_feature_node where id is not null order by id", "selectedId":"1"},{"widgetname":"topocontrol", "label":"Active topocontrol:", "widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":8, "value":"true"}, {"widgetname": "btn_path", "label": "Select DXF file:", "widgettype": "button",  "datatype": "text", "layoutname": "grl_option_parameters", "layoutorder": 9, "value": "...","widgetfunction":"import_dxf" }]'
WHERE id = 2784;

--2021/01/29
INSERT INTO config_form_tableview(location_type, project_type, tablename, columnname, columnindex,status, width, alias)
VALUES ('connec_form', 'utils','v_ui_hydrometer','hydrometer_id',1,TRUE,NULL,'sys_hydrometer_id');
INSERT INTO config_form_tableview(location_type, project_type, tablename, columnname, columnindex,status, width, alias)
VALUES ('connec_form', 'utils','v_ui_hydrometer','connec_id',2,TRUE,NULL,'sys_connec_id');
INSERT INTO config_form_tableview(location_type, project_type, tablename, columnname, columnindex,status, width, alias)
VALUES ('connec_form', 'utils','v_ui_hydrometer','hydrometer_customer_code',3,TRUE,NULL,'Hydro ccode:');
INSERT INTO config_form_tableview(location_type, project_type, tablename, columnname, columnindex,status, width, alias)
VALUES ('connec_form', 'utils','v_ui_hydrometer','connec_customer_code',4,TRUE,NULL,'Connec ccode:');
INSERT INTO config_form_tableview(location_type, project_type, tablename, columnname, columnindex,status, width, alias)
VALUES ('connec_form', 'utils','v_ui_hydrometer','state',5,TRUE,NULL,'State:');
INSERT INTO config_form_tableview(location_type, project_type, tablename, columnname, columnindex,status, width, alias)
VALUES ('connec_form', 'utils','v_ui_hydrometer','expl_id',6,TRUE,NULL,'Exploitation:');
INSERT INTO config_form_tableview(location_type, project_type, tablename, columnname, columnindex,status, width, alias)
VALUES ('connec_form', 'utils','v_ui_hydrometer','hydrometer_link',7,TRUE,NULL,'Link:');

--2021/02/01
UPDATE sys_table SET id ='config_graf_inlet' WHERE id ='config_mincut_inlet';
UPDATE sys_table SET id ='config_graf_checkvalve' WHERE id ='config_checkvalve';

UPDATE config_form_fields SET dv_querytext = replace(dv_querytext,'sys_role_id','sys_role')
WHERE dv_querytext ilike '%sys_role_id%';

-- 2021/04/02
UPDATE config_form_tableview SET columnindex = columnindex - 1;
ALTER TABLE config_form_tableview RENAME COLUMN status TO visible;
