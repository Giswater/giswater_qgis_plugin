/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO sys_table (id, descript, sys_role, context, orderby, alias, source)
VALUES('audit_psector_gully_traceability', 'Traceability of executed planified gullys', 'role_basic', 
'{"level_1":"MASTERPLAN","level_2":"TRACEABILITY"}', 4, 'Psector gully traceability', 'core') ON CONFLICT (id) DO NOTHING;

