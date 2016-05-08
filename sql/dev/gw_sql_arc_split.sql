DROP TABLE IF EXISTS SCHEMA_NAME.split;
CREATE TABLE SCHEMA_NAME.split AS(
SELECT

(ST_Dump(ST_Split(ST_Snap(arc.the_geom, node.the_geom, 0.00001),node.the_geom))).geom as the_geom , 
arc_id AS "old_arc_id", 
nextval('sample_ws.arc_id_seq'::regclass) as arc_id,
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
arc.rotation,
arc.link,
arc.verified

FROM 
    SCHEMA_NAME.arc
JOIN 
    SCHEMA_NAME.node
ON 
    ST_DWithin(node.the_geom, arc.the_geom, 1)

WHERE node."comment"='BLADE'::text
);
