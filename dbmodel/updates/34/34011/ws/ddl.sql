/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/25
ALTER TABLE cat_presszone RENAME TO presszone;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"stylesheet", "dataType":"json"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"stylesheet", "dataType":"json"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"presszone", "column":"stylesheet", "dataType":"json"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"presszone", "column":"head", "dataType":"numeric(12,2)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dqa", "column":"stylesheet", "dataType":"json"}}$$);


ALTER TABLE presszone RENAME id TO presszone_id;


-- config_mincut_inlet
ALTER TABLE config_mincut_inlet DROP CONSTRAINT anl_mincut_inlet_x_exploitation_pkey;
ALTER TABLE config_mincut_inlet ADD CONSTRAINT config_mincut_inlet_pkey PRIMARY KEY(node_id, expl_id);
ALTER TABLE config_mincut_inlet DROP COLUMN id;
UPDATE sys_table SET sys_sequence = null, sys_sequence_field = null WHERE id = 'config_mincut_inlet';
