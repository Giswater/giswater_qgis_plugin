/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- View structure for v_arc_x_node
-- ----------------------------

/*

DROP VIEW IF EXISTS v_ui_arc CASCADE;
CREATE VIEW v_ui_arc AS 
SELECT
v_arc_x_node.*,
value_state.name as state_name,
value_state_type.name as state_type_name,
sector.name as sector_name,
dma.name dma_name,
exploitation.name expl_name
FROM v_arc_x_node
JOIN value_state ON v_arc_x_node.state=value_state.id
JOIN value_state_type ON v_arc_x_node.state_type=value_state_type.id
JOIN sector ON v_arc_x_node.sector_id=sector.sector_id
JOIN dma ON v_arc_x_node.dma_id=dma.dma_id
JOIN exploitation ON v_arc_x_node.expl_id=exploitation.expl_id;





DROP VIEW IF EXISTS v_ui_gully CASCADE;
CREATE VIEW v_ui_gully AS 
SELECT
v_edit_gully.*,
value_state.name as state_name,
value_state_type.name as state_type_name,
sector.name as sector_name,
dma.name dma_name,
exploitation.name expl_name
FROM v_edit_gully
JOIN value_state ON v_edit_gully.state=value_state.id
JOIN value_state_type ON v_edit_gully.state_type=value_state_type.id
JOIN sector ON v_edit_gully.sector_id=sector.sector_id
JOIN dma ON v_edit_gully.dma_id=dma.dma_id
JOIN exploitation ON v_edit_gully.expl_id=exploitation.expl_id;



*/

DROP VIEW IF EXISTS v_man_gully CASCADE;
CREATE VIEW v_man_gully AS 
SELECT
gully_id,
the_geom
FROM gully
JOIN selector_state ON gully.state=selector_state.state_id;



DROP VIEW IF EXISTS v_ui_arc_x_relations CASCADE;
CREATE OR REPLACE VIEW v_ui_arc_x_relations AS 
SELECT 
row_number() OVER () +1000000 AS rid,
v_edit_arc.arc_id,
connec_type as featurecat_id,
connecat_id as catalog,
connec_id AS feature_id,
v_edit_connec.code AS feature_code,
v_edit_connec.sys_type,
v_edit_arc.state as arc_state,
v_edit_connec.state as feature_state,
st_x(v_edit_connec.the_geom) AS x,
st_y(v_edit_connec.the_geom) AS y
FROM v_edit_connec
JOIN v_edit_arc ON v_edit_arc.arc_id=v_edit_connec.arc_id
where v_edit_connec.arc_id is not null
UNION
SELECT 
row_number() OVER () +2000000 AS rid,
v_edit_arc.arc_id,
gully_type,
gratecat_id,
gully_id,
v_edit_gully.code,
v_edit_gully.sys_type,
v_edit_arc.state,
v_edit_gully.state,
st_x(v_edit_gully.the_geom) AS x,
st_y(v_edit_gully.the_geom) AS y
FROM v_edit_gully
JOIN v_edit_arc ON v_edit_arc.arc_id=v_edit_gully.arc_id
where v_edit_gully.arc_id is not null;




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



DROP MATERIALIZED VIEW IF EXISTS v_ui_workcat_polygon_aux CASCADE;
CREATE MATERIALIZED VIEW v_ui_workcat_polygon_aux AS 
 WITH workcat_polygon AS (
         SELECT st_collect(a.the_geom) AS locations,
            a.workcat_id
           FROM ( SELECT node.workcat_id,
                    node.the_geom
                   FROM node
                  WHERE node.state = 1
                UNION
                 SELECT arc.workcat_id,
                    arc.the_geom
                   FROM arc
                  WHERE arc.state = 1
                UNION
                 SELECT connec.workcat_id,
                    connec.the_geom
                   FROM connec
                  WHERE connec.state = 1
                UNION
                 SELECT gully.workcat_id,
                    gully.the_geom
                   FROM gully
                  WHERE gully.state = 1
                UNION
                 SELECT element.workcat_id,
                    element.the_geom
                   FROM element
                  WHERE element.state = 1
                UNION
                 SELECT node.workcat_id_end AS workcat_id,
                    node.the_geom
                   FROM node
                  WHERE node.state = 0
                UNION
                 SELECT arc.workcat_id_end AS workcat_id,
                    arc.the_geom
                   FROM arc
                  WHERE arc.state = 0
                UNION
                 SELECT connec.workcat_id_end AS workcat_id,
                    connec.the_geom
                   FROM connec
                  WHERE connec.state = 0
                UNION
                 SELECT gully.workcat_id,
                    gully.the_geom
                   FROM gully
                  WHERE gully.state = 0
                UNION
                 SELECT element.workcat_id_end AS workcat_id,
                    element.the_geom
                   FROM element
                  WHERE element.state = 0) a
          GROUP BY a.workcat_id
        )
 SELECT workcat_polygon.workcat_id,
        CASE
            WHEN st_geometrytype(st_concavehull(workcat_polygon.locations, 0.99::double precision)) = 'ST_Polygon'::text THEN st_buffer(st_concavehull(workcat_polygon.locations, 0.99::double precision), 10::double precision)
            WHEN st_geometrytype(st_concavehull(workcat_polygon.locations, 0.99::double precision)) = 'ST_LineString'::text THEN st_envelope(workcat_polygon.locations)
            ELSE NULL::geometry
        END AS the_geom
   FROM workcat_polygon;
   
	 
	
DROP VIEW IF EXISTS v_ui_workcat_x_feature;
CREATE OR REPLACE VIEW v_ui_workcat_x_feature AS 
 SELECT row_number() OVER (ORDER BY arc.arc_id) + 1000000 AS rid,
    arc.feature_type,
    arc.arccat_id AS featurecat_id,
    arc.arc_id AS feature_id,
    arc.code,
    arc.state,
    arc.workcat_id
   FROM arc
      where state=1
UNION
 SELECT row_number() OVER (ORDER BY node.node_id) + 2000000 AS rid,
    node.feature_type,
    node.nodecat_id AS featurecat_id,
    node.node_id AS feature_id,
    node.code,
    node.state,
    node.workcat_id
   FROM node
      where state=1
UNION
 SELECT row_number() OVER (ORDER BY connec.connec_id) + 3000000 AS rid,
    connec.feature_type,
    connec.connecat_id AS featurecat_id,
    connec.connec_id AS feature_id,
    connec.code,
    connec.state,
    connec.workcat_id
   FROM connec
      where state=1
 UNION 
   	SELECT row_number() OVER (ORDER BY gully.gully_id) + 4000000 AS rid,
	gully.feature_type,
	gully.gratecat_id as featurecat_id,
	gully.gully_id as feature_id,
	gully.code as code,
	gully.state,
	gully.workcat_id
	FROM gully
   where state=1
UNION
 SELECT row_number() OVER (ORDER BY element.element_id) + 5000000 AS rid,
    element.feature_type,
    element.elementcat_id AS featurecat_id,
    element.element_id AS feature_id,
    element.code,
    element.state,
    element.workcat_id
   FROM element
      where state=1;


   

DROP VIEW IF EXISTS v_ui_workcat_x_feature_end;
CREATE OR REPLACE VIEW v_ui_workcat_x_feature_end AS 
 SELECT row_number() OVER (ORDER BY arc.arc_id) + 1000000 AS rid,
    arc.feature_type,
    arc.arccat_id AS featurecat_id,
    arc.arc_id AS feature_id,
    arc.code,
    arc.state,
    arc.workcat_id_end
   FROM arc
      where state=0
UNION
 SELECT row_number() OVER (ORDER BY node.node_id) + 2000000 AS rid,
    node.feature_type,
    node.nodecat_id AS featurecat_id,
    node.node_id AS feature_id,
    node.code,
    node.state,
    node.workcat_id_end
	FROM node
      where state=0

UNION
 SELECT row_number() OVER (ORDER BY connec.connec_id) + 3000000 AS rid,
    connec.feature_type,
    connec.connecat_id AS featurecat_id,
    connec.connec_id AS feature_id,
    connec.code,
    connec.state,
    connec.workcat_id_end
   FROM connec
      where state=0

 UNION 
   	SELECT row_number() OVER (ORDER BY gully.gully_id) + 4000000 AS rid,
	gully.feature_type,
	gully.gratecat_id as featurecat_id,
	gully.gully_id as feature_id,
	gully.code as code,
	gully.state,
	gully.workcat_id_end
	FROM gully
   where state=0
UNION
 SELECT row_number() OVER (ORDER BY element.element_id) + 5000000 AS rid,
    element.feature_type,
    element.elementcat_id AS featurecat_id,
    element.element_id AS feature_id,
    element.code,
    element.state,
    element.workcat_id_end
   FROM element
   where state=0;	 


	
	

CREATE OR REPLACE VIEW v_rtc_scada AS 
 SELECT ext_rtc_scada.scada_id,
    rtc_scada_node.node_id,
    ext_rtc_scada.cat_scada_id,
    ext_rtc_scada.text
   FROM ext_rtc_scada
     JOIN rtc_scada_node ON rtc_scada_node.scada_id::text = ext_rtc_scada.scada_id::text;

   