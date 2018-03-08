/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


DROP VIEW IF EXISTS v_ui_workcat_polygon;
CREATE OR REPLACE VIEW v_ui_workcat_polygon AS 
WITH workcat_polygon AS (
    SELECT
        ST_Collect(the_geom) AS locations,
        workcat_id
    FROM (select workcat_id, the_geom from node where state=1 union select workcat_id, the_geom 
	from arc where state=1 union select workcat_id, the_geom from connec where state=1 union select workcat_id, the_geom from element 
	where state=1 union select workcat_id_end as workcat_id, the_geom from node where state=0 union select workcat_id_end as workcat_id, the_geom 
	from arc where state=0 union select workcat_id_end as workcat_id, the_geom from connec where state=0
	union select workcat_id_end as workcat_id, the_geom from element) a
    GROUP BY workcat_id
)
SELECT
workcat_polygon.workcat_id,
    CASE 
    WHEN st_geometrytype(ST_ConcaveHull(locations, 0.99))= 'ST_Polygon' THEN  (ST_ConcaveHull(locations, 0.99))
    WHEN st_geometrytype(ST_ConcaveHull(locations, 0.99))= 'ST_LineString' THEN st_envelope (locations) END AS the_geom
FROM workcat_polygon, selector_workcat
WHERE workcat_polygon.workcat_id=selector_workcat.workcat_id AND selector_workcat.cur_user=current_user;




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
    arc.workcat_id_end AS workcat_id
   FROM arc
   where state=0

UNION
 SELECT row_number() OVER (ORDER BY node.node_id) + 2000000 AS rid,
    node.feature_type,
    node.nodecat_id AS featurecat_id,
    node.node_id AS feature_id,
    node.code,
    node.state,
    node.workcat_id_end AS workcat_id
   FROM node
   where state=0

UNION
 SELECT row_number() OVER (ORDER BY connec.connec_id) + 3000000 AS rid,
    connec.feature_type,
    connec.connecat_id AS featurecat_id,
    connec.connec_id AS feature_id,
    connec.code,
    connec.state,
    connec.workcat_id_end AS workcat_id
   FROM connec
   where state=0

UNION
 SELECT row_number() OVER (ORDER BY element.element_id) + 4000000 AS rid,
    element.feature_type,
    element.elementcat_id AS featurecat_id,
    element.element_id AS feature_id,
    element.code,
    element.state,
    element.workcat_id_end AS workcat_id
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