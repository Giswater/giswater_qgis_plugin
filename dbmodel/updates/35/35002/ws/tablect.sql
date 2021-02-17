/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/02/17
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_graf_inlet", "oldName":"config_mincut_inlet_expl_id_fkey", "newName":"config_graf_inlet_expl_id_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_graf_inlet", "oldName":"config_mincut_inlet_node_id_fkey", "newName":"config_graf_inlet_node_id_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_graf_inlet", "oldName":"config_mincut_inlet_pkey", "newName":"config_graf_inlet_pkey"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_graf_checkvalve", "oldName":"anl_mincut_checkvalve_pkey", "newName":"config_graf_checkvalve_pkey"}}$$);
