/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW v_ui_node_x_connection_downstream AS 
 SELECT row_number() OVER (ORDER BY v_edit_arc.node_1)+1000000 AS rid,
    v_edit_arc.node_1 AS node_id,
    v_edit_arc.arc_id AS feature_id,
    v_edit_arc.code AS feature_code,
    v_edit_arc.arc_type AS featurecat_id,
    v_edit_arc.arccat_id,
    v_edit_arc.y2 AS depth,
    st_length2d(v_edit_arc.the_geom)::numeric(12,2) AS length,
    node.node_id AS downstream_id,
    node.code AS downstream_code,
    node.node_type AS downstream_type,
    v_edit_arc.y1 AS downstream_depth,
    sys_type,
    st_x(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS x,
    st_y(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS y,
    cat_arc.descript,
    value_state.name AS state,
    'v_edit_arc' as sys_table_id
   FROM v_edit_arc
     JOIN node ON v_edit_arc.node_2::text = node.node_id::text
     JOIN arc_type ON arc_type.id::text = v_edit_arc.arc_type::text
     LEFT JOIN cat_arc ON v_edit_arc.arccat_id::text = cat_arc.id::text
     JOIN value_state ON v_edit_arc.state = value_state.id;

     

CREATE OR REPLACE VIEW v_ui_node_x_connection_upstream AS 
 SELECT row_number() OVER (ORDER BY v_edit_arc.node_2) + 1000000 AS rid,
    v_edit_arc.node_2 AS node_id,
    v_edit_arc.arc_id AS feature_id,
    v_edit_arc.code AS feature_code,
    v_edit_arc.arc_type AS featurecat_id,
    v_edit_arc.arccat_id,
    v_edit_arc.y1 AS depth,
    st_length2d(v_edit_arc.the_geom)::numeric(12,2) AS length,
    node.node_id AS upstream_id,
    node.code AS upstream_code,
    node.node_type AS upstream_type,
    v_edit_arc.y2 AS upstream_depth,
    v_edit_arc.sys_type,
    st_x(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS x,
    st_y(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS y,
    cat_arc.descript,
    value_state.name AS state,
    'v_edit_arc' as sys_table_id
   FROM v_edit_arc
     JOIN node ON v_edit_arc.node_1::text = node.node_id::text
     JOIN arc_type ON arc_type.id::text = v_edit_arc.arc_type::text
     LEFT JOIN cat_arc ON v_edit_arc.arccat_id=cat_arc.id
     JOIN value_state ON v_edit_arc.state = value_state.id
UNION
 SELECT row_number() OVER (ORDER BY node.node_id) + 2000000 AS rid,
    node.node_id,
    v_edit_connec.connec_id AS feature_id,
    v_edit_connec.code::text AS feature_code,
    v_edit_connec.connec_type AS featurecat_id,
    v_edit_connec.connecat_id AS arccat_id,
    v_edit_connec.y1 AS depth,
    st_length2d(link.the_geom)::numeric(12,2) AS length,
    v_edit_connec.connec_id AS upstream_id,
    v_edit_connec.code AS upstream_code,
    v_edit_connec.connec_type AS upstream_type,
    v_edit_connec.y2 AS upstream_depth,
    v_edit_connec.sys_type,
    st_x(v_edit_connec.the_geom) AS x,
    st_y(v_edit_connec.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    'v_edit_connec' as sys_table_id
   FROM v_edit_connec
     JOIN link ON link.feature_id::text = v_edit_connec.connec_id::text AND link.feature_type::text = 'CONNEC'::text
     JOIN node ON link.exit_id::text = node.node_id::text AND link.exit_type::text = 'NODE'::text
     JOIN connec_type ON connec_type.id::text = v_edit_connec.connec_type::text
     LEFT JOIN cat_connec ON v_edit_connec.connecat_id=cat_connec.id
     JOIN value_state ON v_edit_connec.state = value_state.id
UNION
 SELECT row_number() OVER (ORDER BY node.node_id) + 3000000 AS rid,
    node.node_id,
    v_edit_gully.gully_id AS feature_id,
    v_edit_gully.code::text AS feature_code,
    v_edit_gully.gully_type AS featurecat_id,
    v_edit_gully.connec_arccat_id AS arccat_id,
    v_edit_gully.ymax - v_edit_gully.sandbox AS depth,
    v_edit_gully.connec_length AS length,
    v_edit_gully.gully_id AS upstream_id,
    v_edit_gully.code AS upstream_code,
    v_edit_gully.gully_type AS upstream_type,
    v_edit_gully.connec_depth AS upstream_depth,
    v_edit_gully.sys_type,
    st_x(v_edit_gully.the_geom) AS x,
    st_y(v_edit_gully.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    'v_edit_gully' as sys_table_id
   FROM v_edit_gully
     JOIN link ON link.feature_id::text = v_edit_gully.gully_id::text AND link.feature_type::text = 'GULLY'::text
     JOIN node ON link.exit_id::text = node.node_id::text AND link.exit_type::text = 'NODE'::text
     JOIN gully_type ON gully_type.id::text = v_edit_gully.gully_type::text
     LEFT JOIN cat_connec ON v_edit_gully.connec_arccat_id = cat_connec.id
     JOIN value_state ON v_edit_gully.state = value_state.id;