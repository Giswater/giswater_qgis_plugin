/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


----------------------------
--    GIS EDITING VIEWS
----------------------------

CREATE OR REPLACE VIEW "SCHEMA_NAME".v_edit_node AS
SELECT 
node.node_id, 
node.elevation, 
node.depth, 

cat_node.nodetype_id AS "cat_nodetype_id",
--node.node_type,

node.nodecat_id,
cat_node.matcat_id AS "cat_matcat_id",
cat_node.pnom AS "cat_pnom",
cat_node.dnom AS "cat_dnom",
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
node.rotation,
node.link,
node.verified,
node.the_geom
FROM ("SCHEMA_NAME".node LEFT JOIN "SCHEMA_NAME".cat_node ON (((node.nodecat_id)::text = (cat_node.id)::text)));


CREATE VIEW "SCHEMA_NAME".v_edit_arc AS
SELECT 
arc.arc_id,
arc.node_1,
arc.node_2,
arc.arccat_id, 
cat_arc.arctype_id AS "cat_arctype_id",
cat_arc.matcat_id AS "cat_matcat_id",
cat_arc.pnom AS "cat_pnom",
cat_arc.dnom AS "cat_dnom",
st_length2d(arc.the_geom)::numeric(12,2) AS gis_length,
arc.epa_type,
arc.sector_id, 
arc."state", 
arc.annotation, 
arc.observ, 
arc."comment",
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
arc.rotation,
arc.link,
arc.verified,
arc.the_geom
FROM ("SCHEMA_NAME".arc LEFT JOIN "SCHEMA_NAME".cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text)));



CREATE OR REPLACE VIEW "SCHEMA_NAME".v_edit_connec AS
SELECT connec.connec_id, 
connec.elevation, 
connec.depth, 
connec.connecat_id,
cat_connec.type AS "cat_connectype_id",
cat_connec.matcat_id AS "cat_matcat_id",
cat_connec.pnom AS "cat_pnom",
cat_connec.dnom AS "cat_dnom",
connec.sector_id, 
connec.code,
connec.n_hydrometer,
connec.demand,
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
connec.streetaxis_id,
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
LEFT JOIN "SCHEMA_NAME".streetaxis ON (((connec.streetaxis_id)::text = (streetaxis.id)::text)));


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

