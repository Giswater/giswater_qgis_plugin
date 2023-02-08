/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO config_param_system(parameter, value, descript, 
label,  isenabled,  project_type, datatype, widgettype, ismandatory, iseditable)
VALUES ('edit_review_auto_field_checked', 'false', 'If true, at saving review data it would be automatically set as finished.',
'Review automatic field check:',
false, 'utils', 'boolean', 'check', false,true);


INSERT INTO sys_function(id, function_name, project_type, function_type, descript, sys_role,  source)
VALUES (3194, 'gw_fct_infofromid', 'utils', 'function', 'Function that works internally with gw_fct_getinfofromid', 'role_basic', 'core') ON CONFLICT (id) DO NOTHING;