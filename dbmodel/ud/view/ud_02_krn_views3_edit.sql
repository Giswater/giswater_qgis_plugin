/*
This file is part of Giswater 20 (Sao Caetano)
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;



DROP VIEW IF EXISTS v_edit_macrosector CASCADE;
CREATE VIEW v_edit_macrosector AS SELECT DISTINCT on (macrosector_id)
	sector.macrosector_id,
	macrosector.name,
	macrosector.descript,
	macrosector.the_geom,
	macrosector.undelete
FROM inp_selector_sector, sector 
JOIN macrosector ON macrosector.macrosector_id=sector.macrosector_id
WHERE ((sector.sector_id)=(inp_selector_sector.sector_id)
AND inp_selector_sector.cur_user="current_user"());  



DROP VIEW IF EXISTS v_edit_sector CASCADE;
CREATE VIEW v_edit_sector AS SELECT
	sector.sector_id,
	sector.name,
	sector.macrosector_id,
	sector.descript,
	sector.the_geom,
	sector.undelete
FROM inp_selector_sector,sector 
WHERE ((sector.sector_id)=(inp_selector_sector.sector_id)
AND inp_selector_sector.cur_user="current_user"());  


  
  
DROP VIEW IF EXISTS v_edit_dma CASCADE;
CREATE VIEW v_edit_dma AS SELECT
	dma.dma_id,
	dma.name,
	dma.descript,
	dma.the_geom,
	dma.undelete,
	dma.expl_id
	FROM selector_expl, dma 
WHERE ((dma.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());
  



-- ----------------------------
-- Editing views structure
-- ----------------------------

DROP VIEW IF EXISTS v_edit_node CASCADE;
CREATE VIEW v_edit_node AS
SELECT 
node.node_id, 
node.code,
node.top_elev, 
node.est_top_elev,
node.ymax,
node.est_ymax,
node.elev,
node.est_elev,
v_node.elev AS sys_elev,
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
node.function_type,
node.category_type,
node.fluid_type,
node.location_type,
node.workcat_id,
node.workcat_id_end,
node.buildercat_id,
node.builtdate,
node.enddate,
node.ownercat_id,
node.address_01,
node.address_02,
node.address_03,
node.descript,
cat_node.svg AS "cat_svg",
node.rotation,
node.link,
node.verified,
node.the_geom,
node.undelete,
node.label_x,
node.label_y,
node.label_rotation,
node.publish,
node.inventory,
node.uncertain,
node.xyz_date,
node.unconnected,
node.expl_id,
node.num_value
FROM selector_expl,node
	JOIN v_node ON node.node_id=v_node.node_id
	LEFT JOIN cat_node ON ((node.nodecat_id) = (cat_node.id))
	LEFT JOIN sector ON node.sector_id = sector.sector_id
	WHERE ((node.expl_id)=(selector_expl.expl_id) AND selector_expl.cur_user="current_user"());



  
DROP VIEW IF EXISTS v_edit_arc CASCADE;
CREATE VIEW v_edit_arc AS
SELECT 
arc.arc_id, 
arc.code,
arc.node_1,
arc.node_2,
arc.y1, 
arc.custom_y1,
arc.elev1,
arc.custom_elev1,
v_arc_x_node.elevmax1 as sys_elev1,
arc.y2,
arc.custom_y2,
arc.elev2,
arc.custom_elev2,
v_arc_x_node.elevmax2 as sys_elev2,
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
arc.function_type,
arc.category_type,
arc.fluid_type,
arc.location_type,
arc.workcat_id,
arc.workcat_id_end,
arc.buildercat_id,
arc.builtdate,
arc.enddate,
arc.ownercat_id,
arc.address_01,
arc.address_02,
arc.address_03,
arc.descript,
arc.link,
arc.verified,
arc.the_geom,
arc.undelete,
arc.label_x,
arc.label_y,
arc.label_rotation,
arc.publish,
arc.inventory,
arc.uncertain,	
sector.macrosector_id,
arc.expl_id,
arc.num_value
FROM selector_expl, arc
	JOIN v_arc_x_node ON (((v_arc_x_node.arc_id) = (arc.arc_id)))
	LEFT JOIN cat_arc ON (((arc.arccat_id) = (cat_arc.id)))
	LEFT JOIN sector ON arc.sector_id = sector.sector_id
	WHERE (arc.expl_id)=(selector_expl.expl_id) AND selector_expl.cur_user="current_user"();


DROP VIEW IF EXISTS v_edit_connec CASCADE;
CREATE OR REPLACE VIEW v_edit_connec AS
SELECT connec.connec_id, 
connec.code,
connec.customer_code,
connec.top_elev, 
connec.y1,
connec.y2,
connec.connecat_id,
connec.connec_type,
connec.private_connecat_id,
cat_connec.matcat_id AS "cat_matcat_id",
connec.sector_id,
connec.demand,
connec."state", 
connec_arccat_id,
connec_depth,
connec_length,
connec.arc_id,
connec.annotation, 
connec.observ, 
connec."comment",
connec.dma_id,
connec.soilcat_id,
connec.function_type,
connec.category_type,
connec.fluid_type,
connec.location_type,
connec.workcat_id,
connec.workcat_id_end,
connec.buildercat_id,
connec.builtdate,
connec.enddate,
connec.ownercat_id,
connec.address_01,
connec.address_02,
connec.address_03,
connec.streetaxis_id,
ext_streetaxis.name,
connec.postnumber,
connec.descript,
cat_connec.svg AS "cat_svg",
connec.rotation,
connec.link,
connec.verified,
connec.the_geom,
connec.undelete,
connec.featurecat_id,
connec.feature_id,
connec.label_x,
connec.label_y,
connec.label_rotation,
connec.accessibility,
connec.diagonal,
connec.publish,
connec.inventory,
connec.uncertain,
sector.macrosector_id,
connec.expl_id,
connec.num_value
FROM selector_expl, selector_state, connec 
	JOIN cat_connec ON connec.connecat_id = cat_connec.id
	LEFT JOIN ext_streetaxis ON (((connec.streetaxis_id) = (ext_streetaxis.id)))
	LEFT JOIN link ON connec.connec_id = link.feature_id
	LEFT JOIN sector ON connec.sector_id = sector.sector_id
	LEFT JOIN vnode ON vnode.vnode_id = link.vnode_id
	WHERE 
	connec.expl_id=selector_expl.expl_id AND selector_expl.cur_user="current_user"() AND
	connec.state=selector_state.state_id AND selector_state.cur_user="current_user"();



DROP VIEW IF EXISTS v_edit_gully CASCADE;
CREATE OR REPLACE VIEW v_edit_gully AS
SELECT 
gully.gully_id, 
gully.code,
gully.top_elev, 
gully.ymax, 
gully.sandbox,
gully.matcat_id,
gully.gratecat_id,
cat_grate.matcat_id AS "cat_grate_matcat",
gully.units,
gully.groove,
gully.siphon,
gully.connec_arccat_id,
gully.connec_length,
gully.connec_depth,
gully.arc_id,
gully.sector_id, 
gully."state", 
gully.annotation, 
gully.observ, 
gully."comment",
gully.dma_id,
gully.soilcat_id,
gully.function_type,
gully.category_type,
gully.fluid_type,
gully.location_type,
gully.workcat_id,
gully.workcat_id_end,
gully.buildercat_id,
gully.builtdate,
gully.enddate,
gully.ownercat_id,
gully.address_01,
gully.address_02,
gully.address_03,
gully.descript,
cat_grate.svg AS "cat_svg",
gully.rotation,
gully.link,
gully.verified,
gully.the_geom,
gully.undelete,
gully.featurecat_id,
gully.feature_id,
gully.label_x,
gully.label_y,
gully.label_rotation,
gully.publish,
gully.inventory,
sector.macrosector_id,
gully.streetaxis_id,
ext_streetaxis.name AS streetname,
gully.postnumber,
gully.expl_id,
gully.uncertain,
gully.num_value
FROM selector_expl, selector_state, gully 
	LEFT JOIN cat_grate ON (((gully.gratecat_id) = (cat_grate.id)))
	LEFT JOIN ext_streetaxis ON gully.streetaxis_id = ext_streetaxis.id
	LEFT JOIN sector ON gully.sector_id = sector.sector_id
	WHERE gully.the_geom is not null AND
	gully.expl_id=selector_expl.expl_id AND selector_expl.cur_user="current_user"() AND
	gully.state=selector_state.state_id AND selector_state.cur_user="current_user"();


DROP VIEW IF EXISTS v_edit_gully_pol CASCADE;
CREATE OR REPLACE VIEW v_edit_gully_pol AS
SELECT
gully.gully_id, 
gully.code,
gully.top_elev, 
gully.ymax, 
gully.sandbox,
gully.matcat_id,
gully.gratecat_id,
cat_grate.matcat_id AS "cat_grate_matcat",
gully.units,
gully.groove,
gully.siphon,
gully.connec_arccat_id,
gully.connec_length,
gully.connec_depth,
gully.arc_id,
gully.sector_id, 
gully."state", 
gully.annotation, 
gully.observ, 
gully."comment",
gully.dma_id,
gully.soilcat_id,
gully.function_type,
gully.category_type,
gully.fluid_type,
gully.location_type,
gully.workcat_id,
gully.workcat_id_end,
gully.buildercat_id,
gully.builtdate,
gully.enddate,
gully.ownercat_id,
gully.address_01,
gully.address_02,
gully.address_03,
gully.descript,
cat_grate.svg AS "cat_svg",
gully.rotation,
gully.link,
gully.verified,
gully.the_geom_pol,
gully.undelete,
gully.featurecat_id,
gully.feature_id,
gully.label_x,
gully.label_y,
gully.label_rotation,
gully.publish,
gully.inventory,
sector.macrosector_id,
gully.streetaxis_id,
ext_streetaxis.name AS streetname,
gully.postnumber,
gully.expl_id,
gully.uncertain,
gully.num_value
FROM selector_expl, selector_state, gully 
	LEFT JOIN cat_grate ON (((gully.gratecat_id) = (cat_grate.id)))
	LEFT JOIN ext_streetaxis ON streetaxis_id=ext_streetaxis.id
	LEFT JOIN sector ON gully.sector_id = sector.sector_id
	WHERE gully.the_geom_pol is not null AND
	gully.expl_id=selector_expl.expl_id AND selector_expl.cur_user="current_user"() AND
	gully.state=selector_state.state_id AND selector_state.cur_user="current_user"();



	

DROP VIEW IF EXISTS v_edit_link CASCADE;
CREATE OR REPLACE VIEW v_edit_link AS 
SELECT 
link.link_id,
link.featurecat_id,
link.feature_id,
link.vnode_id,
vnode.sector_id,
vnode.dma_id,
vnode.state,
st_length2d(link.the_geom) AS gis_length,
link.the_geom,
vnode.expl_id
FROM selector_expl, selector_state, link
	JOIN vnode on link.vnode_id=vnode.vnode_id
	WHERE 
	vnode.expl_id=selector_expl.expl_id AND selector_expl.cur_user="current_user"() AND
	vnode.state=selector_state.state_id AND selector_state.cur_user="current_user"();

  
  
DROP VIEW IF EXISTS v_edit_vnode CASCADE;
CREATE VIEW v_edit_vnode AS SELECT
vnode_id,
userdefined_pos,
vnode_type,
vnode.sector_id,
vnode.dma_id,
vnode.state,
annotation,
vnode.the_geom,
vnode.expl_id
FROM selector_expl, selector_state, vnode
	WHERE 
	vnode.expl_id=selector_expl.expl_id AND selector_expl.cur_user="current_user"() AND
	vnode.state=selector_state.state_id AND selector_state.cur_user="current_user"();


	
	
	
	

DROP VIEW IF EXISTS v_edit_man_junction CASCADE;
CREATE OR REPLACE VIEW v_edit_man_junction AS 
SELECT 
node.node_id,
node.code AS junction_code,
node.top_elev AS junction_top_elev,
node.custom_top_elev AS junction_custom_top_elev,
node.ymax AS junction_ymax,
node.custom_ymax AS junction_custom_ymax,
node.elev AS junction_elev,
node.custom_elev AS junction_custom_elev,
v_node.elev AS junction_sys_elev,
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
node.function_type AS junction_function_type,
node.category_type AS junction_category_type,
node.fluid_type AS junction_fluid_type,
node.location_type AS junction_location_type,
node.workcat_id AS junction_workcat_id,
node.workcat_id_end AS junction_workcat_id_end,
node.buildercat_id AS junction_buildercat_id,
node.builtdate AS junction_builtdate,
node.enddate AS junction_enddate,
node.ownercat_id AS junction_ownercat_id,
node.address_01 AS junction_address_01,
node.address_02 AS junction_address_02,
node.address_03 AS junction_address_03,
node.descript AS junction_descript,
node.rotation AS junction_rotation,
node.link AS junction_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS junction_label_x,
node.label_y AS junction_label_y,
node.label_rotation AS junction_label_rotation,
node.publish,
node.inventory,
node.uncertain,
node.xyz_date AS junction_xyz_date,
node.unconnected,
sector.macrosector_id,
node.expl_id,
node.num_value
FROM selector_expl, node
	JOIN man_junction ON man_junction.node_id = node.node_id
	LEFT JOIN sector ON node.sector_id = sector.sector_id
	JOIN v_node ON v_node.node_id = node.node_id
	WHERE (node.expl_id)=(selector_expl.expl_id) AND selector_expl.cur_user="current_user"();

	 
DROP VIEW IF EXISTS v_edit_man_outfall CASCADE;
CREATE OR REPLACE VIEW v_edit_man_outfall AS 
SELECT 
node.node_id,
node.code AS outlfall_code,
node.top_elev AS outfall_top_elev,
node.custom_top_elev AS outfall_custom_top_elev,
node.ymax AS outfall_ymax,
node.custom_ymax AS outfall_custom_ymax,
node.elev AS outfall_elev,
node.custom_elev AS outfall_custom_elev,
v_node.elev AS outfall_sys_elev,
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
node.function_type AS outfall_function_type,
node.category_type AS outfall_category_type,
node.fluid_type AS outfall_fluid_type,
node.location_type AS outfall_location_type,
node.workcat_id AS outfall_workcat_id,
node.workcat_id_end AS outfall_workcat_id_end,
node.buildercat_id AS outfall_buildercat_id,
node.builtdate AS outfall_builtdate,
node.enddate AS outfall_enddate,
node.ownercat_id AS outfall_ownercat_id,
node.address_01 AS outfall_address_01,
node.address_02 AS outfall_address_02,
node.address_03 AS outfall_address_03,
node.descript AS outfall_descript,
node.rotation AS outfall_rotation,
node.link AS outfall_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS outfall_label_x,
node.label_y AS outfall_label_y,
node.label_rotation AS outfall_label_rotation,
man_outfall.name AS outfall_name,
node.code AS outfall_code,
node.publish,
node.inventory,
node.uncertain,
node.xyz_date AS outfall_xyz_date,
node.unconnected,
sector.macrosector_id,
node.expl_id,
node.num_value,
man_outfall.name AS outfall_name
FROM selector_expl, node
	JOIN man_outfall ON man_outfall.node_id = node.node_id
	JOIN v_node ON v_node.node_id = node.node_id
	LEFT JOIN sector ON node.sector_id = sector.sector_id
	WHERE (node.expl_id)=(selector_expl.expl_id) AND selector_expl.cur_user="current_user"();

	 
DROP VIEW IF EXISTS v_edit_man_storage CASCADE;
CREATE OR REPLACE VIEW v_edit_man_storage AS 
SELECT 
node.node_id,
node.code as storage_code,
node.top_elev AS storage_top_elev,
node.custom_top_elev AS storage_custom_top_elev,
node.ymax AS storage_ymax,
node.custom_ymax AS storage_custom_ymax,
node.elev AS storage_elev,
node.custom_elev AS storage_custom_elev,
v_node.elev AS storage_sys_elev,
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
node.function_type AS storage_function_type,
node.category_type AS storage_category_type,
node.fluid_type AS storage_fluid_type,
node.location_type AS storage_location_type,
node.workcat_id AS storage_workcat_id,
node.workcat_id_end AS storage_workcat_id_end,
node.buildercat_id AS storage_buildercat_id,
node.builtdate AS storage_builtdate,
node.enddate AS storage_enddate,
node.ownercat_id AS storage_ownercat_id,
node.address_01 AS storage_address_01,
node.address_02 AS storage_address_02,
node.address_03 AS storage_address_03,
node.descript AS storage_descript,
node.rotation AS storage_rotation,
node.link AS storage_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS storage_label_x,
node.label_y AS storage_label_y,
node.label_rotation AS storage_label_rotation,
node.publish,
node.inventory,
node.uncertain,
node.xyz_date AS storage_xyz_date,
node.unconnected,
sector.macrosector_id,
node.expl_id,
node.num_value,
man_storage.pol_id as storage_pol_id,
man_storage.length as storage_length,
man_storage.width as storage_width,
man_storage.custom_area as storage_custom_area,
man_storage.max_volume AS storage_max_volume,
man_storage.util_volume AS storage_util_volume,
man_storage.min_height AS storage_min_height,
man_storage.accessibility AS storage_accessibility,
man_storage.name AS storage_name
FROM selector_expl, node
	JOIN man_storage ON man_storage.node_id = node.node_id
	LEFT JOIN sector ON node.sector_id = sector.sector_id
	JOIN v_node ON v_node.node_id = node.node_id
	WHERE (node.expl_id)=(selector_expl.expl_id) AND selector_expl.cur_user="current_user"();


	 

DROP VIEW IF EXISTS v_edit_man_storage_pol CASCADE;
CREATE OR REPLACE VIEW v_edit_man_storage_pol AS 
SELECT 
node.node_id,
node.code as storage_code,
node.top_elev AS storage_top_elev,
node.custom_top_elev AS storage_custom_top_elev,
node.ymax AS storage_ymax,
node.custom_ymax AS storage_custom_ymax,
node.elev AS storage_elev,
node.custom_elev AS storage_custom_elev,
v_node.elev AS storage_sys_elev,
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
node.function_type AS storage_function_type,
node.category_type AS storage_category_type,
node.fluid_type AS storage_fluid_type,
node.location_type AS storage_location_type,
node.workcat_id AS storage_workcat_id,
node.workcat_id_end AS storage_workcat_id_end,
node.buildercat_id AS storage_buildercat_id,
node.builtdate AS storage_builtdate,
node.enddate AS storage_enddate,
node.ownercat_id AS storage_ownercat_id,
node.address_01 AS storage_address_01,
node.address_02 AS storage_address_02,
node.address_03 AS storage_address_03,
node.descript AS storage_descript,
node.rotation AS storage_rotation,
node.link AS storage_link,
node.verified,
polygon.the_geom,
node.undelete,
node.label_x AS storage_label_x,
node.label_y AS storage_label_y,
node.label_rotation AS storage_label_rotation,
node.publish,
node.inventory,
node.uncertain,
node.xyz_date AS storage_xyz_date,
node.unconnected,
sector.macrosector_id,
node.expl_id,
node.num_value,
man_storage.pol_id as storage_pol_id,
man_storage.length as storage_length,
man_storage.width as storage_width,
man_storage.custom_area as storage_custom_area,
man_storage.max_volume AS storage_max_volume,
man_storage.util_volume AS storage_util_volume,
man_storage.min_height AS storage_min_height,
man_storage.accessibility AS storage_accessibility,
man_storage.name AS storage_name
FROM selector_expl, node
	JOIN man_storage ON man_storage.node_id = node.node_id
	LEFT JOIN sector ON node.sector_id = sector.sector_id
	JOIN v_node ON v_node.node_id = node.node_id
	JOIN polygon ON polygon.pol_id = man_storage.pol_id
	WHERE (node.expl_id)=(selector_expl.expl_id) AND selector_expl.cur_user="current_user"();

	 
	 
	 
DROP VIEW IF EXISTS v_edit_man_valve CASCADE;
CREATE OR REPLACE VIEW v_edit_man_valve AS 
SELECT 
node.node_id,
node.code AS valve_code,
node.top_elev AS valve_top_elev,
node.custom_top_elev AS valve_custom_top_elev,
node.ymax AS valve_ymax,
node.custom_ymax AS valve_custom_ymax,
node.elev AS valve_elev,
node.custom_elev AS valve_custom_elev,
v_node.elev AS valve_sys_elev,
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
node.function_type AS valve_function_type,
node.category_type AS valve_category_type,
node.fluid_type AS valve_fluid_type,
node.location_type AS valve_location_type,
node.workcat_id AS valve_workcat_id,
node.workcat_id_end AS valve_workcat_id_end,
node.buildercat_id AS valve_buildercat_id,
node.builtdate AS valve_builtdate,
node.enddate AS valve_enddate,
node.ownercat_id AS valve_ownercat_id,
node.address_01 AS valve_address_01,
node.address_02 AS valve_address_02,
node.address_03 AS valve_address_03,
node.descript AS valve_descript,
node.rotation AS valve_rotation,
node.link AS valve_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS valve_label_x,
node.label_y AS valve_label_y,
node.label_rotation AS valve_label_rotation,
node.publish,
node.inventory,
node.uncertain,
node.xyz_date AS valve_xyz_date,
node.unconnected,
sector.macrosector_id,
node.expl_id,
node.num_value,
man_valve.name AS valve_name
FROM selector_expl, node
	JOIN man_valve ON man_valve.node_id = node.node_id
	LEFT JOIN sector ON node.sector_id = sector.sector_id
	JOIN v_node ON v_node.node_id = node.node_id
	WHERE (node.expl_id)=(selector_expl.expl_id) AND selector_expl.cur_user="current_user"();

	 
	 
DROP VIEW IF EXISTS v_edit_man_netinit CASCADE;
CREATE OR REPLACE VIEW v_edit_man_netinit AS 
SELECT 
node.node_id,
node.code AS netinit_code,
node.top_elev AS netinit_top_elev,
node.custom_top_elev AS netinit_custom_top_elev,
node.ymax AS netinit_ymax,
node.custom_ymax AS netinit_custom_ymax,
node.elev AS netinit_elev,
node.custom_elev AS netinit_custom_elev,
v_node.elev AS netinit_sys_elev,
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
node.function_type AS netinit_function_type,
node.category_type AS netinit_category_type,
node.fluid_type AS netinit_fluid_type,
node.location_type AS netinit_location_type,
node.workcat_id AS netinit_workcat_id,
node.workcat_id_end AS netinit_workcat_id_end,
node.buildercat_id AS netinit_buildercat_id,
node.builtdate AS netinit_builtdate,
node.enddate AS netinit_enddate,
node.ownercat_id AS netinit_ownercat_id,
node.address_01 AS netinit_address_01,
node.address_02 AS netinit_address_02,
node.address_03 AS netinit_address_03,
node.descript AS netinit_descript,
node.rotation AS netinit_rotation,
node.link AS netinit_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS netinit_label_x,
node.label_y AS netinit_label_y,
node.label_rotation AS netinit_label_rotation,
node.publish,
node.inventory,
node.uncertain,
node.xyz_date AS netinit_xyz_date,
node.unconnected,
sector.macrosector_id,
node.expl_id,
node.num_value,
man_netinit.length AS netinit_length,
man_netinit.width AS netinit_width,
man_netinit.inlet AS netinit_inlet,
man_netinit.bottom_channel AS netinit_bottom_channel,
man_netinit.accessibility AS netinit_accessibility,
man_netinit.name AS netinit_name
FROM selector_expl, node
	JOIN man_netinit ON man_netinit.node_id = node.node_id
	LEFT JOIN sector ON node.sector_id = sector.sector_id
	JOIN v_node ON v_node.node_id = node.node_id
	WHERE (node.expl_id)=(selector_expl.expl_id) AND selector_expl.cur_user="current_user"();


	 
DROP VIEW IF EXISTS v_edit_man_manhole CASCADE;
CREATE OR REPLACE VIEW v_edit_man_manhole AS 
SELECT 
node.node_id,
node.code AS manhole_code,
node.top_elev AS manhole_top_elev,
node.custom_top_elev AS manhole_custom_top_elev,
node.ymax AS manhole_ymax,
node.custom_ymax AS manhole_custom_ymax,
node.elev AS manhole_elev,
node.custom_elev AS manhole_custom_elev,
v_node.elev AS manhole_sys_elev,
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
node.function_type AS manhole_function_type,
node.category_type AS manhole_category_type,
node.fluid_type AS manhole_fluid_type,
node.location_type AS manhole_location_type,
node.workcat_id AS manhole_workcat_id,
node.workcat_id_end AS manhole_workcat_id_end,
node.buildercat_id AS manhole_buildercat_id,
node.builtdate AS manhole_builtdate,
node.enddate AS manhole_enddate,
node.ownercat_id AS manhole_ownercat_id,
node.address_01 AS manhole_address_01,
node.address_02 AS manhole_address_02,
node.address_03 AS manhole_address_03,
node.descript AS manhole_descript,
node.rotation AS manhole_rotation,
node.link AS manhole_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS manhole_label_x,
node.label_y AS manhole_label_y,
node.label_rotation AS manhole_label_rotation,
node.publish,
node.inventory,
node.uncertain,
node.xyz_date AS manhole_xyz_date,
node.unconnected,
sector.macrosector_id,
node.expl_id,
node.num_value,
man_manhole.length AS manhole_lepth,
man_manhole.width AS manhole_width,
man_manhole.sander_depth AS manhole_sander_depth,
man_manhole.prot_surface AS manhole_prot_surface,
man_manhole.inlet AS manhole_inlet,
man_manhole.bottom_channel AS manhole_bottom_channel,
man_manhole.accessibility AS manhole_accessibility
FROM selector_expl, node
	JOIN man_manhole ON man_manhole.node_id = node.node_id
	LEFT JOIN sector ON node.sector_id = sector.sector_id
	JOIN v_node ON v_node.node_id = node.node_id
	WHERE (node.expl_id)=(selector_expl.expl_id) AND selector_expl.cur_user="current_user"();

	 
DROP VIEW IF EXISTS v_edit_man_wjump CASCADE;
CREATE OR REPLACE VIEW v_edit_man_wjump AS 
SELECT 
node.node_id,
node.code AS wjump_code,
node.top_elev AS wjump_top_elev,
node.custom_top_elev AS wjump_custom_top_elev,
node.ymax AS wjump_ymax,
node.custom_ymax AS wjump_custom_ymax,
node.elev AS wjump_elev,
node.custom_elev AS wjump_custom_elev,
v_node.elev AS wjump_sys_elev,
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
node.function_type AS wjump_function_type,
node.category_type AS wjump_category_type,
node.fluid_type AS wjump_fluid_type,
node.location_type AS wjump_location_type,
node.workcat_id AS wjump_workcat_id,
node.workcat_id_end AS wjump_workcat_id_end,
node.buildercat_id AS wjump_buildercat_id,
node.builtdate AS wjump_builtdate,
node.enddate AS wjump_enddate,
node.ownercat_id AS wjump_ownercat_id,
node.address_01 AS wjump_address_01,
node.address_02 AS wjump_address_02,
node.address_03 AS wjump_address_03,
node.descript AS wjump_descript,
node.rotation AS wjump_rotation,
node.link AS wjump_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS wjump_label_x,
node.label_y AS wjump_label_y,
node.label_rotation AS wjump_label_rotation,
node.publish,
node.inventory,
node.uncertain,
node.xyz_date AS wjump_xyz_date,
node.unconnected,
sector.macrosector_id,
node.expl_id,
node.num_value,
man_wjump.length AS wjump_length,
man_wjump.width AS wjump_width,
man_wjump.sander_depth AS wjump_sander_depth,
man_wjump.prot_surface AS wjump_prot_surface,
man_wjump.accessibility AS wjump_accessibility,
man_wjump.name AS wjump_name
FROM selector_expl, node
	JOIN man_wjump ON man_wjump.node_id = node.node_id
	LEFT JOIN sector ON node.sector_id = sector.sector_id
	JOIN v_node ON v_node.node_id = node.node_id
	WHERE (node.expl_id)=(selector_expl.expl_id) AND selector_expl.cur_user="current_user"();


	 
DROP VIEW IF EXISTS v_edit_man_netgully CASCADE;
CREATE OR REPLACE VIEW v_edit_man_netgully AS 
SELECT 
node.node_id,
node.code AS netgully_code,
node.top_elev AS netgully_top_elev,
node.custom_top_elev AS netgully_custom_top_elev,
node.ymax AS netgully_ymax,
node.custom_ymax AS netgully_custom_ymax,
node.elev AS netgully_elev,
node.custom_elev AS netgully_custom_elev,
v_node.elev AS netgully_sys_elev,
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
node.function_type AS netgully_function_type,
node.category_type AS netgully_category_type,
node.fluid_type AS netgully_fluid_type,
node.location_type AS netgully_location_type,
node.workcat_id AS netgully_workcat_id,
node.workcat_id_end AS netgully_workcat_id_end,
node.buildercat_id AS netgully_buildercat_id,
node.builtdate AS netgully_builtdate,
node.enddate AS netgully_enddate,
node.ownercat_id AS netgully_ownercat_id,
node.address_01 AS netgully_address_01,
node.address_02 AS netgully_address_02,
node.address_03 AS netgully_address_03,
node.descript AS netgully_descript,
node.rotation AS netgully_rotation,
node.link AS netgully_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS netgully_label_x,
node.label_y AS netgully_label_y,
node.label_rotation AS netgully_label_rotation,
node.publish,
node.inventory,
node.uncertain,
node.xyz_date AS netgully_xyz_date,
node.unconnected,
sector.macrosector_id,
node.expl_id,
node.num_value,
man_netgully.pol_id AS netgully_pol_id,
man_netgully.sander_depth AS netgully_sander_depth,
man_netgully.gratecat_id AS netgully_gratecat_id,
man_netgully.units AS netgully_units,
man_netgully.groove AS netgully_groove,
man_netgully.siphon AS netgully_siphon,
man_netgully.streetaxis_id AS netgully_streetaxis_id,
man_netgully.postnumber AS netgully_postnumber
FROM selector_expl, node
	JOIN man_netgully ON man_netgully.node_id = node.node_id
	LEFT JOIN sector ON node.sector_id = sector.sector_id
	JOIN v_node ON v_node.node_id = node.node_id
	WHERE (node.expl_id)=(selector_expl.expl_id) AND selector_expl.cur_user="current_user"();
	 

DROP VIEW IF EXISTS v_edit_man_netgully_pol CASCADE;
CREATE OR REPLACE VIEW v_edit_man_netgully_pol AS 
SELECT 
node.node_id,
node.code AS netgully_code,
node.top_elev AS netgully_top_elev,
node.custom_top_elev AS netgully_custom_top_elev,
node.ymax AS netgully_ymax,
node.custom_ymax AS netgully_custom_ymax,
node.elev AS netgully_elev,
node.custom_elev AS netgully_custom_elev,
v_node.elev AS netgully_sys_elev,
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
node.function_type AS netgully_function_type,
node.category_type AS netgully_category_type,
node.fluid_type AS netgully_fluid_type,
node.location_type AS netgully_location_type,
node.workcat_id AS netgully_workcat_id,
node.workcat_id_end AS netgully_workcat_id_end,
node.buildercat_id AS netgully_buildercat_id,
node.builtdate AS netgully_builtdate,
node.enddate AS netgully_enddate,
node.ownercat_id AS netgully_ownercat_id,
node.address_01 AS netgully_address_01,
node.address_02 AS netgully_address_02,
node.address_03 AS netgully_address_03,
node.descript AS netgully_descript,
node.rotation AS netgully_rotation,
node.link AS netgully_link,
node.verified,
polygon.the_geom,
node.undelete,
node.label_x AS netgully_label_x,
node.label_y AS netgully_label_y,
node.label_rotation AS netgully_label_rotation,
node.publish,
node.inventory,
node.uncertain,
node.xyz_date AS netgully_xyz_date,
node.unconnected,
sector.macrosector_id,
node.expl_id,
node.num_value,
man_netgully.pol_id AS netgully_pol_id,
man_netgully.sander_depth AS netgully_sander_depth,
man_netgully.gratecat_id AS netgully_gratecat_id,
man_netgully.units AS netgully_units,
man_netgully.groove AS netgully_groove,
man_netgully.siphon AS netgully_siphon,
man_netgully.streetaxis_id AS netgully_streetaxis_id,
man_netgully.postnumber AS netgully_postnumber
FROM selector_expl, node
	JOIN man_netgully ON man_netgully.node_id = node.node_id
	LEFT JOIN sector ON node.sector_id = sector.sector_id
	JOIN v_node ON v_node.node_id = node.node_id
	JOIN polygon ON polygon.pol_id = man_netgully.pol_id
	WHERE (node.expl_id)=(selector_expl.expl_id) AND selector_expl.cur_user="current_user"();	 



DROP VIEW IF EXISTS v_edit_man_chamber CASCADE;
CREATE OR REPLACE VIEW v_edit_man_chamber AS 
SELECT 
node.node_id,
node.code  AS chamber_code,
node.top_elev AS chamber_top_elev,
node.custom_top_elev AS chamber_custom_top_elev,
node.ymax AS chamber_ymax,
node.custom_ymax AS chamber_custom_ymax,
node.elev AS chamber_elev,
node.custom_elev AS chamber_custom_elev,
v_node.elev AS chamber_sys_elev,
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
node.function_type AS chamber_function_type,
node.category_type AS chamber_category_type,
node.fluid_type AS chamber_fluid_type,
node.location_type AS chamber_location_type,
node.workcat_id AS chamber_workcat_id,
node.workcat_id_end AS chamber_workcat_id_end,
node.buildercat_id AS chamber_buildercat_id,
node.builtdate AS chamber_builtdate,
node.enddate AS chamber_enddate,
node.ownercat_id AS chamber_ownercat_id,
node.address_01 AS chamber_address_01,
node.address_02 AS chamber_address_02,
node.address_03 AS chamber_address_03,
node.descript AS chamber_descript,
node.rotation AS chamber_rotation,
node.link AS chamber_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS chamber_label_x,
node.label_y AS chamber_label_y,
node.label_rotation AS chamber_label_rotation,
node.publish,
node.inventory,
node.uncertain,
node.xyz_date AS chamber_xyz_date,
node.unconnected,
sector.macrosector_id,
node.expl_id,
node.num_value,
man_chamber.pol_id,
man_chamber.length AS chamber_length,
man_chamber.width AS chamber_width,
man_chamber.sander_depth AS chamber_sander_depth,
man_chamber.max_volume AS chamber_max_volume,
man_chamber.util_volume AS chamber_util_volume,
man_chamber.inlet AS chamber_inlet,
man_chamber.bottom_channel AS chamber_bottom_channel,
man_chamber.accessibility AS chamber_accessibility,
man_chamber.name AS chamber_name
FROM selector_expl, node
    JOIN man_chamber ON man_chamber.node_id = node.node_id
	LEFT JOIN sector ON node.sector_id = sector.sector_id
	JOIN v_node ON v_node.node_id = node.node_id
	WHERE (node.expl_id)=(selector_expl.expl_id) AND selector_expl.cur_user="current_user"();
	 
	 
	 
DROP VIEW IF EXISTS v_edit_man_chamber_pol CASCADE;
CREATE OR REPLACE VIEW v_edit_man_chamber_pol AS 
SELECT 
node.node_id,
node.code  AS chamber_code,
node.top_elev AS chamber_top_elev,
node.custom_top_elev AS chamber_custom_top_elev,
node.ymax AS chamber_ymax,
node.custom_ymax AS chamber_custom_ymax,
node.elev AS chamber_elev,
node.custom_elev AS chamber_custom_elev,
v_node.elev AS chamber_sys_elev,
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
node.function_type AS chamber_function_type,
node.category_type AS chamber_category_type,
node.fluid_type AS chamber_fluid_type,
node.location_type AS chamber_location_type,
node.workcat_id AS chamber_workcat_id,
node.workcat_id_end AS chamber_workcat_id_end,
node.buildercat_id AS chamber_buildercat_id,
node.builtdate AS chamber_builtdate,
node.enddate AS chamber_enddate,
node.ownercat_id AS chamber_ownercat_id,
node.address_01 AS chamber_address_01,
node.address_02 AS chamber_address_02,
node.address_03 AS chamber_address_03,
node.descript AS chamber_descript,
node.rotation AS chamber_rotation,
node.link AS chamber_link,
node.verified,
polygon.the_geom,
node.undelete,
node.label_x AS chamber_label_x,
node.label_y AS chamber_label_y,
node.label_rotation AS chamber_label_rotation,
node.publish,
node.inventory,
node.uncertain,
node.xyz_date AS chamber_xyz_date,
node.unconnected,
sector.macrosector_id,
node.expl_id,
node.num_value,
man_chamber.pol_id,
man_chamber.length AS chamber_length,
man_chamber.width AS chamber_width,
man_chamber.sander_depth AS chamber_sander_depth,
man_chamber.max_volume AS chamber_max_volume,
man_chamber.util_volume AS chamber_util_volume,
man_chamber.inlet AS chamber_inlet,
man_chamber.bottom_channel AS chamber_bottom_channel,
man_chamber.accessibility AS chamber_accessibility,
man_chamber.name AS chamber_name
FROM selector_expl, node
	JOIN man_chamber ON man_chamber.node_id = node.node_id
	LEFT JOIN sector ON node.sector_id = sector.sector_id
	JOIN v_node ON v_node.node_id = node.node_id
	JOIN polygon ON polygon.pol_id = man_chamber.pol_id
	WHERE (node.expl_id)=(selector_expl.expl_id)	AND selector_expl.cur_user="current_user"(); 



DROP VIEW IF EXISTS v_edit_man_wwtp CASCADE;
CREATE OR REPLACE VIEW v_edit_man_wwtp AS 
SELECT 
node.node_id,
node.code AS wwtp_code,
node.top_elev AS wwtp_top_elev,
node.custom_top_elev AS wwtp_custom_top_elev,
node.ymax AS wwtp_ymax,
node.custom_ymax AS wwtp_custom_ymax,
node.elev AS wwtp_elev,
node.custom_elev AS wwtp_custom_elev,
v_node.elev AS wwtp_sys_elev,
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
node.function_type AS wwtp_function_type,
node.category_type AS wwtp_category_type,
node.fluid_type AS wwtp_fluid_type,
node.location_type AS wwtp_location_type,
node.workcat_id AS wwtp_workcat_id,
node.workcat_id_end AS wwtp_workcat_id_end,
node.buildercat_id AS wwtp_buildercat_id,
node.builtdate AS wwtp_builtdate,
node.enddate AS wwtp_enddate,
node.ownercat_id AS wwtp_ownercat_id,
node.address_01 AS wwtp_address_01,
node.address_02 AS wwtp_address_02,
node.address_03 AS wwtp_address_03,
node.descript AS wwtp_descript,
node.rotation AS wwtp_rotation,
node.link AS wwtp_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS wwtp_label_x,
node.label_y AS wwtp_label_y,
node.label_rotation AS wwtp_label_rotation,
node.publish,
node.inventory,
node.uncertain,
node.xyz_date AS wwtp_xyz_date,
node.unconnected,
sector.macrosector_id,
node.expl_id,
node.num_value,
man_wwtp.pol_id,
man_wwtp.name AS wwtp_name
FROM selector_expl, node
	JOIN man_wwtp ON man_wwtp.node_id = node.node_id
	LEFT JOIN sector ON node.sector_id = sector.sector_id
	JOIN v_node ON v_node.node_id = node.node_id
	WHERE (node.expl_id)=(selector_expl.expl_id) AND selector_expl.cur_user="current_user"(); ;



DROP VIEW IF EXISTS v_edit_man_wwtp_pol CASCADE;
CREATE OR REPLACE VIEW v_edit_man_wwtp_pol AS 
SELECT 
node.node_id,
node.code AS wwtp_code,
node.top_elev AS wwtp_top_elev,
node.custom_top_elev AS wwtp_custom_top_elev,
node.ymax AS wwtp_ymax,
node.custom_ymax AS wwtp_custom_ymax,
node.elev AS wwtp_elev,
node.custom_elev AS wwtp_custom_elev,
v_node.elev AS wwtp_sys_elev,
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
node.function_type AS wwtp_function_type,
node.category_type AS wwtp_category_type,
node.fluid_type AS wwtp_fluid_type,
node.location_type AS wwtp_location_type,
node.workcat_id AS wwtp_workcat_id,
node.workcat_id_end AS wwtp_workcat_id_end,
node.buildercat_id AS wwtp_buildercat_id,
node.builtdate AS wwtp_builtdate,
node.enddate AS wwtp_enddate,
node.ownercat_id AS wwtp_ownercat_id,
node.address_01 AS wwtp_address_01,
node.address_02 AS wwtp_address_02,
node.address_03 AS wwtp_address_03,
node.descript AS wwtp_descript,
node.rotation AS wwtp_rotation,
node.link AS wwtp_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS wwtp_label_x,
node.label_y AS wwtp_label_y,
node.label_rotation AS wwtp_label_rotation,
node.publish,
node.inventory,
node.uncertain,
node.xyz_date AS wwtp_xyz_date,
node.unconnected,
sector.macrosector_id,
node.expl_id,
node.num_value,
man_wwtp.pol_id,
man_wwtp.name AS wwtp_name
FROM selector_expl, node
	JOIN man_wwtp ON man_wwtp.node_id = node.node_id
	LEFT JOIN sector ON node.sector_id = sector.sector_id
	JOIN v_node ON v_node.node_id = node.node_id
	JOIN polygon ON polygon.pol_id = man_wwtp.pol_id
	WHERE (node.expl_id)=(selector_expl.expl_id) AND selector_expl.cur_user="current_user"(); 


DROP VIEW IF EXISTS v_edit_man_netelement CASCADE;
CREATE OR REPLACE VIEW v_edit_man_netlement AS 
SELECT 
node.node_id,
node.code AS netel_code,
node.top_elev AS netel_top_elev,
node.custom_top_elev AS netel_custom_top_elev,
node.ymax AS netele_ymax,
node.custom_ymax AS netel_custom_ymax,
node.elev AS netel_elev,
node.custom_elev AS netel_custom_elev,
v_node.elev AS netel_sys_elev,
node.node_type,
node.nodecat_id,
node.epa_type,
node.sector_id,
node.state,
node.annotation AS netel_annotation,
node.observ AS netel_observ,
node.comment AS netel_comment,
node.dma_id,
node.soilcat_id AS netel_soilcat_id,
node.function_type AS netel_function_type,
node.category_type AS netel_category_type,
node.fluid_type AS netel_fluid_type,
node.location_type AS netel_location_type,
node.workcat_id AS netel_workcat_id,
node.workcat_id_end AS netel_workcat_id_end,
node.buildercat_id AS netel_buildercat_id,
node.builtdate AS netel_builtdate,
node.enddate AS netel_enddate,
node.ownercat_id AS netel_ownercat_id,
node.address_01 AS netel_address_01,
node.address_02 AS netel_address_02,
node.address_03 AS netel_address_03,
node.descript AS netel_descript,
node.rotation AS netel_rotation,
node.link AS netel_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS netel_label_x,
node.label_y AS netel_label_y,
node.label_rotation AS netel_label_rotation,
node.publish,
node.inventory,
node.uncertain,
node.xyz_date AS netel_xyz_date,
node.unconnected,
sector.macrosector_id,
node.expl_id,
node.num_value,
netelement.serial_number
FROM selector_expl, node
	JOIN man_netelement ON man_netelement.node_id = node.node_id
	LEFT JOIN sector ON node.sector_id = sector.sector_id
	JOIN v_node ON v_node.node_id = node.node_id
	WHERE (node.expl_id)=(selector_expl.expl_id) AND selector_expl.cur_user="current_user"(); ;



DROP VIEW IF EXISTS v_edit_man_conduit CASCADE;
CREATE OR REPLACE VIEW v_edit_man_conduit AS 
SELECT 
arc.arc_id,
arc.code AS conduit_code,
arc.node_1 AS conduit_node_1,
arc.node_2 AS conduit_node_2,
arc.y1 AS conduit_y1,
arc.custom_y1 AS conduit_custom_y1,
arc.elev1 AS conduit_elev1,
arc.custom_elev1 AS conduit_custom_elev1,
v_arc_x_node.elevmax1 AS conduit_sys_elev1,
arc.y2 AS conduit_y2,
arc.elev2 AS conduit_elev2,
arc.custom_y2 AS conduit_custom_y2,
arc.custom_elev2 AS conduit_custom_elev2,	
v_arc_x_node.elevmax2 AS conduit_sys_elev2,
v_arc_x_node.z1 AS conduit_z1,
v_arc_x_node.z2 AS conduit_z2,
v_arc_x_node.r1 AS conduit_r1,
v_arc_x_node.r2 AS conduit_r2,
v_arc_x_node.slope AS conduit_slope,
arc.arc_type,
arc.arccat_id,
cat_arc.matcat_id AS conduit_matcat_id,
cat_arc.custom_shape AS conduit_cat_shape,
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
arc.function_type AS conduit_function_type,
arc.category_type AS conduit_category_type,
arc.fluid_type AS conduit_fluid_type,
arc.location_type AS conduit_location_type,
arc.workcat_id AS conduit_workcat_id,
arc.workcat_id_end AS conduit_workcat_id_end,
arc.buildercat_id AS conduit_buildercat_id,
arc.builtdate AS conduit_builtdate,
arc.enddate AS conduit_enddate,
arc.ownercat_id AS conduit_ownercat_id,
arc.address_01 AS conduit_address_01,
arc.address_02 AS conduit_address_02,
arc.address_03 AS conduit_address_03,
arc.descript AS conduit_descript,
arc.link AS conduit_link,
arc.verified,
arc.the_geom,
arc.undelete,
arc.label_x AS conduit_label_x,
arc.label_y AS conduit_label_y,
arc.label_rotation AS conduit_label_rotation,
arc.publish,
arc.inventory,
arc.uncertain,
sector.macrosector_id,
arc.expl_id,
arc.num_value
FROM selector_expl, arc
	LEFT JOIN cat_arc ON arc.arccat_id = cat_arc.id
	LEFT JOIN v_arc_x_node ON v_arc_x_node.arc_id = arc.arc_id
	LEFT JOIN sector ON arc.sector_id = sector.sector_id
	JOIN man_conduit ON man_conduit.arc_id = arc.arc_id
	WHERE (arc.expl_id)=(selector_expl.expl_id) AND selector_expl.cur_user="current_user"();



DROP VIEW IF EXISTS v_edit_man_siphon CASCADE;
CREATE OR REPLACE VIEW v_edit_man_siphon AS 
SELECT 
arc.arc_id,
arc.code AS siphon_code,
arc.node_1 AS siphon_node_1,
arc.node_2 AS siphon_node_2,
arc.y1 AS siphon_y1,
arc.custom_y1 AS siphon_custom_y1,
arc.elev1 AS siphon_elev1,
arc.custom_elev1 AS siphon_custom_elev1,
v_arc_x_node.elevmax1 AS siphon_sys_elev1,
arc.y2 AS siphon_y2,
arc.elev2 AS siphon_elev2,
arc.custom_y2 AS siphon_custom_y2,
arc.custom_elev2 AS siphon_custom_elev2,	
v_arc_x_node.elevmax2 AS siphon_sys_elev2,
v_arc_x_node.z1 AS siphon_z1,
v_arc_x_node.z2 AS siphon_z2,
v_arc_x_node.r1 AS siphon_r1,
v_arc_x_node.r2 AS siphon_r2,
v_arc_x_node.slope AS siphon_slope,
arc.arc_type,
arc.arccat_id,
cat_arc.matcat_id AS siphon_matcat_id,
cat_arc.custom_shape AS siphon_cat_shape,
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
arc.function_type AS siphon_function_type,
arc.category_type AS siphon_category_type,
arc.fluid_type AS siphon_fluid_type,
arc.location_type AS siphon_location_type,
arc.workcat_id AS siphon_workcat_id,
arc.workcat_id_end AS siphon_workcat_id_end,
arc.buildercat_id AS siphon_buildercat_id,
arc.builtdate AS siphon_builtdate,
arc.enddate AS siphon_enddate,
arc.ownercat_id AS siphon_ownercat_id,
arc.address_01 AS siphon_address_01,
arc.address_02 AS siphon_address_02,
arc.address_03 AS siphon_address_03,
arc.descript AS siphon_descript,
arc.link AS siphon_link,
arc.verified,
arc.the_geom,
arc.undelete,
arc.label_x AS siphon_label_x,
arc.label_y AS siphon_label_y,
arc.label_rotation AS siphon_label_rotation,
arc.publish,
arc.inventory,
arc.uncertain,
sector.macrosector_id,
arc.expl_id,
arc.num_value,
man_siphon.name AS siphon_name
FROM selector_expl, arc
	LEFT JOIN cat_arc ON arc.arccat_id = cat_arc.id
	LEFT JOIN v_arc_x_node ON v_arc_x_node.arc_id = arc.arc_id
	LEFT JOIN sector ON arc.sector_id = sector.sector_id
	JOIN man_siphon ON man_siphon.arc_id = arc.arc_id
	WHERE (arc.expl_id)=(selector_expl.expl_id) AND selector_expl.cur_user="current_user"();





DROP VIEW IF EXISTS v_edit_man_waccel CASCADE;
CREATE OR REPLACE VIEW v_edit_man_waccel AS 
SELECT 
arc.arc_id,
arc.node_1 AS waccel_node_1,
arc.node_2 AS waccel_node_2,
arc.y1 AS waccel_y1,
arc.custom_y1 AS waccel_custom_y1,
arc.elev1 AS waccel_elev1,
arc.custom_elev1 AS waccel_custom_elev1,
v_arc_x_node.elevmax1 AS waccel_sys_elev1,
arc.y2 AS waccel_y2,
arc.elev2 AS waccel_elev2,
arc.custom_y2 AS waccel_custom_y2,
arc.custom_elev2 AS waccel_custom_elev2,	
v_arc_x_node.elevmax2 AS waccel_sys_elev2,
v_arc_x_node.z1 AS waccel_z1,
v_arc_x_node.z2 AS waccel_z2,
v_arc_x_node.r1 AS waccel_r1,
v_arc_x_node.r2 AS waccel_r2,
v_arc_x_node.slope AS waccel_slope,
arc.arc_type,
arc.arccat_id,
cat_arc.matcat_id AS waccel_matcat_id,
cat_arc.custom_shape AS waccel_cat_shape,
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
arc.function_type AS waccel_function_type,
arc.category_type AS waccel_category_type,
arc.fluid_type AS waccel_fluid_type,
arc.location_type AS waccel_location_type,
arc.workcat_id AS waccel_workcat_id,
arc.workcat_id_end AS waccel_workcat_id_end,
arc.buildercat_id AS waccel_buildercat_id,
arc.builtdate AS waccel_builtdate,
arc.enddate AS waccel_enddate,
arc.ownercat_id AS waccel_ownercat_id,
arc.address_01 AS waccel_address_01,
arc.address_02 AS waccel_address_02,
arc.address_03 AS waccel_address_03,
arc.descript AS waccel_descript,
arc.link AS waccel_link,
arc.verified,
arc.the_geom,
arc.undelete,
arc.label_x AS waccel_label_x,
arc.label_y AS waccel_label_y,
arc.label_rotation AS waccel_label_rotation,
arc.code AS waccel_code,
arc.publish,
arc.inventory,
arc.uncertain,
sector.macrosector_id,
arc.expl_id,
arc.num_value,
man_waccel.sander_length AS waccel_sander_length,
man_waccel.sander_depth AS waccel_sander_depth,
man_waccel.prot_surface AS waccel_prot_surface,
man_waccel.name AS waccel_name
FROM selector_expl, arc
	LEFT JOIN cat_arc ON arc.arccat_id = cat_arc.id
	LEFT JOIN v_arc_x_node ON v_arc_x_node.arc_id = arc.arc_id
	LEFT JOIN sector ON arc.sector_id = sector.sector_id
	JOIN man_waccel ON man_waccel.arc_id = arc.arc_id
	WHERE (arc.expl_id)=(selector_expl.expl_id) AND selector_expl.cur_user="current_user"();;



DROP VIEW IF EXISTS v_edit_man_varc CASCADE;
CREATE OR REPLACE VIEW v_edit_man_varc AS 
SELECT 
arc.arc_id,
arc.code AS varc_code,
arc.node_1 AS varc_node_1,
arc.node_2 AS varc_node_2,
arc.y1 AS varc_y1,
arc.custom_y1 AS varc_custom_y1,
arc.elev1 AS varc_elev1,
arc.custom_elev1 AS varc_custom_elev1,
v_arc_x_node.elevmax1 AS varc_sys_elev1,
arc.y2 AS varc_y2,
arc.elev2 AS varc_elev2,
arc.custom_y2 AS varc_custom_y2,
arc.custom_elev2 AS varc_custom_elev2,	
v_arc_x_node.elevmax2 AS varc_sys_elev2,
v_arc_x_node.z1 AS varc_z1,
v_arc_x_node.z2 AS varc_z2,
v_arc_x_node.r1 AS varc_r1,
v_arc_x_node.r2 AS varc_r2,
v_arc_x_node.slope AS varc_slope,
arc.arc_type,
arc.arccat_id,
cat_arc.matcat_id AS varc_matcat_id,
cat_arc.custom_shape AS varc_cat_shape,
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
arc.function_type AS varc_function_type,
arc.category_type AS varc_category_type,
arc.fluid_type AS varc_fluid_type,
arc.location_type AS varc_location_type,
arc.workcat_id AS varc_workcat_id,
arc.workcat_id_end AS varc_workcat_id_end,
arc.buildercat_id AS varc_buildercat_id,
arc.builtdate AS varc_builtdate,
arc.enddate AS varc_enddate,
arc.ownercat_id AS varc_ownercat_id,
arc.address_01 AS varc_address_01,
arc.address_02 AS varc_address_02,
arc.address_03 AS varc_address_03,
arc.descript AS varc_descript,
arc.link AS varc_link,
arc.verified,
arc.the_geom,
arc.undelete,
arc.label_x AS varc_label_x,
arc.label_y AS varc_label_y,
arc.label_rotation AS varc_label_rotation,
arc.publish,
arc.inventory,
arc.uncertain,
sector.macrosector_id,
arc.expl_id,
arc.num_value
FROM selector_expl, arc
	LEFT JOIN cat_arc ON arc.arccat_id = cat_arc.id
	LEFT JOIN v_arc_x_node ON v_arc_x_node.arc_id = arc.arc_id
	LEFT JOIN sector ON arc.sector_id = sector.sector_id
	JOIN man_varc ON man_varc.arc_id = arc.arc_id
	WHERE (arc.expl_id)=(selector_expl.expl_id) AND selector_expl.cur_user="current_user"();




DROP VIEW IF EXISTS v_edit_man_connec CASCADE;
CREATE OR REPLACE VIEW v_edit_man_connec AS
SELECT * FROM v_edit_connec;


DROP VIEW IF EXISTS v_edit_man_gully CASCADE;
CREATE OR REPLACE VIEW v_edit_man_gully AS
SELECT * FROM v_edit_gully;


DROP VIEW IF EXISTS v_edit_man_gully_pol CASCADE;
CREATE OR REPLACE VIEW v_edit_man_gully_pol AS
SELECT * FROM v_edit_gully_pol



