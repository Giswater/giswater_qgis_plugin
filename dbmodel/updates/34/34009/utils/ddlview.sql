/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/09
DROP VIEW IF EXISTS v_price_x_catsoil4;


CREATE OR REPLACE VIEW v_ui_om_visit_lot AS 
 SELECT om_visit_lot.id,
    om_visit_lot.startdate,
    om_visit_lot.enddate,
    om_visit_lot.real_startdate,
    om_visit_lot.real_enddate,
    om_visit_class.idval AS visitclass_id,
    om_visit_lot.descript,
    cat_team.idval AS team_id,
    om_visit_lot.duration,
    om_typevalue.idval AS status,
    om_visit_lot.class_id,
    om_visit_lot.exercice,
    om_visit_lot.serie,
    ext_workorder.wotype_id,
    ext_workorder.wotype_name,
    om_visit_lot.adreca,
    om_visit_lot.feature_type
   FROM om_visit_lot
     LEFT JOIN ext_workorder ON ext_workorder.serie::text = om_visit_lot.serie::text
     LEFT JOIN om_visit_class ON om_visit_class.id = om_visit_lot.visitclass_id
     LEFT JOIN cat_team ON cat_team.id = om_visit_lot.team_id
     LEFT JOIN om_typevalue ON om_typevalue.id::integer = om_visit_lot.status AND om_typevalue.typevalue = 'lot_cat_status'::text;


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