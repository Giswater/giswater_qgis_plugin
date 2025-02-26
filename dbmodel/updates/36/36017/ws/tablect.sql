/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE node DROP CONSTRAINT arc_macrominsector_id_fkey;
ALTER TABLE node ADD CONSTRAINT node_macrominsector_id_fkey FOREIGN KEY (macrominsector_id)
REFERENCES macrominsector(macrominsector_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE connec DROP CONSTRAINT node_expl_id2_fkey;
ALTER TABLE connec ADD CONSTRAINT connec_expl_id2_fkey FOREIGN KEY (expl_id2)
REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;

GRANT UPDATE, REFERENCES, DELETE, SELECT, TRIGGER, INSERT, TRUNCATE ON TABLE rpt_hydraulic_status TO role_admin WITH GRANT OPTION;
GRANT UPDATE, REFERENCES, DELETE, SELECT, TRIGGER, INSERT, TRUNCATE ON TABLE rpt_energy_usage TO role_admin WITH GRANT OPTION;