/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 02/02/2026

CREATE OR REPLACE VIEW v_ui_doc
AS SELECT id,
    name,
    observ,
    doc_type,
    path,
    date,
    user_name,
    tstamp
   FROM doc;

CREATE OR REPLACE VIEW v_ui_doc_x_psector
AS SELECT doc_x_psector.doc_id,
    plan_psector.name AS psector_name,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_psector
     JOIN doc ON doc.id::text = doc_x_psector.doc_id::text
     JOIN plan_psector ON plan_psector.psector_id::text = doc_x_psector.psector_id::text;


CREATE OR REPLACE VIEW v_ui_doc_x_visit
AS SELECT doc_x_visit.doc_id,
    doc_x_visit.visit_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_visit
     JOIN doc ON doc.id::text = doc_x_visit.doc_id::text;


CREATE OR REPLACE VIEW v_ui_doc_x_workcat
AS SELECT doc_x_workcat.doc_id,
    doc_x_workcat.workcat_id,
    doc.name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_workcat
     JOIN doc ON doc.id::text = doc_x_workcat.doc_id::text;


CREATE OR REPLACE VIEW v_ui_doc_x_node
AS SELECT doc_x_node.doc_id,
    doc_x_node.node_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name,
    doc_x_node.node_uuid
   FROM doc_x_node
     JOIN doc ON doc.id::text = doc_x_node.doc_id::text;


CREATE OR REPLACE VIEW v_ui_doc_x_arc
AS SELECT doc_x_arc.doc_id,
    doc_x_arc.arc_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name,
    doc_x_arc.arc_uuid
   FROM doc_x_arc
     JOIN doc ON doc.id::text = doc_x_arc.doc_id::text;


CREATE OR REPLACE VIEW v_ui_doc_x_connec
AS SELECT doc_x_connec.doc_id,
    doc_x_connec.connec_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name,
    doc_x_connec.connec_uuid
   FROM doc_x_connec
     JOIN doc ON doc.id::text = doc_x_connec.doc_id::text;


CREATE OR REPLACE VIEW v_ui_doc_x_gully
AS SELECT doc_x_gully.doc_id,
    doc_x_gully.gully_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name,
    doc_x_gully.gully_uuid
   FROM doc_x_gully
     JOIN doc ON doc.id::text = doc_x_gully.doc_id::text;


CREATE OR REPLACE VIEW v_ui_doc_x_link
AS SELECT doc_x_link.doc_id,
    doc_x_link.link_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name,
    doc_x_link.link_uuid
   FROM doc_x_link
     JOIN doc ON doc.id::text = doc_x_link.doc_id::text;


CREATE OR REPLACE VIEW v_ui_doc_x_element
AS SELECT doc_x_element.doc_id,
    doc_x_element.element_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name,
    doc_x_element.element_uuid
   FROM doc_x_element
     JOIN doc ON doc.id::text = doc_x_element.doc_id::text;

CREATE OR REPLACE VIEW v_ui_om_visit_x_doc
AS SELECT doc_id,
    visit_id
   FROM doc_x_visit;

-- 10/02/2026
CREATE OR REPLACE VIEW v_ui_node_x_connection_downstream
AS SELECT row_number() OVER (ORDER BY ve_arc.node_1) + 1000000 AS rid,
    ve_arc.node_1 AS node_id,
    ve_arc.arc_id AS feature_id,
    ve_arc.code AS feature_code,
    ve_arc.arc_type AS featurecat_id,
    ve_arc.arccat_id,
    ve_arc.y2 AS depth,
    st_length2d(ve_arc.the_geom)::numeric(12,2) AS length,
    node.node_id AS downstream_id,
    node.code AS downstream_code,
    node.node_type::text AS downstream_type,
    ve_arc.y1 AS downstream_depth,
    ve_arc.sys_type,
    st_x(st_lineinterpolatepoint(ve_arc.the_geom, 0.5::double precision)) AS x,
    st_y(st_lineinterpolatepoint(ve_arc.the_geom, 0.5::double precision)) AS y,
    cat_arc.descript,
    value_state.name AS state,
    've_arc'::text AS sys_table_id
   FROM ve_arc
     JOIN node ON ve_arc.node_2 = node.node_id
     LEFT JOIN cat_arc ON ve_arc.arccat_id::text = cat_arc.id::text
     JOIN value_state ON ve_arc.state = value_state.id;


CREATE OR REPLACE VIEW v_ui_node_x_connection_upstream
AS SELECT row_number() OVER (ORDER BY ve_arc.node_2) + 1000000 AS rid,
    ve_arc.node_2 AS node_id,
    ve_arc.arc_id AS feature_id,
    ve_arc.code AS feature_code,
    ve_arc.arc_type AS featurecat_id,
    ve_arc.arccat_id,
    ve_arc.y1 AS depth,
    st_length2d(ve_arc.the_geom)::numeric(12,2) AS length,
    node.node_id AS upstream_id,
    node.code AS upstream_code,
    node.node_type AS upstream_type,
    ve_arc.y2 AS upstream_depth,
    ve_arc.sys_type,
    st_x(st_lineinterpolatepoint(ve_arc.the_geom, 0.5::double precision)) AS x,
    st_y(st_lineinterpolatepoint(ve_arc.the_geom, 0.5::double precision)) AS y,
    cat_arc.descript,
    value_state.name AS state,
    've_arc'::text AS sys_table_id
   FROM ve_arc
     JOIN node ON ve_arc.node_1 = node.node_id
     LEFT JOIN cat_arc ON ve_arc.arccat_id::text = cat_arc.id::text
     JOIN value_state ON ve_arc.state = value_state.id
UNION
 SELECT DISTINCT ON (ve_connec.connec_id) row_number() OVER (ORDER BY node.node_id) + 2000000 AS rid,
    node.node_id,
    ve_connec.connec_id AS feature_id,
    ve_connec.code AS feature_code,
    ve_connec.connec_type AS featurecat_id,
    ve_connec.conneccat_id AS arccat_id,
    ve_connec.y1 AS depth,
    st_length2d(link.the_geom)::numeric(12,2) AS length,
    ve_connec.connec_id AS upstream_id,
    ve_connec.code AS upstream_code,
    ve_connec.connec_type AS upstream_type,
    ve_connec.y2 AS upstream_depth,
    ve_connec.sys_type,
    st_x(ve_connec.the_geom) AS x,
    st_y(ve_connec.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    've_connec'::text AS sys_table_id
   FROM ve_connec
     JOIN link ON link.feature_id = ve_connec.connec_id AND link.feature_type::text = 'CONNEC'::text
     JOIN node ON ve_connec.pjoint_id = node.node_id AND ve_connec.pjoint_type::text = 'NODE'::text
     LEFT JOIN cat_connec ON ve_connec.conneccat_id::text = cat_connec.id::text
     JOIN value_state ON ve_connec.state = value_state.id
UNION
 SELECT DISTINCT ON (ve_connec.connec_id) row_number() OVER (ORDER BY node.node_id) + 3000000 AS rid,
    node.node_id,
    ve_connec.connec_id AS feature_id,
    ve_connec.code AS feature_code,
    ve_connec.connec_type AS featurecat_id,
    ve_connec.conneccat_id AS arccat_id,
    ve_connec.y1 AS depth,
    st_length2d(link.the_geom)::numeric(12,2) AS length,
    ve_connec.connec_id AS upstream_id,
    ve_connec.code AS upstream_code,
    ve_connec.connec_type AS upstream_type,
    ve_connec.y2 AS upstream_depth,
    ve_connec.sys_type,
    st_x(ve_connec.the_geom) AS x,
    st_y(ve_connec.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    've_connec'::text AS sys_table_id
   FROM ve_connec
     JOIN link ON link.feature_id = ve_connec.connec_id AND link.feature_type::text = 'CONNEC'::text AND link.exit_type::text = 'CONNEC'::text
     JOIN connec ON connec.connec_id = link.exit_id AND connec.pjoint_type::text = 'NODE'::text
     JOIN node ON connec.pjoint_id = node.node_id
     LEFT JOIN cat_connec ON ve_connec.conneccat_id::text = cat_connec.id::text
     JOIN value_state ON ve_connec.state = value_state.id
UNION
 SELECT DISTINCT ON (ve_gully.gully_id) row_number() OVER (ORDER BY node.node_id) + 4000000 AS rid,
    node.node_id,
    ve_gully.gully_id AS feature_id,
    ve_gully.code AS feature_code,
    ve_gully.gully_type AS featurecat_id,
    ve_gully.connec_arccat_id AS arccat_id,
    ve_gully.ymax - ve_gully.sandbox AS depth,
    ve_gully.connec_length AS length,
    ve_gully.gully_id AS upstream_id,
    ve_gully.code AS upstream_code,
    ve_gully.gully_type AS upstream_type,
    ve_gully.connec_depth AS upstream_depth,
    ve_gully.sys_type,
    st_x(ve_gully.the_geom) AS x,
    st_y(ve_gully.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    've_gully'::text AS sys_table_id
   FROM ve_gully
     JOIN link ON link.feature_id = ve_gully.gully_id AND link.feature_type::text = 'GULLY'::text
     JOIN node ON ve_gully.pjoint_id = node.node_id AND ve_gully.pjoint_type::text = 'NODE'::text
     LEFT JOIN cat_connec ON ve_gully.connec_arccat_id::text = cat_connec.id::text
     JOIN value_state ON ve_gully.state = value_state.id
UNION
 SELECT DISTINCT ON (ve_gully.gully_id) row_number() OVER (ORDER BY node.node_id) + 5000000 AS rid,
    node.node_id,
    ve_gully.gully_id AS feature_id,
    ve_gully.code AS feature_code,
    ve_gully.gully_type AS featurecat_id,
    ve_gully.connec_arccat_id AS arccat_id,
    ve_gully.ymax - ve_gully.sandbox AS depth,
    ve_gully.connec_length AS length,
    ve_gully.gully_id AS upstream_id,
    ve_gully.code AS upstream_code,
    ve_gully.gully_type AS upstream_type,
    ve_gully.connec_depth AS upstream_depth,
    ve_gully.sys_type,
    st_x(ve_gully.the_geom) AS x,
    st_y(ve_gully.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    've_gully'::text AS sys_table_id
   FROM ve_gully
     JOIN link ON link.feature_id = ve_gully.gully_id AND link.feature_type::text = 'GULLY'::text AND link.exit_type::text = 'GULLY'::text
     JOIN gully ON gully.gully_id = link.exit_id AND gully.pjoint_type::text = 'NODE'::text
     JOIN node ON gully.pjoint_id = node.node_id
     LEFT JOIN cat_connec ON ve_gully.connec_arccat_id::text = cat_connec.id::text
     JOIN value_state ON ve_gully.state = value_state.id;
