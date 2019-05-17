/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP TRIGGER IF EXISTS gw_trg_topocontrol_arc ON SCHEMA_NAME.arc;
CREATE TRIGGER gw_trg_topocontrol_arc BEFORE INSERT OR UPDATE OF the_geom, state
ON SCHEMA_NAME.arc  FOR EACH ROW  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_topocontrol_arc();