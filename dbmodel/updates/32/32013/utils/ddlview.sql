/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


drop view if exists v_rtc_hydrometer_period cascade;
CREATE OR REPLACE VIEW v_rtc_period_hydrometer AS 
 SELECT 
	ext_rtc_hydrometer.id AS hydrometer_id,
	connec.connec_id,
	arc.arc_id,
	arc.node_1,
	arc.node_2,
	ext_cat_period.id AS period_id,
	period_seconds,
	c.dma_id,
	c.effc::numeric(5,4),
	c.minc,
	c.maxc,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
            ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
        END AS lps_avg,
        ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN connec ON connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN arc ON connec.arc_id=arc.arc_id
     JOIN ext_rtc_scada_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND connec.dma_id::text = c.dma_id::text
     WHERE ext_cat_period.id = (SELECT value FROM config_param_user WHERE cur_user=current_user AND parameter='inp_options_rtc_period_id');


CREATE OR REPLACE VIEW v_rtc_period_dma AS 
 SELECT v_rtc_period_hydrometer.dma_id, 
    period_id, 
    sum(v_rtc_period_hydrometer.m3_total_period) AS m3_total_period,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM v_rtc_period_hydrometer
   JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::int8= v_rtc_period_hydrometer.hydrometer_id::int8
  GROUP BY v_rtc_period_hydrometer.dma_id,period_id, ext_rtc_hydrometer_x_data.pattern_id;


CREATE OR REPLACE VIEW v_rtc_period_node AS 
 SELECT 
    node_1 AS node_id,
    dma_id,
    period_id,
    sum(lps_avg * 0.5::double precision) AS lps_avg,
    effc,
    sum(lps_avg * 0.5::double precision / effc) AS lps_avg_real,
    minc,
    sum((lps_avg * 0.5::double precision / effc )* minc) AS lps_min,
    maxc,
    sum((lps_avg * 0.5::double precision / effc ) * maxc) AS lps_max
   FROM v_rtc_period_hydrometer
   group by node_1,period_id ,dma_id, effc,minc,maxc
UNION
 SELECT 
    node_2 AS node_id,
    dma_id,
    period_id,
    sum(lps_avg * 0.5::double precision) AS lps_avg,
    effc,
    sum(lps_avg * 0.5::double precision / effc) AS lps_avg_real,
    minc,
    sum((lps_avg * 0.5::double precision / effc )* minc) AS lps_min,
    maxc,
    sum((lps_avg * 0.5::double precision / effc ) * maxc) AS lps_max
   FROM v_rtc_period_hydrometer
   group by node_2,period_id ,dma_id, effc,minc,maxc;
   