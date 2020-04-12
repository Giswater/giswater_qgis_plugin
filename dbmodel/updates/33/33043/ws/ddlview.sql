/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW vi_patterns AS 
SELECT a.pattern_id,a.factor_1,a.factor_2,a.factor_3,a.factor_4,a.factor_5,a.factor_6,a.factor_7, a.factor_8, a.factor_9, a.factor_10, 
a.factor_11, a.factor_12, a.factor_13, a.factor_14, a.factor_15, a.factor_16, a.factor_17, a.factor_18
FROM rpt_inp_pattern_value a, inp_selector_result b
WHERE a.result_id = b.result_id AND cur_user = current_user
ORDER BY pattern_id, idrow;
	


CREATE OR REPLACE VIEW vi_pjoint AS 
SELECT pjoint_id, sum(demand) AS sum
FROM v_edit_inp_connec WHERE pjoint_id IS NOT NULL GROUP BY pjoint_id;


DROP VIEW v_rtc_period_dma;

CREATE OR REPLACE VIEW v_rtc_period_dma AS 
 SELECT v_rtc_period_hydrometer.dma_id::integer AS dma_id,
    v_rtc_period_hydrometer.period_id,
    sum(v_rtc_period_hydrometer.m3_total_period)::numeric(12,4) AS m3_total_period,
    a.pattern_id
   FROM v_rtc_period_hydrometer
     JOIN ext_rtc_dma_period a ON a.dma_id::text = v_rtc_period_hydrometer.dma_id::text 
	 AND v_rtc_period_hydrometer.period_id::text = a.cat_period_id::text
  GROUP BY v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.period_id, a.pattern_id;
