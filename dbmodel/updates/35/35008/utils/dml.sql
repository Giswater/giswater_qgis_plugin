/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/06/04
UPDATE config_toolbox SET functionparams = '{"featureType":["arc"]}' WHERE id = 2496;

-- 2021/06/07
INSERT INTO config_param_system (parameter, value, descript, project_type) VALUES(
'qgis_form_element_hidewidgets',  '{}', 
'Variable to customize widgets from element form. Available widggets:
["element_id", "code", "element_type", "elementcat_id", "num_elements", "state", "state_type", "expl_id", "ownercat_id", "location_type", "buildercat_id", "builtdate", "workcat_id", "workcat_id_end", "comment", "observ", "link", "verified", "rotation", "undelete", "btn_add_geom"]',
'ws')
ON CONFLICT (parameter) DO NOTHING;

--2021/06/02
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source)
VALUES (381, 'Arc duplicated', 'utils',NULL, NULL) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3040, 'gw_fct_anl_arc_duplicated', 'utils', 'function', 'json', 'json',
'Check topology assistant. Detect arcs duplicated only by final nodes or the entire geometry',
'role_edit', NULL, NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active)
VALUES (3040,'Check arcs duplicated', '{"featureType":["arc"]}', 
'[{"widgetname":"checkType", "label":"Check type:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,
"comboIds":["geometry","finalNodes"], "comboNames":["GEOMETRY", "FINAL NODES"], "selectedId":"finalNodes"}]', NULL, TRUE) 
ON CONFLICT (id) DO NOTHING;

-- 2021/06/15
INSERT INTO config_function(id, function_name, returnmanager, layermanager, actions)
VALUES (3040,'gw_fct_anl_arc_duplicated', '{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', NULL, NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function(id, function_name, returnmanager, layermanager, actions)
VALUES (2496,'gw_fct_arc_repair', '{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', NULL, NULL)
ON CONFLICT (id) DO NOTHING;

UPDATE config_form_fields SET layoutname=NULL WHERE formname='v_edit_element';
UPDATE config_form_fields SET layoutorder=6 WHERE formname='v_edit_element' AND columnname='state';
UPDATE config_form_fields SET layoutorder=7 WHERE formname='v_edit_element' AND columnname='state_type';

--2021/06/15
DELETE FROM sys_table WHERE id = 'inp_report';
DELETE FROM sys_foreignkey WHERE target_table='inp_report';

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3044, 'gw_fct_import_inp_curve', 'utils', 'function', 'json', 'json',
'Function to assist the import of curves for inp models',
'role_epa', NULL, NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_csv(fid, alias, descript, functionname, active, orderby)
VALUES (384,'Import inp curves', 
'Function to automatize the import of inp curves files. 
The csv file must containts next columns on same position: 
curve_id, x_value, y_value, curve_type (for WS project OR UD project curve_type has diferent values. Check user manual)', 
'gw_fct_import_inp_curve', true, 9)
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source)
VALUES (384, 'Import inp curves', 'utils',NULL, NULL) ON CONFLICT (fid) DO NOTHING;

DELETE FROM config_csv WHERE fid = 141;


INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source)
VALUES (386, 'Import inp patterns', 'utils',NULL, NULL) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3048, 'gw_fct_import_inp_pattern', 'utils', 'function', 'json', 'json',
'Function to assist the import of patterns for inp models',
'role_epa', NULL, NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_csv(fid, alias, descript, functionname, active, orderby)
VALUES (386,'Import inp patterns', 
'Function to automatize the import of inp patterns files. 
The csv file must containts next columns on same position: 
pattern_id, pattern_type, factor1,.......,factorn. 
For WS use up factor18, repeating rows if you like. 
For UD use up factor24. More than one row for pattern is not allowed', 
'gw_fct_import_inp_pattern', true, 9)
ON CONFLICT (fid) DO NOTHING;

--2021/06/21
UPDATE sys_param_user SET label=concat(label,':') WHERE label not ilike '%:';
UPDATE sys_param_user SET formname='hidden' WHERE id='edit_cadtools_baselayer_vdefault';

--2021/06/22
DELETE FROM config_csv WHERE fid=154;
DELETE FROM sys_fprocess WHERE fid=154;

UPDATE config_param_system SET value='{"mode":"disabled", "plan_obsolete_state_type":24}', descript='Define which mode psector trigger would use. Modes: "disabled", "onService"(transform all features afected by psector to its planified state and makes a
 copy of psector), "obsolete"(set all features afected to obsolete but manage their state_type). Define which plan state_type is going to be set to obsolete when execute psector' 
 WHERE parameter='plan_psector_execute_action' AND descript LIKE '%state_type)';

INSERT INTO config_param_system 
VALUES ('edit_connect_autoupdate_fluid', 'TRUE', 'If true, after inserting a link, gully or connec will have the same fluid as arc they are connected to. If false, this value won''t propagate', 'Connect autoupdate fluid', NULL, NULL, FALSE, NULL, 'utils', NULL, NULL, 'boolean')
ON CONFLICT (parameter) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3050, 'gw_fct_getfeaturegeom', 'utils', 'function', 'json', 'json',
'Return geometries from id list',
'role_basic', NULL, NULL) ON CONFLICT (id) DO NOTHING;