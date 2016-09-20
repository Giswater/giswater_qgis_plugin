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
 SELECT temp_arc.arc_id,
    temp_arc.node_1,
    temp_arc.node_2,
    temp_arc.arccat_id,
    cat_arc.matcat_id,
    temp_arc.epa_type,
    temp_arc.sector_id,
    temp_arc.dma_id,
    temp_arc.state,
    temp_arc.soilcat_id,
        CASE
            WHEN temp_arc.custom_length IS NOT NULL THEN temp_arc.custom_length::numeric(12,3)
            ELSE st_length2d(temp_arc.the_geom)::numeric(12,3)
        END AS length,
    temp_arc.the_geom
   FROM temp_arc
   JOIN cat_arc ON temp_arc.arccat_id::text = cat_arc.id::text;


DROP VIEW IF EXISTS v_node CASCADE;
CREATE OR REPLACE VIEW v_node AS 
 SELECT temp_node.node_id,
    temp_node.elevation,
    temp_node.depth,
    temp_node.node_type,
    temp_node.nodecat_id,
    temp_node.epa_type,
    temp_node.sector_id,
    temp_node.dma_id,
    temp_node.state,
    temp_node.the_geom
   FROM gw_saa.temp_node;




