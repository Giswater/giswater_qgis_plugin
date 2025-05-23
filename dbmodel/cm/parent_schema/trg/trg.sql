/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TRIGGER IF EXISTS trg_validate_campaign_x_arc_feature ON "SCHEMA_NAME".om_campaign_x_arc;
CREATE TRIGGER trg_validate_campaign_x_arc_feature BEFORE INSERT ON "SCHEMA_NAME".om_campaign_x_arc
FOR EACH ROW EXECUTE FUNCTION cm.gw_trg_campaign_x_feature_validate_type('arc');

DROP TRIGGER IF EXISTS trg_validate_campaign_x_node_feature ON "SCHEMA_NAME".om_campaign_x_node;
CREATE TRIGGER trg_validate_campaign_x_node_feature BEFORE INSERT ON "SCHEMA_NAME".om_campaign_x_node
FOR EACH ROW EXECUTE FUNCTION cm.gw_trg_campaign_x_feature_validate_type('node');

DROP TRIGGER IF EXISTS trg_validate_campaign_x_connec_feature ON "SCHEMA_NAME".om_campaign_x_connec;
CREATE TRIGGER trg_validate_campaign_x_connec_feature BEFORE INSERT ON "SCHEMA_NAME".om_campaign_x_connec
FOR EACH ROW EXECUTE FUNCTION cm.gw_trg_campaign_x_feature_validate_type('connec');

DROP TRIGGER IF EXISTS trg_validate_campaign_x_link_feature ON "SCHEMA_NAME".om_campaign_x_link;
CREATE TRIGGER trg_validate_campaign_x_link_feature BEFORE INSERT ON "SCHEMA_NAME".om_campaign_x_link
FOR EACH ROW EXECUTE FUNCTION cm.gw_trg_campaign_x_feature_validate_type('link');
