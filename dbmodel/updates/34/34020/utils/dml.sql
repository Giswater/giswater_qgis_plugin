/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/11/09

UPDATE sys_function SET function_name = 'gw_trg_ui_mincut' WHERE id = 2692;

-- 2020/07/14
UPDATE config_param_system SET project_type = 'ws' WHERE parameter = 'om_mincut_enable_alerts';

--2020/08/04
INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role)
VALUES (2988, 'gw_fct_getmincut', 'ws', 'function', 'json', 'json', 'Get mincut values', 'role_om') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role)
VALUES (2990, 'gw_fct_setmincutstart', 'ws', 'function', 'json', 'json', 'Set mincut start', 'role_om') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role)
VALUES (2992, 'gw_fct_setmincutend', 'ws', 'function', 'json', 'json', 'Set mincut end', 'role_om') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type) 
VALUES (2994, 'gw_fct_vnode_repair', 'utils', 'function')ON CONFLICT (id) DO NOTHING;


-- 2020/15/09
UPDATE sys_param_user SET id ='basic_search_exploitation_vdefault' WHERE id = 'basic_search_exploitation_vdefaut';
UPDATE sys_param_user SET id ='basic_search_municipality_vdefault' WHERE id = 'basic_search_municipality_vdefaut';


UPDATE config_param_system SET value ='{"status":false}' WHERE parameter = 'edit_automatic_ccode_autofill';
UPDATE sys_fprocess SET project_type = 'utils' WHERE fid = 118;

INSERT INTO sys_function (id, function_name, project_type, function_type) 
VALUES (2996, 'gw_trg_edit_element_pol', 'utils', 'function')ON CONFLICT (id) DO NOTHING;

--2020/08/06
INSERT INTO config_csv(fid, alias, descript, functionname, active, readheader)
VALUES (246, 'Export ui', 'Export ui form', 'gw_fct_export_ui_xml', true,false) ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_csv(fid, alias, descript, functionname, active, readheader)
VALUES (247, 'Import ui', 'Import ui form', 'gw_fct_import_ui_xml', true,false) ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_toolbox VALUES (2496, 'Arc repair', TRUE, '{"featureType":["arc"]}', NULL, NULL, TRUE)  ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox VALUES (2522, 'Import epanet inp file', TRUE, '{"featureType":[]}', '[{"widgetname":"useNode2arc", "label":"Create node2arc:", "widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":1,"value":"false"}]', null, TRUE)  ON CONFLICT (id) DO NOTHING;
INSERT INTO config_toolbox VALUES (2524, 'Import swmm inp file', TRUE, '{"featureType":[]}', '[{"widgetname":"createSubcGeom", "label":"Create subcatchments geometry:", "widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":1,"value":"true"}]', null, TRUE)  ON CONFLICT (id) DO NOTHING;



INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (251, 'Conduits with negative slope and inverted slope','ud') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (252, 'Features state=2 are involved in psector','utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (253, 'State not according with state_type','utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (254, 'Features with code null','utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (255, 'Orphan polygons', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (256, 'Orphan rows on addfields values', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (257, 'Connec or gully without or with wrong arc_id', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (258, 'Vnode inconsistency - link without vnode', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (259, 'Vnode inconsistency - vnode without link', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (260, 'Link without feature_id', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (261, 'Link without exit_id', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (262, 'Features state=1 and end date', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (263, 'Features state=0 without end date', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (264, 'Features state=1 and end date before start date', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (265, 'Automatic links with more than 100m', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)

VALUES (266, 'Duplicated ID between arc, node, connec, gully', 'utils') ON CONFLICT (fid) DO NOTHING;

-- 2020/16/09
UPDATE sys_param_user SET dv_querytext =$$SELECT UNNEST(ARRAY (select (text_column::json->>'list_tables_name')::text[] from temp_table where fid =163 and cur_user = current_user)) as id, 
UNNEST(ARRAY (select (text_column::json->>'list_layers_name')::text[] FROM temp_table WHERE fid = 163 and cur_user = current_user)) as idval $$ WHERE id = 'edit_cadtools_baselayer_vdefault';

INSERT INTO sys_table (id, descript, sys_role) VALUES ('ve_pol_element', 'Editable view for element polygons', 'role_edit') ON CONFLICT (id) DO NOTHING;
