/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/12/22
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (432, 'Check node ''T candidate'' with wrong topology','ws', null, null) ON CONFLICT (fid) DO NOTHING;

--2021/12/30
UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'checkData', 'NONE'::text) WHERE parameter = 'utils_grafanalytics_status';

--2021/12/31
UPDATE config_function SET style = 
'{"style": {"point": {"style": "categorized", "field": "descript", "transparency": 0.5, "width": 2.5, "values": [{"id": "Disconnected", "color": [255,124,64]}, {"id": "Conflict", "color": [14,206,253]}]},
"line": {"style": "categorized", "field": "descript", "transparency": 0.5, "width": 2.5, "values": [{"id": "Disconnected", "color": [255,124,64]}, {"id": "Conflict", "color": [14,206,253]}]}}}'
WHERE id = 2710; 


UPDATE sys_param_user SET formname  ='hidden' WHERE id IN('inp_options_demandtype','inp_options_rtc_period_id');
UPDATE sys_param_user SET dv_parent_id = null, dv_querytext_filterc = null WHERE id ='inp_options_patternmethod';

UPDATE inp_typevalue SET addparam=null where typevalue = 'inp_value_patternmethod';

ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
DELETE FROM inp_typevalue where typevalue = 'inp_value_patternmethod' and id::integer > 20;
UPDATE inp_typevalue SET id = '14' WHERE id = '13' AND  typevalue = 'inp_value_patternmethod';
UPDATE inp_typevalue SET id = '13' WHERE id = '12' AND  typevalue = 'inp_value_patternmethod';
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','12','SECTOR PATTERN');
UPDATE inp_typevalue SET idval = 'DEFAULT PATTERN' WHERE id = '11' AND  typevalue = 'inp_value_patternmethod';
UPDATE inp_typevalue SET idval = 'FEATURE PATTERN' WHERE id = '14' AND  typevalue = 'inp_value_patternmethod';
UPDATE inp_typevalue SET idval = 'DMA PATTERN' WHERE id = '13' AND  typevalue = 'inp_value_patternmethod';
ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;

UPDATE inp_typevalue SET idval = 'CONNEC (ALL NODARCS)' WHERE typevalue = 'inp_options_networkmode' AND id  ='4';
UPDATE inp_typevalue SET idval = 'NODE (BASIC NODARCS)' WHERE typevalue = 'inp_options_networkmode' AND id  ='1';

UPDATE sys_param_user SET label= 'Default pattern:' WHERE id = 'inp_options_pattern';

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, 
return_type, descript, sys_role, sample_query, source)
VALUES (3108, 'gw_fct_create_dscenario_from_toc', 'ws', 'function', 'json', 
'json', 'Function to create network dscenarios from ToC.',
'role_epa', null, null) ON CONFLICT (id) DO NOTHING;

UPDATE config_toolbox SET id = 3108 WHERE id = 3104;

UPDATE config_toolbox SET alias = 'Create Dscenario from ToC' WHERE id = 3108;

DELETE FROM sys_param_user WHERE id = 'inp_options_demand_model';
INSERT INTO sys_param_user(id, idval, formname, descript, sys_role, label, dv_querytext, isenabled, layoutname, layoutorder,
project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, vdefault, iseditable, epaversion)
VALUES ('inp_options_demand_model', 'DEMAND MODEL', 'epaoptions', 'Demand model:', 'role_epa', 'Demand model' , 'SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_options_demand_model''',true, 'lyt_general_1',10,
'ws', FALSE, FALSE, 'text', 'combo', true, 'PDA', TRUE, '{"from":"2.0.12", "to":null, "language":"english"}') 
ON CONFLICT (id) DO NOTHING;

DELETE FROM sys_param_user WHERE id = 'inp_options_minimum_pressure';
INSERT INTO sys_param_user(id, idval, formname, descript, sys_role, label,  isenabled, layoutname, layoutorder,
project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, vdefault, iseditable, epaversion)
VALUES ('inp_options_minimum_pressure', 'MINIMUM PRESSURE', 'epaoptions', 'Mininum pressure:', 'role_epa', 'Mininum pressure' , true, 'lyt_general_2',10,
'ws', FALSE, FALSE, 'text', 'linetext', true, '0', TRUE, '{"from":"2.0.12", "to":null, "language":"english"}') 
ON CONFLICT (id) DO NOTHING;

DELETE FROM sys_param_user WHERE id = 'inp_options_required_pressure';
INSERT INTO sys_param_user(id, idval, formname, descript, sys_role, label, isenabled, layoutname, layoutorder,
project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, vdefault, iseditable, epaversion)
VALUES ('inp_options_required_pressure', 'REQUIRED PRESSURE', 'epaoptions', 'Required pressure:', 'role_epa', 'Required pressure' , true, 'lyt_general_1',11,
'ws', FALSE, FALSE, 'text', 'linetext', true, '10', TRUE, '{"from":"2.0.12", "to":null, "language":"english"}') 
ON CONFLICT (id) DO NOTHING;

DELETE FROM sys_param_user WHERE id = 'inp_options_pressure_exponent';
INSERT INTO sys_param_user(id, idval, formname, descript, sys_role, label, isenabled, layoutname, layoutorder,
project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, vdefault, iseditable, epaversion)
VALUES ('inp_options_pressure_exponent', 'PRESSURE EXPONENT', 'epaoptions', 'Presure exponent:', 'role_epa', 'Presure exponent' , true, 'lyt_general_2',11,
'ws', FALSE, FALSE, 'text', 'linetext', true, '0.5', TRUE, '{"from":"2.0.12", "to":null, "language":"english"}') 
ON CONFLICT (id) DO NOTHING;

DELETE FROM sys_param_user WHERE id = 'inp_options_max_headerror';
INSERT INTO sys_param_user(id, idval, formname, descript, sys_role, label, isenabled, layoutname, layoutorder,
project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, vdefault, iseditable, epaversion)
VALUES ('inp_options_max_headerror', 'HEADERROR', 'epaoptions', 'Max. head error:', 'role_epa', 'Max head error' , true, 'lyt_hydraulics_1',11,
'ws', FALSE, FALSE, 'text', 'linetext', true, '0', TRUE, '{"from":"2.0.12", "to":null, "language":"english"}') 
ON CONFLICT (id) DO NOTHING;

DELETE FROM sys_param_user WHERE id = 'inp_options_max_flowchange';
INSERT INTO sys_param_user(id, idval, formname, descript, sys_role, label, isenabled, layoutname, layoutorder,
project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, vdefault, iseditable, epaversion)
VALUES ('inp_options_max_flowchange', 'FLOWCHANGE', 'epaoptions', 'Max. flow change:', 'role_epa', 'Max flow change' , true, 'lyt_hydraulics_2',11,
'ws', FALSE, FALSE, 'text', 'linetext', true, '0', TRUE, '{"from":"2.0.12", "to":null, "language":"english"}') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO inp_typevalue VALUES ('inp_options_demand_model','DDA','DDA');
INSERT INTO inp_typevalue VALUES ('inp_options_demand_model','PDA','DDA');

UPDATE sys_param_user SET layoutorder = 12 WHERE id IN ('inp_options_quality_mode','inp_options_node_id');

INSERT INTO sys_table (id, descript, sys_role, source) VALUES('inp_dscenario_junction', 'Table to manage scenario for junctions', 'role_epa', 'core');
INSERT INTO sys_table (id, descript, sys_role, source) VALUES('inp_dscenario_connec', 'Table to manage scenario for connecs', 'role_epa', 'core');
INSERT INTO sys_table (id, descript, sys_role, source) VALUES('inp_dscenario_inlet', 'Table to manage scenario for inlets', 'role_epa', 'core');

INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','JUNCTION','JUNCTION');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','CONNEC','CONNEC');

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, 
return_type, descript, sys_role, sample_query, source)
VALUES (3110, 'gw_fct_create_dscenario_from_crm', 'ws', 'function', 'json', 
'json', 'Function to create dscenarios from CRM. <br>This function store values on CONNEC features.<br>When the network geometry generator works with [NODE] demands are moved 50% to node_1 and node_2.', 'role_epa', null, null) ON CONFLICT (id) DO NOTHING;

DELETE FROM ws_sample.config_toolbox WHERE id = 3110;
INSERT INTO ws_sample.config_toolbox(id, alias, functionparams, inputparams, observ, active)
VALUES (3110,'Create Demand Dscenario from CRM', '{"featureType":[]}',
'[{"widgetname":"name", "label":"Scenario name:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"value":""},
{"widgetname":"descript", "label":"Scenario descript:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2,"value":""}, 
{"widgetname":"exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":4, "dvQueryText":"SELECT expl_id as id, name as idval FROM v_edit_exploitation", "selectedId":""}, 
{"widgetname":"period", "label":"Source CRM period:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":6, "dvQueryText":"SELECT id, code as idval FROM ext_cat_period", "selectedId":""},
{"widgetname":"pattern", "label":"Feature pattern:","widgettype":"combo","tooltip":"This value will be stored on pattern_id of inp_dscenario_demand table in order to be used on the inp file exportation ONLY with the pattern method FEATURE PATTERN.", "datatype":"text","layoutname":"grl_option_parameters","layoutorder":7,"comboIds":[1,2,3,4,5,6,7], "comboNames":["NONE", "SECTOR-DEFAULT", "SECTOR-PERIOD", "DMA-DEFAULT", "DMA-PERIOD","HYDROMETER-PERIOD","HYDROMETER-CATEGORY"], "selectedId":""}, 
{"widgetname":"demandUnits", "label":"Demand units:","tooltip": "Choose units to insert volume data on demand column. <br> This value need to be the same that flow units used on EPANET. On the other hand, it is assumed that volume from hydrometer data table is expresed on m3/period and column period_seconds is filled.", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":8 ,"comboIds":["LPS","LPM","MLD","CMH","CMD","CFS","GPM","MGD","AFD"], "comboNames":["LPS","LPM","MLD","CMH","CMD","CFS","GPM","MGD","AFD"], "selectedId":""}]'
, NULL, TRUE) 
ON CONFLICT (id) DO NOTHING;

UPDATE config_toolbox SET inputparams =
'[{"widgetname":"name", "label":"Scenario name:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"value":""},
{"widgetname":"descript", "label":"Scenario descript:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2,"value":""}, 
{"widgetname":"type", "label":"Scenario type:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":3, "dvQueryText":"SELECT id, idval FROM inp_typevalue where typevalue = ''inp_typevalue_dscenario''", "selectedId":""}
]', functionparams = '{"featureType":["node", "arc", "connec"]}'
WHERE id = 3108;

DELETE FROM sys_function WHERE id = 3112;
INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, 
return_type, descript, sys_role, sample_query, source)
VALUES (3112, 'gw_fct_create_dscenario_demand', 'ws', 'function', 'json', 
'json', 'Function to create demand dscenarios from [CONNEC, JUNCTION].
It moves demand & pattern data from source to inp_dscenario_demand.', 'role_epa', null, null) 
ON CONFLICT (id) DO NOTHING;

DELETE FROM config_toolbox WHERE id = 3112;
INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active)
VALUES (3112,'Create Demand Dscenario from ToC', '{"featureType":["node","connec"]}',
'[{"widgetname":"name", "label":"Scenario name:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"value":""},
 {"widgetname":"descript", "label":"Scenario descript:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2,"value":""}
  ]'
, NULL, TRUE) 
ON CONFLICT (id) DO NOTHING;

UPDATE config_toolbox SET alias = 'Create Network Dscenario from ToC'
WHERE id = 3108
