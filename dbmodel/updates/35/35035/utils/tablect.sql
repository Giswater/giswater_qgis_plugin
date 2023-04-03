/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE IF EXISTS arc ADD CONSTRAINT arc_expl_id2_fkey FOREIGN KEY (expl_id2)
REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE IF EXISTS node ADD CONSTRAINT node_expl_id2_fkey FOREIGN KEY (expl_id2)
REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE IF EXISTS connec ADD CONSTRAINT node_expl_id2_fkey FOREIGN KEY (expl_id2)
REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;