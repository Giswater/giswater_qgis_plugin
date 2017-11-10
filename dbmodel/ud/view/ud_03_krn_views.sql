/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- View structure for v_arc_x_node
-- ----------------------------

DROP VIEW IF EXISTS v_man_gully CASCADE;
CREATE VIEW v_man_gully AS 
SELECT
gully_id,
the_geom
FROM gully
JOIN selector_state ON gully.state=selector_state.state_id
;



CREATE OR REPLACE VIEW v_ui_arc_x_connection AS 
SELECT row_number() OVER (ORDER BY v_edit_arc.arc_id) AS rid,
v_edit_arc.arc_id,
connec.connec_id AS feature_id,
connec.code AS feature_code,
connec.feature_type
FROM v_edit_arc
JOIN connec ON connec.arc_id=v_edit_arc.arc_id
UNION
SELECT row_number() OVER (ORDER BY v_edit_arc.arc_id) AS rid,
v_edit_arc.arc_id,
gully.gully_id AS feature_id,
gully.code AS feature_code,
gully.feature_type
FROM v_edit_arc
JOIN gully ON gully.arc_id=v_edit_arc.arc_id;



DROP VIEW IF EXISTS v_ui_element_x_gully CASCADE;
CREATE OR REPLACE VIEW v_ui_element_x_gully AS
SELECT
element_x_gully.id,
element_x_gully.gully_id,
element_x_gully.element_id,
element.elementcat_id,
element.num_elements,
element.state,
element.observ,
element.comment,
element.builtdate,
element.enddate
FROM element_x_gully
JOIN element ON element.element_id = element_x_gully.element_id;



DROP VIEW IF EXISTS SCHEMA_NAME.v_ui_node_x_connection_downstream;
CREATE OR REPLACE VIEW SCHEMA_NAME.v_ui_node_x_connection_downstream AS 
 SELECT 
row_number() OVER (ORDER BY v_edit_arc.node_2) AS rid,
v_edit_arc.node_2 AS node_id,
 v_edit_arc.arc_id AS feature_id,
    v_edit_arc.code AS feature_code,
    v_edit_arc.arc_type AS featurecat_id,
    v_edit_arc.arccat_id,
    v_edit_arc.y1 AS depth,
    st_length2d(v_edit_arc.the_geom)::numeric(12,2) AS length,
    node.node_id AS downstream_id,
    node.code AS downstream_code,
    node.node_type AS downstream_type,
    v_edit_arc.y2 AS downstream_depth
   FROM SCHEMA_NAME.v_edit_arc
     JOIN SCHEMA_NAME.node ON v_edit_arc.node_1::text = node.node_id::text;


     DROP VIEW IF EXISTS SCHEMA_NAME.v_ui_node_x_connection_upstream;

CREATE OR REPLACE VIEW SCHEMA_NAME.v_ui_node_x_connection_upstream AS 
 SELECT 
row_number() OVER (ORDER BY v_edit_arc.node_1) AS rid,
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
    v_edit_arc.y1 AS upstream_depth
   FROM SCHEMA_NAME.v_edit_arc
     JOIN SCHEMA_NAME.node ON v_edit_arc.node_2::text = node.node_id::text

UNION
 SELECT 
row_number() OVER (ORDER BY node_id) AS rid,
node_id,
 link.link_id::text AS feature_id,
    NULL::character varying AS feature_code,
    v_edit_connec.connec_type AS featurecat_id,
    v_edit_connec.connecat_id AS arccat_id,
    v_edit_connec.y2 AS depth,
    st_length2d(link.the_geom)::numeric(12,2) AS length,
    v_edit_connec.connec_id AS upstream_id,
    v_edit_connec.code AS upstream_code,
    v_edit_connec.connec_type AS upstream_type,
    v_edit_connec.y1 AS upstream_depth
   FROM SCHEMA_NAME.v_edit_connec
     JOIN SCHEMA_NAME.link ON link.feature_id::text = v_edit_connec.connec_id::text AND link.feature_type::text = v_edit_connec.connec_type::text
     JOIN SCHEMA_NAME.node ON link.exit_id=node_id AND link.exit_type='NODE'
UNION
 SELECT 
row_number() OVER (ORDER BY node_id) AS rid,
node_id,
 link.link_id::text AS feature_id,
    NULL::character varying AS feature_code,
    v_edit_gully.gully_type AS featurecat_id,
    v_edit_gully.connec_arccat_id AS arccat_id,
    v_edit_gully.connec_depth AS depth,
    v_edit_gully.connec_length AS length,
    v_edit_gully.gully_id AS upstream_id,
    v_edit_gully.code AS upstream_code,
    v_edit_gully.gully_type AS upstream_type,
    v_edit_gully.ymax - v_edit_gully.sandbox AS upstream_depth
   FROM SCHEMA_NAME.v_edit_gully
     JOIN SCHEMA_NAME.link ON link.feature_id::text = v_edit_gully.gully_id::text AND link.feature_type::text = v_edit_gully.gully_type::text
     JOIN SCHEMA_NAME.node ON link.exit_id=node_id AND link.exit_type='NODE';
     

