/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

DROP TRIGGER IF EXISTS gw_trg_node_update ON node;


CREATE TRIGGER gw_trg_edit_dimensions  INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.v_edit_dimensions
FOR EACH ROW  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_edit_dimensions('dimensions');

DROP TRIGGER gw_trg_topocontrol_node ON node;
CREATE TRIGGER gw_trg_topocontrol_node AFTER INSERT OR UPDATE OF the_geom, state ON node  
FOR EACH ROW EXECUTE PROCEDURE gw_trg_topocontrol_node();

