/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


/*

DROP VIEW IF EXISTS v_ui_arc CASCADE;
CREATE VIEW v_ui_arc AS 
SELECT
v_arc.*,
value_state.name as state_name,
value_state_type.name as state_type_name,
sector.name as sector_name,
dma.name dma_name,
exploitation.name expl_name
FROM v_arc
JOIN value_state ON v_arc.state=value_state.id
JOIN value_state_type ON v_arc.state_type=value_state_type.id
JOIN sector ON v_arc.sector_id=sector.sector_id
JOIN dma ON v_arc.dma_id=dma.dma_id
JOIN exploitation ON v_arc.expl_id=exploitation.expl_id;


*/


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
 SELECT row_number() OVER (ORDER BY element.element_id) + 4000000 AS rid,
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
 SELECT row_number() OVER (ORDER BY element.element_id) + 4000000 AS rid,
    element.feature_type,
    element.elementcat_id AS featurecat_id,
    element.element_id AS feature_id,
    element.code,
    element.state,
    element.workcat_id_end
   FROM element
   where state=0;
	
	

DROP VIEW IF EXISTS v_ui_node_x_relations;
CREATE OR REPLACE VIEW v_ui_node_x_relations AS 
SELECT row_number() OVER (ORDER BY node_id) AS rid,
parent_id,
nodetype_id,
nodecat_id,
node_id,
code,
sys_type
FROM v_edit_node where parent_id is not null and parent_id in (select node_id from SCHEMA_NAME.v_edit_node);