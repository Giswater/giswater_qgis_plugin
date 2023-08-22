/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_csv set descript = 'The csv file must have the folloWing fields:
dscenario_name, feature_id, feature_type, value, demand_type, source', active = TRUE WHERE fid=501;

INSERT INTO sys_table(id, descript, sys_role,  source)
VALUES ('plan_netscenario' , 'Catalog of network scenarios', 'role_master', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source)
VALUES ('plan_netscenario_dma' , 'Table of spatial objects representing planified District Meter Area.', 'role_master', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source)
VALUES ('plan_netscenario_presszone' , 'Table of spatial objects representing planified Pressure Zones', 'role_master', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source)
VALUES ('plan_netscenario_arc' , 'Table to manage arcs related to each netscenarios', 'role_master', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source)
VALUES ('plan_netscenario_node' , 'Table to manage nodes related to each netscenarios', 'role_master', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source)
VALUES ('plan_netscenario_connec' , 'Table to manage connecs related to each netscenarios', 'role_master', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source)
VALUES ('selector_netscenario' , 'Selector of network scenarios', 'role_master', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, source)
VALUES (3256, 'gw_fct_graphanalytics_mapzones_plan', 'ws', 'function', 'json', 'json', 'Function to analyze network as a graph. Multiple analysis is avaliable  (PRESSZONE & DMA). Before start you need to configure:
- Field graph_delimiter on [cat_feature_node] table. 
- Field graphconfig on [plan_netscenario_presszone, plan_netscenario_dma] tables.
- Enable status for variable utils_graphanalytics_status on [config_param_system] table.
- Create an empty netscenario with type DMA or PRESSZONE.
Stop your mouse over labels for more information about input parameters.
This function could be automatic triggered by valve status (open or closed) by configuring utils_graphanalytics_automatic_trigger variable on [config_param_system] table.', 'role_master', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox 
VALUES (3256, 'Mapzone Netscenario Planification','{"featureType":[]}',
'[{"widgetname":"netscenario", "label":"Create mapzones for netscenario:","widgettype":"combo","datatype":"text","tooltip": "Create mapzone for a selected netscenario", "layoutname":"grl_option_parameters","layoutorder":1,"dvQueryText":"select netscenario_id as id, name as idval from plan_netscenario  order by name","isNullValue":"true", "selectedId":""},
{"widgetname":"floodOnlyMapzone", "label":"Flood only one mapzone: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Flood only identified mapzones. The purpose of this is update only network elements affected by this flooding keeping rest of network as is. Recommended to gain performance when mapzones ecosystem is under work", "placeholder":"1001", "layoutname":"grl_option_parameters","layoutorder":4, "value":""}, 
{"widgetname":"forceOpen", "label":"Force open nodes: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Optative node id(s) to temporary open closed node(s) in order to force algorithm to continue there", "placeholder":"1015,2231,3123", "layoutname":"grl_option_parameters","layoutorder":5, "value":""}, 
{"widgetname":"forceClosed", "label":"Force closed nodes: (*)","widgettype":"text","datatype":"text", "isMandatory":false, "tooltip":"Optative node id(s) to temporary close open node(s) to force algorithm to stop there","placeholder":"1015,2231,3123", "layoutname":"grl_option_parameters","layoutorder":6,"value":""}, 
{"widgetname":"netscenario_valve", "label":"Use valve status from dscenario:","widgettype":"combo","datatype":"text","tooltip": "Use closed and opened valves defined on inp_dscenario_shortpipe for selected dscenario", "layoutname":"grl_option_parameters","layoutorder":7,"dvQueryText":"select dscenario_id as id, name as idval from cat_dscenario where dscenario_type =''SHORTPIPE'' order by name","isNullValue":"true", "selectedId":""},
{"widgetname":"usePlanPsector", "label":"Use selected psectors:", "widgettype":"check","datatype":"boolean","tooltip":"If true, use selected psectors. If false ignore selected psectors and only works with on-service network" , "layoutname":"grl_option_parameters","layoutorder":8,"value":""}, 
{"widgetname":"updateMapZone", "label":"Mapzone constructor method:","widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":9,
"comboIds":[0,1,2,3,4], "comboNames":["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT & PIPE BUFFER", "LINK & PIPE BUFFER"], "selectedId":""}, 
{"widgetname":"geomParamUpdate", "label":"Pipe buffer","widgettype":"text","datatype":"float","tooltip":"Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.", "layoutname":"grl_option_parameters","layoutorder":10, "isMandatory":false, "placeholder":"5-30", "value":""}]',
null, true, '{4}');

INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, source)
VALUES (3258, 'gw_fct_set_netscenario_pattern', 'ws', 'function', 'json', 'json', 
'Function that allows to configure demand dscenario for connecs and nodes, using netscenarios mapzones, defined on table plan_netscenario_dma and using pattern_id assigned to each of the zones', 'role_epa', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox 
VALUES (3258, 'Set pattern values on demand dscenario','{"featureType":[]}',
'[{"widgetname":"netscenario", "label":"Source netscenario:","widgettype":"combo","datatype":"text","tooltip": "Select mapzone dscenario from where data will be copied to demand dscenario", "layoutname":"grl_option_parameters","layoutorder":1,"dvQueryText":"select dscenario_id as id, name as idval from plan_netscenario where netscenario_type =''DMA'' order by name","isNullValue":"true", "selectedId":""},
{"widgetname":"dscenario_demand", "label":"Target dscenario demand:","widgettype":"combo","datatype":"text","tooltip": "Select demand dscenario where data will be inserted", "layoutname":"grl_option_parameters","layoutorder":3,
"dvQueryText":"select dscenario_id as id, name as idval from cat_dscenario where dscenario_type =''DEMAND'' order by name","isNullValue":"true", "selectedId":""}]',
null, true, '{4}');

INSERT INTO config_typevalue(typevalue, id, addparam)
VALUES ('sys_table_context', '{"level_1":"MASTERPLAN","level_2":"NETSCENARIO"}', '{"orderBy":24}');

INSERT INTO sys_table(id, descript, sys_role,  source, context, orderby, alias, addparam)
VALUES ('v_plan_netscenario_dma' , 'View to visualize dma related to selected netscenario', 'role_master', 'core','{"level_1":"MASTERPLAN","level_2":"NETSCENARIO"}', 1, 'Netscenario DMA', '{"pkey":"netscenario_id, dma_id"}')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source, context, orderby, alias, addparam)
VALUES ('v_plan_netscenario_presszone' , 'View to visualize presszone related to selected netscenario', 'role_master', 'core','{"level_1":"MASTERPLAN","level_2":"NETSCENARIO"}', 2, 'Netscenario Presszone', '{"pkey":"netscenario_id, presszone_id"}')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source, context, orderby, alias, addparam)
VALUES ('v_plan_netscenario_arc' , 'View to visualize arcs related to selected netscenario', 'role_master', 'core','{"level_1":"MASTERPLAN","level_2":"NETSCENARIO"}', 3, 'Netscenario arc', '{"pkey":"netscenario_id, arc_id"}')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source, context, orderby, alias, addparam)
VALUES ('v_plan_netscenario_node' , 'View to visualize nodes related to selected netscenario', 'role_master', 'core','{"level_1":"MASTERPLAN","level_2":"NETSCENARIO"}', 4, 'Netscenario node', '{"pkey":"netscenario_id, node_id"}')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role,  source, context, orderby, alias, addparam)
VALUES ('v_plan_netscenario_connec' , 'View to visualize connecs related to selected netscenario', 'role_master', 'core','{"level_1":"MASTERPLAN","level_2":"NETSCENARIO"}', 5, 'Netscenario connec', '{"pkey":"netscenario_id, connec_id"}')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (502, 'Set dscenario demand using netscenario', 'ws', null, 'core', true, 'Function process', null) ON CONFLICT (fid) DO NOTHING;
	
INSERT INTO plan_typevalue
VALUES ('netscenario_type', 'DMA', 'DMA',NULL, NULL);

INSERT INTO plan_typevalue
VALUES ('netscenario_type', 'PRESSZONE', 'PRESSZONE',NULL, NULL);

INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, source)
VALUES (3260, 'gw_fct_create_netscenario_empty', 'ws', 'function', 'json', 'json', 
'Function that allows to create new empty netscenario', 'role_master', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox 
VALUES (3260, 'Create empty Netscenario','{"featureType":[]}',
'[{"widgetname":"name", "label":"Name: (*)","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name for netscenario (mandatory)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":1, "value":""},
{"widgetname":"descript", "label":"Descript:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Descript for netscenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"type", "label":"Type:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"netscenario type", "dvQueryText":"SELECT id, idval FROM plan_typevalue WHERE typevalue = ''netscenario_type''", "layoutname":"grl_option_parameters","layoutorder":4, "value":""},
{"widgetname":"active", "label":"Active:", "widgettype":"check", "datatype":"boolean", "tooltip":"If true, active" , "layoutname":"grl_option_parameters","layoutorder":5, "value":"true"},
{"widgetname":"expl", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"netscenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":6, "value":""}]',
null, true, '{4}') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, source)
VALUES (3262, 'gw_fct_create_netscenario_from_toc', 'ws', 'function', 'json', 'json', 
'Function that allows to create new configuration of netscenario and copy mapzones configuration for selected exploitation', 'role_master', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox 
VALUES (3262, 'Create Netscenario from ToC','{"featureType":[]}',
'[{"widgetname":"name", "label":"Name: (*)","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name for netscenario (mandatory)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":1, "value":""},
{"widgetname":"descript", "label":"Descript:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Descript for netscenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"type", "label":"Type:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"netscenario type", "dvQueryText":"SELECT id, idval FROM plan_typevalue WHERE typevalue = ''netscenario_type''", "layoutname":"grl_option_parameters","layoutorder":4, "value":""},
{"widgetname":"active", "label":"Active:", "widgettype":"check", "datatype":"boolean", "tooltip":"If true, active" , "layoutname":"grl_option_parameters","layoutorder":5, "value":"true"},
{"widgetname":"expl", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"netscenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":6, "value":""}]',
null, true, '{4}') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, source)
VALUES (3264, 'gw_fct_duplicate_netscenario', 'ws', 'function', 'json', 'json', 
'Function that allows to create new configuration of netscenario and copy mapzones configuration from already created netscenario', 'role_master', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox 
VALUES (3264, 'Duplicate Netscenario','{"featureType":[]}',
'[{"widgetname":"copyFrom", "label":"Copy from:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT netscenario_id as id, name as idval FROM plan_netscenario WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":0, "selectedId":""},
{"widgetname":"name", "label":"Name: (*)","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name for netscenario (mandatory)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":1, "value":""},
{"widgetname":"descript", "label":"Descript:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Descript for netscenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"parent", "label":"Parent:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Parent for netscenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},
{"widgetname":"active", "label":"Active:", "widgettype":"check", "datatype":"boolean", "tooltip":"If true, active" , "layoutname":"grl_option_parameters","layoutorder":5, "value":"true"}]',
null, true, '{4}') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (508, 'Create new Netscenario', 'ws', null, 'core', true, 'Function process', null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (510, 'Duplicate Netscenario', 'ws', null, 'core', true, 'Function process', null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (512, 'Create Netscenario from ToC', 'ws', null, 'core', true, 'Function process', null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (504, 'Import flowmeter daily values', 'ws', null, 'core', true, 'Function process', null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (506, 'Import flowmeter agg values', 'ws', null, 'core', true, 'Function process', null) ON CONFLICT (fid) DO NOTHING;
	
INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, source)
VALUES (3260, 'gw_fct_import_scada_flowmeteragg_values', 'ws', 'function', 'json', 'json', 
'Function to import flowmeter aggregated values with random interval in order to transform to daily values', 'role_om', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_csv VALUES (504, 'Import flowmeter daily values', 'Import daily flowmeter values into table ext_rtc_scada_x_data according example file scada_flowmeter_daily_values.csv', 'gw_fct_import_scada_values', true, 21);

INSERT INTO config_csv VALUES (506, 'Import flowmeter agg values', 'Import aggregated flowmeter values into table ext_rtc_scada_x_data according example file scada_flowmeter_agg_values.csv', 'gw_fct_import_scada_flowmeteragg_values', true, 22);

UPDATE sys_function SET function_name = 'gw_fct_import_scada_values' WHERE id = 3166;
UPDATE sys_fprocess SET fprocess_name = 'Import scada values' WHERE fid = 469;
UPDATE config_csv SET alias = 'Import scada values', descript = 'Import scada values into table ext_rtc_scada_x_data according example file scada_values.csv', 
functionname = 'gw_fct_import_scada_values' WHERE fid = 469;

INSERT INTO ext_rtc_scada_x_data (scada_id, node_id, value_date, value, value_status)
SELECT node_id, node_id, value_date, value, value_status FROM _ext_rtc_scada_x_data36_;

INSERT INTO config_typevalue(typevalue, id, idval, camelstyle, addparam)
VALUES ('tabname_typevalue', 'tab_netscenario', 'tab_netscenario', 'tabNetscenario', NULL) ON CONFLICT (typevalue, id) DO NOTHING;
	
INSERT INTO config_form_tabs(formname, tabname, label, tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES ('selector_netscenario', 'tab_netscenario', 'Netscenario', 'Netscenario Selector', 'role_basic', null, null, 1,'{4,5}') ON CONFLICT (formname, tabname) DO NOTHING;

INSERT INTO config_param_system(
parameter, value, descript, label, 
dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type,  datatype)
VALUES ('basic_selector_tab_netscenario', '{"table":"plan_netscenario","table_id":"netscenario_id","selector":"selector_netscenario","selector_id":"netscenario_id","label":"netscenario_id, ''-'', name ","query_filter":" AND id > 0 ","manageAll":true}', 'Variable to configura all options related to search for the specificic tab','Selector variables', 
null, null, true, null, 'ws', 'json') ON CONFLICT (parameter) DO NOTHING;

UPDATE config_toolbox SET inputparams = b.inp FROM (SELECT json_agg(a.inputs) AS inp FROM
(SELECT json_array_elements(inputparams)as inputs, json_extract_path_text(json_array_elements(inputparams),'widgetname') as widget
FROM   config_toolbox 
WHERE id=2706)a WHERE widget!='sector')b WHERE  id=2706;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (508, 'Set rpt results as archived', 'ws', null, 'core', true, 'Function process', null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, source)
VALUES (3266, 'gw_fct_set_rpt_archived', 'ws', 'function', 'json', 'json', 
'Function that moves data related to selected result_id from rpt and rpt_inp tables to archived tables', 'role_edit', 'core') ON CONFLICT (fid) DO NOTHING;