/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/03/09
INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3136, 'gw_fct_import_inp_urn', 'utils', 'function', NULL, 'json', 'Function that replaces text ids with an integer urn', 'role_admin', NULL, 'core');

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type)
VALUES (439, 'Set integer id on import inp', 'utils', NULL, 'core', false, 'Function process');

update sys_fprocess set fprocess_type='Function process' where fid in (438, 432);

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3138, 'gw_trg_sysaddfields', 'utils', 'function trigger', NULL, NULL, 'Trigger that controls setting addfileds as unactive', 'role_admin', NULL, 'core');
