/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/09/29
INSERT INTO config_param_system(parameter, value, descript, label,  isenabled, layoutorder, project_type, datatype, widgettype, layoutname)
VALUES ('utils_graphanalytics_status','{"DRAINZONE":true}', 'Dynamic mapzones', 'Dynamic mapzones', TRUE, 12, 'utils', 
'json', 'text', 'lyt_admin_om') ON CONFLICT (parameter) DO NOTHING;


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate,  widgetcontrols,  hidden)
SELECT distinct on (formname) formname, 'form_feature', 'data', 'drainzone_id', 'lyt_data_1', max(layoutorder)+1,
'integer', 'text', 'drainzone_id', false, false, false, false, '{"setMultiline":false}', false
FROM config_form_fields
WHERE (formname ilike 've_%' or formname in('v_edit_node', 'v_edit_arc', 'v_edit_connec', 'v_edit_gully')) and formname !='ve_config_sysfields' 
group by formname ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

DELETE FROM config_toolbox WHERE id=2768;
DELETE FROM sys_function WHERE id = 2710 OR id = 2768;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (2710, 'gw_fct_graphanalytics_mapzones', 'utils', 'function', 'json', 'json', 'Function to analyze graph of network. Multiple analysis is avaliable. Dynamic analisys to sectorize network using the flow traceability function. 
Before work with this funcion it is mandatory to configurate field graph_delimiter on node_type and field graphconfig on [dma, sector, cat_presszone and dqa] tables',
'role_om',null,'core')  ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (2768, 'gw_fct_graphanalytics_mapzones_advanced', 'utils', 'function', 'json', 'json', 'Function to analyze network as a graph. Multiple analysis is avaliable (SECTOR, DQA, PRESSZONE & DMA). Before start you need to configurate:
- Field graph_delimiter on [cat_feature_node] table. 
- Field graphconfig on [dma, sector, cat_presszone and dqa] tables.
- Enable status for variable utils_graphanalytics_status on [config_param_system] table.
Stop your mouse over labels for more information about input parameters.
This function could be automatic triggered by valve status (open or closed) by configuring utils_graphanalytics_automatic_trigger variable on [config_param_system] table.',
'role_om',null,'core')  ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active)
VALUES (2768, 'Mapzones analysis', '{"featureType":[]}', '[
{"widgetname":"graphClass", "label":"Graph class:", "widgettype":"combo","datatype":"text","tooltip": "Graphanalytics method used", "layoutname":"grl_option_parameters","layoutorder":1,"comboIds":["DRAINZONE"],
"comboNames":["Drainage area (DRAINZONE)"], "selectedId":""}, 
{"widgetname":"exploitation", "label":"Exploitation:","widgettype":"combo","datatype":"text","tooltip": "Choose exploitation to work with", "layoutname":"grl_option_parameters","layoutorder":2, 
"dvQueryText":"select expl_id as id, name as idval from exploitation where active is not false order by name", "selectedId":"$userExploitation"},
{"widgetname":"floodOnlyMapzone", "label":"Flood only one mapzone: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Flood only identified mapzones. The purpose of this is update only network elements affected by this flooding keeping rest of network as is. Recommended to gain performance when mapzones ecosystem is under work", "placeholder":"1001", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},
{"widgetname":"floodFromNode", "label":"Flood from node: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Optative parameter to constraint algorithm to work only flooding from any node on network, used to define only the related mapzone", "placeholder":"1015", "layoutname":"grl_option_parameters","layoutorder":4, "value":""},
{"widgetname":"forceOpen", "label":"Force open nodes: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Optative node id(s) to temporary open closed node(s) in order to force algorithm to continue there", "placeholder":"1015,2231,3123", "layoutname":"grl_option_parameters","layoutorder":5, "value":""},
{"widgetname":"forceClosed", "label":"Force closed nodes: (*)","widgettype":"text","datatype":"text", "isMandatory":false, "tooltip":"Optative node id(s) to temporary close open node(s) to force algorithm to stop there","placeholder":"1015,2231,3123", "layoutname":"grl_option_parameters","layoutorder":6,"value":""},
{"widgetname":"usePlanPsector", "label":"Use selected psectors:", "widgettype":"check","datatype":"boolean","tooltip":"If true, use selected psectors. If false ignore selected psectors and only works with on-service network" , "layoutname":"grl_option_parameters","layoutorder":7,"value":""},
{"widgetname":"commitChanges", "label":"Commit changes:", "widgettype":"check","datatype":"boolean","tooltip":"If true, changes will be applied to DB. If false, algorithm results will be saved in anl tables" , "layoutname":"grl_option_parameters","layoutorder":8,"value":""},
{"widgetname":"valueForDisconnected", "label":"Value for disconn. and conflict: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Value to use for disconnected features. Usefull for work in progress with dynamic mpzonesnode" , "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":9, "value":""},
{"widgetname":"updateMapZone", "label":"Mapzone constructor method:","widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":10,
"comboIds":[0,1,2,6], "comboNames":["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "EPA SUBCATCH"], "selectedId":""}, 
{"widgetname":"geomParamUpdate", "label":"Pipe buffer","widgettype":"text","datatype":"float","tooltip":"Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.", "layoutname":"grl_option_parameters","layoutorder":11, "isMandatory":false, "placeholder":"5-30", "value":""}
]',NULL, TRUE) ON CONFLICT (id) DO NOTHING;

UPDATE config_form_fields SET widgetcontrols='{"autoupdateReloadFields":["node_1", "y1", "custom_y1", "custom_elev1", "sys_y1", "sys_elev1", "z1", "r1","slope"]}'
WHERE isautoupdate is true and columnname ilike '%1' and formname ilike '%arc%';

UPDATE config_form_fields SET widgetcontrols='{"autoupdateReloadFields":["node_2", "y2", "custom_y2", "custom_elev2", "sys_y2", "sys_elev2", "z2", "r2","slope"]}'
WHERE isautoupdate is true and columnname ilike '%2' and formname ilike '%arc%';

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (432, 'Check node ''T candidate'' with wrong topology','ws', null, null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate,  widgetcontrols,  hidden)
SELECT distinct on (child_layer) child_layer, 'form_feature', 'data', 'step_pp', 'lyt_data_2', max(layoutorder)+1,
'integer', 'text', 'step PP', false, false, true, false, '{"setMultiline":false}', false
FROM cat_feature cf
join  config_form_fields on child_layer =formname
WHERE system_id='MANHOLE' group by cf.child_layer ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate,  widgetcontrols,  hidden)
SELECT distinct on (child_layer) child_layer, 'form_feature', 'data', 'step_fe', 'lyt_data_2', max(layoutorder)+1,
'integer', 'text', 'step Fe', false, false, true, false, '{"setMultiline":false}', false
FROM cat_feature cf
join  config_form_fields on child_layer =formname
WHERE system_id='MANHOLE' group by cf.child_layer ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate,  widgetcontrols,  hidden)
SELECT distinct on (child_layer) child_layer, 'form_feature', 'data', 'step_replace', 'lyt_data_2', max(layoutorder)+1,
'integer', 'text', 'step replace', false, false, true, false, '{"setMultiline":false}', false
FROM cat_feature cf
join  config_form_fields on child_layer =formname
WHERE system_id='MANHOLE' group by cf.child_layer ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate,  widgetcontrols,  hidden)
SELECT distinct on (child_layer) child_layer, 'form_feature', 'data', 'cover', 'lyt_data_2', max(layoutorder)+1,
'string', 'text', 'cover', false, false, true, false, '{"setMultiline":false}', false
FROM cat_feature cf
join  config_form_fields on child_layer =formname
WHERE system_id='MANHOLE' group by cf.child_layer ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE sys_table SET context='{"level_1":"INVENTORY","level_2":"CATALOGS"}', orderby=23, alias='Arc shape catalog' WHERE id='cat_arc_shape';
UPDATE sys_table SET context='{"level_1":"INVENTORY","level_2":"CATALOGS"}', orderby=24, alias='Node shape catalog' WHERE id='cat_node_shape';

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (481, 'Drainzone Sectorization', 'ud', NULL, 'core', true, 'Function process', NULL)  ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_function(id, function_name, style, layermanager, actions)
VALUES (2710, 'gw_fct_graphanalytics_mapzones', '{"style": {"point": {"style": "categorized", "field": "descript", "transparency": 0.5, "width": 2.5, "values": [{"id": "Disconnected", "color": [255,124,64]}, {"id": "Conflict", "color": [14,206,253]}]},
"line": {"style": "categorized", "field": "descript", "transparency": 0.5, "width": 2.5, "values": [{"id": "Disconnected", "color": [255,124,64]}, {"id": "Conflict", "color": [14,206,253]}]}}}',
null,'[{"funcName": "set_style_mapzones", "params": {}}]') ON CONFLICT (id) DO NOTHING; 

INSERT INTO sys_table( id, descript, sys_role,  source)
VALUES ('drainzone', 'Table of spatial objects representing Drainage zones', 'role_edit', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, criticity, context, orderby, alias, source)
VALUES ('v_edit_drainzone', 'Shows editable information about drainzone.', 'role_edit', 2, '{"level_1":"INVENTORY","level_2":"MAP ZONES"}', 4, 'DRAINZONE','core') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, descript, sys_role,  source)
VALUES (3178, 'gw_trg_edit_drainzone', 'ud', 'trigger function',  'Trigger for editing view v_edit_drainzone', 'role_edit',  'core');

INSERT INTO drainzone(drainzone_id, name, descript,active)
VALUES (-1, 'Conflict', 'Drainzone used on graphanalytics algorithm when two ore more zones has conflict in terms of some interconnection.',true);

INSERT INTO drainzone(drainzone_id, name, active)
VALUES (0, 'Undefined', true);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate,  widgetcontrols,  hidden)
SELECT distinct on (child_layer) child_layer, 'form_feature', 'data', 'cat_area', 'lyt_data_1', max(layoutorder)+1,
'numeric', 'text', 'Area', false, false, false, false, '{"setMultiline":false}', false
FROM cat_feature cf
join  config_form_fields on child_layer =formname
WHERE feature_type='ARC' and layoutname = 'lyt_data_1' group by cf.child_layer ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_function(id, function_name, style, layermanager, actions)
VALUES (2832, 'gw_fct_getprofilevalues', '{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', null, null);


INSERT INTO sys_table( id, descript, sys_role,  source)
VALUES ('anl_gully', 'Table to analyze gullies', 'role_edit', 'core') ON CONFLICT (id) DO NOTHING;

UPDATE sys_function SET descript = concat(descript,' ', 'Value of geom1 (height) from arc catalog is being used to compare the section values.')
WHERE id = 3176;

UPDATE inp_timeseries SET active=true;

UPDATE plan_psector_x_gully pg SET active = p.active FROM plan_psector p WHERE p.psector_id=pg.psector_id;

update link set exit_id = arc_id FROM gully where feature_id = gully_id and exit_type = 'ARC';
UPDATE link SET exit_id = arc_id FROM connec c WHERE connec_id = feature_id AND exit_type  ='ARC';

UPDATE arc SET node_sys_top_elev_1 = sys_top_elev FROM vu_node WHERE node_id = node_1;
UPDATE arc SET node_sys_elev_1 = sys_elev FROM vu_node WHERE node_id = node_1;
UPDATE arc SET node_sys_top_elev_2 = sys_top_elev FROM vu_node WHERE node_id = node_2;
UPDATE arc SET node_sys_elev_2 = sys_elev FROM vu_node WHERE node_id = node_2;
UPDATE arc SET nodetype_1 = node_type FROM vu_node WHERE node_id = node_1;
UPDATE arc SET nodetype_2 = node_type FROM vu_node WHERE node_id = node_2;

UPDATE config_form_fields
SET widgetcontrols='{"autoupdateReloadFields": ["node_1", "node_2", "y1", "custom_y1", "sys_y1", "elev1", "custom_elev1", "sys_elev1", "z1", "r1", "y2", "custom_y2", "sys_y2", "elev2", "custom_elev2", "sys_elev2", "z2", "r2", "slope"]}'
WHERE formname like 've_arc_%' AND formtype='form_feature' AND tabname='data' AND columnname IN ('elev1', 'y1', 'custom_y1', 'custom_elev1', 'elev2', 'y2', 'custom_y2', 'custom_elev2');

UPDATE link SET dma_id = c.dma_id, sector_id = c.sector_id FROM connec c WHERE feature_id = connec_id;
UPDATE link SET dma_id = c.dma_id, sector_id = c.sector_id FROM gully c WHERE feature_id = gully_id;


INSERT INTO sys_table( id, descript, sys_role, source)
VALUES ('vu_link_connec', 'Unfiltered view of links', 'role_basic', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table( id, descript, sys_role, source)
VALUES ('vu_link_gully', 'Unfiltered view of gully links ', 'role_basic', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table( id, descript, sys_role, source)
VALUES ('v_state_link_gully', 'View to filter gully links', 'role_basic', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table( id, descript, sys_role, source)
VALUES ('v_link_gully', 'Filtered view of links type connec', 'role_basic', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table( id, descript, sys_role, source)
VALUES ('v_edit_plan_psector_x_gully', 'Editable view to work with psector and gully', 'role_master', 'core') ON CONFLICT (id) DO NOTHING;

-- 2022/12/28
UPDATE inp_typevalue SET typevalue = 'inp_typevalue_gully_method' where  typevalue  ='typevalue_gully_method';
UPDATE inp_typevalue SET typevalue = 'inp_typevalue_gully_type' where  typevalue  ='typevalue_gully_outlet_type';
UPDATE inp_typevalue SET id  ='W_O', idval = 'W_O' WHERE id = 'W/O' AND typevalue  ='inp_typevalue_gully_method';

UPDATE sys_foreignkey SET typevalue_name = 'inp_typevalue_gully_method' where  typevalue_name  ='typevalue_gully_method';
UPDATE sys_foreignkey SET typevalue_name = 'inp_typevalue_gully_type' where  typevalue_name  ='typevalue_gully_outlet_type';


UPDATE config_form_fields SET dv_querytext = 'SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue = ''inp_typevalue_gully_type'''  
WHERE formname like '%gully%' and columnname ='outlet_type';

UPDATE config_form_fields SET dv_querytext = 'SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue = ''inp_typevalue_gully_method''' 
where formname like '%gully%' and columnname ='method';

UPDATE inp_gully SET method = 'W_O' WHERE method = 'W/O';

UPDATE sys_param_user SET dv_querytext ='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue = ''inp_typevalue_gully_type''', 
vdefault = 'To_network' WHERE id = 'epa_gully_outlet_type_vdefault';
UPDATE sys_param_user SET dv_querytext ='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue = ''inp_typevalue_gully_method''', 
vdefault = 'W_O' WHERE id = 'epa_gully_method_vdefault';

UPDATE config_param_user SET value = 'To_network' WHERE parameter = 'epa_gully_outlet_type_vdefault';
UPDATE config_param_user SET value = 'W_O' WHERE parameter = 'epa_gully_method_vdefault';


INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3186, 'gw_fct_epa_setjunctionsoutlet', 'ud', 'function', 'json', 'json', 'Function to set junctions as oultets of subcatchments filtering by a minimum distance one each other',
'role_epa',null,'core')  ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (484, 'Set junctions as outlet', 'ud', NULL, 'core', true, 'Function process', NULL)
 ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active)
VALUES (3186, 'Set junctions as outlet', '{"featureType":["NODE"]}', 
'[{"widgetname":"minDistance", "label":"Junction minimum distance","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Value to set minimum distance for junctions" , "placeholder":"10", "layoutname":"grl_option_parameters","layoutorder":1, "value":""}]',
NULL, TRUE) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function
VALUES (3186, 'gw_fct_epa_setjunctionsoutlet', '{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}')
 ON CONFLICT (id) DO NOTHING;
 
 
delete from config_form_tableview where tablename='plan_psector_x_gully';

INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_gully', 'id', 0, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_gully', 'gully_id', 1, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_gully', 'arc_id', 2, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_gully', 'psector_id', 3, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_gully', 'state', 4, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_gully', 'doable', 5, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_gully', 'descript', 6, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_gully', '_link_geom_', 7, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_gully', '_userdefined_geom_', 8, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_gully', 'link_id', 9, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_gully', 'active', 10, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_gully', 'insert_tstamp', 11, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_gully', 'insert_user', 12, false, NULL, NULL, NULL);