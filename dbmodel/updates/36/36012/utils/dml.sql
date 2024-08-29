/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('v_ui_doc', 'SELECT * FROM v_ui_doc WHERE id IS NOT NULL', 4, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, NULL);

INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('edit toolbar','utils','v_ui_doc','id',6,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
    VALUES ('edit toolbar','utils','v_ui_doc','name',0,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('edit toolbar','utils','v_ui_doc','observ',1,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('edit toolbar','utils','v_ui_doc','doc_type',2,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('edit toolbar','utils','v_ui_doc','path',3,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('edit toolbar','utils','v_ui_doc','date',4,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('edit toolbar','utils','v_ui_doc','user_name',5,true);


UPDATE config_form_tabs
    SET orderby=0
    WHERE formname IN ('v_edit_arc', 'v_edit_connec', 'v_edit_node', 'v_edit_gully') AND tabname='tab_data';

UPDATE config_form_tabs
    SET orderby=1
    WHERE tabname='tab_epa';


UPDATE config_form_tabs
	SET "label"='Elements' WHERE tabname='tab_elements';
UPDATE config_form_tabs
	SET "label"='Events' WHERE tabname='tab_event';
UPDATE config_form_tabs
	SET "label"='Documents' WHERE tabname='tab_documents';
UPDATE config_form_tabs
	SET "label"='Plan' WHERE tabname='tab_plan';
UPDATE config_form_tabs
	SET "label"='Hydrometer' WHERE tabname='tab_hydrometer';
UPDATE config_form_tabs
	SET "label"='Hydrometer consumptions' WHERE tabname='tab_hydrometer_val';

UPDATE doc SET name = id WHERE name IS NULL;


-- 26/07/2024
UPDATE config_form_tableview
	SET columnindex=0
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='result_id';
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('epa_toolbar','utils','v_ui_rpt_cat_result','expl_id',1,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('epa_toolbar','utils','v_ui_rpt_cat_result','sector_id',2,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('epa_toolbar','utils','v_ui_rpt_cat_result','network_type',3,true);
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('epa_toolbar','utils','v_ui_rpt_cat_result','descript',4,true);
UPDATE config_form_tableview
	SET columnindex=5
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='status';
UPDATE config_form_tableview
	SET columnindex=6
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='iscorporate';
UPDATE config_form_tableview
	SET columnindex=7
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='cur_user';
UPDATE config_form_tableview
	SET columnindex=8
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='exec_date';
UPDATE config_form_tableview
	SET columnindex=9
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='export_options';
UPDATE config_form_tableview
	SET columnindex=10
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='network_stats';
UPDATE config_form_tableview
	SET columnindex=11
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='inp_options';
UPDATE config_form_tableview
	SET columnindex=12
	WHERE objectname='v_ui_rpt_cat_result' AND columnname='rpt_stats';
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible)
	VALUES ('epa_toolbar','utils','v_ui_rpt_cat_result','addparam',13,false);


INSERT INTO sys_table (id, descript, sys_role, "source" )
VALUES('v_ext_municipality', 'View of town cities and villages based filtered by active exploitations', 'role_edit', 'core');


UPDATE config_param_system SET value='{"sys_table_id":"v_ext_municipality", "sys_id_field":"muni_id", "sys_search_field":"name", "sys_geom_field":"the_geom"}'
WHERE "parameter"='basic_search_muni';


UPDATE config_form_fields SET web_layoutorder = NULL
WHERE tabname = 'tab_elements' AND columnname = 'element_id';

UPDATE config_form_fields SET web_layoutorder = 1
WHERE tabname = 'tab_elements' AND columnname = 'tbl_elements';

UPDATE config_form_fields SET web_layoutorder = NULL
WHERE tabname = 'tab_documents' AND columnname = 'doc_id';

UPDATE config_form_fields SET web_layoutorder = 4
WHERE tabname = 'tab_documents' AND columnname = 'tbl_documents';

-- 07/08/2024
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('sys_table_context', '{"level_1":"OM","level_2":"ANALYTICS"}', NULL, NULL, '{"orderBy":26}'::json);
UPDATE sys_table SET context='{"level_1":"OM","level_2":"ANALYTICS"}', orderby=1, alias='Auxiliar Hydrants' WHERE id='v_edit_anl_hydrant';

-- 08/08/2024
UPDATE config_form_fields
	SET label = NULL
	WHERE formname = 'infoplan' AND widgettype = 'divider';

-- 09/08/2024
DELETE FROM sys_function where id  = 2806;
DROP FUNCTION IF EXISTS gw_fct_admin_test_ci();

-- 12/08/2024
UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'sys_geom', ''::text)
	WHERE parameter IN (
		'basic_search_v2_tab_address',
		'basic_search_v2_tab_hydrometer',
		'basic_search_v2_tab_network_arc',
		'basic_search_v2_tab_network_connec',
		'basic_search_v2_tab_network_gully',
		'basic_search_v2_tab_network_node',
		'basic_search_v2_tab_workcat'
	);

-- 08/08/2024
ALTER TABLE sys_role DROP CONSTRAINT sys_role_check;
ALTER TABLE sys_role
ADD CONSTRAINT sys_role_check CHECK (id::text = ANY (ARRAY['role_admin'::character varying, 'role_basic'::character varying,
'role_edit'::character varying, 'role_epa'::character varying, 'role_master'::character varying, 'role_om'::character varying,
'role_crm'::character varying, 'role_system'::character varying]::text[]));

INSERT INTO sys_role VALUES ('role_system', 'system');

UPDATE sys_table SET sys_role = 'role_system' WHERE id = 'sys_feature_cat';
UPDATE sys_table SET sys_role = 'role_system' WHERE id = 'sys_feature_epa_type';
UPDATE sys_table SET sys_role = 'role_system' WHERE id = 'sys_feature_type';
UPDATE sys_table SET sys_role = 'role_system' WHERE id = 'sys_role';
UPDATE sys_table SET sys_role = 'role_system' WHERE id = 'sys_typevalue';
UPDATE sys_table SET sys_role = 'role_system' WHERE id = 'sys_version';

DELETE FROM sys_function WHERE function_name = 'gw_fct_admin_manage_roles';

UPDATE sys_table SET sys_role='role_edit' WHERE id='plan_psector';
UPDATE sys_table SET sys_role='role_edit' WHERE id='plan_psector_x_arc';
UPDATE sys_table SET sys_role='role_edit' WHERE id='plan_psector_x_node';
UPDATE sys_table SET sys_role='role_edit' WHERE id='plan_psector_x_other';
UPDATE sys_table SET sys_role='role_edit' WHERE id='plan_psector_x_connec';


INSERT INTO config_param_system (parameter, value, descript, isenabled, project_type)
VALUES ('edit_link_autoupdate_connect_length', 'FALSE', 'Enable the automatic update for connect (connec & gully) length when link is inserted or geometry of link is updated',
FALSE, 'utils')
ON CONFLICT (parameter) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype,
widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, hidden)
WITH lyt as (SELECT distinct formname, max(layoutorder) as lytorder from config_form_fields
where layoutname ='lyt_data_1' and formname = 'v_edit_link' group by formname)
SELECT c.formname, formtype, tabname, 'uncertain', 'lyt_data_1', lytorder+1, datatype, widgettype, 'Uncertain', 'Uncertain', NULL, false, false, true, false, false
FROM config_form_fields c join lyt using (formname) WHERE c.formname = 'v_edit_link'
AND columnname = 'is_operative'
group by c.formname, formtype, tabname,  layoutname, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent,
iseditable, isautoupdate,  dv_querytext, dv_orderby_id, dv_isnullvalue, lytorder, hidden
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO selector_municipality SELECT muni_id,current_user FROM ext_municipality;

-- clean code for user's selector function
UPDATE config_param_system set value = gw_fct_json_object_delete_keys(value::json, 'explFromMuni') where parameter = 'basic_selector_tab_municipality';
UPDATE config_param_system set value = gw_fct_json_object_delete_keys(value::json, 'explFromSector') where parameter = 'basic_selector_tab_sector';
UPDATE config_param_system set value = gw_fct_json_object_delete_keys(value::json, 'explFromMuni') where parameter = 'basic_selector_tab_exploitation';
UPDATE config_param_system set value = gw_fct_json_object_delete_keys(value::json, 'explFromMacroexpl') where parameter = 'basic_selector_tab_macrosector';
UPDATE config_param_system set value = gw_fct_json_object_delete_keys(value::json, 'sectorFromMacroexpl') where parameter = 'basic_selector_tab_macrosector';
UPDATE config_param_system set value = gw_fct_json_object_delete_keys(value::json, 'explFromMacroexpl') where parameter = 'basic_selector_tab_macroexploitation';
UPDATE config_param_system set value = gw_fct_json_object_delete_keys(value::json, 'sectorFromMacroexpl') where parameter = 'basic_selector_tab_macroexploitation';

UPDATE config_param_system set value = gw_fct_json_object_set_key(value::json, 'selectionMode', 'keepPreviousUsingShift'::text) where parameter = 'basic_selector_tab_municipality';
UPDATE config_param_system set value = gw_fct_json_object_set_key(value::json, 'selectionMode', 'keepPreviousUsingShift'::text) where parameter = 'basic_selector_tab_sector';
UPDATE config_param_system set value = gw_fct_json_object_set_key(value::json, 'selectionMode', 'keepPreviousUsingShift'::text) where parameter = 'basic_selector_tab_exploitation';
UPDATE config_param_system set value = gw_fct_json_object_set_key(value::json, 'selectionMode', 'keepPreviousUsingShift'::text) where parameter = 'basic_selector_tab_macrosector';
UPDATE config_param_system set value = gw_fct_json_object_set_key(value::json, 'selectionMode', 'keepPreviousUsingShift'::text) where parameter = 'basic_selector_tab_macroexploitation';

UPDATE config_param_system set value = gw_fct_json_object_set_key(value::json, 'selectionMode', 'keepPreviousUsingShift'::text) where parameter = 'basic_selector_tab_psector';
UPDATE config_param_system set value = gw_fct_json_object_set_key(value::json, 'selectionMode', 'keepPreviousUsingShift'::text) where parameter = 'basic_selector_tab_dscenario';

UPDATE config_param_system set value = replace(value, 'sector_id >=0', 'sector_id >0') where parameter = 'basic_selector_tab_sector';

UPDATE link SET muni_id = c.muni_id FROM connec c WHERE connec_id =  feature_id;

-- 20/08/2024
INSERT INTO config_function (id, function_name, "style", layermanager, actions) VALUES(3303, 'gw_fct_getinpdata', '{
  "style": {
    "point": {
      "style": "categorized",
      "field": "fid",
      "width": 2,
      "transparency": 0.5
    },
    "line": {
      "style": "categorized",
      "field": "result_id",
      "width": 2,
      "transparency": 0.5
    },
    "polygon": {
      "style": "categorized",
      "field": "fid",
      "width": 2,
      "transparency": 0.5
    }
  }
}'::json, NULL, NULL);

INSERT INTO sys_function (id,function_name,project_type,function_type,input_params,return_type,descript,sys_role,"source")
VALUES (3310,'gw_fct_getinpdata','utils','function','json','json','The function retrieves GeoJSON data for nodes and arcs based on selected result IDs and returns it in a structured JSON format.','role_epa','core');

INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam)
VALUES('selector_muni', 'Selector of municipalities', 'role_basic', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);

INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam)
VALUES('config_style', 'Catalog of different style context', 'role_basic', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL);

INSERT INTO config_param_system ("parameter", value, descript, "label", isenabled, project_type, "datatype", widgettype)
VALUES('qgis_layers_symbology', '{"styleconfig_vdef":101}', 'Variable to configure parameters related with layer symbology tool', 'Layers symbology', false, 'utils', 'json', 'text');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source")
VALUES(3264, 'Wrong configuration. Check config_form_fields on column widgetcontrol key ''reloadfields'' for columnname:', null, 2, true, 'utils', 'core') ON CONFLICT (id) DO NOTHING;



INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source") VALUES(3316,'gw_fct_admin_transfer_addfields_values', 'utils', 'function', 'json', 'json', 'Function to transfer the addfields values', 'role_admin', 'core')
ON CONFLICT (id) DO UPDATE SET project_type=EXCLUDED.project_type;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source") VALUES(3190, 'gw_trg_feature_border', 'utils', 'trigger', NULL, NULL, NULL, 'role_basic', 'core')
ON CONFLICT (id) DO UPDATE SET project_type=EXCLUDED.project_type;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source") VALUES(3272, 'gw_fct_import_scada_flowmeteragg_values', 'utils', 'function', 'json', 'json', 'Function to import flowmeter aggregated values with random interval in order to transform to daily values', 'role_om', 'core')
ON CONFLICT (id) DO UPDATE SET project_type=EXCLUDED.project_type;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source") VALUES(3166, 'gw_fct_import_scada_values', 'utils', 'function', 'json', 'json', 'Function to import scada values ', 'role_om', 'core')
ON CONFLICT (id) DO UPDATE SET project_type=EXCLUDED.project_type;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source") VALUES(1348, 'gw_trg_node_rotation_update', 'utils', 'trigger', NULL, NULL, 'Trigger that allows to update the node rotation', 'role_basic', 'core')
ON CONFLICT (id) DO UPDATE SET project_type=EXCLUDED.project_type;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source") VALUES(3312, 'gw_fct_mincut_minsector', 'ws', 'function', 'character varying, integer, bool', 'json', 'Function to mincut minsector', 'role_basic', 'core')
ON CONFLICT (id) DO UPDATE SET project_type=EXCLUDED.project_type;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source") VALUES(3314, 'gw_fct_mincut_minsector_inverted', 'ws', 'function', 'integer, integer', 'integer', 'Function to mincut minsector inverted ', 'role_om', 'core')
ON CONFLICT (id) DO UPDATE SET project_type=EXCLUDED.project_type;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source") VALUES(3318, 'gw_fct_utils_update_dma_hydroval', 'ws', 'function', null, 'integer', 'Function to update dma hydroval', 'role_edit', 'core')
ON CONFLICT (id) DO UPDATE SET project_type=EXCLUDED.project_type;

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES ('layout_name_typevalue', 'lyt_buttons', 'lyt_buttons', 'layoutButtons', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('arc', 'form_feature', 'tab_none', 'btn_accept', 'lyt_buttons', 0, NULL, 'button', NULL, 'Accept', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Accept"}'::json, '{"functionName": "accept", "params": {}}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('arc', 'form_feature', 'tab_none', 'btn_apply', 'lyt_buttons', 0, NULL, 'button', NULL, 'Apply', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Apply"}'::json, '{"functionName": "apply", "params": {}}'::json, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('arc', 'form_feature', 'tab_none', 'btn_cancel', 'lyt_buttons', 0, NULL, 'button', NULL, 'Cancel', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Cancel"}'::json, '{"functionName": "cancel", "params": {}}'::json, NULL, false, 2);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('node', 'form_feature', 'tab_none', 'btn_accept', 'lyt_buttons', 0, NULL, 'button', NULL, 'Accept', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Accept"}'::json, '{"functionName": "accept", "params": {}}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('node', 'form_feature', 'tab_none', 'btn_apply', 'lyt_buttons', 0, NULL, 'button', NULL, 'Apply', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Apply"}'::json, '{"functionName": "apply", "params": {}}'::json, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('node', 'form_feature', 'tab_none', 'btn_cancel', 'lyt_buttons', 0, NULL, 'button', NULL, 'Cancel', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Cancel"}'::json, '{"functionName": "cancel", "params": {}}'::json, NULL, false, 2);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('connec', 'form_feature', 'tab_none', 'btn_accept', 'lyt_buttons', 0, NULL, 'button', NULL, 'Accept', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Accept"}'::json, '{"functionName": "accept", "params": {}}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('connec', 'form_feature', 'tab_none', 'btn_apply', 'lyt_buttons', 0, NULL, 'button', NULL, 'Apply', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Apply"}'::json, '{"functionName": "apply", "params": {}}'::json, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('connec', 'form_feature', 'tab_none', 'btn_cancel', 'lyt_buttons', 0, NULL, 'button', NULL, 'Cancel', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Cancel"}'::json, '{"functionName": "cancel", "params": {}}'::json, NULL, false, 2);


--29/08/2024
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, "source")
	VALUES(3320, 'gw_fct_set_rpt_archived', 'ud', 'function', 'json', 'json', 'Function to archive or restore results.', 'role_epa', 'core')
ON CONFLICT (id) DO UPDATE SET project_type=EXCLUDED.project_type;

INSERT INTO config_param_user ("parameter", "value", cur_user) VALUES('edit_municipality_vdefault', NULL, current_user) ON CONFLICT ("parameter", cur_user) DO NOTHING;


update samplepoint sp set sector_id = a.sector_id, muni_id = a.muni_id from (
select ss.sample_id, s.sector_id, m.muni_id from samplepoint ss
	left join sector s on st_dwithin(s.the_geom, ss.the_geom, 1)
	left join ext_municipality m on st_intersects(s.the_geom, m.the_geom)
)a where sp.sample_id = a.sample_id;

update samplepoint set sector_id = 0 where sector_id is null;
update samplepoint set muni_id = 0 where muni_id is null;


update "element" e set muni_id = a.muni_id, sector_id = a.sector_id from (
select element_id, node_id, n.muni_id, n.sector_id from element_x_node
	left join node n using (node_id)
)a where e.element_id = a.element_id;

update "element" e set muni_id = a.muni_id, sector_id = a.sector_id from (
select element_id, arc_id, b.muni_id, b.sector_id from element_x_arc
	left join arc b using (arc_id)
)a where e.element_id = a.element_id;

update "element" e set muni_id = a.muni_id, sector_id = a.sector_id from (
select element_id, connec_id, c.muni_id, c.sector_id from element_x_connec
	left join connec c using (connec_id)
)a where e.element_id = a.element_id;

update "element" set muni_id=0 where muni_id is null;
update "element" set sector_id=0 where sector_id is null;


update link b set sector_id = a.sector_id, muni_id = a.muni_id from (
select feature_id, c.sector_id, c.muni_id from link l
	left join connec c on l.feature_id = c.connec_id where l.feature_type = 'CONNEC'
)a where b.feature_id = a.feature_id;


update dimensions d set sector_id = a.sector_id, muni_id = a.muni_id from (
select d.id, s.sector_id, e.muni_id from dimensions d 
	left join sector s on st_dwithin(s.the_geom, d.the_geom, 0.01)
	left join ext_municipality e on st_dwithin(e.the_geom, d.the_geom, 0.01)
)a where d.id = a.id;


update om_visit e set muni_id = a.muni_id, sector_id = a.sector_id from (
select visit_id, node_id, n.muni_id, n.sector_id from om_visit_x_node
	left join node n using (node_id)
)a where e.id = a.visit_id;

update om_visit e set muni_id = a.muni_id, sector_id = a.sector_id from (
select visit_id, arc_id, n.muni_id, n.sector_id from om_visit_x_arc
	left join arc n using (arc_id)
)a where e.id = a.visit_id;

update om_visit e set muni_id = a.muni_id, sector_id = a.sector_id from (
select visit_id, connec_id, n.muni_id, n.sector_id from om_visit_x_connec
	left join connec n using (connec_id)
)a where e.id = a.visit_id;

update om_visit set muni_id = 0 where muni_id is null;
update om_visit set sector_id = 0 where sector_id is null;