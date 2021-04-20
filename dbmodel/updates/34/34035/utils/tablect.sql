/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2021/04/20
ALTER TABLE plan_psector_x_gully DROP CONSTRAINT IF EXISTS plan_psector_x_gully_state_check;
ALTER TABLE plan_psector_x_gully ADD CONSTRAINT plan_psector_x_gully_state_check CHECK (state = ANY (ARRAY[0,1]::integer[]));

-- 2021/04/20
ALTER TABLE plan_psector_x_arc DROP CONSTRAINT IF EXISTS plan_psector_x_arc_state_check;
ALTER TABLE plan_psector_x_arc ADD CONSTRAINT plan_psector_x_arc_state_check CHECK (state = ANY (ARRAY[0,1]::integer[]));

ALTER TABLE plan_psector_x_node DROP CONSTRAINT IF EXISTS plan_psector_x_node_state_check;
ALTER TABLE plan_psector_x_node ADD CONSTRAINT plan_psector_x_node_state_check CHECK (state = ANY (ARRAY[0,1]::integer[]));

ALTER TABLE plan_psector_x_connec DROP CONSTRAINT IF EXISTS plan_psector_x_connec_state_check;
ALTER TABLE plan_psector_x_connec ADD CONSTRAINT plan_psector_x_connec_state_check CHECK (state = ANY (ARRAY[0,1]::integer[]));