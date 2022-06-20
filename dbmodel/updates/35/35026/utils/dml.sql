/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/06/07
UPDATE sys_fprocess SET fprocess_type='Function process' WHERE fprocess_type='"Function process"';

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (453, 'Node planified duplicated', 'utils', null, 'core', true, 'Check plan-data', null) ON CONFLICT (fid) DO NOTHING;

--2022/06/09
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES(454, 'Check node_1 and node_2 on temp_table', 'utils', NULL, 'core', true, 'Function process', NULL) 
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type,input_params, return_type, descript, sys_role,  source)
VALUES (3152, 'gw_fct_admin_reset_sequences', 'utils', 'function', null, 'json', 'Function for reserting ids and sequences for audit, anl and temp tables', 
'role_admin','core')
ON CONFLICT (id) DO NOTHING;

--2022/06/16
INSERT INTO sys_function(id, function_name, project_type, function_type,input_params, return_type, descript, sys_role,  source)
VALUES (3154, 'gw_fct_settopology', 'utils', 'function', null, 'json', 'Function for reset topology by using node ids', 
'role_edit','core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_param_system (parameter, value, descript, project_type)
VALUES ('admin_message_debug','false','It allows debug on message with more detailed log', 'utils');

--2022/06/17
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES(459, 'Duplicate dscenario', 'utils', NULL, 'core', true, 'Function process', NULL) 
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function (id,function_name,project_type,function_type,input_params,return_type,descript,sys_role,"source")
	VALUES (3156,'gw_fct_duplicate_dscenario','utils','function','json','json','Function to duplicate a dscenario','role_epa','core');

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active) VALUES(3156, 'Duplicate dscenario', '{"featureType":[]}'::json, '[
{"widgetname":"copyFrom", "label":"Copy from:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT dscenario_id as id, name as idval FROM cat_dscenario WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":1, "selectedId":"", "signal": "manage_duplicate_dscenario_copyfrom"},

{"widgetname":"name", "label":"Name: (*)","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name for dscenario (mandatory)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},

{"widgetname":"descript", "label":"Descript:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Descript for dscenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},

{"widgetname":"parent", "label":"Parent:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Parent for dscenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":4, "value":""},

{"widgetname":"type", "label":"Type:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"Dscenario type", "dvQueryText":"SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_typevalue_dscenario''", "layoutname":"grl_option_parameters","layoutorder":5, "value":""},

{"widgetname":"active", "label":"Active:", "widgettype":"check", "datatype":"boolean", "tooltip":"If true, active" , "layoutname":"grl_option_parameters","layoutorder":6, "value":""},

{"widgetname":"expl", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"Dscenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":7, "value":""}
]'::json, NULL, true);

UPDATE config_toolbox SET inputparams='[
{"widgetname":"name", "label":"Name: (*)","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name for dscenario (mandatory)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":1, "value":""},

{"widgetname":"descript", "label":"Descript:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Descript for dscenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},

{"widgetname":"parent", "label":"Parent:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Parent for dscenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},

{"widgetname":"type", "label":"Type:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"Dscenario type", "dvQueryText":"SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_typevalue_dscenario''", "layoutname":"grl_option_parameters","layoutorder":4, "value":""},

{"widgetname":"active", "label":"Active:", "widgettype":"check", "datatype":"boolean", "tooltip":"If true, active" , "layoutname":"grl_option_parameters","layoutorder":5, "value":""},

{"widgetname":"expl", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"Dscenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":6, "value":""}
]'::json
	WHERE id=3134;

UPDATE config_toolbox SET alias='Repair nodes duplicated (one by one)' WHERE alias = 'Repair nodes duplicated';