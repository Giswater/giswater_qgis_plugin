/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP TRIGGER IF EXISTS gw_trg_arc_orphannode_delete ON arc;

DROP TRIGGER IF EXISTS gw_trg_om_visit ON "SCHEMA_NAME".om_visit_x_arc;
CREATE TRIGGER gw_trg_om_visit AFTER INSERT ON "SCHEMA_NAME".om_visit_x_arc
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_om_visit('arc');

DROP TRIGGER IF EXISTS gw_trg_om_visit ON "SCHEMA_NAME".om_visit_x_node;
CREATE TRIGGER gw_trg_om_visit AFTER INSERT ON "SCHEMA_NAME".om_visit_x_node
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_om_visit('node');

DROP TRIGGER IF EXISTS gw_trg_om_visit ON "SCHEMA_NAME".om_visit_x_connec;
CREATE TRIGGER gw_trg_om_visit AFTER INSERT ON "SCHEMA_NAME".om_visit_x_connec
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_om_visit('connec');
