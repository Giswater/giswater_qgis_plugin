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

