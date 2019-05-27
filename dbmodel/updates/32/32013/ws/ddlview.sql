/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

create or replace view v_rtc_period_nodepattern as           
SELECT row_number() over (order by pattern_id) as id, pattern_id, 
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
END AS idrow,
concat('pat_',node_1) as pattern_id,
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
END AS idrow,
concat('pat_',node_2),
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


CREATE VIEW v_rtc_interval_nodepattern AS
select * from v_rtc_period_nodepattern;



DROP VIEW vi_patterns;
CREATE OR REPLACE VIEW vi_patterns AS 
 SELECT inp_pattern_value.id,
    inp_pattern_value.pattern_id, inp_pattern_value.factor_1, inp_pattern_value.factor_2, inp_pattern_value.factor_3, inp_pattern_value.factor_4, inp_pattern_value.factor_5, inp_pattern_value.factor_6,    
    inp_pattern_value.factor_7, inp_pattern_value.factor_8, inp_pattern_value.factor_9, inp_pattern_value.factor_10, inp_pattern_value.factor_11, inp_pattern_value.factor_12,    
    inp_pattern_value.factor_13, inp_pattern_value.factor_14, inp_pattern_value.factor_15, inp_pattern_value.factor_16, inp_pattern_value.factor_17, inp_pattern_value.factor_18
   FROM inp_pattern_value
   JOIN rpt_inp_node b ON inp_pattern_value.pattern_id=b.pattern_id
UNION
 SELECT inp_pattern_value.id,
    inp_pattern_value.pattern_id, inp_pattern_value.factor_1, inp_pattern_value.factor_2, inp_pattern_value.factor_3, inp_pattern_value.factor_4, inp_pattern_value.factor_5, inp_pattern_value.factor_6,    
    inp_pattern_value.factor_7, inp_pattern_value.factor_8, inp_pattern_value.factor_9, inp_pattern_value.factor_10, inp_pattern_value.factor_11, inp_pattern_value.factor_12,    
    inp_pattern_value.factor_13, inp_pattern_value.factor_14, inp_pattern_value.factor_15, inp_pattern_value.factor_16, inp_pattern_value.factor_17, inp_pattern_value.factor_18
   FROM inp_pattern_value
JOIN inp_reservoir b ON inp_pattern_value.pattern_id=b.pattern_id
UNION
   SELECT inp_pattern_value.id,
    inp_pattern_value.pattern_id, inp_pattern_value.factor_1, inp_pattern_value.factor_2, inp_pattern_value.factor_3, inp_pattern_value.factor_4, inp_pattern_value.factor_5, inp_pattern_value.factor_6,    
    inp_pattern_value.factor_7, inp_pattern_value.factor_8, inp_pattern_value.factor_9, inp_pattern_value.factor_10, inp_pattern_value.factor_11, inp_pattern_value.factor_12,    
    inp_pattern_value.factor_13, inp_pattern_value.factor_14, inp_pattern_value.factor_15, inp_pattern_value.factor_16, inp_pattern_value.factor_17, inp_pattern_value.factor_18
   FROM inp_pattern_value
   JOIN v_inp_demand b ON inp_pattern_value.pattern_id=b.pattern_id
UNION 
	SELECT * FROM v_rtc_period_nodepattern WHERE (SELECT value FROM SCHEMA_NAME.config_param_user WHERE parameter='inp_options_patternmethod' and cur_user=current_user)='23'
UNION	
	SELECT * FROM v_rtc_interval_nodepattern WHERE (SELECT value FROM SCHEMA_NAME.config_param_user WHERE parameter='inp_options_patternmethod' and cur_user=current_user)='25'
ORDER BY 1;
  