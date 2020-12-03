/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE audit_cat_error SET error_message='It is impossible to use the node to fusion two arcs' WHERE id=2004;
UPDATE audit_cat_error SET error_message='It is impossible to use the node to fusion two arcs' WHERE id=2006;

UPDATE config_param_system SET label = 'Force arc direction using slope direction:', layout_order=8 WHERE parameter='geom_slp_direction';

UPDATE config_param_system SET label = 'Change topocontrol error by log message:', layout_order=5,
descript='If TRUE, topocontrol function is used but the elements which violates topology also can get inside the network. As a result log message of errors it is inserted on audit_log_data table (fprocesscat_id=3). Be careful, this function can lead to errors'
WHERE parameter='edit_topocontrol_dsbl_error';


UPDATE config_param_system SET label = 'Arc topology:', layout_order=9 WHERE parameter='arc_searchnodes';
UPDATE config_param_system SET label = 'Node topology:', layout_order=10 WHERE parameter='node_proximity';
UPDATE config_param_system SET label = 'Connec topology:', layout_order=11 WHERE parameter='connec_proximity';
UPDATE config_param_system SET label = 'Gully topology:', isenabled=true, layout_id=13, layout_order=12, iseditable=true WHERE parameter='gully_proximity';
UPDATE config_param_system SET label = 'Node double geometry enabled:', layout_order=16 WHERE parameter='insert_double_geometry';

UPDATE config_param_system SET isenabled=false, isdeprecated=true WHERE parameter='node_duplicated_tolerance';
UPDATE config_param_system SET isenabled=false, isdeprecated=true WHERE parameter='connec_duplicated_tolerance';


UPDATE audit_cat_param_user SET feature_field_id ='state' WHERE id='state_vdefault';
UPDATE audit_cat_param_user SET feature_field_id ='builtdate' WHERE id='builtdate_vdefault';
UPDATE audit_cat_param_user SET feature_field_id ='enddate' WHERE id='enddate_vdefault';
UPDATE audit_cat_param_user SET feature_field_id ='workcat_id' WHERE id='workcat_vdefault';
UPDATE audit_cat_param_user SET feature_field_id ='workcat_id_end' WHERE id='workcat_id_end_vdefault';
UPDATE audit_cat_param_user SET feature_field_id ='soilcat_id' WHERE id='soilcat_vdefault';
			
UPDATE audit_cat_param_user SET label='Automatic link from connec to network:'
			WHERE id='edit_connect_force_automatic_connect2network';

UPDATE audit_cat_param_user SET formname=null
			WHERE id='edit_arc_division_dsbl';
			
UPDATE audit_cat_param_user SET formname=null
			WHERE id='edit_connect_force_downgrade_linkvnode';

UPDATE om_visit_type SET idval='unexpected' WHERE idval ='unspected';

--2019/05/30
INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2690, 'gw_fct_admin_schema_manage_addfields', 'utils','function', 'Create addfields definition and related custom view','role_admin',FALSE, FALSE,FALSE);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2692, 'gw_fct_utils_export_ui_xml', 'utils','function', 'Export UI xml in order to modify fields order in the custom form','role_admin',FALSE, FALSE,FALSE);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2694, 'gw_fct_utils_import_ui_xml', 'utils','function', 'Import UI xml and update fields order in the custom form','role_admin',FALSE, FALSE,FALSE);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2696, 'gw_fct_om_visit_event_manager', 'utils','function', 'Manager to work with advanced functionalities on events configurable using action_type on parameter_x_parameter table' ,'role_admin',FALSE, FALSE,FALSE);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2697, 'gw_fct_pg2epa_singlenodecapacity', 'ws','function', 'Function with unlimited steps to analyze full network with different demands on one single node on network' ,'role_epa',FALSE, FALSE,FALSE);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2698, 'gw_fct_pg2epa_nodescouplecapacity', 'ws','function', 'Function with five steps to analyze full network with different demands using couples of nodes on network (according spanish rules for firetap analytics)' ,'role_epa',FALSE, FALSE,FALSE);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2700, 'gw_fct_admin_manage_fields', 'utils','function', 'Function to administrate fields on tables used on sql file to prevent conflict when field exists' ,'role_admin',FALSE, FALSE,FALSE);


INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3016, 'New field overlaps the existing one', 'Modify the order value.', 2, TRUE, 'utils',FALSE);

--03/06/2019
UPDATE config_param_system SET value='{"status":"TRUE" , "field":"code"}' WHERE parameter='customer_code_autofill';
UPDATE config_param_system SET descript='If status is TRUE, when insert a new connec, customer_code will be the same as field (connec_id or code)' WHERE parameter='customer_code_autofill';

--19/06/2019
INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated,istoolbox, isparametric)
VALUES (2702,'gw_trg_unique_field','utils', 'trigger function','Check unique values of attributes in a table', 'role_edit', FALSE, FALSE, FALSE);

INSERT INTO audit_cat_error( id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3018, 'Customer code is duplicated for connecs with state=1','Review your data.',2, TRUE, 'utils', FALSE);

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, fprocess_i18n, project_type)
VALUES (43, 'Replace feature','Edit','Replace feature', 'utils');

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox,isparametric)
VALUES (2742, 'gw_trg_edit_config_sys_fields','utils','trigger', 'Edit fields of config api form fields','role_admin',false,false,false);



-- 24/05/2019

UPDATE config_api_form_fields SET formtype='form' WHERE formname='printGeneric';

Delete from config_api_form_fields where formname='infoplan' and column_id IN ('frame2','intermediate_cost', 'other_cost');
DELETE FROM config_api_form_tabs WHERE tabname='tab_rpt';


UPDATE sys_feature_cat SET shortcut_key = 'P' WHERE id = 'PUMP' AND tablename = 'v_edit_man_pump';
UPDATE cat_feature SET shortcut_key = concat('Alt+',sys_feature_cat.shortcut_key) FROM sys_feature_cat WHERE sys_feature_cat.id = cat_feature.id and cat_feature.feature_type = 'NODE';
UPDATE cat_feature SET shortcut_key = concat('Ctrl+',sys_feature_cat.shortcut_key) FROM sys_feature_cat WHERE sys_feature_cat.id = cat_feature.id and cat_feature.feature_type = 'CONNEC';
UPDATE cat_feature SET shortcut_key = sys_feature_cat.shortcut_key FROM sys_feature_cat WHERE sys_feature_cat.id = cat_feature.id and cat_feature.feature_type = 'ARC';


UPDATE config_param_system SET value = '{"sys_table_id":"v_edit_node", "sys_id_field":"node_id", "sys_search_field":"code", "alias":"Nodes", "cat_field":"nodecat_id", "orderby":"2", "feature_type":"node_id"}' 
	WHERE parameter = 'api_search_node';

UPDATE config_param_system SET value = '{"sys_table_id":"v_edit_connec", "sys_id_field":"connec_id", "sys_search_field":"code", "alias":"Connecs", "cat_field":"connecat_id", "orderby":"3", "feature_type":"connec_id"}' 
	WHERE parameter = 'api_search_connec';

UPDATE config_param_system SET value = '{"sys_table_id":"v_edit_element", "sys_id_field":"element_id", "sys_search_field":"code", "alias":"Elements", "cat_field":"elementcat_id", "orderby":"5", "feature_type":"element_id"}' 
	WHERE parameter = 'api_search_element';

UPDATE config_param_system SET value = '{"sys_table_id":"v_edit_arc", "sys_id_field":"arc_id", "sys_search_field":"code", "alias":"Arcs", "cat_field":"arccat_id", "orderby" :"1", "feature_type":"arc_id"}' 
	WHERE parameter = 'api_search_arc';


UPDATE config_api_form_fields set typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' 
WHERE column_id='arccat_id';

UPDATE config_api_form_fields set typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' 
WHERE column_id='nodecat_id';

UPDATE config_api_form_fields set typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' 
WHERE column_id='connecat_id';

UPDATE config_api_form_fields set typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' 
WHERE column_id='connecat_id';

UPDATE config_api_form_fields set typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' 
WHERE column_id='gratecat_id';

UPDATE config_api_form_fields set widgettype='typeahead', typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' 
WHERE column_id='workcat_id';

UPDATE config_api_form_fields set widgettype='typeahead', typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' 
WHERE column_id='workcat_id_end';



UPDATE config_api_form_fields set layout_name = concat('data_',layout_id) WHERE layout_name IS NULL;


-- 28/05/2019

UPDATE cat_feature SET parent_layer = 'v_edit_node' where parent_layer = 've_node';
UPDATE cat_feature SET parent_layer = 'v_edit_arc' where parent_layer = 've_arc';
UPDATE cat_feature SET parent_layer = 'v_edit_connec' where parent_layer = 've_connec';


UPDATE config_api_form_fields SET formname='unexpected_noinfra' WHERE formname='unspected_noinfra';
UPDATE config_api_form_fields SET formname='unexpected_arc' WHERE formname= 'unspected_arc';

UPDATE config_api_visit SET formname='unexpected_arc' WHERE formname= 'unspected_arc';
UPDATE config_api_visit SET formname='unexpected_noinfra' WHERE formname= 'unspected_noinfra';

-- 10/06/2019

UPDATE config_api_form_fields SET dv_querytext = 'SELECT id, id as idval FROM om_visit_lot WHERE active IS TRUE' WHERE formtype='visit' and column_id = 'lot_id';

UPDATE config_api_list SET query_text = 'SELECT DISTINCT ON (a.id) a.id AS sys_id, a.id AS lot_id, ''om_visit_lot'' as sys_table_id, ''id'' as sys_idname FROM om_visit_lot a' WHERE id = 28240;

UPDATE config_api_form_fields SET layout_order = 6 WHERE id = 30040;
UPDATE config_api_form_fields SET layout_order = 7 WHERE id = 30050;

UPDATE config_api_form_fields SET dv_querytext='SELECT id, idval FROM config_api_typevalue WHERE typevalue=''listlimit''' WHERE id='102718';

-- 11/07/2019

UPDATE config_api_form_fields SET column_id = 'connec_type' WHERE column_id = 'connectype_id';

-- 12/07/2019

UPDATE config_api_form_fields SET isparent = True WHERE column_id = 'node_type';
UPDATE config_api_form_fields SET isparent = True WHERE column_id = 'arctype_id';
UPDATE config_api_form_fields SET isparent = True WHERE column_id = 'connec_type';
UPDATE config_api_form_fields SET isparent = True WHERE column_id = 'muni_id';

UPDATE config_api_form_fields SET dv_parent_id = 'node_type' WHERE dv_parent_id = 'nodetype_id';
UPDATE config_api_form_fields SET dv_parent_id = 'arc_type' WHERE dv_parent_id = 'arctype_id';
UPDATE config_api_form_fields SET dv_parent_id = 'connec_type' WHERE dv_parent_id = 'connectype_id';

DELETE FROM config_api_form_fields WHERE formname='v_ui_om_visitman_x_arc';
DELETE FROM config_api_form_fields WHERE formname='v_ui_om_visitman_x_connec';
DELETE FROM config_api_form_fields WHERE formname='v_ui_om_visitman_x_node';
DELETE FROM config_api_form_fields WHERE formname='lot';
DELETE FROM config_api_form_fields WHERE formname='om_visit';
DELETE FROM config_api_form_fields WHERE formname='om_visit_lot';
DELETE FROM config_api_form_fields WHERE formname='om_visit_event_photo';

DELETE FROM config_api_form_fields WHERE formname='visit_node_leak';
DELETE FROM config_api_form_fields WHERE formname='visit_connec_leak';
DELETE FROM config_api_form_fields WHERE formname='visit_arc_leak';
DELETE FROM config_api_form_fields WHERE formname='visit_node_insp';
DELETE FROM config_api_form_fields WHERE formname='visit_connec_insp';
DELETE FROM config_api_form_fields WHERE formname='visit_arc_insp';
DELETE FROM config_api_form_fields WHERE formname='visit_class_0';
DELETE FROM config_api_form_fields WHERE formname='unexpected_noinfra';
DELETE FROM config_api_form_fields WHERE formname='unexpected_arc';
DELETE FROM config_api_form_fields WHERE formname='visit_emb_insp';
DELETE FROM config_api_form_fields WHERE formname='visit_connec_insp_';
DELETE FROM config_api_form_fields WHERE formname='visit_node_insp_';

SELECT setval('SCHEMA_NAME.config_api_form_fields_id_seq', (SELECT max(id) FROM config_api_form_fields), true);

INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('v_ui_om_visitman_x_node', 'listHeader', 'limit', 1, 2, true, 'integer', 'text', 'Limit', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"vdefault":15}', NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('v_ui_om_visitman_x_connec', 'listHeader', 'limit', 1, 2, true, 'integer', 'text', 'Limit', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"vdefault":15}', NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('om_visit_event_photo', 'listHeader', 'filetype', 1, 1, true, NULL, 'combo', 'Tipus fitxer', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, 'SELECT distinct filetype AS id, filetype AS idval FROM om_visit_filetype_x_extension WHERE filetype IS NOT NULL', NULL, true, NULL, NULL, 'gwGetVisit', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('v_ui_om_visitman_x_arc', 'listFooter', 'backbutton', 9, 1, true, NULL, 'button', 'Enrere', NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'backButtonClicked', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('v_ui_om_visitman_x_node', 'listFooter', 'backbutton', 9, 1, true, NULL, 'button', 'Enrere', NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'backButtonClicked', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('v_ui_om_visitman_x_connec', 'listFooter', 'backbutton', 9, 1, true, NULL, 'button', 'Enrere', NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'backButtonClicked', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('v_ui_om_visitman_x_arc', 'listHeader', 'visit_start', 1, 1, true, 'date', 'datepickertime', 'Des de', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"sign":">","vdefault":"01-01-2014" }', NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('v_ui_om_visitman_x_arc', 'listHeader', 'limit', 1, 2, true, 'integer', 'text', 'Limit', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"vdefault":15}', NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('v_ui_om_visitman_x_node', 'listHeader', 'visit_start', 1, 1, true, 'date', 'datepickertime', 'Des de', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"sign":">","vdefault":"01-01-2014" }', NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('v_ui_om_visitman_x_connec', 'listHeader', 'visit_start', 1, 1, true, 'date', 'datepickertime', 'Des de', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"sign":">","vdefault":"01-01-2014" }', NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('om_visit_event_photo', 'listHeader', 'limit', 1, 2, true, 'integer', 'text', 'Limit', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwGetVisit', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('om_visit_event_photo', 'listFooter', 'backbutton', 9, 1, true, NULL, 'button', 'Enrera', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'backButtonClicked', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- 22/07/2019

INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('dimensioning', 'catalog', 'id', 1, 1, true, 'string', 'text', 'id', NULL, NULL, NULL, NULL, NULL, true, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, 'layout_data_1', NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('dimensioning', 'catalog', 'distance', 1, 2, true, 'numeric', 'text', 'custom distance', NULL, NULL, NULL, 12, 4, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, 'layout_data_1', NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('dimensioning', 'catalog', 'depth', 1, 4, true, 'numeric', 'text', 'custom depth', NULL, NULL, NULL, 12, 4, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, 'layout_data_1', NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('dimensioning', 'catalog', 'feature_type', 1, 6, true, 'string', 'text', 'feature type', NULL, NULL, NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, 'layout_data_1', NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('dimensioning', 'catalog', 'feature_id', 1, 5, true, 'string', 'text', 'feature id', NULL, NULL, NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, 'layout_data_1', NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('dimensioning', 'catalog', 'x_symbol', 1, 8, true, 'numeric', 'text', 'x symbol', NULL, NULL, NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, 'layout_data_1', NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('dimensioning', 'catalog', 'y_symbol', 1, 9, true, 'numeric', 'text', 'y symbol', NULL, NULL, NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, 'layout_data_1', NULL, NULL);

DELETE FROM config_api_form_tabs WHERE tabname='tab_connections' AND formname='v_edit_connec';


--2019/08/01
-----------------------
-- value type values
-----------------------

INSERT INTO config_api_typevalue VALUES ('listlimit', '1', '10', NULL);
INSERT INTO config_api_typevalue VALUES ('listlimit', '2', '50', NULL);
INSERT INTO config_api_typevalue VALUES ('listlimit', '3', '100', NULL);
INSERT INTO config_api_typevalue VALUES ('listlimit', '4', '500', NULL);
INSERT INTO config_api_typevalue VALUES ('listlimit', '5', '1000', NULL);
INSERT INTO config_api_typevalue VALUES ('datatype_typevalue', 'text', 'text', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('datatype_typevalue', 'string', 'string', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('datatype_typevalue', 'date', 'date', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('datatype_typevalue', 'bytea', 'bytea', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('datatype_typevalue', 'character varying', 'character varying', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('datatype_typevalue', 'boolean', 'boolean', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('datatype_typevalue', 'double', 'double', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('datatype_typevalue', 'integer', 'integer', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('datatype_typevalue', 'smallint', 'smallint', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('datatype_typevalue', 'numeric', 'numeric', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('widgettype_typevalue', 'nowidget', 'nowidget', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('widgettype_typevalue', 'text', 'text', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('widgettype_typevalue', 'button', 'button', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('widgettype_typevalue', 'typeahead', 'typeahead', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('widgettype_typevalue', 'image', 'image', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('widgettype_typevalue', 'datepickertime', 'datepickertime', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('widgettype_typevalue', 'formDivider', 'formDivider', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('widgettype_typevalue', 'label', 'label', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('widgettype_typevalue', 'doubleSpinbox', 'doubleSpinbox', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('widgettype_typevalue', 'check', 'check', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('widgettype_typevalue', 'hyperlink', 'hyperlink', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('widgettype_typevalue', 'combo', 'combo', NULL, NULL);

UPDATE config_api_form_fields SET layout_name='top_layout' WHERE formname='dimensioning' AND column_id='id';
UPDATE config_api_form_fields SET layout_name='distance_layout' WHERE formname='dimensioning' AND column_id='distance';
UPDATE config_api_form_fields SET layout_name='depth_layout' WHERE formname='dimensioning' AND (column_id='depth' OR column_id='feature_type' OR column_id='feature_id');
UPDATE config_api_form_fields SET layout_name='symbology_layout' WHERE formname='dimensioning' AND (column_id='x_symbol' OR column_id='y_symbol');

--common catalogs
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_connec','form', 'matcat_id', null, null, true, 'string',  'combo', true, 'SELECT id, descript AS idval FROM cat_mat_node WHERE id IS NOT NULL', 'matcat_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_connec', 'form', 'brand', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM cat_brand WHERE id IS NOT NULL', 'brand');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_connec', 'form', 'model', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM cat_brand_model WHERE id IS NOT NULL', 'model');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_connec', 'form', 'cost_ut', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM price_compost WHERE id IS NOT NULL', 'cost_ut');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_connec', 'form', 'cost_ml', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM price_compost WHERE id IS NOT NULL', 'cost_ml');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_connec', 'form', 'cost_m3', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM price_compost WHERE id IS NOT NULL', 'cost_m3');

INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_arc','form', 'matcat_id', null, null, true, 'string',  'combo', true, 'SELECT id, descript AS idval FROM cat_mat_arc WHERE id IS NOT NULL', 'matcat_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_arc', 'form', 'brand', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM cat_brand WHERE id IS NOT NULL', 'brand');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_arc', 'form', 'model', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM cat_brand_model WHERE id IS NOT NULL', 'model');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_arc', 'form', 'cost_unit', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM price_value_unit WHERE id IS NOT NULL', 'cost_unit');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_arc', 'form', 'cost', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM price_compost WHERE id IS NOT NULL', 'cost');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_arc', 'form', 'm2bottom_cost', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM price_compost WHERE id IS NOT NULL', 'm2bottom_cost');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_arc', 'form', 'm3protec_cost', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM price_compost WHERE id IS NOT NULL', 'm3protec_cost');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_arc', 'form', 'shape', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM cat_arc_shape WHERE id IS NOT NULL', 'shape');

INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_node','form', 'matcat_id', null, null, true, 'string',  'combo', true, 'SELECT id, descript AS idval FROM cat_mat_node WHERE id IS NOT NULL', 'matcat_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_node', 'form', 'brand', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM cat_brand WHERE id IS NOT NULL', 'brand');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_node', 'form', 'model', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM cat_brand_model WHERE id IS NOT NULL', 'model');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_node', 'form', 'cost_unit', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM price_value_unit WHERE id IS NOT NULL', 'cost_unit');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_node', 'form', 'cost', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM price_compost WHERE id IS NOT NULL', 'cost');

INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_element','form', 'matcat_id', null, null, true, 'string',  'combo', true, 'SELECT id, descript AS idval FROM cat_mat_element WHERE id IS NOT NULL', 'matcat_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_element','form', 'elementtype_id', null, null, true, 'string',  'combo', true, 'SELECT id, id AS idval FROM element_type WHERE id IS NOT NULL', 'elementtype_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_element', 'form', 'brand', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM cat_brand WHERE id IS NOT NULL', 'brand');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_element', 'form', 'model', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM cat_brand_model WHERE id IS NOT NULL', 'model');

INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_soil', 'form', 'm3exc_cost', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM price_compost WHERE id IS NOT NULL', 'm3exc_cost');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_soil', 'form', 'm3fill_cost', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM price_compost WHERE id IS NOT NULL', 'm3fill_cost');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_soil', 'form', 'm3excess_cost', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM price_compost WHERE id IS NOT NULL', 'm3excess_cost');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_soil', 'form', 'm2trenchl_cost', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM price_compost WHERE id IS NOT NULL', 'm2trenchl_cost');

INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_pavement', 'form', 'm2_cost', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM price_compost WHERE id IS NOT NULL', 'm2_cost');

INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_brand_model', 'form', 'catbrand_id', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM cat_brand WHERE id IS NOT NULL', 'catbrand_id');

INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('cat_users', 'form', 'sys_role', null, null, true, 'string', 'combo', true, 'SELECT id, id AS idval FROM sys_role WHERE id IS NOT NULL', 'sys_role');

--zones
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_dma','form', 'expl_id', null, null, true, 'integer',  'combo', true, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', 'expl_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_dma','form', 'macrodma_id', null, null, true, 'integer',  'combo', false, 'SELECT macrodma_id as id, name as idval FROM macrodma WHERE macrodma_id IS NOT NULL','macrodma_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('exploitation','form', 'macroexpl_id', null, null, true, 'integer',  'combo', false, 'SELECT macroexpl_id as id, name as idval FROM macroexploitation WHERE macroexpl_id IS NOT NULL','macroexpl_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_sector','form', 'macrosector_id', null, null, true, 'integer',  'combo', false, 'SELECT macrosector_id as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL','macrosector_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_macrodma', 'form', 'expl_id', null, null, true, 'string', 'combo', true, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', 'expl_id');

--link
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_link','form', 'expl_id', null, null, true, 'integer',  'combo', true, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', 'expl_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_link','form', 'dma_id', null, null, true, 'integer',  'combo', true, 'SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL', 'dma_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_link','form', 'state', null, null, true, 'integer',  'combo', true, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', 'state');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_link','form', 'macrosector_id', null, null, true, 'integer',  'combo', false, 'SELECT macrosector_id as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL','macrosector_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_link','form', 'macrodma_id', null, null, true, 'integer',  'combo', false, 'SELECT macrodma_id as id, name as idval FROM macrodma WHERE macrodma_id IS NOT NULL','macrodma_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_link','form', 'sector_id', null, null, true, 'integer',  'combo', true, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL','sector_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_link','form', 'feature_type', null, null, true, 'string',  'combo', true, 'SELECT id, id as idval FROM sys_feature_type WHERE id IS NOT NULL', 'feature_type');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_link','form', 'exit_type', null, null, true, 'string',  'combo', true, 'SELECT id, id as idval FROM sys_feature_type WHERE id IS NOT NULL', 'exit_type');

--vnode
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_vnode','form', 'sector_id', null, null, true, 'integer',  'combo', true, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL','sector_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_vnode','form', 'expl_id', null, null, true, 'integer',  'combo', true, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', 'expl_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_vnode','form', 'dma_id', null, null, true, 'integer',  'combo', true, 'SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL', 'dma_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_vnode','form', 'state', null, null, true, 'integer',  'combo', true, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', 'state');

--element
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'element_id', 1, 1, true, 'string',  'text', true, NULL,'Element id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'code', 1, 2, true, 'string',  'text', true, NULL,'Code');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'elementcat_id', 1, 3, true, 'string',  'text', true, NULL,'Catalog');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'expl_id', 1, 4, true, 'integer',  'text', true, NULL, 'Exploitation');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'dma_id', 1, 5, true, 'integer',  'text', true, NULL, 'Dma');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'state', 1, 6, true, 'integer',  'text', true, NULL, 'State');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'state_type', 1, 7, true, 'integer',  'text', true, NULL,'State type');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'workcat_id', 1, 8, true, 'string',  'text', true, NULL, 'Workcat');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'workcat_id_end', 1, 9, true, 'string',  'text', true, NULL, 'Workcat end');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'ownercat_id', null, null, true, 'string',  'text', true, NULL,'Owner');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'buildercat_id', null, null, true, 'string',  'text', true, NULL,'Builder');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'verified', null, null, true, 'string',  'text', true, NULL, 'Verified');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'function_type', null, null, true, 'string',  'text', true, NULL, 'Function type');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'category_type', null, null, true, 'string',  'text', true, NULL, 'Category type');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'location_type', null, null, true, 'string',  'text', true, NULL, 'Location type');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'fluid_type', null, null, true, 'string',  'text', true, NULL, 'Fluid type');

--samplepoint
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_samplepoint','form', 'featurecat_id', null, null, true, 'string',  'combo', true, 'SELECT id, id as idval FROM cat_feature WHERE id IS NOT NULL','featurecat_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_samplepoint','form', 'expl_id', null, null, true, 'integer',  'combo', true, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', 'expl_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_samplepoint','form', 'dma_id', null, null, true, 'integer',  'combo', true, 'SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL', 'dma_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label, isparent, isreload)
VALUES ('v_edit_samplepoint','form', 'state', null, null, true, 'integer',  'combo', true, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', 'state', true, true);
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label, typeahead)
VALUES ('v_edit_samplepoint','form', 'workcat_id', null, null, true, 'string',  'typeahead', true, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL','workcat_id', '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label, typeahead)
VALUES ('v_edit_samplepoint','form', 'workcat_id_end', null, null, true, 'string',  'typeahead', true, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL','workcat_id_end', '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_samplepoint','form', 'muni_id', null, null, true, 'string',  'combo', true, 'SELECT muni_id as id, name as idval FROM ext_municipality WHERE muni_id IS NOT NULL', 'muni_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_samplepoint','form', 'streetaxis_id', null, null, true, 'string',  'combo', true, 'SELECT id, name as idval FROM v_ext_streetaxis WHERE id IS NOT NULL','streetaxis_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_samplepoint','form', 'streetaxis2_id', null, null, true, 'string',  'combo', true, 'SELECT id, name as idval FROM v_ext_streetaxis WHERE id IS NOT NULL','streetaxis2_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_samplepoint','form', 'macrodma_id', null, null, true, 'integer',  'combo', false, 'SELECT macrodma_id as id, name as idval FROM macrodma WHERE macrodma_id IS NOT NULL','macrodma_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_samplepoint','form', 'verified', null, null, true, 'string',  'combo', true, 'SELECT id, id as idval FROM value_verified WHERE id IS NOT NULL', 'verified');




--config_api_typevalue values and foreign keys config


INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('layout_name_typevalue','bot_layout_1','bot_layout_1');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('layout_name_typevalue','bot_layout_2','bot_layout_2');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('layout_name_typevalue','data_1','data_1');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('layout_name_typevalue','data_2','data_2');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('layout_name_typevalue','data_9','data_9');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('layout_name_typevalue','depth_layout','depth_layout');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('layout_name_typevalue','distance_layout','distance_layout');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('layout_name_typevalue','layout_data_1','layout_data_1');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('layout_name_typevalue','layout_data_2','layout_data_2');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('layout_name_typevalue','layout_data_3','layout_data_3');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('layout_name_typevalue','symbology_layout','symbology_layout');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('layout_name_typevalue','top_layout','top_layout');



INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('formtype_typevalue','listHeader','listHeader');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('formtype_typevalue','listFooter','listFooter');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('formtype_typevalue','form','form');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('formtype_typevalue','feature','feature');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('formtype_typevalue','visit','visit');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('formtype_typevalue','catalog','catalog');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('formtype_typevalue','lot','lot');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('formtype_typevalue','listfilter','listfilter');


INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('formtemplate_typevalue','GENERIC','GENERIC');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('formtemplate_typevalue','custom feature','custom feature');


INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('widgetfunction_typevalue','gwGetVisit','gwGetVisit');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('widgetfunction_typevalue','gw_api_open_url','gw_api_open_url');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('widgetfunction_typevalue','gw_api_setprint','gw_api_setprint');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('widgetfunction_typevalue','backButtonClicked','backButtonClicked');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('widgetfunction_typevalue','gwSetVisit','gwSetVisit');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('widgetfunction_typevalue','gw_api_open_node','gw_api_open_node');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('widgetfunction_typevalue','get_catalog_id','get_catalog_id');


INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tab_hydrometer_val','tab_hydrometer_val');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tab_network','tab_network');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tabDone','tabDone');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tabAdmin','tabAdmin');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tab_documents','tab_documents');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tabHydroState','tabHydroState');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tab_hydro','tab_hydro');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tab_elements','tab_elements');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tabUser','tabUser');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tab_relations','tab_relations');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tab_data','tab_data');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tab_visit','tab_visit');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tab_om','tab_om');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tab_inp','tab_inp');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tab_psector','tab_psector');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tabLots','tabLots');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tab_search','tab_search');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tabFiles','tabFiles');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tabNetworkState','tabNetworkState');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tab_workcat','tab_workcat');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tabData','tabData');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tab_plan','tab_plan');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tabExploitation','tabExploitation');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tab_hydrometer','tab_hydrometer');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tab_address','tab_address');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('tabname_typevalue','tab_connections','tab_connections');


INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('mtype_typevalue','withfeature','withfeature');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('mtype_typevalue','alone','alone');


INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('action_function_typevalue','action_workcat','action_workcat');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('action_function_typevalue','action_link','action_link');
INSERT INTO config_api_typevalue (typevalue, id, idval) VALUES ('action_function_typevalue','action_catalog','action_catalog');


DELETE FROM config_api_visit WHERE visitclass_id NOT IN (SELECT id FROM om_visit_class);
DELETE FROM config_api_visit_x_featuretable WHERE visitclass_id NOT IN (SELECT id FROM om_visit_class);