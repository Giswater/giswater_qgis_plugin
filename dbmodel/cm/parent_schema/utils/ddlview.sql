/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- CAMPAIGN x FEATURE
CREATE OR REPLACE VIEW ve_PARENT_SCHEMA_camp_node as
SELECT
om_campaign.campaign_id,
node.node_id,
node.code,
c.node_type,
node.nodecat_id,
om_campaign_x_node.status,
om_campaign_x_node.admin_observ,
om_campaign_x_node.org_observ,
node.the_geom
FROM selector_campaign sc , om_campaign
JOIN om_campaign_x_node ON om_campaign_x_node.campaign_id = om_campaign.campaign_id
JOIN PARENT_SCHEMA.node ON node.node_id::text = om_campaign_x_node.node_id::text
join PARENT_SCHEMA.cat_node c on nodecat_id = c.id
WHERE om_campaign.campaign_id = sc.campaign_id AND sc.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_PARENT_SCHEMA_camp_arc as
SELECT
om_campaign.campaign_id,
arc.arc_id,
arc.code,
c.arc_type,
arc.arccat_id,
om_campaign_x_arc.status,
om_campaign_x_arc.admin_observ,
om_campaign_x_arc.org_observ,
arc.the_geom
FROM selector_campaign sc , om_campaign
JOIN om_campaign_x_arc ON om_campaign_x_arc.campaign_id = om_campaign.campaign_id
JOIN PARENT_SCHEMA.arc ON arc.arc_id::text = om_campaign_x_arc.arc_id::text
join PARENT_SCHEMA.cat_arc c on arccat_id = c.id
WHERE om_campaign.campaign_id = sc.campaign_id AND sc.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_PARENT_SCHEMA_camp_connec as
SELECT
om_campaign.campaign_id,
connec.connec_id,
connec.code,
c.connec_type,
connec.conneccat_id,
om_campaign_x_connec.status,
om_campaign_x_connec.admin_observ,
om_campaign_x_connec.org_observ,
connec.the_geom
FROM selector_campaign sc , om_campaign
JOIN om_campaign_x_connec ON om_campaign_x_connec.campaign_id = om_campaign.campaign_id
JOIN PARENT_SCHEMA.connec ON connec.connec_id::text = om_campaign_x_connec.connec_id::text
join PARENT_SCHEMA.cat_connec c on conneccat_id = c.id
WHERE om_campaign.campaign_id = sc.campaign_id AND sc.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_PARENT_SCHEMA_camp_link AS
SELECT
om_campaign.campaign_id,
link.link_id,
link.code,
c.link_type,
link.linkcat_id,
om_campaign_x_link.status,
om_campaign_x_link.admin_observ,
om_campaign_x_link.org_observ,
link.the_geom
FROM selector_campaign sc, om_campaign
JOIN om_campaign_x_link ON om_campaign_x_link.campaign_id = om_campaign.campaign_id
JOIN PARENT_SCHEMA.link ON link.link_id::text = om_campaign_x_link.link_id::text
join PARENT_SCHEMA.cat_link c on linkcat_id = c.id
WHERE om_campaign.campaign_id = sc.campaign_id AND sc.cur_user = "current_user"()::text;


-- LOT X FEATURE
CREATE OR REPLACE VIEW ve_PARENT_SCHEMA_lot_node as
SELECT
om_campaign_lot.lot_id,
node.node_id,
node.code,
c.node_type,
node.nodecat_id,
om_campaign_lot_x_node.status,
om_campaign_lot_x_node.org_observ,
om_campaign_lot_x_node.team_observ,
om_campaign_lot_x_node.update_at,
om_campaign_lot_x_node.update_by,
om_campaign_lot_x_node.update_count,
om_campaign_lot_x_node.update_log,
qindex1,
qindex2,
node.the_geom
FROM selector_lot, om_campaign_lot
JOIN om_campaign_lot_x_node ON om_campaign_lot_x_node.lot_id = om_campaign_lot.lot_id
JOIN PARENT_SCHEMA.node ON node.node_id::text = om_campaign_lot_x_node.node_id::text
join PARENT_SCHEMA.cat_node c on nodecat_id = c.id
WHERE om_campaign_lot.lot_id = selector_lot.lot_id AND selector_lot.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_PARENT_SCHEMA_lot_arc as
SELECT
om_campaign_lot.lot_id,
arc.arc_id,
arc.code,
c.arc_type,
arc.arccat_id,
om_campaign_lot_x_arc.status,
om_campaign_lot_x_arc.org_observ,
om_campaign_lot_x_arc.team_observ,
om_campaign_lot_x_arc.update_at,
om_campaign_lot_x_arc.update_by,
om_campaign_lot_x_arc.update_count,
om_campaign_lot_x_arc.update_log,
qindex1,
qindex2,
arc.the_geom
FROM selector_lot, om_campaign_lot
JOIN om_campaign_lot_x_arc ON om_campaign_lot_x_arc.lot_id = om_campaign_lot.lot_id
JOIN PARENT_SCHEMA.arc ON arc.arc_id::text = om_campaign_lot_x_arc.arc_id::text
join PARENT_SCHEMA.cat_arc c on arccat_id = c.id
WHERE om_campaign_lot.lot_id = selector_lot.lot_id AND selector_lot.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_PARENT_SCHEMA_lot_connec as
SELECT
om_campaign_lot.lot_id,
connec.connec_id,
connec.code,
c.connec_type,
connec.conneccat_id,
om_campaign_lot_x_connec.status,
om_campaign_lot_x_connec.org_observ,
om_campaign_lot_x_connec.team_observ,
om_campaign_lot_x_connec.update_at,
om_campaign_lot_x_connec.update_by,
om_campaign_lot_x_connec.update_count,
om_campaign_lot_x_connec.update_log,
om_campaign_lot_x_connec.qindex1,
om_campaign_lot_x_connec.qindex2,
connec.the_geom
FROM selector_lot, om_campaign_lot
JOIN om_campaign_lot_x_connec ON om_campaign_lot_x_connec.lot_id = om_campaign_lot.lot_id
JOIN PARENT_SCHEMA.connec ON connec.connec_id::text = om_campaign_lot_x_connec.connec_id::text
join PARENT_SCHEMA.cat_connec c on conneccat_id = c.id
WHERE om_campaign_lot.lot_id = selector_lot.lot_id AND selector_lot.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW ve_PARENT_SCHEMA_lot_link AS
SELECT
om_campaign_lot.lot_id,
link.link_id,
link.code,
c.link_type,
link.linkcat_id,
om_campaign_lot_x_link.status,
om_campaign_lot_x_link.org_observ,
om_campaign_lot_x_link.team_observ,
om_campaign_lot_x_link.update_at,
om_campaign_lot_x_link.update_by,
om_campaign_lot_x_link.update_count,
om_campaign_lot_x_link.update_log, 	
om_campaign_lot_x_link.qindex1,
om_campaign_lot_x_link.qindex2,
link.the_geom
FROM selector_lot, om_campaign_lot
JOIN om_campaign_lot_x_link ON om_campaign_lot_x_link.lot_id = om_campaign_lot.lot_id
JOIN PARENT_SCHEMA.link ON link.link_id::text = om_campaign_lot_x_link.link_id::text
join PARENT_SCHEMA.cat_link c on linkcat_id = c.id
WHERE om_campaign_lot.lot_id = selector_lot.lot_id AND selector_lot.cur_user = "current_user"()::text;

