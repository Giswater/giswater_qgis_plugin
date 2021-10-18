/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/10/14
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (408, 'Import istram nodes','ud', null, null) ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (409, 'Import istram arcs','ud', null, null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, 
return_type, descript, sys_role, sample_query, source)
VALUES (3104, 'gw_fct_import_istram', 'ud', 'function', 'json', 
'json', 'Function to import arcs and nodes from istram files', 'role_edit', null, null) ON CONFLICT id DO NOTHING;

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, source)
VALUES (3190, 'There are no nodes defined as arcs finals','First insert csv file with nodes definition', 2, true, 'ud',null) ON CONFLICT (id) DO NOTHING;