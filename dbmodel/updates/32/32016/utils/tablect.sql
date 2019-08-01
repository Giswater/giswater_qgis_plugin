/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE om_visit_class_x_wo ADD CONSTRAINT om_visit_class_x_wo_class_fkey FOREIGN KEY (visitclass_id)
REFERENCES om_visit_class (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_visit_class_x_wo ADD CONSTRAINT om_visit_class_x_wo_wotype_id_fkey FOREIGN KEY (wotype_id)
REFERENCES ext_workorder_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_visit_lot ADD CONSTRAINT om_visit_lot_team_id_fkey FOREIGN KEY (team_id)
REFERENCES cat_team (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_visit_lot ADD CONSTRAINT om_visit_lot_visitclass_id_fkey FOREIGN KEY (visitclass_id)
REFERENCES om_visit_class (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_visit_lot_x_arc ADD CONSTRAINT om_visit_lot_x_arc_lot_id_fkey FOREIGN KEY (lot_id)
REFERENCES om_visit_lot (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_visit_lot_x_node ADD CONSTRAINT om_visit_lot_x_node_lot_id_fkey FOREIGN KEY (lot_id)
REFERENCES om_visit_lot (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_visit_lot_x_connec ADD CONSTRAINT om_visit_lot_x_connec_lot_id_fkey FOREIGN KEY (lot_id)
REFERENCES om_visit_lot (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_visit_lot_x_user ADD CONSTRAINT om_visit_lot_x_user_lot_id FOREIGN KEY (lot_id) 
REFERENCES om_visit_lot (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION;

ALTER TABLE om_visit_lot_x_user ADD CONSTRAINT om_visit_lot_x_user_team_id_fkey FOREIGN KEY (team_id)
REFERENCES cat_team (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION;

ALTER TABLE ext_workorder ADD CONSTRAINT ext_workorder_wotype_id_fkey FOREIGN KEY (wotype_id)
REFERENCES ext_workorder_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ext_workorder ADD CONSTRAINT ext_workorder_visitclass_id_fkey FOREIGN KEY (visitclass_id)
REFERENCES om_visit_class (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE connec DROP CONSTRAINT IF EXISTS connec_customer_code_key CASCADE;