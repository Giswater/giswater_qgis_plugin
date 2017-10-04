/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

----------------------------
--GIS EDITING VIEWS
----------------------------


DROP VIEW IF EXISTS v_edit_macrodma CASCADE;
CREATE VIEW v_edit_macrodma AS SELECT
	macrodma.macrodma_id,
	macrodma.name,
	macrodma.descript,
	macrodma.the_geom,
	macrodma.undelete,
	macrodma.expl_id
FROM selector_expl, macrodma 
WHERE ((macrodma.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());
  

  
DROP VIEW IF EXISTS v_edit_dma CASCADE;
CREATE VIEW v_edit_dma AS SELECT
	dma.dma_id,
	dma.name,
	dma.macrodma_id,
	dma.descript,
	dma.the_geom,
	dma.undelete,
	dma.expl_id
	FROM selector_expl, dma 
WHERE ((dma.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());
  


DROP VIEW IF EXISTS v_edit_sector CASCADE;
CREATE VIEW v_edit_sector AS SELECT
	sector.sector_id,
	sector.name,
	sector.descript,
	sector.the_geom,
	sector.undelete
FROM inp_selector_sector,sector 
WHERE ((sector.sector_id)=(inp_selector_sector.sector_id) 
AND inp_selector_sector.cur_user="current_user"());



DROP VIEW IF EXISTS v_edit_node CASCADE;
CREATE OR REPLACE VIEW v_edit_node AS
SELECT 
node.node_id, 
node.code,
node.elevation, 
node.depth, 
cat_node.nodetype_id,
node.nodecat_id,
cat_node.matcat_id AS "cat_matcat_id",
cat_node.pnom AS "cat_pnom",
cat_node.dnom AS "cat_dnom",
node.epa_type,
node.sector_id, 
node."state", 
node.state_type,
node.annotation, 
node.observ, 
node."comment",
node.dma_id,
node.presszonecat_id,
node.soilcat_id,
node.function_type,
node.category_type,
node.fluid_type,
node.location_type,
node.workcat_id,
node.buildercat_id,
node.workcat_id_end,
node.builtdate,
node.enddate,
node.ownercat_id,
node.address_01,
node.address_02,
node.address_03,
node.descript,
cat_node.svg AS "cat_svg",
node.rotation,
concat(node_type.link_path,node.link) AS link,
node.verified,
node.the_geom,
node.undelete,
node.label_x,
node.label_y,
node.label_rotation,
node.publish,
node.inventory,
dma.macrodma_id,
node.expl_id,
node.hemisphere,
node.num_value
FROM selector_expl, node
	JOIN v_node ON node.node_id=v_node.node_id
	LEFT JOIN cat_node ON ((node.nodecat_id) = (cat_node.id))
	JOIN node_type ON node_type.id=cat_node.nodetype_id
	LEFT JOIN dma ON (((node.dma_id) = (dma.dma_id)))
	WHERE ((node.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());


DROP VIEW IF EXISTS v_edit_arc CASCADE;
CREATE OR REPLACE VIEW v_edit_arc AS
SELECT 
arc.arc_id,
arc.code,
arc.node_1,
arc.node_2,
arc.arccat_id, 
cat_arc.arctype_id AS "cat_arctype_id",
cat_arc.matcat_id AS "cat_matcat_id",
cat_arc.pnom AS "cat_pnom",
cat_arc.dnom AS "cat_dnom",
arc.epa_type,
arc.sector_id, 
arc."state", 
arc.state_type,
arc.annotation, 
arc.observ, 
arc."comment",
st_length2d(arc.the_geom)::numeric(12,2) AS gis_length,
arc.custom_length,
arc.dma_id,
arc.presszonecat_id,
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
concat(arc_type.link_path,arc.link) as link,
arc.verified,
arc.the_geom,
arc.undelete,
arc.label_x,
arc.label_y,
arc.label_rotation,
arc.publish,
arc.inventory,
dma.macrodma_id,
arc.expl_id,
arc.num_value
FROM selector_expl,arc 
	JOIN v_arc_x_node ON arc.arc_id=v_arc_x_node.arc_id
	LEFT JOIN cat_arc ON (((arc.arccat_id) = (cat_arc.id)))
	JOIN arc_type ON cat_arc.arctype_id=arc_type.id
	LEFT JOIN dma ON (((arc.dma_id) = (dma.dma_id)))
	WHERE ((arc.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());




DROP VIEW IF EXISTS v_edit_man_pipe CASCADE;
CREATE OR REPLACE VIEW v_edit_man_pipe AS
SELECT 
arc.arc_id,
arc.code AS pipe_code,
arc.node_1 AS pipe_node_1,
arc.node_2 AS pipe_node_2,
arc.arccat_id, 
cat_arc.arctype_id AS "cat_arctype_id",
cat_arc.matcat_id AS "pipe_matcat_id",
cat_arc.pnom AS "pipe_cat_pnom",
cat_arc.dnom AS "pipe_cat_dnom",
arc.epa_type,
arc.sector_id, 
arc."state",
arc.state_type,
arc.annotation AS pipe_annotation, 
arc.observ AS pipe_observ, 
arc."comment" AS pipe_comment,
st_length2d(arc.the_geom)::numeric(12,2) AS pipe_gis_length,
arc.custom_length AS pipe_custom_length,
arc.dma_id,
arc.presszonecat_id,
arc.soilcat_id AS pipe_soilcat_id,
arc.function_type AS pipe_function_type,
arc.category_type AS pipe_category_type,
arc.fluid_type AS pipe_fluid_type,
arc.location_type AS pipe_location_type,
arc.workcat_id AS pipe_workcat_id,
arc.workcat_id_end AS pipe_workcat_id_end,
arc.buildercat_id AS pipe_buildercat_id,
arc.builtdate AS pipe_builtdate,
arc.enddate AS pipe_enddate,
arc.ownercat_id AS pipe_ownercat_id,
arc.address_01 AS pipe_address_01,
arc.address_02 AS pipe_address_02,
arc.address_03 AS pipe_address_03,
arc.descript AS pipe_descript,
concat(arc_type.link_path,arc.link) AS pipe_link,
arc.verified,
arc.the_geom,
arc.undelete,
arc.label_x AS pipe_label_x,
arc.label_y AS pipe_label_y,
arc.label_rotation AS pipe_label_rotation,
arc.publish,
arc.inventory,
dma.macrodma_id,
arc.expl_id,
arc.num_value AS pipe_num_value
FROM selector_expl,arc
	JOIN v_arc_x_node ON arc.arc_id=v_arc_x_node.arc_id
	LEFT JOIN cat_arc ON (((arc.arccat_id) = (cat_arc.id)))
	JOIN arc_type ON cat_arc.arctype_id=arc_type.id
	LEFT JOIN dma ON (((arc.dma_id) = (dma.dma_id)))
	JOIN man_pipe ON man_pipe.arc_id=arc.arc_id
	WHERE ((arc.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());



DROP VIEW IF EXISTS v_edit_man_varc CASCADE;
CREATE OR REPLACE VIEW v_edit_man_varc AS
SELECT 
arc.arc_id,
arc.code AS varc_code,
arc.node_1 AS varc_node_1,
arc.node_2 AS varc_node_2,
arc.arccat_id, 
cat_arc.arctype_id AS "cat_arctype_id",
cat_arc.matcat_id AS "varc_matcat_id",
cat_arc.pnom  AS "varc_cat_pnom",
cat_arc.dnom  AS "varc_cat_dnom",
arc.epa_type,
arc.sector_id, 
arc."state",
arc.state_type,
arc.annotation AS varc_annotation, 
arc.observ AS varc_observ, 
arc."comment" AS varc_comment,
st_length2d(arc.the_geom)::numeric(12,2) AS varc_gis_length,
arc.custom_length AS varc_custom_length,
arc.dma_id,
arc.presszonecat_id,
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
concat(arc_type.link_path,arc.link) AS varc_link,
arc.verified,
arc.the_geom,
arc.undelete,
arc.label_x AS varc_label_x,
arc.label_y AS varc_label_y,
arc.label_rotation AS varc_label_rotation,
arc.publish,
arc.inventory,
dma.macrodma_id,
arc.expl_id,
arc.num_value AS varc_num_value
FROM selector_expl,arc 
	JOIN v_arc_x_node ON arc.arc_id=v_arc_x_node.arc_id
	LEFT JOIN cat_arc ON (((arc.arccat_id) = (cat_arc.id)))
	JOIN arc_type ON cat_arc.arctype_id=arc_type.id
	LEFT JOIN dma ON (((arc.dma_id) = (dma.dma_id)))
	JOIN man_varc ON man_varc.arc_id=arc.arc_id
	WHERE ((arc.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());



DROP VIEW IF EXISTS v_edit_man_hydrant CASCADE;
CREATE OR REPLACE VIEW v_edit_man_hydrant AS 
SELECT 
node.node_id,
node.code AS hydrant_code,
node.elevation AS hydrant_elevation,
node.depth AS hydrant_depth,
cat_node.nodetype_id,
node.nodecat_id,
cat_node.matcat_id AS hydrant_cat_matcat_id,
cat_node.pnom AS hydrant_cat_pnom,
cat_node.dnom AS hydrant_cat_dnom,
node.epa_type,
node.sector_id,
node.state,
node.state_type,
node.annotation AS hydrant_annotation,
node.observ AS hydrant_observ,
node.comment AS hydrant_comment,
node.dma_id,
node.presszonecat_id,
node.soilcat_id AS hydrant_soilcat_id,
node.function_type AS hydrant_function_type,
node.category_type AS hydrant_category_type,
node.fluid_type AS hydrant_fluid_type,
node.location_type AS hydrant_location_type,
node.workcat_id AS hydrant_workcat_id,
node.workcat_id_end AS hydrant_workcat_id_end,
node.buildercat_id AS hydrant_buildercat_id,
node.builtdate AS hydrant_builtdate,
node.enddate AS hydrant_enddate,
node.ownercat_id AS hydrant_ownercat_id,
node.address_01 AS hydrant_address_01,
node.address_02 AS hydrant_address_02,
node.address_03 AS hydrant_address_03,
node.descript AS hydrant_descript,
cat_node.svg AS hydrant_cat_svg,
node.rotation AS hydrant_rotation,
concat(node_type.link_path,node.link) AS hydrant_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS hydrant_label_x,
node.label_y AS hydrant_label_y,
node.label_rotation AS hydrant_label_rotation,
node.publish,
node.inventory,
dma.macrodma_id,
node.expl_id,
node.num_value AS hydrant_num_value,
node.hemisphere AS hydrant_hemisphere,
man_hydrant.fire_code AS hydrant_fire_code,
man_hydrant.communication AS hydrant_communication,
man_hydrant.valve AS hydrant_valve,
man_hydrant.valve_diam AS hydrant_valve_diam
FROM selector_expl, node
	JOIN v_node ON node.node_id=v_node.node_id
	LEFT JOIN cat_node ON ((node.nodecat_id) = (cat_node.id))
	JOIN node_type ON node_type.id=cat_node.nodetype_id
	LEFT JOIN dma ON (((node.dma_id) = (dma.dma_id)))
    JOIN man_hydrant ON man_hydrant.node_id = node.node_id
	WHERE ((node.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());
  

	
	 
DROP VIEW IF EXISTS v_edit_man_junction CASCADE;
CREATE OR REPLACE VIEW v_edit_man_junction AS 
SELECT 
node.node_id,
node.code AS junction_code,
node.elevation AS junction_elevation,
node.depth AS junction_depth,
cat_node.nodetype_id,
node.nodecat_id,
cat_node.matcat_id AS junction_cat_matcat_id,
cat_node.pnom AS junction_cat_pnom,
cat_node.dnom AS junction_cat_dnom,
node.epa_type,
node.sector_id,
node."state",
node.state_type,
node.annotation AS junction_annotation,
node.observ AS junction_observ,
node.comment AS junction_comment,
node.dma_id,
node.presszonecat_id,
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
cat_node.svg AS junction_cat_svg,
node.rotation AS junction_rotation,
node.label_x AS junction_label_x,
node.label_y AS junction_label_y,
node.label_rotation AS junction_label_rotation,
concat(node_type.link_path,node.link) AS junction_link,
node.verified,
node.the_geom,
node.undelete,
node.publish,
node.inventory,
dma.macrodma_id,
node.expl_id,
node.hemisphere as junction_hemisphere,
node.num_value as junction_num_value
FROM selector_expl, node
	JOIN v_node ON node.node_id=v_node.node_id
	LEFT JOIN cat_node ON ((node.nodecat_id) = (cat_node.id))
	JOIN node_type ON node_type.id=cat_node.nodetype_id
	LEFT JOIN dma ON (((node.dma_id) = (dma.dma_id)))
	JOIN man_junction ON node.node_id = man_junction.node_id
	WHERE ((node.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());
  

	 
DROP VIEW IF EXISTS v_edit_man_manhole CASCADE;
CREATE OR REPLACE VIEW v_edit_man_manhole AS 
SELECT 
node.node_id,
node.code AS manhole_code,
node.elevation AS manhole_elevation,
node.depth AS manhole_depth,
cat_node.nodetype_id,
node.nodecat_id,
cat_node.matcat_id AS manhole_cat_matcat_id,
cat_node.pnom AS manhole_cat_pnom,
cat_node.dnom AS manhole_cat_dnom,
node.epa_type,
node.sector_id,
node.state,
node.state_type,
node.annotation AS manhole_annotation,
node.observ AS manhole_observ,
node.comment AS manhole_comment,
node.dma_id,
node.presszonecat_id,
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
cat_node.svg AS manhole_cat_svg,
node.rotation AS manhole_rotation,
node.label_x AS manhole_label_x,
node.label_y AS manhole_label_y,
node.label_rotation AS manhole_label_rotation,
concat(node_type.link_path,node.link) AS manhole_link,
node.verified,
node.the_geom,
node.undelete,
node.publish,
node.inventory,
dma.macrodma_id,
node.expl_id,
node.hemisphere as manhole_hemisphere,
node.num_value as manhole_num_value,
man_manhole.name as manhole_name
FROM selector_expl, node
	JOIN v_node ON node.node_id=v_node.node_id
	LEFT JOIN cat_node ON ((node.nodecat_id) = (cat_node.id))
	JOIN node_type ON node_type.id=cat_node.nodetype_id
	LEFT JOIN dma ON (((node.dma_id) = (dma.dma_id)))
	JOIN man_manhole ON node.node_id = man_manhole.node_id
	WHERE ((node.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());




DROP VIEW IF EXISTS v_edit_man_meter CASCADE;
CREATE OR REPLACE VIEW v_edit_man_meter AS 
SELECT 
node.node_id,
node.code AS meter_code,
node.elevation AS meter_elevation,
node.depth AS meter_depth,
cat_node.nodetype_id,
node.nodecat_id,
cat_node.matcat_id AS meter_cat_matcat_id,
cat_node.pnom AS meter_cat_pnom,
cat_node.dnom AS meter_cat_dnom,
node.epa_type,
node.sector_id,
node.state,
node.state_type,
node.annotation AS meter_annotation,
node.observ AS meter_observ,
node.comment AS meter_comment,
node.dma_id,
node.presszonecat_id,
node.soilcat_id AS meter_soilcat_id,
node.function_type AS meter_function_type,
node.category_type AS meter_category_type,
node.fluid_type AS meter_fluid_type,
node.location_type AS meter_location_type,
node.workcat_id AS meter_workcat_id,
node.workcat_id_end AS meter_workcat_id_end,
node.buildercat_id AS meter_buildercat_id,
node.builtdate AS meter_builtdate,
node.enddate AS meter_enddate,
node.ownercat_id AS meter_ownercat_id,
node.address_01 AS meter_address_01,
node.address_02 AS meter_address_02,
node.address_03 AS meter_address_03,
node.descript AS meter_descript,
cat_node.svg AS meter_cat_svg,
node.rotation AS meter_rotation,
concat(node_type.link_path,node.link) AS meter_link,
node.label_x AS meter_label_x,
node.label_y AS meter_label_y,
node.label_rotation AS meter_label_rotation,
node.verified,
node.the_geom,
node.undelete,
node.publish,
node.inventory,
dma.macrodma_id,
node.expl_id,
node.hemisphere as meter_hemisphere,
node.num_value as meter_num_value
FROM selector_expl, node JOIN v_node ON node.node_id=v_node.node_id
	LEFT JOIN cat_node ON ((node.nodecat_id) = (cat_node.id))
	JOIN node_type ON node_type.id=cat_node.nodetype_id
	LEFT JOIN dma ON (((node.dma_id) = (dma.dma_id)))
	JOIN man_meter ON man_meter.node_id = node.node_id
	WHERE ((node.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());


	 
DROP VIEW IF EXISTS v_edit_man_pump CASCADE;
CREATE OR REPLACE VIEW v_edit_man_pump AS 
SELECT 
node.node_id,
node.code AS pump_code,
node.elevation AS pump_elevation,
node.depth AS pump_depth,
cat_node.nodetype_id,
node.nodecat_id,
cat_node.matcat_id AS pump_cat_matcat_id,
cat_node.pnom AS pump_cat_pnom,
cat_node.dnom AS pump_cat_dnom,
node.epa_type,
node.sector_id,
node.state,
node.state_type,
node.annotation AS pump_annotation,
node.observ AS pump_observ,
node.comment AS pump_comment,
node.dma_id,
node.presszonecat_id,
node.soilcat_id AS pump_soilcat_id,
node.function_type AS pump_function_type,
node.category_type AS pump_category_type,
node.fluid_type AS pump_fluid_type,
node.location_type AS pump_location_type,
node.workcat_id AS pump_workcat_id,
node.workcat_id_end AS pump_workcat_id_end,
node.buildercat_id AS pump_buildercat_id,
node.builtdate AS pump_builtdate,
node.enddate AS pump_enddate,
node.ownercat_id AS pump_ownercat_id,
node.address_01 AS pump_address_01,
node.address_02 AS pump_address_02,
node.address_03 AS pump_address_03,
node.descript AS pump_descript,
cat_node.svg AS pump_cat_svg,
node.rotation AS pump_rotation,
node.label_x AS pump_label_x,
node.label_y AS pump_label_y,
node.label_rotation AS pump_label_rotation,
concat(node_type.link_path,node.link) AS pump_link,
node.verified,
node.the_geom,
node.undelete,
node.publish,
node.inventory,
dma.macrodma_id,
node.expl_id,
node.hemisphere as pump_hemisphere,
node.num_value as pump_num_value,
man_pump.max_flow AS pump_max_flow,
man_pump.min_flow AS pump_min_flow,
man_pump.nom_flow AS pump_nom_flow,
man_pump."power" AS pump_power,
man_pump.pressure AS pump_pressure,
man_pump.elev_height AS pump_elev_height,
man_pump.name AS pump_name
FROM selector_expl, node JOIN v_node ON node.node_id=v_node.node_id
	LEFT JOIN cat_node ON ((node.nodecat_id) = (cat_node.id))
	JOIN node_type ON node_type.id=cat_node.nodetype_id
	LEFT JOIN dma ON (((node.dma_id) = (dma.dma_id)))
	JOIN man_pump ON man_pump.node_id = node.node_id
	WHERE ((node.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());


	
	
DROP VIEW IF EXISTS v_edit_man_reduction CASCADE;
CREATE OR REPLACE VIEW v_edit_man_reduction AS 
SELECT 
node.node_id,
node.code AS reduction_code,
node.elevation AS reduction_elevation,
node.depth AS reduction_depth,
cat_node.nodetype_id,
node.nodecat_id,
cat_node.matcat_id AS reduction_cat_matcat_id,
cat_node.pnom AS reduction_cat_pnom,
cat_node.dnom AS reduction_cat_dnom,
node.epa_type,
node.sector_id,
node.state,
node.state_type,
node.annotation AS reduction_annotation,
node.observ AS reduction_observ,
node.comment AS reduction_comment,
node.dma_id,
node.presszonecat_id,
node.soilcat_id AS reduction_soilcat_id,
node.function_type AS reduction_function_type,
node.category_type AS reduction_category_type,
node.fluid_type AS reduction_fluid_type,
node.location_type AS reduction_location_type,
node.workcat_id AS reduction_workcat_id,
node.workcat_id_end AS reduction_workcat_id_end,
node.buildercat_id AS reduction_buildercat_id,
node.builtdate AS reduction_builtdate,
node.enddate AS reduction_enddate,
node.ownercat_id AS reduction_ownercat_id,
node.address_01 AS reduction_address_01,
node.address_02 AS reduction_address_02,
node.address_03 AS reduction_address_03,
node.descript AS reduction_descript,
cat_node.svg AS reduction_cat_svg,
node.rotation AS reduction_rotation,
concat(node_type.link_path,node.link) AS reduction_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS reduction_label_x,
node.label_y AS reduction_label_y,
node.label_rotation AS reduction_label_rotation,
node.publish,
node.inventory,
dma.macrodma_id,
node.expl_id,
node.hemisphere as reduction_hemisphere,
node.num_value as reduction_num_value,
man_reduction.diam1 AS reduction_diam1,
man_reduction.diam2 AS reduction_diam2
FROM selector_expl, node JOIN v_node ON node.node_id=v_node.node_id
	LEFT JOIN cat_node ON ((node.nodecat_id) = (cat_node.id))
	JOIN node_type ON node_type.id=cat_node.nodetype_id
	LEFT JOIN dma ON (((node.dma_id) = (dma.dma_id)))
	JOIN man_reduction ON man_reduction.node_id = node.node_id
	WHERE ((node.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());
	 


DROP VIEW IF EXISTS v_edit_man_source CASCADE;
CREATE OR REPLACE VIEW v_edit_man_source AS 
SELECT 
node.node_id,
node.code AS source_code,
node.elevation AS source_elevation,
node.depth AS source_depth,
cat_node.nodetype_id,
node.nodecat_id,
cat_node.matcat_id AS source_cat_matcat_id,
cat_node.pnom AS source_cat_pnom,
cat_node.dnom AS source_cat_dnom,
node.epa_type,
node.sector_id,
node.state,
node.state_type,
node.annotation AS source_annotation,
node.observ AS source_observ,
node.comment AS source_comment,
node.dma_id,
node.presszonecat_id,
node.soilcat_id AS source_soilcat_id,
node.function_type AS source_function_type,
node.category_type AS source_category_type,
node.fluid_type AS source_fluid_type,
node.location_type AS source_location_type,
node.workcat_id AS source_workcat_id,
node.workcat_id_end AS source_workcat_id_end,
node.buildercat_id AS source_buildercat_id,
node.builtdate AS source_builtdate,
node.enddate AS source_enddate,
node.ownercat_id AS source_ownercat_id,
node.address_01 AS source_address_01,
node.address_02 AS source_address_02,
node.address_03 AS source_address_03,
node.descript AS source_descript,
cat_node.svg AS source_cat_svg,
node.rotation AS source_rotation,
concat(node_type.link_path,node.link) AS source_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS source_label_x,
node.label_y AS source_label_y,
node.label_rotation AS source_label_rotation,
node.publish,
node.inventory,
dma.macrodma_id,
node.expl_id,
node.hemisphere AS source_hemisphere,
node.num_value as source_num_value,
man_source.name AS source_name
FROM selector_expl, node JOIN v_node ON node.node_id=v_node.node_id
	LEFT JOIN cat_node ON ((node.nodecat_id) = (cat_node.id))
	JOIN node_type ON node_type.id=cat_node.nodetype_id
	LEFT JOIN dma ON (((node.dma_id) = (dma.dma_id)))
	JOIN man_source ON node.node_id = man_source.node_id
	WHERE ((node.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());
	
 
	 
DROP VIEW IF EXISTS v_edit_man_valve CASCADE;
CREATE OR REPLACE VIEW v_edit_man_valve AS 
SELECT 
node.node_id,
node.code AS valve_code,
node.elevation AS valve_elevation,
node.depth AS valve_depth,
cat_node.nodetype_id,
node.nodecat_id,
cat_node.matcat_id AS valve_cat_matcat_id,
cat_node.pnom AS valve_cat_pnom,
cat_node.dnom AS valve_cat_dnom,
node.epa_type,
node.sector_id,
node.state,
node.state_type,
node.annotation AS valve_annotation,
node.observ AS valve_observ,
node.comment AS valve_comment,
node.dma_id,
node.presszonecat_id,
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
cat_node.svg AS valve_cat_svg,
node.rotation AS valve_rotation,
concat(node_type.link_path,node.link) AS valve_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS valve_label_x,
node.label_y AS valve_label_y,
node.label_rotation AS valve_label_rotation,
node.publish,
node.inventory,
dma.macrodma_id,
node.expl_id,
node.hemisphere as valve_hemisphere,
node.num_value as valve_num_value,
man_valve.closed AS valve_closed,
man_valve.broken AS valve_broken,
man_valve.buried AS valve_buried,
man_valve.irrigation_indicator AS valve_irrigation_indicator,
man_valve.pression_entry AS valve_pression_entry,
man_valve.pression_exit AS valve_pression_exit,
man_valve.depth_valveshaft AS valve_depth_valveshaft,
man_valve.regulator_situation AS valve_regulator_situation,
man_valve.regulator_location AS valve_regulator_location,
man_valve.regulator_observ AS valve_regulator_observ,
man_valve.lin_meters AS valve_lin_meters,
man_valve.exit_type AS valve_exit_type,
man_valve.exit_code AS valve_exit_code,
man_valve.drive_type AS valve_drive_type,
man_valve.valve_diam AS valve_valve_diam,
man_valve.cat_valve2 AS valve_cat_valve2,
man_valve.arc_id AS valve_arc_id
FROM selector_expl, node JOIN v_node ON node.node_id=v_node.node_id
	LEFT JOIN cat_node ON ((node.nodecat_id) = (cat_node.id))
	JOIN node_type ON node_type.id=cat_node.nodetype_id
	LEFT JOIN dma ON (((node.dma_id) = (dma.dma_id)))
	JOIN man_valve ON man_valve.node_id = node.node_id
	WHERE ((node.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());
	

	 
DROP VIEW IF EXISTS v_edit_man_waterwell CASCADE;
CREATE OR REPLACE VIEW v_edit_man_waterwell AS 
SELECT
node.node_id,
node.code AS waterwell_code,
node.elevation AS waterwell_elevation,
node.depth AS waterwell_depth,
cat_node.nodetype_id,
node.nodecat_id,
cat_node.matcat_id AS waterwell_cat_matcat_id,
cat_node.pnom AS waterwell_cat_pnom,
cat_node.dnom AS waterwell_cat_dnom,
node.epa_type,
node.sector_id,
node.state,
node.state_type,
node.annotation AS waterwell_annotation,
node.observ AS waterwell_observ,
node.comment AS waterwell_comment,
node.dma_id,
node.presszonecat_id,
node.soilcat_id AS waterwell_soilcat_id,
node.function_type AS waterwell_function_type,
node.category_type AS waterwell_category_type,
node.fluid_type AS waterwell_fluid_type,
node.location_type AS waterwell_location_type,
node.workcat_id AS waterwell_workcat_id,
node.workcat_id_end AS waterwell_workcat_id_end,
node.buildercat_id AS waterwell_buildercat_id,
node.builtdate AS waterwell_builtdate,
node.enddate AS waterwell_enddate, 
node.ownercat_id AS waterwell_ownercat_id,
node.address_01 AS waterwell_address_01,
node.address_02 AS waterwell_address_02,
node.address_03 AS waterwell_address_03,
node.descript AS waterwell_descript,
cat_node.svg AS waterwell_cat_svg,
node.rotation AS waterwell_rotation,
concat(node_type.link_path,node.link) AS waterwell_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS waterwell_label_x,
node.label_y AS waterwell_label_y,
node.label_rotation AS waterwell_label_rotation,
node.publish,
node.inventory,
dma.macrodma_id,
node.expl_id,
node.hemisphere as waterwell_hemisphere,
node.num_value as waterwell_num_value,
man_waterwell.name AS waterwell_name
FROM selector_expl, node JOIN v_node ON node.node_id=v_node.node_id
	LEFT JOIN cat_node ON ((node.nodecat_id) = (cat_node.id))
	JOIN node_type ON node_type.id=cat_node.nodetype_id
	LEFT JOIN dma ON (((node.dma_id) = (dma.dma_id)))
	JOIN man_waterwell ON node.node_id = man_waterwell.node_id
	WHERE ((node.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());
	
   
DROP VIEW IF EXISTS v_edit_man_tank CASCADE;
CREATE OR REPLACE VIEW v_edit_man_tank AS 
SELECT 
node.node_id,
node.code AS tank_code,
node.elevation AS tank_elevation,
node.depth AS tank_depth,
cat_node.nodetype_id,
node.nodecat_id,
cat_node.matcat_id AS tank_cat_matcat_id,
cat_node.pnom AS tank_cat_pnom,
cat_node.dnom AS tank_cat_dnom,
node.epa_type,
node.sector_id,
node.state,
node.state_type,
node.annotation AS tank_annotation,
node.observ AS tank_observ,
node.comment AS tank_comment,
node.dma_id,
node.presszonecat_id,
node.soilcat_id AS tank_soilcat_id,
node.function_type AS tank_function_type,
node.category_type AS tank_category_type,
node.fluid_type AS tank_fluid_type,
node.location_type AS tank_location_type,
node.workcat_id AS tank_workcat_id,
node.workcat_id_end AS tank_workcat_id_end,
node.buildercat_id AS tank_buildercat_id,
node.builtdate AS tank_builtdate,
node.enddate AS tank_enddate,
node.ownercat_id AS tank_ownercat_id,
node.address_01 AS tank_address_01,
node.address_02 AS tank_address_02,
node.address_03 AS tank_address_03,
node.descript AS tank_descript,
cat_node.svg AS tank_cat_svg,
node.rotation AS tank_rotation,
concat(node_type.link_path,node.link) AS tank_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS tank_label_x,
node.label_y AS tank_label_y,
node.label_rotation AS tank_label_rotation,
node.publish,
node.inventory,
dma.macrodma_id,
node.expl_id,
node.hemisphere as tank_hemisphere,
node.num_value as tank_num_value,
man_tank.pol_id AS tank_pol_id,
man_tank.vmax AS tank_vmax,
man_tank.vutil AS tank_vutil,
man_tank.area AS tank_area,
man_tank.chlorination AS tank_chlorination,
man_tank.name AS tank_name
FROM selector_expl, node JOIN v_node ON node.node_id=v_node.node_id
	LEFT JOIN cat_node ON node.nodecat_id = cat_node.id
	JOIN node_type ON node_type.id=cat_node.nodetype_id
	LEFT JOIN dma ON node.dma_id = dma.dma_id
	JOIN man_tank ON man_tank.node_id = node.node_id
	WHERE ((node.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());

	
DROP VIEW IF EXISTS v_edit_man_tank_pol CASCADE;
CREATE OR REPLACE VIEW v_edit_man_tank_pol AS 
SELECT 
node.node_id,
node.code AS tank_code,
node.elevation AS tank_elevation,
node.depth AS tank_depth,
cat_node.nodetype_id,
node.nodecat_id,
cat_node.matcat_id AS tank_cat_matcat_id,
cat_node.pnom AS tank_cat_pnom,
cat_node.dnom AS tank_cat_dnom,
node.epa_type,
node.sector_id,
node.state,
node.state_type,
node.annotation AS tank_annotation,
node.observ AS tank_observ,
node.comment AS tank_comment,
node.dma_id,
node.presszonecat_id,
node.soilcat_id AS tank_soilcat_id,
node.function_type AS tank_function_type,
node.category_type AS tank_category_type,
node.fluid_type AS tank_fluid_type,
node.location_type AS tank_location_type,
node.workcat_id AS tank_workcat_id,
node.workcat_id_end AS tank_workcat_id_end,
node.buildercat_id AS tank_buildercat_id,
node.builtdate AS tank_builtdate,
node.enddate AS tank_enddate,
node.ownercat_id AS tank_ownercat_id,
node.address_01 AS tank_address_01,
node.address_02 AS tank_address_02,
node.address_03 AS tank_address_03,
node.descript AS tank_descript,
cat_node.svg AS tank_cat_svg,
node.rotation AS tank_rotation,
concat(node_type.link_path,node.link) AS tank_link,
node.verified,
polygon.the_geom,
node.undelete,
node.label_x AS tank_label_x,
node.label_y AS tank_label_y,
node.label_rotation AS tank_label_rotation,
node.publish,
node.inventory,
dma.macrodma_id,
node.expl_id,
node.hemisphere as tank_hemisphere,
node.num_value as tank_num_value,
man_tank.pol_id AS tank_pol_id,
man_tank.vmax AS tank_vmax,
man_tank.vutil AS tank_vutil,
man_tank.area AS tank_area,
man_tank.chlorination AS tank_chlorination,
man_tank.name AS tank_name
FROM selector_expl, node JOIN v_node ON node.node_id=v_node.node_id
	LEFT JOIN cat_node ON node.nodecat_id = cat_node.id
	JOIN node_type ON node_type.id=cat_node.nodetype_id
	LEFT JOIN dma ON node.dma_id = dma.dma_id
	JOIN man_tank ON man_tank.node_id = node.node_id
	JOIN polygon ON polygon.pol_id=man_tank.pol_id
	WHERE ((node.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());
	

DROP VIEW IF EXISTS v_edit_man_filter CASCADE;
CREATE OR REPLACE VIEW v_edit_man_filter AS 
SELECT
node.node_id,
node.code AS filter_code,
node.elevation AS filter_elevation,
node.depth AS filter_depth,
cat_node.nodetype_id,
node.nodecat_id,
cat_node.matcat_id AS filter_cat_matcat_id,
cat_node.pnom AS filter_cat_pnom,
cat_node.dnom AS filter_cat_dnom,
node.epa_type,
node.sector_id,
node.state,
node.state_type,
node.annotation AS filter_annotation,
node.observ AS filter_observ,
node.comment AS filter_comment,
node.dma_id,
node.presszonecat_id,
node.soilcat_id AS filter_soilcat_id,
node.function_type AS filter_function_type,
node.category_type AS filter_category_type,
node.fluid_type AS filter_fluid_type,
node.location_type AS filter_location_type,
node.workcat_id AS filter_workcat_id,
node.workcat_id_end AS filter_workcat_id_end,
node.buildercat_id AS filter_buildercat_id,
node.builtdate AS filter_builtdate,
node.enddate AS filter_enddate,
node.ownercat_id AS filter_ownercat_id,
node.address_01 AS filter_address_01,
node.address_02 AS filter_address_02,
node.address_03 AS filter_address_03,
node.descript AS filter_descript,
cat_node.svg AS filter_cat_svg,
node.rotation AS filter_rotation,
node.label_x AS filter_label_x,
node.label_y AS filter_label_y,
node.label_rotation AS filter_label_rotation,
concat(node_type.link_path,node.link) AS filter_link,
node.verified,
node.the_geom,
node.undelete,
node.publish,
node.inventory,
dma.macrodma_id,
node.expl_id,
node.hemisphere as filter_hemisphere,
node.num_value as filter_num_value
FROM selector_expl, node JOIN v_node ON node.node_id=v_node.node_id
	LEFT JOIN cat_node ON ((node.nodecat_id) = (cat_node.id))
	JOIN node_type ON node_type.id=cat_node.nodetype_id
	LEFT JOIN dma ON (((node.dma_id) = (dma.dma_id)))
	JOIN man_filter ON node.node_id = man_filter.node_id
	WHERE ((node.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());
	
	
DROP VIEW IF EXISTS v_edit_man_register CASCADE;
CREATE OR REPLACE VIEW v_edit_man_register AS 
SELECT 
node.node_id,
node.code AS register_code,
node.elevation AS register_elevation,
node.depth AS register_depth,
cat_node.nodetype_id,
node.nodecat_id,
cat_node.matcat_id AS register_cat_matcat_id,
cat_node.pnom AS register_cat_pnom,
cat_node.dnom AS register_cat_dnom,
node.epa_type,
node.sector_id,
node.state,
node.state_type,
node.annotation AS register_annotation,
node.observ AS register_observ,
node.comment AS register_comment,
node.dma_id,
node.presszonecat_id,
node.soilcat_id AS register_soilcat_id,
node.function_type AS register_function_type,
node.category_type AS register_category_type,
node.fluid_type AS register_fluid_type,
node.location_type AS register_location_type,
node.workcat_id AS register_workcat_id,
node.workcat_id_end AS register_workcat_id_end,
node.buildercat_id AS register_buildercat_id,
node.builtdate AS register_builtdate,
node.enddate AS register_enddate,
node.ownercat_id AS register_ownercat_id,
node.address_01 AS register_address_01,
node.address_02 AS register_address_02,
node.address_03 AS register_address_03,
node.descript AS register_descript,
cat_node.svg AS register_cat_svg,
node.rotation AS register_rotation,
concat(node_type.link_path,node.link) AS register_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS register_label_x,
node.label_y AS register_label_y,
node.label_rotation AS register_label_rotation,
node.publish,
node.inventory,
dma.macrodma_id,
node.expl_id,
node.hemisphere as register_hemisphere,
node.num_value as register_num_value,
man_register.pol_id AS register_pol_id
FROM selector_expl, node JOIN v_node ON node.node_id=v_node.node_id
	LEFT JOIN cat_node ON ((node.nodecat_id) = (cat_node.id))
	JOIN node_type ON node_type.id=cat_node.nodetype_id
	LEFT JOIN dma ON (((node.dma_id) = (dma.dma_id)))
	JOIN man_register ON node.node_id = man_register.node_id
	WHERE ((node.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());


	
DROP VIEW IF EXISTS v_edit_man_register_pol CASCADE;
CREATE OR REPLACE VIEW v_edit_man_register_pol AS 
SELECT 
node.node_id,
node.code AS register_code,
node.elevation AS register_elevation,
node.depth AS register_depth,
cat_node.nodetype_id,
node.nodecat_id,
cat_node.matcat_id AS register_cat_matcat_id,
cat_node.pnom AS register_cat_pnom,
cat_node.dnom AS register_cat_dnom,
node.epa_type,
node.sector_id,
node.state,
node.state_type,
node.annotation AS register_annotation,
node.observ AS register_observ,
node.comment AS register_comment,
node.dma_id,
node.presszonecat_id,
node.soilcat_id AS register_soilcat_id,
node.function_type AS register_function_type,
node.category_type AS register_category_type,
node.fluid_type AS register_fluid_type,
node.location_type AS register_location_type,
node.workcat_id AS register_workcat_id,
node.workcat_id_end AS register_workcat_id_end,
node.buildercat_id AS register_buildercat_id,
node.builtdate AS register_builtdate,
node.enddate AS register_enddate,
node.ownercat_id AS register_ownercat_id,
node.address_01 AS register_address_01,
node.address_02 AS register_address_02,
node.address_03 AS register_address_03,
node.descript AS register_descript,
cat_node.svg AS register_cat_svg,
node.rotation AS register_rotation,
concat(node_type.link_path,node.link) AS register_link,
node.verified,
polygon.the_geom,
node.undelete,
node.label_x AS register_label_x,
node.label_y AS register_label_y,
node.label_rotation AS register_label_rotation,
node.publish,
node.inventory,
dma.macrodma_id,
node.expl_id,
node.hemisphere as register_hemisphere,
node.num_value as register_num_value,
man_register.pol_id AS register_pol_id
FROM selector_expl, node JOIN v_node ON node.node_id=v_node.node_id
	LEFT JOIN cat_node ON ((node.nodecat_id) = (cat_node.id))
	JOIN node_type ON node_type.id=cat_node.nodetype_id
	LEFT JOIN dma ON (((node.dma_id) = (dma.dma_id)))
	JOIN man_register ON node.node_id = man_register.node_id
	JOIN polygon ON polygon.pol_id = man_register.pol_id
	WHERE ((node.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());

	
DROP VIEW IF EXISTS v_edit_man_netwjoin CASCADE;
CREATE OR REPLACE VIEW v_edit_man_netwjoin AS 
SELECT 
node.node_id,
node.code AS netwjoin_code,
node.elevation AS netwjoin_elevation,
node.depth AS netwjoin_depth,
cat_node.nodetype_id,
node.nodecat_id,
cat_node.matcat_id AS netwjoin_cat_matcat_id,
cat_node.pnom AS netwjoin_cat_pnom,
cat_node.dnom AS netwjoin_cat_dnom,
node.epa_type,
node.sector_id,
node.state,
node.state_type,
node.annotation AS netwjoin_annotation,
node.observ AS netwjoin_observ,
node.comment AS netwjoin_comment,
node.dma_id,
node.presszonecat_id,
node.soilcat_id AS netwjoin_soilcat_id,
node.function_type AS netwjoin_function_type,
node.category_type AS netwjoin_category_type,
node.fluid_type AS netwjoin_fluid_type,
node.location_type AS netwjoin_location_type,
node.workcat_id AS netwjoin_workcat_id,
node.workcat_id_end AS netwjoin_workcat_id_end,
node.buildercat_id AS netwjoin_buildercat_id,
node.builtdate AS netwjoin_builtdate,
node.enddate AS netwjoin_enddate,
node.ownercat_id AS netwjoin_ownercat_id,
node.address_01 AS netwjoin_address_01,
node.address_02 AS netwjoin_address_02,
node.address_03 AS netwjoin_address_03,
node.descript AS netwjoin_descript,
cat_node.svg AS netwjoin_cat_svg,
node.rotation AS netwjoin_rotation,
concat(node_type.link_path,node.link) AS netwjoin_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS netwjoin_label_x,
node.label_y AS netwjoin_label_y,
node.label_rotation AS netwjoin_label_rotation,
node.publish,
node.inventory,
dma.macrodma_id,
node.expl_id,
node.hemisphere as netwjoin_hemisphere,
node.num_value as netwjoin_num_value,
man_netwjoin.customer_code as netwjoin_customer_code,
man_netwjoin.streetaxis_id as netwjoin_streetaxis_id,
ext_streetaxis.name as netwjoin_streetname,
man_netwjoin.postnumber AS netwjoin_postnumber,
man_netwjoin.top_floor AS netwjoin_top_floor,
man_netwjoin.cat_valve AS netwjoin_cat_valve
FROM selector_expl, node JOIN v_node ON node.node_id=v_node.node_id
	LEFT JOIN cat_node ON ((node.nodecat_id) = (cat_node.id))
	JOIN node_type ON node_type.id=cat_node.nodetype_id
	LEFT JOIN dma ON (((node.dma_id) = (dma.dma_id)))
	JOIN man_netwjoin ON node.node_id = man_netwjoin.node_id
	LEFT JOIN ext_streetaxis ON man_netwjoin.streetaxis_id=ext_streetaxis.id
	WHERE ((node.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());
	
	
DROP VIEW IF EXISTS v_edit_man_flexunion CASCADE;
CREATE OR REPLACE VIEW v_edit_man_flexunion AS 
SELECT 
node.node_id,
node.code AS flexunion_code,
node.elevation AS flexunion_elevation,
node.depth AS flexunion_depth,
cat_node.nodetype_id,
node.nodecat_id,
cat_node.matcat_id AS flexunion_cat_matcat_id,
cat_node.pnom AS flexunion_cat_pnom,
cat_node.dnom AS flexunion_cat_dnom,
node.epa_type,
node.sector_id,
node.state,
node.state_type,
node.annotation AS flexunion_annotation,
node.observ AS flexunion_observ,
node.comment AS flexunion_comment,
node.dma_id,
node.presszonecat_id,
node.soilcat_id AS flexunion_soilcat_id,
node.function_type AS flexunion_function_type,
node.category_type AS flexunion_category_type,
node.fluid_type AS flexunion_fluid_type,
node.location_type AS flexunion_location_type,
node.workcat_id AS flexunion_workcat_id,
node.workcat_id_end AS flexunion_workcat_id_end,
node.buildercat_id AS flexunion_buildercat_id,
node.builtdate AS flexunion_builtdate,
node.enddate AS flexunion_enddate,
node.ownercat_id AS flexunion_ownercat_id,
node.address_01 AS flexunion_address_01,
node.address_02 AS flexunion_address_02,
node.address_03 AS flexunion_address_03,
node.descript AS flexunion_descript,
cat_node.svg AS flexunion_cat_svg,
node.rotation AS flexunion_rotation,
concat(node_type.link_path,node.link) AS flexunion_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS flexunion_label_x,
node.label_y AS flexunion_label_y,
node.label_rotation AS flexunion_label_rotation,
node.publish,
node.inventory,
dma.macrodma_id,
node.expl_id,
node.hemisphere as flexunion_hemisphere,
node.num_value as flexunion_num_value
FROM selector_expl, node JOIN v_node ON node.node_id=v_node.node_id
	LEFT JOIN cat_node ON ((node.nodecat_id) = (cat_node.id))
	JOIN node_type ON node_type.id=cat_node.nodetype_id
	LEFT JOIN dma ON (((node.dma_id) = (dma.dma_id)))
	JOIN man_flexunion ON node.node_id = man_flexunion.node_id
	WHERE ((node.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());
	
DROP VIEW IF EXISTS v_edit_man_wtp CASCADE;
CREATE OR REPLACE VIEW v_edit_man_wtp AS 
SELECT 
node.node_id,
node.code AS wtp_code,
node.elevation AS wtp_elevation,
node.depth AS wtp_depth,
cat_node.nodetype_id,
node.nodecat_id,
cat_node.matcat_id AS wtp_cat_matcat_id,
cat_node.pnom AS wtp_cat_pnom,
cat_node.dnom AS wtp_cat_dnom,
node.epa_type,
node.sector_id,
node.state,
node.state_type,
node.annotation AS wtp_annotation,
node.observ AS wtp_observ,
node.comment AS wtp_comment,
node.dma_id,
node.presszonecat_id,
node.soilcat_id AS wtp_soilcat_id,
node.function_type AS wtp_function_type,
node.category_type AS wtp_category_type,
node.fluid_type AS wtp_fluid_type,
node.location_type AS wtp_location_type,
node.workcat_id AS wtp_workcat_id,
node.workcat_id_end AS wtp_workcat_id_end,
node.buildercat_id AS wtp_buildercat_id,
node.builtdate AS wtp_builtdate,
node.enddate AS wtp_enddate,
node.ownercat_id AS wtp_ownercat_id,
node.address_01 AS wtp_address_01,
node.address_02 AS wtp_address_02,
node.address_03 AS wtp_address_03,
node.descript AS wtp_descript,
cat_node.svg AS wtp_cat_svg,
node.rotation AS wtp_rotation,
concat(node_type.link_path,node.link) AS wtp_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS wtp_label_x,
node.label_y AS wtp_label_y,
node.label_rotation AS wtp_label_rotation,
node.publish,
node.inventory,
dma.macrodma_id,
node.expl_id,
node.hemisphere as wtp_hemisphere,
node.num_value as wtp_num_value,
man_wtp.name AS wtp_name
FROM selector_expl, node JOIN v_node ON node.node_id=v_node.node_id
	LEFT JOIN cat_node ON ((node.nodecat_id) = (cat_node.id))
	JOIN node_type ON node_type.id=cat_node.nodetype_id
	LEFT JOIN dma ON (((node.dma_id) = (dma.dma_id)))
	JOIN man_wtp ON node.node_id = man_wtp.node_id
	WHERE ((node.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());
	
DROP VIEW IF EXISTS v_edit_man_expansiontank CASCADE;
CREATE OR REPLACE VIEW v_edit_man_expansiontank AS 
SELECT 
node.node_id,
node.code AS exptank_code,
node.elevation AS exptank_elevation,
node.depth AS exptank_depth,
cat_node.nodetype_id,
node.nodecat_id,
cat_node.matcat_id AS exptank_cat_matcat_id,
cat_node.pnom AS exptank_cat_pnom,
cat_node.dnom AS exptank_cat_dnom,
node.epa_type,
node.sector_id,
node.state,
node.state_type,
node.annotation AS exptank_annotation,
node.observ AS exptank_observ,
node.comment AS exptank_comment,
node.dma_id,
node.presszonecat_id,
node.soilcat_id AS exptank_soilcat_id,
node.function_type AS exptank_function_type,
node.category_type AS exptank_category_type,
node.fluid_type AS exptank_fluid_type,
node.location_type AS exptank_location_type,
node.workcat_id AS exptank_workcat_id,
node.workcat_id_end AS exptank_workcat_id_end,
node.buildercat_id AS exptank_buildercat_id,
node.builtdate AS exptank_builtdate,
node.enddate AS exptank_enddate,
node.ownercat_id AS exptank_ownercat_id,
node.address_01 AS exptank_address_01,
node.address_02 AS exptank_address_02,
node.address_03 AS exptank_address_03,
node.descript AS exptank_descript,
cat_node.svg AS exptank_cat_svg,
node.rotation AS exptank_rotation,
concat(node_type.link_path,node.link) AS exptank_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS exptank_label_x,
node.label_y AS exptank_label_y,
node.label_rotation AS exptank_label_rotation,
node.publish,
node.inventory,
dma.macrodma_id,
node.expl_id,
node.hemisphere as exptank_hemisphere,
node.num_value as exptank_num_value
FROM selector_expl, node JOIN v_node ON node.node_id=v_node.node_id
	LEFT JOIN cat_node ON ((node.nodecat_id) = (cat_node.id))
	JOIN node_type ON node_type.id=cat_node.nodetype_id
	LEFT JOIN dma ON (((node.dma_id) = (dma.dma_id)))
	JOIN man_expansiontank ON node.node_id = man_expansiontank .node_id
	WHERE ((node.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());
	

DROP VIEW IF EXISTS v_edit_man_netsamplepoint CASCADE;
CREATE OR REPLACE VIEW v_edit_man_netsamplepoint AS 
SELECT 
node.node_id,
node.code AS netsample_code,
node.elevation AS netsample_elevation,
node.depth AS netsample_depth,
cat_node.nodetype_id,
node.nodecat_id,
cat_node.matcat_id AS netsample_cat_matcat_id,
cat_node.pnom AS netsample_cat_pnom,
cat_node.dnom AS netsample_cat_dnom,
node.epa_type,
node.sector_id,
node.state,
node.state_type,
node.annotation AS netsample_annotation,
node.observ AS netsample_observ,
node.comment AS netsample_comment,
node.dma_id,
node.presszonecat_id,
node.soilcat_id AS netsample_soilcat_id,
node.function_type AS netsample_function_type,
node.category_type AS netsample_category_type,
node.fluid_type AS netsample_fluid_type,
node.location_type AS netsample_location_type,
node.workcat_id AS netsample_workcat_id,
node.workcat_id_end AS netsample_workcat_id_end,
node.buildercat_id AS netsample_buildercat_id,
node.builtdate AS netsample_builtdate,
node.enddate AS netsample_enddate,
node.ownercat_id AS netsample_ownercat_id,
node.address_01 AS netsample_address_01,
node.address_02 AS netsample_address_02,
node.address_03 AS netsample_address_03,
node.descript AS netsample_descript,
cat_node.svg AS netsample_cat_svg,
node.rotation AS netsample_rotation,
concat(node_type.link_path,node.link) AS netsample_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS netsample_label_x,
node.label_y AS netsample_label_y,
node.label_rotation AS netsample_label_rotation,
node.publish,
node.inventory,
dma.macrodma_id,
node.expl_id,
node.hemisphere as netsample_hemisphere,
node.num_value as netsample_num_value,
man_netsamplepoint.lab_code AS netsample_lab_code
FROM selector_expl, node JOIN v_node ON node.node_id=v_node.node_id
	LEFT JOIN cat_node ON ((node.nodecat_id) = (cat_node.id))
	JOIN node_type ON node_type.id=cat_node.nodetype_id
	LEFT JOIN dma ON (((node.dma_id) = (dma.dma_id)))
	JOIN man_netsamplepoint ON node.node_id = man_netsamplepoint .node_id
	WHERE ((node.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());


DROP VIEW IF EXISTS v_edit_man_netelement CASCADE;
CREATE OR REPLACE VIEW v_edit_man_netelement AS 
SELECT 
node.node_id,
node.code AS netelement_code,
node.elevation AS netelement_elevation,
node.depth AS netelement_depth,
cat_node.nodetype_id,
node.nodecat_id,
cat_node.matcat_id AS netelement_cat_matcat_id,
cat_node.pnom AS netelement_cat_pnom,
cat_node.dnom AS netelement_cat_dnom,
node.epa_type,
node.sector_id,
node.state,
node.state_type,
node.annotation AS netelement_annotation,
node.observ AS netelement_observ,
node.comment AS netelement_comment,
node.dma_id,
node.presszonecat_id,
node.soilcat_id AS netelement_soilcat_id,
node.function_type AS netelement_function_type,
node.category_type AS netelement_category_type,
node.fluid_type AS netelement_fluid_type,
node.location_type AS netelement_location_type,
node.workcat_id AS netelement_workcat_id,
node.workcat_id_end AS netelement_workcat_id_end,
node.buildercat_id AS netelement_buildercat_id,
node.builtdate AS netelement_builtdate,
node.enddate AS netelement_enddate,
node.ownercat_id AS netelement_ownercat_id,
node.address_01 AS netelement_address_01,
node.address_02 AS netelement_address_02,
node.address_03 AS netelement_address_03,
node.descript AS netelement_descript,
cat_node.svg AS netelement_cat_svg,
node.rotation AS netelement_rotation,
concat(node_type.link_path,node.link) AS netelement_link,
node.verified,
node.the_geom,
node.undelete,
node.label_x AS netelement_label_x,
node.label_y AS netelement_label_y,
node.label_rotation AS netelement_label_rotation,
node.publish,
node.inventory,
dma.macrodma_id,
node.expl_id,
node.hemisphere as netelement_hemisphere,
node.num_value as netelement_num_value,
man_netelement.serial_number as netelement_serial_number
FROM selector_expl, node JOIN v_node ON node.node_id=v_node.node_id
	LEFT JOIN cat_node ON ((node.nodecat_id) = (cat_node.id))
	JOIN node_type ON node_type.id=cat_node.nodetype_id
	LEFT JOIN dma ON (((node.dma_id) = (dma.dma_id)))
	JOIN man_netelement ON node.node_id = man_netelement .node_id
	WHERE ((node.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());
	


DROP VIEW IF EXISTS v_edit_pond CASCADE;
CREATE VIEW v_edit_pond AS 
SELECT
pond_id,
connec_id,
pond.dma_id,
dma.macrodma_id,
pond."state",
pond.the_geom,
pond.expl_id
FROM selector_expl,pond
LEFT JOIN dma ON pond.dma_id = dma.dma_id
WHERE ((pond.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());


DROP VIEW IF EXISTS v_edit_pool CASCADE;
CREATE VIEW v_edit_pool AS 
SELECT
pool_id,
connec_id,
pool.dma_id,
dma.macrodma_id,
pool."state",
pool.the_geom,
pool.expl_id
FROM selector_expl,pool
LEFT JOIN dma ON pool.dma_id = dma.dma_id
WHERE ((pool.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());



CREATE OR REPLACE VIEW v_value_cat_connec AS 
 SELECT cat_connec.id,
    cat_connec.connectype_id AS connec_type,
    connec_type.type
   FROM cat_connec
     JOIN connec_type ON connec_type.id::text = cat_connec.connectype_id::text;

     
     CREATE OR REPLACE VIEW v_value_cat_node AS 
 SELECT cat_node.id,
    cat_node.nodetype_id,
    node_type.type
   FROM cat_node
     JOIN node_type ON node_type.id::text = cat_node.nodetype_id::text;

