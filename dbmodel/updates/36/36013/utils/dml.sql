/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

DELETE FROM config_form_fields WHERE formname='visit_arc_leak' AND formtype='form_visit' AND columnname='visit_id' AND tabname='tab_data';
DELETE FROM config_form_fields WHERE formname='visit_node_insp' AND formtype='form_visit' AND columnname='visit_id' AND tabname='tab_data';
DELETE FROM config_form_fields WHERE formname='incident_node' AND formtype='form_visit' AND columnname='visit_id' AND tabname='tab_data';

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
    VALUES('generic', 'form_visit', 'tab_data', 'visit_id', 'lyt_data_1', NULL, 'double', 'text', 'Visit id:', NULL, NULL, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);

UPDATE config_form_fields SET web_layoutorder=2 WHERE formname='visit_connec_leak' AND formtype='form_visit' AND columnname='class_id' AND tabname='tab_data';
UPDATE config_form_fields SET web_layoutorder=2 WHERE formname='incident_node' AND formtype='form_visit' AND columnname='class_id' AND tabname='tab_data';
UPDATE config_form_fields SET web_layoutorder=2 WHERE formname='visit_arc_leak' AND formtype='form_visit' AND columnname='class_id' AND tabname='tab_data';
UPDATE config_form_fields SET web_layoutorder=2 WHERE formname='visit_node_insp' AND formtype='form_visit' AND columnname='class_id' AND tabname='tab_data';

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES ('layout_name_typevalue', 'lyt_main_1', 'lyt_main_1', 'layoutMain1', '{"lytOrientation":"vertical"}');
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES ('layout_name_typevalue', 'lyt_main_2', 'lyt_main_2', 'layoutMain2', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES ('layout_name_typevalue', 'lyt_main_3', 'lyt_main_3', 'layoutMain3', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES ('formtype_typevalue', 'form_featuretype_change', 'form_featuretype_change', 'formFeaturetypeChange', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
 VALUES ('generic', 'form_featuretype_change', 'tab_none', 'btn_accept', 'lyt_buttons', 2, NULL, 'button', NULL, NULL, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"text": "Accept"}'::json, '{"functionName": "btn_accept_featuretype_change", "module": "featuretype_change_button", "parameters": {}}'::json, NULL, FALSE, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
 VALUES ('generic', 'form_featuretype_change', 'tab_none', 'spacer', 'lyt_buttons', 1, NULL, 'hspacer', NULL, NULL, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
 VALUES ('generic', 'form_featuretype_change', 'tab_none', 'btn_cancel', 'lyt_buttons', 3, NULL, 'button', NULL, NULL, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"text": "Cancel"}'::json, '{"functionName": "btn_cancel_featuretype_change", "module": "featuretype_change_button", "parameters": {}}'::json, NULL, FALSE, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
 VALUES ('generic', 'form_featuretype_change', 'tab_none', 'btn_catalog', 'lyt_main_2', 3, NULL, 'button', NULL, NULL, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, '{"icon": "195", "size": "20x20"}'::json, NULL, '{"functionName": "btn_catalog_featuretype_change", "module": "featuretype_change_button", "parameters": {}}'::json, NULL, FALSE, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
 VALUES ('generic', 'form_featuretype_change', 'tab_none', 'feature_type', 'lyt_main_1', 1, 'string', 'text', 'Current feature type', 'Current feature type', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
 VALUES ('generic', 'form_featuretype_change', 'tab_none', 'feature_type_new', 'lyt_main_1', 1, 'string', 'combo', 'New feature type', 'New feature type', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"functionName": "cmb_new_featuretype_selection_changed", "module": "featuretype_change_button", "parameters": {}}'::json, NULL, FALSE, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
 VALUES ('generic', 'form_featuretype_change', 'tab_none', 'featurecat_id', 'lyt_main_2', 1, 'string', 'combo', 'Catalog id', 'Catalog id', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
 VALUES ('generic', 'form_featuretype_change', 'tab_none', 'fluid_type', 'lyt_main_3', 1, 'string', 'combo', 'Fluid', 'Fluid', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top"}'::json, NULL, NULL, FALSE, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
 VALUES ('generic', 'form_featuretype_change', 'tab_none', 'location_type', 'lyt_main_3', 2, 'string', 'combo', 'Location', 'Location', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top"}'::json, NULL, NULL, FALSE, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
 VALUES ('generic', 'form_featuretype_change', 'tab_none', 'category_type', 'lyt_main_3', 3, 'string', 'combo', 'Category', 'Category', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top"}'::json, NULL, NULL, FALSE, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
 VALUES ('generic', 'form_featuretype_change', 'tab_none', 'function_type', 'lyt_main_3', 4, 'string', 'combo', 'Function', 'Function', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top"}'::json, NULL, NULL, FALSE, NULL);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source") VALUES (3324, 'gw_fct_getchangefeaturetype', 'utils', 'function', 'json', 'json', 'Function to get feature type change dialog', 'role_edit', NULL, 'core');

--17/09/2024
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json
	WHERE formname='arc' AND formtype='form_feature' AND columnname='btn_doc_insert' AND tabname='tab_documents';
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json
	WHERE formname='node' AND formtype='form_feature' AND columnname='btn_doc_insert' AND tabname='tab_documents';
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json
	WHERE formname='connec' AND formtype='form_feature' AND columnname='btn_doc_insert' AND tabname='tab_documents';
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json
	WHERE formname='arc' AND formtype='form_feature' AND columnname='btn_doc_new' AND tabname='tab_documents';
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json
	WHERE formname='node' AND formtype='form_feature' AND columnname='btn_doc_new' AND tabname='tab_documents';
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json
	WHERE formname='connec' AND formtype='form_feature' AND columnname='btn_doc_new' AND tabname='tab_documents';

UPDATE config_form_fields
	SET columnname='doc_name'
	WHERE formname='arc' AND formtype='form_feature' AND columnname='doc_id' AND tabname='tab_documents';
UPDATE config_form_fields
	SET columnname='doc_name'
	WHERE formname='node' AND formtype='form_feature' AND columnname='doc_id' AND tabname='tab_documents';
UPDATE config_form_fields
	SET columnname='doc_name'
	WHERE formname='connec' AND formtype='form_feature' AND columnname='doc_id' AND tabname='tab_documents';

UPDATE config_form_fields
	SET dv_querytext='SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL'
	WHERE formname='arc' AND formtype='form_feature' AND columnname='doc_name' AND tabname='tab_documents';
UPDATE config_form_fields
	SET dv_querytext='SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL'
	WHERE formname='node' AND formtype='form_feature' AND columnname='doc_name' AND tabname='tab_documents';
UPDATE config_form_fields
	SET dv_querytext='SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL'
	WHERE formname='connec' AND formtype='form_feature' AND columnname='doc_name' AND tabname='tab_documents';

-- 2024/09/18
UPDATE config_param_system SET isenabled=true where parameter = 'basic_selector_tab_municipality';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source") VALUES(3268, 'You can not insert text values into an integer column.', 'Please select the postcomplement column.', 1, true, 'utils', NULL);

-- 2024/09/21
INSERT INTO config_param_system VALUES
('epa_autorepair','TRUE','Force when export go2epa to autorepair inp columns','Autorepair epa:','','',TRUE,null,'utils',null,null,'boolean','text');

UPDATE config_toolbox SET inputparams =
'[{"widgetname":"nodeType", "label":"NodeType(s):","placeholder":"''T'',''TANK''", "tooltip": "Concat values of node type with '',''. Null values will execute all defined node types", "widgettype":"text","datatype":"text","value":"","layoutname":"grl_option_parameters","layoutorder":1}]'
WHERE id = 3280;

-- 2024/09/23
UPDATE config_form_fields
	SET widgetcontrols=NULL
	WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='fluid_type' AND tabname='tab_none';
UPDATE config_form_fields
	SET widgetcontrols=NULL
	WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='location_type' AND tabname='tab_none';
UPDATE config_form_fields
	SET widgetcontrols=NULL
	WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='category_type' AND tabname='tab_none';
UPDATE config_form_fields
	SET widgetcontrols=NULL
	WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='function_type' AND tabname='tab_none';
UPDATE config_form_fields
	SET layoutorder=2
	WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='feature_type_new' AND tabname='tab_none';
UPDATE config_form_fields
	SET layoutorder=2
	WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='btn_catalog' AND tabname='tab_none';
UPDATE config_form_fields
	SET layoutorder=3
	WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='btn_catalog' AND tabname='tab_none';


UPDATE config_typevalue
	SET addparam='{
  "lytOrientation": "horizontal"
}'::json
	WHERE typevalue='layout_name_typevalue' AND id='lyt_buttons';
UPDATE config_typevalue
	SET addparam='{
  "lytOrientation": "horizontal"
}'::json
	WHERE typevalue='layout_name_typevalue' AND id='lyt_main_2';
