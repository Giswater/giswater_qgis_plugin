/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2018/12/13

CREATE OR REPLACE VIEW SCHEMA_NAME.v_ui_node_x_connection_upstream AS 
 SELECT row_number() OVER (ORDER BY v_edit_arc.node_1) + 1000000 AS rid,
    v_edit_arc.node_1 AS node_id,
    v_edit_arc.arc_id AS feature_id,
    v_edit_arc.code AS feature_code,
    v_edit_arc.arc_type AS featurecat_id,
    v_edit_arc.arccat_id,
    v_edit_arc.y2 AS depth,
    st_length2d(v_edit_arc.the_geom)::numeric(12,2) AS length,
    node.node_id AS upstream_id,
    node.code AS upstream_code,
    node.node_type AS upstream_type,
    v_edit_arc.y1 AS upstream_depth,
    v_edit_arc.sys_type,
    st_x(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS x,
    st_y(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS y
   FROM SCHEMA_NAME.v_edit_arc
     JOIN SCHEMA_NAME.node ON v_edit_arc.node_2::text = node.node_id::text
     JOIN SCHEMA_NAME.arc_type ON arc_type.id::text = v_edit_arc.arc_type::text
UNION
 SELECT row_number() OVER (ORDER BY node.node_id) + 2000000 AS rid,
    node.node_id,
    link.link_id::text AS feature_id,
    NULL::character varying AS feature_code,
    v_edit_connec.connec_type AS featurecat_id,
    v_edit_connec.connecat_id AS arccat_id,
    v_edit_connec.y2 AS depth,
    st_length2d(link.the_geom)::numeric(12,2) AS length,
    v_edit_connec.connec_id AS upstream_id,
    v_edit_connec.code AS upstream_code,
    v_edit_connec.connec_type AS upstream_type,
    v_edit_connec.y1 AS upstream_depth,
    v_edit_connec.sys_type,
    st_x(v_edit_connec.the_geom) AS x,
    st_y(v_edit_connec.the_geom) AS y
   FROM SCHEMA_NAME.v_edit_connec
     JOIN SCHEMA_NAME.link ON link.feature_id::text = v_edit_connec.connec_id::text
     JOIN SCHEMA_NAME.node ON link.exit_id::text = node.node_id::text
     WHERE link.feature_type='CONNEC'
UNION
 SELECT row_number() OVER (ORDER BY node.node_id) + 3000000 AS rid,
    node.node_id,
    link.link_id::text AS feature_id,
    NULL::character varying AS feature_code,
    v_edit_gully.gully_type AS featurecat_id,
    v_edit_gully.connec_arccat_id AS arccat_id,
    v_edit_gully.connec_depth AS depth,
    v_edit_gully.connec_length AS length,
    v_edit_gully.gully_id AS upstream_id,
    v_edit_gully.code AS upstream_code,
    v_edit_gully.gully_type AS upstream_type,
    v_edit_gully.ymax - v_edit_gully.sandbox AS upstream_depth,
    gully_type.man_table AS sys_type,
    st_x(v_edit_gully.the_geom) AS x,
    st_y(v_edit_gully.the_geom) AS y
   FROM SCHEMA_NAME.v_edit_gully
     JOIN SCHEMA_NAME.link ON link.feature_id::text = v_edit_gully.gully_id::text
     JOIN SCHEMA_NAME.node ON link.exit_id::text = node.node_id::text
     JOIN SCHEMA_NAME.gully_type ON gully_type.id::text = v_edit_gully.gully_type::text
     WHERE link.feature_type='GULLY';



-- 2018/12/14

DROP VIEW v_om_visit;
CREATE OR REPLACE VIEW v_om_visit AS 
 SELECT om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit_cat.name,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    om_visit_x_node.node_id AS feature_id,
    'NODE'::text as feature_type,
    om_visit.the_geom
   FROM selector_state,
    om_visit
     JOIN om_visit_x_node ON om_visit_x_node.visit_id = om_visit.id
     JOIN node ON node.node_id::text = om_visit_x_node.node_id::text
     JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
  WHERE selector_state.state_id = node.state AND selector_state.cur_user = "current_user"()::text
UNION
 SELECT om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit_cat.name,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    om_visit_x_arc.arc_id AS feature_id,
    'ARC'::text as feature_type,
    om_visit.the_geom
   FROM selector_state,
    om_visit
     JOIN om_visit_x_arc ON om_visit_x_arc.visit_id = om_visit.id
     JOIN arc ON arc.arc_id::text = om_visit_x_arc.arc_id::text
     JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
  WHERE selector_state.state_id = arc.state AND selector_state.cur_user = "current_user"()::text
UNION
 SELECT om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit_cat.name,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    om_visit_x_connec.connec_id AS feature_id,
    'CONNEC'::text as feature_type,
    om_visit.the_geom
   FROM selector_state,
    om_visit
     JOIN om_visit_x_connec ON om_visit_x_connec.visit_id = om_visit.id
     JOIN connec ON connec.connec_id::text = om_visit_x_connec.connec_id::text
     JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
  WHERE selector_state.state_id = connec.state AND selector_state.cur_user = "current_user"()::text
UNION
 SELECT om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit_cat.name,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    om_visit_x_gully.gully_id AS feature_id,
    'CONNEC'::text as feature_type,
    om_visit.the_geom
   FROM selector_state,
    om_visit
     JOIN om_visit_x_gully ON om_visit_x_gully.visit_id = om_visit.id
     JOIN gully ON gully.gully_id::text = om_visit_x_gully.gully_id::text
     JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
  WHERE selector_state.state_id = gully.state AND selector_state.cur_user = "current_user"()::text;
	 
	 
	 