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

