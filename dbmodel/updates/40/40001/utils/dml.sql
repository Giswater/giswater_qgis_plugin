/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

DELETE FROM sys_table WHERE id IN ('vp_basic_arc', 'vp_basic_node', 'vp_basic_connec', 'vp_basic_gully');

UPDATE config_info_layer SET is_parent=false, tableparent_id=NULL WHERE layer_id='v_edit_node';
UPDATE config_info_layer SET is_parent=false, tableparent_id=NULL WHERE layer_id='v_edit_connec';
UPDATE config_info_layer SET is_parent=false, tableparent_id=NULL WHERE layer_id='v_edit_arc';

INSERT INTO sys_feature_class (id, "type", epa_default, man_table) VALUES('SERVCONNECTION', 'LINK', 'UNDEFINED', 'man_servconnection');


DELETE FROM sys_feature_class WHERE id = 'ELEMENT' AND type = 'ELEMENT';
INSERT INTO sys_feature_class (id, "type", epa_default, man_table) VALUES('FRELEM', 'ELEMENT', 'UNDEFINED', 'man_frelem');
INSERT INTO sys_feature_class (id, "type", epa_default, man_table) VALUES('GENELEM', 'ELEMENT', 'UNDEFINED', 'man_genelem');


DELETE FROM cat_feature WHERE id = 'LINK';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source") VALUES(3286, 'arc_id column cannot be modified when state = 0 on plan_psector %psector_id%.', '', 2, true, 'utils', 'core');

INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('FRPUMP', 'ELEMENT', 'inp_frpump', NULL, true);

INSERT INTO config_typevalue (typevalue, id, camelstyle, idval, addparam) VALUES('sys_table_context', '{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"ELEMENT"}', NULL, NULL, '{"orderBy":89}'::json);


INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3388, 'gw_fct_admin_dynamic_trigger', 'utils', 'function', 'json', 'json', 'Function to insert or update columns dynamically through triggers', 'role_admin', NULL, 'core');

UPDATE config_report SET query_text='SELECT e.name as "Exploitation", vec.connec_id, vec.code, vec.customer_code FROM v_edit_connec vec JOIN exploitation e USING (expl_id) ' WHERE id=101;

-- 10/04/25
ALTER TABLE config_info_layer DROP COLUMN tableparent_id;

UPDATE config_info_layer SET is_parent=true WHERE layer_id='v_edit_node';
UPDATE config_info_layer SET is_parent=true WHERE layer_id='v_edit_connec';
UPDATE config_info_layer SET is_parent=true WHERE layer_id='v_edit_arc';

INSERT INTO config_info_layer (layer_id, is_parent, is_editable, formtemplate, headertext, orderby)
VALUES('ve_frelem', true, true, 'info_feature', 'Flow regulator element', 4);

INSERT INTO config_info_layer (layer_id, is_parent, is_editable, formtemplate, headertext, orderby)
VALUES('ve_genelem', true, true, 'info_feature', 'Generic element', 4);

DELETE FROM config_info_layer WHERE layer_id IN ('v_edit_flwreg', 'v_edit_element');


-- config typevalue
update config_typevalue set addparam ='{"orderBy":10}' where id ='{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"POLYGON"}';
update config_typevalue set addparam ='{"orderBy":51}' where id ='{"level_1":"INVENTORY","level_2":"AUXILIAR"}';

-- sys table
DELETE FROM sys_table WHERE id = 'v_edit_flwreg';
INSERT INTO sys_table (id, descript, sys_role, context, "source") VALUES('ve_frelem', 'Specific view for flowregulator elements', 'role_basic', '{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"ELEMENT"}', 'core');

UPDATE sys_table SET context ='{"level_1":"INVENTORY","level_2":"OTHER"}' , orderby = 1 WHERE id = 'v_edit_dimensions';

INSERT INTO sys_table (id, descript, sys_role, context, "source") VALUES('v_edit_cat_feature_element', 'Catalog for elements', 'role_edit', '{"level_1":"INVENTORY","level_2":"CATALOGS"}', 'core');

UPDATE config_info_layer SET is_parent = true, formtemplate = 'info_feature' WHERE layer_id = 'v_edit_link';

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_link', 'tab_elements', 'Elements', 'List of related elements', 'role_basic', NULL, '[{"actionName":"actionEdit", "disabled":false},
{"actionName":"actionZoom", "disabled":false},
{"actionName":"actionCentered", "disabled":false},
{"actionName":"actionZoomOut", "disabled":false},
{"actionName":"actionCatalog", "disabled":false},
{"actionName":"actionWorkcat", "disabled":false},
{"actionName":"actionCopyPaste","disabled":false},
{"actionName":"actionSection", "disabled":false},
{"actionName":"actionGetParentId", "disabled":false},
{"actionName":"actionLink",  "disabled":false}]'::json, 1, '{4,5}');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_documents', 'tbl_documents', 'lyt_document_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}'::json, 'tbl_doc_x_link', false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_documents', 'open_doc', 'lyt_document_2', 11, NULL, 'button', NULL, 'Open document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"147"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_documents', 'btn_doc_new', 'lyt_document_2', 4, NULL, 'button', NULL, 'New document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"143"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_documents', 'btn_doc_delete', 'lyt_document_2', 3, NULL, 'button', NULL, 'Delete document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}'::json, '{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_documents', 'hspacer_document_1', 'lyt_document_2', 10, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_documents', 'doc_name', 'lyt_document_2', 0, 'string', 'typeahead', 'Doc id:', NULL, NULL, false, false, true, false, false, 'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table"}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_documents', 'doc_type', 'lyt_document_1', 3, 'string', 'combo', 'Doc type:', NULL, NULL, false, false, true, false, true, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''doc_type''', NULL, true, NULL, NULL, NULL, '{"labelPosition": "top"}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_doc_x_link', false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_documents', 'date_from', 'lyt_document_1', 1, 'date', 'datetime', 'Date from:', NULL, NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":">="}'::json, '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json, 'tbl_doc_x_link', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_documents', 'date_to', 'lyt_document_1', 2, 'date', 'datetime', 'Date to:', NULL, NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":"<="}'::json, '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json, 'tbl_doc_x_link', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_documents', 'btn_doc_insert', 'lyt_document_2', 2, NULL, 'button', NULL, 'Insert document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_elements', 'hspacer_lyt_element', 'lyt_element_1', 10, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_elements', 'element_id', 'lyt_element_1', 1, 'string', 'typeahead', 'Element id:', 'Element id', NULL, false, false, true, false, false, 'SELECT element_id as id, element_id as idval FROM element WHERE element_id IS NOT NULL ', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table", "parameters" : { "columnfind": "id"}}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_elements', 'delete_element', 'lyt_element_1', 4, NULL, 'button', NULL, 'Delete element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete element"}'::json, '{ "functionName": "delete_object", "parameters": {"columnfind": "element_id", "targetwidget": "tab_elements_tbl_elements", "sourceview": "element"}}'::json, 'tbl_element_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_elements', 'insert_element', 'lyt_element_1', 3, NULL, 'button', NULL, 'Insert element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
	  "functionName": "add_object",
	  "parameters": {
	    "sourcewidget": "tab_elements_element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_elements', 'new_element', 'lyt_element_1', 5, NULL, 'button', NULL, 'New element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"143"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
	  "functionName": "manage_element",
	  "module": "info",
	  "parameters": {
	    "sourcewidget": "tab_elements_element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_elements', 'open_element', 'lyt_element_1', 11, NULL, 'button', NULL, 'Open element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"144"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open element"}'::json, '{
	  "functionName": "open_selected_element",
	  "module": "info",
	  "parameters": {
	    "columnfind": "element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_elements', 'btn_link', 'lyt_element_1', 12, NULL, 'button', NULL, 'Open link', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"173"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open link"}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_elements_tbl_elements",
    "columnfind": "link_id"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_elements', 'tbl_elements', 'lyt_element_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{"functionName": "open_selected_element", "module": "info", "parameters":{"columnfind":"element_id"}}'::json, 'tbl_element_x_link', false, 1);


INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'dqa_id', 'lyt_data_1', 11, 'integer', 'text', 'dqa_id', 'dqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'dqa_name', 'lyt_data_1', 20, 'string', 'text', 'dqa_name', 'dqa_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'fluid_type', 'lyt_data_1', 15, 'string', 'text', 'fluid_type', 'fluid_type', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'macrodqa_id', 'lyt_data_1', 24, 'integer', 'text', 'macrodqa_id', 'macrodqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'minsector_id', 'lyt_data_1', 12, 'integer', 'text', 'minsector_id', 'minsector_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'epa_type', 'lyt_data_1', 26, 'string', 'text', 'epa_type', '', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'is_operative', 'lyt_data_1', 27, 'boolean', 'check', 'is_operative', '', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_1', 32, 'date', 'datetime', 'Builtdate:', 'builtdate - Date the element was added. In insertion of new elements the date of the day is shown', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'exit_id', 'lyt_data_1', 5, 'string', 'text', 'Exit ID', 'Exit ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'exit_type', 'lyt_data_1', 4, 'string', 'combo', 'Exit type', 'Exit type', NULL, false, false, false, false, NULL, 'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_pjoint_type''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'expl_id', 'lyt_data_1', 7, 'integer', 'combo', 'Explotation ID', 'Explotation ID', NULL, false, false, false, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'feature_id', 'lyt_data_1', 3, 'string', 'text', 'Feature ID', 'Feature ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'feature_type', 'lyt_data_1', 2, 'string', 'combo', 'Feature type', 'Feature type', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM sys_feature_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'link_id', 'lyt_data_1', 1, 'integer', 'text', 'Link ID', 'Link ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'presszone_id', 'lyt_data_1', 10, 'integer', 'text', 'presszone_id', 'presszone_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'sector_id', 'lyt_data_1', 8, 'integer', 'combo', 'Sector ID', 'sector_id  - Sector identifier.', NULL, false, false, false, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'state', 'lyt_data_1', 6, 'integer', 'combo', 'State:', 'State:', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'uncertain', 'lyt_data_1', 34, 'boolean', 'check', 'Uncertain', 'Uncertain', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'conneccat_id', 'lyt_data_1', 29, 'string', 'typeahead', 'Connecat ID', 'connecat_id - A seleccionar del catálogo de acometida. Es independiente del tipo de acometida', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL AND active IS TRUE ', true, NULL, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "cat_connec", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}'::json, NULL, 'action_catalog', false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 33, 'date', 'datetime', 'Enddate', 'enddate - End date of the element. It will only be filled in if the element is in a deregistration state.', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'gis_length', 'lyt_data_1', 16, 'double', 'text', 'Gis length', 'Gis length', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'macrosector_id', 'lyt_data_1', 22, 'integer', 'combo', 'Macrosector id', 'Macrosector id', NULL, false, false, false, false, NULL, 'SELECT macrosector_id as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_none', 'n_hydrometer', 'lyt_data_1', 35, 'integer', 'text', 'N_hydrometer', 'N_hydrometer', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'presszone_name', 'lyt_data_1', 21, 'string', 'text', 'presszone_name', 'presszone_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'sector_name', 'lyt_data_1', 18, 'string', 'text', 'sector_name', 'sector_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_1', 30, 'string', 'typeahead', 'Workcat ID', 'workcat_id - Related to the catalog of work files (cat_work). File that registers the element', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_link', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_1', 31, 'string', 'typeahead', 'Workcat ID end', 'workcat_id_end - ID of the  end of construction work.', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);



INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'dqa_id', 'lyt_data_1', 11, 'integer', 'text', 'dqa_id', 'dqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'dqa_name', 'lyt_data_1', 20, 'string', 'text', 'dqa_name', 'dqa_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'fluid_type', 'lyt_data_1', 15, 'string', 'text', 'fluid_type', 'fluid_type', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'macrodqa_id', 'lyt_data_1', 24, 'integer', 'text', 'macrodqa_id', 'macrodqa_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'minsector_id', 'lyt_data_1', 12, 'integer', 'text', 'minsector_id', 'minsector_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'epa_type', 'lyt_data_1', 26, 'string', 'text', 'epa_type', '', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'is_operative', 'lyt_data_1', 27, 'boolean', 'check', 'is_operative', '', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'builtdate', 'lyt_data_1', 32, 'date', 'datetime', 'Builtdate:', 'builtdate - Date the element was added. In insertion of new elements the date of the day is shown', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'exit_id', 'lyt_data_1', 5, 'string', 'text', 'Exit ID', 'Exit ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'exit_type', 'lyt_data_1', 4, 'string', 'combo', 'Exit type', 'Exit type', NULL, false, false, false, false, NULL, 'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_pjoint_type''', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'expl_id', 'lyt_data_1', 7, 'integer', 'combo', 'Explotation ID', 'Explotation ID', NULL, false, false, false, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'feature_id', 'lyt_data_1', 3, 'string', 'text', 'Feature ID', 'Feature ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'feature_type', 'lyt_data_1', 2, 'string', 'combo', 'Feature type', 'Feature type', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM sys_feature_type WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'link_id', 'lyt_data_1', 1, 'integer', 'text', 'Link ID', 'Link ID', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'presszone_id', 'lyt_data_1', 10, 'integer', 'text', 'presszone_id', 'presszone_id', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'sector_id', 'lyt_data_1', 8, 'integer', 'combo', 'Sector ID', 'sector_id  - Sector identifier.', NULL, false, false, false, false, NULL, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'state', 'lyt_data_1', 6, 'integer', 'combo', 'State:', 'State:', NULL, false, false, true, false, NULL, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'uncertain', 'lyt_data_1', 34, 'boolean', 'check', 'Uncertain', 'Uncertain', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'conneccat_id', 'lyt_data_1', 29, 'string', 'typeahead', 'Connecat ID', 'connecat_id - A seleccionar del catálogo de acometida. Es independiente del tipo de acometida', NULL, false, false, false, false, NULL, 'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL AND active IS TRUE ', true, NULL, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "cat_connec", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}'::json, NULL, 'action_catalog', false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'enddate', 'lyt_data_1', 33, 'date', 'datetime', 'Enddate', 'enddate - End date of the element. It will only be filled in if the element is in a deregistration state.', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'gis_length', 'lyt_data_1', 16, 'double', 'text', 'Gis length', 'Gis length', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'macrosector_id', 'lyt_data_1', 22, 'integer', 'combo', 'Macrosector id', 'Macrosector id', NULL, false, false, false, false, NULL, 'SELECT macrosector_id as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_none', 'n_hydrometer', 'lyt_data_1', 35, 'integer', 'text', 'N_hydrometer', 'N_hydrometer', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'presszone_name', 'lyt_data_1', 21, 'string', 'text', 'presszone_name', 'presszone_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'sector_name', 'lyt_data_1', 18, 'string', 'text', 'sector_name', 'sector_name', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, true, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'workcat_id', 'lyt_data_1', 30, 'string', 'typeahead', 'Workcat ID', 'workcat_id - Related to the catalog of work files (cat_work). File that registers the element', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'action_workcat', false, NULL);
INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_servconnection', 'form_feature', 'tab_data', 'workcat_id_end', 'lyt_data_1', 31, 'string', 'typeahead', 'Workcat ID end', 'workcat_id_end - ID of the  end of construction work.', NULL, false, false, true, false, NULL, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('ve_link_servconnection', 'tab_elements', 'Elements', 'List of related elements', 'role_basic', NULL, '[{"actionName":"actionEdit", "disabled":false},
{"actionName":"actionZoom", "disabled":false},
{"actionName":"actionCentered", "disabled":false},
{"actionName":"actionZoomOut", "disabled":false},
{"actionName":"actionCatalog", "disabled":false},
{"actionName":"actionWorkcat", "disabled":false},
{"actionName":"actionCopyPaste","disabled":false},
{"actionName":"actionSection", "disabled":false},
{"actionName":"actionGetParentId", "disabled":false},
{"actionName":"actionLink",  "disabled":false}]'::json, 1, '{4,5}');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_servconnection', 'form_feature', 'tab_documents', 'tbl_documents', 'lyt_document_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}'::json, 'tbl_doc_x_link', false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_servconnection', 'form_feature', 'tab_documents', 'open_doc', 'lyt_document_2', 11, NULL, 'button', NULL, 'Open document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"147"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open document"}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_servconnection', 'form_feature', 'tab_documents', 'btn_doc_new', 'lyt_document_2', 4, NULL, 'button', NULL, 'New document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"143"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_servconnection', 'form_feature', 'tab_documents', 'btn_doc_delete', 'lyt_document_2', 3, NULL, 'button', NULL, 'Delete document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete document"}'::json, '{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_servconnection', 'form_feature', 'tab_documents', 'hspacer_document_1', 'lyt_document_2', 10, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_servconnection', 'form_feature', 'tab_documents', 'doc_name', 'lyt_document_2', 0, 'string', 'typeahead', 'Doc id:', NULL, NULL, false, false, true, false, false, 'SELECT name as id, name as idval FROM doc WHERE name IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table"}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_servconnection', 'form_feature', 'tab_documents', 'doc_type', 'lyt_document_1', 3, 'string', 'combo', 'Doc type:', NULL, NULL, false, false, true, false, true, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''doc_type''', NULL, true, NULL, NULL, NULL, '{"labelPosition": "top"}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_doc_x_link', false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_servconnection', 'form_feature', 'tab_documents', 'date_from', 'lyt_document_1', 1, 'date', 'datetime', 'Date from:', NULL, NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":">="}'::json, '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json, 'tbl_doc_x_link', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_servconnection', 'form_feature', 'tab_documents', 'date_to', 'lyt_document_1', 2, 'date', 'datetime', 'Date to:', NULL, NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":"<="}'::json, '{"functionName": "filter_table", "parameters":{"columnfind": "date"}}'::json, 'tbl_doc_x_link', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_servconnection', 'form_feature', 'tab_documents', 'btn_doc_insert', 'lyt_document_2', 2, NULL, 'button', NULL, 'Insert document', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_name",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json, 'tbl_doc_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_servconnection', 'form_feature', 'tab_elements', 'hspacer_lyt_element', 'lyt_element_1', 10, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_servconnection', 'form_feature', 'tab_elements', 'element_id', 'lyt_element_1', 1, 'string', 'typeahead', 'Element id:', 'Element id', NULL, false, false, true, false, false, 'SELECT element_id as id, element_id as idval FROM element WHERE element_id IS NOT NULL ', NULL, NULL, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"ILIKE"}'::json, '{"functionName": "filter_table", "parameters" : { "columnfind": "id"}}'::json, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_servconnection', 'form_feature', 'tab_elements', 'delete_element', 'lyt_element_1', 4, NULL, 'button', NULL, 'Delete element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"114"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Delete element"}'::json, '{ "functionName": "delete_object", "parameters": {"columnfind": "element_id", "targetwidget": "tab_elements_tbl_elements", "sourceview": "element"}}'::json, 'tbl_element_x_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_servconnection', 'form_feature', 'tab_elements', 'insert_element', 'lyt_element_1', 3, NULL, 'button', NULL, 'Insert element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"113"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
	  "functionName": "add_object",
	  "parameters": {
	    "sourcewidget": "tab_elements_element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_servconnection', 'form_feature', 'tab_elements', 'new_element', 'lyt_element_1', 5, NULL, 'button', NULL, 'New element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"143"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{
	  "functionName": "manage_element",
	  "module": "info",
	  "parameters": {
	    "sourcewidget": "tab_elements_element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_servconnection', 'form_feature', 'tab_elements', 'open_element', 'lyt_element_1', 11, NULL, 'button', NULL, 'Open element', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"144"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open element"}'::json, '{
	  "functionName": "open_selected_element",
	  "module": "info",
	  "parameters": {
	    "columnfind": "element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_servconnection', 'form_feature', 'tab_elements', 'btn_link', 'lyt_element_1', 12, NULL, 'button', NULL, 'Open link', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"173"}'::json, '{"saveValue":false, "filterSign":"=", "onContextMenu":"Open link"}'::json, '{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_elements_tbl_elements",
    "columnfind": "link_id"
  }
}'::json, 'v_edit_link', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_servconnection', 'form_feature', 'tab_elements', 'tbl_elements', 'lyt_element_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{"functionName": "open_selected_element", "module": "info", "parameters":{"columnfind":"element_id"}}'::json, 'tbl_element_x_link', false, 1);

DELETE FROM config_form_fields
WHERE formname = 'v_edit_link_connec';

DELETE FROM config_form_fields
WHERE formname = 'v_edit_link_gully';

UPDATE config_info_layer
SET is_parent = true
WHERE layer_id = 'v_edit_link';

-- 15/04/2025

DELETE FROM config_param_system WHERE "parameter"='admin_customform_param';

-- 17/04/2025
UPDATE sys_param_user
SET dv_querytext = 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''doc_type'' AND id IS NOT NULL'
WHERE id = 'edit_doctype_vdefault';

-- 22/04/2025

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam)
VALUES('tbl_doc_x_element', 'SELECT * FROM v_ui_doc_x_element WHERE element_id IS NOT NULL', 4, 'tab', 'list', NULL, NULL);

-- 23/04/2025
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','link_id',0,false,'link_id');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','element_id',1,true,'element_id');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','elementcat_id',2,true,'elementcat_id');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','num_elements',3,true,'num_elements');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','feature_class',4,true,'feature_class');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','element_type',5,true,'element_type');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','state',6,true,'state');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','state_type',7,true,'state_type');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','observ',8,true,'observ');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','comment',9,true,'comment');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','builtdate',10,true,'builtdate');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','enddate',11,true,'enddate');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','link',12,true,'link');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','publish',13,true,'publish');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','inventory',14,true,'inventory');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','descript',15,true,'descript');
INSERT INTO config_form_tableview (location_type,project_type,objectname,columnname,columnindex,visible,alias)
	VALUES ('link form','utils','tbl_element_x_link','location_type',16,true,'location_type');

-- 25/04/2025
INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('message_type','UI','UI');
INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('message_type','AUDIT','AUDIT');
INSERT INTO edit_typevalue(typevalue, id, idval) VALUES('message_type','DEBUG','DEBUG');

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field) VALUES ('edit_typevalue','message_type','sys_message','message_type');

-- new messages for audit porpouses:
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(1001, '--------', 'Audit separator', 0, true, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(1003, '------------------------------', 'Audit separator', 0, true, 'generic', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(1005, 'ERRORS', 'Audit separator', 3, true, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(1007, 'WARNINGS', 'Audit separator', 2, true, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(1009, 'INFO', 'Audit separator', 1, true, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, log_level, project_type, source, message_type) VALUES (1101, 'INFO: Deactivated node proximity check.', 0, 'UD', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, log_level, project_type, source, message_type) VALUES (1103, 'CONNECT TO NETWORK', 0, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, log_level, project_type, source, message_type) VALUES (1105, '-------------------------------------------------------------', 0, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, log_level, project_type, source, message_type) VALUES (1107, 'Trying to connect %feature_type% with id %connect_id% to an arc with a diameter smaller than %check_arcdnom% and at maximum distance of %max_distance% meters.', 0, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, log_level, project_type, source, message_type) VALUES (1109, 'Trying to connect %feature_type% with id %connect_id% to an arc at maximum ditance of %max_distance% meters.', 0, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, log_level, project_type, source, message_type) VALUES (1111, 'Trying to connect %feature_type% with id %connect_id%.', 0, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, log_level, project_type, source, message_type) VALUES (1113, 'FAILED: Link not created because connect %connect__id% is over arc %arc_id%', 0, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, log_level, project_type, source, message_type) VALUES (1115, 'Create new link connected to the closest arc with the appropriate conditions.', 0, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, log_level, project_type, source, message_type) VALUES (1117, 'Create new link connected to the selected arc: %arc_id%.', 0, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, log_level, project_type, source, message_type) VALUES (1119, 'Create new link connected to the closest arc.', 0, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, log_level, project_type, source, message_type) VALUES (1121, 'Creating new link by using geometry of existing one.', 0, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, log_level, project_type, source, message_type) VALUES (1123, 'Reverse the direction of drawn link.', 0, 'generic', 'core', 'AUDIT');

-- 30/04/2025
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('v_edit_plan_psector','form_feature','tab_none','creation_date','date','datetime','Creation Date:','Creation Date',false,false,true,false,'{"setMultiline":false}'::json,false);

INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,hidden,web_layoutorder)
	VALUES ('generic','psector','tab_general','creation_date','lyt_general_7',1,'date','datetime','Creation date:','Creation date:',false,false,true,false,false,'{"setMultiline":false}'::json,false,3);

-- 06/05/2025
UPDATE config_form_fields SET label = 'sys_ymax' WHERE columnname = 'sys_ymax';

-- 06/05/2025
DELETE FROM config_param_system WHERE "parameter"='basic_search_network_element';
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('basic_search_network_frelem', '{"sys_table_id":"ve_frelem","sys_id_field":"element_id","sys_search_field":"element_id","alias":"Flow regulator element","cat_field":"elementcat_id","orderby":"5","search_type":"element"}', 'Search configuration parameteres', 'Search flow regulator element:', NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('basic_search_network_genelem', '{"sys_table_id":"ve_genelem","sys_id_field":"element_id","sys_search_field":"element_id","alias":"General element","cat_field":"elementcat_id","orderby":"5","search_type":"element"}', 'Search configuration parameteres', 'Search general element:', NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active)
VALUES(638, 'Arc which id is not an integer', 'utils', NULL, 'core', true, 'Check om-data', NULL, 3, 'arc which id is not an integer. Please, check your data before continue', NULL, NULL, 'SELECT CASE WHEN arc_id~E''^\\d+$'' THEN CAST (arc_id AS INTEGER)  ELSE 0 END  as feature_id, ''ARC'' as type, arccat_id, expl_id FROM t_arc', 'All arcs features with id integer.', '[gw_fct_om_check_data, gw_fct_admin_check_data]', true);

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active)
VALUES(640, 'Node which id is not an integer', 'utils', NULL, 'core', true, 'Check om-data', NULL, 3, 'node which id is not an integer. Please, check your data before continue', NULL, NULL, 'SELECT CASE WHEN node_id~E''^\\d+$'' THEN CAST (node_id AS INTEGER)  ELSE 0 END  as feature_id, ''NODE'' as type, nodecat_id, expl_id FROM t_node', 'All nodes features with id integer.', '[gw_fct_om_check_data, gw_fct_admin_check_data]', true);

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active)
VALUES(642, 'Connec which id is not an integer', 'utils', NULL, 'core', true, 'Check om-data', NULL, 3, 'connec which id is not an integer. Please, check your data before continue', NULL, NULL, 'SELECT CASE WHEN connec_id~E''^\\d+$'' THEN CAST (connec_id AS INTEGER)  ELSE 0 END  as feature_id, ''CONNEC'' as type, conneccat_id, expl_id FROM t_connec', 'All connecs features with id integer.', '[gw_fct_om_check_data, gw_fct_admin_check_data]', true);

DELETE FROM sys_fprocess WHERE fid IN (202, 542);

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('sys_label', 'Specific table to keep labels indexed and ready to translate', 'role_admin', 'core');

INSERT INTO sys_label VALUES (1001, 'INFO');
INSERT INTO sys_label VALUES (1002, 'WARNING');
INSERT INTO sys_label VALUES (1003, 'ERROR');

-- 08/05/2025
UPDATE config_form_tableview SET columnindex=0 WHERE objectname='tbl_relations' AND columnname='rid';
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('arc form', 'utils', 'tbl_relations', 'sys_table_id', 12, true, NULL, 'sys_table_id', NULL, NULL);


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip,
    ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, hidden, dv_querytext)
VALUES
('v_edit_link', 'form_feature', 'tab_data', 'location_type', 'lyt_data_1', 43, 'string', 'combo', 'Location Type', 'Location Type', false, false, true, false, '{"setMultiline":false}'::json, false, 'SELECT location_type as id, location_type as idval FROM man_type_location WHERE ((featurecat_id is null AND feature_type=''LINK'') ) AND active IS TRUE'),
('v_edit_link', 'form_feature', 'tab_data', 'annotation', 'lyt_data_1', 43, 'string', 'text', 'Annotation', 'Annotation', false, false, true, false, '{"setMultiline":false}'::json, false, NULL),
('v_edit_link', 'form_feature', 'tab_data', 'observ', 'lyt_data_1', 44, 'string', 'text', 'Observ', 'Observ', false, false, true, false, '{"setMultiline":false}'::json, false, NULL),
('v_edit_link', 'form_feature', 'tab_data', 'comment', 'lyt_data_1', 45, 'string', 'text', 'Comment', 'Comment', false, false, true, false, '{"setMultiline":false}'::json, false, NULL),
('v_edit_link', 'form_feature', 'tab_data', 'descript', 'lyt_data_1', 46, 'string', 'text', 'Descript', 'Descript', false, false, true, false, '{"setMultiline":false}'::json, false, NULL),
('v_edit_link', 'form_feature', 'tab_data', 'link', 'lyt_data_1', 47, 'string', 'hyperlink', 'Link', 'Link', false, false, true, false, '{"setMultiline":false}'::json, false, NULL),
('v_edit_link', 'form_feature', 'tab_data', 'num_value', 'lyt_data_1', 48, 'double', 'text', 'Num Value', 'Num Value', false, false, true, false, '{"setMultiline":false}'::json, false, NULL);

UPDATE sys_param_user SET widgettype='text' WHERE id='qgis_composers_folderpath';

-- 09/05/2025
UPDATE config_form_fields SET dv_querytext =  'SELECT id, idval FROM om_typevalue WHERE typevalue = ''fluid_type'''
WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='fluid_type' AND tabname='tab_none';

UPDATE config_form_fields SET dv_querytext =  'SELECT id, location_type AS idval FROM man_type_location WHERE id IS NOT NULL'
WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='location_type' AND tabname='tab_none';

UPDATE config_form_fields SET dv_querytext =  'SELECT id, category_type AS idval FROM man_type_category WHERE id IS NOT NULL'
WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='category_type' AND tabname='tab_none';

UPDATE config_form_fields SET dv_querytext =  'SELECT id, function_type AS idval FROM man_type_function WHERE id IS NOT NULL'
WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='function_type' AND tabname='tab_none';

UPDATE config_form_fields SET dv_querytext =  'SELECT id, id AS idval FROM sys_feature_type WHERE id IS NOT NULL'
WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='feature_type_new' AND tabname='tab_none';

UPDATE config_form_fields SET dv_querytext =  'SELECT id, id AS idval FROM cat_feature'
WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='featurecat_id' AND tabname='tab_none';

UPDATE config_form_fields SET dv_querytext =  'SELECT ARRAY[''composer_plan'', ''composer_mincut''] AS id, ARRAY[''composer_plan'', ''composer_mincut''] AS idval'
WHERE formname='print' AND formtype='form_print' AND columnname='composer' AND tabname='tab_none';

-- 15/05/2025
INSERT INTO node_add (node_id) SELECT node_id FROM node ON CONFLICT (node_id) DO NOTHING;
INSERT INTO arc_add (arc_id) SELECT arc_id FROM arc ON CONFLICT (arc_id) DO NOTHING;

-- 19/05/2025
INSERT INTO sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('v_edit_link', 'Shows editable information about links.', 'role_basic', '{1}', '{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"LINK"}', 1, 'Link (parent)', NULL, NULL, NULL, 'core', NULL);

UPDATE sys_table SET project_template = '{1}' WHERE id IN (
	'v_edit_cat_feature_node',
	'v_edit_cat_feature_arc',
	'v_edit_cat_feature_connec',
	'cat_material',
	'cat_node',
	'cat_arc',
	'cat_connec',
	'v_edit_macrosector',
	'v_edit_exploitation',
	'v_edit_sector',
	'v_edit_node',
	'v_edit_connec',
	'v_edit_arc',
	've_pol_node',
	've_pol_connec',
	'v_edit_dimensions',
	'v_ext_municipality',
	'v_ext_address',
	'v_ext_streetaxis',
	'v_ext_plot'
);
UPDATE sys_label SET label_type = 'prefix';

INSERT INTO sys_label (id, idval, label_type)
VALUES (2030, '------------------------------', 'separator');

UPDATE sys_function SET function_alias = 'CALCULATE THE REACH OF HYDRANTS' WHERE function_name = 'gw_fct_graphanalytics_hydrant';

-- 21/05/2025
UPDATE config_param_system SET value='{"DRAINZONE":{"mode":"Random", "column":"name"},"SECTOR":{"mode":"Random", "column":"name"},"DMA":{"mode":"Random", "column":"name"}, "DWFZONE" :{"mode":"Random", "column":"name"}}'
WHERE "parameter"='utils_graphanalytics_style';

UPDATE config_toolbox SET inputparams='[{"widgetname":"graphClass", "label":"Graph class:", "widgettype":"combo","datatype":"text","tooltip": "Graphanalytics method used", "layoutname":"grl_option_parameters","layoutorder":1,"comboIds":["DWFZONE","MACROSECTOR","SECTOR"],
"comboNames":["Drainage area (DWFZONE + DRAINZONE)","(MACROSECTOR)","(SECTOR)"], "selectedId":""},{"widgetname":"exploitation", "label":"Exploitation:","widgettype":"combo","datatype":"text","tooltip": "Choose exploitation to work with", "layoutname":"grl_option_parameters","layoutorder":2, "dvQueryText":"SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC", "selectedId":""}, {"widgetname":"floodOnlyMapzone", "label":"Flood only one mapzone: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Flood only identified mapzones. The purpose of this is update only network elements affected by this flooding keeping rest of network as is. Recommended to gain performance when mapzones ecosystem is under work", "placeholder":"1001", "layoutname":"grl_option_parameters","layoutorder":3, "value":""}, {"widgetname":"forceOpen", "label":"Force open nodes: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Optative node id(s) to temporary open closed node(s) in order to force algorithm to continue there", "placeholder":"1015,2231,3123", "layoutname":"grl_option_parameters","layoutorder":5, "value":""}, {"widgetname":"forceClosed", "label":"Force closed nodes: (*)","widgettype":"text","datatype":"text", "isMandatory":false, "tooltip":"Optative node id(s) to temporary close open node(s) to force algorithm to stop there","placeholder":"1015,2231,3123", "layoutname":"grl_option_parameters","layoutorder":6,"value":""}, {"widgetname":"usePlanPsector", "label":"Use selected psectors:", "widgettype":"check","datatype":"boolean","tooltip":"If true, use selected psectors. If false ignore selected psectors and only works with on-service network" , "layoutname":"grl_option_parameters","layoutorder":7,"value":""}, {"widgetname":"commitChanges", "label":"Commit changes:", "widgettype":"check","datatype":"boolean","tooltip":"If true, changes will be applied to DB. If false, algorithm results will be saved in anl tables" , "layoutname":"grl_option_parameters","layoutorder":8,"value":""}, {"widgetname":"valueForDisconnected", "label":"Value for disconn. and conflict: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Value to use for disconnected features. Usefull for work in progress with dynamic mpzonesnode" , "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":9, "value":""}, {"widgetname":"updateMapZone", "label":"Mapzone constructor method:","widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":10,"comboIds":[0,1,2,6], "comboNames":["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "EPA SUBCATCH"], "selectedId":""}, {"widgetname":"geomParamUpdate", "label":"Pipe buffer","widgettype":"text","datatype":"float","tooltip":"Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.", "layoutname":"grl_option_parameters","layoutorder":11, "isMandatory":false, "placeholder":"5-30", "value":""}]'::json WHERE id=2768;

-- 22/05/2025
UPDATE sys_function SET function_alias = 'REPLACE FEATURE' WHERE function_name = 'gw_fct_setchangefeaturetype';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3290, '%v_count% operative connec(s) have been reconnected', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3292, '%v_count% planned connec(s) have been reconnected', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3294, '%v_count% operative gully(s) have been reconnected', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3296, '%v_count% planned gully(s) have been reconnected', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3298, '%v_count% operative/planned links(s) have been reconnected', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'REPLACE FEATURE' WHERE function_name = 'gw_fct_setfeaturereplace';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3300, 'Replace node id in %v_count% psector', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3302, 'Downgraded old feature %v_old_id% SETTING state: 0, workcat_id_end: %v_workcat_id_end%, enddate: %v_enddate%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3304, 'Update new feature, set state: 1, workcat_id: %v_workcat_id_end% builtdate: %v_enddate%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3306, 'Common values from old feature have been updated on new feature.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3308, 'New feature %v_id% inserted into connec table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3310, 'New feature %v_id% inserted into gully table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3312, 'Assign old data from %rec_addfields.column_name% addfield to the new feature.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3314, 'Reconnect arc %rec_arc.arc_id%.', null, 0, true, 'utils', 'core', 'AUDIT');

-- 23/05/2025

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3316, 'Reconnect connec %rec_connec.connec_id%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3318, 'New feature %v_id% inserted into arc table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3288, 'Replace feature done successfully', null, 0, true, 'utils', 'core', 'UI');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3322, 'Node_1 is a delimiter of a mapzone if arc was defined as toArc it has been reconfigured with new arc_id.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3320, 'Node_2 is a delimiter of a mapzone if arc was defined as toArc it has been reconfigured with new arc_id.', null, 0, true, 'utils', 'core', 'UI');

UPDATE sys_function SET function_alias = 'MAPZONES CONFIGURATION' WHERE function_name = 'gw_fct_setfeaturesreplace';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3332, 'New node is a delimiter of a different mapzone type than the old node. New mapzone delimiter and old mapzone delimiter needs to be configured.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3334, 'New node is a delimiter of a mapzone that needs to be configured.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3336, 'New node is not a delimiter of a mapzone. Configuration for old node need to be removed.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3338, 'New node and old node are delimiters of the same mapzone. Configuration will be updated.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3340, 'Reconnect arc %rec_arc.arc_id%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3342, 'Reconnect %v_count% links.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3344, 'Assign %v_count% elements to the new feature.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3346, 'New feature (%v_id%) inserted into node table.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'ARC DIVIDE' WHERE function_name = 'gw_fct_setarcdivide';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3348, 'Divide arc %v_arc_id%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3350, 'Insert new arcs into arc table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3352, 'Insert new arcs into man and epa table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3354, 'Copy values from old arc: %v_arc_id% to the new arcs: (%rec_aux1.arc_id%, %rec_aux2.arc_id%).', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3356, 'Update arc_id for disconnected node: %rec_node.node_id%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3358, 'Copy %v_count% elements from old to new arcs.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3360, 'Copy %v_count% documents from old to new arcs.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3362, 'Copy %v_count% visits from old to new arcs.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3364, 'New node is a delimiter of a mapzone that needs to be configured.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3366, 'Node_1 is a delimiter of a mapzone if old arc was defined as toArc it has been reconfigured with new arc_id.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'MAPZONES CONFIGURATION' WHERE function_name = 'gw_fct_setarcdivide';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3368, 'Node_2 is a delimiter of a mapzone if old arc was defined as toArc it has been reconfigured with new arc_id.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3370, 'Set old arc to obsolete: %v_arc_id%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3382, 'Delete old arc: %v_arc_id%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3384, 'Arc with state =1, node with state = 2.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3386, 'Arc and node have both state = 2.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3388, 'Insert new arcs into arc table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3390, 'Insert new arcs into man and epa table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3392, 'Update values of arcs node_1 and node_2.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3394, 'Copy values from old arc: %v_arc_id% to the new arcs: (%rec_aux1.arc_id%, %rec_aux2.arc_id%).', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3396, 'Copy elements is not avaliable from old arc to new arc when node.state = 2', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3398, 'Copy documents is not avaliable from old arc to new arcs when node.state = 2', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3400, 'Copy visits is not avaliable from old arc to new arcs when node.state = 2', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3402, 'Reconnect disconnected nodes on this alternative', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3404, 'Update arc_id for disconnected node: %rec_node.node_id%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3406, 'Update psector''s arc_id value for connec and gully setting null value to force trigger to get new arc_id as closest as possible', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3408, 'Update psector_x_arc as doable for fictitious arcs.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3410, 'Insert old arc as downgraded into current psector: %v_psector%.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3412, 'Set values on plan_psector_x_arc addparam.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3414, 'Arc divide done successfully', null, 0, true, 'utils', 'core', 'UI');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(3416, 'Update values of arcs node_1 and node_2.', null, 0, true, 'utils', 'core', 'AUDIT');





