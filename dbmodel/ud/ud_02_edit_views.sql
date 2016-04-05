/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- Views structure
-- ----------------------------

CREATE VIEW "sample_ud".v_edit_node AS
SELECT node.node_id, 
node.top_elev, 
node.ymax,
node.elev,
node.sander,
node.nodecat_id,
cat_node.nodetype_id AS "cat_nodetype_id",
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
node.the_geom
   FROM ("sample_ud".node
   JOIN "sample_ud".cat_node ON (((node.nodecat_id)::text = (cat_node.id)::text)));

   
CREATE VIEW "sample_ud".v_edit_arc AS
SELECT arc.arc_id, 
arc.y1, 
arc.y2,
arc.arccat_id, 
cat_arc.arctype_id AS "cat_arctype_id",
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
arc.direction,
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
arc.the_geom
FROM ("sample_ud".arc
JOIN "sample_ud".cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text)));