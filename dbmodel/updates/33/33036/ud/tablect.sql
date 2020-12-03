/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- DROP
ALTER TABLE node DROP CONSTRAINT IF EXISTS node_matcat_id_fkey;
ALTER TABLE connec DROP CONSTRAINT IF EXISTS connec_matcat_id_fkey;
ALTER TABLE arc DROP CONSTRAINT IF EXISTS arc_matcat_id_fkey;


--ADD
ALTER TABLE node ADD CONSTRAINT node_matcat_id_fkey FOREIGN KEY (matcat_id)
REFERENCES cat_mat_node (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE connec ADD CONSTRAINT connec_matcat_id_fkey FOREIGN KEY (matcat_id)
REFERENCES cat_mat_arc (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE arc ADD CONSTRAINT arc_matcat_id_fkey FOREIGN KEY (matcat_id)
REFERENCES cat_mat_arc (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;