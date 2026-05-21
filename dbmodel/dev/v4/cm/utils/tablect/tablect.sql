/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE cat_team DROP CONSTRAINT IF EXISTS cat_team_organization_id_fkey;
ALTER TABLE cat_team ADD CONSTRAINT cat_team_organization_id_fkey FOREIGN KEY (organization_id)
REFERENCES cat_organization(id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE cat_team DROP CONSTRAINT IF EXISTS cat_team_unique;
ALTER TABLE cat_team ADD CONSTRAINT cat_team_unique UNIQUE (id);

ALTER TABLE om_team_x_user DROP CONSTRAINT IF EXISTS om_team_x_user_unique;
ALTER TABLE om_team_x_user ADD CONSTRAINT om_team_x_user_unique UNIQUE (user_id, team_id);

ALTER TABLE om_team_x_user DROP CONSTRAINT IF EXISTS om_team_x_user_user_id_fkey;
ALTER TABLE om_team_x_user ADD CONSTRAINT om_team_x_user_user_id_fkey FOREIGN KEY (user_id)
REFERENCES PARENT_SCHEMA.cat_users (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_team_x_user DROP CONSTRAINT IF EXISTS om_team_x_user_team_id_fkey;
ALTER TABLE om_team_x_user ADD CONSTRAINT om_team_x_user_team_id_fkey FOREIGN KEY (team_id)
REFERENCES cat_team (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_reviewclass_x_layer DROP CONSTRAINT IF EXISTS om_reviewclass_x_layer_reviewclass_id_fkey;
ALTER TABLE om_reviewclass_x_layer ADD CONSTRAINT om_reviewclass_x_layer_reviewclass_id_fkey FOREIGN KEY (reviewclass_id)
REFERENCES om_reviewclass (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_campaign DROP CONSTRAINT IF EXISTS om_campaign_organization_id_fkey;
ALTER TABLE om_campaign ADD CONSTRAINT om_campaign_organization_id_fkey FOREIGN KEY (organization_id)
REFERENCES cat_organization(id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_campaign_visit DROP CONSTRAINT IF EXISTS om_campaign_visit_campaign_id_fkey;
ALTER TABLE om_campaign_visit ADD CONSTRAINT om_campaign_visit_campaign_id_fkey FOREIGN KEY (campaign_id)
REFERENCES om_campaign (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_campaign_visit DROP CONSTRAINT IF EXISTS om_team_x_user_visitclass_id_fkey;
ALTER TABLE om_campaign_visit ADD CONSTRAINT om_team_x_user_visitclass_id_fkey FOREIGN KEY (visitclass_id)
REFERENCES om_visitclass (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_campaign_review DROP CONSTRAINT IF EXISTS om_campaign_review_campaign_id_fkey;
ALTER TABLE om_campaign_review ADD CONSTRAINT om_campaign_review_campaign_id_fkey FOREIGN KEY (campaign_id)
REFERENCES om_campaign (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_campaign_review DROP CONSTRAINT IF EXISTS om_campaign_review_reviewclass_id_fkey;
ALTER TABLE om_campaign_review ADD CONSTRAINT om_campaign_review_reviewclass_id_fkey FOREIGN KEY (reviewclass_id)
REFERENCES om_reviewclass (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_campaign_x_layer DROP CONSTRAINT IF EXISTS om_campaign_x_layer_campaign_id_fkey;
ALTER TABLE om_campaign_x_layer ADD CONSTRAINT om_campaign_x_layer_campaign_id_fkey FOREIGN KEY (campaign_id)
REFERENCES om_campaign (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE selector_campaign DROP CONSTRAINT IF EXISTS selector_campaign_campaign_id_fkey;
ALTER TABLE selector_campaign ADD CONSTRAINT selector_campaign_campaign_id_fkey FOREIGN KEY (campaign_id)
REFERENCES om_campaign (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_campaign_x_arc DROP CONSTRAINT IF EXISTS om_campaign_x_arc_campaign_id_fkey;
ALTER TABLE om_campaign_x_arc ADD CONSTRAINT om_campaign_x_arc_campaign_id_fkey FOREIGN KEY (campaign_id)
REFERENCES om_campaign (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_campaign_x_arc DROP CONSTRAINT IF EXISTS om_campaign_x_arc_arc_id_fkey;
ALTER TABLE om_campaign_x_arc ADD CONSTRAINT om_campaign_x_arc_arc_id_fkey FOREIGN KEY (arc_id)
REFERENCES PARENT_SCHEMA.arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_campaign_x_connec DROP CONSTRAINT IF EXISTS om_campaign_x_connec_campaign_id_fkey;
ALTER TABLE om_campaign_x_connec ADD CONSTRAINT om_campaign_x_connec_campaign_id_fkey FOREIGN KEY (campaign_id)
REFERENCES om_campaign (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_campaign_x_connec DROP CONSTRAINT IF EXISTS om_campaign_x_connec_connec_id_fkey;
ALTER TABLE om_campaign_x_connec ADD CONSTRAINT om_campaign_x_connec_connec_id_fkey FOREIGN KEY (connec_id)
REFERENCES PARENT_SCHEMA.connec (connec_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_campaign_x_link DROP CONSTRAINT IF EXISTS om_campaign_x_link_campaign_id_fkey;
ALTER TABLE om_campaign_x_link ADD CONSTRAINT om_campaign_x_link_campaign_id_fkey FOREIGN KEY (campaign_id)
REFERENCES om_campaign (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_campaign_x_link DROP CONSTRAINT IF EXISTS om_campaign_x_link_link_id_fkey;
ALTER TABLE om_campaign_x_link ADD CONSTRAINT om_campaign_x_link_link_id_fkey FOREIGN KEY (link_id)
REFERENCES PARENT_SCHEMA.link (link_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_campaign_x_node DROP CONSTRAINT IF EXISTS om_campaign_x_node_campaign_id_fkey;
ALTER TABLE om_campaign_x_node ADD CONSTRAINT om_campaign_x_node_campaign_id_fkey FOREIGN KEY (campaign_id)
REFERENCES om_campaign (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_campaign_x_node DROP CONSTRAINT IF EXISTS om_campaign_x_node_node_id_fkey;
ALTER TABLE om_campaign_x_node ADD CONSTRAINT om_campaign_x_node_node_id_fkey FOREIGN KEY (node_id)
REFERENCES PARENT_SCHEMA.node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_campaign_lot DROP CONSTRAINT IF EXISTS om_campaign_lot_campaign_id_fkey;
ALTER TABLE om_campaign_lot ADD CONSTRAINT om_campaign_lot_campaign_id_fkey FOREIGN KEY (campaign_id)
REFERENCES om_campaign (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_campaign_lot DROP CONSTRAINT IF EXISTS om_campaign_lot_workorder_id_fkey;
ALTER TABLE om_campaign_lot ADD CONSTRAINT om_campaign_lot_workorder_id_fkey FOREIGN KEY (workorder_id)
REFERENCES workorder (workorder_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_campaign_lot DROP CONSTRAINT IF EXISTS om_campaign_lot_team_id_fkey;
ALTER TABLE om_campaign_lot ADD CONSTRAINT om_campaign_lot_team_id_fkey FOREIGN KEY (team_id)
REFERENCES cat_team (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE selector_lot DROP CONSTRAINT IF EXISTS selector_lot_lot_id_fkey;
ALTER TABLE selector_lot ADD CONSTRAINT selector_lot_lot_id_fkey FOREIGN KEY (lot_id)
REFERENCES om_campaign_lot (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE selector_lot DROP CONSTRAINT IF EXISTS selector_lot_lot_id_cur_user_unique;
ALTER TABLE selector_lot ADD CONSTRAINT selector_lot_lot_id_cur_user_unique UNIQUE (lot_id, cur_user);

ALTER TABLE om_campaign_lot_x_arc DROP CONSTRAINT IF EXISTS om_campaign_lot_x_arc_lot_id_fkey;
ALTER TABLE om_campaign_lot_x_arc ADD CONSTRAINT om_campaign_lot_x_arc_lot_id_fkey FOREIGN KEY (lot_id)
REFERENCES om_campaign_lot (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_campaign_lot_x_arc DROP CONSTRAINT IF EXISTS om_campaign_lot_x_arc_arc_id_fkey;
ALTER TABLE om_campaign_lot_x_arc ADD CONSTRAINT om_campaign_lot_x_arc_arc_id_fkey FOREIGN KEY (arc_id)
REFERENCES PARENT_SCHEMA.arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_campaign_lot_x_connec DROP CONSTRAINT IF EXISTS om_campaign_lot_x_connec_lot_id_fkey;
ALTER TABLE om_campaign_lot_x_connec ADD CONSTRAINT om_campaign_lot_x_connec_lot_id_fkey FOREIGN KEY (lot_id)
REFERENCES om_campaign_lot (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_campaign_lot_x_connec DROP CONSTRAINT IF EXISTS om_campaign_lot_x_connec_connec_id_fkey;
ALTER TABLE om_campaign_lot_x_connec ADD CONSTRAINT om_campaign_lot_x_connec_connec_id_fkey FOREIGN KEY (connec_id)
REFERENCES PARENT_SCHEMA.connec (connec_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_campaign_lot_x_link DROP CONSTRAINT IF EXISTS om_campaign_lot_x_link_lot_id_fkey;
ALTER TABLE om_campaign_lot_x_link ADD CONSTRAINT om_campaign_lot_x_link_lot_id_fkey FOREIGN KEY (lot_id)
REFERENCES om_campaign_lot (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_campaign_lot_x_link DROP CONSTRAINT IF EXISTS om_campaign_lot_x_link_link_id_fkey;
ALTER TABLE om_campaign_lot_x_link ADD CONSTRAINT om_campaign_lot_x_link_link_id_fkey FOREIGN KEY (link_id)
REFERENCES PARENT_SCHEMA.link (link_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_campaign_lot_x_node DROP CONSTRAINT IF EXISTS om_campaign_lot_x_node_lot_id_fkey;
ALTER TABLE om_campaign_lot_x_node ADD CONSTRAINT om_campaign_lot_x_node_lot_id_fkey FOREIGN KEY (lot_id)
REFERENCES om_campaign_lot (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE om_campaign_lot_x_node DROP CONSTRAINT IF EXISTS om_campaign_lot_x_node_node_id_fkey;
ALTER TABLE om_campaign_lot_x_node ADD CONSTRAINT om_campaign_lot_x_node_node_id_fkey FOREIGN KEY (node_id)
REFERENCES PARENT_SCHEMA.node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE workorder DROP CONSTRAINT IF EXISTS ext_workorder_workorder_type_fkey;
ALTER TABLE workorder ADD CONSTRAINT ext_workorder_workorder_type_fkey FOREIGN KEY (workorder_type)
REFERENCES workorder_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE workorder DROP CONSTRAINT IF EXISTS workorder_workorder_class_fkey;
ALTER TABLE workorder ADD CONSTRAINT workorder_workorder_class_fkey FOREIGN KEY (workorder_class)
REFERENCES workorder_class (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
