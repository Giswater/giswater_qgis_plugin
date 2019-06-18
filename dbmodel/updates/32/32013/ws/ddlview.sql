/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP VIEW vi_curves;
CREATE OR REPLACE VIEW vi_curves AS 
 SELECT
        CASE
            WHEN a.x_value IS NULL THEN a.curve_type::character varying(16)
            ELSE a.curve_id
        END AS curve_id,
    a.x_value::numeric(12,4) AS x_value,
    a.y_value::numeric(12,4) AS y_value,
	null::text as other
   FROM ( SELECT DISTINCT ON (inp_curve.curve_id) ( SELECT min(sub.id) AS min
                   FROM inp_curve sub
                  WHERE sub.curve_id::text = inp_curve.curve_id::text) AS id,
            inp_curve.curve_id,
            concat(';', inp_curve_id.curve_type, ':', inp_curve_id.descript ) AS curve_type,
            NULL::numeric AS x_value,
            NULL::numeric AS y_value
           FROM inp_curve_id
             JOIN inp_curve ON inp_curve.curve_id::text = inp_curve_id.id::text
        UNION
         SELECT inp_curve.id,
            inp_curve.curve_id,
            inp_curve_id.curve_type,
            inp_curve.x_value,
            inp_curve.y_value
           FROM inp_curve
             JOIN inp_curve_id ON inp_curve.curve_id::text = inp_curve_id.id::text
  ORDER BY 1, 4 DESC) a
	JOIN (SELECT node_id, curve_id FROM inp_pump UNION SELECT node_id, curve_id FROM inp_tank) b USING (curve_id)
	WHERE node_id IN (SELECT node_id FROM rpt_inp_node WHERE result_id=(SELECT result_id FROM inp_selector_result WHERE cur_user=current_user))
;


drop view if exists v_rtc_period_dma;
CREATE OR REPLACE VIEW v_rtc_period_dma AS 
SELECT v_rtc_period_hydrometer.dma_id,
    v_rtc_period_hydrometer.period_id,
    (sum(v_rtc_period_hydrometer.m3_total_period))::numeric(12,3) AS m3_total_period
       FROM v_rtc_period_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = v_rtc_period_hydrometer.hydrometer_id::bigint
  GROUP BY v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.period_id;


drop view if exists v_rtc_period_nodepattern cascade;
create or replace view v_rtc_period_nodepattern as           
SELECT row_number() over (order by pattern_id, idrow) as id, 
 (select value from SCHEMA_NAME.config_param_user WHERE cur_user=current_user AND parameter='inp_options_rtc_period_id') AS period_id,
    idrow,
	pattern_id, 
	sum(factor_1)::numeric(10,8) as factor_1, sum(factor_2)::numeric(10,8) as factor_2,
	sum(factor_3)::numeric(10,8) as factor_3, sum(factor_4)::numeric(10,8) as factor_4,
	sum(factor_5)::numeric(10,8) as factor_5, sum(factor_6)::numeric(10,8) as factor_6,
	sum(factor_7)::numeric(10,8) as factor_7, sum(factor_8)::numeric(10,8) as factor_8,
	sum(factor_9)::numeric(10,8) as factor_9, sum(factor_10)::numeric(10,8) as factor_10,
	sum(factor_11)::numeric(10,8) as factor_11, sum(factor_12)::numeric(10,8) as factor_12,
	sum(factor_13)::numeric(10,8) as factor_13, sum(factor_14)::numeric(10,8) as factor_14,
	sum(factor_15)::numeric(10,8) as factor_15, sum(factor_16)::numeric(10,8) as factor_16,
	sum(factor_17)::numeric(10,8) as factor_17, sum(factor_18)::numeric(10,8) as factor_18
FROM(
SELECT 
CASE 	
	WHEN b.id = ((SELECT min(sub.id) FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 1 
	WHEN b.id = ((SELECT min(sub.id)+1 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 2 
	WHEN b.id = ((SELECT min(sub.id)+2 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 3 
	WHEN b.id = ((SELECT min(sub.id)+3 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 4
	WHEN b.id = ((SELECT min(sub.id)+4 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 5 
	WHEN b.id = ((SELECT min(sub.id)+5 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 6 
	WHEN b.id = ((SELECT min(sub.id)+6 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 7 				
	WHEN b.id = ((SELECT min(sub.id)+7 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 8 				
	WHEN b.id = ((SELECT min(sub.id)+8 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 9 				
	WHEN b.id = ((SELECT min(sub.id)+9 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 10
	WHEN b.id = ((SELECT min(sub.id)+10 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 11
	WHEN b.id = ((SELECT min(sub.id)+11 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 12 
	WHEN b.id = ((SELECT min(sub.id)+12 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 13 
	WHEN b.id = ((SELECT min(sub.id)+13 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 14
	WHEN b.id = ((SELECT min(sub.id)+14 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 15 
	WHEN b.id = ((SELECT min(sub.id)+15 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 16 
	WHEN b.id = ((SELECT min(sub.id)+16 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 17 				
	WHEN b.id = ((SELECT min(sub.id)+17 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 18 				
	WHEN b.id = ((SELECT min(sub.id)+18 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 19 				
	WHEN b.id = ((SELECT min(sub.id)+19 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 20 
	WHEN b.id = ((SELECT min(sub.id)+20 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 21
	WHEN b.id = ((SELECT min(sub.id)+21 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 22 
	WHEN b.id = ((SELECT min(sub.id)+22 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 23 
	WHEN b.id = ((SELECT min(sub.id)+23 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 24
	WHEN b.id = ((SELECT min(sub.id)+24 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 25 
	WHEN b.id = ((SELECT min(sub.id)+25 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 26 
	WHEN b.id = ((SELECT min(sub.id)+26 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 27 				
	WHEN b.id = ((SELECT min(sub.id)+27 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 28 				
	WHEN b.id = ((SELECT min(sub.id)+28 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 29 				
	WHEN b.id = ((SELECT min(sub.id)+29 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 30 	
END AS idrow,
node_1 as pattern_id,
sum(lps_avg*factor_1*0.5) as factor_1,
sum(lps_avg*factor_2*0.5) as factor_2,
sum(lps_avg*factor_3*0.5) as factor_3,
sum(lps_avg*factor_4*0.5) as factor_4,
sum(lps_avg*factor_5*0.5) as factor_5,
sum(lps_avg*factor_6*0.5) as factor_6,
sum(lps_avg*factor_7*0.5) as factor_7,
sum(lps_avg*factor_8*0.5) as factor_8,
sum(lps_avg*factor_9*0.5) as factor_9,
sum(lps_avg*factor_10*0.5) as factor_10,
sum(lps_avg*factor_11*0.5) as factor_11,
sum(lps_avg*factor_12*0.5) as factor_12,
sum(lps_avg*factor_13*0.5) as factor_13,
sum(lps_avg*factor_14*0.5) as factor_14,
sum(lps_avg*factor_15*0.5) as factor_15,
sum(lps_avg*factor_16*0.5) as factor_16,
sum(lps_avg*factor_17*0.5) as factor_17,
sum(lps_avg*factor_18*0.5) as factor_18
FROM v_rtc_period_hydrometer a JOIN inp_pattern_value b USING (pattern_id) group by node_1, idrow

UNION 
SELECT
CASE 	
	WHEN b.id = ((SELECT min(sub.id) FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 1 
	WHEN b.id = ((SELECT min(sub.id)+1 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 2 
	WHEN b.id = ((SELECT min(sub.id)+2 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 3 
	WHEN b.id = ((SELECT min(sub.id)+3 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 4
	WHEN b.id = ((SELECT min(sub.id)+4 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 5 
	WHEN b.id = ((SELECT min(sub.id)+5 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 6 
	WHEN b.id = ((SELECT min(sub.id)+6 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 7 				
	WHEN b.id = ((SELECT min(sub.id)+7 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 8 				
	WHEN b.id = ((SELECT min(sub.id)+8 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 9 				
	WHEN b.id = ((SELECT min(sub.id)+9 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 10
	WHEN b.id = ((SELECT min(sub.id)+10 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 11
	WHEN b.id = ((SELECT min(sub.id)+11 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 12 
	WHEN b.id = ((SELECT min(sub.id)+12 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 13 
	WHEN b.id = ((SELECT min(sub.id)+13 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 14
	WHEN b.id = ((SELECT min(sub.id)+14 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 15 
	WHEN b.id = ((SELECT min(sub.id)+15 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 16 
	WHEN b.id = ((SELECT min(sub.id)+16 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 17 				
	WHEN b.id = ((SELECT min(sub.id)+17 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 18 				
	WHEN b.id = ((SELECT min(sub.id)+18 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 19 				
	WHEN b.id = ((SELECT min(sub.id)+19 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 20 				 				
	WHEN b.id = ((SELECT min(sub.id)+20 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 21
	WHEN b.id = ((SELECT min(sub.id)+21 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 22 
	WHEN b.id = ((SELECT min(sub.id)+22 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 23 
	WHEN b.id = ((SELECT min(sub.id)+23 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 24
	WHEN b.id = ((SELECT min(sub.id)+24 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 25 
	WHEN b.id = ((SELECT min(sub.id)+25 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 26 
	WHEN b.id = ((SELECT min(sub.id)+26 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 27 				
	WHEN b.id = ((SELECT min(sub.id)+27 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 28 				
	WHEN b.id = ((SELECT min(sub.id)+28 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 29 				
	WHEN b.id = ((SELECT min(sub.id)+29 FROM inp_pattern_value sub WHERE sub.pattern_id = b.pattern_id)) THEN 30 
END AS idrow,
node_2,
sum(lps_avg*factor_1*0.5) as factor_1,
sum(lps_avg*factor_2*0.5) as factor_2,
sum(lps_avg*factor_3*0.5) as factor_3,
sum(lps_avg*factor_4*0.5) as factor_4,
sum(lps_avg*factor_5*0.5) as factor_5,
sum(lps_avg*factor_6*0.5) as factor_6,
sum(lps_avg*factor_7*0.5) as factor_7,
sum(lps_avg*factor_8*0.5) as factor_8,
sum(lps_avg*factor_9*0.5) as factor_9,
sum(lps_avg*factor_10*0.5) as factor_10,
sum(lps_avg*factor_11*0.5) as factor_11,
sum(lps_avg*factor_12*0.5) as factor_12,
sum(lps_avg*factor_13*0.5) as factor_13,
sum(lps_avg*factor_14*0.5) as factor_14,
sum(lps_avg*factor_15*0.5) as factor_15,
sum(lps_avg*factor_16*0.5) as factor_16,
sum(lps_avg*factor_17*0.5) as factor_17,
sum(lps_avg*factor_18*0.5) as factor_18
FROM v_rtc_period_hydrometer a JOIN inp_pattern_value b USING (pattern_id) group by node_2, idrow order by pattern_id)a
group by idrow, pattern_id;

drop view if exists v_rtc_interval_nodepattern;
CREATE OR REPLACE VIEW v_rtc_interval_nodepattern AS
select * from v_rtc_period_nodepattern;


DROP VIEW if exists vi_patterns;
CREATE OR REPLACE VIEW vi_patterns AS 
SELECT pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18
	FROM (
		SELECT a.id, a.pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, 
		factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
		FROM inp_pattern_value a JOIN rpt_inp_node b ON a.pattern_id=b.pattern_id
	UNION
		SELECT a.id, a.pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, 
		factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
		FROM inp_pattern_value a JOIN inp_reservoir b ON a.pattern_id=b.pattern_id
	UNION
		SELECT a.id, a.pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, 
		factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
		FROM inp_pattern_value a JOIN vi_demands b ON a.pattern_id=b.pattern_id
	UNION   
		SELECT id+1000000, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, 
		factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18
		FROM rpt_inp_pattern_value WHERE result_id= (select result_id from inp_selector_result WHERE cur_user=current_user ) 	
	ORDER BY 1)a

  