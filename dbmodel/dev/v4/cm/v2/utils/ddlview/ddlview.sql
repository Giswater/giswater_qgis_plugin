/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW v_ui_om_vehicle_x_parameters AS 
SELECT row_number() OVER (ORDER BY om_vehicle_x_parameters.tstamp DESC) AS rid,
ext_cat_vehicle.idval AS vehicle,
om_vehicle_x_parameters.lot_id,
cat_team.idval AS team,
om_vehicle_x_parameters.image,
om_vehicle_x_parameters.load,
om_vehicle_x_parameters.cur_user AS "user",
om_vehicle_x_parameters.tstamp AS date
FROM om_vehicle_x_parameters
JOIN ext_cat_vehicle ON ext_cat_vehicle.id::text = om_vehicle_x_parameters.vehicle_id::text
JOIN cat_team ON cat_team.id = om_vehicle_x_parameters.team_id;


CREATE OR REPLACE VIEW v_om_team_x_user AS 
SELECT om_team_x_user.id,
om_team_x_user.user_id,
cat_team.idval AS team,
cat_users.name AS user_name
FROM om_team_x_user
JOIN cat_team ON om_team_x_user.team_id = cat_team.id
JOIN cat_users ON om_team_x_user.user_id::text = cat_users.id::text;


CREATE OR REPLACE VIEW v_om_team_x_visitclass AS 
SELECT om_team_x_visitclass.id,
cat_team.idval AS team,
config_visit_class.idval AS visitclass
FROM om_team_x_visitclass
JOIN cat_team ON om_team_x_visitclass.team_id = cat_team.id
JOIN config_visit_class ON om_team_x_visitclass.visitclass_id = config_visit_class.id;


CREATE OR REPLACE VIEW v_edit_cat_team AS 
SELECT cat_team.id,
cat_team.idval,
cat_team.descript,
cat_team.active
FROM cat_team;


CREATE VIEW v_ext_cat_vehicle AS
SELECT
id,
idval,
descript,
model,
number_plate
FROM ext_cat_vehicle;


CREATE OR REPLACE VIEW ud.v_om_lot_x_user
AS SELECT om_visit_lot_x_user.id,
    om_visit_lot.serie AS "Número d'OT",
    om_visit_lot_x_user.lot_id AS "Lot",
    om_visit_lot.class_id AS "Tipus d'OT",
    ext_workorder.wotype_name AS "Tipus actuacio",
    cat_team.idval AS "Equip",
    cat_users.name AS "Usuari",
    om_visit_lot_x_user.endtime - om_visit_lot_x_user.starttime AS "Temps treballat",
    ext_cat_vehicle.idval AS "Vehicle",
    ext_workorder.observations AS "Descripcio OT",
    om_visit_lot.descript AS "Descripcio Lot",
    om_visit_lot_x_user.starttime AS "Data inici",
    om_visit_lot_x_user.endtime AS "Data fi"
   FROM om_visit_lot_x_user
     JOIN cat_team ON om_visit_lot_x_user.team_id = cat_team.id
     JOIN cat_users ON om_visit_lot_x_user.user_id::text = cat_users.id::text
     LEFT JOIN ext_cat_vehicle ON om_visit_lot_x_user.vehicle_id::text = ext_cat_vehicle.id::text
     LEFT JOIN om_visit_lot ON om_visit_lot.id = om_visit_lot_x_user.lot_id
     LEFT JOIN ext_workorder ON ext_workorder.serie::text = om_visit_lot.serie::text;


CREATE OR REPLACE VIEW v_ui_om_visit_lot AS 
SELECT om_visit_lot.id,
om_visit_lot.serie AS "Número d'OT",
om_visit_lot.class_id AS "Tipus d'OT",
ext_workorder.wotype_name AS "Tipus d'actuació",
ext_workorder.observations AS "Observacions d'OT",
cat_team.idval AS "Equip",
om_typevalue.idval AS "Estat",
config_visit_class.idval AS "Tipus de visita",
om_visit_lot.descript AS "Descripció Lot",
om_visit_lot.real_startdate AS "Inici real",
om_visit_lot.real_enddate AS "Fi real",
om_visit_lot.startdate AS "Inici previst",
om_visit_lot.enddate AS "Fi previst",
om_visit_lot.address AS "Adreça",
ext_workorder.wotype_id,
om_visit_lot.feature_type
FROM om_visit_lot
LEFT JOIN ext_workorder ON ext_workorder.serie::text = om_visit_lot.serie::text
LEFT JOIN config_visit_class ON config_visit_class.id = om_visit_lot.visitclass_id
LEFT JOIN cat_team ON cat_team.id = om_visit_lot.team_id
LEFT JOIN om_typevalue ON om_typevalue.id::integer = om_visit_lot.status AND om_typevalue.typevalue = 'lot_cat_status';


CREATE OR REPLACE VIEW v_res_lot_x_user AS 
SELECT om_visit_lot_x_user.id,
om_visit_lot_x_user.user_id,
om_visit_lot_x_user.team_id,
om_visit_lot_x_user.lot_id,
om_visit_lot_x_user.starttime,
om_visit_lot_x_user.endtime,
(om_visit_lot_x_user.endtime - om_visit_lot_x_user.starttime)::text AS duration,
om_visit_lot.the_geom
FROM selector_date,
om_visit_lot_x_user
JOIN om_visit_lot ON om_visit_lot.id = om_visit_lot_x_user.lot_id
WHERE "overlaps"(om_visit_lot_x_user.starttime, om_visit_lot_x_user.starttime, selector_date.from_date::timestamp without time zone, selector_date.to_date::timestamp without time zone) AND selector_date.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_lot_x_node AS 
SELECT row_number() OVER (ORDER BY om_visit_lot_x_node.lot_id, node.node_id) AS rid,
node.node_id,
lower(node.feature_type::text) AS feature_type,
node.code,
om_visit_lot.visitclass_id,
om_visit_lot_x_node.lot_id,
om_visit_lot_x_node.status,
om_typevalue.idval AS status_name,
om_visit_lot_x_node.observ,
node.the_geom
FROM selector_lot,
om_visit_lot
JOIN om_visit_lot_x_node ON om_visit_lot_x_node.lot_id = om_visit_lot.id
JOIN node ON node.node_id::text = om_visit_lot_x_node.node_id::text
LEFT JOIN om_typevalue ON om_typevalue.id::integer = om_visit_lot_x_node.status AND om_typevalue.typevalue = 'lot_x_feature_status'::text
WHERE om_visit_lot.id = selector_lot.lot_id AND selector_lot.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_lot_x_connec AS 
SELECT row_number() OVER (ORDER BY om_visit_lot_x_connec.lot_id, connec.connec_id) AS rid,
connec.connec_id,
lower(connec.feature_type::text) AS feature_type,
connec.code,
om_visit_lot.visitclass_id,
om_visit_lot_x_connec.lot_id,
om_visit_lot_x_connec.status,
om_typevalue.idval AS status_name,
om_visit_lot_x_connec.observ,
connec.the_geom
FROM selector_lot,
om_visit_lot
JOIN om_visit_lot_x_connec ON om_visit_lot_x_connec.lot_id = om_visit_lot.id
JOIN connec ON connec.connec_id::text = om_visit_lot_x_connec.connec_id::text
LEFT JOIN om_typevalue ON om_typevalue.id::integer = om_visit_lot_x_connec.status AND om_typevalue.typevalue = 'lot_x_feature_status'::text
WHERE om_visit_lot.id = selector_lot.lot_id AND selector_lot.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_lot_x_arc AS 
SELECT row_number() OVER (ORDER BY om_visit_lot_x_arc.lot_id, arc.arc_id) AS rid,
arc.arc_id,
lower(arc.feature_type::text) AS feature_type,
arc.code,
om_visit_lot.visitclass_id,
om_visit_lot_x_arc.lot_id,
om_visit_lot_x_arc.status,
om_typevalue.idval AS status_name,
om_visit_lot_x_arc.observ,
arc.the_geom
FROM selector_lot,
om_visit_lot
JOIN om_visit_lot_x_arc ON om_visit_lot_x_arc.lot_id = om_visit_lot.id
JOIN arc ON arc.arc_id::text = om_visit_lot_x_arc.arc_id::text
LEFT JOIN om_typevalue ON om_typevalue.id::integer = om_visit_lot_x_arc.status AND om_typevalue.typevalue = 'lot_x_feature_status'::text
WHERE om_visit_lot.id = selector_lot.lot_id AND selector_lot.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_om_team_x_vehicle AS 
SELECT om_team_x_vehicle.id,
cat_team.idval AS team,
ext_cat_vehicle.idval AS vehicle
FROM om_team_x_vehicle
JOIN cat_team ON om_team_x_vehicle.team_id = cat_team.id
JOIN ext_cat_vehicle ON om_team_x_vehicle.vehicle_id::text = ext_cat_vehicle.id::text;

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
 


CREATE OR REPLACE VIEW ve_lot_x_arc_web AS 
 SELECT row_number() OVER (ORDER BY arc.arc_id) AS rid,
    arc.arc_id,
    om_visit_lot_x_arc.lot_id,
    om_visit_lot_x_arc.status,
    arc.the_geom,
    'ARC'::text AS sys_type,
    arc.code
   FROM om_visit_lot
     JOIN om_visit_lot_x_arc ON om_visit_lot_x_arc.lot_id = om_visit_lot.id
     JOIN arc ON arc.arc_id::text = om_visit_lot_x_arc.arc_id::text
     JOIN om_visit_lot_x_user ON om_visit_lot_x_user.lot_id = om_visit_lot_x_arc.lot_id
  WHERE om_visit_lot_x_user.endtime IS NULL;



CREATE OR REPLACE VIEW ve_lot_x_node_web AS 
 SELECT row_number() OVER (ORDER BY node.node_id) AS rid,
    node.node_id,
    om_visit_lot_x_node.lot_id,
    om_visit_lot_x_node.status,
    node.the_geom,
    'NODE'::text AS sys_type,
    node.code
   FROM om_visit_lot
     JOIN om_visit_lot_x_node ON om_visit_lot_x_node.lot_id = om_visit_lot.id
     JOIN node ON node.node_id::text = om_visit_lot_x_node.node_id::text
     JOIN om_visit_lot_x_user ON om_visit_lot_x_user.lot_id = om_visit_lot_x_node.lot_id
  WHERE om_visit_lot_x_user.endtime IS NULL;



CREATE OR REPLACE VIEW ve_lot_x_connec_web AS 
 SELECT row_number() OVER (ORDER BY connec.connec_id) AS rid,
    connec.connec_id,
    om_visit_lot_x_connec.lot_id,
    om_visit_lot_x_connec.status,
    connec.the_geom,
    'CONNEC'::text AS sys_type,
    connec.code
   FROM om_visit_lot
     JOIN om_visit_lot_x_connec ON om_visit_lot_x_connec.lot_id = om_visit_lot.id
     JOIN connec ON connec.connec_id::text = om_visit_lot_x_connec.connec_id::text
     JOIN om_visit_lot_x_user ON om_visit_lot_x_user.lot_id = om_visit_lot_x_connec.lot_id
  WHERE om_visit_lot_x_user.endtime IS NULL;



CREATE VIEW v_edit_om_visit_lot_x_unit AS 
SELECT l.* FROM om_visit_lot_x_unit l, selector_lot s 
WHERE s.lot_id  = l.lot_id and cur_user = current_user;



CREATE VIEW v_edit_om_visit_lot_x_macrounit AS 
SELECT l.* FROM om_visit_lot_x_macrounit l, selector_lot s 
WHERE s.lot_id  = l.lot_id and cur_user = current_user;


CREATE OR REPLACE VIEW ve_lot_x_node
AS SELECT row_number() OVER (ORDER BY om_visit_lot_x_node.lot_id, node.node_id) AS rid,
    node.node_id,
    lower(node.feature_type::text) AS feature_type,
    node.code,
    om_visit_lot.visitclass_id,
    om_visit_lot_x_node.lot_id,
    om_visit_lot_x_node.status,
    om_typevalue.idval AS status_name,
    om_visit_lot_x_node.observ,
    node.the_geom,
    source
   FROM selector_lot,
    om_visit_lot
     JOIN om_visit_lot_x_node ON om_visit_lot_x_node.lot_id = om_visit_lot.id
     JOIN node ON node.node_id::text = om_visit_lot_x_node.node_id::text
     LEFT JOIN om_typevalue ON om_typevalue.id::integer = om_visit_lot_x_node.status AND om_typevalue.typevalue = 'lot_x_feature_status'::text
  WHERE om_visit_lot.id = selector_lot.lot_id AND selector_lot.cur_user = "current_user"()::text;
 

 CREATE OR REPLACE VIEW ve_lot_x_arc
AS SELECT row_number() OVER (ORDER BY om_visit_lot_x_arc.lot_id, arc.arc_id) AS rid,
    arc.arc_id,
    lower(arc.feature_type::text) AS feature_type,
    arc.code,
    om_visit_lot.visitclass_id,
    om_visit_lot_x_arc.lot_id,
    om_visit_lot_x_arc.status,
    om_typevalue.idval AS status_name,
    om_visit_lot_x_arc.observ,
    arc.the_geom,
    source
   FROM selector_lot,
    om_visit_lot
     JOIN om_visit_lot_x_arc ON om_visit_lot_x_arc.lot_id = om_visit_lot.id
     JOIN arc ON arc.arc_id::text = om_visit_lot_x_arc.arc_id::text
     LEFT JOIN om_typevalue ON om_typevalue.id::integer = om_visit_lot_x_arc.status AND om_typevalue.typevalue = 'lot_x_feature_status'::text
  WHERE om_visit_lot.id = selector_lot.lot_id AND selector_lot.cur_user = "current_user"()::text;
  

 CREATE OR REPLACE VIEW ve_lot_x_gully
AS SELECT row_number() OVER (ORDER BY om_visit_lot_x_gully.lot_id, gully.gully_id) AS rid,
    gully.gully_id,
    lower(gully.feature_type::text) AS feature_type,
    gully.code,
    om_visit_lot.visitclass_id,
    om_visit_lot_x_gully.lot_id,
    om_visit_lot_x_gully.status,
    om_typevalue.idval AS status_name,
    om_visit_lot_x_gully.observ,
    gully.the_geom,
    source
   FROM selector_lot,
    om_visit_lot
     JOIN om_visit_lot_x_gully ON om_visit_lot_x_gully.lot_id = om_visit_lot.id
     JOIN gully ON gully.gully_id::text = om_visit_lot_x_gully.gully_id::text
     LEFT JOIN om_typevalue ON om_typevalue.id::integer = om_visit_lot_x_gully.status AND om_typevalue.typevalue = 'lot_x_feature_status'::text
  WHERE om_visit_lot.id = selector_lot.lot_id AND selector_lot.cur_user = "current_user"()::text;




