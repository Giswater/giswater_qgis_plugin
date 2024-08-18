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

INSERT INTO selector_muni SELECT muni_id,current_user FROM ext_municipality;
