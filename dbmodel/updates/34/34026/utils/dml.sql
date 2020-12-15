/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/12/15
INSERT INTO sys_table VALUES ('v_plan_psector_arc', 'View to show arcs related to psectors. Useful to show arcs which will be obsolete in psectors', 'role_basic', 0, 'role_master', 2, 'Cannot view related arcs to psectors') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('v_plan_psector_node', 'View to show nodes related to psectors. Useful to show nodes which will be obsolete in psectors', 'role_basic', 0, 'role_master', 2, 'Cannot view related nodes to psectors') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('v_plan_psector_connec', 'View to show connecs related to psectors. Useful to show connecs which will be obsolete in psectors', 'role_basic', 0, 'role_master', 2, 'Cannot view related connecs to psectors') ON CONFLICT (id) DO NOTHING;
