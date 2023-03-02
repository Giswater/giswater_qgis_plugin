/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later versio
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TRIGGER IF EXISTS gw_trg_topocontrol_arc ON arc;

CREATE TRIGGER gw_trg_topocontrol_arc
BEFORE INSERT OR UPDATE OF state, the_geom, node_1, node_2
ON arc
FOR EACH ROW
EXECUTE FUNCTION gw_trg_topocontrol_arc();