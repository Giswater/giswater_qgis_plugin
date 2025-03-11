/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 23/12/2024
CREATE INDEX gully_streetname ON arc USING btree (streetname);
CREATE INDEX gully_streetname2 ON arc USING btree (streetname2);

ALTER TABLE connec DROP CONSTRAINT arc_drainzone_id_fkey;
ALTER TABLE connec ADD CONSTRAINT connec_drainzone_id_fkey FOREIGN KEY (drainzone_id)
REFERENCES drainzone(drainzone_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE connec DROP CONSTRAINT node_expl_id2_fkey;
ALTER TABLE connec ADD CONSTRAINT connec_expl_id2_fkey FOREIGN KEY (expl_id2)
REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE node DROP CONSTRAINT arc_drainzone_id_fkey;
ALTER TABLE node ADD CONSTRAINT node_drainzone_id_fkey FOREIGN KEY (drainzone_id)
REFERENCES drainzone(drainzone_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE gully DROP CONSTRAINT arc_drainzone_id_fkey;
ALTER TABLE gully ADD CONSTRAINT gully_drainzone_id_fkey FOREIGN KEY (drainzone_id)
REFERENCES drainzone(drainzone_id) ON UPDATE CASCADE ON DELETE RESTRICT;

