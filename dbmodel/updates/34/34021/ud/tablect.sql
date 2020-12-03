/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/09/24

ALTER TABLE plan_psector_x_gully DROP CONSTRAINT IF EXISTS plan_psector_x_gully_arc_id_fkey;

ALTER TABLE plan_psector_x_gully ADD CONSTRAINT plan_psector_x_gully_arc_id_fkey FOREIGN KEY (arc_id)
REFERENCES arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;