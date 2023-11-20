/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 29/10/2023
CREATE INDEX IF NOT EXISTS node_arc_id ON node USING btree (arc_id);

-- 30/10/2023
CREATE INDEX IF NOT EXISTS plan_psector_expl_id ON plan_psector USING btree (expl_id);

-- 3/11/2023
DROP TRIGGER IF EXISTS gw_trg_node_border ON node;

-- 20/11/2023
CREATE INDEX temp_csv_source ON temp_csv USING btree (source COLLATE pg_catalog."default");
