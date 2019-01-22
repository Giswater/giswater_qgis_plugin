/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-----------------------
-- remove all the views that are refactored in the v3.2
-----------------------
/*DROP VIEW IF EXISTS v_edit_inp_demand;
DROP VIEW IF EXISTS v_edit_inp_junction;
DROP VIEW IF EXISTS v_edit_inp_pipe;
DROP VIEW IF EXISTS v_edit_inp_pump;
DROP VIEW IF EXISTS v_edit_inp_reservoir;
DROP VIEW IF EXISTS v_edit_inp_shortpipe;
DROP VIEW IF EXISTS v_edit_inp_tank;
DROP VIEW IF EXISTS v_edit_inp_valve;

DROP VIEW IF EXISTS v_edit_man_expansiontank;
DROP VIEW IF EXISTS v_edit_man_filter;
DROP VIEW IF EXISTS v_edit_man_flexunion;
DROP VIEW IF EXISTS v_edit_man_fountain;
DROP VIEW IF EXISTS v_edit_man_greentap;
DROP VIEW IF EXISTS v_edit_man_hydrant;
DROP VIEW IF EXISTS v_edit_man_junction;
DROP VIEW IF EXISTS v_edit_man_manhole;
DROP VIEW IF EXISTS v_edit_man_meter;
DROP VIEW IF EXISTS v_edit_man_netelement;
DROP VIEW IF EXISTS v_edit_man_netsamplepoint;
DROP VIEW IF EXISTS v_edit_man_netwjoin;
DROP VIEW IF EXISTS v_edit_man_pipe;
DROP VIEW IF EXISTS v_edit_man_pump;
DROP VIEW IF EXISTS v_edit_man_reduction;
DROP VIEW IF EXISTS v_edit_man_register;
DROP VIEW IF EXISTS v_edit_man_source;
DROP VIEW IF EXISTS v_edit_man_tank;
DROP VIEW IF EXISTS v_edit_man_tap;
DROP VIEW IF EXISTS v_edit_man_valve;
DROP VIEW IF EXISTS v_edit_man_varc;
DROP VIEW IF EXISTS v_edit_man_waterwell;
DROP VIEW IF EXISTS v_edit_man_wjoin;
DROP VIEW IF EXISTS v_edit_man_wtp;

*/

--old views with new fields
DROP VIEW IF EXISTS v_anl_connec;
CREATE VIEW v_anl_connec AS 
 SELECT anl_connec.id,
    anl_connec.connec_id,
    anl_connec.connecat_id,
    anl_connec.state,
    anl_connec.connec_id_aux,
    anl_connec.connecat_id_aux,
    anl_connec.state_aux,
    sys_fprocess_cat.fprocess_i18n AS fprocess,
    exploitation.name AS expl_name,
    anl_connec.the_geom
   FROM selector_expl,
    anl_connec
     JOIN exploitation ON anl_connec.expl_id = exploitation.expl_id
     JOIN sys_fprocess_cat ON anl_connec.fprocesscat_id = sys_fprocess_cat.id
  WHERE anl_connec.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND anl_connec.cur_user::name = "current_user"();

/* drop view causes problems as many other views depends on it
DROP VIEW IF EXISTS v_rtc_hydrometer;
CREATE VIEW v_rtc_hydrometer AS 
 SELECT rtc_hydrometer.hydrometer_id,
    rtc_hydrometer_x_connec.connec_id,
    connec.customer_code AS connec_customer_code,
    connec.expl_id,
    connec.arc_id,
    value_state.name AS state,
    exploitation.name AS expl_name,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    ext_rtc_hydrometer.hydrometer_category,
    ext_rtc_hydrometer.house_number,
    ext_rtc_hydrometer.id_number,
    ext_rtc_hydrometer.cat_hydrometer_id,
    ext_rtc_hydrometer.hydrometer_number,
    ext_rtc_hydrometer.identif,
    ext_cat_hydrometer.madeby,
    ext_cat_hydrometer.class AS hydrometer_class,
    ext_cat_hydrometer.ulmc,
    ext_cat_hydrometer.voltman_flow,
    ext_cat_hydrometer.multi_jet_flow,
    ext_cat_hydrometer.dnom,
        CASE
            WHEN (( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'hydrometer_link_absolute_path'::text)) IS NULL THEN rtc_hydrometer.link
            ELSE concat(( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'hydrometer_link_absolute_path'::text), rtc_hydrometer.link)
        END AS hydrometer_link
   FROM rtc_hydrometer
     LEFT JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer.hydrometer_id::text = rtc_hydrometer.hydrometer_id::text
     LEFT JOIN ext_cat_hydrometer ON ext_cat_hydrometer.id::text = ext_rtc_hydrometer.cat_hydrometer_id
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::text = rtc_hydrometer.hydrometer_id::text
     JOIN connec ON rtc_hydrometer_x_connec.connec_id::text = connec.connec_id::text
     JOIN exploitation ON exploitation.expl_id = connec.expl_id
     JOIN value_state ON value_state.id = connec.state;
*/

-----------------------
-- create views ve
-----------------------

DROP VIEW IF EXISTS  ve_arc;
CREATE VIEW ve_arc AS 
 SELECT v_arc.arc_id,
    v_arc.code,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.arccat_id,
    v_arc.arctype_id AS arc_type,
    v_arc.sys_type,
    v_arc.matcat_id AS cat_matcat_id,
    v_arc.pnom AS cat_pnom,
    v_arc.dnom AS cat_dnom,
    v_arc.epa_type,
    v_arc.sector_id,
    sector.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.observ,
    v_arc.comment,
    v_arc.gis_length,
    v_arc.custom_length,
    v_arc.dma_id,
    v_arc.presszonecat_id,
    v_arc.soilcat_id,
    v_arc.function_type,
    v_arc.category_type,
    v_arc.fluid_type,
    v_arc.location_type,
    v_arc.workcat_id,
    v_arc.workcat_id_end,
    v_arc.buildercat_id,
    v_arc.builtdate,
    v_arc.enddate,
    v_arc.ownercat_id,
    v_arc.muni_id,
    v_arc.postcode,
    v_arc.streetaxis_id,
    v_arc.postnumber,
    v_arc.postcomplement,
    v_arc.postcomplement2,
    v_arc.streetaxis2_id,
    v_arc.postnumber2,
    v_arc.descript,
    v_arc.link,
    v_arc.verified,
    v_arc.the_geom,
    v_arc.undelete,
    v_arc.label_x,
    v_arc.label_y,
    v_arc.label_rotation,
    v_arc.publish,
    v_arc.inventory,
    v_arc.macrodma_id,
    v_arc.expl_id,
    v_arc.num_value
   FROM v_arc
     LEFT JOIN sector ON v_arc.sector_id = sector.sector_id;

DROP VIEW IF EXISTS  ve_connec;
CREATE VIEW ve_connec AS 
 SELECT connec.connec_id,
    connec.code,
    connec.elevation,
    connec.depth,
    cat_connec.connectype_id AS connec_type,
    connec_type.type AS sys_type,
    connec.connecat_id,
    connec.sector_id,
    sector.macrosector_id,
    connec.customer_code,
    cat_connec.matcat_id AS cat_matcat_id,
    cat_connec.pnom AS cat_pnom,
    cat_connec.dnom AS cat_dnom,
    connec.connec_length,
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
    concat(connec_type.link_path, connec.link) AS link,
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
   FROM connec
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     JOIN connec_type ON connec_type.id::text = cat_connec.connectype_id::text
     JOIN v_state_connec ON v_state_connec.connec_id::text = connec.connec_id::text
     LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id::text = v_rtc_hydrometer_x_connec.connec_id::text
     LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id;


DROP VIEW IF EXISTS ve_node;
CREATE VIEW ve_node AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id AS node_type,
    v_node.sys_type,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    sector.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.buildercat_id,
    v_node.workcat_id_end,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value
   FROM v_node
     LEFT JOIN sector ON v_node.sector_id = sector.sector_id;



-----------------------
-- create parent views
-----------------------
DROP VIEW IF EXISTS vp_arc;
CREATE OR REPLACE VIEW vp_arc AS 
 SELECT ve_arc.arc_id AS nid,
    ve_arc.arc_type AS custom_type
   FROM ve_arc;

DROP VIEW IF EXISTS vp_connec;
CREATE OR REPLACE VIEW vp_connec AS 
 SELECT ve_connec.connec_id AS nid,
    ve_connec.connec_type AS custom_type
   FROM ve_connec;

DROP VIEW IF EXISTS vp_node;
CREATE OR REPLACE VIEW vp_node AS 
 SELECT ve_node.node_id AS nid,
    ve_node.node_type AS custom_type
   FROM ve_node;
   
-----------------------
-- create child views
-----------------------
DROP VIEW IF EXISTS  ve_arc_varc;
CREATE VIEW ve_arc_varc AS 
 SELECT v_arc.arc_id,
    v_arc.code,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.arccat_id,
    v_arc.arctype_id AS cat_arctype_id,
    v_arc.matcat_id,
    v_arc.pnom AS cat_pnom,
    v_arc.dnom AS cat_dnom,
    v_arc.epa_type,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.observ,
    v_arc.comment,
    v_arc.gis_length,
    v_arc.custom_length,
    v_arc.dma_id,
    v_arc.presszonecat_id,
    v_arc.soilcat_id,
    v_arc.function_type,
    v_arc.category_type,
    v_arc.fluid_type,
    v_arc.location_type,
    v_arc.workcat_id,
    v_arc.workcat_id_end,
    v_arc.buildercat_id,
    v_arc.builtdate,
    v_arc.enddate,
    v_arc.ownercat_id,
    v_arc.muni_id,
    v_arc.postcode,
    v_arc.streetaxis_id,
    v_arc.postnumber,
    v_arc.postcomplement,
    v_arc.postcomplement2,
    v_arc.streetaxis2_id,
    v_arc.postnumber2,
    v_arc.descript,
    v_arc.link,
    v_arc.verified,
    v_arc.the_geom,
    v_arc.undelete,
    v_arc.label_x,
    v_arc.label_y,
    v_arc.label_rotation,
    v_arc.publish,
    v_arc.inventory,
    v_arc.macrodma_id,
    v_arc.expl_id,
    v_arc.num_value
   FROM v_arc
     JOIN man_varc ON man_varc.arc_id::text = v_arc.arc_id::text;

DROP VIEW IF EXISTS  ve_connec_fountain;
CREATE VIEW ve_connec_fountain AS 
 SELECT connec.connec_id,
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
    concat(connec_type.link_path, connec.link) AS link,
    connec.connec_length,
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
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     JOIN connec_type ON connec_type.id::text = cat_connec.connectype_id::text
     JOIN v_state_connec ON v_state_connec.connec_id::text = connec.connec_id::text
     LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id::text = v_rtc_hydrometer_x_connec.connec_id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id
     JOIN man_fountain ON man_fountain.connec_id::text = connec.connec_id::text;


DROP VIEW IF EXISTS  ve_connec_greentap;
CREATE VIEW ve_connec_greentap AS 
 SELECT connec.connec_id,
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
    concat(connec_type.link_path, connec.link) AS link,
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
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     JOIN connec_type ON connec_type.id::text = cat_connec.connectype_id::text
     JOIN v_state_connec ON v_state_connec.connec_id::text = connec.connec_id::text
     LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id::text = v_rtc_hydrometer_x_connec.connec_id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id
     JOIN man_greentap ON man_greentap.connec_id::text = connec.connec_id::text;


DROP VIEW IF EXISTS  ve_connec_tap;
CREATE VIEW ve_connec_tap AS 
 SELECT connec.connec_id,
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
    concat(connec_type.link_path, connec.link) AS link,
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
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     JOIN connec_type ON connec_type.id::text = cat_connec.connectype_id::text
     JOIN v_state_connec ON v_state_connec.connec_id::text = connec.connec_id::text
     LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id::text = v_rtc_hydrometer_x_connec.connec_id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id
     JOIN man_tap ON man_tap.connec_id::text = connec.connec_id::text;


DROP VIEW IF EXISTS ve_connec_wjoin;
CREATE VIEW ve_connec_wjoin AS 
 SELECT connec.connec_id,
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
    concat(connec_type.link_path, connec.link) AS link,
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
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     JOIN connec_type ON connec_type.id::text = cat_connec.connectype_id::text
     JOIN v_state_connec ON v_state_connec.connec_id::text = connec.connec_id::text
     JOIN man_wjoin ON man_wjoin.connec_id::text = connec.connec_id::text
     LEFT JOIN v_rtc_hydrometer_x_connec ON connec.connec_id::text = v_rtc_hydrometer_x_connec.connec_id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id;


DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_shutoffvalve;
CREATE VIEW SCHEMA_NAME.ve_node_shutoffvalve AS 
SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_valve.closed,
    man_valve.broken,
    man_valve.buried,
    man_valve.irrigation_indicator,
    man_valve.pression_entry,
    man_valve.pression_exit,
    man_valve.depth_valveshaft,
    man_valve.regulator_situation,
    man_valve.regulator_location,
    man_valve.regulator_observ,
    man_valve.lin_meters,
    man_valve.exit_type,
    man_valve.exit_code,
    man_valve.drive_type,
    man_valve.cat_valve2,
    a.shtvalve_param_1,
    a.shtvalve_param_2
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_valve ON man_valve.node_id::text = v_node.node_id::text
     LEFT JOIN ( SELECT ct.feature_id, ct.shtvalve_param_1,ct.shtvalve_param_2
            FROM crosstab('SELECT feature_id, parameter_id, value_param
                    FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter on man_addfields_parameter.id=parameter_id where cat_feature_id=''SHUTOFF-VALVE''
                    ORDER  BY 1,2'::text, ' VALUES (''22''),(''23'')'::text) 
                    ct(feature_id character varying, shtvalve_param_1 text, shtvalve_param_2 text)) a ON a.feature_id::text = v_node.node_id::text
                    WHERE v_node.nodetype_id::text = 'SHUTOFF-VALVE'::text;


DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_checkoffvalve;
CREATE VIEW SCHEMA_NAME.ve_node_checkoffvalve AS 
SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_valve.closed,
    man_valve.broken,
    man_valve.buried,
    man_valve.irrigation_indicator,
    man_valve.pression_entry,
    man_valve.pression_exit,
    man_valve.depth_valveshaft,
    man_valve.regulator_situation,
    man_valve.regulator_location,
    man_valve.regulator_observ,
    man_valve.lin_meters,
    man_valve.exit_type,
    man_valve.exit_code,
    man_valve.drive_type,
    man_valve.cat_valve2,
    a.checkvalve_param_1,
    a.checkvalve_param_2
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_valve ON man_valve.node_id::text = v_node.node_id::text
     LEFT JOIN ( SELECT ct.feature_id, ct.checkvalve_param_1,ct.checkvalve_param_2
            FROM crosstab('SELECT feature_id, parameter_id, value_param
                    FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter on man_addfields_parameter.id=parameter_id where cat_feature_id=''CHECK-VALVE''
                    ORDER  BY 1,2'::text, ' VALUES (''47''),(''48'')'::text) 
                    ct(feature_id character varying, checkvalve_param_1 text, checkvalve_param_2 text)) a ON a.feature_id::text = v_node.node_id::text
                    WHERE v_node.nodetype_id::text = 'CHECK-VALVE'::text;


DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_prbkvalve;
CREATE VIEW SCHEMA_NAME.ve_node_prbkvalve AS 
SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_valve.closed,
    man_valve.broken,
    man_valve.buried,
    man_valve.irrigation_indicator,
    man_valve.pression_entry,
    man_valve.pression_exit,
    man_valve.depth_valveshaft,
    man_valve.regulator_situation,
    man_valve.regulator_location,
    man_valve.regulator_observ,
    man_valve.lin_meters,
    man_valve.exit_type,
    man_valve.exit_code,
    man_valve.drive_type,
    man_valve.cat_valve2
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_valve ON man_valve.node_id::text = v_node.node_id::text
     WHERE nodetype_id='PR-BREAK.VALVE';


DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_flcontrvalve;
CREATE VIEW SCHEMA_NAME.ve_node_flcontrvalve AS 
SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_valve.closed,
    man_valve.broken,
    man_valve.buried,
    man_valve.irrigation_indicator,
    man_valve.pression_entry,
    man_valve.pression_exit,
    man_valve.depth_valveshaft,
    man_valve.regulator_situation,
    man_valve.regulator_location,
    man_valve.regulator_observ,
    man_valve.lin_meters,
    man_valve.exit_type,
    man_valve.exit_code,
    man_valve.drive_type,
    man_valve.cat_valve2
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_valve ON man_valve.node_id::text = v_node.node_id::text
     WHERE nodetype_id='FL-CONTR.VALVE';


DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_genpurpvalve;
CREATE VIEW SCHEMA_NAME.ve_node_genpurpvalve AS 
SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_valve.closed,
    man_valve.broken,
    man_valve.buried,
    man_valve.irrigation_indicator,
    man_valve.pression_entry,
    man_valve.pression_exit,
    man_valve.depth_valveshaft,
    man_valve.regulator_situation,
    man_valve.regulator_location,
    man_valve.regulator_observ,
    man_valve.lin_meters,
    man_valve.exit_type,
    man_valve.exit_code,
    man_valve.drive_type,
    man_valve.cat_valve2
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_valve ON man_valve.node_id::text = v_node.node_id::text
     WHERE nodetype_id='GEN-PURP.VALVE';


DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_throttlevalve;
CREATE VIEW SCHEMA_NAME.ve_node_throttlevalve AS 
SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_valve.closed,
    man_valve.broken,
    man_valve.buried,
    man_valve.irrigation_indicator,
    man_valve.pression_entry,
    man_valve.pression_exit,
    man_valve.depth_valveshaft,
    man_valve.regulator_situation,
    man_valve.regulator_location,
    man_valve.regulator_observ,
    man_valve.lin_meters,
    man_valve.exit_type,
    man_valve.exit_code,
    man_valve.drive_type,
    man_valve.cat_valve2
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_valve ON man_valve.node_id::text = v_node.node_id::text
     WHERE nodetype_id='THROTTLE-VALVE';


DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_prreducvalve;
CREATE VIEW SCHEMA_NAME.ve_node_prreducvalve AS 
SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_valve.closed,
    man_valve.broken,
    man_valve.buried,
    man_valve.irrigation_indicator,
    man_valve.pression_entry,
    man_valve.pression_exit,
    man_valve.depth_valveshaft,
    man_valve.regulator_situation,
    man_valve.regulator_location,
    man_valve.regulator_observ,
    man_valve.lin_meters,
    man_valve.exit_type,
    man_valve.exit_code,
    man_valve.drive_type,
    man_valve.cat_valve2
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_valve ON man_valve.node_id::text = v_node.node_id::text
     WHERE nodetype_id='PR-REDUC.VALVE';


DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_prsustavalve;
CREATE VIEW SCHEMA_NAME.ve_node_prsustavalve AS 
SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_valve.closed,
    man_valve.broken,
    man_valve.buried,
    man_valve.irrigation_indicator,
    man_valve.pression_entry,
    man_valve.pression_exit,
    man_valve.depth_valveshaft,
    man_valve.regulator_situation,
    man_valve.regulator_location,
    man_valve.regulator_observ,
    man_valve.lin_meters,
    man_valve.exit_type,
    man_valve.exit_code,
    man_valve.drive_type,
    man_valve.cat_valve2
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_valve ON man_valve.node_id::text = v_node.node_id::text
     WHERE nodetype_id='PR-SUSTA.VALVE';


DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_airvalve;
CREATE VIEW SCHEMA_NAME.ve_node_airvalve AS 
SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_valve.closed,
    man_valve.broken,
    man_valve.buried,
    man_valve.irrigation_indicator,
    man_valve.pression_entry,
    man_valve.pression_exit,
    man_valve.depth_valveshaft,
    man_valve.regulator_situation,
    man_valve.regulator_location,
    man_valve.regulator_observ,
    man_valve.lin_meters,
    man_valve.exit_type,
    man_valve.exit_code,
    man_valve.drive_type,
    man_valve.cat_valve2,
    a.airvalve_param_1,
    a.airvalve_param_2
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_valve ON man_valve.node_id::text = v_node.node_id::text
     LEFT JOIN ( SELECT ct.feature_id, ct.airvalve_param_1,ct.airvalve_param_2
            FROM crosstab('SELECT feature_id, parameter_id, value_param
                FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter on man_addfields_parameter.id=parameter_id where cat_feature_id=''AIR-VALVE''
                ORDER  BY 1,2'::text, ' VALUES (''26''),(''27'')'::text) 
                ct(feature_id character varying, airvalve_param_1 text, airvalve_param_2 text)) a ON a.feature_id::text = v_node.node_id::text
                WHERE v_node.nodetype_id::text = 'AIR-VALVE'::text;




DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_greenvalve;
CREATE VIEW SCHEMA_NAME.ve_node_greenvalve AS 
SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_valve.closed,
    man_valve.broken,
    man_valve.buried,
    man_valve.irrigation_indicator,
    man_valve.pression_entry,
    man_valve.pression_exit,
    man_valve.depth_valveshaft,
    man_valve.regulator_situation,
    man_valve.regulator_location,
    man_valve.regulator_observ,
    man_valve.lin_meters,
    man_valve.exit_type,
    man_valve.exit_code,
    man_valve.drive_type,
    man_valve.cat_valve2,
    a.greenvalve_param_1,
    a.greenvalve_param_2
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_valve ON man_valve.node_id::text = v_node.node_id::text
     LEFT JOIN ( SELECT ct.feature_id, ct.greenvalve_param_1,ct.greenvalve_param_2
            FROM crosstab('SELECT feature_id, parameter_id, value_param
                FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter on man_addfields_parameter.id=parameter_id where cat_feature_id=''GREEN-VALVE''
                ORDER  BY 1,2'::text, ' VALUES (''26''),(''27'')'::text) 
                ct(feature_id character varying, greenvalve_param_1 text, greenvalve_param_2 text)) a ON a.feature_id::text = v_node.node_id::text
                WHERE v_node.nodetype_id::text = 'GREEN-VALVE'::text;



DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_outfallvalve;
CREATE VIEW SCHEMA_NAME.ve_node_outfallvalve AS 
SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_valve.closed,
    man_valve.broken,
    man_valve.buried,
    man_valve.irrigation_indicator,
    man_valve.pression_entry,
    man_valve.pression_exit,
    man_valve.depth_valveshaft,
    man_valve.regulator_situation,
    man_valve.regulator_location,
    man_valve.regulator_observ,
    man_valve.lin_meters,
    man_valve.exit_type,
    man_valve.exit_code,
    man_valve.drive_type,
    man_valve.cat_valve2,
    a.outfallvalve_param_1,
    a.outfallvalve_param_2
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_valve ON man_valve.node_id::text = v_node.node_id::text
     LEFT JOIN ( SELECT ct.feature_id, ct.outfallvalve_param_1,ct.outfallvalve_param_2
            FROM crosstab('SELECT feature_id, parameter_id, value_param
                FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter on man_addfields_parameter.id=parameter_id where cat_feature_id=''OUTFALL-VALVE''
                ORDER  BY 1,2'::text, ' VALUES (''26''),(''27'')'::text) 
                ct(feature_id character varying, outfallvalve_param_1 text, outfallvalve_param_2 text)) a ON a.feature_id::text = v_node.node_id::text
                WHERE v_node.nodetype_id::text = 'OUTFALL-VALVE'::text;


DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_register;
CREATE VIEW SCHEMA_NAME.ve_node_register AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_register.pol_id,
    a.register_param_1,
    a.register_param_2
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_register ON v_node.node_id::text = man_register.node_id::text
     LEFT JOIN ( SELECT ct.feature_id, ct.register_param_1,ct.register_param_2
            FROM crosstab('SELECT feature_id, parameter_id, value_param
                FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter on man_addfields_parameter.id=parameter_id where cat_feature_id=''REGISTER''
                ORDER  BY 1,2'::text, ' VALUES (''3''),(''4'')'::text) 
                ct(feature_id character varying, register_param_1 text, register_param_2 text)) a ON a.feature_id::text = v_node.node_id::text
                WHERE v_node.nodetype_id::text = 'REGISTER'::text;


DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_bypassregister;
CREATE VIEW SCHEMA_NAME.ve_node_bypassregister AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_register.pol_id
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_register ON v_node.node_id::text = man_register.node_id::text
     WHERE nodetype_id='BYPASS-REGISTER';



DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_valveregister;
CREATE VIEW SCHEMA_NAME.ve_node_valveregister AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_register.pol_id
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_register ON v_node.node_id::text = man_register.node_id::text
     WHERE nodetype_id='VALVE-REGISTER';



DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_controlregister;
CREATE VIEW SCHEMA_NAME.ve_node_controlregister AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_register.pol_id,
    a.ctrlregister_param_1,
    a.ctrlregister_param_2
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_register ON v_node.node_id::text = man_register.node_id::text
     LEFT JOIN ( SELECT ct.feature_id, ct.ctrlregister_param_1,ct.ctrlregister_param_2
            FROM crosstab('SELECT feature_id, parameter_id, value_param
                FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter on man_addfields_parameter.id=parameter_id where cat_feature_id=''CONTROL-REGISTER''
                ORDER  BY 1,2'::text, ' VALUES (''28''),(''29'')'::text) 
                ct(feature_id character varying, ctrlregister_param_1 text, ctrlregister_param_2 text)) a ON a.feature_id::text = v_node.node_id::text
                WHERE v_node.nodetype_id::text = 'CONTROL-REGISTER'::text;



DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_expansiontank;
CREATE VIEW SCHEMA_NAME.ve_node_expansiontank AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_expansiontank ON v_node.node_id::text = man_expansiontank.node_id::text;



DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_filter;
CREATE VIEW SCHEMA_NAME.ve_node_filter AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_filter ON v_node.node_id::text = man_filter.node_id::text;



DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_flexunion;
CREATE VIEW SCHEMA_NAME.ve_node_flexunion AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_flexunion ON v_node.node_id::text = man_flexunion.node_id::text;



DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_hydrant;
CREATE VIEW SCHEMA_NAME.ve_node_hydrant AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.num_value,
    v_node.hemisphere,
    man_hydrant.fire_code,
    man_hydrant.communication,
    man_hydrant.valve,
    a.hydrant_param_1,
    a.hydrant_param_2
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_hydrant ON man_hydrant.node_id::text = v_node.node_id::text
     LEFT JOIN ( SELECT ct.feature_id, ct.hydrant_param_1,ct.hydrant_param_2
            FROM crosstab('SELECT feature_id, parameter_id, value_param
                    FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter on man_addfields_parameter.id=parameter_id where cat_feature_id=''HYDRANT''
                    ORDER  BY 1,2'::text, ' VALUES (''35''),(''36'')'::text) 
                    ct(feature_id character varying, hydrant_param_1 text, hydrant_param_2 text)) a ON a.feature_id::text = v_node.node_id::text
                    WHERE v_node.nodetype_id::text = 'HYDRANT'::text;


DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_x;
CREATE VIEW SCHEMA_NAME.ve_node_x AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_junction ON v_node.node_id::text = man_junction.node_id::text
     WHERE nodetype_id='X';

DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_adaptation;
CREATE VIEW SCHEMA_NAME.ve_node_adaptation AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_junction ON v_node.node_id::text = man_junction.node_id::text
     WHERE nodetype_id='ADAPTATION';


DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_endline;
CREATE VIEW SCHEMA_NAME.ve_node_endline AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_junction ON v_node.node_id::text = man_junction.node_id::text
     WHERE nodetype_id='ENDLINE';


DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_t;
CREATE VIEW SCHEMA_NAME.ve_node_t AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_junction ON v_node.node_id::text = man_junction.node_id::text
     WHERE nodetype_id='T';


DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_curve;
CREATE VIEW SCHEMA_NAME.ve_node_curve AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_junction ON v_node.node_id::text = man_junction.node_id::text
     WHERE nodetype_id='CURVE';


DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_junction;
CREATE VIEW SCHEMA_NAME.ve_node_junction AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_junction ON v_node.node_id::text = man_junction.node_id::text
     WHERE nodetype_id='JUNCTION';


DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_manhole;
CREATE VIEW SCHEMA_NAME.ve_node_manhole AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_manhole.name
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_manhole ON v_node.node_id::text = man_manhole.node_id::text;



DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_flowmeter;
CREATE VIEW SCHEMA_NAME.ve_node_flowmeter AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_meter ON man_meter.node_id::text = v_node.node_id::text
     WHERE nodetype_id='FLOWMETER';


DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_pressuremeter;
CREATE VIEW SCHEMA_NAME.ve_node_pressuremeter AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_meter ON man_meter.node_id::text = v_node.node_id::text
    WHERE nodetype_id='PRESSURE-METER';


DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_netelement;
CREATE VIEW SCHEMA_NAME.ve_node_netelement AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_netelement.serial_number
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_netelement ON v_node.node_id::text = man_netelement.node_id::text;



DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_netsamplepoint;
CREATE VIEW SCHEMA_NAME.ve_node_netsamplepoint AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_netsamplepoint.lab_code
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_netsamplepoint ON v_node.node_id::text = man_netsamplepoint.node_id::text;



DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_waterconnection;
CREATE VIEW SCHEMA_NAME.ve_node_waterconnection AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_netwjoin.customer_code,
    man_netwjoin.top_floor,
    man_netwjoin.cat_valve
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_netwjoin ON v_node.node_id::text = man_netwjoin.node_id::text;



DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_pump;
CREATE VIEW SCHEMA_NAME.ve_node_pump AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_pump.max_flow,
    man_pump.min_flow,
    man_pump.nom_flow,
    man_pump.power,
    man_pump.pressure,
    man_pump.elev_height,
    man_pump.name,
    man_pump.pump_number
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_pump ON man_pump.node_id::text = v_node.node_id::text;



DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_reduction;
CREATE VIEW SCHEMA_NAME.ve_node_reduction AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_reduction.diam1,
    man_reduction.diam2
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_reduction ON man_reduction.node_id::text = v_node.node_id::text;



DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_source;
CREATE VIEW SCHEMA_NAME.ve_node_source AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_source.name
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_source ON v_node.node_id::text = man_source.node_id::text;



DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_tank;
CREATE VIEW SCHEMA_NAME.ve_node_tank AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_tank.pol_id,
    man_tank.vmax,
    man_tank.vutil,
    man_tank.area,
    man_tank.chlorination,
    man_tank.name,
    a.tank_param_1,
    a.tank_param_2
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_tank ON man_tank.node_id::text = v_node.node_id::text
     LEFT JOIN ( SELECT ct.feature_id, ct.tank_param_1,ct.tank_param_2
            FROM crosstab('SELECT feature_id, parameter_id, value_param
                FROM SCHEMA_NAME.man_addfields_value JOIN SCHEMA_NAME.man_addfields_parameter on man_addfields_parameter.id=parameter_id where cat_feature_id=''TANK''
                ORDER  BY 1,2'::text, ' VALUES (''5''),(''6'')'::text) 
                ct(feature_id character varying, tank_param_1 text, tank_param_2 text)) a ON a.feature_id::text = v_node.node_id::text
                WHERE v_node.nodetype_id::text = 'TANK'::text;



DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_waterwell;
CREATE VIEW SCHEMA_NAME.ve_node_waterwell AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_waterwell.name
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_waterwell ON v_node.node_id::text = man_waterwell.node_id::text;



DROP VIEW IF EXISTS SCHEMA_NAME.ve_node_wtp;
CREATE VIEW SCHEMA_NAME.ve_node_wtp AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x, 
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_wtp.name
   FROM SCHEMA_NAME.v_node
     JOIN SCHEMA_NAME.man_wtp ON v_node.node_id::text = man_wtp.node_id::text;


-----------------------
-- polygon views
-----------------------

DROP VIEW IF EXISTS ve_pol_tank CASCADE;
CREATE OR REPLACE VIEW ve_pol_tank AS 
SELECT 
man_tank.pol_id,
v_node.node_id,
polygon.the_geom
FROM v_node
    JOIN man_tank ON man_tank.node_id = v_node.node_id
    JOIN polygon ON polygon.pol_id=man_tank.pol_id;
    
DROP VIEW IF EXISTS ve_pol_register CASCADE;
CREATE OR REPLACE VIEW ve_pol_register AS 
SELECT 
man_register.pol_id,
v_node.node_id,
polygon.the_geom
FROM v_node
    JOIN man_register ON v_node.node_id = man_register.node_id
    JOIN polygon ON polygon.pol_id = man_register.pol_id;


DROP VIEW IF EXISTS ve_pol_fountain CASCADE;
CREATE OR REPLACE VIEW ve_pol_fountain AS 
SELECT 
man_fountain.pol_id,
connec.connec_id,
polygon.the_geom
FROM connec
    JOIN man_fountain ON man_fountain.connec_id = connec.connec_id
    JOIN polygon ON polygon.pol_id=man_fountain.pol_id;

-----------------------
-- plan edit views
-----------------------

DROP VIEW IF EXISTS v_ui_plan_arc_cost;
CREATE OR REPLACE VIEW v_ui_plan_arc_cost AS 
 SELECT arc.arc_id,
    1 AS orderby,
    'element'::text AS identif,
    cat_arc.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    1 AS measurement,
    1::numeric * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
     JOIN v_price_compost ON cat_arc.cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    2 AS orderby,
    'm2bottom'::text AS identif,
    cat_arc.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m2mlbottom AS measurement,
    v_plan_arc.m2mlbottom * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
     JOIN v_price_compost ON cat_arc.m2bottom_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    3 AS orderby,
    'm3protec'::text AS identif,
    cat_arc.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m3mlprotec AS measurement,
    v_plan_arc.m3mlprotec * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
     JOIN v_price_compost ON cat_arc.m3protec_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    4 AS orderby,
    'm3exc'::text AS identif,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m3mlexc AS measurement,
    v_plan_arc.m3mlexc * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_soil ON cat_soil.id::text = arc.soilcat_id::text
     JOIN v_price_compost ON cat_soil.m3exc_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    5 AS orderby,
    'm3fill'::text AS identif,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m3mlfill AS measurement,
    v_plan_arc.m3mlfill * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_soil ON cat_soil.id::text = arc.soilcat_id::text
     JOIN v_price_compost ON cat_soil.m3fill_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    6 AS orderby,
    'm3excess'::text AS identif,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m3mlexcess AS measurement,
    v_plan_arc.m3mlexcess * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_soil ON cat_soil.id::text = arc.soilcat_id::text
     JOIN v_price_compost ON cat_soil.m3excess_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    7 AS orderby,
    'm2trenchl'::text AS identif,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m2mltrenchl AS measurement,
    v_plan_arc.m2mltrenchl * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_soil ON cat_soil.id::text = arc.soilcat_id::text
     JOIN v_price_compost ON cat_soil.m2trenchl_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    8 AS orderby,
    'pavement'::text AS identif,
    cat_pavement.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m2mlpav * plan_arc_x_pavement.percent AS measurement,
    v_plan_arc.m2mlpav * plan_arc_x_pavement.percent * v_price_compost.price AS total_cost
   FROM arc
     JOIN plan_arc_x_pavement ON plan_arc_x_pavement.arc_id::text = arc.arc_id::text
     JOIN cat_pavement ON cat_pavement.id::text = plan_arc_x_pavement.pavcat_id::text
     JOIN v_price_compost ON cat_pavement.m2_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT connec.arc_id,
    9 AS orderby,
    'connec'::text AS identif,
    'Various catalog'::character varying AS catalog_id,
    'Various prices'::character varying AS price_id,
    'ut'::character varying AS unit,
    'Sumatory of connecs cost related to arc. The cost is calculated in combination of parameters depth/length from connec table and catalog price from cat_connec table'::character varying AS descript,
    NULL::numeric AS cost,
    count(connec.connec_id) AS measurement,
    sum(connec.connec_length * (v_price_x_catconnec.cost_mlconnec + v_price_x_catconnec.cost_m3trench * connec.depth * 0.333) + v_price_x_catconnec.cost_ut)::numeric(12,2) AS total_cost
   FROM connec
     JOIN v_price_x_catconnec ON v_price_x_catconnec.id::text = connec.connecat_id::text
  GROUP BY connec.arc_id
  ORDER BY 1, 2;

-----------------------
-- rpt edit views
-----------------------
DROP VIEW IF EXISTS ve_ui_rpt_result_cat;
CREATE OR REPLACE VIEW ve_ui_rpt_result_cat AS 
 SELECT rpt_cat_result.id,
    rpt_cat_result.result_id,
    rpt_cat_result.n_junction,
    rpt_cat_result.n_reservoir,
    rpt_cat_result.n_tank,
    rpt_cat_result.n_pipe,
    rpt_cat_result.n_pump,
    rpt_cat_result.n_valve,
    rpt_cat_result.head_form,
    rpt_cat_result.hydra_time,
    rpt_cat_result.hydra_acc,
    rpt_cat_result.st_ch_freq,
    rpt_cat_result.max_tr_ch,
    rpt_cat_result.dam_li_thr,
    rpt_cat_result.max_trials,
    rpt_cat_result.q_analysis,
    rpt_cat_result.spec_grav,
    rpt_cat_result.r_kin_visc,
    rpt_cat_result.r_che_diff,
    rpt_cat_result.dem_multi,
    rpt_cat_result.total_dura,
    rpt_cat_result.exec_date,
    rpt_cat_result.q_timestep,
    rpt_cat_result.q_tolerance
   FROM rpt_cat_result;

-----------------------
-- inp edit views
-----------------------
DROP VIEW IF EXISTS ve_inp_demand;
CREATE VIEW ve_inp_demand AS 
 SELECT inp_demand.id,
    node.node_id,
    inp_demand.demand,
    inp_demand.pattern_id,
    inp_demand.deman_type,
    inp_demand.dscenario_id
   FROM inp_selector_sector,
    inp_selector_dscenario,
    node
     JOIN v_node ON v_node.node_id::text = node.node_id::text
     JOIN inp_demand ON inp_demand.node_id::text = node.node_id::text
  WHERE node.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text 
  AND inp_demand.dscenario_id = inp_selector_dscenario.dscenario_id AND inp_selector_dscenario.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS ve_inp_junction;
CREATE VIEW ve_inp_junction AS 
 SELECT node.node_id,
    node.elevation,
    node.depth,
    node.nodecat_id,
    node.sector_id,
    v_node.macrosector_id,
    node.state,
    node.annotation,
    node.the_geom,
    inp_junction.demand,
    inp_junction.pattern_id
   FROM inp_selector_sector,
    node
     JOIN v_node ON v_node.node_id::text = node.node_id::text
     JOIN inp_junction ON inp_junction.node_id::text = node.node_id::text
  WHERE node.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS ve_inp_pipe;
CREATE VIEW ve_inp_pipe AS 
 SELECT arc.arc_id,
    arc.arccat_id,
    arc.sector_id,
    v_arc.macrosector_id,
    arc.state,
    arc.annotation,
    arc.custom_length,
    arc.the_geom,
    inp_pipe.minorloss,
    inp_pipe.status,
    inp_pipe.custom_roughness,
    inp_pipe.custom_dint
   FROM inp_selector_sector,
    arc
     JOIN v_arc ON v_arc.arc_id::text = arc.arc_id::text
     JOIN inp_pipe ON inp_pipe.arc_id::text = arc.arc_id::text
  WHERE arc.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS ve_inp_pump;
CREATE VIEW ve_inp_pump AS 
 SELECT node.node_id,
    node.elevation,
    node.depth,
    node.nodecat_id,
    node.sector_id,
    v_node.macrosector_id,
    node.state,
    node.annotation,
    node.the_geom,
    inp_pump.power,
    inp_pump.curve_id,
    inp_pump.speed,
    inp_pump.pattern,
    inp_pump.to_arc,
    inp_pump.status
   FROM inp_selector_sector,
    node
     JOIN v_node ON v_node.node_id::text = node.node_id::text
     JOIN inp_pump ON node.node_id::text = inp_pump.node_id::text
  WHERE node.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS ve_inp_reservoir;
CREATE VIEW ve_inp_reservoir AS 
 SELECT node.node_id,
    node.elevation,
    node.depth,
    node.nodecat_id,
    node.sector_id,
    v_node.macrosector_id,
    node.state,
    node.annotation,
    node.the_geom,
    inp_reservoir.pattern_id
   FROM inp_selector_sector,
    node
     JOIN v_node ON v_node.node_id::text = node.node_id::text
     JOIN inp_reservoir ON inp_reservoir.node_id::text = node.node_id::text
  WHERE node.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS ve_inp_shortpipe;
CREATE VIEW ve_inp_shortpipe AS 
 SELECT node.node_id,
    node.elevation,
    node.depth,
    node.nodecat_id,
    node.sector_id,
    v_node.macrosector_id,
    node.state,
    node.annotation,
    node.the_geom,
    inp_shortpipe.minorloss,
    inp_shortpipe.to_arc,
    inp_shortpipe.status
   FROM inp_selector_sector,
    node
     JOIN v_node ON v_node.node_id::text = node.node_id::text
     JOIN inp_shortpipe ON inp_shortpipe.node_id::text = node.node_id::text
  WHERE node.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS ve_inp_tank;
CREATE VIEW ve_inp_tank AS 
 SELECT node.node_id,
    node.elevation,
    node.depth,
    node.nodecat_id,
    node.sector_id,
    v_node.macrosector_id,
    node.state,
    node.annotation,
    node.the_geom,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id
   FROM inp_selector_sector,
    node
     JOIN v_node ON v_node.node_id::text = node.node_id::text
     JOIN inp_tank ON inp_tank.node_id::text = node.node_id::text
  WHERE node.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS ve_inp_valve;
CREATE VIEW ve_inp_valve AS 
 SELECT node.node_id,
    node.elevation,
    node.depth,
    node.nodecat_id,
    node.sector_id,
    v_node.macrosector_id,
    node.state,
    node.annotation,
    node.the_geom,
    inp_valve.valv_type,
    inp_valve.pressure,
    inp_valve.flow,
    inp_valve.coef_loss,
    inp_valve.curve_id,
    inp_valve.minorloss,
    inp_valve.to_arc,
    inp_valve.status
   FROM inp_selector_sector,
    node
     JOIN v_node ON v_node.node_id::text = node.node_id::text
     JOIN inp_valve ON node.node_id::text = inp_valve.node_id::text
  WHERE node.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;



--mincut
DROP VIEW IF EXISTS ve_ui_mincut_result_cat;
CREATE VIEW ve_ui_mincut_result_cat AS 
 SELECT anl_mincut_result_cat.id,
    anl_mincut_result_cat.work_order,
    anl_mincut_cat_state.name AS state,
    anl_mincut_cat_class.name AS class,
    anl_mincut_result_cat.mincut_type,
    anl_mincut_result_cat.received_date,
    anl_mincut_result_cat.expl_id,
    anl_mincut_result_cat.macroexpl_id,
    anl_mincut_result_cat.muni_id,
    anl_mincut_result_cat.postcode,
    anl_mincut_result_cat.streetaxis_id,
    anl_mincut_result_cat.postnumber,
    anl_mincut_result_cat.anl_cause,
    anl_mincut_result_cat.anl_tstamp,
    anl_mincut_result_cat.anl_user,
    anl_mincut_result_cat.anl_descript,
    anl_mincut_result_cat.anl_feature_id,
    anl_mincut_result_cat.anl_feature_type,
    anl_mincut_result_cat.anl_the_geom,
    anl_mincut_result_cat.forecast_start,
    anl_mincut_result_cat.forecast_end,
    anl_mincut_result_cat.assigned_to,
    anl_mincut_result_cat.exec_start,
    anl_mincut_result_cat.exec_end,
    anl_mincut_result_cat.exec_user,
    anl_mincut_result_cat.exec_descript,
    anl_mincut_result_cat.exec_the_geom,
    anl_mincut_result_cat.exec_from_plot,
    anl_mincut_result_cat.exec_depth,
    anl_mincut_result_cat.exec_appropiate
   FROM anl_mincut_result_cat
     LEFT JOIN anl_mincut_cat_class ON anl_mincut_cat_class.id = anl_mincut_result_cat.mincut_class
     LEFT JOIN anl_mincut_cat_state ON anl_mincut_cat_state.id = anl_mincut_result_cat.mincut_state;




-----------------------
-- create inp views
-----------------------


DROP VIEW IF EXISTS vi_title CASCADE;
CREATE OR REPLACE VIEW vi_title AS 
 SELECT inp_project_id.title,
    inp_project_id.date
   FROM inp_project_id
  ORDER BY inp_project_id.title;


DROP VIEW IF EXISTS vi_junctions CASCADE;
CREATE OR REPLACE VIEW vi_junctions AS 
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation,
    rpt_inp_node.demand,
    inp_junction.pattern_id
   FROM inp_selector_result,   rpt_inp_node
   LEFT JOIN inp_junction ON inp_junction.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.epa_type::text = 'JUNCTION'::text AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
  ORDER BY rpt_inp_node.node_id;


DROP VIEW IF EXISTS vi_reservoirs CASCADE;
CREATE OR REPLACE VIEW vi_reservoirs AS 
 SELECT inp_reservoir.node_id,
    rpt_inp_node.elevation AS head,
    inp_reservoir.pattern_id
   FROM inp_selector_result, inp_reservoir
   JOIN rpt_inp_node ON inp_reservoir.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_tanks CASCADE;
CREATE OR REPLACE VIEW vi_tanks AS 
 SELECT inp_tank.node_id,
    rpt_inp_node.elevation,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id
   FROM inp_selector_result, inp_tank
   JOIN rpt_inp_node ON inp_tank.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_pipes CASCADE;
CREATE OR REPLACE VIEW vi_pipes AS 
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.length,
    rpt_inp_arc.diameter,
    rpt_inp_arc.roughness,
    inp_pipe.minorloss,
    inp_typevalue.idval as status
   FROM inp_selector_result, rpt_inp_arc
   JOIN inp_pipe ON rpt_inp_arc.arc_id::text = inp_pipe.arc_id::text
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_pipe.status
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text 
  AND inp_typevalue.typevalue='inp_value_status_pipe'
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.length,
    rpt_inp_arc.diameter,
    rpt_inp_arc.roughness,
    inp_shortpipe.minorloss,
    inp_typevalue.idval as status
   FROM inp_selector_result, rpt_inp_arc
   JOIN inp_shortpipe ON rpt_inp_arc.arc_id::text = concat(inp_shortpipe.node_id, '_n2a')
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_shortpipe.status
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
  AND inp_typevalue.typevalue='inp_value_status_pipe';


CREATE OR REPLACE VIEW vi_pumps AS 
 SELECT concat(inp_pump.node_id, '_n2a') AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    concat('POWER '::text || inp_pump.power::text) AS power,
    concat('HEAD '::text || inp_pump.curve_id::text) AS curve_id,
    concat('SPEED '::text || inp_pump.speed) AS speed,
    concat('PATTERN '::text || inp_pump.pattern::text) AS pattern
   FROM inp_selector_result,
    inp_pump
     JOIN rpt_inp_arc ON rpt_inp_arc.arc_id::text = concat(inp_pump.node_id, '_n2a')
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_valves CASCADE;
CREATE OR REPLACE VIEW vi_valves AS 
SELECT concat(inp_valve.node_id, '_n2a') AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    inp_valve.valv_type,
    inp_valve.pressure::text AS setting,
    inp_valve.minorloss
   FROM inp_selector_result,rpt_inp_arc
     JOIN inp_valve ON rpt_inp_arc.arc_id::text = concat(inp_valve.node_id, '_n2a')
  WHERE (inp_valve.valv_type::text = 'PRV'::text OR inp_valve.valv_type::text = 'PSV'::text OR inp_valve.valv_type::text = 'PBV'::text) 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT concat(inp_valve.node_id, '_n2a') AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    inp_valve.valv_type,
    inp_valve.flow::text AS setting,
    inp_valve.minorloss
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_valve ON rpt_inp_arc.arc_id::text = concat(inp_valve.node_id, '_n2a')
  WHERE inp_valve.valv_type::text = 'FCV'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT concat(inp_valve.node_id, '_n2a') AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    inp_valve.valv_type,
    inp_valve.coef_loss::text AS setting,
    inp_valve.minorloss
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_valve ON rpt_inp_arc.arc_id::text = concat(inp_valve.node_id, '_n2a')
  WHERE inp_valve.valv_type::text = 'TCV'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT concat(inp_valve.node_id, '_n2a') AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    cat_arc.dint AS diameter,
    inp_valve.valv_type,
    inp_valve.curve_id::text AS setting,
    inp_valve.minorloss
   FROM inp_selector_result, rpt_inp_arc
    JOIN inp_valve ON rpt_inp_arc.arc_id::text = concat(inp_valve.node_id, '_n2a')
    JOIN cat_arc ON rpt_inp_arc.arccat_id::text = cat_arc.id::text
WHERE inp_valve.valv_type::text = 'GPV'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
AND inp_selector_result.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS vi_tags CASCADE;
CREATE OR REPLACE VIEW vi_tags AS 
SELECT inp_tags.object,
   inp_tags.node_id,
   inp_tags.tag
FROM inp_tags
ORDER BY inp_tags.object;

DROP VIEW IF EXISTS vi_demands CASCADE;
CREATE OR REPLACE VIEW vi_demands AS 
SELECT inp_demand.node_id,
   inp_demand.demand,
   inp_demand.pattern_id,
   inp_demand.deman_type
 FROM inp_selector_dscenario, inp_selector_result, inp_demand
 JOIN rpt_inp_node ON inp_demand.node_id::text = rpt_inp_node.node_id::text
WHERE inp_selector_dscenario.dscenario_id = inp_demand.dscenario_id AND inp_selector_dscenario.cur_user = "current_user"()::text 
AND inp_selector_result.result_id::text = rpt_inp_node.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_status CASCADE;
CREATE OR REPLACE VIEW vi_status AS 
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.status
   FROM inp_selector_result,  rpt_inp_arc
     JOIN inp_valve ON rpt_inp_arc.arc_id::text = concat(inp_valve.node_id, '_n2a')
  WHERE rpt_inp_arc.status::text = 'OPEN'::text OR rpt_inp_arc.status::text = 'CLOSED'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_pump.status
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_pump ON rpt_inp_arc.arc_id::text = concat(inp_pump.node_id, '_n2a')
  WHERE inp_pump.status::text = 'OPEN'::text OR inp_pump.status::text = 'CLOSED'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text
   AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_pump_additional.status
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_pump_additional ON rpt_inp_arc.arc_id::text = concat(inp_pump_additional.node_id, '_n2a', inp_pump_additional.order_id)
  WHERE inp_pump_additional.status::text = 'OPEN'::text OR inp_pump_additional.status::text = 'CLOSED'::text 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_patterns CASCADE;
CREATE OR REPLACE VIEW vi_patterns AS 
 SELECT inp_pattern_value.pattern_id,
    concat(inp_pattern_value.factor_1,' ',inp_pattern_value.factor_2,' ',inp_pattern_value.factor_3,' ',inp_pattern_value.factor_4,' ',
    inp_pattern_value.factor_5,' ',inp_pattern_value.factor_6,' ',inp_pattern_value.factor_7,' ',inp_pattern_value.factor_8,' ',
    inp_pattern_value.factor_9,' ',inp_pattern_value.factor_10,' ',inp_pattern_value.factor_11,' ', inp_pattern_value.factor_12,' ',
    inp_pattern_value.factor_13,' ', inp_pattern_value.factor_14,' ',inp_pattern_value.factor_15,' ', inp_pattern_value.factor_16,' ',
    inp_pattern_value.factor_17,' ', inp_pattern_value.factor_18,' ',inp_pattern_value.factor_19,' ',inp_pattern_value.factor_20,' ',
    inp_pattern_value.factor_21,' ',inp_pattern_value.factor_22,' ',inp_pattern_value.factor_23,' ',inp_pattern_value.factor_24) as multipliers
   FROM inp_pattern_value
  ORDER BY inp_pattern_value.pattern_id;


DROP VIEW IF EXISTS vi_curves CASCADE;
CREATE OR REPLACE VIEW vi_curves AS 
SELECT
        CASE
            WHEN a.x_value IS NULL THEN a.curve_type::character varying(16)
            ELSE a.curve_id
        END AS curve_id,
    a.x_value::numeric(12,4) AS x_value,
    a.y_value::numeric(12,4) AS y_value
   FROM ( SELECT DISTINCT ON (inp_curve.curve_id) ( SELECT min(sub.id) AS min
                   FROM inp_curve sub
                  WHERE sub.curve_id::text = inp_curve.curve_id::text) AS id,
            inp_curve.curve_id,
            concat(';', inp_curve_id.curve_type, ':') AS curve_type,
            NULL::numeric AS x_value,
            NULL::numeric AS y_value
           FROM inp_curve_id
             JOIN inp_curve ON inp_curve.curve_id::text = inp_curve_id.id::text
        UNION
         SELECT inp_curve.id,
            inp_curve.curve_id,
            inp_curve_id.curve_type,
            inp_curve.x_value,
            inp_curve.y_value
           FROM inp_curve
             JOIN inp_curve_id ON inp_curve.curve_id::text = inp_curve_id.id::text
  ORDER BY 1, 4 DESC) a;


DROP VIEW IF EXISTS vi_controls CASCADE;
CREATE OR REPLACE VIEW vi_controls AS 
 SELECT  inp_controls_x_arc.text
   FROM inp_selector_result,  inp_controls_x_arc
     JOIN rpt_inp_arc ON inp_controls_x_arc.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE inp_selector_result.result_id::text = rpt_inp_arc.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT inp_controls_x_node.text
   FROM inp_selector_result, inp_controls_x_node
   JOIN rpt_inp_node ON inp_controls_x_node.node_id::text = rpt_inp_node.node_id::text
  WHERE inp_selector_result.result_id::text = rpt_inp_node.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_rules CASCADE;
CREATE OR REPLACE VIEW vi_rules AS 
 SELECT inp_rules_x_arc.text
   FROM inp_selector_result,  inp_rules_x_arc
     JOIN rpt_inp_arc ON inp_rules_x_arc.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE inp_selector_result.result_id::text = rpt_inp_arc.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT inp_rules_x_node.text
   FROM inp_selector_result, inp_rules_x_node
   JOIN rpt_inp_node ON inp_rules_x_node.node_id::text = rpt_inp_node.node_id::text
  WHERE inp_selector_result.result_id::text = rpt_inp_node.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS vi_energy CASCADE;
CREATE OR REPLACE VIEW vi_energy AS 
 SELECT 
    inp_energy_el.parameter,
    inp_energy_el.value
   FROM inp_selector_result, inp_energy_el
     JOIN rpt_inp_node ON inp_energy_el.pump_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
  UNION
 SELECT
    inp_energy_gl.parameter,
    inp_energy_gl.value
   FROM inp_energy_gl;



DROP VIEW IF EXISTS vi_emitters CASCADE;
CREATE OR REPLACE VIEW vi_emitters AS 
 SELECT inp_emitter.node_id,
    inp_emitter.coef
    FROM inp_selector_result, inp_emitter
     JOIN rpt_inp_node ON inp_emitter.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS vi_quality CASCADE;
CREATE OR REPLACE VIEW vi_quality AS 
 SELECT inp_quality.node_id,
    inp_quality.initqual
   FROM inp_quality
  ORDER BY inp_quality.node_id;


DROP VIEW IF EXISTS vi_sources CASCADE;
CREATE OR REPLACE VIEW vi_sources AS 
 SELECT inp_source.node_id,
    inp_source.sourc_type,
    inp_source.quality,
    inp_source.pattern_id
   FROM inp_selector_result,  inp_source
     JOIN rpt_inp_node ON inp_source.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_reactions;
CREATE OR REPLACE VIEW vi_reactions AS 
 SELECT inp_typevalue_react.idval AS react_type,
    inp_typevalue_param.idval AS parameter,
    inp_reactions_gl.value
   FROM inp_reactions_gl
     LEFT JOIN inp_typevalue inp_typevalue_react ON inp_reactions_gl.react_type::text = inp_typevalue_react.id::text AND inp_typevalue_react.typevalue::text = 'inp_typevalue_reactions_gl'::text
     LEFT JOIN inp_typevalue inp_typevalue_param ON inp_reactions_gl.parameter::text = inp_typevalue_param.id::text AND inp_typevalue_param.typevalue::text = 'inp_value_reactions_gl'::text
UNION
 SELECT inp_typevalue_param.idval AS react_type,
    inp_reactions_el.arc_id AS parameter,
    inp_reactions_el.value
   FROM inp_selector_result,
    inp_reactions_el
     JOIN rpt_inp_arc ON inp_reactions_el.arc_id::text = rpt_inp_arc.arc_id::text
     LEFT JOIN inp_typevalue inp_typevalue_param ON inp_reactions_el.parameter::text = inp_typevalue_param.id::text AND inp_typevalue_param.typevalue::text = 'inp_value_reactions_el'::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS vi_mixing CASCADE;
CREATE OR REPLACE VIEW vi_mixing AS 
 SELECT inp_mixing.node_id,
    inp_mixing.mix_type,
    inp_mixing.value
   FROM inp_selector_result,
    inp_mixing
     JOIN rpt_inp_node ON inp_mixing.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_times CASCADE;
CREATE OR REPLACE VIEW vi_times AS 
 SELECT 
unnest(array['duration','hydraulic timestep','quality timestep','rule timestep','pattern timestep','pattern start','report timeste',
    'report start','start clocktime','statistic']) as "parameter",
unnest(array[inp_times.duration::text,inp_times.hydraulic_timestep,inp_times.quality_timestep,inp_times.rule_timestep,inp_times.pattern_timestep,
    inp_times.pattern_start,inp_times.report_timestep,inp_times.report_start,inp_times.start_clocktime,inp_typevalue.idval]) as "value"
   FROM inp_times
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_times.statistic
   WHERE inp_typevalue.typevalue='inp_value_times';


DROP VIEW IF EXISTS vi_report CASCADE;
CREATE OR REPLACE VIEW vi_report AS 
 SELECT unnest(array['pagesize','status','summary','energy','nodes','links','elevation','demand','head','pressure','quality','length',
        'diameter','flow','velocity','headloss','setting','reaction','f_factor']) as "parameter",
        unnest(array[inp_report.pagesize::text,inp_typevalue.idval, inp_report.summary, inp_report.energy, inp_report.nodes, inp_report.links,
        inp_report.elevation, inp_report.demand, inp_report.head, inp_report.pressure, inp_report.quality, inp_report.length, inp_report.diameter, 
        inp_report.flow, inp_report.velocity, inp_report.headloss, inp_report.setting, inp_report.reaction, inp_report.f_factor]) as "value"
   FROM inp_report
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_report.status
   WHERE inp_typevalue.typevalue='inp_value_yesnofull';


DROP VIEW IF EXISTS vi_options CASCADE;
CREATE OR REPLACE VIEW vi_options AS 
SELECT
   unnest(array['units','headloss','hydraulics','specific gravity','viscosity','trials','accuracy','unbalanced','checkfreq','maxcheck','damplimit','pattern','demand multiplier','emitter exponent','quality',
   'diffusivity','tolerance']) as "parameter",
      unnest(array[units, headloss,((inp_options.hydraulics::text || ' '::text) || inp_options.hydraulics_fname::text),specific_gravity::text, viscosity::text,trials::text,accuracy::text,((inp_options.unbalanced::text || ' '::text) || inp_options.unbalanced_n),
   checkfreq::text, maxcheck::text, damplimit::text, pattern, demand_multiplier::text, emitter_exponent::text,inp_typevalue.idval, diffusivity::text,tolerance::text]) as "value"
   FROM inp_options 
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_options.quality
   WHERE inp_typevalue.typevalue='inp_value_opti_qual'
   AND quality!='TRACE'
  UNION
SELECT
   unnest(array['units','headloss','hydraulics','specific gravity','viscosity','trials','accuracy','unbalanced','checkfreq','maxcheck','damplimit','pattern','demand multiplier','emitter exponent','quality',
   'diffusivity','tolerance']) as "parameter",
      unnest(array[units, headloss,((inp_options.hydraulics::text || ' '::text) || inp_options.hydraulics_fname::text),specific_gravity::text,viscosity::text,trials::text,accuracy::text,((inp_options.unbalanced::text || ' '::text) || inp_options.unbalanced_n),
   checkfreq::text, maxcheck::text, damplimit::text, pattern, demand_multiplier::text, emitter_exponent::text,((inp_typevalue.idval::text || ' '::text) || inp_options.node_id::text) ,diffusivity::text,tolerance::text]) as "value"
   FROM inp_options 
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_options.quality
   WHERE inp_typevalue.typevalue='inp_value_opti_qual'
   AND quality='TRACE';

DROP VIEW IF EXISTS vi_coordinates CASCADE;
CREATE OR REPLACE VIEW vi_coordinates AS 
SELECT  rpt_inp_node.node_id,
    st_x(rpt_inp_node.the_geom)::numeric(16,3) AS xcoord,
    st_y(rpt_inp_node.the_geom)::numeric(16,3) AS ycoord
FROM rpt_inp_node;


DROP VIEW IF EXISTS vi_vertices CASCADE;
CREATE OR REPLACE VIEW vi_vertices AS 
 SELECT arc.arc_id,
    st_x(arc.point)::numeric(16,3) AS xcoord,
    st_y(arc.point)::numeric(16,3) AS ycoord
   FROM ( SELECT (st_dumppoints(rpt_inp_arc.the_geom)).geom AS point,
            st_startpoint(rpt_inp_arc.the_geom) AS startpoint,
            st_endpoint(rpt_inp_arc.the_geom) AS endpoint,
            rpt_inp_arc.sector_id,
            rpt_inp_arc.arc_id
           FROM inp_selector_result,
            rpt_inp_arc
          WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text) arc
  WHERE (arc.point < arc.startpoint OR arc.point > arc.startpoint) AND (arc.point < arc.endpoint OR arc.point > arc.endpoint);


DROP VIEW IF EXISTS vi_labels CASCADE;
CREATE OR REPLACE VIEW vi_labels AS 
 SELECT  inp_label.xcoord,
    inp_label.ycoord,
    inp_label.label,
    inp_label.node_id
   FROM inp_label;

DROP VIEW IF EXISTS vi_backdrop CASCADE;
CREATE OR REPLACE VIEW vi_backdrop AS 
 SELECT  inp_backdrop.text
   FROM inp_backdrop;



-- ----------------------------
-- View structure for v_inp
-- ----------------------------

DROP VIEW IF EXISTS vi_title CASCADE;
CREATE OR REPLACE VIEW vi_title AS 
 SELECT inp_project_id.title,
    inp_project_id.date
   FROM inp_project_id
  ORDER BY inp_project_id.title;


DROP VIEW IF EXISTS vi_junctions CASCADE;
CREATE OR REPLACE VIEW vi_junctions AS 
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation,
    rpt_inp_node.demand,
    inp_junction.pattern_id
   FROM inp_selector_result,   rpt_inp_node
   LEFT JOIN inp_junction ON inp_junction.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.epa_type::text = 'JUNCTION'::text AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
  ORDER BY rpt_inp_node.node_id;


DROP VIEW IF EXISTS vi_reservoirs CASCADE;
CREATE OR REPLACE VIEW vi_reservoirs AS 
 SELECT inp_reservoir.node_id,
    rpt_inp_node.elevation AS head,
    inp_reservoir.pattern_id
   FROM inp_selector_result, inp_reservoir
   JOIN rpt_inp_node ON inp_reservoir.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_tanks CASCADE;
CREATE OR REPLACE VIEW vi_tanks AS 
 SELECT inp_tank.node_id,
    rpt_inp_node.elevation,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id
   FROM inp_selector_result, inp_tank
   JOIN rpt_inp_node ON inp_tank.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_pipes CASCADE;
CREATE OR REPLACE VIEW vi_pipes AS 
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.length,
    rpt_inp_arc.diameter,
    rpt_inp_arc.roughness,
    inp_pipe.minorloss,
    inp_typevalue.idval as status
   FROM inp_selector_result, rpt_inp_arc
   JOIN inp_pipe ON rpt_inp_arc.arc_id::text = inp_pipe.arc_id::text
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_pipe.status
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text 
  AND inp_typevalue.typevalue='inp_value_status_pipe'
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.length,
    rpt_inp_arc.diameter,
    rpt_inp_arc.roughness,
    inp_shortpipe.minorloss,
    inp_typevalue.idval as status
   FROM inp_selector_result, rpt_inp_arc
   JOIN inp_shortpipe ON rpt_inp_arc.arc_id::text = concat(inp_shortpipe.node_id, '_n2a')
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_shortpipe.status
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
  AND inp_typevalue.typevalue='inp_value_status_pipe';


CREATE OR REPLACE VIEW vi_pumps AS 
 SELECT concat(inp_pump.node_id, '_n2a') AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    concat('POWER '::text || inp_pump.power::text) AS power,
    concat('HEAD '::text || inp_pump.curve_id::text) AS curve_id,
    concat('SPEED '::text || inp_pump.speed) AS speed,
    concat('PATTERN '::text || inp_pump.pattern::text) AS pattern
   FROM inp_selector_result,
    inp_pump
     JOIN rpt_inp_arc ON rpt_inp_arc.arc_id::text = concat(inp_pump.node_id, '_n2a')
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_valves CASCADE;
CREATE OR REPLACE VIEW vi_valves AS 
SELECT concat(inp_valve.node_id, '_n2a') AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    inp_valve.valv_type,
    inp_valve.pressure::text AS setting,
    inp_valve.minorloss
   FROM inp_selector_result,rpt_inp_arc
     JOIN inp_valve ON rpt_inp_arc.arc_id::text = concat(inp_valve.node_id, '_n2a')
  WHERE (inp_valve.valv_type::text = 'PRV'::text OR inp_valve.valv_type::text = 'PSV'::text OR inp_valve.valv_type::text = 'PBV'::text) 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT concat(inp_valve.node_id, '_n2a') AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    inp_valve.valv_type,
    inp_valve.flow::text AS setting,
    inp_valve.minorloss
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_valve ON rpt_inp_arc.arc_id::text = concat(inp_valve.node_id, '_n2a')
  WHERE inp_valve.valv_type::text = 'FCV'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT concat(inp_valve.node_id, '_n2a') AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    inp_valve.valv_type,
    inp_valve.coef_loss::text AS setting,
    inp_valve.minorloss
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_valve ON rpt_inp_arc.arc_id::text = concat(inp_valve.node_id, '_n2a')
  WHERE inp_valve.valv_type::text = 'TCV'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT concat(inp_valve.node_id, '_n2a') AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    cat_arc.dint AS diameter,
    inp_valve.valv_type,
    inp_valve.curve_id::text AS setting,
    inp_valve.minorloss
   FROM inp_selector_result, rpt_inp_arc
    JOIN inp_valve ON rpt_inp_arc.arc_id::text = concat(inp_valve.node_id, '_n2a')
    JOIN cat_arc ON rpt_inp_arc.arccat_id::text = cat_arc.id::text
WHERE inp_valve.valv_type::text = 'GPV'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
AND inp_selector_result.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS vi_tags CASCADE;
CREATE OR REPLACE VIEW vi_tags AS 
SELECT inp_tags.object,
   inp_tags.node_id,
   inp_tags.tag
FROM inp_tags
ORDER BY inp_tags.object;

DROP VIEW IF EXISTS vi_demands CASCADE;
CREATE OR REPLACE VIEW vi_demands AS 
SELECT inp_demand.node_id,
   inp_demand.demand,
   inp_demand.pattern_id,
   inp_demand.deman_type
 FROM inp_selector_dscenario, inp_selector_result, inp_demand
 JOIN rpt_inp_node ON inp_demand.node_id::text = rpt_inp_node.node_id::text
WHERE inp_selector_dscenario.dscenario_id = inp_demand.dscenario_id AND inp_selector_dscenario.cur_user = "current_user"()::text 
AND inp_selector_result.result_id::text = rpt_inp_node.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_status CASCADE;
CREATE OR REPLACE VIEW vi_status AS 
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.status
   FROM inp_selector_result,  rpt_inp_arc
     JOIN inp_valve ON rpt_inp_arc.arc_id::text = concat(inp_valve.node_id, '_n2a')
  WHERE rpt_inp_arc.status::text = 'OPEN'::text OR rpt_inp_arc.status::text = 'CLOSED'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_pump.status
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_pump ON rpt_inp_arc.arc_id::text = concat(inp_pump.node_id, '_n2a')
  WHERE inp_pump.status::text = 'OPEN'::text OR inp_pump.status::text = 'CLOSED'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text
   AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_pump_additional.status
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_pump_additional ON rpt_inp_arc.arc_id::text = concat(inp_pump_additional.node_id, '_n2a', inp_pump_additional.order_id)
  WHERE inp_pump_additional.status::text = 'OPEN'::text OR inp_pump_additional.status::text = 'CLOSED'::text 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_patterns CASCADE;
CREATE OR REPLACE VIEW vi_patterns AS 
 SELECT inp_pattern_value.pattern_id,
    concat(inp_pattern_value.factor_1,' ',inp_pattern_value.factor_2,' ',inp_pattern_value.factor_3,' ',inp_pattern_value.factor_4,' ',
    inp_pattern_value.factor_5,' ',inp_pattern_value.factor_6,' ',inp_pattern_value.factor_7,' ',inp_pattern_value.factor_8,' ',
    inp_pattern_value.factor_9,' ',inp_pattern_value.factor_10,' ',inp_pattern_value.factor_11,' ', inp_pattern_value.factor_12,' ',
    inp_pattern_value.factor_13,' ', inp_pattern_value.factor_14,' ',inp_pattern_value.factor_15,' ', inp_pattern_value.factor_16,' ',
    inp_pattern_value.factor_17,' ', inp_pattern_value.factor_18,' ',inp_pattern_value.factor_19,' ',inp_pattern_value.factor_20,' ',
    inp_pattern_value.factor_21,' ',inp_pattern_value.factor_22,' ',inp_pattern_value.factor_23,' ',inp_pattern_value.factor_24) as multipliers
   FROM inp_pattern_value
  ORDER BY inp_pattern_value.pattern_id;


DROP VIEW IF EXISTS vi_curves CASCADE;
CREATE OR REPLACE VIEW vi_curves AS 
SELECT
        CASE
            WHEN a.x_value IS NULL THEN a.curve_type::character varying(16)
            ELSE a.curve_id
        END AS curve_id,
    a.x_value::numeric(12,4) AS x_value,
    a.y_value::numeric(12,4) AS y_value
   FROM ( SELECT DISTINCT ON (inp_curve.curve_id) ( SELECT min(sub.id) AS min
                   FROM inp_curve sub
                  WHERE sub.curve_id::text = inp_curve.curve_id::text) AS id,
            inp_curve.curve_id,
            concat(';', inp_curve_id.curve_type, ':') AS curve_type,
            NULL::numeric AS x_value,
            NULL::numeric AS y_value
           FROM inp_curve_id
             JOIN inp_curve ON inp_curve.curve_id::text = inp_curve_id.id::text
        UNION
         SELECT inp_curve.id,
            inp_curve.curve_id,
            inp_curve_id.curve_type,
            inp_curve.x_value,
            inp_curve.y_value
           FROM inp_curve
             JOIN inp_curve_id ON inp_curve.curve_id::text = inp_curve_id.id::text
  ORDER BY 1, 4 DESC) a;


DROP VIEW IF EXISTS vi_controls CASCADE;
CREATE OR REPLACE VIEW vi_controls AS 
 SELECT  inp_controls_x_arc.text
   FROM inp_selector_result,  inp_controls_x_arc
     JOIN rpt_inp_arc ON inp_controls_x_arc.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE inp_selector_result.result_id::text = rpt_inp_arc.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT inp_controls_x_node.text
   FROM inp_selector_result, inp_controls_x_node
   JOIN rpt_inp_node ON inp_controls_x_node.node_id::text = rpt_inp_node.node_id::text
  WHERE inp_selector_result.result_id::text = rpt_inp_node.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_rules CASCADE;
CREATE OR REPLACE VIEW vi_rules AS 
 SELECT inp_rules_x_arc.text
   FROM inp_selector_result,  inp_rules_x_arc
     JOIN rpt_inp_arc ON inp_rules_x_arc.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE inp_selector_result.result_id::text = rpt_inp_arc.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT inp_rules_x_node.text
   FROM inp_selector_result, inp_rules_x_node
   JOIN rpt_inp_node ON inp_rules_x_node.node_id::text = rpt_inp_node.node_id::text
  WHERE inp_selector_result.result_id::text = rpt_inp_node.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS vi_energy CASCADE;
CREATE OR REPLACE VIEW vi_energy AS 
 SELECT 
    inp_energy_el.parameter,
    inp_energy_el.value
   FROM inp_selector_result, inp_energy_el
     JOIN rpt_inp_node ON inp_energy_el.pump_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
  UNION
 SELECT
    inp_energy_gl.parameter,
    inp_energy_gl.value
   FROM inp_energy_gl;



DROP VIEW IF EXISTS vi_emitters CASCADE;
CREATE OR REPLACE VIEW vi_emitters AS 
 SELECT inp_emitter.node_id,
    inp_emitter.coef
    FROM inp_selector_result, inp_emitter
     JOIN rpt_inp_node ON inp_emitter.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS vi_quality CASCADE;
CREATE OR REPLACE VIEW vi_quality AS 
 SELECT inp_quality.node_id,
    inp_quality.initqual
   FROM inp_quality
  ORDER BY inp_quality.node_id;


DROP VIEW IF EXISTS vi_sources CASCADE;
CREATE OR REPLACE VIEW vi_sources AS 
 SELECT inp_source.node_id,
    inp_source.sourc_type,
    inp_source.quality,
    inp_source.pattern_id
   FROM inp_selector_result,  inp_source
     JOIN rpt_inp_node ON inp_source.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_reactions;
CREATE OR REPLACE VIEW vi_reactions AS 
 SELECT inp_typevalue_react.idval AS react_type,
    inp_typevalue_param.idval AS parameter,
    inp_reactions_gl.value
   FROM inp_reactions_gl
     LEFT JOIN inp_typevalue inp_typevalue_react ON inp_reactions_gl.react_type::text = inp_typevalue_react.id::text AND inp_typevalue_react.typevalue::text = 'inp_typevalue_reactions_gl'::text
     LEFT JOIN inp_typevalue inp_typevalue_param ON inp_reactions_gl.parameter::text = inp_typevalue_param.id::text AND inp_typevalue_param.typevalue::text = 'inp_value_reactions_gl'::text
UNION
 SELECT inp_typevalue_param.idval AS react_type,
    inp_reactions_el.arc_id AS parameter,
    inp_reactions_el.value
   FROM inp_selector_result,
    inp_reactions_el
     JOIN rpt_inp_arc ON inp_reactions_el.arc_id::text = rpt_inp_arc.arc_id::text
     LEFT JOIN inp_typevalue inp_typevalue_param ON inp_reactions_el.parameter::text = inp_typevalue_param.id::text AND inp_typevalue_param.typevalue::text = 'inp_value_reactions_el'::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS vi_mixing CASCADE;
CREATE OR REPLACE VIEW vi_mixing AS 
 SELECT inp_mixing.node_id,
    inp_mixing.mix_type,
    inp_mixing.value
   FROM inp_selector_result,
    inp_mixing
     JOIN rpt_inp_node ON inp_mixing.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS vi_times CASCADE;
CREATE OR REPLACE VIEW vi_times AS 
 SELECT 
unnest(array['duration','hydraulic timestep','quality timestep','rule timestep','pattern timestep','pattern start','report timeste',
    'report start','start clocktime','statistic']) as "parameter",
unnest(array[inp_times.duration::text,inp_times.hydraulic_timestep,inp_times.quality_timestep,inp_times.rule_timestep,inp_times.pattern_timestep,
    inp_times.pattern_start,inp_times.report_timestep,inp_times.report_start,inp_times.start_clocktime,inp_typevalue.idval]) as "value"
   FROM inp_times
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_times.statistic
   WHERE inp_typevalue.typevalue='inp_value_times';


DROP VIEW IF EXISTS vi_report CASCADE;
CREATE OR REPLACE VIEW vi_report AS 
 SELECT unnest(array['pagesize','status','summary','energy','nodes','links','elevation','demand','head','pressure','quality','length',
        'diameter','flow','velocity','headloss','setting','reaction','f_factor']) as "parameter",
        unnest(array[inp_report.pagesize::text,inp_typevalue.idval, inp_report.summary, inp_report.energy, inp_report.nodes, inp_report.links,
        inp_report.elevation, inp_report.demand, inp_report.head, inp_report.pressure, inp_report.quality, inp_report.length, inp_report.diameter, 
        inp_report.flow, inp_report.velocity, inp_report.headloss, inp_report.setting, inp_report.reaction, inp_report.f_factor]) as "value"
   FROM inp_report
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_report.status
   WHERE inp_typevalue.typevalue='inp_value_yesnofull';


DROP VIEW IF EXISTS vi_options CASCADE;
CREATE OR REPLACE VIEW vi_options AS 
SELECT
   unnest(array['units','headloss','hydraulics','specific gravity','viscosity','trials','accuracy','unbalanced','checkfreq','maxcheck','damplimit','pattern','demand multiplier','emitter exponent','quality',
   'diffusivity','tolerance']) as "parameter",
      unnest(array[units, headloss,((inp_options.hydraulics::text || ' '::text) || inp_options.hydraulics_fname::text),specific_gravity::text, viscosity::text,trials::text,accuracy::text,((inp_options.unbalanced::text || ' '::text) || inp_options.unbalanced_n),
   checkfreq::text, maxcheck::text, damplimit::text, pattern, demand_multiplier::text, emitter_exponent::text,inp_typevalue.idval, diffusivity::text,tolerance::text]) as "value"
   FROM inp_options 
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_options.quality
   WHERE inp_typevalue.typevalue='inp_value_opti_qual'
   AND quality!='TRACE'
  UNION
SELECT
   unnest(array['units','headloss','hydraulics','specific gravity','viscosity','trials','accuracy','unbalanced','checkfreq','maxcheck','damplimit','pattern','demand multiplier','emitter exponent','quality',
   'diffusivity','tolerance']) as "parameter",
      unnest(array[units, headloss,((inp_options.hydraulics::text || ' '::text) || inp_options.hydraulics_fname::text),specific_gravity::text,viscosity::text,trials::text,accuracy::text,((inp_options.unbalanced::text || ' '::text) || inp_options.unbalanced_n),
   checkfreq::text, maxcheck::text, damplimit::text, pattern, demand_multiplier::text, emitter_exponent::text,((inp_typevalue.idval::text || ' '::text) || inp_options.node_id::text) ,diffusivity::text,tolerance::text]) as "value"
   FROM inp_options 
   LEFT JOIN inp_typevalue ON inp_typevalue.id=inp_options.quality
   WHERE inp_typevalue.typevalue='inp_value_opti_qual'
   AND quality='TRACE';

DROP VIEW IF EXISTS vi_coordinates CASCADE;
CREATE OR REPLACE VIEW vi_coordinates AS 
SELECT  rpt_inp_node.node_id,
    st_x(rpt_inp_node.the_geom)::numeric(16,3) AS xcoord,
    st_y(rpt_inp_node.the_geom)::numeric(16,3) AS ycoord
FROM rpt_inp_node;


DROP VIEW IF EXISTS vi_vertices CASCADE;
CREATE OR REPLACE VIEW vi_vertices AS 
 SELECT arc.arc_id,
    st_x(arc.point)::numeric(16,3) AS xcoord,
    st_y(arc.point)::numeric(16,3) AS ycoord
   FROM ( SELECT (st_dumppoints(rpt_inp_arc.the_geom)).geom AS point,
            st_startpoint(rpt_inp_arc.the_geom) AS startpoint,
            st_endpoint(rpt_inp_arc.the_geom) AS endpoint,
            rpt_inp_arc.sector_id,
            rpt_inp_arc.arc_id
           FROM inp_selector_result,
            rpt_inp_arc
          WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text) arc
  WHERE (arc.point < arc.startpoint OR arc.point > arc.startpoint) AND (arc.point < arc.endpoint OR arc.point > arc.endpoint);


DROP VIEW IF EXISTS vi_labels CASCADE;
CREATE OR REPLACE VIEW vi_labels AS 
 SELECT  inp_label.xcoord,
    inp_label.ycoord,
    inp_label.label,
    inp_label.node_id
   FROM inp_label;

DROP VIEW IF EXISTS vi_backdrop CASCADE;
CREATE OR REPLACE VIEW vi_backdrop AS 
 SELECT  inp_backdrop.text
   FROM inp_backdrop;