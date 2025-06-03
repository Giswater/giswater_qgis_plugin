/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TRIGGER IF EXISTS trg_validate_campaign_x_arc_feature ON "SCHEMA_NAME".om_campaign_x_arc;
CREATE TRIGGER trg_validate_campaign_x_arc_feature BEFORE INSERT ON "SCHEMA_NAME".om_campaign_x_arc
FOR EACH ROW EXECUTE FUNCTION SCHEMA_NAME.gw_trg_campaign_x_feature_validate_type('arc');

DROP TRIGGER IF EXISTS trg_validate_campaign_x_node_feature ON "SCHEMA_NAME".om_campaign_x_node;
CREATE TRIGGER trg_validate_campaign_x_node_feature BEFORE INSERT ON "SCHEMA_NAME".om_campaign_x_node
FOR EACH ROW EXECUTE FUNCTION SCHEMA_NAME.gw_trg_campaign_x_feature_validate_type('node');

DROP TRIGGER IF EXISTS trg_validate_campaign_x_connec_feature ON "SCHEMA_NAME".om_campaign_x_connec;
CREATE TRIGGER trg_validate_campaign_x_connec_feature BEFORE INSERT ON "SCHEMA_NAME".om_campaign_x_connec
FOR EACH ROW EXECUTE FUNCTION SCHEMA_NAME.gw_trg_campaign_x_feature_validate_type('connec');

DROP TRIGGER IF EXISTS trg_validate_campaign_x_link_feature ON "SCHEMA_NAME".om_campaign_x_link;
CREATE TRIGGER trg_validate_campaign_x_link_feature BEFORE INSERT ON "SCHEMA_NAME".om_campaign_x_link
FOR EACH ROW EXECUTE FUNCTION SCHEMA_NAME.gw_trg_campaign_x_feature_validate_type('link');

CREATE TRIGGER trg_edit_view_campaign_node INSTEAD OF INSERT OR UPDATE ON ve_PARENT_SCHEMA_camp_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_view_campaign('node');

CREATE TRIGGER trg_edit_view_campaign_arc INSTEAD OF INSERT OR UPDATE ON ve_PARENT_SCHEMA_camp_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_view_campaign('arc');

CREATE TRIGGER trg_edit_view_campaign_connec INSTEAD OF INSERT OR UPDATE ON ve_PARENT_SCHEMA_camp_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_view_campaign('connec');

CREATE TRIGGER trg_edit_view_campaign_link INSTEAD OF INSERT OR UPDATE ON ve_PARENT_SCHEMA_camp_link
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_view_campaign('link');

CREATE TRIGGER trg_edit_view_lot_node INSTEAD OF INSERT OR UPDATE ON ve_PARENT_SCHEMA_lot_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_view_campaign_lot('node');

CREATE TRIGGER trg_edit_view_lot_arc INSTEAD OF INSERT OR UPDATE ON ve_PARENT_SCHEMA_lot_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_view_campaign_lot('arc');

CREATE TRIGGER trg_edit_view_lot_connec INSTEAD OF INSERT OR UPDATE ON ve_PARENT_SCHEMA_lot_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_view_campaign_lot('connec');

CREATE TRIGGER trg_edit_view_lot_link INSTEAD OF INSERT OR UPDATE ON ve_PARENT_SCHEMA_lot_link
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_view_campaign_lot('link');

CREATE TRIGGER trg_lot_x_node_feature AFTER INSERT ON cm.om_campaign_lot_x_node
FOR EACH ROW EXECUTE FUNCTION cm.gw_trg_lot_x_feature('node');

CREATE TRIGGER trg_lot_x_arc_feature AFTER INSERT ON cm.om_campaign_lot_x_arc
FOR EACH ROW EXECUTE FUNCTION cm.gw_trg_lot_x_feature('arc');

CREATE TRIGGER trg_lot_x_connec_feature AFTER INSERT ON cm.om_campaign_lot_x_connec
FOR EACH ROW EXECUTE FUNCTION cm.gw_trg_lot_x_feature('connec');

CREATE TRIGGER trg_lot_x_link_feature AFTER INSERT ON cm.om_campaign_lot_x_link
FOR EACH ROW EXECUTE FUNCTION cm.gw_trg_lot_x_feature('link');

CREATE TRIGGER trg_validate_lot_x_arc_feature BEFORE INSERT OR UPDATE ON cm.om_campaign_lot_x_arc
FOR EACH ROW EXECUTE FUNCTION cm.gw_trg_lot_x_feature_check_campaign('arc');

CREATE TRIGGER trg_validate_lot_x_node_feature BEFORE INSERT OR UPDATE ON cm.om_campaign_lot_x_node
FOR EACH ROW EXECUTE FUNCTION cm.gw_trg_lot_x_feature_check_campaign('node');

CREATE TRIGGER trg_validate_lot_x_connec_feature BEFORE INSERT OR UPDATE ON cm.om_campaign_lot_x_connec
FOR EACH ROW EXECUTE FUNCTION cm.gw_trg_lot_x_feature_check_campaign('connec');

CREATE TRIGGER trg_validate_lot_x_link_feature BEFORE INSERT OR UPDATE ON cm.om_campaign_lot_x_link
FOR EACH ROW EXECUTE FUNCTION cm.gw_trg_lot_x_feature_check_campaign('link');