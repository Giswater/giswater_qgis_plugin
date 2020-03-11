/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--11/03/2020
INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2822, 'gw_fct_admin_manage_roles', 'utils', 'function', 'Function to system roles of giswater: role_basic, role_om, role_edit, role_epa, role_master, role_admin',
'role_admin',FALSE, FALSE,FALSE)
ON CONFLICT (id) DO NOTHING;
