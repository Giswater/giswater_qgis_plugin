/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/09/07
ALTER TABLE doc_x_arc DROP CONSTRAINT IF EXISTS doc_x_arc_arc_id_fkey;
ALTER TABLE doc_x_arc ADD CONSTRAINT doc_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE doc_x_node DROP CONSTRAINT IF EXISTS doc_x_node_node_id_fkey;
ALTER TABLE doc_x_node ADD CONSTRAINT doc_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE doc_x_connec DROP CONSTRAINT IF EXISTS doc_x_connec_connec_id_fkey;
ALTER TABLE doc_x_connec ADD CONSTRAINT doc_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_visit_x_arc DROP CONSTRAINT IF EXISTS om_visit_x_arc_arc_id_fkey;
ALTER TABLE om_visit_x_arc ADD CONSTRAINT om_visit_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_visit_x_node DROP CONSTRAINT IF EXISTS om_visit_x_node_node_id_fkey;
ALTER TABLE om_visit_x_node ADD CONSTRAINT om_visit_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_visit_x_connec DROP CONSTRAINT IF EXISTS om_visit_x_connec_connec_id_fkey;
ALTER TABLE om_visit_x_connec ADD CONSTRAINT om_visit_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
