/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TRIGGER IF EXISTS gw_trg_edit_team_x_user ON v_om_team_x_user;
CREATE TRIGGER gw_trg_edit_team_x_user INSTEAD OF INSERT OR UPDATE OR DELETE ON v_om_team_x_user
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_team_x_user();

DROP TRIGGER IF EXISTS gw_trg_edit_cat_team ON v_edit_cat_team;
CREATE TRIGGER gw_trg_edit_cat_team INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_cat_team
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_cat_team();

/*
DROP TRIGGER IF EXISTS gw_trg_edit_lot_x_user ON v_om_campaign_x_user;
CREATE TRIGGER gw_trg_edit_campaign_x_user INSTEAD OF INSERT OR UPDATE OR DELETE ON v_om_campaign_x_user
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_campaign_x_user();
*/

DROP TRIGGER IF EXISTS gw_trg_om_visit_lotmanage ON PARENT_SCHEMA.om_visit;
CREATE TRIGGER gw_trg_om_visit_lotmanage AFTER INSERT OR UPDATE OF class_id, status ON PARENT_SCHEMA.om_visit
FOR EACH ROW EXECUTE PROCEDURE gw_trg_om_visit_lotmanage();

DROP TRIGGER IF EXISTS gw_trg_om_visit_lotmanage ON PARENT_SCHEMA.om_visit_x_arc;
CREATE TRIGGER gw_trg_om_visit_lotmanage AFTER INSERT ON PARENT_SCHEMA.om_visit_x_arc
FOR EACH ROW EXECUTE PROCEDURE gw_trg_om_visit_lotmanage('arc');

DROP TRIGGER IF EXISTS gw_trg_om_visit_lotmanage ON PARENT_SCHEMA.om_visit_x_node;
CREATE TRIGGER gw_trg_om_visit_lotmanage AFTER INSERT ON PARENT_SCHEMA.om_visit_x_node
FOR EACH ROW EXECUTE PROCEDURE gw_trg_om_visit_lotmanage('node');

DROP TRIGGER IF EXISTS gw_trg_om_visit_lotmanage ON PARENT_SCHEMA.om_visit_x_connec;
CREATE TRIGGER gw_trg_om_visit_lotmanage AFTER INSERT ON PARENT_SCHEMA.om_visit_x_connec
FOR EACH ROW EXECUTE PROCEDURE gw_trg_om_visit_lotmanage('connec');
