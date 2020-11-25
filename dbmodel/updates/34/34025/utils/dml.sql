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