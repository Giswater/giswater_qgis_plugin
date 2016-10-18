/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/




CREATE OR REPLACE VIEW gw_saa.ext_hydrometer_category AS 
 SELECT vw_daecom_categorias.cod_categoria::text AS id,
    vw_daecom_categorias.categoria AS observ
   FROM vw_daecom_categorias;



CREATE OR REPLACE VIEW gw_saa.ext_cat_hydrometer AS 
 SELECT vw_daecom_hidrometro.cod_hidrometro AS hydrometer_id,
    vw_daecom_hidrometro.marca AS madeby,
    vw_daecom_hidrometro.classe AS class,
    vw_daecom_hidrometro.ulmc,
    vw_daecom_hidrometro.vazaovoltman AS voltman_flow,
    vw_daecom_hidrometro.vazaounimultijato AS multi_jet_flow,
    vw_daecom_hidrometro.diametromm AS dnom
   FROM vw_daecom_hidrometro;


