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
            WHEN st_geometrytype(st_concavehull(workcat_polygon.locations, 0.99::double precision)) = 'ST_Polygon'::text 
            THEN st_buffer(st_concavehull(workcat_polygon.locations, 0.99::double precision), 10::double precision)::geometry(polygon, SRID_VALUE)
            ELSE (st_expand(st_buffer(workcat_polygon.locations,10),1))::geometry(polygon, SRID_VALUE)
        END AS the_geom
   FROM workcat_polygon
   WHERE workcat_id IS NOT NULL;
	

  
DROP VIEW IF EXISTS v_ui_workcat_x_feature CASCADE;
CREATE OR REPLACE VIEW v_ui_workcat_x_feature AS 
 SELECT row_number() OVER (ORDER BY arc.arc_id) + 1000000 AS rid,
    arc.feature_type,
    arc.arccat_id AS featurecat_id,
    arc.arc_id AS feature_id,
    arc.code,
    exploitation.name AS expl_name,
    arc.workcat_id,
	exploitation.expl_id
   FROM arc
   JOIN exploitation ON exploitation.expl_id=arc.expl_id
   where state=1
UNION
 SELECT row_number() OVER (ORDER BY node.node_id) + 2000000 AS rid,
    node.feature_type,
    node.nodecat_id AS featurecat_id,
    node.node_id AS feature_id,
    node.code,
    exploitation.name AS expl_name,
    node.workcat_id,
	exploitation.expl_id
	FROM node
   JOIN exploitation ON exploitation.expl_id=node.expl_id
   where state=1
UNION
 SELECT row_number() OVER (ORDER BY connec.connec_id) + 3000000 AS rid,
    connec.feature_type,
    connec.connecat_id AS featurecat_id,
    connec.connec_id AS feature_id,
    connec.code,
    exploitation.name AS expl_name,
    connec.workcat_id,
	exploitation.expl_id
   FROM connec
   JOIN exploitation ON exploitation.expl_id=connec.expl_id
   where state=1
UNION
 SELECT row_number() OVER (ORDER BY element.element_id) + 4000000 AS rid,
    element.feature_type,
    element.elementcat_id AS featurecat_id,
    element.element_id AS feature_id,
    element.code,
    exploitation.name AS expl_name,
    element.workcat_id,
	exploitation.expl_id
   FROM element
   JOIN exploitation ON exploitation.expl_id=element.expl_id
   where state=1;


   
DROP VIEW IF EXISTS v_ui_workcat_x_feature_end CASCADE;
CREATE OR REPLACE VIEW v_ui_workcat_x_feature_end AS 
 SELECT row_number() OVER (ORDER BY arc_id) + 1000000 AS rid,
    'ARC'::varchar as feature_type,
    v_edit_arc.arccat_id AS featurecat_id,
    v_edit_arc.arc_id AS feature_id,
    v_edit_arc.code,
    exploitation.name AS expl_name,
    v_edit_arc.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_arc
     JOIN exploitation ON exploitation.expl_id = v_edit_arc.expl_id
  WHERE v_edit_arc.state = 0
UNION
 SELECT row_number() OVER (ORDER BY node_id) + 2000000 AS rid,
    'NODE',
    v_edit_node.nodecat_id AS featurecat_id,
    v_edit_node.node_id AS feature_id,
    v_edit_node.code,
    exploitation.name AS expl_name,
    v_edit_node.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_node
     JOIN exploitation ON exploitation.expl_id = v_edit_node.expl_id
  WHERE v_edit_node.state = 0
UNION
 SELECT row_number() OVER (ORDER BY connec_id) + 3000000 AS rid,
    'CONNEC',
    v_edit_connec.connecat_id AS featurecat_id,
    v_edit_connec.connec_id AS feature_id,
    v_edit_connec.code,
    exploitation.name AS expl_name,
    v_edit_connec.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_connec
     JOIN exploitation ON exploitation.expl_id = v_edit_connec.expl_id
  WHERE v_edit_connec.state = 0
UNION
 SELECT row_number() OVER (ORDER BY element_id) + 4000000 AS rid,
    'ELEMENT',
    v_edit_element.elementcat_id AS featurecat_id,
    v_edit_element.element_id AS feature_id,
    v_edit_element.code,
    exploitation.name AS expl_name,
    v_edit_element.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_element
     JOIN exploitation ON exploitation.expl_id = v_edit_element.expl_id
  WHERE v_edit_element.state = 0;


DROP VIEW IF EXISTS v_ui_node_x_relations CASCADE;
CREATE OR REPLACE VIEW v_ui_node_x_relations AS 
SELECT row_number() OVER (ORDER BY node_id) AS rid,
parent_id as node_id,
nodetype_id,
nodecat_id,
node_id as child_id,
code,
sys_type
FROM v_edit_node where parent_id is not null;