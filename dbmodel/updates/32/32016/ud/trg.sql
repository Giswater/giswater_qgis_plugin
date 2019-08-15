/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TRIGGER gw_trg_gully_update ON gully;
DROP TRIGGER gw_trg_update_link_arc_id ON gully;

CREATE TRIGGER gw_trg_connect_update AFTER UPDATE OF arc_id, pjoint_id, pjoint_type, the_geom
ON SCHEMA_NAME.gully FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_connect_update('gully');

CREATE TRIGGER gw_trg_om_lot_x_gully_geom AFTER INSERT OR UPDATE OR DELETE
ON om_visit_lot_x_gully FOR EACH ROW EXECUTE PROCEDURE gw_trg_plan_psector_geom('lot');

DROP TRIGGER gw_trg_topocontrol_node ON node;

CREATE TRIGGER gw_trg_topocontrol_node AFTER INSERT OR UPDATE 
OF the_geom, state, top_elev, ymax, elev, custom_top_elev, custom_ymax, custom_elev, sys_elev
ON node  FOR EACH ROW  EXECUTE PROCEDURE gw_trg_topocontrol_node();
