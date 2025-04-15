/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

DELETE FROM sys_table WHERE id IN ('vp_basic_arc', 'vp_basic_node', 'vp_basic_connec', 'vp_basic_gully');

UPDATE config_info_layer SET is_parent=false, tableparent_id=NULL WHERE layer_id='v_edit_node';
UPDATE config_info_layer SET is_parent=false, tableparent_id=NULL WHERE layer_id='v_edit_connec';
UPDATE config_info_layer SET is_parent=false, tableparent_id=NULL WHERE layer_id='v_edit_arc';

INSERT INTO sys_feature_class (id, "type", epa_default, man_table) VALUES('SERVCONNECTION', 'LINK', 'UNDEFINED', 'man_servconnection');


DELETE FROM sys_feature_class WHERE id = 'ELEMENT' AND type = 'ELEMENT';
INSERT INTO sys_feature_class (id, "type", epa_default, man_table) VALUES('FLWREG', 'ELEMENT', 'UNDEFINED', 'man_flwreg');
INSERT INTO sys_feature_class (id, "type", epa_default, man_table) VALUES('GENELEMENT', 'ELEMENT', 'UNDEFINED', 'man_genelement');


DELETE FROM cat_feature WHERE id = 'LINK';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source") VALUES(3286, 'arc_id column cannot be modified when state = 0 on plan_psector %psector_id%.', '', 2, true, 'utils', 'core');

INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('PUMP', 'ELEMENT', 'inp_flwreg_pump', NULL, true);

INSERT INTO config_typevalue (typevalue, id, camelstyle, idval, addparam) VALUES('sys_table_context', '{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"ELEMENT"}', NULL, NULL, '{"orderBy":89}'::json);


INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer, active) VALUES ('FRPUMP', 'FLWREG', 'ELEMENT', 'v_edit_element', 've_elem_frpump', true) ON CONFLICT (id) DO NOTHING;

INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer)
SELECT upper(REPLACE(id, ' ', '_')), 'GENELEMENT', 'ELEMENT', 'v_edit_element', concat('ve_elem_', lower(REPLACE(id, ' ', '_'))) FROM element_type ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3388, 'gw_fct_admin_dynamic_trigger', 'utils', 'function', 'json', 'json', 'Function to insert or update columns dynamically through triggers', 'role_admin', NULL, 'core');

UPDATE config_report SET query_text='SELECT e.name as "Exploitation", vec.connec_id, vec.code, vec.customer_code FROM v_edit_connec vec JOIN exploitation e USING (expl_id) ' WHERE id=101;

-- 10/04/25
ALTER TABLE config_info_layer DROP COLUMN tableparent_id;

UPDATE config_info_layer SET is_parent=true WHERE layer_id='v_edit_node';
UPDATE config_info_layer SET is_parent=true WHERE layer_id='v_edit_connec';
UPDATE config_info_layer SET is_parent=true WHERE layer_id='v_edit_arc';

INSERT INTO config_info_layer (layer_id, is_parent, is_editable, formtemplate, headertext, orderby) 
VALUES('v_edit_flwreg', true, true, 'info_generic', 'Flow regulator', 4);


-- config typevalue
update config_typevalue set addparam ='{"orderBy":10}' where id ='{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"POLYGON"}';
update config_typevalue set addparam ='{"orderBy":51}' where id ='{"level_1":"INVENTORY","level_2":"AUXILIAR"}';

-- sys table
delete from sys_table WHERE id = 'v_edit_flwreg';
insert into sys_table values ('v_edit_flwreg', 'Specific view for flowregulator elements', 'role_basic', null, 
'{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"ELEMENT"}', 2, 'Flowregulators', null, null, null, 'core'); 

update sys_table set context ='{"level_1":"INVENTORY","level_2":"OTHER"}' , orderby = 1 where id = 'v_edit_dimensions';

insert into sys_table values ('v_edit_cat_feature_element', 'Catalog for elements', 'role_edit', null, 
'{"level_1":"INVENTORY","level_2":"CATALOGS"}', 7, 'Element feature catalog', null, null, null, 'core');

UPDATE config_info_layer SET is_parent = true, formtemplate = 'info_feature' WHERE layer_id = 'v_edit_flwreg';
UPDATE config_info_layer SET is_parent = true, formtemplate = 'info_feature' WHERE layer_id = 'v_edit_link';
UPDATE config_info_layer SET is_parent = true, formtemplate = 'info_feature' WHERE layer_id = 'v_edit_element';

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
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_documents', 'doc_type', 'lyt_document_1', 3, 'string', 'combo', 'Doc type:', NULL, NULL, false, false, true, false, true, 'SELECT id as id, id as idval FROM doc_type WHERE id IS NOT NULL ', NULL, true, NULL, NULL, NULL, '{"labelPosition": "top"}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_doc_x_link', false, 3);
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
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_link_servconnection', 'form_feature', 'tab_documents', 'doc_type', 'lyt_document_1', 3, 'string', 'combo', 'Doc type:', NULL, NULL, false, false, true, false, true, 'SELECT id as id, id as idval FROM doc_type WHERE id IS NOT NULL ', NULL, true, NULL, NULL, NULL, '{"labelPosition": "top"}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_doc_x_link', false, 3);
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
