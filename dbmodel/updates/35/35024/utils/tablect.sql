/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/04/08
ALTER TABLE plan_psector_x_arc DROP CONSTRAINT IF EXISTS plan_psector_x_arc_state_fkey;
ALTER TABLE plan_psector_x_connec DROP CONSTRAINT IF EXISTS plan_psector_x_connec_state_fkey;
ALTER TABLE plan_psector_x_node DROP CONSTRAINT IF EXISTS plan_psector_x_node_state_fkey;

