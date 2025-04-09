/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW v_om_team_x_user AS 
SELECT om_team_x_user.id,
om_team_x_user.user_id,
cat_team.name AS team,
cat_user.name AS user_name
FROM om_team_x_user
JOIN cat_team USING (team_id)
JOIN cat_user USING (user_id);

CREATE OR REPLACE VIEW v_edit_cat_team AS 
SELECT cat_team.team_id,
cat_team.name,
cat_team.descript,
cat_team.active
FROM cat_team;

/*
CREATE OR REPLACE VIEW v_om_campaign_x_user AS
SELECT om_visit_lot_x_user.id,
om_visit_lot_x_user.user_id,
cat_team.name AS team,
om_visit_lot_x_user.lot_id,
workorder.workorder_name,
om_visit_lot.serie,
workorder.observ,
om_visit_lot.descript,
om_visit_lot_x_user.starttime,
om_visit_lot_x_user.endtime,
om_visit_lot_x_user.the_geom
FROM om_visit_lot_x_user
JOIN cat_team ON om_visit_lot_x_user.team_id = cat_team.team_id
LEFT JOIN om_visit_lot ON om_visit_lot.id = om_visit_lot_x_user.lot_id
LEFT JOIN workorder ON workorder.serie::text = om_visit_lot.serie::text;
*/


CREATE OR REPLACE VIEW v_ui_om_campaign_lot AS
SELECT om_campaign_lot.id,
om_campaign_lot.startdate,
om_campaign_lot.enddate,
om_campaign_lot.real_startdate,
om_campaign_lot.real_enddate,
om_campaign_lot.descript,
cat_team.name AS team,
om_campaign_lot.duration,
om_typevalue.idval AS status,
workorder.workorder_name,
om_campaign_lot.address
FROM om_campaign_lot
LEFT JOIN workorder ON workorder.workorder_id = om_campaign_lot.workorder_id
LEFT JOIN cat_team ON cat_team.team_id = om_campaign_lot.team_id
LEFT JOIN PARENT_SCHEMA.om_typevalue ON om_typevalue.id::integer = om_campaign_lot.status AND om_typevalue.typevalue = 'lot_cat_status'::text;


/*
CREATE OR REPLACE VIEW v_res_lot_x_user AS 
SELECT om_visit_lot_x_user.id,
om_visit_lot_x_user.user_id,
om_visit_lot_x_user.team_id,
om_visit_lot_x_user.lot_id,
om_visit_lot_x_user.starttime,
om_visit_lot_x_user.endtime,
(om_visit_lot_x_user.endtime - om_visit_lot_x_user.starttime)::text AS duration,
om_visit_lot.the_geom
FROM PARENT_SCHEMA.selector_date,
om_visit_lot_x_user
JOIN om_visit_lot ON om_visit_lot.id = om_visit_lot_x_user.lot_id
WHERE "overlaps"(om_visit_lot_x_user.starttime, om_visit_lot_x_user.starttime, selector_date.from_date::timestamp without time zone, selector_date.to_date::timestamp without time zone) AND selector_date.cur_user = "current_user"()::text;
*/

CREATE OR REPLACE VIEW ve_campaign_x_node AS
SELECT row_number() OVER (ORDER BY om_campaign_lot_x_node.lot_id, node.node_id) AS rid,
node.node_id,
lower(node.feature_type::text) AS feature_type,
node.code,
om_campaign_lot_x_node.lot_id,
om_campaign_lot_x_node.status,
om_typevalue.idval AS status_name,
om_campaign_lot_x_node.observ,
node.the_geom
FROM selector_lot,
om_campaign_lot
JOIN om_campaign_lot_x_node ON om_campaign_lot_x_node.lot_id = om_campaign_lot.id
JOIN PARENT_SCHEMA.node ON node.node_id::text = om_campaign_lot_x_node.node_id::text
LEFT JOIN PARENT_SCHEMA.om_typevalue ON om_typevalue.id::integer = om_campaign_lot_x_node.status AND om_typevalue.typevalue = 'lot_x_feature_status'::text
WHERE om_campaign_lot.id = selector_lot.lot_id AND selector_lot.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_campaign_x_connec AS
SELECT row_number() OVER (ORDER BY om_campaign_lot_x_connec.lot_id, connec.connec_id) AS rid,
connec.connec_id,
lower(connec.feature_type::text) AS feature_type,
connec.code,
om_campaign_lot_x_connec.lot_id,
om_campaign_lot_x_connec.status,
om_typevalue.idval AS status_name,
om_campaign_lot_x_connec.observ,
connec.the_geom
FROM selector_lot,
om_campaign_lot
JOIN om_campaign_lot_x_connec ON om_campaign_lot_x_connec.lot_id = om_campaign_lot.id
JOIN PARENT_SCHEMA.connec ON connec.connec_id::text = om_campaign_lot_x_connec.connec_id::text
LEFT JOIN PARENT_SCHEMA.om_typevalue ON om_typevalue.id::integer = om_campaign_lot_x_connec.status AND om_typevalue.typevalue = 'lot_x_feature_status'::text
WHERE om_campaign_lot.id = selector_lot.lot_id AND selector_lot.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_campaign_x_arc AS
SELECT row_number() OVER (ORDER BY om_campaign_lot_x_arc.lot_id, arc.arc_id) AS rid,
arc.arc_id,
lower(arc.feature_type::text) AS feature_type,
arc.code,
om_campaign_lot_x_arc.lot_id,
om_campaign_lot_x_arc.status,
om_typevalue.idval AS status_name,
om_campaign_lot_x_arc.observ,
arc.the_geom
FROM selector_lot,
om_campaign_lot
JOIN om_campaign_lot_x_arc ON om_campaign_lot_x_arc.lot_id = om_campaign_lot.id
JOIN PARENT_SCHEMA.arc ON arc.arc_id::text = om_campaign_lot_x_arc.arc_id::text
LEFT JOIN PARENT_SCHEMA.om_typevalue ON om_typevalue.id::integer = om_campaign_lot_x_arc.status AND om_typevalue.typevalue = 'lot_x_feature_status'::text
WHERE om_campaign_lot.id = selector_lot.lot_id AND selector_lot.cur_user = "current_user"()::text;

/*
CREATE OR REPLACE VIEW v_visit_lot_user AS 
 SELECT om_visit_lot_x_user.id,
    om_visit_lot_x_user.user_id,
    om_visit_lot_x_user.team_id,
    om_visit_lot_x_user.lot_id,
    om_visit_lot_x_user.starttime,
    om_visit_lot_x_user.endtime,
    now()::date AS date
   FROM om_visit_lot_x_user
  WHERE om_visit_lot_x_user.user_id::name = "current_user"()
  ORDER BY om_visit_lot_x_user.id DESC
 LIMIT 1;
 */


CREATE OR REPLACE VIEW ve_campaign_x_arc_web AS
 SELECT row_number() OVER (ORDER BY arc.arc_id) AS rid,
    arc.arc_id,
    om_campaign_lot_x_arc.lot_id,
    om_campaign_lot_x_arc.status,
    arc.the_geom,
    'ARC'::text AS sys_type,
    arc.code
   FROM om_campaign_lot
     JOIN om_campaign_lot_x_arc ON om_campaign_lot_x_arc.lot_id = om_campaign_lot.id
     JOIN PARENT_SCHEMA.arc ON arc.arc_id::text = om_campaign_lot_x_arc.arc_id::text;



CREATE OR REPLACE VIEW ve_campaign_x_node_web AS
 SELECT row_number() OVER (ORDER BY node.node_id) AS rid,
    node.node_id,
    om_campaign_lot_x_node.lot_id,
    om_campaign_lot_x_node.status,
    node.the_geom,
    'NODE'::text AS sys_type,
    node.code
   FROM om_campaign_lot
     JOIN om_campaign_lot_x_node ON om_campaign_lot_x_node.lot_id = om_campaign_lot.id
     JOIN PARENT_SCHEMA.node ON node.node_id::text = om_campaign_lot_x_node.node_id::text;



CREATE OR REPLACE VIEW ve_campaign_x_connec_web AS
 SELECT row_number() OVER (ORDER BY connec.connec_id) AS rid,
    connec.connec_id,
    om_campaign_lot_x_connec.lot_id,
    om_campaign_lot_x_connec.status,
    connec.the_geom,
    'CONNEC'::text AS sys_type,
    connec.code
   FROM om_campaign_lot
     JOIN om_campaign_lot_x_connec ON om_campaign_lot_x_connec.lot_id = om_campaign_lot.id
     JOIN PARENT_SCHEMA.connec ON connec.connec_id::text = om_campaign_lot_x_connec.connec_id::text;