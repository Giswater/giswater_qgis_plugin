/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = cm, public, pg_catalog;


-- CAMPAIGN x FEATURE
CREATE OR REPLACE VIEW ve_PARENT_SCHEMA_camp_node as
SELECT
ocn.id,
oc.campaign_id,
ocn.node_id,
ocn.code,
ocn.node_type,
ocn.nodecat_id,
ocn.status,
ocn.admin_observ,
ocn.org_observ,
ocn.the_geom
FROM selector_campaign sc
JOIN om_campaign oc ON oc.campaign_id = sc.campaign_id
JOIN om_campaign_x_node ocn ON ocn.campaign_id = oc.campaign_id
WHERE sc.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_PARENT_SCHEMA_camp_arc as
SELECT
oca.id,
oc.campaign_id,
oca.arc_id,
oca.code,
oca.arc_type,
oca.arccat_id,
oca.status,
oca.admin_observ,
oca.org_observ,
oca.the_geom
FROM selector_campaign sc
JOIN om_campaign oc ON oc.campaign_id = sc.campaign_id
JOIN om_campaign_x_arc oca ON oca.campaign_id = oc.campaign_id
WHERE sc.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_PARENT_SCHEMA_camp_connec as
SELECT
occ.id,
oc.campaign_id,
occ.connec_id,
occ.code,
occ.conneccat_id,
occ.status,
occ.admin_observ,
occ.org_observ,
occ.the_geom
FROM selector_campaign sc
JOIN om_campaign oc ON oc.campaign_id = sc.campaign_id
JOIN om_campaign_x_connec occ ON occ.campaign_id = oc.campaign_id
WHERE sc.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_PARENT_SCHEMA_camp_link AS
SELECT
ocl.id,
oc.campaign_id,
ocl.link_id,
ocl.code,
ocl.linkcat_id,
ocl.status,
ocl.admin_observ,
ocl.org_observ,
ocl.the_geom
FROM selector_campaign sc
JOIN om_campaign oc ON oc.campaign_id = sc.campaign_id
JOIN om_campaign_x_link ocl ON ocl.campaign_id = oc.campaign_id
WHERE sc.cur_user = "current_user"()::text;


-- LOT X FEATURE
CREATE OR REPLACE VIEW ve_PARENT_SCHEMA_lot_node as
SELECT
ocln.id,
ocl.lot_id,
ocln.node_id,
ocln.code,
ocln.status,
ocln.org_observ,
ocln.team_observ,
ocln.update_count,
ocln.update_log,
ocln.qindex1,
ocln.qindex2,
ocln.action,
ocn.the_geom
FROM selector_lot sl
JOIN om_campaign_lot ocl ON ocl.lot_id = sl.lot_id
JOIN om_campaign_lot_x_node ocln ON ocln.lot_id = ocl.lot_id
JOIN om_campaign_x_node ocn ON ocn.campaign_id = ocl.campaign_id AND ocn.node_id = ocln.node_id
WHERE sl.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_PARENT_SCHEMA_lot_arc as
SELECT
ocla.id,
ocl.lot_id,
ocla.arc_id,
ocla.code,
ocla.status,
ocla.org_observ,
ocla.team_observ,
ocla.update_count,
ocla.update_log,
ocla.qindex1,
ocla.qindex2,
ocla.action,
oca.the_geom
FROM selector_lot sl
JOIN om_campaign_lot ocl ON ocl.lot_id = sl.lot_id
JOIN om_campaign_lot_x_arc ocla ON ocla.lot_id = ocl.lot_id
JOIN om_campaign_x_arc oca ON oca.campaign_id = ocl.campaign_id AND oca.arc_id = ocla.arc_id
WHERE sl.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_PARENT_SCHEMA_lot_connec as
SELECT
oclc.id,
ocl.lot_id,
oclc.connec_id,
oclc.code,
oclc.status,
oclc.org_observ,
oclc.team_observ,
oclc.update_count,
oclc.update_log,
oclc.qindex1,
oclc.qindex2,
oclc.action,
occ.the_geom
FROM selector_lot sl
JOIN om_campaign_lot ocl ON ocl.lot_id = sl.lot_id
JOIN om_campaign_lot_x_connec oclc ON oclc.lot_id = ocl.lot_id
JOIN om_campaign_x_connec occ ON occ.campaign_id = ocl.campaign_id AND occ.connec_id = oclc.connec_id
WHERE sl.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW ve_PARENT_SCHEMA_lot_link AS
SELECT
ocll.id,
ocl.lot_id,
ocll.link_id,
ocll.code,
ocll.status,
ocll.org_observ,
ocll.team_observ,
ocll.update_count,
ocll.update_log,
ocll.qindex1,
ocll.qindex2,
ocll.action,
oclink.the_geom
FROM selector_lot sl
JOIN om_campaign_lot ocl ON ocl.lot_id = sl.lot_id
JOIN om_campaign_lot_x_link ocll ON ocll.lot_id = ocl.lot_id
JOIN om_campaign_x_link oclink ON oclink.campaign_id = ocl.campaign_id AND oclink.link_id = ocll.link_id
WHERE sl.cur_user = "current_user"()::text;

