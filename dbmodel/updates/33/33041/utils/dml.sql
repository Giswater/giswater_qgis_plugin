/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/03/28
INSERT INTO audit_cat_table(id, context, descript, sys_role_id, sys_criticity, qgis_role_id, isdeprecated) 
VALUES ('om_profile', 'O&M', 'Table to store profiles', 'role_om', 0, 'role_om', false)
ON CONFLICT (id) DO NOTHING;

UPDATE audit_cat_table SET isdeprecated = true 
WHERE id IN ('anl_arc_profile_value','v_edit_vnode');

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (122,'Profile analysis','om','utils') ON CONFLICT (id) DO NOTHING;

--2002/03/11
INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, context, descript, sys_role_id, 
isdeprecated, istoolbox, alias, isparametric)
VALUES (2832, 'gw_fct_getprofilevalues', 'utils', 'function', null, null, null,'Function to manage profile values', 'role_om',
false, false, null, false) ON CONFLICT (id) DO NOTHING;


