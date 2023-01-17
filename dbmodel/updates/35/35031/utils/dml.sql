/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DELETE FROM config_toolbox WHERE id=2766;
DELETE FROM sys_function WHERE id=2766;

UPDATE sys_function SET project_type='utils' WHERE id =2710 OR id=2768;


INSERT INTO config_param_system(parameter, value, descript, isenabled,  project_type, datatype)
VALUES ('admin_isproduction' , False, 'If true, deleting the schema using Giswater button will not be possible', FALSE, 'utils', 'boolean');

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (478, 'Check features without defined sector_id', 'utils', NULL, 'core', true, 'Check om-data', NULL);

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (479, 'Check duplicated arcs', 'utils', NULL, 'core', true, 'Check om-data', NULL);

INSERT INTO config_param_system(parameter, value, descript, project_type,  datatype)
VALUES ('admin_node_code_on_arc', false, 'If true, on codes of final nodes will be visible on arc''s form. If false, node_id would be displayed', 'utils', 'boolean')
ON CONFLICT (parameter) DO NOTHING;

UPDATE sys_param_user SET dv_isnullvalue=NULL WHERE formname='epaoptions';

UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'sys_display_field','descript'::text) WHERE parameter = 'basic_search_street';

-- execute psector refactor
UPDATE sys_message SET hint_message='It''s used as init or final node on planified arcs' WHERE id=3142;

INSERT INTO plan_typevalue VALUES('psector_status', '4', 'EXECUTED (On Service)', 'Psector executed. Its elements are set to On Service', NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO plan_typevalue VALUES('psector_status', '5', 'EXECUTED (Do nothing)', 'Psector executed but do nothing', NULL) ON CONFLICT (typevalue, id) DO NOTHING;

UPDATE plan_typevalue SET idval='EXECUTED (Obsolete)', descript='Psector executed. Its elements are set to Obsolete' WHERE typevalue='psector_status' AND id='0';

UPDATE plan_psector SET status = 4 where status=0 and (SELECT value::json ->> 'mode' FROM config_param_system WHERE parameter='plan_psector_execute_action')='onService';
UPDATE plan_psector SET status = 5 where status=0 and (SELECT value::json ->> 'mode' FROM config_param_system WHERE parameter='plan_psector_execute_action')='disabled';

UPDATE config_param_system SET value = gw_fct_json_object_delete_keys(value::json, 'mode') WHERE parameter = 'plan_psector_execute_action';

INSERT INTO config_param_system  (parameter, value, descript, "label", isenabled, layoutorder, project_type, "datatype", widgettype, layoutname)
SELECT 'plan_statetype_vdefault',json_object_agg (parameter,value), 'Default state_type when using planified features', 'Plan state_type vdefault:', true, 10, 'utils', 'json', 'text', 'lyt_admin_other'
FROM config_param_system where parameter in ('plan_statetype_ficticius', 'plan_statetype_planned', 'plan_statetype_reconstruct');

UPDATE config_param_system  b SET value=b.value::jsonb ||a.value ::jsonb
FROM config_param_system a where a.parameter ='plan_psector_execute_action' and b.parameter='plan_psector_statetype';

DELETE FROM config_param_system where parameter in ('plan_statetype_ficticius', 'plan_statetype_planned', 'plan_statetype_reconstruct','plan_psector_execute_action');

UPDATE config_param_system SET "parameter"='plan_psector_status_action', "label"='Psector execute state_type:' where "parameter"='plan_psector_statetype';

UPDATE config_param_system SET value=replace(value,'plan_obsolete_state_type', 'obsolete_planified') WHERE "parameter"='plan_psector_status_action';

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (480, 'Check duplicated connec/gullies on visible psectors', 'utils', NULL, 'core', true, 'Check epa-data', NULL);

INSERT INTO config_param_system ("parameter", value, descript, isenabled, project_type, "datatype")
VALUES('admin_skip_audit', 'false', 'System parameter to identify processes that need to avoid audit log because of the big amount of data updated. Example: mapzones or daily update crm', false, 'utils', 'string') ON CONFLICT (parameter) DO NOTHING;

UPDATE config_param_system SET value = value::jsonb || '{"customLength":{"maxPercent":10}}'::jsonb
where parameter ='epa_outlayer_values';

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (482, 'Check arcs with value of custom length', 'utils', NULL, 'core', true, 'Check epa-data', NULL);

UPDATE sys_function SET function_name = 'gw_fct_linkexitgenerator' WHERE id = 2994;

DELETE FROM sys_table WHERE id = 'vnode';

UPDATE plan_psector_x_arc pa SET active = p.active FROM plan_psector p WHERE p.psector_id=pa.psector_id;
UPDATE plan_psector_x_node pn SET active = p.active FROM plan_psector p WHERE p.psector_id=pn.psector_id;
UPDATE plan_psector_x_connec pc SET active = p.active FROM plan_psector p WHERE p.psector_id=pc.psector_id;

INSERT INTO sys_function(id, function_name, project_type, function_type, descript, sys_role,  source)
VALUES (3182, 'gw_trg_plan_psector', 'utils', 'trigger function', 
'Trigger to update active value on plan_psector_x_* tables using plan_psector active value', 'role_master', 'core');

UPDATE link SET exit_id = arc_id FROM connec c WHERE connec_id = feature_id AND exit_type  ='ARC';
UPDATE link SET exit_type = 'ARC' WHERE exit_type  ='VNODE';


DELETE FROM sys_function where function_name = 'gw_trg_node_update';

INSERT INTO sys_function VALUES (3184, 'gw_fct_connect_link_refactor', 'utils', 'function', NULL, NULL, 'Function to harmonize plan_psector_x_connec/gully values after link refactor in 3.5.031', 'role_admin', NULL, 'core');

UPDATE config_form_fields SET iseditable = false where columnname ='arc_id' and formname like 've_connec_%' or formname  ='v_edit_connec';
UPDATE config_form_fields SET iseditable = false where formname like 'v_edit_lin%';
UPDATE config_form_fields SET iseditable = true where formname like 'v_edit_lin%' AND columnname  ='state';

INSERT INTO sys_table( id, descript, sys_role, source)
VALUES ('temp_vnode', 'Temporal table to process virtual nodes (for internal use)', 'role_basic', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table( id, descript, sys_role, source)
VALUES ('temp_link', 'Temporal table to process virtual links (for internal use)', 'role_basic', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table( id, descript, sys_role, source)
VALUES ('temp_link_x_arc', 'Temporal table to process virtual links related to arcs (for internal use)', 'role_basic', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table( id, descript, sys_role, source)
VALUES ('vu_link', 'View of links without filters', 'role_basic', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table( id, descript, sys_role, source)
VALUES ('v_filter_link', 'View to filter links', 'role_basic', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table( id, descript, sys_role, source)
VALUES ('v_filter_link_connec', 'View to filter connec links ', 'role_basic', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table( id, descript, sys_role, source)
VALUES ('v_link', 'Filtered view of links', 'role_basic', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table( id, descript, sys_role, source)
VALUES ('v_link_connec', 'Filtered view of links type connec', 'role_basic', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table( id, descript, sys_role, context, orderby, alias,source)
VALUES ('v_edit_link_connec', 'Editable view of links type connec', 'role_basic', '{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"LINK"}', 2,
'Link connec', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table( id, descript, sys_role, source)
VALUES ('v_edit_plan_psector_x_connec', 'Editable view to work with psector and connec', 'role_master', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, descript, sys_role,  source)
VALUES (3174, 'gw_trg_edit_plan_psector_x_connect', 'utils', 'trigger function', 
'Trigger that manages v_edit_plan_psector_x_connec (and gully views)', 'role_master', 'core');


DELETE FROM sys_table WHERE id = 'vnode';
DELETE FROM sys_table WHERE id = 'v_arc_x_vnode';
DELETE FROM sys_table WHERE id = 'v_vnode';

Update sys_fprocess SET fprocess_name = 'Repair temp_link' WHERE fid = 296;
Update sys_fprocess SET fprocess_name = 'Repair link' WHERE fid = 301;
DELETE FROM sys_fprocess  WHERE fid IN (298,300);

DELETE FROM sys_function WHERE function_name='gw_trg_vnode_proximity';
DELETE FROM sys_function WHERE function_name='gw_trg_update_link_arc_id';
DELETE FROM sys_function WHERE function_name='gw_trg_ui_mincut_result_cat';
DELETE FROM sys_function WHERE function_name='gw_trg_selector_expl';
DELETE FROM sys_function WHERE function_name='gw_trg_man_addfields_control';
DELETE FROM sys_function WHERE function_name='gw_trg_edit_subcatchment';
DELETE FROM sys_function WHERE function_name='gw_trg_edit_plan_psector';
DELETE FROM sys_function WHERE function_name='gw_trg_connec_update';
DELETE FROM sys_function WHERE function_name='gw_fct_utils_csv2pg_import_epanet_rpt';
DELETE FROM sys_function WHERE function_name='gw_fct_setmincutstart';
DELETE FROM sys_function WHERE function_name='gw_fct_setmincutend';
DELETE FROM sys_function WHERE function_name='gw_fct_pg2epa_vnodetrimarcs' and id=3070;
DELETE FROM sys_function WHERE function_name='gw_fct_pg2epa_nod2arc_geom';
DELETE FROM sys_function WHERE function_name='gw_fct_pg2epa_nod2arc_data';
DELETE FROM sys_function WHERE function_name='gw_fct_pg2epa_import_rpt';
DELETE FROM sys_function WHERE function_name='gw_fct_pg2epa_flowreg_additional';
DELETE FROM sys_function WHERE function_name='gw_fct_node_replace';
DELETE FROM sys_function WHERE function_name='gw_fct_mincut_output';
DELETE FROM sys_function WHERE function_name='gw_fct_getrowinsert';
DELETE FROM sys_function WHERE function_name='gw_fct_get_widgetjson';
DELETE FROM sys_function WHERE function_name='gw_fct_get_style';
DELETE FROM sys_function WHERE function_name='gw_fct_audit_function';
DELETE FROM sys_function WHERE function_name='gw_fct_admin_schema_dropdeprecated_rel';

UPDATE sys_function SET project_type='ws', function_type='trigger function', input_params=null, return_type=null, descript=null WHERE function_name='gw_trg_ui_mincut';
UPDATE sys_function SET project_type='utils' WHERE function_name='gw_trg_ui_hydroval_connec';
UPDATE sys_function SET project_type='ws' WHERE function_name='gw_trg_node_rotation_update';
UPDATE sys_function SET project_type='utils' WHERE function_name='gw_trg_edit_macrosector';
UPDATE sys_function SET project_type='utils' WHERE function_name='gw_trg_edit_macrodma';
UPDATE sys_function SET project_type='utils', function_type='trigger function' WHERE function_name='gw_trg_edit_inp_curve';
UPDATE sys_function SET project_type='ws' WHERE function_name='gw_trg_edit_field_node';
UPDATE sys_function SET project_type='ws' WHERE function_name='gw_fct_setmincut';
UPDATE sys_function SET project_type='ws' WHERE function_name='gw_fct_setmapzoneconfig';
UPDATE sys_function SET project_type='utils' WHERE function_name='gw_fct_rpt2pg_import_rpt';
UPDATE sys_function SET project_type='utils' WHERE function_name='gw_fct_pg2epa_dscenario';
UPDATE sys_function SET project_type='ws' WHERE function_name='gw_fct_mincut_inverted_flowtrace';
UPDATE sys_function SET project_type='utils' WHERE function_name='gw_fct_import_istram';
UPDATE sys_function SET project_type='utils' WHERE function_name='gw_fct_fill_om_tables';
UPDATE sys_function SET project_type='utils' WHERE function_name='gw_fct_fill_doc_tables';
UPDATE sys_function SET project_type='utils' WHERE function_name='gw_fct_create_dscenario_from_toc';

UPDATE sys_function SET function_type='trigger function' WHERE function_name='gw_trg_typevalue_fk';
UPDATE sys_function SET function_type='function' WHERE function_name='gw_fct_getselectors';
UPDATE sys_function SET function_type='function' WHERE function_name='gw_fct_getprofile';

UPDATE sys_function SET function_name='gw_trg_edit_inp_dscenario_demand' WHERE function_name='gw_trg_edit_inp_demand';
UPDATE sys_function SET function_name='gw_fct_setfeaturereplaceplan' WHERE function_name='gw_fct_setreplacefeatureplan';


delete from config_form_tableview where tablename='plan_psector_x_connec';

INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_connec', 'id', 0, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_connec', 'connec_id', 1, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_connec', 'arc_id', 2, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_connec', 'psector_id', 3, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_connec', 'state', 4, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_connec', 'doable', 5, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_connec', 'descript', 6, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_connec', '_link_geom_', 7, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_connec', '_userdefined_geom_', 8, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_connec', 'link_id', 9, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_connec', 'active', 10, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_connec', 'insert_tstamp', 11, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_connec', 'insert_user', 12, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'v_edit_plan_psector_x_connec', 'rank', 13, false, NULL, NULL, NULL);


delete from config_form_tableview where tablename='plan_psector_x_arc';

INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'plan_psector_x_arc', 'id', 0, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'plan_psector_x_arc', 'arc_id', 1, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'plan_psector_x_arc', 'psector_id', 2, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'plan_psector_x_arc', 'state', 3, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'plan_psector_x_arc', 'doable', 4, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'plan_psector_x_arc', 'descript', 5, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'plan_psector_x_arc', 'addparam', 6, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'plan_psector_x_arc', 'active', 7, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'plan_psector_x_arc', 'insert_tstamp', 8, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'plan_psector_x_arc', 'insert_user', 9, false, NULL, NULL, NULL);


delete from config_form_tableview where tablename='plan_psector_x_node';

INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'plan_psector_x_node', 'id', 0, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'plan_psector_x_node', 'node_id', 1, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'plan_psector_x_node', 'psector_id', 2, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'plan_psector_x_node', 'state', 3, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'plan_psector_x_node', 'doable', 4, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'plan_psector_x_node', 'descript', 5, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'plan_psector_x_node', 'addparam', 6, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'plan_psector_x_node', 'active', 7, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'plan_psector_x_node', 'insert_tstamp', 8, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES('plan toolbar', 'utils', 'plan_psector_x_node', 'insert_user', 9, false, NULL, NULL, NULL);

INSERT INTO sys_function(id, function_name, project_type, function_type, descript, sys_role,  source)
VALUES (3188, 'gw_fct_linktonetwork', 'utils', 'function', 
'Function to work with gw_fct_setlinktonetwork internally', 'role_edit', 'core');

UPDATE config_function SET id = 3188, function_name = 'gw_fct_linktonetwork' WHERE id =2124;


INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, source)
VALUES (3202, 'It''s not possible to break planned arcs by using operative nodes', 'Try it using planned nodes', 2, true, 'utils', 'core');

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, source)
VALUES (3204, 'This connec has an associated link', 'Remove the associated link and arc_id field will be set to null', 2, true, 'utils', 'core');

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, source)
VALUES (3208, 'This connec has an associated link', 'Remove the associated link and arc_id field will be set to null',
 2, true, 'utils', 'core');

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, source)
VALUES (3210, 'It''s impossible to downgrade the state of a planned connec', 'To unlink,  remove from psector dialog or delete it', 2, true, 'utils', 'core');

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, source)
VALUES (3212, 'It''s impossible to update arc_id from psector dialog because this planned link has not arc as exit-type', 'Use connec dialog to update it', 2, true, 'utils', 'core');

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, source)
VALUES (3218, 'It''s impossible to attach operative link to planned feature', 'Set link''s state to planned to continue', 2, true, 'utils', 'core');

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, source)
VALUES (3220, 'It''s impossible to change link''s state to operative, because it''s related to a planned feature', NULL, 2, true, 'utils', 'core');

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, source)
VALUES (3222, 'It''s impossible to upgrade link',
'In order to work with planned link, create new one by drawing it on link layer, using link2network button or feature/psector dialogs (setting arc_id)',
2, true, 'utils', 'core');

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, source)
VALUES (3224, 'It''s impossible to create a planned link for operative feature (connec/gully)',
'If you are working on psector, use link2network button or feature/psector dialogs(setting arc_id) and then modify it',
2, true, 'utils', 'core');

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, source)
VALUES (3226, 'It''s impossible to downgrade link', 'If you want to remove it from psector, delete it',2, true, 'utils', 'core');

UPDATE sys_message SET hint_message = 'In order to relate link with psector use psector dialog or link2network button. you can''t draw in on link layer'
WHERE id=3076;

UPDATE sys_message SET hint_message = 'You can''t have two links related to the same feature (connec/gully) in one psector'
WHERE id=3082;

INSERT INTO inp_typevalue(typevalue, id, idval) VALUES ('inp_pjoint_type','ARC','ARC');
INSERT INTO inp_typevalue(typevalue, id, idval) VALUES ('inp_pjoint_type','CONNEC','CONNEC');
DELETE FROM inp_typevalue WHERE typevalue = 'inp_pjoint_type' AND id = 'VNODE';

UPDATE config_form_fields SET dv_querytext = 'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_pjoint_type''' 
WHERE columnname ='exit_type' and formname='v_edit_link';

UPDATE config_form_fields SET iseditable=false WHERE formname LIKE 've_connec%' AND columnname='arc_id';
UPDATE config_form_fields SET iseditable=false WHERE formname LIKE 've_node%' AND columnname='arc_id';

SELECT gw_fct_connect_link_refactor();

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (485, 'Connect link to arc id with specific coordinates', 'utils', NULL, 'core', true, NULL, NULL)
 ON CONFLICT (fid) DO NOTHING;

ALTER TABLE sys_feature_cat DROP CONSTRAINT IF EXISTS sys_feature_cat_check;

INSERT INTO sys_feature_cat (id, "type", epa_default) VALUES('LINK', 'LINK', 'UNDEFINED');
INSERT INTO cat_feature (id, system_id, feature_type, parent_layer, child_layer, descript, active)
VALUES('LINK', 'LINK', 'LINK', 'v_edit_link', 'v_edit_link', 'Link', true);

UPDATE sys_function SET function_name = 'gw_trg_arc_link_update' WHERE id = 2542; 

INSERT INTO sys_table(id, descript, sys_role, source)
VALUES ('v_expl_node', 'View that filter nodes for exploitation', 'role_basic', 'core');

UPDATE sys_table SET descript='View that filter nodes for state' WHERE id='v_state_node';

INSERT INTO sys_table(id, descript, sys_role, source)
VALUES ('node_border_expl', 'Table that stores relation between node and it''s additional exploitation.', 'role_basic', 'core');

INSERT INTO sys_function(id, function_name, project_type, function_type, descript, sys_role,  source)
VALUES (3190, 'gw_trg_node_border', 'utils', 'function trigger', 
'Trigger that configures nodes that are located on the border between mapzones', 'role_edit', 'core');

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 'v_edit_link_connec', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields WHERE formname = 'v_edit_link' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_typevalue(typevalue, id, idval, camelstyle, addparam)
VALUES ('tabname_typevalue','tab_macroexploitation_add', 'Macroexploitation add', 'Macroexploitation add', null) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO config_param_system(parameter, value, descript, label, isenabled, project_type,  datatype)
VALUES ('basic_selector_tab_macroexploitation_add','{"table":"macroexploitation","selector":"selector_expl","table_id":"macroexpl_id","selector_id":"expl_id","label":"m.macroexpl_id, '' - '', m.name","orderBy":"macroexpl_id","manageAll":true,"query_filter":" AND m.macroexpl_id > 0","typeaheadForced":true,"sectorFromMacroexpl":true,"explFromMacroexpl":false}',
'Variable to configura all options related to search for the specificic tab', 'Selector variables', FALSE, 'utils', 'json') ON CONFLICT (parameter) DO NOTHING;

INSERT INTO config_form_tabs(formname, tabname, label, sys_role,  device, orderby)
VALUES ('selector_basic','tab_macroexploitation_add','Macroexpl Add','role_basic',4, 0) ON CONFLICT (formname, tabname, device) DO NOTHING;

UPDATE config_form_tableview SET columnindex = columnindex + 1 WHERE location_type = 'epa_toolbar';

update config_form_fields set hidden = true WHERE columnname ='presszone_style' and formname='form_feature';