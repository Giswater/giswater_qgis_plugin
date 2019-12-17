/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE cat_node DROP CONSTRAINT IF EXISTS cat_node_node_type_fkey;
ALTER TABLE cat_arc DROP CONSTRAINT IF EXISTS cat_arc_arc_type_fkey;
ALTER TABLE cat_connec DROP CONSTRAINT IF EXISTS cat_connec_connec_type_fkey;
ALTER TABLE cat_grate DROP CONSTRAINT IF EXISTS cat_grate_gully_type_fkey;
ALTER TABLE gully DROP CONSTRAINT gully_pol_id_fkey;



ALTER TABLE cat_node ADD CONSTRAINT cat_node_node_type_fkey FOREIGN KEY (node_type) REFERENCES node_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE cat_arc ADD CONSTRAINT cat_arc_arc_type_fkey FOREIGN KEY (arc_type) REFERENCES arc_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE cat_connec ADD CONSTRAINT cat_connec_connec_type_fkey FOREIGN KEY (connec_type) REFERENCES connec_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE cat_grate ADD CONSTRAINT cat_grate_gully_type_fkey FOREIGN KEY (gully_type) REFERENCES gully_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE gully ADD CONSTRAINT gully_pol_id_fkey FOREIGN KEY (pol_id) REFERENCES polygon (pol_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
