/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/09/21
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (472, 'Check consistency between cat_manager and config_user_x_expl', 'utils',null, 'core', false, 'Function process',null) 
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (473, 'Check consistency between cat_manager and config_user_x_sector', 'utils',null, 'core', false, 'Function process',null) 
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3172, 'gw_fct_anl_node_tcandidate', 'utils', 'function', 'json', 'json', 'Check nodes ''T candidate'' with wrong topology', 'role_edit', null, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function(id, function_name, style, layermanager, actions)
VALUES (3172,'gw_fct_anl_node_tcandidate', '{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', null, null) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active)
VALUES (3172, 'Check nodes T candidates', '{"featureType":["node"]}',null, null, true) ON CONFLICT (id) DO NOTHING;

UPDATE config_param_system SET value =
'{"table":"cat_dscenario","selector":"selector_inp_dscenario","table_id":"dscenario_id","selector_id":"dscenario_id","label":"dscenario_id,'' - '', name, '' ('', dscenario_type,'')''","orderBy":"dscenario_id","manageAll":true,"query_filter":" AND dscenario_id > 0 AND active is true AND (expl_id IS NULL OR expl_id IN (SELECT expl_id FROM selector_expl where cur_user = current_user))","typeaheadFilter":" 
AND lower(concat(dscenario_id, '' - '', name,'' ('',  dscenario_type,'')''))","typeaheadForced":true}'
WHERE parameter = 'basic_selector_tab_dscenario';

UPDATE sys_fprocess SET fprocess_name=replace(fprocess_name,'graf','graph') WHERE fprocess_name ilike '%graf%';
UPDATE sys_fprocess SET fprocess_name=replace(fprocess_name,'Graf','Graph') WHERE fprocess_name ilike '%Graf%';

UPDATE sys_function SET descript=replace(descript,'graf','graph') WHERE descript ilike '%graf%';
UPDATE sys_function SET descript=replace(descript,'Graf','Graph') WHERE descript ilike '%Graf%';
UPDATE sys_table SET id=replace(id, 'graf','graph') WHERE id ilike '%graf%';
UPDATE sys_table SET descript=replace(descript, 'graf','graph') WHERE descript ilike '%graf%';
UPDATE config_form_fields SET columnname=replace(columnname, 'graf','graph') WHERE columnname ilike '%graf%';
UPDATE config_form_fields SET label=replace(label, 'graf','graph') WHERE label ilike '%graf%';
UPDATE config_function SET function_name=replace(function_name, 'graf','graph') WHERE function_name ilike '%graf%';
UPDATE config_form_fields SET columnname=replace(columnname, 'graf','graph') WHERE columnname ilike '%graf%';
UPDATE config_form_fields SET label=replace(label, 'graf','graph') WHERE label ilike '%graf%';
UPDATE config_form_fields SET label=replace(label, 'Graf','Graph') WHERE label ilike '%Graf%';
UPDATE config_form_fields SET dv_querytext=replace(dv_querytext, 'graf','graph') WHERE dv_querytext ilike '%graf%';

UPDATE config_param_system SET parameter='utils_graphanalytics_lrs_graph' WHERE parameter = 'utils_grafanalytics_lrs_graf';

UPDATE config_param_system SET value=replace(value,'ignoreGrafanalytics','ignoreGraphanalytics') WHERE parameter = 'admin_checkproject';
UPDATE config_param_system SET descript=replace(descript,'graf','graph') WHERE descript ilike '%graf%';
UPDATE config_param_system SET label=replace(label,'graf','graph') WHERE label ilike '%graf%';
UPDATE config_param_system SET parameter=replace(label,'graf','graph') WHERE parameter ilike '%graf%';

UPDATE sys_message SET error_message=replace(error_message,'graf','graph') WHERE error_message ilike '%graf%';

UPDATE sys_param_user SET descript=replace(descript,'graf','graph') WHERE descript ilike '%graf%';

UPDATE edit_typevalue SET typevalue=replace(typevalue, 'graf','graph') WHERE typevalue = 'grafdelimiter_type';

UPDATE config_param_system SET parameter='utils_graphanalytics_lrs_feature' WHERE parameter='Grafanalytics LRS config feature:'