/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/10/05
UPDATE sys_param_user SET vdefault = gw_fct_json_object_set_key(vdefault::json, 'graphicLog'::text, 'true'::text) WHERE id = 'inp_options_debug';
UPDATE config_param_user SET value = gw_fct_json_object_set_key(value::json, 'graphicLog'::text, 'true'::text) WHERE parameter = 'inp_options_debug';


UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'query_filter'::text, 'AND active is true AND expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user = current_user)'::text) 
WHERE parameter = 'basic_selector_tab_psector';

UPDATE config_param_system SET value = gw_fct_json_object_delete_keys(value::json, 'queryfilter') WHERE parameter = 'basic_selector_tab_psector';

INSERT INTO sys_function VALUES (3042, 'gw_fct_copy_dscenario_values', 'utils', 'function', 'json', 'json', 'Function to copy values from one dscenario to another one', 'role_epa') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess VALUES (397, 'EPA dscenarios management)', 'utils')
ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active)
VALUES (3042,'Copy Dscenario values', '{"featureType":[]}', 
'[{"widgetname":"source", "label":"Source:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT dscenario_id as id, name as idval FROM cat_dscenario WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":1, "selectedId":""},
{"widgetname":"target", "label":"Target:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT dscenario_id as id, name as idval FROM cat_dscenario WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":2, "selectedId":"$userDscenario"}]', NULL, TRUE) 
ON CONFLICT (id) DO NOTHING;


UPDATE config_toolbox SET 
	inputparams = '[{"widgetname":"resultId", "label":"Result Id:","widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT result_id as id, result_id as idval FROM rpt_cat_result WHERE status > 0","layoutname":"grl_option_parameters","layoutorder":1,"selectedId":"$userInpResult"}]'
	WHERE id = 2680;
	
INSERT INTO inp_typevalue VALUES ('inp_result_status', '0', 'DEPRECATED');

UPDATE polygon SET feature_id = element_id, featurecat_id=elementtype_id 
FROM element JOIN cat_element ce ON ce.id=elementcat_id 
WHERE polygon.pol_id=element.pol_id;

INSERT INTO sys_function VALUES (3032, 'gw_fct_man2inp_values', 'utils', 'function', 'json')
ON CONFLICT (id) DO UPDATE SET function_name = 'gw_fct_man2inp_values', project_type ='utils', function_type='function', input_params='json', return_type=null;


UPDATE config_param_system SET value= '{"setArcObsolete":"false","setOldCode":"false"}' WHERE parameter = 'edit_arc_divide';

INSERT INTO SCHEMA_NAME.sys_fprocess VALUES (402, 'Check if node_id and arc_id defined on CONTROLS/RULES exists)', 'utils')
ON CONFLICT (fid) DO NOTHING;
