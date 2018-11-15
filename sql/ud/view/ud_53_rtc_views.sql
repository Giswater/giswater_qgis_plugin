/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
SET search_path = "SCHEMA_NAME", public, pg_catalog;


drop view IF EXISTS v_rtc_hydrometer cascade;
CREATE OR REPLACE VIEW v_rtc_hydrometer AS 
 SELECT ext_rtc_hydrometer.id::text AS hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
        CASE
            WHEN v_edit_connec.connec_id IS NULL THEN 'XXXX'::character varying
            ELSE v_edit_connec.connec_id
        END AS connec_id,
        CASE
            WHEN ext_rtc_hydrometer.connec_id::text IS NULL THEN 'XXXX'::text
            ELSE ext_rtc_hydrometer.connec_id::text
        END AS connec_customer_code,
    ext_rtc_hydrometer_state.name AS state,
    ext_municipality.name AS muni_name,
    v_edit_connec.expl_id,
    exploitation.name AS expl_name,
    ext_rtc_hydrometer.plot_code,
    ext_rtc_hydrometer.priority_id,
    ext_rtc_hydrometer.catalog_id,
    ext_rtc_hydrometer.category_id,
    ext_rtc_hydrometer.hydro_number,
    ext_rtc_hydrometer.hydro_man_date,
    ext_rtc_hydrometer.crm_number,
    ext_rtc_hydrometer.customer_name,
    ext_rtc_hydrometer.address1,
    ext_rtc_hydrometer.address2,
    ext_rtc_hydrometer.address3,
    ext_rtc_hydrometer.address2_1,
    ext_rtc_hydrometer.address2_2,
    ext_rtc_hydrometer.address2_3,
    ext_rtc_hydrometer.m3_volume,
    ext_rtc_hydrometer.start_date,
    ext_rtc_hydrometer.end_date,
    ext_rtc_hydrometer.update_date,
        CASE
            WHEN (( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'hydrometer_link_absolute_path'::text)) IS NULL THEN rtc_hydrometer.link
            ELSE concat(( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'hydrometer_link_absolute_path'::text), rtc_hydrometer.link)
        END AS hydrometer_link
   FROM selector_hydrometer,
    rtc_hydrometer
     LEFT JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer.id::text = rtc_hydrometer.hydrometer_id::text
     JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
     JOIN v_edit_connec ON v_edit_connec.customer_code::text = ext_rtc_hydrometer.connec_id::text
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = v_edit_connec.muni_id
     LEFT JOIN exploitation ON exploitation.expl_id = v_edit_connec.expl_id
     WHERE selector_hydrometer.state_id = ext_rtc_hydrometer.state_id AND selector_hydrometer.cur_user = "current_user"()::text;

  
  

CREATE OR REPLACE VIEW v_ui_hydrometer AS 
 SELECT v_rtc_hydrometer.hydrometer_id AS sys_hydrometer_id,
    v_rtc_hydrometer.connec_id AS sys_connec_id,
    v_rtc_hydrometer.hydrometer_customer_code AS "Hydro ccode:",
    v_rtc_hydrometer.connec_customer_code AS "Connec ccode:",
    v_rtc_hydrometer.state AS "State:",
    v_rtc_hydrometer.expl_name AS "Exploitation:",
    v_rtc_hydrometer.hydrometer_link
   FROM v_rtc_hydrometer; 
  
 

DROP VIEW IF EXISTS v_rtc_hydrometer_x_connec CASCADE;
CREATE OR REPLACE VIEW v_rtc_hydrometer_x_connec AS
SELECT 
rtc_hydrometer_x_connec.connec_id,
count(v_rtc_hydrometer.hydrometer_id)::integer as n_hydrometer
FROM rtc_hydrometer_x_connec
JOIN v_rtc_hydrometer ON v_rtc_hydrometer.hydrometer_id=rtc_hydrometer_x_connec.hydrometer_id
group by rtc_hydrometer_x_connec.connec_id;

	 
CREATE OR REPLACE VIEW v_rtc_hydrometer_period AS 
 SELECT ext_rtc_hydrometer.id as hydrometer_id,
    ext_cat_period.id AS period_id,
    connec.dma_id,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
            ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
        END AS lps_avg
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::int8= ext_rtc_hydrometer.id::int8
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id = ext_cat_period.id
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::int8= ext_rtc_hydrometer.id::int8
     JOIN connec ON connec.connec_id = rtc_hydrometer_x_connec.connec_id
     JOIN inp_options ON inp_options.rtc_period_id = ext_cat_period.id;



DROP VIEW IF EXISTS v_rtc_dma_hydrometer_period CASCADE;
CREATE OR REPLACE VIEW v_rtc_dma_hydrometer_period AS 
 SELECT v_rtc_hydrometer_period.dma_id, 
    ext_cat_period.id AS period_id, 
    sum(v_rtc_hydrometer_period.m3_total_period) AS m3_total_period, 
    ext_cat_period.period_seconds
   FROM v_rtc_hydrometer_period
   JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::int8= v_rtc_hydrometer_period.hydrometer_id::int8
   JOIN inp_options ON inp_options.rtc_period_id = ext_rtc_hydrometer_x_data.cat_period_id
   JOIN ext_cat_period ON inp_options.rtc_period_id = ext_cat_period.id
  GROUP BY v_rtc_hydrometer_period.dma_id, ext_cat_period.id, ext_cat_period.period_seconds;
  
  DROP VIEW IF EXISTS v_rtc_dma_parameter_period CASCADE;
CREATE OR REPLACE VIEW v_rtc_dma_parameter_period AS 
 SELECT v_rtc_dma_hydrometer_period.dma_id, 
    v_rtc_dma_hydrometer_period.period_id, 
    v_rtc_dma_hydrometer_period.m3_total_period AS m3_total_hydrometer,
    ext_rtc_scada_dma_period.m3_total_period AS m3_total_scada, 
    (1::double precision - v_rtc_dma_hydrometer_period.m3_total_period / ext_rtc_scada_dma_period.m3_total_period)::numeric(5,4) AS losses, 
    ext_rtc_scada_dma_period.m3_min AS m3_min_scada, 
    ext_rtc_scada_dma_period.m3_max AS m3_max_scada, 
    ext_rtc_scada_dma_period.m3_avg AS m3_avg_scada, 
    ext_rtc_scada_dma_period.m3_min / ext_rtc_scada_dma_period.m3_avg AS cmin, 
    ext_rtc_scada_dma_period.m3_max / ext_rtc_scada_dma_period.m3_avg AS cmax
   FROM v_rtc_dma_hydrometer_period
  JOIN ext_rtc_scada_dma_period ON ext_rtc_scada_dma_period.cat_period_id = v_rtc_dma_hydrometer_period.period_id;
  
  
  DROP VIEW IF EXISTS v_rtc_hydrometer_x_arc CASCADE;
CREATE OR REPLACE VIEW v_rtc_hydrometer_x_arc AS 
 SELECT rtc_hydrometer_x_connec.hydrometer_id,
    rtc_hydrometer_x_connec.connec_id,
    rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2
   FROM rtc_hydrometer_x_connec
     JOIN v_edit_connec ON v_edit_connec.connec_id = rtc_hydrometer_x_connec.connec_id
     RIGHT JOIN rpt_inp_arc ON rpt_inp_arc.arc_id = v_edit_connec.arc_id;


CREATE OR REPLACE VIEW v_rtc_hydrometer_x_node_period AS 
 SELECT 
    v_rtc_hydrometer_x_arc.hydrometer_id,
    v_rtc_hydrometer_x_arc.node_1 AS node_id,
    v_rtc_hydrometer_x_arc.arc_id,
    v_rtc_hydrometer_period.dma_id,
    v_rtc_hydrometer_period.period_id,
    v_rtc_hydrometer_period.lps_avg * 0.5::double precision AS lps_avg_real,
    v_rtc_dma_parameter_period.losses,
    v_rtc_hydrometer_period.lps_avg * 0.5::double precision * (1::numeric / (1::numeric - v_rtc_dma_parameter_period.losses))::double precision AS lps_avg,
    v_rtc_dma_parameter_period.cmin,
    v_rtc_hydrometer_period.lps_avg * 0.5::double precision * v_rtc_dma_parameter_period.cmin AS lps_min,
    v_rtc_dma_parameter_period.cmax,
    v_rtc_hydrometer_period.lps_avg * 0.5::double precision * v_rtc_dma_parameter_period.cmax AS lps_max
   FROM v_rtc_hydrometer_x_arc
     LEFT JOIN v_rtc_hydrometer_period ON v_rtc_hydrometer_period.hydrometer_id::int8= v_rtc_hydrometer_x_arc.hydrometer_id::int8
     LEFT JOIN v_rtc_dma_parameter_period ON v_rtc_hydrometer_period.period_id = v_rtc_dma_parameter_period.period_id
UNION
 SELECT 
    v_rtc_hydrometer_x_arc.hydrometer_id,
    v_rtc_hydrometer_x_arc.node_2 AS node_id,
    v_rtc_hydrometer_x_arc.arc_id,
    v_rtc_hydrometer_period.dma_id,
    v_rtc_hydrometer_period.period_id,
    v_rtc_hydrometer_period.lps_avg * 0.5::double precision AS lps_avg_real,
    v_rtc_dma_parameter_period.losses,
    v_rtc_hydrometer_period.lps_avg * 0.5::double precision * (1::numeric / (1::numeric - v_rtc_dma_parameter_period.losses))::double precision AS lps_avg,
    v_rtc_dma_parameter_period.cmin,
    v_rtc_hydrometer_period.lps_avg * 0.5::double precision * v_rtc_dma_parameter_period.cmin AS lps_min,
    v_rtc_dma_parameter_period.cmax,
    v_rtc_hydrometer_period.lps_avg * 0.5::double precision * v_rtc_dma_parameter_period.cmax AS lps_max
   FROM v_rtc_hydrometer_x_arc
     LEFT JOIN v_rtc_hydrometer_period ON v_rtc_hydrometer_period.hydrometer_id::int8 = v_rtc_hydrometer_x_arc.hydrometer_id::int8
     LEFT JOIN v_rtc_dma_parameter_period ON v_rtc_hydrometer_period.period_id = v_rtc_dma_parameter_period.period_id;
	 