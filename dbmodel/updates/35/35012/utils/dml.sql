/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



--2021/08/19
INSERT INTO config_function VALUES (2160, 'gw_fct_setfields', NULL, NULL, '[{"funcName": "refresh_canvas", "params": {}}]')
ON CONFLICT (id) DO NOTHING;

--2021/08/20
INSERT INTO sys_fprocess VALUES (395, 'Check to_arc missed values for pumps', 'ws')
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function VALUES (3070, 'gw_fct_pg2epa_vnodetrimarcs', 'ud', 'function', 'text', 'json', 'Function to trim arcs using gullies', 'role_epa')
ON CONFLICT (id) DO NOTHING;

--2021/08/30
UPDATE config_param_system SET project_type='utils' WHERE parameter IN ('edit_state_topocontrol', 'edit_review_node_tolerance', 'qgis_form_element_hidewidgets');

UPDATE sys_param_user SET project_type='utils' WHERE id IN ('inp_options_debug');

DELETE FROM config_param_system WHERE parameter IN ('admin_transaction_db', 'admin_superusers');

INSERT INTO sys_function VALUES (3072, 'gw_fct_sereplacefeatureplan', 'utils', 'function', 'json', 'json', 'Function to replace features on planning mode', 'role_epa')
ON CONFLICT (id) DO NOTHING;

--2021/09/01
INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3074,'gw_trg_edit_inp_dscenario', 'ws', 'trigger function', NULL, NULL, 'Trigger that allows editing data on v_edit_inp_dscenario views',
'role_epa', NULL, NULL) ON CONFLICT (id) DO NOTHING;

UPDATE config_param_system SET value = gw_fct_json_object_delete_keys(value::json, 'layermanager') WHERE parameter = 'basic_selector_tab_psector';
UPDATE config_param_system SET 
value = gw_fct_json_object_set_key(value::json, 'queryfilter', 'AND expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user = current_user) AND active IS TRUE'::text) 
WHERE parameter = 'basic_selector_tab_psector';

UPDATE plan_psector SET active=TRUE WHERE active IS NULL;

DELETE FROM sys_function WHERE function_name = 'gw_trg_vnode_update';

UPDATE config_param_system SET standardvalue = null where parameter = 'admin_raster_dem';