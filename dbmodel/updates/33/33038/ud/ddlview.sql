/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/06/04

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
   WHERE state=1 AND arc.workcat_id IS NOT NULL
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
   WHERE state=1 AND node.workcat_id IS NOT NULL
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
   WHERE state=1 AND connec.workcat_id IS NOT NULL
 UNION 
   	SELECT row_number() OVER (ORDER BY gully.gully_id) + 4000000 AS rid,
	gully.feature_type,
	gully.gratecat_id as featurecat_id,
	gully.gully_id as feature_id,
	gully.code as code,
    exploitation.name AS expl_name,
	gully.workcat_id,
	exploitation.expl_id
	FROM gully
    JOIN exploitation ON exploitation.expl_id=gully.expl_id
    WHERE state=1 AND gully.workcat_id IS NOT NULL
UNION
	SELECT row_number() OVER (ORDER BY element.element_id) + 5000000 AS rid,
    element.feature_type,
    element.elementcat_id AS featurecat_id,
    element.element_id AS feature_id,
    element.code,
    exploitation.name AS expl_name,
    element.workcat_id,
	exploitation.expl_id
   FROM element
   JOIN exploitation ON exploitation.expl_id=element.expl_id
   WHERE state=1 AND element.workcat_id IS NOT NULL;



CREATE OR REPLACE VIEW v_ui_workcat_x_feature_end AS 
 SELECT row_number() OVER (ORDER BY arc_id) + 1000000 AS rid,
    'ARC'::varchar as feature_type,
    arc.arccat_id AS featurecat_id,
    arc.arc_id AS feature_id,
    arc.code,
    exploitation.name AS expl_name,
    arc.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM arc
     JOIN exploitation ON exploitation.expl_id = arc.expl_id
  WHERE arc.state = 0 AND arc.workcat_id IS NOT NULL
UNION
 SELECT row_number() OVER (ORDER BY node_id) + 2000000 AS rid,
    'NODE',
    node.nodecat_id AS featurecat_id,
    node.node_id AS feature_id,
    node.code,
    exploitation.name AS expl_name,
    node.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM node
     JOIN exploitation ON exploitation.expl_id = node.expl_id
  WHERE node.state = 0 AND node.workcat_id IS NOT NULL
UNION
 SELECT row_number() OVER (ORDER BY connec_id) + 3000000 AS rid,
    'CONNEC',
    connec.connecat_id AS featurecat_id,
    connec.connec_id AS feature_id,
    connec.code,
    exploitation.name AS expl_name,
    connec.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM connec
     JOIN exploitation ON exploitation.expl_id = connec.expl_id
  WHERE connec.state = 0 AND connec.workcat_id IS NOT NULL
UNION
 SELECT row_number() OVER (ORDER BY element_id) + 4000000 AS rid,
    'ELEMENT',
    element.elementcat_id AS featurecat_id,
    element.element_id AS feature_id,
    element.code,
    exploitation.name AS expl_name,
    element.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM element
     JOIN exploitation ON exploitation.expl_id = element.expl_id
  WHERE element.state = 0 AND element.workcat_id IS NOT NULL
   UNION 
   	SELECT row_number() OVER (ORDER BY gully_id) + 4000000 AS rid,
    'GULLY',
	gully.gratecat_id as featurecat_id,
	gully.gully_id as feature_id,
	gully.code as code,
    exploitation.name AS expl_name,
    workcat_id_end AS workcat_id,
	exploitation.expl_id
	FROM gully
    JOIN exploitation ON exploitation.expl_id=gully.expl_id
    where state=0 AND gully.workcat_id IS NOT NULL;