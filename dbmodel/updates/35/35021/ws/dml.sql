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
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','12','SECTOR PATTERN') ON CONFLICT (typevalue, id) DO NOTHING;
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
project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, vdefault, iseditable)
VALUES ('inp_options_demand_model', 'DEMAND MODEL', 'epaoptions', 'Demand model:', 'role_epa', 'Demand model' , 'SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_options_demand_model''',true, 'lyt_general_1',10,
'ws', FALSE, FALSE, 'text', 'combo', true, 'PDA', TRUE) 
ON CONFLICT (id) DO NOTHING;

DELETE FROM sys_param_user WHERE id = 'inp_options_minimum_pressure';
INSERT INTO sys_param_user(id, idval, formname, descript, sys_role, label,  isenabled, layoutname, layoutorder,
project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, vdefault, iseditable)
VALUES ('inp_options_minimum_pressure', 'MINIMUM PRESSURE', 'epaoptions', 'Mininum pressure:', 'role_epa', 'Mininum pressure' , true, 'lyt_general_2',10,
'ws', FALSE, FALSE, 'text', 'linetext', true, '0', TRUE) 
ON CONFLICT (id) DO NOTHING;

DELETE FROM sys_param_user WHERE id = 'inp_options_required_pressure';
INSERT INTO sys_param_user(id, idval, formname, descript, sys_role, label, isenabled, layoutname, layoutorder,
project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, vdefault, iseditable)
VALUES ('inp_options_required_pressure', 'REQUIRED PRESSURE', 'epaoptions', 'Required pressure:', 'role_epa', 'Required pressure' , true, 'lyt_general_1',11,
'ws', FALSE, FALSE, 'text', 'linetext', true, '10', TRUE) 
ON CONFLICT (id) DO NOTHING;

DELETE FROM sys_param_user WHERE id = 'inp_options_pressure_exponent';
INSERT INTO sys_param_user(id, idval, formname, descript, sys_role, label, isenabled, layoutname, layoutorder,
project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, vdefault, iseditable)
VALUES ('inp_options_pressure_exponent', 'PRESSURE EXPONENT', 'epaoptions', 'Presure exponent:', 'role_epa', 'Presure exponent' , true, 'lyt_general_2',11,
'ws', FALSE, FALSE, 'text', 'linetext', true, '0.5', TRUE) 
ON CONFLICT (id) DO NOTHING;

DELETE FROM sys_param_user WHERE id = 'inp_options_max_headerror';
INSERT INTO sys_param_user(id, idval, formname, descript, sys_role, label, isenabled, layoutname, layoutorder,
project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, vdefault, iseditable)
VALUES ('inp_options_max_headerror', 'HEADERROR', 'epaoptions', 'Max. head error:', 'role_epa', 'Max head error' , true, 'lyt_hydraulics_1',11,
'ws', FALSE, FALSE, 'text', 'linetext', true, '0', TRUE) 
ON CONFLICT (id) DO NOTHING;

DELETE FROM sys_param_user WHERE id = 'inp_options_max_flowchange';
INSERT INTO sys_param_user(id, idval, formname, descript, sys_role, label, isenabled, layoutname, layoutorder,
project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, vdefault, iseditable)
VALUES ('inp_options_max_flowchange', 'FLOWCHANGE', 'epaoptions', 'Max. flow change:', 'role_epa', 'Max flow change' , true, 'lyt_hydraulics_2',11,
'ws', FALSE, FALSE, 'text', 'linetext', true, '0', TRUE) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO inp_typevalue VALUES ('inp_options_demand_model','DDA','DDA') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO inp_typevalue VALUES ('inp_options_demand_model','PDA','DDA') ON CONFLICT (typevalue, id) DO NOTHING;;

UPDATE sys_param_user SET layoutorder = 12 WHERE id IN ('inp_options_quality_mode','inp_options_node_id');

INSERT INTO sys_table (id, descript, sys_role, source) VALUES('inp_dscenario_junction', 'Table to manage dscenario for junctions', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table (id, descript, sys_role, source) VALUES('inp_dscenario_connec', 'Table to manage dscenario for connecs', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table (id, descript, sys_role, source) VALUES('inp_dscenario_inlet', 'Table to manage dscenario for inlets', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table (id, descript, sys_role, source) VALUES('inp_dscenario_virtualvalve', 'Table to manage dscenario for virtualvalves', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table (id, descript, sys_role, source) VALUES('inp_dscenario_pump_additional', 'Table to manage dscenario for additional pumps', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, source) VALUES('v_edit_inp_dscenario_junction', 'View to manage dscenario for junctions', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table (id, descript, sys_role, source) VALUES('v_edit_inp_dscenario_connec', 'View to manage dscenario for connecs', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table (id, descript, sys_role, source) VALUES('v_edit_inp_dscenario_inlet', 'View to manage dscenario for inlets', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table (id, descript, sys_role, source) VALUES('v_edit_inp_dscenario_virtualvalve', 'View to manage dscenario for virtualvalves', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table (id, descript, sys_role, source) VALUES('v_edit_inp_dscenario_pump_additional', 'View to manage dscenario for additional pumps', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','JUNCTION','JUNCTION') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','CONNEC','CONNEC') ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','UNDEFINED','UNDEFINED') ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, 
return_type, descript, sys_role, sample_query, source)
VALUES (3110, 'gw_fct_create_dscenario_from_crm', 'ws', 'function', 'json', 
'json', 'Function to create dscenarios from CRM. <br>This function store values on CONNEC features.<br>When the network geometry generator works with [NODE] demands are moved 50% to node_1 and node_2.', 'role_epa', null, null) ON CONFLICT (id) DO NOTHING;

DELETE FROM config_toolbox WHERE id = 3110;
INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active)
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
{"widgetname":"type", "label":"Scenario type:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":3, "dvQueryText":"SELECT id, idval FROM inp_typevalue where typevalue = ''inp_typevalue_dscenario''", "selectedId":""},
{"widgetname":"exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":4, "dvQueryText":"SELECT expl_id as id, name as idval FROM v_edit_exploitation", "selectedId":""}
]', functionparams = '{"featureType":["node", "arc", "connec"]}'
WHERE id = 3108;

DELETE FROM sys_function WHERE id = 3112;
INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, 
return_type, descript, sys_role, sample_query, source)
VALUES (3112, 'gw_fct_create_dscenario_demand', 'ws', 'function', 'json', 
'json', 'Function to create demand dscenarios from [CONNEC, JUNCTION].
It moves demand & pattern data from source to inp_dscenario_demand. Works with epa layers (connec or junction) which means need to be loaded.', 'role_epa', null, null) 
ON CONFLICT (id) DO NOTHING;

DELETE FROM config_toolbox WHERE id = 3112;
INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active)
VALUES (3112,'Create Demand Dscenario from ToC', '{"featureType": {"node":["v_edit_inp_junction"],"connec":["v_edit_inp_connec"]}}',
'[{"widgetname":"name", "label":"Scenario name:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"value":""},
 {"widgetname":"descript", "label":"Scenario descript:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2,"value":""},
 {"widgetname":"exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":4, "dvQueryText":"SELECT expl_id as id, name as idval FROM v_edit_exploitation", "selectedId":""}
  ]', NULL, TRUE) 
ON CONFLICT (id) DO NOTHING;

UPDATE config_toolbox SET alias = 'Create Network Dscenario from ToC'
WHERE id = 3108;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_sector','form_feature', 'main', 'pattern_id', null, null, 'string', 'combo', 'pattern_id', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL', TRUE, TRUE, NULL, NULL,NULL,
'{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "v_edit_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": null}}', 
NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO sys_param_user(id, formname, descript, sys_role, label, isenabled, layoutorder, project_type, isparent, 
isautoupdate, datatype, widgettype, ismandatory, layoutname, iseditable, vdefault)
VALUES ('edit_node_interpolate', 'hidden', 'Values to use with tool node interpolate',
'role_edit', 'Values to manage node interpolate tool', FALSE, NULL, 'ws', FALSE, FALSE, 'json', 'text', true, NULL, NULL,
'{"elevation":{"status":true, "column":"elevation"}, "depth":{"status":true, "column":"depth"}}') ON CONFLICT (id) DO NOTHING;

UPDATE config_form_tabs SET tabactions ='[{"actionName":"actionEdit",  "disabled":false},
{"actionName":"actionZoom",  "disabled":false},
{"actionName":"actionCentered",  "disabled":false},
{"actionName":"actionZoomOut" , "disabled":false},
{"actionName":"actionCatalog",  "disabled":false},
{"actionName":"actionWorkcat",  "disabled":false},
{"actionName":"actionCopyPaste",  "disabled":false},
{"actionName":"actionLink",  "disabled":false},
{"actionName":"actionMapZone",  "disabled":false},
{"actionName":"actionSetToArc",  "disabled":false},
{"actionName":"actionGetParentId",  "disabled":false},
{"actionName":"actionGetArcId", "disabled":false},
{"actionName": "actionRotation","disabled": false},
{"actionName":"actionInterpolate", "disabled":false}]' WHERE formname='v_edit_node';

INSERT INTO config_form_fields (formname, formtype,tabname, columnname, layoutname,layoutorder,datatype, 
widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, 
dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols,
widgetfunction, linkedobject, hidden)
VALUES('v_edit_inp_tank', 'form_feature', 'main','overflow','lyt_data_1', 71, 'string',
'text','overflow', null,  'Yes or No', false,false, true,false, false, 
null,  false,  false,  null,null, null,'{"setMultiline":false}', 
null,null,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_param_system VALUES ('admin_hydrometer_state', '{"0":[0], "1":[1,2,3,4]}', 
'Variable to map state values from crm to giswater state values in order to identify what state are deprecated to check on function state_control for connecs')
 ON CONFLICT (parameter) DO NOTHING;

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, source)
VALUES ('3194', 'It is not possible to downgrade connec because has operative hydrometer associated', 'Unlink hydrometers first', 2, TRUE, 'utils', NULL)
ON CONFLICT (id) DO NOTHING;

--2022/01/10
INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_value_status_pump', 'inp_dscenario_pump', 'status', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_value_status_pump', 'inp_dscenario_pump_additional', 'status', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_value_param_energy', 'inp_dscenario_pump_additional', 'energyparam', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;

ALTER TABLE inp_dscenario_pump DROP CONSTRAINT IF EXISTS inp_dscenario_pump_pattern_id_fkey;
ALTER TABLE inp_dscenario_pump ADD CONSTRAINT inp_dscenario_pump_pattern_id_fkey FOREIGN KEY (pattern)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_value_status_pipe', 'inp_dscenario_shortpipe', 'status', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;

ALTER TABLE inp_dscenario_tank DROP CONSTRAINT IF EXISTS inp_dscenario_tank_curve_id_fkey;
ALTER TABLE inp_dscenario_tank ADD CONSTRAINT inp_dscenario_tank_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_tank DROP CONSTRAINT IF EXISTS inp_tank_curve_id_fkey;
ALTER TABLE inp_tank ADD CONSTRAINT inp_tank_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_dscenario_inlet DROP CONSTRAINT IF EXISTS inp_dscenario_inlet_curve_id_fkey;
ALTER TABLE inp_dscenario_inlet ADD CONSTRAINT inp_dscenario_inlet_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_typevalue_valve', 'inp_virtualvalve', 'valv_type', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_value_status_valve', 'inp_virtualvalve', 'status', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_typevalue_valve', 'inp_dscenario_virtualvalve', 'valv_type', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_value_status_valve', 'inp_dscenario_virtualvalve', 'status', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;


ALTER TABLE inp_dscenario_demand DROP CONSTRAINT IF EXISTS inp_dscenario_demand_feature_type_fkey;
ALTER TABLE inp_dscenario_demand ADD CONSTRAINT inp_dscenario_demand_feature_type_fkey FOREIGN KEY (feature_type)
REFERENCES sys_feature_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

UPDATE sys_foreignkey SET target_field='demand_type' WHERE target_field='deman_type' AND target_table='inp_dscenario_demand';

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_value_status_pipe', 'inp_connec', 'status', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, active)
VALUES ('inp_typevalue', 'inp_value_status_pipe', 'inp_dscenario_connec', 'status', true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_connec', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_dscenario_pipe' AND columnname IN ('status', 'minorloss')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_connec', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_dscenario_pipe' AND columnname IN ('dscenario_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE config_form_fields SET columnname = 'pjoint_type' WHERE formname='v_edit_inp_connec' AND columnname = 'pjoinyt_type';
UPDATE config_form_fields SET columnname = 'pjoint_id' WHERE formname='v_edit_inp_connec' AND columnname = 'pjoinyt_id';

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_connec', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_connec' AND columnname IN ('connec_id','pjoint_type','pjoint_id','demand','pattern_id', 'peak_factor',
'status', 'minorloss', 'custom_roughness', 'custom_length', 'custom_dint')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_demand', 'form_feature', 'main', 'source', null, null, 
'string', 'text', 'source', null, null, false, false, true, false, null, null, null, 
null, null, null, null, '{"setMultiline":false}', null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_inlet', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_dscenario_pipe' AND columnname IN ('dscenario_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_inlet', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_dscenario_reservoir' AND columnname IN ('pattern_id','head')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_inlet', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_tank' AND columnname IN ('overflow')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_inlet', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_inlet' AND columnname IN ('node_id','initlevel','minlevel','maxlevel','diameter', 'minvol',
'curve_id', 'pattern_id', 'overflow', 'head','overflow')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_junction', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_dscenario_pipe' AND columnname IN ('dscenario_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_junction', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_junction' AND columnname IN ('node_id','demand', 'pattern_id', 'peak_factor')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_pump_additional', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_dscenario_pump' AND columnname IN ('dscenario_id','node_id','power', 'curve_id', 'speed',
'pattern','status')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_pump_additional', 'form_feature', 'main', 'order_id', null, null, 
'integer', 'text', 'order_id', null, null, false, false, true, false, null, null, null, 
null, null, null, null, '{"setMultiline":false}', null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_pump_additional', 'form_feature', 'main', 'overflow', null, null, 
'string', 'text', 'overflow', null, null, false, false, true, false, null, null, null, 
null, null, null, null, '{"setMultiline":false}', null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_valve', 'form_feature', 'main', 'add_settings', null, null, 
'double', 'text', 'add_settings', null, null, false, false, true, false, null, null, null, 
null, null, null, null, '{"setMultiline":false}', null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_dscenario_valve', 'form_feature', 'main', 'add_settings', null, null, 
'double', 'text', 'add_settings', null, null, false, false, true, false, null, null, null, 
null, null, null, null, '{"setMultiline":false}', null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_virtualvalve', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_inlet' AND columnname IN ('diameter')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_virtualvalve', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_dscenario_pipe' AND columnname IN ('dscenario_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_virtualvalve', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_virtualvalve' AND columnname IN ('dscenario_id','arc_id','valv_type', 'pressure', 'diameter',
'flow','coef_loss', 'curve_id','minorloss','status','diameter' )
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE config_form_fields SET dv_isnullvalue= true WHERE widgettype='combo' AND formname ILIKE 'v_edit_inp_dscenario_inp%';

UPDATE sys_param_user SET datatype='integer', vdefault = '40' where id IN ('inp_options_trials', 'inp_options_unbalanced_n');
UPDATE config_param_user SET value = cast(value::numeric as integer) where parameter IN ('inp_options_trials', 'inp_options_unbalanced_n');

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_reservoir', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_dscenario_reservoir' AND columnname IN ('head')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_dscenario_tank', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_tank' AND columnname IN ('overflow')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_curve', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_cat_dscenario' AND columnname IN ('log')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_pattern', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_cat_dscenario' AND columnname IN ('log')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_shortpipe', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_inp_pipe' AND columnname IN ('dma_id')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

DELETE FROM config_form_fields WHERE formname='v_edit_inp_junction' AND columnname='expl_id';
DELETE FROM config_form_fields WHERE formname='v_edit_inp_dscenario_demand' AND columnname='id';