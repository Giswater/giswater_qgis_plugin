/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP TRIGGER gw_trg_topocontrol_arc ON arc;
CREATE TRIGGER gw_trg_topocontrol_arc  BEFORE INSERT OR UPDATE OF the_geom, y1, y2, elev1, elev2, custom_y1, custom_y2, custom_elev1, custom_elev2, state, inverted_slope
ON arc  FOR EACH ROW  EXECUTE PROCEDURE gw_trg_topocontrol_arc();

DROP TRIGGER IF EXISTS gw_trg_gully_update ON gully;
DROP TRIGGER IF EXISTS gw_trg_update_link_arc_id ON gully;

CREATE TRIGGER gw_trg_connect_update AFTER UPDATE OF arc_id, pjoint_id, pjoint_type, the_geom
ON SCHEMA_NAME.gully FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_connect_update('gully');

CREATE TRIGGER gw_trg_om_lot_x_gully_geom AFTER INSERT OR UPDATE OR DELETE
ON om_visit_lot_x_gully FOR EACH ROW EXECUTE PROCEDURE gw_trg_plan_psector_geom('lot');

DROP TRIGGER gw_trg_topocontrol_node ON node;

CREATE TRIGGER gw_trg_topocontrol_node AFTER INSERT OR UPDATE 
OF the_geom, state, top_elev, ymax, elev, custom_top_elev, custom_ymax, custom_elev, sys_elev
ON node  FOR EACH ROW  EXECUTE PROCEDURE gw_trg_topocontrol_node();


DROP TRIGGER IF EXISTS gw_trg_vi_outfalls ON SCHEMA_NAME.vi_outfalls;
CREATE TRIGGER gw_trg_vi_outfalls INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_outfalls
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_outfalls');

DROP TRIGGER IF EXISTS  gw_trg_vi_pollutants ON SCHEMA_NAME.vi_pollutants;
CREATE TRIGGER gw_trg_vi_pollutants INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_pollutants
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_pollutants');

DROP TRIGGER IF EXISTS gw_trg_vi_landuses ON SCHEMA_NAME.vi_landuses;
CREATE TRIGGER gw_trg_vi_landuses INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_landuses
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_landuses');

DROP TRIGGER IF EXISTS gw_trg_vi_inflows ON SCHEMA_NAME.vi_treatment;
CREATE TRIGGER gw_trg_vi_treatment INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_treatment
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_treatment');

DROP TRIGGER IF EXISTS gw_trg_vi_inflows ON SCHEMA_NAME.vi_transects;
CREATE TRIGGER gw_trg_vi_transects INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_transects
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_transects');

DROP TRIGGER IF EXISTS gw_trg_vi_inflows ON SCHEMA_NAME.vi_temperature;
CREATE TRIGGER gw_trg_vi_temperature INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_temperature
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_temperature');

DROP TRIGGER IF EXISTS gw_trg_vi_inflows ON SCHEMA_NAME.vi_evaporation;
CREATE TRIGGER gw_trg_vi_evaporation INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_evaporation
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_evaporation');