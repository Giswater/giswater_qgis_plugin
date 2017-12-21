/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE VIEW gw_sdp.v_daescs_connec_search AS 
 SELECT DISTINCT connec.connec_id,
    connec.the_geom,
    rtc_hydrometer_x_connec.hydrometer_id,
    vw_daecom_endereco.cod_rua AS code_street,
    vw_daecom_endereco.numero AS num_portal
   FROM gw_saa.connec
     JOIN gw_saa.rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.connec_id::text = connec.connec_id::text
     JOIN vw_daecom_endereco ON rtc_hydrometer_x_connec.hydrometer_id::text = vw_daecom_endereco.cod_dae::text;

CREATE OR REPLACE VIEW gw_sdp.v_daescs_point AS 
 SELECT point.point_id,
    point.point_type,
    point.observ,
    point.text,
    point.the_geom,
    point.link,
    point.undelete
   FROM gw_saa.point;



   CREATE OR REPLACE VIEW gw_sdp.v_daescs_streetaxis AS 
 SELECT DISTINCT eixos_de_logradouros.gid AS id,
    eixos_de_logradouros.geom AS the_geom,
    eixos_de_logradouros.codigo_rua AS code_street,
    concat(vw_daecom_endereco.tipologr, ' ', vw_daecom_endereco.logr) AS name
   FROM sc_mbc.eixos_de_logradouros
     LEFT JOIN vw_daecom_endereco ON vw_daecom_endereco.cod_rua::text = eixos_de_logradouros.codigo_rua::text;



CREATE OR REPLACE VIEW gw_sdp.v_daescs_urban_propierties AS 
 SELECT lote.id,
    lote.geom AS the_geom,
    lote.iptu AS code,
    lote.bairro AS complement,
    lote.agua_setor AS placement,
    lote.agua_abast,
    lote.esg_bacia,
    lote.esg_subbac,
    lote.drn_bacia,
    lote.drn_subbac,
    lote.intrferenc,
    lote.link_lote AS postnumber,
    lote.zona::text AS zona,
    lote.quadra::text AS square,
    lote.lote::text AS lote,
    lote.cod_rua AS streetaxis,
    lote."Categoria" AS observ,
    lote."Nome" AS text
   FROM sc_mbc.lote;


   
CREATE OR REPLACE VIEW gw_sdp.v_daescs_ws_connec AS 
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
    cat_connec.svg AS svg,
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
   FROM gw_saa.connec
     JOIN gw_saa.cat_connec ON connec.connecat_id::text = cat_connec.id::text
     LEFT JOIN gw_saa.v_rtc_hydrometer_x_connec ON connec.connec_id::text = v_rtc_hydrometer_x_connec.connec_id::text
     LEFT JOIN gw_saa.ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN gw_saa.link ON connec.connec_id::text = link.connec_id::text
     LEFT JOIN gw_saa.vnode ON vnode.vnode_id::text = link.vnode_id::text
     LEFT JOIN gw_saa.dma ON connec.dma_id::text = dma.dma_id::text;



CREATE OR REPLACE VIEW gw_sdp.v_daescs_ws_hydrometer AS 
 SELECT rtc_hydrometer.hydrometer_id,
    rtc_hydrometer_x_connec.connec_id,
    connec.code AS urban_propierties_code,
    ext_rtc_hydrometer.code,
    ext_client_hydrometer.name,
    ext_client_hydrometer.phone,
    ext_rtc_hydrometer.hydrometer_category,
    ext_hydrometer_category.observ AS category,
    ext_rtc_hydrometer.house_number,
    ext_rtc_hydrometer.id_number,
    ext_rtc_hydrometer.cat_hydrometer_id,
    ext_rtc_hydrometer.hydrometer_number,
    ext_rtc_hydrometer.identif,
    ext_cat_hydrometer.id,
    ext_cat_hydrometer.madeby,
    ext_cat_hydrometer.class AS class_type,
    ext_cat_hydrometer.ulmc,
    ext_cat_hydrometer.voltman_flow,
    ext_cat_hydrometer.multi_jet_flow,
    ext_cat_hydrometer.dnom
   FROM gw_saa.rtc_hydrometer
     LEFT JOIN gw_saa.ext_client_hydrometer ON ext_client_hydrometer.hydrometer_id::text = rtc_hydrometer.hydrometer_id::text
     LEFT JOIN gw_saa.ext_rtc_hydrometer ON ext_rtc_hydrometer.hydrometer_id::text = rtc_hydrometer.hydrometer_id::text
     LEFT JOIN gw_saa.ext_cat_hydrometer ON ext_cat_hydrometer.id::text = ext_rtc_hydrometer.cat_hydrometer_id::text
     JOIN gw_saa.ext_hydrometer_category ON ext_hydrometer_category.id = ext_rtc_hydrometer.hydrometer_category::text
     JOIN gw_saa.rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::text = rtc_hydrometer.hydrometer_id::text
     JOIN gw_saa.connec ON rtc_hydrometer_x_connec.connec_id::text = connec.connec_id::text;