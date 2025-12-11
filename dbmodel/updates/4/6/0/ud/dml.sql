/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_fprocess (fid,fprocess_name,project_type,"source",isaudit,fprocess_type,active)
VALUES (640,'Dynamic omunit analysis','ud','core',true,'Function process',true);

INSERT INTO sys_param_user (id,formname,descript,sys_role,"label",isenabled,layoutorder,project_type,isparent,isautoupdate,"datatype",widgettype,ismandatory,layoutname,iseditable,"source")
VALUES ('plan_psector_auto_insert_connec','config','Automatic insertion of connected connecs/gullies when inserting an arc','role_plan','Automatic connec/gully insertion:',true,12,'utils',false,false,'boolean','check',false,'lyt_masterplan',true,'core');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3522, 'gw_fct_graphanalytics_treatment_type', 'ud', 'function', 'json', 'json',
'Function to generate treatment_type of your arcs and nodes. Stop your mouse over labels for more information about input parameters.', 'role_plan', NULL, 'core', NULL);

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active)
VALUES(642, 'Treatment type calculation	', 'ud	', NULL, 'core', true, 'Function process', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true);

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device)
VALUES(3522, 'Treatment type analysis', '{"featureType":[]}'::json, '[
{
  "label": "Process name:", 
  "value": null, 
  "tooltip": "Process name", 
  "comboIds": ["TREATMENT_TYPE"], 
  "datatype": "text", 
  "comboNames": ["Treatment type"], 
  "layoutname": "grl_option_parameters", 
  "selectedId": null,
  "widgetname": "processName", 
  "widgettype": "combo", 
  "layoutorder": 1
}, 
{
  "label": "Exploitation:", 
  "value": null, 
  "tooltip": "Choose exploitation to work with", 
  "datatype": "text", 
  "layoutname": "grl_option_parameters", 
  "selectedId": null, 
  "widgetname": "exploitation", 
  "widgettype": "combo", 
  "dvQueryText": "SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC", 
  "layoutorder": 2
}, 
{
  "label": "Use selected psectors:", 
  "value": null, 
  "tooltip": "If true, use selected psectors. If false ignore selected psectors and only works with on-service network", 
  "datatype": "boolean",
  "layoutname": "grl_option_parameters", 
  "selectedId": null, 
  "widgetname": "usePlanPsector", 
  "widgettype": "check", 
  "layoutorder": 3}, 
{
  "label": "Commit changes:", 
  "value": null, 
  "tooltip": "If true, changes will be applied to DB. If false, algorithm results will be saved in anl tables", 
  "datatype": "boolean", "layoutname": "grl_option_parameters", 
  "selectedId": null, 
  "widgetname": "commitChanges", 
  "widgettype": "check", 
  "layoutorder": 4}
]'::json, NULL, false, '{4}');

UPDATE config_toolbox
SET inputparams='[{"label": "Process name:", "value": null, "tooltip": "Process name", "comboIds": ["FLUID_TYPE"], "datatype": "text", "comboNames": ["Fluid type"], "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "processName", "widgettype": "combo", "layoutorder": 1}, {"label": "Exploitation:", "value": null, "tooltip": "Choose exploitation to work with", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "exploitation", "widgettype": "combo", "dvQueryText": "SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC", "layoutorder": 2}, {"label": "Use selected psectors:", "value": null, "tooltip": "If true, use selected psectors. If false ignore selected psectors and only works with on-service network", "datatype": "boolean", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "usePlanPsector", "widgettype": "check", "layoutorder": 3}, {"label": "Commit changes:", "value": null, "tooltip": "If true, changes will be applied to DB. If false, algorithm results will be saved in anl tables", "datatype": "boolean", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "commitChanges", "widgettype": "check", "layoutorder": 4}]'::json
WHERE id=3424;

UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname ilike 've_connec%' AND formtype='form_feature' AND columnname='matcat_id';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_material WHERE ''ARC'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname ilike 've_arc%' AND formtype='form_feature' AND columnname='matcat_id';
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_material WHERE ''NODE'' = ANY(feature_type) AND id IS NOT NULL' WHERE formname ilike 've_node%' AND formtype='form_feature' AND columnname='matcat_id';

-- 26/11/2025
UPDATE config_param_system SET value='{"sys_table_id":"ve_connec","sys_id_field":"connec_id","sys_search_field":"connec_id","alias":"Connecs","cat_field":"conneccat_id","orderby":"3","search_type":"connec"}'
WHERE "parameter"='basic_search_network_connec';

INSERT INTO sys_table(id, sys_role, source) VALUES ('omunit', 'role_basic', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, sys_role, source) VALUES ('macroomunit', 'role_basic', 'core') ON CONFLICT (id) DO NOTHING;

-- 01/12/2025
UPDATE config_form_fields
	SET "label"=NULL
	WHERE formname='element' AND formtype='form_feature' AND columnname='btn_doc_delete' AND tabname='tab_documents';
UPDATE config_form_fields
	SET "label"=NULL
	WHERE formname='element' AND formtype='form_feature' AND columnname='btn_doc_insert' AND tabname='tab_documents';
UPDATE config_form_fields
	SET "label"=NULL
	WHERE formname='element' AND formtype='form_feature' AND columnname='btn_doc_new' AND tabname='tab_documents';
UPDATE config_form_fields
	SET "label"=NULL
	WHERE formname='element' AND formtype='form_feature' AND columnname='doc_name' AND tabname='tab_documents';
UPDATE config_form_fields
	SET "label"=NULL,tooltip=NULL
	WHERE formname='element' AND formtype='form_feature' AND columnname='hspacer_document_1' AND tabname='tab_documents';
UPDATE config_form_fields
	SET "label"=NULL
	WHERE formname='element' AND formtype='form_feature' AND columnname='open_doc' AND tabname='tab_documents';
UPDATE config_form_fields
	SET "label"=NULL,tooltip=NULL
	WHERE formname='element' AND formtype='form_feature' AND columnname='tbl_documents' AND tabname='tab_documents';

-- 02/12/2025
UPDATE config_form_fields
SET widgetcontrols='{"autoupdateReloadFields":["node_1", "y1", "custom_y1", "custom_elev1", "sys_y1", "sys_elev1", "z1", "r1","node_2", "y2", "custom_y2", "custom_elev2", "sys_y2", "sys_elev2", "z2", "r2","slope"]}'::json
WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='y1' AND tabname='tab_data';
UPDATE config_form_fields
SET widgetcontrols='{"autoupdateReloadFields":["node_1", "y1", "custom_y1", "custom_elev1", "sys_y1", "sys_elev1", "z1", "r1","node_2", "y2", "custom_y2", "custom_elev2", "sys_y2", "sys_elev2", "z2", "r2","slope"]}'::json
WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='custom_y1' AND tabname='tab_data';
UPDATE config_form_fields
SET widgetcontrols='{"autoupdateReloadFields":["node_1", "y1", "custom_y1", "custom_elev1", "sys_y1", "sys_elev1", "z1", "r1","node_2", "y2", "custom_y2", "custom_elev2", "sys_y2", "sys_elev2", "z2", "r2","slope"]}'::json
WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='elev1' AND tabname='tab_data';
UPDATE config_form_fields
SET widgetcontrols='{"autoupdateReloadFields":["node_1", "y1", "custom_y1", "custom_elev1", "sys_y1", "sys_elev1", "z1", "r1","node_2", "y2", "custom_y2", "custom_elev2", "sys_y2", "sys_elev2", "z2", "r2","slope"]}'::json
WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='custom_elev1' AND tabname='tab_data';
UPDATE config_form_fields
SET widgetcontrols='{"autoupdateReloadFields":["node_1", "y1", "custom_y1", "custom_elev1", "sys_y1", "sys_elev1", "z1", "r1","node_2", "y2", "custom_y2", "custom_elev2", "sys_y2", "sys_elev2", "z2", "r2","slope"]}'::json
WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='y2' AND tabname='tab_data';
UPDATE config_form_fields
SET widgetcontrols='{"autoupdateReloadFields":["node_1", "y1", "custom_y1", "custom_elev1", "sys_y1", "sys_elev1", "z1", "r1","node_2", "y2", "custom_y2", "custom_elev2", "sys_y2", "sys_elev2", "z2", "r2","slope"]}'::json
WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='custom_y2' AND tabname='tab_data';
UPDATE config_form_fields
SET widgetcontrols='{"autoupdateReloadFields":["node_1", "y1", "custom_y1", "custom_elev1", "sys_y1", "sys_elev1", "z1", "r1","node_2", "y2", "custom_y2", "custom_elev2", "sys_y2", "sys_elev2", "z2", "r2","slope"]}'::json
WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='elev2' AND tabname='tab_data';
UPDATE config_form_fields
SET widgetcontrols='{"autoupdateReloadFields":["node_1", "y1", "custom_y1", "custom_elev1", "sys_y1", "sys_elev1", "z1", "r1","node_2", "y2", "custom_y2", "custom_elev2", "sys_y2", "sys_elev2", "z2", "r2","slope"]}'::json
WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='custom_elev2' AND tabname='tab_data';

INSERT INTO edit_typevalue (typevalue, id, idval) VALUES ('edit_node_topelev_options', '0', 'ELEV');
INSERT INTO edit_typevalue (typevalue, id, idval) VALUES ('edit_node_topelev_options', '1', 'YMAX');
INSERT INTO sys_param_user VALUES ('edit_node_topelev_options', 'config', 'If elev, ymax is recalculated when node top_elev is changed. If ymax, elev is recalculated when node elev is changed.', 'role_edit', NULL, 'Auto-update elevation/ymax:', 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''edit_node_topelev_options'' AND id IS NOT NULL', NULL, true, 1, 'utils', false, NULL, NULL, NULL, false, 'string', 'combo', true, NULL, NULL, 'lyt_inventory', true, NULL, NULL, NULL, NULL, 'core');

UPDATE sys_fprocess
SET query_text = 'SELECT node_id, nodecat_id, the_geom, expl_id FROM t_node WHERE (ymax is not null) 
and (top_elev is not null or custom_top_elev is not null) and (elev is not null or custom_elev is not null)'
WHERE fid = 461;

