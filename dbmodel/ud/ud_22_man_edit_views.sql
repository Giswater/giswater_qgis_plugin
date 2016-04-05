/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- View structure for v_edit_man_node
-- ----------------------------

CREATE VIEW "sample_ud"."v_edit_man_junction" AS 
SELECT 
node.node_id, node.top_elev, node."ymax", node.nodecat_id, 
cat_node.nodetype_id AS "cat.nodetype",
node.sector_id, node."state", node.annotation, node.observ, node.comment, node.dma_id, node.soilcat_id, node.category_type, node.fluid_type, node.location_type, node.workcat_id, node.buildercat_id, node.builtdate, node.ownercat_id,
man_junction.add_info,
cat_node.svg AS "cat.svg",
node.rotation, node.link, node.verified, node.the_geom
FROM (sample_ud.node 
JOIN sample_ud.man_junction ON (((man_junction.node_id)::text = (node.node_id)::text))
JOIN sample_ud.cat_node ON (((node.nodecat_id)::text = (cat_node.id)::text)));


CREATE VIEW "sample_ud"."v_edit_man_storage" AS 
SELECT 
node.node_id, node.top_elev, node."ymax", node.nodecat_id,  
cat_node.nodetype_id AS "cat.nodetype",
node.sector_id, node."state", node.annotation, node.observ, node.comment, node.dma_id, node.soilcat_id, node.category_type, node.fluid_type, node.location_type, node.workcat_id, node.buildercat_id, node.builtdate, node.ownercat_id, 
man_storage.add_info,
cat_node.svg AS "cat.svg",
node.rotation, node.link, node.verified, node.the_geom
FROM (sample_ud.node 
JOIN sample_ud.man_storage ON (((man_storage.node_id)::text = (node.node_id)::text))
JOIN sample_ud.cat_node ON (((node.nodecat_id)::text = (cat_node.id)::text)));


CREATE VIEW "sample_ud"."v_edit_man_outfall" AS 
SELECT 
node.node_id, node.top_elev, node."ymax", node.nodecat_id, 
cat_node.nodetype_id AS "cat.nodetype",
node.sector_id, node."state", node.annotation, node.observ, node.comment, node.dma_id, node.soilcat_id, node.category_type, node.fluid_type, node.location_type, node.workcat_id, node.buildercat_id, node.builtdate,  node.ownercat_id,
man_outfall.add_info,
cat_node.svg AS "cat.svg",
node.rotation, node.link, node.verified, node.the_geom
FROM (sample_ud.node
JOIN sample_ud.man_outfall ON (((man_outfall.node_id)::text = (node.node_id)::text))
JOIN sample_ud.cat_node ON (((node.nodecat_id)::text = (cat_node.id)::text)));



-- ----------------------------
-- View structure for v_edit_man_arc
-- ----------------------------

CREATE VIEW "sample_ud"."v_edit_man_conduit" AS 
SELECT 
arc.arc_id, arc.arccat_id, 
cat_arc.arctype_id AS "cat_arctype", cat_arc.shape AS "cat_shape", cat_arc.matcat_id AS "cat_matcat_id", cat_arc.geom1 AS "cat_geom1",
arc.sector_id, arc.y1, arc.y2, arc."state", arc.annotation, arc.observ, arc.comment, st_length2d(arc.the_geom)::numeric(12,2) AS gis_length, arc.direction, arc.custom_length, arc.dma_id, arc.soilcat_id, arc.category_type, arc.fluid_type, arc.location_type, arc.workcat_id, arc.buildercat_id, arc.builtdate, arc.ownercat_id, 
man_conduit.add_info,
cat_arc.svg AS "cat.svg",
arc.rotation, arc.link, arc.verified, arc.the_geom
FROM (sample_ud.arc 
JOIN sample_ud.man_conduit ON (((man_conduit.arc_id)::text = (arc.arc_id)::text))
JOIN sample_ud.cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text)));
