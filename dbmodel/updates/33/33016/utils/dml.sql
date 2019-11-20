/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--20/11/2019
INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, context, descript, sys_role_id, isdeprecated, istoolbox, 
alias, isparametric)
VALUES (2776, 'gw_fct_admin_check_data', 'utils', 'api function', '{"featureType":[]}', null, null,'Function which checks the configuration of API and child views.', 'role_admin',
false, true,'Check API configuration',true) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, fprocess_i18n, project_type)
VALUES (95, 'Admin check data', 'Check', 'Admin check data','utils') ON CONFLICT (id) DO NOTHING;
