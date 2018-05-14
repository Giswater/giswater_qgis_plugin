/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "crm", "SCHEMA_NAME", public, pg_catalog;


CREATE OR REPLACE VIEW SCHEMA_NAME.v_rtc_hydrometer AS
SELECT hydrometer.id::text AS hydrometer_id,
   hydrometer.code AS hydrometer_customer_code,
       CASE
           WHEN connec.connec_id IS NULL THEN 'XXXX'::character varying
           ELSE connec.connec_id
       END AS connec_id,
       CASE
           WHEN hydrometer.connec_id::text IS NULL THEN 'XXXX'::text
           ELSE hydrometer.connec_id::text
       END AS connec_customer_code,
   hydro_val_state.observ AS name,
   hydro_val_state.observ AS state,
   ext_municipality.name AS muni_name,
   hydrometer.expl_id,
   exploitation.name AS expl_name,
   hydrometer.plot_code,
   hydrometer.priority_id,
   hydrometer.catalog_id,
   hydrometer.category_id,
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
       CASE
           WHEN (( SELECT config_param_system.value
              FROM config_param_system
             WHERE config_param_system.parameter::text = 'hydrometer_link_absolute_path'::text)) IS NULL THEN rtc_hydrometer.link
           ELSE concat(( SELECT config_param_system.value
              FROM config_param_system
             WHERE config_param_system.parameter::text = 'hydrometer_link_absolute_path'::text), rtc_hydrometer.link)
       END AS hydrometer_link
  FROM selector_hydrometer, rtc_hydrometer
    LEFT JOIN crm.hydrometer ON hydrometer.id::text = rtc_hydrometer.hydrometer_id::text
    LEFT JOIN crm.hydro_val_state ON hydro_val_state.id = hydrometer.state_id*
    LEFT JOIN ext_municipality ON ext_municipality.muni_id = hydrometer.muni_id
    LEFT JOIN exploitation ON exploitation.expl_id = hydrometer.expl_id
    LEFT JOIN connec ON connec.customer_code::text = hydrometer.connec_id::text
	WHERE selector_hydrometer.state_id=ext_rtc_hydrometer.state AND selector_hydrometer.cur_user=current_user;
	