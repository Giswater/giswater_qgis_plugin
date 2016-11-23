/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;
----------------------------
--    GIS EDITING VIEWS
----------------------------

DROP VIEW IF EXISTS v_edit_node CASCADE;
CREATE OR REPLACE VIEW v_edit_node AS
SELECT 
node.node_id, 
node.elevation, 
node.depth, 
node.node_type,
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
dma.presszonecat_id,
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
node.label_rotation
FROM ("SCHEMA_NAME".node 
LEFT JOIN cat_node ON (((node.nodecat_id)::text = (cat_node.id)::text))
LEFT JOIN dma ON (((node.dma_id)::text = (dma.dma_id)::text)));


DROP VIEW IF EXISTS v_edit_arc CASCADE;
CREATE OR REPLACE VIEW v_edit_arc AS
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
dma.presszonecat_id,
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
arc.the_geom,
arc.workcat_id_end,
arc.undelete,
arc.label_x,
arc.label_y,
arc.label_rotation
FROM ("SCHEMA_NAME".arc 
LEFT JOIN cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text))
LEFT JOIN dma ON (((arc.dma_id)::text = (dma.dma_id)::text)));



DROP VIEW v_edit_connec;
CREATE OR REPLACE VIEW v_edit_connec AS 
 SELECT connec.connec_id,
connec.elevation,
connec.depth,
connec.connecat_id,
cat_connec.type AS cat_connectype_id,
cat_connec.matcat_id AS cat_matcat_id,
cat_connec.pnom AS cat_pnom,
cat_connec.dnom AS cat_dnom,
connec.sector_id,
connec.code,
v_rtc_hydrometer_x_connec.n_hydrometer,
connec.demand,
connec.state,
connec.annotation,
connec.observ,
connec.comment,
connec.dma_id,
dma.presszonecat_id,
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
cat_connec.svg AS cat_svg,
connec.rotation,
connec.link,
connec.verified,
connec.the_geom,
connec.connec_type,
connec.undelete,
connec.label_x,
connec.label_y,
connec.label_rotation,
connec.workcat_id_end
FROM connec
JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id::text = v_rtc_hydrometer_x_connec.connec_id::text
LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
LEFT JOIN link ON connec.connec_id::text = link.connec_id::text
LEFT JOIN vnode ON vnode.vnode_id::text = link.vnode_id::text
LEFT JOIN dma ON connec.dma_id::text = dma.dma_id::text;



DROP VIEW IF EXISTS v_edit_link CASCADE;
CREATE OR REPLACE VIEW v_edit_link AS
SELECT 
link.link_id,
link.connec_id,
link.vnode_id,
st_length2d(link.the_geom) as gis_length,
link.custom_length,
connec.connecat_id,
link.the_geom
FROM ("SCHEMA_NAME".link 
LEFT JOIN connec ON (((connec.connec_id)::text = (link.connec_id)::text))
);


DROP VIEW IF EXISTS v_edit_man_hydrant CASCADE;
CREATE OR REPLACE VIEW v_edit_man_hydrant AS 
 SELECT node.node_id,
    node.elevation AS hydrant_elevation,
    node.depth AS hydrant_depth,
    node.node_type,
    node.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    cat_node.pnom AS cat_pnom,
    cat_node.dnom AS cat_dnom,
    node.epa_type,
    node.sector_id,
    node.state AS hydrant_state,
    node.annotation AS hydrant_annotation,
    node.observ AS hydrant_observ,
    node.comment AS hydrant_comment,
    node.dma_id,
    dma.presszonecat_id,
    node.soilcat_id AS hydrant_soilcat_id,
    node.category_type AS hydrant_category_type,
    node.fluid_type AS hydrant_fluid_type,
    node.location_type AS hydrant_location_type,
    node.workcat_id AS hydrant_workcat_id,
    node.workcat_id_end AS hydrant_workcat_id_end,
    node.buildercat_id AS hydrant_buildercat_id,
    node.builtdate AS hydrant_builtdate,
    node.ownercat_id AS hydrant_ownercat_id,
    node.adress_01 AS hydrant_adress_01,
    node.adress_02 AS hydrant_adress_02,
    node.adress_03 AS hydrant_adress_03,
    node.descript AS hydrant_descript,
    cat_node.svg AS cat_svg,
    node.rotation AS hydrant_rotation,
    node.link AS hydrant_link,
    node.verified,
    node.the_geom,
    node.undelete,
    node.label_x AS hydrant_label_x,
    node.label_y AS hydrant_label_y,
    node.label_rotation AS hydrant_label_rotation,
    man_hydrant.communication AS hydrant_communication,
    man_hydrant.valve AS hydrant_valve,
    man_hydrant.valve_diam AS hydrant_valve_diam,
    man_hydrant.distance_left AS hydrant_distance_left,
    man_hydrant.distance_right AS hydrant_distance_right,
    man_hydrant.distance_perpendicular AS hydrant_distance_perpendicular,
    man_hydrant.location AS hydrant_location,
    man_hydrant.location_sign AS hydrant_location_sign
   FROM node
     LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
     LEFT JOIN dma ON node.dma_id::text = dma.dma_id::text
     JOIN man_hydrant ON man_hydrant.node_id::text = node.node_id::text;
	 

	 
DROP VIEW IF EXISTS v_edit_man_junction CASCADE;
CREATE OR REPLACE VIEW v_edit_man_junction AS 
 SELECT node.node_id,
    node.elevation AS junction_elevation,
    node.depth AS junction_depth,
    node.node_type,
    node.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    cat_node.pnom AS cat_pnom,
    cat_node.dnom AS cat_dnom,
    node.epa_type,
    node.sector_id,
    node.state AS junction_state,
    node.annotation AS junction_annotation,
    node.observ AS junction_observ,
    node.comment AS junction_comment,
    node.dma_id,
    dma.presszonecat_id,
    node.soilcat_id AS junction_soilcat_id,
    node.category_type AS junction_category_type,
    node.fluid_type AS junction_fluid_type,
    node.location_type AS junction_location_type,
    node.workcat_id AS junction_workcat_id,
    node.workcat_id_end AS junction_workcat_id_end,
    node.buildercat_id AS junction_buildercat_id,
    node.builtdate AS junction_builtdate,
    node.ownercat_id AS junction_ownercat_id,
    node.adress_01 AS junction_adress_01,
    node.adress_02 AS junction_adress_02,
    node.adress_03 AS junction_adress_03,
    node.descript AS junction_descript,
    cat_node.svg AS cat_svg,
    node.rotation AS junction_rotation,
    node.label_x AS junction_label_x,
    node.label_y AS junction_label_y,
    node.label_rotation AS junction_label_rotation,
    node.link AS junction_link,
    node.verified,
    node.the_geom,
    node.undelete
   FROM node
     LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
     LEFT JOIN dma ON node.dma_id::text = dma.dma_id::text
     JOIN man_junction ON node.node_id::text = man_junction.node_id::text;


	 
DROP VIEW IF EXISTS v_edit_man_manhole CASCADE;
CREATE OR REPLACE VIEW v_edit_man_manhole AS 
 SELECT node.node_id,
    node.elevation AS manhole_elevation,
    node.depth AS manhole_depth,
    node.node_type,
    node.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    cat_node.pnom AS cat_pnom,
    cat_node.dnom AS cat_dnom,
    node.epa_type,
    node.sector_id,
    node.state AS manhole_state,
    node.annotation AS manhole_annotation,
    node.observ AS manhole_observ,
    node.comment AS manhole_comment,
    node.dma_id,
    dma.presszonecat_id,
    node.soilcat_id AS manhole_soilcat_id,
    node.category_type AS manhole_category_type,
    node.fluid_type AS manhole_fluid_type,
    node.location_type AS manhole_location_type,
    node.workcat_id AS manhole_workcat_id,
    node.workcat_id_end AS manhole_workcat_id_end,
    node.buildercat_id AS manhole_buildercat_id,
    node.builtdate AS manhole_builtdate,
    node.ownercat_id AS manhole_ownercat_id,
    node.adress_01 AS manhole_adress_01,
    node.adress_02 AS manhole_adress_02,
    node.adress_03 AS manhole_adress_03,
    node.descript AS manhole_descript,
    cat_node.svg AS cat_svg,
    node.rotation AS manhole_rotation,
    node.label_x AS manhole_label_x,
    node.label_y AS manhole_label_y,
    node.label_rotation AS manhole_label_rotation,
    node.link AS manhole_link,
    node.verified,
    node.the_geom,
    node.undelete
   FROM node
     LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
     LEFT JOIN dma ON node.dma_id::text = dma.dma_id::text
     JOIN man_manhole ON node.node_id::text = man_manhole.node_id::text;


DROP VIEW IF EXISTS v_edit_man_meter CASCADE;
CREATE OR REPLACE VIEW v_edit_man_meter AS 
 SELECT node.node_id,
    node.elevation AS meter_elevation,
    node.depth AS meter_depth,
    node.node_type,
    node.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    cat_node.pnom AS cat_pnom,
    cat_node.dnom AS cat_dnom,
    node.epa_type,
    node.sector_id,
    node.state AS meter_state,
    node.annotation AS meter_annotation,
    node.observ AS meter_observ,
    node.comment AS meter_comment,
    node.dma_id,
    dma.presszonecat_id,
    node.soilcat_id AS meter_soilcat_id,
    node.category_type AS meter_category_type,
    node.fluid_type AS meter_fluid_type,
    node.location_type AS meter_location_type,
    node.workcat_id AS meter_workcat_id,
    node.workcat_id_end AS meter_workcat_id_end,
    node.buildercat_id AS meter_buildercat_id,
    node.builtdate AS meter_builtdate,
    node.ownercat_id AS meter_ownercat_id,
    node.adress_01 AS meter_adress_01,
    node.adress_02 AS meter_adress_02,
    node.adress_03 AS meter_adress_03,
    node.descript AS meter_descript,
    cat_node.svg AS cat_svg,
    node.rotation AS meter_rotation,
    node.link AS meter_link,
    node.label_x AS meter_label_x,
    node.label_y AS meter_label_y,
    node.label_rotation AS meter_label_rotation,
    node.verified,
    node.the_geom,
    node.undelete
   FROM node
     LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
     LEFT JOIN dma ON node.dma_id::text = dma.dma_id::text
     JOIN man_meter ON man_meter.node_id::text = node.node_id::text;

	 
DROP VIEW IF EXISTS v_edit_man_pump CASCADE;
CREATE OR REPLACE VIEW v_edit_man_pump AS 
 SELECT node.node_id,
    node.elevation AS pump_elevation,
    node.depth AS pump_depth,
    node.node_type,
    node.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    cat_node.pnom AS cat_pnom,
    cat_node.dnom AS cat_dnom,
    node.epa_type,
    node.sector_id,
    node.state AS pump_state,
    node.annotation AS pump_annotation,
    node.observ AS pump_observ,
    node.comment AS pump_comment,
    node.dma_id,
    dma.presszonecat_id,
    node.soilcat_id AS pump_soilcat_id,
    node.category_type AS pump_category_type,
    node.fluid_type AS pump_fluid_type,
    node.location_type AS pump_location_type,
    node.workcat_id AS pump_workcat_id,
    node.workcat_id_end AS pump_workcat_id_end,
    node.buildercat_id AS pump_buildercat_id,
    node.builtdate AS pump_builtdate,
    node.ownercat_id AS pump_ownercat_id,
    node.adress_01 AS pump_adress_01,
    node.adress_02 AS pump_adress_02,
    node.adress_03 AS pump_adress_03,
    node.descript AS pump_descript,
    cat_node.svg AS cat_svg,
    node.rotation AS pump_rotation,
    node.label_x AS pump_label_x,
    node.label_y AS pump_label_y,
    node.label_rotation AS pump_label_rotation,
    node.link AS pump_link,
    node.verified,
    node.the_geom,
    node.undelete
   FROM node
     LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
     LEFT JOIN dma ON node.dma_id::text = dma.dma_id::text
     JOIN man_pump ON man_pump.node_id::text = node.node_id::text;

	
	
DROP VIEW IF EXISTS v_edit_man_reduction CASCADE;
CREATE OR REPLACE VIEW v_edit_man_reduction AS 
 SELECT node.node_id,
    node.elevation AS reduction_elevation,
    node.depth AS reduction_depth,
    node.node_type,
    node.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    cat_node.pnom AS cat_pnom,
    cat_node.dnom AS cat_dnom,
    node.epa_type,
    node.sector_id,
    node.state AS reduction_state,
    node.annotation AS reduction_annotation,
    node.observ AS reduction_observ,
    node.comment AS reduction_comment,
    node.dma_id,
    dma.presszonecat_id,
    node.soilcat_id AS reduction_soilcat_id,
    node.category_type AS reduction_category_type,
    node.fluid_type AS reduction_fluid_type,
    node.location_type AS reduction_location_type,
    node.workcat_id AS reduction_workcat_id,
    node.workcat_id_end AS reduction_workcat_id_end,
    node.buildercat_id AS reduction_buildercat_id,
    node.builtdate AS reduction_builtdate,
    node.ownercat_id AS reduction_ownercat_id,
    node.adress_01 AS reduction_adress_01,
    node.adress_02 AS reduction_adress_02,
    node.adress_03 AS reduction_adress_03,
    node.descript AS reduction_descript,
    cat_node.svg AS cat_svg,
    node.rotation AS reduction_rotation,
    node.link AS reduction_link,
    node.verified,
    node.the_geom,
    node.undelete,
    node.label_x AS reduction_label_x,
    node.label_y AS reduction_label_y,
    node.label_rotation AS reduction_label_rotation,
    man_reduction.diam_initial AS reduction_diam_initial,
    man_reduction.diam_final AS reduction_diam_final
   FROM node
     LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
     LEFT JOIN dma ON node.dma_id::text = dma.dma_id::text
     JOIN man_reduction ON man_reduction.node_id::text = node.node_id::text;
	 


DROP VIEW IF EXISTS v_edit_man_source CASCADE;
CREATE OR REPLACE VIEW v_edit_man_source AS 
 SELECT node.node_id,
    node.elevation AS source_elevation,
    node.depth AS source_depth,
    node.node_type,
    node.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    cat_node.pnom AS cat_pnom,
    cat_node.dnom AS cat_dnom,
    node.epa_type,
    node.sector_id,
    node.state AS source_state,
    node.annotation AS source_annotation,
    node.observ AS source_observ,
    node.comment AS source_comment,
    node.dma_id,
    dma.presszonecat_id,
    node.soilcat_id AS source_soilcat_id,
    node.category_type AS source_category_type,
    node.fluid_type AS source_fluid_type,
    node.location_type AS source_location_type,
    node.workcat_id AS source_workcat_id,
    node.workcat_id_end AS source_workcat_id_end,
    node.buildercat_id AS source_buildercat_id,
    node.builtdate AS source_builtdate,
    node.ownercat_id AS source_ownercat_id,
    node.adress_01 AS source_adress_01,
    node.adress_02 AS source_adress_02,
    node.adress_03 AS source_adress_03,
    node.descript AS source_descript,
    cat_node.svg AS cat_svg,
    node.rotation AS source_rotation,
    node.link AS source_link,
    node.verified,
    node.the_geom,
    node.undelete,
    node.label_x AS source_label_x,
    node.label_y AS source_label_y,
    node.label_rotation AS source_label_rotation
   FROM node
     LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
     LEFT JOIN dma ON node.dma_id::text = dma.dma_id::text
     JOIN man_source ON node.node_id::text = man_source.node_id::text;

	 
	 
DROP VIEW IF EXISTS v_edit_man_tank CASCADE;
CREATE OR REPLACE VIEW v_edit_man_tank AS 
 SELECT node.node_id,
    node.elevation AS tank_elevation,
    node.depth AS tank_depth,
    node.node_type,
    node.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    cat_node.pnom AS cat_pnom,
    cat_node.dnom AS cat_dnom,
    node.epa_type,
    node.sector_id,
    node.state AS tank_state,
    node.annotation AS tank_annotation,
    node.observ AS tank_observ,
    node.comment AS tank_comment,
    node.dma_id,
    dma.presszonecat_id,
    node.soilcat_id AS tank_soilcat_id,
    node.category_type AS tank_category_type,
    node.fluid_type AS tank_fluid_type,
    node.location_type AS tank_location_type,
    node.workcat_id AS tank_workcat_id,
    node.workcat_id_end AS tank_workcat_id_end,
    node.buildercat_id AS tank_buildercat_id,
    node.builtdate AS tank_builtdate,
    node.ownercat_id AS tank_ownercat_id,
    node.adress_01 AS tank_adress_01,
    node.adress_02 AS tank_adress_02,
    node.adress_03 AS tank_adress_03,
    node.descript AS tank_descript,
    cat_node.svg AS tank_cat_svg,
    node.rotation AS tank_rotation,
    node.link AS tank_link,
    node.verified,
    node.the_geom,
    node.undelete,
    node.label_x AS tank_label_x,
    node.label_y AS tank_label_y,
    node.label_rotation AS tank_label_rotation,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    man_tank.vmax AS tank_vmax,
    man_tank.area AS tank_area,
    man_tank.add_info AS tank_add_info,
    man_tank.chlorination AS tank_chlorination,
    man_tank.function AS tank_function
   FROM node
     LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
     LEFT JOIN dma ON node.dma_id::text = dma.dma_id::text
     JOIN man_tank ON man_tank.node_id::text = node.node_id::text
     LEFT JOIN inp_tank ON inp_tank.node_id::text = man_tank.node_id::text;

	 
	 
DROP VIEW IF EXISTS v_edit_man_valve CASCADE;
CREATE OR REPLACE VIEW v_edit_man_valve AS 
 SELECT node.node_id,
    node.elevation AS valve_elevation,
    node.depth AS valve_depth,
    node.node_type,
    node.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    cat_node.pnom AS cat_pnom,
    cat_node.dnom AS cat_dnom,
    node.epa_type,
    node.sector_id,
    node.state AS valve_state,
    node.annotation AS valve_annotation,
    node.observ AS valve_observ,
    node.comment AS valve_comment,
    node.dma_id,
    dma.presszonecat_id,
    node.soilcat_id AS valve_soilcat_id,
    node.category_type AS valve_category_type,
    node.fluid_type AS valve_fluid_type,
    node.location_type AS valve_location_type,
    node.workcat_id AS valve_workcat_id,
    node.workcat_id_end AS valve_workcat_id_end,
    node.buildercat_id AS valve_buildercat_id,
    node.builtdate AS valve_builtdate,
    node.ownercat_id AS valve_ownercat_id,
    node.adress_01 AS valve_adress_01,
    node.adress_02 AS valve_adress_02,
    node.adress_03 AS valve_adress_03,
    node.descript AS valve_descript,
    cat_node.svg AS cat_svg,
    node.rotation AS valve_rotation,
    node.link AS valve_link,
    node.verified,
    node.the_geom,
    node.undelete,
    node.label_x AS valve_label_x,
    node.label_y AS valve_label_y,
    node.label_rotation AS valve_label_rotation,
    man_valve.type AS valve_type,
    man_valve.opened AS valve_opened,
    man_valve.acessibility AS valve_acessibility,
    man_valve.broken AS valve_broken,
    man_valve.mincut_anl AS valve_mincut_anl,
    man_valve.hydraulic_anl AS valve_hydraulic_anl,
    man_valve.burried AS valve_burried,
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
    man_valve.valve AS valve_valve,
    man_valve.valve_diam AS valve_valve_diam,
    man_valve.drive_type AS valve_drive_type,
    man_valve.location AS valve_location
   FROM node
     LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
     LEFT JOIN dma ON node.dma_id::text = dma.dma_id::text
     JOIN man_valve ON man_valve.node_id::text = node.node_id::text;


	 
DROP VIEW IF EXISTS v_edit_man_waterwell CASCADE;
CREATE OR REPLACE VIEW v_edit_man_waterwell AS 
 SELECT node.node_id,
    node.elevation AS waterwell_elevation,
    node.depth AS waterwell_depth,
    node.node_type,
    node.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    cat_node.pnom AS cat_pnom,
    cat_node.dnom AS cat_dnom,
    node.epa_type,
    node.sector_id,
    node.state AS waterwell_state,
    node.annotation AS waterwell_annotation,
    node.observ AS waterwell_observ,
    node.comment AS waterwell_comment,
    node.dma_id,
    dma.presszonecat_id,
    node.soilcat_id AS waterwell_soilcat_id,
    node.category_type AS waterwell_category_type,
    node.fluid_type AS waterwell_fluid_type,
    node.location_type AS waterwell_location_type,
    node.workcat_id AS waterwell_workcat_id,
    node.workcat_id_end AS waterwell_workcat_id_end,
    node.buildercat_id AS waterwell_buildercat_id,
    node.builtdate AS waterwell_builtdate,
    node.ownercat_id AS waterwell_ownercat_id,
    node.adress_01 AS waterwell_adress_01,
    node.adress_02 AS waterwell_adress_02,
    node.adress_03 AS waterwell_adress_03,
    node.descript AS waterwell_descript,
    cat_node.svg AS cat_svg,
    node.rotation AS waterwell_rotation,
    node.link AS waterwell_link,
    node.verified,
    node.the_geom,
    node.undelete,
    node.label_x AS waterwell_label_x,
    node.label_y AS waterwell_label_y,
    node.label_rotation AS waterwell_label_rotation
   FROM node
     LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
     LEFT JOIN dma ON node.dma_id::text = dma.dma_id::text
     JOIN man_waterwell ON node.node_id::text = man_waterwell.node_id::text;

	 
	
DROP VIEW IF EXISTS v_edit_man_wjoin CASCADE;
CREATE OR REPLACE VIEW v_edit_man_wjoin AS 
 SELECT connec.connec_id,
    connec.elevation AS wjoin_elevation,
    connec.depth AS wjoin_depth,
    connec.connecat_id,
    cat_connec.type AS cat_connectype_id,
    cat_connec.matcat_id AS cat_matcat_id,
    cat_connec.pnom AS cat_pnom,
    cat_connec.dnom AS cat_dnom,
    connec.sector_id,
    connec.code AS wjoin_code,
    v_rtc_hydrometer_x_connec.n_hydrometer AS wjoin_n_hydrometer,
    connec.demand AS wjoin_demand,
    connec.state AS wjoin_state,
    connec.annotation AS wjoin_annotation,
    connec.observ AS wjoin_observ,
    connec.comment AS wjoin_comment,
    connec.dma_id,
    dma.presszonecat_id,
    connec.soilcat_id AS wjoin_soilcat_id,
    connec.category_type AS wjoin_category_type,
    connec.fluid_type AS wjoin_fluid_type,
    connec.location_type AS wjoin_location_type,
    connec.workcat_id AS wjoin_workcat_id,
    connec.workcat_id_end AS wjoin_workcat_id_end,
    connec.buildercat_id AS wjoin_buildercat_id,
    connec.builtdate AS wjoin_builtdate,
    connec.ownercat_id AS wjoin_ownercat_id,
    connec.adress_01 AS wjoin_adress_01,
    connec.adress_02 AS wjoin_adress_02,
    connec.adress_03 AS wjoin_adress_03,
    connec.streetaxis_id AS wjoin_streetaxis_id,
    ext_streetaxis.name AS wjoin_streetname,
    connec.postnumber AS wjoin_postnumber,
    connec.descript AS wjoin_descript,
    vnode.arc_id,
    cat_connec.svg AS cat_svg,
    connec.rotation AS wjoin_rotation,
    connec.label_x AS wjoin_label_x,
    connec.label_y AS wjoin_label_y,
    connec.label_rotation AS wjoin_label_rotation,
    connec.link AS wjoin_link,
    connec.verified,
    connec.the_geom,
    man_wjoin.length AS wjoin_length,
    man_wjoin.top_floor AS wjoin_top_floor,
    man_wjoin.lead_verified AS wjoin_lead_verified,
    man_wjoin.lead_facade AS wjoin_lead_facade
   FROM connec
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id::text = v_rtc_hydrometer_x_connec.connec_id::text
     LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN link ON connec.connec_id::text = link.connec_id::text
     LEFT JOIN vnode ON vnode.vnode_id::text = link.vnode_id::text
     LEFT JOIN dma ON connec.dma_id::text = dma.dma_id::text
     JOIN man_wjoin ON man_wjoin.connec_id::text = connec.connec_id::text;

	 
	 
DROP VIEW IF EXISTS v_edit_man_tap CASCADE;
CREATE OR REPLACE VIEW v_edit_man_tap AS 
 SELECT connec.connec_id,
    connec.elevation AS tap_elevation,
    connec.depth AS tap_depth,
    connec.connecat_id,
    cat_connec.type AS cat_connectype_id,
    cat_connec.matcat_id AS cat_matcat_id,
    cat_connec.pnom AS cat_pnom,
    cat_connec.dnom AS cat_dnom,
    connec.sector_id,
    connec.code AS tap_code,
    v_rtc_hydrometer_x_connec.n_hydrometer AS tap_n_hydrometer,
    connec.demand AS tap_demand,
    connec.state AS tap_state,
    connec.annotation AS tap_annotation,
    connec.observ AS tap_observ,
    connec.comment AS tap_comment,
    connec.dma_id,
    dma.presszonecat_id,
    connec.soilcat_id AS tap_soilcat_id,
    connec.category_type AS tap_category_type,
    connec.fluid_type AS tap_fluid_type,
    connec.location_type AS tap_location_type,
    connec.workcat_id AS tap_workcat_id,
    connec.workcat_id_end AS tap_workcat_id_end,
    connec.buildercat_id AS tap_buildercat_id,
    connec.builtdate AS tap_builtdate,
    connec.ownercat_id AS tap_ownercat_id,
    connec.adress_01 AS tap_adress_01,
    connec.adress_02 AS tap_adress_02,
    connec.adress_03 AS tap_adress_03,
    connec.streetaxis_id AS tap_streetaxis_id,
    ext_streetaxis.name AS tap_streetname,
    connec.postnumber AS tap_postnumber,
    connec.descript AS tap_descript,
    vnode.arc_id,
    cat_connec.svg AS cat_svg,
    connec.rotation AS tap_rotation,
    connec.label_x AS tap_label_x,
    connec.label_y AS tap_label_y,
    connec.label_rotation AS tap_label_rotation,
    connec.link AS tap_link,
    connec.verified,
    connec.the_geom,
    man_tap.type AS tap_type,
    man_tap.connection AS tap_connection,
    man_tap.continous AS tap_continous,
    man_tap.shutvalve_type AS tap_shutvalve_type,
    man_tap.shutvalve_diam AS tap_shutvalve_diam,
    man_tap.shutvalve_number AS tap_shutvalve_number,
    man_tap.drain_diam AS tap_drain_diam,
    man_tap.drain_exit AS tap_drain_exit,
    man_tap.drain_gully AS tap_drain_gully,
    man_tap.drain_distance AS tap_drain_distance,
    man_tap.arquitect_patrimony AS tap_arquitect_patrimony,
    man_tap.communication AS tap_communication
   FROM connec
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id::text = v_rtc_hydrometer_x_connec.connec_id::text
     LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN link ON connec.connec_id::text = link.connec_id::text
     LEFT JOIN vnode ON vnode.vnode_id::text = link.vnode_id::text
     LEFT JOIN dma ON connec.dma_id::text = dma.dma_id::text
     JOIN man_tap ON man_tap.connec_id::text = connec.connec_id::text;

	 
	 
DROP VIEW IF EXISTS v_edit_man_fountain CASCADE;
CREATE OR REPLACE VIEW v_edit_man_fountain AS 
 SELECT connec.connec_id,
    connec.elevation AS fountain_elevation,
    connec.depth AS fountain_depth,
    connec.connecat_id,
    cat_connec.type AS cat_connectype_id,
    cat_connec.matcat_id AS cat_matcat_id,
    cat_connec.pnom AS cat_pnom,
    cat_connec.dnom AS cat_dnom,
    connec.sector_id,
    connec.code AS fountain_code,
    v_rtc_hydrometer_x_connec.n_hydrometer AS fountain_n_hydrometer,
    connec.demand AS fountain_demand,
    connec.state AS fountain_state,
    connec.annotation AS fountain_annotation,
    connec.observ AS fountain_observ,
    connec.comment AS fountain_comment,
    connec.dma_id,
    dma.presszonecat_id,
    connec.soilcat_id AS fountain_soilcat_id,
    connec.category_type AS fountain_category_type,
    connec.fluid_type AS fountain_fluid_type,
    connec.location_type AS fountain_location_type,
    connec.workcat_id AS fountain_workcat_id,
    connec.workcat_id_end AS fountain_workcat_id_end,
    connec.buildercat_id AS fountain_buildercat_id,
    connec.builtdate AS fountain_builtdate,
    connec.ownercat_id AS fountain_ownercat_id,
    connec.adress_01 AS fountain_adress_01,
    connec.adress_02 AS fountain_adress_02,
    connec.adress_03 AS fountain_adress_03,
    connec.streetaxis_id AS fountain_streetaxis_id,
    ext_streetaxis.name AS fountain_streetname,
    connec.postnumber AS fountain_postnumber,
    connec.descript AS fountain_descript,
    vnode.arc_id,
    cat_connec.svg AS cat_svg,
    connec.rotation AS fountain_rotation,
    connec.label_x AS fountain_label_x,
    connec.label_y AS fountain_label_y,
    connec.label_rotation AS fountain_label_rotation,
    connec.link AS fountain_link,
    connec.verified,
    connec.the_geom,
    man_fountain.vmax AS fountain_vmax,
    man_fountain.vtotal AS fountain_vtotal,
    man_fountain.container_number AS fountain_container_number,
    man_fountain.pump_number AS fountain_pump_number,
    man_fountain.power AS fountain_power,
    man_fountain.regulation_tank AS fountain_regulation_tank,
    man_fountain.name AS fountain_name,
    man_fountain.connection AS fountain_connection,
    man_fountain.chlorinator AS fountain_chlorinator
   FROM connec
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id::text = v_rtc_hydrometer_x_connec.connec_id::text
     LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN link ON connec.connec_id::text = link.connec_id::text
     LEFT JOIN vnode ON vnode.vnode_id::text = link.vnode_id::text
     LEFT JOIN dma ON connec.dma_id::text = dma.dma_id::text
     JOIN man_fountain ON man_fountain.connec_id::text = connec.connec_id::text;


	 
DROP VIEW IF EXISTS v_edit_man_greentap CASCADE;
CREATE OR REPLACE VIEW v_edit_man_greentap AS 
 SELECT connec.connec_id,
    connec.elevation AS greentap_elevation,
    connec.depth AS greentap_depth,
    connec.connecat_id,
    cat_connec.type AS cat_connectype_id,
    cat_connec.matcat_id AS cat_matcat_id,
    cat_connec.pnom AS cat_pnom,
    cat_connec.dnom AS cat_dnom,
    connec.sector_id,
    connec.code AS greentap_code,
    v_rtc_hydrometer_x_connec.n_hydrometer AS greentap_n_hydrometer,
    connec.demand AS greentap_demand,
    connec.state AS greentap_state,
    connec.annotation AS greentap_annotation,
    connec.observ AS greentap_observ,
    connec.comment AS greentap_comment,
    connec.dma_id,
    dma.presszonecat_id,
    connec.soilcat_id AS greentap_soilcat_id,
    connec.category_type AS greentap_category_type,
    connec.fluid_type AS greentap_fluid_type,
    connec.location_type AS greentap_location_type,
    connec.workcat_id AS greentap_workcat_id,
    connec.workcat_id_end AS greentap_workcat_id_end,
    connec.buildercat_id AS greentap_buildercat_id,
    connec.builtdate AS greentap_builtdate,
    connec.ownercat_id AS greentap_ownercat_id,
    connec.adress_01 AS greentap_adress_01,
    connec.adress_02 AS greentap_adress_02,
    connec.adress_03 AS greentap_adress_03,
    connec.streetaxis_id AS greentap_streetaxis_id,
    ext_streetaxis.name AS greentap_streetname,
    connec.postnumber AS greentap_postnumber,
    connec.descript AS greentap_descript,
    vnode.arc_id,
    cat_connec.svg AS cat_svg,
    connec.rotation AS greentap_rotation,
    connec.label_x AS greentap_label_x,
    connec.label_y AS greentap_label_y,
    connec.label_rotation AS greentap_label_rotation,
    connec.link AS greentap_link,
    connec.verified,
    connec.the_geom
   FROM connec
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id::text = v_rtc_hydrometer_x_connec.connec_id::text
     LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN link ON connec.connec_id::text = link.connec_id::text
     LEFT JOIN vnode ON vnode.vnode_id::text = link.vnode_id::text
     LEFT JOIN dma ON connec.dma_id::text = dma.dma_id::text
     JOIN man_greentap ON man_greentap.connec_id::text = connec.connec_id::text;
