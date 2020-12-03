/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP VIEW IF EXISTS v_rtc_dma_parameter_period;
DROP VIEW IF EXISTS v_rtc_dma_hydrometer_period;


create or replace VIEW v_anl_graf as 
WITH nodes_a AS (SELECT * FROM anl_graf WHERE water = 1)
 SELECT anl_graf.grafclass,
    anl_graf.arc_id,
    anl_graf.node_1,
    anl_graf.node_2,
    anl_graf.flag,
    nodes_a.flag AS flagi
   FROM anl_graf
     JOIN nodes_a ON (anl_graf.node_1 = nodes_a.node_2 or anl_graf.node_2 = nodes_a.node_2)
  WHERE anl_graf.flag < 2 and anl_graf.water =0 and nodes_a.flag < 2 and anl_graf.user_name::name = "current_user"();



drop view if exists v_rtc_period_nodepattern cascade;
create or replace view v_rtc_period_nodepattern as           
SELECT row_number() over (order by pattern_id, idrow) as id, 
 (select value from config_param_user WHERE cur_user=current_user AND parameter='inp_options_rtc_period_id') AS period_id,
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
          GROUP BY pjoint_id,1, period_id)a
	  GROUP BY a.period_id, a.idrow, a.pattern_id;

				
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


  
CREATE OR REPLACE VIEW vi_parent_connec as
SELECT ve_connec.*
FROM ve_connec, inp_selector_sector 
WHERE ve_connec.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW vi_parent_hydrometer as
SELECT v_rtc_hydrometer.*
FROM v_rtc_hydrometer
JOIN ve_connec USING (connec_id);


CREATE OR REPLACE VIEW vi_parent_dma as
SELECT DISTINCT ON (dma.dma_id) dma.* 
FROM dma
JOIN vi_parent_arc USING (dma_id);



DROP VIEW v_edit_inp_pipe CASCADE;
CREATE OR REPLACE VIEW v_edit_inp_pipe AS 
 SELECT arc.arc_id,
    arc.node_1,
    arc.node_2,
    arc.arccat_id,
    arc.sector_id,
    v_arc.macrosector_id,
    arc.state,
    arc.annotation,
    arc.custom_length,
    arc.the_geom,
    inp_pipe.minorloss,
    inp_pipe.status,
    inp_pipe.custom_roughness,
    inp_pipe.custom_dint
   FROM inp_selector_sector,
    arc
     JOIN v_arc ON v_arc.arc_id::text = arc.arc_id::text
     JOIN inp_pipe ON inp_pipe.arc_id::text = arc.arc_id::text
  WHERE arc.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW v_edit_inp_junction AS 
 SELECT DISTINCT ON (node_id) v_node.node_id,
    elevation,
    depth,
    nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_junction.demand,
    inp_junction.pattern_id
   FROM inp_selector_sector, v_node
     JOIN inp_junction USING (node_id)
     JOIN vi_parent_arc a ON (a.node_1=v_node.node_id OR a.node_2=v_node.node_id)
     WHERE a.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_pump AS 
 SELECT DISTINCT ON (node_id) v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_pump.power,
    inp_pump.curve_id,
    inp_pump.speed,
    inp_pump.pattern,
    inp_pump.to_arc,
    inp_pump.status
   FROM inp_selector_sector, v_node
     JOIN inp_pump USING (node_id)
     JOIN vi_parent_arc a ON (a.node_1=v_node.node_id OR a.node_2=v_node.node_id)
     WHERE a.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW v_edit_inp_reservoir AS 
 SELECT DISTINCT ON (node_id) v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_reservoir.pattern_id,
	inp_reservoir.to_arc
   FROM inp_selector_sector, v_node
    JOIN inp_reservoir USING (node_id)
     JOIN vi_parent_arc a ON (a.node_1=v_node.node_id OR a.node_2=v_node.node_id)
     WHERE a.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;
     


CREATE OR REPLACE VIEW v_edit_inp_shortpipe AS 
 SELECT DISTINCT ON (node_id) v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_shortpipe.minorloss,
    inp_shortpipe.to_arc,
    inp_shortpipe.status
   FROM inp_selector_sector, v_node
     JOIN inp_shortpipe USING (node_id)
     JOIN vi_parent_arc a ON (a.node_1=v_node.node_id OR a.node_2=v_node.node_id)
     WHERE a.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_tank AS 
 SELECT DISTINCT ON (node_id) v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id
   FROM inp_selector_sector, v_node
     JOIN inp_tank USING (node_id)
     JOIN vi_parent_arc a ON (a.node_1=v_node.node_id OR a.node_2=v_node.node_id)
     WHERE a.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;

	 

CREATE OR REPLACE VIEW v_edit_inp_inlet AS 
 SELECT DISTINCT ON (node_id) v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_inlet.initlevel,
    inp_inlet.minlevel,
    inp_inlet.maxlevel,
    inp_inlet.diameter,
    inp_inlet.minvol,
    inp_inlet.curve_id,
	inp_inlet.pattern_id,
	inp_inlet.to_arc
   FROM inp_selector_sector, v_node
     JOIN inp_inlet USING (node_id)
     JOIN vi_parent_arc a ON (a.node_1=v_node.node_id OR a.node_2=v_node.node_id)
     WHERE a.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;

	 
   
CREATE OR REPLACE VIEW v_edit_inp_valve AS 
 SELECT DISTINCT ON (node_id) v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_valve.valv_type,
    inp_valve.pressure,
    inp_valve.flow,
    inp_valve.coef_loss,
    inp_valve.curve_id,
    inp_valve.minorloss,
    inp_valve.to_arc,
    inp_valve.status
   FROM inp_selector_sector, v_node
     JOIN inp_valve USING (node_id)
     JOIN vi_parent_arc a ON (a.node_1=v_node.node_id OR a.node_2=v_node.node_id)
     WHERE a.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;
     

 CREATE OR REPLACE VIEW v_edit_inp_connec AS 
 SELECT connec.connec_id,
    elevation,
    depth,
    connecat_id,
    connec.arc_id,
    connec.sector_id,
    connec.state,
    connec.annotation,
    connec.the_geom,
    inp_connec.demand,
    inp_connec.pattern_id
   FROM inp_selector_sector, connec
    JOIN inp_connec USING (connec_id)
    WHERE connec.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;

		
CREATE OR REPLACE VIEW vi_reservoirs AS 
 SELECT inp_reservoir.node_id,
    rpt_inp_node.elevation AS head,
    inp_reservoir.pattern_id
   FROM inp_selector_result,  inp_reservoir
     JOIN rpt_inp_node ON inp_reservoir.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
 UNION
SELECT inp_inlet.node_id,
    rpt_inp_node.elevation AS head,
    inp_inlet.pattern_id
   FROM inp_selector_result, inp_inlet
     LEFT JOIN (SELECT node_id, count(*)AS ct FROM (select node_1 as node_id FROM rpt_inp_arc,inp_selector_result
                     WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text 
					 UNION ALL select node_2 FROM rpt_inp_arc,inp_selector_result
                     WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
                     )a GROUP BY 1)b  USING (node_id) 
     JOIN rpt_inp_node ON inp_inlet.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
  AND ct=1;

  
CREATE OR REPLACE VIEW vi_tanks AS 
 SELECT inp_tank.node_id,
    rpt_inp_node.elevation,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id
   FROM inp_selector_result,
    inp_tank
     JOIN rpt_inp_node ON inp_tank.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT inp_inlet.node_id,
    rpt_inp_node.elevation,
    inp_inlet.initlevel,
    inp_inlet.minlevel,
    inp_inlet.maxlevel,
    inp_inlet.diameter,
    inp_inlet.minvol,
    inp_inlet.curve_id
   FROM inp_selector_result,
    inp_inlet
     LEFT JOIN ( SELECT a.node_id,
            count(*) AS ct
           FROM ( SELECT rpt_inp_arc.node_1 AS node_id
						FROM rpt_inp_arc,inp_selector_result
						WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
						UNION ALL
						SELECT rpt_inp_arc.node_2
						FROM rpt_inp_arc,inp_selector_result
						WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
                )a
          GROUP BY a.node_id) b USING (node_id)
     JOIN rpt_inp_node ON inp_inlet.node_id::text = rpt_inp_node.node_id::text
  WHERE b.ct > 1;  
  
  
CREATE OR REPLACE VIEW vi_junctions AS 
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation,
    rpt_inp_node.demand,
    rpt_inp_node.pattern_id
   FROM inp_selector_result,
    rpt_inp_node
     LEFT JOIN inp_junction ON inp_junction.node_id::text = rpt_inp_node.node_id::text
  WHERE (rpt_inp_node.epa_type::text = ANY (ARRAY['JUNCTION'::character varying, 'SHORTPIPE'::character varying]::text[])) AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
  ORDER BY rpt_inp_node.node_id;
  
  
  CREATE OR REPLACE VIEW vi_controls AS 
 SELECT c.text
   FROM ( SELECT a.id,
            a.text
           FROM ( SELECT inp_controls_x_arc.id,
                    inp_controls_x_arc.text
                   FROM inp_selector_result,
                    inp_controls_x_arc
                     JOIN rpt_inp_arc ON inp_controls_x_arc.arc_id::text = rpt_inp_arc.arc_id::text
                  WHERE inp_selector_result.result_id::text = rpt_inp_arc.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
				  AND active IS NOT FALSE
                  ORDER BY inp_controls_x_arc.id) a) c
  ORDER BY c.id;

  
  
CREATE OR REPLACE VIEW vi_rules AS 
 SELECT c.text
   FROM ( SELECT a.id,
            a.text
           FROM ( SELECT inp_rules_x_arc.id,
                    inp_rules_x_arc.text
                   FROM inp_selector_result,
                    inp_rules_x_arc
                     JOIN rpt_inp_arc ON inp_rules_x_arc.arc_id::text = rpt_inp_arc.arc_id::text
                  WHERE inp_selector_result.result_id::text = rpt_inp_arc.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
				  AND active IS NOT FALSE
				  ORDER BY inp_rules_x_arc.id) a
        UNION
         SELECT b.id,
            b.text
           FROM ( SELECT inp_rules_x_node.id + 1000000 AS id,
                    inp_rules_x_node.text
                   FROM inp_selector_result,
                    inp_rules_x_node
                     JOIN rpt_inp_node ON inp_rules_x_node.node_id::text = rpt_inp_node.node_id::text
                  WHERE inp_selector_result.result_id::text = rpt_inp_node.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
   				  AND active IS NOT FALSE
				  ORDER BY inp_rules_x_node.id) b
        UNION
         SELECT d.id,
            d.text
           FROM ( SELECT inp_rules_x_sector.id + 2000000 AS id,
                    inp_rules_x_sector.text
                   FROM inp_selector_sector,
                    inp_rules_x_sector
                  WHERE inp_selector_sector.sector_id = inp_rules_x_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text
   				  AND active IS NOT FALSE
				  ORDER BY inp_rules_x_sector.id) d) c
  ORDER BY c.id;

  
CREATE VIEW v_arc_x_vnode AS
SELECT vnode_id, arc_id, a.feature_type, feature_id, 
node_1,
node_2,
(length*locate)::numeric(12,3) AS vnode_distfromnode1,
(length*(1-locate))::numeric(12,3) AS vnode_distfromnode2,
(elevation1 - locate*(elevation1-elevation2))::numeric (12,3) as vnode_elevation
FROM (
SELECT vnode_id, arc_id, a.feature_type, feature_id,
st_length(v_edit_arc.the_geom) as length,
st_linelocatepoint (v_edit_arc.the_geom , vnode.the_geom)::numeric(12,3) as locate,
node_1,
node_2,
elevation1,
elevation2
from v_edit_arc , vnode 
JOIN v_edit_link a ON vnode_id=exit_id::integer
where st_dwithin ( v_edit_arc.the_geom, vnode.the_geom, 0.01) 
and v_edit_arc.state>0 and vnode.state>0
) a
order by 2,6 desc;


CREATE OR REPLACE VIEW v_anl_mincut_result_cat AS
SELECT 
anl_mincut_result_cat.id,
work_order,
anl_mincut_cat_state.name as state,
anl_mincut_cat_class.name as class,
mincut_type,
received_date,
anl_mincut_result_cat.expl_id,
exploitation.name AS expl_name,
macroexploitation.name AS macroexpl_name,
anl_mincut_result_cat.macroexpl_id,
anl_mincut_result_cat.muni_id,
ext_municipality.name AS muni_name,
postcode,
streetaxis_id,
ext_streetaxis.name AS street_name,
postnumber,
anl_cause,
anl_tstamp ,
anl_user,
anl_descript,
anl_feature_id,
anl_feature_type,
anl_the_geom,
forecast_start,
forecast_end,
assigned_to,
exec_start,
exec_end,
exec_user,
exec_descript,
exec_the_geom,
exec_from_plot,
exec_depth,
exec_appropiate,
notified
FROM anl_mincut_result_selector, anl_mincut_result_cat
LEFT JOIN anl_mincut_cat_class ON anl_mincut_cat_class.id = mincut_class
LEFT JOIN anl_mincut_cat_state ON anl_mincut_cat_state.id = mincut_state
LEFT JOIN exploitation ON anl_mincut_result_cat.expl_id = exploitation.expl_id
LEFT JOIN ext_streetaxis ON anl_mincut_result_cat.streetaxis_id::text = ext_streetaxis.id::text
LEFT JOIN macroexploitation ON anl_mincut_result_cat.macroexpl_id = macroexploitation.macroexpl_id
LEFT JOIN ext_municipality ON anl_mincut_result_cat.muni_id = ext_municipality.muni_id
	WHERE anl_mincut_result_selector.result_id = anl_mincut_result_cat.id AND anl_mincut_result_selector.cur_user = "current_user"()::text;
    

DROP VIEW IF EXISTS v_ui_anl_mincut_result_cat;
CREATE OR REPLACE VIEW v_ui_anl_mincut_result_cat AS
SELECT
anl_mincut_result_cat.id,
anl_mincut_result_cat.id AS name,
work_order,
anl_mincut_cat_state.name AS state,
anl_mincut_cat_class.name AS class,
mincut_type,
received_date,
anl_mincut_result_cat.expl_id,
exploitation.name AS exploitation,
macroexploitation.name AS macroexploitation,
ext_municipality.name AS municipality,
postcode,
ext_streetaxis.name AS streetaxis,
postnumber,
anl_cause,
anl_tstamp,
anl_user,
anl_descript,
anl_feature_id,
anl_feature_type,
forecast_start,
forecast_end,
cat_users.name AS assigned_to,
exec_start,
exec_end,
exec_user,
exec_descript,
exec_from_plot,
exec_depth,
exec_appropiate,
notified
FROM anl_mincut_result_cat
LEFT JOIN anl_mincut_cat_class ON anl_mincut_cat_class.id = mincut_class
LEFT JOIN anl_mincut_cat_state ON anl_mincut_cat_state.id = mincut_state
LEFT JOIN exploitation ON exploitation.expl_id = anl_mincut_result_cat.expl_id
LEFT JOIN macroexploitation ON macroexploitation.macroexpl_id = anl_mincut_result_cat.macroexpl_id
LEFT JOIN ext_municipality ON ext_municipality.muni_id = anl_mincut_result_cat.muni_id
LEFT JOIN ext_streetaxis ON ext_streetaxis.id = anl_mincut_result_cat.streetaxis_id
LEFT JOIN cat_users ON cat_users.id = anl_mincut_result_cat.assigned_to;

DROP VIEW IF EXISTS v_edit_dqa;
CREATE OR REPLACE VIEW v_edit_dqa AS 
 SELECT dqa.dqa_id,
    dqa.name,
    dqa.expl_id,
    dqa.macrodqa_id,
    dqa.descript,
    dqa.undelete,
    dqa.the_geom,
    dqa.pattern_id,
    dqa.nodeparent,
    dqa.dqa_type,
    dqa.link
   FROM selector_expl,
    dqa
  WHERE dqa.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

  
DROP VIEW IF EXISTS v_edit_presszone;
CREATE OR REPLACE VIEW v_edit_presszone AS 
 SELECT cat_presszone.id,
    cat_presszone.descript,
    cat_presszone.expl_id,
    cat_presszone.nodeparent,
    cat_presszone.the_geom
   FROM selector_expl,
    cat_presszone
  WHERE cat_presszone.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;
  
DROP VIEW IF EXISTS v_edit_macrodqa;
CREATE OR REPLACE VIEW v_edit_macrodqa AS 
 SELECT macrodqa.macrodqa_id,
    macrodqa.name,
    macrodqa.expl_id,
    macrodqa.descript,
    macrodqa.undelete,
    macrodqa.the_geom
   FROM selector_expl, macrodqa
  WHERE macrodqa.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;
  