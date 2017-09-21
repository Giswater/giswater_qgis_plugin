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
SELECT
arc_id as feature_id,
v_edit_arc.code as feature_code,
arc_type AS featurecat_id,
arccat_id,
y2 AS depth,
st_length2d(v_edit_arc.the_geom)::numeric(12,2) AS length,
node_id AS upstream_id,
node.code AS upstream_code,
node_type AS upstream_type,
y1 AS upstream_depth
FROM v_edit_arc
JOIN node ON node_2=node_id
UNION
SELECT
link_id::text AS feature_id,
NULL AS feature_code,
'Link' AS featurecat_id,
connecat_id AS arccat_id,
y2 AS depth, 
st_length2d(link.the_geom)::numeric(12,2) AS length,
connec_id AS upstream_id,
code as upstream_code,
connec_type AS upstream_type,
y1 AS upstream_depth
FROM v_edit_connec
JOIN link ON link.feature_id=connec_id AND link.featurecat_id=connec_type
UNION
SELECT
link_id::text AS feature_id,
NULL AS feature_code,
'Link' AS featurecat_id,
connec_arccat_id AS arccat_id,
connec_depth AS depth,
connec_length AS length,
gully_id AS upstream_id,
code AS upstream_code,
gully_type AS upstream_type,
ymax - sandbox AS upstream_depth
FROM v_edit_gully
JOIN link ON link.feature_id=gully_id AND link.featurecat_id=gully_type;




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


