/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/01/18

DROP VIEW IF EXISTS ve_visit_gully_singlevent;
CREATE OR REPLACE VIEW ve_visit_gully_singlevent AS 
 SELECT om_visit_x_gully.visit_id,
    om_visit_x_gully.gully_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    left (date_trunc('second', startdate)::text, 19)::timestamp as startdate,
    left (date_trunc('second', enddate)::text, 19)::timestamp as enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.status,
    om_visit_event.id AS event_id,
    om_visit_event.event_code,
    om_visit_event.position_id,
    om_visit_event.position_value,
    om_visit_event.parameter_id,
    om_visit_event.value,
    om_visit_event.value1,
    om_visit_event.value2,
    om_visit_event.geom1,
    om_visit_event.geom2,
    om_visit_event.geom3,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.tstamp,
    om_visit_event.text,
    om_visit_event.index_val,
    om_visit_event.is_last
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_gully ON om_visit.id = om_visit_x_gully.visit_id
     JOIN config_visit_class ON config_visit_class.id = om_visit.class_id
  WHERE config_visit_class.ismultievent = false;


CREATE OR REPLACE VIEW v_ui_arc_x_relations AS 
 SELECT row_number() OVER () + 1000000 AS rid,
    v_connec.arc_id,
    v_connec.connec_type AS featurecat_id,
    v_connec.connecat_id AS catalog,
    v_connec.connec_id AS feature_id,
    v_connec.code AS feature_code,
    v_connec.sys_type,
    v_connec.state AS arc_state,
    v_connec.state AS feature_state,
    st_x(v_connec.the_geom) AS x,
    st_y(v_connec.the_geom) AS y,
    v_connec.featurecat_id AS proceed_from,
    v_connec.feature_id AS proceed_from_id,
    'v_edit_connec' AS sys_table_id
   FROM v_connec
  WHERE v_connec.arc_id IS NOT NULL
UNION
 SELECT row_number() OVER () + 2000000 AS rid,
    v_gully.arc_id,
    v_gully.gully_type AS featurecat_id,
    v_gully.gratecat_id AS catalog,
    v_gully.gully_id AS feature_id,
    v_gully.code AS feature_code,
    v_gully.sys_type,
    v_gully.state AS arc_state,
    v_gully.state AS feature_state,
    st_x(v_gully.the_geom) AS x,
    st_y(v_gully.the_geom) AS y,
    v_gully.featurecat_id AS proceed_from,
    v_gully.feature_id AS proceed_from_id,
    'v_edit_gully' AS sys_table_id
   FROM v_gully
  WHERE v_gully.arc_id IS NOT NULL;


CREATE OR REPLACE VIEW v_ui_node_x_connection_downstream AS 
 SELECT row_number() OVER (ORDER BY v_arc.node_1) + 1000000 AS rid,
    v_arc.node_1 AS node_id,
    v_arc.arc_id AS feature_id,
    v_arc.code AS feature_code,
    v_arc.arc_type AS featurecat_id,
    v_arc.arccat_id,
    v_arc.y2 AS depth,
    st_length2d(v_arc.the_geom)::numeric(12,2) AS length,
    node.node_id AS downstream_id,
    node.code AS downstream_code,
    node.node_type AS downstream_type,
    v_arc.y1 AS downstream_depth,
    v_arc.sys_type,
    st_x(st_lineinterpolatepoint(v_arc.the_geom, 0.5::double precision)) AS x,
    st_y(st_lineinterpolatepoint(v_arc.the_geom, 0.5::double precision)) AS y,
    cat_arc.descript,
    value_state.name AS state,
    'v_edit_arc'::text AS sys_table_id
   FROM v_arc
     JOIN node ON v_arc.node_2::text = node.node_id::text
     LEFT JOIN cat_arc ON v_arc.arccat_id::text = cat_arc.id::text
     JOIN value_state ON v_arc.state = value_state.id;



CREATE OR REPLACE VIEW v_ui_node_x_connection_upstream AS 
 SELECT row_number() OVER (ORDER BY v_arc.node_2) + 1000000 AS rid,
    v_arc.node_2 AS node_id,
    v_arc.arc_id AS feature_id,
    v_arc.code AS feature_code,
    v_arc.arc_type AS featurecat_id,
    v_arc.arccat_id,
    v_arc.y1 AS depth,
    st_length2d(v_arc.the_geom)::numeric(12,2) AS length,
    node.node_id AS upstream_id,
    node.code AS upstream_code,
    node.node_type AS upstream_type,
    v_arc.y2 AS upstream_depth,
    v_arc.sys_type,
    st_x(st_lineinterpolatepoint(v_arc.the_geom, 0.5::double precision)) AS x,
    st_y(st_lineinterpolatepoint(v_arc.the_geom, 0.5::double precision)) AS y,
    cat_arc.descript,
    value_state.name AS state,
    'v_edit_arc'::text AS sys_table_id
   FROM v_arc
     JOIN node ON v_arc.node_1::text = node.node_id::text
     LEFT JOIN cat_arc ON v_arc.arccat_id::text = cat_arc.id::text
     JOIN value_state ON v_arc.state = value_state.id
UNION
 SELECT row_number() OVER (ORDER BY node.node_id) + 2000000 AS rid,
    node.node_id,
    v_connec.connec_id AS feature_id,
    v_connec.code::text AS feature_code,
    v_connec.connec_type AS featurecat_id,
    v_connec.connecat_id AS arccat_id,
    v_connec.y1 AS depth,
    st_length2d(link.the_geom)::numeric(12,2) AS length,
    v_connec.connec_id AS upstream_id,
    v_connec.code AS upstream_code,
    v_connec.connec_type AS upstream_type,
    v_connec.y2 AS upstream_depth,
    v_connec.sys_type,
    st_x(v_connec.the_geom) AS x,
    st_y(v_connec.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    'v_edit_connec'::text AS sys_table_id
   FROM v_connec
     JOIN link ON link.feature_id::text = v_connec.connec_id::text AND link.feature_type::text = 'CONNEC'::text
     JOIN node ON v_connec.pjoint_id::text = node.node_id::text AND v_connec.pjoint_type::text = 'NODE'::text
     LEFT JOIN cat_connec ON v_connec.connecat_id::text = cat_connec.id::text
     JOIN value_state ON v_connec.state = value_state.id
UNION
 SELECT row_number() OVER (ORDER BY node.node_id) + 3000000 AS rid,
    node.node_id,
    v_gully.gully_id AS feature_id,
    v_gully.code::text AS feature_code,
    v_gully.gully_type AS featurecat_id,
    v_gully.connec_arccat_id AS arccat_id,
    v_gully.ymax - v_gully.sandbox AS depth,
    v_gully.connec_length AS length,
    v_gully.gully_id AS upstream_id,
    v_gully.code AS upstream_code,
    v_gully.gully_type AS upstream_type,
    v_gully.connec_depth AS upstream_depth,
    v_gully.sys_type,
    st_x(v_gully.the_geom) AS x,
    st_y(v_gully.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    'v_edit_gully'::text AS sys_table_id
   FROM v_gully
     JOIN link ON link.feature_id::text = v_gully.gully_id::text AND link.feature_type::text = 'GULLY'::text
     JOIN node ON v_gully.pjoint_id::text = node.node_id::text AND v_gully.pjoint_type::text = 'NODE'::text
     LEFT JOIN cat_connec ON v_gully.connec_arccat_id::text = cat_connec.id::text
     JOIN value_state ON v_gully.state = value_state.id;
