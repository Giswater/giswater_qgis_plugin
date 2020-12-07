/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/11/20

UPDATE sys_message SET error_message='The inserted value is not present in a catalog.'
WHERE ID = 3022;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (357, 'Store hydrometer user selector values', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (358, 'Store state user selector values', 'utils') ON CONFLICT (fid) DO NOTHING ;

-- 2020/11/24
UPDATE config_form_fields SET columnname = 'id', ismandatory = TRUE WHERE columnname='cat_work_id' AND formname = 'new_workcat';
UPDATE config_form_fields SET columnname = 'workid_key1' WHERE columnname='workid_key_1' AND formname = 'new_workcat';
UPDATE config_form_fields SET columnname = 'workid_key2' WHERE columnname='workid_key_2' AND formname = 'new_workcat';

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role)
VALUES (3010,'gw_fct_setcatalog', 'utils', 'function', 'json', 'json', 'Function that saves data into catalogs created using button located in the info form', 'role_edit') 
ON CONFLICT (function_name, project_type) DO NOTHING;

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type)
VALUES (3166, 'Id value for this catalog already exists', 'Look for it in the proposed values or set a new id', 2, true, 'utils') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (360, 'Find features state=2 deleted with psector', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (361, 'Auxiliar cad polygons', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (362, 'Auxiliar cad lines', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role_id, qgis_criticity)
VALUES ('v_edit_cad_auxline', 'Layer to store line geometry', 'role_edit', 0, 'role_edit', 0) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (363, 'Flow values', 'ws') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (364, 'Pressure values', 'ws') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (365, 'Clorinathor values', 'ws') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (366, 'Temperature values', 'ws') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_param_user(id, formname, descript, sys_role, label, isenabled, layoutorder, project_type, isparent, 
isautoupdate, datatype, widgettype, ismandatory, layoutname, iseditable, isdeprecated, vdefault)
VALUES ('inp_timeseries', 'hidden', 'Values for advanced exportation, managing timeseries for epanet',
'role_epa', 'Timeseries', FALSE, NULL, 'ws', FALSE, FALSE, 'json', 'text', FALSE, NULL, NULL, FALSE, 
'{"status":true, "period":{"startTime":"2000-01-01 00:00:00", "endTime":"2000-01-01 00:00:00"}}') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role) VALUES ('ext_arc', 'External table for arc values', 'role_edit') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role) VALUES ('ext_node', 'External table for node values', 'role_edit') 
ON CONFLICT (id) DO NOTHING;

--2020/11/26
UPDATE sys_param_user SET dv_querytext='SELECT id, idval FROM om_typevalue WHERE typevalue=''visit_status'''
WHERE id = 'om_visit_status_vdefault';

--2020/11/30
UPDATE config_csv SET descript='The csv file must containts next columns on same position: 
feature_id (can be arc, node or connec), parameter_id (choose from sys_addfields), value_param. ' WHERE fid=236;

UPDATE config_csv SET descript='The csv file must containts next columns on same position:
Id (arc_id, node_id, connec_id), code, elementcat_id, observ, comment, num_elements, state type (id), workcat_id, verified (choose from edit_typevalue>value_verified).
- Observations and comments fields are optional
- ATTENTION! Import label has to be filled with the type of element (node, arc, connec)' WHERE fid=235;

--2020/03/12
UPDATE cat_feature SET active = TRUE WHERE active IS NULL;
UPDATE cat_arc SET active = TRUE WHERE active IS NULL;
UPDATE cat_node SET active = TRUE WHERE active IS NULL;
UPDATE cat_connec SET active = TRUE WHERE active IS NULL;
UPDATE cat_element SET active = TRUE WHERE active IS NULL;
UPDATE cat_users SET active = TRUE WHERE active IS NULL;
UPDATE exploitation SET active = TRUE WHERE active IS NULL;
UPDATE sys_addfields SET active = TRUE WHERE active IS NULL;
UPDATE sys_style SET active = TRUE WHERE active IS NULL;
UPDATE cat_arc_shape SET active = TRUE WHERE active IS NULL;

UPDATE sys_param_user SET layoutname='lyt_connec_vdef' WHERE layoutname='lyt_connec_gully_vdef' AND id like 'edit_connec%';
UPDATE sys_param_user SET layoutname='lyt_gully_vdef' WHERE layoutname='lyt_connec_gully_vdef' AND id like 'edit_grate%';

UPDATE sys_param_user SET dv_parent_id='edit_feature_category_vdefault' WHERE dv_parent_id='feature_category_vdefault';
UPDATE sys_param_user SET dv_parent_id='edit_feature_fluid_vdefault' WHERE dv_parent_id='feature_fluid_vdefault';
UPDATE sys_param_user SET dv_parent_id='edit_feature_function_vdefault' WHERE dv_parent_id='feature_function_vdefault';
UPDATE sys_param_user SET dv_parent_id='edit_feature_location_vdefault' WHERE dv_parent_id='feature_location_vdefault';

UPDATE sys_param_user SET feature_field_id='fluid_type' WHERE id='edit_feature_fluid_vdefault';
UPDATE sys_param_user SET feature_field_id='function_type' WHERE id='edit_feature_function_vdefault';
UPDATE sys_param_user SET feature_field_id='location_type' WHERE id='edit_feature_location_vdefault';
UPDATE sys_param_user SET feature_field_id='category_type' WHERE id='edit_feature_category_vdefault';

DELETE FROM sys_function where function_name like '%odbc2pg%';