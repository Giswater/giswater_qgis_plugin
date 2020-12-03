/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE om_visit_class_x_wo DROP CONSTRAINT IF EXISTS om_visit_class_x_wo_class_fkey;
ALTER TABLE om_visit_class_x_wo ADD CONSTRAINT om_visit_class_x_wo_class_fkey FOREIGN KEY (visitclass_id)
REFERENCES om_visit_class (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_visit_class_x_wo DROP CONSTRAINT IF EXISTS om_visit_class_x_wo_wotype_id_fkey;
ALTER TABLE om_visit_class_x_wo ADD CONSTRAINT om_visit_class_x_wo_wotype_id_fkey FOREIGN KEY (wotype_id)
REFERENCES ext_workorder_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_visit_lot DROP CONSTRAINT IF EXISTS om_visit_lot_team_id_fkey;
ALTER TABLE om_visit_lot ADD CONSTRAINT om_visit_lot_team_id_fkey FOREIGN KEY (team_id)
REFERENCES cat_team (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_visit_lot DROP CONSTRAINT IF EXISTS om_visit_lot_visitclass_id_fkey;
ALTER TABLE om_visit_lot ADD CONSTRAINT om_visit_lot_visitclass_id_fkey FOREIGN KEY (visitclass_id)
REFERENCES om_visit_class (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_visit_lot_x_arc DROP CONSTRAINT IF EXISTS om_visit_lot_x_arc_lot_id_fkey;
ALTER TABLE om_visit_lot_x_arc ADD CONSTRAINT om_visit_lot_x_arc_lot_id_fkey FOREIGN KEY (lot_id)
REFERENCES om_visit_lot (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_visit_lot_x_node DROP CONSTRAINT IF EXISTS om_visit_lot_x_node_lot_id_fkey;
ALTER TABLE om_visit_lot_x_node ADD CONSTRAINT om_visit_lot_x_node_lot_id_fkey FOREIGN KEY (lot_id)
REFERENCES om_visit_lot (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_visit_lot_x_connec DROP CONSTRAINT IF EXISTS om_visit_lot_x_connec_lot_id_fkey;
ALTER TABLE om_visit_lot_x_connec ADD CONSTRAINT om_visit_lot_x_connec_lot_id_fkey FOREIGN KEY (lot_id)
REFERENCES om_visit_lot (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_visit_lot_x_user DROP CONSTRAINT IF EXISTS om_visit_lot_x_user_lot_id;
ALTER TABLE om_visit_lot_x_user ADD CONSTRAINT om_visit_lot_x_user_lot_id FOREIGN KEY (lot_id) 
REFERENCES om_visit_lot (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION;

ALTER TABLE om_visit_lot_x_user DROP CONSTRAINT IF EXISTS om_visit_lot_x_user_team_id_fkey;
ALTER TABLE om_visit_lot_x_user ADD CONSTRAINT om_visit_lot_x_user_team_id_fkey FOREIGN KEY (team_id)
REFERENCES cat_team (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION;

/*
ALTER TABLE ext_workorder DROP CONSTRAINT IF EXISTS ext_workorder_wotype_id_fkey;
ALTER TABLE ext_workorder ADD CONSTRAINT ext_workorder_wotype_id_fkey FOREIGN KEY (wotype_id)
REFERENCES ext_workorder_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ext_workorder DROP CONSTRAINT IF EXISTS ext_workorder_visitclass_id_fkey;
ALTER TABLE ext_workorder ADD CONSTRAINT ext_workorder_visitclass_id_fkey FOREIGN KEY (visitclass_id)
REFERENCES om_visit_class (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
*/


ALTER TABLE connec DROP CONSTRAINT IF EXISTS connec_customer_code_key CASCADE;

ALTER TABLE om_vehicle_x_parameters DROP CONSTRAINT IF EXISTS om_vehicle_x_parameters_vehicle_id_fkey;
ALTER TABLE om_vehicle_x_parameters ADD CONSTRAINT om_vehicle_x_parameters_vehicle_id_fkey FOREIGN KEY (vehicle_id)
REFERENCES ext_cat_vehicle (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_vehicle_x_parameters DROP CONSTRAINT IF EXISTS om_vehicle_x_parameters_lot_id_fkey;
ALTER TABLE om_vehicle_x_parameters ADD CONSTRAINT om_vehicle_x_parameters_lot_id_fkey FOREIGN KEY (lot_id)
REFERENCES om_visit_lot (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_vehicle_x_parameters DROP CONSTRAINT IF EXISTS om_vehicle_x_parameters_team_id_fkey;
ALTER TABLE om_vehicle_x_parameters ADD CONSTRAINT om_vehicle_x_parameters_team_id_fkey FOREIGN KEY (team_id)
REFERENCES cat_team (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;



ALTER TABLE exploitation_x_user ADD CONSTRAINT exploitation_x_user_manager_id_fkey FOREIGN KEY (manager_id)
REFERENCES cat_manager (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE cat_users ADD CONSTRAINT cat_users_sys_role_fkey FOREIGN KEY (sys_role)
REFERENCES sys_role (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;



ALTER TABLE connec ADD CONSTRAINT connec_pjoint_type_fkey FOREIGN KEY (pjoint_type)
REFERENCES sys_feature_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_visit_class ADD CONSTRAINT om_visit_class_feature_type_fkey FOREIGN KEY (feature_type)
REFERENCES sys_feature_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_visit_class ADD CONSTRAINT om_visit_class_sys_role_id_fkey FOREIGN KEY (sys_role_id)
REFERENCES sys_role (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_visit_class ADD CONSTRAINT om_visit_class_visit_type_fkey FOREIGN KEY (visit_type)
REFERENCES om_visit_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_visit_event_photo ADD CONSTRAINT om_visit_event_photo_event_id_fkey FOREIGN KEY (event_id)
REFERENCES om_visit_event (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_visit_parameter DROP CONSTRAINT IF EXISTS om_visit_parameter_criticity_fkey;

ALTER TABLE om_visit_parameter_x_parameter ADD CONSTRAINT om_visit_parameter_x_parameter_parameter_id1_fkey FOREIGN KEY (parameter_id1)
REFERENCES om_visit_parameter (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_visit_parameter_x_parameter ADD CONSTRAINT om_visit_parameter_x_parameter_parameter_id2_fkey FOREIGN KEY (parameter_id2)
REFERENCES om_visit_parameter (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_visit_team_x_user ADD CONSTRAINT om_visit_team_x_user_team_id_fkey FOREIGN KEY (team_id)
REFERENCES cat_team (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
