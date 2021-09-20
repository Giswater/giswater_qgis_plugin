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
INSERT INTO sys_fprocess VALUES (395, 'Check to_arc missed VALUES for pumps', 'ws')
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

--2021/09/06
INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3076, 'gw_fct_admin_manage_views','utils', 'function', 'json', 'json',
'Function that allows saving, modifying and recuperating a list of views', 'role_admin', null, null);

--2021/09/07

INSERT INTO config_form_tableview VALUES ('connec_form', 'utils', 'v_ui_om_visitman_x_connec', 'visit_id', 0, true);
INSERT INTO config_form_tableview VALUES ('connec_form', 'utils', 'v_ui_om_visitman_x_connec', 'code', 1, true);
INSERT INTO config_form_tableview VALUES ('connec_form', 'utils', 'v_ui_om_visitman_x_connec', 'visitcat_name', 2, true);
INSERT INTO config_form_tableview VALUES ('connec_form', 'utils', 'v_ui_om_visitman_x_connec', 'connec_id', 3, true);
INSERT INTO config_form_tableview VALUES ('connec_form', 'utils', 'v_ui_om_visitman_x_connec', 'visit_start', 4, true);
INSERT INTO config_form_tableview VALUES ('connec_form', 'utils', 'v_ui_om_visitman_x_connec', 'visit_end', 5, true);
INSERT INTO config_form_tableview VALUES ('connec_form', 'utils', 'v_ui_om_visitman_x_connec', 'user_name', 6, true);
INSERT INTO config_form_tableview VALUES ('connec_form', 'utils', 'v_ui_om_visitman_x_connec', 'is_done', 7, true);
INSERT INTO config_form_tableview VALUES ('connec_form', 'utils', 'v_ui_om_visitman_x_connec', 'feature_type', 8, true);
INSERT INTO config_form_tableview VALUES ('connec_form', 'utils', 'v_ui_om_visitman_x_connec', 'form_type', 9, true);

INSERT INTO config_form_tableview VALUES ('node_form', 'utils', 'v_ui_om_visitman_x_node', 'visit_id', 0, true);
INSERT INTO config_form_tableview VALUES ('node_form', 'utils', 'v_ui_om_visitman_x_node', 'code', 1, true);
INSERT INTO config_form_tableview VALUES ('node_form', 'utils', 'v_ui_om_visitman_x_node', 'visitcat_name', 2, true);
INSERT INTO config_form_tableview VALUES ('node_form', 'utils', 'v_ui_om_visitman_x_node', 'node_id', 3, true);
INSERT INTO config_form_tableview VALUES ('node_form', 'utils', 'v_ui_om_visitman_x_node', 'visit_start', 4, true);
INSERT INTO config_form_tableview VALUES ('node_form', 'utils', 'v_ui_om_visitman_x_node', 'visit_end', 5, true);
INSERT INTO config_form_tableview VALUES ('node_form', 'utils', 'v_ui_om_visitman_x_node', 'user_name', 6, true);
INSERT INTO config_form_tableview VALUES ('node_form', 'utils', 'v_ui_om_visitman_x_node', 'is_done', 7, true);
INSERT INTO config_form_tableview VALUES ('node_form', 'utils', 'v_ui_om_visitman_x_node', 'feature_type', 8, true);
INSERT INTO config_form_tableview VALUES ('node_form', 'utils', 'v_ui_om_visitman_x_node', 'form_type', 9, true);

INSERT INTO config_form_tableview VALUES ('arc_form', 'utils', 'v_ui_om_visitman_x_arc', 'visit_id', 0, true);
INSERT INTO config_form_tableview VALUES ('arc_form', 'utils', 'v_ui_om_visitman_x_arc', 'code', 1, true);
INSERT INTO config_form_tableview VALUES ('arc_form', 'utils', 'v_ui_om_visitman_x_arc', 'visitcat_name', 2, true);
INSERT INTO config_form_tableview VALUES ('arc_form', 'utils', 'v_ui_om_visitman_x_arc', 'arc_id', 3, true);
INSERT INTO config_form_tableview VALUES ('arc_form', 'utils', 'v_ui_om_visitman_x_arc', 'visit_start', 4, true);
INSERT INTO config_form_tableview VALUES ('arc_form', 'utils', 'v_ui_om_visitman_x_arc', 'visit_end', 5, true);
INSERT INTO config_form_tableview VALUES ('arc_form', 'utils', 'v_ui_om_visitman_x_arc', 'user_name', 6, true);
INSERT INTO config_form_tableview VALUES ('arc_form', 'utils', 'v_ui_om_visitman_x_arc', 'is_done', 7, true);
INSERT INTO config_form_tableview VALUES ('arc_form', 'utils', 'v_ui_om_visitman_x_arc', 'feature_type', 8, true);
INSERT INTO config_form_tableview VALUES ('arc_form', 'utils', 'v_ui_om_visitman_x_arc', 'form_type', 9, true);

--2021/09/08
DELETE FROM config_param_user WHERE "parameter" ='edit_link_update_connecrotation';

INSERT INTO config_param_system (parameter, value, descript, label, isenabled, layoutorder, project_type, "datatype", widgettype, iseditable, layoutname) 
SELECT id, 'true', descript, label, true, 10, 'utils', 'boolean', 'check', true, 'lyt_system' FROM sys_param_user spu WHERE id ='edit_link_update_connecrotation';

DELETE FROM sys_param_user WHERE id='edit_link_update_connecrotation';

UPDATE config_param_system SET descript='If true, connec''s label and symbol will be rotated using the angle of link. You need to have label symbol configurated with "CASE WHEN label_x = 5 THEN ''    '' ||  "connec_id"  
ELSE  "connec_id"  || ''    ''  END", label_x as quadrant and label_rotation as rotation' WHERE "parameter" = 'edit_link_update_connecrotation';

--2021/09/13
UPDATE config_toolbox SET inputparams = '[{"widgetname":"insertIntoNode", "label":"Direct insert into node table:", "widgettype":"check", "datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":1,"value":"true"},
{"widgetname":"nodeTolerance", "label":"Node tolerance:", "widgettype":"spinbox","datatype":"float","layoutname":"grl_option_parameters","layoutorder":2,"value":0.01},
{"widgetname":"exploitation", "label":"Exploitation ids:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":3, 
"dvQueryText":"select expl_id as id, name as idval from exploitation where active is not false order by name", "selectedId":"$userExploitation"},
{"widgetname":"stateType", "label":"State:", "widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":4, 
"dvQueryText":"select value_state_type.id as id, concat(''state: '',value_state.name,'' state type: '', value_state_type.name) as idval from value_state_type join value_state on value_state.id = state where value_state_type.id is not null order by  CASE WHEN state=1 THEN 1 WHEN state=2 THEN 2 WHEN state=0 THEN 3 END, id", "selectedId":"1","isparent":"true"},
{"widgetname":"workcatId", "label":"Workcat:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":5, "isNullValue":false,"dvQueryText":"select id as id, id as idval from cat_work where id is not null union select null as id, null as idval order by id", "selectedId":"1"},
{"widgetname":"builtdate", "label":"Builtdate:", "widgettype":"datetime","datatype":"date","layoutname":"grl_option_parameters","layoutorder":6, "value":null},
{"widgetname":"nodeType", "label":"Node type:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":7, "dvQueryText":"select distinct id as id, id as idval from cat_feature_node where id is not null", "selectedId":"$userNodetype", "iseditable":false},
{"widgetname":"nodeCat", "label":"Node catalog:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":8, "dvQueryText":"select distinct id as id, id as idval from cat_node where nodetype_id = $userNodetype  OR nodetype_id is null order by id", "selectedId":"$userNodecat"}]'
WHERE id=2118;

ALTER TABLE plan_psector ALTER COLUMN active SET DEFAULT TRUE;

UPDATE config_form_fields SET tabname='data' WHERE formname like 've_%';
UPDATE config_form_fields SET tabname='data' WHERE formname = 'v_edit_node';
UPDATE config_form_fields SET tabname='data' WHERE formname = 'v_edit_arc';
UPDATE config_form_fields SET tabname='data' WHERE formname = 'v_edit_connec';
UPDATE config_form_fields SET tabname='data' WHERE formname = 'v_edit_gully';

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('config_user_x_sector', 'Table to manage sector_id when variable user_x_exploitation is enabled', 'role_admin', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

--2021/09/17
INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('cat_workspace', 'Table to save workspace configuration - values of currently set selectors and inp settings', 'role_basic', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('v_ui_workspace', 'Shows saved workspaces', 'role_basic', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3078, 'gw_fct_workspacemanager','utils', 'function', 'json', 'json',
'Function that allows saving workspaces - currently set values of selectors and inp configuration', 'role_basic', null, 'giswater');

--2021/09/19
INSERT INTO sys_fprocess VALUES (396, 'Check duplicity of features when more than one scenario is enabled', 'utils')
ON CONFLICT (fid) DO NOTHING;
