/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE subcatchment DROP CONSTRAINT IF EXISTS subcatchment_parent_id_fkey;
ALTER TABLE subcatchment DROP CONSTRAINT IF EXISTS subcatchment_node_id_fkey;

ALTER TABLE gully ADD CONSTRAINT gully_pjoint_type_ckeck 
CHECK (pjoint_type::text = ANY (ARRAY['NODE'::character varying, 'VNODE'::character varying]::text[]));

