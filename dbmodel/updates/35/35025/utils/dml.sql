/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/05/23

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES(444, 'Import cat_feature_arc table', 'utils', NULL, 'core', true, '"Function process"', NULL) ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_csv(fid, alias, descript, functionname, active, orderby, addparam)
VALUES (444, 'Import cat_feature_arc', 'Import cat_feature_arc', 'gw_fct_import_cat_feature', true,12, null) ON CONFLICT (fid) DO NOTHING;;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES(445, 'Import cat_feature_node table', 'utils', NULL, 'core', true, '"Function process"', NULL) ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_csv(fid, alias, descript, functionname, active, orderby, addparam)
VALUES (445, 'Import cat_feature_node', 'Import cat_feature_node', 'gw_fct_import_cat_feature', true,13, null) ON CONFLICT (fid) DO NOTHING;;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES(446, 'Import cat_feature_connec table', 'utils', NULL, 'core', true, '"Function process"', NULL) ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_csv(fid, alias, descript, functionname, active, orderby, addparam)
VALUES (446, 'Import cat_feature_connec', 'Import cat_feature_connec', 'gw_fct_import_cat_feature', true,14, null) ON CONFLICT (fid) DO NOTHING;;

INSERT INTO sys_function(id, function_name, project_type, function_type,input_params, return_type, descript, sys_role,  source)
VALUES (3148, 'gw_fct_import_cat_feature', 'utils', 'function', 'json', 'json', 'Function to import configuration of cat_feature tables', 'role_admin','core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, source)
VALUES (3196, 'Shortcut key is already defined for another feature',  'Change it before uploading configuration', 2, true, 'utils', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type,input_params, return_type, descript, sys_role,  source)
VALUES (3150, 'gw_fct_import_catalog', 'utils', 'function', 'json', 'json', 'Function to import configuration of catalogs cat_arc, cat_node, cat_connec and cat_gully', 'role_admin','core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES(448, 'Import cat_node table', 'utils', NULL, 'core', true, '"Function process"', NULL) ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_csv(fid, alias, descript, functionname, active, orderby, addparam)
VALUES (448, 'Import cat_node', 'Import cat_node', 'gw_fct_import_catalog', true,16, null) ON CONFLICT (fid) DO NOTHING;;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES(449, 'Import cat_connec table', 'utils', NULL, 'core', true, '"Function process"', NULL) ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_csv(fid, alias, descript, functionname, active, orderby, addparam)
VALUES (449, 'Import cat_connec', 'Import cat_connec', 'gw_fct_import_catalog', true,17,null) ON CONFLICT (fid) DO NOTHING;;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES(450, 'Import cat_arc table', 'utils', NULL, 'core', true, '"Function process"', NULL) ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_csv(fid, alias, descript, functionname, active, orderby, addparam)
VALUES (450, 'Import cat_arc', 'Import cat_arc', 'gw_fct_import_catalog', true,15, null) ON CONFLICT (fid) DO NOTHING;

--2022/05/31
INSERT INTO config_form_tableview (location_type,project_type,tablename,columnname,columnindex,visible)
	VALUES ('nonvisual manager','utils','v_edit_inp_curve','id',0,true);
INSERT INTO config_form_tableview (location_type,project_type,tablename,columnname,columnindex,visible)
	VALUES ('nonvisual manager','utils','v_edit_inp_curve','curve_type',1,true);
INSERT INTO config_form_tableview (location_type,project_type,tablename,columnname,columnindex,visible,style)
	VALUES ('nonvisual manager','utils','v_edit_inp_curve','descript',2,true,'{"stretch": true}'::json);
INSERT INTO config_form_tableview (location_type,project_type,tablename,columnname,columnindex,visible)
	VALUES ('nonvisual manager','utils','v_edit_inp_curve','expl_id',3,true);
INSERT INTO config_form_tableview (location_type,project_type,tablename,columnname,columnindex,visible)
	VALUES ('nonvisual manager','utils','v_edit_inp_curve','log',4,false);

INSERT INTO config_form_tableview (location_type,project_type,tablename,columnname,columnindex,visible)
	VALUES ('nonvisual manager','utils','v_edit_inp_controls','id',0,true);
INSERT INTO config_form_tableview (location_type,project_type,tablename,columnname,columnindex,visible)
	VALUES ('nonvisual manager','utils','v_edit_inp_controls','sector_id',1,true);
INSERT INTO config_form_tableview (location_type,project_type,tablename,columnname,columnindex,visible,style)
	VALUES ('nonvisual manager','utils','v_edit_inp_controls','text',2,true,'{"stretch": true}'::json);
INSERT INTO config_form_tableview (location_type,project_type,tablename,columnname,columnindex,visible)
	VALUES ('nonvisual manager','utils','v_edit_inp_controls','active',3,true);