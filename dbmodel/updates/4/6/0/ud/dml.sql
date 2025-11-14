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
