/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- View structure for v_edit_man_node
-- ----------------------------

CREATE VIEW "SCHEMA_NAME"."v_edit_man_junction" AS 
SELECT 
node.node_id, node.elevation, node."depth", node.nodecat_id, 
cat_node.nodetype_id AS "cat.nodetype",
node.sector_id, node."state", node.annotation, node.observ, node.comment, node.dma_id, node.soilcat_id, node.category_type, node.fluid_type, node.location_type, node.workcat_id, node.buildercat_id, node.builtdate, node.ownercat_id,
man_junction.add_info,
cat_node.svg AS "cat.svg",
node.rotation, node.link, node.verified, node.the_geom
FROM (SCHEMA_NAME.node 
JOIN SCHEMA_NAME.man_junction ON (((man_junction.node_id)::text = (node.node_id)::text))
JOIN SCHEMA_NAME.cat_node ON (((node.nodecat_id)::text = (cat_node.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_edit_man_tank" AS 
SELECT 
node.node_id, node.elevation, node."depth", node.nodecat_id,
cat_node.nodetype_id AS "cat.nodetype",
node.sector_id, node."state", node.annotation, node.observ, node.comment, node.dma_id, node.soilcat_id, node.category_type, node.fluid_type, node.location_type, node.workcat_id, node.buildercat_id, node.builtdate,  node.ownercat_id,
man_tank.vmax, man_tank.area, man_tank.add_info,
cat_node.svg AS "cat.svg",
node.rotation, node.link, node.verified, node.the_geom
FROM (SCHEMA_NAME.node 
JOIN SCHEMA_NAME.man_tank ON (((man_tank.node_id)::text = (node.node_id)::text))
JOIN SCHEMA_NAME.cat_node ON (((node.nodecat_id)::text = (cat_node.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_edit_man_hydrant" AS 
SELECT 
node.node_id, node.elevation, node."depth", node.nodecat_id, 
cat_node.nodetype_id AS "cat.nodetype",
node.sector_id, node."state", node.annotation, node.observ, node.comment, node.dma_id, node.soilcat_id, node.category_type, node.fluid_type, node.location_type, node.workcat_id, node.buildercat_id, node.builtdate,  node.ownercat_id,
man_hydrant.add_info,
cat_node.svg AS "cat.svg",
node.rotation, node.link, node.verified, node.the_geom
FROM (SCHEMA_NAME.node 
JOIN SCHEMA_NAME.man_hydrant ON (((man_hydrant.node_id)::text = (node.node_id)::text))
JOIN SCHEMA_NAME.cat_node ON (((node.nodecat_id)::text = (cat_node.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_edit_man_valve" AS 
SELECT 
node.node_id, node.elevation, node."depth", node.nodecat_id, 
cat_node.nodetype_id AS "cat.nodetype",
node.sector_id, node."state", node.annotation, node.observ, node.comment, node.dma_id, node.soilcat_id, node.category_type, node.fluid_type, node.location_type, node.workcat_id, node.buildercat_id, node.builtdate, node.ownercat_id, 
man_valve.add_info,
cat_node.svg AS "cat.svg",
node.rotation, node.link, node.verified, node.the_geom
FROM (SCHEMA_NAME.node
JOIN SCHEMA_NAME.man_valve ON (((man_valve.node_id)::text = (node.node_id)::text))
JOIN SCHEMA_NAME.cat_node ON (((node.nodecat_id)::text = (cat_node.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_edit_man_pump" AS 
SELECT 
node.node_id, node.elevation, node."depth", node.nodecat_id, 
cat_node.nodetype_id AS "cat.nodetype",
node.sector_id, node."state", node.annotation, node.observ, node.comment, node.dma_id, node.soilcat_id, node.category_type, node.fluid_type, node.location_type, node.workcat_id, node.buildercat_id, node.builtdate, node.ownercat_id, 
man_pump.add_info,
cat_node.svg AS "cat.svg",
node.rotation, node.link, node.verified, node.the_geom
FROM (SCHEMA_NAME.node 
JOIN SCHEMA_NAME.man_pump ON (((man_pump.node_id)::text = (node.node_id)::text))
JOIN SCHEMA_NAME.cat_node ON (((node.nodecat_id)::text = (cat_node.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_edit_man_filter" AS 
SELECT 
node.node_id, node.elevation, node."depth", node.nodecat_id,  
cat_node.nodetype_id AS "cat.nodetype",
node.sector_id, node."state", node.annotation, node.observ, node.comment, node.dma_id, node.soilcat_id, node.category_type, node.fluid_type, node.location_type, node.workcat_id, node.buildercat_id, node.builtdate, node.ownercat_id, 
man_filter.add_info,
cat_node.svg AS "cat.svg",
node.rotation, node.link, node.verified, node.the_geom
FROM (SCHEMA_NAME.node 
JOIN SCHEMA_NAME.man_filter ON (((man_filter.node_id)::text = (node.node_id)::text))
JOIN SCHEMA_NAME.cat_node ON (((node.nodecat_id)::text = (cat_node.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_edit_man_meter" AS 
SELECT 
node.node_id, node.elevation, node."depth", node.nodecat_id, 
cat_node.nodetype_id AS "cat.nodetype",
node.sector_id, node."state", node.annotation, node.observ, node.comment, node.dma_id, node.soilcat_id, node.category_type, node.fluid_type, node.location_type, node.workcat_id, node.buildercat_id, node.builtdate,  node.ownercat_id,
man_meter.add_info,
cat_node.svg AS "cat.svg",
node.rotation, node.link, node.verified, node.the_geom
FROM (SCHEMA_NAME.node
JOIN SCHEMA_NAME.man_meter ON (((man_meter.node_id)::text = (node.node_id)::text))
JOIN SCHEMA_NAME.cat_node ON (((node.nodecat_id)::text = (cat_node.id)::text)));



-- ----------------------------
-- View structure for v_edit_man_arc
-- ----------------------------

CREATE VIEW "SCHEMA_NAME"."v_edit_man_pipe" AS 
SELECT 
arc.arc_id, arc.arccat_id, 
cat_arc.arctype_id AS "cat.arctype",
arc.sector_id, arc."state", arc.annotation, arc.observ, arc.comment, st_length2d(arc.the_geom)::numeric(12,2) AS gis_length, arc.custom_length, arc.dma_id, arc.soilcat_id, arc.category_type, arc.fluid_type, arc.location_type, arc.workcat_id, arc.buildercat_id, arc.builtdate, arc.ownercat_id, 
man_pipe.add_info,
cat_arc.svg AS "cat.svg",
arc.rotation, arc.link, arc.verified, arc.the_geom
FROM (SCHEMA_NAME.arc 
JOIN SCHEMA_NAME.man_pipe ON (((man_pipe.arc_id)::text = (arc.arc_id)::text))
JOIN SCHEMA_NAME.cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text)));
