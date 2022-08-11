	/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/07/26

DROP TRIGGER IF EXISTS gw_trg_arc_noderotation_update ON arc;

CREATE TRIGGER gw_trg_arc_noderotation_update 
AFTER INSERT OR DELETE OR UPDATE OF the_geom 
ON arc FOR EACH ROW EXECUTE PROCEDURE gw_trg_arc_noderotation_update();

DROP TRIGGER IF EXISTS gw_trg_edit_pol_gully ON ve_pol_gully;

CREATE TRIGGER gw_trg_edit_pol_gully
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON ve_pol_gully
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_man_gully_pol();

