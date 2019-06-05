/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;



DROP VIEW v_rtc_hydrometer_x_arc CASCADE;


drop view if exists v_rtc_hydrometer_period cascade;
CREATE OR REPLACE VIEW v_rtc_period_hydrometer AS 
SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    connec.connec_id,
    rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    c.effc::numeric(5,4) AS effc,
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
     JOIN rpt_inp_arc ON connec.arc_id::text = rpt_inp_arc.arc_id::text
     JOIN ext_rtc_scada_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND connec.dma_id::text = c.dma_id::text
  WHERE ext_cat_period.id::text = (( SELECT config_param_user.value FROM config_param_user WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text))
  AND result_id=(SELECT result_id FROM inp_selector_result WHERE cur_user=current_user)  ;


drop view if exists v_rtc_period_dma;
CREATE OR REPLACE VIEW v_rtc_period_dma AS 
 SELECT v_rtc_period_hydrometer.dma_id, 
    period_id, 
    sum(v_rtc_period_hydrometer.m3_total_period) AS m3_total_period,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM v_rtc_period_hydrometer
   JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::int8= v_rtc_period_hydrometer.hydrometer_id::int8
  GROUP BY v_rtc_period_hydrometer.dma_id,period_id, ext_rtc_hydrometer_x_data.pattern_id;


CREATE OR REPLACE VIEW v_rtc_period_node AS 
 SELECT v_rtc_period_hydrometer.node_1 AS node_id,
    v_rtc_period_hydrometer.dma_id,
    v_rtc_period_hydrometer.period_id,
    sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision) AS lps_avg,
    v_rtc_period_hydrometer.effc,
    sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision) AS lps_avg_real,
    v_rtc_period_hydrometer.minc,
    sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.minc) AS lps_min,
    v_rtc_period_hydrometer.maxc,
    sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.maxc) AS lps_max,
    sum(m3_total_period) as m3_total_period
   FROM v_rtc_period_hydrometer
  GROUP BY v_rtc_period_hydrometer.node_1, v_rtc_period_hydrometer.period_id, v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.effc, v_rtc_period_hydrometer.minc, v_rtc_period_hydrometer.maxc
UNION
 SELECT v_rtc_period_hydrometer.node_2 AS node_id,
    v_rtc_period_hydrometer.dma_id,
    v_rtc_period_hydrometer.period_id,
    sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision) AS lps_avg,
    v_rtc_period_hydrometer.effc,
    sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision) AS lps_avg_real,
    v_rtc_period_hydrometer.minc,
    sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.minc) AS lps_min,
    v_rtc_period_hydrometer.maxc,
    sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.maxc) AS lps_max,
    sum(m3_total_period)
   FROM v_rtc_period_hydrometer
  GROUP BY v_rtc_period_hydrometer.node_2, v_rtc_period_hydrometer.period_id, v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.effc, v_rtc_period_hydrometer.minc, v_rtc_period_hydrometer.maxc;

--05/06/2019
CREATE OR REPLACE VIEW ve_visit_arc_insp AS 
 SELECT om_visit_x_arc.visit_id,
    om_visit_x_arc.arc_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    left (date_trunc('second', startdate)::text, 19)::timestamp as startdate,
    left (date_trunc('second', enddate)::text, 19)::timestamp as enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.lot_id,
    om_visit.status,
    a.param_1 AS sediments_arc,
    a.param_2 AS desperfectes_arc,
    a.param_3 AS neteja_arc
   FROM om_visit
     JOIN om_visit_class ON om_visit_class.id = om_visit.class_id
     JOIN om_visit_x_arc ON om_visit.id = om_visit_x_arc.visit_id
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
			FROM SCHEMA_NAME.om_visit JOIN SCHEMA_NAME.om_visit_event ON om_visit.id= om_visit_event.visit_id 
			JOIN SCHEMA_NAME.om_visit_class on om_visit_class.id=om_visit.class_id
			JOIN SCHEMA_NAME.om_visit_class_x_parameter on om_visit_class_x_parameter.parameter_id=om_visit_event.parameter_id 
			where om_visit_class.ismultievent = TRUE ORDER  BY 1,2'::text, ' VALUES (''sediments_arc''),(''desperfectes_arc''),(''neteja_arc'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text)) a ON a.visit_id = om_visit.id
  WHERE om_visit_class.ismultievent = true;   