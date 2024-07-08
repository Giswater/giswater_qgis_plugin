/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','NETWORK','NETWORK');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES(3308, 'gw_fct_admin_create_message', 'utils', 'function', 'json', 'json', 'Function to create sys_message efficiently', 'role_admin', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_typevalue VALUES (
'tabname_typevalue','tab_municipality','tab_municipality','tabMunicipality');

INSERT INTO config_form_tabs VALUES ('selector_basic','tab_municipality','Muni','Municipality','role_basic',NULL,NULL,0,'{4,5}');

INSERT INTO config_param_system VALUES (
'basic_selector_tab_municipality',
'{"table":"ext_municipality","selector":"selector_municipality","table_id":"muni_id","selector_id":"muni_id","label":"muni_id, ''- '', name","orderBy":"muni_id","manageAll":true,"selectionMode":"keepPreviousUsingShift","query_filter":"AND muni_id > 0","typeaheadFilter":" AND lower(concat(muni_id, '' - '', name))","typeaheadForced":true,"explFromMuni":true}',
'Variable to configura all options related to search for the specificic tab','Selector variables',NULL,NULL,FALSE,NULL,'utils',NULL,NULL,'json','text');

UPDATE config_form_fields SET widgettype='combo',
dv_querytext='SELECT id, id as idval FROM sys_feature_type WHERE classlevel = 1 OR classlevel = 2',
dv_orderby_id=true, dv_isnullvalue = true WHERE formname='v_edit_dimensions' AND formtype='form_feature' AND columnname='feature_type' AND tabname='tab_none';

-- 21/06/2024
DELETE FROM sys_foreignkey WHERE typevalue_name = 'psector_type' AND target_table='plan_psector';
DELETE FROM plan_typevalue WHERE typevalue='psector_type' AND id='1';

INSERT INTO edit_typevalue VALUES ('presszone_type', 'BUSTER', 'BUSTER');
INSERT INTO edit_typevalue VALUES ('presszone_type', 'TANK', 'TANK');
INSERT INTO edit_typevalue VALUES ('presszone_type', 'PRV', 'PRV');
INSERT INTO edit_typevalue VALUES ('presszone_type', 'PSV', 'PSV');
INSERT INTO edit_typevalue VALUES ('presszone_type', 'PUMP', 'PUMP');
INSERT INTO edit_typevalue VALUES ('presszone_type', 'UNDEFINED', 'UNDEFINED');

INSERT INTO config_param_system ("parameter", value, descript, "label", project_type,"datatype", widgettype)
VALUES('plan_node_replace_code', 'false', 'If true, when a node replace in planification is performed, new arcs will have the same code as the replaced one. Otherwise, new arcs will have the same code as its arc_id.', 'Plan node replace code', 'utils', 'boolean', 'text') ON CONFLICT (parameter) DO NOTHING;

-- 28/06/2024
UPDATE config_form_fields
	SET linkedobject=NULL
	WHERE columnname IN ('date_visit_from', 'date_visit_to') AND tabname='tab_visit';

UPDATE config_form_fields
	SET widgetfunction='{"functionName": "filter_table", "parameters": {"columnfind": "Start date", "targetwidget": "tab_visit_tbl_visits"}}'::json
	WHERE columnname='date_visit_from' AND tabname='tab_visit';

UPDATE config_form_fields
	SET widgetfunction='{"functionName": "filter_table", "parameters": {"columnfind": "End date", "targetwidget": "tab_visit_tbl_visits"}}'::json
	WHERE columnname='date_visit_to' AND tabname='tab_visit';

-- 29/06/2024
INSERT INTO config_param_system VALUES ('edit_connec_autofill_plotcode', 'FALSE', 'Variable to automatic fill plot_code', 'Variable to automatic fill plot_code', null, null, TRUE, null, null, null, null, 'boolean', 'text'); 

-- 02/07/2024
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_dma', 'form_feature', 'tab_data', 'expl_id2', 'lyt_data_1', 17, 'string', 'combo', 'expl_id2', 'expl_id2', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id is not null ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);

-- 05/07/2024
UPDATE sys_param_user SET "label"='End date:' WHERE id='edit_enddate_vdefault';
