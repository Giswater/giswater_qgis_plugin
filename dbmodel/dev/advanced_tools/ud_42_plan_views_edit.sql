/*
This file is part of Giswater 20 (Sao Caetano)
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;



-- ----------------------------
-- Editing views structure
-- ----------------------------
DROP VIEW IF EXISTS v_edit_node CASCADE;
CREATE VIEW v_edit_node AS
SELECT node.node_id, 
node.top_elev, 
node.ymax,
node.top_elev-node.ymax as elev,
node.sander,
node.node_type,
node.nodecat_id,
cat_node.matcat_id AS "cat_matcat_id",
node.epa_type,
node.sector_id, 
node."state", 
node.annotation, 
node.observ, 
node."comment",
node.dma_id,
node.soilcat_id,
node.category_type,
node.fluid_type,
node.location_type,
node.workcat_id,
node.buildercat_id,
node.builtdate,
node.ownercat_id,
node.adress_01,
node.adress_02,
node.adress_03,
node.descript,
cat_node.svg AS "cat_svg",
node.est_top_elev,
node.est_ymax,
node.rotation,
node.link,
node.verified,
node.the_geom,
node.workcat_id_end,
node.undelete,
node.label_x,
node.label_y,
node.label_rotation
   FROM (node
   LEFT JOIN cat_node ON (((node.nodecat_id)::text = (cat_node.id)::text))
   JOIN plan_selector_state ON (((node."state")::text = (plan_selector_state.id)::text)));


   
DROP VIEW IF EXISTS v_edit_arc CASCADE;
CREATE VIEW v_edit_arc AS
SELECT arc.arc_id, 
arc.node_1,
arc.node_2,
arc.y1, 
arc.y2,
v_arc_x_node.elev1,
v_arc_x_node.elev2,
v_arc_x_node.z1,
v_arc_x_node.z2,
v_arc_x_node.r1,
v_arc_x_node.r2,
v_arc_x_node.slope,
arc.arc_type,
arc.arccat_id, 
cat_arc.matcat_id AS "cat_matcat_id",
cat_arc.shape AS "cat_shape",
cat_arc.geom1 AS "cat_geom1",
st_length2d(arc.the_geom)::numeric(12,2) AS gis_length,
arc.epa_type,
arc.sector_id, 
arc."state", 
arc.annotation, 
arc.observ, 
arc."comment",
arc.inverted_slope,
arc.custom_length,
arc.dma_id,
arc.soilcat_id,
arc.category_type,
arc.fluid_type,
arc.location_type,
arc.workcat_id,
arc.buildercat_id,
arc.builtdate,
arc.ownercat_id,
arc.adress_01,
arc.adress_02,
arc.adress_03,
arc.descript,
cat_arc.svg AS "cat_svg",
arc.est_y1,
arc.est_y2,
arc.rotation,
arc.link,
arc.verified,
arc.the_geom,
arc.workcat_id_end,
arc.undelete,
arc.label_x,
arc.label_y,
arc.label_rotation
FROM (arc
LEFT JOIN cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text))
LEFT JOIN v_arc_x_node ON (((v_arc_x_node.arc_id)::text = (arc.arc_id)::text))
JOIN plan_selector_state ON (((arc."state")::text = (plan_selector_state.id)::text)));

