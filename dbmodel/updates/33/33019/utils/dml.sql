/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, context, descript, sys_role_id, 
isdeprecated, istoolbox, alias, isparametric)
VALUES (2780, 'gw_fct_odbc2pg_hydro_filldata', 'utils', 'function', null, null, null,'Function to assist the odbc2pg process', 'role_om',
false, false, null, false) ON CONFLICT (id) DO NOTHING;

UPDATE audit_cat_function SET istoolbox=false, isparametric=false, alias=null WHERE id=2774;