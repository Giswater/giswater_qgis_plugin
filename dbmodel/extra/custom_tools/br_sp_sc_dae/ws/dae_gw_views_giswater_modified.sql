/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- GISWATER MODIFIED

CREATE OR REPLACE VIEW gw_saa.v_rtc_hydrometer AS 
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
