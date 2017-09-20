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
connec_arccat_id,
connec_length,
v_rtc_hydrometer_x_connec.n_hydrometer,
connec.demand,
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
connec.address_01,
connec.address_02,
connec.address_03,
connec.streetaxis_id,
ext_streetaxis.name AS streetname,
connec.postnumber,
connec.descript,
vnode.arc_id,
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
FROM selector_expl, connec
	JOIN cat_connec ON connec.connecat_id = cat_connec.id
	JOIN connec_type ON connec_type.id=cat_connec.connectype_id
	LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id = v_rtc_hydrometer_x_connec.connec_id
	LEFT JOIN ext_streetaxis ON connec.streetaxis_id = ext_streetaxis.id
	LEFT JOIN link ON connec.connec_id = link.feature_id
	LEFT JOIN vnode ON vnode.vnode_id = link.vnode_id
	LEFT JOIN dma ON connec.dma_id = dma.dma_id
	WHERE ((connec.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());


DROP VIEW IF EXISTS v_edit_man_wjoin CASCADE;
CREATE OR REPLACE VIEW v_edit_man_wjoin AS 
SELECT 
connec.connec_id,
connec.code AS wjoin_code,
connec.elevation AS wjoin_elevation,
connec.depth AS wjoin_depth,
cat_connec.connectype_id,
connec.connecat_id,
cat_connec.matcat_id AS wjoin_cat_matcat_id,
cat_connec.pnom AS wjoin_cat_pnom,
cat_connec.dnom AS wjoin_cat_dnom,
connec.sector_id,
connec.customer_code AS wjoin_customer_code,
v_rtc_hydrometer_x_connec.n_hydrometer AS wjoin_n_hydrometer,
connec.demand AS wjoin_demand,
connec.state,
connec.state_type,
connec.annotation AS wjoin_annotation,
connec.observ AS wjoin_observ,
connec.comment AS wjoin_comment,
connec.dma_id,
connec.presszonecat_id,
connec.soilcat_id AS wjoin_soilcat_id,
connec.function_type AS wjoin_function_type,
connec.category_type AS wjoin_category_type,
connec.fluid_type AS wjoin_fluid_type,
connec.location_type AS wjoin_location_type,
connec.workcat_id AS wjoin_workcat_id,
connec.workcat_id_end AS wjoin_workcat_id_end,
connec.buildercat_id AS wjoin_buildercat_id,
connec.builtdate AS wjoin_builtdate,
connec.enddate AS wjoin_enddate,
connec.ownercat_id AS wjoin_ownercat_id,
connec.address_01 AS wjoin_address_01,
connec.address_02 AS wjoin_address_02,
connec.address_03 AS wjoin_address_03,
connec.streetaxis_id AS wjoin_streetaxis_id,
ext_streetaxis.name AS wjoin_streetname,
connec.postnumber AS wjoin_postnumber,
connec.descript AS wjoin_descript,
vnode.arc_id,
cat_connec.svg AS wjoin_cat_svg,
connec.rotation AS wjoin_rotation,
connec.label_x AS wjoin_label_x,
connec.label_y AS wjoin_label_y,
connec.label_rotation AS wjoin_label_rotation,
concat(connec_type.link_path,connec.link) AS wjoin_link,
connec.connec_length AS wjoin_connec_length,
connec.verified,
connec.the_geom,
connec.undelete,
connec.publish,
connec.inventory,
dma.macrodma_id,
connec.expl_id,
connec.num_value as wjoin_num_value,
man_wjoin.top_floor AS wjoin_top_floor,
man_wjoin.cat_valve AS wjoin_cat_valve
FROM selector_expl, connec
	JOIN cat_connec ON connec.connecat_id = cat_connec.id
	JOIN connec_type ON connec_type.id=cat_connec.connectype_id
	LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id = v_rtc_hydrometer_x_connec.connec_id
	LEFT JOIN ext_streetaxis ON connec.streetaxis_id = ext_streetaxis.id
	LEFT JOIN link ON connec.connec_id = link.feature_id
	LEFT JOIN vnode ON vnode.vnode_id = link.vnode_id
	LEFT JOIN dma ON connec.dma_id = dma.dma_id
	JOIN man_wjoin ON man_wjoin.connec_id = connec.connec_id
	WHERE ((connec.expl_id)=(selector_expl.expl_id)
 	AND selector_expl.cur_user="current_user"());

	 
	 
DROP VIEW IF EXISTS v_edit_man_tap CASCADE;
CREATE OR REPLACE VIEW v_edit_man_tap AS 
SELECT
connec.connec_id,
connec.code AS tap_code,
connec.elevation AS tap_elevation,
connec.depth AS tap_depth,
cat_connec.connectype_id,
connec.connecat_id,
cat_connec.matcat_id AS tap_cat_matcat_id,
cat_connec.pnom AS tap_cat_pnom,
cat_connec.dnom AS tap_cat_dnom,
connec.sector_id,
connec.customer_code AS tap_customer_code,
v_rtc_hydrometer_x_connec.n_hydrometer AS tap_n_hydrometer,
connec.demand AS tap_demand,
connec.state,
connec.state_type,
connec.annotation AS tap_annotation,
connec.observ AS tap_observ,
connec.comment AS tap_comment,
connec.dma_id,
connec.presszonecat_id,
connec.soilcat_id AS tap_soilcat_id,
connec.function_type AS tap_function_type,
connec.category_type AS tap_category_type,
connec.fluid_type AS tap_fluid_type,
connec.location_type AS tap_location_type,
connec.workcat_id AS tap_workcat_id,
connec.workcat_id_end AS tap_workcat_id_end,
connec.buildercat_id AS tap_buildercat_id,
connec.builtdate AS tap_builtdate,
connec.enddate AS tap_enddate,
connec.ownercat_id AS tap_ownercat_id,
connec.address_01 AS tap_address_01,
connec.address_02 AS tap_address_02,
connec.address_03 AS tap_address_03,
connec.streetaxis_id AS tap_streetaxis_id,
ext_streetaxis.name AS tap_streetname,
connec.postnumber AS tap_postnumber,
connec.descript AS tap_descript,
vnode.arc_id,
cat_connec.svg AS tap_cat_svg,
connec.rotation AS tap_rotation,
connec.label_x AS tap_label_x,
connec.label_y AS tap_label_y,
connec.label_rotation AS tap_label_rotation,
concat(connec_type.link_path,connec.link) AS tap_link,
connec.connec_length AS tap_connec_length,
connec.verified,
connec.the_geom,
connec.undelete,
connec.publish,
connec.inventory,
dma.macrodma_id,
connec.expl_id,
connec.num_value as tap_num_value,
man_tap.linked_connec AS tap_linked_connec,
man_tap.cat_valve AS tap_cat_valve,
man_tap.drain_diam AS tap_drain_diam,
man_tap.drain_exit AS tap_drain_exit,
man_tap.drain_gully AS tap_drain_gully,
man_tap.drain_distance AS tap_drain_distance,
man_tap.arq_patrimony AS tap_arq_patrimony,
man_tap.com_state AS tap_com_state
FROM selector_expl, connec
	JOIN cat_connec ON connec.connecat_id = cat_connec.id
	JOIN connec_type ON connec_type.id=cat_connec.connectype_id
	LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id = v_rtc_hydrometer_x_connec.connec_id
	LEFT JOIN ext_streetaxis ON connec.streetaxis_id = ext_streetaxis.id
	LEFT JOIN link ON connec.connec_id = link.feature_id
	LEFT JOIN vnode ON vnode.vnode_id = link.vnode_id
	LEFT JOIN dma ON connec.dma_id = dma.dma_id
	JOIN man_tap ON man_tap.connec_id = connec.connec_id
	WHERE ((connec.expl_id)=(selector_expl.expl_id)
 	AND selector_expl.cur_user="current_user"());

	 
	 
DROP VIEW IF EXISTS v_edit_man_fountain CASCADE;
CREATE OR REPLACE VIEW v_edit_man_fountain AS 
SELECT 
connec.connec_id,
connec.code AS fountain_code,
connec.elevation AS fountain_elevation,
connec.depth AS fountain_depth,
cat_connec.connectype_id,
connec.connecat_id,
cat_connec.matcat_id AS fountain_cat_matcat_id,
cat_connec.pnom AS fountain_cat_pnom,
cat_connec.dnom AS fountain_cat_dnom,
connec.sector_id,
connec.customer_code AS fountain_customer_code,
v_rtc_hydrometer_x_connec.n_hydrometer AS fountain_n_hydrometer,
connec.demand AS fountain_demand,
connec.state,
connec.state_type,
connec.annotation AS fountain_annotation,
connec.observ AS fountain_observ,
connec.comment AS fountain_comment,
connec.dma_id,
connec.presszonecat_id,
connec.soilcat_id AS fountain_soilcat_id,
connec.function_type AS fountain_function_type,
connec.category_type AS fountain_category_type,
connec.fluid_type AS fountain_fluid_type,
connec.location_type AS fountain_location_type,
connec.workcat_id AS fountain_workcat_id,
connec.workcat_id_end AS fountain_workcat_id_end,
connec.buildercat_id AS fountain_buildercat_id,
connec.builtdate AS fountain_builtdate,
connec.enddate AS fountain_enddate,
connec.ownercat_id AS fountain_ownercat_id,
connec.address_01 AS fountain_address_01,
connec.address_02 AS fountain_address_02,
connec.address_03 AS fountain_address_03,
connec.streetaxis_id AS fountain_streetaxis_id,
ext_streetaxis.name AS fountain_streetname,
connec.postnumber AS fountain_postnumber,
connec.descript AS fountain_descript,
vnode.arc_id,
cat_connec.svg AS fountain_cat_svg,
connec.rotation AS fountain_rotation,
connec.label_x AS fountain_label_x,
connec.label_y AS fountain_label_y,
connec.label_rotation AS fountain_label_rotation,
concat(connec_type.link_path,connec.link) AS fountain_link,
connec.connec_length  as fountain_connec_length,
connec.verified,
connec.the_geom,
connec.undelete,
connec.publish,
connec.inventory,
dma.macrodma_id,
connec.expl_id,
connec.num_value as fountain_num_value,
man_fountain.pol_id AS fountain_pol_id,
man_fountain.linked_connec AS fountain_linked_connec,
man_fountain.vmax AS fountain_vmax,
man_fountain.vtotal AS fountain_vtotal,
man_fountain.container_number AS fountain_container_number,
man_fountain.pump_number AS fountain_pump_number,
man_fountain.power AS fountain_power,
man_fountain.regulation_tank AS fountain_regulation_tank,
man_fountain.chlorinator AS fountain_chlorinator,
man_fountain.arq_patrimony AS fountain_arq_patrimony,
man_fountain.name AS fountain_name
FROM selector_expl, connec
	JOIN cat_connec ON connec.connecat_id = cat_connec.id
	JOIN connec_type ON connec_type.id=cat_connec.connectype_id
	LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id = v_rtc_hydrometer_x_connec.connec_id
	LEFT JOIN ext_streetaxis ON connec.streetaxis_id = ext_streetaxis.id
	LEFT JOIN link ON connec.connec_id = link.feature_id
	LEFT JOIN vnode ON vnode.vnode_id = link.vnode_id
	LEFT JOIN dma ON connec.dma_id = dma.dma_id
	JOIN man_fountain ON man_fountain.connec_id = connec.connec_id
	WHERE ((connec.expl_id)=(selector_expl.expl_id)
 	AND selector_expl.cur_user="current_user"());



 
DROP VIEW IF EXISTS v_edit_man_fountain_pol CASCADE;
CREATE OR REPLACE VIEW v_edit_man_fountain_pol AS 
SELECT 
connec.connec_id,
connec.code AS fountain_code,
connec.elevation AS fountain_elevation,
connec.depth AS fountain_depth,
cat_connec.connectype_id,
connec.connecat_id,
cat_connec.matcat_id AS fountain_cat_matcat_id,
cat_connec.pnom AS fountain_cat_pnom,
cat_connec.dnom AS fountain_cat_dnom,
connec.sector_id,
connec.customer_code AS fountain_customer_code,
v_rtc_hydrometer_x_connec.n_hydrometer AS fountain_n_hydrometer,
connec.demand AS fountain_demand,
connec.state,
connec.state_type,
connec.annotation AS fountain_annotation,
connec.observ AS fountain_observ,
connec.comment AS fountain_comment,
connec.dma_id,
connec.presszonecat_id,
connec.soilcat_id AS fountain_soilcat_id,
connec.function_type AS fountain_function_type,
connec.category_type AS fountain_category_type,
connec.fluid_type AS fountain_fluid_type,
connec.location_type AS fountain_location_type,
connec.workcat_id AS fountain_workcat_id,
connec.workcat_id_end AS fountain_workcat_id_end,
connec.buildercat_id AS fountain_buildercat_id,
connec.builtdate AS fountain_builtdate,
connec.enddate AS fountain_enddate,
connec.ownercat_id AS fountain_ownercat_id,
connec.address_01 AS fountain_address_01,
connec.address_02 AS fountain_address_02,
connec.address_03 AS fountain_address_03,
connec.streetaxis_id AS fountain_streetaxis_id,
ext_streetaxis.name AS fountain_streetname,
connec.postnumber AS fountain_postnumber,
connec.descript AS fountain_descript,
vnode.arc_id,
cat_connec.svg AS fountain_cat_svg,
connec.rotation AS fountain_rotation,
connec.label_x AS fountain_label_x,
connec.label_y AS fountain_label_y,
connec.label_rotation AS fountain_label_rotation,
concat(connec_type.link_path,connec.link) AS fountain_link,
connec.connec_length as fountain_connec_length,
connec.verified,
connec.undelete,
connec.publish,
connec.inventory,
dma.macrodma_id,
connec.expl_id,
connec.num_value as fountain_num_value,
polygon.the_geom,
man_fountain.pol_id AS fountain_pol_id,
man_fountain.linked_connec AS fountain_linked_connec,
man_fountain.vmax AS fountain_vmax,
man_fountain.vtotal AS fountain_vtotal,
man_fountain.container_number AS fountain_container_number,
man_fountain.pump_number AS fountain_pump_number,
man_fountain.power AS fountain_power,
man_fountain.regulation_tank AS fountain_regulation_tank,
man_fountain.chlorinator AS fountain_chlorinator,
man_fountain.arq_patrimony AS fountain_arq_patrimony,
man_fountain.name AS fountain_name
FROM selector_expl, connec
	JOIN cat_connec ON connec.connecat_id = cat_connec.id
	JOIN connec_type ON connec_type.id=cat_connec.connectype_id
	LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id = v_rtc_hydrometer_x_connec.connec_id
	LEFT JOIN ext_streetaxis ON connec.streetaxis_id = ext_streetaxis.id
	LEFT JOIN link ON connec.connec_id = link.feature_id
	LEFT JOIN vnode ON vnode.vnode_id = link.vnode_id
	LEFT JOIN dma ON connec.dma_id = dma.dma_id
	JOIN man_fountain ON man_fountain.connec_id = connec.connec_id
	JOIN polygon ON polygon.pol_id=man_fountain.pol_id
	WHERE ((connec.expl_id)=(selector_expl.expl_id)
 	AND selector_expl.cur_user="current_user"());

	 
DROP VIEW IF EXISTS v_edit_man_greentap CASCADE;
CREATE OR REPLACE VIEW v_edit_man_greentap AS 
SELECT 
connec.connec_id,
connec.code AS greentap_code,
connec.elevation AS greentap_elevation,
connec.depth AS greentap_depth,
cat_connec.connectype_id,
connec.connecat_id,
cat_connec.matcat_id AS greentap_cat_matcat_id,
cat_connec.pnom AS greentap_cat_pnom,
cat_connec.dnom AS greentap_cat_dnom,
connec.sector_id,
connec.customer_code AS greentap_customer_code,
v_rtc_hydrometer_x_connec.n_hydrometer AS greentap_n_hydrometer,
connec.demand AS greentap_demand,
connec.state,
connec.state_type,
connec.annotation AS greentap_annotation,
connec.observ AS greentap_observ,
connec.comment AS greentap_comment,
connec.dma_id,
connec.presszonecat_id,
connec.soilcat_id AS greentap_soilcat_id,
connec.function_type AS greentap_function_type,
connec.category_type AS greentap_category_type,
connec.fluid_type AS greentap_fluid_type,
connec.location_type AS greentap_location_type,
connec.workcat_id AS greentap_workcat_id,
connec.workcat_id_end AS greentap_workcat_id_end,
connec.buildercat_id AS greentap_buildercat_id,
connec.builtdate AS greentap_builtdate,
connec.enddate AS greentap_enddate,
connec.ownercat_id AS greentap_ownercat_id,
connec.address_01 AS greentap_address_01,
connec.address_02 AS greentap_address_02,
connec.address_03 AS greentap_address_03,
connec.streetaxis_id AS greentap_streetaxis_id,
ext_streetaxis.name AS greentap_streetname,
connec.postnumber AS greentap_postnumber,
connec.descript AS greentap_descript,
vnode.arc_id,
cat_connec.svg AS greentap_cat_svg,
connec.rotation AS greentap_rotation,
connec.label_x AS greentap_label_x,
connec.label_y AS greentap_label_y,
connec.label_rotation AS greentap_label_rotation,
concat(connec_type.link_path,connec.link) AS greentap_link,
connec.connec_length AS greentap_connec_length,
connec.verified,
connec.the_geom,
connec.undelete,
connec.publish,
connec.inventory,
dma.macrodma_id,
connec.expl_id,
connec.num_value as greentap_num_value,
man_greentap.linked_connec AS greentap_linked_connec
FROM selector_expl, connec
	JOIN cat_connec ON connec.connecat_id = cat_connec.id
	JOIN connec_type ON connec_type.id=cat_connec.connectype_id
	LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id = v_rtc_hydrometer_x_connec.connec_id
	LEFT JOIN ext_streetaxis ON connec.streetaxis_id = ext_streetaxis.id
	LEFT JOIN link ON connec.connec_id = link.feature_id
	LEFT JOIN vnode ON vnode.vnode_id = link.vnode_id
	LEFT JOIN dma ON connec.dma_id = dma.dma_id
	JOIN man_greentap ON man_greentap.connec_id = connec.connec_id
	WHERE ((connec.expl_id)=(selector_expl.expl_id)
 	AND selector_expl.cur_user="current_user"());


DROP VIEW IF EXISTS v_edit_vnode CASCADE;
CREATE VIEW v_edit_vnode AS SELECT
vnode.vnode_id,
vnode.arc_id,
vnode_type,
vnode.annotation,
userdefined_pos,
vnode.the_geom,
connec.sector_id,
connec.dma_id,
connec.state,
connec.expl_id
FROM vnode
JOIN link on link.vnode_id=vnode.vnode_id
JOIN connec ON link.feature_id=connec.connec_id;



DROP VIEW IF EXISTS v_edit_link CASCADE;
CREATE OR REPLACE VIEW v_edit_link AS 
SELECT 
link.link_id,
link.featurecat_id,
link.feature_id,
link.vnode_id,
link.the_geom,
connec.sector_id,
connec.dma_id,
connec.state,
st_length2d(link.the_geom) AS gis_length,
connec.expl_id
FROM link
JOIN connec ON link.feature_id=connec.connec_id;