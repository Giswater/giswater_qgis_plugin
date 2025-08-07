/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_function SET descript='Check topology assistant. Analyze and validate the length of arcs for potential inconsistencies or errors.' WHERE id=3052;

UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 3}'::jsonb WHERE id='ve_genelem';
UPDATE sys_table SET addparam = NULL WHERE id ilike '%elem%';

-- 03/07/2025
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3482, 'gw_fct_graphanalytics_macromapzones', 'utils', 'function', 'json', 'json', 'Function to analyze network as a macro graph.', 'role_om', NULL, 'core', NULL);

DELETE FROM config_form_fields WHERE columnname='undelete';

UPDATE config_toolbox SET inputparams='[{"label":"Direct insert into node table:","value":null,"datatype":"boolean","layoutname":"grl_option_parameters","selectedId":null,"widgetname":"insertIntoNode","widgettype":"check","layoutorder":1},{"label":"Node tolerance:","value":null,"datatype":"float","layoutname":"grl_option_parameters","selectedId":null,"widgetname":"nodeTolerance","widgettype":"spinbox","layoutorder":2},{"label":"Exploitation ids:","value":null,"datatype":"text","layoutname":"grl_option_parameters","selectedId":null,"widgetname":"exploitation","widgettype":"combo","dvQueryText":"select expl_id as id, name as idval from exploitation where active is not false order by name","layoutorder":3},{"label":"State:","value":null,"datatype":"integer","isparent":"true","layoutname":"grl_option_parameters","selectedId":null,"widgetname":"stateType","widgettype":"combo","dvQueryText":"select value_state_type.id as id, concat(''state: '',value_state.name,'' state type: '', value_state_type.name) as idval from value_state_type join value_state on value_state.id = state where value_state_type.id is not null order by  CASE WHEN state=1 THEN 1 WHEN state=2 THEN 2 WHEN state=0 THEN 3 END, id","layoutorder":4},{"label":"Workcat:","value":null,"datatype":"text","layoutname":"grl_option_parameters","selectedId":null,"widgetname":"workcatId","widgettype":"combo","dvQueryText":"select id as id, id as idval from cat_work where id is not null","isNullValue":true,"layoutorder":5},{"label":"Builtdate:","value":null,"datatype":"date","layoutname":"grl_option_parameters","selectedId":null,"widgetname":"builtdate","widgettype":"datetime","layoutorder":6},{"label":"Node type:","isparent":true,"value":null,"datatype":"text","iseditable":true,"layoutname":"grl_option_parameters","selectedId":"$userNodetype","widgetname":"nodeType","widgettype":"combo","dvQueryText":"select distinct cfn.id as id, cfn.id as idval from cat_feature_node cfn JOIN cat_node cn ON cn.node_type=cfn.id where cfn.id is not null","layoutorder":7},{"label":"Node catalog:","dvparentid":"node_type","dvquerytext_filterc":" AND value_state_type.state","value":null,"datatype":"text","layoutname":"grl_option_parameters","selectedId":"$userNodecat","widgetname":"nodeCat","widgettype":"combo","dvQueryText":"select distinct id as id, id as idval from cat_node order by id","parentname":"nodeType","filterquery":"select distinct id as id, id as idval from cat_node where node_type = ''{parent_value}'' order by id","layoutorder":8}]'::json WHERE id=2118;

-- 08/07/2025
INSERT INTO sys_message (id,error_message,hint_message,log_level,show_user,project_type,"source",message_type)
VALUES (4140,'The specified feature type is not supported: %feature_type%','Must be ''FEATURE'' or ''ELEMENT''',2,true,'utils','core','UI');

UPDATE config_param_system
	SET value = jsonb_set(value::jsonb, '{sys_query_text_add}', '"SELECT distinct(concat(s.name, '''', '''', m.name, '''', '''', a.postnumber)) as \"displayName\" FROM v_ext_streetaxis s join ext_municipality m using(muni_id) join v_ext_address a on s.id = a.streetaxis_id WHERE concat(s.name, '''', '''', m.name, '''', '''', a.postnumber) ILIKE "')
	WHERE parameter='basic_search_v2_tab_address';

-- 10/07/2025
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3484, 'gw_fct_getfeatures', 'utils', 'function', 'json', 'json', 'Function for getting features filtering by sys_type and mapzone, with optional ordering by parameter.', NULL, NULL, 'core', NULL);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3486, 'gw_fct_getdmas', 'utils', 'function', 'json', 'json', 'Function to get a list of DMAs.', 'role_basic', NULL, 'core', NULL);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3488, 'gw_fct_getdmahydrometers', 'utils', 'function', 'json', 'json', 'Function to get DMA hydrometers.', 'role_om', NULL, 'core', NULL);

UPDATE sys_table SET alias = 'Node' WHERE id='v_edit_node' AND alias='Node (parent)';
UPDATE sys_table SET alias = 'Arc' WHERE id='v_edit_arc' AND alias='Arc (parent)';
UPDATE sys_table SET alias = 'Connec' WHERE id='v_edit_connec' AND alias='Connec (parent)';
UPDATE sys_table SET alias = 'Link' WHERE id='v_edit_link' AND alias='Link (parent)';
UPDATE sys_table SET alias = 'Gully' WHERE id='v_edit_gully' AND alias='Gully (parent)';
UPDATE sys_table SET alias = 'Flow Regulator Elements' WHERE id='ve_frelem';
UPDATE sys_table SET alias = 'General Elements', context='{"levels": ["INVENTORY", "NETWORK", "ELEMENT"]}', orderby=1 WHERE id='ve_genelem';
UPDATE sys_table SET alias = 'Municipality' WHERE id='v_ext_municipality';

UPDATE config_form_fields SET dv_querytext='SELECT element_id as id, element_id as idval FROM v_ui_element WHERE element_id IS NOT NULL', widgetfunction='{"functionName": "filter_table", "parameters":{"columnfind":"element_id"}}'::json WHERE formname='element_manager' AND formtype='form_element' AND columnname='element_id' AND tabname='tab_none';
UPDATE config_form_fields SET widgetfunction='{"functionName":"open_selected_manager_item", "parameters":{"columnfind":"element_id"}}'::json WHERE formname='element_manager' AND formtype='form_element' AND columnname='tbl_element' AND tabname='tab_none';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4320, 'The element is already linked to a node: %node_id%', 'Unlink the element from the node first', 1, true, 'utils', 'core', 'UI');

UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_feature_element WHERE id IS NOT NULL' WHERE formname='cat_element' AND formtype='form_feature' AND columnname='elementtype_id' AND tabname='tab_none';

UPDATE sys_table SET alias='Element feature catalog' WHERE id='v_edit_cat_feature_element';

-- 23/07/2025
INSERT INTO sys_fprocess (fid, fprocess_name) VALUES (-1, 'There is');
INSERT INTO sys_fprocess (fid, fprocess_name) VALUES (-2, 'There are');

-- 29/07/2025
DELETE FROM sys_table WHERE id = 'v_edit_raingage';

UPDATE sys_table SET id = REPLACE(id, 'v_edit_', 've_') WHERE id ILIKE '%v_edit_%';

UPDATE sys_style SET layername = REPLACE(layername, 'v_edit_', 've_') WHERE layername ILIKE '%v_edit_%';

UPDATE cat_feature SET parent_layer = REPLACE(parent_layer, 'v_edit_', 've_') WHERE parent_layer ILIKE '%v_edit_%';

UPDATE config_table SET id= REPLACE(id, 'v_edit_', 've_') WHERE id ILIKE '%v_edit_%';

UPDATE config_info_layer SET layer_id = REPLACE(layer_id, 'v_edit_', 've_') WHERE layer_id ILIKE '%v_edit_%';

UPDATE config_form_tabs SET formname = REPLACE(formname, 'v_edit_', 've_') WHERE formname ILIKE '%v_edit_%';

ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;
UPDATE config_form_fields SET dv_querytext = REPLACE(dv_querytext, 'v_edit_', 've_') WHERE dv_querytext ILIKE '%v_edit_%';
ALTER TABLE config_form_fields ENABLE TRIGGER gw_trg_config_control;

UPDATE config_param_system SET value = REPLACE(value, 'v_edit_', 've_') WHERE value ILIKE '%v_edit_%';

UPDATE sys_param_user SET dv_querytext = REPLACE(dv_querytext, 'v_edit_', 've_') WHERE dv_querytext ILIKE '%v_edit_%';

UPDATE config_function SET layermanager = REPLACE(layermanager::text, 'v_edit_', 've_')::json WHERE layermanager::text ILIKE '%v_edit_%';

UPDATE config_form_list SET query_text = REPLACE(query_text, 'v_edit_', 've_') WHERE query_text ILIKE '%v_edit_%';
UPDATE config_form_list SET listname = REPLACE(listname, 'v_edit_', 've_') WHERE listname ILIKE '%v_edit_%';

UPDATE config_report SET query_text = REPLACE(query_text, 'v_edit_', 've_') WHERE query_text ILIKE '%v_edit_%';

--23/07/2025
DELETE FROM config_form_fields WHERE formname='ve_genelem_estep' AND formtype='form_feature' AND columnname='epa_type' AND tabname='tab_data';
DELETE FROM config_form_fields WHERE formname='ve_genelem_ecover' AND formtype='form_feature' AND columnname='epa_type' AND tabname='tab_data';
DELETE FROM config_form_fields WHERE formname='ve_genelem_egate' AND formtype='form_feature' AND columnname='epa_type' AND tabname='tab_data';
DELETE FROM config_form_fields WHERE formname='ve_genelem_eiot_sensor' AND formtype='form_feature' AND columnname='epa_type' AND tabname='tab_data';
DELETE FROM config_form_fields WHERE formname='ve_genelem_eprotector' AND formtype='form_feature' AND columnname='epa_type' AND tabname='tab_data';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4322, '%v_count_feature% link(s) have been downgraded', NULL, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4324, '%v_count_feature% element(s) have been downgraded', NULL, 0, true, 'utils', 'core', 'AUDIT');

UPDATE config_toolbox SET inputparams='[
  {
    "label": "Direct insert into node table:",
    "value": null,
    "datatype": "boolean",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "insertIntoNode",
    "widgettype": "check",
    "layoutorder": 1
  },
  {
    "label": "Node tolerance:",
    "value": null,
    "datatype": "float",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "nodeTolerance",
    "widgettype": "spinbox",
    "layoutorder": 2
  },
  {
    "label": "Exploitation ids:",
    "value": null,
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "exploitation",
    "widgettype": "combo",
    "dvQueryText": "select expl_id as id, name as idval from exploitation where active is not False order by name",
    "layoutorder": 3
  },
  {
    "label": "State:",
    "value": null,
    "datatype": "integer",
    "isparent": "True",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "stateType",
    "widgettype": "combo",
    "dvQueryText": "select value_state_type.id as id, concat(''state: '',value_state.name,'' state type: '', value_state_type.name) as idval from value_state_type join value_state on value_state.id = state where value_state_type.id is not null order by  CASE WHEN state=1 THEN 1 WHEN state=2 THEN 2 WHEN state=0 THEN 3 END, id",
    "layoutorder": 4
  },
  {
    "label": "Workcat:",
    "value": null,
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "workcatId",
    "widgettype": "combo",
    "dvQueryText": "select id as id, id as idval from cat_work where id is not null",
    "isNullValue": true,
    "layoutorder": 5
  },
  {
    "label": "Builtdate:",
    "value": null,
    "datatype": "date",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "builtdate",
    "widgettype": "datetime",
    "layoutorder": 6
  },
  {
    "label": "Node type:",
    "isparent": true,
    "value": null,
    "datatype": "text",
    "iseditable": true,
    "layoutname": "grl_option_parameters",
    "selectedId": "$userNodetype",
    "widgetname": "nodeType",
    "widgettype": "combo",
    "dvQueryText": "select distinct cfn.id as id, cfn.id as idval from cat_feature_node cfn JOIN cat_node cn ON cn.node_type=cfn.id where cfn.id is not null",
    "layoutorder": 7
  },
  {
    "label": "Node catalog:",
    "dvparentid": "node_type",
    "dvquerytext_filterc": " AND value_state_type.state",
    "value": null,
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": "$userNodecat",
    "widgetname": "nodeCat",
    "widgettype": "combo",
    "dvQueryText": "select distinct id as id, id as idval from cat_node order by id",
    "parentname": "nodeType",
    "filterquery": "select distinct id as id, id as idval from cat_node where node_type = ''{parent_value}'' order by id",
    "layoutorder": 8
  }
]'::json WHERE id=2118;

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname)
VALUES('mapzones_config', '{"version" : "1"}', 'Mapzones system config. version - Mapzones version;', 'Mapzones system config', NULL, NULL, true, 17, 'utils', false, false, 'json', 'linetext', true, true, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_admin_other')
ON CONFLICT (parameter) DO NOTHING;

UPDATE config_toolbox SET functionparams = REPLACE(functionparams::text, 'v_edit_', 've_')::json WHERE functionparams::text ILIKE '%v_edit_%';
UPDATE config_toolbox SET inputparams = REPLACE(inputparams::text, 'v_edit_', 've_')::json WHERE inputparams::text ILIKE '%v_edit_%';

UPDATE sys_function SET function_name = 'gw_fct_checktopologypsector' where function_name = 'gw_fct_setplan';

-- 01/08/2025
UPDATE config_form_fields SET widgetcontrols = jsonb_set(COALESCE(widgetcontrols::jsonb, '{}'::jsonb), '{labelSize}', '58')
WHERE formtype = 'psector' and columnname IN ('name', 'ext_code', 'status','workcat_id') and tabname='tab_general';
DELETE FROM config_form_fields WHERE formname='generic' AND formtype='psector' AND columnname='spacer_1' AND tabname='tab_general';

-- 04/08/2025
UPDATE config_form_fields SET label='Show obsolete:' WHERE formname='generic' AND formtype='psector' AND columnname='chk_enable_all' AND tabname='tab_general';
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'active', 'lyt_general_7', 2, 'boolean', 'check', 'Active:', 'Active:', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": true
}'::json, NULL, NULL, false, 2);
UPDATE config_form_fields SET layoutorder=3, web_layoutorder=3 WHERE formname='generic' AND formtype='psector' AND columnname='creation_date' AND tabname='tab_general';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4328, 'It is not allowed to downgrade planified links (state=2)', 'Review your data.', 2, true, 'utils', 'core', 'AUDIT');

-- 05/08/2025
UPDATE plan_psector SET workcat_id_plan = workcat_id WHERE workcat_id IS NOT NULL AND status IN (1, 2, 3);

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4330, 'Input parameter: "%parameter%" is required', 'You need to pass correct parameters.', 2, true, 'utils', 'core', 'UI');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4332, 'Unknown %parameter%', 'You need to pass correct parameters.', 2, true, 'utils', 'core', 'UI');

UPDATE sys_function SET function_name = 'gw_fct_set_toggle_current' WHERE function_name = 'gw_fct_set_current';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4334, 'You can not desactivate the %mapzone_name%, because have objects linked to it', 'First you need to change the objects to another mapzone. EX: Undefined', 2, true, 'utils', 'core', 'UI');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3496, 'gw_fct_check_linked_mapzones', 'utils', 'function', 'json', 'json', 'Check if there are objects linked to the mapzone', NULL, NULL, 'core', NULL);

UPDATE config_form_fields SET layoutname='lyt_general_1', layoutorder=1, web_layoutorder=1, widgetcontrols='{"setMultiline":false, "labelPosition":"top"}'::json WHERE formname='generic' AND formtype='psector' AND columnname='psector_id' AND tabname='tab_general';
UPDATE config_form_fields SET layoutname='lyt_general_1', layoutorder=2, web_layoutorder=2, widgetcontrols='{"setMultiline":false, "labelPosition":"top"}'::json WHERE formname='generic' AND formtype='psector' AND columnname='ext_code' AND tabname='tab_general';
UPDATE config_form_fields SET layoutname='lyt_general_7', layoutorder=4, web_layoutorder=2, widgetcontrols='{"setMultiline":false}'::json WHERE formname='generic' AND formtype='psector' AND columnname='parent_id' AND tabname='tab_general';
UPDATE config_form_fields SET layoutname='lyt_general_4', layoutorder=0, web_layoutorder=0, widgetcontrols='{"setMultiline": false, "labelPosition":"top"}'::json WHERE formname='generic' AND formtype='psector' AND columnname='status' AND tabname='tab_general';
UPDATE config_form_fields SET layoutname='lyt_general_4', layoutorder=1, web_layoutorder=1, widgetcontrols='{"setMultiline":false, "labelPosition":"top"}'::json WHERE formname='generic' AND formtype='psector' AND columnname='priority' AND tabname='tab_general';
UPDATE config_form_fields SET layoutname='lyt_general_3', layoutorder=0, dv_isnullvalue=true, web_layoutorder=0, widgetcontrols='{"setMultiline": false, "labelPosition":"top"}'::json WHERE formname='generic' AND formtype='psector' AND columnname='workcat_id' AND tabname='tab_general';
UPDATE config_form_fields SET layoutname='lyt_general_3', layoutorder=2, web_layoutorder=2, widgetcontrols='{"setMultiline":false, "labelPosition":"top"}'::json WHERE formname='generic' AND formtype='psector' AND columnname='expl_id' AND tabname='tab_general';
UPDATE config_form_fields SET layoutname='lyt_general_4', layoutorder=2, web_layoutorder=2, widgetcontrols='{"setMultiline":false, "labelPosition":"top"}'::json WHERE formname='generic' AND formtype='psector' AND columnname='psector_type' AND tabname='tab_general';
UPDATE config_form_fields SET widgetcontrols='{"setMultiline": false, "labelPosition":"top"}'::json WHERE formname='generic' AND formtype='psector' AND columnname='name' AND tabname='tab_general';
UPDATE config_form_fields SET widgetcontrols='{"setMultiline": true}'::json WHERE formname='generic' AND formtype='psector' AND columnname='chk_enable_all' AND tabname='tab_general';
UPDATE config_form_fields SET widgetcontrols='{"setMultiline": true}'::json WHERE formname='generic' AND formtype='psector' AND columnname='active' AND tabname='tab_general';
UPDATE config_form_fields SET widgetcontrols='{"setMultiline":false}'::json WHERE formname='generic' AND formtype='psector' AND columnname='creation_date' AND tabname='tab_general';
UPDATE config_form_fields SET widgetcontrols='{"setMultiline":false, "labelPosition":"top"}'::json, label='Observation:' WHERE formname='generic' AND formtype='psector' AND columnname='observ' AND tabname='tab_general';
UPDATE config_form_fields SET widgetcontrols='{"setMultiline":false, "labelPosition":"top"}'::json WHERE formname='generic' AND formtype='psector' AND columnname IN ('descript', 'text1', 'text2', 'scale', 'rotation', 'atlas_id') AND tabname='tab_general';

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'workcat_id_plan', 'lyt_general_3', 1, 'string', 'combo', 'Worcat id plan:', 'Worcat id plan', NULL, false, false, false, false, false, 'SELECT id, id as idval  FROM cat_work', NULL, false, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition":"top"}'::json, NULL, NULL, false, 1);

UPDATE sys_param_user SET formname = 'dynamic'  WHERE id = 'edit_state_vdefault';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4336, 'It''s not possible to set this psector to active because it has topological inconsistencies.', 'Fix topological errors first.', 2, true, 'utils', 'core', 'UI');

-- 06/08/2025
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3498, 'gw_fct_cm_setarcdivide', 'utils', 'function', 'json', 'json', 'Divides an existing arc at a specified node location. Finds the nearest arc within tolerance, splits it into two new arcs at the node position, and deletes the original arc while maintaining all attributes and topological connections.', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3500, 'gw_trg_cm_topocontrol_arc', 'utils', 'trigger', 'trigger', 'trigger', 'Trigger function that automatically connects campaign arc endpoints to the nearest nodes. Validates topology rules, snaps geometry to node coordinates, and sets proper node_1/node_2 connections while prioritizing division nodes.', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3502, 'gw_fct_admin_manage_role_cm', 'utils', 'function', 'json', 'json', 'Synchronizes users with CM roles to the cat_user table. Automatically finds users that have role_cm permissions but are not yet in the cat_user catalog, and inserts them with proper team assignments.', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3504, 'gw_fct_cm_check_catalogs', 'utils', 'function', 'json', 'json', 'Validates catalog combinations for campaign and lot features. Checks if arc and node feature combinations exist in cat_arc and cat_node tables, identifies missing catalog entries, and reports which combinations will need new catalog creation when added to production.', NULL, NULL, 'core', NULL);


-- 07/08/2025
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "delete_manager_item",
  "parameters": {
    "sourcetable": "v_ui_element",
    "targetwidget": "tab_none_tbl_element",
    "field_object_id": "element_id"
  }
}'::json
	WHERE formname='element_manager' AND formtype='form_element' AND columnname='delete' AND tabname='tab_none';


DELETE FROM sys_table WHERE id ilike 'v_state_%';