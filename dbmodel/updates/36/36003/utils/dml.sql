/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_function
(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3248, 'gw_fct_node_interpolate_massive', 'utils', 'function', 'json', 'json', 'Function to interpolate node massively', 'role_admin', NULL, 'core') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess
(fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam)
VALUES(496, 'Massive node interpolation', 'utils', NULL, 'core', true, 'Function process', NULL)
ON CONFLICT (fid) DO NOTHING;

-- 21/06/2023
-- tab_elements
UPDATE config_form_fields
	SET widgetfunction='{
	  "functionName": "delete_object",
	  "parameters": {
	    "columnfind": "feature_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}'::json
	WHERE formtype='form_feature' AND columnname='delete_element' AND tabname='tab_elements';

UPDATE config_form_fields
	SET widgetfunction='{
	  "functionName": "add_object",
	  "parameters": {
	    "sourcewidget": "tab_elements_element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}'::json
	WHERE formtype='form_feature' AND columnname='insert_element' AND tabname='tab_elements';

UPDATE config_form_fields
	SET widgetfunction='{
	  "functionName": "manage_element",
	  "module": "info",
	  "parameters": {
	    "sourcewidget": "tab_elements_element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}'::json
	WHERE formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements';

UPDATE config_form_fields
	SET widgetfunction='{
	  "functionName": "open_selected_element",
	  "module": "info",
	  "parameters": {
	    "columnfind": "element_id",
	    "targetwidget": "tab_elements_tbl_elements",
	    "sourceview": "element"
	  }
	}'::json
	WHERE formtype='form_feature' AND columnname='open_element' AND tabname='tab_elements';

-- tab_documents
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "delete_object",
  "parameters": {
    "columnfind": "feature_id",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json
	WHERE formtype='form_feature' AND columnname='btn_doc_delete' AND tabname='tab_documents';
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "add_object",
  "parameters": {
    "sourcewidget": "tab_documents_doc_id",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json
	WHERE formtype='form_feature' AND columnname='btn_doc_insert' AND tabname='tab_documents';
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "manage_document",
  "parameters": {
    "sourcewidget": "tab_documents_doc_id",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json
	WHERE formtype='form_feature' AND columnname='btn_doc_new' AND tabname='tab_documents';
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "open_selected_path",
  "parameters": {
    "columnfind": "path",
    "targetwidget": "tab_documents_tbl_documents",
    "sourceview": "doc"
  }
}'::json
	WHERE formtype='form_feature' AND columnname='open_doc' AND tabname='tab_documents';
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "open_selected_path",
  "parameters": {
    "targetwidget": "tab_documents_tbl_documents",
    "columnfind": "path"
  }
}'::json
	WHERE formtype='form_feature' AND columnname='tbl_documents' AND tabname='tab_documents';
