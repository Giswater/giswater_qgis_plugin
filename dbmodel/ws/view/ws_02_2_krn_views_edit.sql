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
node_id, 
code,
elevation, 
depth, 
nodetype_id AS cat_nodetype_id,
nodecat_id,
cat_matcat_id,
cat_pnom, 
cat_dnom,
epa_type,
sector_id, 
state, 
state_type,
annotation, 
observ, 
comment,
dma_id,
presszonecat_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
buildercat_id,
workcat_id_end,
builtdate,
enddate,
ownercat_id,
address_01,
address_02,
address_03,
descript,
cat_svg,
rotation,
link,
verified,
the_geom,
undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
macrodma_id,
expl_id,
hemisphere,
num_value
FROM v_node;


DROP VIEW IF EXISTS v_edit_arc CASCADE;
CREATE OR REPLACE VIEW v_edit_arc AS
SELECT 
arc_id,
code,
node_1,
node_2,
arccat_id, 
arctype_id AS "cat_arctype_id",
matcat_id AS "cat_matcat_id",
pnom AS "cat_pnom",
dnom AS "cat_dnom",
epa_type,
sector_id, 
state, 
state_type,
annotation, 
observ, 
comment,
gis_length,
custom_length,
dma_id,
presszonecat_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
address_01,
address_02,
address_03,
descript,
link,
verified,
the_geom,
undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
macrodma_id,
expl_id,
num_value
FROM v_arc;

DROP VIEW IF EXISTS v_edit_man_pipe CASCADE;
CREATE OR REPLACE VIEW v_edit_man_pipe AS
SELECT 
v_arc.arc_id,
code AS pipe_code,
node_1 AS pipe_node_1,
node_2 AS pipe_node_2,
arccat_id, 
arctype_id AS "cat_arctype_id",
matcat_id AS "pipe_matcat_id",
pnom AS "pipe_cat_pnom",
dnom AS "pipe_cat_dnom",
epa_type,
sector_id, 
state,
state_type,
annotation AS pipe_annotation, 
observ AS pipe_observ, 
"comment" AS pipe_comment,
gis_length AS pipe_gis_length,
custom_length AS pipe_custom_length,
dma_id,
presszonecat_id,
soilcat_id AS pipe_soilcat_id,
function_type AS pipe_function_type,
category_type AS pipe_category_type,
fluid_type AS pipe_fluid_type,
location_type AS pipe_location_type,
workcat_id AS pipe_workcat_id,
workcat_id_end AS pipe_workcat_id_end,
buildercat_id AS pipe_buildercat_id,
builtdate AS pipe_builtdate,
enddate AS pipe_enddate,
ownercat_id AS pipe_ownercat_id,
address_01 AS pipe_address_01,
address_02 AS pipe_address_02,
address_03 AS pipe_address_03,
descript AS pipe_descript,
link AS pipe_link,
verified,
the_geom,
undelete,
label_x AS pipe_label_x,
label_y AS pipe_label_y,
label_rotation AS pipe_label_rotation,
publish,
inventory,
macrodma_id,
expl_id,
num_value AS pipe_num_value
FROM v_arc
	JOIN man_pipe ON man_pipe.arc_id=v_arc.arc_id;



DROP VIEW IF EXISTS v_edit_man_varc CASCADE;
CREATE OR REPLACE VIEW v_edit_man_varc AS
SELECT 
v_arc.arc_id,
code AS varc_code,
node_1 AS varc_node_1,
node_2 AS varc_node_2,
arccat_id, 
arctype_id AS "cat_arctype_id",
matcat_id AS "varc_matcat_id",
pnom  AS "varc_cat_pnom",
pnom  AS "varc_cat_dnom",
epa_type,
sector_id, 
state,
state_type,
annotation AS varc_annotation, 
observ AS varc_observ, 
comment AS varc_comment,
gis_length AS varc_gis_length,
custom_length AS varc_custom_length,
dma_id,
presszonecat_id,
soilcat_id AS varc_soilcat_id,
function_type AS varc_function_type,
category_type AS varc_category_type,
fluid_type AS varc_fluid_type,
location_type AS varc_location_type,
workcat_id AS varc_workcat_id,
workcat_id_end AS varc_workcat_id_end,
buildercat_id AS varc_buildercat_id,
builtdate AS varc_builtdate,
enddate AS varc_enddate,
ownercat_id AS varc_ownercat_id,
address_01 AS varc_address_01,
address_02 AS varc_address_02,
address_03 AS varc_address_03,
descript AS varc_descript,
link AS varc_link,
verified,
the_geom,
undelete,
label_x AS varc_label_x,
label_y AS varc_label_y,
label_rotation AS varc_label_rotation,
publish,
inventory,
macrodma_id,
expl_id,
num_value AS varc_num_value
FROM v_arc 
	JOIN man_varc ON man_varc.arc_id=v_arc.arc_id;


DROP VIEW IF EXISTS v_edit_man_hydrant CASCADE;
CREATE OR REPLACE VIEW v_edit_man_hydrant AS 
SELECT 
v_node.node_id,
code AS hydrant_code,
elevation AS hydrant_elevation,
depth AS hydrant_depth,
nodetype_id,
nodecat_id,
cat_matcat_id AS hydrant_cat_matcat_id,
cat_pnom AS hydrant_cat_pnom,
cat_dnom AS hydrant_cat_dnom,
epa_type,
sector_id,
state,
state_type,
annotation AS hydrant_annotation,
observ AS hydrant_observ,
comment AS hydrant_comment,
dma_id,
presszonecat_id,
soilcat_id AS hydrant_soilcat_id,
function_type AS hydrant_function_type,
category_type AS hydrant_category_type,
fluid_type AS hydrant_fluid_type,
location_type AS hydrant_location_type,
workcat_id AS hydrant_workcat_id,
workcat_id_end AS hydrant_workcat_id_end,
buildercat_id AS hydrant_buildercat_id,
builtdate AS hydrant_builtdate,
enddate AS hydrant_enddate,
ownercat_id AS hydrant_ownercat_id,
address_01 AS hydrant_address_01,
address_02 AS hydrant_address_02,
address_03 AS hydrant_address_03,
descript AS hydrant_descript,
cat_svg AS hydrant_cat_svg,
rotation AS hydrant_rotation,
link AS hydrant_link,
verified,
the_geom,
undelete,
label_x AS hydrant_label_x,
label_y AS hydrant_label_y,
label_rotation AS hydrant_label_rotation,
publish,
inventory,
macrodma_id,
expl_id,
num_value AS hydrant_num_value,
hemisphere AS hydrant_hemisphere,
man_hydrant.fire_code AS hydrant_fire_code,
man_hydrant.communication AS hydrant_communication,
man_hydrant.valve AS hydrant_valve,
man_hydrant.valve_diam AS hydrant_valve_diam
FROM v_node
    JOIN man_hydrant ON man_hydrant.node_id = v_node.node_id;  

	
	 
DROP VIEW IF EXISTS v_edit_man_junction CASCADE;
CREATE OR REPLACE VIEW v_edit_man_junction AS 
SELECT 
v_node.node_id,
code AS junction_code,
elevation AS junction_elevation,
depth AS junction_depth,
nodetype_id,
nodecat_id,
cat_matcat_id AS junction_cat_matcat_id,
cat_pnom AS junction_cat_pnom,
cat_dnom AS junction_cat_dnom,
epa_type,
sector_id,
"state",
state_type,
annotation AS junction_annotation,
observ AS junction_observ,
comment AS junction_comment,
dma_id,
presszonecat_id,
soilcat_id AS junction_soilcat_id,
function_type AS junction_function_type,
category_type AS junction_category_type,
fluid_type AS junction_fluid_type,
location_type AS junction_location_type,
workcat_id AS junction_workcat_id,
workcat_id_end AS junction_workcat_id_end,
buildercat_id AS junction_buildercat_id,
builtdate AS junction_builtdate,
enddate AS junction_enddate,
ownercat_id AS junction_ownercat_id,
address_01 AS junction_address_01,
address_02 AS junction_address_02,
address_03 AS junction_address_03,
descript AS junction_descript,
cat_svg AS junction_cat_svg,
rotation AS junction_rotation,
label_x AS junction_label_x,
label_y AS junction_label_y,
label_rotation AS junction_label_rotation,
link AS junction_link,
verified,
the_geom,
undelete,
publish,
inventory,
macrodma_id,
expl_id,
hemisphere as junction_hemisphere,
num_value as junction_num_value
FROM v_node
	JOIN man_junction ON v_node.node_id = man_junction.node_id;

  

	 
DROP VIEW IF EXISTS v_edit_man_manhole CASCADE;
CREATE OR REPLACE VIEW v_edit_man_manhole AS 
SELECT 
v_node.node_id,
code AS manhole_code,
elevation AS manhole_elevation,
depth AS manhole_depth,
nodetype_id,
nodecat_id,
cat_matcat_id AS manhole_cat_matcat_id,
cat_pnom AS manhole_cat_pnom,
cat_dnom AS manhole_cat_dnom,
epa_type,
sector_id,
state,
state_type,
annotation AS manhole_annotation,
observ AS manhole_observ,
comment AS manhole_comment,
dma_id,
presszonecat_id,
soilcat_id AS manhole_soilcat_id,
function_type AS manhole_function_type,
category_type AS manhole_category_type,
fluid_type AS manhole_fluid_type,
location_type AS manhole_location_type,
workcat_id AS manhole_workcat_id,
workcat_id_end AS manhole_workcat_id_end,
buildercat_id AS manhole_buildercat_id,
builtdate AS manhole_builtdate,
enddate AS manhole_enddate,
ownercat_id AS manhole_ownercat_id,
address_01 AS manhole_address_01,
address_02 AS manhole_address_02,
address_03 AS manhole_address_03,
descript AS manhole_descript,
cat_svg AS manhole_cat_svg,
rotation AS manhole_rotation,
label_x AS manhole_label_x,
label_y AS manhole_label_y,
label_rotation AS manhole_label_rotation,
link AS manhole_link,
verified,
the_geom,
undelete,
publish,
inventory,
macrodma_id,
expl_id,
hemisphere as manhole_hemisphere,
num_value as manhole_num_value,
man_manhole.name as manhole_name
FROM v_node
	JOIN man_manhole ON v_node.node_id = man_manhole.node_id;



DROP VIEW IF EXISTS v_edit_man_meter CASCADE;
CREATE OR REPLACE VIEW v_edit_man_meter AS 
SELECT 
v_node.node_id,
code AS meter_code,
elevation AS meter_elevation,
depth AS meter_depth,
nodetype_id,
nodecat_id,
cat_matcat_id AS meter_cat_matcat_id,
cat_pnom AS meter_cat_pnom,
cat_dnom AS meter_cat_dnom,
epa_type,
sector_id,
state,
state_type,
annotation AS meter_annotation,
observ AS meter_observ,
comment AS meter_comment,
dma_id,
presszonecat_id,
soilcat_id AS meter_soilcat_id,
function_type AS meter_function_type,
category_type AS meter_category_type,
fluid_type AS meter_fluid_type,
location_type AS meter_location_type,
workcat_id AS meter_workcat_id,
workcat_id_end AS meter_workcat_id_end,
buildercat_id AS meter_buildercat_id,
builtdate AS meter_builtdate,
enddate AS meter_enddate,
ownercat_id AS meter_ownercat_id,
address_01 AS meter_address_01,
address_02 AS meter_address_02,
address_03 AS meter_address_03,
descript AS meter_descript,
cat_svg AS meter_cat_svg,
rotation AS meter_rotation,
link AS meter_link,
label_x AS meter_label_x,
label_y AS meter_label_y,
label_rotation AS meter_label_rotation,
verified,
the_geom,
undelete,
publish,
inventory,
macrodma_id,
expl_id,
hemisphere as meter_hemisphere,
num_value as meter_num_value
FROM v_node 
	JOIN man_meter ON man_meter.node_id = v_node.node_id;

	
	 
DROP VIEW IF EXISTS v_edit_man_pump CASCADE;
CREATE OR REPLACE VIEW v_edit_man_pump AS 
SELECT 
v_node.node_id,
code AS pump_code,
elevation AS pump_elevation,
depth AS pump_depth,
nodetype_id,
nodecat_id,
cat_matcat_id AS pump_cat_matcat_id,
cat_pnom AS pump_cat_pnom,
cat_dnom AS pump_cat_dnom,
epa_type,
sector_id,
state,
state_type,
annotation AS pump_annotation,
observ AS pump_observ,
comment AS pump_comment,
dma_id,
presszonecat_id,
soilcat_id AS pump_soilcat_id,
function_type AS pump_function_type,
category_type AS pump_category_type,
fluid_type AS pump_fluid_type,
location_type AS pump_location_type,
workcat_id AS pump_workcat_id,
workcat_id_end AS pump_workcat_id_end,
buildercat_id AS pump_buildercat_id,
builtdate AS pump_builtdate,
enddate AS pump_enddate,
ownercat_id AS pump_ownercat_id,
address_01 AS pump_address_01,
address_02 AS pump_address_02,
address_03 AS pump_address_03,
descript AS pump_descript,
cat_svg AS pump_cat_svg,
rotation AS pump_rotation,
label_x AS pump_label_x,
label_y AS pump_label_y,
label_rotation AS pump_label_rotation,
link AS pump_link,
verified,
the_geom,
undelete,
publish,
inventory,
macrodma_id,
expl_id,
hemisphere as pump_hemisphere,
num_value as pump_num_value,
man_pump.max_flow AS pump_max_flow,
man_pump.min_flow AS pump_min_flow,
man_pump.nom_flow AS pump_nom_flow,
man_pump."power" AS pump_power,
man_pump.pressure AS pump_pressure,
man_pump.elev_height AS pump_elev_height,
man_pump.name AS pump_name
FROM v_node
	JOIN man_pump ON man_pump.node_id = v_node.node_id;

	
	
DROP VIEW IF EXISTS v_edit_man_reduction CASCADE;
CREATE OR REPLACE VIEW v_edit_man_reduction AS 
SELECT 
v_node.node_id,
code AS reduction_code,
elevation AS reduction_elevation,
depth AS reduction_depth,
nodetype_id,
nodecat_id,
cat_matcat_id AS reduction_cat_matcat_id,
cat_pnom AS reduction_cat_pnom,
cat_dnom AS reduction_cat_dnom,
epa_type,
sector_id,
state,
state_type,
annotation AS reduction_annotation,
observ AS reduction_observ,
comment AS reduction_comment,
dma_id,
presszonecat_id,
soilcat_id AS reduction_soilcat_id,
function_type AS reduction_function_type,
category_type AS reduction_category_type,
fluid_type AS reduction_fluid_type,
location_type AS reduction_location_type,
workcat_id AS reduction_workcat_id,
workcat_id_end AS reduction_workcat_id_end,
buildercat_id AS reduction_buildercat_id,
builtdate AS reduction_builtdate,
enddate AS reduction_enddate,
ownercat_id AS reduction_ownercat_id,
address_01 AS reduction_address_01,
address_02 AS reduction_address_02,
address_03 AS reduction_address_03,
descript AS reduction_descript,
cat_svg AS reduction_cat_svg,
rotation AS reduction_rotation,
link AS reduction_link,
verified,
the_geom,
undelete,
label_x AS reduction_label_x,
label_y AS reduction_label_y,
label_rotation AS reduction_label_rotation,
publish,
inventory,
macrodma_id,
expl_id,
hemisphere as reduction_hemisphere,
num_value as reduction_num_value,
man_reduction.diam1 AS reduction_diam1,
man_reduction.diam2 AS reduction_diam2
FROM v_node 
	JOIN man_reduction ON man_reduction.node_id = v_node.node_id;
	


DROP VIEW IF EXISTS v_edit_man_source CASCADE;
CREATE OR REPLACE VIEW v_edit_man_source AS 
SELECT 
v_node.node_id,
code AS source_code,
elevation AS source_elevation,
depth AS source_depth,
nodetype_id,
nodecat_id,
cat_matcat_id AS source_cat_matcat_id,
cat_pnom AS source_cat_pnom,
cat_dnom AS source_cat_dnom,
epa_type,
sector_id,
state,
state_type,
annotation AS source_annotation,
observ AS source_observ,
comment AS source_comment,
dma_id,
presszonecat_id,
soilcat_id AS source_soilcat_id,
function_type AS source_function_type,
category_type AS source_category_type,
fluid_type AS source_fluid_type,
location_type AS source_location_type,
workcat_id AS source_workcat_id,
workcat_id_end AS source_workcat_id_end,
buildercat_id AS source_buildercat_id,
builtdate AS source_builtdate,
enddate AS source_enddate,
ownercat_id AS source_ownercat_id,
address_01 AS source_address_01,
address_02 AS source_address_02,
address_03 AS source_address_03,
descript AS source_descript,
cat_svg AS source_cat_svg,
rotation AS source_rotation,
link AS source_link,
verified,
the_geom,
undelete,
label_x AS source_label_x,
label_y AS source_label_y,
label_rotation AS source_label_rotation,
publish,
inventory,
macrodma_id,
expl_id,
hemisphere AS source_hemisphere,
num_value as source_num_value,
man_source.name AS source_name
FROM v_node
	JOIN man_source ON v_node.node_id = man_source.node_id;
 
	 
DROP VIEW IF EXISTS v_edit_man_valve CASCADE;
CREATE OR REPLACE VIEW v_edit_man_valve AS 
SELECT 
v_node.node_id,
code AS valve_code,
elevation AS valve_elevation,
depth AS valve_depth,
nodetype_id,
nodecat_id,
cat_matcat_id AS valve_cat_matcat_id,
cat_pnom AS valve_cat_pnom,
cat_dnom AS valve_cat_dnom,
epa_type,
sector_id,
state,
state_type,
annotation AS valve_annotation,
observ AS valve_observ,
comment AS valve_comment,
dma_id,
presszonecat_id,
soilcat_id AS valve_soilcat_id,
function_type AS valve_function_type,
category_type AS valve_category_type,
fluid_type AS valve_fluid_type,
location_type AS valve_location_type,
workcat_id AS valve_workcat_id,
workcat_id_end AS valve_workcat_id_end,
buildercat_id AS valve_buildercat_id,
builtdate AS valve_builtdate,
enddate AS valve_enddate,
ownercat_id AS valve_ownercat_id,
address_01 AS valve_address_01,
address_02 AS valve_address_02,
address_03 AS valve_address_03,
descript AS valve_descript,
cat_svg AS valve_cat_svg,
rotation AS valve_rotation,
link AS valve_link,
verified,
the_geom,
undelete,
label_x AS valve_label_x,
label_y AS valve_label_y,
label_rotation AS valve_label_rotation,
publish,
inventory,
macrodma_id,
expl_id,
hemisphere as valve_hemisphere,
num_value as valve_num_value,
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
FROM v_node
	JOIN man_valve ON man_valve.node_id = v_node.node_id;

	 
DROP VIEW IF EXISTS v_edit_man_waterwell CASCADE;
CREATE OR REPLACE VIEW v_edit_man_waterwell AS 
SELECT
v_node.node_id,
code AS waterwell_code,
elevation AS waterwell_elevation,
depth AS waterwell_depth,
nodetype_id,
nodecat_id,
cat_matcat_id AS waterwell_cat_matcat_id,
cat_pnom AS waterwell_cat_pnom,
cat_dnom AS waterwell_cat_dnom,
epa_type,
sector_id,
state,
state_type,
annotation AS waterwell_annotation,
observ AS waterwell_observ,
comment AS waterwell_comment,
dma_id,
presszonecat_id,
soilcat_id AS waterwell_soilcat_id,
function_type AS waterwell_function_type,
category_type AS waterwell_category_type,
fluid_type AS waterwell_fluid_type,
location_type AS waterwell_location_type,
workcat_id AS waterwell_workcat_id,
workcat_id_end AS waterwell_workcat_id_end,
buildercat_id AS waterwell_buildercat_id,
builtdate AS waterwell_builtdate,
enddate AS waterwell_enddate, 
ownercat_id AS waterwell_ownercat_id,
address_01 AS waterwell_address_01,
address_02 AS waterwell_address_02,
address_03 AS waterwell_address_03,
descript AS waterwell_descript,
cat_svg AS waterwell_cat_svg,
rotation AS waterwell_rotation,
link AS waterwell_link,
verified,
the_geom,
undelete,
label_x AS waterwell_label_x,
label_y AS waterwell_label_y,
label_rotation AS waterwell_label_rotation,
publish,
inventory,
macrodma_id,
expl_id,
hemisphere as waterwell_hemisphere,
num_value as waterwell_num_value,
man_waterwell.name AS waterwell_name
FROM v_node
	JOIN man_waterwell ON v_node.node_id = man_waterwell.node_id;
	
   
DROP VIEW IF EXISTS v_edit_man_tank CASCADE;
CREATE OR REPLACE VIEW v_edit_man_tank AS 
SELECT 
v_node.node_id,
code AS tank_code,
elevation AS tank_elevation,
depth AS tank_depth,
nodetype_id,
nodecat_id,
cat_matcat_id AS tank_cat_matcat_id,
cat_pnom AS tank_cat_pnom,
cat_dnom AS tank_cat_dnom,
epa_type,
sector_id,
state,
state_type,
annotation AS tank_annotation,
observ AS tank_observ,
comment AS tank_comment,
dma_id,
presszonecat_id,
soilcat_id AS tank_soilcat_id,
function_type AS tank_function_type,
category_type AS tank_category_type,
fluid_type AS tank_fluid_type,
location_type AS tank_location_type,
workcat_id AS tank_workcat_id,
workcat_id_end AS tank_workcat_id_end,
buildercat_id AS tank_buildercat_id,
builtdate AS tank_builtdate,
enddate AS tank_enddate,
ownercat_id AS tank_ownercat_id,
address_01 AS tank_address_01,
address_02 AS tank_address_02,
address_03 AS tank_address_03,
descript AS tank_descript,
cat_svg AS tank_cat_svg,
rotation AS tank_rotation,
link AS tank_link,
verified,
the_geom,
undelete,
label_x AS tank_label_x,
label_y AS tank_label_y,
label_rotation AS tank_label_rotation,
publish,
inventory,
macrodma_id,
expl_id,
hemisphere as tank_hemisphere,
num_value as tank_num_value,
man_tank.pol_id AS tank_pol_id,
man_tank.vmax AS tank_vmax,
man_tank.vutil AS tank_vutil,
man_tank.area AS tank_area,
man_tank.chlorination AS tank_chlorination,
man_tank.name AS tank_name
FROM v_node
	JOIN man_tank ON man_tank.node_id = v_node.node_id;
	
	
DROP VIEW IF EXISTS v_edit_man_tank_pol CASCADE;
CREATE OR REPLACE VIEW v_edit_man_tank_pol AS 
SELECT 
v_node.node_id,
code AS tank_code,
elevation AS tank_elevation,
depth AS tank_depth,
nodetype_id,
nodecat_id,
cat_matcat_id AS tank_cat_matcat_id,
cat_pnom AS tank_cat_pnom,
cat_dnom AS tank_cat_dnom,
epa_type,
sector_id,
state,
state_type,
annotation AS tank_annotation,
observ AS tank_observ,
comment AS tank_comment,
dma_id,
presszonecat_id,
soilcat_id AS tank_soilcat_id,
function_type AS tank_function_type,
category_type AS tank_category_type,
fluid_type AS tank_fluid_type,
location_type AS tank_location_type,
workcat_id AS tank_workcat_id,
workcat_id_end AS tank_workcat_id_end,
buildercat_id AS tank_buildercat_id,
builtdate AS tank_builtdate,
enddate AS tank_enddate,
ownercat_id AS tank_ownercat_id,
address_01 AS tank_address_01,
address_02 AS tank_address_02,
address_03 AS tank_address_03,
descript AS tank_descript,
cat_svg AS tank_cat_svg,
rotation AS tank_rotation,
link AS tank_link,
verified,
polygon.the_geom,
v_node.undelete,
label_x AS tank_label_x,
label_y AS tank_label_y,
label_rotation AS tank_label_rotation,
publish,
inventory,
macrodma_id,
expl_id,
hemisphere as tank_hemisphere,
num_value as tank_num_value,
man_tank.pol_id AS tank_pol_id,
man_tank.vmax AS tank_vmax,
man_tank.vutil AS tank_vutil,
man_tank.area AS tank_area,
man_tank.chlorination AS tank_chlorination,
man_tank.name AS tank_name
FROM v_node
	JOIN man_tank ON man_tank.node_id = v_node.node_id
	JOIN polygon ON polygon.pol_id=man_tank.pol_id;
	

DROP VIEW IF EXISTS v_edit_man_filter CASCADE;
CREATE OR REPLACE VIEW v_edit_man_filter AS 
SELECT
v_node.node_id,
code AS filter_code,
elevation AS filter_elevation,
depth AS filter_depth,
nodetype_id,
nodecat_id,
cat_matcat_id AS filter_cat_matcat_id,
cat_pnom AS filter_cat_pnom,
cat_dnom AS filter_cat_dnom,
epa_type,
sector_id,
state,
state_type,
annotation AS filter_annotation,
observ AS filter_observ,
comment AS filter_comment,
dma_id,
presszonecat_id,
soilcat_id AS filter_soilcat_id,
function_type AS filter_function_type,
category_type AS filter_category_type,
fluid_type AS filter_fluid_type,
location_type AS filter_location_type,
workcat_id AS filter_workcat_id,
workcat_id_end AS filter_workcat_id_end,
buildercat_id AS filter_buildercat_id,
builtdate AS filter_builtdate,
enddate AS filter_enddate,
ownercat_id AS filter_ownercat_id,
address_01 AS filter_address_01,
address_02 AS filter_address_02,
address_03 AS filter_address_03,
descript AS filter_descript,
cat_svg AS filter_cat_svg,
rotation AS filter_rotation,
label_x AS filter_label_x,
label_y AS filter_label_y,
label_rotation AS filter_label_rotation,
link AS filter_link,
verified,
the_geom,
undelete,
publish,
inventory,
macrodma_id,
expl_id,
hemisphere as filter_hemisphere,
num_value as filter_num_value
FROM v_node
	JOIN man_filter ON v_node.node_id = man_filter.node_id;
	
	
DROP VIEW IF EXISTS v_edit_man_register CASCADE;
CREATE OR REPLACE VIEW v_edit_man_register AS 
SELECT 
v_node.node_id,
code AS register_code,
elevation AS register_elevation,
depth AS register_depth,
nodetype_id,
nodecat_id,
cat_matcat_id AS register_cat_matcat_id,
cat_pnom AS register_cat_pnom,
cat_dnom AS register_cat_dnom,
epa_type,
sector_id,
state,
state_type,
annotation AS register_annotation,
observ AS register_observ,
comment AS register_comment,
dma_id,
presszonecat_id,
soilcat_id AS register_soilcat_id,
function_type AS register_function_type,
category_type AS register_category_type,
fluid_type AS register_fluid_type,
location_type AS register_location_type,
workcat_id AS register_workcat_id,
workcat_id_end AS register_workcat_id_end,
buildercat_id AS register_buildercat_id,
builtdate AS register_builtdate,
enddate AS register_enddate,
ownercat_id AS register_ownercat_id,
address_01 AS register_address_01,
address_02 AS register_address_02,
address_03 AS register_address_03,
descript AS register_descript,
cat_svg AS register_cat_svg,
rotation AS register_rotation,
link AS register_link,
verified,
the_geom,
undelete,
label_x AS register_label_x,
label_y AS register_label_y,
label_rotation AS register_label_rotation,
publish,
inventory,
macrodma_id,
expl_id,
hemisphere as register_hemisphere,
num_value as register_num_value,
man_register.pol_id AS register_pol_id
FROM v_node
	JOIN man_register ON v_node.node_id = man_register.node_id;
	

	
DROP VIEW IF EXISTS v_edit_man_register_pol CASCADE;
CREATE OR REPLACE VIEW v_edit_man_register_pol AS 
SELECT 
v_node.node_id,
code AS register_code,
elevation AS register_elevation,
depth AS register_depth,
nodetype_id,
nodecat_id,
cat_matcat_id AS register_cat_matcat_id,
cat_pnom AS register_cat_pnom,
cat_dnom AS register_cat_dnom,
epa_type,
sector_id,
state,
state_type,
annotation AS register_annotation,
observ AS register_observ,
comment AS register_comment,
dma_id,
presszonecat_id,
soilcat_id AS register_soilcat_id,
function_type AS register_function_type,
category_type AS register_category_type,
fluid_type AS register_fluid_type,
location_type AS register_location_type,
workcat_id AS register_workcat_id,
workcat_id_end AS register_workcat_id_end,
buildercat_id AS register_buildercat_id,
builtdate AS register_builtdate,
enddate AS register_enddate,
ownercat_id AS register_ownercat_id,
address_01 AS register_address_01,
address_02 AS register_address_02,
address_03 AS register_address_03,
descript AS register_descript,
cat_svg AS register_cat_svg,
rotation AS register_rotation,
link AS register_link,
verified,
polygon.the_geom,
v_node.undelete,
label_x AS register_label_x,
label_y AS register_label_y,
label_rotation AS register_label_rotation,
publish,
inventory,
macrodma_id,
expl_id,
hemisphere as register_hemisphere,
num_value as register_num_value,
man_register.pol_id AS register_pol_id
FROM v_node
	JOIN man_register ON v_node.node_id = man_register.node_id
	JOIN polygon ON polygon.pol_id = man_register.pol_id;
	
	
DROP VIEW IF EXISTS v_edit_man_netwjoin CASCADE;
CREATE OR REPLACE VIEW v_edit_man_netwjoin AS 
SELECT 
v_node.node_id,
code AS netwjoin_code,
elevation AS netwjoin_elevation,
depth AS netwjoin_depth,
nodetype_id,
nodecat_id,
cat_matcat_id AS netwjoin_cat_matcat_id,
cat_pnom AS netwjoin_cat_pnom,
cat_dnom AS netwjoin_cat_dnom,
epa_type,
sector_id,
state,
state_type,
annotation AS netwjoin_annotation,
observ AS netwjoin_observ,
comment AS netwjoin_comment,
dma_id,
presszonecat_id,
soilcat_id AS netwjoin_soilcat_id,
function_type AS netwjoin_function_type,
category_type AS netwjoin_category_type,
fluid_type AS netwjoin_fluid_type,
location_type AS netwjoin_location_type,
workcat_id AS netwjoin_workcat_id,
workcat_id_end AS netwjoin_workcat_id_end,
buildercat_id AS netwjoin_buildercat_id,
builtdate AS netwjoin_builtdate,
enddate AS netwjoin_enddate,
ownercat_id AS netwjoin_ownercat_id,
address_01 AS netwjoin_address_01,
address_02 AS netwjoin_address_02,
address_03 AS netwjoin_address_03,
descript AS netwjoin_descript,
cat_svg AS netwjoin_cat_svg,
rotation AS netwjoin_rotation,
link AS netwjoin_link,
verified,
v_node.the_geom,
undelete,
label_x AS netwjoin_label_x,
label_y AS netwjoin_label_y,
label_rotation AS netwjoin_label_rotation,
publish,
inventory,
macrodma_id,
v_node.expl_id,
hemisphere as netwjoin_hemisphere,
num_value as netwjoin_num_value,
man_netwjoin.customer_code as netwjoin_customer_code,
man_netwjoin.muni_id as netwjoin_muni_id,
man_netwjoin.streetaxis_id as netwjoin_streetaxis_id,
man_netwjoin.postnumber AS netwjoin_postnumber,
man_netwjoin.top_floor AS netwjoin_top_floor,
man_netwjoin.cat_valve AS netwjoin_cat_valve
FROM v_node
	JOIN man_netwjoin ON v_node.node_id = man_netwjoin.node_id
	LEFT JOIN ext_streetaxis ON man_netwjoin.streetaxis_id=ext_streetaxis.id;
	
	
DROP VIEW IF EXISTS v_edit_man_flexunion CASCADE;
CREATE OR REPLACE VIEW v_edit_man_flexunion AS 
SELECT 
v_node.node_id,
code AS flexunion_code,
elevation AS flexunion_elevation,
depth AS flexunion_depth,
nodetype_id,
nodecat_id,
cat_matcat_id AS flexunion_cat_matcat_id,
cat_pnom AS flexunion_cat_pnom,
cat_dnom AS flexunion_cat_dnom,
epa_type,
sector_id,
state,
state_type,
annotation AS flexunion_annotation,
observ AS flexunion_observ,
comment AS flexunion_comment,
dma_id,
presszonecat_id,
soilcat_id AS flexunion_soilcat_id,
function_type AS flexunion_function_type,
category_type AS flexunion_category_type,
fluid_type AS flexunion_fluid_type,
location_type AS flexunion_location_type,
workcat_id AS flexunion_workcat_id,
workcat_id_end AS flexunion_workcat_id_end,
buildercat_id AS flexunion_buildercat_id,
builtdate AS flexunion_builtdate,
enddate AS flexunion_enddate,
ownercat_id AS flexunion_ownercat_id,
address_01 AS flexunion_address_01,
address_02 AS flexunion_address_02,
address_03 AS flexunion_address_03,
descript AS flexunion_descript,
cat_svg AS flexunion_cat_svg,
rotation AS flexunion_rotation,
link AS flexunion_link,
verified,
the_geom,
undelete,
label_x AS flexunion_label_x,
label_y AS flexunion_label_y,
label_rotation AS flexunion_label_rotation,
publish,
inventory,
macrodma_id,
expl_id,
hemisphere as flexunion_hemisphere,
num_value as flexunion_num_value
FROM v_node
	JOIN man_flexunion ON v_node.node_id = man_flexunion.node_id;
	
	
DROP VIEW IF EXISTS v_edit_man_wtp CASCADE;
CREATE OR REPLACE VIEW v_edit_man_wtp AS 
SELECT 
v_node.node_id,
code AS wtp_code,
elevation AS wtp_elevation,
depth AS wtp_depth,
nodetype_id,
nodecat_id,
cat_matcat_id AS wtp_cat_matcat_id,
cat_pnom AS wtp_cat_pnom,
cat_dnom AS wtp_cat_dnom,
epa_type,
sector_id,
state,
state_type,
annotation AS wtp_annotation,
observ AS wtp_observ,
comment AS wtp_comment,
dma_id,
presszonecat_id,
soilcat_id AS wtp_soilcat_id,
function_type AS wtp_function_type,
category_type AS wtp_category_type,
fluid_type AS wtp_fluid_type,
location_type AS wtp_location_type,
workcat_id AS wtp_workcat_id,
workcat_id_end AS wtp_workcat_id_end,
buildercat_id AS wtp_buildercat_id,
builtdate AS wtp_builtdate,
enddate AS wtp_enddate,
ownercat_id AS wtp_ownercat_id,
address_01 AS wtp_address_01,
address_02 AS wtp_address_02,
address_03 AS wtp_address_03,
descript AS wtp_descript,
cat_svg AS wtp_cat_svg,
rotation AS wtp_rotation,
link AS wtp_link,
verified,
the_geom,
undelete,
label_x AS wtp_label_x,
label_y AS wtp_label_y,
label_rotation AS wtp_label_rotation,
publish,
inventory,
macrodma_id,
expl_id,
hemisphere as wtp_hemisphere,
num_value as wtp_num_value,
man_wtp.name AS wtp_name
FROM v_node
	JOIN man_wtp ON v_node.node_id = man_wtp.node_id;
	
	
DROP VIEW IF EXISTS v_edit_man_expansiontank CASCADE;
CREATE OR REPLACE VIEW v_edit_man_expansiontank AS 
SELECT 
v_node.node_id,
code AS exptank_code,
elevation AS exptank_elevation,
depth AS exptank_depth,
nodetype_id,
nodecat_id,
cat_matcat_id AS exptank_cat_matcat_id,
cat_pnom AS exptank_cat_pnom,
cat_dnom AS exptank_cat_dnom,
epa_type,
sector_id,
state,
state_type,
annotation AS exptank_annotation,
observ AS exptank_observ,
comment AS exptank_comment,
dma_id,
presszonecat_id,
soilcat_id AS exptank_soilcat_id,
function_type AS exptank_function_type,
category_type AS exptank_category_type,
fluid_type AS exptank_fluid_type,
location_type AS exptank_location_type,
workcat_id AS exptank_workcat_id,
workcat_id_end AS exptank_workcat_id_end,
buildercat_id AS exptank_buildercat_id,
builtdate AS exptank_builtdate,
enddate AS exptank_enddate,
ownercat_id AS exptank_ownercat_id,
address_01 AS exptank_address_01,
address_02 AS exptank_address_02,
address_03 AS exptank_address_03,
descript AS exptank_descript,
cat_svg AS exptank_cat_svg,
rotation AS exptank_rotation,
link AS exptank_link,
verified,
the_geom,
undelete,
label_x AS exptank_label_x,
label_y AS exptank_label_y,
label_rotation AS exptank_label_rotation,
publish,
inventory,
macrodma_id,
expl_id,
hemisphere as exptank_hemisphere,
num_value as exptank_num_value
FROM v_node
	JOIN man_expansiontank ON v_node.node_id = man_expansiontank .node_id;
	
	

DROP VIEW IF EXISTS v_edit_man_netsamplepoint CASCADE;
CREATE OR REPLACE VIEW v_edit_man_netsamplepoint AS 
SELECT 
v_node.node_id,
code AS netsample_code,
elevation AS netsample_elevation,
depth AS netsample_depth,
nodetype_id,
nodecat_id,
cat_matcat_id AS netsample_cat_matcat_id,
cat_pnom AS netsample_cat_pnom,
cat_dnom AS netsample_cat_dnom,
epa_type,
sector_id,
state,
state_type,
annotation AS netsample_annotation,
observ AS netsample_observ,
comment AS netsample_comment,
dma_id,
presszonecat_id,
soilcat_id AS netsample_soilcat_id,
function_type AS netsample_function_type,
category_type AS netsample_category_type,
fluid_type AS netsample_fluid_type,
location_type AS netsample_location_type,
workcat_id AS netsample_workcat_id,
workcat_id_end AS netsample_workcat_id_end,
buildercat_id AS netsample_buildercat_id,
builtdate AS netsample_builtdate,
enddate AS netsample_enddate,
ownercat_id AS netsample_ownercat_id,
address_01 AS netsample_address_01,
address_02 AS netsample_address_02,
address_03 AS netsample_address_03,
descript AS netsample_descript,
cat_svg AS netsample_cat_svg,
rotation AS netsample_rotation,
link AS netsample_link,
verified,
the_geom,
undelete,
label_x AS netsample_label_x,
label_y AS netsample_label_y,
label_rotation AS netsample_label_rotation,
publish,
inventory,
macrodma_id,
expl_id,
hemisphere as netsample_hemisphere,
num_value as netsample_num_value,
man_netsamplepoint.lab_code AS netsample_lab_code
FROM v_node
	JOIN man_netsamplepoint ON v_node.node_id = man_netsamplepoint .node_id;
	
	

DROP VIEW IF EXISTS v_edit_man_netelement CASCADE;
CREATE OR REPLACE VIEW v_edit_man_netelement AS 
SELECT 
v_node.node_id,
code AS netelement_code,
elevation AS netelement_elevation,
depth AS netelement_depth,
nodetype_id,
nodecat_id,
cat_matcat_id AS netelement_cat_matcat_id,
cat_pnom AS netelement_cat_pnom,
cat_dnom AS netelement_cat_dnom,
epa_type,
sector_id,
state,
state_type,
annotation AS netelement_annotation,
observ AS netelement_observ,
comment AS netelement_comment,
dma_id,
presszonecat_id,
soilcat_id AS netelement_soilcat_id,
function_type AS netelement_function_type,
category_type AS netelement_category_type,
fluid_type AS netelement_fluid_type,
location_type AS netelement_location_type,
workcat_id AS netelement_workcat_id,
workcat_id_end AS netelement_workcat_id_end,
buildercat_id AS netelement_buildercat_id,
builtdate AS netelement_builtdate,
enddate AS netelement_enddate,
ownercat_id AS netelement_ownercat_id,
address_01 AS netelement_address_01,
address_02 AS netelement_address_02,
address_03 AS netelement_address_03,
descript AS netelement_descript,
cat_svg AS netelement_cat_svg,
rotation AS netelement_rotation,
link AS netelement_link,
verified,
the_geom,
undelete,
label_x AS netelement_label_x,
label_y AS netelement_label_y,
label_rotation AS netelement_label_rotation,
publish,
inventory,
macrodma_id,
expl_id,
hemisphere as netelement_hemisphere,
num_value as netelement_num_value,
man_netelement.serial_number as netelement_serial_number
FROM v_node
	JOIN man_netelement ON v_node.node_id = man_netelement .node_id;
	

	
DROP  VIEW  IF EXISTS v_edit_link;
CREATE OR REPLACE VIEW v_edit_link AS 
 SELECT link.link_id,
    link.feature_type,
    link.feature_id,
    link.exit_type,
	link.exit_id,
        CASE
            WHEN link.feature_type::text = 'CONNEC'::text THEN connec.sector_id
            ELSE vnode.sector_id
        END AS sector_id,
        CASE
            WHEN link.feature_type::text = 'CONNEC'::text THEN connec.dma_id
            ELSE vnode.dma_id
        END AS dma_id,
        CASE
            WHEN link.feature_type::text = 'CONNEC'::text THEN connec.expl_id
            ELSE vnode.expl_id
        END AS expl_id,
	link.state,
    st_length2d(link.the_geom) AS gis_length,
    link.userdefined_geom,
    link.the_geom
   FROM selector_expl,
    selector_state,
    link
     LEFT JOIN connec ON link.feature_id::text = connec.connec_id::text AND link.feature_type::text = 'CONNEC'::text
     LEFT JOIN vnode ON link.feature_id::text = vnode.vnode_id::text AND link.feature_type::text = 'VNODE'::text
  WHERE connec.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND connec.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text OR vnode.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND vnode.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text;


  
DROP VIEW IF EXISTS v_edit_vnode CASCADE;
CREATE VIEW v_edit_vnode AS SELECT
vnode_id,
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



DROP VIEW IF EXISTS v_value_cat_connec CASCADE;
CREATE OR REPLACE VIEW v_value_cat_connec AS 
 SELECT cat_connec.id,
    cat_connec.connectype_id AS connec_type,
    connec_type.type
   FROM cat_connec
     JOIN connec_type ON connec_type.id::text = cat_connec.connectype_id::text;


 
DROP VIEW IF EXISTS v_value_cat_connec CASCADE;
CREATE OR REPLACE VIEW v_value_cat_connec AS 
 SELECT cat_node.id,
    cat_node.nodetype_id,
    node_type.type
   FROM cat_node
     JOIN node_type ON node_type.id::text = cat_node.nodetype_id::text;

