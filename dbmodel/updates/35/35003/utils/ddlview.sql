/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/03/25
CREATE OR REPLACE VIEW v_ui_hydroval_x_connec AS 
SELECT ext_rtc_hydrometer_x_data.id,
    rtc_hydrometer_x_connec.connec_id,
    connec.arc_id,
    ext_rtc_hydrometer_x_data.hydrometer_id,
    ext_rtc_hydrometer.catalog_id,
    ext_cat_hydrometer.madeby,
    ext_cat_hydrometer.class,
    ext_rtc_hydrometer_x_data.cat_period_id,
    ext_rtc_hydrometer_x_data.sum,
    ext_rtc_hydrometer_x_data.custom_sum,
    crmtype.idval as value_type, 
    crmstatus.idval as value_status, 
    crmstate.idval as value_state
   FROM ext_rtc_hydrometer_x_data
    JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer_x_data.hydrometer_id::text = ext_rtc_hydrometer.id::text
    LEFT JOIN ext_cat_hydrometer ON ext_cat_hydrometer.id::text = ext_rtc_hydrometer.catalog_id::text
    JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::text = ext_rtc_hydrometer_x_data.hydrometer_id::text
    JOIN connec ON rtc_hydrometer_x_connec.connec_id::text = connec.connec_id::text
    LEFT JOIN crm_typevalue crmtype ON value_type=crmtype.id::integer AND crmtype.typevalue ='crm_value_type'
    LEFT JOIN crm_typevalue crmstatus ON value_status=crmstatus.id::integer AND crmstatus.typevalue = 'crm_value_status'
    LEFT JOIN crm_typevalue crmstate ON value_state=crmstate.id::integer AND crmstate.typevalue ='crm_value_state'
  ORDER BY ext_rtc_hydrometer_x_data.id;