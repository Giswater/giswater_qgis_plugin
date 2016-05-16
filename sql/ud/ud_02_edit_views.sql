/*
This file is part of Giswater 20 (Sao Caetano)
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- Editing views structure
-- ----------------------------

CREATE VIEW "SCHEMA_NAME".v_edit_node AS
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
node.the_geom
   FROM ("SCHEMA_NAME".node
   JOIN "SCHEMA_NAME".cat_node ON (((node.nodecat_id)::text = (cat_node.id)::text)));

   
CREATE VIEW "SCHEMA_NAME".v_edit_arc AS
SELECT arc.arc_id, 
arc.node_1,
arc.node_2,
arc.y1, 
arc.y2,
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
FROM ("SCHEMA_NAME".arc
JOIN "SCHEMA_NAME".cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text)));




CREATE OR REPLACE VIEW "SCHEMA_NAME".v_edit_connec AS
SELECT connec.connec_id, 
connec.top_elev, 
connec.ymax, 
connec.connecat_id,
cat_connec.type AS "cat_connectype_id",
cat_connec.matcat_id AS "cat_matcat_id",
connec.sector_id, 
connec."state", 
connec.annotation, 
connec.observ, 
connec."comment",
connec.dma_id,
connec.soilcat_id,
connec.category_type,
connec.fluid_type,
connec.location_type,
connec.workcat_id,
connec.buildercat_id,
connec.builtdate,
connec.ownercat_id,
connec.adress_01,
connec.adress_02,
connec.adress_03,
streetaxis.name,
connec.postnumber,
connec.descript,
cat_connec.svg AS "cat_svg",
connec.rotation,
connec.link,
connec.verified,
connec.the_geom
FROM ("SCHEMA_NAME".connec 
LEFT JOIN "SCHEMA_NAME".cat_connec ON (((connec.connecat_id)::text = (cat_connec.id)::text))
JOIN "SCHEMA_NAME".streetaxis ON (((connec.streetaxis_id)::text = (streetaxis.id)::text)));



CREATE OR REPLACE VIEW "SCHEMA_NAME".v_edit_link AS
SELECT 
link.link_id,
link.connec_id,
link.vnode_id,
st_length2d(link.the_geom) as gis_length,
link.custom_length,
connec.connecat_id,
link.the_geom
FROM ("SCHEMA_NAME".link 
LEFT JOIN "SCHEMA_NAME".connec ON (((connec.connec_id)::text = (link.connec_id)::text))
);


CREATE OR REPLACE VIEW "SCHEMA_NAME".v_edit_gully AS
SELECT gully.gully_id, 
gully.top_elev, 
gully.ymax, 
gully.gratecat_id,
cat_grate.type AS "cat_grate_type",
cat_grate.matcat_id AS "cat_grate_matcat",
gully.sandbox,
gully.matcat_id,
gully.units,
gully.groove,
gully.arccat_id,
gully.siphon,
gully.sector_id, 
gully."state", 
gully.annotation, 
gully.observ, 
gully."comment",
gully.dma_id,
gully.soilcat_id,
gully.category_type,
gully.fluid_type,
gully.location_type,
gully.workcat_id,
gully.buildercat_id,
gully.builtdate,
gully.ownercat_id,
gully.adress_01,
gully.adress_02,
gully.adress_03,
gully.descript,
cat_grate.svg AS "cat_svg",
gully.rotation,
gully.link,
gully.verified,
gully.the_geom
FROM ("SCHEMA_NAME".gully LEFT JOIN "SCHEMA_NAME".cat_grate ON (((gully.gratecat_id)::text = (cat_grate.id)::text)));