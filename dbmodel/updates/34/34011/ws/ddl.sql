/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/25
ALTER TABLE cat_presszone RENAME TO presszone;

ALTER TABLE sector ADD COLUMN stylesheet json;
ALTER TABLE dma ADD COLUMN stylesheet json;
ALTER TABLE presszone ADD COLUMN head numeric(12,2);
ALTER TABLE presszone ADD COLUMN stylesheet json;
ALTER TABLE dqa ADD COLUMN stylesheet json;

ALTER TABLE presszone RENAME id TO presszone_id;
ALTER TABLE presszone RENAME descript TO name;


-- config_mincut_inlet
ALTER TABLE config_mincut_inlet DROP CONSTRAINT anl_mincut_inlet_x_exploitation_pkey;
ALTER TABLE config_mincut_inlet ADD CONSTRAINT config_mincut_inlet_pkey PRIMARY KEY(node_id, expl_id);
ALTER TABLE config_mincut_inlet DROP COLUMN id;
UPDATE sys_table SET sys_sequence = null, sys_sequence_field = null WHERE id = 'config_mincut_inlet';
