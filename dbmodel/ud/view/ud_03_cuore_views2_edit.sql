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
node.est_top_elev,
node.ymax,
node.est_ymax,
node.elev,
node.est_elev,
v_node.elev AS sys_elev,
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
node.rotation,
node.link,
node.verified,
node.the_geom,
node.workcat_id_end,
node.undelete,
node.label_x,
node.label_y,
node.label_rotation,
node.code,
node.publish,
node.inventory,
node.end_date,
node.uncertain,
node.xyz_date,
node.unconnected,
dma.macrodma_id,
node.expl_id
   FROM expl_selector,node
   LEFT JOIN cat_node ON ((node.nodecat_id)::text = (cat_node.id)::text)
	LEFT JOIN dma ON (((node.dma_id)::text = (dma.dma_id)::text))
	JOIN v_node ON node.node_id=v_node.node_id
   WHERE ((node.expl_id)::text=(expl_selector.expl_id)::text
	AND expl_selector.cur_user="current_user"()::text);



  
DROP VIEW IF EXISTS v_edit_arc CASCADE;
CREATE VIEW v_edit_arc AS
SELECT arc.arc_id, 
arc.node_1,
arc.node_2,
arc.y1, 
arc.y2,
arc.est_y1,
arc.elev1,
arc.est_elev1,
v_arc_x_node.elevmax1,
arc.est_y2,
arc.elev2,
arc.est_elev2,
v_arc_x_node.elevmax2,
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
cat_arc.width AS "cat_width",
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
arc.link,
arc.verified,
arc.the_geom,
arc.workcat_id_end,
arc.undelete,
arc.label_x,
arc.label_y,
arc.label_rotation,
arc.code,
arc.publish,
arc.inventory,
arc.end_date,
arc.uncertain,
dma.macrodma_id,
arc.expl_id
FROM expl_selector, arc
LEFT JOIN cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text))
LEFT JOIN dma ON (((arc.dma_id)::text = (dma.dma_id)::text))
LEFT JOIN v_arc_x_node ON (((v_arc_x_node.arc_id)::text = (arc.arc_id)::text))
WHERE (arc.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text;


DROP VIEW IF EXISTS v_edit_connec CASCADE;
CREATE OR REPLACE VIEW v_edit_connec AS
SELECT connec.connec_id, 
connec.top_elev, 
connec.ymax, 
connec.connecat_id,
connec.connec_type,
cat_connec.matcat_id AS "cat_matcat_id",
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
ext_streetaxis.name,
connec.postnumber,
connec.descript,
vnode.arc_id,
cat_connec.svg AS "cat_svg",
connec.rotation,
connec.link,
connec.verified,
connec.the_geom,
connec.workcat_id_end,
connec.y1,
connec.y2,
connec.undelete,
connec.featurecat_id,
connec.feature_id,
connec.private_connecat_id,
connec.label_x,
connec.label_y,
connec.label_rotation,
connec.accessibility,
connec.diagonal,
connec.publish,
connec.inventory,
connec.end_date,
connec.uncertain,
dma.macrodma_id,
connec.expl_id
FROM expl_selector, connec 
JOIN cat_connec ON (((connec.connecat_id)::text = (cat_connec.id)::text))
LEFT JOIN ext_streetaxis ON (((connec.streetaxis_id)::text = (ext_streetaxis.id)::text))
LEFT JOIN link ON connec.connec_id::text = link.connec_id::text
LEFT JOIN dma ON (((connec.dma_id)::text = (dma.dma_id)::text))
LEFT JOIN vnode ON vnode.vnode_id::text = link.vnode_id
WHERE (connec.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text;


DROP VIEW IF EXISTS v_edit_link CASCADE;
CREATE OR REPLACE VIEW v_edit_link AS 
 SELECT link.link_id,
    link.featurecat_id,
    link.feature_id,
    link.vnode_id,
    st_length2d(link.the_geom) AS gis_length,
    link.custom_length,
    link.the_geom,
    link.expl_id,
	link."state"
   FROM expl_selector, link
  WHERE link.expl_id::text = expl_selector.expl_id::text AND expl_selector.cur_user = "current_user"()::text;
  

DROP VIEW IF EXISTS v_edit_gully CASCADE;
CREATE OR REPLACE VIEW v_edit_gully AS
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
gully.arc_id,
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
gully.the_geom,
gully.undelete,
gully.workcat_id_end,
gully.featurecat_id,
gully.feature_id,
gully.label_x,
gully.label_y,
gully.label_rotation,
gully.code,
gully.publish,
gully.inventory,
gully.end_date,
dma.macrodma_id,
gully.streetaxis_id,
ext_streetaxis.name AS streetname,
gully.postnumber,
gully.expl_id,
gully.connec_length,
gully.connec_depth 
FROM expl_selector, gully 
LEFT JOIN cat_grate ON (((gully.gratecat_id)::text = (cat_grate.id)::text))
LEFT JOIN ext_streetaxis ON gully.streetaxis_id::text = ext_streetaxis.id::text
LEFT JOIN dma ON (((gully.dma_id)::text = (dma.dma_id)::text))
WHERE gully.the_geom is not null 
AND (gully.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text;


DROP VIEW IF EXISTS v_edit_pgully CASCADE;
CREATE OR REPLACE VIEW v_edit_pgully AS
SELECT  gully.gully_id, 
gully.top_elev, 
gully.ymax, 
gully.gratecat_id,
cat_grate.type AS "cat_grate_type",
cat_grate.matcat_id AS "cat_grate_matcat",
gully.sandbox,
gully.matcat_id,
gully.units,
gully.groove,
gully.siphon,
gully.arccat_id,
gully.arc_id,
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
gully.the_geom_pol AS "the_geom",
gully.undelete,
gully.workcat_id_end,
gully.featurecat_id,
gully.feature_id,
gully.label_x,
gully.label_y,
gully.label_rotation,
gully.code,
gully.publish,
gully.inventory,
gully.end_date,
dma.macrodma_id,
gully.streetaxis_id,
gully.postnumber,
gully.expl_id,
gully.connec_length,
gully.connec_depth 
FROM expl_selector, gully 
LEFT JOIN cat_grate ON (((gully.gratecat_id)::text = (cat_grate.id)::text))
LEFT JOIN dma ON (((gully.dma_id)::text = (dma.dma_id)::text))
WHERE gully.the_geom_pol is not null
AND (gully.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text;



DROP VIEW IF EXISTS v_edit_man_junction CASCADE;
CREATE OR REPLACE VIEW v_edit_man_junction AS 
 SELECT node.node_id,
    node.top_elev AS junction_top_elev,
	node.est_top_elev AS junction_est_top_elev,
    node.ymax AS junction_ymax,
	node.est_ymax AS junction_est_ymax,
	node.elev AS junction_elev,
	node.est_elev AS junction_est_elev,
	v_node.elev AS junction_sys_elev,
    node.sander AS junction_sander,
	node.node_type,
    node.nodecat_id,
    node.epa_type,
    node.sector_id,
    node.state,
    node.annotation AS junction_annotation,
    node.observ AS junction_observ,
    node.comment AS junction_comment,
    node.dma_id,
    node.soilcat_id AS junction_soilcat_id,
    node.category_type AS junction_category_type,
    node.fluid_type AS junction_fluid_type,
    node.location_type AS junction_location_type,
    node.workcat_id AS junction_workcat_id,
    node.buildercat_id AS junction_buildercat_id,
    node.builtdate AS junction_builtdate,
    node.ownercat_id AS junction_ownercat_id,
    node.adress_01 AS junction_adress_01,
    node.adress_02 AS junction_adress_02,
    node.adress_03 AS junction_adress_03,
    node.descript AS junction_descript,
    node.rotation AS junction_rotation,
    node.link AS junction_link,
    node.verified,
    node.the_geom,
    node.workcat_id_end AS junction_workcat_id_end,
    node.undelete,
    node.label_x AS junction_label_x,
    node.label_y AS junction_label_y,
    node.label_rotation AS junction_label_rotation,
	node.code AS junction_code,
	node.publish,
	node.inventory,
	node.end_date AS junction_end_date,
	node.uncertain,
	node.xyz_date AS junction_xyz_date,
	node.unconnected,
	dma.macrodma_id,
	node.expl_id
   FROM expl_selector, node
     JOIN man_junction ON man_junction.node_id::text = node.node_id::text
	 LEFT JOIN dma ON (((node.dma_id)::text = (dma.dma_id)::text))
	 JOIN v_node ON v_node.node_id::text = node.node_id::text
	WHERE (node.expl_id)::text=(expl_selector.expl_id)::text
	AND expl_selector.cur_user="current_user"()::text;


	 
DROP VIEW IF EXISTS v_edit_man_outfall CASCADE;
CREATE OR REPLACE VIEW v_edit_man_outfall AS 
 SELECT node.node_id,
    node.top_elev AS outfall_top_elev,
	node.est_top_elev AS outfall_est_top_elev,
    node.ymax AS outfall_ymax,
	node.est_ymax AS outfall_est_ymax,
	node.elev AS outfall_elev,
	node.est_elev AS outfall_est_elev,
	v_node.elev AS outfall_sys_elev,
    node.sander AS outfall_sander,
    node.node_type,
    node.nodecat_id,
    node.epa_type,
    node.sector_id,
    node.state,
    node.annotation AS outfall_annotation,
    node.observ AS outfall_observ,
    node.comment AS outfall_comment,
    node.dma_id,
    node.soilcat_id AS outfall_soilcat_id,
    node.category_type AS outfall_category_type,
    node.fluid_type AS outfall_fluid_type,
    node.location_type AS outfall_location_type,
    node.workcat_id AS outfall_workcat_id,
    node.buildercat_id AS outfall_buildercat_id,
    node.builtdate AS outfall_builtdate,
    node.ownercat_id AS outfall_ownercat_id,
    node.adress_01 AS outfall_adress_01,
    node.adress_02 AS outfall_adress_02,
    node.adress_03 AS outfall_adress_03,
    node.descript AS outfall_descript,
    node.rotation AS outfall_rotation,
    node.link AS outfall_link,
    node.verified,
    node.the_geom,
    node.workcat_id_end AS outfall_workcat_id_end,
    node.undelete,
    node.label_x AS outfall_label_x,
    node.label_y AS outfall_label_y,
    node.label_rotation AS outfall_label_rotation,
    man_outfall.outfall_name,
	node.code AS outfall_code,
	node.publish,
	node.inventory,
	node.end_date AS outfall_end_date,
	node.uncertain,
	node.xyz_date AS outfall_xyz_date,
	node.unconnected,
	dma.macrodma_id,
	node.expl_id
   FROM expl_selector, node
     JOIN man_outfall ON man_outfall.node_id::text = node.node_id::text
	 JOIN v_node ON v_node.node_id::text = node.node_id::text
	 LEFT JOIN dma ON (((node.dma_id)::text = (dma.dma_id)::text))
	 WHERE (node.expl_id)::text=(expl_selector.expl_id)::text
	AND expl_selector.cur_user="current_user"()::text;


	 
DROP VIEW IF EXISTS v_edit_man_storage CASCADE;
CREATE OR REPLACE VIEW v_edit_man_storage AS 
 SELECT node.node_id,
    node.top_elev AS storage_top_elev,
	node.est_top_elev AS storage_est_top_elev,
    node.ymax AS storage_ymax,
	node.est_ymax AS storage_est_ymax,
	node.elev AS storage_elev,
	node.est_elev AS storage_est_elev,
	v_node.elev AS storage_sys_elev,
    node.sander AS storage_sander,
    node.node_type,
    node.nodecat_id,
    node.epa_type,
    node.sector_id,
    node.state,
    node.annotation AS storage_annotation,
    node.observ AS storage_observ,
    node.comment AS storage_comment,
    node.dma_id,
    node.soilcat_id AS storage_soilcat_id,
    node.category_type AS storage_category_type,
    node.fluid_type AS storage_fluid_type,
    node.location_type AS storage_location_type,
    node.workcat_id AS storage_workcat_id,
    node.buildercat_id AS storage_buildercat_id,
    node.builtdate AS storage_builtdate,
    node.ownercat_id AS storage_ownercat_id,
    node.adress_01 AS storage_adress_01,
    node.adress_02 AS storage_adress_02,
    node.adress_03 AS storage_adress_03,
    node.descript AS storage_descript,
    node.rotation AS storage_rotation,
    node.link AS storage_link,
    node.verified,
    node.the_geom,
    node.workcat_id_end AS storage_workcat_id_end,
    node.undelete,
    node.label_x AS storage_label_x,
    node.label_y AS storage_label_y,
    node.label_rotation AS storage_label_rotation,
    man_storage.total_volume AS storage_total_volume,
    man_storage.util_volume AS storage_util_volume,
    man_storage.min_height AS storage_min_height,
    man_storage.total_height AS storage_total_height,
    man_storage.total_length AS storage_total_length,
    man_storage.total_width AS storage_total_width,
    man_storage.pol_id,
    man_storage.storage_name,
	node.code AS storage_code,
	node.publish,
	node.inventory,
	node.end_date AS storage_end_date,
	node.uncertain,
	node.xyz_date AS storage_xyz_date,
	node.unconnected,
	dma.macrodma_id,
	node.expl_id
   FROM expl_selector, node
     JOIN man_storage ON man_storage.node_id::text = node.node_id::text
	 LEFT JOIN dma ON (((node.dma_id)::text = (dma.dma_id)::text))
	 JOIN v_node ON v_node.node_id::text = node.node_id::text
	 WHERE (node.expl_id)::text=(expl_selector.expl_id)::text
	AND expl_selector.cur_user="current_user"()::text;


	 

DROP VIEW IF EXISTS v_edit_man_storage_pol CASCADE;
CREATE OR REPLACE VIEW v_edit_man_storage_pol AS 
 SELECT 
    polygon.pol_id,
    node.node_id,
    node.top_elev AS storage_top_elev,
	node.est_top_elev AS storage_est_top_elev,
    node.ymax AS storage_ymax,
	node.est_ymax AS storage_est_ymax,
	node.elev AS storage_elev,
	node.est_elev AS storage_est_elev,
	v_node.elev AS storage_sys_elev,
    node.sander AS storage_sander,
    node.node_type,
    node.nodecat_id,
    node.epa_type,
    node.sector_id,
    node.state,
    node.annotation AS storage_annotation,
    node.observ AS storage_observ,
    node.comment AS storage_comment,
    node.dma_id,
    node.soilcat_id AS storage_soilcat_id,
    node.category_type AS storage_category_type,
    node.fluid_type AS storage_fluid_type,
    node.location_type AS storage_location_type,
    node.workcat_id AS storage_workcat_id,
    node.buildercat_id AS storage_buildercat_id,
    node.builtdate AS storage_builtdate,
    node.ownercat_id AS storage_ownercat_id,
    node.adress_01 AS storage_adress_01,
    node.adress_02 AS storage_adress_02,
    node.adress_03 AS storage_adress_03,
    node.descript AS storage_descript,
    node.rotation AS storage_rotation,
    node.link AS storage_link,
    node.verified,
    polygon.the_geom,
    node.workcat_id_end AS storage_workcat_id_end,
    node.undelete,
    node.label_x AS storage_label_x,
    node.label_y AS storage_label_y,
    node.label_rotation AS storage_label_rotation,
    man_storage.total_volume AS storage_total_volume,
    man_storage.util_volume AS storage_util_volume,
    man_storage.min_height AS storage_min_height,
    man_storage.total_height AS storage_total_height,
    man_storage.total_length AS storage_total_length,
    man_storage.total_width AS storage_total_width,
    man_storage.pol_id,
    man_storage.storage_name,
	node.code AS storage_code,
	node.publish,
	node.inventory,
	node.end_date AS storage_end_date,
	node.uncertain,
	node.xyz_date AS storage_xyz_date,
	node.unconnected,
	dma.macrodma_id,
	node.expl_id
   FROM expl_selector, node
     JOIN man_storage ON man_storage.node_id::text = node.node_id::text
	 LEFT JOIN dma ON (((node.dma_id)::text = (dma.dma_id)::text))
	 JOIN v_node ON v_node.node_id::text = node.node_id::text
     JOIN polygon ON polygon.pol_id::text = man_storage.pol_id::text
	 WHERE (node.expl_id)::text=(expl_selector.expl_id)::text
	AND expl_selector.cur_user="current_user"()::text;

	 
	 
	 
DROP VIEW IF EXISTS v_edit_man_valve CASCADE;
CREATE OR REPLACE VIEW v_edit_man_valve AS 
 SELECT node.node_id,
    node.top_elev AS valve_top_elev,
	node.est_top_elev AS valve_est_top_elev,
    node.ymax AS valve_ymax,
	node.est_ymax AS valve_est_ymax,
	node.elev AS valve_elev,
	node.est_elev AS valve_est_elev,
	v_node.elev AS valve_sys_elev,
    node.sander AS valve_sander,
    node.node_type,
    node.nodecat_id,
    node.epa_type,
    node.sector_id,
    node.state,
    node.annotation AS valve_annotation,
    node.observ AS valve_observ,
    node.comment AS valve_comment,
    node.dma_id,
    node.soilcat_id AS valve_soilcat_id,
    node.category_type AS valve_category_type,
    node.fluid_type AS valve_fluid_type,
    node.location_type AS valve_location_type,
    node.workcat_id AS valve_workcat_id,
    node.buildercat_id AS valve_buildercat_id,
    node.builtdate AS valve_builtdate,
    node.ownercat_id AS valve_ownercat_id,
    node.adress_01 AS valve_adress_01,
    node.adress_02 AS valve_adress_02,
    node.adress_03 AS valve_adress_03,
    node.descript AS valve_descript,
    node.rotation AS valve_rotation,
    node.link AS valve_link,
    node.verified,
    node.the_geom,
    node.workcat_id_end AS valve_workcat_id_end,
    node.undelete,
    node.label_x AS valve_label_x,
    node.label_y AS valve_label_y,
    node.label_rotation AS valve_label_rotation,
    man_valve.valve_name,
	node.code AS valve_code,
	node.publish,
	node.inventory,
	node.end_date AS valve_end_date,
	node.uncertain,
	node.xyz_date AS valve_xyz_date,
	node.unconnected,
	dma.macrodma_id,
	node.expl_id
   FROM expl_selector, node
     JOIN man_valve ON man_valve.node_id::text = node.node_id::text
	 LEFT JOIN dma ON (((node.dma_id)::text = (dma.dma_id)::text))
	 JOIN v_node ON v_node.node_id::text = node.node_id::text
	 WHERE (node.expl_id)::text=(expl_selector.expl_id)::text
	AND expl_selector.cur_user="current_user"()::text;

	 
	 
DROP VIEW IF EXISTS v_edit_man_netinit CASCADE;
CREATE OR REPLACE VIEW v_edit_man_netinit AS 
 SELECT node.node_id,
    node.top_elev AS netinit_top_elev,
	node.est_top_elev AS netinit_est_top_elev,
    node.ymax AS netinit_ymax,
	node.est_ymax AS netinit_est_ymax,
	node.elev AS netinit_elev,
	node.est_elev AS netinit_est_elev,
	v_node.elev AS netinit_sys_elev,
    node.sander AS netinit_sander,
    node.node_type,
    node.nodecat_id,
    node.epa_type,
    node.sector_id,
    node.state,
    node.annotation AS netinit_annotation,
    node.observ AS netinit_observ,
    node.comment AS netinit_comment,
    node.dma_id,
    node.soilcat_id AS netinit_soilcat_id,
    node.category_type AS netinit_category_type,
    node.fluid_type AS netinit_fluid_type,
    node.location_type AS netinit_location_type,
    node.workcat_id AS netinit_workcat_id,
    node.buildercat_id AS netinit_buildercat_id,
    node.builtdate AS netinit_builtdate,
    node.ownercat_id AS netinit_ownercat_id,
    node.adress_01 AS netinit_adress_01,
    node.adress_02 AS netinit_adress_02,
    node.adress_03 AS netinit_adress_03,
    node.descript AS netinit_descript,
    node.rotation AS netinit_rotation,
    node.link AS netinit_link,
    node.verified,
    node.the_geom,
    node.workcat_id_end AS netinit_workcat_id_end,
    node.undelete,
    node.label_x AS netinit_label_x,
    node.label_y AS netinit_label_y,
    node.label_rotation AS netinit_label_rotation,
    man_netinit.mheight AS netinit_mheight,
    man_netinit.mlength AS netinit_mlength,
    man_netinit.mwidth AS netinit_mwidth,
    man_netinit.netinit_name,
	node.code AS netinit_code,
	node.publish,
	node.inventory,
	node.end_date AS netinit_end_date,
	node.uncertain,
	node.xyz_date AS netinit_xyz_date,
	node.unconnected,
	dma.macrodma_id,
	man_netinit.inlet AS netinit_inlet,
	man_netinit.bottom_channel AS netinit_bottom_channel,
	man_netinit.accessibility AS netinit_accessibility,
	node.expl_id
   FROM expl_selector, node
     JOIN man_netinit ON man_netinit.node_id::text = node.node_id::text
	 LEFT JOIN dma ON (((node.dma_id)::text = (dma.dma_id)::text))
	 JOIN v_node ON v_node.node_id::text = node.node_id::text
	 WHERE (node.expl_id)::text=(expl_selector.expl_id)::text
	AND expl_selector.cur_user="current_user"()::text;


	 
DROP VIEW IF EXISTS v_edit_man_manhole CASCADE;
CREATE OR REPLACE VIEW v_edit_man_manhole AS 
 SELECT node.node_id,
    node.top_elev AS manhole_top_elev,
	node.est_top_elev AS manhole_est_top_elev,
    node.ymax AS manhole_ymax,
	node.est_ymax AS manhole_est_ymax,
	node.elev AS manhole_elev,
	node.est_elev AS manhole_est_elev,
	v_node.elev AS manhole_sys_elev,
    node.sander AS manhole_sander,
	node.node_type,
    node.nodecat_id,
    node.epa_type,
    node.sector_id,
    node.state,
    node.annotation AS manhole_annotation,
    node.observ AS manhole_observ,
    node.comment AS manhole_comment,
    node.dma_id,
    node.soilcat_id AS manhole_soilcat_id,
    node.category_type AS manhole_category_type,
    node.fluid_type AS manhole_fluid_type,
    node.location_type AS manhole_location_type,
    node.workcat_id AS manhole_workcat_id,
    node.buildercat_id AS manhole_buildercat_id,
    node.builtdate AS manhole_builtdate,
    node.ownercat_id AS manhole_ownercat_id,
    node.adress_01 AS manhole_adress_01,
    node.adress_02 AS manhole_adress_02,
    node.adress_03 AS manhole_adress_03,
    node.descript AS manhole_descript,
    node.rotation AS manhole_rotation,
    node.link AS manhole_link,
    node.verified,
    node.the_geom,
    node.workcat_id_end AS manhole_workcat_id_end,
    node.undelete,
    node.label_x AS manhole_label_x,
    node.label_y AS manhole_label_y,
    node.label_rotation AS manhole_label_rotation,
    man_manhole.sander_depth AS manhole_sander_depth,
    man_manhole.prot_surface AS manhole_prot_surface,
	node.code AS manhole_code,
	node.publish,
	node.inventory,
	node.end_date AS manhole_end_date,
	node.uncertain,
	node.xyz_date AS manhole_xyz_date,
	node.unconnected,
	dma.macrodma_id,
	man_manhole.inlet AS manhole_inlet,
	man_manhole.bottom_channel AS manhole_bottom_channel,
	man_manhole.accessibility AS manhole_accessibility,
	node.expl_id
   FROM expl_selector, node
     JOIN man_manhole ON man_manhole.node_id::text = node.node_id::text
	 LEFT JOIN dma ON (((node.dma_id)::text = (dma.dma_id)::text))
	 JOIN v_node ON v_node.node_id::text = node.node_id::text
	 WHERE (node.expl_id)::text=(expl_selector.expl_id)::text
	AND expl_selector.cur_user="current_user"()::text;

	 
DROP VIEW IF EXISTS v_edit_man_wjump CASCADE;
CREATE OR REPLACE VIEW v_edit_man_wjump AS 
 SELECT node.node_id,
    node.top_elev AS wjump_top_elev,
	node.est_top_elev AS wjump_est_top_elev,
    node.ymax AS wjump_ymax,
	node.est_ymax AS wjump_est_ymax,
	node.elev AS wjump_elev,
	node.est_elev AS wjump_est_elev,
	v_node.elev AS wjump_sys_elev,
    node.sander AS wjump_sander,
    node.node_type,
    node.nodecat_id,
    node.epa_type,
    node.sector_id,
    node.state,
    node.annotation AS wjump_annotation,
    node.observ AS wjump_observ,
    node.comment AS wjump_comment,
    node.dma_id,
    node.soilcat_id AS wjump_soilcat_id,
    node.category_type AS wjump_category_type,
    node.fluid_type AS wjump_fluid_type,
    node.location_type AS wjump_location_type,
    node.workcat_id AS wjump_workcat_id,
    node.buildercat_id AS wjump_buildercat_id,
    node.builtdate AS wjump_builtdate,
    node.ownercat_id AS wjump_ownercat_id,
    node.adress_01 AS wjump_adress_01,
    node.adress_02 AS wjump_adress_02,
    node.adress_03 AS wjump_adress_03,
    node.descript AS wjump_descript,
    node.rotation AS wjump_rotation,
    node.link AS wjump_link,
    node.verified,
    node.the_geom,
    node.workcat_id_end AS wjump_workcat_id_end,
    node.undelete,
    node.label_x AS wjump_label_x,
    node.label_y AS wjump_label_y,
    node.label_rotation AS wjump_label_rotation,
    man_wjump.mheight AS wjump_mheight,
    man_wjump.mlength AS wjump_mlength,
    man_wjump.mwidth AS wjump_mwidth,
    man_wjump.sander_length AS wjump_sander_length,
    man_wjump.sander_depth AS wjump_sander_depth,
    man_wjump.security_bar AS wjump_security_bar,
    man_wjump.steps AS wjump_steps,
    man_wjump.prot_surface AS wjump_prot_surface,
    man_wjump.wjump_name,
	node.code AS wjump_code,
	node.publish,
	node.inventory,
	node.end_date AS wjump_end_date,
	node.uncertain,
	node.xyz_date AS wjump_xyz_date,
	node.unconnected,
	dma.macrodma_id,
	node.expl_id
   FROM expl_selector, node
     JOIN man_wjump ON man_wjump.node_id::text = node.node_id::text
	 LEFT JOIN dma ON (((node.dma_id)::text = (dma.dma_id)::text))
	 JOIN v_node ON v_node.node_id::text = node.node_id::text
	 WHERE (node.expl_id)::text=(expl_selector.expl_id)::text
	AND expl_selector.cur_user="current_user"()::text;


	 
DROP VIEW IF EXISTS v_edit_man_netgully CASCADE;
CREATE OR REPLACE VIEW v_edit_man_netgully AS 
 SELECT node.node_id,
    node.top_elev AS netgully_top_elev,
	node.est_top_elev AS netgully_est_top_elev,
    node.ymax AS netgully_ymax,
	node.est_ymax AS netgully_est_ymax,
	node.elev AS netgully_elev,
	node.est_elev AS netgully_est_elev,
	v_node.elev AS netgully_sys_elev,
    node.sander AS netgully_sander,
    node.node_type,
    node.nodecat_id,
    node.epa_type,
    node.sector_id,
    node.state,
    node.annotation AS netgully_annotation,
    node.observ AS netgully_observ,
    node.comment AS netgully_comment,
    node.dma_id,
    node.soilcat_id AS netgully_soilcat_id,
    node.category_type AS netgully_category_type,
    node.fluid_type AS netgully_fluid_type,
    node.location_type AS netgully_location_type,
    node.workcat_id AS netgully_workcat_id,
    node.buildercat_id AS netgully_buildercat_id,
    node.builtdate AS netgully_builtdate,
    node.ownercat_id AS netgully_ownercat_id,
    node.adress_01 AS netgully_adress_01,
    node.adress_02 AS netgully_adress_02,
    node.adress_03 AS netgully_adress_03,
    node.descript AS netgully_descript,
    node.rotation AS netgully_rotation,
    node.link AS netgully_link,
    node.verified,
    node.the_geom,
    node.workcat_id_end AS netgully_workcat_id_end,
    node.undelete,
    node.label_x AS netgully_label_x,
    node.label_y AS netgully_label_y,
    node.label_rotation AS netgully_label_rotation,
    man_netgully.pol_id,
	node.code AS netgully_code,
	node.publish,
	node.inventory,
	node.end_date AS netgully_end_date,
	node.uncertain,
	node.xyz_date AS netgully_xyz_date,
	node.unconnected,
	dma.macrodma_id,
	node.expl_id
   FROM expl_selector, node
     JOIN man_netgully ON man_netgully.node_id::text = node.node_id::text
	 LEFT JOIN dma ON (((node.dma_id)::text = (dma.dma_id)::text))
	 JOIN v_node ON v_node.node_id::text = node.node_id::text
	 WHERE (node.expl_id)::text=(expl_selector.expl_id)::text
	AND expl_selector.cur_user="current_user"()::text;
	 

DROP VIEW IF EXISTS v_edit_man_netgully_pol CASCADE;
CREATE OR REPLACE VIEW v_edit_man_netgully_pol AS 
 SELECT 
 polygon.pol_id,
 node.node_id,
    node.top_elev AS netgully_top_elev,
	node.est_top_elev AS netgully_est_top_elev,
    node.ymax AS netgully_ymax,
	node.est_ymax AS netgully_est_ymax,
	node.elev AS netgully_elev,
	node.est_elev AS netgully_est_elev,
	v_node.elev AS netgully_sys_elev,
    node.sander AS netgully_sander,
    node.node_type,
    node.nodecat_id,
    node.epa_type,
    node.sector_id,
    node.state,
    node.annotation AS netgully_annotation,
    node.observ AS netgully_observ,
    node.comment AS netgully_comment,
    node.dma_id,
    node.soilcat_id AS netgully_soilcat_id,
    node.category_type AS netgully_category_type,
    node.fluid_type AS netgully_fluid_type,
    node.location_type AS netgully_location_type,
    node.workcat_id AS netgully_workcat_id,
    node.buildercat_id AS netgully_buildercat_id,
    node.builtdate AS netgully_builtdate,
    node.ownercat_id AS netgully_ownercat_id,
    node.adress_01 AS netgully_adress_01,
    node.adress_02 AS netgully_adress_02,
    node.adress_03 AS netgully_adress_03,
    node.descript AS netgully_descript,
    node.rotation AS netgully_rotation,
    node.link AS netgully_link,
    node.verified,
    polygon.the_geom,
    node.workcat_id_end AS netgully_workcat_id_end,
    node.undelete,
    node.label_x AS netgully_label_x,
    node.label_y AS netgully_label_y,
    node.label_rotation AS netgully_label_rotation,
	node.code AS netgully_code,
	node.publish,
	node.inventory,
	node.end_date AS netgully_end_date,
	node.uncertain,
	node.xyz_date AS netgully_xyz_date,
	node.unconnected,
	dma.macrodma_id,
	node.expl_id
   FROM expl_selector, node
     JOIN man_netgully ON man_netgully.node_id::text = node.node_id::text
	 LEFT JOIN dma ON (((node.dma_id)::text = (dma.dma_id)::text))
	 JOIN v_node ON v_node.node_id::text = node.node_id::text
     JOIN polygon ON polygon.pol_id::text = man_netgully.pol_id::text
	 WHERE (node.expl_id)::text=(expl_selector.expl_id)::text
	AND expl_selector.cur_user="current_user"()::text;	 



DROP VIEW IF EXISTS v_edit_man_chamber CASCADE;
CREATE OR REPLACE VIEW v_edit_man_chamber AS 
 SELECT node.node_id,
    node.top_elev AS chamber_top_elev,
	node.est_top_elev AS chamber_est_top_elev,
    node.ymax AS chamber_ymax,
	node.est_ymax AS chamber_est_ymax,
	node.elev AS chamber_elev,
	node.est_elev AS chamber_est_elev,
	v_node.elev AS chamber_sys_elev,
    node.sander AS chamber_sander,
    node.node_type,
    node.nodecat_id,
    node.epa_type,
    node.sector_id,
    node.state,
    node.annotation AS chamber_annotation,
    node.observ AS chamber_observ,
    node.comment AS chamber_comment,
    node.dma_id,
    node.soilcat_id AS chamber_soilcat_id,
    node.category_type AS chamber_category_type,
    node.fluid_type AS chamber_fluid_type,
    node.location_type AS chamber_location_type,
    node.workcat_id AS chamber_workcat_id,
    node.buildercat_id AS chamber_buildercat_id,
    node.builtdate AS chamber_builtdate,
    node.ownercat_id AS chamber_ownercat_id,
    node.adress_01 AS chamber_adress_01,
    node.adress_02 AS chamber_adress_02,
    node.adress_03 AS chamber_adress_03,
    node.descript AS chamber_descript,
    node.rotation AS chamber_rotation,
    node.link AS chamber_link,
    node.verified,
    node.the_geom,
    node.workcat_id_end AS chamber_workcat_id_end,
    node.undelete,
    node.label_x AS chamber_label_x,
    node.label_y AS chamber_label_y,
    node.label_rotation AS chamber_label_rotation,
    man_chamber.pol_id,
    man_chamber.total_volume AS chamber_total_volume,
    man_chamber.total_height AS chamber_total_height,
    man_chamber.total_length AS chamber_total_length,
    man_chamber.total_width AS chamber_total_width,
    man_chamber.chamber_name,
	node.code  AS chamber_code,
	node.publish,
	node.inventory,
	node.end_date AS chamber_end_date,
	node.uncertain,
	node.xyz_date AS chamber_xyz_date,
	node.unconnected,
	dma.macrodma_id,
	man_chamber.inlet AS chamber_inlet,
	man_chamber.bottom_channel AS chamber_bottom_channel,
	man_chamber.accessibility AS chamber_accessibility,
	man_chamber.sandbox AS chamber_sandbox,
	node.expl_id
   FROM expl_selector, node
    JOIN man_chamber ON man_chamber.node_id::text = node.node_id::text
	LEFT JOIN dma ON (((node.dma_id)::text = (dma.dma_id)::text))
	JOIN v_node ON v_node.node_id::text = node.node_id::text
	WHERE (node.expl_id)::text=(expl_selector.expl_id)::text
	AND expl_selector.cur_user="current_user"()::text;
	 
	 
	 
DROP VIEW IF EXISTS v_edit_man_chamber_pol CASCADE;
CREATE OR REPLACE VIEW v_edit_man_chamber_pol AS 
 SELECT 
 polygon.pol_id,
 node.node_id,
    node.top_elev AS chamber_top_elev,
	node.est_top_elev AS chamber_est_top_elev,
    node.ymax AS chamber_ymax,
	node.est_ymax AS chamber_est_ymax,
	node.elev AS chamber_elev,
	node.est_elev AS chamber_est_elev,
	v_node.elev AS chamber_sys_elev,
    node.sander AS chamber_sander,
    node.node_type,
    node.nodecat_id,
    node.epa_type,
    node.sector_id,
    node.state,
    node.annotation AS chamber_annotation,
    node.observ AS chamber_observ,
    node.comment AS chamber_comment,
    node.dma_id,
    node.soilcat_id AS chamber_soilcat_id,
    node.category_type AS chamber_category_type,
    node.fluid_type AS chamber_fluid_type,
    node.location_type AS chamber_location_type,
    node.workcat_id AS chamber_workcat_id,
    node.buildercat_id AS chamber_buildercat_id,
    node.builtdate AS chamber_builtdate,
    node.ownercat_id AS chamber_ownercat_id,
    node.adress_01 AS chamber_adress_01,
    node.adress_02 AS chamber_adress_02,
    node.adress_03 AS chamber_adress_03,
    node.descript AS chamber_descript,
    node.rotation AS chamber_rotation,
    node.link AS chamber_link,
    node.verified,
    polygon.the_geom,
    node.workcat_id_end AS chamber_workcat_id_end,
    node.undelete,
    node.label_x AS chamber_label_x,
    node.label_y AS chamber_label_y,
    node.label_rotation AS chamber_label_rotation,
    man_chamber.total_volume AS chamber_total_volume,
    man_chamber.total_height AS chamber_total_height,
    man_chamber.total_length AS chamber_total_length,
    man_chamber.total_width AS chamber_total_width,
    man_chamber.chamber_name,
	node.code AS chamber_code,
	node.publish,
	node.inventory,
	node.end_date AS chamber_end_date,
	node.uncertain,
	node.xyz_date AS chamber_xyz_date,
	node.unconnected,
	dma.macrodma_id,
	man_chamber.inlet AS chamber_inlet,
	man_chamber.bottom_channel AS chamber_bottom_channel,
	man_chamber.accessibility AS chamber_accessibility,
	man_chamber.sandbox AS chamber_sandbox,
	node.expl_id
   FROM expl_selector, node
     JOIN man_chamber ON man_chamber.node_id::text = node.node_id::text
	 LEFT JOIN dma ON (((node.dma_id)::text = (dma.dma_id)::text))
	 JOIN v_node ON v_node.node_id::text = node.node_id::text
     JOIN polygon ON polygon.pol_id::text = man_chamber.pol_id::text
	 WHERE (node.expl_id)::text=(expl_selector.expl_id)::text
	AND expl_selector.cur_user="current_user"()::text; 



DROP VIEW IF EXISTS v_edit_man_wwtp CASCADE;
CREATE OR REPLACE VIEW v_edit_man_wwtp AS 
 SELECT node.node_id,
    node.top_elev AS wwtp_top_elev,
	node.est_top_elev AS wwtp_est_top_elev,
    node.ymax AS wwtp_ymax,
	node.est_ymax AS wwtp_est_ymax,
	node.elev AS wwtp_elev,
	node.est_elev AS wwtp_est_elev,
	v_node.elev AS wwtp_sys_elev,
    node.sander AS wwtp_sander,
    node.node_type,
    node.nodecat_id,
    node.epa_type,
    node.sector_id,
    node.state,
    node.annotation AS wwtp_annotation,
    node.observ AS wwtp_observ,
    node.comment AS wwtp_comment,
    node.dma_id,
    node.soilcat_id AS wwtp_soilcat_id,
    node.category_type AS wwtp_category_type,
    node.fluid_type AS wwtp_fluid_type,
    node.location_type AS wwtp_location_type,
    node.workcat_id AS wwtp_workcat_id,
    node.buildercat_id AS wwtp_buildercat_id,
    node.builtdate AS wwtp_builtdate,
    node.ownercat_id AS wwtp_ownercat_id,
    node.adress_01 AS wwtp_adress_01,
    node.adress_02 AS wwtp_adress_02,
    node.adress_03 AS wwtp_adress_03,
    node.descript AS wwtp_descript,
    node.rotation AS wwtp_rotation,
    node.link AS wwtp_link,
    node.verified,
    node.the_geom,
    node.workcat_id_end AS wwtp_workcat_id_end,
    node.undelete,
    node.label_x AS wwtp_label_x,
    node.label_y AS wwtp_label_y,
    node.label_rotation AS wwtp_label_rotation,
    man_wwtp.pol_id,
    man_wwtp.wwtp_name,
	node.code AS wwtp_code,
	node.publish,
	node.inventory,
	node.end_date AS wwtp_end_date,
	node.uncertain,
	node.xyz_date AS wwtp_xyz_date,
	node.unconnected,
	dma.macrodma_id,
	node.expl_id
   FROM expl_selector, node
     JOIN man_wwtp ON man_wwtp.node_id::text = node.node_id::text
	 LEFT JOIN dma ON (((node.dma_id)::text = (dma.dma_id)::text))
	 JOIN v_node ON v_node.node_id::text = node.node_id::text
	 WHERE (node.expl_id)::text=(expl_selector.expl_id)::text
	AND expl_selector.cur_user="current_user"()::text; ;



DROP VIEW IF EXISTS v_edit_man_wwtp_pol CASCADE;
CREATE OR REPLACE VIEW v_edit_man_wwtp_pol AS 
 SELECT 
    polygon.pol_id,
	node.node_id,
    node.top_elev AS wwtp_top_elev,
	node.est_top_elev AS wwtp_est_top_elev,
    node.ymax AS wwtp_ymax,
	node.est_ymax AS wwtp_est_ymax,
	node.elev AS wwtp_elev,
	node.est_elev AS wwtp_est_elev,
	v_node.elev AS wwtp_sys_elev,
    node.sander AS wwtp_sander,
    node.node_type,
    node.nodecat_id,
    node.epa_type,
    node.sector_id,
    node.state,
    node.annotation AS wwtp_annotation,
    node.observ AS wwtp_observ,
    node.comment AS wwtp_comment,
    node.dma_id,
    node.soilcat_id AS wwtp_soilcat_id,
    node.category_type AS wwtp_category_type,
    node.fluid_type AS wwtp_fluid_type,
    node.location_type AS wwtp_location_type,
    node.workcat_id AS wwtp_workcat_id,
    node.buildercat_id AS wwtp_buildercat_id,
    node.builtdate AS wwtp_builtdate,
    node.ownercat_id AS wwtp_ownercat_id,
    node.adress_01 AS wwtp_adress_01,
    node.adress_02 AS wwtp_adress_02,
    node.adress_03 AS wwtp_adress_03,
    node.descript AS wwtp_descript,
    node.rotation AS wwtp_rotation,
    node.link AS wwtp_link,
    node.verified,
    polygon.the_geom,
    node.workcat_id_end AS wwtp_workcat_id_end,
    node.undelete,
    node.label_x AS wwtp_label_x,
    node.label_y AS wwtp_label_y,
    node.label_rotation AS wwtp_label_rotation,
    man_wwtp.wwtp_name,
	node.code AS wwtp_code,
	node.publish,
	node.inventory,
	node.end_date AS wwtp_end_date,
	node.uncertain,
	node.xyz_date AS wwtp_xyz_date,
	node.unconnected,
	dma.macrodma_id,
	node.expl_id
   FROM expl_selector, node
     JOIN man_wwtp ON man_wwtp.node_id::text = node.node_id::text
	 LEFT JOIN dma ON (((node.dma_id)::text = (dma.dma_id)::text))
	 JOIN v_node ON v_node.node_id::text = node.node_id::text
     JOIN polygon ON polygon.pol_id::text = man_wwtp.pol_id::text
	 WHERE (node.expl_id)::text=(expl_selector.expl_id)::text
	AND expl_selector.cur_user="current_user"()::text; 



DROP VIEW IF EXISTS v_edit_man_conduit CASCADE;
CREATE OR REPLACE VIEW v_edit_man_conduit AS 
 SELECT arc.arc_id,
    arc.node_1 AS conduit_node_1,
    arc.node_2 AS conduit_node_2,
    arc.y1 AS conduit_y1,
	arc.est_y1 AS conduit_est_y1,
	arc.elev1 AS conduit_elev1,
	arc.est_elev1 AS conduit_est_elev1,
	v_arc_x_node.elevmax1 AS conduit_sys_elev1,
	arc.y2 AS conduit_y2,
	arc.elev2 AS conduit_elev2,
    arc.est_y2 AS conduit_est_y2,
	arc.est_elev2 AS conduit_est_elev2,	
	v_arc_x_node.elevmax2 AS conduit_sys_elev2,
    v_arc_x_node.z1 AS conduit_z1,
    v_arc_x_node.z2 AS conduit_z2,
    v_arc_x_node.r1 AS conduit_r1,
    v_arc_x_node.r2 AS conduit_r2,
    v_arc_x_node.slope AS conduit_slope,
    arc.arc_type,
    arc.arccat_id,
    cat_arc.matcat_id AS conduit_matcat_id,
    cat_arc.shape AS conduit_cat_shape,
    cat_arc.geom1 AS conduit_cat_geom1,
	cat_arc.width AS conduit_cat_width,
    st_length2d(arc.the_geom)::numeric(12,2) AS conduit_gis_length,
    arc.epa_type,
    arc.sector_id,
    arc.state,
    arc.annotation AS conduit_annotation,
    arc.observ AS conduit_observ,
    arc.comment AS conduit_comment,
    arc.inverted_slope AS conduit_inverted_slope,
    arc.custom_length AS conduit_custom_length,
    arc.dma_id,
    arc.soilcat_id AS conduit_soilcat_id,
    arc.category_type AS conduit_category_type,
    arc.fluid_type AS conduit_fluid_type,
    arc.location_type AS conduit_location_type,
    arc.workcat_id AS conduit_workcat_id,
    arc.buildercat_id AS conduit_buildercat_id,
    arc.builtdate AS conduit_builtdate,
    arc.ownercat_id AS conduit_ownercat_id,
    arc.adress_01 AS conduit_adress_01,
    arc.adress_02 AS conduit_adress_02,
    arc.adress_03 AS conduit_adress_03,
    arc.descript AS conduit_descript,
    arc.link AS conduit_link,
    arc.verified,
    arc.the_geom,
    arc.workcat_id_end AS conduit_workcat_id_end,
    arc.undelete,
    arc.label_x AS conduit_label_x,
    arc.label_y AS conduit_label_y,
    arc.label_rotation AS conduit_label_rotation,
	arc.code AS conduit_code,
	arc.publish,
	arc.inventory,
	arc.end_date AS conduit_end_date,
	arc.uncertain,
	dma.macrodma_id,
	arc.expl_id
   FROM expl_selector, arc
     LEFT JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
     LEFT JOIN v_arc_x_node ON v_arc_x_node.arc_id::text = arc.arc_id::text
	 LEFT JOIN dma ON (((arc.dma_id)::text = (dma.dma_id)::text))
     JOIN man_conduit ON man_conduit.arc_id::text = arc.arc_id::text
	 WHERE (arc.expl_id)::text=(expl_selector.expl_id)::text
	AND expl_selector.cur_user="current_user"()::text;





DROP VIEW IF EXISTS v_edit_man_siphon CASCADE;

CREATE OR REPLACE VIEW v_edit_man_siphon AS 
 SELECT arc.arc_id,
     arc.node_1 AS siphon_node_1,
    arc.node_2 AS siphon_node_2,
    arc.y1 AS siphon_y1,
	arc.est_y1 AS siphon_est_y1,
	arc.elev1 AS siphon_elev1,
	arc.est_elev1 AS siphon_est_elev1,
	v_arc_x_node.elevmax1 AS siphon_sys_elev1,
	arc.y2 AS siphon_y2,
	arc.elev2 AS siphon_elev2,
    arc.est_y2 AS siphon_est_y2,
	arc.est_elev2 AS siphon_est_elev2,	
	v_arc_x_node.elevmax2 AS siphon_sys_elev2,
    v_arc_x_node.z1 AS siphon_z1,
    v_arc_x_node.z2 AS siphon_z2,
    v_arc_x_node.r1 AS siphon_r1,
    v_arc_x_node.r2 AS siphon_r2,
    v_arc_x_node.slope AS siphon_slope,
    arc.arc_type,
    arc.arccat_id,
    cat_arc.matcat_id AS siphon_matcat_id,
    cat_arc.shape AS siphon_cat_shape,
    cat_arc.geom1 AS siphon_cat_geom1,
	cat_arc.width AS siphon_cat_width,
    st_length2d(arc.the_geom)::numeric(12,2) AS siphon_gis_length,
    arc.epa_type,
    arc.sector_id,
    arc.state,
    arc.annotation AS siphon_annotation,
    arc.observ AS siphon_observ,
    arc.comment AS siphon_comment,
    arc.inverted_slope AS siphon_inverted_slope,
    arc.custom_length AS siphon_custom_length,
    arc.dma_id,
    arc.soilcat_id AS siphon_soilcat_id,
    arc.category_type AS siphon_category_type,
    arc.fluid_type AS siphon_fluid_type,
    arc.location_type AS siphon_location_type,
    arc.workcat_id AS siphon_workcat_id,
    arc.buildercat_id AS siphon_buildercat_id,
    arc.builtdate AS siphon_builtdate,
    arc.ownercat_id AS siphon_ownercat_id,
    arc.adress_01 AS siphon_adress_01,
    arc.adress_02 AS siphon_adress_02,
    arc.adress_03 AS siphon_adress_03,
    arc.descript AS siphon_descript,
    arc.link AS siphon_link,
    arc.verified,
    arc.the_geom,
    arc.workcat_id_end AS siphon_workcat_id_end,
    arc.undelete,
    arc.label_x AS siphon_label_x,
    arc.label_y AS siphon_label_y,
    arc.label_rotation AS siphon_label_rotation,
    man_siphon.security_bar AS siphon_security_bar,
    man_siphon.steps AS siphon_steps,
    man_siphon.siphon_name,
	arc.code AS siphon_code,
	arc.publish,
	arc.inventory,
	arc.end_date AS siphon_end_date,
	arc.uncertain,
	dma.macrodma_id,
	arc.expl_id
   FROM expl_selector, arc
     LEFT JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
     LEFT JOIN v_arc_x_node ON v_arc_x_node.arc_id::text = arc.arc_id::text
	 LEFT JOIN dma ON (((arc.dma_id)::text = (dma.dma_id)::text))
     JOIN man_siphon ON man_siphon.arc_id::text = arc.arc_id::text
	 WHERE (arc.expl_id)::text=(expl_selector.expl_id)::text
	AND expl_selector.cur_user="current_user"()::text;





DROP VIEW IF EXISTS v_edit_man_waccel CASCADE;
CREATE OR REPLACE VIEW v_edit_man_waccel AS 
 SELECT arc.arc_id,
    arc.node_1 AS waccel_node_1,
    arc.node_2 AS waccel_node_2,
    arc.y1 AS waccel_y1,
	arc.est_y1 AS waccel_est_y1,
	arc.elev1 AS waccel_elev1,
	arc.est_elev1 AS waccel_est_elev1,
	v_arc_x_node.elevmax1 AS waccel_sys_elev1,
	arc.y2 AS waccel_y2,
	arc.elev2 AS waccel_elev2,
    arc.est_y2 AS waccel_est_y2,
	arc.est_elev2 AS waccel_est_elev2,	
	v_arc_x_node.elevmax2 AS waccel_sys_elev2,
    v_arc_x_node.z1 AS waccel_z1,
    v_arc_x_node.z2 AS waccel_z2,
    v_arc_x_node.r1 AS waccel_r1,
    v_arc_x_node.r2 AS waccel_r2,
    v_arc_x_node.slope AS waccel_slope,
    arc.arc_type,
    arc.arccat_id,
    cat_arc.matcat_id AS waccel_matcat_id,
    cat_arc.shape AS waccel_cat_shape,
    cat_arc.geom1 AS waccel_cat_geom1,
	cat_arc.width AS waccel_cat_width,
    st_length2d(arc.the_geom)::numeric(12,2) AS waccel_gis_length,
    arc.epa_type,
    arc.sector_id,
    arc.state,
    arc.annotation AS waccel_annotation,
    arc.observ AS waccel_observ,
    arc.comment AS waccel_comment,
    arc.inverted_slope AS waccel_inverted_slope,
    arc.custom_length AS waccel_custom_length,
    arc.dma_id,
    arc.soilcat_id AS waccel_soilcat_id,
    arc.category_type AS waccel_category_type,
    arc.fluid_type AS waccel_fluid_type,
    arc.location_type AS waccel_location_type,
    arc.workcat_id AS waccel_workcat_id,
    arc.buildercat_id AS waccel_buildercat_id,
    arc.builtdate AS waccel_builtdate,
    arc.ownercat_id AS waccel_ownercat_id,
    arc.adress_01 AS waccel_adress_01,
    arc.adress_02 AS waccel_adress_02,
    arc.adress_03 AS waccel_adress_03,
    arc.descript AS waccel_descript,
    arc.link AS waccel_link,
    arc.verified,
    arc.the_geom,
    arc.workcat_id_end AS waccel_workcat_id_end,
    arc.undelete,
    arc.label_x AS waccel_label_x,
    arc.label_y AS waccel_label_y,
    arc.label_rotation AS waccel_label_rotation,
    man_waccel.sander_length AS waccel_sander_length,
    man_waccel.sander_depth AS waccel_sander_depth,
    man_waccel.security_bar AS waccel_security_bar,
    man_waccel.steps AS waccel_steps,
    man_waccel.prot_surface AS waccel_prot_surface,
    man_waccel.waccel_name,
	arc.code AS waccel_code,
	arc.publish,
	arc.inventory,
	arc.end_date AS waccel_end_date,
	arc.uncertain,
	dma.macrodma_id,
	arc.expl_id
   FROM expl_selector, arc
     LEFT JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
     LEFT JOIN v_arc_x_node ON v_arc_x_node.arc_id::text = arc.arc_id::text
	 LEFT JOIN dma ON (((arc.dma_id)::text = (dma.dma_id)::text))
     JOIN man_waccel ON man_waccel.arc_id::text = arc.arc_id::text
	 WHERE (arc.expl_id)::text=(expl_selector.expl_id)::text
	AND expl_selector.cur_user="current_user"()::text;;




DROP VIEW IF EXISTS v_edit_man_varc CASCADE;
CREATE OR REPLACE VIEW v_edit_man_varc AS 
 SELECT arc.arc_id,
     arc.node_1 AS varc_node_1,
    arc.node_2 AS varc_node_2,
    arc.y1 AS varc_y1,
	arc.est_y1 AS varc_est_y1,
	arc.elev1 AS varc_elev1,
	arc.est_elev1 AS varc_est_elev1,
	v_arc_x_node.elevmax1 AS varc_sys_elev1,
	arc.y2 AS varc_y2,
	arc.elev2 AS varc_elev2,
    arc.est_y2 AS varc_est_y2,
	arc.est_elev2 AS varc_est_elev2,	
	v_arc_x_node.elevmax2 AS varc_sys_elev2,
    v_arc_x_node.z1 AS varc_z1,
    v_arc_x_node.z2 AS varc_z2,
    v_arc_x_node.r1 AS varc_r1,
    v_arc_x_node.r2 AS varc_r2,
    v_arc_x_node.slope AS varc_slope,
    arc.arc_type,
    arc.arccat_id,
    cat_arc.matcat_id AS varc_matcat_id,
    cat_arc.shape AS varc_cat_shape,
    cat_arc.geom1 AS varc_cat_geom1,
    st_length2d(arc.the_geom)::numeric(12,2) AS varc_gis_length,
    arc.epa_type,
    arc.sector_id,
    arc.state,
    arc.annotation AS varc_annotation,
    arc.observ AS varc_observ,
    arc.comment AS varc_comment,
    arc.inverted_slope AS varc_inverted_slope,
    arc.custom_length AS varc_custom_length,
    arc.dma_id,
    arc.soilcat_id AS varc_soilcat_id,
    arc.category_type AS varc_category_type,
    arc.fluid_type AS varc_fluid_type,
    arc.location_type AS varc_location_type,
    arc.workcat_id AS varc_workcat_id,
    arc.buildercat_id AS varc_buildercat_id,
    arc.builtdate AS varc_builtdate,
    arc.ownercat_id AS varc_ownercat_id,
    arc.adress_01 AS varc_adress_01,
    arc.adress_02 AS varc_adress_02,
    arc.adress_03 AS varc_adress_03,
    arc.descript AS varc_descript,
    arc.link AS varc_link,
    arc.verified,
    arc.the_geom,
    arc.workcat_id_end AS varc_workcat_id_end,
    arc.undelete,
    arc.label_x AS varc_label_x,
    arc.label_y AS varc_label_y,
    arc.label_rotation AS varc_label_rotation,
	arc.code AS varc_code,
	arc.publish,
	arc.inventory,
	arc.end_date AS varc_end_date,
	arc.uncertain,
	dma.macrodma_id,
	arc.expl_id
   FROM expl_selector, arc
     LEFT JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
     LEFT JOIN v_arc_x_node ON v_arc_x_node.arc_id::text = arc.arc_id::text
	 LEFT JOIN dma ON (((arc.dma_id)::text = (dma.dma_id)::text))
     JOIN man_varc ON man_varc.arc_id::text = arc.arc_id::text
	 WHERE (arc.expl_id)::text=(expl_selector.expl_id)::text
	AND expl_selector.cur_user="current_user"()::text;



DROP VIEW IF EXISTS v_edit_man_connec CASCADE;
CREATE OR REPLACE VIEW v_edit_man_connec AS
SELECT connec.connec_id, 
connec.top_elev, 
connec.ymax, 
connec.connec_type,
connec.connecat_id,
cat_connec.matcat_id AS "cat_matcat_id",
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
ext_streetaxis.name AS "streetname",
connec.postnumber,
connec.descript,
vnode.arc_id,
cat_connec.svg AS "cat_svg",
connec.rotation,
connec.link,
connec.verified,
connec.the_geom,
connec.workcat_id_end,
connec.y1,
connec.y2,
connec.undelete,
connec.featurecat_id,
connec.feature_id,
connec.private_connecat_id,
connec.label_x,
connec.label_y,
connec.label_rotation,
connec.accessibility,
connec.diagonal,
connec.publish,
connec.inventory,
connec.end_date,
connec.uncertain,
dma.macrodma_id,
connec.expl_id
FROM expl_selector, connec 
JOIN cat_connec ON (((connec.connecat_id)::text = (cat_connec.id)::text))
LEFT JOIN ext_streetaxis ON (((connec.streetaxis_id)::text = (ext_streetaxis.id)::text))
LEFT JOIN link ON connec.connec_id::text = link.connec_id::text
LEFT JOIN vnode ON vnode.vnode_id::text = link.vnode_id
LEFT JOIN dma ON (((connec.dma_id)::text = (dma.dma_id)::text))
WHERE (connec.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text;



DROP VIEW IF EXISTS v_edit_man_gully CASCADE;
CREATE OR REPLACE VIEW v_edit_man_gully AS
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
gully.arc_id,
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
gully.the_geom,
gully.undelete,
gully.workcat_id_end,
gully.featurecat_id,
gully.feature_id,
gully.label_x,
gully.label_y,
gully.label_rotation,
gully.code,
gully.publish,
gully.inventory,
gully.end_date,
dma.macrodma_id,
gully.streetaxis_id,
ext_streetaxis.name AS streetname,
gully.postnumber,
gully.expl_id,
gully.connec_length,
gully.connec_depth 
FROM expl_selector, gully 
LEFT JOIN cat_grate ON (((gully.gratecat_id)::text = (cat_grate.id)::text))
LEFT JOIN ext_streetaxis ON gully.streetaxis_id::text = ext_streetaxis.id::text
LEFT JOIN dma ON (((gully.dma_id)::text = (dma.dma_id)::text))
WHERE gully.the_geom is not null 
AND (gully.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text;


DROP VIEW IF EXISTS v_edit_man_pgully CASCADE;
CREATE OR REPLACE VIEW v_edit_man_pgully AS
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
gully.siphon,
gully.arccat_id,
gully.arc_id,
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
gully.the_geom_pol AS "the_geom",
gully.undelete,
gully.workcat_id_end,
gully.featurecat_id,
gully.feature_id,
gully.label_x,
gully.label_y,
gully.label_rotation,
gully.code,
gully.publish,
gully.inventory,
gully.end_date,
dma.macrodma_id,
gully.streetaxis_id,
gully.postnumber,
gully.expl_id,
gully.connec_length,
gully.connec_depth 
FROM expl_selector, gully 
LEFT JOIN cat_grate ON (((gully.gratecat_id)::text = (cat_grate.id)::text))
LEFT JOIN dma ON (((gully.dma_id)::text = (dma.dma_id)::text))
WHERE gully.the_geom_pol is not null
AND (gully.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text;



DROP VIEW IF EXISTS v_edit_sector CASCADE;
CREATE VIEW v_edit_sector AS SELECT
	sector.sector_id,
	sector.descript,
	sector.the_geom,
	sector.undelete,
	sector.expl_id
FROM expl_selector,sector 
WHERE ((sector.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text);

DROP VIEW IF EXISTS v_edit_dma CASCADE;
CREATE VIEW v_edit_dma AS SELECT
	dma.dma_id,
	dma.sector_id,
	dma.descript,
	dma.observ,
	dma.the_geom,
	dma.undelete,
	dma.macrodma_id,
	dma.expl_id
	FROM expl_selector, dma 
WHERE ((dma.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text);
  
  

DROP VIEW IF EXISTS v_edit_polygon CASCADE;
CREATE VIEW v_edit_polygon AS SELECT
	pol_id,
	text,
	polygon.the_geom,
	polygon.undelete,
	polygon.expl_id
FROM expl_selector, polygon
WHERE ((polygon.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text);


DROP VIEW IF EXISTS v_edit_vnode CASCADE;
CREATE VIEW v_edit_vnode AS SELECT
	vnode_id,
	userdefined_pos,
	vnode_type,
	sector_id,
	state,
	annotation,
	vnode.the_geom,
	vnode.expl_id
FROM expl_selector,vnode
WHERE ((vnode.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text);


DROP VIEW IF EXISTS v_edit_point CASCADE;
CREATE VIEW v_edit_point AS SELECT
	point_id,
	point_type,
	observ,
	text,
	link,
	point.the_geom,
	point.expl_id
FROM expl_selector,point
WHERE ((point.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text);


DROP VIEW IF EXISTS v_edit_samplepoint CASCADE;
CREATE VIEW v_edit_samplepoint AS SELECT
	sample_id,
	state,
	rotation,
	code_lab,
	element_type,
	workcat_id,
	workcat_id_end,
	street1,
	street2,
	place_name,
	dma_id,
	sector_id,
	representative,
	samplepoint.the_geom,
	samplepoint.expl_id
FROM expl_selector,samplepoint
WHERE ((samplepoint.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text);

DROP VIEW IF EXISTS v_edit_element CASCADE;
CREATE VIEW v_edit_element AS SELECT
	element_id,
	elementcat_id,
	state,
	annotation,
	observ,
	comment,
	location_type,
	workcat_id,
	buildercat_id,
	builtdate,
	ownercat_id,
	enddate AS end_date,
	rotation,
	link,
	verified,
	workcat_id_end,
	code,
	element.the_geom,
	element.expl_id
FROM expl_selector,element
WHERE ((element.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text);


DROP VIEW IF EXISTS v_edit_catchment CASCADE;
CREATE VIEW v_edit_catchment AS SELECT
	catchment_id,
	catchment.descript,
	text,
	catchment.the_geom,
	catchment.undelete,
	catchment.expl_id
FROM expl_selector,catchment
WHERE ((catchment.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text);

  
 --REVIEW TABLES 

DROP VIEW IF EXISTS v_edit_review_node CASCADE;
CREATE VIEW v_edit_review_node AS 
 SELECT review_audit_node.node_id,
 node.nodecat_id,
    node.top_elev,
    node.ymax,
	node."state",
	review_audit_node.nodecat_id AS field_nodecat_id,
    review_audit_node.top_elev AS field_top_elev,
    review_audit_node.ymax AS field_ymax,
    review_audit_node.annotation,
    review_audit_node.observ,
	review_audit_node.moved_geom,
    review_audit_node.office_checked,
	review_audit_node.the_geom	
   FROM node
     RIGHT JOIN review_audit_node ON node.node_id::text = review_audit_node.node_id::text
  WHERE review_audit_node.field_checked IS TRUE AND review_audit_node.office_checked IS NOT TRUE;
  

CREATE OR REPLACE VIEW v_edit_review_arc AS 
 SELECT review_audit_arc.arc_id,
	arc.arc_type,
    arc.arccat_id,
    arc.y1,
    arc.y2,
	arc."state",
	review_audit_arc.arc_type AS field_arc_type,
    review_audit_arc.arccat_id AS field_arccat_id,
    review_audit_arc.y1 AS field_y1,
    review_audit_arc.y2 AS field_y2,
    review_audit_arc.annotation,
    review_audit_arc.observ,
    review_audit_arc.moved_geom,
    review_audit_arc.office_checked,
    review_audit_arc.the_geom
   FROM arc
     RIGHT JOIN review_audit_arc ON arc.arc_id::text = review_audit_arc.arc_id::text
  WHERE review_audit_arc.field_checked IS TRUE AND review_audit_arc.office_checked IS NOT TRUE;
  
  
  CREATE OR REPLACE VIEW v_edit_review_connec AS 
	SELECT review_audit_connec.connec_id,
	 connec.top_elev,
	 connec.ymax,
	 connec.connec_type,
	 connec.connecat_id,
	 connec."state",
	 review_audit_connec.top_elev as field_top_elev,
	 review_audit_connec.ymax AS field_ymax,
	 review_audit_connec.connec_type AS field_connec_type,
	 review_audit_connec.connecat_id AS field_connecat_id,
	 review_audit_connec.annotation,
	 review_audit_connec.observ,
	 review_audit_connec.moved_geom,
	 review_audit_connec.office_checked,
	 review_audit_connec.the_geom
	 FROM connec
		RIGHT JOIN review_audit_connec ON connec.connec_id::text = review_audit_connec.connec_id::text
  WHERE review_audit_connec.field_checked IS TRUE AND review_audit_connec.office_checked IS NOT TRUE;

  
  CREATE OR REPLACE VIEW v_edit_review_gully AS 
	SELECT review_audit_gully.gully_id,
	 gully.top_elev,
	 gully.ymax,
	 gully.matcat_id,
	 gully.gratecat_id,
	 gully.units,
	 gully.groove,
	 gully.arccat_id,
	 gully.arc_id,
	 gully.siphon,
	 gully.featurecat_id,
	 gully.feature_id,
	 gully."state",
	 review_audit_gully.ymax AS field_ymax,
	 review_audit_gully.top_elev as field_top_elev,
	 review_audit_gully.matcat_id AS field_matcat_id,
	 review_audit_gully.gratecat_id AS field_gratecat_id,
	 review_audit_gully.units AS field_units,
	 review_audit_gully.groove AS field_groove,
	 review_audit_gully.arccat_id AS field_arccat_id,
	 review_audit_gully.arc_id AS field_arc_id,
	 review_audit_gully.siphon AS field_siphon,
	 review_audit_gully.featurecat_id AS field_featurecat_id,
	 review_audit_gully.feature_id AS field_feature_id,	 
	 review_audit_gully.annotation,
	 review_audit_gully.observ,
	 review_audit_gully.moved_geom,
	 review_audit_gully.office_checked,
	 review_audit_gully.the_geom
	 FROM gully
		RIGHT JOIN review_audit_gully ON gully.gully_id::text = review_audit_gully.gully_id::text
  WHERE review_audit_gully.field_checked IS TRUE AND review_audit_gully.office_checked IS NOT TRUE;

  
