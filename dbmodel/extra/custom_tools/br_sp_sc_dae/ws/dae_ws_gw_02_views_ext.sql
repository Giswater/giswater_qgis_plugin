/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- EXTERNALS

CREATE VIEW gw_saa.ext_rtc_scada_x_value as
SELECT 
pea_id ,
    lei_stamp  ,
    msetor_id ,
    p1_mca  ,
    p2_mca  ,
    p3_mca  ,
    q_m3h  ,
    tot1_m3  ,
    q1m_m3h ,
    tot_dia_m3 
FROM  gcd_online_msetor;



CREATE OR REPLACE VIEW gw_saa.ext_hydrometer_category AS 
 SELECT vw_daecom_categorias.cod_categoria::text AS id,
    vw_daecom_categorias.categoria AS observ
   FROM vw_daecom_categorias;



CREATE OR REPLACE VIEW gw_saa.ext_cat_hydrometer AS 
 SELECT vw_daecom_hidrometro.cod_hidrometro AS id,
    vw_daecom_hidrometro.marca AS madeby,
    vw_daecom_hidrometro.classe AS class,
    vw_daecom_hidrometro.ulmc,
    vw_daecom_hidrometro.vazaovoltman AS voltman_flow,
    vw_daecom_hidrometro.vazaounimultijato AS multi_jet_flow,
    vw_daecom_hidrometro.diametromm AS dnom
   FROM vw_daecom_hidrometro;



CREATE OR REPLACE VIEW gw_saa.ext_client_hydrometer AS 
 SELECT vw_daecom_endereco.cod_dae AS hydrometer_id,
    vw_daecom_endereco.nome AS name,
    vw_daecom_endereco.telefone AS phone
   FROM vw_daecom_endereco;


CREATE OR REPLACE VIEW gw_saa.ext_rtc_hydrometer AS 
 SELECT vw_daecom_ligacao.cod_dae AS hydrometer_id,
    vw_daecom_ligacao.inscr_iptu AS code,
    vw_daecom_ligacao.cod_categoria AS hydrometer_category,
    vw_daecom_ligacao.qtd_economias AS house_number,
    vw_daecom_ligacao.num_caderno AS id_number,
    vw_daecom_ligacao.cod_hidrometro AS cat_hydrometer_id,
    vw_daecom_ligacao.num_hidrometro AS hydrometer_number,
    vw_daecom_ligacao.cnpjcpf AS identif
   FROM vw_daecom_ligacao;



CREATE OR REPLACE VIEW gw_saa.ext_streetaxis AS 
 SELECT DISTINCT eixos_de_logradouros.gid as id,
    eixos_de_logradouros.geom AS the_geom,
    eixos_de_logradouros.codigo_rua AS code_street,
    concat(vw_daecom_endereco.tipologr, ' ', vw_daecom_endereco.logr) AS name
   FROM sc_mbc.eixos_de_logradouros
     LEFT JOIN vw_daecom_endereco ON vw_daecom_endereco.cod_rua::text = eixos_de_logradouros.codigo_rua::text;


CREATE OR REPLACE VIEW gw_saa.ext_urban_propierties AS 
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

