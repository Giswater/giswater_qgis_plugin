 /*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
 

-- 2919/03/29
CREATE OR REPLACE VIEW vi_junctions AS 
SELECT 
rpt_inp_node.node_id, 
elevation, 
rpt_inp_node.demand, 
rpt_inp_node.pattern_id
FROM inp_selector_result, rpt_inp_node
   LEFT JOIN inp_junction ON inp_junction.node_id = rpt_inp_node.node_id
   WHERE epa_type IN ('JUNCTION', 'SHORTPIPE') AND rpt_inp_node.result_id=inp_selector_result.result_id AND inp_selector_result.cur_user="current_user"()
   ORDER BY rpt_inp_node.node_id;
  

DROP VIEW vi_patterns;
CREATE OR REPLACE VIEW vi_patterns AS 
 SELECT inp_pattern_value.pattern_id,
    inp_pattern_value.factor_1,
    inp_pattern_value.factor_2,
    inp_pattern_value.factor_3,
    inp_pattern_value.factor_4,
    inp_pattern_value.factor_5,
    inp_pattern_value.factor_6,
    inp_pattern_value.factor_7,
    inp_pattern_value.factor_8,
    inp_pattern_value.factor_9,
    inp_pattern_value.factor_10,
    inp_pattern_value.factor_11,
    inp_pattern_value.factor_12,
    inp_pattern_value.factor_13,
    inp_pattern_value.factor_14,
    inp_pattern_value.factor_15,
    inp_pattern_value.factor_16,
    inp_pattern_value.factor_17,
    inp_pattern_value.factor_18
   FROM inp_pattern_value
  ORDER BY inp_pattern_value.pattern_id;


    
CREATE OR REPLACE VIEW vi_pipes AS 
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.length,
    rpt_inp_arc.diameter,
    rpt_inp_arc.roughness,
    CASE WHEN inp_pipe.minorloss IS NULL THEN 0::numeric(12,6) ELSE inp_pipe.minorloss END AS minorloss,
    inp_typevalue.idval AS status
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_pipe ON rpt_inp_arc.arc_id::text = inp_pipe.arc_id::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_pipe.status::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.length,
    rpt_inp_arc.diameter,
    rpt_inp_arc.roughness,
    CASE WHEN inp_shortpipe.minorloss IS NULL THEN 0::numeric(12,6) ELSE inp_shortpipe.minorloss END AS minorloss,
    inp_typevalue.idval AS status
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_shortpipe ON rpt_inp_arc.arc_id::text = concat(inp_shortpipe.node_id, '_n2a')
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_shortpipe.status::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


-- 2919/03/29
DROP VIEW IF EXISTS v_rtc_hydrometer_x_node_period;
CREATE OR REPLACE VIEW v_rtc_hydrometer_x_node_period AS 
 SELECT a.hydrometer_id,
    a.node_1 AS node_id,
    a.arc_id,
    b.dma_id,
    b.period_id,
    b.lps_avg * 0.5::double precision AS lps_avg_real,
    c.effc::numeric(5,4) AS losses,
    b.lps_avg * 0.5::double precision / c.effc AS lps_avg,
    c.minc AS cmin,
    b.lps_avg * 0.5::double precision / c.effc * c.minc AS lps_min,
    c.maxc AS cmax,
    b.lps_avg * 0.5::double precision / c.effc * c.maxc AS lps_max,
    pattern_id
   FROM v_rtc_hydrometer_x_arc a
     JOIN v_rtc_hydrometer_period b ON b.hydrometer_id::bigint = a.hydrometer_id::bigint
     JOIN ext_rtc_scada_dma_period c ON c.cat_period_id::text = b.period_id::text AND c.dma_id::text = b.dma_id::text
UNION
 SELECT a.hydrometer_id,
    a.node_2 AS node_id,
    a.arc_id,
    b.dma_id,
    b.period_id,
    b.lps_avg * 0.5::double precision AS lps_avg_real,
    c.effc::numeric(5,4) AS losses,
    b.lps_avg * 0.5::double precision / c.effc AS lps_avg,
    c.minc AS cmin,
    b.lps_avg * 0.5::double precision / c.effc * c.minc AS lps_min,
    c.maxc AS cmax,
    b.lps_avg * 0.5::double precision / c.effc * c.maxc AS lps_max,
    pattern_id
   FROM v_rtc_hydrometer_x_arc a
     JOIN v_rtc_hydrometer_period b ON b.hydrometer_id::bigint = a.hydrometer_id::bigint
     JOIN ext_rtc_scada_dma_period c ON c.cat_period_id::text = b.period_id::text AND c.dma_id::text = b.dma_id::text;