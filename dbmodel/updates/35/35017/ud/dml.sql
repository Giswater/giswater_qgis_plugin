/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/11/01
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (416, 'Gully without pjoint_id or pjoint_type','ud', null, null) ON CONFLICT (fid) DO NOTHING;

--2021/11/06
UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text, '"valueRelation":{', '"valueRelation":{"nullValue":false, '))::json 
WHERE widgetcontrols->>'valueRelation' IS NOT NULL;

UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text, '"valueRelation": {', '"valueRelation":{"nullValue":false, '))::json 
WHERE widgetcontrols->>'valueRelation' IS NOT NULL;

UPDATE config_form_fields 
SET widgetcontrols = gw_fct_json_object_set_key(widgetcontrols, 'valueRelation', '{"nullValue":false, "layer": "cat_dwf_scenario", "activated": true, "keyColumn": "id", "valueColumn": "idval", "filterExpression": ""}'::json)
WHERE columnname = 'dwfscenario_id' AND formname !='cat_dwf_scenario';

UPDATE config_form_fields 
SET widgetcontrols = gw_fct_json_object_set_key(widgetcontrols, 'valueRelation', '{"nullValue":true, "layer": "cat_hydrology", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": ""}'::json)
WHERE columnname = 'pattern_id' AND formname !='inp_pattern';

UPDATE config_form_fields 
SET widgetcontrols = gw_fct_json_object_set_key(widgetcontrols, 'valueRelation', '{"nullValue":true, "layer": "v_edit_inp_curve", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": ""}'::json)
WHERE columnname = 'curve_id' AND formname !='inp_curve';

UPDATE config_form_fields 
SET widgetcontrols = gw_fct_json_object_set_key(widgetcontrols, 'valueRelation', '{"nullValue":true, "layer": "inp_timeseries", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": ""}'::json)
WHERE columnname = 'timser_id' AND formname !='inp_timeseries';

UPDATE config_form_fields 
SET widgetcontrols = gw_fct_json_object_set_key(widgetcontrols, 'valueRelation', '{"nullValue":true, "layer": "inp_lid_control", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": ""}'::json)
WHERE columnname = 'dscenario_id' AND formname !='cat_dscenario';

UPDATE config_form_fields 
SET widgetcontrols = '{"setMultiline": false, "valueRelation":{"nullValue":false,   "layer": "cat_feature", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression":"feature_type=''ARC''"}}'
WHERE columnname = 'arc_type' AND (formname = 'v_edit_arc' or formname like 've_arc%');

UPDATE config_form_fields 
SET widgetcontrols = '{"setMultiline": false, "valueRelation":{"nullValue":false,   "layer": "cat_feature", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression":"feature_type=''CONNEC''"}}'
WHERE columnname = 'connec_type' AND (formname = 'v_edit_connec' or formname like 've_connec%');

UPDATE config_form_fields 
SET widgetcontrols = '{"setMultiline": false, "valueRelation":{"nullValue":false,   "layer": "cat_feature", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression":"feature_type=''GYLLY''"}}'
WHERE columnname = 'gully_type' AND (formname = 'v_edit_gully' or formname like 've_gully%' or formname  ='cat_grate');