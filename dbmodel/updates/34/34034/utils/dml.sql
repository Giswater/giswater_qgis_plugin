/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/03/26
INSERT INTO sys_table VALUES ('v_plan_psector_budget_arc', 'View to show budget of every arc related to a psector', 'role_basic', 0) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('v_plan_psector_budget_node', 'View to show budget of every node related to a psector', 'role_basic', 0) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('v_plan_psector_budget_other', 'View to show budget of other prices related to a psector', 'role_basic', 0) ON CONFLICT (id) DO NOTHING;
