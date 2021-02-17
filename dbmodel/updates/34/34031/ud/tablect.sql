/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/02/10
ALTER TABLE plan_psector_x_gully DROP CONSTRAINT IF EXISTS plan_psector_x_gully_unique;
ALTER TABLE plan_psector_x_gully ADD CONSTRAINT plan_psector_x_gully_unique UNIQUE(gully_id, psector_id);

-- 2020/01/07
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"cat_feature_gully", "oldName":"gully_type_pkey", "newName":"cat_feature_gully_pkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"cat_feature_gully", "oldName":"gully_type_id_fkey", "newName":"cat_feature_gully_id_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"cat_feature_gully", "oldName":"gully_type_type_fkey", "newName":"cat_feature_gully_type_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"cat_feature_gully", "oldName":"gully_type_man_table_check", "newName":"cat_feature_gully_man_table_check"}}$$);
