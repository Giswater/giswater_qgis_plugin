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

UPDATE config_form_fields SET tabname = 'tab_data' WHERE tabname='data';
UPDATE config_form_fields SET tabname = 'tab_connections' WHERE tabname='connection';

INSERT INTO config_typevalue(typevalue, id, idval, camelstyle, addparam)
VALUES ('tabname_typevalue', 'tab_none', 'tab_none', 'tabNone', NULL) 
ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES ('config_typevalue', 'tabname_typevalue','config_form_fields','tabname', null, true)
ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field, parameter_id) DO NOTHING;


INSERT INTO sys_fprocess
(fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam)
VALUES(497, 'Check orphan documents', 'utils', NULL, 'core', true, 'Function process', NULL)
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess
(fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam)
VALUES(498, 'Check orphan visits', 'utils', NULL, 'core', true, 'Function process', NULL)
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess
(fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam)
VALUES(499, 'Check orphan elements', 'utils', NULL, 'core', true, 'Function process', NULL)
ON CONFLICT (fid) DO NOTHING;

DELETE FROM sys_table WHERE id='config_visit_class_x_feature';

UPDATE sys_function set 
descript = 'Massive repair function. All the arcs that are not connected with extremal node will be reconected using the parameter arc_searchnodes.
Function works only for operative features (state=1).' where function_name = 'gw_fct_arc_repair';


DELETE FROM config_toolbox WHERE id IN (2848); 

UPDATE config_fprocess SET tablename = replace(tablename, 'vi_', 'vi_t_') WHERE fid  =141;

DELETE FROM sys_table WHERE id IN ('v_anl_graphanalytics_mapzones', 'v_anl_graphanalytics_upstream', 'v_anl_graph');

UPDATE config_form_fields SET datatype='datetime' WHERE formtype='form_visit' and widgettype='datetime';

UPDATE sys_fprocess SET fprocess_type='Check om-data' WHERE fid=175;

UPDATE config_toolbox SET inputparams='[
{"widgetname":"name", "label":"Name: (*)","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name for dscenario (mandatory)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":1, "value":""},
{"widgetname":"descript", "label":"Descript:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Descript for dscenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"parent", "label":"Parent:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Parent for dscenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},
{"widgetname":"type", "label":"Type:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"Dscenario type", "dvQueryText":"SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_typevalue_dscenario''", "layoutname":"grl_option_parameters","layoutorder":4, "value":""},
{"widgetname":"active", "label":"Active:", "widgettype":"check", "datatype":"boolean", "tooltip":"If true, active" , "layoutname":"grl_option_parameters","layoutorder":5, "value":"true"},
{"widgetname":"expl", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"Dscenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":6, "value":""}
]'::json WHERE id=3134;

-- 28/07/2023
UPDATE config_typevalue
SET idval='Additional Pump', camelstyle=NULL, addparam=NULL
WHERE typevalue='formactions_typevalue' AND id='actionPump';

UPDATE config_form_fields
SET ismandatory=true WHERE formname='v_edit_inp_dscenario_pump_additional' AND formtype='form_feature' AND columnname='order_id' AND tabname='tab_none';

UPDATE config_form_fields
SET ismandatory=true WHERE formname='v_edit_inp_pump_additional' AND formtype='form_feature' AND columnname='order_id' AND tabname='tab_none';

UPDATE config_form_fields
SET layoutorder=1, hidden=false WHERE formname='v_edit_inp_dscenario_demand' AND formtype='form_feature' AND columnname='feature_id' AND tabname='tab_none';

-- change epa layouts
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam)
VALUES('layout_name_typevalue', 'lyt_epa_dsc_1', 'lyt_epa_dsc_1', 'lytEpaDsc1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam)
VALUES('layout_name_typevalue', 'lyt_epa_dsc_2', 'lyt_epa_dsc_2', 'lytEpaDsc2', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam)
VALUES('layout_name_typevalue', 'lyt_epa_dsc_3', 'lyt_epa_dsc_3', 'lytEpaDsc3', NULL);

UPDATE config_form_fields SET layoutname = 'lyt_epa_dsc_3' WHERE layoutname = 'lyt_epa_3';

DELETE FROM config_typevalue WHERE typevalue='layout_name_typevalue' AND id='lyt_epa_3';

UPDATE config_form_fields SET iseditable = true WHERE layoutname = 'lyt_epa_dsc_1' AND widgettype = 'button';

UPDATE config_form_fields
	SET dv_querytext='SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_typevalue_dscenario'''
	WHERE formname='v_edit_cat_dscenario' AND columnname='dscenario_type';

UPDATE config_form_fields
	SET widgetfunction='{"functionName": "open_visit_files", "module": "info", "parameters":{"targetwidget":"tab_visit_tbl_visits"}}'::json
	WHERE formname IN ('arc', 'node', 'connec', 'gully') AND columnname='open_gallery' AND tabname='tab_visit';
UPDATE config_form_fields
	SET widgetfunction='{"functionName": "open_visit_manager", "parameters":{"columnfind": "visit_id", "targetwidget": "tab_event_tbl_event_cf", "sourceview": "event"}}'::json
	WHERE formname IN ('arc', 'node', 'connec', 'gully') AND columnname='btn_open_visit' AND tabname='tab_event';
UPDATE config_form_fields
	SET widgetfunction='{"functionName": "open_gallery", "module": "info", "parameters":{"targetwidget":"tab_event_tbl_event_cf", "columnfind": ["visit_id", "event_id"], "sourceview":"visit"}}'::json
	WHERE formname IN ('arc', 'node', 'connec', 'gully') AND columnname='btn_open_gallery' AND tabname='tab_event';
UPDATE config_form_fields
	SET widgetfunction='{"functionName": "open_visit_document", "module": "info", "parameters":{"targetwidget": "tab_event_tbl_event_cf", "columnfind": "visit_id"}}'::json
	WHERE formname IN ('arc', 'node', 'connec', 'gully') AND columnname='btn_open_visit_doc' AND tabname='tab_event';
UPDATE config_form_fields
	SET widgetfunction='{"functionName": "open_visit_event", "module": "info", "parameters":{"targetwidget": "tab_event_tbl_event_cf", "columnfind":["visit_id", "event_id"]}}'::json
	WHERE formname IN ('arc', 'node', 'connec', 'gully') AND columnname='btn_open_visit_event' AND tabname='tab_event';

UPDATE config_form_fields
	SET widgetfunction='{ "functionName": "delete_object", "parameters": {"columnfind": "element_id", "targetwidget": "tab_elements_tbl_elements", "sourceview": "element"}}'::json
	WHERE formname IN ('arc', 'node', 'connec', 'gully') AND columnname='delete_element' AND tabname='tab_elements';
UPDATE config_form_fields
	SET widgetfunction='{"functionName": "delete_object", "parameters": {"columnfind": "doc_id", "targetwidget": "tab_documents_tbl_documents", "sourceview": "doc"}}'::json
	WHERE formname IN ('arc', 'node', 'connec', 'gully') AND columnname='btn_doc_delete' AND tabname='tab_documents';
