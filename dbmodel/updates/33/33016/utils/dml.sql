/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--20/11/2019
INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, context, descript, sys_role_id, isdeprecated, istoolbox, 
alias, isparametric)
VALUES (2776, 'gw_fct_admin_check_data', 'utils', 'api function', '{"featureType":[]}', null, null,'Function which checks the configuration of API and child views.', 'role_admin',
false, true,'Check API configuration',true) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, fprocess_i18n, project_type)
VALUES (95, 'Admin check data', 'Check', 'Admin check data','utils') ON CONFLICT (id) DO NOTHING;


--21/11/2019
UPDATE audit_cat_function SET return_type = '[{"widgetname":"isArcDivide", "label":"Analyse nodes that divide arcs:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":1, "value":"FALSE"},
{"widgetname":"saveOnDatabase", "label":"Save on database:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":9, "value":"FALSE"}]' 
WHERE function_name = 'gw_fct_anl_node_orphan';


-- 22/11/2019
UPDATE config_param_system SET parameter='inp_fast_buildup',
value='{"node":{"nullElevBuffer":100}, "pipe":{"diameter":"160"}, "junction":{"defaultDemand":"0.001"}, "tank":{"distVirtualReservoir":1}, "pressGroup":{"status":"ACTIVE", "forceStatus":"ACTIVE"}, "pumpStation":{"status":"CLOSED", "forceStatus":"CLOSED"}, "PRV":{"status":"ACTIVE", "forceStatus":"ACTIVE"}}'
WHERE parameter='inp_fast_builddup';


INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, context, descript, sys_role_id, 
isdeprecated, istoolbox, alias, isparametric)
VALUES (2778, 'gw_fct_pg2epa_nod2arc_double', 'ws', 'function', null, null, null,'Function to create two nodarcs from one nod2arc (when PUMP has a curve_type choosed PUMP-2N2A)', 'role_epa',
false, false, null, false) ON CONFLICT (id) DO NOTHING;


-- 23/11/2019
INSERT INTO sys_fprocess_cat(id, fprocess_name, context, fprocess_i18n, project_type)
VALUES (96, 'Arcs with state=1 using nodes on state=0', 'Edit', 'Arcs with state=1 using nodes on state=0','utils') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, fprocess_i18n, project_type)
VALUES (97, 'Arcs with state=1 using nodes on state=2', 'Edit', 'Arcs with state=1 using nodes on state=2','utils') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, fprocess_i18n, project_type)
VALUES (98, 'Tanks with null mandatory values', 'EPA', 'Tanks with null mandatory values','ws') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, fprocess_i18n, project_type)
VALUES (99, 'Mincut process', 'om', 'Mincut process', 'ws');


--20/11/2019
UPDATE config_api_form_fields SET dv_isnullvalue = true WHERE formtype='form' AND (column_id='pattern' OR column_id ='pattern_id') 
AND formname != 'inp_pattern' AND formname != 'inp_pattern_value';

UPDATE config_api_form_fields SET dv_isnullvalue = true WHERE formtype='form' AND column_id='curve_id' AND formname != 'inp_curve';