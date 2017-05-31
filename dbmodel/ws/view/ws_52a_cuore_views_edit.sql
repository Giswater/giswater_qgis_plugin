/*
This file is part of Giswater 2.0
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
connec.workcat_id_end,
connec.publish,
connec.inventory,
connec.end_date,
dma.macrodma_id,
exploitation.descript AS expl_name	
FROM expl_selector, connec
JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id::text = v_rtc_hydrometer_x_connec.connec_id::text
LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
LEFT JOIN link ON connec.connec_id::text = link.connec_id::text
LEFT JOIN vnode ON vnode.vnode_id::text = link.vnode_id::text
LEFT JOIN dma ON connec.dma_id::text = dma.dma_id::text
JOIN exploitation ON connec.expl_id=exploitation.expl_id
WHERE ((connec.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text);


DROP VIEW IF EXISTS v_edit_man_wjoin CASCADE;
CREATE OR REPLACE VIEW v_edit_man_wjoin AS 
 SELECT connec.connec_id,
    connec.elevation AS wjoin_elevation,
    connec.depth AS wjoin_depth,
    connec.connec_type,
    connec.connecat_id,
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
	connec.undelete,
    man_wjoin.length AS wjoin_length,
    man_wjoin.top_floor AS wjoin_top_floor,
    man_wjoin.lead_verified AS wjoin_lead_verified,
    man_wjoin.lead_facade AS wjoin_lead_facade,
	connec.publish,
	connec.inventory,
	connec.end_date AS wjoin_end_date,
	dma.macrodma_id,
	man_wjoin.cat_valve2 AS wjoin_cat_valve2,
	exploitation.descript AS expl_name	
 FROM expl_selector, connec
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id::text = v_rtc_hydrometer_x_connec.connec_id::text
     LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN link ON connec.connec_id::text = link.connec_id::text
     LEFT JOIN vnode ON vnode.vnode_id::text = link.vnode_id::text
     LEFT JOIN dma ON connec.dma_id::text = dma.dma_id::text
     JOIN man_wjoin ON man_wjoin.connec_id::text = connec.connec_id::text
	 JOIN exploitation ON connec.expl_id=exploitation.expl_id
	 WHERE ((connec.expl_id)::text=(expl_selector.expl_id)::text
 	 AND expl_selector.cur_user="current_user"()::text);

	 
	 
DROP VIEW IF EXISTS v_edit_man_tap CASCADE;
CREATE OR REPLACE VIEW v_edit_man_tap AS 
 SELECT connec.connec_id,
    connec.elevation AS tap_elevation,
    connec.depth AS tap_depth,
    connec.connec_type,
    connec.connecat_id,
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
	connec.undelete,
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
    man_tap.communication AS tap_communication,
	connec.publish,
	connec.inventory,
	connec.end_date AS tap_end_date,
	dma.macrodma_id,
	man_tap.cat_valve2 AS tap_cat_valve2,
	man_tap.linked_connec AS tap_linked_connec,
	exploitation.descript AS expl_name	
 FROM expl_selector, connec
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id::text = v_rtc_hydrometer_x_connec.connec_id::text
     LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN link ON connec.connec_id::text = link.connec_id::text
     LEFT JOIN vnode ON vnode.vnode_id::text = link.vnode_id::text
     LEFT JOIN dma ON connec.dma_id::text = dma.dma_id::text
     JOIN man_tap ON man_tap.connec_id::text = connec.connec_id::text
	 JOIN exploitation ON connec.expl_id=exploitation.expl_id
	 WHERE ((connec.expl_id)::text=(expl_selector.expl_id)::text
 	 AND expl_selector.cur_user="current_user"()::text);

	 
	 
DROP VIEW IF EXISTS v_edit_man_fountain CASCADE;
CREATE OR REPLACE VIEW v_edit_man_fountain AS 
 SELECT connec.connec_id,
    connec.elevation AS fountain_elevation,
    connec.depth AS fountain_depth,
    connec.connec_type,
    connec.connecat_id,
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
	connec.undelete,
    man_fountain.vmax AS fountain_vmax,
    man_fountain.vtotal AS fountain_vtotal,
    man_fountain.container_number AS fountain_container_number,
    man_fountain.pump_number AS fountain_pump_number,
    man_fountain.power AS fountain_power,
    man_fountain.regulation_tank AS fountain_regulation_tank,
    man_fountain.name AS fountain_name,
    man_fountain.connection AS fountain_connection,
    man_fountain.chlorinator AS fountain_chlorinator,
	connec.publish,
	connec.inventory,
	connec.end_date AS fountain_end_date,
	dma.macrodma_id,
	man_fountain.linked_connec AS fountain_linked_connec,
	man_fountain.the_geom_pol,
	exploitation.descript AS expl_name
 FROM expl_selector, connec
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id::text = v_rtc_hydrometer_x_connec.connec_id::text
     LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN link ON connec.connec_id::text = link.connec_id::text
     LEFT JOIN vnode ON vnode.vnode_id::text = link.vnode_id::text
     LEFT JOIN dma ON connec.dma_id::text = dma.dma_id::text
     JOIN man_fountain ON man_fountain.connec_id::text = connec.connec_id::text
	 JOIN exploitation ON connec.expl_id=exploitation.expl_id
	 WHERE ((connec.expl_id)::text=(expl_selector.expl_id)::text
 	 AND expl_selector.cur_user="current_user"()::text);


	 
DROP VIEW IF EXISTS v_edit_man_greentap CASCADE;
CREATE OR REPLACE VIEW v_edit_man_greentap AS 
 SELECT connec.connec_id,
    connec.elevation AS greentap_elevation,
    connec.depth AS greentap_depth,
    connec.connec_type,
    connec.connecat_id,
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
    connec.the_geom,
	connec.undelete,
	connec.publish,
	connec.inventory,
	connec.end_date AS greentap_end_date,
	dma.macrodma_id,
	man_greentap.linked_connec AS greentap_linked_connec,
	exploitation.descript AS expl_name	
 FROM expl_selector, connec
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id::text = v_rtc_hydrometer_x_connec.connec_id::text
     LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN link ON connec.connec_id::text = link.connec_id::text
     LEFT JOIN vnode ON vnode.vnode_id::text = link.vnode_id::text
     LEFT JOIN dma ON connec.dma_id::text = dma.dma_id::text
     JOIN man_greentap ON man_greentap.connec_id::text = connec.connec_id::text
	 JOIN exploitation ON connec.expl_id=exploitation.expl_id
	 WHERE ((connec.expl_id)::text=(expl_selector.expl_id)::text
 	 AND expl_selector.cur_user="current_user"()::text);

