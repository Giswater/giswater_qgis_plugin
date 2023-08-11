/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_csv set descript = 'The csv file must have the folloWing fields:
dscenario_name, feature_id, feature_type, value, demand_type, source', active = TRUE WHERE fid=501;

INSERT INTO inp_typevalue
VALUES ('inp_typevalue_dscenario', 'MAPZONE', 'MAPZONE',NULL, NULL);

INSERT INTO sys_table(id, descript, sys_role,  source)
VALUES ('inp_dscenario_mapzone' , 'Table to manage mapzones defined for a specific dscenario', 'role_epa', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, source)
VALUES (3256, 'gw_fct_graphanalytics_mapzones_plan', 'ws', 'function', 'json', 'json', 'Function to analyze network as a graph. Multiple analysis is avaliable (SECTOR, DQA, PRESSZONE & DMA). Before start you need to configure:
- Field graph_delimiter on [cat_feature_node] table. 
- Field graphconfig on [dma, sector, cat_presszone and dqa] tables.
- Enable status for variable utils_graphanalytics_status on [config_param_system] table.
- Create an empty dscenario with type MAPZONE.
Stop your mouse over labels for more information about input parameters.
This function could be automatic triggered by valve status (open or closed) by configuring utils_graphanalytics_automatic_trigger variable on [config_param_system] table.', 'role_epa', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox 
VALUES (3256, 'Mapzone Dscenario Planification','{"featureType":[]}',
'[{"widgetname":"graphClass", "label":"Graph class:", "widgettype":"combo","datatype":"text","tooltip": "Graphanalytics method used", "layoutname":"grl_option_parameters","layoutorder":1,"comboIds":["PRESSZONE","DQA","DMA","SECTOR"],
"comboNames":["Pressure Zonification (PRESSZONE)", "District Quality Areas (DQA) ", "District Metering Areas (DMA)", "Inlet Sectorization (SECTOR-HIGH / SECTOR-LOW)"], "selectedId":""}, 
{"widgetname":"exploitation", "label":"Exploitation:","widgettype":"combo","datatype":"text","tooltip": "Choose exploitation to work with", "layoutname":"grl_option_parameters","layoutorder":2, 
"dvQueryText":"select expl_id as id, name as idval from exploitation where active is not false order by name", "selectedId":"$userExploitation"}, 
{"widgetname":"floodOnlyMapzone", "label":"Flood only one mapzone: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Flood only identified mapzones. The purpose of this is update only network elements affected by this flooding keeping rest of network as is. Recommended to gain performance when mapzones ecosystem is under work", "placeholder":"1001", "layoutname":"grl_option_parameters","layoutorder":3, "value":""}, 
{"widgetname":"forceOpen", "label":"Force open nodes: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Optative node id(s) to temporary open closed node(s) in order to force algorithm to continue there", "placeholder":"1015,2231,3123", "layoutname":"grl_option_parameters","layoutorder":4, "value":""}, 
{"widgetname":"forceClosed", "label":"Force closed nodes: (*)","widgettype":"text","datatype":"text", "isMandatory":false, "tooltip":"Optative node id(s) to temporary close open node(s) to force algorithm to stop there","placeholder":"1015,2231,3123", "layoutname":"grl_option_parameters","layoutorder":5,"value":""}, 
{"widgetname":"usePlanPsector", "label":"Use selected psectors:", "widgettype":"check","datatype":"boolean","tooltip":"If true, use selected psectors. If false ignore selected psectors and only works with on-service network" , "layoutname":"grl_option_parameters","layoutorder":6,"value":""}, 
{"widgetname":"updateMapZone", "label":"Mapzone constructor method:","widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":7,
"comboIds":[0,1,2,3,4], "comboNames":["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT & PIPE BUFFER", "LINK & PIPE BUFFER"], "selectedId":""}, 
{"widgetname":"geomParamUpdate", "label":"Pipe buffer","widgettype":"text","datatype":"float","tooltip":"Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.", "layoutname":"grl_option_parameters","layoutorder":8, "isMandatory":false, "placeholder":"5-30", "value":""}, 
{"widgetname":"dscenario_mapzone", "label":"Create mapzones for dscenario:","widgettype":"combo","datatype":"text","tooltip": "Create mapzone for a selected dscenario", "layoutname":"grl_option_parameters","layoutorder":9,"dvQueryText":"select dscenario_id as id, name as idval from cat_dscenario where dscenario_type =''MAPZONE'' order by name","isNullValue":"true", "selectedId":""},
{"widgetname":"dscenario_valve", "label":"Use valve status from dscenario:","widgettype":"combo","datatype":"text","tooltip": "Use closed and opened valves defined on inp_dscenario_shortpipe for selected dscenario", "layoutname":"grl_option_parameters","layoutorder":10,"dvQueryText":"select dscenario_id as id, name as idval from cat_dscenario where dscenario_type =''SHORTPIPE'' order by name","isNullValue":"true", "selectedId":""}]',
null, true, '{4}');

INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, source)
VALUES (3258, 'gw_fct_mapzones_dscenario_pattern', 'ws', 'function', 'json', 'json', 
'Function that allows to configure demand dscenario for connecs and nodes, depending on their mapzones, defined on table inp_dscenario_mapzones and using pattern_id assigned to each of the zones', 'role_epa', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox 
VALUES (3258, 'Manage Mapzone Dscenario Demand','{"featureType":[]}',
'[{"widgetname":"dscenario_mapzone", "label":"Source dscenario mapzone:","widgettype":"combo","datatype":"text","tooltip": "Select mapzone dscenario from where data will be copied to demand dscenario", "layoutname":"grl_option_parameters","layoutorder":1,"dvQueryText":"select dscenario_id as id, name as idval from cat_dscenario where dscenario_type =''MAPZONE'' order by name","isNullValue":"true", "selectedId":""},
{"widgetname":"graphClass", "label":"Graph class:", "widgettype":"combo","datatype":"text","tooltip": "Graphanalytics method used", "layoutname":"grl_option_parameters","layoutorder":2,"comboIds":["PRESSZONE","DQA","DMA","SECTOR"],
"comboNames":["Pressure Zonification (PRESSZONE)", "District Quality Areas (DQA) ", "District Metering Areas (DMA)", "Inlet Sectorization (SECTOR-HIGH / SECTOR-LOW)"], "selectedId":""}, 
{"widgetname":"dscenario_demand", "label":"Target dscenario demand:","widgettype":"combo","datatype":"text","tooltip": "Select demand dscenario where data will be inserted", "layoutname":"grl_option_parameters","layoutorder":3,
"dvQueryText":"select dscenario_id as id, name as idval from cat_dscenario where dscenario_type =''DEMAND'' order by name","isNullValue":"true", "selectedId":""}]',
null, true, '{4}');

INSERT INTO sys_table(id, descript, sys_role,  source, context, orderby, alias, addparam)
VALUES ('v_edit_inp_dscenario_mapzone' , 'Editable view to manage mapzones defined for a specific dscenario', 'role_epa', 'core','{"level_1":"EPA","level_2":"DSCENARIO"}', 17, 'Mapzone Dscenario', '{"pkey":"dscenario_id, mapzone_type, mapzone_id"}')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_form_fields 
SELECT 'v_edit_inp_dscenario_mapzone', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, columnname, tooltip, placeholder, ismandatory, 
isparent, false, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_cat_dscenario' AND 
columnname in ('dscenario_id', 'name') ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING; 

INSERT INTO config_form_fields 
SELECT 'v_edit_inp_dscenario_mapzone', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, 'pattern_id', tooltip, placeholder, ismandatory, 
isparent, true, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_dscenario_demand' AND 
columnname in ('pattern_id') ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields 
VALUES ('v_edit_inp_dscenario_mapzone', 'form_feature', 'tab_none', 'arcs', null, null, 'string', 'text', 'arcs', null, null, false, 
false, false, false, false, null, null, null, null, null, null, 
null, null, null, false);

INSERT INTO config_form_fields 
VALUES ('v_edit_inp_dscenario_mapzone', 'form_feature', 'tab_none', 'nodes', null, null, 'string', 'text', 'nodes', null, null, false, 
false, false, false, false, null, null, null, null, null, null, 
null, null, null, false);

INSERT INTO config_form_fields 
VALUES ('v_edit_inp_dscenario_mapzone', 'form_feature', 'tab_none', 'connecs', null, null, 'string', 'text', 'connecs', null, null, false, 
false, false, false, false, null, null, null, null, null, null, 
null, null, null, false);

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (502, 'Mapzone dscenario demand', 'ws', null, 'core', true, 'Function process', null) ON CONFLICT (fid) DO NOTHING;
	
