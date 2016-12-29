/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- View structure for v_arc_x_node
-- ----------------------------


DROP VIEW IF EXISTS v_arc CASCADE;
CREATE OR REPLACE VIEW v_arc AS 
SELECT 
arc.arc_id, 
arc.node_1, 
arc.node_2,
arc.arccat_id,
cat_arc.matcat_id,																	-- field to customize de source of the data matcat_id (from arc catalog or directly from arc table)
arc.epa_type,
arc.sector_id,
arc.dma_id,
arc.state,
arc.soilcat_id,
(CASE 
WHEN (arc.custom_length IS NOT NULL) THEN custom_length::numeric (12,3)				-- field to use length/custom_length
ELSE st_length2d(arc.the_geom)::numeric (12,3) END) AS length,
arc.the_geom
FROM arc
JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text;


DROP VIEW IF EXISTS v_node CASCADE;
CREATE OR REPLACE VIEW v_node AS
SELECT
node.node_id,
node.elevation,
node.depth,
node.node_type,
node.nodecat_id,
node.epa_type,
node.sector_id,
node.dma_id,
node.state,
node.the_geom
FROM node;



DROP VIEW IF EXISTS v_arc_x_node1 CASCADE;
CREATE OR REPLACE VIEW v_arc_x_node1 AS 
SELECT arc.arc_id, arc.node_1, 
node.elevation AS elevation1, 
node.depth AS depth1, 
(cat_arc.dext)/1000 AS dext, 
node.depth - (cat_arc.dext)/1000 AS r1
FROM arc
JOIN node ON arc.node_1::text = node.node_id::text
JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text AND arc.arccat_id::text = cat_arc.id::text;


DROP VIEW IF EXISTS v_arc_x_node2 CASCADE;
CREATE OR REPLACE VIEW v_arc_x_node2 AS 
SELECT arc.arc_id, arc.node_2, 
node.elevation AS elevation2, 
node.depth AS depth2,
(cat_arc.dext)/1000 AS dext, 
node.depth - (cat_arc.dext)/1000 AS r2
FROM arc
JOIN node ON arc.node_2::text = node.node_id::text
JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text AND arc.arccat_id::text = cat_arc.id::text;


DROP VIEW IF EXISTS v_arc_x_node CASCADE;
CREATE OR REPLACE VIEW v_arc_x_node AS 
SELECT 
v_arc_x_node1.arc_id,
v_arc_x_node1.node_1,
v_arc_x_node1.elevation1,
v_arc_x_node1.depth1,
v_arc_x_node1.r1,
v_arc_x_node2.node_2,
v_arc_x_node2.elevation2,
v_arc_x_node2.depth2,
v_arc_x_node2.r2,
arc."state",
arc.sector_id,
arc.the_geom
FROM v_arc_x_node1
JOIN v_arc_x_node2 ON v_arc_x_node1.arc_id::text = v_arc_x_node2.arc_id::text
JOIN arc ON v_arc_x_node2.arc_id::text = arc.arc_id::text;



CREATE OR REPLACE VIEW v_value_cat_node AS 
 SELECT 
 cat_node.id,
 cat_node.nodetype_id,
 node_type.type
   FROM cat_node
     JOIN node_type ON node_type.id = nodetype_id


CREATE OR REPLACE VIEW mataro_ws_demo.v_value_cat_connec AS 
 SELECT cat_connec.id,
    cat_connec.type as connec_type,
    connec_type.type
   FROM mataro_ws_demo.cat_connec
     JOIN mataro_ws_demo.connec_type ON connec_type.id::text = cat_connec.type::text;


