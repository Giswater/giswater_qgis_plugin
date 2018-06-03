/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "crm", "ws", public, pg_catalog;




CREATE OR REPLACE VIEW ws.v_rtc_hydrometer AS 
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
    hydrometer.plot_code::text AS codi_finca,
    hydrometer.priority_id,
    hydrometer.catalog_id,
    hydrometer.category_id,
    hydrometer.hydro_number::text AS num_comptador,
    hydrometer.hydro_man_date,
    hydrometer.crm_number,
    hydrometer.customer_name::text AS titular,
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
               FROM ws.config_param_system
              WHERE config_param_system.parameter::text = 'hydrometer_link_absolute_path'::text)) IS NULL THEN rtc_hydrometer.link
            ELSE concat(( SELECT config_param_system.value
               FROM ws.config_param_system
              WHERE config_param_system.parameter::text = 'hydrometer_link_absolute_path'::text), rtc_hydrometer.link)
        END AS hydrometer_link
  FROM ws.selector_hydrometer, ws.rtc_hydrometer
     LEFT JOIN crm.hydrometer ON hydrometer.id::text = rtc_hydrometer.hydrometer_id::text
     JOIN crm.hydro_val_state ON hydro_val_state.id = hydrometer.state_id
     LEFT JOIN ws.ext_municipality ON ext_municipality.muni_id = hydrometer.muni_id
     LEFT JOIN ws.exploitation ON exploitation.expl_id = hydrometer.expl_id
     JOIN ws.v_edit_connec ON v_edit_connec.customer_code::text = hydrometer.connec_id::text
     	WHERE selector_hydrometer.state_id=hydrometer.state_id AND selector_hydrometer.cur_user=current_user;


GRANT ALL ON TABLE ws.v_rtc_hydrometer TO postgres;
GRANT SELECT ON TABLE ws.v_rtc_hydrometer TO role_basic;
GRANT SELECT ON TABLE ws.v_rtc_hydrometer TO role_edit;
GRANT SELECT ON TABLE ws.v_rtc_hydrometer TO role_om;
GRANT SELECT ON TABLE ws.v_rtc_hydrometer TO role_epa;
GRANT SELECT ON TABLE ws.v_rtc_hydrometer TO role_master;
GRANT SELECT ON TABLE ws.v_rtc_hydrometer TO role_admin






CREATE OR REPLACE VIEW ws.v_anl_mincut_result_hydrometer AS
SELECT anl_mincut_result_hydrometer.id,
    anl_mincut_result_hydrometer.result_id,
    anl_mincut_result_cat.work_order,
    anl_mincut_result_hydrometer.hydrometer_id,
    v_rtc_hydrometer.hydrometer_customer_code,
    rtc_hydrometer_x_connec.connec_id
   FROM ws.anl_mincut_result_selector, ws.anl_mincut_result_hydrometer
        JOIN ws.v_rtc_hydrometer ON v_rtc_hydrometer.hydrometer_id::text = anl_mincut_result_hydrometer.hydrometer_id::text
     JOIN ws.rtc_hydrometer_x_connec ON anl_mincut_result_hydrometer.hydrometer_id::text = rtc_hydrometer_x_connec.hydrometer_id::text
     JOIN ws.anl_mincut_result_cat ON anl_mincut_result_hydrometer.result_id = anl_mincut_result_cat.id
  WHERE anl_mincut_result_selector.result_id::text = anl_mincut_result_hydrometer.result_id::text AND anl_mincut_result_selector.cur_user = "current_user"()::text;


GRANT SELECT ON TABLE ws.v_anl_mincut_result_hydrometer TO role_basic;
GRANT SELECT ON TABLE ws.v_anl_mincut_result_hydrometer TO role_edit;
GRANT ALL ON TABLE ws.v_anl_mincut_result_hydrometer TO role_om;
GRANT SELECT ON TABLE ws.v_anl_mincut_result_hydrometer TO role_epa;
GRANT ALL ON TABLE ws.v_anl_mincut_result_hydrometer TO role_master;
GRANT SELECT ON TABLE ws.v_anl_mincut_result_hydrometer TO role_admin;
