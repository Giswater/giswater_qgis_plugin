/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE VIEW ws.ext_rtc_hydrometer AS 
 SELECT hydrometer.id,
    hydrometer.code,
    hydrometer.connec_id,
    hydrometer.muni_id,
    hydrometer.plot_code,
    hydrometer.priority_id,
    hydrometer.catalog_id,
    hydrometer.category_id,
    hydrometer.state_id,
    hydrometer.hydro_number,
    hydrometer.hydro_man_date,
    hydrometer.crm_number,
    hydrometer.customer_name,
    hydrometer.address1,
    hydrometer.address2,
    hydrometer.address3,
    hydrometer.address2_1,
    hydrometer.address2_2,
    hydrometer.address2_3,
    hydrometer.m3_volume,
    hydrometer.start_date,
    hydrometer.end_date,
    hydrometer.update_date,
    hydrometer.expl_id
   FROM crm.hydrometer;


--views
FILE ws_52_1_krn_views_edit
FILE ws_52_2_rtc_views_edit
FILE ws_53_rtc_views

-- triggers
FILE ws_gw_trg_edit_man_connec
FILE ws_gw_trg_edit_man_connec_pol
FILE ws_gw_trg_edit_rtc_hydro_data
