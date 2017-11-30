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
connec.connecat_id,
connec.sector_id,
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
connec.streetaxis2_id,
connec.postnumber2,
connec.descript,
connec.arc_id,
cat_connec.svg AS cat_svg,
connec.rotation,
concat(connec_type.link_path,connec.link),
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
	LEFT JOIN dma ON connec.dma_id = dma.dma_id;
	

DROP VIEW IF EXISTS v_edit_man_wjoin CASCADE;
CREATE OR REPLACE VIEW v_edit_man_wjoin AS 
SELECT 
connec.connec_id,
connec.code AS wj_code,
connec.elevation AS wj_elevation,
connec.depth AS wj_depth,
cat_connec.connectype_id,
connec.connecat_id,
cat_connec.matcat_id AS wj_cat_matcat_id,
cat_connec.pnom AS wj_cat_pnom,
cat_connec.dnom AS wj_cat_dnom,
connec.sector_id,
connec.customer_code AS wj_customer_code,
v_rtc_hydrometer_x_connec.n_hydrometer AS wj_n_hydrometer,
connec.state,
connec.state_type,
connec.annotation AS wj_annotation,
connec.observ AS wj_observ,
connec.comment AS wj_comment,
connec.dma_id,
connec.presszonecat_id,
connec.soilcat_id AS wj_soilcat_id,
connec.function_type AS wj_function_type,
connec.category_type AS wj_category_type,
connec.fluid_type AS wj_fluid_type,
connec.location_type AS wj_location_type,
connec.workcat_id AS wj_workcat_id,
connec.workcat_id_end AS wj_workcat_id_end,
connec.buildercat_id AS wj_buildercat_id,
connec.builtdate AS wj_builtdate,
connec.enddate AS wj_enddate,
connec.ownercat_id AS wj_ownercat_id,
connec.muni_id AS wj_muni_id,
connec.postcode AS wj_postcode,
connec.streetaxis_id AS wj_streetaxis_id,
connec.postnumber AS wj_postnumber,
connec.streetaxis2_id AS wj_streetaxis2_id,
connec.postnumber2 AS wj_postnumber2,
connec.descript AS wj_descript,
connec.arc_id,
cat_connec.svg AS wj_cat_svg,
connec.rotation AS wj_rotation,
connec.label_x AS wj_label_x,
connec.label_y AS wj_label_y,
connec.label_rotation AS wj_label_rotation,
concat(connec_type.link_path,connec.link) AS wj_link,
connec.connec_length AS wj_connec_length,
connec.verified,
connec.the_geom,
connec.undelete,
connec.publish,
connec.inventory,
dma.macrodma_id,
connec.expl_id,
connec.num_value as wj_num_value,
man_wjoin.top_floor AS wj_top_floor,
man_wjoin.cat_valve AS wj_cat_valve
FROM connec
	JOIN cat_connec ON connec.connecat_id = cat_connec.id
	JOIN connec_type ON connec_type.id=cat_connec.connectype_id
	JOIN v_state_connec ON v_state_connec.connec_id=connec.connec_id
	JOIN man_wjoin ON man_wjoin.connec_id = connec.connec_id
	LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id = v_rtc_hydrometer_x_connec.connec_id
	LEFT JOIN dma ON connec.dma_id = dma.dma_id;
	
	 
	 
DROP VIEW IF EXISTS v_edit_man_tap CASCADE;
CREATE OR REPLACE VIEW v_edit_man_tap AS 
SELECT
connec.connec_id,
connec.code AS tp_code,
connec.elevation AS tp_elevation,
connec.depth AS tp_depth,
cat_connec.connectype_id,
connec.connecat_id,
cat_connec.matcat_id AS tp_cat_matcat_id,
cat_connec.pnom AS tp_cat_pnom,
cat_connec.dnom AS tp_cat_dnom,
connec.sector_id,
connec.customer_code AS tp_customer_code,
v_rtc_hydrometer_x_connec.n_hydrometer AS tp_n_hydrometer,
connec.state,
connec.state_type,
connec.annotation AS tp_annotation,
connec.observ AS tp_observ,
connec.comment AS tp_comment,
connec.dma_id,
connec.presszonecat_id,
connec.soilcat_id AS tp_soilcat_id,
connec.function_type AS tp_function_type,
connec.category_type AS tp_category_type,
connec.fluid_type AS tp_fluid_type,
connec.location_type AS tp_location_type,
connec.workcat_id AS tp_workcat_id,
connec.workcat_id_end AS tp_workcat_id_end,
connec.buildercat_id AS tp_buildercat_id,
connec.builtdate AS tp_builtdate,
connec.enddate AS tp_enddate,
connec.ownercat_id AS tp_ownercat_id,
connec.muni_id AS tp_muni_id,
connec.postcode AS tp_postcode,
connec.streetaxis_id AS tp_streetaxis_id,
connec.postnumber AS tp_postnumber,
connec.streetaxis2_id AS tp_streetaxis2_id,
connec.postnumber2 AS tp_postnumber2,
connec.descript AS tp_descript,
connec.arc_id,
cat_connec.svg AS tp_cat_svg,
connec.rotation AS tp_rotation,
connec.label_x AS tp_label_x,
connec.label_y AS tp_label_y,
connec.label_rotation AS tp_label_rotation,
concat(connec_type.link_path,connec.link) AS tp_link,
connec.connec_length AS tp_connec_length,
connec.verified,
connec.the_geom,
connec.undelete,
connec.publish,
connec.inventory,
dma.macrodma_id,
connec.expl_id,
connec.num_value as tp_num_value,
man_tap.linked_connec AS tp_linked_connec,
man_tap.cat_valve AS tp_cat_valve,
man_tap.drain_diam AS tp_drain_diam,
man_tap.drain_exit AS tp_drain_exit,
man_tap.drain_gully AS tp_drain_gully,
man_tap.drain_distance AS tp_drain_distance,
man_tap.arq_patrimony AS tp_arq_patrimony,
man_tap.com_state AS tp_com_state
FROM connec
	JOIN cat_connec ON connec.connecat_id = cat_connec.id
	JOIN connec_type ON connec_type.id=cat_connec.connectype_id
	JOIN v_state_connec ON v_state_connec.connec_id=connec.connec_id
	LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id = v_rtc_hydrometer_x_connec.connec_id
	LEFT JOIN dma ON connec.dma_id = dma.dma_id
	JOIN man_tap ON man_tap.connec_id = connec.connec_id;
	
	 
	 
DROP VIEW IF EXISTS v_edit_man_fountain CASCADE;
CREATE OR REPLACE VIEW v_edit_man_fountain AS 
SELECT 
connec.connec_id,
connec.code AS fo_code,
connec.elevation AS fo_elevation,
connec.depth AS fo_depth,
cat_connec.connectype_id,
connec.connecat_id,
cat_connec.matcat_id AS fo_cat_matcat_id,
cat_connec.pnom AS fo_cat_pnom,
cat_connec.dnom AS fo_cat_dnom,
connec.sector_id,
connec.customer_code AS fo_customer_code,
v_rtc_hydrometer_x_connec.n_hydrometer AS fo_n_hydrometer,
connec.state,
connec.state_type,
connec.annotation AS fo_annotation,
connec.observ AS fo_observ,
connec.comment AS fo_comment,
connec.dma_id,
connec.presszonecat_id,
connec.soilcat_id AS fo_soilcat_id,
connec.function_type AS fo_function_type,
connec.category_type AS fo_category_type,
connec.fluid_type AS fo_fluid_type,
connec.location_type AS fo_location_type,
connec.workcat_id AS fo_workcat_id,
connec.workcat_id_end AS fo_workcat_id_end,
connec.buildercat_id AS fo_buildercat_id,
connec.builtdate AS fo_builtdate,
connec.enddate AS fo_enddate,
connec.ownercat_id AS fo_ownercat_id,
connec.muni_id AS fo_muni_id,
connec.postcode AS fo_postcode,
connec.streetaxis_id AS fo_streetaxis_id,
connec.postnumber AS fo_postnumber,
connec.streetaxis2_id AS fo_streetaxis2_id,
connec.postnumber2 AS fo_postnumber2,
connec.descript AS fo_descript,
connec.arc_id,
cat_connec.svg AS fo_cat_svg,
connec.rotation AS fo_rotation,
connec.label_x AS fo_label_x,
connec.label_y AS fo_label_y,
connec.label_rotation AS fo_label_rotation,
concat(connec_type.link_path,connec.link) AS fo_link,
connec.connec_length  as fo_connec_length,
connec.verified,
connec.the_geom,
connec.undelete,
connec.publish,
connec.inventory,
dma.macrodma_id,
connec.expl_id,
connec.num_value as fo_num_value,
man_fountain.pol_id AS fo_pol_id,
man_fountain.linked_connec AS fo_linked_connec,
man_fountain.vmax AS fo_vmax,
man_fountain.vtotal AS fo_vtotal,
man_fountain.container_number AS fo_container_number,
man_fountain.pump_number AS fo_pump_number,
man_fountain.power AS fo_power,
man_fountain.regulation_tank AS fo_regulation_tank,
man_fountain.chlorinator AS fo_chlorinator,
man_fountain.arq_patrimony AS fo_arq_patrimony,
man_fountain.name AS fo_name
FROM connec
	JOIN cat_connec ON connec.connecat_id = cat_connec.id
	JOIN connec_type ON connec_type.id=cat_connec.connectype_id
	JOIN v_state_connec ON v_state_connec.connec_id=connec.connec_id
	LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id = v_rtc_hydrometer_x_connec.connec_id
	LEFT JOIN dma ON connec.dma_id = dma.dma_id
	JOIN man_fountain ON man_fountain.connec_id = connec.connec_id;




 
DROP VIEW IF EXISTS v_edit_man_fountain_pol CASCADE;
CREATE OR REPLACE VIEW v_edit_man_fountain_pol AS 
SELECT 
connec.connec_id,
connec.code AS fo_code,
connec.elevation AS fo_elevation,
connec.depth AS fo_depth,
cat_connec.connectype_id,
connec.connecat_id,
cat_connec.matcat_id AS fo_cat_matcat_id,
cat_connec.pnom AS fo_cat_pnom,
cat_connec.dnom AS fo_cat_dnom,
connec.sector_id,
connec.customer_code AS fo_customer_code,
v_rtc_hydrometer_x_connec.n_hydrometer AS fo_n_hydrometer,
connec.state,
connec.state_type,
connec.annotation AS fo_annotation,
connec.observ AS fo_observ,
connec.comment AS fo_comment,
connec.dma_id,
connec.presszonecat_id,
connec.soilcat_id AS fo_soilcat_id,
connec.function_type AS fo_function_type,
connec.category_type AS fo_category_type,
connec.fluid_type AS fo_fluid_type,
connec.location_type AS fo_location_type,
connec.workcat_id AS fo_workcat_id,
connec.workcat_id_end AS fo_workcat_id_end,
connec.buildercat_id AS fo_buildercat_id,
connec.builtdate AS fo_builtdate,
connec.enddate AS fo_enddate,
connec.ownercat_id AS fo_ownercat_id,
connec.muni_id AS fo_muni_id,
connec.postcode AS fo_postcode,
connec.streetaxis_id AS fo_streetaxis_id,
connec.postnumber AS fo_postnumber,
connec.streetaxis2_id AS fo_streetaxis2_id,
connec.postnumber2 AS fo_postnumber2,
connec.descript AS fo_descript,
connec.arc_id,
cat_connec.svg AS fo_cat_svg,
connec.rotation AS fo_rotation,
connec.label_x AS fo_label_x,
connec.label_y AS fo_label_y,
connec.label_rotation AS fo_label_rotation,
concat(connec_type.link_path,connec.link) AS fo_link,
connec.connec_length as fo_connec_length,
connec.verified,
connec.undelete,
connec.publish,
connec.inventory,
dma.macrodma_id,
connec.expl_id,
connec.num_value as fo_num_value,
polygon.the_geom,
man_fountain.pol_id AS fo_pol_id,
man_fountain.linked_connec AS fo_linked_connec,
man_fountain.vmax AS fo_vmax,
man_fountain.vtotal AS fo_vtotal,
man_fountain.container_number AS fo_container_number,
man_fountain.pump_number AS fo_pump_number,
man_fountain.power AS fo_power,
man_fountain.regulation_tank AS fo_regulation_tank,
man_fountain.chlorinator AS fo_chlorinator,
man_fountain.arq_patrimony AS fo_arq_patrimony,
man_fountain.name AS fo_name
FROM connec
	JOIN cat_connec ON connec.connecat_id = cat_connec.id
	JOIN connec_type ON connec_type.id=cat_connec.connectype_id
	JOIN v_state_connec ON v_state_connec.connec_id=connec.connec_id
	LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id = v_rtc_hydrometer_x_connec.connec_id
	LEFT JOIN dma ON connec.dma_id = dma.dma_id
	JOIN man_fountain ON man_fountain.connec_id = connec.connec_id
	JOIN polygon ON polygon.pol_id=man_fountain.pol_id;

	 
DROP VIEW IF EXISTS v_edit_man_greentap CASCADE;
CREATE OR REPLACE VIEW v_edit_man_greentap AS 
SELECT 
connec.connec_id,
connec.code AS gr_code,
connec.elevation AS gr_elevation,
connec.depth AS gr_depth,
cat_connec.connectype_id,
connec.connecat_id,
cat_connec.matcat_id AS gr_cat_matcat_id,
cat_connec.pnom AS gr_cat_pnom,
cat_connec.dnom AS gr_cat_dnom,
connec.sector_id,
connec.customer_code AS gr_customer_code,
v_rtc_hydrometer_x_connec.n_hydrometer AS gr_n_hydrometer,
connec.state,
connec.state_type,
connec.annotation AS gr_annotation,
connec.observ AS gr_observ,
connec.comment AS gr_comment,
connec.dma_id,
connec.presszonecat_id,
connec.soilcat_id AS gr_soilcat_id,
connec.function_type AS gr_function_type,
connec.category_type AS gr_category_type,
connec.fluid_type AS gr_fluid_type,
connec.location_type AS gr_location_type,
connec.workcat_id AS gr_workcat_id,
connec.workcat_id_end AS gr_workcat_id_end,
connec.buildercat_id AS gr_buildercat_id,
connec.builtdate AS gr_builtdate,
connec.enddate AS gr_enddate,
connec.ownercat_id AS gr_ownercat_id,
connec.muni_id AS gr_muni_id,
connec.postcode AS gr_postcode,
connec.streetaxis_id AS gr_streetaxis_id,
connec.postnumber AS gr_postnumber,
connec.streetaxis2_id AS gr_streetaxis2_id,
connec.postnumber2 AS gr_postnumber2,
connec.descript AS gr_descript,
connec.arc_id,
cat_connec.svg AS gr_cat_svg,
connec.rotation AS gr_rotation,
connec.label_x AS gr_label_x,
connec.label_y AS gr_label_y,
connec.label_rotation AS gr_label_rotation,
concat(connec_type.link_path,connec.link) AS gr_link,
connec.connec_length AS gr_connec_length,
connec.verified,
connec.the_geom,
connec.undelete,
connec.publish,
connec.inventory,
dma.macrodma_id,
connec.expl_id,
connec.num_value as gr_num_value,
man_greentap.linked_connec AS gr_linked_connec
FROM connec
	JOIN cat_connec ON connec.connecat_id = cat_connec.id
	JOIN connec_type ON connec_type.id=cat_connec.connectype_id
	JOIN v_state_connec ON v_state_connec.connec_id=connec.connec_id
	LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id = v_rtc_hydrometer_x_connec.connec_id
	LEFT JOIN dma ON connec.dma_id = dma.dma_id
	JOIN man_greentap ON man_greentap.connec_id = connec.connec_id;


