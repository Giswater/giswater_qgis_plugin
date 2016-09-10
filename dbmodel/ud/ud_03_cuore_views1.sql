/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- View structure for v_arc_x_node
-- ----------------------------

DROP VIEW IF EXISTS v_arc;
CREATE OR REPLACE VIEW v_arc AS 
SELECT 
arc.arc_id, 
arc.node_1, 
arc.node_2,
(CASE 
WHEN (arc.est_y1 IS NOT NULL) THEN arc.est_y1::numeric (12,3)    
ELSE y1::numeric (12,3) END) AS y1,													-- field to customize the different options of y1 (mts or cms, field name or behaviour about the use of y1/est_y1 fields
(CASE 
WHEN (arc.est_y2 IS NOT NULL) THEN arc.est_y2::numeric (12,3)		
ELSE y2::numeric (12,3) END) AS y2,													-- field to customize the different options of y2 (mts or cms, field name or behaviour about the use of y2/est_y2 fields
arc.arccat_id,
cat_arc.matcat_id,																	-- field to customize de source of the data matcat_id (from arc catalog or directly from arc table)
arc.arc_type,
arc.epa_type,
arc.sector_id,
arc.dma_id,
arc.state,
arc.soilcat_id,
(CASE 
WHEN (arc.custom_length IS NOT NULL) THEN custom_length::numeric (12,3)				-- field to use length/customized_length
ELSE st_length2d(arc.the_geom)::numeric (12,3) END) AS length,
arc.the_geom
FROM arc
JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text;


DROP VIEW IF EXISTS v_node;
CREATE OR REPLACE VIEW v_node AS
SELECT
node.node_id,
(CASE 
WHEN (node.est_top_elev IS NOT NULL) THEN node.est_top_elev::numeric (12,3)    
ELSE top_elev::numeric (12,3) END) AS top_elev,										-- field to customize the different options of top_elev (mts or cms, field name or behaviour about the use of top_elev/est_top_elev fields)
(CASE 
WHEN (node.est_ymax IS NOT NULL) THEN node.est_ymax::numeric (12,3)		
ELSE ymax::numeric (12,3) END) AS ymax,												-- field to customize the different options of ymax (mts or cms, field name or behaviour about the use of y2/est_y2 fields)
node.nodecat_id,
node.node_type,
node.epa_type,
node.sector_id,
node.dma_id,
node.state,
node.the_geom
FROM node;



DROP VIEW IF EXISTS v_arc_x_node1;
CREATE OR REPLACE VIEW v_arc_x_node1 AS 
SELECT arc.arc_id, arc.node_1, node.top_elev AS top_elev1, node.ymax AS ymax1, node.top_elev - node.ymax AS elev1, arc.y1, node.ymax - arc.y1 AS z1, cat_arc.geom1, arc.y1 - cat_arc.geom1 AS r1 
FROM v_arc arc 
	JOIN node ON arc.node_1::text = node.node_id::text
	JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text AND arc.arccat_id::text = cat_arc.id::text;

	
DROP VIEW IF EXISTS v_arc_x_node2;
CREATE OR REPLACE VIEW v_arc_x_node2 AS 
SELECT arc.arc_id,arc.node_2,node.top_elev AS top_elev2,node.ymax AS ymax2,node.top_elev - node.ymax AS elev2,arc.y2,node.ymax - arc.y2 AS z2,cat_arc.geom1, arc.y2 - cat_arc.geom1 AS r2
FROM v_arc arc
   JOIN v_node node ON arc.node_2::text = node.node_id::text
   JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text AND arc.arccat_id::text = cat_arc.id::text;


DROP VIEW IF EXISTS v_arc_x_node;
CREATE OR REPLACE VIEW v_arc_x_node AS 
SELECT v_arc_x_node1.arc_id, 
v_arc_x_node1.node_1,
v_arc_x_node1.top_elev1,
v_arc_x_node1.ymax1,
v_arc_x_node1.elev1,
v_arc_x_node1.y1,
v_arc_x_node2.node_2,
v_arc_x_node2.top_elev2,
v_arc_x_node2.ymax2,
v_arc_x_node2.elev2,
v_arc_x_node2.y2,
v_arc_x_node1.z1,
v_arc_x_node2.z2,
v_arc_x_node1.geom1,
v_arc_x_node1.r1,
v_arc_x_node2.r2,
(CASE WHEN ((((((1)::numeric * ((v_arc_x_node1.elev1 + v_arc_x_node1.z1) - (v_arc_x_node2.elev2 + v_arc_x_node2.z2))))::double precision / (public.st_length(arc.the_geom)))>1)) THEN null::numeric(6,4)
ELSE (((((1)::numeric * ((v_arc_x_node1.elev1 + v_arc_x_node1.z1) - (v_arc_x_node2.elev2 + v_arc_x_node2.z2))))::double precision / (public.st_length(arc.the_geom))))::numeric(6,4) END) AS slope,
arc."state", 
arc.sector_id, 
arc.the_geom
FROM v_arc_x_node1
   JOIN v_arc_x_node2 ON v_arc_x_node1.arc_id::text = v_arc_x_node2.arc_id::text
   JOIN v_arc arc ON v_arc_x_node2.arc_id::text = arc.arc_id::text;



