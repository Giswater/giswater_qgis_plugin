/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
SET search_path = "SCHEMA_NAME", public, pg_catalog;


DROP VIEW IF EXISTS v_rtc_hydrometer_x_connec CASCADE;
CREATE OR REPLACE VIEW v_rtc_hydrometer_x_connec AS
SELECT 
connec_id,
count(hydrometer_id)::integer as n_hydrometer
FROM rtc_hydrometer_x_connec
group by connec_id;



DROP VIEW IF EXISTS v_edit_connec CASCADE;
CREATE OR REPLACE VIEW v_edit_connec AS 
SELECT 
connec.connec_id,
connec.code,
connec.elevation,
connec.depth,
cat_connec.connectype_id,
connec_type.type as sys_type,
connec.connecat_id,
connec.sector_id,
sector.macrosector_id,
connec.customer_code,
cat_connec.matcat_id AS cat_matcat_id,
cat_connec.pnom AS cat_pnom,
cat_connec.dnom AS cat_dnom,
connec_length,
v_rtc_hydrometer_x_connec.n_hydrometer,
connec.state,
connec.state_type,
connec.annotation,
connec.observ,
connec.comment,
connec.dma_id,
connec.presszonecat_id,
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
connec.muni_id ,
connec.postcode,
connec.streetaxis_id,
connec.postnumber,
connec.postcomplement,
connec.streetaxis2_id,
connec.postnumber2,
connec.postcomplement2,
connec.descript,
connec.arc_id,
cat_connec.svg AS svg,
connec.rotation,
concat(connec_type.link_path,connec.link) as link,
connec.verified,
connec.the_geom,
connec.undelete,
connec.label_x,
connec.label_y,
connec.label_rotation,
connec.publish,
connec.inventory,
dma.macrodma_id,
connec.expl_id,
connec.num_value
FROM  connec
	JOIN cat_connec ON connec.connecat_id = cat_connec.id
	JOIN connec_type ON connec_type.id=cat_connec.connectype_id
	JOIN v_state_connec ON v_state_connec.connec_id=connec.connec_id
	LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id = v_rtc_hydrometer_x_connec.connec_id
	LEFT JOIN ext_streetaxis ON connec.streetaxis_id = ext_streetaxis.id
	LEFT JOIN dma ON connec.dma_id = dma.dma_id
	LEFT JOIN sector ON connec.sector_id=sector.sector_id;
	

DROP VIEW IF EXISTS v_edit_man_wjoin CASCADE;
CREATE OR REPLACE VIEW v_edit_man_wjoin AS 
SELECT 
connec.connec_id,
connec.code ,
connec.elevation ,
connec.depth,
cat_connec.connectype_id,
connec.connecat_id,
cat_connec.matcat_id,
cat_connec.pnom,
cat_connec.dnom,
connec.sector_id,
sector.macrosector_id,
connec.customer_code,
v_rtc_hydrometer_x_connec.n_hydrometer,
connec.state,
connec.state_type,
connec.annotation,
connec.observ,
connec.comment,
connec.dma_id,
connec.presszonecat_id,
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
connec.muni_id,
connec.postcode,
connec.streetaxis_id,
connec.postnumber,
connec.postcomplement,
connec.streetaxis2_id,
connec.postnumber2,
connec.postcomplement2,
connec.descript,
connec.arc_id,
cat_connec.svg,
connec.rotation,
connec.label_x,
connec.label_y,
connec.label_rotation,
concat(connec_type.link_path,connec.link) AS link,
connec.connec_length,
connec.verified,
connec.the_geom,
connec.undelete,
connec.publish,
connec.inventory,
dma.macrodma_id,
connec.expl_id,
connec.num_value,
man_wjoin.top_floor,
man_wjoin.cat_valve
FROM connec
	JOIN cat_connec ON connec.connecat_id = cat_connec.id
	JOIN connec_type ON connec_type.id=cat_connec.connectype_id
	JOIN v_state_connec ON v_state_connec.connec_id=connec.connec_id
	JOIN man_wjoin ON man_wjoin.connec_id = connec.connec_id
	LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id = v_rtc_hydrometer_x_connec.connec_id
	LEFT JOIN dma ON connec.dma_id = dma.dma_id
	LEFT JOIN sector ON connec.sector_id=sector.sector_id;
	
	 
	 
DROP VIEW IF EXISTS v_edit_man_tap CASCADE;
CREATE OR REPLACE VIEW v_edit_man_tap AS 
SELECT
connec.connec_id,
connec.code,
connec.elevation,
connec.depth,
cat_connec.connectype_id,
connec.connecat_id,
cat_connec.matcat_id,
cat_connec.pnom,
cat_connec.dnom,
connec.sector_id,
sector.macrosector_id,
connec.customer_code,
v_rtc_hydrometer_x_connec.n_hydrometer,
connec.state,
connec.state_type,
connec.annotation,
connec.observ,
connec.comment,
connec.dma_id,
connec.presszonecat_id,
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
connec.muni_id,
connec.postcode,
connec.streetaxis_id,
connec.postnumber,
connec.postcomplement,
connec.streetaxis2_id,
connec.postnumber2,
connec.postcomplement2,
connec.descript,
connec.arc_id,
cat_connec.svg,
connec.rotation,
connec.label_x,
connec.label_y,
connec.label_rotation,
concat(connec_type.link_path,connec.link) as link,
connec.connec_length,
connec.verified,
connec.the_geom,
connec.undelete,
connec.publish,
connec.inventory,
dma.macrodma_id,
connec.expl_id,
connec.num_value,
man_tap.linked_connec,
man_tap.cat_valve,
man_tap.drain_diam,
man_tap.drain_exit,
man_tap.drain_gully,
man_tap.drain_distance,
man_tap.arq_patrimony,
man_tap.com_state
FROM connec
	JOIN cat_connec ON connec.connecat_id = cat_connec.id
	JOIN connec_type ON connec_type.id=cat_connec.connectype_id
	JOIN v_state_connec ON v_state_connec.connec_id=connec.connec_id
	LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id = v_rtc_hydrometer_x_connec.connec_id
	LEFT JOIN dma ON connec.dma_id = dma.dma_id
	LEFT JOIN sector ON connec.sector_id=sector.sector_id
	JOIN man_tap ON man_tap.connec_id = connec.connec_id;
	
	 
	 
DROP VIEW IF EXISTS v_edit_man_fountain CASCADE;
CREATE OR REPLACE VIEW v_edit_man_fountain AS 
SELECT 
connec.connec_id,
connec.code,
connec.elevation,
connec.depth,
cat_connec.connectype_id,
connec.connecat_id,
cat_connec.matcat_id,
cat_connec.pnom,
cat_connec.dnom,
connec.sector_id,
sector.macrosector_id,
connec.customer_code,
v_rtc_hydrometer_x_connec.n_hydrometer,
connec.state,
connec.state_type,
connec.annotation,
connec.observ,
connec.comment,
connec.dma_id,
connec.presszonecat_id,
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
connec.muni_id,
connec.postcode,
connec.streetaxis_id,
connec.postnumber,
connec.postcomplement,
connec.streetaxis2_id,
connec.postnumber2,
connec.postcomplement2,
connec.descript,
connec.arc_id,
cat_connec.svg,
connec.rotation,
connec.label_x,
connec.label_y,
connec.label_rotation,
concat(connec_type.link_path,connec.link) as link,
connec.connec_length ,
connec.verified,
connec.the_geom,
connec.undelete,
connec.publish,
connec.inventory,
dma.macrodma_id,
connec.expl_id,
connec.num_value,
man_fountain.pol_id,
man_fountain.linked_connec,
man_fountain.vmax,
man_fountain.vtotal,
man_fountain.container_number,
man_fountain.pump_number,
man_fountain.power,
man_fountain.regulation_tank,
man_fountain.chlorinator,
man_fountain.arq_patrimony,
man_fountain.name
FROM connec
	JOIN cat_connec ON connec.connecat_id = cat_connec.id
	JOIN connec_type ON connec_type.id=cat_connec.connectype_id
	JOIN v_state_connec ON v_state_connec.connec_id=connec.connec_id
	LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id = v_rtc_hydrometer_x_connec.connec_id
	LEFT JOIN dma ON connec.dma_id = dma.dma_id
	LEFT JOIN sector ON connec.sector_id=sector.sector_id
	JOIN man_fountain ON man_fountain.connec_id = connec.connec_id;




 
DROP VIEW IF EXISTS v_edit_man_fountain_pol CASCADE;
CREATE OR REPLACE VIEW v_edit_man_fountain_pol AS 
SELECT 
man_fountain.pol_id,
connec.connec_id,
polygon.the_geom
FROM connec
	JOIN man_fountain ON man_fountain.connec_id = connec.connec_id
	JOIN polygon ON polygon.pol_id=man_fountain.pol_id;

	
	 
DROP VIEW IF EXISTS v_edit_man_greentap CASCADE;
CREATE OR REPLACE VIEW v_edit_man_greentap AS 
SELECT 
connec.connec_id,
connec.code,
connec.elevation,
connec.depth,
cat_connec.connectype_id,
connec.connecat_id,
cat_connec.matcat_id,
cat_connec.pnom,
cat_connec.dnom,
connec.sector_id,
sector.macrosector_id,
connec.customer_code,
v_rtc_hydrometer_x_connec.n_hydrometer,
connec.state,
connec.state_type,
connec.annotation,
connec.observ,
connec.comment,
connec.dma_id,
connec.presszonecat_id,
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
connec.muni_id,
connec.postcode,
connec.streetaxis_id,
connec.postnumber,
connec.postcomplement,
connec.streetaxis2_id,
connec.postnumber2,
connec.postcomplement2,
connec.descript,
connec.arc_id,
cat_connec.svg,
connec.rotation,
connec.label_x,
connec.label_y,
connec.label_rotation,
concat(connec_type.link_path,connec.link) AS link,
connec.connec_length,
connec.verified,
connec.the_geom,
connec.undelete,
connec.publish,
connec.inventory,
dma.macrodma_id,
connec.expl_id,
connec.num_value,
man_greentap.linked_connec
FROM connec
	JOIN cat_connec ON connec.connecat_id = cat_connec.id
	JOIN connec_type ON connec_type.id=cat_connec.connectype_id
	JOIN v_state_connec ON v_state_connec.connec_id=connec.connec_id
	LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id = v_rtc_hydrometer_x_connec.connec_id
	LEFT JOIN dma ON connec.dma_id = dma.dma_id
	LEFT JOIN sector ON connec.sector_id=sector.sector_id
	JOIN man_greentap ON man_greentap.connec_id = connec.connec_id;


