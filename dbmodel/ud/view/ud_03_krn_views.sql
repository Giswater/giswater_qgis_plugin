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



CREATE OR REPLACE VIEW v_ui_arc_x_relations AS 
SELECT 
row_number() OVER (ORDER BY arc_id)+1000000 AS rid,
arc_id,
connec_type as featurecat_id,
connecat_id as catalog,
connec_id AS feature_id,
code AS feature_code,
sys_type,
st_x(v_edit_connec.the_geom) AS x,
st_y(v_edit_connec.the_geom) AS y
FROM v_edit_connec where arc_id is not null
UNION
SELECT 
row_number() OVER (ORDER BY arc_id)+2000000 AS rid,
arc_id,
gully_type,
gratecat_id,
gully_id,
code,
sys_type,
st_x(v_edit_gully.the_geom) AS x,
st_y(v_edit_gully.the_geom) AS y
FROM v_edit_gully where arc_id is not null;



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
JOIN element ON element.element_id = element_x_gully.element_id
WHERE state=1;



DROP VIEW IF EXISTS v_ui_node_x_connection_downstream;
CREATE OR REPLACE VIEW v_ui_node_x_connection_downstream AS 
 SELECT row_number() OVER (ORDER BY v_edit_arc.node_2) AS rid,
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
    v_edit_arc.y2 AS downstream_depth,
	sys_type,
    st_x(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS x,
    st_y(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS y
   FROM v_edit_arc
     JOIN node ON v_edit_arc.node_1::text = node.node_id::text
     JOIN arc_type ON arc_type.id::text = v_edit_arc.arc_type::text;


	 

DROP VIEW IF EXISTS "v_ui_node_x_connection_upstream";
CREATE OR REPLACE VIEW "v_ui_node_x_connection_upstream" AS 
 SELECT row_number() OVER (ORDER BY v_edit_arc.node_1)+1000000 AS rid,
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
    sys_type,
    st_x(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS x,
    st_y(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS y
   FROM v_edit_arc
     JOIN node ON v_edit_arc.node_2::text = node.node_id::text
     JOIN arc_type ON arc_type.id::text = v_edit_arc.arc_type::text
UNION
 SELECT row_number() OVER (ORDER BY node.node_id)+2000000 AS rid,
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
	sys_type,
    st_x(v_edit_connec.the_geom) AS x,
    st_y(v_edit_connec.the_geom) AS y
   FROM v_edit_connec
     JOIN link ON link.feature_id::text = v_edit_connec.connec_id::text AND link.feature_type::text = v_edit_connec.connec_type::text
     JOIN node ON link.exit_id::text = node.node_id::text AND link.exit_type::text = 'NODE'::text
     JOIN connec_type ON connec_type.id::text = v_edit_connec.connec_type::text
UNION
 SELECT row_number() OVER (ORDER BY node.node_id)+3000000 AS rid,
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
    gully_type.man_table AS feature_table,
    st_x(v_edit_gully.the_geom) AS x,
    st_y(v_edit_gully.the_geom) AS y
   FROM v_edit_gully
     JOIN link ON link.feature_id::text = v_edit_gully.gully_id::text AND link.feature_type::text = v_edit_gully.gully_type::text
     JOIN node ON link.exit_id::text = node.node_id::text AND link.exit_type::text = 'NODE'::text
     JOIN gully_type ON gully_type.id::text = v_edit_gully.gully_type::text;

	 
DROP VIEW IF EXISTS v_ui_workcat_x_feature;
 CREATE VIEW v_ui_workcat_x_feature as
 SELECT
	arc.feature_type,
	arc.arccat_id as featurecat_id,
	arc.arc_id as feature_id,
	arc.code as code,
	arc.state,
	arc.workcat_id,
	arc.workcat_id_end
	FROM arc
UNION
	SELECT
	node.feature_type,
	node.nodecat_id as featurecat_id,
	node.node_id as feature_id,
	node.code as code,
	node.state,
	node.workcat_id,
	node.workcat_id_end
	FROM node
UNION
	SELECT
	connec.feature_type,
	connec.connecat_id as featurecat_id,
	connec.connec_id as feature_id,
	connec.code as code,
	connec.state,
	connec.workcat_id,
	connec.workcat_id_end	
	FROM connec
UNION
	SELECT
	gully.feature_type,
	gully.gratecat_id as featurecat_id,
	gully.gully_id as feature_id,
	gully.code as code,
	gully.state,
	gully.workcat_id,
	gully.workcat_id_end	
	FROM gully
UNION 
	SELECT
	element.feature_type,
	element.elementcat_id as featurecat_id,
	element.element_id as feature_id,
	element.code as code,
	element.state,
	element.workcat_id,
	element.workcat_id_end	
	FROM element;


   