/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/03/17

ALTER TABLE arc_add ADD CONSTRAINT arc_add_arc_id_fkey FOREIGN KEY (arc_id)
REFERENCES arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE node_add ADD CONSTRAINT node_add_node_id_fkey FOREIGN KEY (node_id)
REFERENCES node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE connec_add ADD CONSTRAINT connec_add_connec_id_fkey FOREIGN KEY (connec_id)
REFERENCES connec (connec_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
