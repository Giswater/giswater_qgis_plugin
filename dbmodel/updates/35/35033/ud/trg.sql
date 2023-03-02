/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TRIGGER gw_trg_edit_inp_gully
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_gully
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_gully();

DROP TRIGGER IF EXISTS gw_trg_topocontrol_arc ON arc;

CREATE TRIGGER gw_trg_topocontrol_arc
    BEFORE INSERT OR UPDATE OF node_1, node_2, y1, y2, elev1, elev2, custom_y1, custom_y2, custom_elev1, custom_elev2, state, inverted_slope, the_geom
    ON arc
    FOR EACH ROW
    EXECUTE FUNCTION gw_trg_topocontrol_arc();