/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/12/15
INSERT INTO sys_table VALUES ('v_plan_psector_gully', 'View to show gullys related to psectors. Useful to show gullys which will be obsolete in psectors', 'role_basic', 0, 'role_master', 2, 'Cannot view related gullys to psectors') ON CONFLICT (id) DO NOTHING;
