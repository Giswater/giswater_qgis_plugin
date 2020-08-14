/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

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

UPDATE sys_param_user SET id = 'edit_insert_elevation_from_dem', label = 'Insert elevation from DEM:'
WHERE id = 'edit_upsert_elevation_from_dem';

UPDATE sys_param_user SET layoutorder = layoutorder+1 WHERE layoutorder > 17 AND layoutname = 'lyt_other';

INSERT INTO sys_param_user(id, formname, descript, sys_role,  label, isenabled, layoutorder, project_type, isparent, 
isautoupdate, datatype, widgettype, ismandatory, layoutname, iseditable,  isdeprecated)
VALUES ('edit_update_elevation_from_dem', 'config', 'If true, the the elevation will be automatically updated from the DEM raster',
'role_edit', 'Update elevation from DEM:', TRUE, 18, 'utils', FALSE, FALSE, 'boolean', 'check', FALSE, 'lyt_other',
TRUE, FALSE) ON CONFLICT (id) DO NOTHING;

--2020/08/06
INSERT INTO config_csv(fid, alias, descript, functionname, active, readheader)
VALUES (246, 'Export ui', 'Export ui form', 'gw_fct_export_ui_xml', true,false) ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_csv(fid, alias, descript, functionname, active, readheader)
VALUES (247, 'Import ui', 'Import ui form', 'gw_fct_import_ui_xml', true,false) ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_toolbox VALUES (2496, 'Arc repair', TRUE, '{"featureType":["arc"]}', NULL, NULL, TRUE);

INSERT INTO sys_param_user(id, formname, descript, sys_role,  label, isenabled, layoutorder, project_type, isparent, 
isautoupdate, datatype, widgettype, ismandatory, layoutname, iseditable,  isdeprecated)
VALUES ('edit_element_doublegeom', 'config', 'If value, overwrites trigger element value to create double geometry in case elementcat_id is defined with this attribute',
'role_edit', 'Doublegeometry value for element:', 2, 11, 'utils', FALSE, FALSE, 'boolean', 'check', FALSE, 'lyt_inventory',
TRUE, FALSE) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type) 
VALUES (2996, 'gw_trg_edit_element_pol', 'utils', 'function')ON CONFLICT (id) DO NOTHING;
