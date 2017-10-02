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



DROP VIEW IF EXISTS v_ui_element_x_gully CASCADE;
CREATE OR REPLACE VIEW v_ui_element_x_gully AS
SELECT
element_x_gully.id,
element_x_gully.gully_id,
element_x_gully.element_id,
element.elementcat_id,
element.state,
element.observ,
element.comment,
element.builtdate,
element.enddate
FROM element_x_gully
JOIN element ON element.element_id = element_x_gully.element_id;



DROP VIEW IF EXISTS v_ui_node_x_connection_upstream CASCADE;
CREATE OR REPLACE VIEW v_ui_node_x_connection_upstream AS 
 SELECT v_edit_arc.arc_id AS feature_id,
    v_edit_arc.code AS feature_code,
    v_edit_arc.arc_type AS featurecat_id,
    v_edit_arc.arccat_id,
    v_edit_arc.y2 AS depth,
    st_length2d(v_edit_arc.the_geom)::numeric(12,2) AS length,
    node.node_id AS upstream_id,
    node.code AS upstream_code,
    node.node_type AS upstream_type,
    v_edit_arc.y1 AS upstream_depth
   FROM ud30.v_edit_arc
     JOIN ud30.node ON v_edit_arc.node_2::text = node.node_id::text
UNION
 SELECT link.link_id::text AS feature_id,
    v_edit_connec.feature_code,
    v_edit_connec.connec_type AS featurecat_id,
    v_edit_connec.connecat_id AS arccat_id,
    v_edit_connec.y2 AS depth,
    st_length2d(link.the_geom)::numeric(12,2) AS length,
    v_edit_connec.connec_id AS upstream_id,
    v_edit_connec.code AS upstream_code,
    v_edit_connec.connec_type AS upstream_type,
    v_edit_connec.y1 AS upstream_depth
   FROM ud30.v_edit_connec
     JOIN ud30.link ON link.feature_id::text = v_edit_connec.connec_id::text AND link.featurecat_id::text = v_edit_connec.connec_type::text
UNION
 SELECT link.link_id::text AS feature_id,
    v_edit_gully.feature_code,
    v_edit_gully.gully_type AS featurecat_id,
    v_edit_gully.connec_arccat_id AS arccat_id,
    v_edit_gully.connec_depth AS depth,
    v_edit_gully.connec_length AS length,
    v_edit_gully.gully_id AS upstream_id,
    v_edit_gully.code AS upstream_code,
    v_edit_gully.gully_type AS upstream_type,
    v_edit_gully.ymax - v_edit_gully.sandbox AS upstream_depth
   FROM ud30.v_edit_gully
     JOIN ud30.link ON link.feature_id::text = v_edit_gully.gully_id::text AND link.featurecat_id::text = v_edit_gully.gully_type::text;





DROP VIEW IF EXISTS v_ui_node_x_connection_downstream CASCADE;
CREATE OR REPLACE VIEW v_ui_node_x_connection_downstream AS
SELECT
arc_id as feature_id,
v_edit_arc.code as feature_code,
arc_type AS featurecat_id,
arccat_id,
y1 AS depth,
st_length2d(v_edit_arc.the_geom)::numeric(12,2) AS length,
node_id AS downstream_id,
node.code AS downstream_code,
node_type AS downstream_type,
y2 AS downstream_depth
FROM v_edit_arc
JOIN node ON node_1=node_id


