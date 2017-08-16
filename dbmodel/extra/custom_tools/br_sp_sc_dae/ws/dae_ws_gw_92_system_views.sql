/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- NEWS

CREATE OR REPLACE VIEW gw_saa.v_daescs_connec_search AS 
 SELECT DISTINCT connec.connec_id,
    connec.the_geom,
    rtc_hydrometer_x_connec.hydrometer_id,
    vw_daecom_endereco.cod_rua AS code_street,
    vw_daecom_endereco.numero AS num_portal
   FROM gw_saa.connec
     JOIN gw_saa.rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.connec_id::text = connec.connec_id::text
     JOIN vw_daecom_endereco ON rtc_hydrometer_x_connec.hydrometer_id::text = vw_daecom_endereco.cod_dae::text;



