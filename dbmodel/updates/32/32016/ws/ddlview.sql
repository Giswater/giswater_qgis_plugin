/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


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
  

 /* 
CREATE OR REPLACE VIEW v_rtc_period_pjointpattern AS 
	SELECT row_number() OVER (ORDER BY a.pattern_id, a.idrow) AS id,
	a.period_id,
    a.idrow,
    a.pattern_id,
    sum(a.factor_1)::numeric(10,8) AS factor_1,
    sum(a.factor_2)::numeric(10,8) AS factor_2,
    sum(a.factor_3)::numeric(10,8) AS factor_3,
    sum(a.factor_4)::numeric(10,8) AS factor_4,
    sum(a.factor_5)::numeric(10,8) AS factor_5,
    sum(a.factor_6)::numeric(10,8) AS factor_6,
    sum(a.factor_7)::numeric(10,8) AS factor_7,
    sum(a.factor_8)::numeric(10,8) AS factor_8,
    sum(a.factor_9)::numeric(10,8) AS factor_9,
    sum(a.factor_10)::numeric(10,8) AS factor_10,
    sum(a.factor_11)::numeric(10,8) AS factor_11,
    sum(a.factor_12)::numeric(10,8) AS factor_12,
    sum(a.factor_13)::numeric(10,8) AS factor_13,
    sum(a.factor_14)::numeric(10,8) AS factor_14,
    sum(a.factor_15)::numeric(10,8) AS factor_15,
    sum(a.factor_16)::numeric(10,8) AS factor_16,
    sum(a.factor_17)::numeric(10,8) AS factor_17,
    sum(a.factor_18)::numeric(10,8) AS factor_18
   FROM ( SELECT
                CASE
                    WHEN b.id = (( SELECT min(sub.id) AS min
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 1
                    WHEN b.id = (( SELECT min(sub.id) + 1
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 2
                    WHEN b.id = (( SELECT min(sub.id) + 2
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 3
                    WHEN b.id = (( SELECT min(sub.id) + 3
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 4
                    WHEN b.id = (( SELECT min(sub.id) + 4
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 5
                    WHEN b.id = (( SELECT min(sub.id) + 5
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 6
                    WHEN b.id = (( SELECT min(sub.id) + 6
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 7
                    WHEN b.id = (( SELECT min(sub.id) + 7
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 8
                    WHEN b.id = (( SELECT min(sub.id) + 8
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 9
                    WHEN b.id = (( SELECT min(sub.id) + 9
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 10
                    WHEN b.id = (( SELECT min(sub.id) + 10
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 11
                    WHEN b.id = (( SELECT min(sub.id) + 11
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 12
                    WHEN b.id = (( SELECT min(sub.id) + 12
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 13
                    WHEN b.id = (( SELECT min(sub.id) + 13
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 14
                    WHEN b.id = (( SELECT min(sub.id) + 14
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 15
                    WHEN b.id = (( SELECT min(sub.id) + 15
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 16
                    WHEN b.id = (( SELECT min(sub.id) + 16
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 17
                    WHEN b.id = (( SELECT min(sub.id) + 17
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 18
                    WHEN b.id = (( SELECT min(sub.id) + 18
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 19
                    WHEN b.id = (( SELECT min(sub.id) + 19
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 20
                    WHEN b.id = (( SELECT min(sub.id) + 20
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 21
                    WHEN b.id = (( SELECT min(sub.id) + 21
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 22
                    WHEN b.id = (( SELECT min(sub.id) + 22
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 23
                    WHEN b.id = (( SELECT min(sub.id) + 23
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 24
                    WHEN b.id = (( SELECT min(sub.id) + 24
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 25
                    WHEN b.id = (( SELECT min(sub.id) + 25
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 26
                    WHEN b.id = (( SELECT min(sub.id) + 26
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 27
                    WHEN b.id = (( SELECT min(sub.id) + 27
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 28
                    WHEN b.id = (( SELECT min(sub.id) + 28
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 29
                    WHEN b.id = (( SELECT min(sub.id) + 29
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 30
                    ELSE NULL::integer
                END AS idrow,
            pjoint_id AS pattern_id,
			period_id,
            sum(lps_avg * b.factor_1::double precision) AS factor_1,
            sum(lps_avg * b.factor_2::double precision) AS factor_2,
            sum(lps_avg * b.factor_3::double precision) AS factor_3,
            sum(lps_avg * b.factor_4::double precision) AS factor_4,
            sum(lps_avg * b.factor_5::double precision) AS factor_5,
            sum(lps_avg * b.factor_6::double precision) AS factor_6,
            sum(lps_avg * b.factor_7::double precision) AS factor_7,
            sum(lps_avg * b.factor_8::double precision) AS factor_8,
            sum(lps_avg * b.factor_9::double precision) AS factor_9,
            sum(lps_avg * b.factor_10::double precision) AS factor_10,
            sum(lps_avg * b.factor_11::double precision) AS factor_11,
            sum(lps_avg * b.factor_12::double precision) AS factor_12,
            sum(lps_avg * b.factor_13::double precision) AS factor_13,
            sum(lps_avg * b.factor_14::double precision) AS factor_14,
            sum(lps_avg * b.factor_15::double precision) AS factor_15,
            sum(lps_avg * b.factor_16::double precision) AS factor_16,
            sum(lps_avg * b.factor_17::double precision) AS factor_17,
            sum(lps_avg * b.factor_18::double precision) AS factor_18
           FROM v_rtc_period_hydrometer
             JOIN inp_pattern_value b USING (pattern_id)
          GROUP BY pjoint_id,1)a
	  GROUP BY a.period_id, a.idrow, a.pattern_id;
*/
				
CREATE OR REPLACE VIEW v_inp_pjointpattern AS 
 SELECT row_number() OVER (ORDER BY a.pattern_id, a.idrow) AS id,
    a.idrow,
    a.pattern_id,
    sum(a.factor_1)::numeric(10,8) AS factor_1,
    sum(a.factor_2)::numeric(10,8) AS factor_2,
    sum(a.factor_3)::numeric(10,8) AS factor_3,
    sum(a.factor_4)::numeric(10,8) AS factor_4,
    sum(a.factor_5)::numeric(10,8) AS factor_5,
    sum(a.factor_6)::numeric(10,8) AS factor_6,
    sum(a.factor_7)::numeric(10,8) AS factor_7,
    sum(a.factor_8)::numeric(10,8) AS factor_8,
    sum(a.factor_9)::numeric(10,8) AS factor_9,
    sum(a.factor_10)::numeric(10,8) AS factor_10,
    sum(a.factor_11)::numeric(10,8) AS factor_11,
    sum(a.factor_12)::numeric(10,8) AS factor_12,
    sum(a.factor_13)::numeric(10,8) AS factor_13,
    sum(a.factor_14)::numeric(10,8) AS factor_14,
    sum(a.factor_15)::numeric(10,8) AS factor_15,
    sum(a.factor_16)::numeric(10,8) AS factor_16,
    sum(a.factor_17)::numeric(10,8) AS factor_17,
    sum(a.factor_18)::numeric(10,8) AS factor_18
   FROM ( SELECT
                CASE
                    WHEN b.id = (( SELECT min(sub.id) AS min
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 1
                    WHEN b.id = (( SELECT min(sub.id) + 1
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 2
                    WHEN b.id = (( SELECT min(sub.id) + 2
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 3
                    WHEN b.id = (( SELECT min(sub.id) + 3
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 4
                    WHEN b.id = (( SELECT min(sub.id) + 4
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 5
                    WHEN b.id = (( SELECT min(sub.id) + 5
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 6
                    WHEN b.id = (( SELECT min(sub.id) + 6
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 7
                    WHEN b.id = (( SELECT min(sub.id) + 7
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 8
                    WHEN b.id = (( SELECT min(sub.id) + 8
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 9
                    WHEN b.id = (( SELECT min(sub.id) + 9
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 10
                    WHEN b.id = (( SELECT min(sub.id) + 10
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 11
                    WHEN b.id = (( SELECT min(sub.id) + 11
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 12
                    WHEN b.id = (( SELECT min(sub.id) + 12
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 13
                    WHEN b.id = (( SELECT min(sub.id) + 13
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 14
                    WHEN b.id = (( SELECT min(sub.id) + 14
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 15
                    WHEN b.id = (( SELECT min(sub.id) + 15
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 16
                    WHEN b.id = (( SELECT min(sub.id) + 16
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 17
                    WHEN b.id = (( SELECT min(sub.id) + 17
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 18
                    WHEN b.id = (( SELECT min(sub.id) + 18
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 19
                    WHEN b.id = (( SELECT min(sub.id) + 19
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 20
                    WHEN b.id = (( SELECT min(sub.id) + 20
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 21
                    WHEN b.id = (( SELECT min(sub.id) + 21
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 22
                    WHEN b.id = (( SELECT min(sub.id) + 22
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 23
                    WHEN b.id = (( SELECT min(sub.id) + 23
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 24
                    WHEN b.id = (( SELECT min(sub.id) + 24
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 25
                    WHEN b.id = (( SELECT min(sub.id) + 25
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 26
                    WHEN b.id = (( SELECT min(sub.id) + 26
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 27
                    WHEN b.id = (( SELECT min(sub.id) + 27
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 28
                    WHEN b.id = (( SELECT min(sub.id) + 28
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 29
                    WHEN b.id = (( SELECT min(sub.id) + 29
                       FROM inp_pattern_value sub
                      WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 30
                    ELSE NULL::integer
		END AS idrow,
		pjoint_id AS pattern_id,
		sum(demand * b.factor_1::double precision) AS factor_1,
		sum(demand * b.factor_2::double precision) AS factor_2,
		sum(demand * b.factor_3::double precision) AS factor_3,
		sum(demand * b.factor_4::double precision) AS factor_4,
		sum(demand * b.factor_5::double precision) AS factor_5,
		sum(demand * b.factor_6::double precision) AS factor_6,
		sum(demand * b.factor_7::double precision) AS factor_7,
		sum(demand * b.factor_8::double precision) AS factor_8,
		sum(demand * b.factor_9::double precision) AS factor_9,
		sum(demand * b.factor_10::double precision) AS factor_10,
		sum(demand * b.factor_11::double precision) AS factor_11,
		sum(demand * b.factor_12::double precision) AS factor_12,
		sum(demand * b.factor_13::double precision) AS factor_13,
		sum(demand * b.factor_14::double precision) AS factor_14,
		sum(demand * b.factor_15::double precision) AS factor_15,
		sum(demand * b.factor_16::double precision) AS factor_16,
		sum(demand * b.factor_17::double precision) AS factor_17,
		sum(demand * b.factor_18::double precision) AS factor_18
		FROM (SELECT connec_id, demand, pattern_id, pjoint_id
			FROM inp_connec
			JOIN connec USING (connec_id)
			) c
		JOIN inp_pattern_value b USING (pattern_id)
		GROUP BY pjoint_id, 1
		) a
  GROUP BY a.idrow, a.pattern_id;