/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE om_visit_lot DROP CONSTRAINT IF EXISTS om_visit_lot_team_id_fkey;
ALTER TABLE om_visit_lot ADD CONSTRAINT om_visit_lot_team_id_fkey FOREIGN KEY (team_id)
REFERENCES cat_team (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_visit_lot DROP CONSTRAINT IF EXISTS om_visit_lot_visitclass_id_fkey;
ALTER TABLE om_visit_lot ADD CONSTRAINT om_visit_lot_visitclass_id_fkey FOREIGN KEY (visitclass_id)
REFERENCES config_visit_class (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE selector_lot DROP CONSTRAINT IF EXISTS selector_lot_lot_id_fkey;
ALTER TABLE selector_lot ADD CONSTRAINT selector_lot_lot_id_fkey FOREIGN KEY (lot_id)
REFERENCES om_visit_lot (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE selector_lot DROP CONSTRAINT IF EXISTS selector_lot_lot_id_cur_user_unique;
ALTER TABLE selector_lot ADD CONSTRAINT selector_lot_lot_id_cur_user_unique UNIQUE (lot_id, cur_user);

ALTER TABLE om_team_x_user DROP CONSTRAINT IF EXISTS om_team_x_user_unique;
ALTER TABLE om_team_x_user ADD CONSTRAINT om_team_x_user_unique UNIQUE (user_id, team_id);

ALTER TABLE om_team_x_visitclass DROP CONSTRAINT IF EXISTS om_team_x_visitclass_unique;
ALTER TABLE om_team_x_visitclass ADD CONSTRAINT om_team_x_visitclass_unique UNIQUE (team_id, visitclass_id);

ALTER TABLE om_team_x_vehicle DROP CONSTRAINT IF EXISTS om_team_x_vehicle_unique;
ALTER TABLE om_team_x_vehicle ADD CONSTRAINT om_team_x_vehicle_unique UNIQUE (team_id, vehicle_id);

ALTER TABLE om_team_x_user DROP CONSTRAINT IF EXISTS om_team_x_user_user_id_fkey;
ALTER TABLE om_team_x_user ADD CONSTRAINT om_team_x_user_user_id_fkey FOREIGN KEY (user_id)
REFERENCES cat_users (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_team_x_user DROP CONSTRAINT IF EXISTS om_team_x_user_team_id_fkey;
ALTER TABLE om_team_x_user ADD CONSTRAINT om_team_x_user_team_id_fkey FOREIGN KEY (team_id)
REFERENCES cat_team (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_visit_lot_x_arc DROP CONSTRAINT IF EXISTS om_visit_lot_x_arc_lot_id_fkey;
ALTER TABLE om_visit_lot_x_arc ADD CONSTRAINT om_visit_lot_x_arc_lot_id_fkey FOREIGN KEY (lot_id)
REFERENCES om_visit_lot (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_visit_lot_x_connec DROP CONSTRAINT IF EXISTS om_visit_lot_x_connec_lot_id_fkey;
ALTER TABLE om_visit_lot_x_connec ADD CONSTRAINT om_visit_lot_x_connec_lot_id_fkey FOREIGN KEY (lot_id)
REFERENCES om_visit_lot (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_visit_lot_x_node DROP CONSTRAINT IF EXISTS om_visit_lot_x_node_lot_id_fkey;
ALTER TABLE om_visit_lot_x_node ADD CONSTRAINT om_visit_lot_x_node_lot_id_fkey FOREIGN KEY (lot_id)
REFERENCES om_visit_lot (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

/*
ALTER TABLE ext_workorder DROP CONSTRAINT IF EXISTS ext_workorder_visitclass_id_fkey;
ALTER TABLE ext_workorder ADD CONSTRAINT ext_workorder_visitclass_id_fkey FOREIGN KEY (visitclass_id)
REFERENCES config_visit_class (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ext_workorder DROP CONSTRAINT IF EXISTS ext_workorder_wotype_id_fkey;
ALTER TABLE ext_workorder ADD CONSTRAINT ext_workorder_wotype_id_fkey FOREIGN KEY (wotype_id)
REFERENCES ext_workorder_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
*/
ALTER TABLE om_visit_lot_x_user DROP CONSTRAINT IF EXISTS om_visit_lot_x_user_lot_id;
ALTER TABLE om_visit_lot_x_user ADD CONSTRAINT om_visit_lot_x_user_lot_id FOREIGN KEY (lot_id)
REFERENCES om_visit_lot (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_visit_lot_x_user DROP CONSTRAINT IF EXISTS om_visit_lot_x_user_team_id_fkey;
ALTER TABLE om_visit_lot_x_user ADD CONSTRAINT om_visit_lot_x_user_team_id_fkey FOREIGN KEY (team_id)
REFERENCES cat_team (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_team_x_vehicle DROP CONSTRAINT IF EXISTS om_team_x_vehicle_team_id_fkey;
ALTER TABLE om_team_x_vehicle ADD CONSTRAINT om_team_x_vehicle_team_id_fkey FOREIGN KEY (team_id)
REFERENCES cat_team (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_team_x_vehicle DROP CONSTRAINT IF EXISTS om_team_x_vehicle_vehicle_id_fkey;
ALTER TABLE om_team_x_vehicle ADD CONSTRAINT om_team_x_vehicle_vehicle_id_fkey FOREIGN KEY (vehicle_id)
REFERENCES ext_cat_vehicle (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_vehicle_x_parameters DROP CONSTRAINT IF EXISTS om_vehicle_x_parameters_lot_id_fkey;
ALTER TABLE om_vehicle_x_parameters ADD CONSTRAINT om_vehicle_x_parameters_lot_id_fkey FOREIGN KEY (lot_id)
REFERENCES om_visit_lot (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_vehicle_x_parameters DROP CONSTRAINT IF EXISTS om_vehicle_x_parameters_team_id_fkey;
ALTER TABLE om_vehicle_x_parameters ADD CONSTRAINT om_vehicle_x_parameters_team_id_fkey FOREIGN KEY (team_id)
REFERENCES cat_team (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_vehicle_x_parameters DROP CONSTRAINT IF EXISTS om_vehicle_x_parameters_vehicle_id_fkey;
ALTER TABLE om_vehicle_x_parameters ADD CONSTRAINT om_vehicle_x_parameters_vehicle_id_fkey FOREIGN KEY (vehicle_id)
REFERENCES ext_cat_vehicle (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_team_x_visitclass DROP CONSTRAINT IF EXISTS om_team_x_visitclass_team_id_fkey;
ALTER TABLE om_team_x_visitclass ADD CONSTRAINT om_team_x_visitclass_team_id_fkey FOREIGN KEY (team_id)
REFERENCES cat_team (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_team_x_visitclass DROP CONSTRAINT IF EXISTS om_team_x_visitclass_visitclass_id_fkey;
ALTER TABLE om_team_x_visitclass ADD CONSTRAINT om_team_x_visitclass_visitclass_id_fkey FOREIGN KEY (visitclass_id)
REFERENCES config_visit_class (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE config_visit_class_x_workorder DROP CONSTRAINT IF EXISTS om_visit_class_x_wo_class_fkey;
ALTER TABLE config_visit_class_x_workorder ADD CONSTRAINT om_visit_class_x_wo_class_fkey FOREIGN KEY (visitclass_id)
REFERENCES config_visit_class (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE config_visit_class_x_workorder DROP CONSTRAINT IF EXISTS om_visit_class_x_wo_wotype_id_fkey;
ALTER TABLE config_visit_class_x_workorder ADD CONSTRAINT om_visit_class_x_wo_wotype_id_fkey FOREIGN KEY (wotype_id)
REFERENCES ext_workorder_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE om_visit_lot_x_unit DROP CONSTRAINT IF EXISTS om_visit_lot_x_unit_lot_id_fkey;
ALTER TABLE om_visit_lot_x_unit ADD CONSTRAINT om_visit_lot_x_unit_lot_id_fkey FOREIGN KEY (lot_id)
REFERENCES om_visit_lot(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE om_visit_lot_x_unit DROP CONSTRAINT IF EXISTS om_visit_lot_x_unit_macrounit_id_fk;
ALTER TABLE om_visit_lot_x_unit ADD CONSTRAINT om_visit_lot_x_unit_macrounit_id_fk FOREIGN KEY (macrounit_id) 
REFERENCES om_visit_lot_x_macrounit(macrounit_id) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE om_visit_lot_x_macrounit DROP CONSTRAINT IF EXISTS om_visit_lot_x_macrounit_lot_id_fkey;
ALTER TABLE om_visit_lot_x_macrounit ADD CONSTRAINT om_visit_lot_x_macrounit_lot_id_fkey FOREIGN KEY (lot_id)
REFERENCES ud.om_visit_lot(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE om_visit_lot_x_arc DROP CONSTRAINT IF EXISTS om_visit_lot_x_arc_unit_id_fk;
ALTER TABLE om_visit_lot_x_arc ADD CONSTRAINT om_visit_lot_x_arc_unit_id_fk FOREIGN KEY (unit_id) 
REFERENCES om_visit_lot_x_unit(unit_id) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE om_visit_lot_x_node DROP CONSTRAINT IF EXISTS om_visit_lot_x_node_unit_id_fk;
ALTER TABLE om_visit_lot_x_node ADD CONSTRAINT om_visit_lot_x_node_unit_id_fk FOREIGN KEY (unit_id) 
REFERENCES om_visit_lot_x_unit(unit_id) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE om_visit_lot_x_gully DROP CONSTRAINT IF EXISTS om_visit_lot_x_gully_unit_id_fk;
ALTER TABLE om_visit_lot_x_gully ADD CONSTRAINT om_visit_lot_x_gully_unit_id_fk FOREIGN KEY (unit_id) 
REFERENCES om_visit_lot_x_unit(unit_id) ON DELETE SET NULL ON UPDATE CASCADE;



